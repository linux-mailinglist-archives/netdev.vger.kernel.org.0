Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0CB6BB46A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjCONWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCONV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:21:59 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2118.outbound.protection.outlook.com [40.107.8.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286AA74A49;
        Wed, 15 Mar 2023 06:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7i+/23LpKRukX863YKVoPX0l0YOyBDJOdfP5liv5zQsZpoUJBuYf/0w8Sp9wi52ekePt3mePQNRWC+BSyuf7RTpiZh1JJ7Ob4H7TWvMDuUn7r/JG43AgVe711xIiCStSRT0vA9rTBAsTnZrefuyGPIQsgfOJRaLAnPAY0Eg7VdDsKTUZJ3x5aFOn2T2rsf1L0kbttHeB+39PnzcSQR+MXLaMiDQckhg6pTctB2KM+KYLAYv3SigVJptQgnrA1XWf6+rev5I+RLuj3/Qtc+Lt7iVQ9ox6n2DJooS2aZeP74U8GzNmKXC2mJW+/mn9mDt2fw34O9WClwnCxCKdn6epQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnpKq3BnkOlgxogV/WwTGuSsBjjct+ZAkHH0xrtIIwg=;
 b=KbvB6Omw/iImxZ8w+VCmuiF7J9VMXOrewOR+i126ZBLM6if/ECkm8CoivqyQ/gnWJui1Ecr+VNkipGSSVJDS4z2TPdeW0ce664GZoYw/ZGj7u7z2ID+9f2JfdRJPoWA3o3e0PvMdOCyz0lQqnfgRl5tmNMygZE3d39LKdRVzY34fI+382DL92t6V3grLSKRaqbXUbyFmXVS8veidpOIT5xG8Fmc8iaLZHmzZv/PeDwGuDBcwZputd2pWRZAq+wjjUQbuH1qX3NxV9Jl/9sN8X6Gyl8bfSvBK+fAcr69If1tGYDsIH96qxRzHoMVlff9vosMxd+uRYB1WpgAw2yDGtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnpKq3BnkOlgxogV/WwTGuSsBjjct+ZAkHH0xrtIIwg=;
 b=rQTQGK9/Pm7MTrUTd5ODH8tAMGZx1F6VNw1HR0ZDna3wtjPBPjUCKrUR/tCtlFZDNSrTpzpm+sd/FcqYY07xp7tgO4f3LShQ2KXUsDKgrd8j5qnkaJN3shTe3+cz2hWI+mfNofQ7xl23tMV0eCrsPUMf04GsPGg0uMmOMFFKie4=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM7PR03MB6657.eurprd03.prod.outlook.com (2603:10a6:20b:1ba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:21:50 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:21:50 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in error
 messages
Thread-Topic: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in
 error messages
Thread-Index: AQHZVz9ncwIQGHtkZ02ET+txG5HVha7707QA
Date:   Wed, 15 Mar 2023 13:21:50 +0000
Message-ID: <20230315132150.fuu3iudzxzm2b7kz@bang-olufsen.dk>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <20230315130917.3633491-2-a.fatoum@pengutronix.de>
In-Reply-To: <20230315130917.3633491-2-a.fatoum@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|AM7PR03MB6657:EE_
x-ms-office365-filtering-correlation-id: 56ac391d-3669-4474-5664-08db25583c71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Q6u2NrUGMtShWRHF2DMbwiK1ysnfGxiTX2rkrBj10zb31CmGS2eC+ezSRZTExwJvwMRVKhk9qmT0rdU9T2QP+daVbe5aTp6hAUf/jcK+6UzDMvIv7CvkaZKEYVycaHggHESfARQdkTbkRFj9p2/9MLQJxhwNbTfSn7m3zg7NU3T2uT6mdrSfVzEqi9NtAJR9f70A37+sfzeyWdqYQ0s1zs4fFUtSAe+aU1B+cARj4Gfg3LGTonXndPWf1iDVHLz6+KoCmafauofEEu6Uwmsv/SstcNoUOEzyi53wOIWu0DTswPHZ9xRumbYxHhvUfkKLNCMaToW3qj7z5m/lX2yOP7UCI2g7EE11bYa03Rz9jbH7yrJLHIf77v2z5kiqBmr49lxOvXCPaQHh2/PxLbluzvj4xcZ+vat3n0Sncbu8femhjdVKiEYbMW5JCibadegxjlDmpC0GZwt4ymM0ZuGfly3MW0Oc9cIeHgBMqnwkIy6vXgdjy5h0NBkwhoEdTcORVTpyqevQXDV4z00Ocdc8vtbMD4H1nT7lQdCoeNQ44+XNdHYdIXoNgVcRBeAgAGSy0TJxzs6DXvMA6MJfSfeCWJ5IvLLcR6YdxpQ3dAfvzG8LpI+kkEiUSWtVWRXa5RlwnjwvayEMFH/g7xYn8vz8YPNwOhyvgO+OLKPhuepclJhUSJLf8TP3HYq3DcZxAwLPrDeVpZaIu5nZlt123ltCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39850400004)(396003)(346002)(376002)(136003)(366004)(451199018)(85202003)(85182001)(36756003)(6486002)(122000001)(6506007)(6512007)(1076003)(26005)(186003)(83380400001)(2616005)(66574015)(5660300002)(8936002)(8976002)(7416002)(86362001)(4326008)(6916009)(41300700001)(15650500001)(2906002)(38070700005)(38100700002)(8676002)(71200400001)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(91956017)(316002)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TW5Gb2g2bjNWd1VWOTY5alduZm1yTlFLWUlJcG1UVVB1a1V3bDV6ajNyaWFC?=
 =?utf-8?B?a3pYbXUzSlBIMjMzVW1sQ002bHpTNWNlVi9YMkwrZ2p4MWh6SFFtWjZ6WCtG?=
 =?utf-8?B?Ti8rR1NaQTJCYlJySllveTdNZ3YrTisxRFc2aU1FRjBDRmRDQ3ZWbzdDVGtN?=
 =?utf-8?B?NSs4Y29aQWl6Z0pxdHZzT2w4cDVqUm9wbkxsK3VRblVBeThLcCtpQzZyRW5o?=
 =?utf-8?B?dEpDMDJLNVZiUFpqTytscUlWYnRPWnZ6eDE3NE9SWWNQKzJTY09sT0NML0Q3?=
 =?utf-8?B?SEpwbUF0VmZzYTZvZFF5WndUbmZScGtQY2lTcVhNVjRPd0E2VjBXYTMzMlpC?=
 =?utf-8?B?RWdaYVB0MHhjNCtrSzZsWHdLYWhRbFQ2L2xpR2RGenhleDRWWjR5NjBud0hZ?=
 =?utf-8?B?c2Uzd09FRzRDZFlvQlR5bXZWYVpsczc4QXo3bHlMN09iUVUzYW5Kc1ZLM1Y4?=
 =?utf-8?B?bnNoVDJOL0R4aG9RM3BKWlBUYW5RN2NodTA2UjRSRjNKV2FmTVFUUVRXbGpr?=
 =?utf-8?B?SU5DSDUwK0xOU0lGV1dUT3d0UVJXaEtISytUaGd3RlJVYWZ2cWtmS2hNTDJn?=
 =?utf-8?B?RWhKTC9yc3F0RnpBV2hubmNDSUJhMkNnTVVTekhxK3kyZ1lxQlo5cE9KaTZI?=
 =?utf-8?B?OFhSSUVZUTZhdi80cWMvalVZTDZyb09rK0lGa0xMTEJCMVlhWkFmOXFnMzha?=
 =?utf-8?B?UFlPR0MvT0IyWU1LODRpNUxYZ1MxaXRtY3RyYWlkcExia1oxWXpJRGdYREVh?=
 =?utf-8?B?VEVlWkh5b1FXakIxbERHWEg2WitFUk43UEpwcnpvR3FycStIT1BxbFl0M1F5?=
 =?utf-8?B?QXA5b2ZFcTNrV3FUSlU3NktrTkErZHE0Y080L2VKelhMelhTMmwvTkI5c2Zs?=
 =?utf-8?B?elhVTzZISW9jdWF6NGtRUVZKN25JQ1pncFRveHZLWjFjZER6Q3JtQmNkQWVU?=
 =?utf-8?B?eEJEeXUwWEoyRHdhRVJBOUc4RlhLcDhRbFZQd1RwK1FXZDRYNkpZaEY0eVFO?=
 =?utf-8?B?LzZ1UEVkWnAvRGJoVThiRk10bDZpdUQrRU5zWHlURWlZTUl3ck1NOTlPN3BM?=
 =?utf-8?B?akFobVRBWUVVYmpJNytESFZubmZhd2V3czVQRllTSm9HNGNhQmJLNTdiTVJh?=
 =?utf-8?B?L1FoNW5pRzEyQjlCOU85VjZpMGN4TUZiQ3hWeStEN0dKaGtKVlY0aWo2N3g0?=
 =?utf-8?B?a0E4NUdnYU02WEp3aGtvbHFzeUY3OTBnbEduL1FiRjNYbU42Q2VUclRhd0RN?=
 =?utf-8?B?ZXkxUjgvTHVtTnZOWCtYU2NCRHllNU9ibXFUdDhIcFFIaWN3RFh3c3BOWExM?=
 =?utf-8?B?L3ZiMFBPemV4WTlyd25yNjh5aWExYlRqbUhEb29IOG1SSXhmRWRGOGpmbkFK?=
 =?utf-8?B?Zktmay9rb3hYL3RFYlEySzVQNGJZMkRFZnljd1VSS3pMNVc5eHU3cHV4RW9I?=
 =?utf-8?B?eHpFUUQ0MFhHcFhHMnl0aVZnMkZuQWV2eHM1T0k3aXFhdUdWL1JHOTJ0QTZ0?=
 =?utf-8?B?VjJzRzBYb2hjVzlZYzY4NUtjUnBWNmt6OGRDSGtQTHpYUkFoTUlnTURWUmwv?=
 =?utf-8?B?N1ltYldjSTFaVGtCTmdUQmJIV0ZqdTdFTmtrb1RGNnhINlg4TEd6ZUlwQXh0?=
 =?utf-8?B?NVg2YkFEZm5ISUE0a2t1VFkyZUxYenBKdDhHSlF1T25hQlZ3YXh1MUNURGNp?=
 =?utf-8?B?WHVhek0xWXg4eFIvMVpzR01lSHNLMW9qZ2FTNFBRUHFDT2RZV2hDQ2FGREtW?=
 =?utf-8?B?RzFUNUlqdUkxNHBaNldBeStnS0tHNE5wSTU4YmV4dFRxdEZvQktydnJTeTNN?=
 =?utf-8?B?ZUlEV0M3KzJhMndQSnhoK1RpMU56VmhYaFh4RnVRVnNOU1FZdkZWaTJFWHBV?=
 =?utf-8?B?RjNkLzFPbjNSRGk1T1B0ZnNLdXNvNUYwa0lqd3dwRXFCSjROcmNseisrYzJV?=
 =?utf-8?B?dWR5cEdCOHFmYlBTWUdWdnBNOElKM29mQ2RVZElIbUdvaG0yME9oK2VvcHVp?=
 =?utf-8?B?eGdySDNhKzZzcE1BT3V2ZVdNZTg5eXFzbWM3Y3ByMHMraS94aWZ6T0dSc2Zl?=
 =?utf-8?B?bitCWHVOcFNpWUwzd3FCTDdSWmsvQU56T1R2eGhRUnFELzkyb05YMkpxWnpZ?=
 =?utf-8?B?UDExTk4xMFBzQlA2eDMyNld0MjVxQ0RzbFMwdUJqOFlWcFRUdjdhd0VCQ1BU?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21BC7A37F57C60459E407478532173B2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56ac391d-3669-4474-5664-08db25583c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:21:50.4155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z8aMCEHYeZdFJjDEf+RD1lpw//uuL8lSOVvw1qQF2/KyXJVcbzm0WTxytBO2eVClKJAWdkuKkuuW5roYYPY2RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6657
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBNYXIgMTUsIDIwMjMgYXQgMDI6MDk6MTZQTSArMDEwMCwgQWhtYWQgRmF0b3VtIHdy
b3RlOg0KPiBTb21lIGVycm9yIG1lc3NhZ2VzIGxhY2sgYSBuZXcgbGluZSwgYWRkIHRoZW0uDQo+
IA0KPiBGaXhlczogZDQwZjYwN2MxODFmICgibmV0OiBkc2E6IHJlYWx0ZWs6IHJ0bDgzNjVtYjog
YWRkIFJUTDgzNjdTIHN1cHBvcnQiKQ0KPiBGaXhlczogZDg2NTI5NTZjZjM3ICgibmV0OiBkc2E6
IHJlYWx0ZWstc21pOiBBZGQgUmVhbHRlayBTTUkgZHJpdmVyIikNCj4gU2lnbmVkLW9mZi1ieTog
QWhtYWQgRmF0b3VtIDxhLmZhdG91bUBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQoNClJldmlld2Vk
LWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQoNCj4gIGRyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jICAgIHwgMiArLQ0KPiAgZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvcnRsODM2Ni1jb3JlLmMgfCA0ICsrLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRs
ODM2NW1iLmMNCj4gaW5kZXggZGEzMWQ4YjgzOWFjLi4zM2QyODk1MWY0NjEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+IEBAIC0yMDY4LDcgKzIwNjgsNyBAQCBzdGF0
aWMgaW50IHJ0bDgzNjVtYl9kZXRlY3Qoc3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJpdikNCj4gIA0K
PiAgCWlmICghbWItPmNoaXBfaW5mbykgew0KPiAgCQlkZXZfZXJyKHByaXYtPmRldiwNCj4gLQkJ
CSJ1bnJlY29nbml6ZWQgc3dpdGNoIChpZD0weCUwNHgsIHZlcj0weCUwNHgpIiwgY2hpcF9pZCwN
Cj4gKwkJCSJ1bnJlY29nbml6ZWQgc3dpdGNoIChpZD0weCUwNHgsIHZlcj0weCUwNHgpXG4iLCBj
aGlwX2lkLA0KPiAgCQkJY2hpcF92ZXIpOw0KPiAgCQlyZXR1cm4gLUVOT0RFVjsNCj4gIAl9DQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2LWNvcmUuYyBiL2Ry
aXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjYtY29yZS5jDQo+IGluZGV4IGRjNWY3NWJlMzAx
Ny4uZjM1MzQ4M2IyODFiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9y
dGw4MzY2LWNvcmUuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY2LWNv
cmUuYw0KPiBAQCAtMzI5LDcgKzMyOSw3IEBAIGludCBydGw4MzY2X3ZsYW5fYWRkKHN0cnVjdCBk
c2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICANCj4gIAlyZXQgPSBydGw4MzY2X3NldF92bGFu
KHByaXYsIHZsYW4tPnZpZCwgbWVtYmVyLCB1bnRhZywgMCk7DQo+ICAJaWYgKHJldCkgew0KPiAt
CQlkZXZfZXJyKHByaXYtPmRldiwgImZhaWxlZCB0byBzZXQgdXAgVkxBTiAlMDR4Iiwgdmxhbi0+
dmlkKTsNCj4gKwkJZGV2X2Vycihwcml2LT5kZXYsICJmYWlsZWQgdG8gc2V0IHVwIFZMQU4gJTA0
eFxuIiwgdmxhbi0+dmlkKTsNCj4gIAkJcmV0dXJuIHJldDsNCj4gIAl9DQo+ICANCj4gQEAgLTMz
OCw3ICszMzgsNyBAQCBpbnQgcnRsODM2Nl92bGFuX2FkZChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMs
IGludCBwb3J0LA0KPiAgDQo+ICAJcmV0ID0gcnRsODM2Nl9zZXRfcHZpZChwcml2LCBwb3J0LCB2
bGFuLT52aWQpOw0KPiAgCWlmIChyZXQpIHsNCj4gLQkJZGV2X2Vycihwcml2LT5kZXYsICJmYWls
ZWQgdG8gc2V0IFBWSUQgb24gcG9ydCAlZCB0byBWTEFOICUwNHgiLA0KPiArCQlkZXZfZXJyKHBy
aXYtPmRldiwgImZhaWxlZCB0byBzZXQgUFZJRCBvbiBwb3J0ICVkIHRvIFZMQU4gJTA0eFxuIiwN
Cj4gIAkJCXBvcnQsIHZsYW4tPnZpZCk7DQo+ICAJCXJldHVybiByZXQ7DQo+ICAJfQ0KPiAtLSAN
Cj4gMi4zMC4yDQo+
