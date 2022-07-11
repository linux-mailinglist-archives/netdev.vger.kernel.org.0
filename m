Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE5456FE45
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiGKKHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiGKKHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:07:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959A5BB7DD
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:31:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFwxbCGtugPVKndYmz73Cuqcf2v265liSjLdyIs8ou6S/8A4dRmNskBJMmMJ8p/uNPmFT1yvPjchWnJOkRUl0R978kRnuFH0R4WFRsuWRThDdIjqJqvVr79yoGLJJcKRepJZjOeLZ6+ynDVJWz7lesHn7iHyHD9ymVejG9gwaFF0GT3aDm2lKdbEHuM6tHKvOmgJZrXhcQrxcApTBB6JWum/kVqXvXZfg0t/5CyIm+UTwmiT7yJ5binOmV/JclbwbJHiGrUDW/0cgiNmVpyq4bkGW3LgbCOR9eKb14LFGrZMGIqZiSFJ/STEhubHHSyS3RypGc0rLXyZbcUNcPqECg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcY80LX7yNrCD23+UDik/8VFtdElogI9HdP5+Mt6org=;
 b=UsRo+xeDXVUq1GWlW3vdeOcGTKXvYFhYpEeFFa66CEzn3mKt/Hi7fC5r8SQFSDAWYiRIOCQFqm8X+YiEXfeGsqPRwQ27Z1FXaPoYGf9eAtupj8BFZa9HC5qco0KW9ULRxXFLM+n7jllZFMpWoiYJ+uZnKGjPl+EyE0DhvYXY3dJjd+kbpcIUCX4iEyfGJ7FT767E6+qsTpLxWFOX2QmVkwXXDnv7/v2NTM+JutKBUmqnITFpUDpsrNN1Eeh40h7fQicS13quDqiszai5Pk9VR45Lxp7ymJa0ngS45dcBE9Uw6jZKyv2hyJ65QFrafAO1kbxu9olZsJacIxC2KOS4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcY80LX7yNrCD23+UDik/8VFtdElogI9HdP5+Mt6org=;
 b=jtk3xus1b/p1EhZBv8ZAEKlvpM+sQH77GYT7eKKD7TiXxSDEdcs3oO3GnSePoqETtTYeCqqUH0WEv3+Q2kZfITzHZFJrw1zu4eGTvzdbk3Y65/1+/hC02yl1+CjfWaImPbu+0W+p8XCQZ7LE5NC3fWCgaIQy/1i3xMWdIKV4twI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4892.namprd13.prod.outlook.com (2603:10b6:510:74::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.11; Mon, 11 Jul
 2022 09:31:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.016; Mon, 11 Jul 2022
 09:31:16 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>
Subject: [PATCH net-next] nfp: support TX VLAN ctag insert in NFDK
Date:   Mon, 11 Jul 2022 11:30:48 +0200
Message-Id: <20220711093048.1911698-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0028.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3924a26c-be04-423f-6d2f-08da63201a27
X-MS-TrafficTypeDiagnostic: PH0PR13MB4892:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0F5pCX4Gy7oMatfzP2p56eSajc0Bu6dl/i72I/0n+G69bJOz5MHblo9zZS0pSAXLfSgnSVKTvmwnFvIzZSWhWkHe/RxYCaNxikptYWBeovPwaAw9Bu+WcQrBFofK8kRd5/nd9/DrVIEoLBCaao0oib08Lwe3Pq+X8yuf/Yimr4M8191bG/Jtk1D2BD21vdyLepNGZcyt2EPS0hm5SC6eRUFJj/5LFtQO9sjc5jrdPycLWR8SJPWaltQgkbmYjmOKAUWgOxhi7yMwQGAbYCppujJ47qd+pxTQ56NnJ+fbHVrl28RfCFjvtJBeXd9mkgCnCdtBcpaZKA7EKNzVF5FY8SBKebb2uQ67oPshsOOFw1wXvEuACQb0cYgNDqilBI8jC0eV7EXb7s+lPxnJI0jdvXy9X/8KJ5kUavpmIC3QVOTQ1PdKQvmnmM7ItLug+S1F9qiNySYVprYvBP7HDQof8Ro6F77sfXgV3fCimSe1O+OwwROhBtenDNFhmWXL2abM++vOhSEOqSsw1CwwIiggBpzUWQGntl9N8JxNyMaA5yIymYJRQrjWSpMjRXWPRZSvm4qTTz0oS/fc81oBQr9almrW1DxVRYR7Lf5ioaCxXzbJT9c62GDfA0pV5y0SnKRKAmFOFZo3Se/Ai1iWi6YR5zBjkl6C2WAhXwYqnv1LqRTQgA3u1HdeFjKFqHpH/MuIlq1PUBbX5mJtbu4ooTY/fPWLXkGxtAryLBogVfSr3s3wLb8se3V6P8WyyDDm4sj7d+aTCdOCg0sWrIHWi5KTx035p36aEr+ttDjLg/lbEYbzSbZnh2tJIGSv4dAtmnhO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(396003)(39830400003)(136003)(1076003)(66946007)(8936002)(41300700001)(5660300002)(44832011)(8676002)(110136005)(66556008)(83380400001)(186003)(316002)(66476007)(107886003)(6666004)(2616005)(4326008)(6486002)(52116002)(36756003)(86362001)(38100700002)(478600001)(2906002)(6512007)(6506007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eXsnOJnn1UOxksX/rH+WVICE1HSk3nSX3+EC8M8nnuvK3V8aZQ9Gd+E6naqU?=
 =?us-ascii?Q?w7e3LsbTdyyZiPChwSpq9GUWWbkgsaKXh8oOghdZMARFzxgLlHFISa224mu2?=
 =?us-ascii?Q?jxVBNcT3I5r8tsaMalpkeSAmjxiOYwPPLc+K/sh0JG/5ipTDUlSj1NmNXcMO?=
 =?us-ascii?Q?OHKdlsbCXpJNrRPNBDzPDfAlRgNxI2dW9vig0Y+ZwHQs5Jej3S45VdQupkC+?=
 =?us-ascii?Q?OwErQv86LNbEFrXuh9hNIRxM4xpITxwyqAOvb7Okm+Rqq+2fpOTh2vi64qLu?=
 =?us-ascii?Q?VtoZPlccAUzgal8a632RwmIfnNlhVd4/7xdQ+W7UzuREoW1Z9PvPosYaqLm5?=
 =?us-ascii?Q?OXDgAsHxEJAFKqTnzKmqkgreiJKgSCW18KEuBe7rYbKnNGh32QPxb70z0Pbn?=
 =?us-ascii?Q?7BTkSPrQGJWodRxx1tfuQZnf6YDwVl6cmA2JSh+IsnEo56OmU/uhutL2dN/4?=
 =?us-ascii?Q?txHkfRwEoaaqJSN5y5oAMSINpcOKxVcXh0UjgCKFGD+k4L3MSawllRQNJE+E?=
 =?us-ascii?Q?IkrKM/BQfEPZ1HYFmCrdV7JOfkYT/8e1P5WL/jiq6z/W5HRjJ0TyJ4+xhAwO?=
 =?us-ascii?Q?F2nITm5Fe72KiJA0i2xzQOYuLtf6DPsN6/uHgJxVd3ZLsAZGlLS9hEJ0TJHB?=
 =?us-ascii?Q?udde0U/Co6kvqffrSEwJwaMqp+Lz0s3e5viQCvh4aUBiYT/DfKkcqtvLi2VW?=
 =?us-ascii?Q?XEMouM753k7kBfe9tBrHWkLJU1zHqYg/oZjjS+Z7fTKLCQ/YyZTPRVvV5PKx?=
 =?us-ascii?Q?IVDeAGX5nN9e/iicA3DPREcKqZxe1yUUm3ynccKEVVCbr+cHd21ts4eUGS1M?=
 =?us-ascii?Q?IYeUPmLUryqchsD1/qNT8g/7RHiHH8UFAJXiXX3xhdpr3bIHD6efZoasU0Rw?=
 =?us-ascii?Q?3mJOyKY754jxgjeQk/Ild+ZpLReltj9P0fwgAq9N3HFdBSdVlKNLALjQPfGw?=
 =?us-ascii?Q?+6Wjg7nPq5GzMsW5+uxOfcNNEiDoQ2GxtqhAaDdd3QD9cJFD5/d4loxycne+?=
 =?us-ascii?Q?sp8YpeX8UAK9H2BDMe6HaqrlY121C8CAhxkNk1EUEE9yFfyQnIvZBQbZFFmF?=
 =?us-ascii?Q?IJofAZGODiabFvl8N1em2XWgnJyfMGDqnUkSJCH9MZYIpjW8g5T2umNRi5Ya?=
 =?us-ascii?Q?0wrABUMmyhD13lJ7ViKS2wkOya1Hzub+dwyKJg6UMpbBzonhcGKUZqkxTJlm?=
 =?us-ascii?Q?l43DQxin5Vszm+9se67yEgctk5NqLUbCLL/YYB8XeAhGGaaVIJMIuxc2vmKH?=
 =?us-ascii?Q?qWhd5humWYZ+TVqbTSAkpBTwUpFBAt+EKZN+4XYONTMfJQLXs2FsuDk1mBG3?=
 =?us-ascii?Q?27D12RYhimyHzEmr700vLr/AvJ0N9nhHIuEROcZZaOmYPpZRfIWCcaeatZAT?=
 =?us-ascii?Q?sHfSDH5JPdlC7IbRrqfTyv4JUZe6ImXMYPA9nvjntQ5ztEYLjT6KJzc+JyOb?=
 =?us-ascii?Q?hoBHcmQsth0C1PJ61kTD5nV8UrK5Tq2xrENgrct99qcgoA2UrlwvVwwEV6w7?=
 =?us-ascii?Q?BgP+4QTj/WFqrR+ufmNAkmxJuRrMmGCyZRWuk/XxTpV/cAvtpX8ap8Ga3YI5?=
 =?us-ascii?Q?hlSgwAaecqrFh5kY80O99EbDNIZJbtXWPDTDdRD0xzsOsjAGH9RKPlpLYk6t?=
 =?us-ascii?Q?ir3yJitCKSioAGk0WS60ZASe4SsHDQnEjDcd5buyw560ugnEV494egxSJFck?=
 =?us-ascii?Q?TXlYnw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3924a26c-be04-423f-6d2f-08da63201a27
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:31:16.1033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwF0ZjabBGxa1lWLZzKQyDSbfyg0prGyipClP1Q5tE6GNZ3fgbnlB9kCgX/s3k0Zpz4322q/AaDTsF48+Olq+g/M7RF59hHhZ98J3B/D3xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4892
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Add support for TX VLAN ctag insert
which may be configured via ethtool.
e.g.
     # ethtool -K $DEV tx-vlan-offload on

The NIC supplies VLAN insert information as packet metadata.
The fields of this VLAN metadata including vlan_proto and vlan tag.

Configuration control bit NFP_NET_CFG_CTRL_TXVLAN_V2 is to
signal availability of ctag-insert features of the firmware.

NFDK is used to communicate via PCIE to NFP-3800 based NICs
while NFD3 is used for other NICs supported by the NFP driver.
This features is currently implemented only for NFD3 and
this patch adds support for it with NFDK.

Signed-off-by: Diana Wang <na.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  | 63 ++++++++++---------
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 3 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 0b4f550aa39d..fa1361de86e1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -169,49 +169,52 @@ nfp_nfdk_tx_maybe_close_block(struct nfp_net_tx_ring *tx_ring,
 	return 0;
 }
 
-static int nfp_nfdk_prep_port_id(struct sk_buff *skb)
+static int
+nfp_nfdk_prep_tx_meta(struct nfp_net_dp *dp, struct nfp_app *app,
+		      struct sk_buff *skb)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
 	unsigned char *data;
+	bool vlan_insert;
+	u32 meta_id = 0;
+	int md_bytes;
 
-	if (likely(!md_dst))
-		return 0;
-	if (unlikely(md_dst->type != METADATA_HW_PORT_MUX))
-		return 0;
-
-	if (unlikely(skb_cow_head(skb, sizeof(md_dst->u.port_info.port_id))))
-		return -ENOMEM;
-
-	data = skb_push(skb, sizeof(md_dst->u.port_info.port_id));
-	put_unaligned_be32(md_dst->u.port_info.port_id, data);
+	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
+		md_dst = NULL;
 
-	return sizeof(md_dst->u.port_info.port_id);
-}
+	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
 
-static int
-nfp_nfdk_prep_tx_meta(struct nfp_app *app, struct sk_buff *skb,
-		      struct nfp_net_r_vector *r_vec)
-{
-	unsigned char *data;
-	int res, md_bytes;
-	u32 meta_id = 0;
-
-	res = nfp_nfdk_prep_port_id(skb);
-	if (unlikely(res <= 0))
-		return res;
+	if (!(md_dst || vlan_insert))
+		return 0;
 
-	md_bytes = res;
-	meta_id = NFP_NET_META_PORTID;
+	md_bytes = sizeof(meta_id) +
+		   !!md_dst * NFP_NET_META_PORTID_SIZE +
+		   vlan_insert * NFP_NET_META_VLAN_SIZE;
 
-	if (unlikely(skb_cow_head(skb, sizeof(meta_id))))
+	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
 
-	md_bytes += sizeof(meta_id);
+	data = skb_push(skb, md_bytes) + md_bytes;
+	if (md_dst) {
+		data -= NFP_NET_META_PORTID_SIZE;
+		put_unaligned_be32(md_dst->u.port_info.port_id, data);
+		meta_id = NFP_NET_META_PORTID;
+	}
+	if (vlan_insert) {
+		data -= NFP_NET_META_VLAN_SIZE;
+		/* data type of skb->vlan_proto is __be16
+		 * so it fills metadata without calling put_unaligned_be16
+		 */
+		memcpy(data, &skb->vlan_proto, sizeof(skb->vlan_proto));
+		put_unaligned_be16(skb_vlan_tag_get(skb), data + sizeof(skb->vlan_proto));
+		meta_id <<= NFP_NET_META_FIELD_SIZE;
+		meta_id |= NFP_NET_META_VLAN;
+	}
 
 	meta_id = FIELD_PREP(NFDK_META_LEN, md_bytes) |
 		  FIELD_PREP(NFDK_META_FIELDS, meta_id);
 
-	data = skb_push(skb, sizeof(meta_id));
+	data -= sizeof(meta_id);
 	put_unaligned_be32(meta_id, data);
 
 	return NFDK_DESC_TX_CHAIN_META;
@@ -259,7 +262,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_BUSY;
 	}
 
-	metadata = nfp_nfdk_prep_tx_meta(nn->app, skb, r_vec);
+	metadata = nfp_nfdk_prep_tx_meta(dp, nn->app, skb);
 	if (unlikely((int)metadata < 0))
 		goto err_flush;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
index 6cd895d3b571..fdb8144a63e0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
@@ -169,6 +169,7 @@ nfp_nfdk_print_tx_descs(struct seq_file *file,
 	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
 	 NFP_NET_CFG_CTRL_RXVLAN |					\
 	 NFP_NET_CFG_CTRL_RXVLAN_V2 | NFP_NET_CFG_CTRL_RXQINQ |		\
+	 NFP_NET_CFG_CTRL_TXVLAN_V2 |					\
 	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
 	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
 	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_IRQMOD |		\
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index c5c3a4aac788..cf4d6f1129fa 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2104,7 +2104,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->cap & NFP_NET_CFG_CTRL_TXVLAN   ? "TXVLAN "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_RXQINQ   ? "RXQINQ "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ? "RXVLANv2 "   : "",
-		nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2   ? "TXVLAN2 "   : "",
+		nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2   ? "TXVLANv2 "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_SCATTER  ? "SCATTER "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_GATHER   ? "GATHER "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_LSO      ? "TSO1 "     : "",
-- 
2.30.2

