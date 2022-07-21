Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2134D57C2F8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiGUDtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiGUDtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:49:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10olkn2064.outbound.protection.outlook.com [40.92.41.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF9D45996;
        Wed, 20 Jul 2022 20:49:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROpqzs57gukvW6D+VFL8KfWm7Ki3z9+rOp8fm6CQTRdkYmMgfsVmMTpblX8CEd0w57BqFQdLvsH9CEo9iDxiNSnx1Sln5n8ptQajLIlDha6GtQ3H5XHkP2na7131izaYFFbMMT7m2+VNTW2xXlAZ3YPth0wzdrkQjhTxM412+OIONkujYHkfgAhIaw2JlMpOVKbFXIJxsQopZApC6e3Ght4g0ZBATjHKXsb40jgFd+8bf8XS3PC/28HoE6TF1NWp9p6J7kJvwfZyQ7KbquAKN6X2rFmpLDuE7UcB6yHcOia19J360n9Q4uxtCxPMTWFnLOAMzjCxinOblH/PA3lTEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsQIkv2oIecJWHy10QXiI6upvnV1dGLBOmX3cBB3W1E=;
 b=b+e5VP5NKiBsWXxZcAE1jgrcE8wgCC8f+praUfGzTmeTDH7VU9bek4Lh23aiik7i6P0OMpOg7m9/M3zbW1CwWVgrICALMr3Dzo6j849j/IqzLJSAmkaO+tFnbV1H59tFQiuJSONYkfGc2inI3Mao/nHegLR5ODc7lPy6ZEpk8sotPOXxMjndGCvdu1qCVNcqTyyWHkxbm6SqyLtckC+K2hbCKhDtCHLXH1T3lJDOEfu6VFyjge0nBDOVLYm6d+X4qWnTbXps/3ruj4nm9YoLzd66uPRheQmmpDN3wZF0Zc0xUBTzEV8ZClPWgqZPw4kXkQUNyZo6Om8VMEMVuZmV3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsQIkv2oIecJWHy10QXiI6upvnV1dGLBOmX3cBB3W1E=;
 b=jPHi1BNe8aZ2z6ZM/5DpXK6H2xjecdfOaep5wghdpfGz0qW7vD/W1aB5yAKiInM8dcchZpGV7QKxlVF2CxZdeA/GYGQghXxyomsTkXy/4EdKw88ViH+auAVQbIro8n45QvDgngwHOy8WGF/k+KBAGSefcsAparaxle2Jq5pFC26yl5uUbTB36Mi70RAEUS/TaAeOgRy1kHgREcEP8g9XBUnI2ntUEO50Y4mWYjSk9uiw6GM9bllBIHosN/ZOSsN8ShGT5LKyyRoej1SpXIxblxSm70S7oGvO8xf1815XQwP3lg/Gqx0n8/W/dzMCnypZc+o4JbejswHatnBJRCPjcA==
Received: from MN2PR17MB3375.namprd17.prod.outlook.com (2603:10b6:208:13c::25)
 by SA0PR17MB4159.namprd17.prod.outlook.com (2603:10b6:806:8a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 03:49:43 +0000
Received: from MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::48d3:68bb:bdcb:4658]) by MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::48d3:68bb:bdcb:4658%6]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 03:49:43 +0000
From:   Vanessa Page <Vebpe@outlook.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        "joel.peshkin@broadcom.com" <joel.peshkin@broadcom.com>,
        "dan.beygelman@broadcom.com" <dan.beygelman@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Thread-Topic: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Thread-Index: AQHYnJYZEMhK4a4RdUuXvO3VZlf0QK2IK86AgAAANYCAAAMvTIAAAXQD
Date:   Thu, 21 Jul 2022 03:49:43 +0000
Message-ID: <MN2PR17MB3375B8FBA2C18CCD4B3DE2B5B8919@MN2PR17MB3375.namprd17.prod.outlook.com>
References: <20220721000626.29497-1-william.zhang@broadcom.com>
 <40cec207-9463-d999-5fc9-8a7514e24b91@gmail.com>
 <2492407a-49a8-4672-b117-4e027db09400@gmail.com>
 <MN2PR17MB3375B15F7E0673D50B241CD5B8919@MN2PR17MB3375.namprd17.prod.outlook.com>
