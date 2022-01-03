Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2368D48347D
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiACQBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 11:01:53 -0500
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:21721
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231513AbiACQBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 11:01:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5gmTXR9FosVMQetdeVHU/shbEALd9Z0RbcD2xLpKvQ00uoTAFf9qUnyfJmbZ0KBjcaLE+6skDNXub3OpgvBvYrnRX76fzAJXACNLVYcKZWfVjSvFQ7UdBNcBP8gESXiR8VU4rgCPD3wREFeempBlTyN+9a7Uh8p4jORTK/jF7eXjgtyvHsXKQRN+iWF+dv+M38U+H2CDtUx7Wj/Ok38/W8gk2PIadgwnIPGsdue1tHHREXd13mXXh5bJOUEDy+PT/ruHq3ywk+P23gwa/VhvWQl7rmw0745wv1jmhJrpRCx5gRjT5Xsn7UWIKXyCuuyWuGA4WS8QG7qA2YGtWOG7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nl5K5nIAaOGJoxCq/JffKzj9e0cqDBMt0QHva/wUUXw=;
 b=Vc/bPbdAcDVMkdTf6cQi6XHTt1IyklgMKNcgDLqPvwoZZlKds44hB2y6f0HpqNmxtRn6Vxh3Dwj7+mbdHO+/bscomaXIwRzJxvMZ4odtbncABd6dI/bqoe9oqbNx9vN+Idv/zlRci9ltsel3V8yc7EFvize6BrQdaYm0fPXj7yrvghlioEcSm2/z1Bh0w3sjRvrZCMx6IIUNuA2r0O8H7lVChW3FaOAz6+Q/ZjbefKl7rIEtzRugraQ2bqiz/JW6Vu6XazynLcakXibBT8Uq9u5CxeCHqILySrWiViEtzvsA0HksDSG3Ty7akdAfXY8j4wq9IseoaG4XEi+Z3UcmrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nl5K5nIAaOGJoxCq/JffKzj9e0cqDBMt0QHva/wUUXw=;
 b=JBDCPu+Z1TlKzcutp0PFKEvD7JxyijDhRkfSiy2V1vKuGUQFZ9x8YrrZDBw7u0EEqG6n6O6y/01ggtlbgDW0aNEZkSSGutVlBT5De3pft4qHVb4ILiDoNxhdd9jb7wZciqQmV89jthPOX0Mw/Zc2p9iTxxyRYOuvjVmWsVpfSCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS4PR04MB9507.eurprd04.prod.outlook.com (2603:10a6:20b:4ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 16:01:48 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%8]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 16:01:48 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v3 1/1] phy: nxp-c45-tja11xx: add extts and perout support
