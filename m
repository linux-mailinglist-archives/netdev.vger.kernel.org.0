Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1A952D635
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbiESOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbiESOgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:36:07 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C42237C7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:36:03 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id l82so135568qke.3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5K47+VWuf1vthmWmNwtCIX+WJ6HK9Gj3DxuzkseX7oo=;
        b=IcpkzvX/hAcNVT83ULhOWInLIYts2t/cvZn49nYR0fp0QQliH02si0cLv8RyIId7yv
         phlp9hCsGobyqAJ1tEXfbT97dCYEGBiufHHM6XqChABC+bTDVWZ1RJQ2klZ3JoU+XLKf
         lS0AxD8BnZBPB3JpN6acfJDJ0D+jheJ6rNW/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5K47+VWuf1vthmWmNwtCIX+WJ6HK9Gj3DxuzkseX7oo=;
        b=UG5TLX8iOlMM+S1fU5RGHmEUFN121STg28z7JKqYM1dPjIYRrM3UHQigZYA8zv0UQD
         CkLo6f3OAeSvxXOwRH+9nOaoeqD0qmZn9dwNSSJ7P3G/YjmgSWteS5OoJ5nquOhySDxO
         NYba7Ywudcysibkfhf2zsd4B0fuYjq9+cRme812MW9RV2JPqddPYtMzLMuJQyq9ejOEz
         G0nSeIw4TPSdqwC2HNhWsMEoVzjPOP60wyFhObRT/7NzItO/0df9pnEbEJtYGT+3IPpb
         fPlP29efzNYFu/2p4fMsdmToN1lp8Az2qsURnPHKJqYFr/2YVj0zz/wV4XjHgqMP/50c
         fMbg==
X-Gm-Message-State: AOAM532mu5PolwCRIZpY6g7ZT3YSIy2d5fQsBIJ7SxnDRxYwH5tS/wK1
        p1NUjEx/EASazkfuXsfuMkX9Ps+LxYtBQAr/MpAijA==
X-Google-Smtp-Source: ABdhPJxBoV0LRZ1pOw/xOBMf5pnB9z/pEUaGk+yeMTQqpbEoi6xivWmLRGkNlzmxRge3CdKnsaCEubYZAwYkTbHa/RM=
X-Received: by 2002:a05:620a:14b2:b0:69f:9cc3:a6df with SMTP id
 x18-20020a05620a14b200b0069f9cc3a6dfmr3212976qkj.406.1652970962238; Thu, 19
 May 2022 07:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com> <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
 <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com> <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
 <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com> <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
 <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
In-Reply-To: <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 19 May 2022 20:05:49 +0530
Message-ID: <CALs4sv2M+9N1joECMQrOGKHQ_YjMqzeF1gPD_OBQ2_r+SJwOwQ@mail.gmail.com>
Subject: Re: tg3 dropping packets at high packet rates
To:     David Laight <David.Laight@aculab.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000c364705df5e4b36"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000c364705df5e4b36
Content-Type: text/plain; charset="UTF-8"

On Thu, May 19, 2022 at 7:41 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Paolo Abeni
> > Sent: 19 May 2022 14:29
> ....
> > If the packet processing is 'bursty', you can have idle time and still
> > hit now and the 'rx ring is [almost] full' condition. If pause frames
> > are enabled, that will cause the peer to stop sending frames: drop can
> > happen in the switch, and the local NIC will not notice (unless there
> > are counters avaialble for pause frames sent).
>
> The test program sending the data does spread it out.
> So it isn't sending 2000 packets with minimal IPG every 10ms.
> (I'm sending from 2 systems.)
>
> I don't know if pause frames are enabled (ethtool might suggest they are).
> But detecting whether they are sent is another matter.
>
> In any case sending pause frames doesn't fix anything.
> They are largely entirely useless unless you have a cable
> that directly connects two computers.
>
> > AFAICS the packet processing is bursty, because enqueuing packets to a
> > remote CPU in considerably faster then full network stack processing.
>
> I have taken restricted ftrace traces of the receiving system.
> Not often seen more than 4 frames processed in one napi callback
> Certainly didn't spot blocks of 100+ that you might expect
> to see if the driver code was the bottleneck.
>
> > Side note: on a not-to-obsolete H/W the kernel should be able to
> > process >1mpps per cpu.
>
> Yes, and, IIRC, a 33Mhz 486 can saturate 10MHz ethernet with
> small packets.
>
> In this case the cpu are almost twiddling their thumbs.
>   model name      : Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz
>   stepping        : 2
>   microcode       : 0x43
>   cpu MHz         : 1300.000
> cpu 14 (the one taking the interrupts) is running at full speed.
>
> cpu doesn't seem to be the bottleneck.
> The problem seems to be the hardware not using all the buffers
> it has been given.
>

When this happens, can you provide the register dump that you can
obtain using ethtool -d ?

>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

--0000000000000c364705df5e4b36
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
MjHtaKp4bqyoZGmz/QLIf3iYE8N/j4l3nASfKLlxomJthuh0xS34f5+M+q361VT2RQFR2ZNQFb7f
u2AmJ7NZqhqVl/nlRPbwLl/nxV03XFhDLEhyLbRKuG8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUW6H0m/TK4GBYA6W3b8Soy869
jBwwDQYJKoZIhvcNAQELBQADggEBADBUMB9YQdlXyJbj8JK/hqrxQKEs3OvpoVm65s7Ws/OD1N+T
t34VwsCr+2FQPH693pbmtIaWRVg7JoRBb+Fn27tahgcRLQeJCU33jwM0Ng3+Jcyh/almUP+zN7a1
K8FRTPOb1x5ZQpfNbAhen8hwr/7uf3t96jgDxt4Ov+Ix86GZ0flz094Z/zrVh73T2UCThpz1QhxI
jy7V2rR7XHb8F3Vm33NlgRSS4+7FwV5OVWbm+PNNQDrlTBAl6PobGqt6M3TPy6f968Vr1MB2WgqW
8MnI3cvZy6tudQ1MhGmfYpx8SlvXhhwkWwhXeW7OkX3t6QalgNkliqzXRifAVFHqVrkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxHYLxThyE3XZpRkkEw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKkwE4VqkSoKmasyI8vBW2dbAgwaeTF0
jjVf7dYdale+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUx
OTE0MzYwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCZZpRubTUjlhCx+p41mOlYNJjqF75xBNXRVFhs7kCsBarshjdq
3WpoAubctkSU1R8uQtyH0BsUByytowIDlaIFbHoX6bkf5PxkhNIYD2cznRvR/J8eM7bGednwXepz
WxQO2l191w7tw4VtGXIkd12DvWjpKWELznsdVQVZvEuJsDH98hMBmHLCRhUqdEP3GXbVFTXEDW+S
InIqwyBfpnBQp7TsSfFS46xC5uB0/4HctVutVwJedNd/yh6Xv333CGLZzvY01UxYqrCcTqp3mQk1
3bJvHC+Bi6fV66LmTWlZYWy2mOKyni6YfeL+jA3zTFdKYMbgnZ6yhLi5h3Gr6SZQ
--0000000000000c364705df5e4b36--
