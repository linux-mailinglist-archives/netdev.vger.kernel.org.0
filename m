Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4305045C19
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbfFNMEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 08:04:44 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33182 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfFNMEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 08:04:42 -0400
Received: by mail-vs1-f65.google.com with SMTP id m8so1616188vsj.0
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 05:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wekL8YWDkqRel6lPpDwHCRj0DcIfrEA1VPjPXzU8y0w=;
        b=G7aTMou1vJgBraiplgcH9VZVlbYJFsAxlBbQdqVuDa3SJHcvyDthJgVqg2DS4u0IQM
         1Vl+WtF9IOC5bYYcbIqpuVq3dgJzPR058qJC/EdRNB1gNr1SpRLo6iA+4IAhKNn3kWw4
         um1dObJ4YBBftyVGVc6gB5YRujZpnKb1uW5SlmPHRrlCJ1KQ4OmCkUBVtesjaQ6Y/tT0
         QXufDxUwKJgiVdtTVnXDZGn1Mpgat4BCjICRVvz5A5MeEc8O29p3uXt5fcnxfPqShBKg
         WdX86d3Qu8i8oip25NrC9qm+JfffO/xm09y+aDoJTZWgAv1wjP/yN7DnrcUab/VGHbTI
         bAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wekL8YWDkqRel6lPpDwHCRj0DcIfrEA1VPjPXzU8y0w=;
        b=a699F+on4TL3g+K1YloIOxDrJZRX5i5+HsTtPJ2KdGP3J1u0EKAPjVU8cKUmmBeZvU
         rgRUESJ0mpCLkMrtCdGqH9FLQHWYWpStRppYy3czj/G4shbjG/vO9JrbHYH11Yxt0nml
         8TYWMzog19kd0cDJiXoQ7BES9OzoDefvi/NWxJgIShds7B/eRjdPA1WmHjzO1iCKOcxb
         1BB5T4jBEdL4auvA/WwyFs1PZp6GbmYOLa7aIiGy76ZZsTKCGFsHzOx7FwXM0A+sd8OB
         6NMGO9SQl6S7AV6U35/wjnTV24IJG0a3LhHWBnccRmxx+P0nDd6P7vpZGU/nrEhM+WxX
         VF2Q==
X-Gm-Message-State: APjAAAV27lztdhlq6aW9/uVzMz6BAvERjvGrlU0GZ4PCP2gpiVooLhuI
        eMBmRoVP6cvpkKfMWbEezLxtkIs11/5yy67vxv4Fpg==
X-Google-Smtp-Source: APXvYqzyYPyYu3NhlneNtUy4uQw7vXiO9xEyqIq8cxSgVVuv4L3wQ/rXvq7FFDRacsSyvGtTRS40uoD0WBeOCwmNVlo=
X-Received: by 2002:a67:ee16:: with SMTP id f22mr3486750vsp.191.1560513881577;
 Fri, 14 Jun 2019 05:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190613234153.59309-1-dianders@chromium.org> <20190613234153.59309-3-dianders@chromium.org>
In-Reply-To: <20190613234153.59309-3-dianders@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 14 Jun 2019 14:04:05 +0200
Message-ID: <CAPDyKFrgXGf_9=H7G40fiUQj=da5WWRys_oim2azgL4FEOeUVA@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mmc: core: API to temporarily disable retuning for
 SDIO CRC errors
