Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A8623348D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgG3Ogs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:36:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60328 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgG3Ogr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 10:36:47 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B40116010E;
        Thu, 30 Jul 2020 14:36:46 +0000 (UTC)
Received: from us4-mdac16-32.ut7.mdlocal (unknown [10.7.66.145])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B2B0B8009E;
        Thu, 30 Jul 2020 14:36:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.176])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1AFE780070;
        Thu, 30 Jul 2020 14:36:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 898E468007A;
        Thu, 30 Jul 2020 14:36:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 15:36:33 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 04/12] sfc_ef100: TX path for EF100 NICs
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Message-ID: <3ce8bef2-6f5b-84f5-dce3-dd9a34746330@solarflare.com>
Date:   Thu, 30 Jul 2020 15:36:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25572.005
X-TM-AS-Result: No-15.778100-8.000000-10
X-TMASE-MatchedRID: k0If7wV2PvgM9SHmc6e0vqiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrPOP
        Ra/sN+oGfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkFqifzwY4bVrcflUbL70Jwq//6X0io9HxEgt
        IAt1bntLVstQScevTFjgKnJS0afWRU7tXQkLesrwn6YVq3MQsI1BijjE0XjY+GlfXMQvierc6Rv
        9YN97Y5ge12Spq8ms86YDSgpputKpfN6BhDtIz4jIjK23O9D33mdrHMkUHHq8TeUeU5use5gbTE
        KBg0WBHiKEAcHpvpidepovekByZHksjbhvPBf0QR0BY8wG7yRDmTPEuA2FKKacxvibtoCq3zQnA
        OmXc4++VKeTBHi8dMyMWNLrfOODJfmfYZ4AgHucXK/dRaOWlvewlOGZoQVV0i8VrlddQxsYc/f0
        XofiG9wBv1Gf6I3HTtbGzBmYDTk15JYwYB8Ubvi0x8J2DopEN+LljbN4c70N8Wx0lu+VLLR6q6H
        Ji0bIIdvMDsdlFTfwoVFQz+aPEawwhA/znOS/bKrDHzH6zmUVLqa9X75MqaUl/J9Ro+MAB5wxIy
        yhRieMbRHxQ6+ormhFCuSA0AK/rQ897cr1qZHpwju9EALAXQqMNYCHb1HdaSg8ufp5n3T4ACh5a
        lwhWMpjecj2e6HJGP1WB6XtkuCq7CdJld1eOdVYYEnRJHpL9YM9s6twyNwkjRiu1AuxJTPUXRTQ
        h9Qsb2nPTJ66uXI/Q1sxf/FqsuRA2kxuARasN9Ib/6w+1lWRXRBJn+k0VQfAlhlr8vzcdl9Mup5
        cLtszjuYqO2jWgp/c5Fm/x7ifdIZ57TkclczOeAiCmPx4NwLTrdaH1ZWqC1kTfEkyaZdz6C0ePs
        7A07YVH0dq7wY7uA/3R8k/14e0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--15.778100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596119806-MYOECJiAvqnl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Includes checksum offload and TSO, so declare those in our netdev features.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c  |   8 +
 drivers/net/ethernet/sfc/ef100_tx.c   | 368 +++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/ef100_tx.h   |   4 +
 drivers/net/ethernet/sfc/net_driver.h |  21 ++
 drivers/net/ethernet/sfc/tx_common.c  |   1 +
 6 files changed, 398 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 963d6c835cba..5d576bd99059 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -263,6 +263,9 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
 		case ESE_GZ_EF100_EV_MCDI:
 			efx_mcdi_process_event(channel, p_event);
 			break;
+		case ESE_GZ_EF100_EV_TX_COMPLETION:
+			ef100_ev_tx(channel, p_event);
+			break;
 		case ESE_GZ_EF100_EV_DRIVER:
 			netif_info(efx, drv, efx->net_dev,
 				   "Driver initiated event " EFX_QWORD_FMT "\n",
@@ -436,10 +439,15 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
 
 /*	NIC level access functions
  */
+#define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM |			\
+	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST |		\
+	NETIF_F_TSO_ECN | NETIF_F_TSO_MANGLEID | NETIF_F_HW_VLAN_CTAG_TX)
+
 const struct efx_nic_type ef100_pf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = false,
 	.probe = ef100_probe_pf,
