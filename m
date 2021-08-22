Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D004A3F425F
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhHVX2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:28:01 -0400
Received: from mail-eopbgr140090.outbound.protection.outlook.com ([40.107.14.90]:57612
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229969AbhHVX17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 19:27:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIdb/fgLtK3D4xcS6JzX1alEb9ztOTgNdWfhWP8DitAd2IUrxEwSEs2gIKRaDasfQ67dB+7OaivmxHfmCAkLKFjT9CQF3mwKe4Oi3RkUMHWoLoHGSTHlpHp7KKYvWI2S8Umdem5Qg4DnRJJKIRA4INhSZukA7r6UDjXsXu7clzg9Q08Oep49w4B/WLdgENRGxp1sLHMofg/yXvClm1DS73r+Zu1tT5390deSlveYGRT/hRDJ/xho5Q+Y5/DlanBAslbdBuW+G53cWFnmyrnLuVm2vTd019Gbh/35Z215VA56OOshwMLFZA768RCBydaCSCxC74dXocz9x5T4AQaJQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/SlBc1hV/VUEHT1wmRD8tpGXI2BSbe/NMBfAJHGaB0=;
 b=A0i6bJ+zCC0FeyyP0rWRLZWQVcl+ORiSDS8j1Yk+KluBzbnVUpt9VvWg0emF9w0SnwmD+wQ/W2j/8X2pfpWUpc+hXFuHVx+LIIJxfvDTVg2Yq0qjLuL2jtvCM0mOZcEtDbyYA+DOrcO2nLpoM3nfbp42sKHumPBio2+4bvq35eWZbn/wQT7qMYV4if+1wCVBgEqDIrMPFbELrlcfd0G1XvPwM+T1oGZ10dCBWvNNFzaJ4GzrFIG4aoXvyVWyPmYJGx86kWHEnwreIwM+LiHhV+PzGwkSJKf2Hf4onzrwnPnmzrsoNXndNcf524UDFkYrN0qhBuStGukS4GIQ2mJSZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/SlBc1hV/VUEHT1wmRD8tpGXI2BSbe/NMBfAJHGaB0=;
 b=hKXoMD7oq3ldno+UtgU9xyGOtA+FA88rW/eLXf5zFFLAQtZeSGdNnwKwQ0Ka4/dSPPiFhYpsxpC61+13p/0xo/5SWhRfCHJWqOJq2JuSHAECVd628B65UN7YDhNQpUyx6QlgLD/F/5xvz6BPE6YdY26NShOa0OOH6x21pN9Msb0=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2780.eurprd03.prod.outlook.com (2603:10a6:3:f0::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.19; Sun, 22 Aug 2021 23:27:12 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Sun, 22 Aug 2021
 23:27:12 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Topic: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Thread-Index: AQHXl4yAoQircf8Jw0+inLvWs8TmmauAE7kAgAANXwCAAAa0gIAAA5GA
Date:   Sun, 22 Aug 2021 23:27:11 +0000
Message-ID: <c4a2302e-b961-fc2d-c0f3-c3123dbaab83@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk> <YSLJervLt/xNIKHn@lunn.ch>
 <eeca192a-ef7f-0553-1b4a-1c38d9892ea0@bang-olufsen.dk>
 <YSLaUUe0eBeMQYtj@lunn.ch>
In-Reply-To: <YSLaUUe0eBeMQYtj@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d5325ce-e1e3-46dd-d2fc-08d965c45e5c
x-ms-traffictypediagnostic: HE1PR0302MB2780:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB2780A9CED3C334DC72D9D22B83C39@HE1PR0302MB2780.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AhF3c/1aRRC8G6uJ6cNg8z4DsEU0fVDSSlpPxGv5XFR2ahtIEEpSicS5hA0P2M+9I/q26c3yxW61yk4MB7ufDTvQ9Q+kW1Z3C2LF2fn8dbOIwfzylueUPMBFi+CrvI4aptsdh4cYseJCaIo+W+CNKbzLg43bxu3a+TApzv7cfeuafcBzkBOQmsn5nB+DmJkyU+3F/I4xSJ/j11APoltne8x3S1u1E4nc9GownwTPZpS71fWHhUd7SIsyxqL/45uD+7DfM1nA6CcP9AxwdjzRhMXeEPu8tVD7TyDHeGuVFowW8FdlYFxwXNDk3Yg5z4F/q1EYLHpQHh3bmNY/SafOSGB0O/9x4SITg/BLAepAckBKGo8o5mejj4PRXy1YHh41JfBUrCwptEMGTq9WYeRrxqqzO1QfDK9h99HGOoWUlmULgtmCJmoKCIYrR9FpH8fsBHPsD5w6AsTv+whPzosqxzYUoZyp7NJ9cWOumiAflNsX7HtcZ7Rz/bq2S1j69J4F7mNvko1lEoLC9e2Yk6tcY0qe1cGOb0Unq/HxWjsbCzczhPGK+flJrayjv8yrTpKZKs8nx3KTFvacKd0f1sUQNwyJbim2sDhULifvpHBY2aPE6bTNyTPmJW//5evj9Cd97syn7m7+I19p9SpHA6wlTeuRT9FSbUV8bKq1DZyzFwnGLmg5lw+id0e0cXrf9QdhO7pMkltq/YRq9OuVjZnCARUpiRxKqKWtQts4XpIYGNuzeUQWv5+mEx38uvrlCeqgjUBhIZfaNXLAZVfcVeAcHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(346002)(376002)(396003)(366004)(136003)(8936002)(8676002)(7416002)(31696002)(53546011)(8976002)(186003)(91956017)(76116006)(26005)(83380400001)(2616005)(86362001)(122000001)(38100700002)(6916009)(4326008)(5660300002)(6506007)(71200400001)(31686004)(4744005)(36756003)(85182001)(66946007)(85202003)(478600001)(6486002)(2906002)(66446008)(38070700005)(64756008)(66556008)(66476007)(6512007)(316002)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjVpYXQxOGFBVXh6dW1XcVVaTGNqTWlBOGJDc0pFTGJIaFVjM1dxUnVyRTJK?=
 =?utf-8?B?bk9EWFkyZld6Zks3eTVpWkRVVW42NHB3eTVqT1R4MGFNOXNscTZKWkhWUXJa?=
 =?utf-8?B?SEM2eWZnYnYxQlcvS09WSlgrbE5ZTytZY21pQUtyZkpoZk1PWm1MZDRUWE41?=
 =?utf-8?B?OWZOWUM5SGZiZitBTXQyeDYrTlc4UmdxMlNNSVhPaXJ6REx1UjZLRFgrdHdB?=
 =?utf-8?B?emRYeXVEQWFVa3l5TkR2d1loNkxWS2Fqa0RycVAzWVZsRkdYUlhZL3R6bFMy?=
 =?utf-8?B?WXRKWS9JcG1jTjB1aDFObVlWNjhWaGR6MjEwK1FsMDhEYm5aNUVCTGdWWFZZ?=
 =?utf-8?B?MVk4bW12WmIvRmlrRlh0dDdqWlBYSE5ldWNTWUJWeUxjTFFXWG1kM01JekMr?=
 =?utf-8?B?dTlDRnZyM0ZzaGJIcmthZTBsUDlBbWQxMHp1djY4RGJBblliRERuMWg3Szlm?=
 =?utf-8?B?dWtOU05oamhGcVEyWmZ3YzdwaXhGTWtsVERiWG04TDIzQlNSREJBZU5lQXR2?=
 =?utf-8?B?UFRQWUVsYXBXampUMDY1REJpcytTd3JQc3FPcm5HQy95ZmNkTHZ5dFZONjVG?=
 =?utf-8?B?cmZFRGkxL29jcmVSZFE0cGpWTjlGKzRCNXk0KzVYeE02R2JCRUlNQllpZW1S?=
 =?utf-8?B?aVROVjFmRG9QSFJ6NGNIZ2Nka1h5R3FPV0QrYThMRU40R3ZNODY2djZ4VDJj?=
 =?utf-8?B?ckJKa3p6Uk5GQ0x2d2xEeGJvZGRjTTlQcjJNeVl2TkI1Ulg2K08ySk55SlZI?=
 =?utf-8?B?MkRuSkgwbzN2MC93OXZpMCt6b29uTXpnNUR2K21DSnVRRkp4TzhaeGJUQ2FR?=
 =?utf-8?B?U2xBdklacDZwNXh6SG1RU2lhR0VNWC9KS2o3Z3Rra1F4U2s5UDN3bjlNSFZ4?=
 =?utf-8?B?TUtuZ3RJakN1bHNyZ0tIdC9sZXE1UGloeXdYVjdvM1k0Q2RWbHM0RElYakht?=
 =?utf-8?B?S0N0WmFkTDdmMm9KMDBzOHJRbWg0bEh1TUljcjNlNzgyY3Z0TUdlamZrZUgy?=
 =?utf-8?B?ZVNQT2xKRzlRQmROVWpuTnhyTmJwc2tWdnFBbjFJK0RYYWRjMUpqWUJEOG5l?=
 =?utf-8?B?ZEFCWVR2emlUb1drRTRYWW5vUXhnMm1aUFRmM09PSGVEd3pkVGlONFBsV1FU?=
 =?utf-8?B?cENnY3MrbE5JNTFlZkJ1SHBCdEY5cnowMWRWbkMrcVpTZWlqODBIMTFrOTFn?=
 =?utf-8?B?MkNrQlYyK1pCSkJ4dmJpR2xPOWp3bkxzNXBuZzdNZ0xjbllNWDRaNTlsb3dM?=
 =?utf-8?B?MFZNUmN4bXE4UW1FdEVvZUczRXFaZjl1eTBDS3lGQmhWdEQvc3d4RWl6TFY2?=
 =?utf-8?B?bkxkbEk2NHZQRmdscWk3UmloTGs2UkFHdjlmQ0VZRjAwSFdjNnNCak5VU3dJ?=
 =?utf-8?B?ZHFWekpndXZzZzVFdTB4UHU2LytnODczUWNLQW4zK0ZwdnhUUkF2RkJudUYx?=
 =?utf-8?B?S1BxUWM1Y3E3MWRNdzlSNzRGSzJIWmNxK2dNUXRJR0h6ODFHbFN0TW9sTWtx?=
 =?utf-8?B?ZW00UGFNVHl4U1VHYUxtZ1RyTGZ4U0FJL05VNTN3S3o0djN1ckd3S1lkRFZU?=
 =?utf-8?B?NlBRUS9HaG42K2J6bDhDY2g2RHlpdURxZ2hrZC9CNzE2a0sxY2lFOFIvajNU?=
 =?utf-8?B?Y2o4bzFKdkU4UEhqNlJ2RzNhd1ZXU2ljSC9sUlNSLzYvaGIrR2RXRkNVejZr?=
 =?utf-8?B?L05RS0x5Y3hNdjdzcTdCcHVKY2lsSG5wVEZiTTRabzFISjRob3RQSndaZG96?=
 =?utf-8?Q?lnlVNgGeeAJLxjy97aacvYhWRKizZUK+2ZD2vyr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <282F77BFE16A6D4ABBEFA174C14EFD63@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5325ce-e1e3-46dd-d2fc-08d965c45e5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2021 23:27:11.9363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wnhj+cmBxFEMwWg7SGKhRNdU6uG3nI1pT13pfLR1KYIOKPIx7YkyN7zk/VeO0hLsxYGCDaV8AwZo4Bzm4QZsbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiA4LzIzLzIxIDE6MTQgQU0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+
PiArICovDQo+Pj4+ICsNCj4+Pj4gKyNpbmNsdWRlIDxsaW51eC9ldGhlcmRldmljZS5oPg0KPj4+
PiArI2luY2x1ZGUgPGxpbnV4L2JpdHMuaD4NCj4+Pj4gKw0KPj4+PiArI2luY2x1ZGUgImRzYV9w
cml2LmgiDQo+Pj4+ICsNCj4+Pj4gKyNkZWZpbmUgUlRMOF80X1RBR19MRU4JCQk4DQo+Pj4+ICsj
ZGVmaW5lIFJUTDhfNF9FVEhFUlRZUEUJCTB4ODg5OQ0KPj4+DQo+Pj4gUGxlYXNlIGFkZCB0aGlz
IHRvIGluY2x1ZGUvdWFwaS9saW51eC9pZl9ldGhlci5oDQo+IA0KPiBNYXliZSBjYWxsIGl0IEVU
SF9QX1JFQUxURUssIGFuZCBjb21tZW50IC8qIE11bHRpcGxlIFByb3ByaWV0YXJ5DQo+IHByb3Rv
Y29scyAqLyA/DQo+IA0KPiBJZiB5b3UgZG8gaXQgaW4gYW4gaW5kaXZpZHVhbCBwYXRjaCwgeW91
IGNhbiBleHBsYWluIG1vcmUgaW4gdGhlDQo+IGNvbW1pdCBtZXNzYWdlIGFib3V0IGl0IGJlaW5n
IHVzZWQgZm9yIGRpZmZlcmVudCBwcm90b2NvbHMgYnkgUmVhbHRlaywNCj4gYW5kIHRoYXQgbm8g
YXNzdW1wdGlvbnMgc2hvdWxkIGJlIG1hZGUgd2hlbiB0cnlpbmcgdG8gZGVjb2RlIGl0Lg0KDQpT
b3VuZHMgZ29vZCwgSSdsbCBkbyB0aGF0IGluIHYyLg0KDQo+IA0KPiAJICBBbmRyZXcNCj4gDQo=
