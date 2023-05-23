Return-Path: <netdev+bounces-4667-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 238CD70DCAC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD10128129F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B954A23;
	Tue, 23 May 2023 12:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4534A84E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:34:46 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F478DD;
	Tue, 23 May 2023 05:34:42 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id D8216C000E;
	Tue, 23 May 2023 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684845281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjjLHA4piWXe9Nt5jWQ61wpym3DoXg/n2DnHKkoOboc=;
	b=lXAq1/cPGZX+AQhroWjiTrX4TMT4vEs/P2cWLMwEHX96c16hq9L0iIPVvpNN9V8FbZlE+C
	ELclEIu8h9/Yxx+z06pHxwbZwZpCEe3Li8eGVadS55Zje0/clR3ZeSlbme9BqpqZwVn9HX
	nqyB2rI/YPDtirz5MReY1HOTnxJoTC+hzp+lFRN5xIZyWqEuK3UWJ6bREkknzwSOvJm+5j
	pxEo8eAUnCih1zQRYbtKf6u2MrHZ1WF7GJjQIT8lzqVd+uP3kr/4q73Vfvxyvo1QQt4WJl
	lBennWDv2VUMpbEafrYe5vRPy9WzyDFB8kxsaf8VMxPJrONbqysTOfdKCrFlqA==
Date: Tue, 23 May 2023 14:34:33 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org"
 <devicetree@vger.kernel.org>, "thomas.petazzoni@bootlin.com"
 <thomas.petazzoni@bootlin.com>, Andrew Lunn <andrew@lunn.ch>, Florian
 Fainelli <f.fainelli@gmail.com>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Luka Perkov
 <luka.perkov@sartura.hr>, Robert Marko <robert.marko@sartura.hr>, Andy
 Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad
 Dybcio <konrad.dybcio@somainline.org>, romain.gantois@bootlin.com
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20230523143433.28947c34@pc-7.home>
In-Reply-To: <20221115115023.hgc4ynrx3kylf6p3@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
	<20221104174151.439008-4-maxime.chevallier@bootlin.com>
	<20221104200530.3bbe18c6@kernel.org>
	<20221107093950.74de3fa1@pc-8.home>
	<6b38ec27-65a3-c973-c5e1-a25bbe4f6104@nbd.name>
	<20221115102924.1329b49f@pc-7.home>
	<20221115115023.hgc4ynrx3kylf6p3@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello everyone,

I'm digging this topic up, it has we'd like to move forward with the
upstreaming of this, and before trying any new approach, I'd like to
see if we can settle on one of the two choices that were expressed so
far.

To summarize the issue, this hardware platform (IPQ4019 from Qualcomm)
uses an internal switch that's a modified QCA8K, for which there
already is a DSA driver. On that platform, there's a MAC (ipqess)
connected to the switch, that passes the dst/src port id through the
DMA descriptor, whereas a typical DSA switch would pass that
information in the frame itself.

There has been a few approaches to try and reuse DSA as-is with a
custom tagger, but all of them eventually got rejected, for a good
reason.

Two solutions are proposed, as discussed in that thread (hence the
top-posting, sorry about that).

There are two approaches remaining, either implementing DSA tagging
offload support in RX/TX, or having a DSA frontend for the switch (the
current QCA8K driver) and a switchdev frontend, using the qca8k logic
with the ESS driver handling transfers for the CPU port.

As both approaches make sense but are quite opposed, I'd like to make
sure we go in the right direction. The switchdev approach definitely
makes a lot of sense, but the DSA tagging offloading has been in
discussion for quite a while, starting with Florian's series, followed
by Felix's, and this could also be a good occasion to move forward with
this, and it would also involve a minimal rework of the current ipqess
driver.

Any pointer would help,

Thanks everyone,

Maxime

