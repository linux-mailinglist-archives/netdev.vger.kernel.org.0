Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24A483E12
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiADI1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiADI1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:27:00 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81129C061761;
        Tue,  4 Jan 2022 00:27:00 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id by39so59501622ljb.2;
        Tue, 04 Jan 2022 00:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vl2+K30hIBppyx7gf5vYs0vg7twk5+LRUR5dzc5wH34=;
        b=JprZSpCJ4bfg/fEV7ERvLTNNu1WG5WMKWkq4xHGZbh6Quez/KZ50JRMFwyQyvCzuhe
         j6ZpECsfs6ax86zAx75HCGBb7BQOdy9e8FiJ+0QHK0WOnhx8//w7VjNylR0V+bNM1o9O
         vhjGC3caKqVwPwUe8uGdq17rqzETXYlJEk28Rw/caahdAQQ2H63CHzLCFe2v5zAfjerQ
         dvmv9EtnZhK7ldwsqlEMrT3NRFIEgfFgVrUMzqNs1aS7o2qaijC3XW7C0grA4HZVpA+Y
         vMrbGzAys79FBPhTBSYC/eVgqNYCdMx8QAEvUbWegUJjnemxvr9FtuqwNpPThTDlYg1I
         32oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vl2+K30hIBppyx7gf5vYs0vg7twk5+LRUR5dzc5wH34=;
        b=G9GnSZF1iAiCHP4+cb4CALmJQ7p+LQREfYSiMZS+AvRt7FjLwQ/U/Nfrz1RQH/672A
         Hg80Yo8QfbhwbUh3Mm84cRb1hwGzyki2cG8yK+dxFbkNhGW6BVjnEyhy3FD2YlgsYX6S
         0OCPz6B4KgmWSZSsn+g6C1U+LJyWLnNb2RUXm3p1bvm/pKjfSL2SQGNta9CG6WuX4yfu
         C3tZR3pYoTKS5T2eNBDmrrJOB5YD/OwzusN2KXJRiRXY/kI+AvUjSQF6wNbWhSPn0EEX
         A1zPoyUagItcSO5jo6GuMsPht7iEUUNTbVXmvdS0FsU0RiiNXdqe2gfR/4UuJVOa3wlV
         aOng==
X-Gm-Message-State: AOAM532hikKqzYfvj7eX8RZ507vJ0d2PqaT//tZ5AKnb090EtGZshQyf
        BO1ZcrEZVwq9HzmCNhsrbtE=
X-Google-Smtp-Source: ABdhPJwN4wMdxUZ9jWeCOrza7QHw/N8ibrejGlnER2ABU8kOT4o25zd9EtdVDJJGT+R75DxSepdxvQ==
X-Received: by 2002:a2e:3508:: with SMTP id z8mr34664796ljz.37.1641284818802;
        Tue, 04 Jan 2022 00:26:58 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id k9sm1945647ljq.33.2022.01.04.00.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 00:26:58 -0800 (PST)
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt
 paths
To:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-5-marcan@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com>
Date:   Tue, 4 Jan 2022 11:26:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104072658.69756-5-marcan@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

04.01.2022 10:26, Hector Martin пишет:
> Apple platforms have firmware and config files identified with multiple
> dimensions. We want to be able to find the most specific firmware
> available for any given platform, progressively trying more general
> firmwares.
> 
> First, add support for having multiple alternate firmware paths.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 75 ++++++++++++++-----
>  .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +
>  2 files changed, 59 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 0497b721136a..7570dbf22cdd 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -427,6 +427,8 @@ void brcmf_fw_nvram_free(void *nvram)
>  struct brcmf_fw {
>  	struct device *dev;
>  	struct brcmf_fw_request *req;
> +	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
> +	int alt_index;

unsigned int

>  	u32 curpos;
>  	void (*done)(struct device *dev, int err, struct brcmf_fw_request *req);
>  };
> @@ -592,14 +594,18 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
>  	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
>  }
>  
> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])>  {
>  	char alt_path[BRCMF_FW_NAME_LEN];
>  	const char *suffix;
>  
> +	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
> +					BRCMF_FW_MAX_ALT_PATHS));
You don't need to use array_size() since size of a fixed array is
already known.

memset(alt_paths, 0, sizeof(alt_paths));

...
> +static void
> +brcm_free_alt_fw_paths(const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
> +{
> +	unsigned int i;
> +
> +	for (i = 0; alt_paths[i]; i++)

What if array is fully populated and there is no null in the end? Please
don't do this, use BRCMF_FW_MAX_ALT_PATHS or ARRAY_SIZE().

> +		kfree(alt_paths[i]);
>  }
>  
>  static int brcmf_fw_request_firmware(const struct firmware **fw,
> @@ -617,19 +634,25 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
>  {
>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>  	int ret;
> +	unsigned int i;

Keep reverse Xmas tree coding style.

...
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
> @@ -11,6 +11,8 @@
>  
>  #define BRCMF_FW_DEFAULT_PATH		"brcm/"
>  
> +#define BRCMF_FW_MAX_ALT_PATHS	8

Two tabs are needed here.
