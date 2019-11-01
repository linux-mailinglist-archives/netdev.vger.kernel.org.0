Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22E9EC29C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfKAMRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49322 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730583AbfKAMRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CBNsN001722;
        Fri, 1 Nov 2019 05:17:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=64XMu97/MxX6tUTFO1bwMvowU13EexdmPfbdGXv7L4A=;
 b=pDlL1rtUxmT0cqe90lronK5W+AfGT0g5Dk4RI7aW5ZB+S1KzP04OP6iemSYcFFwXJA0k
 GZYMMxA3IsCrjx10x3gJQEZNDdDp6Ua44rVhbNME/V5qkklPXiCB/XNDs0WQKvA1refd
 8NW341BJJB333ow8Cpfg4Hoz/0Oc3PCRIVfku9KyJKemFf4za4J9gNR5BMQPcb9hfpJQ
 6Nv1KNWlThblwjI3rw9lQoyH2U0nsOIlMxn4v+RGShRP0W0EPAcLI6vD+Aze0SoJyy4/
 wfl6TNG7jMawDMotoblDZbEzVo4X1mPqeNfCwvxZerMx/3LLOo+JR/EmfQ0ttr4+iTtW 8w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjmbtm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:33 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:32 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWj8ZEIyRatz8biXspBp7Oiw+ntMQXlwPRXjxbuRZbzrkPWxyRW0OAzzdFrGuCvrOpJ1lmkgCiAbcODvCavKGR8sSCwTwXHz7p0Xcw2icLr253xAooegRI1CayhCkuqVKGEKliSRcJeUpACuMOTG+X6y9a0hab1FqQub1w+vFSLDKnugIvg2HLDMtBysBQUyAr4JhAjv068Dv9vMaqpF8xbrvVLIhPUcLgi5G8BYiMvxN/mFzjdgUly36QEJStaGtxeOYXGhfRcYWx+lni7BQ7anKmUGG68PSOHZtvs7QdgoMDhKzC47Jo385kL75/IRYpyDEgN8Hkp7FbAXMPsHHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64XMu97/MxX6tUTFO1bwMvowU13EexdmPfbdGXv7L4A=;
 b=cwyddtUxX4E6eDnYjs5A8+DqT46qeycTA6iawHBMDFm5xYbti/0TC8hH4sNIz22cK960JXFfOY52sTeQXmdbpvCgNMxTH2aeAI7KBO43k0PMNESPoVAb4TljtfQjGNXyw6nmIKEDmoL91O/Abnpg5EOZQM6/YQ1g1OGmvK4CKBvkNd0PM9vZGHIZWIV7SCdTSeROrqSsESThZX6mmAKeSGIknykrutv22oqzebKm5S/nxlM49xzuoRxj0Bzz8cS+MZ78KNx3fzgWjxAAqUB/Qg/AP9pBGPdjQYB2di/pcKMfOBVSWEgCK6jeAZZ+3+V/dQzHzbIMa4qodyRJi/8vSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64XMu97/MxX6tUTFO1bwMvowU13EexdmPfbdGXv7L4A=;
 b=EMbVbwaEYcYzQxvKDDZif/B+Ryv5Gux396Jq3TKqTDNa7mMZXZtAYAmOZYLBsbnP5ag9GVjRtpNpHzioTBa8gqeeTvrJI+38cLXUKJcRwwZWJTEzBITnyDoD8tuRJtY8H7xVCyRipzwt+w21r8gLBst9g/2eMoUu+a0eAXcUOdM=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:26 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:26 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 10/12] net: atlantic: update flow control logic
Thread-Topic: [PATCH net-next 10/12] net: atlantic: update flow control logic
Thread-Index: AQHVkK5SiUcbJaRSGESrsQYilCMaug==
Date:   Fri, 1 Nov 2019 12:17:25 +0000
Message-ID: <9a3a9d8c38468a743269c659f5a27fa2de0c736e.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
In-Reply-To: <cover.1572610156.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::23) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6eb887cc-4d79-465e-0fcd-08d75ec574bf
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB230682371F6A87538E95DD2AB7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:22;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xr6Ix1BjoxcmnvUVRo7af9eqj/yZkErDNO73gRNuWw0UuaH4FAWWuQCUlYT6V8jIdoosaasYUBelgk10BmKD1LFcpozipv4plu7tXM+0RcPci778/pwDI6ZnECOB+Ux2RX+ZLx3YupaZSnf/nPiCJu5PnkiPlbUsSQ+Ay0rQ/tVDxhKOLgL18VS28Tkwpl+KnxVH1CbUR80Jqz3nWuwCL1vib4s3ocey0UNCKsJF4YlTDSjMm5IIQxmCzgxtVcxRSw2CXt3S34rdfSQjCU3gCW+iaeZiWMnzaHzDwapNRvjFd+Gxoy2WnFb9Adk1ui4V4A5iUZ864DdC0iI4BuvcaM3VjWnziODx7EsWPDTj3l4HTqXFM2Y9nnJHKT4stcowsiTx+MUP7Xn4xJjNzQVgLrDuPt1qNsaF8JW4o5nZbIZLHAAemIdaLjFOj6MKZaas
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb887cc-4d79-465e-0fcd-08d75ec574bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:25.8959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WdDBRQqMkna9yKx+t8NRosMMmyWJgVMkGbNZ6ydnD3eOY556P9IUk+WLzH37D8/kVfu7li/fHtVHauNWJcANyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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
index bb4957a31498..e5b6d72fd21d 100644
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
index 1950db2a6153..e4de258a5c19 100644
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

