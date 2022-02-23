Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01E4C11B5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbiBWLlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240112AbiBWLld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:41:33 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177C496810
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:41:04 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id l10so12078285vki.9
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MLiVDmTMym3zwjmLrg6DD0fvz/uviaALz+tBpiY2YcU=;
        b=HO61Nue+CzKuM26vPgx4IUtsziVhASts3sx3uh1YiLSHUMi7CUBMQWBWd5c0LXJ3Sz
         vDh9O4WvVC3urtIdJYpAMO4kxORUxSPsMbqo2gxt8Dc0R7iICrn4vHCBD0eHG6zooJZc
         FvPyMw4XBf7iUqU46K1f070hnrfd3mFN4UEqLpqZKHB+x0tjjX0FVPt+EclKBEPxY7fv
         2lpT5WyjYRQZL/Hlha5X/J3rLqDhoHNix9kzvMUGjVljKq0fiKUBW7LOLOHsnNanCtbc
         7/VOb8tIAuEDpzc0hUbS72q74XeMy71C6x9MVYdyXLE9kfRP6TX/2wywjHb2pISMNWtx
         Jt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MLiVDmTMym3zwjmLrg6DD0fvz/uviaALz+tBpiY2YcU=;
        b=YhN6rApZpOILNqvdzeYIlKCY3oU6fniyLYowrdUeBZ2cMynOgEfCt4653SnNvQwGBs
         FHWPp0Du6+RTYbPB+mYNYcfXOwqYfEJE04SwJsrgRcBjvz7Mbr0eUEKOFLgVoRS+3ngy
         nxMzoFq6VofI2/uQ5rRnnhj6AdOrRN3IiYOct4AEazDEA036d0+S21ikKp4u5TgaCOkJ
         59LyFYyADHBHmLuEODjcZT7tfQhC00ex65JMGeej/MSTY4WuROQNVjonz1RIN3ILs6CC
         Mj5HaZEYyCrSoCCahlQjnyUGO8D9MwOinRLVJn5ZIxcc/+gXjNCbfQG8VhGB5KpW24QR
         9bWA==
X-Gm-Message-State: AOAM532a27rHlRmMathPv/BTYysqkm1qhzW7RMsQu/DAgO3rKZl9d4I4
        DpdwUYDoHCMuQwVtR0bOzptYrxr/7cEdixBxcN8=
X-Google-Smtp-Source: ABdhPJyDhVXkcjs2IC3T1xULlkAqDhyLcJvOndN4NHeGm2b403AQhpc44UUiTz7c6u6ewM/1o1sHoWG2XFC2Rd9aaCU=
X-Received: by 2002:a05:6122:a1f:b0:32d:a4a4:6c27 with SMTP id
 31-20020a0561220a1f00b0032da4a46c27mr11519147vkn.14.1645616463175; Wed, 23
 Feb 2022 03:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com> <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
In-Reply-To: <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Wed, 23 Feb 2022 11:40:52 +0000
Message-ID: <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 8:15 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 2/22/2022 12:07 PM, Peter Robinson wrote:
> >> On 2/22/2022 1:53 AM, Peter Robinson wrote:
> >>> The ethtool WoL enable function wasn't checking if the device
> >>> has the optional WoL IRQ and hence on platforms such as the
> >>> Raspberry Pi 4 which had working ethernet prior to the last
> >>> fix regressed with the last fix, so also check if we have a
> >>> WoL IRQ there and return ENOTSUPP if not.
> >>>
> >>> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
> >>> Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")
> >>> Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
> >>> Suggested-by: Javier Martinez Canillas <javierm@redhat.com>
> >>> ---
> >>>    drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 4 ++++
> >>>    1 file changed, 4 insertions(+)
> >>>
> >>> We're seeing this crash on the Raspberry Pi 4 series of devices on
> >>> Fedora on 5.17-rc with the top Fixes patch and wired ethernet doesn't work.
> >>
> >> Are you positive these two things are related to one another? The
> >> transmit queue timeout means that the TX DMA interrupt is not firing up
> >> what is the relationship with the absence/presence of the Wake-on-LAN
> >> interrupt line?
> >
> > The first test I did was revert 9deb48b53e7f and the problem went
> > away, then poked at a few bits and the patch also fixes it without
> > having to revert the other fix. I don't know the HW well enough to
> > know more.
> >
> > It seems there's other fixes/improvements that could be done around
> > WOL in the driver, the bcm2711 SoC at least in the upstream DT doesn't
> > support/implement a WOL IRQ, yet the RPi4 reports it supports WOL.
>
> There is no question we can report information more accurately and your
> patch fixes that.
>
> >
> > This fix at least makes it work again in 5.17, I think improvements
> > can be looked at later by something that actually knows their way
> > around the driver and IP.
>
> I happen to be that something, or rather consider myself a someone. But
> the DTS is perfectly well written and the Wake-on-LAN interrupt is
> optional, the driver assumes as per the binding documents that the
> Wake-on-LAN is the 3rd interrupt, when available.
>
> What I was hoping to get at is the output of /proc/interrupts for the
> good and the bad case so we can find out if by accident we end-up not
> using the appropriate interrupt number for the TX path. Not that I can
> see how that would happen, but since we have had some interesting issues
> being reported before when mixing upstream and downstream DTBs, I just
> don't fancy debugging that again:

