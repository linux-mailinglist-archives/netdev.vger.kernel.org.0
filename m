Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1532B6441B5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiLFK7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiLFK7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:59:08 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8884822524
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:59:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AneFufhXF+BF4Cyx3x5z84MF5gRuI5uvuDluhK1AeSSkIKbvBHZTnZaXw3QFyKvgLCG0ikj5eKcFiQY8lFJgGdQBUYEoutOSyBQWLEdQTG+f/w2mpUuHAp55GsSrJR5i1hxR6Qw3hxG643daNi4++qS2RPKEzt3gZSmb9Sbu2exkfv/saEOIjcTug2l0/dE5t5fKReaD95aAOE7Zzk497ci++brruRMCAxFfizH6l9fs8QonqCsHXBA7vAn8jQQYlrJhv9RGXdnUMptN382eMXmrmNKPBlGXb19fEWqAL6XHGEFsgRxUshgnBhoVC7rn9mhfBMHgbj6PFxPncjW8pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXV2/wFaM/FmM2Zuy8SrSPKa4bOiS4GZJHNko+mi8r4=;
 b=OHG/MQ8Jpxgln2mfEWGoI/x0nO0eq3Zuw8crv9LdzWpL0DJAECLsIhymyeW7LbxUFlC91S67TCwNGFun6NJmORloOl41VpHyWFlZ4KJJndpzkvAdGDDZRwVTG/CN8GC2Q4+E0A1mhVOUt7LcYcwPc/N4vSE134Vdlikwu63RsrSfocbLtfoAb1I4lG+k8KJLWuVfuSN23XwF408dNYlv+9VMBBNi25lCR3Z7SBO9nngoNG+EMvoWPGKlNGbeFnfUlRzO9MyUcOgVa94bJ8JmUTOgQ7po+UTts+b2sjDf5YM6ULfUas4B+w59KTsxspDovdo6GcrwN/2KZ+9SWog25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXV2/wFaM/FmM2Zuy8SrSPKa4bOiS4GZJHNko+mi8r4=;
 b=jzb+uccxKMLjP6bGzbShWfUZa7568z0uVzVjGoGYG2jwAkVsVJH2mrn8tNB/gKBAwTXqRHendC+FBi9OeKMFxrRGRk9HyfHlR4tyJs4O2trRt7xtut2A/lb0OLh6VyBkYKpDR8xS5cMzfeTbQinPHHAG2yw5lDrB+xETW9jO0CpRF9IvcW2cUNUQF/StlFmxa+Hwx5uFdo3p5Uzvf2RM2dvhRxKmmOfonEy+1PkmzptW4s4DmgjY8GdwAk0sRi7CBDZUPisfQsqR9oq11MZ+GApQMFUIvnBqwYf0DTxzpceJNY4dLZAIFOfvpW3MKHO5vlmKTY/P8Z2lERzrkT5dzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 10:59:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:59:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 4/9] bridge: mcast: Propagate MDB configuration structure further
