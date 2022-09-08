Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F45B2924
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 00:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiIHWSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 18:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiIHWSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 18:18:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3A2E901A
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 15:18:38 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bq9so15710821wrb.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 15:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date;
        bh=Io8HQvun+BJ3o3R4VO3fCHq/OiGNwf0QkwbHY8RHtnU=;
        b=yb6/kOaSN+tLFACis2YqdQvA3fOhOIugtACQ7lgtuqoxMa83JsZcWjywhvMp6fIS6j
         KXddeMWY2ECOWtgXgE7ph3AQb2qW5EbTS6VetW2w1fM4y0mXyZFGoOx3eh3/VraVar7v
         MYOFwYqtP0DooD/PshmQXNnKmJMXvfnPbDD2SELYQ5rcXXTqeIT1lIJEZN3k321xnKPz
         sIG/a+fGbjDE5/J5fp573nAe5DpSeFibxg0/sYRv7p4fKDkNsHI2uFkdZj3peom4QOFp
         mx6Um0fmJVfI6ey6UPRV++S7kxoU3NmJxjTNpbbeWu9jszf+F/KS8cp4QjFFZPYjdG7U
         r4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:cc:date:message-id:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Io8HQvun+BJ3o3R4VO3fCHq/OiGNwf0QkwbHY8RHtnU=;
        b=Er77NbjfrY/LeUce4DxPQAZqkZJV9fuIYLUp+T9hvWZxELI0WGoV1xkK4FcPmT4Gzq
         VI7tySqGbA1vvrWf0fYkXqT0VQSPYvT/oslJqw/5v2v0drsxByzejPAkrBiqpOXq/PK9
         RBJ2732QlKcwDov9v7Dsd0sX0MesBIeQPsE0WF1HdGIl8UYyIHo+7PFRUfGmhlmmXQC1
         JPru85r153ea1lhpG2x1mfziAkHpFF+f25W/eVM1FZXuil67vW21arGgX2chWVPTHkxX
         qD8c88E/fqnC0F89wj9q6q5r/Q373eVNu/tEZy8r6Ys0hsSbo0p9vaaKXjgpcWd5IHwU
         gVXA==
X-Gm-Message-State: ACgBeo2RA+qx/q5XIEoJoyi1y4muFLp8DB33ucix9TSN6wyP/dvUYFUe
        xW/tgL1T1tfcHZ2rOf1EKpy7yXRvNjvS+Q==
X-Google-Smtp-Source: AA6agR7U4Yxpm5acYu+cNXfkLRuo+dhifClg+VK0guIAzROW/tZXlV0S9M+Zu54gtZ8yfIURJ96Xuw==
X-Received: by 2002:a05:6000:107:b0:228:df94:d6c1 with SMTP id o7-20020a056000010700b00228df94d6c1mr6163712wrx.541.1662675516717;
        Thu, 08 Sep 2022 15:18:36 -0700 (PDT)
Received: from smtpclient.apple ([2a02:6b61:b014:9045:9d1b:aad0:1a2a:2fe6])
        by smtp.gmail.com with ESMTPSA id n13-20020a5d51cd000000b00228d6bc8450sm304664wrv.108.2022.09.08.15.18.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Sep 2022 15:18:36 -0700 (PDT)
From:   Lasse Johnsen <lasse@timebeat.app>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc driver
Message-Id: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
Date:   Thu, 8 Sep 2022 23:18:35 +0100
Cc:     "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>,
        Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds 1-step functionality to the igc driver
1-step is only supported in L2 PTP
(... as the hardware can update the FCS, but not the UDP checksum on the =
fly..)

Signed-off-by: Lasse Johnsen <lasse@timebeat.app>
---
diff --git a/drivers/net/ethernet/intel/igc/igc.h =
b/drivers/net/ethernet/intel/igc/igc.h
index 1e7e707..70d9440 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -247,6 +247,8 @@ struct igc_adapter {
 		struct timespec64 start;
 		struct timespec64 period;
 	} perout[IGC_N_PEROUT];
+
+	bool onestep_discard;
 };
=20
 void igc_up(struct igc_adapter *adapter);
