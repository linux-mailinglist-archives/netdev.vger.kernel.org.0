Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B3D12B0CC
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfL0DMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 22:12:24 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:43559
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbfL0DMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 22:12:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxVzvj22tOi2AAaLJO1LFP+wp+cuAaXTQ3hB3Qqz9GRQ0uekgIsxEVSTLaFoYgUVZBGD5+K5Ge6bcMB03Vf5DvcayCHf+jAqxvPw5ZMJ53oXQEHvbhsmVaI5uP8XhbBjUSDVH9OXpwlXutX2Cet9iB46AXLrucfsidI6uycrFrgEBIFGKStj8BYRTUHMV71bgKID4GE7YCX9c/6J+EFtrPqdEMup2cidltFd5bpN2vCMyBpB7w/XabvMMDsZRyc+j3BNEi9Fp+gqM+x8/dTpPg7ZfTaCXLqQWVV0UztGCNdFD7+9QqijkNsJwrs+AJNO1BEaa5s651APP/5y0uc6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5BRF1UFIXZEgIn00KW+QCNtinnDQrWz6s1HoqFyKyw=;
 b=cv+Ur3njRM8dN+u0r9RkgP3sbZHnExd5l9WzPxzZCQq3EIIC1323Nbm01ZwU8kyQYdJd2VeANz7bX7RcljLKUuMRlDTmL9qJchGtLOJTLluaMqt7aYRvJM3aW6VMHBTc97KhI1ntkuKKazcgEPB/UK1KA7qAMIE/iG9bu2iZl7vLByQq7TPCz5n81FeSUodw0QqAP8hhPtskKXCJj0DNnDr5n+X9VoKR22aIneZIsHAeKSioYRWTwufkTD1lPczYLWw75Au4nCx5sw6Fvu9IOqjV/ArWCJv1oZQMOouAyCibAfQ7sLwNA9HX4m8N9nUJTSBuOf/37LSLxrhxS5ltww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5BRF1UFIXZEgIn00KW+QCNtinnDQrWz6s1HoqFyKyw=;
 b=O/JO30STRx/MY7I5QVOTWo1xuZ7Hid/BAn9PZFloXN4K0SDgDz7NQzoERGnZiOOykH8cVmYzhddYlwYId9E0I8qtPLKhtzp84gaUDRnxODt69lNGRvS6nvIiSS90I+ygPFDnmunECi5qM9MhiPM4iEHdpsCzFWtyormLgfJ8ECc=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6685.eurprd04.prod.outlook.com (20.179.233.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Fri, 27 Dec 2019 03:12:19 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::b870:829f:748a:4bc%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 03:12:18 +0000
Received: from localhost.localdomain (119.31.174.73) by SN4PR0601CA0016.namprd06.prod.outlook.com (2603:10b6:803:2f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 03:12:12 +0000
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
Subject: [v2,net-next] enetc: add support time specific departure base on the
 qos etf
Thread-Topic: [v2,net-next] enetc: add support time specific departure base on
 the qos etf
Thread-Index: AQHVvGNyrgSmwD+0RU+o/s0aZaT5Dg==
Date:   Fri, 27 Dec 2019 03:12:18 +0000
Message-ID: <20191227025547.4452-1-Po.Liu@nxp.com>
References: <20191223032618.18205-1-Po.Liu@nxp.com>
In-Reply-To: <20191223032618.18205-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN4PR0601CA0016.namprd06.prod.outlook.com
 (2603:10b6:803:2f::26) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6defe49c-c126-419d-a1f9-08d78a7a94ab
x-ms-traffictypediagnostic: VE1PR04MB6685:|VE1PR04MB6685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66858135AFEC37578156AEA8922A0@VE1PR04MB6685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(189003)(199004)(66946007)(186003)(16526019)(26005)(66446008)(64756008)(478600001)(66476007)(52116002)(8936002)(4326008)(66556008)(1076003)(2616005)(86362001)(956004)(316002)(2906002)(5660300002)(6506007)(110136005)(54906003)(71200400001)(81166006)(6486002)(69590400006)(8676002)(36756003)(6512007)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6685;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N3ojwmVxX+xudoeKLAiFpO69wrntzKXkNljpCD492zkrq7nvBHlCCzsOU2n/q1v6wZegpvNBk2jlejZ0tFnekUeeCZeVVAp6mRy9kkutrmllkD7VZQKg6ZzMNuJrDSmA11rtYJdKGkiY/BYQphzua1nMkTPREdW60yA9VNatUGdpkIls1it2EAIdWUIDYGuhiyRBifyE9IqBVrWa0zia5ST68GlenWnm9jO6RN+EhAnH8YFT59HKS8treJFLh+nGS6PWI+JrIrPbP0bMpRPpspuNzA4w0y1GwaofFEmCNm99iIWnPcyFYGCOmtF9kxZAmdAPNeE1XnpWf9hkaofoJvkV2r00UV2AOvlWomchlvMwHHlo3NGLcse5iT/z8f98V+GvcFFz+nO/aS4EFK3ua7DWiiCyLW5kKWnVn5KhDMtxeXKBJXaBBEmXEjbAP314qAkiXb61d3cThfkSs/KY5Y2X15NM56pHk6JNfypciXrcJ16S+EZ/RGFBwz19MqTj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6defe49c-c126-419d-a1f9-08d78a7a94ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 03:12:18.6740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 23kDafI1/ZUPSlkhGEa7Qtrk89FKzG2TfqSCmYUA464f5ilrhY/N4KTKcqFacCL+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6685
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
changes log:
v2:
- fix the csum and time specific deaprture return directly if both
offloading enabled

 drivers/net/ethernet/freescale/enetc/enetc.c  | 18 +++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 ++
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 10 +++++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 +++++++++++++++++++
 4 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 2ee4a2cd4780..8e4dfaf07f0e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -149,11 +149,27 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ri=
ng, struct sk_buff *skb,
=20
 	if (enetc_tx_csum(skb, &temp_bd))
 		flags |=3D ENETC_TXBD_FLAGS_CSUM | ENETC_TXBD_FLAGS_L4CS;
+	if (tx_ring->tsd_enable)
+		flags |=3D ENETC_TXBD_FLAGS_TSE | ENETC_TXBD_FLAGS_TXSTART;
+
+	if (flags & ENETC_TXBD_FLAGS_TSE && flags & ENETC_TXBD_FLAGS_CSUM) {
+		dev_err(tx_ring->dev,
+			"Both TXSTART and CSUM enabled not support!");
+		return 0;
+	}
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
@@ -1505,6 +1521,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_s=
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

