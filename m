Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6AE4894CB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242616AbiAJJLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242635AbiAJJLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:11:36 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E2AC06175A
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:11:35 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id e17so2100212pgg.6
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:in-reply-to;
        bh=o2VcgtUdTfP+SKGCC+6IyqchzHuOxkB2QwstzpHhVQo=;
        b=NUMWoAgnMW84MjQwzg/iZ4lzM1gyaBrOp5egCt7TvZvsPbQMMpqCe472gEvyHA2rST
         2f6XMbE5XtM9j468m7wrM7ffxwx13SJgE/5CCXDo74LxGDhzcWhr36/i2kkhBOm1FFs1
         DlkxGA6tFZ7/5Wb3ubVxf47Z+yTjVt/um4hqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:in-reply-to;
        bh=o2VcgtUdTfP+SKGCC+6IyqchzHuOxkB2QwstzpHhVQo=;
        b=y1q0wDrwlvFTf8xmQN0wbewuJrCbeRDl1lOUOuWEuCSXJww7s9ojHU9kMDUOEKvocJ
         ywdwoVsC3O0TN6VzDQ7CNoAw0/30cxz1kYwNznMzDuOXo5kKNCmfgHpVqnD9BwshR73J
         GFa7BVBQos+Ih2yO7N2p/Xo1i8SDBRmSqeEXnuxR6sPGVvMmPqFikS9T4EjqCNl46mep
         XykOP7FAPyZl3DbwJVrNeQYkSEYOxFu4qeg/wE2Q1UP5zIiL5WD9f50P7VQEHpbaVMsi
         8eGTuFw894pB3b8A2jHpaDci6MYJjHohAkfrLQdnhW1Qh8+O9ziN3TCR0HKz4giaNI3u
         EMkg==
X-Gm-Message-State: AOAM533INKp4Qhp0jDqB6ZcU8oXSc6QCTTnHGmf7uRU7cuOMu+Dy6xHy
        QEwjZhHRAfC/irAgr4SNn/yjdg==
X-Google-Smtp-Source: ABdhPJxuoNbIeiC0O2Q0xOPuJjQlFJxTwZPLgkmkZlLrk9vX8JRAFN0Ger+SvJETghXmiVvI5Sfe1A==
X-Received: by 2002:a05:6a00:1386:b0:4ba:b454:70bc with SMTP id t6-20020a056a00138600b004bab45470bcmr74304468pfg.19.1641805895101;
        Mon, 10 Jan 2022 01:11:35 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id p6sm4957976pgl.16.2022.01.10.01.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 01:11:34 -0800 (PST)
Message-ID: <d72bf3e4-1a49-d354-9439-5f52334d2698@broadcom.com>
Date:   Mon, 10 Jan 2022 10:11:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2 16/35] brcmfmac: acpi: Add support for fetching Apple
 ACPI properties
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
        Dmitry Osipenko <digetx@gmail.com>
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
 <20220104072658.69756-17-marcan@marcan.st>
