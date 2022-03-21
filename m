Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF264E31D3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353360AbiCUUci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244766AbiCUUch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:32:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A23782D39
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:31:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so412945pjb.3
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wyaW51GCbOw4pskk2fP77amiIp+gooNOj0TN4dCItPo=;
        b=QHP1oxRiXm6/iRN/s7uKJfRLzoriMbyhlu4nxHx9CntxyuT1JW9o9MiQRWR4CbPN0P
         wrUuXzPPQVyqpzROIyLKirNlc+rgAnRBQnCIsWwy6sWH2TbTVfpHt89SWF2HLd1ddxcr
         19DpZdc31lZCs8H5EUX6TCUegSGvU0HG0WvRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wyaW51GCbOw4pskk2fP77amiIp+gooNOj0TN4dCItPo=;
        b=XOJOqhscUsxkCvIg2T69xN+St029JNO/tuOQ6J4Nrzn4AVAf8rAqfGfHpgkmv8BeEa
         T+/KYFksU04AjgoVcpHEaxWBOt0NrHFyrS1oKxu+PqRaJFTVmbmr0YV5TgZBsxna5yN9
         sgS6CCawU7OSSkJ/8tipb6CT7BWX8vbNT8IDog3cex222l3/+AJvIgoaAstC0/mkSnIp
         A06e8pEWaYb/TLjUDRsYnGWme9zJNGlk8ueKr9q3rQ4g8E8VDStd+dzC5vCGEo/dYuK+
         iBkXI5oiWnTrKp0QEuFVFDcEy1me3he2mUH1ZDEX/BO1vcLK0ZJ3hiDvmiofrU8GP1tK
         Uxaw==
X-Gm-Message-State: AOAM532gOe72N8L6En7yXXteglGP6mMXl9I41nVTA2zj396s8fU7YbY6
        IR59FyZ87BkzjUYM4hFqi558wg==
X-Google-Smtp-Source: ABdhPJw5hp3xn0PSEdQR2aNkyuKAd2aqMJsqb786uJYPzCHzZBWyEdDJLvNuVgntvNCW3OdFSHKBHA==
X-Received: by 2002:a17:902:690b:b0:154:5daa:7253 with SMTP id j11-20020a170902690b00b001545daa7253mr6299845plk.2.1647894670830;
        Mon, 21 Mar 2022 13:31:10 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:6dba:56e0:1f17:3446])
        by smtp.gmail.com with ESMTPSA id s11-20020a056a0008cb00b004fa2a3b989dsm20233958pfu.157.2022.03.21.13.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:31:10 -0700 (PDT)
Date:   Mon, 21 Mar 2022 13:31:07 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org,
        Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Subject: Re: [RFC PATCH] mwifiex: Select firmware based on strapping
Message-ID: <Yjjgi4YJVYBnJTqK@google.com>
References: <20220321161003.39214-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321161003.39214-1-francesco.dolcini@toradex.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 05:10:03PM +0100, Francesco Dolcini wrote:
> From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
> 
> Some WiFi/Bluetooth modules might have different host connection
> options, allowing to either use SDIO for both WiFi and Bluetooth,
> or SDIO for WiFi and UART for Bluetooth. It is possible to detect
> whether a module has SDIO-SDIO or SDIO-UART connection by reading
> its host strap register.
> 
> This change introduces a way to automatically select appropriate
> firmware depending of the connection method, and removes a need
> of symlinking or overwriting the original firmware file with a
> required one.
> 
> Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
> Hi all,
> 
> Current mwifiex_sdio implementation does not have strapping detection, which
> means there's no way system will automatically detect which firmware needs to
> be picked depending of the strapping. SD8997, in particular, can be strapped
> for sdiosdio (Wi-Fi over SDIO, Bluetooth over SDIO) or sdiouart (Wi-Fi over
> SDIO, Bluetooth over UART). What we do now - simply replace the
> original sdiosdio firmware file with the one supplied by NXP [1] for sdiouart.
> 
> Of course, this is not clean, and by submitting this patch I would like to
> receive your comments regarding how it would be better to implement the
> strapping detection.
> 
> [1] https://github.com/NXP/imx-firmware/blob/lf-5.10.52_2.1.0/nxp/FwImage_8997_SD/sdiouart8997_combo_v4.bin
> 
> Francesco & Andrejs
> 
> ---
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 17 ++++++++++++++++-
>  drivers/net/wireless/marvell/mwifiex/sdio.h |  6 ++++++
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
> index bde9e4bbfffe..8670ded74c27 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -182,6 +182,9 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
>  	.host_int_rsr_reg = 0x4,
>  	.host_int_status_reg = 0x0C,
>  	.host_int_mask_reg = 0x08,
> +	.host_strap_reg = 0xF4,
> +	.host_strap_mask = 0x01,
> +	.host_strap_value = 0x00,

