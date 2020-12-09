Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73E2D3E44
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgLIJLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:11:43 -0500
Received: from mail-eopbgr60088.outbound.protection.outlook.com ([40.107.6.88]:28581
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgLIJLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 04:11:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJEfBSUVNOyYrukH23yYjAio5XUmr03G4BJYI3XtT9wiADSkJrIVrHYg5sJoY5yPAvLU5sRtk9QxKMkDHbg4olAgbzuDfyk4D+2R5ShDv6qpaRRMfIn0OWK3Cb2cYnGh3YD5fVHAJA8ct/CPdSmtsmGWDK4HK+j+HRtAHEef4MyVyHkcwSErC42aw2mJ2UVl7V+r2xozkn2n8gwZS5lkDfCUFaUBc7k5IHqSiDnoZHgG6mwDHfEGumYwiht0rZQ3dqLYfiKfxcn3+uoKr8NjOsOAcfils7j0Hc5Orm6/2/r1DDdAFBs+3M47stgx19eEUFHvdFMGZ4I0EmNJP2SPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sO0vFfbexxZrdQpBUurXyqvqeXG2ZBEALe+qlLJdq5M=;
 b=Ur86VEUWDV+XwHshzVuHMcieJ/jA9o6jcr/HSgFY/WsSokHtwSiR9BF8MfLxovMLNe7920pagDCc0uZSGGleGQz0vyvYUcCGnrhr2LreKx4tTa81mtFh0+/fJEOFab2vW5ifZ19HsKklEML57giufT7PXF8vxGRr9NQHGr3b6q5qBKwCAGpiHvKUCAO2L4zP8t0o9hS6XEC2og97ZMp/DDlLnw5I0AjLUVaEyzMu2P5X96RCM3Da7BMR3yPGoqarogBsLN8nPpWf/ohfs/gXZyyK5+H1kBoZSrjp4aKIZHquCAc68A+T7ySGJA7rwMIpQ05LezRe7A7vNj9F+4ALyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sO0vFfbexxZrdQpBUurXyqvqeXG2ZBEALe+qlLJdq5M=;
 b=HVH9OMQ8xwywvJMv+UKvlc2wZYSMLk39kkJUTZ8IoQ6ZVdYh4gCZDy/hXyQ1AQI2vosSiQvmCJPSNuTbaUf/FD7m1ltIsCdFJciMJRvxWR/dPBuZaAYDGZPtNTfLXod6kPQj2fA7EAysdrrgC0jMUpIbBb93HXUDczQbCbCkkTw=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB6646.eurprd04.prod.outlook.com (2603:10a6:20b:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 9 Dec
 2020 09:10:54 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc%6]) with mapi id 15.20.3632.022; Wed, 9 Dec 2020
 09:10:54 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Patrick Havelange <patrick.havelange@essensium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
Thread-Topic: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
Thread-Index: AQHWyXtSU15lz2QhZ0iXI1B/qYMSiKnlgUwAgAfQMQCAABdiMA==
Date:   Wed, 9 Dec 2020 09:10:54 +0000
Message-ID: <AM6PR04MB3976F905489C0CB2ECD1A6FAECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
 <20201203135039.31474-2-patrick.havelange@essensium.com>
 <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <e488ed95-3672-fdcb-d678-fdd4eb9a8b4b@essensium.com>
