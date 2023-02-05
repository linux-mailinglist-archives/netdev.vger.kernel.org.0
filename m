Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F4D68AE90
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 07:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBEG6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 01:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBEG6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 01:58:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0FF22784
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 22:58:08 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id eq11so8758846edb.6
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 22:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MRkCLmA81LACbEaz/c/cvJIgZ+jKBgVWzPa9PNzdeHE=;
        b=gcc6hiBiwJV1jMRb/oHUVVIM6mDES9jLBAaMbgvrV1jhmiqlXLgXAFWXW7tiqRrLWn
         cvxL0WWM1j7W8xNwGbYd/8LYQ+yNYoWHgWkzNAzw4rPNla7SlYsgdBAnGPV/oYSqVXD7
         /RWKbmuw7xPtLtoTddC2TZ+Kw8bUReImnSFTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRkCLmA81LACbEaz/c/cvJIgZ+jKBgVWzPa9PNzdeHE=;
        b=OCtL9sGqW7KtaKYIWCvSxKxruOurBwBvSlLXnDgSLx6XcjiAORczDEm3sI1+kvAUEu
         4JwVrbcGsQ1oOM+/0gnMUPVWs56/kzptbbp/5nkTBXd++9Ptxn7nC1mqyNXQhplNX3Rg
         +I1ajVnUbeHYsSdwSSllIwZJvfy2F2uMMT1EI8lxBSoTSKUx8RExjlVTWgAPtMFHzkQZ
         h515bt4WcrAjyeLRGyYUl7xhORdLcEdH7w4Tw2QN2xFByQbNa1AFXd3A+jjs+mVYVbQJ
         ClUjjHWk6bueMyUid8NVwewtSkannOsxKRNQokSJ+9fG90SrOi2GT4Q8z0IjaAY95uwP
         p55g==
X-Gm-Message-State: AO0yUKVHEZNCwbOdIPxjysJSmSMFV6xUuWbzd6rjQEeV0IryE8Ku2CLE
        17OuMDXSFl0dXS6tgECvRTimhQ==
X-Google-Smtp-Source: AK7set/iR/Bydojhcr5nmgxe9SbwW6//oN1GF1HIb1u+6yJ+qZx2rdIidiaU5B3ztd+oqfnSWBWNXA==
X-Received: by 2002:a05:6402:2998:b0:4a8:4252:757e with SMTP id eq24-20020a056402299800b004a84252757emr10467876edb.32.1675580286506;
        Sat, 04 Feb 2023 22:58:06 -0800 (PST)
Received: from [192.168.178.38] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id m24-20020a170906849800b0088b24b3aff8sm3749056ejx.183.2023.02.04.22.58.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Feb 2023 22:58:05 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Hector Martin <marcan@marcan.st>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "'Hector Martin' via BRCM80211-DEV-LIST,PDL" 
        <brcm80211-dev-list.pdl@broadcom.com>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>, <asahi@lists.linux.dev>,
        <linux-wireless@vger.kernel.org>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sun, 05 Feb 2023 07:58:04 +0100
Message-ID: <186205e1c60.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <28ed8713-4243-7c67-b792-92d0dde82256@marcan.st>
References: <20230131112840.14017-1-marcan@marcan.st>
 <20230131112840.14017-2-marcan@marcan.st>
 <CAOiHx=mYxFx0kr5s=4X_qywZBpPqCbrNjLnTXfigPOnqZSxjag@mail.gmail.com>
 <4fb4af22-d115-de62-3bda-c1ae02e097ee@marcan.st>
 <1861323f100.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <28ed8713-4243-7c67-b792-92d0dde82256@marcan.st>
User-Agent: AquaMail/1.42.0 (build: 104200255)
Subject: Re: [PATCH v2 1/5] brcmfmac: Drop all the RAW device IDs
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c967cf05f3ee6fe9"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c967cf05f3ee6fe9
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit

- stale Cypress emails

On February 5, 2023 3:50:41 AM Hector Martin <marcan@marcan.st> wrote:

> On 03/02/2023 02.19, Arend Van Spriel wrote:
>> On February 2, 2023 6:25:28 AM "'Hector Martin' via BRCM80211-DEV-LIST,PDL"
>> <brcm80211-dev-list.pdl@broadcom.com> wrote:
>>
>>> On 31/01/2023 23.17, Jonas Gorski wrote:
>>>> On Tue, 31 Jan 2023 at 12:36, Hector Martin <marcan@marcan.st> wrote:
>>>>>
>>>>> These device IDs are only supposed to be visible internally, in devices
>>>>> without a proper OTP. They should never be seen in devices in the wild,
>>>>> so drop them to avoid confusion.
>>>>
>>>> I think these can still show up in embedded platforms where the
>>>> OTP/SPROM is provided on-flash.
>>>>
>>>> E.g. https://forum.archive.openwrt.org/viewtopic.php?id=55367&p=4
>>>> shows this bootlog on an BCM4709A0 router with two BCM43602 wifis:
>>>>
>>>> [    3.237132] pci 0000:01:00.0: [14e4:aa52] type 00 class 0x028000
>>>> [    3.237174] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x00007fff 64bit]
>>>> [    3.237199] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x003fffff 64bit]
>>>> [    3.237302] pci 0000:01:00.0: supports D1 D2
>>>> ...
>>>> [    3.782384] pci 0001:03:00.0: [14e4:aa52] type 00 class 0x028000
>>>> [    3.782440] pci 0001:03:00.0: reg 0x10: [mem 0x00000000-0x00007fff 64bit]
>>>> [    3.782474] pci 0001:03:00.0: reg 0x18: [mem 0x00000000-0x003fffff 64bit]
>>>> [    3.782649] pci 0001:03:00.0: supports D1 D2
>>>>
>>>> 0xaa52 == 43602 (BRCM_PCIE_43602_RAW_DEVICE_ID)
>>>>
>>>> Rafał can probably provide more info there.
>>>>
>>>> Regards
>>>> Jonas
>>>
>>> Arend, any comments on these platforms?
>>
>> Huh? I already replied to that couple of days ago or did I only imagine
>> doing that.
>
> I don't see any replies from you on the lists (or my inbox) to Jonas' email.

Accidentally sent that reply to internal mailing list. So quoting myself here:

"""
Shaking the tree helps ;-) What is meant by "OTP/SPROM is provided 
on-flash"? I assume you mean that it is on the host side and the wifi PCIe 
device can not access it when it gets powered up. Maybe for this scenario 
we should have a devicetree compatible to configure the device id, but that 
does not help any current users of these platforms. Thanks for providing 
this info.
"""

Regards,
Arend




--000000000000c967cf05f3ee6fe9
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
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCkvKvg5Rwq33wWaFyo
/EONhMwmY1qXXqnkV/jy13GiKzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMzAyMDUwNjU4MDZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAfj/Gdy31M5hEaf6JFI8l1sHZRJ6zmhycT6dl
en9l8AwwvibjFIt7bSmJ7rHorvvL4io4WSwQbm7uk/FVDLs5ukxSCkm8HcfG7lUB8yW/S0wvuI/r
c//cJyA/cDU6hTharqmhdqb5H3TwzFG7TmD8PC/v0HN8XGY5xfkiOTaQsMx4ZiHQrKv/1iU4/Y8C
bBbH9ZwNnxJap033xzX8noHoY27CRP5Fw1/yqtfZKXlev0hTsdydFApyMmQcnTyzIGeyfWduAwD/
VsAlePzuVwKrESgAzYqbKua/x2PvmfVr+H2XG9nCXRtUVpVltK/wLqV5OAsv45p0jH00Sblvak2p
hw==
--000000000000c967cf05f3ee6fe9--
