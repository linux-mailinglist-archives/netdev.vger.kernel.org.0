Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D120D81A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387415AbgF2Tfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:35:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59216 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731876AbgF2Tfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:35:47 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E568920D286
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:36:42 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D496B200EC;
        Mon, 29 Jun 2020 13:36:42 +0000 (UTC)
Received: from us4-mdac16-66.at1.mdlocal (unknown [10.110.50.157])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D29FA6009B;
        Mon, 29 Jun 2020 13:36:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 52F66220078;
        Mon, 29 Jun 2020 13:36:42 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DC0F834005D;
        Mon, 29 Jun 2020 13:36:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Jun
 2020 14:36:37 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 14/15] sfc: commonise ARFS handling
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3750523f-1c2f-628d-1f71-39b355cf6661@solarflare.com>
Message-ID: <2a6e5010-75f2-9c43-6a20-fbca159eef3b@solarflare.com>
Date:   Mon, 29 Jun 2020 14:36:33 +0100
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
X-TM-AS-Result: No-4.930900-8.000000-10
X-TMASE-MatchedRID: wXB7bW5HoSKh9oPbMj7PPPCoOvLLtsMhSoCG4sefl8QGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc7U1g4lO1dF7ZFCdtV6Jf3WimHWEC28pk0KogTtqoQiBquPvo9L6iaIuDX
        FlWkcRb7SAMKRDNnvIf1IZ9j+Jw0BGdVSNQ1S+GURBjzsfzCd+VWiBZGwRpH+h2PNS3AljLs9AM
        2fSzYVL7LFzVWms74CHdq74htd0GemWOD8X0TFhOouvI+nvaRrSRAY0aYK4Xgkt9BigJAcVrqgR
        OSQe1cRrpHml9UShoy03vv284nw/t3ayerUAlue4uOO8v5wJui++wkLapadd7FbhhcWxNQOjKex
        icEa6XgtTpdgjcMhx10pErA9gDkH8VFKgEI2S3KcxB01DrjF97qGBW9J0Yqjl0fnruLcE4Dwb+w
        bv5zoMofwmhpC5Bg1gGC8WI2tP2BZUCXhKjTWACQ4UCgoD20CUGKOMTReNj4uJkuWXG4MpF24Yv
        C9/lw+nBGPZ1F1OdtajG3kExxaaoxcnvTjb4Fz7vTMSwgFi9+Siza26cvwNGmycYYiBYyZl5wro
        gyz/gNsslTF3sRRapGTpe1iiCJq71zr0FZRMbBt1O49r1VEa8RB0bsfrpPIfiAqrjYtFiRM87H5
        JAqwY5xmryNmPt13w6E8bIYXJ0NZCV4GRi6eBH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.930900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25510.003
X-MDID: 1593437802-KVN11Gyzd1Nr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 will use the same approach to ARFS as EF10.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.h       |   5 -
 drivers/net/ethernet/sfc/rx.c        | 234 ---------------------------
 drivers/net/ethernet/sfc/rx_common.c | 234 +++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/rx_common.h |   4 +
 4 files changed, 238 insertions(+), 239 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index 8aadec02407c..e8be786582c0 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -147,11 +147,6 @@ static inline s32 efx_filter_get_rx_ids(struct efx_nic *efx,
 {
 	return efx->type->filter_get_rx_ids(efx, priority, buf, size);
 }
-#ifdef CONFIG_RFS_ACCEL
-int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
-		   u16 rxq_index, u32 flow_id);
-bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
-#endif
 
 /* RSS contexts */
 static inline bool efx_rss_active(struct efx_rss_context *ctx)
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index c01916cff507..a201a30b5d29 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -417,237 +417,3 @@ void __efx_rx_packet(struct efx_channel *channel)
 out:
 	channel->rx_pkt_n_frags = 0;
 }
