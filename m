Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C4F6AF746
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCGVLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjCGVLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:11:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C372A569C;
        Tue,  7 Mar 2023 13:11:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cw28so57813377edb.5;
        Tue, 07 Mar 2023 13:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678223498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D7ov6pYeEeAnC4WjtGYJ+7a7E67wYcuVz+STN09ArGQ=;
        b=andqcNwwE0JH3KXBTdQIeQnZtCDZGmvUOLKZeWezHPNz/d9EyxQ0meZVYdNskQOCE4
         OGkiz8O6Rh61bpXF1xP2tij4lZTn89FaGXVX/QtGc/qeHOKnIuQO907IRzpjcbTkn6Y+
         SYfyvaIibhOImy9jIz20vwoZWxro29iDkTL8oZh/9AgHY+94xO92xyYrnRsC7rRzhQ0u
         hKOVoudXLwnNHBJSiHu1KOHMkS8YbFTigjokVHaK8lT1tHbnSvPv7slQwtilq560aaYr
         BVuvjhTL2EtRQJbg/D7PifWw0t3PBYfigocu7dl9PZrOMhGfZUJcUHXC5eH2X4TrWn0A
         1Siw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678223498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7ov6pYeEeAnC4WjtGYJ+7a7E67wYcuVz+STN09ArGQ=;
        b=SL5ENtcsy288bg0JqkTmp4rrOjj/EdJGvKQny+JYD51j9Q7ocV4qCSqSM6z7Qnx0Kr
         e3L1cvp7tUz+RNC2B2njLg7OhtqHDgkmzqvh2z8sn/IDKihKT0QdM5TeXeml/T5GZXJ2
         Ip33upCv7F/CU84euuYFBEBYNAPTOKdTW4YZQC+bG9N3Y8yW1FiBF8FZ53JoWi6TEXDb
         fb/oVIdGmhQww2VjCsntH+xYimVSimAHQqOpNR9Y1+K3//ImGGmhP4Tra5bdfvbXAw4Y
         MdieKuXuCqaBgsh063sJKHhzum+XewCNjdRHDmOhR15+kQT0tupPYXWRPSddRa/Uw7SG
         XpCw==
X-Gm-Message-State: AO0yUKXpzpw3P43Bzm/daYSOC2ifX+qhQ6ppHz/OMtXY5MRAWbnsi3Rt
        2nyMZXCh1KhUKoJf4PM1qVDO8bkxWHEw/Q==
X-Google-Smtp-Source: AK7set+d4vEwUS7GQnnRZ0BiFkORJTho0ZAG3I0T6KrLrq2DtpEmxc9+lIGv0K/8rlT5clBWiY+hdQ==
X-Received: by 2002:aa7:dccb:0:b0:4ac:b4f3:b8a7 with SMTP id w11-20020aa7dccb000000b004acb4f3b8a7mr11156786edu.7.1678223497523;
        Tue, 07 Mar 2023 13:11:37 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m17-20020a50c191000000b004e7ffb7db11sm3048165edf.76.2023.03.07.13.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:11:37 -0800 (PST)
Date:   Tue, 7 Mar 2023 23:11:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230307211134.ref5gwbv52jd473r@skbuf>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
 <20230306140651.kqayqatlrccfky2b@skbuf>
 <20230306163542.GB11936@pengutronix.de>
 <20230307164614.jy2mzxvk3xgc4z7b@skbuf>
 <20230307182732.GA1692@pengutronix.de>
 <20230307185734.x2lv4j3ml3fzfzoy@skbuf>
 <20230307195250.GB1692@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307195250.GB1692@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 08:52:50PM +0100, Oleksij Rempel wrote:
> > > One more question is, what is actual expected behavior of mqprio if max_rate
> > > option is used? In my case, if max_rate is set to a queue (even to max value),
> > > then strict priority TSA will not work:
> > > queue0---max rate 100Mbit/s---\
> > >                                |---100Mbit/s---
> > > queue1---max rate 100Mbit/s---/
> > > 
> > > in this example both streams will get 49Mbit/s. My expectation of strict prio
> > > is that queue1 should get 100Mbit/s and queue 0Mbit/s
> > 
> > I don't understand this. Have you already implemented mqprio offloading
> > and this is what you observe?
> 
> Ack.
> 
> > max_rate is an option per traffic class. Are queue0 and queue1 mapped to
> > the same traffic class in your example, or are they not?
> 
> They are separate TCs. It is not possible to assign multiple TXQs to on TC on
> KSZ.
> 
> > Could you show the full ommand you ran?
> 
> tc qdisc add dev lan2 parent root handle 100 mqprio num_tc 4 map 0 1 2 3
> queues 1@0 1@1 1@2 1@3  hw 1 mode channel shaper bw_rlimit max_rate
> 70Mbit 70Mbit 70Mbit 70Mbit
> 
> lan2 is bridged with lan1 and lan3. Egress traffic on lan2 is from lan1 and lan3.
> For testing I use 2 iperf3 instances with different PCP values in the VLAN tag.
> Classification is done by HW (currently not configurable from user space)

Hmm, I still don't understand the question. First of all you changed the
data between messages - first you talk about max_rate 100 Mbps and then
you specify max_rate 70Mbit per traffic class. Possibly also the link
speeds are changed between the 2 examples. What is the link speed of the
egress port in the 2 examples?

The question is phrased as "what is the actual expected behavior" - that
would be easy - the traffic classes corresponding to the 2 TXQs are rate
limited to no more than 100 Mbps each. When the total sum of bandwidth
consumptions exceeds the capacity of the link is when you'll start
seeing prioritization effects.

If the question is why this doesn't happen in your case and they get
equal bandwidths instead (assuming you do create congestion), I don't know;
I have seen neither your implementation nor am I familiar with the
hardware. However, there are a few things I've noticed which might be of
help:

- the fact that you get 50-50 bandwidth allocation sounds an awful lot
  to me as if the TXQs are still operating in WRR mode and not in strict
  priority mode.

- the KSZ9477 datasheet says that rate limiting is per port, and not per
  queue, unless Switch MAC Control 5 Register bit 3 (Queue Based Egress
  Rate Limit Enable) is set.

- maybe you simply failed to convert the rates properly between the unit
  of measurement passed by iproute2 to the unit of measurement expected
  by hw. Here's a random comment from the ice driver:

		/* TC command takes input in K/N/Gbps or K/M/Gbit etc but
		 * converts the bandwidth rate limit into Bytes/s when
		 * passing it down to the driver. So convert input bandwidth
		 * from Bytes/s to Kbps
		 */

("TC command" means iproute2, the conversion is in the "get_rate64()" function)

> > sorry for the quick response, need to go right now
> 
> No proble. Have fun.

There wasn't anything funny to do, I had to rush to do some shopping
before the grocery stores closed.
