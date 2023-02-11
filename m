Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228BE693048
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 12:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBKLXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 06:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjBKLXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 06:23:39 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA4753E7D
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:23:36 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id lu11so21712504ejb.3
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Wee+p5e9Yynp8SwJfYHFndUd7OT+siZ3oRo1NeGP9iI=;
        b=ZWeifxaIxsodLZR9JHzy4RQzWuYL1iJZ0/q2mU3B/6/JVwxoyMGSM9nHmSrnp+wChP
         iHAKoieOvCLjA923my9XhIsCsfKLpPu5o+XvBt0VDgjJTnRfKnxTIsumuiPkT+9Y9dmw
         S2gIjWv+u8HxseKqdqM7NiHCRs/3bZumBGP3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wee+p5e9Yynp8SwJfYHFndUd7OT+siZ3oRo1NeGP9iI=;
        b=VgLiaBcjKz4h8XKt8qC1OZenHZ1S3sqN1MX0yi2haO3u/8AP3MZceQT8eMS/YGzU0t
         i/Tu64COWNxWfXJsEjqYqZDFZ02fjFGnNpPszTDMJqwOY+ZyKk2kWEvrwIN6yKHL9xWG
         OsKZVnes+rTueOCTjeFT3RumEDpRjk2mlLPZZglQC8UmPV4i5CJev8wmsdy+VD21tF+F
         vBiwZ7+O8bizHFjTMl4r+6g1pk5Lar0XX2PdicZyIOu2eoY/5dhNOedwXXdD6ghfi8Mh
         h5zcywit6QkFSde2JRwf6a9lO5ZKgAF2zV9afDK64qd8mjC5mcxJc3tkHE/uAujYs9k7
         DFtA==
X-Gm-Message-State: AO0yUKWb8DhAaQ0/fX+fAUJakXNc6NtozoXeziSpKe/TLsxGgtUNmcak
        kiQ+9ik5goFonU8YRzcKG0C7Mw==
X-Google-Smtp-Source: AK7set9uF8z7qIbdDgTgvt/9b6Q+9YT38UlZGCN/o7bwyP+ov6rNdx38SxDSKjwVlV9V/+OnSYNpWA==
X-Received: by 2002:a17:906:7202:b0:883:ba98:204d with SMTP id m2-20020a170906720200b00883ba98204dmr19783540ejk.65.1676114614542;
        Sat, 11 Feb 2023 03:23:34 -0800 (PST)
Received: from [192.168.178.38] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id b12-20020a170906150c00b00888d593ce76sm3719540ejd.72.2023.02.11.03.23.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Feb 2023 03:23:33 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Hector Martin <marcan@marcan.st>,
        "Ping-Ke Shih" <pkshih@realtek.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Alexander Prutskov <alep@cypress.com>,
        "Chi-Hsien Lin" <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, <asahi@lists.linux.dev>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Sat, 11 Feb 2023 12:23:31 +0100
Message-ID: <18640374b38.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
 <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
 <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
User-Agent: AquaMail/1.42.0 (build: 104200255)
Subject: Re: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000037705f05f46ad890"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000037705f05f46ad890
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit

On February 11, 2023 11:09:02 AM Hector Martin <marcan@marcan.st> wrote:

> On 10/02/2023 12.42, Ping-Ke Shih wrote:
>>
>>
>>> -----Original Message-----
>>> From: Hector Martin <marcan@marcan.st>
>>> Sent: Friday, February 10, 2023 10:50 AM
>>> To: Arend van Spriel <aspriel@gmail.com>; Franky Lin 
>>> <franky.lin@broadcom.com>; Hante Meuleman
>>> <hante.meuleman@broadcom.com>; Kalle Valo <kvalo@kernel.org>; David S. 
>>> Miller <davem@davemloft.net>; Eric
>>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo 
>>> Abeni <pabeni@redhat.com>
>>> Cc: Alexander Prutskov <alep@cypress.com>; Chi-Hsien Lin 
>>> <chi-hsien.lin@cypress.com>; Wright Feng
>>> <wright.feng@cypress.com>; Ian Lin <ian.lin@infineon.com>; Soontak Lee 
>>> <soontak.lee@cypress.com>; Joseph
>>> chuang <jiac@cypress.com>; Sven Peter <sven@svenpeter.dev>; Alyssa 
>>> Rosenzweig <alyssa@rosenzweig.io>;
>>> Aditya Garg <gargaditya08@live.com>; Jonas Gorski <jonas.gorski@gmail.com>; 
>>> asahi@lists.linux.dev;
>>> linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com; 
>>> SHA-cyfmac-dev-list@infineon.com;
>>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Hector Martin 
>>> <marcan@marcan.st>; Arend van Spriel
>>> <arend.vanspriel@broadcom.com>
>>> Subject: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
>>>
>>> The commit that introduced support for this chip incorrectly claimed it
>>> is a Cypress-specific part, while in actuality it is just a variant of
>>> BCM4355 silicon (as evidenced by the chip ID).
>>>
>>> The relationship between Cypress products and Broadcom products isn't
>>> entirely clear but given what little information is available and prior
>>> art in the driver, it seems the convention should be that originally
>>> Broadcom parts should retain the Broadcom name.
>>>
>>> Thus, rename the relevant constants and firmware file. Also rename the
>>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>>> driver).
>>>
>>> v2: Since Cypress added this part and will presumably be providing
>>> its supported firmware, we keep the CYW designation for this device.
>>>
>>> v3: Drop the RAW device ID in this commit. We don't do this for the
>>> other chips since apparently some devices with them exist in the wild,
>>> but there is already a 4355 entry with the Broadcom subvendor and WCC
>>> firmware vendor, so adding a generic fallback to Cypress seems
>>> redundant (no reason why a device would have the raw device ID *and* an
>>> explicitly programmed subvendor).
>>
>> Do you really want to add changes of v2 and v3 to commit message? Or,
>> just want to let reviewers know that? If latter one is what you want,
>> move them after s-o-b with delimiter ---
>
> Both; I thought those things were worth mentioning in the commit message
> as it stands on its own, and left the version tags in so reviewers know
> when they were introduced.

The commit message is documenting what we end up with post reviewing so 
patch versions are meaningless there. Of course useful information that 
came up in review cycles should end up in the commit message.

Regards,
Arend




--00000000000037705f05f46ad890
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
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDeegE7KjXbma0LbcgE
jmYPyuSaqO0ZzSDKJjMmfBOTfTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMzAyMTExMTIzMzRaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAMbvZE/Fm8PKwL4bLxym/1Wxao6dyBbMMs17Y
IMb0H51fXhl8/skpMDQBmOAYRS/sJdQ6+GIkbNhzh9F4o8QEf5uvBsAJvoPz2X6uk7taZDZQfXvH
U3UztIXiEPQfBglOTJq0beTcukTLQ2ISPNInLUqZ8EWKbkFkn4hzWLvmx2XSltuzJ1akA8gGzsYi
XU3ODisDqiHDYC1NQvAQD2KZfyGlVPqBSV6mFA0Aca6RkXiHGiL6nRwYChQWb1Kutr0LU+ltCoq4
qJb+ak76SlKDFEMeRS5oMc4cXg/wKT4qMrMXzN+hcW9jTM5siO6KrF3bCJBVTgA6nBI35Qyb8Lxn
vw==
--00000000000037705f05f46ad890--
