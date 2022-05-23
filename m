Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532BD53148D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238407AbiEWQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiEWQPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:15:12 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1523164D37
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:15:11 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id dm17so12444676qvb.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nh41VRF5eMFPclr5Q+CgI2NOjfnCpL2B/IOAqCv96zI=;
        b=X2kXkbfZGr8GB6N0y9+dt1mQzbfQFeLkzyWtOBHrw6iT32I7LJRtLdBFEvA8gFUjc1
         EsHN6LOuz4xXgbwx2KOr53p5jx3bIhkaamV+7cHHjftpHKDxda3IpQuSIIPP4rT9F+4C
         JahltF1ljW/yk2nrq+VrKYjaRl2a9Me2D854k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nh41VRF5eMFPclr5Q+CgI2NOjfnCpL2B/IOAqCv96zI=;
        b=kX8OJYgbvc9vTEWSFATaztdXroQ2sb6bzc1EY07eXBiMej2Q12Wno0Nwj3gRj5jK5j
         OixmfoEAjTEehk9tsjwLTTC+FtOb2SE/JiPkVezx76MdJ45IRm+c/Wx1pOICA6KcUvts
         x9nnlLw5hOlXmQ+IBJKItsnywf9bxKJe/3To05D7wzWNe0q0AFjBKh7t34Ao4atpaQKX
         Ia1PARP432Ti1rWzWaG54lghe7zVqCUXwVR8G4ROEGUWdo4Zdbazv9oERruc5l1gQ9Io
         qZb5CXIN1lGHcMp2lsYQvPI+jWRafXt/XFwmrlEDIs+Dc0GT9v2Lw0nH2pNWV4nsD53I
         8x7A==
X-Gm-Message-State: AOAM533szQHxtxmrRWkS0cS2O43MUYfXoT/gDSCh1oQnfx+LJspHrsA+
        5vFo95idC4A2lxASsQCUSCZriNDFH4YDLfcN3zJPag==
X-Google-Smtp-Source: ABdhPJysciQG4ha1gD1vL8P1+mTTmngn2fqPPemnjXtQS0n81RloqDRwoYotTv8NGszDpXdEkznueHLZQEuTfka3TVA=
X-Received: by 2002:a0c:ea34:0:b0:456:319f:f3aa with SMTP id
 t20-20020a0cea34000000b00456319ff3aamr17890638qvp.18.1653322510157; Mon, 23
 May 2022 09:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com> <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
 <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com> <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
 <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com> <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
 <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com> <CALs4sv2M+9N1joECMQrOGKHQ_YjMqzeF1gPD_OBQ2_r+SJwOwQ@mail.gmail.com>
 <1bc5053ef6f349989b42117eda7d2515@AcuMS.aculab.com> <ae631eefb45947ac84cfe0468d0b7508@AcuMS.aculab.com>
 <9119f62fadaa4342a34882cac835c8b0@AcuMS.aculab.com>
In-Reply-To: <9119f62fadaa4342a34882cac835c8b0@AcuMS.aculab.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Mon, 23 May 2022 21:44:58 +0530
Message-ID: <CALs4sv13Y7CoMvrYm2c58vP6FKyK+_qrSp2UBCv0MURTAkv8hg@mail.gmail.com>
Subject: Re: tg3 dropping packets at high packet rates
To:     David Laight <David.Laight@aculab.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ef31cf05dfb02454"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ef31cf05dfb02454
Content-Type: text/plain; charset="UTF-8"

From the register dump we can see that your device is 5720-A0.
There is a patch that was applied long time ago:
4d95847381228639844c7197deb8b2211274ef22- tg3: Workaround rx_discards stat bug

This patch could be making the rx_discards count not report the actual discards.
You can see the actual discards if you monitor the register at 0x2250,
which I think matches with
your application report. Can you test this and confirm?

We can also see from your register dump shared earlier that the Flow
Attention Register at 0x3C48 is indicating
bit 6 set. That means the MBUF allocation state machine has reached
mbuf low water threshold.
In summary at this point it appears like the host cannot keep up with
incoming traffic.


