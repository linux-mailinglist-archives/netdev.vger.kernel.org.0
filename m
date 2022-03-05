Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704264CE655
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 18:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiCER64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 12:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiCER6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 12:58:55 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9950237A26
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 09:58:04 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2d07ae0b1c0so123670227b3.2
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 09:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmIRN9XM9S/bVNDYu72wu6sUDzi6KDW2WwT9m46Thao=;
        b=tnSmeywJlYIJW0Fu7Lay+SnF2sS3QWuQIFCIrk4rZl5fOs2m2YcJY8F9h4ZHMPxENp
         kLJ8dtP4wS+D0vf7c0xde6OIRiiVVe/Ch6M8sBIjeu6rwMOCgqkewPpkKUlNuXAqvnHa
         NJv72x1YHZnrhdILPWbKiauV9oWXyhv1tcx/gJp+wUwIXKYp+aBFdTNv/aFNKvQt3qqa
         23xHzo8nVWQpru60/zQyXJgO8FbxQ7RBbepO+jIEJcVe3gH5eb4DQmJNT8z4dGflpPtE
         jFBXGQcsyoqLYMEl3ilqjUGLgct58Oei+ZvdZEVUcRnkLxB7mTzL/NbzoAFiBXpxwcv8
         MQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmIRN9XM9S/bVNDYu72wu6sUDzi6KDW2WwT9m46Thao=;
        b=hp2aAX98WmTWzV+eNbKs9tNm7MJzXr4U7unyRPSDcl6MBZ7NfLqwVcsB6477HLd7oq
         Q2OkYXifGo2tGC+C7WufQIQEUvfTATf5b+/Z5OxRpydmfabgf5jXlVz29VSkMTQ9BcVc
         a7OZqU6sLnR+KZbyQcWIUD6ZiZpzvUN6jxX6zulwvzRLufNj9zz4orLDqTyboj1dxqyI
         xkszLnf9LECpR83OAtC6rJZngryEql1C9CE1pg/oJhSBEUlOgVsAUAln0D8Pq6ILlukG
         bp6KqaMhUntAgnrYRX6YQVb4nFKWVXeoDHAxUyR4b3FxLKnSa0vErYr6plcT0CPWhepb
         1IdA==
X-Gm-Message-State: AOAM533SC1WbgA2CnKcYxvGaZJS+zjEEr1fILgPHsYsuRwAbAppADquQ
        tUo++MPARKf32iJPjDvrmamXGR8HDVMno5zTrErfiA==
X-Google-Smtp-Source: ABdhPJwAh/38zf1WaZFSeKPOooyYMcVAvYoUNIBmGKnxLwW4OsF1Nt1UB7E/YU2Y5zW1Wa+28W0GZ7bhrDssJIAhI7k=
X-Received: by 2002:a0d:d596:0:b0:2db:fc7f:990e with SMTP id
 x144-20020a0dd596000000b002dbfc7f990emr3042239ywd.47.1646503083441; Sat, 05
 Mar 2022 09:58:03 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-15-eric.dumazet@gmail.com> <c9f5c261-c263-a6b4-7e00-17dfefd36a7a@kernel.org>
 <CANn89iJKEV6Y+2mY1Gs_zJTrnm+TTXOHoW_D3AWYE0ELijrm+w@mail.gmail.com> <66ea9048-3287-c0d5-6edc-bd4b7ec4bd70@kernel.org>
In-Reply-To: <66ea9048-3287-c0d5-6edc-bd4b7ec4bd70@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 5 Mar 2022 09:57:52 -0800
Message-ID: <CANn89i+d0gaAM=Bsve-ix5BcKnK5gL1MtVhYbBha+92TiFSHpw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 14/14] mlx5: support BIG TCP packets
To:     David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 5, 2022 at 8:36 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/4/22 10:14 AM, Eric Dumazet wrote:
> > On Thu, Mar 3, 2022 at 8:43 PM David Ahern <dsahern@kernel.org> wrote:
> >>
> >> On 3/3/22 11:16 AM, Eric Dumazet wrote:
> >>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >>> index b2ed2f6d4a9208aebfd17fd0c503cd1e37c39ee1..1e51ce1d74486392a26568852c5068fe9047296d 100644
> >>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >>> @@ -4910,6 +4910,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
> >>>
> >>>       netdev->priv_flags       |= IFF_UNICAST_FLT;
> >>>
> >>> +     netif_set_tso_ipv6_max_size(netdev, 512 * 1024);
> >>
> >>
> >> How does the ConnectX hardware handle fairness for such large packet
> >> sizes? For 1500 MTU this means a single large TSO can cause the H/W to
> >> generate 349 MTU sized packets. Even a 4k MTU means 128 packets. This
> >> has an effect on the rate of packets hitting the next hop switch for
> >> example.
> >
> > I think ConnectX cards interleave packets from all TX queues, at least
> > old CX3 have a parameter to control that.
> >
> > Given that we already can send at line rate, from a single TX queue, I
> > do not see why presenting larger TSO packets
> > would change anything on the wire ?
> >
> > Do you think ConnectX adds an extra gap on the wire at the end of a TSO train ?
>
> It's not about 1 queue, my question was along several lines. e.g,
> 1. the inter-packet gap for TSO generated packets. With 512kB packets
> the burst is 8x from what it is today.

We did experiments with 185 KB  (or 45 4K segments in our case [1]),
and got no increase of drops.
We are deploying these limits.
[1] we increased MAX_SKB_FRAGS to 45,  so that zero copy for both TX
and RX is possible.

Once your switches are 100Gbit rated, just send them 100Gbit traffic.

Note that linux TCP has a lot of burst-control, and pacing features already.

>
> 2. the fairness within hardware as 1 queue has potentially many 512kB
> packets and the impact on other queues (e.g., higher latency?) since it
> will take longer to split the larger packets into MTU sized packets.

It depends on the NIC. Many NICs (including mlx4) have a per queue quantum,
usually configurable in power of two steps (4K, 8K, 16K, 32K ...)

It means that one TSO packet is split in smaller chunks, depending on
concurrent eligible TX queues.

Our NIC of the day at  Google, has a MTU quantum per queue.

(This is one of the reason I added
/sys/class/net/ethX/gro_flush_timeout, because sending TSO packets
would not mean the receiver would receive this TSO in a single train
of received packets)

>
> It is really about understanding the change this new default size is
> going to have on users.

Sure, but to be able to conduct experiments, and allow TCP congestion control
to probe for bigger bursts, we need the core to support bigger packets.

Then, one can precisely tune the max GSO size that it wants, per
ethernet device,
if really existing rate limiting features do not help.
