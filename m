Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8C84FAED
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfFWJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:23:44 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:32560 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbfFWJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:23:43 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5N9LhQ4007309;
        Sun, 23 Jun 2019 02:23:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=c0t4VMV+2v8bQEtW4VrDj1n+L+Kl1QBMn2wQU9AXs60=;
 b=C7S1fqRWAWxfcngf/cgk8M08DSdzZ7oCizP3vETNZcK4MebjkYcFOxsaMNORQFoTKdhy
 WWS+K6dueY8JEJN8CBKXMlyp/mp5/zWeIi4CygZHVOb+vgeSNUCOx27zqwOtTukdhnzr
 IdSrIcmICBJsDIPSnWJrgbWpIFuquu3BqeSea11m7lpoUim19X4Xt5q7XD3QVJXvmtji
 JS1khCgSz1ibnmDlcQ9+S5XidTzZMOfXJgV1TdJM9YnJb9HGOtaYVXQkuD2kq/f+5Cmv
 9SrtVSElgtSc+CVBbyMo0fGdCRvJ+XQExxI3zsrYT+R5WmHyxmR4MzSnoL3FmYWh5NWN 7g== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2057.outbound.protection.outlook.com [104.47.42.57])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs2nnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 02:23:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0t4VMV+2v8bQEtW4VrDj1n+L+Kl1QBMn2wQU9AXs60=;
 b=npz1tagq5n7/WcIddzZSUXO99SVZhzzd34OxYndRe1BmYqlIgJLQfLFIJ6+Cpgga14ID8L8C7ylDHxQoEMJqNel1HBAlAgPbgge/V4AEyBDgqi8IpB/4XTI5lsld+egMrmmRFlppnhUviF8kGQu9BXhvcqtrkFhodGWkKvSjGVw=
