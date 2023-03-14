Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537A46B8B4F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 07:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCNGhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 02:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCNGhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 02:37:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F0096C05
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:37:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjnLnO8mhOOKfiUgF7BallrBziZfaa+cjHePdPdnvQAB9yavluoAEAleLK+B/uXOlqoghASQPlOt8rNummctdcnaRnGRsNXIIzC/i/+ExE+rX0R3JP51K5MWvVEHxn1i/vSrH50ZmwpthES8MjRkATg1MbY1IjzZYltz7+GuwxXujsH+DSTkC8fETATfhiyhsMbltoNhwwmze4dcW/KItx2Z+fOhHGjy5qzoDfxufll2uug4f8NxgWNKJ8rIXEor/NlOvSJoDwB+Q4pnWG6RQy1O/Ctmu433KZiz7rP7sX/4AUiSdJgroh2URA5Lb6S/X69vUdOblvz4m8xQvcE8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7R7hSp8KiKzZeWFu4AIRWKKRbcbz5GPqdzrp4gDuY6M=;
 b=HfqH/giHhDdZe+lB6Z/NMhFIVh0EjwjOSa1Bth/ND3nrN/DjEL463OTtZhqZuE+mopZb/A74WDmEqZQcCCs5PR1XrdLZzZGKh2ysAT0cLZGnskYABV70gpFObb5YSUl5LT44/iiNERjsFzqOPuXUcJLoakinrzsEJKJ62xd2Ep5eRC9Wj19Uu6G3nSmV43xcimT6K8Ba13226Z1raL+Urz1fRkBl2Tqo3YEO+nLE+dkkvFJ/1Rut+vJ/+1qKULEl8lkPlSikbKs9Uis9YBIJFTxeZnVNYTYIDgyjOrwEMe5xQ4mly21czAuOZuxaVTNa1nVgdIS0qWkNoKLefJCijg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7R7hSp8KiKzZeWFu4AIRWKKRbcbz5GPqdzrp4gDuY6M=;
 b=Re2qHTott6RdIh+w8C+DaR0mSRtSnvAcdVuhz4hayEa/jFrjltS+HZf9J+lpFR02VPQWfJ58HSy+Pu62e+gRe1aPr5L3Ij6GtDW5RJqUozW6KdTGSPsNEiMpma/EgB7XCTJgNG2b2JZ+H5+MmvFjTsKjbP3mZHshPmmEFzT6B/4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA0PR13MB4110.namprd13.prod.outlook.com (2603:10b6:806:99::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.26; Tue, 14 Mar 2023 06:37:15 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::c281:6de1:2a5c:40b8%3]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 06:37:14 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next 5/6] nfp: flower: prepare for parameterisation of number of offload rules
