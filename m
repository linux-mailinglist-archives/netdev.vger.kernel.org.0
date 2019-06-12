Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FF14276C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437658AbfFLN0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:26:09 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:44228 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfFLN0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 09:26:09 -0400
Received: by mail-vk1-f195.google.com with SMTP id x129so3248345vkc.11
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 06:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E7fySMumjNmRNmMY5t+/ORC71GvUDcf7jQJsz2Lmu8Y=;
        b=QYWBrnNjzTR4SGTlmO+2dMnBv0gF7OVThMta1UF3J+3SU6BeS6RM+NzORZ66PxnWMr
         TN4VaBhSU8xmyY+EpiRD7RUp/3nb+aJxMFRBITrHO7pf7VOLwfr75hgtcrdjNdhikPqg
         CQ0xBkMxoL13nkJCidmvZ5LkHGd1qFz+h1IAO85qJdsWiPFmVRRH9ubM6QwTjpUo0lRH
         l8+unLl6yS22kj5G2/kesq8q0bzn8XxOe56vJ7Nwgq1hxtYfcbCqgmfsl9UPsih6Eq4f
         44D0bXKixT4b/tmZKKQrVAKKLo9+5lz4OVfKHUOuvLssmnlfk4kDGpVhZNeT0V3qZoSs
         Ezrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E7fySMumjNmRNmMY5t+/ORC71GvUDcf7jQJsz2Lmu8Y=;
        b=Y3/KA9ume4tzHVGRRCqlNSzsRXBrfXYRN/fGSHHLMi/bWJKuBtun6WL3oaljPNYdTD
         WfAobveTrl/uAlp/rwVf++QAldH3h09yWxM7bW0h2Kcg0zeTTRxl59qAFb7ENCY1jV5h
         tZy+Ug2bK1aaWI4j6cTBDrp0ce0d6W74v3St5Byc0nUwFBp/KEEWw8bta/b1u7xMkkF9
         ei9s5+Bzizlwy2KDG5PR58ZYK/VpLrrxRjRa53wARWRUFF3wwsfBQtMnJX8rLeb7tXIZ
         8Zry/7aoGO0QL+aSFyAQ4F67cdArplHxroHb5rY0C1VEKLiepd3IZ+cfJf0E/1twLNK4
         WTOQ==
X-Gm-Message-State: APjAAAUpiLT9TazegKEZZCF9DTej5Nm/sJstcGa41w3SvKkmHL6wLpfj
        2F1QapPAV+QWG6p6HN0WyN4uS2eC8roJ/LVjUyzStQ==
X-Google-Smtp-Source: APXvYqzHLztZ6A07mA3L0RxrvDr4TaNWEVgx7eQUPB1lNxzINC6SuMv7jHQOr/DXwamjqJh6KLqVETMYT0iIgnB+Yjs=
X-Received: by 2002:ac5:c2d2:: with SMTP id i18mr23129212vkk.36.1560345967778;
 Wed, 12 Jun 2019 06:26:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190607223716.119277-1-dianders@chromium.org> <20190607223716.119277-3-dianders@chromium.org>
In-Reply-To: <20190607223716.119277-3-dianders@chromium.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 12 Jun 2019 15:25:31 +0200
Message-ID: <CAPDyKFpdkkzkbSy-uWL8TwdNFjJi10au7ZDOYjoWuDzftpoNsQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] mmc: core: API for temporarily disabling
 auto-retuning due to errors
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
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Avri Altman <avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Jun 2019 at 00:37, Douglas Anderson <dianders@chromium.org> wrote:
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
> state on certain Broadcom WiFi cards.  Specifically if the card was
> already transitioning between states when the command was sent it
> could cause an error on the SDIO bus.
>
> Let's add an API that the SDIO card drivers can call that will
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
> Note that are are a whole boatload of different ways that we could
> provide an API for the Broadcom WiFi SDIO driver.  This patch
> illustrates one way but if maintainers feel strongly that this is too
> ugly and have a better idea then I can give it a shot too.  From a
> purist point of view I kinda felt that the "expect errors" really
> belonged as part of the mmc_request structure, but getting it into
> there meant changing a whole pile of core SD/MMC APIs.  Simply adding
> it to the host seemed to match the current style better and was a less
> intrusive change.
>
> Changes in v3:
> - Took out the spinlock since I believe this is all in one context.

This needs to be clarified, preferable also in a function header.

If I understand correctly, the SDIO func driver needs the host to be
claimed when it calls mmc_expect_errors_begin(). More importantly, it
also needs to be keep it claimed until after it had called
mmc_expect_errors_end(). Correct?

>
> Changes in v2:
> - Updated commit message to clarify based on discussion of v1.
>
>  drivers/mmc/core/core.c  | 19 +++++++++++++++++--
>  include/linux/mmc/core.h |  2 ++
>  include/linux/mmc/host.h |  1 +
>  3 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 6db36dc870b5..bc109ec49406 100644
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
> +           !host->expect_errors &&
>             (err == -EILSEQ || (mrq->sbc && mrq->sbc->error == -EILSEQ) ||
>             (mrq->data && mrq->data->error == -EILSEQ) ||
>             (mrq->stop && mrq->stop->error == -EILSEQ)))
> @@ -2163,6 +2164,20 @@ int mmc_sw_reset(struct mmc_host *host)
>  }
>  EXPORT_SYMBOL(mmc_sw_reset);
>
> +void mmc_expect_errors_begin(struct mmc_host *host)
> +{
> +       WARN_ON(host->expect_errors);

Please remove the WARN_ON. If you believe there is a need for
reference counting, then please add that instead (but likely not in
the phase?).

> +       host->expect_errors = true;
> +}
> +EXPORT_SYMBOL_GPL(mmc_expect_errors_begin);
> +
> +void mmc_expect_errors_end(struct mmc_host *host)
> +{
> +       WARN_ON(!host->expect_errors);

Ditto.

> +       host->expect_errors = false;
> +}
> +EXPORT_SYMBOL_GPL(mmc_expect_errors_end);

These new APIs seems to be useful solely for SDIO. Even if it turns
out later that they can be made generic, I suggest to start with a
SDIO func API instead.

However, using a new host variable (->expect_errors) is fine by me.

> +
>  static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
>  {
>         host->f_init = freq;
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

The API prevents a new re-tune to be "scheduled" in case requests are
failing with -EILSEQ.

To better reflect that, may I suggest to rename this to
sdio_retune_crc_disable() and sdio_retune_crc_enable(). Or something
along those lines.


>  void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card);
>
>  #endif /* LINUX_MMC_CORE_H */
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 43d0f0c496f6..8d553fb8c834 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -398,6 +398,7 @@ struct mmc_host {
>         unsigned int            retune_now:1;   /* do re-tuning at next req */
>         unsigned int            retune_paused:1; /* re-tuning is temporarily disabled */
>         unsigned int            use_blk_mq:1;   /* use blk-mq */
> +       unsigned int            expect_errors:1; /* don't trigger retune upon errors */
>
>         int                     rescan_disable; /* disable card detection */
>         int                     rescan_entered; /* used with nonremovable devices */
> --
> 2.22.0.rc2.383.gf4fbbf30c2-goog
>

Kind regards
Uffe