To:     Douglas Anderson <dianders@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Double Lo <double.lo@cypress.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        Jiong Wu <lohengrin1024@gmail.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Allison Randal <allison@lohutok.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 at 01:42, Douglas Anderson <dianders@chromium.org> wrote:
>
> Normally when the MMC core sees an "-EILSEQ" error returned by a host
> controller then it will trigger a retuning of the card.  This is
> generally a good idea.
>
> However, if a command is expected to sometimes cause transfer errors
> then these transfer errors shouldn't cause a re-tuning.  This
> re-tuning will be a needless waste of time.  One example case where a
> transfer is expected to cause errors is when transitioning between
> idle (sometimes referred to as "sleep" in Broadcom code) and active
> state on certain Broadcom WiFi SDIO cards.  Specifically if the card
> was already transitioning between states when the command was sent it
> could cause an error on the SDIO bus.
>
> Let's add an API that the SDIO function drivers can call that will
> temporarily disable the auto-tuning functionality.  Then we can add a
> call to this in the Broadcom WiFi driver and any other driver that
> might have similar needs.
>
> NOTE: this makes the assumption that the card is already tuned well
> enough that it's OK to disable the auto-retuning during one of these
> error-prone situations.  Presumably the driver code performing the
> error-prone transfer knows how to recover / retry from errors.  ...and
> after we can get back to a state where transfers are no longer
> error-prone then we can enable the auto-retuning again.  If we truly
> find ourselves in a case where the card needs to be retuned sometimes
> to handle one of these error-prone transfers then we can always try a
> few transfers first without auto-retuning and then re-try with
> auto-retuning if the first few fail.
>
> Without this change on rk3288-veyron-minnie I periodically see this in
> the logs of a machine just sitting there idle:
>   dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to XYZ
>
> Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
>
> Changes in v4:
> - Moved to SDIO API only (Adrian, Ulf).
> - Renamed to make it less generic, now retune_crc_disable (Ulf).
> - Function header makes it clear host must be claimed (Ulf).
> - No more WARN_ON (Ulf).
>
> Changes in v3:
> - Took out the spinlock since I believe this is all in one context.
>
> Changes in v2:
> - Updated commit message to clarify based on discussion of v1.
>
>  drivers/mmc/core/core.c       |  5 +++--
>  drivers/mmc/core/sdio_io.c    | 36 +++++++++++++++++++++++++++++++++++
>  include/linux/mmc/core.h      |  2 ++
>  include/linux/mmc/host.h      |  1 +
>  include/linux/mmc/sdio_func.h |  3 +++
>  5 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6db36dc870b5..9020cb2490f7 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -144,8 +144,9 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
>         int err = cmd->error;
>
>         /* Flag re-tuning needed on CRC errors */
> -       if ((cmd->opcode != MMC_SEND_TUNING_BLOCK &&
> -           cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200) &&
> +       if (cmd->opcode != MMC_SEND_TUNING_BLOCK &&
> +           cmd->opcode != MMC_SEND_TUNING_BLOCK_HS200 &&
> +           !host->retune_crc_disable &&
>             (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
>             (mrq->data && mrq->data->error == -EILSEQ) ||
>             (mrq->stop && mrq->stop->error == -EILSEQ)))
> diff --git a/drivers/mmc/core/sdio_io.c b/drivers/mmc/core/sdio_io.c
> index f79f0b0caab8..f822a9630b0e 100644
> --- a/drivers/mmc/core/sdio_io.c
> +++ b/drivers/mmc/core/sdio_io.c
> @@ -734,3 +734,39 @@ int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags)
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(sdio_set_host_pm_flags);
> +
> +/**
> + *     sdio_retune_crc_disable - temporarily disable retuning on CRC errors
> + *     @func: SDIO function attached to host
> + *
> + *     If the SDIO card is known to be in a state where it might produce
> + *     CRC errors on the bus in response to commands (like if we know it is
> + *     transitioning between power states), an SDIO function driver can
> + *     call this function to temporarily disable the SD/MMC core behavior of
> + *     triggering an automatic retuning.
> + *
> + *     This function should be called while the host is claimed and the host
> + *     should remain claimed until sdio_retune_crc_enable() is called.
> + *     Specifically, the expected sequence of calls is:
> + *     - sdio_claim_host()
> + *     - sdio_retune_crc_disable()
> + *     - some number of calls like sdio_writeb() and sdio_readb()

sdio_retune_crc_enable()

> + *     - sdio_release_host()
> + */
> +void sdio_retune_crc_disable(struct sdio_func *func)
> +{
> +       func->card->host->retune_crc_disable = true;
> +}
> +EXPORT_SYMBOL_GPL(sdio_retune_crc_disable);
> +
> +/**
> + *     sdio_retune_crc_enable - reneable retuning on CRC errors

/s/reneable/re-enable

> + *     @func: SDIO function attached to host
> + *
> + *     This is the compement to sdio_retune_crc_disable().
> + */
> +void sdio_retune_crc_enable(struct sdio_func *func)
> +{
> +       func->card->host->retune_crc_disable = false;
> +}
> +EXPORT_SYMBOL_GPL(sdio_retune_crc_enable);
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 134a6483347a..02a13abf0cda 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -178,6 +178,8 @@ int mmc_wait_for_cmd(struct mmc_host *host, struct mmc_command *cmd,
>
>  int mmc_hw_reset(struct mmc_host *host);
>  int mmc_sw_reset(struct mmc_host *host);
> +void mmc_expect_errors_begin(struct mmc_host *host);
> +void mmc_expect_errors_end(struct mmc_host *host);

Leftovers for earlier versions.

>  void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card);
>
>  #endif /* LINUX_MMC_CORE_H */
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 43d0f0c496f6..ecb7972e2423 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -398,6 +398,7 @@ struct mmc_host {
>         unsigned int            retune_now:1;   /* do re-tuning at next req */
>         unsigned int            retune_paused:1; /* re-tuning is temporarily disabled */
>         unsigned int            use_blk_mq:1;   /* use blk-mq */
> +       unsigned int            retune_crc_disable:1; /* don't trigger retune upon crc */
>
>         int                     rescan_disable; /* disable card detection */
>         int                     rescan_entered; /* used with nonremovable devices */
> diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
> index e9dfdd501cd1..4820e6d09dac 100644
> --- a/include/linux/mmc/sdio_func.h
> +++ b/include/linux/mmc/sdio_func.h
> @@ -167,4 +167,7 @@ extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
>  extern mmc_pm_flag_t sdio_get_host_pm_caps(struct sdio_func *func);
>  extern int sdio_set_host_pm_flags(struct sdio_func *func, mmc_pm_flag_t flags);
>
> +extern void sdio_retune_crc_disable(struct sdio_func *func);
> +extern void sdio_retune_crc_enable(struct sdio_func *func);
> +
>  #endif /* LINUX_MMC_SDIO_FUNC_H */
> --
> 2.22.0.rc2.383.gf4fbbf30c2-goog
>

Besides the minor comments, this looks good to me.

Kind regards
Uffe
