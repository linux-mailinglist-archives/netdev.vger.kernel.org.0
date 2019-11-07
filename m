Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC9F3B97
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfKGWl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:41:58 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55566 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727720AbfKGWl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:41:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MekBC002982;
        Thu, 7 Nov 2019 14:41:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=G7RRo/1YUFQoiT6BTapw+k1EXTMeb5zN2pVZMx3RRfg=;
 b=kmow0Ti4UhLBtndiyHxGyp/a6nEIdE17kmVizrjhM6dYFlrgXU2749nLvsRU9xVhnMQ5
 eoorKMZ16mR1NiBw5t329diBDKqdUFnL1Ph3GDKD006qreTVm0BpcTv0oxicfhX+K1wH
 EMqM3wbebh8YbSD/WD1Sh86CneyP0Sn9RdB1XucMaiKoI1r6/6joCwHJjcJn3WwNiO/4
 pXWwiAnK3XfhEN5QIrMjucpMG/8RDFEIx7XV9P893CrGVBcczu97Yb/cDcUq1YTeM03L
 kbeZBCrLF70Z42PcyBjyK0zxv5wxpzu13fMruB0IhTeri3a+K1DaJ5jvfCTgRu9Ipczp dQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxrew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:41:54 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:41:53 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:41:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiYVIAuVxZT31Yzztrm+uA5Da2X50sTFBrZ2vwDv3uVGtKm2XxzOndi7QtrjjSNjrzGw/k7uPGYuAtQb6aoy+TmjxV6u5ECReQeJNwmneXt7BreKwZzLRV5KePfhJWUVTzTKkHe7poCC8FIFpdpNLt9zwrrAeeokcAduHNxAWiMjNwroLkI8ZxgYpSRdNlOyzr8EYafSX99QVAteaLjA5HbAeIUNypyDur31Kjnlpv6KyCfMPf14EZwZAfjj38sYyn/iPZhbxCjS315ngwYwuoDNghJOWdQdPYMHTO+X/Jdh1ELWaPlpqbbJF/oeqRZqhV4/K6SvpCHr5JSiISZjYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7RRo/1YUFQoiT6BTapw+k1EXTMeb5zN2pVZMx3RRfg=;
 b=RA7zGoZyvMr2sHrYKO+aJ5xOTRMysQ3wVGftqPRZ7zEHZRA1+SgHT7c9/SYaI+nM6+Yw+XrLHIF7Nfq9RZcFfvq0TZRPbwEBExBHI5OoGNWwdTNsZjNlzQFKt7LPwkTqY3i9AgtUR4pedszbCpDDE3Fcs0EWwBDuQsAx1TyHW9QX/j+CqyHs2uYD23DjX6KEREfNFeVsLF5Li2Eg9cI7+9FaxmrLKjO74K2Sr84xq6i2qvbXSCT/NlCflTZnA9rTT43OllFd/yzfaJm0yYuV2EWV/x/sVOsoC+BUutODpjnX4YSfrtc+hQnbo0HYFwLvMTdL54QM3WOEGz9hvNmePQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7RRo/1YUFQoiT6BTapw+k1EXTMeb5zN2pVZMx3RRfg=;
 b=eJZjs45yQpKMWH6g7NExJi3ZFua0eYjwJgTSvv1ZbWdKgpJPoqTVEnBTZVm0sTHab/GFfqohirjjWNT3rX4GPCJBcwZN5x6OumRoB5b3MeM8KH7VVUCoQLTsmYxq+GCfylUhBAMn70TETTOTSokCEEIjppdS/RHHUoGoCiNbzNw=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:41:52 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:41:52 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH v2 net-next 03/12] net: atlantic: refactoring pm logic
