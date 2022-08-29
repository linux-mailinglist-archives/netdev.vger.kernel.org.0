Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BAC5A4C9A
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiH2M4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiH2M4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:56:19 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC28647EA
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:47:36 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220829114007euoutp02c53500b847e1ceb0e5dba3a1759dd7cb~Pze14zIg-1161911619euoutp02o
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 11:40:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220829114007euoutp02c53500b847e1ceb0e5dba3a1759dd7cb~Pze14zIg-1161911619euoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661773207;
        bh=NlqnfmZPhIiAdSmb9e1tnBpfqs2Sfxg+RXt9PT2NbdI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=k7k8e2kHm7hQZoyDkbAtgAtfK8ttrUxLfGH4+CK/cG1/zjyRCgXhP/zq5l9GAXrTH
         RFXb6Z4ePwRfat1/Wot0mvfZ3QUXBXc3UBS+g4AI/M/arshPpgPlBcXGEeHEG2WzKx
         aV9Hkge6FpcpDq38WNN/Ksi83TwE1mU9tAQmmMVo=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220829114006eucas1p11544e8406d01d1ef573721a720a0bddd~Pze1XjFMy0273902739eucas1p1Q;
        Mon, 29 Aug 2022 11:40:06 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 61.48.07817.695AC036; Mon, 29
        Aug 2022 12:40:06 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220829114006eucas1p241acc35b524d14bfa56df07728107b80~Pze06s5q-1877718777eucas1p2a;
        Mon, 29 Aug 2022 11:40:06 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220829114006eusmtrp24b545145fe5fe5da0de822eac1a0f62d~Pze05sPxt1996519965eusmtrp2D;
        Mon, 29 Aug 2022 11:40:06 +0000 (GMT)
X-AuditID: cbfec7f4-8abff70000011e89-66-630ca596ea3a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 64.2B.07473.695AC036; Mon, 29
        Aug 2022 12:40:06 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220829114005eusmtip282cf831be81fa79a13531e2049fcbeff~Pzez3m_1G2289322893eusmtip2X;
        Mon, 29 Aug 2022 11:40:05 +0000 (GMT)
