Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6779EC28C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfKAMRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:24 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51436 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfKAMRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CA8Jh019225;
        Fri, 1 Nov 2019 05:17:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=IVL6fKCBHuUpTlTfL9TPW/6/jqpwJUsNULJabCDXTiY=;
 b=gXaOHjzzfoMRq/hvzUyYdEkG4Fr05utJRlXR1RMAL4J6vCeagxIc2p5gZ5hfURZahiW+
 acsrfNdKrY3dO4lm8/BO79DY+k//YDgbtJBEosNA2U3xkKu5FGocbDmAtjY/2qbt8iWA
 mvMNtRGf8LPLnvXVMFJd9oFTVlcSOsuDrAKyhrfPTwfd2DBSbmnTCr44Pvl+HT9m5d53
 Pq0/GxkowV90TgfMBVfdNM+10SvlXiizLygIo6L1AQ6fOl10gXEjlOJmYowwXmrn8nrb
 LI98psbLXPkFjzcFO+DOPj8+YuCzhI+Z6KZzqdWGs3NOAnmvzCYpRTQ3S6H075t7uyxL YA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vyxhy4qan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:20 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:18 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQVU37WxWOfkU2mq2Xwj351bBUo8uqtp4wsFa10pGewFQ2ObIXMZIIgpf2yNzR0fLrPsVcSvBPVJzNxl1f3STBp5+hKA1FxuGnglNnK7hj3xJJIqPXZkUWU7CCIq0eBK2p11dQyNMG4f2hONt0CPMMS2A4PevBFlE9wMMe6t1HeUJ3jS3CChE+jjgpCfe6TCwrrD8NeNWxRWL2+28twdMqgmLlIJwQRWEgqAu/090kc3DjNGsUVNJ/6vUlsGFZ1YTR/9h9xKjqGMNUBqcxmz/KQJM+t29PcCjoO/30Mdj7iwWjMSw1sbPl+V+3sRestXfYfk9wJDgt7si9WlBiaU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVL6fKCBHuUpTlTfL9TPW/6/jqpwJUsNULJabCDXTiY=;
 b=KChLaVl+5szNAv5OO9Lapfb5nByjMQBIVCNuucr1ofRFPwLTxSmuWOt7zKJSN2SgRzZSdVoYbXft66OV9GdRB8nAtLv6XmVRtdvhLXgTZxaqVEwB/zDot8mTYchYDzG3Kno63e2cs6sZ/xi9I6h3xd+DDimSimT2gWgSwKczB35+IyYhoYkdDDuDsPaCjMJFqufPMvgGHtDKEJYRL9TE+7rQB6XaOfdo9QeB3aG2/afi5tW24M3WUTjOZfeIDYoCBioizt7Cp8uy71p/o9GveoUeF+shCbtbi4YKIrpMbw+CxqYZibiUas1qtbmUFnMq/JJXFIQK9WCM+ZWLAVUioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVL6fKCBHuUpTlTfL9TPW/6/jqpwJUsNULJabCDXTiY=;
 b=dHGcavqG8gns2unO/qTslserFGbBTk+9r19CE7W/2ooTWkWm62QRuuJMY6ci73Rofj6qx0imMkBcEjYZcxa6aAtxxCP5YXytji6S8ZWdZV/VF9uAV7WELgUletX83ZPcKLjZG0DPd040ktsrqbQ5+Yf1gNqCz7gOVvTTObB35DI=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:15 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:15 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 02/12] net: atlantic: implement wake_phy feature
