Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC884810
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbfHGIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:48:30 -0400
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:58083 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbfHGIsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:48:30 -0400
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.191) BY m9a0003g.houston.softwaregrp.com WITH ESMTP;
 Wed,  7 Aug 2019 08:48:19 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 7 Aug 2019 08:38:46 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (15.124.72.11) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 7 Aug 2019 08:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMxhm3bibX6KEfVwZIG2lmaDgQK31kJWJll74AiGg2Bgh/G0mQYFYxC+/VrhIDY0/8pvA4QDUH7ZBhJmROIO/byS2Y2JXja+zn7FUMZS+iAJUbN/VSZ5Cjvpxl4iKfMu5Xi58tEARCc5uAz9p9L8X7Gh0lFTA1PLcndKvDTqrM1asCIirtI3dSyQo/XgsEjcwUZaKxh/ofyW3sMQrMcjTPvdxSfWro4Xgb25uOi8l50ZU9LWVre08Ht2VFyNmbS9YlL6XyQ2B9O+DRRa49Uwow64lGv7gblH3FWbVFwSxJi73MpZGI74Rop7M+kWWWk9FFhTqoKjhLPBaWTFwyoJzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ng1DD3SFfeBrAtK6l5D6DPzBzE7BXJRk8H2HW4r835w=;
 b=CHfkXXVF15LzcaoWApau4GGcduz/poLK/rv1eFJnSPsbqLZgTvZq/7abZUAmHunsJPQ2NU6pCw32ispibWe1YKfO4pLKVtwUBSOEIP5G1SobAJ+2e6M5hlZRUr4izDTaguejjjCTkCfNoAOW1TcCH4JeHssLlHQBQP5CCaHg6MXpiLCgLcBkS3TA1Nodc7Takz+2yK7Gt+PQuMEcRlMFtwcWXbJ/7BYp7/+WzsnEGNtwZa70cxfJKOI6OvFTmeRGwPxRyUeNL38aQgl4zXrOjOGxCteF0HOPAvSaA62YmJCv7NzRIylvea+ytfn4dsyuWM9RYd5ImAEGNmWfQIoqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) by
 BY5PR18MB3121.namprd18.prod.outlook.com (10.255.136.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 08:38:44 +0000
Received: from BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac]) by BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac%4]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 08:38:44 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     Jacob Wen <jian.w.wen@oracle.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
Thread-Topic: [PATCH v2 1/1] ixgbe: sync the first fragment unconditionally
Thread-Index: AQHVTMrFkDapNm+vukGfNKy6YOsjCqbvUa91gAALugA=
Date:   Wed, 7 Aug 2019 08:38:43 +0000
Message-ID: <20190807083831.GA6811@linux-6qg8>
References: <20190807024917.27682-1-firo.yang@suse.com>
 <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
