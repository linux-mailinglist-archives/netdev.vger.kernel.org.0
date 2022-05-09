Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C7652035B
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbiEIRON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239471AbiEIROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:14:09 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B791F35DD
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:10:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gh6so28162965ejb.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 10:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vl8myjzNwEZeK704hoMQsnP8VuM2TQ7de5GnlL7YDw8=;
        b=X5RWlEzK1zznjcVmTGLDIDs+UVIH4FEqX/REq5YT7ejbA01wA60iGgTp69259E+zc9
         50zQdAoq17hz8W3n1J4H3BAhsQZp2gQfq2aHSsyKH9IignX9jBqM8ex0WGbnQZ6S1w4C
         th0/8qcn5v4DQOXH1jV9VxRLPj1RJNPpQ6+I+HZ7/pJiVvGVV9dQWebtUkkoWBAdFKCi
         FeI1Ip0aqmuvv/RsrsvKarQRd7HJtsfyMsPXKxPUcU+hq7frcxUiOl65t1MRzsftZ7xB
         lDAeTrrNuwqY0Bu1sWiFqbJHbbhhttlQedyQUGFCIpVoeM2UGTVoTd30RHjd4GdxOxuk
         zRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vl8myjzNwEZeK704hoMQsnP8VuM2TQ7de5GnlL7YDw8=;
        b=5uX34IWm6OwF0E/P7qieCIdEpxp4Q1BDYN7RcMr+nz7hog7qdzz8KJ3PSLVOdsO7Rk
         cN1tPNx5GeZ2AeRf82iLYohx0r+gPuMNptjnZaSmSw47B7VBwwXmeKnU+SJRqi49cUV1
         BaKlWnu95MFY52+IQu8JB9q+8DFFeZ1aBCAW6G/rN1Frjxee80m7XvF/Bodmq80TSeXz
         Fg+h0pevYsCYEmv/aFZY0CkfovYagpqF7h1GYZFsc9+ovLwcfm/33G5zYE8dh46Zu/+t
         QAlUi++B8Fj8iflOkYcgnWKkCbzar6+lc2n+vKSSIAmcyMvt0LDK1XqC4/oLb5Xcwn6J
         D04A==
X-Gm-Message-State: AOAM532VNA8MtV5v2rngA71/GeehSxGt8i/z7FQH6b+T6KkGcUp+6CQ5
        kdWZu+GEWtl5P/e/7/KYF/tusH9tbLko9JDdS6E=
X-Google-Smtp-Source: ABdhPJzwjGX77g1BpaDO8qjqH2y0VDeUGMOgFS71H3f8ttjJBEewdKxY21zMbzaJOzJtb5zPUZPEhaWofH3Cs8bBHY8=
X-Received: by 2002:a17:906:4787:b0:6f4:2f25:f9ff with SMTP id
 cw7-20020a170906478700b006f42f25f9ffmr16135826ejc.116.1652116210982; Mon, 09
 May 2022 10:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <06dc7df0afd344fc9aa656896e761d37@AcuMS.aculab.com>
In-Reply-To: <06dc7df0afd344fc9aa656896e761d37@AcuMS.aculab.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 9 May 2022 10:09:59 -0700
Message-ID: <CAA93jw5pYtaPuzbVm-sFF5_pWup7PmzE+4aV+hm04_K00nE3kQ@mail.gmail.com>
Subject: Re: High packet rate udp receive
To:     David Laight <David.Laight@aculab.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 10:01 AM David Laight <David.Laight@aculab.com> wrot=
e:
>
> I'm testing some high channel count RTP (UDP audio).
> When I get much over 250000 receive packets/second the
> network receive softint processing seems to overload
> one cpu and then packets are silently discarded somewhere.
>
> I (probably) can see all the packets in /sys/class/net/em2/statistics/rx_=
packets
> but the counts from 'netstat -s' are a lot lower.
>
> The packets are destined for a lot of UDP sockets - each gets 50/sec.
> These can't be 'connected' because the source address is allowed to chang=
e.
> For testing the source IP is pretty fixed.
> But I've not tried to look for the actual bottleneck.
>
> Are we stuck with one cpu doing all the ethernet, IP and UDP
> receive processing?
> (and the end of transmit reaping).
> Or is there a way to get another cpu to do some of the work?
>
> Since this is UDP things like gro can't help.
> We do have to handle very large numbers of packets.
>
> Would a multi-queue ethernet adapter help?
> This system has a BCM5720 (tg3 driver) which I don't think is multi-Q.
>
> OTOH I've also had issues with a similar packet rate on an intel
> nic that would be multi-q because the interrupt mitigation logic
> is completely broken for high packet rates.
> Only increasing the ring size to 4096 stopped it dropping packets.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)
>

In general I favor larger rx rings these days as linux presently seems
to be very batchy on rx.
--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
