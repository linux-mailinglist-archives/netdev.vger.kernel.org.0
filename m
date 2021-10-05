Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A343A422B69
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhJEOrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:47:39 -0400
Received: from mail-eopbgr20090.outbound.protection.outlook.com ([40.107.2.90]:23059
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234899AbhJEOri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 10:47:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPh5R3aOv7eZd0kUlX8A7gHqyijmJ/ldJojD/oN9wCLQ+BuCQO944Fycpmyw1jSmLKAovrCsbfqMMPlH7wLoaer/eG0LPmfTjJFuh7MKo0Goaq1Ch+XdS1yvZg2MCYsfMd1YaO1Tde46Q8D50z4JV06MPd7ypE8blAjlJ4ut17mtA2Zaa7Nxrbk32kkGmpOW8WzwokJspvyBFzSHuY91OuA3S6rc2U6zcnWWA3bZgnfQipLM9lpXmZmSVzGMFcSOx1Mu4UaL2ethXuI0bvb8Aibt1AcZxUDuRKw3W/+/WiK4rv3X8Q3JX/tRD0cJEJKEdUk0djX7aUQQZ/AqIojLgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8x+VfLFhFQdbR18ML30rdQY2g8whLXYvVrLqBBZr16c=;
 b=UBvrGOBg2tOmIeKWygQpGrFGcCon5lnVkTWnTWBcFMYaFnUuJoEt8BOqKms/+r7XEUu4//Oj9MAZtMO9VzEvNFwKQe2A70G+EXGlryGVnYt4loYJ6PYmm3h9nJjbr/dfNl6S5lhYOpq+JrxhZK2UfpU0QWUnc7XLUoQmbnn/TZvpKkVeBBuSFrnmRIVFz+J0OYZ5ZJdIWPl0idiV2fxjpBPcmBvbeA5cO1aJoMzU2PeMp+ctNvtHfA8yfHY4ajW1/OIktbZwxCM6Ta74B+q2oyP0w3nwnQX7IJ6xdza749i5p5C9WY2mcvF44oFAOG32j516dgjF61Pqu8xkVlnyFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8x+VfLFhFQdbR18ML30rdQY2g8whLXYvVrLqBBZr16c=;
 b=mFMQuoirgGnP5n7lMoG6if9GirQiwolu+FbkEOUjlng3p3gmOmf1n9H0Kcd0JzPPJcTI5GWyxhp2P6VxZF68NgPA8WxyMEoKh2gRddWsZdsJ481Vd0wzhSxY4mIq9nS188nP/1gpQ5qgICTXl2sKw1i9iLXE6v6eCCX+xaxyFHA=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2139.eurprd03.prod.outlook.com (2603:10a6:3:1d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.19; Tue, 5 Oct 2021 14:45:45 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 14:45:45 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Thread-Topic: [PATCH net-next 1/4 v4] net: dsa: rtl8366rb: Support disabling
 learning
Thread-Index: AQHXtXXws06pLZ3f6EGMY4OLSctn3qu8ZZCAgAb0a4CAALkwAIAAZnAAgAALEoA=
Date:   Tue, 5 Oct 2021 14:45:44 +0000
Message-ID: <c399197c-65a2-51da-0efd-e553acd86999@bang-olufsen.dk>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-2-linus.walleij@linaro.org>
 <9c620f87-884f-dd85-3d29-df8861131516@bang-olufsen.dk>
 <CACRpkdZ5O0pf+mZphr5ypDNXtkQwfomwBnUToY2arXvtDHki+g@mail.gmail.com>
 <d255f7eb-a85d-6fb6-8e86-ccb9669dd339@bang-olufsen.dk>
 <CACRpkdYaqN8=AcSJMTk_uNfDti_tETQ6LT8=OO74qAHadtRmaA@mail.gmail.com>
In-Reply-To: <CACRpkdYaqN8=AcSJMTk_uNfDti_tETQ6LT8=OO74qAHadtRmaA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbcd4935-c223-400f-7f97-08d9880ed013
x-ms-traffictypediagnostic: HE1PR0301MB2139:
x-microsoft-antispam-prvs: <HE1PR0301MB2139D7E599FEC89C0F37431083AF9@HE1PR0301MB2139.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjvdUp6o+P79myVNbKNqUHpYMnopFKe3foINi2kN9Ndu20CYsGtGwlaJHw3KSkO2KDH3aWfXEN2eM/Jv99Fh7otrsx7gPvvB0YFBqI+2FUZUGuqM/mZJhdJTA9dv3WDfTEPVLPZt2wMeTqPZsG6DQeqf0sTupv4L9gX8915zYfx6w4z3P8ykmEwttESdW7dJe/Q9JZj1fuHMBXleJX76ar/k4g14z9mD99zO5o/wxBbm5OmotjLJ5ktCrq6q9Gbhvn1nrqd8JR0O2keSiL/uE5W+onGgG61B+V2op3w7AGgJEDJECxxc7UlPfqp6GkBozWCrAKfqfZo9mInFlCEpIdTVDkveJE8cb+o1zsmcUTN6uWePGHSyQB6xVTwy8vTJKeQOwdwKDNvtUoUPx9FZGlBsFl39gA0zXIwJYTM9pXS5Wi6v2j78pKI8121bv3e1isGJBE8ubzVT4A8WkRwpY+rEm5KCKuSlqDxvtXN9W2TnW43zCWdTBPXDOeHNz0QxuLBy15GzAHx1TagfulJqq3gMEq6Iyhcu7BsQeFgPVUqiaoGyWxcesLreM8ddGut5PADtvD4+GCQaelwhJ+174pOkg24ezsDsLRjKEhoATtT+aboKFfctY84MvnMESm7tJNmw32PbGJsij9Bp1qvix/tBaDHqhjEYb8u35wsD8O0TNR2HnW0f1OGaEY9C+BaP8oRXIVeUP5KIAWe7SJiP3EkPDXy3z/+9YkKblB/LHtD8hLIsqRgoouOXkHsArgr9VDI6MzBWI5xCIt6H99OZwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(4326008)(86362001)(36756003)(316002)(83380400001)(38070700005)(85202003)(508600001)(8976002)(38100700002)(85182001)(186003)(8676002)(31686004)(2906002)(66946007)(66476007)(6486002)(66446008)(66556008)(64756008)(2616005)(8936002)(122000001)(6506007)(26005)(53546011)(6916009)(5660300002)(7416002)(76116006)(54906003)(6512007)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3gzMDlERndWR3c2L3MyQ21WZ3lMZFFXNHByUU9OZWNrSkhna0lxekYrV3RK?=
 =?utf-8?B?d3ZkeU5rWlZZNGVwNVJFYXhXQkh2UDQrZG4wT3lNVi9wU0lXdmdFd01ScDNi?=
 =?utf-8?B?a3VSY2lpd2RvQW92cjhzMWNaN0E4SFZxSFpTd082TWlTT1daQ2Q4TmxFRHhD?=
 =?utf-8?B?L3l6ZVp2R1d1T0wwWXU5aXAreVFMMERBTTVlSVpENlFDa0x1MGNJbHF2cjZ2?=
 =?utf-8?B?WndJR1UvRUc0VUFlRlhuVHdHZ3pYc2Vhbnp2d3l1RVRKcVR5bEg3dVZXS2tP?=
 =?utf-8?B?ajNRUms2MHNnRTRGZnB0OS9zUzNSc2hLd3BnaGdiZkNlT0ZCSmlhL1ZvczJQ?=
 =?utf-8?B?RkV0ak9XMm55a0k3S254emgzWGVyYkU2dEdPMHBPNGtqN0hMNjdjUG1renpH?=
 =?utf-8?B?STNTS2w4Y0trL1JqYjF3TDBKaE14UDFHck05dWJoZWNxTTVXSzNkamw4WGlu?=
 =?utf-8?B?L2Vwc2xxcWNlOG56ZFN2VnVEdHRlSkJuYTJHKzZaY2liWSs4SmlJaDhKMXUv?=
 =?utf-8?B?ZmJhZDJ6VnE0Q3g1elBSOU5QcDVIbEwweUpDMTR6S1FLbjAyNml4dlQ0TDFQ?=
 =?utf-8?B?RWFBYkNndDM3U253K0dDdFhGS0RHK0lwamJmdFErSUhxMFBnR1ZRQ0YxWmJw?=
 =?utf-8?B?TlVrNUswY2pXMjV5SlB2Si9JTWNReEhJY1FXcVNJOThFeXBwRTh3RFlSc3Nn?=
 =?utf-8?B?M05SSDU3K3FnTXFTMVhkYXRPMHJrMHZpRDRDMHlCejNLeWNrU2p1cjNndkQz?=
 =?utf-8?B?OWJIZFlpWEdzMnBjWEdScUZ0OXo3Q21OVmJuNWdtSGRLVWJDcUdrN0JFdzFM?=
 =?utf-8?B?ejB1Yy94Wm9oMHd1eUduWlA4cnZUY0dTQTd2YnlZN2wvR1UxT0xmWGMzUmxW?=
 =?utf-8?B?ZndORU1CQThyM1JTRUU1Y0JCODBLNUFSSC9SbUFjSk9lK3Q0WFhzQTZHR294?=
 =?utf-8?B?bmRKQnFMRjN4V1hBRjBaZ0VPN0dsTlVTczVNRWQ0enNwQk1CTThwdjI3bjFR?=
 =?utf-8?B?UzRQdDEwVWRpZHBDSzNTZk9xSXl4Vk9vR2Jiak5QYXB0YjJqWUF3ZnVhRndD?=
 =?utf-8?B?R2pKNXkxUnpaWTYzdS9sa2tLZ2tYaFhSRzQ2bkozM1lOTmJHMk1VT3RGUzhG?=
 =?utf-8?B?M21tRHd0REFUamdjdC9OSnlsVEJhNDN4K1Z1VThlZVNDMW9aRTYvdGJXRkpB?=
 =?utf-8?B?VWx0ZGR1WnFxUEVoeVJ0ZWFJS2xzTkk5MVhJdndBNzZVcHdMZldDcmZnRnA3?=
 =?utf-8?B?YWFNTUdhWGFMYk9oUGZuU2wydmVvT3dPZEFRejhYRE01eXJZOGlpZGkvSHQ4?=
 =?utf-8?B?VG9RRXhYaTFlMTk2eFZJMHdKK1YwWHRyNDM3QmtKb2w5MHYxMlJOMTh4cmFZ?=
 =?utf-8?B?ZnVFL2NvR2NxM3RqcCtpTm9xckFDQVJPVWtORDU4RWxPcWtnTnVpclBUeGxL?=
 =?utf-8?B?T0JvclZRTi9wSU11L09laHFtMEdDUmZBN3ZaRmZrMFQ5N0FoMTlRUTg2MEtV?=
 =?utf-8?B?eDBKZ3dMUHpKSVZLSU9PeEFiQlE2S2FQWkUxMmlHcStTeU1qMlNPVFRibGNI?=
 =?utf-8?B?d3pZcG5qN1FMRnFneWVCZnF4OGNLZTE0dkgxUkZzUHJvWWVvVUNWek5ucTFu?=
 =?utf-8?B?NzFGN2M1ek1kVXQwN210a09BaHRpYTkrMkxPSVA3YmdvVWNoOU1VUTV2K0hO?=
 =?utf-8?B?dUgvV040cnBFUkVzSzNRYTJJQjdLNnpmdUZCcnd4U2lGME5EZG9HYUI4Wmoy?=
 =?utf-8?Q?Xcd8w0twkvHY1z8kHZos/tYkfZDl3UphHNTiQY1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B50C14B8385FD468890E4D46E6639BA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcd4935-c223-400f-7f97-08d9880ed013
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 14:45:44.9565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +30+xh9D5xj0bQ/YVK/12ilunk5t+5vlXy2q1kyZNd/4vcsOfUENd8Bm5GsG3OcBTAvVLw+FXNNK0Z7xFcXWKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNS8yMSA0OjA3IFBNLCBMaW51cyBXYWxsZWlqIHdyb3RlOg0KPiBPbiBUdWUsIE9jdCA1
LCAyMDIxIGF0IDk6NTkgQU0gQWx2aW4gxaBpcHJhZ2EgPEFMU0lAYmFuZy1vbHVmc2VuLmRrPiB3
cm90ZToNCj4+IE9uIDEwLzQvMjEgMTA6NTcgUE0sIExpbnVzIFdhbGxlaWogd3JvdGU6DQo+IA0K
Pj4+IEJUVzogYWxsIHRoZSBwYXRjaGVzIGkgaGF2ZSBsZWZ0IGFyZSBleHRlbnNpb25zIHRvIFJU
TDgzNjZSQg0KPj4+IHNwZWNpZmljYWxseSBzbyBJIHRoaW5rIGl0IHNob3VsZCBiZSBmaW5lIGZv
ciB5b3UgdG8gc3VibWl0IHBhdGNoZXMNCj4+PiBmb3IgeW91ciBzd2l0Y2ggb24gdG9wIG9mIG5l
dC1uZXh0LCBtYXliZSB3ZSBjYW4gdGVzdCB0aGlzDQo+Pj4gb24geW91IGNoaXAgdG9vLCBJIHN1
c3BlY3QgaXQgd29ya3MgdGhlIHNhbWUgb24gYWxsIFJlYWx0ZWsNCj4+PiBzd2l0Y2hlcz8NCj4+
DQo+PiBHZW5lcmFsbHkgc3BlYWtpbmcgSSBkb24ndCB0aGluayB0aGF0IHRoZSBwYXRjaGVzIHlv
dSBoYXZlIHNlbnQgZm9yIDY2UkINCj4+IGFyZSBwYXJ0aWN1bGFybHkgcmVsZXZhbnQgZm9yIHRo
ZSA2NU1CIGJlY2F1c2UgdGhlIHJlZ2lzdGVyIGxheW91dCBhbmQNCj4+IHNvbWUgY2hpcCBzZW1h
bnRpY3MgYXJlIHRvdGFsbHkgZGlmZmVyZW50Lg0KPiANCj4gSSB3YXMgbWFpbmx5IHRoaW5raW5n
IGFib3V0IHRoZSBjcmF6eSBWTEFOIHNldC11cCB0aGF0IGRpZG4ndCB1c2UNCj4gcG9ydCBpc29s
YXRpb24gYW5kIHdoaWNoIGlzIG5vdyBkZWxldGVkLiBCdXQgIG1heWJlIHlvdSB3ZXJlIG5vdA0K
PiB1c2luZyB0aGUgcnRsODM2Ni5jIGZpbGUgZWl0aGVyPyBKdXN0IHJlYWx0ZWstc21pLmM/DQoN
CkFoLCBJIHdhcyBqdXN0IG5vdCB1c2luZyB0aG9zZSBwYXJ0aWN1bGFybHkgZnJlYWt5IFZMQU4g
ZnVuY3Rpb25zIGZyb20gDQp0aGUgcnRsODM2NiBsaWJyYXJ5LiBJIHN0aWxsIHVzZSB2bGFuX3th
ZGQsZGVsfSBhbmQgdGhlIE1JQiBjb3VudGVyIA0KaGVscGVycyB0aG91Z2gsIGFzIHRoZXNlIHNl
ZW0gdG8gYmUgT0suIEkgaGF2ZSBiZWVuIGtlZXBpbmcgdXAtdG8tZGF0ZSANCndpdGggeW91ciBj
aGFuZ2VzIHRvIHJ0bDgzNjYuYyBhbmQgdGVzdGVkIHRoZW0gbG9jYWxseSB3aXRoIG15IHN1YmRy
aXZlciANCmFuZCB0aGV5IGFyZSB3b3JraW5nIGxpa2UgYSBjaGFybS4gU28gd2Ugc2hvdWxkIHN0
aWxsIGJlbmVmaXQgZnJvbSBzb21lIA0KbGV2ZWwgb2YgY29kZSByZXVzZS4NCg0KCUFsdmluDQoN
Cj4gDQo+PiBSZWdhcmRpbmcgQ1BVIHBvcnQgbGVhcm5pbmcNCj4+IGZvciB0aGUgUlRMODM2NU1C
IGNoaXA6IHJpZ2h0IG5vdyBJIGFtIHBsYXlpbmcgYXJvdW5kIHdpdGggdGhlICJ0aGlyZA0KPj4g
d2F5IiBWbGFkaW1pciBzdWdnZXN0ZWQsIGJ5IGVuYWJsaW5nIGxlYXJuaW5nIHNlbGVjdGl2ZWx5
IG9ubHkgZm9yDQo+PiBicmlkZ2UtbGF5ZXIgcGFja2V0cyAoc2tiLT5vZmZsb2FkX2Z3ZF9tYXJr
ID09IHRydWUpLiBUbyBiZWdpbiB3aXRoIEknbQ0KPj4gbm90IGV2ZW4gc3VyZSBpZiB5b3UgaGF2
ZSB0aGlzIGNhcGFiaWxpdHkgd2l0aCB0aGUgUlRMODM2NlJCLg0KPiANCj4gVGhpcyB3aWxsIGJl
IGludGVyZXN0aW5nIHRvIHNlZSENCj4gDQo+IFlvdXJzLA0KPiBMaW51cyBXYWxsZWlqDQo+IA0K
DQo=