The top two are pre/post plugging an ethernet cable with the patched
kernel, the last two are the broken kernel. There doesn't seem to be a
massive difference in interrupts but you likely know more of what
you're looking for.

Patched:

[root@rpi400 ~]# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  9:          0          0          0          0     GICv2  25 Level     vgic
 11:      16607       8639       5018       5793     GICv2  30 Level
  arch_timer
 12:          0          0          0          0     GICv2  27 Level
  kvm guest vtimer
 18:          0          0          0          0     GICv2 107 Level
  fe004000.txp
 19:       1202          0          0          0     GICv2  65 Level
  fe00b880.mailbox
 22:       4105          0          0          0     GICv2 125 Level     ttyS0
 23:          0          0          0          0     GICv2 129 Level     vc4 hvs
 24:          0          0          0          0     GICv2 105 Level
  fe980000.usb, fe980000.usb, dwc2_hsotg:usb3
 26:          0          0          0          0     GICv2 112 Level     DMA IRQ
 28:          0          0          0          0     GICv2 114 Level     DMA IRQ
 35:          0          0          0          0     GICv2 141 Level
  vc4 crtc
 36:          0          0          0          0     GICv2 142 Level
  vc4 crtc, vc4 crtc
 37:          0          0          0          0     GICv2 133 Level
  vc4 crtc
 38:          0          0          0          0     GICv2 138 Level
  vc4 crtc
 41:      10661          0          0          0     GICv2 158 Level
  mmc0, mmc1
 42:          0          0          0          0     GICv2  48 Level     arm-pmu
 43:          0          0          0          0     GICv2  49 Level     arm-pmu
 44:          0          0          0          0     GICv2  50 Level     arm-pmu
 45:          0          0          0          0     GICv2  51 Level     arm-pmu
 48:       3763          0          0          0     GICv2 189 Level     eth0
 49:          0          0          0          0     GICv2 190 Level     eth0
 57:          0          0          0          0     GICv2 175 Level
  PCIe PME, aerdrv
 58:         69          0          0          0  BRCM STB PCIe MSI
524288 Edge      xhci_hcd
 59:          0          0          0          0
interrupt-controller@7ef00100   4 Edge      vc4 hdmi hpd connected
 60:          0          0          0          0
interrupt-controller@7ef00100   5 Edge      vc4 hdmi hpd disconnected
 61:          0          0          0          0
interrupt-controller@7ef00100   1 Edge      vc4 hdmi cec rx
 62:          0          0          0          0
interrupt-controller@7ef00100   0 Edge      vc4 hdmi cec tx
 63:          0          0          0          0
interrupt-controller@7ef00100  10 Edge      vc4 hdmi hpd connected
 64:          0          0          0          0
interrupt-controller@7ef00100  11 Edge      vc4 hdmi hpd disconnected
 65:          0          0          0          0
interrupt-controller@7ef00100   7 Edge      vc4 hdmi cec rx
 66:          0          0          0          0
