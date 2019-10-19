Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF8DDD84D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbfJSLGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 07:06:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJSLGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 07:06:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D443560D5C; Sat, 19 Oct 2019 11:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571483211;
        bh=wnOIIW4MR+CLK/071OVBzNZaauLzgBfSEoUioJEm5WY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LJ3WBBtmUl28mQPuUH7cOn3/SNt7WNhkVTxOm2/FoUoWM177EMQBU3fhRDrrDv4LM
         44TIGZVRjG04P+wPJ8ne5GHUpLtcRtGuj4wRfcoOYICRu/2VCc2vAQsikCvk2yRG+p
         LvBnDW67RmL2pjgKjLlvL65eGTjyESqlHYqR0qjM=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 920AB60D39;
        Sat, 19 Oct 2019 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571483209;
        bh=wnOIIW4MR+CLK/071OVBzNZaauLzgBfSEoUioJEm5WY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=go6dHWqpkYFY2dGyszr8OAmuSCwtZIGaTWdcfcoar0dXcL6Qvguo3sDrIpnYI9o/9
         gwK00FxgPmGb2nKbbFTpfYe8GrirVct7y0Swsj86DabGQ/V1l8/OzsDcSaQs+LR6Kw
         mFzFHQt5LGvtJDsyRhPd7elZFcICtGj/iQ+n/GVU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 920AB60D39
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
Date:   Sat, 19 Oct 2019 14:06:41 +0300
In-Reply-To: <cover.1571430329.git.hns@goldelico.com> (H. Nikolaus Schaller's
        message of "Fri, 18 Oct 2019 22:25:21 +0200")
Message-ID: <87sgnpvvsu.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

> Here we have a set of scattered patches to make the OpenPandora WiFi work again.
>
> v4.7 did break the pdata-quirks which made the mmc3 interface
> fail completely, because some code now assumes device tree
> based instantiation.
>
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")
>
> v4.11 did break the sdio qirks for wl1251 which made the driver no longer
> load, although the device was found as an sdio client.
>
> Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")
>
> To solve these issues:
> * we convert mmc3 and wl1251 initialization from pdata-quirks
>   to device tree
> * we make the wl1251 driver read properties from device tree
> * we fix the mmc core vendor ids and quirks
> * we fix the wl1251 (and wl1271) driver to use only vendor ids
>   from header file instead of (potentially conflicting) local
>   definitions
>
>
> H. Nikolaus Schaller (9):
>   Documentation: dt: wireless: update wl1251 for sdio
>   net: wireless: ti: wl1251 add device tree support
>   DTS: ARM: pandora-common: define wl1251 as child node of mmc3
>   mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid
>     of pandora_wl1251_init_card
>   omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
>   mmc: sdio: fix wl1251 vendor id
>   mmc: core: fix wl1251 sdio quirks
>   net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
>   net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions

I didn't get patches 3-7 so I don't know what they have, but what's the
plan how these should be applied? Normally wl1251 patches go via
wireless-drivers-next but are you planning something else?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
