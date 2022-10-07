Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B35F7290
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 03:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiJGBky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 21:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiJGBkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 21:40:52 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05208A4874;
        Thu,  6 Oct 2022 18:40:51 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 85248C020; Fri,  7 Oct 2022 03:40:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1665106849; bh=rzoBfsAiCdEWZQ20WCaCW3PZC2FVyXXDBzt8MmnFLEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXpSDetbKGqvRvd3qmLOF2C2HLYQ5r5IFfpIKb9JQMZ65k3L9xxAGgRIPChT4vRX5
         UpqY1f080hL8BUWwivmThmEbtlLXunQrbvX78eyw8vtoxTYAJaH1Fv2DwvY0s7i7kc
         WHEN8NbB7DkPnn1V8xfboBc2n5gzqVr8fOYGufKlOx3fp4QtKFnoRtIQEMHf4rt++Q
         A8solBbRy+pldK9SJc6RT0rKbwUTgN7DyJwRgalj2PN+4KIo8SSw6g1ISJRuMCt3ms
         pJ2VDHYigwxvclJJwgPrpWZEbbieTg4rXK54B5LDXHL89aj0gPr6P88745BRnVmSeL
         ih+McuJgH16/A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 14BF6C009;
        Fri,  7 Oct 2022 03:40:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1665106848; bh=rzoBfsAiCdEWZQ20WCaCW3PZC2FVyXXDBzt8MmnFLEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lG/j5Hy41YweyC74PFrJP4/crGLUSOa5BMJbxgJ3I5Ly6Qfa3KZMoLuVV17hvKzMA
         W9mn/2gismC43drGOrsegXOqEoGQyIfKV9gBy5vl5B8OWKB2WmHnw3hwJsTAiAxu0c
         ku4cHwyp8yUuo/dYiBj+lq2Q2eV5CuHcvUQoFGldBHhyUPUWtNLJDpvOUz/UOERQOg
         6Jp2wLU2Ogz78EUC7Nvd6IbygR8Xq7SXQFeQtII4qiSY87o0QRhRo/gmMC1h92DEFT
         R09SBdhD5YlcV9SKn7Z2QKLtVeHpZ4Tc+RPKmONracCekA7SL2omodZaEkF2O0Axz/
         xGTg8Txpqa3QQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id e4b8ba3e;
        Fri, 7 Oct 2022 01:40:42 +0000 (UTC)
Date:   Fri, 7 Oct 2022 10:40:27 +0900
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
Message-ID: <Yz+Di8tJiyPPJUaK@codewreck.org>
References: <00000000000039af4d05915a9f56@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
 <4293faaf-8279-77e2-8b1a-aff765416980@I-love.SAKURA.ne.jp>
 <69253379.JACLdFHAbQ@silver>
 <e96a8dce-9444-c363-2dfa-83fe5c7012b5@I-love.SAKURA.ne.jp>
 <YxPlzlJAKObm88p8@codewreck.org>
 <38d892bd-8ace-c4e9-9d73-777d3828acbc@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38d892bd-8ace-c4e9-9d73-777d3828acbc@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa wrote on Sun, Sep 04, 2022 at 09:27:22AM +0900:
> On 2022/09/04 8:39, Dominique Martinet wrote:
> > Is there any reason you spent time working on v2, or is that just
> > theorical for not messing with userland fd ?
> 
> Just theoretical for not messing with userland fd, for programs generated
> by fuzzers might use fds passed to the mount() syscall. I imagined that
> syzbot again reports this problem when it started playing with fcntl().
> 
> For robustness, not messing with userland fd is the better. ;-)

By the way digging this back made me think about this a bit again.
My opinion hasn't really changed that if you want to shoot yourself in
the foot I don't think we're crossing any priviledge boundary here, but
we could probably prevent it by saying the mount call with close that fd
and somehow steal it? (drop the fget, close_fd after get_file perhaps?)

That should address your concern about robustess and syzbot will no
longer be able to play with fcntl on "our" end of the pipe. I think it's
fair to say that once you pass it to the kernel all bets are off, so
closing it for the userspace application could make sense, and the mount
already survives when short processes do the mount call and immediately
exit so it's not like we need that fd to be open...


What do you think?

(either way would be for 6.2, the patch is already good enough as is for
me)
--
Dominique
