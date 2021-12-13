Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E7747200C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 05:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhLMEkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 23:40:03 -0500
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:37979
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231736AbhLMEkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 23:40:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox3N0QMCaMtyMqjndirqYlvjNfFLkcpbK4HgXBrpH3NqglXDWVBmOUiShE1W4l8mQuVn2ROJiDsAA50ExVf+GoGHm/kXGoa6MyBKVGIO6QFGabhbtz2Zdfvtss+XIxra2bULK8vuqyjSnfDy6c7vjCVdGa/tADG7Ie53vZeRx0J2vi1r42JncUcgQuhNcfJXLvI/m6yHySWDkPkg3+46wFmKpUflnQkoxx4s6CeYfkfmoRAMxNW8i49jd23gm9Bz6/1Cx17TMc2MlF+2BKS7+Vw8Yn7LF0LFoT9bCOGoxuRxIB5eHB1+u66aPk7yg4wSyquVgR5iZlPDBpVWQSpVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooYOiUPQHd/HUMtUwOrlrrizw7yzKjQqr4xk5LbtQOE=;
 b=lcauAB8oTWhfsszC4D6/1P9Oh8Rhj0JTiClVbv+95Yv1fzoZYMNZ8pmlminYaF7ThGhxSSRK4IAxz8rHCNhXjM0ex+YAwLI1Nu0vRMlcoBMxnZXaU+rnQfkgG4zwob8Cw+8Pj4KpKEpTaL0LhpvDjwCym5SUOKxuJ0PpTldLHqSAaCBkhBCgbo545WA04yefatlBKsDr5W2TFqjuQa/lkzIAxG+LzliT16ZafDx3lY6D1l1w8bOuOf+weqF98gCBKSa/3uWTUX2WLn6y6+5yDBOe0aW4C4opjgs0ri5zK89CRWvSjfwyAHD48m0yut3F3scWFMTaNU860Ggrro2cQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooYOiUPQHd/HUMtUwOrlrrizw7yzKjQqr4xk5LbtQOE=;
 b=lh1+Bc/WNscSNrJCx6V01L0RYB9MW1iwIF4SqBFkn6W0cGIvUDYDrEI6Wb4yQ70EGt+8b36d8avLg8N2bw9ww5BreTFMmtohdb9jQV6L3msrkreZndu0FQoC/iUkhQEENleJxBHX6AFVdPIl6sLSHzGG8pKnlcGYmQNDqNWDsoY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7705.eurprd04.prod.outlook.com (2603:10a6:10:209::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 04:40:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 04:40:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "philippe.schenker@toradex.com" <philippe.schenker@toradex.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: phy: perform a PHY reset on resume
Thread-Topic: [PATCH net-next] net: phy: perform a PHY reset on resume
Thread-Index: AQHX7o9UVCTxfzxrGEuJcbM+JSMkN6wv2JcQ
Date:   Mon, 13 Dec 2021 04:40:00 +0000
Message-ID: <DB8PR04MB6795CF540670BF328C637E2DE6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
 <20211211130146.357794-1-francesco.dolcini@toradex.com>
In-Reply-To: <20211211130146.357794-1-francesco.dolcini@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bdc3c22-ff12-4eac-a414-08d9bdf29f8d
x-ms-traffictypediagnostic: DBBPR04MB7705:EE_
x-microsoft-antispam-prvs: <DBBPR04MB770580305AEB46FAEB78A8D5E6749@DBBPR04MB7705.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iNQSBEqSzUNHQi6t7vtJmizNICbOudB9guLpB+T/JgYCB+3Uzo6Jp6zQhLiLVTU9Ce7PH3GnXmeNh+gAeJKZ+xowtAo+x5SGQ0ijlkNqbRliaIEb4NWj3kbRMm3cMWXImVVc1h/cUC0oZrH7OUJb3BmYUG1gLpkvjdRxinO1hN1YRg8t9gnMo6vLI5mLomDwHVrvNuFjhDLpaW2QiR0Fc6esqsEj9Omv12J3MkaHMGK2/SwbijXjVA+qsExN2dNNFo8rI4Vz8rvv6NslDMAErL7IfvjxRjfzBmXcE6H/Dgw0/VY+un3u7vyu/lDybZ/2rTZ92AToRSzl8DlhMaOnt3XIzQjP+j6zGnihDa+TNpmonq2hAY2UbgZ0BaxhfWiWbMZEO4MtL03nWDmlvGPiws3apkte9P2zBNUawvo80btn85v2OPaC3+NdL38zaFDO/NxEstloX2SQO26fbZVZQvmoagAoMn1etOMZ0RQOjjD0CqmMGx9+Yhz/TOECDbh79BwDF+ApXZHAblCNxdtNr36Eq2xmOyqFCR9tcx/ilXWWINfNk6wiZ0GuNTg6AC/PpX4WoQjUAmF55rC2cEyp1RY0LxIhPuQ3aBCFNa5Wt3QzUhwro34jb0ueGzJUHDLciToEv81L8fjfhgS9mfrNtmhZYzPiF18ULLn/Gy+oEaCs9P6JXd51ktTGet7Ma4nQOOq5MOG3J7hEhahviKyR6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(4326008)(38100700002)(54906003)(110136005)(316002)(38070700005)(33656002)(122000001)(8936002)(2906002)(66556008)(7696005)(966005)(45080400002)(186003)(9686003)(26005)(8676002)(53546011)(64756008)(71200400001)(66446008)(6506007)(66476007)(76116006)(66946007)(52536014)(83380400001)(55016003)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NHhjMW91MFFoUHZhWWVkNHJtamRCQ2NCZWFzYlZHSkZmUktHS0xjQVpCUlhj?=
 =?gb2312?B?ZitQY0ZPeDVYQk10VFhsYXo2T0lmMURrUzBJemZyZ1BjZFpTSjB4UHNsKzhG?=
 =?gb2312?B?bWVoZ1gzQ1d0cmRRb1VKMTJab0pKQm9hRXhpaWI0VEJUc3M3QUd6TzNIZHAy?=
 =?gb2312?B?ZWlBbE05VFVjYUxtRFVWNVphVUhHRW9jMVZWcTFrNWpMdjYvQk1ubTFrdWRH?=
 =?gb2312?B?c2JkYTE4RWtDMUlLdWhGTDJWWWVuUXZqRmxXWUFaOUlGUEZtY2ttNmZkbWdh?=
 =?gb2312?B?dGp5Z1VjR2NsUUtVa0pacDhndE84MDUrWUZEZUVVL0xWUkErTitFM3BjOHMx?=
 =?gb2312?B?c0lnWG52UFVUR2JycG5NaS9xSFBZNTdLQU5iL3ZkdnhIRDZkblpwWG5sRjZu?=
 =?gb2312?B?NWVabTZuMllFVjh5ODhlSXVRU0JsL2xPZXdMYXF0WFQ2MWlDSWRaQWNPT3VM?=
 =?gb2312?B?SVAwcWQ2bHVUY1NtUDR6WUZCNzRMUnhuaVJuQ2F4MGxrQVhMQnNtU3VYWXRM?=
 =?gb2312?B?c2R0cEExZTJwV0MyL08rdGNXVE5qREtjdEx4QUpCZDl0alh5QUtZd3ZwcWdv?=
 =?gb2312?B?V0dLUFQ4Z2s1ek0zUnlKZ2ZvSHVTeDYwT01oNTlheGRWbWIya0o0eWM4Nmpk?=
 =?gb2312?B?UHptNkNWVWtKSlloOFVsQVZMWXdsZUEvQlVvL1l6ZHdNTnBtRkowdTVYRElO?=
 =?gb2312?B?RkV3SDArdkFEM0hZa1Y2WE9QcXd4L3V2OFlpZTV1YUFVckt0V0pOVnF6SXBS?=
 =?gb2312?B?eG9WZTdVSTR6WXJOcXZPU0V3ZXMxOGVyVTd0ZnhNbE51bmxvdmx3dkovQUxr?=
 =?gb2312?B?dWRYYndWT2dRdzJQUXd1cllzUnpoYWNJVGkrSTFTS2FtWjZYMUZKdUVTMzhl?=
 =?gb2312?B?dXUwNUFuS092MWdWOG5qM3VYWkhva29BTWtSL1drQTNQME9SOUQ1VjMya1VU?=
 =?gb2312?B?MnlhOERPc1U1MXNheGdWb3lRdEVkYnpFQTF4TVEwUzBLNCtySzdvRU5pRjZL?=
 =?gb2312?B?T1ltQUNkZnBxMktkRk5rY2dlcGN1eUplWTBZVTQwSVUyaC8zcTJob3NvbElk?=
 =?gb2312?B?THUzOW1CTlhMYkFiOWFvTnBOVTB4WitoZUhHcnRWTml0YUpESjNKMzVKNnBD?=
 =?gb2312?B?RnF6clZWbkhuY2pBUEYrMDErTUpvbXVpaXl1cTRxVUNIZVphUkRNN2FIOVZ3?=
 =?gb2312?B?OVExWFVCMkMzSmpmQVB2YUVGN0tFV055eWRHSTB6a2Q0ZU93M1dzOHM4MFFa?=
 =?gb2312?B?QjdEWXRYS2JBbGVVL2ZCdXUxLzN2T0t5MmZFSzdrYXhLMVpsaUk3TUZ3cWI5?=
 =?gb2312?B?MDB1ZXdYVkxSL3lRNEFxRWJEZ0Y2TC9GZFpjMHIzQXZsMSsvU3h0aWs3UVF3?=
 =?gb2312?B?MG1FQkt3dU5VU2t4S0xjR0pTWHkreDRiTFliWE5kTjJvUjFoSkxPdEZ4Vkt3?=
 =?gb2312?B?MElDRjdOT0hzL0dXOHZSMUdUMXZxbmlSVDdOclQ2L1dWWHpCaE5RNWRPRG12?=
 =?gb2312?B?S3FmSG5mRUVCTUpmRllpeGVHVnViZXJ5RXJ4WEVwUmpiV3pWWU53Q1RuSUtX?=
 =?gb2312?B?SjE0L2pxdCsyQlF1RU9OcHVhQ3VRWmdEVC9PZCtwV08rTnpyaVZCMU9nTWFG?=
 =?gb2312?B?aEcrdVZzbVk5MXh2R1lyOUdxRkpyUXMySmdndjMrbWt3NktyVWFHUkgxU2pr?=
 =?gb2312?B?L2dBSTNpWU9NeFJjN2EzL05RVWxlczlVQW0ycHpER0JuMDNUYVlCNjgvNzE0?=
 =?gb2312?B?SW5OZUhxeHozaTV4QThnWHl0NzFDYS9uZ0JiOUIyMmpvR01pWDRsaVhFU3Zt?=
 =?gb2312?B?emRTYWg4YVdtdHRmck92RlY4S0RpT2s1TzVJTk1RQUJMeXZ4eWZrd09iZmNo?=
 =?gb2312?B?ejBCb2RESktucFZNV3BvR2w4aUhBZ2VRdmxOWlZ2dDVVQkpCZ2oxb1A0MWpv?=
 =?gb2312?B?YXJFSmdXeGVEMHFkNkFnSkh2ekVJMXNjbW80WFFwMFdlM3YvVmIrZkRHUWln?=
 =?gb2312?B?MzRNZHkrbFlhLy9ES1RyTXhvK09hTUc3a1VYdHdQQ094SnQ5UzB5RXg3bXZI?=
 =?gb2312?B?eFF1MmVDalR0LzVMMzE4dlhPM0NWSkZsMzI0SExDR1lYVEVRdXpXRGZTUnhQ?=
 =?gb2312?B?N0VLU0lNMzJTa2ZRZFhscXIvYjRtSWRiZnpNUytBUkZmem5RazdmQVZCTlBm?=
 =?gb2312?B?OEE9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdc3c22-ff12-4eac-a414-08d9bdf29f8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 04:40:00.4349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T3b+/k4G5cQt8Yj5f7XkEPp56dPyh5Pv9Nby2ywMx3lHta0l7BXkLY+auEIwLj19py8n0YIaMEwd4FHDrofB7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmFuY2VzY28sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
RnJhbmNlc2NvIERvbGNpbmkgPGZyYW5jZXNjby5kb2xjaW5pQHRvcmFkZXguY29tPg0KPiBTZW50
OiAyMDIxxOoxMtTCMTHI1SAyMTowMg0KPiBUbzogcGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5j
b207IGFuZHJld0BsdW5uLmNoOyBKb2FraW0gWmhhbmcNCj4gPHFpYW5ncWluZy56aGFuZ0BueHAu
Y29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZmVzdGV2YW1AZ21haWwuY29tOyBrdWJh
QGtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4QGFybWxp
bnV4Lm9yZy51azsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRnJhbmNlc2NvIERvbGNpbmkg
PGZyYW5jZXNjby5kb2xjaW5pQHRvcmFkZXguY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5l
eHRdIG5ldDogcGh5OiBwZXJmb3JtIGEgUEhZIHJlc2V0IG9uIHJlc3VtZQ0KPiANCj4gUGVyZm9y
bSBhIFBIWSByZXNldCBpbiBwaHlfaW5pdF9odygpIHRvIGVuc3VyZSB0aGF0IHRoZSBQSFkgaXMg
d29ya2luZyBhZnRlcg0KPiByZXN1bWUuIFRoaXMgaXMgcmVxdWlyZWQgaWYgdGhlIFBIWSB3YXMg
cG93ZXJlZCBkb3duIGluIHN1c3BlbmQgbGlrZSBpdCBpcw0KPiBkb25lIGJ5IHRoZSBmcmVlc2Nh
bGUgRkVDIGRyaXZlciBpbiBmZWNfc3VzcGVuZCgpLg0KPiANCj4gTGluazoNCj4gaHR0cHM6Ly9l
dXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJG
bG9yZS5rDQo+IGVybmVsLm9yZyUyRm5ldGRldiUyRjIwMjExMjA2MTAxMzI2LjEwMjI1MjctMS1w
aGlsaXBwZS5zY2hlbmtlciU0MHRvcg0KPiBhZGV4LmNvbSUyRiZhbXA7ZGF0YT0wNCU3QzAxJTdD
cWlhbmdxaW5nLnpoYW5nJTQwbnhwLmNvbSU3QzQwOA0KPiAyNThiODZmZWM0YzM5YTFiNzA4ZDli
Y2E2NzU1ZiU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTcNCj4gQzAlN0MwJTdD
NjM3NzQ4MjQ1Mzk0Mjc4MTA0JTdDVW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pDQo+IE1D
NHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0Ql
N0MzMDANCj4gMCZhbXA7c2RhdGE9bTE3UTViM0NaVkk4OXhtcGxWVndWdkNIRVhack1rWTZkWUlB
bXoydjNDRSUzRCZhDQo+IG1wO3Jlc2VydmVkPTANCj4gU2lnbmVkLW9mZi1ieTogRnJhbmNlc2Nv
IERvbGNpbmkgPGZyYW5jZXNjby5kb2xjaW5pQHRvcmFkZXguY29tPg0KPiANCj4gLS0tDQo+IA0K
PiBQaGlsaXBwZTogd2hhdCBhYm91dCBzb21ldGhpbmcgbGlrZSB0aGF0PyBPbmx5IGNvbXBpbGUg
dGVzdGVkLCBidXQgSSBzZWUgbm8NCj4gcmVhc29uIGZvciB0aGlzIG5vdCBzb2x2aW5nIHRoZSBp
c3N1ZS4NCj4gDQo+IEFueSBkZWxheSByZXF1aXJlZCBvbiB0aGUgcmVzZXQgY2FuIGJlIHNwZWNp
ZmllZCB1c2luZw0KPiByZXNldC1hc3NlcnQtdXMvcmVzZXQtZGVhc3NlcnQtdXMuDQoNCkxvb2tz
IGZpbmUgZm9yIG1lLiBXZSBjYW4gdHJpZ2dlciBhIGhhcmR3YXJlIHJlc2V0IGZpcnN0LCB0aGVu
IGZvbGxvd2luZyBhIHNvZnQgcmVzZXQgYW5kIHBoeQ0KY29uZmlndXJhdGlvbnMsIHRoZSBsb2dp
YyBzZWVtcyByZWFzb25hYmxlLg0KDQpBbHNvIG5lZWQgUEhZIG1haW50YWluZXJzIGdpdmUgbW9y
ZSBjb21tZW50cy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYyB8IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvcGh5L3BoeV9kZXZpY2UuYyBiL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gaW5k
ZXggNzRkOGUxZGMxMjVmLi43ZWFiMGMwNTRhZGYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L3BoeS9waHlfZGV2aWNlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0K
PiBAQCAtMTE1OCw3ICsxMTU4LDggQEAgaW50IHBoeV9pbml0X2h3KHN0cnVjdCBwaHlfZGV2aWNl
ICpwaHlkZXYpICB7DQo+ICAJaW50IHJldCA9IDA7DQo+IA0KPiAtCS8qIERlYXNzZXJ0IHRoZSBy
ZXNldCBzaWduYWwgKi8NCj4gKwkvKiBwaHkgcmVzZXQgcmVxdWlyZWQgaWYgdGhlIHBoeSB3YXMg
cG93ZXJlZCBkb3duIGR1cmluZyBzdXNwZW5kICovDQo+ICsJcGh5X2RldmljZV9yZXNldChwaHlk
ZXYsIDEpOw0KPiAgCXBoeV9kZXZpY2VfcmVzZXQocGh5ZGV2LCAwKTsNCj4gDQo+ICAJaWYgKCFw
aHlkZXYtPmRydikNCj4gLS0NCj4gMi4yNS4xDQoNCg==
