Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926B3F114C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 05:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhHSDL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 23:11:56 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60472
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235770AbhHSDLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 23:11:54 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 81E5840CCB
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 03:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629342678;
        bh=d09GlAzprtFjTslwCwVH3/69opIncO+DTS6YfL9TjBY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=gF4bFZpZdmq/MN1ZfvZ5nEqv43jso9BDZak6lzVN2B9IxmfMLxjna/pvJQQxwi8qw
         a5vY82NNHGvvO494inX8RnfaRCfdDyrgrDCgAmCjzKWbtt80qUgMfcz6tjhOIcx4XQ
         KB2CKo4OTpw4XJ1dvSh+/LVBImr748h1xjp2zHRtztf3yd3I6nHy3zrXA7BE41hMBa
         JSHbKuLXIZxoJn592VrB8W8F12f1dXWHh7ilh7Ahokq5cGm0IhcEQMPPR4xnBfmhUN
         imHTeKS3L8VARGUQAbiXweOelJPQBwYDXeMesL7Pavl+k1kz2SzyFVMVXvRkFKnmM2
         2+kxW3EZ8EIKQ==
Received: by mail-ed1-f70.google.com with SMTP id f21-20020a056402005500b003bf4e6b5b96so316683edu.5
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 20:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d09GlAzprtFjTslwCwVH3/69opIncO+DTS6YfL9TjBY=;
        b=KAQ1ODSxo9ENKjWELTqijJ3OGIukCvozy4JR753SZGt9REsud3ML9xFrgoRk+K+rXg
         dcqlI5r23pHAydMWh83LYZCmNdwpt0xpxZViE5GLhnPZQJFzKexD9ILGRMZF1uHXx+BN
         O9zhMy54H4McgIwZ2A6DiM3s7wx2gI9KGqx81vbeg4lNZs198SqOKvNvM2A7GbwnQM2G
         CVuAoLQcvy6ITy9DJ4xaBP1JSG16UR0hlAS5dmmNl5OcjVYUz5kQkvpWcT2FdgKEb2xE
         uTs+VALKCYJKrsvStJ7CJGA+lStqXgwxbbgDdA5Glf8kKkU+eQHA5ldRlD1n4SepuVnz
         XDzw==
X-Gm-Message-State: AOAM532pE+2jxzx6ur2vnY6PcQP3mintbj7X4hpGuSE67dsZACJiFISN
        zZ9TObVUEohAMvJ3f2VCQj/uP5/5IwC42T8ZUgzRJ6/jhLur/4327ZJGqpsEiHnxUlJ3pCA1Til
        yyiMv+GCDZLjAb8bTP35e8iSyqIl+az9QF//Gb3S1dy82/Kpd8Q==
X-Received: by 2002:a17:906:87c2:: with SMTP id zb2mr13193505ejb.322.1629342678109;
        Wed, 18 Aug 2021 20:11:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWrsB/K13mNEpyjYOgVG3U2mdfpzylK5z5h1Gl5IeBpe560SUsiwiLN4VkHkkoDQBFuXnjqlhgsakEyjdReDU=
X-Received: by 2002:a17:906:87c2:: with SMTP id zb2mr13193485ejb.322.1629342677724;
 Wed, 18 Aug 2021 20:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
 <631a47b7-f068-7770-65f4-bdfedc4b7d6c@gmail.com> <CAAd53p7qVcnwLL-73J4J_QvEfca2Y=Mjr=G-7LaBPMX2FzRCFw@mail.gmail.com>
 <0c08f92a-2e06-8917-3726-4b67bd875dbc@gmail.com>
In-Reply-To: <0c08f92a-2e06-8917-3726-4b67bd875dbc@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Thu, 19 Aug 2021 11:11:06 +0800
Message-ID: <CAAd53p7anTVx_NXg7fx8-rMStpPpxxWs_3QGvSnNXtZGdggb6g@mail.gmail.com>
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

On Sat, Aug 14, 2021 at 7:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 13.08.2021 11:54, Kai-Heng Feng wrote:
> > On Fri, Aug 13, 2021 at 2:49 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 12.08.2021 17:53, Kai-Heng Feng wrote:
> >>> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> >>> Same issue can be observed with older vendor drivers.
> >>>
> >>> The issue is however solved by the latest vendor driver. There's a new
> >>> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> >>> more than 10 packets, and vice versa.
> >>>
> >>> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> >>
> >> As we have Realtek in this mail thread:
> >
> > Is it still in active use? I always think it's just a dummy address...
> At least mails to this address are not bounced, and this address still is
> in MAINTAINERS. But right, I've never any reaction on mails to this
> address. So it may make sense to remove it from MAINTAINERS.
> Not sure what the process would be to do this.
>
> >
> >> Typically hw issues affect 1-3 chip versions only. The ASPM problems seem
> >> to have been existing for at least 15 years now, in every chip version.
> >> It seems that even the new RTL8125 chip generation still has broken ASPM.
> >
> > Is there a bug report for that?
> >
> No. This was referring to your statement that also r8125 vendor driver
> includes this "dynamic ASPM" workaround. They wouldn't have done this
> if RTL8125 had proper ASPM support, or?

