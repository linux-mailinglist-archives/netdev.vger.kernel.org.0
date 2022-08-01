Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB18C58632E
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 05:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiHAD5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 23:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHAD5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 23:57:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2085.outbound.protection.outlook.com [40.107.22.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2356AC3;
        Sun, 31 Jul 2022 20:56:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwgrjMiNu80oFNCzjGjP3Rrni2qM6rQTeyUNTqBFre9bUL1nQZhBPHevLm37eRn4Qqjgx4ikG2P3r3WiyyUEWUAHYWlnZz7Sc3LZs4G6WlH00o8QtpnQGBpWRs5v9khnDsBYbkUXpix4+Lf+uK/lI2cwXU0i85AOXdw6RtwLvG4QwiyksD8FnL2qRR5b0gPMHdE3Od+26MXuNwXdO3J00HT7CVDKaqQIcrRv93/V+9jIaKEnncOYnCNkDf908b9rIurT5uZeP0GV6aRAHad4o3zxPJvRWs7JUQrayfO5oU5oDCNV3Pm1jXeD3CjggngsgqRXNcb4BnH9AqzuEcZbzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvBy2D5/0oNyO3MgRouCBWRqIHZe2ZkwEwHwTVZpqP8=;
 b=Jd/owcpI6XzaXbVzq7ZKYODSpJHmAV83rmdR+Syy+rLhrYZawL72A8J0L5n1Yy94E7nucaoXvmD7H53xTFTWtS3m4nlV/AQYGG+sRnj68nxwspszzG8L7PE5/Uh6xtcwIhEZONPVAG2xDvoXWqpI3KxlRhbRK4mL0xuzY5cd/Ckd/nUvyIiEOvGCI+mn2LfSlTEIOCjeyYK4pAsxomUWLhlVBwq1LPbk+AeW/TR20EZq/v3K+Rho/Gw2RY0jV61VsNMrmd9T2NhNPs5ZL5fJt3re+KqGg6p6wM5FUlJZAmu187TjoFPEMZgz9mGazdDoBKCFDgaUqdZLz3Pzxlah/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvBy2D5/0oNyO3MgRouCBWRqIHZe2ZkwEwHwTVZpqP8=;
 b=VDLBaomd3ZaLyzeRY53nS+tGSyihxjs6heE/BmTPEBZ8TV3aNk6D4uA/x8DhTgvIwVBXH6QtdUYIJKzXJh8KNCRxAg1LnYb9LXOYGWjNgUkRC1VQoD8G+TZ2+7FTq7BKggYCx2Ia3XCN3I0TXZsrJp4VW6WcGBCJ7EGMfmBLsQ0=
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by VI1PR04MB4880.eurprd04.prod.outlook.com (2603:10a6:803:56::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 03:56:55 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::801b:cede:a6f3:4029]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::801b:cede:a6f3:4029%7]) with mapi id 15.20.5482.011; Mon, 1 Aug 2022
 03:56:49 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [PATCH V4 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Thread-Topic: [PATCH V4 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Thread-Index: AQHYoLtZYMytdFBntU6t4pm4cdkb6q2ZcLkQ
Date:   Mon, 1 Aug 2022 03:56:49 +0000
Message-ID: <AM9PR04MB90036155F00A8C645A27A440889A9@AM9PR04MB9003.eurprd04.prod.outlook.com>
References: <20220726143853.23709-1-wei.fang@nxp.com>
 <20220726143853.23709-4-wei.fang@nxp.com>
In-Reply-To: <20220726143853.23709-4-wei.fang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4b4d59e-06c1-4583-980b-08da7371dcca
x-ms-traffictypediagnostic: VI1PR04MB4880:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yx1vp81iMX3KGMfyPPBBgS6vBgA+X6wvytyvD4hYtR0P5QzrUa2lT5ZWczfcS0FL7o7m6bF2oF2mHoJ6Rd3wkoIC0pWfRDqPHa21g98WlC1zhUCZ/DcMJ03FHEPgjqPg/e1uPFaJwrCaEAGhRZ7BdQ9pV8szMwS3sDrJGtBKiLTKW/O9bYyIxGMj93ffrr9DjYrjYgZBbtjhTkj9WFoNBVUMlnhJSulNe71ERJLccGDnMtpCv45icXCq+5BivwWGJ1cGCbA31Y6H4EX2l2sS+wf8DuRq8HSNXOpGr6ma4qn+EaoAbpq1y9M9r3zTD5NdzNwyK1XRzEzZVvpBV/kUwkThxpAzEfEYmGKQRFRkG6oOx+Giv7V2cML4KuBY2keF1rpcHg6wjwEFVd1xgupDSO0uKiriii8ueRqpUo2tKejFLgKlxeePGD0Nn6HaJMhpwG6IK/4ZcG70iJvsfoTgi8hHigNzbvOGE2ZHr/2J5dBYTEi9wPOSHoUB3ulZNKNs22atjDcDj4h7nwy1b8WIhWUh1R8MXjIHnlF2wx3Jv5YoIEaehKEG5uuS0/i1GsRP+TSRE7C2JED5oziQn9+OvkS0BKxnm3POegkTiB6wzueP4CS2QdwdXwQ4P+XO3TXEkDuhHhF6JheOHsCkpJ3zq9lCKRLjK7eGnAoKwb7NPDYvAPhJAjWiDQl6qRyQLi39L0AVYTSLIOT962/9gleMFWKqYlSG1HoSDPXrG8tMoUUnyCOwgizPhhro1177DYGw48NUcgxoZMrxEwrIQrE8morNOZhlOEVDNkaXZzulwYdYzAlFbZ0ikS7RLVkYYVhA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(9686003)(26005)(6506007)(53546011)(7696005)(186003)(38070700005)(122000001)(38100700002)(64756008)(83380400001)(8936002)(52536014)(44832011)(5660300002)(7416002)(66476007)(66446008)(66556008)(110136005)(4326008)(66946007)(55016003)(2906002)(71200400001)(41300700001)(478600001)(8676002)(76116006)(54906003)(316002)(86362001)(33656002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?VDdicmpzcUpjanV5RnVRUE9QN09iaERkNU1yWTBlUjVESjRVK0dUVmZpWUgz?=
 =?gb2312?B?SjJmT29qc3NrZFd3T3g4RzZlM2JPZTEwTTlkTjJSbFZQME1tVHJWYS9vSzls?=
 =?gb2312?B?ZDNEeGFsUW5pTHVtTlZNQ2JiZTlocVZvL0RUVzd2NzJ5SU9zbUpuamJQUzFH?=
 =?gb2312?B?cndFYkRLS3YwanlUOFdJMC83T2dXangvbWJuSFZXNmtlKzFONjFvOVlXYSty?=
 =?gb2312?B?VWxMbURWcmVMczU0Zi9VWlA4QW9XS0o1aUsrbE04YmlmUXQxVFFmZmd0MjNm?=
 =?gb2312?B?NCtXSUpQbE56ajFLK0U4U214MjgwalYzNE9VR09HRUwrR01aR3Q4TWkrOXZU?=
 =?gb2312?B?aGNIRnIzVEdzT0dPSHhqcjRrY2JGUHIyTnlEdHlGY29ER2ljRmZXWFdjaktZ?=
 =?gb2312?B?TlViQk1kQVQ5eG81TkV5U3JEMTBPRyszSmpLcjJHTjJoYjNLeTB5bS9kVm42?=
 =?gb2312?B?cUViMkNhVnlPS2FtQ0I2YzdJOGkzTGRUbERTZFZhTFN0cEFka0pFUWxkazBX?=
 =?gb2312?B?VzVQNWwxWmVYZmwrK3lmMVN1MGtnR0phYXVwYXlKeVVBTTUvM2hYNGEwZDd0?=
 =?gb2312?B?ZGltTlhlZjdVUTErSXRhaW4rUTR3T3d2ZDhGclN0bVhGT2h2QnhMK3J2dE9I?=
 =?gb2312?B?WThTK1N5Qmg4cHVmM3E2bzY2b0FPcDc1b1QyQ3BQWnI4eEIvTzFCMlRMMVB4?=
 =?gb2312?B?S09vRnVkb1kyakhId1hNRTUrTUpqNmRkc0RsMjJPc005a3E3VDFrNEkvNGVT?=
 =?gb2312?B?eWNvSkxpOGd2eGhNeGZHMkdpSTgwTUVERGRTek9GTWZselJpd24vRFNCODUv?=
 =?gb2312?B?SjlQQU14c2FnenoxWGxFV3M0bC9UWVllZlBDRTluS1EyZ2hEVUVqZVVmNWk2?=
 =?gb2312?B?WW12U09lQjNvNUNSN3dtM0tqeThOajdwR0o5MXg0bUpteXpnOWZHc1pmdnE0?=
 =?gb2312?B?ZnJzOTNjQ0VBUzlGL1ZrNlJUeXJadCtMdzVhbGxwaWNxUjU5eElTVmpvV1R1?=
 =?gb2312?B?NXVnYkhFY2diMTBMU1hLRlZxYTR6eGdEblFpYXkyZXdCZTJwWllaSUJiSlpF?=
 =?gb2312?B?Wnh0eXI5M1RCVkZuUzlWWWdOUjNRU0pPRll4RnVVSGdsc0VlT1JpeTA2cFhS?=
 =?gb2312?B?TU1xbHRBeHgyRnovNFYxVVRtejBaTS83ZDFReFFnVGhwcVFyV012bzAvVnBI?=
 =?gb2312?B?R1ZqRGo0Nm55aW40Y2hnNnptYmVmYnBMbmd4R2xiNTdrVS9UV1d5T0xrYSsr?=
 =?gb2312?B?T3JqUGxYZDlwYjM2WmhVd1d3VG4xeUo4ZnRBM1Y3cHN3QVBoT0NGT0lyUWJy?=
 =?gb2312?B?b3MvaTJuMittT1RLVmd3RGNJYkUxWTFCYlRGNUNwMGRhcWM2ZlVpc1pFVWZE?=
 =?gb2312?B?ZDFmcldUcG9XTTlETDVZNUZmdjQ0bWYrMi91LzVSai9LYnI1NWZlTWlqQk9w?=
 =?gb2312?B?ZkJXWG5Eb0tpajBZWnZYS3RJMnFSTWozUlZxUVFHUmVMSDZVQ2x1a3Rub01C?=
 =?gb2312?B?NGFLTGRSZ1psOXJUZWs1cU0rai9nYVNLTHYxWHlvcG5oQWZRNkRkNHJCSlM3?=
 =?gb2312?B?K3o4T2lIZjdXOEtrcHhENDlEOUs4VEIyMWFKY1RESGVPK2tqM3JVWWtpWE5v?=
 =?gb2312?B?NitGU1BDK0RSOTRlTC9WUGZCNFFrdlBtNXFvZk5wVWliWDNGYnVIRTNmeHFW?=
 =?gb2312?B?RFBXZjRHeDQyQk5GcVhMNXd3eTcvOGg3TmpQdzZyMTFIZlV0WkFVQXVIRjNi?=
 =?gb2312?B?UXczSWNyTmlhK25kNzVLRXdaOW5rUXBieVJIQ096R3AyUzlqY1o4V1k5Z3c0?=
 =?gb2312?B?c2ZuUzV1ZEl2YXE4QmxxWWZVRnpRSTJWem01bUdORjlxVlVldzlFVU0xTWkv?=
 =?gb2312?B?cVZuSGlXWGdwNk84WkNMR3VZMVZHT0swcWNQbEdLMTRJeWVxVUMxN2o4U3BN?=
 =?gb2312?B?aElGR0RwbHkzdG9rTHlDSjJHSURqQWJqcVFxam52Z0dHN25RclNJeU11dHRO?=
 =?gb2312?B?NFVxVzA0Tmpzc2U5N0Y5QkFEa2h1NEZxUWI3S0JUMy9nMCtkOGJtNmExQldM?=
 =?gb2312?B?UHR5YWxwSmZvcURmWW9qQ1dTeDNyNkdpMkdKY25nUFpJN2IzOG13bkQvZWQv?=
 =?gb2312?Q?iVNA=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b4d59e-06c1-4583-980b-08da7371dcca
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 03:56:49.8485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KYbeYrVzqn7SKO9f6KrGCjbdvtIhMdlGebHG42WNufUSCwFu0EPMVmRyIc3R9o2YCf9UYldBNdUyPSFbDbLfjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkNCglLaW5kbHkgUGluZy4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBXZWkgRmFuZw0KPiBTZW50OiAyMDIyxOo31MIyNsjVIDE0OjQ2DQo+IFRvOiBkYXZlbUBkYXZl
bWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVu
aUByZWRoYXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7IGtyenlzenRvZi5rb3psb3dza2krZHRA
bGluYXJvLm9yZzsNCj4gc2hhd25ndW9Aa2VybmVsLm9yZzsgcy5oYXVlckBwZW5ndXRyb25peC5k
ZQ0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGtlcm5lbEBwZW5ndXRyb25peC5k
ZTsgZmVzdGV2YW1AZ21haWwuY29tOw0KPiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29t
PjsgUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+OyBKYWNreSBCYWkNCj4gPHBpbmcuYmFpQG54
cC5jb20+OyBzdWRlZXAuaG9sbGFAYXJtLmNvbTsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnOyBBaXNoZW5nIERvbmcgPGFpc2hlbmcuZG9uZ0BueHAuY29tPg0KPiBTdWJq
ZWN0OiBbUEFUQ0ggVjQgMy8zXSBhcm02NDogZHRzOiBpbXg4dWxwLWV2azogQWRkIHRoZSBmZWMg
c3VwcG9ydA0KPiANCj4gRnJvbTogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IA0KPiBF
bmFibGUgdGhlIGZlYyBvbiBpLk1YOFVMUCBFVksgYm9hcmQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gLS0tDQo+IFYyIGNoYW5nZToNCj4gQWRk
IGNsb2NrX2V4dF9ybWlpIGFuZCBjbG9ja19leHRfdHMuIFRoZXkgYXJlIGJvdGggcmVsYXRlZCB0
byBFVksgYm9hcmQuDQo+IFYzIGNoYW5nZToNCj4gTm8gY2hhbmdlLg0KPiBWNCBjaGFuZ2U6DQo+
IEFkZCBldGhlcm5ldC1waHkgYWRkcmVzcyAiQDEiLg0KPiAtLS0NCj4gIGFyY2gvYXJtNjQvYm9v
dC9kdHMvZnJlZXNjYWxlL2lteDh1bHAtZXZrLmR0cyB8IDU3DQo+ICsrKysrKysrKysrKysrKysr
KysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA1NyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHVscC1ldmsuZHRzDQo+IGIvYXJj
aC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHVscC1ldmsuZHRzDQo+IGluZGV4IDMzZTg0
YzRlOWVkOC4uZjFjNmQ5MzNhMTdjIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybTY0L2Jvb3QvZHRz
L2ZyZWVzY2FsZS9pbXg4dWxwLWV2ay5kdHMNCj4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9m
cmVlc2NhbGUvaW14OHVscC1ldmsuZHRzDQo+IEBAIC0xOSw2ICsxOSwyMSBAQCBtZW1vcnlAODAw
MDAwMDAgew0KPiAgCQlkZXZpY2VfdHlwZSA9ICJtZW1vcnkiOw0KPiAgCQlyZWcgPSA8MHgwIDB4
ODAwMDAwMDAgMCAweDgwMDAwMDAwPjsNCj4gIAl9Ow0KPiArDQo+ICsJY2xvY2tfZXh0X3JtaWk6
IGNsb2NrLWV4dC1ybWlpIHsNCj4gKwkJY29tcGF0aWJsZSA9ICJmaXhlZC1jbG9jayI7DQo+ICsJ
CWNsb2NrLWZyZXF1ZW5jeSA9IDw1MDAwMDAwMD47DQo+ICsJCWNsb2NrLW91dHB1dC1uYW1lcyA9
ICJleHRfcm1paV9jbGsiOw0KPiArCQkjY2xvY2stY2VsbHMgPSA8MD47DQo+ICsJfTsNCj4gKw0K
PiArCWNsb2NrX2V4dF90czogY2xvY2stZXh0LXRzIHsNCj4gKwkJY29tcGF0aWJsZSA9ICJmaXhl
ZC1jbG9jayI7DQo+ICsJCS8qIEV4dGVybmFsIHRzIGNsb2NrIGlzIDUwTUhaIGZyb20gUEhZIG9u
IEVWSyBib2FyZC4gKi8NCj4gKwkJY2xvY2stZnJlcXVlbmN5ID0gPDUwMDAwMDAwPjsNCj4gKwkJ
Y2xvY2stb3V0cHV0LW5hbWVzID0gImV4dF90c19jbGsiOw0KPiArCQkjY2xvY2stY2VsbHMgPSA8
MD47DQo+ICsJfTsNCj4gIH07DQo+IA0KPiAgJmxwdWFydDUgew0KPiBAQCAtMzgsNyArNTMsNDkg
QEAgJnVzZGhjMCB7DQo+ICAJc3RhdHVzID0gIm9rYXkiOw0KPiAgfTsNCj4gDQo+ICsmZmVjIHsN
Cj4gKwlwaW5jdHJsLW5hbWVzID0gImRlZmF1bHQiLCAic2xlZXAiOw0KPiArCXBpbmN0cmwtMCA9
IDwmcGluY3RybF9lbmV0PjsNCj4gKwlwaW5jdHJsLTEgPSA8JnBpbmN0cmxfZW5ldD47DQo+ICsJ
Y2xvY2tzID0gPCZjZ2MxIElNWDhVTFBfQ0xLX1hCQVJfRElWQlVTPiwNCj4gKwkJIDwmcGNjNCBJ
TVg4VUxQX0NMS19FTkVUPiwNCj4gKwkJIDwmY2djMSBJTVg4VUxQX0NMS19FTkVUX1RTX1NFTD4s
DQo+ICsJCSA8JmNsb2NrX2V4dF9ybWlpPjsNCj4gKwljbG9jay1uYW1lcyA9ICJpcGciLCAiYWhi
IiwgInB0cCIsICJlbmV0X2Nsa19yZWYiOw0KPiArCWFzc2lnbmVkLWNsb2NrcyA9IDwmY2djMSBJ
TVg4VUxQX0NMS19FTkVUX1RTX1NFTD47DQo+ICsJYXNzaWduZWQtY2xvY2stcGFyZW50cyA9IDwm
Y2xvY2tfZXh0X3RzPjsNCj4gKwlwaHktbW9kZSA9ICJybWlpIjsNCj4gKwlwaHktaGFuZGxlID0g
PCZldGhwaHk+Ow0KPiArCXN0YXR1cyA9ICJva2F5IjsNCj4gKw0KPiArCW1kaW8gew0KPiArCQkj
YWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gKwkJI3NpemUtY2VsbHMgPSA8MD47DQo+ICsNCj4gKwkJ
ZXRocGh5OiBldGhlcm5ldC1waHlAMSB7DQo+ICsJCQlyZWcgPSA8MT47DQo+ICsJCQltaWNyZWws
bGVkLW1vZGUgPSA8MT47DQo+ICsJCX07DQo+ICsJfTsNCj4gK307DQo+ICsNCj4gICZpb211eGMx
IHsNCj4gKwlwaW5jdHJsX2VuZXQ6IGVuZXRncnAgew0KPiArCQlmc2wscGlucyA9IDwNCj4gKwkJ
CU1YOFVMUF9QQURfUFRFMTVfX0VORVQwX01EQyAgICAgMHg0Mw0KPiArCQkJTVg4VUxQX1BBRF9Q
VEUxNF9fRU5FVDBfTURJTyAgICAweDQzDQo+ICsJCQlNWDhVTFBfUEFEX1BURTE3X19FTkVUMF9S
WEVSICAgIDB4NDMNCj4gKwkJCU1YOFVMUF9QQURfUFRFMThfX0VORVQwX0NSU19EViAgMHg0Mw0K
PiArCQkJTVg4VUxQX1BBRF9QVEYxX19FTkVUMF9SWEQwICAgICAweDQzDQo+ICsJCQlNWDhVTFBf
UEFEX1BURTIwX19FTkVUMF9SWEQxICAgIDB4NDMNCj4gKwkJCU1YOFVMUF9QQURfUFRFMTZfX0VO
RVQwX1RYRU4gICAgMHg0Mw0KPiArCQkJTVg4VUxQX1BBRF9QVEUyM19fRU5FVDBfVFhEMCAgICAw
eDQzDQo+ICsJCQlNWDhVTFBfUEFEX1BURTIyX19FTkVUMF9UWEQxICAgIDB4NDMNCj4gKwkJCU1Y
OFVMUF9QQURfUFRFMTlfX0VORVQwX1JFRkNMSyAgMHg0Mw0KPiArCQkJTVg4VUxQX1BBRF9QVEYx
MF9fRU5FVDBfMTU4OF9DTEtJTiAweDQzDQo+ICsJCT47DQo+ICsJfTsNCj4gKw0KPiAgCXBpbmN0
cmxfbHB1YXJ0NTogbHB1YXJ0NWdycCB7DQo+ICAJCWZzbCxwaW5zID0gPA0KPiAgCQkJTVg4VUxQ
X1BBRF9QVEYxNF9fTFBVQVJUNV9UWAkweDMNCj4gLS0NCj4gMi4yNS4xDQoNCg==
