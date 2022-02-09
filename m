Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1B54AFF39
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbiBIVbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:31:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiBIVbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:31:09 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C162C0F8699
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:31:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCDFOBWPAkDHoCNA3eE5ctA7PufpgZ9UpHGuEJyiPdwYC9OJw6du3Eghhf5DuYUvGLGhPgUCD3awWaYYYZk6ln2duiNdEZqxTsjFYI0ltM1AOroHapr/SjvIc9R4fNJVuo29B7JMENVTL2eeOzVq1Emed9LXc72+IcwVAxSPGA4LyKYAT1e7KgZ6kJ+7W//p4J7Fi1V8Hn7oGhCZc/jES6Qxp80WbgskonYL2+L5fDBeVjQkwFhX6X2/Vm9M88VNKG8rSDHJK494nLgXRVZ/q2PHhFFyqzl4SOqdEwc7nB7Zi1e+V/I2uMD1Nr1O8OI4crdehK+QngKXlKTfD6uK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3rDtdiNb6ZhbjMTxnrNyarp2x5JpjOLJ3C0LfF2zu8=;
 b=UKUwbhwN+/nRWoy4teX0ExVmFdZstPXViWgZmCgZ7YDpVqOOpljtx6GONPv6ogrSWSyLhhmSKC0iv2xtt36lDkVNZTqIr3pPEas8tI0G3BbhRGG28SV8vaNl9X/CHs1yYqUIkORgNW/492DgHaD2AKc1Kzs06NNX5WuwL+KvjgMoM7wNd2SfG0CYLtgu3XBEfUqC86+yLNd8KV/lsBWBcFT7b0wNnwfy9swsgt0hl6mbuTYzSmIc9FZg6AuKyAdSQIzCRe6t1G37YsHtJr/zKFZU7oiy304KXZlBiIr3iBL03k4UFCkwrLk7IO8GaFDkzIbR/dEvO5BvCIS/6/en1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3rDtdiNb6ZhbjMTxnrNyarp2x5JpjOLJ3C0LfF2zu8=;
 b=i3k+xf0c3UxvQ80KblKIQ7Cjsr4isC3igD1faQT1XGGOKVrEpxwmJgUOVvWJaJAyHa0npD9xqfa9v34wo7ZXVCKEyErnuuYanuevo7a8UEBByN90xHvN3k3M38p3wk4bXLMqpQNiNFgzhYhAy4L+jBh+8i8QUnPsQrF1zsvrpOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:31:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:31:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [RFC PATCH net-next 2/5] net: bridge: vlan: nbp_vlan_add: notify switchdev only when changed