@@ -403,13 +405,14 @@ enum igc_state_t {
=20
 enum igc_tx_flags {
 	/* cmd_type flags */
-	IGC_TX_FLAGS_VLAN	=3D 0x01,
-	IGC_TX_FLAGS_TSO	=3D 0x02,
-	IGC_TX_FLAGS_TSTAMP	=3D 0x04,
+	IGC_TX_FLAGS_VLAN		=3D 0x01,
+	IGC_TX_FLAGS_TSO		=3D 0x02,
+	IGC_TX_FLAGS_TSTAMP		=3D 0x04,
+	IGC_TX_FLAGS_ONESTEP_SYNC	=3D 0x08,
=20
 	/* olinfo flags */
-	IGC_TX_FLAGS_IPV4	=3D 0x10,
-	IGC_TX_FLAGS_CSUM	=3D 0x20,
+	IGC_TX_FLAGS_IPV4		=3D 0x10,
+	IGC_TX_FLAGS_CSUM		=3D 0x20,
 };
=20
 enum igc_boards {
@@ -631,6 +634,7 @@ int igc_ptp_set_ts_config(struct net_device *netdev, =
struct ifreq *ifr);
 int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq =
*ifr);
 void igc_ptp_tx_hang(struct igc_adapter *adapter);
 void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts);
+bool igc_ptp_process_onestep(struct igc_adapter *adapter, struct =
sk_buff *skb);
=20
 #define igc_rx_pg_size(_ring) (PAGE_SIZE << igc_rx_pg_order(_ring))
=20
diff --git a/drivers/net/ethernet/intel/igc/igc_base.h =
b/drivers/net/ethernet/intel/igc/igc_base.h
index ce530f5..a7106b5 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.h
+++ b/drivers/net/ethernet/intel/igc/igc_base.h
@@ -31,6 +31,7 @@ struct igc_adv_tx_context_desc {
 };
=20
 /* Adv Transmit Descriptor Config Masks */
+#define IGC_ADVTXD_ONESTEP	0x00040000 /* IEEE1588 perform one-step =
*/
 #define IGC_ADVTXD_MAC_TSTAMP	0x00080000 /* IEEE1588 Timestamp packet =
*/
 #define IGC_ADVTXD_DTYP_CTXT	0x00200000 /* Advanced Context =
Descriptor */
 #define IGC_ADVTXD_DTYP_DATA	0x00300000 /* Advanced Data Descriptor =
