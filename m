Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911723DFA2D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 06:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhHDEFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 00:05:48 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43928
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229562AbhHDEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 00:05:46 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id E5A7D3F109
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 04:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628049925;
        bh=K8QqgejufW6QBHrbYxY5VgQSp4ONTbxOf5CTX7mBoLY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=q+hcqWJLEUQAY/kg+kfyyUD2amNalVJ26hp0lX60i7LXeUxNHOwjDkWeeOUz21nfm
         MLcGQSiRtmSbEnzcrSBwVCUeVVT6G9dW96va4t/MeJKtH9XhCGj6jpSEjL7gMZUohj
         WXTUSSpdCiN04v7CsL3dM8SsLKnpyoyx89HcYr7sqQn+K8B5MhLKrdfooykHY2QtY3
         9WGXdb2f8rrksUis2snyuWjcOYHRuFn0Tk6U73kpO7tF0UiWQPSxggc1ccoDRgy7zx
         koSMeZZVI/FUXYrzs9efeQFdBuzWUJNd/hWqVPFiIQ4Bjut+hZ6ODRsx+oJmXU3ZTk
         wGJpq3IIBzfGg==
Received: by mail-ed1-f71.google.com with SMTP id u25-20020aa7d8990000b02903bb6a903d90so769451edq.17
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 21:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K8QqgejufW6QBHrbYxY5VgQSp4ONTbxOf5CTX7mBoLY=;
        b=qNUYwjF9dIq/GmlU8rUMhsXR2L8pnThKAkYyT0kz52f3NuN8WENL3aRJFZLHsCXH2s
         sfcEiBgkZKQ1JacLuXi+5XhEA4GqC+4x5Pms6nQConZhHmJiDk8SWuE9xSyvx2V98wWx
         yTDMQGfrOs9df6pC5h8Axvyim5ei6tagYQooZanTxt4EWZQS5DnTE86bXJcnH/cCo8/L
         j1AzaPYz4Vn8RMxkn4CibBjYma2qHXVn77omkT5E3RPucYeWp9G0EVfTWjH15Ytg9KLr
         i1goUi89EhLQgxl/a0ZO9vrN2JnqPjFmszcK03kgfIAAULi4dVXcyiif1/ifXVQUAgWl
         ycIg==
X-Gm-Message-State: AOAM531X7tcCJYiSVk8QFlZOM/zvcqriKYBHcGzp4XY+9NTf8Gyqf8uy
        KfYZ4gQ9/W+FK4MKOgeiXwUTmsOiYwKbH4RmrTl5dFO71QqTfBu2idddJ07lKA6vcoTvVZ2GU67
        wcC4QIyvwvhtqOqxti5dnDX+jmFQ0CGo+Fjus8Ibt7cejuxIjZQ==
X-Received: by 2002:aa7:c50d:: with SMTP id o13mr29221419edq.153.1628049925364;
        Tue, 03 Aug 2021 21:05:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPpYJiPgLknSuDZM0Ba9u14AjqWyOXZKkeW43iLJtYDXVL8CggnubSMbP5TmbTHk9vFfIu5YymNDqZ51mvHrE=
X-Received: by 2002:aa7:c50d:: with SMTP id o13mr29221409edq.153.1628049925125;
 Tue, 03 Aug 2021 21:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210803152823.515849-1-kai.heng.feng@canonical.com> <f5f553ad-904d-dac5-dac5-3d7e266ab2fb@gmail.com>
In-Reply-To: <f5f553ad-904d-dac5-dac5-3d7e266ab2fb@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Wed, 4 Aug 2021 12:05:10 +0800
Message-ID: <CAAd53p52G6R-ydsy72faAZ5yphb8-vSeYcvz1kog46eGFh+hLQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] r8169: Implement dynamic ASPM mechanism
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

On Wed, Aug 4, 2021 at 3:57 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 03.08.2021 17:28, Kai-Heng Feng wrote:
> > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > Same issue can be observed with older vendor drivers.
> >
> > The issue is however solved by the latest vendor driver. There's a new
>
> Is there any errata document from Realtek recommending this workaround?
> Any prove that it solves the issues in all cases of ASPM issues we've
> seen so far?

Actually I don't know. Let me ask Realtek.

