Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984F3520E8F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbiEJHhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239357AbiEJHNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:13:23 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C2E2AC6FB
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 00:09:26 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 5122B5C0058;
        Tue, 10 May 2022 03:09:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 10 May 2022 03:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652166564; x=
        1652252964; bh=p9mILSzH6fUBHeedgTz4JmckqlK8TrOpRupTpvWyVe0=; b=x
        3y3kv7PaLZATHk0xv/eYxw9nycJyoNOZ0zhC+DSQXr6fcScNqTpJ1jtWlPi00i6F
        eRUGJX3ViCbF5GWPRPkavMj7H33yE+RF64v/IUQWkIK5VgNcQlk8w81BXYUSvYWS
        g5TW37OCAYlwAIK3OBIwW3ljA6Rl/90yRO+P7Mb9Lesq/ZSAotsVBTxMnpEeXnFs
        kJ++uplY6QyK/nQcT2/7O8H0/VI/SVPtf8lAvU9yrxUfxutHFICK/IvmtnaijeSd
        Tt9HUXZlheIRx4PK//GBrhy7SHrzZvY3Ku622UpFJpSbp7gkvvTxOXmgrhmaQw0U
        GtzXbbUYb7Shn0ILxtezg==
X-ME-Sender: <xms:pA96YiWbIJN9Q9yNPt4mA2ms5R7AUsyTrpE9hz_Cqv-Gp8j-ZR0XHQ>
    <xme:pA96YuloV1Rt238PEm9RV7-tSu-Y5XK_PyNvSUGSHlcdmHABCVtvA8CfuYx1CTx17
    _wNP7c8ZKW9lpo>
X-ME-Received: <xmr:pA96YmZZpS1s5mymhGIqUyEI4Jfv3z2_tET9JPwINITS3uVoHUPqc7qkZe5cob89u7Bdx3sCKKqi1Rt_x9bbCcbn7z8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedtgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:pA96YpUgpCATXk1xq9hZAnZh-6DKq6yWEe3b1X3rymQsmz9fcl4MyQ>
    <xmx:pA96YsmBx9YpuBlGqckR9qrc4rjhTqTxB1sea0wXExPftyew-IrUxA>
    <xmx:pA96Yud0vyVk6lGd-JZclNz8ZYqTFy1XruhBjQUKQd0Kg0G3aadjkg>
    <xmx:pA96YtBrm8v8KqQZd9uJNFqgrrxnD26WK1zJTVfFmpXuxU7C6G9p5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 May 2022 03:09:23 -0400 (EDT)
Date:   Tue, 10 May 2022 10:09:19 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] show rx_otherhost_dropped stat in ip link show
Message-ID: <YnoPn+hQt7hQYWkA@shredder>
References: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509191810.2157940-1-jeffreyjilinux@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 07:18:10PM +0000, Jeffrey Ji wrote:
> From: Jeffrey Ji <jeffreyji@google.com>
> 
> This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")
> 
> Tested: sent packet with wrong MAC address from 1
> network namespace to another, verified that counter showed "1" in
> `ip -s -s link sh` and `ip -s -s -j link sh`
> 
> Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
> ---
>  include/uapi/linux/if_link.h |  2 ++
>  ip/ipaddress.c               | 15 +++++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 22e21e57afc9..50477985bfea 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -243,6 +243,8 @@ struct rtnl_link_stats64 {
>  	__u64	rx_compressed;
>  	__u64	tx_compressed;
>  	__u64	rx_nohandler;
> +
> +	__u64	rx_otherhost_dropped;

I believe you need to rebase against current iproute2-next. The kernel
headers are already updated there. This tree:
https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

>  };
>  
>  /* Subset of link stats useful for in-HW collection. Meaning of the fields is as
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index a80996efdc28..9d6af56e2a72 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -692,6 +692,7 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>  		strlen("heartbt"),
>  		strlen("overrun"),
>  		strlen("compressed"),
> +		strlen("otherhost_dropped"),

There were a lot of changes in this area as part of the "ip stats"
work. See print_stats64() in current iproute2-next.

>  	};
>  	int ret;
>  
> @@ -713,6 +714,10 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>  		if (s->rx_compressed)
>  			print_u64(PRINT_JSON,
>  				   "compressed", NULL, s->rx_compressed);
> +		if (s->rx_otherhost_dropped)
> +			print_u64(PRINT_JSON,
> +				   "otherhost_dropped",
> +				   NULL, s->rx_otherhost_dropped);
>  
>  		/* RX error stats */
>  		if (show_stats > 1) {
> @@ -795,11 +800,15 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>  				     rta_getattr_u32(carrier_changes) : 0);
>  
>  		/* RX stats */
> -		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
> +		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%*s%s",
>  			cols[0] - 4, "bytes", cols[1], "packets",
>  			cols[2], "errors", cols[3], "dropped",
>  			cols[4], "missed", cols[5], "mcast",
> -			cols[6], s->rx_compressed ? "compressed" : "", _SL_);
> +			s->rx_compressed ? cols[6] : 0,
> +			s->rx_compressed ? "compressed " : "",
> +			s->rx_otherhost_dropped ? cols[7] : 0,
> +			s->rx_otherhost_dropped ? "otherhost_dropped" : "",
> +			_SL_);
>  
>  		fprintf(fp, "    ");
>  		print_num(fp, cols[0], s->rx_bytes);
> @@ -810,6 +819,8 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
>  		print_num(fp, cols[5], s->multicast);
>  		if (s->rx_compressed)
>  			print_num(fp, cols[6], s->rx_compressed);
> +		if (s->rx_otherhost_dropped)
> +			print_num(fp, cols[7], s->rx_otherhost_dropped);
>  
>  		/* RX error stats */
>  		if (show_stats > 1) {
> -- 
> 2.36.0.512.ge40c2bad7a-goog
> 
