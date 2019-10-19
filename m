Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF57DD877
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 13:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfJSLZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 07:25:44 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:25078 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfJSLZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 07:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571484340;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=7L/sjFraJ4hVObqz6n+Hjde2x2GWCuAJ3/E9bu48O6s=;
        b=O2zpnN8FTh9K/83LOn4ojYeiq3odunsilcm0+mfJhvHAkwBIvEIxKda31klJ/eG5Sx
        LQcSHaQvEuHvrhY+XX9QdrZe01tReFiATxUpo7Zwb4TbUvNyhMtjMll9TxzZSDDE9oP4
        8Xo5vwtPgylAGHJgUw33R5gvl1MXDEh8+Bu2nWOpz4nQx8Dxii3sNyHJ4JGy8op+RHtn
        QRrX5nrpuDJlx85R/A608BzjH08k4YZvyPh0EvtVRzOfxB/3qYA5F0dU0eGEBRF85Kgr
        5J+X4w41rDP5YKzFPDWd5kiKHR2zbiqzgCzuZcq8hVNWJ4JBtjGGoq2iyNWPy2aNugOK
        Rx5A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmAkw4voSw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9JBPKEpk
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 19 Oct 2019 13:25:20 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 0/9] OpenPandora: make wl1251 connected to mmc3 sdio port of OpenPandora work again
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <87sgnpvvsu.fsf@kamboji.qca.qualcomm.com>
Date:   Sat, 19 Oct 2019 13:25:20 +0200
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <584D2E2D-7617-4F7D-A567-507C7CCB4A53@goldelico.com>
References: <cover.1571430329.git.hns@goldelico.com> <87sgnpvvsu.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Am 19.10.2019 um 13:06 schrieb Kalle Valo <kvalo@codeaurora.org>:
>=20
> "H. Nikolaus Schaller" <hns@goldelico.com> writes:
>=20
>> Here we have a set of scattered patches to make the OpenPandora WiFi =
work again.
>>=20
>> v4.7 did break the pdata-quirks which made the mmc3 interface
>> fail completely, because some code now assumes device tree
>> based instantiation.
>>=20
>> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for =
requesting DMA channel")
>>=20
>> v4.11 did break the sdio qirks for wl1251 which made the driver no =
longer
>> load, although the device was found as an sdio client.
>>=20
>> Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks =
file")
>>=20
>> To solve these issues:
>> * we convert mmc3 and wl1251 initialization from pdata-quirks
>>  to device tree
>> * we make the wl1251 driver read properties from device tree
>> * we fix the mmc core vendor ids and quirks
>> * we fix the wl1251 (and wl1271) driver to use only vendor ids
>>  from header file instead of (potentially conflicting) local
>>  definitions
>>=20
>>=20
>> H. Nikolaus Schaller (9):
>>  Documentation: dt: wireless: update wl1251 for sdio
>>  net: wireless: ti: wl1251 add device tree support
>>  DTS: ARM: pandora-common: define wl1251 as child node of mmc3
>>  mmc: host: omap_hsmmc: add code for special init of wl1251 to get =
rid
>>    of pandora_wl1251_init_card
>>  omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
>>  mmc: sdio: fix wl1251 vendor id
>>  mmc: core: fix wl1251 sdio quirks
>>  net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 =
definition
>>  net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions
>=20
> I didn't get patches 3-7

oh sorry. I don't know why.

Here they are all: https://patchwork.kernel.org/cover/11199599/

> so I don't know what they have, but what's the
> plan how these should be applied? Normally wl1251 patches go via
> wireless-drivers-next but are you planning something else?

Well, I have no plan for that except that all should end up fixed in =
mainline
and stable.

The issue is that multiple subsystems are involved (net/wireless, mmc =
and arm/omap)
and all patches should be ideally be applied in combination.

BR and thanks,
Nikolaus

