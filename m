Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5093AE2F6
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhFUGIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:08:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46721 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhFUGIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:08:06 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210621060551euoutp02c41dd2620f21f1fbc752aee888c3be0f~Kg9F2rEqu2912629126euoutp02b
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 06:05:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210621060551euoutp02c41dd2620f21f1fbc752aee888c3be0f~Kg9F2rEqu2912629126euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624255551;
        bh=7zo/KJD1puXq+82LaBcXxMxZOsgJWKQdzbVs6z8dDRM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=h1r1AwqSNOFb8RAoeNB/mo65NOyRGZ8OYzUon1sk4mSJBXrH1iDsiVw4pDgPjYQzF
         ogYsV6cHFzZLLGbf32Y8H2dZ8boJBoxUiQCxV+70TZx0ZS5xKqz+gln+gsadwsnaUl
         jL7hBdzo+90+Xel9/2eYfZH3uN8xfaec8VYkp8vA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210621060550eucas1p141cdaabda755047efe8e20c8c8b4c6a9~Kg9FhQcaL0793407934eucas1p13;
        Mon, 21 Jun 2021 06:05:50 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F6.79.45756.E3C20D06; Mon, 21
        Jun 2021 07:05:50 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210621060550eucas1p23bae82f91753ea0a81396fb855316bd6~Kg9FCyxHr2694226942eucas1p2F;
        Mon, 21 Jun 2021 06:05:50 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210621060550eusmtrp1f895269b6921656c05ab1d05ff2727dc~Kg9FB63kW1313213132eusmtrp1l;
        Mon, 21 Jun 2021 06:05:50 +0000 (GMT)
X-AuditID: cbfec7f2-7bdff7000002b2bc-55-60d02c3e511b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D4.50.31287.E3C20D06; Mon, 21
        Jun 2021 07:05:50 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210621060549eusmtip15a7e129335db8f3debd3b19f966a96cc~Kg9EXtB7J3191831918eusmtip14;
        Mon, 21 Jun 2021 06:05:49 +0000 (GMT)
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <2d0bdf2e-49bc-60c0-789e-b909cf1e2667@samsung.com>
Date:   Mon, 21 Jun 2021 08:05:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618132035.6vg53gjwuyildlry@pengutronix.de>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7djPc7p2OhcSDC79M7I4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD2KyyYlNSezLLVI3y6BK+Pa1H1sBd/lKv6tnsna
        wPhQoouRk0NCwETizu4FrF2MXBxCAisYJTa/2MEC4XxhlNj69iYjSJWQwGdGiYu9AjAd65bs
        ZoYoWs4ocXjTDKj2j4wSvXOb2bsYOTiEBYIklh8MAmkQEdCRaNyyHqyGWWAlk8SEpy9YQBJs
        AoYSXW+72EBsXgE7ibWLd4D1sgioSkxcIQUSFhVIlng/D2Q+SImgxMmZT8BaOQVsJc5ufAhm
        MwvISzRvnc0MYYtL3Hoynwlkl4RAM6fEo9e7GCGudpE4eLkPyhaWeHV8CzuELSNxenIPC1QD
        o8TDc2vZIZweRonLTTOgOqwl7pz7xQZyHbOApsT6XfoQYUeJGStaWEDCEgJ8EjfeCkIcwScx
        adt0Zogwr0RHmxBEtZrErOPr4NYevHCJeQKj0iwkr81C8s4sJO/MQti7gJFlFaN4amlxbnpq
        sWFearlecWJucWleul5yfu4mRmC6Ov3v+KcdjHNffdQ7xMjEwXiIUYKDWUmElzPzTIIQb0pi
        ZVVqUX58UWlOavEhRmkOFiVx3lWz18QLCaQnlqRmp6YWpBbBZJk4OKUamObIfH4XWHjg7NVF
        UzIXt7lLn4h/nx15sJAntiOO9wSrblrSNgtRo63pVS7Tzc489p+iI39KVejFsdj+H3r2H8zM
        v3s2c3btrljN2pbN9fuZCBPvq7UGB4LiixOXnrJ6/mrygkTztRsfb312z1DV5FvqlQmnbH4n
        ywS9ujMvPM/Xo35hz1+TpuLzdi3TfBbznQxkaDxt+PtN+u2P3/QOnxBca5naubOBafsfoZAL
        x+oTLxVw7M4+nu1wxO5a+VOdJWe5m1OELAW+CwdYRQYu+jzXu2jClelFU65duG46bfujD2wi
        ++ZX5GybmcDi+mzqrlmy/OpTSl15Z8/PU1CQ5lyqso7/0ttPx/1lhYV3v1NiKc5INNRiLipO
        BACkRwLxxgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xu7p2OhcSDFbN47c4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP
        0Ng81srIVEnfziYlNSezLLVI3y5BL+Pa1H1sBd/lKv6tnsnawPhQoouRk0NCwERi3ZLdzF2M
        XBxCAksZJY5e2cQEkZCRODmtgRXCFpb4c62LDaLoPaPE4Y5PQA4Hh7BAkMTyg0EgNSICOhKN
        W9azgtQwC6xkkljYMoEFouEYs8THfx8YQarYBAwlut6CTOLk4BWwk1i7eAc7yCAWAVWJiSuk
        QMKiAskSP9e3Q5UISpyc+YQFxOYUsJU4u/EhmM0sYCYxb/NDZghbXqJ562woW1zi1pP5TBMY
        hWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIzQbcd+bt7BOO/V
        R71DjEwcjIcYJTiYlUR4OTPPJAjxpiRWVqUW5ccXleakFh9iNAV6ZyKzlGhyPjBF5JXEG5oZ
        mBqamFkamFqaGSuJ826duyZeSCA9sSQ1OzW1ILUIpo+Jg1OqgWmvoJVNWOjUiH3eQtwNkWef
        r86/q/r21Zcwl87/O9u6L6o+FF4qaNT7IG9r0R5GdjFnY/9J5nKa6hcreIUmTl3N9YF7u+f6
        +auMPXacbjjlGLdz072QXa1XzRZUHeUXfizrW/7v5plFa3asfv01NmlykG1BqfcNV+Pb0w//
        PmAdwR+x/8f/yl2lhw+3nRU+sO1wcHD9hivnpJi21h7wrj/64a9Jl8UPb/cVq8VWM/iffX1+
        8ZcVV7WC/fIF+Z/Oqd2xjDXlcIi1xGyBh7t3hzPohTxbOlO845/aHnb2H1rbejulRKf9/6X/
        80D6/lUu+z8YzHjrYfNyakyOdeuJtDJfgxiNkBOcm56tVK+MvcesxFKckWioxVxUnAgAvUv3
        0FkDAAA=