In-Reply-To: <e488ed95-3672-fdcb-d678-fdd4eb9a8b4b@essensium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: essensium.com; dkim=none (message not signed)
 header.d=none;essensium.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [109.166.137.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ef8c569-3e64-4791-2890-08d89c22550f
x-ms-traffictypediagnostic: AM6PR04MB6646:
x-microsoft-antispam-prvs: <AM6PR04MB66462219C67B61727DEC95B8ECCC0@AM6PR04MB6646.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m22WT0HrvfGKYoFG8pAEKj4pBtU5fTDjWHkdmGpTKrqCvgBnf/jKmEs10sj8y/az2WSxM/IDO+ikRDH2qbiDUHdmpiHCo513E27pZMvqWIQp6fX79KKHyrRFi+paumbU7fv1fXQegYSVO85F3EoFbHXvebH9UGQ/UBG7eMOnNlhQzlgAfoocKkyYQOhqV5mWpf38F//ktRjHDeQbzy6aQP+9tV5Wwsacg0ozHLCq+BH4bO1FUmwCVIeOFOZLMfRAuGSs8mL1O+5LuNXQPA62LguFqWP+yi9NIx8UfCxjXY16YMgGsAyugOXyUyZmtWozabf1vumZfZlVcw+WdToviQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(2906002)(5660300002)(7696005)(86362001)(71200400001)(9686003)(44832011)(33656002)(8936002)(508600001)(26005)(110136005)(66946007)(55016002)(66556008)(53546011)(76116006)(8676002)(6506007)(66476007)(83380400001)(186003)(52536014)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S3I5SWx2TXZGVGpZTmk2VWtnQjhkWDFoQThUVmxqS0dHNFAwTGgxdnpmQ1hJ?=
 =?utf-8?B?ckRTdkhsUzNYYU1pZFVVdXhnMWNQTTdEMzNjb01jK1h3VjljaHE1RUxSekRp?=
 =?utf-8?B?OGEycUZhTExwa1lXbjdnVlBtVmJocFI4WmgyMGZMK3dKaitkdzB2UzZQT1Ez?=
 =?utf-8?B?VXc0TGVaOWQ0S09wSStPQ25nRW90MWxXbmxiOWNOVll6UEtZNzQzbkhBNXMr?=
 =?utf-8?B?cEorS2oxSWZvanlueVYwMm5wbVplTExQUVZaUXhzdmhHdnVoUmlmYk5iczhO?=
 =?utf-8?B?VVBBZVNpMTdoeEQ0VUhTVUg4bFpLMm0rN3NSQlNwS3Znek9sbGNIaEo4TmlV?=
 =?utf-8?B?M2I1WXozZDBaQXYwdUVPQ0pkMFF4VklGUytsdHVRL243YmF3cnBUY0ZaZVZv?=
 =?utf-8?B?L2IrajJEUGlodEdMZVJ4SkFOdVdwcUxUaS9jYTg2bk9HZkVJVnNXRWFrNU5O?=
 =?utf-8?B?ZVhmVmhWeE1WK3pEOGJXeitQTlNpd0VGRmt6RGJHQnJUM1lybFVpRzZCN0Mz?=
 =?utf-8?B?VmZmekx4QnJZczJSNFQwQS9Kdnh3RzNFZHQ0ZVphYWh0WDdnaFVYTDZXVlhN?=
 =?utf-8?B?OWRZQTJXa2xrSEd6MWxZYWhNUitDNXNnVVVWS1dnUjJnRFhZK0tLRExqNHZV?=
 =?utf-8?B?a291c2E4UmVVVVdlQVBFY2VaeGs4VEdSN1BVcFRrRTE2R1drbmlITm9IcStM?=
 =?utf-8?B?a1krNmc3a3ZyNC84ZUFPZ1pvNTAvYUlzdTVNK3VsWlJFRGZhcHg2Y2ZQMTVX?=
 =?utf-8?B?UXlCdWw0aWhYWHNlZmpiM0hURjFGMFQ4cUR1eDY1S2VZb0RXb3FrZWhyWitt?=
 =?utf-8?B?SjVFOGk2dW1xRU1pRFBqUFdnc3oxcWE3c29VOHpZbDhWaTFpTFBjZjE3K2NV?=
 =?utf-8?B?V3FwRUVTWkMxS3NDemZWb29yUkVpdUFXZkNvaThjUllRbkVJZkR1NWoyVExZ?=
 =?utf-8?B?RFNkQjVjalI0UG1jcjNONm1DOTNPTERKQ241aVBkNTBJRFMvTnhjUlhkbE5T?=
 =?utf-8?B?SzRIMEtPNE9pQUR5S2JDQStRV1NIWmRqei8vWFR0NGdWVmlqdXByOWNjVW84?=
 =?utf-8?B?enRBSWRyWEZKTXJOT2pnR25HMDVSV1pUbHNubitGVUhHSERlMWNtYnF0WTE2?=
 =?utf-8?B?SHBvZ0dHNDIvUy9LUnRidk5xV3RRaUtoa1RQNWRzOHNFbElBVDdpSlIvQ3ZV?=
 =?utf-8?B?Q3U1M2J5ZkZ4NGVaeGdReDVrQ28zcStPaDduNHplZDI4Rkwrd2xuT1dyUHRl?=
 =?utf-8?B?NjFpWU1UdkF0VjBZeHZ4RzBtSmN4M1JINmcxVW96MHRqR2Fnb2VDWnlubTdn?=
 =?utf-8?Q?pKXU/WwOmOsxA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef8c569-3e64-4791-2890-08d89c22550f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 09:10:54.1763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k8qpCfY/O9CHXgZUyVKpltAD7gR3tuaW8QFhzf5bM8Sy1Nc+THP3RU5QnlUKR1168gveCGqxE3xsAdD4EP9p/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6646
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYXRyaWNrIEhhdmVsYW5nZSA8
cGF0cmljay5oYXZlbGFuZ2VAZXNzZW5zaXVtLmNvbT4NCj4gU2VudDogMDggRGVjZW1iZXIgMjAy
MCAxNjo1Ng0KPiBUbzogTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBueHAuY29tPjsgRGF2
aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgMS80XSBuZXQ6IGZyZWVz
Y2FsZS9mbWFuOiBTcGxpdCB0aGUgbWFpbiByZXNvdXJjZQ0KPiByZWdpb24gcmVzZXJ2YXRpb24N
Cj4gDQo+IE9uIDIwMjAtMTItMDMgMTY6NDcsIE1hZGFsaW4gQnVjdXIgd3JvdGU6DQo+ID4+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFBhdHJpY2sgSGF2ZWxhbmdlIDxw
YXRyaWNrLmhhdmVsYW5nZUBlc3NlbnNpdW0uY29tPg0KPiA+PiBTZW50OiAwMyBEZWNlbWJlciAy
MDIwIDE1OjUxDQo+ID4+IFRvOiBNYWRhbGluIEJ1Y3VyIDxtYWRhbGluLmJ1Y3VyQG54cC5jb20+
OyBEYXZpZCBTLiBNaWxsZXINCj4gPj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNp
bnNraSA8a3ViYUBrZXJuZWwub3JnPjsNCj4gPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+PiBDYzogUGF0cmljayBIYXZlbGFuZ2UgPHBh
dHJpY2suaGF2ZWxhbmdlQGVzc2Vuc2l1bS5jb20+DQo+ID4+IFN1YmplY3Q6IFtQQVRDSCBuZXQg
MS80XSBuZXQ6IGZyZWVzY2FsZS9mbWFuOiBTcGxpdCB0aGUgbWFpbiByZXNvdXJjZQ0KPiA+PiBy
ZWdpb24gcmVzZXJ2YXRpb24NCj4gPj4NCj4gPj4gVGhlIG1haW4gZm1hbiBkcml2ZXIgaXMgb25s
eSB1c2luZyBzb21lIHBhcnRzIG9mIHRoZSBmbWFuIG1lbW9yeQ0KPiA+PiByZWdpb24uDQo+ID4+
IFNwbGl0IHRoZSByZXNlcnZhdGlvbiBvZiB0aGUgbWFpbiByZWdpb24gaW4gMiwgc28gdGhhdCB0
aGUgb3RoZXINCj4gPj4gcmVnaW9ucyB0aGF0IHdpbGwgYmUgdXNlZCBieSBmbWFuLXBvcnQgYW5k
IGZtYW4tbWFjIGRyaXZlcnMgY2FuDQo+ID4+IGJlIHJlc2VydmVkIHByb3Blcmx5IGFuZCBub3Qg
YmUgaW4gY29uZmxpY3Qgd2l0aCB0aGUgbWFpbiBmbWFuDQo+ID4+IHJlc2VydmF0aW9uLg0KPiA+
Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBQYXRyaWNrIEhhdmVsYW5nZSA8cGF0cmljay5oYXZlbGFu
Z2VAZXNzZW5zaXVtLmNvbT4NCj4gPg0KPiA+IEkgdGhpbmsgdGhlIHByb2JsZW0geW91IGFyZSB0
cnlpbmcgdG8gd29yayBvbiBoZXJlIGlzIHRoYXQgdGhlIGRldmljZQ0KPiA+IHRyZWUgZW50cnkg
dGhhdCBkZXNjcmliZXMgdGhlIEZNYW4gSVAgYWxsb3RzIHRvIHRoZSBwYXJlbnQgRk1hbiBkZXZp
Y2UNCj4gdGhlDQo+ID4gd2hvbGUgbWVtb3J5LW1hcHBlZCByZWdpc3RlcnMgYXJlYSwgYXMgZGVz
Y3JpYmVkIGluIHRoZSBkZXZpY2UgZGF0YXNoZWV0Lg0KPiA+IFRoZSBzbWFsbGVyIEZNYW4gYnVp
bGRpbmcgYmxvY2tzIChwb3J0cywgTURJTyBjb250cm9sbGVycywgZXRjLikgYXJlDQo+ID4gZWFj
aCB1c2luZyBhIG5lc3RlZCBzdWJzZXQgb2YgdGhpcyBtZW1vcnktbWFwcGVkIHJlZ2lzdGVycyBh
cmVhLg0KPiA+IFdoaWxlIHRoaXMgaGllcmFyY2hpY2FsIGRlcGljdGlvbiBvZiB0aGUgaGFyZHdh
cmUgaGFzIG5vdCBwb3NlZCBhDQo+IHByb2JsZW0NCj4gPiB0byBkYXRlLCBpdCBpcyBwb3NzaWJs
ZSB0byBjYXVzZSBpc3N1ZXMgaWYgYm90aCB0aGUgRk1hbiBkcml2ZXIgYW5kIGFueQ0KPiA+IG9m
IHRoZSBzdWItYmxvY2tzIGRyaXZlcnMgYXJlIHRyeWluZyB0byBleGNsdXNpdmVseSByZXNlcnZl
IHRoZQ0KPiByZWdpc3RlcnMNCj4gPiBhcmVhLiBJJ20gYXNzdW1pbmcgdGhpcyBpcyB0aGUgcHJv
YmxlbSB5b3UgYXJlIHRyeWluZyB0byBhZGRyZXNzIGhlcmUsDQo+ID4gYmVzaWRlcyB0aGUgc3Rh
Y2sgY29ycnVwdGlvbiBpc3N1ZS4NCj4gDQo+IFllcyBleGFjdGx5Lg0KPiBJIGRpZCBub3QgYWRk
IHRoaXMgYmVoYXZpb3VyIChoYXZpbmcgYSBtYWluIHJlZ2lvbiBhbmQgc3ViZHJpdmVycyB1c2lu
Zw0KPiBzdWJyZWdpb25zKSwgSSdtIGp1c3QgdHJ5aW5nIHRvIGNvcnJlY3Qgd2hhdCBpcyBhbHJl
YWR5IHRoZXJlLg0KPiBGb3IgZXhhbXBsZTogdGhpcyBpcyBzb21lIGNvbnRlbnQgb2YgL3Byb2Mv
aW9tZW0gZm9yIG9uZSBib2FyZCBJJ20NCj4gd29ya2luZyB3aXRoLCB3aXRoIHRoZSBjdXJyZW50
IGV4aXN0aW5nIGNvZGU6DQo+IGZmZTQwMDAwMC1mZmU0ZmRmZmYgOiBmbWFuDQo+ICAgIGZmZTRl
MDAwMC1mZmU0ZTBmZmYgOiBtYWMNCj4gICAgZmZlNGUyMDAwLWZmZTRlMmZmZiA6IG1hYw0KPiAg
ICBmZmU0ZTQwMDAtZmZlNGU0ZmZmIDogbWFjDQo+ICAgIGZmZTRlNjAwMC1mZmU0ZTZmZmYgOiBt
YWMNCj4gICAgZmZlNGU4MDAwLWZmZTRlOGZmZiA6IG1hYw0KPiANCj4gYW5kIG5vdyB3aXRoIG15
IHBhdGNoZXM6DQo+IGZmZTQwMDAwMC1mZmU0ZmRmZmYgOiAvc29jQGZmZTAwMDAwMC9mbWFuQDQw
MDAwMA0KPiAgICBmZmU0MDAwMDAtZmZlNDgwZmZmIDogZm1hbg0KPiAgICBmZmU0ODgwMDAtZmZl
NDg4ZmZmIDogZm1hbi1wb3J0DQo+ICAgIGZmZTQ4OTAwMC1mZmU0ODlmZmYgOiBmbWFuLXBvcnQN
Cj4gICAgZmZlNDhhMDAwLWZmZTQ4YWZmZiA6IGZtYW4tcG9ydA0KPiAgICBmZmU0OGIwMDAtZmZl
NDhiZmZmIDogZm1hbi1wb3J0DQo+ICAgIGZmZTQ4YzAwMC1mZmU0OGNmZmYgOiBmbWFuLXBvcnQN
Cj4gICAgZmZlNGE4MDAwLWZmZTRhOGZmZiA6IGZtYW4tcG9ydA0KPiAgICBmZmU0YTkwMDAtZmZl
NGE5ZmZmIDogZm1hbi1wb3J0DQo+ICAgIGZmZTRhYTAwMC1mZmU0YWFmZmYgOiBmbWFuLXBvcnQN
Cj4gICAgZmZlNGFiMDAwLWZmZTRhYmZmZiA6IGZtYW4tcG9ydA0KPiAgICBmZmU0YWMwMDAtZmZl
NGFjZmZmIDogZm1hbi1wb3J0DQo+ICAgIGZmZTRjMDAwMC1mZmU0ZGZmZmYgOiBmbWFuDQo+ICAg
IGZmZTRlMDAwMC1mZmU0ZTBmZmYgOiBtYWMNCj4gICAgZmZlNGUyMDAwLWZmZTRlMmZmZiA6IG1h
Yw0KPiAgICBmZmU0ZTQwMDAtZmZlNGU0ZmZmIDogbWFjDQo+ICAgIGZmZTRlNjAwMC1mZmU0ZTZm
ZmYgOiBtYWMNCj4gICAgZmZlNGU4MDAwLWZmZTRlOGZmZiA6IG1hYw0KPiANCj4gPiBXaGlsZSBm
b3IgdGhlIGxhdHRlciBJIHRoaW5rIHdlIGNhbg0KPiA+IHB1dCB0b2dldGhlciBhIHF1aWNrIGZp
eCwgZm9yIHRoZSBmb3JtZXIgSSdkIGxpa2UgdG8gdGFrZSBhIGJpdCBvZiB0aW1lDQo+ID4gdG8g
c2VsZWN0IHRoZSBiZXN0IGZpeCwgaWYgb25lIGlzIHJlYWxseSBuZWVkZWQuIFNvLCBwbGVhc2Us
IGxldCdzIHNwbGl0DQo+ID4gdGhlIHR3byBwcm9ibGVtcyBhbmQgZmlyc3QgYWRkcmVzcyB0aGUg
aW5jb3JyZWN0IHN0YWNrIG1lbW9yeSB1c2UuDQo+IA0KPiBJIGhhdmUgbm8gaWRlYSBob3cgeW91
IGNhbiBmaXggaXQgd2l0aG91dCBhIChtb3JlIGNvcnJlY3QgdGhpcyB0aW1lKQ0KPiBkdW1teSBy
ZWdpb24gcGFzc2VkIGFzIHBhcmFtZXRlciAoYW5kIHlvdSBkb24ndCB3YW50IHRvIHVzZSB0aGUg
Zmlyc3QNCj4gcGF0Y2gpLiBCdXQgdGhlbiBpdCB3aWxsIGJlIHVzZWxlc3MgdG8gZG8gdGhlIGNh
bGwgYW55d2F5LCBhcyBpdCB3b24ndA0KPiBkbyBhbnkgcHJvcGVyIHZlcmlmaWNhdGlvbiBhdCBh
bGwsIHNvIGl0IGNvdWxkIGFsc28gYmUgcmVtb3ZlZCBlbnRpcmVseSwNCj4gd2hpY2ggYmVncyB0
aGUgcXVlc3Rpb24sIHdoeSBkbyBpdCBhdCBhbGwgaW4gdGhlIGZpcnN0IHBsYWNlICh0aGUNCj4g
ZGV2bV9yZXF1ZXN0X21lbV9yZWdpb24pLg0KPiANCj4gSSdtIG5vdCBhbiBleHBlcnQgaW4gdGhh
dCBwYXJ0IG9mIHRoZSBjb2RlIHNvIGZlZWwgZnJlZSB0byBjb3JyZWN0IG1lIGlmDQo+IEkgbWlz
c2VkIHNvbWV0aGluZy4NCj4gDQo+IEJSLA0KPiANCj4gUGF0cmljayBILg0KDQpIaSwgUGF0cmlj
aywNCg0KdGhlIERQQUEgZW50aXRpZXMgYXJlIGRlc2NyaWJlZCBpbiB0aGUgZGV2aWNlIHRyZWUu
IEFkZGluZyBzb21lIGhhcmRjb2RpbmcgaW4NCnRoZSBkcml2ZXIgaXMgbm90IHJlYWxseSB0aGUg
c29sdXRpb24gZm9yIHRoaXMgcHJvYmxlbS4gQW5kIEknbSBub3Qgc3VyZSB3ZSBoYXZlDQphIGNs
ZWFyIHByb2JsZW0gc3RhdGVtZW50IHRvIHN0YXJ0IHdpdGguIENhbiB5b3UgaGVscCBtZSBvbiB0
aGF0IHBhcnQ/DQoNCk1hZGFsaW4NCg==
