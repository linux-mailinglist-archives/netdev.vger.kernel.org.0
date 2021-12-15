Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C690475391
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 08:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbhLOHQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 02:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240473AbhLOHQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 02:16:13 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CFCC06173E
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 23:16:12 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id be32so30453881oib.11
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 23:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iTgtnQdRZOQC70dHZST7rANbpEQlupbSgOvB6m22IcU=;
        b=ZeitVrEzqWWAAbC4xIfGE+rrb/NjRImvUDDe1hBt/6xwKhnoRcR9X//uFZ6tLrfMZG
         SzfANUwo7rihe7dtXYZ5G7pEIb05iv+iWw7NOpdkE/6GjXq/7Mfhs/xyPyVRDi/64jnh
         EhZ2WlrNOK34Bx02+/s0M0c2hL3LA0XnWE1i0QuQwfuXTRdiBlSlSR5PTEUeE4fBgVhN
         YQHFM4uTmyN8tiZmN900uBRMgKAIMFG9cF++KxTC6DaifqTKy8Ll0+5Qf3B2IDwtyTst
         B6nyUxIghf9jfmyiawfcjzkVlrLzoN7VBpPU+fnYIQM7wdR1KZmIT254L8wSQEtkzH+N
         qpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iTgtnQdRZOQC70dHZST7rANbpEQlupbSgOvB6m22IcU=;
        b=CKHzWdP5CUyd+i20MTzCEwS7vqB2CvQdFHMUOTWtVr/As3weHJJ75VEdxO8Om8ROu9
         F/PJcytCMzbtSsItVkJn1r5Q2c6azrqCYEUYqoFTD2aZmZR0PBt2UfRxVZqTMaq0jRsf
         JvZuEMtJWjvF0HJWqAbizhrGWz3BVdFPCxblXmtxglm+hppj6MmazHEH99wIAC7QpB5d
         XI4lfktJSQROJmOJaI05l0tPLUX2RxoAmm10zO3FVOtUuNWxL9Nwhvi/XUo6+BwPxsry
         ixPFMdY/uMvxcTYXQU04DUd6EJ2CgC1/2oLEqYHks2o1e7ijtohfz0ySBqbyfutMb735
         ksWQ==
X-Gm-Message-State: AOAM533WyW/QmVO/4OOI3UUi1n5H8wTpPUF5OmGG0wRdbQ+1In3LRgaY
        MVTWj9OWihYpZ48UsY9/MMMwEZCZDcDgZEN/Unk5YA==
X-Google-Smtp-Source: ABdhPJyTzPgwdXIvoWRJgwE4Y0FO2roYSNMdAqCy4CzWkPpPWny0BmiTkJx3i6vrMTIxqrjUg+OKjA+YsVjfQAJvWPs=
X-Received: by 2002:a05:6808:d1:: with SMTP id t17mr7550480oic.161.1639552572191;
 Tue, 14 Dec 2021 23:16:12 -0800 (PST)
MIME-Version: 1.0
References: <20211215065508.313330-1-kai.heng.feng@canonical.com>
In-Reply-To: <20211215065508.313330-1-kai.heng.feng@canonical.com>
From:   Jian-Hong Pan <jhp@endlessos.org>
Date:   Wed, 15 Dec 2021 15:15:35 +0800
Message-ID: <CAPpJ_eff_NC3w7QjGtYtLjOBtSFBuRkFHojnuPC7neOmd54wcg@mail.gmail.com>
Subject: Re: [PATCH v3] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tried to apply this patch for testing.  But it seems conflicting to
commit c81edb8dddaa "rtw88: add quirk to disable pci caps on HP 250 G7
Notebook PC" in wireless-drivers-next repo.

Jian-Hong Pan

