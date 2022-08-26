Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47B25A2300
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343604AbiHZI3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiHZI3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:29:13 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34312C275A
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:29:12 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220826082910euoutp02048a7f7e3818d7889b38ff622e90ffd6~O18RSPYvR0199601996euoutp02R
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 08:29:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220826082910euoutp02048a7f7e3818d7889b38ff622e90ffd6~O18RSPYvR0199601996euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661502550;
        bh=Dqk2R4KIJNveyE1KVpN9C9E70yVLb5LIzzAZTlB6zGs=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=YqhtRC2sKARV2tGpkwwqxq2NBpFr6A0dJzmMcyVk6FTFbMp7Nv8ucj0lFw8fuFLHz
         UjTzADIAwGduG3xkHZemLDNe4RIIG9kUx/XSFb1ZfIyKtmbwyl1HTqWBMKBDZMrn0p
         3QWHoedWvf2e/HZEPbx2Bw5kChbOFDGA3SchWjRQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220826082909eucas1p28f88f976db2c2f04de00dbb78e519749~O18QiL8jS1184711847eucas1p2K;
        Fri, 26 Aug 2022 08:29:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id E5.F3.07817.55488036; Fri, 26
        Aug 2022 09:29:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220826082909eucas1p135890661d5bc18bc2a9887a561ce785f~O18P8rkyR2427724277eucas1p1H;
        Fri, 26 Aug 2022 08:29:09 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220826082909eusmtrp2bfbe3e5bf067af840f7093d537e5c4e1~O18P6cXja0067100671eusmtrp23;
        Fri, 26 Aug 2022 08:29:09 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-2a-63088455a28c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id AD.B9.07473.55488036; Fri, 26
        Aug 2022 09:29:09 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220826082908eusmtip11cd40b4ca07a7e0d5ac292dc775ea348~O18OxgXsf0432204322eusmtip1H;
        Fri, 26 Aug 2022 08:29:08 +0000 (GMT)
Message-ID: <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
Date:   Fri, 26 Aug 2022 10:29:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220826075331.GA32117@wunner.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHd+69vX1ZSi7VyQkSl5UMU+daZSQ7DsZsMOEyTeY+qNNlm125
        o2TQkpY6MDEjVAwruAGCYFdnB1JGbcDxUkFiVyspTnG1Q93KRAFbJTDKKs0qzJetXLbx7ff8
        n9f/yeHhIjOZyMtXFzNataJATAoIh2fB++quwzzlppaQFJmP+LnIO+bG0X3/KInM3sMECnom
        uejRN5dI5G0sx1HzXBMHeb1nuei640sOCpyxYqjJ68RQs7UCR+6GCwANRmwEmnqwFo37jATy
        WNYg4712ElkqggT68+rvABkeTmPor1ofuTWBHrnlw+m+sdOA7mn3Y3S/aYxL/xH+kLZ06elg
        zTEu3WX7gqQH/ROA7u+bx+jbj1oBPee8SdL+0DROPzOMEHRnz02Cnu9at1O0T5CRyxTkH2C0
        ssz9AlXkKL/owaaSe77ny0CFxAj4PEilwaMttbgRCHgi6jsAzx2fJdkgAuD3d5wYG8wDaHFX
        co2At9RSaeawehuAi47F5SAMYHT8KYjNFVKZ0DrcjseYoF6G4cool9Xj4Y8nAkSMX6CU0OTx
        LNWvotRwxm/jxBinEuBo4BQW49WUGJbXh5auwKm7JAx3X1lKkNRmaJw1kjHmUzJ4vD+Ksc0v
        QkPv1zhr7qQADiweZHkbXHgS4rC8Ck4P9XBZToLP+mPLYs408EnTa6xcAm/N2JfHpMPbPy2S
        sRKcksDO8zJWlsOw6w7OdsbBX2fj2QPiYJ2jcVkWwsojIrY6BZqGOv7befH6z3gNEJtWvIlp
        hXfTCium//daAGEDCYxeV5jH6FLVzGdSnaJQp1fnSZWawi7wzwe++nQo0gfapsNSN8B4wA0g
        DxevFr7hIZQiYa6i9CCj1Xyk1RcwOjdYyyPECUJl/lmFiMpTFDOfMkwRo/03i/H4iWWY5NBv
        ydESUVZt1YbxvYegQZI2sb7+hy2NLRk7U1pBkj3kG6jpTuVbknfLkttypg583jmXF8eddLy9
        0XytzHJar8kdTc8O1MmB67L1fHe0+J3J93uyoxNJZzz3sYcfZ60ZSAsOpk79cqNZ5bfOuDzO
        4ZSc56KhHSr75MhbLSov5z2byik+eUOuLDNu9Whe2t6+Z3v2u6fOpZfG0XUdX2U277nIB1n2
        wN4r9ZbR6mjdujdbvdc+2Y/5X6FlDZelHZJ9zkx7eW+k1qDNkPXGK6sMd6trPtj2rVE+07f+
        cXmGpMG9JTVRHi7NIYYXvNSO6qpLrguPgxtdhqJj6a/nRuxiQqdSbN6Aa3WKvwGW41wELwQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t/xu7qhLRzJBkdaOSzmtN1ktzh/9xCz
        xbObt9gs5pxvYbF4euwRu8WPeYfZLM5Pb2K2WPR+BqvF+fMb2C0ubOtjtXiyehmTxYzz+5gs
        Fi1rZbY4NHUvo8WRL6tYLF48l7Z4cLGLxeLYAjGLrscr2SwWtD5lsfh2+g2jRfOnV0wWvyde
        ZHMQ97h87SKzx467Sxg9tqy8yeSxc9Zddo8PH+M8Fmwq9Xg6YTK7x6ZVnWweR24+ZPTYueMz
        k8edH0sZPd7vu8rmcfPdK2aP/82XWTzWb7nK4vF5k1yAUJSeTVF+aUmqQkZ+cYmtUrShhZGe
        oaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZapG+XYJexpdezoLnBhWPL3I3MLZqdjFycEgImEh0
        zGHtYuTiEBJYyiixff5KIIcTKC4jcXJaA5QtLPHnWhcbRNF7RomHFxcwgSR4Bewklp1ZyQxi
        swioSnzs+M4OEReUODnzCQuILSqQLLGk4T7YIGGBPInTzW/AbGYBcYlbT+aDzRERUJJomvKO
        CWQBs8BjNokJX2eCDRISmMoi0bbYEMRmEzCU6HoLcgUnB6eAvsS0nd+ZIAaZSXRt7WKEsOUl
        mrfOZp7AKDQLyR2zkOybhaRlFpKWBYwsqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQLTzrZj
        PzfvYJz36qPeIUYmDsZDjBIczEoivFbHWJKFeFMSK6tSi/Lji0pzUosPMZoCA2Mis5Rocj4w
        8eWVxBuaGZgamphZGphamhkrifN6FnQkCgmkJ5akZqemFqQWwfQxcXBKNTDxmQitD2mofJB/
        3W3xt4T3P1VNNog6fF5xxchs0krDzSf27VNw/5rFv6wiqzqoOuO/xcQUO5F/4v1CM1zvsnIZ
        Cko9/bnGIdBlldj2ksLzZziKuP2ZzrvXROxfFnpSfc6C438Lnzmkx/S8fPhqwjK1zxvWhFek
        mx/h/6Vfwr+9o4Cr2vxpFHdHLLPR5NwJjzlmx1lJPMu50TTn+94pe/7PnnnU44nhTdVX/bOq
        4r5ujZdV4TjIct/0ezGb+oN5wsnlC5dYOduFtzYv1PO653PNRbjvVE/Ul9o1piFp/ccv53av
        cnijeIDZz9ci5so3L9aew7nMCe4Oss6dD2aYh/eXZnzasp/NhqNYJ/H+HSWW4oxEQy3mouJE
        AFGQiwbEAwAA
