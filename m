Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F65B459F32
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 10:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhKWJcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 04:32:36 -0500
Received: from mail-eopbgr00040.outbound.protection.outlook.com ([40.107.0.40]:10240
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230447AbhKWJcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 04:32:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeDeoqMK39xlaW9mIQtIgq+97s9eY3LBREJzdzGefnOlkrbZZZ1QgwvEVqqE2lZuxKCrkpUiPfSkzSWYOYgdBlxUeBIqVomp2IFGBd6GIZAbvG2N95PvkanO+ot4puMsfg/r4wkyHAnwyTRvLdz7IxBoniJ1lNTaeQZ1LwrFrJWvhA13IJ8nL5eY4sqVi9tvh5oGSocHkpMjArR+fDHWCwSK4nG2+Rm9/agTzFMoA7nw2y5IT/QcIOPAR8lAHJ9HpkJMpb4slUNanfpoLg7cwTf0EVRfnr+Onywp2X62IpCOC6otR+L+BWONiTmTUffvM/73E+1RynKS3Fgm5ky5Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuqbQh4uhZAY1HC+OnxaGdxh1MzooTI7Yd9D1bD5b+I=;
 b=FqdCkS9ATVYjCQkelC1XC4lWjV7k7FAo8B9BcyejIYlp1hKe84lIASOtpxR61rraTyKwhLSZzlqohvSyL2BFfAPxGxsBZzOVeSVYJSOYAyqvcg/jIBW5Vkygyie7L47eVxllxDGVuK8OYsmjEpXr6otcRQFTCkAw8MUi3JjyHehOZGzJd/e3yMLtoT6YKC4VLPGCF98+Q3WHBvv56kVLUnBb5sogkv8geqXNWfL1sIkaASTAefIiRThje6bfG+U52CYOLUxioWBrCbYnfRt0VhrbJ+Q8gsjyIGwKR9C37ws+ek2gUSj9j7b92Xsd8pVkY7hPkaz4fIxvohYlB2L75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuqbQh4uhZAY1HC+OnxaGdxh1MzooTI7Yd9D1bD5b+I=;
 b=qmCf0zAo4yzaI3Pv3Ru74AwYiSnoa7Rlvtbv9LjK2TcGfa2Hy2pPca2cgUn/DhWu8dOkazR5Ep6TqaWcz7XADx1Z7tstzW6F0/0FtCcDZ0u9AldsEV1iRfwDRHtj43cbuT7y/qgvzn7lE180RxN3+mF1fL8KK/27W+2yS5K3IBs=
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU0PR04MB9249.eurprd04.prod.outlook.com (2603:10a6:10:350::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Tue, 23 Nov
 2021 09:29:26 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4713.024; Tue, 23 Nov 2021
 09:29:26 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Thread-Topic: [PATCH 1/4] dt-bindings: net: fec: simplify yaml
Thread-Index: AQHX3gYOANElx4ianEWrRr45c6TuOawOz04AgAINnRA=
Date:   Tue, 23 Nov 2021 09:29:26 +0000
Message-ID: <DU0PR04MB9417842B67DE3FC3C28B120788609@DU0PR04MB9417.eurprd04.prod.outlook.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-2-peng.fan@oss.nxp.com>
 <DB8PR04MB6795E60F4D2CED35569CBFA7E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795E60F4D2CED35569CBFA7E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c68c85e7-6946-46dc-059e-08d9ae63bdfc
x-ms-traffictypediagnostic: DU0PR04MB9249:
x-microsoft-antispam-prvs: <DU0PR04MB9249BE9201AFEB6E24426F4F88609@DU0PR04MB9249.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rqgYpQUdHl1N+5LCF54NWPuWvwsHVqx1pMIOV6Ow5CeumKGeiHbIKdQMCd3heXEfMBQwkchpCt8UFWKCcELi1X8DcxjVwIouY2qDafVIujF8mUIbBpLdwSov6I2miSG4JzHZOiNQI9SAGOTmccg3jNd5czDkGbmtlmFpgEPFZJTgfmJt5mC3fStEor+2rjBtvtl9vSe/Tppr3f4rMYtYQWkihmZVNwP02DySNrYPjdLkNiSLdrXQkWFsHUyYJxHCIW66LyzNCbHVO/dnBt68EAVa4yPHfjiJWrN8C/TB1RFQwOduWlggpPdWME8mqIW9pL7p470haUDRzEAfSwbj9brghIrzARUP2xGCjcUCWh2RHI38VD3OESYxK3oBFAxKPCS7Mvf88xIxEK++HcMBxvkkkZxTBuJTfTCsNZuJ4ssPFv06VuLOEQNPudSTz2fbS04NfilfFE+EY2/0H+Z6unrtLj+Snn0Dd6lr+wY/lGoHcaY1Z0mxNY5e3dBe10U4D3IvjRiS13luVEFNUtmfcn9ZQkQT0+ZorAQ5rThDb2ilLJHiOkxZm7b3i/yJzFA5QBcPLdQyrdi+6lnbIFXwmox8kDE5t5ZDQlyFtTneR9j+lzz9ZRm601efps9n36LmwYqSqsBnKMOE4XjGXc3/ugMzg1wkdRaoV2u84xXY+Y/UXyKbHcP3sl7uq5ICcrXXU0NQGRBWaGmjuq2VW9ancA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(110136005)(4326008)(6506007)(122000001)(54906003)(52536014)(83380400001)(38100700002)(71200400001)(44832011)(316002)(33656002)(66946007)(66556008)(66446008)(8676002)(53546011)(86362001)(2906002)(9686003)(7416002)(66476007)(64756008)(7696005)(38070700005)(26005)(508600001)(55016003)(8936002)(76116006)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q0d2eGlzWGdUQ2hDaXFqd2k2c2dRNXNGL0lZcFdlYUROQjBHRnU4dHMyV2tu?=
 =?gb2312?B?UWdjRHBsdnQ3N0tpcnlhOG15QXVFRG9YdWxUeW5qcjdOR0ZyR09LWTBqRG50?=
 =?gb2312?B?VXJSQjZXOHFXOXNIYktONGVJTnZaZFpIVDE0MGgzangxdU9LUys3NlZJN1BH?=
 =?gb2312?B?THZQU2I4elRtNkptY0laNjhNWnlXWUJwSXdHWDM0ZWkvRm1mT0VnK3p6K3Vs?=
 =?gb2312?B?UzNJNUdZQTRuaDljLzZMNVRza3RFNktrS1FIdlJpVXg0V0NxNlNoV1dObWFu?=
 =?gb2312?B?M1dtK3hVWlV2emZOenBYTUtTd1hkU05UWXBpMHdxNjQ5MFFZWTE4dFJXTms0?=
 =?gb2312?B?V1RqaXhGZjJidkY2eTdHQlo3ZHhtK0lGSEEvZGtpTWYwWVp1U3BOTjlXaTNy?=
 =?gb2312?B?MmN4U2dkYnhKV3J0WU1uQVlCS0JxK2w4Qm9GK3JRMlhBaDFRdTdQWUU0TWF0?=
 =?gb2312?B?TkFBbGlPK3Z0NDBTY0QzVUlYTHpNVHI4THBKRTFhZkRORWo0ci95Q0pzbjhX?=
 =?gb2312?B?c3gvYzJWK3NiU0xWeGtjV3RUOC9IQ1R5R3NJOEVrR0FiSkEyQVpCQUlKdlE3?=
 =?gb2312?B?RjRaTDZnU1VjV1g1RlI0K1FjN2VGeDNRTG9INkI1aGhxUWVqYm94T0M4clpU?=
 =?gb2312?B?K0FJUjVDdHNzVjVRWk9TMU5kV0RncERyYjZXcFNtZXE2YlF5b2xBTExQQWRT?=
 =?gb2312?B?VWQzNy9iOFAzTU5iR1hORENrTlUrK3FFN0hDSGJ1Q0g3L3k5YVV0Q1pYUDlh?=
 =?gb2312?B?cDBBZzdGMjJQV0ZPUTdPTUhDM3VacEU4aHMyREU4T1pGa2U3RFpMQzJvYm1J?=
 =?gb2312?B?ZG0wMHdMVGtneGJLMmlUTzdvK085ZFBDNVdyVHVQUDRNWDZSMmMyc1FTbDFJ?=
 =?gb2312?B?cWRjTVUxZDdieWo3T2xEVkNEbXNFRU5iQTNoamVhTVB5Z3VsWnFlckxJbXI5?=
 =?gb2312?B?YitkaERxcTc1T0NENldjZEpSSG9mTUg0bHNoYmwyQi92OWczdlZmamZqemF6?=
 =?gb2312?B?dkQyS0dBM01GTXRoakoxWmNETFArQUl1ZzFFMDVXdy9hZDQxak9CVnF2OW9q?=
 =?gb2312?B?ellyWFlwUzZVek41ZXBDcGI3Q2ptK3hDWFpLaGlqd0Q4UGFJTEJEbGdnRkx0?=
 =?gb2312?B?L0x4K1VJMTZuYkR2aFZxVmV6VWJ5RnNzaFlzam03TmVQckV1L2V1OXJhYnpZ?=
 =?gb2312?B?Mk85aUkrN3BULzQrZmE4eDdsR1ZxWmNPMU1admJhem9GNU5ScmNuQ2lFUktZ?=
 =?gb2312?B?a1NSdmczTVhjeEFObjFEOVpaNVlwM3czUlNlaEMyUVFlaEVuWVdneTdJWXlR?=
 =?gb2312?B?Q2hjcVNHWkpXcXlXZUJQK3hNOU1pVXFCN2UxOU10WlBuenlZR3RxZWh0eXBE?=
 =?gb2312?B?VzZIRHpCMDdqQnRzenhGRXdFSDBrdFdTMXc5SEdjS01hU3FieEZDN01KY295?=
 =?gb2312?B?WXFYOWprQVI2QzF0UFVDUndreEdmRmM3MURFL2ZnQThDbjJyVWJOb0h3Tmll?=
 =?gb2312?B?aC9jL1VhN2FXZmFVRHdUNkt6aUx4ZzZ1OGxRK0NYZE5vK3U4OFFySjA2NWlD?=
 =?gb2312?B?WDc4SVhzMzUvTVB1L1laLzZmbG8zczhmbG95WC9aR1U5RDlkN0FBQ25vQXhJ?=
 =?gb2312?B?d2EvdktJNGxUK1ovN2VQdk4vaDR2eUltLzFwclZDams1VmhZYWNCNGxNZnRp?=
 =?gb2312?B?cnM5RGM3NGVzcDVLYS9DVk12K25zK3pPeVNNeCtHVWJoTnJJUEMrUm1mS3ky?=
 =?gb2312?B?L0c3cE9OaXAvY0IxZnFsWFdsTlV3YXdHaXpTTEkvWXUybDZUd3JtMEsvR0lY?=
 =?gb2312?B?WGoxSWFYZmNWRlpGNzJCRWxmS2VUOG40RVlENFhxUE9iTFBQZE5Ud1RaaW9F?=
 =?gb2312?B?RDFHK0ZwaTZQRnJMaE5naWlJSmU4QnMycU9zRVpVQ21ZYVowaHhwdlJhODRt?=
 =?gb2312?B?OXB1R0FWUEVielFIUXJDenJNeFYwdUpacVRsN0NZbjJBaHc1VVZsVnQrZ0h0?=
 =?gb2312?B?MnRHUXlPaTBtQVhSbXZRYks2ckIxMVV4eUxUUmR6U2xnZDloeXNtcy9vUjRy?=
 =?gb2312?B?dlp5Q2k3NHVtUzdHYzJtT0huSjIrMWxpN3p0NjhmZ3VnTHlFN0xvOWZraXpB?=
 =?gb2312?B?ZU1DUk90eEJkSjY0MS9rMFUybmhoNk1PYWQ2RXljREdxdFZQY1NvVC9rRytt?=
 =?gb2312?B?dnc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68c85e7-6946-46dc-059e-08d9ae63bdfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 09:29:26.0697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTop2pn5uVI4vTTiFGYecJ2M6LIFE1CpCdoP0jaEgn9K8JbjajKrO1yeg4pLNknx06CVqh6JHS7B1PPUPRP7ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSRTogW1BBVENIIDEvNF0gZHQtYmluZGluZ3M6IG5ldDogZmVjOiBzaW1wbGlm
eSB5YW1sDQo+IA0KPiANCj4gSGkgUGVuZywNCj4gDQo+IFRoYW5rcyBhIGxvdCBmb3IgaGVscGlu
ZyB1cHN0cmVhbSB0aGlzIHBhdGNoIHNldC4NCj4gDQo+IEZvciB0aGlzIGNoYW5nZSwgaGF2ZSB5
b3UgcnVuICdtYWtlIGR0YnNfY2hlY2snPyBJIHJlbWVtYmVyIHRoYXQgc3BsaXQgdGhlbQ0KPiB0
byBwYXNzIGR0YnNfY2hlY2sgd2hlbiBjb252ZXJ0IGl0IGludG8geWFtbC4NCg0KIiBhcmNoL2Fy
bS9ib290L2R0cy9pbXg2ZGwtbml0cm9nZW42eC5kdC55YW1sOiANCmV0aGVybmV0QDIxODgwMDA6
IE1vcmUgdGhhbiBvbmUgY29uZGl0aW9uIHRydWUgaW4gb25lT2Ygc2NoZW1hOiAiDQoNCkJ1dCB0
aGlzIGlzIG5vdCBpbnRyb2R1Y2VkIGJ5IG15IHBhdGNoLCBpdCBhbHJlYWR5IHRoZXJlIGV2ZW4g
ZHJvcCBteQ0KcGF0Y2guDQoNCkkgbm90IHNlZSBvdGhlciBpc3N1ZXMuDQoNClRoYW5rcywNClBl
bmcuDQoNCj4gDQo+IEJlc3QgUmVnYXJkcywNCj4gSm9ha2ltIFpoYW5nDQo+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBQZW5nIEZhbiAoT1NTKSA8cGVuZy5mYW5Ab3Nz
Lm54cC5jb20+DQo+ID4gU2VudDogMjAyMcTqMTHUwjIwyNUgMTk6NTgNCj4gPiBUbzogcm9iaCtk
dEBrZXJuZWwub3JnOyBBaXNoZW5nIERvbmcgPGFpc2hlbmcuZG9uZ0BueHAuY29tPjsgSm9ha2lt
DQo+ID4gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsNCj4ga3ViYUBrZXJuZWwub3JnOw0KPiA+IHNoYXduZ3VvQGtlcm5lbC5vcmc7IHMuaGF1ZXJA
cGVuZ3V0cm9uaXguZGUNCj4gPiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBn
bWFpbC5jb207IGRsLWxpbnV4LWlteA0KPiA+IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7DQo+ID4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnOyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4gPiBTdWJqZWN0OiBbUEFUQ0gg
MS80XSBkdC1iaW5kaW5nczogbmV0OiBmZWM6IHNpbXBsaWZ5IHlhbWwNCj4gPg0KPiA+IEZyb206
IFBlbmcgRmFuIDxwZW5nLmZhbkBueHAuY29tPg0KPiA+DQo+ID4gaS5NWDdELCBpLk1YOE1RIGFu
ZCBpLk1YOFFNIGFyZSBjb21wYXRpYmxlIHdpdGggaS5NWDZTWCwgc28gbm8gbmVlZA0KPiB0bw0K
PiA+IHNwbGl0IHRoZW0gaW50byB0aHJlZSBpdGVtcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IFBlbmcgRmFuIDxwZW5nLmZhbkBueHAuY29tPg0KPiA+IC0tLQ0KPiA+ICBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2ZzbCxmZWMueWFtbCB8IDggKystLS0tLS0NCj4gPiAg
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+
IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2ZzbCxm
ZWMueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2ws
ZmVjLnlhbWwNCj4gPiBpbmRleCBlY2E0MTQ0M2ZjY2UuLmRiZjYzYTljMmE0NiAxMDA2NDQNCj4g
PiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2ZzbCxmZWMueWFt
bA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZl
Yy55YW1sDQo+ID4gQEAgLTM5LDkgKzM5LDggQEAgcHJvcGVydGllczoNCj4gPiAgICAgICAgLSBp
dGVtczoNCj4gPiAgICAgICAgICAgIC0gZW51bToNCj4gPiAgICAgICAgICAgICAgICAtIGZzbCxp
bXg3ZC1mZWMNCj4gPiAtICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ID4gLSAg
ICAgIC0gaXRlbXM6DQo+ID4gLSAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14OG1xLWZlYw0KPiA+
ICsgICAgICAgICAgICAgIC0gZnNsLGlteDhtcS1mZWMNCj4gPiArICAgICAgICAgICAgICAtIGZz
bCxpbXg4cW0tZmVjDQo+ID4gICAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14NnN4LWZlYw0KPiA+
ICAgICAgICAtIGl0ZW1zOg0KPiA+ICAgICAgICAgICAgLSBlbnVtOg0KPiA+IEBAIC01MCw5ICs0
OSw2IEBAIHByb3BlcnRpZXM6DQo+ID4gICAgICAgICAgICAgICAgLSBmc2wsaW14OG1wLWZlYw0K
PiA+ICAgICAgICAgICAgLSBjb25zdDogZnNsLGlteDhtcS1mZWMNCj4gPiAgICAgICAgICAgIC0g
Y29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ID4gLSAgICAgIC0gaXRlbXM6DQo+ID4gLSAgICAgICAg
ICAtIGNvbnN0OiBmc2wsaW14OHFtLWZlYw0KPiA+IC0gICAgICAgICAgLSBjb25zdDogZnNsLGlt
eDZzeC1mZWMNCj4gPiAgICAgICAgLSBpdGVtczoNCj4gPiAgICAgICAgICAgIC0gZW51bToNCj4g
PiAgICAgICAgICAgICAgICAtIGZzbCxpbXg4cXhwLWZlYw0KPiA+IC0tDQo+ID4gMi4yNS4xDQoN
Cg==
