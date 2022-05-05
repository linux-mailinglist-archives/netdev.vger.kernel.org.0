Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF0351B790
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243788AbiEEFsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243707AbiEEFrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C6234B9D
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMiK3geE8bRcGhgJExO6afeTikaEbRkAxtW04IH9asEVxyM/HCrVp/rVxpcsgjBCNe5PGbMn2F5nzoKvVF+62MlK+z/+GIRaoS+DsRoQIeLbtnkymWbIpnZ7lQdHj/CcY2mId+/yQD6tnH0rgkBfCJnJKiv2h9uytUbWMcTc2HLwck7/3a8w5MNbOEOfIjAkmHRtMGkGbDAI6iX5eTPVSllsS0CecfsnYjhTG+MmOkr/WP0bLHghDfAi6MoFnEzCRjK4Z/wDXc0CnERatI4vI2Jazhje09XgmKgQ/dOsxePGQH1zxCliEwEsJj2x5xn+1yy974TEGWxtEHdjb8zUxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lORqU9Cb+qiwcWB325YwDU1pNMoYERYEOj+eKJg94o4=;
 b=Eevbp3NN2ErcIAnMunk/PqlrCq+bPPmSgUIA3ol9ZtaG14P5807M7WaXxLxoUQjX+Yf8TUZvWCzHAIwzhuN/kN3vBmL6NRuTPBB5gtrQ7XTPtIxDbzBirnwrwHSLuZLvXFFArz3seTGy9GBT6lNEK1WUQkzrHehKrkPlTZrkBhc+83Ve2cQkBTByxWt/z/VIF7F3gVnKByLHPyIr+IWPa5s0StpuUykLqqo1UwAMHP8Rq7pwbIUvF0M9m3tolkRQVbdtpTtHd+HLjROAXiFZzzfQPkHQGbY8I54RVM9QpVz2Is/x0VdeqX/JvEHgaD5SrEeNSKWAr5YgNn/kg76CtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lORqU9Cb+qiwcWB325YwDU1pNMoYERYEOj+eKJg94o4=;
 b=MALMBNHImib+Le7ZwYj5jhXsz1CwaBh8yptxgQ4+3G3a7GsZKwYeRZ9RwA9PbtOdzSSjM8Zc8wBM1DN56wRt8ftR2nqQFIQz2/e3qu7tTc/GUpz7HzdZWusWo72Pi717lFqi7HaBDVumFWtc7sfSyXRJliZZCAi8WqF3iv9Q4+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1257.namprd13.prod.outlook.com (2603:10b6:3:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.16; Thu, 5 May
 2022 05:44:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:11 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 6/9] nfp: flower: rework tunnel neighbour configuration
