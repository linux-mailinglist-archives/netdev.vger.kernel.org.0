Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA13A2962
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFJKdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:33:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40472 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhFJKdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:33:31 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210610103131euoutp0217d27655092fc034fa499dfa3c8033d3~HMe6SBAn01803418034euoutp02o
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:31:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210610103131euoutp0217d27655092fc034fa499dfa3c8033d3~HMe6SBAn01803418034euoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623321091;
        bh=imHj3dPSvsNM+s/qIGCD4AsThUq1ngL1OkwnCaxkWec=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=IiPvFjJNs4TyFwaEqB6Gux5Rktx1OTcTRNL8uqUdH3M5u+7w4q4wM0I0Kqp650J4N
         UNpKETPr1431V0oBe4yGLuIlSCXFYESFf4FgehCMkv8LM+4vpufri+EQNu/mENaoYi
         0KkqaPlCAh7UKy8DC8Ip6rBJPWN7MBtaIN2nF7vw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210610103130eucas1p20b3b618c3fb4a19289f26dee4a87dc32~HMe5v-8O22546025460eucas1p2i;
        Thu, 10 Jun 2021 10:31:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 66.0B.09439.20AE1C06; Thu, 10
        Jun 2021 11:31:30 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210610103130eucas1p1fbd2c6489e7f26a0b98167110de455ac~HMe5ETsUF1097110971eucas1p15;
        Thu, 10 Jun 2021 10:31:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210610103130eusmtrp13caa79670a0c4e4c687fc0dd649cac20~HMe5DXUnB3064130641eusmtrp1U;
        Thu, 10 Jun 2021 10:31:30 +0000 (GMT)
