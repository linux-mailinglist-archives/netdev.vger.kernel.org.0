Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F141602B34
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJRMG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiJRMGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:06:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2F61C12B
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMWPJ/+GNAUuAwd9LulVYTaKdvzxJsK7NeZEUwZtpSF6WIaM2NDN4gVsjfbLgBvYwO46qQRMCDjetMMmToZroMWASsjaeD92Efw1Rp27VQ6o8LqOe2JNWxwDo9poySHqptp9DwgtoFFc8uNaobBECX38bGEs5e1q9VMAZlcX/tVjfUGmpq2zJESLAN7wB4U4rnfCZh95SF2l27vB+rS0mjTHensrIFrT/LzCJaIjlSIpOxMawAD2iQdD+4FRToE0vEIvU6g87/qylfeUMJt4Fg9ZR5FCZ1SOoG3xDstIoNSjaRBBIbM0nwhZQ+KytB05aZTv++GZLSvKjh80TnlXWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7KoE8HIJ1pu5VQO2POFsxCEe9tHwXnYbaiO6W4KMMA=;
 b=Q0rV6j48WVJsCNROonzIH79LwNbr8Z28ao+EiC/mxUJVewxRHas4T3WOu6NJ3vCgJVIE8sLOfTeNJsPo5SJgOwFBqCrh4EQZWOh5T26RBFFY4J2E5RZeI9v7B/iCxOmVIJpRV5wsXtxs/hf2JYxRQnz0r2nXL3yIHUlktGOIXl2kTjxfh+k/M3jWkxpU1Kmf3CXJNZxQ3m7150XyZLwmpOap5WnyCyaj2o/M6uswEsjsvxhOaDiZq92+A/ry7Eo/4Odr7znyCW14/fu8Q4mKQdTZ0wn4HhN4CGrFq4VErT2KMMPNpjxWR5lNehejdwRAkS16WcHd2Ev32XoWeX5JTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7KoE8HIJ1pu5VQO2POFsxCEe9tHwXnYbaiO6W4KMMA=;
 b=k91U7ynCXOCUykkF3hEqrblQsC9WEjoQfeivT9jbOosCaxA26eRSuT/FX7SFsyUknXXzBK6KeYvx8FXfgyngE7WahMrLCrNl5TRFQC5DxAfhhKietasaQMmmn3Y8H8zsBLMF+FiEMJQ+TdAZpNM5tCXiK2NMJIj6vFQQQVuNjIz11IJ6jUnszydAnwE2g1EoH47vey3EO8NAWz/mfToetVfJcEvsUul0UTRmCILXUhlajvjbnFUf+llqGBWdjAO/TvsIQ+lc4v0vs/Olc6KTxFfbnQSGwYdASVuEPdvOmqbF6DME2+4pIb+qIJ8Pj6Qe4f8MPZcsvQzXOgfbti/JJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:05:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 04/19] bridge: mcast: Propagate MDB configuration structure further
