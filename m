Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3C7486E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 09:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfGYHsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 03:48:08 -0400
Received: from mail-eopbgr760059.outbound.protection.outlook.com ([40.107.76.59]:14926
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387988AbfGYHsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 03:48:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgyHD0Gon2ZbYuCN4hMNDk4jd7wlpZV5U2Njd8QMjdi9LMO1XFCwoGvvkhQtqs9ZBrUnM01RE/8K2NRoaBdhiJ36utLNX2wNtk0d2I6DnobTFq0X4E1DzEbOa0FynXcy6XTCTzDnmKoyj+R0rikEmcogz82Nrx5ZPCQudoqVzwAaP0D5KsRQJSlshkr0wFzZX1YTnHk85bEuryDvKO6ZN0s6BuEEGQg4zGL+Rn0mcNlOR8xk3uEDZC6rQixklNQJ/gzgGJ6rximCzfXaPrN+pYScKoE6D70zQN19BHipFNi+HHOrDE9L5aXmPI2zb1+TBPFHboqRdFYH5ahz+dc7TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsM8VQ0xTqdnKApzDidJKuNiZlYnz4Jl+SqrFE69dZ0=;
 b=VTGOEE8nCyKlc9JKF4l19aVLenff0dCWJGYZYlzmRkbs2GlNdchbCmuvkRDPefXaOGzj78VyiuxJiw8+1YdBo89ki1oqIExAhpv1lYdj+5ktToJJPLJLQUJGPh9/0oxeJrSRoO5ORbKTuEmTKL4+y4wt7d447JWcU61j0P64P/ENLhNArxaMO16yjleguz4jKwlMiWSITkDW1MX9GbFcxEvWO88BrkFooyMJsfEoMPZVm/3NeKM/UzMYiXsV/JCacIHr23/zUUby27Ky3uO/q2sWxqLjZVIFlBeAKOC0suKu4TD83uDChyU9cFhz47vCmcm5G+iMZX0wfCrKh4y2Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synaptics.com;dmarc=pass action=none
 header.from=synaptics.com;dkim=pass header.d=synaptics.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector1-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsM8VQ0xTqdnKApzDidJKuNiZlYnz4Jl+SqrFE69dZ0=;
 b=apZ2uSsKfOdN6t5M87E/GWaGjXx+JCwYnengfnuN5Yb1hgmAjukN/FSWKazdc39yL2jduskq6sXMGW0qWtu+Jt+oel3L/vXl80jyR97ckbz/roAMQkEcmqM5WyPqhN9Pkj8I2cjyTaSD+rPDBpsYc897u7Vp5vTGJq42t00B97g=
Received: from BYAPR03MB4773.namprd03.prod.outlook.com (20.179.92.152) by
 BYAPR03MB3864.namprd03.prod.outlook.com (20.176.254.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 07:48:05 +0000
Received: from BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::b1e6:c114:bea7:6763]) by BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::b1e6:c114:bea7:6763%7]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 07:48:05 +0000
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: mvneta: use devm_platform_ioremap_resource() to
 simplify code
Thread-Topic: [PATCH net-next] net: mvneta: use
 devm_platform_ioremap_resource() to simplify code
Thread-Index: AQHVQr1KREBZw2F/xka/2h+o7XnfwA==
Date:   Thu, 25 Jul 2019 07:48:04 +0000
Message-ID: <20190725153741.095dca99@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.74.246.114]
x-clientproxiedby: TYAPR01CA0024.jpnprd01.prod.outlook.com (2603:1096:404::36)
 To BYAPR03MB4773.namprd03.prod.outlook.com (2603:10b6:a03:134::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jisheng.Zhang@synaptics.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9c5ba3d-a911-4cb2-0bf7-08d710d46d36
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB3864;
x-ms-traffictypediagnostic: BYAPR03MB3864:
x-microsoft-antispam-prvs: <BYAPR03MB386480B038AF0BD1CAA8FE01EDC10@BYAPR03MB3864.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39850400004)(366004)(136003)(376002)(199004)(189003)(478600001)(256004)(476003)(8936002)(81166006)(1076003)(6486002)(50226002)(81156014)(102836004)(2906002)(6506007)(486006)(71200400001)(99286004)(14454004)(6436002)(186003)(71190400001)(53936002)(5660300002)(64756008)(25786009)(9686003)(86362001)(66066001)(386003)(66446008)(26005)(54906003)(8676002)(3846002)(4326008)(110136005)(316002)(7736002)(66946007)(66476007)(6116002)(66556008)(68736007)(305945005)(6512007)(52116002)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3864;H:BYAPR03MB4773.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: synaptics.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nK6Sw5xLABX2nj7RxPeWW+OjyPZ8MHhgKe5ISZgzSgUB16oD97CHZf+ZkJHgWY2az/SPwPKDq1bXYLTLuhAYzOXST8cM7q+XaL5nUCPSvQGpDHS5g5NpVIk0RSVbfNMSqyeb6Xf/EZcz+lEZsKFyd8FReZdiuL116F0DNpmHN7WscKnqKKwxFxoDiLj7kVBwQleOVjZ0vvUANEN0gFpdCuua6DTB1eUazC8SXrzCTabw2qPYhBS6N7eKL0h5g2VL6AN7xmICswsttnRmoBNa3cUzcxftdlW7VPM2RMIPnkbhH0fFS1t12XsT9SMprBT3+6IR4TZJZJD1S00drSIxmUHW3J/7darQa4AKfMq6ArugeG7VZgti57oeABlMzDvHIdvUEH4E5hnwC693hHIt8JgUshSsy1QMRX811aVsZPw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A10877E47AE88F4EA2053740BC0534C7@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c5ba3d-a911-4cb2-0bf7-08d710d46d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 07:48:04.9423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiszha@synaptics.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3864
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_platform_ioremap_resource() wraps platform_get_resource() and
devm_ioremap_resource() in a single helper, let's use that helper to
simplify the code.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 15cc678f5e5b..e49820675c8c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4469,7 +4469,6 @@ static int mvneta_port_power_up(struct mvneta_port *p=
p, int phy_mode)
 /* Device initialization routine */
 static int mvneta_probe(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct device_node *dn =3D pdev->dev.of_node;
 	struct device_node *bm_node;
 	struct mvneta_port *pp;
@@ -4553,8 +4552,7 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (!IS_ERR(pp->clk_bus))
 		clk_prepare_enable(pp->clk_bus);
=20
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	pp->base =3D devm_ioremap_resource(&pdev->dev, res);
+	pp->base =3D devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pp->base)) {
 		err =3D PTR_ERR(pp->base);
 		goto err_clk;
--=20
2.22.0

