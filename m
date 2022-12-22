Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE21E653F1D
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 12:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiLVLhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 06:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbiLVLhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 06:37:11 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0126205F3
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 03:37:09 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id x11so1082070qtv.13
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 03:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=CeLNuBbrP530src0Z6NCrItj4/+wVeEtwCPVc4BuF5Y=;
        b=Vqda0nKrOLj8xINU0m5yCraWtC9LnYAC0x3ehyJl3BasENJbnHjFUWRF7+IdDgX8NO
         XjEe7iYwKLfg4EBLUmpcb2m3emczsCNWIweBjT9wZdksF2O3runw7iJurtprkdgZGUQA
         MlAedVrNDFfJztV8+LuBO4+4Kivkh6iiSy8Rg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CeLNuBbrP530src0Z6NCrItj4/+wVeEtwCPVc4BuF5Y=;
        b=3TKBg9XkGRdJ2/7GNPEFQviXluX5zdKaeDqQrXbVtlIji1VCXAlEYeZgY1nK+dvI3n
         WbyoJ9N8pKch8bjQcjwPqERnK0aSsTahMAn/Ng3V3Hz6phDW9SqMdPaa6cyWC2A6SW4c
         WAkduEMqKPZqw8C9LwiF3NLZtmnf5kxy7eIeYDob4IQJ73iiraHZjDAdxQBOihQ7Y1V1
         HJPdCTvFsDtAdahmIRTkiF7vaUSJa88HiMHFymWipjFLPDBpowAnnrn+4raChYYph4u8
         C4V+F69Mg08SP+zuv5ckp917WjBP2t7Ku0bCnH9lJ+afimLSHfVETJUiJu5VIhbCtHAu
         eo+A==
X-Gm-Message-State: AFqh2kobi058Oq1rIuTR69tALWxjmCPIHzZWltxVEHY4mARpGoiPQxnO
        B3VY9atun6pYNveZLktaIjs/6SElVxGGE7JC
X-Google-Smtp-Source: AMrXdXsgrmSpI1wqz9afmQ1MMfc8bAWQGMhm223lGfvhvC2F3UZxrpozfDbNqJBc0Ye8JsabRlBggg==
X-Received: by 2002:ac8:4f17:0:b0:3a6:95ff:ffd4 with SMTP id b23-20020ac84f17000000b003a695ffffd4mr6515138qte.52.1671709028795;
        Thu, 22 Dec 2022 03:37:08 -0800 (PST)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id g8-20020ac81248000000b003a69de747c9sm241955qtj.19.2022.12.22.03.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:37:07 -0800 (PST)
Message-ID: <58d61ba6-3cd9-cfee-d6d1-2bb800853eb4@broadcom.com>
Date:   Thu, 22 Dec 2022 12:37:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] wifi: brcmfmac: unmap dma buffer in
 brcmf_msgbuf_alloc_pktid()
To:     shaozhengchao <shaozhengchao@huawei.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "aspriel@gmail.com" <aspriel@gmail.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        "wright.feng@cypress.com" <wright.feng@cypress.com>,
        "chi-hsien.lin@cypress.com" <chi-hsien.lin@cypress.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "alsi@bang-olufsen.dk" <alsi@bang-olufsen.dk>,
        "pieterpg@broadcom.com" <pieterpg@broadcom.com>,
        "dekim@broadcom.com" <dekim@broadcom.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
