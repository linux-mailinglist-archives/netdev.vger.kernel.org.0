Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991E551E160
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355238AbiEFVyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359636AbiEFVyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:54:37 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543ED506EE
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 14:50:52 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ef5380669cso94943857b3.9
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 14:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bwyucxFIAm/PwGTcwC531g+oZjrWV8Ji3QeTcHYIkso=;
        b=H8nQp5yhlaQdlsDDFedw5zf212vPBAA5BlrNHUEDRsJYA6TVQkbs6nOtCAI9UVpZv5
         p62wlTUldnCiXAZy/Fz19O7l9tl42a6nLlqpAv6wuFqpnzCoiCFS5XpNUUjk7SrEzH6/
         YK+JxNfWy6ubqRu/kLZGQ31iyDfECSTnRdZScM94rxiEut4LqaAjx8Ghg8Trq91wfa0+
         Ldu8EvibTU5o8ngIAXQUIEZg/fFJhS4WYmKXIg41nZZTKWz8XikemAmicgmHQQuYMSJg
         PksyU6ipuBl0Kl9L1u7JUZqaM3E9pDJAt3Doq3vF4KRmt1DGMUMnkKozELqbZk1PhPIb
         RO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bwyucxFIAm/PwGTcwC531g+oZjrWV8Ji3QeTcHYIkso=;
        b=V61t9aHCYtqyygSlgWB/GbMJAhJ9jA5PApePfeJVVzEHcJ3rzSvzp7d/xSv35typMp
         FDCi0R3AnP7AkWSWQfcYxVp0GjK+muM40oPSRSqiY8J+g7yod/MzJzlLeHOWJmm2RYvJ
         mldJMOQ74qYhFb/QosToSaev9IXnj7z2PH/Uv1ty90fa7WgGHbDT63Ono1oWXRh96C3O
         WBEBD7Yeu5vHhXIC5isAKT976jxvAv8I9yvV+7HKsndq588VXSanrltYo1unjTIad9+a
         qQ0Q78xGTgfKSEI7VUHCztCfIQ5UWPPJmRE51Wy5J4QEAAlZbCF+3XZ7XFrKlT+F8jeS
         A+yA==
X-Gm-Message-State: AOAM531chCX8xPx/5TVUa9uzREK4p/CIM/6Pvbe0JIUBqbkX9cxM882B
        14q/d2wRrV03GQCPUhRWgBYaM4k31tmFXNdp5qnahg==
X-Google-Smtp-Source: ABdhPJxZDO6ItvBNzL9Rew99P5wk7MDtJWbijq6n19I/Ehi0Cb7MBx6x4ZNdPysqykbxxq2wYgP4ILSRt9cVgU4Pe/8=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr4281414ywb.255.1651873851268; Fri, 06
 May 2022 14:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-3-eric.dumazet@gmail.com> <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
 <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com> <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com>
In-Reply-To: <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 14:50:40 -0700
Message-ID: <CANn89i+f0PGo86pD4XGS4FpjkcHwh-Nb2=r5D6=jp2jbgTY+nw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
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

On Fri, May 6, 2022 at 2:37 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, May 6, 2022 at 2:20 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, May 6, 2022 at 1:48 PM Alexander H Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > > > From: Coco Li <lixiaoyan@google.com>
> > > >
> > > > This enables ipv6/TCP stacks to build TSO packets bigger than
> > > > 64KB if the driver is LSOv2 compatible.
> > > >
> > > > This patch introduces new variable gso_ipv6_max_size
> > > > that is modifiable through ip link.
> > > >
> > > > ip link set dev eth0 gso_ipv6_max_size 185000
> > > >
> > > > User input is capped by driver limit (tso_max_size)
> > > >
> > > > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > >
> > > So I am still not a fan of adding all this extra tooling to make an
> > > attribute that is just being applied to one protocol. Why not just
> > > allow gso_max_size to extend beyond 64K and only limit it by
> > > tso_max_size?
> >
> > Answer is easy, and documented in our paper. Please read it.
>
> I have read it.
>
> > We do not want to enable BIG TCP for IPv4, this breaks user space badly.
> >
> > I do not want to break tcpdump just because some people think TCP just works.
>
> The changes I suggested don't enable it for IPv4. What your current
> code is doing now is using dev->gso_max_size and if it is the correct
> IPv6 type you are using dev->gso_ipv6_max_size. What I am saying is
> that instead of adding yet another netdev control you should just make
> it so that we retain existing behavior when gso_max_size is less than
> GSO_MAX_SIZE, and when it exceeds it all non-ipv6 types max out at
> GSO_MAX_SIZE and only the ipv6 type packets use gso_max_size when you
> exceed GSO_MAX_SIZE.

gso_max_size can not exceed GSO_MAX_SIZE.
This will break many drivers.
I do not want to change hundreds of them.

Look, we chose this implementation so that chances of breaking things
are very small.
I understand this is frustrating, but I suggest you take the
responsibility of breaking things,
and not add this on us.