Date:   Mon,  3 Jan 2022 18:01:25 +0200
Message-Id: <20220103160125.142782-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103160125.142782-1-radu-nicolae.pirea@oss.nxp.com>
References: <20220103160125.142782-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0010.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::20) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 143e2161-2eaf-411c-cb50-08d9ced2592d
X-MS-TrafficTypeDiagnostic: AS4PR04MB9507:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AS4PR04MB9507B4904B2D029C225694FA9F499@AS4PR04MB9507.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWAwElOcAKuXucte48QoXbddTFFC7nTSDIrkd3q+7nEP0rakgoeHn72/C5bKE5Kqjw+LHJsUfn713rbCGYp44gZqEFSqlw1PNT+fNuBliNpVwxwY+7V6LqDXxFCESdO34vEEZq54imPBeXoUeoDYcP+sn0Vgwpqhdu2RrCQTwyEli/NtmoxA6PJbNgnB3SmH0XO1ALWWYftPFLexN6K98lsHKFUgLtOm18cvfGJP3OgG/JplkbJKv2Q2Csmd/55j/uiTHgccV5M3/sg+Y3uhtWC27jxOKI/D3Ho1JiwANtGRlSU++6aL9ASx9nIrwHKMvJnCuOQwU+RKUacuDFBfSwuTvCZ5G6F8hxHxefoar3Ddsz604d3OZ2D8gVMdKky8w4Zw9xLOtoICp+n7fjfJD7s/3YZ420Ice5Nk7crcHTYrufrmNHpUCoia5t3lO0gg5plN+4GA4wJh81TX/kCBJbHXAdDvmYA5l4WfuafMMs7WcSWx822c/ccKFqRuhWuPQ9UvdRBrI2Ksso0rz49iLviIjj22r0Z4j45ywyHmRM1venhZSp/toudviVWKzu7i+bRELMruJXGgeFo/jRzx8UfSmyZMnZ2uqf9N2wD02YwzINsQ6C+G2OtPKmcXRIr/JP3TF6P7YtkZ7xov7nuX+4aZ4mMObCc9S7hQI3QwGNHDuq/GEwg8CO794sHntcKgsr72ZkJ9Wdp+Rf6jt46LYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(66556008)(6486002)(86362001)(2616005)(66946007)(83380400001)(66476007)(6666004)(8936002)(4326008)(6512007)(8676002)(186003)(38350700002)(2906002)(66574015)(316002)(52116002)(508600001)(26005)(38100700002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FNm2kRRcjqCXTinDn5JhJf6NbsX16MWnfeFHwTiQPaTQud8MjC9fE5928wSI?=
 =?us-ascii?Q?Kr9CFd+trSKA+Jb1vlfpEjhE1FCd5rQ+qTYTkH9QqHrv6F75sfEnY/pRAzNW?=
 =?us-ascii?Q?IiGk8c2zU4CPEbtk/bIsdfhWaiktvBd9tuzAEdNVfG0gKF/jqhEl04eliYQD?=
 =?us-ascii?Q?76d/cL+WdIXNw5hKCJK1FfizL9pqQscjTF+TtZyZjL/kpiUQFTBKsvfbPOrC?=
 =?us-ascii?Q?2tsOsEim5pZAAfIMTgZ7EzwNWxQnDZq2sdCQ5w4m0558Ngxhk85Sl38m7n8Y?=
 =?us-ascii?Q?olCwMu8deMpS0NEcKuvoq/d2kS13dA03ozoGPXXDf7YcAwwX/hJYjckCLkgn?=
 =?us-ascii?Q?m+RtHdeDt/pTUPNsXUG3J621gxdAinClfmSxP1i/YL7Yv0cNhfX+mAgc6FRo?=
 =?us-ascii?Q?dyswh8MpZ7gkKxsVgpPvvT9BYSMksmjfYbiZlB4mC7wuvVRrgD5Kf36Xhd1M?=
 =?us-ascii?Q?ntE1+FvaWcnemMlzGCsb6turECh1pxaH+GKF40y1Xk2y2ojLAUhsggfI/jf2?=
 =?us-ascii?Q?jUw3gTtcn9U90+sIrlzdWxKaJWWEmMig7uMym6WAv+V3UXbuWmJBexzYdVBB?=
 =?us-ascii?Q?SY7mxWNdppreWglB3xJuGIPECL26yiQJ8tMvsWw7pzzcvPy8jUO6uD15Dv09?=
 =?us-ascii?Q?flDhBSh+LFZgu5QJB9Z+ii4TSvyK5w9RWs0I4M1sZgZrpngBp0smfZafa3Rl?=
 =?us-ascii?Q?Q0lr68zOoCnYNJywmQHs5B0aiv3zM0wPBSap5PouYUvQEd6bMrERJRSa7aq0?=
 =?us-ascii?Q?4HkqF/+QLUhSNHxa8NhskUJjvlM3wPm0zXnJBLsdQo4OBWACwklhiYFBbYdT?=
 =?us-ascii?Q?TiSglnOiinkNhAaUXIur9f5lcu2DTToCZLboi1g6q/8M8LymuSNP+Gpw9O4w?=
 =?us-ascii?Q?HrIBv2AZlzElbD+N1E9jzIhdrPY8UEWnO63HSqD8LwV9xNx4uv1PVQLJjljA?=
 =?us-ascii?Q?7104sbgNX5LYdm6BoD9LSWtS9RJx0NqV0/PxmpWotHfEpR1fnsW+B9SulnE/?=
 =?us-ascii?Q?W1oBWi5Tn9etnpcOb7m5On9lWsdoFiwjUnqg8lPIFZVXt1fth0yK+wOTK67q?=
 =?us-ascii?Q?arY5i7vCSWUhdcNE2eN46EXCYBrSW+CIm6KIdyVIAfUK9MjjXg0Tgu9oGcyZ?=
 =?us-ascii?Q?pp4yycs0BX2yMQSJJM0gFmyS4sOChWkVChffJO1FsPtoFQHZyaWCNuBMJ1RR?=
 =?us-ascii?Q?4PlkZ4dkGze7FxKVfoOda1MHlLEtn5zo3qoZyxYZmAxnLj5xpU3LHdu/y2OQ?=
 =?us-ascii?Q?Gvy+frGgXO0V5+X6eyubhn8RGj4fSU1OnVFHcmaHaOd/WtyvMPzkOKE5T8b9?=
 =?us-ascii?Q?L7g10miYbQvopmxiMeqVU4g1Ms7kyaGhZSVuPfIv2pVg9oPr8+Esdusz+Esg?=
 =?us-ascii?Q?zoD4rEVQBFF/Fl1KqaKLTK6v2kZOvL3OMvtJ7H6bZHLkC6N+A0I/EkbQJaQD?=
 =?us-ascii?Q?4StDTTbOXPRgYqmstvAX5/chTXC95RpRS+zQSwLDWKlyoYbZ+zALYl08OZzm?=
 =?us-ascii?Q?IQLTlRsSJFhNiuJ6DnGfrFLUFYq0R7dlbY0hnUfEOs720zX/KcnCnERqYB4R?=
 =?us-ascii?Q?yo8Kk1K7A59V+6pXTxfQmMmEBf/+OBFsapkemiAIGA2lJ1AWO8AotU9HiMGA?=
 =?us-ascii?Q?Zai7RcX57E+kZxo/crdVrdcO1QL155EPusaZ+1NCd6jxx9bSzg6HepS7lrrw?=
 =?us-ascii?Q?6AFe3Q=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143e2161-2eaf-411c-cb50-08d9ced2592d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 16:01:48.5677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wUI2eBm3oqsey6cZSuAZf+f5QbhiA/sF4qkAXnArBpidusZdqEiQ34bFakF6Mxyqka7an1Ab+kGBxt1Z6XySsfQwRcVRN2O64VpT63X9CV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for external timestamp and periodic signal output.
TJA1103 have one periodic signal and one external time stamp signal that
can be multiplexed on all 11 gpio pins.

The periodic signal can be only enabled or disabled. Have no start time
and if is enabled will be generated with a period of one second in sync
with the LTC seconds counter. The phase change is possible only with a
half of a second.

The external timestamp signal has no interrupt and no valid bit and
that's why the timestamps are handled by polling in .do_aux_work.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 220 ++++++++++++++++++++++++++++++
 1 file changed, 220 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 91a327f67a420..06fdbae509a79 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -97,6 +97,11 @@
 #define VEND1_TX_IPG_LENGTH		0xAFD1
 #define COUNTER_EN			BIT(15)
 
+#define VEND1_PTP_CONFIG		0x1102
+#define EXT_TRG_EDGE			BIT(1)
+#define PPS_OUT_POL			BIT(2)
+#define PPS_OUT_EN			BIT(3)
+
 #define VEND1_LTC_LOAD_CTRL		0x1105
 #define READ_LTC			BIT(2)
 #define LOAD_LTC			BIT(0)
@@ -132,6 +137,13 @@
 #define VEND1_EGR_RING_DATA_3		0x1151
 #define VEND1_EGR_RING_CTRL		0x1154
 
+#define VEND1_EXT_TRG_TS_DATA_0		0x1121
+#define VEND1_EXT_TRG_TS_DATA_1		0x1122
+#define VEND1_EXT_TRG_TS_DATA_2		0x1123
+#define VEND1_EXT_TRG_TS_DATA_3		0x1124
+#define VEND1_EXT_TRG_TS_DATA_4		0x1125
+#define VEND1_EXT_TRG_TS_CTRL		0x1126
+
 #define RING_DATA_0_DOMAIN_NUMBER	GENMASK(7, 0)
 #define RING_DATA_0_MSG_TYPE		GENMASK(11, 8)
 #define RING_DATA_0_SEC_4_2		GENMASK(14, 2)
@@ -162,6 +174,17 @@
 #define VEND1_RX_PIPE_DLY_NS		0x114B
 #define VEND1_RX_PIPEDLY_SUBNS		0x114C
 
+#define VEND1_GPIO_FUNC_CONFIG_BASE	0x2C40
+#define GPIO_FUNC_EN			BIT(15)
+#define GPIO_FUNC_PTP			BIT(6)
+#define GPIO_SIGNAL_PTP_TRIGGER		0x01
+#define GPIO_SIGNAL_PPS_OUT		0x12
+#define GPIO_DISABLE			0
+#define GPIO_PPS_OUT_CFG		(GPIO_FUNC_EN | GPIO_FUNC_PTP | \
+	GPIO_SIGNAL_PPS_OUT)
+#define GPIO_EXTTS_OUT_CFG		(GPIO_FUNC_EN | GPIO_FUNC_PTP | \
+	GPIO_SIGNAL_PTP_TRIGGER)
+
 #define RGMII_PERIOD_PS			8000U
 #define PS_PER_DEGREE			div_u64(RGMII_PERIOD_PS, 360)
 #define MIN_ID_PS			1644U
