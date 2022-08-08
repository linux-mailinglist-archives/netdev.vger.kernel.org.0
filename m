Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3874658D055
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 00:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244443AbiHHWwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 18:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243759AbiHHWwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 18:52:30 -0400
X-Greylist: delayed 826 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 08 Aug 2022 15:52:29 PDT
Received: from mx0b-000e8d01.pphosted.com (mx0b-000e8d01.pphosted.com [148.163.143.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1200FBCA6;
        Mon,  8 Aug 2022 15:52:28 -0700 (PDT)
Received: from pps.filterd (m0136174.ppops.net [127.0.0.1])
        by mx0b-000e8d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278LlsLN015670;
        Mon, 8 Aug 2022 15:38:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=selinc.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=sel1;
 bh=lws8IdHd72mZnmLENQ4B7BqE1udaUwwqs0KmlsmJSic=;
 b=kC3VNe2LJcYI8AtK+S/wZQE0B7V/q8Il6mbI14V/l4S9hdzkhyAm8I9ZS8I3JDPUJ3p7
 yAWCVBZR4CbdHc7ml/5x0rWmlkI8nAGb6rdgBlBwCNjqKE3aKqFuwJj9X9T9EyPz4/h8
 pKALRoWl8rcqM2xiAOZ4muKLtfej0wuTQJO3LZ5LpzTdE4ggdTYojkSGs+jKErYlg6My
 7pZESoM7VhOP72FfGsh2qnencW+ko8VxhFw1uDX7kkDVAA48PxuFFfXkdNCaAkKdMXFW
 8tjfhrkYQXj6AJXMAh3nYA/bXB2IsqHYYmlk+YDWQtxNjOHDF0J0LMR10dWE9B00HDx1 JA== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0b-000e8d01.pphosted.com (PPS) with ESMTPS id 3hsmqp1f9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Aug 2022 15:38:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDUYDqhECyGZhhkVEruLVBtY1VNlOJ+I0S0I3QtUJ7gz/GYxLuM6F+uN3wWx8PLHAR7shUMPUZnIGDWqF11DXwE/m1M7/04gBOD9W3l+E+ygKRQjOlCYEPX9X4ktKvnkkwm8JfYj5wkzznH6xFit3GUlfkHsV50xOlCk1rOtfT/h3GC91OkeveRb4vAicfUm1k4JhOjn5Y4wAzQ0xbH30eCUHdqTm/DM0rRxSP8cAq6M+I4cOu1cLB69VNpuzm2NJglMK9Cr6fq7slhGSfe8li8WOILcIqX5oWYMi7KqoXrKYlfTRG2FLQzquJ0FFUIMgM30pf+7/owaciTvBCPzYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lws8IdHd72mZnmLENQ4B7BqE1udaUwwqs0KmlsmJSic=;
 b=hI3zJPYLKZOpw+MABnoK7uLup5/Lxvw2J5JNov6XGRAy9947io0SG5RXipubXL5g7CWfdaKqETjgRSrdb+ZzfEWquPWbg6fjVR8HDAbhxRGwI/4KhQxsUokP9e4RBcvzpA9xOf74ne3I7Vn7l1ggpfkwdQXEyHA5ySFUlT3n2StGldxDJrne8HdesYcibLpnYHpuLXcuACVHFikm6e+wwCwm7WhlLDblKvJppIvKw35psked01B0aeaEE+7Ai9FOLbvoh2S+sl0TJRmXGEhlGmcJ79S3vJuipAe5SeH8RtTtux2L8kxXlsEdgw0DpkSa6UEYOP2DZy49/UYf+rOW5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 74.117.212.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=selinc.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=selinc.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=selinc.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lws8IdHd72mZnmLENQ4B7BqE1udaUwwqs0KmlsmJSic=;
 b=ghzOrUk0GDCacupQsCg1ra0f4Usk0ISFHAbrLVvTZ2Um+CnM02ukJoSaK3I1rJtd+ftUBUSTazsAh/rtZSI780Xb6qRg/u0Q/jT1JWlas56OX+ivHm3Jy8hRYHDO6uI0NJJXooZ03B/XMMPPTwfGhcWuAs1TzuLEaraoLt14AMttkIoMt8EFasPgCtb6oDvDs1dpEKpofL9SE3ZX/+CLBaDwWKn/cswEEas2ebWfmv4Uvad1wXPMw3bQhvupPj8NYO67xUEDuH/EICkV/lI6IhITOWa3EwVuN0Kz0q94YUdZPPNLJq4+PVhCuxQiOvSyvFXJrF6cvUIdQNnnx0za5Q==
Received: from SA1P222CA0047.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::20)
 by CO6PR22MB2531.namprd22.prod.outlook.com (2603:10b6:303:a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Mon, 8 Aug
 2022 22:38:26 +0000
Received: from SN1NAM02FT0046.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:2d0:cafe::86) by SA1P222CA0047.outlook.office365.com
 (2603:10b6:806:2d0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14 via Frontend
 Transport; Mon, 8 Aug 2022 22:38:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 74.117.212.83)
 smtp.mailfrom=selinc.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=selinc.com;
Received-SPF: Pass (protection.outlook.com: domain of selinc.com designates
 74.117.212.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=74.117.212.83; helo=email.selinc.com; pr=C
Received: from email.selinc.com (74.117.212.83) by
 SN1NAM02FT0046.mail.protection.outlook.com (10.97.5.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.17 via Frontend Transport; Mon, 8 Aug 2022 22:38:24 +0000
Received: from clayyagelx.ad.selinc.com (10.100.90.200) by
 wpul-exchange1.ad.selinc.com (10.53.14.24) with Microsoft SMTP Server id
 15.2.1118.9; Mon, 8 Aug 2022 15:38:23 -0700
Received: by clayyagelx.ad.selinc.com (sSMTP sendmail emulation); Mon, 08 Aug 2022 15:38:23 -0700
Date:   Mon, 8 Aug 2022 15:38:23 -0700
From:   Clayton Yager <Clayton_Yager@selinc.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Clayton Yager <clayton_yager@selinc.com>
Subject: [PATCH net] macsec: Fix traffic counters/statistics
Message-ID: <20220808223823.GA109769@clayyagelx.ad.selinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4a6347e-4da8-4ac0-173e-08da798eb4aa
X-MS-TrafficTypeDiagnostic: CO6PR22MB2531:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aG+XYOblwvaMkjRbGjWKCGEsGq2Kmh1T7LMdnnCgf3ixH4peRi8qc3YvkgMjtMCjdnjBVse64Z9jd7fMPNb9QdanNToLz/m/vE7ibB8wVfb9JSTcnqk93m2BGO8oSqOzPn3Ebo3UoZLK1jfOWuJdO9tuKf8IV0+XJIjlFZgYo8qOf+qeIXp7rNsxdeUB/JchvqJpW12XtbKFTMbue/wMuYI08Mz+ut3It4witx5jK+zG19GAtEi5LcLw7IXjpgu9/B3dclPdnzUV7JMn0rLHKkNQiZGQA7x2WwpBZASYRyzukHHwzfpCfw6IfCzNc8Y7mYKKi5ni7VlRPj9ToPGHWcVQov9Jswkgsy8CTkMN5GLpnBQqIsVqYQVw6hwtILexN7JPRRBgG4Cl6FEPaHQohDw/i6tnJuQYVi3bOs+FchuFgFmxQXtxz3tDoz2hO1awMr+MzadmVAVASuNz6A5VVFucoo2xZvazZtQueGtutUPU83TXr1OKqL2JpuviJDddm8TdWrVfYnhVsyN8WKTr3UV9kmkJ+8P96zEq7+tXwnw7REIFQybsery9mKjOR+DmYfXhhkAOwqgsCQhki5YXuGgEfbVI+1EHKK/MS+707UU1a7Cdxe/mi2F6aEDS7JRxiTDPU1DtVxZvpstjyfaFG0brPNE1DjMOMSF/ypuxJPZuYSL1tl36IxRfB30Yy4gwFgJFV5+NFcSB+CbVJZgz6l0kWau2wIPqU+LU4qdjaQvfa+pxb2Ib/Qxhf4P4dnp8VNYlIOY3vDYCBhmypCzbHidhA5MxDMDEwSzQ+qWdFMv2IliaM1+uSJ7ozq49b5J7
X-Forefront-Antispam-Report: CIP:74.117.212.83;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:email.selinc.com;PTR:wpul-exchange1.selinc.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(346002)(36840700001)(46966006)(40470700004)(336012)(41300700001)(426003)(47076005)(33656002)(2906002)(107886003)(1076003)(26005)(86362001)(82740400003)(40460700003)(40480700001)(356005)(83380400001)(7636003)(8936002)(82310400005)(36860700001)(5660300002)(186003)(8676002)(70586007)(4326008)(70206006)(54906003)(110136005)(478600001)(316002)(42186006);DIR:OUT;SFP:1101;
X-OriginatorOrg: selinc.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 22:38:24.8303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a6347e-4da8-4ac0-173e-08da798eb4aa
X-MS-Exchange-CrossTenant-Id: 12381f30-10fe-4e2c-aa3a-5e03ebeb59ec
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=12381f30-10fe-4e2c-aa3a-5e03ebeb59ec;Ip=[74.117.212.83];Helo=[email.selinc.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0046.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR22MB2531
X-Proofpoint-ORIG-GUID: JKmgorsnVA7AB67LGyJ6SyRDyRBD-hB2
X-Proofpoint-GUID: JKmgorsnVA7AB67LGyJ6SyRDyRBD-hB2
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1011 suspectscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080098
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OutOctetsProtected, OutOctetsEncrypted, InOctetsValidated, and
InOctetsDecrypted were incrementing by the total number of octets in frames
instead of by the number of octets of User Data in frames.

The Controlled Port statistics ifOutOctets and ifInOctets were incrementing
by the total number of octets instead of the number of octets of the MSDUs
plus octets of the destination and source MAC addresses.

The Controlled Port statistics ifInDiscards and ifInErrors were not
incrementing each time the counters they aggregate were.

The Controlled Port statistic ifInErrors was not included in the output of
macsec_get_stats64 so the value was not present in ip commands output.

The ReceiveSA counters InPktsNotValid, InPktsNotUsingSA, and InPktsUnusedSA
were not incrementing.

Signed-off-by: Clayton Yager <Clayton_Yager@selinc.com>
---
 drivers/net/macsec.c | 58 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f1683ce6b561..ee6087e7b2bf 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -162,6 +162,19 @@ static struct macsec_rx_sa *macsec_rxsa_get(struct macsec_rx_sa __rcu *ptr)
 	return sa;
 }
 
+static struct macsec_rx_sa *macsec_active_rxsa_get(struct macsec_rx_sc *rx_sc)
+{
+	struct macsec_rx_sa *sa = NULL;
+	int an;
+
+	for (an = 0; an < MACSEC_NUM_AN; an++)	{
+		sa = macsec_rxsa_get(rx_sc->sa[an]);
+		if (sa)
+			break;
+	}
+	return sa;
+}
+
 static void free_rx_sc_rcu(struct rcu_head *head)
 {
 	struct macsec_rx_sc *rx_sc = container_of(head, struct macsec_rx_sc, rcu_head);
@@ -500,18 +513,28 @@ static void macsec_encrypt_finish(struct sk_buff *skb, struct net_device *dev)
 	skb->protocol = eth_hdr(skb)->h_proto;
 }
 
+static unsigned int macsec_msdu_len(struct sk_buff *skb)
+{
+	struct macsec_dev *macsec = macsec_priv(skb->dev);
+	struct macsec_secy *secy = &macsec->secy;
+	bool sci_present = macsec_skb_cb(skb)->has_sci;
+
+	return skb->len - macsec_hdr_len(sci_present) - secy->icv_len;
+}
+
 static void macsec_count_tx(struct sk_buff *skb, struct macsec_tx_sc *tx_sc,
 			    struct macsec_tx_sa *tx_sa)
 {
+	unsigned int msdu_len = macsec_msdu_len(skb);
 	struct pcpu_tx_sc_stats *txsc_stats = this_cpu_ptr(tx_sc->stats);
 
 	u64_stats_update_begin(&txsc_stats->syncp);
 	if (tx_sc->encrypt) {
-		txsc_stats->stats.OutOctetsEncrypted += skb->len;
+		txsc_stats->stats.OutOctetsEncrypted += msdu_len;
 		txsc_stats->stats.OutPktsEncrypted++;
 		this_cpu_inc(tx_sa->stats->OutPktsEncrypted);
 	} else {
-		txsc_stats->stats.OutOctetsProtected += skb->len;
+		txsc_stats->stats.OutOctetsProtected += msdu_len;
 		txsc_stats->stats.OutPktsProtected++;
 		this_cpu_inc(tx_sa->stats->OutPktsProtected);
 	}
@@ -541,9 +564,10 @@ static void macsec_encrypt_done(struct crypto_async_request *base, int err)
 	aead_request_free(macsec_skb_cb(skb)->req);
 
 	rcu_read_lock_bh();
-	macsec_encrypt_finish(skb, dev);
 	macsec_count_tx(skb, &macsec->secy.tx_sc, macsec_skb_cb(skb)->tx_sa);
-	len = skb->len;
+	/* packet is encrypted/protected so tx_bytes must be calculated */
+	len = macsec_msdu_len(skb) + 2 * ETH_ALEN;
+	macsec_encrypt_finish(skb, dev);
 	ret = dev_queue_xmit(skb);
 	count_tx(dev, ret, len);
 	rcu_read_unlock_bh();
@@ -702,6 +726,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 
 	macsec_skb_cb(skb)->req = req;
 	macsec_skb_cb(skb)->tx_sa = tx_sa;
+	macsec_skb_cb(skb)->has_sci = sci_present;
 	aead_request_set_callback(req, 0, macsec_encrypt_done, skb);
 
 	dev_hold(skb->dev);
@@ -743,15 +768,17 @@ static bool macsec_post_decrypt(struct sk_buff *skb, struct macsec_secy *secy, u
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsLate++;
 		u64_stats_update_end(&rxsc_stats->syncp);
+		secy->netdev->stats.rx_dropped++;
 		return false;
 	}
 
 	if (secy->validate_frames != MACSEC_VALIDATE_DISABLED) {
+		unsigned int msdu_len = macsec_msdu_len(skb);
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		if (hdr->tci_an & MACSEC_TCI_E)
-			rxsc_stats->stats.InOctetsDecrypted += skb->len;
+			rxsc_stats->stats.InOctetsDecrypted += msdu_len;
 		else
-			rxsc_stats->stats.InOctetsValidated += skb->len;
+			rxsc_stats->stats.InOctetsValidated += msdu_len;
 		u64_stats_update_end(&rxsc_stats->syncp);
 	}
 
@@ -764,6 +791,8 @@ static bool macsec_post_decrypt(struct sk_buff *skb, struct macsec_secy *secy, u
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsNotValid++;
 			u64_stats_update_end(&rxsc_stats->syncp);
+			this_cpu_inc(rx_sa->stats->InPktsNotValid);
+			secy->netdev->stats.rx_errors++;
 			return false;
 		}
 
@@ -856,9 +885,9 @@ static void macsec_decrypt_done(struct crypto_async_request *base, int err)
 
 	macsec_finalize_skb(skb, macsec->secy.icv_len,
 			    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
+	len = skb->len;
 	macsec_reset_skb(skb, macsec->secy.netdev);
 
-	len = skb->len;
 	if (gro_cells_receive(&macsec->gro_cells, skb) == NET_RX_SUCCESS)
 		count_rx(dev, len);
 
@@ -1049,6 +1078,7 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoTag++;
 			u64_stats_update_end(&secy_stats->syncp);
+			macsec->secy.netdev->stats.rx_dropped++;
 			continue;
 		}
 
@@ -1158,6 +1188,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		u64_stats_update_begin(&secy_stats->syncp);
 		secy_stats->stats.InPktsBadTag++;
 		u64_stats_update_end(&secy_stats->syncp);
+		secy->netdev->stats.rx_errors++;
 		goto drop_nosa;
 	}
 
@@ -1168,11 +1199,15 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		/* If validateFrames is Strict or the C bit in the
 		 * SecTAG is set, discard
 		 */
+		struct macsec_rx_sa *active_rx_sa = macsec_active_rxsa_get(rx_sc);
 		if (hdr->tci_an & MACSEC_TCI_C ||
 		    secy->validate_frames == MACSEC_VALIDATE_STRICT) {
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsNotUsingSA++;
 			u64_stats_update_end(&rxsc_stats->syncp);
+			secy->netdev->stats.rx_errors++;
+			if (active_rx_sa)
+				this_cpu_inc(active_rx_sa->stats->InPktsNotUsingSA);
 			goto drop_nosa;
 		}
 
@@ -1182,6 +1217,8 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		u64_stats_update_begin(&rxsc_stats->syncp);
 		rxsc_stats->stats.InPktsUnusedSA++;
 		u64_stats_update_end(&rxsc_stats->syncp);
+		if (active_rx_sa)
+			this_cpu_inc(active_rx_sa->stats->InPktsUnusedSA);
 		goto deliver;
 	}
 
@@ -1202,6 +1239,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 			u64_stats_update_begin(&rxsc_stats->syncp);
 			rxsc_stats->stats.InPktsLate++;
 			u64_stats_update_end(&rxsc_stats->syncp);
+			macsec->secy.netdev->stats.rx_dropped++;
 			goto drop;
 		}
 	}
