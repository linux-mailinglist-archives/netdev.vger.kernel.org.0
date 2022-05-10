Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8026852214E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347470AbiEJQhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347459AbiEJQhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:37:05 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70122.outbound.protection.outlook.com [40.107.7.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106FC2A3775
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:33:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/rfnQXnZCdxXAMRXBIDTd6Q+t0ed/EFNF/iWPzkyGv5jCFxDkmwYnlnhOKCap6NNGNUNnOQ+kcwUboEv7nH5CJ9fxRuALVY5yT5K/GA35zszRO0ymKUlIDPGDYtX+Sjfaf/7PkLnsn0jiEqoD5Zzw7U7lLLWYL89i78lJknij8YyIcfwYkulzFr98pmD75bqQsDkt1r1GIZ2NTnNEv7lO6MTED2dvvrVdIsCQcdWfizvOpqwYXRX+fzeD/fApv/3FjsEbu/j9ztK8Zm/9wVgQduT/yUT2Vt3CBCk6ZuEXjXKMwB9Y2McPcc3BniAMsFB/JURkVtqgtfiTsOMqL2oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zr9951OAKY95msDGe244t9kR2+8WP7+d1D55sO2y/c=;
 b=hSXnHQRzgNyqawxn78gsJg0YHPQm2wG7EgKkYG1O1Yj6mE7aKN20S/F2W7usvvgaviSyM/l0lGi+rmbeGzQ46JFHQ1ccO5LglriUiYOmxGq/QLHlbGyyD+BNkKpl6+R5hODzesrywaPonDBszE9/OJYpY7yvMAsdNiB0HecG0JuCP3O6hzz7yirNAnhF5dHOFtzeNaOeJDsz5WDPSyM/7IrMBKXNHajjIVT4iZ8qlB1fWXs1ibnyYQYlGIADmkUu4d4Yd4jjtfzNNUR8Qyc71MKuN5O+rLMaykSKD/2rNBJoMhZEEGl5R5WacqmZQqUV5yyOEB2N42dAYgkmegEGqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zr9951OAKY95msDGe244t9kR2+8WP7+d1D55sO2y/c=;
 b=nFzaDWZWhij8fXI0xwWsAEd8wVrWMED7QZPutZaCeD/jBOOhSxuvLBAO0DEGHuX6i5TzxwOlf0zd9YzJIouAHLBRMZBXCObYf7Z3/iUezOdH8i2pakT72o4O9oYxuRFvwNrsnPffTlVIEGUKJzSCJVUDOxCEINfTkyzlOTXy0y0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PR3PR03MB6426.eurprd03.prod.outlook.com (2603:10a6:102:7a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 16:33:01 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:33:01 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/4] net: dsa: realtek: rtl8365mb: Fix interface type mask
Thread-Topic: [PATCH 1/4] net: dsa: realtek: rtl8365mb: Fix interface type
 mask
Thread-Index: AQHYYy3lMMC4pxDV/Eulg+XZl+9Mca0YUN6A
Date:   Tue, 10 May 2022 16:33:01 +0000
Message-ID: <20220510163301.g67htnnpx3qeiri7@bang-olufsen.dk>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-2-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-2-hauke@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2cde36a-0ce7-4d71-ce71-08da32a2c011
x-ms-traffictypediagnostic: PR3PR03MB6426:EE_
x-microsoft-antispam-prvs: <PR3PR03MB642648EFA66E13E240FCFC3C83C99@PR3PR03MB6426.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q34Og563sNWOpwgtfzDpSKa8OZmd3l6X6ijHVtD+KmeKt+RQJKBOXqJ/fkGn83jeRH4RbcXSX60+VV364Vf05dFet5yW8ZUjXn3LiSzNgiLfUrjqcasT0fmSVe18ra6b9N0SGRqtlWJAHFZ4RCq9DFwmInX8jvfHUreOro1riQ11e1yOtwQZxj9vN5xCIPeAVMVsicucZQEXpyCHkvWmj6T5uNxblaDqno2laugogHywAfKTaGn43+BqXHNGeYAGwKoBkvVvqCVTPVjlQxQ4AWzufwAkvde9PowfgqZs6ww+kI2msG4t1q3RieTrI7+/Djzz8RSafQb/baReUqX03qi5leuPXXaMV5GM4ZF5Ey7RWDj8rSA+qbyOsA1a71xcoqx6DN7MFWqYxfC92TEIPlAflcV5hZrhA31lwARqpiO56ytClygDpWDH+1ol0QTUSB7aYUd7cftG+TNPS/LaERY7S/gsem5XNmNQZe1kUeLm/KjUBKVig7iz4U4x5WENFG8ETNy+E1kPn303tj/FULv7b+3xsXxpkPzRsM6ng5VeQBvucqIR4qnzT/fWkz0DRjWIDcLRDOyOuHZNQXEXoctxj1DqLqrEp1tlVwSFTbIGXIDk4xVfpxmhVZmw40OGSmSwRgNA9I6EM6vDwe6okEJFu5qikRGyPRY7NVH/K6A6OzR7Fs0hZU4KaIN4efB+IZJhGlcRo52RWVpBT7dS4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(5660300002)(8936002)(1076003)(71200400001)(8976002)(54906003)(66556008)(66946007)(26005)(91956017)(6916009)(6512007)(2616005)(66476007)(86362001)(316002)(186003)(66446008)(64756008)(4326008)(8676002)(83380400001)(4744005)(6506007)(85182001)(36756003)(85202003)(6486002)(38100700002)(2906002)(38070700005)(66574015)(508600001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWpxRjNMRkJPSHM5RkpUOTRTOFdyb3BHOVdHbFM5ajUzM3k0TnB6aWtWN3BE?=
 =?utf-8?B?bzM0bzhianplYnlaZjhDNVN1S2hEN3o3bm0zTGluZlA3dThsSThFeDB2ZEFM?=
 =?utf-8?B?cThLbFdROUxXeGhxVk9QRURwQS8zTytUNks5Znc3MEhvNUxCOXk4Rlk3VXdn?=
 =?utf-8?B?NnROOG9PZ3MyWHVNbjFqMjMzZzY2RVg0M3ZZUXdTU3Q1Zy9mVnRGb3IrL1Ax?=
 =?utf-8?B?ZmhqeGdodHJ0T0laNGluYzV4VjFWSCtnVXNjc3ZJSGZ3bjJHVDdNRHh5emVW?=
 =?utf-8?B?TEVMTzFGVWM3WFFCRURsbVZpMmJ5UGcyZnZrbm5HMXR3MzZSc053dVB0VTcv?=
 =?utf-8?B?RE12dTgwZ0Q3UmdUaFZaZTMvUk1sUFUrdy9WTTd0YmRpbXJBZTBSczNycE9N?=
 =?utf-8?B?QU9nN3VoL24yVGRnZ3F6aDJsN0ovMFkzbnovaGRPWDJuVWJJS016QlJadDcz?=
 =?utf-8?B?aEpkWFo2U1hJL1REOVJIZ1J5eGxPWXlPQkkrRkczZkJ0UmZaNFJMV29nWHcv?=
 =?utf-8?B?WW9LdTB0alJ2ajRpaW9OWmVlN1BxeWxiN1Qxek9yY0ZzcTNDMXU5UWRDbUl3?=
 =?utf-8?B?UkZVaHlNSlFjdFVtallzWWRPMUdsMGd6bWZlZ3A4ak5NcnRoakRlZVJGR3Jq?=
 =?utf-8?B?VVdFQ3hjY0FLN01kdnJSUXYwTU5FSG5jdkhiNUx6TGhQNFhkeWZTaVEyN0R5?=
 =?utf-8?B?T3FBeGpvWFAybklObjZjcW1xTVdya2QzamwrK3ZrdDloQ0dxeDJJRTdiMlFp?=
 =?utf-8?B?NlRBbkJjTloyVXE4S3VVcDhkSERNQk45cnNUUWFma2ROaTRDbC9jVGVtT0k5?=
 =?utf-8?B?MDRsc2luMGZkNGpQZFpETWowZ1N2WTZNUXFHZ2tLcjJ3a2FnUVo3VzFzZDll?=
 =?utf-8?B?VWRac25ldVhtUTlMYXdtV0NKeklZV3RNdTFyTnNBSXRrOFdDV01GdUFZYkFa?=
 =?utf-8?B?ODViMk5wZVppWTV0R3FvdzVRSG1DU3JUZGRPV2xRaVJWbGIyOTFlTnNxTDJS?=
 =?utf-8?B?eElCN3M0RzZISnNrNStZU3BqcFI1Q0RUdUxPUjJ1ajJHM1c3MGpwWUJ1enJ2?=
 =?utf-8?B?aFlPb2tkUXRoaGV0dmdVQ3RjQ29UaDgrTUs0cmlTODJNRi9wSnFmb3cvVzgw?=
 =?utf-8?B?N3dxbVgyK0M1bUx3MUI5MTEzUlV3MFRFTHc0cmxNbUgyUzhUbk1EMGdaRzFr?=
 =?utf-8?B?TUlFVy96SEIyNzB3TTQrM1Z6dldGd0VzUlVjWktmV3ljeDFSRHJmNW1ZNytK?=
 =?utf-8?B?YWZ1dnBOcStwR1RlT2tNRkNEaXVoSjlTdEVjUXUxa1BDRm01bEJkNk1sYXRX?=
 =?utf-8?B?bERHdXRMZ2FRdDVZOThrSEcvSllFNHN3Z05jbjZhMjNLSjVocUNkUnQyd1dT?=
 =?utf-8?B?MmVITkVhQll1MUp2VEl2Z2JadXMxUVQ4UnV0VTJmMDFXMXEyeTJVZkRPakMr?=
 =?utf-8?B?OFdCZkU0QmdGUlFNQ1NnZFh3ZG43Ykh0UDJUclE2SEkyNEJNRzhuYk1ZalZO?=
 =?utf-8?B?aVRkYStNZXpReThEVk1YSDFiRDk0d0xsUkkwVHd0SXFhM3pOcGdaV1pXY3VQ?=
 =?utf-8?B?ZVl0ZTNhUndsSTF6Y0FvRS85ditqT2VZQkJZR3JyY3VUaTJReXZ0eVJKcFRm?=
 =?utf-8?B?K3V4Z3ZJL1NzNHl0TGRuV1NOS0E3WTlyNUZ5bDQ5Ty9ydXlmVjN5WlgwaTcw?=
 =?utf-8?B?cFdOb09PcndHeFN4UXBKaENHQk1jRnJpM1FoeTEzRWNOSDAyNlJSejdnV0Ry?=
 =?utf-8?B?VkF3LzkxRCtiYTlRZHFkK2hNeVI3cnRyaGRYRzY4SVRZL0R3N0xWWEFYU3Jj?=
 =?utf-8?B?SW9tYm1ndkZoNS9wWnpyeDg4dWdBcU94UEZrNFZJNE1FSWlaNkVxNlhDdFFh?=
 =?utf-8?B?ajZtZDZzYWFrOGplVDNTdFkraXdyV1FCMmpDeUhUYkJjaUpNZDFmbzR5bnVM?=
 =?utf-8?B?U3hQMnJOS3ZIMnBEcytvbDVNUHJUeTNaSEFKVnNzVVh5Wkw4OS9BMFVhNVJl?=
 =?utf-8?B?N3htNEhKL0JsZHFWWm00MVNvaFlhUEtaaVI3YmtGUGFoTzh4UGhDNDRLaGR0?=
 =?utf-8?B?ck1TNEdaR3pVQ1dyM0VBVFh2WXlKYVp3aWYvZ3dXMkxJR2F1emhHcXZ1WEdZ?=
 =?utf-8?B?bVdZOGJzU01STHFRMnVRVXI4UCttSlpqQmJhRzlZSm91NVVUMGJWcnhEZytP?=
 =?utf-8?B?MitubU1vcEZyQTZOalpiRDFabmV0RngrTjQ1djJjR2xGOGVJRGN3VnVFVk9P?=
 =?utf-8?B?YWpKeUNsSXozZERRQXczUURTRjlDaHhmd3Y2NWVPQTdNVVdWb2FWRUlnRUFp?=
 =?utf-8?B?V0t1U3BZTGNIL1B1UG4zNjdVSmJ0OUVwaXBpSWU5YUMralJEd28wdUIwS3FQ?=
 =?utf-8?Q?THjH3eQovPL1UkiM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80AA908C67548247B455A57912243CC4@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2cde36a-0ce7-4d71-ce71-08da32a2c011
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 16:33:01.4204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zkh3eKqL1qukdUC493aDza1mZBJP4buntrs14+kEHFNfxFJACk6boOlQbHJ9vkXicW2ib6XGG2d3f73icBEp/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6426
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXkgMDksIDIwMjIgYXQgMTI6NDg6NDVBTSArMDIwMCwgSGF1a2UgTWVocnRlbnMg
d3JvdGU6DQo+IFRoZSBtYXNrIHNob3VsZCBiZSBzaGlmdGVkIGxpa2UgdGhlIG9mZnNldC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEhhdWtlIE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMiArLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNClJldmlld2VkLWJ5
OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQoNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYyBiL2RyaXZlcnMvbmV0L2Rz
YS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+IGluZGV4IDNkNzBlOGE3N2VjZi4uMmNiNzIyYTllMDk2
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBAQCAtMjM3LDcgKzIz
Nyw3IEBAIHN0YXRpYyBjb25zdCBpbnQgcnRsODM2NW1iX2V4dGludF9wb3J0X21hcFtdICA9IHsg
LTEsIC0xLCAtMSwgLTEsIC0xLCAtMSwgMSwgMiwNCj4gIAkJIChfZXh0aW50KSA9PSAyID8gUlRM
ODM2NU1CX0RJR0lUQUxfSU5URVJGQUNFX1NFTEVDVF9SRUcxIDogXA0KPiAgCQkgMHgwKQ0KPiAg
I2RlZmluZSAgIFJUTDgzNjVNQl9ESUdJVEFMX0lOVEVSRkFDRV9TRUxFQ1RfTU9ERV9NQVNLKF9l
eHRpbnQpIFwNCj4gLQkJKDB4RiA8PCAoKChfZXh0aW50KSAlIDIpKSkNCj4gKwkJKDB4RiA8PCAo
KChfZXh0aW50KSAlIDIpICogNCkpDQo+ICAjZGVmaW5lICAgUlRMODM2NU1CX0RJR0lUQUxfSU5U
RVJGQUNFX1NFTEVDVF9NT0RFX09GRlNFVChfZXh0aW50KSBcDQo+ICAJCSgoKF9leHRpbnQpICUg
MikgKiA0KQ0KPiAgDQo+IC0tIA0KPiAyLjMwLjINCj4=
