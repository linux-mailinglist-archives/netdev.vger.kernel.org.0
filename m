Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3F945E34C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245009AbhKYX2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:28:01 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:6021
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235724AbhKYX0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 18:26:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qqfm8DBhAiaJVIJYyF4AlmTrrgaZq1QUpHe+WPzyuAmDzHdTES6A8e4ehdHEaC168a0F2LuwXp5ybjr8z/buE8gNTcnpghjrBNv44AYASS01jC5d4SL/KhX6z7rnhXzaigOBnHQ9zjc6l1HkH6FDOjfvvYGqe7kpa3H7M5CXCMMDpKYbzoF6SW8+CYU89++8v0gH7ls+J9bCa92zWP/QIh+Zi81xHGVwb5udVWxERxP5oKr8iDP+sBD4RKUIFQ9C/042PSrGI81f0B1noJ++g/DeD3NMTJfUPxocQyHwKXB/0iYcTdi1HEaDSpa1tjI+Kdzl9J0/NUPmN11e7duUFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMCL5YE0G/7/LbupntkCdgXl12JXAe41s+mH2OmFJcM=;
 b=EA7yx8RNwEBtZh7J9T74gI+x5Kdm6vyA7i90Bh/eOrz38anwDNf4kxo8LDCzr8kKHpk07O+el7ZhTY7NvzyNt3FyoqF9+FXChUlconsJ4XDGFylTeAF+brM+BKCOE2rncc6T52F131JxPvQQ3Ezv60KRGCsaZd20anbs9Ov1Czb+X+Jnp0oBWdgN6GOpBys/tlC3sLk0r2y4xMkobSNJBigXeTBPO/wKF5EI7I5TFfagnW+JCJAYTqzoH445S2dBmx+fBt5NWYX28yCNzYRyoAcp5NMAsYe3eoCt9SAORkd1zDrXalZc1EBxAXoiXBqiubXr0dq2ymO+0uI0u1FL5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMCL5YE0G/7/LbupntkCdgXl12JXAe41s+mH2OmFJcM=;
 b=bnsoLxIb5s6yfEJXyEuibdMCx9IxRU2edoKKzSQhHo5Eh+3AC11oLmBEbT1HMtr9+UH9gmntbUJ/RH+pq+cOtfGw+pB5hz/gcB4jd5C4KPFpSETv+aJk8zt/eJVgAZzbOLFaD3lzsTbHcRZHX5uE/2caRk3DDWMBmrJyazpDk6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 23:21:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 23:21:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH net-next 2/4] net: mscc: ocelot: create a function that replaces an existing VCAP filter