> Also your heuristics logic seems to be different from the one in r8168.
> The vendor driver considers also rx packets.

rx packets are accumulated in rtl_rx().

>
> In addition you use this logic also for chip versions not covered by
> r8168, like RTL8125. Any info from Realtek regarding these chip versions?

Right, maybe 8125 doesn't need dynamic ASPM. Let me ask them...

>
> > mechanism, which disables r8169's internal ASPM when the NIC has
> > substantial network traffic, and vice versa.
> >
> 10 packets per second I wouldn't call substantial traffic.

I'll change the wording in v2.

> I'm afraid we may open a can of worms and may be bothered
> with bug reports and complaints again.

Let's hope this time it works.

>
> > So implement the same mechanism here to resolve the issue.
> >
> For me this risk is too high to re-enable ASPM for a lot of chip
> versions w/o any official errata and workaround information.
> I propose you make this change downstream, and if there are no
> user complaints after some months I may consider to have something
> like that in the mainline driver.

Sure, let's see how it works in downstream kernel first.

>
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  drivers/net/ethernet/realtek/r8169_main.c | 36 +++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index c7af5bc3b8af..e257d3cd885e 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -624,6 +624,10 @@ struct rtl8169_private {
> >
> >       unsigned supports_gmii:1;
> >       unsigned aspm_manageable:1;
> > +     unsigned aspm_enabled:1;
> > +     struct timer_list aspm_timer;
> > +     u32 aspm_packet_count;
> > +
> >       dma_addr_t counters_phys_addr;
> >       struct rtl8169_counters *counters;
> >       struct rtl8169_tc_offsets tc_offset;
> > @@ -2671,6 +2675,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
> >       }
> >
> > +     tp->aspm_enabled = enable;
> > +
> >       udelay(10);
> >  }
> >
> > @@ -4408,6 +4414,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
> >
> >       dirty_tx = tp->dirty_tx;
> >
> > +     tp->aspm_packet_count += tp->cur_tx - dirty_tx;
> >       while (READ_ONCE(tp->cur_tx) != dirty_tx) {
> >               unsigned int entry = dirty_tx % NUM_TX_DESC;
> >               u32 status;
> > @@ -4552,6 +4559,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
> >               rtl8169_mark_to_asic(desc);
> >       }
> >
> > +     tp->aspm_packet_count += count;
> > +
> >       return count;
> >  }
> >
> > @@ -4659,8 +4668,31 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
> >       return 0;
> >  }
> >
> > +#define ASPM_PACKET_THRESHOLD 10
> > +#define ASPM_TIMER_INTERVAL 1000
> > +
> > +static void rtl8169_aspm_timer(struct timer_list *timer)
> > +{
> > +     struct rtl8169_private *tp = from_timer(tp, timer, aspm_timer);
> > +     bool enable;
> > +
> > +     enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
> > +
> > +     if (tp->aspm_enabled != enable) {
> > +             rtl_unlock_config_regs(tp);
> > +             rtl_hw_aspm_clkreq_enable(tp, enable);
> > +             rtl_lock_config_regs(tp);
>
> All this in interrupt context w/o locking?

Sorry, I forgot the timer is in interrupt context.
Or is it safe to use workqueue for rtl_{,un}lock_config_regs() and
rtl_hw_aspm_clkreq_enable()?

Kai-Heng

>
> > +     }
> > +
> > +     tp->aspm_packet_count = 0;
> > +
> > +     mod_timer(timer, jiffies + msecs_to_jiffies(ASPM_TIMER_INTERVAL));
> > +}
> > +
> >  static void rtl8169_down(struct rtl8169_private *tp)
> >  {
> > +     del_timer_sync(&tp->aspm_timer);
> > +
> >       /* Clear all task flags */
> >       bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
> >
> > @@ -4687,6 +4719,10 @@ static void rtl8169_up(struct rtl8169_private *tp)
> >       rtl_reset_work(tp);
> >
> >       phy_start(tp->phydev);
> > +
> > +     timer_setup(&tp->aspm_timer, rtl8169_aspm_timer, 0);
> > +     mod_timer(&tp->aspm_timer,
> > +               jiffies + msecs_to_jiffies(ASPM_TIMER_INTERVAL));
> >  }
> >
> >  static int rtl8169_close(struct net_device *dev)
> >
>
