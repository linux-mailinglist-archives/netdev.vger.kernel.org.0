Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B09482A4C
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiABGiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiABGiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:38:17 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695EAC061574;
        Sat,  1 Jan 2022 22:38:17 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id u22so51071452lju.7;
        Sat, 01 Jan 2022 22:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RY/U1mpEKxFZojyoZ97q8tWXTVzCIHhjBCHLYYMtIr8=;
        b=nHsU7FKiC1V5YYqkluEY6hG4KFarKP2yzppwyAiIUjCKH4hfRxFWIPkkwtpVpBAWun
         qviHdevED9XzS+i/3x9khk5Cs8Mtm7p6N4mdiOAGwkUTkAoN1xZlmU1VvYT3wGiKn3Ms
         MfVs6LjuVO4ucTjgq3cF3NJA46bgiVZgTyW5M2ExUSbOVdQ/yD25oH5mCNxpr0eW18km
         lX16cASexynWPol0RAQ9y6JRRK384Sjr0eeURq62k6buWgHIDj40traQnrPd3bn0Npej
         DiMJCbkqkDRcswJSJS/Z/oqDS0ExkWOOPqToxroUBTbbOcs4TjnAm9NpAXC+ECVPj9bG
         WjZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RY/U1mpEKxFZojyoZ97q8tWXTVzCIHhjBCHLYYMtIr8=;
        b=eCSM/7YpN908ohBMmnFD5a8/XJw7yYM7PI0OuClZjGGEgRqp8zPlQaF4rbjsK7hxIk
         1K/o0Cp0cD6AVQADxWd+2Pp+Prv8uVukY4NubxV6fq2qpQniylSpbnQ5NFNFIpfOXvwX
         qX15SXIDxG2c+024PYVcLxVkHk3axSjbM+662xlfUqDgDn8sezDrHW7uNDxXdOk7YEXg
         pSwxf/gFn6zcF+0SFFLXmTj1GzAJMfxXrSQzepxRKVb9C74CbsneC4b6RHI/0HxXt2TR
         cqa1XKf8lKdkOCp4PV4RaNm0p3vNUkA1EALZ1186tEWtwNHcB0YvhzQT55HIPwO5Z6SD
         c1vg==
X-Gm-Message-State: AOAM531ZIbXN5cU5FmBrBcdpsc2+UVWNHjjdD2tj5VvjpSRr1vRRZekp
        +the8XleZxd0ZuvJ4VDLIM4=
X-Google-Smtp-Source: ABdhPJya1AJlz6j758QzPpJT+m/4CvnYx+/OXQX5TwjL0M+LEGylW6FcMTook3yFztb7fsQNkEY2jw==
X-Received: by 2002:a05:651c:d5:: with SMTP id 21mr31546294ljr.433.1641105495746;
        Sat, 01 Jan 2022 22:38:15 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id p21sm2642428lfu.154.2022.01.01.22.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jan 2022 22:38:15 -0800 (PST)
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
Message-ID: <17b997d2-708e-4ed7-7e27-1c3e0cd5c428@gmail.com>
Date:   Sun, 2 Jan 2022 09:38:13 +0300
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
> Apple platforms have firmware and config files identified with multiple
> dimensions. We want to be able to find the most specific firmware
> available for any given platform, progressively trying more general
> firmwares.
> 
> First, add support for having multiple alternate firmware paths.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../broadcom/brcm80211/brcmfmac/firmware.c    | 73 ++++++++++++++-----
>  1 file changed, 55 insertions(+), 18 deletions(-)

...
> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
> +static const char **brcm_alt_fw_paths(const char *path, const char *board_type)
...
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

The brcm_alt_fw_paths() takes "board_type" argument, while you're
passing the "fwctx" to it. This patch doesn't compile.

If this code is changed by a further patch, then please use "git rebase
--exec" to compile-test all the patches.

drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c: In function
‘brcmf_fw_request_firmware’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:642:71:
error: passing argument 2 of ‘brcm_alt_fw_paths’ from incompatible
pointer type [-Werror=incompatible-pointer-types]
  642 |                 const char **alt_paths =
brcm_alt_fw_paths(cur->path, fwctx);
      |
      ^~~~~
      |
      |
      |
      struct brcmf_fw *
drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:597:69:
note: expected ‘const char *’ but argument is of type ‘struct brcmf_fw *’
  597 | static const char **brcm_alt_fw_paths(const char *path, const
char *board_type)
      |
~~~~~~~~~~~~^~~~~~~~~~
drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c: In function
‘brcmf_fw_get_firmwares’:
drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:752:59:
error: passing argument 2 of ‘brcm_alt_fw_paths’ from incompatible
pointer type [-Werror=incompatible-pointer-types]
  752 |         fwctx->alt_paths = brcm_alt_fw_paths(first->path, fwctx);
      |                                                           ^~~~~
      |                                                           |
      |                                                           struct
brcmf_fw *
drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:597:69:
note: expected ‘const char *’ but argument is of type ‘struct brcmf_fw *’
  597 | static const char **brcm_alt_fw_paths(const char *path, const
char *board_type)
      |
~~~~~~~~~~~~^~~~~~~~~~
cc1: some warnings being treated as errors
