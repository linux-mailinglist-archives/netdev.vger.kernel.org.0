Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85F33EB3D7
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbhHMKLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 06:11:48 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:37418
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239646AbhHMKLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 06:11:47 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 0494940C8F
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 10:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628849480;
        bh=XktaWb5OarhZZWhK207tWNHGLgGwQeK53+2iSkcLfrA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=UcfiywftvRZOVms8PQZBljq5ZuLPOrz4HrULE7FGxRjMoiJ6ozeb0qINpnw33onAU
         qb1ftQah6EPJo+aPUMHYVGkPjgk6yN8ZAslRcVzLzIdxxjprHyBNgjkgOc4+8JnKDz
         N32qHkfY1/eicQxv/erdLntoMmFtxcP3qNyLlAOjpaOYt/WcjfMXOdzrxEY7V7xr5V
         45ImwLCMGGhuQuaolJCGsqu0wfSG42Pu0NXQv8WGy9nRAAj6oRbHGWnywu9QpruASD
         viRj1IEGoIlsEggTVOJGpQp3qoZlgRr/y0l69Cm0wjAv5Qcg6630qQWXpAk+Sx8h/j
         AsFnMIX4YWl2A==
Received: by mail-ed1-f72.google.com with SMTP id di3-20020a056402318300b003bebf0828a2so540204edb.8
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 03:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XktaWb5OarhZZWhK207tWNHGLgGwQeK53+2iSkcLfrA=;
        b=gRq9PKh0dMTkayGgDzrPDQz/t89vQNpPV2jJTZNyoeC74k6miZIYF2UJgno4HNnpiv
         Pt6ZkPq1nq6vwvy+hb2kBr7F7LZwnAyc35S4aKxUXQ0tIQs+CwTQbKUsw/LTUOzyfXcs
         W5Udzj/Vlx9KLn2G3P2KWK58ae4bNW/TIF8N09B4IvkhOreLIY7HC3bJ8Y9aZ9dmHAB0
         HPlK2Mf3F1Gh8EQr5A7Ly083FpF3dCQ1ax/+3EBX4pd11/p9wM7iHkt1kjsnA1Q/1LQY
         1wQi4GpHBktWPrLTet1YFOM1QzrcPWY+e14xuZpuFmJmlOxY2+avkKeb6WpeguqFSDwG
         dK8g==
X-Gm-Message-State: AOAM533ESS0tpsGvQsj5EWt9K6aZLtfrJlMOoVvEGCD5i+9qhd+6ntL5
        6nWLXURqwSCy3bUsIeZPgIsxbcoZuuf9FrZcnDFpHF8eTp+U3Eip4GXY0dbiPue0yCr57M+u4VC
        PSJGappEwpU2n3Tplqt+UvR7xyQ6sAPkojhtyNQtKBcxY2ntsWw==
X-Received: by 2002:a17:907:3345:: with SMTP id yr5mr1657229ejb.542.1628849479558;
        Fri, 13 Aug 2021 03:11:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx54a+seJ6N2++kphZ8J3++CuGLKdwh8/E5ah2nd49CpMNozv5E8xFHxj6PzaHtWLKKdcjORItwf19KoGuY2gg=
X-Received: by 2002:a17:907:3345:: with SMTP id yr5mr1657216ejb.542.1628849479230;
 Fri, 13 Aug 2021 03:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
 <20210812155341.817031-2-kai.heng.feng@canonical.com> <3633f984-8dd6-f81b-85f9-6083420b4516@gmail.com>
In-Reply-To: <3633f984-8dd6-f81b-85f9-6083420b4516@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 13 Aug 2021 18:11:06 +0800
Message-ID: <CAAd53p6KGTVWp5PgZux5t2mdTXK29XdyB5Ke5YbR_-UacR03Sg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] r8169: Enable ASPM for selected NICs
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

On Fri, Aug 13, 2021 at 3:39 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 12.08.2021 17:53, Kai-Heng Feng wrote:
> > The latest vendor driver enables ASPM for more recent r8168 NICs, do the
> > same here to match the behavior.
> >
> > In addition, pci_disable_link_state() is only used for RTL8168D/8111D in
> > vendor driver, also match that.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v2:
> >  - No change
> >
> >  drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++++++++++++------
> >  1 file changed, 26 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 7ab2e841dc69..caa29e72a21a 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -623,7 +623,7 @@ struct rtl8169_private {
> >       } wk;
> >
> >       unsigned supports_gmii:1;
> > -     unsigned aspm_manageable:1;
> > +     unsigned aspm_supported:1;
> >       unsigned aspm_enabled:1;
> >       struct delayed_work aspm_toggle;
> >       struct mutex aspm_mutex;
> > @@ -2667,8 +2667,11 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
> >
> >  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >  {
> > +     if (!tp->aspm_supported)
> > +             return;
> > +
> >       /* Don't enable ASPM in the chip if OS can't control ASPM */
> > -     if (enable && tp->aspm_manageable) {
> > +     if (enable) {
> >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
> >               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
> >       } else {
> > @@ -5284,6 +5287,21 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
> >       rtl_rar_set(tp, mac_addr);
> >  }
> >
> > +static int rtl_hw_aspm_supported(struct rtl8169_private *tp)
> > +{
> > +     switch (tp->mac_version) {
> > +     case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_36:
> > +     case RTL_GIGA_MAC_VER_38:
> > +     case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_42:
> > +     case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_46:
> > +     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_63:
>
> This shouldn't be needed because ASPM support is announced the
> standard PCI way. Max a blacklist should be needed if there are
> chip versions that announce ASPM support whilst in reality they
> do not support it (or support is completely broken).

So can we also remove aspm_manageable since blacklist will be used?

Kai-Heng

>
> > +             return 1;
> > +
> > +     default:
> > +             return 0;
> > +     }
> > +}
> > +
> >  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  {
> >       struct rtl8169_private *tp;
> > @@ -5315,12 +5333,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       if (rc)
> >               return rc;
> >
> > -     /* Disable ASPM completely as that cause random device stop working
> > -      * problems as well as full system hangs for some PCIe devices users.
> > -      */
> > -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> > -                                       PCIE_LINK_STATE_L1);
> > -     tp->aspm_manageable = !rc;
> > +     if (tp->mac_version == RTL_GIGA_MAC_VER_25)
> > +             pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> > +                                    PCIE_LINK_STATE_L1 |
> > +                                    PCIE_LINK_STATE_CLKPM);
> > +
> > +     tp->aspm_supported = rtl_hw_aspm_supported(tp);
> >
> >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> >       rc = pcim_enable_device(pdev);
> >
>
