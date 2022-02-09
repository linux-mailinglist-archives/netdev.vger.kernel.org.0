Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6031E4AE993
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiBIFzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:55:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbiBIFwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:52:09 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894D9C0DE7DD;
        Tue,  8 Feb 2022 21:52:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3VlJRZpItdnLjRB0fDNyvMkR59NXSifn+rfNeVgZJ9H1oUVOfPNmO4mQCOnAo13zjSXqYUcLKczzpedKUXXm2qHhu0oW2t7aTw1NaUaZVBEqk/H9DcuTCZw5yOmj94uI6SBdSm53v8h3i7um9mw76BfiOmlrBGnioIzCE2kAUuQ8fo0PjU9N/G/cCYuKLxV/ORmQ+VLIqMZGS2kshBtCDxH09W/Ax2vF/MsvXr3QvUhiYN3LlPGxyYukIWFYlD+mAdkn7/zL0SmfHay0fAu017uIYf9HoDTh14K4NbFekn2wj3QlQdHtJnKaCt474rbt5BAYbR7GItnf4+m7oAE7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/42pygzw0MFmsY+dzOSKXxb2KF6S1/2jIhVpfijcaw=;
 b=gT29pNhxqt2/h1Kvxthqnt+HGC8Nep1gZWCQ+8P7hX+m7CTJiO9lFXeP42E9NISsiQbdbjQKOUAqLhBbJpMkm9lP3dIHdajqKuxfoBuQhLpuIptpxMRvguBoJ4FCM+K+EHdExNPDJywyMdUu2M096DJTl53zihOPIngyaqhsi/E0PVyEp47suawktrRte0eVuuXElA+j5mcT0mY1IPANDRBmG/saFsEyXYh9mwFb+VsYWMG1ZoasmWKsZwzQWHVfLcrcxnS+K06bqa9bLyk/RpYfhCFzdiRTnlww6nSvgs7d6E5WIm/9GTLXP8o+CqqBsLojggAB8mKraMnQDtng5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/42pygzw0MFmsY+dzOSKXxb2KF6S1/2jIhVpfijcaw=;
 b=M3mhl7HeQaLuDViEouCBVtpQNxiJEF5tUYWnwXDC1Bxo9RRfIZDZUoauAc/Q5NCevFYSWL4fp/YJtIlD1ondLiLRaruwGY+/USWRxqTxkMIvXK5SxudiDPMXUB20rL6zDsa5c4Pwfmho5KtSc77zJ2kMfY2LjGnXR+M6qFoKRHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PA4PR04MB7823.eurprd04.prod.outlook.com (2603:10a6:102:c1::14)
 by DB7PR04MB5002.eurprd04.prod.outlook.com (2603:10a6:10:19::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 05:50:29 +0000
Received: from PA4PR04MB7823.eurprd04.prod.outlook.com
 ([fe80::653b:a7f3:f5c9:b7a5]) by PA4PR04MB7823.eurprd04.prod.outlook.com
 ([fe80::653b:a7f3:f5c9:b7a5%5]) with mapi id 15.20.4951.018; Wed, 9 Feb 2022
 05:50:29 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, Po Liu <po.liu@nxp.com>
Subject: [v1,net-next 2/3] net:enetc: command BD ring data memory alloc as one function alone
Date:   Wed,  9 Feb 2022 13:49:28 +0800
Message-Id: <20220209054929.10266-2-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209054929.10266-1-po.liu@nxp.com>
References: <20220209054929.10266-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To PA4PR04MB7823.eurprd04.prod.outlook.com (2603:10a6:102:c1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09da3e5b-9813-48e4-40b6-08d9eb9013f4
X-MS-TrafficTypeDiagnostic: DB7PR04MB5002:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB50020973F97AB60B24502A4E922E9@DB7PR04MB5002.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXc+bJG1DmOTU/BnBmVm3N/IuLhaKu3QZ9RMpae9WSvRBhq6TF3mJ/98dSYgoUPyWgoRl3AP9yrp9xobIcGph9b3W9FmKIACQj3slX7VvFl1M9X/4hGqJg02eq5F9IP/hwcG5giQ4fQBYmyqZtxN/RpXDdzLvO6Cmz5zxNhFDey2vhkXzq3mRroDLKBWHcc6i99K6XRsnEkvcdr2q3fW+WiZmDSSXvSU+EH2XgDb+9o2KyQTU5Q9BROyDlYuevLjMzskhohqA54hNYtZ4BHPVPg04D+3sIEe34Jrg7RVOcLzP+sj1Qbb5fx5W9liIIaNtkPqnoqxVmBaMvosohwEIALCsXPhDQW76akyP9sS150iUNBHWpVgz9fNlhbZCs32kqrkxLQh41qvBqID2RclAv+Gsn73jnnPNgDSfvaAkH1OkL9Pvoq5Gm3/3u/vJn7zmU1JQzGrAYJnNMxROvtEQnHfXWRZ/Tlx4yDN19Re0iddEamKGn6SwemcMZOUvRkazpD6lG8T91gnkGLHDcugcI9ODgbqZSBkRni9JitqZ1VyA/NjDxs7lYpxe6Vz2wkmyxofdYmWW+fG7jEU4LeIeAgut2olB034VlptV/PC0Zw83ZzYd6ZKfRmlm/qfTs5hM4FDkuca9IKTsdhEhQPKaEAKTIJFX4YVaFlLkx9BpTCaYdWOPw0iNCcvz3eICIn3aM5gZ0syXIIT+4cXrc3LHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7823.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(4326008)(44832011)(316002)(6636002)(5660300002)(6512007)(26005)(6486002)(86362001)(6506007)(2906002)(2616005)(186003)(1076003)(66476007)(8936002)(66556008)(508600001)(66946007)(38100700002)(38350700002)(8676002)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5nSih9x/Y+KLjrt2ExPb6l8TnMT9uBId9aqSWcJoBYPAT/v78KwDV4NRCcj6?=
 =?us-ascii?Q?l4X2thv2MVlRSfIrRDR0ciJCUSUVD8Tj5/jxgKpXP98jomXkXTvkfXcMGjQz?=
 =?us-ascii?Q?FJm9gf/Mooj8H2W6T4wDLzI0MuYgDhCxSSL75VOUV69nnsCn1k3gKJ2SPUkV?=
 =?us-ascii?Q?bzlS/5QGfIigrrE1KqAvv36rr631xryMVcHADnjFOlzl6RQGLmDgGrbZVffA?=
 =?us-ascii?Q?33o9NEA6UiHveqRLD0wCkgdLthynpv9MD3wjpCh0pW/LKHMjtGroPhILT8cP?=
 =?us-ascii?Q?P822G+llQlpItqIWalblQCJIcsgIIz9o5aMrp12OF/TMCuzJ78uwYXJ2m1UZ?=
 =?us-ascii?Q?L3zHWfowYxDa07dbyYVbwRhZl3qBQgd58x3Swy8xdGZoJmGoRdUFK6jNq4ft?=
 =?us-ascii?Q?IfjtIZ29RjrIUryDp8q5YzDcDnLc4OuIrUxk/FoSEWGc2LOLviM/maYfE1fd?=
 =?us-ascii?Q?FLiUR5iDq31vAcG9/Of5CE3UgoCdvra/DVtUjDQUN4DAcjwwEngY6E8+r4Pj?=
 =?us-ascii?Q?CQd487Eed0zy6f0ESLbqvT03MdAuX2bezRqYMDEt2Uo6IGMlphemT20hxafO?=
 =?us-ascii?Q?2y6pG7hutyQIFM+e4s8HYhb1dwNlMtW3etzPWUtram8DDjCnphsgnB2IjCGd?=
 =?us-ascii?Q?zCiElKMTeGRLCA/+YoOX7SBG/MLR+lV4QTxc9nC6kim+fEjnB3AKA4/gtYfR?=
 =?us-ascii?Q?FjtJmPPgpvXY60uKjwdGHy8oxKo0jVtmVLBHb17qazu8cRrQNIy4JSMY/uQx?=
 =?us-ascii?Q?si87jEodb2AII7lFVJhrXmDLJ+thz0e5KgKcgVk3TOTApQe0hddViW4Sz02j?=
 =?us-ascii?Q?Tm6oOy9c6dGzX+nOL9IVtBJWd9I3WW3csi94Q35nDa58ZAy82c2VKXMGL+6C?=
 =?us-ascii?Q?yVzLk8wG1GRiEilqGsuje12VBt4KAxlrHkVKdLjNrL6U3rprzTFojeDoq7AA?=
 =?us-ascii?Q?rgoQME9OdKT9FiMGJq/mAMMgzI6ArbPssKoulzSVBlsBwga/tGP8DCDk5H5m?=
 =?us-ascii?Q?RrCowQZo2q/dYEm0tbdPQlV6ZYKPsRJBqx4GxexcULhtuN4mUFmsQMS4WJJa?=
 =?us-ascii?Q?gTNfGKkYwFgP7wuPXuqlyxV4S/MPbjgn0yDSIs3UVtHeWIx8oGFhKkdrRvRi?=
 =?us-ascii?Q?mkHgFKy/+xq5fZtKyjioodH/m3HY7H1Ib15VODcLYrzLtasptfyYcPhTTKn8?=
 =?us-ascii?Q?BFpkdcFlkLybNQNRPP9Z8DQnxNCMSF9RvRwyUCzm+/JSgpg4fnF/J2Q26g15?=
 =?us-ascii?Q?7LSVpZuWFmY/ikaOPB3af0X2m3rnbnIUInv33icsIKRIy2e07vmPDh+l5FEQ?=
 =?us-ascii?Q?S8gC4xwFud6DT3zmJqEKZcsBLS9lGsuOwDYU9FWhDOuGyvdCnXURePIGqVO1?=
 =?us-ascii?Q?5we/11KWmaF6ROf72nmP9RX0YyguG/DvWhd+NbdrS9x2P5uIX2jdFo0+UZXt?=
 =?us-ascii?Q?TQOj/2vP50xc8mPnma856kfSlAUYgIESg6asJADQtItW6SUjmGOTx2kysSSQ?=
 =?us-ascii?Q?z9lqmVRVdajifxnZ537cfrTkRhrqiVhqTkKG4MNC/4/mRD438nQp75i5wnYv?=
 =?us-ascii?Q?XDN1oSMkZXP9IuwFAdQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09da3e5b-9813-48e4-40b6-08d9eb9013f4
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7823.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 05:50:29.4259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8ST0t4TQnP0Cboya7VZS+6tZZH5hHgsShjnCKtNRJ4YHsEtgkH7IbVqnm9UTW/p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5002
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the CBDR data memory alloc standalone. It is convenient for
other part loading, for example the ENETC QOS part.

Reported-and-suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Po Liu <po.liu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h  | 38 +++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_cbdr.c | 41 +++++--------------
 2 files changed, 49 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index fb39e406b7fc..68d806dc3701 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -18,6 +18,8 @@
 #define ENETC_MAX_MTU		(ENETC_MAC_MAXFRM_SIZE - \
 				(ETH_FCS_LEN + ETH_HLEN + VLAN_HLEN))
 
+#define ENETC_CBD_DATA_MEM_ALIGN 64
+
 struct enetc_tx_swbd {
 	union {
 		struct sk_buff *skb;
@@ -415,6 +417,42 @@ int enetc_get_rss_table(struct enetc_si *si, u32 *table, int count);
 int enetc_set_rss_table(struct enetc_si *si, const u32 *table, int count);
 int enetc_send_cmd(struct enetc_si *si, struct enetc_cbd *cbd);
 
+static inline void *enetc_cbd_alloc_data_mem(struct enetc_si *si,
+					     struct enetc_cbd *cbd,
+					     int size, dma_addr_t *dma,
+					     void **data_align)
+{
+	struct enetc_cbdr *ring = &si->cbd_ring;
+	dma_addr_t dma_align;
+	void *data;
+
+	data = dma_alloc_coherent(ring->dma_dev,
+				  size + ENETC_CBD_DATA_MEM_ALIGN,
+				  dma, GFP_KERNEL);
+	if (!data) {
+		dev_err(ring->dma_dev, "CBD alloc data memory failed!\n");
+		return NULL;
+	}
+
+	dma_align = ALIGN(*dma, ENETC_CBD_DATA_MEM_ALIGN);
+	*data_align = PTR_ALIGN(data, ENETC_CBD_DATA_MEM_ALIGN);
+
+	cbd->addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd->addr[1] = cpu_to_le32(upper_32_bits(dma_align));
+	cbd->length = cpu_to_le16(size);
+
+	return data;
+}
+
+static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
+					   void *data, dma_addr_t *dma)
+{
+	struct enetc_cbdr *ring = &si->cbd_ring;
+
+	dma_free_coherent(ring->dma_dev, size + ENETC_CBD_DATA_MEM_ALIGN,
+			  data, *dma);
+}
+
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
index 073e56dcca4e..af68dc46a795 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -166,70 +166,55 @@ int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 	return enetc_send_cmd(si, &cbd);
 }
 
-#define RFSE_ALIGN	64
 /* Set entry in RFS table */
 int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
 		       int index)
 {
 	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd cbd = {.cmd = 0};
-	dma_addr_t dma, dma_align;
 	void *tmp, *tmp_align;
+	dma_addr_t dma;
 	int err;
 
 	/* fill up the "set" descriptor */
 	cbd.cmd = 0;
 	cbd.cls = 4;
 	cbd.index = cpu_to_le16(index);
-	cbd.length = cpu_to_le16(sizeof(*rfse));
 	cbd.opt[3] = cpu_to_le32(0); /* SI */
 
-	tmp = dma_alloc_coherent(ring->dma_dev, sizeof(*rfse) + RFSE_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(ring->dma_dev, "DMA mapping of RFS entry failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(si, &cbd, sizeof(*rfse),
+				       &dma, &tmp_align);
+	if (!tmp)
 		return -ENOMEM;
-	}
 
-	dma_align = ALIGN(dma, RFSE_ALIGN);
-	tmp_align = PTR_ALIGN(tmp, RFSE_ALIGN);
 	memcpy(tmp_align, rfse, sizeof(*rfse));
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
-
 	err = enetc_send_cmd(si, &cbd);
 	if (err)
 		dev_err(ring->dma_dev, "FS entry add failed (%d)!", err);
 
-	dma_free_coherent(ring->dma_dev, sizeof(*rfse) + RFSE_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(si, sizeof(*rfse), tmp, &dma);
 
 	return err;
 }
 
-#define RSSE_ALIGN	64
 static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 			       bool read)
 {
 	struct enetc_cbdr *ring = &si->cbd_ring;
 	struct enetc_cbd cbd = {.cmd = 0};
-	dma_addr_t dma, dma_align;
 	u8 *tmp, *tmp_align;
+	dma_addr_t dma;
 	int err, i;
 
-	if (count < RSSE_ALIGN)
+	if (count < ENETC_CBD_DATA_MEM_ALIGN)
 		/* HW only takes in a full 64 entry table */
 		return -EINVAL;
 
-	tmp = dma_alloc_coherent(ring->dma_dev, count + RSSE_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(ring->dma_dev, "DMA mapping of RSS table failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(si, &cbd, count,
+				       &dma, (void *)&tmp_align);
+	if (!tmp)
 		return -ENOMEM;
-	}
-	dma_align = ALIGN(dma, RSSE_ALIGN);
-	tmp_align = PTR_ALIGN(tmp, RSSE_ALIGN);
 
 	if (!read)
 		for (i = 0; i < count; i++)
@@ -238,10 +223,6 @@ static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 	/* fill up the descriptor */
 	cbd.cmd = read ? 2 : 1;
 	cbd.cls = 3;
-	cbd.length = cpu_to_le16(count);
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	err = enetc_send_cmd(si, &cbd);
 	if (err)
@@ -251,7 +232,7 @@ static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 		for (i = 0; i < count; i++)
 			table[i] = tmp_align[i];
 
-	dma_free_coherent(ring->dma_dev, count + RSSE_ALIGN, tmp, dma);
+	enetc_cbd_free_data_mem(si, count, tmp, &dma);
 
 	return err;
 }
-- 
2.17.1

