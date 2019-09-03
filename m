Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6BAA7489
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfICUTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:19:35 -0400
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:35214
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726451AbfICUTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:19:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrBLSjRHc0thB1BPtG+ZIOl/mBKTgjhIuAn0vqk9ZUYQ8bmFJwkqBdLNPXPKIqanwc2Hn1lEoth9BG8jKo4scnqXYfRa9RyCvUSen9oM+aTshUwgKAClPgQwaucsaHt0WyKf688p/ao8nB/Zw+iPxAoU9q3K/XqkVpVmi+h5dgujPLFELErDG4BV+ocqFD5evvQLzZ1iNfOTmfjDTT9CjcWh/oPE32GszknVd/4sn/8TJ//P9l+T95L2+qGMa9Y/+lLpn6mastdgTn4KhsOKTp2XjgtbHEyVPMx84za9fEmofQbJIiGIrCJQxUFlJNyLC8Fg+VMnuXplr6FOaH9DoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=253YVjAwOII23T0MGmOeEUEe9e6C7JWzQ8KiMBOIzTo=;
 b=a/FUM4s8jGUffu2QGNcVB6m99hucv+qq1zys1as7JB057vEWo0TQ8X+QlPzP/FXCtxvi4MjD85O+lV2NDWXXPJ5b3kxnufVhGyXkfDPHN7yocKA/A6kmwLRmtg3x+FzBmO7/Y+/NTUuMlvqloQuD1AFtzpSjXBGVvuJWd3Z23pLYZzomOsccHz0KigeEREEVrNSDu9OjqJ4qK1D4LaFbQbyx/Kx1shb96H6EOk10FUiNIrbyGrWnOST5yGIPLVbJGKq+9xWARkMtut8uXHw4yFBqkXNZXVZUXNLOLmdVNRQjxQhNKBEmJxpthOKLkqGaKv9dfdwACuxEPI7KSeCl8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=253YVjAwOII23T0MGmOeEUEe9e6C7JWzQ8KiMBOIzTo=;
 b=CE+QECEgYafgSt7a1+G3ZX3LKetS/L2dY28NZKojG7vyZ1CBb9TaW39dTKYUeQsGHi5PQjKollpPNQpFJCOWVi/gboa6Hvl9qRhU3mgfwqnCPKT4AJZ+1oIKYUmk2L5oaRVsmiWNjwC5xt1eVc8mlNkg07C72+g7z0aFZGRds3M=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2273.eurprd05.prod.outlook.com (10.165.23.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Tue, 3 Sep 2019 20:19:28 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:19:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kal.conley@dectris.com" <kal.conley@dectris.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke.hoiland-jorgensen@kau.se" <toke.hoiland-jorgensen@kau.se>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Thread-Topic: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
Thread-Index: AQHVYW39i8jila7I5E+nLgvDcwa+8acaZuaA
Date:   Tue, 3 Sep 2019 20:19:28 +0000
Message-ID: <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
         <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
         <20190902110818.2f6a8894@carbon>
In-Reply-To: <20190902110818.2f6a8894@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4e9adda-cc61-4e88-4439-08d730ac05f9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2273;
x-ms-traffictypediagnostic: AM4PR0501MB2273:|AM4PR0501MB2273:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB227397E7E465747CE740166EBEB90@AM4PR0501MB2273.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(51914003)(189003)(199004)(6486002)(118296001)(2501003)(71200400001)(71190400001)(36756003)(66066001)(229853002)(486006)(86362001)(966005)(14454004)(3846002)(6116002)(5660300002)(478600001)(25786009)(102836004)(91956017)(446003)(99286004)(54906003)(53936002)(316002)(6506007)(2616005)(66476007)(476003)(305945005)(66446008)(6436002)(66946007)(256004)(11346002)(26005)(6306002)(8936002)(6512007)(186003)(7736002)(4326008)(8676002)(81166006)(76176011)(76116006)(58126008)(64756008)(66556008)(2906002)(110136005)(81156014)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2273;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vW71QvrD8Z7vk8/NXgOArbwgqu5OaH36DTxTEFT5QpBJRGR0hGvsxF4C7yjyxNEkSE1Z2InUSVdK5bigVoStDR9pBymFmkzDUvZFBv4HFo51wzXgi0IHIDcdf4JccpdWwk1C82tYZP+pNrYFhNCrm6yOayGBegiBzbir2eLqXZogg+sNQR36mpfRDlB9os+sOW4f+BhqDWQwLV5fewsM8ALdNLTkBiD/HUeWhFYwIQ82xGjhTFlP7/SqeRHBVmXcEJPNMN1nX+HbuV6hpW0N5JDLTRzCqA0Y6/0ofjXquO1XzmbaPhhNLo/CWjngwFqvLl5a8OCm4OtZ6j3d8bqW/rQKKXW4YfGi2mo1IwrHg6dK6m9Srkf1dIyVz7nOVrDbORsF+OCIwjXOvi7ngzgy3ya4QO9nUZhvM9mDP4XgnIQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <544A4E29CCB9D04BBDB044E42E2D8C3A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e9adda-cc61-4e88-4439-08d730ac05f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:19:28.7135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yahUgXI5r/FPDZJC1mC1P6OGO73C3DBqdPIcyCq6QndgtBKEvyeMijmbL2VHdkKnAmbEbaAMp+6sHlfjk3Gp1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2273
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTAyIGF0IDExOjA4ICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBTdW4sIDEgU2VwIDIwMTkgMTg6NDc6MTUgKzAyMDANCj4gS2FsIEN1dHRl
ciBDb25sZXkgPGthbC5jb25sZXlAZGVjdHJpcy5jb20+IHdyb3RlOg0KPiANCj4gPiBIaSwNCj4g
PiBJIGZpZ3VyZWQgb3V0IHRoZSBwcm9ibGVtLiBMZXQgbWUgZG9jdW1lbnQgdGhlIGlzc3VlIGhl
cmUgZm9yDQo+ID4gb3RoZXJzDQo+ID4gYW5kIGhvcGVmdWxseSBzdGFydCBhIGRpc2N1c3Npb24u
DQo+ID4gDQo+ID4gVGhlIG1seDUgZHJpdmVyIHVzZXMgc3BlY2lhbCBxdWV1ZSBpZHMgZm9yIFpD
LiBJZiBOIGlzIHRoZSBudW1iZXINCj4gPiBvZg0KPiA+IGNvbmZpZ3VyZWQgcXVldWVzLCB0aGVu
IGZvciBYRFBfWkVST0NPUFkgdGhlIHF1ZXVlIGlkcyBzdGFydCBhdCBOLg0KPiA+IFNvDQo+ID4g
cXVldWUgaWRzIFswLi5OKSBjYW4gb25seSBiZSB1c2VkIHdpdGggWERQX0NPUFkgYW5kIHF1ZXVl
IGlkcw0KPiA+IFtOLi4yTikNCj4gPiBjYW4gb25seSBiZSB1c2VkIHdpdGggWERQX1pFUk9DT1BZ
Lg0KPiANCj4gVGhhbmtzIGZvciB0aGUgZm9sbG93dXAgYW5kIGV4cGxhbmF0aW9uIG9uIGhvdyBt
bHg1IEFGX1hEUCBxdWV1ZQ0KPiBpbXBsZW1lbnRhdGlvbiBpcyBkaWZmZXJlbnQgZnJvbSBvdGhl
ciB2ZW5kb3JzLg0KPiANCj4gDQo+ID4gc3VkbyBldGh0b29sIC1MIGV0aDAgY29tYmluZWQgMTYN
Cj4gPiBzdWRvIHNhbXBsZXMvYnBmL3hkcHNvY2sgLXIgLWkgZXRoMCAtYyAtcSAwICAgIyBPSw0K
PiA+IHN1ZG8gc2FtcGxlcy9icGYveGRwc29jayAtciAtaSBldGgwIC16IC1xIDAgICAjIEVSUk9S
DQo+ID4gc3VkbyBzYW1wbGVzL2JwZi94ZHBzb2NrIC1yIC1pIGV0aDAgLWMgLXEgMTYgICMgRVJS
T1INCj4gPiBzdWRvIHNhbXBsZXMvYnBmL3hkcHNvY2sgLXIgLWkgZXRoMCAteiAtcSAxNiAgIyBP
Sw0KPiA+IA0KPiA+IFdoeSB3YXMgdGhpcyBkb25lPyBUbyB1c2UgemVyb2NvcHkgaWYgYXZhaWxh
YmxlIGFuZCBmYWxsYmFjayBvbg0KPiA+IGNvcHkNCj4gPiBtb2RlIG5vcm1hbGx5IHlvdSB3b3Vs
ZCBzZXQgc3hkcF9mbGFncz0wLiBIb3dldmVyLCBoZXJlIHRoaXMgaXMgbm8NCj4gPiBsb25nZXIg
cG9zc2libGUuIFRvIHN1cHBvcnQgdGhpcyBkcml2ZXIsIHlvdSBoYXZlIHRvIGZpcnN0IHRyeQ0K
PiA+IGJpbmRpbmcNCj4gPiB3aXRoIFhEUF9aRVJPQ09QWSBhbmQgdGhlIHNwZWNpYWwgcXVldWUg
aWQsIHRoZW4gaWYgdGhhdCBmYWlscywgeW91DQo+ID4gaGF2ZSB0byB0cnkgYmluZGluZyBhZ2Fp
biB3aXRoIGEgbm9ybWFsIHF1ZXVlIGlkLiBQZWN1bGlhcml0aWVzDQo+ID4gbGlrZQ0KPiA+IHRo
aXMgY29tcGxpY2F0ZSB0aGUgWERQIHVzZXIgYXBpLiBNYXliZSBzb21lb25lIGNhbiBleHBsYWlu
IHRoZQ0KPiA+IGJlbmVmaXRzPw0KPiANCg0KaW4gbWx4NSB3ZSBsaWtlIHRvIGtlZXAgZnVsbCBm
dW5jdGlvbmFsIHNlcGFyYXRpb24gYmV0d2VlbiBkaWZmZXJlbnQNCnF1ZXVlcy4gVW5saWtlIG90
aGVyIGltcGxlbWVudGF0aW9ucyBpbiBtbHg1IGtlcm5lbCBzdGFuZGFyZCByeCByaW5ncw0KY2Fu
IHN0aWxsIGZ1bmN0aW9uIHdoaWxlIHhzayBxdWV1ZXMgYXJlIG9wZW5lZC4gZnJvbSB1c2VyIHBl
cnNwZWN0aXZlDQp0aGlzIHNob3VsZCBiZSB2ZXJ5IHNpbXBsZSBhbmQgdmVyeSB1c2VmdWxsOg0K
DQpxdWV1ZXMgMC4uKE4tMSk6IGNhbid0IGJlIHVzZWQgZm9yIFhTSyBaQyBzaW5jZSB0aGV5IGFy
ZSBzdGFuZGFyZCBSWA0KcXVldWVzIG1hbmFnZWQgYnkga2VybmVsICBhbmQgZHJpdmVyDQpxdWV1
ZXMgTi4uKDJOLTEpOiBBcmUgWFNLIHVzZXIgYXBwIG1hbmFnZWQgcXVldWVzLCB0aGV5IGNhbid0
IGJlIHVzZWQNCmZvciBhbnl0aGluZyBlbHNlLg0KDQpiZW5lZml0czoNCi0gUlNTIGlzIG5vdCBp
bnRlcnJ1cHRlZCwgT25nb2luZyB0cmFmZmljIGFuZCBDdXJyZW50IFJYIHF1ZXVlcyBrZWVwcw0K
Z29pbmcgbm9ybWFsbHkgd2hlbiBYU0sgYXBwcyBhcmUgYWN0aXZhdGVkL2RlYWN0aXZhdGVkIG9u
IHRoZSBmbHkuDQotIFdlbGwtZGVmaW5lZCBmdWxsIGxvZ2ljYWwgc2VwYXJhdGlvbiBiZXR3ZWVu
IGRpZmZlcmVudCB0eXBlcyBvZiBSWA0KcXVldWUuDQoNCmFzIEplc3BlciBleHBsYWluZWQgd2Ug
dW5kZXJzdGFuZCB0aGUgY29uZnVzaW9uLCBhbmQgd2Ugd2lsbCBjb21lIHVwDQp3aXRoIGEgc29s
dXRpb24gdGhlIGZpdHMgYWxsIHZlbmRvcnMuDQoNCj4gVGhhbmtzIGZvciBjb21wbGFpbmluZywg
aXQgaXMgYWN0dWFsbHkgdmFsdWFibGUuIEl0IHJlYWxseSBpbGx1c3RyYXRlDQo+IHRoZSBrZXJu
ZWwgbmVlZCB0byBpbXByb3ZlIGluIHRoaXMgYXJlYSwgd2hpY2ggaXMgd2hhdCBvdXIgdGFsa1sx
XSBhdA0KPiBMUEMyMDE5IChTZXAgMTApIGlzIGFib3V0Lg0KPiANCj4gVGl0bGU6ICJNYWtpbmcg
TmV0d29ya2luZyBRdWV1ZXMgYSBGaXJzdCBDbGFzcyBDaXRpemVuIGluIHRoZSBLZXJuZWwiDQo+
ICBbMV0gaHR0cHM6Ly9saW51eHBsdW1iZXJzY29uZi5vcmcvZXZlbnQvNC9jb250cmlidXRpb25z
LzQ2Mi8NCj4gDQo+IEFzIHlvdSBjYW4gc2VlLCBzZXZlcmFsIHZlbmRvcnMgYXJlIGFjdHVhbGx5
IGludm9sdmVkLiBLdWRvcyB0bw0KPiBNYWdudXMNCj4gZm9yIHRha2luZyBpbml0aWF0aXZlIGhl
cmUhICBJdCdzIHVuZm9ydHVuYXRlbHkgbm90IHNvbHZlZA0KPiAidG9tb3Jyb3ciLA0KPiBhcyBm
aXJzdCB3ZSBoYXZlIHRvIGFncmVlIHRoaXMgaXMgbmVlZGVkIChmYWNpbGl0eSB0byByZWdpc3Rl
cg0KPiBxdWV1ZXMpLA0KPiB0aGVuIGFncmVlIG9uIEFQSSBhbmQgZ2V0IGNvbW1pdG1lbnQgZnJv
bSB2ZW5kb3JzLCBhcyB0aGlzIHJlcXVpcmVzDQo+IGRyaXZlcnMgY2hhbmdlcy4gIFRoZXJlIGlz
IGEgbG9uZyByb2FkIGFoZWFkLCBidXQgSSB0aGluayBpdCB3aWxsIGJlDQo+IHdvcnRod2hpbGUg
aW4gdGhlIGVuZCwgYXMgZWZmZWN0aXZlIHVzZSBvZiBkZWRpY2F0ZWQgaGFyZHdhcmUgcXVldWVz
DQo+IChib3RoIFJYIGFuZCBUWCkgaXMga2V5IHRvIHBlcmZvcm1hbmNlLg0KPiANCg==
