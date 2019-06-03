Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4033B70
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFCWgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:36:50 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:6068
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbfFCWgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 18:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOLpKjZE9uIfFJBrOYuBt7GHE6Gfuiuf5NMC/gM99Bw=;
 b=TOlx9RpRgGObAmnq08TAk4BsLOanc8kk6uCQgs0NEfupgWkedqgt8SrJWfKsmJkdTcQ8TpLfpw0Gl41komnCH/ovkVnR+1fFu6GaaXzRfIV3GrKXXVfaq7fklgUBzHbz/Z/vRabBhThjDcgHo8uig62NN0katQi0Oa7fc2lqwOk=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3250.eurprd05.prod.outlook.com (10.170.126.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Mon, 3 Jun 2019 22:36:45 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::55c3:8aaf:20f6:5899]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::55c3:8aaf:20f6:5899%5]) with mapi id 15.20.1922.021; Mon, 3 Jun 2019
 22:36:45 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next 0/2] Support MPLS features in bonding and vlan net
 devices
Thread-Topic: [PATCH net-next 0/2] Support MPLS features in bonding and vlan
 net devices
Thread-Index: AQHVGlzSERdpS9Cm2EeImPD9yjzdhA==
Date:   Mon, 3 Jun 2019 22:36:45 +0000
Message-ID: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.226.120.58]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: LO2P265CA0106.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::22) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1798a0c0-e078-4308-70ad-08d6e873f536
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3250;
x-ms-traffictypediagnostic: AM4PR05MB3250:
x-microsoft-antispam-prvs: <AM4PR05MB3250ADA0FE5E5E91C36866B1BA140@AM4PR05MB3250.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39860400002)(346002)(376002)(189003)(199004)(14454004)(86362001)(3846002)(256004)(186003)(6116002)(2501003)(4720700003)(99286004)(4326008)(107886003)(2351001)(25786009)(66476007)(26005)(386003)(6506007)(4744005)(6916009)(52116002)(36756003)(71200400001)(71190400001)(316002)(305945005)(508600001)(66066001)(486006)(5640700003)(2616005)(68736007)(476003)(81166006)(73956011)(8676002)(1730700003)(81156014)(6512007)(8936002)(2906002)(7736002)(5660300002)(66446008)(64756008)(66556008)(6436002)(50226002)(66946007)(102836004)(53936002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3250;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SwPGI/tulqjvrSVbADzsnJgWRxMGjdBMx+3Jakl5+V05XiPTmXj9VGhP8kxD+TuwLt7HVBEjvaMdOGLtwxxGHc5qWel5ncBQxF27kKvLkejLEelNMJt9DoH2Q9668aX96N1x+iYTOLlxEYnbfTWTkXT1tboMQjxJjB7eG2ZtKJIFcOx2ZgVaj53CAf5N8OIeGKR5L+w4qK92RHfrPWq5HDem3zkgJtQX/25kTlEJW9LvpOpGI2FhzRk8GC98YbfiA2PlwwxOiPsWQWYqCnimLszc7b2udTdmlG9SAiNi1yF2JRq3qsVs54mc0Z287OhthOkjZc865KsqDpvTvG10rGObpXmzlSuv0s0vE1KG7RLo6FNzDVsXxEUazSbiY6L111/sDudg38abWce5hn+iFbiV+TEtU1hen+VhEScbtZw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1798a0c0-e078-4308-70ad-08d6e873f536
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 22:36:45.5330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lariel@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3250
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TmV0ZGV2aWNlIEhXIE1QTFMgZmVhdHVyZXMgYXJlIG5vdCBwYXNzZWQgZnJvbSBkZXZpY2UgZHJp
dmVyJ3MgbmV0ZGV2aWNlIHRvDQp1cHBlciBuZXRkZXZpY2UsIHNwZWNpZmljYWxseSBWTEFOIGFu
ZCBib25kaW5nIG5ldGRldmljZSB3aGljaCBhcmUgY3JlYXRlZA0KYnkgdGhlIGtlcm5lbCB3aGVu
IG5lZWRlZC4NCg0KVGhpcyBwcmV2ZW50cyBlbmFibGVtZW50IGFuZCB1c2FnZSBvZiBIVyBvZmZs
b2Fkcywgc3VjaCBhcyBUU08gYW5kIGNoZWNrc3VtbWluZw0KZm9yIE1QTFMgdGFnZ2VkIHRyYWZm
aWMgd2hlbiBydW5uaW5nIHZpYSBWTEFOIG9yIGJvbmRpbmcgaW50ZXJmYWNlLg0KDQpUaGUgcGF0
Y2hlcyBpbnRyb2R1Y2UgY2hhbmdlcyB0byB0aGUgaW5pdGlhbGl6YXRpb24gc3RlcHMgb2YgdGhl
IFZMQU4gYW5kIGJvbmRpbmcNCm5ldGRldmljZXMgdG8gaW5oZXJpdCB0aGUgTVBMUyBmZWF0dXJl
cyBmcm9tIGxvd2VyIG5ldGRldmljZXMgdG8gYWxsb3cgdGhlIEhXDQpvZmZsb2Fkcy4NCg0KQXJp
ZWwgTGV2a292aWNoICgyKToNCiAgbmV0OiBib25kaW5nOiBJbmhlcml0IE1QTFMgZmVhdHVyZXMg
ZnJvbSBzbGF2ZSBkZXZpY2VzDQogIG5ldDogdmxhbjogSW5oZXJpdCBNUExTIGZlYXR1cmVzIGZy
b20gcGFyZW50IGRldmljZQ0KDQogZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4uYyB8IDEx
ICsrKysrKysrKysrDQogbmV0LzgwMjFxL3ZsYW5fZGV2LmMgICAgICAgICAgICB8ICAxICsNCiAy
IGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCg0KLS0gDQoxLjguMy4xDQoNCg==
