Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934075AC406
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 12:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiIDKxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 06:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiIDKxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 06:53:08 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E772541992
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 03:53:05 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 06F94C020; Sun,  4 Sep 2022 12:53:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662288784; bh=qcpK6gIOPgU08ol6Aa0Hz7RpXFDdBrA/nrdzgg76Ub0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jWajuPec/Y7YFe+74OKIux1Zd2t180gOyW/FNy1SLFqqdyaCqiPJBb25h11gYMo+U
         Kaf3uL9ifoIR6K2rg+8O4NZ13v0P4Txu6QGMGcN1OZrJm4t8CR0YGbyfWWV9AsD9JJ
         2qvnDsFzG3ac4aHN+8ObW9lExmXrmIVSko4cUY+KA37EeZhnjGzc3oTvOygcQaVo3C
         V1SO5KoOgvd8B17HhvoxWRwASQPBeCKRQp6TqqELQsRK77pzTlgXvbUrlbeP6J8eiE
         TH3uT9kyOfsoAWzlvejbmbJ7zH0y79ltkzaJ05L1RD1q3McU5fzyGbrEIsRaUAGwyV
         tLrUhnCzadPFg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 5A8FEC009;
        Sun,  4 Sep 2022 12:53:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662288782; bh=qcpK6gIOPgU08ol6Aa0Hz7RpXFDdBrA/nrdzgg76Ub0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JLZmADVyD0AvRu9LoksIuDGg+altERdF/lHMA3nhtcMmGTzu9YEXKG0LXzQylWMnc
         upA6ps/JXRpXu8Fw09JHVQbbfQf9oujKoXwOM0bBjKZL9rHCdVv+8ig2cf1/RihBZU
         jl7uJN206sGfCddTpHNv46RD5MSukjre9IWim7QxVqlRQU4N5hK7tkLnS6iYbEys5O
         NB1x+xaIQbtURviqiBKuwZIrG11/A1e8QlTyBrtKBM2ZMQsAG0izkuEAUMRxj+dtIH
         eYNH/EjmAZDbTpv1CB+oGFJl8bABVuhIkZ2MyTWiMaEMagrGHa7bNd71/Q8BK4zWbx
         WCuJS1toBLa1g==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 90536ec9;
        Sun, 4 Sep 2022 10:52:57 +0000 (UTC)
Date:   Sun, 4 Sep 2022 19:52:42 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net/9p: use a dedicated spinlock for modifying IDR
Message-ID: <YxSDeqn4LrSfSaUs@codewreck.org>
References: <YxRZ7xtcUiYcPaw0@codewreck.org>
 <10e6223b-88c2-a377-c238-11c93d4e1afb@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <10e6223b-88c2-a377-c238-11c93d4e1afb@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa wrote on Sun, Sep 04, 2022 at 07:02:04PM +0900:
> > In hindsight it's probably faster to just send a diff... Happy to keep
> > you as author if you'd like, or sign off or whatever you prefer -- I
> > wouldn't have guessed what that report meant without you.
> 
> This diff is bigger than I can guess correctness. Maybe v1 patch should be
> applied as a fix for this problem (because including Reported-by: or Fixes:
> likely makes patches be automatically picked up by stable kernel maintainers
> before syzbot tests for a while) and your patch should be applied as an improvement
> (i.e. omit Reported-by: and Fixes: ). You can manually request for inclusion into
> stable kernels after syzbot tested for a while.

Hmm. The diff is bigger but the change really is equivalent: that
client->lock is only ever used in client.c and trans_fd.c, you replaced
all the occurences in client.c (3 locations + init) while I replaced all
the occurences in trans_fd.c (6 locations + init); the end result is
the same of splitting the two locks exactly at the same place; as far as
correctness goes the patches are identical.

The diff is a bit bigger but the result is more maintainable, and both
versions would require trivial context adjustments to backport anyway
because of bd873038aed5 ("net/9p: allocate appropriate reduced message
buffers") which conflict with either version...
I don't think this warrants the overhead of splitting the patch; sorry.

(and anyway Sasha Levin's autopicker seems to pick almost everything 9p,
said bd873038aed5 was backported down to 5.15 so these will have
backport for free on either version)



Back on topic, assuming you don't strongly oppose to keeping my version,
what tags should I add to the patch?
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
undersells your work, but I don't want to add something like
Co-authored-by without your permission.


Thanks,
--
Dominique
