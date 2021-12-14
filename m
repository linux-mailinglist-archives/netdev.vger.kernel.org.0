Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF45B473CF6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 07:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhLNGHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 01:07:02 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:59906
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230325AbhLNGHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 01:07:02 -0500
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DBA624005B
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 06:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639462020;
        bh=atZu+sVRTQVv1ZgYIjaMF+4PZzut5XqBDnscKf83G9Y=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=dpBPhlsqH3xG/SRTJtpYM4KHpTZTxWh9Dd1B7rhCqcagIBCET7Xvv46b9BVw+nxB4
         f/SHbXYN1CxfbLtyaZZT4MuThYUAUB+W+YKu+HPTZM55scQK22Oo5ieQc0+Oh3pWVg
         zYV0veOcj6lN9JqJAZuTk+b8cz0t3TuYiIcqcPqrcPHoTZymHSWyuHGDNGLmqR6mzm
         XowGema20HWYW1nxXfBjeGwqfrHOleIKEAHW4kbJj17luE7XqMu3lBWRK3wbV6dRzI
         RnsHGtnXrSEcH40uMTgNfR/VLI4pHpc43y0LX2asJpPDydMRYTRCkmE3LlQZno/A10
         XRkFzR1uFz9fQ==
Received: by mail-oo1-f69.google.com with SMTP id y123-20020a4a4581000000b002c282d3ab49so12219434ooa.14
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 22:07:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atZu+sVRTQVv1ZgYIjaMF+4PZzut5XqBDnscKf83G9Y=;
        b=tZEVx7xZECSo52kpQ0+gigiBPF4IHuK3k85LaF+by5qUfH7VTZ49hDTvuHmlG5DGsH
         NDQZn8grWFpOUsP71PWy8uvfeLOgJjB3eghdRAYC9GHN1Hs75rEN8vJz6WmhZzlAaTQ+
         3Qo9oHApP6AKP4bZnrfD0NeCcSeaHPOttSKXm1paXc/91o7nZPhCc+R31pqO4L2FceT0
         6sQ0WlhFFmgX3NJssceLDJDiAyubjtAFq1Skhpfa1DpAQhH+c1x8kapkdsFUe0NrmDsQ
         iT7kARcqi6iLjMNfGRWojrUoa3BfGhMRGAm79jNh1+6IGyKUrM/bPXgH6D4eQyKtl3EN
         Ayyw==
X-Gm-Message-State: AOAM532kSpBWpApPIgfdKCOBgXztVv2rUwmiEXncKTHzsCXG7Digj9GO
        5a16nPzyRZeRJvOG5vTBxK0ZLbXR8VkgfW0l/KXLtbnxJfPMCFPDyP9Ai/5x9Rv23WX4HepvCxP
        I6VSQs9MtsSlkt1gmiGPV2pMc96Y1hZBwpgVGeOSOmb0xCHo8+w==
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr32526451oib.98.1639462019853;
        Mon, 13 Dec 2021 22:06:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsAc54cDrgKi0kQyNgUnH00P5/F+C7RE8loyA+HLGHegRIVZXctcN4iFxDQ6tC3Y7RZ9TcuvP9dr/mbgjL40Y=
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr32526433oib.98.1639462019636;
 Mon, 13 Dec 2021 22:06:59 -0800 (PST)
MIME-Version: 1.0
References: <20211214053302.242222-1-kai.heng.feng@canonical.com> <4aaf5dd030004285a56bc55cc6b2731b@realtek.com>
In-Reply-To: <4aaf5dd030004285a56bc55cc6b2731b@realtek.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 14 Dec 2021 14:06:48 +0800
Message-ID: <CAAd53p6TWV=vciEPkM-_rPy4op1Nqpqye-UhHXnsUJ4MjoVk=w@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
To:     Pkshih <pkshih@realtek.com>
Cc:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "jian-hong@endlessm.com" <jhp@endlessos.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 1:59 PM Pkshih <pkshih@realtek.com> wrote:
>
>
> > -----Original Message-----
> > From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Sent: Tuesday, December 14, 2021 1:33 PM
> > To: tony0620emma@gmail.com; Pkshih <pkshih@realtek.com>
> > Cc: jian-hong@endlessm.com; Kai-Heng Feng <kai.heng.feng@canonical.com>; Kalle Valo
> > <kvalo@codeaurora.org>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Bernie
> > Huang <phhuang@realtek.com>; Brian Norris <briannorris@chromium.org>; linux-wireless@vger.kernel.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
> >
> > Many Intel based platforms face system random freeze after commit
> > 9e2fd29864c5 ("rtw88: add napi support").
> >
> > The commit itself shouldn't be the culprit. My guess is that the 8821CE
> > only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
> > masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
> > extremely slow. Eventually the RX ring becomes messed up:
> > [ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status
> >
> > Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
> > the driver to resolve the issue.
> >
> > Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
> > BugLink: https://bugs.launchpad.net/bugs/1927808
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v2:
> >  - Add default value for module parameter.
> >
> >  drivers/net/wireless/realtek/rtw88/pci.c | 74 ++++++++----------------
> >  drivers/net/wireless/realtek/rtw88/pci.h |  1 +
> >  2 files changed, 24 insertions(+), 51 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> > index 3b367c9085eba..4ab75ac2500e9 100644
> > --- a/drivers/net/wireless/realtek/rtw88/pci.c
> > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > @@ -2,7 +2,6 @@
> >  /* Copyright(c) 2018-2019  Realtek Corporation
> >   */
> >
> > -#include <linux/dmi.h>
> >  #include <linux/module.h>
> >  #include <linux/pci.h>
> >  #include "main.h"
> > @@ -16,10 +15,13 @@
> >
> >  static bool rtw_disable_msi;
> >  static bool rtw_pci_disable_aspm;
> > +static int rtw_rx_aspm = -1;
> >  module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
> >  module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
> > +module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
> >  MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
> >  MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
> > +MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)");
> >
> >  static u32 rtw_pci_tx_queue_idx_addr[] = {
> >       [RTW_TX_QUEUE_BK]       = RTK_PCI_TXBD_IDX_BKQ,
> > @@ -1409,7 +1411,11 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
> >        * throughput. This is probably because the ASPM behavior slightly
> >        * varies from different SOC.
> >        */
> > -     if (rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1)
> > +     if (!(rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1))
> > +             return;
> > +
> > +     if ((enter && atomic_dec_return(&rtwpci->link_usage) == 0) ||
> > +         (!enter && atomic_inc_return(&rtwpci->link_usage) == 1))
> >               rtw_pci_aspm_set(rtwdev, enter);
> >  }
> >
>
> I found calling pci_link_ps isn't always symmetric, so we need to reset
> ref_cnt at pci_start() like below, or we can't enter rtw_pci_aspm_set()
> anymore. The negative flow I face is
> ifup -> connect AP -> ifdown -> ifup (ref_cnt isn't expected now).

Is it expected to be asymmetric?
If it's intended to be this way, I'll change where we set link_usage.
Otherwise I think making it symmetric makes more sense.

Kai-Heng

>
>
> @@ -582,6 +582,8 @@ static int rtw_pci_start(struct rtw_dev *rtwdev)
>         rtw_pci_napi_start(rtwdev);
>
>         spin_lock_bh(&rtwpci->irq_lock);
> +       atomic_set(&rtwpci->link_usage, 1);
>         rtwpci->running = true;
>         rtw_pci_enable_interrupt(rtwdev, rtwpci, false);
>         spin_unlock_bh(&rtwpci->irq_lock);
>
> --
> Ping-Ke
>
>
