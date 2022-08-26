Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3C5A221F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbiHZHlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245373AbiHZHly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:41:54 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FAD96FF3
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:41:50 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220826074149euoutp02e12c8f79fe18d9668be8bd93a37ea6b4~O1S7FR0c41821918219euoutp02E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 07:41:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220826074149euoutp02e12c8f79fe18d9668be8bd93a37ea6b4~O1S7FR0c41821918219euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661499709;
        bh=00YdqTAoGLelCMAebxd6w+HdTUsCETMGMaI6e3qElPY=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=ChSfvUO/x0SosBSYZ0D0hm5w7iHSWMoUxanCwesr4xnfGiZVKgojAAqgIoQW11dMh
         GahTuTWGh+X5dCwNbHskU4K9Evw4T/kF25i7OfgsE4sxWBAjosUyhfywxok9Qq75Ob
         5x1linI8Z2V5ctrD+m7DRGegRZ9fqFZJb8NWxTI4=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220826074148eucas1p1b044e0f61c59197808f1b0634a1dd6b6~O1S6f5BRL2940729407eucas1p1D;
        Fri, 26 Aug 2022 07:41:48 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 2A.7C.29727.C3978036; Fri, 26
        Aug 2022 08:41:48 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220826074148eucas1p27abe1e8e35122515708ad42f8ecc76d6~O1S6AlvDb2193221932eucas1p2V;
        Fri, 26 Aug 2022 07:41:48 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220826074148eusmtrp2687c74f6b27934a762649455b8c7ff5f~O1S5-cOXR0595305953eusmtrp2n;
        Fri, 26 Aug 2022 07:41:48 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-80-6308793cce75
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 0F.E1.07473.C3978036; Fri, 26
        Aug 2022 08:41:48 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220826074147eusmtip25e2fceee0961046a6663216211448d21~O1S42VOvd2864128641eusmtip2C;
        Fri, 26 Aug 2022 07:41:46 +0000 (GMT)
