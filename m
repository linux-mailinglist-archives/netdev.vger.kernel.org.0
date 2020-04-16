Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED031AD024
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgDPTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:07:21 -0400
Received: from mail-eopbgr30088.outbound.protection.outlook.com ([40.107.3.88]:10643
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbgDPTHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 15:07:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV85uYhA1m/5dk53Ptzls006tsp3IiUMpLJ2QWwaZwqmkQ5x1aypQ4VASOQwd+d14q7XHynqD8qTpr1p8Mq1TXEF2a22AAFlYMJxjiKJT8q2pX2uMsu9MMiFHvBQNLOyV4byIIjjCaPkGKkfSUIhGx+Ow/e43d58F7CJQntSF7Os6sfjwyd8W3sK1ri1nmK716Yh5tDn+hW8CvL4b5hBXbPODcgN91qo5ATtCL+NTtE++IfiKXTso1nnG5gIL2DJmWxswLD8IOoT4kucuVBSxtY6sW+3YoIH31kp6Y5SmZyCyRYaYiVS2I1OzxX9N05vKvLQuyQSwp9UwZNzRt2fwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxjI+EdwRFtGk074+huL/btTydVieCy1erKoNeg1zBo=;
 b=JTYNs5fpwLT+w6HMgKiF/iyWuN1E7GLZ+rhqpeYdEPJ2Ra5n3Vf/Lq7vGiq9Y+a/XszxN3G1i0Yom00pzy7tRCOwB8XXvTZ1nP8zyPqdgS5ZT93LpFlPSYKDaghwU+zjnB4bZPWZ7o/U3I7GV802F2jiiVIpHORjbJiL6BcAzbuF0tWDMg1EgnOsrPDjPIZgCHgNSeVNyhL41UQhtf3W7SxDdVCG3xrRRwgly+Kc9vqVzZvGwLI2g1y229nJaV/zc2CsNWl6gGPxpFRFg5s3T01EgNGGmbepC49oH1mv685DjV2/QMciktM8NofAQDGQPBqkKlI3FBSDav+xpGHocA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxjI+EdwRFtGk074+huL/btTydVieCy1erKoNeg1zBo=;
 b=I9pkgJFTNvu8wmgRsGZSn9CPsgfPGXfa4h9pRqIiCroXqknMLXHoONNZ49UvldRGW/z/vPGakw5X5/niSGJ4PXXlU0v0IxIg8eqvoev22Q04VktiJr5OYOZJdUnJIqEdZoeqe77fVvV1Fb1KV0Rvx82+nEWO7pgfvxFSWB0+w38=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4319.eurprd05.prod.outlook.com (2603:10a6:803:3e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Thu, 16 Apr
 2020 19:07:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 19:07:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "ecree@solarflare.com" <ecree@solarflare.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Topic: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Thread-Index: AQHWEFb6WRVOJO0/j0GE4IB+QkA/0qh1Ei4AgAC1ZICAAheSAIAAjYWAgAAM6ICAADp+AIAAE8gAgABWOICAAURNAIAAgPKAgABFSICAABU+gIAAh8CAgABeMwA=
Date:   Thu, 16 Apr 2020 19:07:13 +0000
Message-ID: <550d615e14258c744cb76dd06c417d08d9e4de16.camel@mellanox.com>
References: <20200414015627.GA1068@sasha-vm>
         <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
         <20200414110911.GA341846@kroah.com>
         <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
         <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
         <20200414205755.GF1068@sasha-vm>
         <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
         <20200416000009.GL1068@sasha-vm>
         <434329130384e656f712173558f6be88c4c57107.camel@mellanox.com>
         <20200416052409.GC1309273@unreal> <20200416133001.GK1068@sasha-vm>
In-Reply-To: <20200416133001.GK1068@sasha-vm>
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
x-ms-office365-filtering-correlation-id: ce9039ce-fd3b-4d34-a171-08d7e2395f15
x-ms-traffictypediagnostic: VI1PR05MB4319:
x-microsoft-antispam-prvs: <VI1PR05MB4319B55CC6DA9065ADC0A0ADBED80@VI1PR05MB4319.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(316002)(186003)(6486002)(36756003)(110136005)(26005)(54906003)(5660300002)(8936002)(45080400002)(71200400001)(6506007)(64756008)(66556008)(81156014)(66446008)(76116006)(4326008)(478600001)(2616005)(8676002)(66476007)(966005)(66946007)(86362001)(53546011)(6512007)(2906002)(91956017);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hnsDG83Yz611M/yJHsTTR0jn5FvS4stGK92ANVtDKhQfNLF3lR4Zy59sQt+EEhchCB6OfFiIR7WY7wq3Txmt89VNADbV4urt4oJ89oZ0Xm2nphofA/V6FwWeji0QNlBAtpv1i1nh1XbtF3BDkoMM7iHopnMGqdUECSOEICADIgnq8ddVZXUoXZCEAlLMdegxvjkvQT1MMUsINcsBgxyAfPCwh0lEw48sK6RYMzmvds+yvgUZJA5uHcgWS07ZQZE8gvTWvpWGiv3WQVcXtQBxl+8gEMvOQLJUA3P20a5NjQ+eAmbZoVFX5rgFrGXXYPFlcffV5DMcVPlwGZfPpuvugL2lfnm7VXN7uVzoDWHgvC0j3KAEVHyHms/h26Bw129jceSwZYhZ7s2w2KCcFWVvOe+OU0/qpy93afBb1nHEmDcAwkwGMn5HwOxbrnYpTzzV/tiBNHPC+JXfA5+Xy46MfpOMX2NqnFLv99yoOyTzyPRgnSZQ7i0X31JrtFsxLKxu9sLo5sS9oVhgEgCAhkfbvw==
x-ms-exchange-antispam-messagedata: MoaMH6aIK6vrZw1UnPY3lAnhDs4W7K+HmaCaDNVwtzpFbHOB26B61/zLaQIu5pfLHnH/TPn+exupG1F/cZpKRCDUNRDP9Y6Db1acDo07Fv+IGG/78toAkQ2PMBoquWmt8MrKtG6uqV2jxF6t6qzQow==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6950A5B1EF71C4FBE73D8BA9F155E11@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce9039ce-fd3b-4d34-a171-08d7e2395f15
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 19:07:13.1611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGrbWL6jcyF2fsbxpOhcFfKysO1xmGZGRVhWZ6+CtnEROXiAvDa75Ff0m7KGwBPArZDlCh3NtlZAihWA7ZuABA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4319
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDA5OjMwIC0wNDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
T24gVGh1LCBBcHIgMTYsIDIwMjAgYXQgMDg6MjQ6MDlBTSArMDMwMCwgTGVvbiBSb21hbm92c2t5
IHdyb3RlOg0KPiA+IE9uIFRodSwgQXByIDE2LCAyMDIwIGF0IDA0OjA4OjEwQU0gKzAwMDAsIFNh
ZWVkIE1haGFtZWVkIHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyMDIwLTA0LTE1IGF0IDIwOjAwIC0w
NDAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4gPiA+ID4gT24gV2VkLCBBcHIgMTUsIDIwMjAgYXQg
MDU6MTg6MzhQTSArMDEwMCwgRWR3YXJkIENyZWUgd3JvdGU6DQo+ID4gPiA+ID4gRmlyc3RseSwg
bGV0IG1lIGFwb2xvZ2lzZTogbXkgcHJldmlvdXMgZW1haWwgd2FzIHRvbyBoYXJzaA0KPiA+ID4g
PiA+IGFuZCB0b28NCj4gPiA+ID4gPiAgYXNzZXJ0aXZlYWJvdXQgdGhpbmdzIHRoYXQgd2VyZSBy
ZWFsbHkgbW9yZSB1bmNlcnRhaW4gYW5kDQo+ID4gPiA+ID4gdW5jbGVhci4NCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBPbiAxNC8wNC8yMDIwIDIxOjU3LCBTYXNoYSBMZXZpbiB3cm90ZToNCj4gPiA+
ID4gPiA+IEkndmUgcG9pbnRlZCBvdXQgdGhhdCBhbG1vc3QgNTAlIG9mIGNvbW1pdHMgdGFnZ2Vk
IGZvcg0KPiA+ID4gPiA+ID4gc3RhYmxlIGRvDQo+ID4gPiA+ID4gPiBub3QNCj4gPiA+ID4gPiA+
IGhhdmUgYSBmaXhlcyB0YWcsIGFuZCB5ZXQgdGhleSBhcmUgZml4ZXMuIFlvdSByZWFsbHkgZGVk
dWNlDQo+ID4gPiA+ID4gPiB0aGluZ3MgYmFzZWQNCj4gPiA+ID4gPiA+IG9uIGNvaW4gZmxpcCBw
cm9iYWJpbGl0eT8NCj4gPiA+ID4gPiBZZXMsIGJ1dCBmYXIgbGVzcyB0aGFuIDUwJSBvZiBjb21t
aXRzICpub3QqIHRhZ2dlZCBmb3Igc3RhYmxlDQo+ID4gPiA+ID4gaGF2ZQ0KPiA+ID4gPiA+IGEg
Zml4ZXMNCj4gPiA+ID4gPiAgdGFnLiAgSXQncyBub3QgYWJvdXQgaGFyZC1hbmQtZmFzdCBBcmlz
dG90ZWxpYW4NCj4gPiA+ID4gPiAiZGVkdWN0aW9ucyIsIGxpa2UNCj4gPiA+ID4gPiAidGhpcw0K
PiA+ID4gPiA+ICBkb2Vzbid0IGhhdmUgRml4ZXM6LCB0aGVyZWZvcmUgaXQgaXMgbm90IGEgc3Rh
YmxlDQo+ID4gPiA+ID4gY2FuZGlkYXRlIiwgaXQncw0KPiA+ID4gPiA+IGFib3V0DQo+ID4gPiA+
ID4gIHByb2JhYmlsaXN0aWMgImluZHVjdGlvbiIuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiAi
aXQgZG9lcyBpbmNyZWFzZSB0aGUgYW1vdW50IG9mIGNvdW50ZXJ2YWlsaW5nIGV2aWRlbmNlDQo+
ID4gPiA+ID4gPiBuZWVkZWQgdG8NCj4gPiA+ID4gPiA+IGNvbmNsdWRlIGEgY29tbWl0IGlzIGEg
Zml4IiAtIFBsZWFzZSBleHBsYWluIHRoaXMgYXJndW1lbnQNCj4gPiA+ID4gPiA+IGdpdmVuDQo+
ID4gPiA+ID4gPiB0aGUNCj4gPiA+ID4gPiA+IGFib3ZlLg0KPiA+ID4gPiA+IEFyZSB5b3UgZmFt
aWxpYXIgd2l0aCBCYXllc2lhbiBzdGF0aXN0aWNzPyAgSWYgbm90LCBJJ2QNCj4gPiA+ID4gPiBz
dWdnZXN0DQo+ID4gPiA+ID4gcmVhZGluZw0KPiA+ID4gPiA+ICBzb21ldGhpbmcgbGlrZSBodHRw
Oi8veXVka293c2t5Lm5ldC9yYXRpb25hbC9iYXllcy8gd2hpY2gNCj4gPiA+ID4gPiBleHBsYWlu
cw0KPiA+ID4gPiA+IGl0Lg0KPiA+ID4gPiA+IFRoZXJlJ3MgYSBiaWcgZGlmZmVyZW5jZSBiZXR3
ZWVuIGEgY29pbiBmbGlwIGFuZCBhDQo+ID4gPiA+ID4gX2NvcnJlbGF0ZWRfDQo+ID4gPiA+ID4g
Y29pbiBmbGlwLg0KPiA+ID4gPiANCj4gPiA+ID4gSSdkIG1heWJlIHBvaW50IG91dCB0aGF0IHRo
ZSBzZWxlY3Rpb24gcHJvY2VzcyBpcyBiYXNlZCBvbiBhDQo+ID4gPiA+IG5ldXJhbA0KPiA+ID4g
PiBuZXR3b3JrIHdoaWNoIGtub3dzIGFib3V0IHRoZSBleGlzdGVuY2Ugb2YgYSBGaXhlcyB0YWcg
aW4gYQ0KPiA+ID4gPiBjb21taXQuDQo+ID4gPiA+IA0KPiA+ID4gPiBJdCBkb2VzIGV4YWN0bHkg
d2hhdCB5b3UncmUgZGVzY3JpYmluZywgYnV0IGFsc28gdGFraW5nIGEgYnVuY2gNCj4gPiA+ID4g
bW9yZQ0KPiA+ID4gPiBmYWN0b3JzIGludG8gaXQncyBkZXNpY2lvbiBwcm9jZXNzICgicGFuaWMi
PyAib29wcyI/DQo+ID4gPiA+ICJvdmVyZmxvdyI/DQo+ID4gPiA+IGV0YykuDQo+ID4gPiA+IA0K
PiA+ID4gDQo+ID4gPiBJIGFtIG5vdCBhZ2FpbnN0IEFVVE9TRUwgaW4gZ2VuZXJhbCwgYXMgbG9u
ZyBhcyB0aGUgZGVjaXNpb24gdG8NCj4gPiA+IGtub3cNCj4gPiA+IGhvdyBmYXIgYmFjayBpdCBp
cyBhbGxvd2VkIHRvIHRha2UgYSBwYXRjaCBpcyBtYWRlDQo+ID4gPiBkZXRlcm1pbmlzdGljYWxs
eQ0KPiA+ID4gYW5kIG5vdCBzdGF0aXN0aWNhbGx5IGJhc2VkIG9uIHNvbWUgQUkgaHVuY2guDQo+
ID4gPiANCj4gPiA+IEFueSBhdXRvIHNlbGVjdGlvbiBmb3IgYSBwYXRjaCB3aXRob3V0IGEgRml4
ZXMgdGFncyBjYW4gYmUNCj4gPiA+IGNhdGFzdHJvcGhpYw0KPiA+ID4gLi4gaW1hZ2luZSBhIHBh
dGNoIHdpdGhvdXQgYSBGaXhlcyBUYWcgd2l0aCBhIHNpbmdsZSBsaW5lIHRoYXQgaXMNCj4gPiA+
IGZpeGluZyBzb21lICJvb3BzIiwgc3VjaCBwYXRjaCBjYW4gYmUgZWFzaWx5IGFwcGxpZWQgY2xl
YW5seSB0bw0KPiA+ID4gc3RhYmxlLQ0KPiA+ID4gdi54IGFuZCBzdGFibGUtdi55IC4uIHdoaWxl
IGl0IGZpeGVzIHRoZSBpc3N1ZSBvbiB2LnggaXQgbWlnaHQNCj4gPiA+IGhhdmUNCj4gPiA+IGNh
dGFzdHJvcGhpYyByZXN1bHRzIG9uIHYueSAuLg0KPiA+IA0KPiA+IEkgdHJpZWQgdG8gaW1hZ2lu
ZSBzdWNoIGZsb3cgYW5kIGZhaWxlZCB0byBkbyBzby4gQXJlIHlvdSB0YWxraW5nDQo+ID4gYWJv
dXQNCj4gPiBhbnl0aGluZyBzcGVjaWZpYyBvciBpbWFnaW5hcnkgY2FzZT8NCj4gDQo+IEl0IGhh
cHBlbnMsIHJhcmVseSwgYnV0IGl0IGRvZXMuIEhvd2V2ZXIsIGFsbCB0aGUgY2FzZXMgSSBjYW4g
dGhpbmsNCj4gb2YNCj4gaGFwcGVuZWQgd2l0aCBhIHN0YWJsZSB0YWdnZWQgY29tbWl0IHdpdGhv
dXQgYSBmaXhlcyB3aGVyZSBpdCdzDQo+IGJhY2twb3J0DQo+IHRvIGFuIG9sZGVyIHRyZWUgY2F1
c2VkIHVuaW50ZW5kZWQgYmVoYXZpb3IgKGxvY2FsIGRlbmlhbCBvZiBzZXJ2aWNlDQo+IGluDQo+
IG9uZSBjYXNlKS4NCj4gDQo+IFRoZSBzY2VuYXJpbyB5b3UgaGF2ZSBpbiBtaW5kIGlzIHRydWUg
Zm9yIGJvdGggc3RhYmxlIGFuZCBub24tc3RhYmxlDQo+IHRhZ2dlZCBwYXRjaGVzLCBzbyBpdCB5
b3Ugd2FudCB0byByZXN0cmljdCBob3cgd2UgZGVhbCB3aXRoIGNvbW1pdHMNCj4gdGhhdA0KPiBk
b24ndCBoYXZlIGEgZml4ZXMgdGFnIHNob3VsZG4ndCBpdCBiZSB0cnVlIGZvciAqYWxsKiBjb21t
aXRzPw0KDQpBbGwgY29tbWl0cz8gZXZlbiB0aGUgb25lcyB3aXRob3V0ICJvb3BzIiBpbiB0aGVt
ID8gd2hlcmUgZG9lcyB0aGlzDQpzdG9wID8gOikgDQpXZSBfbXVzdF8gaGF2ZSBhIGhhcmQgYW5k
IGRldGVybWluaXN0aWMgY3V0IGZvciBob3cgZmFyIGJhY2sgdG8gdGFrZSBhDQpwYXRjaCBiYXNl
ZCBvbiBhIGh1bWFuIGRlY2lzaW9uLi4gdW5sZXNzIHdlIGFyZSAxMDAlIHBvc2l0aXZlDQphdXRv
c2VsZWN0aW9uIEFJIGNhbiBuZXZlciBtYWtlIGEgbWlzdGFrZS4NCg0KSHVtYW5zIGFyZSBhbGxv
d2VkIHRvIG1ha2UgbWlzdGFrZXMsIEFJIGlzIG5vdC4NCg0KSWYgYSBGaXhlcyB0YWcgaXMgd3Jv
bmcsIHRoZW4gYSBodW1hbiB3aWxsIGJlIGJsYW1lZCwgYW5kIHRoYXQgaXMNCnBlcmZlY3RseSBm
aW5lLCBidXQgaWYgd2UgaGF2ZSBzb21lIHN0YXRpc3RpY2FsIG1vZGVsIHRoYXQgd2Uga25vdyBp
dA0KaXMgZ29pbmcgdG8gYmUgd3JvbmcgMC4wMDElIG9mIHRoZSB0aW1lLi4gYW5kIHdlIHN0aWxs
IGxldCBpdCBydW4uLg0KdGhlbiBzb21ldGhpbmcgbmVlZHMgdG8gYmUgZG9uZSBhYm91dCB0aGlz
Lg0KDQpJIGtub3cgdGhlcmUgYXJlIGJlbmVmaXRzIHRvIGF1dG9zZWwsIGJ1dCBvdmVydGltZSwg
aWYgdGhpcyBpcyBub3QNCmJlaW5nIGF1ZGl0ZWQsIG1hbnkgcGllY2VzIG9mIHRoZSBrZXJuZWwg
d2lsbCBnZXQgYnJva2VuIHVubm90aWNlZA0KdW50aWwgc29tZSBwb29yIGRpc3RybyBkZWNpZGVz
IHRvIHVwZ3JhZGUgdGhlaXIga2VybmVsIHZlcnNpb24uDQoNCg0KPiANCj4gPiA8Li4uPg0KPiA+
ID4gPiBMZXQgbWUgcHV0IG15IE1pY3Jvc29mdCBlbXBsb3llZSBoYXQgb24gaGVyZS4gV2UgaGF2
ZQ0KPiA+ID4gPiBkcml2ZXIvbmV0L2h5cGVydi8NCj4gPiA+ID4gd2hpY2ggZGVmaW5pdGVseSB3
YXNuJ3QgZ2V0dGluZyBhbGwgdGhlIGZpeGVzIGl0IHNob3VsZCBoYXZlDQo+ID4gPiA+IGJlZW4N
Cj4gPiA+ID4gZ2V0dGluZyB3aXRob3V0IEFVVE9TRUwuDQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4g
PiB1bnRpbCBzb21lIHBhdGNoIHdoaWNoIHNob3VsZG4ndCBnZXQgYmFja3BvcnRlZCBzbGlwcyB0
aHJvdWdoLA0KPiA+ID4gYmVsaWV2ZQ0KPiA+ID4gbWUgdGhpcyB3aWxsIGhhcHBlbiwganVzdCBn
aXZlIGl0IHNvbWUgdGltZSAuLg0KPiA+IA0KPiA+IEJ1Z3MgYXJlIGluZXZpdGFibGUsIEkgZG9u
J3Qgc2VlIG1hbnkgZGlmZmVyZW5jZXMgYmV0d2VlbiBidWdzDQo+ID4gaW50cm9kdWNlZCBieSBt
YW51YWxseSBjaGVycnktcGlja2luZyBvciBhdXRvbWF0aWNhbGx5IG9uZS4NCj4gDQo+IE9oIGJ1
Z3Mgc2xpcCBpbiwgdGhhdCdzIHdoeSBJIHRyYWNrIGhvdyBtYW55IGJ1Z3Mgc2xpcHBlZCB2aWEg
c3RhYmxlDQo+IHRhZ2dlZCBjb21taXRzIHZzIG5vbi1zdGFibGUgdGFnZ2VkIG9uZXMsIGFuZCB0
aGUgc3RhdGlzdGljIG1heQ0KPiBzdXJwcmlzZQ0KPiB5b3UuDQo+IA0KDQpTdGF0aXN0aWNzIGRv
IG5vdCBtYXR0ZXIgaGVyZSwgd2hhdCByZWFsbHkgbWF0dGVycyBpcyB0aGF0IHRoZXJlIGlzIGEN
CnBvc3NpYmlsaXR5IG9mIGEgbm9uLWh1bWFuIGluZHVjZWQgZXJyb3IsIHRoaXMgc2hvdWxkIGJl
IGEgbm8gbm8uDQpvciBhdCBsZWFzdCBtYWtlIGl0IGFuIG9wdC1pbiB0aGluZyBmb3IgdGhvc2Ug
d2hvIHdhbnQgdG8gdGFrZSB0aGVpcg0KY2hhbmNlcyBhbmQga2VlcCBhIGNsb3NlIGV5ZSBvbiBp
dC4uDQoNCj4gVGhlIHNvbHV0aW9uIGhlcmUgaXMgdG8gYmVlZiB1cCB5b3VyIHRlc3RpbmcgaW5m
cmFzdHJ1Y3R1cmUgcmF0aGVyDQo+IHRoYW4NCg0KU28gcGxlYXNlIGxldCBtZSBvcHQtaW4gdW50
aWwgSSBiZWVmIHVwIG15IHRlc3RpbmcgaW5mcmEuDQoNCj4gdGFraW5nIGxlc3MgcGF0Y2hlczsg
d2Ugc3RpbGwgd2FudCB0byBoYXZlICphbGwqIHRoZSBmaXhlcywgcmlnaHQ/DQo+IA0KDQppZiB5
b3UgY2FuIGJlIHN1cmUgMTAwJSBpdCBpcyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8sIHRoZW4geWVz
LCBwbGVhc2UNCmRvbid0IGhlc2l0YXRlIHRvIHRha2UgdGhhdCBwYXRjaCwgZXZlbiB3aXRob3V0
IGFza2luZyBhbnlvbmUgISENCg0KQWdhaW4sIEh1bWFucyBhcmUgYWxsb3dlZCB0byBtYWtlIG1p
c3Rha2VzLi4gQUkgaXMgbm90Lg0KDQoNCj4gPiBPZiBjb3Vyc2UsIGl0IGlzIHRydWUgaWYgdGhp
cyBhdXRvbWF0aWNhbGx5IGNoZXJyeS1waWNraW5nIHdvcmtzIGFzDQo+ID4gZXhwZWN0ZWQgYW5k
IGV2b2x2aW5nLg0KPiA+IA0KPiA+ID4gPiBXaGlsZSBuZXQvIGlzIGRvaW5nIGdyZWF0LCBkcml2
ZXJzL25ldC8gaXMgbm90LiBJZiBpdCdzIGluZGVlZA0KPiA+ID4gPiBmb2xsb3dpbmcNCj4gPiA+
ID4gdGhlIHNhbWUgcnVsZXMgdGhlbiB3ZSBuZWVkIHRvIHRhbGsgYWJvdXQgaG93IHdlIGdldCBk
b25lDQo+ID4gPiA+IHJpZ2h0Lg0KPiA+ID4gPiANCj4gPiA+IA0KPiA+ID4gYm90aCBuZXQgYW5k
IGRyaXZlcnMvbmV0IGFyZSBtYW5hZ2VkIGJ5IHRoZSBzYW1lIG1haXRhaW5lciBhbmQNCj4gPiA+
IGZvbGxvdw0KPiA+ID4gdGhlIHNhbWUgcnVsZXMsIGNhbiB5b3UgZWxhYm9yYXRlIG9uIHRoZSBk
aWZmZXJlbmNlID8NCj4gPiANCj4gPiBUaGUgbWFpbiByZWFzb24gaXMgYSBkaWZmZXJlbmNlIGlu
IGEgdm9sdW1lIGJldHdlZW4gbmV0IGFuZA0KPiA+IGRyaXZlcnMvbmV0Lg0KPiA+IFdoaWxlIG5l
dC8qIHBhdGNoZXMgYXJlIHdhdGNoZWQgYnkgbWFueSBleWVzIGFuZCBjYXJlZnVsbHkgc2VsZWN0
ZWQNCj4gPiB0byBiZQ0KPiA+IHBvcnRlZCB0byBzdGFibGVALCBtb3N0IG9mIHRoZSBkcml2ZXJz
L25ldCBwYXRjaGVzIGFyZSBub3QuDQo+ID4gDQo+ID4gRXhjZXB0IDMtNSB0aGUgbW9zdCBhY3Rp
dmUgZHJpdmVycywgcmVzdCBvZiB0aGUgZHJpdmVyIHBhdGNoZXMNCj4gPiBhbG1vc3QgbmV2ZXIN
Cj4gPiBhc2tlZCB0byBiZSBiYWNrcG9ydGVkLg0KPiANCj4gUmlnaHQsIHRoYXQncyBleGFjdGx5
IG15IHBvaW50OiBJZiB5b3UncmUgbm90IE1lbGxhbm94LCBlMTAwMCosIGV0Yw0KPiB5b3UNCj4g
d29uJ3Qgc2VlIGl0LCBidXQgdGhlIHNtYWxsZXIgZHJpdmVycyBhcmVuJ3QgZ2V0dGluZyB0aGUg
c2FtZQ0KPiBoYW5kbGluZw0KPiBhcyB0aGUgYmlnIG9uZXMuDQo+IA0KPiBJIHRoaW5rIHRoYXQg
d2UgYWxsIGxvdmUgdGhlIHdvcmsgRGF2ZU0gZG9lcyB3aXRoIG5ldC8gLSBpdCBtYWtlcyBvdXIN
Cj4gbGl2ZXMgYSBsb3QgZWFzaWVyLCBhbmQgaWYgdGhlIHNhbWUgdGhpbmcgd291bGQgaGFwcGVu
IHdpdGgNCj4gZHJpdmVycy9uZXQvDQo+IEknbGwgaGFwcGlseSBnbyBhd2F5IGFuZCBuZXZlciBB
VVRPU0VMIGEgKm5ldCogY29tbWl0LCBidXQgbG9va2luZyBhdA0KPiBob3cgb3VyIEh5cGVyLVYg
ZHJpdmVycyBsb29rIGxpa2UgaXQncyBjbGVhcmx5IG5vdCB0aGVyZSB5ZXQuDQo+IA0K
