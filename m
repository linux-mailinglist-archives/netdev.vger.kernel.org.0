Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A446F425521
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242007AbhJGORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:17:23 -0400
Received: from mail-eopbgr60127.outbound.protection.outlook.com ([40.107.6.127]:39003
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241998AbhJGORU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:17:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdQG1cxMISS5tRnaqK8ciTdyozBP/wEZFz9zezZXbtycuy8d8jAP9JD1Jnquokt57GProXl2esIwAZNVJ91AQ1a6gPjZOf+s/dzf1xWatutfIk92Te0BTdw+romkvC5JvDgmHB0RBaOKH4wS9qLkPkz+XI6cJi3fN8C02hDCl7R+4VV8epHJLn7zIeJQFdugIlRbtMRUe2wwtmIcHms7lv1jttmJfDn9D4YLOkyb1j5KKgIq+u04kJ0GgeJg00DXn62Gnemdhh5HkAYHoztCkVf8Atg0sDMbzRvqphxu7NcO33JwhPJc9sq1tUIarFG87WrLAMR/YftqOR4S9pdafg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMqpTyGV/k1U1g/EIVpxg9gwRjo0qdfNUNqsurgW2sY=;
 b=l/cnxul9viKOc25JArVABU8ofCiIrGGN1050lpNFoK2B+qzreLXGdK2mYuftydeqhu3QuhUOlEx1d1HLnlex6SwB4IbpQEQ1VmaVga/cUdjn/7GR4hVFSO/xrTaSBAPa7ESCs7FnzSLJz5vxjJqz9RV/NrGFdRc1hF9nbSSi5y8fkrn1ejboT/l0cW67Utkf/K3WqG68CML2Odm+/DRED7QEj/YlqYZktLWtZx7KS/U5VFvt8WkPNj0wkSeDobCqWxRJlrs/60GC2Dx6GBIeNfG6BXd/mUXkZH/Rg7HIcsrMjtnS8g0qiUUJI3XxiyLA7wUz5Fyz67sQ3fKnw2o/5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMqpTyGV/k1U1g/EIVpxg9gwRjo0qdfNUNqsurgW2sY=;
 b=RnRJkRvbZx51iW7Z9m4dQjJdDexQS0t5q1q/KXymNYrtD7YSj5lo+JsMYNnA7SHsphiSyP/JoSgbYxL6bpUie1kdyjgMvkP5X2Hx5aOlBDf9+gR35pq6HJtJTGSLlvwtBzYtW6wo13xvutUHIFsSzXoXhCRO5wvVHZeRqQga/s4=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2812.eurprd03.prod.outlook.com (2603:10a6:3:f6::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.22; Thu, 7 Oct 2021 14:15:23 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4566.022; Thu, 7 Oct 2021
 14:15:23 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: DSA: some questions regarding TX forwarding offload
Thread-Topic: DSA: some questions regarding TX forwarding offload
Thread-Index: AQHXucaemV05T+14+0C6ajjHlibfJavEL5CAgAAgAgCAABbYAIAAE5gAgAANB4CAAaB4gIABJYaAgAAaqICAAANuAIAALN0A
Date:   Thu, 7 Oct 2021 14:15:23 +0000
Message-ID: <9150c268-d5c5-53ba-babe-17fe8ed6bce4@bang-olufsen.dk>
References: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
 <20211005101253.sqvsvk53k34atjwt@skbuf>
 <f6974437-4e5c-802f-a84c-52b1e9506660@bang-olufsen.dk>
 <20211005132912.bkjogbbv7gpf6ue7@skbuf>
 <3603d4eb-61d0-e64d-3e9d-53803d8c46a4@bang-olufsen.dk>
 <20211005152557.wbn7ojk5nphos5s5@skbuf>
 <cd717680-dbac-4329-75af-32d0c677d622@bang-olufsen.dk>
 <20211007094707.wg24vgbf57cr76mi@skbuf>
 <0726ca75-e615-0872-7222-abdb7a28ce8a@bang-olufsen.dk>
 <20211007113448.y4ijmlthgf4qxejz@skbuf>
In-Reply-To: <20211007113448.y4ijmlthgf4qxejz@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bea60e8-f5c6-48d8-8e17-08d9899ce70b
x-ms-traffictypediagnostic: HE1PR0302MB2812:
x-microsoft-antispam-prvs: <HE1PR0302MB2812ED3B4B651D319295A9BA83B19@HE1PR0302MB2812.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8qANF8T0ucehmupTtDm6R6ESRVYqYm8sTyjes5lvj6SRK20fXWkRkogT7ZIilW2HTkLqHLLWRagoBxs0tbFSfTZT20YAs8ldIzeF2yzLBLO1J3tROq8ULkS5bwoJpyVy8II9z9BaqEb9GteUlcLEmfrwIGjWd3GdCmjEOp5S607BhIuFQwNCJ8pf6R6D5ZjN3NzMckoYbvkSBvL6o/LKazFvGCKpmkdcI5bWkG6YSc8oM8cCDwAV1WUuYLOPPP/ooyrEh9BjSVSlTay5Z/CL3uMsB4wKuprIxcoMw7zbTTVSQwSh69p2+b45E/e2BE9QPZFY6E/z8SGAt20INTC2XmBpmGq/TgRXIbk74TkTXgGY9x8qM4j+o0aNnWc2WEDPczJPu+BSTTww9wZglIg84MpBvaO1rfTD2xGFdLgoBTr4pKPyAc01gar9Wgz0nZ7sQxg+GntNYA3STOIEcUzqom0+lRQA366JWLUnM9biEbDsXkqwfP+X7Bw4klRX93xB9vZ1UkRHaI/VW1nkQ7bkO12gkgi4z41Gu1GBuHDhIIls0wdhrDvqzmEXRQYaDOYtNSwII6MXD+ve7+QUksNQ5EKXm8pn9lOJPi7h5FHA4mur+owT3YeGW+M+3wqwdvUqyyejLGPOfyhlFdI7Q5OGMWiEyxazZqPyDWuUBTF8xI6G8LqUaEi+VOU69PWiFY3XFaqJmyVGy/l2TKFBM57NYa4i/IRgqKUP+i8gIAHo9T1+83tLsnvm2/2PHddqWYFJwGjPt9m42KwLv3Ss3J/DIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6486002)(64756008)(6512007)(85202003)(85182001)(8976002)(316002)(6506007)(86362001)(38070700005)(6916009)(8936002)(54906003)(31696002)(38100700002)(122000001)(91956017)(36756003)(66446008)(83380400001)(26005)(4326008)(5660300002)(8676002)(508600001)(71200400001)(66946007)(66574015)(66476007)(186003)(2616005)(66556008)(2906002)(76116006)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFhtaUJQZ0dUTVoxUW9wZ0xxWTFhM3FNMSs0WkxQNmk2TWFWb0lVMlZnUm9p?=
 =?utf-8?B?ZVFIMjFnWXFMNEpicitTTmgzbnJGNjNjZDlPWWQxVHo2WWdFaFRTNHNkMi9m?=
 =?utf-8?B?dW1TYlJGaXg1cGxEWGh3b3VjNkhDVlptUEZzQ1JaaFFwbkFobXR2N3l3Z043?=
 =?utf-8?B?a2tMd1pVazJic2pkYldGbHVoL0N5MVJmTk53RTdqa1QvRk1NOHZpaCtTQTY1?=
 =?utf-8?B?UEhpSXpmNHpjRHFkYndSOUloTWxGZjBLdjM4VXE2aXJMUlRpMUlLSG8xbU41?=
 =?utf-8?B?aHRnZFRJaEFCRHF5RHJJZi9qNnBoTVdWTStoSm9XVG5qTjNqNU4rQWw5V1Va?=
 =?utf-8?B?VzNLTEx4clM0RkNTVE1WUTBNZmJWN2tvamY3SVRnVng4dmkxQlF0WEZrYlha?=
 =?utf-8?B?aThaaklSb0xKOFozdnBCby9hbDA3RzJvancxbEsvMkJiRUpyQkx0cDdmZzJZ?=
 =?utf-8?B?aVZsK0I4eUE4WC9qWEpQR2VaeTZHbmN0VU91VldOYlpaTlVaK1RPbXl5aENa?=
 =?utf-8?B?OGphRzJxQ29MTW9POW9KdzdnTlczS2p0TXVMRFd0TUlydGFPNzRXOS9jQm1p?=
 =?utf-8?B?N2M0aUVycFhpZlh2ZlhNZXFwQWw2SkFSK3AzZzdtbTRuNW5zM3RmSzBsUEJ1?=
 =?utf-8?B?SVNjclNRVyszb0lTaW91ZjhSMmtTQ3MyMWxTem53OWdReGV5RTRMbC9EVEtL?=
 =?utf-8?B?OEkvLzVhbHdnRys0L2ttUnljWE4rQzY4S2pyRk5JcHloalFzUmQwUlA2dTNC?=
 =?utf-8?B?SG5uTGZoWW40YUZDSGV1ZnVvdkx3RlNWMzlheWdBODdiU042TmU2TWVwYmtH?=
 =?utf-8?B?WFhQSHEzV0lXWXNaeXdYZTJmZTJmTVZjOVZSbTBZb2wrSGJKVnQrOHU5NVB0?=
 =?utf-8?B?a3lVcG1JdUxoMUlNYmhtK1pjWTQ3YVM4VmZnUW1KTlo2azd5QnFzclYrd2FN?=
 =?utf-8?B?RW54R1dWdkp2WUxuVTJjU3BNYldwaEJjSW81cGgyZmVJMlBIUjQxT2p6cG5n?=
 =?utf-8?B?OGc5VStESlV5aFhZalRNZzEyYWduUjhuTFFKSjh5a25XZjVxSW9wNWtvVkdP?=
 =?utf-8?B?RzFSTUQxdTVvdVZJWmk3K2xJMUI2akROZnh3VmY1bVNmWDhhaDhVS2prUmhE?=
 =?utf-8?B?eW0vN0N0SmdlRTdMZzcrbzBKQVRMZFR6OEp6bkIvVGFWaHV5bHRmTXE5SUhY?=
 =?utf-8?B?QTNDeUNmc2tmUzB0Nkd0aHRkdmJtd1JsaXdlSkI3aklRVVdocWkxRDNzWVAx?=
 =?utf-8?B?bERjcjBqNFZienpzUmdNT1ZaRko4UjQ2aWhvRGxvWWNFYm5PTzY4MFpOQ1lJ?=
 =?utf-8?B?dGVPdTNPYkV6TzcxaVEyK3dkZUF6Q0JkU0FxZmhyVDRoUGE4T21tdkJDNXdX?=
 =?utf-8?B?TnMzSHFXSVFRNkE0UDB1bGFqL3d0NkY2cGN3azJRTzJyeVN1T09mc1JjWDVo?=
 =?utf-8?B?TzhXMEJpNFZoMUMyM0RJY0V5dll5dlhIZEtiZjRweHBSbGIxYlE0Mit3cmZU?=
 =?utf-8?B?SkNSbUg4dklRaW9SWFZjRXdkSXZJTFY5VU16Q3hZVUt4d2JheDdScFZCb0tw?=
 =?utf-8?B?WWRBczY3N1FQaWF5cm1uUXo5ZkpzWSs2TzlSWmtZWlBzTU1HaGdsUHZjWmNi?=
 =?utf-8?B?bzk5dGptc3hLQks4SlBaZVp6ZFVDRlV1MHMyOXM4Vnk0K24xKzFPUWpUdVpa?=
 =?utf-8?B?c0ZOTWJ5ZTFjdmtBYWx3Vjc0cWZlUG55ckc3TjlySGo5Q2RSRmdjZDljK2NY?=
 =?utf-8?Q?9WCQjCShheH0f9fDw/y45aNL8G7lBuvwlldeP87?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <344F0C7F8D35B6488044064ED1F90B0F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bea60e8-f5c6-48d8-8e17-08d9899ce70b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 14:15:23.1834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lp/VOb5AbSQSxtjwSXnVP1bkgk4CipCodqasyaVuJgb+kJHsG6X5zJcBYy35P+fhvK6/0dcgnGYB6cXuzUiLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2812
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNy8yMSAxOjM0IFBNLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IE9uIFRodSwgT2N0
IDA3LCAyMDIxIGF0IDExOjIyOjMyQU0gKzAwMDAsIEFsdmluIMWgaXByYWdhIHdyb3RlOg0KPj4+
PiAJc3BhOiBzb3VyY2UgcG9ydCBhZGRyZXNzLCBpLmUuIHRoZSBwb3J0IHRoYXQgbGVhcm5lZA0K
Pj4+PiAJZmlkOiBGSUQgKG9mIHRoZSBWTEFOKQ0KPj4+PiAJZWZpZDogRUZJRCAob2YgdGhlIHBv
cnQpDQo+Pj4+DQo+Pj4+IEkgYWxzbyB0cmllZCBzZW5kaW5nIHVudGFnZ2VkIGZyYW1lcyBmcm9t
IHRoZSBuZXR3b3JrIGFuZCBjeWNsaW5nDQo+Pj4+IHRocm91Z2ggb25lIG9mIHRoZSBWTEFOcyBh
cyBQVklELCBpbiB3aGljaCBjYXNlIHRoZSBwb3J0IHdvdWxkIGxlYXJuIGFuZA0KPj4+PiBtYWtl
IGFuIGVudHJ5IHdpdGggdmlkX2ZpZCBjb3JyZXNwb25kaW5nIHRvIHRoZSBQVklELg0KPj4+Pg0K
Pj4+PiBUaGlzIHN1Z2dlc3RzIHRvIG1lIHRoYXQgdGhlIElWTCBmaWVsZCBvZiB0aGUgVkxBTiBj
b25maWd1cmF0aW9uIHJlYWxseQ0KPj4+PiBkb2VzIGFjaGlldmUgSW5kZXBlbmRlbnQgVkxBTiBs
ZWFybmluZywgYW5kIHRoYXQgdGhlcmUgYXJlIG5vdCBtYW55DQo+Pj4+IGNvbnN0cmFpbnRzIGhl
cmUgYmVzaWRlcyB0aGUgc2l6ZSBvZiB0aGUgbG9vay11cC10YWJsZS4NCj4+Pg0KPj4+IENhbiB5
b3UgcmVwZWF0IHRoZSBleHBlcmltZW50IHN3ZWVwaW5nIHRocm91Z2ggRUZJRHMsIGJ1dCB3aXRo
IHRoZSBWTEFOcw0KPj4+IGNvbmZpZ3VyZWQgZm9yIFNWTCBhbmQgaGF2aW5nIHRoZSBzYW1lIEZJ
RD8gSSB3b3VsZCBleHBlY3QgdGhhdCB0aGUgTFVUDQo+Pj4gaW5kaWNlcyB3aWxsIGJlIGRpZmZl
cmVudCwgYnV0IHN0aWxsIGFzIG1hbnkuIEp1c3Qgd2FudCB0byBjb25maXJtIG15DQo+Pj4gdGhl
b3J5IHRoYXQgdGhlIEVGSUQgcHJvdmlkZXMgcG9ydC1iYXNlZCBpc29sYXRpb24gcmVnYXJkbGVz
cyBvZiBJVkxfRU4uDQo+Pg0KPj4gSSB3YXMgYWN0dWFsbHkgdGVzdGluZyB0aGlzIGp1c3Qgbm93
Lg0KPj4NCj4+IEZvciBWTEFOcyB3aXRoIFNWTCBzYW1lIEZJRCBhbmQgRUZJRCwgdGhlIHNhbWUg
TUFDIGlzIGxlYXJuZWQgaW50byB0aGUNCj4+IHNhbWUgaW5kZXgsIGlycmVzcGVjdGl2ZSBvZiBW
SUQgKG5vIHN1cnByaXNlKS4NCj4+DQo+PiBIb3dldmVyLCBjeWNsaW5nIHRocm91Z2ggdGhlIEVG
SUQsIHRoZSBzYW1lIE1BQyBpcyBpbnN0ZWFkIGxlYXJuZWQgaW50bw0KPj4gOCBkaWZmZXJlbnQg
aW5kaWNlcy4NCj4+DQo+PiBTbyB5ZXMsIEVGSUQgcHJvdmlkZXMgcG9ydC1iYXNlZCBpc29sYXRp
b24gcmVnYXJkbGVzcyBvZiBJVkxfRU4uIFRoaXMgaXMNCj4+IGNvbnNpc3RlbnQgd2l0aCB0aGUg
ZGVzY3JpcHRpb24gaW4gdGhlIGRhdGFzaGVldCB0b28uDQo+IA0KPiBPaywgc28gdGhlIEVGSUQg
d2lsbCBiZSB0aGUgYmFzaXMgZm9yIEZEQiBpc29sYXRpb24gdGhlbi4gQW4gRUZJRCBmb3INCj4g
YWxsIHN0YW5kYWxvbmUgcG9ydHMsIGFuZCBhbiBFRklEIGZvciBlYWNoIGJyaWRnZS4NCg0KT0ss
IHRoYW5rcyBmb3IgeW91ciBwYXRpZW5jZSB0aHVzIGZhci4gSSBoYXZlIGp1c3Qgb25lIG1vcmUg
c2V0IG9mIA0KcXVlc3Rpb25zLCB0aGlzIHRpbWUgcmVnYXJkaW5nIFZMQU4tdW5hd2FyZSBicmlk
Z2VzLg0KDQpGaXJzdCBvZiBhbGwsIEkgbm90aWNlZCB0aGF0IGV2ZW4gd2l0aCBWTEFOLXVuYXdh
cmUgYnJpZGdlcywgaWYgSSBhZGQgDQpWTEFOcyB0byB0aGUgYnJpZGdlIG9yIHBvcnRzLCB0aGVu
IG15IC5wb3J0X3ZsYW5fYWRkIGlzIGNhbGxlZCBldmVuIA0KdGhvdWdoIFZMQU4gZmlsdGVyaW5n
IGlzIG5vdCBlbmFibGVkLiBUaGF0J3MgT0sgYW5kIHRoZSBzd2l0Y2ggd2lsbCANCnN0aWxsIHJl
Y2VpdmUgdW50YWdnZWQvcHJpb3JpdHktdGFnZ2VkIGZyYW1lcyB3aXRob3V0IGNvbXBsYWludC4g
QnV0IGlmIA0KSSBtYXkgYXNrLCB3aGF0IGlzIHRoZSBwb2ludD8gRXZlbiB3aGVuIHByb2dyYW1t
aW5nIGEgUFZJRCBvbiBhIGdpdmVuIA0KcG9ydCBvZiBhIFZMQU4tdW5hd2FyZSBicmlkZ2UsIHRo
ZSBzd2l0Y2ggaXMgbm90IGluc2VydGluZyA4MDIuMVEgdGFncyANCm9uIGluZ3Jlc3MgZnJhbWVz
IHRoYXQgaXQgZm9yd2FyZHMgdG8gdGhlIENQVSBwb3J0ICh0Y3BkdW1wIG9uIHRoZSBzd3BOIA0K
aW50ZXJmYWNlIHN0aWxsIHNob3dzIHVudGFnZ2VkIGZyYW1lcykuIFNvIEkgZmFpbCB0byBzZWUg
d2hhdCBjYXBhYmlsaXR5IA0KaXMgYmVpbmcgb2ZmbG9hZGVkIHRvIHRoZSBzd2l0Y2ggaGFyZHdh
cmUgd2l0aCB0aGF0IGNhbGwgdG8gDQoucG9ydF92bGFuX2FkZCBmb3IgVkxBTi11bmF3YXJlIGJy
aWRnZXMuIE9yIF9zaG91bGRfIHRoZSBzd2l0Y2ggaW5zZXJ0IGEgDQp0YWcgZm9yIHBvcnRzIHdp
dGggYSBQVklEPw0KDQpUaGUgc2Vjb25kIGNvbmNlcm4gSSBoYXZlIGlzIHJlZ2FyZGluZyBsZWFy
bmluZy4gV2UgYWdyZWVkIG5vdyB0aGF0IGFsbCANCm9mIHRoZSBWTEFOcyB3ZSBhZGQgdG8gdGhl
IHN3aXRjaCBzaG91bGQgaGF2ZSBJVkxfRU49MSwgbWVhbmluZyB0aGF0IHRoZSANCnN3aXRjaCB3
aWxsIGxlYXJuIGluIGEgVkxBTi1hd2FyZSBtYW5uZXIuIElmIHRoZSBzd2l0Y2ggcmVjZWl2ZXMg
YSBmcmFtZSANCndpdGggTUFDIFNBPTAwOjAwOmFhOmFhOmFhOmFhLCBWSUQ9MSBvbiBwb3J0IE4g
b2YgYSBWTEFOLXVuYXdhcmUgYnJpZGdlLCANCml0IHdpbGwgc3RpbGwgaGF2ZSB0byBmbG9vZCBh
IGZyYW1lIGZyb20gdGhlIENQVSB3aXRoIE1BQyANCkRBPTAwOjAwOmFhOmFhOmFhOmFhIGlmIHRo
ZSBmcmFtZSBkb2Vzbid0IGhhdmUgVklEPTEsIHJhdGhlciB0aGFuIA0KZm9yd2FyZGluZyBpdCBk
aXJlY3RseSB0byBwb3J0IE4uIFNvIGFsdGhvdWdoIHRoZSBwb3J0cyBvZiB0aGlzIA0KVkxBTi11
bmF3YXJlIGJyaWRnZSBhcmUgcmVzcGVjdGluZyB0aGUgcnVsZXMgb2YgVkxBTi0odW4pYXdhcmVu
ZXNzIGFzIEkgDQpyZWFkIHRoZW0gaW4gdGhlIHN3aXRjaGRldiBkb2N1bWVudGF0aW9uLCB0aGUg
aGFyZHdhcmUncyBsZWFybmluZyANCnByb2Nlc3MgaXMgc3RpbGwgVkxBTi1hd2FyZSBhbmQgbWF5
IGNhdXNlIG1vcmUgZmxvb2RpbmcgdGhhbiBleHBlY3RlZC4gDQpNeSBxdWVzdGlvbiB0byB5b3Ug
aXM6IGlzIHRoaXMgYWNjZXB0YWJsZSBiZWhhdmlvdXI/DQoNClRvIHdvcmsgYXJvdW5kIHRoaXMs
IEkgZ3Vlc3MgSSBjYW4gc2V0IHZsYW5fZmlsdGVyaW5nX2lzX2dsb2JhbD10cnVlLiBPciANCkkg
Y2FuIGRvIHNvbWUgYm9va2tlZXBpbmcgaW4gdGhlIGRyaXZlciBvZiBWTEFOIHNldHRpbmdzIGFu
ZCBvbmx5IA0KcHJvZ3JhbSB0aGVtIHdoZW4gZW5hYmxpbmcgVkxBTiBmaWx0ZXJpbmcsIHdoaWNo
IGlzIGEgYml0IG9mIGEgcGFpbi4gDQpIb3BpbmcgeW91IGNhbiBoZWxwIGNsZWFyIHRoaXMgdXAg
Zm9yIG1lIC0gSSBoYXZlIGEgZmVlbGluZyBJIGhhdmUgDQptaXN1bmRlcnN0b29kIHNvbWV0aGlu
Zy4NCg0K
