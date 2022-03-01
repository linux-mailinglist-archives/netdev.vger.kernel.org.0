Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5605D4C908D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiCAQoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiCAQoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:44:13 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E18560ED
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:43:32 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E0E125C0165;
        Tue,  1 Mar 2022 11:43:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 01 Mar 2022 11:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wR4Ts9VFtWK53GlRv
        K0lW1rHuCuWvh76zlUaiQPITaU=; b=HgA4rA5T/+ZWzuE+hsH0vZRJIAjrez1mi
        Ohax8eS+N1pIDGw8p2JtWdBfyi7IO/+cPj3gmGU8wNZnXzAW84Br+DNtOFW+maSt
        +230jl51YFPZ+t8AuUwG/jRD8uhEzSvpvBIA3eu1Mwav1CpQV4thsR8MAYX/sp6j
        FPd5o6aEIeDAW/AqOSAp6zyhTGbdam5q1dqFPrMlu6JU78vLB+BU1u2oRrgXlmoo
        rzVTQsER0xJIpPrMiWAhVfDOkD7gkXou4A+AbPSyGOvs56h4avKB/uungvpCnikx
        wRJiobLCR3qObYjqLOQG08jb0j0WS9As7uxWcGh2zmJi2NVF47Mjw==
X-ME-Sender: <xms:Mk0eYgax3AYQKe78YvKNdINK5qTve-I9C1mhrUUDsCaJ5CNO3EYKtA>
    <xme:Mk0eYrbfgOC8gEw8es6Rbf1vI5ADGRo6AlYSV_ZMPzGUGUWzeW1x_xdX9lNrXpMdY
    Rj3jMblnyv1qIU>
X-ME-Received: <xmr:Mk0eYq8cBWcKP8t7Ja0mm3ou0O4PzsbDbqMdgygEPLDIXFgqhFm81R7kP9P86c80_i1JQJLdk5U9puwEVkGKs-pHpoI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtvddgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:M00eYqrcKe3vL9yLBUeUD2ngl8YuSdgJ3LofyRzz1sT6h6JPYVCJqA>
    <xmx:M00eYrp0D6yFbZLwDii_avMkItQyENleqikDILUweuja2-8YWb5wYg>
    <xmx:M00eYoRr0o0uJCpqjq_vNXOrXMFfHOpM8whW519B5NwswqwuMMMY6g>
    <xmx:M00eYnLDWZNfpayIywfKX0pRZpTaAiJYsjXcdy3xctrkYboS5cjPNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Mar 2022 11:43:30 -0500 (EST)
Date:   Tue, 1 Mar 2022 18:43:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Message-ID: <Yh5NL1SY7+3rLW5O@shredder>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 01:31:02PM +0100, Mattias Forsblad wrote:
> This patch implements the bridge flag local_receive. When this
> flag is cleared packets received on bridge ports will not be forwarded up.
> This makes is possible to only forward traffic between the port members
> of the bridge.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
> ---
>  include/linux/if_bridge.h      |  6 ++++++
>  include/net/switchdev.h        |  2 ++

Nik might ask you to split the offload part from the bridge
implementation. Please wait for his feedback as he might be AFK right
now

>  include/uapi/linux/if_bridge.h |  1 +
>  include/uapi/linux/if_link.h   |  1 +
>  net/bridge/br.c                | 18 ++++++++++++++++++
>  net/bridge/br_device.c         |  1 +
>  net/bridge/br_input.c          |  3 +++
>  net/bridge/br_ioctl.c          |  1 +
>  net/bridge/br_netlink.c        | 14 +++++++++++++-
>  net/bridge/br_private.h        |  2 ++
>  net/bridge/br_sysfs_br.c       | 23 +++++++++++++++++++++++

I believe the bridge doesn't implement sysfs for new attributes

>  net/bridge/br_vlan.c           |  8 ++++++++
>  12 files changed, 79 insertions(+), 1 deletion(-)

[...]

> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index e0c13fcc50ed..5864b61157d3 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  		break;
>  	}
>  
> +	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
> +		local_rcv = false;
> +

I don't think the description in the commit message is accurate:
"packets received on bridge ports will not be forwarded up". From the
code it seems that if packets hit a local FDB entry, then they will be
"forwarded up". Instead, it seems that packets will not be flooded
towards the bridge. In which case, why not maintain the same granularity
we have for the rest of the ports and split this into unicast /
multicast / broadcast?

BTW, while the patch honors local FDB entries, it overrides host MDB
entries which seems wrong / inconsistent.

>  	if (dst) {
>  		unsigned long now = jiffies;
