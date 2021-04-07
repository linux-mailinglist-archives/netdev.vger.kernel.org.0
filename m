Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69878357684
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhDGVMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhDGVMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:12:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F939611CC;
        Wed,  7 Apr 2021 21:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617829949;
        bh=3ClaiXmoMxpwLarSFjiRGpAykEyCSoeO2i4RKoiLJjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kOkMQRKbNoGZJir5IqZsa5DWckU2utpxegMfi2tXvaKN+tznLQ7b/vsTrWy04J+US
         8wFdOOQgZs0I7yE2+Uvih6z0fTTKY7hiAFLghtdJjMCsAcxhMROLwnOFHyHNccZh61
         Rj0HWfzalucRa9+8Nl+TPR85leQgELeDc6dmc9iXjx8U/Ipl08BNFUdLcAhFaZM4Gp
         /sGicmeMgHkEFuegFgWMF6N9FI2Jwq/m54G/CBeQYa5rj5OWVwH/jpPUvCRqERbbpd
         l9hD5iGXLX/ncCAgPsU6yc9xAr9sqklpN0xnquKMbyH5hbUQyITRFyoQqlHIFdehWC
         18M//9JNefbKQ==
Date:   Wed, 7 Apr 2021 14:12:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <YG4gO15Q2CzTwlO7@quark.localdomain>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407113920.3735505-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 07:39:20PM +0800, Hangbin Liu wrote:
> As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> FIPS certified, the WireGuard module should be disabled in FIPS mode.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

I think you mean "FIPS allowed", not "FIPS certified"?  Even if it used FIPS
allowed algorithms like AES, the Linux kernel doesn't come with any sort of FIPS
certification out of the box.

Also, couldn't you just consider WireGuard to be outside your FIPS module
boundary, which would remove it from the scope of the certification?

And how do you handle all the other places in the kernel that use ChaCha20 and
SipHash?  For example, drivers/char/random.c?

- Eric
