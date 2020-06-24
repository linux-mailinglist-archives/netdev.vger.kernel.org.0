Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAD8206D1A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388381AbgFXG4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:56:53 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:4359
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387981AbgFXG4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 02:56:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlmuVL1kTI5yQdE/KaF+Z0c0sqBFq+pe4GR2SUi9TlHV4GmbZW4grtaa84O7HQgaDJkX4tBtRwcMZE4z9CLETq3STbES2qvr5Xb9WISsyBz11vWiG7k4f+kPcVlR+pgpAluV66CH0Qp6F3OI3Au1Xvcx/PI5Wynqi+EZ7s5vazMlcCkowBu47XmReOmyYGEaMV1XyoichZ9eIA3rK/ur/dz0iry24T0RA9keNIAL32a9n1VfquIqGv3B0yrCe65xOQzMuAXiFwOe5YDgv3SS56lZ1JR+kAkm4jevO3gzY32SHHiqZBU9CjZw2DP5wZmVTIhFABwu/QAkOsA+dGhdFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45o6T174vi9fRlYKvPoDLxQK/AnqCp1UzjMZj8u45e0=;
 b=LDc54AeAA+7KwQV83uHqCK/E5kvtnVsZ6D7NKmhaBHm1awAemoTF/5lOGUAQ6HfqNQmEzTW7UW9dKmqHnugjzrHnTRz+PP5d/3zqM1fPxuEl0XhzwvrprjK8oyojjR167QimCCbZ03lalbbOZ9oKsnc/KVIjegQ0KvKrhWJ4+kViBmkYjG1mqXL1bCLO/cMcUwd1cXofLFRV/FdCHMXt6k2OYxVlpuzp38S06S/pHpBc00hI1FZgp+vPUnBEizX9H6seESLOga6AFv/ajLU0U1L/iER49j5iG/zzyxqZiyVZ7JGTS805w3ap035Ltp+5mS8ZTHWgLX1UMCV+8ZreyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45o6T174vi9fRlYKvPoDLxQK/AnqCp1UzjMZj8u45e0=;
 b=BHtCsh1eGtVJXVSAH0fj/x5D/OomZ4BGCsN75KnjkgbhrlXoZU2+UI+8aVHayuZMSodX/d/V9TUZI61VSKS2ZML06Mvzr2FTIll0Sn2xZizWm0p9T3oa4cO1FCanP7SpEO62Kc+C+V47/HJtVKaOvPgjfIauYy8czDb00/Ry9Bk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5774.eurprd05.prod.outlook.com (2603:10a6:803:d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Wed, 24 Jun
 2020 06:56:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 06:56:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Thread-Topic: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Thread-Index: AQHWSZftaIEAvWsK9UqUrJlFGGGeOajmuBIAgACd/gA=
Date:   Wed, 24 Jun 2020 06:56:48 +0000
Message-ID: <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
         <20200623195229.26411-11-saeedm@mellanox.com>
         <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6854713-00fc-4ca6-6227-08d8180bc41c
x-ms-traffictypediagnostic: VI1PR05MB5774:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5774CE0C40CD84BF9C42CD5EBE950@VI1PR05MB5774.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BYgyV+tc7pnzRyD0QKsn2M9hwJH+b/sAulZwiDTmRT6mCCwsjvqSzQVzCmmMqa2FCHlwzzGgqSZ2SYEz41wWoA7j3BMBJgEne7nji1k6Nw1DyR1o2IS/RU0FEGjCBXUnzK+18A0pE+5VgzHhR7O9f1Le1ek264Y8WsAOLJvhOCPxhBv1ku0uCZ1qHblnZ2unk6iagbgGf2ulStq8N5iAyCviKWLQNVwGckf1B4vtxP3SzWMGpbL0fHXK67KdWIUK3SdgQLSpjJibj0SLsqOLsCw1FQE2j2+Emnl1iO34dELOheEKJuQdGnwbvpZU3txwvCXiEUqVIglq9tKO4XTwaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(26005)(2906002)(6512007)(4326008)(6506007)(186003)(107886003)(54906003)(316002)(478600001)(36756003)(8936002)(86362001)(6916009)(6486002)(2616005)(8676002)(5660300002)(66556008)(76116006)(91956017)(66476007)(66446008)(83380400001)(71200400001)(66946007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wq6GEmvYG9PMX2aDSDKkjC20JcWgwdbKlWIFIY6J0wtFOjldDvPyNiP95snxe7JzhIAz0XYiEXGsSSKlF/weZB1bpCaSTi+kfSjhDRcXs4xSfBOy0+Ukf5zfihEpjU+q+KiW07T1jrfRDhh4t+H6x72AbYiMNgzfi1aBmNxcGf4kaMJ1stERZPYSWRe4LFh2cF+nyuU5+6iWqfy341QN4JWSlDvgf/ftK4a/26yRGaXLH1OV6Mw6maz7wymIQJUl3zXvjp0jC2ysNHozDvNVja08qDxZqDNcNhkSVGaHA67x2rhq80rhH9pDLDBa0vVIDzbv9cs/2hWe9otifiC/Mj+MPmT9BuVuI5dOSL3vkPXH7Ybg4SrLefn4k8lGjW5H7qqLWUX1lMjOyxzJxDPh1vCXQp4txx+/VSziAFh6JS5yEYqRqGyxZXYZoexjLRkVUdbDXQBlf9VY4vz0zQq2CYfIwLMk+enwJEes1TU90FYWuMjilNaSLjxQZ5cMrugo
Content-Type: text/plain; charset="utf-8"
Content-ID: <45B8950630328F49995302D651088760@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6854713-00fc-4ca6-6227-08d8180bc41c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 06:56:48.5457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpJt6HP9ixwMf7vUbJshQsCUC5mxPa4na9K7bpfRkCl5v/+fSYHknOZMOElITQTizdPoZkcfQtnq+rSaDMvJQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5774
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTIzIGF0IDE0OjMxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyMyBKdW4gMjAyMCAxMjo1MjoyOSAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBBeWEgTGV2aW4gPGF5YWxAbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IFRo
ZSBjb25jZXB0IG9mIFJlbGF4ZWQgT3JkZXJpbmcgaW4gdGhlIFBDSSBFeHByZXNzIGVudmlyb25t
ZW50DQo+ID4gYWxsb3dzDQo+ID4gc3dpdGNoZXMgaW4gdGhlIHBhdGggYmV0d2VlbiB0aGUgUmVx
dWVzdGVyIGFuZCBDb21wbGV0ZXIgdG8gcmVvcmRlcg0KPiA+IHNvbWUNCj4gPiB0cmFuc2FjdGlv
bnMganVzdCByZWNlaXZlZCBiZWZvcmUgb3RoZXJzIHRoYXQgd2VyZSBwcmV2aW91c2x5DQo+ID4g
ZW5xdWV1ZWQuDQo+ID4gDQo+ID4gSW4gRVRIIGRyaXZlciwgdGhlcmUgaXMgbm8gcXVlc3Rpb24g
b2Ygd3JpdGUgaW50ZWdyaXR5IHNpbmNlIGVhY2gNCj4gPiBtZW1vcnkNCj4gPiBzZWdtZW50IGlz
IHdyaXR0ZW4gb25seSBvbmNlIHBlciBjeWNsZS4gSW4gYWRkaXRpb24sIHRoZSBkcml2ZXINCj4g
PiBkb2Vzbid0DQo+ID4gYWNjZXNzIHRoZSBtZW1vcnkgc2hhcmVkIHdpdGggdGhlIGhhcmR3YXJl
IHVudGlsIHRoZSBjb3JyZXNwb25kaW5nDQo+ID4gQ1FFDQo+ID4gYXJyaXZlcyBpbmRpY2F0aW5n
IGFsbCBQQ0kgdHJhbnNhY3Rpb25zIGFyZSBkb25lLg0KPiANCg0KSGkgSmFrdWIsIHNvcnJ5IGkg
bWlzc2VkIHlvdXIgY29tbWVudHMgb24gdGhpcyBwYXRjaC4NCg0KPiBBc3N1bWluZyB0aGUgZGV2
aWNlIHNldHMgdGhlIFJPIGJpdHMgYXBwcm9wcmlhdGVseSwgcmlnaHQ/IE90aGVyd2lzZQ0KPiBD
UUUgd3JpdGUgY291bGQgdGhlb3JldGljYWxseSBzdXJwYXNzIHRoZSBkYXRhIHdyaXRlLCBubz8N
Cj4gDQoNClllcyBIVyBndWFyYW50ZWVzIGNvcnJlY3RuZXNzIG9mIGNvcnJlbGF0ZWQgcXVldWVz
IGFuZCB0cmFuc2FjdGlvbnMuDQoNCj4gPiBXaXRoIHJlbGF4ZWQgb3JkZXJpbmcgc2V0LCB0cmFm
ZmljIG9uIHRoZSByZW1vdGUtbnVtYSBpcyBhdCB0aGUNCj4gPiBzYW1lDQo+ID4gbGV2ZWwgYXMg
d2hlbiBvbiB0aGUgbG9jYWwgbnVtYS4NCj4gDQo+IFNhbWUgbGV2ZWwgb2Y/IEFjaGlldmFibGUg
YmFuZHdpZHRoPw0KPiANCg0KWWVzLCBCYW5kd2lkdGgsIGFjY29yZGluZyB0aGUgYmVsb3cgZXhw
bGFuYXRpb24sIGkgc2VlIHRoYXQgdGhlIG1lc3NhZ2UNCm5lZWRzIGltcHJvdmVtZW50cy4NCg0K
PiA+IFJ1bm5pbmcgVENQIHNpbmdsZSBzdHJlYW0gb3ZlciBDb25uZWN0WC00IExYLCBBUk0gQ1BV
IG9uIHJlbW90ZS0NCj4gPiBudW1hDQo+ID4gaGFzIDMwMCUgaW1wcm92ZW1lbnQgaW4gdGhlIGJh
bmR3aWR0aC4NCj4gPiBXaXRoIHJlbGF4ZWQgb3JkZXJpbmcgdHVybmVkIG9mZjogQlc6MTAgW0dC
L3NdDQo+ID4gV2l0aCByZWxheGVkIG9yZGVyaW5nIHR1cm5lZCBvbjogIEJXOjQwIFtHQi9zXQ0K
PiA+IA0KPiA+IFRoZSBkcml2ZXIgdHVybnMgcmVsYXhlZCBvcmRlcmluZyBvZmYgYnkgZGVmYXVs
dC4gSXQgZXhwb3NlcyAyDQo+ID4gYm9vbGVhbg0KPiA+IHByaXZhdGUtZmxhZ3MgaW4gZXRodG9v
bDogcGNpX3JvX3JlYWQgYW5kIHBjaV9yb193cml0ZSBmb3IgdXNlcg0KPiA+IGNvbnRyb2wuDQo+
ID4gDQo+ID4gJCBldGh0b29sIC0tc2hvdy1wcml2LWZsYWdzIGV0aDINCj4gPiBQcml2YXRlIGZs
YWdzIGZvciBldGgyOg0KPiA+IC4uLg0KPiA+IHBjaV9yb19yZWFkICAgICAgICA6IG9mZg0KPiA+
IHBjaV9yb193cml0ZSAgICAgICA6IG9mZg0KPiA+IA0KPiA+ICQgZXRodG9vbCAtLXNldC1wcml2
LWZsYWdzIGV0aDIgcGNpX3JvX3dyaXRlIG9uDQo+ID4gJCBldGh0b29sIC0tc2V0LXByaXYtZmxh
Z3MgZXRoMiBwY2lfcm9fcmVhZCBvbg0KPiANCj4gSSB0aGluayBNaWNoYWwgd2lsbCByaWdodGx5
IGNvbXBsYWluIHRoYXQgdGhpcyBkb2VzIG5vdCBiZWxvbmcgaW4NCj4gcHJpdmF0ZSBmbGFncyBh
bnkgbW9yZS4gQXMgKC9pZj8pIEFSTSBkZXBsb3ltZW50cyB0YWtlIGEgZm9vdGhvbGQgDQo+IGlu
IERDIHRoaXMgd2lsbCBiZWNvbWUgYSBjb21tb24gc2V0dGluZyBmb3IgbW9zdCBOSUNzLg0KDQpJ
bml0aWFsbHkgd2UgdXNlZCBwY2llX3JlbGF4ZWRfb3JkZXJpbmdfZW5hYmxlZCgpIHRvDQogcHJv
Z3JhbW1hdGljYWxseSBlbmFibGUgdGhpcyBvbi9vZmYgb24gYm9vdCBidXQgdGhpcyBzZWVtcyB0
bw0KaW50cm9kdWNlIHNvbWUgZGVncmFkYXRpb24gb24gc29tZSBJbnRlbCBDUFVzIHNpbmNlIHRo
ZSBJbnRlbCBGYXVsdHkNCkNQVXMgbGlzdCBpcyBub3QgdXAgdG8gZGF0ZS4gQXlhIGlzIGRpc2N1
c3NpbmcgdGhpcyB3aXRoIEJqb3JuLg0KDQpTbyB1bnRpbCB3ZSBmaWd1cmUgdGhpcyBvdXQsIHdp
bGwga2VlcCB0aGlzIG9mZiBieSBkZWZhdWx0Lg0KDQpmb3IgdGhlIHByaXZhdGUgZmxhZ3Mgd2Ug
d2FudCB0byBrZWVwIHRoZW0gZm9yIHBlcmZvcm1hbmNlIGFuYWx5c2lzIGFzDQp3ZSBkbyB3aXRo
IGFsbCBvdGhlciBtbHg1IHNwZWNpYWwgcGVyZm9ybWFuY2UgZmVhdHVyZXMgYW5kIGZsYWdzLg0K
DQo=
