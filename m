Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEA92DA296
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503529AbgLNVdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:33:03 -0500
Received: from smtp-outgoing.laposte.net ([160.92.124.96]:54219 "EHLO
        smtp-outgoing.laposte.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387804AbgLNVdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:33:03 -0500
X-mail-filterd: {"version":"1.2.0","queueID":"4Cvvbv27ZDz10MQQ","contextId":"e4100a5d-ddc4-4ab8-ae96-0fcdda228721"}
Received: from outgoing-mail.laposte.net (localhost.localdomain [127.0.0.1])
        by mlpnf0120.laposte.net (SMTP Server) with ESMTP id 4Cvvbv27ZDz10MQQ;
        Mon, 14 Dec 2020 22:27:07 +0100 (CET)
X-mail-filterd: {"version":"1.2.0","queueID":"4Cvvbv1641z10MQN","contextId":"220a356f-d0ad-4082-9009-5fa2bef692ab"}
X-lpn-mailing: LEGIT
X-lpn-spamrating: 36
X-lpn-spamlevel: not-spam
X-lpn-spamcause: OK, (-100)(0000)gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgudehtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfntefrqffuvffgpdfqfgfvpdggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujgesthdttddttddtvdenucfhrhhomhepgghinhgtvghnthcuufhtvghhlhoruceovhhinhgtvghnthdrshhtvghhlhgvsehlrghpohhsthgvrdhnvghtqeenucggtffrrghtthgvrhhnpeelvdegveegieejudelieehteffjeffieeffeeileehhfetffdvveeljeevveejieenucfkphepkeekrdduvddurddugeelrdegleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehrohhmuhgrlhgurdgsvghrghgvrhhivgdpihhnvghtpeekkedruddvuddrudegledrgeelpdhmrghilhhfrhhomhepvhhinhgtvghnthdrshhtvghhlhgvsehlrghpohhsthgvrdhnvghtpdhrtghpthhtohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehkuhgsrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhifiheslhhinhhugidrihgsmhdrtghomhdprhgtphhtthhopehflhhorhhirghnrdhfrghinhgvlhhlihesthgvlhgvtghomhhinhhtrdgvuhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkv
 ghrnhgvlhdrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Received: from romuald.bergerie (unknown [88.121.149.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mlpnf0120.laposte.net (SMTP Server) with ESMTPSA id 4Cvvbv1641z10MQN;
        Mon, 14 Dec 2020 22:27:07 +0100 (CET)
Received: by romuald.bergerie (Postfix, from userid 1000)
        id C55893DFAA08; Mon, 14 Dec 2020 22:27:06 +0100 (CET)
Date:   Mon, 14 Dec 2020 22:27:06 +0100
From:   Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [PATCH] net: korina: remove busy skb free
Message-ID: <X9fYqvy2DjB/Cp/V@romuald.bergerie>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
References: <20201213172052.12433-1-vincent.stehle@laposte.net>
 <ecd7900f-8b54-23e2-2537-033237e08597@linux.ibm.com>
 <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=laposte.net; s=lpn-wlmd; t=1607981230; bh=EhCVq64/QG0QI4s/bViYBnWqEScfemWkVU+ds5VcEIw=; h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To; b=YE77RI7dsk0YN9+oHaDpWa7OxVmDqJ8EV7c3XKPtO9iL1TPBM907q2p4RRTugGqPDcltKPsPGKRRS8CnZVBaIxKHxwma7wesFS6AgKewrwvjHNltRTRL3DD/wMmQVs7G633yeAO+uwhwNYPGrpzZ9+WPNN6GsuZBD799SvL2+RYxdC7LuMJ3vYLtICXXS2zACevBU6cGkHAWIuY0ZusHhbB+G7pbuunMjl2ggoOTiaLDcP581OnkRCweU15+bFD8L/XboPEUmJ/ZPE2GjAoTIdG5BOxgwEF5nQA0BSB3W1L0u2rqlyfoLESfJ80aEqS2zYeHCM0zqV7M8qKdSZEsjw==;
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 01:08:32PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Dec 2020 11:03:12 +0100 Julian Wiedmann wrote:
> > > diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> > > index bf48f0ded9c7d..9d84191de6824 100644
> > > --- a/drivers/net/ethernet/korina.c
> > > +++ b/drivers/net/ethernet/korina.c
> > > @@ -216,7 +216,6 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
> > >  			netif_stop_queue(dev);
> > >  		else {
> > >  			dev->stats.tx_dropped++;
> > > -			dev_kfree_skb_any(skb);
> > >  			spin_unlock_irqrestore(&lp->lock, flags);
> > >  
> > >  			return NETDEV_TX_BUSY;
> > >   
> > 
> > As this skb is returned to the stack (and not dropped), the tx_dropped
> > statistics increment looks bogus too.
> 
> Since this is clearly an ugly use after free, and nobody complained we
> can assume that the driver correctly stops its TX queue ahead of time.
> So perhaps we can change the return value to NETDEV_TX_OK instead.

Hi Jakub,

Thanks for the review.

Ok, if this is the preferred fix I will respin the patch this way.

Best regards,
Vincent.
