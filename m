Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1892EE8DB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbhAGWii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAGWii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 17:38:38 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CF6C0612F4;
        Thu,  7 Jan 2021 14:37:57 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 3so6838798wmg.4;
        Thu, 07 Jan 2021 14:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5NWCqyWxrgJ9mwYBzsd5FnhwT4mcrOvckByJF+b0Cw=;
        b=QhW+pOB+MXQXTdemZ/3/ZODuIhfZiR7UgRUEExoHfpZ6O/v1f+ATphb0KkOptstotR
         11ZUwLhOF/OMAUe8Iz+XvOtxG/D1u0ISispr2VAvTw6r6WGRGhLOFHyfKz+Jk+Hoej8u
         B45+wKuy5ZE9M2QFA+h3DFm0K+epbnu3Fb64riR8zRtkEbm76fEinvMuAEHnDnIeI6/R
         zmFq+TPZlWWNJuQ+u0ig2GgMHOVWzb6locmi1XwMRii1p72pRXAq5e/52mqF+pWv2Fis
         lFHLqOZeOV8VNHOm3R3YZ6SF5oyvzWx1wmflhuUlt5xrjYrG7WdkEgxsuTty6g0xl7VJ
         GJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5NWCqyWxrgJ9mwYBzsd5FnhwT4mcrOvckByJF+b0Cw=;
        b=LXpM5cKBRJHgSRXidNsTP70eA4KlD7bfSjb6v8Q5ssFZENvevkHzuavv+bscjWaRJj
         iB94T53r7/BDTZJ9nWdipNvv4SouJTN3JGPWKgI5UNx6khcN5EZNCkVTmvsdnTZPIKyh
         iQF8Hjew/ABgaju3ffJMyc96Y+4DikH//aXpVElx8hTQWOmykYLb+0pSR7nO9+cfqjYV
         ik4LToENtdu+Kx3OnfzeliDnw10ZPjgYFGYvqgQ2E8RS8UCPKlkiq6M6a/EWiBuu0z9m
         PNvStLeC+jOCmZTwzQJcukjzb0t08UCQmYilEhRpLmEdJvFg0lWWXxjgUF08v+u7+8Bu
         fiqw==
X-Gm-Message-State: AOAM531oEc4Zgq87EvzTxxLFU62lOl2mU70ixmNEaadNisdB9g8CeBza
        +PuN9WaLFAYEM6HXj2H65d1Q3JDEdtwKoey8
X-Google-Smtp-Source: ABdhPJymJiyHBIAA4sKbf1fuAR2JxtRrXMs99NWfyR/H6W64L5tTKiHroxhHBx4rdHf+SWh4kDr80g==
X-Received: by 2002:a1c:6a02:: with SMTP id f2mr583854wmc.36.1610059075972;
        Thu, 07 Jan 2021 14:37:55 -0800 (PST)
Received: from localhost.localdomain (host-80-116-1-51.retail.telecomitalia.it. [80.116.1.51])
        by smtp.gmail.com with ESMTPSA id i9sm10836580wrs.70.2021.01.07.14.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:37:55 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] hv_netvsc: Add (more) validation for untrusted Hyper-V values
