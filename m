Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BE16F89C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgBZHiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:38:10 -0500
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:31136
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbgBZHiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 02:38:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsZ6ZKJJMEqL2CPFhvMfmNw1XbICPlgbM30Upaj4aUazENTRQgMyyyoiQWqC7jFXSOAJJ5M+ZK0MZreL3N6ILjvC6XkcqrdcalJRZS19kinM3HXVS++tnbO9+fMFAi1YD8IPYXkpC5rhuAt9WDzSjwcM6DA81MKmvNK5RIk0dsuAPVPb8yLsByqxBCE1XowYvo+WKDbVI0ngtXAZLeA+pik+sLkLRkoOOlBbf1J2zTst0q4c+urbhYkwpWk566Tb/LjH9CiPPePtGYFtWgRik9Q/Roc5z0GL85K2TaDJWAdIJHiNo/1jBuBa7jQxPEsXDC2fA4OzwPQy2Se5bjDkzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOAvg69xl6lS5Za8OPYLySbK/9UHUVSiUFpqfAIc9rM=;
 b=eAAQtr+CqmXtpKYSPpCDyBMYSCX08m9bpM53SZgEpAbHUfJacKqYQQ9WJpOkdvk7yzP6X85qy51rJz7vL6WLXe34l9Exi7FVqYQz9ccJJj0Ckf3voPgTd0lZ7rw52GXYUEHFusiEMiE93Bxm1z8QzsASBx2o9D3+Ntds9XOyRZsmdzjO4tJVT/rgPhcE0g9sAlz1mmI4qjgpNR1x4hNLKzJMQpZLFx0q3lSCpde9fEKKUrvXboXgTU7lUXKODrwyrKBB7Wj9fiNkFu+trHw2cz6LnRhFzNPuN/njC/M+x6XyoBEBvU9DPpQrg75pYcVdbyeSt+UCEy8aCtLotdO48Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FOAvg69xl6lS5Za8OPYLySbK/9UHUVSiUFpqfAIc9rM=;
 b=kotkX5adMqxkNg7YoG00K4x98cq4jizYGGb5eR6o5MhdSLmZkMwJ7KMNouqsduMey4xr+z8w7XnuDdoiSlTVm9ZKhqJDsyhXVlygPXFD4jGSWuMJF6LX3Fh/zRCLwMYHpHIfmLduyY53s9Lwut6P3TA8oprwtRLYWgffXQlhgMg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3246.eurprd05.prod.outlook.com (10.170.236.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Wed, 26 Feb 2020 07:38:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 07:38:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [net-next 03/16] net/mlx5e: Encapsulate updating netdev queues
 into a function
Thread-Topic: [net-next 03/16] net/mlx5e: Encapsulate updating netdev queues
 into a function
Thread-Index: AQHV7EHs1+X0eHqdWEuuChLezdwOyKgsszuAgABjnAA=
Date:   Wed, 26 Feb 2020 07:38:05 +0000
Message-ID: <0a1fcb63c5a2d76db16b02db6ab247a6e95ee510.camel@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
         <20200226011246.70129-4-saeedm@mellanox.com>
         <20200225174133.05c4a1d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200225174133.05c4a1d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 9ae43f61-a8f9-4d3a-a605-08d7ba8ed1a2
x-ms-traffictypediagnostic: VI1PR05MB3246:|VI1PR05MB3246:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3246C5E70DC0EADBF0AB2F33BEEA0@VI1PR05MB3246.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(199004)(189003)(86362001)(8676002)(6512007)(8936002)(81166006)(186003)(478600001)(71200400001)(5660300002)(26005)(6506007)(107886003)(6916009)(2616005)(316002)(76116006)(4326008)(66946007)(91956017)(66476007)(66446008)(64756008)(54906003)(6486002)(36756003)(66556008)(81156014)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3246;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4kUt+6HW94WulhusQZLoRqeeXzEn501k7QoD3E8c1VJqbF/OwBlFJHci8j0MLphcfyMVSeERQLoxnueKfSj3ghgcfc3MB9xMuwoBLm6Wb2uwyKbrJxOMj/FsVpMVTQAwNF3rjlcJzmP3vzxz/ceB0e2G91v6bX9Ol95gBW6Qizp8rfWvFT6HshKDhNTDnHZeIwl9+bW+XKXISCccFfRJP/w1L380HwvgrZPVC/2aSe4nP4k6uHLKFbtl0hlq1FRv5iHhqC0JWAINRcqRkEiDzUvYKCHiVKFA818U8IGhkn/YEtHxcER24nv7zu6LT5Gqs0gNjC8sDJP8fyWrYU1P/dfYd0TvISOH5KS7WFqQaWBcSx/CKP3xaA807RLUQhIyYT66ijARCCsZXWxnKUXXweJ/iLEpQwK6aEcmGr4B4PzfB7ye1wYkx01C1RGi53+w
x-ms-exchange-antispam-messagedata: WOcxA3Fly9Eh/rJWuiaoJI1zDBF3S35SeP32t552tafxqo7bLQrxRG1mIDCzZFGhemePSw++IVxHkpq3O6DfKxIYt8eOwV3etdV48m1ZxJlSkI5o0CsUEjMssAGAy9NlpwTetJ9KuAmEqUt26rEMpw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD34C19E91FA9345BC102D523687AAE1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae43f61-a8f9-4d3a-a605-08d7ba8ed1a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 07:38:06.0185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4mJcYgbsgFSj27Zsw8T8+EVpDK7u7W//1TUnA/yzLI3iS0fpl0hLBACvt2uI2kLiMPay4V48mOegCnREztiBBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTI1IGF0IDE3OjQxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyNSBGZWIgMjAyMCAxNzoxMjozMyAtMDgwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGltbWlAbWVsbGFub3guY29tPg0K
PiA+IA0KPiA+IEFzIGEgcHJlcGFyYXRpb24gZm9yIG9uZSBvZiB0aGUgZm9sbG93aW5nIGNvbW1p
dHMsIGNyZWF0ZSBhDQo+ID4gZnVuY3Rpb24gdG8NCj4gPiBlbmNhcHN1bGF0ZSB0aGUgY29kZSB0
aGF0IG5vdGlmaWVzIHRoZSBrZXJuZWwgYWJvdXQgdGhlIG5ldyBhbW91bnQNCj4gPiBvZg0KPiA+
IFJYIGFuZCBUWCBxdWV1ZXMuIFRoZSBjb2RlIHdpbGwgYmUgY2FsbGVkIG11bHRpcGxlIHRpbWVz
IGluIHRoZQ0KPiA+IG5leHQNCj4gPiBjb21taXQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTog
TWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCj4gPiBSZXZpZXdlZC1i
eTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4v
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgfCAxOSArKysrKysrKysr
KystLS0NCj4gPiAtLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA3
IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+ID4gaW5kZXggYTRkM2UxYjZhYjIwLi44
NWE4NmZmNzJhYWMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gPiBAQCAtMjg2OSw2ICsyODY5LDE3IEBAIHN0
YXRpYyB2b2lkIG1seDVlX25ldGRldl9zZXRfdGNzKHN0cnVjdA0KPiA+IG5ldF9kZXZpY2UgKm5l
dGRldikNCj4gPiAgCQluZXRkZXZfc2V0X3RjX3F1ZXVlKG5ldGRldiwgdGMsIG5jaCwgMCk7DQo+
ID4gIH0NCj4gPiAgDQo+ID4gK3N0YXRpYyB2b2lkIG1seDVlX3VwZGF0ZV9uZXRkZXZfcXVldWVz
KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KQ0KPiA+ICt7DQo+ID4gKwlpbnQgbnVtX3R4cXMgPSBw
cml2LT5jaGFubmVscy5udW0gKiBwcml2LQ0KPiA+ID5jaGFubmVscy5wYXJhbXMubnVtX3RjOw0K
PiA+ICsJaW50IG51bV9yeHFzID0gcHJpdi0+Y2hhbm5lbHMubnVtICogcHJpdi0+cHJvZmlsZS0+
cnFfZ3JvdXBzOw0KPiA+ICsJc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IHByaXYtPm5ldGRl
djsNCj4gPiArDQo+ID4gKwltbHg1ZV9uZXRkZXZfc2V0X3RjcyhuZXRkZXYpOw0KPiA+ICsJbmV0
aWZfc2V0X3JlYWxfbnVtX3R4X3F1ZXVlcyhuZXRkZXYsIG51bV90eHFzKTsNCj4gPiArCW5ldGlm
X3NldF9yZWFsX251bV9yeF9xdWV1ZXMobmV0ZGV2LCBudW1fcnhxcyk7DQo+ID4gK30NCj4gPiAr
DQo+ID4gIHN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX3R4cV9tYXBzKHN0cnVjdCBtbHg1ZV9wcml2
ICpwcml2KQ0KPiA+ICB7DQo+ID4gIAlpbnQgaSwgY2g7DQo+ID4gQEAgLTI4OTAsMTMgKzI5MDEs
NyBAQCBzdGF0aWMgdm9pZCBtbHg1ZV9idWlsZF90eHFfbWFwcyhzdHJ1Y3QNCj4gPiBtbHg1ZV9w
cml2ICpwcml2KQ0KPiA+ICANCj4gPiAgdm9pZCBtbHg1ZV9hY3RpdmF0ZV9wcml2X2NoYW5uZWxz
KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KQ0KPiA+ICB7DQo+ID4gLQlpbnQgbnVtX3R4cXMgPSBw
cml2LT5jaGFubmVscy5udW0gKiBwcml2LQ0KPiA+ID5jaGFubmVscy5wYXJhbXMubnVtX3RjOw0K
PiA+IC0JaW50IG51bV9yeHFzID0gcHJpdi0+Y2hhbm5lbHMubnVtICogcHJpdi0+cHJvZmlsZS0+
cnFfZ3JvdXBzOw0KPiA+IC0Jc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IHByaXYtPm5ldGRl
djsNCj4gPiAtDQo+ID4gLQltbHg1ZV9uZXRkZXZfc2V0X3RjcyhuZXRkZXYpOw0KPiA+IC0JbmV0
aWZfc2V0X3JlYWxfbnVtX3R4X3F1ZXVlcyhuZXRkZXYsIG51bV90eHFzKTsNCj4gPiAtCW5ldGlm
X3NldF9yZWFsX251bV9yeF9xdWV1ZXMobmV0ZGV2LCBudW1fcnhxcyk7DQo+ID4gKwltbHg1ZV91
cGRhdGVfbmV0ZGV2X3F1ZXVlcyhwcml2KTsNCj4gDQo+IE5vdCBzdXJlIHdoZXJlIHdlIHN0YW5k
IG9uIGp1c3QgbW92aW5nIGJhZCBjb2RlLCBidXQgc2V0X3JlYWxfbnVtXw0KPiBfcXVldWVzIGNh
biBmYWlsLCBEYXZlIGp1c3QgcG9pbnRlZCB0aGlzIG91dCB0byBzb21lb25lIHJlY2VudGx5IGlu
DQo+IHJldmlldy4NCj4gDQoNCmdvb2QgcG9pbnQsIGJ1dCBsaWtld2lzZSBub3Qgc3VyZSBpZiB0
aGlzIHBhdGNoIGlzIHRoZSBwbGFjZSB0byBmaXggdGhlDQppc3N1ZSwgdGhlIGdvb2QgdGhpbmcg
aXMgdGhhdCBub3cgaXQgaXMgZml4YWJsZSBzaW5jZSBtYXhpbSBhZGRlZCB0aGUNCmFiaWxpdHkg
dG8gYWxsb3cgZmFpbGluZyBtbHg1X3N3aXRjaF9jaGFubmVscygpIGFuZCByb2xsIGJhY2suDQoN
CmluIHBhdGNoIDYgb2YgdGhpcyBzZXJpZXM7DQpuZXQvbWx4NWU6IEZpeCBjb25maWd1cmF0aW9u
IG9mIFhQUyBjcHVtYXNrcyBhbmQgbmV0ZGV2IHF1ZXVlcyBpbg0KY29ybmVyIGNhc2VzDQoNCnlv
dSBjYW4gc2VlIHRoYXQgTWF4aW0gaXMgdXNpbmcgdGhlIG5ldyBmdW5jdGlvbiBpbnRyb2R1Y2Vk
IGluIHRoaXMNCnBhdGNoIGFzIGEgaG9vayB0aGF0IGlzIGFsbG93ZWQgdG8gZmFpbCBhbmQgYmFp
bCBvdXQgd2hlbiBzd2l0Y2hpbmcNCmJldHdlZW4gY2hhbm5lbHM6DQoNCmVyciA9IG1seDVlX3Nh
ZmVfc3dpdGNoX2NoYW5uZWxzKHByaXYsICZuZXdfY2hhbm5lbHMsDQptbHg1ZV9udW1fY2hhbm5l
bHNfY2hhbmdlZCk7DQoNCnNvIGFsbCB3ZSBuZWVkIGlzIHRvIG5vdCBpZ25vcmUgdGhlIHJldHVy
biB2YWx1ZSBvZg0KbmV0aWZfc2V0X3JlYWxfbnVtX3R4X3F1ZXVlcygpIGFuZCBhYm9ydCBtbHg1
ZV9udW1fY2hhbm5lbHNfY2hhbmdlZCgpDQppbiBjYXNlIG9mIGZhaWx1cmUgd2hpY2ggd2lsbCBh
Ym9ydCBtbHg1ZV9zYWZlX3N3aXRjaF9jaGFubmVscygpIGFuZA0Kb2xkIGNoYW5uZWxzIHdpbGwg
a2VlcCB3b3JraW5nLg0KDQpJIGd1ZXNzIHRoaXMgc2hvdWxkIGJlIGFuIGluY3JlbWVudGFsIG9u
ZWxpbmVyIHBhdGNoIGFmdGVyIHRoaXMgc2VyaWVzLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KPiA+
ICANCj4gPiAgCW1seDVlX2J1aWxkX3R4cV9tYXBzKHByaXYpOw0KPiA+ICAJbWx4NWVfYWN0aXZh
dGVfY2hhbm5lbHMoJnByaXYtPmNoYW5uZWxzKTsNCg==
