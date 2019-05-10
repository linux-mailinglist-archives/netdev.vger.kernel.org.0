Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662211999E
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 10:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfEJIYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 04:24:11 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:25819
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727351AbfEJIYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 04:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuYkKE9Bz5/f8ezob2AHey3cbRutfMWigjnjyzbJGtw=;
 b=BKIkDLgpK9F0vXhYiFZn37R28Hai/Hl/++M15rvboqtwKYEJwqBRtn+pBhLPbXijJ6yctyDOp/mu1IA227pdmYeqllWr4C8Py92q//gtlzXoxSNYg/alDRktRIsoG4mdHs35Psitr1flM+dQYtQSSfAJkO2Tbb16stz0l98NF7g=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2815.eurprd04.prod.outlook.com (10.172.255.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Fri, 10 May 2019 08:24:03 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 08:24:03 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net 2/3] of_net: add property "nvmem-mac-address" for
 of_get_mac_addr()
Thread-Topic: [PATCH net 2/3] of_net: add property "nvmem-mac-address" for
 of_get_mac_addr()
Thread-Index: AQHVBwm64QpngfTPuUW2xDFkk+Lk0w==
Date:   Fri, 10 May 2019 08:24:03 +0000
Message-ID: <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
In-Reply-To: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR02CA0212.apcprd02.prod.outlook.com
 (2603:1096:201:20::24) To VI1PR0402MB3600.eurprd04.prod.outlook.com
 (2603:10a6:803:a::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0595174-25df-4fa1-d30d-08d6d520dc67
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2815;
x-ms-traffictypediagnostic: VI1PR0402MB2815:
x-microsoft-antispam-prvs: <VI1PR0402MB2815144F2DEED94E881B5079FF0C0@VI1PR0402MB2815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(199004)(11346002)(486006)(26005)(6436002)(305945005)(2616005)(6116002)(3846002)(68736007)(316002)(7736002)(386003)(6506007)(6486002)(102836004)(446003)(186003)(2906002)(6916009)(50226002)(54906003)(1730700003)(66066001)(66556008)(36756003)(8676002)(4744005)(66946007)(66476007)(64756008)(76176011)(2351001)(81156014)(476003)(5660300002)(73956011)(86362001)(66446008)(81166006)(14454004)(478600001)(8936002)(25786009)(5640700003)(256004)(6512007)(52116002)(71190400001)(71200400001)(2501003)(53936002)(4326008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2815;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Eh+H8bEND/z/ImbIV04ADauUhcMSSh9DjFvMxWxHGkF8GrCTPTx1MsL++VTzzOF2o+zEz+ShRbJqSWkxIA2Cwkvd7rPraPS87vOSMN3fkBnbdi4CzkL7U2RdGVMypj1eKaiLhgt+zLTMVXpU9cfrWzVxD5Lf/7hWSeyMOaAJeYCledYObhLOKKeGIbAJmSmgDE4iSY/iw2BwztF3eh4Ez0LeM91y4l//Y/MioSt5KpGXkAmr4wO5jEQmvL+tl8q/bGD7PksW2EGFbfDktRrT5Ua35FgZOvs2Me5T14HMOCSo7pRLW12dM00PnNXGuATAKzNy35DEcJoUF1D1e3kX9R7mCbhVEsMgCIijfVuID/c97Tuu+eMZT1+vrxuxTNMEL3qECTfFcmRrHkqNKKKl674CnA1F232KTBbMC+I+XAY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0595174-25df-4fa1-d30d-08d6d520dc67
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 08:24:03.8099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SWYgTUFDIGFkZHJlc3MgcmVhZCBmcm9tIG52bWVtIGNlbGwgYW5kIGl0IGlzIHZhbGlkIG1hYyBh
ZGRyZXNzLA0KLm9mX2dldF9tYWNfYWRkcl9udm1lbSgpIGFkZCBuZXcgcHJvcGVydHkgIm52bWVt
LW1hYy1hZGRyZXNzIiBpbg0KZXRoZXJuZXQgbm9kZS4gT25jZSB1c2VyIGNhbGwgLm9mX2dldF9t
YWNfYWRkcmVzcygpIHRvIGdldCBNQUMNCmFkZHJlc3MgYWdhaW4sIGl0IGNhbiByZWFkIHZhbGlk
IE1BQyBhZGRyZXNzIGZyb20gZGV2aWNlIHRyZWUgaW4NCmRpcmVjdGx5Lg0KDQpTaWduZWQtb2Zm
LWJ5OiBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCi0tLQ0KIGRyaXZlcnMvb2Yv
b2ZfbmV0LmMgfCA0ICsrKysNCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL29mL29mX25ldC5jIGIvZHJpdmVycy9vZi9vZl9uZXQuYw0KaW5k
ZXggOTY0OWNkNS4uNTA3MTI0MSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvb2Yvb2ZfbmV0LmMNCisr
KyBiL2RyaXZlcnMvb2Yvb2ZfbmV0LmMNCkBAIC0xMjUsNiArMTI1LDEwIEBAIGNvbnN0IHZvaWQg
Km9mX2dldF9tYWNfYWRkcmVzcyhzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wKQ0KIAlpZiAoYWRkcikN
CiAJCXJldHVybiBhZGRyOw0KIA0KKwlhZGRyID0gb2ZfZ2V0X21hY19hZGRyKG5wLCAibnZtZW0t
bWFjLWFkZHJlc3MiKTsNCisJaWYgKGFkZHIpDQorCQlyZXR1cm4gYWRkcjsNCisNCiAJcmV0dXJu
IG9mX2dldF9tYWNfYWRkcl9udm1lbShucCk7DQogfQ0KIEVYUE9SVF9TWU1CT0wob2ZfZ2V0X21h
Y19hZGRyZXNzKTsNCi0tIA0KMi43LjQNCg0K
