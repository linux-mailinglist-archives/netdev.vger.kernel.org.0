Return-Path: <netdev+bounces-3186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A70705EA5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC11728144E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 04:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93425440A;
	Wed, 17 May 2023 04:18:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF73D86
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:18:21 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2074.outbound.protection.outlook.com [40.107.104.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59E010E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 21:18:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAQyvcKsIrUt7/gCIybxBMVqZLbZP+z+qY9SRPZrxypsT/kBJ0zza0tUDU+MzKnwWfWRkGXFBW9+jwAZDlsv3tGv9QljEbTeA1ZBB8x4rWFZFbE+FdejH2vIbazj6jmPfqvr7UwXKHGEoyDQwqACbsLaOFxIkHUlYQUi060+SXUbt+kC90fp3NX96YweBDz6GvH2lQrtrivp1uDsIr76DB+bfvR8gzufg0slmVhuBeDQYLUhreGbLaIhdaVHJiRyvpi9FSgMcK0hP2JvMlNOnpQVglYaeFGbM0tUYPA7xFY+k1YYf6SGzArvtjNvxI7fU0TemFTxwAbC1h1923FgZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQDSeWxYb3m1XBkLAXTXAhaJjHGK04pw973pgBMkq4k=;
 b=aseH4w5lWISOY3Y91DiqMp6xBxAKI9ZTLSBQuzTAjA7TgGLbn1oX78/Oyi7yrxleTAfgIBR8QeaLrl4WF23lr7oq5LrVPp8KxqIx1oxc8HSRUzDzMnUiQ9tHy2RCLjVIfKpQnulpAppPmn1bAiHA40lwmX2ddGOAWeWigGM8lbNPG7pXjEHeurunqD6tZSViKWlLWnn/tFP7/GLg624FgWIF1mct2Ea0O0v1KUngcTg7lkvW8lDmaS51G4VCLV3TOPnGEGRJe2JJtWVhay/IIC2fYlte5ampq7H3AfgPKrXlAFqa50RJvu3PfS55zoOdod+MPVDkRbRdZY44M9fODA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQDSeWxYb3m1XBkLAXTXAhaJjHGK04pw973pgBMkq4k=;
 b=QXeQm1aDN/8ziqmdfRhz/W/wsPewMB2ywPPymVNXjHb8tKiraXMcYtfU3iVj6lGmfTTboWWUfw+H+mhxbR5GEAwBghTHpEN9xwPEptH6CmHamQZSZNzj7zF5+OWrj7oQsq5cxcW6Q8WYTSZVV/ObYuQ0FY8fUFBn45MUdiM91h8=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AM9PR04MB8193.eurprd04.prod.outlook.com (2603:10a6:20b:3ea::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.34; Wed, 17 May
 2023 04:18:16 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 04:18:16 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Shenwei Wang <shenwei.wang@nxp.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>
CC: Clark Wang <xiaoning.wang@nxp.com>, dl-linux-imx <linux-imx@nxp.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "imx@lists.linux.dev"
	<imx@lists.linux.dev>
Subject: RE: [PATCH net] net: fec: add wmb to ensure correct descriptor values
Thread-Topic: [PATCH net] net: fec: add wmb to ensure correct descriptor
 values
Thread-Index: AQHZiDxkF7z2O/imD0KE2UatJdC07q9dz1WA
Date: Wed, 17 May 2023 04:18:16 +0000
Message-ID:
 <AM5PR04MB31393AF1641234ECD2918761887E9@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230516212117.1726491-1-shenwei.wang@nxp.com>
In-Reply-To: <20230516212117.1726491-1-shenwei.wang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|AM9PR04MB8193:EE_
x-ms-office365-filtering-correlation-id: 05698c7b-3400-410c-38f7-08db568dbd02
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 /J+6u9ewlFK+LBImR6DsvSjlH/5W8j1RJId0q5We/KjJGkIcVA1vWeIqQ4Ysne3P7QK+e0OlrR6+vWaqE308+Se3TmWrFP1J43YObazBN278prGHKuoWhLkxwuMlWZqUv0TdbncH8dNWuJXX1qZr6Y0/X9/fdzkPHu625gBNIxxeo7nmV4KXzGuFXu6lm22Q/LQayJ27Nsrc02tIAZ66uOCZE2tDAD3G8CCXfXcaX5W8WHRc4vAluuUaANoF/Bu33VHV4Bqtxf44exc6nWkYgaF2E78gUUu1Sl9LVAOA9sT/IttdZ5w93+wwYQPIcaruAjIyb4enjZDzL5GYoNH4nGTzVC0cUp4kYNjbMkK+bu/1TgWgDSU9TLTWHwZvEpUhc5X5PA67KO2+f/APua7fnQFPhbI8PUPEiD1T+u3O5PICZa+qmnMW6Zc++eUIn6q++S1Yh/9mGbaOoUMS5dYEMpXke5rJlE/woKtMqEDD4tIatkqxln54ak3IUkPgGH9QHkP4b3yFKF2A7AdcFnO2Arx+sXhBnYnrRE1OwUOglWUjBFN5RlonAuWNqhPk308xxObjJqHjuvXgiQWDEhIU7x5fngt768OqvJMrHLFLJAvR9pUXOnAJlC4nbWAX+QKb
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199021)(55016003)(71200400001)(38070700005)(54906003)(110136005)(478600001)(66446008)(66476007)(66946007)(76116006)(7696005)(41300700001)(64756008)(66556008)(86362001)(316002)(4326008)(122000001)(38100700002)(52536014)(5660300002)(2906002)(44832011)(6506007)(8676002)(8936002)(26005)(186003)(33656002)(53546011)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?L2tIY3k3TXkwNzNSTnJud2Z1Yk1nVUluYWprQkthSWlRRkVsS1U5ekVHa2dZ?=
 =?gb2312?B?OHRXVFBBc0UyVG90Q1VSMU51UGpUSVZVSVJVRGN2MTNZdVgzeHFabUlYcEMz?=
 =?gb2312?B?MVdyZnQ4aXRITG5vcGJIbWp6REduV0x2aVlZMTFhOGNvVU93aGpMQVpDWm10?=
 =?gb2312?B?MXA0aVlGQ3N0RjRoZkhvbzhUQzBkQ2hlc0tOanpwelo0Nlh3OTVNcG5vM3V4?=
 =?gb2312?B?MkJNaVJ3aE1XVXlpbFVtZXN1ZUhhYzFMNlQ3V0UxdHh3Yk11MjJBY2podElU?=
 =?gb2312?B?b0dmTThnem1RMWlJdVBSMzJtUnVlbkRTNzQ3YmNPU2x4TXkzQjVuWXJiOGlI?=
 =?gb2312?B?M3lOMEw4N0JJcUs2ckQ0eFJDeW5RVlhyMlVsbU1rUzdhaGFFeXowMk1DbW1v?=
 =?gb2312?B?dmZDYTh2OEswbnR1VDk5T0djc3NUN1phMWxSc2VuMHVYWU4wU21zcnY4bTVB?=
 =?gb2312?B?S041RUJ3QlJESmtKaGdNQTE3SGFYK3VySjdvMWdZTTBQOVlxUzJmQ3EzaFps?=
 =?gb2312?B?SEZaQytZZzF4S2xrd3NzQSsxSUFlTVJRVFYycDFqMmRjVlhVY3ZzMzlxL2Ji?=
 =?gb2312?B?KytXUy9QeFlvN0xqS1dKWWRPRjJjLzh6bHE4UVRUWGZQenRDbWd6ODRjcHhH?=
 =?gb2312?B?a3UwTDZGN291WDh0YlZYWlZsYnhWOGtzK2s0dUtCWWhFWllmNnhSNjJEYit3?=
 =?gb2312?B?N0hLcklKVFBEeVl5djZjU01EYmx2WXllblZpeEdBeHJNOE9acEtaM0FCWWdY?=
 =?gb2312?B?SjFxaVdmMlFVbnMzRklQQ2VBRXNwYXhpYVVkQmltSm1GeDFGVGZZdmhVL1Rp?=
 =?gb2312?B?M0Y3cVkrQkY5MmtnQWs5djBITmJ2d1BKaFhobVlzbGRnZzAxOUxMelNhdWxi?=
 =?gb2312?B?OWhCd2Jib0NMRk1TS01YQ2txVUpDdjAzTjE3WU1tdWZUd0tCUEp1UmJJMmQv?=
 =?gb2312?B?SVpkeDJnMjJXWnhGRFlLeVZPQUQyOEllSmhMbUlxaUtJdTJXeEFYS0dPOGRN?=
 =?gb2312?B?ajZRKzNHSmhBanVJS0UyZEQvOFFtaktJSU5SNnhxUE9xZ2dJbXphKzEyS2Rs?=
 =?gb2312?B?NWFDUVRVMVlPZWxhZVl2Z2Zxbk8yL1hDTEJmV3VOdDJUZm9Zd0EvcllGbGxO?=
 =?gb2312?B?bkc5ZEl0SGNlbkJCR2ZkSklUeTM4YUpWMkNuYWtEbk8vVEE1MUMxdXF1eHFy?=
 =?gb2312?B?LzNpWUY3bElpNm9ZQjNmRzM3RFB1YWE0U0thWkpYcDkwQ1Q5ZWl6Rk81WmZ3?=
 =?gb2312?B?cm10Z1BQRTlWZUZvRUVab1d6bHVzOFFqa2loK2xuVC9icERlelBkYzQ2eEts?=
 =?gb2312?B?SDR4VlNaUEpiaWpmUzVlaTBLeldabUdCQUVtMng4dnJPSys1ZE1JRlYzWHB1?=
 =?gb2312?B?L0VpclpLUHRpNzF2eDA1NTc3TndVZkI2QUI4eWRmQ2QrNHM3alA5bEdlSG1H?=
 =?gb2312?B?UVBRN0s1R2VGWGRVd211dEJpaGZmTlBxODJ4QnY4UEdVYTBSL3NvT3JkcjVG?=
 =?gb2312?B?Zks5ODhzdVZrOW1nOVczSXlBRmh1YThEVFhUeEY3OENXeCtjVTBxSDZrbXd5?=
 =?gb2312?B?d1V5dnhvOTBxcVRObVM2Z2VPSzh5RVRLMVoxY1RWM3JKSUFZN1hnQUtKZkxp?=
 =?gb2312?B?VDZLa09ONnk4bjN6eVY2NWNnWHk3NTJVbUNCaWxZTHM2aTB1M0dueFZxSHZ1?=
 =?gb2312?B?RzM1OXQ0bTlZRDcwKzBJdmJWMjBSR3hZdE1TL2VqMURUdC8wenZTOTUzWFdz?=
 =?gb2312?B?T1Y1OGVUbGIyd1VmK1J4UzQxczhnMndUTFZhQ2U0amlkWlNBd0NGSkF2N1BK?=
 =?gb2312?B?YkFndEdIYi8vNHZuVmtYMUNxNHI2d1RpYU5CRC9iK0RUYXRScFhNUjF2cG0w?=
 =?gb2312?B?aFc3eHJXSkQ0d1pnM2d3eC9TbU1ta0c2aXBpdFlDSytqeGp6VnUwTm54VE9G?=
 =?gb2312?B?bDdxQUV6d2xzWnFpRHA0S3JQc0o1VVFEUTVWaFRxVndFbjNIallmRjdqWkt5?=
 =?gb2312?B?MVV5SEN3aUU3bW13c2hTVnVGMXRHSmthdXlDM0lybElZMVB5dkVaUGNPWlB0?=
 =?gb2312?B?TWpNaFBmT1Yvbi9FZXBqL25DbHpBY3RLTlBDenZnMU1oTVRnWG5KbnRqNmps?=
 =?gb2312?Q?auFM=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05698c7b-3400-410c-38f7-08db568dbd02
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 04:18:16.4252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OMA7TU6seXhMvVudjVdyhIKVjV/q6TleTwOX5ysUl+5TrSJh1yEs5s0/8QW2U0puMr4qb7bYAWqM/E6+HdV0zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8193
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaGVud2VpIFdhbmcgPHNoZW53
ZWkud2FuZ0BueHAuY29tPg0KPiBTZW50OiAyMDIzxOo11MIxN8jVIDU6MjENCj4gVG86IFdlaSBG
YW5nIDx3ZWkuZmFuZ0BueHAuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsNCj4gRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5z
a2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47
IFNpbW9uIEhvcm1hbiA8aG9ybXNAa2VybmVsLm9yZz47DQo+IEhvcmF0aXUgVnVsdHVyIDxob3Jh
dGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tPg0KPiBDYzogU2hlbndlaSBXYW5nIDxzaGVud2VpLndh
bmdAbnhwLmNvbT47IENsYXJrIFdhbmcNCj4gPHhpYW9uaW5nLndhbmdAbnhwLmNvbT47IGRsLWxp
bnV4LWlteCA8bGludXgtaW14QG54cC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBp
bXhAbGlzdHMubGludXguZGV2DQo+IFN1YmplY3Q6IFtQQVRDSCBuZXRdIG5ldDogZmVjOiBhZGQg
d21iIHRvIGVuc3VyZSBjb3JyZWN0IGRlc2NyaXB0b3IgdmFsdWVzDQo+IA0KPiBUd28gd21iKCkg
YXJlIGFkZGVkIGluIHRoZSBYRFAgVFggcGF0aCB0byBlbnN1cmUgcHJvcGVyIG9yZGVyaW5nIG9m
DQo+IGRlc2NyaXB0b3IgYW5kIGJ1ZmZlciB1cGRhdGVzOg0KPiAxLiBBIHdtYigpIGlzIGFkZGVk
IGFmdGVyIHVwZGF0aW5nIHRoZSBsYXN0IEJEIHRvIG1ha2Ugc3VyZQ0KPiAgICB0aGUgdXBkYXRl
cyB0byByZXN0IG9mIHRoZSBkZXNjcmlwdG9yIGFyZSB2aXNpYmxlIGJlZm9yZQ0KPiAgICB0cmFu
c2ZlcnJpbmcgb3duZXJzaGlwIHRvIEZFQy4NCj4gMi4gQSB3bWIoKSBpcyBhbHNvIGFkZGVkIGFm
dGVyIHVwZGF0aW5nIHRoZSB0eF9za2J1ZmYgYW5kIGJkcA0KPiAgICB0byBlbnN1cmUgdGhlc2Ug
dXBkYXRlcyBhcmUgdmlzaWJsZSBiZWZvcmUgdXBkYXRpbmcgdHhxLT5iZC5jdXIuDQo+IDMuIFN0
YXJ0IHRoZSB4bWl0IG9mIHRoZSBmcmFtZSBpbW1lZGlhdGVseSByaWdodCBhZnRlciBjb25maWd1
cmluZyB0aGUNCj4gICAgdHggZGVzY3JpcHRvci4NCj4gDQo+IEZpeGVzOiA2ZDZiMzlmMTgwYjgg
KCJuZXQ6IGZlYzogYWRkIGluaXRpYWwgWERQIHN1cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBT
aGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jIHwgMTkgKysrKysrKysrKysrKy0tLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBpbmRleCA2
ZDBiNDZjNzY5MjQuLmJhNDMzNWQ1ZGRjMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gQEAgLTM4MzQsNiArMzgzNCwxMSBAQCBzdGF0aWMgaW50
IGZlY19lbmV0X3R4cV94bWl0X2ZyYW1lKHN0cnVjdA0KPiBmZWNfZW5ldF9wcml2YXRlICpmZXAs
DQo+ICAJaW5kZXggPSBmZWNfZW5ldF9nZXRfYmRfaW5kZXgobGFzdF9iZHAsICZ0eHEtPmJkKTsN
Cj4gIAl0eHEtPnR4X3NrYnVmZltpbmRleF0gPSBOVUxMOw0KPiANCj4gKwkvKiBNYWtlIHN1cmUg
dGhlIHVwZGF0ZXMgdG8gcmVzdCBvZiB0aGUgZGVzY3JpcHRvciBhcmUgcGVyZm9ybWVkIGJlZm9y
ZQ0KPiArCSAqIHRyYW5zZmVycmluZyBvd25lcnNoaXAuDQo+ICsJICovDQo+ICsJd21iKCk7DQo+
ICsNCj4gIAkvKiBTZW5kIGl0IG9uIGl0cyB3YXkuICBUZWxsIEZFQyBpdCdzIHJlYWR5LCBpbnRl
cnJ1cHQgd2hlbiBkb25lLA0KPiAgCSAqIGl0J3MgdGhlIGxhc3QgQkQgb2YgdGhlIGZyYW1lLCBh
bmQgdG8gcHV0IHRoZSBDUkMgb24gdGhlIGVuZC4NCj4gIAkgKi8NCj4gQEAgLTM4NDMsOCArMzg0
OCwxNiBAQCBzdGF0aWMgaW50IGZlY19lbmV0X3R4cV94bWl0X2ZyYW1lKHN0cnVjdA0KPiBmZWNf
ZW5ldF9wcml2YXRlICpmZXAsDQo+ICAJLyogSWYgdGhpcyB3YXMgdGhlIGxhc3QgQkQgaW4gdGhl
IHJpbmcsIHN0YXJ0IGF0IHRoZSBiZWdpbm5pbmcgYWdhaW4uICovDQo+ICAJYmRwID0gZmVjX2Vu
ZXRfZ2V0X25leHRkZXNjKGxhc3RfYmRwLCAmdHhxLT5iZCk7DQo+IA0KPiArCS8qIE1ha2Ugc3Vy
ZSB0aGUgdXBkYXRlIHRvIGJkcCBhbmQgdHhfc2tidWZmIGFyZSBwZXJmb3JtZWQgYmVmb3JlDQo+
ICsJICogdHhxLT5iZC5jdXIuDQo+ICsJICovDQpJIHRoaW5rIHRoaXMgZGVzY3JpcHRpb24gc2hv
dWxkIGJlIG1vZGlmeSBhcHByb3ByaWF0ZWx5LCBiZWNhdXNlIHR4X3NrYnVmZiBpcw0KdXBkYXRl
ZCBhdCB0aGUgZmlyc3Qgd21iKCksIG5vdCBoZXJlLg0KDQo+ICsJd21iKCk7DQo+ICsNCj4gIAl0
eHEtPmJkLmN1ciA9IGJkcDsNCj4gDQo+ICsJLyogVHJpZ2dlciB0cmFuc21pc3Npb24gc3RhcnQg
Ki8NCj4gKwl3cml0ZWwoMCwgdHhxLT5iZC5yZWdfZGVzY19hY3RpdmUpOw0KPiArDQo+ICAJcmV0
dXJuIDA7DQo+ICB9DQo+IA0KPiBAQCAtMzg3MywxMiArMzg4Niw2IEBAIHN0YXRpYyBpbnQgZmVj
X2VuZXRfeGRwX3htaXQoc3RydWN0IG5ldF9kZXZpY2UNCj4gKmRldiwNCj4gIAkJc2VudF9mcmFt
ZXMrKzsNCj4gIAl9DQo+IA0KPiAtCS8qIE1ha2Ugc3VyZSB0aGUgdXBkYXRlIHRvIGJkcCBhbmQg
dHhfc2tidWZmIGFyZSBwZXJmb3JtZWQuICovDQo+IC0Jd21iKCk7DQo+IC0NCj4gLQkvKiBUcmln
Z2VyIHRyYW5zbWlzc2lvbiBzdGFydCAqLw0KPiAtCXdyaXRlbCgwLCB0eHEtPmJkLnJlZ19kZXNj
X2FjdGl2ZSk7DQo+IC0NCj4gIAlfX25ldGlmX3R4X3VubG9jayhucSk7DQo+IA0KPiAgCXJldHVy
biBzZW50X2ZyYW1lczsNCj4gLS0NCj4gMi4zNC4xDQoNCg==

