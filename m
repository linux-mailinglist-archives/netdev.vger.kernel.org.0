Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5BB825DC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfHEUGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:06:42 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:16079
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727460AbfHEUGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 16:06:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5v6KMA+4RzrZRnsYDquQKfMVAD7ZsT7XzNURAIeK64p97EEH7Hd1i7lGj+5k6c6Dtv+UGGHLMuNHnevxQbLe2I/gVQ4CO76S1Jag2upcfKeuHqfVdJkKD42eWUl7Qzf7D357XY6Uac/QaSegfSupXZ8E2+hTQxs924d3XXAjl+Uwl4lJOm5aM8E3HffRMlB738xbReU67+C80vRf+xLTaaB8z84evuN7Zdenip0lrs6tCXyM3IoldbIfhZi07Tu+qhnaiyoE2xQQmXgi2Kp7YTEEV8VNxP9MnCWLG3XXpzf0AuURVujYcYQk9s2qMUx271GhIogd0dy+BbyfYRyZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d99nnaC5I2JkmJUQbaJ0J8AjTtt+PHuoG9nL9J4b3O8=;
 b=g0GzrihDFqaoABIga6K2G1ysEW6cu8rRoxPaK8WVJBTyIhmyRWd1P73tuaDpFmaNTXqUKDeSk7m/tt7shyL2mrgYUxbH32rJS34bHSZdh/A37obthpTjJFtKVimzoziLMXgEB7frw53ED5my3opD8QTGzc/uoWKQ0bBikPG3ZUv7iqr+Sher7XX6YtK5QqKah1bXPruvoy3fN2gZsOJ8jHJy+CCFyzOKSaPwtXUhGxuKluZiJLUostKANIMeh0B4iFJS295bodm11R0PA9/B3l+m64pwgkMdWO/HHFMqU+a4Af5HVyjVbUmr6Q5V/YplJekeVCNk6CyLuTr4qUUBVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d99nnaC5I2JkmJUQbaJ0J8AjTtt+PHuoG9nL9J4b3O8=;
 b=nQABv2gwf8+7Na3z3mjLDe83axeOO6PkUjfrm2ozakjMm11X9ulKZVMaMYoCSJldYEetacxWE33IuiBuacWQQASXEqrObkeY3CqgjJdJRBfxswviFDKC+nPKGmetuvbm9BARhMBEFtSLljbrEWRQeZLl5cqi3JR/M1s+LnPVq9c=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2822.eurprd05.prod.outlook.com (10.172.227.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Mon, 5 Aug 2019 20:06:36 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 20:06:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "hslester96@gmail.com" <hslester96@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Topic: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Index: AQHVSVIhSHjGbDfeSka9iay/Nq7Xtqbq9h0AgAAdkYCAAQNvAIAAC80AgADdAQA=
Date:   Mon, 5 Aug 2019 20:06:36 +0000
Message-ID: <b19b7cd49d373cc51d3e745a6444b27166b88304.camel@mellanox.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
         <20190804125858.GJ4832@mtr-leonro.mtl.com>
         <CANhBUQ2H5MU0m2xM0AkJGPf7+MJBZ3Eq5rR0kgeOoKRi4q1j6Q@mail.gmail.com>
         <20190805061320.GN4832@mtr-leonro.mtl.com>
         <CANhBUQ0tUTXQKq__zvhNCUxXTFfDyr2xKF+Cwupod9xmvSrw2A@mail.gmail.com>
In-Reply-To: <CANhBUQ0tUTXQKq__zvhNCUxXTFfDyr2xKF+Cwupod9xmvSrw2A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ccc6173-b3e2-4c6c-5db5-08d719e06b7e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2822;
x-ms-traffictypediagnostic: DB6PR0501MB2822:
x-microsoft-antispam-prvs: <DB6PR0501MB2822CE7CC77EBE48F5F1CF2FBEDA0@DB6PR0501MB2822.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(189003)(199004)(4326008)(110136005)(58126008)(53546011)(6506007)(66556008)(26005)(66476007)(102836004)(64756008)(66446008)(91956017)(66946007)(6512007)(2906002)(86362001)(14454004)(316002)(446003)(6486002)(66066001)(256004)(486006)(6436002)(14444005)(476003)(186003)(2616005)(76116006)(53936002)(229853002)(11346002)(7736002)(118296001)(36756003)(6246003)(71190400001)(5660300002)(71200400001)(81166006)(99286004)(3846002)(54906003)(81156014)(478600001)(25786009)(2501003)(6116002)(8936002)(305945005)(8676002)(76176011)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2822;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 96kryCYO+fa1FRF13QHU+qavaZnLHRayA6FftxcMfMDXjJmgOWfR5HPHEVShKGfVGCFfi1AtCYTkPGg4V8en8BCFLRHH0L/Lhx0lNtzYyaFIhf3LZ5j95ShmlVshwANkRdVek7RYHPZhSM1r9Q8BIWUBDvFBofiaGGIGIeiHSKQb4fJZJ29Zqs+ncfgGkUui9UarH6JzMXjzJXK7crDs4ZHbKAQFNrDZnL0gH71jNp8iRAOh7QaO14+so2W247yND4UPWSXk26a+yTf/GB/B8YnXScfft3bP5TEowPN8hrPLfXPOhNqtAUibXBETTCcIaSqlXaQMXNLqEqNQRUhwzVLUHwU62xPuN86GA9lP9MIHr4E9K5bGcTUJPNib3aX/bxD8L5MEE5WzQ/tSQnHG+3889BAgHWzOmuWbsSPW/K8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC1103FF0DC08343A8BBD522A8924F14@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ccc6173-b3e2-4c6c-5db5-08d719e06b7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 20:06:36.2337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2822
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE0OjU1ICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+
IE9uIE1vbiwgQXVnIDUsIDIwMTkgYXQgMjoxMyBQTSBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2Vy
bmVsLm9yZz4NCj4gd3JvdGU6DQo+ID4gT24gU3VuLCBBdWcgMDQsIDIwMTkgYXQgMTA6NDQ6NDdQ
TSArMDgwMCwgQ2h1aG9uZyBZdWFuIHdyb3RlOg0KPiA+ID4gT24gU3VuLCBBdWcgNCwgMjAxOSBh
dCA4OjU5IFBNIExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiA+ID4gd3JvdGU6
DQo+ID4gPiA+IE9uIFNhdCwgQXVnIDAzLCAyMDE5IGF0IDEyOjQ4OjI4QU0gKzA4MDAsIENodWhv
bmcgWXVhbiB3cm90ZToNCj4gPiA+ID4gPiByZWZjb3VudF90IGlzIGJldHRlciBmb3IgcmVmZXJl
bmNlIGNvdW50ZXJzIHNpbmNlIGl0cw0KPiA+ID4gPiA+IGltcGxlbWVudGF0aW9uIGNhbiBwcmV2
ZW50IG92ZXJmbG93cy4NCj4gPiA+ID4gPiBTbyBjb252ZXJ0IGF0b21pY190IHJlZiBjb3VudGVy
cyB0byByZWZjb3VudF90Lg0KPiA+ID4gPiANCj4gPiA+ID4gSSdtIG5vdCB0aHJpbGxlZCB0byBz
ZWUgdGhvc2UgYXV0b21hdGljIGNvbnZlcnNpb24gcGF0Y2hlcywNCj4gPiA+ID4gZXNwZWNpYWxs
eQ0KPiA+ID4gPiBmb3IgZmxvd3Mgd2hpY2ggY2FuJ3Qgb3ZlcmZsb3cuIFRoZXJlIGlzIG5vdGhp
bmcgd3JvbmcgaW4gdXNpbmcNCj4gPiA+ID4gYXRvbWljX3QNCj4gPiA+ID4gdHlwZSBvZiB2YXJp
YWJsZSwgZG8geW91IGhhdmUgaW4gbWluZCBmbG93IHdoaWNoIHdpbGwgY2F1c2UgdG8NCj4gPiA+
ID4gb3ZlcmZsb3c/DQo+ID4gPiA+IA0KPiA+ID4gPiBUaGFua3MNCj4gPiA+IA0KPiA+ID4gSSBo
YXZlIHRvIHNheSB0aGF0IHRoZXNlIHBhdGNoZXMgYXJlIG5vdCBkb25lIGF1dG9tYXRpY2FsbHku
Li4NCj4gPiA+IE9ubHkgdGhlIGRldGVjdGlvbiBvZiBwcm9ibGVtcyBpcyBkb25lIGJ5IGEgc2Ny
aXB0Lg0KPiA+ID4gQWxsIGNvbnZlcnNpb25zIGFyZSBkb25lIG1hbnVhbGx5Lg0KPiA+IA0KPiA+
IEV2ZW4gd29yc2UsIHlvdSBuZWVkIHRvIGF1ZGl0IHVzYWdlIG9mIGF0b21pY190IGFuZCByZXBs
YWNlIHRoZXJlDQo+ID4gaXQgY2FuIG92ZXJmbG93Lg0KPiA+IA0KPiA+ID4gSSBhbSBub3Qgc3Vy
ZSB3aGV0aGVyIHRoZSBmbG93IGNhbiBjYXVzZSBhbiBvdmVyZmxvdy4NCj4gPiANCj4gPiBJdCBj
YW4ndC4NCj4gPiANCj4gPiA+IEJ1dCBJIHRoaW5rIGl0IGlzIGhhcmQgdG8gZW5zdXJlIHRoYXQg
YSBkYXRhIHBhdGggaXMgaW1wb3NzaWJsZQ0KPiA+ID4gdG8gaGF2ZSBwcm9ibGVtcyBpbiBhbnkg
Y2FzZXMgaW5jbHVkaW5nIGJlaW5nIGF0dGFja2VkLg0KPiA+IA0KPiA+IEl0IGlzIG5vdCBkYXRh
IHBhdGgsIGFuZCBJIGRvdWJ0IHRoYXQgc3VjaCBjb252ZXJzaW9uIHdpbGwgYmUNCj4gPiBhbGxv
d2VkDQo+ID4gaW4gZGF0YSBwYXRocyB3aXRob3V0IHByb3ZpbmcgdGhhdCBubyBwZXJmb3JtYW5j
ZSByZWdyZXNzaW9uIGlzDQo+ID4gaW50cm9kdWNlZC4NCj4gPiA+IFNvIEkgdGhpbmsgaXQgaXMg
YmV0dGVyIHRvIGRvIHRoaXMgbWlub3IgcmV2aXNpb24gdG8gcHJldmVudA0KPiA+ID4gcG90ZW50
aWFsIHJpc2ssIGp1c3QgbGlrZSB3ZSBoYXZlIGRvbmUgaW4gbWx4NS9jb3JlL2NxLmMuDQo+ID4g
DQo+ID4gbWx4NS9jb3JlL2NxLmMgaXMgYSBkaWZmZXJlbnQgYmVhc3QsIHJlZmNvdW50IHRoZXJl
IG1lYW5zIGFjdHVhbA0KPiA+IHVzZXJzDQo+ID4gb2YgQ1Egd2hpY2ggYXJlIGxpbWl0ZWQgaW4g
U1csIHNvIGluIHRoZW9yeSwgdGhleSBoYXZlIHBvdGVudGlhbA0KPiA+IHRvIGJlIG92ZXJmbG93
bi4NCj4gPiANCj4gPiBJdCBpcyBub3QgdGhlIGNhc2UgaGVyZSwgdGhlcmUgeW91ciBhcmUgYWRk
aW5nIG5ldyBwb3J0Lg0KPiA+IFRoZXJlIGlzIG5vdGhpbmcgd3Jvbmcgd2l0aCBhdG9taWNfdC4N
Cj4gPiANCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBleHBsYW5hdGlvbiENCj4gSSB3aWxsIHBheSBh
dHRlbnRpb24gdG8gdGhpcyBwb2ludCBpbiBzaW1pbGFyIGNhc2VzLg0KPiBCdXQgaXQgc2VlbXMg
dGhhdCB0aGUgc2VtYW50aWMgb2YgcmVmY291bnQgaXMgbm90IGFsd2F5cyBhcyBjbGVhciBhcw0K
PiBoZXJlLi4uDQo+IA0KDQpTZW1hbnRpY2FsbHkgc3BlYWtpbmcsIHRoZXJlIGlzIG5vdGhpbmcg
d3Jvbmcgd2l0aCBtb3ZpbmcgdG8gcmVmY291bnRfdA0KaW4gdGhlIGNhc2Ugb2YgdnhsYW4gcG9y
dHMuLiBpdCBhbHNvIHNlZW1zIG1vcmUgYWNjdXJhdGUgYW5kIHdpbGwNCnByb3ZpZGUgdGhlIHR5
cGUgcHJvdGVjdGlvbiwgZXZlbiBpZiBpdCBpcyBub3QgbmVjZXNzYXJ5LiBQbGVhc2UgbGV0IG1l
DQprbm93IHdoYXQgaXMgdGhlIHZlcmRpY3QgaGVyZSwgaSBjYW4gYXBwbHkgdGhpcyBwYXRjaCB0
byBuZXQtbmV4dC1tbHg1Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
