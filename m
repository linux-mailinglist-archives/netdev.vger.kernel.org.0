Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D868620DF5C
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389401AbgF2UfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:35:10 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:37140 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732188AbgF2TVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:21:33 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 964E820D08C
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:35:15 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 84CDF2008F;
        Mon, 29 Jun 2020 13:35:15 +0000 (UTC)
Received: from us4-mdac16-9.at1.mdlocal (unknown [10.110.49.191])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 78892800AC;
        Mon, 29 Jun 2020 13:35:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C879640072;
        Mon, 29 Jun 2020 13:35:14 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 01D6B8009A;
        Mon, 29 Jun 2020 13:35:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:35:09 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 08/15] sfc: commonise ethtool NFC and RXFH/RSS
 functions
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <78e4130f-ce16-2c36-94e8-4ebb35e814aa@solarflare.com>
Date:   Mon, 29 Jun 2020 14:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25510.003
X-TM-AS-Result: No-5.888900-8.000000-10
X-TMASE-MatchedRID: DYXSdc7newLjtwtQtmXE5bsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc5el/ldITy+ZL4v11zmWaeKB7TqRAYVohaZ2scyRQcer+OeTF42zeolptN
        rryJ4UEhkKUy0+G4/sdGor5sS4O17HWlGy04g9z5HQFjzAbvJEBXytXp9UuwEydmEN0UhdkTELY
        2kh2BC5anpXO4yFxgnA7Kl5ovdLNNmz7PUJFt/VkNsgQWRiIpM2zgw5RT/BrYRGC0rW8q1XaKkU
        0t47vZI3k5E0nKWebAQH1/5RooS5oir9MqcjAA9zNIobH2DzGGqdpuEuCeGaFfLpI8fOvDuTx9j
        hIf/nmy43+Y7Msub/rPnrzlTZe0ReNwp7qZDbQe+hCRkqj3j0zFcf92WG8u/R2YNIFh+clHBZqE
        dJyZjPVqz8mWYrj0fTXZ1AfIjADTCFdW8OB9PNxfae1/VAFhlUGKOMTReNj6KXNybanokT8ESQx
        QDVVJ146vFa+4Exm5vU4DrAss84DcpdZ3fQiLdOX/V8P8ail1yZ8zcONpAscRB0bsfrpPInfebC
        PtgykCUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.888900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437715-XTxqgOjZy4EM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 will share EF10's model of filtering, hashing and spreading.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c        | 672 ----------------------
 drivers/net/ethernet/sfc/ethtool_common.c | 672 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/ethtool_common.h |  16 +
 3 files changed, 688 insertions(+), 672 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 55413d451ac3..5e0051b94ae7 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -267,678 +267,6 @@ static int efx_ethtool_reset(struct net_device *net_dev, u32 *flags)
 	return efx_reset(efx, rc);
 }
 