Date:   Wed,  9 Feb 2022 23:30:40 +0200
Message-Id: <20220209213044.2353153-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0077.eurprd09.prod.outlook.com
 (2603:10a6:802:29::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67a98126-d32b-4392-2122-08d9ec137aee
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3481:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3481BA034C1A2DD3E11EC6E7E02E9@HE1PR0402MB3481.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZzCQEPsw8HXQswi1acHnjOQf/o/yokomwJJ0x77sXMtwRuDqWbXjWYZoPqL8b1imCRcUpFGC+P04kNcvEZ0xbr+/sm7NOCc5zEd8D/P+KoGD7Kh0vjEhixg+v2ysOfQgU/rftaO58B4OElkVJJ46riF+A1HgeiccOSqvbgDS0s0UyarE/feJcws2xVPXhTLf4KfTHHc7Tc7CZSvqupoDs25onmvnJZ4QQ46U+amJUgcVgPDGKQQ3pjpEZwUoPTBdorUZyayNvCdCLdjAwHeI/Q6sMQKsF9Qg9JHrNJYo6qLjTvQNsq3j2VZc7yjesmqvJ1nKPGgEELB8Fy9Kfy6/k/GrH1SdIyZf6psgOjbLP+dM5V5Gc+/gG+ofMBBzGTvnsW/ptRxs/oofNU4b7rPjzqLLqsYmwtEnqlJcxHARwaBmkslHM2BtaiyHSV4Y3rOB3zRmfMO7eIxoa3eMw7/FFLzxaxycyDTfuAzUo+RYSKG5FK+RjrHsvUG7o/O3Wqguu2I57ZhhIcQny55WLIsBb6No9fbsXM8IETYqGP9Ru6dou7gQ5xFYF3cGp0QGhITkSoqqncZeD/2H0hu6fZOfDUzMKz2ImBRWKdqjLl68kgyjTNyjw2qNWrCzD1WNl7JbD6jUou6g8rVoHtv1rB4USw33bXfztuT6pUxgLjnfXkGNujJeh9nwcRB+977kF4e2sNY8uQl72hTZW8ot0Az3sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(6486002)(86362001)(508600001)(66476007)(6916009)(83380400001)(5660300002)(6512007)(44832011)(52116002)(8676002)(186003)(26005)(7416002)(1076003)(4326008)(6666004)(6506007)(54906003)(2906002)(38100700002)(38350700002)(36756003)(2616005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mfKK0UNFyoEMYCrHwVGUxbI32tWEO3hdsia/qHN3a7sRF5FvvG/ciSnci7Rl?=
 =?us-ascii?Q?vF80a4sGm+mOt+iIDAA6T2ZK0OMWEZrbV/EKn6O7uSRIYtrpgUhgNAPtcv3E?=
 =?us-ascii?Q?WnGhjPbMi2n7B5DixY8Z3xbUoN9PBOusKwK7IkS2anxbJOC4TefLlpOfIBlA?=
 =?us-ascii?Q?ceA0jyBAnuNSejECV1BNv5nmwsFTVKNHF8YfHZ1MBXS7vvMyN70rNu+v/NuM?=
 =?us-ascii?Q?5k02wIDShQ0pkG+9jiDt8kz2ZMj8qcJjV8eqL7FkhpaXSpwvsbJSy3Mxk2jV?=
 =?us-ascii?Q?U8ofe6HYtLnEk/lEG2VKJjrrsPwlM31+JPNM3yiD7onTeQEjK7WZ9i8a3XhL?=
 =?us-ascii?Q?iZ6rfMiGwGWvUG0DRpPtGKctFnahHoiGA4/4YVy3Ts+fF02tPzSt0j8OoLTQ?=
 =?us-ascii?Q?nE0Js4UwE+lV71jJ2y9De3MjNMbZ9L5+F+1BkxVdidqxHlobog12rblds6XT?=
 =?us-ascii?Q?//eAob2/3xWxzw9TGJ5OGH1B6kQCw473vszp32huKS+c9OlPLjZh9IDitwoD?=
 =?us-ascii?Q?Mx4eQCIN6uvB3iNJa6mianl5y5szyLmoW9Q5oJeCm4aI9lPZxepK8pg2e3M2?=
 =?us-ascii?Q?hPHDEgj36lxDsIskzGUxD1+NkPQZ3QY9CsO5HMdeuOUylAxkqztVFiZFIyzT?=
 =?us-ascii?Q?evzc+HILhQC8kYvKvgHgUNWBFeNLrn99OAn4iHC3V+kOEfv5pep+AbYGx7s/?=
 =?us-ascii?Q?/vLOAN2ciTk57Y6ybl7rHtKUNkrm9bNX11EUiaPFI+sywPYMs1NcxbYT+sTl?=
 =?us-ascii?Q?EgsOWOlmBFTSul+ymFw32+CDpzxeqWdB/TguNyxQs8CrNHT2EHfAM1wvTk+p?=
 =?us-ascii?Q?JcVPjySsfpN9LAdaRRg+YIh+mFnSxY4+naU/qU5FeRW9sPYtvcuR8mR+wE+b?=
 =?us-ascii?Q?HtsorS5ccxMF4o0ncMDr6YLc5IjoALpI0aUwcj0lDxGUo14iNDyIwoFuoaWQ?=
 =?us-ascii?Q?+eYD91W8oxvUpIZgK2iPDTfrKw0lkkZwyzenpXSHVzT1HprHwiLtqUoF789j?=
 =?us-ascii?Q?fwFmnvXjjEfaWuyd4BVuDUYvWA6q9iMDQr7vS4XKsuNkZXUiQPOnBtV55i5E?=
 =?us-ascii?Q?xRn+LbuDmsGF9CU9LdoP6Ioh6YAxtcnN4M/30Wy34i59/fVNj7+ZFU9y4P7c?=
 =?us-ascii?Q?oE/OfYxens8xjAmWMZcnPPr2dzC6cfunU46Vi7QFKGGNZaeJt9kjYIW6KJNO?=
 =?us-ascii?Q?AqgcxNKvMs3ACn9pOJ07zxiP1HRUDtALvx2EPP6H+E2mfOkhL+rU5kYZetJq?=
 =?us-ascii?Q?1wbQ8EyS8u7NdxpnUDWLymUH0H47bwgnMHN4Y02Wt8W4WiAuyFk59h9hi1e1?=
 =?us-ascii?Q?bVB+uFt91GquLBzAGGuqVcCdXxWQVcsWyc4AoiDXDMTpDbd84Mc1wO6PJ5U4?=
 =?us-ascii?Q?TkWk3Qs3QIAYxKStun3u5zKc+2SGmBw5WT7DJFuHvE2C4c+F0hsXDM0mG4oO?=
 =?us-ascii?Q?K6GuTpLavs/Yl3Xnx4PsDlbIe7iEA+YVmUwWv/1WbYZJmIqpU8+7W1n+QPTS?=
 =?us-ascii?Q?St/W7Fa3h6FpTb4GQK0hIJrlzdB4z9DM5nup7QgGLhgqzIhbEKc0Ow31DVUu?=
 =?us-ascii?Q?iijL5+frXPJg7FoHz9rZ4cplAS5kYDz64V6OCo3M/0xR2yYRNs42ouAPTXMc?=
 =?us-ascii?Q?vytH3oLabxCOMKtJ+jfEH8g=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a98126-d32b-4392-2122-08d9ec137aee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:31:06.2314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHKxQK6EdIo2DUMGQrmSioXRJHoR6WKQy/I2OvI+wB9MvqxIR4Nf4ww5ZReeq+VxHcC5ZrP5PXpnrAPg24xfbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a VLAN entry is added multiple times in a row to a bridge port:

bridge vlan add dev lan12 vid 100 master static

the bridge notifies switchdev each time, even if nothing changed, which
makes driver-level accounting impossible.

Since nbp_vlan_add() changes only the flags of the existing port VLAN,
record the old flags, and restore them on the error path of
br_switchdev_port_vlan_add().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index c7cadc1b4f71..3c149b54124e 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1279,11 +1279,18 @@ int nbp_vlan_add(struct net_bridge_port *port, u16 vid, u16 flags,
 	*changed = false;
 	vlan = br_vlan_find(nbp_vlan_group(port), vid);
 	if (vlan) {
-		/* Pass the flags to the hardware bridge */
-		ret = br_switchdev_port_vlan_add(port->dev, vid, flags, extack);
-		if (ret && ret != -EOPNOTSUPP)
-			return ret;
+		u16 old_flags = vlan->flags;
+
 		*changed = __vlan_add_flags(vlan, flags);
+		if (*changed) {
+			/* Pass the flags to the hardware bridge */
+			ret = br_switchdev_port_vlan_add(port->dev, vid, flags,
+							 extack);
+			if (ret && ret != -EOPNOTSUPP) {
+				__vlan_add_flags(vlan, old_flags);
+				return ret;
+			}
+		}
 
 		return 0;
 	}
-- 
2.25.1

