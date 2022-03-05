Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B534CE65A
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiCESJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 13:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiCESJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 13:09:42 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1609A3DA5F
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 10:08:52 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2dc242a79beso113393397b3.8
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 10:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYjYh+Mjf01Hna+1Ctsj1ByQKsn/wjYqnPTyeX6I2R8=;
        b=oDHkTrBlAHo0VbAyavGnfuV1CjVshJV6gM3k+qM/333d9+uVPWZ6oZBmPkBa4GL1H3
         ajZhUYpjcP5k+dxU93CI/jhUhvISIolCyWSYR705Ifv4ytXTzuYEbWcKOQYXU3MELbTO
         GOe7vUJlm2ujggpH36ftGL09mxvpvoHFN07964aSPLo8lS2VfgYP2o/YU1IApKpWtyMg
         ObziMrm1qLcAfrjsXyHZGsKWXwBZaimVkYzITpWQtkywa47WLzZoMzGbRaBrl5CsWOHL
         k9Goupr8HP4ItjIvv1EY065abB23/7lEG9puinXEBvP6yE3u7wc1/caWSFZwBYDPeRyh
         1JYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYjYh+Mjf01Hna+1Ctsj1ByQKsn/wjYqnPTyeX6I2R8=;
        b=DrkBFoFeuP6CAHTn63hkPsjc8eS0lvI3BxY4/kI+ugyWDDxRZGqBw1ZZQchXSFoigC
         mJ7Z8jwYcYOLdd42+mId2YFfm/Q5Nx7D1/yDjZNIvRP6mJ21j2BaGbFNv+xGssnIDjUb
         Oveal9Un0FHej4xo0z07fQEUUTEw7WOMxokZLTpcaifr4W/OjZ8ypbMsGWnxOEcxwbrw
         1NYLdcb/l2nj2Hrt9Y7MUMOZ+cpxhIHiFpXEy6c0r1x3qVOS5eh+M8XQnF3+EyUPSQwC
         GaCUeOeKr07t4QSjuaH78IHTeGQMF+jolJyQCaQPaghyF7otzWaWF54fBdMEaKfM3851
         VTcw==
X-Gm-Message-State: AOAM532inrZP5UcNhEYK65QGe6fZyUN1L2VMQkQjtrUtFVvBqY6uvSyK
        pa3Hi56IA6gcyMy6zX+ziFSD8LpUMrQacn3+SB+QdQ==
X-Google-Smtp-Source: ABdhPJwlk1uYGtI7aMbNWaqfAu33zTG36sOcNCQjJbAPIgYZWg3x/pUvkZdMAZs96P0pcheOg8Sf1a6EzvGWsSdgpsI=
X-Received: by 2002:a81:846:0:b0:2db:f920:5c62 with SMTP id
 67-20020a810846000000b002dbf9205c62mr3206365ywi.489.1646503730989; Sat, 05
 Mar 2022 10:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com> <726720e6-cd28-646c-1ba3-576a258ae02e@kernel.org>
 <CANn89iL2gXRsnC20a+=YJ+Ug=3x_jacmtL+S269_0g+E0wDYSQ@mail.gmail.com> <b66106e0-4bd6-e2ae-044d-e48c22546c87@kernel.org>
In-Reply-To: <b66106e0-4bd6-e2ae-044d-e48c22546c87@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 5 Mar 2022 10:08:40 -0800
Message-ID: <CANn89i+iGb7p2SqLXvzmkR3W3T_BgUWW78-4z0TxrBW8dYTnwA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
To:     David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
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

