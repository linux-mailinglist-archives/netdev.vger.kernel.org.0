Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B945248C289
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352617AbiALKvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352630AbiALKvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:51:55 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A94C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 02:51:54 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s30so6627579lfo.7
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 02:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ajadRxekfKlNZLmonMEGUdpiiUlJCpBU8D0nYRIxhqA=;
        b=n7ouKiMIb/tYofVya2jhLWqIz4otlZtpCCE4aguIdHQS6dKoDs8RksAdkHVkfh6ck9
         kLk0Qw8b9sD6WfOvMmBksUUT/hrgra1I5API4Y6De42JSRUZLf8BRJKHORRK20eAuH9Z
         swLy1bap3RlWJDUOMzIPyTBWUX06YOkgPTcU1RN0vX5H25enAYzExMTYYSCp0FfsdTGY
         lCUHBleRTxjJZ/zLOnra4Cugri59EkvL9QHtXp6yzeoBDHKWdRMa4IKepql+xYOfmE3V
         +vq+5Z3GSTB+IFeoGbA8QKA7aUQmuOgEdues2+HRvY+0UaG7QLcRZBpvmP6TFxyAaliz
         U2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ajadRxekfKlNZLmonMEGUdpiiUlJCpBU8D0nYRIxhqA=;
        b=ELkg9CPa6+MY6ZhctpEDdJmtLDiVPgoP67ZtOMB+YJwgK3OGwtxN/gzkOkCF2UJqhh
         AfdPYSYgPUdviLeVU+T1A1egk6KTYakmkRTsJR6aa0A4OreaGCFYj9cVzmrY+jM25gL9
         Ii8t9xM0da+6j7NkE0qXyDTqzqDR1wZ/9nM8PEuErxIva/bu1fR/yp9aZar5P/w7UIIj
         THYipgWeWXWKUbiAAIWspeoGCpq/CoNxq1dXtheESDlrozkHeQUKxpD5emD0/RUMXxaL
         JAS8DFL/SLsZApy6tYaEIPgr5zMlHUXuMV4A7YqVtURQaovmJ+2HKWyXzqCa8MUG5bLt
         919g==
X-Gm-Message-State: AOAM533G4CWoJXYe34ZrF/BdNrdRFV6FXgdOZ9lg103HFADOknAs5YKb
        rXAtX0cIYQVth1qt/em6rrdp3TZYKx3lofqaWj7izWW1xcfptQ==
X-Google-Smtp-Source: ABdhPJwlG2ajFyVnViZREk3eK3GmcRqUFKwmypVgeholraY8xEQawKZtMDgFhgZE9kKw4JIyjTxnCJC3g5FMtOM/0kI=
X-Received: by 2002:a05:651c:98f:: with SMTP id b15mr6038585ljq.367.1641984713037;
 Wed, 12 Jan 2022 02:51:53 -0800 (PST)
MIME-Version: 1.0
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
In-Reply-To: <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 12 Jan 2022 11:51:16 +0100
Message-ID: <CAPDyKFoMQG-GOfRsMk21Awk21cxVN6bMe9n8YCh8xHbg7j1Rgg@mail.gmail.com>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]

> +static const struct of_device_id wfx_sdio_of_match[] = {
> +       { .compatible = "silabs,wf200",    .data = &pdata_wf200 },
> +       { .compatible = "silabs,brd4001a", .data = &pdata_brd4001a },
> +       { .compatible = "silabs,brd8022a", .data = &pdata_brd8022a },
> +       { .compatible = "silabs,brd8023a", .data = &pdata_brd8023a },
> +       { .compatible = "silabs,wfx-sdio", .data = &pdata_wfx_sdio },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, wfx_sdio_of_match);
> +
> +static int wfx_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
> +{
> +       const struct wfx_platform_data *pdata = of_device_get_match_data(&func->dev);
> +       struct device_node *np = func->dev.of_node;
> +       struct wfx_sdio_priv *bus;
> +       int ret;
> +
> +       if (func->num != 1) {
> +               dev_err(&func->dev, "SDIO function number is %d while it should always be 1 (unsupported chip?)\n",
> +                       func->num);
> +               return -ENODEV;
> +       }
> +
> +       if (!pdata) {
> +               dev_warn(&func->dev, "no compatible device found in DT\n");
> +               return -ENODEV;
> +       }
> +
> +       bus = devm_kzalloc(&func->dev, sizeof(*bus), GFP_KERNEL);
> +       if (!bus)
> +               return -ENOMEM;
> +
> +       bus->func = func;
> +       bus->of_irq = irq_of_parse_and_map(np, 0);
> +       sdio_set_drvdata(func, bus);
> +       func->card->quirks |= MMC_QUIRK_LENIENT_FN0 |
> +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;

This should not be needed any more, right?

> +
> +       sdio_claim_host(func);
> +       ret = sdio_enable_func(func);
> +       /* Block of 64 bytes is more efficient than 512B for frame sizes < 4k */
> +       sdio_set_block_size(func, 64);
> +       sdio_release_host(func);
> +       if (ret)
> +               return ret;
> +
> +       bus->core = wfx_init_common(&func->dev, pdata, &wfx_sdio_hwbus_ops, bus);
> +       if (!bus->core) {
> +               ret = -EIO;
> +               goto sdio_release;
> +       }
> +
> +       ret = wfx_probe(bus->core);
> +       if (ret)
> +               goto sdio_release;
> +
> +       return 0;
> +
> +sdio_release:
> +       sdio_claim_host(func);
> +       sdio_disable_func(func);
> +       sdio_release_host(func);
> +       return ret;
> +}

[...]

Other than the above, this looks good to me!


Kind regards
Uffe
