Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4F43022A
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 12:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244233AbhJPKlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 06:41:50 -0400
Received: from mail-eopbgr140113.outbound.protection.outlook.com ([40.107.14.113]:58230
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231331AbhJPKls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 06:41:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYKaV/RBujD7G46onZK3dXvZ5Cd6KVYVqln+I4G5c29ubc4/8p+qp+QOhp9fNAGlUIDwxTAGhiUnmd9AK0VFkRY6UghjpVlQ5KiYk8WP7pN3i5Dn/ZNM3la8/RW/foPaLg3SCCbpI1ZHA/Qp/1Swtis9EhMFIYK/VL7vOla2SDaLA97b70x1ce9ZNXP6wJDNyop8OLqToRZjwXUWkOkwOQJZ2YKLRA5Ojpo8c+68D6FPEAQLiebV5FAqq9CDc2GqGol1kNNcJvIPu0ZGGPTs+8qLMNbDRPVJhFEegR+BU4pdqSUoAzgDhnZRINw4UXOyKZz+/zMbR1/PIqQlZk2NIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WD2riVQlWkWUxxEbS7OkasxsheVswyc6WaMyj3lcmoo=;
 b=Q13tumcnPwrsoqbB1bBsGABGuVFbsAv5qK8N373JCLs1iSNxrfh1tzL3B12oS+yTvAyQorJXG0adI2x+ZpxJsuEHRrOp+zx6bZ3s1n2Souxb8l0M1pgDs17K2vvUOLpxdZSUcJGj3e0/pgjMxlFN4UXuMKLUPMrprtbIWti/9O0nUC799Yh93qk+2d8gZAfLg2eRHW80r8gsvK9rvFBNhcOttzA5sL6iEqNDOgwtXffzE74AEtokLU0Ymnb/rsNkI9DUtZCsi5oN94IvSDr3hoOrS0OBj+03bZ+ARYUcWtVuBDPzBHEYZmCBSWQNG+/T025amWnOzDL/n7y5jTW6Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WD2riVQlWkWUxxEbS7OkasxsheVswyc6WaMyj3lcmoo=;
 b=Rx9iy8RUVIXVAngyoNk1y2+ttoAt3ydsj5CRBc/qOQITz/dHIQ/XUhCuYQeRmr5wEM2W73pwGp5IsyAl860I5z+KjHjFLvy2M0yEW5UwuR7ofH0QzoaRgnLDSEMBMeJ2jlVCEpN3aEIQP0V+i+TxHOgURCCIFklUIi/h2135o4c=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2810.eurprd03.prod.outlook.com (2603:10a6:3:f2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Sat, 16 Oct 2021 10:39:35 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4608.018; Sat, 16 Oct 2021
 10:39:34 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 6/7] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [PATCH v3 net-next 6/7] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXweelrKrYprmug0eA9zwrcaKgW6vUyRyAgACnS4A=
Date:   Sat, 16 Oct 2021 10:39:34 +0000
Message-ID: <53cce32a-c419-c9ab-1965-a6afb865b4f6@bang-olufsen.dk>
References: <20211015171030.2713493-1-alvin@pqrs.dk>
 <20211015171030.2713493-7-alvin@pqrs.dk>
 <20211015174047.6552112a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211015174047.6552112a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a4baae0-ef44-4b9f-80ae-08d990913eb1
x-ms-traffictypediagnostic: HE1PR0302MB2810:
x-microsoft-antispam-prvs: <HE1PR0302MB2810A6B364AF85EE0232D59B83BA9@HE1PR0302MB2810.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wxxLgw5tihQn/C2UqIkEY/VzW1pjKOHdS0wRvy9P3LO+C7qnUmbIoAxDZ3KH2hNuTJrc/hwf3zcIFCvo3YdUCHpKLqt7hqYhCybge0vWhTkVjpzr0lCWLdvUDf3KH6/rOXnFjQmL3f6zkKRG/Wy19Lja8jsVDTUpJGD/Jnl9WZKZSRcwbpeoQIITc4Wyn7rhJBFF1YjN0U1PfMl4K5utjk8nqtRm2Wx/+iq+cEgGzYuOaz4nNZXdZhy7jdLpb0cOkPkpkQCCa07qtJefmrSD9IJABVziMRzIqDx5uhzqCdPq+yXN7i2FA7dT4i8k0oq1UFzoOHs72HV4k+kurbFsw3rEaKJ/Rp8uGJiV+tSdmd3Sq0R9l8T9J/VikRWWfH0UsYSostrKjcBkxJFbNvb7ju9Q9Tos2F1HlBGeNB+2UczUQeXpgtq7mvOK42MmKWCmbraVTI8bgYMTZwCtHJxGzZssS1Gv66oFOOg1woWtcDGdZsgafwovRPzmNn1ZIyv5Y5fpik/7vkRuTuv4Bfm/ccqtKhzgq/dUhYG5CVQVswIYbnk9iqzj57ve5Uq0LbSnLyNhPhPLdoZ7RGQEpM0Qk8y97S9ztHWeSS15G92ITcpINWC+J9m/pgry+pmByW+FVmt1aHNn2h0mZeQHf4p/ShXdMYEVaII3AzjkKrTfXUkhKUhR5yAaJClvAIEZhmIye1MYa5i5V02TS9taTiCylinkPx5jnRV/5uPJV/lbLfGbXFAy6Gc9xPQnZs97fmgvWVUcFwbhsJc6cNvwG9rSoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(122000001)(54906003)(38100700002)(85182001)(26005)(31686004)(6506007)(86362001)(2906002)(4326008)(83380400001)(53546011)(8976002)(7416002)(85202003)(186003)(110136005)(31696002)(66446008)(8936002)(66476007)(6512007)(64756008)(6486002)(66574015)(38070700005)(508600001)(36756003)(66556008)(71200400001)(2616005)(5660300002)(76116006)(91956017)(66946007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anZqMWtBendjZWw3L1U0SnRWQmhnYm9yR3VUYkczWUZ4dGREUnRhcFExbXZS?=
 =?utf-8?B?eUlNeitoNmxFR3NGaExieGkrZEFOK3RUYXlyN1B5MmUwQ0tMYlBoWE8va3Uv?=
 =?utf-8?B?dEorc2IxOTU5MDJKWjhDMkliUDJyZ2NwZ1dOT3RjRkl3MWwxLzhLTnZLek94?=
 =?utf-8?B?aTJ5MjBNY3lLemtVZHJZRThMaWNXL0hBQ3oxSnBsUEhOc0tKZGk2WnJNVWFV?=
 =?utf-8?B?NVRPT2RMNXhwQ2RqTXdHSFRSMmQ5aDFPbWEvR0piaURFcldBQWdYcUtWNHdw?=
 =?utf-8?B?Q0VjKzk3bTdMSWhJYlcwWE9udlFiUElMT25MeG44bVh5SDlicWNzYmRXSjFY?=
 =?utf-8?B?ZWlSR0xkYit2WTJTTkgwQTR3ZnZFWm5HMW1sdFNiRWhYeERwUy94Q05lWkh3?=
 =?utf-8?B?SmJpWnVzUUZtZ0wwZmNxT1EzRUZjU1VLdHU4bDdnRTU3dlQ2aUI1VWtUbDdM?=
 =?utf-8?B?dkZ3Vm5XUHo0NlpZeUYxOWNjVDVxWG96SVQwSFdGOG1yMGxOQnRGemU0L0lz?=
 =?utf-8?B?YkR2NW9ma1phNFY4VHFwVG9KczFvd3R2dnYxREErME1VRCthZVdYNlhXYzZq?=
 =?utf-8?B?ckhwbGVaVEhQeDZ2RFNONDFNTlVCZVJkTE9GQkhaMUpPZHdrVDdBOXpWbUEv?=
 =?utf-8?B?WXhBUFZ6d0pmMmlNQlFYL0k4Zk9YM0plQWd5WHVJK0xNeXR1U3p1N0RrTWNB?=
 =?utf-8?B?dEgvMUZROGFJY2tqbytWY1Jzc1JML2pkRThDZ29DcU1oNG5SQXJaa1JoYVZo?=
 =?utf-8?B?QTZRVlJpWVk0RndPWTdURndrYitFWkJrVDJSZlI5Mlc4a1VCNHE4U0QyM2Nu?=
 =?utf-8?B?UCthOHh3MzFOWDRNOXRqWUVaVzkzV1NCQUd0Y21vaUJNZnhVMEtpb29ybVRE?=
 =?utf-8?B?cU5VV2tCT2s0TW1IOHptaTRURmJMUWJRQ29DN2pxRnF5cEFrV3BmbUZyV09I?=
 =?utf-8?B?dDJ5NEh5ZEZIS2xDOEVmREFsWkRvOW1PZGMwOWV0TEVBMTE1SnE2Tldaelh1?=
 =?utf-8?B?bXdURUlKUFRNY3JBWUttRDd2V0JITUl4djllMlhHekRiS1hBZzE1UzVzSits?=
 =?utf-8?B?VS80eVNpZHhjdnNVdXpZQy9ONjFGbzVodWpScnRiY0pDRWZacUVuTWJibmk0?=
 =?utf-8?B?K0RIcWlEb3M5ckh6YXJGc1U4dVNrcUtZZGlUcjZ6Nm9TMG1KdjRDT04xc0R0?=
 =?utf-8?B?cnpHdHQ4c3VDeURPQmQxOVlxdFFHUkN4cHA2a3ZNdE9pZWhHMkpJQ3dDNVRh?=
 =?utf-8?B?d1JWdncveFFQeFo1YkNXZEhoSS9kRTlmMFdqS1pnOW9vSnJOVGNPY0ZJbkhO?=
 =?utf-8?B?M25sajFXczZXWkdXcVFISWp6TXltMS9PYzdyRzBkeTY4dHNvSDRZZmNNeWNU?=
 =?utf-8?B?UHQ0RGNoOWwrbElMcWttUHhiSWwwU2ltTko5bjIzVzBTTEQwVmhGTCtvNEY0?=
 =?utf-8?B?dFRRaEdIUk9Ra1d2ZUs5TUxyNlY2SXVLWWVSQ04yTHJwcDJGMHhvejNGQ0Js?=
 =?utf-8?B?a3Bsczh4WHltSDN3aC9mMzNPS1ZXdExoNVc5aDlNT3ZodGxkRVprcWVqbytZ?=
 =?utf-8?B?akp0R3dONGMwZXZ2SjZLRzBvR1Y2U0JrMHhYeXRuZVBGcksvWmh3VU80VmxN?=
 =?utf-8?B?QWdPb2g0UC81cjRqZ0FLaFJRTW11TmFuQVNySVI4L3p5Qi9ic3htcjlrcmZw?=
 =?utf-8?B?ZUQ1cG0vYVB2TmlIaGFHZkd4UExCc3ZpQzBxTWZYd2V2cU03MDZkQlh1T0Z0?=
 =?utf-8?Q?ag7KBXJjfHKKMSMDBBYdviwT+S5Oigwd778M0PC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A6B0C00843DAE41A76833F766B4B4D0@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4baae0-ef44-4b9f-80ae-08d990913eb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2021 10:39:34.4944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vtUDxFzO8oj3vBFdfqQlVBahzvBcUl1lLs1lvcQKnkKjwNzetEY2Wg5NhdAXo0xQv9uz4dr9109HEoa9hVPKSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTYvMjEgMjo0MCBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwgMTUg
T2N0IDIwMjEgMTk6MTA6MjcgKzAyMDAgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+PiB2MiAtPiB2
MzoNCj4+ICAgIC0gY29sbGVjdCBGbG9yaWFuJ3MgUmV2aWV3ZWQtYnkNCj4+ICAgIC0gbW92ZSBJ
UlEgc2V0dXAgZWFybGllciBpbiBwcm9iZSBwZXIgRmxvcmlhbidzIHN1Z2dlc3Rpb24NCj4+ICAg
IC0gZm9sbG93IEpha3ViJ3Mgc3VnZ2VzdGlvbiBhbmQgdXNlIHRoZSBzdGFuZGFyZCBldGh0b29s
IHN0YXRzIEFQSQ0KPiANCj4gVGhhbmtzIGEgbG90IGZvciBkb2luZyB0aGlzLiBUaGUgY29kZSBM
R1RNLCB0aGUgb25seSB0aGluZyB0aGF0IHN0YW5kcw0KPiBvdXQgaXMgdGhlIHVzZSBvZiBzcGlu
X2xvY2tzKCkuIEkgY291bGRuJ3QgcXVpY2tseSBwYXJzZSBvdXQgd2hhdCBidXMNCj4gdGhpcyBk
ZXZpY2UgaGFuZ3Mgb2ZmLCBpZiBpdCdzIE1NSU8gYW5kIHJlZ2lzdGVycyBjYW4gYmUgcmVhZCB3
aXRob3V0DQo+IHNsZWVwaW5nIHlvdSBjb3VsZCBwb3RlbnRpYWxseSBnZXQgcmlkIG9mIHRoZSBk
ZWxheWVkIHdvcmsgdG8gcmVhZA0KPiBzdGF0cywgYnV0IEkgdGhpbmsgeW91IG5lZWQgdG8gc3dp
dGNoIHRvDQo+IHJlZ21hcF9yZWFkX3BvbGxfdGltZW91dF9hdG9taWMoKSBiZWNhdXNlIHJlZ21h
cF9yZWFkX3BvbGxfdGltZW91dCgpDQo+IGl0c2VsZiBjYW4gc2xlZXAuDQoNCkl0J3MgYW4gIlNN
SSIgYnVzIGJpdC1iYW5nZWQgd2l0aCBHUElPIC0gZGV0YWlscyBhcmUgaW4gDQpyZWFsdGVrLXNt
aS1jb3JlLmMgLSBhIFJlYWx0ZWsgcGVjdWxpYXJpdHkuIEluaXRpYWxseSBJIHRob3VnaHQgdGhp
cyB3YXMgDQppbXBsZW1lbnRhdGlvbiB3YXMgc2xlZXBpbmcsIGJ1dCBhY3R1YWxseSBpdCdzIHVz
aW5nIG5kZWxheSgpIHdoaWNoIGlzIA0KT0sgaW4gYXRvbWljIGNvbnRleHQgaWYgSSdtIG5vdCBt
aXN0YWtlbj8gU28gSSBndWVzcyB5b3UncmUgcmlnaHQsIEkgY2FuIA0KZ2V0IHJpZCBvZiB0aGUg
ZGVsYXllZCB3b3JrLiA6KQ0KDQo+IA0KPiBJZiB0aGUgcmVnaXN0ZXIgYWNjZXNzIHNsZWVwcyAo
STJDLCBTUEksIE1ESU8gZXRjKSB5b3UgbmVlZCB0byBzd2l0Y2gNCj4gZnJvbSBhIHNwaW4gbG9j
ayB0byBhIG11dGV4Lg0KPiANCj4gRWl0aGVyIHdheSBDT05GSUdfREVCVUdfQVRPTUlDX1NMRUVQ
IGlzIHlvdXIgZnJpZW5kLg0KDQpUaGFua3MsIEknbGwgdGVzdCB3aXRoIHRoaXMgYW5kIGZvbGxv
dyB1cC4gSSBzZWUgYSBrZXJuZWwgdGVzdCByb2JvdCANCndhcm5pbmcgc28gSSB3aWxsIGJlIHNl
bmRpbmcgdjQgYW55d2F5Lg0K
