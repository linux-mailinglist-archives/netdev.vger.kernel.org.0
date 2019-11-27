Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB7710AD12
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 10:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfK0J7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 04:59:36 -0500
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:6881
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbfK0J7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 04:59:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VostKQACndPTDafVQ0vkxaVge44oZgydkbBWu4BFbKDSnQRqCIR+d3901TpXfmoCYlt8XhVf1AFj9g4bPeFLBPuiR1zhSuLo0BU4Sw14/f3fF3MxmiDm1ZsEJ3mojGREtE1RAq/y+qOr0CT+35vHEyrLCMTpgUfGbshH23jMJS1DwFM5xwgbNEPk/iz1GktABDiqJyJl4qbtrJwYf+6q1fY9H6KqHtQyAByO0hdSlPBZg/0halv82W0M1fIFZAGweH7vhdviAFGDTe33N1cVmXt8qJU9stAGCewbsyRKk9cbK430fzN5fQ0qdwY+nyzG0tZsd+lOruhglQl7aA37IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbgI0a9MySwr59pE+Jx3uxJM1wE0sjpdcL/vI9ca6jc=;
 b=CNZTqsyEM2ht3DAbA1REYGG87E8YfyU3UoaXtN9JMWzRY2beG1bDCHg/mrap0ecWjyHDvmUnlZI/xRcBrBqdzOJw7GU09pQctEJsTqKMVGcU9whhpNkMTP8x0UqLsT4J/w8/3HJ8+72F/bfEtdw/SfXyRm4ZCKA6xSxxTghKD6lMbuIhf51S3AdNbuDyxB3mLL9uI25Wcd4GfxhmxFgkYxbvCAZEX2pIuaHFlr16dwT1vw3mRYTkoYeLrYgfQT6cofkFuZMF3dxkJOIUWwwLpegFKLNueZgEhwMC+JHaNy3QU5xwfcizHYWAE5gVH9SsWK918a5PzKrBxMPQthYwHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbgI0a9MySwr59pE+Jx3uxJM1wE0sjpdcL/vI9ca6jc=;
 b=R4MRZa6ieRqijqDNQiGJeTC01r8+ltfHrOr++18BCj1M1SzZdMmRuYWjUFjAkxbgCADfvKRP8bhnYjmD0jeEM5OvyTAEF6Ssjk9iTdfpEjwhp1oQkESvHSB2pRQRbvpEb6lxLUKJY0bIiiHDW9mtiRKrE2bzGmvBd25FCrZXsKg=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6558.eurprd04.prod.outlook.com (20.179.232.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Wed, 27 Nov 2019 09:59:30 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 09:59:30 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
Subject: [v1,net-next, 2/2] enetc: implement the enetc 802.1Qbu hardware
 function
Thread-Topic: [v1,net-next, 2/2] enetc: implement the enetc 802.1Qbu hardware
 function
Thread-Index: AQHVpQlc7ro1OG7YiUanY6BZ5H4mAA==
Date:   Wed, 27 Nov 2019 09:59:30 +0000
Message-ID: <20191127094517.6255-2-Po.Liu@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
In-Reply-To: <20191127094517.6255-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN4PR0601CA0003.namprd06.prod.outlook.com
 (2603:10b6:803:2f::13) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b07cea1-ed07-4ba6-6375-08d773207e9f
x-ms-traffictypediagnostic: VE1PR04MB6558:|VE1PR04MB6558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6558024498794EA7575505E492440@VE1PR04MB6558.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(6512007)(6436002)(6486002)(1076003)(76176011)(102836004)(86362001)(386003)(6506007)(2501003)(446003)(5660300002)(66556008)(66946007)(66476007)(64756008)(66446008)(2616005)(11346002)(30864003)(2201001)(186003)(7416002)(305945005)(6116002)(3846002)(25786009)(7736002)(26005)(50226002)(8676002)(81156014)(478600001)(8936002)(2906002)(4326008)(52116002)(66066001)(14454004)(81166006)(36756003)(110136005)(256004)(99286004)(54906003)(71200400001)(71190400001)(316002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6558;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DuOOlRmglvKlYKFM8lW9t9GcpcIS+/UXuCqGdNVYLnW0HhANcxmVyOqfvNBOMIeLbqQk1yNo/9K0X6pSGZ0pcxc4ECwQm89mJgkNvwP9Gue6Xeols6a2sMobsY0cEWCJjrq0vVkot2foXtzTa1LKjha3gdnfFQSqe1fsq4ylHp4bAXVLJXhcuu12kolVmYssN0b7NFafdu8889lifHikfaC3IrHuo6eHVww3CIX/F43XXxfspM32Midk4DwH0t8OJpB9TsYL6yjHAcDV11U2I+glDasFlb9ZbpnaEQYFZwr+tXvVijgCSB2YQoCsjiCgkpWZU7uu+Z+vSq6FrUDZUZOWdXo6e/wf+rBYcF5nCBbL5BEQGjaVFzsvsi7a0hXL+pB5qWcur/fpPWNd2/iNHaFDIy9AoYZy5ddgGszwjIIpUNLd+Ah5vR79cvNn41dR
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b07cea1-ed07-4ba6-6375-08d773207e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 09:59:30.4292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGSPSH2HNEuK37mPnROSwemlc+fyS0YwO8j4urKPQaMRMYGaM2iV0+ZR/wl8L/FG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6558
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interface follow up the ethtool 'preemption' set/get.
Hardware features also need to set hw_features with
NETIF_F_PREEMPTION flag. So ethtool could check kernel
link features if there is preemption capability of port.

There are two MACs in ENETC. One is express MAC which traffic
classes in it are advanced transmition. Another is preemptable
MAC which traffic classes are frame preemptable.

The hardware need to initialize the MACs at initial stage.
And then set the preemption enable registers of traffic
classes when ethtool set .get_link_ksettings/.set_link_ksettings
stage.

To test the ENETC preemption capability, user need to set mqprio
or taprio to mapping the traffic classes with priorities. Then
use ethtool command to set 'preemption' with a 8 bits value.
MSB represent high number traffic class.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  |   3 +
 drivers/net/ethernet/freescale/enetc/enetc.h  |   4 +
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 142 ++++++++++++++++--
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  17 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  15 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   4 +
 6 files changed, 174 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 9db1b96ed9b9..be0d9916e6ea 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -750,6 +750,8 @@ void enetc_get_si_caps(struct enetc_si *si)
=20
 	if (val & ENETC_SIPCAPR0_QBV)
 		si->hw_features |=3D ENETC_SI_F_QBV;
+	if (val & ENETC_SIPCAPR0_QBU)
+		si->hw_features |=3D ENETC_SI_F_QBU;
 }
=20
 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
@@ -1448,6 +1450,7 @@ static int enetc_setup_tc_mqprio(struct net_device *n=
dev, void *type_data)
 	num_tc =3D mqprio->num_tc;
=20
 	if (!num_tc) {
+		enetc_preemption_set(ndev, 0);
 		netdev_reset_tc(ndev);
 		netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
=20
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 7ee0da6d0015..cfa74fa326e8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -119,6 +119,7 @@ enum enetc_errata {
 };
=20
 #define ENETC_SI_F_QBV BIT(0)
+#define ENETC_SI_F_QBU BIT(1)
=20
 /* PCI IEP device data */
 struct enetc_si {
@@ -177,6 +178,7 @@ enum enetc_active_offloads {
 	ENETC_F_RX_TSTAMP	=3D BIT(0),
 	ENETC_F_TX_TSTAMP	=3D BIT(1),
 	ENETC_F_QBV             =3D BIT(2),
+	ENETC_F_QBU		=3D BIT(3),
 };
=20
 struct enetc_ndev_priv {
@@ -261,3 +263,5 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *t=
ype_data);
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #endif
+
+int enetc_preemption_set(struct net_device *ndev, u32 ptvector);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers=
/net/ethernet/freescale/enetc/enetc_ethtool.c
index 880a8ed8bb47..4c7425539280 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -183,6 +183,21 @@ static const struct {
 	{ ENETC_PICDR(3),   "ICM DR3 discarded frames" },
 };
=20
+static const struct {
+	int reg;
+	char name[ETH_GSTRING_LEN];
+} enetc_pmac_counters[] =3D {
+	{ ENETC_PM1_RFRM,   "PMAC rx frames" },
+	{ ENETC_PM1_RPKT,   "PMAC rx packets" },
+	{ ENETC_PM1_RDRP,   "PMAC rx dropped packets" },
+	{ ENETC_PM1_RFRG,   "PMAC rx fragment packets" },
+	{ ENETC_PM1_TFRM,   "PMAC tx frames" },
+	{ ENETC_PM1_TERR,   "PMAC tx error frames" },
+	{ ENETC_PM1_TPKT,   "PMAC tx packets" },
+	{ ENETC_MAC_MERGE_MMFCRXR,   "MAC merge fragment rx counter" },
+	{ ENETC_MAC_MERGE_MMFCTXR,   "MAC merge fragment tx counter"},
+};
+
 static const char rx_ring_stats[][ETH_GSTRING_LEN] =3D {
 	"Rx ring %2d frames",
 	"Rx ring %2d alloc errors",
@@ -195,15 +210,24 @@ static const char tx_ring_stats[][ETH_GSTRING_LEN] =
=3D {
 static int enetc_get_sset_count(struct net_device *ndev, int sset)
 {
 	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	int len;
+
+	if (sset !=3D ETH_SS_STATS)
+		return -EOPNOTSUPP;
=20
-	if (sset =3D=3D ETH_SS_STATS)
-		return ARRAY_SIZE(enetc_si_counters) +
-			ARRAY_SIZE(tx_ring_stats) * priv->num_tx_rings +
-			ARRAY_SIZE(rx_ring_stats) * priv->num_rx_rings +
-			(enetc_si_is_pf(priv->si) ?
-			ARRAY_SIZE(enetc_port_counters) : 0);
+	len =3D ARRAY_SIZE(enetc_si_counters) +
+	      ARRAY_SIZE(tx_ring_stats) * priv->num_tx_rings +
+	      ARRAY_SIZE(rx_ring_stats) * priv->num_rx_rings;
=20
-	return -EOPNOTSUPP;
+	if (!enetc_si_is_pf(priv->si))
+		return len;
+
+	len +=3D ARRAY_SIZE(enetc_port_counters);
+
+	if (priv->active_offloads & ENETC_F_QBU)
+		len +=3D ARRAY_SIZE(enetc_pmac_counters);
+
+	return len;
 }
=20
 static void enetc_get_strings(struct net_device *ndev, u32 stringset, u8 *=
data)
@@ -241,6 +265,16 @@ static void enetc_get_strings(struct net_device *ndev,=
 u32 stringset, u8 *data)
 				ETH_GSTRING_LEN);
 			p +=3D ETH_GSTRING_LEN;
 		}
+
+		if (!(priv->active_offloads & ENETC_F_QBU))
+			break;
+
+		for (i =3D 0; i < ARRAY_SIZE(enetc_pmac_counters); i++) {
+			strlcpy(p, enetc_pmac_counters[i].name,
+				ETH_GSTRING_LEN);
+			p +=3D ETH_GSTRING_LEN;
+		}
+
 		break;
 	}
 }
@@ -268,6 +302,12 @@ static void enetc_get_ethtool_stats(struct net_device =
*ndev,
=20
 	for (i =3D 0; i < ARRAY_SIZE(enetc_port_counters); i++)
 		data[o++] =3D enetc_port_rd(hw, enetc_port_counters[i].reg);
+
+	if (!(priv->active_offloads & ENETC_F_QBU))
+		return;
+
+	for (i =3D 0; i < ARRAY_SIZE(enetc_pmac_counters); i++)
+		data[o++] =3D enetc_port_rd(hw, enetc_pmac_counters[i].reg);
 }
=20
 #define ENETC_RSSHASH_L3 (RXH_L2DA | RXH_VLAN | RXH_L3_PROTO | RXH_IP_SRC =
| \
@@ -609,6 +649,90 @@ static int enetc_set_wol(struct net_device *dev,
 	return ret;
 }
=20
+static u8 enetc_get_tc_num(struct enetc_si *si)
+{
+	struct net_device *ndev =3D si->ndev;
+	u8 tc_num;
+
+	tc_num =3D (enetc_port_rd(&si->hw, ENETC_PCAPR1)
+		  & ENETC_NUM_TCS_MASK) >> 4;
+
+	return min(netdev_get_num_tc(ndev), tc_num + 1);
+}
+
+int enetc_preemption_set(struct net_device *ndev, u32 ptvector)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	u8 tc_num;
+	u32 temp;
+	int i;
+
+	if (ptvector & ~ENETC_QBU_TC_MASK)
+		return -EINVAL;
+
+	temp =3D enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET);
+	if (temp & ENETC_QBV_TGE)
+		enetc_wr(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET,
+			 temp & (~ENETC_QBV_TGPE));
+
+	tc_num =3D enetc_get_tc_num(priv->si);
+
+	for (i =3D 0; i < tc_num; i++) {
+		temp =3D enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(i));
+
+		if ((ptvector >> i) & 0x1)
+			enetc_port_wr(&priv->si->hw,
+				      ENETC_PTCFPR(i),
+				      temp | ENETC_FPE);
+		else
+			enetc_port_wr(&priv->si->hw,
+				      ENETC_PTCFPR(i),
+				      temp & ~ENETC_FPE);
+	}
+
+	return 0;
+}
+
+static u32 enetc_preemption_get(struct net_device *ndev)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	u32 ptvector =3D 0;
+	u8 tc_num;
+	int i;
+
+	/* If preemptable MAC is not enable return 0 */
+	if (!(enetc_port_rd(&priv->si->hw, ENETC_PFPMR) & ENETC_PFPMR_PMACE))
+		return 0;
+
+	tc_num =3D enetc_get_tc_num(priv->si);
+
+	for (i =3D 0; i < tc_num; i++)
+		if (enetc_port_rd(&priv->si->hw, ENETC_PTCFPR(i)) & ENETC_FPE)
+			ptvector |=3D 1 << i;
+
+	return ptvector;
+}
+
+static int enetc_get_link_ksettings(struct net_device *ndev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	cmd->base.preemption =3D enetc_preemption_get(ndev);
+
+	return phy_ethtool_get_link_ksettings(ndev, cmd);
+}
+
+static int enetc_set_link_ksettings(struct net_device *ndev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	int err;
+
+	err =3D enetc_preemption_set(ndev, cmd->base.preemption);
+	if (err)
+		return err;
+
+	return phy_ethtool_set_link_ksettings(ndev, cmd);
+}
+
 static const struct ethtool_ops enetc_pf_ethtool_ops =3D {
 	.get_regs_len =3D enetc_get_reglen,
 	.get_regs =3D enetc_get_regs,
@@ -622,8 +746,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops =
=3D {
 	.get_rxfh =3D enetc_get_rxfh,
 	.set_rxfh =3D enetc_set_rxfh,
 	.get_ringparam =3D enetc_get_ringparam,
-	.get_link_ksettings =3D phy_ethtool_get_link_ksettings,
-	.set_link_ksettings =3D phy_ethtool_set_link_ksettings,
+	.get_link_ksettings =3D enetc_get_link_ksettings,
+	.set_link_ksettings =3D enetc_set_link_ksettings,
 	.get_link =3D ethtool_op_get_link,
 	.get_ts_info =3D enetc_get_ts_info,
 	.get_wol =3D enetc_get_wol,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index 51f543ef37a8..b609ec095710 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -19,6 +19,7 @@
 #define ENETC_SICTR1	0x1c
 #define ENETC_SIPCAPR0	0x20
 #define ENETC_SIPCAPR0_QBV	BIT(4)
+#define ENETC_SIPCAPR0_QBU	BIT(3)
 #define ENETC_SIPCAPR0_RSS	BIT(8)
 #define ENETC_SIPCAPR1	0x24
 #define ENETC_SITGTGR	0x30
@@ -176,6 +177,7 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PCAPR0_RXBDR(val)	((val) >> 24)
 #define ENETC_PCAPR0_TXBDR(val)	(((val) >> 16) & 0xff)
 #define ENETC_PCAPR1		0x0904
+#define ENETC_NUM_TCS_MASK	GENMASK(6, 4)
 #define ENETC_PSICFGR0(n)	(0x0940 + (n) * 0xc)  /* n =3D SI index */
 #define ENETC_PSICFGR0_SET_TXBDR(val)	((val) & 0xff)
 #define ENETC_PSICFGR0_SET_RXBDR(val)	(((val) & 0xff) << 16)
@@ -223,6 +225,7 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_SET_TX_MTU(val)	((val) << 16)
 #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
 #define ENETC_PM0_IF_MODE	0x8300
+#define ENETC_PM1_IF_MODE       0x9300
 #define ENETC_PMO_IFM_RG	BIT(2)
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
 #define ENETC_PM0_IFM_RGAUTO	(BIT(15) | ENETC_PMO_IFM_RG | BIT(1))
@@ -276,6 +279,15 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_TSCOL		0x82E0
 #define ENETC_PM0_TLCOL		0x82E8
 #define ENETC_PM0_TECOL		0x82F0
+#define ENETC_PM1_RFRM		0x9120
+#define ENETC_PM1_RDRP		0x9158
+#define ENETC_PM1_RPKT		0x9160
+#define ENETC_PM1_RFRG		0x91B8
+#define ENETC_PM1_TFRM		0x9220
+#define ENETC_PM1_TERR		0x9238
+#define ENETC_PM1_TPKT		0x9260
+#define ENETC_MAC_MERGE_MMFCRXR	0x1f14
+#define ENETC_MAC_MERGE_MMFCTXR	0x1f18
=20
 /* Port counters */
 #define ENETC_PICDR(n)		(0x0700 + (n) * 8) /* n =3D [0..3] */
@@ -615,3 +627,8 @@ struct enetc_cbd {
 /* Port time gating capability register */
 #define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
 #define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+
+#define ENETC_QBU_TC_MASK	GENMASK(7, 0)
+
+#define ENETC_PTCFPR(n)         (0x1910 + (n) * 4)
+#define ENETC_FPE               BIT(31)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_pf.c
index e7482d483b28..f1873c4da77f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -523,10 +523,15 @@ static void enetc_configure_port_mac(struct enetc_hw =
*hw)
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
 		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
 	/* set auto-speed for RGMII */
-	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
+	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG) {
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);
-	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) =3D=3D ENETC_G_EPFBLPR1_XGMII=
)
+		enetc_port_wr(hw, ENETC_PM1_IF_MODE, ENETC_PM0_IFM_RGAUTO);
+	}
+
+	if (enetc_global_rd(hw, ENETC_G_EPFBLPR(1)) =3D=3D ENETC_G_EPFBLPR1_XGMII=
) {
 		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_XGMII);