Date:   Thu,  5 May 2022 14:43:45 +0900
Message-Id: <20220505054348.269511-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d7b9d9b-9614-4593-d6ab-08da2e5a480d
X-MS-TrafficTypeDiagnostic: DM5PR13MB1257:EE_
X-Microsoft-Antispam-PRVS: <DM5PR13MB12570D65DDDB8E47248CAF5DE8C29@DM5PR13MB1257.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IWp4gBuKSJVrKoH99zHD3vYt0HDnQG1z+3Q+zdHXMWT207eJ3kGhBkyZpHZrNJ2wHz4g05pwd811bV6fiT5jjWdGme3h1xJauAbeEHAter/pUaRMEJNy98+nLDIxyDTtGfQtkhyNWXmHIbf0ZvugCoEi+nnojq99BbHFBE6+DwfaUOFsjXncSvgu0QQI0HbQEKmKC/LgTix/8HnXb0+LUc/xXQ8if/1Z0aOggsWhh+nEMnORH/R3RXZu5gqibEeMmA4KQOjH6sbM8Fc7HB9ifXt1K4yKikaFw/W9E0w1pp+jkZSaFceUzUbBXQSPbwCDN0HUKBM3KH1/ZFTgtCQ9589+gDQ0Pvf8/d8moChbxMIQX0zrpf+5Wv9LUkeXDH8VK8EkVJljC8Mn0RwwSUtgoNRqjXLq5gSz9qCyf1xfAu+9GzN5ETK3Qpl1yywfUlQoexI7vClK6DXl3niCfWcDL8B1FURDwdViLbTxn4tmowvBb4gI9tWrszcnZ3dS2i3Ks679mVA1hvcivG3i47p1loj6+HJ+J7VVUivubfFOEKg/1Rx1+QP+4AIkPG4WU/wfo2s3LcN3XOmQ2vije3Rdojb6rndz1d+E1u+uwyskOVBBqckKOmJgJ+nuPQ3HpZp6E5y53MN8gscajVp4KwqKGwkdRpBM36IADSzN8F4ePc6OZ5DGdD8XNVdqFUJ8Gf4qDz+Ym0PHZhGe50iu8GmKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(136003)(396003)(39830400003)(66556008)(66946007)(6506007)(8676002)(4326008)(5660300002)(52116002)(1076003)(186003)(6486002)(36756003)(2616005)(316002)(110136005)(83380400001)(107886003)(66476007)(6512007)(8936002)(38100700002)(38350700002)(86362001)(508600001)(26005)(6666004)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEJpsEadVez6DyXRuQBRl5Q+ShyVm6Yn6QXzmns7wtE6JY3Q2ikp9lVBT2hS?=
 =?us-ascii?Q?mtqMODhgmKeDqtdGRX6hZ1KbAraa+qu0c4j/4iok8203J2NfHzGg9yA2VUBV?=
 =?us-ascii?Q?S3qt16mUP1hzZQ9cSKooTxpqaRQ75rfTWnchAkUBPzUlk321CMOuJgZmPCVW?=
 =?us-ascii?Q?OfOJLDUIbV4SZgbornXl1ZYwNd/V5/vBZH91NfBZIlEUtM8dz65QtKKQyzI2?=
 =?us-ascii?Q?NzN/QaJcYQh+Xu+eIV09X9mae0a+xs+0/2yAO0mCq8jP3gdn2wrHYWHoi3VG?=
 =?us-ascii?Q?ZKPh28UFK+buiXeXj4KgBU7wVwLXa+1iSSb52aWZRYtFdxGpGBk+e1339WCv?=
 =?us-ascii?Q?v5/mgEuaokiblhNbmM+GiwcmOkuLf+d5cy2VNzHHIdthjZhOmdEaAW7mCGbV?=
 =?us-ascii?Q?2mM8ng0PtGbcgOD/ZRneU6IY433+s3lI0xweir3fkttDsD3rTsbANi2LUyI2?=
 =?us-ascii?Q?l/Ub5tedzNLiBo4lUQqS+BX5KNz//DW4TIv1ReQnxyFZikvNvBT3H9hLOYUG?=
 =?us-ascii?Q?SQcCkxsRFyJV/aylkGJZ6Fk0bX36rnN6RoaCHXeURfGJUJfcJfjB7oCxTOdc?=
 =?us-ascii?Q?qV6vUzUig0Stbi6wiacZpdMDO6t+So6jmdQ0V5lzZl2r4dfBPszwgQJVqd/T?=
 =?us-ascii?Q?RTF8G+wWDCXCtiixqdv19N+aDGlifrDLU+UMcZrxrz2Dc8F2J+vZg6C8IVJJ?=
 =?us-ascii?Q?48z9eF5mBZi9kM/W4l7xnmdYXgpNzC8eOEcu4wDYVhekIR1g74XgtcA0DfVF?=
 =?us-ascii?Q?CKbXJTEssH587W9rbxER/cYVfzMXtO3npOY2PrzNWocgB/DlAYwpyRIFV/cA?=
 =?us-ascii?Q?+6AtR6+uJqrcPuQHgkFB8YOOeFPpIBB17aUpofH+z26AJ+bRj2t8pPPpvHNY?=
 =?us-ascii?Q?lRu9CjXZzfx68K2HZNLj3ZmjbIZ/JeyjN8JM8SUQ6eMrQwm4MVU30OJAghSB?=
 =?us-ascii?Q?VFIowuvgpngBqg886Mjr5Nx1hGglwb5jCgxX1DQLdo3cEskBW32qe7TJ5ciW?=
 =?us-ascii?Q?gWeuyTJ2+jprjz+M9WRk416GCZj823R5rJ4oteI3hNPSXkBn5sArhoFTueAw?=
 =?us-ascii?Q?aR00gc/9OPAWvbZQHwz5n3BNqgPKcnsGM9nV3k7XtLEgt4gMiyRrpAn/orjP?=
 =?us-ascii?Q?/nhWWaO6xqYU4omMU1W1BLj6WxIj3mFpOVo6W0NAlSuffGeYo9Pv2tUikzhJ?=
 =?us-ascii?Q?GG19qHzCdwol906BPeu0vKpDG/ixAswcDh8qTtcObLaozc9VvBj6QhrxpIH6?=
 =?us-ascii?Q?StuP5/qrx9UN3ZlAwBXjcY5TNtr6NAlr7faPYQwAp6EsIhb763nMQo8+RQqy?=
 =?us-ascii?Q?tOB4LrhMsugfgVAZiK+GusEAkiWY+hf9iUNpQmNp6MbvnqV2/Tff9jX65wUP?=
 =?us-ascii?Q?dTm187HjRWq8kJjnq4DAbGJ0qX228gjElxVltlhdijrzSMcTHU2LyUWQdeLu?=
 =?us-ascii?Q?mzSeJPV4aCkGHXajSkJzjyuSr8Z3p27L23kE8JPWXFmnSkX2VQ+CK2CefvDZ?=
 =?us-ascii?Q?GDnnDRkzLgd2xxOg4mQfCIP57L+rhckCfM9aEmcesKoiO/R7o4cUuOilXQCJ?=
 =?us-ascii?Q?hIx7rfnQ+7XSgryfIhpK8TW3QhGN2oBft5GAO0TFdfEMq6KB8cb09l5dJI7I?=
 =?us-ascii?Q?pxzVPqWkQpYaZmg7uPSDtD5PebkV36Du9qE8nzBiOjln4w3WqLS8m4ljvcn3?=
 =?us-ascii?Q?AQiP0JwTad/B8Yki97AL9Ri06d75P/qq3Wfrs+erzjHkjYURhWzStU1di4pp?=
 =?us-ascii?Q?bvkBVzv8majxNRbXO9JCtjqi+lP9k40=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7b9d9b-9614-4593-d6ab-08da2e5a480d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:11.8553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZTgiDDzVSWJ4dA+mZ1AvTMBQgHV54TThLA+u0AniPOpXwYd7h+vNG1U0dp2iWC7VMDIYaZo74fwQvQAtt3zYnzYrvB5s8jgISRHU2nYmBrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1257
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

