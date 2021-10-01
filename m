Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842D541E6CB
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 06:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351729AbhJAEeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 00:34:21 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:39486
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237015AbhJAEeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 00:34:15 -0400
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 412F9402F7
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633062751;
        bh=4jmZaqJlLt2B/tNcWSu5EKE9uB+UjAWfslLYeEYvZb8=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=feGTsfO/+urBeGM0WgfAFa5a35B8vZ8cgK/Io2yB9AptxyHFKpHk4P6ZIO0RfKfU8
         1ImoE307Wb96VJ5NuMp40AE6J0Lni68sqGHX95S97srLs+6cik9UbnxboxD8aoYfa5
         Z5DxAPDtfqeyCtFJ3QfgmXJlH6YdfwMMYRja/xYmNeszPzkcmxgloNUh2ueLqltJM+
         wpgUqiDiCW/0jiBugAhxYhDNaUVH/QVZZnz+q/lpJbKjgDN3Bwlz193Kz8/sQnT8Dh
         J2APDsK9K5+RsKvuCk9TkNDZXlpGrC68lr5ZxofQUEt4L+3+EH+OCB//wNgwD3BBnV
         j0u7VFFS3R29A==
Received: by mail-ot1-f70.google.com with SMTP id x25-20020a9d6d99000000b0051bf9bfc12fso5872338otp.8
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 21:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jmZaqJlLt2B/tNcWSu5EKE9uB+UjAWfslLYeEYvZb8=;
        b=LN7Vs7IkGDEc17o79wNzAnlyN7AvgyrJadpDH9WkiJE01ar/406dFIHjpoeBPerns4
         Y62D76yRZ9ahuwC3zV/uAEg9ktZY/4kFitmXwTZMuFFAsKjHMYPpuyd76rSwduj2GBlB
         kNUQp+9EHqXO5GjTpwgVOzGqnHwVj6QiMGAJH7RgGiFh7FQlcd30qAeE7xvrII9zceCB
         uBrru/qhbRGbbVyx4izxwqXGYnk+l3NTkIQoPM6gRQ1YBXQsmPT5Vp8MfNsRQP3K1PXj
         cP7VGDNYNz/Vb7+/3sVlviMTeC0bvsvcsXYsoKEkLAK6LbZxZnAERRtxZn6blbSE3Fir
         Ghbg==
X-Gm-Message-State: AOAM533p9HuCZuEmRIzPAOVaJylrhov/tqZo6hwIFFrcyrH7jbjxkQgN
        OU6vhuemZsF2OUzfJqvaAmLcp6ktaJI9mRS/1suJ1kd+eFd0F/aqjqa9URI3mzoPP/BRXyWsZ09
        APriwauL75vzyxBvE+C6pdGB3aN9JTViXdWONoMAs6Xha7PUOGw==
X-Received: by 2002:aca:2116:: with SMTP id 22mr2455501oiz.146.1633062749873;
        Thu, 30 Sep 2021 21:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxT/PH0aH2nQY4vnU0iSiMt/e4/dQ/8HGUQHm8xcWhyCnmLkRXj8TGr5aZZHFDVPA14JcN3SDlNDyRwYQ9E0mA=
X-Received: by 2002:aca:2116:: with SMTP id 22mr2455483oiz.146.1633062749646;
 Thu, 30 Sep 2021 21:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAAd53p445rDeL1VFRYFA3QEbKZ6JtjzhCb9fxpR3eZ9E9NAETA@mail.gmail.com>
 <20210917152612.GA1717817@bjorn-Precision-5520>
In-Reply-To: <20210917152612.GA1717817@bjorn-Precision-5520>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 1 Oct 2021 12:32:18 +0800
Message-ID: <CAAd53p60Vjme9=zmVCF3WOt9iiqkZ6gprABDh1VSQyyKZbGkdw@mail.gmail.com>
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

On Fri, Sep 17, 2021 at 11:26 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Fri, Sep 17, 2021 at 12:09:08PM +0800, Kai-Heng Feng wrote:
> > On Fri, Sep 17, 2021 at 1:07 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Thu, Sep 16, 2021 at 11:44:16PM +0800, Kai-Heng Feng wrote:
> > > > Because ASPM control may not be granted by BIOS while ASPM is enabled,
> > > > and ASPM can be enabled via sysfs, so use pcie_aspm_enabled() directly
> > > > to check current ASPM enable status.
> > > >
> > > > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > > ---
> > > > v5:
> > > >  - New patch.
> > > >
> > > >  drivers/net/ethernet/realtek/r8169_main.c | 13 ++++++++-----
> > > >  1 file changed, 8 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > > > index 0199914440abc..6f1a9bec40c05 100644
> > > > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > > > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > > > @@ -622,7 +622,6 @@ struct rtl8169_private {
> > > >       } wk;
> > > >
> > > >       unsigned supports_gmii:1;
> > > > -     unsigned aspm_manageable:1;
> > > >       dma_addr_t counters_phys_addr;
> > > >       struct rtl8169_counters *counters;
> > > >       struct rtl8169_tc_offsets tc_offset;
> > > > @@ -2664,8 +2663,13 @@ static void rtl_enable_exit_l1(struct rtl8169_private *tp)
> > > >
> > > >  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
> > > >  {
> > > > -     /* Don't enable ASPM in the chip if OS can't control ASPM */
> > > > -     if (enable && tp->aspm_manageable) {
> > > > +     struct pci_dev *pdev = tp->pci_dev;
> > > > +
> > > > +     /* Don't enable ASPM in the chip if PCIe ASPM isn't enabled */
> > > > +     if (!pcie_aspm_enabled(pdev) && enable)
> > > > +             return;
> > >
> > > What happens when the user enables or disables ASPM via sysfs (see
> > > https://git.kernel.org/linus/72ea91afbfb0)?
> > >
> > > The driver is not going to know about that change.
> >
> > So it's still better to fold this patch into next one? So the periodic
> > delayed_work can toggle ASPM accordingly.
>
> No, my point is that the user can enable/disable ASPM via sysfs, and
> the driver will not know anything about it.  There's no callback that
> tells the driver when this happens.
>
> My question is whether this code works when that happens.  I doubt it
> works, because if ASPM is not enabled at this moment, you return
> without doing enabling ASPM in the chip below.
>
> If the user subsequently enables ASPM via sysfs, the chip setup below
> will not be done.
>
> If there's chip-specific setup to make ASPM work, I think the
> chip-specific part needs to be done unconditionally.

So it's either adding a callback to notify driver about ASPM change,
or doing chip-specific ASPM unconditionally.
Which one do you prefer?

Kai-Heng

>
> > > > +     if (enable) {
> > > >               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
> > > >               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
> > > >       } else {
> > > > @@ -5272,8 +5276,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> > > >       /* Disable ASPM L1 as that cause random device stop working
> > > >        * problems as well as full system hangs for some PCIe devices users.
> > > >        */
> > > > -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > > > -     tp->aspm_manageable = !rc;
> > > > +     pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> > > >
> > > >       /* enable device (incl. PCI PM wakeup and hotplug setup) */
> > > >       rc = pcim_enable_device(pdev);
> > > > --
> > > > 2.32.0
> > > >
