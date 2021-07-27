Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3016A3D6FBA
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhG0Gxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:53:40 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34526
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235205AbhG0Gxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:53:38 -0400
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 2508B3F376
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 06:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627368818;
        bh=qN8OJFf6Po6PVFEhUmeuvpneJoBvci7+fruSnaLegCQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Bvo8ExcB6ryYZEnySjB2VjmyHWF41rFKKMOHI/0PvTZad3ICkG3RlnhrdJsnsAY4K
         EAR7X7tjG7N5aslV/MfBqC/2iAsCgXtuDOSc9yhNV+fqFTnyEfyOTp7vYHz8YObcjt
         8RUgWN3+jJrysUEQdnmtdFslHBnZq9roLPsX5R2cJvHW4+aBVXlFxfssU/9qHVUzZ+
         ktcnpUyMbZrLB6IyUs85RTv1qUg1l6EyFkKX3EUGMP60k2Qggpy/s0N4NaIAQIBolL
         cEKNyJRVmxYI/p8czj93+TqyiI5C3n5qffRTFLuoJ/xYrKfwGwwbxsNawjvE0mfq91
         t8QkE2zp5gzvg==
Received: by mail-ej1-f70.google.com with SMTP id qf6-20020a1709077f06b029057e66b6665aso1792708ejc.18
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 23:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qN8OJFf6Po6PVFEhUmeuvpneJoBvci7+fruSnaLegCQ=;
        b=ZjoFTCJTHQlEnUPfJuhhB69yp85fiQ7pvxgqM4+xr9rXpKs/Orx+q5WIPujKBFg3s2
         3DRairsh5PmB5vfL1Eggy/CKWZBAQINWDveyzpIvJ9UOxPIc/aDoKDZ4cgzhjj2kBXOH
         g1JzWpOPJJwn7LE2O/f27VKv7W0Qp2yjWbe8RUuexrwbtBe07XTP2555t7GSU2FRat3n
         rWanNbSyDKwKhKdsxqHoYurmxFHZMYgs5hQs8xf/q5t4nJfKj2dq1wUcQdre5klCCtD0
         cAH0QGoFsg/Lu5bSptPXJT8wXSpqgspDxUyLiZePcCAaUx/fl5JZSImo99wlQhxyhnhO
         IMyw==
X-Gm-Message-State: AOAM532GR9+23+Ia4bQPrzAMZD+ZQHbty/bRfabpkuCj2u87j3SyI21Q
        +nirDUnBxQTkPSlWZT6LdI3Qj6KK9IKm8QXFBWJYYOPZA4z9Joq9T3xGO3TR2fcC8hF+UFgeVve
        kjTCHutDK/7XLxEFaBb7wfO4d5J9QQiph1ut+wXS6XTZtBRgeVA==
X-Received: by 2002:a05:6402:1846:: with SMTP id v6mr8052318edy.198.1627368816956;
        Mon, 26 Jul 2021 23:53:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYdD2hDnkETruFxQmylsUBZw88ismuEmU2WP6U9HAo2K2rEXtDKURDvsFgfMewoRu4uhjd2VcTqS0lweEkMF8=
X-Received: by 2002:a05:6402:1846:: with SMTP id v6mr8052290edy.198.1627368816680;
 Mon, 26 Jul 2021 23:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210712133500.1126371-1-kai.heng.feng@canonical.com> <20210712133500.1126371-3-kai.heng.feng@canonical.com>
In-Reply-To: <20210712133500.1126371-3-kai.heng.feng@canonical.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 27 Jul 2021 14:53:23 +0800
Message-ID: <CAAd53p5B5f5U_J1L+SpjZ46AFEr1kMqwgqnF2dYKvDwY2x3GzA@mail.gmail.com>
Subject: Re: [PATCH 3/3] e1000e: Serialize TGP e1000e PM ops
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Mon, Jul 12, 2021 at 9:35 PM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> On TGL systems, PCI_COMMAND may randomly flip to 0 on system resume.
> This is devastating to drivers that use pci_set_master(), like NVMe and
> xHCI, to enable DMA in their resume routine, as pci_set_master() can
> inadvertently disable PCI_COMMAND_IO and PCI_COMMAND_MEMORY, making
> resources inaccessible.
>
> The issue is reproducible on all kernel releases, but the situation is
> exacerbated by commit 6cecf02e77ab ("Revert "e1000e: disable s0ix entry
> and exit flows for ME systems"").
>
> Seems like ME can do many things to other PCI devices until it's finally out of
> ULP polling. So ensure e1000e PM ops are serialized by enforcing suspend/resume
> order to workaround the issue.
>
> Of course this will make system suspend and resume a bit slower, but we
> probably need to settle on this workaround until ME is fully supported.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=212039
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Series "e1000e: Add handshake with the CSME to support s0ix" doesn't
fix the issue, so this patch is still needed.

Kai-Heng

> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index e63445a8ce12..0244d3dd90a3 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7319,7 +7319,8 @@ static const struct net_device_ops e1000e_netdev_ops = {
>
>  static void e1000e_create_device_links(struct pci_dev *pdev)
>  {
> -       struct pci_dev *tgp_mei_me;
> +       struct pci_bus *bus = pdev->bus;
> +       struct pci_dev *tgp_mei_me, *p;
>
>         /* Find TGP mei_me devices and make e1000e power depend on mei_me */
>         tgp_mei_me = pci_get_device(PCI_VENDOR_ID_INTEL, 0xa0e0, NULL);
> @@ -7335,6 +7336,17 @@ static void e1000e_create_device_links(struct pci_dev *pdev)
>                 pci_info(pdev, "System and runtime PM depends on %s\n",
>                          pci_name(tgp_mei_me));
>
> +       /* Find other devices in the SoC and make them depend on e1000e */
> +       list_for_each_entry(p, &bus->devices, bus_list) {
> +               if (&p->dev == &pdev->dev || &p->dev == &tgp_mei_me->dev)
> +                       continue;
> +
> +               if (device_link_add(&p->dev, &pdev->dev,
> +                                   DL_FLAG_AUTOREMOVE_SUPPLIER))
> +                       pci_info(p, "System PM depends on %s\n",
> +                                pci_name(pdev));
> +       }
> +
>         pci_dev_put(tgp_mei_me);
>  }
>
> --
> 2.31.1
>