Message-ID: <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
Date:   Mon, 29 Aug 2022 13:40:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
From:   Marek Szyprowski <m.szyprowski@samsung.com>
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
In-Reply-To: <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTGfe+9vfdCVnatur5BZEsXmbgJ4tzybgIbzi03M8btn21hYayp
        Ny0btKQtQ53ZDN820yATLBciCAqjOMr46KBxDDsoQx0FCY4Suikf1YB8lFLxY9RZrm789zvP
        eU6ec968NC6pJEPpFLWe06rlqTIymLDY7zu2lZx/RrF9/kQkKs9zUsjhsuHI7RwhUbkjh0CT
        9jEK3TvzG4kcp7NwVDVnFCGHo5FC/ZYTIjRRX4Mho6MDQ1U1uTiyFf8CUNeiiUC3b21ENwYM
        BLJXPocM43UkqsydJNDdK3cAyl6YwtDDkwPk21J28PoAzra5zgG2pc6Jse28i2LnPZ+xlU0Z
        7GTh9xTbZDpGsl3Om4Btb/Ni7Oi984Cd6xgiWefsFM4+yh4kWHPLEMF6m8I/kCQGxx7gUlO+
        4rTR8Z8HqxoWhqj04TcOVhQ/FB0F3dsNIIiGzE54crZaZADBtIT5AcBrJgshFIsAZpU3Pym8
        ABaeqyefjox2XqaERi2Afj6HFAoPgLYiNxVwiZl4mOvtxAJMMJvhreVJTNDXwt7SCSLAGxgF
        5O12EOB1jBpOO02iAOOMFI5MVKz4SSYGGmYMK8nrGRnMOjWLBcJw5m8Sepovr5iCmLfg8p+t
        uDD8PMxuLcMDJsicDYbebish7L0HusYeAIHXwameFkrgMPioPZBGP2YNXDa+KsgH4fXpC7jA
        u+Bo3wMyYMGZSGi2RgtyAvR0/oULkyFweGatsEEILLKcfiKLYUGeRHBHQL6n4b/MS/3X8EIg
        41c9Cr/qeH7VLfz/uZWAMAEpl6FLU3K6HWouM0onT9NlqJVRCk1aE3j8ia/4exbbQO2UJ8oG
        MBrYAKRx2Xqxz0orJOID8kOHOa0mWZuRyulsYCNNyKRiRUqjXMIo5XruS45L57RPuxgdFHoU
        2x1yR3vEudXr/7VAFqayHit+8b3errilizNRa+LKLoY7EvP38zeqRufeR/r82/XvrOlYSspA
        2gHz+M7Gvcqxq30l9m9yaEqsNF5tPxWjOz7e1bclGnZvrlMlpeR8VPTjz/G1+z/0FUussRoL
        ursw7671Jb7WfKTcrIqOt33yU5pYGmsNe+X1DYfEin6uzG30WzJnVJf+2VQamXs4ufRjbheW
        cHyH/6XffZsibGUEv6zP/E4m19cMer52j47HgAqf783ealO46+WbIS6/UTNizksoWYyL3Xe2
        Jjm0/4U/YgrOzN7XOHaXbfk2Ylt1amvUu88uTacvxObDC58W1H8xnNQgI3QqecxWXKuT/wvD
        sZV2MwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t/xe7rTlvIkG0z+yWsxp+0mu8X5u4eY
        LZ7dvMVmMed8C4vF02OP2C1+zDvMZnF+ehOzxaL3M1gtzp/fwG5xYVsfq8WT1cuYLGac38dk
        sWhZK7PFoal7GS2OfFnFYvHiubTFg4tdLBbHFohZdD1eyWaxoPUpi8W3028YLZo/vWKy+D3x
        IpuDuMflaxeZPXbcXcLosWXlTSaPnbPusnt8+BjnsWBTqcfTCZPZPTat6mTzOHLzIaPHzh2f
        mTzu/FjK6PF+31U2j5vvXjF7/G++zOKxfstVFo/Pm+QChKL0bIryS0tSFTLyi0tslaINLYz0
        DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0MtZ9uspecMOyYv7U36wNjEcNuhg5OSQE
        TCTuHDjF3sXIxSEksJRR4su8PWwQCRmJk9MaWCFsYYk/17rYIIreM0pcOzWfESTBK2An0fr5
        ABOIzSKgKvH871MmiLigxMmZT1hAbFGBZIklDffBBgkL5Emcbn4DZjMLiEvcejIfrJ5NwFCi
        620X2GIRASWJpinvmECWMQs8ZpOY8HUm1HmnWCROrVzMDFLFKWAv8ff6VmaISWYSXVu7GCFs
        eYnmrbOZJzAKzUJyyCwkC2chaZmFpGUBI8sqRpHU0uLc9NxiQ73ixNzi0rx0veT83E2MwPSz
        7djPzTsY5736qHeIkYmD8RCjBAezkgjv110cyUK8KYmVValF+fFFpTmpxYcYTYGhMZFZSjQ5
        H5gA80riDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamFjcN5wJOLi8
        3CH1axCngfKeTXN2+GpFnH8pJM9wyv5MjgkfX273LLOctTsd1mYyGFhJ1rw65i6SfG4zH7Om
        mV/KDZf5z6fGKn1z/5tZ4Hle3M9EmHEfs2WxjuKcd1Fqdaf8/yRfKn2ef1+SU/19ZmHVirAF
        TPu4GqUO/wqKUOLTXhl1cpeyk/DUefUfP7YqljHZrnBumXJA1am/TDI+1Gu560mxtY+/rTwZ
        kXjlyfRbtzc7V7gl37G6k3Xg1crD3YkW9yQTXeQuCv5+JjF/a3CkGZ+PKT/H4Q3zcqY+O77l
        TLDDzro1Ear81xeqOLXz9bS/fcK4uTHtzrljM2UPK8/mPcgqe3gbf1iqJK+7EktxRqKhFnNR
        cSIAZtF3GsgDAAA=
