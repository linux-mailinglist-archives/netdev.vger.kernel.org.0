Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312CD5B9EF6
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiIOPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiIOPfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:35:06 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2130.outbound.protection.outlook.com [40.107.21.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301C758099;
        Thu, 15 Sep 2022 08:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E63Hu4ySjSTHomiW7L91d3QAKKFambmb0qR/FebhbeawkPXd0v0BuCmRaMazhW5NBAO5bWnceMOn9kdNld5Vz53ErVAha85qpH9NMjroVfiEogtVSEpu+IEEByVVauw5GvyTiFvEJFqNVDeFEWsG1DvGJ4tUrMcsTibyYwuTd9QFR8nhV2Lml2x3+y213PZubl1I6mN0fQKEfO7YNOEToApJefOQjC3BuSTPUJwSajI54neHXCoP9+k0Zc8U8/ktAwzzveMb7qFU4F8DbP6iCqZOfowPuQCuZCl7Tepq5MYqI8eDx39cCelefixZWG2ppuAf7DPDWDxMZB6ss/lRSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AmKZrzUFBWmpJhiw/3XP2x1jCW7RIur9LRhfThtPeOg=;
 b=miHFYXKmyxP5WH90XpEBLo9beEzWm5KXSj0GDXy+Z9ghuwoqWJS7vlji/AzSD4LshcFhya1NtDN9jTZtVXmrjmipltnCppf+3vUIqaCKCeW9AckNP1kP5U8ctrrYHV6U4+ihDYPSMLKYdPqoTgxt1PA0jap5p6/cAiEFJdIVB0eSu0YO7BBH02+rCSy9r2xnjQHDsA5ELRok5eklrkw+O+JLxFizs5Q3kwE+AeaC8z3MM3FIF+PD9Ka4kcMWRs+CSevHMmjfOo1cmpInRFjUhKXnw+UcQNQBRH54JKhFntxWCcpE89MLDsNejtpSvqfdzY1Y+2C2cRm/TQWJZE6PNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmKZrzUFBWmpJhiw/3XP2x1jCW7RIur9LRhfThtPeOg=;
 b=kd8Ghgulw8tPPNSBIE6FP9Qeo9z9ZzkjrhXVMyuPFQXdMtF2SYYP/WbMXIcIfs+C9lwA83F7Yni7AgplcrcuoeQP19oCkWAsebL00nADxn8mokg+9PFNnwcxQfAU5PUNWhbTFQ5otD6GVnLFFbnrQy8bBwPOgZSPXiELxEvJPP4=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:34:59 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:34:59 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 11/12] brcmfmac: pcie: Add IDs/properties
 for BCM4378
Thread-Topic: [PATCH wireless-next v2 11/12] brcmfmac: pcie: Add
 IDs/properties for BCM4378
