Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4072542648A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 08:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhJHGVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 02:21:14 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:36616
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229511AbhJHGVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 02:21:12 -0400
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E75BD3FFF5
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 06:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633673949;
        bh=cWlG5EYoT1/7D4Ww3p1KH0SaTmrnnM0OXvZ9d+n2OgE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=k2EsFJWA0U62bPcg5/9adAVpw3kD27nA/4ZmP481RS80R7KsvDUSPqZg5V+ttZIrq
         BqOkfcmhpgKxxb7GtNyaUHrTHIMsE5OHtAhheiz6Ul81ySyfhuueEvXfzahuhZjpEB
         A9tfBK8zjXvLbRKxzV9qO2bfLtyNrFlrwBh6ddabh3n2di8OBdH+93igjXc0cLInA5
         xwAkCymXPAkBZklwczTwZ5eQr2o/3CVnbgr4EP9+1LFrnvf9FNZHDfTAfJcmj1WPNt
         X+DMWPAc+AEkYxRtUIQBtx2ZNqJq6pZ5JWGpdA8VXxSwc0VqqcL8gBbM6eh9vInW4K
         +YyHrJu7b1anw==
Received: by mail-ot1-f70.google.com with SMTP id 100-20020a9d02ed000000b0054e1a7095faso4919360otl.5
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 23:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cWlG5EYoT1/7D4Ww3p1KH0SaTmrnnM0OXvZ9d+n2OgE=;
        b=7MM3MWT7LRQ0tgEJwsqrGRVgFc4rvMMjml/IztUtxeDDDzq9YLSY2o38ThgugnfKx4
         ArUT0kiGHAwx3HRc2D/8D/EEoHthWCrnMjSyDx62gU1BpO49IiT6W70mrcjziF7raKuH
         LPg39ptfU3PsF1b4OjZIXYdowYyHohSjecCO2ntw9JH92s3zbaM23ftevRIdMnkF/tpO
         XkadbHWR5tMlcnzXYrni2H0Bpt3Jcp7engx2onaxD3Q02+9EY8T8TIL0LbTdMGFwAq57
         b5CfRakho7UiM6n0Tc33JgLcLVnkBUFIyVemkT+6H+IDui4yzovusjRjx4r944BIINpo
         9SHw==
X-Gm-Message-State: AOAM533RW/eo0OeUVcv6oaig8vysnAcCf7oDdpDp3QknHtVnjQ/G1ShR
        znbumMlfQV6RFbsLvI4ptJsiR5CpH5gH2MDaSJZdp0rbmqvbaY5tMBj1hQUQz6GDUzVxVCScPMo
        kmLZgcbn8Os5U9ECtmL8+kPU2Pm6PVtxskjs3GrGk8P7qIoWY0A==
X-Received: by 2002:a05:6808:10d5:: with SMTP id s21mr15017821ois.98.1633673948038;
        Thu, 07 Oct 2021 23:19:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoKs7eNdX07+xhGn6S4+OMQyiafBCTyV7LTMSWU3wT9Iiz6zcHyvedXe5fFfl1fHj7cR7wRAZ/xK2aba2UmAg=
X-Received: by 2002:a05:6808:10d5:: with SMTP id s21mr15017782ois.98.1633673947178;
 Thu, 07 Oct 2021 23:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20211007161552.272771-4-kai.heng.feng@canonical.com> <20211007191108.GA1250550@bhelgaas>
In-Reply-To: <20211007191108.GA1250550@bhelgaas>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 8 Oct 2021 14:18:55 +0800
Message-ID: <CAAd53p4v+CmupCu2+3vY5N64WKkxcNvpk1M7+hhNoposx+aYCg@mail.gmail.com>
Subject: Re: [RFC] [PATCH net-next v6 3/3] r8169: Implement dynamic ASPM mechanism
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

On Fri, Oct 8, 2021 at 3:11 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Fri, Oct 08, 2021 at 12:15:52AM +0800, Kai-Heng Feng wrote:
> > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > Same issue can be observed with older vendor drivers.
> >
> > The issue is however solved by the latest vendor driver. There's a new
> > mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > more than 10 packets per second, and vice versa. The possible reason for
> > this is likely because the buffer on the chip is too small for its ASPM
> > exit latency.
>
> Because the NIC works fine on some platforms with ASPM fully enabled,
> I would describe this as a "workaround" for a bug where we don't know
> the root cause, not a "solution".

OK, will change the wording.

>
> > Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> > use dynamic ASPM under Windows. So implement the same mechanism here to
> > resolve the issue.
> >
> > Also introduce a lock to prevent race on accessing config registers.
>
> Strictly speaking, the addition of the lock should be a separate patch
> since it's not directly related to the ASPM change.

Will separate it to another patch.