X-CMS-MailID: 20220829114006eucas1p241acc35b524d14bfa56df07728107b80
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
        <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 26.08.2022 10:29, Marek Szyprowski wrote:
> On 26.08.2022 09:53, Lukas Wunner wrote:
>> On Fri, Aug 26, 2022 at 09:41:46AM +0200, Marek Szyprowski wrote:
>>> On 26.08.2022 09:19, Lukas Wunner wrote:
>>>> On Fri, Aug 26, 2022 at 08:51:58AM +0200, Marek Szyprowski wrote:
>>>>> On 19.05.2022 23:22, Marek Szyprowski wrote:
>>>>>> On 19.05.2022 21:08, Lukas Wunner wrote:
>>>>>>> On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
>>>>>>>> This patch landed in the recent linux next-20220516 as commit
>>>>>>>> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY
>>>>>>>> driver to
>>>>>>>> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet
>>>>>>>> operation
>>>>>>>> after system suspend-resume cycle. On the Odroid XU3 board I 
>>>>>>>> got the
>>>>>>>> following warning in the kernel log:
>>>>>>>>
>>>>>>>> # time rtcwake -s10 -mmem
>>>>>>>> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 
>>>>>>>> 09:16:07 2022
>>>>>>>> PM: suspend entry (deep)
>>>>>>>> Filesystems sync: 0.001 seconds
>>>>>>>> Freezing user space processes ... (elapsed 0.002 seconds) done.
>>>>>>>> OOM killer disabled.
>>>>>>>> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) 
>>>>>>>> done.
>>>>>>>> printk: Suspending console(s) (use no_console_suspend to debug)
>>>>>>>> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
>>>>>>>> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
>>>>>>>> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
>>>>>>>> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
>>>>>>>> ------------[ cut here ]------------
>>>>>>>> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
>>>>>>>> phy_state_machine+0x98/0x28c
>>>>>>> [...]
>>>>>>>> It looks that the driver's suspend/resume operations might need 
>>>>>>>> some
>>>>>>>> adjustments. After the system suspend/resume cycle the driver 
>>>>>>>> is not
>>>>>>>> operational anymore. Reverting the $subject patch on top of linux
>>>>>>>> next-20220516 restores ethernet operation after system 
>>>>>>>> suspend/resume.
>>>>>>> Thanks a lot for the report. It seems the PHY is signaling a link
>>>>>>> change
>>>>>>> shortly before system sleep and by the time the phy_state_machine()
>>>>>>> worker
>>>>>>> gets around to handle it, the device has already been suspended 
>>>>>>> and thus
>>>>>>> refuses any further USB requests with -EHOSTUNREACH (-113):
>>>> [...]
>>>>>>> Assuming the above theory is correct, calling phy_stop_machine()
>>>>>>> after usbnet_suspend() would be sufficient to fix the issue.
>>>>>>> It cancels the phy_state_machine() worker.
>>>>>>>
>>>>>>> The small patch below does that. Could you give it a spin?
>>>>>> That's it. Your analysis is right and the patch fixes the issue. 
>>>>>> Thanks!
>>>>>>
>>>>>> Feel free to add:
>>>>>>
>>>>>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>>>
>>>>>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>>> Gentle ping for the final patch...
>>>> Hm?  Actually this issue is supposed to be fixed by mainline commit
>>>> 1758bde2e4aa ("net: phy: Don't trigger state machine while in 
>>>> suspend").
>>>>
>>>> The initial fix attempt that you're replying to should not be 
>>>> necessary
>>>> with that commit.
>>>>
>>>> Are you still seeing issues even with 1758bde2e4aa applied?
>>>> Or are you maybe using a custom downstream tree which is missing 
>>>> that commit?
>>> On Linux next-20220825 I still get the following warning during
>>> suspend/resume cycle:
>>>
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 0 PID: 1483 at drivers/net/phy/phy_device.c:323
>>> mdio_bus_phy_resume+0x10c/0x110
>>> Modules linked in: exynos_gsc s5p_jpeg s5p_mfc videobuf2_dma_contig
>>> v4l2_mem2mem videobuf2_memops videobuf2_v4l2 videobuf2_common videodev
>>> mc s5p_cec
>>> CPU: 0 PID: 1483 Comm: rtcwake Not tainted 6.0.0-rc2-next-20220825 
>>> #5482
>>> Hardware name: Samsung Exynos (Flattened Device Tree)
>>>    unwind_backtrace from show_stack+0x10/0x14
>>>    show_stack from dump_stack_lvl+0x58/0x70
>>>    dump_stack_lvl from __warn+0xc8/0x220
>>>    __warn from warn_slowpath_fmt+0x5c/0xb4
>>>    warn_slowpath_fmt from mdio_bus_phy_resume+0x10c/0x110
>>>    mdio_bus_phy_resume from dpm_run_callback+0x94/0x208
>>>    dpm_run_callback from device_resume+0x124/0x21c
>>>    device_resume from dpm_resume+0x108/0x278
>>>    dpm_resume from dpm_resume_end+0xc/0x18
>>>    dpm_resume_end from suspend_devices_and_enter+0x208/0x70c
>>>    suspend_devices_and_enter from pm_suspend+0x364/0x430
>>>    pm_suspend from state_store+0x68/0xc8
>>>    state_store from kernfs_fop_write_iter+0x110/0x1d4
>>>    kernfs_fop_write_iter from vfs_write+0x1c4/0x2ac
>>>    vfs_write from ksys_write+0x5c/0xd4
>>>    ksys_write from ret_fast_syscall+0x0/0x1c
>>> Exception stack(0xf2ee5fa8 to 0xf2ee5ff0)
>>> 5fa0:                   00000004 0002b438 00000004 0002b438 00000004
>>> 00000000
>>> 5fc0: 00000004 0002b438 000291b0 00000004 0002b438 00000004 befd9c1c
>>> 00028160
>>> 5fe0: 0000006c befd9ae8 b6eb4148 b6f118a4
>>> irq event stamp: 58381
>>> hardirqs last  enabled at (58393): [<c019ff28>] 
>>> vprintk_emit+0x320/0x344
>>> hardirqs last disabled at (58400): [<c019fedc>] 
>>> vprintk_emit+0x2d4/0x344
>>> softirqs last  enabled at (58258): [<c0101694>] 
>>> __do_softirq+0x354/0x618
>>> softirqs last disabled at (58247): [<c012dd18>] 
>>> __irq_exit_rcu+0x140/0x1ec
>>> ---[ end trace 0000000000000000 ]---
>>>
>>> The mentioned patch fixes it.
>> Color me confused.
>>
>> With "the mentioned patch", are you referring to 1758bde2e4aa
>> or are you referring to the little test patch in this e-mail:
>> https://lore.kernel.org/netdev/20220519190841.GA30869@wunner.de/
>>
>> There's a Tested-by from you on 1758bde2e4aa, so I assume the
>> commit fixed the issue at the time.  Does it still occur
>> intermittently?  Or does it occur every time?  In the latter case,
>> I'd assume some other change was made in the meantime and that
>> other change exposed the issue again...
>
> The issue seems to be exposed again. On 1758bde2e4aa everything works 
> fine and there is no warning during suspend/resume cycle. Then I've 
> noticed that warning again while playing with current linux-next. I 
> will check when it got broken and report again.

I've finally traced what has happened. I've double checked and indeed 
the 1758bde2e4aa commit fixed the issue on next-20220516 kernel and as 
such it has been merged to linus tree. Then the commit 744d23c71af3 
("net: phy: Warn about incorrect mdio_bus_phy_resume() state") has been 
merged to linus tree, which triggers a new warning during the 
suspend/resume cycle with smsc95xx driver. Please note, that the 
smsc95xx still works fine regardless that warning. However it look that 
the commit 1758bde2e4aa only hide a real problem, which the commit 
744d23c71af3 warns about.

Probably a proper fix for smsc95xx driver is to call phy_stop/start 
during suspend/resume cycle, like in similar patches for other drivers:

https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

