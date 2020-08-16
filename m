Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEE92459C7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgHPWIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgHPWIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 18:08:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DA8C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:08:22 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so6745025pjb.2
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 15:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6QzyDCZzkdERan1AyisujE+HO7VANLFXVJg17cQ6K2I=;
        b=1spAZ5uDZhhcYi5CiceD+7xMlmOpiuPTjokesFJ3YpIOwcZGqWRbgOi/56MbBwWgry
         o4pE6VNirxUBLG+Wuf9I+v60lf1/e+UCdhQL4vk53x4Pz+fr4C9T6/7O6TxSzuZ5vzEl
         CDzqBG2aJtv+arVZN9Wm6kz44Z0tLypU/vTpVTUR73PjFAp6PQu91SlxHBX4ByBbrGvc
         JgYDktxg15pgGy9Q0cK97QUqfUFdkpqn0yNqQyQwOo8JmcTANJ2gvoESQQdX8gCTut7N
         gTJ903Gu6lp+mLKLlMG5QNrt+uCHymjTBW69u2gre7pImCH6OyYuQ/+j9mpzkKurBV6R
         uS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6QzyDCZzkdERan1AyisujE+HO7VANLFXVJg17cQ6K2I=;
        b=fbwPhxLJ5w0Z69UHzAcwURV0VDBMriOufaRLmjuLx22q+ZgLvC58urrgo/90wSHeu3
         knjf9Lqflp+gyP+r3v9fj7BZUkjlAZiPhJWrFaIYzHbwD5zop2WFljBPQ3zMWLCNdbHy
         dX6cC6/DJ+aAPongKxfGeJGDDc5zb6AWXfbl7Uw9vwjF4M/q6297i3nH1EZWSB2IY7VU
         q6OHhyzE5yrKjfqbB0wFI5NqNFLp15kc/mR3mG8cAkgYJgLjdNL6qLUY9wASlejwXRTb
         Mv8xsuGmnEi6pF/cSq2ir3+ZmXdurIAQq9h/JEaChwYTZiAYITVUgNp3ngNXpqftgGFY
         83cQ==
X-Gm-Message-State: AOAM531yUZdT6JdEyn2BaY6DKRAaaHDCwvv/5W4USbXPIb9TsOdvP9va
        pkMobbR/sCOrUi8eCsfhuSVnMA==
X-Google-Smtp-Source: ABdhPJwcZMbADPSsDvznLqaow0E1oxSYWGxF4xSTywU7LD+ZtLm/dDKrPhffR4Bf2kU6zahhhjIQcQ==
X-Received: by 2002:a17:902:7d94:: with SMTP id a20mr8975809plm.174.1597615701383;
        Sun, 16 Aug 2020 15:08:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y10sm14750320pjv.55.2020.08.16.15.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2020 15:08:21 -0700 (PDT)
Date:   Sun, 16 Aug 2020 15:08:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Linus =?UTF-8?B?TMO8c3Npbmc=?= <linus.luessing@c0d3.blue>
Cc:     netdev@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, gluon@luebeck.freifunk.net,
        openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [Bridge] [RFC PATCH net-next] bridge: Implement MLD Querier
 wake-up calls / Android bug workaround
Message-ID: <20200816150813.0b998607@hermes.lan>
In-Reply-To: <20200816202424.3526-1-linus.luessing@c0d3.blue>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Aug 2020 22:24:24 +0200
Linus L=C3=BCssing <linus.luessing@c0d3.blue> wrote:

> Implement a configurable MLD Querier wake-up calls "feature" which
> works around a widely spread Android bug in connection with IGMP/MLD
> snooping.
>=20
> Currently there are mobile devices (e.g. Android) which are not able
> to receive and respond to MLD Queries reliably because the Wifi driver
> filters a lot of ICMPv6 when the device is asleep - including
> MLD. This in turn breaks IPv6 communication when MLD Snooping is
> enabled. However there is one ICMPv6 type which is allowed to pass and
> which can be used to wake up the mobile device: ICMPv6 Echo Requests.
>=20
> If this bridge is the selected MLD Querier then setting
> "multicast_wakeupcall" to a number n greater than 0 will send n
> ICMPv6 Echo Requests to each host behind this port to wake
> them up with each MLD Query. Upon receiving a matching ICMPv6 Echo
> Reply an MLD Query with a unicast ethernet destination will be sent
> to the specific host(s).
>=20
> Link: https://issuetracker.google.com/issues/149630944
> Link: https://github.com/freifunk-gluon/gluon/issues/1832
>=20
> Signed-off-by: Linus L=C3=BCssing <linus.luessing@c0d3.blue>
> ---
> A version of this patch rebased to Linux 4.14 is currently applied on a
> 400 nodes mesh network (Freifunk Vogtland).
>=20
> I'm aware that this is quite a hack, so I'm unsure if this is suitable
> for upstream. On the other hand, the Android ticket isn't moving
> anywhere and even if it were fixed in Android, I'd expect it to take
> years until that fix would propagate or unpatched Android devices to
> vanish. So I'm wondering if it should be treated like a hardware bug
> workaround and by that should be suitable for applying it upstream in
> the Linux kernel?
>=20
> I've also raised this issue on the mcast-wifi@ietf.org and pim@ietf.org
> mailing list earlier this year but the amount of feedback was a bit
> sparse.
>=20
> CC'ing the OpenWrt mailing list, too, as I expect there to be most users
> affected by this issue, if they enabled IGMP/MLD snooping.
>=20
> Let me know what you think about this.
>=20
>  include/linux/if_bridge.h    |   1 +
>  include/uapi/linux/if_link.h |   1 +
>  net/bridge/Kconfig           |  26 ++++
>  net/bridge/br_fdb.c          |  10 ++
>  net/bridge/br_input.c        |   4 +-
>  net/bridge/br_multicast.c    | 284 ++++++++++++++++++++++++++++++++++-
>  net/bridge/br_netlink.c      |  19 +++
>  net/bridge/br_private.h      |  19 +++
>  net/bridge/br_sysfs_if.c     |  18 +++
>  9 files changed, 374 insertions(+), 8 deletions(-)
>=20
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 6479a38e52fa..73bc692e1ae6 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -50,6 +50,7 @@ struct br_ip_list {
>  #define BR_MRP_AWARE		BIT(17)
>  #define BR_MRP_LOST_CONT	BIT(18)
>  #define BR_MRP_LOST_IN_CONT	BIT(19)
> +#define BR_MULTICAST_WAKEUPCALL	BIT(20)
> =20
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
> =20
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 7fba4de511de..5015f8ce1ad7 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -355,6 +355,7 @@ enum {
>  	IFLA_BRPORT_BACKUP_PORT,
>  	IFLA_BRPORT_MRP_RING_OPEN,
>  	IFLA_BRPORT_MRP_IN_OPEN,
> +	IFLA_BRPORT_MCAST_WAKEUPCALL,
>  	__IFLA_BRPORT_MAX
>  };
>  #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
> diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
> index 80879196560c..056e80bf00c4 100644
> --- a/net/bridge/Kconfig
> +++ b/net/bridge/Kconfig
> @@ -48,6 +48,32 @@ config BRIDGE_IGMP_SNOOPING
> =20
>  	  If unsure, say Y.
> =20
> +config BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +	bool "MLD Querier wake-up calls"
> +	depends on BRIDGE_IGMP_SNOOPING
> +	depends on IPV6
> +	help
> +	  If you say Y here, then the MLD Snooping Querier will be built
> +	  with a per bridge port wake-up call "feature"/workaround.
> +
> +	  Currently there are mobile devices (e.g. Android) which are not able
> +	  to receive and respond to MLD Queries reliably because the Wifi driver
> +	  filters a lot of ICMPv6 when the device is asleep - including MLD.
> +	  This in turn breaks IPv6 communication when MLD Snooping is enabled.
> +	  However there is one ICMPv6 type which is allowed to pass and
> +	  which can be used to wake up the mobile device: ICMPv6 Echo Requests.
> +
> +	  If this bridge is the selected MLD Querier then setting
> +	  "multicast_wakeupcall" to a number n greater than 0 will send n
> +	  ICMPv6 Echo Requests to each host behind this port to wake them up
> +	  with each MLD Query. Upon receiving a matching ICMPv6 Echo Reply
> +	  an MLD Query with a unicast ethernet destination will be sent to the
> +	  specific host(s).
> +
> +	  Say N to exclude this support and reduce the binary size.
> +
> +	  If unsure, say N.
> +
>  config BRIDGE_VLAN_FILTERING
>  	bool "VLAN filtering"
>  	depends on BRIDGE
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 9db504baa094..f63f85c5007c 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -84,6 +84,10 @@ static void fdb_rcu_free(struct rcu_head *head)
>  {
>  	struct net_bridge_fdb_entry *ent
>  		=3D container_of(head, struct net_bridge_fdb_entry, rcu);
> +
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +	del_timer_sync(&ent->wakeupcall_timer);
> +#endif
>  	kmem_cache_free(br_fdb_cache, ent);
>  }
> =20
> @@ -511,6 +515,12 @@ static struct net_bridge_fdb_entry *fdb_create(struc=
t net_bridge *br,
>  		fdb->key.vlan_id =3D vid;
>  		fdb->flags =3D flags;
>  		fdb->updated =3D fdb->used =3D jiffies;
> +
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +		timer_setup(&fdb->wakeupcall_timer,
> +			    br_multicast_send_wakeupcall, 0);
> +#endif
> +
>  		if (rhashtable_lookup_insert_fast(&br->fdb_hash_tbl,
>  						  &fdb->rhnode,
>  						  br_fdb_rht_params)) {
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 59a318b9f646..a1e40b25eb8a 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -155,8 +155,10 @@ int br_handle_frame_finish(struct net *net, struct s=
ock *sk, struct sk_buff *skb
>  	if (dst) {
>  		unsigned long now =3D jiffies;
> =20
> -		if (test_bit(BR_FDB_LOCAL, &dst->flags))
> +		if (test_bit(BR_FDB_LOCAL, &dst->flags)) {
> +			br_multicast_wakeupcall_rcv(br, p, skb, vid);
>  			return br_pass_frame_up(skb);
> +		}
> =20
>  		if (now !=3D dst->used)
>  			dst->used =3D now;
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 4c4a93abde68..4b25ad6113bf 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -309,10 +309,11 @@ static struct sk_buff *br_ip4_multicast_alloc_query=
(struct net_bridge *br,
>  #if IS_ENABLED(CONFIG_IPV6)
>  static struct sk_buff *br_ip6_multicast_alloc_query(struct net_bridge *b=
r,
>  						    const struct in6_addr *grp,
> -						    u8 *igmp_type)
> +						    u8 *igmp_type,
> +						    bool delay)
>  {
> +	unsigned long interval =3D 0;
>  	struct mld2_query *mld2q;
> -	unsigned long interval;
>  	struct ipv6hdr *ip6h;
>  	struct mld_msg *mldq;
>  	size_t mld_hdr_size;
> @@ -371,9 +372,13 @@ static struct sk_buff *br_ip6_multicast_alloc_query(=
struct net_bridge *br,
> =20
>  	/* ICMPv6 */
>  	skb_set_transport_header(skb, skb->len);
> -	interval =3D ipv6_addr_any(grp) ?
> -			br->multicast_query_response_interval :
> -			br->multicast_last_member_interval;
> +	if (delay) {
> +		interval =3D ipv6_addr_any(grp) ?
> +				br->multicast_query_response_interval :
> +				br->multicast_last_member_interval;
> +		interval =3D jiffies_to_msecs(interval);
> +	}
> +
>  	*igmp_type =3D ICMPV6_MGM_QUERY;
>  	switch (br->multicast_mld_version) {
>  	case 1:
> @@ -381,7 +386,7 @@ static struct sk_buff *br_ip6_multicast_alloc_query(s=
truct net_bridge *br,
>  		mldq->mld_type =3D ICMPV6_MGM_QUERY;
>  		mldq->mld_code =3D 0;
>  		mldq->mld_cksum =3D 0;
> -		mldq->mld_maxdelay =3D htons((u16)jiffies_to_msecs(interval));
> +		mldq->mld_maxdelay =3D htons((u16)interval);
>  		mldq->mld_reserved =3D 0;
>  		mldq->mld_mca =3D *grp;
>  		mldq->mld_cksum =3D csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
> @@ -430,7 +435,7 @@ static struct sk_buff *br_multicast_alloc_query(struc=
t net_bridge *br,
>  #if IS_ENABLED(CONFIG_IPV6)
>  	case htons(ETH_P_IPV6):
>  		return br_ip6_multicast_alloc_query(br, &addr->u.ip6,
> -						    igmp_type);
> +						    igmp_type, true);
>  #endif
>  	}
>  	return NULL;
> @@ -709,6 +714,168 @@ static void br_multicast_select_own_querier(struct =
net_bridge *br,
>  #endif
>  }
> =20
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +
> +#define BR_MC_WAKEUP_ID htons(0xEC6B) /* random identifier */
> +#define BR_MC_ETH_ZERO { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
> +#define BR_MC_IN6_ZERO \
> +{ \
> +	.s6_addr32[0] =3D 0, .s6_addr32[1] =3D 0, \
> +	.s6_addr32[2] =3D 0, .s6_addr32[3] =3D 0, \
> +}
> +
> +#define BR_MC_IN6_FE80 \
> +{ \
> +	.s6_addr32[0] =3D htonl(0xfe800000), \
> +	.s6_addr32[1] =3D 0, \
> +	.s6_addr32[2] =3D htonl(0x000000ff), \
> +	.s6_addr32[3] =3D htonl(0xfe000000), \
> +}
> +
> +#define BR_MC_ECHO_LEN sizeof(pkt->echohdr)
> +
> +static struct sk_buff *br_multicast_alloc_wakeupcall(struct net_bridge *=
br,
> +						     struct net_bridge_port *port,
> +						     u8 *eth_dst)
> +{
> +	struct in6_addr ip6_src, ip6_dst =3D BR_MC_IN6_FE80;
> +	struct sk_buff *skb;
> +	__wsum csum_part;
> +	__sum16 csum;
> +
> +	struct wakeupcall_pkt {
> +		struct ethhdr ethhdr;
> +		struct ipv6hdr ip6hdr;
> +		struct icmp6hdr echohdr;
> +	} __packed;
> +
> +	struct wakeupcall_pkt *pkt;
> +
> +	static const struct wakeupcall_pkt __pkt_template =3D {
> +		.ethhdr =3D {
> +			.h_dest =3D BR_MC_ETH_ZERO, // update
> +			.h_source =3D BR_MC_ETH_ZERO, // update
> +			.h_proto =3D htons(ETH_P_IPV6),
> +		},
> +		.ip6hdr =3D {
> +			.priority =3D 0,
> +			.version =3D 0x6,
> +			.flow_lbl =3D { 0x00, 0x00, 0x00 },
> +			.payload_len =3D htons(BR_MC_ECHO_LEN),
> +			.nexthdr =3D IPPROTO_ICMPV6,
> +			.hop_limit =3D 1,
> +			.saddr =3D BR_MC_IN6_ZERO, // update
> +			.daddr =3D BR_MC_IN6_ZERO, // update
> +		},
> +		.echohdr =3D {
> +			.icmp6_type =3D ICMPV6_ECHO_REQUEST,
> +			.icmp6_code =3D 0,
> +			.icmp6_cksum =3D 0, // update
> +			.icmp6_dataun.u_echo =3D {
> +				.identifier =3D BR_MC_WAKEUP_ID,
> +				.sequence =3D 0,
> +			},
> +		},
> +	};
> +
> +	memcpy(&ip6_dst.s6_addr32[2], &eth_dst[0], ETH_ALEN / 2);
> +	memcpy(&ip6_dst.s6_addr[13], &eth_dst[3], ETH_ALEN / 2);
> +	ip6_dst.s6_addr[8] ^=3D 0x02;
> +	if (ipv6_dev_get_saddr(dev_net(br->dev), br->dev, &ip6_dst, 0,
> +			       &ip6_src))
> +		return NULL;
> +
> +	skb =3D netdev_alloc_skb_ip_align(br->dev, sizeof(*pkt));
> +	if (!skb)
> +		return NULL;
> +
> +	skb->protocol =3D htons(ETH_P_IPV6);
> +	skb->dev =3D port->dev;
> +
> +	pkt =3D (struct wakeupcall_pkt *)skb->data;
> +	*pkt =3D __pkt_template;
> +
> +	ether_addr_copy(pkt->ethhdr.h_source, br->dev->dev_addr);
> +	ether_addr_copy(pkt->ethhdr.h_dest, eth_dst);
> +
> +	pkt->ip6hdr.saddr =3D ip6_src;
> +	pkt->ip6hdr.daddr =3D ip6_dst;
> +
> +	csum_part =3D csum_partial(&pkt->echohdr, sizeof(pkt->echohdr), 0);
> +	csum =3D csum_ipv6_magic(&ip6_src, &ip6_dst, sizeof(pkt->echohdr),
> +			       IPPROTO_ICMPV6, csum_part);
> +	pkt->echohdr.icmp6_cksum =3D csum;
> +
> +	skb_reset_mac_header(skb);
> +	skb_set_network_header(skb, offsetof(struct wakeupcall_pkt, ip6hdr));
> +	skb_set_transport_header(skb, offsetof(struct wakeupcall_pkt, echohdr));
> +	skb_put(skb, sizeof(*pkt));
> +	__skb_pull(skb, sizeof(pkt->ethhdr));
> +
> +	return skb;
> +}
> +
> +void br_multicast_send_wakeupcall(struct timer_list *t)
> +{
> +	struct net_bridge_fdb_entry *fdb =3D from_timer(fdb, t, wakeupcall_time=
r);
> +	struct net_bridge_port *port =3D fdb->dst;
> +	struct net_bridge *br =3D port->br;
> +	struct sk_buff *skb, *skb0;
> +	int i;
> +
> +	skb0 =3D br_multicast_alloc_wakeupcall(br, port, fdb->key.addr.addr);
> +	if (!skb0)
> +		return;
> +
> +	for (i =3D port->wakeupcall_num_rings; i > 0; i--) {
> +		if (i > 1) {
> +			skb =3D skb_clone(skb0, GFP_ATOMIC);
> +			if (!skb) {
> +				kfree_skb(skb0);
> +				break;
> +			}
> +		} else {
> +			skb =3D skb0;
> +		}
> +
> +		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
> +			dev_net(port->dev), NULL, skb, NULL, skb->dev,
> +			br_dev_queue_push_xmit);
> +	}
> +}
> +
> +static void br_multicast_schedule_wakeupcalls(struct net_bridge *br,
> +					      struct net_bridge_port *port,
> +					      const struct in6_addr *group)
> +{
> +	struct net_bridge_fdb_entry *fdb;
> +	unsigned long delay;
> +
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
> +		if (!fdb->dst || fdb->dst->dev !=3D port->dev)
> +			continue;
> +
> +		/* Wake-up calls to VLANs unsupported for now */
> +		if (fdb->key.vlan_id)
> +			continue;
> +
> +		/* Spread the ICMPv6 Echo Requests to avoid congestion.
> +		 * We then won't use a max response delay for the queries later,
> +		 * as that would be redundant. Spread randomly by a little less
> +		 * than max response delay to anticipate the extra round trip.
> +		 */
> +		delay =3D	ipv6_addr_any(group) ?
> +				br->multicast_query_response_interval :
> +				br->multicast_last_member_interval;
> +		delay =3D prandom_u32() % (3 * delay / 4);
> +
> +		timer_reduce(&fdb->wakeupcall_timer, jiffies + delay);
> +	}
> +	rcu_read_unlock();
> +}
> +#endif /* CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS */
> +
>  static void __br_multicast_send_query(struct net_bridge *br,
>  				      struct net_bridge_port *port,
>  				      struct br_ip *ip)
> @@ -727,6 +894,13 @@ static void __br_multicast_send_query(struct net_bri=
dge *br,
>  		NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
>  			dev_net(port->dev), NULL, skb, NULL, skb->dev,
>  			br_dev_queue_push_xmit);
> +
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +		if (port->wakeupcall_num_rings &&
> +		    ip->proto =3D=3D htons(ETH_P_IPV6))
> +			br_multicast_schedule_wakeupcalls(br, port,
> +							  &ip->u.ip6);
> +#endif
>  	} else {
>  		br_multicast_select_own_querier(br, ip, skb);
>  		br_multicast_count(br, port, skb, igmp_type,
> @@ -1752,6 +1926,93 @@ int br_multicast_rcv(struct net_bridge *br, struct=
 net_bridge_port *port,
>  	return ret;
>  }
> =20
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +
> +static bool br_multicast_wakeupcall_check(struct net_bridge *br,
> +					  struct net_bridge_port *port,
> +					  struct sk_buff *skb, u16 vid)
> +{
> +	struct ethhdr *eth =3D eth_hdr(skb);
> +	const struct ipv6hdr *ip6h;
> +	unsigned int offset, len;
> +	struct icmp6hdr *icmp6h;
> +
> +	/* Wake-up calls to VLANs unsupported for now */
> +	if (!port->wakeupcall_num_rings || vid ||
> +	    eth->h_proto !=3D htons(ETH_P_IPV6))
> +		return false;
> +
> +	if (!ether_addr_equal(eth->h_dest, br->dev->dev_addr) ||
> +	    is_multicast_ether_addr(eth->h_source) ||
> +	    is_zero_ether_addr(eth->h_source))
> +		return false;
> +
> +	offset =3D skb_network_offset(skb) + sizeof(*ip6h);
> +	if (!pskb_may_pull(skb, offset))
> +		return false;
> +
> +	ip6h =3D ipv6_hdr(skb);
> +
> +	if (ip6h->version !=3D 6)
> +		return false;
> +
> +	len =3D offset + ntohs(ip6h->payload_len);
> +	if (skb->len < len || len <=3D offset)
> +		return false;
> +
> +	if (ip6h->nexthdr !=3D IPPROTO_ICMPV6)
> +		return false;
> +
> +	skb_set_transport_header(skb, offset);
> +
> +	if (ipv6_mc_check_icmpv6 < 0)
> +		return false;
> +
> +	icmp6h =3D (struct icmp6hdr *)skb_transport_header(skb);
> +	if (icmp6h->icmp6_type !=3D ICMPV6_ECHO_REPLY ||
> +	    icmp6h->icmp6_dataun.u_echo.identifier !=3D BR_MC_WAKEUP_ID)
> +		return false;
> +
> +	return true;
> +}
> +
> +static void br_multicast_wakeupcall_send_mldq(struct net_bridge *br,
> +					      struct net_bridge_port *port,
> +					      const u8 *eth_dst)
> +{
> +	const struct in6_addr grp =3D BR_MC_IN6_ZERO;
> +	struct sk_buff *skb;
> +	u8 igmp_type;
> +
> +	/* we might have been triggered by multicast-address-specific query
> +	 * but reply with a general MLD query for now to keep things simple
> +	 */
> +	skb =3D br_ip6_multicast_alloc_query(br, &grp, &igmp_type, false);
> +	if (!skb)
> +		return;
> +
> +	skb->dev =3D port->dev;
> +	ether_addr_copy(eth_hdr(skb)->h_dest, eth_dst);
> +
> +	br_multicast_count(br, port, skb, igmp_type,
> +			   BR_MCAST_DIR_TX);
> +	NF_HOOK(NFPROTO_BRIDGE, NF_BR_LOCAL_OUT,
> +		dev_net(port->dev), NULL, skb, NULL, skb->dev,
> +		br_dev_queue_push_xmit);
> +}
> +
> +void br_multicast_wakeupcall_rcv(struct net_bridge *br,
> +				 struct net_bridge_port *port,
> +				 struct sk_buff *skb, u16 vid)
> +{
> +	if (!br_multicast_wakeupcall_check(br, port, skb, vid))
> +		return;
> +
> +	br_multicast_wakeupcall_send_mldq(br, port, eth_hdr(skb)->h_source);
> +}
> +
> +#endif /* CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS */
> +
>  static void br_multicast_query_expired(struct net_bridge *br,
>  				       struct bridge_mcast_own_query *query,
>  				       struct bridge_mcast_querier *querier)
> @@ -2023,6 +2284,15 @@ int br_multicast_set_port_router(struct net_bridge=
_port *p, unsigned long val)
>  	return err;
>  }
> =20
> +int br_multicast_set_wakeupcall(struct net_bridge_port *p, unsigned long=
 val)
> +{
> +	if (val > U8_MAX)
> +		return -EINVAL;
> +
> +	p->wakeupcall_num_rings =3D val;
> +	return 0;
> +}
> +
>  static void br_multicast_start_querier(struct net_bridge *br,
>  				       struct bridge_mcast_own_query *query)
>  {
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 147d52596e17..3372d954b075 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -149,6 +149,9 @@ static inline size_t br_port_info_size(void)
>  		+ nla_total_size_64bit(sizeof(u64)) /* IFLA_BRPORT_HOLD_TIMER */
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
> +#endif
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MCAST_WAKEUPCALL */
>  #endif
>  		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
>  		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
> @@ -240,6 +243,11 @@ static int br_port_fill_attrs(struct sk_buff *skb,
>  		       p->multicast_router))
>  		return -EMSGSIZE;
>  #endif
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +	if (nla_put_u8(skb, IFLA_BRPORT_MCAST_WAKEUPCALL,
> +		       p->wakeupcall_num_rings))
> +		return -EMSGSIZE;
> +#endif
> =20
>  	/* we might be called only with br->lock */
>  	rcu_read_lock();
> @@ -724,6 +732,7 @@ static const struct nla_policy br_port_policy[IFLA_BR=
PORT_MAX + 1] =3D {
>  	[IFLA_BRPORT_PROXYARP_WIFI] =3D { .type =3D NLA_U8 },
>  	[IFLA_BRPORT_MULTICAST_ROUTER] =3D { .type =3D NLA_U8 },
>  	[IFLA_BRPORT_MCAST_TO_UCAST] =3D { .type =3D NLA_U8 },
> +	[IFLA_BRPORT_MCAST_WAKEUPCALL] =3D { .type =3D NLA_U8 },
>  	[IFLA_BRPORT_MCAST_FLOOD] =3D { .type =3D NLA_U8 },
>  	[IFLA_BRPORT_BCAST_FLOOD] =3D { .type =3D NLA_U8 },
>  	[IFLA_BRPORT_VLAN_TUNNEL] =3D { .type =3D NLA_U8 },
> @@ -868,6 +877,16 @@ static int br_setport(struct net_bridge_port *p, str=
uct nlattr *tb[])
>  	}
>  #endif
> =20
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +	if (tb[IFLA_BRPORT_MCAST_WAKEUPCALL]) {
> +		u8 wakeupcall =3D nla_get_u8(tb[IFLA_BRPORT_MCAST_WAKEUPCALL]);
> +
> +		err =3D br_multicast_set_wakeupcall(p, wakeupcall);
> +		if (err)
> +			return err;
> +	}
> +#endif
> +
>  	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
>  		u16 fwd_mask =3D nla_get_u16(tb[IFLA_BRPORT_GROUP_FWD_MASK]);
> =20
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index baa1500f384f..3d22571294f3 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -208,6 +208,10 @@ struct net_bridge_fdb_entry {
>  	unsigned long			used;
> =20
>  	struct rcu_head			rcu;
> +
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +	struct timer_list		wakeupcall_timer;
> +#endif
>  };
> =20
>  #define MDB_PG_FLAGS_PERMANENT	BIT(0)
> @@ -277,6 +281,7 @@ struct net_bridge_port {
>  	struct timer_list		multicast_router_timer;
>  	struct hlist_head		mglist;
>  	struct hlist_node		rlist;
> +	u8				wakeupcall_num_rings;
>  #endif
> =20
>  #ifdef CONFIG_SYSFS
> @@ -940,6 +945,20 @@ static inline int br_multicast_igmp_type(const struc=
t sk_buff *skb)
>  }
>  #endif
> =20
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +void br_multicast_wakeupcall_rcv(struct net_bridge *br,
> +				 struct net_bridge_port *port,
> +				 struct sk_buff *skb, u16 vid);
> +void br_multicast_send_wakeupcall(struct timer_list *t);
> +int br_multicast_set_wakeupcall(struct net_bridge_port *p, unsigned long=
 val);
> +#else
> +static inline void br_multicast_wakeupcall_rcv(struct net_bridge *br,
> +					       struct net_bridge_port *port,
> +					       struct sk_buff *skb, u16 vid)
> +{
> +}
> +#endif /* CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS */
> +
>  /* br_vlan.c */
>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>  bool br_allowed_ingress(const struct net_bridge *br,
> diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
> index 7a59cdddd3ce..0b68576b6da6 100644
> --- a/net/bridge/br_sysfs_if.c
> +++ b/net/bridge/br_sysfs_if.c
> @@ -249,6 +249,21 @@ BRPORT_ATTR_FLAG(multicast_fast_leave, BR_MULTICAST_=
FAST_LEAVE);
>  BRPORT_ATTR_FLAG(multicast_to_unicast, BR_MULTICAST_TO_UNICAST);
>  #endif
> =20
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +static ssize_t show_multicast_wakeupcall(struct net_bridge_port *p, char=
 *buf)
> +{
> +	return sprintf(buf, "%d\n", p->wakeupcall_num_rings);
> +}
> +
> +static int store_multicast_wakeupcall(struct net_bridge_port *p,
> +				      unsigned long v)
> +{
> +	return br_multicast_set_wakeupcall(p, v);
> +}
> +static BRPORT_ATTR(multicast_wakeupcall, 0644, show_multicast_wakeupcall,
> +		   store_multicast_wakeupcall);
> +#endif
> +
>  static const struct brport_attribute *brport_attrs[] =3D {
>  	&brport_attr_path_cost,
>  	&brport_attr_priority,
> @@ -274,6 +289,9 @@ static const struct brport_attribute *brport_attrs[] =
=3D {
>  	&brport_attr_multicast_router,
>  	&brport_attr_multicast_fast_leave,
>  	&brport_attr_multicast_to_unicast,
> +#endif
> +#ifdef CONFIG_BRIDGE_IGMP_SNOOPING_WAKEUPCALLS
> +	&brport_attr_multicast_wakeupcall,
>  #endif
>  	&brport_attr_proxyarp,
>  	&brport_attr_proxyarp_wifi,

Rather than adding yet another feature to the bridge, could this hack be do=
ne by
having a BPF hook? or netfilter module?