Date:   Tue, 14 Mar 2023 08:36:09 +0200
Message-Id: <20230314063610.10544-6-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314063610.10544-1-louis.peens@corigine.com>
References: <20230314063610.10544-1-louis.peens@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA0PR13MB4110:EE_
X-MS-Office365-Filtering-Correlation-Id: afca909d-ce73-4564-060d-08db24568c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hIFJlf6gNQHvboquwIGwAF/lUe+iF/aDPaPXleZc1B9zFhShUDtjzm8GqImka2lYMvvKthU+YNBx/8l7yF8V5Krqaac2eXadrifa59fJsB1EgyU8fnPVap/5qrXp/V7gzowZHjrmLKAxOOMNEgy/00rouhcLTuKmoL5UgZXIuP9yit+CUR5yZCLOSL5J+Px3nnYzS+8YPwpSC2g+7QRUOgnznKaPiC+Ow4N79ecH8LJfvH8RRKZC04H3f7Ux1hjFRVf1+k4z1TK06yxZoy/UFFBKl2tBfu+BNR7jIZuukJ9S0ofnTWDbXJgrSfNLGBSDOt+GX5SZ0XDRRJjbQr7gZzDrwVf1Kzg/mcLzfQEytOG0L5qt1abfucME5eiEsrrI84h8IWkjp97KU1TaLggFOcv5vX6o9CZvUIGKASG3X6NOGoMpnYrgSWWmrgwh12hR7ahQl+Cr/GggihfasO0I5s/7b6bdbuRYq4R0cJ5xW4XSMPN+G2xpDU52cDYnmb0JrgwHkWgFsLM9lUafc4SQgb9nuvJUYD20iGiaIktP+dU7YPrqs9z/WK/odcioBFkuowrxolRYT/a48WR9p7vw9Da/ACEAy/6v5Q3WWoujrxRGAgUN5vVZlaRfIEI6C72tXtxp768sl/4eKHrg1TyowqDT+boEQ6l/5f1y28FVz2Dbk6qPpkzFiYyF5HQ57mbmzM5ONN+sChSBVE2kP30Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39840400004)(376002)(396003)(366004)(451199018)(41300700001)(5660300002)(44832011)(2906002)(86362001)(38350700002)(36756003)(38100700002)(8936002)(52116002)(478600001)(66946007)(66556008)(66476007)(8676002)(6486002)(107886003)(6666004)(4326008)(83380400001)(110136005)(316002)(1076003)(186003)(6506007)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3BvIXzKfsruXLnsEKywm6NBZhmrZvZBm99ZHzJ7jNUsU5tksuxN6HEw7/YXo?=
 =?us-ascii?Q?Qn4cdvXM6raL4DdpOoWwmhd/uYz+nBnxtYp4kZF3j7WZOcQAOkp6glNrfh/g?=
 =?us-ascii?Q?BlIfic+yGzyxw2b8LXCCTgC7QMQI38tyRm44HOMQc9Ab0xZnUYG2Qodx3r26?=
 =?us-ascii?Q?fdvAKZZhDk6//2bYjMyj72pmO3Wxmoltknc6/98shrOS7Ps5pvT9MlKKepHD?=
 =?us-ascii?Q?QIGiHImiuvx01fly8Nw7fE801wZYO9Ck2W4bRK/c7oID31Q9RwddDh9Qn0P7?=
 =?us-ascii?Q?CCtDVYOwd4yvzZ9tnehib7OKA90kyxKol6AvGOanpyAnRmDAqgvu8oo2FQ+r?=
 =?us-ascii?Q?7fOrv4706JA0mRP+uVilkAX2WiWvsY9T4j+Bc/qu35RLLZXqCcE+Y7KfDaCa?=
 =?us-ascii?Q?q55lUvoBigczL/sKIV7i9xOGmO/RLFZwVjtvrUidiNvNmizJ9rEJVM/GOVl0?=
 =?us-ascii?Q?D++orZnBxyS6AmcDG1D61UFjLAdRU+VmyTpKu/2O9muIFL9Ppc/F4Tll91Ij?=
 =?us-ascii?Q?1ul9z6iaBhzyraI6Qlvhogd3Oj9GJ9ggIv99j6LVDuDngQPi96GxzO/e9juE?=
 =?us-ascii?Q?mkxHdbzeVA69b4vy+eCTrQVRYj4QxAdDPIeg82lgqhiWn7i/lEnH14z0JmUc?=
 =?us-ascii?Q?TnfNXKcbYdpnsZ8Gc1zAnteGiqLDO2EhR4b6mPAbORGHFeClB2uiay19qBJ+?=
 =?us-ascii?Q?uYdHtf3EfXqbUgSWI4/TD/PLxJ52UYhOdVzm7C+69e1xMX6F3ONbi2ditpd7?=
 =?us-ascii?Q?VVxwvzrYFGtSMebsd4yqXbcfAmS4JLS6LtY3bF68AKu3a1SAvJansq4w9zQe?=
 =?us-ascii?Q?fGRaDH1UKd0LQ89xXd2YaQyPYhs8dsGF/op3ERBpPAswd73pzzVxAQZ9EQls?=
 =?us-ascii?Q?yKVzKhLdAL08s5OQVCPpBO68KJ8+s5Wjpegl2mOqCDKNRHsLkD1w7dib1+D+?=
 =?us-ascii?Q?Xaom0lzQs067UEEGkC/AA2b2N8hqhILhNe8lY+OUXVTtsywBIvUTjbpd5xvk?=
 =?us-ascii?Q?MwG3I/6+jA36AVQY1T5MvTGxvXgf46FW9R1z5+wzdvFP+NDin4TBAc17ynEO?=
 =?us-ascii?Q?tV8TyhTMdkNtG8K/gQ7kPiUNyh3/T+DTzJE7LLGaOpMvuuLYoJKHhLYkyObT?=
 =?us-ascii?Q?jJYu4BcCNaWa0Hx5xR1KyowTYSeSzubRWYqUUdb0e0QNeguI+iI50JWGzhds?=
 =?us-ascii?Q?Q0666YDKDBJ27vxm3i/lQuxXRH803Q5BNUKBXw0bFKUSweri0kvXtWfQ6xsd?=
 =?us-ascii?Q?UVVI+LQWdPMRZHnRjQ+uY7waMIzp84417R/NAuJpvbJSjmV2Q0vLKgGdxFij?=
 =?us-ascii?Q?ku+DQn6vsRt2mas9wFDx9TxsdrOhmWvMUOX9p1sAxPxGZ4sNKAhe6/MYl77r?=
 =?us-ascii?Q?iWa2yekG779XjF8QKSaUNlZNew2gpsrfCHyNq25/CA9PejfmwQr0d1SVaggs?=
 =?us-ascii?Q?XUZQl3DT1OYtQ6vfW2e18g8BKAzRk0a/begcCTZBedGV30Z5Jz6VAx3Rf/hQ?=
 =?us-ascii?Q?19ZjCrv7APRAfZFQi/iE0nEK2r57p6lH1bJtdalXwGzwfuEiazNV/TSOZycB?=
 =?us-ascii?Q?UN1ej0fUK24NIUKNNPomGwLoRIH7l8nlHGQrh3HnCXrPsBvdHUmoz7gpWqBu?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afca909d-ce73-4564-060d-08db24568c99
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 06:37:14.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sX/YuHK1aj8ng7RCUhbxE/n7+sPpjCYs/Ozqx2veS5Nn7v4Y1rHi5XfR+RTh/wu+nEaiMB1sGWfHxXacJtr1TFFxtZ3EjnfA/Dfix9fmM0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4110
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wentao Jia <wentao.jia@corigine.com>

