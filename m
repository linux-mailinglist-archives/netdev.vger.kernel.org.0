Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB7E3AC916
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhFRKr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:47:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32510 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhFRKrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:47:55 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210618104544euoutp0245cfd3ca01ff083d95f7be9ca89445ad~Jp1m4m4941753317533euoutp02t
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 10:45:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210618104544euoutp0245cfd3ca01ff083d95f7be9ca89445ad~Jp1m4m4941753317533euoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624013144;
        bh=qa5dOA++QuOeumqWG0uQi90gqBCiV9C3agHbjD0E5SQ=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=HDyqRGHtaofvSZxaJstunYNcVRryVWAnCaIUePQOSd+XQ8UE4dU65s91h5w0/P7xI
         ZcBDvoCRJcnmVL0yewxVccDcRJXUPDrq8qI3Glv2aHf1BprVv0Kh2yPFz0jyzPAAQE
         OW21v7ERU0DM4GiwK07B6F8ndF7U3JhPjAQNHReg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210618104544eucas1p18969ab27e707382b6706732b08a126cd~Jp1mggZ0k1511615116eucas1p1N;
        Fri, 18 Jun 2021 10:45:44 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 03.B5.45756.7597CC06; Fri, 18
        Jun 2021 11:45:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210618104543eucas1p14437398cafcfe986f8d10fa934afff7a~Jp1lu9jXI2563325633eucas1p1h;
        Fri, 18 Jun 2021 10:45:43 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210618104543eusmtrp20225c6070dd55df79dc95c78fa320ebe~Jp1luKoUa0566905669eusmtrp2T;
        Fri, 18 Jun 2021 10:45:43 +0000 (GMT)
X-AuditID: cbfec7f2-7bdff7000002b2bc-c8-60cc7957eb78
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 39.1F.20981.7597CC06; Fri, 18
        Jun 2021 11:45:43 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210618104542eusmtip117fc492ed7aa11a223cab28da922e140~Jp1lJYNFX1026310263eusmtip1i;
        Fri, 18 Jun 2021 10:45:42 +0000 (GMT)
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <460f971e-fbae-8d3d-ae8e-ed90bbebda4d@samsung.com>
Date:   Fri, 18 Jun 2021 12:45:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618101317.55fr5vl5akmtgcf6@pengutronix.de>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djP87rhlWcSDOZ0mVqcv3uI2WLO+RYW
        i0XvZ7BarJq6k8XiwrY+VovLu+awWSxa1spscWjqXkaLYwvELJ7cY3Tg8rh87SKzx5aVN5k8
        ds66y+6xaVUnm8fOHZ+ZPPr/Gnh83iQXwB7FZZOSmpNZllqkb5fAlfFmfyt7wXWRiusv2lkb
        GH8JdDFyckgImEgsW7OKvYuRi0NIYAWjxMauacwQzhdGiT83b7NAOJ8ZJfoOr2KDafl+8BdU
        YjmjxKobxxkhnI+MEg3P7gEN4+AQFgiSWH4wCKRBREBHonHLelaQGmaBlUwSEz/tYAJJsAkY
        SnS97QKbyitgJ9HafxXMZhFQlXjTeZMRxBYVSJZ4P28GK0SNoMTJmU9YQGxOAVuJZxOPgc1h
        FpCXaN46mxnCFpe49WQ+E8gyCYH/HBKTtr5lBDlIQsBFYtZhqA+EJV4d38IOYctI/N8JU9/M
        KPHw3Fp2CKeHUeJy0wxGiCpriTvnfrGBDGIW0JRYv0sfIuwoMWNFCwvEfD6JG28FIW7gk5i0
        bTozRJhXoqNNCKJaTWLW8XVwaw9euMQ8gVFpFpLPZiH5ZhaSb2Yh7F3AyLKKUTy1tDg3PbXY
        MC+1XK84Mbe4NC9dLzk/dxMjMGGd/nf80w7Gua8+6h1iZOJgPMQowcGsJMLLmXkmQYg3JbGy
        KrUoP76oNCe1+BCjNAeLkjjvqtlr4oUE0hNLUrNTUwtSi2CyTBycUg1MjjttLjV+/vA5N2DS
        PYnLzexfdy4rrNHe8+FeYFyw3dcXByYeFF8QdHLT07/vFntdnmxsvPTTdYeHC5dw8T2X9+G7
        8epJTouZ3slPxUzTDR/8Cv4raue3Yk/+hL0nn9eEpPTUBVVeCE6K36cvF7Pmv7TA8eeLJdyU
        1trO1uC3kTv1s4T5+v6HvBbTRTbI7NATqZrCssDu7oc/j6avqfz9Rv8Tq9Ta1dd7BE1X5IYs
        fTf97o7vGwWkdpzZYKMWHt2mr3doz96FDxxeT+ycHPlnkoT/nC9pqQ27525wKzt0bdkii/eR
        NwyS898/3XilfumFHcJr5aefcnQ3ywrLW7FWS6A/21RwJeedhKTqn7veaFYrsRRnJBpqMRcV
        JwIA11yPRccDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t/xu7rhlWcSDE7MY7M4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP
        0Ng81srIVEnfziYlNSezLLVI3y5BL+PN/lb2gusiFddftLM2MP4S6GLk5JAQMJH4fvAXSxcj
        F4eQwFJGickvX7BCJGQkTk5rgLKFJf5c62KDKHrPKHF/8nr2LkYODmGBIInlB4NAakQEdCQa
        t6xnBalhFljNJHF/w0QmiAYgZ97znSwgVWwChhJdb0EmcXLwCthJtPZfBbNZBFQl3nTeZASx
        RQWSJX6ub4eqEZQ4OfMJWC+ngK3Es4nHmEBsZgEziXmbHzJD2PISzVtnQ9niEreezGeawCg0
        C0n7LCQts5C0zELSsoCRZRWjSGppcW56brGRXnFibnFpXrpecn7uJkZgjG479nPLDsaVrz7q
        HWJk4mA8xCjBwawkwsuZeSZBiDclsbIqtSg/vqg0J7X4EKMp0D8TmaVEk/OBSSKvJN7QzMDU
        0MTM0sDU0sxYSZzX5MiaeCGB9MSS1OzU1ILUIpg+Jg5OqQYmwddvkg6IrrvKlqSzdMvCD+X5
        Wgu3/5ZimFjwVKpvvpa70s5Z9ivf/FliqqFVu/Tzyu9r5XY/SdOZb9F5WnViUDTrDLtONhvB
        +lUMmrszTjafsmutlhM8qxqc2Oa1QD2k57bz60vp/Tp7S42/dCW/6+nZsPtz5CcLhVfp3r8W
        bngefnYN69FZBWf3RrCdXcew+tIM8cl6C06JFsjm7ti0PMZMMb5x4z5RZvudtQ89ZT70rTpy
        5GRit9lJI7vzcSt9t5Rte/x44dmDXzsY6o6xqLYxTvz8dRvbjVZxQfZ3rQYR/+68U9G6NGU2
        k7T+sVkR3xX+X8mdKPbi36Y+cYX0/ikOkXx8S0Ov8sjWHN51R4mlOCPRUIu5qDgRAOlO7LNa
        AwAA
