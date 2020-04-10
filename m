Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE811A3E65
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 04:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDJCks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 22:40:48 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:32576
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbgDJCks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 22:40:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrO78YUiUxPPj/yTUZavP/pPGOAad7Pq7nza60q+e3PimmFrpEk+FjOpMG7tet/8JiWnPdNEIg0xmY/ED4FlqIHGpgCiimIvFqnWIB3bsJV759a8tIb9sTDnZ8Zn4iWjg5GhdX+WaHQG32IffbWhWb/rnSnF+Zv77boHpwuFUmTzahltrCDLJPo4E7wdzlz6GH5weadVRaqT5P9ckyuOCERCJKWEgXmxasAEZEx48cqOjtCA0eNmMOfMvUa6pm7iQX6asGK0nfQqVcDT8YLbmtnP5Ir0M3OHOYSIx9JYi33YlHs0qNpvjjZgLR51GvTDvEgQNA3Lw4Qg6CDpykOvyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmkFfT2WZ8znsr7wYt8LI2u3R2KX1ao2uUOc7VXDS28=;
 b=YbV5ZXxXK86e8CqUK2n0M0GTqYOYN6rXJXgqDI+Jgt+TymFSsoriEwG3T6OSjvSh39CEE1NKgwQ/ohOp4bmW7eCNyXya1QHye7jiXU5b0mRYafGExcw/agp+lxb/ks+egOujyG8EhrXYeEVt96t8ri/271Zhw2Q1kwwVk2tjRJmhDkxv7ZdLDFjUNenzU0ngpeLdgnlqKJ+MT5V8gn+Q0HxFD6EhlUO4zo9dA3qPeOGekgbPK2EyamwTOJLmd6UEjGaNKrNUxres7L3Ez57DcLUb+I1YqgSeFDROMpI1zKAVNLTszr/nGB89l4Yvny+1vbZ/oZ36Vc2nf50Qwubo3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JmkFfT2WZ8znsr7wYt8LI2u3R2KX1ao2uUOc7VXDS28=;
 b=ff8HYC1E6jVkzLv3I+EbsGgG8oxosGtbKyOWzU9SfnQxoY1TzeHm3IfUZVm7+SE4wna3vvq3JUilRpWN76X+KLFk9Om1JSjeY5dTadjCHJht4klBixTITfutcrhxaqeWqJn5aTwehrogNkhx5hIyzQgSYf2rjZL3qdGeG2kquu4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4895.eurprd05.prod.outlook.com (20.177.51.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2900.20; Fri, 10 Apr 2020 02:40:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 02:40:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "arnd@arndb.de" <arnd@arndb.de>
CC:     "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Thread-Topic: [RFC 0/6] Regressions for "imply" behavior change
Thread-Index: AQHWDeQiJzc7TgrcN0yUMWAEU5j98qhvr4mAgAADKgCAAB92AIAAp0gAgAEtnwA=
Date:   Fri, 10 Apr 2020 02:40:42 +0000
Message-ID: <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
         <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
         <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
         <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
In-Reply-To: <87k12pgifv.fsf@intel.com>
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
x-ms-office365-filtering-correlation-id: 91839159-9afa-460e-e72c-08d7dcf89048
x-ms-traffictypediagnostic: VI1PR05MB4895:
x-microsoft-antispam-prvs: <VI1PR05MB4895A819FA3866D162856197BEDE0@VI1PR05MB4895.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0369E8196C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(36756003)(2906002)(4326008)(5660300002)(110136005)(54906003)(6486002)(316002)(71200400001)(7416002)(8676002)(76116006)(91956017)(6512007)(66446008)(64756008)(66476007)(66946007)(66556008)(53546011)(6506007)(26005)(8936002)(81156014)(478600001)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mzXqDzag92Dab6fFB+4ppj7llYpqiJW5+OS4NUmVnOo2WSdI3SW76UoDGSEyJCam14zCXHsCk24uFNfI1Ez8wLZzfrTiR9fVm5lgwE78nZfp8LEZtqWpeYgMDrPPqA2pF7t78a3VsouA3rnfSqETWcF+4V+YU6Av7gjgu/aXDIZ1w0k8YtAQYciqTvH4Veim5tJqfi7kcyilivo2Nm++7txadQh+bsFMrPgJbdWXX4SdHQB5tJziryaLqZURN0QGU7yEKHk7iISNgs68pGOiL4cKfWPUJxhEz4+ZATUfsx9u0fTl7Y4NWv1f3DDgCwq0Qt0fGJmVGaeLQFIU+qRvlEgXjbOvP0+hw+tOJY1BFeG/cNjG0WyBzU2ZksceuV8EvN1F2eZQp1GQpKcdpK1zUWkiBJrc6yXLUdN/4Aa/8LxFf+2Y0n+XIeCVk6XMxCKy
x-ms-exchange-antispam-messagedata: 7dZErSLe/iTSwlIL0+9qPV1dMM0GdUxO1XFENN97hWiB6S67fpRlaJee2G4HaML1UuEmAwqoKApLZQ9XY5VcoB98ue0a8YDsqtBVEfrbszWKUKvg9sIhjlO1wVWMB25l8NUOoew6jy5EogLdXmaqgg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5E26D8D6312FF48A2B2B1029454549C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91839159-9afa-460e-e72c-08d7dcf89048
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2020 02:40:42.6221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9DD6JIpUCc8BmEC8ZAlWnZtmkpiuvGNp+Nthu0scwe+Oq4DzAcwJOcwk0nKEJsyRm+7+EXQcsomp+W5ddOWjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4895
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTA5IGF0IDExOjQxICswMzAwLCBKYW5pIE5pa3VsYSB3cm90ZToNCj4g
T24gV2VkLCAwOCBBcHIgMjAyMCwgSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUuY2E+IHdyb3Rl
Og0KPiA+IE9uIFdlZCwgQXByIDA4LCAyMDIwIGF0IDEwOjQ5OjQ4UE0gKzAyMDAsIEFybmQgQmVy
Z21hbm4gd3JvdGU6DQo+ID4gPiBPbiBXZWQsIEFwciA4LCAyMDIwIGF0IDEwOjM4IFBNIE5pY29s
YXMgUGl0cmUgPG5pY29AZmx1eG5pYy5uZXQ+DQo+ID4gPiB3cm90ZToNCj4gPiA+ID4gT24gV2Vk
LCA4IEFwciAyMDIwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPiA+ID4gPiA+IEkgaGF2ZSBjcmVh
dGVkIHdvcmthcm91bmRzIGZvciB0aGUgS2NvbmZpZyBmaWxlcywgd2hpY2ggbm93DQo+ID4gPiA+
ID4gc3RvcCB1c2luZw0KPiA+ID4gPiA+IGltcGx5IGFuZCBkbyBzb21ldGhpbmcgZWxzZSBpbiBl
YWNoIGNhc2UuIEkgZG9uJ3Qga25vdw0KPiA+ID4gPiA+IHdoZXRoZXIgdGhlcmUgd2FzDQo+ID4g
PiA+ID4gYSBidWcgaW4gdGhlIGtjb25maWcgY2hhbmdlcyB0aGF0IGhhcyBsZWQgdG8gYWxsb3dp
bmcNCj4gPiA+ID4gPiBjb25maWd1cmF0aW9ucyB0aGF0DQo+ID4gPiA+ID4gd2VyZSBub3QgbWVh
bnQgdG8gYmUgbGVnYWwgZXZlbiB3aXRoIHRoZSBuZXcgc2VtYW50aWNzLCBvciBpZg0KPiA+ID4g
PiA+IHRoZSBLY29uZmlnDQo+ID4gPiA+ID4gZmlsZXMgaGF2ZSBzaW1wbHkgYmVjb21lIGluY29y
cmVjdCBub3cgYW5kIHRoZSB0b29sIHdvcmtzIGFzDQo+ID4gPiA+ID4gZXhwZWN0ZWQuDQo+ID4g
PiA+IA0KPiA+ID4gPiBJbiBtb3N0IGNhc2VzIGl0IGlzIHRoZSBjb2RlIHRoYXQgaGFzIHRvIGJl
IGZpeGVkLiBJdCB0eXBpY2FsbHkNCj4gPiA+ID4gZG9lczoNCj4gPiA+ID4gDQo+ID4gPiA+ICAg
ICAgICAgaWYgKElTX0VOQUJMRUQoQ09ORklHX0ZPTykpDQo+ID4gPiA+ICAgICAgICAgICAgICAg
ICBmb29faW5pdCgpOw0KPiA+ID4gPiANCj4gPiA+ID4gV2hlcmUgaXQgc2hvdWxkIHJhdGhlciBk
bzoNCj4gPiA+ID4gDQo+ID4gPiA+ICAgICAgICAgaWYgKElTX1JFQUNIQUJMRShDT05GSUdfRk9P
KSkNCj4gPiA+ID4gICAgICAgICAgICAgICAgIGZvb19pbml0KCk7DQo+ID4gPiA+IA0KPiA+ID4g
PiBBIGNvdXBsZSBvZiBzdWNoIHBhdGNoZXMgaGF2ZSBiZWVuIHByb2R1Y2VkIGFuZCBxdWV1ZWQg
aW4gdGhlaXINCj4gPiA+ID4gcmVzcGVjdGl2ZSB0cmVlcyBhbHJlYWR5Lg0KPiA+ID4gDQo+ID4g
PiBJIHRyeSB0byB1c2UgSVNfUkVBQ0hBQkxFKCkgb25seSBhcyBhIGxhc3QgcmVzb3J0LCBhcyBp
dCB0ZW5kcyB0bw0KPiA+ID4gY29uZnVzZSB1c2VycyB3aGVuIGEgc3Vic3lzdGVtIGlzIGJ1aWx0
IGFzIGEgbW9kdWxlIGFuZCBhbHJlYWR5DQo+ID4gPiBsb2FkZWQgYnV0IHNvbWV0aGluZyByZWx5
aW5nIG9uIHRoYXQgc3Vic3lzdGVtIGRvZXMgbm90IHVzZSBpdC4NCj4gPiA+IA0KPiA+ID4gSW4g
dGhlIHNpeCBwYXRjaGVzIEkgbWFkZSwgSSBoYWQgdG8gdXNlIElTX1JFQUNIQUJMRSgpIG9uY2Us
DQo+ID4gPiBmb3IgdGhlIG90aGVycyBJIHRlbmRlZCB0byB1c2UgYSBLY29uZmlnIGRlcGVuZGVu
Y3kgbGlrZQ0KPiA+ID4gDQo+ID4gPiAnZGVwZW5kcyBvbiBGT08gfHwgRk9PPW4nDQo+ID4gDQoN
ClRoaXMgYXNzdW1lcyB0aGF0IHRoZSBtb2R1bGUgdXNpbmcgRk9PIGhhcyBpdHMgb3duIGZsYWcg
cmVwcmVzZW50aW5nDQpGT08gd2hpY2ggaXMgbm90IGFsd2F5cyB0aGUgY2FzZS4NCg0KZm9yIGV4
YW1wbGUgaW4gbWx4NSB3ZSB1c2UgVlhMQU4gY29uZmlnIGZsYWcgZGlyZWN0bHkgdG8gY29tcGls
ZSBWWExBTg0KcmVsYXRlZCBmaWxlczoNCg0KbWx4NS9jb3JlL01ha2VmaWxlOg0KDQpvYmotJChD
T05GSUdfTUxYNV9DT1JFKSArPSBtbHg1X2NvcmUubw0KDQptbHg1X2NvcmUteSA6PSBtbHg1X2Nv
cmUubw0KbWx4NV9jb3JlLSQoVlhMQU4pICs9IG1seDVfdnhsYW4ubw0KDQphbmQgaW4gbWx4NV9t
YWluLm8gd2UgZG86DQogDQppZiAoSVNfRU5BQkxFRChWWExBTikpDQogICAgICAgbWx4NV92eGxh
bl9pbml0KCkNCg0KYWZ0ZXIgdGhlIGNoYW5nZSBpbiBpbXBseSBzZW1hbnRpY3M6DQpvdXIgb3B0
aW9ucyBhcmU6DQoNCjEpIHVzZSBJU19SRUFDSEFCTEUoVlhMQU4pIGluc3RlYWQgb2YgSVNfRU5B
QkxFRChWWExBTikNCg0KMikgaGF2ZSBNTFg1X1ZYTEFOIGluIG1seDUgS2NvbmZpZyBhbmQgdXNl
IElTX0VOQUJMRUQoTUxYNV9WWExBTikgDQpjb25maWcgTUxYNV9WWExBTg0KCWRlcGVuZHMgb24g
VlhMQU4gfHwgIVZYTEFODQoJYm9vbA0KDQpTbyBpIHVuZGVyc3RhbmQgdGhhdCBldmVyeSBvbmUg
YWdyZWUgdG8gdXNlIHNvbHV0aW9uICMyID8NCg0KPiA+IEl0IGlzIHVuZm9ydHVuYXRlIGtjb25m
aWcgZG9lc24ndCBoYXZlIGEgbGFuZ3VhZ2UgZmVhdHVyZSBmb3IgdGhpcw0KPiA+IGlkaW9tLCBh
cyB0aGUgYWJvdmUgaXMgY29uZm91bmRpbmcgd2l0aG91dCBhIGxvdCBvZiBrY29uZmlnDQo+ID4g
a25vd2xlZGdlDQo+ID4gDQo+ID4gPiBJIGRpZCBjb21lIHVwIHdpdGggdGhlIElTX1JFQUNIQUJM
RSgpIG1hY3JvIG9yaWdpbmFsbHksIGJ1dCB0aGF0DQo+ID4gPiBkb2Vzbid0IG1lYW4gSSB0aGlu
ayBpdCdzIGEgZ29vZCBpZGVhIHRvIHVzZSBpdCBsaWJlcmFsbHkgOy0pDQo+ID4gDQo+ID4gSXQg
d291bGQgYmUgbmljZSB0byBoYXZlIHNvbWUgdW5pZm9ybSBwb2xpY3kgaGVyZQ0KPiA+IA0KPiA+
IEkgYWxzbyBkb24ndCBsaWtlIHRoZSBJU19SRUFDSEFCTEUgc29sdXRpb24sIGl0IG1ha2VzIHRo
aXMgbW9yZQ0KPiA+IGNvbXBsaWNhdGVkLCBub3QgbGVzcy4uDQo+IA0KPiBKdXN0IGNoaW1pbmcg
Im1lIHRvbyIgaGVyZS4NCj4gDQo+IElTX1JFQUNIQUJMRSgpIGlzIG5vdCBhIHNvbHV0aW9uLCBp
dCdzIGEgaGFjayB0byBoaWRlIGEgZGVwZW5kZW5jeQ0KPiBsaW5rDQo+IHByb2JsZW0gdW5kZXIg
dGhlIGNhcnBldCwgaW4gYSB3YXkgdGhhdCBpcyBkaWZmaWN1bHQgZm9yIHRoZSB1c2VyIHRvDQo+
IGRlYnVnIGFuZCBmaWd1cmUgb3V0Lg0KPiANCj4gVGhlIHVzZXIgdGhpbmtzIHRoZXkndmUgZW5h
YmxlZCBhIGZlYXR1cmUsIGJ1dCBpdCBkb2Vzbid0IGdldCB1c2VkDQo+IGFueXdheSwgYmVjYXVz
ZSBhIGJ1aWx0aW4gZGVwZW5kcyBvbiBzb21ldGhpbmcgdGhhdCBpcyBhIG1vZHVsZSBhbmQNCj4g
dGhlcmVmb3JlIG5vdCByZWFjaGFibGUuIENhbiBzb21lb25lIHBsZWFzZSBnaXZlIG1lIGFuIGV4
YW1wbGUgd2hlcmUNCj4gdGhhdCBraW5kIG9mIGJlaGF2aW91ciBpcyBkZXNpcmFibGU/DQo+IA0K
PiBBRkFJQ1QgSVNfUkVBQ0hBQkxFKCkgaXMgYmVjb21pbmcgbW9yZSBhbmQgbW9yZSBjb21tb24g
aW4gdGhlIGtlcm5lbCwNCj4gYnV0IGFyZ3VhYmx5IGl0J3MganVzdCBtYWtpbmcgbW9yZSB1bmRl
c2lyYWJsZSBjb25maWd1cmF0aW9ucw0KPiBwb3NzaWJsZS4gQ29uZmlndXJhdGlvbnMgdGhhdCBz
aG91bGQgc2ltcGx5IGJlIGJsb2NrZWQgYnkgdXNpbmcNCj4gc3VpdGFibGUNCj4gZGVwZW5kZW5j
aWVzIG9uIHRoZSBLY29uZmlnIGxldmVsLg0KPiANCj4gRm9yIGV4YW1wbGUsIHlvdSBoYXZlIHR3
byBncmFwaGljcyBkcml2ZXJzLCBvbmUgYnVpbHRpbiBhbmQgYW5vdGhlcg0KPiBtb2R1bGUuIFRo
ZW4geW91IGhhdmUgYmFja2xpZ2h0IGFzIGEgbW9kdWxlLiBVc2luZyBJU19SRUFDSEFCTEUoKSwN
Cj4gYmFja2xpZ2h0IHdvdWxkIHdvcmsgaW4gb25lIGRyaXZlciwgYnV0IG5vdCB0aGUgb3RoZXIu
IEknbSBzdXJlIHRoZXJlDQo+IGlzDQo+IHRoZSBvZGRiYWxsIHBlcnNvbiB3aG8gZmluZHMgdGhp
cyBkZXNpcmFibGUsIGJ1dCB0aGUgb3ZlcndoZWxtaW5nDQo+IG1ham9yaXR5IHdvdWxkIGp1c3Qg
bWFrZSB0aGUgZGVwcyBzdWNoIHRoYXQgZWl0aGVyIHlvdSBtYWtlIGFsbCBvZg0KPiB0aGVtDQo+
IG1vZHVsZXMsIG9yIGFsc28gcmVxdWlyZSBiYWNrbGlnaHQgdG8gYmUgYnVpbHRpbi4NCj4gDQoN
CnRoZSBwcmV2aW91cyBpbXBseSBzZW1hbnRpY3MgaGFuZGxlZCB0aGlzIGJ5IGZvcmNpbmcgYmFj
a2xpZ2h0IHRvIGJlDQpidWlsdC1pbiwgd2hpY2ggd29ya2VkIG5pY2VseS4NCg0KPiANCj4gQlIs
DQo+IEphbmkuDQo+IA0KPiANCg==