Thread-Topic: [PATCH net-next 02/12] net: atlantic: implement wake_phy feature
Thread-Index: AQHVkK5M2pG5TEZPCEGt8s5WgWReiw==
Date:   Fri, 1 Nov 2019 12:17:15 +0000
Message-ID: <a3558daf4e62b490376d7f4fa22d1854bac57724.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 2ddd16c9-a8f5-4eff-e679-08d75ec56e61
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB2306936CBF854532EB33D62FB7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(30864003)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SFQnBXtlgWAT6kEmQCEpYjS4eV9OAa5hgmlSOlp5FRRZ3cGWM5zylg32R1bEpj7YG+HZsWR0vz2gWvD9Ng4ep3pjsqXGR1pStkdgMHhjfZL3NpjrnIU0vhvdyuR5UAL94X89Fcrk1r4h2YGDFUi1pXDjcC9AE2Rk+SLc2gc5YMgMhLhj2Gw/j6WVR1ru4ipsRnLelBSS/Ixjrnx9QwpCdQrvhoTOWYNCRJMSq34DOzcYSvYjZr2cO2+cEzGuyIMmxj1jDE8hgCG/vlOnUvkCDlSOWb7j55GBOXULPbnnsEv8RltztSIpN1p8VUIRzgtorbbcpK29OBl6eS6zy/lSdfTL2BU4wZOeZe4u8bjdaWeBfVYsb7puDajH6d9FCU8uVKawS3Ce443awEMsgMztQEL5uH+n4+V/We3PtkNSe6WFcVuKPhwxwjdBE3Q9NbPt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ddd16c9-a8f5-4eff-e679-08d75ec56e61
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:15.2351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IvR3hW2q+BUxPhTazP9nhE3eVyW7MUzjERZlWldzCpd4WW3U+ACWZ5DVRWgrjKMskW9A2Pcl5XfUD4LsNHdhTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

Wake on PHY allows to configure device to wakeup host
as soon as PHY link status is changed to active.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_cfg.h   |   3 +
 .../ethernet/aquantia/atlantic/aq_ethtool.c   |  18 ++-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |   4 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  34 +++---
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   6 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |   7 +-
 .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 111 ++++++------------
 7 files changed, 73 insertions(+), 110 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_cfg.h
index 8c633caf79d2..d02b0d79f68a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -78,6 +78,9 @@
=20
 #define AQ_CFG_FC_MODE AQ_NIC_FC_FULL
=20
+/* Default WOL modes used on initialization */
+#define AQ_CFG_WOL_MODES WAKE_MAGIC
+
 #define AQ_CFG_SPEED_MSK  0xFFFFU	/* 0xFFFFU=3D=3Dauto_neg */
=20
 #define AQ_CFG_IS_AUTONEG_DEF       1U
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/=
net/ethernet/aquantia/atlantic/aq_ethtool.c
index 1ae8aabcc41a..3c55cf13cf14 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -356,11 +356,8 @@ static void aq_ethtool_get_wol(struct net_device *ndev=
,
 	struct aq_nic_s *aq_nic =3D netdev_priv(ndev);
 	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
=20
-	wol->supported =3D WAKE_MAGIC;
-	wol->wolopts =3D 0;
-
-	if (cfg->wol)
-		wol->wolopts |=3D WAKE_MAGIC;
+	wol->supported =3D AQ_NIC_WOL_MODES;
+	wol->wolopts =3D cfg->wol;
 }
=20
 static int aq_ethtool_set_wol(struct net_device *ndev,
@@ -371,11 +368,12 @@ static int aq_ethtool_set_wol(struct net_device *ndev=
,
 	struct aq_nic_cfg_s *cfg =3D aq_nic_get_cfg(aq_nic);
 	int err =3D 0;
=20
-	if (wol->wolopts & WAKE_MAGIC)
-		cfg->wol |=3D AQ_NIC_WOL_ENABLED;
-	else
-		cfg->wol &=3D ~AQ_NIC_WOL_ENABLED;
-	err =3D device_set_wakeup_enable(&pdev->dev, wol->wolopts);
+	if (wol->wolopts & ~AQ_NIC_WOL_MODES)
+		return -EOPNOTSUPP;
+
+	cfg->wol =3D wol->wolopts;
+
+	err =3D device_set_wakeup_enable(&pdev->dev, !!cfg->wol);
=20
 	return err;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_main.c
index a26d4a69efad..2c1096561614 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -74,7 +74,7 @@ static int aq_ndev_open(struct net_device *ndev)
=20
 err_exit:
 	if (err < 0)
-		aq_nic_deinit(aq_nic);
+		aq_nic_deinit(aq_nic, true);
 	return err;
 }
=20
@@ -86,7 +86,7 @@ static int aq_ndev_close(struct net_device *ndev)
 	err =3D aq_nic_stop(aq_nic);
 	if (err < 0)
 		goto err_exit;
-	aq_nic_deinit(aq_nic);
+	aq_nic_deinit(aq_nic, true);
=20
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 433adc099e44..75faf288a2fc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -79,6 +79,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 	cfg->num_rss_queues =3D AQ_CFG_NUM_RSS_QUEUES_DEF;
 	cfg->aq_rss.base_cpu_number =3D AQ_CFG_RSS_BASE_CPU_NUM_DEF;
 	cfg->flow_control =3D AQ_CFG_FC_MODE;
+	cfg->wol =3D AQ_CFG_WOL_MODES;
=20
 	cfg->mtu =3D AQ_CFG_MTU_DEF;
 	cfg->link_speed_msk =3D AQ_CFG_SPEED_MSK;
@@ -1000,7 +1001,20 @@ int aq_nic_stop(struct aq_nic_s *self)
 	return self->aq_hw_ops->hw_stop(self->aq_hw);
 }
