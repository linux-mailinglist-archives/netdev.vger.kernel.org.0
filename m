Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0589F4E2486
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346433AbiCUKoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346428AbiCUKn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:43:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4E55230
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bS8/H6y6e+KPKQUxypIiISCg60FwMcZ16LYKh41lHDLUqiTFTipy7B9E1juA/jp4hhh26oNij/zAG10Dy00V+FEAleq4yIIqR2fB1vTgLYlX3CcF1jKTDf/LuYhhW/ygLpkjKOpuIfka/hdpDWoqqa89VTwetagN8UVGII1qS4UCjDtauXXdQEq+D7CTjZqovRQLpquWkHk3iMKYpJ8vnwt5SaVi/dLvmQeD/vwoGq9hVnexxjys5PosMfbBTAN7n+0U9w+TnNcQf2W9bJQWz4nDbCu2Qh4T4vKv718DbVMdXlXKKoz6d33YP2ByEE+wtTmbSoB5B5YlJSaf7SnY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRwIsxME4yECKGc6XtiOwqUCMk58u83rwT8iL1OC/rY=;
 b=OgaK719xz0+l4emryoxAqo7r3dXEoRgTQrx+ludpMwAGk+OybbDxWVDo2aEe1nbmzk3SnhZMvmwRm8aeq98s02g1xi6hI+/SZn8IlX3Vj55Zvl2unqc+55cxNAkN1b+q/ey7x2Oq/cw70OUtYZehOHroXidYvuG3ELbpl/9a8RXnzLMZvibMQzCC52kjC4e9iVNplHOmVSAuh31xoG/vIW5eqLYy81JmHMeii/IGdIbQmJMt39aL5sBiXkZlvby62DGPlR8r0Ngdsc2kK0qbCkXj4sePf7vfilh9/XOj5iGWy1b/tFFAkn4706yqTpqQpSd8HAvKURxnXFEUOr8k4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRwIsxME4yECKGc6XtiOwqUCMk58u83rwT8iL1OC/rY=;
 b=lqORtbejmSkraAbE2on2lQBrkxfXP8l6JzQtiT+HlvFQS6klfs370X59pasm5YV370eGoXVvhgzDTS2OeLEfW8Cpq1RvxTzN3CgA0sR58OfB5GNmal41PeUKta2eXMTm1De3z4hkwDsAydYd/sZvYIBdMrsZqh0i0k+ydkVOnO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:30 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 03/10] nfp: use callbacks for slow path ring related functions
