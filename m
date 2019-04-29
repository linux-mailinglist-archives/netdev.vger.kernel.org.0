Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C29BECD2
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfD2Wez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:34:55 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:52868
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729481AbfD2Wez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:34:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fasTFBcoLJLbh6mv/s6SBGg0oL1VkRqwAvDKN6mFfts=;
 b=wYEjTxA0J56g0uXSqJ+I8mtv+ogL9yVizaoCP1pHuH7BDr7m6DdEU9I/OYJFkT5C8WYSl66WNDYA/ks0NooGeefqbRnihj3OXqvc2xWIXARxqpHxZ5wet/B41OPOMX274zP7SSVo3TocXYstkZMinAndXNs2Kx9CZMVjUaYdr7Q=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2592.eurprd05.prod.outlook.com (10.168.137.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 22:34:51 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 22:34:51 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Mark Bloch <markb@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: RE: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Topic: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Index: AQHU/rdxfbRKUZWs402AO/w32fvXqaZTeNWAgAAAqlCAAD9mAIAAAK9w
Date:   Mon, 29 Apr 2019 22:34:51 +0000
Message-ID: <VI1PR0501MB22719EBFAF3F1BBEF81D7823D1390@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
 <20190429181326.6262-10-saeedm@mellanox.com>
 <20190429184116.GB6705@mtr-leonro.mtl.com>
 <VI1PR0501MB22712A3E3743FE283308771ED1390@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <e08a2f83-03ac-61cf-322f-652f4549e074@mellanox.com>
In-Reply-To: <e08a2f83-03ac-61cf-322f-652f4549e074@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d4fbfe3-b8a9-4e2f-a591-08d6ccf2e4d5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2592;
x-ms-traffictypediagnostic: VI1PR0501MB2592:
x-microsoft-antispam-prvs: <VI1PR0501MB25922A08E4ECE88A14745284D1390@VI1PR0501MB2592.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(136003)(376002)(366004)(13464003)(51914003)(199004)(189003)(52536014)(55016002)(107886003)(256004)(9686003)(14444005)(53936002)(6246003)(316002)(54906003)(97736004)(76176011)(8676002)(53546011)(7736002)(74316002)(33656002)(305945005)(66066001)(99286004)(8936002)(186003)(26005)(110136005)(81156014)(81166006)(102836004)(6506007)(71200400001)(25786009)(71190400001)(14454004)(6436002)(66946007)(450100002)(3846002)(66476007)(4326008)(6116002)(76116006)(64756008)(66446008)(66556008)(73956011)(2906002)(86362001)(5660300002)(93886005)(446003)(11346002)(476003)(7696005)(486006)(68736007)(6636002)(478600001)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2592;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qzgxUW+2dgAU+ARhtsmUxBr5nGHC0mk1BhZmJQvPhfrNW+MwUFpOXGBBvGhh0N7wtrlbXvMMO+pVsRtlcXyzAEZmY1fERhuRmb0Auj394poTkv+cJEEtGEKRDlCEK0xxNUFSYXX/5Ceb3hPtiBVDxZ9K8EMifI3ai4zIk08j4Su6eBxFw6fYSiPGzVxg/J07M536l/WwcX4zJx5CfYtMH2S8PQ0behIoE0pvKdDUWepM8LeJ3uDSR3ovLZ+d/lL0QwKVUdvGuQ4KGKS2jrrA6ow9G8PLEJZ86SoyW+sJ5ndtkA8grBgNprOO2sNvaFeklFa5yj1/0UpkloXOOQfF5AkfgHoPGsxJdscBDzN/CcR2kM61onQnWQ+lr6l7YGpxc8vPk2OoW9A+/VOeFC6SneyUXb5+nh0/4HY0dNfdiKc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d4fbfe3-b8a9-4e2f-a591-08d6ccf2e4d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 22:34:51.1981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyaywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJrIEJs
b2NoDQo+IFNlbnQ6IE1vbmRheSwgQXByaWwgMjksIDIwMTkgNTozMSBQTQ0KPiBUbzogUGFyYXYg
UGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+OyBMZW9uIFJvbWFub3Zza3kNCj4gPGxlb25yb0Bt
ZWxsYW5veC5jb20+OyBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gQ2M6
IEphc29uIEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LQ0KPiByZG1hQHZnZXIua2VybmVsLm9yZzsgTWFvciBHb3R0bGllYiA8bWFvcmdA
bWVsbGFub3guY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIG1seDUtbmV4dCAwOS8xMV0g
bmV0L21seDU6IEVzd2l0Y2gsIGVuYWJsZSBSb0NFDQo+IGxvb3BiYWNrIHRyYWZmaWMNCj4gDQo+
IA0KPiANCj4gT24gNC8yOS8xOSAxMTo0NSBBTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+DQo+
ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogbmV0ZGV2LW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4NCj4gT24N
Cj4gPj4gQmVoYWxmIE9mIExlb24gUm9tYW5vdnNreQ0KPiA+PiBTZW50OiBNb25kYXksIEFwcmls
IDI5LCAyMDE5IDE6NDEgUE0NCj4gPj4gVG86IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KPiA+PiBDYzogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPj4gbGludXgtIHJkbWFAdmdlci5rZXJuZWwub3JnOyBN
YW9yIEdvdHRsaWViIDxtYW9yZ0BtZWxsYW5veC5jb20+Ow0KPiBNYXJrDQo+ID4+IEJsb2NoIDxt
YXJrYkBtZWxsYW5veC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbWx4NS1uZXh0
IDA5LzExXSBuZXQvbWx4NTogRXN3aXRjaCwgZW5hYmxlDQo+ID4+IFJvQ0UgbG9vcGJhY2sgdHJh
ZmZpYw0KPiA+Pg0KPiA+PiBPbiBNb24sIEFwciAyOSwgMjAxOSBhdCAwNjoxNDoxNlBNICswMDAw
LCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPj4+IEZyb206IE1hb3IgR290dGxpZWIgPG1hb3Jn
QG1lbGxhbm94LmNvbT4NCj4gPj4+DQo+ID4+PiBXaGVuIGluIHN3aXRjaGRldiBtb2RlLCB3ZSB3
b3VsZCBsaWtlIHRvIHRyZWF0IGxvb3BiYWNrIFJvQ0UgdHJhZmZpYw0KPiA+Pj4gKG9uIGVzd2l0
Y2ggbWFuYWdlcikgYXMgUkRNQSBhbmQgbm90IGFzIHJlZ3VsYXIgRXRoZXJuZXQgdHJhZmZpYyBJ
bg0KPiA+Pj4gb3JkZXIgdG8gZW5hYmxlIGl0IHdlIGFkZCBmbG93IHN0ZWVyaW5nIHJ1bGUgdGhh
dCBmb3J3YXJkIFJvQ0UNCj4gPj4+IGxvb3BiYWNrIHRyYWZmaWMgdG8gdGhlIEhXIFJvQ0UgZmls
dGVyIChieSBhZGRpbmcgYWxsb3cgcnVsZSkuDQo+ID4+PiBJbiBhZGRpdGlvbiB3ZSBhZGQgUm9D
RSBhZGRyZXNzIGluIEdJRCBpbmRleCAwLCB3aGljaCB3aWxsIGJlIHNldCBpbg0KPiA+Pj4gdGhl
IFJvQ0UgbG9vcGJhY2sgcGFja2V0Lg0KPiA+Pj4NCj4gPiBJIGxpa2VseSBkb24ndCB1bmRlcnN0
YW5kIG5vciBJIHJldmlld2VkIHRoZSBwYXRjaGVzLg0KPiA+IFBhcnQgdGhhdCBJIGRvbid0IHVu
ZGVyc3RhbmQgaXMgR0lEIGluZGV4IDAgZm9yIFJvQ0UuDQo+ID4gUm9DRSB0cmFmZmljIHJ1bnMg
b3ZlciBhbGwgdGhlIEdJRCBlbnRyaWVzIGFuZCBmb3IgYWxsIHByYWN0aWNhbCBwdXJwb3NlcyBm
cm9tDQo+IG5vbl96ZXJvIGluZGV4Lg0KPiA+IEhvdyB3aWxsIGl0IHdvcms/DQo+IA0KPiBDdXJy
ZW50bHkgaW4gc3dpdGNoZGV2IG1vZGUgd2Ugb25seSBzdXBwb3J0IFJBVyBFdGhlcm5ldCBRUCBh
bmQgbm8gUm9DRQ0KPiBjYXBhYmlsaXRpZXMgYXJlIHJlcG9ydGVkIHRvIGliX2NvcmUuDQo+IFdo
aWNoIG1lYW5zIG5vIEdJRHMgYXJlIGluc2VydGVkIHRvIHRoZSBIVydzIEdJRCB0YWJsZSBhbmQg
Um9DRSBpc24ndA0KPiBlbmFibGVkIG9uIHRoZSB2cG9ydC4NCj4gDQo+IEhvd2V2ZXIsIHRoZXJl
IGFyZSBjYXNlcyB3aGVyZSBhbiBpbnRlcm5hbCBSQyBRUCBtaWdodCBiZSBuZWVkZWQsIGFuZCBm
b3INCj4gdGhhdCB3ZSBuZWVkIGEgR0lELg0KPiBUaGUgcGF0Y2hlcyBmcm9tIE1hb3IgbWFrZSBz
dXJlIGEgR0lEIGVudHJ5IGF0IGluZGV4IDAgaXMgdmFsaWQgKGFuZCB3ZSBkbw0KPiB0aGF0IG9u
bHkgaW4gc3dpdGNoZGV2IG1vZGUpLCBhbmQgd2l0aCBzdGVlcmluZyB3ZSBtYWtlIHN1cmUgc3Vj
aCB0cmFmZmljIGlzDQo+IG9ubHkgdXNlZCBmb3IgbG9vcGJhY2sgcHVycG9zZXMuDQoNCkdvdCBp
dC4gVGhhbmtzIGZvciB0aGUgZGV0YWlsZWQgZGVzY3JpcHRpb24uIEl0cyBjbGVhciB0byBtZSBu
b3cuDQo=
