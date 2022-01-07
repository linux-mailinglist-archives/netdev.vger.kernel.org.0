Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F244872FD
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiAGGRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiAGGRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:17:37 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDA6C0611FD
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 22:17:37 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z9so18149241edm.10
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 22:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version;
        bh=9F5kW0QSxdMcAQ5knG1RWlAUQjiuJpDdFBM+50xVBL4=;
        b=alXG2p6erBo5DXoBYd0aJpi07ZRDsoY94kbaHmvIHr32aSsuDZkb7Qv4AlgRA1VPrq
         uflTbcpYdOoVZ3snYL7yZJIXy9fLamQJ9JgJ9FLSV1cQypuSCfWoT6WuQ2BclhWrkg+L
         dvBedSnUD4uCx6hBxV/Mv+mkzXicwoeHnpUuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version;
        bh=9F5kW0QSxdMcAQ5knG1RWlAUQjiuJpDdFBM+50xVBL4=;
        b=QK+qu5cGr0Y2cVH/awe9Q2S2Zez2WV07nISH311JkzJw70FgK6e7+CJoFo55COjvmj
         ykurYoN/udm0Reivw1AQUobqFfwqnGImHd88l9SChXqrTbY/XtFQF/eoqkeM3vpx5seg
         MjN/QwkqTWBqqxEfRNgveFxgZpyf/VetIAOa30giguyQxazWAPIq92Y6DuoHAcScZ5di
         9M5aMapy7tDgpRTpZp0th9gZazisJY1w2KI2/PV8SsC0qvPYzSs/GlKC0+6cOA6bPML8
         cFhBW1a1K60SiV8qooU7xnnnF2AIm/wz0ZVgi21CVK4lbDCXB9uU1BdGcSav0Y709iGG
         TCiQ==
X-Gm-Message-State: AOAM530e6wzw19hOIP0qU5vaiV4odpsxzFAY+xUxN92Po6qN0z6hq/+i
        g5muSYhE+gn34XZn+aVJNXUw9A==
X-Google-Smtp-Source: ABdhPJyWwOhoUPLI0/yPV5oN/xWJtyruLVlmPyg0if7y7Zxa3CNJVPvQEzM+Zgfl/XGDcC2T5iWgNQ==
X-Received: by 2002:a17:906:f01:: with SMTP id z1mr19743030eji.346.1641536255527;
        Thu, 06 Jan 2022 22:17:35 -0800 (PST)
Received: from [192.168.178.38] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id h18sm1641340edw.55.2022.01.06.22.17.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jan 2022 22:17:33 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
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
        "Chi-hsien Lin" <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
CC:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "Pieter-Paul Giesberts" <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>
Date:   Fri, 07 Jan 2022 07:17:32 +0100
Message-ID: <17e332f6860.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <25eaec8a-337e-78b7-1bc3-7224a0218501@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-7-marcan@marcan.st>
 <911f7e95-7d6a-1c7f-c8de-0d4e0c7b7238@broadcom.com>
 <25eaec8a-337e-78b7-1bc3-7224a0218501@marcan.st>
User-Agent: AquaMail/1.33.0 (build: 103300102)
Subject: Re: [PATCH v2 06/35] brcmfmac: firmware: Support passing in multiple board_types
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000069cbfc05d4f7f190"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000069cbfc05d4f7f190
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On January 7, 2022 5:02:13 AM Hector Martin <marcan@marcan.st> wrote:

> On 2022/01/06 21:16, Arend van Spriel wrote:
>> On 1/4/2022 8:26 AM, Hector Martin wrote:
>>> In order to make use of the multiple alt_path functionality, change
>>> board_type to an array. Bus drivers can pass in a NULL-terminated list
>>> of board type strings to try for the firmware fetch.
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>> ---
>>> .../broadcom/brcm80211/brcmfmac/firmware.c    | 35 ++++++++++++-------
>>> .../broadcom/brcm80211/brcmfmac/firmware.h    |  2 +-
>>> .../broadcom/brcm80211/brcmfmac/pcie.c        |  4 ++-
>>> .../broadcom/brcm80211/brcmfmac/sdio.c        |  2 +-
>>> 4 files changed, 27 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c 
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> index 7570dbf22cdd..054ea3ed133e 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> @@ -594,28 +594,39 @@ static int brcmf_fw_complete_request(const struct 
>>> firmware *fw,
>>> return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
>>> }
>>>
>>> -static int brcm_alt_fw_paths(const char *path, const char *board_type,
>>> +static int brcm_alt_fw_paths(const char *path, struct brcmf_fw *fwctx,
>>>   const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])
>>> {
>>> + const char **board_types = fwctx->req->board_types;
>>> + unsigned int i;
>>> char alt_path[BRCMF_FW_NAME_LEN];
>>> const char *suffix;
>>
>> [...]
>>
>>> + for (i = 0; i < BRCMF_FW_MAX_ALT_PATHS; i++) {
>>> + if (!board_types[i])
>>> +    break;
>>>
>>> - strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
>>> - strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
>>> - strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>>> + /* strip extension at the end */
>>> + strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
>>> + alt_path[suffix - path] = 0;
>>>
>>> - alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
>>> + strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
>>> + strlcat(alt_path, board_types[i], BRCMF_FW_NAME_LEN);
>>> + strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>>> +
>>> + alt_paths[i] = kstrdup(alt_path, GFP_KERNEL);
>>> + brcmf_dbg(TRACE, "FW alt path: %s\n", alt_paths[i]);
>>
>> Could use alt_path in the debug print thus avoiding additional array
>> access (working hard to find those nits to pick ;-) ).
>
> So you're saying my code is so good you have to resort to nits on this
> level to make it clear you read it, right? ;-)

Don't read too much into this :-p Actually never liked the alt_path 
approach, but didn't come up with a better solution.

Regards,
Arend




--00000000000069cbfc05d4f7f190
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAYcFW58B/BlKRVruQd
o3c4eFIPLUbBpCnsoLo9j5G7nDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMDcwNjE3MzVaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAidXHwMnc5XoFP/bxXMr3wC4BLHKdRZivgkGP
ltUkBToCJgaq4AYqdDN/7pUZCJui0u8l2vWXDNQmDW8sXaAGRX/gQKcNYzIJc3DDkvxailzY352B
2J0r4bhNVjtzN/ieqnf7/W3v2WmNSuwrKomD+77+6T6tiz5m4ipqw4LIMi7HcEV9AH5unKemQnaj
2eemU5EUcMROtxec77UfaF+jfYKv4iFlv2qMFwh6aJRW4mpR4VxFNIZ9bOZXOuOWqOXEOSCeDBHH
BAtkqQLDPLiwAK63M0MlpInZ+5UAfJ0dLZyqoy7J57iT3hMfs3O8t6saf41S2fsfqSqJZ53l00yg
6A==
--00000000000069cbfc05d4f7f190--