Date:   Mon, 21 Mar 2022 11:42:02 +0100
Message-Id: <20220321104209.273535-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57f71366-a4ef-423e-9c45-08da0b277fb7
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB151248A2B09EAF41B8338557E8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRkME6OtuCXCF6f9snrf/zSdJw/7OlIAoSXOiOTMhHRl9sAMyWgeEQ1NYokYwVyeFnm7qWUTs/b+x2+iz7HtS93CLv18LgWiF9bApp2Q9BDx5RSyiVtGNvyfMDkmTLaJ6RRahVOEYqqBnldqE9rgpfyNzs58Fy06un38xMQUIgZ6SDOyqJ/+HeENlaMhUsl2AQQmbBmARlgX3ue3IuI6NDlBqbUT9VRr1uxWL/cQYtNDujOdWeYvGss13jNRMxTysqmlaKHZt6VfeGCCSx3R0VUGQ/ajpgFeAwS6NbVQyQKAPOuU3qihQBF0k/B2d4biVYn11TkIQp6ZhR9jkXDpPGABtLV30OMZm6PQ6JTtP8lcrQAs1Ru9IJjR4LWZonpiWfuvqVAWKNFszDG1e+zZedhaM4mDbLr7AIVG3sNNoGuYDYTgItIp/9z3w4c1YqKbjc+EQhSX8A3N3sfK8im4om+MLR9JeRXpjrKbSElP4VXG1NlAEPEKQ9RXWR5I8SE7lWiWtHyJmJRJkcCBvo5CzDE1jHP85nWouUQrbUwtubqH2jPf2iJP030BRmwRijIsY/Xw17xGZ804uf0O6hFUBwWGnjCU96V9OFUaADrrxekM/OL+T81XMdacFU6uGtLUiW3pCHjt8I2fwIzjFWwTcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(30864003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bq9ghuJdzopk0ut0/CQFFNVrWw+TwVEzpHpSlZYiMURPQxcOfPSTWySNpCXw?=
 =?us-ascii?Q?7hcmm9X2GnfDqOnRYFdORe77bUOvZkneu1AL06LQT0oH/h6kBqd6eFYWlOzB?=
 =?us-ascii?Q?s2h6RR7bUrKCMZvRVBk8gCxEy34BtoVJW2tyAkS8P98HPiRadfe0XVRc4YwF?=
 =?us-ascii?Q?NxioSgcdHekehawcVN6/eaLlAKMliW2jGiTNVGrBmnNWEwriJOi6xuccr3YI?=
 =?us-ascii?Q?NJUEcZDZkh+2zXt3KRhLSqsTmMxpt4ZKBmAZ4fcZoiKiIz0tv4azTy3mI0M+?=
 =?us-ascii?Q?rQRkZ7BL5NZIXMBwdwjGWDiZADYp+4eObK3EPEtsYEzhXFoxlrdVectkKWXt?=
 =?us-ascii?Q?Wdwp6vrXdEROqwLfGTW0zNPXlHFGAzLyTVgpVpkHJ6b/xCTyxidLNjBHWlU+?=
 =?us-ascii?Q?4vXOLH1nJm4Zpmn34Hu+7o3WZPamtqZ1f++tAnBvSNExlEkbqbFOunaXqUg+?=
 =?us-ascii?Q?D3XQFxYB7g1FzROqlUt+GAYqgiha+c6t8lsnBcywRpnWch9mC7+O54l60ZKb?=
 =?us-ascii?Q?kgbZEPaPI5f5OneuMr4GraEa7pofWsh7uWaH60x3w82qpi1gj05UNM39UuwB?=
 =?us-ascii?Q?ik+ra8i3UH2GWGI0WsyWz+XXJpRozi/6DRjLmmq1jPcJndryY6fbjwpCfeQz?=
 =?us-ascii?Q?H+grWYyM3EuP31sCq2ZitvpNjxCBr+8CwHfGH423iGHsKiu9AVFyui3TgVjz?=
 =?us-ascii?Q?pIhCl4Ml2nnAvbeTszXhN9KgcrLCzHul4SDJT+3Bk1fI7KEAFNn+JotuDbLJ?=
 =?us-ascii?Q?j1E3cnhKVS++I2e5IQhsFISIqaFH37prPnxXWW3wGLHSmO1Acjw5gf949s8J?=
 =?us-ascii?Q?VAG6D6vnPcOOzD8GXF2cIKaFMiZ5IMTaY0M4FO6Hhwm/KiOLniF0atIeizur?=
 =?us-ascii?Q?HMO3BMeHmgo/4HysSqsKBZ9TwVSnIUrXZKocQiHp9LtJSqBh7bX/LZP1rMxP?=
 =?us-ascii?Q?7y1+DyyAkwrhE+RzoGqDUzcpnMduC1iVBoGHCG84zHQbpCV5Tywrfe8A9mUN?=
 =?us-ascii?Q?WNmL9lMXEewFNxep46qepMILY8ZEnGgaUMmFbjHpInzdlGPaQFpQIOQCJ578?=
 =?us-ascii?Q?AnWCm+0wdiKLurVO/k75afiZpGm6BSBZGpLJC6V6MqbwnBvX4uNHdELYs8j3?=
 =?us-ascii?Q?JODX1xgMl77t3lLa32j7Ig1IAMhbLAU6hUD097VbibfqmKVbnlWSwtsfCnXo?=
 =?us-ascii?Q?bUC4BW7t8oyselbBdaLPaLSxgo3Zcn9xIQiIHh2P90x5XwFM3785FHgkOwKl?=
 =?us-ascii?Q?mfDv7lMdxVBJaoMzbsPEBryoLZR5TtWZAIX6Ao2mhqxikJp+ot7W51pcSQuP?=
 =?us-ascii?Q?bvvgExUga9a3lrLaMnj9bVH/d6eQfjov6/CA4eJNShekuJnPJjThqbBFnMcI?=
 =?us-ascii?Q?EFHUzYqMvMrJ+hT8nZ4HkW3Y00gM3RsLBFcHZDRYPJeA8d9jUgQvurm0fkDf?=
 =?us-ascii?Q?30eqVtCbkYXuyBIC0jAOYnz/Cn8CL8bBjYt4olOtHZYw2j6EY6jDsxID6Twu?=
 =?us-ascii?Q?dxQDAK/gn89C06qibBxDa2cz5/mgjI4/xr0b7uivqggOcNfiFvW+rE3JNw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f71366-a4ef-423e-9c45-08da0b277fb7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:30.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsHCsxXF1jTJ1HmX34kbqVZuShMc2OZWpkHJDMku90zbVYv04far5AHeJ4J9ILWHNsNt/HWrMs5xMRltiVrjTUP3CWF4NlmkeKXTfdomjys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

To reduce the coupling of slow path ring implementations and their
callers, use callbacks instead.

Changes to Jakub's work:
* Also use callbacks for xmit functions

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  27 +----
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |  28 +----
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  28 ++++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   4 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   7 +-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   |  55 ++-------
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   | 111 +++++++++++++++---
 8 files changed, 148 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index b2a34a09471b..619f4d09e4e0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -1131,9 +1131,9 @@ int nfp_nfd3_poll(struct napi_struct *napi, int budget)
 /* Control device data path
  */
 
-static bool
-nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
-		struct sk_buff *skb, bool old)
+bool
+nfp_nfd3_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		     struct sk_buff *skb, bool old)
 {
 	unsigned int real_len = skb->len, meta_len = 0;
 	struct nfp_net_tx_ring *tx_ring;
@@ -1215,31 +1215,12 @@ nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	return false;
 }
 
