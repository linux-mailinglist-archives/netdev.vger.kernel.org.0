Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80B74B26EB
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350465AbiBKNOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 08:14:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiBKNOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 08:14:45 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70112.outbound.protection.outlook.com [40.107.7.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF1B7F;
        Fri, 11 Feb 2022 05:14:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtVXz58X3KTDz+5TzLb1y1e/JO4uKenk7ldSh8v6Yqf9k6gFLVztaFR3X/Lhan1W/XmXrVVh1nI7U3Gt+mt7SuA+q6BIqIJpmClGMdHcBNLEhc3HZdZK7/Bks2qO1v1UlGdFVUpJ5brE/c8RdwzmYnR5IdO2M77U3DgcY31gtROq85jfM8lEoKGWzCRPII1k5cQvJ7nqdYEsnJVNvcq/xVnhcNNp+3Ohp79+P8F1sCvcHli698QNkzWDOu30KKE7gnhbBRBGaHxPXqz9keWH9QkxFaZhBHbnQ+UUke4nC9SuyZSAPo6CBpwdJVktMSnaIzFPlg/RUZoAehhEKKtGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4g+lLdbiHu0kgDl/hDkw5r2h9lOn+QD7czEgTiGehr0=;
 b=d7ai6srj0z/KOK+oSPoogc2NI0awr2+xT/tQByn8PKwg+VHj/wduDesC6KVnzrev9r4dT1MpqEKlwiCJuOu/WD5jlq1WgzyZBIVhJxJtsqfLiAzJQk1Q6z4BMxfftNo+VE6OMITb1OrE9glxciprGzd+c6eU6vbC+rAQkb5X2LWdDlWFNu63xSOjEn88z7qsOUt7ZbE8E09VDYjAtiB307y2G8+8lPanUfKfzavgtD+ytd5QZk8b0/1lpObt1B+iSwgY8+z9elfYWr+Xtdd/h8ZKidNYVdfyvV2j7+fCAi4h1aAt0uGlbAjd3eb3bj86npgf76LmCPRqNYG+pU49rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4g+lLdbiHu0kgDl/hDkw5r2h9lOn+QD7czEgTiGehr0=;
 b=GyY/LUFVEdHgkVzx5nQSNMW/FKt7j53k7IDutK9J+e/SF87ymfWGig0m0GDh0QMmzFYyb2/yQjsMZ2MD2srQ9S8YtgqwMWDe4bykPTFW5adSF3zodonA1VwlrAlPutWDaEC4h/r2ribvs90cHnYO9gCyU+q60rU5oYwV7c39/Tw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1329.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 13:14:39 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a807:615f:f392:8ffb]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::a807:615f:f392:8ffb%4]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 13:14:39 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: bridge: multicast: notify switchdev driver whenever MC processing gets disabled
