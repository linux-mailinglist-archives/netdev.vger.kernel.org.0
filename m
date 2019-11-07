Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DB7F3B9F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfKGWmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49744 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727987AbfKGWmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:42:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MfADY003111;
        Thu, 7 Nov 2019 14:42:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=00v1Q9AEbuLcvbZbM7o3GiVhQNxGw4wzGOPG/UQIgK8=;
 b=j3zmQdXmn5zRFcI7/y5Gi3Oc3f7UWo7Tr/pc2/421C9QkX+aWfHVKHoswWOHUgpAgMja
 +8ffsHirGGv5+IdJWYZrXHVcpwPSFz9jR7gohv7Ya+AKj7icbtmApVLi68UwbU94KhZ5
 BfRyhdv+Se4YiR+vtHFaVMCGR/FsGPgjcbi2AsSpq6FQt6uo1o5jyD07w+ZDjZDB6Apq
 3IUfyauTT5ys3iQ/mk6yfmfjLNOyGyRIbwhmZX0KBkXb0caWIV3jl7emslR0Mav49aSx
 F+Mpd/6aVLS/5Zi/ZGIzssJqisXs7hDTAyrr1wKQQNmN+vUFEZhbPbASHF52QX6HCpxd dA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxrff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:42:06 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:42:05 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.55) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:42:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wirh+c1VffeOtkY0r0AsAinxlm9rsskX8VcCsVMUWkrPoT0DmJ8qzih55YjWeLZnJ2TXqOL7ZqQdjy3o1qIVDLGmXUmhVWTqwPebW5xOQW8nvzDeyWpgGUtTzbm5DpzJ4obwurJ9IWsf+7Kx1s6fCj7xS4FcuDrzIRv49+mPR8YL5eGrs8DZVLSkKgm2/QwgRo2DLl5w7FdtGB/LucvkvcF32yKKfFnM9csOhH042Vq9sNeJ53JnmcFXLAic1aCflHkix4S/KHwKz7UECEunt8ppCLZzt924yoO0S/Gw2cUZ4HC2/DTA8Anx7uM/ExadYePRvdxTp5wPVa5JnlUhlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00v1Q9AEbuLcvbZbM7o3GiVhQNxGw4wzGOPG/UQIgK8=;
 b=mUpdooVuWyiGF5/vqiUmW9g8LjSec6g8Ctzf890DLMESRXk9QkUXo6hDTkVKShundC3qv7ugmfcshcX96HBNKP7BFZTIBfqsPLhfQYclCb4hwi3+gx7tb1HL9zZWw/EYgz0CNZJUXDV5PvCQwg0l4pw7GIUmQQK0o7q723VY47dSVQIqdufPDt5xfE0SqwsNvCQNUz9o7zQznDdKLtvoQz28rmd9wyjNuS9Hf9SdsNhD3gUc/S/2CyO8lIP4ltMXbcaonP+NPHiYZmLcveYS3r9pBIxRr3Hzw/RoDq/y0YyWp3+WWJ8qW1LZESoWcqf9w7PLGln0RogAUsIgnzx+Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00v1Q9AEbuLcvbZbM7o3GiVhQNxGw4wzGOPG/UQIgK8=;
 b=OicmRtoqOFpnsLsueBh/ArPFuCBj0fb5it5oTbcmMl2PEbPpvO36pGTm+8F6ob+01yzHYf2jmLbptAP3ZqndZVEhCRQ63nPMYBEkRkPfehlEHnGlZAeDr8K1ao0HQkjcSRh7h7UdsbKz+hot+6jEDQEg6R2iWNlWcKK7C6QDm4g=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:42:04 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:42:04 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 10/12] net: atlantic: update flow control logic
Thread-Topic: [PATCH v2 net-next 10/12] net: atlantic: update flow control
 logic
