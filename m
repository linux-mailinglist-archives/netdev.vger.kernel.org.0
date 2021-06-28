Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB2B3B5A77
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 10:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhF1IaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 04:30:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13311 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhF1IaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 04:30:16 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210628082749euoutp020c685c57c61757d7c06612d0b587e946~MsaDJGjfj0257602576euoutp02E
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 08:27:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210628082749euoutp020c685c57c61757d7c06612d0b587e946~MsaDJGjfj0257602576euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624868869;
        bh=QgPk6fGpXUSMrivSJan0SozQdbHsAxmc1zYFdsUCBF8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=BdNql6ncmRc3quuk1pzdtibm2wG/ByT5b7v3WcExFLDDoh+M6rUY5X0E/jc3YGG6l
         Qbfyb8Hg3pmOraxItKDdyqaaW4eWzwp5Zm/A3UBVuyyMargrcK41JQw1RQLGgAW76z
         NtdA9ZTkeJCuDBR9tdf2ZdTotO+dQrllU2ixuhc8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210628082749eucas1p2fc310737ec0c9d7430dadf9d13fe301e~MsaCycgOZ2216222162eucas1p2f;
        Mon, 28 Jun 2021 08:27:49 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id DB.DB.56448.50889D06; Mon, 28
        Jun 2021 09:27:49 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210628082748eucas1p2c5d26df5c75f0551421ef047b681c6b9~MsaCT_Euq0251202512eucas1p2N;
        Mon, 28 Jun 2021 08:27:48 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210628082748eusmtrp1dd2b61e01a9ea07e522b4f640ad68cc0~MsaCTFSW_2119321193eusmtrp17;
        Mon, 28 Jun 2021 08:27:48 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-b2-60d988059f59
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 14.35.31287.40889D06; Mon, 28
        Jun 2021 09:27:48 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210628082748eusmtip2da06dd82dce8cca2a968f7f8f744bd66~MsaBmt6Hn1554215542eusmtip2i;
        Mon, 28 Jun 2021 08:27:47 +0000 (GMT)
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
Message-ID: <01f6cf2f-9d5f-010c-b3f3-194350d01cf0@samsung.com>
Date:   Mon, 28 Jun 2021 10:27:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210623070618.nfv4yizuijbrv575@pengutronix.de>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7djPc7qsHTcTDLrX8lmcv3uI2WLO+RYW
        i0XvZ7BarJq6k8XiwrY+VovLu+awWSxa1spscWjqXkaLYwvELJ7cY3Tg8rh87SKzx5aVN5k8
        ds66y+6xaVUnm8fOHZ+ZPPr/Gnh83iQXwB7FZZOSmpNZllqkb5fAlfHj0nfGgomaFVenPGdv
        YPyt0MXIySEhYCJxesVB1i5GLg4hgRWMEn/mfWACSQgJfGGUWLBSCSLxmVGiYfcxRpiO7x2d
        TBCJ5YwS/1esg3I+MkrMe7sWaBYHh7BAkMTyg0EgDSICOhKNW9aDrWAWWMkkMeHpCxaQBJuA
        oUTX2y42kHpeATuJyV0FIGEWAVWJhRNPM4PYogLJEu/nzWAFsXkFBCVOznwC1sopYCux4moH
        mM0sIC/RvHU2M4QtLnHryXyweyQEmjklXn7dxQQyX0LAReLsKW+IB4QlXh3fwg5hy0icntzD
        AlXPKPHw3Fp2CKeHUeJy0wyol60l7pz7BXYos4CmxPpd+hBhR4kZK1pYIObzSdx4KwhxA5/E
        pG3TmSHCvBIdbUIQ1WoSs46vg1t78MIl5gmMSrOQfDYLyTezkHwzC2HvAkaWVYziqaXFuemp
        xcZ5qeV6xYm5xaV56XrJ+bmbGIHJ6vS/4193MK549VHvECMTB+MhRgkOZiURXrGqawlCvCmJ
        lVWpRfnxRaU5qcWHGKU5WJTEeXdtXRMvJJCeWJKanZpakFoEk2Xi4JRqYHJ9ND85JvW8RuHC
        rU+rvz25kZQkL/nRvmHKnCdBbIwvfq43VP+xMP3KiwpD348L9/WzVzxj4Zm0q4T3T+qGvzsX
        X9e3YlzwPmiH7fauQIcv0Z7sN87cePVn+pzJfhZzr4Q3Pj49TXWq3slcD11uvklzrKpfeTf/
        Pn7t29kpG7x3hpz2qBebyhK73EerboH0KoOJHKW5FwSKl18IjpT74/zPYULM+0d3Xb0SOcqN
        2jZtClL+4bPor46z9uMve2rjLV/5HxYSFv/0M/RS671eoe2Pa5g/zU/jt1u8a7qCnNj95JL+
        n+s+Hrp1MOhleMYiwYC3zTrqlu6ZnC4W71inBb9S5omd0/OtaaHR38MnGoOVWIozEg21mIuK
        EwE2LeBKxQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xe7osHTcTDC61q1ucv3uI2WLO+RYW
        i0XvZ7BarJq6k8XiwrY+VovLu+awWSxa1spscWjqXkaLYwvELJ7cY3Tg8rh87SKzx5aVN5k8
        ds66y+6xaVUnm8fOHZ+ZPPr/Gnh83iQXwB6lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hpoWdkYqln
        aGwea2VkqqRvZ5OSmpNZllqkb5egl/Hj0nfGgomaFVenPGdvYPyt0MXIySEhYCLxvaOTqYuR
        i0NIYCmjxLq7H1ggEjISJ6c1sELYwhJ/rnWxQRS9Z5R48+E0UAcHh7BAkMTyg0EgNSICOhKN
        W9azgtQwC6xkkljYMoEFomEdi8T6AwcZQarYBAwlut6CTOLg4BWwk5jcVQASZhFQlVg48TQz
        iC0qkCzxc307G4jNKyAocXLmE7CDOAVsJVZc7QCzmQXMJOZtfsgMYctLNG+dDWWLS9x6Mp9p
        AqPQLCTts5C0zELSMgtJywJGllWMIqmlxbnpucWGesWJucWleel6yfm5mxiBEbrt2M/NOxjn
        vfqod4iRiYPxEKMEB7OSCK9Y1bUEId6UxMqq1KL8+KLSnNTiQ4ymQP9MZJYSTc4Hpoi8knhD
        MwNTQxMzSwNTSzNjJXHerXPXxAsJpCeWpGanphakFsH0MXFwSjUwyVjsl03r6HXx/y2r4fjr
        TVB5K/eLv94nz/w4aPBbPMfq1wHpO64aiz7+YJn61LSPc/rHL4e2/OwolWPPkcjmmcfFPvsL
        i+78920nbumvFeFK0krJvBHQ9unUaUPWPbmiVdb/r6gyrq5/Frw+7f6nu6lpK0yuvk31WP39
        SceyordbloTWS8w4VRV5+Gvsacfbn+4pbHt89PElpXzjOQGWbNr1d1YcDhQu19ns3LXubvV+
        naaFT1adna32UNDqbEvIXIuOIsdzqyLZFRk5Lm4p3Rpx/V7lU6Wj4TFnn/W4+VjYXq7dYZH+
        rqNwh8tBRyuFy5WLNvwL2Gyrvi5M2SMw4okGU+flZxc1LQuOmYvcV2Ipzkg01GIuKk4EAAix
        qMZZAwAA
