Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E909F30D590
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhBCIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhBCIuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:50:50 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F811C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 00:50:10 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id w1so34311012ejf.11
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 00:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDGu83x00/Kbq7cfgWDb84zPXIcJC3/OK0BtXFBvvpA=;
        b=aWKZRaA12a0t0HAx5P0FkZHEOstlJNEQKYy0hNc5PMowuXy6Fmm6uOFe9yJfA8JMNf
         KxLWb9jPYx1es+3Nnb0vcLd34lKq82BB/X5/3kL3FmEsAfrv9Iis6o+TFul4KmpbdF1e
         uHr1kK3ipUk361duraChP8riyTz4F4UkfMHMsbUqtQJVp60NlQUkke/zo7Wm28FbwE3D
         K9xpmbahGRzW2GX6vaX4p/4z1BG4m9sU26/ySg55nBuyUiHMIeKkNT4W8hJSF9BIA27x
         RK2sRrvVd/HIlxFJy2sUkVOXOOZOtKEyvK6uIgAwYFjRa9088F7ZCQDyZDUprAUgWaZx
         42JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDGu83x00/Kbq7cfgWDb84zPXIcJC3/OK0BtXFBvvpA=;
        b=CXHPpLPrLyG1i6hmplFiPre+5wd9swEBfr9rQ9t+MRtt6gSVM2OMLxk78CeltHf6Sd
         mjS3UnvnL22Lo84a12BjHTU5py9V2zBCI0GLXyzbDuISOQNn0Tj4/s2rB8cUWFIsuin3
         R5uP9+9LpeiBQqiJC2uuyjBydbj/IfYVO4DmbRo5Gn85QbtmYzGC/FsOswdFIhiWyBgg
         /x1O3OWxODsyEvrqQBFpk0ztfWZttTPP1wA3ubGXuW5EuDyLc0HLaMl91CWjxA/SkyzD
         1IICNE8GJ6MOjYw70/Qd2HwxOTLosiU0WW4Ek/bB3Gn9+yFqHSFwA/Vf7MyPKJMrgA4U
         t0hg==
X-Gm-Message-State: AOAM5317YDmPkG5ecqLgQsasIdIjiWufDBLQv/+KhiMtp2m2wTNAhZHa
        o23rlPlodBjaHuaQvm93qYQ=
X-Google-Smtp-Source: ABdhPJzLxJU/GR4IVZyeoUN1tCtDpV2CowP/ZqWV9vu6qYnRtNgj2LnfqVzlEpGioDRgFRrPcnmOwA==
X-Received: by 2002:a17:906:7006:: with SMTP id n6mr2121831ejj.35.1612342208473;
        Wed, 03 Feb 2021 00:50:08 -0800 (PST)
Received: from AHABDELS-M-J3JG ([173.38.220.50])
        by smtp.gmail.com with ESMTPSA id gz14sm665201ejc.105.2021.02.03.00.50.07
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 03 Feb 2021 00:50:07 -0800 (PST)
Date:   Wed, 3 Feb 2021 09:50:05 +0100
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     Suprit Japagal <suprit.japagal@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        David Lebrun <david.lebrun@uclouvain.be>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] NET: SRv6: seg6_local: Fixed SRH processing when
 segments left is 0
Message-Id: <20210203095005.4de51bc6632f2da2bb55c70a@gmail.com>
In-Reply-To: <CAGTyo2N5KzFmDgjkqHGZAcO4ZdQ54iKDD6wCYDHemZHFGfP57A@mail.gmail.com>
References: <20210131130840.32384-1-suprit.japagal@gmail.com>
        <5ac9c562-6bd6-1ab5-3504-b83dc58c15cc@gmail.com>
        <20210202105233.b78404a6747aead2c087b4e4@gmail.com>
        <CAGTyo2N5KzFmDgjkqHGZAcO4ZdQ54iKDD6wCYDHemZHFGfP57A@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Suprit, 

As you see the in the pseudocode, if Segments Left = 0, the End function will 
stop processing the SRH and will process upper layer protocols for OAM (e.g., ICMP). 

The packet will not be forwarded further. 

What you propose here is a different thing, you want to decap the SRv6 
headers and forward the packet further if Segments Left = 0.

This is not a correct symantic of SRv6 End Behavior.   


But if you need such behavior in your network, it already defined by another 
flavor of the End function called Ultimate Segment Decapsulation (USD) [2]

Please feel free to submit a patch to support this USD flavor of END.  

[2] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-28#section-4.16.3

Thanks
Ahmed
 


On Tue, 2 Feb 2021 16:50:58 +0530
Suprit Japagal <suprit.japagal@gmail.com> wrote:

> Hi,
> 
> As per the section 4.1 of [1]:
> 
> "When N receives a packet whose IPv6 DA is S and S is a local *End SID*,
> 
>    N does:
> 
>    S01. When an SRH is processed {
>    S02.   If (Segments Left == 0) {
>    S03.      Stop processing the SRH, and proceed to process the next
>                 header in the packet, whose type is identified by
>                 the Next Header field in the routing header.
> 
>    S04. }
> "
> S is the DA which is a local End SID and when SRH is processed, the
> segments left field can be 0 as mentioned above.
> Same goes for End.X SID and End.T SID as per section 4.2 and 4.3 of [1]
> respectively.
> 
> Packets processed by End, End.X and End.T behaviors can have a Segment Left
> Value
> of zero.
> 
> [1]https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-28
> 
> Thanks,
> Suprit J
> 
> On Tue, Feb 2, 2021 at 3:22 PM Ahmed Abdelsalam <ahabdels.dev@gmail.com>
> wrote:
> 
> > The current implementation is correct. This patch is introducing incorrect
> > symantic to SRv6 End and End.T behaviors.
> >
> > SRv6 End and End.T behaviors (among other behaviors) are defined in the
> > SRv6 Network Programming draft (Soon to published as an RFC) [1].
> >
> > SRv6 End and End.T behaviors are used to implement Traffic Engineering (TE)
> > use-cases, where a node recieves the packet and send it to the next SID
> > from
> > the SRH SIDList.
> >
> > Packets processed by End and End.T behaviors can not have a Segment Left
> > Value
> > of zero.
> >
> > Please refer to sections 4.1 and 4.3 of [1].
> >
> >
> > [1]
> > https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-28
> >
> > Ahmed
> >
> >
> > On Sun, 31 Jan 2021 10:33:14 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> >
> > > [ cc David Lebrun, author of the original code ]
> > >
> > > On 1/31/21 6:08 AM, Suprit Japagal wrote:
> > > > From: "Suprit.Japagal" <suprit.japagal@gmail.com>
> > > >
> > > > According to the standard IETF RFC 8754, section 4.3.1.1
> > > > (https://tools.ietf.org/html/rfc8754#section-4.3.1.1)
> > > > When the segments left in SRH equals to 0, proceed to process the
> > > > next header in the packet, whose type is identified by the
> > > > Next header field of the routing header.
> > > >
> > > > Signed-off-by: Suprit.Japagal <suprit.japagal@gmail.com>
> > > > ---
> > > >  net/ipv6/seg6_local.c | 54
> > +++++++++++++++++++++++++++++++++++++++++++++------
> > > >  1 file changed, 48 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > > > index b07f7c1..b17f9dc 100644
> > > > --- a/net/ipv6/seg6_local.c
> > > > +++ b/net/ipv6/seg6_local.c
> > > > @@ -273,11 +273,25 @@ static int input_action_end(struct sk_buff *skb,
> > struct seg6_local_lwt *slwt)
> > > >  {
> > > >     struct ipv6_sr_hdr *srh;
> > > >
> > > > -   srh = get_and_validate_srh(skb);
> > > > +   srh = get_srh(skb);
> > > >     if (!srh)
> > > >             goto drop;
> > > >
> > > > -   advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > > > +   if (srh->segments_left > 0)
> > > > +           if (!seg6_hmac_validate_skb(skb))
> > > > +                   goto drop;
> > > > +#endif
> > > > +
> > > > +   if (srh->segments_left == 0) {
> > > > +           if (!decap_and_validate(skb, srh->nexthdr))
> > > > +                   goto drop;
> > > > +
> > > > +           if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> > > > +                   goto drop;
> > > > +   } else {
> > > > +           advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > +   }
> > > >
> > > >     seg6_lookup_nexthop(skb, NULL, 0);
> > > >
> > > > @@ -293,11 +307,25 @@ static int input_action_end_x(struct sk_buff
> > *skb, struct seg6_local_lwt *slwt)
> > > >  {
> > > >     struct ipv6_sr_hdr *srh;
> > > >
> > > > -   srh = get_and_validate_srh(skb);
> > > > +   srh = get_srh(skb);
> > > >     if (!srh)
> > > >             goto drop;
> > > >
> > > > -   advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > > > +   if (srh->segments_left > 0)
> > > > +           if (!seg6_hmac_validate_skb(skb))
> > > > +                   goto drop;
> > > > +#endif
> > > > +
> > > > +   if (srh->segments_left == 0) {
> > > > +           if (!decap_and_validate(skb, srh->nexthdr))
> > > > +                   goto drop;
> > > > +
> > > > +           if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> > > > +                   goto drop;
> > > > +   } else {
> > > > +           advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > +   }
> > > >
> > > >     seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> > > >
> > > > @@ -312,11 +340,25 @@ static int input_action_end_t(struct sk_buff
> > *skb, struct seg6_local_lwt *slwt)
> > > >  {
> > > >     struct ipv6_sr_hdr *srh;
> > > >
> > > > -   srh = get_and_validate_srh(skb);
> > > > +   srh = get_srh(skb);
> > > >     if (!srh)
> > > >             goto drop;
> > > >
> > > > -   advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > > > +   if (srh->segments_left > 0)
> > > > +           if (!seg6_hmac_validate_skb(skb))
> > > > +                   goto drop;
> > > > +#endif
> > > > +
> > > > +   if (srh->segments_left == 0) {
> > > > +           if (!decap_and_validate(skb, srh->nexthdr))
> > > > +                   goto drop;
> > > > +
> > > > +           if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> > > > +                   goto drop;
> > > > +   } else {
> > > > +           advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > > > +   }
> > > >
> > > >     seg6_lookup_nexthop(skb, NULL, slwt->table);
> > > >
> > > >
> > >
> >
> >
> > --
> > Ahmed Abdelsalam <ahabdels.dev@gmail.com>
> >


-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
