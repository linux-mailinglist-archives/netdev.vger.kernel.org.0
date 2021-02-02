Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87E30BB84
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhBBJyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhBBJxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:53:17 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD3C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 01:52:36 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v15so19756627wrx.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 01:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1+c1Er8rSXXiSKmZT51/RstLkABp2JaioVD5358bhQg=;
        b=uedS3B5SwqoaHvIy4Ml1Z+s3FuucIk1O6L+6U3WXnyuum5Za38KV3kBLZLdpO8fRJl
         YmqQ/LULm4VQrOpYSzWB94aTgVpmKOUBbNYdyVC8S89p5xPvvbX73f04UWQGXwXvDXOL
         3JEI7Szww7NR5R3jod+8QpPYl/MivWpiZjgixZXstMNSXrJZaMW6V6UpMWxBcE/BToJj
         TiWmr5pcxbxD9f12Gp6LWNwN6rFgC8bz2QQ4Gg2bLtoXB3zFwGRTbeHD8KK/rWGDSNH2
         DubPiQLMakyYm6KY6PWZUdpcxddt6UXw8UaGGc9bQYP/0VCi1qCj7ijWf9IuYcFkEyyD
         LhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1+c1Er8rSXXiSKmZT51/RstLkABp2JaioVD5358bhQg=;
        b=BqdetVpcEDV9NeLK31iCikSrlx9k66ZJGUerJ7JCstb6cIdrmAnSYi8ghP1xkYWNK7
         5URTSNjIHeXIsGEwcoQs8wlHNfHOUvBjAF3i4LePK77qBAvyRqLolNG5ukO2x1E0HRdL
         OCeSPwYJL9szaiknMbyAo6VRroxPMEiuF+LyMDUbC3JrcqusKWiT69GNGOThT6R0sWRZ
         aL+6wNrVEDet/jzG8SUTMpwxcYfcHOQwwEfk3S2f8lQZrZQBWEuqpBnOrWg/zMQd/pDo
         hyArdrIa4c7D3QkjEs3Li0/8sr1J4Ge+LwRr+4Hx2AxjWHdAmlMmtvGOV/tvjZJTLPrP
         R+yA==
X-Gm-Message-State: AOAM532p3lrWVU1o6fV6v1O0WvyKwyI+oOBvbFxawVu1sXvOqU1C/dAC
        Qai80Oc3Uf/Q7atx0IaPqSk=
X-Google-Smtp-Source: ABdhPJw3eFSfQ2K16dK7oMZk4zKzVrQ6LIF8mDW/YGrkpBeoYZsyQwmt379l1PRGnU3spb/0sVemjg==
X-Received: by 2002:adf:f90d:: with SMTP id b13mr16199764wrr.198.1612259555682;
        Tue, 02 Feb 2021 01:52:35 -0800 (PST)
Received: from AHABDELS-M-J3JG ([192.135.27.141])
        by smtp.gmail.com with ESMTPSA id u206sm2214705wme.12.2021.02.02.01.52.34
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 02 Feb 2021 01:52:34 -0800 (PST)
Date:   Tue, 2 Feb 2021 10:52:33 +0100
From:   Ahmed Abdelsalam <ahabdels.dev@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Suprit Japagal <suprit.japagal@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        David Lebrun <david.lebrun@uclouvain.be>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] NET: SRv6: seg6_local: Fixed SRH processing when
 segments left is 0
Message-Id: <20210202105233.b78404a6747aead2c087b4e4@gmail.com>
In-Reply-To: <5ac9c562-6bd6-1ab5-3504-b83dc58c15cc@gmail.com>
References: <20210131130840.32384-1-suprit.japagal@gmail.com>
        <5ac9c562-6bd6-1ab5-3504-b83dc58c15cc@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.21; x86_64-apple-darwin10.8.0)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation is correct. This patch is introducing incorrect 
symantic to SRv6 End and End.T behaviors.   