Kai-Heng Feng <kai.heng.feng@canonical.com> =E6=96=BC 2021=E5=B9=B412=E6=9C=
=8815=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=882:55=E5=AF=AB=E9=81=93=
=EF=BC=9A
>
> Many Intel based platforms face system random freeze after commit
> 9e2fd29864c5 ("rtw88: add napi support").
>
> The commit itself shouldn't be the culprit. My guess is that the 8821CE
> only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
> masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
> extremely slow. Eventually the RX ring becomes messed up:
> [ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status
>
> Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
> the driver to resolve the issue.
>
> Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D215131
> BugLink: https://bugs.launchpad.net/bugs/1927808
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v3:
>  - Move the module parameter to be part of private struct.
>  - Ensure link_usage never goes below zero.
>
> v2:
>  - Add default value for module parameter.
>
>  drivers/net/wireless/realtek/rtw88/pci.c | 61 ++++++++----------------
>  drivers/net/wireless/realtek/rtw88/pci.h |  2 +
>  2 files changed, 21 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index a7a6ebfaa203c..08cf66141889b 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -2,7 +2,6 @@
>  /* Copyright(c) 2018-2019  Realtek Corporation
>   */
>
> -#include <linux/dmi.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include "main.h"
> @@ -1409,7 +1408,11 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev=
, bool enter)
>          * throughput. This is probably because the ASPM behavior slightl=
y
>          * varies from different SOC.
>          */
> -       if (rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1)
> +       if (!(rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1))
> +               return;
> +
> +       if ((enter && atomic_dec_if_positive(&rtwpci->link_usage) =3D=3D =
0) ||
> +           (!enter && atomic_inc_return(&rtwpci->link_usage) =3D=3D 1))
>                 rtw_pci_aspm_set(rtwdev, enter);
>  }
>
> @@ -1658,6 +1661,9 @@ static int rtw_pci_napi_poll(struct napi_struct *na=
pi, int budget)
>                                               priv);
>         int work_done =3D 0;
>
> +       if (rtwpci->rx_no_aspm)
> +               rtw_pci_link_ps(rtwdev, false);
> +
>         while (work_done < budget) {
>                 u32 work_done_once;
>
> @@ -1681,6 +1687,8 @@ static int rtw_pci_napi_poll(struct napi_struct *na=
pi, int budget)
>                 if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
>                         napi_schedule(napi);
>         }
> +       if (rtwpci->rx_no_aspm)
> +               rtw_pci_link_ps(rtwdev, true);
>
>         return work_done;
>  }
> @@ -1702,50 +1710,13 @@ static void rtw_pci_napi_deinit(struct rtw_dev *r=
twdev)
>         netif_napi_del(&rtwpci->napi);
>  }
>
> -enum rtw88_quirk_dis_pci_caps {
> -       QUIRK_DIS_PCI_CAP_MSI,
> -       QUIRK_DIS_PCI_CAP_ASPM,
> -};
> -
> -static int disable_pci_caps(const struct dmi_system_id *dmi)
> -{
> -       uintptr_t dis_caps =3D (uintptr_t)dmi->driver_data;
> -
> -       if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_MSI))
> -               rtw_disable_msi =3D true;
> -       if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_ASPM))
> -               rtw_pci_disable_aspm =3D true;
> -
> -       return 1;
> -}
> -
> -static const struct dmi_system_id rtw88_pci_quirks[] =3D {
> -       {
> -               .callback =3D disable_pci_caps,
> -               .ident =3D "Protempo Ltd L116HTN6SPW",
> -               .matches =3D {
> -                       DMI_MATCH(DMI_SYS_VENDOR, "Protempo Ltd"),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "L116HTN6SPW"),
> -               },
> -               .driver_data =3D (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
> -       },
> -       {
> -               .callback =3D disable_pci_caps,
> -               .ident =3D "HP HP Pavilion Laptop 14-ce0xxx",
> -               .matches =3D {
> -                       DMI_MATCH(DMI_SYS_VENDOR, "HP"),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Laptop 1=
4-ce0xxx"),
> -               },
> -               .driver_data =3D (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
> -       },
> -       {}
> -};
> -
>  int rtw_pci_probe(struct pci_dev *pdev,
>                   const struct pci_device_id *id)
>  {
> +       struct pci_dev *bridge =3D pci_upstream_bridge(pdev);
>         struct ieee80211_hw *hw;
>         struct rtw_dev *rtwdev;
> +       struct rtw_pci *rtwpci;
>         int drv_data_size;
>         int ret;
>
> @@ -1763,6 +1734,9 @@ int rtw_pci_probe(struct pci_dev *pdev,
>         rtwdev->hci.ops =3D &rtw_pci_ops;
>         rtwdev->hci.type =3D RTW_HCI_TYPE_PCIE;
>
> +       rtwpci =3D (struct rtw_pci *)rtwdev->priv;
> +       atomic_set(&rtwpci->link_usage, 1);
> +
>         ret =3D rtw_core_init(rtwdev);
>         if (ret)
>                 goto err_release_hw;
> @@ -1791,7 +1765,10 @@ int rtw_pci_probe(struct pci_dev *pdev,
>                 goto err_destroy_pci;
>         }
>
> -       dmi_check_system(rtw88_pci_quirks);
> +       /* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
> +       if (pdev->device =3D=3D 0xc821 && bridge->vendor =3D=3D PCI_VENDO=
R_ID_INTEL)
> +               rtwpci->rx_no_aspm =3D true;
> +
>         rtw_pci_phy_cfg(rtwdev);
>
>         ret =3D rtw_register_hw(rtwdev, hw);
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wirel=
ess/realtek/rtw88/pci.h
> index 66f78eb7757c5..0c37efd8c66fa 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.h
> +++ b/drivers/net/wireless/realtek/rtw88/pci.h
> @@ -223,6 +223,8 @@ struct rtw_pci {
>         struct rtw_pci_tx_ring tx_rings[RTK_MAX_TX_QUEUE_NUM];
>         struct rtw_pci_rx_ring rx_rings[RTK_MAX_RX_QUEUE_NUM];
>         u16 link_ctrl;
> +       atomic_t link_usage;
> +       bool rx_no_aspm;
>         DECLARE_BITMAP(flags, NUM_OF_RTW_PCI_FLAGS);
>
>         void __iomem *mmap;
> --
> 2.33.1
>
