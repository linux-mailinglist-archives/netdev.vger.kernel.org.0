Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A498529F4A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344055AbiEQKU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbiEQKUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:20:13 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B292EA09
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 03:18:52 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220517101847euoutp012e825588766042c80ad1f6a8951d715b~v3SJggdhc0482904829euoutp01g
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:18:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220517101847euoutp012e825588766042c80ad1f6a8951d715b~v3SJggdhc0482904829euoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652782728;
        bh=l6/a9s2hL4R6Kmm4X7zRBw1dsohVxPnNWaJjPgdOnRg=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=LEkZxnu2GBCeVUCYX/gkdvoKIDXfXIcGLPckMLlOe8ktXmhZuMZk51b4RYZfebdST
         kQot7DR+Ucsn1cIk5YU3AB5rrgnWrGEDvhmUPktLtcLgb79pjMffjXysAXjrITDqxq
         PO6ZmFw/pW24KyraTxJo11ahKfKMvCIP77fCTOAQ=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220517101847eucas1p2ccc010e672657944b81e5043c6ab6edd~v3SI4vs_22411024110eucas1p25;
        Tue, 17 May 2022 10:18:47 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 3E.BB.09887.78673826; Tue, 17
        May 2022 11:18:47 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99~v3SIRtwxp0044400444eucas1p2b;
        Tue, 17 May 2022 10:18:46 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220517101846eusmtrp1b138d4496aa1750fdba379c42f101b28~v3SIQigzY1249912499eusmtrp1T;
        Tue, 17 May 2022 10:18:46 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-72-628376873eb6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 57.32.09522.68673826; Tue, 17
        May 2022 11:18:46 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220517101845eusmtip1c080cec6daca5e80e055ab6eea13d63c~v3SHMqqLN0115901159eusmtip1z;
        Tue, 17 May 2022 10:18:45 +0000 (GMT)
