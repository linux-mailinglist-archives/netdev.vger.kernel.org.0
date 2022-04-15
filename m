Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48B650310B
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiDOWHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 18:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiDOWHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 18:07:03 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8164E193E4
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 15:04:33 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id bn33so10734739ljb.6
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 15:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UjWq5GSJRSakthqVM5tmIM2a+e/ojUhA4a1Oq61RZ+M=;
        b=Lhl4IQLYHvZIMiYRBY9LMQOe7ZXADWBvzrgaltAp5vr6ME6XD1cFDpgx5gmlQnv3vq
         2I9CV3ihB58nWJSaXF9LLIi8ZInllmYi53uZTAw9ockb8emAJotNoKdgwJUHQqbbX9NG
         KKvyhwHNqLJVXykHvLSukTIchMbo10B9vcnRfuBq0PKQNN+v6Tm0D/FGNV6zTke1FtHj
         cP3dcBkQ9/PH3MP8Sn7YjfJ6Y8f4pL9/ReLUxL7Gdt3C82IycymQWuZs6q6W7Cqf9KYk
         JVWtptC92bawKDL0navlb/xocnJO9IIVUAWCL5y9ySMs6ic7Zq692RbTH/6sSwZM/cE1
         zWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UjWq5GSJRSakthqVM5tmIM2a+e/ojUhA4a1Oq61RZ+M=;
        b=V62Mpkv3o7pGLoqFiMV0JCoB/FhUHgjhmVM/tLfbarvVoMkw8awK6TCrTHf3Nm0LC8
         ZJ97ycZsGYnX94Lh2R8HhePGsbWeZqRGOF7aozbueGTMQLIZ40iQ+NxUNqt1SJayFqOm
         MU1n63kHOjHeUai2zpligoDOz3f/hp7YF3c/qZ+4BUMwvk5CGJ16wZIIHq6Tvkn7lsde
         FN5ClAy7wmYbPpI/0a0lmIhIaAp4R6bCuvChmmplOmmATlCXDLwfv1gqAtpvlDougZzx
         qm4s1el0bi7LwiHTq9FZw4oHit8+t52OuANbZ9PKRLeW69dB+WEc5nnV4W+itjcMqdVd
         tjLA==
X-Gm-Message-State: AOAM531KJvbh/bu7xZ8UZQlz27zlLssf961zkI8bQOz31Iq7dtrEMdMm
        vQZul7tTqk0OtsWLFZxWgBCvgFh5xyQXVOGPqpMaew==
X-Google-Smtp-Source: ABdhPJzotPEtPcjiFGRG/9Jf1YWrMW0QQ39f1sDmIFQXTwZeOPyLx5qAV54b1gIIu/7QDV8YuKObwKTAyWiDK2xE2fM=
X-Received: by 2002:a05:651c:546:b0:24d:a9fa:7088 with SMTP id
 q6-20020a05651c054600b0024da9fa7088mr625761ljp.96.1650060271664; Fri, 15 Apr
 2022 15:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com> <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org> <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com>
 <20220412214655.GB579091@hoboy.vegasvil.org> <CANr-f5zLyphtbi49mvsH_rVzn7yrGejUGMVobwrFmX8U6f2YVA@mail.gmail.com>
 <20220414063627.GA2311@hoboy.vegasvil.org>
In-Reply-To: <20220414063627.GA2311@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sat, 16 Apr 2022 00:04:20 +0200
Message-ID: <CANr-f5zzQ6_UsOdLZK7b-k5Jy4qhdGJ4_D2irK-S0FzhE5u3rQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > For igc and tsnep the 16 bytes in front of the RX frame exist anyway.
> > So this would be a minimal solution with best performance as a first
> > step. A lookup for netdev/phc can be added in the future if there is
> > a driver, which needs that.
>
> It is a design mistake to base new kernel interfaces on hardware
> quirks.
>
> > Is it worth posting an implementation in that direction?
>
> Sure, but please make thoughts about how this would work for the
> non-igc world.
>
> IIRC one of the nxp switches also has such counters?  You can start
> with that.

I did some measurements (A53, 1.2GHz): netdev lookup and call to
my driver takes ~400ns. ptp_convert_timestamp() takes ~6000ns, I
assume because of class_find_device_by_name() call. So eliminating
the netdev lookup is the wrong optimisation target.

I will try to do it like that:

- normal, driver without cycles support:   use hwtstamps->hwtstamp
directly (not changed)
- driver with cycles support:   netdev lookup for address/cookie
conversion to hwtstamp (newly implemented)
- vclock:   slow path with phc lookup (not changed)

Gerhard