This patch updates the way in which the tunnel neighbour entries
are handled. Previously they were mostly send-and-forget, with
just the destination IP's cached in a list. This update changes
to a scheme where the neighbour entry information is stored in
a hash table.

The reason for this is that the neighbour table will now also
be used on the decapsulation path, whereas previously it was
only used for encapsulation. We need to save more of the neighbour
information in order to link them with flower flows in follow
up patches.

Updating of the neighbour table is now also handled by the same
function, instead of separate  *_write_neigh_vX functions.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../netronome/nfp/flower/tunnel_conf.c        | 174 ++++++++++++------
 1 file changed, 115 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 174888272a30..4ca149501409 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -419,75 +419,131 @@ nfp_tun_del_route_from_cache_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
 }
 
 static void
-nfp_tun_write_neigh_v4(struct net_device *netdev, struct nfp_app *app,
-		       struct flowi4 *flow, struct neighbour *neigh, gfp_t flag)
+nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
+		    void *flow, struct neighbour *neigh, bool is_ipv6)
 {
-	struct nfp_tun_neigh_v4 payload;
+	bool neigh_invalid = !(neigh->nud_state & NUD_VALID) || neigh->dead;
+	size_t neigh_size = is_ipv6 ? sizeof(struct nfp_tun_neigh_v6) :
+			    sizeof(struct nfp_tun_neigh_v4);
+	unsigned long cookie = (unsigned long)neigh;
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_neigh_entry *nn_entry;
 	u32 port_id;
+	u8 mtype;
 
 	port_id = nfp_flower_get_port_id_from_netdev(app, netdev);
 	if (!port_id)
 		return;
 
-	memset(&payload, 0, sizeof(struct nfp_tun_neigh_v4));
-	payload.dst_ipv4 = flow->daddr;
+	spin_lock_bh(&priv->predt_lock);
+	nn_entry = rhashtable_lookup_fast(&priv->neigh_table, &cookie,
+					  neigh_table_params);
+	if (!nn_entry && !neigh_invalid) {
+		struct nfp_tun_neigh_ext *ext;
+		struct nfp_tun_neigh *common;
+
+		nn_entry = kzalloc(sizeof(*nn_entry) + neigh_size,
+				   GFP_ATOMIC);
+		if (!nn_entry)
+			goto err;
+
+		nn_entry->payload = (char *)&nn_entry[1];
+		nn_entry->neigh_cookie = cookie;
+		nn_entry->is_ipv6 = is_ipv6;
+		nn_entry->flow = NULL;
+		if (is_ipv6) {
+			struct flowi6 *flowi6 = (struct flowi6 *)flow;
+			struct nfp_tun_neigh_v6 *payload;
+
+			payload = (struct nfp_tun_neigh_v6 *)nn_entry->payload;
+			payload->src_ipv6 = flowi6->saddr;
+			payload->dst_ipv6 = flowi6->daddr;
+			common = &payload->common;
+			ext = &payload->ext;
+			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6;
+		} else {
+			struct flowi4 *flowi4 = (struct flowi4 *)flow;
+			struct nfp_tun_neigh_v4 *payload;
+
+			payload = (struct nfp_tun_neigh_v4 *)nn_entry->payload;
+			payload->src_ipv4 = flowi4->saddr;
+			payload->dst_ipv4 = flowi4->daddr;
+			common = &payload->common;
+			ext = &payload->ext;
+			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+		}
+		ext->host_ctx = cpu_to_be32(U32_MAX);
+		ext->vlan_tpid = cpu_to_be16(U16_MAX);
+		ext->vlan_tci = cpu_to_be16(U16_MAX);
+		ether_addr_copy(common->src_addr, netdev->dev_addr);
+		neigh_ha_snapshot(common->dst_addr, neigh, netdev);
+		common->port_id = cpu_to_be32(port_id);
+
+		if (rhashtable_insert_fast(&priv->neigh_table,
+					   &nn_entry->ht_node,
+					   neigh_table_params))
+			goto err;
+
+		/* Add entries to the relevant route cache */
+		if (is_ipv6) {
+			struct nfp_tun_neigh_v6 *payload;
+
+			payload = (struct nfp_tun_neigh_v6 *)nn_entry->payload;
+			nfp_tun_add_route_to_cache_v6(app, &payload->dst_ipv6);
+		} else {
+			struct nfp_tun_neigh_v4 *payload;
+
+			payload = (struct nfp_tun_neigh_v4 *)nn_entry->payload;
+			nfp_tun_add_route_to_cache_v4(app, &payload->dst_ipv4);
+		}
 
-	/* If entry has expired send dst IP with all other fields 0. */
-	if (!(neigh->nud_state & NUD_VALID) || neigh->dead) {
-		nfp_tun_del_route_from_cache_v4(app, &payload.dst_ipv4);
+		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
+					 nn_entry->payload,
+					 GFP_ATOMIC);
+	} else if (nn_entry && neigh_invalid) {
+		if (is_ipv6) {
+			struct flowi6 *flowi6 = (struct flowi6 *)flow;
+			struct nfp_tun_neigh_v6 *payload;
+
+			payload = (struct nfp_tun_neigh_v6 *)nn_entry->payload;
+			memset(payload, 0, sizeof(struct nfp_tun_neigh_v6));
+			payload->dst_ipv6 = flowi6->daddr;
+			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6;
+			nfp_tun_del_route_from_cache_v6(app,
+							&payload->dst_ipv6);
+		} else {
+			struct flowi4 *flowi4 = (struct flowi4 *)flow;
+			struct nfp_tun_neigh_v4 *payload;
+
+			payload = (struct nfp_tun_neigh_v4 *)nn_entry->payload;
+			memset(payload, 0, sizeof(struct nfp_tun_neigh_v4));
+			payload->dst_ipv4 = flowi4->daddr;
+			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
+			nfp_tun_del_route_from_cache_v4(app,
+							&payload->dst_ipv4);
+		}
 		/* Trigger ARP to verify invalid neighbour state. */
 		neigh_event_send(neigh, NULL);
-		goto send_msg;
-	}
-
-	/* Have a valid neighbour so populate rest of entry. */
-	payload.src_ipv4 = flow->saddr;
-	ether_addr_copy(payload.common.src_addr, netdev->dev_addr);
-	neigh_ha_snapshot(payload.common.dst_addr, neigh, netdev);
-	payload.common.port_id = cpu_to_be32(port_id);
-	/* Add destination of new route to NFP cache. */
-	nfp_tun_add_route_to_cache_v4(app, &payload.dst_ipv4);
-
-send_msg:
-	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH,
-				 sizeof(struct nfp_tun_neigh_v4),
-				 (unsigned char *)&payload, flag);
-}
+		rhashtable_remove_fast(&priv->neigh_table,
+				       &nn_entry->ht_node,
+				       neigh_table_params);
 
