Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE76148F51
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388980AbgAXU0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:26:51 -0500
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:12927
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387548AbgAXU0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:26:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYmLnWhcCJn2Lh9ZrxEu9ExB0WnX4Pj+z2ihb7MYkAZ2KnKZG8OsyEcd8olpX7QwPHTv2gCoQUAxz60WGstNtNs18I5jfkJJAqmOaxpv+r4PJTKvSrqes7k7b1pvMiGqqJhcb4Z5OCYr45j6k7rVaLXw8iFlB3KHIgTkcLNJUiIlGhccYr/uyYGdtaMtS0nJGjpQLMHBMr3kGfItYrP2aGz9PAsbFcDCblAtnUZ5B1c08uegyixuHgYlT/8TaRfYI0gOHHXbM8bk41K4dnJVoPqggzZ8I39ckXqaeaO8ncR7/ILRxjKSGyVIRm7HaUH/Kiwqq5iwXK2CR8/un1vlmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZW9y7VIN19E/FBv0TCbqSo5q/C1XG6Jf//01H9CGow=;
 b=aFA1xdxacxuEjtfl63jWRGsTrtE0ab17rigfoIGDaMO7We+P9p9QduuFty8yfxaFN9+UTjjehSslHvW59Gk1USuEnC0xLEF0VFacMGNlPDsZZ8R8EEfWJ6XmJMinm0hYHwdvkpqAhO1vW63VinLtfF4q1jEM8d9qWNs5zTAiX9L/T7nMbSCl53jYBpB2VlMc15/jzVLbwQ/bYjg6q2n1xc4p6YeVHBj/IPkemggUnIJPw/4B8W5hs/8eNffa/Qy1bT/oF2AKJnzQ0wF2Zw2p91Ha3luYa5IZj/FQqecXMRjAY5NWCpGZ8TpKsgrtiXVqh2Xp+JL97TID2qC/RZ1TpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZW9y7VIN19E/FBv0TCbqSo5q/C1XG6Jf//01H9CGow=;
 b=f91Bzy59v6v5rSvLy2kfBnNP4OCLfr+rI7xevuqye8FDsjNDss9EER79WYsR1bitYAcfD7Dl48L3dvgnvVAaCwI4ki9s46yonwXA+pfXzObv9+yiVmXrbJn236lhNzkTtRypAqu3VlxbHIu+dCGVh8Nd1Dc5nz84m6sFJ9pmc+c=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:26:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:26:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Oz Shlomo <ozsh@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [PATCH net-next 00/13] Handle multi chain hardware misses
Thread-Topic: [PATCH net-next 00/13] Handle multi chain hardware misses
Thread-Index: AQHV0HY4DifryuDZx0aVaDBxGBwzoqf1n68AgAJloQCAAkL0gA==
Date:   Fri, 24 Jan 2020 20:26:47 +0000
Message-ID: <9ee545fca21031d4fbd82fe204be5323c9f9f7cd.camel@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
         <4b0bcbf60537bcdfe8d184531788a9b6084be8f6.camel@mellanox.com>
         <20200123.105436.515913650694137847.davem@davemloft.net>
