Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB9A1066E8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKVHRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:17:24 -0500
Received: from mail-eopbgr30088.outbound.protection.outlook.com ([40.107.3.88]:25696
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbfKVHRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 02:17:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfo/JohrIQtpV09qEbwl0eKQWbGJQLDnawrAmBqW8yQWrQTVcxQDdrUsw2yA8rUYFHQqbKGICyx1IvvxibUu5QkM2NtUAAic5CRJt8TEHPXoQfkAKlj28lBOHY14Ba3e1wvNkO8zzoH0FpgJDiZryJUd2jL/Li7iKTAJ5E+jeN4kji0Cjm0aT0TEl5zKP4qrHw9raHNe0NPRVMAjs5+M7BLTdmqhGJ07mq+TVC32Rkdne7OrZsVwxbcOu9IgN9cUqezMWZUB+7nwNngFO46Ifqy6kDbrRv3wPDk32spk5dhhdHLLr/FpPZVDgq5hsCrs6sqMI8UCRhWNlVFgKf6ELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHmLNyu4H8FDF5caBEYhlpjZoY+e+3TMkpagGaoBrC0=;
 b=ZSvV3aBRz1H5B60CI6z0KmeiPQd3U7OkW57/TjpqVbDYOxYyufGVGkK5yQfvPr/f7enFygf60cLXwv/IQmCEj2jdivlLB5QVqX/0mFDVnGHjQ+4EWOvZt9D2azFZWEJMlDQO1oBwl9Wqi1dtMCgoWMFDMC15zjrjK86j5uHnYWxdqw/zsYxJ79P/D0U1+gMy8yqR6cKG/FPRnGm8F8CR3yo8HaVrRk9D7OV9kVYs5Mv1F+fCgspYeWw/Xj+n7tGD2tYwi02jCG2Dh6H/bs3fBF/6nwV4v7DjmezL37nBPotmOORhstIAUx2YC46jubsJmsBzYEhOzet+uEPvNICKnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHmLNyu4H8FDF5caBEYhlpjZoY+e+3TMkpagGaoBrC0=;
 b=b9vgSpzbSrLI0g8Kq6NoAiz/RDZtQ9Xi9sVOJnF1zqiLFE5hd3VkLp5j2SXEiA+T4NJNISXIb9vKRsDbS7/o6Tee8U4tkEeOBV67C5S/XZw/Jk3iH8zWgBX97JrIKqrvGu0WmXjOH30ASIC0+tFB1v2RtP4t7LSW7MIsooln1ic=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6655.eurprd04.prod.outlook.com (20.179.232.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 07:17:19 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7c6e:3d38:6630:5515%4]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 07:17:18 +0000
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
        Po Liu <po.liu@nxp.com>
Subject: [net-next] enetc: add support Credit Based Shaper(CBS) for hardware
 offload
Thread-Topic: [net-next] enetc: add support Credit Based Shaper(CBS) for
 hardware offload
Thread-Index: AQHVoQTfZRfPw7RK9Uq/YjFUdit1ag==
Date:   Fri, 22 Nov 2019 07:17:18 +0000
Message-ID: <20191122070321.20915-1-Po.Liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SN4PR0701CA0010.namprd07.prod.outlook.com
 (2603:10b6:803:28::20) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c4352544-cdb6-42b4-6a80-08d76f1c023b
x-ms-traffictypediagnostic: VE1PR04MB6655:|VE1PR04MB6655:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6655D7E9EF61C379719BF2D892490@VE1PR04MB6655.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(199004)(189003)(25786009)(2201001)(7736002)(305945005)(8936002)(50226002)(2616005)(5660300002)(1076003)(186003)(6506007)(386003)(102836004)(26005)(14454004)(478600001)(86362001)(36756003)(99286004)(54906003)(110136005)(66446008)(66946007)(64756008)(66556008)(52116002)(66476007)(3846002)(66066001)(6116002)(2906002)(6486002)(6436002)(6512007)(14444005)(256004)(81156014)(81166006)(8676002)(316002)(71200400001)(4326008)(71190400001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6655;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/zsWrTEf2xoDUeKcHxs9Ot/ZMbElMppTlSQ4CIgABd/f26O/QSdzueCAZd8YLRRn3ECp1XJZ5SNCVoZHqGkNY72qAQ58KsguV3TtvqfpHfE4cHv9RA4IleTNgZaMBwU6g0VunupoozlPQdo4auLKrjLf6gpDZ6YaZ+u6EK369tK402Tfk0z+XTK6JWaxKP7OkWIORx3MiaWcw2PoIwbTGclctrXhtMVQ+f0cFh1DCCxTO71d8GoknRc/G6L6dex+MixqU9HWgTrnR0ChFB20R2+9qlsIcMAFTAwf7zPC8CEmD5YPdChjslOyapt+bYPEGec3EdDhQp3h9BfQ4bgLmG8Dv2S3vc+5ma1nLIg2TefzV4Gar8tAlyCw+JsEdNS+LHWMhLqk9KfTTfzAb1PcdBPAyIiUzgJgkSgfogUGwuoqLIwvasw38QeOKxHFjzq
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4352544-cdb6-42b4-6a80-08d76f1c023b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 07:17:18.7817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FLgpYwEaugWghEII5/M9EKdeS/q8O74nfPto2v2Dv7xv01L3tHeeTCmhlMp/ojnd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENETC hardware support the Credit Based Shaper(CBS) which part
of the IEEE-802.1Qav. The CBS driver was loaded by the sch_cbs
interface when set in the QOS in the kernel.

Here is an example command to set 20Mbits bandwidth in 1Gbits port
for taffic class 7:

tc qdisc add dev eth0 root handle 1: mqprio \
	   num_tc 8 map 0 1 2 3 4 5 6 7 hw 1

tc qdisc replace dev eth0 parent 1:8 cbs \
	   locredit -1470 hicredit 30 \
	   sendslope -980000 idleslope 20000 offload 1

Signed-off-by: Po Liu <Po.Liu@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.h  |   2 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 126 ++++++++++++++++++
 5 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/eth=
ernet/freescale/enetc/Kconfig
index 491659fe3e35..edad4ca46327 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -53,10 +53,10 @@ config FSL_ENETC_HW_TIMESTAMPING
=20
 config FSL_ENETC_QOS
 	bool "ENETC hardware Time-sensitive Network support"
-	depends on (FSL_ENETC || FSL_ENETC_VF) && NET_SCH_TAPRIO
+	depends on (FSL_ENETC || FSL_ENETC_VF) && (NET_SCH_TAPRIO || NET_SCH_CBS)
 	help
 	  There are Time-Sensitive Network(TSN) capabilities(802.1Qbv/802.1Qci
 	  /802.1Qbu etc.) supported by ENETC. These TSN capabilities can be set
 	  enable/disable from user space via Qos commands(tc). In the kernel
 	  side, it can be loaded by Qos driver. Currently, it is only support
-	  taprio(802.1Qbv).
+	  taprio(802.1Qbv) and Credit Based Shaper(802.1Qbu).
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index 27f6fd1708f0..9db1b96ed9b9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1496,6 +1496,8 @@ int enetc_setup_tc(struct net_device *ndev, enum tc_s=
etup_type type,
 		return enetc_setup_tc_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return enetc_setup_tc_taprio(ndev, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return enetc_setup_tc_cbs(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/eth=
ernet/freescale/enetc/enetc.h
index 89f23156f330..7ee0da6d0015 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -255,7 +255,9 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cb=
d *cbd);
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data);
 void enetc_sched_speed_set(struct net_device *ndev);
+int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data);
 #else
 #define enetc_setup_tc_taprio(ndev, type_data) -EOPNOTSUPP
 #define enetc_sched_speed_set(ndev) (void)0
+#define enetc_setup_tc_cbs(ndev, type_data) -EOPNOTSUPP
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/=
ethernet/freescale/enetc/enetc_hw.h
index 924ddb6d358a..51f543ef37a8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -185,6 +185,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSICFGR0_SIVC(bmp)	(((bmp) & 0xff) << 24) /* VLAN_TYPE */
=20
 #define ENETC_PTCCBSR0(n)	(0x1110 + (n) * 8) /* n =3D 0 to 7*/
+#define ENETC_CBSE		BIT(31)
+#define ENETC_CBS_BW_MASK	GENMASK(6, 0)
 #define ENETC_PTCCBSR1(n)	(0x1114 + (n) * 8) /* n =3D 0 to 7*/
 #define ENETC_RSSHASH_KEY_SIZE	40
 #define ENETC_PRSSK(n)		(0x1410 + (n) * 4) /* n =3D [0..9] */
@@ -603,6 +605,8 @@ struct enetc_cbd {
 	u8 status_flags;
 };
=20
+#define ENETC_CLK  400000000ULL
+
 /* port time gating control register */
 #define ENETC_QBV_PTGCR_OFFSET		0x11a00
 #define ENETC_QBV_TGE			BIT(31)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net=
/ethernet/freescale/enetc/enetc_qos.c
index 66a3da61ca16..98c3d062459a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -170,3 +170,129 @@ int enetc_setup_tc_taprio(struct net_device *ndev, vo=
id *type_data)
=20
 	return err;
 }
+
+static u32 enetc_get_cbs_enable(struct enetc_hw *hw, u8 tc)
+{
+	return enetc_port_rd(hw, ENETC_PTCCBSR0(tc)) & ENETC_CBSE;
+}
+
+static u8 enetc_get_cbs_bw(struct enetc_hw *hw, u8 tc)
+{
+	return enetc_port_rd(hw, ENETC_PTCCBSR0(tc)) & ENETC_CBS_BW_MASK;
+}
+
+int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
+{
+	struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
+	struct tc_cbs_qopt_offload *cbs =3D type_data;
+	u32 port_transmit_rate =3D priv->speed;
+	u8 tc_nums =3D netdev_get_num_tc(ndev);
+	struct enetc_si *si =3D priv->si;
+	u32 hi_credit_bit, hi_credit_reg;
+	u32 max_interference_size;
+	u32 port_frame_max_size;
+	u32 tc_max_sized_frame;
+	u8 tc =3D cbs->queue;
+	u8 prio_top, prio_next;
+	int bw_sum =3D 0;
+	u8 bw;
+
+	prio_top =3D netdev_get_prio_tc_map(ndev, tc_nums - 1);
+	prio_next =3D netdev_get_prio_tc_map(ndev, tc_nums - 2);
+
+	/* Support highest prio and second prio tc in cbs mode */
+	if (tc !=3D prio_top && tc !=3D prio_next)
+		return -EOPNOTSUPP;
+
+	if (!cbs->enable) {
+		/* Make sure the other TC that are numerically
+		 * lower than this TC have been disabled.
+		 */
+		if (tc =3D=3D prio_top &&
+		    enetc_get_cbs_enable(&si->hw, prio_next)) {
+			dev_err(&ndev->dev,
+				"Disable TC%d before disable TC%d\n",
+				prio_next, tc);
+			return -EINVAL;
+		}
+
+		enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), 0);
+		enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), 0);
+
+		return 0;
+	}
+
+	if (cbs->idleslope - cbs->sendslope !=3D port_transmit_rate * 1000L ||
+	    cbs->idleslope < 0 || cbs->sendslope > 0)
+		return -EOPNOTSUPP;
+
+	port_frame_max_size =3D ndev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	bw =3D cbs->idleslope / (port_transmit_rate * 10UL);
+
+	/* Make sure the other TC that are numerically
+	 * higher than this TC have been enabled.
+	 */
+	if (tc =3D=3D prio_next) {
+		if (!enetc_get_cbs_enable(&si->hw, prio_top)) {
+			dev_err(&ndev->dev,
+				"Enable TC%d first before enable TC%d\n",
+				prio_top, prio_next);
+			return -EINVAL;
+		}
+		bw_sum +=3D enetc_get_cbs_bw(&si->hw, prio_top);
+	}
+
+	if (bw_sum + bw >=3D 100) {
+		dev_err(&ndev->dev,
+			"The sum of all CBS Bandwidth can't exceed 100\n");
+		return -EINVAL;
+	}
+
+	tc_max_sized_frame =3D enetc_port_rd(&si->hw, ENETC_PTCMSDUR(tc));
+
+	/* For top prio TC, the max_interfrence_size is maxSizedFrame.
+	 *
+	 * For next prio TC, the max_interfrence_size is calculated as below:
+	 *
+	 *      max_interference_size =3D M0 + Ma + Ra * M0 / (R0 - Ra)
+	 *
+	 *	- RA: idleSlope for AVB Class A
+	 *	- R0: port transmit rate
+	 *	- M0: maximum sized frame for the port
+	 *	- MA: maximum sized frame for AVB Class A
+	 */
+
+	if (tc =3D=3D prio_top) {
+		max_interference_size =3D port_frame_max_size * 8;
+	} else {
+		u32 m0, ma, r0, ra;
+
+		m0 =3D port_frame_max_size * 8;
+		ma =3D enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
+		ra =3D enetc_get_cbs_bw(&si->hw, prio_top) *
+			port_transmit_rate * 10000ULL;
+		r0 =3D port_transmit_rate * 1000000ULL;
+		max_interference_size =3D m0 + ma + (u64)ra * m0 / (r0 - ra);
+	}
+
+	/* hiCredit bits calculate by:
+	 *
+	 * maxSizedFrame * (idleSlope/portTxRate)
+	 */
+	hi_credit_bit =3D max_interference_size * bw / 100;
+
+	/* hiCredit bits to hiCredit register need to calculated as:
+	 *
+	 * (enetClockFrequency / portTransmitRate) * 100
+	 */
+	hi_credit_reg =3D (ENETC_CLK * 100ULL) * hi_credit_bit
+			/ (port_transmit_rate * 1000000ULL);
+
+	enetc_port_wr(&si->hw, ENETC_PTCCBSR1(tc), hi_credit_reg);
+
+	/* Set bw register and enable this traffic class */
+	enetc_port_wr(&si->hw, ENETC_PTCCBSR0(tc), bw | ENETC_CBSE);
+
+	return 0;
+}
--=20
2.17.1