+	.offload_features = EF100_OFFLOAD_FEATURES,
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 15e646f8c3e0..176dbf2d761c 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -9,14 +9,24 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <net/ip6_checksum.h>
+
 #include "net_driver.h"
 #include "tx_common.h"
 #include "nic_common.h"
+#include "mcdi_functions.h"
+#include "ef100_regs.h"
+#include "io.h"
 #include "ef100_tx.h"
+#include "ef100_nic.h"
 
-/* TX queue stubs */
 int ef100_tx_probe(struct efx_tx_queue *tx_queue)
 {
+	/* Allocate an extra descriptor for the QMDA status completion entry */
+	return efx_nic_alloc_buffer(tx_queue->efx, &tx_queue->txd.buf,
+				    (tx_queue->ptr_mask + 2) *
+				    sizeof(efx_oword_t),
+				    GFP_KERNEL);
 	return 0;
 }
 
@@ -27,10 +37,287 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue)
 		netdev_get_tx_queue(tx_queue->efx->net_dev,
 				    tx_queue->channel->channel -
 				    tx_queue->efx->tx_channel_offset);
+
+	if (efx_mcdi_tx_init(tx_queue, false))
+		netdev_WARN(tx_queue->efx->net_dev,
+			    "failed to initialise TXQ %d\n", tx_queue->queue);
+}
+
+static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+{
+	struct efx_nic *efx = tx_queue->efx;
+	struct ef100_nic_data *nic_data;
+	struct efx_tx_buffer *buffer;
+	struct tcphdr *tcphdr;
+	struct iphdr *iphdr;
+	size_t header_len;
+	u32 mss;
+
+	nic_data = efx->nic_data;
+
+	if (!skb_is_gso_tcp(skb))
+		return false;
+	if (!(efx->net_dev->features & NETIF_F_TSO))
+		return false;
+
+	mss = skb_shinfo(skb)->gso_size;
+	if (unlikely(mss < 4)) {
+		WARN_ONCE(1, "MSS of %u is too small for TSO\n", mss);
+		return false;
+	}
+
+	header_len = efx_tx_tso_header_length(skb);
+	if (header_len > nic_data->tso_max_hdr_len)
+		return false;
+
+	if (skb_shinfo(skb)->gso_segs > nic_data->tso_max_payload_num_segs) {
+		/* net_dev->gso_max_segs should've caught this */
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	if (skb->data_len / mss > nic_data->tso_max_frames)
+		return false;
+
+	/* net_dev->gso_max_size should've caught this */
+	if (WARN_ON_ONCE(skb->data_len > nic_data->tso_max_payload_len))
+		return false;
+
+	/* Reserve an empty buffer for the TSO V3 descriptor.
+	 * Convey the length of the header since we already know it.
+	 */
+	buffer = efx_tx_queue_get_insert_buffer(tx_queue);
+	buffer->flags = EFX_TX_BUF_TSO_V3 | EFX_TX_BUF_CONT;
+	buffer->len = header_len;
+	buffer->unmap_len = 0;
+	buffer->skb = skb;
+	++tx_queue->insert_count;
+
+	/* Adjust the TCP checksum to exclude the total length, since we set
+	 * ED_INNER_IP_LEN in the descriptor.
+	 */
+	tcphdr = tcp_hdr(skb);
+	if (skb_is_gso_v6(skb)) {
+		tcphdr->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+						 &ipv6_hdr(skb)->daddr,
+						 0, IPPROTO_TCP, 0);
+	} else {
+		iphdr = ip_hdr(skb);
+		tcphdr->check = ~csum_tcpudp_magic(iphdr->saddr, iphdr->daddr,
+						   0, IPPROTO_TCP, 0);
+	}
+	return true;
+}
+
+static inline efx_oword_t *ef100_tx_desc(struct efx_tx_queue *tx_queue,
+					 unsigned int index)
+{
+	if (likely(tx_queue->txd.buf.addr))
+		return ((efx_oword_t *)tx_queue->txd.buf.addr) + index;
+	else
+		return NULL;
+}
+
+void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue)
+{
+	unsigned int write_ptr;
+	efx_dword_t reg;
+
+	if (unlikely(tx_queue->notify_count == tx_queue->write_count))
+		return;
+
+	write_ptr = tx_queue->write_count & tx_queue->ptr_mask;
+	/* The write pointer goes into the high word */
+	EFX_POPULATE_DWORD_1(reg, ERF_GZ_TX_RING_PIDX, write_ptr);
+	efx_writed_page(tx_queue->efx, &reg,
+			ER_GZ_TX_RING_DOORBELL, tx_queue->queue);
+	tx_queue->notify_count = tx_queue->write_count;
+	tx_queue->xmit_more_available = false;
+}
+
+static void ef100_tx_push_buffers(struct efx_tx_queue *tx_queue)
+{
+	ef100_notify_tx_desc(tx_queue);
+	++tx_queue->pushes;
+}
+
+static void ef100_set_tx_csum_partial(const struct sk_buff *skb,
+				      struct efx_tx_buffer *buffer, efx_oword_t *txd)
+{
+	efx_oword_t csum;
+	int csum_start;
+
+	if (!skb || skb->ip_summed != CHECKSUM_PARTIAL)
+		return;
+
+	/* skb->csum_start has the offset from head, but we need the offset
+	 * from data.
+	 */
+	csum_start = skb_checksum_start_offset(skb);
+	EFX_POPULATE_OWORD_3(csum,
+			     ESF_GZ_TX_SEND_CSO_PARTIAL_EN, 1,
+			     ESF_GZ_TX_SEND_CSO_PARTIAL_START_W,
+			     csum_start >> 1,
+			     ESF_GZ_TX_SEND_CSO_PARTIAL_CSUM_W,
+			     skb->csum_offset >> 1);
+	EFX_OR_OWORD(*txd, *txd, csum);
+}
+
+static void ef100_set_tx_hw_vlan(const struct sk_buff *skb, efx_oword_t *txd)
+{
+	u16 vlan_tci = skb_vlan_tag_get(skb);
+	efx_oword_t vlan;
+
+	EFX_POPULATE_OWORD_2(vlan,
+			     ESF_GZ_TX_SEND_VLAN_INSERT_EN, 1,
+			     ESF_GZ_TX_SEND_VLAN_INSERT_TCI, vlan_tci);
+	EFX_OR_OWORD(*txd, *txd, vlan);
+}
+
+static void ef100_make_send_desc(struct efx_nic *efx,
+				 const struct sk_buff *skb,
+				 struct efx_tx_buffer *buffer, efx_oword_t *txd,
+				 unsigned int segment_count)
+{
+	/* TX send descriptor */
+	EFX_POPULATE_OWORD_3(*txd,
+			     ESF_GZ_TX_SEND_NUM_SEGS, segment_count,
+			     ESF_GZ_TX_SEND_LEN, buffer->len,
+			     ESF_GZ_TX_SEND_ADDR, buffer->dma_addr);
+
+	if (likely(efx->net_dev->features & NETIF_F_HW_CSUM))
+		ef100_set_tx_csum_partial(skb, buffer, txd);
+	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX &&
+	    skb && skb_vlan_tag_present(skb))
+		ef100_set_tx_hw_vlan(skb, txd);
+}
+
+static void ef100_make_tso_desc(struct efx_nic *efx,
+				const struct sk_buff *skb,
+				struct efx_tx_buffer *buffer, efx_oword_t *txd,
+				unsigned int segment_count)
+{
+	u32 mangleid = (efx->net_dev->features & NETIF_F_TSO_MANGLEID) ||
+		skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID ?
+		ESE_GZ_TX_DESC_IP4_ID_NO_OP :
+		ESE_GZ_TX_DESC_IP4_ID_INC_MOD16;
+	u16 vlan_enable =  efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX ?
+		skb_vlan_tag_present(skb) : 0;
+	unsigned int len, ip_offset, tcp_offset, payload_segs;
+	u16 vlan_tci = skb_vlan_tag_get(skb);
+	u32 mss = skb_shinfo(skb)->gso_size;
+
+	len = skb->len - buffer->len;
+	/* We use 1 for the TSO descriptor and 1 for the header */
+	payload_segs = segment_count - 2;
+	ip_offset =  skb_network_offset(skb);
+	tcp_offset = skb_transport_offset(skb);
+
+	EFX_POPULATE_OWORD_13(*txd,
+			      ESF_GZ_TX_DESC_TYPE, ESE_GZ_TX_DESC_TYPE_TSO,
+			      ESF_GZ_TX_TSO_MSS, mss,
+			      ESF_GZ_TX_TSO_HDR_NUM_SEGS, 1,
+			      ESF_GZ_TX_TSO_PAYLOAD_NUM_SEGS, payload_segs,
+			      ESF_GZ_TX_TSO_HDR_LEN_W, buffer->len >> 1,
+			      ESF_GZ_TX_TSO_PAYLOAD_LEN, len,
+			      ESF_GZ_TX_TSO_CSO_INNER_L4, 1,
+			      ESF_GZ_TX_TSO_INNER_L3_OFF_W, ip_offset >> 1,
+			      ESF_GZ_TX_TSO_INNER_L4_OFF_W, tcp_offset >> 1,
+			      ESF_GZ_TX_TSO_ED_INNER_IP4_ID, mangleid,
+			      ESF_GZ_TX_TSO_ED_INNER_IP_LEN, 1,
+			      ESF_GZ_TX_TSO_VLAN_INSERT_EN, vlan_enable,
+			      ESF_GZ_TX_TSO_VLAN_INSERT_TCI, vlan_tci
+		);
+}
+
+static void ef100_tx_make_descriptors(struct efx_tx_queue *tx_queue,
+				      const struct sk_buff *skb,
+				      unsigned int segment_count)
+{
+	unsigned int old_write_count = tx_queue->write_count;
+	unsigned int new_write_count = old_write_count;
+	struct efx_tx_buffer *buffer;
+	unsigned int next_desc_type;
+	unsigned int write_ptr;
+	efx_oword_t *txd;
+	unsigned int nr_descs = tx_queue->insert_count - old_write_count;
+
+	if (unlikely(nr_descs == 0))
+		return;
+
+	if (segment_count)
+		next_desc_type = ESE_GZ_TX_DESC_TYPE_TSO;
+	else
+		next_desc_type = ESE_GZ_TX_DESC_TYPE_SEND;
+
+	/* if it's a raw write (such as XDP) then always SEND single frames */
+	if (!skb)
+		nr_descs = 1;
+
+	do {
+		write_ptr = new_write_count & tx_queue->ptr_mask;
+		buffer = &tx_queue->buffer[write_ptr];
+		txd = ef100_tx_desc(tx_queue, write_ptr);
+		++new_write_count;
+
+		/* Create TX descriptor ring entry */
+		tx_queue->packet_write_count = new_write_count;
+
+		switch (next_desc_type) {
+		case ESE_GZ_TX_DESC_TYPE_SEND:
+			ef100_make_send_desc(tx_queue->efx, skb,
+					     buffer, txd, nr_descs);
+			break;
+		case ESE_GZ_TX_DESC_TYPE_TSO:
+			/* TX TSO descriptor */
+			WARN_ON_ONCE(!(buffer->flags & EFX_TX_BUF_TSO_V3));
+			ef100_make_tso_desc(tx_queue->efx, skb,
+					    buffer, txd, nr_descs);
+			break;
+		default:
+			/* TX segment descriptor */
+			EFX_POPULATE_OWORD_3(*txd,
+					     ESF_GZ_TX_DESC_TYPE, ESE_GZ_TX_DESC_TYPE_SEG,
+					     ESF_GZ_TX_SEG_LEN, buffer->len,
+					     ESF_GZ_TX_SEG_ADDR, buffer->dma_addr);
+		}
+		/* if it's a raw write (such as XDP) then always SEND */
+		next_desc_type = skb ? ESE_GZ_TX_DESC_TYPE_SEG :
+				       ESE_GZ_TX_DESC_TYPE_SEND;
+
+	} while (new_write_count != tx_queue->insert_count);
+
+	wmb(); /* Ensure descriptors are written before they are fetched */
+
+	tx_queue->write_count = new_write_count;
+
+	/* The write_count above must be updated before reading
+	 * channel->holdoff_doorbell to avoid a race with the
+	 * completion path, so ensure these operations are not
+	 * re-ordered.  This also flushes the update of write_count
+	 * back into the cache.
+	 */
+	smp_mb();
 }
 
 void ef100_tx_write(struct efx_tx_queue *tx_queue)
 {
+	ef100_tx_make_descriptors(tx_queue, NULL, 0);
+	ef100_tx_push_buffers(tx_queue);
+}
+
+void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
+{
+	unsigned int tx_done =
+		EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_TXCMPL_NUM_DESC);
+	unsigned int qlabel =
+		EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_TXCMPL_Q_LABEL);
+	struct efx_tx_queue *tx_queue =
+		efx_channel_get_tx_queue(channel, qlabel);
+	unsigned int tx_index = (tx_queue->read_count + tx_done - 1) &
+				tx_queue->ptr_mask;
+
+	efx_xmit_done(tx_queue, tx_index);
 }
 
 /* Add a socket buffer to a TX queue
@@ -42,10 +329,81 @@ void ef100_tx_write(struct efx_tx_queue *tx_queue)
  */
 int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 {
-	/* Stub.  No TX path yet. */
+	unsigned int old_insert_count = tx_queue->insert_count;
 	struct efx_nic *efx = tx_queue->efx;
+	bool xmit_more = netdev_xmit_more();
+	unsigned int fill_level;
+	unsigned int segments;
+	int rc;
+
+	if (!tx_queue->buffer || !tx_queue->ptr_mask) {
+		netif_stop_queue(efx->net_dev);
+		dev_kfree_skb_any(skb);
+		return -ENODEV;
+	}
+
+	segments = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 0;
+	if (segments == 1)
+		segments = 0;	/* Don't use TSO/GSO for a single segment. */
+	if (segments && !ef100_tx_can_tso(tx_queue, skb)) {
+		rc = efx_tx_tso_fallback(tx_queue, skb);
+		tx_queue->tso_fallbacks++;
+		if (rc)
+			goto err;
+		else
+			return 0;
+	}
+
+	/* Map for DMA and create descriptors */
+	rc = efx_tx_map_data(tx_queue, skb, segments);
+	if (rc)
+		goto err;
+	ef100_tx_make_descriptors(tx_queue, skb, segments);
+
+	fill_level = efx_channel_tx_fill_level(tx_queue->channel);
+	if (fill_level > efx->txq_stop_thresh) {
+		netif_tx_stop_queue(tx_queue->core_txq);
+		/* Re-read after a memory barrier in case we've raced with
+		 * the completion path. Otherwise there's a danger we'll never
+		 * restart the queue if all completions have just happened.
+		 */
+		smp_mb();
+		fill_level = efx_channel_tx_fill_level(tx_queue->channel);
+		if (fill_level < efx->txq_stop_thresh)
+			netif_tx_start_queue(tx_queue->core_txq);
+	}
+
+	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more))
+		tx_queue->xmit_more_available = false; /* push doorbell */
+	else if (tx_queue->write_count - tx_queue->notify_count > 255)
+		/* Ensure we never push more than 256 packets at once */
+		tx_queue->xmit_more_available = false; /* push */
+	else
+		tx_queue->xmit_more_available = true; /* don't push yet */
+
+	if (!tx_queue->xmit_more_available)
+		ef100_tx_push_buffers(tx_queue);
+
+	if (segments) {
+		tx_queue->tso_bursts++;
+		tx_queue->tso_packets += segments;
+		tx_queue->tx_packets  += segments;
+	} else {
+		tx_queue->tx_packets++;
+	}
+	return 0;
+
+err:
+	efx_enqueue_unwind(tx_queue, old_insert_count);
+	if (!IS_ERR_OR_NULL(skb))
+		dev_kfree_skb_any(skb);
 