Received: from BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35)
 by BYAPR07MB6824.namprd07.prod.outlook.com (2603:10b6:a03:128::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.16; Sun, 23 Jun
 2019 09:23:33 +0000
Received: from DM3NAM05FT018.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::207) by BYAPR07CA0058.outlook.office365.com
 (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Sun, 23 Jun 2019 09:23:33 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx2.cadence.com (158.140.1.28) by
 DM3NAM05FT018.mail.protection.outlook.com (10.152.98.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Sun, 23 Jun 2019 09:23:32 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id x5N9NTfX011163
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 23 Jun 2019 02:23:31 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 23 Jun 2019 11:23:28 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 23 Jun 2019 11:23:28 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5N9NSLc014059;
        Sun, 23 Jun 2019 10:23:28 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v4 4/5] net: macb: add support for high speed interface
Date:   Sun, 23 Jun 2019 10:23:26 +0100
Message-ID: <1561281806-13991-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(346002)(136003)(396003)(2980300002)(36092001)(189003)(199004)(50466002)(186003)(26826003)(36756003)(336012)(4326008)(426003)(86362001)(5660300002)(26005)(77096007)(48376002)(478600001)(30864003)(356004)(70206006)(70586007)(76130400001)(53416004)(7696005)(486006)(476003)(2201001)(14444005)(50226002)(7126003)(11346002)(446003)(126002)(2616005)(305945005)(7636002)(246002)(2906002)(316002)(8936002)(107886003)(8676002)(76176011)(47776003)(110136005)(16586007)(54906003)(51416003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB6824;H:sjmaillnx2.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 360d41a0-dcfe-46f7-3d76-08d6f7bc767a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:BYAPR07MB6824;
X-MS-TrafficTypeDiagnostic: BYAPR07MB6824:
X-Microsoft-Antispam-PRVS: <BYAPR07MB68246ED71B886AEBB2AFD114C1E10@BYAPR07MB6824.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 00770C4423
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: CMcgJ9yFNfSJTSNunVT/m3MgbE4hWRwg99OnW6YcC3gIYkQfuD/Bb8aAui38U6KXpVuclwNH9TCc+mUSI9SpRT5c3Z4BnOHAgX19GlUfMqSVXNJL6dygStnWWSJFN7QmNjUoNJbrm2nuSb6sT8+oP2lYOuRRYQWDwxYkIZ0oWukg7WTltzT+nS+ghVUMTNfCADFOoAAsP+QFFlFWB9sF+xsO9wCVUfnPeMEsoL/zH523/o2tYdQqBFQTVh8puwSBaWqW0zT2KG6t11VNZwvCw3Du3dOKRlQgx2XIhR9CNPHIR08N8X0McxImB3dllp/QG2ejeQjX7nrvIhH6gdBRFdalyB1j2lutNOUbouZf3N/EI9kyAemtB8sUFUkh9SoVpeuqFGtHQR/USM7QyyCl/uyV+ecYvpYEKkMeVmS6hiQ=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2019 09:23:32.7784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 360d41a0-dcfe-46f7-3d76-08d6f7bc767a
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB6824
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-23_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906230083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for high speed USXGMII PCS and 10G
speed in Cadence ethernet controller driver.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb.h      |  41 +++++
 drivers/net/ethernet/cadence/macb_main.c | 194 +++++++++++++++++++----
 2 files changed, 207 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 330da702b946..809acff19be9 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -82,6 +82,7 @@
 #define GEM_USRIO		0x000c /* User IO */
 #define GEM_DMACFG		0x0010 /* DMA Configuration */
 #define GEM_JML			0x0048 /* Jumbo Max Length */
+#define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
 #define GEM_HRB			0x0080 /* Hash Bottom */
 #define GEM_HRT			0x0084 /* Hash Top */
 #define GEM_SA1B		0x0088 /* Specific1 Bottom */
@@ -167,6 +168,9 @@
 #define GEM_DCFG7		0x0298 /* Design Config 7 */
 #define GEM_DCFG8		0x029C /* Design Config 8 */
 #define GEM_DCFG10		0x02A4 /* Design Config 10 */
+#define GEM_DCFG12		0x02AC /* Design Config 12 */
+#define GEM_USX_CONTROL		0x0A80 /* USXGMII control register */
+#define GEM_USX_STATUS		0x0A88 /* USXGMII status register */
 
 #define GEM_TXBDCTRL	0x04cc /* TX Buffer Descriptor control register */
 #define GEM_RXBDCTRL	0x04d0 /* RX Buffer Descriptor control register */
@@ -274,6 +278,8 @@
 #define MACB_IRXFCS_SIZE	1
 
 /* GEM specific NCR bitfields. */
+#define GEM_ENABLE_HS_MAC_OFFSET	31
+#define GEM_ENABLE_HS_MAC_SIZE		1
 #define GEM_TWO_PT_FIVE_GIG_OFFSET	29
 #define GEM_TWO_PT_FIVE_GIG_SIZE	1
 
@@ -465,6 +471,10 @@
 #define MACB_REV_OFFSET				0
 #define MACB_REV_SIZE				16
 
+/* Bitfield in HS_MAC_CONFIG */
+#define GEM_HS_MAC_SPEED_OFFSET			0
+#define GEM_HS_MAC_SPEED_SIZE			3
+
 /* Bitfields in PCS_CONTROL. */
 #define GEM_PCS_CTRL_RST_OFFSET			15
 #define GEM_PCS_CTRL_RST_SIZE			1
@@ -510,6 +520,34 @@
 #define GEM_RXBD_RDBUFF_OFFSET			8
 #define GEM_RXBD_RDBUFF_SIZE			4
 
+/* Bitfields in DCFG12. */
+#define GEM_HIGH_SPEED_OFFSET			26
+#define GEM_HIGH_SPEED_SIZE			1
+
+/* Bitfields in USX_CONTROL. */
+#define GEM_USX_CTRL_SPEED_OFFSET		14
+#define GEM_USX_CTRL_SPEED_SIZE			3
+#define GEM_SERDES_RATE_OFFSET			12
+#define GEM_SERDES_RATE_SIZE			2
+#define GEM_RX_SCR_BYPASS_OFFSET		9
+#define GEM_RX_SCR_BYPASS_SIZE			1
+#define GEM_TX_SCR_BYPASS_OFFSET		8
+#define GEM_TX_SCR_BYPASS_SIZE			1
+#define GEM_RX_SYNC_RESET_OFFSET		2
+#define GEM_RX_SYNC_RESET_SIZE			1
+#define GEM_TX_EN_OFFSET			1
+#define GEM_TX_EN_SIZE				1
+#define GEM_SIGNAL_OK_OFFSET			0
+#define GEM_SIGNAL_OK_SIZE			1
+
+/* Bitfields in USX_STATUS. */
+#define GEM_USX_TX_FAULT_OFFSET			28
+#define GEM_USX_TX_FAULT_SIZE			1
+#define GEM_USX_RX_FAULT_OFFSET			27
+#define GEM_USX_RX_FAULT_SIZE			1
+#define GEM_USX_BLOCK_LOCK_OFFSET		0
+#define GEM_USX_BLOCK_LOCK_SIZE			1
+
 /* Bitfields in TISUBN */
 #define GEM_SUBNSINCR_OFFSET			0
 #define GEM_SUBNSINCR_SIZE			16
@@ -670,6 +708,7 @@
 #define MACB_CAPS_MACB_IS_GEM			BIT(31)
 #define MACB_CAPS_PCS				BIT(24)
 #define MACB_CAPS_MACB_IS_GEM_GXL		BIT(25)
+#define MACB_CAPS_HIGH_SPEED			BIT(26)
 
 #define MACB_GEM7010_IDNUM			0x009
 #define MACB_GEM7014_IDNU			0x107
@@ -749,6 +788,7 @@
 	})
 
 #define MACB_READ_NSR(bp)	macb_readl(bp, NSR)
