Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D86568AA8
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiGFOCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiGFOCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:02:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F56D13FAF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657116126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PT0ecxKz8+1DU81mR0Y9SlpR1EbJt2TNMRE9j1Wvwbw=;
        b=I8cWEqHsp+RFLQEUwNGZw2J4v612lwMELy/Q9IIoD6snWQ3mV5XMdvaD0X+afHh9ku+Aq3
        u2UBbdlveJ0ljxJ/XR1o495xRZ/jLOwtiyTgjEatg1foaYsbdai3gIynYX2Xon7irF50o+
        y1V0JNSFJsiVJqLSCT8fbUQ0C2oaeVQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-TmYmH2OxMFSAM0vzZ6DQxg-1; Wed, 06 Jul 2022 10:02:01 -0400
X-MC-Unique: TmYmH2OxMFSAM0vzZ6DQxg-1
Received: by mail-qt1-f198.google.com with SMTP id m6-20020ac866c6000000b002f52f9fb4edso12408658qtp.19
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 07:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PT0ecxKz8+1DU81mR0Y9SlpR1EbJt2TNMRE9j1Wvwbw=;
        b=30cSA9zD/NGNJ9vRs+WW8gRjRd2trRpk6fXjaIPFkTdIPHJuAhxW7bU2592CjjX82X
         pCdtDBGK5koBYSECIIAj0wAXOee3jhQ95ApbcoyxD01oku/cl6kkE0w4fyVK7xSVhZtw
         sffn9AygZ48StHup+mWIwFUazO9oDuz1Xww51L1CqanLDRNLVM36byDbB1yu9kgwgzc7
         sJn8uHmwCSgOTX1VFcP6lA8yrTafsBlFJ4OebsdyCrT20pswJx5eGito8vunb4aawqGG
         rykYNOwmWbmdvLazpj28RK37ucEebZf3W7gY5XiBon++KBGtqutuRdhht+U2mP/5vZk9
         mYQg==
X-Gm-Message-State: AJIora9VqBC3g/wIbtWx+TJ2IbehvX6M7SWm0lV/gPYBURGKbkqsmqgL
        YyvfjhpKG85Co18BBPVF/g6soOoqhbY1RRODBkX60cJEiyyk1QECO0JID0OoSw+Vat6atllxowy
        U6X8ELs4F6RraCqiD
X-Received: by 2002:a05:622a:1010:b0:31d:3789:bf17 with SMTP id d16-20020a05622a101000b0031d3789bf17mr23129517qte.180.1657116120485;
        Wed, 06 Jul 2022 07:02:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1srdkKZ2I7G4mnfqtYuH/hEhrjNSIzuW1eRlEfLFoSV0aOtiJENVtFgM+Y/v+bcPvwzbL/HhQ==
X-Received: by 2002:a05:622a:1010:b0:31d:3789:bf17 with SMTP id d16-20020a05622a101000b0031d3789bf17mr23129440qte.180.1657116119882;
        Wed, 06 Jul 2022 07:01:59 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id a186-20020a3766c3000000b006a37c908d33sm29185369qkc.28.2022.07.06.07.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 07:01:59 -0700 (PDT)
Message-ID: <2c4816a4f5fbd5c8f4f6ad194114d567830de72d.camel@redhat.com>
Subject: Re: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?UTF-8?Q?=EC=84=9C=EC=84=B8=EC=9A=B1?= <ssewook@gmail.com>
Cc:     Sewook Seo <sewookseo@google.com>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Date:   Wed, 06 Jul 2022 16:01:55 +0200
In-Reply-To: <CAM2q-ny=r-U-6n6F+02QON1B8NHJ5TZrrOa7x3CAfkrUtRWnwQ@mail.gmail.com>
References: <20220621202240.4182683-1-ssewook@gmail.com>
         <20220701154413.868096-1-ssewook@gmail.com>
         <7dc20590ff5ab471a6cd94a6cc63bb2459782706.camel@redhat.com>
         <CAM2q-ny=r-U-6n6F+02QON1B8NHJ5TZrrOa7x3CAfkrUtRWnwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello,
On Wed, 2022-07-06 at 03:10 +0000, 서세욱 wrote:
> On Tue, Jul 5, 2022 at 5:25 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > If you are targting net, please add a suitable Fixes: tag.
> I'm targeting net-next, and will update the subject.
> 
> > It looks like the cloned policy will be overwrited by later resets and
> > possibly leaked? nobody calls xfrm_sk_free_policy() on the old policy

> Is it possible that a later reset overwrites sk_ctl's sk_policy? I
> thought ctl_sk is a percpu variable and it's preempted. Maybe I might
> miss something, please let me know if my understanding is wrong.

I mean: what happesn when there are 2 tcp_v4_send_reset() on the same
CPU (with different sk argument)?

It looks like that after the first call to xfrm_sk_clone_policy(),
sk_ctl->sk_policy will be set to the newly allocated (cloned) policy.

The next call will first clear the sk_ctl->sk_policy - without freeing
the old value - and later set it again. 

It looks like a memory leak. Am I missing something?

Thanks!

Paolo

