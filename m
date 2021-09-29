Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56D341C3BD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245158AbhI2Ltd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:49:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245139AbhI2Ltb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:49:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632916070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e0hiCZ6MaoVErEiOVWX40x+hKPGxbYz9tFHdifG89+s=;
        b=RV8nHISaJjmmKjnkoit2VDiGBNk4UP/TQGGmTz+cQOWgHo+kyo50gkmpKveumauXXvQMSt
        36JO/MmV3FvxrqrFaaNkq33swKsJcJQ9wAtPePsEAkb+LUDUz/I/5VkG7D4MBF9yHIbAex
        OFyiTnw+AmSqOvW4tPAPfCr6GS7uBkM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146--0xQ5IWuNJy9nAy2G3unHA-1; Wed, 29 Sep 2021 07:47:48 -0400
X-MC-Unique: -0xQ5IWuNJy9nAy2G3unHA-1
Received: by mail-ed1-f72.google.com with SMTP id c8-20020a50d648000000b003daa53c7518so1819865edj.21
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 04:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e0hiCZ6MaoVErEiOVWX40x+hKPGxbYz9tFHdifG89+s=;
        b=0QZrjrPQdbj7H9VRfY/+OW5I4yvyMdhdYqBWbQnDvcNSEkmqp1sTwP4U24jMqdVW/w
         TIiZ7PenMCaazX2Pr6X6hXxmZ+znSQQu3hIHZCac2JmiHn9awNgw/wy0UF4qeYFZxIb2
         y64cCOpCYFJVhctZgMari5K/+jC8dd97JQkY29hMpGYzcYxkxrAaqI6lZ5khzWiRA7eo
         aF8gJE68cngoBiUBtH5sHpgYtBOM1fhaSEfBZtlTwFZDFQYfruKEdQQhQz+ag85NzdlW
         6Wf8yaDzEwLoP/wqciG17uRhn+FT8aun6V2+0SKxcE7Jnd21d3ZTlOShKqtsu6JCcThV
         Z/NQ==
X-Gm-Message-State: AOAM533c3xp9LRedGUX1cFJavZxJA8LNTaYoVQ7o60/vIpfqMhSghRbQ
        jvHv6QVpW2CqQ2ZCOYT05ueXaEy/BuZmxMy+dCXQCUiLh+HipbgnUD2Un0aZZBZYVXFAsDLeCwY
        xl1dorPpq008iTunn
X-Received: by 2002:aa7:db13:: with SMTP id t19mr8255903eds.339.1632916067322;
        Wed, 29 Sep 2021 04:47:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyksUISkDtOs7VCvoVSP6Qe34qy0BStdrgy5t2ER1Ar/N/ffAzOJ2ryHd0gpvIeD/h7cTyIhQ==
X-Received: by 2002:aa7:db13:: with SMTP id t19mr8255876eds.339.1632916067060;
        Wed, 29 Sep 2021 04:47:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lc2sm1261324ejb.21.2021.09.29.04.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 04:47:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 676A318034F; Wed, 29 Sep 2021 13:47:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
In-Reply-To: <CAADnVQJSjbQC1wWAf_Js9h47iMge7O3L8zmYh7Mu8j4psMBf7g@mail.gmail.com>
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
 <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
 <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
 <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com>
 <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com>
 <CAADnVQJSjbQC1wWAf_Js9h47iMge7O3L8zmYh7Mu8j4psMBf7g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 29 Sep 2021 13:47:45 +0200
Message-ID: <871r57k3ha.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Sep 22, 2021 at 6:49 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> At the same time Toke mentioned that he has a prototype of suck skb map.
>
> This is such an embarrassing typo :) Sorry Toke. s/suck/such/ in above.

Haha, managed to completely miss this; no worries, though, gave me a
good chuckle :)

-Toke

