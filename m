Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5C2A3DB
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfEYJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:58:16 -0400
Received: from mail-eopbgr820057.outbound.protection.outlook.com ([40.107.82.57]:48829
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726812AbfEYJ6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 05:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVQSM+1WYC+cWkjh5caE/3bYAsXSIQ3nI1iYMYwvQS4=;
 b=R2qdSLaCVDbIfLPh2iTu/W94SIIU7H/PsPz02nDje54uWDE8xE00pGThFdo3KMOeNS1Rz4EE0DXEoxZ5ogG0koqXpWUnroXFK/pVRuJyjw2RCYBtWmZ7ehq4d0HAYjEhYVn5Y7edjkVJqdRRZrZZQ5tgtgp0ZS09gEGmOHnLspQ=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3017.namprd11.prod.outlook.com (20.177.218.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Sat, 25 May 2019 09:58:05 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1922.021; Sat, 25 May 2019
 09:58:05 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH net 4/4] net: aquantia: tcp checksum 0xffff being handled
 incorrectly
Thread-Topic: [PATCH net 4/4] net: aquantia: tcp checksum 0xffff being handled
 incorrectly
Thread-Index: AQHVEuBZf/FHXeSoaEq2NntBaHmdtg==
Date:   Sat, 25 May 2019 09:58:05 +0000
Message-ID: <e412fb65c4a4ef3cdd523ea9a554f7384d3bc627.1558777421.git.igor.russkikh@aquantia.com>
References: <cover.1558777421.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1558777421.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0009.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:bc::19)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56f21ca8-fbcb-4365-bd0e-08d6e0f77b44
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM6PR11MB3017;
x-ms-traffictypediagnostic: DM6PR11MB3017:
x-microsoft-antispam-prvs: <DM6PR11MB30174BDAFB007248FD8D33BD98030@DM6PR11MB3017.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39850400004)(199004)(189003)(66946007)(71190400001)(486006)(53936002)(66476007)(2616005)(44832011)(71200400001)(66556008)(107886003)(66446008)(73956011)(64756008)(7736002)(6916009)(14454004)(11346002)(478600001)(316002)(25786009)(446003)(6436002)(72206003)(6512007)(6486002)(386003)(118296001)(36756003)(3846002)(4326008)(305945005)(52116002)(6506007)(186003)(76176011)(26005)(2906002)(99286004)(476003)(102836004)(256004)(86362001)(5660300002)(54906003)(66066001)(68736007)(81156014)(8676002)(81166006)(50226002)(8936002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3017;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uuMFbzoRrIj5pjal0VRZntHCgVXVXmoxqO0SHuvnUg4hecA5YnX8I8kyL3MTVW+O/YIx8ZgFwzyJnoHPeuB+dZsjgezAQrqBX7emybvvpBr9lgmKtyUaLbbwU7x0V7RV7OBcH11u3g0qgFf1NxAUluSiPo1DHm1nOCsTezfovUSqfcst64fuRm4YA9IxPJ7+qiZo2eCFSNZhgtObUwBdlXBINJaDm57/JfKzp3sgaK6G60r5qruTdyFy3QKOBC40picJBGXo3dR/ZnCPn/I620qCUJx4AWtQDDqSi+/ox7/anQayM8HEol3uVP5BO0tH9pL+EixP3q3dTa3aEHJTaW1yz7qnngJTIkTdKUVHOsCrXpSZxE9wznwVNBPuq/LKEWglVB9RVCgjOVIrn8yRzerm0wDaraBxwp8hAd/QJ6M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f21ca8-fbcb-4365-bd0e-08d6e0f77b44
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 09:58:05.3567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmlraXRhIERhbmlsb3YgPG5kYW5pbG92QGFxdWFudGlhLmNvbT4NCg0KVGhhdHMgYSBr
bm93biBxdWlyayBpbiB3aW5kb3dzIHRjcCBzdGFjayBpdCBjYW4gcHJvZHVjZSAweGZmZmYgY2hl
Y2tzdW0uDQpUaGF0cyBpbmNvcnJlY3QgYnV0IGl0IGlzLg0KDQpBdGxhbnRpYyBIVyB3aXRoIExS
TyBlbmFibGVkIGhhbmRsZXMgdGhhdCBpbmNvcnJlY3RseSBhbmQgY2hhbmdlcyBjc3VtIHRvDQow
eGZmZmUgLSBidXQgaW5kaWNhdGVzIHRoYXQgY3N1bSBpcyBpbnZhbGlkLiBUaGlzIGNhdXNlcyBk
cml2ZXIgdG8gcGFzcw0KcGFja2V0IHRvIGxpbnV4IG5ldHdvcmtpbmcgc3RhY2sgd2l0aCBDU1VN
X05PTkUsIHN0YWNrIGV2ZW50dWFsbHkgZHJvcHMNCnRoZSBwYWNrZXQuDQoNClRoZXJlIGlzIGEg
cXVpcmsgaW4gYXRsYW50aWMgSFcgdG8gZW5hYmxlIGNvcnJlY3QgcHJvY2Vzc2luZyBvZg0KMHhm
ZmZmIGluY29ycmVjdCBjc3VtLiBFbmFibGUgaXQuDQoNClRoZSB2aXNpYmxlIGJ1ZyBpcyB0aGF0
IHdpbmRvd3MgbGluayBwYXJ0bmVyIHdpdGggc29mdHdhcmUgZ2VuZXJhdGVkIGNzdW1zDQpjYXVz
ZWQgVENQIGNvbm5lY3Rpb24gdG8gYmUgdW5zdGFibGUgc2luY2UgYWxsIHBhY2tldHMgdGhhdCBj
c3VtIHZhbHVlDQphcmUgZHJvcHBlZC4NCg0KUmVwb3J0ZWQtYnk6IERtaXRyeSBCZXpydWtvdiA8
ZG1pdHJ5LmJlenJ1a292QGFxdWFudGlhLmNvbT4NClNpZ25lZC1vZmYtYnk6IE5pa2l0YSBEYW5p
bG92IDxuZGFuaWxvdkBhcXVhbnRpYS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3NraWto
IDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjAuYyB8IDMgKy0tDQogMSBmaWxlIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5j
DQppbmRleCBlOTc5ZjIyN2NmMGIuLjVjMzA2NWJkZmRkZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfYjAuYw0KKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5j
DQpAQCAtMjY2LDEyICsyNjYsMTEgQEAgc3RhdGljIGludCBod19hdGxfYjBfaHdfb2ZmbG9hZF9z
ZXQoc3RydWN0IGFxX2h3X3MgKnNlbGYsDQogCQkgKi8NCiAJCWh3X2F0bF9ycG9fbHJvX21heF9j
b2FsZXNjaW5nX2ludGVydmFsX3NldChzZWxmLCA1MCk7DQogDQotDQogCQlod19hdGxfcnBvX2xy
b19xc2Vzc2lvbnNfbGltX3NldChzZWxmLCAxVSk7DQogDQogCQlod19hdGxfcnBvX2xyb190b3Rh
bF9kZXNjX2xpbV9zZXQoc2VsZiwgMlUpOw0KIA0KLQkJaHdfYXRsX3Jwb19scm9fcGF0Y2hfb3B0
aW1pemF0aW9uX2VuX3NldChzZWxmLCAwVSk7DQorCQlod19hdGxfcnBvX2xyb19wYXRjaF9vcHRp
bWl6YXRpb25fZW5fc2V0KHNlbGYsIDFVKTsNCiANCiAJCWh3X2F0bF9ycG9fbHJvX21pbl9wYXlf
b2ZfZmlyc3RfcGt0X3NldChzZWxmLCAxMFUpOw0KIA0KLS0gDQoyLjE3LjENCg0K
