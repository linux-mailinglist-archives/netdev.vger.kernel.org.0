Return-Path: <netdev+bounces-3650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A837082D3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0D01C210C4
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C83E23C9F;
	Thu, 18 May 2023 13:33:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680A423C8A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:33:35 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2055.outbound.protection.outlook.com [40.107.8.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2515BE46
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:33:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agxbjz1/Ialwt2ObQMqrfLOeE0VbFxwpii1gFmteaeDw2wKQec4c0Hperm0/ahihONZrT/ZcSScu8pMyL+VyhEKO3w5aBer2AEC1xUg0RkC9e0yfYuuDSfJI33v26VZ50TWMXNTH6Ds8BUp3rb+la/KcOEGBgsamjsDiIr4l9VpAGrVEZoGE+NREwmglfjfDbWigg7lgXgDN9YhwUOzH+CbjQiULS7HZIRQzsTsVy19eFIF7am4AbDklVdGB5jk8eVX31gmJjwRaCDfQYsw0l6Ec1NSwh0K5OxYftyeScPH+R5TgSwLqm5vOweT+EPWzmWTUWKJHnenIDu9bAuP2Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTWRWaMBbFOGWCFDmCSKtqhTdRVJNWYi5cwNb3NokJg=;
 b=bHB6aQLLSU+QgxKNepfLwaSNcSYjnWHB/hqIms0JTE65EZAiUfWfIsC53HTs+Lxmy0GNuw1EQ3Ez1BFCcCk4Mln7iYX8BdKjnUWiR9LBf0VeURy6TQHpS5ktd9KSBm4X7vm9/HVNBAVt3rbwFRPJDtzxpt346D82csOvsdADw5tjr+VwxyPO16qJagH/jjAGNqH2w49/0FNUC+POWXBKnYep5aF7wQq/vHnCQaCl2Hjc+BdGWwUUiEvlAmHz/dC/EtcBNdmhwsaouL6uiF6RvSaBMPbiiSQcWPBgO3VZi5uo2yvxbbFYaXGbBbaSGAG3Kq/2/WW8Zmz5qy1xS1Ekww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTWRWaMBbFOGWCFDmCSKtqhTdRVJNWYi5cwNb3NokJg=;
 b=p8611zv4dfHWZ/LOz2vVGnz1WqJidWFbLZbQ26KylbGDxPLDmBH7GXbZJmCi1EGgNvigy59aEfZZHX9Id1nX2FVZqDzzSGOP9/Q6q30Z8nDELGXeBWxFQbpvh9y95P3IFwLXukAi1m7JYbll4Cd+repq2BzHCFridHYe2a7r4ss=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8961.eurprd04.prod.outlook.com (2603:10a6:20b:42c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 13:33:27 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6387.034; Thu, 18 May 2023
 13:33:27 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Heiner Kallweit <hkallweit1@gmail.com>, Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>
CC: Clark Wang <xiaoning.wang@nxp.com>, dl-linux-imx <linux-imx@nxp.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "imx@lists.linux.dev"
	<imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net] net: fec: add wmb to ensure correct
 descriptor values
Thread-Topic: [EXT] Re: [PATCH v2 net] net: fec: add wmb to ensure correct
 descriptor values
Thread-Index: AQHZiNrGgchPJVnC/0WH4WurCF11xa9e1amAgAEzBAA=
Date: Thu, 18 May 2023 13:33:27 +0000
Message-ID:
 <PAXPR04MB91857E7BEC3E199D52E4376E897F9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230517161502.1862260-1-shenwei.wang@nxp.com>
 <8b06972b-026a-155a-1473-ab72f72828d5@gmail.com>
In-Reply-To: <8b06972b-026a-155a-1473-ab72f72828d5@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AS8PR04MB8961:EE_
x-ms-office365-filtering-correlation-id: 5cbb8c85-3029-41d2-676d-08db57a47667
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 eODZ9P18ZHX6tlvSUS2NImX8odME6E/4XfEHhY9f0Kq+yN/0+xAnBH+qxi7n7ZxjKDsJJ0eV6DUQFFiFUlFUZ7UpQu8Y3HsiK7uPBCmw2NBZ/MyR8LEV7SHkv+av/BMRxXK9uRT8SG0/GuI06hW/aKBj7P9yPFo44h5gGpCKJHO12qccq584acyyWfx7gNGIpdrpNW7UchkEjiuLCz39iuzzejH2q/6zeqIxrhgAWxpSVoOgG716yf73QLDxaHBBcLj/QLUR3txSU2SB9kpIu8PgpCUjS6K5hbrAFU3KT6/oR43Two1P87KuRoV7wQRsUmrJvGc7K20DDe+/Gmjlr3Yn4D0S3sqMG3Gh/s8Va2f0GiCRGfDrOUkjV2l00hA400IXrMMzeCCIAza+j7k2JnGQwaUnEK80641rQDCRdTSvh8UXRHKj8G+/cZRVeSNu4TcoV/kIU9ohznIDAXySIsFUSK6Zz0LNno410NytkNGtMbprFE2N3mI/X9Bax+DilRoKmwYx0yTqUcd0MqrTYBGCWU84cjHkuRxsF6fKvTcb+VsI71fKZj2OhpxT3tpdTzYh11g+8t9N0ZiKh12NNvUq8AuUMxWbCpZkcJrQaWo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199021)(86362001)(33656002)(55016003)(26005)(9686003)(8676002)(55236004)(8936002)(6506007)(53546011)(44832011)(5660300002)(76116006)(52536014)(478600001)(66556008)(54906003)(66446008)(110136005)(66476007)(64756008)(4326008)(7696005)(316002)(41300700001)(66946007)(71200400001)(186003)(38100700002)(38070700005)(122000001)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QkYzT0xJVW5HMVRGekh4azJHSTNDWWNsOURKNjNkMkNxT2M2ZkVOR1JIWGsz?=
 =?utf-8?B?L2pzNVJyRkRJc0pUSlVWRUxTQVByemFDSzc0djRYRk5XNGtDOEQ0RUZuMTRr?=
 =?utf-8?B?RXp0Z2huTDNPbm9hRm9nWm1KQUNJQnA4S0d4VS8reGsraGlRSU52cmo0T3U5?=
 =?utf-8?B?eFQzallRQUZoblAxMjM5SkhoSUxLdDZHV1dKVFRsZytEVGZicXVOdFhZTC9z?=
 =?utf-8?B?NWRERzlQa2l4dzdtY25lbFJ4OUNMSXBPUjBWQjRYTVJuVFFIc1lVYzZ0REF2?=
 =?utf-8?B?dmxncTZHODc2bTdUbGwvd2lvcFRvWUQ1SS9XY1NZVnI2N0FaNjVGTGx3T20x?=
 =?utf-8?B?R3RORXJTUEtqcXZ4cGxEcUdoWVg3TDJVUkNHbVViQWpSS3RIbzg3aG5ScXkz?=
 =?utf-8?B?WlpFR244enl0ZFBQSU9EbVpIUkdxRTJVUnkwempDYkZ1QW1IQlJsUWFsWnhO?=
 =?utf-8?B?MFJ6d21LRWtvNEVjY1E0NHQ0dDl3QnNyVzU3UGQ0SW42MEZ2THRWR1MwOXl4?=
 =?utf-8?B?MXNCZzBseERWOEo2dWJMU2hrc1NnMGc1RkJWS2s5MytWd05SYm9jbWZlNmVC?=
 =?utf-8?B?L0RPYmY5Y1Z1Y3prU1k4dFNuRnZ5L0xOT3ZDN3dvbWk3VTBUb1UxaDhlQ2JB?=
 =?utf-8?B?d2FFekowYzd0UnZPcDVOYzI4b0tZN0gybHNKdFp3K09iZ3NWcysvS1FoUXAw?=
 =?utf-8?B?ZWIrU00zN0pYNjFYMW1GWGkxMmxuNUZKWklwSWI0bEJ2WGMzYlZiYWNvSjI5?=
 =?utf-8?B?QjMrMytlWnI2TmdWeENCSmtDOEpqN2hhN2JkMloyRkF5UTJHM0RvQnpuTlpv?=
 =?utf-8?B?NTJzdzlKVDUxdnhPS2d0V05JN2hEL1AzVWxMUEpWdTNna2htNzZOSEhXb1pk?=
 =?utf-8?B?N25WdVZlUlhQVTBCcFJld3NpcVhRNE0xZzdxRkdYcVpvYm5DTE9UWFZuVkNI?=
 =?utf-8?B?TVJZME5XUXVzSTFtRFcyWEtIMlBpMkFxaXNSeFBaeVpGampmZHhDdGEzRzZD?=
 =?utf-8?B?RUZCc2Z4SGg5L0dOWDJvQWIrWmpEbGZaUEc3dGZWd0FkQ0thNXZ2TzJjQnQv?=
 =?utf-8?B?ZmdIeHpJRE8zRlRnWkRJMXp6L0ZDeGppNlVWNXF6eEt5YUpHSVNQYmlPSU1v?=
 =?utf-8?B?QklWcE4vVzFld0pFQmVCbzdMZFlHVzd6MkZBODd1UkNsdzNibzNNbFlGRGVs?=
 =?utf-8?B?N0RIUnd5WWFGL3V6K09pSHBKa3YxcWI5Mnl1bTFjazdkZEtpZWdCQXJCbzJL?=
 =?utf-8?B?KzM2V1AwT1pER3diRnA3bUVVRHVXSlhyNTlnV3F3bVVDWnp6em5uR0hvOW56?=
 =?utf-8?B?REhKem5sKytReHNWQWhUaFhFNVczbWsrMW42VHZ6TmdPSUgyeG9UeFZ4aUth?=
 =?utf-8?B?Si9OcUlxNGJ5SnYxKzlDa2lCeGQxZzVkQUVsc0pDbFgwNXpOdTZSL3BPOFo1?=
 =?utf-8?B?a1ZDNUI1ZU96SnR3d3QyR0hqcW1pdWJDVG13bkhKdzhPanNlZFQ5eXBzNEw3?=
 =?utf-8?B?ays0d0xVa1p1dTNVd0Q5elk2TWxycFV0by9KeDdKeEZKQW8rODVCK2pqS3h4?=
 =?utf-8?B?aUVZc05rd0lnR1BMYndzbjVWZTNlNDdJT1hMRmo5a2dpdFVVeXpCYTR4dE5a?=
 =?utf-8?B?OW9jMS85STQyV0xZMlpDRHQ5cjcwRFVRMXdNS2pHdUZZSEtTb21STnNRS0tV?=
 =?utf-8?B?QU5kZ3MwcCtKRFZpNUhmeHhFRVFQTGV6WjJld2tOTk1nQ3ppY282cktkcGh1?=
 =?utf-8?B?YWMwTVI3bkZOQURuR0h4a3VDWW1YV2dpSEcrbGtXdExFenhNSnF2SUcrZlBo?=
 =?utf-8?B?VkYxS0UrRkhRWGF0eWZteHJxR2RpaUlXRzVUM0lHd2pFdlZEdENiK0gvN21X?=
 =?utf-8?B?dzdDWTU0bEt1bGhIOE10ckdodW43UFQwVWJTRnp1UmxrdUpTWjF2cGVKUE5X?=
 =?utf-8?B?V0tqWURqNE84MXJzSkFGQXo4Tm54SmRFN09iTUUrRUQ1N21Ka3BwYzZOZFFi?=
 =?utf-8?B?eHFiRDV6ZmlpTWlFWVAyRDZ6ZnI2RzUyRTdQNVFWb05GOTE5L2ljZXp3NVdm?=
 =?utf-8?B?NWpsdlBRLzRDaXdpRDVTV21Vd2NvT0FLRHp2bmtUR0ZGeGNXNG9qWW5qL0VV?=
 =?utf-8?Q?g8u+7UDXqv6B+Z2HeRDdc/Hrs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbb8c85-3029-41d2-676d-08db57a47667
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 13:33:27.5264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: giuf9V9dIq2kNUYLCO2Huf0AG6rDJ5FrP9MmNx3CP/uspmKKN7sBXmzCBDBSb3rXTI5R+G+0ciyXeHCrFm12+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8961
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXkgMTcsIDIwMjMg
MjoxNCBQTQ0KPiBUbzogU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT47IFdlaSBG
YW5nIDx3ZWkuZmFuZ0BueHAuY29tPjsNCj4gRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNv
bT47IFNpbW9uIEhvcm1hbiA8aG9ybXNAa2VybmVsLm9yZz47IEhvcmF0aXUgVnVsdHVyDQo+IDxo
b3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiBDYzogQ2xhcmsgV2FuZyA8eGlhb25pbmcu
d2FuZ0BueHAuY29tPjsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGlteEBsaXN0cy5saW51eC5kZXYNCj4gU3ViamVjdDogW0VYVF0g
UmU6IFtQQVRDSCB2MiBuZXRdIG5ldDogZmVjOiBhZGQgd21iIHRvIGVuc3VyZSBjb3JyZWN0IGRl
c2NyaXB0b3INCj4gdmFsdWVzDQo+IA0KPiBDYXV0aW9uOiBUaGlzIGlzIGFuIGV4dGVybmFsIGVt
YWlsLiBQbGVhc2UgdGFrZSBjYXJlIHdoZW4gY2xpY2tpbmcgbGlua3Mgb3INCj4gb3BlbmluZyBh
dHRhY2htZW50cy4gV2hlbiBpbiBkb3VidCwgcmVwb3J0IHRoZSBtZXNzYWdlIHVzaW5nIHRoZSAn
UmVwb3J0IHRoaXMNCj4gZW1haWwnIGJ1dHRvbg0KPiANCj4gDQo+IE9uIDE3LjA1LjIwMjMgMTg6
MTUsIFNoZW53ZWkgV2FuZyB3cm90ZToNCj4gPiBUd28gd21iKCkgYXJlIGFkZGVkIGluIHRoZSBY
RFAgVFggcGF0aCB0byBlbnN1cmUgcHJvcGVyIG9yZGVyaW5nIG9mDQo+ID4gZGVzY3JpcHRvciBh
bmQgYnVmZmVyIHVwZGF0ZXM6DQo+ID4gMS4gQSB3bWIoKSBpcyBhZGRlZCBhZnRlciB1cGRhdGlu
ZyB0aGUgbGFzdCBCRCB0byBtYWtlIHN1cmUNCj4gPiAgICB0aGUgdXBkYXRlcyB0byByZXN0IG9m
IHRoZSBkZXNjcmlwdG9yIGFyZSB2aXNpYmxlIGJlZm9yZQ0KPiA+ICAgIHRyYW5zZmVycmluZyBv
d25lcnNoaXAgdG8gRkVDLg0KPiA+IDIuIEEgd21iKCkgaXMgYWxzbyBhZGRlZCBhZnRlciB1cGRh
dGluZyB0aGUgdHhfc2tidWZmIGFuZCBiZHANCj4gPiAgICB0byBlbnN1cmUgdGhlc2UgdXBkYXRl
cyBhcmUgdmlzaWJsZSBiZWZvcmUgdXBkYXRpbmcgdHhxLT5iZC5jdXIuDQo+ID4gMy4gU3RhcnQg
dGhlIHhtaXQgb2YgdGhlIGZyYW1lIGltbWVkaWF0ZWx5IHJpZ2h0IGFmdGVyIGNvbmZpZ3VyaW5n
IHRoZQ0KPiA+ICAgIHR4IGRlc2NyaXB0b3IuDQo+ID4NCj4gPiBGaXhlczogNmQ2YjM5ZjE4MGI4
ICgibmV0OiBmZWM6IGFkZCBpbml0aWFsIFhEUCBzdXBwb3J0IikNCj4gPiBTaWduZWQtb2ZmLWJ5
OiBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiA+ICB2MjoN
Cj4gPiAgIC0gdXBkYXRlIHRoZSBpbmxpbmUgY29tbWVudHMgZm9yIDJuZCB3bWIgcGVyIFdlaSBG
YW5nJ3MgcmV2aWV3Lg0KPiA+DQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9m
ZWNfbWFpbi5jIHwgMTcgKysrKysrKysrKystLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEx
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ID4gaW5kZXggNmQwYjQ2Yzc2OTI0Li5k
MjEwZTY3YTE4OGIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2ZlY19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZmVjX21haW4uYw0KPiA+IEBAIC0zODM0LDYgKzM4MzQsMTEgQEAgc3RhdGljIGludCBmZWNfZW5l
dF90eHFfeG1pdF9mcmFtZShzdHJ1Y3QNCj4gZmVjX2VuZXRfcHJpdmF0ZSAqZmVwLA0KPiA+ICAg
ICAgIGluZGV4ID0gZmVjX2VuZXRfZ2V0X2JkX2luZGV4KGxhc3RfYmRwLCAmdHhxLT5iZCk7DQo+
ID4gICAgICAgdHhxLT50eF9za2J1ZmZbaW5kZXhdID0gTlVMTDsNCj4gPg0KPiA+ICsgICAgIC8q
IE1ha2Ugc3VyZSB0aGUgdXBkYXRlcyB0byByZXN0IG9mIHRoZSBkZXNjcmlwdG9yIGFyZSBwZXJm
b3JtZWQgYmVmb3JlDQo+ID4gKyAgICAgICogdHJhbnNmZXJyaW5nIG93bmVyc2hpcC4NCj4gPiAr
ICAgICAgKi8NCj4gPiArICAgICB3bWIoKTsNCj4gPiArDQo+ID4gICAgICAgLyogU2VuZCBpdCBv
biBpdHMgd2F5LiAgVGVsbCBGRUMgaXQncyByZWFkeSwgaW50ZXJydXB0IHdoZW4gZG9uZSwNCj4g
PiAgICAgICAgKiBpdCdzIHRoZSBsYXN0IEJEIG9mIHRoZSBmcmFtZSwgYW5kIHRvIHB1dCB0aGUg
Q1JDIG9uIHRoZSBlbmQuDQo+ID4gICAgICAgICovDQo+ID4gQEAgLTM4NDMsOCArMzg0OCwxNCBA
QCBzdGF0aWMgaW50IGZlY19lbmV0X3R4cV94bWl0X2ZyYW1lKHN0cnVjdA0KPiBmZWNfZW5ldF9w
cml2YXRlICpmZXAsDQo+ID4gICAgICAgLyogSWYgdGhpcyB3YXMgdGhlIGxhc3QgQkQgaW4gdGhl
IHJpbmcsIHN0YXJ0IGF0IHRoZSBiZWdpbm5pbmcgYWdhaW4uICovDQo+ID4gICAgICAgYmRwID0g
ZmVjX2VuZXRfZ2V0X25leHRkZXNjKGxhc3RfYmRwLCAmdHhxLT5iZCk7DQo+ID4NCj4gPiArICAg
ICAvKiBNYWtlIHN1cmUgdGhlIHVwZGF0ZSB0byBiZHAgYXJlIHBlcmZvcm1lZCBiZWZvcmUgdHhx
LT5iZC5jdXIuICovDQo+ID4gKyAgICAgd21iKCk7DQo+ID4gKw0KPiANCj4gRG8geW91IHJlYWxs
eSBuZWVkIHdtYigpIGhlcmUgb3Igd291bGQgYSBtb3JlIGxpZ2h0LXdlaWdodCBzbXBfd21iKCkg
b3INCj4gZG1hX3dtYigpIGJlIHN1ZmZpY2llbnQ/DQo+IA0KDQpJbiB0aGlzIGNhc2UsIGJvdGgg
d21iIHNob3VsZCBiZSBjaGFuZ2VkIHRvIGRtYV93bWIuIA0KDQpSZWdhcmRzLA0KU2hlbndlaQ0K
DQo+ID4gICAgICAgdHhxLT5iZC5jdXIgPSBiZHA7DQo+ID4NCj4gPiArICAgICAvKiBUcmlnZ2Vy
IHRyYW5zbWlzc2lvbiBzdGFydCAqLw0KPiA+ICsgICAgIHdyaXRlbCgwLCB0eHEtPmJkLnJlZ19k
ZXNjX2FjdGl2ZSk7DQo+ID4gKw0KPiA+ICAgICAgIHJldHVybiAwOw0KPiA+ICB9DQo+ID4NCj4g
PiBAQCAtMzg3MywxMiArMzg4NCw2IEBAIHN0YXRpYyBpbnQgZmVjX2VuZXRfeGRwX3htaXQoc3Ry
dWN0IG5ldF9kZXZpY2UNCj4gKmRldiwNCj4gPiAgICAgICAgICAgICAgIHNlbnRfZnJhbWVzKys7
DQo+ID4gICAgICAgfQ0KPiA+DQo+ID4gLSAgICAgLyogTWFrZSBzdXJlIHRoZSB1cGRhdGUgdG8g
YmRwIGFuZCB0eF9za2J1ZmYgYXJlIHBlcmZvcm1lZC4gKi8NCj4gPiAtICAgICB3bWIoKTsNCj4g
PiAtDQo+ID4gLSAgICAgLyogVHJpZ2dlciB0cmFuc21pc3Npb24gc3RhcnQgKi8NCj4gPiAtICAg
ICB3cml0ZWwoMCwgdHhxLT5iZC5yZWdfZGVzY19hY3RpdmUpOw0KPiA+IC0NCj4gPiAgICAgICBf
X25ldGlmX3R4X3VubG9jayhucSk7DQo+ID4NCj4gPiAgICAgICByZXR1cm4gc2VudF9mcmFtZXM7
DQo+ID4gLS0NCj4gPiAyLjM0LjENCj4gPg0KPiA+DQoNCg==

