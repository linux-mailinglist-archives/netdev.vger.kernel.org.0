Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63F3434A24
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhJTLix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:38:53 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:17770
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230089AbhJTLiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:38:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gb3Mb+o7y5SfGZdX0B0t46qAyNc05xgptIXFBgo+5BALPYYueJmaTvMURk0xlg8t8d2uu+WnIN76WkLuNq2av9h30mO0Q0mmJifTkP9zDCWynhRoBrggQ9gzrmxkrMkovHknojKPRCvxsuPNzHm4LC/Eq4H/OCOK/QycIKK4dTedNEweuoIdVh9ypczCxhBHshfo7YU4vubMgY3qhgaQVv7xh/Nr/Xa4deOCnGiN9PaJEtZaOlOYRbUO9MlC/puoaZH8cXQE8CSRpmHA4oybWSCsXOCqnk/P9fKq0IkcfKeX7ilbvtVWYmR1LvLkjMI8KhmcJTUROqXd3TTXRz3l+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJc5LjUOwczkqmpjEHtYpnzZ+oowQmp6jsWB82ntNLo=;
 b=eVQy3Rz2nqadDcAv05k/K5q7rB/SX/4+fasrM6etwBfFlg43mp39+jpIgm0gT9v75IHlu6v/FXttI14E9w5LzUruEbUOE08PDfKSsGY/ON5mFMadcsf36fVw2ULLjlfUg/6QHi5y9/AC62niMPwQXED50MzN5bluif1vtZFnHNgQ80uG13cg7clctB670ifnXl5C4Qu1N+wcEYsGjPnTDvu2Ndb+oEn69R2Ge3GJ7+NbPDkf19M31b0WkhM4Or5TTiK5xSmZi0WsJFCVi0f0NdISM1KJu4BNhDglx4r2WroogDfLDnxhWTrUqoeeZSAKZe70gjaNr/B3i+iXodM7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJc5LjUOwczkqmpjEHtYpnzZ+oowQmp6jsWB82ntNLo=;
 b=hmrOYr/5XLHAngxSY9esVcUSSmBImZaeBDIael7UpmU29oDa3v74Sg8XS2YII6A3WDTy1b2WAjMSfiVmw762Y9mAAErdUvvQ92CpmT6tLFML6DZdR8fRua7qAl5sCVxK3E47I1HuQx4+XpRJMDs2Gewhx2NObGlxL82Qa0avd7U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 11:36:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 11:36:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH devicetree 1/3] ARM: dts: imx6qp-prtwd3: update RGMII delays for sja1105 switch