Thread-Index: AQHYyRi3xj6oNdMJR0m5ZebHMKLX9A==
Date:   Thu, 15 Sep 2022 15:34:59 +0000
Message-ID: <20220915153459.oytlibhzbngczsuo@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg8C-0064vf-SN@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg8C-0064vf-SN@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: 8a20e4eb-e619-4d42-2053-08da972fd9a4
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AFHX+7Z21ojkzS9P4C02RN/rfEx11CCX9pzA7+wc7YB67vv871/gkNF17RFDsre2rJ7QPMOQ5l6o3O7rsP3zaMs7fbmvbWOeGSRTEq+8jMf7IoskUZp4UEveokWHmQXHawcllTHJSxRW0x9bAfioh+CTYvMPFlohUTnKgAEDHltxE9izjZmm2YAhd6wcEBHNmX/4fZ7XL0Pv6OzPZC1lbj+0A2++QvsIv8vsHYBlPh033QO5E/DA8J2fuD5hWIRh+NBQhQlol+oqm7bvB+4/85aYOsXGY2WNtlAO2/Y2neZtd45w0iOX7NiqG6QWoTcCAoiYlvZK9uVCaPNhbcLcjGJ8xsxRjAo3ZKqV0gFfdC4WpcFQ+hTrWFods4DLxuuplNtqhGDPpJB2tEa2HWTK55Lj9npEswT5yXUEjw7DZg2xH6gUoxv6USTe7+11vh6AMRnTDECzVElm9P3YBkfY0+5ulLrYM8sObfnHtt8zRwY6JDd2yR5UCn9nvOwyJAAHlTcHAdMVk35n06qG1+B9vfs8YZ+Yn5SlT/sbqsmpB9BUhG6Ol64w4+sS4O+T5k1RLmhoqekC1UwV8FM//aVCv+xooZFCvWlPSHd+W7AtaO6h4C6TxtW6cx22dGi5YnKGd3EDI3sCxwEJFQ5yuhNnG0UhcPTJ/2ZAiYvCo41VA3+Ak2TcsNo8R0nXUU4I4xAscSOVqo50zBJdHv8Kv4bRyDDU0/RNOvAH358ytXT6dRb4OaN5EObDc3xB14V5YZjR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(3716004)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(38070700005)(85182001)(26005)(478600001)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFF5Zm10cjQ1VWRKdUJvaXlZWCs2UkhoaE11M3RzeWIwMGpwaWwvVnhWeExy?=
 =?utf-8?B?ZXlFY3VjdnprVEUvbU9WcERyWXJDQzdFUHBwQ0VvVFYvK3Q1d3Vhd2Q4MU1H?=
 =?utf-8?B?QUV5MlAwTFd0bFpkWVlhcm5Lc3EvcW10eXREazJSaC82V2lyMThOZTRScUtm?=
 =?utf-8?B?eHRtVjlhU0ppL0RoZ1VNeGFWeHFQRk1ZZmZUdFl0dGtqcGp6YkFkMHc0cWZn?=
 =?utf-8?B?bmFkb2VDb0RiVHlDMVQ0ZTZaZmk4SmNiSEJWMXB2MC9RWW9KRXA5QlN6UUdl?=
 =?utf-8?B?Tlc5RklVeU10SFdkUUt2b1F6ckYweEt1Q0FPeVdCUzJBVWpXditHNmR2SWpT?=
 =?utf-8?B?Mm0yS25rQk4xMTAzdDhqUWpzbWRvWUdJNlhLUmZWQUJrT0tyQitiRlF3TmNk?=
 =?utf-8?B?eTlyME95K1prVDA0Y1JvSmlxb3d0cnd3QlZPWTg1ajg5aVpOZkdhZkdkc293?=
 =?utf-8?B?TEQ5NnR4UlRUajNLNzZNZTYwK3pWY0ViZDRSaUMyV3l5blp2R2Y2WXFjclo4?=
 =?utf-8?B?aUt2dzJFcXBzeFZFKzIybDFhSW1meEFzTWxqTGp5RnNsQ2RRNzdvTFdUZ3Fu?=
 =?utf-8?B?Q05pT210RkVmWC9oR3hNVWkzVm9qUlJEKytIUExzV01vMTlhZjdrdUdQYW5V?=
 =?utf-8?B?eUM1VnQ2VEVONHhPb3MrYWVjbGZpTXNsdHdWbUFDNjFXZ1hNQ1lJY2tLU016?=
 =?utf-8?B?K1htcnovek1sM241UWI4YTJGQmNmYjN2NVgrWnJvTkZkTjg1M25aSUk1cG9H?=
 =?utf-8?B?ZFh0QVVVYWorUjRHNzdLNXgwOUJOa1RhSEZZR1c0eDBBWDJOYlFjRGU2YzRQ?=
 =?utf-8?B?R0w3cjkzQ1c1RmJuQ1R0d2VsNnhMVkNGWktEZmtFZ3ZyU05oY3R4SDEyTmJV?=
 =?utf-8?B?SCtvNFh0R05UOCtkNHRpcndZK1JVYUlGeStwRGQ5MThNZUN3c2RFd2VJazM5?=
 =?utf-8?B?VlIvQXA5Z2ZZQ2Vzdzc4Z0NIUGZ0UEhyWngxRCtFcmRITk41bWVkcE0yelM1?=
 =?utf-8?B?cTBsOHhycFkrNnY1QzBQazdnYXVYWURDcVFYaVhzbk1tUVJvajl4ZFlUM2pN?=
 =?utf-8?B?VU1USUJZTlUrTXlzQTlHaUxZWGora28ybGUvbFA2K0FzMjhoK1JoTWtsc3I2?=
 =?utf-8?B?cktpK0JWTS9oNHZzenhIWS9GWjRWS01SVVVOMWY0MEtDaVhHdzFSZ0pVSkox?=
 =?utf-8?B?Mlp2SXRYOFQxVW53cWNhK1VQQitVdjhFRk55SjJPV3VjSFN4U29hZzZ5ZE1V?=
 =?utf-8?B?SHpSVGh1eWswQm1OcjBhS29NeTJ1Wk9VL0p3Z3o4bytYU0tpUlN3cTVmM1VF?=
 =?utf-8?B?YjJ2UnFEaWdKRHJWejlJN1lLUW1WLzV5TGY5bzFpWkdQbGg3Tm9xdUQxdzNj?=
 =?utf-8?B?NHBQSTBiUzlycnM2M1FXclA2WHlNcjlUSFRnMVBpdTNJZElOTkpxQTBIVjBM?=
 =?utf-8?B?ZFFjZEZkekg5N1RIYytZeDh3VFkwdUx5a3dya2NWU0hURGJuaW45VElkcFZ5?=
 =?utf-8?B?VWZnUEs3ZDVMOHNEcWcvUFRocDlSMk5ZU0NCT0FQaHVGcUw1VE12VFprV1VH?=
 =?utf-8?B?QThaVGVTamhRS0VqN3ZEd1ExMVdNYzVnUERYejd3ZmJoZG5jUzFYeXFRNDJJ?=
 =?utf-8?B?cW44QmdEc1V4cDhJV1A5VUk3akZVZyt1Qm0wcERKVGR4VTVFVGkySEpzeXlI?=
 =?utf-8?B?N0ZidnNqQnpTbC93Z2czOUlvYlpqekFhZ1JXc044cXhhdk5LWjM2UXBGVTBk?=
 =?utf-8?B?TUJndHZ6RTN2MldybVcwK0trd0JJVktGcWVrTTBreTVnT1BBWVcyd2Z6S3Jv?=
 =?utf-8?B?ZERWWFVwSXB4NkEyTi9OSmUvS3czYWt4M2x4Zk00L3R5bFQzZDJCT1U1U0wv?=
 =?utf-8?B?UWJzdjl6eEVVS25jMHRJaklJMUFuWDhuZHhxenE2eVFsTnNxM3pnL05KdXFi?=
 =?utf-8?B?a1lVdnVwa0pWVnhjZVZOUXdOeXR2NFZGZk1LTitMdFhSLzh6dG1hWVZhczd5?=
 =?utf-8?B?Y1dhd09YV2tweFpQakJWazRDRHJuMGxXQTVFZlZxcDJLbDMyTW9hYjVPZWF2?=
 =?utf-8?B?TERhdjU3aHZoaG96d1llVFJWZlpYWFJXRXo3WUtXNUF3KzByME5maTB0Mkgx?=
 =?utf-8?Q?IhoQEiMTU+C8ep1XXpMf/Pa2Y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9A25E757F69DF4AB35793A4A08C94AC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a20e4eb-e619-4d42-2053-08da972fd9a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:34:59.6546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 86gOMF7dk465wqAN5FBqjTFNuEhBp4JlfDZPQqbkliQnXMBS0g0eK6qb1zFiYqqVVqEerFde+wdMumKpCdfQVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTM6MzJBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gVGhp
