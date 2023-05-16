Return-Path: <netdev+bounces-3033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F90370528B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6762815B3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDF224E97;
	Tue, 16 May 2023 15:45:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E934CF9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:45:27 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2055.outbound.protection.outlook.com [40.107.20.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8728A78;
	Tue, 16 May 2023 08:44:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWYK3MyVA8z5KABk/qCXm9AFHF0mQl9RLl8my/T3RBbeMXutTgLTvQZDS5N2RUG+6pJNxEkysgKOHQcToCWlJKMW12psM8eTjfL7iZNHeZPD+R2G1oixB5KtLSzDwkq2XoXkpQLYdklVj6Zk2zVijQjE3YVZtGUGR6SY8MMfdBZ166R7vYX7svhgo7yTQVvtTPn53uC1dnRvKT3J4jOOZKAvlfC3ZacA/CsekO9fqVlBpKShz0hD7+y9nHkyBxGobdg2QXlbF9MxBrUJ1BokzH71AqN7WMl/qUu44XIiwWFwSfD9oTbIw5fbjXj9fOBBQvZEyOWuk1K6UlxvH4f1ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgItz6+LGBXMCLOpx3et6fGh8NUdfYz93TvZYNwvjtY=;
 b=hnvjUGOPe259o4/h4M58ZxeFO0OtTnH6rTLEVELo92wt/CCs2SzrJoK5d23WfJNo8cJ8UhmEvbDUr9MG2Iua2L9Rb2m+2KMcb9TeOJDQScD0rNYgdWxMPgssJ/eQ/Nj5ZmyGxWtxICCvl67xhztUAVVVY/jRYUGf22Jok8s7KrqMHjIaLNx7WcTdJnd4q+C+6lQV2ADYiuHwoYBfOuBlypwI7wY79EV1TjrThjktwCh1C9+FmM2uZqS08Mlme0GlVt5WqQppH/6Iur0P/SVDLl/70DFKdbsJtlnqLrdBTlEcNFU8x1cL3ftIV5O/88U8Zm1j6YY/Hn5tF/N6FqKKwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgItz6+LGBXMCLOpx3et6fGh8NUdfYz93TvZYNwvjtY=;
 b=L2dX28ox252ERCHKMEsAH3Ni34Syxvcoamvn/yXDDD8VRiOw+UfUFXKumXH1v+tlejmvTQpmi0+NBWVayMK0inUprOlOsJWkrmvN9q6b6g6Agy6uzf7BAgjIjvIhKerxg5hcMQWJhc08f+9Rmj/UUx64QwbYngOaRbT2F/b9Gas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB7668.eurprd04.prod.outlook.com (2603:10a6:20b:2dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Tue, 16 May
 2023 15:44:30 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%5]) with mapi id 15.20.6387.032; Tue, 16 May 2023
 15:44:30 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net: pcs: xpcs: fix C73 AN not getting enabled
