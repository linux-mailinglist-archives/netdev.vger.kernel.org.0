Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB2220A2B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 16:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfEPOw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 10:52:28 -0400
Received: from mail-eopbgr690046.outbound.protection.outlook.com ([40.107.69.46]:20462
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727336AbfEPOw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 10:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yR/LnftyhlmUovwWOykFOhgJA6p0NmY4Iny21P9tL9A=;
 b=MMq0lhqrvpUclbapkX4Jzsrw9vyHk2KZ+rm9b43puBEWCa6gb8cIqCOzPo16Dlkd1tANpwkBv5AwR3PiYFak6zc1zk6xsnFb8jMn8VvSF28uF+FpEFUPFMbZ3y0SuRUWYS8iIK/djQvVATMpa/9GFfOl9I13PvLNz9Io9kl9h70=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3659.namprd11.prod.outlook.com (20.178.231.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 14:52:25 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 14:52:25 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 3/3] aqc111: cleanup mtu related logic
Thread-Topic: [PATCH net 3/3] aqc111: cleanup mtu related logic
Thread-Index: AQHVC/b5+ylLZ20+E0GGzjBtQfjRwA==
Date:   Thu, 16 May 2019 14:52:25 +0000
Message-ID: <c24be8a514fbb2cc903c9a8ba69f9d461ec042f0.1558017386.git.igor.russkikh@aquantia.com>
References: <cover.1558017386.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1558017386.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0010.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::20)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 186384cf-5db4-4cd3-4802-08d6da0e1ba2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3659;
x-ms-traffictypediagnostic: DM6PR11MB3659:
x-microsoft-antispam-prvs: <DM6PR11MB36590ACD2701E847BA99D8D7980A0@DM6PR11MB3659.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(136003)(346002)(396003)(376002)(189003)(199004)(53936002)(6436002)(99286004)(54906003)(316002)(118296001)(14454004)(2906002)(50226002)(6512007)(6486002)(73956011)(478600001)(86362001)(5660300002)(8936002)(305945005)(66066001)(102836004)(72206003)(476003)(81166006)(2616005)(11346002)(36756003)(66446008)(64756008)(66556008)(7736002)(68736007)(446003)(81156014)(66476007)(8676002)(3846002)(76176011)(26005)(6916009)(44832011)(52116002)(71190400001)(71200400001)(107886003)(66946007)(6116002)(486006)(256004)(186003)(4326008)(14444005)(386003)(6506007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3659;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: V1J/7EgQVQdJy5B0LRZOFsFfdWkPGxbcruWbtM88WX8/tGHnh2CPiHbf9oKYVXSvkxtmWGuY7ClLs6RJNfQUBIy/GwPqNT4QnO8ep6OxKxiN5sg4YjTtPeq8bajBOYsSyECADfaWUWzamvpUAy3XwuYkce5ZfpFrjrF2V4rZBWtxbp8yZPuscs+POIJrXDMpQiNGj/5Ca6iHeAWRYU+cX/aJYdqf3hLlrEQQ1lPMvMtff50iANbDDVRZmF6XkgUJau34NpLmh1sI53VULTtW7BAyUHdRL/o1FnKK+MmCgHDzR+WbLbZtIAWz+zlb3vqzoQyqLL90pQ2q9pzhKJydqrAyFkSDwtCSGlNNcl5OnFiTvPQ2WDDgSQVsxUh575z8vqhw8L8Opli+Y0mdLJEoMDbfoCDUkMXzlyvQiFMx0zc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 186384cf-5db4-4cd3-4802-08d6da0e1ba2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 14:52:25.2068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T3JpZ2luYWwgZml4IGI4YjI3NzUyNWU5ZCB3YXMgZG9uZSB1bmRlciBpbXByZXNzaW9uIHRoYXQg
aW52YWxpZCBkYXRhDQpjb3VsZCBiZSB3cml0dGVuIGZvciBtdHUgY29uZmlndXJhdGlvbiBoaWdo
ZXIgdGhhdCAxNjMzNC4NCg0KQnV0IHRoZSBoaWdoIGxpbWl0IHdpbGwgYW55d2F5IGJlIHJlamVj
dGVkIG15IG1heF9tdHUgY2hlY2sgaW4gY2FsbGVyLg0KVGh1cywgbWFrZSB0aGUgY29kZSBjbGVh
bmVyIGFuZCBhbGxvdyBpdCBkb2luZyB0aGUgY29uZmlndXJhdGlvbiB3aXRob3V0DQpjaGVja2lu
ZyBmb3IgbWF4aW11bSBtdHUgdmFsdWUuDQoNCkZpeGVzOiBiOGIyNzc1MjVlOWQgKCJhcWMxMTE6
IGZpeCBlbmRpYW5uZXNzIGlzc3VlIGluIGFxYzExMV9jaGFuZ2VfbXR1IikNClNpZ25lZC1vZmYt
Ynk6IElnb3IgUnVzc2tpa2ggPGlnb3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0KLS0tDQogZHJp
dmVycy9uZXQvdXNiL2FxYzExMS5jIHwgNiArKy0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNi
L2FxYzExMS5jIGIvZHJpdmVycy9uZXQvdXNiL2FxYzExMS5jDQppbmRleCA0MDhkZjJkMzM1ZTMu
LjdlNDQxMTA3NDZkZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L3VzYi9hcWMxMTEuYw0KKysr
IGIvZHJpdmVycy9uZXQvdXNiL2FxYzExMS5jDQpAQCAtNDM3LDcgKzQzNyw3IEBAIHN0YXRpYyBp
bnQgYXFjMTExX2NoYW5nZV9tdHUoc3RydWN0IG5ldF9kZXZpY2UgKm5ldCwgaW50IG5ld19tdHUp
DQogCWFxYzExMV93cml0ZTE2X2NtZChkZXYsIEFRX0FDQ0VTU19NQUMsIFNGUl9NRURJVU1fU1RB
VFVTX01PREUsDQogCQkJICAgMiwgJnJlZzE2KTsNCiANCi0JaWYgKGRldi0+bmV0LT5tdHUgPiAx
MjUwMCAmJiBkZXYtPm5ldC0+bXR1IDw9IDE2MzM0KSB7DQorCWlmIChkZXYtPm5ldC0+bXR1ID4g
MTI1MDApIHsNCiAJCW1lbWNweShidWYsICZBUUMxMTFfQlVMS0lOX1NJWkVbMl0sIDUpOw0KIAkJ
LyogUlggYnVsayBjb25maWd1cmF0aW9uICovDQogCQlhcWMxMTFfd3JpdGVfY21kKGRldiwgQVFf
QUNDRVNTX01BQywgU0ZSX1JYX0JVTEtJTl9RQ1RSTCwNCkBAIC00NTEsMTAgKzQ1MSw4IEBAIHN0
YXRpYyBpbnQgYXFjMTExX2NoYW5nZV9tdHUoc3RydWN0IG5ldF9kZXZpY2UgKm5ldCwgaW50IG5l
d19tdHUpDQogCQlyZWcxNiA9IDB4MTAyMDsNCiAJZWxzZSBpZiAoZGV2LT5uZXQtPm10dSA8PSAx
MjUwMCkNCiAJCXJlZzE2ID0gMHgxNDIwOw0KLQllbHNlIGlmIChkZXYtPm5ldC0+bXR1IDw9IDE2
MzM0KQ0KLQkJcmVnMTYgPSAweDFBMjA7DQogCWVsc2UNCi0JCXJldHVybiAwOw0KKwkJcmVnMTYg
PSAweDFBMjA7DQogDQogCWFxYzExMV93cml0ZTE2X2NtZChkZXYsIEFRX0FDQ0VTU19NQUMsIFNG
Ul9QQVVTRV9XQVRFUkxWTF9MT1csDQogCQkJICAgMiwgJnJlZzE2KTsNCi0tIA0KMi4xNy4xDQoN
Cg==
