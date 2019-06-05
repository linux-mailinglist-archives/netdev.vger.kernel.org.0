Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB2683668D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfFEVM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35462 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfFEVMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:23 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so268001qto.2
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLzaazMHvcijCpMcqbIMPQOAnCt6vLhhD70+49EGVDA=;
        b=Re3GvNpRFcqudFAD3s5uxqJDRhgRQgS5g2wXC/R+3pQDkAe9po3af5WcRVj9K+I4XW
         sSS8sN+SBfvIfrCboamg6KRmdxCY4EvGumGTUZIfLn5f4BjioIiHPXCgFu3KxerguijC
         uuIEM+I2KNQ07dQxPE5iQiKwel1W8lzLkNal+vUUaTKii7xT1kuZMt+NGEVhWHlwP2j5
         9ZFILQez1I/N1OD5u2V+AxIRT5sjLDEOtHDojJUaQleypAUWzsD5bYX/QP/SQyy8nn0F
         BJw1qLwt+aoiY0ZVX0gaKVprDSyimNVyYw+Fhs3KK1HI8n44dSuZGdhD/Xx0oKrr8xuP
         HYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLzaazMHvcijCpMcqbIMPQOAnCt6vLhhD70+49EGVDA=;
        b=Z8wY88t3j/IRHBYcduUB8oPWx8BuaF9ZwhDS8BieyupM0CzfgWYR3tq+w/2DclzMrF
         ln7MdHWMXYNAw+bFj1eXVubf7GeIEva6DoFxUmSO0ykix9aMUQ0H/gdYzy25GFkCpVOF
         +PCK/aznFGhS+wi2WFiCoFkVh759o9/0dH3CkYa1JahFA2vErrX7toi1PzriSe64DCAO
         uR/Yu2RMU1SvmTTW4MxJwv8zjQ+xUNXpaX2EOIU6R6DSr0fDnuGDWtc0xYY4IsUvhyA6
         CRvthbUYra3VVbHsdhMagBB/x/oM1V90xPDif40qMb2vuYpn5uCHonQTzK37sOZT3ICM
         hfIw==
X-Gm-Message-State: APjAAAVoJVzyxVPCFyVWufWuPh4j/aoNtfolUOxFbjs4OHfoAssrw1LH
        /VTJs1FOwW5MQzSgmEG5FVtKqw==
X-Google-Smtp-Source: APXvYqwNPPDmGkdE3lJnXQ5mJHa6AHAm3HtZUKOlNHipv0YRQHNLUmFYh9h/5KcIa2R5RVHlsRffMw==
X-Received: by 2002:ac8:2fa8:: with SMTP id l37mr35820064qta.358.1559769141791;
        Wed, 05 Jun 2019 14:12:21 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:21 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 13/13] nfp: tls: add basic statistics
Date:   Wed,  5 Jun 2019 14:11:43 -0700
Message-Id: <20190605211143.29689-14-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count TX TLS packets: successes, out of order, and dropped due to
missing record info.  Make sure the RX and TX completion statistics
don't share cache lines with TX ones as much as possible.  With TLS
stats they are no longer reasonably aligned.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/crypto/tls.c   |  6 +++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  | 23 ++++++++++++--
 .../ethernet/netronome/nfp/nfp_net_common.c   | 31 +++++++++++++++----
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 16 ++++++++--
 4 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 3e079c8469a2..c638223e9f60 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -324,9 +324,13 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 	reply = (void *)skb->data;
 	err = -be32_to_cpu(reply->error);
 	if (err) {
-		if (err != -ENOSPC)
+		if (err == -ENOSPC) {
+			if (!atomic_fetch_inc(&nn->ktls_no_space))
+				nn_info(nn, "HW TLS table full\n");
+		} else {
 			nn_dp_warn(&nn->dp,
 				   "failed to add TLS, FW replied: %d\n", err);
+		}
 		goto err_free_skb;
 	}
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 8c1639a83fd4..661fa5941b91 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -12,6 +12,7 @@
 #ifndef _NFP_NET_H_
 #define _NFP_NET_H_
 
