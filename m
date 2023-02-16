Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3421569949B
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjBPMnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBPMnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:43:13 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BFA1353E;
        Thu, 16 Feb 2023 04:43:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bN2JX4MDwa8qoMsabzrkNsybBLTXcB5RiqBOO3jglgiodWB/J7zNSD3ok/Z/HtD98tRne8ol+Ro5uIANbliDqmkberd6cQPFTBLr1dOEwZBqbfZqak4NKuhiyFngZ7U34zF1F6L4tKn9wjgMRydc6Ie3iErKGYfaGNjP1pJG1A+/POzKBRXAylcLnd0Dl0AqipzNB+IVtfaLmi7oabb8pWRYxEsKnzT6COWmbCQA9ktk9Uq5LeA/Sk3d78Jz2CNepTWVfMj9DIUKwpiGohozB2s6MOnmnXtXDBuEa2qJ4qysovFV5krtYhakhfP0zsfoHiVMb9hKfJWy00lkx33nWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUV/5OHVi4dyJ3PJ1TUxjMqVAWZ+dYqGHfv76GiHrQI=;
 b=bf+QXN+7DSOtgRDrTGXHvooVatG27gg6bCjnLp9gWrqOW7anY18YQGA5JBTsgKJvrx+TbE0jn8idfBZLgHE/32Lf7XGlMtPp6cyERbXctZZg7subnCuUV8M99QELI5l4uKZY8iSXFJCWWqvmorZQ/B4HCXWIlkT0Am+dI1YGVEbQyw/eEGJ+A9DfBAXRXoIP7MFHO7oBfhd/HqIoSQqW6hRGuXZU1GUbCS56A9nXGGYSQqub00XH4HuyUnZkaoFyTcWa7VdTODL5g3h0i47LhMPR/m57CLD4msteUAgz83wbXsEWMX/5PxT9K7pud38KtfAM4Z3DBGRyIoFkQkeL4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUV/5OHVi4dyJ3PJ1TUxjMqVAWZ+dYqGHfv76GiHrQI=;
 b=h7xqcJMsJp9cLkTRQ6gm/g7uHPKtjnBMoPjlN0slHQsUKU62mcj+bKX29KME2ePOSQjhSIJr4yKl14iXGJB7oWGXwl4uRPIq/F98uwxz4Ctd8ANNO+GgVJ74dLBJqloLtWgZoO6q5IAG79VXm9ti+WGLWaCJ4ld6RoYTESK1RDc=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB7088.eurprd04.prod.outlook.com (2603:10a6:800:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 12:43:05 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 12:43:05 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Index: AQHZP44WIaasQ+1ZZ0O2FaaW5aXAcK7NCrmAgAAEr4CAABcEgIAABoCAgAEHe7CAAE3BgIAC96rQ
Date:   Thu, 16 Feb 2023 12:43:05 +0000
Message-ID: <DB9PR04MB810629C2CEB106787D6A2B8C88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com> <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com> <Y+p8WZCPKhp4/RIH@lunn.ch>
 <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Y+uamTHJSaNHvTbU@lunn.ch>
In-Reply-To: <Y+uamTHJSaNHvTbU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|VI1PR04MB7088:EE_
x-ms-office365-filtering-correlation-id: d4931de5-50f2-4b5c-8c43-08db101b5958
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1GzSqag2TuBSvceG2E9pQlNB8pAtpF38I/0HMzNoPWL7SanM0QermjzzTtelZ5wPrqxvLfhiCQJhxP1Yerz9Y5jaEkVvU3CYeiRyMmKlWcnFqtOEtb5aUY7M5QdMs7NEeC4O1bphkC/lts4GWfsYRxutGPkUWcGLNmuJpvo3bFCAMzmSRKV2yY8AXLJq82letjim2rikrf6xS9mBKvPIJFGpMgt4ClfFEFBD9vCr4hcDmH+or+HYMhyUPod8KfBMtyfdoh0UgIRGqfAEo/+zrwELKT7sq0f5hUAXV5NCnRBqafMkHj7mcOCcRRwSzRudawjPEY3U0gCVg6cmhEVlNqPxlm6+957Zut43KZsgi2CAou37YBzI0a2C9M+AIuvLTkTTgLARfNgmzSCdlFToB66uoXVnYoV6Fv0/xQxWUxaf6Y/D7wwK0ekT5JqFOpnLKEHGaf1/0L4fCh8hE8KoG632KNRzLM9/E6nmBSgObiTZwQ6qgfGVpOMr4C+CpaVQFBiub898Vd3tC4F/z9+o7BpVwKkV/Z6r4TCAFRQ/3zDU4tJbuyJhEFZVxnB1yyykv2mqP9UzJixKe+ftdGQQgC/C+ffcWfAFgq3Uup5EOwrWG6Jk1q7gp/0VI0jynkTcrH7dvr+yv/bddzMTN920HqS6WAQGc60zNdJwKaCSQg1h671weTEbcGb6WsHYfIrX6hE9lamI66UA5n1tP/vZqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199018)(52536014)(8936002)(66556008)(6916009)(66476007)(4326008)(2906002)(76116006)(8676002)(64756008)(66946007)(66446008)(5660300002)(316002)(41300700001)(44832011)(54906003)(55016003)(9686003)(71200400001)(7696005)(478600001)(6506007)(53546011)(186003)(26005)(83380400001)(86362001)(33656002)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bVVtajlnQlR5Q0NRcStucytOV1RQVDRRL2FmSC9Sc1pXTUQ3Yk5hOEtGVUtW?=
 =?gb2312?B?ZnBicCtBa3ZtZWhST2pDRS9JSFJCdTZJTm1nU25adHVSZWRxRm1LRTlqV1R2?=
 =?gb2312?B?NHBXT0NQNFV4YlZKdkxTQjBuaXNGRWV6WE9BYitnR01xeG1ZVEZRbXB3VU9k?=
 =?gb2312?B?cXVIakh0TkJmaTN6K2hTL3E5Q0lBcHkyNVExdGdaZWJWVmFZOExRZFFsRFU4?=
 =?gb2312?B?VnRBYVp3M1BjTjI3bDFlN1k5Sm53RzF4Z3AxRTFpN25WSFNkOE9Fb1gwVGNz?=
 =?gb2312?B?T01VVlV6RWdCU2FCTzhjdDNCUE9DUnJVQktkNitySjhBa2kydkZtckhGM2lT?=
 =?gb2312?B?enpXUUQvYjJUUTlMOXgzallvRFBsQ2toc08zeG9GeFVJendtWFBDM3c1Nkhz?=
 =?gb2312?B?SHg0Y1cvMFBSTEQweWhpSDJScEh3RmZDYnB5Yi9SU0ZFekV2a0d5NUtzMFdX?=
 =?gb2312?B?TExJWFgxUGFaZUxqTEZSbmdsakI0UFVuMFJUSVdCMUdjRjYwbDFqVkltM2hB?=
 =?gb2312?B?MmVHL1g4Yzc4TlFLdVd0bHk4VEd3U3BYQUlnQW1Ob1VJZWpuRUxXS3BrK08z?=
 =?gb2312?B?T2RtaWtLeWJaSXpEWFpTczM5KzJEUmpDZEVTZDhLQnFPTENvY2F2VGhEay9X?=
 =?gb2312?B?VUdCZUk5UG9SRjFOVFdwRTgzVTFhNWRzT2ZOcGU3S2tHVmdDS3o2Zlp3MEwy?=
 =?gb2312?B?Z2RUbnBiWFlFeVgyemJZWXJsMkJndXJLVXVRT2oybXBZR2J6MERFUTU1MHVC?=
 =?gb2312?B?d1ZXWnNXUWQ3V3psbmpXYWhCSC81TzFLSElJTUZBUFliNEsrV1BvcDBlTGxX?=
 =?gb2312?B?U3RkTnpzZTd5MCtCRXZpTGthMTlocEdCZlVLWEpySm5qKzNLejkxTGt3OHFI?=
 =?gb2312?B?QndETCtjdG1PbWRSVXFZcUY1dDBMLzR2VUJQWjFJWTN6R1VOMFBPRkVOenIz?=
 =?gb2312?B?UFkzczN0c1Q5aDlBVnZQaEZHK1MrbzBWZzJjS2N2bVRGc0ZpWk5yT1pyUlFj?=
 =?gb2312?B?TklUaXNuVnNVaHI1UTZkQnJ0SDRDWEc1M1U2R2hud2s5WE1RVEM1cS9xZUNV?=
 =?gb2312?B?LytIeEJKM1dwZm5GNVQ1ZVVLUzF0MmpGVTFpNmo3YjJ0ZFNmK1UxMnpIN0lm?=
 =?gb2312?B?Ky9wV0lkZjFkMk94QktVTkJsZktubVVzUkJSRTVZTktIKzBQbHE0YkxOdXlC?=
 =?gb2312?B?U2p4VGdNYzFHVUkrK1FzV3VjamlmNmZ5SWxpYmJJNFpwbUw1UmtVM3krekZm?=
 =?gb2312?B?SXBOdnNvNFY5b3dVcUFJdUo2N0Y1ZDdmYTQ4SFU0MjZhUE5MeE5uZTVORkU3?=
 =?gb2312?B?T1MzeUJZZlRPcDdIRXFyK1pMdkFyalY2YkIwVFY5dHBxdHJ2N3F4QlFmV1c0?=
 =?gb2312?B?WlFMaUtiWmM2ZVU0UkI3QUplSkkzRXJJdnA2eFIzRGE0akorSGxrSlhGdWQ1?=
 =?gb2312?B?RG1LYzdGdnhNc05WbjhrNXl0TENXbjhyV2p2cVUweXJoVlNKS3E3WU5IZ0gw?=
 =?gb2312?B?bWhhdVJSbkdyMERLSVBOSDdnSkprd0RNUFRDZFFOWVNNNmtUWWs3SGNGSUZn?=
 =?gb2312?B?MmwrbHphYzF6ekNHUVNNYmd1MFg0Yk9CNy9FZmZGdnRnd1pGd3BMaVBoODZB?=
 =?gb2312?B?Uld1L0RJZVlPZGV0bjRreHdoNkZSR21SUXdhK1NMdEJCYXJFSkVNZ3hOMnRB?=
 =?gb2312?B?Mm9wN3FoVCt1RW53Umt6L3dGTFJBUGc0emZmYmdpS01CeUl5MDJYTkN1eUc5?=
 =?gb2312?B?TSsrMlNPc09HYzB1TmN0YUNiOTBsanpuWGdyMVkrak9Vbm9aVXFoamEzVGNq?=
 =?gb2312?B?aUNOTWxNQkg2ekZiRHdWVjZISUJ5M01PRmNCQmhKNnNnTkFWcnBXOURtaXFx?=
 =?gb2312?B?VHhMWlBZdk5WQy9uWEVPNDNuZllBVkxaSG4yNDZBZmlaOU1ncHVaWGJHR2l5?=
 =?gb2312?B?cVR4ZWtoQng1QWlQOVJtNk1QZk1XRWIwMVVkVElIMHNDMjMvL21odjRXMUJ4?=
 =?gb2312?B?c3cvWkFlOVNaN3kyamRNUlFIT0FTaDljL0N5U0F4eWFPbkYzQTExc3lmcEpY?=
 =?gb2312?B?eW5ESVRnbkF2clJURTUwMTM1dENVKzBOTUJTRVRLMTFnUEVWa0hCSVZHazJI?=
 =?gb2312?Q?pWsU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4931de5-50f2-4b5c-8c43-08db101b5958
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 12:43:05.1725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K3zqDGeBI+0Fm2zh5dJO95bOx79Mucwk67k952Ge7w19YWqb6P/PCyIBHzCa7xYSDh+w5Yr9pcDd0Wql30MitQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7088
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyM8TqMtTCMTTI1SAyMjoyOQ0KPiBUbzogV2VpIEZhbmcg
PHdlaS5mYW5nQG54cC5jb20+DQo+IENjOiBBbGV4YW5kZXIgTG9iYWtpbiA8YWxleGFuZHIubG9i
YWtpbkBpbnRlbC5jb20+OyBTaGVud2VpIFdhbmcNCj4gPHNoZW53ZWkud2FuZ0BueHAuY29tPjsg
Q2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0
LmNvbTsgc2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsN
Cj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dF0gbmV0OiBmZWM6IGFk
ZCBDQlMgb2ZmbG9hZCBzdXBwb3J0DQo+IA0KPiA+IFNvcnJ5LCBJJ20gbm90IHZlcnkgZmFtaWxp
YXIgd2l0aCB0aGUgY29uZmlndXJhdGlvbiBvZiBwdXJlIHNvZnR3YXJlDQo+ID4gaW1wbGVtZW50
YXRpb24gb2YgQ0JTLiBJIHRyaWVkIHRvIGNvbmZpZ3VyZSB0aGUgQ0JTIGxpa2UgdGhlDQo+ID4g
Zm9sbG93aW5nLiBUaGUgYmFuZHdpZHRoIG9mIHF1ZXVlIDEgd2FzIHNldCB0byAzME1icHMuIEFu
ZCB0aGUgcXVldWUgMg0KPiA+IGlzIHNldCB0byAyME1icHMuIFRoZW4gb25lIHN0cmVhbSB3ZXJl
IHNlbnQgdGhlIHF1ZXVlIDEgYW5kIHRoZSByYXRlDQo+ID4gd2FzIDUwTWJwcywgdGhlIGxpbmsg
c3BlZWQgd2FzIDFHYnBzLiBCdXQgdGhlIHJlc3VsdCBzZWVtZWQgdGhhdCB0aGUgQ0JTDQo+IGRp
ZCBub3QgdGFrZSBlZmZlY3RpdmUgaW4gbXkgcHJldmlvdXMgdGVzdC4NCj4gDQo+IEknbSBub3Qg
dGhhdCBmYW1pbGlhciB3aXRoIENCUywgYnV0IHRoYXQgaXMgd2hhdCBpIHdvdWxkIGV4cGVjdC4g
WW91IGFyZSBvdmVyDQo+IHN1YnNjcmliaW5nIHRoZSBxdWV1ZSBieSAyME1icHMsIHNvIHRoYXQg
MjBNYnBzIGdldHMgcmVsZWdhdGVkIHRvIGJlc3QgZWZmb3J0Lg0KPiBBbmQgc2luY2UgeW91IGhh
dmUgYSAxRyBsaW5rLCB5b3UgaGF2ZSBwbGVudHkgb2YgYmVzdCBlZmZvcnQgYmFuZHdpZHRoLg0K
PiANClRoYXQgaXMgbm90IHRoZSBiZWhhdmlvciBvZiBDQlMsIGlmIHRoZSBiYW5kd2lkdGggb2Yg
dGhlIHF1ZXVlIGlzIHNldCB0byAyME1icHMsIHRoZQ0KbWF4aW11bSB0cmFuc21pdCByYXRlIG9m
IHRoZSBxdWV1ZSBzaG91bGRuJ3QgZXhjZWVkIDIwTWJwcy4gSSBoYXZlIGZvdW5kIHRoZQ0Kcm9v
dCBjYXVzZSB3aHkgdGhlIENCUyBkb2VzIG5vdCB0YWtlIGVmZmVjdGl2ZSBpbiBteSBwcmV2aW91
cyB0ZXN0LCBiZWNhdXNlIHRoZQ0KZGVmYXVsdCBzZXR0aW5nIG9mIHBrdGdlbiB3aWxsIGJ5cGFz
cyB0aGUgUWRpc2MuDQoNCj4gQXMgd2l0aCBtb3N0IFFvUyBxdWV1aW5nLCBpdCBvbmx5IHJlYWxs
eSBtYWtlcyBhIGRpZmZlcmVudCB0byBwYWNrZXQgbG9zcyB3aGVuDQo+IHlvdSBvdmVyc3Vic2Ny
aWJlIHRoZSBsaW5rIGFzIGEgd2hvbGUuDQo+IA0KPiBTbyB3aXRoIHlvdXIgMzBNYnBzICsgMjBN
YnBzICsgQkUgY29uZmlndXJhdGlvbiBvbiBhIDFHIGxpbmssIHNlbmQgNTBNYnBzDQo+ICsgME1i
cHMgKyAxR2Jwcy4gMzBNYnBzIG9mIHlvdXIgNTBNYnBzIHN0cmVhbSBzaG91bGQgYmUgZ3VhcmFu
dGVlZCB0bw0KPiBhcnJpdmUgYXQgdGhlIGRlc3RpbmF0aW9uLiBUaGUgcmVtYWluaW5nIDIwTWJw
cyBuZWVkcyB0byBzaGFyZSB0aGUgcmVtYWluaW5nDQo+IDk3ME1icHMgb2YgbGluayBjYXBhY2l0
eSB3aXRoIHRoZSAxRyBvZiBCRSB0cmFmZmljLiBTbyB5b3Ugd291bGQgZXhwZWN0IHRvIHNlZQ0K
PiBhIGZldyBleHRyYSBLYnBzIG9mIHF1ZXVlICMxIHRyYWZmaWMgYXJyaXZpbmcgYW5kIGFyb3Vu
ZCA5NjlNYnBzIG9mIGJlc3QNCj4gZWZmb3J0IHRyYWZmaWMuDQo+IA0KPiBIb3dldmVyLCB0aGF0
IGlzIG5vdCByZWFsbHkgdGhlIGNhc2UgaSdtIGludGVyZXN0ZWQgaW4uIFRoaXMgZGlzY3Vzc2lv
biBzdGFydGVkDQo+IGZyb20gdGhlIHBvaW50IHRoYXQgYXV0b25lZyBoYXMgcmVzdWx0ZWQgaW4g
YSBtdWNoIHNtYWxsZXIgbGluayBjYXBhY2l0eS4gVGhlDQo+IGxpbmsgaXMgbm93IG92ZXIgc3Vi
c2NyaWJlZCBieSB0aGUgQ0JTIGNvbmZpZ3VyYXRpb24uIFNob3VsZCB0aGUgaGFyZHdhcmUganVz
dA0KPiBnaXZlIHVwIGFuZCBnbyBiYWNrIHRvIGRlZmF1bHQgYmVoYXZpb3VyLCBvciBzaG91bGQg
aXQgY29udGludWUgdG8gZG8gc29tZQ0KPiBDQlM/DQo+IA0KU2VlIHRlc3QgcmVzdWx0cyBhbmQg
cmVzcG9uc2VzIGJlbG93Lg0KDQo+IFNldCBsZXRzIHN0YXJ0IHdpdGggYSA3TWJwcyBxdWV1ZSAx
IGFuZCA1TWJwcyBxdWV1ZSAyLCBvbiBhIGxpbmsgd2hpY2ggYXV0bw0KPiBuZWdzIHRvIDEwME1i
cHMuIEdlbmVyYXRlIHRyYWZmaWMgb2YgOE1icHMsIDZNcGJzIGFuZCAxMDBNYnBzIEJFLiBZb3UN
Cj4gd291bGQgZXhwZWN0IH43TWJwcywgfjVNYnBzIGFuZCA4OE1icHMgdG8gYXJyaXZlIGF0IHRo
ZSBsaW5rIHBlZXIuIFlvdXIgdHdvDQo+IENCUyBmbG93cyBnZXQgdGhlcmUgcmVzZXJ2ZWQgYmFu
ZHdpZHRoLCBwbHVzIGEgbGl0dGxlIG9mIHRoZSBCRS4gQkUgZ2V0cyB3aGF0cw0KPiByZW1haW5z
IG9mIHRoZSBsaW5rLiBUZXN0IHRoYXQgYW5kIG1ha2Ugc3VyZSB0aGF0IGlzIHdoYXQgYWN0dWFs
bHkgaGFwcGVucyB3aXRoDQo+IHNvZnR3YXJlIENCUywgYW5kIHdpdGggeW91ciBUQyBvZmZsb2Fk
IHRvIGhhcmR3YXJlLg0KPiANCj4gTm93IGZvcmNlIHRoZSBsaW5rIGRvd24gdG8gMTBNYnBzLiBU
aGUgQ0JTIHF1ZXVlcyB0aGVuIG92ZXIgc3Vic2NyaWJlIHRoZQ0KPiBsaW5rLiBLZWVwIHdpdGgg
dGhlIHRyYWZmaWMgZ2VuZXJhdG9yIHByb2R1Y2luZyA4TWJwcywgNk1wYnMgYW5kIDEwME1icHMN
Cj4gQkUuIFdoYXQgaSBndWVzcyB0aGUgc29mdHdhcmUgQ0JTIHdpbGwgZG8gaXMgN01icHMsIDNN
YnBzIGFuZA0KPiAwIEJFLiBZb3Ugc2hvdWxkIGNvbmZpcm0gdGhpcyB3aXRoIHRlc3RpbmcuDQo+
IA0KSSBoYXZlIHRlc3RlZCB0aGUgcHVyZSBzb2Z0d2FyZSBDQlMgdG9kYXkuIEFuZCBiZWxvdyBh
cmUgdGhlIHRlc3Qgc3RlcHMgYW5kIHJlc3VsdHMuDQpMaW5rIHNwZWVkIDEwME1icHMuDQpRdWV1
ZSAwOiBOb24tQ0JTIHF1ZXVlLCAxMDBNYnBzIHRyYWZmaWMuDQpRdWV1ZSAxOiBDQlMgcXVldWUs
IDdNYnBzIGJhbmR3aWR0aCBhbmQgOE1icHMgdHJhZmZpYy4NClF1ZXVlIDI6IENCUyBxdWV1ZSwg
NU1icHMgYmFuZHdpZHRoIGFuZCA2TWJwcyB0cmFmZmljLg0KUmVzdWx0czogcXVldWUgMCBlZ3Jl
c3MgcmF0ZSBpcyA4Nk1icHMsIHF1ZXVlIDEgZWdyZXNzIHJhdGUgaXMgNk1icHMsIGFuZCBxdWV1
ZSAyDQplZ3Jlc3MgcmF0ZSBpcyA0TWJwcy4NClRoZW4gY2hhbmdlIHRoZSBsaW5rIHNwZWVkIHRv
IDEwTWJwcywgcXVldWUgMCBlZ3Jlc3MgcmF0ZSBpcyA0TWJwcywgcXVldWUgMSBlZ3Jlc3MNCnJh
dGUgaXMgNE1icHMsIGFuZCBxdWV1ZSAyIGVncmVzcyByYXRlIGlzIDNNYnBzLg0KDQo+IFdoYXQg
ZG9lcyB0aGlzIG1lYW4gZm9yIFRDIG9mZmxvYWQ/IFlvdSBzaG91bGQgYmUgYWltaW5nIGZvciB0
aGUgc2FtZQ0KPiBiZWhhdmlvdXIuIFNvIGV2ZW4gd2hlbiB0aGUgbGluayBpcyBvdmVyIHN1YnNj
cmliZWQsIHlvdSBzaG91bGQgc3RpbGwgYmUNCj4gcHJvZ3JhbW1pbmcgdGhlIGhhcmR3YXJlLg0K
PiANCkJlc2lkZSB0aGUgdGVzdCByZXN1bHRzLCBJIGFsc28gY2hlY2tlZCB0aGUgQ0JTIGNvZGVz
LiBVbmxpa2UgaGFyZHdhcmUgaW1wbGVtZW50YXRpb24sDQp0aGUgcHVyZSBzb2Z0d2FyZSBtZXRo
b2QgaXMgbW9yZSBmbGV4aWJsZSwgaXQgaGFzIGZvdXIgcGFyYW1ldGVyczogaWRsZXNsb3BlLCBz
ZW5kc2xvcGUsDQpsb2NyZWRpdCBhbmQgaGljcmVkaXQuIEFuZCBpdCBjYW4gZGV0ZWN0IHRoZSBj
aGFuZ2Ugb2YgbGluayBzcGVlZCBhbmQgZG8gc29tZSBhZGp1c3QuDQpIb3dldmVyLCBmb3IgaGFy
ZHdhcmUgd2Ugb25seSB1c2UgdGhlIGlkbGVzbG9wZSBwYXJhbWV0ZXIuIEl0J3MgaGFyZCBmb3Ig
dXMgdG8gbWFrZQ0KdGhlIGhhcmR3YXJlIGJlaGF2ZSBhcyB0aGUgcHVyZSBzb2Z0d2FyZSB3aGVu
IHRoZSBsaW5rIHNwZWVkIGNoYW5nZXMuDQpTbyBmb3IgdGhlIHF1ZXN0aW9uOiBTaG91bGQgdGhl
IGhhcmR3YXJlIGp1c3QgZ2l2ZSB1cCBhbmQgZ28gYmFjayB0byBkZWZhdWx0IGJlaGF2aW91ciwN
Cm9yIHNob3VsZCBpdCBjb250aW51ZSB0byBkbyBzb21lIENCUz8NCkkgdGhpbmsgdGhhdCB3ZSBj
YW4gcmVmZXIgdG8gdGhlIGJlaGF2aW9ycyBvZiBzdG1tYWMgYW5kIGVuZXRjIGRyaXZlcnMsIGp1
c3Qga2VlcCB0aGUNCmJhbmR3aWR0aCByYXRpbyBjb25zdGFudCB3aGVuIHRoZSBsaW5rIHJhdGUg
Y2hhbmdlcy4gSW4gYWRkaXRpb24sIHRoZSBsaW5rIHNwZWVkIGNoYW5nZQ0KaXMgYSBjb3JuZXIg
Y2FzZSwgdGhlcmUgaXMgbm8gbmVlZCB0byBzcGVuZCBhbnkgbW9yZSBlZmZvcnQgdG8gZGlzY3Vz
cyB0aGlzIG1hdHRlci4NCg0KDQo=
