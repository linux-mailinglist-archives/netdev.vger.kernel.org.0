Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD1B1066FD
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKVHV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:21:27 -0500
Received: from mail-eopbgr40042.outbound.protection.outlook.com ([40.107.4.42]:6629
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbfKVHV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 02:21:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4kF9l7OES9L8EBhrDIo7yuvbQPaItGmpsvaqHKi+mR6tZCDvKaLjl77QUY5ahslpP2wX99z44doizOvtLP7O9XUMXNCWL/VOpKdezph+XmicObPx8NxMw7MmX/VnzWTzO615Y0285/CBMjgxmjEqORXvti8v7o0mEu3eiLgsyR5QUNfZQXzNtniR1H6xiknp9S0xBlPQDSN9uAbwe350mZ6FjihK2tDi9tSYkaNIB4763CrPc9h0sL3DXNHdWyHf4IjkHyR7+X/QfI3n41zsy+lCDxyr4wEIYHDp6DIVVRfXq2VtCRpzBpvwO+8xvzsdtQCzHTf1+Ls6Je90gu2Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCQVnpJusZleGQr0FG6ST8HtD+Apc0RlXUuQWYjkI2g=;
 b=B3lmNLjxxJXcGknqN0a3aEYX4ZrM6dS9nevAVWNKB3VGugCGpesSreIZHmitBXCXsIHfUOHSL8C1BaP6uMYjqHZQQpy9W8KQ/JvctbOXgxFRbVdEtsne2gSs+vmf5L1zvajAIC+AHMy0WfnWVKJ0iFuq2Wck10L/4UXMk9yeha/AyBXYbirVGBd1OPTX8F62fRCuLyt2kGdFM/B8WJBaqgvWAFEfCurxWSieqUm23PUgii1vqbPAVvz9svqc3QD05peXVSl8J0mb4WsoZM0WaJhwvqmEDAjzeMxiclocIThsWoogknwpQtTdF+V3V28G94/CmFGkfGurjciOfmqdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCQVnpJusZleGQr0FG6ST8HtD+Apc0RlXUuQWYjkI2g=;
 b=s4fbESPPAhPbN4gAUyzWtne0jgFmlbn0Ua4gN5ANxCEHagDLDCGlOM2ISISBYa1t4zyx23t/0ktcSlYBdXBd40BrdVaASBLiTXb0dVl8+90JnZ47mB6I2a8NPxnHQPMuZxQwhTr+dhUgAP/8tF+zPWtLs7m3/SNJGmxF1WNj0wQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5921.eurprd05.prod.outlook.com (20.178.117.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 07:21:22 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.032; Fri, 22 Nov 2019
 07:21:22 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] net: rtnetlink: prevent underflows in do_setvfinfo()
Thread-Topic: [PATCH net] net: rtnetlink: prevent underflows in do_setvfinfo()
Thread-Index: AQHVn57yqEm1l969pkuGNkZ+vIYicqeWOzmAgACQaYA=
Date:   Fri, 22 Nov 2019 07:21:22 +0000
Message-ID: <a3f851fb-e148-d386-e9dd-29e7d89c93fa@mellanox.com>
References: <20191120123438.vxn2ngnxzpcaqot4@kili.mountain>
 <20191121.144429.649625073638417068.davem@davemloft.net>
In-Reply-To: <20191121.144429.649625073638417068.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [68.203.16.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a39b4d5e-14e0-4903-1cd5-08d76f1c93ed
x-ms-traffictypediagnostic: AM0PR05MB5921:|AM0PR05MB5921:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5921581A913111BE682306BDD1490@AM0PR05MB5921.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(53546011)(3846002)(66476007)(91956017)(66446008)(66556008)(64756008)(66946007)(6116002)(66066001)(31686004)(36756003)(76116006)(76176011)(316002)(229853002)(6246003)(110136005)(99286004)(54906003)(4326008)(71190400001)(256004)(14444005)(6512007)(6486002)(2906002)(81166006)(81156014)(8676002)(71200400001)(6436002)(11346002)(446003)(2616005)(2501003)(25786009)(7736002)(305945005)(7416002)(478600001)(31696002)(86362001)(14454004)(8936002)(5660300002)(186003)(102836004)(26005)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5921;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o92Y8vtsksRTTiQIS6UplFn5vxZ2L6Cq03HoYYVc7IDElwAlJXc0zYIy9Fq+6l9Ov4uyYWJGutvwpAgpNDUeh+asaA6Qi9Zxtq6pDXPvz/nHio3//wqzR0pjxtZ+EQqDkc/OsbrwXOgoV2kd/6K6ztjr9LodrTA0SInfnunCjFjWrp+5aKoVqeLQtYwK4SLcNYhwaoZWJw8KSccmNyA3id4nXfAH1jiO6ecHCELKAZU03p8GBFHa57ITN5oA7wpjEwsSWKTuLbE+x+nH+fnDj7fAEAhKTc58JuGWb/o8Xn2zxoaDOj4g84iugHerVm9SfAExER4J2w6qthcRD9sj4Jq4M6dFLUgfvAI3nEpotnudIM96ZiOwoeQLkrVWYuRfWkzRmgztfacj7KTQvQSTP/9rkgaLafS7JslV4W1ofE1rCgTQm8ZnyBJUTGphIJ27
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC8105720A638A488645302A1B8BF23A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a39b4d5e-14e0-4903-1cd5-08d76f1c93ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 07:21:22.6352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6PUT4tAQiGyzDLoj4LE4rTi2S98OTYLrtJIiEGlFH0zBivZtVghyXCMAnvIIvAYICcpwAyaQ4+IHqI+sVKkfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5921
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjEvMjAxOSA0OjQ0IFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+IEZyb206IERhbiBD
YXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4NCj4gRGF0ZTogV2VkLCAyMCBOb3Yg
MjAxOSAxNTozNDozOCArMDMwMA0KPg0KPj4gVGhlICJpdm0tPnZmIiB2YXJpYWJsZSBpcyBhIHUz
MiwgYnV0IHRoZSBwcm9ibGVtIGlzIHRoYXQgYSBudW1iZXIgb2YNCj4+IGRyaXZlcnMgY2FzdCBp
dCB0byBhbiBpbnQgYW5kIHRoZW4gZm9yZ2V0IHRvIGNoZWNrIGZvciBuZWdhdGl2ZXMuICBBbg0K
Pj4gZXhhbXBsZSBvZiB0aGlzIGlzIGluIHRoZSBjeGdiNCBkcml2ZXIuDQo+Pg0KPj4gZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2hlbHNpby9jeGdiNC9jeGdiNF9tYWluLmMNCj4+ICAgMjg5MCAgc3Rh
dGljIGludCBjeGdiNF9tZ210X2dldF92Zl9jb25maWcoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwN
Cj4+ICAgMjg5MSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IHZmLCBz
dHJ1Y3QgaWZsYV92Zl9pbmZvICppdmkpDQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIF5eXl5eXg0KPj4gICAyODkyICB7DQo+PiAgIDI4OTMgICAgICAgICAg
c3RydWN0IHBvcnRfaW5mbyAqcGkgPSBuZXRkZXZfcHJpdihkZXYpOw0KPj4gICAyODk0ICAgICAg
ICAgIHN0cnVjdCBhZGFwdGVyICphZGFwID0gcGktPmFkYXB0ZXI7DQo+PiAgIDI4OTUgICAgICAg
ICAgc3RydWN0IHZmX2luZm8gKnZmaW5mbzsNCj4+ICAgMjg5NiAgDQo+PiAgIDI4OTcgICAgICAg
ICAgaWYgKHZmID49IGFkYXAtPm51bV92ZnMpDQo+PiAgICAgICAgICAgICAgICAgICAgIF5eXl5e
Xl5eXl5eXl5eXl5eXl4NCj4+ICAgMjg5OCAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFM
Ow0KPj4gICAyODk5ICAgICAgICAgIHZmaW5mbyA9ICZhZGFwLT52ZmluZm9bdmZdOw0KPj4gICAg
ICAgICAgICAgICAgIF5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eDQo+Pg0KPj4gVGhlcmUgYXJl
IDQ4IGZ1bmN0aW9ucyBhZmZlY3RlZC4NCj4gIC4uLg0KPj4gU2lnbmVkLW9mZi1ieTogRGFuIENh
cnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPg0KPiBJJ20gZ29pbmcgdG8gYXBwbHkg
dGhpcyBhbmQgcXVldWUgaXQgdXAgZm9yIC1zdGFibGUuDQo+DQo+IFRoZSB1MzIgY29udmVyc2lv
biBzaG91bGQgaGFwcGVuIGluIG5leHQuDQpva2F5Lg0KV2hlbiBEYW4gcmVwb3J0ZWQsIEkgcmV2
aWV3ZWQgYW5kIHdyb3RlIHRoZSBwYXRjaCBmb3IgdTMyLCBhbmQgc29tZSBtb3JlDQpjb2RlIGNv
bnNvbGlkYXRpb24gd2l0aCBpdC4NCkJ1dCBoaXQgdGhlIGJsb2NrIHdpdGggdTMyIGxlYWRpbmcg
dG8gb3ZlcmZsb3cgdG8gMCB3aGljaCBtb2RpZmllcyB0aGUNCmZpcnN0IFZGIGluY29ycmVjdGx5
Lg0KQ2hlY2tpbmcgbnVtX3ZmcyBvZiBwY2kgZGV2LCB3aXRob3V0IGRldmljZV9sb2NrKCkgaXMg
ZXF1YWxseSBidWdneSBhcw0KaXQgc3RhbmRzIHRvZGF5Lg0KQ3JlYXRpbmcgYSBsb2NrIGluIGVh
Y2ggdmVuZG9yIGRyaXZlcihzKSBkb2Vzbid0IG1ha2Ugc2Vuc2UuDQpIYXZlbid0IGhhZCBjaGFu
Y2UgeWV0IGFmdGVyIHRoYXQuDQpMZXQgbWUga25vdyBpZiBzb21lb25lIGhhcyBhIHN1Z2dlc3Rp
b24gdGhhdCBJIHNob3VsZCBpbmNvcnBvcmF0ZS4NCg0K
