Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041E25F6134
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 08:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJFGtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 02:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJFGtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 02:49:19 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D668A7DD
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 23:49:18 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 137E6320092F;
        Thu,  6 Oct 2022 02:49:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 06 Oct 2022 02:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1665038953; x=1665125353; bh=K2MA9MmNhFqB/t7A/RJ/77WX2CVn
        Md+WjbYI+WjG+6w=; b=u5l1Pt+Lj72SlkAEdqVAJNHy1q/pFwaJY1vs4xrNUh7H
        I//O8NNI2M2LbR/toWFuHshfi2Gy2y4csETCWenIY/dBWhyPjtJnMqkt5lxn8cC8
        cAO0tfT77sqGakuf0H/RJKbCLIg/Tqn/zOue6IUngmCKEgMA8GwGwlv8ZnfqOY0D
        4k3TjmmiwjUjhld4DN444CH+tQt3CX72a3E8jLofd7wr7a8WUVgv2Pf0LTyvwshm
        k1FpiIMRHnDkZffpoK4YHuiHtdRxownOO2VLgNyDaen/2xgjEY+YUMY7aGGCWOWq
        TbTPRhNDZovd7Nt/4lzUHltiVZjXu01xPKB4eOFPug==
X-ME-Sender: <xms:aXo-Y3DuG3WA6773eBj3JoFYa0KUw24xFZoXMZWQCwIMu1FM51fFoA>
    <xme:aXo-Y9hBUyzNmuHAC2Eku4t8FieXBpUUxUJdJiqYsBA19LfdNxgeYsORa_-KjIhc1
    nnNqajLnxXSzxg>
X-ME-Received: <xmr:aXo-YylxG6f42tJDUDA1xoFmQOARsAOPHgWoCm4Ihjmr3q9cBRxltHbCszGLlOciv2w1JZm1lCNm4cU0yVYp4juTEgk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeigedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedtjeefhefgteevtdejfeeutdduhffhjeeiieffiefhhfekveefteeifffh
    kedtudenucffohhmrghinhepnhgvgihthhhophhsrdhshhenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:aXo-Y5xwCfOBgMs6tQyrgwDhYiopr8Fnd77le2EyyhDAKupK4VI5Tg>
    <xmx:aXo-Y8TeREoykz7Gx16JublUhER5F-8OSnf25XY3amPdYAAyF67FZA>
    <xmx:aXo-Y8aNDVUFhncieT-EBe8AoFL9doJbCtsHLitlvdafOAih2Ae4Hg>
    <xmx:aXo-YyemE79jB89jmR-eBmQDOm1ksbOVW0JQ4ShlCbnMOZ28zXVNTg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Oct 2022 02:49:12 -0400 (EDT)
Date:   Thu, 6 Oct 2022 09:49:08 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, Gwangun Jung <exsociety@gmail.com>
Subject: Re: [PATCH net] ipv4: Handle attempt to delete multipath route when
 fib_info contains an nh reference
Message-ID: <Yz56ZBVMUC/vmKhP@shredder>
References: <20221005181257.8897-1-dsahern@kernel.org>
 <Yz3WE+cBd9YUj7Bp@shredder>
 <84202713-ec7c-1e5e-8d9f-d36e715c81e4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84202713-ec7c-1e5e-8d9f-d36e715c81e4@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 01:27:59PM -0600, David Ahern wrote:
> On 10/5/22 1:08 PM, Ido Schimmel wrote:
> > On Wed, Oct 05, 2022 at 12:12:57PM -0600, David Ahern wrote:
> >> Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
> >>     fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
> >>     fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
> >>     inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874
> >>
> >> Separate nexthop objects are mutually exclusive with the legacy
> >> multipath spec. Fix fib_nh_match to return if the config for the
> >> to be deleted route contains a multipath spec while the fib_info
> >> is using a nexthop object.
> > 
> > Cool bug... Managed to reproduce with:
> > 
> >  # ip nexthop add id 1 blackhole
> >  # ip route add 192.0.2.0/24 nhid 1
> >  # ip route del 192.0.2.0/24 nexthop via 198.51.100.1 nexthop via 198.51.100.2
> 
> that's what I did as well.

:)

> 
> > 
> > Maybe add to tools/testing/selftests/net/fib_nexthops.sh ?
> 
> I have one in my tree, but in my tests nothing blew up or threw an error
> message. It requires KASAN to be enabled otherwise the test does not
> trigger anything.

That's fine. At least our team is running this test as part of
regression on a variety of machines, some of which run a debug kernel
with KASAN enabled. The system knows to fail a test if a splat was
emitted to the kernel log.

> 
> > 
> > Checked IPv6 and I don't think we can hit it there, but I will double
> > check tomorrow morning.
> > 
> >>
> >> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> >> Reported-by: Gwangun Jung <exsociety@gmail.com>
> >> Signed-off-by: David Ahern <dsahern@kernel.org>
> >> ---
> >>  net/ipv4/fib_semantics.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> 
> > 
> > There is already such a check above for the non-multipath check, maybe
> > we can just move it up to cover both cases? Something like:
> > 
> > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > index 2dc97583d279..e9a7f70a54df 100644
> > --- a/net/ipv4/fib_semantics.c
> > +++ b/net/ipv4/fib_semantics.c
> > @@ -888,13 +888,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
> >  		return 1;
> >  	}
> >  
> > +	/* cannot match on nexthop object attributes */
> > +	if (fi->nh)
> > +		return 1;
> 
> that should work as well. I went with the simplest change that would
> definitely not have a negative impact on backports.

Ha, I see this hunk was added by 6bf92d70e690b. Given how overzealous
the AUTOSEL bot is, I don't expect this fix to be missing from stable
kernels. If you also blame 6bf92d70e690b (given it was apparently
incomplete), then it makes it clear to anyone doing the backport that
6bf92d70e690b is needed as well.

I prefer having the check at the beginning because a) It would have
avoided this bug b) It directly follows the 'cfg->fc_nh_id' check,
making it clear that we never match if nexthop ID was not specified, but
we got a FIB info with a nexthop object.

> 
> 
> > +
> >  	if (cfg->fc_oif || cfg->fc_gw_family) {
> >  		struct fib_nh *nh;
> >  
> > -		/* cannot match on nexthop object attributes */
> > -		if (fi->nh)
> > -			return 1;
> > -
> >  		nh = fib_info_nh(fi, 0);
> >  		if (cfg->fc_encap) {
> >  			if (fib_encap_match(net, cfg->fc_encap_type,
> 
