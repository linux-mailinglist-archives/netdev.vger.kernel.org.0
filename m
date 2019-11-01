Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B6EEC290
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbfKAMR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55546 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730559AbfKAMR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:28 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1C9YV8018587;
        Fri, 1 Nov 2019 05:17:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=qgIBIp5Oci3sFwu3uvL1vJj5Oauj8htBJgUg9KtVZPU=;
 b=wYoi31fHaAaLsVU814pQN+xTbdaOj13JaF3W5+9BhdxgmdKKFlPKBmSIEl415272iKCw
 yvFnOGuLsKtq7pA9c6tyQFHMnY/la71yxaC2jKTlJwl3JklkYJmWiZzNvEJavTINE08K
 tzifL/o3v/y1jT+kHwqY4BPfCfQ5KkaYHRUh6uTTRYuxZJa5bxa4XsBztV62eDxbR86/
 3CsnhhUYGsWPqtm6edx8Xdyd7DpbB18L0h+XD9MoJXQG3wClEC6cSz1MUelrzrDbE7rB
 MDr1n3mFwTY9Kqmehzlni+Mm5EoyHCgxZvZ6bMxOL/81mrjKIUHAvxvEbI92wOIEKR0v Kg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vyxhy4qb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:25 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:23 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QekKea8i+BCK7XmS87TYSspPjfQrAsCNmW9BIcJA8rJRGWp+UBpYhNcOzyIfjJBODdl612GGhSzHZiVLVBwi3pbCQRuLCI/c25xN+nECBMuCcgQe/D231HV7lCwz8nnxpvix5dMxlUehTXH6JfHv/6yKQP+i6srXOvbDJ+TD+homPcUUmxzyjFjVmmv5BHPXYJmoYrJtVLZoTJaDmvV8bKz2MluX93fcOgNm88clI/plBH8QUj44qdilVcX43XEgfmZ59zmdpLjPMMI7QdUJ5n1XQHazzfZyRFJppjkwtf7kWwMH8OfWPbXNW47MVbnbP80mpXk+6VKSFnBawf81lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgIBIp5Oci3sFwu3uvL1vJj5Oauj8htBJgUg9KtVZPU=;
 b=lmy1GU88PtuMTmLDmIP6QuvnLyn4/q9F6WVE4dr1zNrTXt1Apz1gU92gJqVTw5xb7QSQF81Na+HeJEj7BIqbMMA76otHlBMFH82rTSLFzv9IhYhTcBlrJpb4tRssc/RFEjqBw3Fjh6d3Zbd35bz340fUCMHYhdm3lurme+c6HC3QHySATVI4UbrdYsOuhhbOfp5+kRE2A7moxHP8NVW7GaayqDUWJ0eLqeGTgCaDI/KYiAi55rfiHD7fF2jz0agCnMiHPbbfq5erKAjexPqFQ3DGnqzgJ9jP0nZXm5BLlR96sxqPOL0zj5ZXMihWwNF/5RsZLQfwuPWQ5Dlw1mEBAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgIBIp5Oci3sFwu3uvL1vJj5Oauj8htBJgUg9KtVZPU=;
 b=OmX7Y2mik/aIrtA/vdmqTk8LYc7aweAi1bfa20ZjNeaGjZspLhSXQOwVyxNEnnpg7rW/EpWc3mC2+bLd6BelOygO6rj2FrOgZOesh06dJ/sj2y92Tuzc7x/ogVivb3MVLl5zTc8YP6GQujhB8qsPI0E9lxAre/naXMdGEFmFAzk=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:19 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:19 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 05/12] net: atlantic: adding ethtool physical
 identification
Thread-Topic: [PATCH net-next 05/12] net: atlantic: adding ethtool physical
 identification
Thread-Index: AQHVkK5O8WLFOiKmA06H7VhHTjHyoA==
Date:   Fri, 1 Nov 2019 12:17:19 +0000
Message-ID: <69c0157aa8826dd0c7f2ea97af1e325dfb333301.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: f275d170-7dde-4aae-d114-08d75ec570c4
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306BBCDE8923536817D1C8BB7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:78;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3sKioX21ka9x4Tj/Y3QGIL4WG3sylyp3v9exVKpuX+F5iHROBhYThJuzm+TnId5SLKsym3iQsrAf9pupWe7TAnYOseM+AlxDGEKn/bQv/gA0vivH+FLhm2o3l0Wej3vXoM0mmjKC0KHxyNT4CmsAlZjYmOHeVe1ghMVu9J4Gno9Zj3h6M1jZeYY9eshOSsxf2T0eUxEZrmdVV+F+K8Q5cxAS9pXFPogkVN278+zwlt3UnoKB9vGuOXzVyQR4/QXsmMkgAyA8RohIB4bYcmKurlc20qdxRud69BCp2svNaeeX6L+rgDnIP7Patk0904Jz2kq7+ZbW8qujrH8pK9J8qcA7ODJiQrarxuzWol8zvs/jS2DpsjY8Y3yQhrKr5pCzfcFPc4DvOKGAeTdoKtzcFd6YyA54JOCUgbJ7fwJF+uZCFY581FP7e6rJYDrkARN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f275d170-7dde-4aae-d114-08d75ec570c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:19.2128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fCQzw6oLxYjovTpLbnZDIoLecEb0MhfIT3pGSEPGwWeVBdY4nSNUGpkruB504yL8cThAFQYCplL0kTFiORG92A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

