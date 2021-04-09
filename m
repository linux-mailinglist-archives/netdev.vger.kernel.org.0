Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6260635972E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhDIII3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhDIII2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 04:08:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CD7C061762;
        Fri,  9 Apr 2021 01:08:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so4574313pji.5;
        Fri, 09 Apr 2021 01:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CMMJZPbp0MgRCMvfRE+uOWyBauUtpDGlrFmT7fkYW5k=;
        b=nvHD9vcMQbQp7dZO1Z+Ko7EQPvJWFmilvnpnanwZ9FIql68hLtZK8ScyvHR4390nHQ
         ZbEfPaCGYv7VQckx5EqMpTZRTcJuEdMaUcSkA3kQkjWyushgnoKCn3yiw0xFmhaPi0Vq
         m5qQyzPxK7PYrv9BLFU2cpU4xvdqrP7P3OUPaEgRFXFdFfECOddW/akbrycr4hLf2bpt
         S4Sx4af9qWnRfthw6RoW9msrmZ/ah64mqYj7tNFkWMSnTu+/DiLquhM3IYVvLnPyMeMk
         Zpsc682rWOLFH6ubqoZJmZIHGEP+hiI4SBT0iAH5YFVGoZMFuCznqR95tMCv2mmxZXNi
         pYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CMMJZPbp0MgRCMvfRE+uOWyBauUtpDGlrFmT7fkYW5k=;
        b=lo0PC6/wLQ6SNAvtCUOWUVcl3W8H8jrvUMmfab+6t6s+PivSytOI7fXF8UXhA9z+Mu
         S2hVaAcgzjU3O0MqAmHNoF7Myp06g9jtBIh31MqyZKpVAq/qAgseMGoj3EQdpM2i82/H
         AKYhta10YSX2R/Eo49GLqT9lyki55XOgWzGCig+atriSDOOitbhTERK+aWrOWarvJQbp
         QVWwd9W7LWYRzcuKZwq2XSMyWwwr3kbH1wZvdpGuJryX3podCBhEjIWyOE+4m8iOEXAc
         ljLqlyCAjC6xw9Q92igTGB6v+5GmRjK4iIhLCsVW5XCyY5AmLQje5tfckDOKPqSt9rS3
         kGpA==
X-Gm-Message-State: AOAM531O9NLVQ2r2LALzOBL7j/IbJ+ps06lhAEq8TylhSkNHm52ffHe/
        9+RDkUCE5kmkiHFzqiCmtJs=
X-Google-Smtp-Source: ABdhPJz6OQD16FR58rvd/ZRtffFAZOG9W1XY/kKLxN798BlIPp3zjrZAHxadbOovOTHGnUwWeH3B3A==
X-Received: by 2002:a17:902:f687:b029:e8:da63:6195 with SMTP id l7-20020a170902f687b02900e8da636195mr11850895plg.75.1617955695735;
        Fri, 09 Apr 2021 01:08:15 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s6sm1414618pfw.96.2021.04.09.01.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 01:08:15 -0700 (PDT)
Date:   Fri, 9 Apr 2021 16:08:04 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210409080804.GO2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain>
 <20210408010640.GH2900@Leo-laptop-t470s>
 <20210408115808.GJ2900@Leo-laptop-t470s>
 <YG8dJpEEWP3PxUIm@sol.localdomain>
 <20210409021121.GK2900@Leo-laptop-t470s>
 <7c2b6eff291b2d326e96c3a5f9cd70aa4ef92df3.camel@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c2b6eff291b2d326e96c3a5f9cd70aa4ef92df3.camel@chronox.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 09:08:20AM +0200, Stephan Mueller wrote:
> > > > > > And how do you handle all the other places in the kernel that use
> > > > > > ChaCha20 and
> > > > > > SipHash?  For example, drivers/char/random.c?
> > > > > 
> > > > > Good question, I will check it and reply to you later.
> > > > 
> > > > I just read the code. The drivers/char/random.c do has some fips
> > > > specific
> > > > parts(seems not related to crypto). After commit e192be9d9a30 ("random:
> > > > replace
> > > > non-blocking pool with a Chacha20-based CRNG") we moved part of chacha
> > > > code to
> > > > lib/chacha20.c and make that code out of control.
> > > > 
> > > So you are saying that you removed drivers/char/random.c and
> > > lib/chacha20.c from
> > > your FIPS module boundary?  Why not do the same for WireGuard?
> > 
> > No, I mean this looks like a bug (using not allowed crypto in FIPS mode) and
> > we should fix it.
> 
> The entirety of random.c is not compliant to FIPS rules. ChaCha20 is the least
> of the problems. SP800-90B is the challenge. This is one of the motivation of
> the design and architecture of the LRNG allowing different types of crypto and
> have a different approach to post-process the data.
> 
> https://github.com/smuellerDD/lrng

Thanks Stephan for this info. After offline discussion with Herbert, here is
what he said:

"""
This is not a problem in RHEL8 because the Crypto API RNG replaces /dev/random
in FIPS mode.
"""

I'm not familiar with this code, not sure how upstream handle this.

Thanks
Hangbin
