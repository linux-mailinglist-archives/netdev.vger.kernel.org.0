Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9BB621F08
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfEQUUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:20:03 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbfEQUUC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KSsgklGekdDHrLHaGmMIlB/HYnPtDw+Iu716FfySqS4=;
 b=O3oEHz/RYp7ZeBRAnkk/w4kvcpbRXPxMTXY0sZYntaWdU0qzEeZsfjU8gb0jDWckXXgZ11EoFv3zLwnFh+Zl+eZSyq+OcD0Hqjop8tA90GkjuQDZ8jGGyh72mFIsv0GYRUKqy/RgpPuwxuCI2/fp9D6IWMpd/UM2uQcBIm1gP70=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:53 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/11] net/mlx5e: Fix number of vports for ingress ACL
 configuration
Thread-Topic: [net 07/11] net/mlx5e: Fix number of vports for ingress ACL
 configuration
Thread-Index: AQHVDO3jSGMG8gMO7kSHFFvTS7+L7A==
Date:   Fri, 17 May 2019 20:19:53 +0000
Message-ID: <20190517201910.32216-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5075ef7a-de4f-437e-fd7c-08d6db0504ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB61386929B525FCDE646C42AABE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:348;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EBV/nY9LvRNhEMui2sTW9bOTllfZxh9eIZoqRY4ldvhghBEE/ImKWJAljmybdE/RPrqbc6v5TrBn6/M0DduIOVDI+pik/oT6gB2eKJyOovvUyqYi+sHFzLEiENGSemu+LmoYdmK36UaVunZKWh39Z/Ufm6eWZxbq9v+LgeFc3bugAFyNaS93Q4Cx30oOxUyilY8nI6GsRuJlk5XkWI10pDYwc60LSqhKX7yrosvTaxzsdxSyQqV00Gcyx74vF7MUSxHbBnu0FJFuirIjDqEYPN41+1m5omjzAabVWJQORtj89jsPc+TQ4A4KThNeHr8HwfSqnzWh0uimiJDsQN3Z+o8FX7MuJdcLEsSCmwLjxm5Zd1IY7pQm6eyt8QLU863cknUZlC196jjNtgaMpel/Cz4aNxIlCQHrUaTd5VqTZM4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5075ef7a-de4f-437e-fd7c-08d6db0504ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:53.8391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpXaXRoIHRoZSBjaXRl
ZCBjb21taXQsIEFDTHMgYXJlIGNvbmZpZ3VyZWQgZm9yIHRoZSBWRiBwb3J0cy4gVGhlIGxvb3AN
CmZvciB0aGUgbnVtYmVyIG9mIHBvcnRzIGhhZCB0aGUgd3JvbmcgbnVtYmVyLiBGaXggaXQuDQoN
CkZpeGVzOiAxODQ4NjczNzNkOGMgKCJuZXQvbWx4NWU6IEFDTHMgZm9yIHByaW9yaXR5IHRhZyBt
b2RlIikNClNpZ25lZC1vZmYtYnk6IEVsaSBCcml0c3RlaW4gPGVsaWJyQG1lbGxhbm94LmNvbT4N
ClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiAuLi4vbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgICB8IDkgKysrKyst
LS0tDQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoX29mZmxvYWRzLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZXN3aXRjaF9vZmZsb2Fkcy5jDQppbmRleCAyMDYwNDU2ZGRjZDAuLjQ3YjQ0NmQzMGY3MSAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNo
X29mZmxvYWRzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lc3dpdGNoX29mZmxvYWRzLmMNCkBAIC0xNzMyLDEzICsxNzMyLDE0IEBAIHN0YXRpYyB2b2lk
IGVzd19wcmlvX3RhZ19hY2xzX2NsZWFudXAoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIAlz
dHJ1Y3QgbWx4NV92cG9ydCAqdnBvcnQ7DQogCWludCBpOw0KIA0KLQltbHg1X2Vzd19mb3JfZWFj
aF92Zl92cG9ydChlc3csIGksIHZwb3J0LCBlc3ctPm52cG9ydHMpIHsNCisJbWx4NV9lc3dfZm9y
X2VhY2hfdmZfdnBvcnQoZXN3LCBpLCB2cG9ydCwgZXN3LT5kZXYtPnByaXYuc3Jpb3YubnVtX3Zm
cykgew0KIAkJZXN3X3Zwb3J0X2Rpc2FibGVfZWdyZXNzX2FjbChlc3csIHZwb3J0KTsNCiAJCWVz
d192cG9ydF9kaXNhYmxlX2luZ3Jlc3NfYWNsKGVzdywgdnBvcnQpOw0KIAl9DQogfQ0KIA0KLXN0
YXRpYyBpbnQgZXN3X29mZmxvYWRzX3N0ZWVyaW5nX2luaXQoc3RydWN0IG1seDVfZXN3aXRjaCAq
ZXN3LCBpbnQgbnZwb3J0cykNCitzdGF0aWMgaW50IGVzd19vZmZsb2Fkc19zdGVlcmluZ19pbml0
KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywgaW50IHZmX252cG9ydHMsDQorCQkJCSAgICAgIGlu
dCBudnBvcnRzKQ0KIHsNCiAJaW50IGVycjsNCiANCkBAIC0xNzQ2LDcgKzE3NDcsNyBAQCBzdGF0
aWMgaW50IGVzd19vZmZsb2Fkc19zdGVlcmluZ19pbml0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVz
dywgaW50IG52cG9ydHMpDQogCW11dGV4X2luaXQoJmVzdy0+ZmRiX3RhYmxlLm9mZmxvYWRzLmZk
Yl9wcmlvX2xvY2spOw0KIA0KIAlpZiAoTUxYNV9DQVBfR0VOKGVzdy0+ZGV2LCBwcmlvX3RhZ19y
ZXF1aXJlZCkpIHsNCi0JCWVyciA9IGVzd19wcmlvX3RhZ19hY2xzX2NvbmZpZyhlc3csIG52cG9y
dHMpOw0KKwkJZXJyID0gZXN3X3ByaW9fdGFnX2FjbHNfY29uZmlnKGVzdywgdmZfbnZwb3J0cyk7
DQogCQlpZiAoZXJyKQ0KIAkJCXJldHVybiBlcnI7DQogCX0NCkBAIC0xODM5LDcgKzE4NDAsNyBA
QCBpbnQgZXN3X29mZmxvYWRzX2luaXQoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LCBpbnQgdmZf
bnZwb3J0cywNCiB7DQogCWludCBlcnI7DQogDQotCWVyciA9IGVzd19vZmZsb2Fkc19zdGVlcmlu
Z19pbml0KGVzdywgdG90YWxfbnZwb3J0cyk7DQorCWVyciA9IGVzd19vZmZsb2Fkc19zdGVlcmlu
Z19pbml0KGVzdywgdmZfbnZwb3J0cywgdG90YWxfbnZwb3J0cyk7DQogCWlmIChlcnIpDQogCQly
ZXR1cm4gZXJyOw0KIA0KLS0gDQoyLjIxLjANCg0K