On Tue, 15 Nov 2022 11:50:23 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Tue, Nov 15, 2022 at 10:29:24AM +0100, Maxime Chevallier wrote:
> > Hello everyone,
> > 
> > Felix, thanks for the feedback !
> > 
> > On Tue, 8 Nov 2022 13:22:17 +0100
> > Felix Fietkau <nbd@nbd.name> wrote:
> > 
> > [...]
> >   
> > > FYI, I'm currently working on hardware DSA untagging on the
> > > mediatek mtk_eth_soc driver. On this hardware, I definitely need
> > > to keep the custom DSA tag driver, as hardware untagging is not
> > > always available. For the receive side, I came up with this patch
> > > (still untested) for using METADATA_HW_PORT_MUX.
> > > It has the advantage of being able to skip the tag protocol rcv
> > > ops call for offload-enabled packets.
> > > 
> > > Maybe for the transmit side we could have some kind of netdev
> > > feature or capability that indicates offload support and allows
> > > skipping the tag xmit function as well.
> > > In that case, ipqess could simply use a no-op tag driver.  
> > 
> > If I'm not mistaken, Florian also proposed a while ago an offload
> > mechanism for taggin/untagging :
> > 
> > https://lore.kernel.org/lkml/1438322920.20182.144.camel@edumazet-glaptop2.roam.corp.google.com/T/
> > 
> > It uses some of the points you're mentionning, such as the netdev
> > feature :)
> > 
> > All in all, I'm still a bit confused about the next steps. If I can
> > summarize a bit, we have a lot of approaches, all with advantages
> > and inconvenients, I'll try to summarize the state :
> > 
> >  - We could simply use the skb extensions as-is, rename the tagger
> >    something like "DSA_TAG_IPQDMA" and consider this a way to
> > perform tagging on this specific class of hardware, without trying
> > too hard to make it generic.  
> 
> For Felix, using skb extensions would be inconvenient, since it would
> involve per packet allocations which are now avoided with the metadata
> dsts.
> 
> >  - We could try to move forward with this mechanism of offloading
> >    tagging and untagging from the MAC driver, this would address
> >    Florian's first try at this, Felix's use-case and would fit well
> > the IPQESS case  
> 
> Someone would need to take things from where Felix left them:
> https://patchwork.kernel.org/project/netdevbpf/patch/20221114124214.58199-2-nbd@nbd.name/
> and add TX tag offloading support as well. Here there would need to be
> a mechanism through which DSA asks "hey, this is my tagging protocol,
> can the master offload it in the TX direction or am I just going to
> push the tag into the packet?". I tried to sketch here something
> along those lines:
> https://patchwork.kernel.org/project/netdevbpf/patch/20221109163426.76164-10-nbd@nbd.name/#25084481
> 
> >  - There's the option discussed by Vlad and Jakub to add several
> >    frontends, one being a switchev driver, here I'm a bit lost TBH,
> > if we go this way I could definitely use a few pointers from Vlad
> > :)  
> 
> The assumption being here that there is more functionality to cover by
> the metadata dst than a port mux. I'm really not clear what is the
> hardware design truly, hopefully you could give more details about
> that.

TBH the documentation I have is pretty limited, I don't actually know
what else can go in the metadata attached to the descriptor :(

> The mechanism is quite simple, it's not rocket science. Take something
> like a bridge join operation, the proposal is to do something like
> this:
> 
>     dsa_slave_netdevice_event
>         (net/dsa/slave.c)
>                |
>                v
>       dsa_slave_changeupper
>        (net/dsa/slave.c)
>                |
>                v
>        dsa_port_bridge_join
> ocelot_netdevice_event (net/dsa/port.c)
> (drivers/net/ethernet/mscc/ocelot_net.c) |
>                | v                                           v
>      dsa_switch_bridge_join
> ocelot_netdevice_changeupper (net/dsa/switch.c)
> (drivers/net/ethernet/mscc/ocelot_net.c) |
>                | v                                           v
>        felix_bridge_join
> ocelot_netdevice_bridge_join (drivers/net/dsa/ocelot/felix.c)
>  (drivers/net/ethernet/mscc/ocelot_net.c) |
>                 | |                                           |
>                +---------------------+---------------------+
>                                      |
>                                      v
>                            ocelot_port_bridge_join
>                       (drivers/net/ethernet/mscc/ocelot.c)
> 
> with you maintaining the entire right branch that represents the
> switchdev frontend, and more or less duplicates part of DSA.
> 
> The advantage of this approach is that you can register your own NAPI
> handler where you can treat packets in whichever way you like, and
> have your own ndo_start_xmit. This driver would treat the aggregate
> of the ess DMA engine and the ipq switch as a single device, and
> expose it as a switch with DMA, basically.