On Sat, Mar 5, 2022 at 8:46 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/4/22 10:47 AM, Eric Dumazet wrote:
> > On Thu, Mar 3, 2022 at 8:33 PM David Ahern <dsahern@kernel.org> wrote:
> >>
> >> On 3/3/22 11:16 AM, Eric Dumazet wrote:
> >>> From: Coco Li <lixiaoyan@google.com>
> >>>
> >>> Instead of simply forcing a 0 payload_len in IPv6 header,
> >>> implement RFC 2675 and insert a custom extension header.
> >>>
> >>> Note that only TCP stack is currently potentially generating
> >>> jumbograms, and that this extension header is purely local,
> >>> it wont be sent on a physical link.
> >>>
> >>> This is needed so that packet capture (tcpdump and friends)
> >>> can properly dissect these large packets.
> >>>
> >>
> >>
> >> I am fairly certain I know how you are going to respond, but I will ask
> >> this anyways :-) :
> >>
> >> The networking stack as it stands today does not care that skb->len >
> >> 64kB and nothing stops a driver from setting max gso size to be > 64kB.
> >> Sure, packet socket apps (tcpdump) get confused but if the h/w supports
> >> the larger packet size it just works.
> >
> > Observability is key. "just works" is a bold claim.
> >
> >>
> >> The jumbogram header is getting adding at the L3/IPv6 layer and then
> >> removed by the drivers before pushing to hardware. So, the only benefit
> >> of the push and pop of the jumbogram header is for packet sockets and
> >> tc/ebpf programs - assuming those programs understand the header
> >> (tcpdump (libpcap?) yes, random packet socket program maybe not). Yes,
> >> it is a standard header so apps have a chance to understand the larger
> >> packet size, but what is the likelihood that random apps or even ebpf
> >> programs will understand it?
> >
> > Can you explain to me what you are referring to by " random apps" exactly ?
> > TCP does not expose to user space any individual packet length.
>
> TCP apps are not affected; they do not have direct access to L3 headers.
> This is about packet sockets and ebpf programs and their knowledge of
> the HBH header. This does not seem like a widely used feature and even
> tcpdump only recently gained support for it (e.g.,  Ubuntu 20.04 does
> not support it, 21.10 does). Given that what are the odds most packet
> programs are affected by the change and if they need to have support we
> could just as easily add that support in a way that gets both networking
> layers working.
>
> >
> >
> >
> >>
> >> Alternative solutions to the packet socket (ebpf programs have access to
> >> skb->len) problem would allow IPv4 to join the Big TCP party. I am
> >> wondering how feasible an alternative solution is to get large packet
> >> sizes across the board with less overhead and changes.
> >
> > You know, I think I already answered this question 6 months ago.
> >
> > We need to carry an extra metadata to carry how much TCP payload is in a packet,
> > both on RX and TX side.
> >
> > Adding an skb field for that was not an option for me.
>
> Why? skb->len is not limited to a u16. The only affect is when skb->len
> is used to fill in the ipv4/ipv6 header.

Seriously ?

Have you looked recently at core networking stack, and have you read
my netdev presentation ?

Core networking stack will trim your packets skb->len based on what is
found in the network header,
which is a 16bit field, unless you use HBH.

Look at ip6_rcv_core().
Do you want to modify it ?
Let us know how exactly, and why it is not going to break things.

pkt_len = ntohs(hdr->payload_len);

/* pkt_len may be zero if Jumbo payload option is present */
if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
    if (pkt_len + sizeof(struct ipv6hdr) > skb->len) {
         __IP6_INC_STATS(net,
                                     idev, IPSTATS_MIB_INTRUNCATEDPKTS);
        goto drop;
    }
    if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr))) {
        __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
            goto drop;
      }
hdr = ipv6_hdr(skb);
}

if (hdr->nexthdr == NEXTHDR_HOP) {
    if (ipv6_parse_hopopts(skb) < 0) {
        __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
        rcu_read_unlock();
        return NULL;
    }
}







>
> >
> > Adding a 8 bytes header is basically free, the headers need to be in cpu caches
> > when the header is added/removed.
> >
> > This is zero cost on current cpus, compared to the gains.
> >
> > I think you focus on TSO side, which is only 25% of the possible gains
> > that BIG TCP was seeking for.
> >
> > We covered both RX and TX with a common mechanism.
>