-static void
-nfp_tun_write_neigh_v6(struct net_device *netdev, struct nfp_app *app,
-		       struct flowi6 *flow, struct neighbour *neigh, gfp_t flag)
-{
-	struct nfp_tun_neigh_v6 payload;
-	u32 port_id;
+		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
+					 nn_entry->payload,
+					 GFP_ATOMIC);
 
-	port_id = nfp_flower_get_port_id_from_netdev(app, netdev);
-	if (!port_id)
-		return;
-
-	memset(&payload, 0, sizeof(struct nfp_tun_neigh_v6));
-	payload.dst_ipv6 = flow->daddr;
-
-	/* If entry has expired send dst IP with all other fields 0. */
-	if (!(neigh->nud_state & NUD_VALID) || neigh->dead) {
-		nfp_tun_del_route_from_cache_v6(app, &payload.dst_ipv6);
-		/* Trigger probe to verify invalid neighbour state. */
-		neigh_event_send(neigh, NULL);
-		goto send_msg;
+		if (nn_entry->flow)
+			list_del(&nn_entry->list_head);
+		kfree(nn_entry);
 	}
 
-	/* Have a valid neighbour so populate rest of entry. */
-	payload.src_ipv6 = flow->saddr;
-	ether_addr_copy(payload.common.src_addr, netdev->dev_addr);
-	neigh_ha_snapshot(payload.common.dst_addr, neigh, netdev);
-	payload.common.port_id = cpu_to_be32(port_id);
-	/* Add destination of new route to NFP cache. */
-	nfp_tun_add_route_to_cache_v6(app, &payload.dst_ipv6);
-
-send_msg:
-	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6,
-				 sizeof(struct nfp_tun_neigh_v6),
-				 (unsigned char *)&payload, flag);
+	spin_unlock_bh(&priv->predt_lock);
+	return;
+
+err:
+	kfree(nn_entry);
+	spin_unlock_bh(&priv->predt_lock);
+	nfp_flower_cmsg_warn(app, "Neighbour configuration failed.\n");
 }
 
 static int