interrupt-controller@7ef00100   8 Edge      vc4 hdmi cec tx
IPI0:      2984       9834       4892       4645       Rescheduling interrupts
IPI1:       874        696        669        667       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for
crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast
interrupts
IPI5:       121         86        103         79       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0
[root@rpi400 ~]# [  790.405408] bcmgenet fd580000.ethernet eth0: Link
is Up - 1Gbps/Full - flow control rx/tx
[  790.413783] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  9:          0          0          0          0     GICv2  25 Level     vgic
 11:      16769       9013       5132       5943     GICv2  30 Level
  arch_timer
 12:          0          0          0          0     GICv2  27 Level
  kvm guest vtimer
 18:          0          0          0          0     GICv2 107 Level
  fe004000.txp
 19:       1263          0          0          0     GICv2  65 Level
  fe00b880.mailbox
 22:       4566          0          0          0     GICv2 125 Level     ttyS0
 23:          0          0          0          0     GICv2 129 Level     vc4 hvs
 24:          0          0          0          0     GICv2 105 Level
  fe980000.usb, fe980000.usb, dwc2_hsotg:usb3
 26:          0          0          0          0     GICv2 112 Level     DMA IRQ
 28:          0          0          0          0     GICv2 114 Level     DMA IRQ
 35:          0          0          0          0     GICv2 141 Level
  vc4 crtc
 36:          0          0          0          0     GICv2 142 Level
  vc4 crtc, vc4 crtc
 37:          0          0          0          0     GICv2 133 Level
  vc4 crtc
 38:          0          0          0          0     GICv2 138 Level
  vc4 crtc
 41:      10751          0          0          0     GICv2 158 Level
  mmc0, mmc1
 42:          0          0          0          0     GICv2  48 Level     arm-pmu
 43:          0          0          0          0     GICv2  49 Level     arm-pmu
 44:          0          0          0          0     GICv2  50 Level     arm-pmu
 45:          0          0          0          0     GICv2  51 Level     arm-pmu
 48:       3838          0          0          0     GICv2 189 Level     eth0
 49:         33          0          0          0     GICv2 190 Level     eth0
 57:          0          0          0          0     GICv2 175 Level
  PCIe PME, aerdrv
 58:         69          0          0          0  BRCM STB PCIe MSI
524288 Edge      xhci_hcd
 59:          0          0          0          0
interrupt-controller@7ef00100   4 Edge      vc4 hdmi hpd connected
 60:          0          0          0          0
interrupt-controller@7ef00100   5 Edge      vc4 hdmi hpd disconnected
 61:          0          0          0          0
interrupt-controller@7ef00100   1 Edge      vc4 hdmi cec rx
 62:          0          0          0          0
interrupt-controller@7ef00100   0 Edge      vc4 hdmi cec tx
 63:          0          0          0          0
interrupt-controller@7ef00100  10 Edge      vc4 hdmi hpd connected
 64:          0          0          0          0
interrupt-controller@7ef00100  11 Edge      vc4 hdmi hpd disconnected
 65:          0          0          0          0
interrupt-controller@7ef00100   7 Edge      vc4 hdmi cec rx
 66:          0          0          0          0
interrupt-controller@7ef00100   8 Edge      vc4 hdmi cec tx
IPI0:      3112      10093       5006       4796       Rescheduling interrupts
IPI1:       891        729        679        671       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for
crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast
interrupts
IPI5:       129         92        110         86       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0


Broken:
[root@rpi400 ~]# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  9:          0          0          0          0     GICv2  25 Level     vgic
 11:       7651       5879      21793      19375     GICv2  30 Level
  arch_timer
 12:          0          0          0          0     GICv2  27 Level
  kvm guest vtimer
 18:          0          0          0          0     GICv2 107 Level
  fe004000.txp
 19:       1719          0          0          0     GICv2  65 Level
  fe00b880.mailbox
 22:       3118          0          0          0     GICv2 125 Level     ttyS0
 23:          0          0          0          0     GICv2 129 Level     vc4 hvs
 24:          0          0          0          0     GICv2 105 Level
  fe980000.usb, fe980000.usb, dwc2_hsotg:usb2
 26:          0          0          0          0     GICv2 112 Level     DMA IRQ
 28:          0          0          0          0     GICv2 114 Level     DMA IRQ
 35:          0          0          0          0     GICv2 141 Level
  vc4 crtc
 36:          0          0          0          0     GICv2 142 Level
  vc4 crtc, vc4 crtc
 37:          0          0          0          0     GICv2 133 Level
  vc4 crtc
 38:          0          0          0          0     GICv2 138 Level
  vc4 crtc
 41:      11012          0          0          0     GICv2 158 Level
  mmc1, mmc0
 42:          0          0          0          0     GICv2  48 Level     arm-pmu
 43:          0          0          0          0     GICv2  49 Level     arm-pmu
 44:          0          0          0          0     GICv2  50 Level     arm-pmu
 45:          0          0          0          0     GICv2  51 Level     arm-pmu
 48:       6518          0          0          0     GICv2 189 Level     eth0
 49:          0          0          0          0     GICv2 190 Level     eth0
 57:          0          0          0          0     GICv2 175 Level
  PCIe PME, aerdrv
 58:          0          0          0          0
