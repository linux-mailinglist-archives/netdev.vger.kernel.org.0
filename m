Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29523E02D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfD2KFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:05:08 -0400
Received: from mail-eopbgr780044.outbound.protection.outlook.com ([40.107.78.44]:59488
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727661AbfD2KFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 06:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJ/HsWbh9coX9uC3V5MhVz63UWahagYUlJM0w2EDkik=;
 b=Qkwgpr256DM/rwnpqNGqhgGsL16GbLIV6JsnWBn4vy6bO3TWh6yBgFUoiiwza/i1ch2xhQTkQ2qKNxfcBZmF4IjXWxaP+plIeRaCmPGadk3ROtcQ98OOaykjDsFCEj4mMYwqUvoDuDwMRLCyOJEN2xS5SEW2O5IOlzbB1b3STtg=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3321.namprd11.prod.outlook.com (20.176.122.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 10:05:05 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.010; Mon, 29 Apr 2019
 10:05:05 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH v4 net-next 13/15] net: aquantia: get total counters from DMA
 block
Thread-Topic: [PATCH v4 net-next 13/15] net: aquantia: get total counters from
 DMA block
Thread-Index: AQHU/nMEtDjrEzmmAEiCvl2Ot843Zg==
Date:   Mon, 29 Apr 2019 10:05:05 +0000
Message-ID: <6d10f3f83de675ab390e9791b66aa5ec8f1cb6bd.1556531633.git.igor.russkikh@aquantia.com>
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
x-ms-office365-filtering-correlation-id: b3b0d1cf-e367-476b-d756-08d6cc8a26b9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3321;
x-ms-traffictypediagnostic: DM6PR11MB3321:
x-microsoft-antispam-prvs: <DM6PR11MB3321DD1C932D942B9FF4B15498390@DM6PR11MB3321.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:233;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(366004)(396003)(376002)(346002)(189003)(199004)(6116002)(3846002)(6916009)(73956011)(81156014)(66446008)(68736007)(64756008)(256004)(14444005)(7736002)(26005)(81166006)(66946007)(66556008)(66476007)(102836004)(305945005)(486006)(6436002)(446003)(8676002)(476003)(2616005)(11346002)(478600001)(2906002)(107886003)(97736004)(4326008)(316002)(6512007)(86362001)(186003)(72206003)(6486002)(386003)(71190400001)(76176011)(6506007)(99286004)(71200400001)(52116002)(5660300002)(66066001)(36756003)(14454004)(44832011)(54906003)(50226002)(118296001)(25786009)(53936002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3321;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n0LR/UDgxWsePvNY9ZQ9BXTI9zCtLv/0DSLQXFNni9EQjYb8w0KgFjEsliZyhtx3FaWiYCF+aulg/RgfU58W1PH6LqB78ylX8dJEMigD9HjcSQ6snxFkOkZIkNjC8pCfzqcnqQaPcmvvcwMEVtiLL95aTQrmvpzpEY60xtW00QmzJsQd4qGkN5j4YNRObkSEtHUWKgAkz7lGRY37loySW7i1IiVjwoh0u0ZTgIuD0uMACqxe0FaRwrMUeBiqxCYc+nMtNt/xt64axdkXAe6pn3zDV2os4d5Od0dXxFhI+czZzgRTwW7qp3ZNMyU0TcMdcdCqYeqO8mkZp2J4Egx8eEqDoztq+Cz9POo1t0yl4Cqc9gRD04urobVPRyZpL4/TwNTu0Py9DxhSawH9THzncDwnAB9Jy62T1O3aGE9KzlE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3b0d1cf-e367-476b-d756-08d6cc8a26b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 10:05:05.0703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3321
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRG1pdHJ5IEJvZ2Rhbm92IDxkbWl0cnkuYm9nZGFub3ZAYXF1YW50aWEuY29tPg0KDQph
cV9uaWNfdXBkYXRlX25kZXZfc3RhdHMgcHVzaGVzIHN0YXRpc3RpY3MgdG8gbmRldi0+c3RhdHMg
ZnJvbQ0Kc3lzdGVtIGludGVyZmFjZS4gVGhpcyBpcyBub3QgYWx3YXlzIGdvb2QgYmVjYXVzZSBp
dCBjb3VudHMgcGFja2V0cy9ieXRlcw0KYmVmb3JlIGFueSBvZiByeCBmaWx0ZXJzIChpbmNsdWRp
bmcgbWFjIGZpbHRlcikuDQoNCkl0cyBiZXR0ZXIgdG8gcmVwb3J0IHRoZSBwYWNrZXQvYnl0ZXMg
c3RhdGlzdGljcyBmcm9tIERNQQ0KY291bnRlcnMgd2hpY2ggZ2l2ZXMgYWN0dWFsIHZhbHVlcyBv
ZiBkYXRhIHRyYW5zZmVycmVkIG92ZXIgcGNpLg0KU3lzdGVtIGxldmVsIHN0YXRzIGlzIHN0aWxs
IGF2YWlsYWJsZSB2aWEgZXRodG9vbC4NCg0KU2lnbmVkLW9mZi1ieTogTmlraXRhIERhbmlsb3Yg
PG5kYW5pbG92QGFxdWFudGlhLmNvbT4NClNpZ25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2ggPGln
b3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0KU2lnbmVkLW9mZi1ieTogRG1pdHJ5IEJvZ2Rhbm92
IDxkbWl0cnkuYm9nZGFub3ZAYXF1YW50aWEuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMgfCA5ICsrKysrLS0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCA1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9uaWMuYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jDQppbmRleCA4MDE4ZjQ4M2FlNDUu
LmU4MmQyNWE5MWJjMSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlh
L2F0bGFudGljL2FxX25pYy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9h
dGxhbnRpYy9hcV9uaWMuYw0KQEAgLTc1MywxMSArNzUzLDEyIEBAIHN0YXRpYyB2b2lkIGFxX25p
Y191cGRhdGVfbmRldl9zdGF0cyhzdHJ1Y3QgYXFfbmljX3MgKnNlbGYpDQogCXN0cnVjdCBuZXRf
ZGV2aWNlICpuZGV2ID0gc2VsZi0+bmRldjsNCiAJc3RydWN0IGFxX3N0YXRzX3MgKnN0YXRzID0g
c2VsZi0+YXFfaHdfb3BzLT5od19nZXRfaHdfc3RhdHMoc2VsZi0+YXFfaHcpOw0KIA0KLQluZGV2
LT5zdGF0cy5yeF9wYWNrZXRzID0gc3RhdHMtPnVwcmMgKyBzdGF0cy0+bXByYyArIHN0YXRzLT5i
cHJjOw0KLQluZGV2LT5zdGF0cy5yeF9ieXRlcyA9IHN0YXRzLT51YnJjICsgc3RhdHMtPm1icmMg
KyBzdGF0cy0+YmJyYzsNCisJbmRldi0+c3RhdHMucnhfcGFja2V0cyA9IHN0YXRzLT5kbWFfcGt0
X3JjOw0KKwluZGV2LT5zdGF0cy5yeF9ieXRlcyA9IHN0YXRzLT5kbWFfb2N0X3JjOw0KIAluZGV2
LT5zdGF0cy5yeF9lcnJvcnMgPSBzdGF0cy0+ZXJwcjsNCi0JbmRldi0+c3RhdHMudHhfcGFja2V0
cyA9IHN0YXRzLT51cHRjICsgc3RhdHMtPm1wdGMgKyBzdGF0cy0+YnB0YzsNCi0JbmRldi0+c3Rh
dHMudHhfYnl0ZXMgPSBzdGF0cy0+dWJ0YyArIHN0YXRzLT5tYnRjICsgc3RhdHMtPmJidGM7DQor
CW5kZXYtPnN0YXRzLnJ4X2Ryb3BwZWQgPSBzdGF0cy0+ZHBjOw0KKwluZGV2LT5zdGF0cy50eF9w
YWNrZXRzID0gc3RhdHMtPmRtYV9wa3RfdGM7DQorCW5kZXYtPnN0YXRzLnR4X2J5dGVzID0gc3Rh
dHMtPmRtYV9vY3RfdGM7DQogCW5kZXYtPnN0YXRzLnR4X2Vycm9ycyA9IHN0YXRzLT5lcnB0Ow0K
IAluZGV2LT5zdGF0cy5tdWx0aWNhc3QgPSBzdGF0cy0+bXByYzsNCiB9DQotLSANCjIuMTcuMQ0K
DQo=
