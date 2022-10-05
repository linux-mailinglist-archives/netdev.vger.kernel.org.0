Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FEC5F5A67
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 21:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJETIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 15:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiJETIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 15:08:14 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8059678214
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 12:08:12 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B29853200B6D;
        Wed,  5 Oct 2022 15:08:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 05 Oct 2022 15:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664996888; x=1665083288; bh=bWBFvLjjXU2QoI/WeY/XeVHjKS8k
        uKEnhsSosIDH3hk=; b=NXhvnjZUbWVH6PJIP4g4P6w2lCWUkmKF/GnknFO2SX0Y
        nKxyiNnz4SqhoR/fmlLuWXsUXpCfOQp8FKGR7Kqcy6DRzXqFMaQmYqZsRnq5cycj
        E39qK4H5rvJQf2BFvtlyCR4pJe+YvnTReX61RdfC/uPuybuwUzC9jC4Oddtfh0Rl
        QRTWoMVhcPzxhgWFI3uhEPT/waB0KrdNMrsx0tb11nOSaZp1rRjVOlJ/2y3xA3KC
        txcl6VaYzo6j/X+/vcUHAt5X/fqoqpml2n9is+6pYE76aB3DfdtU2sG2tBok37Th
        szZN2mGZhx1WGDcYAhgZkFjCnnUzTS+3YiggdgpNvw==
X-ME-Sender: <xms:GNY9Y6A01SLAcUFolg3Ic75T12OFdq9uBRLGwrjzaWH6rZ4NcsehIQ>
    <xme:GNY9Y0hEhe2ZemaI3C3IM9XWXoFvh4MDjFNcgP1wXldngnMzgEoKxfC1q9xZumqDD
    5ug0LFAPEgtE0Y>
X-ME-Received: <xmr:GNY9Y9ka1zYNkwN7oinhR4o4oIBM6ukCEpDGgAuwYfDJ2QgovV-0rMikqcB8M71w8g33eqz3YOntEZFlvh0akmYeHEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeifedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedtjeefhefgteevtdejfeeutdduhffhjeeiieffiefhhfekveefteeifffh
    kedtudenucffohhmrghinhepnhgvgihthhhophhsrdhshhenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:GNY9Y4zQpM4gOEIgdYhYriOvC2hkmxUQaY0Vi-9QteYKN0rX83YtEQ>
    <xmx:GNY9Y_RX3vTKC3abqGfd0apdp4zCz9lrgSiMy2idV0dY9aefH0YxJg>
    <xmx:GNY9YzZHhzMhFjDBhbx5rWdh8pVxD3qdBvw41W913DtRzdezbtwG8Q>
    <xmx:GNY9Y5cdIWRxAkSA8RRu-wtIkJe_cs0JUz1ThSZsM3gxKlBKmwSouA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Oct 2022 15:08:07 -0400 (EDT)
Date:   Wed, 5 Oct 2022 22:08:03 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, Gwangun Jung <exsociety@gmail.com>
Subject: Re: [PATCH net] ipv4: Handle attempt to delete multipath route when
 fib_info contains an nh reference
Message-ID: <Yz3WE+cBd9YUj7Bp@shredder>
References: <20221005181257.8897-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005181257.8897-1-dsahern@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 12:12:57PM -0600, David Ahern wrote:
> Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
>     fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
>     fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
>     inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874
> 
> Separate nexthop objects are mutually exclusive with the legacy
> multipath spec. Fix fib_nh_match to return if the config for the
> to be deleted route contains a multipath spec while the fib_info
> is using a nexthop object.

Cool bug... Managed to reproduce with:

 # ip nexthop add id 1 blackhole
 # ip route add 192.0.2.0/24 nhid 1
 # ip route del 192.0.2.0/24 nexthop via 198.51.100.1 nexthop via 198.51.100.2

Maybe add to tools/testing/selftests/net/fib_nexthops.sh ?

Checked IPv6 and I don't think we can hit it there, but I will double
check tomorrow morning.

> 
> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> Reported-by: Gwangun Jung <exsociety@gmail.com>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv4/fib_semantics.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 2dc97583d279..17caa73f57e6 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -926,6 +926,10 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
>  	if (!cfg->fc_mp)
>  		return 0;
>  
> +	/* multipath spec and nexthop id are mutually exclusive */
> +	if (fi->nh)
> +		return 1;
> +
>  	rtnh = cfg->fc_mp;
>  	remaining = cfg->fc_mp_len;

There is already such a check above for the non-multipath check, maybe
we can just move it up to cover both cases? Something like:

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2dc97583d279..e9a7f70a54df 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -888,13 +888,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	/* cannot match on nexthop object attributes */
+	if (fi->nh)
+		return 1;
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
