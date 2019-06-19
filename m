Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 329A64B5D0
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 12:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbfFSKCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 06:02:41 -0400
Received: from mail-eopbgr40139.outbound.protection.outlook.com ([40.107.4.139]:6985
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbfFSKCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 06:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHfZV+14xHe30f0MqLVlV0Hb3vH6fw1A7yAiydXQd8E=;
 b=B3sZwkChttaWmxVgIw3+bbl65PHpjfIekHTSt2k8BM1qh0HSObqdGIxMZglPhKnSlQdZO0Pf2GzhLIf+AHAmpFMLEr1vFmp8ND0NWJKo3XXPp66PukD4yEZh6wbdUnIuXHok9ruOWZvbVRUB2rthWyIt3+44YGd6vGBE+9eE9rA=
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM (10.255.30.92) by
 AM0PR10MB2450.EURPRD10.PROD.OUTLOOK.COM (20.177.110.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 10:02:38 +0000
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4c4f:7a8e:cfcc:5d5a]) by AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::4c4f:7a8e:cfcc:5d5a%6]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 10:02:38 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: fix shift of FID bits in
 mv88e6250_g1_vtu_loadpurge()
Thread-Topic: [PATCH net-next] net: dsa: mv88e6xxx: fix shift of FID bits in
 mv88e6250_g1_vtu_loadpurge()
Thread-Index: AQHVJoYgiIx9hVtFtkGo5GdkyURJHw==
Date:   Wed, 19 Jun 2019 10:02:38 +0000
Message-ID: <20190619100224.11848-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR02CA0117.eurprd02.prod.outlook.com
 (2603:10a6:7:29::46) To AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:160::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18548a6a-06a8-4fc3-e8aa-08d6f49d4279
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR10MB2450;
x-ms-traffictypediagnostic: AM0PR10MB2450:
x-microsoft-antispam-prvs: <AM0PR10MB2450161D6B5A3E3CA4FC7A088AE50@AM0PR10MB2450.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(39850400004)(376002)(136003)(199004)(189003)(3846002)(6116002)(5660300002)(25786009)(6436002)(6486002)(8936002)(8976002)(71190400001)(4326008)(71200400001)(53936002)(14444005)(256004)(2906002)(4744005)(6512007)(36756003)(1076003)(99286004)(66556008)(64756008)(66446008)(73956011)(66946007)(305945005)(66066001)(52116002)(74482002)(7736002)(66476007)(81166006)(81156014)(26005)(186003)(14454004)(2616005)(476003)(486006)(102836004)(8676002)(50226002)(6506007)(68736007)(316002)(386003)(44832011)(110136005)(54906003)(42882007)(72206003)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB2450;H:AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uCiRN1thxuix3VDgAJIWrohR/oH1aB6KBgB6JqydSXauW0MCJuocLyp6rrRLgTRxP+K0OGRNJIdT1Hay75ja2JAnJFuhoTSOTchQUO9MZMJZm2Et6L3OzHZyZUpmqa7AafaKSFwQl3fwgd7Yd14ebdYMp+dCsa1++U7HPlsF3qjdP65zJ4o8dBjEU9oNkkc9dJDeQ1NzJsHjMFdU/lVFtihmPzEya9eczxd0hFEUfOGEa/F0sEy+oV3cyKXF2BdLW3eFQFD0HXsbbxSe/6NdE8TJ1TyHl41O+DMFGsDy0b+E080bx4pIKPnBO/6to8B+YSEOH7xzC9zIUnUfyswwMeZWH/MTuILGBSeVup/ULCKLsZ26SA1IOMxOSBYlSWyZSryCCSwdUt/RvnZGnDnWo32haeAu3Z2GpN+Ys8f9ZcY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 18548a6a-06a8-4fc3-e8aa-08d6f49d4279
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 10:02:38.5230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2450
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGNvbW1lbnQgaXMgY29ycmVjdCwgYnV0IHRoZSBjb2RlIGVuZHMgdXAgbW92aW5nIHRoZSBi
aXRzIGZvdXINCnBsYWNlcyB0b28gZmFyLCBpbnRvIHRoZSBWVFVPcCBmaWVsZC4NCg0KRml4ZXM6
IGJlYzhlNTcyNTI4MSAobmV0OiBkc2E6IG12ODhlNnh4eDogaW1wbGVtZW50IHZ0dV9nZXRuZXh0
IGFuZCB2dHVfbG9hZHB1cmdlIGZvciBtdjg4ZTYyNTApDQpTaWduZWQtb2ZmLWJ5OiBSYXNtdXMg
VmlsbGVtb2VzIDxyYXNtdXMudmlsbGVtb2VzQHByZXZhcy5kaz4NCi0tLQ0KIGRyaXZlcnMvbmV0
L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xv
YmFsMV92dHUuYw0KaW5kZXggNDUwNDBmOTYzMTQyLi40ZjdiNTIyZTVlNTkgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMNCisrKyBiL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYw0KQEAgLTQ0NCw3ICs0NDQsNyBAQCBpbnQg
bXY4OGU2MjUwX2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0K
IAkJICogVlRVIERCTnVtWzU6NF0gYXJlIGxvY2F0ZWQgaW4gVlRVIE9wZXJhdGlvbiA5OjgNCiAJ
CSAqLw0KIAkJb3AgfD0gZW50cnktPmZpZCAmIDB4MDAwZjsNCi0JCW9wIHw9IChlbnRyeS0+Zmlk
ICYgMHgwMDMwKSA8PCA4Ow0KKwkJb3AgfD0gKGVudHJ5LT5maWQgJiAweDAwMzApIDw8IDQ7DQog
CX0NCiANCiAJcmV0dXJuIG12ODhlNnh4eF9nMV92dHVfb3AoY2hpcCwgb3ApOw0KLS0gDQoyLjIw
LjENCg0K