X-CMS-MailID: 20210618104543eucas1p14437398cafcfe986f8d10fa934afff7a
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 18.06.2021 12:13, Oleksij Rempel wrote:
> thank you for your feedback.
>
> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>> To be able to use ax88772 with external PHYs and use advantage of
>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>> driver to the phylib framework.
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> I found one more issue with this patch. On one of my test boards
>> (Samsung Exynos5250 SoC based Arndale) system fails to establish network
>> connection just after starting the kernel when the driver is build-in.
>>
>> --->8---
>> # dmesg | grep asix
>> [    2.761928] usbcore: registered new interface driver asix
>> [    5.003110] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
>> invalid hw address, using random
>> [    6.065400] asix 1-3.2.4:1.0 eth0: register 'asix' at
>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, 7a:9b:9a:f2:94:8e
>> [   14.043868] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>> control off
>> # ping -c2  host
>> PING host (192.168.100.1) 56(84) bytes of data.
>>   From 192.168.100.20 icmp_seq=1 Destination Host Unreachable
>>   From 192.168.100.20 icmp_seq=2 Destination Host Unreachable
>>
>> --- host ping statistics ---
>> 2 packets transmitted, 0 received, +2 errors, 100% packet loss, time 59ms
>> --->8---
> Hm... it looks like different chip variant. My is registered as
> "ASIX AX88772B USB", yours is "ASIX AX88772 USB 2.0" - "B" is the
> difference. Can you please tell me more about this adapter and if possible open
> tell the real part name.
Well, currently I have only remote access to that board. The network 
chip is soldered on board. Maybe you can read something from the photo 
on the wiki page: https://en.wikipedia.org/wiki/Arndale_Board
> I can imagine that this adapter may using generic PHY driver.
> Can you please confirm it by dmesg | grep PHY?
> In my case i'll get:
> Asix Electronics AX88772C usb-001:003:10: attached PHY driver (mii_bus:phy_addr=usb-001:003:10, irq=POLL)
# dmesg | grep PHY
[    5.700274] Asix Electronics AX88772A usb-001:004:10: attached PHY 
driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
> If you have a different PHY, can you please send me the PHY id:
> cat /sys/bus/mdio_bus/devices/usb-001\:003\:10/phy_id
>
> Your usb path will probably be different.

# cat /sys/bus/mdio_bus/devices/usb-001\:004\:10/phy_id
0x003b1861

 > ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

