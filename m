Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1028D129131
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 04:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfLWDoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 22:44:24 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:11910
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbfLWDoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 22:44:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYegHxSD6hEo6KIOY6udSxSNn3SQotHmvywitP/7QJcLnOXwRmmKMBBbkgqIViWcNRlbt81gTTIOd45OTcuQgxnrHIc8NOUW5ezTbyk63BRNtkw3sGueJ63Xo1ZpLpWTnwJ/2PHdCeyGIyHx4OZ6MqukucQuS6UoBNQ95S+cMgAlzC5HS51ZpQCK/FTNV+F2T2jF/p515eDRLlFmyzOYySLr1SD0+XqudxPOTYjWJZw8dx2LW6QGJVuT7R0VvLPTCtz294gGIxz1Yi5RpOzb0ZGeH6aE8Usfx/PFn01WXgZut+PbkXnm28JwcRBktqS0CZhrU3aIAFM0cudonW5WAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5mf9LUL8MhQ1DvdHmy/b2UIQuDY61HBF9LYonzTcYk=;
 b=WfnCjHeahLrnQmCqslzmxWNMB0MslHb0bVVRPt3i88i2pYk+fEaUCvhvyOpuzSNAnJZXoqgJzc9yChLK46gdCx9WiwbfNwdpB0/u1YuZAZ2Gi0KPLq2dHToU8LSW6AlrKT8Iq4Wq6oxWTlFmB+nk0t9oSrY5lHC0C08QgyhYNaUc6ND6yXINDt1/07XHpVKLRzSjlnju5eJkBakTGQQFOHVNMD6GwvcmFwRkRIiKjReQb6AKHhW6Moj7E0hVucorrjquwcy1Qlvi1qYtJ88Z3ET/hZyFFfXqROuElpjobhmpxobMtl4dXQ6ufPFGBEEVd8lQ2tmqKZ7jSYv7MKeaIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5mf9LUL8MhQ1DvdHmy/b2UIQuDY61HBF9LYonzTcYk=;
 b=BNbCnBMIxHhsWTiS3oyRl7pOOVl/xOeoZ1kAJVIyhAIhGUgTACCVfw3AXNLAPHgRFSyKfqTyVvD20I+Y6diZlZwqZrwvnrnWZBS1m4x6cc1TMesSTniBZX1acotEy7tIuCuYIlpZflkFrZdsMQmFleVXVG2koFRJ+VqoxmnmfUY=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6672.eurprd04.prod.outlook.com (20.179.235.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.13; Mon, 23 Dec 2019 03:42:39 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc%3]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 03:42:39 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        Po Liu <po.liu@nxp.com>
Subject: [net-next] enetc: add support time specific departure base on the qos
 etf
Thread-Topic: [net-next] enetc: add support time specific departure base on
 the qos etf
Thread-Index: AQHVuUMFGbRcJW58xE+CKKbOYElKEg==
Date:   Mon, 23 Dec 2019 03:42:39 +0000
Message-ID: <20191223032618.18205-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN4PR0201CA0025.namprd02.prod.outlook.com
 (2603:10b6:803:2e::11) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32d2a83c-2f0d-4709-a006-08d7875a2828
x-ms-traffictypediagnostic: VE1PR04MB6672:|VE1PR04MB6672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6672AF8A90C1E3773E9731FD922E0@VE1PR04MB6672.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(189003)(199004)(66446008)(2616005)(36756003)(71200400001)(6486002)(66946007)(66476007)(1076003)(64756008)(110136005)(66556008)(54906003)(6512007)(316002)(4326008)(52116002)(5660300002)(2906002)(81166006)(478600001)(81156014)(8676002)(6506007)(8936002)(26005)(86362001)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6672;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3J9dm6mzCIjIP2IT6asxhuXKwww296t1l8f+Pwr+DRPRcCAE2ys/8t5SwNlL36uL+l7hemRw4576eY+F6UAwcbgw+6LumEDNq89rWFhCyurG6wHpNGTgwZsnCT09zwmTUKT0BxMXgRQE1l0Nq3sfE6AQ5Vnr1f76t7RbOXnGH8v6WmEFxSo7PpPsbefjp0LletNLE7+K7O3eKl6nyQZvBiI37ecCITXTFJy2CeEFXjNgu08ErH77NxxBu4vA08St3GnMkJBluGuEM864RhbUpCW8E1mEGA1a8LdsSIERjbgoBSxHGOnIGajvusPOU+Lka6jJQTojzIYR/gktCelNWuayDHsGUT66r4ToRlEVeUbJiS3fV5rUzL0LY8pRFtEPTbJvoWFLblKyKpJsSl9RTQc6JJTuu+idANwpcIHf42cTWrti3fQDdm/g3wTNCp3H
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d2a83c-2f0d-4709-a006-08d7875a2828
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 03:42:39.1669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kDQFwrf6xTFIYyQ77Zk3B0N5GqHRudfbZ5FsZBo+z077QPy5P+83+KAM9QOjuQKT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENETC implement time specific departure capability, which enables
the user to specify when a frame can be transmitted. When this
capability is enabled, the device will delay the transmission of
the frame so that it can be transmitted at the precisely specified time.
The delay departure time up to 0.5 seconds in the future. If the
departure time in the transmit BD has not yet been reached, based
on the current time, the packet will not be transmitted.

This driver was loaded by Qos driver ETF. User could load it by tc
commands. Here are the example commands:

tc qdisc add dev eth0 root handle 1: mqprio \
	   num_tc 8 map 0 1 2 3 4 5 6 7 hw 1
tc qdisc replace dev eth0 parent 1:8 etf \
	   clockid CLOCK_TAI delta 30000  offload

These example try to set queue mapping first and then set queue 7
with 30us ahead dequeue time.