-
-#ifdef CONFIG_RFS_ACCEL
-
-static void efx_filter_rfs_work(struct work_struct *data)
-{
-	struct efx_async_filter_insertion *req = container_of(data, struct efx_async_filter_insertion,
-							      work);
-	struct efx_nic *efx = netdev_priv(req->net_dev);
-	struct efx_channel *channel = efx_get_channel(efx, req->rxq_index);
-	int slot_idx = req - efx->rps_slot;
-	struct efx_arfs_rule *rule;
-	u16 arfs_id = 0;
-	int rc;
-
-	rc = efx->type->filter_insert(efx, &req->spec, true);
-	if (rc >= 0)
-		/* Discard 'priority' part of EF10+ filter ID (mcdi_filters) */
-		rc %= efx->type->max_rx_ip_filters;
-	if (efx->rps_hash_table) {
-		spin_lock_bh(&efx->rps_hash_lock);
-		rule = efx_rps_hash_find(efx, &req->spec);
-		/* The rule might have already gone, if someone else's request
-		 * for the same spec was already worked and then expired before
-		 * we got around to our work.  In that case we have nothing
-		 * tying us to an arfs_id, meaning that as soon as the filter
-		 * is considered for expiry it will be removed.
-		 */
-		if (rule) {
-			if (rc < 0)
-				rule->filter_id = EFX_ARFS_FILTER_ID_ERROR;
-			else
-				rule->filter_id = rc;
-			arfs_id = rule->arfs_id;
-		}
-		spin_unlock_bh(&efx->rps_hash_lock);
-	}
-	if (rc >= 0) {
-		/* Remember this so we can check whether to expire the filter
-		 * later.
-		 */
-		mutex_lock(&efx->rps_mutex);
-		if (channel->rps_flow_id[rc] == RPS_FLOW_ID_INVALID)
-			channel->rfs_filter_count++;
-		channel->rps_flow_id[rc] = req->flow_id;
-		mutex_unlock(&efx->rps_mutex);
-
-		if (req->spec.ether_type == htons(ETH_P_IP))
-			netif_info(efx, rx_status, efx->net_dev,
-				   "steering %s %pI4:%u:%pI4:%u to queue %u [flow %u filter %d id %u]\n",
-				   (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
-				   req->spec.rem_host, ntohs(req->spec.rem_port),
-				   req->spec.loc_host, ntohs(req->spec.loc_port),
-				   req->rxq_index, req->flow_id, rc, arfs_id);
-		else
-			netif_info(efx, rx_status, efx->net_dev,
-				   "steering %s [%pI6]:%u:[%pI6]:%u to queue %u [flow %u filter %d id %u]\n",
-				   (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
-				   req->spec.rem_host, ntohs(req->spec.rem_port),
-				   req->spec.loc_host, ntohs(req->spec.loc_port),
-				   req->rxq_index, req->flow_id, rc, arfs_id);
-		channel->n_rfs_succeeded++;
-	} else {
-		if (req->spec.ether_type == htons(ETH_P_IP))
-			netif_dbg(efx, rx_status, efx->net_dev,
-				  "failed to steer %s %pI4:%u:%pI4:%u to queue %u [flow %u rc %d id %u]\n",
-				  (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
-				  req->spec.rem_host, ntohs(req->spec.rem_port),
-				  req->spec.loc_host, ntohs(req->spec.loc_port),
-				  req->rxq_index, req->flow_id, rc, arfs_id);
-		else
-			netif_dbg(efx, rx_status, efx->net_dev,
-				  "failed to steer %s [%pI6]:%u:[%pI6]:%u to queue %u [flow %u rc %d id %u]\n",
-				  (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
-				  req->spec.rem_host, ntohs(req->spec.rem_port),
-				  req->spec.loc_host, ntohs(req->spec.loc_port),
-				  req->rxq_index, req->flow_id, rc, arfs_id);
-		channel->n_rfs_failed++;
-		/* We're overloading the NIC's filter tables, so let's do a
-		 * chunk of extra expiry work.
-		 */
-		__efx_filter_rfs_expire(channel, min(channel->rfs_filter_count,
-						     100u));
-	}
-
-	/* Release references */
-	clear_bit(slot_idx, &efx->rps_slot_map);
-	dev_put(req->net_dev);
-}
-
-int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
-		   u16 rxq_index, u32 flow_id)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-	struct efx_async_filter_insertion *req;
-	struct efx_arfs_rule *rule;
-	struct flow_keys fk;
-	int slot_idx;
-	bool new;
-	int rc;
-
-	/* find a free slot */
-	for (slot_idx = 0; slot_idx < EFX_RPS_MAX_IN_FLIGHT; slot_idx++)
-		if (!test_and_set_bit(slot_idx, &efx->rps_slot_map))
-			break;
-	if (slot_idx >= EFX_RPS_MAX_IN_FLIGHT)
-		return -EBUSY;
-
-	if (flow_id == RPS_FLOW_ID_INVALID) {
-		rc = -EINVAL;
-		goto out_clear;
-	}
-
-	if (!skb_flow_dissect_flow_keys(skb, &fk, 0)) {
-		rc = -EPROTONOSUPPORT;
-		goto out_clear;
-	}
-
-	if (fk.basic.n_proto != htons(ETH_P_IP) && fk.basic.n_proto != htons(ETH_P_IPV6)) {
-		rc = -EPROTONOSUPPORT;
-		goto out_clear;
-	}
-	if (fk.control.flags & FLOW_DIS_IS_FRAGMENT) {
-		rc = -EPROTONOSUPPORT;
-		goto out_clear;
-	}
-
-	req = efx->rps_slot + slot_idx;
-	efx_filter_init_rx(&req->spec, EFX_FILTER_PRI_HINT,
-			   efx->rx_scatter ? EFX_FILTER_FLAG_RX_SCATTER : 0,
-			   rxq_index);
-	req->spec.match_flags =
-		EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_IP_PROTO |
-		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_LOC_PORT |
-		EFX_FILTER_MATCH_REM_HOST | EFX_FILTER_MATCH_REM_PORT;
-	req->spec.ether_type = fk.basic.n_proto;
-	req->spec.ip_proto = fk.basic.ip_proto;
-
-	if (fk.basic.n_proto == htons(ETH_P_IP)) {
-		req->spec.rem_host[0] = fk.addrs.v4addrs.src;
-		req->spec.loc_host[0] = fk.addrs.v4addrs.dst;
-	} else {
-		memcpy(req->spec.rem_host, &fk.addrs.v6addrs.src,
-		       sizeof(struct in6_addr));
-		memcpy(req->spec.loc_host, &fk.addrs.v6addrs.dst,
-		       sizeof(struct in6_addr));
-	}
-
-	req->spec.rem_port = fk.ports.src;
-	req->spec.loc_port = fk.ports.dst;
-
-	if (efx->rps_hash_table) {
-		/* Add it to ARFS hash table */
-		spin_lock(&efx->rps_hash_lock);
-		rule = efx_rps_hash_add(efx, &req->spec, &new);
-		if (!rule) {
-			rc = -ENOMEM;
-			goto out_unlock;
-		}
-		if (new)
-			rule->arfs_id = efx->rps_next_id++ % RPS_NO_FILTER;
-		rc = rule->arfs_id;
-		/* Skip if existing or pending filter already does the right thing */
-		if (!new && rule->rxq_index == rxq_index &&
-		    rule->filter_id >= EFX_ARFS_FILTER_ID_PENDING)
-			goto out_unlock;
-		rule->rxq_index = rxq_index;
-		rule->filter_id = EFX_ARFS_FILTER_ID_PENDING;
-		spin_unlock(&efx->rps_hash_lock);
-	} else {
-		/* Without an ARFS hash table, we just use arfs_id 0 for all
-		 * filters.  This means if multiple flows hash to the same
-		 * flow_id, all but the most recently touched will be eligible
-		 * for expiry.
-		 */
-		rc = 0;
-	}
-
-	/* Queue the request */
-	dev_hold(req->net_dev = net_dev);
-	INIT_WORK(&req->work, efx_filter_rfs_work);
-	req->rxq_index = rxq_index;
-	req->flow_id = flow_id;
-	schedule_work(&req->work);
-	return rc;
-out_unlock:
-	spin_unlock(&efx->rps_hash_lock);
-out_clear:
-	clear_bit(slot_idx, &efx->rps_slot_map);
-	return rc;
-}
-
-bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota)
-{
-	bool (*expire_one)(struct efx_nic *efx, u32 flow_id, unsigned int index);
-	struct efx_nic *efx = channel->efx;
-	unsigned int index, size, start;
-	u32 flow_id;
-
-	if (!mutex_trylock(&efx->rps_mutex))
-		return false;
-	expire_one = efx->type->filter_rfs_expire_one;
-	index = channel->rfs_expire_index;
-	start = index;
-	size = efx->type->max_rx_ip_filters;
-	while (quota) {
-		flow_id = channel->rps_flow_id[index];
-
-		if (flow_id != RPS_FLOW_ID_INVALID) {
-			quota--;
-			if (expire_one(efx, flow_id, index)) {
-				netif_info(efx, rx_status, efx->net_dev,
-					   "expired filter %d [channel %u flow %u]\n",
-					   index, channel->channel, flow_id);
-				channel->rps_flow_id[index] = RPS_FLOW_ID_INVALID;
-				channel->rfs_filter_count--;
-			}
-		}
-		if (++index == size)
-			index = 0;
-		/* If we were called with a quota that exceeds the total number
-		 * of filters in the table (which shouldn't happen, but could
-		 * if two callers race), ensure that we don't loop forever -
-		 * stop when we've examined every row of the table.
-		 */
-		if (index == start)
-			break;
-	}
-
-	channel->rfs_expire_index = index;
-	mutex_unlock(&efx->rps_mutex);
-	return true;
-}
-
-#endif /* CONFIG_RFS_ACCEL */
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index e10c23833515..9927e9ecbbb4 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -849,3 +849,237 @@ void efx_remove_filters(struct efx_nic *efx)
 	efx->type->filter_table_remove(efx);
 	up_write(&efx->filter_sem);
 }
