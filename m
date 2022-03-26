Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8E44E80CC
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiCZM0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiCZM0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:26:13 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44594292BB4;
        Sat, 26 Mar 2022 05:24:36 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id CB5B4C021; Sat, 26 Mar 2022 13:24:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648297473; bh=J+rWcnu8yF7moh054Aw+8XHr3g7eD83siDQ/MkyTBjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fMGFh1uJbcJcldQgmnJxIll8S+FwMV8Yav7DYp0Ttu8UGPN0eWvmzuI3WXZmxJDed
         KcNdXofmrYQdnymnzjU/Xltw6xG8gZ08wTHYsJ2ko+Kvr9I6nPHIq8WAs+BZFV/fgx
         ngpduVyNJvXiDcX5Bx1LQaDboa/g6T6Uyv/XxR6Uu5dyi+6uiQEk5nR+0l9KGxB6NL
         0tlEUOE1841SaECbJ1VnWOItVEiFqcpBpZe1ReTj8SqCocJqd0GnLgkmPviq1maSNx
         L8Lmds4tH7eovs/GPa//YYaes9YGnhKLgMLXd6wSJWp18ODxDqUusJsmd5eRFTyr0G
         AnojQo6SajdHg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C07DCC009;
        Sat, 26 Mar 2022 13:24:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648297472; bh=J+rWcnu8yF7moh054Aw+8XHr3g7eD83siDQ/MkyTBjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bp2S0TjOym2RriaIq4Q1XLf+Az7nE22NgnsSp9Ixsfwed0OtIMB2UrLt2wm+8Cxfd
         y/2CPT2Ah6NIRetxdVwix0c0l7Ava30y1r9eXbhIztXaFF93xDJqVh8Ay9NuVXtDqC
         FKZ12TmjWf7EvNH0A3ZPR+tHbwsnrfy05WGCYeWe3Epdokk43fIQC4YjpM2/nOu8hG
         Z5hboCFi/GSpfu8hJfkgol0EeL4axCfzEvGTfBKTLuj3KBm5rSOd9oOedhr4yko8pV
         1OyLgdx9e3ErzM+pPBStOFFNor9sU/FMwqKjsHTPbG9Bq1CdVfDf1FWkt0j1u9WvwF
         thne8LKrDEvxg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 1cc6f6ba;
        Sat, 26 Mar 2022 12:24:25 +0000 (UTC)
Date:   Sat, 26 Mar 2022 21:24:10 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net,
        syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com
Subject: Re: [syzbot] WARNING in p9_client_destroy
Message-ID: <Yj8F6sQzx6Bvy+aZ@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3597833.OkAhqpS0b6@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3597833.OkAhqpS0b6@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sat, Mar 26, 2022 at 12:48:26PM +0100:
> [...]
>
> > Signed-off-by: David Kahurani <k.kahurani@gmail.com>
> > Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com

Looks good to me - it's pretty much what I'd have done if I hadn't
forgotten!
It doesn't strike me as anything critical and I don't have anything else
for this cycle so I'll just queue it in -next for now, and submit it
at the start of the 5.19 cycle in ~2months.

> I'm not absolutely sure that this will really fix this issue, but it seems to 
> be a good idea to add a rcu_barrier() call here nevertheless.

Yeah, I'm not really sure either but this is the only idea I have given
the debug code doesn't list anything left in the cache, and David came
to the same conclusion :/

Can't hurt though, so let's try and see if syzbot complains
again. Thanks for the review!

-- 
Dominique