+#define GEM_READ_USX_STATUS(bp)	gem_readl(bp, USX_STATUS)
 
 /* struct macb_dma_desc - Hardware DMA descriptor
  * @addr: DMA address of data buffer
@@ -1262,6 +1302,7 @@ struct macb {
 	struct macb_pm_data pm_data;
 	struct phylink *pl;
 	struct phylink_config pl_config;
+	u32 serdes_rate;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 94145e460e6e..65eda399aef8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -84,6 +84,20 @@ static struct sifive_fu540_macb_mgmt *mgmt;
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
 
+enum {
+	HS_MAC_SPEED_100M,
+	HS_MAC_SPEED_1000M,
+	HS_MAC_SPEED_2500M,
+	HS_MAC_SPEED_5000M,
+	HS_MAC_SPEED_10000M,
+	HS_MAC_SPEED_25000M,
+};
+
+enum {
+	MACB_SERDES_RATE_5_PT_15625Gbps = 5,
+	MACB_SERDES_RATE_10_PT_3125Gbps = 10,
+};
+
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
@@ -93,6 +107,8 @@ static struct sifive_fu540_macb_mgmt *mgmt;
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
 
+#define MACB_USX_BLOCK_LOCK_TIMEOUT	1000000 /* in usecs */
+
 /* DMA buffer descriptor might be different size
  * depends on hardware configuration:
  *
@@ -439,23 +455,37 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
  */
 static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
 {
+	struct macb *bp = netdev_priv(dev);
 	long ferr, rate, rate_rounded;
 
 	if (!clk)
 		return;
 
-	switch (speed) {
-	case SPEED_10:
-		rate = 2500000;
-		break;
-	case SPEED_100:
-		rate = 25000000;
-		break;
-	case SPEED_1000:
-		rate = 125000000;
-		break;
-	default:
-		return;
+	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+		switch (bp->serdes_rate) {
+		case MACB_SERDES_RATE_5_PT_15625Gbps:
+			rate = 78125000;
+			break;
+		case MACB_SERDES_RATE_10_PT_3125Gbps:
+			rate = 156250000;
+			break;
+		default:
+			return;
+		}
+	} else {
+		switch (speed) {
+		case SPEED_10:
+			rate = 2500000;
+			break;
+		case SPEED_100:
+			rate = 25000000;
+			break;
+		case SPEED_1000:
+			rate = 125000000;
+			break;
+		default:
+			return;
+		}
 	}
 
 	rate_rounded = clk_round_rate(clk, rate);
@@ -485,6 +515,21 @@ static void gem_phylink_validate(struct phylink_config *pl_config,
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_NA:
+	case PHY_INTERFACE_MODE_USXGMII:
+	case PHY_INTERFACE_MODE_10GKR:
+		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
+			phylink_set(mask, 10000baseCR_Full);
+			phylink_set(mask, 10000baseER_Full);
+			phylink_set(mask, 10000baseKR_Full);
+			phylink_set(mask, 10000baseLR_Full);
+			phylink_set(mask, 10000baseLRM_Full);
+			phylink_set(mask, 10000baseSR_Full);
+			phylink_set(mask, 10000baseT_Full);
+			phylink_set(mask, 5000baseT_Full);
+			phylink_set(mask, 2500baseX_Full);
+			phylink_set(mask, 1000baseX_Full);
+		}
+	/* fallthrough */
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 	case PHY_INTERFACE_MODE_RGMII:
@@ -516,6 +561,91 @@ static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
 	return -EOPNOTSUPP;
 }
 
