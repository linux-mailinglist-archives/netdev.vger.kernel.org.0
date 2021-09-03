Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5BA4002BA
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349813AbhICP52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:57:28 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36696
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349760AbhICP51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 11:57:27 -0400
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9E1F54017F
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630684586;
        bh=npwnkinRUjbWFwTW3lB4R+la4/oRddSoWvIxhax/+MA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=TIJX/gByvIoxJtkAuV0LMVyhlJhGlXhqrHbuJgdkOS7xDH7FlIIpJXkyxxN4RzAkI
         JHt+rE5vkJDdtX2wxyNHKbCtAcRFPUHsu61qTb7TJCxtlSvxn0H7RGGr8T1RikvMw+
         EhdUYahTBcP6Xup10vusra+jvn7pqWWugvNJRBEf8Xx/hWlUFsQGeGSHW5jO4yt90+
         o603Ub8fPghlLnqYV4O2/X4v8SXq8uBspVKHnh0vvxeAtOqxbNdCZPdD6Evpf5EPmj
         /hFn37YeqX7sihe7m2JwbZEnJz4Yfx4A553ePOMJc5mf3rHQJLd8D8nBYVsKiqd1GJ
         sL9U+z2qlyO0A==
Received: by mail-ej1-f69.google.com with SMTP id q15-20020a17090622cf00b005c42d287e6aso2922494eja.18
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 08:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npwnkinRUjbWFwTW3lB4R+la4/oRddSoWvIxhax/+MA=;
        b=Au8gLQ48JxLEAFKXqfzeXrpJDURasqHa9MDbxVMVieaqli6YmT9di02zvmpnfl6y/c
         JCWAKXzvqDHOTjZASuqnArZ4Wm/dJW4jRTtu+FajAtgIQh/Wkd/Z9rkPbeOUfX1R3Bak
         cL4T5/H9BVs0BauiruLR68+lvD6hoD4elZI8ccBXA6IBs7FmEz9OcB6ljNvmqWD5s36d
         dQ/fgUuJSwCf+jDqnEOBoYlDIckTfAG4fWhI3LLX2yd1ve6Pf1yR89iRn7yfLCF2ADik
         3S2D2FYIJiOgEGwqRSJEEl+alaLV5Vj4F7MFJNHWt3FDVbMRjIDdWWnBItwn9Ebvb9qH
         8GRg==
X-Gm-Message-State: AOAM532NMdJr0jvtKJzC8S8OBb88Kou77oMuU4TimNIUWkx+IoXh850P
        5qtqJPQNz13PbXOOCp9qZ/RWpOXehgrm757gfH3qDUBl8RCtClwwzIBMFDPv/+yCuPj7fpQEgAp
        ooYaE7jN8h4pFvdbSmdDhNJa/o+bouYfcVXI3gKlelsCsaz0GQw==
X-Received: by 2002:a17:906:1e97:: with SMTP id e23mr5028250ejj.336.1630684586267;
        Fri, 03 Sep 2021 08:56:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz74Mit3ppBvU+YFh7C9xWkgrlXdy5fNGbXmeIn7QL4VgeMdAZe15wp7j4zrXyllTOm33QeNf6TvEsrYscZ7L8=
X-Received: by 2002:a17:906:1e97:: with SMTP id e23mr5028212ejj.336.1630684585878;
 Fri, 03 Sep 2021 08:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210827171452.217123-3-kai.heng.feng@canonical.com> <20210830180940.GA4209@bjorn-Precision-5520>
In-Reply-To: <20210830180940.GA4209@bjorn-Precision-5520>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 3 Sep 2021 23:56:14 +0800
Message-ID: <CAAd53p634-nxEYYDbc69JEVev=cFkqtdCJv5UjAFCDUqdNAk_A@mail.gmail.com>
Subject: Re: [RFC] [PATCH net-next v4] [PATCH 2/2] r8169: Implement dynamic
 ASPM mechanism
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 2:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Sat, Aug 28, 2021 at 01:14:52AM +0800, Kai-Heng Feng wrote:
> > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > Same issue can be observed with older vendor drivers.
> >
> > The issue is however solved by the latest vendor driver. There's a new
> > mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > more than 10 packets, and vice versa. The possible reason for this is
> > likely because the buffer on the chip is too small for its ASPM exit
> > latency.
>
> This sounds like good speculation, but of course, it would be better
> to have the supporting data.
>
> You say above that this problem affects r8169 on "some platforms."  I
> infer that ASPM works fine on other platforms.  It would be extremely
> interesting to have some data on both classes, e.g., "lspci -vv"
> output for the entire system.