@@ -199,6 +222,9 @@ struct nxp_c45_phy {
 	int hwts_rx;
 	u32 tx_delay;
 	u32 rx_delay;
+	struct timespec64 extts_ts;
+	int extts_index;
+	bool extts;
 };
 
 struct nxp_c45_phy_stats {
@@ -339,6 +365,21 @@ static bool nxp_c45_match_ts(struct ptp_header *header,
 	       header->domain_number  == hwts->domain_number;
 }
 
+static void nxp_c45_get_extts(struct nxp_c45_phy *priv,
+			      struct timespec64 *extts)
+{
+	extts->tv_nsec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				      VEND1_EXT_TRG_TS_DATA_0);
+	extts->tv_nsec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				       VEND1_EXT_TRG_TS_DATA_1) << 16;
+	extts->tv_sec = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				     VEND1_EXT_TRG_TS_DATA_2);
+	extts->tv_sec |= phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+				      VEND1_EXT_TRG_TS_DATA_3) << 16;
+	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1, VEND1_EXT_TRG_TS_CTRL,
+		      RING_DONE);
+}
+
 static bool nxp_c45_get_hwtxts(struct nxp_c45_phy *priv,
 			       struct nxp_c45_hwts *hwts)
 {
@@ -409,6 +450,7 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
 	bool poll_txts = nxp_c45_poll_txts(priv->phydev);
 	struct skb_shared_hwtstamps *shhwtstamps_rx;
+	struct ptp_clock_event event;
 	struct nxp_c45_hwts hwts;
 	bool reschedule = false;
 	struct timespec64 ts;
@@ -439,9 +481,181 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		netif_rx_ni(skb);
 	}
 