@@ -556,7 +612,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 			dst_release(dst);
 		}
-		nfp_tun_write_neigh_v6(n->dev, app, &flow6, n, GFP_ATOMIC);
+		nfp_tun_write_neigh(n->dev, app, &flow6, n, true);
 #else
 		return NOTIFY_DONE;
 #endif /* CONFIG_IPV6 */
@@ -576,7 +632,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 			ip_rt_put(rt);
 		}
-		nfp_tun_write_neigh_v4(n->dev, app, &flow4, n, GFP_ATOMIC);
+		nfp_tun_write_neigh(n->dev, app, &flow4, n, false);
 	}
 #else
 	return NOTIFY_DONE;
@@ -619,7 +675,7 @@ void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
 	ip_rt_put(rt);
 	if (!n)
 		goto fail_rcu_unlock;
-	nfp_tun_write_neigh_v4(n->dev, app, &flow, n, GFP_ATOMIC);
+	nfp_tun_write_neigh(n->dev, app, &flow, n, false);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
@@ -661,7 +717,7 @@ void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb)
 	if (!n)
 		goto fail_rcu_unlock;
 
-	nfp_tun_write_neigh_v6(n->dev, app, &flow, n, GFP_ATOMIC);
+	nfp_tun_write_neigh(n->dev, app, &flow, n, true);
 	neigh_release(n);
 	rcu_read_unlock();
 	return;
-- 
2.30.2