X-CMS-MailID: 20210621060550eucas1p23bae82f91753ea0a81396fb855316bd6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
        <20210607082727.26045-5-o.rempel@pengutronix.de>
        <CGME20210618083914eucas1p240f88e7064a7bf15b68370b7506d24a9@eucas1p2.samsung.com>
        <15e1bb24-7d67-9d45-54c1-c1c1a0fe444a@samsung.com>
        <20210618101317.55fr5vl5akmtgcf6@pengutronix.de>
        <b1c48fa1-d406-766e-f8d7-54f76d3acb7c@gmail.com>
        <e868450d-c623-bea9-6325-aca4e8367ad5@samsung.com>
        <20210618132035.6vg53gjwuyildlry@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 18.06.2021 15:20, Oleksij Rempel wrote:
> On Fri, Jun 18, 2021 at 01:11:41PM +0200, Marek Szyprowski wrote:
>> On 18.06.2021 13:04, Heiner Kallweit wrote:
>>> On 18.06.2021 12:13, Oleksij Rempel wrote:
>>>> thank you for your feedback.
>>>>
>>>> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
>>>>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>>>>> To be able to use ax88772 with external PHYs and use advantage of
>>>>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>>>>> driver to the phylib framework.
>>>>>>
>>>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>>>> I found one more issue with this patch. On one of my test boards
>>>>> (Samsung Exynos5250 SoC based Arndale) system fails to establish network
>>>>> connection just after starting the kernel when the driver is build-in.
>>>>>
>>> If you build in the MAC driver, do you also build in the PHY driver?
>>> If the PHY driver is still a module this could explain why genphy
>>> driver is used.
>>> And your dmesg filtering suppresses the phy_attached_info() output
>>> that would tell us the truth.
>> Here is a bit more complete log:
>>
>> # dmesg | grep -i Asix
>> [    2.412966] usbcore: registered new interface driver asix
>> [    4.620094] usb 1-3.2.4: Manufacturer: ASIX Elec. Corp.
>> [    4.641797] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
>> invalid hw address, using random
>> [    5.657009] libphy: Asix MDIO Bus: probed
>> [    5.750584] Asix Electronics AX88772A usb-001:004:10: attached PHY
>> driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
>> [    5.763908] asix 1-3.2.4:1.0 eth0: register 'asix' at
>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, fe:a5:29:e2:97:3e
>> [    9.090270] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>> control off
>>
>> This seems to be something different than missing PHY driver.
> Can you please test it:
>
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index aec97b021a73..7897108a1a42 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -453,6 +453,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
>   	u16 rx_ctl, phy14h, phy15h, phy16h;
>   	u8 chipcode = 0;
>   
> +	netdev_info(dev->net, "ax88772a_hw_reset\n");
>   	ret = asix_write_gpio(dev, AX_GPIO_RSE, 5, in_pm);
>   	if (ret < 0)
>   		goto out;
> @@ -509,31 +510,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
>   			goto out;
>   		}
>   	} else if ((chipcode & AX_CHIPCODE_MASK) == AX_AX88772A_CHIPCODE) {
> -		/* Check if the PHY registers have default settings */
> -		phy14h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
> -					     AX88772A_PHY14H);
> -		phy15h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
> -					     AX88772A_PHY15H);
> -		phy16h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
> -					     AX88772A_PHY16H);
> -
> -		netdev_dbg(dev->net,
> -			   "772a_hw_reset: MR20=0x%x MR21=0x%x MR22=0x%x\n",
> -			   phy14h, phy15h, phy16h);
> -
> -		/* Restore PHY registers default setting if not */
> -		if (phy14h != AX88772A_PHY14H_DEFAULT)
> -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
> -					     AX88772A_PHY14H,
> -					     AX88772A_PHY14H_DEFAULT);
> -		if (phy15h != AX88772A_PHY15H_DEFAULT)
> -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
> -					     AX88772A_PHY15H,
> -					     AX88772A_PHY15H_DEFAULT);
> -		if (phy16h != AX88772A_PHY16H_DEFAULT)
> -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
> -					     AX88772A_PHY16H,
> -					     AX88772A_PHY16H_DEFAULT);
> +		netdev_info(dev->net, "do not touch PHY regs\n");
>   	}
>   
>   	ret = asix_write_cmd(dev, AX_CMD_WRITE_IPG0,

This doesn't help for this issue.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