=20
-void aq_nic_deinit(struct aq_nic_s *self)
+void aq_nic_set_power(struct aq_nic_s *self)
+{
+	if (self->power_state !=3D AQ_HW_POWER_STATE_D0 ||
+	    self->aq_hw->aq_nic_cfg->wol)
+		if (likely(self->aq_fw_ops->set_power)) {
+			mutex_lock(&self->fwreq_mutex);
+			self->aq_fw_ops->set_power(self->aq_hw,
+						   self->power_state,
+						   self->ndev->dev_addr);
+			mutex_unlock(&self->fwreq_mutex);
+		}
+}
+
+void aq_nic_deinit(struct aq_nic_s *self, bool link_down)
 {
 	struct aq_vec_s *aq_vec =3D NULL;
 	unsigned int i =3D 0U;
@@ -1017,23 +1031,12 @@ void aq_nic_deinit(struct aq_nic_s *self)
 	aq_ptp_ring_free(self);
 	aq_ptp_free(self);
=20
-	if (likely(self->aq_fw_ops->deinit)) {
+	if (likely(self->aq_fw_ops->deinit) && link_down) {
 		mutex_lock(&self->fwreq_mutex);
 		self->aq_fw_ops->deinit(self->aq_hw);
 		mutex_unlock(&self->fwreq_mutex);
 	}
=20
-	if (self->power_state !=3D AQ_HW_POWER_STATE_D0 ||
-	    self->aq_hw->aq_nic_cfg->wol)
-		if (likely(self->aq_fw_ops->set_power)) {
-			mutex_lock(&self->fwreq_mutex);
-			self->aq_fw_ops->set_power(self->aq_hw,
-						   self->power_state,
-						   self->ndev->dev_addr);
-			mutex_unlock(&self->fwreq_mutex);
-		}
-
-
 err_exit:;
 }
=20
@@ -1072,7 +1075,7 @@ int aq_nic_change_pm_state(struct aq_nic_s *self, pm_=
message_t *pm_msg)
 		if (err < 0)
 			goto err_exit;
=20
-		aq_nic_deinit(self);
+		aq_nic_deinit(self, !self->aq_hw->aq_nic_cfg->wol);
 	} else {
 		err =3D aq_nic_init(self);
 		if (err < 0)
@@ -1108,7 +1111,8 @@ void aq_nic_shutdown(struct aq_nic_s *self)
 		if (err < 0)
 			goto err_exit;
 	}
-	aq_nic_deinit(self);
+	aq_nic_deinit(self, !self->aq_hw->aq_nic_cfg->wol);
+	aq_nic_set_power(self);
=20
 err_exit:
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index c2513b79b9e9..8c23ad4ddf38 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -60,7 +60,8 @@ struct aq_nic_cfg_s {
 #define AQ_NIC_FLAG_ERR_UNPLUG  0x40000000U
 #define AQ_NIC_FLAG_ERR_HW      0x80000000U
=20
-#define AQ_NIC_WOL_ENABLED	BIT(0)
+#define AQ_NIC_WOL_MODES        (WAKE_MAGIC |\
+				 WAKE_PHY)
=20
 #define AQ_NIC_TCVEC2RING(_NIC_, _TC_, _VEC_) \
 	((_TC_) * AQ_CFG_TCS_MAX + (_VEC_))
