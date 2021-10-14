Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF47542D8FB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhJNMN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:27 -0400
Received: from mail-am6eur05on2132.outbound.protection.outlook.com ([40.107.22.132]:14432
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231502AbhJNMNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 08:13:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvv94lAM40Np7v9SfLU67Lrvhdt0bYbY+4FCjE75eaCj2vIHSE+LZmpOvkh0vXzxT/QTRrQTW1WpI+3jOVUvRv1uawd5VJTowRyuUemmbmri5A5XdGm/HB7uM7psxdZ1JwW3/4K2NNUyN89xiaJZHCtojpesLElg9ZFNCTWuFVJCinAEDFZOB6ZvzKq7ioXsO2VAlTltUUAxIqesEglG42O25190ciwEiaBu22r68XmBY8dGFfITXMS82dLukn8s3S9BhXC3maqRJSomCtbX5tCTnkVAyjjjtJW19AchnOf7heNww7SuqKUXqM6vQaGraSWChLtyEaCchMLzxR5zLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4pp57u0npnzuasKRbpj9j4quwBjiCX4hHIsx1f17N6s=;
 b=aLERV+hw5pyJIsNHgqSHQYaC5y8mtk5uMcqzkPiiVKvLgIqkOP2vn6IGVPIsOV+VXyl4Vxvnzzi0T3sshaos1vuT+pVsAU2Pd7cLtF7xZco2BhSXlGZCdRoihDfeppiaAQeBUVzsq2OrKUF8wHXKZLpTRNSpK6R/MK8yiOkVhHuqziMGpBec7LkczCQEe42aFwEWl8hr1zWa3D1IMYX37XJWcFjOOeOLk3e73A6ZWHMrR/U+Gz0k9LCFcyJn5CKrhbkBoQBz4cKaUwlLQdDWlRTkBdytLkruFwg06fX0wQem81pCCj85lozlSArtbIJ35a9gT93ytX6BGgosViFUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pp57u0npnzuasKRbpj9j4quwBjiCX4hHIsx1f17N6s=;
 b=EAaqjfO3hjTq9u5wR+AepvmHt9ZKBEvYdybQcyx7lB9q1oJN+xOMoSwLgHFTHoxGwQVs8hspMwabmCF0e3ALIgIpbqd4eFwMI+pDB8MbevltNP/aGRnA0JNyd/b5/GcnejPCNrptGli5GyyD8RFRqAXi60o4qG2+VhgkGZ2DSno=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR03MB2954.eurprd03.prod.outlook.com (2603:10a6:7:5a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.16; Thu, 14 Oct 2021 12:11:17 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 12:11:16 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXv2Xnxc/wFCiERUe0xn+KS7nXfavRCrmAgAFfpoA=
Date:   Thu, 14 Oct 2021 12:11:16 +0000
Message-ID: <ea99a19b-3d3e-4a11-01d5-d49f95be36a0@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
 <CACRpkdYwTUopZ_6khRpkAPFg6qiRTOgyKe=URzVRrNagK2HZMw@mail.gmail.com>
In-Reply-To: <CACRpkdYwTUopZ_6khRpkAPFg6qiRTOgyKe=URzVRrNagK2HZMw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99a88d93-d1ae-4b0e-186d-08d98f0bb970
x-ms-traffictypediagnostic: HE1PR03MB2954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR03MB2954021C17CB26CBB5CCD99283B89@HE1PR03MB2954.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iPFzijZJGGYGYbZF67Te3rqFO8lPiI9mAtQ8Z4VTdn83YFD77hXyEdkfg5ydv/iwdiRqMepfcpr1lUAoy6aICGPTnRRIkTNC1Lep6o0FCirBRBaTmJk2sRB9X6mOc2x+d6JEVvq8my0OKQ2YaD5Lrs3gxXjDJ9BA93DCzp3tZWccYlWZmnCUOqNLHNM8LLI+R77LLuFpZpazFIBYabrBWv6G2mDIn7BWI30W2CJ9u6nTcskEJuWFgwxJ8TYClXTGNyu2itlkD2YgL4zqmt0Rprtr7NKDZSR9zqSwq+7FlLN8wiHGm2FzsOKo/Szbe2eAWtMJUvF3vBd3iRK8UuZkqMHgy+NR8NrFGIIamNEMmdsJ+Z5F/pD5ffemqOmvIw/5fyXEAL3wE2B8REppAAEmvT0N+IfBqjQeV2iKS62Jd+HbEyYVCwNTDGAgtHzpww5JY/GVwwOdsI6LiD7k9sxBx9Gv4A6S2tXDvH6Djx6Os2vsyOpmAwizffCWOPCk6oNRkknqnigwszs7u73ci3PHGDMsi13v6XR/40/x7pyzAA6dV4vCxQn6EdNL6wYZEKmlUshhwBhqq8cIsbmK1AUxSSL/I/TydmalptWZv7eVXwo/LJplWdLQtNua1QXcGgZ845yLuePnGJBpyHU6aW5B2vmRZ7RHlvOn+OpSmawUVzIfwp1k62jcN81ALzugtvg3UUQf7S14F0A9/GaW1WRztDk+3QnsQUKe9nrxDe+5cd08jpfwA3azM2k0LbvuaWi7y4NR1sSAwhoPs14TE4Kfug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(4326008)(110136005)(38100700002)(54906003)(8936002)(7416002)(8976002)(76116006)(26005)(8676002)(71200400001)(316002)(508600001)(6486002)(85182001)(122000001)(36756003)(91956017)(2616005)(66574015)(66446008)(2906002)(66476007)(64756008)(66556008)(38070700005)(86362001)(6512007)(53546011)(66946007)(6506007)(186003)(5660300002)(31686004)(85202003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmVZckVZdDVjQU15RzVOaGxRSFcwY1JvbUlPVXI5ZXc4RmxVWjE4djR0d1lz?=
 =?utf-8?B?cXpIdGFOcmNkb2t0SSs4czZMYVpnNUNPRktSY2U1L21INWtvSW5iUHZBMEhk?=
 =?utf-8?B?YlMwUEJuUmwvL1ZLVko0RGdqZFVOOTdUaHFpVis4VkI1UU5hbmkrK0dxdTZa?=
 =?utf-8?B?Q1M2OU5PQWtBU3Nod2NpT0RaNGlybGRhNnRxeWt2VmphVzVHcS9iUytQdUV3?=
 =?utf-8?B?cVdMY0dzTkZPc0crYU5vaDBrc2Jnb2d5ZzF3WDAxNy9TUXVlZGoyS2JWVlVR?=
 =?utf-8?B?TkF2YWFrK0FDMmtVYXBQSjVFZitTbk9uZFlJUWFSc2V1Q2RGSC9MZ21oL2lp?=
 =?utf-8?B?UzFzNmQ2VE1Zc0ZJS2NlNUF0ZVFBL0pMYUMvaUFtUmlzTjcwNVNHUFlRZUpU?=
 =?utf-8?B?M3ZJNytPRUZqRk9wbkk2QytsN1o2OHNHR21KbU5yakphMGswRDNHWjNHVnFy?=
 =?utf-8?B?MFdGQnVCQWgyVEpXVXRjaHpTZUtCUWxIQUkzUFF2R1hlR1FWZTNERHpvT2x1?=
 =?utf-8?B?QVZRKzYzM0VxUHYxNFFkaGVIU0FNSXpuLy80dU5wL1E5YWkxblBxWnNrNS9l?=
 =?utf-8?B?OWluTHlrcEtQT3kzYkdLdVhJL0hyL2NZNUJaeldpdElHOERxR0JYYUFKbGkx?=
 =?utf-8?B?ZSswb1k2MlFrTFNJWW5PandDRU41SWJBQnNjejd3R3hYbmFlbFJFT0VoZ3Qx?=
 =?utf-8?B?ZlV6cTM4WktHNE82eHJGenJIdVprZFVEenl0bjQwWjR3SjFSWGxYcTB2a2R0?=
 =?utf-8?B?U0Z1TEpWZm13ck4ybmtWVUpxRW51NjRTb1Z4cnhqK1VpSk1zYnB1QkwrSGR2?=
 =?utf-8?B?ZTdOaUZpaFJMTUZReS9yekFDY2I0WFptYVdYTVMrU2VaWFVCZVhjNEdCZW5Q?=
 =?utf-8?B?anNLNnpVYXh1WjczcWxNdGZoNzBQamtNU1BoRkpxK1BjQnJCaGo3a2tIZGt0?=
 =?utf-8?B?Z2lRUnovRmFjaWNvaFNHVTQ0amZoN1RQaG1zK0pzaEx3Zzd6WFBnZ2diYTZ0?=
 =?utf-8?B?ZXlIcEd5cUExc29PbmczQUtZVXVZekVjMG16d1hFNHF2VTljYnQ3MHlCcDZN?=
 =?utf-8?B?YlpVYm9FN0ZMb1Brd2JVL0dvZUxQMWp6WjZFR1FKcFVrbzVJS0NjMDdlTVVp?=
 =?utf-8?B?M2xkRmtxQ1loQmdJYi95UkVETmlueXFTSVJBQ1duaEdyRnV0TERqcUZtc04z?=
 =?utf-8?B?M05jUGpmQzdIOVpDNUUvdURPMmN4eCt0YS9zMWQwSEUxS0JCOHpwQk9CWitS?=
 =?utf-8?B?bW9pbTFrOWdoUTB5bHV0dk1tT3JobzFpQVVNT2hyYjNFMDBhU056MER0eHNw?=
 =?utf-8?B?SlYrQVhUbk00SWVlcHVNRjVsRzNUNnAxa2xtMWVMU0NlejVlZ1NYV1BuVHZi?=
 =?utf-8?B?c1ZROFhod3BNRWI3TDBsdHV3VjhRZlNiSlc0QVZjZ0lDUUxPWHQrSnd5dEZi?=
 =?utf-8?B?bXphWS9kOHdOMWREb2hmREEveUkxUzQ5OEVMaVNZNWJybDdNY3lXWE4vbjZk?=
 =?utf-8?B?dFJka0NXSDZuZ3NKVVBSNjU0Rlh0eWZzTHVZZ21FM2RIRlh2RjNpT3A4VmNU?=
 =?utf-8?B?dTg2bjh5YmU1WXdzSzhGdXRoTjJyUWhZQ09qRm9XeXJqRWVUL3ZZVnhnU3ZB?=
 =?utf-8?B?UkNQL2I4dmZiR0UxaS9wZ1VkYWVlYVBTRG5kZmI5eDF1TkRKYmROU0lCU3JE?=
 =?utf-8?B?bHdPakpQTWlSenFLV05iTVdrazNFa3BEWXRudStNemY1NytudllyUFhVTCtV?=
 =?utf-8?Q?HgJLlIXC9gE9HHqcjdQ6Y1wOeCqZ4lb/DSR9v86?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1CAEFA3E1EDEB418927853CE17A6C32@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a88d93-d1ae-4b0e-186d-08d98f0bb970
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 12:11:16.5890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XiWtBjuHNUFIkJwON9pRk5FgXYJ+MmE0mo/sxc95CQo8XMbzBdwkabUFRP+L8D7pb1c8B07fh/MbAOqrU/dw3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2954
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTMvMjEgNToxMiBQTSwgTGludXMgV2FsbGVpaiB3cm90ZToNCj4gT24gVHVlLCBPY3Qg
MTIsIDIwMjEgYXQgMjozNyBQTSBBbHZpbiDFoGlwcmFnYSA8YWx2aW5AcHFycy5kaz4gd3JvdGU6
DQo+IA0KPj4gVGhpcyBwYXRjaCBhZGRzIGEgcmVhbHRlay1zbWkgc3ViZHJpdmVyIGZvciB0aGUg
UlRMODM2NU1CLVZDIDQrMSBwb3J0DQo+PiAxMC8xMDAvMTAwME0gc3dpdGNoIGNvbnRyb2xsZXIu
IFRoZSBkcml2ZXIgaGFzIGJlZW4gZGV2ZWxvcGVkIGJhc2VkIG9uIGENCj4+IEdQTC1saWNlbnNl
ZCBPUy1hZ25vc3RpYyBSZWFsdGVrIHZlbmRvciBkcml2ZXIga25vd24gYXMgcnRsODM2N2MgZm91
bmQNCj4+IGluIHRoZSBPcGVuV3J0IHNvdXJjZSB0cmVlLg0KPiAoLi4uKQ0KPj4gQ28tZGV2ZWxv
cGVkLWJ5OiBNaWNoYWVsIFJhc211c3NlbiA8bWlyQGJhbmctb2x1ZnNlbi5kaz4NCj4+IFNpZ25l
ZC1vZmYtYnk6IE1pY2hhZWwgUmFzbXVzc2VuIDxtaXJAYmFuZy1vbHVmc2VuLmRrPg0KPj4gU2ln
bmVkLW9mZi1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPiANCj4g
T3ZlcmFsbCB0aGlzIGRyaXZlciBsb29rcyB2ZXJ5IGdvb2QgOikNCj4gDQo+IFNvbWUgbWlub3Ig
bml0cyBiZWxvdzoNCj4gDQo+PiArc3RhdGljIGlycXJldHVybl90IHJ0bDgzNjVtYl9pcnEoaW50
IGlycSwgdm9pZCAqZGF0YSkNCj4+ICt7DQo+ICguLi4pDQo+PiArICAgICAgIGlmICghbGluZV9j
aGFuZ2VzKQ0KPj4gKyAgICAgICAgICAgICAgIGdvdG8gb3V0X25vbmU7DQo+PiArDQo+PiArICAg
ICAgIHdoaWxlIChsaW5lX2NoYW5nZXMpIHsNCj4+ICsgICAgICAgICAgICAgICBpbnQgbGluZSA9
IF9fZmZzKGxpbmVfY2hhbmdlcyk7DQo+PiArICAgICAgICAgICAgICAgaW50IGNoaWxkX2lycTsN
Cj4+ICsNCj4+ICsgICAgICAgICAgICAgICBsaW5lX2NoYW5nZXMgJj0gfkJJVChsaW5lKTsNCj4+
ICsNCj4+ICsgICAgICAgICAgICAgICBjaGlsZF9pcnEgPSBpcnFfZmluZF9tYXBwaW5nKHNtaS0+
aXJxZG9tYWluLCBsaW5lKTsNCj4+ICsgICAgICAgICAgICAgICBoYW5kbGVfbmVzdGVkX2lycShj
aGlsZF9pcnEpOw0KPj4gKyAgICAgICB9DQo+IA0KPiBXaGF0IGFib3V0IGp1c3Q6DQo+IA0KPiBm
b3JfZWFjaF9zZXRfYml0KG9mZnNldCwgJmxpbmVfY2hhbmdlcywgMzIpIHsNCj4gICAgY2hpbGRf
aXJxID0gaXJxX2ZpbmRfbWFwcGluZyhzbWktPmlycWRvbWFpbiwgbGluZSk7DQo+ICAgIGhhbmRs
ZV9uZXN0ZWRfaXJxKGNoaWxkX2lycSk7DQo+IH0NCj4gDQo+ID8NCj4gDQo+IEkgZG9uJ3Qga25v
dyBob3cgbWFueSBvciB3aGljaCBiaXRzIGFyZSB2YWxpZCBJUlFzLCAxNiBtYXliZSByYXRoZXIN
Cj4gdGhhbiAzMi4NCj4gDQo+PiArc3RhdGljIHN0cnVjdCBpcnFfY2hpcCBydGw4MzY1bWJfaXJx
X2NoaXAgPSB7DQo+PiArICAgICAgIC5uYW1lID0gInJ0bDgzNjVtYiIsDQo+PiArICAgICAgIC8q
IFRoZSBoYXJkd2FyZSBkb2Vzbid0IHN1cHBvcnQgbWFza2luZyBJUlFzIG9uIGEgcGVyLXBvcnQg
YmFzaXMgKi8NCj4+ICt9Ow0KPiANCj4gSSB3b3VsZCByYXRoZSBtYWtlIHRoaXMgYSBkeW5hbWlj
YWxseSBhbGxvY2F0ZWQgc3RydWN0IGluc2lkZQ0KPiBzdHJ1Y3QgcnRsODM2NW1iLCBzbyB0aGUg
aXJxY2hpcCBsaXZlcyB3aXRoIHRoZSBpbnN0YW5jZSBvZiB0aGUNCj4gY2hpcC4gKFdoaWNoIGlz
IG5pY2UgaWYgdGhlcmUgd291bGQgaGFwcGVuIHRvIGJlIHR3byBvZiB0aGVzZQ0KPiBjaGlwcyBp
biBhIHN5c3RlbS4pDQoNCkZvcmdpdmUgbXkgaWdub3JhbmNlLCBidXQgaXMgaXQgYWN0dWFsbHkg
bmVjZXNzYXJ5PyBDYW4ndCBtdWx0aXBsZSANCmluc3RhbmNlcyBvZiB0aGUgc3dpdGNoIHN0aWxs
IHVzZSB0aGUgc2FtZSBpcnFfY2hpcCBzdHJ1Y3R1cmU/IFRoYXQgDQpzZWVtcyB0byBiZSBPSyBm
b3IgdGhlIGR1bW15IGNoaXAsIGZvciBleGFtcGxlIChkdW1teWNoaXAuYykuIEkgYWxzbyANCmZh
aWxlZCB0byBmaW5kIGEgZHJpdmVyIHdoaWNoIGRvZXMgaXQgdGhlIHdheSB5b3Ugc3VnZ2VzdC4N
Cg0KSSB3aWxsIGluY29ycG9yYXRlIHRoZSByZXN0IG9mIHlvdXIgZmVlZGJhY2sgaW50byB2My4g
OikNCg0KPiANCj4+ICtzdGF0aWMgaW50IF9ydGw4MzY1bWJfaXJxX2VuYWJsZShzdHJ1Y3QgcmVh
bHRla19zbWkgKnNtaSwgYm9vbCBlbmFibGUpDQo+IA0KPiBJJ20gcGVyc29uYWxseSBhIGJpdCBh
bGxlcmdpYyB0byBfcmFuZF91bmRlcnNjb3JlX25hbWluZywgYXMgc29tZXRpbWVzDQo+IHRoYXQg
bWVhbnMgImlubmVyIGZ1bmN0aW9uIiBhbmQgc29tZXRpbWVzIGl0IG1lYW5zICJjb21waWxlciBp
bnRyaW5zaWMiDQo+IEkgd291bGQganVzdCBuYW1lIGl0IHJ0bDgzNjVtYl9pcnFfY29uZmlnX2Nv
bW1pdCgpDQo+IA0KPiAobm8gc3Ryb25nIG9waW5pb24pDQo+IA0KPj4gKyAgICAgICAvKiBDb25m
aWd1cmUgY2hpcCBpbnRlcnJ1cHQgc2lnbmFsIHBvbGFyaXR5ICovDQo+PiArICAgICAgIGlycV90
cmlnID0gaXJxZF9nZXRfdHJpZ2dlcl90eXBlKGlycV9nZXRfaXJxX2RhdGEoaXJxKSk7DQo+IA0K
PiBOaWNlIHRoYXQgeW91IHByZXNlcnZlIHRoaXMgZWRnZSB0cmlnZ2VyIGNvbmZpZyBmcm9tIHRo
ZSBtYWNoaW5lDQo+IGRlc2NyaXB0aW9uIChEVCkhDQo+IA0KPiBXaXRoIHRoaXMgZml4ZWQgb3Ig
bm90ICh5b3VyIHByZWZlcmVuY2UpDQo+IFJldmlld2VkLWJ5OiBMaW51cyBXYWxsZWlqIDxsaW51
cy53YWxsZWlqQGxpbmFyby5vcmc+DQo+IA0KPiBZb3VycywNCj4gTGludXMgV2FsbGVpag0KPiAN
Cg0K
