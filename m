Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BDF52D060
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiESKVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiESKVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:21:12 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04E5A1B0
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:21:10 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id n10so4261733qvi.5
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ExjCWz+7+BoRJKK4CyQ5ia+7kTKhO4BWmQIONXixiZM=;
        b=RnDJBeEGBqYZoL33kwhYJ4f+cYjE0u6ZhyAf1APCrejBlTTRTOcMYHWXeRY77a66k4
         PeyYvxQ1jYc0Wf/5CeXACOqyU+5xbT9mo6vxN7qGVgMH1lU/N8LYXC291rP96v4CCsgj
         vPIZFHFiVTO4kxkIFQVpk0wFwVe4Kgm1QX4jY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ExjCWz+7+BoRJKK4CyQ5ia+7kTKhO4BWmQIONXixiZM=;
        b=w0WoBBYCA+ErgfoJ7dAZ5Ve3iPgsrlMIBsRfzwVS7TojPjnNr4KwenUe4ATZk1KqZN
         xTxMGF4A7i6XlIewgrFm8SIZelPoXj5l1yd7Kjz13AH9MeUM4RUDWxUAuaoZblD8O5/m
         x9M1IUDCgxdUcu/c1b2O467kqQRkjDR3NyasoRn+f5ACZV+19Egj4FJZsyZnvHK1eWXj
         KfvmtR4dq/zAqIyIGxm4mImqLYzYvTLKpQgAkIpq9BYFQMYIyN1IPHztoxMwvKTLKj+V
         rjeQPakFo2ptTsIXjPJOy8nuGvp1QN2YaEhNoi3lr2guYziDhP8mBp3JBGGaoo72AVOG
         0aqg==
X-Gm-Message-State: AOAM533tTqfZEbSk/XvKiJd4aLdBwE/eXfhTKQN0DA8mrHLQ+8vQj27B
        B6ha26VBJt//W5p6E24Pd12RNnISqaRFA6lX2VkATw==
X-Google-Smtp-Source: ABdhPJw+byJNOCDwl74cxhTFxc7X9bC9Pb2gqft4/wBnBVk1nCJEyJ9wk3dqsLDfBUuN6nvVnQO4inxB5R/24ruajbY=
X-Received: by 2002:a05:6214:2a4:b0:461:c636:f9fc with SMTP id
 m4-20020a05621402a400b00461c636f9fcmr3004656qvv.72.1652955669980; Thu, 19 May
 2022 03:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com> <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
 <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
In-Reply-To: <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 19 May 2022 15:50:58 +0530
Message-ID: <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
Subject: Re: tg3 dropping packets at high packet rates
To:     David Laight <David.Laight@aculab.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008dcf6905df5abb16"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008dcf6905df5abb16
Content-Type: text/plain; charset="UTF-8"