Thread-Topic: [PATCH v2 net-next 03/12] net: atlantic: refactoring pm logic
Thread-Index: AQHVlbyMEaYHdK+MVU268MvHR4S/ww==
Date:   Thu, 7 Nov 2019 22:41:52 +0000
Message-ID: <2a3fd0c2ae938d549f0c8922cf10b40d570de885.1573158381.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: 18aab357-93b6-4097-6521-08d763d3af1a
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB2295A260761F53D91FD2C540B7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(5024004)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bVzsFIVmwfbk/YgleYG/rC7dhdrXW7rrmIBZwQDMMYLqsH0ypPNbxfY2BElb/JcrbmslUnDa2g9uZKOwLgjACyHWoWkH9eVRUWyyr1wj1y+5GsvKqbc9ZJ9Cz95pjTyu0Nsnq6iKPZs2kT/1t9agrnH/UzRCfpOITLv7bzn8vD7EuamvCiCD/1oFWZxOebsSEIonOlLYWQowXOheQfG5JMdVzVAUHzQZd+Uk3xt+cXugmp1hAVe5eIgs8s2QQSN89HjWU5phAEhDPjS91tNloR3DiqzCbl1tMvemf8l9ifYk1owTTJRqHRWICbjJpdY8uGk7dFMx2t9VCz79ChwjEJ2s30RP6t9BLTbyEdnUU9r170Ihl5rWiO1A4WxiBo+eur27O5SQkb9i9PPaoFKiChyhiJUmaGDa2DfL2iGYEqgMef1EKbHzviobCNXaT7J7
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 18aab357-93b6-4097-6521-08d763d3af1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:41:52.5815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Budmpud12h8cmN08qbIxaR9lImjw0Rl3Nvp1gNmbOi8Qt2L5vPNPuaqwFyDClhAOjt+7VwTvsaGnc9diJjhNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

We now implement .driver.pm callbacks, these
allows driver to work correctly in hibernate
usecases, especially when used in conjunction with
WOL feature.

Before that driver only reacted to legacy .suspend/.resume
callbacks, that was a limitation in some cases.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 38 --------
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  1 -
 .../ethernet/aquantia/atlantic/aq_pci_func.c  | 87 +++++++++++++++++--
 3 files changed, 78 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 75faf288a2fc..d5764228cea5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -1057,44 +1057,6 @@ void aq_nic_free_vectors(struct aq_nic_s *self)
 err_exit:;
 }
=20
-int aq_nic_change_pm_state(struct aq_nic_s *self, pm_message_t *pm_msg)
-{
-	int err =3D 0;
-
-	if (!netif_running(self->ndev)) {
-		err =3D 0;
-		goto out;
-	}
-	rtnl_lock();
-	if (pm_msg->event & PM_EVENT_SLEEP || pm_msg->event & PM_EVENT_FREEZE) {
-		self->power_state =3D AQ_HW_POWER_STATE_D3;
-		netif_device_detach(self->ndev);
-		netif_tx_stop_all_queues(self->ndev);
-
-		err =3D aq_nic_stop(self);
-		if (err < 0)
-			goto err_exit;
-
-		aq_nic_deinit(self, !self->aq_hw->aq_nic_cfg->wol);
-	} else {
-		err =3D aq_nic_init(self);
-		if (err < 0)
-			goto err_exit;
-
-		err =3D aq_nic_start(self);
-		if (err < 0)
-			goto err_exit;
-
-		netif_device_attach(self->ndev);
-		netif_tx_start_all_queues(self->ndev);
-	}
-
-err_exit:
-	rtnl_unlock();
-out:
-	return err;
-}
-
 void aq_nic_shutdown(struct aq_nic_s *self)
 {
 	int err =3D 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.h
index 8c23ad4ddf38..ab3176dfc209 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -157,7 +157,6 @@ int aq_nic_set_link_ksettings(struct aq_nic_s *self,
 			      const struct ethtool_link_ksettings *cmd);
 struct aq_nic_cfg_s *aq_nic_get_cfg(struct aq_nic_s *self);
 u32 aq_nic_get_fw_version(struct aq_nic_s *self);
-int aq_nic_change_pm_state(struct aq_nic_s *self, pm_message_t *pm_msg);
 int aq_nic_update_interrupt_moderation_settings(struct aq_nic_s *self);
 void aq_nic_shutdown(struct aq_nic_s *self);
 u8 aq_nic_reserve_filter(struct aq_nic_s *self, enum aq_rx_filter_type typ=
e);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers=
/net/ethernet/aquantia/atlantic/aq_pci_func.c
index e82c96b50373..3169951fe6ab 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -347,29 +347,98 @@ static void aq_pci_shutdown(struct pci_dev *pdev)
 	}
 }