Date:   Thu,  7 Jan 2021 23:37:23 +0100
Message-Id: <20210107223723.285653-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For additional robustness in the face of Hyper-V errors or malicious
behavior, validate all values that originate from packets that Hyper-V
has sent to the guest.  Ensure that invalid values cannot cause indexing
off the end of an array, or subvert an existing validation via integer
overflow.  Ensure that outgoing packets do not have any leftover guest
memory that has not been zeroed out.

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
---
 drivers/net/hyperv/netvsc.c       |   3 +-
 drivers/net/hyperv/netvsc_bpf.c   |   6 ++
 drivers/net/hyperv/netvsc_drv.c   |  16 ++-
 drivers/net/hyperv/rndis_filter.c | 167 +++++++++++++++++++-----------
 4 files changed, 130 insertions(+), 62 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1510a236aa341..d9324961e0d64 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -887,6 +887,7 @@ static inline int netvsc_send_pkt(
 	int ret;
 	u32 ring_avail = hv_get_avail_to_write_percent(&out_channel->outbound);
 
+	memset(&nvmsg, 0, sizeof(struct nvsp_message));
 	nvmsg.hdr.msg_type = NVSP_MSG1_TYPE_SEND_RNDIS_PKT;
 	if (skb)
 		rpkt->channel_type = 0;		/* 0 is RMC_DATA */
@@ -1306,7 +1307,7 @@ static void netvsc_send_table(struct net_device *ndev,
 			 sizeof(union nvsp_6_message_uber);
 
 	/* Boundary check for all versions */
-	if (offset > msglen - count * sizeof(u32)) {
+	if (msglen < count * sizeof(u32) || offset > msglen - count * sizeof(u32)) {
 		netdev_err(ndev, "Received send-table offset too big:%u\n",
 			   offset);
 		return;
diff --git a/drivers/net/hyperv/netvsc_bpf.c b/drivers/net/hyperv/netvsc_bpf.c
index 440486d9c999e..11f0588a88843 100644
--- a/drivers/net/hyperv/netvsc_bpf.c
+++ b/drivers/net/hyperv/netvsc_bpf.c
@@ -37,6 +37,12 @@ u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel *nvchan,
 	if (!prog)
 		goto out;
 
+	/* Ensure that the below memcpy() won't overflow the page buffer. */
+	if (len > ndev->mtu + ETH_HLEN) {
+		act = XDP_DROP;
+		goto out;
+	}
+
 	/* allocate page buffer for data */
 	page = alloc_page(GFP_ATOMIC);
 	if (!page) {
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f32f28311d573..ef3ad66d927a8 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -760,6 +760,16 @@ void netvsc_linkstatus_callback(struct net_device *net,
 	if (indicate->status == RNDIS_STATUS_LINK_SPEED_CHANGE) {
 		u32 speed;
 
+		/* Validate status_buf_offset */
+		if (indicate->status_buflen < sizeof(speed) ||
+		    indicate->status_buf_offset < sizeof(*indicate) ||
+		    resp->msg_len - RNDIS_HEADER_SIZE < indicate->status_buf_offset ||
+		    resp->msg_len - RNDIS_HEADER_SIZE - indicate->status_buf_offset
+				< indicate->status_buflen) {
+			netdev_err(net, "invalid rndis_indicate_status packet\n");
+			return;
+		}
+
 		speed = *(u32 *)((void *)indicate
 				 + indicate->status_buf_offset) / 10000;
 		ndev_ctx->speed = speed;
@@ -865,8 +875,12 @@ static struct sk_buff *netvsc_alloc_recv_skb(struct net_device *net,
 	 */
 	if (csum_info && csum_info->receive.ip_checksum_value_invalid &&
 	    csum_info->receive.ip_checksum_succeeded &&
-	    skb->protocol == htons(ETH_P_IP))
+	    skb->protocol == htons(ETH_P_IP)) {
+		/* Check that there is enough space to hold the IP header. */
+		if (skb_headlen(skb) < sizeof(struct iphdr))
+			return NULL;
 		netvsc_comp_ipcsum(skb);
+	}
 
 	/* Do L4 checksum offload if enabled and present. */
 	if (csum_info && (net->features & NETIF_F_RXCSUM)) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 7e6dee2f02a43..99c146f6a9d6f 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -131,66 +131,84 @@ static void dump_rndis_message(struct net_device *netdev,
 {
 	switch (rndis_msg->ndis_msg_type) {
 	case RNDIS_MSG_PACKET:
-		netdev_dbg(netdev, "RNDIS_MSG_PACKET (len %u, "
-			   "data offset %u data len %u, # oob %u, "
-			   "oob offset %u, oob len %u, pkt offset %u, "
-			   "pkt len %u\n",
-			   rndis_msg->msg_len,
-			   rndis_msg->msg.pkt.data_offset,
-			   rndis_msg->msg.pkt.data_len,
-			   rndis_msg->msg.pkt.num_oob_data_elements,
-			   rndis_msg->msg.pkt.oob_data_offset,
-			   rndis_msg->msg.pkt.oob_data_len,
-			   rndis_msg->msg.pkt.per_pkt_info_offset,
-			   rndis_msg->msg.pkt.per_pkt_info_len);
+		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >= sizeof(struct rndis_packet)) {
+			const struct rndis_packet *pkt = &rndis_msg->msg.pkt;
+			netdev_dbg(netdev, "RNDIS_MSG_PACKET (len %u, "
+				   "data offset %u data len %u, # oob %u, "
+				   "oob offset %u, oob len %u, pkt offset %u, "
+				   "pkt len %u\n",
+				   rndis_msg->msg_len,
+				   pkt->data_offset,
+				   pkt->data_len,
+				   pkt->num_oob_data_elements,
+				   pkt->oob_data_offset,
+				   pkt->oob_data_len,
+				   pkt->per_pkt_info_offset,
+				   pkt->per_pkt_info_len);
+		}
 		break;
 
 	case RNDIS_MSG_INIT_C:
-		netdev_dbg(netdev, "RNDIS_MSG_INIT_C "
-			"(len %u, id 0x%x, status 0x%x, major %d, minor %d, "
-			"device flags %d, max xfer size 0x%x, max pkts %u, "
-			"pkt aligned %u)\n",
-			rndis_msg->msg_len,
-			rndis_msg->msg.init_complete.req_id,
-			rndis_msg->msg.init_complete.status,
-			rndis_msg->msg.init_complete.major_ver,
-			rndis_msg->msg.init_complete.minor_ver,
-			rndis_msg->msg.init_complete.dev_flags,
-			rndis_msg->msg.init_complete.max_xfer_size,
-			rndis_msg->msg.init_complete.
-			   max_pkt_per_msg,
-			rndis_msg->msg.init_complete.
-			   pkt_alignment_factor);
+		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >=
+				sizeof(struct rndis_initialize_complete)) {
+			const struct rndis_initialize_complete *init_complete =
+				&rndis_msg->msg.init_complete;
+			netdev_dbg(netdev, "RNDIS_MSG_INIT_C "
+				"(len %u, id 0x%x, status 0x%x, major %d, minor %d, "
+				"device flags %d, max xfer size 0x%x, max pkts %u, "
+				"pkt aligned %u)\n",
+				rndis_msg->msg_len,
+				init_complete->req_id,
+				init_complete->status,
+				init_complete->major_ver,
+				init_complete->minor_ver,
+				init_complete->dev_flags,
+				init_complete->max_xfer_size,
+				init_complete->max_pkt_per_msg,
+				init_complete->pkt_alignment_factor);
+		}
 		break;
 
 	case RNDIS_MSG_QUERY_C:
-		netdev_dbg(netdev, "RNDIS_MSG_QUERY_C "
-			"(len %u, id 0x%x, status 0x%x, buf len %u, "
-			"buf offset %u)\n",
-			rndis_msg->msg_len,
-			rndis_msg->msg.query_complete.req_id,
-			rndis_msg->msg.query_complete.status,
-			rndis_msg->msg.query_complete.
-			   info_buflen,
-			rndis_msg->msg.query_complete.
-			   info_buf_offset);
+		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >=
+				sizeof(struct rndis_query_complete)) {
+			const struct rndis_query_complete *query_complete =
+				&rndis_msg->msg.query_complete;
+			netdev_dbg(netdev, "RNDIS_MSG_QUERY_C "
+				"(len %u, id 0x%x, status 0x%x, buf len %u, "
+				"buf offset %u)\n",
+				rndis_msg->msg_len,
+				query_complete->req_id,
+				query_complete->status,
+				query_complete->info_buflen,
+				query_complete->info_buf_offset);
+		}
 		break;
 
 	case RNDIS_MSG_SET_C:
-		netdev_dbg(netdev,
-			"RNDIS_MSG_SET_C (len %u, id 0x%x, status 0x%x)\n",
-			rndis_msg->msg_len,
-			rndis_msg->msg.set_complete.req_id,
-			rndis_msg->msg.set_complete.status);
+		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE + sizeof(struct rndis_set_complete)) {
+			const struct rndis_set_complete *set_complete =
+				&rndis_msg->msg.set_complete;
+			netdev_dbg(netdev,
+				"RNDIS_MSG_SET_C (len %u, id 0x%x, status 0x%x)\n",
+				rndis_msg->msg_len,
+				set_complete->req_id,
+				set_complete->status);
+		}
 		break;
 
 	case RNDIS_MSG_INDICATE:
-		netdev_dbg(netdev, "RNDIS_MSG_INDICATE "
-			"(len %u, status 0x%x, buf len %u, buf offset %u)\n",
-			rndis_msg->msg_len,
-			rndis_msg->msg.indicate_status.status,
-			rndis_msg->msg.indicate_status.status_buflen,
-			rndis_msg->msg.indicate_status.status_buf_offset);
+		if (rndis_msg->msg_len - RNDIS_HEADER_SIZE >=
+				sizeof(struct rndis_indicate_status)) {
+			const struct rndis_indicate_status *indicate_status =
+				&rndis_msg->msg.indicate_status;
+			netdev_dbg(netdev, "RNDIS_MSG_INDICATE "
+				"(len %u, status 0x%x, buf len %u, buf offset %u)\n",
+				rndis_msg->msg_len,
+				indicate_status->status,
+				indicate_status->status_buflen,
+				indicate_status->status_buf_offset);
+		}
 		break;
 
 	default:
@@ -246,11 +264,19 @@ static void rndis_set_link_state(struct rndis_device *rdev,
 {
 	u32 link_status;
 	struct rndis_query_complete *query_complete;
+	u32 msg_len = msg_len = request->response_msg.msg_len;
+
+	/* Ensure the packet is big enough to access its fields */
+	if (msg_len - RNDIS_HEADER_SIZE < sizeof(struct rndis_query_complete))
+		return;
 
 	query_complete = &request->response_msg.msg.query_complete;
 
 	if (query_complete->status == RNDIS_STATUS_SUCCESS &&
-	    query_complete->info_buflen == sizeof(u32)) {
+	    query_complete->info_buflen >= sizeof(u32) &&
+	    msg_len - RNDIS_HEADER_SIZE >= query_complete->info_buf_offset &&
+	    msg_len - RNDIS_HEADER_SIZE - query_complete->info_buf_offset
+			>= query_complete->info_buflen) {
 		memcpy(&link_status, (void *)((unsigned long)query_complete +
 		       query_complete->info_buf_offset), sizeof(u32));
 		rdev->link_state = link_status != 0;
@@ -343,7 +369,8 @@ static void rndis_filter_receive_response(struct net_device *ndev,
  */
 static inline void *rndis_get_ppi(struct net_device *ndev,
 				  struct rndis_packet *rpkt,
-				  u32 rpkt_len, u32 type, u8 internal)
+				  u32 rpkt_len, u32 type, u8 internal,
+				  u32 ppi_size)
 {
 	struct rndis_per_packet_info *ppi;
 	int len;
@@ -359,7 +386,8 @@ static inline void *rndis_get_ppi(struct net_device *ndev,
 		return NULL;
 	}
 
-	if (rpkt->per_pkt_info_len > rpkt_len - rpkt->per_pkt_info_offset) {
+	if (rpkt->per_pkt_info_len < sizeof(*ppi) ||
+	    rpkt->per_pkt_info_len > rpkt_len - rpkt->per_pkt_info_offset) {
 		netdev_err(ndev, "Invalid per_pkt_info_len: %u\n",
 			   rpkt->per_pkt_info_len);
 		return NULL;
@@ -381,8 +409,12 @@ static inline void *rndis_get_ppi(struct net_device *ndev,
 			continue;
 		}
 
-		if (ppi->type == type && ppi->internal == internal)
+		if (ppi->type == type && ppi->internal == internal) {
+			/* ppi->size should be big enough to hold the returned object. */
+			if (ppi->size < ppi_size)
+				continue;
 			return (void *)((ulong)ppi + ppi->ppi_offset);
+		}
 		len -= ppi->size;
 		ppi = (struct rndis_per_packet_info *)((ulong)ppi + ppi->size);
 	}
@@ -461,13 +493,16 @@ static int rndis_filter_receive_data(struct net_device *ndev,
 		return NVSP_STAT_FAIL;
 	}
 
-	vlan = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, IEEE_8021Q_INFO, 0);
+	vlan = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, IEEE_8021Q_INFO, 0, sizeof(*vlan));
 
-	csum_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, TCPIP_CHKSUM_PKTINFO, 0);
+	csum_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, TCPIP_CHKSUM_PKTINFO, 0,
+				  sizeof(*csum_info));
 
-	hash_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, NBL_HASH_VALUE, 0);
+	hash_info = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, NBL_HASH_VALUE, 0,
+				  sizeof(*hash_info));
 
-	pktinfo_id = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, RNDIS_PKTINFO_ID, 1);
+	pktinfo_id = rndis_get_ppi(ndev, rndis_pkt, rpkt_len, RNDIS_PKTINFO_ID, 1,
+				   sizeof(*pktinfo_id));
 
 	data = (void *)msg + data_offset;
 
@@ -522,9 +557,6 @@ int rndis_filter_receive(struct net_device *ndev,
 	struct net_device_context *net_device_ctx = netdev_priv(ndev);
 	struct rndis_message *rndis_msg = data;
 
-	if (netif_msg_rx_status(net_device_ctx))
-		dump_rndis_message(ndev, rndis_msg);
-
 	/* Validate incoming rndis_message packet */
 	if (buflen < RNDIS_HEADER_SIZE || rndis_msg->msg_len < RNDIS_HEADER_SIZE ||
 	    buflen < rndis_msg->msg_len) {
@@ -533,6 +565,9 @@ int rndis_filter_receive(struct net_device *ndev,
 		return NVSP_STAT_FAIL;
 	}
 
+	if (netif_msg_rx_status(net_device_ctx))
+		dump_rndis_message(ndev, rndis_msg);
+
 	switch (rndis_msg->ndis_msg_type) {
 	case RNDIS_MSG_PACKET:
 		return rndis_filter_receive_data(ndev, net_dev, nvchan,
@@ -567,6 +602,7 @@ static int rndis_filter_query_device(struct rndis_device *dev,
 	u32 inresult_size = *result_size;
 	struct rndis_query_request *query;
 	struct rndis_query_complete *query_complete;
+	u32 msg_len;
 	int ret = 0;
 
 	if (!result)
@@ -634,8 +670,19 @@ static int rndis_filter_query_device(struct rndis_device *dev,
 
 	/* Copy the response back */
 	query_complete = &request->response_msg.msg.query_complete;
+	msg_len = request->response_msg.msg_len;
+
+	/* Ensure the packet is big enough to access its fields */
+	if (msg_len - RNDIS_HEADER_SIZE < sizeof(struct rndis_query_complete)) {
+		ret = -1;
+		goto cleanup;
+	}
 
-	if (query_complete->info_buflen > inresult_size) {
+	if (query_complete->info_buflen > inresult_size ||
+	    query_complete->info_buf_offset < sizeof(*query_complete) ||
+	    msg_len - RNDIS_HEADER_SIZE < query_complete->info_buf_offset ||
+	    msg_len - RNDIS_HEADER_SIZE - query_complete->info_buf_offset
+			< query_complete->info_buflen) {
 		ret = -1;
 		goto cleanup;
 	}
-- 
2.25.1