In-Reply-To: <85aaefdf-d454-1823-5840-d9e2f71ffb19@oracle.com>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR01CA0098.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::24) To BY5PR18MB3187.namprd18.prod.outlook.com
 (2603:10b6:a03:196::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d3cf22d-a1ec-42ab-cad7-08d71b12a7f5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR18MB3121;
x-ms-traffictypediagnostic: BY5PR18MB3121:
x-microsoft-antispam-prvs: <BY5PR18MB31211F7A2BEF1E2C260FC9AC88D40@BY5PR18MB3121.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(7916004)(376002)(396003)(366004)(39860400002)(136003)(346002)(199004)(189003)(102836004)(386003)(6506007)(53546011)(256004)(14444005)(25786009)(486006)(476003)(44832011)(99286004)(52116002)(76176011)(26005)(4326008)(229853002)(6436002)(6486002)(66066001)(2906002)(6916009)(71190400001)(71200400001)(33656002)(186003)(6246003)(9686003)(6512007)(53936002)(1076003)(54906003)(7736002)(33716001)(5660300002)(86362001)(478600001)(316002)(6116002)(3846002)(8676002)(446003)(8936002)(305945005)(66446008)(66946007)(66476007)(66556008)(64756008)(68736007)(81166006)(81156014)(14454004)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3121;H:BY5PR18MB3187.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RVOxiQzOZoigePJeViL6aUais+xvG2E2cPJMS1uyYVzuYlmpZFb60MFGIcWbjXU+42AUFrp27dTOkrKh7LQZJ7LWSE+A9FWjn9E8WmzBDcKsyj+7JYSeivbfs4+cXj8EAbBoEe2bF308LH/t+AJuq+vck9EqJI4tR3uYSf8iXxVcW4yEzQ0psmiIM0vfgUUnmrj8SK1OK51FzJ0IK/qdd1NPUaJiw8aOAcsV3wbWFe3In3ITq3lAAghs0hY2fjTziwN5GQM/RESkLZ/rhTll1eUk5loEf1uqWDzBdizquD9xVajRbYNCMI5/hWE80UYR+VcVZXVkNspTjV71WtmOs0qAjc3jtZbXsoqtzlO0AmVRfzRYtGGG6mZqn75cwn03JUXelmnt8yapOdCHewWW9pNP4f48bVXMFBWbYnanJmI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <24F50199789C5E4F9AEBC58ED3001D71@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3cf22d-a1ec-42ab-cad7-08d71b12a7f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 08:38:43.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XOa5w/RqWrj4Zt7EwvRsshDN09oOVQPJTM6KoLY2+wlFmdl/sdbSoxE+uo36gRYW/3PYzJQBcdCkDvoHT4zhXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3121
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA4LzA3LzIwMTkgMTU6NTYsIEphY29iIFdlbiB3cm90ZToNCj4gSSB0aGluayB0aGUgZGVz
Y3JpcHRpb24gaXMgbm90IGNvcnJlY3QuIENvbnNpZGVyIHVzaW5nIHNvbWV0aGluZyBsaWtlIGJl
bG93Lg0KVGhhbmsgeW91IGZvciBjb21tZW50cy4gDQoNCj4gDQo+IEluIFhlbiBlbnZpcm9ubWVu
dCwgZHVlIHRvIG1lbW9yeSBmcmFnbWVudGF0aW9uIGl4Z2JlIG1heSBhbGxvY2F0ZSBhICdETUEn
DQo+IGJ1ZmZlciB3aXRoIHBhZ2VzIHRoYXQgYXJlIG5vdCBwaHlzaWNhbGx5IGNvbnRpZ3VvdXMu
DQpBY3R1YWxseSwgSSBkaWRuJ3QgbG9vayBpbnRvIHRoZSByZWFzb24gd2h5IGl4Z2JlIGdvdCBh
IERNQSBidWZmZXIgd2hpY2gNCndhcyBtYXBwZWQgdG8gWGVuLXN3aW90bGIgYXJlYS4NCg0KQnV0
IEkgZG9uJ3QgdGhpbmsgdGhpcyBpc3N1ZSByZWxhdGVzIHRvIHBoc2ljYWwgbWVtb3J5IGNvbnRp
Z3VpdHkgYmVjYXVzZSwgaW4NCm91ciBjYXNlLCBvbmUgaXhnYmVfcnhfYnVmZmVyIG9ubHkgYXNz
b2NpYXRlcyBhdCBtb3N0IG9uZSBwYWdlLg0KDQpJZiB5b3UgdGFrZSBhIGxvb2sgYXQgdGhlIHJl
bGF0ZWQgY29kZSwgeW91IHdpbGwgZmluZCB0aGVyZSBhcmUgc2V2ZXJhbCByZWFzb25zDQpmb3Ig
bWFwcGluZyBhIERNQSBidWZmZXIgdG8gWGVuLXN3aW90bGIgYXJlYToNCnN0YXRpYyBkbWFfYWRk
cl90IHhlbl9zd2lvdGxiX21hcF9wYWdlKHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IHBhZ2Ug
KnBhZ2UsDQogICAgICAgICAqLw0KICAgICAgICBpZiAoZG1hX2NhcGFibGUoZGV2LCBkZXZfYWRk
ciwgc2l6ZSkgJiYNCiAgICAgICAgICAgICFyYW5nZV9zdHJhZGRsZXNfcGFnZV9ib3VuZGFyeShw
aHlzLCBzaXplKSAmJg0KICAgICAgICAgICAgICAgICF4ZW5fYXJjaF9uZWVkX3N3aW90bGIoZGV2
LCBwaHlzLCBkZXZfYWRkcikgJiYNCiAgICAgICAgICAgICAgICBzd2lvdGxiX2ZvcmNlICE9IFNX
SU9UTEJfRk9SQ0UpDQogICAgICAgICAgICAgICAgZ290byBkb25lOw0KDQovLyBGaXJvDQo+IA0K
PiBBIE5JQyBkb2Vzbid0IHN1cHBvcnQgZGlyZWN0bHkgd3JpdGUgc3VjaCBidWZmZXIuIFNvIHhl
bi1zd2lvdGxiIHdvdWxkIHVzZQ0KPiB0aGUgcGFnZXMsIHdoaWNoIGFyZSBwaHlzaWNhbGx5IGNv
bnRpZ3VvdXMsIGZyb20gdGhlIHN3aW90bGIgYnVmZmVyIGZvciB0aGUNCj4gTklDLg0KPiANCj4g
VGhlIHVubWFwIG9wZXJhdGlvbiBpcyB1c2VkIHRvIGNvcHkgdGhlIHN3aW90bGIgYnVmZmVyIHRv
IHRoZSBwYWdlcyB0aGF0IGFyZQ0KPiBhbGxvY2F0ZWQgYnkgaXhnYmUuDQo+IA0KPiBPbiA4Lzcv
MTkgMTA6NDkgQU0sIEZpcm8gWWFuZyB3cm90ZToNCj4gPiBJbiBYZW4gZW52aXJvbm1lbnQsIGlm
IFhlbi1zd2lvdGxiIGlzIGVuYWJsZWQsIGl4Z2JlIGRyaXZlcg0KPiA+IGNvdWxkIHBvc3NpYmx5
IGFsbG9jYXRlIGEgcGFnZSwgRE1BIG1lbW9yeSBidWZmZXIsIGZvciB0aGUgZmlyc3QNCj4gPiBm
cmFnbWVudCB3aGljaCBpcyBub3Qgc3VpdGFibGUgZm9yIFhlbi1zd2lvdGxiIHRvIGRvIERNQSBv
cGVyYXRpb25zLg0KPiA+IFhlbi1zd2lvdGxiIGhhdmUgdG8gaW50ZXJuYWxseSBhbGxvY2F0ZSBh
bm90aGVyIHBhZ2UgZm9yIGRvaW5nIERNQQ0KPiA+IG9wZXJhdGlvbnMuIEl0IHJlcXVpcmVzIHN5
bmNpbmcgYmV0d2VlbiB0aG9zZSB0d28gcGFnZXMuIEhvd2V2ZXIsDQo+ID4gc2luY2UgY29tbWl0
IGYzMjEzZDkzMjE3MyAoIml4Z2JlOiBVcGRhdGUgZHJpdmVyIHRvIG1ha2UgdXNlIG9mIERNQQ0K
PiA+IGF0dHJpYnV0ZXMgaW4gUnggcGF0aCIpLCB0aGUgdW5tYXAgb3BlcmF0aW9uIGlzIHBlcmZv
cm1lZCB3aXRoDQo+ID4gRE1BX0FUVFJfU0tJUF9DUFVfU1lOQy4gQXMgYSByZXN1bHQsIHRoZSBz
eW5jIGlzIG5vdCBwZXJmb3JtZWQuDQo+ID4gDQo+ID4gVG8gZml4IHRoaXMgcHJvYmxlbSwgYWx3
YXlzIHN5bmMgYmVmb3JlIHBvc3NpYmx5IHBlcmZvcm1pbmcgYSBwYWdlDQo+ID4gdW5tYXAgb3Bl
cmF0aW9uLg0KPiA+IA0KPiA+IEZpeGVzOiBmMzIxM2Q5MzIxNzMgKCJpeGdiZTogVXBkYXRlIGRy
aXZlciB0byBtYWtlIHVzZSBvZiBETUENCj4gPiBhdHRyaWJ1dGVzIGluIFJ4IHBhdGgiKQ0KPiA+
IFJldmlld2VkLWJ5OiBBbGV4YW5kZXIgRHV5Y2sgPGFsZXhhbmRlci5oLmR1eWNrQGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBGaXJvIFlhbmcgPGZpcm8ueWFuZ0BzdXNlLmNv
bT4NCj4gPiAtLS0NCj4gPiANCj4gPiBDaGFuZ2VzIGZyb20gdjE6DQo+ID4gICAqIEltcG9ydmVk
IHRoZSBwYXRjaCBkZXNjcmlwdGlvbi4NCj4gPiAgICogQWRkZWQgUmV2aWV3ZWQtYnk6IGFuZCBG
aXhlczogYXMgc3VnZ2VzdGVkIGJ5IEFsZXhhbmRlciBEdXljaw0KPiA+IA0KPiA+ICAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jIHwgMTYgKysrKysrKysrLS0t
LS0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhn
YmUvaXhnYmVfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVf
bWFpbi5jDQo+ID4gaW5kZXggY2JhZjcxMmQ2NTI5Li4yMDBkZTk4MzgwOTYgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4g
QEAgLTE4MjUsMTMgKzE4MjUsNyBAQCBzdGF0aWMgdm9pZCBpeGdiZV9wdWxsX3RhaWwoc3RydWN0
IGl4Z2JlX3JpbmcgKnJ4X3JpbmcsDQo+ID4gICBzdGF0aWMgdm9pZCBpeGdiZV9kbWFfc3luY19m
cmFnKHN0cnVjdCBpeGdiZV9yaW5nICpyeF9yaW5nLA0KPiA+ICAgCQkJCXN0cnVjdCBza19idWZm
ICpza2IpDQo+ID4gICB7DQo+ID4gLQkvKiBpZiB0aGUgcGFnZSB3YXMgcmVsZWFzZWQgdW5tYXAg
aXQsIGVsc2UganVzdCBzeW5jIG91ciBwb3J0aW9uICovDQo+ID4gLQlpZiAodW5saWtlbHkoSVhH
QkVfQ0Ioc2tiKS0+cGFnZV9yZWxlYXNlZCkpIHsNCj4gPiAtCQlkbWFfdW5tYXBfcGFnZV9hdHRy
cyhyeF9yaW5nLT5kZXYsIElYR0JFX0NCKHNrYiktPmRtYSwNCj4gPiAtCQkJCSAgICAgaXhnYmVf
cnhfcGdfc2l6ZShyeF9yaW5nKSwNCj4gPiAtCQkJCSAgICAgRE1BX0ZST01fREVWSUNFLA0KPiA+
IC0JCQkJICAgICBJWEdCRV9SWF9ETUFfQVRUUik7DQo+ID4gLQl9IGVsc2UgaWYgKHJpbmdfdXNl
c19idWlsZF9za2IocnhfcmluZykpIHsNCj4gPiArCWlmIChyaW5nX3VzZXNfYnVpbGRfc2tiKHJ4
X3JpbmcpKSB7DQo+ID4gICAJCXVuc2lnbmVkIGxvbmcgb2Zmc2V0ID0gKHVuc2lnbmVkIGxvbmcp
KHNrYi0+ZGF0YSkgJiB+UEFHRV9NQVNLOw0KPiA+ICAgCQlkbWFfc3luY19zaW5nbGVfcmFuZ2Vf
Zm9yX2NwdShyeF9yaW5nLT5kZXYsDQo+ID4gQEAgLTE4NDgsNiArMTg0MiwxNCBAQCBzdGF0aWMg
dm9pZCBpeGdiZV9kbWFfc3luY19mcmFnKHN0cnVjdCBpeGdiZV9yaW5nICpyeF9yaW5nLA0KPiA+
ICAgCQkJCQkgICAgICBza2JfZnJhZ19zaXplKGZyYWcpLA0KPiA+ICAgCQkJCQkgICAgICBETUFf
RlJPTV9ERVZJQ0UpOw0KPiA+ICAgCX0NCj4gPiArDQo+ID4gKwkvKiBJZiB0aGUgcGFnZSB3YXMg
cmVsZWFzZWQsIGp1c3QgdW5tYXAgaXQuICovDQo+ID4gKwlpZiAodW5saWtlbHkoSVhHQkVfQ0Io
c2tiKS0+cGFnZV9yZWxlYXNlZCkpIHsNCj4gPiArCQlkbWFfdW5tYXBfcGFnZV9hdHRycyhyeF9y
aW5nLT5kZXYsIElYR0JFX0NCKHNrYiktPmRtYSwNCj4gPiArCQkJCSAgICAgaXhnYmVfcnhfcGdf
c2l6ZShyeF9yaW5nKSwNCj4gPiArCQkJCSAgICAgRE1BX0ZST01fREVWSUNFLA0KPiA+ICsJCQkJ
ICAgICBJWEdCRV9SWF9ETUFfQVRUUik7DQo+ID4gKwl9DQo+ID4gICB9DQo+ID4gICAvKioNCj4g
DQo=
