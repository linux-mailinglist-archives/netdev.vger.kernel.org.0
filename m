Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4ED4898AE
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245522AbiAJMes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:34:48 -0500
Received: from mail-eopbgr130109.outbound.protection.outlook.com ([40.107.13.109]:17379
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245596AbiAJMdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 07:33:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATJt07QZPsVHjzkwWTRNy/sFOpzwU6ECxX+Jrzh+QdmSyop/PAJ3qEWeLSDVtRb0TpWHqR4uhH2jnQtZqfe3BqOCPhq7fYDe4C6ZOeTxJEqfVwOj4TSwyetk4gd1VvPi/eeGWQqp6lL+6wpbswhr5oDK4LKGpBQR9oJyA5jxpkX8yJ9jZliZSk3iQuR4eZ4vIwsNFx/NrpiUvL0PRGtXzQUyQoECOo8TmPVizjuR2iT2apaINjXz2KfYI/SuxZMp9x7iwIIVG59+vEWhZ7DY1v0b+RqseJrN6RNharEBE2orBG8DQzTbklCrJlfoKDc4jf4+xFH8veSyX4cXCwXMNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7WuxmzhkwMkAcDnYTfMrRxBN/LwAf8SF/g3oYYHVTM=;
 b=Uqe095YmBNC/5F9rAs4X9mjIS6KWrsHY/2uOTsBIynf8LnwgxXyWhCSSCH4FXIYhcc/2UJvkRfDKoAOk4/35QzUwnPcI1YcmBLQ/Y4v1WhOYRzP4op0w5e/Pw5FSnPO2p8he3vqrJ462SmWH/sUgG4FAqZpSXCynI3SPX1oYVobGPcNlSwFxoiM2Ld6g1QEDG/GHlrCuSF7UJdHbPIAnOINfEurZWE6w7Z8hq2RX8wr+qtpxZ9EGyrKCekFfEdJILohQfA3bOIDK2Zl1rbs8m6h5s0NWTGFMYqEE2d+/hVGG6qHB8towyCZcCIi+5RiCOI5z6eGY/+/bWecpQXWP3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7WuxmzhkwMkAcDnYTfMrRxBN/LwAf8SF/g3oYYHVTM=;
 b=nUqOYBF5x/08sWWUnO7CXGcJNh8Id3lwK/92ppF+kOotErVtZHV+7Nc6xNmF09+xGk2i3ygSMDBwlxuOrB56EgGDrMCh2ah5JaRH+8J80LT4yi0gGIAK6EieVoOjNLwflCZuOcV5W1BaECshWn+0hW9iqiNB97DhcJICBeX8iZg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB4918.eurprd03.prod.outlook.com (2603:10a6:20b:8a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 12:33:48 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 12:33:47 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
Thread-Topic: [PATCH net-next v4 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
Thread-Index: AQHYAeKNAJ5J+V2WfkCl0TnST7KHLg==
Date:   Mon, 10 Jan 2022 12:33:47 +0000
Message-ID: <87r19fepn9.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-3-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-3-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 5 Jan 2022 00:15:06 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a36c4664-d843-4ae2-1a99-08d9d435731a
x-ms-traffictypediagnostic: AM6PR03MB4918:EE_
x-microsoft-antispam-prvs: <AM6PR03MB4918565E26D8C1660889361383509@AM6PR03MB4918.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TTRYPseMjaDggkTwweSPC25zgv/pnfjUN00ByTiGaVIICNs1yY0Uanj2tc+te/2H3OHBL4QM3CM++pI1/TL5PSYnYUTZc1qE6BZZ8YvA7STXxDpHKKv0I+3RE0EELapgI7umwH81m80MfElxDr/6drTypDOQPoEvOHoyVSDt6+mFKJVhs/RLIfI/fbsd+Meim+yBecGeaVa/bhNGgzR35NkxrLeOqOL4d8Qgy07IcWSHHlyFpG6GTr8OJRdm+K5WuWe4ZX3k1dbR1h/35EuzdxB7sqaXRwoOo77us8uE0shF2aOM8JM0iqL1OyETwEjcw770KQRP6XuS5Wxy9II0AZT6o4bnPWFe5dDeTKqvEXT23Fb8L4XTEYUt0r+5S/egGzQ/4RO0BnlIlijBVMSycbhYMKqXVAtPIRNE1ReSbW7AQPCuAJFmS+m5OYTcCOcNbEo4986JDOye0oD1jjk1p2aPP7ntoPD1bYOqBflWpcorHrr7CixKxkHLXNbXN0a1X6CUAwaYL94TQxACnF1JpQ8db0i+329rDenrmteaMg59hb4SOaV6/NKsIioHXDcr+unoAHDcNbojHbWFja1B0jLps43+Wn56zuTQSKjXgwgTfi2rpnw8qxLa4bkoF2FJCHfgnmskLzYHADSVU0+47wcK3S9JKoJY3wteCNDpVMYj9Yy11CrjG1OFCky3TRDM6MVYdSBt6Zo24v3M4hBuWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(2616005)(4326008)(76116006)(86362001)(8676002)(5660300002)(6506007)(91956017)(6512007)(66446008)(6916009)(66476007)(66946007)(4744005)(64756008)(85182001)(85202003)(38100700002)(122000001)(66556008)(186003)(83380400001)(2906002)(26005)(36756003)(54906003)(6486002)(316002)(71200400001)(8976002)(508600001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azB3S2FnL0VDVTJDaStMM1F0blZ5ZkVpbTFVcG1DdTViYS92OTNQd082Vit2?=
 =?utf-8?B?SWVEQXlJRDlBWFEzei9rb3hadUN5VHY0cnBHTDhiNVJqcUpRRkJrUEVvdENU?=
 =?utf-8?B?K3BtME5UalpVSElKOUc0bzExWHo0NVIzN0twRXhrZFdudWNSVDd3MjVzcnNa?=
 =?utf-8?B?dU1hbnFYaXp1SmtCNGNHNldOUzlhejlya21SeC9scnE5U2FSQ0QxMVlBbzRv?=
 =?utf-8?B?QnJFSjJKZklqMmxqZExrTW5mRmY3VjFnQWVheWdWRGJqTlFhS3NwTGFzZnBJ?=
 =?utf-8?B?WXVjaElLNnpGdnFGeWZtYlpuR2RPVmJzMEEySWlwVG9WbTB4d1JNK25XSGRL?=
 =?utf-8?B?dlhxMVVyalJCM25GZXg3S2x2QXZETWQ4TDdRYXRRZmVvcUE5VVpnK2JCcm1U?=
 =?utf-8?B?VjBTZEJJcXBxMWtTdVUvYlJ6SFBnT0l4YkxEOFlERFdZRVFUSXVyaGV2enQ1?=
 =?utf-8?B?NkpSVUZHeGUwRXlTZTR3Yzl1QmJOQ1NMK215eGFMRkVJamJpN09hNkVwbGox?=
 =?utf-8?B?ZXpxdGZ6QTBVSEdJTFVDM1NjL0FEaURUWWZBVnNMbUQvcVo5RTRKNjFHZmRj?=
 =?utf-8?B?NTRtQURDL2dHWUVmbnhkN3BvSGVReWJtOTU5cjdPNmU0R012eDBPMVBpWnNL?=
 =?utf-8?B?cVkzS3Rick9pcnl2aEcvV0tyWnk3UGJka1hsVEYxaFB0eCtnNU9xbUJXUWpu?=
 =?utf-8?B?VUpQSEFrck5rZ2NhWWZkOHBkQ2Fhd3AwK0hPdmN5MW9mOTdGU21SS3VIc05w?=
 =?utf-8?B?ZjlpTFRTVFFGQ1ExVzNoVEw1cVppRGhaUTJCWkptZGdIa1BoVUdHamVldDY0?=
 =?utf-8?B?MHE1SEM0UDkwWCt0akFrRVN2MDlrZDV2alBLVzRITEpVWnJZbXlsR1dCbWtn?=
 =?utf-8?B?Y2JUamtVZHBOODRXNHY4TzZIczA3RjdZY0gvY0EwbWtmOHRmNzZ3SWNVNE9i?=
 =?utf-8?B?eEptYU1tOThjWHJPSVZEejhVZzBYZmRvY3hET3o5T1orYmoxd1craC95LzZy?=
 =?utf-8?B?UlhBT0VYMGNXaUVndm1JZW5OZkpxcERVekxxWXl0T2ovMG5qTFZvOG9HL1dm?=
 =?utf-8?B?Q1hpdHo2THdnb3J4NnNpc29LOU53YzVOU2wxWXRITGVRMmZGZDRkMkdKcktY?=
 =?utf-8?B?UGNXSmEvUHF5eFZtcDdVWEw2T1NDR2ZYNnBaWjhOVlRHY3M4QmRJU1p4Z2FN?=
 =?utf-8?B?QjlPdXZZeTd6MndJMitzZUdrbzZHVUI3ZEREVFJaeG45TExma1d0eFp2Z2NG?=
 =?utf-8?B?WjF1NS9JNDMvME1QR252RXI5czJUVVc5NUNjc2dUZm5iN3dpS2lCR1IxR0Mx?=
 =?utf-8?B?WTNROElEUVJmbUIwTU5QV29oZEdPei9XUkFGTWkySnU0dlZTbWkxWVRGT0Za?=
 =?utf-8?B?ZU5NdFBiMmdUdjZKMENHOG02MHhvT3RsUytlaE9hTS9FU0lNVmx5Y1pVS0hy?=
 =?utf-8?B?NnM4eGh3dFZ4cEJ5dXk4c2J5Qyt5dmM2T3o5NDNYa3k5OGNNdzVXNUNJbURT?=
 =?utf-8?B?bW5GeUpYZDdoY2FZMXRvQmRRNUIyR0dSTTBycjdKUGlIYyt6eFlHY2FReFhm?=
 =?utf-8?B?MFJ5QUcwcXA5Rk9LcDcrZ3pnaHo5SWpmK0VnODZxYnJzZkYxQ3ptU01HQU91?=
 =?utf-8?B?WjI5b1pwY1J1L2hpL1JVTVJZM2UxdFMzcks2bXdtVERpTzl3cE5nVW50WjU4?=
 =?utf-8?B?RHBaaWN6aUtHcXl2WHFEYmlneEVSZHhWZW9waWl3a0tPYU05MHAyakhFNHgx?=
 =?utf-8?B?UU5LR2l4djB1RGdtL3l6d21NbkQrZmppdEtxZjlUUHNDdEtSVEhrYVVZU3Zz?=
 =?utf-8?B?Y2k2dno2OUxic0w3VHIvZFhYMStkcUFoeGJGYkNsSFpGNlN4d0QrYXgyc0xO?=
 =?utf-8?B?VWpJcnExQnl2Vk5OYk9DZWExaklZYzFzK3A3djZZeEV2UXEzTyt0Y3ZCOVRz?=
 =?utf-8?B?MFo3a284Q25Kc1hNbFppN2xoRWRKSzZ1ak0vZTd2QXJLSVk4d2NnWlQ1VXFP?=
 =?utf-8?B?UnprZ2FmZm5uUmRlOGVwdGUvcllGY1ZhcWRtNzY3V1NURGUzdm4zeTMvOEE4?=
 =?utf-8?B?a0lVU2JieFJqdlZxWVF5VjEwSjAyNUs0dkEydXNtbjFHeGs1RUc2dTdwbjFU?=
 =?utf-8?B?Vzhmbm9uenVLZzFxTlQzK3ZtQzJBaGFyUGl4cG5sQ3dlNzVlTS9QM3pHTloz?=
 =?utf-8?Q?jU4D7vUJWFxlqgXmbBO4tuM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85361A8253A67D409C1F68756DA7D6BA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a36c4664-d843-4ae2-1a99-08d9d435731a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 12:33:47.8456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g/QYsmBrGisd/GhzXzFqXqut8ktPi/N9G1nv8G5e3f30Bh5hpG6HH4K1B94CHK25OXWvWseZGsSIkC3r2Mf+yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4918
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gSW4gcHJlcGFyYXRpb24gdG8gYWRkaW5nIG90aGVyIGludGVyZmFjZXMsIHRoZSBwcml2YXRl
IGRhdGEgc3RydWN0dXJlDQo+IHdhcyByZW5hbWVkIHRvIHByaXYuIEFsc28sIHJlYWx0ZWtfc21p
X3ZhcmlhbnQgYW5kIHJlYWx0ZWtfc21pX29wcw0KPiB3ZXJlIHJlbmFtZWQgdG8gcmVhbHRla192
YXJpYW50IGFuZCByZWFsdGVrX29wcyBhcyB0aG9zZSBzdHJ1Y3RzIGFyZQ0KPiBub3QgU01JIHNw
ZWNpZmljLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIDxs
dWl6bHVjYUBnbWFpbC5jb20+DQo+IFRlc3RlZC1ieTogQXLEsW7DpyDDnE5BTCA8YXJpbmMudW5h
bEBhcmluYzkuY29tPg0KPiBSZXZpZXdlZC1ieTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxs
aUBnbWFpbC5jb20+DQoNClJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9s
dWZzZW4uZGs+DQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLXNt
aS1jb3JlLmMgICAgfCAzMTYgKysrKysrKy0tLS0tLS0NCj4gIC4uLi9yZWFsdGVrL3tyZWFsdGVr
LXNtaS1jb3JlLmggPT4gcmVhbHRlay5ofSB8ICA2OCArLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9y
ZWFsdGVrL3J0bDgzNjVtYi5jICAgICAgICAgICB8IDM5NCArKysrKysrKy0tLS0tLS0tLQ0KPiAg
ZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2Ni5jICAgICAgICAgICAgIHwgMTY0ICsrKy0t
LS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjZyYi5jICAgICAgICAgICB8IDQw
MiArKysrKysrKystLS0tLS0tLS0NCj4gIDUgZmlsZXMgY2hhbmdlZCwgNjcyIGluc2VydGlvbnMo
KyksIDY3MiBkZWxldGlvbnMoLSkNCj4gIHJlbmFtZSBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay97
cmVhbHRlay1zbWktY29yZS5oID0+IHJlYWx0ZWsuaH0gKDU3JSk=
