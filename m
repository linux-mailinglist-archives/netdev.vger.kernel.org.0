Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA7D5AF79
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 10:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfF3IoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 04:44:01 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:44039
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfF3IoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 04:44:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3Gvq9s8zc71q6RlGn9VhjfLDwJvOIZ/ZwKM/858SaE=;
 b=SJCODOZTo6K8QerYJMXm4Mxwniy5tMh0CD8qTAuGCbXpCFlqDL2UFwO3twkcQ0Tgw+oIARsSCH0YGDbdrzMtuklhYLSXJGQSbHigZgm5qpyc2Ek9PqyOVWCqqEm/VT5C25Ob7jKZ84VbTCp7sCbhK7Uhw0clCzxEzPrfchqqI/Y=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3425.eurprd05.prod.outlook.com (10.171.190.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Sun, 30 Jun 2019 08:43:58 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 08:43:58 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "aconole@redhat.com" <aconole@redhat.com>,
        "wangzhike@jd.com" <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jpettit@ovn.org" <jpettit@ovn.org>
Subject: Re: [PATCH net-next v2 1/4] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next v2 1/4] net/sched: Introduce action ct
Thread-Index: AQHVJ24eOxnMkA1dYkKXdu3QHI3chKav9SqAgAP73wA=
Date:   Sun, 30 Jun 2019 08:43:58 +0000
Message-ID: <c67b9fcb-e24d-00d3-13ab-d0f25916ceac@mellanox.com>
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
 <1561038141-31370-2-git-send-email-paulb@mellanox.com>
 <20190627.125339.707372206595841703.davem@davemloft.net>
In-Reply-To: <20190627.125339.707372206595841703.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0054.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::18) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85ba0860-8eed-4fa3-ebc9-08d6fd371786
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3425;
x-ms-traffictypediagnostic: AM4PR05MB3425:
x-microsoft-antispam-prvs: <AM4PR05MB3425EC20D97E2A42CB7DD3F5CFFE0@AM4PR05MB3425.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(199004)(189003)(7736002)(316002)(229853002)(14454004)(68736007)(305945005)(11346002)(54906003)(66946007)(66446008)(66476007)(66556008)(64756008)(71200400001)(71190400001)(2906002)(8936002)(73956011)(6116002)(3846002)(6246003)(4326008)(6506007)(386003)(53546011)(31686004)(86362001)(81156014)(8676002)(81166006)(36756003)(6916009)(99286004)(76176011)(102836004)(66066001)(5660300002)(4744005)(25786009)(31696002)(52116002)(53936002)(6436002)(6486002)(478600001)(26005)(186003)(6512007)(486006)(256004)(476003)(2616005)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3425;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qcG/D/JUDSOn6RZZz7xF4kEIW6b+q3StlAO/tr95pICu6yKgpukoKEFxO6josaTH+PV4QqlRDH1ElHiNS0JE2gsl2qB1h7PqvNvINE0Bd8qy+HY2oG0uQFEJXHbAPRrmd5X2fEdghLXPKof+hV8XJ5zeaYwEIguZ+yZize2iyuLHp5LQ7SYy5pux0/IGORpPpXnjy9ZAHz2hEqA01u2IGldfWOPOwcXFyk/M+yHYIEa4+Ur/mUHXe6ojnbb7K9Ugab8k4CPGKtnxxdf7gvBq9wZ8g8hbVghqpnToiGgBuz0ulbGZ/HxJI//8Qvd+zxv++whFkxhp19WkArkL7QSZukjnflUqLgu6psytiydQDTkA383vWL5ZhpIm0Jwo97X0sxYBfkR9w9q+j2ZpVDZifkrKQm6hzt+gexAM/Hn4+No=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ECD0908C0258E428B9386BC7B97FD22@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ba0860-8eed-4fa3-ebc9-08d6fd371786
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 08:43:58.2758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3425
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzI3LzIwMTkgMTA6NTMgUE0sIERhdmlkIE1pbGxlciB3cm90ZToNCj4gRnJvbTogUGF1
bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NCj4gRGF0ZTogVGh1LCAyMCBKdW4gMjAxOSAx
Njo0MjoxOCArMDMwMA0KPg0KPj4gK3N0cnVjdCB0Y2ZfY3RfcGFyYW1zIHsNCj4gICAuLi4NCj4+
ICsJc3RydWN0IHJjdV9oZWFkIHJjdTsNCj4+ICsNCj4+ICt9Ow0KPiBQbGVhc2UgZ2V0IHJpZGUg
b2YgdGhhdCBlbXB0eSBsaW5lIGFmdGVyIHRoZSAncmN1JyBtZW1iZXIuDQo+DQo+PiArCXN3aXRj
aCAoc2tiLT5wcm90b2NvbCkgew0KPj4gKwljYXNlIGh0b25zKEVUSF9QX0lQKToNCj4+ICsJCWZh
bWlseSA9IE5GUFJPVE9fSVBWNDsNCj4+ICsJCWJyZWFrOw0KPj4gKwljYXNlIGh0b25zKEVUSF9Q
X0lQVjYpOg0KPj4gKwkJZmFtaWx5ID0gTkZQUk9UT19JUFY2Ow0KPj4gKwkJYnJlYWs7DQo+PiAr
CWRlZmF1bHQ6DQo+PiArCWJyZWFrOw0KPiBCcmVhayBzdGF0ZW1lbnQgaXMgbm90IGluZGVudGVk
IHByb3Blcmx5Lg0KPg0KPj4gK3N0YXRpYyBfX25ldF9pbml0IGludCBjdF9pbml0X25ldChzdHJ1
Y3QgbmV0ICpuZXQpDQo+PiArew0KPj4gKwlzdHJ1Y3QgdGNfY3RfYWN0aW9uX25ldCAqdG4gPSBu
ZXRfZ2VuZXJpYyhuZXQsIGN0X25ldF9pZCk7DQo+PiArCXVuc2lnbmVkIGludCBuX2JpdHMgPSBG
SUVMRF9TSVpFT0Yoc3RydWN0IHRjZl9jdF9wYXJhbXMsIGxhYmVscykgKiA4Ow0KPiBSZXZlcnNl
IGNocmlzdG1hcyB0cmVlIGhlcmUgcGxlYXNlLg0KU3VyZSB0aGFua3MuDQo=