Date:   Fri, 11 Feb 2022 15:14:26 +0200
Message-Id: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::21) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e17982a-9cf1-4a83-c7d8-08d9ed6075ab
X-MS-TrafficTypeDiagnostic: AM9P190MB1329:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB132998FE333D888C99F4A9B2E4309@AM9P190MB1329.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdssnKQZ9FoHZOEErVhCK6uiygLEM5rOiH2C91Ht63S1h/PvcfzLYlchyBMomJVMqH1XxI6IZIUMPS7znlfL/HF13jSZaOXQUR/A6J1gYuYI1+Q1K4wmRbTjOjmkiDKSmHfQ4TsLWdSne6LprCbTtHFOQB0jqru+1GNFg7L8XlPJj8XqsOf4VDHwk2VgXi/Sg2pixAdA8mqyK+oUzfO8B0yNIm2AA4Jn/qQ5LjkkWqWqklPuyqORLjCLbxsfv2rqtF6iZJbppejtGWlXrGNdv/k5iv1pDDQYkDuAKSOvMjFpYGf3VmHYXi/UUDvCaCIYrSa1/y9iG6KH2VAT5xNpRfsgomoQrhpZJVjfDgCAXRLnhRTlbqbdGuLCU5flaU2cilJlz6WxdAzw9bXp7/cyNxhhw7JB12Me+cUlrHI1Qk+4KQ8poNoV2mZR8NZfbbnbQWB6etd5Imp+5xAsDTujdxgIS2ODVx28OBr3oRM3Pzouft6aVQJeKbHYw7kZMAShmFyrAqt7pN0I+g/b/I5O//AMvHQdflveWqvJYZWeKpRN/Dk2Aux/6M011A0BZpTZFehJT52LAnX1xIVQuFaiPwMWv+W8Uxcp9K7aeu0MiG/lbYo7K1Ypq86qbZQlR7RekE/u1fTo9RJm2Q6cFrtf7Y57cdBnpUIoK0O29oQco9CX6u6N/tDl9OZGHqRic636WauVXO8A2u+6lxLCm/p2LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(376002)(39830400003)(36756003)(8936002)(508600001)(44832011)(2906002)(5660300002)(66556008)(66476007)(66946007)(8676002)(54906003)(6916009)(316002)(6486002)(6666004)(6512007)(86362001)(6506007)(4326008)(52116002)(186003)(83380400001)(26005)(38100700002)(38350700002)(2616005)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eEMZgW626uzzsA2vdUAqpHbwxZrPU1gwYVuti9pnpDLTuJbRqIiNkTmGvhx7?=
 =?us-ascii?Q?Lr0MDofwNhRSM6GHQf2lwcWDdkdC85O9o6mMTf78RWsrwgK6TH29ZBGikidR?=
 =?us-ascii?Q?Uf6ow7rJUxi4I+MCp1S50jnj7ywYOuw/UVusQoOiSFXNvb7oUfCo3jpVG0vo?=
 =?us-ascii?Q?URN+XldmpGVHs+YG51/2776nXo9PK6Yib8lY8QdB1mEOTIwwm8zuVmOKxXD+?=
 =?us-ascii?Q?uMrL9TU1XGcC2Q9RqwtrpqZo8S+xAQHT7bJOcpRNoIm+lP9ELrFcJ18t5elq?=
 =?us-ascii?Q?iODt/xpGRBdNVPJ0vlq55H5YxBFwcfaAI2Us1qpIfXTlD8BjVjSMhzPOan7r?=
 =?us-ascii?Q?vULcow/IcKhTF8uemfJGnkUhQm4xi9F7pvkBsiXs0ys9y+V2i7xJ7j5sardz?=
 =?us-ascii?Q?entiWlbS2vGIHfC6bH30cnVBh9avwvfZPeQqNTMB0EsoO2yUONu02WAuCq/3?=
 =?us-ascii?Q?ih5uTFrOJFbLnPZmgUm7onm/8j4lv0/zD/KKC8hw24PuECTPpOzkWCo08+Wh?=
 =?us-ascii?Q?QuBZ2IiRpH9nA4FlnUvRY5ybnTxrCAL4UdyhRjeGM6ApKvMTfEdrC1oIz6RG?=
 =?us-ascii?Q?/r9HCWIa/+i2LrObEnjWtTnbAAdVH9DYO3RNovJoxXh7u6mAFT/HqMBJvYWS?=
 =?us-ascii?Q?ZV8VFlZ5XF2kXfgHL3/Zg1PBkPubsusjuvRfsdqqxAFvWvS1+s17QDR89nBx?=
 =?us-ascii?Q?Llo/+7kQUHkDzVBQXhT0pV5rfHFVYovfFlB+dBCQXMt6FZM8dGauAVvRUWz2?=
 =?us-ascii?Q?fvGSqzv0n5PbtBPzp6kurEXJr/8YvbfJ8EiajDAp0ja00d6mpUc9yKJmPaks?=
 =?us-ascii?Q?PdNCQ9jA3p5yXvee5W0BJ0n+8Nz0OJG2T31N/bqqfxlIsLbFXlMqxVY81z0f?=
 =?us-ascii?Q?tFWeJHhMADh7K36I+VfE8Flq7WSMVJ4U/IV7HvpZGnT42nKzet6QtSfINV/e?=
 =?us-ascii?Q?PL/ZVip5W6t6D1kO5DaElG6IdarZ5930sJ+pR0Vc0OkWOXqA/Fhbsb1aEe3K?=
 =?us-ascii?Q?O5+eKw6K0kmgPX/SzAUVvJOhWGTGUM+zZxhRvfdtYOK6LP2ZZRhEecKYupX9?=
 =?us-ascii?Q?BFpmjFvPP7/K077YzYztaOnGkkky8lH7bwq6SS6rnaXMnVWowlJsk+FZGxp8?=
 =?us-ascii?Q?68w6oFKNPYmKwuPWdOoghxTFXWQdrLufs8ersD0tdE4M9Q4Xt+9NoRW92ffP?=
 =?us-ascii?Q?ToDMBEXwXPIR8hKjL9NII6CWj2OTeR0xUBqOPj80TluzRxFamqQvD6SnU3c/?=
 =?us-ascii?Q?vQP3ZXeEsakTZNRfc0y4E30/vtYW5zqJ6NFLosThxQ7bX9w7EBe2OwiE2151?=
 =?us-ascii?Q?FZll5bgcY0jdcfF0EVCh94UzkP0YIFEPu0FJd/9zkrqw1BBHyRHefO7tQ7mh?=
 =?us-ascii?Q?tu04DOkeoH5Q3KlU7zTuDnpfkP1lp1DcpC9L2eAXmKsyWPdCfTdtMrC39UL0?=
 =?us-ascii?Q?VFOkNxrTnNFMkzCcVGf41G1di6MKCc1YirhYS1ce4/ZPs/m+USTPKI476s4S?=
 =?us-ascii?Q?XhrkNh431LwEg30L38h2/YOj1EFB9J9caPqKCbIb9032lUdWuSaRwrJ52A+1?=
 =?us-ascii?Q?RoXzb9BTN71+YkXCs4/opq8u+jArgtDoSUt/myNHHvaqeLMtnoMGuSPYLkEz?=
 =?us-ascii?Q?xXsq2DtbUukoWbRyh2/APQ7z2fUa1Qx/73JwYL1lDpThZDJrC+Z6T5YS8nH8?=
 =?us-ascii?Q?+XBJDQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e17982a-9cf1-4a83-c7d8-08d9ed6075ab
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 13:14:39.7721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aR59qBBPl4Faz9GrP6Cxl72h9+lt9ryXyO03BVtv8nZMNQzyrZpAWARqX0W7Rbeg/HyFqtJhUQUU1cJLLCdktiazAeHmjRpAWT4Ef7nT9rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1329
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever bridge driver hits the max capacity of MDBs, it disables
the MC processing (by setting corresponding bridge option), but never
notifies switchdev about such change (the notifiers are called only upon
explicit setting of this option, through the registered netlink interface).

This could lead to situation when Software MDB processing gets disabled,
but this event never gets offloaded to the underlying Hardware.

Fix this by adding a notify message in such case.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 net/bridge/br_multicast.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de2409889489..d53c08906bc8 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -82,6 +82,9 @@ static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
+static int br_mc_disabled_update(struct net_device *dev, bool value,
+				 struct netlink_ext_ack *extack);
+
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
 		struct net_bridge_port_group_sg_key *sg_p)
@@ -1156,6 +1159,8 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		err = br_mc_disabled_update(br->dev, false, NULL);
+		WARN_ON(err && err != -EOPNOTSUPP);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
 	}
-- 
2.17.1