+		enetc_port_wr(hw, ENETC_PM1_IF_MODE, ENETC_PM0_IFM_XGMII);
+	}
 }
=20
 static void enetc_configure_port_pmac(struct enetc_hw *hw)
@@ -745,6 +750,12 @@ static void enetc_pf_netdev_setup(struct enetc_si *si,=
 struct net_device *ndev,
 	if (si->hw_features & ENETC_SI_F_QBV)
 		priv->active_offloads |=3D ENETC_F_QBV;
=20
+	if (si->hw_features & ENETC_SI_F_QBU) {
+		ndev->hw_features |=3D NETIF_F_PREEMPTION;
+		ndev->features |=3D NETIF_F_PREEMPTION;
+		priv->active_offloads |=3D ENETC_F_QBU;
+	}
+
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
index 2e99438cb1bf..94dde847d052 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -169,6 +169,10 @@ int enetc_setup_tc_taprio(struct net_device *ndev, voi=
d *type_data)
 					   priv->tx_ring[i]->index,
 					   taprio->enable ? 0 : i);
=20
+	/* preemption off if TC priority is all 0 */
+	if ((err && taprio->enable) || !(err || taprio->enable))
+		enetc_preemption_set(ndev, 0);
+
 	return err;
 }
=20
--=20
2.17.1