Then user send test frame should set SO_TXTIME feature for socket.

There are also some limitations for this feature in hardware:
- Transmit checksum offloads and time specific departure operation
are mutually exclusive.
- Time Aware Shaper feature (Qbv) offload and time specific departure
operation are mutually exclusive.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 12 +++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 10 +++++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 +++++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 2ee4a2cd4780..1f79e36116a3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -149,11 +149,21 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ri=
ng, struct sk_buff *skb,
=20
 	if (enetc_tx_csum(skb, &temp_bd))
 		flags |=3D ENETC_TXBD_FLAGS_CSUM | ENETC_TXBD_FLAGS_L4CS;
+	else if (tx_ring->tsd_enable)
+		flags |=3D ENETC_TXBD_FLAGS_TSE | ENETC_TXBD_FLAGS_TXSTART;
=20
 	/* first BD needs frm_len and offload flags set */
 	temp_bd.frm_len =3D cpu_to_le16(skb->len);
 	temp_bd.flags =3D flags;
=20
+	if (flags & ENETC_TXBD_FLAGS_TSE) {
+		u32 temp;
+
+		temp =3D (skb->skb_mstamp_ns >> 5 & ENETC_TXBD_TXSTART_MASK)
+			| (flags << ENETC_TXBD_FLAGS_OFFSET);
+		temp_bd.txstart =3D cpu_to_le32(temp);
+	}
+
 	if (flags & ENETC_TXBD_FLAGS_EX) {
 		u8 e_flags =3D 0;
 		*txbd =3D temp_bd;
@@ -1505,6 +1515,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_s=
etup_type type,
 		return enetc_setup_tc_taprio(ndev, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return enetc_setup_tc_cbs(ndev, type_data);
+	case TC_SETUP_QDISC_ETF:
+		return enetc_setup_tc_txtime(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 7ee0da6d0015..dd4a227ffc7a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -72,6 +72,7 @@ struct enetc_bdr {
 	struct enetc_ring_stats stats;
=20
 	dma_addr_t bd_dma_base;
+	u8 tsd_enable; /* Time specific departure */
 } ____cacheline_aligned_in_smp;
=20
 static inline void enetc_bdr_idx_inc(struct enetc_bdr *bdr, int *i)
@@ -256,8 +257,10 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_c=
bd *cbd);
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
 int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
+int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data);
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
 #define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
+#define enetc_setup_tc_txtime(ndev, type_data) -EOPNOTSUPP
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index 51f543ef37a8..8375cd886dba 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -358,6 +358,7 @@ union enetc_tx_bd {
 				u8 l4_csoff;
 				u8 flags;
 			}; /* default layout */
+			__le32 txstart;
 			__le32 lstatus;
 		};
 	};
@@ -378,11 +379,14 @@ union enetc_tx_bd {
 };
=20
 #define ENETC_TXBD_FLAGS_L4CS	BIT(0)
+#define ENETC_TXBD_FLAGS_TSE	BIT(1)
 #define ENETC_TXBD_FLAGS_W	BIT(2)
 #define ENETC_TXBD_FLAGS_CSUM	BIT(3)
+#define ENETC_TXBD_FLAGS_TXSTART BIT(4)
 #define ENETC_TXBD_FLAGS_EX	BIT(6)
 #define ENETC_TXBD_FLAGS_F	BIT(7)
-
+#define ENETC_TXBD_TXSTART_MASK GENMASK(24, 0)
+#define ENETC_TXBD_FLAGS_OFFSET 24
 static inline void enetc_clear_tx_bd(union enetc_tx_bd *txbd)
 {
 	memset(txbd, 0, sizeof(*txbd));
@@ -615,3 +619,7 @@ struct enetc_cbd {
 /* Port time gating capability register */
 #define ENETC_QBV_PTGCAPR_OFFSET	0x11a08
 #define ENETC_QBV_MAX_GCL_LEN_MASK	GENMASK(15, 0)
+
+/* Port time specific departure */
+#define ENETC_PTCTSDR(n)	(0x1210 + 4 * (n))
+#define ENETC_TSDE		BIT(31)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
index 9190ffc9f6b2..049f0fb40ac7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -156,6 +156,11 @@ int enetc_setup_tc_taprio(struct net_device *ndev, voi=
d *type_data)
 	int err;
 	int i;
=20
+	/* TSD and Qbv are mutually exclusive in hardware */
+	for (i =3D 0; i < priv->num_tx_rings; i++)
+		if (priv->tx_ring[i]->tsd_enable)
+			return -EBUSY;
+
 	for (i =3D 0; i < priv->num_tx_rings; i++)
 		enetc_set_bdr_prio(&priv->si->hw,
 				   priv->tx_ring[i]->index,
@@ -297,3 +302,29 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *=
type_data)
=20
 	return 0;
 }
+
+int enetc_setup_tc_txtime(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	struct tc_etf_qopt_offload *qopt =3D type_data;
+	u8 tc_nums =3D netdev_get_num_tc(ndev);
+	int tc;
+
+	if (!tc_nums)
+		return -EOPNOTSUPP;
+
+	tc =3D qopt->queue;
+
+	if (tc < 0 || tc > priv->num_tx_rings)
+		return -EINVAL;
+
+	/* TSD and Qbv are mutually exclusive in hardware */
+	if (enetc_rd(&priv->si->hw, ENETC_QBV_PTGCR_OFFSET) & ENETC_QBV_TGE)
+		return -EBUSY;
+
+	priv->tx_ring[tc]->tsd_enable =3D qopt->enable;
+	enetc_port_wr(&priv->si->hw, ENETC_PTCTSDR(tc),
+		      qopt->enable ? ENETC_TSDE : 0);
+
+	return 0;
+}
--=20
2.17.1