X-CMS-MailID: 20210628082748eucas1p2c5d26df5c75f0551421ef047b681c6b9
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
        <2d0bdf2e-49bc-60c0-789e-b909cf1e2667@samsung.com>
        <20210623070618.nfv4yizuijbrv575@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 23.06.2021 09:06, Oleksij Rempel wrote:
> On Mon, Jun 21, 2021 at 08:05:49AM +0200, Marek Szyprowski wrote:
>> On 18.06.2021 15:20, Oleksij Rempel wrote:
>>> On Fri, Jun 18, 2021 at 01:11:41PM +0200, Marek Szyprowski wrote:
>>>> On 18.06.2021 13:04, Heiner Kallweit wrote:
>>>>> On 18.06.2021 12:13, Oleksij Rempel wrote:
>>>>>> thank you for your feedback.
>>>>>>
>>>>>> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
>>>>>>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>>>>>>> To be able to use ax88772 with external PHYs and use advantage of
>>>>>>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>>>>>>> driver to the phylib framework.
>>>>>>>>
>>>>>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>>>>>> I found one more issue with this patch. On one of my test boards
>>>>>>> (Samsung Exynos5250 SoC based Arndale) system fails to establish network
>>>>>>> connection just after starting the kernel when the driver is build-in.
>>>>>>>
>>>>> If you build in the MAC driver, do you also build in the PHY driver?
>>>>> If the PHY driver is still a module this could explain why genphy
>>>>> driver is used.
>>>>> And your dmesg filtering suppresses the phy_attached_info() output
>>>>> that would tell us the truth.
>>>> Here is a bit more complete log:
>>>>
>>>> # dmesg | grep -i Asix
>>>> [    2.412966] usbcore: registered new interface driver asix
>>>> [    4.620094] usb 1-3.2.4: Manufacturer: ASIX Elec. Corp.
>>>> [    4.641797] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
>>>> invalid hw address, using random
>>>> [    5.657009] libphy: Asix MDIO Bus: probed
>>>> [    5.750584] Asix Electronics AX88772A usb-001:004:10: attached PHY
>>>> driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
>>>> [    5.763908] asix 1-3.2.4:1.0 eth0: register 'asix' at
>>>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, fe:a5:29:e2:97:3e
>>>> [    9.090270] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>>>> control off
>>>>
>>>> This seems to be something different than missing PHY driver.
>>> Can you please test it:
>>>
>>> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
>>> index aec97b021a73..7897108a1a42 100644
>>> --- a/drivers/net/usb/asix_devices.c
>>> +++ b/drivers/net/usb/asix_devices.c
>>> @@ -453,6 +453,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
>>>    	u16 rx_ctl, phy14h, phy15h, phy16h;
>>>    	u8 chipcode = 0;
>>>    
>>> +	netdev_info(dev->net, "ax88772a_hw_reset\n");
>>>    	ret = asix_write_gpio(dev, AX_GPIO_RSE, 5, in_pm);
>>>    	if (ret < 0)
>>>    		goto out;
>>> @@ -509,31 +510,7 @@ static int ax88772a_hw_reset(struct usbnet *dev, int in_pm)
>>>    			goto out;
>>>    		}
>>>    	} else if ((chipcode & AX_CHIPCODE_MASK) == AX_AX88772A_CHIPCODE) {
>>> -		/* Check if the PHY registers have default settings */
>>> -		phy14h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
>>> -					     AX88772A_PHY14H);
>>> -		phy15h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
>>> -					     AX88772A_PHY15H);
>>> -		phy16h = asix_mdio_read_nopm(dev->net, dev->mii.phy_id,
>>> -					     AX88772A_PHY16H);
>>> -
>>> -		netdev_dbg(dev->net,
>>> -			   "772a_hw_reset: MR20=0x%x MR21=0x%x MR22=0x%x\n",
>>> -			   phy14h, phy15h, phy16h);
>>> -
>>> -		/* Restore PHY registers default setting if not */
>>> -		if (phy14h != AX88772A_PHY14H_DEFAULT)
>>> -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
>>> -					     AX88772A_PHY14H,
>>> -					     AX88772A_PHY14H_DEFAULT);
>>> -		if (phy15h != AX88772A_PHY15H_DEFAULT)
>>> -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
>>> -					     AX88772A_PHY15H,
>>> -					     AX88772A_PHY15H_DEFAULT);
>>> -		if (phy16h != AX88772A_PHY16H_DEFAULT)
>>> -			asix_mdio_write_nopm(dev->net, dev->mii.phy_id,
>>> -					     AX88772A_PHY16H,
>>> -					     AX88772A_PHY16H_DEFAULT);
>>> +		netdev_info(dev->net, "do not touch PHY regs\n");
>>>    	}
>>>    
>>>    	ret = asix_write_cmd(dev, AX_CMD_WRITE_IPG0,
>> This doesn't help for this issue.
> Ok.
> So far I was not able to see obvious differences between:
> probe -> ip link set dev eth1 up
>
> and
>
> probe -> ip link set dev eth1 up;
> 	 ip link set dev eth1 down;
> 	 ip link set dev eth1 up
>
>
> Except of PHY sate. By default the PHY is in resumed state after probe
> and is able to negotiate the link even if the MAC is down.
> After ip link set dev eth1 down, the PHY is in suspend state, as
> expected.
>
> Can you please test this change?
>
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index aec97b021a73..2c115216420a 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -701,6 +701,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>   		return ret;
>   	}
>   
> +	phy_suspend(priv->phydev);
>   	priv->phydev->mac_managed_pm = 1;
>   
>   	phy_attached_info(priv->phydev);
>
I'm sorry for the late reply, I've just got back from vacations. The 
above change fixes the issue.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

