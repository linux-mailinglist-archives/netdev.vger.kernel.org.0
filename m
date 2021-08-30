Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFB03FBF68
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhH3X2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:28:01 -0400
Received: from mail-eopbgr70095.outbound.protection.outlook.com ([40.107.7.95]:49830
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232049AbhH3X2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 19:28:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt3f7UCXmvN01aRmhCJw3THCvhtG3YEvtgJT33N5dsMITDaztpIEqkRGQAIVMuuuCMi/QLPywy2GkmS+iMZw4GNalU7LxZ+XGtKipYt5axq736MWyh5/3+XDYNNhy1iL+blbEfCvwLowRDbMJyuLVMZzG5U28v1GcX4Dzgdb4ISorx+Wo1Mkt2u2vxKGyB+K2Ypp5zbM0EH3tSpEY7ZmK9InU9u0IMKyZ9pkz4A10Kk5D6QCwOVn5pauLTT0cSzFK+Vry0JkZtB4Bq0Wo4J3wmIPnGaJPoiYC3mQZwzoTJK8DphUitipPSp5t/dk1CtxBLQ4mdQkzimDnWqYFHycHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEGGj27IRKDSZ6GzkRw/Zk6H90X9Rb6uq6vkRM3m27M=;
 b=TRGeQzOjWTPnRZz6DBb6pvberXFPfChG1UWxkmw/jaGgQPMX2JGMYY/9iK+SkKBAtzZKrqybHhDt0nkZz8aJazvB0vyAcI//EAos1k/iIhYqCulN1tGE5t5Mte8uNPOtaHxvO4MreYbf40ZCiWbsn0dhiN7F9iQ+pz4BODJsG9ixsplX/1XKqVthS61kWhhwx+VWAMUBOYKvmhCw4U1HUWlVvnYux3Lj1py34cgV3QZLKiacsVTVtegWZyZBnDFKo+6DpWAJw7NV3nGXFvlSDRZSfEcK1MYkpEjbQTgiSFtUbbb6yQJ1T1XsxCJ/L9ah5MaEGXJ0oVh9qg1Okh7IwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEGGj27IRKDSZ6GzkRw/Zk6H90X9Rb6uq6vkRM3m27M=;
 b=Jd/wCRZNtKDAZ+SXSE72iJunoCPzraXJeJnfQXhoc0JBgCE0J6ApoKMb/5C3Jkli1zJXmIG1x74lLNHVGBS7RkE7WuekhZLaxfyWTmfDM2Pu7ujkmz5DrIGS0+QyiAgc89De7PKaCZAXUzSMsJfpL2ziYRNAn5AadSsHvzkY3yE=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2252.eurprd03.prod.outlook.com (2603:10a6:3:22::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Mon, 30 Aug 2021 23:27:04 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 23:27:04 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 2/5 v2] net: dsa: rtl8366: Drop custom VLAN
 set-up
Thread-Topic: [PATCH net-next 2/5 v2] net: dsa: rtl8366: Drop custom VLAN
 set-up
Thread-Index: AQHXneljLO9TDOQeCEim/7L84rf636uMsUCA
Date:   Mon, 30 Aug 2021 23:27:04 +0000
Message-ID: <f2fe444a-421b-65de-e12d-6629ff86ffb3@bang-olufsen.dk>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-3-linus.walleij@linaro.org>
In-Reply-To: <20210830214859.403100-3-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2afc546-d4d2-4d3c-e5cb-08d96c0dad42
x-ms-traffictypediagnostic: HE1PR0301MB2252:
x-microsoft-antispam-prvs: <HE1PR0301MB2252A7C4440BB82EA43E5D7283CB9@HE1PR0301MB2252.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9uNsJXa8W4Rg8T/FCZfB4ZFjzRwwN+PQZSK2G1FqCR2OldcfiTO3Tn3TPqkDIg1EnHPw5TyWt5IEALAy3G++IKm0P/IBKqytlV9h5P4HyQ/uHI+Tc/eyMuqwEmb4MUgFZebXY7V9HeY4K/03qc86QFF4mUxoaCPHICkPzYSsb+zdwSWIXLYOOU2kkD5wn06M+wS6zjeyF1Py0BhRs+CHW5AwYNWqHC8t1+bEU+mJat+qQWgxiyqoUUTyE98Je7BiZXy42LwBPbUVt4QiEfnnWL4jQdd0e8jvjH+cnymGrNB+dntwbEU7nnRNzjcqmL6b0wTASXI+u4GfTxHwrtDE48sqe6F4XJQlJgk7NCk4begDpR+9K6OjSiw9JZZiGgrm9uG0+LbD7j+Hns1+8di5AoLDyOIcKxRjPLy1fAa210azvM0r34pIN+LCsyEZYX0Q2CDvylbO0j3LpRYXQ7Y0zy/yJlWpQDC/fuRdkQG6RHxfwi+ZoBgf5PB7EB05br7SC/A+ZlxQkZTZZAPC3tjMkuu9QmlxwgAFYUzefyFMwOTgmPF+6ycSBqh3GEPO/nraNYm4fkNn+YkxD9IDbfRy4V6+BBt7iCf/3x46rn1L3NTS+g+wheOqQd5G9EQpr/QG9w9X7Z9j/8PwngCNXlt3Sd1p/wVgdYcuPOkWlQbUq+eruxC4jF6NEpQXybwfyi7l+PatB8i4+TCCUEVGb25+SbC304xnDaCuHKZaKtUSslDeujlHC+dRXAoM/Ys81CHYdNDjjvIgsRyKODiEpbCyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(478600001)(36756003)(71200400001)(54906003)(8976002)(66574015)(85182001)(122000001)(6512007)(8676002)(91956017)(86362001)(110136005)(6486002)(38100700002)(38070700005)(4326008)(26005)(31686004)(2906002)(2616005)(53546011)(66446008)(64756008)(66946007)(85202003)(83380400001)(66556008)(186003)(31696002)(316002)(6506007)(8936002)(5660300002)(76116006)(7416002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDk1dlBnQ2JDclc2TWQvc3ArSXNoU3FVMVZSSjZjaFcwNG1YRmFqbDcyU2Jj?=
 =?utf-8?B?Z3prMG03Wk5ITDE4dlpFK0tVUVFiTnM0SUwzK24vcm1JUTJLWkZmeW14bWMv?=
 =?utf-8?B?UThaM3FxWFE5VngyTERBM1VKSVhHdHZXL3QybUJtTmdmVjAwUklCb0JxMkVm?=
 =?utf-8?B?NFZLU25YaEx5UjB3VkxtVkVNelNDT1ZlS3FhWVJucmx2aFVCc0dYS0dhTnJG?=
 =?utf-8?B?TzM0Y0pUK0k4ZjZwQkE2YllwSTMvZUpOU09jMHY0aXgvSEUxbzZmcXYrZVhu?=
 =?utf-8?B?b0VjMzdka2E2NEF2UklTTXA5VVE3Und6WEdPYk14V0IrUzYrQklUS0ZTRkt1?=
 =?utf-8?B?M2M5VzJNRXByZEt2dVBLOUw1dU1BNnU1emd5dXp1Y3NhdjdsVE1EUkNVVmVn?=
 =?utf-8?B?UDFFcnJhQWh3YVFCekoxeWNhMXJkd21uY0Y4R2NuVmN4TUsyY2R0VVFxbDFu?=
 =?utf-8?B?YUZ5cGY3SDVUVWp6MWtBVGF2WW1SUG9Sa2hVVHllZ3VPU2FYWU9HOTZTOFRX?=
 =?utf-8?B?eGEyNVpWc2JHNGFaRkRLZGtKSEsxNVNQMFlnV3lMa2hqenlOOUN0bXpRbXVj?=
 =?utf-8?B?cVpGK0RpMVpWamk4N3phclRnWmRFRVh4cnFucnR3dmsrRmVBUmprcHVXR1R1?=
 =?utf-8?B?dEd0WHZLbzNoV01UVW8yYUZwdkJWOVdEOHdhSXZYbFZYaTBYdlZwY3NmVDB2?=
 =?utf-8?B?a2k3U2JULzZNdVVQVTU3WTNmYmhIYkwzZGVuTEp2d0sxb1FsdWN1Y3EzZGJu?=
 =?utf-8?B?VldwRWhCRHlCVDNNbnorbklsMk9VNGptNVZncC80N0dmK1FXQnJDd1BFUFNh?=
 =?utf-8?B?R3VYNDFwWGhWb1ROOXBkQ3ZPSDF1TzZuVUk3U1lRaHF6Q3p1NjVZVUxXT3NC?=
 =?utf-8?B?YUF1UTBlVHAzWXpSbjY2MTdFUFdMM0oyZXVDc28vaWYyeHdob1R3Rnp0d09a?=
 =?utf-8?B?bWJQdUxSdGdnbjRSdXZQMzMvSlRKa01USzRwRlNxd0NtS2c0QS9ON2xTczB5?=
 =?utf-8?B?QUMyaWxXWXR0Zi9aQnNQSVVSSmFBOGw4bVdOL25pWHpHR2dPd1hwZXFmZUVL?=
 =?utf-8?B?RUJ3TmhoUzQwZ1ZsTDJaTjNwbWt6SUNpRkJUaWNTMDVhUkd3N240WlN4NnFv?=
 =?utf-8?B?OTB3WVVtYlZFWllkV3pCSnFWbEV2V2M4QWNDWjVtUm9XM1N4Zi9PRUc1Tm1p?=
 =?utf-8?B?TlorZ0FqSVJrcGo2clczdkJoN2hMMnc3OXNVM2tnL1VFYUlBVTJaZ3c5OEVE?=
 =?utf-8?B?Nm9DN1A0Y0ljdjdKWk1nZThuNHladCtuSG5tOWVSYkhCSHpSd3ZlM21zUjA4?=
 =?utf-8?B?bGMwbysyZnM3ZUkxTTNpNlNBK1JXOUZnd3U5Ym14SUhFalJWZ0twM0Y1R3lx?=
 =?utf-8?B?eVFhUzA4MU94Y1VlSzlNYnI3ZkF0RXJ4dCtiYjhSM01SeDk0SVI5dXcrSjc2?=
 =?utf-8?B?OFlSV1RidndsUzVGV1Q3SXFweXJGaGxqcWJoZVh1RHNSWk9mcVJsMjRuQ1Fi?=
 =?utf-8?B?WnRBRzRtSDk0OENnWHdLK3Y1RHR0TDE5Ky9WbkY5NldhQi9Hd016TVI5TFIx?=
 =?utf-8?B?L2pLTWRZbnhsejE4ekxrU3NGSitSKy81cGptME5oUDRURG43cEFMcmh0YW9k?=
 =?utf-8?B?cHYyeGtuNG5MZnVJZmU5emYwbVhENTBTdXJvSWY3QzY3eDVkS0J0dDFXRHBl?=
 =?utf-8?B?Z0gyc0xCeHZpMnNObG9mOFJyK0YxY2R2SHVGOGxPQTBmcE1DNWhWTmx0NkQz?=
 =?utf-8?Q?fSAqDRAK2Ez/RaRPyWwIC/KmixDyTAiPwwrirlV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <488502A2416317459F26E7BFA78543F9@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2afc546-d4d2-4d3c-e5cb-08d96c0dad42
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 23:27:04.4754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GioRWROtuaGasCQQm6IKTdtWXwdPaviswB0eJ52fDA6ombPeRTi0ajmPHZCO7pLAkcEITpXXZLyUrYO/TgrqKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8zMC8yMSAxMTo0OCBQTSwgTGludXMgV2FsbGVpaiB3cm90ZToNCj4gVGhpcyBoYWNreSBk
ZWZhdWx0IFZMQU4gc2V0dXAgd2FzIGRvbmUgaW4gb3JkZXIgdG8gZGlyZWN0DQo+IHBhY2tldHMg
dG8gdGhlIHJpZ2h0IHBvcnRzIGFuZCBwcm92aWRlIHBvcnQgaXNvbGF0aW9uLCBib3RoDQo+IHdo
aWNoIHdlIG5vdyBzdXBwb3J0IHByb3Blcmx5IHVzaW5nIGN1c3RvbSB0YWdzIGFuZCBwcm9wZXIN
Cj4gYnJpZGdlIHBvcnQgaXNvbGF0aW9uLg0KPiANCj4gV2UgY2FuIGRyb3AgdGhlIGN1c3RvbSBW
TEFOIGNvZGUgYW5kIGxlYXZlIGFsbCBWTEFOIGhhbmRsaW5nDQo+IGFsb25lLCBhcyB1c2VycyBl
eHBlY3QgdGhpbmdzIHRvIGJlLiBXZSBjYW4gYWxzbyBkcm9wDQo+IGRzLT5jb25maWd1cmVfdmxh
bl93aGlsZV9ub3RfZmlsdGVyaW5nID0gZmFsc2U7IGFuZCBsZXQNCj4gdGhlIGNvcmUgZGVhbCB3
aXRoIGFueSBWTEFOcyBpdCB3YW50cy4NCj4gDQo+IENjOiBWbGFkaW1pciBPbHRlYW4gPG9sdGVh
bnZAZ21haWwuY29tPg0KPiBDYzogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRr
Pg0KPiBDYzogTWF1cmkgU2FuZGJlcmcgPHNhbmRiZXJnQG1haWxmZW5jZS5jb20+DQo+IENjOiBE
RU5HIFFpbmdmYW5nIDxkcWZleHRAZ21haWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMaW51cyBX
YWxsZWlqIDxsaW51cy53YWxsZWlqQGxpbmFyby5vcmc+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTog
QWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KDQo+IENoYW5nZUxvZyB2MS0+
djI6DQo+IC0gTm8gY2hhbmdlcy4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWst
c21pLWNvcmUuaCB8ICAxIC0NCj4gICBkcml2ZXJzL25ldC9kc2EvcnRsODM2Ni5jICAgICAgICAg
IHwgNDggLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNh
L3J0bDgzNjZyYi5jICAgICAgICB8ICA0ICstLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDUyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9yZWFsdGVrLXNtaS1jb3JlLmggYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay1zbWktY29y
ZS5oDQo+IGluZGV4IGZjZjQ2NWY3ZjkyMi4uYzhmYmQ3YjlmZDBiIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9kc2EvcmVhbHRlay1zbWktY29yZS5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2Rz
YS9yZWFsdGVrLXNtaS1jb3JlLmgNCj4gQEAgLTEyOSw3ICsxMjksNiBAQCBpbnQgcnRsODM2Nl9z
ZXRfcHZpZChzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSwgdW5zaWduZWQgaW50IHBvcnQsDQo+ICAg
aW50IHJ0bDgzNjZfZW5hYmxlX3ZsYW40ayhzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSwgYm9vbCBl
bmFibGUpOw0KPiAgIGludCBydGw4MzY2X2VuYWJsZV92bGFuKHN0cnVjdCByZWFsdGVrX3NtaSAq
c21pLCBib29sIGVuYWJsZSk7DQo+ICAgaW50IHJ0bDgzNjZfcmVzZXRfdmxhbihzdHJ1Y3QgcmVh
bHRla19zbWkgKnNtaSk7DQo+IC1pbnQgcnRsODM2Nl9pbml0X3ZsYW4oc3RydWN0IHJlYWx0ZWtf
c21pICpzbWkpOw0KPiAgIGludCBydGw4MzY2X3ZsYW5fZmlsdGVyaW5nKHN0cnVjdCBkc2Ffc3dp
dGNoICpkcywgaW50IHBvcnQsIGJvb2wgdmxhbl9maWx0ZXJpbmcsDQo+ICAgCQkJICAgc3RydWN0
IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKTsNCj4gICBpbnQgcnRsODM2Nl92bGFuX2FkZChzdHJ1
Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZHNhL3J0bDgzNjYuYyBiL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2LmMNCj4gaW5kZXggNzU4OTdh
MzY5MDk2Li41OWM1YmM0ZjdiNzEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9ydGw4
MzY2LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjYuYw0KPiBAQCAtMjkyLDU0ICsy
OTIsNiBAQCBpbnQgcnRsODM2Nl9yZXNldF92bGFuKHN0cnVjdCByZWFsdGVrX3NtaSAqc21pKQ0K
PiAgIH0NCj4gICBFWFBPUlRfU1lNQk9MX0dQTChydGw4MzY2X3Jlc2V0X3ZsYW4pOw0KPiAgIA0K
PiAtaW50IHJ0bDgzNjZfaW5pdF92bGFuKHN0cnVjdCByZWFsdGVrX3NtaSAqc21pKQ0KPiAtew0K
PiAtCWludCBwb3J0Ow0KPiAtCWludCByZXQ7DQo+IC0NCj4gLQlyZXQgPSBydGw4MzY2X3Jlc2V0
X3ZsYW4oc21pKTsNCj4gLQlpZiAocmV0KQ0KPiAtCQlyZXR1cm4gcmV0Ow0KPiAtDQo+IC0JLyog
TG9vcCBvdmVyIHRoZSBhdmFpbGFibGUgcG9ydHMsIGZvciBlYWNoIHBvcnQsIGFzc29jaWF0ZQ0K
PiAtCSAqIGl0IHdpdGggdGhlIFZMQU4gKHBvcnQrMSkNCj4gLQkgKi8NCj4gLQlmb3IgKHBvcnQg
PSAwOyBwb3J0IDwgc21pLT5udW1fcG9ydHM7IHBvcnQrKykgew0KPiAtCQl1MzIgbWFzazsNCj4g
LQ0KPiAtCQlpZiAocG9ydCA9PSBzbWktPmNwdV9wb3J0KQ0KPiAtCQkJLyogRm9yIHRoZSBDUFUg
cG9ydCwgbWFrZSBhbGwgcG9ydHMgbWVtYmVycyBvZiB0aGlzDQo+IC0JCQkgKiBWTEFOLg0KPiAt
CQkJICovDQo+IC0JCQltYXNrID0gR0VOTUFTSygoaW50KXNtaS0+bnVtX3BvcnRzIC0gMSwgMCk7
DQo+IC0JCWVsc2UNCj4gLQkJCS8qIEZvciBhbGwgb3RoZXIgcG9ydHMsIGVuYWJsZSBpdHNlbGYg
cGx1cyB0aGUNCj4gLQkJCSAqIENQVSBwb3J0Lg0KPiAtCQkJICovDQo+IC0JCQltYXNrID0gQklU
KHBvcnQpIHwgQklUKHNtaS0+Y3B1X3BvcnQpOw0KPiAtDQo+IC0JCS8qIEZvciBlYWNoIHBvcnQs
IHNldCB0aGUgcG9ydCBhcyBtZW1iZXIgb2YgVkxBTiAocG9ydCsxKQ0KPiAtCQkgKiBhbmQgdW50
YWdnZWQsIGV4Y2VwdCBmb3IgdGhlIENQVSBwb3J0OiB0aGUgQ1BVIHBvcnQgKDUpIGlzDQo+IC0J
CSAqIG1lbWJlciBvZiBWTEFOIDYgYW5kIHNvIGFyZSBBTEwgdGhlIG90aGVyIHBvcnRzIGFzIHdl
bGwuDQo+IC0JCSAqIFVzZSBmaWx0ZXIgMCAobm8gZmlsdGVyKS4NCj4gLQkJICovDQo+IC0JCWRl
dl9pbmZvKHNtaS0+ZGV2LCAiVkxBTiVkIHBvcnQgbWFzayBmb3IgcG9ydCAlZCwgJTA4eFxuIiwN
Cj4gLQkJCSAocG9ydCArIDEpLCBwb3J0LCBtYXNrKTsNCj4gLQkJcmV0ID0gcnRsODM2Nl9zZXRf
dmxhbihzbWksIChwb3J0ICsgMSksIG1hc2ssIG1hc2ssIDApOw0KPiAtCQlpZiAocmV0KQ0KPiAt
CQkJcmV0dXJuIHJldDsNCj4gLQ0KPiAtCQlkZXZfaW5mbyhzbWktPmRldiwgIlZMQU4lZCBwb3J0
ICVkLCBQVklEIHNldCB0byAlZFxuIiwNCj4gLQkJCSAocG9ydCArIDEpLCBwb3J0LCAocG9ydCAr
IDEpKTsNCj4gLQkJcmV0ID0gcnRsODM2Nl9zZXRfcHZpZChzbWksIHBvcnQsIChwb3J0ICsgMSkp
Ow0KPiAtCQlpZiAocmV0KQ0KPiAtCQkJcmV0dXJuIHJldDsNCj4gLQl9DQo+IC0NCj4gLQlyZXR1
cm4gcnRsODM2Nl9lbmFibGVfdmxhbihzbWksIHRydWUpOw0KPiAtfQ0KPiAtRVhQT1JUX1NZTUJP
TF9HUEwocnRsODM2Nl9pbml0X3ZsYW4pOw0KPiAtDQo+ICAgaW50IHJ0bDgzNjZfdmxhbl9maWx0
ZXJpbmcoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwgYm9vbCB2bGFuX2ZpbHRlcmlu
ZywNCj4gICAJCQkgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+ICAgew0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jIGIvZHJpdmVycy9uZXQvZHNh
L3J0bDgzNjZyYi5jDQo+IGluZGV4IDUwZWU3Y2Q2MjQ4NC4uOGIwNDA0NDBkMmQ0IDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcnRsODM2NnJiLmMNCj4gKysrIGIvZHJpdmVycy9uZXQv
ZHNhL3J0bDgzNjZyYi5jDQo+IEBAIC05ODYsNyArOTg2LDcgQEAgc3RhdGljIGludCBydGw4MzY2
cmJfc2V0dXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRzKQ0KPiAgIAkJCXJldHVybiByZXQ7DQo+ICAg
CX0NCj4gICANCj4gLQlyZXQgPSBydGw4MzY2X2luaXRfdmxhbihzbWkpOw0KPiArCXJldCA9IHJ0
bDgzNjZfcmVzZXRfdmxhbihzbWkpOw0KPiAgIAlpZiAocmV0KQ0KPiAgIAkJcmV0dXJuIHJldDsN
Cj4gICANCj4gQEAgLTEwMDAsOCArMTAwMCw2IEBAIHN0YXRpYyBpbnQgcnRsODM2NnJiX3NldHVw
KHN0cnVjdCBkc2Ffc3dpdGNoICpkcykNCj4gICAJCXJldHVybiAtRU5PREVWOw0KPiAgIAl9DQo+
ICAgDQo+IC0JZHMtPmNvbmZpZ3VyZV92bGFuX3doaWxlX25vdF9maWx0ZXJpbmcgPSBmYWxzZTsN
Cj4gLQ0KPiAgIAlyZXR1cm4gMDsNCj4gICB9DQo+ICAgDQo+IA0K
