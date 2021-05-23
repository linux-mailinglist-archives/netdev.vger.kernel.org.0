Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B538D95B
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 08:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhEWG4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 02:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbhEWG4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 02:56:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A1EC06138A
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:54:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id et19so29734067ejc.4
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version;
        bh=mN683RJDic84XC4yWf94CI824+tAyOQKD3uivZwksLY=;
        b=dnGBeI1x8fTpOClHenQcL7+naL9Wic4S50V1Z9oGNauwQHUgs6Fi+X0xrHSLlEFget
         BM0LQEym1+NcJ1XDEcJ36KMu6L2ycZb9M0HrMtrDZdfIb28SqGeo3goHd0JTMkRmHYPt
         XfJ5cAGAWPl+pZz/RyWLAlSs2EFaod9phvbsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version;
        bh=mN683RJDic84XC4yWf94CI824+tAyOQKD3uivZwksLY=;
        b=eNmAjOTo538ZuOlGULoft9jvWr9GQDp9k3WPJH1dU9ace/sn9uSItpP7aSQKHWkedv
         7odWe0ROXQCgwZo8TJ2RrNRobqlZ5u35GZ0Ju0Sa2yIWa6mnjyl/4k/tseOcRx6rRLM/
         vX1oW2FG9cLLUiu8i5CvUXqNgJsvdi7yQCmS4rFZec4gr3phWoKH4EhRcFYpmoecZWqy
         VUjg3ExBVJQErrXaV7Mq9LlViVmof1WH9Kz0CbrS5TVHUTG4puZAA3SRB+Pw9b1J+PYw
         LtuQOadza2tButB3YZOAr5xF5p788qbHPTd8RQHwb1o/mgMAqp9PQyfiHeYErb+6mtbL
         djhA==
X-Gm-Message-State: AOAM53360JbU++rvwx/GrKhfb/UJFd64HWLCZwbZaGrHW0TviYfeCV1/
        jjkrUAakt/rmDTa2nO7k7BNzfJvh+JnhrsO8RPAqkPS1kPeKdIX+bz/TACHDSymi76gXHEDqGAh
        9d6UAds4=
X-Google-Smtp-Source: ABdhPJw5GjMU3W9VOYLU/1HtIAJfi9rkx2KxNxIlgvpbqRVjxlhv8yooF6ljBITWfs4XBj0EOjsKQQ==
X-Received: by 2002:a17:906:82d5:: with SMTP id a21mr17887594ejy.5.1621752891070;
        Sat, 22 May 2021 23:54:51 -0700 (PDT)
Received: from [192.168.178.38] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id yw9sm6168485ejb.91.2021.05.22.23.54.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 May 2021 23:54:50 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Shawn Guo <shawn.guo@linaro.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "Chi-hsien Lin" <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        "Chung-hsien Hsu" <chung-hsien.hsu@infineon.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>
Date:   Sun, 23 May 2021 08:54:48 +0200
Message-ID: <17998013ac0.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20210523061221.GD29015@dragon>
References: <20210425110200.3050-1-shawn.guo@linaro.org>
 <b6c5713f-ebf0-9eaf-e871-d5690a6b7c10@broadcom.com>
 <20210428124228.GH15093@dragon>
 <20210523061221.GD29015@dragon>
User-Agent: AquaMail/1.29.2-1810 (build: 102900008)
Subject: Re: [PATCH] brcmfmac: use ISO3166 country code and 0 rev as fallback
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000001449f05c2f9c586"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000001449f05c2f9c586
Content-Type: text/plain; format=flowed; charset="UTF-8"

On May 23, 2021 8:12:29 AM Shawn Guo <shawn.guo@linaro.org> wrote:

> On Wed, Apr 28, 2021 at 08:42:29PM +0800, Shawn Guo wrote:
>> On Wed, Apr 28, 2021 at 02:03:07PM +0200, Arend van Spriel wrote:
>>> On 4/25/2021 1:02 PM, Shawn Guo wrote:
>>>> Instead of aborting country code setup in firmware, use ISO3166 country
>>>> code and 0 rev as fallback, when country_codes mapping table is not
>>>> configured.  This fallback saves the country_codes table setup for recent
>>>> brcmfmac chipsets/firmwares, which just use ISO3166 code and require no
>>>> revision number.
>>>
>>> I am somewhat surprised, but with the brcm-spinoffs (cypress/infineon and
>>> synaptics) my understanding may have been surpassed by reality. Would you
>>> happen to know which chipsets/firmwares require only ISO3166 code and no
>>> rev?
>>
>> The "no rev" here actually means 'rev' field being zero.  The chipset
>> I'm running is a BCM43012 from Synaptics, I think.
>>
>> Firmware: BCM43012/2 wl0: Apr 16 2021 15:25:36 version 18.35.389.63.t2 
>> (wlan=r836194) FWID 01-a8c7bac
>
> Arend,
>
> Does it make sense?  Or is there actually a country code mapping table
> I'm not aware of?

I recall the firmware always include a rev 0 for each country code. I will 
have to ask internally whether that may be used for any chipset. If so, it 
seems reasonable to use rev 0 as fallback when no mapping table is provided.

Regards,
Arend




-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--00000000000001449f05c2f9c586
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCAYlGQGboJuh+3YOUZB
4X4uZL78dBMtXhYk8JE0lBM3CjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMTA1MjMwNjU0NTFaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAct1E3ef/h3RGzyHgfD/6M3Tifg3wNHpNF5Zv
kntafYN2e+oynSuLODBzWobOecZMMSSrft2u9AQikfCsTR7KGPFVIJouXiCe4ezB36PEREWqHli5
J7uHjKTFsYoX6RP5lny4MpFdgrAu3h4W2Sg9IY0dKE0TG9cjqzKK5a+dWokERijEPo3COwFnYO0V
+9pIktl1xwivoZHVbELStScqnW+1IVI/5vo9K4spWNsVFvfNAXI4FwGa1M+JaifuMy0BRhqoHDEm
/udqtRFLprd5nBhgMxOFDP+5PSmExPjG8lKE+jiqlgZgo4dRo6CF3NVODthzPCIru4mwMFKznm1b
Rg==
--00000000000001449f05c2f9c586--
