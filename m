Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA11EC28F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbfKAMR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:28 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfKAMR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CA3me019181;
        Fri, 1 Nov 2019 05:17:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=QeqrhPl2fZ1tXQaa530n27icFsqOEBltcMHJPiOb7oo=;
 b=rONM4liYB+pbsyVhdnTRIP5b+CXdeiqw1yUKNr299bHkxbUeC4MdyAzm4zYSHj5BkKjF
 Zt3yL5TQUoEyk9Wl++l6S9bx7zYd9WfqkKWDtLJDx+rpB1wZ7W671dgNmJhiOIq/cfEQ
 gb7zbcXELS+zSorRRGEAkTxrKkz292RKMq2mkkULO6GT8HVAmvYZwa2GlROmt+UDfhvF
 8Wdy8QgWtsITsbB7SpPHLb/Yw8kPoPeY/ZLYz2AhiqQpJzfTJ8yzjP0e5Rde9GczXyW+
 1YYLHJ/fOfzIGbXBOFsALNYwxNalddx/AUZ1NfKeUlIDZx8T34CJVErjZpMqEhLBYp76 gw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vyxhy4qax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:24 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:23 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtWaf+bpayUzsR4z2iJlYR80u8uT23lPdwOU9cEiQM6kfq5FYoC1db5ALWg9B4MjsynNLvHNgpM+w+vDS9WjH2YOLndo1m0FXfuXKT6ATne2AoR2zk6OvTaUImJAKRHkHQLM6OyJvxqt8ENAmgrbIf0sOaJgvDAvXKdsdoa7cWiUeFeEFztg1Fzop85n4rclXsiCY8FfrCGaSRn1vjlVRx67rwBEoQhvwclHdG0G9zW3OyLpWivAfPF/fxp6m2QTkz4va+qadYBemp5sximCkjFC6+wrizM1l13zaLX5UkkyumxurvOshCQR33Ws383ysRlpxMg9i1gLZvhYQwAaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeqrhPl2fZ1tXQaa530n27icFsqOEBltcMHJPiOb7oo=;
 b=CWF+GPLW1EHsjj/Gh+C6ZHmoBpG3Cw1h0CnE+aSe0NsrwEvSTXLZv1CC5QzWSVjcJAqxcs5hMTNHiUGh0bCCkMo2852iR6JcSpZzjXq0ncQ2rNigR53kEKu0QvPdXnjBN/ALz7me+8exRFAgal5YEXM5wDv9V9xj3JH2NbjwCnCAHl+dlvaUjkFfuiY9BxMah7UnlFu7f1iBNLfjFUDd401ZSeO6ct3SP4gZfnvilGEAKEE/qkMY1BH4CK41cUPiT8JUl6sYlqJt7+hItcJ55V6zn6USO9q/aUdNL42UhfJDHdcsEdM95422IMdR6tUOAVh/8RPBHOP+F13M80YtHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeqrhPl2fZ1tXQaa530n27icFsqOEBltcMHJPiOb7oo=;
 b=Vp71bwbhAMR2hKZgvPo4wM9sPsdo60lHFF4YeXwBrnfmBXk8s8zTMsvXrYmCSYwzMV9Es79Oh9tXcl+9xS/fVhF6Zi2zBGp9Ty3RAWH7XfihOxQpd9XaPvQ3f+4oqD/nU+ONPxqe3853PMwzSZyV4ctpTSnOjfM85FUuDOOtTEk=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:18 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:18 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 04/12] net: atlantic: add msglevel configuration
Thread-Topic: [PATCH net-next 04/12] net: atlantic: add msglevel configuration
Thread-Index: AQHVkK5NaiYiQWNl+0SFCsFI4GLTVQ==
Date:   Fri, 1 Nov 2019 12:17:17 +0000
Message-ID: <765a5eb67e638bf73369b016cadd17260d73f4c9.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: ac5cb67f-b687-42dc-58a4-08d75ec56ffd
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB23066ADDE569D29D4EE4F318B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:98;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AjxmcDkrdLtuJmFrUq8EChzSbcnfOar1c63meBLuS7r5URXpE3HXAsv7szifGHG81lpwBtHs2Gsc+C/5c+si4Sw+ogoD/6eoYGgMHCHwIxCPVen26i9NeSlKEbLhoXTtcwUYpbD6P8c0vXicX82evOdwdz99hwTXpDlSB55ZS88VRDhF/uSFCjh9HOZ3ssRLZvSy0CU/PzJiF9MA5BFln0Jp9ZD2tIVOGhw+vQSY/2NwVjLOOa3nAcpgpETnNv9ZDCeKXLbeFAwje0twCL1Dlnd/VWKYNqTEgpWTtLCx2nyQQzkJOT4F7Tnl6dlb/P5NPp6x+5VAgE66aFZpxwUev8cVdP6k4znfu26iYMpj5y+Cr31T69CGfmFqzB+LP14iIiXIoy3gYLeY2572Oh0nmgrYkIWGXy2871yzlF7YggjLZLgU78XxIkUuC2A7Nj/d
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5cb67f-b687-42dc-58a4-08d75ec56ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:17.8945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JN+3E1xQw1nH6/OM2dNig7rhuclRiKe2T0+C0qLKVOfjOdplhfhFvg7ui365zFfstJX7Oms1ySFFN7e/5TK60Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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

