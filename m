Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F887C801
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 18:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfGaQAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 12:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727276AbfGaQAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 12:00:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF56A206A2;
        Wed, 31 Jul 2019 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564588846;
        bh=8/iUzsnff7v3bdrLEupAqK60VWMHVs1+tovD+8fMDdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oSq7AczokLq9O5HmGNMMXoBQHyFsn+uD6YtJzSsackbSJOjH4gxnRgXabQ5IUo40f
         VDSVk4VIirr7JC0jMtPN8qU6VGYI09s81wOUOQnbFA3yoNTTiKFP1DcV3OENUMrD/K
         TC6xyj22CzGCwJMpv8SwLM/4oeYAaT8kraa4+Cug=
Date:   Wed, 31 Jul 2019 18:00:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     devel@driverdev.osuosl.org, andrew@lunn.ch, f.fainelli@gmail.com,
        kernel-build-reports@lists.linaro.org, netdev@vger.kernel.org,
        willy@infradead.org, broonie@kernel.org,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        hkallweit1@gmail.com
Subject: Re: next/master build: 221 builds: 11 failed, 210 passed, 13 errors,
 1174 warnings (next-20190731)
Message-ID: <20190731160043.GA15520@kroah.com>
References: <5d41767d.1c69fb81.d6304.4c8c@mx.google.com>
 <20190731112441.GB4369@sirena.org.uk>
 <20190731113522.GA3426@kroah.com>
 <20190731.084824.2244928058443049.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190731.084824.2244928058443049.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 08:48:24AM -0700, David Miller wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Wed, 31 Jul 2019 13:35:22 +0200
> 
> > On Wed, Jul 31, 2019 at 12:24:41PM +0100, Mark Brown wrote:
> >> On Wed, Jul 31, 2019 at 04:07:41AM -0700, kernelci.org bot wrote:
> >> 
> >> Today's -next fails to build an ARM allmodconfig due to:
> >> 
> >> > allmodconfig (arm, gcc-8) ― FAIL, 1 error, 40 warnings, 0 section mismatches
> >> > 
> >> > Errors:
> >> >     drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of function 'writeq'; did you mean 'writel'? [-Werror=implicit-function-declaration]
> >> 
> >> as a result of the changes that introduced:
> >> 
> >> WARNING: unmet direct dependencies detected for MDIO_OCTEON
> >>   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=m] && MDIO_BUS [=m] && 64BIT && HAS_IOMEM [=y] && OF_MDIO [=m]
> >>   Selected by [m]:
> >>   - OCTEON_ETHERNET [=m] && STAGING [=y] && (CAVIUM_OCTEON_SOC && NETDEVICES [=y] || COMPILE_TEST [=y])
> >> 
> >> which is triggered by the staging OCTEON_ETHERNET driver which misses a
> >> 64BIT dependency but added COMPILE_TEST in 171a9bae68c72f2
> >> (staging/octeon: Allow test build on !MIPS).
> > 
> > A patch was posted for this, but it needs to go through the netdev tree
> > as that's where the offending patches are coming from.
> 
> I didn't catch that, was netdev CC:'d?

Nope, just you :(

I'll resend it now and cc: netdev.

thanks,

greg k-h