In-Reply-To: <MN2PR17MB3375B15F7E0673D50B241CD5B8919@MN2PR17MB3375.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [uRFvVvs481gBXO1JzFsCcJCCFtUXFzwHegLYZrOUgxY2HwRecz7t5nDDSaVAxX/qIhsre8ceHzI=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f6742f3-c936-4323-6542-08da6acc0c21
x-ms-traffictypediagnostic: SA0PR17MB4159:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/zrxv7riJOplbzN3HX8dBpgLkUVLcRFpofUtw0W9rZBFsGnzfGN6qEro1qzO801ufq0nhsvOaLczCzdtqyWMwTPKsMiucYffzFX6yr44dIx70U30FJVJAlIhVrAQ/zpDYp/b7KWUyarcgd8EU6A9ClsnR2efU9+5lVkYH14QuNy6EzBZ3XweZd4b1RTBR30ZWo0UtYmfNmiGVDljcnz2SQqPOE8FOEPhCGnILt8FoAcMnV18SIycedl3UvBBG/nAsIhi55G1Du5F0h+V9yinPVJVtIQl42egCnvS7crRUEMt5P7OcZU0IlV9qJqbqB9sRvePK/KtvxKv4w6iPmXEwPN7zq46e0aWmEVD3bDTr0hP4jEOQVuYMZJODTf1ddf//SRdH+qfbhg/PA+0x6ybY7/4fTg1bHZmFqjrnUDou5hzhW5gHzjKeIKOBdSFm0ep3SLcXJ0DNnY45+9yjV5F1MVK2txMb+VdTG7cRDA4Z51ARSWEF48CzZHWjWX8COBCUXjU/Ini/RBX+h/pl6SmD6U9aAwQMCicm9LOJBrU4ylYwaAyZP1NN0Hpin+EOdlkhjbAECdC/d1/u9/2DG+LWx8J5ELL5eNJnNOCgJtPqM8GRuqHzW4YPZCynjvlC2+ljfCM2vcv47rHn9YUlJPT1sRiUhQK1RAhb/ImDzyFkMhjihSWqqTCwrxhONSEddj
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUFKWEptWXN0RGJqMFVpRTg5N084TmNDRjZCYkZyeVdHTzRSOFJIeUxmUERm?=
 =?utf-8?B?MjFNeGpVWXNGamdRbXEyekk2MktycHQzMENUSC9mUWRyUm9yUGhEZFBmRkR6?=
 =?utf-8?B?YjV4Q1pyMXE0SUF0Wk5KSVNqdzczK1NaejdoZERLbVVXOXZTdFZwVDhXWXZh?=
 =?utf-8?B?KzExTWhqV0dCcmNHeXFXN2gvWU1HMXAyUlZtWEdhTVc3WHd5RStDcWVQdXZ1?=
 =?utf-8?B?SG5lZTJWbEJTb0VFMkgyMGVlNnNubUpteExyMHRXSHNQQzY1eWhaUlBLRzMz?=
 =?utf-8?B?RUVtSGg2TUFmM2ViMktpcGlIMmhnZStKNEFzNU5tQ1BMcWZiT0NRa1VvalhY?=
 =?utf-8?B?Q29FMWxBdjBMUGNlTG9RV1g5c3hncUtJd3lDMnJUbVIrbVFWOTM5Y0F0cEpj?=
 =?utf-8?B?SEhZL2UvbnZJOER1dGJ5RUxRUnZlaW1PbWU2UXd4b1NEVE1xSWFYSEpzNVFZ?=
 =?utf-8?B?UnhrOHBkaVg5Y0RuZnFKNExmWXlFVEtZWjFia3lqUWRwZmExRnZyU2pmUllj?=
 =?utf-8?B?ZDdzb29yZEJkRXVOdmI2aXA2UUhtQ3NxWVMxeUxlaDRvZ1NZV2lRT2pIL1Yx?=
 =?utf-8?B?Ny9hSThBRGtGWnNCbzhGc013eVFSWHdSY0FnTkhaVktrRUdha2h0ams5ZVJa?=
 =?utf-8?B?TkhlYmgwMmdXQnY0ZlVzQnUyTEtLS2J3Vng4MkpDMzBoY04xa2I1VmliZzRN?=
 =?utf-8?B?S2huYTJUU09XTjc4THlNV3JDakcvdlFxYktGcC9TazVjMGs5ZG9tdEsvY28y?=
 =?utf-8?B?VUNWbUVFRENMODVEMW5mM2xWTUFVQ0tlNjg2dDN6OFp6Qks5UWVVZE1jd1dC?=
 =?utf-8?B?ZENYc1JQZ1NpaUVCRCszejM3MkFvZDBLcXB1R01IMFdDdFprK2U1NWlRZ0w4?=
 =?utf-8?B?eUU1dDQ1N3FjR3J3MlF6UGFkd25OQkYvQnNpZklUdkhkSGVRZEY5UzdQQ0R3?=
 =?utf-8?B?WXZMcDh0dTlzQ0NsUk5PcFlFZnBsZis5dmQva1A0NlpWK2tsZi8rWVhxbkFx?=
 =?utf-8?B?OU8wQUlNb2k4RHVuM21YdGhJYm9neHlKdXVIc0xqZTZsV0RQb0NIZWYzbXVo?=
 =?utf-8?B?aEh5UjlLcERHcmRrbC82b0ZjMU5rb1pqbXRCeFpyRS9vWlRLMFVLT2Jid3Ri?=
 =?utf-8?B?SjB4azU4aHB6UTFaa0JoanEwYU5GL2ZlZG5IVFQ4eG5GYzVrT1lSOE4wcjh6?=
 =?utf-8?B?VnppWmlHOGUrM1BEM0ovMHNzQWQrSnFBNEE1YTBkZjZFRlNBMmx5dDY1UHND?=
 =?utf-8?B?eWVXL3ZJaFZub0R6aUxIWjgyaktMYUNtaHBnaG9PVUJ5Mll4SjB6UC9qM2w5?=
 =?utf-8?B?RDJnZys3bzEwekVoM2dBVEsrYWZuT0RvWXdZVHNJUmRKb3pISmpLTERMckxv?=
 =?utf-8?B?L1NPOG5SUXVGNGpDWnpveHI2MjYrOTlVSkpTUzZ5dVRMRHliWUJGZVZjUDJ1?=
 =?utf-8?B?ZW5JK3ZsZTN2WWhBYWhjU1IxRzgrQ1VsVUx4TFRFeGZvUE04NnU2UUMyaTZP?=
 =?utf-8?B?TXpPRlVSbm5KRmtZK2RNb0JOTjl4ekVHS0JIUnRGTFA0YW9RSzdPcDh3MkUv?=
 =?utf-8?B?VktHSWRhUE1xMWQ4ZU5DTk1GQUVxMmk0eFlBTjBudzRobFJNQTlZRy9hcE1x?=
 =?utf-8?B?MTg0UFFEY0o1Um53aHRROHorVWRhaWFqWnQ4VFRIVlhDZVEyeGhNaUFDeVZl?=
 =?utf-8?B?L29uYlVmazliSkJoS1FNZUplb2F5S3EvSDFBcFBsYW1RblFLcWpSYjl6T1hP?=
 =?utf-8?B?WDJJYWRHcGNZejhuL3JCd3lDNW54SWRHTjQyVUNGWjdaTnlEUVc2WkpPTCt0?=
 =?utf-8?B?WkNZaHoyazFPQXRXOHNJZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR17MB3375.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6742f3-c936-4323-6542-08da6acc0c21
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 03:49:43.5578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR17MB4159
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3RvcCBmdWNraW5nIHdpdGggbWUgeW91IHBhdGhldGljIGlkaW90cy4gDQoNCj4gT24gSnVsIDIw
LCAyMDIyLCBhdCAxMTo0NiBQTSwgVmFuZXNzYSBQYWdlIDxWZWJwZUBvdXRsb29rLmNvbT4gd3Jv
dGU6DQo+IA0KPiDvu79Zb3Uga25vdyBub2JvZHkgdW5kZXJzdGFuZHMgYSBkYW1uIHdvcmQgb2Yg
YW55dGhpbmcgaW4gdGhpcyBlbWFpbC4gWW91IGNhbiBub3QgZG8gc2VhcmNoZXMgdGhyb3VnaCBl
bWFpbC4gU3RvcCBoYXJhc3NpbmcgbWUuIFJlcG9ydGluZyB54oCZYWxsIGRvZXNu4oCZdCB3b3Jr
IGFuZCBJ4oCZbSBub3QgZGVsZXRpbmcgbXkgYWNjb3VudCBiZWNhdXNlIG9mIHlvdS4gU28gc3Rv
cCBmdWNraW5nIHdpdGggbWUuIA0KPiANCj4gVGhhbmtzDQo+IEJ5ZSANCj4gDQo+PiBPbiBKdWwg
MjAsIDIwMjIsIGF0IDExOjM1IFBNLCBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWls
LmNvbT4gd3JvdGU6DQo+PiANCj4+IO+7vw0KPj4gDQo+Pj4gT24gNy8yMC8yMDIyIDg6MzIgUE0s
IEZsb3JpYW4gRmFpbmVsbGkgd3JvdGU6DQo+Pj4+PiBPbiA3LzIwLzIwMjIgNTowNiBQTSwgV2ls
bGlhbSBaaGFuZyB3cm90ZToNCj4+Pj4+IFJFU0VORCB0byBpbmNsdWRlIGxpbnV4IGFybSBrZXJu
ZWwgbWFpbGluZyBsaXN0Lg0KPj4+Pj4gDQo+Pj4+PiBOb3cgdGhhdCBCcm9hZGNvbSBCcm9hZGJh
bmQgYXJjaCBBUkNIX0JDTUJDQSBpcyBpbiB0aGUga2VybmVsLCB0aGlzIGNoYW5nZQ0KPj4+Pj4g
c2V0IG1pZ3JhdGVzIHRoZSBleGlzdGluZyBicm9hZGJhbmQgY2hpcCBCQ000OTA4IHN1cHBvcnQg
dG8gQVJDSF9CQ01CQ0EuDQo+Pj4gTG9va3MgbGlrZSBvbmx5IDEsIDIgNCBhbmQgNSBtYWRlIGl0
IHRvIGJjbS1rZXJuZWwtZmVlZGJhY2stbGlzdCBtZWFuaW5nIHRoYXQgb3VyIHBhdGNod29yayBp
bnN0YW5jZSBkaWQgbm90IHBpY2sgdGhlbSBhbGwgdXAuDQo+Pj4gRGlkIHlvdSB1c2UgcGF0bWFu
IHRvIHNlbmQgdGhlc2UgcGF0Y2hlcz8gSWYgc28sIHlvdSBtaWdodCBzdGlsbCBuZWVkIHRvIG1h
a2Ugc3VyZSB0aGF0IHRoZSBmaW5hbCBDQyBsaXN0IGluY2x1ZGVzIHRoZSBub3cgKGV4KSBCQ000
OTA4IG1haW50YWluZXIgYW5kIHRoZSBBUk0gU29DIG1haW50YWluZXIgZm9yIEJyb2FkY29tIGNo
YW5nZXMuDQo+PiANCj4+IEFuZCB0aGUgdGhyZWFkaW5nIHdhcyBicm9rZW4gYmVjYXVzZSB0aGUg
cGF0Y2hlcyAxLTkgd2VyZSBub3QgaW4gcmVzcG9uc2UgdG8geW91ciBjb3ZlciBsZXR0ZXIuDQo+
PiAtLSANCj4+IEZsb3JpYW4NCj4+IA0KPj4gX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fDQo+PiBMaW51eCBNVEQgZGlzY3Vzc2lvbiBtYWlsaW5n
IGxpc3QNCj4+IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGlu
dXgtbXRkLw0KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18NCj4gTGludXggTVREIGRpc2N1c3Npb24gbWFpbGluZyBsaXN0DQo+IGh0dHA6Ly9s
aXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbXRkLw0K