@@ -1230,6 +1268,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 deliver:
 	macsec_finalize_skb(skb, secy->icv_len,
 			    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
+	len = skb->len;
 	macsec_reset_skb(skb, secy->netdev);
 
 	if (rx_sa)
@@ -1237,7 +1276,6 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	macsec_rxsc_put(rx_sc);
 
 	skb_orphan(skb);
-	len = skb->len;
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, len);
@@ -1279,6 +1317,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoSCI++;
 			u64_stats_update_end(&secy_stats->syncp);
+			macsec->secy.netdev->stats.rx_errors++;
 			continue;
 		}
 
@@ -3404,6 +3443,7 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
+	len = skb->len;
 	skb = macsec_encrypt(skb, dev);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EINPROGRESS)
@@ -3414,7 +3454,6 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	macsec_count_tx(skb, &macsec->secy.tx_sc, macsec_skb_cb(skb)->tx_sa);
 
 	macsec_encrypt_finish(skb, dev);
-	len = skb->len;
 	ret = dev_queue_xmit(skb);
 	count_tx(dev, ret, len);
 	return ret;
@@ -3662,6 +3701,7 @@ static void macsec_get_stats64(struct net_device *dev,
 
 	s->rx_dropped = dev->stats.rx_dropped;
 	s->tx_dropped = dev->stats.tx_dropped;
+	s->rx_errors = dev->stats.rx_errors;
 }
 
 static int macsec_get_iflink(const struct net_device *dev)
-- 
2.25.1

