Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278BC6441FD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbiLFLWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiLFLW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:22:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A9F26AC3
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:22:21 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso5854087pjh.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1/KopKWl3Jho3xxC0WTGEi7CEx18qropkP2WDjxVgHQ=;
        b=EZCUz/sey/wF3jN50J2HZ5aqjvCrLGwnEmJdlPLQIAKmIRGSlPTJX3h9KO96VtvcI/
         V005C7cI3tcCjbv8e/XRySOd66VjQ7f46fouuo7yOzvFT0bV472YE0+aUAUQcnkGs/G1
         Ucj3LYTiTFNcgd/RIlX1yfoDmV7zxL20PK87U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/KopKWl3Jho3xxC0WTGEi7CEx18qropkP2WDjxVgHQ=;
        b=RPqP9WzOu4gtVnPt/svmA9a00GHmEjeKiLb8wfvfVtf+NKrDFj3sd6nXm4bi1bxVN9
         hxfisOfR8z5Iz9S2vFrCQbU28xy6B/ydXaWRO973mnbu9s0wpDkdP9Bp0mMzXCtJ54DU
         0ko/h4M5CcE2Rm+t8PL+rO+qmzKYVfzSQ39X5ls8PbfMUBfXH0y6b+U7yfhVa8STsdQH
         TfWqA2u3TFZRsi++3W6sbTC7k+hK5GVvtS9+b1V6RaC+8LOPgAXIPN75RoQsiDhIieR8
         r2zT7LJoHa50+ouZiz+9WBnXowzUe67Euw8RxafWhn5qGoPqqaPN77xjCcC5X4segfb7
         SwVQ==
X-Gm-Message-State: ANoB5pkD6Uuqmw8MYluUSDChXBojwMZXt2uvbO0E2gX8q6sWtoRJm+rm
        UnPNuhkcAWYmYd0z6WrRCIV9cA==
X-Google-Smtp-Source: AA0mqf7mGeP55guWqrA/W+k8rpCwTRQ3kL2xgvD3g/YGOrAmii4h+zOtHwfqbscT8P3Tm6lFXa5q7Q==
X-Received: by 2002:a17:903:268f:b0:189:e28d:90fe with SMTP id jf15-20020a170903268f00b00189e28d90femr5715103plb.45.1670325741120;
        Tue, 06 Dec 2022 03:22:21 -0800 (PST)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id b4-20020a17090a8c8400b00218b32f6a9esm10833303pjo.18.2022.12.06.03.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 03:22:19 -0800 (PST)
