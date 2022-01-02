Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B802482A6E
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 08:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiABHIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 02:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiABHIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 02:08:34 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329DCC061574;
        Sat,  1 Jan 2022 23:08:34 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id p7so50426488ljj.1;
        Sat, 01 Jan 2022 23:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4pJHGx8Mv9IfGjeqKBn3sbftuPoFfBWcnCGgc1xztxQ=;
        b=G0eksPpTL0cBUAjxo9Uq/syqgZ+9CuQkn9g1+ODI1F5WuTU4/DoaLwjpuh2OigzdyZ
         6OHPRlUm75CZOV2/J0tyrQswqd7QbAABMVIwzEDce0zH1AT9hHXbDRBCUd4kYasn24Ht
         G8UNPFbRdBzBLt8CC6Zv1SU55AeZwlNd/29PjPqpIM8aD8R6iOmOyTk2e23wG0AZp5WZ
         Vs+XpH4X5p8olNWfcbkba68wy8Rs1MuO58A0vWMA39jS41H6+AnkpXEpKtoD1Dy30uk9
         ULQ18yF+7BoPRUSjec613wKU53k1KjaRAQ+RCUxRx1KcmtwLXUJWnWzWJ9UrkZby31OH
         2ReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4pJHGx8Mv9IfGjeqKBn3sbftuPoFfBWcnCGgc1xztxQ=;
        b=KuJ18D/vYehPU8eRm/Oxo9q8YoAk3+6uY8PilPKiHIpVMtldbLAH2rBULojncgKUXN
         d+m4vH1YIp1yUWQqw4iYIjtMSNO8oMq/C0cBG7bmw/olrrBx7Ybb65yMvLTaP1NFt/6B
         hfgyWRBoTW8pI6c+bprbNh7txRNvdDC5BeiCfmq3Jm82nOEryQeUJvmEY3iRPJOJ7SsE
         fnhRdJJY2YkakWeJf3mRS7Mq49slTWpWY9CfL6DJnLVciw4+bPqTlykCw9uuT8pZkpcb
         4QnuHEC/pUu0YuceFOb9qD85bl7Oq+oN/QGYWxjS/LevMgXAJHMWaTaJevbOZc5WhB5h
         768g==
X-Gm-Message-State: AOAM531/AufMA2F4BEK90uwZowGMY9XqPSB2kLN7gt5U5zIJTejCfxpr
        EyxQE/BSo7thtPgAdJyk4F5OAmASl24=
X-Google-Smtp-Source: ABdhPJzR1Z24rRNnRBmMEiZ9vuuUXv6kpIZiLr+j7LGf6GuFK3Ni7ZIx2WNCsviwkuU8UavVhkBIyw==
X-Received: by 2002:a2e:b5a8:: with SMTP id f8mr36334292ljn.130.1641107312509;
        Sat, 01 Jan 2022 23:08:32 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id l2sm2317980lja.51.2022.01.01.23.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 23:08:32 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
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
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <c79d67af-2d4c-2c9d-bb7d-630faf9de175@gmail.com>
Date:   Sun, 2 Jan 2022 10:08:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211226153624.162281-4-marcan@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

26.12.2021 18:35, Hector Martin пишет:
> +static void brcm_free_alt_fw_paths(const char **alt_paths)
> +{
> +	int i;
> +
> +	if (!alt_paths)
> +		return;
> +
> +	for (i = 0; alt_paths[i]; i++)
> +		kfree(alt_paths[i]);
> +
> +	kfree(alt_paths);
>  }
>  
>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>  				     struct brcmf_fw *fwctx)
>  {
>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
> -	int ret;
> +	int ret, i;
>  
>  	/* Files can be board-specific, first try a board-specific path */
>  	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
> -		char *alt_path;
> +		const char **alt_paths = brcm_alt_fw_paths(cur->path, fwctx);
>  
> -		alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
> -		if (!alt_path)
> +		if (!alt_paths)
>  			goto fallback;
>  
> -		ret = request_firmware(fw, alt_path, fwctx->dev);
> -		kfree(alt_path);
> -		if (ret == 0)
> -			return ret;
> +		for (i = 0; alt_paths[i]; i++) {
> +			ret = firmware_request_nowarn(fw, alt_paths[i], fwctx->dev);
> +			if (ret == 0) {
> +				brcm_free_alt_fw_paths(alt_paths);
> +				return ret;
> +			}
> +		}
> +		brcm_free_alt_fw_paths(alt_paths);
>  	}
>  
>  fallback:
> @@ -641,6 +663,9 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
>  	struct brcmf_fw *fwctx = ctx;
>  	int ret;
>  
> +	brcm_free_alt_fw_paths(fwctx->alt_paths);
> +	fwctx->alt_paths = NULL;

It looks suspicious that fwctx->alt_paths isn't zero'ed by other code
paths. The brcm_free_alt_fw_paths() should take fwctx for the argument
and fwctx->alt_paths should be set to NULL there.

On the other hand, I'd change the **alt_paths to a fixed-size array.
This should simplify the code, making it easier to follow and maintain.

-	const char **alt_paths;
+	char *alt_paths[BRCM_MAX_ALT_FW_PATHS];

Then you also won't need to NULL-terminate the array, which is a common
source of bugs in kernel.