*/
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c =
b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b..cba34ae 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1536,7 +1536,8 @@ static int igc_ethtool_get_ts_info(struct =
net_device *dev,
=20
 		info->tx_types =3D
 			BIT(HWTSTAMP_TX_OFF) |
-			BIT(HWTSTAMP_TX_ON);
+			BIT(HWTSTAMP_TX_ON) |
+			BIT(HWTSTAMP_TX_ONESTEP_SYNC);
=20
 		info->rx_filters =3D BIT(HWTSTAMP_FILTER_NONE);
 		info->rx_filters |=3D BIT(HWTSTAMP_FILTER_ALL);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c =
b/drivers/net/ethernet/intel/igc/igc_main.c
index a5ebee7..713da04 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1260,6 +1260,9 @@ static int igc_tx_map(struct igc_ring *tx_ring,
 	cmd_type |=3D size | IGC_TXD_DCMD;
 	tx_desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
=20
+	if (first->tx_flags & IGC_TX_FLAGS_ONESTEP_SYNC)
+		tx_desc->read.cmd_type_len |=3D IGC_ADVTXD_ONESTEP;
+
 	netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount);
=20
 	/* set the timestamp */
@@ -1452,12 +1455,19 @@ static netdev_tx_t igc_xmit_frame_ring(struct =
sk_buff *skb,
 		 * the other timer registers before skipping the
 		 * timestamping request.
 		 */
-		if (adapter->tstamp_config.tx_type =3D=3D HWTSTAMP_TX_ON =
&&
+
+		if (adapter->tstamp_config.tx_type >=3D HWTSTAMP_TX_ON =
&&
 		    !test_and_set_bit_lock(__IGC_PTP_TX_IN_PROGRESS,
 					   &adapter->state)) {
 			skb_shinfo(skb)->tx_flags |=3D =
SKBTX_IN_PROGRESS;
 			tx_flags |=3D IGC_TX_FLAGS_TSTAMP;
=20
+			if (adapter->tstamp_config.tx_type =3D=3D =
HWTSTAMP_TX_ONESTEP_SYNC &&
+			    igc_ptp_process_onestep(adapter, skb)) {
+				tx_flags |=3D IGC_TX_FLAGS_ONESTEP_SYNC;
+				adapter->onestep_discard =3D true;
+			}
+
 			adapter->ptp_tx_skb =3D skb_get(skb);
 			adapter->ptp_tx_start =3D jiffies;
 		} else {
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c =
b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 653e9f1..dc57339 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -21,6 +21,9 @@
 #define IGC_PTM_STAT_SLEEP		2
 #define IGC_PTM_STAT_TIMEOUT		100
=20
+#define IGC_PTP_TX_ONESTEP_L2_OFFSET		48
+#define IGC_PTP_TX_ONESTEP_L2_IN_VLAN_OFFSET	52
+
 /* SYSTIM read access for I225 */
 void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts)
 {
@@ -550,6 +553,35 @@ static void igc_ptp_enable_tx_timestamp(struct =
igc_adapter *adapter)
 	rd32(IGC_TXSTMPH);
 }
=20
+static void igc_ptp_update_1588_offset_in_tsynctxctl(struct igc_adapter =
*adapter, int ptp_class)
+{
+	struct igc_hw *hw =3D &adapter->hw;
+	u32 onestep_offset =3D (rd32(IGC_TSYNCTXCTL) & 0xFF00) >> 8;
+
+	if ((ptp_class & PTP_CLASS_VLAN) &&
+	    onestep_offset !=3D IGC_PTP_TX_ONESTEP_L2_IN_VLAN_OFFSET) {
+		wr32(IGC_TSYNCTXCTL, IGC_TSYNCTXCTL_ENABLED | =
IGC_TSYNCTXCTL_TXSYNSIG |
+				(IGC_PTP_TX_ONESTEP_L2_IN_VLAN_OFFSET << =
8));
+	} else if (!(ptp_class & PTP_CLASS_VLAN) &&
+		   onestep_offset !=3D IGC_PTP_TX_ONESTEP_L2_OFFSET) {
+		wr32(IGC_TSYNCTXCTL, IGC_TSYNCTXCTL_ENABLED | =
IGC_TSYNCTXCTL_TXSYNSIG |
+				(IGC_PTP_TX_ONESTEP_L2_OFFSET << 8));
+	}
+}
+
+bool igc_ptp_process_onestep(struct igc_adapter *adapter, struct =
sk_buff *skb)
+{
+	unsigned int ptp_class =3D ptp_classify_raw(skb);
+
+	if ((ptp_class & PTP_CLASS_L2) && (ptp_class & PTP_CLASS_V2)) {
+		if (ptp_msg_is_sync(skb, ptp_class)) {
+			=
igc_ptp_update_1588_offset_in_tsynctxctl(adapter, ptp_class);
+			return true;
+		}
+	}
+	return false;
+}
+
 /**
  * igc_ptp_set_timestamp_mode - setup hardware for timestamping
  * @adapter: networking device structure
@@ -564,6 +596,7 @@ static int igc_ptp_set_timestamp_mode(struct =
igc_adapter *adapter,
 	case HWTSTAMP_TX_OFF:
 		igc_ptp_disable_tx_timestamp(adapter);
 		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
 	case HWTSTAMP_TX_ON:
 		igc_ptp_enable_tx_timestamp(adapter);
 		break;
@@ -603,6 +636,9 @@ static void igc_ptp_tx_timeout(struct igc_adapter =
*adapter)
 {
 	struct igc_hw *hw =3D &adapter->hw;
=20
+	if (adapter->onestep_discard)
+		adapter->onestep_discard =3D false;
+
 	dev_kfree_skb_any(adapter->ptp_tx_skb);
 	adapter->ptp_tx_skb =3D NULL;
 	adapter->tx_hwtstamp_timeouts++;
@@ -671,16 +707,14 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter =
*adapter)
 	shhwtstamps.hwtstamp =3D
 		ktime_add_ns(shhwtstamps.hwtstamp, adjust);
=20
-	/* Clear the lock early before calling skb_tstamp_tx so that
-	 * applications are not woken up before the lock bit is clear. =
We use
-	 * a copy of the skb pointer to ensure other threads can't =
change it
-	 * while we're notifying the stack.
-	 */
+	if (adapter->onestep_discard)
+		adapter->onestep_discard =3D false;
+	else
+		skb_tstamp_tx(skb, &shhwtstamps);
+
 	adapter->ptp_tx_skb =3D NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
=20
-	/* Notify the stack and free the skb after we've unlocked */
-	skb_tstamp_tx(skb, &shhwtstamps);
 	dev_kfree_skb_any(skb);
 }
=20
@@ -959,6 +993,7 @@ void igc_ptp_init(struct igc_adapter *adapter)
=20
 	adapter->tstamp_config.rx_filter =3D HWTSTAMP_FILTER_NONE;
 	adapter->tstamp_config.tx_type =3D HWTSTAMP_TX_OFF;
+	adapter->onestep_discard =3D false;
=20
 	adapter->prev_ptp_time =3D =
ktime_to_timespec64(ktime_get_real());
 	adapter->ptp_reset_start =3D ktime_get();
--=20
2.37.3=
