Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7D63E9CD
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLAGSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiLAGSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:18:41 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17437AB001
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 22:18:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vp12so1791622ejc.8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 22:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EMhhOqwyAWZpywfYHqTZF0ycVlPQkx6a8R1gls/4ya8=;
        b=LQv+nB6lSqgjHfUewjozXsfTuy1euk+lLyoVsXhgALUelE3zG/HsnIfTdhADqLOCpO
         geffGPy91L8stqLkBpC/JaJmTBcZG0wV0fR3oHVmwin6EOHPBv3TsExMseiyVN9GX0PS
         36tYybWreGg62x+0bI6Fj8F/oEZtj5/AG53r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMhhOqwyAWZpywfYHqTZF0ycVlPQkx6a8R1gls/4ya8=;
        b=IjikzNRZ06hn394tbOqdx0hNSZl+d1jXogf2qZLQfxQOfP0cDThO6gBLj+jqseNfwR
         kHhKxLqzzXYpemUP4/GxPFV5UWaoqCNL/cNy9iqp30X4DOSEUnnm+DsfyffA3WxnutsK
         yD8PNhfiQMUazc9VvwsfXi0ltnIg+coMwgClkqvLKWmItDEpUWN5auWnOonvLs/L4WZ7
         6r0ZzqyjnjumzbuVaunDFc9DZ/Af6XVb3dslQek2CXcvmEBS1U/gXKcxpgOXNjIB/mvM
         koAEfTjzsLnBrlQSPBy9XOr23CCbqm797dIt0uPOeL6A8FAye9AAqAud0GLo4seHMQbU
         1fbg==
X-Gm-Message-State: ANoB5plOxI/S2MZUikN1QQk7EcHFRlIzFunzUSf9FYla67vB6T8XkZqm
        LQqmUcZOy5QoAhEB+Bgth2PXSg==
X-Google-Smtp-Source: AA0mqf4pv5YV5N05LaViOe7i4mQW0kV0nXSH2eUKtr75zRI8ca4d6+bK+cWSPpj9A/AIWksyRUsbvg==
X-Received: by 2002:a17:907:3117:b0:7ae:6746:f26b with SMTP id wl23-20020a170907311700b007ae6746f26bmr54633868ejb.171.1669875519596;
        Wed, 30 Nov 2022 22:18:39 -0800 (PST)
Received: from [100.111.29.158] ([109.37.133.192])
        by smtp.gmail.com with ESMTPSA id r17-20020a1709061bb100b007c0985aa6b0sm1387028ejg.191.2022.11.30.22.18.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Nov 2022 22:18:34 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     wangyufen <wangyufen@huawei.com>,
        Franky Lin <franky.lin@broadcom.com>
CC:     <aspriel@gmail.com>, <hante.meuleman@broadcom.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <arend@broadcom.com>
Date:   Thu, 01 Dec 2022 07:18:32 +0100
Message-ID: <184cc562ed8.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <14e5c329-03c4-e82e-8ae2-97d30d53e4fd@huawei.com>
References: <1669716458-15327-1-git-send-email-wangyufen@huawei.com>
 <CA+8PC_czBYZUsOH7brTh4idjg3ps58PtanqtmTD0mPN3Sp9Xhw@mail.gmail.com>
 <4e61f6e5-94bd-9e29-d12f-d5928f00c8a8@huawei.com>
 <5dd42599-ace7-42cb-8b3c-90704d18fc21@broadcom.com>
 <14e5c329-03c4-e82e-8ae2-97d30d53e4fd@huawei.com>
User-Agent: AquaMail/1.40.1 (build: 104001224)
Subject: Re: [PATCH] wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002dca6a05eebe3165"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002dca6a05eebe3165
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit

On December 1, 2022 4:01:39 AM wangyufen <wangyufen@huawei.com> wrote:

> 在 2022/11/30 19:19, Arend van Spriel 写道:
>> On 11/30/2022 3:00 AM, wangyufen wrote:
>>>
>>>
>>> 在 2022/11/30 1:41, Franky Lin 写道:
>>>> On Tue, Nov 29, 2022 at 1:47 AM Wang Yufen <wangyufen@huawei.com> wrote:
>>>>>
>>>>> Fix to return a negative error code -EINVAL instead of 0.
>>>>>
>>>>> Compile tested only.
>>>>>
>>>>> Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
>>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>>>> ---
>>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> index 465d95d..329ec8ac 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
>>>>> @@ -3414,6 +3414,7 @@ static int brcmf_sdio_download_firmware(struct
>>>>> brcmf_sdio *bus,
>>>>>         /* Take arm out of reset */
>>>>>         if (!brcmf_chip_set_active(bus->ci, rstvec)) {
>>>>>                 brcmf_err("error getting out of ARM core reset\n");
>>>>> +               bcmerror = -EINVAL;
>>>>
>>>> ENODEV seems more appropriate here.
>>>
>>> However, if brcmf_chip_set_active()  fails in
>>> brcmf_pcie_exit_download_state(), "-EINVAL" is returned.
>>> Is it necessary to keep consistent?
>>
>> If we can not get the ARM on the chip out of reset things will fail soon
>> enough further down the road. Anyway, the other function calls return
>> -EIO so let's do the same here.
>
> So -EIO is better?  Anyone else have any other opinions? 😄

Obviously it is no better than -EINVAL when you look at the behavior. It is 
just a feeble attempt to be a little bit more consistent. Feel free to 
change the return value for brcmf_pcie_exit_download_state() as well.

Regards,
Arend
>>




--0000000000002dca6a05eebe3165
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
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBZhSJJg5vXgJ7I1Z1z
S3pD8gSUnSYPb8kYsCVpwErDWDAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjEyMDEwNjE4MzlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAZdhfWp++yf/L/vF+pWEKdim8gSv4zgOj61H5
KDs0odL3oycMnOGf9CP8otmIm9G5bM7mL6ZQlM0H5EMGSlV6jHOEXRGcgfix/sHcGAQCMDsnfcpz
zO7Eaof4VcV8yNNRXQTZ0gdS150HJDIk/+u7DLpkvXCxsdy27h82FMOyyXpaTS6sAAofdHDbgOc/
AN3/5NTE3K36TJmRpwsNi1dHEEgJOhWEzOYcraL/iMLwmxZVmEGlilWuNCv+TOyBDa1M13ezOzPQ
+w86jXImzfdkZ4gSI5sAgtZYOv5LDvp6Q8D+0NC4I30mPnq8H0TJuQ/0Xrrmk27EVzgET5E7G89F
Fw==
--0000000000002dca6a05eebe3165--