X-AuditID: cbfec7f5-c03ff700000024df-92-60c1ea020e0c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id D3.88.08705.10AE1C06; Thu, 10
        Jun 2021 11:31:30 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210610103129eusmtip1bbcb09b2588b79d6b55f1a72570d5ae9~HMe4ZVQ2O1168511685eusmtip1U;
        Thu, 10 Jun 2021 10:31:29 +0000 (GMT)
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
Message-ID: <6b90f8ef-6d86-68a6-690d-d5255b6308df@samsung.com>
Date:   Thu, 10 Jun 2021 12:31:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210609124609.zngg6sfcu6cj4p2m@pengutronix.de>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsWy7djPc7pMrw4mGExeoWlx/u4hZos551tY
        LBa9n8FqsWrqThaLC9v6WC0u75rDZrFoWSuzxaGpexktji0Qs3hyj9GBy+PytYvMHltW3mTy
        2DnrLrvHplWdbB47d3xm8uj/a+DxeZNcAHsUl01Kak5mWWqRvl0CV8btk/cZC/ZZVnxbuJGx
        gfGvfhcjJ4eEgInEw2XnWbsYuTiEBFYwShze3s8I4XxhlGif2MwM4XxmlHj36h8LTMuOySuh
        WpYzSrx4dZIFwvnIKPH68RO2LkYODmGBIInlB4NAGkQEdCQat6wHa2AWWMkkMfHTDiaQBJuA
        oUTX2y42EJtXwE7iyKu1rCC9LAKqEj9uloKYogLJEr836kJUCEqcnPmEBSTMKWArcf1OHEiY
        WUBeonnrbGYIW1zi1pP5TCCbJAT+c0hMn3mWGeJmF4mnt2+yQdjCEq+Ob2GHsGUkTk/uYYFo
        aGaUeHhuLTuE08MocblpBiNElbXEnXO/wP5iFtCUWL8LGnaOErtvvQI7WUKAT+LGW0GII/gk
        Jm2bzgwR5pXoaBOCqFaTmHV8HdzagxcuMU9gVJqF5LNZSN6ZheSdWQh7FzCyrGIUTy0tzk1P
        LTbOSy3XK07MLS7NS9dLzs/dxAhMVqf/Hf+6g3HFq496hxiZOBgPMUpwMCuJ8JYZ7ksQ4k1J
        rKxKLcqPLyrNSS0+xCjNwaIkzrtr65p4IYH0xJLU7NTUgtQimCwTB6dUA5OCzsac56eTjk+t
        sPtprrMkj1HwgO/iVfs5pRJ+K5um6p++MVmniJEtXinWwHPxdpt4s9miH15pVHdv2Og874GJ
        29GezBv1XGI2OnU6t27/vh97kTm7L2Gf9Eved+s+HFPaHddzqDwyKWRaQu+ZPc8PbP8bFWzA
        zREdM3+KsvStUifR2TXNDyO+KSxrCpku+o5v6oN9tjO5udYE6IUnMT2wv8jt/7o0Zlaew/M6
        gVNFrk//Hj/O9PfMKoH7a84JL5f/cpdX6gW/me0m4aWrJDQyy4qEGNiftW3Y865X5ZGuudL7
        rfv1DPzF/28+eVLC3Tt9m7yq7O/+8DmpG/cvccyoWm3/z/9Tx5mfbL2Fc5RYijMSDbWYi4oT
        AbHa9+XFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t/xu7pMrw4mGFwrtjh/9xCzxZzzLSwW
        i97PYLVYNXUni8WFbX2sFpd3zWGzWLSsldni0NS9jBbHFohZPLnH6MDlcfnaRWaPLStvMnns
        nHWX3WPTqk42j507PjN59P818Pi8SS6APUrPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q
        2DzWyshUSd/OJiU1J7MstUjfLkEv4/bJ+4wF+ywrvi3cyNjA+Fe/i5GTQ0LARGLH5JWsXYxc
        HEICSxklNhyeywaRkJE4Oa2BFcIWlvhzrYsNoug9o8SsPVfYuxg5OIQFgiSWHwwCqRER0JFo
        3LIebBCzwGomifsbJjJBNAA5R78fZgepYhMwlOh62wW2gVfATuLIq7WsIINYBFQlftwsBQmL
        CiRLbGj/zwpRIihxcuYTFpASTgFbiet34kDCzAJmEvM2P2SGsOUlmrfOhrLFJW49mc80gVFo
        FpLuWUhaZiFpmYWkZQEjyypGkdTS4tz03GJDveLE3OLSvHS95PzcTYzA6Nx27OfmHYzzXn3U
        O8TIxMF4iFGCg1lJhLfMcF+CEG9KYmVValF+fFFpTmrxIUZToG8mMkuJJucD00NeSbyhmYGp
        oYmZpYGppZmxkjjv1rlr4oUE0hNLUrNTUwtSi2D6mDg4pRqYOhdvUfV9OTPJTLBz+4fwZBvb
        pPueooWN54xF12zYc0m7uKnjvPK53oqYf9aH+qYxmG89Kupz6Og/kbpqWTXGncV/tqt2C3y4
        mPxz02f2hMvdDnc2KgrWPvdI35BTWrkoMWSdiVDqOtYo7dcPHj97a5leuUpYJPpZrbJxu5SZ
        xbwrXg12ffu9rget3Xqia0cL+wKJoGMxSmzHbQ35xVQuaKn8iLO691Y09Qr34/drn9+uZZ81
        +0zdaYN8t8oT7E+i0nZdPtz7pyTtsmlg3wK+3NPC31Yvigy/uyfsyvK9c7++S7i1/KxDM+Pz
        kvsrP/5u2MMsvrRtz8ndeka3X0/NXsxnccXy0M4rj/24Nij/UWIpzkg01GIuKk4EADZbBCVX
        AwAA
X-CMS-MailID: 20210610103130eucas1p1fbd2c6489e7f26a0b98167110de455ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210609095923eucas1p2e692c9a482151742d543316c91f29802
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210609095923eucas1p2e692c9a482151742d543316c91f29802
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
        <20210607082727.26045-5-o.rempel@pengutronix.de>
        <CGME20210609095923eucas1p2e692c9a482151742d543316c91f29802@eucas1p2.samsung.com>
        <84ff1dab-ab0a-f27c-a948-e1ebdf778485@samsung.com>
        <20210609124609.zngg6sfcu6cj4p2m@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 09.06.2021 14:46, Oleksij Rempel wrote:
> On Wed, Jun 09, 2021 at 11:59:23AM +0200, Marek Szyprowski wrote:
>> On 07.06.2021 10:27, Oleksij Rempel wrote:
>>> To be able to use ax88772 with external PHYs and use advantage of
>>> existing PHY drivers, we need to port at least ax88772 part of asix
>>> driver to the phylib framework.
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> This patch landed recently in linux-next as commit e532a096be0e ("net:
>> usb: asix: ax88772: add phylib support"). I found that it causes some
>> warnings on boards with those devices, see the following log:
>>
>> root@target:~# time rtcwake -s10 -mmem
>> rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:16:41 2021
>> [  231.226579] PM: suspend entry (deep)
>> [  231.231697] Filesystems sync: 0.002 seconds
>> [  231.261761] Freezing user space processes ... (elapsed 0.002 seconds)
>> done.
>> [  231.270526] OOM killer disabled.
>> [  231.273557] Freezing remaining freezable tasks ... (elapsed 0.002
>> seconds) done.
>> [  231.282229] printk: Suspending console(s) (use no_console_suspend to
>> debug)
>> ...
>> [  231.710852] Disabling non-boot CPUs ...
>> ...
>> [  231.901794] Enabling non-boot CPUs ...
>> ...
>> [  232.225640] usb usb3: root hub lost power or was reset
>> [  232.225746] usb usb1: root hub lost power or was reset
>> [  232.225864] usb usb5: root hub lost power or was reset
>> [  232.226206] usb usb6: root hub lost power or was reset
>> [  232.226207] usb usb4: root hub lost power or was reset
>> [  232.297749] usb usb2: root hub lost power or was reset
>> [  232.343227] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  232.343293] asix 3-1:1.0 eth0: Failed to enable software MII access
>> [  232.344486] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
>> [  232.344512] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  232.344529] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x78
>> returns -22
>> [  232.344554] Asix Electronics AX88772C usb-003:002:10: PM: failed to
>> resume: error -22
>> [  232.563712] usb 1-1: reset high-speed USB device number 2 using
>> exynos-ehci
>> [  232.757653] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
>> [  233.730994] OOM killer enabled.
>> [  233.734122] Restarting tasks ... done.
>> [  233.754992] PM: suspend exit
>>
>> real    0m11.546s
>> user    0m0.000s
>> sys     0m0.530s
>> root@target:~# sleep 2
>> root@target:~# time rtcwake -s10 -mmem
>> rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:17:02 2021
>> [  241.959608] PM: suspend entry (deep)
>> [  241.963446] Filesystems sync: 0.001 seconds
>> [  241.978619] Freezing user space processes ... (elapsed 0.004 seconds)
>> done.
>> [  241.989199] OOM killer disabled.
>> [  241.992215] Freezing remaining freezable tasks ... (elapsed 0.005
>> seconds) done.
>> [  242.003979] printk: Suspending console(s) (use no_console_suspend to
>> debug)
>> ...
>> [  242.592030] Disabling non-boot CPUs ...
>> ...
>> [  242.879721] Enabling non-boot CPUs ...
>> ...
>> [  243.145870] usb usb3: root hub lost power or was reset
>> [  243.145910] usb usb4: root hub lost power or was reset
>> [  243.147084] usb usb5: root hub lost power or was reset
>> [  243.147157] usb usb6: root hub lost power or was reset
>> [  243.147298] usb usb1: root hub lost power or was reset
>> [  243.217137] usb usb2: root hub lost power or was reset
>> [  243.283807] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  243.284005] asix 3-1:1.0 eth0: Failed to enable software MII access
>> [  243.285526] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
>> [  243.285676] asix 3-1:1.0 eth0: Failed to read reg index 0x0004: -22
>> [  243.285769] ------------[ cut here ]------------
>> [  243.286011] WARNING: CPU: 2 PID: 2069 at drivers/net/phy/phy.c:916
>> phy_error+0x28/0x68
>> [  243.286115] Modules linked in: cmac bnep mwifiex_sdio mwifiex
>> sha256_generic libsha256 sha256_arm cfg80211 btmrvl_sdio btmrvl
>> bluetooth s5p_mfc uvcvideo s5p_jpeg exynos_gsc v
>> [  243.287490] CPU: 2 PID: 2069 Comm: kworker/2:5 Not tainted
>> 5.13.0-rc5-next-20210608 #10443
>> [  243.287555] Hardware name: Samsung Exynos (Flattened Device Tree)
>> [  243.287609] Workqueue: events_power_efficient phy_state_machine
>> [  243.287716] [<c0111920>] (unwind_backtrace) from [<c010d0cc>]
>> (show_stack+0x10/0x14)
>> [  243.287807] [<c010d0cc>] (show_stack) from [<c0b62360>]
>> (dump_stack_lvl+0xa0/0xc0)
>> [  243.287882] [<c0b62360>] (dump_stack_lvl) from [<c0127960>]
>> (__warn+0x118/0x11c)
>> [  243.287954] [<c0127960>] (__warn) from [<c0127a18>]
>> (warn_slowpath_fmt+0xb4/0xbc)
>> [  243.288021] [<c0127a18>] (warn_slowpath_fmt) from [<c0734968>]
>> (phy_error+0x28/0x68)
>> [  243.288094] [<c0734968>] (phy_error) from [<c0735d6c>]
>> (phy_state_machine+0x218/0x278)
>> [  243.288173] [<c0735d6c>] (phy_state_machine) from [<c014ae08>]
>> (process_one_work+0x30c/0x884)
>> [  243.288254] [<c014ae08>] (process_one_work) from [<c014b3d8>]
>> (worker_thread+0x58/0x594)
>> [  243.288333] [<c014b3d8>] (worker_thread) from [<c0153944>]
>> (kthread+0x160/0x1c0)
>> [  243.288408] [<c0153944>] (kthread) from [<c010011c>]
>> (ret_from_fork+0x14/0x38)
>> [  243.288475] Exception stack(0xc4683fb0 to 0xc4683ff8)
>> [  243.288531] 3fa0:                                     00000000
>> 00000000 00000000 00000000
>> [  243.288587] 3fc0: 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000 00000000
>> [  243.288641] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
>> [  243.288690] irq event stamp: 1611
>> [  243.288744] hardirqs last  enabled at (1619): [<c01a6ef0>]
>> vprintk_emit+0x230/0x290
>> [  243.288830] hardirqs last disabled at (1626): [<c01a6f2c>]
>> vprintk_emit+0x26c/0x290
>> [  243.288906] softirqs last  enabled at (1012): [<c0101768>]
>> __do_softirq+0x500/0x63c
>> [  243.288978] softirqs last disabled at (1007): [<c01315b4>]
>> irq_exit+0x214/0x220
>> [  243.289055] ---[ end trace eeacda95eb7db60a ]---
>> [  243.289345] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
>> [  243.289466] asix 3-1:1.0 eth0: Failed to write Medium Mode mode to
>> 0x0000: ffffffea
>> [  243.289540] asix 3-1:1.0 eth0: Link is Down
>> [  243.482809] usb 1-1: reset high-speed USB device number 2 using
>> exynos-ehci
>> [  243.647251] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
>> [  244.847161] OOM killer enabled.
>> [  244.850221] Restarting tasks ... done.
>> [  244.861372] PM: suspend exit
>>
>> real    0m13.050s
>> user    0m0.000s
>> sys     0m1.152s
>> root@target:~#
>>
>> It looks that some kind of system suspend/resume integration for phylib
>> is not implemented.
> Probably it is should be handled only by the asix driver. I'll take a
> look in to it. Did interface was able to resume after printing some
> warnings?

Nope. The network is not operational after suspend/resume cycle after 
applying this patch.

Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

