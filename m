Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17E25641FD
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiGBSIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 14:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBSIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 14:08:17 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2101.outbound.protection.outlook.com [40.107.114.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153BD2E7;
        Sat,  2 Jul 2022 11:08:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta9Da89mwi3Z9jQW0siyDSYOSBRytUIwnyIRcsgFgxeyR3oDZet+TfQUCe1CPNz7N6gOgNwdf9xrHQV1ibBIaMCyPvl/KUZklmEt4uaeRZM5lMOMNDvSy8yy4Z+czu1UvHjt6plG5x6JI1Ny9Qz1inBCnMFshgmTQ5ZnlxMrQottjgad7VGiFrgiuwLxLaoJKuvT4a1XrHcMbfBptlYugmz7LYAFYvQ7NDyZtIYofP8XaWGMAhd7LY0zivZmGNF+1nomRfeUeL2TsZQkxQfGL8BK7tKDd/NcD/8CnhPmeJfps7UvoV26Y9VycV3yn6Xj9HSJ+C3bDNN/D5+hSTi0bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ztx50OK/jabxvgIH10vGkeGsLra9H0FXlQpmhpn5Am4=;
 b=mWkMOMfM6O9v1mlnFICqVHFx4X3zdPYXJJBBkAnYgB2dtQy0OBm/KjldQqNHRzegiiam9LIiAZWegINVP9K2LuyAs9dTktIgR7Imq7V/mAeemtR7r1+CbgCHP2duNKvsUKvys9ntCtqgui8xA5bvEg7z2y5nYrzDNPIinsPksUl7P7c2vGXb11flJLJE96tEtp3gCuLQ0SZF0nMuxt09GaPq62faj8VZzgu97mMI/HJRVdm8jJNBk8i4IHzfpTeAViwaUcxDl1WRC2RqKPPDafM0Y7/Gar4Lj4vOa9ToyxT8MIzpzEH2l/VhkXDoW1fvZGscfnvNFOmM0egI5adfFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ztx50OK/jabxvgIH10vGkeGsLra9H0FXlQpmhpn5Am4=;
 b=JzHsv6/nC2Ukm0tDDsK4RfcFOw1Fcvivsp8un5xiJ1xjjK4aXVRVpMy0ZcSuidPRbAebvI6oQectargqr6r750T72Z5CHToTdlN/hLiLGpqTLlQ9qxDznYw5DHE9sNy41hySypSBgo89SLrW9eFGMlH6FGdNaNBrbabp3UT4yxI=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by TYCPR01MB7702.jpnprd01.prod.outlook.com (2603:1096:400:17b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 18:08:11 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::dc06:eb07:874:ecce%9]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 18:08:11 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Thread-Topic: [PATCH 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Thread-Index: AQHYjhxN2EHUWhoQnUmuL2WBdAs3mK1rQXeAgAAfcaA=
Date:   Sat, 2 Jul 2022 18:08:11 +0000
Message-ID: <OS0PR01MB5922452249D532A1219C192E86BC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
 <20220702140130.218409-3-biju.das.jz@bp.renesas.com>
 <20220702161445.lwiumlsj6wumyein@pengutronix.de>
In-Reply-To: <20220702161445.lwiumlsj6wumyein@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 747939c4-a021-4351-3554-08da5c55d395
x-ms-traffictypediagnostic: TYCPR01MB7702:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41kzWX30bXYKihgyjU2t/vEhde1EKzazH4kpZlY59UXWwQ7OUE7DOCVD07d5sUT8RnvUrt+NFvyBC1XM2HK5mQLh9bwdiH9LUuFBeps7fyW2H58m9NPfLyjoKuSB0+o0YC9tAbOUfstd/gUeyONgftmu/a4Rj1pxxmCRVcwEAuIwo89f5+NylGo35yfYzUNf8eWLDrzfdiZguKPqSXMNl5iL5P3dCShYQqsK1xuAg+q3JIm5wLxENkfDgS/clkOoHWG4Lh9EdVQB9GovbzxGQpW3Zfcl6vl+P6/tFyD2GylvEpcwwWuBsiyrTSvsrmrtYKRFWak6jyRKIj1mGvjR8QOS/HGjW78tL4oXUu95gisI811iMLKgRRtn9IWHx7jMzRo8lYSnsK5qK8T9p2cKWOiqtaqZZFbFthjKIXy49d3PkRuPxJIt/yzGMEn4Bx2HsFqBmWXweZ1bNN2K+6xfmlrJ5UwlOEaoTY6Y+WfpjWboG5iNOfEGRq7Yyl5v1ttbD24ebd7Yj8eufqnSr1FH8/RgcwR4lIotndr91GHzYz9mhNu1y2HJQy/00allYJnl5zg+DqKoRXSmnBZYJ74v6ZzFgFc+67tE/kQfNIILD/A3A85y2pxiluki6ETPqvUTinvjdEANTCshH7Q8dHvWLuzA/j94PrxkNlx8LTlGJcLrYEQMeqR+8wBFFCXohT4U4Y88twWaJIl36pEQbwPMbo8CsnAqZRLGKiU5rTTkGgFVXTCWOCfqsyAP0NwEC8bSBgmDRXqbriKsWOhD5piyV8G6b+YnGyUFmsuiN+/tTfDSn/fBvFlRcih7U93rHqEe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(122000001)(8676002)(4326008)(53546011)(6506007)(9686003)(7696005)(26005)(2906002)(8936002)(38070700005)(52536014)(66476007)(66556008)(66446008)(64756008)(66946007)(76116006)(5660300002)(7416002)(54906003)(316002)(38100700002)(86362001)(33656002)(71200400001)(6916009)(41300700001)(55016003)(478600001)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TDFYQit6bEtQbjljRzBmT0d4Q1E4NC94U3BqRERRd0VUVml3bHJJb1U0T09Q?=
 =?utf-8?B?T2E5bXNGa1hKOWNLS005RmpoK3lNRWVEamQ2dGhkQ2JKcnExSGZKbkdoeXNY?=
 =?utf-8?B?aE1KUlVTM29Sb3psUktDd2VlM2Zva3h1NDBHY0RUWTBzNnQ2L0RKb2d2TDRJ?=
 =?utf-8?B?cFh6WkdUUkdsYTJmQS82UmhlV0xwb2htUDArYVJyc1RtZFc0d0ladDBvNjAy?=
 =?utf-8?B?d044NFFJZ1I2KzdrTE95SU9HdFNCNFpVcDNRelJxMWVaYUpubHRLNVJlS0tQ?=
 =?utf-8?B?NzNFcFpyN1cyVGFvM0FsVDFnMTlNcWNod0Y0aHdhQTM3OGNNUzljY1JiS0tO?=
 =?utf-8?B?TldBTDE2MGcrOVVBMFZ4SmU3KzRkU24xNEVYdHFCV1Jxa1R5WFROMWppZmNC?=
 =?utf-8?B?QjByOUh4N0RjOXBodTZHTHRCNVJTTDdGTTNjemxZVEplV2ljTXcvSE5FSkpp?=
 =?utf-8?B?OUovM1V3MnlvSVE2d3VWaXZSMXF0cDFCNmtRSktadEM1RDdCd1U4OEQ0RnVi?=
 =?utf-8?B?bGQ2K1hGMWNENWI2ODVYNG5uVDFJNFd6OXBnV0w5UmNncGxxTzBRM1JwT25o?=
 =?utf-8?B?RjRpZldwaGZNYU9wanp4ZVNXeWViUUJTd1ZMODN6a3lXWWU0QWJINzBtT0Ur?=
 =?utf-8?B?Ump5Y2JrU3R4NDBJTm42anIyNkVSa3lzTmpPYXQxdDR2WE9mbzQ0NHBIYmVU?=
 =?utf-8?B?ZFhvLzJDcldwcDEyQ2NMdGJ5Smd6bmE5alVtYWxwRTVIOElMRDZ6QWVvMGt1?=
 =?utf-8?B?cDY0aTFJNmJMTzVkc2tCQmQ4ZnBTeVZ2Qk9TUUt5eUs5eC93Q0FQTDkvMkVE?=
 =?utf-8?B?QmpqZkNLbGtuQUEvNXMrcVJzNzBVc3hhakpZNjZkUW92RUJ6Z3k3TjYrdStY?=
 =?utf-8?B?SHlzSGlTNVZjK3Vud3RTb2FtRkczc1dPelpIZytGR2RsL2hobjZjckZ2aHVo?=
 =?utf-8?B?OE56ZkYrVVNTamJCTWJDcWQybEdYYUt5T2xPQWIvc1VRbVBHRTBucERXUkdv?=
 =?utf-8?B?OGpuWUkyczJ6ektyQlQrd0J4SjhDaTVOaEk5U0tYZXBOTWtDQWp5a3RIZXAz?=
 =?utf-8?B?MHlCWWxYOXBhV2F1NTJjUjl2cWRBVmxJZEdUR0FKV1diaGxTdEQwN3JTUzBD?=
 =?utf-8?B?VWl1UVcyelY1a1pPUUp1ZVNBOERDVjllZlVESWszc1d0bUJ2a29rQ2xmSUNI?=
 =?utf-8?B?VjZ3UEFaN0VkaUtLb1VibHMzeW1aRWY0UVNjelllWUkzY0t5cUs0ckM2bXJI?=
 =?utf-8?B?YVgyQlpVZVloZGpsMVV0N01uWU5TdThNZVFJV3RTeWxuSVp0ZVVtQUV1Sjkr?=
 =?utf-8?B?STZwUWVOWWlZMmNUYWVHS00wVnJWVVRpSi8yd0hFMTAzRHFpZDZpb1IwK0pR?=
 =?utf-8?B?VlJ5KzFBYm96V3hON1RNY3F2RkV0WXRuaStEbk5UazBkamtLTWwyeUp5aWZw?=
 =?utf-8?B?YWZTZ05ERS9yaysxSUFwcVltcW9OTkVaZHpJK2thall0eUZ4aHIwRHVhL3Fa?=
 =?utf-8?B?bVN3cGNSYTZwRUtpRWwrcWYvblNjNHBIVDNuUjViMXUwNGNNc25pSUJwRWtL?=
 =?utf-8?B?SVZPWmFhY1dnTmpOY3pmRjNwYUQva3hsb1g5MFJHMVFLVE5tM3ltZ2pXN290?=
 =?utf-8?B?VHcvdGlFcXVld2d6MnFucEhFRDJsY2xIR3hIR1ZKSDBSK2NFQzl0QTI4cElk?=
 =?utf-8?B?Um81R3NheG8yL3lmVERiS1dTT2hkdDFKMjRXQWpueUlVNXFzc0NMN1pPSkJu?=
 =?utf-8?B?d1R1dG5LTW9aR0NZWEsxVldOeTdjWjhHN3lIRnFQY0cwa1Q3K3RlM3h6N0JR?=
 =?utf-8?B?UXBvRWNybHhSdFJ2TmZEODdjbW5ZN1BpUGd2ZlY0R1I3ak1BQkZ0c252RC9E?=
 =?utf-8?B?Z1NUa01YMWlSS1BRZzludkd3Y24zMnc0ZlNEa3dKMlJNdHVMem1Ld1hHaWZw?=
 =?utf-8?B?YlNlYUM5Y3I0ZXhHK3pmVlluMS85RlRaWEdUTVlnV0s1RnZjRXBpS3BFZytM?=
 =?utf-8?B?Sm9aeVdKM2pDQnZzaXNIMTkyNU9VK3hnYnc0NHRwK2ZHek1NVFJDUzJUbm00?=
 =?utf-8?B?TUpKbW1jQVkvaDRudW9pR09pSlZMQTNSNzJ2NU84VmFNZDFWb2hOOURxdi9w?=
 =?utf-8?Q?WdPllF/ucvLK/5SZIzKyZK+4e?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 747939c4-a021-4351-3554-08da5c55d395
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 18:08:11.7936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7eD3HQiwa02pVbElGr28krjVEtIvUf++ggMbd0vE9XU9Nq5RXWQidlAU+bca7IsE8s4J0qjphugqZEPYHOfgGuJYl7r/BrjJfropqEVsle8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB7702
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suDQoNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCAyLzZdIGR0LWJpbmRpbmdzOiBjYW46IG54cCxzamExMDAwOiBEb2N1bWVudA0KPiBSWi9O
MXtELFN9IHN1cHBvcnQNCj4gDQo+IE9uIDAyLjA3LjIwMjIgMTU6MDE6MjYsIEJpanUgRGFzIHdy
b3RlOg0KPiA+IEFkZCBDQU4gYmluZGluZyBkb2N1bWVudGF0aW9uIGZvciBSZW5lc2FzIFJaL04x
IFNvQy4NCj4gPg0KPiA+IFRoZSBTSkExMDAwIENBTiBjb250cm9sbGVyIG9uIFJaL04xIFNvQyBo
YXMgc29tZSBkaWZmZXJlbmNlcyBjb21wYXJlZA0KPiA+IHRvIG90aGVycyBsaWtlIGl0IGhhcyBu
byBjbG9jayBkaXZpZGVyIHJlZ2lzdGVyIChDRFIpIHN1cHBvcnQgYW5kIGl0DQo+ID4gaGFzIG5v
IEhXIGxvb3BiYWNrKEhXIGRvZXNuJ3Qgc2VlIHR4IG1lc3NhZ2VzIG9uIHJ4KSwgc28gaW50cm9k
dWNlZCBhDQo+ID4gbmV3DQo+ICAgICAgICAgICAgICAgIF5eXg0KPiANCj4gcGxlYXNlIGFkZCBz
cGFjZS4NCg0KT0suDQoNCj4gDQo+ID4gY29tcGF0aWJsZSAncmVuZXNhcyxyem4xLXNqYTEwMDAn
IHRvIGhhbmRsZSB0aGVzZSBkaWZmZXJlbmNlcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJp
anUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2Jp
bmRpbmdzL25ldC9jYW4vbnhwLHNqYTEwMDAueWFtbCAgICAgICAgIHwgMjINCj4gKysrKysrKysr
KysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdA0KPiA+IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC9jYW4vbnhwLHNqYTEwMDAueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL25ldC9jYW4vbnhwLHNqYTEwMDAueWFtbA0KPiA+IGluZGV4IDkxZDBmMWIyNWQxMC4u
ZDBkMzc0Yjk3OWVjIDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvY2FuL254cCxzamExMDAwLnlhbWwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi9ueHAsc2phMTAwMC55YW1sDQo+ID4gQEAgLTE2
LDYgKzE2LDEyIEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAgICAgY29uc3Q6IG54cCxzamExMDAw
DQo+ID4gICAgICAgIC0gZGVzY3JpcHRpb246IFRlY2hub2xvZ2ljIFN5c3RlbXMgU0pBMTAwMCBD
QU4gQ29udHJvbGxlcg0KPiA+ICAgICAgICAgIGNvbnN0OiB0ZWNobm9sb2dpYyxzamExMDAwDQo+
ID4gKyAgICAgIC0gZGVzY3JpcHRpb246IFJlbmVzYXMgUlovTjEgU0pBMTAwMCBDQU4gQ29udHJv
bGxlcg0KPiA+ICsgICAgICAgIGl0ZW1zOg0KPiA+ICsgICAgICAgICAgLSBlbnVtOg0KPiA+ICsg
ICAgICAgICAgICAgIC0gcmVuZXNhcyxyOWEwNmcwMzItc2phMTAwMCAjIFJaL04xRA0KPiA+ICsg
ICAgICAgICAgICAgIC0gcmVuZXNhcyxyOWEwNmcwMzMtc2phMTAwMCAjIFJaL04xUw0KPiA+ICsg
ICAgICAgICAgLSBjb25zdDogcmVuZXNhcyxyem4xLXNqYTEwMDAgIyBSWi9OMQ0KPiA+DQo+ID4g
ICAgcmVnOg0KPiA+ICAgICAgbWF4SXRlbXM6IDENCj4gPiBAQCAtMjMsNiArMjksMTIgQEAgcHJv
cGVydGllczoNCj4gPiAgICBpbnRlcnJ1cHRzOg0KPiA+ICAgICAgbWF4SXRlbXM6IDENCj4gPg0K
PiA+ICsgIGNsb2NrczoNCj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICsgIGNsb2Nr
LW5hbWVzOg0KPiA+ICsgICAgY29uc3Q6IGNhbl9jbGsNCj4gPiArDQo+ID4gICAgcmVnLWlvLXdp
ZHRoOg0KPiA+ICAgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMvdWlu
dDMyDQo+ID4gICAgICBkZXNjcmlwdGlvbjogSS9PIHJlZ2lzdGVyIHdpZHRoIChpbiBieXRlcykg
aW1wbGVtZW50ZWQgYnkgdGhpcw0KPiA+IGRldmljZSBAQCAtOTEsNiArMTAzLDE2IEBAIGFsbE9m
Og0KPiA+ICAgICAgICByZXF1aXJlZDoNCj4gPiAgICAgICAgICAtIHJlZy1pby13aWR0aA0KPiA+
DQo+ID4gKyAgLSBpZjoNCj4gPiArICAgICAgcHJvcGVydGllczoNCj4gPiArICAgICAgICBjb21w
YXRpYmxlOg0KPiA+ICsgICAgICAgICAgY29udGFpbnM6DQo+ID4gKyAgICAgICAgICAgIGNvbnN0
OiByZW5lc2FzLHJ6bjEtc2phMTAwMA0KPiA+ICsgICAgdGhlbjoNCj4gPiArICAgICAgcmVxdWly
ZWQ6DQo+ID4gKyAgICAgICAgLSBjbG9ja3MNCj4gPiArICAgICAgICAtIGNsb2NrLW5hbWVzDQo+
ID4gKw0KPiA+ICB1bmV2YWx1YXRlZFByb3BlcnRpZXM6IGZhbHNlDQo+ID4NCj4gPiAgZXhhbXBs
ZXM6DQo+IA0KPiBDYW4geW91IGFkZCBhbiBleGFtcGxlLCB0b28/DQoNCg0KT0ssIFdpbGwgYWRk
IGluIFYyLg0KDQpDaGVlcnMsDQpCaWp1DQo=
