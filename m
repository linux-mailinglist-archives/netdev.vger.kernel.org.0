Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3488DDD887
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 13:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfJSLfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 07:35:10 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60378 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfJSLfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 07:35:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C717460D5A; Sat, 19 Oct 2019 11:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571484907;
        bh=2Xx/PoFNBKT4cvQQWZqZuKa3vjJHJ9OPdlZAX5aVIgg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SAysUsZYh9P8k1dX9KyTcyzvT6Nn5nOwtBib/jo52daUzwIbdADuRajitkY8h82A2
         rjxMOC4R65kyQSEZIhrKoV+aL7CLjO5BNEBSFpxD3Eud23EsOHvLdzqaaRAaOxs4CP
         p6ajZWBjeYMKL69L84pR1YLkjpksi6W2eTx+elho=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88F67601EA;
        Sat, 19 Oct 2019 11:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571484905;
        bh=2Xx/PoFNBKT4cvQQWZqZuKa3vjJHJ9OPdlZAX5aVIgg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dgwjPI86YslgyZtCByFuNG0ZcDPASaMoues6By5VUtSUYDCEbKXOD3luVCNv8pUTR
         p7HGPy9hOYJAuk70bVirNgBMNTAKeUSKLheDm07QT1l9y5mVFEjEb5OYNIQ5yKfZzU
         Fat4Amj3p2tyRb3vMlcKSuLEOQ5e/xPH4z/dM6Hw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 88F67601EA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: Re: [PATCH 0/9] OpenPandora: make wl1251 connected to mmc3 sdio port of OpenPandora work again
References: <cover.1571430329.git.hns@goldelico.com>
        <87sgnpvvsu.fsf@kamboji.qca.qualcomm.com>
        <584D2E2D-7617-4F7D-A567-507C7CCB4A53@goldelico.com>
Date:   Sat, 19 Oct 2019 14:34:57 +0300
In-Reply-To: <584D2E2D-7617-4F7D-A567-507C7CCB4A53@goldelico.com> (H. Nikolaus
        Schaller's message of "Sat, 19 Oct 2019 13:25:20 +0200")
Message-ID: <87d0etvuhq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

> Hi,
>
>> Am 19.10.2019 um 13:06 schrieb Kalle Valo <kvalo@codeaurora.org>:
>> 
>> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
>> 
>>> Here we have a set of scattered patches to make the OpenPandora WiFi work again.
>>> 
>>> v4.7 did break the pdata-quirks which made the mmc3 interface
>>> fail completely, because some code now assumes device tree
>>> based instantiation.
>>> 
>>> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
>>> 
>>> v4.11 did break the sdio qirks for wl1251 which made the driver no longer
>>> load, although the device was found as an sdio client.
>>> 
>>> Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
>>> 
>>> To solve these issues:
>>> * we convert mmc3 and wl1251 initialization from pdata-quirks
>>>  to device tree
>>> * we make the wl1251 driver read properties from device tree
>>> * we fix the mmc core vendor ids and quirks
>>> * we fix the wl1251 (and wl1271) driver to use only vendor ids
>>>  from header file instead of (potentially conflicting) local
>>>  definitions
>>> 
>>> 
>>> H. Nikolaus Schaller (9):
>>>  Documentation: dt: wireless: update wl1251 for sdio
>>>  net: wireless: ti: wl1251 add device tree support
>>>  DTS: ARM: pandora-common: define wl1251 as child node of mmc3
>>>  mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid
>>>    of pandora_wl1251_init_card
>>>  omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
>>>  mmc: sdio: fix wl1251 vendor id
>>>  mmc: core: fix wl1251 sdio quirks
>>>  net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
>>>  net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions
>> 
>> I didn't get patches 3-7
>
> oh sorry. I don't know why.
>
> Here they are all: https://patchwork.kernel.org/cover/11199599/

Thanks.

>> so I don't know what they have, but what's the
>> plan how these should be applied? Normally wl1251 patches go via
>> wireless-drivers-next but are you planning something else?
>
> Well, I have no plan for that except that all should end up fixed in mainline
> and stable.
>
> The issue is that multiple subsystems are involved (net/wireless, mmc and arm/omap)
> and all patches should be ideally be applied in combination.

Ok, I then assume someone else is going to handle these, wl1251 rarely
has any changes so the chance of conflicts is small anyway, and I'll
drop the wl1251 patches from my patchwork.

For wl1251 patches 1, 2, 8 and 9:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
