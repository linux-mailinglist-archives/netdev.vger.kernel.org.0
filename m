Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4628221F0B
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfEQUUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:20:13 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729354AbfEQUUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1HY0e+BL/2B38yZ+wtW68dnNOtR77s/wW+mnZ2eaMk=;
 b=Gfbrg4yTUIDwcsU8tH8BAGIrJRNQp5ixDsW9YsiTmUhNEvQUrmRgYKeSTz2wVAexp/OaxqJq6ldwYehDCzGvX52BMbdC2fP/Ll94sm9xMikW2+WTgYHRLeqP9Rz6gKRpkPBgU97V2H9hF/tkdUN4ss8N84LtJgf7btwUX8XlZ/Q=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:20:01 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:20:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/11] net/mlx5e: Fix no rewrite fields with the same match
Thread-Topic: [net 10/11] net/mlx5e: Fix no rewrite fields with the same match
Thread-Index: AQHVDO3nSZAF93G3xkak5gdbXIllzw==
Date:   Fri, 17 May 2019 20:20:01 +0000
Message-ID: <20190517201910.32216-11-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9273ffe-074a-4219-fa11-08d6db0509ba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB613822CAB60808B342E1C944BE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:104;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YrtMYJTrnHPw/MiCIZhIbfjs9eJP+fzR4pkZ8tjhmpG/YJRQw8XetkFm+FgGrfNbJ/GQRSgLHRojoLTLFWMqEWe8gidjN+rehCu/wDAazfqR2s9regIHyL4nMqaNmlJ723EFnVDa4EYoloj1dTZD3KO/TTQC7usFcCaf8SBugs90EPNVGG9J93QaoHnCW1xDq9EJsQuPI5VjBBLX1blU4qmZD09Sc3VdXz8P341aiAKTZ8Uqp/BLsOWU49Jsi0EKWDbHTQfOUy2bssUaWI+KXEx4bnzw2f4Xuc/BIaydHx2+lO6bQ+Cd8f8mTP7Ay7crbn4qHoG9SZyZlXhlgFwt7+XlofOR7zi8noxQoS5XH+mhfNGZUgEwv76x9WSa7CoWqjzcgpkF7/OyyhwvfZm87klgGIUJyWr84HDsTrPohz0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9273ffe-074a-4219-fa11-08d6db0509ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:20:01.4085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpXaXRoIGNvbW1pdCAy
N2MxMWI2Yjg0NGMgKCJuZXQvbWx4NWU6IERvIG5vdCByZXdyaXRlIGZpZWxkcyB3aXRoIHRoZQ0K
c2FtZSBtYXRjaCIpIHRoZXJlIGFyZSBubyByZXdyaXRlcyBpZiB0aGUgcmV3cml0ZSB2YWx1ZSBp
cyB0aGUgc2FtZSBhcw0KdGhlIG1hdGNoZWQgdmFsdWUuIEhvd2V2ZXIsIGlmIHRoZSBmaWVsZCBp
cyBub3QgbWF0Y2hlZCwgdGhlIHJld3JpdGUgaXMNCmFsc28gd3JvbmdseSBza2lwcGVkLiBGaXgg
aXQuDQoNCkZpeGVzOiAyN2MxMWI2Yjg0NGMgKCJuZXQvbWx4NWU6IERvIG5vdCByZXdyaXRlIGZp
ZWxkcyB3aXRoIHRoZSBzYW1lIG1hdGNoIikNClNpZ25lZC1vZmYtYnk6IEVsaSBCcml0c3RlaW4g
PGVsaWJyQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFu
b3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5j
b20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jICAg
fCAyMiArKysrKysrKysrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMo
KyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl90Yy5jDQppbmRleCA1NDIzNTRiNWViNGQuLjQ3MjJhYzcwZjBhOSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5j
DQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0K
QEAgLTE5MTYsNiArMTkxNiwxOSBAQCBzdHJ1Y3QgbWx4NV9maWVsZHMgew0KIAkJIG9mZnNldG9m
KHN0cnVjdCBwZWRpdF9oZWFkZXJzLCBmaWVsZCkgKyAob2ZmKSwgXA0KIAkJIE1MWDVfQllURV9P
RkYoZnRlX21hdGNoX3NldF9seXJfMl80LCBtYXRjaF9maWVsZCl9DQogDQorLyogbWFza2VkIHZh
bHVlcyBhcmUgdGhlIHNhbWUgYW5kIHRoZXJlIGFyZSBubyByZXdyaXRlcyB0aGF0IGRvIG5vdCBo
YXZlIGENCisgKiBtYXRjaC4NCisgKi8NCisjZGVmaW5lIFNBTUVfVkFMX01BU0sodHlwZSwgdmFs
cCwgbWFza3AsIG1hdGNodmFscCwgbWF0Y2htYXNrcCkgKHsgXA0KKwl0eXBlIG1hdGNobWFza3gg
PSAqKHR5cGUgKikobWF0Y2htYXNrcCk7IFwNCisJdHlwZSBtYXRjaHZhbHggPSAqKHR5cGUgKiko
bWF0Y2h2YWxwKTsgXA0KKwl0eXBlIG1hc2t4ID0gKih0eXBlICopKG1hc2twKTsgXA0KKwl0eXBl
IHZhbHggPSAqKHR5cGUgKikodmFscCk7IFwNCisJXA0KKwkodmFseCAmIG1hc2t4KSA9PSAobWF0
Y2h2YWx4ICYgbWF0Y2htYXNreCkgJiYgIShtYXNreCAmIChtYXNreCBeIFwNCisJCQkJCQkJCSBt
YXRjaG1hc2t4KSk7IFwNCit9KQ0KKw0KIHN0YXRpYyBib29sIGNtcF92YWxfbWFzayh2b2lkICp2
YWxwLCB2b2lkICptYXNrcCwgdm9pZCAqbWF0Y2h2YWxwLA0KIAkJCSB2b2lkICptYXRjaG1hc2tw
LCBpbnQgc2l6ZSkNCiB7DQpAQCAtMTkyMywxNiArMTkzNiwxMyBAQCBzdGF0aWMgYm9vbCBjbXBf
dmFsX21hc2sodm9pZCAqdmFscCwgdm9pZCAqbWFza3AsIHZvaWQgKm1hdGNodmFscCwNCiANCiAJ
c3dpdGNoIChzaXplKSB7DQogCWNhc2Ugc2l6ZW9mKHU4KToNCi0JCXNhbWUgPSAoKCoodTggKil2
YWxwKSAmICgqKHU4ICopbWFza3ApKSA9PQ0KLQkJICAgICAgICgoKih1OCAqKW1hdGNodmFscCkg
JiAoKih1OCAqKW1hdGNobWFza3ApKTsNCisJCXNhbWUgPSBTQU1FX1ZBTF9NQVNLKHU4LCB2YWxw
LCBtYXNrcCwgbWF0Y2h2YWxwLCBtYXRjaG1hc2twKTsNCiAJCWJyZWFrOw0KIAljYXNlIHNpemVv
Zih1MTYpOg0KLQkJc2FtZSA9ICgoKih1MTYgKil2YWxwKSAmICgqKHUxNiAqKW1hc2twKSkgPT0N
Ci0JCSAgICAgICAoKCoodTE2ICopbWF0Y2h2YWxwKSAmICgqKHUxNiAqKW1hdGNobWFza3ApKTsN
CisJCXNhbWUgPSBTQU1FX1ZBTF9NQVNLKHUxNiwgdmFscCwgbWFza3AsIG1hdGNodmFscCwgbWF0
Y2htYXNrcCk7DQogCQlicmVhazsNCiAJY2FzZSBzaXplb2YodTMyKToNCi0JCXNhbWUgPSAoKCoo
dTMyICopdmFscCkgJiAoKih1MzIgKiltYXNrcCkpID09DQotCQkgICAgICAgKCgqKHUzMiAqKW1h
dGNodmFscCkgJiAoKih1MzIgKiltYXRjaG1hc2twKSk7DQorCQlzYW1lID0gU0FNRV9WQUxfTUFT
Syh1MzIsIHZhbHAsIG1hc2twLCBtYXRjaHZhbHAsIG1hdGNobWFza3ApOw0KIAkJYnJlYWs7DQog
CX0NCiANCi0tIA0KMi4yMS4wDQoNCg==
