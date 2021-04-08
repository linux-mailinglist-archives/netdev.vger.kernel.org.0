Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD3935828D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDHL6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHL6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:58:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915FAC061760;
        Thu,  8 Apr 2021 04:58:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so3054449pjb.0;
        Thu, 08 Apr 2021 04:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jXH6y4YscxSeRR8s6JzgRu1L9W547REVPRiKHGjiNIY=;
        b=AEkfymwhHejmj+SuWnfpyqSAcs38c+KHpcEFLT1SWYEww/z+pWc3bgh7wdO16/whqc
         ueWd4yQNLE+nzlLLGR44cBKWCBBR20LwOxoJzJ8HiUnMfbnSbAtU5Dikoy2EwOwp0Ows
         MP11DIQ3jh5JzldBnlnohBK+h4EkQ9kg5GRQsYF9d9nBYzd3ZKR0qFS7WQ28tWpSaSjV
         3hQr3BRYwHAJZP1hNFST6HbMPN9ICX1St20knxO0ATCGV0dR4SiX1N2oQDRElnsdEBDl
         rzKF/Thb8+bY0Tgu5I9k37zGzBRw7keb5FSEmJTsG1hl4gEobFxJL8/qfWu6p1Z3g25S
         SNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jXH6y4YscxSeRR8s6JzgRu1L9W547REVPRiKHGjiNIY=;
        b=dhyhUMhY15PBXi2tBpv3NdwoZcAXYJqNZ9WRjqrdw8udBSBGrX7BON6k7BMZwft1vM
         OMtUaVuAaCERCU6Zdz0RcAkuC3I/ehnbyZ9f11HaD9PQK18YFKa3slpRv/AoU837t2cV
         lsfscEaUvlswb3D3xYColZgqeaJMKLzcZIlgo4jHdLChUJ1jT6VbLUvKCi9Qc9qxrbXe
         PfNx0r/8HkVhSn3s5IDKNcGRrv5FPGZeIMy08cZMEDnigFO0vdiVGkiKBefJQznarsmI
         96ykrLz15fZnDk4VuomiUM7H/H9DZzuCKiAxa2Lu8EgQyzWwE3MnM4T3ltrqvnYKmD03
         9Jww==
X-Gm-Message-State: AOAM531XCLWnCvg/T02ODWipu1Ho1iTGtMvJymPG1+nHwcss/H8pYDAb
        521MKTQa7DuuS/rP4ci1Aej9d7IjY61sdg==
X-Google-Smtp-Source: ABdhPJy+VZmkfEmzWiCs3m+xMSnafBHyXgL5Fv/HA7IG4QhkD5ZszMGt+N0tlgsnHJkgdL+dSia0DA==
X-Received: by 2002:a17:90b:3b4e:: with SMTP id ot14mr1538820pjb.81.1617883100222;
        Thu, 08 Apr 2021 04:58:20 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22sm8154138pjl.31.2021.04.08.04.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 04:58:19 -0700 (PDT)
Date:   Thu, 8 Apr 2021 19:58:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210408115808.GJ2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain>
 <20210408010640.GH2900@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408010640.GH2900@Leo-laptop-t470s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 09:06:52AM +0800, Hangbin Liu wrote:
> > Also, couldn't you just consider WireGuard to be outside your FIPS module
> > boundary, which would remove it from the scope of the certification?
> > 
> > And how do you handle all the other places in the kernel that use ChaCha20 and
> > SipHash?  For example, drivers/char/random.c?
> 
> Good question, I will check it and reply to you later.

I just read the code. The drivers/char/random.c do has some fips specific
parts(seems not related to crypto). After commit e192be9d9a30 ("random: replace
non-blocking pool with a Chacha20-based CRNG") we moved part of chacha code to
lib/chacha20.c and make that code out of control.

Thanks
Hangbin
