Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB841F3B98
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfKGWmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:00 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727894AbfKGWl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:41:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MdlO4021310;
        Thu, 7 Nov 2019 14:41:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QeqrhPl2fZ1tXQaa530n27icFsqOEBltcMHJPiOb7oo=;
 b=m4RC4AOt3bC+yQGN1Sowd2X20hVnZ5OGQv5dNhezZbyMtKZnYPJyb/zMTzujF37zLotI
 jCKFE8JLJMZA1GTjF0z6rY/gco+g1jrxi8TSGuSHfYJ4avtwosGjgXFS1oEhfQ9SpDgt
 EcWuUj/C9tgX9be9TWQZulHiO/gmWf8hy8briJ1F/dAFhDkyXOghKFDp4hQhW1qwtTZm
 aY7zgv5/srlLWbvpXNN6IFrJ2Wnxzre1NQRhFgDC/L1oRseHzC0UIDnVFnAuLCz3QN5D
 Q2aJ0VJB9IdvOhuwITgyq6jF711KgE1WMZrzHBdq9BWQ2a6XwYVGULmwprtqnKOINd8M ug== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w4fq6u8jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:41:57 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:41:55 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.57) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:41:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+KEoC6EzKi3ZtH1ZSCWkxrc/sptQ2pkej1wgWTNeFQBpf1oOaGSsGPny3WTKdxkRfdP0TmWo/yt6DZThT17pig1Y1QRoqUedWv2fr6yIv8KqOzyQpAf7VKer9UEnSQT1hmyWh7+SuLX9mTXk8T65gsRA/L3R9xAtJPqj2BjWIT5vuJVZT4R6vHMeOJ+iWBOcZWcF/oU2RMuXH13CcXkJyb/Wof4jjbl+W1/4kglu8U3zdv0aCbw8c6OiH36gc/FVghAseyWH4tDRQCYdmXOJ/cpB//1rJXVNQ7X2NGqRbplzs6S6ByzNX873gH/6GE1mOPwBM/SPeN6AjOyBWcInQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeqrhPl2fZ1tXQaa530n27icFsqOEBltcMHJPiOb7oo=;
 b=U6huMCKRuBnmXa+pje7U1pg9ohbHaOsft7OTXhOWuDzoQ3QtJG4bzj1YV4LaAHaYFop3dQ7gdGVcxQMGcRf2gjwUhXPWbe3QdeLD3v0+uILtm83m8Zwh0/GWxMpvGESAXvLwbmk7zVEtgDB1s4kxH2vDM4WpGk/PaftT3kJ8kmRGOMPU36ClLFBiZY+ID3zWwznRgxmOcH9LGL+kTVTQQpWLRMbk8Uctn8sDEjKoQuOm1wkq+UxVo895IGF5coOlFvTiKaEAHOQiLn0vjDlTrqFNQs6/D9kTNGQEjYT+q6qH+Hwmy2uWo8PWk39pwcpaSYV3MaBblcl2VE6FaqG6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeqrhPl2fZ1tXQaa530n27icFsqOEBltcMHJPiOb7oo=;
 b=ghkWkGJDrnYApsjwVSpMIpQEBJAqEqw9m+8UdNm0IJe6ke90ZKRseXS94nJKfXXr5HmkZf4d7ZNWIeXJsYOH2sTZP1wbD9sEGBAViImdItjNxOcMoukU+zgxXeD9CSDgIW5Qm7kwq9RuV0MDaHc8x+KSYqJaGIJEStvG7i2exck=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:41:54 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:41:54 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 04/12] net: atlantic: add msglevel configuration
Thread-Topic: [PATCH v2 net-next 04/12] net: atlantic: add msglevel
 configuration
