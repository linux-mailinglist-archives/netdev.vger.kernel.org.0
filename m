Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1EB69F6A5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 15:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjBVOfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 09:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBVOf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 09:35:29 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E142D39CE8;
        Wed, 22 Feb 2023 06:35:27 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p26so5847464wmc.4;
        Wed, 22 Feb 2023 06:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o216UyId00qon4sdQIb+67acV+Y6OPaoB40ZuphAVlU=;
        b=Ec4q98dyPS5F4T6BkCrlEzWRsU5KmNKoyWSk26vc7E8D6YGYgirkV2Gs4V4tUOEIXF
         ThXkPt3LDWm53FzK7tT6+HSOXbgzIJxYa3D9RguW+Rp0w7tO0LoTS2pLrUS3FoXcXVMU
         w2mcmbbbflrpJhNdkbTjjSZrZDpQDUoVktTp4s+tG0e/zUTnT7feiGJ1fmOdSshrsTPX
         uZXao9DGppTI0lrDL7bn42qZiaceXpUAbGXx6AePbZPn9CMXbgBwrtzDcm2cH6aDeOpB
         K+W8P5q9W0wSj7c5Ze0w/1Cg0OWAM94OBudL0FpI+jTPM1LzNfqUTeHJq+I5RppCMk6o
         V/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o216UyId00qon4sdQIb+67acV+Y6OPaoB40ZuphAVlU=;
        b=kPd9X1G2J1lBm7CIBCF9lJMcTtxOxEfqB5xKM7dNYRYu3p30yQPOzwb4bM9dzWlnSZ
         F4WJsDFnHywpCCAaTipHJiR9YaCCmbGR/9EpuH91z8ygx46aw6toGh2z8UH5fVBoJaq9
         wAO2c0/u+sDm0U5o3MiFPtY4rliv4LKLdkCFmSQA3hoD44ygKNaFm9SPYuasmmyZoQwG
         AcRw05QcYjHSv32XQ/hypUoxqVs3jFrobAZ3313hRxy16v6PevmjK7UL6uy68lqp3PS/
         0G9l5T1aKYFP7kSVFfcbcY0Nm3DCvJ+aOspN5/exoRdO46JWOIatPYe8avqXZNNBzu2K
         Y5+A==
X-Gm-Message-State: AO0yUKV2xKsexHlC0ht5Kny+q3Kz/Gmn9v9mCYwYZkIDMcBsGw7YKdF1
        9PW5cmowqK8VZvc5Dprhszk=
X-Google-Smtp-Source: AK7set+5KKv6zPiZqyhOKgh/+pcBnPo+/DhSmuNtLMARcGX7fDwTaB6uW4f9okrvsl+sIeiQBZXoWQ==
X-Received: by 2002:a05:600c:16c4:b0:3df:94c3:4725 with SMTP id l4-20020a05600c16c400b003df94c34725mr1031764wmn.38.1677076526334;
        Wed, 22 Feb 2023 06:35:26 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b003e1f2e43a1csm8163369wms.48.2023.02.22.06.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:35:25 -0800 (PST)
Date:   Wed, 22 Feb 2023 15:35:03 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        steffen.klassert@secunet.com, lixiaoyan@google.com,
        alexanderduyck@fb.com, leon@kernel.org, ye.xingchen@zte.com.cn,
        iwienand@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230222143455.GA11832@debian>
References: <20230130130047.GA7913@debian>
 <20230130130752.GA8015@debian>
 <CANn89i+Hs8837KvTrHE37NYrk=5vCYhDGYFu3MBm1dvXmS=KnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+Hs8837KvTrHE37NYrk=5vCYhDGYFu3MBm1dvXmS=KnQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Currently, the IPv6 extension headers are parsed twice: first in
> > ipv6_gro_receive, and then again in ipv6_gro_complete.
> >
> > The field NAPI_GRO_CB(skb)->proto is used by GRO to hold the layer 4
> > protocol type that comes after the IPv6 layer. I noticed that it is set
> > in ipv6_gro_receive, but isn't used anywhere. By using this field, and
> > also storing the size of the network header, we can avoid parsing
> > extension headers a second time in ipv6_gro_complete.
> >
> > The implementation had to handle both inner and outer layers in case of
> > encapsulation (as they can't use the same field).
> >
> > I've applied this optimisation to all base protocols (IPv6, IPv4,
> > Ethernet). Then, I benchmarked this patch on my machine, using ftrace to
> > measure ipv6_gro_complete's performance, and there was an improvement.
> 
> It seems your patch adds a lot of conditional checks, which will
> alternate true/false
> for encapsulated protocols.
> 
> So please give us raw numbers, ftrace is too heavy weight for such claims.
> 

