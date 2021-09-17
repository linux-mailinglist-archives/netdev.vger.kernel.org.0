Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EE540F0EC
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 06:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244466AbhIQEMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 00:12:31 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:41060
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244307AbhIQEKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 00:10:43 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E92623F2FC
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 04:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631851760;
        bh=2kNbCKPeMI5ps1oSfYt0rhq/83SKx4ifSFqd7Ngd/x8=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=E9ZKtLBKkzbX5b4UnwrvP0It2m/UEsJWLxrjYDDN0zLniLN+bccJ4nQZTTUBvXqN6
         UBnEhRd5FLmtwwoE2xZGNFq63MOFMShRvDmICtMtjX7VG/87ebf0LyBxDsMhmxtQh1
         MV2jnSJzuzWWX8GmGA5aevDZX8dbRxABzeRAhq9wlUj+pwV5r99dlK6BJm6gNCAylG
         xk0ZgVJPySSfxOlJdz5D58FpPrxtgMVBMWrTjH36DTxZgNllpAaTNp6Lp63hghZGHP
         a61TuStLiPVl0dKENMzQSdLGIITsapqSlGG+OFaRCNMtQbYZH57nvWH5QaHoqh2zN4
         4Xyl3Cu5lEdjg==
Received: by mail-ot1-f72.google.com with SMTP id k18-20020a9d7dd2000000b0051aec75d1abso38529792otn.5
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 21:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2kNbCKPeMI5ps1oSfYt0rhq/83SKx4ifSFqd7Ngd/x8=;
        b=dmAmPzrROfyoVUlFfaRfZxIz82w8hDBhTS9Z+3IvMhZhUWYOFRLGQihEPcoq6mDpYT
         KuAFEgSXzGjr1x+0e8it9w+NvYnvIeBKPWpYW/YZZ0OJBt2bzS2uBc25kiv8Fzw8TPd8
         WIA9o5UQ8h9InM8CMo8cO+Ex7tKk076JbtAB4k5zCsdoGSN3cyU+lLdhGthiEscnGPaU
         iHEhTCX1BBavxJRgUzLWLKtXPYl1Cj655Tz6R2vmn8txEkPX4UpikGbWtie0WZDvyTgO
         6zvm5OcJVwGJe3m/zVn3JWvAPxdO9NszeEI2UB32Y4kqXEZP6XF8F9lQbehdfVaPwZU3
         5GFA==
X-Gm-Message-State: AOAM533GGWe2ZT+QQ5sbVcaAILFTnleDH1yzgU9J6TPggOU2Sy+dpFHK
        9LTrXR0INY8umNL/upHZrxSCKtnDCjgS1TNQNydpqf/Y+H1wh3HkMjpwlxyhpZhjlBhgKgIDskK
        G4vdI+GgXI8iWLZfDFpdYPJHocHFM6z1DimVkka+5LK6oQpSSRQ==
X-Received: by 2002:a05:6830:1355:: with SMTP id r21mr7577217otq.11.1631851759596;
        Thu, 16 Sep 2021 21:09:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMF308vBhb8hL4uK4kU9xdvxAyxq4JZckv5A+wbG2eFi1WlX0r+u8n875Mh+huTOVd1HQxckgRdKQLPj1/D5A=
X-Received: by 2002:a05:6830:1355:: with SMTP id r21mr7577204otq.11.1631851759263;
 Thu, 16 Sep 2021 21:09:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210916154417.664323-3-kai.heng.feng@canonical.com> <20210916170740.GA1624437@bjorn-Precision-5520>
In-Reply-To: <20210916170740.GA1624437@bjorn-Precision-5520>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 17 Sep 2021 12:09:08 +0800
Message-ID: <CAAd53p445rDeL1VFRYFA3QEbKZ6JtjzhCb9fxpR3eZ9E9NAETA@mail.gmail.com>
Subject: Re: [RFC] [PATCH net-next v5 2/3] r8169: Use PCIe ASPM status for NIC
 ASPM enablement
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

On Fri, Sep 17, 2021 at 1:07 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Thu, Sep 16, 2021 at 11:44:16PM +0800, Kai-Heng Feng wrote:
> > Because ASPM control may not be granted by BIOS while ASPM is enabled,
> > and ASPM can be enabled via sysfs, so use pcie_aspm_enabled() directly
> > to check current ASPM enable status.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v5:
> >  - New patch.
> >
> >  drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index 0199914440abc..6f1a9bec40c05 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -622,7 +622,6 @@ struct rtl8169_private {
> >       } wk;
> >
> >       unsigned supports_gmii:1;
> > -     unsigned aspm_manageable:1;
> >       dma_addr_t counters_phys_addr;
> >       struct rtl8169_counters *counters;
> >       struct rtl8169_tc_offsets tc_offset;
> > @@ -2664,8 +2663,13 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
> >
> >  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> >  {
> > -     /* Don't enable ASPM in the chip if OS can't control ASPM */
> > -     if (enable && tp->aspm_manageable) {
> > +     struct pci_dev *pdev = tp->pci_dev;
> > +
> > +     /* Don't enable ASPM in the chip if PCIe ASPM isn't enabled */
> > +     if (!pcie_aspm_enabled(pdev) && enable)
> > +             return;
>
> What happens when the user enables or disables ASPM via sysfs (see
> https://git.kernel.org/linus/72ea91afbfb0)?
>
> The driver is not going to know about that change.

So it's still better to fold this patch into next one? So the periodic
delayed_work can toggle ASPM accordingly.

Kai-Heng

>
> > +     if (enable) {
> >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
> >               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
> >       } else {
> > @@ -5272,8 +5276,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >       /* Disable ASPM L1 as that cause random device stop working
> >        * problems as well as full system hangs for some PCIe devices users.
> >        */
> > -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > -     tp->aspm_manageable = !rc;
> > +     pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> >
> >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> >       rc = pcim_enable_device(pdev);
> > --
> > 2.32.0
> >
