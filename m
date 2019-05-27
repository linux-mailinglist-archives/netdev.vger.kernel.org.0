Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A89F2B310
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 13:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfE0LRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 07:17:39 -0400
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:48973
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725814AbfE0LRi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 07:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector1-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gG629QXx8FdyEOPr9ywHpRzo7CmvFkkUA0RLj7yTFGo=;
 b=ErWdXyGsZI8rrf/LELXu4VLzktWyg1B7suCT6KHUyRq9y5c6NBWCtL27tOEKmRHB7ILp1iZFZv5eZhV9TZ6+nxCBzMLIVxIWrWaD3YqXcWxYRumXfejaY+erY6quCY2mH6XnzB3zPBzN9lGpxQXKjSqXBlSStRSQ6ME6JozvNJ4=
Received: from BYAPR03MB4773.namprd03.prod.outlook.com (20.179.92.152) by
 BYAPR03MB4758.namprd03.prod.outlook.com (20.179.92.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Mon, 27 May 2019 11:17:34 +0000
Received: from BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9]) by BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9%7]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 11:17:34 +0000
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: stmmac: Switch to devm_alloc_etherdev_mqs
Thread-Topic: [PATCH net-next] net: stmmac: Switch to devm_alloc_etherdev_mqs
Thread-Index: AQHVFH3IrxvNh8wfqUaLjPCBqcAB3A==
Date:   Mon, 27 May 2019 11:17:34 +0000
Message-ID: <20190527190833.5955c851@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.74.246.114]
x-clientproxiedby: TYAPR03CA0017.apcprd03.prod.outlook.com
 (2603:1096:404:14::29) To BYAPR03MB4773.namprd03.prod.outlook.com
 (2603:10b6:a03:134::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jisheng.Zhang@synaptics.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15017929-6127-4655-ec1c-08d6e294ea97
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB4758;
x-ms-traffictypediagnostic: BYAPR03MB4758:
x-microsoft-antispam-prvs: <BYAPR03MB475863B39DD3E1C0923BF2B3ED1D0@BYAPR03MB4758.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:457;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(346002)(366004)(136003)(39860400002)(189003)(199004)(99286004)(476003)(68736007)(486006)(86362001)(71200400001)(1076003)(6486002)(71190400001)(305945005)(5660300002)(14454004)(102836004)(7736002)(6436002)(316002)(256004)(14444005)(186003)(26005)(66476007)(4326008)(73956011)(2906002)(386003)(6506007)(66556008)(64756008)(66946007)(110136005)(66446008)(54906003)(25786009)(478600001)(8676002)(6116002)(81166006)(81156014)(50226002)(72206003)(8936002)(52116002)(3846002)(66066001)(6512007)(53936002)(9686003)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4758;H:BYAPR03MB4773.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: synaptics.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YqpdWlhULodD0JEhUASUU2DASiZ3Q9iLNtkVS8LlgyHRzlkZr25pubPjLKlb3AV5KPJL5xqUJzBr9Yib5jG690rYw1VreCt1TWFqtYdu0ebGt6z7UvD44ip8eMfBb4mLz8eHv/3up6Md8xbkP0kCJD38IvnR9XArvtojmw4L/LvUhXUPayGBGDi+bn47aBLgD1pY/wL/upUEgRnLzRT5zC4Vzrsaf7q236w/1IkLF0FdXlfQlsU6vQAjJssu5DHACzZ8PGNtzmmNbfLXdD+OA75C7C+dtuZ+0oq0whiEej5xu+znMgpq0AmMgGyvBfyGVa62ab72DvndYl3KycstL6uXTWsyd0cizYtIqntBEmLrdjQRiQGEcaeD33cYVNSatbBYDzgcWNcvwrJgAJ3aRxZRc9ot2fKV+IxjfaR/CbE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97DBF27A6D764C4EB47AE73D4219A661@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15017929-6127-4655-ec1c-08d6e294ea97
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 11:17:34.2143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiszha@synaptics.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4758
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of devm_alloc_etherdev_mqs() to simplify the code.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_main.c
index a87ec70b19f1..08022fbcb67a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4243,9 +4243,9 @@ int stmmac_dvr_probe(struct device *device,
 	u32 queue, maxq;
 	int ret =3D 0;
=20
-	ndev =3D alloc_etherdev_mqs(sizeof(struct stmmac_priv),
-				  MTL_MAX_TX_QUEUES,
-				  MTL_MAX_RX_QUEUES);
+	ndev =3D devm_alloc_etherdev_mqs(sizeof(struct stmmac_priv),
+				       MTL_MAX_TX_QUEUES,
+				       MTL_MAX_RX_QUEUES);
 	if (!ndev)
 		return -ENOMEM;
=20
@@ -4277,8 +4277,7 @@ int stmmac_dvr_probe(struct device *device,
 	priv->wq =3D create_singlethread_workqueue("stmmac_wq");
 	if (!priv->wq) {
 		dev_err(priv->device, "failed to create workqueue\n");
-		ret =3D -ENOMEM;
-		goto error_wq;
+		return -ENOMEM;
 	}
=20
 	INIT_WORK(&priv->service_task, stmmac_service_task);
@@ -4434,8 +4433,6 @@ int stmmac_dvr_probe(struct device *device,
 	}
 error_hw_init:
 	destroy_workqueue(priv->wq);
-error_wq:
-	free_netdev(ndev);
=20
 	return ret;
 }
@@ -4472,7 +4469,6 @@ int stmmac_dvr_remove(struct device *dev)
 		stmmac_mdio_unregister(ndev);
 	destroy_workqueue(priv->wq);
 	mutex_destroy(&priv->lock);
-	free_netdev(ndev);
=20
 	return 0;
 }
--=20
2.20.1