Message-ID: <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
Date:   Fri, 26 Aug 2022 09:41:46 +0200
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
In-Reply-To: <20220826071924.GA21264@wunner.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTdRzu+77v3o114MuA9lW5cJME6oQmld+Q4+Ko7q1Tz7C7fl3abrwh
        19hoPxTsDz0GHM4r8Uc5J5Nl6nCYcgMJusti6SbSMTcFtwWu2MgxEB0YR5kS26vFf8/n8zzP
        PZ/ne18eLjCRy3gVCg2jUkjlYpJPdDn+GlhdWMOTPX+iLgc1N/i4yDVix9EfPj+Jml11BBpz
        jHLR3LGfSeQ6XIuj43cMHORytXPR1a4vOCjUdgpDBtcFDB0/VY8j+5c/AHTxnpVA4VvL0W9u
        PYEc5qeQPniaROb6MQLN9k8CpJuOYOj+fjf5ipC+NuTG6e6RE4DuPO3D6B7jCJe+G91Cm21a
        eqzpIJe2WfeQ9EXf74Du6Z7B6OG5k4C+c2GQpH1TEZye110j6HOdgwQ9Y3t6k+B9fmEZI6/Y
        zqjyij7ib/O3iaqCWdWBlkF8NxgW6UECD1IvQN/QMK4HfJ6AagXw1yMRIkYIqHsAmmbeY4kZ
        APcE72OPHV6rh8MSFgANwVtcdogCaGm9xImpEqki2D9ZC2KYoJ6Bly834Ow+GfYdCcUj0igZ
        NDoccU0KpYATPmvci1NC6A+1xNNSKTGsPTSFxQJwKkDCaMeVOEFSEqi/rSdjOIHKg/VH+x6Z
        M6Du/NF4IUiZ+PDMgGvhPN7C8Cqc7VjNVkiBEWcnl8XpcL4nFhaTKOEDQz67roZDE2dwFq+D
        wwN/kzEJTuXAc9/nsetiGP3pJs46k6D3djJ7QBI80HX40ToRNjYIWPUqaHSe/S+z96oHbwJi
        46I3MS7qblxUxfh/rhkQViBktOrKckYtUTA7ctXSSrVWUZ4rU1bawMIP7n/onO4Gpkg01w4w
        HrADyMPFqYkFDkImSCyT1uxkVMqtKq2cUdvBch4hFibKKtqlAqpcqmE+YZgqRvWYxXgJy3Zj
        nCrbp6vKCrZ/+PL680t3DUU23yiVtK20F6kP7F1pbTfL1zm3dA98940kpS/LEXI+F9gaOlRQ
        UropJwNP5Viahtv3G96c6c0Z3yxZMf/jGs++1/xSUSC8M2znviVpftf4hAV7vfTJiDupo/Hk
        6AdIIJfe+Mr2dldOfvizh1lmw4Y/yycs/isvtRbrJvdmdz0AacJjSxt3ZY5lT8FRQcnHs2td
        Gy+NuzXTqdFf8PTSYDTZ4fGqWta4HNpGT9G4ObCk2iBc+8acKC09r06Zkelt0uq4tddv2jP/
        WRJWDmq+vl4o0OwoNNWUzH77zr7iz8++OLFRRPZn381Xet2ZK2p6p8RiQr1NKnkWV6ml/wL2
        sY+8MAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t/xe7o2lRzJBkt+s1rMabvJbnH+7iFm
        i2c3b7FZzDnfwmLx9Ngjdosf8w6zWZyf3sRssej9DFaL8+c3sFtc2NbHavFk9TImixnn9zFZ
        LFrWymxxaOpeRosjX1axWLx4Lm3x4GIXi8WxBWIWXY9XslksaH3KYvHt9BtGi+ZPr5gsfk+8
        yOYg7nH52kVmjx13lzB6bFl5k8lj56y77B4fPsZ5LNhU6vF0wmR2j02rOtk8jtx8yOixc8dn
        Jo87P5Yyerzfd5XN4+a7V8we/5svs3is33KVxePzJrkAoSg9m6L80pJUhYz84hJbpWhDCyM9
        Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jFurFQseq1fcn3+VuYHxjmIXIyeHhICJ
        xI1Vl1i7GLk4hASWMkpcm/+cBSIhI3FyWgMrhC0s8edaFxtE0XtGiVl/n7OBJHgF7CROv2li
        BLFZBFQlTpxoY4aIC0qcnPkEbJCoQLLEkob7YIOEBfIkTje/AbOZBcQlbj2ZzwRiiwgoSTRN
        eccEsoBZ4DGbxISvM9khtu1mljh4dSNYB5uAoUTX2y6wzZwC+hKts09CTTKT6NraxQhhy0s0
        b53NPIFRaBaSQ2YhWTgLScssJC0LGFlWMYqklhbnpucWG+oVJ+YWl+al6yXn525iBCafbcd+
        bt7BOO/VR71DjEwcjIcYJTiYlUR4rY6xJAvxpiRWVqUW5ccXleakFh9iNAWGxkRmKdHkfGD6
        yyuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYBJmKf0kv/mobPpU
        pmXT+HvNpipNfHEsJT/2mlGJ9arvrB4xdYzBW8VzOThzjKs+WTbInJ77sLlkXtgRs0XNSTOP
        3k0TZZh1cqpsUZn7icKsfVpv94etqrG0CHP986Ho8KYv55+FPtIR2fR1k9JXdrGCZS7PHn3w
        lvu49dyNfT8kIwWtZWMUW0/u/ycYMaPtifHBekNt4/oXs5XbW29HKk8qb6hSbV26qkel8k9j
        vtXluhMZTx7xPG+Svf9tRbvJrAxfy60FVpwql4rE+b2Kt3wtZ+nW3/dwjdODCs46u5UeR3xf
        TOd98PNN/cLJ0n/ZJ/1dlDJ9x54v8bYTAlfKxaQK3/6iFrvk3H6TDr6ZVUosxRmJhlrMRcWJ
        ANKrHfbHAwAA
X-CMS-MailID: 20220826074148eucas1p27abe1e8e35122515708ad42f8ecc76d6
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

Hi Lukas,

