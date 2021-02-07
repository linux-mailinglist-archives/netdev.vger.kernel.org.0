Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E249312091
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBGARC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGARB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 19:17:01 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5994C06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 16:16:20 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w2so18935186ejk.13
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 16:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yrdc3ueVgaJQWXiOH7N88Gkl1b5g4WUljgwYHy0oroo=;
        b=YnPmFSZd8tuPsipZbDcBQuftO5+AIhKjrAKmJNIm0B9EzlPSHVDs1kZXl8sDJngSHs
         OWPfUvL0Oyo+Eg0jJzEMT5TjhhmnRByJc0BAVOV21M2u4eB17/+iZgO6eCS/NAk0R50+
         e0I/kpVZfbrMVhzxnQY4PWKeeiLLyHTLrvOpNaLqpo65vlzF+2jwy3jG+Iaw+vVHJ0C6
         V7AZd6RhqKjPiQvgGTjj7RITwsHfR3SBjs5P7pPeYseVPmL27/6ysM14ySfPDYnZHcuN
         9/V1/w999lnJoePhqwdQAJpHI9c9+3L0bdrwsKeJn6D84HsAkl+Uo/80K5rZlnC182t8
         s9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yrdc3ueVgaJQWXiOH7N88Gkl1b5g4WUljgwYHy0oroo=;
        b=YWsQ6Uw6/7FWenbSW6jDPLGx54IkuQFd8DUGyYoPZLdpGXWzpuC9Q27iluYk1iMUwK
         juixDCAg2TrM9r+HLN2m6SQSyuHpJ12frOZrCon0OHL0F0jw8V5/RIlHOjZ6PtMhNs5C
         wbLqMLKveD6cOiMzP2gHxdqShO/6wbGEaslKsdR8KsBa1p+8X/wROchs6rHB50carPkh
         thdka7RTRgRPvWe6Yhxu75N1M6cQPUeEi7noNQAqltVLjEF8qKLZvkNAcH6RlOaxZsyx
         JB6IUNpvA+ItAjjwWdqUM9jc/Job91AmOwCw8QrrYbXQ8vZeD6TviD+y2n7US01DzZy+
         5f+A==
X-Gm-Message-State: AOAM533a3ySPSezETXoJYQuFW319baBE6o/1J85AVBalcFs+5KEN5tAB
        AZ7Ulyb0qrCGKXlMjpNOgm8=
X-Google-Smtp-Source: ABdhPJwNHL88+o8kMCi52sVkGqBCoPycrcA1BgtmjBiLvHVgRrBovMUDH2GCpSfi2YUpFqLZSkkOaQ==
X-Received: by 2002:a17:906:7191:: with SMTP id h17mr10998731ejk.54.1612656979290;
        Sat, 06 Feb 2021 16:16:19 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lf26sm5880388ejb.4.2021.02.06.16.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 16:16:18 -0800 (PST)
Date:   Sun, 7 Feb 2021 02:16:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: allow port mirroring towards foreign
 interfaces
Message-ID: <20210207001617.p3ohj754mi5vrydb@skbuf>
References: <20210205223355.298049-1-olteanv@gmail.com>
 <fead6d2a-3455-785a-a367-974c2e6efdf3@gmail.com>
 <20210205230521.s2eb2alw5pkqqafv@skbuf>
 <20210206155857.1d983d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210206155857.1d983d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 06, 2021 at 03:58:57PM -0800, Jakub Kicinski wrote:
> > For ingress mirroring there should be nothing special about the mirror
> > packets, it's just more traffic in the ingress data path where the qdisc
> > hook already exists.
> 
> For ingress the only possible corner case seems to be if the filter has
> SKIP_SW set, then HW will send to CPU but SW will ignore.

Correct, but I'm not sure if this requirement can be enforced at driver
level though.

> That's assuming the frame still comes on the CPU appropriately tagged.

For ingress mirroring I think the assumption that it does is reasonable,
since the packet should be mirrored before the forwarding took place, it
can only have one DSA tag and that would be the tag where the source
port is the ingress port.
For egress mirroring, software would need to see the mirrored packet as
coming from the egress port, and this would mean that the source port in
the DSA frame header would have to be equal to the egress port.

> > For egress mirroring I don't think there's really any way for the mirred
> > action to take over the packets from what is basically the ingress qdisc
> > and into the egress qdisc of the DSA interface such that they will be
> > redirected to the selected mirror. I hadn't even thought about egress
> > mirroring. I suppose with more API, we could have DSA do introspection
> > into the frame header, see it's an egress-mirrored packet, and inject it
> > into the egress qdisc of the net device instead of doing netif_rx.
> 
> IMHO it's not very pretty but FWIW some "SmartNIC" drivers already do
> a similar thing. But to be clear that's just an optimization, right?
> The SW should still be able to re-process and come to the same
> decisions as the switch, provided SKIP_SW was not set?

I guess what would need to happen is that we'd need to do something like
this, from the DSA tagging protocol files:

	if (is_egress_mirror(skb)) {
		skb_get(skb);
		skb_push(skb, ETH_ALEN);
		skb = sch_handle_egress(skb, &err, skb->dev);
		if (skb)
			consume_skb(skb);
		return NULL;
	}

basically just run whatever tc filters there might be on that packet (in
our case mirred), then discard it.

It's not an optimization thing. Egress mirrored traffic on a DSA switch
is still ingress traffic from software's perspective, so it won't match
on any mirred action on any egress qdisc. Only packets sent from the
network stack would match the mirred egress mirror rule, however there
might be lots of offloaded flows which don't.

Or I might just be misunderstanding.

> > The idea with 2 mirrors might work however it's not amazing and I was
> > thinking that if we bother to do something at all, we could as well try
> > to think it through and come up with something that's seamless for the
> > user.