In-Reply-To: <20200123.105436.515913650694137847.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc322403-a875-4af8-3558-08d7a10bbc86
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB555268D3C33DFAB9EE91FA2CBE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(199004)(189003)(64756008)(66446008)(76116006)(66946007)(4326008)(66476007)(107886003)(66556008)(91956017)(110136005)(316002)(6512007)(71200400001)(54906003)(186003)(26005)(6486002)(6506007)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uBCnyc9pKVu6LndL6J4SZWfnk1k3rKsdaLcifPYDEtLnhoU5fBdAT4DG/NLnnOdLa2dIFuhAUlPa7mmhtGMpYt2VROQRW3/HCV8jlKGtEaDPbKr4PC6ZcszyJd5SgUarme3utB4POiLBaehA5N+/N/YeWoqvGU638TNi80q/ySZBxKWqayaqC6BAh+qBVmsqmKHqILE59g/lCT8qVclL3EvrxD043ExjDrFrUrN7QtmJts3IskwqYyuWPEm4U790rOFslRPBQLNeZe3gp84pWSfVQhhXe1OU/cY6Nt6wa9vUFzmKqjs7mAIq4MXXAzI9/MjyyEodNkQTQS8rq28MUHMJhsHiVdp+KGwGedcVGwhGXiUjZ1b9X3mfaaSO3BXmsIxxNsFSTB9hFy+qDyx/Ho7BwoZ8PjnWUZg6BzONajS+nqBDmRJgBmKRyMvdmBQi
x-ms-exchange-antispam-messagedata: Iasdosqz79L4xDsQg6SIO3PjBOyK0XcVkpgssrRQ6k0Q0v1jCRaOZHxuD6t9z5J5lKVd5yPzy6cnGONHGWGpLVzCy2DKbmVrKrtUgyBcERaKnUN+GsM7tkmeDRTuaer+2gPjoPlP662obDp+Y+R9Bw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E289330549A2841BD7D6318D2C98354@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc322403-a875-4af8-3558-08d7a10bbc86
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:26:47.4759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ti0VRXgQKT/J1avjNkTyE14cmzQmVuJOXtorUjuKuOa0PCJeDcvuOAwgrSuPnmHXZ+S+PwGkkl9HgGY2oyNN7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAxLTIzIGF0IDEwOjU0ICswMTAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUs
IDIxIEphbiAyMDIwIDIxOjE4OjIxICswMDAwDQo+IA0KPiA+IE9uIFR1ZSwgMjAyMC0wMS0yMSBh
dCAxODoxNiArMDIwMCwgUGF1bCBCbGFrZXkgd3JvdGU6DQo+ID4+IE5vdGUgdGhhdCBtaXNzIHBh
dGggaGFuZGxpbmcgb2YgbXVsdGktY2hhaW4gcnVsZXMgaXMgYSByZXF1aXJlZA0KPiA+PiBpbmZy
YXN0cnVjdHVyZQ0KPiA+PiBmb3IgY29ubmVjdGlvbiB0cmFja2luZyBoYXJkd2FyZSBvZmZsb2Fk
LiBUaGUgY29ubmVjdGlvbiB0cmFja2luZw0KPiA+PiBvZmZsb2FkDQo+ID4+IHNlcmllcyB3aWxs
IGZvbGxvdyB0aGlzIG9uZS4NCj4gPiANCj4gPiBIaSBEYXZlIGFuZCBKYWt1YiwNCj4gPiANCj4g
PiBBcyBQYXVsIGV4cGxhaW5lZCB0aGlzIGlzIHBhcnQgb25lIG9mIHR3byBwYXJ0cyBzZXJpZXMs
DQo+ID4gDQo+ID4gQXNzdW1pbmcgdGhlIHJldmlldyB3aWxsIGdvIHdpdGggbm8gaXNzdWVzIGkg
d291bGQgbGlrZSB0byBzdWdnZXN0DQo+IHRoZQ0KPiA+IGZvbGxvd2luZyBhY2NlcHRhbmNlIG9w
dGlvbnM6DQo+ID4gDQo+ID4gb3B0aW9uIDEpIEkgY2FuIGNyZWF0ZSBhIHNlcGFyYXRlIHNpZGUg
YnJhbmNoIGZvciBjb25uZWN0aW9uDQo+IHRyYWNraW5nDQo+ID4gb2ZmbG9hZCBhbmQgb25jZSBQ
YXVsIHN1Ym1pdHMgdGhlIGZpbmFsIHBhdGNoIG9mIHRoaXMgZmVhdHVyZSBhbmQNCj4gdGhlDQo+
ID4gbWFpbGluZyBsaXN0IHJldmlldyBpcyBjb21wbGV0ZSwgaSBjYW4gc2VuZCB0byB5b3UgZnVs
bCBwdWxsDQo+IHJlcXVlc3QNCj4gPiB3aXRoIGV2ZXJ5dGhpbmcgaW5jbHVkZWQgLi4gDQo+ID4g
DQo+ID4gb3B0aW9uIDIpIHlvdSB0byBhcHBseSBkaXJlY3RseSB0byBuZXQtbmV4dCBib3RoIHBh
dGNoc2V0cw0KPiA+IGluZGl2aWR1YWxseS4gKHRoZSBub3JtYWwgcHJvY2VzcykNCj4gPiANCj4g
PiBQbGVhc2UgbGV0IG1lIGtub3cgd2hhdCB3b3JrcyBiZXR0ZXIgZm9yIHlvdS4NCj4gPiANCj4g
PiBQZXJzb25hbGx5IEkgcHJlZmVyIG9wdGlvbiAxKSBzbyB3ZSB3b24ndCBlbmR1cCBzdHVjayB3
aXRoIG9ubHkgb25lDQo+ID4gaGFsZiBvZiB0aGUgY29ubmVjdGlvbiB0cmFja2luZyBzZXJpZXMg
aWYgdGhlIHJldmlldyBvZiB0aGUgMm5kDQo+IHBhcnQNCj4gPiBkb2Vzbid0IGdvIGFzIHBsYW5u
ZWQuDQo+IA0KPiBJJ20gZmluZSB3aXRoIG9wdGlvbiAjMSBhbmQgd2lsbCB3YWl0IGZvciB0aGF0
IHRvIGFwcGVhciBpbiBvbmUgb2YNCg0KQ29vbCwgd2lsbCBkbyBvcHRpb24gIzEgdGhlbi4uIA0K
DQo+IHlvdXIgZnV0dXJlIHB1bGwgcmVxdWVzdHMuICBJdCBsb29rcyBsaWtlIHBhdGNoICMxIGdv
dCBzb21lIGZlZWRiYWNrDQo+IGFuZCBuZWVkcyBzb21lIG1vZGlmaWNhdGlvbnMgZmlyc3QgdGhv
dWdoLg0KPiANCg0KWWVzLCBQYXVsIHdpbGwgc2VuZCBWMyBhbmQgSSB3aWxsIHdhaXQgZm9yIGFs
bCB0aGUgbmVlZGVkIEFDS3MgYW5kDQpSZXZpZXdzLCBmb3IgdGhpcyBwYXRjaHNldCBhbmQgdGhl
IG9uZXMgdG8gZm9sbG93Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