The fixed number of offload flow rule is only supported scenario of one
ct zone, in the scenario of multiple ct zones, dynamic number and more
number of offload flow rules are required. In order to support scenario
of multiple ct zones, parameter num_rules is added for to offload flow
rules

Signed-off-by: Wentao Jia <wentao.jia@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 54 ++++++++++---------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 86ea8cbc67a2..ecffb6b0f3a1 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -693,34 +693,34 @@ static void nfp_fl_get_csum_flag(struct flow_action_entry *a_in, u8 ip_proto, u3
 static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 					struct nfp_flower_priv *priv,
 					struct net_device *netdev,
-					struct nfp_fl_payload *flow_pay)
+					struct nfp_fl_payload *flow_pay,
+					int num_rules)
 {
 	enum flow_action_hw_stats tmp_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
 	struct flow_action_entry *a_in;
-	int i, j, num_actions, id;
+	int i, j, id, num_actions = 0;
 	struct flow_rule *a_rule;
 	int err = 0, offset = 0;
 
-	num_actions = rules[CT_TYPE_PRE_CT]->action.num_entries +
-		      rules[CT_TYPE_NFT]->action.num_entries +
-		      rules[CT_TYPE_POST_CT]->action.num_entries;
+	for (i = 0; i < num_rules; i++)
+		num_actions += rules[i]->action.num_entries;
 
 	/* Add one action to make sure there is enough room to add an checksum action
 	 * when do nat.
 	 */
-	a_rule = flow_rule_alloc(num_actions + 1);
+	a_rule = flow_rule_alloc(num_actions + (num_rules / 2));
 	if (!a_rule)
 		return -ENOMEM;
 
-	/* Actions need a BASIC dissector. */
-	a_rule->match = rules[CT_TYPE_PRE_CT]->match;
 	/* post_ct entry have one action at least. */
-	if (rules[CT_TYPE_POST_CT]->action.num_entries != 0) {
-		tmp_stats = rules[CT_TYPE_POST_CT]->action.entries[0].hw_stats;
-	}
+	if (rules[num_rules - 1]->action.num_entries != 0)
+		tmp_stats = rules[num_rules - 1]->action.entries[0].hw_stats;
+
+	/* Actions need a BASIC dissector. */
+	a_rule->match = rules[0]->match;
 
 	/* Copy actions */
-	for (j = 0; j < _CT_TYPE_MAX; j++) {
+	for (j = 0; j < num_rules; j++) {
 		u32 csum_updated = 0;
 		u8 ip_proto = 0;
 
@@ -758,8 +758,9 @@ static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
 				/* nft entry is generated by tc ct, which mangle action do not care
 				 * the stats, inherit the post entry stats to meet the
 				 * flow_action_hw_stats_check.
+				 * nft entry flow rules are at odd array index.
 				 */
-				if (j == CT_TYPE_NFT) {
+				if (j & 0x01) {
 					if (a_in->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
 						a_in->hw_stats = tmp_stats;
 					nfp_fl_get_csum_flag(a_in, ip_proto, &csum_updated);
@@ -801,6 +802,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	struct nfp_fl_payload *flow_pay;
 
 	struct flow_rule *rules[_CT_TYPE_MAX];
+	int num_rules = _CT_TYPE_MAX;
 	u8 *key, *msk, *kdata, *mdata;
 	struct nfp_port *port = NULL;
 	struct net_device *netdev;
@@ -820,7 +822,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	memset(&key_map, 0, sizeof(key_map));
 
 	/* Calculate the resultant key layer and size for offload */
-	for (i = 0; i < _CT_TYPE_MAX; i++) {
+	for (i = 0; i < num_rules; i++) {
 		err = nfp_flower_calculate_key_layers(priv->app,
 						      m_entry->netdev,
 						      &tmp_layer, rules[i],
@@ -886,7 +888,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	 * that the layer is not present.
 	 */
 	if (!qinq_sup) {
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
+		for (i = 0; i < num_rules; i++) {
 			offset = key_map[FLOW_PAY_META_TCI];
 			key = kdata + offset;
 			msk = mdata + offset;
@@ -900,7 +902,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		offset = key_map[FLOW_PAY_MAC_MPLS];
 		key = kdata + offset;
 		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
+		for (i = 0; i < num_rules; i++) {
 			nfp_flower_compile_mac((struct nfp_flower_mac_mpls *)key,
 					       (struct nfp_flower_mac_mpls *)msk,
 					       rules[i]);
@@ -916,7 +918,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		offset = key_map[FLOW_PAY_IPV4];
 		key = kdata + offset;
 		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
+		for (i = 0; i < num_rules; i++) {
 			nfp_flower_compile_ipv4((struct nfp_flower_ipv4 *)key,
 						(struct nfp_flower_ipv4 *)msk,
 						rules[i]);
@@ -927,7 +929,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		offset = key_map[FLOW_PAY_IPV6];
 		key = kdata + offset;
 		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
+		for (i = 0; i < num_rules; i++) {
 			nfp_flower_compile_ipv6((struct nfp_flower_ipv6 *)key,
 						(struct nfp_flower_ipv6 *)msk,
 						rules[i]);
@@ -938,7 +940,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		offset = key_map[FLOW_PAY_L4];
 		key = kdata + offset;
 		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
+		for (i = 0; i < num_rules; i++) {
 			nfp_flower_compile_tport((struct nfp_flower_tp_ports *)key,
 						 (struct nfp_flower_tp_ports *)msk,
 						 rules[i]);
@@ -949,7 +951,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		offset = key_map[FLOW_PAY_QINQ];
 		key = kdata + offset;
 		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
+		for (i = 0; i < num_rules; i++) {
 			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
 						(struct nfp_flower_vlan *)msk,
 						rules[i]);
@@ -965,7 +967,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 			struct nfp_ipv6_addr_entry *entry;
 			struct in6_addr *dst;
 
-			for (i = 0; i < _CT_TYPE_MAX; i++) {
+			for (i = 0; i < num_rules; i++) {
 				nfp_flower_compile_ipv6_gre_tun((void *)key,
 								(void *)msk, rules[i]);
 			}
@@ -982,7 +984,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		} else {
 			__be32 dst;
 
-			for (i = 0; i < _CT_TYPE_MAX; i++) {
+			for (i = 0; i < num_rules; i++) {
 				nfp_flower_compile_ipv4_gre_tun((void *)key,
 								(void *)msk, rules[i]);
 			}
@@ -1006,7 +1008,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 			struct nfp_ipv6_addr_entry *entry;
 			struct in6_addr *dst;
 
-			for (i = 0; i < _CT_TYPE_MAX; i++) {
+			for (i = 0; i < num_rules; i++) {
 				nfp_flower_compile_ipv6_udp_tun((void *)key,
 								(void *)msk, rules[i]);
 			}
@@ -1023,7 +1025,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		} else {
 			__be32 dst;
 
-			for (i = 0; i < _CT_TYPE_MAX; i++) {
+			for (i = 0; i < num_rules; i++) {
 				nfp_flower_compile_ipv4_udp_tun((void *)key,
 								(void *)msk, rules[i]);
 			}
@@ -1040,13 +1042,13 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 			offset = key_map[FLOW_PAY_GENEVE_OPT];
 			key = kdata + offset;
 			msk = mdata + offset;
-			for (i = 0; i < _CT_TYPE_MAX; i++)
+			for (i = 0; i < num_rules; i++)
 				nfp_flower_compile_geneve_opt(key, msk, rules[i]);
 		}
 	}
 
 	/* Merge actions into flow_pay */
-	err = nfp_fl_merge_actions_offload(rules, priv, netdev, flow_pay);
+	err = nfp_fl_merge_actions_offload(rules, priv, netdev, flow_pay, num_rules);
 	if (err)
 		goto ct_offload_err;
 
-- 
2.34.1