On Thu, May 19, 2022 at 2:14 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Michael Chan
> > Sent: 19 May 2022 01:52
> >
> > On Wed, May 18, 2022 at 2:31 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Paolo Abeni
> > > > Sent: 18 May 2022 18:27
> > > ....
> > > > > If I read /sys/class/net/em2/statistics/rx_packets every second
> > > > > delaying with:
> > > > >   syscall(SYS_clock_nanosleep, CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL);
> > > > > about every 43 seconds I get a zero increment.
> > > > > This really doesn't help!
> > > >
> > > > It looks like the tg3 driver fetches the H/W stats once per second. I
> > > > guess that if you fetch them with the same period and you are unlucky
> > > > you can read the same sample 2 consecutive time.
> > >
> > > Actually I think the hardware is writing them to kernel memory
> > > every second.
> >
> > On your BCM95720 chip, statistics are gathered by tg3_timer() once a
> > second.  Older chips will use DMA.
>
> Ah, I wasn't sure which code was relevant.
> FWIW the code could rotate 64bit values by 32 bits
> to convert to/from the strange ordering the hardware uses.
>
> > Please show a snapshot of all the counters.  In particular,
> > rxbds_empty, rx_discards, etc will show whether the driver is keeping
> > up with incoming RX packets or not.
>
> After running the test for a short time.
> The application stats indicate that around 40000 packets are missing.
>
> # ethtool -S em2 | grep -v ' 0$'; for f in /sys/class/net/em2/statistics/*; do echo $f $(cat $f); done|grep -v ' 0$'
> NIC statistics:
>      rx_octets: 4589028558
>      rx_ucast_packets: 21049866
>      rx_mcast_packets: 763
>      rx_bcast_packets: 746
>      tx_octets: 4344
>      tx_ucast_packets: 6
>      tx_mcast_packets: 40
>      tx_bcast_packets: 3
>      rxbds_empty: 76
>      rx_discards: 14
>      mbuf_lwm_thresh_hit: 14
> /sys/class/net/em2/statistics/multicast 763
> /sys/class/net/em2/statistics/rx_bytes 4589028558
> /sys/class/net/em2/statistics/rx_missed_errors 14
> /sys/class/net/em2/statistics/rx_packets 21433169
> /sys/class/net/em2/statistics/tx_bytes 4344
> /sys/class/net/em2/statistics/tx_packets 49
>
> I've replaced the rx_packets count with an atomic64 counter in tg3_rx().
> Reading every second gives values like:
>
> # echo_every 1 |(c=0; n0=0; while read r; do n=$(cat /sys/class/net/em2/statistics/rx_packets); echo $c $((n - n0)); c=$((c+1)); n0=$n; done)
> 0 397169949
> 1 399831
> 2 399883
> 3 399913
> 4 399871
> 5 398747
> 6 400035
> 7 399958
> 8 399947
> 9 399923
> 10 399978
> 11 399457
> 12 399130
> 13 400128
> 14 399808
> 15 399029
>

I see that in a span of 15 seconds, the received packets are 4362 less
than what you are expecting (considering 400000/s avg)
In what time period did the application report 40000 missing packets?
Does it map to about 150 seconds of test time?
The error counters do not look suspicious at this point for the
reported problem.
Do you see this problem with any other traffic pattern?

> They should all be 400000 with slight variances.
> But there are clearly 100s of packets being discarded in some
> 1 second periods.
>
> I don't think I can blame the network.
> All the systems are plugged into the same ethernet switch on a test LAN.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

--0000000000008dcf6905df5abb16
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDEdgvFOHITddmlGSQTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDE5NDZaFw0yMjA5MjIxNDUzMjhaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFBhdmFuIENoZWJiaTEoMCYGCSqGSIb3DQEJ
ARYZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAN3mGiXPVb6+ePaxZyFGa/u3ZQh4rPCPD3Y8Upnh+EXdw4OgeXtu+l2nXqfB7IXOr2pyGzTe
BnN6od1TYmyK+Db3HtaAa6ZusOJXR5CqR3Q3ROk+EiRUeIQBesoVvSLiomf0h0Wdju4RykCSrh7y
qPt77+7MGWjiC6Y82ewRZcquxDNQSPsW/DztRE9ojqMq8QGg8x7e2DB0zd/tI9QDuVZZjeSy4ysi
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICiep8SUP5olyFw85rdsjd4amK3AJ6Ci
1GLNS1cFtCYGMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUx
OTEwMjExMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDN6NTEaTnmzu6fyeQ8SUIFL/Jc3PBCdwxSP8VhVWoYhAEQbnMk
hAbOwf3zg/tD+qf+K5Skuu9voTdhALF1Wj5SV076SXa0fdR0yPG/mesK1RJEDrep27FWApQURnvx
tKXNJyZaEbG/f+6A8LtU4sJYtDIWKJc1P+KXZIv6jYpdd4YIesl06Uvy6/YbvC1gEXP0nbuU9Vwj
u+7pbtGVu0To8YrsYywHB0EXYsTudUiAmRPMjkJdHvYfjANkWxAXJq0ZZ/PhjWmy+UREA3p+SHz6
8gisG3+6VM/5RTlBeas3iIizkFWWWrkDvkKDhsR5wl2z7E0EVF/idlxuhSEgvOWb
--0000000000008dcf6905df5abb16--
