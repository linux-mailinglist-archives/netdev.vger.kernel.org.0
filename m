Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70A71526BB
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 08:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgBEHPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 02:15:10 -0500
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:48105
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbgBEHPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 02:15:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBDMKUZcGL0aqeoh996687/U8eLoRVrsoW0kMMBph6I1xnG5YsQol3uTsCzvrGM7IHo2icqu++2zlZ7EcikWPxBQc/1U/L9ssp0yFV10oQLoqbSKxtor7b6+6+bzmRdY9epLrWh92eU5P/7Fyrq3ewQc99C5wPb0grvppn/833u7sR4Z0azyxQWbtNcvqy478dOhwJ3yzqFJa4M3DJKwOMN4pwNgRi6D1aWb/CD107BV1A5J2Mj3jWGANvB+gfikjIrQDBZY6P1MQ7K0+eb6ACRdtNTeuy7KS6EnxxYVP/0uIqbEBdOoEgSHEClZXl5v4QKvrVQ5r8jTtce/ATZcYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWf6a2Rd0ies5rSCVmJgZ66peRsDzAVCULR4cEzitfM=;
 b=ebf3pTT6a7pS68qHIR2BxM9fkWUlZio9lhK1xWjg2UhfFAexS16c7e/ACf0/Zm4+V5Zdsp//YWI8oYM4rjv+GlrSoMa0tfRgsv7o1d3wfMyh4MaUhwZO4s3HANO70KqrkYbXwYOc3SBcO+u/siHlItY1HQx7mEYFgL5yStG29v/dRd0iMrQ/IqWtfVVLYgO2fxhkbpJJhVdhde1BMLp3XXBgHUcGFy1OVCcGGyiPX2Ff0QjfOyqbSGQ1bkQv/ixlE/lG77epK4AssK9OWxpmBvNBFtuZl/vU9R1U7Lb/kl39I4HEv0xXgFrmATWg1bBMnQOYWlP0mLhnqL2El3m1lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XWf6a2Rd0ies5rSCVmJgZ66peRsDzAVCULR4cEzitfM=;
 b=Paw5pf7nmpWMW4DoFhmsvhwXRXbNFU2hOId+q2artqmCX2yBa4JJS3x8bM2hTqFQRxXLCjfJClXKFHbGuLr0M1NNoZ2vSBuIeXIYP+5/PF09nzMQK0Kuf/i4x0ahR/gQwJ9ojDuhzmDe+FGDcmrRsLlCVXW7IflQN1KAIu42FWw=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB3876.eurprd05.prod.outlook.com (52.133.48.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Wed, 5 Feb 2020 07:15:04 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2686.031; Wed, 5 Feb 2020
 07:15:04 +0000
From:   Shahaf Shuler <shahafs@mellanox.com>
To:     Tiwei Bie <tiwei.bie@intel.com>, Jason Wang <jasowang@redhat.com>
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
Thread-Index: AQHV1+fI0VDKiPRsCkOOQhfIRhwRFqgKZwCAgAF56YCAAFYPAA==
Date:   Wed, 5 Feb 2020 07:15:03 +0000
Message-ID: <AM0PR0502MB37952015716C1D5E07E390B6C3020@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200205020247.GA368700@___>
In-Reply-To: <20200205020247.GA368700@___>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [31.154.10.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 292764e5-cca2-454b-19d7-08d7aa0b1f2b
x-ms-traffictypediagnostic: AM0PR0502MB3876:|AM0PR0502MB3876:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB3876BCBD81EC75903EFE7472C3020@AM0PR0502MB3876.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(199004)(189003)(9686003)(66446008)(64756008)(66476007)(66556008)(8676002)(81166006)(81156014)(76116006)(66946007)(52536014)(5660300002)(4326008)(33656002)(6506007)(478600001)(8936002)(55016002)(186003)(26005)(86362001)(316002)(7416002)(2906002)(71200400001)(7696005)(54906003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3876;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dOVszRvCOAVzoncSG6qt26FwlLk9y1tpgm0ouWRt916xk6ttFFcQwzimymVR4fjQCL/LGF//X61z1pgQmPS9Iz0AzAKzZx43FyFOuNHa9gWss4QFdCKyIOePPSTxmlD4u/kat5ufHcux79cv+rud0jPZeIzlx4PQt5WkdIMcekdz0Am4B5PKCdB/S+ZXDmRr/1jQgI5OYSrZ2pYpSrQ6fYhZLjciJqwQJN6GsJNDAP9INRNnC294ciCyZq73qsMbG30Bm12Ngi9T+pHh7/sKfMkTaQaeYUkb456v9B7Yliv2vIjVFvyRqN+xDwGp0njFmj6qYqC2bR0Gqs1P0KgBGqJ6t7aYII8asMp/A9zmvlNeFM9ok2QdkCKCS2KyQPcEbKb9NwDjrweNhYLcfiLqBoaRzQJtcv4Wow1L/+gPvwRNHoCLeb5mTX6G/kw30Md4
x-ms-exchange-antispam-messagedata: SXJn4Igv0AGygJVogE5g0hgFjY2EjAIiFQzpNgiUywDerafhGlqETJIazBfTc3+w5jFQNu2+J03838bw+yNyk2Y+T3FIC5gzpil902b7qeky2PgIRLxkeYTMxZrZe0KJ+fJdu9CaEGHezdUtQ0he5w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292764e5-cca2-454b-19d7-08d7aa0b1f2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 07:15:03.9305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A2Zw4lxXnah5i22LCSFf1152zBfgBHSm9YvVJXbsgW2GT0J31MxdTyUe9UFB/yTKDPdu7WV0/IQBGpjc3KKpFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3876
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2VkbmVzZGF5LCBGZWJydWFyeSA1LCAyMDIwIDQ6MDMgQU0sIFRpd2VpIEJpZToNCj4gU3ViamVj
dDogUmU6IFtQQVRDSF0gdmhvc3Q6IGludHJvZHVjZSB2RFBBIGJhc2VkIGJhY2tlbmQNCj4gDQo+
IE9uIFR1ZSwgRmViIDA0LCAyMDIwIGF0IDExOjMwOjExQU0gKzA4MDAsIEphc29uIFdhbmcgd3Jv
dGU6DQo+ID4gT24gMjAyMC8xLzMxIOS4iuWNiDExOjM2LCBUaXdlaSBCaWUgd3JvdGU6DQo+ID4g
PiBUaGlzIHBhdGNoIGludHJvZHVjZXMgYSB2RFBBIGJhc2VkIHZob3N0IGJhY2tlbmQuIFRoaXMg
YmFja2VuZCBpcw0KPiA+ID4gYnVpbHQgb24gdG9wIG9mIHRoZSBzYW1lIGludGVyZmFjZSBkZWZp
bmVkIGluIHZpcnRpby12RFBBIGFuZA0KPiA+ID4gcHJvdmlkZXMgYSBnZW5lcmljIHZob3N0IGlu
dGVyZmFjZSBmb3IgdXNlcnNwYWNlIHRvIGFjY2VsZXJhdGUgdGhlDQo+ID4gPiB2aXJ0aW8gZGV2
aWNlcyBpbiBndWVzdC4NCj4gPiA+DQo+ID4gPiBUaGlzIGJhY2tlbmQgaXMgaW1wbGVtZW50ZWQg
YXMgYSB2RFBBIGRldmljZSBkcml2ZXIgb24gdG9wIG9mIHRoZQ0KPiA+ID4gc2FtZSBvcHMgdXNl
ZCBpbiB2aXJ0aW8tdkRQQS4gSXQgd2lsbCBjcmVhdGUgY2hhciBkZXZpY2UgZW50cnkgbmFtZWQN
Cj4gPiA+IHZob3N0LXZkcGEvJHZkcGFfZGV2aWNlX2luZGV4IGZvciB1c2Vyc3BhY2UgdG8gdXNl
LiBVc2Vyc3BhY2UgY2FuDQo+ID4gPiB1c2Ugdmhvc3QgaW9jdGxzIG9uIHRvcCBvZiB0aGlzIGNo
YXIgZGV2aWNlIHRvIHNldHVwIHRoZSBiYWNrZW5kLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IFRpd2VpIEJpZSA8dGl3ZWkuYmllQGludGVsLmNvbT4NCg0KWy4uLl0NCg0KPiA+ID4gK3N0
YXRpYyBsb25nIHZob3N0X3ZkcGFfZG9fZG1hX21hcHBpbmcoc3RydWN0IHZob3N0X3ZkcGEgKnYp
IHsNCj4gPiA+ICsJLyogVE9ETzogZml4IHRoaXMgKi8NCj4gPg0KPiA+DQo+ID4gQmVmb3JlIHRy
eWluZyB0byBkbyB0aGlzIGl0IGxvb2tzIHRvIG1lIHdlIG5lZWQgdGhlIGZvbGxvd2luZyBkdXJp
bmcNCj4gPiB0aGUgcHJvYmUNCj4gPg0KPiA+IDEpIGlmIHNldF9tYXAoKSBpcyBub3Qgc3VwcG9y
dGVkIGJ5IHRoZSB2RFBBIGRldmljZSBwcm9iZSB0aGUgSU9NTVUNCj4gPiB0aGF0IGlzIHN1cHBv
cnRlZCBieSB0aGUgdkRQQSBkZXZpY2UNCj4gPiAyKSBhbGxvY2F0ZSBJT01NVSBkb21haW4NCj4g
Pg0KPiA+IEFuZCB0aGVuOg0KPiA+DQo+ID4gMykgcGluIHBhZ2VzIHRocm91Z2ggR1VQIGFuZCBk
byBwcm9wZXIgYWNjb3VudGluZw0KPiA+IDQpIHN0b3JlIEdQQS0+SFBBIG1hcHBpbmcgaW4gdGhl
IHVtZW0NCj4gPiA1KSBnZW5lcmF0ZSBkaWZmcyBvZiBtZW1vcnkgdGFibGUgYW5kIHVzaW5nIElP
TU1VIEFQSSB0byBzZXR1cCB0aGUgZG1hDQo+ID4gbWFwcGluZyBpbiB0aGlzIG1ldGhvZA0KPiA+
DQo+ID4gRm9yIDEpLCBJJ20gbm90IHN1cmUgcGFyZW50IGlzIHN1ZmZpY2llbnQgZm9yIHRvIGRv
aW5nIHRoaXMgb3IgbmVlZCB0bw0KPiA+IGludHJvZHVjZSBuZXcgQVBJIGxpa2UgaW9tbXVfZGV2
aWNlIGluIG1kZXYuDQo+IA0KPiBBZ3JlZS4gV2UgbWF5IGFsc28gbmVlZCB0byBpbnRyb2R1Y2Ug
c29tZXRoaW5nIGxpa2UgdGhlIGlvbW11X2RldmljZS4NCj4gDQoNCldvdWxkIGl0IGJlIGJldHRl
ciBmb3IgdGhlIG1hcC91bW5hcCBsb2dpYyB0byBoYXBwZW4gaW5zaWRlIGVhY2ggZGV2aWNlID8g
DQpEZXZpY2VzIHRoYXQgbmVlZHMgdGhlIElPTU1VIHdpbGwgY2FsbCBpb21tdSBBUElzIGZyb20g
aW5zaWRlIHRoZSBkcml2ZXIgY2FsbGJhY2suIA0KRGV2aWNlcyB0aGF0IGhhcyBvdGhlciB3YXlz
IHRvIGRvIHRoZSBETUEgbWFwcGluZyB3aWxsIGNhbGwgdGhlIHByb3ByaWV0YXJ5IEFQSXMuIA0K
DQo=