@@ -141,7 +142,8 @@ int aq_nic_get_regs(struct aq_nic_s *self, struct ethto=
ol_regs *regs, void *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
 void aq_nic_get_stats(struct aq_nic_s *self, u64 *data);
 int aq_nic_stop(struct aq_nic_s *self);
-void aq_nic_deinit(struct aq_nic_s *self);
+void aq_nic_deinit(struct aq_nic_s *self, bool link_down);
+void aq_nic_set_power(struct aq_nic_s *self);
 void aq_nic_free_hot_resources(struct aq_nic_s *self);
 void aq_nic_free_vectors(struct aq_nic_s *self);
 int aq_nic_set_mtu(struct aq_nic_s *self, int new_mtu);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b=
/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index 6c7caff9a96b..fd2c6be4e22e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -845,7 +845,8 @@ int hw_atl_utils_get_fw_version(struct aq_hw_s *self, u=
32 *fw_version)
 	return 0;
 }
=20
-static int aq_fw1x_set_wol(struct aq_hw_s *self, bool wol_enabled, u8 *mac=
)
+static int aq_fw1x_set_wake_magic(struct aq_hw_s *self, bool wol_enabled,
+				  u8 *mac)
 {
 	struct hw_atl_utils_fw_rpc *prpc =3D NULL;
 	unsigned int rpc_size =3D 0U;
@@ -894,8 +895,8 @@ static int aq_fw1x_set_power(struct aq_hw_s *self, unsi=
gned int power_state,
 	unsigned int rpc_size =3D 0U;
 	int err =3D 0;
=20
-	if (self->aq_nic_cfg->wol & AQ_NIC_WOL_ENABLED) {
-		err =3D aq_fw1x_set_wol(self, 1, mac);
+	if (self->aq_nic_cfg->wol & WAKE_MAGIC) {
+		err =3D aq_fw1x_set_wake_magic(self, 1, mac);
=20
 		if (err < 0)
 			goto err_exit;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2=
x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
index f649ac949d06..9b89622fa5d4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
@@ -34,6 +34,7 @@
 #define HW_ATL_FW2X_CAP_SLEEP_PROXY      BIT(CAPS_HI_SLEEP_PROXY)
 #define HW_ATL_FW2X_CAP_WOL              BIT(CAPS_HI_WOL)
=20
+#define HW_ATL_FW2X_CTRL_WAKE_ON_LINK     BIT(CTRL_WAKE_ON_LINK)
 #define HW_ATL_FW2X_CTRL_SLEEP_PROXY      BIT(CTRL_SLEEP_PROXY)
 #define HW_ATL_FW2X_CTRL_WOL              BIT(CTRL_WOL)
 #define HW_ATL_FW2X_CTRL_LINK_DROP        BIT(CTRL_LINK_DROP)
@@ -345,87 +346,46 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self,=
 int *temp)
 	return 0;
 }
=20
-static int aq_fw2x_set_sleep_proxy(struct aq_hw_s *self, u8 *mac)
+static int aq_fw2x_set_wol(struct aq_hw_s *self, u8 *mac)
 {
 	struct hw_atl_utils_fw_rpc *rpc =3D NULL;
-	struct offload_info *cfg =3D NULL;
-	unsigned int rpc_size =3D 0U;
-	u32 mpi_opts;
+	struct offload_info *info =3D NULL;
+	u32 wol_bits =3D 0;
+	u32 rpc_size;
 	int err =3D 0;
 	u32 val;
=20
-	rpc_size =3D sizeof(rpc->msg_id) + sizeof(*cfg);
-
-	err =3D hw_atl_utils_fw_rpc_wait(self, &rpc);
-	if (err < 0)
-		goto err_exit;
-
-	memset(rpc, 0, rpc_size);
-	cfg =3D (struct offload_info *)(&rpc->msg_id + 1);
-
-	memcpy(cfg->mac_addr, mac, ETH_ALEN);
-	cfg->len =3D sizeof(*cfg);
-
-	/* Clear bit 0x36C.23 and 0x36C.22 */
-	mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
-	mpi_opts &=3D ~HW_ATL_FW2X_CTRL_SLEEP_PROXY;
-	mpi_opts &=3D ~HW_ATL_FW2X_CTRL_LINK_DROP;
-
-	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
-
-	err =3D hw_atl_utils_fw_rpc_call(self, rpc_size);
-	if (err < 0)
-		goto err_exit;
-
-	/* Set bit 0x36C.23 */
-	mpi_opts |=3D HW_ATL_FW2X_CTRL_SLEEP_PROXY;
-	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
-
-	err =3D readx_poll_timeout_atomic(aq_fw2x_state2_get,
-					self, val,
-					val & HW_ATL_FW2X_CTRL_SLEEP_PROXY,
-					1U, 100000U);
-
-err_exit:
-	return err;
-}
-
-static int aq_fw2x_set_wol_params(struct aq_hw_s *self, u8 *mac)
-{
-	struct hw_atl_utils_fw_rpc *rpc =3D NULL;
-	struct fw2x_msg_wol *msg =3D NULL;
-	u32 mpi_opts;
-	int err =3D 0;
-	u32 val;
-
-	err =3D hw_atl_utils_fw_rpc_wait(self, &rpc);
-	if (err < 0)
-		goto err_exit;
-
-	msg =3D (struct fw2x_msg_wol *)rpc;
-
-	memset(msg, 0, sizeof(*msg));
+	if (self->aq_nic_cfg->wol & WAKE_PHY) {
+		aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR,
+				HW_ATL_FW2X_CTRL_LINK_DROP);
+		readx_poll_timeout_atomic(aq_fw2x_state2_get, self, val,
+					  (val &
+					   HW_ATL_FW2X_CTRL_LINK_DROP) !=3D 0,
+					  1000, 100000);
+		wol_bits |=3D HW_ATL_FW2X_CTRL_WAKE_ON_LINK;
+	}
=20
-	msg->msg_id =3D HAL_ATLANTIC_UTILS_FW2X_MSG_WOL;
-	msg->magic_packet_enabled =3D true;
-	memcpy(msg->hw_addr, mac, ETH_ALEN);
+	if (self->aq_nic_cfg->wol & WAKE_MAGIC) {
+		wol_bits |=3D HW_ATL_FW2X_CTRL_SLEEP_PROXY |
+			    HW_ATL_FW2X_CTRL_WOL;
=20
-	mpi_opts =3D aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
-	mpi_opts &=3D ~(HW_ATL_FW2X_CTRL_SLEEP_PROXY | HW_ATL_FW2X_CTRL_WOL);
+		err =3D hw_atl_utils_fw_rpc_wait(self, &rpc);
+		if (err < 0)
+			goto err_exit;
=20
-	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
+		rpc_size =3D sizeof(*info) +
+			   offsetof(struct hw_atl_utils_fw_rpc, fw2x_offloads);
+		memset(rpc, 0, rpc_size);
+		info =3D &rpc->fw2x_offloads;
+		memcpy(info->mac_addr, mac, ETH_ALEN);
+		info->len =3D sizeof(*info);
=20
-	err =3D hw_atl_utils_fw_rpc_call(self, sizeof(*msg));
-	if (err < 0)
-		goto err_exit;
+		err =3D hw_atl_utils_fw_rpc_call(self, rpc_size);
+		if (err < 0)
+			goto err_exit;
+	}
=20
-	/* Set bit 0x36C.24 */
-	mpi_opts |=3D HW_ATL_FW2X_CTRL_WOL;
-	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, mpi_opts);
-
-	err =3D readx_poll_timeout_atomic(aq_fw2x_state2_get,
-					self, val, val & HW_ATL_FW2X_CTRL_WOL,
-					1U, 10000U);
+	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, wol_bits);
=20
 err_exit:
 	return err;
@@ -436,14 +396,9 @@ static int aq_fw2x_set_power(struct aq_hw_s *self, uns=
igned int power_state,
 {
 	int err =3D 0;
=20
-	if (self->aq_nic_cfg->wol & AQ_NIC_WOL_ENABLED) {
-		err =3D aq_fw2x_set_sleep_proxy(self, mac);
-		if (err < 0)
-			goto err_exit;
-		err =3D aq_fw2x_set_wol_params(self, mac);
-	}
+	if (self->aq_nic_cfg->wol)
+		err =3D aq_fw2x_set_wol(self, mac);
=20
-err_exit:
 	return err;
 }
=20
--=20
2.17.1

