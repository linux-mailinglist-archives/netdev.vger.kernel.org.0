Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCFE3EB399
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 11:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239491AbhHMJzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 05:55:02 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:42898
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239357AbhHMJzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 05:55:01 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id F06C141281
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628848473;
        bh=SrdDpuT8eQb6Wl4YhAW94RUzTcb218gwtO8WiF/FcKc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=fjoUp9FaEARxFo6ddm0rXiegWvuh1BJy68gqZpqmMUxNMr8W6ElJluOLQ1wqRSvT0
         qfr1Iwj1aJMOgUkEag9WY/V4JatJNXoxcHIIlB3lOkmPL9EnsQihzpNwNiSz7toKtj
         7OC6xXIMVzQ0i70a026VJi7PEHhaRVKXQMtT9grf6snygnUgxeRJZle5OOl8rPi3kC
         C56xViuhxKyNo3oiAcLatn7nn1Evx4Hs5TNZINa2MJOLRobUeEharzgqsFFHLzTwYk
         //3l7zEE6WRyujLehSwy6adPS7u6UHi021lKWFEQVCV1/BMNmxrVfkyHHlPhscCtP5
         Zh/tKGJSGQkEQ==
Received: by mail-ej1-f71.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so2784152ejc.8
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 02:54:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SrdDpuT8eQb6Wl4YhAW94RUzTcb218gwtO8WiF/FcKc=;
        b=BDJLjf1BoBZKctgVjO52eMLKOelCJbwJo6+YJRe3pWPWKmbjiPSjAnTtIkmOjDZyrS
         u9Yl+lhaHRA1uIXo1K3y3k3KwW99JRukOyNkt7cUwpdAlMqrjRWsPFFkuEpng4wSdVTt
         wDQPhegGlUo57nYfVOvPPn+7hO9Bam4Rf3/2xCl0ef0jqWtFg7E6b6k+zKUB5zItx6Rh
         wqRsu3OwpgvyjqvtFtOcXIM08Z7B1eC0R/hZDOGVikgiWwlGyWFwGag2yyir7Ybii/QF
         zqxehIHyyo2upQIsH5IdXtEWTeBIJW4mHeQC+GVme5MFyHzdNGCN6ZdKYXcIJFPvpO02
         mb3A==
X-Gm-Message-State: AOAM531Hkb1uAOIQfyJL9YjiHVPli0AuRYHCbOBcHtgxEtZqsZ1MkKwO
        H9d2uIywD8rvdHEd2d/wDmWTXH4RK7Cp0jN4D6Z4fbaVXgH4AKq32fE8f/P+Nkt5/w/jnmW+iHZ
        +6Wa3R0hhtSp/XoUNlvA09QIFclMTMSVzcG3OqRP/HOdm4Oj4Tg==
X-Received: by 2002:a17:907:7b81:: with SMTP id ne1mr1689010ejc.192.1628848473468;
        Fri, 13 Aug 2021 02:54:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhtmRHEIM0AOuAW6KIwZLRxkresgcPMt0enq+AjL0KoOp3FkiU2OeK1EVxtEBkcKOWfl8ctlTUjrIdlE11Nhk=
X-Received: by 2002:a17:907:7b81:: with SMTP id ne1mr1688994ejc.192.1628848473182;
 Fri, 13 Aug 2021 02:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210812155341.817031-1-kai.heng.feng@canonical.com> <631a47b7-f068-7770-65f4-bdfedc4b7d6c@gmail.com>
In-Reply-To: <631a47b7-f068-7770-65f4-bdfedc4b7d6c@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 13 Aug 2021 17:54:20 +0800
Message-ID: <CAAd53p7qVcnwLL-73J4J_QvEfca2Y=Mjr=G-7LaBPMX2FzRCFw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] r8169: Implement dynamic ASPM mechanism
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 2:49 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 12.08.2021 17:53, Kai-Heng Feng wrote:
> > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > Same issue can be observed with older vendor drivers.
> >
> > The issue is however solved by the latest vendor driver. There's a new
> > mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > more than 10 packets, and vice versa.
> >
> > Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
>
> As we have Realtek in this mail thread:

