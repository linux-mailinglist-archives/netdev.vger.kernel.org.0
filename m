Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9863824D3
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfHESXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:23:12 -0400
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:10817
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726779AbfHESXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:23:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx/fCOtHqlUSUT8C3ACC9iW6LXYid2UaPsLP+yoxZCK1VgzQaqtXhvnQnUjUWBaSav+ORUE2Eh6RRTMMoufMfSvOHfqBwbJ+Ltk3VnNTR68XTZU9EIS/GtY0cMaNukRSe1wNom5Hvbpc4tLH6wdqrhKiqcXQDm/m10qpenUI2wtHjTsMXZEJujAQRWJsW2pSXwU5wm38j851CAPW14UYLRMxXxM/wzdSQ5D7v/Esgbnt3SgFsk9wtygCNBLGOloaROaQcN3pKDtoTSQ2G1vWyvh4zng/cqHsplhGsPB7uuhPh+stuBQt+0QyPJd1beWwPN+DZULiKyuUDhoqdTuIYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7oei5bu9QLyjv2pPKsvFYoc3pZXJBvDc51IvP8nEKM=;
 b=OlX5ItZ4VesZUyzzLgGoBVMb/FL42KCAqqVEJUo50zRefwFIDT6bDaxIM1mok0mTlF+4wlhdojj8hXPhu5vMmCP8qulg0Wkz9RTNMwW+0/bbadNLKtuKoMKsFnCR0Q9BKHbce1koJ6lmC0YM/F2xNJKgeSjjT/cUDZQiqkwEcA+708EKGnDm31ysVxwH6KPBF7HHA2r0C3oT5UcSc7jiW/91XnBUKPcXEfVK5JZGRL6nPNqRw/PpFHWlsx2ujAepMUnemMkv96FIFZRdPoNBr03ydFZUhiEII2fTltUBMbDhaMXqEYiA5XKPGuVtBCGkY/5aniM1aESUq81eXdk39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7oei5bu9QLyjv2pPKsvFYoc3pZXJBvDc51IvP8nEKM=;
 b=rFxypfEdfbqW6AKp+bxKeWC5FiWLjJxiGdvbcXBuyJKB/QsUMlmI9vtrfVbuzR1XcPenqCxZpGhZPk2+F6oUIJ2KWlES2Cxv6jCy+IcVTv0odVO0C5J9tA2+ym4fEQHrpFxzSAWBwbOvUYjqDpv95vwH5gb1rgsbVCjm+aaTiq4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2246.eurprd05.prod.outlook.com (10.168.55.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Mon, 5 Aug 2019 18:23:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 18:23:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
CC:     Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v1 1/3] IB/mlx5: Query ODP capabilities for DC
Thread-Topic: [PATCH mlx5-next v1 1/3] IB/mlx5: Query ODP capabilities for DC
Thread-Index: AQHVSquH7cBiw3thB0e75f2KBPTPqabs4EoA
Date:   Mon, 5 Aug 2019 18:23:04 +0000
Message-ID: <d3b21502d398fc3bf2cf38231ca84c1bb0386b17.camel@mellanox.com>
References: <20190804100048.32671-1-leon@kernel.org>
         <20190804100048.32671-2-leon@kernel.org>
