Return-Path: <netdev+bounces-5283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C07F4710927
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:47:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 880612814F0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 09:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AC3DF55;
	Thu, 25 May 2023 09:47:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA63D301
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:47:00 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2086.outbound.protection.outlook.com [40.107.105.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854C4A9;
	Thu, 25 May 2023 02:46:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MfU1WGGpMWIDU48BLSpHCSsfasi3lqy4Os+L8+WNmgh10nCFey5xLOiuqL+cNLmdwBXercdirozouoQuiiyU9sjviMMgKhUHXmNeJrmtlN87NIjQZdAFXKHwWO9Q7LAHB25X0QGa4c3zyNG+eKKDFHtfHf3n+1JYvob43UForzXLuJxnoMWAdVMGSBwGrqkh4kg3iMvtrlkGraOEAoM4XupZpWgJOMIDW+BvqUDMpfNT3jT01c6HhAljapZSgjbbcB+PvmUYzukptFJGHnibOOqDc+OUVq4qJ9W7+G8lv44U6NgdJX0rfb9nO+/eyGZBmYsrHtTKOHVXV1XZZtpxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4AOxuBMkGqbkqaST1daTeOfgf+RVcE5uRuYDziO5n7o=;
 b=I9VIiecCcz50Pw0kgjOPhKI19h9Mqq53KtExMJ2qM1H3pxaaJ+T+1P8WL2fMhenxccedk4i+TiTtPKUi/bYV2XYB1kjQPQq3issjhD0DxCxtnua4JyidWKrMFGlPuqMovDEWs8Ipv746nM1zY8eR3Tg0r54pCbX7rM5iF2/qQ3PdNy1lnw8qiJZaUwlsWlNBZariJO3FWyk/JK0NSg4fWC27Eg5vKxBkQpQLTz9u0nEvROzgi9rUFXvFA73JAo8fjoNb8CtVY4KMbyCalxm2bxolCpLwjO5RzIRU0GFawZzH6edXSqs9+aNWcr4P9yYLQcUWbav5gowayoPEaX1Dzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AOxuBMkGqbkqaST1daTeOfgf+RVcE5uRuYDziO5n7o=;
 b=Q42V0i8E3uRjTwHC+eGinipaa24wGYSgg2GilPR9ESGSCRaFGFmiy10duxssDVkf6Iuw1yZmFm8F+WtqEBVL9lNczw0d4gWGPqi2uUTOyrWrXqS20TpKCBNrJj+KgKE0W1NWgSlNe53CLfCSGe4PpWmIjzBUEUYog6bIzheAYTE=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by DU2PR04MB8791.eurprd04.prod.outlook.com (2603:10a6:10:2e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 09:46:54 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 09:46:54 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, dl-linux-imx <linux-imx@nxp.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: fec: remove last_bdp from
 fec_enet_txq_xmit_frame()
Thread-Topic: [PATCH net-next] net: fec: remove last_bdp from
 fec_enet_txq_xmit_frame()
Thread-Index: AQHZjuToAdjg79t7vkOJMZ+/LVMoXq9qs0IAgAAKGCA=
Date: Thu, 25 May 2023 09:46:54 +0000
Message-ID:
 <AM5PR04MB3139757DD806591C0E2BFCC188469@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230525083824.526627-1-wei.fang@nxp.com>
 <ZG8lpJvFnZlA3w2q@corigine.com>
In-Reply-To: <ZG8lpJvFnZlA3w2q@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|DU2PR04MB8791:EE_
x-ms-office365-filtering-correlation-id: f014e7aa-f361-4c17-4a7e-08db5d04f957
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 7OeBoKoyCONfqZnKfBXFLEyQZUsD2aktEysU/v6DB10rRmKZUiQ+gSiQ5ZBWY80hp5K29tqK+LWKpafOMi9EYL6B/25ram6WwnYIXP+1kwFXP/jyD9xIbNCAlQzJyzQ9/yPIXOeFZd+cB+ECHMMWHE6Ni3e7scQVaUY6bEjRSBeWvVCHEPI42kxb/wYMtU9Fbb7xDMWRrtvN1H2DFin7DqDQGKr3eD0IoVx/ZBYplxiXVmtvB6jdS9nxx8g/VhQ7E2kumTbtsLxBo4P8OI1sOPdOaG+ebHZhhcppXUGJUWXfju603ckAfBLtDEONWcYu15rBXmzAMdy4ZsMgi2d3x8qw1E4jyz2fxlVdzJWmy6L+JQmhidH2Anl847gO2EGja8tZ4iV+H1cpzEBReZx1erX8WhUxSf7E2NU2hYnZdKyUR6Jq3ddCyXw7XDPQVs99Jn34/kZZjh2A9qAViWp+xKTBhdsDkxvz8N8PdWZTuAbVm323iYcc/OwN1+8Aeuxs3FaVpBFjG+g6rawI5PTK2+T9gHNblGuXEihHmc6rW03Hn6GSNQvBx2fS0b+KiZYrUk6z+KPy0xwmYdDTLpTMrTpwN7lsh8eNAyvCTe7ulk/Sg4KFusEUVSY6X60IoWB1
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199021)(54906003)(4744005)(2906002)(52536014)(5660300002)(8676002)(8936002)(44832011)(7696005)(4326008)(41300700001)(76116006)(66556008)(66476007)(66946007)(6916009)(478600001)(66446008)(33656002)(64756008)(71200400001)(55016003)(316002)(9686003)(6506007)(38100700002)(26005)(53546011)(122000001)(86362001)(186003)(83380400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?NW1qSlhWTE1xNFVCN0tSZk1haE90MzNXU0MxclJ4V0J1M29IN1E2bTFRSXQ3?=
 =?gb2312?B?aFExRllSaWgxTitwWElPWVVkU1VxNWQ4ZW96MzcvQ3h5WWJTdTdiZEY0SC9Y?=
 =?gb2312?B?YlFLUnVPeDFLazN6Zm9Wc24yNFVxblc2MUhwOUFPajluZ3k3QTNrSDRGeTk1?=
 =?gb2312?B?bEV0VGh2aDdyVW5MbmY4b08rMmVoaHpBNHQ0RktaVnBzenl3cjNGVytuamRE?=
 =?gb2312?B?bzlpQkNRYnR5TkMxN3E0ZTlqanlyZGE2Z29CZVlFaHk3SUxUWmJ1MUtKYzUz?=
 =?gb2312?B?YTNQdE9pYkFxai9CNXh4SkVZMXgvUDhEbkpSbEtXeVEwc21pWHNjNWFCUWMv?=
 =?gb2312?B?YXNsdUVycGR3Ujh0RE85aXN3aFB3cWt2QllrWm1tcXpaZTllZFJ0VTYySjBo?=
 =?gb2312?B?R2VBWUpRT29ra3NCdkpuVU1tOXQ3Q3l6SC9QcURDaG9LeDQvTGhmMnFWcmZj?=
 =?gb2312?B?a092OUlmRlMybFhzeTRVMGpQdnJReGlIRzZNOVlTSm9CRWMwYStiRnFXaHNI?=
 =?gb2312?B?YkpMamNGVVF3cy9Zc3BkQnNYQU80d2xSVGFnUmVHU2x0TU5BbGMxcVJPU0ZD?=
 =?gb2312?B?QStqeGhyMVdlNGxTTVk4RFk3RWNMSmdybWZQVkJjUmw2eDNZMFFyY1ErMEpO?=
 =?gb2312?B?ajhJYTFhTG5KNysxSVF6RzllL25LMHg4YytxYURweUxRVUhibzA2alE5Z2FF?=
 =?gb2312?B?RFFuRWVVTXM4WTVJWHZsOVBBRDhlVnRBMDNoUmhQL1dVWnN2enhlWGxTSVFj?=
 =?gb2312?B?TlJWVTljaDIwWTd1QlduZUlFbDZwR1h0WCt4cHg2aTNpNzJnZlp6M0V6UUFG?=
 =?gb2312?B?ZGM0V21DbDRucXNPcEpYVmU3OVFQVllScmdCWUt3bXE3RDhFdmlRR2NjaUJT?=
 =?gb2312?B?SENUbFN5WEFYSzE3b3JEYWluNVpOeFFRck9FenpRZzJZUHF1MHlLT3EyZ1k2?=
 =?gb2312?B?eS9qTGlFalRvTGVzOVhoSjZvMlZKOGs4eXNmZmtCRTdSaGx2cFUrZkd6SGsw?=
 =?gb2312?B?aVZOODJxM1ZmY3lpMmNUS3lYdkZJcGkrZHhHVEhJbVZIZDJ0RU1DU2JNVXZ2?=
 =?gb2312?B?Ykp4ZXh4VThpdjFibktpNXFjcG1tbXlmRE4rR1pRT0NjNTZIOWsyaTFnVGxR?=
 =?gb2312?B?eDdyaWdyWHp5Tlh5RTJPYW5BeTkvQVRzUEF4c1MxWnd0T2VTY2N4bFdGR0hF?=
 =?gb2312?B?eXVmcFVPZTZVMXlDaU9IQUJ0cXpBMkZzcys3N3F5N2VDbkJLbGNuMDFnYjg5?=
 =?gb2312?B?UGhtemVUMWZNczBqdlc3RWQ3em41UDZXTDBhYUJZcDlvR1BVdXZGa1pBQ0VD?=
 =?gb2312?B?eEhxTmxHZmxQNkpnQ085TDJnUHU2d2E1ajVnclF1eWUwazR6YmptYXorMFlT?=
 =?gb2312?B?eFBNclhRNllCanhPWnd4NkhWN2RWQjhOam5yVC90ak9sVHZpdkJjcHMrZkFC?=
 =?gb2312?B?TlZGZG1nZmtYMjlTaWtPR05NVDI5ZTk3ZmYwY1E1SWlnckk2UmRrWkxkQllE?=
 =?gb2312?B?UStmemd3ZXByOW5vOUlqNzhhaitET0ozM0l2dXpHN1NvZnN4MDZLa1RaYVoz?=
 =?gb2312?B?dFVsMXpHQWFEL2Y5ZEtSNVhBcHdMWWpTMlBKQy9FemRYMnVPV3dMZXZ3N0Rh?=
 =?gb2312?B?WmhNemNUNVI5aWxFTUhqOXhWK0tVMGdnemtGcWl3RktkMHluZi93Q1I5ZUpN?=
 =?gb2312?B?V1RiQ080TjV0ZStPQ3Z0ZldFMU1ZVGlWM1BvZHIxck04NXJTNzJqL0JjYklq?=
 =?gb2312?B?UExpTmk0TGhBcER4QUN5RWdiam5JMHowaFM3NlVHelVTS0c0dEw2cnlPMStN?=
 =?gb2312?B?K29PSnpZUGVDai9rSXNrOGJMMjZEdjZpUW9mTVpLdFZOUjBKNGVkYW5QcHYw?=
 =?gb2312?B?T0F5UVFxSW5yb3pJd2dFT2lpS2RmRW94V3h2NmhkTVBkcVQveFc0bkJTeHdy?=
 =?gb2312?B?cXN6dTFiRVNaUWcxSGZWWHE0cGxKZmlHdjRUUytvVHM1djBYM1ppNU1qMWJn?=
 =?gb2312?B?U1hnUndUdHJ3RmEyRlJNam9BK2paNVQydWJhSmt0L0Q3OExUMktpSFBpeG5a?=
 =?gb2312?B?bmFxQWVmOVkvUVlaVG5wT2NkRHIrbXRRdzRiWkllSHQwSXFkci9uNzQ0a3U4?=
 =?gb2312?Q?ziPE=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f014e7aa-f361-4c17-4a7e-08db5d04f957
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 09:46:54.7100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZOkQ+0xr+azLDl7hM85N6SfrA96S4cYpMN4J5dzjQlK/wUtH6iRBKdL6ngByqyiuuSCpXDqad9jcQ15430Mvmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8791
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTaW1vbiBIb3JtYW4gPHNpbW9u
Lmhvcm1hbkBjb3JpZ2luZS5jb20+DQo+IFNlbnQ6IDIwMjPE6jXUwjI1yNUgMTc6MDkNCj4gVG86
IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
ZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNv
bTsgU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT47IENsYXJrIFdhbmcNCj4gPHhp
YW9uaW5nLndhbmdAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlt
eA0KPiA8bGludXgtaW14QG54cC5jb20+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIG5ldDogZmVjOiByZW1vdmUgbGFzdF9iZHAg
ZnJvbQ0KPiBmZWNfZW5ldF90eHFfeG1pdF9mcmFtZSgpDQo+IA0KPiBPbiBUaHUsIE1heSAyNSwg
MjAyMyBhdCAwNDozODoyNFBNICswODAwLCB3ZWkuZmFuZ0BueHAuY29tIHdyb3RlOg0KPiA+IEZy
b206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+DQo+ID4gQWN0dWFsbHksIHRoZSBs
YXN0X2JkcCBpcyB1c2VsZXNzIGluIGZlY19lbmV0X3R4cV94bWl0X2ZyYW1lKCksIHNvDQo+ID4g
cmVtb3ZlIGl0Lg0KPiANCj4gSSB0aGluayBpdCB3b3VsZCBiZSB1c2VmdWwgdG8gZGVzY3JpYmUg
d2h5IGl0IGlzIHVzZWxlc3MuDQo+IA0KPiBGLmUuIGJlY2F1c2UgaXQgaXMgc2V0IHRvIGJkcCwg
d2hpY2ggZG9lc24ndCBjaGFuZ2UsIHNvIGJkcCBjYW4gYmUgdXNlZCBkaXJlY3RseQ0KPiBpbnN0
ZWFkLg0KPiANClNvcnJ5LCBJJ2xsIHJlZmluZSB0aGUgY29tbWl0IG1lc3NhZ2UgaW4gdGhlIG5l
eHQgdmVyc2lvbi4gVGhhbmsgeW91IQ0K

