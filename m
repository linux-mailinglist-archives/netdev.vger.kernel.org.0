Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC27C75F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfGaPs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:48:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbfGaPs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:48:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C1AA14015B0D;
        Wed, 31 Jul 2019 08:48:25 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:48:24 -0700 (PDT)
Message-Id: <20190731.084824.2244928058443049.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, willy@infradead.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-build-reports@lists.linaro.org
Subject: Re: next/master build: 221 builds: 11 failed, 210 passed, 13
 errors, 1174 warnings (next-20190731)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190731113522.GA3426@kroah.com>
References: <5d41767d.1c69fb81.d6304.4c8c@mx.google.com>
        <20190731112441.GB4369@sirena.org.uk>
        <20190731113522.GA3426@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:48:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2019 13:35:22 +0200

> On Wed, Jul 31, 2019 at 12:24:41PM +0100, Mark Brown wrote:
>> On Wed, Jul 31, 2019 at 04:07:41AM -0700, kernelci.org bot wrote:
>> 
>> Today's -next fails to build an ARM allmodconfig due to:
>> 
>> > allmodconfig (arm, gcc-8) ― FAIL, 1 error, 40 warnings, 0 section mismatches
>> > 
>> > Errors:
>> >     drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of function 'writeq'; did you mean 'writel'? [-Werror=implicit-function-declaration]
>> 
>> as a result of the changes that introduced:
>> 
>> WARNING: unmet direct dependencies detected for MDIO_OCTEON
>>   Depends on [n]: NETDEVICES [=y] && MDIO_DEVICE [=m] && MDIO_BUS [=m] && 64BIT && HAS_IOMEM [=y] && OF_MDIO [=m]
>>   Selected by [m]:
>>   - OCTEON_ETHERNET [=m] && STAGING [=y] && (CAVIUM_OCTEON_SOC && NETDEVICES [=y] || COMPILE_TEST [=y])
>> 
>> which is triggered by the staging OCTEON_ETHERNET driver which misses a
>> 64BIT dependency but added COMPILE_TEST in 171a9bae68c72f2
>> (staging/octeon: Allow test build on !MIPS).
> 
> A patch was posted for this, but it needs to go through the netdev tree
> as that's where the offending patches are coming from.

I didn't catch that, was netdev CC:'d?