References: <20221207013114.1748936-1-shaozhengchao@huawei.com>
 <167164758059.5196.17408082243455710150.kvalo@kernel.org>
 <Y6QJWPDXglDjUP9p@linutronix.de> <87cz8bkeqp.fsf@kernel.org>
 <47236b24-6b47-b03a-c7b8-c46ea07cac6f@huawei.com>
 <6b529058-3650-72bb-7541-9fbfb8c6ad9b@broadcom.com>
 <fc8a7c6ac335473b901aa9815167754f@huawei.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <fc8a7c6ac335473b901aa9815167754f@huawei.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d853c805f0691606"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d853c805f0691606
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 12/22/2022 12:35 PM, shaozhengchao wrote:
> 
> 
> -----Original Message-----
> From: Arend van Spriel [mailto:arend.vanspriel@broadcom.com]
> Sent: Thursday, December 22, 2022 7:00 PM
> To: shaozhengchao <shaozhengchao@huawei.com>; Kalle Valo <kvalo@kernel.org>; Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: netdev@vger.kernel.org; linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com; SHA-cyfmac-dev-list@infineon.com; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; aspriel@gmail.com; franky.lin@broadcom.com; hante.meuleman@broadcom.com; wright.feng@cypress.com; chi-hsien.lin@cypress.com; a.fatoum@pengutronix.de; alsi@bang-olufsen.dk; pieterpg@broadcom.com; dekim@broadcom.com; linville@tuxdriver.com; weiyongjun (A) <weiyongjun1@huawei.com>; yuehaibing <yuehaibing@huawei.com>
> Subject: Re: [PATCH] wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()
> 
> On 12/22/2022 9:52 AM, shaozhengchao wrote:
>>
>>
>> On 2022/12/22 16:46, Kalle Valo wrote:
>>> Sebastian Andrzej Siewior <bigeasy@linutronix.de> writes:
>>>
>>>> On 2022-12-21 18:33:06 [+0000], Kalle Valo wrote:
>>>>> Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>>>>
>>>>>> After the DMA buffer is mapped to a physical address, address is
>>>>>> stored
>>>>>> in pktids in brcmf_msgbuf_alloc_pktid(). Then, pktids is parsed in
>>>>>> brcmf_msgbuf_get_pktid()/brcmf_msgbuf_release_array() to obtain
>>>>>> physaddr
>>>>>> and later unmap the DMA buffer. But when count is always equal to
>>>>>> pktids->array_size, physaddr isn't stored in pktids and the DMA buffer
>>>>>> will not be unmapped anyway.
>>>>>>
>>>>>> Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
>>>>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>>>>>
>>>>> Can someone review this?
>>>>
>>>> After looking at the code, that skb is mapped but not inserted into the
>>>> ringbuffer in this condition. The function returns with an error and the
>>>> caller will free that skb (or add to a list for later). Either way the
>>>> skb remains mapped which is wrong. The unmap here is the right thing to
>>>> do.
>>>>
>>>> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>>
>>> Thanks for the review, very much appreciated.
>>>
>>
>> Thank you very much.
> 
>> Good catch. Has this path been observed or is this found by inspecting
>> the code? Just curious.
> 
>> Regards,
>> Arend
> 
> Hi Arend：
> 	I review code and find the bug.


Much appreciated.

Regards,
Arend

> Zhengchao Shao

--000000000000d853c805f0691606
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
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBn4YmxMlybyTKYUck3
g+QzvLr7vK/vfo4lClMGCb5t3jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjEyMjIxMTM3MDlaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAX9jQ04R+dTyhlWaurcdCKjjNZWGcUf0OZHb0
QujWNHCexNzmC+LQR+9uhIT0zRK05b4epKWza/lWCm0fi+jUlfJJvcrfeK8NqbJ+nUqmdDyVhBYX
TzciVBI+L6I5JAga73aUi7cpKgy6poQDrxDkmfyefhrocIiyJUVWVZT2rpBze7M6FVMyjt0Cu9Xo
X4vWtNfSHUvufAVZ1hRHDitKQYetF4m7DvTVJSvcfL5UBs0+Nwqi9jSLf6Eyxgf/LflRe25M/9B8
dpM23LjgwiOKQhrzS3giB+YdZmm7G1fBxFSWKF7Wu42Ky+MQvgC9BwYhnibGTVQTa7VzHGduOgGG
Dg==
--000000000000d853c805f0691606--
