Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44923EB384
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 11:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhHMJrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 05:47:35 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35200
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239866AbhHMJre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 05:47:34 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 3082F40661
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 09:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628848027;
        bh=kuDUT5t1e04YMCIk4a4teOdbNpRD8/S5RQDYcDNhlw0=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=EJyRv6WCNYqwVkkvpy4czA5Lp0b+ILfqYlMSjITmOzS+6dUIbxIP3s0TnTQK8z85E
         HG1nK1kuw3go5E21wQ1ZqlcjIiHYAkqwMcmkGcphIHRg4iV1qO5YIhE4V+11z4/Ktc
         yFdWoGix4q3wPQoWt6Ye72jYIYo1DaMp77tGq23ovDk3p50Q5qm3UJOrZpjWhUjhgo
         vjj26rWxMOShrrKn3+osHcN1op72jQ0Gw1vMVytZ8u+cw1Nr8VHkLF+zIQLXB/OSL6
         H8Vw4hI4sWB/Iu4rJisq3EmfDcj5bz3KRwNy4e0kug0XogXCFsPrpErE+o/Nk9jqki
         1P9waEqHrLtHA==
Received: by mail-ej1-f71.google.com with SMTP id ke4-20020a17090798e4b02905b869727055so2222351ejc.11
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 02:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kuDUT5t1e04YMCIk4a4teOdbNpRD8/S5RQDYcDNhlw0=;
        b=IuM6pqWtq1ltZeP8t3IZYPCnfveKPbJaPVTcszC7WDlfD4LvMuoc578Jw5zWpHs057
         UZYehCBhcjlAvTHGVScegKFb7uB0/efDd+g+rMH/hf8Bsut22hTAWZsIP5G0AMUX9e1x
         ymT5LJ0S9fjOByQJApm4HSWJs8jtrIPES/M6/43CUTqv6HSVH5o6Y2/QMl5MToloxolX
         BwrjkiiCO6RmwGVq6BTdkLu043kB4xe2tnDlO7xdc21FO68MSZrVmTBna4VMf/of7Qj8
         qa2sKtA1FO3ElwNMUPXVtvrZuQJXLbkRNrOF31AmNhjD/bGrJlN6CTTJaHPvznOPvpcm
         mkrg==
X-Gm-Message-State: AOAM532eLTgZD/jGF0Okh7E6Xwm1PIDijiPTG/+phOKAmIP5qV/zZFFt
        sLkBSAVjdL503H/VOPzfn9/jfq8aRHY+2gFqlkmBZHeRoFQey7u9qCZLi0wE5D8cyec5OsUY6k0
        uFnHo3qly3ugh+IeT/GCZFMNaHs2JK5yVmZctaMfuBN90QmjrLA==
X-Received: by 2002:a17:907:7609:: with SMTP id jx9mr1623641ejc.432.1628848026823;
        Fri, 13 Aug 2021 02:47:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoS9nfDcjQVnCHb4VR8ordSgOFPR3gCyp+ddvhSZqKiWoatM4yvS/rrgGtgWS2L8suVPS5dpiDTUC0xpX0iRU=
X-Received: by 2002:a17:907:7609:: with SMTP id jx9mr1623617ejc.432.1628848026482;
 Fri, 13 Aug 2021 02:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210812155341.817031-1-kai.heng.feng@canonical.com> <875e7304-20a1-0bca-ee07-41b16f07152a@gmail.com>
In-Reply-To: <875e7304-20a1-0bca-ee07-41b16f07152a@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 13 Aug 2021 17:46:54 +0800
Message-ID: <CAAd53p41RWp6weA2uXmZvKiVajehYkuC6cmHDeLxtJU_gsxCFA@mail.gmail.com>
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

j

On Fri, Aug 13, 2021 at 3:39 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
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
> > use dynamic ASPM under Windows. So implement the same mechanism here to
> > resolve the issue.
> >
> Realtek using something in their Windows drivers isn't really a proof of
> quality.

I agree. So it'll be great if Realtek can work with us here.

> Still my concerns haven't been addressed. If ASPM is enabled and
> there's a congestion in the chip it may take up to a second until ASPM
> gets disabled. In this second traffic very likely is heavily affected.
> Who takes care in case of problem reports?

I think we'll know that once the patch is merged in downstream kernel.

>
> This is a massive change for basically all chip versions. And experience
> shows that in case of problem reports Realtek never cares, even though
> they are listed as maintainers. All I see is that they copy more and more
> code from r8169 into their own drivers. This seems to indicate that they
> consider quality of their own drivers as not sufficient.

I wonder why they don't want to put their efforts to r8169...
Obviously they are doing a great job for rtw88 and r8152.

>
> Still my proposal: Apply this downstream, and if there are no complaints
> after a few months it may be considered for mainline.

Yes that's my plan. But I'd still like it to be reviewed before
putting it to the downstream kernel.

>
> Last but not least the formal issues:
> - no cover letter

Will write it up once it's tested dowstream.

> - no net/net-next annotation

Does it mean put "net/net-next" in the subject line?


>
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
>
> We are in soft irq context here, therefore you shouldn't sleep.

I thought napi_poll is not using softirq, apparent I was wrong. Will
correct it too.

>
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
>
> In the first version you used msecs_to_jiffies(ASPM_TIMER_INTERVAL).
> Now you use 1000 jiffies what is a major difference.

msecs_to_jiffies() was omitted. Will correct it.

Kai-Heng

>
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
