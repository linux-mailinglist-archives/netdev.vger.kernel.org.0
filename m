Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DBFE02C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfD2KFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:05 -0400
Received: from mail-eopbgr780044.outbound.protection.outlook.com ([40.107.78.44]:59488
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727630AbfD2KFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oy+M21QeMRNqErpz/RsVbbM07wbgnQ/54rjDyXMVWMo=;
 b=VpG5emP5psGZee/K4bC83tX2By9HdlY6ZxnkJFl/d2XvfL8KbLbScUCmDOcTuyeLSmGj1R0gDQ9egxWxPTZk2vR97XzKMuDplRpkvLhY4rEaz27Nynh1l0Wa0iqQQ0fG6o/0QkRStaI4aMaxLvNLdz3F/F3cvnLLnJd4eZwG8FE=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3321.namprd11.prod.outlook.com (20.176.122.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 10:05:02 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:05:02 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v4 net-next 12/15] net: aquantia: fetch up to date statistics
 on ethtool request
Thread-Topic: [PATCH v4 net-next 12/15] net: aquantia: fetch up to date
 statistics on ethtool request
Thread-Index: AQHU/nMDi0P1rGtlokOw3CWMlfeIRQ==
Date:   Mon, 29 Apr 2019 10:05:02 +0000
Message-ID: <9b824b0e582e7670a1226f16df70c76acbf86b8c.1556531633.git.igor.russkikh@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1556531633.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0189.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35a55afd-8a68-4316-ba7b-08d6cc8a253a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3321;
x-ms-traffictypediagnostic: DM6PR11MB3321:
x-microsoft-antispam-prvs: <DM6PR11MB3321CD3B501F1C06E3C2976098390@DM6PR11MB3321.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:71;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(366004)(396003)(376002)(346002)(189003)(199004)(6116002)(3846002)(6916009)(73956011)(81156014)(66446008)(68736007)(64756008)(256004)(14444005)(7736002)(26005)(81166006)(66946007)(66556008)(66476007)(102836004)(305945005)(486006)(6436002)(446003)(8676002)(476003)(2616005)(11346002)(478600001)(2906002)(107886003)(97736004)(4326008)(316002)(6512007)(86362001)(186003)(72206003)(6486002)(386003)(71190400001)(76176011)(6506007)(99286004)(71200400001)(52116002)(5660300002)(66066001)(36756003)(14454004)(44832011)(54906003)(50226002)(118296001)(25786009)(53936002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3321;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +YD2fwkoLCyhh+aqD0y3eIqH7ZgSoIh/aTHYDKzhYBOjX9o/fbJEzwRstvNUuylDegLV1vGnaanSUNtB4Y/wmeCnuk9kGkgWsQndDwpTubSKfHA/KMqiQge1SNqwRiVKeFmcL6IuvtgsT09VHZhrhJAc7vLI3MQG4aR/IzBvfMrlSSEbyHefrHoZ97pkq/KebuoNXwLWh0RzCoSDQDAb7X8tjsv9xOqwWzm9eb+dAgQ+h+Dz9BAvzYjYVyYQxWXAAWG76zl9OrD0HqU13Ajx6vH45Q6kCMBV3YPSCXXcYCQcEZ7IlQDA4N3T1+9Agpwr0Ip6MGYLYeIqTSoFSm8726EB5EyjS9q+Vik/4VwHPBsGiP7Jti04XpnIhbUetEUeoJxZB9q4PnqxpXjQLtvy/szYQbkRY8LIka2qwdaJbTk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a55afd-8a68-4316-ba7b-08d6cc8a253a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:05:02.6135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3321
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG1pdHJ5IEJvZ2Rhbm92IDxkbWl0cnkuYm9nZGFub3ZAYXF1YW50aWEuY29tPg0KDQpU
aGlzIGltcHJvdmVzIGV0aHRvb2wgLVMgdXNhZ2UsIHdoZXJlIHN0YXRzIGFyZSBub3cgYWN0dWFs
DQpvbiBlYWNoIHJlcXVlc3QuIEJlZm9yZSB0aGF0IHN0YXRzIG9ubHkgd2VyZSB1cGRhdGVkIGF0
IHNlcnZpY2UNCnRpbWVyIHBlcmlvZC4NCg0KVGVzdGVkLWJ5OiBOaWtpdGEgRGFuaWxvdiA8bmRh
bmlsb3ZAYXF1YW50aWEuY29tPg0KU2lnbmVkLW9mZi1ieTogSWdvciBSdXNza2lraCA8aWdvci5y
dXNza2lraEBhcXVhbnRpYS5jb20+DQpTaWduZWQtb2ZmLWJ5OiBEbWl0cnkgQm9nZGFub3YgPGRt
aXRyeS5ib2dkYW5vdkBhcXVhbnRpYS5jb20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9h
cXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYyB8IDkgKysrKysrKystDQogMSBmaWxlIGNoYW5nZWQs
IDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYw0KaW5kZXggNDU0YTQ0YmIxNDhlLi44MDE4
ZjQ4M2FlNDUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxh
bnRpYy9hcV9uaWMuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50
aWMvYXFfbmljLmMNCkBAIC03MDAsNyArNzAwLDE0IEBAIHZvaWQgYXFfbmljX2dldF9zdGF0cyhz
dHJ1Y3QgYXFfbmljX3MgKnNlbGYsIHU2NCAqZGF0YSkNCiAJdW5zaWduZWQgaW50IGkgPSAwVTsN
CiAJdW5zaWduZWQgaW50IGNvdW50ID0gMFU7DQogCXN0cnVjdCBhcV92ZWNfcyAqYXFfdmVjID0g
TlVMTDsNCi0Jc3RydWN0IGFxX3N0YXRzX3MgKnN0YXRzID0gc2VsZi0+YXFfaHdfb3BzLT5od19n
ZXRfaHdfc3RhdHMoc2VsZi0+YXFfaHcpOw0KKwlzdHJ1Y3QgYXFfc3RhdHNfcyAqc3RhdHM7DQor
DQorCWlmIChzZWxmLT5hcV9md19vcHMtPnVwZGF0ZV9zdGF0cykgew0KKwkJbXV0ZXhfbG9jaygm
c2VsZi0+ZndyZXFfbXV0ZXgpOw0KKwkJc2VsZi0+YXFfZndfb3BzLT51cGRhdGVfc3RhdHMoc2Vs
Zi0+YXFfaHcpOw0KKwkJbXV0ZXhfdW5sb2NrKCZzZWxmLT5md3JlcV9tdXRleCk7DQorCX0NCisJ
c3RhdHMgPSBzZWxmLT5hcV9od19vcHMtPmh3X2dldF9od19zdGF0cyhzZWxmLT5hcV9odyk7DQog
DQogCWlmICghc3RhdHMpDQogCQlnb3RvIGVycl9leGl0Ow0KLS0gDQoyLjE3LjENCg0K