In-Reply-To: <20220104072658.69756-17-marcan@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002fa86d05d536b9a1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002fa86d05d536b9a1
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/4/2022 8:26 AM, Hector Martin wrote:
> On DT platforms, the module-instance and antenna-sku-info properties
> are passed in the DT. On ACPI platforms, module-instance is passed via
> the analogous Apple device property mechanism, while the antenna SKU
> info is instead obtained via an ACPI method that grabs it from
> non-volatile storage.
> 
> Add support for this, to allow proper firmware selection on Apple
> platforms.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>   .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
>   .../broadcom/brcm80211/brcmfmac/acpi.c        | 47 +++++++++++++++++++
>   .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
>   .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
>   4 files changed, 59 insertions(+)
>   create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
> new file mode 100644
> index 000000000000..2b1a4448b291
> --- /dev/null
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: ISC
> +/*
> + * Copyright The Asahi Linux Contributors
> + */
> +
> +#include <linux/acpi.h>
> +#include "debug.h"
> +#include "core.h"
> +#include "common.h"
> +
> +void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
> +		      struct brcmf_mp_device *settings)
> +{
> +	acpi_status status;
> +	const union acpi_object *o;
> +	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
> +
> +	if (!adev)
> +		return;
> +
> +	if (!ACPI_FAILURE(acpi_dev_get_property(adev, "module-instance",
> +						ACPI_TYPE_STRING, &o))) {
> +		brcmf_dbg(INFO, "ACPI module-instance=%s\n", o->string.pointer);
> +		settings->board_type = devm_kasprintf(dev, GFP_KERNEL,
> +						      "apple,%s",
> +						      o->string.pointer);
> +	} else {
> +		brcmf_dbg(INFO, "No ACPI module-instance\n");

Do you need to obtain the antenna-sku when there is no module-instance?

> +	}
> +
> +	status = acpi_evaluate_object(adev->handle, "RWCV", NULL, &buf);

Can you clarify what the above does? What does the "RWCV" mean?

> +	o = buf.pointer;
> +	if (!ACPI_FAILURE(status) && o && o->type == ACPI_TYPE_BUFFER &&
> +	    o->buffer.length >= 2) {
> +		char *antenna_sku = devm_kzalloc(dev, 3, GFP_KERNEL);
> +
> +		memcpy(antenna_sku, o->buffer.pointer, 2);
> +		brcmf_dbg(INFO, "ACPI RWCV data=%*phN antenna-sku=%s\n",
> +			  (int)o->buffer.length, o->buffer.pointer,
> +			  antenna_sku);
> +
> +		settings->antenna_sku = antenna_sku;
> +	} else {
> +		brcmf_dbg(INFO, "No ACPI antenna-sku\n");
> +	}
> +}

--0000000000002fa86d05d536b9a1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
XSlOP9s1dqWlRRnnNxV7BVC87lkKKy0+1M2DOF6qRYQlnW4EfOyCToYLAG5zeV+AjepMoX6J9bUz
yj4BlDtwH4HFjaRIlPPbdLshUA54/tV84x8woATuLGBq+hTZEpkZAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFKb+3b9pz8zo
0QsCHGb/p0UrBlU+MA0GCSqGSIb3DQEBCwUAA4IBAQCHisuRNqP0NfYfG3U3XF+bocf//aGLOCGj
NvbnSbaUDT/ZkRFb9dQfDRVnZUJ7eDZWHfC+kukEzFwiSK1irDPZQAG9diwy4p9dM0xw5RXSAC1w
FzQ0ClJvhK8PsjXF2yzITFmZsEhYEToTn2owD613HvBNijAnDDLV8D0K5gtDnVqkVB9TUAGjHsmo
aAwIDFKdqL0O19Kui0WI1qNsu1tE2wAZk0XE9FG0OKyY2a2oFwJ85c5IO0q53U7+YePIwv4/J5aP
OGM6lFPJCVnfKc3H76g/FyPyaE4AL/hfdNP8ObvCB6N/BVCccjNdglRsL2ewttAG3GM06LkvrLhv
UCvjMYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMMSnY
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCc4lcvcKQgwiiSBg20
yHBGUkMDCHExZkkjFDwfZXoTeTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMTAwOTExMzVaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAZlaJ9env3lytfqS+vFL09YEzlMBu7cGAbd/1
mEShEiyZzzXQG0Pzfm4NN42Gih9NeGaCyxcBzaPbGaM4IPmMngKuF30swQdwEx43OiWhygqQyYQz
Iyykopo/FeEklc8dJuLSAE/vf/OWRH52u/+hE9fxZ6IdjHlsmlJMW0jE3FoeFE8f2LoE1EDQjgBT
JYo9KC21wcIjKj4S7CaPBXwE81X/W3tX4wB+LOEPI0eNjJ0fgQ0wEuwt12FB1KC+A1jTpJ0QezbF
t9d4FLApUNdwyvLRJ04ahzAQDgbsDW0PVE8I/yE7UbNhqryY0UQLEMmlvfxHSAjjYoizKiKN9RzF
TA==
--0000000000002fa86d05d536b9a1--
