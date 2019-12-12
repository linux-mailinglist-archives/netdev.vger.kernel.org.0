Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B01C11C84C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 09:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbfLLIeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 03:34:25 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:46271 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbfLLIeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 03:34:25 -0500
Received: by mail-ua1-f68.google.com with SMTP id i31so519312uae.13
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 00:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7UHi4BJ1RU7e2Qqap02HTsnKWPKQhPRzj+3IJpyS25I=;
        b=CazqmSjeTmhzl/T12C6gcLYS78AV26Bg70XLZn0tfPlbRO0xZA1iYgJxjWgyvbKkYM
         fqV5h9oeUZn2BR/O8OFlfjMF2ZBJkAoH7qEN8CgXpr3Yx5caJxkU3c/jv7Vkdkn1kQcW
         0VvbmS0LJs31VYHSUKL+UOKderGSIrcaDzMIwLQ4gBxSZQntQeVK8YxgGb7cUKPqWdPE
         td3UK3ak3il/JVLcA4/pZvdsHY2kEG9/lPeK3G6OUwgjdD041nqzE1Eh4w2pulwEskla
         yziHm1/CNTbjVgTqoFg/JwFFwNiQOrzY+AwZ/Y0nQ49mgMp66XvA+LVRVVinF77kDisu
         B4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7UHi4BJ1RU7e2Qqap02HTsnKWPKQhPRzj+3IJpyS25I=;
        b=C91H+uvOFf1zr/qujD+d1EBNScjLJegtEJJgw88SAGiZ67FVF8FGIDCPw1FDdsRCxq
         +EdMM7NVN26CDsWGi59OdxSG9ZKUAs4I9SQiNVkc4ouHHVMZkurqmAYC6ZQmzTCnwnGf
         mxKSouXPdgk/f56IO7MTJpgqOdg/+YOZqgVbDF+3hApY3bKG2r1njDI9wKfxmxTtYV1W
         g95ozwuwQo2/OqUGcGRvPT3n4nDKMeuNdNiHPxUzMoWMSaGOoh9blXp96TAf9Ttw+E2N
         BC1dnr8rVv3qiq3eTYS4pUt6OyipUkYk5m7YNltof+Idw7bs8Lwc+uZv7sibWIXP3puV
         Ducg==
X-Gm-Message-State: APjAAAUnQgEFA2acOx/oTCsLfsfvmnVexEUJawgjn/51Iz7LO8wmCHpi
        Y1fqQ/20IFllYG4uz8TnxVz2AH0U1rMDgEUGllPuUw==
X-Google-Smtp-Source: APXvYqynopALtn3p4wqILJgjiXAeEzWwP6jaNx08xBuWSale2Uc+wFkAq1aVL/iomN6MiJTwLqjwY+vVT8KlCKpstMw=
X-Received: by 2002:ab0:4ea6:: with SMTP id l38mr7262273uah.129.1576139663793;
 Thu, 12 Dec 2019 00:34:23 -0800 (PST)
MIME-Version: 1.0
References: <20191211235253.2539-1-smoch@web.de> <20191211235253.2539-6-smoch@web.de>
In-Reply-To: <20191211235253.2539-6-smoch@web.de>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 12 Dec 2019 09:33:46 +0100
Message-ID: <CAPDyKFoE7g0XsyTkbSYBRE0=JraPCxCP+wyZ2PQFVpAvvQvCfg@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] brcmfmac: add support for BCM4359 SDIO chipset
To:     Soeren Moch <smoch@web.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 at 00:53, Soeren Moch <smoch@web.de> wrote:
>
> BCM4359 is a 2x2 802.11 abgn+ac Dual-Band HT80 combo chip and it
> supports Real Simultaneous Dual Band feature.
>
> Based on a similar patch by: Wright Feng <wright.feng@cypress.com>
>
> Signed-off-by: Soeren Moch <smoch@web.de>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
> changes in v2:
> - add SDIO_DEVICE_ID_CYPRESS_89359 as requested
>   by Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> Cc: Wright Feng <wright.feng@cypress.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list.pdl@broadcom.com
> Cc: brcm80211-dev-list@cypress.com
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-rockchip@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 1 +
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 ++
>  include/linux/mmc/sdio_ids.h                              | 2 ++
>  4 files changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 68baf0189305..f4c53ab46058 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -973,8 +973,10 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
> +       BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_4373),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_43012),
> +       BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_CYPRESS_89359),
>         { /* end: all zeroes */ }
>  };
>  MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index baf72e3984fc..282d0bc14e8e 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -1408,6 +1408,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>                 addr = CORE_CC_REG(base, sr_control0);
>                 reg = chip->ops->read32(chip->ctx, addr);
>                 return (reg & CC_SR_CTL0_ENABLE_MASK) != 0;
> +       case BRCM_CC_4359_CHIP_ID:
>         case CY_CC_43012_CHIP_ID:
>                 addr = CORE_CC_REG(pmu->base, retention_ctl);
>                 reg = chip->ops->read32(chip->ctx, addr);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 21e535072f3f..c4012ed58b9c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -616,6 +616,7 @@ BRCMF_FW_DEF(43455, "brcmfmac43455-sdio");
>  BRCMF_FW_DEF(43456, "brcmfmac43456-sdio");
>  BRCMF_FW_DEF(4354, "brcmfmac4354-sdio");
>  BRCMF_FW_DEF(4356, "brcmfmac4356-sdio");
> +BRCMF_FW_DEF(4359, "brcmfmac4359-sdio");
>  BRCMF_FW_DEF(4373, "brcmfmac4373-sdio");
>  BRCMF_FW_DEF(43012, "brcmfmac43012-sdio");
>
> @@ -638,6 +639,7 @@ static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>         BRCMF_FW_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFDC0, 43455),
>         BRCMF_FW_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
>         BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
> +       BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>         BRCMF_FW_ENTRY(CY_CC_4373_CHIP_ID, 0xFFFFFFFF, 4373),
>         BRCMF_FW_ENTRY(CY_CC_43012_CHIP_ID, 0xFFFFFFFF, 43012)
>  };
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 08b25c02b5a1..2e9a6e4634eb 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -41,8 +41,10 @@
>  #define SDIO_DEVICE_ID_BROADCOM_43455          0xa9bf
>  #define SDIO_DEVICE_ID_BROADCOM_4354           0x4354
>  #define SDIO_DEVICE_ID_BROADCOM_4356           0x4356
> +#define SDIO_DEVICE_ID_BROADCOM_4359           0x4359
>  #define SDIO_DEVICE_ID_CYPRESS_4373            0x4373
>  #define SDIO_DEVICE_ID_CYPRESS_43012           43012
> +#define SDIO_DEVICE_ID_CYPRESS_89359           0x4355
>
>  #define SDIO_VENDOR_ID_INTEL                   0x0089
>  #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX     0x1402
> --
> 2.17.1
>
