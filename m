Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF0D1478F7
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 08:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgAXH0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 02:26:39 -0500
Received: from mail-eopbgr80098.outbound.protection.outlook.com ([40.107.8.98]:30017
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725817AbgAXH0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 02:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjUmjULqipBiuHryiMHT2UmxlEjveiYC2ai+e48/BrDJyu3iz/cVddNxf/Uzaoiwer2YzFnRfF1zZlO+TWdgyrcaGzmH9yYsm+BWsnm0KAKBG2WewWyiOw2hXsXGB0vnQlS3dvpjW1/ZMQSJ+1b6ZhpFIyXoIGshcnScQ1ecDHYzSBLop2KaC6jj9fmUdzGwnzAcVnM5Mqu6FeZt2YRo/rOPgApoaZMATxErIzUtk0+3ytQG/+m89090OH4+Z4zYKQXgraqJkGFhYeRohb0Y70jxJB2S2puja1/EtPvlgSsFe8FsxIxyaXVDmcP7vkMM3/Rit41IxDtUREUHHRMxJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ir33Kbp611F0E8ovc9BxUa74nsSDgeDXvsBIJB+9ggg=;
 b=AAHta08htZA7ntB+Ykomzi5GfYhx9jAIENaXsTXJvLmIEbp/c1S0Zp8Igamf2fP92Gkt9sV44ERGbW2ZJpCOnDrUSM6br+ILuO1WW/rjE5CNxEnGcKUSyTIrjwap2Wh2WF4EVaI5GnncozFS8xK1L/wBljVU8YYivgKAaqGVzR3xC4xsTvfV6hX2Ibvzdy1AMLs1OdL/28qjBQScqSSptgOTL3WDUgJ6QH5cbM8J5Em3LMIQ+2oWE/cVTLNJSBuRPWF/s+ywrsJuO0pfk048g14gNUxWNksmfFGe5GQ0lfnwzS8Hm8Q+vA1fFwtX7/iApRRcvROzyLNYFqDipWlDnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ir33Kbp611F0E8ovc9BxUa74nsSDgeDXvsBIJB+9ggg=;
 b=ljQsiz7885rahtHpC7//eqtXsg7eP76tkyeDYdQFUaAm/psBzogwaEbLUgayDcTMKZ6cGr/PR2p9c8yDEyBRbjp4QsgFFvwWXOz6i6BO8FKUs4PZ5j/nypKH2t9WLYxhq1XDnmmiPcx1dlkvOcSmcQa7phU9Ms5BUy78uXPbqT8=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB4739.eurprd05.prod.outlook.com (52.133.54.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 07:26:34 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 07:26:34 +0000
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM0PR06CA0011.eurprd06.prod.outlook.com (2603:10a6:208:ab::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 07:26:30 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: [PATCH v4] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v4] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV0oebTsKeFqWhwESpvZKN+FWHow==
Date:   Fri, 24 Jan 2020 07:26:34 +0000
Message-ID: <20200124072628.75245-1-sven.auhagen@voleatech.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.1 (Apple Git-122.3)
x-clientproxiedby: AM0PR06CA0011.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::24) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [78.43.2.70]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24ba2fb8-a89f-488d-40dd-08d7a09ebdd7
x-ms-traffictypediagnostic: AM0PR05MB4739:|AM0PR05MB4739:
x-microsoft-antispam-prvs: <AM0PR05MB47391EA7ECB0497F96E23579EF0E0@AM0PR05MB4739.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39830400003)(346002)(396003)(376002)(366004)(189003)(199004)(6486002)(26005)(6506007)(54906003)(8936002)(81166006)(81156014)(2906002)(6512007)(956004)(186003)(2616005)(16526019)(52116002)(8676002)(316002)(4326008)(107886003)(86362001)(66446008)(66476007)(6916009)(4744005)(66556008)(64756008)(1076003)(66946007)(71200400001)(36756003)(5660300002)(44832011)(508600001)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB4739;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zy1/pySAj/KZDcoe1MzAPwD9sDr8gTyJOvZvgCqqnxT3n8O8Q1dKAic1hBzbk5SYN0Svv9SA3FEgL7ATIFp7RUqYFp6aUO81ZiLWtXJAWWMN+VweUJa4dJwIqzEoYa7U0FajrqySa4cr8A/A1cg5xySaLcd+6lQbmH/zg2M1dcIjEVm8i4212n9hrFfC5tERpXjdSwnUDw2TfNU3QEAm8BjwK4kTK+uR+t5m7yNN8giYkC2yb8J8d18bsi5MmTQEyU5CZhSC/UFn8yc4Uxd+jo5eoc56JPLu9p9l6twMYjlVcOv/rnWHEAb2OIuNicYufAAtzF0AnSs31JAWO4gbKmSTSrzVHiVi5osZMY5mQdSz1HYGUqWZ3xuSPylKOrfpuSDLVOE3W9i/LybyuUjQd4QYFTxMFxdw+hXgy7qM/vtA5O8qaU970QxeN2RCK5tXaXJJU7c17b8SNp/1fvinzF54JP1HiX+Y63VlT1TX/PKQUV93UXH2c5ApscfRAS37
x-ms-exchange-antispam-messagedata: Ct1mJvE4xqXk4l5UHzKSUJ9iy7cZGf5o+0+KgdDoG7i2511gWTAqDDdE6O0jWss3pQezoro0U6rVv8tAqT7k/PbXfoburJR/QIVWafqiLQaDoAClpcY5IkfMcUeM30ubJs+TJgYUWw4RGshMvOqorQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ba2fb8-a89f-488d-40dd-08d7a09ebdd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 07:26:34.7991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vp5p1kMKk0N59acIX5ZoDa/nNT76K/Ug+Zky/9TXk6xg8+SCsVb1+W0cbaqS+8DDA7A6BjddVHrh+CX6ZTbLSeBdW5IxWy8qqmP4PGdSrAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently XDP Support was added to the mvneta driver
for software buffer management only.
It is still possible to attach an XDP program if
hardware buffer management is used.
It is not doing anything at that point.

The patch disallows attaching XDP programs to mvneta
if hardware buffer management is used.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 71a872d46bc4..96593b9fbd9b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4225,6 +4225,12 @@ static int mvneta_xdp_setup(struct net_device *dev, =
struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
=20
+		if (pp->bm_priv) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Hardware Buffer Management not supported on XDP");
+			return -EOPNOTSUPP;
+		}
+
 	need_update =3D !!pp->xdp_prog !=3D !!prog;
 	if (running && need_update)
 		mvneta_stop(dev);