Thread-Index: AQHVlbyTZMBUUn05o0CLlldpw/6tVA==
Date:   Thu, 7 Nov 2019 22:42:04 +0000
Message-ID: <f58e50a30c6d125f51d1d432a0274227ce23299b.1573158382.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
In-Reply-To: <cover.1573158381.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:101:16::23) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17e89702-1fe3-4807-206b-08d763d3b5ec
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB229552A989BF068E2043752FB7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:22;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LoA/hr5DKNUrtE1qoG7QudTu+iEy+uL2MvoN20QiTzSF1WbRAulMu6MU0LPGDBmd/HRLm6EpHyrTZr++yK1n4p9eTAD71BW5Gx2+D/hlCIeLMZDEUHFXB0Txq0iKIDONEt+15Um1UtWJ1LWsQ4bFX863pMQkPQbp11/EOpcPLv0axx+scZBbanteRbBI/p1iWo5RLdyzxSl27BRrcntXtxg9eOQ+2A+QkI3mXDCVGvJ+XOADZ3cm7YmVEa/VhMdJMaKviuITeWZOOO/Unt/r+E7LuTgxZSulhTgbCBq4wCBEM8UtWzS6C9PnmI4b+thnUqkxDGByuGTQk90e3ztgCuefWMEJtJVbVfk5gShZvZuSU4Mx6wH8VSQmNwUufCkzJsjrGgbthK2EELlSsZhZdgIN37nmzke2DsSQNgZ0kIwHuzdP4TRQhNHZ8kSvIJe8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e89702-1fe3-4807-206b-08d763d3b5ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:42:04.0523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IjLeuUDjC85IfyiiqikL7meyhtK26GYiOO/u5DonmP7eCm84Ujm77G2XHdXokXJD/2QaDFHT8Th3pEJlUmYGlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

We now differentiate requested and negotiated flow control
modes. Therefore `ethtool -A` now operates on local requested
FC values, and regular link settings shows the negotiated FC
settings.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |  6 ---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 10 ++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 19 +++++---
 .../net/ethernet/aquantia/atlantic/aq_nic.h   | 14 +++++-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  2 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 47 +++++++++++--------
 7 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_cfg.h
index d02b0d79f68a..f0c41f7408e5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -70,12 +70,6 @@
=20
 /*#define AQ_CFG_MAC_ADDR_PERMANENT {0x30, 0x0E, 0xE3, 0x12, 0x34, 0x56}*/
=20
-#define AQ_NIC_FC_OFF    0U
-#define AQ_NIC_FC_TX     1U
-#define AQ_NIC_FC_RX     2U
-#define AQ_NIC_FC_FULL   3U
-#define AQ_NIC_FC_AUTO   4U
-
 #define AQ_CFG_FC_MODE AQ_NIC_FC_FULL
=20
 /* Default WOL modes used on initialization */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 8286c77d43a5..6353a5c5ed27 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -588,7 +588,7 @@ static void aq_ethtool_get_pauseparam(struct net_device=
 *ndev,
 				      struct ethtool_pauseparam *pause)
 {
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
-	u32 fc =3D aq_nic->aq_nic_cfg.flow_control;
+	u32 fc =3D aq_nic->aq_nic_cfg.fc.req;
=20
 	pause->autoneg =3D 0;
=20
@@ -610,14 +610,14 @@ static int aq_ethtool_set_pauseparam(struct net_devic=
e *ndev,
 		return -EOPNOTSUPP;
=20
 	if (pause->rx_pause)
-		aq_nic->aq_hw->aq_nic_cfg->flow_control |=3D AQ_NIC_FC_RX;
+		aq_nic->aq_hw->aq_nic_cfg->fc.req |=3D AQ_NIC_FC_RX;
 	else
-		aq_nic->aq_hw->aq_nic_cfg->flow_control &=3D ~AQ_NIC_FC_RX;
+		aq_nic->aq_hw->aq_nic_cfg->fc.req &=3D ~AQ_NIC_FC_RX;
=20
 	if (pause->tx_pause)
-		aq_nic->aq_hw->aq_nic_cfg->flow_control |=3D AQ_NIC_FC_TX;
+		aq_nic->aq_hw->aq_nic_cfg->fc.req |=3D AQ_NIC_FC_TX;
 	else
-		aq_nic->aq_hw->aq_nic_cfg->flow_control &=3D ~AQ_NIC_FC_TX;
+		aq_nic->aq_hw->aq_nic_cfg->fc.req &=3D ~AQ_NIC_FC_TX;
=20
 	mutex_lock(&aq_nic->fwreq_mutex);
 	err =3D aq_nic->aq_fw_ops->set_flow_control(aq_nic->aq_hw);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index d3739f21b18e..7ad8eb535d28 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -79,7 +79,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 	cfg->is_rss =3D AQ_CFG_IS_RSS_DEF;
 	cfg->num_rss_queues =3D AQ_CFG_NUM_RSS_QUEUES_DEF;
 	cfg->aq_rss.base_cpu_number =3D AQ_CFG_RSS_BASE_CPU_NUM_DEF;
-	cfg->flow_control =3D AQ_CFG_FC_MODE;
+	cfg->fc.req =3D AQ_CFG_FC_MODE;
 	cfg->wol =3D AQ_CFG_WOL_MODES;
=20
 	cfg->mtu =3D AQ_CFG_MTU_DEF;
@@ -144,6 +144,10 @@ static int aq_nic_update_link_status(struct aq_nic_s *=
self)
 	if (err)
 		return err;
=20
+	if (self->aq_fw_ops->get_flow_control)
+		self->aq_fw_ops->get_flow_control(self->aq_hw, &fc);
+	self->aq_nic_cfg.fc.cur =3D fc;
+
 	if (self->link_status.mbps !=3D self->aq_hw->aq_link_status.mbps) {
 		netdev_info(self->ndev, "%s: link change old %d new %d\n",
 			    AQ_CFG_DRV_NAME, self->link_status.mbps,
@@ -161,8 +165,6 @@ static int aq_nic_update_link_status(struct aq_nic_s *s=
elf)
 		 * on any link event.
 		 * We should query FW whether it negotiated FC.
 		 */
-		if (self->aq_fw_ops->get_flow_control)
-			self->aq_fw_ops->get_flow_control(self->aq_hw, &fc);
 		if (self->aq_hw_ops->hw_set_fc)
 			self->aq_hw_ops->hw_set_fc(self->aq_hw, fc, 0);
 	}
@@ -862,9 +864,12 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     100baseT_Full);
=20
-	if (self->aq_nic_cfg.aq_hw_caps->flow_control)
+	if (self->aq_nic_cfg.aq_hw_caps->flow_control) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported,
 						     Pause);
+		ethtool_link_ksettings_add_link_mode(cmd, supported,
+						     Asym_Pause);
+	}
=20
 	ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