interrupt-controller@7ef00100   4 Edge      vc4 hdmi hpd connected
 59:          0          0          0          0
interrupt-controller@7ef00100   5 Edge      vc4 hdmi hpd disconnected
 60:         69          0          0          0  BRCM STB PCIe MSI
524288 Edge      xhci_hcd
 61:          0          0          0          0
interrupt-controller@7ef00100   1 Edge      vc4 hdmi cec rx
 62:          0          0          0          0
interrupt-controller@7ef00100   0 Edge      vc4 hdmi cec tx
 63:          0          0          0          0
interrupt-controller@7ef00100  10 Edge      vc4 hdmi hpd connected
 64:          0          0          0          0
interrupt-controller@7ef00100  11 Edge      vc4 hdmi hpd disconnected
 65:          0          0          0          0
interrupt-controller@7ef00100   7 Edge      vc4 hdmi cec rx
 66:          0          0          0          0
interrupt-controller@7ef00100   8 Edge      vc4 hdmi cec tx
IPI0:      3752       6274      11796       5915       Rescheduling interrupts
IPI1:       840        590        537        764       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for
crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast
interrupts
IPI5:       217        105         88        100       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0
[root@rpi400 ~]# [ 1361.290396] bcmgenet fd580000.ethernet eth0: Link
is Up - 1Gbps/Full - flow control rx/tx
[ 1361.298771] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 1364.009923] ------------[ cut here ]------------
[ 1364.014648] NETDEV WATCHDOG: eth0 (bcmgenet): transmit queue 2 timed out
[ 1364.021543] WARNING: CPU: 2 PID: 0 at net/sched/sch_generic.c:529
dev_watchdog+0x234/0x240
[ 1364.029955] Modules linked in: nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip_set nf_tables nfnetlink btsdio bluetooth
ecdh_generic brcmfmac cpufreq_dt brcmutil cfg80211 broadcom
raspberrypi_cpufreq bcm_phy_lib snd_soc_hdmi_codec rfkill genet
iproc_rng200 bcm2711_thermal mdio_bcm_unimac nvmem_rmem leds_gpio vfat
fat fuse zram mmc_block vc4 snd_soc_core dwc2 snd_compress ac97_bus
snd_pcm_dmaengine snd_pcm raspberrypi_hwmon udc_core crct10dif_ce
gpio_raspberrypi_exp clk_bcm2711_dvp bcm2835_wdt bcm2835_dma snd_timer
snd sdhci_iproc sdhci_pltfm soundcore sdhci pcie_brcmstb phy_generic
drm_cma_helper i2c_dev aes_neon_bs
[ 1364.097026] CPU: 2 PID: 0 Comm: swapper/2 Not tainted
5.17.0-0.rc3.89.fc36.aarch64 #1
[ 1364.104975] Hardware name: Unknown Unknown Product/Unknown Product,
BIOS 2022.04-rc2 04/01/2022
[ 1364.113800] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1364.120866] pc : dev_watchdog+0x234/0x240
[ 1364.124937] lr : dev_watchdog+0x234/0x240
[ 1364.129006] sp : ffff8000080aba40
[ 1364.132363] x29: ffff8000080aba40 x28: ffffa70da31c7000 x27: ffff8000080abb20
[ 1364.139614] x26: ffffa70da2c40000 x25: 0000000000000000 x24: ffffa70da31cec08
[ 1364.146864] x23: 0000000000000100 x22: ffffa70da31c7000 x21: ffff2c5242c30000
[ 1364.154112] x20: 0000000000000002 x19: ffff2c5242c304c8 x18: ffffffffffffffff
[ 1364.161359] x17: ffff854558af2000 x16: ffff800008014000 x15: 0000000000000006
[ 1364.168606] x14: 0000000000000000 x13: 74756f2064656d69 x12: ffffa70da32bd5f0
[ 1364.175852] x11: 712074696d736e61 x10: ffffa70da32bd5f0 x9 : ffffa70da0e0c81c
[ 1364.183098] x8 : 00000000ffffdfff x7 : 000000000000003f x6 : 0000000000000000
[ 1364.190345] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000001000
[ 1364.197592] x2 : 0000000000001000 x1 : 0000000000000005 x0 : 000000000000003c
[ 1364.204839] Call trace:
[ 1364.207315]  dev_watchdog+0x234/0x240
[ 1364.211035]  call_timer_fn+0x3c/0x15c
[ 1364.214757]  __run_timers.part.0+0x288/0x310
[ 1364.219093]  run_timer_softirq+0x48/0x80
[ 1364.223076]  __do_softirq+0x128/0x360
[ 1364.226791]  __irq_exit_rcu+0x138/0x140
[ 1364.230688]  irq_exit_rcu+0x1c/0x30
[ 1364.234229]  el1_interrupt+0x38/0x54
[ 1364.237857]  el1h_64_irq_handler+0x18/0x24
[ 1364.242013]  el1h_64_irq+0x7c/0x80
[ 1364.245462]  arch_cpu_idle+0x18/0x2c
[ 1364.249089]  default_idle_call+0x4c/0x140
[ 1364.253157]  cpuidle_idle_call+0x14c/0x1a0
[ 1364.257318]  do_idle+0xb0/0x100
[ 1364.260506]  cpu_startup_entry+0x34/0x8c
[ 1364.264488]  secondary_start_kernel+0xe4/0x110
[ 1364.269001]  __secondary_switched+0x94/0x98
[ 1364.273248] ---[ end trace 0000000000000000 ]---

