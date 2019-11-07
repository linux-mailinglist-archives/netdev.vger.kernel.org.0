Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76748F3B96
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfKGWl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:41:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbfKGWl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:41:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7Mf9HK003108;
        Thu, 7 Nov 2019 14:41:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=IVL6fKCBHuUpTlTfL9TPW/6/jqpwJUsNULJabCDXTiY=;
 b=A0qNqN0wdlL6C/QoYsXGWebyY/KmLnSEKhwFE6LF/A5DgIX0nFLQWMwLhJB9FDB0/Fzb
 nBkIbFfaEPcigXSYQThKbl/uv3daMY+6bepaumGeK2HkwivEscmMTwC69JPGGvzkGJO/
 eEjio6FfqHj2SAE1nOke7lDjIqyHRPZTZFBPvxoJjcuuYC4X+/oL+FEKN5sKL4Mh8Bnm
 qChSDTdPNL1cXyRxBleGK4l7tUdj//MfkkW5A4qVbK0SBjendJlxNxyBHo5RG5MZKNXK
 dk8QAuZx0qlp/8e0bZPlhlcxFJhMMskmiWhbtYL+wBOAcQfAA7xdBNEm376zqFb5H5J4 4Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxres-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:41:53 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:41:52 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:41:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6torZonbPjYGycUCM+OALQjAE2Y9yvW3DKz/G0WvKYZf509LpEvxAq2yVlv/QeYl0/Jj898f3TYeI9LP+zVQLZbOKkZehX/T9bxrsWFOkvR7eggdkeXNfpTZhgrw1tZmgJ1f6Ywr85TuJUHgcE7qBVywgJTKHVfMDYdxoE11uTAhClWIEe+fuUGczA9D/QYQS2yU8zNNC4hr4vE3r+fzIr10dMhRTKBt4KRvGsqAwHZS8URYKU3FOUjOCEqS9f8iEYTgWAyD6FmXI1EwVRPuHGhWcT0kF58LbKy2ZaPBigFWfQPs9PaN0HaqyPpMN3FYV2R9r/ko+Xy0617I5kHsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVL6fKCBHuUpTlTfL9TPW/6/jqpwJUsNULJabCDXTiY=;
 b=NsjyztGYyKDBmF/w7WcPZ9isi0vBuC9g96Inz7xcNONnl35OjWJAoWxYGCvK/dqKoWJ8U92KPpRsNY3uY0/Wb6Xv3wRcyF2nhiAD2WDpa33fsZOhshkew5/GGuxOGZm7AG520uoUgRTFF258ceqgPjWXEbKz88HcLtXiU95+RvXOkImucBZ2te4cMzSXxOFxlEE1MTCmwe7bCBROdQhZMp0wLwX1S2LusoE/i7Az+1KK7OWlEbzHdUbsdBMKf6QO64G7X25A7kfDU1vrbBVxIyTOWJBedzFOvGojDudSxUnPKt4r34YqstqhXZUw7mqI7jKdmRUuIItqKVjNUCIRog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVL6fKCBHuUpTlTfL9TPW/6/jqpwJUsNULJabCDXTiY=;
 b=VtN2DVN5uNIPqIi3n2HJm6NhH6PKZFUsksaORpK8y37AY9B5xPYl1hgBeSs6+XnE5wNXA4LdwgiJ9xGI6UzN3tEL/nXUHHJzGqMG/IzssAxl90BikELB8vIYeAInQp8vlVzAt+0CeQYhCfPywfEKQtvfy6N+HO7TOF4GJZxLdBY=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:41:51 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:41:51 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 02/12] net: atlantic: implement wake_phy feature
Thread-Topic: [PATCH v2 net-next 02/12] net: atlantic: implement wake_phy
 feature
Thread-Index: AQHVlbyLSY6kAGN6ykmqhaO8FyvRKQ==
Date:   Thu, 7 Nov 2019 22:41:50 +0000
Message-ID: <a3558daf4e62b490376d7f4fa22d1854bac57724.1573158381.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 1de8d7f0-ca45-4c80-554b-08d763d3ae18
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB22951B2F3522C2C62158995FB7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(30864003)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S4WDl8DafQARcEP7qGky0F2q2UWBeHuAcMlTOQMRC02tfR0nc6x+B1UUc+1GqrRwRh/Q9foMkZWaf62WlPP88Rb0H0WCRN5BVGEbvspa2ReCjI1stsK1LLm8z7LnX6olTuG8tg25kr1Ur2nxZ1AaWMmmLNEkxgJVMR2ovpCfPNweR85QprKGiAsGT7LvMOYCCi9hzENAlMigfedVkKOMe0glCPR6AVKoJJBlwUb+fgVlvt9MEDjICXw9CDUQ1BXjVGnTV8GiyliNS/0YM6kt7Ma5TZANzP2y8AMiuuxfG7wYaIWO8Qv9dHh/Ybjr9ww9G5UE9ad3wCS0K8cjaAdcKC1g6EjyfrKve1B8/wbs4HsorD+zjBUcQ4ovy48hEvBHGgA/c3mDotQt32jOYLW7ar4cQFaqzNh0qs377xaLAmL/WQg8yYXacd1Xs3YVLzoN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de8d7f0-ca45-4c80-554b-08d763d3ae18
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:50.9442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N3uEp26eOje4ySCn/dAvkYivyZrcHCxv7gzAKw/khY+pTpVZ1wibFcKzRcbq6ocs7u49lsI9PmYp3jFs4XAWGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
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

