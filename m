Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDEF2B6AD9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgKQQ6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgKQQ6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:58:35 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D3DC0613CF;
        Tue, 17 Nov 2020 08:58:33 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so30401659ejb.7;
        Tue, 17 Nov 2020 08:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ugxCgHtx60hb2w7JVXNEa59aQyV6GuKLKOg4Q4dz6cU=;
        b=QEhIAgU/gUsGNFWJr2jS9qLUBaN7eYqfRz2nHduAKqkPegvEpLD/SDRmQv5wuyrwlx
         wgO4maTnU1sWd4AjqcbctkKyW1WhB1vRtGDTBUzubAcgTS+DucIKhCf66sNCn6+VYDek
         W+hi67sh2zShGlpAdGgsO8EVnlsdzuWZPEGfiHKPhPjn2+gJBlaumWFBsJS5mG+kqFCK
         gq0P4K7ghWXzkK8wdZ/pwZfW/WPmgFIqjPk89R7Zq5Sh5Pkfa8ExRT9/q4FJXE/CcpPK
         CQITLH4ev96wAkfe5oe86uY6h3KM8pDSforr2qBIqAtAgibVYZ1cKF18BaVCge8HFwtf
         EJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ugxCgHtx60hb2w7JVXNEa59aQyV6GuKLKOg4Q4dz6cU=;
        b=S6wGTfjc+uqEAzos+dTgU286173lF3DCQV1qLca99pAQJpZSrXFKZ8PHX5CtF7Vbwa
         kXbDpeyV3kcioresBQpOPK8noDNS2/HWtv9+uU5mIyMip8FoGpYmYGFAFjetmKa6afIM
         En2IXjtFCt9pTdkUGb8/Sp1Mmrpl1Ukja/jzJd60LVaLrmjNyv8d719PGkjDQRKevyi6
         Qnf9vTinKOVR4tqYJsEuZ9lWOQIqs1mzhndW4gKVwrsIq07Enm7jKK3uH3IZvqHz+85e
         6ZY9kmoRt1eCyEaOCIQ1ujLZXBGxFFkNUfSPJM/YWU2Pq9jSYPQVLPoDx2OTnIPyoHjB
         8Ytg==
X-Gm-Message-State: AOAM531VTau+I2hz7LtXthRTcveKUICh9eTWVOoYrYJDmI/DcyxlYLiX
        uixU/PLUYxjDt7a0qk4XMzNCnraasMk=
X-Google-Smtp-Source: ABdhPJyyYRDEkiI3PG2Bsd8EKSkDmMLh0WfJpQLkhgokLsuuYkGF+rXPKNGiabDXMY65xfihg6fdVw==
X-Received: by 2002:a17:906:2e08:: with SMTP id n8mr21467527eji.440.1605632312204;
        Tue, 17 Nov 2020 08:58:32 -0800 (PST)
Received: from ltop.local ([2a02:a03f:b7fe:f700:ec88:97fa:6d80:7ccf])
        by smtp.gmail.com with ESMTPSA id s20sm11957919edw.26.2020.11.17.08.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 08:58:31 -0800 (PST)
Date:   Tue, 17 Nov 2020 17:58:30 +0100
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH net-next] net: add annotation for sock_{lock,unlock}_fast
Message-ID: <20201117165830.e44pu3nd5vx3jzmz@ltop.local>
References: <95cf587fe96127884e555f695fe519d50e63cc17.1605522868.git.pabeni@redhat.com>
 <20201116222750.nmfyxnj6jvd3rww4@ltop.local>
 <a41e88a82b4d7433dded23e9fbd0465ad8529e36.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a41e88a82b4d7433dded23e9fbd0465ad8529e36.camel@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 09:38:45AM +0100, Paolo Abeni wrote:
> Hello,
> 
> Thank you for the feedback!
> 
> On Mon, 2020-11-16 at 23:27 +0100, Luc Van Oostenryck wrote:
> > > @@ -1606,10 +1607,12 @@ bool lock_sock_fast(struct sock *sk);
> > >   */
> > >  static inline void unlock_sock_fast(struct sock *sk, bool slow)
> > >  {
> > > -	if (slow)
> > > +	if (slow) {
> > >  		release_sock(sk);
> > > -	else
> > > +		__release(&sk->sk_lock.slock);
> > 
> > The correct solution would be to annotate the declaration of
> > release_sock() with '__releases(&sk->sk_lock.slock)'.
> 
> If I add such annotation to release_sock(), I'll get several sparse
> warnings for context imbalance (on each lock_sock()/release_sock()
> pair), unless I also add an '__acquires()' annotation to lock_sock(). 
> 
> The above does not look correct to me ?!? When release_sock() completes
> the socket spin lock is not held.

Yes, that's fine, but I suppose it somehow releases the mutex that
is taken in lock_sock_fast() when returning true, right?

> The annotation added above is
> somewhat an artifact to let unlock_sock_fast() matches lock_sock_fast()
> from sparse perspective. I intentionally avoided changing
> the release_sock() annotation to avoid introducing more artifacts.
> 
> The proposed schema is not 100% accurate, as it will also allow e.g. a
> really-not-fitting bh_lock_sock()/unlock_sock_fast() pair, but I could
> not come-up with anything better.
> 
> Can we go with the schema I proposed?

Well, I suppose it's a first step.
But can you then add a '__releases(...)' to unlock_sock_fast()?
It's not needed by sparse because it's an inline function and sparse
can then deduce it but it will help to see the pairing with
lock_sock_fast() is OK.

-- Luc
