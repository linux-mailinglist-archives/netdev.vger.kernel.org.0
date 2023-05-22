Return-Path: <netdev+bounces-4144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B0A70B4F7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 08:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0B681C209B1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 06:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23561114;
	Mon, 22 May 2023 06:22:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD1946AD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 06:22:52 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCC3CF
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 23:22:51 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id AB9DD5C00AE;
	Mon, 22 May 2023 02:22:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 May 2023 02:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684736570; x=1684822970; bh=wvYvHdMM3vV8l
	5emClYjU1eLjnfxNNlZgj4NI3UoUC4=; b=tByulWrDlvGeiOKSbPxpfEhNl2AJB
	RjUlc9fFSTZRPAei//+dJPwzuhHUiSAbA4yBqEFnqzAHtGFGd3OyLlA/GKpAiJey
	mnb6pXQ1H2KAIALEp1kdzD00XEpQuOXRAp2kPL8SWqpV1pUF8yBvVGmPBe5w99sT
	lTc+z3hPvXLnYSOgL9f/Ox9G+sEbJOiuTGMNddyS9WkEx+lBlQ+HKHASmVlfqKgg
	kuW5rLOqZyoQjflPtS8myLQher7Y0KldrQuqsT/ppzXOFwTmzmmrb1TKx6rfVOWv
	hWMEXWaGs/A7VXA36CSMVQljm4tdGWC96RkSR5U2UV3RO7EJm0K4fEJqA==
X-ME-Sender: <xms:OgprZIgpCjT_0VGEsBXRsPw3XiZE4CVC1lV1yWdXLlVuBvWU4mdWZw>
    <xme:OgprZBD7-cqrguSMfJXRrHNq9at-N9IxabRqCnMnyuG9hfbfjmgEU2Um3fsb1CZdp
    cSoPy_XMGiojzU>
X-ME-Received: <xmr:OgprZAGeIE7DTEP7qyWIZZJVr4TwIQh6WGM58Z7xTr_7rLpPGxQSURpdlnry>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejtddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeeffeeugeehheelleegheejgfeiledtueetkeekfeehjeduffelfefgledu
    hefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:OgprZJSYp11dn-FuShH_3YM3UjRAT6n0_s96tC7jFQXFQiGnRwT5NA>
    <xmx:OgprZFyzJLDgjhC55E7540KuidvgBCoP3D8o6BpUtN8Zh-tMy9slFw>
    <xmx:OgprZH6ie5rFnjYyVE6fz8VmHB2c45JrcrMhTEUeXDxBTLhOVzXTvQ>
    <xmx:OgprZIqYqsMM6gietG-xRDUZ63bfuK1KXPLyO4jcvDpad4lBOOb-7A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 May 2023 02:22:49 -0400 (EDT)
Date: Mon, 22 May 2023 09:22:48 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: stephen@networkplumber.org, dsahern@gmail.com, netdev@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
	liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGsKOHxuFMSomUUI@shredder>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder>
 <87lehgsxyn.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lehgsxyn.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 02:03:37PM +0800, Vladimir Nikishkin wrote:
> 
> Ido Schimmel <idosch@idosch.org> writes:
> 
> > On Sun, May 21, 2023 at 01:49:48PM +0800, Vladimir Nikishkin wrote:
> >> +	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
> >> +	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
> >            ^ Unaligned 
> >
> >> +		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
> >
> > Missing space after "localbypass":
> >
> > # ip -d link show dev vxlan0
> > 10: vxlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
> >     link/ether ce:10:63:1d:f3:a8 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
> >     vxlan id 10 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum localbypassnoudp6zerocsumtx [...]
> >
> > Should be:
> >
> > print_bool(PRINT_ANY, "localbypass", "localbypass ", true);
> >
> >> +	}
> >
> > Parenthesis are unnecessary in this case.
> >
> > I disagree with Stephen's comment about "Use presence as a boolean in
> > JSON". I don't like the fact that we don't have JSON output when
> > "false":
> >
> >  # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
> >  true
> >  # ip link set dev vxlan0 type vxlan nolocalbypass
> >  # ip -d -j -p link show dev vxlan0 | jq '.[]["linkinfo"]["info_data"]["localbypass"]'
> >  null
> >
> > It's inconsistent with other iproute2 utilities such as "bridge" and
> > looks very much like an oversight in the initial JSON output
> > implementation.
> >
> > IOW, I don't have a problem with the code in v4 or simply:
> >
> > @@ -613,6 +622,10 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> >                 }
> >         }
> >  
> > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]));
> > +
> >         if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
> >                 __u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
> 
> If the two maintainers disagree, I am even more confused.

Stephen and David are the maintainers.

> 
> Shall I restore version 4? Use print_bool unconditionally, and add the
> json context check back into the code?

Please wait for their reply before sending another version. Ultimately
it's their call. It's better to decide now how we want to handle boolean
VXLAN options than repeating this discussion the next time a new option
is added.