cyBjaGlwIGlzIHByZXNlbnQgb24gQXBwbGUgTTEgKHQ4MTAzKSBwbGF0Zm9ybXM6DQo+IA0KPiAq
IGF0bGFudGlzYiAoYXBwbGUsajI3NCk6IE1hYyBtaW5pIChNMSwgMjAyMCkNCj4gKiBob25zaHUg
ICAgKGFwcGxlLGoyOTMpOiBNYWNCb29rIFBybyAoMTMtaW5jaCwgTTEsIDIwMjApDQo+ICogc2hp
a29rdSAgIChhcHBsZSxqMzEzKTogTWFjQm9vayBBaXIgKE0xLCAyMDIwKQ0KPiAqIGNhcHJpICAg
ICAoYXBwbGUsajQ1Nik6IGlNYWMgKDI0LWluY2gsIDR4IFVTQi1DLCBNMSwgMjAyMCkNCj4gKiBz
YW50b3JpbmkgKGFwcGxlLGo0NTcpOiBpTWFjICgyNC1pbmNoLCAyeCBVU0ItQywgTTEsIDIwMjAp
DQo+IA0KPiBSZXZpZXdlZC1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8u
b3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0K
PiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgPHJtaytrZXJuZWxAYXJtbGlu
dXgub3JnLnVrPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJh
bmctb2x1ZnNlbi5kaz4NCg0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgw
MjExL2JyY21mbWFjL2NoaXAuYyAgIHwgMiArKw0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJv
YWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYyAgIHwgOCArKysrKysrKw0KPiAgLi4uL25l
dC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvaW5jbHVkZS9icmNtX2h3X2lkcy5oIHwgMiAr
Kw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlw
LmMNCj4gaW5kZXggMjMyOTVmY2ViMDYyLi4zMDI2MTY2YTU2YzEgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2No
aXAuYw0KPiBAQCAtNzMzLDYgKzczMyw4IEBAIHN0YXRpYyB1MzIgYnJjbWZfY2hpcF90Y21fcmFt
YmFzZShzdHJ1Y3QgYnJjbWZfY2hpcF9wcml2ICpjaSkNCj4gIAkJcmV0dXJuIDB4MTYwMDAwOw0K
PiAgCWNhc2UgQ1lfQ0NfNDM3NTJfQ0hJUF9JRDoNCj4gIAkJcmV0dXJuIDB4MTcwMDAwOw0KPiAr
CWNhc2UgQlJDTV9DQ180Mzc4X0NISVBfSUQ6DQo+ICsJCXJldHVybiAweDM1MjAwMDsNCj4gIAlk
ZWZhdWx0Og0KPiAgCQlicmNtZl9lcnIoInVua25vd24gY2hpcDogJXNcbiIsIGNpLT5wdWIubmFt
ZSk7DQo+ICAJCWJyZWFrOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJv
YWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jy
b2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9wY2llLmMNCj4gaW5kZXggMjY5YTUxNmFlNjU0Li4w
YzYyN2YzMzA0OWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29t
L2JyY204MDIxMS9icmNtZm1hYy9wY2llLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYw0KPiBAQCAtNTksNiArNTksNyBAQCBC
UkNNRl9GV19ERUYoNDM2NUMsICJicmNtZm1hYzQzNjVjLXBjaWUiKTsNCj4gIEJSQ01GX0ZXX0RF
Rig0MzY2QiwgImJyY21mbWFjNDM2NmItcGNpZSIpOw0KPiAgQlJDTUZfRldfREVGKDQzNjZDLCAi
YnJjbWZtYWM0MzY2Yy1wY2llIik7DQo+ICBCUkNNRl9GV19ERUYoNDM3MSwgImJyY21mbWFjNDM3
MS1wY2llIik7DQo+ICtCUkNNRl9GV19DTE1fREVGKDQzNzhCMSwgImJyY21mbWFjNDM3OGIxLXBj
aWUiKTsNCj4gIA0KPiAgLyogZmlybXdhcmUgY29uZmlnIGZpbGVzICovDQo+ICBNT0RVTEVfRklS
TVdBUkUoQlJDTUZfRldfREVGQVVMVF9QQVRIICJicmNtZm1hYyotcGNpZS50eHQiKTsNCj4gQEAg
LTg4LDYgKzg5LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBicmNtZl9maXJtd2FyZV9tYXBwaW5n
IGJyY21mX3BjaWVfZnduYW1lc1tdID0gew0KPiAgCUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0NfNDM2
NjRfQ0hJUF9JRCwgMHhGRkZGRkZGMCwgNDM2NkMpLA0KPiAgCUJSQ01GX0ZXX0VOVFJZKEJSQ01f
Q0NfNDM2NjZfQ0hJUF9JRCwgMHhGRkZGRkZGMCwgNDM2NkMpLA0KPiAgCUJSQ01GX0ZXX0VOVFJZ
KEJSQ01fQ0NfNDM3MV9DSElQX0lELCAweEZGRkZGRkZGLCA0MzcxKSwNCj4gKwlCUkNNRl9GV19F
TlRSWShCUkNNX0NDXzQzNzhfQ0hJUF9JRCwgMHhGRkZGRkZGRiwgNDM3OEIxKSwgLyogMyAqLw0K
DQpXaGF0IGlzIC8qIDMgKi8/DQoNCj4gIH07DQo+ICANCj4gICNkZWZpbmUgQlJDTUZfUENJRV9G
V19VUF9USU1FT1VUCQk1MDAwIC8qIG1zZWMgKi8NCj4gQEAgLTE5NzAsNiArMTk3MiwxMSBAQCBz
dGF0aWMgaW50IGJyY21mX3BjaWVfcmVhZF9vdHAoc3RydWN0IGJyY21mX3BjaWVkZXZfaW5mbyAq
ZGV2aW5mbykNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+ICAJc3dpdGNoIChkZXZpbmZvLT5jaS0+Y2hp
cCkgew0KPiArCWNhc2UgQlJDTV9DQ180Mzc4X0NISVBfSUQ6DQo+ICsJCWNvcmVpZCA9IEJDTUFf
Q09SRV9HQ0k7DQo+ICsJCWJhc2UgPSAweDExMjA7DQo+ICsJCXdvcmRzID0gMHgxNzA7DQo+ICsJ
CWJyZWFrOw0KPiAgCWRlZmF1bHQ6DQo+ICAJCS8qIE9UUCBub3Qgc3VwcG9ydGVkIG9uIHRoaXMg
Y2hpcCAqLw0KPiAgCQlyZXR1cm4gMDsNCj4gQEAgLTI0NTgsNiArMjQ2NSw3IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBicmNtZl9wY2llX2RldmlkX3RhYmxlW10gPSB7DQo+
ICAJQlJDTUZfUENJRV9ERVZJQ0UoQlJDTV9QQ0lFXzQzNjZfMkdfREVWSUNFX0lEKSwNCj4gIAlC
UkNNRl9QQ0lFX0RFVklDRShCUkNNX1BDSUVfNDM2Nl81R19ERVZJQ0VfSUQpLA0KPiAgCUJSQ01G
X1BDSUVfREVWSUNFKEJSQ01fUENJRV80MzcxX0RFVklDRV9JRCksDQo+ICsJQlJDTUZfUENJRV9E
RVZJQ0UoQlJDTV9QQ0lFXzQzNzhfREVWSUNFX0lEKSwNCj4gIAl7IC8qIGVuZDogYWxsIHplcm9l
cyAqLyB9DQo+ICB9Ow0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvaW5jbHVkZS9icmNtX2h3X2lkcy5oIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2luY2x1ZGUvYnJjbV9od19pZHMuaA0KPiBpbmRleCAx
ZjIyNWNkYWM5YmQuLjEwMDNmMTIzZWMyNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2luY2x1ZGUvYnJjbV9od19pZHMuaA0KPiArKysgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvaW5jbHVkZS9icmNtX2h3X2lk
cy5oDQo+IEBAIC01MSw2ICs1MSw3IEBADQo+ICAjZGVmaW5lIEJSQ01fQ0NfNDM2NjRfQ0hJUF9J
RAkJNDM2NjQNCj4gICNkZWZpbmUgQlJDTV9DQ180MzY2Nl9DSElQX0lECQk0MzY2Ng0KPiAgI2Rl
ZmluZSBCUkNNX0NDXzQzNzFfQ0hJUF9JRAkJMHg0MzcxDQo+ICsjZGVmaW5lIEJSQ01fQ0NfNDM3
OF9DSElQX0lECQkweDQzNzgNCj4gICNkZWZpbmUgQ1lfQ0NfNDM3M19DSElQX0lECQkweDQzNzMN
Cj4gICNkZWZpbmUgQ1lfQ0NfNDMwMTJfQ0hJUF9JRAkJNDMwMTINCj4gICNkZWZpbmUgQ1lfQ0Nf
NDM0MzlfQ0hJUF9JRAkJNDM0MzkNCj4gQEAgLTg4LDYgKzg5LDcgQEANCj4gICNkZWZpbmUgQlJD
TV9QQ0lFXzQzNjZfMkdfREVWSUNFX0lECTB4NDNjNA0KPiAgI2RlZmluZSBCUkNNX1BDSUVfNDM2
Nl81R19ERVZJQ0VfSUQJMHg0M2M1DQo+ICAjZGVmaW5lIEJSQ01fUENJRV80MzcxX0RFVklDRV9J
RAkweDQ0MGQNCj4gKyNkZWZpbmUgQlJDTV9QQ0lFXzQzNzhfREVWSUNFX0lECTB4NDQyNQ0KPiAg
DQo+ICANCj4gIC8qIGJyY21zbWFjIElEcyAqLw0KPiAtLSANCj4gMi4zMC4yDQo+
