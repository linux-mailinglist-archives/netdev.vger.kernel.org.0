Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE90F4B84F0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiBPJwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:52:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiBPJw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:52:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A131A3A4;
        Wed, 16 Feb 2022 01:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E14AAB818F7;
        Wed, 16 Feb 2022 09:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCCEC004E1;
        Wed, 16 Feb 2022 09:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645005101;
        bh=jrCG01kuZtoWFzJMK4a9MI6BlNvCp9nP8W6TDqdJUAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VUio0Q9vJ7wTrHosofFUk73FdcSLNbwzOeAyvASdGD/Q4N7+9MJl+CTVhqiBNpg4S
         DGTKAi4HIUXaAR3ys4yo0utRqVdAWLfS4yYWUe3M8OwUWJ61wp8PSe7FFzU0X6cn65
         B8IFJjpTymndDJJJDQJYNFVGJPaxHYzt3oVJvIuKNu1XHTQYZIVPRMZ/gnHAh7ceUG
         lCrQHvRaaXU+ZqI33DQICXUdbQXJZJRcrukEfgk6QRr0KUxIWN3MXpO4PA7n09ds4O
         sNw33JAQyj3fSlwdvTaFreL703xgCLwy/YyqPa91IwU3K50xIQGIwVAfzVYB/W7pia
         /Y3vOfVtO88Ew==
Received: by pali.im (Postfix)
        id 583107F4; Wed, 16 Feb 2022 10:51:39 +0100 (CET)
Date:   Wed, 16 Feb 2022 10:51:39 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/2] staging: wfx: apply the necessary SDIO quirks for
 the Silabs WF200
Message-ID: <20220216095139.2oulgq2vwvpsmnan@pali>
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
 <20220216093112.92469-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216093112.92469-3-Jerome.Pouiller@silabs.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 16 February 2022 10:31:12 Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Until now, the SDIO quirks are applied directly from the driver.
> However, it is better to apply the quirks before driver probing. So,
> this patch relocate the quirks in the MMC framework.
> 
> Note that the WF200 has no valid SDIO VID/PID. Therefore, we match DT
> rather than on the SDIO VID/PID.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Reviewed-by: Pali Rohár <pali@kernel.org>

> ---
>  drivers/mmc/core/quirks.h      | 5 +++++
>  drivers/staging/wfx/bus_sdio.c | 3 ---
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/core/quirks.h b/drivers/mmc/core/quirks.h
> index 20f568727277..f879dc63d936 100644
> --- a/drivers/mmc/core/quirks.h
> +++ b/drivers/mmc/core/quirks.h
> @@ -149,6 +149,11 @@ static const struct mmc_fixup __maybe_unused sdio_fixup_methods[] = {
>  static const struct mmc_fixup __maybe_unused sdio_card_init_methods[] = {
>  	SDIO_FIXUP_COMPATIBLE("ti,wl1251", wl1251_quirk, 0),
>  
> +	SDIO_FIXUP_COMPATIBLE("silabs,wf200", add_quirk,
> +			      MMC_QUIRK_BROKEN_BYTE_MODE_512 |
> +			      MMC_QUIRK_LENIENT_FN0 |
> +			      MMC_QUIRK_BLKSZ_FOR_BYTE_MODE),
> +
>  	END_FIXUP
>  };
>  
> diff --git a/drivers/staging/wfx/bus_sdio.c b/drivers/staging/wfx/bus_sdio.c
> index 312d2d391a24..51a0d58a9070 100644
> --- a/drivers/staging/wfx/bus_sdio.c
> +++ b/drivers/staging/wfx/bus_sdio.c
> @@ -216,9 +216,6 @@ static int wfx_sdio_probe(struct sdio_func *func, const struct sdio_device_id *i
>  	bus->func = func;
>  	bus->of_irq = irq_of_parse_and_map(np, 0);
>  	sdio_set_drvdata(func, bus);
> -	func->card->quirks |= MMC_QUIRK_LENIENT_FN0 |
> -			      MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> -			      MMC_QUIRK_BROKEN_BYTE_MODE_512;
>  
>  	sdio_claim_host(func);
>  	ret = sdio_enable_func(func);
> -- 
> 2.34.1
> 