They call it "performance tuning".

>
> >> Why was this never fixed? ASPM not considered to be relevant? HW design
> >> too broken?
> >
> > IIUC, ASPM is extremely relevant to pass EU/US power consumption
> > regulation. So I really don't know why the situation under Linux is so
> > dire.
> >
> It's not something related to Linux, ASPM support in the Realtek chips
> is simply broken. This needs to be fixed in HW.
> The behavior we see may indicate that certain buffers in the chips are
> too small to buffer traffic for full period of ASPM exit latency.

The smaller buffers is part of the reason why they are dirt cheap and
makes them so pervasive...
So the dynamic ASPM is actually a good thing because it can deal with
this defect and saves power at the same time.

Kai-Heng

>
> > Kai-Heng
> >
> >>
> >>> use dynamic ASPM under Windows. So implement the same mechanism here to
> >>> resolve the issue.
> >>>
> >>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >>> ---
> >>> v2:
> >>>  - Use delayed_work instead of timer_list to avoid interrupt context
> >>>  - Use mutex to serialize packet counter read/write
> >>>  - Wording change
> >>>
> >>>  drivers/net/ethernet/realtek/r8169_main.c | 45 +++++++++++++++++++++++
> >>>  1 file changed, 45 insertions(+)
> >>>
> >>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >>> index c7af5bc3b8af..7ab2e841dc69 100644
> >>> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >>> @@ -624,6 +624,11 @@ struct rtl8169_private {
> >>>
> >>>       unsigned supports_gmii:1;
> >>>       unsigned aspm_manageable:1;
> >>> +     unsigned aspm_enabled:1;
> >>> +     struct delayed_work aspm_toggle;
> >>> +     struct mutex aspm_mutex;
> >>> +     u32 aspm_packet_count;
> >>> +
> >>>       dma_addr_t counters_phys_addr;
> >>>       struct rtl8169_counters *counters;
> >>>       struct rtl8169_tc_offsets tc_offset;
> >>> @@ -2671,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >>>               RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
> >>>       }
> >>>
> >>> +     tp->aspm_enabled = enable;
> >>> +
> >>>       udelay(10);
> >>>  }
> >>>
> >>> @@ -4408,6 +4415,9 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
> >>>
> >>>       dirty_tx = tp->dirty_tx;
> >>>
> >>> +     mutex_lock(&tp->aspm_mutex);
> >>> +     tp->aspm_packet_count += tp->cur_tx - dirty_tx;
> >>> +     mutex_unlock(&tp->aspm_mutex);
> >>>       while (READ_ONCE(tp->cur_tx) != dirty_tx) {
> >>>               unsigned int entry = dirty_tx % NUM_TX_DESC;
> >>>               u32 status;
> >>> @@ -4552,6 +4562,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
> >>>               rtl8169_mark_to_asic(desc);
> >>>       }
> >>>
> >>> +     mutex_lock(&tp->aspm_mutex);
> >>> +     tp->aspm_packet_count += count;
> >>> +     mutex_unlock(&tp->aspm_mutex);
> >>> +
> >>>       return count;
> >>>  }
> >>>
> >>> @@ -4659,8 +4673,33 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
> >>>       return 0;
> >>>  }
> >>>
> >>> +#define ASPM_PACKET_THRESHOLD 10
> >>> +#define ASPM_TOGGLE_INTERVAL 1000
> >>> +
> >>> +static void rtl8169_aspm_toggle(struct work_struct *work)
> >>> +{
> >>> +     struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
> >>> +                                               aspm_toggle.work);
> >>> +     bool enable;
> >>> +
> >>> +     mutex_lock(&tp->aspm_mutex);
> >>> +     enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
> >>> +     tp->aspm_packet_count = 0;
> >>> +     mutex_unlock(&tp->aspm_mutex);
> >>> +
> >>> +     if (tp->aspm_enabled != enable) {
> >>> +             rtl_unlock_config_regs(tp);
> >>> +             rtl_hw_aspm_clkreq_enable(tp, enable);
> >>> +             rtl_lock_config_regs(tp);
> >>> +     }
> >>> +
> >>> +     schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
> >>> +}
> >>> +
> >>>  static void rtl8169_down(struct rtl8169_private *tp)
> >>>  {
> >>> +     cancel_delayed_work_sync(&tp->aspm_toggle);
> >>> +
> >>>       /* Clear all task flags */
> >>>       bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
> >>>
> >>> @@ -4687,6 +4726,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
> >>>       rtl_reset_work(tp);
> >>>
> >>>       phy_start(tp->phydev);
> >>> +
> >>> +     schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
> >>>  }
> >>>
> >>>  static int rtl8169_close(struct net_device *dev)
> >>> @@ -5347,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>>
> >>>       INIT_WORK(&tp->wk.work, rtl_task);
> >>>
> >>> +     INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
> >>> +
> >>> +     mutex_init(&tp->aspm_mutex);
> >>> +
> >>>       rtl_init_mac_address(tp);
> >>>
> >>>       dev->ethtool_ops = &rtl8169_ethtool_ops;
> >>>
> >>
>