-bool __nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
-
-	return nfp_ctrl_tx_one(nn, r_vec, skb, false);
-}
-
-bool nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
-	bool ret;
-
-	spin_lock_bh(&r_vec->lock);
-	ret = nfp_ctrl_tx_one(nn, r_vec, skb, false);
-	spin_unlock_bh(&r_vec->lock);
-
-	return ret;
-}
-
 static void __nfp_ctrl_tx_queued(struct nfp_net_r_vector *r_vec)
 {
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&r_vec->queue)))
-		if (nfp_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
+		if (nfp_nfd3_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
 			return;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
index 0bd597ad6c6e..7a0df9e6c3c4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
@@ -93,34 +93,14 @@ nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		    void *data, void *pkt, unsigned int pkt_len, int meta_len);
 void nfp_nfd3_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget);
 int nfp_nfd3_poll(struct napi_struct *napi, int budget);
+netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev);
+bool
+nfp_nfd3_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		     struct sk_buff *skb, bool old);
 void nfp_nfd3_ctrl_poll(struct tasklet_struct *t);
 void nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 				    struct nfp_net_rx_ring *rx_ring);
 void nfp_nfd3_xsk_tx_free(struct nfp_nfd3_tx_buf *txbuf);
 int nfp_nfd3_xsk_poll(struct napi_struct *napi, int budget);
 
-void
-nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-			       struct nfp_net_rx_ring *rx_ring);
-int
-nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring);
-int
-nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			    struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			   struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_print_tx_descs(struct seq_file *file,
-			struct nfp_net_r_vector *r_vec,
-			struct nfp_net_tx_ring *tx_ring,
-			u32 d_rd_p, u32 d_wr_p);
-netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev);
-bool nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
-bool __nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
-
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 4c6aaebb7522..342871d23e15 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -38,7 +38,7 @@ static void nfp_nfd3_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring)
  *
  * Assumes that the device is stopped, must be idempotent.
  */