=20
@@ -898,13 +903,13 @@ void aq_nic_get_link_ksettings(struct aq_nic_s *self,
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     100baseT_Full);
=20
-	if (self->aq_nic_cfg.flow_control & AQ_NIC_FC_RX)
+	if (self->aq_nic_cfg.fc.cur & AQ_NIC_FC_RX)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     Pause);
=20
 	/* Asym is when either RX or TX, but not both */
-	if (!!(self->aq_nic_cfg.flow_control & AQ_NIC_FC_TX) ^
-	    !!(self->aq_nic_cfg.flow_control & AQ_NIC_FC_RX))
+	if (!!(self->aq_nic_cfg.fc.cur & AQ_NIC_FC_TX) ^
+	    !!(self->aq_nic_cfg.fc.cur & AQ_NIC_FC_RX))
 		ethtool_link_ksettings_add_link_mode(cmd, advertising,
 						     Asym_Pause);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index 98c3182bf1d0..a752f8bb4b08 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -20,6 +20,18 @@ struct aq_vec_s;
 struct aq_ptp_s;
 enum aq_rx_filter_type;
=20
+enum aq_fc_mode {
+	AQ_NIC_FC_OFF =3D 0,
+	AQ_NIC_FC_TX,
+	AQ_NIC_FC_RX,
+	AQ_NIC_FC_FULL,
+};
+
+struct aq_fc_info {
+	enum aq_fc_mode req;
+	enum aq_fc_mode cur;
+};
+
 struct aq_nic_cfg_s {
 	const struct aq_hw_caps_s *aq_hw_caps;
 	u64 features;
@@ -34,7 +46,7 @@ struct aq_nic_cfg_s {
 	u32 rxpageorder;
 	u32 num_rss_queues;
 	u32 mtu;
-	u32 flow_control;
+	struct aq_fc_info fc;
 	u32 link_speed_msk;
 	u32 wol;
 	u8 is_vlan_rx_strip;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index d2fb399f179f..03b62d7d9f1a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -155,7 +155,7 @@ static int hw_atl_a0_hw_qos_set(struct aq_hw_s *self)
=20
 	/* QoS Rx buf size per TC */
 	tc =3D 0;
-	is_rx_flow_control =3D (AQ_NIC_FC_RX & self->aq_nic_cfg->flow_control);
+	is_rx_flow_control =3D (AQ_NIC_FC_RX & self->aq_nic_cfg->fc.req);
 	buff_size =3D HW_ATL_A0_RXBUF_MAX;
=20
 	hw_atl_rpb_rx_pkt_buff_size_per_tc_set(self, buff_size, tc);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index a51826907467..57b357eadd51 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -168,7 +168,7 @@ static int hw_atl_b0_hw_qos_set(struct aq_hw_s *self)
 						   (1024U / 32U) * 50U) /
 						   100U, tc);
