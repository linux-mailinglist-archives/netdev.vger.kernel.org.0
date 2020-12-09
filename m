Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80642D499D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387538AbgLIS4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:56:39 -0500
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:40961
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387457AbgLIS4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 13:56:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nd57WO60sLWcdh2yqkpcObaQE9gIlqp6CLv+Q2PZU6E8egjLNYqtfqO7OwvPJIz/i4KaHOCS7Y88FKcCrXdz8GfntpukXgBY8Y+gY81tqlyJkm8junfYMz19yjtnLkpazreNoBWdEnyG/yf9uYWs11jPE5Dap+kjiXslqismrlTyH5+NoVYV7vxVhQNPQFuu37Z2zoqG8XDwI+zMZvBxvz+KWjgrVdJaWu6tBhS+TAThoExzxvXfR1J5l2sb2OapPRK4JsUpeCQyp77rdmYrnDA6xAoNDdFMdVxzTWaD0kz6nxm7/ZFXRNXeptIP/CYQPQgk9gNIm8QnvYPyVUwRnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvOIxUw80IL5FOvmhRKO1JIZpUOEtLilCrajRZj2RBI=;
 b=LzT9lEKm4l+uACijyY6feNIP7XinSUULtBnS0vQ/zSyeSxZow/KkFCejTSWNlDTvDClkZGy0WVlqbk2IrkIKdfACeUw0DJrtvnDKB/Pb1FP5/Q4Qkz+xE2MPvE0GtykAIWD/XrpbQmAr0GE8CQmjokrwE214zzSBAT8IrB/d44ZM4Vau5hHBoPV+52X/NSHQWnCwVZxCNFlj3ZgqBS3YSzKCq1UPTrwSKFL07/veS/Hth+xATBraM/n9q5peSrV4+5KXyTetebDI1772+UAbRwRRcWS11OyAuG0uI2/IxqkYaGweTrDcd/hKz8WDJX/tv2Kzn1TdGOBZLn/y65+hOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvOIxUw80IL5FOvmhRKO1JIZpUOEtLilCrajRZj2RBI=;
 b=Ac9wrJedKMCoXjRgFpAebmuyqEUUgZPtCzw/X293g6PC5j+KlM1wJQ1tYDgTr+XaWXqzEivJ2sVdKsW+eNtkSZSUMK3/FHdm7TuK4Tj2DajEkwy1E6Vk/F6EZgbnUakiibBnB2S/k/tZTXJJttJR6upKqGNp1QAN2wXdZ6HETrE=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM7PR04MB6775.eurprd04.prod.outlook.com (2603:10a6:20b:102::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 18:55:47 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f022:b0a2:ee2b:2ddc%6]) with mapi id 15.20.3654.014; Wed, 9 Dec 2020
 18:55:47 +0000
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
Thread-Index: AQHWyXtSU15lz2QhZ0iXI1B/qYMSiKnlgUwAgAfQMQCAABdiMIABcACAgABKVyA=
Date:   Wed, 9 Dec 2020 18:55:47 +0000
Message-ID: <AM6PR04MB3976721D38D6EAE91E6F3F37ECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
 <20201203135039.31474-2-patrick.havelange@essensium.com>
 <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <e488ed95-3672-fdcb-d678-fdd4eb9a8b4b@essensium.com>
 <AM6PR04MB3976F905489C0CB2ECD1A6FAECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <8c28d03a-8831-650c-cf17-9a744d084479@essensium.com>
