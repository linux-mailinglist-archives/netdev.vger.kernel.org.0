Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E97B872112
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391859AbfGWUte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:49:34 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:43244
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730760AbfGWUtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 16:49:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZL1SHSMtciq43Crw68Gvxfvf0hK69U0M958y+CzspChQW1FbdH0t/LlwAQYc6AWO9wEhLdO/r54GtGZqHJ8T1UCUPUVbGVzCsoJeiksKWnEnY2t+y+Z9aCaV4hm534nH7sJuIwM3Q6L1BbXLQzbA+N3rGzib1udzURQpjdlmEn2RilErUS2YIqFFGyojyY4lrpmkdRWfy2LpeNxLxoHmn/x8ztKaBeEpc5qXQ4kY4V9rH712/HrTKfU5cDpdAzY2IPzIbkTqCrVBBwS6tVK1Mldjc84LnSDjocrwfjazOqDzwLqdRfJAUQBIfPJutC+ievAsX15PFkS1IJ94fNr4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO1wOfk8Z4IQl0xQQjnsNA2Mgeg6sF/+vSP1KcN+JPc=;
 b=K1S3dz3FzrkLlK2XGdV6p9zxkKE8KvOEzJfMNZH5M51r46lGPsv7tiSKWP0h6gfA+dpcpeKW7DPndHN2YUOqba7rgJZ2xMYdOq0Lt6K1s7tu5k3hTIl/pJFMKrzPv03XzN2YprW/U1Ux4/YNnt9eeoQe9/rJ+wRnEBwzMwBLhBaLX2MixVr0fGjTrkC4PBuRc9+xFsezTQk4g/KJdXkx6aOLs6finz+LcTiCZxO9k2aRSXlZH0x3iVZYkvY5smqE2a1wKIeyfgJgi9wqzJhwadMFBmwXvjJWeEn4UnOdosxIj1IWShKl1FCmWQxaHDXWC9ik3C2n25J3DRIn80WcrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gO1wOfk8Z4IQl0xQQjnsNA2Mgeg6sF/+vSP1KcN+JPc=;
 b=L6Gdv3bjbzeVzy5695IPoXaywBizMvaJJAx/56hMJxTLyq3VSYa29DNF/TGhQIFM7tZWwGRVOyIakfs9stMWU2odjKtlcPQy/G8SohHxt7adD0bqLkz65UnVqTIPXA1cQ9J+oUJyAZEDydWGJBmtD8sX7iqbOPXYAnkx5S1caPU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2517.eurprd05.prod.outlook.com (10.168.77.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 20:49:27 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 20:49:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "leoyang.li@nxp.com" <leoyang.li@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexandru.marginean@nxp.com" <alexandru.marginean@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe MDIO
 endpoint
Thread-Topic: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Thread-Index: AQHVQWmdXX+sxQto9UCSZSuFYsFM0KbYrWaA
Date:   Tue, 23 Jul 2019 20:49:27 +0000
Message-ID: <2e3c565cacae6050656aeb7c0132736c60f9f4ee.camel@mellanox.com>
References: <1563894955-545-1-git-send-email-claudiu.manoil@nxp.com>
         <1563894955-545-2-git-send-email-claudiu.manoil@nxp.com>
In-Reply-To: <1563894955-545-2-git-send-email-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a3aae89-78d3-459c-b7f0-08d70faf40c2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2517;
x-ms-traffictypediagnostic: DB6PR0501MB2517:
x-microsoft-antispam-prvs: <DB6PR0501MB2517177F7BCB8D23709CC331BEC70@DB6PR0501MB2517.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(199004)(189003)(76176011)(2501003)(6436002)(478600001)(6486002)(25786009)(53936002)(91956017)(66066001)(76116006)(14454004)(6512007)(229853002)(86362001)(66556008)(66446008)(66946007)(5660300002)(66476007)(6246003)(54906003)(7736002)(81166006)(8936002)(36756003)(305945005)(8676002)(4326008)(64756008)(2906002)(81156014)(71190400001)(71200400001)(58126008)(26005)(6116002)(476003)(2616005)(14444005)(256004)(3846002)(68736007)(6506007)(99286004)(486006)(11346002)(446003)(186003)(110136005)(316002)(118296001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2517;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /y8sT8PDmbl5oBN600Wwt3AdOS0+7shfz643TgniVMG9XOj4/3ABjEa1cjYNXT81M6s9kOd56xKIGRDbwAmI7MB7AYzjyWlDogbDQOGnvvI1AMivAcDTAdoo2lqlotsMfhRU4SzstKJE7+o3WNexSPGHSZfCSbj4eM4dzD8ct5uM4YrLjFjewrFi3ULGIxr87rYaESMrKeEfQ0gfekYJ6hWBTPYtITf7pfTEH38htuR6YZbAYTPKPhHKxvsxv3VUQZwSaCqMXRC1kIWdHPPGMEpR0n2MjzeJVgl4VaQYC3RUIgzWiYly25C2MzhTC9aLEOaq9g6kkJgP6ZoUTJpFXy5V/X0iRId8r7MeXfvQuMSCwlEm6dkkchGwfPT8j+V1npPRAzJJsPB5aPeD0sYo2NFyFdPQL0aOTgf8RUL6nn4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E131E465F5E195408AFDA8F176CF2B58@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3aae89-78d3-459c-b7f0-08d70faf40c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 20:49:27.4341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2517
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDE4OjE1ICswMzAwLCBDbGF1ZGl1IE1hbm9pbCB3cm90ZToN
Cj4gRU5FVEMgcG9ydHMgY2FuIG1hbmFnZSB0aGUgTURJTyBidXMgdmlhIGxvY2FsIHJlZ2lzdGVy
DQo+IGludGVyZmFjZS4gIEhvd2V2ZXIgdGhlcmUncyBhbHNvIGEgY2VudHJhbGl6ZWQgd2F5DQo+
IHRvIG1hbmFnZSB0aGUgTURJTyBidXMsIHZpYSB0aGUgTURJTyBQQ0llIGVuZHBvaW50DQo+IGRl
dmljZSBpbnRlZ3JhdGVkIGJ5IHRoZSBzYW1lIHJvb3QgY29tcGxleCB0aGF0IGFsc28NCj4gaW50
ZWdyYXRlcyB0aGUgRU5FVEMgcG9ydHMgKGV0aCBjb250cm9sbGVycykuDQo+IA0KPiBEZXBlbmRp
bmcgb24gYm9hcmQgZGVzaWduIGFuZCB1c2UgY2FzZSwgY2VudHJhbGl6ZWQNCj4gYWNjZXNzIHRv
IE1ESU8gbWF5IGJlIGJldHRlciB0aGFuIHVzaW5nIGxvY2FsIEVORVRDDQo+IHBvcnQgcmVnaXN0
ZXJzLiAgRm9yIGluc3RhbmNlLCBvbiB0aGUgTFMxMDI4QSBRRFMgYm9hcmQNCj4gd2hlcmUgTURJ
TyBtdXhpbmcgaXMgcmVxdWllcmVkLiAgQWxzbywgdGhlIExTMTAyOEEgb24tY2hpcA0KPiBzd2l0
Y2ggZG9lc24ndCBoYXZlIGEgbG9jYWwgTURJTyByZWdpc3RlciBpbnRlcmZhY2UuDQo+IA0KPiBU
aGUgY3VycmVudCBwYXRjaCByZWdpc3RlcnMgdGhlIGFib3ZlIFBDSWUgZW5wb2ludCBhcyBhDQo+
IHNlcGFyYXRlIE1ESU8gYnVzIGFuZCBwcm92aWRlcyBhIGRyaXZlciBmb3IgaXQgYnkgcmUtdXNp
bmcNCj4gdGhlIGNvZGUgdXNlZCBmb3IgbG9jYWwgTURJTyBhY2Nlc3MuICBJdCBhbHNvIGFsbG93
cyB0aGUNCj4gRU5FVEMgcG9ydCBQSFlzIHRvIGJlIG1hbmFnZWQgYnkgdGhpcyBkcml2ZXIgaWYg
dGhlIGxvY2FsDQo+ICJtZGlvIiBub2RlIGlzIG1pc3NpbmcgZnJvbSB0aGUgRU5FVEMgcG9ydCBu
b2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2ls
QG54cC5jb20+DQo+IC0tLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5l
dGNfbWRpby5jIHwgOTANCj4gKysrKysrKysrKysrKysrKysrKw0KPiAgLi4uL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYyAgIHwgIDUgKy0NCj4gIDIgZmlsZXMgY2hhbmdl
ZCwgOTQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19tZGlvLmMNCj4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfbWRpby5jDQo+IGluZGV4IDc3
YjljZDEwYmEyYi4uZWZhOGEyOWY0NjNkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfbWRpby5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19tZGlvLmMNCj4gQEAgLTE5NywzICsxOTcsOTMg
QEAgdm9pZCBlbmV0Y19tZGlvX3JlbW92ZShzdHJ1Y3QgZW5ldGNfcGYgKnBmKQ0KPiAgCQltZGlv
YnVzX2ZyZWUocGYtPm1kaW8pOw0KPiAgCX0NCj4gIH0NCj4gKw0KPiArI2RlZmluZSBFTkVUQ19N
RElPX0RFVl9JRAkweGVlMDENCj4gKyNkZWZpbmUgRU5FVENfTURJT19ERVZfTkFNRQkiRlNMIFBD
SWUgSUUgQ2VudHJhbCBNRElPIg0KPiArI2RlZmluZSBFTkVUQ19NRElPX0JVU19OQU1FCUVORVRD
X01ESU9fREVWX05BTUUgIiBCdXMiDQo+ICsjZGVmaW5lIEVORVRDX01ESU9fRFJWX05BTUUJRU5F
VENfTURJT19ERVZfTkFNRSAiIGRyaXZlciINCj4gKyNkZWZpbmUgRU5FVENfTURJT19EUlZfSUQJ
ImZzbF9lbmV0Y19tZGlvIg0KPiArDQo+ICtzdGF0aWMgaW50IGVuZXRjX3BjaV9tZGlvX3Byb2Jl
KHN0cnVjdCBwY2lfZGV2ICpwZGV2LA0KPiArCQkJCWNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lk
ICplbnQpDQo+ICt7DQo+ICsJc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldjsNCj4gKwlz
dHJ1Y3QgbWlpX2J1cyAqYnVzOw0KPiArCWludCBlcnI7DQo+ICsNCj4gKwlidXMgPSBtZGlvYnVz
X2FsbG9jX3NpemUoc2l6ZW9mKHUzMiAqKSk7DQo+ICsJaWYgKCFidXMpDQo+ICsJCXJldHVybiAt
RU5PTUVNOw0KPiArDQo+ICsJYnVzLT5uYW1lID0gRU5FVENfTURJT19CVVNfTkFNRTsNCj4gKwli
dXMtPnJlYWQgPSBlbmV0Y19tZGlvX3JlYWQ7DQo+ICsJYnVzLT53cml0ZSA9IGVuZXRjX21kaW9f
d3JpdGU7DQo+ICsJYnVzLT5wYXJlbnQgPSBkZXY7DQo+ICsJc25wcmludGYoYnVzLT5pZCwgTUlJ
X0JVU19JRF9TSVpFLCAiJXMiLCBkZXZfbmFtZShkZXYpKTsNCj4gKw0KPiArCXBjaWVfZmxyKHBk
ZXYpOw0KPiArCWVyciA9IHBjaV9lbmFibGVfZGV2aWNlX21lbShwZGV2KTsNCj4gKwlpZiAoZXJy
KSB7DQo+ICsJCWRldl9lcnIoZGV2LCAiZGV2aWNlIGVuYWJsZSBmYWlsZWRcbiIpOw0KDQptZGlv
YnVzX2ZyZWUoYnVzKSBpcyBtaXNzaW5nIGhlcmUgYW5kIGluIGV2ZXJ5IGVycm9yIHBhdGguDQoN
Cj4gKwkJcmV0dXJuIGVycjsNCj4gKwl9DQo+ICsNCj4gKwllcnIgPSBwY2lfcmVxdWVzdF9tZW1f
cmVnaW9ucyhwZGV2LCBFTkVUQ19NRElPX0RSVl9JRCk7DQo+ICsJaWYgKGVycikgew0KPiArCQlk
ZXZfZXJyKGRldiwgInBjaV9yZXF1ZXN0X3JlZ2lvbnMgZmFpbGVkXG4iKTsNCj4gKwkJZ290byBl
cnJfcGNpX21lbV9yZWc7DQo+ICsJfQ0KPiArDQo+ICsJYnVzLT5wcml2ID0gcGNpX2lvbWFwX3Jh
bmdlKHBkZXYsIDAsIEVORVRDX01ESU9fUkVHX09GRlNFVCwgMCk7DQo+ICsJaWYgKCFidXMtPnBy
aXYpIHsNCj4gKwkJZXJyID0gLUVOWElPOw0KPiArCQlkZXZfZXJyKGRldiwgImlvcmVtYXAgZmFp
bGVkXG4iKTsNCj4gKwkJZ290byBlcnJfaW9yZW1hcDsNCj4gKwl9DQo+ICsNCj4gKwllcnIgPSBv
Zl9tZGlvYnVzX3JlZ2lzdGVyKGJ1cywgZGV2LT5vZl9ub2RlKTsNCj4gKwlpZiAoZXJyKQ0KPiAr
CQlnb3RvIGVycl9tZGlvYnVzX3JlZzsNCj4gKw0KPiArCXBjaV9zZXRfZHJ2ZGF0YShwZGV2LCBi
dXMpOw0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICsNCj4gK2Vycl9tZGlvYnVzX3JlZzoNCj4gKwlp
b3VubWFwKGJ1cy0+cHJpdik7DQo+ICtlcnJfaW9yZW1hcDoNCj4gKwlwY2lfcmVsZWFzZV9tZW1f
cmVnaW9ucyhwZGV2KTsNCj4gK2Vycl9wY2lfbWVtX3JlZzoNCj4gKwlwY2lfZGlzYWJsZV9kZXZp
Y2UocGRldik7DQo+ICsNCj4gKwlyZXR1cm4gZXJyOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9p
ZCBlbmV0Y19wY2lfbWRpb19yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpDQo+ICt7DQo+ICsJ
c3RydWN0IG1paV9idXMgKmJ1cyA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gKw0KPiArCW1k
aW9idXNfdW5yZWdpc3RlcihidXMpOw0KPiArCWlvdW5tYXAoYnVzLT5wcml2KTsNCj4gKwltZGlv
YnVzX2ZyZWUoYnVzKTsNCj4gKw0KDQp0aGlzIHNob3VsZCBjb21lIGxhc3QgdG8gYmUgc3ltbWV0
cmljYWwgd2l0aCBwcm9iZSBmbG93Lg0KDQo+ICsJcGNpX3JlbGVhc2VfbWVtX3JlZ2lvbnMocGRl
dik7DQo+ICsJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMg
Y29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgZW5ldGNfcGNpX21kaW9faWRfdGFibGVbXSA9IHsN
Cj4gKwl7IFBDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9GUkVFU0NBTEUsIEVORVRDX01ESU9fREVW
X0lEKSB9LA0KPiArCXsgMCwgfSAvKiBFbmQgb2YgdGFibGUuICovDQo+ICt9Ow0KPiArTU9EVUxF
X0RFVklDRV9UQUJMRShwY2ksIGVuZXRjX21kaW9faWRfdGFibGUpOw0KPiArDQo+ICtzdGF0aWMg
c3RydWN0IHBjaV9kcml2ZXIgZW5ldGNfcGNpX21kaW9fZHJpdmVyID0gew0KPiArCS5uYW1lID0g
RU5FVENfTURJT19EUlZfSUQsDQo+ICsJLmlkX3RhYmxlID0gZW5ldGNfcGNpX21kaW9faWRfdGFi
bGUsDQo+ICsJLnByb2JlID0gZW5ldGNfcGNpX21kaW9fcHJvYmUsDQo+ICsJLnJlbW92ZSA9IGVu
ZXRjX3BjaV9tZGlvX3JlbW92ZSwNCj4gK307DQo+ICttb2R1bGVfcGNpX2RyaXZlcihlbmV0Y19w
Y2lfbWRpb19kcml2ZXIpOw0KPiArDQo+ICtNT0RVTEVfREVTQ1JJUFRJT04oRU5FVENfTURJT19E
UlZfTkFNRSk7DQo+ICtNT0RVTEVfTElDRU5TRSgiRHVhbCBCU0QvR1BMIik7DQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYw0KPiBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19wZi5jDQo+IGluZGV4
IDI1OGIzY2IzOGE2Zi4uN2Q2NTEzZmY4NTA3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYw0KPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYw0KPiBAQCAtNzUwLDYgKzc1MCw3IEBA
IHN0YXRpYyBpbnQgZW5ldGNfb2ZfZ2V0X3BoeShzdHJ1Y3QNCj4gZW5ldGNfbmRldl9wcml2ICpw
cml2KQ0KPiAgew0KPiAgCXN0cnVjdCBlbmV0Y19wZiAqcGYgPSBlbmV0Y19zaV9wcml2KHByaXYt
PnNpKTsNCj4gIAlzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wID0gcHJpdi0+ZGV2LT5vZl9ub2RlOw0K
PiArCXN0cnVjdCBkZXZpY2Vfbm9kZSAqbWRpb19ucDsNCj4gIAlpbnQgZXJyOw0KPiAgDQo+ICAJ
aWYgKCFucCkgew0KPiBAQCAtNzczLDcgKzc3NCw5IEBAIHN0YXRpYyBpbnQgZW5ldGNfb2ZfZ2V0
X3BoeShzdHJ1Y3QNCj4gZW5ldGNfbmRldl9wcml2ICpwcml2KQ0KPiAgCQlwcml2LT5waHlfbm9k
ZSA9IG9mX25vZGVfZ2V0KG5wKTsNCj4gIAl9DQo+ICANCj4gLQlpZiAoIW9mX3BoeV9pc19maXhl
ZF9saW5rKG5wKSkgew0KPiArCW1kaW9fbnAgPSBvZl9nZXRfY2hpbGRfYnlfbmFtZShucCwgIm1k
aW8iKTsNCj4gKwlpZiAobWRpb19ucCkgew0KPiArCQlvZl9ub2RlX3B1dChtZGlvX25wKTsNCj4g
IAkJZXJyID0gZW5ldGNfbWRpb19wcm9iZShwZik7DQo+ICAJCWlmIChlcnIpIHsNCj4gIAkJCW9m
X25vZGVfcHV0KHByaXYtPnBoeV9ub2RlKTsNCg==
