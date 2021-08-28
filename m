Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8003FA514
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 12:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhH1KvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 06:51:21 -0400
Received: from mail-eopbgr20090.outbound.protection.outlook.com ([40.107.2.90]:33156
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233763AbhH1KvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 06:51:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoGfa3TO+0SQVgADdEP98jGeCs6oWHg91LDvHMa1q4kFbbj6eApKi9DjwaxqvQwOu96MuFvvkUhz4yl5799dbTwixLy7wvRssvhjTQHvh/IcaGUod0s1zoAz+pWM79EshIE6YoFasiOsnvUT0TWVXeBcJADaB4sWNmmUv7IXKDw1ZjcqNL1WiJ7D6G4aNE0Kj8r0cH3TrGOAm46kiw3bs3EbC7kReFYie2W7ojZp4Nyot+5CXDOAS5026q3XUAXb5ekzauzfkhqQMA9bobJSMQtNm21T1caadeRdZPlDT4lmXoC2fgJXky0XmRk1tpT41fldteQhK0DGb1ns8KRhBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eR4scDM6sKZFu/lf0t4OHgY2Kw4p8P2tcA2c7oGfX4=;
 b=XMZh5jFfHnPLBsKjQC82IBCgDPofbyeQjBG/l0Wo/WCJqbh+i7nJgI4zsWATGdjxMAHZGkhadi3yDX32GAxqSNyJkdxRyZnid+1l+KucPLjsKdepICa334czD69PuNASStb3WhpIOzsm+k3H3udCqGDaPlhrNyCGwbNWhHfnGjXLSIagyPFokAwccPhDw7tKdnQvKQRffVY0FqeyOyMprCy/V0+1HDGXimuYZ3wBigh3cwA1Kan1FC5PXrU/hWYSbW+/43sUMyb1zaa91nJ8SIM3yt4G15/TaKBJafMgAOQYiRmOh0uG69WEahvYwKyQcJ3KJyJ3qddeJuKIiC0qRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eR4scDM6sKZFu/lf0t4OHgY2Kw4p8P2tcA2c7oGfX4=;
 b=SFZJj53MADlB2Vu3o226gy5IUMN89fW+Ze/v/22mLGWJYOBy3JtUZiOS6L5iKJkQ0iP1g5tvn/tWojIWvNW413pQ48JtjpmL0af8wGgZA9SHAtjPVmV7MwkmyxHqQchua7vjww3iJXOyqewK11QQmrdOiJMPZx13V7RYrpBYJ1A=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR03MB2953.eurprd03.prod.outlook.com (2603:10a6:7:57::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.21; Sat, 28 Aug 2021 10:50:20 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 10:50:19 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free bug
 on module unload
Thread-Topic: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Thread-Index: AQHXl4x7EC/JWmhXnkaFSDyQCHXzdauADasAgAAOkQCAAAwjAIAHyD6AgADVRAA=
Date:   Sat, 28 Aug 2021 10:50:18 +0000
Message-ID: <b16bd774-b641-f1b6-49f5-9ea5e3498ee7@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk> <YSLEZmuWlD5kUOlx@lunn.ch>
 <cb38f340-a410-26a4-43be-5f549c980ff3@bang-olufsen.dk>
 <YSLazK4TbG5wjHbu@lunn.ch>
 <CACRpkdbUMSJxv+Gmbu2rpsWRMJyTy=ftQqhRuF_4FGb0CV+hqw@mail.gmail.com>
In-Reply-To: <CACRpkdbUMSJxv+Gmbu2rpsWRMJyTy=ftQqhRuF_4FGb0CV+hqw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31f064c6-1a8b-4cf2-2a27-08d96a11a0b6
x-ms-traffictypediagnostic: HE1PR03MB2953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR03MB2953D087F0AD70452F2EF8A483C99@HE1PR03MB2953.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oJsLKsD9Fs9HK08TtmhX8MT1Gy/5M+JwSkb6xplWkAxwpkGPqIzjiXTmvFrRk+QZUPNU/KqBo1XE8P0y3DYTrWzS9tuIXp2VTq9/kPPUYrEoK2qA3nCAfg6i9LiSRSjSTYSI7YUHj4NDAzUvuFV0RrPlzkUjChFW3hu4eTiAIKUam4MS1HsjIvhNYCWGj/70nasimnd0Qc7QZzHUmpVZRD6dL28UgJQaXHUBD4R2SUPM5KkVfFsciJpINr+ba3bLxpbu4E+rkb/e7/hfgVLuOjFSkYpKWWfC0Ha4uDcC657gVdOPSVPfqTm0J3BTc5HMdyU7gp1y8lpRxTQh6TAWO9avTS7b2K7yJGon9N2E35JL0MxwDQjYrODv3F9VLfwXRD1CZm7J9tzuIr0MXRt+lK91hjTPMcZSrQXXdA5rI5BjraSz2Gj2eRk7De5mxbSXfLYIdao6FlhYLMG2VX4+J5VHrTR8bT5ulDTe4MjqXCF823ixW/0bLmsLZAtEEe+IjUOm0svdN2FCiEz+/EK87EEQFYePx1MbqRBnyuvEBcGKxuVzA6Ijg4OFSAbl3Kp02HofJf0gFTd4sClzLc28uPZ+yMGw8ISMX+yYx3tiRURZj5tyYmlhV+Muz/NBHwH5fUN7JRfloVvfSTYeuW4OW06gCGSPBKOHCcBitSu11sPO9IFjufiWT5VzDKgM9ERVheF+qAN03bc7/B+K5m5Mos8/JKEVvT3681JSJRk9AxLfhK0gmmLhrQbeoKipCpcdPNln3Ri4h98ftLvc5BuefA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39850400004)(366004)(6512007)(85202003)(4744005)(26005)(64756008)(122000001)(91956017)(83380400001)(38070700005)(2906002)(66446008)(8676002)(66946007)(76116006)(8936002)(478600001)(110136005)(186003)(54906003)(85182001)(5660300002)(6486002)(7416002)(6506007)(4326008)(66476007)(66556008)(8976002)(31696002)(316002)(2616005)(36756003)(71200400001)(31686004)(38100700002)(86362001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXV6VEpVZDJ2Tys0QVRUOUdabktKR3RHb3FhMFM0d256eVpjeHdhM3ZTUFlT?=
 =?utf-8?B?TUVIQU9mRmt4Ky91eXEwT09YanZLRzZZZlN4NEViNWdIb0F2RUh1RkFqTC9o?=
 =?utf-8?B?dGtBdXB0M3pFQW5GckI5NDloVkZwTXhpdVAxNW1Nbm9jd0hoQlpWY3lnYWhG?=
 =?utf-8?B?RUtQRHdNNU50ZVJ3aEVZRit4TlV6dGVqOGQ4S2dvdmJwbHZNeW1HaVVnUmF0?=
 =?utf-8?B?ZVVGZ2s4Z3E0ZGFXaUovZ25zMjR3bzhzeXRHRng3aGtzVm9LdVRteXJVMmVN?=
 =?utf-8?B?VEZOV1IwRitXQkY0RCt4S1RMN2dvd3NnOXJZbEZCNmhmMzNJRDBUUjR6S2cw?=
 =?utf-8?B?bXdTR0lwTmdHb0VtUmpLa3NwRmRZUDhaMjdtSnpJZkNxQTRvcjZ4ZkVpT2tX?=
 =?utf-8?B?aDV5VXR1blNmR2djYTMySmJnZGJSUE9SQk9MVlBNOHcybGFidEhQaVdKWjJD?=
 =?utf-8?B?MWpXOFVTQ0xEUEpZYXpRTTJheUxVRHRvQUFiaGppZzcyNFFWaEJuaE1ScUVS?=
 =?utf-8?B?UytHNjFvWGNJam9tUndRbnM3RkhHai9mWjVyS2cxd05QTm12bG5ha3RQYTcz?=
 =?utf-8?B?MjBmWDVJQW5kNm16R2sxSVdSUXU2NXBqQW03ZXN4U080T1BhaW5jcWl4Zy96?=
 =?utf-8?B?M1BjREdiU0JLRExObzNUU3R4a2JBRDlCeFZNcEdTNngzYjhnbHVia0M3bDc3?=
 =?utf-8?B?NTlOaVRRYVdabjVCOTVWN2VhRHhCeFAydjVuVmxLQ0hhZXQxcjZZQ2g1bitv?=
 =?utf-8?B?VURhOGxKQnlZVDY1MFdYWExnUmhBaE5ldFVBUkMvSUN5NGNLdUlzZEh1S2R1?=
 =?utf-8?B?V1VUOTNFZnZRUFprb0N5UVhGV3pON0JVSTNLOUFqUW8ra3k0Nzk1a3JJMEgr?=
 =?utf-8?B?UkxLZFIvNVlENFVNUnJjRkpvWGZ4Q2E3NXh4T0N2TDY2dmhWM2U2Lzl6dGc1?=
 =?utf-8?B?YU5NZkJLZkN6WWVkNjJRNll1WHFYcE1CWUxENGFCTFhXczBqMy9ORXVrc1NK?=
 =?utf-8?B?K1FRSzhWY1lkUUxDNkpMNVY4NHNwVjBBTzBXemZnTk1nTkpkL3hBdS9kK1Rw?=
 =?utf-8?B?R0RsMTZteFAxMG95aDVPS1MzQm5wbnQ4RERrOHJlRHZBYlVNQ0diaHdua3Zz?=
 =?utf-8?B?UEplWUR1TmJvZ1FmamI5K2d1L21oUzhPaUNEWjVYeG5SZXZxdEx6enI0SEVm?=
 =?utf-8?B?UHN4THh3ZUh6amR2cnlQSnJLK05hTlQxMnU4WDFpUjZIbVZ6amJBSTVVRE9M?=
 =?utf-8?B?WWZKeTNhaFg2dVFZdWRsYWYwMnZGcitTT1F1d2xFT3BET3J6clgxWFIvWHV5?=
 =?utf-8?B?LzJpZVVWdVRqNGF0TFdkcS8xREpLZVpaQmtiYXFzS3F0dEQwNUtRQlNHdWFs?=
 =?utf-8?B?ZTJJNlVTM2JDREVMWjIrbVR0SklzNWNRM3pRRXl4NG1qUTJxN2JZcUx4MFBW?=
 =?utf-8?B?NTVyWlRHWitGZUFHRCtaaWpKaXd4bmhlM2NuTC84TzRHdW5DNEUyS1lDSFFh?=
 =?utf-8?B?QU1vZmhFWmVjM0pQWXpEdmtCNTBqVTQ2eXRSRUg2aFNGZGh4T0VIVTY2MEww?=
 =?utf-8?B?dGhTTVlVUytQWXl2NHBEZXdPM2xCR0drSkZMR2xUS0lUY0xUZVQ4UU9ydjR0?=
 =?utf-8?B?d1BLWkRPYjQ0MFIrK3lwVUZ1U3ZCeHc5NVRMTW5TNDA2RVM0L0NGZE00bkg1?=
 =?utf-8?B?Snc5MXpVYnJaMUtUU1BBTFhJa3ZGdDBQL095L3FzZm9JRzlyTWlVd1Z3d2tB?=
 =?utf-8?Q?LojvkTihNXCjueEQ1eLhC2UMjEIe8K8FI0uF9zr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FF5D0B81CBC334884BCB8A45BB76F8B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f064c6-1a8b-4cf2-2a27-08d96a11a0b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 10:50:18.8879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Udvudk+eMbOqGa7fu4LriFjSPkD5o+HgZYlg5OynSgKty4ZYAdnFP1ixo6IU8Ii/MTqBODzDJ+KA3VAkny5xrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yOC8yMSAxMjowNiBBTSwgTGludXMgV2FsbGVpaiB3cm90ZToNCj4gT24gTW9uLCBBdWcg
MjMsIDIwMjEgYXQgMToxNiBBTSBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+IHdyb3RlOg0K
PiANCj4+PiBObywgdGhlcmUgaXNuJ3QuIEkgbmVnbGVjdGVkIHRvIG1lbnRpb24gaW4gdGhlIHJ0
bDgzNjVtYiBwYXRjaCB0aGF0IEkNCj4+PiByZXdvcmtlZCB0aGUgSVJRIHNldHVwIChjb21wYXJl
ZCB3aXRoIHJ0bDgzNjZyYikgc28gdGhhdCBpdCBjb3VsZCBiZQ0KPj4+IHRvcm4gZG93biBpbiBh
IG5lYXQgd2F5LiBTbyB5b3Ugd2lsbCBzZWUgdGhhdCB0aGUgbmV3IGRyaXZlciBkb2VzIGl0DQo+
Pj4gcHJvcGVybHksIGJ1dCBJIGRpZCBub3QgdG91Y2ggcnRsODM2NnJiIGJlY2F1c2UgSSBhbSBu
b3QgdXNpbmcgaXQuIEkgYW0NCj4+PiBoYXBweSB0byBkbyB0aGUgc2FtZSB0byBydGw4MzY2cmIg
YnV0IEkgZG9uJ3QgdGhpbmsgSSBzaG91bGQgbWFrZSBpdA0KPj4+IHBhcnQgb2YgdGhpcyBzZXJp
ZXMuIFdoYXQgZG8geW91IHRoaW5rPw0KPj4NCj4+IExldHMgc2VlIGlmIExpbnVzIGhhcyB0aW1l
LiBIZSBjYW4gcHJvYmFibHkgbW9kZWwgdGhlIGNoYW5nZSBiYXNlZCBvbg0KPj4gd2hhdCB5b3Ug
aGF2ZSBkb25lIGhlcmUuDQo+IA0KPiBJIGhhdmUgbGltaXRlZCBiYW5kd2lkdGggYXMgSSBhbSBl
ZmZlY3RpdmVseSBvbiBwYXJlbnRhbCBsZWF2ZSwgc28NCj4gSSBjYW4ndCBkbyBtdWNoIG9mIHdy
aXRpbmcgY29kZSwgYnV0IEkgY2FuIGNlcnRhaW5seSB0ZXN0IGEgcGF0Y2ggb3INCj4gdHdvLg0K
DQpObyBwcm9ibGVtIC0gSSB3aWxsIGZvbGxvdyB1cCBvbiB0aGlzIGFuZCBzdWJtaXQgc29tZSBw
YXRjaGVzIHdoZW4gSSBnZXQgDQp0aGVyZS4NCg0KCUFsdmluDQoNCj4gDQo+IFlvdXJzLA0KPiBM
aW51cyBXYWxsZWlqDQo+IA0K
