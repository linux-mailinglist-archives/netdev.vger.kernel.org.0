Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33A235B86C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 04:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbhDLCMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 22:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLCMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 22:12:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D590C061574;
        Sun, 11 Apr 2021 19:11:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id i4so5826561pjk.1;
        Sun, 11 Apr 2021 19:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HrLSrYH4xBjuha0oEZJ32zfpXue79TxDMF6euyStLuo=;
        b=jif8JxTUPmxJ6EoYqfuzKJXvriggHyorchGhg9qzXlchT3SX69DWKQzBbxivySEbc9
         egnVQfK8PWwZh7NZ62Lau9/ktdg43P3V3UVZt3hgRga3+W0P/PVWtT9sfHiBBrLtI+XK
         rc+v/4PuT9IkIslA1UpYCLNyN+210prsOalhGnlX/IA0i7Vjoy8789Lx1ugmk02cDU0c
         Zqkt3qFAtasaKV612SO9bLgeb6hoXPP4KZBBIotC1Vhs6k5QlrUptGJke0aGroKq2sYz
         uNo+mGOr4cTPzQDBEz/lzAPTLjW1htMQfv5h0ZoEnUcl7MNo+KQ+TiLTbdZIuf1qD9+0
         S5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HrLSrYH4xBjuha0oEZJ32zfpXue79TxDMF6euyStLuo=;
        b=CpGZFJLx1gIOvAKK2fWXV5xbFbhyzeDmeodir4KNl+DJ94mD6yxFXO0tq/3qLCdqP4
         RcZvwCE8ND4TnahnJ6NTWHEDpj/x3wCCQCMMfB3mo0oS1wXY2ToJuIWDqNzR0fdb4RoH
         3pTnw1yLYFrUSD0w1bp11RXmUAGCMJChEybGFpM+TQaMMKSi0cheGfHogdPyWcHTnn16
         l7cYfw7QudAluoSuMkI6WRWpcRBXvB1E5XdRnTV4dbIIMQOUWsWdxEvy5ts2DjB9z0mS
         UjQ15m4Dn0Dz9E/EzBlNKpGTHodCYN2Xr/2ITxDZvjNsVYvZ/RvVmjxpnODNQsWYnFNZ
         818A==
X-Gm-Message-State: AOAM532t5w49sf6oq9RIqxXbYdz9ddZ/bNZtuN6fPadqKC5hTMq6cvBV
        Wlrx9D+cB2ef8DpQMniABfMI4jhKO76KFw==
X-Google-Smtp-Source: ABdhPJzRIFtiYugnxn1AH06w/cohmy8TA4qh4ZVJCz+7xHlfzuaIxrRxszDLjEbjqQCBLPIaUy5Aww==
X-Received: by 2002:a17:90b:16cd:: with SMTP id iy13mr27283178pjb.46.1618193516172;
        Sun, 11 Apr 2021 19:11:56 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o18sm8996909pji.10.2021.04.11.19.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 19:11:55 -0700 (PDT)
Date:   Mon, 12 Apr 2021 10:11:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210412021144.GP2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain>
 <20210408010640.GH2900@Leo-laptop-t470s>
 <20210408115808.GJ2900@Leo-laptop-t470s>
 <YG8dJpEEWP3PxUIm@sol.localdomain>
 <20210409021121.GK2900@Leo-laptop-t470s>
 <7c2b6eff291b2d326e96c3a5f9cd70aa4ef92df3.camel@chronox.de>
 <20210409080804.GO2900@Leo-laptop-t470s>
 <CAHmME9o53wa-_Rpk41Wd34O81o34ndpuej0xz9tThvqiHVeiSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9o53wa-_Rpk41Wd34O81o34ndpuej0xz9tThvqiHVeiSQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 12:29:42PM -0600, Jason A. Donenfeld wrote:
> On Fri, Apr 9, 2021 at 2:08 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > After offline discussion with Herbert, here is
> > what he said:
> >
> > """
> > This is not a problem in RHEL8 because the Crypto API RNG replaces /dev/random
> > in FIPS mode.
> > """
> 
> So far as I can see, this isn't the case in the kernel sources I'm
> reading? Maybe you're doing some userspace hack with CUSE? But at
> least get_random_bytes doesn't behave this way...

> > I'm not familiar with this code, not sure how upstream handle this.

Hi Jason,

As I said, I'm not familiar with this part of code. If upstream does not
handle this correctly, sure this is an issue and need to be fixed.

And as Simo said, he is also working on this part. I will talk with him
and Herbert and see if we can have a more proper fix.

Feel free to drop this patch.

Thanks
Hangbin