=20
-static int aq_pci_suspend(struct pci_dev *pdev, pm_message_t pm_msg)
+static int aq_suspend_common(struct device *dev, bool deep)
 {
-	struct aq_nic_s *self =3D pci_get_drvdata(pdev);
+	struct aq_nic_s *nic =3D pci_get_drvdata(to_pci_dev(dev));
+
+	rtnl_lock();
+
+	nic->power_state =3D AQ_HW_POWER_STATE_D3;
+	netif_device_detach(nic->ndev);
+	netif_tx_stop_all_queues(nic->ndev);
=20
-	return aq_nic_change_pm_state(self, &pm_msg);
+	aq_nic_stop(nic);
+
+	if (deep) {
+		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
+		aq_nic_set_power(nic);
+	}
+
+	rtnl_unlock();
+
+	return 0;
 }
=20
-static int aq_pci_resume(struct pci_dev *pdev)
+static int atl_resume_common(struct device *dev, bool deep)
 {
-	struct aq_nic_s *self =3D pci_get_drvdata(pdev);
-	pm_message_t pm_msg =3D PMSG_RESTORE;
+	struct pci_dev *pdev =3D to_pci_dev(dev);
+	struct aq_nic_s *nic;
+	int ret;
+
+	nic =3D pci_get_drvdata(pdev);
+
+	rtnl_lock();
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	if (deep) {
+		ret =3D aq_nic_init(nic);
+		if (ret)
+			goto err_exit;
+	}
+
+	ret =3D aq_nic_start(nic);
+	if (ret)
+		goto err_exit;
+
+	netif_device_attach(nic->ndev);
+	netif_tx_start_all_queues(nic->ndev);
=20
-	return aq_nic_change_pm_state(self, &pm_msg);
+err_exit:
+	rtnl_unlock();
+
+	return ret;
+}
+
+static int aq_pm_freeze(struct device *dev)
+{
+	return aq_suspend_common(dev, false);
 }
=20
+static int aq_pm_suspend_poweroff(struct device *dev)
+{
+	return aq_suspend_common(dev, true);
+}
+
+static int aq_pm_thaw(struct device *dev)
+{
+	return atl_resume_common(dev, false);
+}
+
+static int aq_pm_resume_restore(struct device *dev)
+{
+	return atl_resume_common(dev, true);
+}
+
+const struct dev_pm_ops aq_pm_ops =3D {
+	.suspend =3D aq_pm_suspend_poweroff,
+	.poweroff =3D aq_pm_suspend_poweroff,
+	.freeze =3D aq_pm_freeze,
+	.resume =3D aq_pm_resume_restore,
+	.restore =3D aq_pm_resume_restore,
+	.thaw =3D aq_pm_thaw,
+};
+
 static struct pci_driver aq_pci_ops =3D {
 	.name =3D AQ_CFG_DRV_NAME,
 	.id_table =3D aq_pci_tbl,
 	.probe =3D aq_pci_probe,
 	.remove =3D aq_pci_remove,
-	.suspend =3D aq_pci_suspend,
-	.resume =3D aq_pci_resume,
 	.shutdown =3D aq_pci_shutdown,
+#ifdef CONFIG_PM
+	.driver.pm =3D &aq_pm_ops,
+#endif
 };
=20
 int aq_pci_func_register_driver(void)
--=20
2.17.1