>
> A little more below...
>
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214307
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v6:
> >  - Wording change.
> >  - Add bugzilla link.
> >
> > v5:
> >  - Split out aspm_manageable replacement as another patch.
> >  - Introduce a lock for lock_config_regs() and unlock_config_regs().
> >
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
> >  drivers/net/ethernet/realtek/r8169_main.c | 58 +++++++++++++++++++++--
> >  1 file changed, 53 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 53936ebb3b3a6..9c10a908c08fb 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -622,6 +622,11 @@ struct rtl8169_private {
> >       } wk;
> >
> >       unsigned supports_gmii:1;
> > +     unsigned rtl_aspm_enabled:1;
> > +     struct delayed_work aspm_toggle;
> > +     atomic_t aspm_packet_count;
> > +     struct mutex config_lock;
> > +
> >       dma_addr_t counters_phys_addr;
> >       struct rtl8169_counters *counters;
> >       struct rtl8169_tc_offsets tc_offset;
> > @@ -670,12 +675,14 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
> >
> >  static void rtl_lock_config_regs(struct rtl8169_private *tp)
> >  {
> > +     mutex_lock(&tp->config_lock);
> >       RTL_W8(tp, Cfg9346, Cfg9346_Lock);
> >  }
> >
> >  static void rtl_unlock_config_regs(struct rtl8169_private *tp)
> >  {
> >       RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
> > +     mutex_unlock(&tp->config_lock);
> >  }
> >
> >  static void rtl_pci_commit(struct rtl8169_private *tp)
> > @@ -2669,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >       if (!pcie_aspm_support_enabled() || !pcie_aspm_capable(pdev))
> >               return;
> >
> > +     tp->rtl_aspm_enabled = enable;
> > +
> >       if (enable) {
> >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
> >               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
> > @@ -4407,6 +4416,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
> >
> >       dirty_tx = tp->dirty_tx;
> >
> > +     atomic_add(tp->cur_tx - dirty_tx, &tp->aspm_packet_count);
> >       while (READ_ONCE(tp->cur_tx) != dirty_tx) {
> >               unsigned int entry = dirty_tx % NUM_TX_DESC;
> >               u32 status;
> > @@ -4551,6 +4561,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
> >               rtl8169_mark_to_asic(desc);
> >       }
> >
> > +     atomic_add(count, &tp->aspm_packet_count);
> > +
> >       return count;
> >  }
> >
> > @@ -4658,8 +4670,39 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
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
>
> IIUC the way the "dynamic ASPM" works is that rtl8169_aspm_toggle()
> runs every second (1000ms).  If the NIC has sent or received fewer
> than 10 packets in the last second, you make sure ASPM is enabled.  If
> it has sent or received more than 10 packets, you disable ASPM.

Yes, this is what this patch does.

>
> Since the disable is done in rtl_hw_aspm_clkreq_enable() with
> chip-specific registers, I suppose lspci and the like still show ASPM
> as being enabled.  Not really a problem, I guess.
>
> It looks like this disables ASPM completely, even though the NIC
> apparently works correctly with L0s and L1.1 enabled, right?

I've seen bug reports that ASPM L0s and L1.1 caused the NIC stops to working.
So dynamic ASPM strikes the right

>
> I suppose that on the Intel system, if we enable ASPM, the link goes
> to L1.2, and the NIC immediately receives 1000 packets in that second
> before we can disable ASPM again, we probably drop a few packets?
>
> Whereas on the AMD system, we probably *never* drop any packets even
> with L1.2 enabled all the time?

Yes and yes.

>
> And if we actually knew the root cause and could set the correct LTR
> values or whatever is wrong on the Intel system, we probably wouldn't
> need this dynamic scheme?

Because Realtek already implemented the dynamic ASPM workaround in
their Windows and Linux driver, they never bother to find the root
cause.
So we'll never know what really happens here.

Kai-Heng

>
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
> > @@ -4686,6 +4729,10 @@ static void rtl8169_up(struct rtl8169_private *tp)
> >       rtl_reset_work(tp);
> >
> >       phy_start(tp->phydev);
> > +
> > +     /* pcie_aspm_capable may change after system resume */
> > +     if (pcie_aspm_support_enabled() && pcie_aspm_capable(tp->pci_dev))
> > +             schedule_delayed_work(&tp->aspm_toggle, 0);
> >  }
> >
> >  static int rtl8169_close(struct net_device *dev)
> > @@ -5273,11 +5320,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       if (rc)
> >               return rc;
> >
> > -     /* Disable ASPM L1 as that cause random device stop working
> > -      * problems as well as full system hangs for some PCIe devices users.
> > -      */
> > -     pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > -
> >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> >       rc = pcim_enable_device(pdev);
> >       if (rc < 0) {
> > @@ -5307,6 +5349,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >               return rc;
> >       }
> >
> > +     mutex_init(&tp->config_lock);
> > +
> >       tp->mmio_addr = pcim_iomap_table(pdev)[region];
> >
> >       xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
> > @@ -5344,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