Date: Tue, 16 May 2023 18:44:10 +0300
Message-Id: <20230516154410.4012337-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0014.eurprd05.prod.outlook.com
 (2603:10a6:803:1::27) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB7668:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b9b869-79d2-4d3e-b78e-08db56247002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zOif2akDFrKMcrysjGJmvThZwZ6Jo5G82q223vLMZfezK84xcTPL9HuyGg/vDSPlPaRKW+tpYiGlZC389bTzuA4T6+3tsxNnpvRKxPKlmzp/hl4L18VyK8ysXUATn9VypNPcjxkBgjnjekrbV2x/sY/o3XpogFb1izcJ9Z+jd/bPiiXUpjR66cRPXTG/GHXfxnGBjlhbLabWLQNtMsZIt3zWG2oFRakT/DFW3iUhQw4HLCjdmrFTxQmu0SpLPqpCxgTO1y/pr2aywL2pLTA7HzcLOIAHmWts8oYobATKEUMH+lZWsbENjyGirOlGL8hzDXxy87iIk5S707Qo6VUd5qIkUgEAmhPPpFYjcE4ethEoeO6Ln5WZMQhGOAdm8SLqNTFNN2QvsJMF8Uo9DIRRefotYOW01HkkPrgwQU1t7lx/BkmfdNItyP3PGSVMcw/2Rn7RiP5cOnnvoF2QhR69yf3HG5EVJzOM3k5wDdZNac+JO8UmNfOuuHzQH5kAuVfKTIbBiRcPgKP6VS2hiJBP2UQwfaNFoZg5Tht3lPZaGegBKZdfFSiq8NNsk7aiTa2dwd8TgEdz8p4KHAp6slTRbeGU77sveGKHJIuRO+G97h4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(36756003)(8676002)(44832011)(5660300002)(8936002)(2906002)(7416002)(2616005)(66556008)(66476007)(41300700001)(66946007)(4326008)(83380400001)(6916009)(316002)(86362001)(6506007)(186003)(478600001)(1076003)(6512007)(54906003)(38100700002)(26005)(38350700002)(52116002)(966005)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FFyd9+RcXWYi5hDU43BTRVBXDgaCiHI4RmdqH3QNHmVg6IbgKcrToiSF/mg5?=
 =?us-ascii?Q?D1VzHvup+ggOX03KDjM35e0ysdduW3PVjoxWw5YSNjCOMHI5uCRJI17AMVhs?=
 =?us-ascii?Q?zrwT8RmUYwRU0d8FDhH7wMlNyqk0bHPEpEsBeoqLZaJ9hPRiKUu8fLV1AWEk?=
 =?us-ascii?Q?3g2AHES3LZFjMsDOH+wiHmkWJeM2/XJ0UBsbrk8IRVbopH98G9I6qhNgfYgn?=
 =?us-ascii?Q?pFl/QdUAQbaaE79aQN3Nl+ATeizq9bTuvWWT8MBCW0SOpqJQaxjrDNZBsWwP?=
 =?us-ascii?Q?zphvsFBbtCey5+ArsxyitW1BjhH8NN3ecRYDWhqTfaF9he3strPHR5WJE1fF?=
 =?us-ascii?Q?BqnjmrmHyxdqzfXIIS7CXMVRRPLdQWBjP6/1Xl1aeBnoGPrZ/K0t5aQTmiyT?=
 =?us-ascii?Q?VgdwrtmBUAVmp/HmWH4WGixuryRfn1+Z8PwPAjBwB46m4fhCQAnNcNZaSxAY?=
 =?us-ascii?Q?4KaaTBtsNTGO2jP5K8SmYJBjTx0lBG+JiJ4tSryx56Lz7Y8HnutuwPaA8+SP?=
 =?us-ascii?Q?L4kM/MUHozlmuJC7tMA5QudaYxvSgjMe0MBLqgDXgHvd2oefdu2ZOwlbEQxb?=
 =?us-ascii?Q?UUVxP7esyD6PlN5jCRsAtfkWf6kUoGG+dPdNSkPJg6zdTko8FSKjHOqWAwN2?=
 =?us-ascii?Q?sT++b5wxboLl7zEdSUm/rWXqJZOA3UaRiUbLe+Fm4vcKoAgEavSLHyDneZfe?=
 =?us-ascii?Q?JOGs5QEnELhqbpwRlUdl/ChxPCVavPjRuK8k02OhLZ1wtNBWeVZvCPhz5zvt?=
 =?us-ascii?Q?I6wp4bJgx64ct8MAf97N5WrwQFNZWVlPaIbkNqSZp/Lus9Do2II/F8CltD6I?=
 =?us-ascii?Q?BHmi2krywb30QbAK4iDEy04AW+0WkzzFuDQEapdiLYP0lo9zRT3NsLI/oVb/?=
 =?us-ascii?Q?/tfsTiqUSxLir8dZPIPfo8MZNa+xQfYa/72dgITx8aoHASIiSET1NOlevD4n?=
 =?us-ascii?Q?AhA/An4PE5F/Yv9D+6HHBJtnue3w8968PX9nPHrH0Jiquc7i6gzVGCPtPe8j?=
 =?us-ascii?Q?9UEimDW8n1H54GVArvr3KWy8418dzqYYZ2hGmc1gxa7RlEjUGO7PTm108Z92?=
 =?us-ascii?Q?WEGk+UFTTw3eijeZKe/CXJ/WGmsBLj7//uE2neLb6nYqcAWZk4bjbTSSqjiO?=
 =?us-ascii?Q?ZhihVBY0Lxbifnwq51LIqmniEOaoT5eVm5W2D+P5rOBwnK0SeHEnwc2evem+?=
 =?us-ascii?Q?o5LDGJfZy2XuAlurFtAsprp3MO6/7IeLhaZ8PM6Zn+bbCpgVQDiFjofx4FmI?=
 =?us-ascii?Q?KAqbd3/4l2gWpt0dMZqaV3uoaXZb65SERI/9bJp0jSu+b9/0dFU21T0rGkGs?=
 =?us-ascii?Q?nhyVfYLLlGu0uYS13yAP0iCZBn765aWkxgOyp63xw6MOwsr5zu61y36+frtU?=
 =?us-ascii?Q?0FixeSrb5EcgDoK+TUREdCZgbIBmwCBPTk0m7XYkMtD/VEYlOTS+VS12Pe5p?=
 =?us-ascii?Q?DxQvAu70dGptv2WP6pXpjxnf3GF74YCcfVVERHtCQtIcl5aZtBzNkN5OCLC1?=
 =?us-ascii?Q?GNRPnx0gNT9spzJshBPQOgCZfw1FG9l0aocmyDmnRuu1Z2/WAZIlyNWpkBp7?=
 =?us-ascii?Q?vEM8J5jR4V95eOcIQncZheAtq3Ej3HPAsyt837VzoZfcGVY+XYFjUrOipp0L?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b9b869-79d2-4d3e-b78e-08db56247002
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 15:44:30.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32zkwaswPEIJB80nJcFWEuhqbrzAN9ijVQt1ZfJRUqWH0XSXUhfRrGJ5peLXFaFgc1orlTCHogJ9DzLymWmUIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7668
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The XPCS expects clause 73 (copper backplane) autoneg to follow the
ethtool autoneg bit. It actually did that until the blamed
commit inaptly replaced state->an_enabled (coming from ethtool) with
phylink_autoneg_inband() (coming from the device tree or struct
phylink_config), as part of an unrelated phylink_pcs API conversion.

Russell King suggests that state->an_enabled from the original code was
just a proxy for the ethtool Autoneg bit, and that the correct way of
restoring the functionality is to check for this bit in the advertising
mask.

Fixes: 11059740e616 ("net: pcs: xpcs: convert to phylink_pcs_ops")
Link: https://lore.kernel.org/netdev/ZGNt2MFeRolKGFck@shell.armlinux.org.uk/
Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
The only (paranoid) test I've done is that the sja1105 driver (which
also calls xpcs_do_config() outside of phylink, and provides a NULL
pointer for "advertising") does not crash. Which was completely to be
expected, since none of the nxp_sja1105 XPCS compatible modes uses
DW_AN_C73.

 drivers/net/pcs/pcs-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 539cd43eae8d..f680d03863ff 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -873,7 +873,7 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 
 	switch (compat->an_mode) {
 	case DW_AN_C73:
-		if (phylink_autoneg_inband(mode)) {
+		if (test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) {
 			ret = xpcs_config_aneg_c73(xpcs, compat);
 			if (ret)
 				return ret;
-- 
2.34.1