-void
+static void
 nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 {
 	struct netdev_queue *nd_q;
@@ -98,7 +98,7 @@ nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
  * nfp_nfd3_tx_ring_free() - Free resources allocated to a TX ring
  * @tx_ring:   TX ring to free
  */
-void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
+static void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
 {
 	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
 	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
@@ -123,7 +123,7 @@ void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
  *
  * Return: 0 on success, negative errno otherwise.
  */
-int
+static int
 nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 {
 	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
@@ -156,7 +156,7 @@ nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 	return -ENOMEM;
 }
 
-void
+static void
 nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
 			   struct nfp_net_tx_ring *tx_ring)
 {
@@ -174,7 +174,7 @@ nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
 	}
 }
 
-int
+static int
 nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
 			    struct nfp_net_tx_ring *tx_ring)
 {
@@ -195,7 +195,7 @@ nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
 	return 0;
 }
 
-void
+static void
 nfp_nfd3_print_tx_descs(struct seq_file *file,
 			struct nfp_net_r_vector *r_vec,
 			struct nfp_net_tx_ring *tx_ring,
@@ -241,3 +241,19 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 		seq_putc(file, '\n');
 	}
 }
+
+const struct nfp_dp_ops nfp_nfd3_ops = {
+	.version		= NFP_NFD_VER_NFD3,
+	.poll			= nfp_nfd3_poll,
+	.xsk_poll		= nfp_nfd3_xsk_poll,
+	.ctrl_poll		= nfp_nfd3_ctrl_poll,
+	.xmit			= nfp_nfd3_tx,
+	.ctrl_tx_one		= nfp_nfd3_ctrl_tx_one,
+	.rx_ring_fill_freelist	= nfp_nfd3_rx_ring_fill_freelist,
+	.tx_ring_alloc		= nfp_nfd3_tx_ring_alloc,
+	.tx_ring_reset		= nfp_nfd3_tx_ring_reset,
+	.tx_ring_free		= nfp_nfd3_tx_ring_free,
+	.tx_ring_bufs_alloc	= nfp_nfd3_tx_ring_bufs_alloc,
+	.tx_ring_bufs_free	= nfp_nfd3_tx_ring_bufs_free,
+	.print_tx_descs		= nfp_nfd3_print_tx_descs
+};
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index bffe53f4c2d3..13a9e6731d0d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -98,6 +98,7 @@
 /* Forward declarations */
 struct nfp_cpp;
 struct nfp_dev_info;
+struct nfp_dp_ops;
 struct nfp_eth_table_port;
 struct nfp_net;
 struct nfp_net_r_vector;
@@ -439,6 +440,7 @@ struct nfp_stat_pair {
  * @rx_rings:		Array of pre-allocated RX ring structures
  * @ctrl_bar:		Pointer to mapped control BAR
  *
+ * @ops:		Callbacks and parameters for this vNIC's NFD version
  * @txd_cnt:		Size of the TX ring in number of descriptors
  * @rxd_cnt:		Size of the RX ring in number of descriptors
  * @num_r_vecs:		Number of used ring vectors
@@ -473,6 +475,8 @@ struct nfp_net_dp {
 
 	/* Cold data follows */
 
+	const struct nfp_dp_ops *ops;
+
 	unsigned int txd_cnt;
 	unsigned int rxd_cnt;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 1d3277068301..dd234f5228f1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -754,7 +754,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
 
 			__skb_queue_head_init(&r_vec->queue);
 			spin_lock_init(&r_vec->lock);
-			tasklet_setup(&r_vec->tasklet, nfp_nfd3_ctrl_poll);
+			tasklet_setup(&r_vec->tasklet, nn->dp.ops->ctrl_poll);
 			tasklet_disable(&r_vec->tasklet);
 		}
 
@@ -768,7 +768,7 @@ nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec, int idx)
 	if (dp->netdev)
 		netif_napi_add(dp->netdev, &r_vec->napi,
 			       nfp_net_has_xsk_pool_slow(dp, idx) ?
-			       nfp_nfd3_xsk_poll : nfp_nfd3_poll,
+			       dp->ops->xsk_poll : dp->ops->poll,
 			       NAPI_POLL_WEIGHT);
 	else
 		tasklet_enable(&r_vec->tasklet);