-/* MAC address mask including only I/G bit */
-static const u8 mac_addr_ig_mask[ETH_ALEN] __aligned(2) = {0x01, 0, 0, 0, 0, 0};
-
-#define IP4_ADDR_FULL_MASK	((__force __be32)~0)
-#define IP_PROTO_FULL_MASK	0xFF
-#define PORT_FULL_MASK		((__force __be16)~0)
-#define ETHER_TYPE_FULL_MASK	((__force __be16)~0)
-
-static inline void ip6_fill_mask(__be32 *mask)
-{
-	mask[0] = mask[1] = mask[2] = mask[3] = ~(__be32)0;
-}
-
-static int efx_ethtool_get_class_rule(struct efx_nic *efx,
-				      struct ethtool_rx_flow_spec *rule,
-				      u32 *rss_context)
-{
-	struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
-	struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
-	struct ethtool_usrip4_spec *uip_entry = &rule->h_u.usr_ip4_spec;
-	struct ethtool_usrip4_spec *uip_mask = &rule->m_u.usr_ip4_spec;
-	struct ethtool_tcpip6_spec *ip6_entry = &rule->h_u.tcp_ip6_spec;
-	struct ethtool_tcpip6_spec *ip6_mask = &rule->m_u.tcp_ip6_spec;
-	struct ethtool_usrip6_spec *uip6_entry = &rule->h_u.usr_ip6_spec;
-	struct ethtool_usrip6_spec *uip6_mask = &rule->m_u.usr_ip6_spec;
-	struct ethhdr *mac_entry = &rule->h_u.ether_spec;
-	struct ethhdr *mac_mask = &rule->m_u.ether_spec;
-	struct efx_filter_spec spec;
-	int rc;
-
-	rc = efx_filter_get_filter_safe(efx, EFX_FILTER_PRI_MANUAL,
-					rule->location, &spec);
-	if (rc)
-		return rc;
-
-	if (spec.dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP)
-		rule->ring_cookie = RX_CLS_FLOW_DISC;
-	else
-		rule->ring_cookie = spec.dmaq_id;
-
-	if ((spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE) &&
-	    spec.ether_type == htons(ETH_P_IP) &&
-	    (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) &&
-	    (spec.ip_proto == IPPROTO_TCP || spec.ip_proto == IPPROTO_UDP) &&
-	    !(spec.match_flags &
-	      ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
-		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
-		EFX_FILTER_MATCH_IP_PROTO |
-		EFX_FILTER_MATCH_LOC_PORT | EFX_FILTER_MATCH_REM_PORT))) {
-		rule->flow_type = ((spec.ip_proto == IPPROTO_TCP) ?
-				   TCP_V4_FLOW : UDP_V4_FLOW);
-		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
-			ip_entry->ip4dst = spec.loc_host[0];
-			ip_mask->ip4dst = IP4_ADDR_FULL_MASK;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
-			ip_entry->ip4src = spec.rem_host[0];
-			ip_mask->ip4src = IP4_ADDR_FULL_MASK;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_LOC_PORT) {
-			ip_entry->pdst = spec.loc_port;
-			ip_mask->pdst = PORT_FULL_MASK;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_PORT) {
-			ip_entry->psrc = spec.rem_port;
-			ip_mask->psrc = PORT_FULL_MASK;
-		}
-	} else if ((spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE) &&
-	    spec.ether_type == htons(ETH_P_IPV6) &&
-	    (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) &&
-	    (spec.ip_proto == IPPROTO_TCP || spec.ip_proto == IPPROTO_UDP) &&
-	    !(spec.match_flags &
-	      ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
-		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
-		EFX_FILTER_MATCH_IP_PROTO |
-		EFX_FILTER_MATCH_LOC_PORT | EFX_FILTER_MATCH_REM_PORT))) {
-		rule->flow_type = ((spec.ip_proto == IPPROTO_TCP) ?
-				   TCP_V6_FLOW : UDP_V6_FLOW);
-		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
-			memcpy(ip6_entry->ip6dst, spec.loc_host,
-			       sizeof(ip6_entry->ip6dst));
-			ip6_fill_mask(ip6_mask->ip6dst);
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
-			memcpy(ip6_entry->ip6src, spec.rem_host,
-			       sizeof(ip6_entry->ip6src));
-			ip6_fill_mask(ip6_mask->ip6src);
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_LOC_PORT) {
-			ip6_entry->pdst = spec.loc_port;
-			ip6_mask->pdst = PORT_FULL_MASK;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_PORT) {
-			ip6_entry->psrc = spec.rem_port;
-			ip6_mask->psrc = PORT_FULL_MASK;
-		}
-	} else if (!(spec.match_flags &
-		     ~(EFX_FILTER_MATCH_LOC_MAC | EFX_FILTER_MATCH_LOC_MAC_IG |
-		       EFX_FILTER_MATCH_REM_MAC | EFX_FILTER_MATCH_ETHER_TYPE |
-		       EFX_FILTER_MATCH_OUTER_VID))) {
-		rule->flow_type = ETHER_FLOW;
-		if (spec.match_flags &
-		    (EFX_FILTER_MATCH_LOC_MAC | EFX_FILTER_MATCH_LOC_MAC_IG)) {
-			ether_addr_copy(mac_entry->h_dest, spec.loc_mac);
-			if (spec.match_flags & EFX_FILTER_MATCH_LOC_MAC)
-				eth_broadcast_addr(mac_mask->h_dest);
-			else
-				ether_addr_copy(mac_mask->h_dest,
-						mac_addr_ig_mask);
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_MAC) {
-			ether_addr_copy(mac_entry->h_source, spec.rem_mac);
-			eth_broadcast_addr(mac_mask->h_source);
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE) {
-			mac_entry->h_proto = spec.ether_type;
-			mac_mask->h_proto = ETHER_TYPE_FULL_MASK;
-		}
-	} else if (spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE &&
-		   spec.ether_type == htons(ETH_P_IP) &&
-		   !(spec.match_flags &
-		     ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
-		       EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
-		       EFX_FILTER_MATCH_IP_PROTO))) {
-		rule->flow_type = IPV4_USER_FLOW;
-		uip_entry->ip_ver = ETH_RX_NFC_IP4;
-		if (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) {
-			uip_mask->proto = IP_PROTO_FULL_MASK;
-			uip_entry->proto = spec.ip_proto;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
-			uip_entry->ip4dst = spec.loc_host[0];
-			uip_mask->ip4dst = IP4_ADDR_FULL_MASK;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
-			uip_entry->ip4src = spec.rem_host[0];
-			uip_mask->ip4src = IP4_ADDR_FULL_MASK;
-		}
-	} else if (spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE &&
-		   spec.ether_type == htons(ETH_P_IPV6) &&
-		   !(spec.match_flags &
-		     ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
-		       EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
-		       EFX_FILTER_MATCH_IP_PROTO))) {
-		rule->flow_type = IPV6_USER_FLOW;
-		if (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) {
-			uip6_mask->l4_proto = IP_PROTO_FULL_MASK;
-			uip6_entry->l4_proto = spec.ip_proto;
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
-			memcpy(uip6_entry->ip6dst, spec.loc_host,
-			       sizeof(uip6_entry->ip6dst));
-			ip6_fill_mask(uip6_mask->ip6dst);
-		}
-		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
-			memcpy(uip6_entry->ip6src, spec.rem_host,
-			       sizeof(uip6_entry->ip6src));
-			ip6_fill_mask(uip6_mask->ip6src);
-		}
-	} else {
-		/* The above should handle all filters that we insert */
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	if (spec.match_flags & EFX_FILTER_MATCH_OUTER_VID) {
-		rule->flow_type |= FLOW_EXT;
-		rule->h_ext.vlan_tci = spec.outer_vid;
-		rule->m_ext.vlan_tci = htons(0xfff);
-	}
-
-	if (spec.flags & EFX_FILTER_FLAG_RX_RSS) {
-		rule->flow_type |= FLOW_RSS;
-		*rss_context = spec.rss_context;
-	}
-
-	return rc;
-}
-
-static int
-efx_ethtool_get_rxnfc(struct net_device *net_dev,
-		      struct ethtool_rxnfc *info, u32 *rule_locs)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	u32 rss_context = 0;
-	s32 rc = 0;
-
-	switch (info->cmd) {
-	case ETHTOOL_GRXRINGS:
-		info->data = efx->n_rx_channels;
-		return 0;
-
-	case ETHTOOL_GRXFH: {
-		struct efx_rss_context *ctx = &efx->rss_context;
-		__u64 data;
-
-		mutex_lock(&efx->rss_lock);
-		if (info->flow_type & FLOW_RSS && info->rss_context) {
-			ctx = efx_find_rss_context_entry(efx, info->rss_context);
-			if (!ctx) {
-				rc = -ENOENT;
-				goto out_unlock;
-			}
-		}
-
-		data = 0;
-		if (!efx_rss_active(ctx)) /* No RSS */
-			goto out_setdata_unlock;
-
-		switch (info->flow_type & ~FLOW_RSS) {
-		case UDP_V4_FLOW:
-		case UDP_V6_FLOW:
-			if (ctx->rx_hash_udp_4tuple)
-				data = (RXH_L4_B_0_1 | RXH_L4_B_2_3 |
-					RXH_IP_SRC | RXH_IP_DST);
-			else
-				data = RXH_IP_SRC | RXH_IP_DST;
-			break;
-		case TCP_V4_FLOW:
-		case TCP_V6_FLOW:
-			data = (RXH_L4_B_0_1 | RXH_L4_B_2_3 |
-				RXH_IP_SRC | RXH_IP_DST);
-			break;
-		case SCTP_V4_FLOW:
-		case SCTP_V6_FLOW:
-		case AH_ESP_V4_FLOW:
-		case AH_ESP_V6_FLOW:
-		case IPV4_FLOW:
-		case IPV6_FLOW:
-			data = RXH_IP_SRC | RXH_IP_DST;
-			break;
-		default:
-			break;
-		}
-out_setdata_unlock:
-		info->data = data;
-out_unlock:
-		mutex_unlock(&efx->rss_lock);
-		return rc;
-	}
-
-	case ETHTOOL_GRXCLSRLCNT:
-		info->data = efx_filter_get_rx_id_limit(efx);
-		if (info->data == 0)
-			return -EOPNOTSUPP;
-		info->data |= RX_CLS_LOC_SPECIAL;
-		info->rule_cnt =
-			efx_filter_count_rx_used(efx, EFX_FILTER_PRI_MANUAL);
-		return 0;
-
-	case ETHTOOL_GRXCLSRULE:
-		if (efx_filter_get_rx_id_limit(efx) == 0)
-			return -EOPNOTSUPP;
-		rc = efx_ethtool_get_class_rule(efx, &info->fs, &rss_context);
-		if (rc < 0)
-			return rc;
-		if (info->fs.flow_type & FLOW_RSS)
-			info->rss_context = rss_context;
-		return 0;
-
-	case ETHTOOL_GRXCLSRLALL:
-		info->data = efx_filter_get_rx_id_limit(efx);
-		if (info->data == 0)
-			return -EOPNOTSUPP;
-		rc = efx_filter_get_rx_ids(efx, EFX_FILTER_PRI_MANUAL,
-					   rule_locs, info->rule_cnt);
-		if (rc < 0)
-			return rc;
-		info->rule_cnt = rc;
-		return 0;
-
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static inline bool ip6_mask_is_full(__be32 mask[4])
-{
-	return !~(mask[0] & mask[1] & mask[2] & mask[3]);
-}
-
-static inline bool ip6_mask_is_empty(__be32 mask[4])
-{
-	return !(mask[0] | mask[1] | mask[2] | mask[3]);
-}
-
-static int efx_ethtool_set_class_rule(struct efx_nic *efx,
-				      struct ethtool_rx_flow_spec *rule,
-				      u32 rss_context)
-{
-	struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
-	struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
-	struct ethtool_usrip4_spec *uip_entry = &rule->h_u.usr_ip4_spec;
-	struct ethtool_usrip4_spec *uip_mask = &rule->m_u.usr_ip4_spec;
-	struct ethtool_tcpip6_spec *ip6_entry = &rule->h_u.tcp_ip6_spec;
-	struct ethtool_tcpip6_spec *ip6_mask = &rule->m_u.tcp_ip6_spec;
-	struct ethtool_usrip6_spec *uip6_entry = &rule->h_u.usr_ip6_spec;
-	struct ethtool_usrip6_spec *uip6_mask = &rule->m_u.usr_ip6_spec;
-	u32 flow_type = rule->flow_type & ~(FLOW_EXT | FLOW_RSS);
-	struct ethhdr *mac_entry = &rule->h_u.ether_spec;
-	struct ethhdr *mac_mask = &rule->m_u.ether_spec;
-	enum efx_filter_flags flags = 0;
-	struct efx_filter_spec spec;
-	int rc;
-
-	/* Check that user wants us to choose the location */
-	if (rule->location != RX_CLS_LOC_ANY)
-		return -EINVAL;
-
-	/* Range-check ring_cookie */
-	if (rule->ring_cookie >= efx->n_rx_channels &&
-	    rule->ring_cookie != RX_CLS_FLOW_DISC)
-		return -EINVAL;
-
-	/* Check for unsupported extensions */
-	if ((rule->flow_type & FLOW_EXT) &&
-	    (rule->m_ext.vlan_etype || rule->m_ext.data[0] ||
-	     rule->m_ext.data[1]))
-		return -EINVAL;
-
-	if (efx->rx_scatter)
-		flags |= EFX_FILTER_FLAG_RX_SCATTER;
-	if (rule->flow_type & FLOW_RSS)
-		flags |= EFX_FILTER_FLAG_RX_RSS;
-
-	efx_filter_init_rx(&spec, EFX_FILTER_PRI_MANUAL, flags,
-			   (rule->ring_cookie == RX_CLS_FLOW_DISC) ?
-			   EFX_FILTER_RX_DMAQ_ID_DROP : rule->ring_cookie);
-
-	if (rule->flow_type & FLOW_RSS)
-		spec.rss_context = rss_context;
-
-	switch (flow_type) {
-	case TCP_V4_FLOW:
-	case UDP_V4_FLOW:
-		spec.match_flags = (EFX_FILTER_MATCH_ETHER_TYPE |
-				    EFX_FILTER_MATCH_IP_PROTO);
-		spec.ether_type = htons(ETH_P_IP);
-		spec.ip_proto = flow_type == TCP_V4_FLOW ? IPPROTO_TCP
-							 : IPPROTO_UDP;
-		if (ip_mask->ip4dst) {
-			if (ip_mask->ip4dst != IP4_ADDR_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
-			spec.loc_host[0] = ip_entry->ip4dst;
-		}
-		if (ip_mask->ip4src) {
-			if (ip_mask->ip4src != IP4_ADDR_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
-			spec.rem_host[0] = ip_entry->ip4src;
-		}
-		if (ip_mask->pdst) {
-			if (ip_mask->pdst != PORT_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_LOC_PORT;
-			spec.loc_port = ip_entry->pdst;
-		}
-		if (ip_mask->psrc) {
-			if (ip_mask->psrc != PORT_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_PORT;
-			spec.rem_port = ip_entry->psrc;
-		}
-		if (ip_mask->tos)
-			return -EINVAL;
-		break;
-
-	case TCP_V6_FLOW:
-	case UDP_V6_FLOW:
-		spec.match_flags = (EFX_FILTER_MATCH_ETHER_TYPE |
-				    EFX_FILTER_MATCH_IP_PROTO);
-		spec.ether_type = htons(ETH_P_IPV6);
-		spec.ip_proto = flow_type == TCP_V6_FLOW ? IPPROTO_TCP
-							 : IPPROTO_UDP;
-		if (!ip6_mask_is_empty(ip6_mask->ip6dst)) {
-			if (!ip6_mask_is_full(ip6_mask->ip6dst))
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
-			memcpy(spec.loc_host, ip6_entry->ip6dst, sizeof(spec.loc_host));
-		}
-		if (!ip6_mask_is_empty(ip6_mask->ip6src)) {
-			if (!ip6_mask_is_full(ip6_mask->ip6src))
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
-			memcpy(spec.rem_host, ip6_entry->ip6src, sizeof(spec.rem_host));
-		}
-		if (ip6_mask->pdst) {
-			if (ip6_mask->pdst != PORT_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_LOC_PORT;
-			spec.loc_port = ip6_entry->pdst;
-		}
-		if (ip6_mask->psrc) {
-			if (ip6_mask->psrc != PORT_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_PORT;
-			spec.rem_port = ip6_entry->psrc;
-		}
-		if (ip6_mask->tclass)
-			return -EINVAL;
-		break;
-
-	case IPV4_USER_FLOW:
-		if (uip_mask->l4_4_bytes || uip_mask->tos || uip_mask->ip_ver ||
-		    uip_entry->ip_ver != ETH_RX_NFC_IP4)
-			return -EINVAL;
-		spec.match_flags = EFX_FILTER_MATCH_ETHER_TYPE;
-		spec.ether_type = htons(ETH_P_IP);
-		if (uip_mask->ip4dst) {
-			if (uip_mask->ip4dst != IP4_ADDR_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
-			spec.loc_host[0] = uip_entry->ip4dst;
-		}
-		if (uip_mask->ip4src) {
-			if (uip_mask->ip4src != IP4_ADDR_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
-			spec.rem_host[0] = uip_entry->ip4src;
-		}
-		if (uip_mask->proto) {
-			if (uip_mask->proto != IP_PROTO_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_IP_PROTO;
-			spec.ip_proto = uip_entry->proto;
-		}
-		break;
-
-	case IPV6_USER_FLOW:
-		if (uip6_mask->l4_4_bytes || uip6_mask->tclass)
-			return -EINVAL;
-		spec.match_flags = EFX_FILTER_MATCH_ETHER_TYPE;
-		spec.ether_type = htons(ETH_P_IPV6);
-		if (!ip6_mask_is_empty(uip6_mask->ip6dst)) {
-			if (!ip6_mask_is_full(uip6_mask->ip6dst))
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
-			memcpy(spec.loc_host, uip6_entry->ip6dst, sizeof(spec.loc_host));
-		}
-		if (!ip6_mask_is_empty(uip6_mask->ip6src)) {
-			if (!ip6_mask_is_full(uip6_mask->ip6src))
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
-			memcpy(spec.rem_host, uip6_entry->ip6src, sizeof(spec.rem_host));
-		}
-		if (uip6_mask->l4_proto) {
-			if (uip6_mask->l4_proto != IP_PROTO_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_IP_PROTO;
-			spec.ip_proto = uip6_entry->l4_proto;
-		}
-		break;
-
-	case ETHER_FLOW:
-		if (!is_zero_ether_addr(mac_mask->h_dest)) {
-			if (ether_addr_equal(mac_mask->h_dest,
-					     mac_addr_ig_mask))
-				spec.match_flags |= EFX_FILTER_MATCH_LOC_MAC_IG;
-			else if (is_broadcast_ether_addr(mac_mask->h_dest))
-				spec.match_flags |= EFX_FILTER_MATCH_LOC_MAC;
-			else
-				return -EINVAL;
-			ether_addr_copy(spec.loc_mac, mac_entry->h_dest);
-		}
-		if (!is_zero_ether_addr(mac_mask->h_source)) {
-			if (!is_broadcast_ether_addr(mac_mask->h_source))
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_REM_MAC;
-			ether_addr_copy(spec.rem_mac, mac_entry->h_source);
-		}
-		if (mac_mask->h_proto) {
-			if (mac_mask->h_proto != ETHER_TYPE_FULL_MASK)
-				return -EINVAL;
-			spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
-			spec.ether_type = mac_entry->h_proto;
-		}
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	if ((rule->flow_type & FLOW_EXT) && rule->m_ext.vlan_tci) {
-		if (rule->m_ext.vlan_tci != htons(0xfff))
-			return -EINVAL;
-		spec.match_flags |= EFX_FILTER_MATCH_OUTER_VID;
-		spec.outer_vid = rule->h_ext.vlan_tci;
-	}
-
-	rc = efx_filter_insert_filter(efx, &spec, true);
-	if (rc < 0)
-		return rc;
-
-	rule->location = rc;
-	return 0;
-}
-
-static int efx_ethtool_set_rxnfc(struct net_device *net_dev,
-				 struct ethtool_rxnfc *info)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx_filter_get_rx_id_limit(efx) == 0)
-		return -EOPNOTSUPP;
-
-	switch (info->cmd) {
-	case ETHTOOL_SRXCLSRLINS:
-		return efx_ethtool_set_class_rule(efx, &info->fs,
-						  info->rss_context);
-
-	case ETHTOOL_SRXCLSRLDEL:
-		return efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_MANUAL,
-						 info->fs.location);
-
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static u32 efx_ethtool_get_rxfh_indir_size(struct net_device *net_dev)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	if (efx->n_rx_channels == 1)
-		return 0;
-	return ARRAY_SIZE(efx->rss_context.rx_indir_table);
-}
-
-static u32 efx_ethtool_get_rxfh_key_size(struct net_device *net_dev)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	return efx->type->rx_hash_key_size;
-}
-
-static int efx_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
-				u8 *hfunc)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	int rc;
-
-	rc = efx->type->rx_pull_rss_config(efx);
-	if (rc)
-		return rc;
-
-	if (hfunc)
-		*hfunc = ETH_RSS_HASH_TOP;
-	if (indir)
-		memcpy(indir, efx->rss_context.rx_indir_table,
-		       sizeof(efx->rss_context.rx_indir_table));
-	if (key)
-		memcpy(key, efx->rss_context.rx_hash_key,
-		       efx->type->rx_hash_key_size);
-	return 0;
-}
-
-static int efx_ethtool_set_rxfh(struct net_device *net_dev, const u32 *indir,
-				const u8 *key, const u8 hfunc)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	/* Hash function is Toeplitz, cannot be changed */
-	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
-		return -EOPNOTSUPP;
-	if (!indir && !key)
-		return 0;
-
-	if (!key)
-		key = efx->rss_context.rx_hash_key;
-	if (!indir)
-		indir = efx->rss_context.rx_indir_table;
-
-	return efx->type->rx_push_rss_config(efx, true, indir, key);
-}
-
-static int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
-					u8 *key, u8 *hfunc, u32 rss_context)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	struct efx_rss_context *ctx;
-	int rc = 0;
-
-	if (!efx->type->rx_pull_rss_context_config)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&efx->rss_lock);
-	ctx = efx_find_rss_context_entry(efx, rss_context);
-	if (!ctx) {
-		rc = -ENOENT;
-		goto out_unlock;
-	}
-	rc = efx->type->rx_pull_rss_context_config(efx, ctx);
-	if (rc)
-		goto out_unlock;
-
-	if (hfunc)
-		*hfunc = ETH_RSS_HASH_TOP;
-	if (indir)
-		memcpy(indir, ctx->rx_indir_table, sizeof(ctx->rx_indir_table));
-	if (key)
-		memcpy(key, ctx->rx_hash_key, efx->type->rx_hash_key_size);
-out_unlock:
-	mutex_unlock(&efx->rss_lock);
-	return rc;
-}
-
-static int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
-					const u32 *indir, const u8 *key,
-					const u8 hfunc, u32 *rss_context,
-					bool delete)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	struct efx_rss_context *ctx;
-	bool allocated = false;
-	int rc;
-
-	if (!efx->type->rx_push_rss_context_config)
-		return -EOPNOTSUPP;
-	/* Hash function is Toeplitz, cannot be changed */
-	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&efx->rss_lock);
-
-	if (*rss_context == ETH_RXFH_CONTEXT_ALLOC) {
-		if (delete) {
-			/* alloc + delete == Nothing to do */
-			rc = -EINVAL;
-			goto out_unlock;
-		}
-		ctx = efx_alloc_rss_context_entry(efx);
-		if (!ctx) {
-			rc = -ENOMEM;
-			goto out_unlock;
-		}
-		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
-		/* Initialise indir table and key to defaults */
-		efx_set_default_rx_indir_table(efx, ctx);
-		netdev_rss_key_fill(ctx->rx_hash_key, sizeof(ctx->rx_hash_key));
-		allocated = true;
-	} else {
-		ctx = efx_find_rss_context_entry(efx, *rss_context);
-		if (!ctx) {
-			rc = -ENOENT;
-			goto out_unlock;
-		}
-	}
-
-	if (delete) {
-		/* delete this context */
-		rc = efx->type->rx_push_rss_context_config(efx, ctx, NULL, NULL);
-		if (!rc)
-			efx_free_rss_context_entry(ctx);
-		goto out_unlock;
-	}
-
-	if (!key)
-		key = ctx->rx_hash_key;
-	if (!indir)
-		indir = ctx->rx_indir_table;
-
-	rc = efx->type->rx_push_rss_context_config(efx, ctx, indir, key);
-	if (rc && allocated)
-		efx_free_rss_context_entry(ctx);
-	else
-		*rss_context = ctx->user_id;
-out_unlock:
-	mutex_unlock(&efx->rss_lock);
-	return rc;
-}
-
 static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 				   struct ethtool_ts_info *ts_info)
 {
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index b91961126eeb..d7d8795eb1d3 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -13,6 +13,7 @@
 #include "mcdi.h"
 #include "nic.h"
 #include "selftest.h"
+#include "rx_common.h"
 #include "ethtool_common.h"
 
 struct efx_sw_stat_desc {
@@ -601,3 +602,674 @@ int efx_ethtool_set_fecparam(struct net_device *net_dev,
 
 	return rc;
 }
+
+/* MAC address mask including only I/G bit */
+static const u8 mac_addr_ig_mask[ETH_ALEN] __aligned(2) = {0x01, 0, 0, 0, 0, 0};
+
+#define IP4_ADDR_FULL_MASK	((__force __be32)~0)
+#define IP_PROTO_FULL_MASK	0xFF
+#define PORT_FULL_MASK		((__force __be16)~0)
+#define ETHER_TYPE_FULL_MASK	((__force __be16)~0)
+
+static inline void ip6_fill_mask(__be32 *mask)
+{
+	mask[0] = mask[1] = mask[2] = mask[3] = ~(__be32)0;
+}
+
+static int efx_ethtool_get_class_rule(struct efx_nic *efx,
+				      struct ethtool_rx_flow_spec *rule,
+				      u32 *rss_context)
+{
+	struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
+	struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
+	struct ethtool_usrip4_spec *uip_entry = &rule->h_u.usr_ip4_spec;
+	struct ethtool_usrip4_spec *uip_mask = &rule->m_u.usr_ip4_spec;
+	struct ethtool_tcpip6_spec *ip6_entry = &rule->h_u.tcp_ip6_spec;
+	struct ethtool_tcpip6_spec *ip6_mask = &rule->m_u.tcp_ip6_spec;
+	struct ethtool_usrip6_spec *uip6_entry = &rule->h_u.usr_ip6_spec;
+	struct ethtool_usrip6_spec *uip6_mask = &rule->m_u.usr_ip6_spec;
+	struct ethhdr *mac_entry = &rule->h_u.ether_spec;
+	struct ethhdr *mac_mask = &rule->m_u.ether_spec;
+	struct efx_filter_spec spec;
+	int rc;
+
+	rc = efx_filter_get_filter_safe(efx, EFX_FILTER_PRI_MANUAL,
+					rule->location, &spec);
+	if (rc)
+		return rc;
+
+	if (spec.dmaq_id == EFX_FILTER_RX_DMAQ_ID_DROP)
+		rule->ring_cookie = RX_CLS_FLOW_DISC;
+	else
+		rule->ring_cookie = spec.dmaq_id;
+
+	if ((spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE) &&
+	    spec.ether_type == htons(ETH_P_IP) &&
+	    (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) &&
+	    (spec.ip_proto == IPPROTO_TCP || spec.ip_proto == IPPROTO_UDP) &&
+	    !(spec.match_flags &
+	      ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
+		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
+		EFX_FILTER_MATCH_IP_PROTO |
+		EFX_FILTER_MATCH_LOC_PORT | EFX_FILTER_MATCH_REM_PORT))) {
+		rule->flow_type = ((spec.ip_proto == IPPROTO_TCP) ?
+				   TCP_V4_FLOW : UDP_V4_FLOW);
+		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
+			ip_entry->ip4dst = spec.loc_host[0];
+			ip_mask->ip4dst = IP4_ADDR_FULL_MASK;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
+			ip_entry->ip4src = spec.rem_host[0];
+			ip_mask->ip4src = IP4_ADDR_FULL_MASK;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_LOC_PORT) {
+			ip_entry->pdst = spec.loc_port;
+			ip_mask->pdst = PORT_FULL_MASK;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_PORT) {
+			ip_entry->psrc = spec.rem_port;
+			ip_mask->psrc = PORT_FULL_MASK;
+		}
+	} else if ((spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE) &&
+	    spec.ether_type == htons(ETH_P_IPV6) &&
+	    (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) &&
+	    (spec.ip_proto == IPPROTO_TCP || spec.ip_proto == IPPROTO_UDP) &&
+	    !(spec.match_flags &
+	      ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
+		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
+		EFX_FILTER_MATCH_IP_PROTO |
+		EFX_FILTER_MATCH_LOC_PORT | EFX_FILTER_MATCH_REM_PORT))) {
+		rule->flow_type = ((spec.ip_proto == IPPROTO_TCP) ?
+				   TCP_V6_FLOW : UDP_V6_FLOW);
+		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
+			memcpy(ip6_entry->ip6dst, spec.loc_host,
+			       sizeof(ip6_entry->ip6dst));
+			ip6_fill_mask(ip6_mask->ip6dst);
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
+			memcpy(ip6_entry->ip6src, spec.rem_host,
+			       sizeof(ip6_entry->ip6src));
+			ip6_fill_mask(ip6_mask->ip6src);
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_LOC_PORT) {
+			ip6_entry->pdst = spec.loc_port;
+			ip6_mask->pdst = PORT_FULL_MASK;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_PORT) {
+			ip6_entry->psrc = spec.rem_port;
+			ip6_mask->psrc = PORT_FULL_MASK;
+		}
+	} else if (!(spec.match_flags &
+		     ~(EFX_FILTER_MATCH_LOC_MAC | EFX_FILTER_MATCH_LOC_MAC_IG |
+		       EFX_FILTER_MATCH_REM_MAC | EFX_FILTER_MATCH_ETHER_TYPE |
+		       EFX_FILTER_MATCH_OUTER_VID))) {
+		rule->flow_type = ETHER_FLOW;
+		if (spec.match_flags &
+		    (EFX_FILTER_MATCH_LOC_MAC | EFX_FILTER_MATCH_LOC_MAC_IG)) {
+			ether_addr_copy(mac_entry->h_dest, spec.loc_mac);
+			if (spec.match_flags & EFX_FILTER_MATCH_LOC_MAC)
+				eth_broadcast_addr(mac_mask->h_dest);
+			else
+				ether_addr_copy(mac_mask->h_dest,
+						mac_addr_ig_mask);
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_MAC) {
+			ether_addr_copy(mac_entry->h_source, spec.rem_mac);
+			eth_broadcast_addr(mac_mask->h_source);
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE) {
+			mac_entry->h_proto = spec.ether_type;
+			mac_mask->h_proto = ETHER_TYPE_FULL_MASK;
+		}
+	} else if (spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE &&
+		   spec.ether_type == htons(ETH_P_IP) &&
+		   !(spec.match_flags &
+		     ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
+		       EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
+		       EFX_FILTER_MATCH_IP_PROTO))) {
+		rule->flow_type = IPV4_USER_FLOW;
+		uip_entry->ip_ver = ETH_RX_NFC_IP4;
+		if (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) {
+			uip_mask->proto = IP_PROTO_FULL_MASK;
+			uip_entry->proto = spec.ip_proto;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
+			uip_entry->ip4dst = spec.loc_host[0];
+			uip_mask->ip4dst = IP4_ADDR_FULL_MASK;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
+			uip_entry->ip4src = spec.rem_host[0];
+			uip_mask->ip4src = IP4_ADDR_FULL_MASK;
+		}
+	} else if (spec.match_flags & EFX_FILTER_MATCH_ETHER_TYPE &&
+		   spec.ether_type == htons(ETH_P_IPV6) &&
+		   !(spec.match_flags &
+		     ~(EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_OUTER_VID |
+		       EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_REM_HOST |
+		       EFX_FILTER_MATCH_IP_PROTO))) {
+		rule->flow_type = IPV6_USER_FLOW;
+		if (spec.match_flags & EFX_FILTER_MATCH_IP_PROTO) {
+			uip6_mask->l4_proto = IP_PROTO_FULL_MASK;
+			uip6_entry->l4_proto = spec.ip_proto;
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_LOC_HOST) {
+			memcpy(uip6_entry->ip6dst, spec.loc_host,
+			       sizeof(uip6_entry->ip6dst));
+			ip6_fill_mask(uip6_mask->ip6dst);
+		}
+		if (spec.match_flags & EFX_FILTER_MATCH_REM_HOST) {
+			memcpy(uip6_entry->ip6src, spec.rem_host,
+			       sizeof(uip6_entry->ip6src));
+			ip6_fill_mask(uip6_mask->ip6src);
+		}
+	} else {
+		/* The above should handle all filters that we insert */
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (spec.match_flags & EFX_FILTER_MATCH_OUTER_VID) {
+		rule->flow_type |= FLOW_EXT;
+		rule->h_ext.vlan_tci = spec.outer_vid;
+		rule->m_ext.vlan_tci = htons(0xfff);
+	}
+
+	if (spec.flags & EFX_FILTER_FLAG_RX_RSS) {
+		rule->flow_type |= FLOW_RSS;
+		*rss_context = spec.rss_context;
+	}
+
+	return rc;
+}
+
+int efx_ethtool_get_rxnfc(struct net_device *net_dev,
+			  struct ethtool_rxnfc *info, u32 *rule_locs)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	u32 rss_context = 0;
+	s32 rc = 0;
+
+	switch (info->cmd) {
+	case ETHTOOL_GRXRINGS:
+		info->data = efx->n_rx_channels;
+		return 0;
+
+	case ETHTOOL_GRXFH: {
+		struct efx_rss_context *ctx = &efx->rss_context;
+		__u64 data;
+
+		mutex_lock(&efx->rss_lock);
+		if (info->flow_type & FLOW_RSS && info->rss_context) {
+			ctx = efx_find_rss_context_entry(efx, info->rss_context);
+			if (!ctx) {
+				rc = -ENOENT;
+				goto out_unlock;
+			}
+		}
+
+		data = 0;
+		if (!efx_rss_active(ctx)) /* No RSS */
+			goto out_setdata_unlock;
+
+		switch (info->flow_type & ~FLOW_RSS) {
+		case UDP_V4_FLOW:
+		case UDP_V6_FLOW:
+			if (ctx->rx_hash_udp_4tuple)
+				data = (RXH_L4_B_0_1 | RXH_L4_B_2_3 |
+					RXH_IP_SRC | RXH_IP_DST);
+			else
+				data = RXH_IP_SRC | RXH_IP_DST;
+			break;
+		case TCP_V4_FLOW:
+		case TCP_V6_FLOW:
+			data = (RXH_L4_B_0_1 | RXH_L4_B_2_3 |
+				RXH_IP_SRC | RXH_IP_DST);
+			break;
+		case SCTP_V4_FLOW:
+		case SCTP_V6_FLOW:
+		case AH_ESP_V4_FLOW:
+		case AH_ESP_V6_FLOW:
+		case IPV4_FLOW:
+		case IPV6_FLOW:
+			data = RXH_IP_SRC | RXH_IP_DST;
+			break;
+		default:
+			break;
+		}
+out_setdata_unlock:
+		info->data = data;
+out_unlock:
+		mutex_unlock(&efx->rss_lock);
+		return rc;
+	}
+
+	case ETHTOOL_GRXCLSRLCNT:
+		info->data = efx_filter_get_rx_id_limit(efx);
+		if (info->data == 0)
+			return -EOPNOTSUPP;
+		info->data |= RX_CLS_LOC_SPECIAL;
+		info->rule_cnt =
+			efx_filter_count_rx_used(efx, EFX_FILTER_PRI_MANUAL);
+		return 0;
+
+	case ETHTOOL_GRXCLSRULE:
+		if (efx_filter_get_rx_id_limit(efx) == 0)
+			return -EOPNOTSUPP;
+		rc = efx_ethtool_get_class_rule(efx, &info->fs, &rss_context);
+		if (rc < 0)
+			return rc;
+		if (info->fs.flow_type & FLOW_RSS)
+			info->rss_context = rss_context;
+		return 0;
+
+	case ETHTOOL_GRXCLSRLALL:
+		info->data = efx_filter_get_rx_id_limit(efx);
+		if (info->data == 0)
+			return -EOPNOTSUPP;
+		rc = efx_filter_get_rx_ids(efx, EFX_FILTER_PRI_MANUAL,
+					   rule_locs, info->rule_cnt);
+		if (rc < 0)
+			return rc;
+		info->rule_cnt = rc;
+		return 0;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static inline bool ip6_mask_is_full(__be32 mask[4])
+{
+	return !~(mask[0] & mask[1] & mask[2] & mask[3]);
+}
+
+static inline bool ip6_mask_is_empty(__be32 mask[4])
+{
+	return !(mask[0] | mask[1] | mask[2] | mask[3]);
+}
+
+static int efx_ethtool_set_class_rule(struct efx_nic *efx,
+				      struct ethtool_rx_flow_spec *rule,
+				      u32 rss_context)
+{
+	struct ethtool_tcpip4_spec *ip_entry = &rule->h_u.tcp_ip4_spec;
+	struct ethtool_tcpip4_spec *ip_mask = &rule->m_u.tcp_ip4_spec;
+	struct ethtool_usrip4_spec *uip_entry = &rule->h_u.usr_ip4_spec;
+	struct ethtool_usrip4_spec *uip_mask = &rule->m_u.usr_ip4_spec;
+	struct ethtool_tcpip6_spec *ip6_entry = &rule->h_u.tcp_ip6_spec;
+	struct ethtool_tcpip6_spec *ip6_mask = &rule->m_u.tcp_ip6_spec;
+	struct ethtool_usrip6_spec *uip6_entry = &rule->h_u.usr_ip6_spec;
+	struct ethtool_usrip6_spec *uip6_mask = &rule->m_u.usr_ip6_spec;
+	u32 flow_type = rule->flow_type & ~(FLOW_EXT | FLOW_RSS);
+	struct ethhdr *mac_entry = &rule->h_u.ether_spec;
+	struct ethhdr *mac_mask = &rule->m_u.ether_spec;
+	enum efx_filter_flags flags = 0;
+	struct efx_filter_spec spec;
+	int rc;
+
+	/* Check that user wants us to choose the location */
+	if (rule->location != RX_CLS_LOC_ANY)
+		return -EINVAL;
+
+	/* Range-check ring_cookie */
+	if (rule->ring_cookie >= efx->n_rx_channels &&
+	    rule->ring_cookie != RX_CLS_FLOW_DISC)
+		return -EINVAL;
+
+	/* Check for unsupported extensions */
+	if ((rule->flow_type & FLOW_EXT) &&
+	    (rule->m_ext.vlan_etype || rule->m_ext.data[0] ||
+	     rule->m_ext.data[1]))
+		return -EINVAL;
+
+	if (efx->rx_scatter)
+		flags |= EFX_FILTER_FLAG_RX_SCATTER;
+	if (rule->flow_type & FLOW_RSS)
+		flags |= EFX_FILTER_FLAG_RX_RSS;
+
+	efx_filter_init_rx(&spec, EFX_FILTER_PRI_MANUAL, flags,
+			   (rule->ring_cookie == RX_CLS_FLOW_DISC) ?
+			   EFX_FILTER_RX_DMAQ_ID_DROP : rule->ring_cookie);
+
+	if (rule->flow_type & FLOW_RSS)
+		spec.rss_context = rss_context;
+
+	switch (flow_type) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+		spec.match_flags = (EFX_FILTER_MATCH_ETHER_TYPE |
+				    EFX_FILTER_MATCH_IP_PROTO);
+		spec.ether_type = htons(ETH_P_IP);
+		spec.ip_proto = flow_type == TCP_V4_FLOW ? IPPROTO_TCP
+							 : IPPROTO_UDP;
+		if (ip_mask->ip4dst) {
+			if (ip_mask->ip4dst != IP4_ADDR_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
+			spec.loc_host[0] = ip_entry->ip4dst;
+		}
+		if (ip_mask->ip4src) {
+			if (ip_mask->ip4src != IP4_ADDR_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
+			spec.rem_host[0] = ip_entry->ip4src;
+		}
+		if (ip_mask->pdst) {
+			if (ip_mask->pdst != PORT_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_LOC_PORT;
+			spec.loc_port = ip_entry->pdst;
+		}
+		if (ip_mask->psrc) {
+			if (ip_mask->psrc != PORT_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_PORT;
+			spec.rem_port = ip_entry->psrc;
+		}
+		if (ip_mask->tos)
+			return -EINVAL;
+		break;
+
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+		spec.match_flags = (EFX_FILTER_MATCH_ETHER_TYPE |
+				    EFX_FILTER_MATCH_IP_PROTO);
+		spec.ether_type = htons(ETH_P_IPV6);
+		spec.ip_proto = flow_type == TCP_V6_FLOW ? IPPROTO_TCP
+							 : IPPROTO_UDP;
+		if (!ip6_mask_is_empty(ip6_mask->ip6dst)) {
+			if (!ip6_mask_is_full(ip6_mask->ip6dst))
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
+			memcpy(spec.loc_host, ip6_entry->ip6dst, sizeof(spec.loc_host));
+		}
+		if (!ip6_mask_is_empty(ip6_mask->ip6src)) {
+			if (!ip6_mask_is_full(ip6_mask->ip6src))
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
+			memcpy(spec.rem_host, ip6_entry->ip6src, sizeof(spec.rem_host));
+		}
+		if (ip6_mask->pdst) {
+			if (ip6_mask->pdst != PORT_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_LOC_PORT;
+			spec.loc_port = ip6_entry->pdst;
+		}
+		if (ip6_mask->psrc) {
+			if (ip6_mask->psrc != PORT_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_PORT;
+			spec.rem_port = ip6_entry->psrc;
+		}
+		if (ip6_mask->tclass)
+			return -EINVAL;
+		break;
+
+	case IPV4_USER_FLOW:
+		if (uip_mask->l4_4_bytes || uip_mask->tos || uip_mask->ip_ver ||
+		    uip_entry->ip_ver != ETH_RX_NFC_IP4)
+			return -EINVAL;
+		spec.match_flags = EFX_FILTER_MATCH_ETHER_TYPE;
+		spec.ether_type = htons(ETH_P_IP);
+		if (uip_mask->ip4dst) {
+			if (uip_mask->ip4dst != IP4_ADDR_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
+			spec.loc_host[0] = uip_entry->ip4dst;
+		}
+		if (uip_mask->ip4src) {
+			if (uip_mask->ip4src != IP4_ADDR_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
+			spec.rem_host[0] = uip_entry->ip4src;
+		}
+		if (uip_mask->proto) {
+			if (uip_mask->proto != IP_PROTO_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_IP_PROTO;
+			spec.ip_proto = uip_entry->proto;
+		}
+		break;
+
+	case IPV6_USER_FLOW:
+		if (uip6_mask->l4_4_bytes || uip6_mask->tclass)
+			return -EINVAL;
+		spec.match_flags = EFX_FILTER_MATCH_ETHER_TYPE;
+		spec.ether_type = htons(ETH_P_IPV6);
+		if (!ip6_mask_is_empty(uip6_mask->ip6dst)) {
+			if (!ip6_mask_is_full(uip6_mask->ip6dst))
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_LOC_HOST;
+			memcpy(spec.loc_host, uip6_entry->ip6dst, sizeof(spec.loc_host));
+		}
+		if (!ip6_mask_is_empty(uip6_mask->ip6src)) {
+			if (!ip6_mask_is_full(uip6_mask->ip6src))
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_HOST;
+			memcpy(spec.rem_host, uip6_entry->ip6src, sizeof(spec.rem_host));
+		}
+		if (uip6_mask->l4_proto) {
+			if (uip6_mask->l4_proto != IP_PROTO_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_IP_PROTO;
+			spec.ip_proto = uip6_entry->l4_proto;
+		}
+		break;
+
+	case ETHER_FLOW:
+		if (!is_zero_ether_addr(mac_mask->h_dest)) {
+			if (ether_addr_equal(mac_mask->h_dest,
+					     mac_addr_ig_mask))
+				spec.match_flags |= EFX_FILTER_MATCH_LOC_MAC_IG;
+			else if (is_broadcast_ether_addr(mac_mask->h_dest))
+				spec.match_flags |= EFX_FILTER_MATCH_LOC_MAC;
+			else
+				return -EINVAL;
+			ether_addr_copy(spec.loc_mac, mac_entry->h_dest);
+		}
+		if (!is_zero_ether_addr(mac_mask->h_source)) {
+			if (!is_broadcast_ether_addr(mac_mask->h_source))
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_REM_MAC;
+			ether_addr_copy(spec.rem_mac, mac_entry->h_source);
+		}
+		if (mac_mask->h_proto) {
+			if (mac_mask->h_proto != ETHER_TYPE_FULL_MASK)
+				return -EINVAL;
+			spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
+			spec.ether_type = mac_entry->h_proto;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if ((rule->flow_type & FLOW_EXT) && rule->m_ext.vlan_tci) {
+		if (rule->m_ext.vlan_tci != htons(0xfff))
+			return -EINVAL;
+		spec.match_flags |= EFX_FILTER_MATCH_OUTER_VID;
+		spec.outer_vid = rule->h_ext.vlan_tci;
+	}
+
+	rc = efx_filter_insert_filter(efx, &spec, true);
+	if (rc < 0)
+		return rc;
+
+	rule->location = rc;
+	return 0;
+}
+
+int efx_ethtool_set_rxnfc(struct net_device *net_dev,
+			  struct ethtool_rxnfc *info)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx_filter_get_rx_id_limit(efx) == 0)
+		return -EOPNOTSUPP;
+
+	switch (info->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		return efx_ethtool_set_class_rule(efx, &info->fs,
+						  info->rss_context);
+
+	case ETHTOOL_SRXCLSRLDEL:
+		return efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_MANUAL,
+						 info->fs.location);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+u32 efx_ethtool_get_rxfh_indir_size(struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->n_rx_channels == 1)
+		return 0;
+	return ARRAY_SIZE(efx->rss_context.rx_indir_table);
+}
+
+u32 efx_ethtool_get_rxfh_key_size(struct net_device *net_dev)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	return efx->type->rx_hash_key_size;
+}
+
+int efx_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
+			 u8 *hfunc)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	int rc;
+
+	rc = efx->type->rx_pull_rss_config(efx);
+	if (rc)
+		return rc;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+	if (indir)
+		memcpy(indir, efx->rss_context.rx_indir_table,
+		       sizeof(efx->rss_context.rx_indir_table));
+	if (key)
+		memcpy(key, efx->rss_context.rx_hash_key,
+		       efx->type->rx_hash_key_size);
+	return 0;
+}
+
+int efx_ethtool_set_rxfh(struct net_device *net_dev, const u32 *indir,
+			 const u8 *key, const u8 hfunc)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	/* Hash function is Toeplitz, cannot be changed */
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+	if (!indir && !key)
+		return 0;
+
+	if (!key)
+		key = efx->rss_context.rx_hash_key;
+	if (!indir)
+		indir = efx->rss_context.rx_indir_table;
+
+	return efx->type->rx_push_rss_config(efx, true, indir, key);
+}
+
+int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
+				 u8 *key, u8 *hfunc, u32 rss_context)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct efx_rss_context *ctx;
+	int rc = 0;
+
+	if (!efx->type->rx_pull_rss_context_config)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&efx->rss_lock);
+	ctx = efx_find_rss_context_entry(efx, rss_context);
+	if (!ctx) {
+		rc = -ENOENT;
+		goto out_unlock;
+	}
+	rc = efx->type->rx_pull_rss_context_config(efx, ctx);
+	if (rc)
+		goto out_unlock;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+	if (indir)
+		memcpy(indir, ctx->rx_indir_table, sizeof(ctx->rx_indir_table));
+	if (key)
+		memcpy(key, ctx->rx_hash_key, efx->type->rx_hash_key_size);
+out_unlock:
+	mutex_unlock(&efx->rss_lock);
+	return rc;
+}
+
+int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
+				 const u32 *indir, const u8 *key,
+				 const u8 hfunc, u32 *rss_context,
+				 bool delete)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct efx_rss_context *ctx;
+	bool allocated = false;
+	int rc;
+
+	if (!efx->type->rx_push_rss_context_config)
+		return -EOPNOTSUPP;
+	/* Hash function is Toeplitz, cannot be changed */
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&efx->rss_lock);
+
+	if (*rss_context == ETH_RXFH_CONTEXT_ALLOC) {
+		if (delete) {
+			/* alloc + delete == Nothing to do */
+			rc = -EINVAL;
+			goto out_unlock;
+		}
+		ctx = efx_alloc_rss_context_entry(efx);
+		if (!ctx) {
+			rc = -ENOMEM;
+			goto out_unlock;
+		}
+		ctx->context_id = EFX_MCDI_RSS_CONTEXT_INVALID;
+		/* Initialise indir table and key to defaults */
+		efx_set_default_rx_indir_table(efx, ctx);
+		netdev_rss_key_fill(ctx->rx_hash_key, sizeof(ctx->rx_hash_key));
+		allocated = true;
+	} else {
+		ctx = efx_find_rss_context_entry(efx, *rss_context);
+		if (!ctx) {
+			rc = -ENOENT;
+			goto out_unlock;
+		}
+	}
+
+	if (delete) {
+		/* delete this context */
+		rc = efx->type->rx_push_rss_context_config(efx, ctx, NULL, NULL);
+		if (!rc)
+			efx_free_rss_context_entry(ctx);
+		goto out_unlock;
+	}
+
+	if (!key)
+		key = ctx->rx_hash_key;
+	if (!indir)
+		indir = ctx->rx_indir_table;
+
+	rc = efx->type->rx_push_rss_context_config(efx, ctx, indir, key);
+	if (rc && allocated)
+		efx_free_rss_context_entry(ctx);
+	else
+		*rss_context = ctx->user_id;
+out_unlock:
+	mutex_unlock(&efx->rss_lock);
+	return rc;
+}
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index eaa1fd9157f8..024a78ce0905 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -37,4 +37,20 @@ int efx_ethtool_get_fecparam(struct net_device *net_dev,
 			     struct ethtool_fecparam *fecparam);
 int efx_ethtool_set_fecparam(struct net_device *net_dev,
 			     struct ethtool_fecparam *fecparam);
+int efx_ethtool_get_rxnfc(struct net_device *net_dev,
+			  struct ethtool_rxnfc *info, u32 *rule_locs);
+int efx_ethtool_set_rxnfc(struct net_device *net_dev,
+			  struct ethtool_rxnfc *info);
+u32 efx_ethtool_get_rxfh_indir_size(struct net_device *net_dev);
+u32 efx_ethtool_get_rxfh_key_size(struct net_device *net_dev);
+int efx_ethtool_get_rxfh(struct net_device *net_dev, u32 *indir, u8 *key,
+			 u8 *hfunc);
+int efx_ethtool_set_rxfh(struct net_device *net_dev,
+			 const u32 *indir, const u8 *key, const u8 hfunc);
+int efx_ethtool_get_rxfh_context(struct net_device *net_dev, u32 *indir,
+				 u8 *key, u8 *hfunc, u32 rss_context);
+int efx_ethtool_set_rxfh_context(struct net_device *net_dev,
+				 const u32 *indir, const u8 *key,
+				 const u8 hfunc, u32 *rss_context,
+				 bool delete);
 #endif