Date:   Tue,  6 Dec 2022 12:58:04 +0200
Message-Id: <20221206105809.363767-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0150.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f4dd635-dcfe-41ab-c587-08dad778e2e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gPYRdnDfjmG+C/+mumFurrFdOklr+rEsdIWqjkF7WaKy99pvzR6GTOmAirF9dA4NuKvCaGMpotE6eOm3Z1SgSee6hsw5b+JpiXibuNY6gzqLa4kdhO828FEG/6MdtG8+OO83BPtNusB7XqYFCSPLONXarrLHbPGvJZeZHid5uSJtgrqN/rFbCdKZXztnxbA/QbkM85ezD/cfMQdgPqfgUL7LVFJN1RG+dl97Ay74aSb7BTEItyv09HMmcpEcOzhFvJmH/REFJwZYvAzR8h92EfNjcLcA9YuiG5YYL/mv9RMUnHcnN1aFRF18law219+zgJWU3YhMmxwKDkpRHSu/bmZg8V4LjgdPa6MjM3XRtd8Wqe5KSJiW7Ye+0MXIbTZkV3QcYuXcNGFz89YdjkwlwXrwzugQuBuZBedVAjVry58hIf66A8QM5OGc5OLjyD3cVSbke++2B3s050GwcQUbkuMMzaIfqdy57gGq7zoEht1vxcTD//mUZTwIChYDsZNPacV1P6UBDyI4eYnYrTgU6bZhwvmo8sc+2P8O/JAXRFecUBzpKkZR4nvyR3hdRTowiPRjcWYNZhWtFiyVmIdS5c1noPwtmFiLW8wIfh7bhvkm8ncZ8Xz18HTaApBOBf7+EwuEzgXnyJ5xTrhr+U7hwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(38100700002)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(107886003)(8676002)(5660300002)(4326008)(2906002)(316002)(66556008)(41300700001)(8936002)(66476007)(66946007)(1076003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lE4QNg+BUKFBOG9y762jnAJolQLUo/kxwD6npFlALoz/vD/YkqqvVEQwt/ac?=
 =?us-ascii?Q?zUiA09bD4D7uddSe0eeQgYsWvJxGUferkP2mtGur1ovo9g/WfjGLB8PmZTb+?=
 =?us-ascii?Q?dPGSguVj+YtStwwj8so+eyPMErlD7vJ1r25AWl1HFrdhxR5n0XSz7hNXRpCU?=
 =?us-ascii?Q?3o86ihpdbFt0wi4N2wxSaK2D1OudmE0S0mROjXrNHN5bUn6R98LNr7zPJgjJ?=
 =?us-ascii?Q?BGtqbYsh8npQH1L/1+a0qRkFPl7qJGhv2HCHBqACwIYJECc7XshOui6p7/n0?=
 =?us-ascii?Q?aL0dBPKEfSClWxYarTnszcJFBvuQ1M9OUuTXghw6CTl+wQ5ReiWnGL41UFXq?=
 =?us-ascii?Q?DFYbOs29SUg2f0eF8IQC3fgeCrGXUfEMdz5zELjxgyE1GlD2AL1Vn1kso+6i?=
 =?us-ascii?Q?5VMIxLPofhGL4XEp5aY7ANuofPuGj2z5YhWaXED0N9w3IXXECbo/TyEmysEq?=
 =?us-ascii?Q?r5qklosjYxi8D++q55xUYhUYHX33lhFQ5QAuqX4KhqCVjycwpqACjQ5V8VbH?=
 =?us-ascii?Q?a2nvcnLRfOea4rbc77UGO3Z5fJRlQSfC18kdJQd1hm66cW2+FCaj5j0lUsUp?=
 =?us-ascii?Q?C19oRfbNDYQBGMiVHnHnAl5oKV4J0vxFAje+S4Irod2z7d4JCPeFZG7iTyrH?=
 =?us-ascii?Q?CjpOfEj5a4QJO0ZqBg+9bJ+wQjNit0+WgkZhalntCp/KYB2SpP5n7RkFzWgB?=
 =?us-ascii?Q?cLsfgQlVmbCjnqoLqy7pi7WZlVHmVOJiNPP4PWe/eFM+dQAOWtmsalorvPfD?=
 =?us-ascii?Q?vUO7Yq91zev4+hsKQUwj7sn8ChE2Y5NOtp2HNHB39GnImAcu5zBVY3OWBDBt?=
 =?us-ascii?Q?H0ygbyoCf1SD5UXffBPdZUjAdq2f2N6xPjwLp0/AQqnNvPm1MFMpgjTo+aQb?=
 =?us-ascii?Q?TGFugcBE9tJorpoqXeQFC8K17TCnqbopZwaZZmWkfpeyw1Jirl5q6Sk4KntE?=
 =?us-ascii?Q?SJmikEyIcloBB88tAnGvYkeor4DUPuyHPOUGUP3A3xipqc7/Kmp2J83Hg8Zu?=
 =?us-ascii?Q?PpQiEjPslmsEG4BH0G3L5uYeRMzPyC2Zp4OcNMWyYGNDqovq+GAcX079lCaX?=
 =?us-ascii?Q?NFkV1yCQdwCMeXnQczABQPKAvtJgWYK+u3sMhvyGxNBxB2Kd91n3wOuD4JhU?=
 =?us-ascii?Q?VhJmFCWZqeRY7QuThtH1aEN27ALvQ/HeqQ50aQLM5mDt96EnKyhVT+is+X7b?=
 =?us-ascii?Q?g2bnwOnYhoHhPYaSq6sRTp0ufE/FKhFz0KBpjtlzYLZUwbk6KHVz1cR0gEq3?=
 =?us-ascii?Q?tn44mhY6+Jnc9fy+eAv4PtzhfdsB9DHojEKD1pZ0fl3UjRNc0mVKDItrW5wc?=
 =?us-ascii?Q?x+isUzhlTbq2WsrUDlgIP//PYRn+qLAmvirDPLnFfwAIxG44THfT6nt5pC8i?=
 =?us-ascii?Q?atQkVR3EUXFdb8v3bn0b4CBVhMesp+lX5eB2JqdXmv0I2DbIsp7UL8RToMKO?=
 =?us-ascii?Q?NG7hFvbZwHIBaj10FwF7RDTktcXDI0MehYX27gXnqKl0yzZnWWCYuQoGRyZy?=
 =?us-ascii?Q?RmXc/tMHLbDAKMVcw61BIIMCy4JWHAoXl7gQF+6CKk32BY+FOqBmwOy/KOvO?=
 =?us-ascii?Q?7FA2V4QEV3j3XVIL0ACS6wpnYWEuzGZs/wyPAVCv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f4dd635-dcfe-41ab-c587-08dad778e2e6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:59:03.0105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VU7hGmlZvyFomAkuprWfuVj6dqlDqAuST0+9lzn9Su6XNtUWWfY6xU2wZGjbnrAR5pGQHEn08ebAyPIuMgFtsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As an intermediate step towards only using the new MDB configuration
