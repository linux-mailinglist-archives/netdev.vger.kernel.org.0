Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD50E5741A2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiGNC5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGNC5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:57:43 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60085.outbound.protection.outlook.com [40.107.6.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB87424BE0;
        Wed, 13 Jul 2022 19:57:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0jgx39mlfuBQ32ZJf6aeYWVHeAbsLy/v4bZsJsPGxdfstlQH4+0OhJmTDg7nQRmvrluWML5V1d7ZNaOI9aDXynriJ9lkG78YeyU6J/bwIFlCyIjS6sEhhTkXYnCftcMQBdcRQsAtSriXVKBfuipCtqYDtTvwH1ar0D2kIsbn3TJsqFik8BJgSxcBd8gmyRiVToWlXei1HnuQA9oIhpD0l94lQV3wfAnOcz8FXB96Fy0QsLmQ8lFs6CQ9jEMdfusIqgLBJitXRMtGU+RW1iGbCkTy+4wRC8QhbNbBio+9C+1jw8z27nG0sIE5WQtR+KET2mZcGBchoGR0d/cVFPxsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWAuJdMwd/0b247EFNscttixFvDhBJ2ZRIp5ebvvmB8=;
 b=KrxDdAKFN+PAETcqVco+TLq3tneKUUpA1oXYLBqyhHTYmV4Y5CE/nA1+XxTsf8dzFc0QmxtNAI/wUkZdVRW4vwo1mO5SAzPVDPPRuhQgX+zk29BCQbTCC6NWg6PZXdGNsh+/YPWuIFUyaf2PYLKikUzVVkUYw2OgVxa9QrMTT6uYaGZhJL4nGd6+s8bjC8lNLWjif0Bb/EWrenZYPwTZY7EQg6MrHpYcplMg0BEDzf3lfWBCriVecqQ0S6nq+zyZIvFLGNuaENZdwf2MeGcCT1ViuPJf5R8MwLcWp95kZg/TqfSVhhEnXh0Dn3vQi0n6aCyb0A89WsE33eYCM9QomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWAuJdMwd/0b247EFNscttixFvDhBJ2ZRIp5ebvvmB8=;
 b=OkA+GRVeukar4vNVFYoEvVn9bcoPs1Eh2K46cUC/w9h9Kxrb/3WSmvGC598OK/Fgg1RQ7VMYowL4FQWMplb2iftfCRTOh4FWpQ+/fEM6To7gcGCT6+1WFXSctIHX3eqcZpoqvOSUW8yT2+JJazkjGIMjYD4UgfRyeLBEeVKGMRs=
Received: from DU2PR04MB9000.eurprd04.prod.outlook.com (2603:10a6:10:2e3::19)
 by DB6PR04MB3189.eurprd04.prod.outlook.com (2603:10a6:6:3::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.14; Thu, 14 Jul 2022 02:57:39 +0000
Received: from DU2PR04MB9000.eurprd04.prod.outlook.com
 ([fe80::98c:9da9:bc3a:21a0]) by DU2PR04MB9000.eurprd04.prod.outlook.com
 ([fe80::98c:9da9:bc3a:21a0%3]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 02:57:39 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: RE: [EXT] Re: [PATCH V2 0/3] Add the fec node on i.MX8ULP platform
Thread-Topic: [EXT] Re: [PATCH V2 0/3] Add the fec node on i.MX8ULP platform
Thread-Index: AQHYlMh4J2AekUWmXEqFZvpGw88fa619LmiAgAABirA=
Date:   Thu, 14 Jul 2022 02:57:39 +0000
Message-ID: <DU2PR04MB9000C6370B519A5E00B427E688889@DU2PR04MB9000.eurprd04.prod.outlook.com>
References: <20220711094434.369377-1-wei.fang@nxp.com>
 <20220713194659.45e410d2@kernel.org>
In-Reply-To: <20220713194659.45e410d2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 528bdb6e-efec-41fa-31c1-08da65449cf9
x-ms-traffictypediagnostic: DB6PR04MB3189:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QZYBfPfltwjQ/SeKoD4nOGx0tGNMaa2FkSPwgJODWiU7ypxm4k9jXZX2DWMJ19XP1mZ4pugtBjp27BJsH4vteyplWL4RrOOcRl+7eapWzBLM7UTzql1sTBHVlfvUXmaAvPl7iI1sq+mQtqrY5+iIeZgk+HRRMqAYB0UzTvQk0OFz2aQk/CknAeDLInlg9q2PtSsXwiqWhtoC0nLfIbammGHePXAzKglpyYq9r0TXuSi12pUhRKnLzsCgoFdNemk5PbsqnU9GRWCkNeFOLJErUcKKXjw8nVaBru4yoEYIP72y2nqQdQ+tklZWHq9BI4ve1G6/XNL4/IXZBlFCTuR51aolpznupVLaoXT4d1shqh/oXHJtTejjUr88dPYoGS63xgoHgvN9sxkoJwiu57CMpNKFuTqtjd6gOI5jVlEUSiepWAyooYi1/ifvlkyfQkAiUolFfGVyHhwg1lmWbUo2mjO6JR8W/NvrVaMZXfclFrmeZcFwIbEhl8eOol4XOZTjNQPrJMhwJjJxaaGcQMoJpga2rxpWD62nYQGYp7Fr3jE6mxmA6N7j0q8LN+EVRwBCQ7+yL1x7b6YnNwcPi2JqjRub5Nq6FkiFvF3MwlRSq0hGMJ1O0D4fsOD3OW+2KeAlC9rGmQ1w0TIZZ9Tp+uHkCcB5Vl59tEEwtB6IlBjuzzspnLoc0bsDMVbxI+SSLrkLKuWf8UG+HQKnUxtqbExjmY7ugwKgGGKwlieW7ucZO4IfIaYCFPzyvdIDF6Atsu012Rlf5iTrVSXCGMmVsY1PCczyyZWNg7Vo+PwGuKEDiUbakbq/yip9lRJH5f5Mnhgy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB9000.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(6506007)(7696005)(38100700002)(41300700001)(2906002)(8676002)(122000001)(6916009)(54906003)(478600001)(53546011)(4326008)(66476007)(8936002)(66556008)(66946007)(64756008)(66446008)(71200400001)(83380400001)(5660300002)(76116006)(9686003)(52536014)(44832011)(7416002)(26005)(55016003)(86362001)(186003)(33656002)(316002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Szg4YjllL0UvQ0Z2bHlOZmYwR2JpcmVMdXAzVWpOa1ExS09JVWhBOEtDTXFG?=
 =?gb2312?B?TGFwM2hNY1d1bkpsZ2txTWVyNVl0L1VGeVNuSjdITmpXRVFvSnFpQ3RkdXFJ?=
 =?gb2312?B?UGUyRUg3bDFzc0xtZmV4VDdQN2pEZ2ZDL0Z5OUdKTjRjeVIrQWxMYmhnTUhC?=
 =?gb2312?B?QWluaGNJOEFTR2RhVDQ0ZzJnMk5GUU1TNG1hWUsyT3pmbkxxc3RFVTBGTnhQ?=
 =?gb2312?B?V0prbXJBNWdDWWUvL0RsN0RybGxxcVJyZTAwU04xUk9YQ2JVY0dnQTNTelhq?=
 =?gb2312?B?RnpKa0JjRzdTUFNRcERKajNUWE41UzVlc01OMkxnRFYrc0RnQnBCMnNSQllD?=
 =?gb2312?B?cnJoQjEzeXkrTmRld2RzZW1DeDluR0ozVnpOazVxSUhNOHMzS0pUeHVKcWVK?=
 =?gb2312?B?MHFCcEVITEN3SVVRaXNLbHZHN0pxWWZBNHBzNWZCZ1NVNW9wSlZSeW9tRkFa?=
 =?gb2312?B?bStleHZwaytUVUN1REM5dys4S1lQOEZORWdVdXZTZ3pMelFDTTYxa2pmZTNC?=
 =?gb2312?B?R1dwRU1KTmVtSTBlcjQyR3hnaFY4RzhubXB5dkx4UGhLUG5iN3c2N1luTmRY?=
 =?gb2312?B?UzRsRlRwZmEyekdaNk5jRU5wRXdDMVRuSDgxNkg5UlFoNFM2NDJuc280akFm?=
 =?gb2312?B?Ym9PeWJFVzI5ZWRFTmpFMFhGRHQ3Y3JqYTRVZ0VZdk54VUVaVmw5OFFsUWU4?=
 =?gb2312?B?RkgzdUNPSXJ2ZE5qTlEzWlhmci93WEtYMGhacURkN3h4eWNkb1ZKejFzcmVi?=
 =?gb2312?B?NFc4TmJJMkZUN1c4eCtyaVhFR2t2Y3VaWDlPQmRCTXk0eHFUeEM1YlVySitJ?=
 =?gb2312?B?OFdYSHBMVHB4bEpEWUUzVEZVS1RpSXBUV1JleFBrN05Nd3o0YUV1UDZoLzhx?=
 =?gb2312?B?R1U1THBOS1pGWHhWai90TG9DcVUzbmJ0eWtuOC9UUTQvR3gyN2YyMDBBcU80?=
 =?gb2312?B?amE1ZnhoaUtnbkgwRmU3NGh1Q2d0TGs5dDFxSE9Qa09mRG9UVzNOQW1EM2Ru?=
 =?gb2312?B?Tm05dkhENXVyWDNibW14TU9DelIrY3dhaGdWL0lYTXVKMlhDYTBNNGNJUTdO?=
 =?gb2312?B?WG1hT0ZNdWFpTVIySSs3bWRPbjNEajhQK21lb3cvTzJFTGhqZC9tbHNFcXdl?=
 =?gb2312?B?RE5GVGRpVnJ1WFZyakFvMEMzMVNOaHVlRG5vREJERWp2YnkvdmN3OFRCRU5u?=
 =?gb2312?B?VVNzeS9tWlRYYmxOSEdYcGxBcjhWYmRoVkNFY256U01NZjB4dG42b0R3TWdB?=
 =?gb2312?B?emdXWVBKZDhDTFlvb1AxTkhXamhpUXNWbUZEa0FFc0JRMFU0OWpBS1Y1MmlR?=
 =?gb2312?B?VzM4Nk93djZzdVBkMzA2ODIybk85elJsWUVNSjZnZUZFZVhmaFQ3MEttOStv?=
 =?gb2312?B?RjhsNHREV2lVcHZURFJyNTRnQzFpbjhJNUcybmVPYjlmMWladHFGM0hmc3pT?=
 =?gb2312?B?MjBjVzNTVnNOSGtJWFNTTXl2YWVyenNqdy93SWVLaGZHUmF3Vnp6SW5FUkVC?=
 =?gb2312?B?V244Vk5IVjFpdWdrZGtZeFdDWUt5NXVDU29DVjdyYjZJQWNGb2dLNm1WT3FE?=
 =?gb2312?B?Q1NISWxhbloybWxNMFZNZCsweUI4TmJZZTFvY0czVUtpcHhOOTlhWlFhY3dM?=
 =?gb2312?B?WkcrOE9zbng1SVhQZUN1cnRaZ1VheEtlR1R2NXE5aEhGdWlyVFB5QlZuQmh1?=
 =?gb2312?B?YWhyZ0lteG04RWFLenhHTGMyZUNONEFoNDZ4K2xVNU9xeUNrblEzOUtCZitM?=
 =?gb2312?B?MFJyRjc2SFU2Mml5dW8wd0lQcU1UekJpWVQrcWpTc1BxVlhEWFpMdHdieVlu?=
 =?gb2312?B?Mzc0TmtqSzNJcjYxTHc0ZFNPRUxabWIrdmNONmN3MkFlMit2RmxTNW9kODBG?=
 =?gb2312?B?WkdnN21GbTl2THUvUENWQVpCZlFoSzMydEFwcTNIK3N4SVdsSDVVSW9xWWtu?=
 =?gb2312?B?c2svZ2N0aldnR2xSSDFoS25SL0tMUWlwaWtXL0VueEI1Szh6akFUQzNNZVF1?=
 =?gb2312?B?VHE3MDFvYVBEazZNSmIvUjdXbGJsTDlWb0d0TmthT2Q4cVB5eDhzSTl4anZ5?=
 =?gb2312?B?eWNSOHNhQklHNzJwRG9FL2ZEdk1YT1NGZ1pQWjJrQzBhZ3ZZRmlQenpzYkJu?=
 =?gb2312?Q?pdEs=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB9000.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528bdb6e-efec-41fa-31c1-08da65449cf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 02:57:39.1480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F8H/oEQ6/YFgRWmeM7rESK0CZuSaH3ZAkVSr5Q93FXeNZPH1hrD+YwyUdV2M+SmHCFX9i5+cEmdS2fSN5RfTVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMsTqN9TCMTTI1SAxMDo0Nw0KPiBUbzogV2Vp
IEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVt
YXpldEBnb29nbGUuY29tOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gcm9iaCtkdEBrZXJuZWwub3Jn
OyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7DQo+IHNoYXduZ3VvQGtlcm5lbC5v
cmc7IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRl
dmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0K
PiBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGZlc3RldmFtQGdtYWlsLmNvbTsgZGwtbGludXgtaW14
DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47IFBlbmcgRmFuIDxwZW5nLmZhbkBueHAuY29tPjsgSmFj
a3kgQmFpDQo+IDxwaW5nLmJhaUBueHAuY29tPjsgc3VkZWVwLmhvbGxhQGFybS5jb207DQo+IGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgQWlzaGVuZyBEb25nIDxhaXNoZW5n
LmRvbmdAbnhwLmNvbT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQQVRDSCBWMiAwLzNdIEFkZCB0
aGUgZmVjIG5vZGUgb24gaS5NWDhVTFAgcGxhdGZvcm0NCj4gDQo+IENhdXRpb246IEVYVCBFbWFp
bA0KPiANCj4gT24gTW9uLCAxMSBKdWwgMjAyMiAxOTo0NDozMSArMTAwMCBXZWkgRmFuZyB3cm90
ZToNCj4gPiBBZGQgdGhlIGZlYyBub2RlIG9uIGkuTVg4VUxQIHBsYXRmcm9tcy4NCj4gPiBBbmQg
ZW5hYmxlIHRoZSBmZWMgc3VwcG9ydCBvbiBpLk1YOFVMUCBFVksgYm9hcmRzLg0KPiANCj4gU29t
ZXRoaW5nIG9kZCBoYXBwZW5lZCB0byB0aGlzIHBvc3RpbmcsIHRoZXJlIGFyZSBtdWx0aXBsZSBl
bWFpbHMgd2l0aCB0aGUNCj4gc2FtZSBNZXNzYWdlLUlELiBDb3VsZCB5b3UgcGxlYXNlIGNvbGxl
Y3QgdGhlIGFja3MgYW5kIHBvc3QgYSBjbGVhbiB2Mz8gSWYgdGhlDQo+IGludGVudGlvbiBpcyBm
b3IgdGhlIHBhdGNoZXMgdG8gZ28gdmlhIHRoZSBuZXR3b3JraW5nIHRyZWUgcGxlYXNlIHJlcG9z
dCB0aGVtDQo+IHdpdGggdGhlIHRyZWUgbmFtZSBpbiB0aGUgc3ViamVjdCB0YWcgaS5lLiBbUEFU
Q0ggbmV0LW5leHRdDQoNCk9rLCBJJ2xsIHJlcG9zdCB0aGUgcGF0Y2hlcy4gVGhhbmsgeW91Lg0K
