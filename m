Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3F43E448B
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhHILTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:19:07 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:42818
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235026AbhHILTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 07:19:06 -0400
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 10FA63F351
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 11:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628507925;
        bh=CLVtGv+u1VQk6WuBK3njmzUEUjHOf3FsmIGUOKSLR2c=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=US5WFfJSVnxWHIeADWP/59l29kuI9s/2WnCVpa0QBjuv5iGZqQ9by7UU0OJ4woj3e
         AT8+ZxInQo9N92+4ul79UzgIWSWd8OrxCoG6Urnozew5TXqoXdKE2iwV8nqsu3Q7xW
         lslgZWsuHM2AYLXsDq278iyE93EIQghWSN5XfTD/8cXbuD9DYfMIOWVGI1RWCxZlyV
         fWL8MtDz5lLfYA+kxa0iLoHDthep6LTIRM1moZy0ammy79/deoiPpQGMMv17USMyvQ
         YzA7MokWKzVGowm5XsQOGwd2b/nxZejdYmMwBti6AytXGn9p1/1GhW5PyH3Ng9w+oG
         OkCFOBMLDPxLw==
Received: by mail-ej1-f72.google.com with SMTP id kf21-20020a17090776d5b02905af6ad96f02so664520ejc.12
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 04:18:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLVtGv+u1VQk6WuBK3njmzUEUjHOf3FsmIGUOKSLR2c=;
        b=FjHkcVxwnPGnkLCpu1QSBd+Tjlv0+IKM27aevGKQTpiI24CR1ldzwRif5T471+4JtO
         WSd39gYgVlnyg2wydwucRCzatgFNSwp6wCCqEAGjhf0sDV3oDI8TaxDdl0ClGLOKnW5n
         N20NMWcM2NK6GHKUYybLgWtRD/B8t5D64Qt6H6FVNlnQulCxMeRZ69g4mdX17JNN7ON+
         EzZXJ2w7RirzzYyqSU+hVKXWEbhxY+yHUOZG63XDxw376vcNbWdCBiOY6MVpxJVieoYw
         KU3U3OIDCM0Y6b/PLpQG/0hxXUeZpdcb9oXjYdUgbsdOVtWEXdnJOyXDDWOn5hOpltVC
         L6cw==
X-Gm-Message-State: AOAM532Qm6FzawXdd17sAMl6pII4HuqdxPVF1/GId7ImfvP2w6uEzVmB
        ujsg/Z4oQT8U+niBOEzESr5cTdGsfVJmPZUX5/FS9eRJsSo0xobN+pUX/M4CKB0ASM5/zHsAAit
        31Bfp/1ziA5Yq4w9si5cQeC3x0owkyywO90AW8atLw3liPs5n2Q==
X-Received: by 2002:a17:907:3345:: with SMTP id yr5mr21818518ejb.542.1628507924656;
        Mon, 09 Aug 2021 04:18:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycuL4QVPtW9Ha3wNg63K1CxnOthluT58wCPPOTjs6+P7J22mf4vw1/w5gMnLWCnqZuK7LX3MJ2w5v9vau/myQ=
X-Received: by 2002:a17:907:3345:: with SMTP id yr5mr21818498ejb.542.1628507924382;
 Mon, 09 Aug 2021 04:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210803152823.515849-1-kai.heng.feng@canonical.com> <6a5f26e7-48a2-49c8-035e-19e9497c12a7@gmail.com>
In-Reply-To: <6a5f26e7-48a2-49c8-035e-19e9497c12a7@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 9 Aug 2021 19:18:33 +0800
Message-ID: <CAAd53p6Z-J989BCDdgW-hYHqthqUHAUaG66-3iQ9=Popb3d3sw@mail.gmail.com>
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

On Sat, Aug 7, 2021 at 2:47 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 03.08.2021 17:28, Kai-Heng Feng wrote:
> > r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > Same issue can be observed with older vendor drivers.
> >
> > The issue is however solved by the latest vendor driver. There's a new
> > mechanism, which disables r8169's internal ASPM when the NIC has
> > substantial network traffic, and vice versa.
> >
> > So implement the same mechanism here to resolve the issue.
> >
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
> I have one more question / concern regarding this workaround:
> If bigger traffic starts and results in a congestion (let's call it like that
> because we don't know in detail what happens in the chip), then it may take
> up to a second until ASPM gets disabled and traffic gets back to normal.
> This second is good enough to prevent that the timeout watchdog fires.
> However in this second supposedly traffic is very limited, if possible at all.
> Means if we have a network traffic pattern with alternating quiet and busy
> periods then we may see a significant impact on performance.
> Is this something that you tested?

No, we didn't test this scenario.
Realtek told us that dynamic ASPM is also used by Windows driver, but
I don't know the interval used by Windows driver.
For now I think it's better to stick with vendor defined value.

Kai-Heng
