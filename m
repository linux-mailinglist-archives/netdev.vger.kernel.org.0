Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750DC83904
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHFSyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:54:16 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:41782
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfHFSyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 14:54:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3oaN4jAFBu5BPlAB4s+HVDljHiUtL3fWisW4Kr4FkUJy8LX/PAsLFR2vfsQavkXK1Mmozf5EF20asSl8RT4uhoJRHRFDPA59O0R2D3Ipv5azsje4SjpUxQI07Ex7JJMfZ9q5mBJ02bxGh9Zn2rSxOGZ/DLidzow264BK588rjJ0LSYmVF/FZHOKPVJW/l8J0ndx05k6ZSwISDQGWqj97H27YzVdK3EL4DqZMD/YfTrNn6WWAIQa999ie6OmCYXTIWzBlRgnxV8D+oGXYTVtgfp5JzN5CEbQiPegZ/LIWPt/RrZNxAR4bQKv91XLpc0XfyGNNG9fOy3j5g3pGyBs/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJ8o5vbjiivOO4T49o7j9/0n44rGL5K3YJTDP48ISls=;
 b=U+IiTHXLQHSMFC7QV14GRvPLUMQWU6fSzP4MKsruYMkf6AsiQDMkf3J7i2aJM5vFsFxuKKwj0JHt23BV2k/NOgM6lhheSEYE7omAj0dSdWnrVoAHxYbtnHe+FUGbfQmbv09cgBY542DxIfXqoZNmhDtdz8MVLUOWOPb/yU9oV5io802bzyuiycWX5tnPtsKowqUfc2Hg8OlC4KIfAajAu6XODoKa33wNLhYk/mSVDz7VmDauNfA0Q7f2rTQJ7r9jvCjqXpeOgcR9RUrefimbUH/QBNZ1Mrk4Vp49GKyzBwgNaL/o8ZOBKLog8N0fWUlrPkgL6hc9o0mpspnavM7MWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJ8o5vbjiivOO4T49o7j9/0n44rGL5K3YJTDP48ISls=;
 b=KozHL8Er/sIya34BRTIMtrQIP5FfQVPdW/b7f8+rMcSkXC7HcKdZ0dM4TyUoVNerm7UmSaLg2c6cZBi6R4biDJAeUwWkVAV8IefeMmsENGIdRj3QuiEdbzRHvgC/UWfX60sJ+uxDDGnx72HIzZK9iwVUcnPtVBw3OI6/AjfLnVQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2567.eurprd05.prod.outlook.com (10.168.71.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Tue, 6 Aug 2019 18:54:09 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 18:54:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Topic: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Index: AQHVSVIhSHjGbDfeSka9iay/Nq7Xtqbq9h0AgAAdkYCAAQNvAIAAC80AgADdAQCAALaOAIAAwyGAgAAEYQA=
Date:   Tue, 6 Aug 2019 18:54:09 +0000
Message-ID: <673f1d648f99823da0aef801bf264ab5d84fcfda.camel@mellanox.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
         <20190804125858.GJ4832@mtr-leonro.mtl.com>
         <CANhBUQ2H5MU0m2xM0AkJGPf7+MJBZ3Eq5rR0kgeOoKRi4q1j6Q@mail.gmail.com>
         <20190805061320.GN4832@mtr-leonro.mtl.com>
         <CANhBUQ0tUTXQKq__zvhNCUxXTFfDyr2xKF+Cwupod9xmvSrw2A@mail.gmail.com>
         <b19b7cd49d373cc51d3e745a6444b27166b88304.camel@mellanox.com>
         <20190806065958.GQ4832@mtr-leonro.mtl.com>
         <20190806183821.GR11627@ziepe.ca>
In-Reply-To: <20190806183821.GR11627@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 508101c4-fade-42a9-78ee-08d71a9f76d3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2567;
x-ms-traffictypediagnostic: DB6PR0501MB2567:
x-microsoft-antispam-prvs: <DB6PR0501MB2567A798596F3BF7C2D9AA83BED50@DB6PR0501MB2567.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(199004)(189003)(6486002)(81166006)(8676002)(478600001)(14454004)(6436002)(11346002)(476003)(6512007)(14444005)(53936002)(8936002)(71200400001)(81156014)(305945005)(256004)(118296001)(71190400001)(66066001)(2501003)(7736002)(36756003)(91956017)(66556008)(66476007)(64756008)(66446008)(66946007)(316002)(76116006)(5660300002)(2906002)(54906003)(229853002)(110136005)(58126008)(25786009)(486006)(186003)(53546011)(99286004)(3846002)(6506007)(76176011)(4326008)(6246003)(6116002)(86362001)(446003)(102836004)(2616005)(26005)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2567;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GVw7wZ1ldlod7D0mAUd9qQ+/Fm9BEQu9Px+q3GxRBe1c5cPEB2WfN4d6jwmAjx5L0spkjb2dzt19PL/6LNZeF51ht36vWffkqlhaS5SxlTSgaFqaWuQRBvhrbcZuFVJJQz5dwDtTTn9uWI/n/vY/Kcu2kHUcVc+OPk0auvCYo3dtsNJiPAEjPqNXG5fq3Ev5TLauy0iEekC+cABUK+XeJ/7bd0bsmKKs5KNMLjAZfcWQBgL0gm4X4YMbSywWigcjkv0k+zsayThC72P+TlTI7GHzpo1HGkfJqIOscbcJohiGEmxjzSBWraju0DX+KochyuUHeyfrvraXIFPCgqP93ZKwZaG0J4ShpzdTW9SFtHNithvWjSLK2YplUZc+DE2I8wIwKwI9A525QPoshGYJi7eZKVcqqxfqqYMR8LFv91Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61013AD757114A4A8A417054C9971DA1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508101c4-fade-42a9-78ee-08d71a9f76d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 18:54:09.0727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2567
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDE1OjM4IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFR1ZSwgQXVnIDA2LCAyMDE5IGF0IDA5OjU5OjU4QU0gKzAzMDAsIExlb24gUm9tYW5v
dnNreSB3cm90ZToNCj4gPiBPbiBNb24sIEF1ZyAwNSwgMjAxOSBhdCAwODowNjozNlBNICswMDAw
LCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiA+IE9uIE1vbiwgMjAxOS0wOC0wNSBhdCAxNDo1
NSArMDgwMCwgQ2h1aG9uZyBZdWFuIHdyb3RlOg0KPiA+ID4gPiBPbiBNb24sIEF1ZyA1LCAyMDE5
IGF0IDI6MTMgUE0gTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmcNCj4gPiA+ID4gPg0K
PiA+ID4gPiB3cm90ZToNCj4gPiA+ID4gPiBPbiBTdW4sIEF1ZyAwNCwgMjAxOSBhdCAxMDo0NDo0
N1BNICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+ID4gPiA+ID4gPiBPbiBTdW4sIEF1ZyA0
LCAyMDE5IGF0IDg6NTkgUE0gTGVvbiBSb21hbm92c2t5IDwNCj4gPiA+ID4gPiA+IGxlb25Aa2Vy
bmVsLm9yZz4NCj4gPiA+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBTYXQsIEF1ZyAw
MywgMjAxOSBhdCAxMjo0ODoyOEFNICswODAwLCBDaHVob25nIFl1YW4NCj4gPiA+ID4gPiA+ID4g
d3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gcmVmY291bnRfdCBpcyBiZXR0ZXIgZm9yIHJlZmVyZW5j
ZSBjb3VudGVycyBzaW5jZSBpdHMNCj4gPiA+ID4gPiA+ID4gPiBpbXBsZW1lbnRhdGlvbiBjYW4g
cHJldmVudCBvdmVyZmxvd3MuDQo+ID4gPiA+ID4gPiA+ID4gU28gY29udmVydCBhdG9taWNfdCBy
ZWYgY291bnRlcnMgdG8gcmVmY291bnRfdC4NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+
IEknbSBub3QgdGhyaWxsZWQgdG8gc2VlIHRob3NlIGF1dG9tYXRpYyBjb252ZXJzaW9uDQo+ID4g
PiA+ID4gPiA+IHBhdGNoZXMsDQo+ID4gPiA+ID4gPiA+IGVzcGVjaWFsbHkNCj4gPiA+ID4gPiA+
ID4gZm9yIGZsb3dzIHdoaWNoIGNhbid0IG92ZXJmbG93LiBUaGVyZSBpcyBub3RoaW5nIHdyb25n
IGluDQo+ID4gPiA+ID4gPiA+IHVzaW5nDQo+ID4gPiA+ID4gPiA+IGF0b21pY190DQo+ID4gPiA+
ID4gPiA+IHR5cGUgb2YgdmFyaWFibGUsIGRvIHlvdSBoYXZlIGluIG1pbmQgZmxvdyB3aGljaCB3
aWxsDQo+ID4gPiA+ID4gPiA+IGNhdXNlIHRvDQo+ID4gPiA+ID4gPiA+IG92ZXJmbG93Pw0KPiA+
ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gVGhhbmtzDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiA+IEkgaGF2ZSB0byBzYXkgdGhhdCB0aGVzZSBwYXRjaGVzIGFyZSBub3QgZG9uZQ0KPiA+ID4g
PiA+ID4gYXV0b21hdGljYWxseS4uLg0KPiA+ID4gPiA+ID4gT25seSB0aGUgZGV0ZWN0aW9uIG9m
IHByb2JsZW1zIGlzIGRvbmUgYnkgYSBzY3JpcHQuDQo+ID4gPiA+ID4gPiBBbGwgY29udmVyc2lv
bnMgYXJlIGRvbmUgbWFudWFsbHkuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gRXZlbiB3b3JzZSwg
eW91IG5lZWQgdG8gYXVkaXQgdXNhZ2Ugb2YgYXRvbWljX3QgYW5kIHJlcGxhY2UNCj4gPiA+ID4g
PiB0aGVyZQ0KPiA+ID4gPiA+IGl0IGNhbiBvdmVyZmxvdy4NCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiA+IEkgYW0gbm90IHN1cmUgd2hldGhlciB0aGUgZmxvdyBjYW4gY2F1c2UgYW4gb3ZlcmZsb3cu
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSXQgY2FuJ3QuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiBCdXQgSSB0aGluayBpdCBpcyBoYXJkIHRvIGVuc3VyZSB0aGF0IGEgZGF0YSBwYXRoIGlzDQo+
ID4gPiA+ID4gPiBpbXBvc3NpYmxlDQo+ID4gPiA+ID4gPiB0byBoYXZlIHByb2JsZW1zIGluIGFu
eSBjYXNlcyBpbmNsdWRpbmcgYmVpbmcgYXR0YWNrZWQuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
SXQgaXMgbm90IGRhdGEgcGF0aCwgYW5kIEkgZG91YnQgdGhhdCBzdWNoIGNvbnZlcnNpb24gd2ls
bCBiZQ0KPiA+ID4gPiA+IGFsbG93ZWQNCj4gPiA+ID4gPiBpbiBkYXRhIHBhdGhzIHdpdGhvdXQg
cHJvdmluZyB0aGF0IG5vIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24NCj4gPiA+ID4gPiBpcw0KPiA+
ID4gPiA+IGludHJvZHVjZWQuDQo+ID4gPiA+ID4gPiBTbyBJIHRoaW5rIGl0IGlzIGJldHRlciB0
byBkbyB0aGlzIG1pbm9yIHJldmlzaW9uIHRvDQo+ID4gPiA+ID4gPiBwcmV2ZW50DQo+ID4gPiA+
ID4gPiBwb3RlbnRpYWwgcmlzaywganVzdCBsaWtlIHdlIGhhdmUgZG9uZSBpbiBtbHg1L2NvcmUv
Y3EuYy4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBtbHg1L2NvcmUvY3EuYyBpcyBhIGRpZmZlcmVu
dCBiZWFzdCwgcmVmY291bnQgdGhlcmUgbWVhbnMNCj4gPiA+ID4gPiBhY3R1YWwNCj4gPiA+ID4g
PiB1c2Vycw0KPiA+ID4gPiA+IG9mIENRIHdoaWNoIGFyZSBsaW1pdGVkIGluIFNXLCBzbyBpbiB0
aGVvcnksIHRoZXkgaGF2ZQ0KPiA+ID4gPiA+IHBvdGVudGlhbA0KPiA+ID4gPiA+IHRvIGJlIG92
ZXJmbG93bi4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBJdCBpcyBub3QgdGhlIGNhc2UgaGVyZSwg
dGhlcmUgeW91ciBhcmUgYWRkaW5nIG5ldyBwb3J0Lg0KPiA+ID4gPiA+IFRoZXJlIGlzIG5vdGhp
bmcgd3Jvbmcgd2l0aCBhdG9taWNfdC4NCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+ID4gPiA+IFRo
YW5rcyBmb3IgeW91ciBleHBsYW5hdGlvbiENCj4gPiA+ID4gSSB3aWxsIHBheSBhdHRlbnRpb24g
dG8gdGhpcyBwb2ludCBpbiBzaW1pbGFyIGNhc2VzLg0KPiA+ID4gPiBCdXQgaXQgc2VlbXMgdGhh
dCB0aGUgc2VtYW50aWMgb2YgcmVmY291bnQgaXMgbm90IGFsd2F5cyBhcw0KPiA+ID4gPiBjbGVh
ciBhcw0KPiA+ID4gPiBoZXJlLi4uDQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gPiBTZW1hbnRpY2Fs
bHkgc3BlYWtpbmcsIHRoZXJlIGlzIG5vdGhpbmcgd3Jvbmcgd2l0aCBtb3ZpbmcgdG8NCj4gPiA+
IHJlZmNvdW50X3QNCj4gPiA+IGluIHRoZSBjYXNlIG9mIHZ4bGFuIHBvcnRzLi4gaXQgYWxzbyBz
ZWVtcyBtb3JlIGFjY3VyYXRlIGFuZCB3aWxsDQo+ID4gPiBwcm92aWRlIHRoZSB0eXBlIHByb3Rl
Y3Rpb24sIGV2ZW4gaWYgaXQgaXMgbm90IG5lY2Vzc2FyeS4gUGxlYXNlDQo+ID4gPiBsZXQgbWUN
Cj4gPiA+IGtub3cgd2hhdCBpcyB0aGUgdmVyZGljdCBoZXJlLCBpIGNhbiBhcHBseSB0aGlzIHBh
dGNoIHRvIG5ldC0NCj4gPiA+IG5leHQtbWx4NS4NCj4gPiANCj4gPiBUaGVyZSBpcyBubyB2ZXJk
aWN0IGhlcmUsIGl0IGlzIHVwIHRvIHlvdS4sIGlmIHlvdSBsaWtlIGNvZGUgY2h1cm4sDQo+ID4g
Z28NCj4gPiBmb3IgaXQuDQo+IA0KPiBJTUhPIENPTkZJR19SRUZDT1VOVF9GVUxMIGlzIGEgdmFs
dWFibGUgZW5vdWdoIHJlYXNvbiB0byBub3Qgb3Blbg0KPiBjb2RlDQo+IHdpdGggYW4gYXRvbWlj
IGV2ZW4gaWYgb3ZlcmZsb3cgaXMgbm90IHBvc3NpYmxlLiANCj4gDQo+IFJhY2VzIHJlc3VsdGlu
ZyBpbiBpbmNycyBvbiAwIHJlZmNvdW50cyBpcyBhIGNvbW1vbiBlbm91Z2ggbWlzdGFrZS4NCj4g
DQo+IEphc29uDQoNCkluZGVlZCwgdGhhbmtzIEphc29uLCBJIHdpbGwgdGFrZSB0aGlzIHBhdGNo
IHRvIG5ldC1uZXh0LW1seDUuDQoNCg==