Message-ID: <86aefe08-9f78-4afa-7d50-5c5a4ef87499@broadcom.com>
Date:   Tue, 6 Dec 2022 12:22:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Arend Van Spriel <aspriel@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
 <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
 <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> <87fse76yig.fsf@kernel.org>
 <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org> <87bkov6x1q.fsf@kernel.org>
 <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
 <28991d2d-d917-af47-4f5f-4e8183569bb1@linaro.org>
 <c83d7496-7547-2ab4-571a-60e16aa2aa3d@broadcom.com>
 <6e4f1795-08b5-7644-d1fa-102d6d6b47fb@linaro.org>
 <af489711-6849-6f87-8ea3-6c8216f0007b@broadcom.com>
 <62566987-6bd2-eed3-7c2f-ec13c5d34d1b@gmail.com>
 <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007c2d5b05ef2704c5"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007c2d5b05ef2704c5
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/6/2022 10:58 AM, Konrad Dybcio wrote:
> 
> 
> On 02/12/2022 20:28, Arend Van Spriel wrote:
>>
>>
>> On 12/2/2022 4:26 PM, Arend van Spriel wrote:
>>> On 12/2/2022 11:33 AM, Konrad Dybcio wrote:
>>>>
>>>>
>>>> On 1.12.2022 12:31, Arend van Spriel wrote:
>>>>> On 11/28/2022 3:40 PM, Konrad Dybcio wrote:
>>>>>>
>>>>>>
>>>>>> On 26.11.2022 22:45, Linus Walleij wrote:
>>>>>>> On Fri, Nov 25, 2022 at 1:25 PM Kalle Valo <kvalo@kernel.org> wrote:
>>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>>
>>>>>>>>> On 25.11.2022 12:53, Kalle Valo wrote:
>>>>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>>>>
>>>>>>>>>>> On 21.11.2022 14:56, Linus Walleij wrote:
>>>>>>>>>>>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio 
>>>>>>>>>>>> <konrad.dybcio@linaro.org> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> I can think of a couple of hacky ways to force use of 43596 
>>>>>>>>>>>>> fw, but I
>>>>>>>>>>>>> don't think any would be really upstreamable..
>>>>>>>>>>>>
>>>>>>>>>>>> If it is only known to affect the Sony Xperias mentioned then
>>>>>>>>>>>> a thing such as:
>>>>>>>>>>>>
>>>>>>>>>>>> if (of_machine_is_compatible("sony,xyz") ||
>>>>>>>>>>>>       of_machine_is_compatible("sony,zzz")... ) {
>>>>>>>>>>>>      // Enforce FW version
>>>>>>>>>>>> }
>>>>>>>>>>>>
>>>>>>>>>>>> would be completely acceptable in my book. It hammers the
>>>>>>>>>>>> problem from the top instead of trying to figure out itsy witsy
>>>>>>>>>>>> details about firmware revisions.
>>>>>>>>>>>>
>>>>>>>>>>>> Yours,
>>>>>>>>>>>> Linus Walleij
>>>>>>>>>>>
>>>>>>>>>>> Actually, I think I came up with a better approach by pulling 
>>>>>>>>>>> a page
>>>>>>>>>>> out of Asahi folks' book - please take a look and tell me 
>>>>>>>>>>> what you
>>>>>>>>>>> think about this:
>>>>>>>>>>>
>>>>>>>>>>> [1]
>>>>>>>>>>> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
>>>>>>>>>>> [2]
>>>>>>>>>>> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7
>>>>>>>
>>>>>>> Something in this direction works too.
>>>>>>>
>>>>>>> The upside is that it tells all operating systems how to deal
>>>>>>> with the firmware for this hardware.
>>>>>>>
>>>>>>>>>> Instead of a directory path ("brcm/brcmfmac43596-pcie") why 
>>>>>>>>>> not provide
>>>>>>>>>> just the chipset name ("brcmfmac43596-pcie")? IMHO it's 
>>>>>>>>>> unnecessary to
>>>>>>>>>> have directory names in Device Tree.
>>>>>>>>>
>>>>>>>>> I think it's common practice to include a full 
>>>>>>>>> $FIRMWARE_DIR-relative
>>>>>>>>> path when specifying firmware in DT, though here I left out the 
>>>>>>>>> board
>>>>>>>>> name bit as that's assigned dynamically anyway. That said, if 
>>>>>>>>> you don't
>>>>>>>>> like it, I can change it.
>>>>>>>>
>>>>>>>> It's just that I have understood that Device Tree is supposed to
>>>>>>>> describe hardware and to me a firmware directory "brcm/" is a 
>>>>>>>> software
>>>>>>>> property, not a hardware property. But this is really for the 
>>>>>>>> Device
>>>>>>>> Tree maintainers to decide, they know this best :)
>>>>>>>
>>>>>>> I would personally just minimize the amount of information
>>>>>>> put into the device tree to be exactly what is needed to find
>>>>>>> the right firmware.
>>>>>>>
>>>>>>> brcm,firmware-compatible = "43596";
>>>>>>>
>>>>>>> since the code already knows how to conjure the rest of the string.
>>>>>>>
>>>>>>> But check with Rob/Krzysztof.
>>>>>>>
>>>>>>> Yours,
>>>>>>> Linus Walleij
>>>>>>
>>>>>> Krzysztof, Rob [added to CC] - can I have your opinions?
>>>>>
>>>>> I tried catching up on this thread. Reading it I am not sure what 
>>>>> the issue is, but I am happy to dive in. If you can provide a boot 
>>>>> log with brcmfmac loaded with module parameter 'debug=0x1416' I can 
>>>>> try and make sense of the chipid/devid confusion.
>>>>
>>>> Hope this helps, thanks! https://hastebin.com/xidagekuge.yaml
>>>
>>> It does to some extent. It is basically a 4359 revision 9:
>>>
>>> [   25.898782] brcmfmac: brcmf_chip_recognition found AXI chip: 
>>> BCM4359/9
>>>
>>> The 4359 entry in pcie.c is applicable for revision 0 and higher 
>>> (doubtful but that is in the code):
>>>
>>>      BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
>>>
>>> We need to change the mask above to 0x000001FF and add a new entry 
>>> with mask 0xFFFFFE00. All we need is come up with a reasonable 
>>> firmware filename. So can you run the strings command on the firmware 
>>> you use:
>>>
>>> $ strings fw.bin | tail -1
>>>
>>> and let me know the output.
>>
>> Actually realized you already provided a URL to the repo containing 
>> the firmware you used. So I had a look and it shows:
>>
>> 43596a0-roml/pcie-ag-apcs-pktctx-proptxstatus-ampduhostreorder-lpc-die3-olpc-pspretend-mfp-ltecx-clm_43xx_somc_mimo-phyflags-txpwrctrls-dpo Version: 9.75.119.15 (r691661) CRC: a6cf427b Date: Fri 2017-03-24 13:24:25 KST Ucode Ver: 1060.20542 FWID: 01-e4abc35c
>>
>> However, from firmware perspective this is equivalent to 4359c0 so I 
>> would suggest the change below.
>>
>> Let me know if that works.
> Sorry for the late reply.
> 
> Yes, it does seem to work just fine! The kernel now looks for 
> brcm/brcmfmac4359c-pcie.sony,kagura-row.bin as we would expect.
> 
> Could you submit this patch below to supersede my one?

