Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA4F9D758
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfHZUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:14:52 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:56962
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387567AbfHZUOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 16:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fRf+iHzpfcHA374gpJfM4/JFD0Cv5OvQdb+E33hmkGrLA/9nPQbcYnojvbbVi4FJ6wSNe+N3mOGGhr3B+co4Xi6EZiShqEWtI1S0Mo3xgTQJYCbdSs6Dgh7sjw/fEo9Jf8cqplyh7Xz4lRy6uuG9aRae7b50ixN4y1EUdPCzSvHi04ilvzYWf8lCVg11WXDsSj7qrUlYvvZZXJKA9R/IofHmvMKN48Jbu0mMyAxK9Eef7ckVJh8PT6tcA5yBS7SsgGEJ6wq8S9jX1xPu9Yv5r0e/+nr5xDlvR+o9SgiD8mVFwFrogT+kSYDpR5MWGVvmhCtTmAmhDlAJKaX+ZOjN0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oF/3sun9MGqLbEbGtFn4v6d814tFESy/qiUKecVPJ4=;
 b=l1bNMb/ds807HQo51Rk60n8ILmEyXo6nGqXBSCDtnusLK+DP4ra02JcfTGp9oNW87qWB3ZdKkDu8w9kbGJahGr9LUbSZ4+6DKlfBEmq80LvhP08CvlOHpiJsx0Uxt9R6F8PBPpEtqXIhhVvd4ug0Zbc0Z+IwrO6UeLXPPDwiT7pzKnm2IytfAgcfIFOEjuZQ3WSRsI3nPZozxLGZ8ia1hm9Dtct+9RiV0Y+FrGwyg1dwvApR/RVuX9fbzJQtBVkLFtS0UQvjeXkojJSl2rTy8YnoGBBbnt/R+d6IcB82IaOefXLZ+tiarttPlGy/hX9vkNyTXBrFQi8GSTWoVGhRtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oF/3sun9MGqLbEbGtFn4v6d814tFESy/qiUKecVPJ4=;
 b=mPtU4nny4HX/NNVAs8savlQspndKEienAEbuejtdyPa+kUgWu/+9xBvsTmkYdMD4DFsnPEmpPtjQzDP2mk1rTnZFVP2c98CuPfxsRxhvRtQ1vJNEze+pBQISDnI0K16fGkklei5DtDwmT6o4vv+GbjNVPOK8WletBO65j89sb2A=