Is it still in active use? I always think it's just a dummy address...

> Typically hw issues affect 1-3 chip versions only. The ASPM problems seem
> to have been existing for at least 15 years now, in every chip version.
> It seems that even the new RTL8125 chip generation still has broken ASPM.

Is there a bug report for that?

> Why was this never fixed? ASPM not considered to be relevant? HW design
> too broken?

IIUC, ASPM is extremely relevant to pass EU/US power consumption
regulation. So I really don't know why the situation under Linux is so
dire.

Kai-Heng

>
> > use dynamic ASPM under Windows. So implement the same mechanism here to
> > resolve the issue.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v2:
> >  - Use delayed_work instead of timer_list to avoid interrupt context
> >  - Use mutex to serialize packet counter read/write
> >  - Wording change
> >
> >  drivers/net/ethernet/realtek/r8169_main.c | 45 +++++++++++++++++++++++
> >  1 file changed, 45 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index c7af5bc3b8af..7ab2e841dc69 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -624,6 +624,11 @@ struct rtl8169_private {
> >
> >       unsigned supports_gmii:1;
> >       unsigned aspm_manageable:1;
> > +     unsigned aspm_enabled:1;
> > +     struct delayed_work aspm_toggle;
> > +     struct mutex aspm_mutex;
> > +     u32 aspm_packet_count;
> > +
> >       dma_addr_t counters_phys_addr;
> >       struct rtl8169_counters *counters;
> >       struct rtl8169_tc_offsets tc_offset;
> > @@ -2671,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
> >       }
> >
> > +     tp->aspm_enabled = enable;
> > +
> >       udelay(10);
> >  }
> >
> > @@ -4408,6 +4415,9 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
> >
> >       dirty_tx = tp->dirty_tx;
> >
> > +     mutex_lock(&tp->aspm_mutex);
> > +     tp->aspm_packet_count += tp->cur_tx - dirty_tx;
> > +     mutex_unlock(&tp->aspm_mutex);
> >       while (READ_ONCE(tp->cur_tx) != dirty_tx) {
> >               unsigned int entry = dirty_tx % NUM_TX_DESC;
> >               u32 status;
> > @@ -4552,6 +4562,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
> >               rtl8169_mark_to_asic(desc);
> >       }
> >
> > +     mutex_lock(&tp->aspm_mutex);
> > +     tp->aspm_packet_count += count;
> > +     mutex_unlock(&tp->aspm_mutex);
> > +
> >       return count;
> >  }
> >
> > @@ -4659,8 +4673,33 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
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
> > +     bool enable;
> > +
> > +     mutex_lock(&tp->aspm_mutex);
> > +     enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
> > +     tp->aspm_packet_count = 0;
> > +     mutex_unlock(&tp->aspm_mutex);
> > +
> > +     if (tp->aspm_enabled != enable) {
> > +             rtl_unlock_config_regs(tp);
> > +             rtl_hw_aspm_clkreq_enable(tp, enable);
> > +             rtl_lock_config_regs(tp);
> > +     }
> > +
> > +     schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
> > +}
> > +
> >  static void rtl8169_down(struct rtl8169_private *tp)
> >  {
> > +     cancel_delayed_work_sync(&tp->aspm_toggle);
> > +
> >       /* Clear all task flags */
> >       bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
> >
> > @@ -4687,6 +4726,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
> >       rtl_reset_work(tp);
> >
> >       phy_start(tp->phydev);
> > +
> > +     schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
> >  }
> >
> >  static int rtl8169_close(struct net_device *dev)
> > @@ -5347,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >
> >       INIT_WORK(&tp->wk.work, rtl_task);
> >
> > +     INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
> > +
> > +     mutex_init(&tp->aspm_mutex);
> > +
> >       rtl_init_mac_address(tp);
> >
> >       dev->ethtool_ops = &rtl8169_ethtool_ops;
> >
>