On 26.08.2022 09:19, Lukas Wunner wrote:
> On Fri, Aug 26, 2022 at 08:51:58AM +0200, Marek Szyprowski wrote:
>> On 19.05.2022 23:22, Marek Szyprowski wrote:
>>> On 19.05.2022 21:08, Lukas Wunner wrote:
>>>> On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
>>>>> This patch landed in the recent linux next-20220516 as commit
>>>>> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY
>>>>> driver to
>>>>> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet
>>>>> operation
>>>>> after system suspend-resume cycle. On the Odroid XU3 board I got the
>>>>> following warning in the kernel log:
>>>>>
>>>>> # time rtcwake -s10 -mmem
>>>>> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
>>>>> PM: suspend entry (deep)
>>>>> Filesystems sync: 0.001 seconds
>>>>> Freezing user space processes ... (elapsed 0.002 seconds) done.
>>>>> OOM killer disabled.
>>>>> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>>>>> printk: Suspending console(s) (use no_console_suspend to debug)
>>>>> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
>>>>> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
>>>>> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
>>>>> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
>>>>> ------------[ cut here ]------------
>>>>> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
>>>>> phy_state_machine+0x98/0x28c
>>>> [...]
>>>>> It looks that the driver's suspend/resume operations might need some
>>>>> adjustments. After the system suspend/resume cycle the driver is not
>>>>> operational anymore. Reverting the $subject patch on top of linux
>>>>> next-20220516 restores ethernet operation after system suspend/resume.
>>>> Thanks a lot for the report. It seems the PHY is signaling a link
>>>> change
>>>> shortly before system sleep and by the time the phy_state_machine()
>>>> worker
>>>> gets around to handle it, the device has already been suspended and thus
>>>> refuses any further USB requests with -EHOSTUNREACH (-113):
> [...]
>>>> Assuming the above theory is correct, calling phy_stop_machine()
>>>> after usbnet_suspend() would be sufficient to fix the issue.
>>>> It cancels the phy_state_machine() worker.
>>>>
>>>> The small patch below does that. Could you give it a spin?
>>> That's it. Your analysis is right and the patch fixes the issue. Thanks!
>>>
>>> Feel free to add:
>>>
>>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>>
>>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Gentle ping for the final patch...
> Hm?  Actually this issue is supposed to be fixed by mainline commit
> 1758bde2e4aa ("net: phy: Don't trigger state machine while in suspend").
>
> The initial fix attempt that you're replying to should not be necessary
> with that commit.
>
> Are you still seeing issues even with 1758bde2e4aa applied?
> Or are you maybe using a custom downstream tree which is missing that commit?

On Linux next-20220825 I still get the following warning during 
suspend/resume cycle:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1483 at drivers/net/phy/phy_device.c:323 
mdio_bus_phy_resume+0x10c/0x110
Modules linked in: exynos_gsc s5p_jpeg s5p_mfc videobuf2_dma_contig 
v4l2_mem2mem videobuf2_memops videobuf2_v4l2 videobuf2_common videodev 
mc s5p_cec
CPU: 0 PID: 1483 Comm: rtcwake Not tainted 6.0.0-rc2-next-20220825 #5482
Hardware name: Samsung Exynos (Flattened Device Tree)
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0xc8/0x220
  __warn from warn_slowpath_fmt+0x5c/0xb4
  warn_slowpath_fmt from mdio_bus_phy_resume+0x10c/0x110
  mdio_bus_phy_resume from dpm_run_callback+0x94/0x208
  dpm_run_callback from device_resume+0x124/0x21c
  device_resume from dpm_resume+0x108/0x278
  dpm_resume from dpm_resume_end+0xc/0x18
  dpm_resume_end from suspend_devices_and_enter+0x208/0x70c
  suspend_devices_and_enter from pm_suspend+0x364/0x430
  pm_suspend from state_store+0x68/0xc8
  state_store from kernfs_fop_write_iter+0x110/0x1d4
  kernfs_fop_write_iter from vfs_write+0x1c4/0x2ac
  vfs_write from ksys_write+0x5c/0xd4
  ksys_write from ret_fast_syscall+0x0/0x1c
Exception stack(0xf2ee5fa8 to 0xf2ee5ff0)
5fa0:                   00000004 0002b438 00000004 0002b438 00000004 
00000000
5fc0: 00000004 0002b438 000291b0 00000004 0002b438 00000004 befd9c1c 
00028160
5fe0: 0000006c befd9ae8 b6eb4148 b6f118a4
irq event stamp: 58381
hardirqs last  enabled at (58393): [<c019ff28>] vprintk_emit+0x320/0x344
hardirqs last disabled at (58400): [<c019fedc>] vprintk_emit+0x2d4/0x344
softirqs last  enabled at (58258): [<c0101694>] __do_softirq+0x354/0x618
softirqs last disabled at (58247): [<c012dd18>] __irq_exit_rcu+0x140/0x1ec
---[ end trace 0000000000000000 ]---

The mentioned patch fixes it.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

