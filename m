Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088504610F5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 10:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242075AbhK2JVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 04:21:39 -0500
Received: from mail-db8eur05on2097.outbound.protection.outlook.com ([40.107.20.97]:16288
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231185AbhK2JTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 04:19:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JY8kiuuQOoRxBp2PLxC0eugklOx8pX43mDygeWUUIRAM1XvbWWPMD3PFDu3MatSE45K2SJF/42ixjo3z/ozWGjezJosWIXkOOGTAIEHTkbt4nKGPD6KGAmr5ODfz9ZjCOU8l+tLnLfWWzauo7EB1oPM0Wfru3I5iNnruWknb7slzWPq9h3NuBDx6Ug68cNYfZ68pAz0lvhsp74rBCf797U2n75+9bZcEKf8njAsr+8TenBbN6zkumJRMBLLCnQTb5bozSTr7+BWL4O2adpTSaQRZFqLAlk/LzJMcqca3F7RtwpXF3zC9cWhU8QmhnZ/FmCxUSmdMujiqP8JelLe7Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Go26aNs2hkHVdoj3j+b0v29U9g/m1FwF/oaGXJFJ/6U=;
 b=PjTYOnc4HaWXhDLuEO695cPx0tSgRAoCv0dQvxuGh5Fz6K60iLXXPZAsuXzOe+Lk62tTFjjiCYTmBq88QBa8EmKBNJ9FxZpgEsnPC5uX8X6Rm+J2omQE0dK4NmcHmWKmh1RCCBRehD4QINtwynfVsbVWPwVsUGak4glLexo1UakUBbYQAQAHzm4fU9658GUnwT1teAY3O+5qWzd1K6mXrYapDCVZhVv0Jqkn43bAVPii+H8raL25tm8zFWMCNH79mH0Lo2G7FMDiIM97UCW2bObfwVFKZTFzyOvPe3milx/K99AALpZAkz/PlCfrFfaOQXw+NwEPvzIEOav8cmeiSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Go26aNs2hkHVdoj3j+b0v29U9g/m1FwF/oaGXJFJ/6U=;
 b=WYJJjBvuGJr5vkLQ6HOsSb1JIqK3nyW1NB9CZDgMlHvXb6Pg/15fs7Hoh2HqyiQr884xlDPhQv8G8A3SE4mTcfPeELyOYX+cp9Titho65wfNCHcfR2X7pS5IYco+U4Co9ynTqWmDbnxPL/dJ8ZwCpDUsRx2z/Z1GydP/3L3IVW0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4840.eurprd03.prod.outlook.com (2603:10a6:20b:83::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 09:16:18 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 09:16:18 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Thread-Topic: [PATCH net 1/3] net: dsa: realtek-smi: don't log an error on
 EPROBE_DEFER
Thread-Index: AQHX4sQxAJEIGz+qvUe1kaaV+tTig6waG7uAgAAiQ4A=
Date:   Mon, 29 Nov 2021 09:16:18 +0000
Message-ID: <426139eb-46a7-0c3d-dd2f-9dc5fc044a54@bang-olufsen.dk>
References: <20211126125007.1319946-1-alvin@pqrs.dk>
 <0948d94a-3a50-8cc4-7984-03a0fff0b7b1@gmail.com>
In-Reply-To: <0948d94a-3a50-8cc4-7984-03a0fff0b7b1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7345c38-c3fd-4c53-f34e-08d9b318e72f
x-ms-traffictypediagnostic: AM6PR03MB4840:
x-microsoft-antispam-prvs: <AM6PR03MB4840BDB1564107D3E640A2A183669@AM6PR03MB4840.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SjbyVn8Parf7Viqz49/DMclux2InzlwMPaDi8dFjRXD66i4GB8UlRgCzIJengrzC95zsnIzf01ejn1Av5wUMVtjLKxUByB/MBV4eNCJKnE0ERRnw1VIuBUqHr/EBtdcyZhYdqjCH7jp8LMaqnkGsnOUgb2bYMNv41R3gU41iv8QhAKPztFkQtegVbze2EozR9v+1oNnkr4JX551ao50/lPsGCELnFQ8IawUHxbkcuPlCp5Euf6hsVAytDbSjq9hJq9m2bwA+CJ6ZKEQblRNaSjuh/LVNXCWk8VSb7xGZg2cKX3M01OLr3jLxiKMM4Wt1echQbWPL9jv7RQANyUlHjp2ffarwf+blg9H43AhZVpTCmWf3Nmuq+28HLjPaJ/V/skwDdFZy0Aj2kzl3hJBrKYfhAZ3JnBVUJTIgbpfn6I0q3vbdIOd1GvISw6PMbZn0ts9cw0hoU0m3dkqzHdmYVCNL8MTq6fx9Cg0HpeGIGAqbM1vGqZVFcMpyMms11olufgxRlgdFLcH2SjJiRTlI76Ity2mRJGs3YlbL7xGc8uYcKIofpJSnP2CcjcQDFojpy6KbTBVN/tL9kJsMtEwnoe2DVQ9d6c3YNANm46LY7m4ZK2y05q9lgwrankpKcU8iZ/S4372dQh+2KnJ3SolpKEL1GX7OkQeCN2ytHtyMKjlSRL+OBJXc8sdOigkNEJd6LU4j5iLgqOCINM5B81hS7v0AHBkSSz2ogxWnWc+LdKEil6hpztvaHWbvk1Omh1YhYsI/tsFj1ElsqrpuZJqrTw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8676002)(508600001)(6486002)(31686004)(8936002)(66556008)(83380400001)(6916009)(66574015)(91956017)(66946007)(53546011)(86362001)(85202003)(66476007)(76116006)(64756008)(38100700002)(31696002)(26005)(66446008)(186003)(38070700005)(6506007)(4326008)(2906002)(122000001)(6512007)(8976002)(5660300002)(2616005)(36756003)(54906003)(85182001)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWNFQ1RNbmpVU1ozZ09MNWtpUng4aTltd0gzZ2U3U1B5WXVvaExONlFJcWJQ?=
 =?utf-8?B?VnR0R1VvS2QzWXRTTnNmbWhyMTFGU1dFSnNMTTlQYTZJL3BxYm9xTElvS0gv?=
 =?utf-8?B?UFZHV2hWUFg4Y0xaT0Nnekd1OFlrRXYxdkptc2VucS9XR1pHRk8wY1FCbWFV?=
 =?utf-8?B?SFlFYTgzWG9od1VyNTRkNzlCcjlBZFllNzVoRXVjdGNiblNldGhFSG1aM2ZE?=
 =?utf-8?B?SUg1dXM3Ryt2UElVYXJCMDBxOUVMcHZtWXNvdUtHeE51MzZHL0dsRUk1ZzZt?=
 =?utf-8?B?L2Y5aHRxaCtiTFpEMlA3akNKT1hYak5aZzhqeUMvbXZQVXlaaWJYYlZENjZY?=
 =?utf-8?B?RTB2TlB1LytsbDBiQ2ZObmxJL3FDK0ZEdnRLbFduMG4rdjdBNk1ycHYvbUhM?=
 =?utf-8?B?Y2MrbWVxSjFuRnpsZlNJWk0rR0RVOVdlVWJvVk1GSHZQUDNNZXpTVXZQTGxY?=
 =?utf-8?B?QXlYUzF5UnNzNWlFRzEwSllHZ3hsYmE3L1ZLQnA2MkJueTNTSWpBVi81bCtR?=
 =?utf-8?B?NDNBQzcxWnNTWkJsZi9mRk5lK2lnVlk5ZGp3Y2UwZlRPM2ZlaHZWeDJPekdz?=
 =?utf-8?B?Q1UyNkI3bjJVTjVQbVk3NnlpMGVYeHlqUkRPL1lyOFQ2Zm1yV0FXQ21wN0R5?=
 =?utf-8?B?VXoybHdEUEhrbDRZWmRoUG0xVUFjWXNIc3U5TlRIWElCaEl3Mlhoa1A2aFY5?=
 =?utf-8?B?ZVExd0o0MVRzTVJ3b0ZLYXVQZWtYeHBDdkhmN1dDUllFeG1xSm1hRkJ0NUZx?=
 =?utf-8?B?N09LTjVJVkxpMlVTNXp0dERVdEc0eHMydEFoZlpwMjUyMnB4YUZ2Z045NWFV?=
 =?utf-8?B?QlFabThySnBxLysrL0JvYjR4aUYwdzJwTXRMek0vRzkyNGNjUmQ1VXJqQ0FL?=
 =?utf-8?B?ZTNaM2EwUldpaUN1OXdmQnRJL05SSWlvUGNleHNsT0V5WndDWTRuSThRVnhJ?=
 =?utf-8?B?WGp2bEU4N2dQMHdJQzhHODlYQ1JjSWpWTSt2Sys0VHAya0g4b2U5QS9aN2Nz?=
 =?utf-8?B?NlE5ekcwRTNPNnVIdGpNdHl5dXJaOWlub0ZxNlFUaWxOejJRNlRyc0xTRE5o?=
 =?utf-8?B?c0NBVjA2YmN5VDJEOUlLamc4cVBpUHVwNEVNWHpiUENSU25xWlRFNjU2ZU9K?=
 =?utf-8?B?cDBIY0lTZDBkQlZlTFhZcTdpS3lDZ0xKRDY2UENKNnNYdlJRZCsvZ3RJSk5Z?=
 =?utf-8?B?dzE2WDBwc2I1M0NDdmQ2RnpGdTNjMFZ2SzBuK0VEK3cySnk3WnZlR1dBMHVJ?=
 =?utf-8?B?Tk00ZVBqQm1tZ0oxY1hFdWJ1MkFsRlFtdm1Ua1A0c1RqNVM1T0cwQldSUTRt?=
 =?utf-8?B?dlpRSU43aWYzL1E5dHhYbFhMUTkrbUVQU1RZVkwrd3VzdDd1TVYrZnJVQTFx?=
 =?utf-8?B?SDFJRmVvTlBWU1FzMWVCNllPa1RlMDdxeURXSHUrUmhkeWxkUEFVN2VxMlhL?=
 =?utf-8?B?eWgyR3o4NE92di9XUytjaXRhN1NSOVJrQnFnSVQzVm5NRGplRVB0VThuZFky?=
 =?utf-8?B?V0tNQlYrb3dyamQvZHhDNFY3VlRTbW5zTTA5c1pETEJSK2VQRGR6Rk0rZ3g2?=
 =?utf-8?B?V2VjYmsrRkV5RHJ5RUlMbmRXRzFRVTZVZ0pyUUFNZmIxSjUxMTNyQll6RHFG?=
 =?utf-8?B?L01penMwbE1XVitFRHV6TkZHaWpvWjdzYTVjWUdWY09FVGY5NFVoaXJpV0d0?=
 =?utf-8?B?ck8rU1ZCZ3M4cE9oZjFldXptSk84Zjk3L1ZDaUFzUkJHTUNqWW5ObEV0TTVp?=
 =?utf-8?B?VURPTzU5dk5BbnNjUGlaRjdORzQ4NC8rcjFabzlyS1BsT1BiL3pZWnVKNmF2?=
 =?utf-8?B?WWk1dHVVdXpRY0NWL1F1SlNyRzNSdnN4L1kwUmlZeW5kdmxmSVM1b1cycVdI?=
 =?utf-8?B?T0xDRmxQeFhpZmdacjRMWW9tTkp3YjRUVTJ6V2lQWFRYQU10VWR1c1pjQzdC?=
 =?utf-8?B?cE8vVGlBKzZxTHpZckErNzc0QlBYWTNLYUFoMHNIR0U5R2NLZXZLelJoaUp6?=
 =?utf-8?B?Q1lZRWJvZzdlb2ZINFB0M1VieTZsR2RhUmZwM3ZkaVR1VXVTOVlJODczbXVa?=
 =?utf-8?B?bEU5eThKTTZNcm1UWmJnRkZXUFpPcUJ0QXo3cHZVaFZmYU5qQW9OK0UxVnFu?=
 =?utf-8?B?ZFVyNnJYTXdiOHh6b0tQZHJPRnRTQ3RHcy8rd0dyenpXcy9JS3dGN1lDcm1T?=
 =?utf-8?Q?bR3NlWJzbJM1zWVNYZC0Epg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7A93A3F16440C46A917B30A9341C0DD@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7345c38-c3fd-4c53-f34e-08d9b318e72f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 09:16:18.7722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WAC2N6rirZSF/H9BkfxgVUILxBTEgo5KUlDXGS3V7+A3P+RQYmVgdJiaBWiSFx3fkUSrso6N043Nm3p4+Vv5zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjkvMjEgMDg6MTMsIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gT24gMjYuMTEuMjAy
MSAxMzo1MCwgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+PiBGcm9tOiBBbHZpbiDFoGlwcmFnYSA8
YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+Pg0KPj4gUHJvYmUgZGVmZXJyYWwgaXMgbm90IGFuIGVy
cm9yLCBzbyBkb24ndCBsb2cgdGhpcyBhcyBhbiBlcnJvcjoNCj4+DQo+PiBbMC41OTAxNTZdIHJl
YWx0ZWstc21pIGV0aGVybmV0LXN3aXRjaDogdW5hYmxlIHRvIHJlZ2lzdGVyIHN3aXRjaCByZXQg
PSAtNTE3DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1v
bHVmc2VuLmRrPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrLXNtaS1jb3Jl
LmMgfCA0ICsrKy0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay1zbWkt
Y29yZS5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWstc21pLWNvcmUuYw0KPj4gaW5kZXggYzY2
ZWJkMGVlMjE3Li45NDE1ZGQ4MWNlNWEgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9kc2Ev
cmVhbHRlay1zbWktY29yZS5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay1zbWkt
Y29yZS5jDQo+PiBAQCAtNDU2LDcgKzQ1Niw5IEBAIHN0YXRpYyBpbnQgcmVhbHRla19zbWlfcHJv
YmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4+ICAgCXNtaS0+ZHMtPm9wcyA9IHZh
ci0+ZHNfb3BzOw0KPj4gICAJcmV0ID0gZHNhX3JlZ2lzdGVyX3N3aXRjaChzbWktPmRzKTsNCj4+
ICAgCWlmIChyZXQpIHsNCj4+IC0JCWRldl9lcnIoZGV2LCAidW5hYmxlIHRvIHJlZ2lzdGVyIHN3
aXRjaCByZXQgPSAlZFxuIiwgcmV0KTsNCj4+ICsJCWlmIChyZXQgIT0gLUVQUk9CRV9ERUZFUikN
Cj4gDQo+IEJldHRlciB1c2UgZGV2X2Vycl9wcm9iZSgpLg0KDQpEaWRuJ3Qga25vdyBhYm91dCB0
aGF0IC0gdGhhbmtzLiBJJ2xsIHNlbmQgYSB2Mi4NCg0KPiANCj4+ICsJCQlkZXZfZXJyKGRldiwg
InVuYWJsZSB0byByZWdpc3RlciBzd2l0Y2ggcmV0ID0gJWRcbiIsDQo+PiArCQkJCXJldCk7DQo+
PiAgIAkJcmV0dXJuIHJldDsNCj4+ICAgCX0NCj4+ICAgCXJldHVybiAwOw0KPj4NCj4gDQoNCg==