@@ -1895,7 +1895,7 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_uninit		= nfp_app_ndo_uninit,
 	.ndo_open		= nfp_net_netdev_open,
 	.ndo_stop		= nfp_net_netdev_close,
-	.ndo_start_xmit		= nfp_nfd3_tx,
+	.ndo_start_xmit		= nfp_net_tx,
 	.ndo_get_stats64	= nfp_net_stat64,
 	.ndo_vlan_rx_add_vid	= nfp_net_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
@@ -2033,6 +2033,7 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 	nn->dp.ctrl_bar = ctrl_bar;
 	nn->dev_info = dev_info;
 	nn->pdev = pdev;
+	nn->dp.ops = &nfp_nfd3_ops;
 
 	nn->max_tx_rings = max_tx_rings;
 	nn->max_rx_rings = max_rx_rings;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index 59b852e18758..791203d07ac7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -105,7 +105,7 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 		   tx_ring->cnt, &tx_ring->dma, tx_ring->txds,
 		   tx_ring->rd_p, tx_ring->wr_p, d_rd_p, d_wr_p);
 
-	nfp_net_debugfs_print_tx_descs(file, r_vec, tx_ring,
+	nfp_net_debugfs_print_tx_descs(file, &nn->dp, r_vec, tx_ring,
 				       d_rd_p, d_wr_p);
 out:
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
index 8fe48569a612..431bd2c13221 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
@@ -392,57 +392,28 @@ void nfp_net_vec_clear_ring_data(struct nfp_net *nn, unsigned int idx)
 	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), 0);
 }
 
-void
-nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
-{
-	nfp_nfd3_tx_ring_reset(dp, tx_ring);
-}
-
-void nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-				   struct nfp_net_rx_ring *rx_ring)
+netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 {
-	nfp_nfd3_rx_ring_fill_freelist(dp, rx_ring);
-}
+	struct nfp_net *nn = netdev_priv(netdev);
 
-int
-nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
-{
-	return nfp_nfd3_tx_ring_alloc(dp, tx_ring);
+	return nn->dp.ops->xmit(skb, netdev);
 }
 
-void
-nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
 {
-	nfp_nfd3_tx_ring_free(tx_ring);
-}
+	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
 
-int nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring)
-{
-	return nfp_nfd3_tx_ring_bufs_alloc(dp, tx_ring);
+	return nn->dp.ops->ctrl_tx_one(nn, r_vec, skb, false);
 }
 
-void nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring)
-{
-	nfp_nfd3_tx_ring_bufs_free(dp, tx_ring);
-}
-
-void
-nfp_net_debugfs_print_tx_descs(struct seq_file *file,
-			       struct nfp_net_r_vector *r_vec,
-			       struct nfp_net_tx_ring *tx_ring,
-			       u32 d_rd_p, u32 d_wr_p)
+bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
 {
-	nfp_nfd3_print_tx_descs(file, r_vec, tx_ring, d_rd_p, d_wr_p);
-}
+	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
+	bool ret;
 
-bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	return __nfp_nfd3_ctrl_tx(nn, skb);
-}
+	spin_lock_bh(&r_vec->lock);
+	ret = nn->dp.ops->ctrl_tx_one(nn, r_vec, skb, false);
+	spin_unlock_bh(&r_vec->lock);
 
-bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	return nfp_nfd3_ctrl_tx(nn, skb);
+	return ret;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 30ccdf5aa819..25af0e3c7af7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -5,7 +5,6 @@
 #define _NFP_NET_DP_
 
 #include "nfp_net.h"
-#include "nfd3/nfd3.h"
 
 static inline dma_addr_t nfp_net_dma_map_rx(struct nfp_net_dp *dp, void *frag)
 {
@@ -100,21 +99,103 @@ void nfp_net_rx_rings_free(struct nfp_net_dp *dp);
 void nfp_net_tx_rings_free(struct nfp_net_dp *dp);
 void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring);
 