For the benchmarks, I used 100Gbit NIC mlx5 single-core (power management off), turboboost off.

Typical IPv6 traffic (zero extension headers):

    for i in {1..5}; do netperf -t TCP_STREAM -H 2001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    16391.20
    131072  16384  16384    90.00    16403.50
    131072  16384  16384    90.00    16403.30
    131072  16384  16384    90.00    16397.84
    131072  16384  16384    90.00    16398.00

    # after
    131072  16384  16384    90.00    16399.85
    131072  16384  16384    90.00    16392.37
    131072  16384  16384    90.00    16403.06
    131072  16384  16384    90.00    16406.97
    131072  16384  16384    90.00    16406.09

IPv6 over IPv6 traffic:

    for i in {1..5}; do netperf -t TCP_STREAM -H 4001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    14791.61
    131072  16384  16384    90.00    14791.66
    131072  16384  16384    90.00    14783.47
    131072  16384  16384    90.00    14810.17
    131072  16384  16384    90.00    14806.15

    # after
    131072  16384  16384    90.00    14793.49
    131072  16384  16384    90.00    14816.10
    131072  16384  16384    90.00    14818.41
    131072  16384  16384    90.00    14780.35
    131072  16384  16384    90.00    14800.48

IPv6 traffic with varying extension headers:

    for i in {1..5}; do netperf -t TCP_STREAM -H 2001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    14812.37
    131072  16384  16384    90.00    14813.04
    131072  16384  16384    90.00    14802.54
    131072  16384  16384    90.00    14804.06
    131072  16384  16384    90.00    14819.08

    # after
    131072  16384  16384    90.00    14927.11
    131072  16384  16384    90.00    14910.45
    131072  16384  16384    90.00    14917.36
    131072  16384  16384    90.00    14916.53
    131072  16384  16384    90.00    14928.88