-	netif_stop_queue(efx->net_dev);
-	dev_kfree_skb_any(skb);
-	return -ENODEV;
+	/* If we're not expecting another transmit and we had something to push
+	 * on this queue then we need to push here to get the previous packets
+	 * out.  We only enter this branch from before the 'Update BQL' section
+	 * above, so xmit_more_available still refers to the old state.
+	 */
+	if (tx_queue->xmit_more_available && !xmit_more)
+		ef100_tx_push_buffers(tx_queue);
+	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
index 9a472f7aff43..fa23e430bdd7 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.h
+++ b/drivers/net/ethernet/sfc/ef100_tx.h
@@ -17,6 +17,10 @@
 int ef100_tx_probe(struct efx_tx_queue *tx_queue);
 void ef100_tx_init(struct efx_tx_queue *tx_queue);
 void ef100_tx_write(struct efx_tx_queue *tx_queue);
+void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue);
+unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
+
+void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
 
 netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
 #endif
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9791fac0b649..7bb7ecb480ae 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -173,6 +173,7 @@ struct efx_tx_buffer {
 #define EFX_TX_BUF_MAP_SINGLE	8	/* buffer was mapped with dma_map_single() */
 #define EFX_TX_BUF_OPTION	0x10	/* empty buffer for option descriptor */
 #define EFX_TX_BUF_XDP		0x20	/* buffer was sent with XDP */
+#define EFX_TX_BUF_TSO_V3	0x40	/* empty buffer for a TSO_V3 descriptor */
 
 /**
  * struct efx_tx_queue - An Efx TX queue
@@ -245,6 +246,7 @@ struct efx_tx_buffer {
  * @pio_packets: Number of times the TX PIO feature has been used
  * @xmit_more_available: Are any packets waiting to be pushed to the NIC
  * @cb_packets: Number of times the TX copybreak feature has been used
+ * @notify_count: Count of notified descriptors to the NIC
  * @empty_read_count: If the completion path has seen the queue as empty
  *	and the transmission path has not yet checked this, the value of
  *	@read_count bitwise-added to %EFX_EMPTY_COUNT_VALID; otherwise 0.
@@ -292,6 +294,7 @@ struct efx_tx_queue {
 	unsigned int pio_packets;
 	bool xmit_more_available;
 	unsigned int cb_packets;
+	unsigned int notify_count;
 	/* Statistics to supplement MAC stats */
 	unsigned long tx_packets;
 
@@ -1669,6 +1672,24 @@ static inline void efx_xmit_hwtstamp_pending(struct sk_buff *skb)
 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 }
 
+/* Get the max fill level of the TX queues on this channel */
+static inline unsigned int
+efx_channel_tx_fill_level(struct efx_channel *channel)
+{
+	struct efx_tx_queue *tx_queue;
+	unsigned int fill_level = 0;
+
+	/* This function is currently only used by EF100, which maybe
+	 * could do something simpler and just compute the fill level
+	 * of the single TXQ that's really in use.
+	 */
+	efx_for_each_channel_tx_queue(tx_queue, channel)
+		fill_level = max(fill_level,
+				 tx_queue->insert_count - tx_queue->read_count);
+
+	return fill_level;
+}
+
 /* Get all supported features.
  * If a feature is not fixed, it is present in hw_features.
  * If a feature is fixed, it does not present in hw_features, but
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 11b64c609550..793e234819a8 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -71,6 +71,7 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 		  "initialising TX queue %d\n", tx_queue->queue);
 
 	tx_queue->insert_count = 0;
+	tx_queue->notify_count = 0;
 	tx_queue->write_count = 0;
 	tx_queue->packet_write_count = 0;
 	tx_queue->old_write_count = 0;

