Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2DF425216
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbhJGLgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:36:49 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:11809
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232829AbhJGLgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 07:36:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKc4UQkDT+fHKFcVYOhM8cjrbh+IjbNnaKsD7dV4nfHA6cnpvcqlgsYqO1q3yNeSbSXyauHbhtGN4UFpNdIV0SXeoLB7Hh50NKGaNVchXj8vFO5v53pb3R0MSqE7huf6YpzMLfLHE5Vklc8lilLWwjG6wyqWUoEsp86hwup0ra6Xcf3oUVn1s+Hsdmi23d+T0/VU005C85KQe+J/WkYukQI5NkpGzZJ1uMvAqj5LxcuUq+XMfzCOZsUKCq+Y9AK4ZS8KwVyZfk439Shj/pQ6jEzYF9QMrEYuOOEzkDKVpVbYLa7j83fTKDZQTlThd0UrEm+9jXmNWgbkFQ3STcXoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnhjHLTqV7/skVZ+lLJbQmTH/SRPeUrqsBhi7yvFlfM=;
 b=IialWv189+yyzCD5sFxHQ3P/owevwNNrSX1Ts0jB4IkkHnBRznHZULydBbqJ1lRz7/+COUjgRdSt0p+tyi2c0p6vUIUlzjiU+tN+6BZ+hTk+9fdJFA+BY3AiPX7M6pwmPXXIlTQZPKa8CSDGq/+oEEtrQe51xDetmfb4U5zOWEKD4DtlkXS+afz2oqL30p803O6sMzR495iFkvPavmeMvadm/P7COzYodRRWScwM31XjRgwq6xMvD43+LNgu335bGIGNq3vqU0fRsl5C0c9NetGUoeatbUGm7+1aIR1ADCGLtnDFGvOL7hBRG/l+DZqZupCQF3zi506RoPZ7B3xtIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnhjHLTqV7/skVZ+lLJbQmTH/SRPeUrqsBhi7yvFlfM=;
 b=oMpH9Qr92A9tye/i4Bn5UhTxXoYMfLwWqIoezDLJuLiX3t/ZUNK+OWoYDibj6qwkNfJI9R45+gk42JeP5kdXAHe9tk8psdYtTq96tfz3X9sj56mOfnSGkDRenO6f+uDgT7hA1XMvmrqWbAKMcSDZGw5FFwgt9+1n6JGhIFUXclE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5134.eurprd04.prod.outlook.com (2603:10a6:803:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 7 Oct
 2021 11:34:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 11:34:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: DSA: some questions regarding TX forwarding offload
Thread-Topic: DSA: some questions regarding TX forwarding offload
Thread-Index: AQHXucaemV05T+14+0C6ajjHlibfJavEL5CAgAAgAgCAABbYAIAAE5gAgAANB4CAAaB4gIABJYaAgAAaqICAAANuAA==
Date:   Thu, 7 Oct 2021 11:34:48 +0000
Message-ID: <20211007113448.y4ijmlthgf4qxejz@skbuf>
References: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
 <20211005101253.sqvsvk53k34atjwt@skbuf>
 <f6974437-4e5c-802f-a84c-52b1e9506660@bang-olufsen.dk>
 <20211005132912.bkjogbbv7gpf6ue7@skbuf>
 <3603d4eb-61d0-e64d-3e9d-53803d8c46a4@bang-olufsen.dk>
 <20211005152557.wbn7ojk5nphos5s5@skbuf>
 <cd717680-dbac-4329-75af-32d0c677d622@bang-olufsen.dk>
 <20211007094707.wg24vgbf57cr76mi@skbuf>
 <0726ca75-e615-0872-7222-abdb7a28ce8a@bang-olufsen.dk>
In-Reply-To: <0726ca75-e615-0872-7222-abdb7a28ce8a@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bang-olufsen.dk; dkim=none (message not signed)
 header.d=none;bang-olufsen.dk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f465a6eb-90c0-479e-7877-08d989867864
x-ms-traffictypediagnostic: VI1PR04MB5134:
x-microsoft-antispam-prvs: <VI1PR04MB51349FCCB3BEDA1F76747B2FE0B19@VI1PR04MB5134.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A8uhauZNgucsygBJf10mTX7ba9VZ8ZsYmnF97lLQQraBo76nNh4NrTstyNjhnx1SWq/BBtX4X97GLGGzP/aqMe+dXuRKjBoDa2j5Bs3FmEVSlp2cxKmoykd25qMo17Kjghfr1zD1cFMWfu4ZpcxxuyXivJJHsKus/fRKUfkm5eviMczNoTZtjO85WdQ/p2LT43+upIVgGQkl7IVipWLtOEIp41eGYIoNK6FhRq3y5o9SEd73SdsM/ytzAhr0CFWopNoGd8RE+o0OzkvDwzMcR5QTTFvCee5k6Xo8C4ZsKVxwF0YUCHEAFLkLoqre/r9dl3I/LkckiuBP63apYt7Ly7Gku/9d2OZn2YTRHWq3YYkwAl5iJHpvJKrg9s2pEJLrV8SOZQLTIJ8AX6UtfsqJOy/2beZfoo4G3o/JhJU1Q6faV6zNaR9bbelV5c1WbUNhk71TTQX98P11GAsr6EdH/+xKz8Ov/Edt5m15sCeK5XAHpBf3fCs9QTCoY/06SIWB77M/92ODKpp2YFJKAqQad309+m2drGcXkKgsGqZn6TLOd+/FUqXVNPYjhQVSYwthOjsbCC4LPcZm9W8/eVC7ygIstkTCwhNqey/66BwMbReoWZ9ppx1YifkYASU7F+5zxxBQB6BKkffqi/D6vmNCw1NTYHqGW0AXV/n9WTlHJ9rUChgnq2mGCytP1DvplFMgXG9XiGUjj5z8lLMNl7sGkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(66574015)(2906002)(5660300002)(54906003)(38070700005)(186003)(33716001)(9686003)(71200400001)(6916009)(6512007)(316002)(83380400001)(86362001)(508600001)(76116006)(38100700002)(26005)(122000001)(6486002)(64756008)(8676002)(66946007)(66476007)(1076003)(66446008)(66556008)(44832011)(8936002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1B2enJXN2JNKzZsdkhXdWVPSjRJcjAvdkRxNkEzNHVnd2Ywcit6VURKNGZD?=
 =?utf-8?B?ODJLYldCbEN3VEVibUI1V3BmQVhicGR1c084RmdFQlJ2ajBTU3VObmFHWDZp?=
 =?utf-8?B?emRtSldkSkZIejhRK1haNkRKWGcrV0x2UUxkYUNJYzM1NUJmSUt3Z0VBNjJl?=
 =?utf-8?B?UTRQc2JFdUUxVGgxUmZkck4rMHVscWovM0JqY1VILzgyeXNHelZZTTdWNzA2?=
 =?utf-8?B?ejZyaXUwenhmdlFNNGVKcDcyRnUxVElERHRhOUQ1MFZTM3FtakhFSUdIL2Jy?=
 =?utf-8?B?MTF4d0RKZkwwRnI4c3NIUWhDWDVSeThGOVA3WHdZVFpOd0NicmhpR0oyMjhL?=
 =?utf-8?B?dkZHNFdVVWJGVnpES0xSaVN1ejVnMWVpMC9Ta1Vsc1F2cWY4WXpvYS9qZm5I?=
 =?utf-8?B?cmUrVXVBR0JrQnk0ajhDK3lCaFdNenY0QlJnYi9HNGZ6WmZwTmpoKzY4dlph?=
 =?utf-8?B?cGljZjk2dFpyaWIvdEpLTjJmQWlDcXdnN1k4U3gvM01XWXRaWjlEbmorbnM0?=
 =?utf-8?B?cGljUk0rTU9pb2l6ZmlNak5BellVYzNYVEhxR21WbDh3UDc4L3hvbEtoUk5s?=
 =?utf-8?B?Q3ZhckswTDdtY0tRTGg1U3pqVXJ3TW1vSzBqaVJZb2FPajZZRnlMT09HU0Nn?=
 =?utf-8?B?UUhTMmh1dnFHa3VzcGZIelBFYUl5a3VNazFWK1lGNE9VQThINUxkN0RPOVJy?=
 =?utf-8?B?dXVpcEdZVTlpbjNlVmQ0di9ESEMzRk5FenlDUkg0NTRPeUVhT3FuVnh2M29G?=
 =?utf-8?B?V3g3SnJscjNvQ21vTXNwN0lkemYySGNKaTMrMWtINm5vYXhwUk1wWkdvZ2xk?=
 =?utf-8?B?VHN0ZVAxL0VpcitvN3hKYVFGYjU1d0JHeHlxNFN0bHR4R0ovVmtrVzlveWpi?=
 =?utf-8?B?ZFNXT3hURUFBK2JBZWNnbUhFcWQxV3B2ZzN4NVF4SWRDYVR5enhZYklyWkFC?=
 =?utf-8?B?K2hDdnVqanNjZnBFS1plR0V3Q3R4TDNtY3lmUnhjNXUyRmJUWWJsNU5wbzVQ?=
 =?utf-8?B?RVBnTUZTcHV5U1pFUy9yZnNIT0tZb3RLbXRYa01sbjdVZHBKMDJLNEVKT1g0?=
 =?utf-8?B?Vmo1MkJrQ3lFdGFiOVk2Y2h2M25EMFJRRTJ4bm9YWTdPQXdVcENuNzEyMklk?=
 =?utf-8?B?aGlVY1VpYWYyOTk5a3E1K2NPOEIzNjQvcUN4MFJZeCtpTUZFN0ZSUGd0aHlX?=
 =?utf-8?B?ekJDWVAyYnVQekhYM3NNQmpaa0dlQ01qcEJ4Q083ZERpaU5GTjdtS05YYVFu?=
 =?utf-8?B?YTFSU1JoN0V6d2FFTzJMMWhMRWhwT0xPVmZYU2tkYS9heHp6bCtDNFpqWXRD?=
 =?utf-8?B?VDduTjVFOFduTURKUWE0cnl1RFNUa1kxZ0FLb0ZqOFlVNGo2cmpQdnphcW1j?=
 =?utf-8?B?OWRTRUt6OFRwU2hOL2hlU1AreDlLaWdGdnJURC9RNjF6cDlaRjhkUjBYNmE5?=
 =?utf-8?B?eEJUbndxSFVYbGE2d2M2L0FaYVc4cWI1MU1jbUJLeXNJelRSL2RUbWp3Z3Zu?=
 =?utf-8?B?dm1hY1VOdzZNVDdUTzdCRzlKaUhvdThRYWdVL0ZzNFNBWFpRWEFQTmlKTHBq?=
 =?utf-8?B?Tm9BTUxSSm9aaGgxK3djenJ6eTlTR3BHeHZFRStHZUFjSFVlVnVFSVA3V3A2?=
 =?utf-8?B?M3FVaXdKQ2dRbWhTVHNVSStHQVM3cGVwcXg1bGUzeGM0TnAxcThHcThIaUh4?=
 =?utf-8?B?eHBpUDRMeWNaMlhWNVpBOE94ZlMwcXR6L3EzOU9RMlkvdzhPUkZWNHZBQ0hx?=
 =?utf-8?Q?Qi8LClMr6FbZN2KT65kt23bKxh0yowqL6fKDGpA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D5B54488AB5C741B358DCFE1318408F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f465a6eb-90c0-479e-7877-08d989867864
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 11:34:48.6530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mIbA6n0el89zFMBVrXlUQb9iZ5B20HRsV5hfEZUpJAWNjPZmvAtqsiOlK99ouAikXZFtL2Yqk7rTpRNRV+61zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBPY3QgMDcsIDIwMjEgYXQgMTE6MjI6MzJBTSArMDAwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+ID4+IAlzcGE6IHNvdXJjZSBwb3J0IGFkZHJlc3MsIGkuZS4gdGhlIHBvcnQgdGhh
dCBsZWFybmVkDQo+ID4+IAlmaWQ6IEZJRCAob2YgdGhlIFZMQU4pDQo+ID4+IAllZmlkOiBFRklE
IChvZiB0aGUgcG9ydCkNCj4gPj4NCj4gPj4gSSBhbHNvIHRyaWVkIHNlbmRpbmcgdW50YWdnZWQg
ZnJhbWVzIGZyb20gdGhlIG5ldHdvcmsgYW5kIGN5Y2xpbmcNCj4gPj4gdGhyb3VnaCBvbmUgb2Yg
dGhlIFZMQU5zIGFzIFBWSUQsIGluIHdoaWNoIGNhc2UgdGhlIHBvcnQgd291bGQgbGVhcm4gYW5k
DQo+ID4+IG1ha2UgYW4gZW50cnkgd2l0aCB2aWRfZmlkIGNvcnJlc3BvbmRpbmcgdG8gdGhlIFBW
SUQuDQo+ID4+DQo+ID4+IFRoaXMgc3VnZ2VzdHMgdG8gbWUgdGhhdCB0aGUgSVZMIGZpZWxkIG9m
IHRoZSBWTEFOIGNvbmZpZ3VyYXRpb24gcmVhbGx5DQo+ID4+IGRvZXMgYWNoaWV2ZSBJbmRlcGVu
ZGVudCBWTEFOIGxlYXJuaW5nLCBhbmQgdGhhdCB0aGVyZSBhcmUgbm90IG1hbnkNCj4gPj4gY29u
c3RyYWludHMgaGVyZSBiZXNpZGVzIHRoZSBzaXplIG9mIHRoZSBsb29rLXVwLXRhYmxlLg0KPiA+
DQo+ID4gQ2FuIHlvdSByZXBlYXQgdGhlIGV4cGVyaW1lbnQgc3dlZXBpbmcgdGhyb3VnaCBFRklE
cywgYnV0IHdpdGggdGhlIFZMQU5zDQo+ID4gY29uZmlndXJlZCBmb3IgU1ZMIGFuZCBoYXZpbmcg
dGhlIHNhbWUgRklEPyBJIHdvdWxkIGV4cGVjdCB0aGF0IHRoZSBMVVQNCj4gPiBpbmRpY2VzIHdp
bGwgYmUgZGlmZmVyZW50LCBidXQgc3RpbGwgYXMgbWFueS4gSnVzdCB3YW50IHRvIGNvbmZpcm0g
bXkNCj4gPiB0aGVvcnkgdGhhdCB0aGUgRUZJRCBwcm92aWRlcyBwb3J0LWJhc2VkIGlzb2xhdGlv
biByZWdhcmRsZXNzIG9mIElWTF9FTi4NCj4NCj4gSSB3YXMgYWN0dWFsbHkgdGVzdGluZyB0aGlz
IGp1c3Qgbm93Lg0KPg0KPiBGb3IgVkxBTnMgd2l0aCBTVkwgc2FtZSBGSUQgYW5kIEVGSUQsIHRo
ZSBzYW1lIE1BQyBpcyBsZWFybmVkIGludG8gdGhlDQo+IHNhbWUgaW5kZXgsIGlycmVzcGVjdGl2
ZSBvZiBWSUQgKG5vIHN1cnByaXNlKS4NCj4NCj4gSG93ZXZlciwgY3ljbGluZyB0aHJvdWdoIHRo
ZSBFRklELCB0aGUgc2FtZSBNQUMgaXMgaW5zdGVhZCBsZWFybmVkIGludG8NCj4gOCBkaWZmZXJl
bnQgaW5kaWNlcy4NCj4NCj4gU28geWVzLCBFRklEIHByb3ZpZGVzIHBvcnQtYmFzZWQgaXNvbGF0
aW9uIHJlZ2FyZGxlc3Mgb2YgSVZMX0VOLiBUaGlzIGlzDQo+IGNvbnNpc3RlbnQgd2l0aCB0aGUg
ZGVzY3JpcHRpb24gaW4gdGhlIGRhdGFzaGVldCB0b28uDQoNCk9rLCBzbyB0aGUgRUZJRCB3aWxs
IGJlIHRoZSBiYXNpcyBmb3IgRkRCIGlzb2xhdGlvbiB0aGVuLiBBbiBFRklEIGZvcg0KYWxsIHN0
YW5kYWxvbmUgcG9ydHMsIGFuZCBhbiBFRklEIGZvciBlYWNoIGJyaWRnZS4NCg0KPiA+IEFsc28s
IGNhbiB5b3UgcGxlYXNlIHJlcGVhdCB0aGUgSVZMIGV4cGVyaW1lbnQgYnV0IHdpdGggVklEcyBu
b3QgaGF2aW5nDQo+ID4gY29uc2VjdXRpdmUgdmFsdWVzLCBidXQgcmF0aGVyIE4sIE4rMTYsIE4r
MzIsIE4rNDgsIC4uLiBOKzIwNDggZXRjPw0KPiA+IEkgd291bGQgbGlrZSB0byBnZXQgdG8gdGhl
IGJvdHRvbSBvZiB0aGF0IDQtYml0IEZJRCB0aGluZy4NCj4NCj4gU3VyZS4gSSByYW4gdGhlIHRl
c3QgYXMgeW91IHN1Z2dlc3RlZCB3aXRoIE49MTAwIGFuZCB0aGUgcmVzdWx0cyBhcmUgdGhlDQo+
IHNhbWU6IGZvciAzMiBWTEFOcyBhbmQgY3ljbGluZyB0aHJvdWdoIHRoZSA4IEVGSURzIGZvciBl
YWNoLCBJIGVuZCB1cA0KPiB3aXRoIDI1NiBlbnRyaWVzIGluIHRoZSBMVVQuIElmIEkga2VlcCBh
ZGRpbmcgVkxBTnMgKG5vdGUgdGhlIGxpbWl0IGlzDQo+IDMyLCBidXQgSSBjYW4gcmVtb3ZlIGFu
IG9sZCBvbmUgYW5kIHB1dCBhIG5ldyBvbmUgd2l0aG91dCBsb3NpbmcgdGhlIExVVA0KPiBlbnRy
aWVzIG9mIHRoZSBvbGQpLCB0aGVuIHRoZSBMVVQga2VlcHMganVzdCB0YWtpbmcgb24gZW50cmll
cy4NCj4NCj4gQ29uc2lkZXJpbmcgdGhpcywgZG8geW91IGFncmVlIHdpdGggdGhlIG1hcHBpbmcg
SSBzdWdnZXN0ZWQgaW4gdGhlDQo+IHByZXZpb3VzIGVtYWlsPw0KPg0KPiB8IFNWTDoge0ZJRCwg
RUZJRCwgTUFDfSAtPiBpbmRleA0KPiB8IElWTDoge1ZJRCwgRUZJRCwgTUFDfSAtPiBpbmRleA0K
Pg0KPiBUaGVyZSBkb2Vzbid0IHNlZW0gdG8gYmUgYW55IDQtYml0IHJlc29sdXRpb24gdG8gdGhl
IFZJRCBrZXkgd2hlbiBkb2luZw0KPiBhbiBJVkwgbG9va3VwLg0KDQpJZiB0aGUgMzIgVkxBTiBJ
RHMgYXJlIGluY3JlbWVudGVkIGluIHN0ZXBzIG9mIDE2LCB0aGVuIHllcywgc28gaXQgd291bGQN
CnNlZW0uDQoNCj4gPiBZZXMsIGluIGNhc2Ugb2YgaGFzaCBjb2xsaXNpb25zIGJldHdlZW4gdW5y
ZWxhdGVkIGVudHJpZXMgb24gYSBmdWxsIHJvdywNCj4gPiByZXR1cm5pbmcgLUVOT1NQQyBpcyBj
bGVhcmx5IG9rYXkuIFRoaXMgY2FzZSBpcyBtb3JlIGludGVyZXN0aW5nIGJlY2F1c2UNCj4gPiB0
aGUgTFVUIGVudHJpZXMgYXJlIG5vdCB1bnJlbGF0ZWQuIEkgd2FzIGNvbW1lbnRpbmcgdW5kZXIg
dGhlIGFzc3VtcHRpb24NCj4gPiB0aGF0IHlvdSB3aWxsIG5lZWQgdG8gZ2l2ZSBzd2l0Y2hkZXYg
dGhlIGltcHJlc3Npb24gdGhhdCB5b3UgYXJlDQo+ID4gb2ZmbG9hZGluZyBlbnRyaWVzIHZpYSBJ
VkwgKHNvIHlvdSBzaG91bGQgYWNjZXB0IHR3byBGREIgZW50cmllcyBmb3IgdGhlDQo+ID4gc2Ft
ZSBNQUMgREEgaW4gZGlmZmVyZW50IFZJRHMsIGFzIGxvbmcgYXMgdGhleSBwb2ludCB0b3dhcmRz
IHRoZSBzYW1lDQo+ID4gZGVzdGluYXRpb24gcG9ydCkgYmVjYXVzZSB0aGF0J3MgaG93IHRoZSBo
YXJkd2FyZSBpcyBnb2luZyB0byB0cmVhdCB0aGVtLg0KPiA+IFRoZSBvbmx5IHByb2JsZW1hdGlj
IGNhc2UgaXMgd2hlbiBzd2l0Y2hkZXYgYXNrcyBvbmUgRkRCIGluIG9uZSBWTEFOIHRvDQo+ID4g
Z28gb25lIHdheSwgYW5kIGFub3RoZXIgaW4gYW5vdGhlciBWTEFOIHRvIGdvIGFub3RoZXIgd2F5
Lg0KPiA+DQo+ID4gWyBieSB0aGUgd2F5IHlvdSBjYW4ndCBwcm9wYWdhdGUgZXJyb3JzIGZyb20g
LnBvcnRfZmRiX2FkZCB0byBzd2l0Y2hkZXYsDQo+ID4gICAgYW5kIHRvIHRoZSBicmlkZ2UsIHNv
cnJ5IF0NCj4NCj4gT0ssIGJ1dCBJIGd1ZXNzIHJldHVybmluZyAtRU5PU1BDIGluIC5wb3J0X2Zk
Yl9hZGQgaXMgdGhlIGJlc3QgYSBEU0ENCj4gZHJpdmVyIGNhbiBkbywgcmlnaHQ/DQoNClllYWgs
IHRoYXQgcGFydCBuZWVkcyBzb21lIHdvcmsuIEl0IGlzbid0IHNpbXBsZSBzdHVmZi4=
