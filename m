Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6350627015B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgIRPvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:51:52 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:59700 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgIRPvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 11:51:43 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64d78b0000>; Fri, 18 Sep 2020 23:51:39 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 15:51:39 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 15:51:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKAn+IegEJ7jxdOwdtUxhSr0GK7XisUJ0SkQi9TqjeGeg/BDpFfZtWANjJNka+hkDfPyFigAbbCg/PDJ4PhS6cx/3ZkQKBOIm74rnhKiDjkfSh5ViAxw6Bsr22se/UTGPs3V9caJJfLD+V5a0N7Npbq6U3GT/0OXT0B+d4Gt3h0pZ+XOIfeaEVF+0bF6264lesM5lzXIe/nXmx72bRUy3kzYOqIGLSZMjZSCvR69q4vu0gOmks0Y1+SJO4v6HEt6dGRkyj6IzCZ0pivsRwqDHBydxC468gR+JvFkJ3JW1bQ7AvPrrHcbGen7SfZTmYi8cUbp4UqTEsJyrScbHXrb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElgrxkD8juBE3cVVAjreEY/REOXjEcinCO/q9tDoxhs=;
 b=I+/rSJxL7qiW2GW6nEMKI56z4rLFzQdfoj8qfr4MP75tAgH6SybPxgmnP0tHfCVRsbfvj21aFK6u7yf32x62J2UfivrFNtcFbmIb80TIdiApohkwwfioSi7rLrjKFzENLAeToHgDm04sOp5kgkjuOONGxy3G8CBVXR7zLVxLZM8cuXrtvAt4gCLv/JP1ilkGZ4exlpjrJ0pQ6/JoT95JMiLMZd0+YxM43CKRLrs9VhhgsOcpJPf30cfLDR044HWTTEFe+g4b6ZhhHKECBg+GdQNMJQiH9yl3ACkU+jqmJTYqTAjhu11vh+yqmSP1UqFAMfld7UQBkl9uUO7kruH5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 18 Sep
 2020 15:51:37 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.027; Fri, 18 Sep 2020
 15:51:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
Thread-Topic: [PATCH net-next v2 8/8] netdevsim: Add support for add and
 delete PCI SF port
Thread-Index: AQHWjRbiZXOkBXXnYkS4YkdYcsgPfqltSM4AgABzn/CAAAO2gIAADdQQgAC3PQCAAAcxIA==
Date:   Fri, 18 Sep 2020 15:51:36 +0000
Message-ID: <BY5PR12MB432259730B3822B74857A105DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
 <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
 <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <5cd529c8-cd55-b270-7f3c-227ef957b6e8@gmail.com>
