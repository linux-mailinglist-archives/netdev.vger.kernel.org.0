Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3115AC1BF
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 01:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiICXku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 19:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiICXkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 19:40:49 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BA45006F;
        Sat,  3 Sep 2022 16:40:22 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8170FC020; Sun,  4 Sep 2022 01:40:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662248419; bh=Zb9XsnnNwueUjSy+hlSu1JgZEiThAH1fGuYBaT0Yg/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXh0DE6iRXCMpLTLHBDxKaMrfPdmAG+fS5+9nYIVpLT8flPEShAoU5yb203+Z/tVC
         WRD1d4s1Wk11rGi1o076HKX7p7hiyViNa9q4m09W9kYzxRoyw2N49R72TrEpAujh1j
         tgswKIZuDQrDZMiyYm3hlp0/qNgP5H2qJis9gall2OVAknEZPf4pqHFdliEyev/0ag
         /TJSCYBGEZgLH3AhOq+zEQLhFV/LXYbV1zTCfhTj5ZKaOusQWwIZC8oCw+MGLEL8tg
         7lwAhxO2S2XNAezWkvch3H7mzNo9HsNWd3tZXI58U3S39pcEkn3ZOrWmE2e4eMr1Ab
         /FpOxPdMaMVrQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0A14CC009;
        Sun,  4 Sep 2022 01:40:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662248418; bh=Zb9XsnnNwueUjSy+hlSu1JgZEiThAH1fGuYBaT0Yg/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCUr0GxKn41SI9WAWgnpiq1VN7rfyxo03hjwIlDDBU7jdGotYknViNGESJReHs39O
         9S9vgUz4s6EizgsvXcbgrUO9bTdg67PRC6moqLk8qk7aRmF0mBmLUY+j37zlZOQOsE
         BuMl2YQcUnsoB9D/QlkH91dqKI3B741lmIiy48RsJwC1EUSK6Cosp7Ll1gMmyTGAT8
         d24AbeJpL5cIMGpw4TKCVN22Ur2gC3VVOubJepZH5/aF1V7mZgwWh/6NOKBlxKHtx2
         KJZIBh5elyLjb24e1UzndgbUs3ycXnHYBhacyUTGWljR5soOzxPDWNKnfAxOtCywmv
         I/c1BKgadyJ8g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f293b310;
        Sat, 3 Sep 2022 23:40:13 +0000 (UTC)
Date:   Sun, 4 Sep 2022 08:39:58 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] 9p/trans_fd: perform read/write with TIF_SIGPENDING
 set
Message-ID: <YxPlzlJAKObm88p8@codewreck.org>
References: <00000000000039af4d05915a9f56@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
 <4293faaf-8279-77e2-8b1a-aff765416980@I-love.SAKURA.ne.jp>
 <69253379.JACLdFHAbQ@silver>
 <e96a8dce-9444-c363-2dfa-83fe5c7012b5@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e96a8dce-9444-c363-2dfa-83fe5c7012b5@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch and sorry for the slow reply

v1 vs v2: my take is that I think v1 is easier to understand, and if you
pass a fd to be used as kernel end for 9p you shouldn't also be messing
with it so it's fair game to make it O_NONBLOCK -- we're reading and
writing to these things, the fds shouldn't be used by the caller after
the mount syscall.

Is there any reason you spent time working on v2, or is that just
theorical for not messing with userland fd ?

unless there's any reason I'll try to find time to test v1 and queue it
for 6.1

Tetsuo Handa wrote on Fri, Sep 02, 2022 at 07:25:30AM +0900:
> On 2022/09/02 0:23, Christian Schoenebeck wrote:
> > So the intention in this alternative approach is to allow user space apps  
> > still being able to perform blocking I/O, while at the same time making the 
> > kernel thread interruptible to fix this hung task issue, correct?
> 
> Making the kernel thread "non-blocking" (rather than "interruptible") in order
> not to be blocked on I/O on pipes.
> 
> Since kernel threads by default do not receive signals, being "interruptible"
> or "killable" does not help (except for silencing khungtaskd warning). Being
> "non-blocking" like I/O on sockets helps.

I'm still not 100% sure I understand the root of the deadlock, but I can
agree the worker thread shouldn't block.

We seem to check for EAGAIN where kernel_read/write end up being called
and there's a poll for scheduling so it -should- work, but I assume this
hasn't been tested much and might take a bit of time to test.


> The thread which currently clearing the TIF_SIGPENDING flag is a user process
> (which are calling "killable" functions from syscall context but effectively
> "uninterruptible" due to clearing the TIF_SIGPENDING flag and retrying).
> By the way, clearing the TIF_SIGPENDING flag before retrying "killable" functions
> (like p9_client_rpc() does) is very bad and needs to be avoided...

Yes, I really wish we could make this go away.
I started work to make the cancel (flush) asynchronous, but it
introduced a regression I never had (and still don't have) time to
figure out... If you have motivation to take over, the patches I sent
are here:
https://lore.kernel.org/all/20181217110111.GB17466@nautica/T/
(unfortunately some refactoring happened and they no longer apply, but
the logic should be mostly sane)


Thanks,
--
Dominique