> >
> > Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> > ---
> >  include/net/gro.h      |  8 ++++++--
> >  net/ethernet/eth.c     | 11 +++++++++--
> >  net/ipv4/af_inet.c     |  8 +++++++-
> >  net/ipv6/ip6_offload.c | 15 ++++++++++++---
> >  4 files changed, 34 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/gro.h b/include/net/gro.h
> > index 7b47dd6ce94f..d364616cb930 100644
> > --- a/include/net/gro.h
> > +++ b/include/net/gro.h
> > @@ -41,8 +41,8 @@ struct napi_gro_cb {
> >         /* Number of segments aggregated. */
> >         u16     count;
> >
> > -       /* Used in ipv6_gro_receive() and foo-over-udp */
> > -       u16     proto;
> > +       /* Used in eth_gro_receive() */
> > +       __be16  network_proto;
> >
> >  /* Used in napi_gro_cb::free */
> >  #define NAPI_GRO_FREE             1
> > @@ -86,6 +86,10 @@ struct napi_gro_cb {
> >
> >         /* used to support CHECKSUM_COMPLETE for tunneling protocols */
> >         __wsum  csum;
> > +
> > +       /* Used in inet and ipv6 _gro_receive() */
> > +       u16     network_len;
> > +       u8      transport_proto;
> >  };
> >
> >  #define NAPI_GRO_CB(skb) ((struct napi_gro_cb *)(skb)->cb)
> > diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> > index 2edc8b796a4e..d68ad90f0a9e 100644
> > --- a/net/ethernet/eth.c
> > +++ b/net/ethernet/eth.c
> > @@ -439,6 +439,9 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
> >                 goto out;
> >         }
> >
> > +       if (!NAPI_GRO_CB(skb)->encap_mark)
> > +               NAPI_GRO_CB(skb)->network_proto = type;
> > +
> >         skb_gro_pull(skb, sizeof(*eh));
> >         skb_gro_postpull_rcsum(skb, eh, sizeof(*eh));
> >
> > @@ -456,12 +459,16 @@ EXPORT_SYMBOL(eth_gro_receive);
> >  int eth_gro_complete(struct sk_buff *skb, int nhoff)
> >  {
> >         struct ethhdr *eh = (struct ethhdr *)(skb->data + nhoff);
> 
> Why initializing @eh here is needed ?
> Presumably, for !skb->encapsulation, @eh would not be used.
> 

Fixed in v2, thanks

> > -       __be16 type = eh->h_proto;
> > +       __be16 type;
> >         struct packet_offload *ptype;
> >         int err = -ENOSYS;
> >
> > -       if (skb->encapsulation)
> > +       if (skb->encapsulation) {
> >                 skb_set_inner_mac_header(skb, nhoff);
> > +               type = eh->h_proto;
> > +       } else {
> > +               type = NAPI_GRO_CB(skb)->network_proto;
> > +       }
> >
> >         ptype = gro_find_complete_by_type(type);
> >         if (ptype != NULL)
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 6c0ec2789943..4401af7b3a15 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1551,6 +1551,9 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
> >          * immediately following this IP hdr.
> >          */
> >
> > +       if (!NAPI_GRO_CB(skb)->encap_mark)
> > +               NAPI_GRO_CB(skb)->transport_proto = proto;
> > +
> >         /* Note : No need to call skb_gro_postpull_rcsum() here,
> >          * as we already checked checksum over ipv4 header was 0
> >          */
> > @@ -1621,12 +1624,15 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
> >         __be16 newlen = htons(skb->len - nhoff);
> >         struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
> >         const struct net_offload *ops;
> > -       int proto = iph->protocol;
> > +       int proto;
> >         int err = -ENOSYS;
> >
> >         if (skb->encapsulation) {
> >                 skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IP));
> >                 skb_set_inner_network_header(skb, nhoff);
> > +               proto = iph->protocol;
> > +       } else {
> > +               proto = NAPI_GRO_CB(skb)->transport_proto;
> 
> I really doubt this change is needed.
> We need to access iph->fields in the following lines.
> Adding an else {} branch is adding extra code, and makes your patch
> longer to review.
> 

Good point, removed in v2.

> >         }
> >
> >         csum_replace2(&iph->check, iph->tot_len, newlen);
> > diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
> > index 00dc2e3b0184..79ba5882f576 100644
> > --- a/net/ipv6/ip6_offload.c
> > +++ b/net/ipv6/ip6_offload.c
> > @@ -227,11 +227,14 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
> >                 iph = ipv6_hdr(skb);
> >         }
> >
> > -       NAPI_GRO_CB(skb)->proto = proto;
> 
> I guess you missed BIG  TCP ipv4 changes under review... ->proto is now used.
> 

I rebased the patch now that ipv4 BIG TCP is merged, and made proto and
transport_proto be separate variables.

> > -
> >         flush--;
> >         nlen = skb_network_header_len(skb);
> >
> > +       if (!NAPI_GRO_CB(skb)->encap_mark) {
> > +               NAPI_GRO_CB(skb)->transport_proto = proto;
> > +               NAPI_GRO_CB(skb)->network_len = nlen;
> > +       }
> > +
> >         list_for_each_entry(p, head, list) {
> >                 const struct ipv6hdr *iph2;
> >                 __be32 first_word; /* <Version:4><Traffic_Class:8><Flow_Label:20> */
> > @@ -358,7 +361,13 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
> >                 iph->payload_len = htons(payload_len);
> >         }
> >
> > -       nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> > +       if (!skb->encapsulation) {
> > +               ops = rcu_dereference(inet6_offloads[NAPI_GRO_CB(skb)->transport_proto]);
> > +               nhoff += NAPI_GRO_CB(skb)->network_len;
> > +       } else {
> > +               nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> 
> IMO ipv6_exthdrs_len() is quite fast for the typical case where we
> have no extension headers.
> 
> This new conditional check seems expensive to me.
> 

In v2 I moved the encapsulation branch at the beginning of the function to this
spot, merging the conditions.  So for the typical case, instead of another
redundant extension header length calculation (which requires at least one
branch and one dereference of iph data), it's a simple dereference to CB. Thus,
performance for the typical case is unharmed, and possibly even slightly improved.
For cases with a varying amount of extension headers in ipv6, there's a
performance upgrade (multiple memory dereference to iph data and conditional
checks are saved).

Also, after further inspection, I noticed that there is a potential problem in
ipv6_gro_complete(), where inner_network_header is initialized to the wrong
value.  The initialization of the inner_network_header field should be
performed after the BIG TCP if block. I fixed this in v2 by combining this
initialization with the new conditional check after the BIG TCP so the patch
does not add a conditional check anymore.