Thread-Index: AQHVlbyNj6wka7VuoUWrkDofh0G0Kw==
Date:   Thu, 7 Nov 2019 22:41:54 +0000
Message-ID: <59d4adecc9931662dcd4457dc22425d244e9bd81.1573158381.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 0d8c2e0a-e1e7-4300-cc4b-08d763d3b00f
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB22953D23BD3870358B1B1AB8B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:98;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W1kR4Gh5BI9wysF+SkRBz5UW/5cZ8O5K8X0fj4Wk9zIQsJbok/6fg/syDny5IZP8SFEwDUIe80yX5O1AGQvW6hVDwIGLDaJsfsksNfS7drtFZTOe5ERtoEqdGlCPEyKQoXcDBe7kcrTGmdg+oY9OxU8inq+huLtTNBGZPAkTcx9vh5pYXGypD0zEYihUuUSYqGGk6vsyCU0jzZ3ccV5o84OsvTIF+DnbpuZewY79mDydoddMdsL5Y2CENUo3mC2DVP9xOtQJVmzUpLP38sxw6UbUsv/D6Sq7/Nz9zlTK2LzaLZaktlKoZSMNDfJM1U+4mnMd8qYMi/FTmU19Yt0vW5rbKu6dofbhmKLk+E3sWxNYm4n8ovESdAge8rfx4qRnDUjJLB7Qkn88cJdY0z+j5Iabu/w7opAhpKmSiv3pufKrRhkMUkstGFFeAcP/Xydo
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8c2e0a-e1e7-4300-cc4b-08d763d3b00f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:54.1977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e/UxzJJ7dTFPIjsRncSz3MS8YZdosApg2tPW/kx6IeOz+2cdlBdM/OAX+LM/Vxekoph+wWzC9FKVq17C63M89A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

We add ethtool msglevel configuration and change some
printouts to use netdev_info set of functions.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c  | 16 ++++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  |  7 ++++---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h  |  1 +
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 3c55cf13cf14..5be273892430 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -607,6 +607,20 @@ static int aq_set_ringparam(struct net_device *ndev,
 	return err;
 }
=20
+static u32 aq_get_msg_level(struct net_device *ndev)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+
+	return aq_nic->msg_enable;
+}
+
+static void aq_set_msg_level(struct net_device *ndev, u32 data)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+
+	aq_nic->msg_enable =3D data;
+}
+
 const struct ethtool_ops aq_ethtool_ops =3D {
 	.get_link            =3D aq_ethtool_get_link,
 	.get_regs_len        =3D aq_ethtool_get_regs_len,
@@ -628,6 +642,8 @@ const struct ethtool_ops aq_ethtool_ops =3D {
 	.set_rxfh            =3D aq_ethtool_set_rss,
 	.get_rxnfc           =3D aq_ethtool_get_rxnfc,
 	.set_rxnfc           =3D aq_ethtool_set_rxnfc,
+	.get_msglevel        =3D aq_get_msg_level,
+	.set_msglevel        =3D aq_set_msg_level,
 	.get_sset_count      =3D aq_ethtool_get_sset_count,
 	.get_ethtool_stats   =3D aq_ethtool_stats,
 	.get_link_ksettings  =3D aq_ethtool_get_link_ksettings,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index d5764228cea5..8f83e91f8146 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -144,9 +144,9 @@ static int aq_nic_update_link_status(struct aq_nic_s *s=
elf)
 		return err;
=20
 	if (self->link_status.mbps !=3D self->aq_hw->aq_link_status.mbps) {
-		pr_info("%s: link change old %d new %d\n",
-			AQ_CFG_DRV_NAME, self->link_status.mbps,
-			self->aq_hw->aq_link_status.mbps);
+		netdev_info(self->ndev, "%s: link change old %d new %d\n",
+			    AQ_CFG_DRV_NAME, self->link_status.mbps,
+			    self->aq_hw->aq_link_status.mbps);
 		aq_nic_update_interrupt_moderation_settings(self);
=20
 		if (self->aq_ptp) {
@@ -306,6 +306,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->priv_flags =3D aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE;
=20
+	self->msg_enable =3D NETIF_MSG_DRV | NETIF_MSG_LINK;
 	self->ndev->mtu =3D aq_nic_cfg->mtu - ETH_HLEN;
 	self->ndev->max_mtu =3D aq_hw_caps->mtu - ETH_FCS_LEN - ETH_HLEN;
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index ab3176dfc209..527273502d54 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -88,6 +88,7 @@ struct aq_hw_rx_fltrs_s {
=20
 struct aq_nic_s {
 	atomic_t flags;
+	u32 msg_enable;
 	struct aq_vec_s *aq_vec[AQ_CFG_VECS_MAX];
 	struct aq_ring_s *aq_ring_tx[AQ_CFG_VECS_MAX * AQ_CFG_TCS_MAX];
 	struct aq_hw_s *aq_hw;
--=20
2.17.1

