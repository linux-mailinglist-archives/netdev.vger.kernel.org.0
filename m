Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77843E305C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 13:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438979AbfJXL1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 07:27:23 -0400
Received: from mail-eopbgr00071.outbound.protection.outlook.com ([40.107.0.71]:56382
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438971AbfJXL1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 07:27:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgovGwNcFznDO1U1VVsWleifm5ongGmWazZ6ufdk67WKGyCPZnNOVFppsJr6dwAlzn1v/Rij8s1AMtKwbcAeMd/6bn+AR1v6YOfPxUUUDcSg6QSd5Mpb/HdT/GTS5WTEQZj+uOfQo6dpcnALYgxxlUaq3Z3fb8LiFBdknEsJnB7SpNKe6bOS+S9MHW1H67Qwm2q0vwqCMgf8MzicaSJKP5nd+kRnrbGc9eIwC/+X2wtPhe1lBmTX/NfAQ/7QW0R6911095UsOXPzje+WLtyY3ygGIpBATZLIVBbojvKBjqfxC2X69puU23C+PrmwpaE+OrY4GlM7qnXv0IsMjdoCYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy6mqQMWpCSf+Qx/DgIg4DprDSwfcuLGg+XkGZ/6fSU=;
 b=DmX3GhzpvoGGXWltgpQPyx3JXNgFNeB3OQgAfEnPgJChcez5EIWRgFpJZKKZn0J3BKMXvujPjetE3bRockwN4flrtrnoTHZkItb2ZtFjFnsvYbqq4oQU0DxHwwWFUjIWgkBw380xGvkpRcrju1sw2XIpKEpEO6XNlAEFnsAo9wHMPNMbFPV/aOMr7oyeqOg/2FHcxrP0Q6rVJQpDdo/s+6r/40sUfJnMpwW02di8B1j1p/cwK/bKXUr/6ImpHApcsC/qDP44AWOOEji37La3BbOJVJ9Jyx9HkTtmT3SCiUZS4jb2cOjY64RUaNhSkg+9f51bQKe2LhpA7xW/UVdZZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wy6mqQMWpCSf+Qx/DgIg4DprDSwfcuLGg+XkGZ/6fSU=;
 b=TaFl3VnWiw+aj45NCU+748GChRV6+zl9C6IB5pLQ3+a6lCgxONX/wUij0E4Ryki6Dz3ff2BdBT5jiiPJPOiGlU1sthyYO1weMMIU0PWHUMQYgxyH1LTZHX+162B7p3pOLcjUlSJQdABE0wDPW/WS2EAHJQagI9YNhSAhCYQzSck=
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com (20.177.51.208) by
 VI1PR04MB7069.eurprd04.prod.outlook.com (10.186.157.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Thu, 24 Oct 2019 11:27:17 +0000
Received: from VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb]) by VI1PR04MB5134.eurprd04.prod.outlook.com
 ([fe80::10f0:af2c:76ac:dfb%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 11:27:17 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     Robin Murphy <robin.murphy@arm.com>, "hch@lst.de" <hch@lst.de>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Topic: [RFC PATCH 1/3] dma-mapping: introduce a new dma api
 dma_addr_to_phys_addr()
Thread-Index: AQHVilrGnKjPt4OKKUmo2Ix2Q0Rbb6dpp0QA
Date:   Thu, 24 Oct 2019 11:27:17 +0000
Message-ID: <f01dc1b3-7d7d-118a-fbe9-1b176c4ce75a@nxp.com>
References: <20191022125502.12495-1-laurentiu.tudor@nxp.com>
 <20191022125502.12495-2-laurentiu.tudor@nxp.com>
 <62561dca-cdd7-fe01-a0c3-7b5971c96e7e@arm.com>
 <50a42575-02b2-c558-0609-90e2ad3f515b@nxp.com> <20191024020140.GA6057@lst.de>
 <ebbf742e-4d1f-ba90-0ed8-93ea445d0200@nxp.com>
 <2b75c349-0ca1-ea7e-6571-28db9f1a8c46@arm.com>
In-Reply-To: <2b75c349-0ca1-ea7e-6571-28db9f1a8c46@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=laurentiu.tudor@nxp.com; 
x-originating-ip: [89.37.124.34]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 12b0c47a-ca8a-4a91-e65f-08d7587520a9
x-ms-traffictypediagnostic: VI1PR04MB7069:|VI1PR04MB7069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB70692B5F76C92891CC129AD3EC6A0@VI1PR04MB7069.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(189003)(199004)(52314003)(31686004)(4326008)(486006)(66476007)(186003)(81166006)(81156014)(26005)(64756008)(11346002)(66446008)(36756003)(2616005)(8676002)(66556008)(91956017)(66946007)(476003)(478600001)(6512007)(14454004)(99286004)(446003)(5660300002)(2906002)(71200400001)(8936002)(66066001)(110136005)(229853002)(6436002)(86362001)(256004)(25786009)(54906003)(561944003)(6486002)(305945005)(71190400001)(76116006)(31696002)(76176011)(7736002)(44832011)(6116002)(14444005)(3846002)(6506007)(53546011)(6246003)(4001150100001)(102836004)(2501003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB7069;H:VI1PR04MB5134.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yBn/ZqLFKmt/iqLBmoPmgGvPIGdvhreTeMx/sH5iLmYrX189czVRvn/+JycX3ctE2/omZ72HM1MxFVWE/YRqrl6/kQ+jMvsAsewA33LGpebclXC2VmN3bphInLaiV/3bZfnz4KW7rxo2mBzfgUPlYPSPtE3ah0LOt/RIeSu/v93U3jr120vKfKgcLCtvv5Txmtg809j02fQ4NVEpwSnxTV4YnxhwU6+7fIgF3aNcgwUI0gpx4yZ165Ms3uraQl7UNRvJQYMjXWZqU4GTj5hfExUJcDavvFP+Qvc/kIgbtIa6y0CeII4fb7UiOTuDzfp21E0miOdUicuNeD41/T2Z7Bi+DZBjnZeP+VhaoUF0hwAA8keV6e2A/zna2i6dXmGJhPkSNcagUK3gAa2FyZu8/6UUwDJOl6KNSflbCUDajso46WW7CFpO2Q4Av/Mm4j74
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9DF65D53EA6314D9FA5AB3AF57E7CDB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12b0c47a-ca8a-4a91-e65f-08d7587520a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 11:27:17.7188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCinWk9DF4ccaoexw3gRwGajFhbAm4icxXhFdsG7r3P21aunyV7yku+UVL2gfEtshcIT9fwKWOE2BPhylqpjdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQuMTAuMjAxOSAxNDowNCwgUm9iaW4gTXVycGh5IHdyb3RlOg0KPiBPbiAyMDE5LTEwLTI0
IDg6NDkgYW0sIExhdXJlbnRpdSBUdWRvciB3cm90ZToNCj4+DQo+Pg0KPj4gT24gMjQuMTAuMjAx
OSAwNTowMSwgaGNoQGxzdC5kZSB3cm90ZToNCj4+PiBPbiBXZWQsIE9jdCAyMywgMjAxOSBhdCAx
MTo1Mzo0MUFNICswMDAwLCBMYXVyZW50aXUgVHVkb3Igd3JvdGU6DQo+Pj4+IFdlIGhhZCBhbiBp
bnRlcm5hbCBkaXNjdXNzaW9uIG92ZXIgdGhlc2UgcG9pbnRzIHlvdSBhcmUgcmFpc2luZyBhbmQN
Cj4+Pj4gTWFkYWxpbiAoY2MtZWQpIGNhbWUgdXAgd2l0aCBhbm90aGVyIGlkZWE6IGluc3RlYWQg
b2YgYWRkaW5nIHRoaXMgcHJvbmUNCj4+Pj4gdG8gbWlzdXNlIGFwaSBob3cgYWJvdXQgZXhwZXJp
bWVudGluZyB3aXRoIGEgbmV3IGRtYSB1bm1hcCBhbmQgZG1hIHN5bmMNCj4+Pj4gdmFyaWFudHMg
dGhhdCB3b3VsZCByZXR1cm4gdGhlIHBoeXNpY2FsIGFkZHJlc3MgYnkgY2FsbGluZyB0aGUgbmV3
bHkNCj4+Pj4gaW50cm9kdWNlZCBkbWEgbWFwIG9wLiBTb21ldGhpbmcgYWxvbmcgdGhlc2UgbGlu
ZXM6DQo+Pj4+IMKgwqDCoCAqIHBoeXNfYWRkcl90IGRtYV91bm1hcF9wYWdlX3JldF9waHlzKC4u
LikNCj4+Pj4gwqDCoMKgICogcGh5c19hZGRyX3QgZG1hX3VubWFwX3NpbmdsZV9yZXRfcGh5cygu
Li4pDQo+Pj4+IMKgwqDCoCAqIHBoeXNfYWRkcl90IGRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1X3Jl
dF9waHlzKC4uLikNCj4+Pj4gSSdtIHRoaW5raW5nIHRoYXQgdGhpcyBwcm9wb3NhbCBzaG91bGQg
cmVkdWNlIHRoZSByaXNrcyBvcGVuZWQgYnkgdGhlDQo+Pj4+IGluaXRpYWwgdmFyaWFudC4NCj4+
Pj4gUGxlYXNlIGxldCBtZSBrbm93IHdoYXQgeW91IHRoaW5rLg0KPj4+DQo+Pj4gSSdtIG5vdCBz
dXJlIHdoYXQgdGhlIHJldCBpcyBzdXBwb3NlZCB0byBtZWFuLCBidXQgSSBnZW5lcmFsbHkgbGlr
ZQ0KPj4+IHRoYXQgaWRlYSBiZXR0ZXIuDQo+Pg0KPj4gSXQgd2FzIHN1cHBvc2VkIHRvIGJlIHNo
b3J0IGZvciAicmV0dXJuIiBidXQgZ2l2ZW4gdGhhdCBJJ20gbm90IGdvb2QgYXQNCj4+IG5hbWlu
ZyBzdHVmZiBJJ2xsIGp1c3QgZHJvcCBpdC4NCj4gDQo+IEhtbSwgaG93IGFib3V0IHNvbWV0aGlu
ZyBsaWtlICJkbWFfdW5tYXBfKl9kZXNjIiBmb3IgdGhlIGNvbnRleHQgb2YgdGhlIA0KPiBtYXBw
ZWQgRE1BIGFkZHJlc3MgYWxzbyBiZWluZyB1c2VkIGFzIGEgZGVzY3JpcHRvciB0b2tlbj8NCg0K
QWxyaWdodC4NCg0KPj4+IFdlIGFsc28gbmVlZCB0byBtYWtlIHN1cmUgdGhlcmUgaXMgYW4gZWFz
eSB3YXkNCj4+PiB0byBmaWd1cmUgb3V0IGlmIHRoZXNlIEFQSXMgYXJlIGF2YWlsYWJsZSwgYXMg
dGhleSBnZW5lcmFsbHkgYXJlbid0DQo+Pj4gZm9yIGFueSBub24tSU9NTVUgQVBJIElPTU1VIGRy
aXZlcnMuDQo+Pg0KPj4gSSB3YXMgcmVhbGx5IGhvcGluZyB0byBtYW5hZ2UgbWFraW5nIHRoZW0g
YXMgZ2VuZXJpYyBhcyBwb3NzaWJsZSBidXQNCj4+IGFueXdheSwgSSdsbCBzdGFydCB3b3JraW5n
IG9uIGEgUG9DIGFuZCBzZWUgaG93IGl0IHR1cm5zIG91dC4gVGhpcyB3aWxsDQo+PiBwcm9iYWJs
eSBoYXBwZW4gc29tZXRpbWUgbmV4dCBuZXh0IHdlZWsgYXMgdGhlIGZvbGxvd2luZyB3ZWVrIEkn
bGwgYmUNCj4+IHRyYXZlbGluZyB0byBhIGNvbmZlcmVuY2UuDQo+IA0KPiBBRkFJQ1MsIGV2ZW4g
YSBmdWxsIGltcGxlbWVudGF0aW9uIG9mIHRoZXNlIEFQSXMgd291bGQgaGF2ZSB0byBiZSANCj4g
Y2FwYWJsZSBvZiByZXR1cm5pbmcgYW4gaW5kaWNhdGlvbiB0aGF0IHRoZXJlIGlzIG5vIHZhbGlk
IHBoeXNpY2FsIA0KPiBhZGRyZXNzIC0gZS5nLiBpZiB1bm1hcCBpcyBjYWxsZWQgd2l0aCBhIGJv
Z3VzIERNQSBhZGRyZXNzIHRoYXQgd2FzIA0KPiBuZXZlciBtYXBwZWQuIEF0IHRoYXQgcG9pbnQg
dGhlcmUnc3NlZW1pbmdseSBubyBwcm9ibGVtIGp1c3QgDQo+IGltcGxlbWVudGluZyB0aGUgdHJp
dmlhbCBjYXNlIG9uIHRvcCBvZiBhbnkgZXhpc3RpbmcgdW5tYXAvc3luYyANCj4gY2FsbGJhY2tz
IGZvciBldmVyeW9uZS4gSSdkIGltYWdpbmUgdGhhdCBkcml2ZXJzIHdoaWNoIHdhbnQgdGhpcyBh
cmVuJ3QgDQo+IGxpa2VseSB0byBydW4gb24gdGhlIG9sZGVyIGFyY2hpdGVjdHVyZXMgd2hlcmUg
dGhlIHdlaXJkIElPTU1VcyBsaXZlLCBzbyANCj4gdGhleSBjb3VsZCBwcm9iYWJseSBqdXN0IGFs
d2F5cyB0cmVhdCBmYWlsdXJlIGFzIHVuZXhwZWN0ZWQgYW5kIGZhdGFsIA0KPiBlaXRoZXIgd2F5
Lg0KPiANCj4gSW4gZmFjdCwgSSdtIG5vdyB3b25kZXJpbmcgd2hldGhlciBpdCdzIGxpa2VseSB0
byBiZSBjb21tb24gdGhhdCB1c2VycyANCj4gd2FudCB0aGUgcGh5c2ljYWwgYWRkcmVzcyBzcGVj
aWZpY2FsbHksIG9yIHdoZXRoZXIgaXQgd291bGQgbWFrZSBzZW5zZSANCj4gdG8gcmV0dXJuIHRo
ZSBvcmlnaW5hbCBWQS9wYWdlLCBib3RoIGZvciBzeW1tZXRyeSB3aXRoIHRoZSBjb3JyZXNwb25k
aW5nIA0KPiBtYXAgY2FsbHMgYW5kIGZvciB0aGUgZWFzZSBvZiBiZWluZyBhYmxlIHRvIHJldHVy
biBOVUxMIHdoZW4gbmVjZXNzYXJ5Lg0KDQpUaGF0J3Mgc291bmRzIHdvbmRlcmZ1bCBhcyBpdCBz
aG91bGQgbWFrZSB0aGUgY29kZSBsZWFuZXIgaW4gdGhlIGRyaXZlcnMuDQoNCi0tLQ0KQmVzdCBS
ZWdhcmRzLCBMYXVyZW50aXU=