+static int macb_wait_for_usx_block_lock(struct macb *bp)
+{
+	u32 val;
+
+	return readx_poll_timeout(GEM_READ_USX_STATUS, bp, val,
+				  val & GEM_BIT(USX_BLOCK_LOCK),
+				  1, MACB_USX_BLOCK_LOCK_TIMEOUT);
+}
+
+static inline int gem_mac_usx_configure(struct macb *bp, int spd)
+{
+	u32 speed, config;
+
+	gem_writel(bp, NCFGR, GEM_BIT(PCSSEL) |
+		   (~GEM_BIT(SGMIIEN) & gem_readl(bp, NCFGR)));
+	gem_writel(bp, NCR, gem_readl(bp, NCR) |
+		   GEM_BIT(ENABLE_HS_MAC));
+	gem_writel(bp, NCFGR, gem_readl(bp, NCFGR) |
+		   MACB_BIT(FD));
+	config = gem_readl(bp, USX_CONTROL);
+	config = GEM_BFINS(SERDES_RATE, bp->serdes_rate, config);
+	config &= ~GEM_BIT(TX_SCR_BYPASS);
+	config &= ~GEM_BIT(RX_SCR_BYPASS);
+	gem_writel(bp, USX_CONTROL, config |
+		   GEM_BIT(TX_EN));
+	config = gem_readl(bp, USX_CONTROL);
+	gem_writel(bp, USX_CONTROL, config | GEM_BIT(SIGNAL_OK));
+	if (macb_wait_for_usx_block_lock(bp) < 0) {
+		netdev_warn(bp->dev, "USXGMII block lock failed");
+		return -ETIMEDOUT;
+	}
+
+	switch (spd) {
+	case SPEED_10000:
+		if (bp->serdes_rate >= MACB_SERDES_RATE_10_PT_3125Gbps) {
+			speed = HS_MAC_SPEED_10000M;
+		} else {
+			netdev_warn(bp->dev, "10G speed isn't supported by HW");
+			netdev_warn(bp->dev, "Setting speed to 1G");
+			speed = HS_MAC_SPEED_1000M;
+		}
+		break;
+	case SPEED_5000:
+		speed = HS_MAC_SPEED_5000M;
+		break;
+	case SPEED_2500:
+		speed = HS_MAC_SPEED_2500M;
+		break;
+	case SPEED_1000:
+		speed = HS_MAC_SPEED_1000M;
+		break;
+	default:
+	case SPEED_100:
+		speed = HS_MAC_SPEED_100M;
+		break;
+	}
+
+	gem_writel(bp, HS_MAC_CONFIG, GEM_BFINS(HS_MAC_SPEED, speed,
+						gem_readl(bp, HS_MAC_CONFIG)));
+	gem_writel(bp, USX_CONTROL, GEM_BFINS(USX_CTRL_SPEED, speed,
+					      gem_readl(bp, USX_CONTROL)));
+	return 0;
+}
+
+static inline void gem_mac_configure(struct macb *bp, int speed)
+{
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
+		gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
+			   GEM_BIT(PCSSEL) |
+			   gem_readl(bp, NCFGR));
+
+	switch (speed) {
+	case SPEED_1000:
+		gem_writel(bp, NCFGR, GEM_BIT(GBE) |
+			   gem_readl(bp, NCFGR));
+		break;
+	case SPEED_100:
+		macb_writel(bp, NCFGR, MACB_BIT(SPD) |
+			    macb_readl(bp, NCFGR));
+		break;
+	default:
+		break;
+	}
+}
+
 static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			   const struct phylink_link_state *state)
 {
@@ -551,26 +681,20 @@ static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
 			reg &= ~GEM_BIT(GBE);
 		macb_or_gem_writel(bp, NCFGR, reg);
 
-		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
-			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
-				   GEM_BIT(PCSSEL) |
-				   gem_readl(bp, NCFGR));
-
 		reg = macb_readl(bp, NCFGR);
 		if (state->duplex)
 			reg |= MACB_BIT(FD);