Received: from HE1PR0501MB2763.eurprd05.prod.outlook.com (10.172.125.17) by
 HE1PR0501MB2732.eurprd05.prod.outlook.com (10.172.125.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 26 Aug 2019 20:14:47 +0000
Received: from HE1PR0501MB2763.eurprd05.prod.outlook.com
 ([fe80::a561:bcc6:10ab:d06a]) by HE1PR0501MB2763.eurprd05.prod.outlook.com
 ([fe80::a561:bcc6:10ab:d06a%10]) with mapi id 15.20.2178.023; Mon, 26 Aug
 2019 20:14:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Topic: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Index: AQHVWUJWlLdQtLGJp0+FOnAm6QwlfqcH8v0AgABKrwCAAM1ygIAE2CiA
Date:   Mon, 26 Aug 2019 20:14:47 +0000
Message-ID: <18abb6456fb4a2fba52f6f77373ac351651a62c6.camel@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
         <20190822233514.31252-5-saeedm@mellanox.com>
         <20190822183324.79b74f7b@cakuba.netronome.com>
         <27f7cfa13d1b5e7717e2d75595ab453951b18a96.camel@mellanox.com>
         <20190823111601.012fabf4@cakuba.netronome.com>
In-Reply-To: <20190823111601.012fabf4@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2667d4d-68e1-4f9a-1e6e-08d72a620b05
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0501MB2732;
x-ms-traffictypediagnostic: HE1PR0501MB2732:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0501MB27323D2221F549E3C536D84EBEA10@HE1PR0501MB2732.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(199004)(189003)(51914003)(5640700003)(6486002)(26005)(2501003)(6916009)(2616005)(6436002)(2906002)(2351001)(102836004)(14454004)(6506007)(229853002)(58126008)(316002)(118296001)(256004)(305945005)(36756003)(54906003)(66066001)(7736002)(86362001)(8936002)(71200400001)(8676002)(478600001)(6246003)(5660300002)(4326008)(71190400001)(81156014)(81166006)(99286004)(486006)(3846002)(76176011)(107886003)(6116002)(91956017)(64756008)(66446008)(66946007)(53936002)(6306002)(966005)(25786009)(186003)(11346002)(76116006)(66556008)(446003)(6512007)(66476007)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2732;H:HE1PR0501MB2763.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3IOooQjzRrb5Ge4XC5RkBEHIzpy+gPZOK5c9GKs/7chmLTH1XnDDDdg58m41ZqZb701LK5+zuUX9FIIHISzhVEZ0NtOiRj75Sp8QBbgnirz8cox3EjqqiA0F7Uf1cPRCbC1L3mnLeDLItXFI4f59PxQCYvMQUw7jCpXKyBoDr7/7+PMTFauzeq80NNkWYaWVGJa4LY8HFup1xhl9ANNrlLtCKGF54M72iLKIMiFznLvPvkI46i5pz8/8qaoJtAkhtkd2Umrni092xqLyPP/F5C6bmg78sGI16/weeslAIWsU6C1oGbqrpFBQdBBZhtl+M/Ci7ZYKOweP7Cfhnr3/ji1nqw59pnzavaJKDbTC4Anr3NL3jzRlVfxdJEK9JjOWUpCKjByb44PwEIrDI61bdoWFqLjztGMgh8Qv98bM/dE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <449047D5AA684B4299F52B38C57E0115@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2667d4d-68e1-4f9a-1e6e-08d72a620b05
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 20:14:47.5271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2fFwncnzmWR/9TXkZhMI6abYt/ns+SW7QE5k0tYMuNHWL+D7h5C7hKpkydAzT5rSupzG4cPnt5PU2qPpdjGCPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTIzIGF0IDExOjE2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyMyBBdWcgMjAxOSAwNjowMDo0NSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gT24gVGh1LCAyMDE5LTA4LTIyIGF0IDE4OjMzIC0wNzAwLCBKYWt1YiBLaWNpbnNr
aSB3cm90ZToNCj4gPiA+IE9uIFRodSwgMjIgQXVnIDIwMTkgMjM6MzU6NTIgKzAwMDAsIFNhZWVk
IE1haGFtZWVkIHdyb3RlOiAgDQo+ID4gPiA+IEZyb206IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1l
bGxhbm94LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IEFkZGVkIHRoZSBmb2xsb3dpbmcgcGFja2V0
cyBkcm9wIGNvdW50ZXI6DQo+ID4gPiA+IERldmljZSBvdXQgb2YgYnVmZmVyIC0gY291bnRzIHBh
Y2tldHMgd2hpY2ggd2VyZSBkcm9wcGVkIGR1ZSB0bw0KPiA+ID4gPiBmdWxsDQo+ID4gPiA+IGRl
dmljZSBpbnRlcm5hbCByZWNlaXZlIHF1ZXVlLg0KPiA+ID4gPiBUaGlzIGNvdW50ZXIgd2lsbCBi
ZSBzaG93biBvbiBldGh0b29sIGFzIGEgbmV3IGNvdW50ZXIgY2FsbGVkDQo+ID4gPiA+IGRldl9v
dXRfb2ZfYnVmZmVyLg0KPiA+ID4gPiBUaGUgY291bnRlciBpcyByZWFkIGZyb20gRlcgYnkgY29t
bWFuZCBRVUVSWV9WTklDX0VOVi4NCj4gPiA+ID4gDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IE1v
c2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+ICANCj4gPiA+IA0KPiA+ID4gU291
bmRzIGxpa2UgcnhfZmlmb19lcnJvcnMsIG5vPyBEb2Vzbid0IHJ4X2ZpZm9fZXJyb3JzIGNvdW50
IFJYDQo+ID4gPiBvdmVycnVucz8gIA0KPiA+IA0KPiA+IE5vLCB0aGF0IGlzIHBvcnQgYnVmZmVy
IHlvdSBhcmUgbG9va2luZyBmb3IgYW5kIHdlIGdvdCB0aGF0IGZ1bGx5DQo+ID4gY292ZXJlZCBp
biBtbHg1LiB0aGlzIGlzIGRpZmZlcmVudC4NCj4gPiANCj4gPiBUaGlzIG5ldyBjb3VudGVyIGlz
IGRlZXAgaW50byB0aGUgSFcgZGF0YSBwYXRoIHBpcGVsaW5lIGFuZCBpdA0KPiA+IGNvdmVycw0K
PiA+IHZlcnkgcmFyZSBhbmQgY29tcGxleCBzY2VuYXJpb3MgdGhhdCBnb3Qgb25seSByZWNlbnRs
eSBpbnRyb2R1Y2VkDQo+ID4gd2l0aA0KPiA+IHN3aWNoZGV2IG1vZGUgYW5kICJzb21lIiBsYXRl
bHkgYWRkZWQgdHVubmVscyBvZmZsb2FkcyB0aGF0IGFyZQ0KPiA+IHJvdXRlZA0KPiA+IGJldHdl
ZW4gVkZzL1BGcy4NCj4gPiANCj4gPiBOb3JtYWxseSB0aGUgSFcgaXMgbG9zc2xlc3Mgb25jZSB0
aGUgcGFja2V0IHBhc3NlcyBwb3J0IGJ1ZmZlcnMNCj4gPiBpbnRvDQo+ID4gdGhlIGRhdGEgcGxh
bmUgcGlwZWxpbmUsIGxldCdzIGNhbGwgdGhhdCAiZmFzdCBsYW5lIiwgQlVUIGZvciBzcmlvdg0K
PiA+IGNvbmZpZ3VyYXRpb25zIHdpdGggc3dpdGNoZGV2IG1vZGUgZW5hYmxlZCBhbmQgc29tZSBz
cGVjaWFsIGhhbmQNCj4gPiBjcmFmdGVkIHRjIHR1bm5lbCBvZmZsb2FkcyB0aGF0IHJlcXVpcmVz
IGhhaXJwaW4gYmV0d2VlbiBWRnMvUEZzLA0KPiA+IHRoZQ0KPiA+IGh3IG1pZ2h0IGRlY2lkZSB0
byBzZW5kIHNvbWUgdHJhZmZpYyB0byBhICJzZXJ2aWNlIGxhbmUiIHdoaWNoIGlzDQo+ID4gc3Rp
bGwNCj4gPiBmYXN0IHBhdGggYnV0IHVubGlrZSB0aGUgImZhc3QgbGFuZSIgaXQgaGFuZGxlcyB0
cmFmZmljIHRocm91Z2ggIkhXDQo+ID4gaW50ZXJuYWwiIHJlY2VpdmUgYW5kIHNlbmQgcXVldWVz
IChqdXN0IGxpa2Ugd2UgZG8gd2l0aCBoYWlycGluKQ0KPiA+IHRoYXQNCj4gPiBtaWdodCBkcm9w
IHBhY2tldHMuIHRoZSB3aG9sZSB0aGluZyBpcyB0cmFuc3BhcmVudCB0byBkcml2ZXIgYW5kIGl0
DQo+ID4gaXMNCj4gPiBIVyBpbXBsZW1lbnRhdGlvbiBzcGVjaWZpYy4NCj4gDQo+IEkgc2VlIHRo
YW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9uIGFuZCBzb3JyeSBmb3IgdGhlIGRlbGF5ZWQgcmVzcG9u
c2UuDQo+IFdvdWxkIGl0IHBlcmhhcHMgbWFrZSBzZW5zZSB0byBpbmRpY2F0ZSB0aGUgaGFpcnBp
biBpbiB0aGUgbmFtZT8NCg0KV2UgaGFkIHNvbWUgaW50ZXJuYWwgZGlzY3Vzc2lvbiBhbmQgd2Ug
Y291bGRuJ3QgY29tZSB1cCB3aXRoIHRoZQ0KcGVyZmVjdCBuYW1lIDopDQoNCmhhaXJwaW4gaXMg
anVzdCBhbiBpbXBsZW1lbnRhdGlvbiBkZXRhaWwsIHdlIGRvbid0IHdhbnQgdG8gZXhjbHVzaXZl
bHkNCmJpbmQgdGhpcyBjb3VudGVyIHRvIGhhaXJwaW4gb25seSBmbG93cywgdGhlIHByb2JsZW0g
aXMgbm90IHdpdGgNCmhhaXJwaW4sIHRoZSBhY3R1YWwgcHJvYmxlbSBpcyBkdWUgdG8gdGhlIHVz
ZSBvZiBpbnRlcm5hbCBSUXMsIGZvciBub3cNCml0IG9ubHkgaGFwcGVucyB3aXRoICJoYWlycGlu
IGxpa2UiIGZsb3dzLCBidXQgdG9tb3Jyb3cgaXQgY2FuIGhhcHBlbg0Kd2l0aCBhIGRpZmZlcmVu
dCBzY2VuYXJpbyBidXQgc2FtZSByb290IGNhdXNlICh0aGUgdXNlIG9mIGludGVybmFsDQpSUXMp
LCB3ZSB3YW50IHRvIGhhdmUgb25lIGNvdW50ZXIgdG8gY291bnQgaW50ZXJuYWwgZHJvcHMgZHVl
IHRvDQppbnRlcm5hbCB1c2Ugb2YgaW50ZXJuYWwgUlFzLg0KDQpzbyBob3cgYWJvdXQ6DQpkZXZf
aW50ZXJuYWxfcnFfb29iOiBEZXZpY2UgSW50ZXJuYWwgUlEgb3V0IG9mIGJ1ZmZlcg0KZGV2X2lu
dGVybmFsX291dF9vZl9yZXM6IERldmljZSBJbnRlcm5hbCBvdXQgb2YgcmVzb3VyY2VzIChtb3Jl
IGdlbmVyaWMNCj8gdG9vIGdlbmVyaWMgPykNCg0KQW55IHN1Z2dlc3Rpb24gdGhhdCB5b3UgcHJv
dmlkZSB3aWxsIGJlIG1vcmUgdGhhbiB3ZWxjb21lLg0KDQo+IGRldl9vdXRfb2ZfYnVmZmVyIGlz
IHF1aXRlIGEgZ2VuZXJpYyBuYW1lLCBhbmQgdGhlcmUgc2VlbXMgdG8gYmUgbm8NCj4gZG9jLCBu
b3IgZG9lcyB0aGUgY29tbWl0IG1lc3NhZ2UgZXhwbGFpbnMgaXQgYXMgd2VsbCBhcyB5b3UgaGF2
ZS4uDQoNClJlZ2FyZGluZyBkb2N1bWVudGF0aW9uOg0KQWxsIG1seDUgZXRob29sIGNvdW50ZXJz
IGFyZSBkb2N1bWVudGVkIGhlcmUNCmh0dHBzOi8vY29tbXVuaXR5Lm1lbGxhbm94LmNvbS9zL2Fy
dGljbGUvdW5kZXJzdGFuZGluZy1tbHg1LWxpbnV4LWNvdW50ZXJzLWFuZC1zdGF0dXMtcGFyYW1l
dGVycw0KDQpvbmNlIHdlIGRlY2lkZSBvbiB0aGUgbmFtZSwgd2lsbCBhZGQgdGhlIG5ldyBjb3Vu
dGVyIHRvIHRoZSBkb2MuDQoNCg0KDQo=
