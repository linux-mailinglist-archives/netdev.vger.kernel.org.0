Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420B13AC945
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhFRK71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:59:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46350 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbhFRK7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:59:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210618105715euoutp016e8510edaf4d33b83f2dcf921fd0030b~Jp-qSvAOg2690626906euoutp01C
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 10:57:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210618105715euoutp016e8510edaf4d33b83f2dcf921fd0030b~Jp-qSvAOg2690626906euoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624013835;
        bh=14mZzBq8zeEE6XqUQmqsKNH8rPSubM5TvfjmOUPtFLc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jko0nR29CDY9TYzPbcd4ZsWvPDXXDD63U466tAg4CfTqx9vzGVyNPiRfpbPtYu6R3
         sQK7nX9Jh46Bju7V5xnNfl+qRDYBfGKT/L84sxkcNYptCS81ZV4/4lsfOuA/xvcXwF
         yVHhC5C1me9xchz9W4/lN67YsTusnnk/UJgsQLoY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210618105715eucas1p18c1831fe5e492ffdf94d8a3bafae5a32~Jp-qCxABS1763917639eucas1p1s;
        Fri, 18 Jun 2021 10:57:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id FE.E6.42068.A0C7CC06; Fri, 18
        Jun 2021 11:57:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210618105714eucas1p19cb74b673ce2cc0be01d4cf3b64f3eb3~Jp-ppNfgA1778817788eucas1p1n;
        Fri, 18 Jun 2021 10:57:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210618105714eusmtrp16c15e084132194a6cc3cff3c8c55b6d2~Jp-pobdee1675616756eusmtrp1z;
        Fri, 18 Jun 2021 10:57:14 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-da-60cc7c0aa2b9
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 5A.D0.20981.A0C7CC06; Fri, 18
        Jun 2021 11:57:14 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210618105713eusmtip2356b062a76f2d63442eb3597b0042d24~Jp-pBpILJ1581515815eusmtip2t;
        Fri, 18 Jun 2021 10:57:13 +0000 (GMT)
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <b3b990b5-d2f6-3e93-effd-44e10c5dfb5e@samsung.com>
Date:   Fri, 18 Jun 2021 12:57:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <460f971e-fbae-8d3d-ae8e-ed90bbebda4d@samsung.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7djP87pcNWcSDGa9t7Q4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD2KyyYlNSezLLVI3y6BK+NM+0TWgk0yFXsvfmRu
        YFwl3sXIySEhYCLxe+klVhBbSGAFo0TnBP0uRi4g+wujRMuqr6wQzmdGiYZzR1hhOm7+3sEC
        kVjOKHG06QQTRPtHRom/TxW7GDk4hAWCJJYfDAIJswkYSnS97WIDsUUEdCQat6wHG8ossJJJ
        YuKnHUwg9bwCdhItk2VAalgEVCUuXD7LCGKLCiRLvJ83A2wvr4CgxMmZT1hAbE4Be4nVe5aB
        2cwC8hLNW2czQ9jiEreezGcCmS8h0MwpMadzAiPE0S4SJ678ZIOwhSVeHd/CDmHLSJye3MMC
        1cAo8fDcWnYIp4dR4nLTDKhua4k7536xgVzKLKApsX6XPkTYUWLGihYWkLCEAJ/EjbeCEEfw
        SUzaNp0ZIswr0dEmBFGtJjHr+Dq4tQcvXGKewKg0C8lrs5C8MwvJO7MQ9i5gZFnFKJ5aWpyb
        nlpslJdarlecmFtcmpeul5yfu4kRmKxO/zv+ZQfj8lcf9Q4xMnEwHmKU4GBWEuHlzDyTIMSb
        klhZlVqUH19UmpNafIhRmoNFSZw3acuaeCGB9MSS1OzU1ILUIpgsEwenVAMTS+k5hhnh+yV2
        LTdLPbG+do9OzuV+HeacN248jOdCORf3HWGIeJsdvPnUH+MvEnuS3vI+6T4dnvVkk4z19foP
        547+vCx2SSp6uuDKJU559+oMT/wqOvgzVFny2XvBh3Pe93seqq98KvHx3s+PHbUerceLr6Zz
        HLYpXLB3f6bgjKl2VxXdDi4pZ+D47fS8xynrqsCpUKaZlu3bHjsa5ai3Hpz2O7j9ySnNJf+k
        +4JWlVpwzTVauyT60JKnU7ZfPVvY/6Z+xry5zOyflrtPDpl4wly58+8/jzOPPhQJMJ1o+tX9
        fueZ1UU3ZV/kG7zo8elZetMyn+f6xOUntrvxqz1az5m7Iclr+hn1Q3fOdm1b4a/EUpyRaKjF
        XFScCABY+K4QxQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t/xe7pcNWcSDH5+l7E4f/cQs8Wc8y0s
        Fovez2C1WDV1J4vFhW19rBaXd81hs1i0rJXZ4tDUvYwWxxaIWTy5x+jA5XH52kVmjy0rbzJ5
        7Jx1l91j06pONo+dOz4zefT/NfD4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DSQs/IxFLP
        0Ng81srIVEnfziYlNSezLLVI3y5BL+NM+0TWgk0yFXsvfmRuYFwl3sXIySEhYCJx8/cOli5G
        Lg4hgaWMEruen2SFSMhInJzWAGULS/y51sUGUfSeUWLG8/NAHRwcwgJBEssPBoHUsAkYSnS9
        Banh5BAR0JFo3LKeFaSeWWA1k8T9DROZIJofMEksm9UO1swrYCfRMlkGpIFFQFXiwuWzjCC2
        qECyxM/17WCDeAUEJU7OfMICYnMK2Eus3rMMzGYWMJOYt/khM4QtL9G8dTaULS5x68l8pgmM
        QrOQtM9C0jILScssJC0LGFlWMYqklhbnpucWG+kVJ+YWl+al6yXn525iBEbotmM/t+xgXPnq
        o94hRiYOxkOMEhzMSiK8nJlnEoR4UxIrq1KL8uOLSnNSiw8xmgL9M5FZSjQ5H5gi8kriDc0M
        TA1NzCwNTC3NjJXEeU2OrIkXEkhPLEnNTk0tSC2C6WPi4JRqYPKN66j+qbDcZ5Z3+/lvKuef
        SfTsLTr6SnfWnayT11Znzjsu/e6KxQfvrtim2wVTzHqqr169t1zhakj5aa+tC9mmFijK/2eY
        kapyXmIBs+G7MI8llWcWKmpy+4pne9k/2cr1vs3bzVllj+ovuZpLfy4/2rM2Inhh2EX7jV3N
        y4I79oQX6rZdOr3Qx1pYb1JuR/P33AOd0x2ZZh5+nxig+d8n91Oef7qXFYPgpya/Uqbdl37O
        uHDHcX9qQrTz/KL6X1lZp36wf30jWpzAYj5D5NFNx53nH9v/Pv3pwi/Tch/nFY3Lr3yUurWt
        e9fsKTPPV7Vqi2jnbphStvqinWhk2I1pnL9P60lv4mnJ/RH854USS3FGoqEWc1FxIgA1hasn
        WQMAAA==