+#include <linux/atomic.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
@@ -373,6 +374,11 @@ struct nfp_net_rx_ring {
  * @hw_csum_tx_inner:	 Counter of inner TX checksum offload requests
  * @tx_gather:	    Counter of packets with Gather DMA
  * @tx_lso:	    Counter of LSO packets sent
+ * @hw_tls_tx:	    Counter of TLS packets sent with crypto offloaded to HW
+ * @tls_tx_fallback:	Counter of TLS packets sent which had to be encrypted
+ *			by the fallback path because packets came out of order
+ * @tls_tx_no_fallback:	Counter of TLS packets not sent because the fallback
+ *			path could not encrypt them
  * @tx_errors:	    How many TX errors were encountered
  * @tx_busy:        How often was TX busy (no space)?
  * @rx_replace_buf_alloc_fail:	Counter of RX buffer allocation failures
@@ -410,21 +416,28 @@ struct nfp_net_r_vector {
 	u64 hw_csum_rx_inner_ok;
 	u64 hw_csum_rx_complete;
 
+	u64 hw_csum_rx_error;
+	u64 rx_replace_buf_alloc_fail;
+
 	struct nfp_net_tx_ring *xdp_ring;
 
 	struct u64_stats_sync tx_sync;
 	u64 tx_pkts;
 	u64 tx_bytes;
-	u64 hw_csum_tx;
+
+	u64 ____cacheline_aligned_in_smp hw_csum_tx;
 	u64 hw_csum_tx_inner;
 	u64 tx_gather;
 	u64 tx_lso;
+	u64 hw_tls_tx;
 
-	u64 hw_csum_rx_error;
-	u64 rx_replace_buf_alloc_fail;
+	u64 tls_tx_fallback;
+	u64 tls_tx_no_fallback;
 	u64 tx_errors;
 	u64 tx_busy;
 
+	/* Cold data follows */
+
 	u32 irq_vector;
 	irq_handler_t handler;
 	char name[IFNAMSIZ + 8];
@@ -566,6 +579,8 @@ struct nfp_net_dp {
  * @rx_bar:             Pointer to mapped FL/RX queues
  * @tlv_caps:		Parsed TLV capabilities
  * @ktls_tx_conn_cnt:	Number of offloaded kTLS TX connections
+ * @ktls_no_space:	Counter of firmware rejecting kTLS connection due to
+ *			lack of space
  * @mbox_cmsg:		Common Control Message via vNIC mailbox state
  * @mbox_cmsg.queue:	CCM mbox queue of pending messages
  * @mbox_cmsg.wq:	CCM mbox wait queue of waiting processes
@@ -647,6 +662,8 @@ struct nfp_net {
 
 	unsigned int ktls_tx_conn_cnt;
 
+	atomic_t ktls_no_space;
+
 	struct {
 		struct sk_buff_head queue;
 		wait_queue_head_t wq;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 52f20f191eed..e221847d9a3e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -804,8 +804,8 @@ static void nfp_net_tx_csum(struct nfp_net_dp *dp,
 
 #ifdef CONFIG_TLS_DEVICE
 static struct sk_buff *
-nfp_net_tls_tx(struct nfp_net_dp *dp, struct sk_buff *skb, u64 *tls_handle,
-	       int *nr_frags)
+nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+	       struct sk_buff *skb, u64 *tls_handle, int *nr_frags)
 {
 	struct nfp_net_tls_offload_ctx *ntls;
 	struct sk_buff *nskb;
@@ -824,15 +824,26 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct sk_buff *skb, u64 *tls_handle,
 		if (!datalen)
 			return skb;
 
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->tls_tx_fallback++;
+		u64_stats_update_end(&r_vec->tx_sync);
+
 		nskb = tls_encrypt_skb(skb);
-		if (!nskb)
+		if (!nskb) {
+			u64_stats_update_begin(&r_vec->tx_sync);
+			r_vec->tls_tx_no_fallback++;
+			u64_stats_update_end(&r_vec->tx_sync);
 			return NULL;
+		}
 		/* encryption wasn't necessary */
 		if (nskb == skb)
 			return skb;
 		/* we don't re-check ring space */
 		if (unlikely(skb_is_nonlinear(nskb))) {
 			nn_dp_warn(dp, "tls_encrypt_skb() produced fragmented frame\n");
+			u64_stats_update_begin(&r_vec->tx_sync);
+			r_vec->tx_errors++;
+			u64_stats_update_end(&r_vec->tx_sync);
 			dev_kfree_skb_any(nskb);
 			return NULL;
 		}
@@ -845,6 +856,12 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct sk_buff *skb, u64 *tls_handle,
 		return nskb;
 	}
 
+	if (datalen) {
+		u64_stats_update_begin(&r_vec->tx_sync);
+		r_vec->hw_tls_tx++;
+		u64_stats_update_end(&r_vec->tx_sync);
+	}
+
 	memcpy(tls_handle, ntls->fw_handle, sizeof(ntls->fw_handle));
 	ntls->next_seq += datalen;
 	return skb;
@@ -944,9 +961,11 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 #ifdef CONFIG_TLS_DEVICE
-	skb = nfp_net_tls_tx(dp, skb, &tls_handle, &nr_frags);
-	if (unlikely(!skb))
-		goto err_flush;
+	skb = nfp_net_tls_tx(dp, r_vec, skb, &tls_handle, &nr_frags);
+	if (unlikely(!skb)) {
+		nfp_net_tx_xmit_more_flush(tx_ring);
+		return NETDEV_TX_OK;
+	}
 #endif
 
 	md_bytes = nfp_net_prep_tx_meta(skb, tls_handle);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 851e31e0ba8e..3a8e1af7042d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -150,8 +150,9 @@ static const struct nfp_et_stat nfp_mac_et_stats[] = {
 
 #define NN_ET_GLOBAL_STATS_LEN ARRAY_SIZE(nfp_net_et_stats)
 #define NN_ET_SWITCH_STATS_LEN 9
-#define NN_RVEC_GATHER_STATS	9
+#define NN_RVEC_GATHER_STATS	12
 #define NN_RVEC_PER_Q_STATS	3
+#define NN_CTRL_PATH_STATS	1
 
 #define SFP_SFF_REV_COMPLIANCE	1
 
@@ -423,7 +424,8 @@ static unsigned int nfp_vnic_get_sw_stats_count(struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 
-	return NN_RVEC_GATHER_STATS + nn->max_r_vecs * NN_RVEC_PER_Q_STATS;
+	return NN_RVEC_GATHER_STATS + nn->max_r_vecs * NN_RVEC_PER_Q_STATS +
+		NN_CTRL_PATH_STATS;
 }
 
 static u8 *nfp_vnic_get_sw_stats_strings(struct net_device *netdev, u8 *data)
@@ -446,6 +448,11 @@ static u8 *nfp_vnic_get_sw_stats_strings(struct net_device *netdev, u8 *data)
 	data = nfp_pr_et(data, "hw_tx_inner_csum");
 	data = nfp_pr_et(data, "tx_gather");
 	data = nfp_pr_et(data, "tx_lso");
+	data = nfp_pr_et(data, "tx_tls_encrypted");
+	data = nfp_pr_et(data, "tx_tls_ooo");
+	data = nfp_pr_et(data, "tx_tls_drop_no_sync_data");
+
+	data = nfp_pr_et(data, "hw_tls_no_space");
 
 	return data;
 }
@@ -478,6 +485,9 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 			tmp[6] = nn->r_vecs[i].hw_csum_tx_inner;
 			tmp[7] = nn->r_vecs[i].tx_gather;
 			tmp[8] = nn->r_vecs[i].tx_lso;
+			tmp[9] = nn->r_vecs[i].hw_tls_tx;
+			tmp[10] = nn->r_vecs[i].tls_tx_fallback;
+			tmp[11] = nn->r_vecs[i].tls_tx_no_fallback;
 		} while (u64_stats_fetch_retry(&nn->r_vecs[i].tx_sync, start));
 
 		data += NN_RVEC_PER_Q_STATS;
@@ -489,6 +499,8 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 	for (j = 0; j < NN_RVEC_GATHER_STATS; j++)
 		*data++ = gathered_stats[j];
 
+	*data++ = atomic_read(&nn->ktls_no_space);
+
 	return data;
 }
 
-- 
2.21.0