lspci data collected from working and non-working system can be found here:
https://bugzilla.kernel.org/show_bug.cgi?id=214307

>
> If r8169 ASPM works well on some systems, we *should* be able to make
> it work well on *all* systems, because the device can't tell what
> system it's in.  All the device can see are the latencies for entry
> and exit for link states.

That's definitely better if we can make r8169 ASPM work for all platforms.

>
> IIUC this patch makes the driver wake up every 1000ms.  If the NIC has
> sent or received more than 10 packets in the last 1000ms, it disables
> ASPM; otherwise it enables ASPM.

Yes, that's correct.

>
> I asked these same questions earlier, but nothing changed, so I won't
> raise them again if you don't think they're pertinent.  Some patch
> splitting comments below.

Sorry about that. The lspci data is attached.

>
> > Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> > use dynamic ASPM under Windows. So implement the same mechanism here to
> > resolve the issue.
> >
> > Because ASPM control may not be granted by BIOS while ASPM is enabled,
> > remove aspm_manageable and use pcie_aspm_capable() instead. If BIOS
> > enables ASPM for the device, we want to enable dynamic ASPM on it.
> >
> > In addition, since PCIe ASPM can be switched via sysfs, enable/disable
> > dynamic ASPM accordingly by checking pcie_aspm_enabled().
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v4:
> >  - Squash two patches
> >  - Remove aspm_manageable and use pcie_aspm_capable()
> >    pcie_aspm_enabled() accordingly
> >
> > v3:
> >  - Use msecs_to_jiffies() for delay time
> >  - Use atomic_t instead of mutex for bh
> >  - Mention the buffer size and ASPM exit latency in commit message
> >
> > v2:
> >  - Use delayed_work instead of timer_list to avoid interrupt context
> >  - Use mutex to serialize packet counter read/write
> >  - Wording change
> >  drivers/net/ethernet/realtek/r8169_main.c | 77 ++++++++++++++++++++---
> >  1 file changed, 69 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 46a6ff9a782d7..97dba8f437b78 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -623,7 +623,10 @@ struct rtl8169_private {
> >       } wk;
> >
> >       unsigned supports_gmii:1;
> > -     unsigned aspm_manageable:1;
> > +     unsigned rtl_aspm_enabled:1;
> > +     struct delayed_work aspm_toggle;
> > +     atomic_t aspm_packet_count;
> > +
> >       dma_addr_t counters_phys_addr;
> >       struct rtl8169_counters *counters;
> >       struct rtl8169_tc_offsets tc_offset;
> > @@ -698,6 +701,20 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
> >              tp->mac_version <= RTL_GIGA_MAC_VER_53;
> >  }
> >
> > +static int rtl_supports_aspm(struct rtl8169_private *tp)
> > +{
> > +     switch (tp->mac_version) {
> > +     case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_31:
> > +     case RTL_GIGA_MAC_VER_37:
> > +     case RTL_GIGA_MAC_VER_39:
> > +     case RTL_GIGA_MAC_VER_43:
> > +     case RTL_GIGA_MAC_VER_47:
> > +             return 0;
> > +     default:
> > +             return 1;
> > +     }
>
> This part looks like it should be a separate patch.  I would think
> rtl_init_one() could call this once and set a bit in rtl8169_private.
> Then rtl_hw_aspm_clkreq_enable() could just return without doing
> anything if the bit is not set.

OK, will do in next version.

>
> > +}
> > +
> >  static bool rtl_supports_eee(struct rtl8169_private *tp)
> >  {
> >       return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
> > @@ -2699,8 +2716,15 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
> >
> >  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >  {
> > +     struct pci_dev *pdev = tp->pci_dev;
> > +
> > +     if (!pcie_aspm_enabled(pdev) && enable)
> > +             return;
> > +
> > +     tp->rtl_aspm_enabled = enable;
> > +
> >       /* Don't enable ASPM in the chip if OS can't control ASPM */
> > -     if (enable && tp->aspm_manageable) {
> > +     if (enable) {
>
> This part also looks like it should be a separate patch, since it is
> strictly concerned with whether the OS can control ASPM and doesn't
> seem related to dynamic ASPM.

OK, will tackle this in next version.

Kai-Heng

>
> >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
> >               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
> >       } else {
> > @@ -4440,6 +4464,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
> >
> >       dirty_tx = tp->dirty_tx;
> >
> > +     atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
> >       while (READ_ONCE(tp->cur_tx) != dirty_tx) {
> >               unsigned int entry = dirty_tx % NUM_TX_DESC;
> >               u32 status;
> > @@ -4584,6 +4609,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
> >               rtl8169_mark_to_asic(desc);
> >       }
> >
> > +     atomic_add(count, &tp->aspm_packet_count);
> > +
> >       return count;
> >  }
> >
> > @@ -4691,8 +4718,39 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
> >       return 0;
> >  }
> >
> > +#define ASPM_PACKET_THRESHOLD 10
> > +#define ASPM_TOGGLE_INTERVAL 1000
> > +
> > +static void rtl8169_aspm_toggle(struct work_struct *work)
> > +{
> > +     struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
> > +                                               aspm_toggle.work);
> > +     int packet_count;
> > +     bool enable;
> > +
> > +     packet_count = atomic_xchg(&tp->aspm_packet_count, 0);
> > +
> > +     if (pcie_aspm_enabled(tp->pci_dev)) {
> > +             enable = packet_count <= ASPM_PACKET_THRESHOLD;
> > +
> > +             if (tp->rtl_aspm_enabled != enable) {
> > +                     rtl_unlock_config_regs(tp);
> > +                     rtl_hw_aspm_clkreq_enable(tp, enable);
> > +                     rtl_lock_config_regs(tp);
> > +             }
> > +     } else if (tp->rtl_aspm_enabled) {
> > +             rtl_unlock_config_regs(tp);
> > +             rtl_hw_aspm_clkreq_enable(tp, false);
> > +             rtl_lock_config_regs(tp);
> > +     }
> > +
> > +     schedule_delayed_work(&tp->aspm_toggle, msecs_to_jiffies(ASPM_TOGGLE_INTERVAL));
> > +}
> > +
> >  static void rtl8169_down(struct rtl8169_private *tp)
> >  {
> > +     cancel_delayed_work_sync(&tp->aspm_toggle);
> > +
> >       /* Clear all task flags */
> >       bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
> >
> > @@ -4719,6 +4777,11 @@ static void rtl8169_up(struct rtl8169_private *tp)
> >       rtl_reset_work(tp);
> >
> >       phy_start(tp->phydev);
> > +
> > +     /* pcie_aspm_capable may change after system resume */
> > +     if (pcie_aspm_support_enabled() && pcie_aspm_capable(tp->pci_dev) &&
> > +         rtl_supports_aspm(tp))
> > +             schedule_delayed_work(&tp->aspm_toggle, 0);
> >  }
> >
> >  static int rtl8169_close(struct net_device *dev)
> > @@ -5306,12 +5369,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       if (rc)
> >               return rc;
> >
> > -     /* Disable ASPM L1 as that cause random device stop working
> > -      * problems as well as full system hangs for some PCIe devices users.
> > -      */
> > -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > -     tp->aspm_manageable = !rc;
> > -
> >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> >       rc = pcim_enable_device(pdev);
> >       if (rc < 0) {
> > @@ -5378,6 +5435,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >
> >       INIT_WORK(&tp->wk.work, rtl_task);
> >
> > +     INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
> > +
> > +     atomic_set(&tp->aspm_packet_count, 0);
> > +
> >       rtl_init_mac_address(tp);
> >
> >       dev->ethtool_ops = &rtl8169_ethtool_ops;
> > --
> > 2.32.0
> >
