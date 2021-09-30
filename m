Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CEE41D607
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349261AbhI3JLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:11:07 -0400
Received: from mail-db8eur05on2121.outbound.protection.outlook.com ([40.107.20.121]:26885
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349025AbhI3JLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 05:11:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFEpsLUWaPXUoLgjXK916PzyYsXnVsPQzgMebKfbfcYgFoJvmGZJym6Iqy0nVY/5EeFFoQ/qw2GLcEG6SkSso5gtfmDOawIth2doTrfhgXCumEU0IChhZbitFoXDEj2e7SuZ3+vf3enbOExAmVcwpO26hvWJu8rSbY6Dhm9Q6zKAT1+DA86gzfGAcMjylSHnfR6BtqSKD7+WNVdKuVX6Q/SD/cTvoyEiXOxE3eDRzGLK3MSiGwDYhFJoxg2DoYeMzNtqiDKuGv5VANs/2SnllCjrMYdlbW61ObbyTy5bF0Gj3N2IBUnxQgsEDrEGoF/LD0BWjVfzpFRgoWhFWaXKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/se7T1CTqTYCmaTK5EFppRnyySyl2RpdUTks0fwhJYE=;
 b=G2gKeusqnJvHmlYsiuaBOSwEeQZz0hDdT1QYBjY6PTLi85gqq+FMA3y7R9c1E9EYlwPJ8QphXOCSTiFMRqYGxmgEDmQT2Vk1YsgrVGgpv1HtZMTg07mRcdo3ByXlm4gBhh349Il3SMoSLWobUx73++/3D7NbhlMS0I7ZWsv/42hPln7YPC1zFPtaZMcRm9TyTmUYnfYe+yJ0hBStkp3TZROZoveJDj4rL4VkLEjMgggGlo8HcuBzRSzZv253vCNTeYvgKMnMFq4ZsQ5cemNtFoQsdQw27r8c715WAIKUceVg42pU4Np5oP4OBD23iqnY94sPFDcH6OA1MaYUSBa6hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/se7T1CTqTYCmaTK5EFppRnyySyl2RpdUTks0fwhJYE=;
 b=nJSaiA3adTkc+h8MLV15hthMX7SPr4x0HBfCXDW/7F5vIrJJY38RPq50fztqWy4Hx38WBPPhX0DAFbExS9WKBxwM4KSUP0y381O9tXex32QKra7IxIowsZCuF3Q6AJ+hYGwoteWsRBtlMHCVpxXP8pS5J6QNdq7beYBLbNtcowc=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2410.eurprd03.prod.outlook.com (2603:10a6:3:68::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.15; Thu, 30 Sep 2021 09:09:20 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 09:09:19 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 2/4 v4] net: dsa: rtl8366rb: Support flood
 control
Thread-Topic: [PATCH net-next 2/4 v4] net: dsa: rtl8366rb: Support flood
 control
Thread-Index: AQHXtXXxt6P1UWLZZ0iJaFtxWvrMC6u7jyqAgAC7nYA=
Date:   Thu, 30 Sep 2021 09:09:19 +0000
Message-ID: <ccc6d77c-d454-8869-2f43-05a161753ae3@bang-olufsen.dk>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-3-linus.walleij@linaro.org>
 <20210929215749.55mti6y66m4m75hj@skbuf>
In-Reply-To: <20210929215749.55mti6y66m4m75hj@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11db35f8-e0c5-4b37-fc6a-08d983f1fc9a
x-ms-traffictypediagnostic: HE1PR0301MB2410:
x-microsoft-antispam-prvs: <HE1PR0301MB2410C59A862DE837BA74052C83AA9@HE1PR0301MB2410.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cb28bJA0djLwq+nv69PBPIYBRWsx9VkzEi9pVH2Y2HJkjF/7IqAEr5o1f1EU8oZUnsf72SitBiHk7X3IAdkW00dRRlZJMoo9/0ENlzX1pcf4ISyQd/R5E7ma3gAJs0RT7ELUvawIKc3eSPTe7T1vObK3qDzNT547qwMIW7RsLEHPS4XX5fG9dgYVyHhTL9D5EaWIutFc2fjcWLxa3Tl0a/EBv4cLi4Q0TK5LxR2k/RhLHGK9rVBtjlMzVdWXBZxTSGuzvaA6mqgh3YjrcSmQu6bDJIzRU1RnJEd5s5gNDgaQFr37uclwT3gwOytYd9UxG2kOg12alIMxutjX/bVBsR31riYVc91y9YCOjEjUryF6OBcOntkYixyIdXGmzvBOVNb2qy2EqR2KczhsKk7lUdY4m1p3IZUJdJ3HL91yal7BP9MWpy3sivjz6J6ARlvRrCb7kibKNf90zy1Eug7ESdYEaxLEknXitGJHmfIO2DcIgxHkG2j8e7xCukWdK4d7wy9k9Sr5p7NObs/qdt0gNTG0uYsPG3hq82Iz1w0SpAroIh49BG9JeffsqdNBZ1e2lx++XNr3HvokD5TsntHx4GG1IFnFAu8aDxXQPxXWH9F+xGSOvdSbelpurxPMYnxmZVA55ohAeHPIqns1IXGkdzKvj3MDfRqCSYJne9DNoy+TP8zoXJaKbcuKLqV1T4RmqRVjKtSJp4rEy1Q4+tJr9MHsgmVX1z4J7JBnqtTF7hctxXmtaemsbXXGc42WrmhGVEdPX8C6n1aYhf6O4l3/5O+DpDeESoCa+rrYxCDOwLyoqMqdmEyomXQQlftjMNYil3LS4tR6r3JoQ059kq/wd51beD9zrclGBkfCoqUVFno=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66574015)(71200400001)(64756008)(66446008)(966005)(85202003)(2906002)(66946007)(91956017)(76116006)(31696002)(85182001)(31686004)(83380400001)(38070700005)(86362001)(122000001)(38100700002)(2616005)(66476007)(66556008)(6506007)(7416002)(186003)(6512007)(4326008)(316002)(508600001)(110136005)(53546011)(26005)(54906003)(36756003)(5660300002)(8936002)(6486002)(8976002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFRNd09kZEhWRmVkUW1kSjlVeElVWCtwMVdlemNabjh4dFVNczFFbUR1bzhr?=
 =?utf-8?B?REtra2xibTQxOGZmTlBrN1F0aFNHRFE3ZWp1RzVYVW5VZzlOQTZEQmZjREwx?=
 =?utf-8?B?K3Z4SjU4dkNUSy9RM3M5ZlpZTFpuNzBuRGtjRkQyZnYwNktiUDcwd0NsUXZy?=
 =?utf-8?B?MCttWDRBb1l5WkpyNHpSQkJhRGVONHBLVnFteUNzTnNiNnNiSWZydG9TcGtN?=
 =?utf-8?B?WlVhM2UvQWwyNHZ6TmMxUXRweWoreFZ2Z1JtT3ovaUlYdEJGSFpjZGdvMkRJ?=
 =?utf-8?B?Q2dPRUxpZmtVY2lxemt0czJ2UERHN0R4SjBnNWZybDlaRXY5a0Qvemo2L1F4?=
 =?utf-8?B?YVhiOVpXMGhxODd6bVE0T1NFMWhoV1VxMTBydFByazAxcXo1M0RHSm9uZnh2?=
 =?utf-8?B?bURqUkFEWkxyY2pVbmF2bTBLNTBNd1Yxa0Q5c1lvZ0pyZHAzSnEyRWdaZEFH?=
 =?utf-8?B?MUhPeWNpYWlSdGFCYUw2VTdGUWhYUGtmUFU3eHcwNnFzN1kzbVYzYXhjK2hD?=
 =?utf-8?B?NFA5WEtVQ3hzY3BNRnBFUVFpSW52M0FkRDBYOFdaRndyc0NJbDZWNmNOVVRC?=
 =?utf-8?B?MGFPaVVWeEdPSEd4d2gyOFFxMm1FS2I3TDdKcW9hUkRtUjZiTVNoaDlrbjdP?=
 =?utf-8?B?VDZWZ0FENGxKV2hqazVrb1BUanpTQ0M2U0lYYkN6U1MxaUEybXJ6TURPcGpm?=
 =?utf-8?B?TzYxSnZlSlI5Rm5pZWNxeUNsdTBqWmd4QWpjY0VhdmN6ZzJsK1RzbWw2M3NF?=
 =?utf-8?B?MjZ2VzBuRjlobnZ2RUs4cHhUb0VGSDZkdUdscDd6N3B5WUVPTExYYVJGL013?=
 =?utf-8?B?MHNwQjh6eVF1djRMNVFqZUR5d1VENHNGN25uNUMxT2N0cUdvZE9yeUNQRDU0?=
 =?utf-8?B?aHNrbUFpVmI4enJIRHEwRHMzMmMydHcvTUxuUDhkVkxFY3Q3UlR1d0VOWkZ4?=
 =?utf-8?B?b0FYNys0RDVuMGJucHR4cG1OWDBZN0lHL1RINS9qcEo2M2tpbHBFNm1UeXlj?=
 =?utf-8?B?TGpHV1hiakN4VW12WEdXNlErQkt6czgwSVpkUmxZZnF1UU1YUDBSZDJGbkFN?=
 =?utf-8?B?U2Vid3RqdWpwbGtsbExEeVFrNEI3c0ZMYVBvQUVJSGlNbnFobCtUUFJaZW5N?=
 =?utf-8?B?YmRGeWdrL3ZacHMrYlE4SnB3c0doSXM2K01GbGNMbHBqQ2lzYTZ2YlFPbklm?=
 =?utf-8?B?ZWdsUHl3dVl5M1dHbEVjeHBPRWFvOWtJRUllSFBSeDBpTGRIWTI1YVYwN2Fj?=
 =?utf-8?B?SXNqZ3p2Ly82YTh0d0NNamtNMFpGNUNoc3dQcldhZUtIRWh4VmxjZzR3Nnd3?=
 =?utf-8?B?OUoxb0gvRXd2T2w1ZVhmZ3FhRTBOK24wZnNveDh5U1B2cVhMR2FZV3VVdlN6?=
 =?utf-8?B?SjIxOGp3U1c2N2dWZFlWZHFaOGdhZW9zeHBIVnk5RXpmZStTQ042SFFzYnNP?=
 =?utf-8?B?UTJQdXhoL0ZwMUIzSWY2bWNTNWEvYkFhOWJaRXZGMlY1alMyNmN3blpaY2c0?=
 =?utf-8?B?YTlBY2prSC85RzN5aUFEMmFZNzV6T29hVDVPK2NvUVdYazNlVWQxVGV2U0gr?=
 =?utf-8?B?bGN0TVFCRDBOMGgxVFdpZnVjSFV5bnp0MlNOSExURXdDT0xSZXduNUV1WnFx?=
 =?utf-8?B?bnBxdWtBcVpEcmpKUzcrSVdGeHhDdGZtV1Fod3FLT3BFejA1eDRtbkRtelhl?=
 =?utf-8?B?aG01eUFIUi9OZGY5NmpzTDF0czRISUxhVnVJdW9qRUJ6R2FGYTBWNU85cC9I?=
 =?utf-8?Q?jsqu2oU8rAELmAv5ekwVm8rX/5nHCK/tF9DLC9K?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <71FADA0A9F557C4EA7D317857ABA4515@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11db35f8-e0c5-4b37-fc6a-08d983f1fc9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 09:09:19.6037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iMb9oHdVbpGlzfHRC8DKE2PHe34WaSRN9tLUkp+hneZ+51fB4U6gXNFHM6UlOOimzq9hRhKQVZzbUqPT0s+QFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2410
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8yOS8yMSAxMTo1NyBQTSwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiBPbiBXZWQsIFNl
cCAyOSwgMjAyMSBhdCAxMTowMzo0N1BNICswMjAwLCBMaW51cyBXYWxsZWlqIHdyb3RlOg0KPj4g
Tm93IHRoYXQgd2UgaGF2ZSBpbXBsZW1lbnRlZCBicmlkZ2UgZmxhZyBoYW5kbGluZyB3ZSBjYW4g
ZWFzaWx5DQo+PiBzdXBwb3J0IGZsb29kIGNvbnRyb2wgYXMgd2VsbCBzbyBsZXQncyBkbyBpdC4N
Cj4+DQo+PiBDYzogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4+IENjOiBB
bHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+PiBDYzogTWF1cmkgU2FuZGJl
cmcgPHNhbmRiZXJnQG1haWxmZW5jZS5jb20+DQo+PiBDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5m
YWluZWxsaUBnbWFpbC5jb20+DQo+PiBDYzogREVORyBRaW5nZmFuZyA8ZHFmZXh0QGdtYWlsLmNv
bT4NCj4+IFNpZ25lZC1vZmYtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJv
Lm9yZz4NCj4+IC0tLQ0KPj4gQ2hhbmdlTG9nIHYzLT52NDoNCj4+IC0gTm8gY2hhbmdlcywgcmVi
YXNlZCBvbiB0aGUgb3RoZXIgcGF0Y2hlcy4NCj4+IENoYW5nZUxvZyB2Mi0+djM6DQo+PiAtIE1v
dmUgdGhlIFVOTUMgdW5kZXIgdGhlIG11bHRpY2FzdCBzZXR0aW5nIGFzIGl0IGlzIHJlbGF0ZWQg
dG8NCj4+ICAgIG11bHRpY2FzdCB0byB1bmtub3duIGFkZHJlc3MuDQo+PiAtIEFkZCBzb21lIG1v
cmUgcmVnaXN0ZXJzIGZyb20gdGhlIEFQSSwgdW5mb3J0dW5hdGVseSB3ZSBkb24ndA0KPj4gICAg
a25vdyBob3cgdG8gbWFrZSB1c2Ugb2YgdGhlbS4NCj4+IC0gVXNlIHRhYnMgZm9yIGluZGVudGF0
aW9uIGluIGNvcHlwYXN0ZSBidWcuDQo+PiAtIFNpbmNlIHdlIGRvbid0IGtub3cgaG93IHRvIG1h
a2UgdGhlIGVsYWJvcmF0ZSBzdG9ybSBjb250cm9sDQo+PiAgICB3b3JrIGp1c3QgbWVudGlvbiBm
bG9vZCBjb250cm9sIGluIHRoZSBtZXNzYWdlLg0KPj4gQ2hhbmdlTG9nIHYxLT52MjoNCj4+IC0g
TmV3IHBhdGNoDQo+PiAtLS0NCj4+ICAgZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jIHwgNTUg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0KPj4gICAxIGZpbGUgY2hhbmdl
ZCwgNTMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5j
DQo+PiBpbmRleCBiMzA1NjA2NGI5MzcuLjUyZTc1MGVhNzkwZSAxMDA2NDQNCj4+IC0tLSBhL2Ry
aXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgz
NjZyYi5jDQo+PiBAQCAtMTY0LDYgKzE2NCwyNiBAQA0KPj4gICAgKi8NCj4+ICAgI2RlZmluZSBS
VEw4MzY2UkJfVkxBTl9JTkdSRVNTX0NUUkwyX1JFRwkweDAzN2YNCj4+ICAgDQo+PiArLyogU3Rv
cm0gcmVnaXN0ZXJzIGFyZSBmb3IgZmxvb2QgY29udHJvbA0KPj4gKyAqDQo+PiArICogMDJlMiBh
bmQgMDJlMyBhcmUgZGVmaW5lZCBpbiB0aGUgaGVhZGVyIGZvciB0aGUgUlRMODM2NlJCIEFQSQ0K
Pj4gKyAqIGJ1dCB0aGVyZSBhcmUgbm8gdXNhZ2UgZXhhbXBsZXMuIFRoZSBpbXBsZW1lbnRhdGlv
biBvbmx5IGFjdGl2YXRlcw0KPj4gKyAqIHRoZSBmaWx0ZXIgcGVyIHBvcnQgaW4gdGhlIENUUkwg
cmVnaXN0ZXJzLg0KPiANCj4gVGhlICJmaWx0ZXIiIHdvcmQgYm90aGVycyBtZSBhIGJpdC4NCj4g
QXJlIHRoZXNlIHNldHRpbmdzIGFwcGxpZWQgb24gaW5ncmVzcyBvciBvbiBlZ3Jlc3M/IElmIHlv
dSBoYXZlDQo+IFJUTDgzNjZSQl9TVE9STV9CQ19DVFJMID09IEJJVCgwKSB8IEJJVCgxKSwgYW5k
IGEgYnJvYWRjYXN0IHBhY2tldCBpcw0KPiByZWNlaXZlZCBvbiBwb3J0IDIsIHRoZW4NCj4gDQo+
IChhKSBpcyBpdCByZWNlaXZlZCBvciBkcm9wcGVkPw0KPiAoYikgaXMgaXQgZm9yd2FyZGVkIHRv
IHBvcnQgMCBhbmQgMT8NCj4gKGMpIGlzIGl0IGZvcndhcmRlZCB0byBwb3J0IDM/DQoNCkxpbnVz
LCBhcmUgeW91IHN1cmUgdGhlc2UgU1RPUk1fLi4uIHJlZ2lzdGVycyBhcmUgdGhlIHJpZ2h0IG9u
ZXMgdG8gDQpjb250cm9sIGZsb29kaW5nPyBUaGUgZG9jIGZyb20gUmVhbHRla1sxXSB0YWxrcyBi
cmllZmx5IGFib3V0IHRoaXMgc3Rvcm0gDQpjb250cm9sIGZlYXR1cmUsIGJ1dCBpdCBzZWVtcyB0
byBiZSByZWxhdGVkIHRvIHJhdGUgbGltaXRpbmcsIG5vdCBhY3R1YWwgDQpmbG9vZGluZyBiZWhh
dmlvdXIuDQoNCkp1c3QgRllJLCBvbiB0aGUgUlRMODM2NU1CIHRoZXJlIGFyZSBzaW1pbGFyIHN0
b3JtIGNvbnRyb2wgcmVnaXN0ZXJzLCANCmJ1dCB0aGUgdmVuZG9yIGRyaXZlciBkb2Vzbid0IHVz
ZSB0aGVtIHRvIGNvbnRyb2wgZmxvb2RpbmcuIEZsb29kaW5nIGlzIA0KY29udHJvbGxlZCBieSBh
IHNldCBvZiBkaWZmZXJlbnQgcmVnaXN0ZXJzIHdoaWNoIGFsbG93IHlvdSB0byAoMSkgZmxvb2Qs
IA0KKDIpIGZsb29kIHRvIGEgc3BlY2lmaWVkIHBvcnRtYXNrLCAoMykgZHJvcCwgb3IgKDQpIHRy
YXAuIEluIHRoZSB2ZW5kb3IgDQpkcml2ZXIgdGhvc2UgcmVnaXN0ZXJzIHRha2UgbmFtZXMgbGlr
ZSANClJUTDgzNjdDX1JFR19VTktOT1dOX1VOSUNBU1RfREFfUE9SVF9CRUhBVkUgdG8gY29udHJv
bCB1bmljYXN0IGZsb29kaW5nIA0Kb24gYSBwZXItcG9ydCBiYXNpcy4gU28gdGhlcmUgbWlnaHQg
YmUgc29tZXRoaW5nIHNpbWlsYXIgZm9yIHRoZSAnNjZSQi4NCg0KT3JpZ2luYWxseSBJIHRob3Vn
aHQgInN0b3JtIiB3YXMgUmVhbHRlayBzbGFuZyBmb3IgImZsb29kIiwgYnV0IGl0IHNlZW1zIA0K
dGhhdCBpcyBub3QgdGhlIGNhc2UuDQoNClsxXSANCmh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9n
aC9saWJjMDYwNy9SZWFsdGVrX3N3aXRjaF9oYWNraW5nQGZpbGVzL1JlYWx0ZWtfVW5tYW5hZ2Vk
X1N3aXRjaF9Qcm9ncmFtbWluZ0d1aWRlLnBkZg0KDQo+IA0KPj4gKyAqLw0KPj4gKyNkZWZpbmUg
UlRMODM2NlJCX1NUT1JNX0ZJTFRFUklOR18xX1JFRwkJMHgwMmUyDQo+PiArI2RlZmluZSBSVEw4
MzY2UkJfU1RPUk1fRklMVEVSSU5HX1BFUklPRF9CSVQJQklUKDApDQo+PiArI2RlZmluZSBSVEw4
MzY2UkJfU1RPUk1fRklMVEVSSU5HX1BFUklPRF9NU0sJR0VOTUFTSygxLCAwKQ0KPj4gKyNkZWZp
bmUgUlRMODM2NlJCX1NUT1JNX0ZJTFRFUklOR19DT1VOVF9CSVQJQklUKDEpDQo+PiArI2RlZmlu
ZSBSVEw4MzY2UkJfU1RPUk1fRklMVEVSSU5HX0NPVU5UX01TSwlHRU5NQVNLKDMsIDIpDQo+PiAr
I2RlZmluZSBSVEw4MzY2UkJfU1RPUk1fRklMVEVSSU5HX0JDX0JJVAlCSVQoNSkNCj4+ICsjZGVm
aW5lIFJUTDgzNjZSQl9TVE9STV9GSUxURVJJTkdfMl9SRUcJCTB4MDJlMw0KPj4gKyNkZWZpbmUg
UlRMODM2NlJCX1NUT1JNX0ZJTFRFUklOR19NQ19CSVQJQklUKDApDQo+PiArI2RlZmluZSBSVEw4
MzY2UkJfU1RPUk1fRklMVEVSSU5HX1VOREFfQklUCUJJVCg1KQ0KPj4gKyNkZWZpbmUgUlRMODM2
NlJCX1NUT1JNX0JDX0NUUkwJCQkweDAzZTANCj4+ICsjZGVmaW5lIFJUTDgzNjZSQl9TVE9STV9N
Q19DVFJMCQkJMHgwM2UxDQo+PiArI2RlZmluZSBSVEw4MzY2UkJfU1RPUk1fVU5EQV9DVFJMCQkw
eDAzZTINCj4+ICsjZGVmaW5lIFJUTDgzNjZSQl9TVE9STV9VTk1DX0NUUkwJCTB4MDNlMw0KPj4g
Kw0KPj4gICAvKiBMRUQgY29udHJvbCByZWdpc3RlcnMgKi8NCj4+ICAgI2RlZmluZSBSVEw4MzY2
UkJfTEVEX0JMSU5LUkFURV9SRUcJCTB4MDQzMA0KPj4gICAjZGVmaW5lIFJUTDgzNjZSQl9MRURf
QkxJTktSQVRFX01BU0sJCTB4MDAwNw0KPj4gQEAgLTEyODIsOCArMTMwMiw4IEBAIHJ0bDgzNjZy
Yl9wb3J0X3ByZV9icmlkZ2VfZmxhZ3Moc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwN
Cj4+ICAgCQkJCXN0cnVjdCBzd2l0Y2hkZXZfYnJwb3J0X2ZsYWdzIGZsYWdzLA0KPj4gICAJCQkJ
c3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0KPj4gICB7DQo+PiAtCS8qIFdlIHN1cHBv
cnQgZW5hYmxpbmcvZGlzYWJsaW5nIGxlYXJuaW5nICovDQo+PiAtCWlmIChmbGFncy5tYXNrICYg
fihCUl9MRUFSTklORykpDQo+PiArCWlmIChmbGFncy5tYXNrICYgfihCUl9MRUFSTklORyB8IEJS
X0JDQVNUX0ZMT09EIHwNCj4+ICsJCQkgICBCUl9NQ0FTVF9GTE9PRCB8IEJSX0ZMT09EKSkNCj4+
ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4+ICAgDQo+PiAgIAlyZXR1cm4gMDsNCj4+IEBAIC0xMzA1
LDYgKzEzMjUsMzcgQEAgcnRsODM2NnJiX3BvcnRfYnJpZGdlX2ZsYWdzKHN0cnVjdCBkc2Ffc3dp
dGNoICpkcywgaW50IHBvcnQsDQo+PiAgIAkJCXJldHVybiByZXQ7DQo+PiAgIAl9DQo+PiAgIA0K
Pj4gKwlpZiAoZmxhZ3MubWFzayAmIEJSX0JDQVNUX0ZMT09EKSB7DQo+PiArCQlyZXQgPSByZWdt
YXBfdXBkYXRlX2JpdHMoc21pLT5tYXAsIFJUTDgzNjZSQl9TVE9STV9CQ19DVFJMLA0KPj4gKwkJ
CQkJIEJJVChwb3J0KSwNCj4+ICsJCQkJCSAoZmxhZ3MudmFsICYgQlJfQkNBU1RfRkxPT0QpID8g
QklUKHBvcnQpIDogMCk7DQo+PiArCQlpZiAocmV0KQ0KPj4gKwkJCXJldHVybiByZXQ7DQo+PiAr
CX0NCj4+ICsNCj4+ICsJaWYgKGZsYWdzLm1hc2sgJiBCUl9NQ0FTVF9GTE9PRCkgew0KPj4gKwkJ
cmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRzKHNtaS0+bWFwLCBSVEw4MzY2UkJfU1RPUk1fTUNfQ1RS
TCwNCj4+ICsJCQkJCSBCSVQocG9ydCksDQo+PiArCQkJCQkgKGZsYWdzLnZhbCAmIEJSX01DQVNU
X0ZMT09EKSA/IEJJVChwb3J0KSA6IDApOw0KPj4gKwkJaWYgKHJldCkNCj4+ICsJCQlyZXR1cm4g
cmV0Ow0KPj4gKwkJLyogVU5NQyA9IFVua25vd24gbXVsdGljYXN0IGFkZHJlc3MgKi8NCj4+ICsJ
CXJldCA9IHJlZ21hcF91cGRhdGVfYml0cyhzbWktPm1hcCwgUlRMODM2NlJCX1NUT1JNX1VOTUNf
Q1RSTCwNCj4+ICsJCQkJCSBCSVQocG9ydCksDQo+PiArCQkJCQkgKGZsYWdzLnZhbCAmIEJSX0ZM
T09EKSA/IEJJVChwb3J0KSA6IDApOw0KPj4gKwkJaWYgKHJldCkNCj4+ICsJCQlyZXR1cm4gcmV0
Ow0KPj4gKwl9DQo+PiArDQo+PiArCWlmIChmbGFncy5tYXNrICYgQlJfRkxPT0QpIHsNCj4+ICsJ
CS8qIFVOREEgPSBVbmtub3duIGRlc3RpbmF0aW9uIGFkZHJlc3MgKi8NCj4+ICsJCXJldCA9IHJl
Z21hcF91cGRhdGVfYml0cyhzbWktPm1hcCwgUlRMODM2NlJCX1NUT1JNX1VOREFfQ1RSTCwNCj4+
ICsJCQkJCSBCSVQocG9ydCksDQo+PiArCQkJCQkgKGZsYWdzLnZhbCAmIEJSX0ZMT09EKSA/IEJJ
VChwb3J0KSA6IDApOw0KPj4gKwkJaWYgKHJldCkNCj4+ICsJCQlyZXR1cm4gcmV0Ow0KPj4gKwl9
DQo+PiArDQo+PiAgIAlyZXR1cm4gMDsNCj4+ICAgfQ0KPj4gICANCj4+IC0tIA0KPj4gMi4zMS4x
DQo+Pg0KPiANCg0K