+	if (priv->extts) {
+		nxp_c45_get_extts(priv, &ts);
+		if (timespec64_compare(&ts, &priv->extts_ts) != 0) {
+			priv->extts_ts = ts;
+			event.index = priv->extts_index;
+			event.type = PTP_CLOCK_EXTTS;
+			event.timestamp = ns_to_ktime(timespec64_to_ns(&ts));
+			ptp_clock_event(priv->ptp_clock, &event);
+		}
+		reschedule = true;
+	}
+
 	return reschedule ? 1 : -1;
 }
 
+static void nxp_c45_gpio_config(struct nxp_c45_phy *priv,
+				int pin, u16 pin_cfg)
+{
+	struct phy_device *phydev = priv->phydev;
+
+	phy_write_mmd(phydev, MDIO_MMD_VEND1,
+		      VEND1_GPIO_FUNC_CONFIG_BASE + pin, pin_cfg);
+}
+
+static int nxp_c45_perout_enable(struct nxp_c45_phy *priv,
+				 struct ptp_perout_request *perout, int on)
+{
+	struct phy_device *phydev = priv->phydev;
+	int pin;
+
+	if (perout->flags & ~PTP_PEROUT_PHASE)
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_PEROUT, perout->index);
+	if (pin < 0)
+		return pin;
+
+	if (!on) {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG,
+				   PPS_OUT_EN);
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG,
+				   PPS_OUT_POL);
+
+		nxp_c45_gpio_config(priv, pin, GPIO_DISABLE);
+
+		return 0;
+	}
+
+	/* The PPS signal is fixed to 1 second and is always generated when the
+	 * seconds counter is incremented. The start time is not configurable.
+	 * If the clock is adjusted, the PPS signal is automatically readjusted.
+	 */
+	if (perout->period.sec != 1 || perout->period.nsec != 0) {
+		phydev_warn(phydev, "The period can be set only to 1 second.");
+		return -EINVAL;
+	}
+
+	if (!(perout->flags & PTP_PEROUT_PHASE)) {
+		if (perout->start.sec != 0 || perout->start.nsec != 0) {
+			phydev_warn(phydev, "The start time is not configurable. Should be set to 0 seconds and 0 nanoseconds.");
+			return -EINVAL;
+		}
+	} else {
+		if (perout->phase.nsec != 0 &&
+		    perout->phase.nsec != (NSEC_PER_SEC >> 1)) {
+			phydev_warn(phydev, "The phase can be set only to 0 or 500000000 nanoseconds.");
+			return -EINVAL;
+		}
+
+		if (perout->phase.nsec == 0)
+			phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					   VEND1_PTP_CONFIG, PPS_OUT_POL);
+		else
+			phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+					 VEND1_PTP_CONFIG, PPS_OUT_POL);
+	}
+
+	nxp_c45_gpio_config(priv, pin, GPIO_PPS_OUT_CFG);
+
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PTP_CONFIG, PPS_OUT_EN);
+
+	return 0;
+}
+
+static int nxp_c45_extts_enable(struct nxp_c45_phy *priv,
+				struct ptp_extts_request *extts, int on)
+{
+	int pin;
+
+	if (extts->flags & ~(PTP_ENABLE_FEATURE |
+			      PTP_RISING_EDGE |
+			      PTP_FALLING_EDGE |
+			      PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Sampling on both edges is not supported */
+	if ((extts->flags & PTP_RISING_EDGE) &&
+	    (extts->flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_EXTTS, extts->index);
+	if (pin < 0)
+		return pin;
+
+	if (!on) {
+		nxp_c45_gpio_config(priv, pin, GPIO_DISABLE);
+		priv->extts = false;
+
+		return 0;
+	}
+
+	if (extts->flags & PTP_RISING_EDGE)
+		phy_clear_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	if (extts->flags & PTP_FALLING_EDGE)
+		phy_set_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
+				 VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	nxp_c45_gpio_config(priv, pin, GPIO_EXTTS_OUT_CFG);
+	priv->extts = true;
+	priv->extts_index = extts->index;
+	ptp_schedule_worker(priv->ptp_clock, 0);
+
+	return 0;
+}
+
+static int nxp_c45_ptp_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *req, int on)
+{
+	struct nxp_c45_phy *priv = container_of(ptp, struct nxp_c45_phy, caps);
+
+	switch (req->type) {
+	case PTP_CLK_REQ_EXTTS:
+		return nxp_c45_extts_enable(priv, &req->extts, on);
+	case PTP_CLK_REQ_PEROUT:
+		return nxp_c45_perout_enable(priv, &req->perout, on);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct ptp_pin_desc nxp_c45_ptp_pins[] = {
+	{ "nxp_c45_gpio0", 0, PTP_PF_NONE},
+	{ "nxp_c45_gpio1", 1, PTP_PF_NONE},
+	{ "nxp_c45_gpio2", 2, PTP_PF_NONE},
+	{ "nxp_c45_gpio3", 3, PTP_PF_NONE},
+	{ "nxp_c45_gpio4", 4, PTP_PF_NONE},
+	{ "nxp_c45_gpio5", 5, PTP_PF_NONE},
+	{ "nxp_c45_gpio6", 6, PTP_PF_NONE},
+	{ "nxp_c45_gpio7", 7, PTP_PF_NONE},
+	{ "nxp_c45_gpio8", 8, PTP_PF_NONE},
+	{ "nxp_c45_gpio9", 9, PTP_PF_NONE},
+	{ "nxp_c45_gpio10", 10, PTP_PF_NONE},
+	{ "nxp_c45_gpio11", 11, PTP_PF_NONE},
+};
+
+static int nxp_c45_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+				  enum ptp_pin_function func, unsigned int chan)
+{
+	if (pin >= ARRAY_SIZE(nxp_c45_ptp_pins))
+		return -EINVAL;
+
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_PEROUT:
+	case PTP_PF_EXTTS:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
 {
 	priv->caps = (struct ptp_clock_info) {
@@ -452,7 +666,13 @@ static int nxp_c45_init_ptp_clock(struct nxp_c45_phy *priv)
 		.adjtime	= nxp_c45_ptp_adjtime,
 		.gettimex64	= nxp_c45_ptp_gettimex64,
 		.settime64	= nxp_c45_ptp_settime64,
+		.enable		= nxp_c45_ptp_enable,
+		.verify		= nxp_c45_ptp_verify_pin,
 		.do_aux_work	= nxp_c45_do_aux_work,
+		.pin_config	= nxp_c45_ptp_pins,
+		.n_pins		= ARRAY_SIZE(nxp_c45_ptp_pins),
+		.n_ext_ts	= 1,
+		.n_per_out	= 1,
 	};
 
 	priv->ptp_clock = ptp_clock_register(&priv->caps,
-- 
2.34.1

