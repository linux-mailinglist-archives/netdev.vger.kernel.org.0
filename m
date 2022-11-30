Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D627E63D6D1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiK3NfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiK3NfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:35:21 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF6549B41;
        Wed, 30 Nov 2022 05:35:20 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 002A0C022; Wed, 30 Nov 2022 14:35:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669815328; bh=DFwsM28ZAHCOTIWVrHbYM9F79eW1XgktjNJ3t+S8qmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ese4d+HxKUGOiU4QD65t7NG6Z4sCJZf10F3wchc91Fq9HPlJhbVIZMGTzlUsVlhUu
         NoAhoAnZB1j2YmDfxG9S/Aim3wtPrAHz351+by/Ez4o+L9sGb/M/n1E8yVjw1wMLkc
         68m2CV6QHJyWCNXepX52bddhbIveqyHWCTyxXgevRkjnx1Yu6NflsngUtf1VTYxbWi
         G4W7wfGNTaPffna9RukcFVQ57M2ln2xR+S+cKVW93G1CFPHICbO0hu3/b9Pbm4O8eg
         HhQ7ABBmpxsimlkpiGkiwDJfmDtitiLKLFAExvGAPKtBtwnotjos/LBFV953/VUaSw
         Xzw46zF4i9AtA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 71FA0C009;
        Wed, 30 Nov 2022 14:35:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669815327; bh=DFwsM28ZAHCOTIWVrHbYM9F79eW1XgktjNJ3t+S8qmY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XX/+Zwid75/ISSCwteyg/2Q9TG/nlh9pPNpdO+rsCMcRWMSu0+zYcm2WJhYJufH1k
         nInYUSTNJBUn/O/AVu8b3MzvpRD/eRX3dHbQies9FT3PrHSt85oHaHFcsB1U1Kg69i
         ipgvIDqUQvLP7Uo+vydLiS/SW/JDKetM+eMYQWFwvJYBHIaBmW8AYGnTTFgvDUiqG3
         u1wyOL/YBCy9sUgawBHx+zDwHEvtIVGXccnOmBa8bR7y7D47jUJX6N5OWKfEZhNBeA
         A+9sWAkaMWpn1YvrqyETu9NpsVE2xZNTDdXDnCXuYvB3HS7gVw9ML8zoO5on7gIJq8
         SwQF8VS61u00A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 24854f8a;
        Wed, 30 Nov 2022 13:35:11 +0000 (UTC)
Date:   Wed, 30 Nov 2022 22:34:56 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Message-ID: <Y4dcAGM+0xzOgSCa@codewreck.org>
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org>
 <m2r0xli1mq.fsf@gmail.com>
 <Y4b1MQaEsPRK+3lF@codewreck.org>
 <m2o7sowzas.fsf@gmail.com>
 <Y4c5N/SAuszTLiEA@codewreck.org>
 <m2a6487f23.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m2a6487f23.fsf@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schspa Shi wrote on Wed, Nov 30, 2022 at 09:15:12PM +0800:
> >> If the req was newly alloced(It was at a new page), refcount maybe not
> >> 0, there will be problem in this case. It seems we can't relay on this.
> >> 
> >> We need to set the refcount to zero before add it to idr in p9_tag_alloc.
> >
> > Hmm, if it's reused then it's zero by definition, but if it's a new
> > allocation (uninitialized) then anything goes; that lookup could find
> > and increase it before the refcount_set, and we'd have an off by one
> > leading to use after free. Good catch!
> >
> > Initializing it to zero will lead to the client busy-looping until after
> > the refcount is properly set, which should work.
> 
> Why? It looks no different from the previous process here. Initializing
> it to zero should makes no difference.

I do not understand this remark.
If this is a freed request it will be zero, because we freed the request
as the refcount hit zero, but if it's a newly allocated request then the
memory is uninitalized, and the lookup can get anything.

In that case we want refcount to be zero to have the check in
p9_tag_lookup to not use the request until we set the refcount to 2.


> > Setting refcount early might have us use an re-used req before the tag
> > has been changed so that one cannot move.
> >
> > Could you test with just that changed if syzbot still reproduces this
> > bug? (perhaps add a comment if you send this)
> >
> 
> I have upload a new v2 change for this. But I can't easily reproduce
> this problem.

Ah, I read that v2 as you actually ran some tests with this, sorry for
the misuderstanding.

Well, it's a fix anyway, so it cannot hurt to apply...
-- 
Dominique