+
+#ifdef CONFIG_RFS_ACCEL
+
+static void efx_filter_rfs_work(struct work_struct *data)
+{
+	struct efx_async_filter_insertion *req = container_of(data, struct efx_async_filter_insertion,
+							      work);
+	struct efx_nic *efx = netdev_priv(req->net_dev);
+	struct efx_channel *channel = efx_get_channel(efx, req->rxq_index);
+	int slot_idx = req - efx->rps_slot;
+	struct efx_arfs_rule *rule;
+	u16 arfs_id = 0;
+	int rc;
+
+	rc = efx->type->filter_insert(efx, &req->spec, true);
+	if (rc >= 0)
+		/* Discard 'priority' part of EF10+ filter ID (mcdi_filters) */
+		rc %= efx->type->max_rx_ip_filters;
+	if (efx->rps_hash_table) {
+		spin_lock_bh(&efx->rps_hash_lock);
+		rule = efx_rps_hash_find(efx, &req->spec);
+		/* The rule might have already gone, if someone else's request
+		 * for the same spec was already worked and then expired before
+		 * we got around to our work.  In that case we have nothing
+		 * tying us to an arfs_id, meaning that as soon as the filter
+		 * is considered for expiry it will be removed.
+		 */
+		if (rule) {
+			if (rc < 0)
+				rule->filter_id = EFX_ARFS_FILTER_ID_ERROR;
+			else
+				rule->filter_id = rc;
+			arfs_id = rule->arfs_id;
+		}
+		spin_unlock_bh(&efx->rps_hash_lock);
+	}
+	if (rc >= 0) {
+		/* Remember this so we can check whether to expire the filter
+		 * later.
+		 */
+		mutex_lock(&efx->rps_mutex);
+		if (channel->rps_flow_id[rc] == RPS_FLOW_ID_INVALID)
+			channel->rfs_filter_count++;
+		channel->rps_flow_id[rc] = req->flow_id;
+		mutex_unlock(&efx->rps_mutex);
+
+		if (req->spec.ether_type == htons(ETH_P_IP))
+			netif_info(efx, rx_status, efx->net_dev,
+				   "steering %s %pI4:%u:%pI4:%u to queue %u [flow %u filter %d id %u]\n",
+				   (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
+				   req->spec.rem_host, ntohs(req->spec.rem_port),
+				   req->spec.loc_host, ntohs(req->spec.loc_port),
+				   req->rxq_index, req->flow_id, rc, arfs_id);
+		else
+			netif_info(efx, rx_status, efx->net_dev,
+				   "steering %s [%pI6]:%u:[%pI6]:%u to queue %u [flow %u filter %d id %u]\n",
+				   (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
+				   req->spec.rem_host, ntohs(req->spec.rem_port),
+				   req->spec.loc_host, ntohs(req->spec.loc_port),
+				   req->rxq_index, req->flow_id, rc, arfs_id);
+		channel->n_rfs_succeeded++;
+	} else {
+		if (req->spec.ether_type == htons(ETH_P_IP))
+			netif_dbg(efx, rx_status, efx->net_dev,
+				  "failed to steer %s %pI4:%u:%pI4:%u to queue %u [flow %u rc %d id %u]\n",
+				  (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
+				  req->spec.rem_host, ntohs(req->spec.rem_port),
+				  req->spec.loc_host, ntohs(req->spec.loc_port),
+				  req->rxq_index, req->flow_id, rc, arfs_id);
+		else
+			netif_dbg(efx, rx_status, efx->net_dev,
+				  "failed to steer %s [%pI6]:%u:[%pI6]:%u to queue %u [flow %u rc %d id %u]\n",
+				  (req->spec.ip_proto == IPPROTO_TCP) ? "TCP" : "UDP",
+				  req->spec.rem_host, ntohs(req->spec.rem_port),
+				  req->spec.loc_host, ntohs(req->spec.loc_port),
+				  req->rxq_index, req->flow_id, rc, arfs_id);
+		channel->n_rfs_failed++;
+		/* We're overloading the NIC's filter tables, so let's do a
+		 * chunk of extra expiry work.
+		 */
+		__efx_filter_rfs_expire(channel, min(channel->rfs_filter_count,
+						     100u));
+	}
+
+	/* Release references */
+	clear_bit(slot_idx, &efx->rps_slot_map);
+	dev_put(req->net_dev);
+}
+
+int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
+		   u16 rxq_index, u32 flow_id)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+	struct efx_async_filter_insertion *req;
+	struct efx_arfs_rule *rule;
+	struct flow_keys fk;
+	int slot_idx;
+	bool new;
+	int rc;
+
+	/* find a free slot */
+	for (slot_idx = 0; slot_idx < EFX_RPS_MAX_IN_FLIGHT; slot_idx++)
+		if (!test_and_set_bit(slot_idx, &efx->rps_slot_map))
+			break;
+	if (slot_idx >= EFX_RPS_MAX_IN_FLIGHT)
+		return -EBUSY;
+
+	if (flow_id == RPS_FLOW_ID_INVALID) {
+		rc = -EINVAL;
+		goto out_clear;
+	}
+
+	if (!skb_flow_dissect_flow_keys(skb, &fk, 0)) {
+		rc = -EPROTONOSUPPORT;
+		goto out_clear;
+	}
+
+	if (fk.basic.n_proto != htons(ETH_P_IP) && fk.basic.n_proto != htons(ETH_P_IPV6)) {
+		rc = -EPROTONOSUPPORT;
+		goto out_clear;
+	}
+	if (fk.control.flags & FLOW_DIS_IS_FRAGMENT) {
+		rc = -EPROTONOSUPPORT;
+		goto out_clear;
+	}
+
+	req = efx->rps_slot + slot_idx;
+	efx_filter_init_rx(&req->spec, EFX_FILTER_PRI_HINT,
+			   efx->rx_scatter ? EFX_FILTER_FLAG_RX_SCATTER : 0,
+			   rxq_index);
+	req->spec.match_flags =
+		EFX_FILTER_MATCH_ETHER_TYPE | EFX_FILTER_MATCH_IP_PROTO |
+		EFX_FILTER_MATCH_LOC_HOST | EFX_FILTER_MATCH_LOC_PORT |
+		EFX_FILTER_MATCH_REM_HOST | EFX_FILTER_MATCH_REM_PORT;
+	req->spec.ether_type = fk.basic.n_proto;
+	req->spec.ip_proto = fk.basic.ip_proto;
+
+	if (fk.basic.n_proto == htons(ETH_P_IP)) {
+		req->spec.rem_host[0] = fk.addrs.v4addrs.src;
+		req->spec.loc_host[0] = fk.addrs.v4addrs.dst;
+	} else {
+		memcpy(req->spec.rem_host, &fk.addrs.v6addrs.src,
+		       sizeof(struct in6_addr));
+		memcpy(req->spec.loc_host, &fk.addrs.v6addrs.dst,
+		       sizeof(struct in6_addr));
+	}
+
+	req->spec.rem_port = fk.ports.src;
+	req->spec.loc_port = fk.ports.dst;
+
+	if (efx->rps_hash_table) {
+		/* Add it to ARFS hash table */
+		spin_lock(&efx->rps_hash_lock);
+		rule = efx_rps_hash_add(efx, &req->spec, &new);
+		if (!rule) {
+			rc = -ENOMEM;
+			goto out_unlock;
+		}
+		if (new)
+			rule->arfs_id = efx->rps_next_id++ % RPS_NO_FILTER;
+		rc = rule->arfs_id;
+		/* Skip if existing or pending filter already does the right thing */
+		if (!new && rule->rxq_index == rxq_index &&
+		    rule->filter_id >= EFX_ARFS_FILTER_ID_PENDING)
+			goto out_unlock;
+		rule->rxq_index = rxq_index;
+		rule->filter_id = EFX_ARFS_FILTER_ID_PENDING;
+		spin_unlock(&efx->rps_hash_lock);
+	} else {
+		/* Without an ARFS hash table, we just use arfs_id 0 for all
+		 * filters.  This means if multiple flows hash to the same
+		 * flow_id, all but the most recently touched will be eligible
+		 * for expiry.
+		 */
+		rc = 0;
+	}
+
+	/* Queue the request */
+	dev_hold(req->net_dev = net_dev);
+	INIT_WORK(&req->work, efx_filter_rfs_work);
+	req->rxq_index = rxq_index;
+	req->flow_id = flow_id;
+	schedule_work(&req->work);
+	return rc;
+out_unlock:
+	spin_unlock(&efx->rps_hash_lock);
+out_clear:
+	clear_bit(slot_idx, &efx->rps_slot_map);
+	return rc;
+}
+
+bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota)
+{
+	bool (*expire_one)(struct efx_nic *efx, u32 flow_id, unsigned int index);
+	struct efx_nic *efx = channel->efx;
+	unsigned int index, size, start;
+	u32 flow_id;
+
+	if (!mutex_trylock(&efx->rps_mutex))
+		return false;
+	expire_one = efx->type->filter_rfs_expire_one;
+	index = channel->rfs_expire_index;
+	start = index;
+	size = efx->type->max_rx_ip_filters;
+	while (quota) {
+		flow_id = channel->rps_flow_id[index];
+
+		if (flow_id != RPS_FLOW_ID_INVALID) {
+			quota--;
+			if (expire_one(efx, flow_id, index)) {
+				netif_info(efx, rx_status, efx->net_dev,
+					   "expired filter %d [channel %u flow %u]\n",
+					   index, channel->channel, flow_id);
+				channel->rps_flow_id[index] = RPS_FLOW_ID_INVALID;
+				channel->rfs_filter_count--;
+			}
+		}
+		if (++index == size)
+			index = 0;
+		/* If we were called with a quota that exceeds the total number
+		 * of filters in the table (which shouldn't happen, but could
+		 * if two callers race), ensure that we don't loop forever -
+		 * stop when we've examined every row of the table.
+		 */
+		if (index == start)
+			break;
+	}
+
+	channel->rfs_expire_index = index;
+	mutex_unlock(&efx->rps_mutex);
+	return true;
+}
+
+#endif /* CONFIG_RFS_ACCEL */
diff --git a/drivers/net/ethernet/sfc/rx_common.h b/drivers/net/ethernet/sfc/rx_common.h
index c41f12a89477..3508dd316570 100644
--- a/drivers/net/ethernet/sfc/rx_common.h
+++ b/drivers/net/ethernet/sfc/rx_common.h
@@ -89,6 +89,10 @@ struct efx_arfs_rule *efx_rps_hash_add(struct efx_nic *efx,
 				       const struct efx_filter_spec *spec,
 				       bool *new);
 void efx_rps_hash_del(struct efx_nic *efx, const struct efx_filter_spec *spec);
+
+int efx_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
+		   u16 rxq_index, u32 flow_id);
+bool __efx_filter_rfs_expire(struct efx_channel *channel, unsigned int quota);
 #endif
 
 int efx_probe_filters(struct efx_nic *efx);