Date:   Tue, 18 Oct 2022 15:04:05 +0300
Message-Id: <20221018120420.561846-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0014.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ef52b80-7b50-413c-fad1-08dab1010ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQppUnReMCcptRO07TYPRy+UxxfbMzYE1xfxfLeJrGer3XBUiGBLMGVsDskubwfVXVHX89GtDHHRNWbnhhXvKLgcqF850+RsQd+IAKIEGjYCBokoNs/ukQ+Bb4yCxbges28rUnMkLNJ9rq5Xc88JKOCHjpYwkhob5Z6Z8AQEvfXusJoMKGgKvWOrNfKWnVnZFxm1KUoJvTPcOYb/MYXaqXVWZvWx4R4RxM9IESFN5lNCHmmLr/4LywVDqzaa3PkQ52CFHtszQ/u8z7pyzLwgxVQr3o55w8pcD/9fJd2dSNxaR7Zh56YwoGKhXEzCOVHiZnamYb+zZ9YsHgZ9r4YSZqQLbn/Up0roeVsknrU/IpCGd3Zntb34zrj5ltwF3/ruUrV34lR2IF+3fDsZtu37ch3fDR84YRWx6ICkn7AYWY13qZYM52HwvKmnpyxUsvuXBPvORhhzTOkZMuTt7LicR6Ptk72ClcI8OvC9FF115V2KJQ159KGqqhSdonAT7xvxFof5HKJvs8DLt6w33vtmtdZpYO810Sdy4JbmLeXEDEEgVrxiKEJQxQnQFBzA68h3XFW+zWIWchPi9lYYVs1NRuudyI64Ykgqt+Ph06y8JdpVid8PcdX2FJeoUkOsWAnwmk95gRL5Mfy8rjKSUtqO2hcSZI1dWxBAgB+HM/T7rMPFXLBh101GEEJRoFcNW0I4b1XA7D73D9u+aXwkySeWBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(6666004)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7EMJWTW6XyWN3a3zPyE9oPKrBNX78/tSyZ+hvnTKPBvl3x4WKWPNf/PXpArX?=
 =?us-ascii?Q?AID4AHWVbla3TxkS5iv8cQo8TrujRoL7UzVSMkbsMC+IHc5b3QyzxZe8nS2G?=
 =?us-ascii?Q?d7aeYStYudLXSXvpsDDKZ3M9Y/3TSepuQllDxhzsq2l+k6htTYZgw3musi1m?=
 =?us-ascii?Q?sBg6mQGyzvQ2t60qrIr43AuCaFhdQEMndMMO8c40gNJ4jiZ7ZQe6bmqO5b6f?=
 =?us-ascii?Q?4o3FC2+pjEhGppFjETP9KIl+71xDgKkQ3Ce2NUbHJYA/rzQ8OR1aZofULPOu?=
 =?us-ascii?Q?w84jQqVtB74h/lr5YFdOwuzw3An+Yb00edYDALBGUZaOzSldEUXHkaEoVfBV?=
 =?us-ascii?Q?rUKwEe05SiG7qttbJLTQKsKr7/ALNKiZeuL7+qwmZMoavMvNeld0fZQPZ0Rz?=
 =?us-ascii?Q?TyWFQllMm/BkWiZNLj2pKGs1lxVcoZnmmNulCFyc9aaEKa/V2nxc2MDwnSNL?=
 =?us-ascii?Q?0DpdSY5oo6JjJvCKuoJYiUYNYQx2ZF1pB86AuFCsEjoWl7+HYblzcBTp/DTe?=
 =?us-ascii?Q?fOKBySmhjBbvcm0etI0hOoMTL3NFCEZuIBwT91RfFPPcymio/qiAfX1VqHwZ?=
 =?us-ascii?Q?/3AapymWKmJWApD4VdDiaFKvO6XniFPKjueOziKMY5zx9eIe+K3FXUheuVE5?=
 =?us-ascii?Q?UYQo9IefXitKPjykhdsifVTMWqJjrIyBJ2CrEDdUmFxxNnDoSdqGiWEyO8cM?=
 =?us-ascii?Q?EkEdMV7KiAJFoTnjNUK7L9S18pyr439d4+CGI0fmFc1T4bdEOSm162SsYBYv?=
 =?us-ascii?Q?jDTSg6i1TeQuyK9lJ7ygB1PqC1iWverGRKwho8YADjsrSGrEEUgVMjum9xqH?=
 =?us-ascii?Q?7OE2NY9V2R0537H1oQHPc4KYobYKPlPbTQVfqW45k3+V8Up7w0mzcMEsRnwb?=
 =?us-ascii?Q?1kTSnk/PqHHeLazfpgCL6cxjelUmfT/o7Gn+a0I70jjxNaAbQWgFoSFzyCvh?=
 =?us-ascii?Q?tn512whcMWtsjgUK22fJXvk+k61LEzrB28zbMuKjxVJBeaGZOK/wh6z7dlX5?=
 =?us-ascii?Q?p0mf73Yo6El4gMrWh47ZeGvdvgKwlYFVLHCkiZiBiQtYQHDtyfWTWr7bR1nA?=
 =?us-ascii?Q?QOKlcRIZrUj1Lm642N//yEA6za0X5JgE99RsHtq9almaXHSf52a0WAWatXsH?=
 =?us-ascii?Q?LPC7dYTzgfAYnDzlZyuXMllyWImsBRnfcq/mrUo6vAStnmcGAMQbHKmVS9E2?=
 =?us-ascii?Q?CkgtcFuGfW60G93vtLQfwJOt00JFR9fHx7P72dbdM2ELIe8EYqLuygYkeENF?=
 =?us-ascii?Q?85f1ZYsIk3uf2kvJe+Eml/bd0eMcf9rTWQLZJA/DHMyz/0k6H3GL7OK567b3?=
 =?us-ascii?Q?g7cUj55yRpAjUhlUw9PQX+/0D6idwYrqGH6tLAerDa9dTNRd/8xCBfFbyvfM?=
 =?us-ascii?Q?Qj7DCqbo6uFZrUHO7MwEx+t4l87CHJv5dCoLnC9pTVplkbMTK5StIBT++SA4?=
 =?us-ascii?Q?pnomIXXrqk0WqJ3z9OSH2LLuCIrx13MZVP7MaLH7M+oYpo36MRmTXrhvGssj?=
 =?us-ascii?Q?SFLEgNwFnkHBMfMM4bXMhYEytScfiGlbiB9aIAyx843Cl6LQx3ArB9CDa5gO?=
 =?us-ascii?Q?MWgCEKHZ1sSXLMTkLS3c/0bNK3NzaCXJ5EZhF8cU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef52b80-7b50-413c-fad1-08dab1010ef1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:33.1419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v4QVCFWUsnPW8Ag287eSH93UVtRH3YxR5eXhiVNP2WmnzjKHZTd3vxVTd43JCKcZN8sLXEL78C6VNHdEu+v1Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 net/bridge/br_mdb.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index cdc71516a51b..2f9b192500a3 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -959,17 +959,15 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	return 0;
 }
 
-static int __br_mdb_add(struct net *net, struct net_bridge *br,
-			struct net_bridge_port *p,
-			struct br_mdb_entry *entry,
+static int __br_mdb_add(struct br_mdb_config *cfg,
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
+static int __br_mdb_del(struct br_mdb_config *cfg,
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

