Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3FA1879C1
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 07:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgCQGg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 02:36:57 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:59587
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbgCQGg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 02:36:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8R/viJV1Uxir24Zlv2Vu3tdknIUqxYQPEkCeKjkNYy0mRTvSj1lezebjOqFN5DNtKHlWD1WfeXN0TQGmdqHUp1R6A+y3rOXGOvqCtNupGe30faIIOR1vXInbptldnt/RDOKoeRWdK9zzrprk3OTyB7Y9K5euvzvaRt9YD8EESn2S7qjWsRDpv25JVvaYfhRYroVhS92jVhkDSfC69Bo++5+RzVm1hMVEU96/uDYJAjPqkJnYKCgT9llJ/9bkmYtP6O/sI4rp8F1Wj8GFwLc00WfcDAulIeb1jLx7Op4Bdm/NW4agNYHwKFb+HLRgR05pBNsf7fRkHlFrVhv76wNWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtwgJr+/JupANyR8Bjo4kb8TBBLNawc0UCpTjWtb7b0=;
 b=OtG7IDvcrYhFcptiwBw2jT65+ARJyqdWu52Y0qbEdy0NVeKZ2LS9pl/b8CBKZN6E2Bk7uvDNWmmc4/LQQHBt08CVMmcfS/0O1YQh+c6T8WCO+ruq/HRaKmkwoFhLsJSNCFR+YP4GqnEfB0pSebHM/6YVzNhDLotYNDDdBlaoSF+LIDQax+PXYsCTbJR1/QogOy9bhuN2jTEBxNG7u059v6zdxLk4PH+MMXOVxmuMBaNYVwGCEY8dIl+4pmJuEi2m3te6LG1S6MPHtIik4nLDrUiSNsEYiv2WFhfvm+Tt93hffKflZAOJ7ZukLgay9/Yc5kpcSFAnxHqAPbmIa4ChEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtwgJr+/JupANyR8Bjo4kb8TBBLNawc0UCpTjWtb7b0=;
 b=p/MpfJQC1cXNs4sVIQbRJ2a+VafQiRie2yljSiZNpcA+DKqm7+7FFqb8txFOiueOyvO/68OEIQTcrqkkaFTFPRSD9eRrl4cb3co/GEKXK4FP8XVL+W6uDs8DHrs8fJjW9NVEnfK2V2WfJd+bFlDM3WKYvnEHHWN6cmPtoMeHzMs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6589.eurprd05.prod.outlook.com (20.179.25.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.18; Tue, 17 Mar 2020 06:36:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 06:36:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "natechancellor@gmail.com" <natechancellor@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mlx5: Remove uninitialized use of key in
 mlx5_core_create_mkey
Thread-Topic: [PATCH] mlx5: Remove uninitialized use of key in
 mlx5_core_create_mkey
Thread-Index: AQHV+9JofEO2fsSXcEevmUAlteNGUqhMVTqA
Date:   Tue, 17 Mar 2020 06:36:51 +0000
Message-ID: <1639b8bff62218c8a931ee48e01710f921bf9666.camel@mellanox.com>
References: <20200316203452.32998-1-natechancellor@gmail.com>
In-Reply-To: <20200316203452.32998-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5758010e-a11a-439c-29fc-08d7ca3d93e7
x-ms-traffictypediagnostic: VI1PR05MB6589:
x-microsoft-antispam-prvs: <VI1PR05MB6589AFF3C89D5B25568F72E7BEF60@VI1PR05MB6589.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:98;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(199004)(478600001)(110136005)(54906003)(966005)(2906002)(86362001)(81166006)(6486002)(26005)(5660300002)(8676002)(81156014)(8936002)(316002)(186003)(71200400001)(4326008)(6506007)(64756008)(66556008)(2616005)(66446008)(36756003)(76116006)(6512007)(66946007)(66476007)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6589;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dbly9omG5ad62CYkOBpvRuKvLoOPb/mtE/XfjjfIvxY4+JRcHahzTU9wHJjy/ZV5kIG8F7U+cexAoljwphiSc+5FZw3dzPGemlCO1lO4s4clekbwY+coZl2beZAg5NcIbLPYcBhsPxO5kTpv0WQXBK3mSIGnyitwiiGe1rLCaFdzgy6OauOajgra92+xHSxe/CNcOfnCH/DUqWT1jNIfSmgIbfxVB0h/upVpfphQxLF5Tc7ztBkRNTGres3hDNyiyqajM++qWdLPbspNdGw0EBm5LSn5JuVnkNWyNIruqENdmzZSy4q9L2T6gM7uuSdElnZ7sEVT9jD4tKl5mbr6EROw1QgcdYJvUoC0alUhpMhjLegPLPEf8BhWaumtqs0k3i/Gi/UG+gP+PLBqHjFFywPO8rQ2rLF7KfTxZJ6kR6FD/rTWgzpGIfxe6JT7UXHe17ERP8YySJgLQAVKBYiPbCgv0TnmJBGDUprCNausCSqrZqE6ypU1xM1id9tpb6N0X3ZM7rDVY7aty+wTgfb95A==
x-ms-exchange-antispam-messagedata: 7C7Wnv3guY5/q1+YvzrOcHkGlav2g1V/aTY3V6InDZS1jA1a3IGNIvFHk1hA/Ds3WF6GP036sZ0zX/b1cfAK00+yc5cjYpYp/YnNnHF8gY+n1UsoC+a7WxuVre226Nq3jCHDZej+s8UsiK6KRubhNg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <45442FF83533354BAB84493D59F634C3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5758010e-a11a-439c-29fc-08d7ca3d93e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 06:36:51.7781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMb6/LgTDIGVpJJNn6d4IfpaHu1T2hK7QX48DdkAzmUoYnyq8gAwFTOHkazwweyah7Qebj+zXMFQbtmhKP1PvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTE2IGF0IDEzOjM0IC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gQ2xhbmcgd2FybnM6DQo+IA0KPiAuLi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvbXIuYzo2MzoyMTogd2FybmluZzoNCj4gdmFyaWFibGUNCj4gJ2tleScgaXMg
dW5pbml0aWFsaXplZCB3aGVuIHVzZWQgaGVyZSBbLVd1bmluaXRpYWxpemVkXQ0KPiAgICAgICAg
ICAgICAgICAgICAgICAgbWtleV9pbmRleCwga2V5LCBta2V5LT5rZXkpOw0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXn5+DQo+IC4uL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9tbHg1X2NvcmUuaDo1NDo2OiBub3RlOg0KPiBleHBhbmRlZCBmcm9t
IG1hY3JvICdtbHg1X2NvcmVfZGJnJw0KPiAgICAgICAgICAgICAgICAgICMjX19WQV9BUkdTX18p
DQo+ICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fg0KPiAuLi9pbmNsdWRlL2xpbnV4L2Rl
dl9wcmludGsuaDoxMTQ6Mzk6IG5vdGU6IGV4cGFuZGVkIGZyb20gbWFjcm8NCj4gJ2Rldl9kYmcn
DQo+ICAgICAgICAgZHluYW1pY19kZXZfZGJnKGRldiwgZGV2X2ZtdChmbXQpLCAjI19fVkFfQVJH
U19fKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+
fn5+fn5+fg0KPiAuLi9pbmNsdWRlL2xpbnV4L2R5bmFtaWNfZGVidWcuaDoxNTg6MTk6IG5vdGU6
IGV4cGFuZGVkIGZyb20gbWFjcm8NCj4gJ2R5bmFtaWNfZGV2X2RiZycNCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgZGV2LCBmbXQsICMjX19WQV9BUkdTX18pDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+fn5+DQo+IC4uL2luY2x1ZGUvbGludXgv
ZHluYW1pY19kZWJ1Zy5oOjE0Mzo1Njogbm90ZTogZXhwYW5kZWQgZnJvbSBtYWNybw0KPiAnX2R5
bmFtaWNfZnVuY19jYWxsJw0KPiAgICAgICAgIF9fZHluYW1pY19mdW5jX2NhbGwoX19VTklRVUVf
SUQoZGRlYnVnKSwgZm10LCBmdW5jLA0KPiAjI19fVkFfQVJHU19fKQ0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn4N
Cj4gfn5+fg0KPiAuLi9pbmNsdWRlL2xpbnV4L2R5bmFtaWNfZGVidWcuaDoxMjU6MTU6IG5vdGU6
IGV4cGFuZGVkIGZyb20gbWFjcm8NCj4gJ19fZHluYW1pY19mdW5jX2NhbGwnDQo+ICAgICAgICAg
ICAgICAgICBmdW5jKCZpZCwgIyNfX1ZBX0FSR1NfXyk7ICAgICAgICAgICAgICAgXA0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn4NCj4gLi4vZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21yLmM6NDc6ODogbm90ZToNCj4gaW5pdGlhbGl6ZQ0K
PiB0aGUgdmFyaWFibGUgJ2tleScgdG8gc2lsZW5jZSB0aGlzIHdhcm5pbmcNCj4gICAgICAgICB1
OCBrZXk7DQo+ICAgICAgICAgICAgICAgXg0KPiAgICAgICAgICAgICAgICA9ICdcMCcNCj4gMSB3
YXJuaW5nIGdlbmVyYXRlZC4NCj4gDQo+IGtleSdzIGluaXRpYWxpemF0aW9uIHdhcyByZW1vdmVk
IGluIGNvbW1pdCBmYzZhOWY4NmYwOGENCj4gKCJ7SUIsbmV0fS9tbHg1Og0KPiBBc3NpZ24gbWtl
eSB2YXJpYW50IGluIG1seDVfaWIgb25seSIpIGJ1dCBpdHMgdXNlIHdhcyBub3QgZnVsbHkNCj4g
cmVtb3ZlZC4NCj4gUmVtb3ZlIGl0IG5vdyBzbyB0aGF0IHRoZXJlIGlzIG5vIG1vcmUgd2Fybmlu
Zy4NCj4gDQo+IEZpeGVzOiBmYzZhOWY4NmYwOGEgKCJ7SUIsbmV0fS9tbHg1OiBBc3NpZ24gbWtl
eSB2YXJpYW50IGluIG1seDVfaWINCj4gb25seSIpDQo+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNv
bS9DbGFuZ0J1aWx0TGludXgvbGludXgvaXNzdWVzLzkzMg0KPiBTaWduZWQtb2ZmLWJ5OiBOYXRo
YW4gQ2hhbmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29tPg0KPiANCg0KTEdUTQ0KDQph
cHBsaWVkIHRvIG1seDUtbmV4dA0KDQpUaGFua3MsDQpTYWVlZC4NCg==