X-CMS-MailID: 20210618105714eucas1p19cb74b673ce2cc0be01d4cf3b64f3eb3
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
        <460f971e-fbae-8d3d-ae8e-ed90bbebda4d@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.06.2021 12:45, Marek Szyprowski wrote:
> On 18.06.2021 12:13, Oleksij Rempel wrote:
>> thank you for your feedback.
>>
>> On Fri, Jun 18, 2021 at 10:39:12AM +0200, Marek Szyprowski wrote:
>>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>>> To be able to use ax88772 with external PHYs and use advantage of
>>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>>> driver to the phylib framework.
>>>>
>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> I found one more issue with this patch. On one of my test boards
>>> (Samsung Exynos5250 SoC based Arndale) system fails to establish 
>>> network
>>> connection just after starting the kernel when the driver is build-in.
>>>
>>> --->8---
>>> # dmesg | grep asix
>>> [    2.761928] usbcore: registered new interface driver asix
>>> [    5.003110] asix 1-3.2.4:1.0 (unnamed net_device) (uninitialized):
>>> invalid hw address, using random
>>> [    6.065400] asix 1-3.2.4:1.0 eth0: register 'asix' at
>>> usb-12110000.usb-3.2.4, ASIX AX88772 USB 2.0 Ethernet, 
>>> 7a:9b:9a:f2:94:8e
>>> [   14.043868] asix 1-3.2.4:1.0 eth0: Link is Up - 100Mbps/Full - flow
>>> control off
>>> # ping -c2  host
>>> PING host (192.168.100.1) 56(84) bytes of data.
>>>   From 192.168.100.20 icmp_seq=1 Destination Host Unreachable
>>>   From 192.168.100.20 icmp_seq=2 Destination Host Unreachable
>>>
>>> --- host ping statistics ---
>>> 2 packets transmitted, 0 received, +2 errors, 100% packet loss, time 
>>> 59ms
>>> --->8---
>> Hm... it looks like different chip variant. My is registered as
>> "ASIX AX88772B USB", yours is "ASIX AX88772 USB 2.0" - "B" is the
>> difference. Can you please tell me more about this adapter and if 
>> possible open
>> tell the real part name.
> Well, currently I have only remote access to that board. The network 
> chip is soldered on board. Maybe you can read something from the photo 
> on the wiki page: https://en.wikipedia.org/wiki/Arndale_Board
>> I can imagine that this adapter may using generic PHY driver.
>> Can you please confirm it by dmesg | grep PHY?
>> In my case i'll get:
>> Asix Electronics AX88772C usb-001:003:10: attached PHY driver 
>> (mii_bus:phy_addr=usb-001:003:10, irq=POLL)
> # dmesg | grep PHY
> [    5.700274] Asix Electronics AX88772A usb-001:004:10: attached PHY 
> driver (mii_bus:phy_addr=usb-001:004:10, irq=POLL)
>> If you have a different PHY, can you please send me the PHY id:
>> cat /sys/bus/mdio_bus/devices/usb-001\:003\:10/phy_id
>>
>> Your usb path will probably be different.
>
> # cat /sys/bus/mdio_bus/devices/usb-001\:004\:10/phy_id
> 0x003b1861
>
> > ...

Just for the record, I also have a board with external USB Ethernet 
dongle based on ASIX chip, which works fine with this patch, both when 
driver is built-in or as a module. Here is the log:

# dmesg | grep -i Asix
[    1.718349] usbcore: registered new interface driver asix
[    2.608596] usb 3-1: Manufacturer: ASIX Elec. Corp.
[    3.876279] libphy: Asix MDIO Bus: probed
[    3.958105] Asix Electronics AX88772C usb-003:002:10: attached PHY 
driver (mii_bus:phy_addr=usb-003:002:10, irq=POLL)
[    3.962728] asix 3-1:1.0 eth0: register 'asix' at 
usb-xhci-hcd.6.auto-1, ASIX AX88772B USB 2.0 Ethernet, 00:50:b6:18:92:f0
[   17.488532] asix 3-1:1.0 eth0: Link is Down
[   19.557233] asix 3-1:1.0 eth0: Link is Up - 100Mbps/Full - flow 
control off

# cat /sys/bus/mdio_bus/devices/usb-003\:002\:10/phy_id
0x003b1881


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