structure, pass it further in the control path instead of passing
individual attributes.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v2:
    * Pass 'cfg' as 'const'.

 net/bridge/br_mdb.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 080516a3ee9c..6017bff8316a 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -959,17 +959,15 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	return 0;
 }
 
-static int __br_mdb_add(struct net *net, struct net_bridge *br,
-			struct net_bridge_port *p,
-			struct br_mdb_entry *entry,
+static int __br_mdb_add(const struct br_mdb_config *cfg,
 			struct nlattr **mdb_attrs,
 			struct netlink_ext_ack *extack)
 {
 	int ret;
 
-	spin_lock_bh(&br->multicast_lock);
-	ret = br_mdb_add_group(br, p, entry, mdb_attrs, extack);
-	spin_unlock_bh(&br->multicast_lock);
+	spin_lock_bh(&cfg->br->multicast_lock);
+	ret = br_mdb_add_group(cfg->br, cfg->p, cfg->entry, mdb_attrs, extack);
+	spin_unlock_bh(&cfg->br->multicast_lock);
 
 	return ret;
 }
@@ -1120,22 +1118,22 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			cfg.entry->vid = v->vid;
-			err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry,
-					   mdb_attrs, extack);
+			err = __br_mdb_add(&cfg, mdb_attrs, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry, mdb_attrs,
-				   extack);
+		err = __br_mdb_add(&cfg, mdb_attrs, extack);
 	}
 
 	return err;
 }
 
-static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry,
+static int __br_mdb_del(const struct br_mdb_config *cfg,
 			struct nlattr **mdb_attrs)
 {
+	struct br_mdb_entry *entry = cfg->entry;
+	struct net_bridge *br = cfg->br;
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
@@ -1206,10 +1204,10 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			cfg.entry->vid = v->vid;
-			err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
+			err = __br_mdb_del(&cfg, mdb_attrs);
 		}
 	} else {
-		err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
+		err = __br_mdb_del(&cfg, mdb_attrs);
 	}
 
 	return err;
-- 
2.37.3