I have no problem when you include this patch in yours and submit it to 
the linux-wireless list.

Regards,
Arend

--0000000000007c2d5b05ef2704c5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2Gzj3QNJRLsZu1TLyOyBBIr/BE7UiY3RabgRzknBGAPmzhS+fmyM8OtM5BYBsFBrSUFtZZO2p/tf
Nbc24J2zf2peoZ8MK+7WQqummYlOnz+FyDkA9EybeNMcS5C+xi/PAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFIikAXd8CEtv
ZbDflDRnf3tuStPuMA0GCSqGSIb3DQEBCwUAA4IBAQCdS5XCYx6k2GGZui9DlFsFm75khkqAU7rT
zBX04sJU1+B1wtgmWTVIzW7ugdtDZ4gzaV0S9xRhpDErjJaltxPbCylb1DEsLj+AIvBR34caW6ZG
sQk444t0HPb29HnWYj+OllIGMbdJWr0/P95ZrKk2bP24ub3ZP/8SyzrohfIba9WZKMq6g2nTLZE3
BtkeSGJx/8dy0h8YmRn+adOrxKXHxhSL8BNn8wsmIZyYWe6fRcBtO3Ks2DOLyHCdkoFlN8x9VUQF
N2ulEgqCbRKkx+qNirW86eF138lr1gRxzclu/38ko//MmkAYR/+hP3WnBll7zbpIt0jc9wyFkSqH
p8a1MYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMTv1t
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCClzTnajM2G6jjjfY1v
+REWhAm3O3shk6/8jCyIXJ91eDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjEyMDYxMTIyMjFaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAgAP3YQRwxEI90GXOw+i7FlAKyhc6nKEb73QV
jbPj+WcS87o9cN1uxsFi2srEsJKL24xGHBMe5N9HW5jV3hPjHdSeXeladsP0S5cdUqE6Z64yG7ho
2Vv3YNG7w7CJDFblpO3SBen+KswM189pFjtqfgyshR/ESO3Nf4dz7w0jrccYPExnYZLkfAk94xVH
tkJiuT8b5ZgZSobp6iqT2skIKlOxPV97YxgPzPHsEeZSaD5825n4nm/1tlTl335UdB3ZTUFOuwfw
kfHVvFr3qqdYbGWbtbgW/iCAe8zSYAKL5mmRHQBMKIAWYnz7XSAtP6Tn7dB0wK0aPtTFAivQbqiw
kw==
--0000000000007c2d5b05ef2704c5--
