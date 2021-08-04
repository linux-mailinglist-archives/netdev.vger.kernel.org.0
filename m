Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49A93DFF6C
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 12:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbhHDKcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 06:32:41 -0400
Received: from mail-eopbgr1410094.outbound.protection.outlook.com ([40.107.141.94]:57952
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236964AbhHDKck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 06:32:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvrxy66S8akm5vRLC3SGQ0iyQ2jeY1ApT926j5zIS6V3jzGNCHdmVwO0OPSlB8QuIBdolfxvzrGDu9GvCbGhHbkvvc7eXtUjODgfuxVKrFZQ/LR6CedBei3DpL9+/9f5pB1ZMsH1IxQ/IZdqrzWVQJTR57vjse1FjQZwTmAXric5NzepihwVxh4G3fuIK0tiPpGB3RbdEDXRYxmu2PwvSck3BzZPO0DFe1FbHf9L64w/bASojQwOPgiOEtBDt0rAC9NMexxRW3NGrch+VJrlWd/lBBVBMRrRDY+KfaaLSTNaqNcs5gyozMVEoPEpY92S9wb2rWzsjd1iLExX0EcxYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6VcoXIHT6ogkBNydjj1mtNryXs9i+VCvnYNECm9/H0=;
 b=iG50vByL67uZXcWSMUoJSpCbMyctsp34TnQjcLQ0KDll/mmXtw7Lfhi4V9Etgt9RiKmdWgpidOcxhWmpyvVY4uueMEWADulAVlreO91StkMPdkgjR/2Zrtbo+z71enetPjLU62LqjmB61uHcCEypyCojgfIYJdZ12GiRExYSo7hI7wehLBE++PjkQu4dA3wytE8qErK76T0Hdqq2pyJ78KVHdaqELpSa4NqwMcsovZSkxEsV+VC3T5YpblWNtgxpYq+5ZUNkkRFRMkwIwPzLtvQ7lSRN832cH+BWv9BDb+ul0JCrwrICmYpacZ9aWQ+dbpn8BYOmyG3ZuIpLw6Wncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6VcoXIHT6ogkBNydjj1mtNryXs9i+VCvnYNECm9/H0=;
 b=YGbyzf10BG/N6dzyuT1/T644OATNDdmp+ExPBJQg/mrBlXPKZkw3bdXx6QHzmAtmS4TPVkYwwW8vGH2Cw4c/DYaDgXuKi5Uy6fFcd/j+Fp10TNLOOeyupTR9gdctQRyet4qJGdYSu2nLFYrWa6gwnbERCfTQNlIlF0LGJ3yF+2U=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5444.jpnprd01.prod.outlook.com (2603:1096:604:ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Wed, 4 Aug
 2021 10:32:24 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 10:32:24 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
Thread-Topic: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
Thread-Index: AQHXh4kJVg2tFXlcHEytJvY9Z7FsDqtiSZqAgACEk/CAAFeEgIAAAU1Q
Date:   Wed, 4 Aug 2021 10:32:24 +0000
Message-ID: <OS0PR01MB5922015F2C73A8DB20F6BCC786F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ad727120-3ae6-4db7-e368-f06c82cfa759@gmail.com>
 <OS0PR01MB5922974FA17E6ABB4697B6B986F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <2815f1f1-0e69-0a06-2874-318af4b76292@gmail.com>
In-Reply-To: <2815f1f1-0e69-0a06-2874-318af4b76292@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 528f346c-c8dc-4bed-4c11-08d957332620
x-ms-traffictypediagnostic: OS0PR01MB5444:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB5444E9C723FA02E2A5CE6B4386F19@OS0PR01MB5444.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Kd1iC8ChJP9iz7DcC2qXESBtv0VI0+9vo7adZBxalZXbv5TNPwI8oAC4Em0Ja2a2inSo13V5wJl7Bv7AtEMm3lU6mb9Deu5Kg48108x2DjyxfF+reIOcydnrc4pqWnf9GneOEbjA52/lCEg1S32JyL22v7PCQBlHJD8y6xWq6X1vxMEWZriY9OeuDX6hf0iJTvwdpb1ABrrU0+jv+OdD5laLYJmNf2+mkRUv/AR0U4aB7SLqfFUDl6uqnYho4Vk0zPke3yZ5uXdHr6q/UjqtIW3cwnSZnQim75Yvr8N/uPrPgG06/n8ydjV+g9YE7E0uc3368r8g8Z/nDAMzuyyw0wjnlNdZJD5MZrgvw1JxlOAWKtGac0DXQP0tecHrIA+Q7xS1QvEmOOBqKqjioP9mQwVqs43gfqj6uyMpoSJ5UH73XULg8VmSyE4skUrY4jK76YLVMy85X4kSI6rnnuCIz77kRjsX44mFRJq6Okl7fhsuNXWHQMoxpI4N9rKbLj9PHjCl8mdAJQFUhrH4s1ytqlHerxMrCefBAj5oC+N/b0OBC4+3M9rkFQof5odZ5w7HeTcOkjjDuvY6rvh9l5lWIRYeeYU7bl942E2G1veUU47qmKdoVUhRvuQOEuuNhau3yZAMg7YyvvwQU8bFhW9gXyTzHLbarA+y3cCxHVf9IJQqA6aMCVlxH4v1ZMEbCrPJnF0gAkSTx6vilajeQ0VCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(4326008)(38100700002)(54906003)(122000001)(53546011)(110136005)(7696005)(107886003)(6506007)(26005)(316002)(8676002)(38070700005)(55016002)(8936002)(33656002)(9686003)(186003)(7416002)(76116006)(2906002)(478600001)(71200400001)(52536014)(66556008)(66446008)(64756008)(66946007)(66476007)(83380400001)(5660300002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDgvTXdlUjRwWldqQ1lYTTcrNmQ5aWp1RmhvK3JNNTNtQS9mS052SFJqUVVL?=
 =?utf-8?B?OTNjT3hCNFBleDhza2RVUVV3MFdRUlhvMllTb3psNCsrVU5qR0tLbnpNRXkz?=
 =?utf-8?B?Q1BUZmhXczd5eFBRR0VUVWM3OTAxcXc4NURVNFJ3VVRwQ3BwWEFDVFV3QjV0?=
 =?utf-8?B?TC9EZDg2eGZIRzNmOUYzQkovVnN5a3RPN0JwVWFNeTF5b1hta2hxazVUK0tW?=
 =?utf-8?B?R1BKcGVFakpXZlp2cC8vT1k2SDZFcHM3TzY3c2hNV3BiUVhBTDMyODNQbE5l?=
 =?utf-8?B?RXYwWjNDM1Q1RkRKcVUxTmVsUEV6QkZNeXVNSU02RnlXSTlTcGp0SlRnd3NH?=
 =?utf-8?B?cmU1Z3YyQ2RZT3g2TmIyTmZaRkVOYzVyVTBrSG9tYitwVllsa3R5MEIzbzhw?=
 =?utf-8?B?OWZFdGJWbTFiOXVZd0k0eUxnNXNuaVBhWmRYZlR2cGsyVWl6VjhLbC9JdzVm?=
 =?utf-8?B?cXh6TFI1L1VmbnNoR21JWVRuM2J3UnJVY3gvbGxLbGpMRDVjY3ZUc2srdnVH?=
 =?utf-8?B?YTJlSDFFVDJNL0tiUTNtcTlKWk9lL3kwblhMR0l3TEpOSEZYUE4xK1VjcTlk?=
 =?utf-8?B?VHdQYXk5em9aYjZBemllOHBDUlBUT1NIUWZ0bk9tNHF1T2tqaFlISTNXUDlm?=
 =?utf-8?B?eDNSdXJ6amZTM2N0MXJEc0xLWWh4WitVWklCeGEvQmNuRDkvUU5hNExxb3ZH?=
 =?utf-8?B?dGtGbWVkMEVQMExmOGh0TDNBMkpMRCtqVWh2c0JyQ1h6MFIrTFFnUG5rb1ps?=
 =?utf-8?B?YlVmaVNuYk0xOGNqRW5mTldhak5yTTE3MDhmcm5YVXh6UlBTempFWmx0dmdL?=
 =?utf-8?B?eFcwTWVXVWhFTWowU2lJRnhHRjhoRmhjdU9kQVpPaGVlYWJhUkR3K2lIdUtl?=
 =?utf-8?B?dWU3bGZ1SGh4UEpxaUZUUjVlSnh2QnlHSVlGbXNHdDhzU2dzYmNjZzE0amF4?=
 =?utf-8?B?aHczQVJkMmFUWm9Nd1h5bTYwKzhlaks1WW0vZG5jQVdZMWZWQnZ4MS9WOEhi?=
 =?utf-8?B?Y09uNHlaSXJEamFGeExSbkxWa3NuL3IzNUlMNmV3dnFxOVRxdW9kd2lmTWVj?=
 =?utf-8?B?dlRFTEtORkRHcncyV1ZoVHhmcU00T0pzLy8ybVB3MzVGRFFmYlRSRjVqMnBV?=
 =?utf-8?B?MkJJa2xuRitMeFM3VDYwamNKZ0JLUWlUMFRWczJmVGYvTyt5bVNuVzF2OXRo?=
 =?utf-8?B?V082K3lYRTQ0WjlTOHk1MjVlc3ZUN1YwRHJ1Nkl4bmw5dVRHWWhJWk1pZ0xw?=
 =?utf-8?B?TnNNUzFIM04yVkl4a0NMaENoOGIrZlB0MjBqeE9PMkN3RG9aYkh0TTAvM3Uw?=
 =?utf-8?B?eWZWS25hVWRsYk9FTlRFa0dKcU5tM3piVVZXdVA2WDFwVGxCb3dxMjB1SDVY?=
 =?utf-8?B?OFVLYzZJM0RJUklsRjhtdUVERXhwRE54T3ZWRlBOdHlqMG5BWHZGSmhNSFNY?=
 =?utf-8?B?YzRTZGFHLzVuamJiTTR4V0MvWG9tUlFwbUVXRmY1NDJkUGZBQnVTTytBWXVK?=
 =?utf-8?B?VUVpZUtBazQrK1BpSDBIY0QreWxuUk56VEdiTmVmSUhUN2M0VktuUVk4L2Mw?=
 =?utf-8?B?amJKUE9rSWVmL0VqT3pFWGJVcFJacWp4cTdHMmp6T3hQejZUcXBLcXZDTjdk?=
 =?utf-8?B?MTdqWmd1eGZrbk1KSXhWbDFsOGp4WGRtZ1NYMUw1aWFNVUE3VGJvbjMwV25M?=
 =?utf-8?B?d3FQSjh1Z3N4UHFDYWJXN0hkUW5ObkEzWWl2S2tVWmxVZDI4d3dZL2lERXc1?=
 =?utf-8?Q?wIS8TtInyKi0R8M10d6nhMwegLwUF8Q0doMLdv9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528f346c-c8dc-4bed-4c11-08d957332620
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 10:32:24.2592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o8XeNye1/a6GIZZSOZXPSV39aWWKZEGZOJIL12Ka7se0u3eTeYxBqBMjQ5AyraCBMgUaV3waV+npoKjpv5Nv3T6SNN0qwPx8PrYEKw1vq94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5444
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIgNy84XSByYXZi
OiBBZGQgaW50ZXJuYWwgZGVsYXkgaHcgZmVhdHVyZQ0KPiB0byBzdHJ1Y3QgcmF2Yl9od19pbmZv
DQo+IA0KPiBPbiAwNC4wOC4yMDIxIDg6MTMsIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gWy4uLl0N
Cj4gPj4+IFItQ2FyIEdlbjMgc3VwcG9ydHMgVFggYW5kIFJYIGNsb2NrIGludGVybmFsIGRlbGF5
IG1vZGVzLCB3aGVyZWFzDQo+ID4+PiBSLUNhcg0KPiA+Pj4gR2VuMiBhbmQgUlovRzJMIGRvIG5v
dCBzdXBwb3J0IGl0Lg0KPiA+Pj4gQWRkIGFuIGludGVybmFsX2RlbGF5IGh3IGZlYXR1cmUgYml0
IHRvIHN0cnVjdCByYXZiX2h3X2luZm8gdG8NCj4gPj4+IGVuYWJsZSB0aGlzIG9ubHkgZm9yIFIt
Q2FyIEdlbjMuDQo+ID4+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFz
Lmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+Pj4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIgPHBy
YWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4g
djI6DQo+ID4+PiAgICogSW5jb3Jwb3JhdGVkIEFuZHJldyBhbmQgU2VyZ2VpJ3MgcmV2aWV3IGNv
bW1lbnRzIGZvciBtYWtpbmcgaXQNCj4gPj4gc21hbGxlciBwYXRjaA0KPiA+Pj4gICAgIGFuZCBw
cm92aWRlZCBkZXRhaWxlZCBkZXNjcmlwdGlvbi4NCj4gPj4+IC0tLQ0KPiA+Pj4gICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMyArKysNCj4gPj4+ICAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDYgKysrKy0tDQo+ID4+PiAgIDIg
ZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4g
Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+
Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gaW5kZXggM2Rm
ODEzYjJlMjUzLi4wZDY0MGRiZTFlZWQgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiLmgNCj4gPj4+IEBAIC05OTgsNiArOTk4LDkgQEAgc3RydWN0IHJhdmJfaHdf
aW5mbyB7DQo+ID4+PiAgIAlpbnQgbnVtX3R4X2Rlc2M7DQo+ID4+PiAgIAlpbnQgc3RhdHNfbGVu
Ow0KPiA+Pj4gICAJc2l6ZV90IHNrYl9zejsNCj4gPj4+ICsNCj4gPj4+ICsJLyogaGFyZHdhcmUg
ZmVhdHVyZXMgKi8NCj4gPj4+ICsJdW5zaWduZWQgaW50ZXJuYWxfZGVsYXk6MTsJLyogUkFWQiBo
YXMgaW50ZXJuYWwgZGVsYXlzICovDQo+ID4+DQo+ID4+ICAgICBPb3BzLCBtaXNzZWQgaXQgaW5p
dGlhbGx5Og0KPiA+PiAgICAgUkFWQj8gVGhhdCdzIG5vdCBhIGRldmljZSBuYW1lLCBhY2NvcmRp
bmcgdG8gdGhlIG1hbnVhbHMuIEl0DQo+ID4+IHNlZW1zIHRvIGJlIHRoZSBkcml2ZXIncyBuYW1l
Lg0KPiA+DQo+ID4gT0suIHdpbGwgY2hhbmdlIGl0IHRvIEFWQi1ETUFDIGhhcyBpbnRlcm5hbCBk
ZWxheXMuDQo+IA0KPiAgICAgUGxlYXNlIGRvbid0IC0tIEUtTUFDIGhhcyB0aGVtLCBub3QgQVZC
LURNQUMuDQoNClNpbmNlIHRoZSByZWdpc3RlciBmb3Igc2V0dGluZyBpbnRlcm5hbCBkZWxheSBt
b2RlIGlzIGNvbWluZyBmcm9tIHByb2R1Y3Qgc3BlY2lmaWMgcmVnaXN0ZXIoMHg4YyksDQpJIGFt
IGFncmVlaW5nIHdpdGggeW91ciBzdGF0ZW1lbnQsICJFLU1BQyBoYXMgaW50ZXJuYWwgZGVsYXlz
Ii4NCg0KQ2hlZXJzLA0KQmlqdQ0K
