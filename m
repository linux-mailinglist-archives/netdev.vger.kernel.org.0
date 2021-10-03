Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628DF42005F
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 08:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhJCGxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 02:53:14 -0400
Received: from mail-eopbgr1400124.outbound.protection.outlook.com ([40.107.140.124]:11863
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhJCGxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 02:53:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffJ/T96T1IhWz3KUtT45sbPfK1QucWvSGarUHsw4TwevD+xLxQzN4WpGSnxOo0HOIlQ8VMjmS6Jk9ay1s2Znam5P93FHOP2N7cgOrnphLL59YjbdIHqhT2vvqtAbAjDkSCmrBtMMKaHZyVeLhJV5kr0oeQI/+7EPmPtTn2apEh9gVL9EjFtVZRDF1KS1F0J5iBbwPb7qiJgXi9Q80bnH1wCKqFfpdesP0l3zpH00z9G7QS2beA/48DCQWO8RzpkkPTzUWUSuE76/Eg3FS6s6/MfJTcZwTAzUpRBCFnav7j8UuucnhBVaFgOWJzHhy625KUJ59xyZ1CYhw5oyoJeZnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHdeD61XtYnhGmL89ngfV9IM7BBXw+bnkNCoB6VYvR0=;
 b=KwxOYQYB1PVgrQln9JeidNci6nVbEIRtTpWvvja1hxUDKxDX2Xpl6mz74Nlr9UoWjEbX+TYHat3pNNCcrdscHWTtQbG3xzybd4qT8AGlZkaDDMUOTVOjjteJS2rc+6oCJnCTHMxzEHKWUi/w3kz+iDkyriennZVhHsu/XoQpL9rJFhK4BS4RBlf5xZ3f4MbwO/bfO9byGgTVQ4Z4edK8L58+oyDqI9yZUHRzvLF58EgfpuZYBbQ6cElVGYsvw4nrrfi19Pg8/I3QmvbaZfO+c8bewHID4l3IcxwtzyUx+tRP5sjl3Lw7d8XwBBmXwuqpqmdj0pmlHZIz4DBCLYuNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHdeD61XtYnhGmL89ngfV9IM7BBXw+bnkNCoB6VYvR0=;
 b=s1KFgk5bOGaUmLxoRBny6sYipHvvAcnFlf3owGTv4T/KQXZWSXB/SOhPvvKCp0B51t3nAJLNLq0QMuBwUGGM+VZFCkv49kGBepjrx7C71+ytvtsWJKaGpwpiNR/CgBzL6wunapicdeMtOZJadbp5GmXLO8cw5cYO+99I9Bs2O48=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB1874.jpnprd01.prod.outlook.com (2603:1096:603:2c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sun, 3 Oct
 2021 06:51:17 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Sun, 3 Oct 2021
 06:51:17 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Thread-Topic: [PATCH 04/10] ravb: Add support for RZ/G2L SoC
Thread-Index: AQHXttX7hUtu3PiXEk+gzpGHHZtaNqvAHb6AgAC5mMA=
Date:   Sun, 3 Oct 2021 06:51:16 +0000
Message-ID: <OS0PR01MB59224497C081231E9CC334B986AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-5-biju.das.jz@bp.renesas.com>
 <b4c87a6d-014f-0170-feb5-20079c7d5761@omp.ru>
In-Reply-To: <b4c87a6d-014f-0170-feb5-20079c7d5761@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abda8fe3-97c9-492c-3760-08d9863a32fa
x-ms-traffictypediagnostic: OSAPR01MB1874:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB1874A1B18B981F83CA09B25486AD9@OSAPR01MB1874.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fi599gBDbFYtc2z9mhR3IORrq9mFXZHo2yaTBhUrowrE/4/5ap7cyy/tnMk3YNqrM5S0kv5oAfAtEDKiyGDpcDoThj3ZQc8HImE2Uy7CYlb8StZk/IQ1qBOYmP14RickO/cVzPn4UPytfq86Cf6cr+5L/zcA10ew6aAl/OO9tSpW/z2JhDv/TKdLuAcS6RDREOgITACf3yn/RCZyIhT5d1xiCRK3/txVQqaw2IKoBUBD6lJcGvOB4tkIPAhAK56Mr0YjCmtlpckCMvA6nayY3z4Qu3N64BB4SxRj7SlXVrBaqEL8CxPZ2NZSX7kNeYsx39QHWluPGn0tSKUYZbpPwdVBdT7Ne8vWYXPOXoTUbGsOxY/rE5uiN73imfghksZEuzm4XyympnFI3afxaQqAw48CX0FX/GfKC/q6tU2PvGXSHhliIWC2PKZvfRUI2UbhYqklqoMXt7kwgQnUchSqe39u8BJAENKAJk6YMEqaZUQJU0EvwhNIrAKZRLDCzmTLYKlG3ZE58CaXUHeXlzQ5kqEdvCiC7TvqDxlc92tQ+ziP7uIWq0ZYmnt5+86kLf2ZmPsNhDxFU4E4TwUroWN9KgE/xw0Q6mNGK6qPi9TnkZrIdvaBPTK1wFZyW21pyLgLgTA1nzox/X/8qWhXC25L6l57ISV/qkOU21lhoAzbzdytEbvChuhbjp7CFEkf0dxMCDZnQ+M4XFFZfS47/+AhGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(66946007)(66476007)(66556008)(64756008)(86362001)(107886003)(38070700005)(316002)(5660300002)(8676002)(76116006)(2906002)(8936002)(66446008)(7416002)(54906003)(83380400001)(9686003)(110136005)(6506007)(71200400001)(508600001)(26005)(55016002)(4326008)(186003)(7696005)(53546011)(122000001)(52536014)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2tqV1ducWNXY2hOckFoVzJ4UTJ6bWpkblE0aXpReW5HOFMrYjFQMktTMXZK?=
 =?utf-8?B?cGxBTjhLZUUrdjB4eU1lY2UvWTFUd0FwMzFEclJVUnZsWWhxQm9jTFl1VEFH?=
 =?utf-8?B?Q3NsL2JlNlBHTXpRTVBjQ1pwU1ZFWUdGbEpxYlhJNjk0d0RsajBMcDc5bVdL?=
 =?utf-8?B?RFVnVDB0RStneW9RMlN1OTlhZi9pNG1HajNpWEkwS1NVdHF2cFoxN2JESms5?=
 =?utf-8?B?ZHNiVlVuN0R6cjNQVW5TMEVIeEppbHFiQWIzbDVkWjQydFpQSnBTZUcyZFVm?=
 =?utf-8?B?a3RuNngrR2w0RFFoYXpCUmtjSmMwUGlzblZqZmxCTHRJRHFUWUlLWXptcXV5?=
 =?utf-8?B?K25LY0VoTlJ3bU9VZ0JmZ0dlbzBiZC9oa2RDUXZickU1SmpPZ0RvWXF2dmtv?=
 =?utf-8?B?ZkJDT3YyQThoYUFMMTZFZkxuTDdpa09ZWkJMenBLLzBkaE1LMDlBb0h4c2k4?=
 =?utf-8?B?dVYxTVExM1pOUFJtYmV6S0ZnRFpVM2xYUy9MTFNndVdkZmtaYk8wdWw5eml3?=
 =?utf-8?B?Mzk2eFV3ellDWTV6QlZjc2pNQ0RlanZHTDU3RnBDVTVSeEhzVW43WFlvNFc2?=
 =?utf-8?B?ODExOTE0bkhvL0x4RmxIdi9jd3c1LzFOSDBTZ3ZsR2lzMEVtaDlIY2p0RXpY?=
 =?utf-8?B?UDdhVmE5SjMrdE5meXhEMFhvOFVDTWdFZUhyYldsb3p0N2tPckVlbWZjaXJj?=
 =?utf-8?B?SWVOSXNDVU1kQWg5d2thcGQ3RDR6MFgwWE9pa0xNTHdxSys1ZWphNzRxc3gv?=
 =?utf-8?B?bU1Fc2I0V0s2Ylp6cFVxT3ZYMlFKTkVWdG9DdVFoTklSZk1BVUR4dkZIdFpG?=
 =?utf-8?B?Vk04SVVqOFpUT0RGa1NRaEQ1RG0xRk05eklwU1RWQmFYTkxPOFQ3TmlxWjFU?=
 =?utf-8?B?R2N3b2ZodXlQRXRaZ3ErdVhCQXNsaGc3QjR3TVNlSEJSUlVtUFNRalY2ZkpJ?=
 =?utf-8?B?K2VYTTJGOHRkVlhDV2RiM0NhWjUzZVl4KzF3S2JSZjBXVlpXMkM5NCsxcEdN?=
 =?utf-8?B?SVJ1QmMxQzUwTEJNaGhyVGovbTF1MmhHVXJjQ2lTTE00OGRoRDZJNmxyNjBY?=
 =?utf-8?B?cjI1S21MUzk0RjhoWEs0K3RSNmU0NHRUR0J3d0tyTEg4ek1vNUFEYXNMS3pG?=
 =?utf-8?B?SHNpOUVBdkpJVVZ6Y2ZRVkRreVdYTjNBTHk3T2tmb2RvdXgzQXRvemtqcTFZ?=
 =?utf-8?B?ajFhQnIvd3Jhd1lHS0huRTZxUm8yZ1puRTgrenRHL0U2Q3N2aHpJZVJMODND?=
 =?utf-8?B?ZGhJL2N5bHJ0MU1aY09ySlBZZFUramhUTzR0c0JWZ2o1SU4xaHVBcklMRm1X?=
 =?utf-8?B?bHdvcUJ4YTl3RlhLZkxuNngrMlBzMHllRFp0akxyL2JiSFkvb3VPcHk4dVZH?=
 =?utf-8?B?RGdkN2JMekF1bS9WQ0NTb1o4SG1SYnFLUCtzL1lzTjNEOHdEcEpsem5McG1u?=
 =?utf-8?B?enJ3QXVVM0FWTlpEbWl6SGRNd1FOQzFIK0V0aklTemI1T3cwZ0RITThrTFlr?=
 =?utf-8?B?ZXdYaytIZFBxNVFybTlxWE5YTFZZekFYcU9HVFFBUkh4TWF1c05rODVhdmNy?=
 =?utf-8?B?ZFU0bCtzSzJ0ZzRUYjU4WEtRdnR0L1NIUXBSNlVmM1ltTEZLS1R1UlpCQ05p?=
 =?utf-8?B?dXVnaUZhdDBnVVRrczBXSUdDQ3Zab2oyK2Q2TDlvQ3VmNHNEUEZudWgrUnpS?=
 =?utf-8?B?SkZHejRUUUVYM1lQbGNlekpMMGI1Z0dwTVBkaFNNSHZpcytndTJFdk8wY1hx?=
 =?utf-8?Q?ibF+uDYvo/0Px3ukNk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abda8fe3-97c9-492c-3760-08d9863a32fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2021 06:51:16.6669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zxqe1VCRg4ulOLcpyMzuhZuZEaUtQSvYVWW+aXgusT83DD9Rp3tL8JblAmrDbQZgvCjM+yZ3wRJEB9asyOk3111ME0lmPDYp/tUuIhxrgXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1874
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIDA0LzEwXSByYXZiOiBBZGQgc3VwcG9ydCBmb3IgUlovRzJM
IFNvQw0KPiANCj4gT24gMTAvMS8yMSA2OjA2IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4g
UlovRzJMIFNvQyBoYXMgR2lnYWJpdCBFdGhlcm5ldCBJUCBjb25zaXN0aW5nIG9mIEV0aGVybmV0
IGNvbnRyb2xsZXINCj4gPiAoRS1NQUMpLCBJbnRlcm5hbCBUQ1AvSVAgT2ZmbG9hZCBFbmdpbmUg
KFRPRSkgYW5kIERlZGljYXRlZCBEaXJlY3QNCj4gPiBtZW1vcnkgYWNjZXNzIGNvbnRyb2xsZXIg
KERNQUMpLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhZGRzIGNvbXBhdGlibGUgc3RyaW5nIGZvciBS
Wi9HMkwgYW5kIGZpbGxzIHVwIHRoZQ0KPiA+IHJhdmJfaHdfaW5mbyBzdHJ1Y3QuIEZ1bmN0aW9u
IHN0dWJzIGFyZSBhZGRlZCB3aGljaCB3aWxsIGJlIHVzZWQgYnkNCj4gPiBnYmV0aF9od19pbmZv
IGFuZCB3aWxsIGJlIGZpbGxlZCBpbmNyZW1lbnRhbGx5Lg0KPiANCj4gICAgSSd2ZSBhbHdheXMg
YmVlbiBhZ2FpbnN0IHRoaXMgcGF0Y2ggLS0gd2UgZ2V0IGEgc3VwcG9ydCBmb3IgdGhlIEdiRXRo
ZXINCj4gd2hpaGMgZG9lc24ndCB3b3JrIGFmdGVyIHRoaXMgcGF0Y2guIEkgYmVsaWV2ZSB3ZSBz
aG91bGQgaGF2ZSB0aGUgR2JFdGhlcg0KPiBzdXBwb3J0IGluIHRoZSBsYXN0IHBhdGNoLiBvZiB0
aGUgb3ZlcmFsbCBzZXJpZXMuDQoNCg0KVGhpcyBpcyB0aGUgY29tbW9uIHByYWN0aWNlLiBXZSB1
c2UgYnJpY2tzIHRvIGJ1aWxkIGEgd2FsbC4gVGhlIGZ1bmN0aW9uIHN0dWJzIGFyZSBqdXN0DQpC
cmlja3MuIA0KDQpBZnRlciBmaWxsaW5nIHN0dWJzLCB3ZSB3aWxsIGFkZCBTb0MgZHQgYW5kIGJv
YXJkIERULCBhZnRlciB0aGF0IG9uZSB3aWxsIGdldCBHQnN1cHBvcnQgb24NClJaL0cyTCBwbGF0
Zm9ybS4NCg0KUmVnYXJkcywNCkJpanUNCg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERh
cyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFi
aGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0N
Cj4gPiBSRkMtPnYxOg0KPiA+ICAqIEFkZGVkIGNvbXBhdGlibGUgc3RyaW5nIGZvciBSWi9HMkwu
DQo+ID4gICogQWRkZWQgZmVhdHVyZSBiaXRzIG1heF9yeF9sZW4sIGFsaWduZWRfdHggYW5kIHR4
X2NvdW50ZXJzIGZvciBSWi9HMkwuDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgMiArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMgfCA2Mg0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDY0IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCBjOTFlOTNlNTU5MGYuLmY2Mzk4ZmRj
ZWFkMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+IFsuLi5d
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBp
bmRleCA4YmYxMzU4NmU5MGEuLmRjODE3YjRkOTVhMSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiBbLi4uXQ0KPiA+IEBAIC0yMDczLDEyICsy
MTIwLDI3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvDQo+IHJhdmJfZ2VuMl9o
d19pbmZvID0gew0KPiA+ICAJLm5jX3F1ZXVlID0gMSwNCj4gPiAgfTsNCj4gPg0KPiA+ICtzdGF0
aWMgY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyBnYmV0aF9od19pbmZvID0gew0KPiA+ICsJLnJ4
X3JpbmdfZnJlZSA9IHJhdmJfcnhfcmluZ19mcmVlX2diZXRoLA0KPiA+ICsJLnJ4X3JpbmdfZm9y
bWF0ID0gcmF2Yl9yeF9yaW5nX2Zvcm1hdF9nYmV0aCwNCj4gPiArCS5hbGxvY19yeF9kZXNjID0g
cmF2Yl9hbGxvY19yeF9kZXNjX2diZXRoLA0KPiA+ICsJLnJlY2VpdmUgPSByYXZiX3J4X2diZXRo
LA0KPiA+ICsJLnNldF9yYXRlID0gcmF2Yl9zZXRfcmF0ZV9nYmV0aCwNCj4gPiArCS5zZXRfZmVh
dHVyZSA9IHJhdmJfc2V0X2ZlYXR1cmVzX2diZXRoLA0KPiA+ICsJLmRtYWNfaW5pdCA9IHJhdmJf
ZG1hY19pbml0X2diZXRoLA0KPiA+ICsJLmVtYWNfaW5pdCA9IHJhdmJfZW1hY19pbml0X2diZXRo
LA0KPiA+ICsJLm1heF9yeF9sZW4gPSBHQkVUSF9SWF9CVUZGX01BWCArIFJBVkJfQUxJR04gLSAx
LA0KPiANCj4gICAgQUxJR04oR0JFVEhfUlhfQlVGRl9NQVgsIFJBVkJfQUxJR04pPw0KPiANCj4g
PiArCS5hbGlnbmVkX3R4ID0gMSwNCj4gPiArCS50eF9jb3VudGVycyA9IDEsDQo+ID4gK307DQo+
ID4gKw0KPiANCj4gWy4uLl0NCj4gDQo+IE1CUi4gU2VyZ2V5DQo=