-void
-nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-				   struct nfp_net_rx_ring *rx_ring);
-int
-nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void
-nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-int nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring);
-void nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring);
-void
-nfp_net_debugfs_print_tx_descs(struct seq_file *file,
+enum nfp_nfd_version {
+	NFP_NFD_VER_NFD3,
+};
+
+/**
+ * struct nfp_dp_ops - Hooks to wrap different implementation of different dp
+ * @version:			Indicate dp type
+ * @poll:			Napi poll for normal rx/tx
+ * @xsk_poll:			Napi poll when xsk is enabled
+ * @ctrl_poll:			Tasklet poll for ctrl rx/tx
+ * @xmit:			Xmit for normal path
+ * @ctrl_tx_one:		Xmit for ctrl path
+ * @rx_ring_fill_freelist:	Give buffers from the ring to FW
+ * @tx_ring_alloc:		Allocate resource for a TX ring
+ * @tx_ring_reset:		Free any untransmitted buffers and reset pointers
+ * @tx_ring_free:		Free resources allocated to a TX ring
+ * @tx_ring_bufs_alloc:		Allocate resource for each TX buffer
+ * @tx_ring_bufs_free:		Free resources allocated to each TX buffer
+ * @print_tx_descs:		Show TX ring's info for debug purpose
+ */
+struct nfp_dp_ops {
+	enum nfp_nfd_version version;
+
+	int (*poll)(struct napi_struct *napi, int budget);
+	int (*xsk_poll)(struct napi_struct *napi, int budget);
+	void (*ctrl_poll)(struct tasklet_struct *t);
+	netdev_tx_t (*xmit)(struct sk_buff *skb, struct net_device *netdev);
+	bool (*ctrl_tx_one)(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+			    struct sk_buff *skb, bool old);
+	void (*rx_ring_fill_freelist)(struct nfp_net_dp *dp,
+				      struct nfp_net_rx_ring *rx_ring);
+	int (*tx_ring_alloc)(struct nfp_net_dp *dp,
+			     struct nfp_net_tx_ring *tx_ring);
+	void (*tx_ring_reset)(struct nfp_net_dp *dp,
+			      struct nfp_net_tx_ring *tx_ring);
+	void (*tx_ring_free)(struct nfp_net_tx_ring *tx_ring);
+	int (*tx_ring_bufs_alloc)(struct nfp_net_dp *dp,
+				  struct nfp_net_tx_ring *tx_ring);
+	void (*tx_ring_bufs_free)(struct nfp_net_dp *dp,
+				  struct nfp_net_tx_ring *tx_ring);
+
+	void (*print_tx_descs)(struct seq_file *file,
 			       struct nfp_net_r_vector *r_vec,
 			       struct nfp_net_tx_ring *tx_ring,
 			       u32 d_rd_p, u32 d_wr_p);
+};
+
+static inline void
+nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	return dp->ops->tx_ring_reset(dp, tx_ring);
+}
+
+static inline void
+nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+			      struct nfp_net_rx_ring *rx_ring)
+{
+	dp->ops->rx_ring_fill_freelist(dp, rx_ring);
+}
+
+static inline int
+nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	return dp->ops->tx_ring_alloc(dp, tx_ring);
+}
+
+static inline void
+nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	dp->ops->tx_ring_free(tx_ring);
+}
+
+static inline int
+nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			   struct nfp_net_tx_ring *tx_ring)
+{
+	return dp->ops->tx_ring_bufs_alloc(dp, tx_ring);
+}
+
+static inline void
+nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			  struct nfp_net_tx_ring *tx_ring)
+{
+	dp->ops->tx_ring_bufs_free(dp, tx_ring);
+}
+
+static inline void
+nfp_net_debugfs_print_tx_descs(struct seq_file *file, struct nfp_net_dp *dp,
+			       struct nfp_net_r_vector *r_vec,
+			       struct nfp_net_tx_ring *tx_ring,
+			       u32 d_rd_p, u32 d_wr_p)
+{
+	dp->ops->print_tx_descs(file, r_vec, tx_ring, d_rd_p, d_wr_p);
+}
+
+extern const struct nfp_dp_ops nfp_nfd3_ops;
+
+netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev);
+
 #endif /* _NFP_NET_DP_ */
-- 
2.30.2

