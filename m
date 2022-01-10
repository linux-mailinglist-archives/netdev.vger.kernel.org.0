Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F8B489834
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbiAJMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245180AbiAJMCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 07:02:18 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA9EC06175B
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:02:17 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z3so11586373plg.8
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 04:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to;
        bh=8H/34KiL9PGdpbLXQkyW4vd/RkD6CcHb24obrf4k96A=;
        b=Pt23gzvLUs8touHOCZcw1j4UZGjNgOBkTPljrBMIG3slzjw5C9U/eX6nqCxek9Zwms
         poF6GRfv7eIuXowhCkNKA2QAiJ6yOa8VavrfT7YEYrr6HYiGAeNr5PlE2x/ZD7v5Gp50
         UE81G0JDvdT0UBtwUnd2o1BTHQnJuy7DpYWm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to;
        bh=8H/34KiL9PGdpbLXQkyW4vd/RkD6CcHb24obrf4k96A=;
        b=awFkWnzR+XFBx3qOvty0eEhu93XIUXxPWd9TrRWS7PyuPuTSvBul4VhCA9jppx32Vh
         k++BIUmS4FSZ4J+EjPDxPOyLauIifE/fdJTbzU+SkWP8fm1hIyGYNfpNOsv8mdR0i6zg
         MxslwyPk6HfXLaP3GiOBvQk3pG4fLPrsXkW8Abpu5V6xv+qL07PRBL1uV5LRghSjK2sm
         qFEMxDC5OIu/Q3qEVZyeBKKPdsFSw1tlSP6xlt2WUm+iM25i6xyWF1ToWlqks9dM9u7M
         IY/aQde/OoWzv1Lrw9NnXR6GT/bhWi/SaqFEEohu/29/Rqwmn78x7Q3jrJ5oPeoWt6hk
         UNnw==
X-Gm-Message-State: AOAM532CYVv6tZZETs7aI0Um2Utj3hB3Z++/b7rUTYBIoUoaim8o/7h0
        2J6Rv41FEA5ZpaXtIKPj/H2prw==
X-Google-Smtp-Source: ABdhPJwpfi2x//kTn5qs9QhtBs43L9cZ/U4cVcMBKdaNYw7luORWgC6LvKRBO4yFOXt8zrsfFNoBdw==
X-Received: by 2002:a17:902:da8c:b0:148:a2e8:2759 with SMTP id j12-20020a170902da8c00b00148a2e82759mr74062202plx.96.1641816136437;
        Mon, 10 Jan 2022 04:02:16 -0800 (PST)
