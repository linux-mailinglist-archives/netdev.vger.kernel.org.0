Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D332D51E18F
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 00:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387886AbiEFWMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241939AbiEFWMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:12:23 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52965DA7D
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:08:39 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y76so15173210ybe.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 15:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8N8f/YMGzp0t9xBfRj+qQHogs+OoMAE9FozPFE9eKI=;
        b=AHc06IaQEYE3EKoIKSZfhgE80WHFuoqTzPisu/wFvC++qmVtUdI8ILqhoqv+wQ95Z+
         EMeG1P8kwgHjnljkOIUpKMrCk8fVSHgwYikU4+51bbvuISEzPRiEasDDvs18vY3cVgXQ
         uRm9PZuZjnybJkniFXZmv4Ih7NP9M75G48ZbQ0GWxbDsYuKF5OBf6P+BDDZH95Wit6lP
         E1VpMCY4U+XvvX4g8LoKXtl3wSJARhEsaoPX9DAMVEYLFuBuI1VoV287u7wmAk2Szk8O
         +aI7ukOSYA+C7E4s+WpAEFACR/nwOKnSvtgGuH1zjfvGN9HgTgpLZMJTDybO8sxKU2j7
         DSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8N8f/YMGzp0t9xBfRj+qQHogs+OoMAE9FozPFE9eKI=;
        b=SPAPn0QrEIhUxOeHgB1t8G89m80kZZkZ8+wQZdvHRa4PPLpYGzN7WEZiCilc+bBJNR
         Zurbqp0rYRL0PSKMWOKOTo/7dpllC1wb9egzQv0iCCIJLjsf6HrCdYV8fGYMaVlVsHJL
         g48Vb+OzAfUErdGkttDFSDU3mxejdB4/TrQdxYTqzjw4nn2J+/1yRAYYhQold+2gIOsM
         YBZfPdGrAQIGt/qqWTG3CElNDuum2BQr799ox/+ATIG2/vCbMYthJsoLNFvy6Er4VRMX
         kbJZsYDLi7VAMS9zRofwaOXc03w/nv7ZYdGtDEBoGkVLaaOLRb5DrlwoQ/odVMiFilCY
         Fdqg==
X-Gm-Message-State: AOAM530N5tQU53D1r6Vcl/mCfazV4S3sUUolAgUcwS95WaLO6Td+qfUu
        zAP6HJJZ1Gj5/zk4f3s74N9aqHq5vMOaE9N3tF+uraF1e50ATAQw
X-Google-Smtp-Source: ABdhPJyqybPDxnQ9/9xF4h3K9AttgVhDxjkvNPsCunwN4W/PXwR0A2TClE65HIlLh0EaH479ii6Rcgm7UC4YVrJl6rE=
X-Received: by 2002:a25:6157:0:b0:645:8d0e:f782 with SMTP id
 v84-20020a256157000000b006458d0ef782mr4496220ybb.36.1651874918539; Fri, 06
 May 2022 15:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-8-eric.dumazet@gmail.com> <b75489431902bd73fcefd4da2e81e39eec8cc667.camel@gmail.com>
 <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com> <CAKgT0UdFqN5UuwoT683Rh=SsFfXMJxtkRu10WbFkqV7deObNtQ@mail.gmail.com>
In-Reply-To: <CAKgT0UdFqN5UuwoT683Rh=SsFfXMJxtkRu10WbFkqV7deObNtQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 15:08:27 -0700
Message-ID: <CANn89iL7bjhVTtbhLGPJv=_srr_epVBe-ZroSDkWjFafxTat3Q@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 07/12] ipv6: add IFLA_GRO_IPV6_MAX_SIZE
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 3:01 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, May 6, 2022 at 2:22 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, May 6, 2022 at 2:06 PM Alexander H Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > > > From: Coco Li <lixiaoyan@google.com>
> > > >
> > > > Enable GRO to have IPv6 specific limit for max packet size.
> > > >
> > > > This patch introduces new dev->gro_ipv6_max_size
> > > > that is modifiable through ip link.
> > > >
> > > > ip link set dev eth0 gro_ipv6_max_size 185000
> > > >
> > > > Note that this value is only considered if bigger than
> > > > gro_max_size, and for non encapsulated TCP/ipv6 packets.
> > > >
> > > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > >
> > > This is another spot where it doesn't make much sense to me to add yet
> > > another control. Instead it would make much more sense to simply remove
> > > the cap from the existing control and simply add a check that caps the
> > > non-IPv6 protocols at GRO_MAX_SIZE.
> >
> > Can you please send a diff on top of our patch series ?
>
> I would rather not as it would essentially just be a revert of the two
> problematic patches since what I am suggesting is significantly
> smaller.
>
> > It is kind of hard to see what you want, and _why_ you want this.
> >
> > Note that GRO_MAX_SIZE has been replaced by dev->gro_max_size last year.
>
> I am using GRO_MAX_SIZE as a legacy value for everything that is not
> IPv6. If it would help you could go back and take a look at Jakub's
> patch series and see what he did with TSO_LEGACY_MAX_SIZE.

Yes, I was the one suggesting this TSO_LEGACY_MAX_SIZE.

> You could
> think of my use here as GRO_LEGACY_MAX_SIZE. What I am doing is
> capping all the non-ipv6/tcp flows at the default maximum limit for
> legacy setups.
>
> > Yes, yet another control, but some people want more control than others I guess.
>
> Basically these patches are reducing functionality from an existing
> control. The g[sr]o_max_size values were applied to all incoming or
> outgoing traffic.

Yes, and we need to change that, otherwise we are stuck at 65536,
because legacy.

> The patches are adding a special control that only applies to a subset of ipv6 traffic.

Exactly. This is not an accident.

> Instead of taking that route I
> would rather have the max_size values allowed to exceed the legacy
> limits, and in those cases that cannot support the new sizes we
> default back to the legacy maxes.

Please send a tested patch. I think it will break drivers.

We spent months doing extensive tests, and I do not see any reason to spend more
time on something that you suggest that I feel is wrong.

> Doing that I feel like we would get
> much more consistent behavior and if somebody is wanting to use these
> values for their original intended purpose which was limiting the
> traffic they will be able to affect all traffic, not just the
> non-ipv6/tcp traffic.

Some people (not us) want to add BIG-TCP with IPv4 as well in a future
evolution.