In-Reply-To: <8c28d03a-8831-650c-cf17-9a744d084479@essensium.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: essensium.com; dkim=none (message not signed)
 header.d=none;essensium.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [81.196.28.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 85a847ad-7a04-45af-b388-08d89c740a16
x-ms-traffictypediagnostic: AM7PR04MB6775:
x-microsoft-antispam-prvs: <AM7PR04MB67750FA46179ECAB571C1F64ECCC0@AM7PR04MB6775.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ogwD4TpZ4Je0iwVix7lBZWPKDz0VBOnTxdEQs47QE6O3JH6AT6FeHDjsv9QQoKCt02xCoA50W51+KBqIlZdM5lxohM0+byZOW7LH2vbX0Jaq4GwMELYzs06opuxFkwIzZOOElGAYq+RJa0t/YzMe+iv6Ruk+a3GmXXaVUTke306NRpjMtbTnTaG0xdHND/5Fd89ycQURHDuot5SplIV5o+iLE8oZ7POKmPT/Bvlnq5optHXgID7wFS7rpWmrkN29O5GQC2nRExkhe5tSXl98vg3lNYoBs85Ip1q7LtjGcS5iTTPMfsOsldIkPh/9sRYTLCoMUf6in7QpZPZJ/TzrFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(66446008)(8936002)(9686003)(66476007)(86362001)(33656002)(66556008)(5660300002)(8676002)(2906002)(66946007)(64756008)(55016002)(71200400001)(52536014)(76116006)(83380400001)(110136005)(508600001)(186003)(26005)(44832011)(6506007)(53546011)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?V1NHM1pubE9oYmgzR0hFODdnRzc3d2pzZGFmNE9Rc2xORG5SNzVuWlI4QTdp?=
 =?utf-8?B?RGJFZ1VqQkRhSWhzUUd0SVZkMm4xa0plWHhXNkdMdnNYcHRVSUt4dFpSSlpE?=
 =?utf-8?B?eTdXdGVPRkl0N1dsK0pqYjE4NGdBN292YVlaV2p5QTlRb2FXRVU0ZnBKclVK?=
 =?utf-8?B?d0hhMFRIbk5udGMxcitSeTk3Ris1ald1TmtXcWlEM3BhT1hyVzlaRTRkQXdp?=
 =?utf-8?B?WGZ6Vk04YjhPV21URWJML2Z2NUZxMmwxTFUvZUY3K2g1NE0wQ1kydXlzVlJF?=
 =?utf-8?B?Sm9YOFpNdVFISzNlRE1KZjdscXpHc0s4SU93UmJVMkRWQVFmRHZLYnZTenho?=
 =?utf-8?B?cU5DNkFLM1BsZlpxK0lCZS9WSVFGZXh2NXlMYUpFZjBjaVV3djJ3MXA2U2o5?=
 =?utf-8?B?aWlCYmRwVWZDTU5MaG5RblZxK3p0amY3T2lkdk11dnFwM095c1NEYUlpNzdN?=
 =?utf-8?B?cHU1a3crVVJwbDhNdUs3L2NJUm1HTmUvdkRyQmNZQ3lDS0tab3pXeFIzdnE3?=
 =?utf-8?B?MnM3Y3MvTzlQQkpid01Ya0xRZnRaSFZiMzlXTUxtdFJYVTZ1NGRPSWlaTTJY?=
 =?utf-8?B?b0dyczdnNWVlKzdYbVVTWjJpbFB6eW5LWjVoQWxjVGkyakVqemJuU0ZYTFZ0?=
 =?utf-8?B?UldWTy9vTE9KeWprYVh5am95SFpzVE13eVFLTVVaaER3N0V2VG1sdklsR05F?=
 =?utf-8?B?cXhnUEpPUVR5RlV3cmtOUnRvTTBMNEJQYTI5VVhUT1JNSi9YdFUrMG1CRU5h?=
 =?utf-8?B?UGtEbnlzekFubVc3cDQ2R3lVZVN1dTNMeFhYMjcrV1djb0dnSWdwM2pVbCtG?=
 =?utf-8?B?bTZEeTV1SHdGMjY5dm81QU1sUlZaU1JKY2c4ZGZOUUlVRkVabTgxeW1JZWRJ?=
 =?utf-8?B?ZWxrVFZjK2d5LzJadXhjSnNvbEszUUVoQ1FRMHVrbDk4MGU4YmNkU2hQZEpz?=
 =?utf-8?B?SXlrYmhYMmdRMmkvby9OQmY3N0N0bFJ6dWNPSE5Ja3M1SDA4emJCSDdQaVkz?=
 =?utf-8?B?blFaN0Z1NjJSTHJmUWdzVjh2MjIyMjJBa1ZvY0VsV0FBZHVYNzZ2M1pSVVdq?=
 =?utf-8?B?SXRIQlJyb1JCNCtYWDY5Ly9obTZpT2FQaGFqWUR0VWdDVFYzUG4xMmcxeFph?=
 =?utf-8?B?bndhOGpqT1lJUXhKQXJmRDhtdithRVFTZXk0MUdZeWdKNHNjK2wvS1ZNTWpE?=
 =?utf-8?B?bWl3YUZDTFBzNmgxNFN2QXpmcEVCbFBWeFhiQjE4U3JUR3hQUmQvQjdiWldk?=
 =?utf-8?B?UTRORWVKOHNHeHppZEl2dmQ4MG95bHdnWnRlWXdhWXY1Rlp4NGZKTDFYL2lG?=
 =?utf-8?Q?zfDHDMlUDer5o=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85a847ad-7a04-45af-b388-08d89c740a16
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 18:55:47.1684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yc8k667gPOCrPTZGVgBOyvMQAyoZ/jFupmU2cbwNvQIkc4IYf1Ry/4juj95jGs8UpZYi5Qt6YwZRE2deZzb7cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6775
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYXRyaWNrIEhhdmVsYW5nZSA8
cGF0cmljay5oYXZlbGFuZ2VAZXNzZW5zaXVtLmNvbT4NCj4gU2VudDogMDkgRGVjZW1iZXIgMjAy
MCAxNjoxNw0KPiBUbzogTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBueHAuY29tPjsgRGF2
aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgMS80XSBuZXQ6IGZyZWVz
Y2FsZS9mbWFuOiBTcGxpdCB0aGUgbWFpbiByZXNvdXJjZQ0KPiByZWdpb24gcmVzZXJ2YXRpb24N
Cj4gDQo+ID4+PiBhcmVhLiBJJ20gYXNzdW1pbmcgdGhpcyBpcyB0aGUgcHJvYmxlbSB5b3UgYXJl
IHRyeWluZyB0byBhZGRyZXNzIGhlcmUsDQo+ID4+PiBiZXNpZGVzIHRoZSBzdGFjayBjb3JydXB0
aW9uIGlzc3VlLg0KPiA+Pg0KPiA+PiBZZXMgZXhhY3RseS4NCj4gPj4gSSBkaWQgbm90IGFkZCB0
aGlzIGJlaGF2aW91ciAoaGF2aW5nIGEgbWFpbiByZWdpb24gYW5kIHN1YmRyaXZlcnMgdXNpbmcN
Cj4gPj4gc3VicmVnaW9ucyksIEknbSBqdXN0IHRyeWluZyB0byBjb3JyZWN0IHdoYXQgaXMgYWxy
ZWFkeSB0aGVyZS4NCj4gPj4gRm9yIGV4YW1wbGU6IHRoaXMgaXMgc29tZSBjb250ZW50IG9mIC9w
cm9jL2lvbWVtIGZvciBvbmUgYm9hcmQgSSdtDQo+ID4+IHdvcmtpbmcgd2l0aCwgd2l0aCB0aGUg
Y3VycmVudCBleGlzdGluZyBjb2RlOg0KPiA+PiBmZmU0MDAwMDAtZmZlNGZkZmZmIDogZm1hbg0K
PiA+PiAgICAgZmZlNGUwMDAwLWZmZTRlMGZmZiA6IG1hYw0KPiA+PiAgICAgZmZlNGUyMDAwLWZm
ZTRlMmZmZiA6IG1hYw0KPiA+PiAgICAgZmZlNGU0MDAwLWZmZTRlNGZmZiA6IG1hYw0KPiA+PiAg
ICAgZmZlNGU2MDAwLWZmZTRlNmZmZiA6IG1hYw0KPiA+PiAgICAgZmZlNGU4MDAwLWZmZTRlOGZm
ZiA6IG1hYw0KPiA+Pg0KPiA+PiBhbmQgbm93IHdpdGggbXkgcGF0Y2hlczoNCj4gPj4gZmZlNDAw
MDAwLWZmZTRmZGZmZiA6IC9zb2NAZmZlMDAwMDAwL2ZtYW5ANDAwMDAwDQo+ID4+ICAgICBmZmU0
MDAwMDAtZmZlNDgwZmZmIDogZm1hbg0KPiA+PiAgICAgZmZlNDg4MDAwLWZmZTQ4OGZmZiA6IGZt
YW4tcG9ydA0KPiA+PiAgICAgZmZlNDg5MDAwLWZmZTQ4OWZmZiA6IGZtYW4tcG9ydA0KPiA+PiAg
ICAgZmZlNDhhMDAwLWZmZTQ4YWZmZiA6IGZtYW4tcG9ydA0KPiA+PiAgICAgZmZlNDhiMDAwLWZm
ZTQ4YmZmZiA6IGZtYW4tcG9ydA0KPiA+PiAgICAgZmZlNDhjMDAwLWZmZTQ4Y2ZmZiA6IGZtYW4t
cG9ydA0KPiA+PiAgICAgZmZlNGE4MDAwLWZmZTRhOGZmZiA6IGZtYW4tcG9ydA0KPiA+PiAgICAg
ZmZlNGE5MDAwLWZmZTRhOWZmZiA6IGZtYW4tcG9ydA0KPiA+PiAgICAgZmZlNGFhMDAwLWZmZTRh
YWZmZiA6IGZtYW4tcG9ydA0KPiA+PiAgICAgZmZlNGFiMDAwLWZmZTRhYmZmZiA6IGZtYW4tcG9y
dA0KPiA+PiAgICAgZmZlNGFjMDAwLWZmZTRhY2ZmZiA6IGZtYW4tcG9ydA0KPiA+PiAgICAgZmZl
NGMwMDAwLWZmZTRkZmZmZiA6IGZtYW4NCj4gPj4gICAgIGZmZTRlMDAwMC1mZmU0ZTBmZmYgOiBt
YWMNCj4gPj4gICAgIGZmZTRlMjAwMC1mZmU0ZTJmZmYgOiBtYWMNCj4gPj4gICAgIGZmZTRlNDAw
MC1mZmU0ZTRmZmYgOiBtYWMNCj4gPj4gICAgIGZmZTRlNjAwMC1mZmU0ZTZmZmYgOiBtYWMNCj4g
Pj4gICAgIGZmZTRlODAwMC1mZmU0ZThmZmYgOiBtYWMNCj4gPj4NCj4gPj4+IFdoaWxlIGZvciB0
aGUgbGF0dGVyIEkgdGhpbmsgd2UgY2FuDQo+ID4+PiBwdXQgdG9nZXRoZXIgYSBxdWljayBmaXgs
IGZvciB0aGUgZm9ybWVyIEknZCBsaWtlIHRvIHRha2UgYSBiaXQgb2YNCj4gdGltZQ0KPiA+Pj4g
dG8gc2VsZWN0IHRoZSBiZXN0IGZpeCwgaWYgb25lIGlzIHJlYWxseSBuZWVkZWQuIFNvLCBwbGVh
c2UsIGxldCdzDQo+IHNwbGl0DQo+ID4+PiB0aGUgdHdvIHByb2JsZW1zIGFuZCBmaXJzdCBhZGRy
ZXNzIHRoZSBpbmNvcnJlY3Qgc3RhY2sgbWVtb3J5IHVzZS4NCj4gPj4NCj4gPj4gSSBoYXZlIG5v
IGlkZWEgaG93IHlvdSBjYW4gZml4IGl0IHdpdGhvdXQgYSAobW9yZSBjb3JyZWN0IHRoaXMgdGlt
ZSkNCj4gPj4gZHVtbXkgcmVnaW9uIHBhc3NlZCBhcyBwYXJhbWV0ZXIgKGFuZCB5b3UgZG9uJ3Qg
d2FudCB0byB1c2UgdGhlIGZpcnN0DQo+ID4+IHBhdGNoKS4gQnV0IHRoZW4gaXQgd2lsbCBiZSB1
c2VsZXNzIHRvIGRvIHRoZSBjYWxsIGFueXdheSwgYXMgaXQgd29uJ3QNCj4gPj4gZG8gYW55IHBy
b3BlciB2ZXJpZmljYXRpb24gYXQgYWxsLCBzbyBpdCBjb3VsZCBhbHNvIGJlIHJlbW92ZWQgZW50
aXJlbHksDQo+ID4+IHdoaWNoIGJlZ3MgdGhlIHF1ZXN0aW9uLCB3aHkgZG8gaXQgYXQgYWxsIGlu
IHRoZSBmaXJzdCBwbGFjZSAodGhlDQo+ID4+IGRldm1fcmVxdWVzdF9tZW1fcmVnaW9uKS4NCj4g
Pj4NCj4gPj4gSSdtIG5vdCBhbiBleHBlcnQgaW4gdGhhdCBwYXJ0IG9mIHRoZSBjb2RlIHNvIGZl
ZWwgZnJlZSB0byBjb3JyZWN0IG1lDQo+IGlmDQo+ID4+IEkgbWlzc2VkIHNvbWV0aGluZy4NCj4g
Pj4NCj4gPj4gQlIsDQo+ID4+DQo+ID4+IFBhdHJpY2sgSC4NCj4gPg0KPiA+IEhpLCBQYXRyaWNr
LA0KPiA+DQo+ID4gdGhlIERQQUEgZW50aXRpZXMgYXJlIGRlc2NyaWJlZCBpbiB0aGUgZGV2aWNl
IHRyZWUuIEFkZGluZyBzb21lDQo+IGhhcmRjb2RpbmcgaW4NCj4gPiB0aGUgZHJpdmVyIGlzIG5v
dCByZWFsbHkgdGhlIHNvbHV0aW9uIGZvciB0aGlzIHByb2JsZW0uIEFuZCBJJ20gbm90IHN1cmUN
Cj4gd2UgaGF2ZQ0KPiANCj4gSSdtIG5vdCBzZWVpbmcgYW55IHByb2JsZW0gaGVyZSwgdGhlIG9m
ZnNldHMgdXNlZCBieSB0aGUgZm1hbiBkcml2ZXINCj4gd2VyZSBhbHJlYWR5IHRoZXJlLCBJIGp1
c3QgcmVvcmdhbml6ZWQgdGhlbSBpbiAyIGJsb2Nrcy4NCj4gDQo+ID4gYSBjbGVhciBwcm9ibGVt
IHN0YXRlbWVudCB0byBzdGFydCB3aXRoLiBDYW4geW91IGhlbHAgbWUgb24gdGhhdCBwYXJ0Pw0K
PiANCj4gLSBUaGUgY3VycmVudCBjYWxsIHRvIF9fZGV2bV9yZXF1ZXN0X3JlZ2lvbiBpbiBmbWFu
X3BvcnQuYyBpcyBub3QgY29ycmVjdC4NCj4gDQo+IE9uZSB3YXkgdG8gZml4IHRoaXMgaXMgdG8g
dXNlIGRldm1fcmVxdWVzdF9tZW1fcmVnaW9uLCBob3dldmVyIHRoaXMNCj4gcmVxdWlyZXMgdGhh
dCB0aGUgbWFpbiBmbWFuIHdvdWxkIG5vdCBiZSByZXNlcnZpbmcgdGhlIHdob2xlIHJlZ2lvbi4N
Cj4gVGhpcyBsZWFkcyB0byB0aGUgc2Vjb25kIHByb2JsZW06DQo+IC0gTWFrZSBzdXJlIHRoZSBt
YWluIGZtYW4gZHJpdmVyIGlzIG5vdCByZXNlcnZpbmcgdGhlIHdob2xlIHJlZ2lvbi4NCj4gDQo+
IElzIHRoYXQgY2xlYXJlciBsaWtlIHRoaXMgPw0KPiANCj4gUGF0cmljayBILg0KDQpUaGUgb3Zl
cmxhcHBpbmcgSU8gYXJlYXMgcmVzdWx0IGZyb20gdGhlIGRldmljZSB0cmVlIGRlc2NyaXB0aW9u
LCB0aGF0IGluIHR1cm4NCm1pbWljcyB0aGUgSFcgZGVzY3JpcHRpb24gaW4gdGhlIG1hbnVhbC4g
SWYgd2UgcmVhbGx5IHdhbnQgdG8gcmVtb3ZlIHRoZSBuZXN0aW5nLA0Kd2Ugc2hvdWxkIGNoYW5n
ZSB0aGUgZGV2aWNlIHRyZWVzLCBub3QgdGhlIGRyaXZlcnMuIElmIHdlIHdhbnQgdG8gaGFjayBp
dCwNCmluc3RlYWQgb2Ygc3BsaXR0aW5nIGlvcmVtYXBzLCB3ZSBjYW4gcmVzZXJ2ZSA0IGtCIGlu
IHRoZSBGTWFuIGRyaXZlciwNCmFuZCBrZWVwIHRoZSBpb3JlbWFwIGFzIGl0IGlzIG5vdywgd2l0
aCB0aGUgYmVuZWZpdCBvZiBsZXNzIGNvZGUgY2h1cm4uDQpJbiB0aGUgZW5kLCB3aGF0IHRoZSBy
ZXNlcnZhdGlvbiBpcyB0cnlpbmcgdG8gYWNoaWV2ZSBpcyB0byBtYWtlIHN1cmUgdGhlcmUNCmlz
IGEgc2luZ2xlIGRyaXZlciBjb250cm9sbGluZyBhIGNlcnRhaW4gcGVyaXBlaGVyYWwsIGFuZCB0
aGlzIGJhc2ljDQpyZXF1aXJlbWVudCB3b3VsZCBiZSBhZGRyZXNzZWQgYnkgdGhhdCBjaGFuZ2Ug
cGx1cyBkZXZtX29mX2lvbWFwKCkgZm9yIGNoaWxkDQpkZXZpY2VzIChwb3J0cywgTUFDcykuDQoN
Ck1hZGFsaW4NCg==
