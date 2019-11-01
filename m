Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4341EEC28B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfKAMRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:23 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729098AbfKAMRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CApIh001185;
        Fri, 1 Nov 2019 05:17:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=F6V5Th3tGsDSPquEnOJCukWyrPY0loxMehzkrnWT/+Y=;
 b=hCNjwlmKPAEjaY8Hbuq2R80jfwFIcC+pjcQpyQb4b7WWUr003ucV0A7m3+bLP0VBDAc3
 xE3cKaJfk7o8NtoFzlOmbGQZyvh/M766tKmWpwEj91iQrJy7ws+PS4JUDQrpkE5BA2Q+
 HbSwTZcq0IkKM6mcTfrutCjVUWipxJKDY1+bnCrq+VtgyPc9zWXZFDyLG7aenkEO7Rzf
 uNZFXvWOo93QA1vw95WkG8EBOrn5v4r79Y0u0uoMHa4fKnzIvhsnw+rL3ipkGyPeiRRW
 5pAGOwCX6RpxW9D6i5jeXCM1YspKvY3tDZzbmsAz0uu+qwNWTyKp39pCL8fdl2W+T15T Ow== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2vxwjmbtkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:21 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:20 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAD/W8ugwmN1N7hcMMcSGdZDqprf27ZbMIDjPkSmr0fGqTsQ1hl6rtTZphYQwrVkfu6bYaaiEPiTF2bpjjvo+RuJeqxH89tEPUqu3HKrYOqdaTltNHtPvxAVLLfADbYfdJqeXJbI10Qf1wv6WMJnjcQsgXUse8fOxR9RXZb/SKNPf6Cdq5P/cu9IwkIWEdyP0phuIbNoqQEfWehcGs9LWlUS7O26DdDoYGG2tNoN32mLtVa8y90uh0GYL3mRZIDiSYkA5MQxU4nTReMbzoG0B3r25Fzy8518vthiPlQYIk+XNygn4q/ExpfB97EcSCiN8OI8ilVhLtSJDxdHNyCHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6V5Th3tGsDSPquEnOJCukWyrPY0loxMehzkrnWT/+Y=;
 b=ZarPnBjgk+cAZsD63geGmzxMMn7btpUxRPSZAGX2Jc35GOEGncGuQZWTQwGVn2UOum3mTZymXlpKeQE9+lmIqKRcf4UD665P+/qewmzGcYMj7Munb3y9RDlHZa/O1eGlWptdLj9ZsAKLDi/BiGvZ6PWC9YjTosgU+7FNLHGuEXfRzw4qhqjANjN0Dj+PSTmZ0Yl7lYkdyAiCsxYauplCfNkyZytNtDeTiu0JDY90FzeZjv4wuViaxoyhPExYOWoGj3Jd6nj6ny5ZhzuBU4Sgre7HJtaNAjQhP8rlTWBN1iN1/RYRkiSDhownsNfMfKeMX6IQHKyD+mrLbXZsQfmbkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6V5Th3tGsDSPquEnOJCukWyrPY0loxMehzkrnWT/+Y=;
 b=hwmhc7Z/l4a84ntM32A3cFgQdy/qHvDLiVMz4naSXp4qOC6c0WTdllYAfhvTprmFF2Yd3DbPnfGjnsajg+lk+U4KA4XDFv4mh5GUxWsy4g9PH0VZPA9SnHI6T6AGPEXodzV6gEDQs4obO2FYqgkKVenvVpTYe66SimI7PUsuRdo=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:16 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:16 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Subject: [PATCH net-next 03/12] net: atlantic: refactoring pm logic
Thread-Topic: [PATCH net-next 03/12] net: atlantic: refactoring pm logic
Thread-Index: AQHVkK5M3d5WZArY3U6mMUmzv+MPMg==
Date:   Fri, 1 Nov 2019 12:17:16 +0000
Message-ID: <f7a1c4805413b5aa808881da5698aebd395739c0.1572610156.git.irusskikh@marvell.com>
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
x-ms-office365-filtering-correlation-id: df0bf76b-4c97-4efa-e925-08d75ec56f31
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB230674EEAA8C5B070F402E78B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(5024004)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TdVunAZGaHZxPsl7Evb1lrA0qDhBrvj1ywCyXtiifnKq7MLvwEBsecPhFVNCqw+rxtjADz0h85sXvX1z/0Tu+zehRQtqJfqnGRNj5bauhtX3ffEGqO8TL4E57O6V8jBn3E9VTBfIXbq18kXyau/WKrXbRBwCFHBx3ISqypOlpd/LHE+85TKuIvPCHs7Ie1dw5k19naQZhEc8DchZf2vhFGFiTsTYeqQNegJyJR397/kUfQIxKtVSCn4EfbXKGEvmDn6/wOTYyXsUmHiAm8y0ehVkPRQtnyzLuXajoIByIZCzDBAEYjdEKDvf4B+L0Kv9ZPWg9gg4uiBH76/L1MZd0oy7RDQgchqHpximZX4hSwqo309KWZ4Fo1Ch+9gh8X4CNkNw1fxhLvDFXhOFSoIBhrEmy49+U0iIFddBKyFHERW6Eb91d5r9mTN/SNEcJae
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: df0bf76b-4c97-4efa-e925-08d75ec56f31
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:16.5793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aVD0YfeRqBCki0riTiedgNStY6IzN2c1FwVL6IiButg9/jyyMsgngWmiyAVsjhDxr6+pgWAsXXDEeuEF/7RbeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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
 .../ethernet/aquantia/atlantic/aq_pci_func.c  | 86 +++++++++++++++++--
 3 files changed, 77 insertions(+), 48 deletions(-)

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
index e82c96b50373..1c54424e4c42 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -347,29 +347,97 @@ static void aq_pci_shutdown(struct pci_dev *pdev)
 	}
 }
=20
-static int aq_pci_suspend(struct pci_dev *pdev, pm_message_t pm_msg)
+static int aq_suspend_common(struct device *dev, bool deep)
 {
-	struct aq_nic_s *self =3D pci_get_drvdata(pdev);
+	struct pci_dev *pdev =3D to_pci_dev(dev);
+	struct aq_nic_s *nic =3D pci_get_drvdata(pdev);
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
+	struct aq_nic_s *nic =3D pci_get_drvdata(pdev);
+	int ret;
=20
-	return aq_nic_change_pm_state(self, &pm_msg);
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
+
+err_exit:
+	rtnl_unlock();
+
+	return ret;
+}
+
+static int aq_pm_freeze(struct device *dev)
+{
+	return aq_suspend_common(dev, false);
+}
+
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
 }
=20
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

