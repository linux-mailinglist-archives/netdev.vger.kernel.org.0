Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7EED9EFE9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfH0QQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:16:34 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:8768
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbfH0QQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:16:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+rhIAgDXNgiYKIWkcJ9McbfpVVIJz0ku8AK7H0D6+KWK52DjI5phpJ9UBWNrI1YWBIaNQIiAGu0ZdJncEb32C+SpGFFurO3ayGfxNYqQA38edh0arD/Xk5NvnsE/bTzMNJKWud7b3CjigbU0beglL5ziombQiRBg7yMbLHZleOvkNI1s37hLQeBmte1/d+1VZhsqn6yILTTJO7VubDzKRr7nDuQbUOyJIZbX3TYU4WfirnmcFObUOMZXiA7KHA2UUGSXfmiaUXCgWWpMbS2FXbnnrthEi2li87UK3DG5mA0iHfY8345r8uVBmBrTOcyyfMSnemfIddKpE+Uq7Gonw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIJaeLXMr+YUYArp4PSY4v8NdvFu6NcbH6xow94hfCE=;
 b=Lz7wikcdpMfCMrYpKZ29dz/3d7KRKZUUAADBqbcXuqWSjXfFl9gy3qDZnZ9jQpdVjqnlw6oqB55+zbMQU8ijUXfqph97CKgIaRu5Goj9qJ4gHzOhpof+9+htYPour92/I8cWAYI7+IdEV6dHIdYaTzc5wOi0t7KABpQEMJ/ecycEcZYIJ9c/5iNoE4rnxoqI31ltKpirHF+EijRHk9mB+nBIGHciUeoe5DriPS303qC+53ELUIKEK2Co/CWwjISda+f+qBAD0Gzr6rBw4A1nfV6sZtcsuuvT/Vju23ttjptgGTGbmjldnBS3Ev8zgniW1K0E5rjrcTNxv0XbqBohzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIJaeLXMr+YUYArp4PSY4v8NdvFu6NcbH6xow94hfCE=;
 b=qXeND3FgVyUhSKkouW/BR9Km+dQGXWt7S4femVf5+b5HA1yhqA07+Uc2K1/Hi/wXebuNqMyrhxxHknT55LmxQUXOhX+klodveVSLfIkxt1UzMaZGrWgD8EjekhcgZt741CCbnCH+mjiWrJnhyapIcQGqaL7JwkOCQaSZKBI1x3A=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5155.eurprd05.prod.outlook.com (20.178.18.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Tue, 27 Aug 2019 16:16:28 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 16:16:28 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Mark Bloch <markb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXE627FcLaFBgXUa8jSc95m92WKcOC/2AgABaVPCAALfnAIAADiQA
Date:   Tue, 27 Aug 2019 16:16:27 +0000
Message-ID: <AM0PR05MB4866148E1652A20E43260C35D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
        <6601940a-4832-08d2-e0f6-f9ac24758cdc@mellanox.com>
        <AM0PR05MB4866BB4736D265EF28280014D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827092346.66bb73f1@x1.home>
In-Reply-To: <20190827092346.66bb73f1@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cec361c7-7880-48f2-177a-08d72b09ea7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5155;
x-ms-traffictypediagnostic: AM0PR05MB5155:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5155108B6107897482D14036D1A00@AM0PR05MB5155.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(13464003)(9456002)(5660300002)(8676002)(6436002)(66946007)(66476007)(66556008)(64756008)(76116006)(6246003)(55016002)(66446008)(9686003)(53936002)(33656002)(256004)(66066001)(14444005)(186003)(2906002)(86362001)(99286004)(102836004)(486006)(11346002)(446003)(6506007)(81166006)(7696005)(52536014)(55236004)(14454004)(316002)(476003)(26005)(53546011)(54906003)(76176011)(8936002)(7736002)(74316002)(305945005)(4326008)(71200400001)(229853002)(478600001)(81156014)(71190400001)(6916009)(25786009)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5155;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ihnyds2WgWM+pQl4MLiC9Ivu5eGm/ctNU4T5/L0XlHq3Q5U6hfbzbevwEe5p+F9rntoPAWebBMMWE0s+CDDotivd3bTQHLmtvfqyMhld+fS5jVHqAm8RlSumbJPp8JOfOxT9m1ApIre7ophV/smSvqz9HRXaiLOJN6z9keGl9Ymn2EqwAn272PovWoWyx3Pl+9rHsSVs/jo6j8XZL3b2bN3MOC9/GSCkF2gv7HejI95gg7lfs04RRAltLH0DGQ/sYc89UyKO/xu65xC4gKr0kPKghKP239vqZwVdJDcL89W0SpDt+MmR37IeH+W8Yf5QOOvpNgjYq5pYgpa/Rhxgy19aVw0X7nwAJrhQKiKclKoRuwlrIpTYu4gzQC/Z9oyL8n1qwW0bTvLBvDOIOFAhCGWT+/LjITBJANHH9GmDCnU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cec361c7-7880-48f2-177a-08d72b09ea7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 16:16:28.1172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ek6AoGw7IcFdrbE1hEe63VxWEaXgEalvSi+UrB7qmy8emXGBNXOgkwMcvoKRzTQE3dNQyBeM6M57PycvxZZmcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleCBXaWxsaWFtc29u
IDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDI3
LCAyMDE5IDg6NTQgUE0NCj4gVG86IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0K
PiBDYzogTWFyayBCbG9jaCA8bWFya2JAbWVsbGFub3guY29tPjsgSmlyaSBQaXJrbyA8amlyaUBt
ZWxsYW5veC5jb20+Ow0KPiBrd2Fua2hlZGVAbnZpZGlhLmNvbTsgY29odWNrQHJlZGhhdC5jb207
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtQQVRDSCAyLzRdIG1kZXY6IE1ha2UgbWRldiBhbGlhcyB1bmlxdWUgYW1vbmcgYWxsIG1kZXZz
DQo+IA0KPiBPbiBUdWUsIDI3IEF1ZyAyMDE5IDA0OjI4OjM3ICswMDAwDQo+IFBhcmF2IFBhbmRp
dCA8cGFyYXZAbWVsbGFub3guY29tPiB3cm90ZToNCj4gDQo+ID4gSGkgTWFyaywNCj4gPg0KPiA+
ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IE1hcmsgQmxvY2ggPG1h
cmtiQG1lbGxhbm94LmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAyNywgMjAxOSA0
OjMyIEFNDQo+ID4gPiBUbzogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+OyBhbGV4
LndpbGxpYW1zb25AcmVkaGF0LmNvbTsNCj4gPiA+IEppcmkgUGlya28gPGppcmlAbWVsbGFub3gu
Y29tPjsga3dhbmtoZWRlQG52aWRpYS5jb207DQo+ID4gPiBjb2h1Y2tAcmVkaGF0LmNvbTsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiA+ID4gQ2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4g
PiBTdWJqZWN0OiBSZTogW1BBVENIIDIvNF0gbWRldjogTWFrZSBtZGV2IGFsaWFzIHVuaXF1ZSBh
bW9uZyBhbGwNCj4gPiA+IG1kZXZzDQo+ID4gPg0KPiA+ID4NCj4gPiA+DQo+ID4gPiBPbiA4LzI2
LzE5IDE6NDEgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiA+ID4gTWRldiBhbGlhcyBzaG91
bGQgYmUgdW5pcXVlIGFtb25nIGFsbCB0aGUgbWRldnMsIHNvIHRoYXQgd2hlbiBzdWNoDQo+ID4g
PiA+IGFsaWFzIGlzIHVzZWQgYnkgdGhlIG1kZXYgdXNlcnMgdG8gZGVyaXZlIG90aGVyIG9iamVj
dHMsIHRoZXJlIGlzDQo+ID4gPiA+IG5vIGNvbGxpc2lvbiBpbiBhIGdpdmVuIHN5c3RlbS4NCj4g
PiA+ID4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5v
eC5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgZHJpdmVycy92ZmlvL21kZXYvbWRldl9jb3Jl
LmMgfCA1ICsrKysrDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+
ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2NvcmUu
Yw0KPiA+ID4gPiBiL2RyaXZlcnMvdmZpby9tZGV2L21kZXZfY29yZS5jIGluZGV4IGU4MjVmZjM4
YjAzNy4uNmViMzdmMGM2MzY5DQo+ID4gPiA+IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJz
L3ZmaW8vbWRldi9tZGV2X2NvcmUuYw0KPiA+ID4gPiArKysgYi9kcml2ZXJzL3ZmaW8vbWRldi9t
ZGV2X2NvcmUuYw0KPiA+ID4gPiBAQCAtMzc1LDYgKzM3NSwxMSBAQCBpbnQgbWRldl9kZXZpY2Vf
Y3JlYXRlKHN0cnVjdCBrb2JqZWN0ICprb2JqLA0KPiA+ID4gc3RydWN0IGRldmljZSAqZGV2LA0K
PiA+ID4gPiAgCQkJcmV0ID0gLUVFWElTVDsNCj4gPiA+ID4gIAkJCWdvdG8gbWRldl9mYWlsOw0K
PiA+ID4gPiAgCQl9DQo+ID4gPiA+ICsJCWlmICh0bXAtPmFsaWFzICYmIHN0cmNtcCh0bXAtPmFs
aWFzLCBhbGlhcykgPT0gMCkgew0KPiA+ID4NCj4gPiA+IGFsaWFzIGNhbiBiZSBOVUxMIGhlcmUg
bm8/DQo+ID4gPg0KPiA+IElmIGFsaWFzIGlzIE5VTEwsIHRtcC0+YWxpYXMgd291bGQgYWxzbyBi
ZSBudWxsIGJlY2F1c2UgZm9yIGdpdmVuIHBhcmVudCBlaXRoZXINCj4gd2UgaGF2ZSBhbGlhcyBv
ciB3ZSBkb27igJl0Lg0KPiA+IFNvIGl0cyBub3QgcG9zc2libGUgdG8gaGF2ZSB0bXAtPmFsaWFz
IGFzIG51bGwgYW5kIGFsaWFzIGFzIG5vbiBudWxsLg0KPiA+IEJ1dCBpdCBtYXkgYmUgZ29vZC9k
ZWZlbnNpdmUgdG8gYWRkIGNoZWNrIGZvciBib3RoLg0KPiANCj4gbWRldl9saXN0IGlzIGEgZ2xv
YmFsIGxpc3Qgb2YgYWxsIG1kZXYgZGV2aWNlcywgaG93IGNhbiB3ZSBtYWtlIGFueQ0KPiBhc3N1
bXB0aW9ucyB0aGF0IGFuIGVsZW1lbnQgaGFzIHRoZSBzYW1lIHBhcmVudD8gIFRoYW5rcywNCj4g
DQpPaCB5ZXMsIHJpZ2h0LiBJZiB0bXAtPmFsaWFzIGlzIG5vdF9udWxsIGJ1dCBhbGlhcyBjYW4g
YmUgTlVMTC4NCkkgd2lsbCBmaXggdGhlIGNoZWNrLg0KDQo+IEFsZXgNCj4gDQo+ID4gPiA+ICsJ
CQltdXRleF91bmxvY2soJm1kZXZfbGlzdF9sb2NrKTsNCj4gPiA+ID4gKwkJCXJldCA9IC1FRVhJ
U1Q7DQo+ID4gPiA+ICsJCQlnb3RvIG1kZXZfZmFpbDsNCj4gPiA+ID4gKwkJfQ0KPiA+ID4gPiAg
CX0NCj4gPiA+ID4NCj4gPiA+ID4gIAltZGV2ID0ga3phbGxvYyhzaXplb2YoKm1kZXYpLCBHRlBf
S0VSTkVMKTsNCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBNYXJrDQoNCg==
