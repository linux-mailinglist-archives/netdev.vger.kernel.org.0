Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB36A152857
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgBEJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:30:20 -0500
Received: from mail-am6eur05on2076.outbound.protection.outlook.com ([40.107.22.76]:44897
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728061AbgBEJaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 04:30:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7zeaAwMwT1lCM/9ucC6VzOspfSmB7tDOEAgiY8Bfroqd18SvFm2qGhHyNu5Bw0vKj8LVCz6JBsQVEwBD1dPm0C/PgPMr1H8MS5a0eXf3DNuTAUZIdk53Xo0A7xCdFX1owDWDWSEwKN42ovZQykBedMm303VPc2YBe6Pi7YDh2xevyP/hcqE2ydT5smbcO2gxSwYgPYnLspxIzl1IRARwElm+yP3U+Ex2R/rDzjxVk6DC0wQNYZcNRH5hlQTZoKDCH7spnV7Tm/5txb26tTpNpwocKMVpbIAmeSRNUUSnxZBRUzhA3AvTpzujTm8FXUj18RVuZpMbeNzXZqBZt5idg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGGZ0n2sFuS7wYu9oUfext/G3X3Ke7AcfcLEKxeId6c=;
 b=F1cCdpk3DLs+pbCujbu03e3LwIDfRpEw+sHWoyXYO8JxU8kE+2SMfM0FTkDhtDr7X9HQh6IUuUWoW7f45xgpS4uBDEE2rpDC1msWBpTkSqTptlZTghrmJnHPlTgflz4fQJg2cRq26r0827pX23BqTXBGZfoB12ySlRBy1XTHzAAO6FXc2Mg81NObsKfbxPLGa78mRbbydoo+AJpJ06Q9njv2V3jl6ueHiOTLJlHxM/Q1FcAN73WoLhvIy1R8ap2X6TqeB3sXoLNxlSpYTDUqIFR+fhShFzHYO0KhDmKl0CuU1Y4okYT01Law+VGbQwSbSk6l7CHjXrGbJE2dwYBnaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGGZ0n2sFuS7wYu9oUfext/G3X3Ke7AcfcLEKxeId6c=;
 b=C9Iytkwt675Y394bDgQu2xq0flffwfs2Cas0QL3BTZBzQh9x3iio9VJ1ejVxFKuuh1A1gU2nJ5EKrKEEOJVp4JbPZqmXy93JStcn+78+E4l76nWFEhALKFSG/JzGmMTP30cG80N2+U6UB1Vtaz0Y81sbFyr0d39WA6pMKSZCU7A=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB3746.eurprd05.prod.outlook.com (52.133.47.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Wed, 5 Feb 2020 09:30:14 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2686.031; Wed, 5 Feb 2020
 09:30:14 +0000
From:   Shahaf Shuler <shahafs@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "dan.daly@intel.com" <dan.daly@intel.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>
Subject: RE: [PATCH] vhost: introduce vDPA based backend
Thread-Topic: [PATCH] vhost: introduce vDPA based backend
Thread-Index: AQHV1+fI0VDKiPRsCkOOQhfIRhwRFqgKZwCAgAF56YCAAFYPAIAACwUAgAAUU1A=
Date:   Wed, 5 Feb 2020 09:30:14 +0000
Message-ID: <AM0PR0502MB3795AD42233D69F350402A8AC3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
 <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
In-Reply-To: <112858a4-1a01-f4d7-e41a-1afaaa1cad45@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [31.154.10.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 665eafe7-a0ec-42dd-9755-08d7aa1e0195
x-ms-traffictypediagnostic: AM0PR0502MB3746:|AM0PR0502MB3746:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB374626CDBE2B98C0D3E6EBABC3020@AM0PR0502MB3746.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(199004)(189003)(478600001)(64756008)(66556008)(66446008)(9686003)(6506007)(86362001)(7696005)(26005)(2906002)(76116006)(4326008)(5660300002)(66476007)(186003)(66946007)(71200400001)(316002)(33656002)(81166006)(52536014)(7416002)(8936002)(55016002)(81156014)(110136005)(54906003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3746;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WoJ1CAkQyMdUgmz2hxQSE0jdZF4fac17vuIYnkJ9XOhzsIiTwZ8Th+IJk08mCTykkjWNZDwYCl6qlGVYu/t0YQ49sUeShOXo452MFLyPHRJXTDY5hc+N6ccwIsFlb87JX/YJGq+OrhtUZAV5guw8QpmZtAmKieBA1WXxy6TBXT+8ul6cEk6BCyUfoTJ8jZU9PpheCFY4EpdWnXlvekFYPfpFpn6ry2i1SN5qO78K1Eo3yVWZUIS7BY8oG1IQnu47VBqT00QtTe/HScyHnj7NmGL+PDhfTndLw1eARvYuEY7Ovs53K+QM0lDwJSy7YkpnhPLLSkED08wlobvTFVR5dV1UCD6DWlTBEt0Jw8jHcReP9NjyJwu6huvRxXAlzIPMbNkOug6SK/ZJAZ+1LSWImmq+2L87aQjZQNhRIDI5v3RRAa+Pr5ouWEBbFIqAUC8A
x-ms-exchange-antispam-messagedata: DugJz5w3Ot/a0/V/eTbHrdtVaTh4xFsgi8vfChrQt2FQrcMh+UX37+fmPPdFast9t+97mB1Z9xYx1rsG3Het24NhPJT1PgzP1ch2EVZw16qPd3sST9aev3GR2ZoN3NH0W5DdnvFZWsd89BruGa4Ryw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665eafe7-a0ec-42dd-9755-08d7aa1e0195
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 09:30:14.6737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i0zPoaZm0R9nBd539pICslVFAntNL66whDKHwzh80XAfoQuKeVE15Zb2HpkYGYE1BlPYIhBu7mXYaUaQAT7U5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3746
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2VkbmVzZGF5LCBGZWJydWFyeSA1LCAyMDIwIDk6NTAgQU0sIEphc29uIFdhbmc6DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0hdIHZob3N0OiBpbnRyb2R1Y2UgdkRQQSBiYXNlZCBiYWNrZW5kDQo+IE9u
IDIwMjAvMi81IOS4i+WNiDM6MTUsIFNoYWhhZiBTaHVsZXIgd3JvdGU6DQo+ID4gV2VkbmVzZGF5
LCBGZWJydWFyeSA1LCAyMDIwIDQ6MDMgQU0sIFRpd2VpIEJpZToNCj4gPj4gU3ViamVjdDogUmU6
IFtQQVRDSF0gdmhvc3Q6IGludHJvZHVjZSB2RFBBIGJhc2VkIGJhY2tlbmQNCj4gPj4NCj4gPj4g
T24gVHVlLCBGZWIgMDQsIDIwMjAgYXQgMTE6MzA6MTFBTSArMDgwMCwgSmFzb24gV2FuZyB3cm90
ZToNCj4gPj4+IE9uIDIwMjAvMS8zMSDkuIrljYgxMTozNiwgVGl3ZWkgQmllIHdyb3RlOg0KPiA+
Pj4+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIHZEUEEgYmFzZWQgdmhvc3QgYmFja2VuZC4gVGhp
cyBiYWNrZW5kIGlzDQo+ID4+Pj4gYnVpbHQgb24gdG9wIG9mIHRoZSBzYW1lIGludGVyZmFjZSBk
ZWZpbmVkIGluIHZpcnRpby12RFBBIGFuZA0KPiA+Pj4+IHByb3ZpZGVzIGEgZ2VuZXJpYyB2aG9z
dCBpbnRlcmZhY2UgZm9yIHVzZXJzcGFjZSB0byBhY2NlbGVyYXRlIHRoZQ0KPiA+Pj4+IHZpcnRp
byBkZXZpY2VzIGluIGd1ZXN0Lg0KPiA+Pj4+DQo+ID4+Pj4gVGhpcyBiYWNrZW5kIGlzIGltcGxl
bWVudGVkIGFzIGEgdkRQQSBkZXZpY2UgZHJpdmVyIG9uIHRvcCBvZiB0aGUNCj4gPj4+PiBzYW1l
IG9wcyB1c2VkIGluIHZpcnRpby12RFBBLiBJdCB3aWxsIGNyZWF0ZSBjaGFyIGRldmljZSBlbnRy
eQ0KPiA+Pj4+IG5hbWVkIHZob3N0LXZkcGEvJHZkcGFfZGV2aWNlX2luZGV4IGZvciB1c2Vyc3Bh
Y2UgdG8gdXNlLg0KPiBVc2Vyc3BhY2UNCj4gPj4+PiBjYW4gdXNlIHZob3N0IGlvY3RscyBvbiB0
b3Agb2YgdGhpcyBjaGFyIGRldmljZSB0byBzZXR1cCB0aGUgYmFja2VuZC4NCj4gPj4+Pg0KPiA+
Pj4+IFNpZ25lZC1vZmYtYnk6IFRpd2VpIEJpZSA8dGl3ZWkuYmllQGludGVsLmNvbT4NCj4gPiBb
Li4uXQ0KPiA+DQo+ID4+Pj4gK3N0YXRpYyBsb25nIHZob3N0X3ZkcGFfZG9fZG1hX21hcHBpbmco
c3RydWN0IHZob3N0X3ZkcGEgKnYpIHsNCj4gPj4+PiArCS8qIFRPRE86IGZpeCB0aGlzICovDQo+
ID4+Pg0KPiA+Pj4gQmVmb3JlIHRyeWluZyB0byBkbyB0aGlzIGl0IGxvb2tzIHRvIG1lIHdlIG5l
ZWQgdGhlIGZvbGxvd2luZyBkdXJpbmcNCj4gPj4+IHRoZSBwcm9iZQ0KPiA+Pj4NCj4gPj4+IDEp
IGlmIHNldF9tYXAoKSBpcyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSB2RFBBIGRldmljZSBwcm9iZSB0
aGUgSU9NTVUNCj4gPj4+IHRoYXQgaXMgc3VwcG9ydGVkIGJ5IHRoZSB2RFBBIGRldmljZQ0KPiA+
Pj4gMikgYWxsb2NhdGUgSU9NTVUgZG9tYWluDQo+ID4+Pg0KPiA+Pj4gQW5kIHRoZW46DQo+ID4+
Pg0KPiA+Pj4gMykgcGluIHBhZ2VzIHRocm91Z2ggR1VQIGFuZCBkbyBwcm9wZXIgYWNjb3VudGlu
Zw0KPiA+Pj4gNCkgc3RvcmUgR1BBLT5IUEEgbWFwcGluZyBpbiB0aGUgdW1lbQ0KPiA+Pj4gNSkg
Z2VuZXJhdGUgZGlmZnMgb2YgbWVtb3J5IHRhYmxlIGFuZCB1c2luZyBJT01NVSBBUEkgdG8gc2V0
dXAgdGhlDQo+ID4+PiBkbWEgbWFwcGluZyBpbiB0aGlzIG1ldGhvZA0KPiA+Pj4NCj4gPj4+IEZv
ciAxKSwgSSdtIG5vdCBzdXJlIHBhcmVudCBpcyBzdWZmaWNpZW50IGZvciB0byBkb2luZyB0aGlz
IG9yIG5lZWQNCj4gPj4+IHRvIGludHJvZHVjZSBuZXcgQVBJIGxpa2UgaW9tbXVfZGV2aWNlIGlu
IG1kZXYuDQo+ID4+IEFncmVlLiBXZSBtYXkgYWxzbyBuZWVkIHRvIGludHJvZHVjZSBzb21ldGhp
bmcgbGlrZSB0aGUgaW9tbXVfZGV2aWNlLg0KPiA+Pg0KPiA+IFdvdWxkIGl0IGJlIGJldHRlciBm
b3IgdGhlIG1hcC91bW5hcCBsb2dpYyB0byBoYXBwZW4gaW5zaWRlIGVhY2ggZGV2aWNlID8NCj4g
PiBEZXZpY2VzIHRoYXQgbmVlZHMgdGhlIElPTU1VIHdpbGwgY2FsbCBpb21tdSBBUElzIGZyb20g
aW5zaWRlIHRoZSBkcml2ZXINCj4gY2FsbGJhY2suDQo+IA0KPiANCj4gVGVjaG5pY2FsbHksIHRo
aXMgY2FuIHdvcmsuIEJ1dCBpZiBpdCBjYW4gYmUgZG9uZSBieSB2aG9zdC12cGRhIGl0IHdpbGwg
bWFrZSB0aGUNCj4gdkRQQSBkcml2ZXIgbW9yZSBjb21wYWN0IGFuZCBlYXNpZXIgdG8gYmUgaW1w
bGVtZW50ZWQuDQoNCk5lZWQgdG8gc2VlIHRoZSBsYXllcmluZyBvZiBzdWNoIHByb3Bvc2FsIGJ1
dCBhbSBub3Qgc3VyZS4gDQpWaG9zdC12ZHBhIGlzIGdlbmVyaWMgZnJhbWV3b3JrLCB3aGlsZSB0
aGUgRE1BIG1hcHBpbmcgaXMgdmVuZG9yIHNwZWNpZmljLiANCk1heWJlIHZob3N0LXZkcGEgY2Fu
IGhhdmUgc29tZSBzaGFyZWQgY29kZSBuZWVkZWQgdG8gb3BlcmF0ZSBvbiBpb21tdSwgc28gZHJp
dmVycyBjYW4gcmUtdXNlIGl0LiAgdG8gbWUgaXQgc2VlbXMgc2ltcGxlciB0aGFuIGV4cG9zaW5n
IGEgbmV3IGlvbW11IGRldmljZS4gDQoNCj4gDQo+IA0KPiA+IERldmljZXMgdGhhdCBoYXMgb3Ro
ZXIgd2F5cyB0byBkbyB0aGUgRE1BIG1hcHBpbmcgd2lsbCBjYWxsIHRoZQ0KPiBwcm9wcmlldGFy
eSBBUElzLg0KPiANCj4gDQo+IFRvIGNvbmZpcm0sIGRvIHlvdSBwcmVmZXI6DQo+IA0KPiAxKSBt
YXAvdW5tYXANCg0KSXQgaXMgbm90IG9ubHkgdGhhdC4gQUZBSVIgdGhlcmUgYWxzbyBmbHVzaCBh
bmQgaW52YWxpZGF0ZSBjYWxscywgcmlnaHQ/DQoNCj4gDQo+IG9yDQo+IA0KPiAyKSBwYXNzIGFs
bCBtYXBzIGF0IG9uZSB0aW1lPw0KDQpUbyBtZSB0aGlzIHNlZW1zIG1vcmUgc3RyYWlnaHQgZm9y
d2FyZC4gDQpJdCBpcyBjb3JyZWN0IHRoYXQgdW5kZXIgaG90cGx1ZyBhbmQgbGFyZ2UgbnVtYmVy
IG9mIG1lbW9yeSBzZWdtZW50cyB0aGUgZHJpdmVyIHdpbGwgbmVlZCB0byB1bmRlcnN0YW5kIHRo
ZSBkaWZmIChvciBub3QgYW5kIGp1c3QgcmVsb2FkIHRoZSBuZXcgY29uZmlndXJhdGlvbikuIEhv
d2V2ZXIsIG15IGFzc3VtcHRpb24gaGVyZSBpcyB0aGF0IG1lbW9yeSBob3RwbHVnIGlzIGhlYXZ5
IGZsb3cgYW55d2F5LCBhbmQgdGhlIGRyaXZlciBleHRyYSBjeWNsZXMgd2lsbCBub3QgYmUgdGhh
dCB2aXNpYmxlDQoNCj4gDQo+IFRoYW5rcw0KPiANCj4gDQo+ID4NCg0K
