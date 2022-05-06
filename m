Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288FE51E189
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444661AbiEFWFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444660AbiEFWFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:05:37 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5545666C91
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:01:52 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l18so16777224ejc.7
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 15:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sxZict+kX+TGvY+Zczra/BZoZXRnDH1pvRFjX8hUlpU=;
        b=SVtGkUsDHZeRslk7hTuw/Rw2e8RiibfIHWaaijVtpYD7t5pejl280t57tXJQw767qH
         vL+KiuCNMLJcyd4jvc3xOa5xvOlFbGS4siMLgWCfIhsdM4ZlS9uOpuYxh599RB5s6BqD
         kRlVkvUYUx3+QoY5ckeoWxo8unttLlfbeEOp7Ja8F7JfwUibYkvEfWctaUvNnH4AJ3ON
         AqUKjkHr+tyYcGiNVvTjIgaFAmKH9FMl0MRRExpDxVWXPQjm9HQFhn08wwH2rYbSxE4J
         r5WLGpO0pvjGnvbRlfDhbNtD7LpF7k6foyWTeYgEChmS48gBcaApOEJq6b1xbYyZ/G1o
         OS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sxZict+kX+TGvY+Zczra/BZoZXRnDH1pvRFjX8hUlpU=;
        b=Dg41GhdlXBPYkO27zqOPYhGlUw1C4pY2eZ+cC4Jh8V4g3IaCMlwiuC/Ir4oCSWCbpI
         sy1RYl6D801laTMpaWmiobhIJleAoZcyQlzJbP7buSJJa/suof7i1XO0GUcAjwPDccTX
         Pt/gA1pcN08ZWTM51QNTmUH0oTpDuixl2ozPb0iwtpq03Y/zWYhCCBHFNVauHtANsojZ
         mug1Nw/Ubx5joR20zmf5o0+4yBU7/ZzZ3wnzUP+xoCLCghdNKDsU8hvS2bFC+EuN6mCb
         eiX9skVscRBMkjmjEkK2QtSBA9yhlxPsNGdA2hkM+INW8ySTOq1o924hJN7eMt0U5REg
         sB6g==
X-Gm-Message-State: AOAM531ipot1JQiAhYSzAjOjX0KrhkfS2B4K78RoZzVgH3cPymn1huSZ
        5BAu4PrMVN3yfnAm1Zj7WW6TFAINrx84r2KwTdY=
X-Google-Smtp-Source: ABdhPJwHmlNlzzHPuw5WCB0RDzlKYUBIQxUZcnH/6/WJk1z1bM0mDL2PVhs4L7sDbJS+Cai2+kBoD7tEs3kx/Dw+yBg=
X-Received: by 2002:a17:907:62a1:b0:6da:7952:d4d2 with SMTP id
 nd33-20020a17090762a100b006da7952d4d2mr4700409ejc.260.1651874510818; Fri, 06
 May 2022 15:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-8-eric.dumazet@gmail.com> <b75489431902bd73fcefd4da2e81e39eec8cc667.camel@gmail.com>
 <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
In-Reply-To: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 May 2022 15:01:39 -0700
Message-ID: <CAKgT0UdFqN5UuwoT683Rh=SsFfXMJxtkRu10WbFkqV7deObNtQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 07/12] ipv6: add IFLA_GRO_IPV6_MAX_SIZE
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 2:22 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 6, 2022 at 2:06 PM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > > From: Coco Li <lixiaoyan@google.com>
> > >
> > > Enable GRO to have IPv6 specific limit for max packet size.
> > >
> > > This patch introduces new dev->gro_ipv6_max_size
> > > that is modifiable through ip link.
> > >
> > > ip link set dev eth0 gro_ipv6_max_size 185000
> > >
> > > Note that this value is only considered if bigger than
> > > gro_max_size, and for non encapsulated TCP/ipv6 packets.
> > >
> > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >
> > This is another spot where it doesn't make much sense to me to add yet
> > another control. Instead it would make much more sense to simply remove
> > the cap from the existing control and simply add a check that caps the
> > non-IPv6 protocols at GRO_MAX_SIZE.
>
> Can you please send a diff on top of our patch series ?

I would rather not as it would essentially just be a revert of the two
problematic patches since what I am suggesting is significantly
smaller.

> It is kind of hard to see what you want, and _why_ you want this.
>
> Note that GRO_MAX_SIZE has been replaced by dev->gro_max_size last year.

I am using GRO_MAX_SIZE as a legacy value for everything that is not
IPv6. If it would help you could go back and take a look at Jakub's
patch series and see what he did with TSO_LEGACY_MAX_SIZE. You could
think of my use here as GRO_LEGACY_MAX_SIZE. What I am doing is
capping all the non-ipv6/tcp flows at the default maximum limit for
legacy setups.

> Yes, yet another control, but some people want more control than others I guess.

Basically these patches are reducing functionality from an existing
control. The g[sr]o_max_size values were applied to all incoming or
outgoing traffic. The patches are adding a special control that only
applies to a subset of ipv6 traffic. Instead of taking that route I
would rather have the max_size values allowed to exceed the legacy
limits, and in those cases that cannot support the new sizes we
default back to the legacy maxes. Doing that I feel like we would get
much more consistent behavior and if somebody is wanting to use these
values for their original intended purpose which was limiting the
traffic they will be able to affect all traffic, not just the
non-ipv6/tcp traffic.