SRv6 End and End.T behaviors (among other behaviors) are defined in the 
SRv6 Network Programming draft (Soon to published as an RFC) [1].

SRv6 End and End.T behaviors are used to implement Traffic Engineering (TE)
use-cases, where a node recieves the packet and send it to the next SID from 
the SRH SIDList. 

Packets processed by End and End.T behaviors can not have a Segment Left Value 
of zero. 

Please refer to sections 4.1 and 4.3 of [1]. 


[1]https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming-28

Ahmed 


On Sun, 31 Jan 2021 10:33:14 -0700
David Ahern <dsahern@gmail.com> wrote:

> [ cc David Lebrun, author of the original code ]
> 
> On 1/31/21 6:08 AM, Suprit Japagal wrote:
> > From: "Suprit.Japagal" <suprit.japagal@gmail.com>
> > 
> > According to the standard IETF RFC 8754, section 4.3.1.1
> > (https://tools.ietf.org/html/rfc8754#section-4.3.1.1)
> > When the segments left in SRH equals to 0, proceed to process the
> > next header in the packet, whose type is identified by the
> > Next header field of the routing header.
> > 
> > Signed-off-by: Suprit.Japagal <suprit.japagal@gmail.com>
> > ---
> >  net/ipv6/seg6_local.c | 54 +++++++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 48 insertions(+), 6 deletions(-)
> > 
> > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > index b07f7c1..b17f9dc 100644
> > --- a/net/ipv6/seg6_local.c
> > +++ b/net/ipv6/seg6_local.c
> > @@ -273,11 +273,25 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  {
> >  	struct ipv6_sr_hdr *srh;
> >  
> > -	srh = get_and_validate_srh(skb);
> > +	srh = get_srh(skb);
> >  	if (!srh)
> >  		goto drop;
> >  
> > -	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > +	if (srh->segments_left > 0)
> > +		if (!seg6_hmac_validate_skb(skb))
> > +			goto drop;
> > +#endif
> > +
> > +	if (srh->segments_left == 0) {
> > +		if (!decap_and_validate(skb, srh->nexthdr))
> > +			goto drop;
> > +
> > +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> > +			goto drop;
> > +	} else {
> > +		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > +	}
> >  
> >  	seg6_lookup_nexthop(skb, NULL, 0);
> >  
> > @@ -293,11 +307,25 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  {
> >  	struct ipv6_sr_hdr *srh;
> >  
> > -	srh = get_and_validate_srh(skb);
> > +	srh = get_srh(skb);
> >  	if (!srh)
> >  		goto drop;
> >  
> > -	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > +	if (srh->segments_left > 0)
> > +		if (!seg6_hmac_validate_skb(skb))
> > +			goto drop;
> > +#endif
> > +
> > +	if (srh->segments_left == 0) {
> > +		if (!decap_and_validate(skb, srh->nexthdr))
> > +			goto drop;
> > +
> > +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> > +			goto drop;
> > +	} else {
> > +		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > +	}
> >  
> >  	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> >  
> > @@ -312,11 +340,25 @@ static int input_action_end_t(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  {
> >  	struct ipv6_sr_hdr *srh;
> >  
> > -	srh = get_and_validate_srh(skb);
> > +	srh = get_srh(skb);
> >  	if (!srh)
> >  		goto drop;
> >  
> > -	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > +	if (srh->segments_left > 0)
> > +		if (!seg6_hmac_validate_skb(skb))
> > +			goto drop;
> > +#endif
> > +
> > +	if (srh->segments_left == 0) {
> > +		if (!decap_and_validate(skb, srh->nexthdr))
> > +			goto drop;
> > +
> > +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> > +			goto drop;
> > +	} else {
> > +		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> > +	}
> >  
> >  	seg6_lookup_nexthop(skb, NULL, slwt->table);
> >  
> > 
> 


-- 
Ahmed Abdelsalam <ahabdels.dev@gmail.com>
