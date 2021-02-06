Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6437B311F44
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 19:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhBFSF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 13:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhBFSFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 13:05:25 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316EBC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 10:04:45 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id u25so15410619lfc.2
        for <netdev@vger.kernel.org>; Sat, 06 Feb 2021 10:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZjMO5Lk59yiTXI7f5EBiFCCiUROVU87CbI4UVN4ctC4=;
        b=j7wQGTI3MwVvmscsJwpWPN7HoNNe72a4DodlSziGv+U2XEGeFWJjSxe6wlvdBPv9Lm
         iv5+e53yU59j4ze7RK8c4bIGk5jjq6SNHUgsRjkEjoGO7HZz/DjVwozGNIBwXCPHL7Gp
         RPQRY7h3U1H/ta3PbFLbkHFl0K6qrZMZWGhTFZnGseGNApMyqe+9U0hlSYhtQYB+3yra
         HDZ7IiWQ8YmdWZ+gJvWIGdh6A6DLPb+IYBhchkmJ3uUeZS4M9EUxtXRZBIhiLcx4Ptz/
         WnAgOWlnIA5AVKVqAfIX1aGf5oMReoHLh3Fp3JMr68s0qDi8T/osBW4wmwd8crXGcZ1j
         Czcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjMO5Lk59yiTXI7f5EBiFCCiUROVU87CbI4UVN4ctC4=;
        b=ImMKMMc1h/DdfEdwh1+cpw2/eR0qj+vBs8xyPoZ71YMOja7OVWfgCzo+X4Yrjzg/Ks
         zQ8D6YheatCjuPHucDZxwhKrQuwrAf7zxFC8oEZ7UcyT79/QlHVRcKbLZopZoJ5UugjH
         gIjhqx8Y5qMt5As8ey1G91MaqWG0w6bOHZylntCmUHaPToC+OBx79lYa2fGVIzFrJ8UV
         5xx0blImMKgXKcZhnPFmp+ufMvJLdam0AI0X3Vj68b9EO3AXRR/5lNKNjeTQ4o6gUavh
         Irq5CkS7m3wNdpATAOVJHIb8gXJJTHicNrJd47ffkARVeK7k8CLtRa9Czb8IjgCI9Bto
         4clw==
X-Gm-Message-State: AOAM5301YpzyxywqgLgT98PMktMB4lzuTQ98dYrkOe1RYeH97NMX3wje
        +VIACQbAud98OFziugYNMS+wRAD2OBuW3w==
X-Google-Smtp-Source: ABdhPJy4gT29dWQN6T1grJmq8u52i5Jk8KpbsxI6vlji3cN77uJk8hG2EkXPA2ipRJpQBWrCzePF9Q==
X-Received: by 2002:ac2:53b1:: with SMTP id j17mr6270531lfh.477.1612634683100;
        Sat, 06 Feb 2021 10:04:43 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id o14sm1375329ljp.48.2021.02.06.10.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 10:04:42 -0800 (PST)
Subject: Re: [RFC PATCH 14/16] gtp: add support for flow based tunneling
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-15-jonas@norrbonn.se>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <5c94d0f6-4d35-6654-4fde-1eebbcc7d74f@norrbonn.se>
Date:   Sat, 6 Feb 2021 19:04:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210123195916.2765481-15-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin et al;

TL;DR:  we don't need to introduce an entire collect_md mode to the 
driver; we just need to tweak what we've got so that metadata is 
"always" added on RX and respected on TX; make the userspace socket 
optional and dump GTP packets to netstack if it's not present; and make 
a decision on whether to allow packets into netstack without validating 
their IP address.

On 23/01/2021 20:59, Jonas Bonn wrote:
> From: Pravin B Shelar <pbshelar@fb.com>
> 
> This patch adds support for flow based tunneling, allowing to send and
> receive GTP tunneled packets via the (lightweight) tunnel metadata
> mechanism.  This would allow integration with OVS and eBPF using flow
> based tunneling APIs.
> 
> The mechanism used here is to get the required GTP tunnel parameters
> from the tunnel metadata instead of looking up a pre-configured PDP
> context.  The tunnel metadata contains the necessary information for
> creating the GTP header.


So, I've been investigating this a bit further...

What is being introduced in this patch is a variant of "normal 
functionality" that resembles something called "collect metadata" mode 
in other drivers (GRE, VXLAN, etc).  These other drivers operate in one 
of two modes:  more-or-less-point-to-point mode, or this alternative 
collect metadata varaint.  The latter is something that has been bolted 
on to an existing implementation of the former.

