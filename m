Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F618C1B3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfHMTx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:53:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57863 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfHMTx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:53:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1EF1721FB5;
        Tue, 13 Aug 2019 15:53:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 13 Aug 2019 15:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AjyaD9
        EaWr7+k2rMNmtVc8SYcylCMiShMYzcNxDKPPk=; b=CQHzng+CS9hN2WujJxOdzX
        Db3THBL3nIUBJJ5ddDfw1KqdH8Nyw5+Ig2W8f8wHMMyT5QZW8CsI/ouoP8PED0RF
        xs6vflNuu9enm56PpsotaOKuQf4B/LwoJCi8R3MFe9ms3gE9vTci/rX0R6FQaT8n
        iZBy5JRsSoPycvHKSPHRCOvJWRodt7aNa6S9WJyR7jMWCG3ZKNcWEOF3PKMSIM6X
        m93gIlEq0Os+ZMzaGvUpd1xEeV27c6utOUvM1f7RlWCOhIAZH7A8RYLVSG8V8gB7
        gSmcO40Ktksbhsz6r75X/ZzY0Xy8ua67j0txTXEkYisVxwJW0zIBS8HHA5kj7IIg
        ==
X-ME-Sender: <xms:VRVTXQGzBCBcZO_leUqjpMMZTAUAc2rxX6JEeN4krQ6VIkrJ2ETNEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepje
    ejrddufeekrddvgeelrddvtdelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgt
    hhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:VRVTXT3FemhQJlQq2IGPjkDUrT6LTCC-PWYt7jeavAUCSFp0zMfwwA>
    <xmx:VRVTXXFm3MkMdYOhIL3u21tJw5SzRTiHTFcOZzBNFqw5mAVHapvgTA>
    <xmx:VRVTXUzreYAlqdfZtv1Zsq7qovRNH-FyGg9Rjp0P69wbJOrx55gF3g>
    <xmx:VhVTXXU0e_MhLCd5NTNbIUzC2Yssz8z8CRowkvD-HwIKxP2aCHcRVg>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2AB0380087;
        Tue, 13 Aug 2019 15:53:56 -0400 (EDT)
Date:   Tue, 13 Aug 2019 22:53:41 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Patrick Ruddy <pruddy@vyatta.att-mail.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linus.luessing@c0d3.blue
Subject: Re: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by
 bridge
Message-ID: <20190813195341.GA27005@splinter>
References: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Bridge maintainers, Linus

On Tue, Aug 13, 2019 at 03:18:04PM +0100, Patrick Ruddy wrote:
> At present only all-nodes IPv6 multicast packets are accepted by
> a bridge interface that is not in multicast router mode. Since
> other protocols can be running in the absense of multicast
> forwarding e.g. OSPFv3 IPv6 ND. Change the test to allow
> all of the FFx2::/16 range to be accepted when not in multicast
> router mode. This aligns the code with IPv4 link-local reception
> and RFC4291

Can you please quote the relevant part from RFC 4291?

> 
> Signed-off-by: Patrick Ruddy <pruddy@vyatta.att-mail.com>
> ---
>  include/net/addrconf.h    | 15 +++++++++++++++
>  net/bridge/br_multicast.c |  2 +-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index becdad576859..05b42867e969 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -434,6 +434,21 @@ static inline void addrconf_addr_solict_mult(const struct in6_addr *addr,
>  		      htonl(0xFF000000) | addr->s6_addr32[3]);
>  }
>  
> +/*
> + *      link local multicast address range ffx2::/16 rfc4291
> + */
> +static inline bool ipv6_addr_is_ll_mcast(const struct in6_addr *addr)
> +{
> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
> +	__be64 *p = (__be64 *)addr;
> +	return ((p[0] & cpu_to_be64(0xff0f000000000000UL))
> +		^ cpu_to_be64(0xff02000000000000UL)) == 0UL;
> +#else
> +	return ((addr->s6_addr32[0] & htonl(0xff0f0000)) ^
> +		htonl(0xff020000)) == 0;
> +#endif
> +}
> +
>  static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
>  {
>  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 9b379e110129..ed3957381fa2 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1664,7 +1664,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
>  	err = ipv6_mc_check_mld(skb);
>  
>  	if (err == -ENOMSG) {
> -		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
> +		if (!ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
>  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;

IIUC, you want IPv6 link-local packets to be locally received, but this
also changes how these packets are flooded. RFC 4541 says that packets
addressed to the all hosts address are a special case and should be
forwarded to all ports:

"In IPv6, the data forwarding rules are more straight forward because MLD is
mandated for addresses with scope 2 (link-scope) or greater. The only exception
is the address FF02::1 which is the all hosts link-scope address for which MLD
messages are never sent. Packets with the all hosts link-scope address should
be forwarded on all ports."

Maybe you want something like:

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 09b1dd8cd853..9f312a73f61c 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -132,7 +132,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
 		    br_multicast_querier_exists(br, eth_hdr(skb))) {
 			if ((mdst && mdst->host_joined) ||
-			    br_multicast_is_router(br)) {
+			    br_multicast_is_router(br) ||
+			    BR_INPUT_SKB_CB_LOCAL_RECEIVE(skb)) {
 				local_rcv = true;
 				br->dev->stats.multicast++;
 			}
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9b379e110129..f03cecf6174e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1667,6 +1667,9 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 
+		if (ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
+			BR_INPUT_SKB_CB(skb)->local_receive = 1;
+
 		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
 			err = br_ip6_multicast_mrd_rcv(br, port, skb);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b7a4942ff1b3..d76394ca4059 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -426,6 +426,7 @@ struct br_input_skb_cb {
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	u8 igmp;
 	u8 mrouters_only:1;
+	u8 local_receive:1;
 #endif
 	u8 proxyarp_replied:1;
 	u8 src_port_isolated:1;
@@ -445,8 +446,10 @@ struct br_input_skb_cb {
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(BR_INPUT_SKB_CB(__skb)->mrouters_only)
+# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(BR_INPUT_SKB_CB(__skb)->local_receive)
 #else
 # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
+# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(0)
 #endif
 
 #define br_printk(level, br, format, args...)	\