`ethtool -p eth0` will blink leds helping identify
physical port.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 30 +++++++++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  5 ++++
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  1 +
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 14 +++++++++
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 5be273892430..2f877fb46615 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -153,6 +153,35 @@ static void aq_ethtool_get_strings(struct net_device *=
ndev,
 	}
 }
=20
+static int aq_ethtool_set_phys_id(struct net_device *ndev,
+				  enum ethtool_phys_id_state state)
+{
+	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
+	struct aq_hw_s *hw =3D aq_nic->aq_hw;
+	int ret =3D 0;
+
+	if (!aq_nic->aq_fw_ops->led_control)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&aq_nic->fwreq_mutex);
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		ret =3D aq_nic->aq_fw_ops->led_control(hw, AQ_HW_LED_BLINK |
+				 AQ_HW_LED_BLINK << 2 | AQ_HW_LED_BLINK << 4);
+		break;
+	case ETHTOOL_ID_INACTIVE:
+		ret =3D aq_nic->aq_fw_ops->led_control(hw, AQ_HW_LED_DEFAULT);
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&aq_nic->fwreq_mutex);
+
+	return ret;
+}
+
 static int aq_ethtool_get_sset_count(struct net_device *ndev, int stringse=
t)
 {
 	int ret =3D 0;
@@ -627,6 +656,7 @@ const struct ethtool_ops aq_ethtool_ops =3D {
 	.get_regs            =3D aq_ethtool_get_regs,
 	.get_drvinfo         =3D aq_ethtool_get_drvinfo,
 	.get_strings         =3D aq_ethtool_get_strings,
+	.set_phys_id         =3D aq_ethtool_set_phys_id,
 	.get_rxfh_indir_size =3D aq_ethtool_get_rss_indir_size,
 	.get_wol             =3D aq_ethtool_get_wol,
 	.set_wol             =3D aq_ethtool_set_wol,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/e=
thernet/aquantia/atlantic/aq_hw.h
index 5246cf44ce51..c2725a58f050 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -119,6 +119,9 @@ struct aq_stats_s {
=20
 #define AQ_HW_MULTICAST_ADDRESS_MAX     32U
=20
+#define AQ_HW_LED_BLINK    0x2U
+#define AQ_HW_LED_DEFAULT  0x0U
+
 struct aq_hw_s {
 	atomic_t flags;
 	u8 rbl_enabled:1;
@@ -304,6 +307,8 @@ struct aq_fw_ops {
=20
 	int (*set_flow_control)(struct aq_hw_s *self);
=20
+	int (*led_control)(struct aq_hw_s *self, u32 mode);
+
 	int (*set_power)(struct aq_hw_s *self, unsigned int power_state,
 			 u8 *mac);
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index fd2c6be4e22e..fc82ede18b20 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -970,4 +970,5 @@ const struct aq_fw_ops aq_fw_1x_ops =3D {
 	.set_flow_control =3D NULL,
 	.send_fw_request =3D NULL,
 	.enable_ptp =3D NULL,
+	.led_control =3D NULL,
 };
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index 9b89622fa5d4..4eab51b5b400 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -17,6 +17,7 @@
 #include "hw_atl_utils.h"
 #include "hw_atl_llh.h"
=20
+#define HW_ATL_FW2X_MPI_LED_ADDR         0x31c
 #define HW_ATL_FW2X_MPI_RPC_ADDR         0x334
=20
 #define HW_ATL_FW2X_MPI_MBOX_ADDR        0x360
@@ -51,6 +52,8 @@
 #define HAL_ATLANTIC_WOL_FILTERS_COUNT   8
 #define HAL_ATLANTIC_UTILS_FW2X_MSG_WOL  0x0E
=20
+#define HW_ATL_FW_VER_LED                0x03010026U
+
 struct __packed fw2x_msg_wol_pattern {
 	u8 mask[16];
 	u32 crc;
@@ -450,6 +453,16 @@ static void aq_fw3x_enable_ptp(struct aq_hw_s *self, i=
nt enable)
 	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
 }
=20
+static int aq_fw2x_led_control(struct aq_hw_s *self, u32 mode)
+{
+	if (self->fw_ver_actual < HW_ATL_FW_VER_LED)
+		return -EOPNOTSUPP;
+
+	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_LED_ADDR, mode);
+
+	return 0;
+}
+
 static int aq_fw2x_set_eee_rate(struct aq_hw_s *self, u32 speed)
 {
 	u32 mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
@@ -557,4 +570,5 @@ const struct aq_fw_ops aq_fw_2x_ops =3D {
 	.get_flow_control   =3D aq_fw2x_get_flow_control,
 	.send_fw_request    =3D aq_fw2x_send_fw_request,
 	.enable_ptp         =3D aq_fw3x_enable_ptp,
+	.led_control        =3D aq_fw2x_led_control,
 };
--=20
2.17.1

