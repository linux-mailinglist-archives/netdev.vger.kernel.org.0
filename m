Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737342D3C5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfE2C0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:26:12 -0400
Received: from mail-eopbgr810049.outbound.protection.outlook.com ([40.107.81.49]:41024
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfE2C0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector1-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoORN3fFqLBOif3g/fjg3HX3WgE/TkSV2YHWtv10SQU=;
 b=eT/LuyHecbaVheYeKr3+/uq1EG97Paw504JMP/CYgP4tSdH/VZxNuUYidaiMgFSAACO3ykLNOVj3j3vbut38rTS9RyjyDDUICjcpz+NnoqaGXh1ofeBkywRe/5VUSWrjW7amoMywZ4V3wpkBSAJMGqUtsg3x0431EJn2TII1K8I=
Received: from BYAPR03MB4773.namprd03.prod.outlook.com (20.179.92.152) by
 BYAPR03MB4166.namprd03.prod.outlook.com (20.177.184.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Wed, 29 May 2019 02:26:08 +0000
Received: from BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9]) by BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:26:07 +0000
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: stmmac: Switch to devm_alloc_etherdev_mqs
Thread-Topic: [PATCH net-next v2] net: stmmac: Switch to
 devm_alloc_etherdev_mqs
Thread-Index: AQHVFcXfQrQj7OmglEaLnHJdWJkmdw==
Date:   Wed, 29 May 2019 02:26:07 +0000
Message-ID: <20190529101642.294cafd0@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.74.246.114]
x-clientproxiedby: TYCPR01CA0029.jpnprd01.prod.outlook.com
 (2603:1096:405:1::17) To BYAPR03MB4773.namprd03.prod.outlook.com
 (2603:10b6:a03:134::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jisheng.Zhang@synaptics.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2298fc59-b6da-40f2-4b70-08d6e3dd017f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB4166;
x-ms-traffictypediagnostic: BYAPR03MB4166:
x-microsoft-antispam-prvs: <BYAPR03MB4166360E99FC1558BEF26222ED1F0@BYAPR03MB4166.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(486006)(26005)(186003)(316002)(6436002)(86362001)(476003)(9686003)(66066001)(71200400001)(6486002)(14444005)(256004)(71190400001)(1076003)(68736007)(478600001)(81166006)(102836004)(6506007)(386003)(14454004)(99286004)(2906002)(25786009)(110136005)(53936002)(54906003)(4326008)(3846002)(6116002)(72206003)(64756008)(50226002)(52116002)(73956011)(8936002)(7736002)(66946007)(66476007)(66556008)(305945005)(66446008)(5660300002)(8676002)(81156014)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4166;H:BYAPR03MB4773.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: synaptics.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: etZ6yY7RrJlRa7Tq2Mgy66xERDIvM99028NKm99kNFwGsjTuLElpb9tziPIPRulOIvPSA0xHKG5oldmQUwNpNxoVA1jgAgXXuNU4EpHrzYj31N+zM6bvDhzKC5QmKPtUzJNfIpyTPj7IZixf323mYr0S2H1Hgr+63jnSYZgaC6YzOnrvddo+IewmrX3GxCxbuSIOAqxWzVwOMUC2euUB8yQZ85KNvGaDh5+x+ATavVvs8VgYEhgB1rGLB3glOxwyVkgJUpVRpYOHhs1f318ExbAPvykh42SUAWEFOVu02CazjhqiJjv7FwiZpK3EhAVqoNtoEQOZy9Zs4SmATI+tNTeGRm6JvZwcCUl5g15QiDiW375kSQiV3viCTccEDquJrrkcDk1DQaQByrkOVsVLVFFe5oeOVNX8M8GTiwIqaBA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97DB1BCFAFF7BC43912BC947382159D4@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2298fc59-b6da-40f2-4b70-08d6e3dd017f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:26:07.6828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiszha@synaptics.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of devm_alloc_etherdev_mqs() to simplify the code.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
Since V1:
 - fix the build error, sorry, my bad.

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index a87ec70b19f1..4defdcb4f237 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4243,9 +4243,8 @@ int stmmac_dvr_probe(struct device *device,
 	u32 queue, maxq;
 	int ret =3D 0;
=20
-	ndev =3D alloc_etherdev_mqs(sizeof(struct stmmac_priv),
-				  MTL_MAX_TX_QUEUES,
-				  MTL_MAX_RX_QUEUES);
+	ndev =3D devm_alloc_etherdev_mqs(device, sizeof(struct stmmac_priv),
+				       MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES);
 	if (!ndev)
 		return -ENOMEM;
=20
@@ -4277,8 +4276,7 @@ int stmmac_dvr_probe(struct device *device,
 	priv->wq =3D create_singlethread_workqueue("stmmac_wq");
 	if (!priv->wq) {
 		dev_err(priv->device, "failed to create workqueue\n");
-		ret =3D -ENOMEM;
-		goto error_wq;
+		return -ENOMEM;
 	}
=20
 	INIT_WORK(&priv->service_task, stmmac_service_task);
@@ -4434,8 +4432,6 @@ int stmmac_dvr_probe(struct device *device,
 	}
 error_hw_init:
 	destroy_workqueue(priv->wq);
-error_wq:
-	free_netdev(ndev);
=20
 	return ret;
 }
@@ -4472,7 +4468,6 @@ int stmmac_dvr_remove(struct device *dev)
 		stmmac_mdio_unregister(ndev);
 	destroy_workqueue(priv->wq);
 	mutex_destroy(&priv->lock);
-	free_netdev(ndev);
=20
 	return 0;
 }
--=20
2.20.1