+		macb_or_gem_writel(bp, NCFGR, reg);
 
-		switch (state->speed) {
-		case SPEED_1000:
-			reg |= GEM_BIT(GBE);
-			break;
-		case SPEED_100:
-			reg |= MACB_BIT(SPD);
-			break;
-		default:
-			break;
+		if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
+			if (gem_mac_usx_configure(bp, state->speed) < 0) {
+				spin_unlock_irqrestore(&bp->lock, flags);
+				phylink_mac_change(bp->pl, false);
+				return;
+			}
+		} else {
+			gem_mac_configure(bp, state->speed);
 		}
-		macb_or_gem_writel(bp, NCFGR, reg);
 
 		bp->speed = state->speed;
 		bp->duplex = state->duplex;
@@ -3417,6 +3541,9 @@ static void macb_configure_caps(struct macb *bp,
 		default:
 			break;
 		}
+		dcfg = gem_readl(bp, DCFG12);
+		if (GEM_BFEXT(HIGH_SPEED, dcfg) == 1)
+			bp->caps |= MACB_CAPS_HIGH_SPEED;
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
@@ -4405,7 +4532,18 @@ static int macb_probe(struct platform_device *pdev)
 	} else if (bp->caps & MACB_CAPS_MACB_IS_GEM_GXL) {
 		u32 interface_supported = 1;
 
-		if (phy_mode == PHY_INTERFACE_MODE_SGMII) {
+		if (phy_mode == PHY_INTERFACE_MODE_USXGMII) {
+			if (!(bp->caps & MACB_CAPS_HIGH_SPEED &&
+			      bp->caps & MACB_CAPS_PCS))
+				interface_supported = 0;
+
+			if (of_property_read_u32(np, "serdes-rate-gbps",
+						 &bp->serdes_rate)) {
+				netdev_err(dev,
+					   "GEM serdes_rate not specified");
+				interface_supported = 0;
+			}
+		} else if (phy_mode == PHY_INTERFACE_MODE_SGMII) {
 			if (!(bp->caps & MACB_CAPS_PCS))
 				interface_supported = 0;
 		} else if (phy_mode == PHY_INTERFACE_MODE_GMII ||
-- 
2.17.1