Received: from [192.168.178.136] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id t27sm7203261pfg.41.2022.01.10.04.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 04:02:15 -0800 (PST)
Message-ID: <ba7fa453-2bc0-cba4-e7f2-48e2e94aa408@broadcom.com>
Date:   Mon, 10 Jan 2022 13:02:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 20/35] brcmfmac: pcie: Perform correct BCM4364 firmware
 selection
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
 <20220104072658.69756-21-marcan@marcan.st>
 <3a957aa1-07f9-dff2-563e-656fffa0db6c@broadcom.com>
 <fc945ba3-94b7-773d-4537-3408b10bfe92@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <fc945ba3-94b7-773d-4537-3408b10bfe92@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009f674605d5391b44"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009f674605d5391b44
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/2022 12:20 PM, Hector Martin wrote:
> On 2022/01/10 18:12, Arend van Spriel wrote:
>> On 1/4/2022 8:26 AM, Hector Martin wrote:
>>> This chip exists in two revisions (B2=r3 and B3=r4) on different
>>> platforms, and was added without regard to doing proper firmware
>>> selection or differentiating between them. Fix this to have proper
>>> per-revision firmwares and support Apple NVRAM selection.
>>>
>>> Revision B2 is present on at least these Apple T2 Macs:
>>>
>>> kauai:    MacBook Pro 15" (Touch/2018-2019)
>>> maui:     MacBook Pro 13" (Touch/2018-2019)
>>> lanai:    Mac mini (Late 2018)
>>> ekans:    iMac Pro 27" (5K, Late 2017)
>>>
>>> And these non-T2 Macs:
>>>
>>> nihau:    iMac 27" (5K, 2019)
>>>
>>> Revision B3 is present on at least these Apple T2 Macs:
>>>
>>> bali:     MacBook Pro 16" (2019)
>>> trinidad: MacBook Pro 13" (2020, 4 TB3)
>>> borneo:   MacBook Pro 16" (2019, 5600M)
>>> kahana:   Mac Pro (2019)
>>> kahana:   Mac Pro (2019, Rack)
>>> hanauma:  iMac 27" (5K, 2020)
>>> kure:     iMac 27" (5K, 2020, 5700/XT)
>>>
>>> Fixes: 24f0bd136264 ("brcmfmac: add the BRCM 4364 found in MacBook Pro 15,2")
>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>> ---
>>>    .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 11 +++++++++--
>>>    1 file changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> index 87daabb15cd0..e4f2aff3c0d5 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> @@ -54,7 +54,8 @@ BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
>>>    BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>>>    BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>>>    BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
>>> -BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
>>> +BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
>>> +BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
>>
>> would this break things for people. Maybe better to keep the old name
>> for the B2 variant.
> 
> Or the B3 variant... people have been using random copied firmwares with
> the same name, I guess. Probably even the wrong NVRAMs in some cases.
> And then I'd have to add a special case to the firmware extraction
> script to rename one of these two to not include the revision...
> 
> Plus, newer firmwares require the random blob, so this only ever worked
> with old, obsolete firmwares... which I think have security
> vulnerabilities (there was an AWDL exploit recently IIRC).
> 
> Honestly though, there are probably rather few people using upstream
> kernels on T2s. Certainly on the MacBooks, since the keyboard/touchpad
> aren't supported upstream yet... plus given that there was never any
> "official" firmware distributed under the revision-less name, none of
> this would work out of the box with upstream kernels anyway.
> 
> FWIW, I've been in contact with the t2linux folks and users have been
> testing this patchset (that's how I got it tested on all the chips), so
> at least some people are already aware of the story and how to get the
> firmware named properly :-)

Ok. When there is no brcmfmac4364-pcie.bin in linux-firmware repo we can 
safely rename.

>>> -	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFFF, 4364),
>>> +	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0x0000000F, 4364B2), /* 3 */
>>> +	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFF0, 4364B3), /* 4 */
>>
>> okay. so it is the numerical chip revision. If so, please drop that comment.
>>
> 
> I figured it would be useful to document this somewhere, since the
> alphanumeric code -> rev number mapping doesn't seem to be consistent
> from chip to chip, and we might have to add a new revision in the future
> for an existing chip (which would require knowing the rev for the old
> one). Do you have any ideas?

Indeed the alphanumeric code differs from chip to chip depending on how 
much respins are necessary and what type of respin. We start a 'a0' aka 
numeric rev 0. For minor fixes we increase the digit, but for major 
fixes or new functionality we move to the next letter whereas the 
numeric revision simply increases.

--0000000000009f674605d5391b44
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAfK5EiiyV1npyn1PC1
SjcDUOGpFT1lOonhkBimvUIKwTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjAxMTAxMjAyMTZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAFPEddhIgS0nS0XXEclvHZnF+39G7+Gh10Nm/
MgYig5DMcr6U2d3W8xW+oxcK+NhfT44AXgZujCNLAt0Wie479xu1HWo5VbM+ugRrIYjLg3y28f/H
TGq2i0meNwodhaI7jEYb/gGUQC5fVJw4pY545yBSJMf9DnC1loP+nPKFPqnXrST/aRJzkM74yepl
EdrA74aTeMEMC1p6zHalHThoKHQskmoEDprvfeM5BcrkORBqXbJi6JdYJHr3jySa9NYGsiACsgiW
4MtbrAGKVFuwRHSNVVc1KsvtC5BmPGKZYsDPA1Xbo1atzELXCVxLuyBJwdWbUNU7IMz7RsFE4qEi
qw==
--0000000000009f674605d5391b44--
