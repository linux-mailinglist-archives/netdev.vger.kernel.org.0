Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6902F75B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 08:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfE3GBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 02:01:51 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:37925
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbfE3GBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 02:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pSPGBN0Yv6OkEVjb9D2kumR4wP3mV5UesWdMLw604V0=;
 b=e1bjv39n7nJALrtRMMttwCkpBHcPvHCLPPsYjAhhWfY/B09MGCwVUIz1EyVjQ5raQMyqdrrQQcxwwDAqMpQ7MB3HGFVaSmCjfEKkuswPHin6/qUdIcIFCY00ZGjiupyBCgHrespDDlYIX9dMKcWfmPO8OrJALptNY/mWhMXYCGw=
Received: from AM0PR05MB4147.eurprd05.prod.outlook.com (52.134.124.140) by
 AM0PR05MB5170.eurprd05.prod.outlook.com (20.178.18.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 30 May 2019 06:01:46 +0000
Received: from AM0PR05MB4147.eurprd05.prod.outlook.com
 ([fe80::f099:9287:8470:5b72]) by AM0PR05MB4147.eurprd05.prod.outlook.com
 ([fe80::f099:9287:8470:5b72%7]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 06:01:46 +0000
From:   Mark Zhang <markz@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Thread-Topic: [PATCH rdma-next v2 13/17] RDMA/core: Get sum value of all
 counters when perform a sysfs stat read
Thread-Index: AQHU/maJo6zXY95FBkWR7IjH/etEzqZ3ijYAgAqV0ACAAE4FAIAA722A
Date:   Thu, 30 May 2019 06:01:46 +0000
Message-ID: <6e0b034c-b647-749f-fba7-2ac51a12d327@mellanox.com>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-14-leon@kernel.org> <20190522172636.GF15023@ziepe.ca>
 <20190529110524.GU4633@mtr-leonro.mtl.com> <20190529154438.GB8567@ziepe.ca>
In-Reply-To: <20190529154438.GB8567@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0202CA0013.eurprd02.prod.outlook.com
 (2603:10a6:203:69::23) To AM0PR05MB4147.eurprd05.prod.outlook.com
 (2603:10a6:208:63::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markz@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [115.195.218.239]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a86eed97-875c-4d13-b97c-08d6e4c44c26
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR05MB5170;
x-ms-traffictypediagnostic: AM0PR05MB5170:
x-microsoft-antispam-prvs: <AM0PR05MB51705EE57D30329B0CAD85E3CA180@AM0PR05MB5170.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(39860400002)(366004)(376002)(189003)(199004)(71190400001)(316002)(71200400001)(54906003)(110136005)(66946007)(3846002)(229853002)(81156014)(81166006)(6116002)(31686004)(8676002)(66066001)(73956011)(6486002)(68736007)(36756003)(6512007)(305945005)(8936002)(2906002)(6436002)(5660300002)(256004)(186003)(52116002)(6506007)(4326008)(25786009)(6246003)(7736002)(66556008)(66476007)(64756008)(66446008)(2616005)(14454004)(478600001)(486006)(386003)(446003)(102836004)(86362001)(99286004)(476003)(26005)(31696002)(11346002)(53936002)(76176011)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5170;H:AM0PR05MB4147.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BbxheWyvE75CELJspvsf/ozKUEXiOqp9XBx3z2v7oa8hdoE5MptiodLchXhb1ZioIV5vurpza/CWPnlCPhB8KJS6zNHNQhk8nTlzCLevbzCjNqnaTLkSqA05Osj1mnOsWsMamzOJi7gJR23dEQYgCNDwLBG4dBi00C8Y/eTuvB/mpe8zKstGQgKpa4RlSXKYaclI1mLyVQ5HQQ3wLO+oA/bUYLJxWXgqknvnS4r9P2xZqPaZzP3KtJU9Shvw26eddL1qz55lTr9DuXnt21Y42IN7BMMwQG+Zle6vUCxgL49266AGUQcM5QS5BGfGYeOnC3rrVxu61bhNrdwFUi9ZhGFZVnYF3DP+L6RVs9GbYncZTOOvxRzhIzc3+0AxM2U+UynOkIxnpb9IUfNoR+r6qYuiFCagv+LX46JPakl3fz0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <733024340E9E054FBFD09B1E79D98316@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a86eed97-875c-4d13-b97c-08d6e4c44c26
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 06:01:46.6420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: markz@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5170
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yOS8yMDE5IDExOjQ0IFBNLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+IE9uIFdlZCwg
TWF5IDI5LCAyMDE5IGF0IDAyOjA1OjI0UE0gKzAzMDAsIExlb24gUm9tYW5vdnNreSB3cm90ZToN
Cj4+IE9uIFdlZCwgTWF5IDIyLCAyMDE5IGF0IDAyOjI2OjM2UE0gLTAzMDAsIEphc29uIEd1bnRo
b3JwZSB3cm90ZToNCj4+PiBPbiBNb24sIEFwciAyOSwgMjAxOSBhdCAxMTozNDo0OUFNICswMzAw
LCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmlu
aWJhbmQvY29yZS9kZXZpY2UuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2RldmljZS5jDQo+
Pj4+IGluZGV4IGM1NmZmYzYxYWIxZS4uOGFlNDkwNmE2MGU3IDEwMDY0NA0KPj4+PiArKysgYi9k
cml2ZXJzL2luZmluaWJhbmQvY29yZS9kZXZpY2UuYw0KPj4+PiBAQCAtMTI1NSw3ICsxMjU1LDEx
IEBAIGludCBpYl9yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IGliX2RldmljZSAqZGV2aWNlLCBjb25z
dCBjaGFyICpuYW1lKQ0KPj4+PiAgIAkJZ290byBkZXZfY2xlYW51cDsNCj4+Pj4gICAJfQ0KPj4+
Pg0KPj4+PiAtCXJkbWFfY291bnRlcl9pbml0KGRldmljZSk7DQo+Pj4+ICsJcmV0ID0gcmRtYV9j
b3VudGVyX2luaXQoZGV2aWNlKTsNCj4+Pj4gKwlpZiAocmV0KSB7DQo+Pj4+ICsJCWRldl93YXJu
KCZkZXZpY2UtPmRldiwgIkNvdWxkbid0IGluaXRpYWxpemUgY291bnRlclxuIik7DQo+Pj4+ICsJ
CWdvdG8gc3lzZnNfY2xlYW51cDsNCj4+Pj4gKwl9DQo+Pj4NCj4+PiBEb24ndCBwdXQgdGhpcyB0
aGluZ3MgcmFuZG9tbHksIGlmIHRoZXJlIGlzIHNvbWUgcmVhc29uIGl0IHNob3VsZCBiZQ0KPj4+
IGFmdGVyIHN5c2ZzIGl0IG5lZWRzIGEgY29tbWVudCwgb3RoZXJ3aXNlIGlmIGl0IGlzIGp1c3Qg
YWxsb2NhdGluZw0KPj4+IG1lbW9yeSBpdCBiZWxvbmdzIGVhcmxpZXIsIGFuZCB0aGUgdW53aW5k
IHNob3VsZCBiZSBkb25lIGluIHJlbGVhc2UuDQo+Pj4NCj4+PiBJIGFsc28gdGhpbmsgaXQgaXMg
dmVyeSBzdHJhbmdlL3dyb25nIHRoYXQgYm90aCBzeXNmcyBhbmQgY291bnRlcnMgYXJlDQo+Pj4g
YWxsb2NhdGluZyB0aGUgc2FtZSBhbGxvY19od19zdGF0cyBvYmplY3QNCj4+Pg0KPj4+IFdoeSBj
YW4ndCB0aGV5IHNoYXJlPw0KPj4NCj4+IFRoZXkgY2FuLCBidXQgd2Ugd2FudGVkIHRvIHNlcGFy
YXRlICJsZWdhY3kiIGNvdW50ZXJzIHdoaWNoIHdlcmUgZXhwb3NlZA0KPj4gdGhyb3VnaCBzeXNm
cyBhbmQgIm5ldyIgY291bnRlcnMgd2hpY2ggY2FuIGJlIGVuYWJsZWQvZGlzYWJsZSBhdXRvbWF0
aWNhbGx5Lg0KPiANCj4gSXMgdGhlcmUgYW55IGNyb3NzIGNvbnRhbWluYXRpb24gdGhyb3VnaCB0
aGUgaHdfc3RhdHM/IElmIG5vIHRoZXkNCj4gc2hvdWxkIGp1c3Qgc2hhcmUuID4NCg0Kc3lzZnMg
aHdfc3RhdHMgaG9sZHMgdGhlIHBvcnQgY291bnRlciwgd2hpbGUgdGhpcyBvbmUgaG9sZHMgdGhl
DQpoaXN0b3J5IHZhbHVlIG9mIGFsbCBkeW5hbWljYWxseSBhbGxvY2F0ZWQgY291bnRlcnMuIFRo
ZXkgY2FuIG5vdCBzaGFyZS4NCnBvcnRfY291bnRlciA9DQogICBkZWZhdWx0X2NvdW50ZXIgKyBy
dW5uaW5nX2R5bmFtaWNfY291bnRlciArIGhpc3RvcnlfZHluYW1pY19jb3VudGVyDQoNCj4gSmFz
b24NCj4gDQoNCg==