Date:   Wed, 20 Oct 2021 14:36:11 +0300
Message-Id: <20211020113613.815210-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020113613.815210-1-vladimir.oltean@nxp.com>
References: <20211020113613.815210-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:208:14::49) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0036.eurprd03.prod.outlook.com (2603:10a6:208:14::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 11:36:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ddaa41a-5e4b-41d0-676c-08d993bddd66
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB468562D234709CC34BBA1F48E0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4M6+yoW5QQNXvNc0GZeeHXvWkOPTGd4aq23d1RovopEVhVlhlHhQgnSgWY6+rDDb7qzyiQ5GV8XN2xXby3935EIMboy3KNAfynmq/QL+b0R9A/fCDGKCEbnfDvjuP3z7BmHdKvuQFWz0Jy/u/Vv33tVgJYO2toyD3R3CTbZWyvK32C7jK89iiSjHTnj+ckhq7Yb7SuzCi+BLa75LyOqrQ3Zk68fpAyDmxPFH+KOYwdv6rkDKhxTEAM/hF8TewJGg1YSHDiB3tD/4P23XzX6w9eKJu2ppgjzGiUD7fNnRj4PkODl5avu3O/W+KLJVIL0saoz9DjIZgtVFtUpXvQIns8u5OUyBhJF1P8be2YN7l7pXwP26CKkSxsLlcLTLN/uy7uZyTM+jCKjFdVikdeQ0jNkE8YNsY48hFI3RUEzOtWrIYpeHoTC9JnE38Jb3uFZppcIkDSRM4PqRJ6Opu52FAl9XN1tmFa7MZCHc+msKkZnfBd2DsZVVR8GkTCpQAO08gVNIxXDcwnB103izvRqML9YlLk9/ZW4Q+5FsgzqZ8RFuSBTHS0yxyUiue1mZBhZ7/Y7/NqumXo89hezxWZH/xJCPNzYg+4GVuQGhLsxWO2g0kcfHb+rJdnAF+xKHDE9oMpiAhg7IKn6linsJF040nqtaAfl6QORzD8w9gxK0ItODfkEWZEjMYZyijFxIbPdPW4nTYFFvBucSEpHp4NxbpZgQWAG4SGHz1oxqKhndliQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(4326008)(6512007)(956004)(66946007)(2906002)(44832011)(186003)(8936002)(2616005)(86362001)(5660300002)(316002)(6506007)(52116002)(508600001)(26005)(38100700002)(38350700002)(6486002)(54906003)(1076003)(6666004)(66556008)(66476007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yEhR9I9rj9xxWWumAtnU/5gxsoNfnVe1C7ORnaUkp90W+NJFtAzdDrHNvH1V?=
 =?us-ascii?Q?SPsdheebfau80u0QkXL39KCm2+IWgMVpqpKbcpzU6w+qtnTZcpsnGf8xp+Pd?=
 =?us-ascii?Q?rKNJBRmE1FSItdnfur3dKGlBamVd+xc6LKpdCMyEiT4v9p1RgEa70FZMV6EW?=
 =?us-ascii?Q?VJZOmoao2Wnq4GLjTn0iG0Pogidm+g+zZG3rkmP2uv4fK3XboZlcp1ORu1vO?=
 =?us-ascii?Q?tW8QO0PTTIdaaeoaYnabhpeEt/Vu+HlXdSSqB422O96cRJ0qLXLhERMtLCtX?=
 =?us-ascii?Q?TS75op/kIZ/2EbFQDlH19gJEMoMWgZssk4z1N+lv4f8dFMyJe2e5NUlcpiCq?=
 =?us-ascii?Q?l3gBaoU2ekK4PW9p+ilr2vvSHqCFReVWPQE6RM9sLqhcUw7elMglb5CvsWHo?=
 =?us-ascii?Q?8t5kr/tbz7zYphbu5IDZ6LIS+PcfeyfyYJDaIIouMN21LiZusCcZZD3g2F/S?=
 =?us-ascii?Q?2BivlYXETx1Eg1BlN6wLCz1Zh+QPENQ3OUD/IIURB3FeVDbxUCVlUx4GUhq/?=
 =?us-ascii?Q?RGcOEC5gyIUwe3xpI6Z7D/3Du9R+rW5BNRVwfYBx2ShG+bMyMW82oieslXVq?=
 =?us-ascii?Q?IXdpwegi+Uf1bMXR/3GCKx1h678Gtex5/M2vod1OpcH7WUCgbwgNlC0ljLxc?=
 =?us-ascii?Q?7uJz9Fd0IHBF6vruA0d1Y/HOKC/yHfIqhQBbrQqrekCSRkgfC7wYuZJXYIt3?=
 =?us-ascii?Q?9t/qojZg2HRy+HHxv+AVk950qszbey40nkKluEPDd0Bo2JJngiRJ0dw1uzV6?=
 =?us-ascii?Q?m9qCmka4H3t9jQTJ3ZeK/s6aYHrBym2EPtR48RZN1ewdXyXJn/+dzoKqdRjP?=
 =?us-ascii?Q?5ktD1vnI/iWi0JrwdSEn0RlIEMKvlcR5HZ5vg7BDbHU1zEeLSRy+yxbVu3m6?=
 =?us-ascii?Q?LEPMpLFfStnoigENmZ9iOOkbU6gOmbz+113RvqiQugZAOO7fQZFEYDoIcRvD?=
 =?us-ascii?Q?Zf1Ac65mG9HdiX8uu3hVy+TUFfvkSkWCKclbUubdUcznYaxcdvFJ6/4X75do?=
 =?us-ascii?Q?g7gAipMwT/Bwf0gWQgtwDhSyNEvfFGr7+ONToKCS6iRJDsMQR0IKrtmN7Q74?=
 =?us-ascii?Q?CUGFgd/DL4/H5ekV65Ir6v1YlDVw5WfbLFwHM2U2zyxZMGpORO3Q3bJiwJBP?=
 =?us-ascii?Q?hDrwwo3WXAyYgaGZtAkZ/8mc0lr2MwGp5DMgWZT6k7pYYz8XIGyshiQScc6c?=
 =?us-ascii?Q?W4uo3nJfb9BBBTlX0Shcixm2R5IS0G7aCQehyRRWJ5M79Wd3YDYb5277KZYh?=
 =?us-ascii?Q?E9939y41c7tb8h3dnYWTwvJmD9s8DKzL0IjlK9k4lHwZkDMtRlstm0flYNeO?=
 =?us-ascii?Q?DPA4L6vOZVKDcIb9exz8IIdl5zec+tE4FmHbSqqjamjBeoHoCxZB+x9yNgFo?=
 =?us-ascii?Q?QrdDa2evmfpATHGTh6V2C6fwndcHODQAoNGScOlVEgp5LTsFOPxtK7UrP989?=
 =?us-ascii?Q?kSOo0/8bDQ2vfJO4l4c9x7CSdhrp6EzHsGQno5SlOLARXIR5K6mWpc+rZxef?=
 =?us-ascii?Q?i1lfpR+NurddWX/eq3em5caDYE57jLHXPGNFthWF1JifBYZUDGRkPcrqMqQ2?=
 =?us-ascii?Q?gTL0pLsbsAIPUod1dVLPPS/5OCUtyNdue6KBaXTn3namaPpiXYWlbx82v5eP?=
 =?us-ascii?Q?bH4t+9LyapSPZ+vJ70tFv24=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddaa41a-5e4b-41d0-676c-08d993bddd66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 11:36:32.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eM8p/Ih+rK7+klFDFcpaW/tcGTkg0YN+yvAVCvHsxWyy8oen2W/vuKOXooaCxvjr37qxu+pKetQ4UXFVyoDLTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to apply both RX and
TX delays. To preserve that, add explicit 2 nanosecond delays, which are
identical with what the driver used to add (a 90 degree phase shift).
The delays from the phy-mode are ignored by new kernels (it's still
RGMII as long as it's "rgmii*" something), and the explicit
{rx,tx}-internal-delay-ps properties are ignored by old kernels, so the
change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/imx6qp-prtwd3.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qp-prtwd3.dts b/arch/arm/boot/dts/imx6qp-prtwd3.dts
index 7648e8a02000..cf6571cc4682 100644
--- a/arch/arm/boot/dts/imx6qp-prtwd3.dts
+++ b/arch/arm/boot/dts/imx6qp-prtwd3.dts
@@ -178,6 +178,8 @@ port@4 {
 				label = "cpu";
 				ethernet = <&fec>;
 				phy-mode = "rgmii-id";
+				rx-internal-delay-ps = <2000>;
+				tx-internal-delay-ps = <2000>;
 
 				fixed-link {
 					speed = <100>;
-- 
2.25.1