In-Reply-To: <20190804100048.32671-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cf445f8-c072-4b6b-77f5-08d719d1f4f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2246;
x-ms-traffictypediagnostic: DB6PR0501MB2246:
x-microsoft-antispam-prvs: <DB6PR0501MB2246EA4DE2428F07510F8B2CBEDA0@DB6PR0501MB2246.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(189003)(199004)(54906003)(14454004)(476003)(2616005)(71190400001)(71200400001)(486006)(11346002)(446003)(6246003)(25786009)(86362001)(4326008)(68736007)(2201001)(118296001)(316002)(36756003)(478600001)(58126008)(76116006)(305945005)(7736002)(26005)(229853002)(6512007)(3846002)(6116002)(110136005)(186003)(6486002)(66946007)(5660300002)(64756008)(66446008)(66556008)(2906002)(66476007)(102836004)(6436002)(53936002)(99286004)(66066001)(81156014)(81166006)(8676002)(6506007)(14444005)(91956017)(256004)(76176011)(2501003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2246;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EpqJHVrWxM4c8XJIT33w59igxNc+8WQ36emGsSlnS0kTRZgThxuGx8Od3+N5gxXlT5zPfm1b6Y4MMhnCpmgtTJId9PEkVIsyFmbQl03zJmnahswgrBEAoZal9wxZZ7TEOp9NbhXqBtj5X4IJ8orvO0f2FUsDhopMHGWngZIgM5Rn5Xqxhk3mtq3sZPTZGhom31LgVkO4OX/H/3pV/OMJwd/2a9fRY6Sm8FSex4KIhQC9wPGLB8OT13aNQ2UJkhUA0FxbCtIhwj/2fYhR5QbR5ZhDCC3Zyz98WxdFMctwprjjxqgp6i153g4GRNzEkTp+Qsr/dc+52Oxk3QOEhHeUMP2BxjuFOXFkECen6PWBUXVf1/sJlbqE/0hJ7HgQCtFt/y96f4SPo42L1Hi0abqKFi5OnwgSRjcftL/CRh2UcWY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68D93B727C9CD44486D0D945ED388294@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf445f8-c072-4b6b-77f5-08d719d1f4f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 18:23:04.2922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDE5LTA4LTA0IGF0IDEzOjAwICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IEZyb206IE1pY2hhZWwgR3VyYWxuaWsgPG1pY2hhZWxndXJAbWVsbGFub3guY29tPg0KPiAN
Cj4gU2V0IGN1cnJlbnQgY2FwYWJpbGl0aWVzIG9mIE9EUCBmb3IgREMgdG8gbWF4IGNhcGFiaWxp
dGllcyBhbmQgY2FjaGUNCj4gdGhlbSBpbiBtbHg1X2liLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
TWljaGFlbCBHdXJhbG5payA8bWljaGFlbGd1ckBtZWxsYW5veC5jb20+DQo+IFJldmlld2VkLWJ5
OiBNb25pIFNob3VhIDxtb25pc0BtZWxsYW5veC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IExlb24g
Um9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2luZmlu
aWJhbmQvaHcvbWx4NS9tbHg1X2liLmggICAgICAgICAgIHwgIDEgKw0KPiAgZHJpdmVycy9pbmZp
bmliYW5kL2h3L21seDUvb2RwLmMgICAgICAgICAgICAgICB8IDE4IA0KPiArKysrKysrKysrKysr
KysrKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMg
fCAgNiArKysrKysNCj4gIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAgICAg
ICAgICAgfCAgNCArKystDQoNClBsZWFzZSBhdm9pZCBjcm9zcyB0cmVlIGNoYW5nZXMgd2hlbiB5
b3UgY2FuLi4gDQpIZXJlIHlvdSBkbyBjYW4gYXZvaWQgaXQsIHNvIHBsZWFzZSBzZXBhcmF0ZSB0
byB0d28gc3RhZ2UgcGF0Y2hlcywNCm1seDVfaWZjIGFuZCBjb3JlLCB0aGVuIG1seDVfaWIuDQoN
Cg0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9pYi5oDQo+
IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9pYi5oDQo+IGluZGV4IGNiNDFhN2U2
MjU1YS4uZjk5YzcxYjNjODc2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcv
bWx4NS9tbHg1X2liLmgNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWx4NV9p
Yi5oDQo+IEBAIC05NjcsNiArOTY3LDcgQEAgc3RydWN0IG1seDVfaWJfZGV2IHsNCj4gIAlzdHJ1
Y3QgbXV0ZXgJCQlzbG93X3BhdGhfbXV0ZXg7DQo+ICAJaW50CQkJCWZpbGxfZGVsYXk7DQo+ICAJ
c3RydWN0IGliX29kcF9jYXBzCW9kcF9jYXBzOw0KPiArCXVpbnQzMl90CQlkY19vZHBfY2FwczsN
Cj4gIAl1NjQJCQlvZHBfbWF4X3NpemU7DQo+ICAJc3RydWN0IG1seDVfaWJfcGZfZXEJb2RwX3Bm
X2VxOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9vZHAu
Yw0KPiBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L29kcC5jDQo+IGluZGV4IGIwYzVkZTM5
ZDE4Ni4uNWU4N2E1ZTI1NTc0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcv
bWx4NS9vZHAuYw0KPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9vZHAuYw0KPiBA
QCAtMzUzLDYgKzM1MywyNCBAQCB2b2lkIG1seDVfaWJfaW50ZXJuYWxfZmlsbF9vZHBfY2Fwcyhz
dHJ1Y3QNCj4gbWx4NV9pYl9kZXYgKmRldikNCj4gIAlpZiAoTUxYNV9DQVBfT0RQKGRldi0+bWRl
diwgeHJjX29kcF9jYXBzLnNycV9yZWNlaXZlKSkNCj4gIAkJY2Fwcy0+cGVyX3RyYW5zcG9ydF9j
YXBzLnhyY19vZHBfY2FwcyB8PQ0KPiBJQl9PRFBfU1VQUE9SVF9TUlFfUkVDVjsNCj4gIA0KPiAr
CWlmIChNTFg1X0NBUF9PRFAoZGV2LT5tZGV2LCBkY19vZHBfY2Fwcy5zZW5kKSkNCj4gKwkJZGV2
LT5kY19vZHBfY2FwcyB8PSBJQl9PRFBfU1VQUE9SVF9TRU5EOw0KPiArDQo+ICsJaWYgKE1MWDVf
Q0FQX09EUChkZXYtPm1kZXYsIGRjX29kcF9jYXBzLnJlY2VpdmUpKQ0KPiArCQlkZXYtPmRjX29k
cF9jYXBzIHw9IElCX09EUF9TVVBQT1JUX1JFQ1Y7DQo+ICsNCj4gKwlpZiAoTUxYNV9DQVBfT0RQ
KGRldi0+bWRldiwgZGNfb2RwX2NhcHMud3JpdGUpKQ0KPiArCQlkZXYtPmRjX29kcF9jYXBzIHw9
IElCX09EUF9TVVBQT1JUX1dSSVRFOw0KPiArDQo+ICsJaWYgKE1MWDVfQ0FQX09EUChkZXYtPm1k
ZXYsIGRjX29kcF9jYXBzLnJlYWQpKQ0KPiArCQlkZXYtPmRjX29kcF9jYXBzIHw9IElCX09EUF9T
VVBQT1JUX1JFQUQ7DQo+ICsNCj4gKwlpZiAoTUxYNV9DQVBfT0RQKGRldi0+bWRldiwgZGNfb2Rw
X2NhcHMuYXRvbWljKSkNCj4gKwkJZGV2LT5kY19vZHBfY2FwcyB8PSBJQl9PRFBfU1VQUE9SVF9B
VE9NSUM7DQo+ICsNCj4gKwlpZiAoTUxYNV9DQVBfT0RQKGRldi0+bWRldiwgZGNfb2RwX2NhcHMu
c3JxX3JlY2VpdmUpKQ0KPiArCQlkZXYtPmRjX29kcF9jYXBzIHw9IElCX09EUF9TVVBQT1JUX1NS
UV9SRUNWOw0KPiArDQo+ICAJaWYgKE1MWDVfQ0FQX0dFTihkZXYtPm1kZXYsIGZpeGVkX2J1ZmZl
cl9zaXplKSAmJg0KPiAgCSAgICBNTFg1X0NBUF9HRU4oZGV2LT5tZGV2LCBudWxsX21rZXkpICYm
DQo+ICAJICAgIE1MWDVfQ0FQX0dFTihkZXYtPm1kZXYsIHVtcl9leHRlbmRlZF90cmFuc2xhdGlv
bl9vZmZzZXQpKQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9tYWluLmMNCj4gaW5kZXggYjE1YjI3YTQ5N2ZjLi4zOTk1ZmM2ZDRkMzQgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYw0KPiBA
QCAtNDk1LDYgKzQ5NSwxMiBAQCBzdGF0aWMgaW50IGhhbmRsZV9oY2FfY2FwX29kcChzdHJ1Y3QN
Cj4gbWx4NV9jb3JlX2RldiAqZGV2KQ0KPiAgCU9EUF9DQVBfU0VUX01BWChkZXYsIHhyY19vZHBf
Y2Fwcy53cml0ZSk7DQo+ICAJT0RQX0NBUF9TRVRfTUFYKGRldiwgeHJjX29kcF9jYXBzLnJlYWQp
Ow0KPiAgCU9EUF9DQVBfU0VUX01BWChkZXYsIHhyY19vZHBfY2Fwcy5hdG9taWMpOw0KPiArCU9E
UF9DQVBfU0VUX01BWChkZXYsIGRjX29kcF9jYXBzLnNycV9yZWNlaXZlKTsNCj4gKwlPRFBfQ0FQ
X1NFVF9NQVgoZGV2LCBkY19vZHBfY2Fwcy5zZW5kKTsNCj4gKwlPRFBfQ0FQX1NFVF9NQVgoZGV2
LCBkY19vZHBfY2Fwcy5yZWNlaXZlKTsNCj4gKwlPRFBfQ0FQX1NFVF9NQVgoZGV2LCBkY19vZHBf
Y2Fwcy53cml0ZSk7DQo+ICsJT0RQX0NBUF9TRVRfTUFYKGRldiwgZGNfb2RwX2NhcHMucmVhZCk7
DQo+ICsJT0RQX0NBUF9TRVRfTUFYKGRldiwgZGNfb2RwX2NhcHMuYXRvbWljKTsNCj4gIA0KPiAg
CWlmIChkb19zZXQpDQo+ICAJCWVyciA9IHNldF9jYXBzKGRldiwgc2V0X2N0eCwgc2V0X3N6LA0K
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCj4gYi9pbmNsdWRl
L2xpbnV4L21seDUvbWx4NV9pZmMuaA0KPiBpbmRleCBlYzU3MWZkN2ZjZjguLjVlYWU4ZDczNDQz
NSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCj4gKysrIGIv
aW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCj4gQEAgLTk0NCw3ICs5NDQsOSBAQCBzdHJ1
Y3QgbWx4NV9pZmNfb2RwX2NhcF9iaXRzIHsNCj4gIA0KPiAgCXN0cnVjdCBtbHg1X2lmY19vZHBf
cGVyX3RyYW5zcG9ydF9zZXJ2aWNlX2NhcF9iaXRzDQo+IHhyY19vZHBfY2FwczsNCj4gIA0KPiAt
CXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMTAwWzB4NzAwXTsNCj4gKwlzdHJ1Y3QgbWx4NV9pZmNf
b2RwX3Blcl90cmFuc3BvcnRfc2VydmljZV9jYXBfYml0cyBkY19vZHBfY2FwczsNCj4gKw0KPiAr
CXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMTAwWzB4NkUwXTsNCg0KcmVzZXJ2ZWRfYXRfMTAwIHNo
b3VsZCBtb3ZlIDIwIGJpdCBmb3J3YXJkLiBpLmUgcmVzZXJ2ZWRfYXRfMTIwDQoNCg0K