Do you have any documentation or sources (e.g., a vendor driver) that
describe this register? If we don't have documentation on what exactly
this register means, we might need to be a bit more conservative on
using it.

Previous thread:
https://lore.kernel.org/linux-wireless/87a6ejj2np.fsf@bang-olufsen.dk/
I guess this links to some driver sources with similar definitions?

Seems like we could still use a bit better naming/macros to explicitly
call these out as "UART" and "SDIO" options, instead of just
"alternate".

>  	.status_reg_0 = 0xE8,
>  	.status_reg_1 = 0xE9,
>  	.sdio_int_mask = 0xff,
> @@ -402,6 +405,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
>  
>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
>  	.firmware = SD8997_DEFAULT_FW_NAME,
> +	.firmware_alt_strap = SD8997_SDIOUART_FW_NAME,
>  	.reg = &mwifiex_reg_sd8997,
>  	.max_ports = 32,
>  	.mp_agg_pkt_limit = 16,
> @@ -536,6 +540,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
>  		struct mwifiex_sdio_device *data = (void *)id->driver_data;
>  
>  		card->firmware = data->firmware;
> +		card->firmware_alt_strap = data->firmware_alt_strap;
>  		card->reg = data->reg;
>  		card->max_ports = data->max_ports;
>  		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
> @@ -2439,6 +2444,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
>  	int ret;
>  	struct sdio_mmc_card *card = adapter->card;
>  	struct sdio_func *func = card->func;
> +	const char *firmware = card->firmware;
>  
>  	/* save adapter pointer in card */
>  	card->adapter = adapter;
> @@ -2455,7 +2461,15 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
>  		return ret;
>  	}
>  
> -	strcpy(adapter->fw_name, card->firmware);
> +	/* Select alternative firmware based on the strapping options */
> +	if (card->firmware_alt_strap) {
> +		u8 val;
> +		mwifiex_read_reg(adapter, card->reg->host_strap_reg, &val);
> +		if ((val & card->reg->host_strap_mask) == card->reg->host_strap_value)
> +			firmware = card->firmware_alt_strap;
> +	}
> +	strcpy(adapter->fw_name, firmware);
> +
>  	if (card->fw_dump_enh) {
>  		adapter->mem_type_mapping_tbl = generic_mem_type_map;
>  		adapter->num_mem_types = 1;
> @@ -3157,3 +3171,4 @@ MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
>  MODULE_FIRMWARE(SD8977_DEFAULT_FW_NAME);
>  MODULE_FIRMWARE(SD8987_DEFAULT_FW_NAME);
>  MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
> +MODULE_FIRMWARE(SD8997_SDIOUART_FW_NAME);
> diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
> index 5648512c9300..bfea4d5998b7 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.h
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
> @@ -39,6 +39,7 @@
>  #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
>  #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
>  #define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
> +#define SD8997_SDIOUART_FW_NAME "nxp/sdiouart8997_combo_v4.bin"

This isn't your main issue, but just because companies buy and sell IP
doesn't mean we'll change the firmware paths. Qualcomm drivers still use
"ath" prefixes, for one ;)

Personally, I'd still keep the mrvl/ path. But that might be up to Kalle
and/or linux-firmware.git maintainers.

Brian

>  
>  #define BLOCK_MODE	1
>  #define BYTE_MODE	0