=20
-	hw_atl_b0_set_fc(self, self->aq_nic_cfg->flow_control, tc);
+	hw_atl_b0_set_fc(self, self->aq_nic_cfg->fc.req, tc);
=20
 	/* Init TC2 for PTP_RX */
 	tc =3D 2;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index ce3ed86d8c0e..97ebf849695f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -181,17 +181,26 @@ static int aq_fw2x_set_link_speed(struct aq_hw_s *sel=
f, u32 speed)
 	return 0;
 }
=20
-static void aq_fw2x_set_mpi_flow_control(struct aq_hw_s *self, u32 *mpi_st=
ate)
+static void aq_fw2x_upd_flow_control_bits(struct aq_hw_s *self,
+					  u32 *mpi_state, u32 fc)
 {
-	if (self->aq_nic_cfg->flow_control & AQ_NIC_FC_RX)
-		*mpi_state |=3D BIT(CAPS_HI_PAUSE);
-	else
-		*mpi_state &=3D ~BIT(CAPS_HI_PAUSE);
+	*mpi_state &=3D ~(HW_ATL_FW2X_CTRL_PAUSE |
+			HW_ATL_FW2X_CTRL_ASYMMETRIC_PAUSE);
=20
-	if (self->aq_nic_cfg->flow_control & AQ_NIC_FC_TX)
-		*mpi_state |=3D BIT(CAPS_HI_ASYMMETRIC_PAUSE);
-	else
-		*mpi_state &=3D ~BIT(CAPS_HI_ASYMMETRIC_PAUSE);
+	switch (fc) {
+	/* There is not explicit mode of RX only pause frames,
+	 * thus, we join this mode with FC full.
+	 * FC full is either Rx, either Tx, or both.
+	 */
+	case AQ_NIC_FC_FULL:
+	case AQ_NIC_FC_RX:
+		*mpi_state |=3D HW_ATL_FW2X_CTRL_PAUSE |
+			      HW_ATL_FW2X_CTRL_ASYMMETRIC_PAUSE;
+		break;
+	case AQ_NIC_FC_TX:
+		*mpi_state |=3D HW_ATL_FW2X_CTRL_ASYMMETRIC_PAUSE;
+		break;
+	}
 }
=20
 static void aq_fw2x_upd_eee_rate_bits(struct aq_hw_s *self, u32 *mpi_opts,
@@ -215,7 +224,8 @@ static int aq_fw2x_set_state(struct aq_hw_s *self,
 	case MPI_INIT:
 		mpi_state &=3D ~BIT(CAPS_HI_LINK_DROP);
 		aq_fw2x_upd_eee_rate_bits(self, &mpi_state, cfg->eee_speeds);
-		aq_fw2x_set_mpi_flow_control(self, &mpi_state);
+		aq_fw2x_upd_flow_control_bits(self, &mpi_state,
+					      self->aq_nic_cfg->fc.req);
 		break;
 	case MPI_DEINIT:
 		mpi_state |=3D BIT(CAPS_HI_LINK_DROP);
@@ -525,7 +535,8 @@ static int aq_fw2x_set_flow_control(struct aq_hw_s *sel=
f)
 {
 	u32 mpi_state =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
=20
-	aq_fw2x_set_mpi_flow_control(self, &mpi_state);
+	aq_fw2x_upd_flow_control_bits(self, &mpi_state,
+				      self->aq_nic_cfg->fc.req);
=20
 	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_state);
=20
@@ -535,17 +546,13 @@ static int aq_fw2x_set_flow_control(struct aq_hw_s *s=
elf)
 static u32 aq_fw2x_get_flow_control(struct aq_hw_s *self, u32 *fcmode)
 {
 	u32 mpi_state =3D aq_fw2x_state2_get(self);
+	*fcmode =3D 0;
=20
 	if (mpi_state & HW_ATL_FW2X_CAP_PAUSE)
-		if (mpi_state & HW_ATL_FW2X_CAP_ASYM_PAUSE)
-			*fcmode =3D AQ_NIC_FC_RX;
-		else
-			*fcmode =3D AQ_NIC_FC_RX | AQ_NIC_FC_TX;
-	else
-		if (mpi_state & HW_ATL_FW2X_CAP_ASYM_PAUSE)
-			*fcmode =3D AQ_NIC_FC_TX;
-		else
-			*fcmode =3D 0;
+		*fcmode |=3D AQ_NIC_FC_RX;
+
+	if (mpi_state & HW_ATL_FW2X_CAP_ASYM_PAUSE)
+		*fcmode |=3D AQ_NIC_FC_TX;
=20
 	return 0;
 }
--=20
2.17.1

