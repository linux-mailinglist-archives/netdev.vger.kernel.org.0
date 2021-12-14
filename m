Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C59473B70
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhLNDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:20:12 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:54904
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhLNDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:20:11 -0500
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E3C523F4B3
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639452009;
        bh=8FZdDPbJvuDCvUbuvpPls49z7FqYcIY0iWn2oyHLKu4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=F4uRspWaOI4kf1LdhYmggG31Ycw88E3h4TuVb35U+kqHkxL/UYolu9C47aXVMzNpk
         g3IkPGvy0Ynig0JDlKUxDa9g41f80o180pDPua92oclwFHMIKFAYsExWAnBZ/Lv3Xg
         M9GzQpXkEYmyEqRHrdq6wMxHZRNfrnHFC8aoyLrSnp3mS3rre3egcGhgPYIo1K9tVA
         kKrTrkMf2hL+7HqIzP/ov7ia1g8sJO8ZLX2RbHnoD0bwBQ4vSre2/bIkTAllV193M1
         RkuzZoOXcA2q6+PFCUiXlbBL5SA9uvpW7rvmc2/05KKqkXMvkZSqjUdgidJFmFVjKE
         p62IpdDiQE/eg==
Received: by mail-oo1-f72.google.com with SMTP id i11-20020a4adf0b000000b002c6a9df15a0so12039171oou.2
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:20:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8FZdDPbJvuDCvUbuvpPls49z7FqYcIY0iWn2oyHLKu4=;
        b=oRpDIWWuxaVSFmiKoSsZbjakRD3o9hLZwynkMvXK4glaTROnmSOPhXvVM0lm0aEcCo
         NAgsPosFVYD/zBBu3uz7AAfWYHXjDrfGgULuRLjBDcFf+q243y5IftYVvxjA1zK+0s3k
         UE1oLbNYq270agDOPhIibNhqzrdnB5wsWjP3EmW7FRsN+ckB0+td8Te8Gh1HolaVA41x
         TR7jtblFEnjkLrMoZS00YQP+ScVnS10wW+SSxQGCOy86tCNl4IdZAXq92RtUw9Rl284U
         5ci6UNpsEBXfudZYkf0LN1aU/0OJf2OVnNo3e5TsFR/78MFi8hknuLvTe2cmDr2Iz23M
         8I5w==
X-Gm-Message-State: AOAM531Qsq/dVmQtvfgC+gEQ2i4kCnqIoKIbzd7ZP75DPOU62qygUeFa
        0dLw4fggr/a+oYLWZEADY+GUjH8/2vvaioNOtE5AJPHW0V0aIqv2kkr7SozkE85eIjGy/mAEDBA
        0G60JTzVTgc+EUwml9KyzeYgs0oNdDflX51m2ZmSK4pSOVzcHog==
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr31976317oib.98.1639452008767;
        Mon, 13 Dec 2021 19:20:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZYy3vrJI5erZLzbK8j8AIuaUEm9zlOY5LI7xfy8mYTB10jRalX15dW1iBj7EEA3q4dqo9v+uUDoDxS9APxRc=
X-Received: by 2002:a05:6808:199c:: with SMTP id bj28mr31976296oib.98.1639452008405;
 Mon, 13 Dec 2021 19:20:08 -0800 (PST)
MIME-Version: 1.0
References: <20211214024901.223603-1-kai.heng.feng@canonical.com> <cdf57476e4a544e09859029bf05142c0@realtek.com>
In-Reply-To: <cdf57476e4a544e09859029bf05142c0@realtek.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 14 Dec 2021 11:19:57 +0800
Message-ID: <CAAd53p4v+CkEz-qruFr1+-Xu+z=pn1nTic-Jhfa5LN+svc7U-Q@mail.gmail.com>
Subject: Re: [PATCH] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
To:     Pkshih <pkshih@realtek.com>
Cc:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "jian-hong@endlessm.com" <jhp@endlessos.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Bernie Huang <phhuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:19 AM Pkshih <pkshih@realtek.com> wrote:
>
>
> > -----Original Message-----
> > From: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > Sent: Tuesday, December 14, 2021 10:49 AM
> > To: tony0620emma@gmail.com; Pkshih <pkshih@realtek.com>
> > Cc: jian-hong@endlessm.com; Kai-Heng Feng <kai.heng.feng@canonical.com>; Kalle Valo
> > <kvalo@codeaurora.org>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Brian
> > Norris <briannorris@chromium.org>; Bernie Huang <phhuang@realtek.com>; linux-wireless@vger.kernel.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: [PATCH] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
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
> >  drivers/net/wireless/realtek/rtw88/pci.c | 74 ++++++++----------------
> >  drivers/net/wireless/realtek/rtw88/pci.h |  1 +
> >  2 files changed, 24 insertions(+), 51 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> > index 3b367c9085eba..f09eb5e2437a9 100644
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
> > +static int rtw_rx_aspm;
>
> With your parameter description, rtw_rx_aspm = -1 by default.

Thanks for catching this, will send v2.

Kai-Heng

>
> >  module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
> >  module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
> > +module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
> >  MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
> >  MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
> > +MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)");
>
>
> [...]
>
> --
> Ping-Ke
>
