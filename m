Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479BD4311B2
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 09:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhJRIAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:00:55 -0400
Received: from mail-eopbgr130113.outbound.protection.outlook.com ([40.107.13.113]:63669
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230478AbhJRIAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 04:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJwlnDlUSv1GlTRm8oh2U9pZ9d9lg9DUG8f+Gva0IArVz4HrQ3bOSC04plWBUqLxVmbt73V4RACRkk1pUa2WJDZebuo+MX2ZUd+kf1u9A8fRSLVglNVIHUOtVC0ZGhAkA0VkHRV1v02hwFDotqYz34LeBS7U5L+2hRTkQbdaIKUiVAfzZEUAW3Ev/i7m84kOga193rWk8jPE6qOlzxrG1OMEeQ07Oh66sDNn6kUYKmfsaPHZoDbfLWONm15JBIgRGMpdoSirTHBYnmcpnPlSMvtdwpUrVGTLsY8azyvNHH2RBmpnHu28NnJCVUw8wS3clTMrbyINtVX/hiGmcBDtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukZUTLfC/bdElIBNVg/PjluUCy51GK9ABMZM/vE/s0E=;
 b=MZ8XOYyOefvHfveMfj+DjbVoW4iyi/F5obQYj3GaW5ZUxW+xEtWeL6V4B+14v5ajHdnUBbWjyLBrkXhvwARtE/mlgquzBFHesn/7G3HDi7Bt1CdaNHyZ6gZoOPQN4VW9WSxREOp3uNjVx5xqynuRa6ruGQJ6fVwKz0Y1OxyDpfuBX1XSAsjfg/EdKjrHHRs1n+78b8OGixqtNizI1yN3GYYx0zXdMBMYboIJpaj0upnaP6z7Rvq0QMUO2yA8ZkKkFuDRnDEdgpi31Z7o5Vsm4lzZDptI77cy3pjFZwR8CYg1YCeV6TZHqB5kZ4CmG0cHbvtAUljABAFs6uTKqj7JFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukZUTLfC/bdElIBNVg/PjluUCy51GK9ABMZM/vE/s0E=;
 b=olWin40DBsCN/fZo8s+J2hev57oM63hIFJ4fZtodqD0w2oDM+PZuGw9UCK/qRdyGn8c46082yVBmJi/A/fp5F5oVv5N6PpOHK4DxwyqJK50tRAICwLTmDfFNc9tRGziJseeOmojkBWXYG1y5+7b0pajXdyr2SbgAl8tvFp10uog=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2491.eurprd03.prod.outlook.com (2603:10a6:3:70::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Mon, 18 Oct 2021 07:58:40 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 07:58:40 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     DENG Qingfang <dqfext@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next 5/7] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Topic: [PATCH v3 net-next 5/7] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Index: AQHXweeh2ZSouY7skEirLTDENie5YqvVI4yAgANEkIA=
Date:   Mon, 18 Oct 2021 07:58:40 +0000
Message-ID: <8da0a0ce-6f62-ca02-0b72-bcf5ff4ec493@bang-olufsen.dk>
References: <20211015171030.2713493-1-alvin@pqrs.dk>
 <20211015171030.2713493-6-alvin@pqrs.dk>
 <20211016060429.783447-1-dqfext@gmail.com>
In-Reply-To: <20211016060429.783447-1-dqfext@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84c42f2e-2e9a-4d61-c297-08d9920d194c
x-ms-traffictypediagnostic: HE1PR0301MB2491:
x-microsoft-antispam-prvs: <HE1PR0301MB2491F6C89CE322B8913402A983BC9@HE1PR0301MB2491.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+4fBYkqHD/xhnnnV6vcjupQf0izxuemWla/vymPwhQuf+SY1BmH3wGSAW6T5a0o23SjgDQpGuEffXow7/R1KRI2dz4S7Oy2WWRDfhmtNhL1xUhtgBX0uLBmhsh76cyjDoPuEPykFXZMlgk5zQn8H4VFojZ5/dtSuArzGUhcekqXVgbnHwKBD6FaFcSrwux3uXssHNAu0o7Ba+Bei0cNrptEzmryBali69k8YOLZ3A4uanNSRmo0FI/uGExGJqidLvi1vXv+79QpSJPoqXNHNM87gbHBzXGf4M2x8eh5/iL5Kh6Rw/jUPIB8yOzr9dne524JKe1zmTa2UUrDzj9ZFa/yytDGOQ+h/zmvDeLsJjRT+ePMWAo6beo1E6C6yimP7y5VHPhRUAh5jW5JzH8+xG7LgF6fPkY7Y9IzWbMyui2NZKuQMndJPaEqoN0zdiQw13IL7dXFJGuH3HiBwGQDWCIW/EDNv6PYS5xd7fsMZ/b0LI8fDr2jj5fffcNLMhK4+NYKZ5uZ9ntUYUa5GuuRZkmTzO4aDDq89UM1W7s/LhHnyPKfPsUggq3CitWyWAG/NXP5qPOuijn67lh1/aT3gdPOhVZv9S6rMijcLSDQvJqt9QRs+QE6Do+LLu6mkYBLuTICy9p/Olpeip3PMztUCY0Jx1rW3Kqf91cCwGEB3h5xdL9fLNZuge99iD9MxDcT91NB5WHWLPbs1BfT09LGMij82mrFg5UYZktPf8aYynX5dY7umXFhwVnk1tORMAYdQt+jlpVsqSlEuemeqKUIiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(66476007)(64756008)(2906002)(66556008)(71200400001)(66446008)(110136005)(5660300002)(186003)(31696002)(38070700005)(6512007)(31686004)(76116006)(4744005)(38100700002)(508600001)(8976002)(66946007)(6486002)(91956017)(54906003)(53546011)(7416002)(8936002)(4326008)(316002)(6506007)(26005)(85182001)(85202003)(8676002)(2616005)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3E4OE5XREVyRndMdUxmNkU0MkFXK2JGNUI1L0pCNlEzQXZaZHlPeEhyMkR2?=
 =?utf-8?B?NHAwNUEvU2htWnh3SURlcVhGL1NLNHE0MDltOFkreFhOUzFzeVIvZlNIVVMz?=
 =?utf-8?B?SForK04zTTIwbVRZSGFPZHBkT0pMbklXeHI0eS93RGUvNEZCVjVMTGJzT0lK?=
 =?utf-8?B?bzVRT3BIZEtoc0NLelFOODZGK0duZlhnRy9PNklEM2FOd0NmZ0tEeFd2em1K?=
 =?utf-8?B?QkF5cWI3R3ZMRmY4TmxhTFh0QnFTV3kyR0k0NmwrYS9JUVR3TkYyQUwxY0FX?=
 =?utf-8?B?VFZqWElZdnlMM2ZGdkJmQVJQWXpXTXUwTFFnRHdtQjNMZ1BSSmgvbzhqQTg5?=
 =?utf-8?B?WDZ4VnN2eGlwVzhXWkNIMjZuOEdiaFFsRHZEQU5DNmNoNkpvUjNGYjM3ZUJT?=
 =?utf-8?B?dXVCVmxwMzVERDBldUVmZWdwWnhkSHNNdnhwMitSMkN1V2dHY2JsaXhmc1ZL?=
 =?utf-8?B?Yjg1OXBoek01K3JoWTNaUjlCSitKNm90OUhwUjQxZDdHMFdRdlo5aTRMTkxG?=
 =?utf-8?B?Y3FEeHlHelFVRm85aXR6QVAxejJaTHYxMVliSm5JRlZhNG9yNVdqUjZHRFJH?=
 =?utf-8?B?LzV6bWs2ODRMS1NPNEV3cmlFbGY4YTJZQmZWSjIxZ2hvdVk1YlBvYkZ3djN5?=
 =?utf-8?B?MFhoL1Mwck81NnZpUDZWQkJYdm9PcEhoZ0o1dktxN3B0aDhzZ1Jwb01NR0pE?=
 =?utf-8?B?YnZoNHYzVm1nT2x4Ry9Tc25Jbmk1Q0dkM3hONERmN0grc3haSVFCWXJmVVlx?=
 =?utf-8?B?cFp3NEdhcEdIdmhqQUM2UjZhSkVBTGtaNElZdk1TTjNjVVBzU2ZIbWFjWkJ6?=
 =?utf-8?B?YU9wcTN1ZGt5YWtZNGkwcGVDb3FzK0l1RHRsUmJLbkhHSGxDdVN6Q1pjRlFV?=
 =?utf-8?B?QVdFRGRydkkxemNRWmJxQi9QZ1BNMnZkcmRhMEtpSmpQN2J3TjJybzlvbHF3?=
 =?utf-8?B?NFFySmN6UG1KSGRvcGVJSTJUb0ZaS24xbUZ5Qll6OFhPTEhlMlc0aUJXbzdG?=
 =?utf-8?B?ZkgvWDZoS1dPVmU4K2d5cm1sSmo3R1lHSC9xb3lpcjJyV1ZyWW9EQUV0NmJS?=
 =?utf-8?B?MG1meGRtb0VrSzk3c1Z1MjJWSGx0L0Y2UmFSZDVqeG12aEVLNExuaGl1RUFB?=
 =?utf-8?B?NTdkQSt2NjhmM2Y4d3Q2ZmV6bWJuVFphMVF5cit1Mi96RWxVY0V0MDZOS1dU?=
 =?utf-8?B?RW5MbGltNUl0RmJ4UTV1YU5GUEl6N3Y3SWM2QWF0Vmpxbkgvc2N4UEhmZkMx?=
 =?utf-8?B?V0JwVEZkem16NUthS254aVBBQXh6aTZHMy9aRUV5SGtTbFM2T291R09STVdU?=
 =?utf-8?B?Z1RqUWs2S3lTaThNNlZoS2VTRFBhUUU5aEE5ajBCb3lqOE41akR5R2tzM25M?=
 =?utf-8?B?bmhCK3JwRzdySTlSSm5VdUt6akd1TkRkOW9LVU05UUlRdDdIOUtyTDNFZGQy?=
 =?utf-8?B?QmVLVDV2Ymk2dXQzTjdROC8ybUZkdE9jcHdFVG81TElNdTcwZlJnU3d3Unh6?=
 =?utf-8?B?L2V4VkNXQXZ2U0cvMXNHRWdPcjJES0hRS3pRQ1hvdUFvdjNqb0dDczUvY1dr?=
 =?utf-8?B?b2JwRHNNK3Q5eUFDaDZXMDZMR0N0cm1Kb1hESmY4NnJONW1Gai9RNWdoWWFm?=
 =?utf-8?B?OXVVQ2NrT0VZV1EzRzZ5Zzg2UkpPdTh6WkYzeDhvVkFRZTlZaW43bkhnMmtC?=
 =?utf-8?B?Q3lubjhiaURvaTVwVzRIRDV0cWdod2Qwd2xsTUxMMjQweklBN3JlZVB3Y0tZ?=
 =?utf-8?Q?isTiEKv48ql/8cb1mhQl7hbYfyeJkK5nm5fREHP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCD2336A42EC3440A867338051C61719@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c42f2e-2e9a-4d61-c297-08d9920d194c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 07:58:40.5147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PslYjOv3CEmWLBuXbb2zNo9z/PRGxzW3suK/59OioxkyThhRFw4yHJBPXMnFGce/ZZQ5J/lJX3ug3Qgle45Ybg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2491
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTYvMjEgODowNCBBTSwgREVORyBRaW5nZmFuZyB3cm90ZToNCj4gT24gRnJpLCBPY3Qg
MTUsIDIwMjEgYXQgMDc6MTA6MjZQTSArMDIwMCwgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+PiAr
c3RhdGljIHN0cnVjdCBza19idWZmICpydGw4XzRfdGFnX3htaXQoc3RydWN0IHNrX2J1ZmYgKnNr
YiwNCj4+ICsJCQkJICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+PiArew0KPj4gKwlz
dHJ1Y3QgZHNhX3BvcnQgKmRwID0gZHNhX3NsYXZlX3RvX3BvcnQoZGV2KTsNCj4+ICsJX19iZTE2
ICp0YWc7DQo+PiArDQo+PiArCS8qIFBhZCBvdXQgc28gdGhlIChzdHJpcHBlZCkgcGFja2V0IGlz
IGF0IGxlYXN0IDY0IGJ5dGVzIGxvbmcNCj4+ICsJICogKGluY2x1ZGluZyBGQ1MpLCBvdGhlcndp
c2UgdGhlIHN3aXRjaCB3aWxsIGRyb3AgdGhlIHBhY2tldC4NCj4+ICsJICogVGhlbiB3ZSBuZWVk
IGFuIGFkZGl0aW9uYWwgOCBieXRlcyBmb3IgdGhlIFJlYWx0ZWsgdGFnLg0KPj4gKwkgKi8NCj4+
ICsJaWYgKHVubGlrZWx5KF9fc2tiX3B1dF9wYWR0byhza2IsIEVUSF9aTEVOICsgUlRMOF80X1RB
R19MRU4sIGZhbHNlKSkpDQo+PiArCQlyZXR1cm4gTlVMTDsNCj4gDQo+IElzIHRoaXMgc3RpbGwg
cmVxdWlyZWQgaWYgeW91IHNldCBydGw4MzY1bWJfY3B1X3J4bGVuIHRvIDY0IGJ5dGVzIGFscmVh
ZHk/DQoNCkFwcGFyZW50bHkgbm90IC0gbmljZSBjYXRjaC4gSSd2ZSByZW1vdmVkIGl0IGZvciB3
aGF0IHdpbGwgYmUgdjQuIDopDQoNCj4gDQo+PiArDQo+PiArCXNrYl9wdXNoKHNrYiwgUlRMOF80
X1RBR19MRU4pOw0KPj4gKw0KDQo=