Date:   Fri, 26 Nov 2021 01:21:16 +0200
Message-Id: <20211125232118.2644060-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR05CA0011.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AS8PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:20b:311::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:21:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7418459-e82e-4e76-5244-08d9b06a58f4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28628C06E4B5971931F12D8CE0629@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ec8Zg0qZEIZDk7e+J+VLn4ys4mBfQUZ5gepX+BmfpXxP5yuqdzFw7Er6l3e1mN1980S/XYGuk1AyHeBgkiDpm6DRO4cMWN+i7Tt/fRZYF+5sWRHLusA6ksdVZZb6Yvf9t+H0LzYBh7EYT2NfXSpIPM/OejNJCTt95DHDeeY7jMPhv8dIpDTaZ60HsbCNV0LFF4wuoJPXasFjhPgyIzewC3WelsJE1UWcKRtlgD8eABAclx4OpQFLaiqdGE6AfBGs9/qSvLfGxCfrSUhkoLZtCyU2W5lClO5AMKh2IJdrRQyKbA0QGXY5Sp7/2La6iJfP2VS1QuOvpnkmSHT31g/VIZ1tVEZ3xYbQeVMskwSMWIjpLdnW4KapEP8rpDrq6Hkq/Jx9SKl5p8tzQdy+BnMbotVk0iFMJvNz50AzleECKx6i/6zy08VLfEYM3LzbNRGplTp2Ukll2ag1MR513SVq4TqpqKrYTkwhp3V3YeYNRuAIFKI2qHc7cKYKmN65FMmP6jAa6CTYmvXxh/6B9HBFsQQOKsCtc9KuFlPJnOZUybddaX+sRR0bymg4/+NNbkr24ITnMBcC0lciKLIkkYv3GZdVGh3DgRlDRPXaTcqCVBJQK/3hQJGZDnZ0kElbF9+9n2mIxI3NxdzoI6cY6rPcewhh7J7SyVlJAiHa7LScC+596DL+iAtSy28LuSkdGPNf6jwS9MG4aN/0WpgU7z35Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(1076003)(8676002)(5660300002)(52116002)(2616005)(8936002)(6506007)(44832011)(83380400001)(6636002)(6666004)(186003)(956004)(6512007)(6486002)(508600001)(66476007)(66946007)(66556008)(6862004)(37006003)(38350700002)(316002)(86362001)(38100700002)(36756003)(54906003)(2906002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9+SZlKC301Si6aycPLnLwPPkfp72T6Z1GDz6pxGxChO6beFvIb24vh+3SdBa?=
 =?us-ascii?Q?kk6TLNsSeTagdpx7JcqpzeL3cmy2mFN894Ckh7uy/oSuhJkejxqlBSkfDm28?=
 =?us-ascii?Q?gGbBpeceB+BRl8dwIxItZqe4LQQ/PrWJJjJvIOLjhfCxjxTJtRcGzKlrBq8S?=
 =?us-ascii?Q?E0rhwzyISP4JcRlooX5hP+nrCMr0ktGbzi/o0GtEmqu7lCg5FyhGhEfCM2GW?=
 =?us-ascii?Q?aO5Kkpvfp1l2fvz7cJXjuz5yB+fz5esqiK3dLUIggwmRVQk3hBWJSzvJ/Kj5?=
 =?us-ascii?Q?oSNnvy+hEvEU6m2HodN/26Fqlujq7CFP6zUKqnzhykz2hO5tujCyJDy9iYq3?=
 =?us-ascii?Q?92HpE1d5N4nzRzaOQdepoXhVqbNrAFBZsqCpZ0Gy/qwXvvmG4NXMBQR2dJv1?=
 =?us-ascii?Q?eNHb9w3h1aqoK+4DSnmKuNlsTqnBj8xRmltnSVEMpoE5R5+CgpE3eXJLx0pM?=
 =?us-ascii?Q?bJFngngLumqXzatuPZe9wS19v8A5wIsCqpFPafwzsWlMxrsV6JEd0rOz6Dp0?=
 =?us-ascii?Q?uti87ZMxJIz+eGymsvotjNOVZiRDswsLA4p/vsWxrv+e0N1rrlgEmqW0UKHI?=
 =?us-ascii?Q?10W8Qe+Xa+Z6YAH+ruilo44uT5ClS4cWndp+c1H/lz9kDJMnIbrC4bxdslX6?=
 =?us-ascii?Q?+ZHwUS8ZNdcP5o/nWUWAtvs8f7roxRYvXWvQN2zMd0qJS8w8YYPoF7JKfdls?=
 =?us-ascii?Q?nJy47CyNNQc/48LpqXTp3CzjZZJBbsdQHOq4eaudO2Zr4j0otx5ehPV7+QQL?=
 =?us-ascii?Q?58wG+mumJIl5Hjzsak+nDB223TmeONYXdT3bu0x1oy0RasztPjxReV7u/hb4?=
 =?us-ascii?Q?7kWgsi2nu6WEsm0FIptnrZt9r550pO3m8EmmcyAcZf3wXZP6evgpsH4Dh3I2?=
 =?us-ascii?Q?S96KoUMl/Cbd48EFMCSNof2UugtGhmZYQuDnmZFBiETTWR9Oers8G+DWHW4F?=
 =?us-ascii?Q?rcnrCp1uHyZ2FDVpgQs+JcLwIMHHHHduXVHM6GaCoGjgu1vtFteCcJCH8yGQ?=
 =?us-ascii?Q?sTH1ji94dhK8Uy5M5vZfX5lj+/zXksiXVHvnRIA+XZtE00zxoQanACck8z0v?=
 =?us-ascii?Q?yQ5oEoslin3W7J3JJ5+GYPQp8yL6LH5vhObf1DbIGnBkE+/fGYjZib62DHev?=
 =?us-ascii?Q?nNkbgzT2aO0DBN7We7RJun75e7/kdGqloOPImT4Sb+DVnc9PKfIvSKU2Wkl8?=
 =?us-ascii?Q?dk+VQIIs2ZE5fNQ5LwRc4+T3ppwMpCe14qabxAm4RhrN+TfTx5XuzRlrkdd0?=
 =?us-ascii?Q?LarpH8xQu6WCbiE7D9O26BNu6I2+GvrsxPxQJBLp9Dn2cVfH+vlTCd6ZTd/5?=
 =?us-ascii?Q?a9VEA/fUYWCeK4yI0pahsHRmUoNqIFukgh2yu4GoAmuWWvCB+AACzuohFChE?=
 =?us-ascii?Q?QVgjItlBNgWJXRf7eOmBdgzGLMMy9SfLBoHftmV7dYHSOtRue7F0Cf+4/JV0?=
 =?us-ascii?Q?6P5iCqttlvLVzPWh9w6NjpybuRCct3diLnwkX5S9MEfw2F2ld5waHXBIwFNr?=
 =?us-ascii?Q?UckgTzwIVDkpKZlopWVgrohyvQdayCQtC1/MdQrcM0KAlRYE4P3Fgh0yrcoE?=
 =?us-ascii?Q?dU9FfRi8AJuaz8YK8AaaI8nuBDtdMEalE1M3P6llXrw1/ndysp4Rm4IRUxmw?=
 =?us-ascii?Q?+0vGgSi/iYHeOibswJ8vEic=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7418459-e82e-4e76-5244-08d9b06a58f4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:21:45.6673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQ3MZZNYJe8m3vC8J/ogExz5tJ5HTAk4chZPQw+bZPvcYL4heIBseDsyCl3Ud2U46lcqcbjDcgQuRr1TTRNbRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VCAP (Versatile Content Aware Processor) is the TCAM-based engine behind
tc flower offload on ocelot, among other things. The ingress port mask
on which VCAP rules match is present as a bit field in the actual key of
the rule. This means that it is possible for a rule to be shared among
multiple source ports. When the rule is added one by one on each desired
port, that the ingress port mask of the key must be edited and rewritten
to hardware.

But the API in ocelot_vcap.c does not allow for this. For one thing,
ocelot_vcap_filter_add() and ocelot_vcap_filter_del() are not symmetric,
because ocelot_vcap_filter_add() works with a preallocated and
prepopulated filter and programs it to hardware, and
ocelot_vcap_filter_del() does both the job of removing the specified
filter from hardware, as well as kfreeing it. That is to say, the only
option of editing a filter in place, which is to delete it, modify the
structure and add it back, does not work because it results in
use-after-free.

This patch introduces ocelot_vcap_filter_replace, which trivially
reprograms a VCAP entry to hardware, at the exact same index at which it
existed before, without modifying any list or allocating any memory.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 16 ++++++++++++++++
 include/soc/mscc/ocelot_vcap.h          |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 18ab0fd303c8..d3544413a8a4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1246,6 +1246,22 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 }
 EXPORT_SYMBOL(ocelot_vcap_filter_del);
 
+int ocelot_vcap_filter_replace(struct ocelot *ocelot,
+			       struct ocelot_vcap_filter *filter)
+{
+	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
+	int index;
+
+	index = ocelot_vcap_block_get_filter_index(block, filter);
+	if (index < 0)
+		return index;
+
+	vcap_entry_set(ocelot, index, filter);
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_vcap_filter_replace);
+
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *filter)
 {
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 9cca2f8e61a2..709cbc198fd2 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -704,6 +704,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct netlink_ext_ack *extack);
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
+int ocelot_vcap_filter_replace(struct ocelot *ocelot,
+			       struct ocelot_vcap_filter *filter);
 struct ocelot_vcap_filter *
 ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block,
 				    unsigned long cookie, bool tc_offload);
-- 
2.25.1