For iproute2, a parameter called 'external' is added to the setup of 
links of the above type to switch between the two modes; the 
point-to-point parameters are invalid in 'external' (or 'collect 
metadata') mode.  The name 'external' is because the driver is 
externally controlled, meaning that the tunnel information is not 
hardcoded into the device instance itself.

The GTP driver, however, has never been a point-to-point device.  It is 
already 'externally controlled' in the sense that tunnels can be added 
and removed at any time.  Adding this 'external' mode doesn't 
immediately make sense because that's roughly what we already have.

Looking into how ip_tunnel_collect_metadata() works, it looks to me like 
it's always true if there's _ANY_ routing rule in the system with 
'tunnel ID' set.  Is that correct?  I'll assume it is in order to 
continue my thoughts.

So, with that, either the system is collecting SKB metadata or it isn't. 
  If it is, it seems reasonable that we populate incoming packets with 
the tunnel ID as in this patch.  That said, I'm not convinced that we 
should bypass the PDP context mechanism entirely... there should still 
be a PDP context set up or we drop the packet for security reasons.

For outgoing packets, it seems reasonable that the remote TEID may come 
from metadata OR a PDP context.  That would allow some routing 
alternatives to what we have right now which just does a PDP context 
lookup based on the destination/source address of the packet.  It would 
be nice for OVS/BPF to be able to direct a packet to a remote GTP 
endpoint by providing that endpoint/TEID via a metadata structure.

So we end up with, roughly:

On RX:
i) check TEID in GTP header
ii) lookup PDP context
iii) validate IP of encapsulated packet
iv) if ip(tunnel_collect_metadata()) { /* add tun info */ }
v) decapsulate and pass to network stack

On TX:
i) if SKB has metadata, get destination and TEID from metadata (tunnel ID)
ii) otherwise, lookup PDP context for packet

For RX, only iv) is new; for TX only step i) is new.  The rest is what 
we already have.

The one thing that this complicates is the case where an external entity 
(OVS or BPF) is doing validation of packet IP against incoming TEID.  In 
that case, we've got double validation of the incoming address and, I 
suppose, OVS/BPF would perhaps be more efficient (?)...  In that case, 
holding a PDP context is a bit of a waste of memory.

It's somewhat of a security issue to allow un-checked packets into the 
system, so I'm not super keen on dropping the validation of incoming 
packets; given the previous paragraph, however, we might add a flag when 
creating the link to decide whether or not we allow packets through even 
if we can't validate them.  This would also apply to packets without a 
PDP context for an incoming TEID, too.  This flag, I suppose, looks a 
bit like the 'collect_metadata' flag that Pravin has added here.

The other difference to what we currently have is that this patch sets 
up a socket exclusively in kernel space for the tunnel; currently, all 
sockets terminate in userspace:  userspace receives all packets that 
can't be decapsulated and re-injected in to the network stack.  With 
this patch, ALL packets (without a userspace termination) are 
re-injected into the network stack; it's just that anything that can't 
be decapsulated gets injected as a "GTP packet" with some metadata and 
an UNKNOWN protocol type.  If nothing is looking at the metadata and 
acting on it, then these will just get dropped; and that's what would 
happen if nothing was listening on the userspace end, too.  So we might 
as well just make the FD1 socket parameter to the link setup optional 
and be done with it.

So, thoughts?  What am I missing?

/Jonas

> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> ---
>   drivers/net/gtp.c                  | 160 +++++++++++++++++++++++++----
>   include/uapi/linux/gtp.h           |  12 +++
>   include/uapi/linux/if_tunnel.h     |   1 +
>   tools/include/uapi/linux/if_link.h |   1 +
>   4 files changed, 156 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 8aab46ec8a94..668ed8a4836e 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -21,6 +21,7 @@
>   #include <linux/file.h>
>   #include <linux/gtp.h>
>   
> +#include <net/dst_metadata.h>
>   #include <net/net_namespace.h>
>   #include <net/protocol.h>
>   #include <net/ip.h>
> @@ -74,6 +75,9 @@ struct gtp_dev {
>   	unsigned int		hash_size;
>   	struct hlist_head	*tid_hash;
>   	struct hlist_head	*addr_hash;
> +	/* Used by LWT tunnel. */
> +	bool			collect_md;
> +	struct socket		*collect_md_sock;
>   };
>   
>   static unsigned int gtp_net_id __read_mostly;
> @@ -224,6 +228,51 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
>   	return -1;
>   }
>   
> +static int gtp_set_tun_dst(struct pdp_ctx *pctx, struct sk_buff *skb,
> +			   unsigned int hdrlen)
> +{
> +	struct metadata_dst *tun_dst;
> +	struct gtp1_header *gtp1;
> +	int opts_len = 0;
> +	__be64 tid;
> +
> +	gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
> +
> +	tid = key32_to_tunnel_id(gtp1->tid);
> +
> +	if (unlikely(gtp1->flags & GTP1_F_MASK))
> +		opts_len = sizeof(struct gtpu_metadata);
> +
> +	tun_dst = udp_tun_rx_dst(skb,
> +			pctx->sk->sk_family, TUNNEL_KEY, tid, opts_len);
> +	if (!tun_dst) {
> +		netdev_dbg(pctx->dev, "Failed to allocate tun_dst");
> +		goto err;
> +	}
> +
> +	netdev_dbg(pctx->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
> +		   pctx->gtp_version, hdrlen);
> +	if (unlikely(opts_len)) {
> +		struct gtpu_metadata *opts;
> +
> +		opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
> +		opts->ver = GTP_METADATA_V1;
> +		opts->flags = gtp1->flags;
> +		opts->type = gtp1->type;
> +		netdev_dbg(pctx->dev, "recved control pkt: flag %x type: %d\n",
> +			   opts->flags, opts->type);
> +		tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
> +		tun_dst->u.tun_info.options_len = opts_len;
> +		skb->protocol = htons(0xffff);         /* Unknown */
> +	}
> +
> +	skb_dst_set(skb, &tun_dst->dst);
> +	return 0;
> +err:
> +	return -1;
> +}
> +
> +
>   /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
>   static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
>   {
> @@ -262,6 +311,7 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
>   	unsigned int hdrlen = sizeof(struct udphdr) +
>   			      sizeof(struct gtp1_header);
>   	struct gtp1_header *gtp1;
> +	struct pdp_ctx md_pctx;
>   	struct pdp_ctx *pctx;
>   
>   	if (!pskb_may_pull(skb, hdrlen))
> @@ -272,6 +322,24 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
>   	if ((gtp1->flags >> 5) != GTP_V1)
>   		return 1;
>   
> +	if (ip_tunnel_collect_metadata() || gtp->collect_md) {
> +		int err;
> +
> +		pctx = &md_pctx;
> +
> +		pctx->gtp_version = GTP_V1;
> +		pctx->sk = gtp->sk1u;
> +		pctx->dev = gtp->dev;
> +
> +		err = gtp_set_tun_dst(pctx, skb, hdrlen);
> +		if (err) {
> +			gtp->dev->stats.rx_dropped++;
> +			return -1;
> +		}
> +
> +		return gtp_rx(pctx, skb, hdrlen);
> +	}
> +
>   	if (gtp1->type != GTP_TPDU)
>   		return 1;
>   
> @@ -353,7 +421,8 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
>   	if (!gtp)
>   		return 1;
>   
> -	netdev_dbg(gtp->dev, "encap_recv sk=%p\n", sk);
> +	netdev_dbg(gtp->dev, "encap_recv sk=%p type %d\n",
> +		   sk, udp_sk(sk)->encap_type);
>   
>   	switch (udp_sk(sk)->encap_type) {
>   	case UDP_ENCAP_GTP0:
> @@ -539,7 +608,7 @@ static struct rtable *gtp_get_v4_rt(struct sk_buff *skb,
>   	memset(&fl4, 0, sizeof(fl4));
>   	fl4.flowi4_oif		= sk->sk_bound_dev_if;
>   	fl4.daddr		= pctx->peer_addr_ip4.s_addr;
> -	fl4.saddr		= inet_sk(sk)->inet_saddr;
> +	fl4.saddr		= *saddr;
>   	fl4.flowi4_tos		= RT_CONN_FLAGS(sk);
>   	fl4.flowi4_proto	= sk->sk_protocol;
>   
> @@ -617,29 +686,84 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
>   static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>   {
>   	struct gtp_dev *gtp = netdev_priv(dev);
> +	struct gtpu_metadata *opts = NULL;
> +	struct pdp_ctx md_pctx;
>   	struct pdp_ctx *pctx;
> +	__be16 port;
>   	struct rtable *rt;
> -	__be32 saddr;
>   	struct iphdr *iph;
> +	__be32 saddr;
>   	int headroom;
> -	__be16 port;
> +	__u8 tos;
>   	int r;
>   
> -	/* Read the IP destination address and resolve the PDP context.
> -	 * Prepend PDP header with TEI/TID from PDP ctx.
> -	 */
> -	iph = ip_hdr(skb);
> -	if (gtp->role == GTP_ROLE_SGSN)
> -		pctx = ipv4_pdp_find(gtp, iph->saddr);
> -	else
> -		pctx = ipv4_pdp_find(gtp, iph->daddr);
> +	if (gtp->collect_md) {
> +		/* LWT GTP1U encap */
> +		struct ip_tunnel_info *info = NULL;
>   
> -	if (!pctx) {
> -		netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
> -			   &iph->daddr);
> -		return -ENOENT;
> +		info = skb_tunnel_info(skb);
> +		if (!info) {
> +			netdev_dbg(dev, "missing tunnel info");
> +			return -ENOENT;
> +		}
> +		if (info->key.tp_dst && ntohs(info->key.tp_dst) != GTP1U_PORT) {
> +			netdev_dbg(dev, "unexpected GTP dst port: %d", ntohs(info->key.tp_dst));
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (!gtp->sk1u) {
> +			netdev_dbg(dev, "missing tunnel sock");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		pctx = &md_pctx;
> +		memset(pctx, 0, sizeof(*pctx));
> +		pctx->sk = gtp->sk1u;
> +		pctx->gtp_version = GTP_V1;
> +		pctx->u.v1.o_tei = ntohl(tunnel_id_to_key32(info->key.tun_id));
> +		pctx->peer_addr_ip4.s_addr = info->key.u.ipv4.dst;
> +
> +		saddr = info->key.u.ipv4.src;
> +		tos = info->key.tos;
> +
> +		if (info->options_len != 0) {
> +			if (info->key.tun_flags & TUNNEL_GTPU_OPT) {
> +				opts = ip_tunnel_info_opts(info);
> +			} else {
> +				netdev_dbg(dev, "missing tunnel metadata for control pkt");
> +				return -EOPNOTSUPP;
> +			}
> +		}
> +		netdev_dbg(dev, "flow-based GTP1U encap: tunnel id %d\n",
> +			   pctx->u.v1.o_tei);
> +	} else {
> +		struct iphdr *iph;
> +
> +		if (ntohs(skb->protocol) != ETH_P_IP)
> +			return -EOPNOTSUPP;
> +
> +		iph = ip_hdr(skb);
> +
> +		/* Read the IP destination address and resolve the PDP context.
> +		 * Prepend PDP header with TEI/TID from PDP ctx.
> +		 */
> +		if (gtp->role == GTP_ROLE_SGSN)
> +			pctx = ipv4_pdp_find(gtp, iph->saddr);
> +		else
> +			pctx = ipv4_pdp_find(gtp, iph->daddr);
> +
> +		if (!pctx) {
> +			netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
> +				   &iph->daddr);
> +			return -ENOENT;
> +		}
> +		netdev_dbg(dev, "found PDP context %p\n", pctx);
> +
> +		saddr = inet_sk(pctx->sk)->inet_saddr;
> +		tos = iph->tos;
> +		netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
> +			   &iph->saddr, &iph->daddr);
>   	}
> -	netdev_dbg(dev, "found PDP context %p\n", pctx);
>   
>   	rt = gtp_get_v4_rt(skb, dev, pctx, &saddr);
>   	if (IS_ERR(rt)) {
> @@ -691,7 +815,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>   
>   	udp_tunnel_xmit_skb(rt, pctx->sk, skb,
>   			    saddr, pctx->peer_addr_ip4.s_addr,
> -			    iph->tos,
> +			    tos,
>   			    ip4_dst_hoplimit(&rt->dst),
>   			    0,
>   			    port, port,
> diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
> index 79f9191bbb24..62aff78b7c56 100644
> --- a/include/uapi/linux/gtp.h
> +++ b/include/uapi/linux/gtp.h
> @@ -2,6 +2,8 @@
>   #ifndef _UAPI_LINUX_GTP_H_
>   #define _UAPI_LINUX_GTP_H_
>   
> +#include <linux/types.h>
> +
>   #define GTP_GENL_MCGRP_NAME	"gtp"
>   
>   enum gtp_genl_cmds {
> @@ -34,4 +36,14 @@ enum gtp_attrs {
>   };
>   #define GTPA_MAX (__GTPA_MAX + 1)
>   
> +enum {
> +	GTP_METADATA_V1
> +};
> +
> +struct gtpu_metadata {
> +	__u8    ver;
> +	__u8    flags;
> +	__u8    type;
> +};
> +
>   #endif /* _UAPI_LINUX_GTP_H_ */
> diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
> index 7d9105533c7b..802da679fab1 100644
> --- a/include/uapi/linux/if_tunnel.h
> +++ b/include/uapi/linux/if_tunnel.h
> @@ -176,6 +176,7 @@ enum {
>   #define TUNNEL_VXLAN_OPT	__cpu_to_be16(0x1000)
>   #define TUNNEL_NOCACHE		__cpu_to_be16(0x2000)
>   #define TUNNEL_ERSPAN_OPT	__cpu_to_be16(0x4000)
> +#define TUNNEL_GTPU_OPT		__cpu_to_be16(0x8000)
>   
>   #define TUNNEL_OPTIONS_PRESENT \
>   		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index d208b2af697f..28d649bda686 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -617,6 +617,7 @@ enum {
>   	IFLA_GTP_FD1,
>   	IFLA_GTP_PDP_HASHSIZE,
>   	IFLA_GTP_ROLE,
> +	IFLA_GTP_COLLECT_METADATA,
>   	__IFLA_GTP_MAX,
>   };
>   #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
> 
