Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC03F1E37
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhHSQlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhHSQk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 12:40:59 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C10EC061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:40:23 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id d11so14122715eja.8
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version;
        bh=2CSgDuo5gzTZMs0fH69SccBvjgushh/NOV4Ye02Hcrk=;
        b=aV+3oSC32zxb8Omx3FMdKpkdajPN0vTxh1AfFDgcMeS5h4lN3oed7N/uHl3YEz4nDg
         saCmjocWMYC9dRhI47IuHStAxbhV0a/j+wKNsFJwB8aMexUCcxZf4JfceLxPrgJjyGEh
         PehNv52A2CjzFFK+3SnDfDNfF82YUedqyEHYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version;
        bh=2CSgDuo5gzTZMs0fH69SccBvjgushh/NOV4Ye02Hcrk=;
        b=P70Yuudx6o0JRqZtHutqlN/5QXQ7ON8AEqMWeLGQ5oVy7HOx4qHq60zY821Vxbb6gM
         KMZRCui9g/ebJ9VJki8krojJGg0zdqXri3S4NNJ7Z9JWTGhzDYifZLfskTkhfyouXVjJ
         NtB0pfsHVSxqNStNU/x7lWWZ6ApAbAVFljST3z2Qbn5q4BVrpxBn2LjKsYey/ukd90ob
         rDEyS2rgEGH2rCZNKGzCVYhQMM20LOz2ip8D0kw0/XXhjusjzZPZhkBZigiYQzRKKS1/
         ONfjAuPajV0PGD3u3z0NtM9JT/fVGSbTadE6KtTpb32Z8rYnXQGTURnvXfOIJLd5Wave
         Sc2w==
X-Gm-Message-State: AOAM531D7QZpsscCe3G7smWJdVv9B1UKGSYMRMFnxLrxKtLN+pf1+A2K
        a1OUD8SPYbj56349t9wu3BGFgw1mmAqNQVmC/fQgwfBOzLlp/bFf8nQMnSWEkr/5lZYKs8rrQAe
        RCQOat2E=
X-Google-Smtp-Source: ABdhPJyfGAwrivNEY+19s9BUWJuYXJyY/gPbf9uheHF3Co3Di42SSD8o2cdRT2XlNT6D9wu4Ey1uBw==
X-Received: by 2002:a17:906:31cf:: with SMTP id f15mr16865335ejf.272.1629391221585;
        Thu, 19 Aug 2021 09:40:21 -0700 (PDT)
Received: from [10.230.42.144] ([192.19.152.250])
        by smtp.gmail.com with ESMTPSA id s18sm1557315ejh.12.2021.08.19.09.40.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:40:18 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Ryutaroh Matsumoto <ryutaroh@ict.e.titech.ac.jp>
CC:     <aspriel@gmail.com>, <linux-rpi-kernel@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@infineon.com>,
        <wright.feng@infineon.com>, <chung-hsien.hsu@infineon.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>
Date:   Thu, 19 Aug 2021 18:40:17 +0200
Message-ID: <17b5f48d5b0.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20210818.184109.580170563027962616.ryutaroh@ict.e.titech.ac.jp>
References: <20210817.093658.33467107987117119.ryutaroh@ict.e.titech.ac.jp>
 <17b52a1ab20.279b.9696ff82abe5fb6502268bdc3b0467d4@gmail.com>
 <56ea3e65-62f4-2496-edd4-e454126abc66@broadcom.com>
 <20210818.184109.580170563027962616.ryutaroh@ict.e.titech.ac.jp>
User-Agent: AquaMail/1.30.1-1828 (build: 103001000)
Subject: Re: 5.10.58 UBSAN from brcmf_sdio_dpc+0xa50/0x128c [brcmfmac]
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000faee7805c9ec34eb"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000faee7805c9ec34eb
Content-Type: text/plain; format=flowed; charset="US-ASCII"

On August 18, 2021 11:41:14 AM Ryutaroh Matsumoto 
<ryutaroh@ict.e.titech.ac.jp> wrote:

> Hi Arend, sorry for my late response, partly because compilation takes 10 hours
> on RPi4B...
> I did the same thing with version 5.10.59 and CLang 11 and got the same
> UBSAN.
>
>>> If you enable CONFIG_DEBUG_INFO in your kernel .config and recompile
>>> brcmfmac you can load the module in gdb:
>>> gdb> add-symbol-file brcmfmac.ko [address]
>>> gdb> l *brcmf_sdio_dpc+0xa50
>>> The [address] is not very important so just fill in a nice value. The
>>> 'l' command should provide the line number.
>>
>> Hi Ryutaroh,
>>
>> Meanwhile I did some digging in the brcmfmac driver and I think I
>> found the location in brcmf_sdio_sendfromq() where we do a
>> __skb_queue_tail(). So I looked at that and it does following:
>>
>> static inline void __skb_queue_tail(struct sk_buff_head *list,
>> struct sk_buff *newsk)
>> {
>> __skb_queue_before(list, (struct sk_buff *)list, newsk);
>> }
>>
>> Your report seems to be coming from the cast that is done here, which
>> is fine as long as sk_buff and sk_buff_head have the same members
>> 'next' and 'prev' at the start, which is true today and hopefully
>> forever ;-) I am inclined to say this is a false report.
>>
>> Can you please confirm the stack trace indeed points to
>> brcmf_sdio_sendfromq() in your report.
>
> Summary: I confirm that the stack trace indeed points to
> brcmf_sdio_sendfromq(). The detail follows (you don't have to read it if
> you believe in me :-)
> If kernel version 5.10.x or 5.13.x is compiled with gcc 10, I have never seen
> UBSAN. I wonder if CLang 11/12 tends to generate falsely positive UBSAN.

UBSAN seems to be wrong in this case...

>
> (gdb) add-symbol-file  
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko 0x0
> add symbol table from file 
> "drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko" at
> .text_addr = 0x0
> (y or n) y
>
> (gdb)  l *brcmf_sdio_dpc+0xa50
> warning: Could not find DWO CU 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.dwo(0x79060145b4b45807) 
> referenced by CU at offset 0x394 [in module 
> /usr/lib/debug/lib/modules/5.10.59-clang11debug/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko]
> 0x277a4 is at ./include/linux/skbuff.h:2016.
> 2011 ./include/linux/skbuff.h: No such file or directory.
>
> Line 2016 of skbuff.h is __skb_insert in the next inline function:
> static inline void __skb_queue_before(struct sk_buff_head *list,
>                                      struct sk_buff *next,
>                                      struct sk_buff *newsk)
> {
>        __skb_insert(newsk, next->prev, next, list);
> }

... because the next pointer is same as list so it is sk_buff_head instance 
which is smaller than sk_buff, but using next->prev is ok given the 
structure definitions.

Thanks for the confirmation regarding the line number in brcmfmac source.

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

--000000000000faee7805c9ec34eb
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
h9J/RI6gsHbuMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCCBbLwOKfy8QOFVq9Rk
S8JYFSnonxMrtZ/MjRVUZPZxTTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMTA4MTkxNjQwMjFaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAgVcWeqoKFRETufHG9zHuMjAHMvbvbgaPhxvl
58jOi05CRUZLPCSToTZqDliEK82sgMtGwiwjJmGAYsZRkpgPOMxogUPxBIwx1hUUUX2B1asHk7rB
hDYLwCZnoKtjn2Q+H0YE1lah21HbCIVc+FhLsWKTUwQDsCA+qY+mdZ30BY2olQPa4zOuU8B7hHgy
VZ2dbSf5NoaEDWNiZ3RJJ6Bo8lvDDdYuhv0yhxy5Eg5OtLkX4/5k+NLgW9C+a7v00dUwT8f6TXsP
e1ua9NT9kJ8rzNqjY4qXIsLsF2HjsoMvR+k3ow8bMw4TFRUBtFmBziphnOh/qvHtl3wW1PckSMKF
cw==
--000000000000faee7805c9ec34eb--