Message-ID: <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
Date:   Tue, 17 May 2022 12:18:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
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
In-Reply-To: <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0xTVxzOuff29tKl5FqcnCm4pQ7MjEMecztkzrnF6d1mjHsmmuFWyh0y
        oO1acExm1hRbpS6miEOozBUmFAob2nQNLg5LQSqCVl7GMsrAUsXysoDzlY1ZLm789+V7/L7f
        7+RQuOgHcjmVIcthlTJJlpgUEPa2B1dePLi3IDVefU6AynUePnJ7nTi66eknUbn7AIH8bTf4
        6P7JFhK5j2twVDlVykNu92k+umo/wkMjddUYKnU3YaiyWosj5/e/A9Q6ayHQ6K0VaKhLT6A2
        0zKk99WSyKT1E+ivjnGACqYDGHpU1EVuimR6rnXhTKP3FGBstR6MOWv08pk7wd2MyZrL+A3F
        fMZqKSSZVs8wYM42zmDMwP0qwEw19ZGMZzKAM3MFPQTTYOsjmBnryh2iXYINaWxWxl5WuW7j
        Z4I9g02XgMKVmHey7DKhBiVr9CCMgvRLsMVWytMDASWiawBs1w3jIUFEzwJo+iOOE2YAdNQM
        8J4kHNZhkhPMAHaaAwvxIICN6l4y5BLSG2Fzced8gqBj4FHHKMbxS2B72QgRwk/TqXB8vG++
        LoKWwTGPZd6P05Gwf+RHLDR0KW0H0PCAC+B0Ow/azyeHMEknQP2E/nEZRYXRH0NjZRpneRYW
        /HoC5zatEsALzUkc3gw9YxaCwxEw4LLxORwFO4q/I0JjIC2Hf5cu2PPgtbH6hTGvwoErD+eb
        cPoF2PDbOo5+AwYdgziXDIfXJ5ZwC4TDo/bjC7QQHtKJOHcsNLp++a+z+Wo3bgBi46InMS46
        3bjoFOP/vSZAWEAkm6vKTmdViTL2qziVJFuVK0uPk8qzreDxD+74xzXbCMyBYJwTYBRwAkjh
        4qXC+Dx1qkiYJvl6H6uUf6rMzWJVTrCCIsSRQmnGaYmITpfksJksq2CVT1SMCluuxlQK+fob
        WPl0SuGjhp+jE99Bvd0TjvdKzsRc0nTkJW0Zvfiu7ZtWneKjU323r69+eah+bqcjyfp+maTy
        tpu6+Imvc9d0/srtjT1SeDcqZvfdIbw73+VdpTdksGtbttkzv9z/TP6HPK1+6/PJ/skDvsOX
        R2Lf3tz5LYXJ9dluaUXNF69NbS9M/Xxy5q3MZWGaHfdW30k5Zmg1nyh5qm5f0ZHw2uQS30/U
        68OahFjhmS3RDeff1LBEc1p/9qHDVb313rmy/dqUQpes6UJ58KZbUWFyEjWz93r0rxQlb4t+
        Dm0wD38QeChNibpVcW5wp3/9Vu2fuu5NhsGI+Lq1OQbRQV+q6li1mFDtkSSswZUqyb/HdIi9
        MAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t/xu7ptZc1JBgffKlnMabvJbnH+7iFm
        i2c3b7FZzDnfwmLx9Ngjdosf8w6zWZyf3sRssej9DFaL8+c3sFtc2NbHavFk9TImixnn9zFZ
        LFrWymxxaOpeRosjX1axWLx4Lm3x4GIXi8WxBWIWXY9XslksaH3KYvHt9BtGi+ZPr5gsfk+8
        yOYg7nH52kVmjx13lzB6bFl5k8lj56y77B4fPsZ5LNhU6vF0wmR2j02rOtk8jtx8yOixc8dn
        Jo87P5Yyerzfd5XN4+a7V8we/5svs3is33KVxePzJrkAoSg9m6L80pJUhYz84hJbpWhDCyM9
        Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jHv7TjEWHDeqmDfzLEsD4zStLkZODgkB
        E4kDmx6ydTFycQgJLGWUWLBgNQtEQkbi5LQGVghbWOLPtS6ooveMEnum/GUGSfAK2EkcnHwG
        rIhFQFVi0oEXTBBxQYmTM58ADeLgEBVIkjhymB8kLCyQJ3G6+Q1YObOAuMStJ/OZQGaKCGxj
        lPj4/QfYAmaB86wSr+bdAxskJFAn0TGvkQ3EZhMwlOh6C3IFBwenQJjErEUpEIPMJLq2djFC
        2PISzVtnM09gFJqF5IxZSPbNQtIyC0nLAkaWVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIGp
        Z9uxn5t3MM579VHvECMTB+MhRgkOZiURXoOKhiQh3pTEyqrUovz4otKc1OJDjKbAsJjILCWa
        nA9Mfnkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUzcz911nn/M
        KvDt3vXyp+JbiUuLo8TeOFu07nyxdsrqcqWj1zYYiRc7Zr9SXDj5a+CjZa6Fe8+8LubfzZz5
        IfGtulkPt+W2nwf4Tv69K3KrRI5/TpLQp092r7r/h5f++R/Ju/rAmoKbr6f1repj6Zh7ccth
        vqf7NSxkV70oDw3WuRKX+UL43VJNT+9JV966lSqfWaAzf/J7BoOKq/+n3XHgsJ4bpPKFK1Tr
        tP+7c/0bzux5MTtgdtXqKN+KrWJrwpxdowt7nVO/c8Vk12k9lRWpv3DR7p+hxRrlhH2JnLd2
        HDricCZ2l4X3ldqeZRN3cCfeK9m292uilZTxhc+LOLKYeKbxT339rptP7M5pbZcbSizFGYmG
        WsxFxYkAe4vwfcYDAAA=
X-CMS-MailID: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
References: <cover.1652343655.git.lukas@wunner.de>
        <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
        <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On 12.05.2022 10:42, Lukas Wunner wrote:
> Link status of SMSC LAN95xx chips is polled once per second, even though
> they're capable of signaling PHY interrupts through the MAC layer.
>
> Forward those interrupts to the PHY driver to avoid polling.  Benefits
> are reduced bus traffic, reduced CPU overhead and quicker interface
> bringup.
>
> Polling was introduced in 2016 by commit d69d16949346 ("usbnet:
> smsc95xx: fix link detection for disabled autonegotiation").
> Back then, the LAN95xx driver neglected to enable the ENERGYON interrupt,
> hence couldn't detect link-up events when auto-negotiation was disabled.
> The proper solution would have been to enable the ENERGYON interrupt
> instead of polling.
>
> Since then, PHY handling was moved from the LAN95xx driver to the SMSC
> PHY driver with commit 05b35e7eb9a1 ("smsc95xx: add phylib support").
> That PHY driver is capable of link detection with auto-negotiation
> disabled because it enables the ENERGYON interrupt.
>
> Note that signaling interrupts through the MAC layer not only works with
> the integrated PHY, but also with an external PHY, provided its
> interrupt pin is attached to LAN95xx's nPHY_INT pin.
>
> In the unlikely event that the interrupt pin of an external PHY is
> attached to a GPIO of the SoC (or not connected at all), the driver can
> be amended to retrieve the irq from the PHY's of_node.
>
> To forward PHY interrupts to phylib, it is not sufficient to call
> phy_mac_interrupt().  Instead, the PHY's interrupt handler needs to run
> so that PHY interrupts are cleared.  That's because according to page
> 119 of the LAN950x datasheet, "The source of this interrupt is a level.
> The interrupt persists until it is cleared in the PHY."
>
> https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocuments/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf
>
> Therefore, create an IRQ domain with a single IRQ for the PHY.  In the
> future, the IRQ domain may be extended to support the 11 GPIOs on the
> LAN95xx.
>
> Normally the PHY interrupt should be masked until the PHY driver has
> cleared it.  However masking requires a (sleeping) USB transaction and
> interrupts are received in (non-sleepable) softirq context.  I decided
> not to mask the interrupt at all (by using the dummy_irq_chip's noop
> ->irq_mask() callback):  The USB interrupt endpoint is polled in 1 msec
> intervals and normally that's sufficient to wake the PHY driver's IRQ
> thread and have it clear the interrupt.  If it does take longer, worst
> thing that can happen is the IRQ thread is woken again.  No big deal.
>
> Because PHY interrupts are now perpetually enabled, there's no need to
> selectively enable them on suspend.  So remove all invocations of
> smsc95xx_enable_phy_wakeup_interrupts().
>
> In smsc95xx_resume(), move the call of phy_init_hw() before
> usbnet_resume() (which restarts the status URB) to ensure that the PHY
> is fully initialized when an interrupt is handled.
>
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch> # from a PHY perspective
> Cc: Andre Edich <andre.edich@microchip.com>

This patch landed in the recent linux next-20220516 as commit 
1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to 
avoid polling"). Unfortunately it breaks smsc95xx usb ethernet operation 
after system suspend-resume cycle. On the Odroid XU3 board I got the 
following warning in the kernel log:

# time rtcwake -s10 -mmem
rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
PM: suspend entry (deep)
Filesystems sync: 0.001 seconds
Freezing user space processes ... (elapsed 0.002 seconds) done.
OOM killer disabled.
Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
printk: Suspending console(s) (use no_console_suspend to debug)
smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
------------[ cut here ]------------
WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946 
phy_state_machine+0x98/0x28c
Modules linked in: snd_soc_hdmi_codec snd_soc_odroid governor_passive 
snd_soc_i2s exynos_bus snd_soc_idma snd_soc_s3c_dma exynosdrm 
analogix_dp snd_soc_max98090 snd_soc_core ac97_bus snd_pcm_dmaengine 
snd_pcm clk_s2mps11 rtc_s5m snd_timer snd soundcore ina2xx exynos_gsc 
pwm_samsung exynos_adc s5p_jpeg ohci_exynosv4l2_mem2mem phy_exynos_usb2 
panfrost ehci_exynos s5p_mfc drm_shmem_helper videobuf2_dma_contig 
videobuf2_memops videobuf2_v4l2 videobuf2_common gpu_sched videodev mc 
exynos_ppmu exynos5422_dmc exynos_nocp s5p_sss rtc_s3c exynos_rng 
s3c2410_wdt s5p_cec pwm_fan
CPU: 2 PID: 73 Comm: kworker/2:1 Tainted: G        W 
5.18.0-rc6-01433-g1ce8b37241ed #5040
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x40/0x4c
  dump_stack_lvl from __warn+0xc8/0x13c
  __warn from warn_slowpath_fmt+0x5c/0xb4
  warn_slowpath_fmt from phy_state_machine+0x98/0x28c
  phy_state_machine from process_one_work+0x1ec/0x4cc
  process_one_work from worker_thread+0x58/0x54c
  worker_thread from kthread+0xd0/0xec
  kthread from ret_from_fork+0x14/0x2c
Exception stack(0xf0aa9fb0 to 0xf0aa9ff8)
...
---[ end trace 0000000000000000 ]---

It looks that the driver's suspend/resume operations might need some 
adjustments. After the system suspend/resume cycle the driver is not 
operational anymore. Reverting the $subject patch on top of linux 
next-20220516 restores ethernet operation after system suspend/resume.

> ---
> Only change since v2:
>   * Drop call to __irq_enter_raw() which worked around a warning in
>     generic_handle_domain_irq().  That warning is gone since
>     792ea6a074ae (queued on tip.git/irq/urgent).
>     (Marc Zyngier, Thomas Gleixner)
>
>   drivers/net/usb/smsc95xx.c | 113 ++++++++++++++++++++-----------------
>   1 file changed, 61 insertions(+), 52 deletions(-)

 > ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