On Mon, May 23, 2022 at 9:31 PM David Laight <David.Laight@aculab.com> wrote:
>
> Ok todays test is calling tracing_off() when the napi callback
> has more than 1000 packets queued.
>
> This is rather informative.
> Just taking the trace for cpu 32 and shortening the lines somewhat
> gives the following.
>
> <idle>-0  6.594695: irq_handler_entry: irq=87 name=em2-rx-2
> <idle>-0  6.594695: napi_schedule_prep <-tg3_msi_1shot
> <idle>-0  6.594695: __napi_schedule <-tg3_msi_1shot
> <idle>-0  6.594695: irq_handler_exit: irq=87 ret=handled
> <idle>-0  6.594695: softirq_entry: vec=3 [action=NET_RX]
> <idle>-0  6.594696: napi_schedule_prep <-tg3_rx
> <idle>-0  6.594696: __napi_schedule <-tg3_rx
> <idle>-0  6.594697: napi_poll: napi poll on napi struct 06e44eda for device em2 work 1 budget 64
> <idle>-0  6.594697: softirq_exit: vec=3 [action=NET_RX]
> <idle>-0  6.594697: softirq_entry: vec=3 [action=NET_RX]
> <idle>-0  6.594698: napi_poll: napi poll on napi struct 909def03 for device em2 work 0 budget 64
> <idle>-0  6.594698: softirq_exit: vec=3 [action=NET_RX]
> <idle>-0  6.594700: irq_handler_entry: irq=87 name=em2-rx-2
> <idle>-0  6.594701: napi_schedule_prep <-tg3_msi_1shot
> <idle>-0  6.594701: __napi_schedule <-tg3_msi_1shot
> <idle>-0  6.594701: irq_handler_exit: irq=87 ret=handled
> <idle>-0  6.594701: softirq_entry: vec=3 [action=NET_RX]
> <idle>-0  6.594704: napi_schedule_prep <-tg3_rx
> <idle>-0  6.594704: __napi_schedule <-tg3_rx
> <idle>-0  6.594705: napi_poll: napi poll on napi struct 06e44eda for device em2 work 3 budget 64
> <idle>-0  6.594706: softirq_exit: vec=3 [action=NET_RX]
> <idle>-0  6.594710: irq_handler_entry: irq=87 name=em2-rx-2
> <idle>-0  6.594710: napi_schedule_prep <-tg3_msi_1shot
> <idle>-0  6.594710: __napi_schedule <-tg3_msi_1shot
> <idle>-0  6.594710: irq_handler_exit: irq=87 ret=handled
> <idle>-0  6.594712: sched_switch: prev_pid=0 prev_prio=120 prev_state=R ==> next_pid=2275 next_prio=49
> pid-2275  6.594720: sys_futex(uaddr: 7fbd2bfe3a88, op: 81, val: 1, utime: 1064720, uaddr2: 0, val3: 27bea)
> pid-2275  6.594721: sys_futex -> 0x0
> pid-2275  6.598067: sys_epoll_wait(epfd: 61, events: 7fbd2bfe3300, maxevents: 80, timeout: 0)
> pid-2275  6.598747: sched_switch: prev_pid=2275 prev_prio=49 prev_state=S ==> next_pid=175 next_prio=120
> pid-175   6.598759: sched_switch: prev_pid=175 prev_prio=120 prev_state=R ==> next_pid=819 next_prio=120
> pid-819   6.598763: sched_switch: prev_pid=819 prev_prio=120 prev_state=I ==> next_pid=175 next_prio=120
> pid-175   6.598765: softirq_entry: vec=3 [action=NET_RX]
> pid-175   6.598770: __napi_schedule <-napi_complete_done
> pid-175   6.598771: napi_poll: napi poll on napi struct 909def03 for device em2 work 0 budget 64
>
> The first few interrupts look fine.
> Then there is a 4ms delay between the irq_handler caling napi_schedule()
> and the NET_RX function actually being called.
>
> Except that isn't the actual delay.
> There are 3 relevant napi structures.
> 06e44eda (horrid hash confusing things) for the rx ring of irq=87.
> xxxxxxxx (not in the above trace) for the other active rx ring.
> 909def03 for em2-rx-1 that is also used to copy used rx descriptors
> back to the 'free buffer' ring.
>
> So the normal sequence is the hard_irq schedules the 'napi' for that ring.
> Max 64 packets are processed (RPS cross schedules them).
> Then the 'napi' for ring em2-rx-0 is scheduled.
> It is this napi that is being reported complete.
> Then the em2-rx-2 napi is called and finds 1000+ items on the status ring.
>
> During the 4ms gap em2-rx-4 is being interrupted and the napi is
> processing receive packets - but the shared napi (909def03) isn't run.
> (Earlier in the trace it gets scheduled by both ISR.)
>
> pid 175 is ksoftirqd/32 and 819 kworker/32:2.
> pid 2275 is part of our application.
> It is possible that it looped in userspace for a few ms.
>
> But the napi_schedule() at 6.594704 should have called back as
> 909def03 immediately.
>
> I've got a lot more ftrace - but it is large and mostly boring.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

--000000000000ef31cf05dfb02454
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILbcIoSRX7koBV9qVNJMDiXIq2XOrG/F
vCfawoz5OGjhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUy
MzE2MTUxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBuGgbjqWDbINvakSRL3jd+yHmh1rIQkI2XC7xW1o4iUzqYtB5s
Duf1C50ELSLR0Mz8/rLGtkaVjKUUCW/5rF4swKj0977FKMD7ygBu5qWRfcZszrSvgmexgT5pRiGb
16MKVFOC6aK3t+0K+BAVCrXG1wMJdAKv9pjM0viSvjLCm3WZmmBkBPHP8yKlJLWcmzUBBkYXYgTS
9KuTg0mmR0maTqOzUo7/AempgL/PkN/zhcylCnglnS5Bw3E+4/aupQt5+ez4q2tlvnXJZBoMsPeG
LeU+UEspwthw++znZRk1QdQpqr+OfQNGL+AB/NBGWH/cWbHEQhyr6E1Wd79FijKf
--000000000000ef31cf05dfb02454--