X-CMS-MailID: 20220826082909eucas1p135890661d5bc18bc2a9887a561ce785f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
References: <cover.1652343655.git.lukas@wunner.de>
        <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
        <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
        <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
        <20220519190841.GA30869@wunner.de>
        <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
        <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
        <20220826071924.GA21264@wunner.de>
        <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
        <20220826075331.GA32117@wunner.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 26.08.2022 09:53, Lukas Wunner wrote:
> On Fri, Aug 26, 2022 at 09:41:46AM +0200, Marek Szyprowski wrote:
>> On 26.08.2022 09:19, Lukas Wunner wrote:
>>> On Fri, Aug 26, 2022 at 08:51:58AM +0200, Marek Szyprowski wrote:
>>>> On 19.05.2022 23:22, Marek Szyprowski wrote:
>>>>> On 19.05.2022 21:08, Lukas Wunner wrote:
>>>>>> On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
>>>>>>> This patch landed in the recent linux next-20220516 as commit
>>>>>>> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY
>>>>>>> driver to
>>>>>>> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet
>>>>>>> operation
>>>>>>> after system suspend-resume cycle. On the Odroid XU3 board I got the
>>>>>>> following warning in the kernel log:
>>>>>>>
>>>>>>> # time rtcwake -s10 -mmem
>>>>>>> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
>>>>>>> PM: suspend entry (deep)
>>>>>>> Filesystems sync: 0.001 seconds
>>>>>>> Freezing user space processes ... (elapsed 0.002 seconds) done.
>>>>>>> OOM killer disabled.
>>>>>>> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>>>>>>> printk: Suspending console(s) (use no_console_suspend to debug)
>>>>>>> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
>>>>>>> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
>>>>>>> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
>>>>>>> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
>>>>>>> ------------[ cut here ]------------
>>>>>>> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
>>>>>>> phy_state_machine+0x98/0x28c
>>>>>> [...]
>>>>>>> It looks that the driver's suspend/resume operations might need some
>>>>>>> adjustments. After the system suspend/resume cycle the driver is not
>>>>>>> operational anymore. Reverting the $subject patch on top of linux
>>>>>>> next-20220516 restores ethernet operation after system suspend/resume.
>>>>>> Thanks a lot for the report. It seems the PHY is signaling a link
>>>>>> change
>>>>>> shortly before system sleep and by the time the phy_state_machine()
>>>>>> worker
>>>>>> gets around to handle it, the device has already been suspended and thus
>>>>>> refuses any further USB requests with -EHOSTUNREACH (-113):
>>> [...]
>>>>>> Assuming the above theory is correct, calling phy_stop_machine()
>>>>>> after usbnet_suspend() would be sufficient to fix the issue.
>>>>>> It cancels the phy_state_machine() worker.
>>>>>>
>>>>>> The small patch below does that. Could you give it a spin?
>>>>> That's it. Your analysis is right and the patch fixes the issue. Thanks!
>>>>>
>>>>> Feel free to add:
>>>>>
>>>>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>>
>>>>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>> Gentle ping for the final patch...
>>> Hm?  Actually this issue is supposed to be fixed by mainline commit
>>> 1758bde2e4aa ("net: phy: Don't trigger state machine while in suspend").
>>>
>>> The initial fix attempt that you're replying to should not be necessary
>>> with that commit.
>>>
>>> Are you still seeing issues even with 1758bde2e4aa applied?
>>> Or are you maybe using a custom downstream tree which is missing that commit?
>> On Linux next-20220825 I still get the following warning during
>> suspend/resume cycle:
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1483 at drivers/net/phy/phy_device.c:323
>> mdio_bus_phy_resume+0x10c/0x110
>> Modules linked in: exynos_gsc s5p_jpeg s5p_mfc videobuf2_dma_contig
>> v4l2_mem2mem videobuf2_memops videobuf2_v4l2 videobuf2_common videodev
>> mc s5p_cec
>> CPU: 0 PID: 1483 Comm: rtcwake Not tainted 6.0.0-rc2-next-20220825 #5482
>> Hardware name: Samsung Exynos (Flattened Device Tree)
>>    unwind_backtrace from show_stack+0x10/0x14
>>    show_stack from dump_stack_lvl+0x58/0x70
>>    dump_stack_lvl from __warn+0xc8/0x220
>>    __warn from warn_slowpath_fmt+0x5c/0xb4
>>    warn_slowpath_fmt from mdio_bus_phy_resume+0x10c/0x110
>>    mdio_bus_phy_resume from dpm_run_callback+0x94/0x208
>>    dpm_run_callback from device_resume+0x124/0x21c
>>    device_resume from dpm_resume+0x108/0x278
>>    dpm_resume from dpm_resume_end+0xc/0x18
>>    dpm_resume_end from suspend_devices_and_enter+0x208/0x70c
>>    suspend_devices_and_enter from pm_suspend+0x364/0x430
>>    pm_suspend from state_store+0x68/0xc8
>>    state_store from kernfs_fop_write_iter+0x110/0x1d4
>>    kernfs_fop_write_iter from vfs_write+0x1c4/0x2ac
>>    vfs_write from ksys_write+0x5c/0xd4
>>    ksys_write from ret_fast_syscall+0x0/0x1c
>> Exception stack(0xf2ee5fa8 to 0xf2ee5ff0)
>> 5fa0:                   00000004 0002b438 00000004 0002b438 00000004
>> 00000000
>> 5fc0: 00000004 0002b438 000291b0 00000004 0002b438 00000004 befd9c1c
>> 00028160
>> 5fe0: 0000006c befd9ae8 b6eb4148 b6f118a4
>> irq event stamp: 58381
>> hardirqs last  enabled at (58393): [<c019ff28>] vprintk_emit+0x320/0x344
>> hardirqs last disabled at (58400): [<c019fedc>] vprintk_emit+0x2d4/0x344
>> softirqs last  enabled at (58258): [<c0101694>] __do_softirq+0x354/0x618
>> softirqs last disabled at (58247): [<c012dd18>] __irq_exit_rcu+0x140/0x1ec
>> ---[ end trace 0000000000000000 ]---
>>
>> The mentioned patch fixes it.
> Color me confused.
>
> With "the mentioned patch", are you referring to 1758bde2e4aa
> or are you referring to the little test patch in this e-mail:
> https://lore.kernel.org/netdev/20220519190841.GA30869@wunner.de/
>
> There's a Tested-by from you on 1758bde2e4aa, so I assume the
> commit fixed the issue at the time.  Does it still occur
> intermittently?  Or does it occur every time?  In the latter case,
> I'd assume some other change was made in the meantime and that
> other change exposed the issue again...

The issue seems to be exposed again. On 1758bde2e4aa everything works 
fine and there is no warning during suspend/resume cycle. Then I've 
noticed that warning again while playing with current linux-next. I will 
check when it got broken and report again.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

