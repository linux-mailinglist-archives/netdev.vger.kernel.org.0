Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE55992C9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbiHSBuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243630AbiHSBuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:50:54 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99207D7CC7;
        Thu, 18 Aug 2022 18:50:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeBmuhJGMbkXCszaKDHsuuCfVhKoQ65dTFKPjsw65q7tzfQjz2pGzqglCp5mDIVVr8o9pPSUKXhJ+/rGWB/fqtaCMeAixKApngH+jfBHmfSlgKIADEN+27hGKjmgDgcCl6jmaK9JD3sUDDAJIwVBZxG2Qvmb4GjIYqu1IVm4PM1LARQ4yhFn1sAj6W83I8lmKV/p5GShw1gA/fu5qh1epA7UKy7ct1YAxuk9R3x47nXS/5HHosWUepqa5Lc6WXKD5gyKWqr8Z7gKP2/AKHeCCUiGZSQGmuvWXCwatrygwcVOkz6bEPt7oRMI7ZjN6FSiCFWNt//Eae+ak7+wVXPbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uxx+nlxyC9Ib3FlKTGZdIgEtUXGl2w71FW8EVujwVmg=;
 b=L4KPbIR4A2kK3SzHeO93E8fTYOlkwrrIWUzhU4byrdOZu5NNeBvld50Zg86B0IwgzSFAqMCyCpPLZIOnjmQqDDrNvOU2n68TUy6mDwuAdfvxJrpt12JDyiL1BVkuFLKBErXYwzh3oox239O5v66d4Pl/gCj7nAdiLtk0uMJzSLSEORQ7JZF9QllBcbelC3zy2EJzAJBsW8rqay9Jz1rsFkfF/xmy9lHj4XN3q1xCxhZs5cBc27JSkrICWkbsfvAcJQeYfnGbjxojWd80o9mzipflXZEVGo0Uzwl16YclP5POs4yX2B4NWH0cqxnzF5OtHqX6AkTjQnBpYzZIdXghag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uxx+nlxyC9Ib3FlKTGZdIgEtUXGl2w71FW8EVujwVmg=;
 b=EMdsfZVJPPAN38ytbReBByMQd7Zh3NZ4Iv4swoyzDYydB7hh110fu9BBEjFyYNKgQ7Ttb6kdPWUigzRvcW4XojZYjJo3KhsqAf2UPcT/J9/ezz0dn87adE73o9KrD00Dk9D9MbkWcJk7eUwNZWpRIojZTamZsucTH3lju8jGMlE=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by HE1PR0401MB2667.eurprd04.prod.outlook.com (2603:10a6:3:7d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 01:50:47 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 01:50:47 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
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
Subject: RE: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Thread-Topic: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Thread-Index: AQHYsqKW4sUYyPySKkCZLBfJFMMhm620SUAAgAAZr4CAAAaYgIAARhqAgAAB7ACAAMKigA==
Date:   Fri, 19 Aug 2022 01:50:47 +0000
Message-ID: <DB9PR04MB8106BB72857149F5DD10ACEA886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
 <20220818092257.GF149610@dragon>
 <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
 <20220818135727.GG149610@dragon>
 <00614b8f-0fdd-3d7e-0153-3846be5bb645@linaro.org>
In-Reply-To: <00614b8f-0fdd-3d7e-0153-3846be5bb645@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8faec53f-60fa-4405-f35d-08da81853ce1
x-ms-traffictypediagnostic: HE1PR0401MB2667:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 29/aqLCoD6z2NfRHMDBvikIKsz1OEBZNbS79v5b6ZmkSLMmZN8q4J3ZD2nfofKpHx5u6Ji32eNjBp/GBdRARBvENve6vCpN0zvMbMKkv+T4aZEHgPZERCul5ai11wMYfjIsY9VT0se+IDYZOeAGwcf45kdFc7v3c4iJP+Tg4hXhbRAUo3B8rfYaI7m46Iw2/NZ6igAbxtvXO4+athB6C+ThcU9obVSIhS9GxPEIQCA1MdBWTOY7iSzp4UGaiMfJn3QnZC4juAhrjeoWcJjE/xw/V5YGJwWQTo8S+LVlPBerLBG+1mK5IHFEQ+/wLdS75YErSd7E7ODZhIuguUjvjRP5fTolp4qLdvGjVxlGldZr09tvx61W7dWpO503s9GaLYkDF+V6CrI6cweyJaG4DLzHrqYfEAgnAsDzmu0U8ggN/58y2w4Ptcvx1ZxF1LdkV4VGGVHYHyZTSBRL06ZIgL9fczkq4gPqs49ghfxoGhm0HcRUqb45cwE3/7aDUuIWGM30vJpHVMCHd3iLYdMED7ARhC8VWh9UamqL5TsMATeMJi0CU5FDdd2kdJwcDL9o3Sdu0BI6JOXIqLDwTpKQquu1eRc5KbWe3hSQLN/w/Gi+uW+Ls0+e1EXT6cRXFF3AkuAQYoEK6Wn/kxJ4lZVUH8bJGuXgPaT1tpkxZz7h4yeC4lW6uaTXd8jZU7mboQdsgKAgHQ5blnU0S/a2/TzYTijx2hYszPww5Ghrcg0girD29uIIglq2cWUM21cgAws4xMYbJQDmKKhd3ToXGdw0Fgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(186003)(38070700005)(38100700002)(122000001)(83380400001)(8936002)(52536014)(66946007)(66556008)(66476007)(66446008)(8676002)(4326008)(64756008)(76116006)(5660300002)(55016003)(44832011)(15650500001)(7416002)(2906002)(6506007)(41300700001)(7696005)(53546011)(9686003)(478600001)(110136005)(26005)(54906003)(316002)(71200400001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkRiWXBPMEkrV0UveG9hVkl6Vy9QNk9aajNnYXNhTnYwL05LS0FTOWZONFhr?=
 =?utf-8?B?L3lsMUNZTzlGaHNWbVN4K0k2cGdHZjI2eEVCZ3k4NkF0MHdraFpmemNLYSsr?=
 =?utf-8?B?OHRUUGs3NWIweDNsd1YwV2prN1Jvd0cvd3g5UTJyMUowWkcxMmlBSC9Mc042?=
 =?utf-8?B?UVI5NzVBd3BiNXp0UE9YQ0RsK1RiNmdNZTlRMGJzS1NQN21rMVNhWWdSdU40?=
 =?utf-8?B?SUhzRU9kVVVOSmNmemlId0VKNjRnVVJJSjc0cjJlcHhrY21ETTRXM2UxM05L?=
 =?utf-8?B?amc3aUpiaFBzcFBjMkduR1FmYzZLOGgyNUJKZG1Pb0FFMlhIeW5TaWZ1SjdB?=
 =?utf-8?B?b3FlLy9ORXRMbWY3a0hiQldsY0RmdDc4TVZ6ZkpQYVdBS25Pc2gwVTc4aUhO?=
 =?utf-8?B?Qkltd3V3UnZlK1lmVGxNUTV6MDZMb3RDM3UzK3lIZW94TWYyK21SMFZSazBi?=
 =?utf-8?B?akdtK0N4cHQ4TFNDTkt3VHZrTTY4bEhsd2xoOEpUV3R5b0g3WWFTejJQenAr?=
 =?utf-8?B?WnJBYlp5c2FvaFowS2NXbWZ1cTFKQWNLa3hoQWZjQzdlY05GcFB0aXk4Vjhl?=
 =?utf-8?B?UFVudFN6blg1TWZZVGJtQmlSTFRTa1VhS3JRN1A2dUVBRUU4UHZFTnExd0Vu?=
 =?utf-8?B?MXFVQk56bFZwbm5Ic3dDQlVQdmVid3NDQ3RrVlUwTVdycTRpR0E0U3pFdGtF?=
 =?utf-8?B?Y09ySUtvSXlTbkx6aUFMZW03ZWlvUFc3bnVkMmFHejI4N3FUeTlBT3FtY2VB?=
 =?utf-8?B?ZEFtdEtIVUVjelBXNjlldkFiYXRUeFZWNkJRL2JMd2d0c0JlUEtpZE9Xd01U?=
 =?utf-8?B?cXpSRGZhT1gwMGlKalZQYW5tdWVDMyt5cXROWXlsSnhQMllkUFVCSWNIMDFh?=
 =?utf-8?B?UHh2WHJVM2JTS0o5bjBqVzI1QjBPWERpa1hZUThmVS94SDB6eEQ0UU5wRDdG?=
 =?utf-8?B?eU9MMVJYc2J3bUY1aFZaS0NvbFE2dmdwakpSWG9rN3lnZWpYcXVOcHJxR2tz?=
 =?utf-8?B?Vk84eC9TZWd4VnZ5czlTMERFdmxEcU1QNnRxdzZQbzhRRi9vR214TWRiSmsr?=
 =?utf-8?B?SzI5OWp5TUZMN3VFNFVEN09YVDZKclpQSUVRSE5yRHJNQ0gwTldlRFJwUVBP?=
 =?utf-8?B?VlBWdVdvVWkxNElReVJWcWpDK1Zwa0F6STBkRnpvbUFqR2VGWks4UlNvRmtp?=
 =?utf-8?B?ZXdoczRPUEtFVDVMbmFXd2NOU0t5QzdtL2U1dzMxVXZSeWFRamtTbS85VVBX?=
 =?utf-8?B?c2gzVDFES0FrY1BsQ3VIQjhOSTgzUHhHWTJzcXlRTU9aSVZxL1pVcGJZZkU0?=
 =?utf-8?B?cXFQdmlpUjY3dy9rNk5HYzZWbUtoVjZ6ekwrai9lNWl5QU92TGdEQWdJTjJQ?=
 =?utf-8?B?QjhqSVdkNVNHMzhEd3ltdVRLMUhHdDBqQVNNOHhmVU5wUVYrUS9Na3NwaFdU?=
 =?utf-8?B?eTkzcTNseTNVSEt3TDdzQ0pBTmxDKzRDRDVZK3pjdFhGVEhDMDM3RHM3aGhS?=
 =?utf-8?B?KzRTZjByeVBlTnNvdkUvS09yRFo4RmZxVE9UekJVS3lpUDhicUNwN3RSeWp2?=
 =?utf-8?B?b2QxRTZCNE9UazhtK000THE1M3U2UE85UzF2LzdxUWpNWWJDNTh2LzI5ODZG?=
 =?utf-8?B?blg2VlpVc1N6cTNvV0xuSGJjMWFudHIvSUhqcldqMC9uLzJZZ0VQVGcxNFIx?=
 =?utf-8?B?SXJIRVNJREI1aXN1YTZJVzF5ZDlpMUl5aW8zL3RnK1phN2ZUL3p0a3l6K2Qz?=
 =?utf-8?B?bVVLNGUrdlZZb2lJRnFNaDVBaWVVQ2R3eW0vR1pYVVQwUEs3WUdCV0RZcS9G?=
 =?utf-8?B?VGdXQ1NSQnRJWDNYajlscGhzOGlTcEpMaUtUQXFoalRYMC8zbnpvZXNtVlhu?=
 =?utf-8?B?dk5neXc0ZnJOcWgzdE5MSjQ2aG82TUdQaDZqeHd1VDRmSjd5QTNXQ0YzWS9l?=
 =?utf-8?B?bjRiajRaQWc0NStZcHRPenluVGkrdHFwY3dUUDNnbEtqQXZOcVJkV0kxWjU1?=
 =?utf-8?B?d3A3aG9XS0Y5VmMrbDdoYjB4T1krUkMyK2ZNa1NBYWRVZXZhL25Ja2xEc3l2?=
 =?utf-8?B?ZHlwTElqQmZXcUpaNHlYQVpVbjVTSHhSK1Bsem1xcGZnOGkwSUhrVnJjWStF?=
 =?utf-8?Q?mQJE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8faec53f-60fa-4405-f35d-08da81853ce1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 01:50:47.8265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lLhJG4z/YTbw4J1WdTYdcdyqYytNcLjIL3KP9vmq2iCC75hwjCsFiDeh99E6gF3P76OB9ufxcgjDaevzDkPPXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2667
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIy5bm0OOac
iDE45pelIDIyOjA0DQo+IFRvOiBTaGF3biBHdW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+DQo+IENj
OiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGVk
dW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+
IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOw0K
PiBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsga2Vy
bmVsQHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207DQo+IGRsLWxpbnV4LWlteCA8
bGludXgtaW14QG54cC5jb20+OyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT47IEphY2t5IEJh
aQ0KPiA8cGluZy5iYWlAbnhwLmNvbT47IHN1ZGVlcC5ob2xsYUBhcm0uY29tOw0KPiBsaW51eC1h
cm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IEFpc2hlbmcgRG9uZyA8YWlzaGVuZy5kb25n
QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBkdC1iaW5nczogbmV0OiBmc2ws
ZmVjOiB1cGRhdGUgY29tcGF0aWJsZSBpdGVtDQo+IA0KPiBPbiAxOC8wOC8yMDIyIDE2OjU3LCBT
aGF3biBHdW8gd3JvdGU6DQo+ID4gT24gVGh1LCBBdWcgMTgsIDIwMjIgYXQgMTI6NDY6MzNQTSAr
MDMwMCwgS3J6eXN6dG9mIEtvemxvd3NraSB3cm90ZToNCj4gPj4gT24gMTgvMDgvMjAyMiAxMjoy
MiwgU2hhd24gR3VvIHdyb3RlOg0KPiA+Pj4gT24gVGh1LCBBdWcgMTgsIDIwMjIgYXQgMTA6NTE6
MDJBTSArMDMwMCwgS3J6eXN6dG9mIEtvemxvd3NraSB3cm90ZToNCj4gPj4+PiBPbiAxOC8wOC8y
MDIyIDA0OjMzLCBTaGF3biBHdW8gd3JvdGU6DQo+ID4+Pj4+IE9uIE1vbiwgSnVsIDA0LCAyMDIy
IGF0IDExOjEyOjA5QU0gKzAyMDAsIEtyenlzenRvZiBLb3psb3dza2kgd3JvdGU6DQo+ID4+Pj4+
Pj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNs
LGZlYy55YW1sDQo+ID4+Pj4+Pj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L2ZzbCxmZWMueWFtbA0KPiA+Pj4+Pj4+IGluZGV4IGRhYTJmNzlhMjk0Zi4uNjY0MmMyNDY5
NTFiIDEwMDY0NA0KPiA+Pj4+Pj4+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvZnNsLGZlYy55YW1sDQo+ID4+Pj4+Pj4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWwNCj4gPj4+Pj4+PiBAQCAtNDAsNiArNDAs
MTAgQEAgcHJvcGVydGllczoNCj4gPj4+Pj4+PiAgICAgICAgICAgIC0gZW51bToNCj4gPj4+Pj4+
PiAgICAgICAgICAgICAgICAtIGZzbCxpbXg3ZC1mZWMNCj4gPj4+Pj4+PiAgICAgICAgICAgIC0g
Y29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ID4+Pj4+Pj4gKyAgICAgIC0gaXRlbXM6DQo+ID4+Pj4+
Pj4gKyAgICAgICAgICAtIGVudW06DQo+ID4+Pj4+Pj4gKyAgICAgICAgICAgICAgLSBmc2wsaW14
OHVscC1mZWMNCj4gPj4+Pj4+PiArICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2dWwtZmVjDQo+
ID4+Pj4+Pg0KPiA+Pj4+Pj4gVGhpcyBpcyB3cm9uZy4gIGZzbCxpbXg2dWwtZmVjIGhhcyB0byBi
ZSBmb2xsb3dlZCBieQ0KPiA+Pj4+Pj4gZnNsLGlteDZxLWZlYy4gSSB0aGluayBzb21lb25lIG1h
ZGUgc2ltaWxhciBtaXN0YWtlcyBlYXJsaWVyIHNvIHRoaXMgaXMgYQ0KPiBtZXNzLg0KPiA+Pj4+
Pg0KPiA+Pj4+PiBIbW0sIG5vdCBzdXJlIEkgZm9sbG93IHRoaXMuICBTdXBwb3Npbmcgd2Ugd2Fu
dCB0byBoYXZlIHRoZQ0KPiA+Pj4+PiBmb2xsb3dpbmcgY29tcGF0aWJsZSBmb3IgaS5NWDhVTFAg
RkVDLCB3aHkgZG8gd2UgaGF2ZSB0byBoYXZlDQo+ICJmc2wsaW14NnEtZmVjIg0KPiA+Pj4+PiBo
ZXJlPw0KPiA+Pj4+Pg0KPiA+Pj4+PiAJZmVjOiBldGhlcm5ldEAyOTk1MDAwMCB7DQo+ID4+Pj4+
IAkJY29tcGF0aWJsZSA9ICJmc2wsaW14OHVscC1mZWMiLCAiZnNsLGlteDZ1bC1mZWMiOw0KPiA+
Pj4+PiAJCS4uLg0KPiA+Pj4+PiAJfTsNCj4gPj4+Pg0KPiA+Pj4+IEJlY2F1c2UgYSBiaXQgZWFy
bGllciB0aGlzIGJpbmRpbmdzIGlzIHNheWluZyB0aGF0IGZzbCxpbXg2dWwtZmVjDQo+ID4+Pj4g
bXVzdCBiZSBmb2xsb3dlZCBieSBmc2wsaW14NnEtZmVjLg0KPiA+Pj4NCj4gPj4+IFRoZSBGRUMg
ZHJpdmVyIE9GIG1hdGNoIHRhYmxlIHN1Z2dlc3RzIHRoYXQgZnNsLGlteDZ1bC1mZWMgYW5kDQo+
ID4+PiBmc2wsaW14NnEtZmVjIGFyZSBub3QgcmVhbGx5IGNvbXBhdGlibGUuDQo+ID4+Pg0KPiA+
Pj4gc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgZmVjX2R0X2lkc1tdID0gew0KPiA+
Pj4gICAgICAgICB7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyNS1mZWMiLCAuZGF0YSA9DQo+ICZm
ZWNfZGV2dHlwZVtJTVgyNV9GRUNdLCB9LA0KPiA+Pj4gICAgICAgICB7IC5jb21wYXRpYmxlID0g
ImZzbCxpbXgyNy1mZWMiLCAuZGF0YSA9DQo+ICZmZWNfZGV2dHlwZVtJTVgyN19GRUNdLCB9LA0K
PiA+Pj4gICAgICAgICB7IC5jb21wYXRpYmxlID0gImZzbCxpbXgyOC1mZWMiLCAuZGF0YSA9DQo+
ICZmZWNfZGV2dHlwZVtJTVgyOF9GRUNdLCB9LA0KPiA+Pj4gICAgICAgICB7IC5jb21wYXRpYmxl
ID0gImZzbCxpbXg2cS1mZWMiLCAuZGF0YSA9DQo+ICZmZWNfZGV2dHlwZVtJTVg2UV9GRUNdLCB9
LA0KPiA+Pj4gICAgICAgICB7IC5jb21wYXRpYmxlID0gImZzbCxtdmY2MDAtZmVjIiwgLmRhdGEg
PQ0KPiAmZmVjX2RldnR5cGVbTVZGNjAwX0ZFQ10sIH0sDQo+ID4+PiAgICAgICAgIHsgLmNvbXBh
dGlibGUgPSAiZnNsLGlteDZzeC1mZWMiLCAuZGF0YSA9DQo+ICZmZWNfZGV2dHlwZVtJTVg2U1hf
RkVDXSwgfSwNCj4gPj4+ICAgICAgICAgeyAuY29tcGF0aWJsZSA9ICJmc2wsaW14NnVsLWZlYyIs
IC5kYXRhID0NCj4gPj4+ICZmZWNfZGV2dHlwZVtJTVg2VUxfRkVDXSwgfSwNCj4gPj4NCj4gPj4g
SSBkb24ndCBzZWUgaGVyZSBhbnkgaW5jb21wYXRpYmlsaXR5LiBCaW5kaW5nIGRyaXZlciB3aXRo
IGRpZmZlcmVudA0KPiA+PiBkcml2ZXIgZGF0YSBpcyBub3QgYSBwcm9vZiBvZiBpbmNvbXBhdGli
bGUgZGV2aWNlcy4NCj4gPg0KPiA+IFRvIG1lLCBkaWZmZXJlbnQgZHJpdmVyIGRhdGEgaXMgYSBn
b29kIHNpZ24gb2YgaW5jb21wYXRpYmlsaXR5LiAgSXQNCj4gPiBtb3N0bHkgbWVhbnMgdGhhdCBz
b2Z0d2FyZSBuZWVkcyB0byBwcm9ncmFtIHRoZSBoYXJkd2FyZSBibG9jaw0KPiA+IGRpZmZlcmVu
dGx5Lg0KPiANCj4gQW55IGRldmljZSBiZWluZyAxMDAlIGNvbXBhdGlibGUgd2l0aCBvbGQgb25l
IGFuZCBoYXZpbmcgYWRkaXRpb25hbCBmZWF0dXJlcw0KPiB3aWxsIGhhdmUgZGlmZmVyZW50IGRy
aXZlciBkYXRhLi4uIHNvIG5vLCBpdCdzIG5vdCBhIHByb29mLg0KPiBUaGVyZSBhcmUgbWFueSBv
ZiBzdWNoIGV4YW1wbGVzIGFuZCB3ZSBjYWxsIHRoZW0gY29tcGF0aWJsZSwgYmVjYXVzZSB0aGUN
Cj4gZGV2aWNlIGNvdWxkIG9wZXJhdGUgd2hlbiBib3VuZCBieSB0aGUgZmFsbGJhY2sgY29tcGF0
aWJsZS4NCj4gDQo+IElmIHRoaXMgaXMgdGhlIGNhc2UgaGVyZSAtIGhvdyBkbyBJIGtub3c/IEkg
cmFpc2VkIGFuZCB0aGUgYW5zd2VyIHdhcw0KPiBhZmZpcm1hdGl2ZS4uLg0KPiANCj4gPg0KPiA+
DQo+ID4+IEFkZGl0aW9uYWxseSwgdGhlDQo+ID4+IGJpbmRpbmcgZGVzY3JpYmVzIHRoZSBoYXJk
d2FyZSwgbm90IHRoZSBkcml2ZXIuDQo+ID4+DQo+ID4+PiAgICAgICAgIHsgLmNvbXBhdGlibGUg
PSAiZnNsLGlteDhtcS1mZWMiLCAuZGF0YSA9DQo+ICZmZWNfZGV2dHlwZVtJTVg4TVFfRkVDXSwg
fSwNCj4gPj4+ICAgICAgICAgeyAuY29tcGF0aWJsZSA9ICJmc2wsaW14OHFtLWZlYyIsIC5kYXRh
ID0NCj4gJmZlY19kZXZ0eXBlW0lNWDhRTV9GRUNdLCB9LA0KPiA+Pj4gICAgICAgICB7IC8qIHNl
bnRpbmVsICovIH0NCj4gPj4+IH07DQo+ID4+PiBNT0RVTEVfREVWSUNFX1RBQkxFKG9mLCBmZWNf
ZHRfaWRzKTsNCj4gPj4+DQo+ID4+PiBTaG91bGQgd2UgZml4IHRoZSBiaW5kaW5nIGRvYz8NCj4g
Pj4NCj4gPj4gTWF5YmUsIEkgZG9uJ3Qga25vdy4gVGhlIGJpbmRpbmcgZGVzY3JpYmVzIHRoZSBo
YXJkd2FyZSwgc28gYmFzZWQgb24NCj4gPj4gaXQgdGhlIGRldmljZXMgYXJlIGNvbXBhdGlibGUu
IENoYW5naW5nIHRoaXMsIGV4Y2VwdCBBQkkgaW1wYWN0LA0KPiA+PiB3b3VsZCBiZSBwb3NzaWJs
ZSB3aXRoIHByb3BlciByZWFzb24sIGJ1dCBub3QgYmFzZWQgb24gTGludXggZHJpdmVyIGNvZGUu
DQo+ID4NCj4gPiBXZWxsLCBpZiBMaW51eCBkcml2ZXIgY29kZSBpcyB3cml0dGVuIGluIHRoZSB3
YXkgdGhhdCBoYXJkd2FyZQ0KPiA+IHJlcXVpcmVzLCBJIGd1ZXNzIHRoYXQncyBqdXN0IGJhc2Vk
IG9uIGhhcmR3YXJlIGNoYXJhY3RlcmlzdGljcy4NCj4gPg0KPiA+IFRvIG1lLCBoYXZpbmcgYSBk
ZXZpY2UgY29tcGF0aWJsZSB0byB0d28gZGV2aWNlcyB0aGF0IHJlcXVpcmUNCj4gPiBkaWZmZXJl
bnQgcHJvZ3JhbW1pbmcgbW9kZWwgaXMgdW5uZWNlc3NhcnkgYW5kIGNvbmZ1c2luZy4NCj4gDQo+
IEl0J3MgdGhlIGZpcnN0IHRpbWUgYW55b25lIG1lbnRpb25zIGhlcmUgdGhlIHByb2dyYW1taW5n
IG1vZGVsIGlzIGRpZmZlcmVudC4uLiBJZg0KPiBpdCBpcyBkaWZmZXJlbnQsIHRoZSBkZXZpY2Vz
IGFyZSBsaWtlbHkgbm90IGNvbXBhdGlibGUuDQo+IA0KPiBIb3dldmVyIHdoZW4gSSByYWlzZWQg
dGhpcyBpc3N1ZSBsYXN0IHRpbWUsIHRoZXJlIHdlcmUgbm8gY29uY2VybnMgd2l0aCBjYWxsaW5n
DQo+IHRoZW0gYWxsIGNvbXBhdGlibGUuIFRoZXJlZm9yZSBJIHdvbmRlciBpZiB0aGUgZm9sa3Mg
d29ya2luZyBvbiB0aGlzIGRyaXZlcg0KPiBhY3R1YWxseSBrbm93IHdoYXQncyB0aGVyZS4uLiBJ
IGRvbid0IGtub3csIEkgZ2F2ZSByZWNvbW1lbmRhdGlvbnMgYmFzZWQgb24NCj4gd2hhdCBpcyBk
ZXNjcmliZWQgaW4gdGhlIGJpbmRpbmcgYW5kIGV4cGVjdCB0aGUgZW5naW5lZXIgdG8gY29tZSB3
aXRoIHRoYXQNCj4ga25vd2xlZGdlLg0KPiANCj4gDQpTb3JyeSwgSSBkaWQgbm90IGV4cGxhaW4g
Y2xlYXJseSBsYXN0IHRpbWUsIEkganVzdCBtZW50aW9uZWQgdGhhdCBpbXg4dWxwIGZlYyB3YXMN
CnRvdGFsbHkgcmV1c2VkIGZyb20gaW14NnVsIGFuZCB3YXMgYSBsaXR0bGUgZGlmZmVyZW50IGZy
b20gaW14NnEuDQpTbyB3aGF0IHNob3VsZCBJIGRvIG5leHQ/IFNob3VsZCBJIGZpeCB0aGUgYmlu
ZGluZyBkb2MgPw0K