In-Reply-To: <5cd529c8-cd55-b270-7f3c-227ef957b6e8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 588fc410-e745-445a-4969-08d85beab9ea
x-ms-traffictypediagnostic: BY5PR12MB3843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB384395B5F32B157A69FDA158DC3F0@BY5PR12MB3843.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WN+yRAOgro95pPuRHLWRic6GmP/heEomWb0mKVS35RvuGjULzL+QvOGikNR5METD7mo00flf8iBNpD4UXUkSXRaBFk2dc7caGHRImKsomlNKhywMaf1Gg3WNkIvac3Tw4Gvr1rntB9BFClMqt1M7luJC5sotxsSH06T30mCl0zG9JjrgPzuJcrsaFsEj6dnH9CVcZEIXQQrZ4tSAx/UQAaQMRl9tbQMqXlyKRtRGNMqsNu9ni4doruXskVcOygRm2MJjgkxErhQZquZmfdN1T7b8znVdAwkvyUKT2uPatlJ+dpynE4ido3VkPkER5ygV6M4OO58rw+cMlmAUyEKNvpihkP1N4lDa/gcmUCuB4QzKF1CkDmwIRF3M4+kMK1icHOgYxAZzAyHy8PeOj9DNCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(64756008)(66446008)(7696005)(86362001)(4326008)(8676002)(186003)(33656002)(9686003)(966005)(316002)(478600001)(26005)(110136005)(6506007)(5660300002)(53546011)(55016002)(66556008)(107886003)(66476007)(66946007)(55236004)(8936002)(2906002)(76116006)(52536014)(71200400001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /7hnr48qjRnZvgMYFQ2K8iX2leT3GwFDqYRtYlNrwTDz9bSPT0Kru8DdlCmnhoVPPfAVkf5erK1Me+CjCBqXfBSqd5k7lvF0QhWkwtFdaFK1TQsXjLhm8MCeciLjAaWFWDVHxQ8Omi/i1HbDJmrYzPh8lGJd2GWfWduJDttHjYqNG+mybq2PHNMpjjrS6JEhld21+guMafjFI/xt39O1Miff3qMNGsXCtBv0I30/ZJM4rku6UL4A7yQle4nxhRArB4ACfUs3OoLmXok98fSisDbQ7nv942sDakOp6r1Mg0hydbsLWu0uycrBgtYEHq+ECcp49VmjAnf/UsuUz3otG/4Q/BTCChMTfrs9+52kpJPtDbgxzPo06sA7BQB6cRnjBGHmaJeQLGLbR8l91lMehtn0HxejEfNBfO7fpzFSNHLvWc7YKNU99as5gISoHKv1WUts2xPUukLwlY46PP/OPDvLE+HOUKKw6pK+rgMmduGaMbpsPpQf/8aO/t+Q7X8RRtVol0MJxB04uTSWG0R65DGalNXZCLRp5sI28iLbDwDQkqsdKiolthIN9mVzKflB1RCKYuYO/5ranBhTIPNYYo9Uo1mZxM2MxFNrt1VO6mDL+K8M8qAFwLgTO8BPeratPM35Ri7t0leRlCq5lpJKww==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588fc410-e745-445a-4969-08d85beab9ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 15:51:37.0657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nICT7Rb5gFcJh3S/EI1yOcAqaYB73ZTxLMehkSqcHbOFI7ywGel+GNToQam2Hu0uKW5vqRbN0oKJBBtG/HuRdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3843
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600444299; bh=ElgrxkD8juBE3cVVAjreEY/REOXjEcinCO/q9tDoxhs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=loaVA6z9YN//JUBC/b6so1HYEmx8LZwTj/OdqaiGh9SoGTLnm1TRUNcHNxIc7i+eC
         GGzKV6wnIsNc60lRrxd2KGk0/Yb9WJOgmEcjmsMDvL3ZbK46qThYJwmhFKNQ6jc77h
         JODTUKhX8AAHh+ry7iClb205wOzEZwFN/NUKPKlCYxDvTbV6EGUG+Yilf9kSzP3bts
         inNbyI2uZE4raxSW8os6YNdhh7F4ER7PU6cpDIVENzQovaqr8gIINsShxGDLAfziIG
         mfh0dPxavKfqK5WB7fs6gFGa7IGfaNRTyS3LQPrI50LJAkCyUypKz7Oi4hT0JGd49K
         Z5EJzLieCfARA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRGF2aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIFNlcHRlbWJlciAxOCwgMjAyMCA4OjU0IFBNDQo+IA0KPiBPbiA5LzE3LzIwIDEwOjQxIFBN
LCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gSGkgRGF2aWQsDQo+ID4NCj4gPj4gRnJvbTogRGF2
aWQgQWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIFNlcHRlbWJl
ciAxOCwgMjAyMCA5OjA4IEFNDQo+ID4+DQo+ID4+IE9uIDkvMTcvMjAgOToyOSBQTSwgUGFyYXYg
UGFuZGl0IHdyb3RlOg0KPiA+Pj4+PiBFeGFtcGxlczoNCj4gPj4+Pj4NCj4gPj4+Pj4gQ3JlYXRl
IGEgUENJIFBGIGFuZCBQQ0kgU0YgcG9ydC4NCj4gPj4+Pj4gJCBkZXZsaW5rIHBvcnQgYWRkIG5l
dGRldnNpbS9uZXRkZXZzaW0xMC8xMCBmbGF2b3VyIHBjaXBmIHBmbnVtIDANCj4gPj4+Pj4gJCBk
ZXZsaW5rIHBvcnQgYWRkIG5ldGRldnNpbS9uZXRkZXZzaW0xMC8xMSBmbGF2b3VyIHBjaXNmIHBm
bnVtIDANCj4gPj4+Pj4gc2ZudW0NCj4gPj4+Pj4gNDQgJCBkZXZsaW5rIHBvcnQgc2hvdyBuZXRk
ZXZzaW0vbmV0ZGV2c2ltMTAvMTENCj4gPj4+Pj4gbmV0ZGV2c2ltL25ldGRldnNpbTEwLzExOiB0
eXBlIGV0aCBuZXRkZXYgZW5pMTBucGYwc2Y0NCBmbGF2b3VyDQo+ID4+Pj4+IHBjaXNmDQo+ID4+
Pj4gY29udHJvbGxlciAwIHBmbnVtIDAgc2ZudW0gNDQgZXh0ZXJuYWwgdHJ1ZSBzcGxpdHRhYmxl
IGZhbHNlDQo+ID4+Pj4+ICAgZnVuY3Rpb246DQo+ID4+Pj4+ICAgICBod19hZGRyIDAwOjAwOjAw
OjAwOjAwOjAwIHN0YXRlIGluYWN0aXZlDQo+ID4+Pj4+DQo+ID4+Pj4+ICQgZGV2bGluayBwb3J0
IGZ1bmN0aW9uIHNldCBuZXRkZXZzaW0vbmV0ZGV2c2ltMTAvMTEgaHdfYWRkcg0KPiA+Pj4+PiAw
MDoxMToyMjozMzo0NDo1NSBzdGF0ZSBhY3RpdmUNCj4gPj4+Pj4NCj4gPj4+Pj4gJCBkZXZsaW5r
IHBvcnQgc2hvdyBuZXRkZXZzaW0vbmV0ZGV2c2ltMTAvMTEgLWpwIHsNCj4gPj4+Pj4gICAgICJw
b3J0Ijogew0KPiA+Pj4+PiAgICAgICAgICJuZXRkZXZzaW0vbmV0ZGV2c2ltMTAvMTEiOiB7DQo+
ID4+Pj4+ICAgICAgICAgICAgICJ0eXBlIjogImV0aCIsDQo+ID4+Pj4+ICAgICAgICAgICAgICJu
ZXRkZXYiOiAiZW5pMTBucGYwc2Y0NCIsDQo+ID4+Pj4NCj4gPj4+PiBJIGNvdWxkIGJlIG1pc3Np
bmcgc29tZXRoaW5nLCBidXQgaXQgZG9lcyBub3Qgc2VlbSBsaWtlIHRoaXMgcGF0Y2gNCj4gPj4+
PiBjcmVhdGVzIHRoZSBuZXRkZXZpY2UgZm9yIHRoZSBzdWJmdW5jdGlvbi4NCj4gPj4+Pg0KPiA+
Pj4gVGhlIHNmIHBvcnQgY3JlYXRlZCBoZXJlIGlzIHRoZSBlc3dpdGNoIHBvcnQgd2l0aCBhIHZh
bGlkIHN3aXRjaCBpZA0KPiA+Pj4gc2ltaWxhciB0byBQRg0KPiA+PiBhbmQgcGh5c2ljYWwgcG9y
dC4NCj4gPj4+IFNvIHRoZSBuZXRkZXYgY3JlYXRlZCBpcyB0aGUgcmVwcmVzZW50b3IgbmV0ZGV2
aWNlLg0KPiA+Pj4gSXQgaXMgY3JlYXRlZCB1bmlmb3JtbHkgZm9yIHN1YmZ1bmN0aW9uIGFuZCBw
ZiBwb3J0IGZsYXZvdXJzLg0KPiA+Pg0KPiA+PiBUbyBiZSBjbGVhcjogSWYgSSBydW4gdGhlIGRl
dmxpbmsgY29tbWFuZHMgdG8gY3JlYXRlIGEgc3ViLWZ1bmN0aW9uLA0KPiA+PiBgaXAgbGluayBz
aG93YCBzaG91bGQgbGlzdCBhIG5ldF9kZXZpY2UgdGhhdCBjb3JyZXNwb25kcyB0byB0aGUgc3Vi
LQ0KPiBmdW5jdGlvbj8NCj4gPg0KPiA+IEluIHRoaXMgc2VyaWVzIG9ubHkgcmVwcmVzZW50b3Ig
bmV0ZGV2aWNlIGNvcnJlc3BvbmRzIHRvIHN1Yi1mdW5jdGlvbiB3aWxsDQo+IGJlIHZpc2libGUg
aW4gaXAgbGluayBzaG93LCBpLmUuIGVuaTEwbnBmMHNmNDQuDQo+ID4NCj4gPiBOZXRkZXZzaW0g
aXMgb25seSBzaW11bGF0aW5nIHRoZSBlc3dpdGNoIHNpZGUgb3IgY29udHJvbCBwYXRoIGF0IHBy
ZXNlbnQgZm9yDQo+IHBmL3ZmL3NmIHBvcnRzLg0KPiA+IFNvIG90aGVyIGVuZCBvZiB0aGlzIHBv
cnQgKG5ldGRldmljZS9yZG1hIGRldmljZS92ZHBhIGRldmljZSkgYXJlIG5vdCB5ZXQNCj4gY3Jl
YXRlZC4NCj4gPg0KPiA+IFN1YmZ1bmN0aW9uIHdpbGwgYmUgYW5jaG9yZWQgb24gdmlydGJ1cyBk
ZXNjcmliZWQgaW4gUkZDIFsxXSwgd2hpY2ggaXMgbm90DQo+IHlldCBpbi1rZXJuZWwgeWV0Lg0K
PiA+IEdyZXAgZm9yICJldmVyeSBTRiBhIGRldmljZSBpcyBjcmVhdGVkIG9uIHZpcnRidXMiIHRv
IGp1bXAgdG8gdGhpcyBwYXJ0IG9mIHRoZQ0KPiBsb25nIFJGQy4NCj4gPg0KPiA+IFsxXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMDA1MTkwOTIyNTguR0Y0NjU1QG5hbm9wc3lj
aG8vDQo+ID4NCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHJlZmVyZW5jZS4gSSBoYXZlIHNlZW4gdGhh
dC4gSSBhbSBpbnRlcmVzdGVkIGluIHRoaXMgaWRlYSBvZg0KPiBjcmVhdGluZyBuZXRkZXZzIGZv
ciAnc2xpY2VzJyBvZiBhbiBhc2ljIG9yIG5pYywgYnV0IGl0IGlzIG5vdCBjbGVhciB0byBtZSBo
b3cgaXQNCj4gY29ubmVjdHMgZW5kIHRvIGVuZC4gV2lsbCB5b3UgYmUgYWJsZSB0byBjcmVhdGUg
YSBzdWItZnVuY3Rpb24gYmFzZWQNCj4gbmV0ZGV2aWNlLCBhc3NpZ24gaXQgbGltaXRlZCByZXNv
dXJjZXMgZnJvbSB0aGUgbmljIGFuZCB0aGVuIGFzc2lnbiB0aGF0DQo+IG5ldGRldmljZSB0byBh
IGNvbnRhaW5lciBmb3IgZXhhbXBsZT8NClllcC4gWW91IGRlc2NyaWJlZCBpcyBwcmVjaXNlbHkg
d2VsbC4NClRoaXMgc2hvcnQgc2VyaWVzIGNyZWF0ZXMgZXN3aXRjaCByZXByZXNlbnRvciBmb3Ig
dGhlIG1vbWVudC4NCk9uY2UgdmlydGJ1cyBpcyBpbl9rZXJuZWwsIHdpbGwgZXh0ZW5kIHRvIGNy
ZWF0ZSBhY3R1YWwgbmV0ZGV2aWNlIG9mIHRoZSBzdWJmdW5jdGlvbiB0b28uDQo=
