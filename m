Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E0040C90E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhIOP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:56:00 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:41444
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234334AbhIOPz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 11:55:59 -0400
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 656BF402CE
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631721279;
        bh=ueSFxhfWFil0IlgAFMYQeGjlmsHbDXN3YHC8WlG95pA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=dIG/eA3YTMgGGojLtg6FU8xmRn5Lrk7p4zWOK45hrBzRz5jjAkd5fpFa4n1QCrf19
         nne76emuKGBMNvWKa5325hAo+Xzgce9K7D4VjgGmMi/dqdKL3MzQvbu5ST1fH1lTi5
         SHdRu0wmTQpkre6kMFyZ0ZS2WA4nY6MjmoZ6GD/ZN6mDgOzVhEN3zClpsJx3+cM0q5
         JYQsdmtV3R+rhy2rSmJiuZEyn2P88ds6AOgYnXXGSmwrjcikR9yre7kfU+oCApwEFD
         XNXh9D7Qmchk6S6AmvNKDDkA8D8AsIe8TJr4tjJVquVjmV7oiE296iRPg+jIfVhtzL
         +w/FMsejK+usA==
Received: by mail-oo1-f69.google.com with SMTP id e26-20020a4ada1a000000b00290b0695382so3138007oou.0
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 08:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ueSFxhfWFil0IlgAFMYQeGjlmsHbDXN3YHC8WlG95pA=;
        b=W2Qzh+oEygmrCtPwpXVO+GSa8e7cZ9ymZsrETbPxNqUWL7LX7fe/Xq2V+oFGMsCx2B
         SMx2FJeNtWdi3fBzqlaCMUzxoWPWDkUl5ajrROrHFRE4WiL+vdFAZZ/GKazvd0UF6ecj
         HWq0zKs2fgCkmiYzUE98M5xHrMQr752/Iebcxvozi7tpyJMN03OetVIAhT1ubeZpk5Em
         +ir8nt/wJc7b38JKjZaYcVOGKELAp9eRZ53DOZdVhqwZmaxOplsyQsk9E5ASvwL1cq1/
         yywT3HGUQcUaxkOjAU5CMyWEtvc2DWFYWdjswDaPxg/+KdxkdOjXYmijU2A6akwKncc5
         xwsQ==
X-Gm-Message-State: AOAM531oLyYDoiDAiZmm4/DjlbR+rZZwMS56TDVm2UygFeBudLphRsNx
        vDKeA0gR1ZsK70crceJ7bD/rTo4S78gZDEia1vEhn6bY7awMjyKjMsqQcnBDj8svOOZqCjkfaW8
        /MQHzGr8n2uUj4DcABVmWt7Q9QilEsqFP/xg20osq0FnZHYASmg==
X-Received: by 2002:a05:6808:1243:: with SMTP id o3mr5780645oiv.146.1631721278077;
        Wed, 15 Sep 2021 08:54:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLkAq4LSefU34adzhJIvNH7MiMMnSbs5Q0CRchVTKMxYbv92jyFPoShrmQpnkNQIpzF7YbTxViqbCpqaoSoco=
X-Received: by 2002:a05:6808:1243:: with SMTP id o3mr5780624oiv.146.1631721277728;
 Wed, 15 Sep 2021 08:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210827171452.217123-1-kai.heng.feng@canonical.com>
 <20210827171452.217123-3-kai.heng.feng@canonical.com> <2839f04c-8d7b-b010-f7c4-540359037d38@gmail.com>
In-Reply-To: <2839f04c-8d7b-b010-f7c4-540359037d38@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 15 Sep 2021 23:54:25 +0800
Message-ID: <CAAd53p4fih84-jT-gpG+er=piArCR+VNx=Srr51CQyLd4Ogd8A@mail.gmail.com>
Subject: Re: [RFC] [PATCH net-next v4] [PATCH 2/2] r8169: Implement dynamic
 ASPM mechanism
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
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

On Tue, Sep 7, 2021 at 2:03 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 27.08.2021 19:14, Kai-Heng Feng wrote:
> > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > Same issue can be observed with older vendor drivers.
> >
> > The issue is however solved by the latest vendor driver. There's a new
> > mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > more than 10 packets, and vice versa. The possible reason for this is
> > likely because the buffer on the chip is too small for its ASPM exit
> > latency.
> >
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
> Why is this needed now that you have pcie_aspm_capable()?

The black list is copied from vendor driver.
Will remove it in next iteration and hopefully pcie_aspm_capable() is
sufficient.

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
>
> This looks racy. Another unlock_config_regs/do_something/lock_config_regs
> can run in parallel. And if such a parallel lock_config_regs is executed
> exactly here, then rtl_hw_aspm_clkreq_enable() may fail.

Yes this is racy.
Will add a lock to prevent the race.

Kai-Heng

>
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
> >
>
