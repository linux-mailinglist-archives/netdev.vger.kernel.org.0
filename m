Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD635794C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 03:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhDHBHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 21:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhDHBHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 21:07:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ED0C061760;
        Wed,  7 Apr 2021 18:06:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ha17so237856pjb.2;
        Wed, 07 Apr 2021 18:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wilm16Ub8BB1XoT4ev+bET2RH1JL/eiAqerv1Ew7RoM=;
        b=nvSTKc5PujztH5rKuQaDnnYjuR/107vkLSvjfbXWnXH0+3vlmNO4WUyh+ZViotytIB
         wy9cKH7J8PrNRSNMEz2m9/6aIG8trf5YgdqRFBPS4agxPOWGVcdOBxeHdTo+jWDRVMFE
         ifSfvWpUPSTZN8wpleooC+eqaOdI/nuTHncyBiinrCPDFOzPRMhdFoa2wopUBGbJEIGF
         iySY7agK0k+urzIQTscqpWJK4LVyM/eWY1DAx1flaYedjLt8/jmnET7r9MiYBJcCTb25
         KKzerHpVAvk6zm5NTBVBJq+FDSXxugMXVmnMjAH7ImFUJwjFdh9dH/jgEl+XWZ74nPsz
         jqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wilm16Ub8BB1XoT4ev+bET2RH1JL/eiAqerv1Ew7RoM=;
        b=EL6RYUdBiyQ+ffbcRUbDj4i73crRnI0bQaaTJJ8Ka6HnjK5NiZBWCjvvSkRHPvUGJY
         wd0Bbm15KVY85lxuIcfYsrEuHC2LBqNoOGJ4P8zUPeYHKGyT/UfU9kkfXQwavXUH9g8b
         P1eCBdFkI5iLVnlJG7VfQ7Kb3gpoVF82/batYk2gbPvg45DrObQtZm8fDzm+gYhPVU8Q
         4gR1hoTba969BaeJNbXPLZuy/zuA+TIQQ62n4qtBD5pLfT7aDuwcsGVZcJzLApXNVjeI
         7kwKceJlqECJBaaAH7iMYHmalWLAOPFM7r0v6MtKekeGFARqXd/b3nfOF3VLzv7wUTCK
         RYkg==
X-Gm-Message-State: AOAM532tfAGiFrcqT03jcJ2WrisljT0hOykz4wEEIQz91mfps3py8Kt/
        Pdp31HPlMGexWsHedzr06zw=
X-Google-Smtp-Source: ABdhPJz5YV8kgLhUcjjLJDQLLyLHx53mfRkqMU4z/LR7KyArIJGVyBnMxzxwAZ20yizeLG0lfEd5sw==
X-Received: by 2002:a17:902:7446:b029:e9:6692:f523 with SMTP id e6-20020a1709027446b02900e96692f523mr4904685plt.10.1617844011869;
        Wed, 07 Apr 2021 18:06:51 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gg22sm6454563pjb.20.2021.04.07.18.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 18:06:51 -0700 (PDT)
Date:   Thu, 8 Apr 2021 09:06:40 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210408010640.GH2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG4gO15Q2CzTwlO7@quark.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 02:12:27PM -0700, Eric Biggers wrote:
> On Wed, Apr 07, 2021 at 07:39:20PM +0800, Hangbin Liu wrote:
> > As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> > FIPS certified, the WireGuard module should be disabled in FIPS mode.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> I think you mean "FIPS allowed", not "FIPS certified"?  Even if it used FIPS
> allowed algorithms like AES, the Linux kernel doesn't come with any sort of FIPS
> certification out of the box.

Yes, you are right.
> 
> Also, couldn't you just consider WireGuard to be outside your FIPS module
> boundary, which would remove it from the scope of the certification?
> 
> And how do you handle all the other places in the kernel that use ChaCha20 and
> SipHash?  For example, drivers/char/random.c?

Good question, I will check it and reply to you later.

Thanks
Hangbin
