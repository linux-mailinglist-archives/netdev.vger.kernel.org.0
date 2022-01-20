Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714FC494A06
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbiATIuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiATIuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 03:50:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54685C06173F
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 00:50:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id g2so5002635pgo.9
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 00:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:from:to:cc
         :references:in-reply-to;
        bh=BfAmt/7HzAaMYDff+rsyYB8Vl3YqWdv+dUnGoUAvni8=;
        b=ZiaMXjIvLV4dotgxWCba2KKolGzSmSRkHn9xFjm/vyUCfPd9Ju6Obk0kfWjSu56V/i
         9aCx3F6VN2nqMX2NobizCojLksZQd9aUzVN0UwCppLgt4KpP99qUvF4Tdm/ZQoPojXjw
         lonAUlN2qQGSJE7v7bkVPcM4XgKKWCD+FvOA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :from:to:cc:references:in-reply-to;
        bh=BfAmt/7HzAaMYDff+rsyYB8Vl3YqWdv+dUnGoUAvni8=;
        b=ffvkBoyvacbHrDEMJy967gCQTb2IujqBuxFyEFcOajBoGVJdjK/Sun/gtqUUSWLqaQ
         f7ORm8Xx3eu8tv/A0RQpVMY+RjuwNH75p3dpy53fPwcIZMLafGw9OzQjal3V+aL9jEjS
         3EgrCk0+HKvq8C1HUPfMB8j75ex7VBACC62FhCsTVT4rdttYc8B9zSXRP+UUt4Tiplp7
         u5AoodMxnvtgNhOAyJ5etGzrgz4JXtc7Kvi3TAEU30SEKkSicgBSLiZ0B5hrCHDs4CE/
         7fccGhJXeX5lg3Y+k+tHFhcdqL2QFYb2bL553JAYdMWaxiqkJZmnda5J7HzaJayWaYty
         pK1w==
X-Gm-Message-State: AOAM530Af8mj94E/frY0RFTCqHBVE1d2HWw3OW2iijAddiast32OOUhq
        Lo1EDWiZD0LhIHXnUbxZpkA2Bg==
X-Google-Smtp-Source: ABdhPJzRWJsMfvdfUAnYf4q27etILPp3I11aDeBOPRbNvvn2QQ381bSHVUPeO8o557XlWnBQ/1Tvng==
X-Received: by 2002:a62:f90a:0:b0:4c6:7794:6f29 with SMTP id o10-20020a62f90a000000b004c677946f29mr880153pfh.1.1642668599772;
        Thu, 20 Jan 2022 00:49:59 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id d12sm2343441pfl.24.2022.01.20.00.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 00:49:58 -0800 (PST)
Message-ID: <5d949e1f-63f8-3dde-a7d0-1eab5d3030ec@broadcom.com>
Date:   Thu, 20 Jan 2022 09:49:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 22/35] brcmfmac: chip: Handle 1024-unit sizes for TCM
 blocks
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
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
 <20220104072658.69756-23-marcan@marcan.st>
 <ed387a90-586d-5071-baa6-bc66d4e7f22f@broadcom.com>
In-Reply-To: <ed387a90-586d-5071-baa6-bc66d4e7f22f@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000064c0d805d5ff962a"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000064c0d805d5ff962a
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/19/2022 1:36 PM, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> BCM4387 has trailing odd-sized blocks as part of TCM which have
>> their size described as a multiple of 1024 instead of 8192. Handle this
>> so we can compute the TCM size properly.

So that is the deal. Wish someone over here told me about that :-p Gave 
my blessing already, but do have some remarks.

> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../wireless/broadcom/brcm80211/brcmfmac/chip.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c 
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> index 713546cebd5a..cfa93e3ef1a1 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> @@ -212,8 +212,8 @@ struct sbsocramregs {
>>   #define    ARMCR4_TCBANB_MASK    0xf
>>   #define    ARMCR4_TCBANB_SHIFT    0
>> -#define    ARMCR4_BSZ_MASK        0x3f
>> -#define    ARMCR4_BSZ_MULT        8192

Instead of deleting can we leave it here and...

>> +#define    ARMCR4_BSZ_MASK        0x7f
>> +#define    ARMCR4_BLK_1K_MASK    0x200
>>   struct brcmf_core_priv {
>>       struct brcmf_core pub;
>> @@ -675,7 +675,8 @@ static u32 brcmf_chip_sysmem_ramsize(struct 
>> brcmf_core_priv *sysmem)
>>   }
>>   /** Return the TCM-RAM size of the ARMCR4 core. */
>> -static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
>> +static u32 brcmf_chip_tcm_ramsize(struct brcmf_chip_priv *ci,
>> +                  struct brcmf_core_priv *cr4)
> 
> Not sure why you add ci parameter here. It is not used below or am I 
> overlooking something.
> 
>>   {
>>       u32 corecap;
>>       u32 memsize = 0;
>> @@ -683,6 +684,7 @@ static u32 brcmf_chip_tcm_ramsize(struct 
>> brcmf_core_priv *cr4)
>>       u32 nbb;
>>       u32 totb;
>>       u32 bxinfo;
>> +    u32 blksize;
>>       u32 idx;
>>       corecap = brcmf_chip_core_read32(cr4, ARMCR4_CAP);
>> @@ -694,7 +696,12 @@ static u32 brcmf_chip_tcm_ramsize(struct 
>> brcmf_core_priv *cr4)
>>       for (idx = 0; idx < totb; idx++) {
>>           brcmf_chip_core_write32(cr4, ARMCR4_BANKIDX, idx);
>>           bxinfo = brcmf_chip_core_read32(cr4, ARMCR4_BANKINFO);
>> -        memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * ARMCR4_BSZ_MULT;
>> +        if (bxinfo & ARMCR4_BLK_1K_MASK)
>> +            blksize = 1024;
>> +        else
>> +            blksize = 8192;

... do following here instead:

		blksize = 8192;
		if (bxinfo & ARMCR4_BLK_1K_MASK)
			blksize >>= 3;

[not sure if mailreader is screwing with indentation or what]

>> +
>> +        memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * blksize;
>>       }
>>       return memsize;

--00000000000064c0d805d5ff962a
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCB2nE0rhkk2CtfnkMV4
c7aze/vK7ws5UFitWRLkfEYbCzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMjAwODUwMDBaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEACmVSJkdKWWA5HYFhU0iRAzqDaNzfohi92kxm
anAzxLhPgR8EC6lm27ke/z78hv9EaD4bcTuPccnHfLq4RHDlNRhQgAVUTA8nzIXdbelttXXYGe4l
sgtffZz/KoKdnGSs22l8pTJqSSKlQLrGaCcBmO3dyXOjB6j3QDKn4IQ+zFgly8aFCsjEGHcz+iAr
DLIdYxza4kPDE9PdK4zcbfH3zRi/fhZmUxJS3Egi/74dKApI+eBV2lPf3x6DM8aNbWcZrKFXThB+
DSyT/u4P9uxNatLQmUYVjjaIymz34nqLY5pIDaiMWBjUVm5iLwqyyNSE0zvHkvReAHo3w6LbCXv7
Yw==
--00000000000064c0d805d5ff962a--