[root@rpi400 ~]# cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  9:          0          0          0          0     GICv2  25 Level     vgic
 11:       7878       5980      21922      19501     GICv2  30 Level
  arch_timer
 12:          0          0          0          0     GICv2  27 Level
  kvm guest vtimer
 18:          0          0          0          0     GICv2 107 Level
  fe004000.txp
 19:       1761          0          0          0     GICv2  65 Level
  fe00b880.mailbox
 22:       3588          0          0          0     GICv2 125 Level     ttyS0
 23:          0          0          0          0     GICv2 129 Level     vc4 hvs
 24:          0          0          0          0     GICv2 105 Level
  fe980000.usb, fe980000.usb, dwc2_hsotg:usb2
 26:          0          0          0          0     GICv2 112 Level     DMA IRQ
 28:          0          0          0          0     GICv2 114 Level     DMA IRQ
 35:          0          0          0          0     GICv2 141 Level
  vc4 crtc
 36:          0          0          0          0     GICv2 142 Level
  vc4 crtc, vc4 crtc
 37:          0          0          0          0     GICv2 133 Level
  vc4 crtc
 38:          0          0          0          0     GICv2 138 Level
  vc4 crtc
 41:      11087          0          0          0     GICv2 158 Level
  mmc1, mmc0
 42:          0          0          0          0     GICv2  48 Level     arm-pmu
 43:          0          0          0          0     GICv2  49 Level     arm-pmu
 44:          0          0          0          0     GICv2  50 Level     arm-pmu
 45:          0          0          0          0     GICv2  51 Level     arm-pmu
 48:       6551          0          0          0     GICv2 189 Level     eth0
 49:          0          0          0          0     GICv2 190 Level     eth0
 57:          0          0          0          0     GICv2 175 Level
  PCIe PME, aerdrv
 58:          0          0          0          0
interrupt-controller@7ef00100   4 Edge      vc4 hdmi hpd connected
 59:          0          0          0          0
interrupt-controller@7ef00100   5 Edge      vc4 hdmi hpd disconnected
 60:         69          0          0          0  BRCM STB PCIe MSI
524288 Edge      xhci_hcd
 61:          0          0          0          0
interrupt-controller@7ef00100   1 Edge      vc4 hdmi cec rx
 62:          0          0          0          0
interrupt-controller@7ef00100   0 Edge      vc4 hdmi cec tx
 63:          0          0          0          0
interrupt-controller@7ef00100  10 Edge      vc4 hdmi hpd connected
 64:          0          0          0          0
interrupt-controller@7ef00100  11 Edge      vc4 hdmi hpd disconnected
 65:          0          0          0          0
interrupt-controller@7ef00100   7 Edge      vc4 hdmi cec rx
 66:          0          0          0          0
interrupt-controller@7ef00100   8 Edge      vc4 hdmi cec tx
IPI0:      3802       6344      11929       5993       Rescheduling interrupts
IPI1:       852        595        542        770       Function call interrupts
IPI2:         0          0          0          0       CPU stop interrupts
IPI3:         0          0          0          0       CPU stop (for
crash dump) interrupts
IPI4:         0          0          0          0       Timer broadcast
interrupts
IPI5:       226        107         96        103       IRQ work interrupts
IPI6:         0          0          0          0       CPU wake-up interrupts
Err:          0
