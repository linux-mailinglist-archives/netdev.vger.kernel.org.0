Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC2C3C9C77
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhGOKO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:14:59 -0400
Received: from mail-am6eur05on2052.outbound.protection.outlook.com ([40.107.22.52]:15457
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233489AbhGOKO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 06:14:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5W72W8kTHVb2J0QhAiVyvWsUkzl/4ppLFHtLoiz47A1jaJ7i2zYpBA7zv6W45aYuVBZBOWJ9DZfzf/DezVKRLdD3KyC2Gil14BQYGFs/xMoHR14HAJKxs0wd5gpNYzy+eW9vFgwB57hBstBfyDbstpgvYREvVzRW/UuXDf7rB6444KAU4JsT2Im0x2mHY4NhOQoavHuUFZKfEu9pjRu6PkkG3Sk/jMenqnWSd8St98j3ljc+iNewmruFyiB8CCIL2O5a1zyrQAPPJmrAQJ9WhnckUefa9TYbMCkMMj3F+zVwGU0BmHsu4JuBaC67wgq0O/mGz7K05WDP6gQGUgHcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+srwyWY2+UvtTBHhOD5okzI0mIZY21UBxq6fNQGdYJY=;
 b=XFBoEZx4fusxPbaswAjgqBfFia1aX/wq8pSxPvr6ExD+gYdlWS8LkSDwPolhG8tOT9Y+pH8KYpxxioQGfNsL+ONw74exWz3B4mDw+2X70Vtak9gke0KRjMTG9lP1GJmBu58gL2RdjdWxiBzS8g7cYo3WEvpT0A4ZBnJERe8/aVcmCTiW2nLkqKCz5ybBcA8W9OgmbuNrS9MoOb4HbseOnPMgZ15hdn2Twv2OoAKDrTuiEZ/DTeGo0uuUxiSC5I3UfOxCJwyjF3zW0YGHnTCoNM75+SdIShBH/qtLx5j9PQZt94ydhMICHCLvR1WYQkzXVX5hCdpaI0v4Q0WwKfgtBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+srwyWY2+UvtTBHhOD5okzI0mIZY21UBxq6fNQGdYJY=;
 b=W7xfSylaRpJ0IhNY6C2VziK+Uks6o5Wmjq/q6nSWcn/KCUdC+gNi/gWYYlWCweet7f6PwpaBKReWi8Y2DJLAET6pom/YDbeNe4OJJ0psabZQbCzV9yJ3FWETWzHckWwtXHTOKWwDl7jZMyjQJMPOoRYIKXShT73w5EvbC3Zg1cE=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 10:12:04 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Thu, 15 Jul 2021
 10:12:04 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: RE: [PATCH linux-next] net:stmmac: Fix the unsigned expression
 compared with zero
Thread-Topic: [PATCH linux-next] net:stmmac: Fix the unsigned expression
 compared with zero
Thread-Index: AQHXeU1V5WLQdRUTCk+xNkC0Cx2THqtDzvVg
Date:   Thu, 15 Jul 2021 10:12:04 +0000
Message-ID: <DB8PR04MB679513459A42E7A7982CE91EE6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210715074539.226600-1-zhang.yunkai@zte.com.cn>
In-Reply-To: <20210715074539.226600-1-zhang.yunkai@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4397d0eb-72bb-49bb-278c-08d94778fe9f
x-ms-traffictypediagnostic: DB6PR04MB3094:
x-microsoft-antispam-prvs: <DB6PR04MB3094396DC6F903464369F8C5E6129@DB6PR04MB3094.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mZ5Oexv9eVu1JvVoDSevKCDLxC41eJI4xYHurk+0o3WZmLsXOztrNmDEQt/FhyO7AWjtqbu6s7QjBV36+kQW9Gzt+x0LouNApTjdLx6VZCefQj+q/L9svYwG3obFXPfkBeKhPw5Gr2JMGTjArK3TDnbvhTxiihznxncNb2fAEMXEoY5lFoeSgRNx/EiI2iy6/GrF8xU0KeyosHesH4Qo/+8WiJ1ofaJEsv1FhG8/pzxSdQEynGinJ835JQYuDOUCBjcqhoZFT9ST8pf+q/usQDqD3bdCCAS1ObKa4bPwo95reSx0dSTHw640Ti+1WdT0icZSAOslzske0kK36Dma3eEUntLOAsfrpDNPt8O7BbGAsGZMjAp0x4xljntIbGndUI2xkyuuWTlfx7UkzsIHbG+YZm8JP3uSBgbGKb0MmAxpvoVYSNsgHTmuliuVBuqbFC0yZp6hh48kmTDJIdTZ0FWaJBjEhHhl7qj1uJxYQr8dLsEIKxDaUpmhZbhy/751GlNF+Otu0GGCo5Zat3/UW5C77Jb8OCwiUXQpuI8/tyzDEBiSeqMULv8y4JMMr5CRt9+fIjwjNc3LV2lxcUWzEwpmcQz071+U7zClEf6mKMluSU/YjWniZxQebMjU+gCoM/qn0BbQYoiBiasJNM5fy1SJA7BqZSZcJZ1kJ2JR+nF7yMRMA2ODm2fByiBQbCmCBop15sgw9nUEwo1rHHVnuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(7416002)(122000001)(71200400001)(8936002)(5660300002)(8676002)(33656002)(76116006)(38100700002)(66946007)(66476007)(66446008)(64756008)(4326008)(83380400001)(2906002)(54906003)(86362001)(7696005)(53546011)(316002)(66556008)(110136005)(9686003)(186003)(26005)(55016002)(52536014)(6506007)(478600001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bDNjNS80cWtFVWxIT3Jmb3VkRS9QQSs1MlB0TkVVZWxTZ3owNmxoMFBOOEhC?=
 =?gb2312?B?eVB4Vzk4TVNZK3Bta3hZZStnZnJjQWQ3TGpab1hEb2RDOE1yWjUzdUJXVUJK?=
 =?gb2312?B?Y0lJSENhd0lFcmU3eUluTHQ2dFk3WnVOWGFmMEtRb2c4bWh1QnFuemRUZWNj?=
 =?gb2312?B?QWdtcWNDa2sxWDUxNmZsREk0b0FBbnU5cy82NE5MaEFycEl3anp3TEFBVm9r?=
 =?gb2312?B?N3NhK0pXZGdnVEU3NENsV2d1ZlpWZWFycTZDZ04zQXB0Y1Z2UXJDUkpDL2pa?=
 =?gb2312?B?RUJTOTJwR1lsY1psV0tlRWVvcDZBNnJCbXdHWDIzalg1L3llNnVRVExEc2l2?=
 =?gb2312?B?RXQ3ZVR4V1Y3Zkd2NGxSeXM0WVZGd25STm40TkFPQVh0Uk5YKzFKRUhkUita?=
 =?gb2312?B?SUt1ZCs3dGRoVmI5K0lKRS9PUmZuR2VvRkJLR1c2dVFqTndrbFNsRFUwVXJo?=
 =?gb2312?B?Y1MwY09TRWVwMXV3NjJTdE9JdTg3OWhSUlBmZHBVeXByamhkMVAra3ZWUDhs?=
 =?gb2312?B?dms2VmFINUNaWEhjYmpMVE1EaDhmV2VETTVBYVhPRVJNdEVsMEhNdllZUnBN?=
 =?gb2312?B?WVh4anlUcUtRYVVKZWZqOE1KTDgraWFmRGVBdWhjbTE4Z2Y4L2JUTTlJNUJx?=
 =?gb2312?B?ek96Wi9nTjE4cEVGZ3Vrc25BQ2ZreWZ0cGtSWXF5RGVobE1RaEJIVS8vMm9C?=
 =?gb2312?B?NVZaaEdaNXBqNHlBK2tWU1l3RVhrR0JUTE0xczMyVnlqTVhleFA4S3NFVlZs?=
 =?gb2312?B?YVFsUHgxT2wyejNDUWFBSFZ4N2RPY0lFYWYySmR5MklZRi9QNEVTY1k2Smd2?=
 =?gb2312?B?QU0rTG9Kdk5DVVZuSzkyN3dnbVFiY2xxU2pMQlpUWVNRWTg5VXR0MnVuS2lu?=
 =?gb2312?B?bEUvZkNrUytuMWo1MGxxbXdrQWlDUUEwcDFpamRVRGhCRklOYXVyanFBOVha?=
 =?gb2312?B?RGlRd0NSVmRrN0RCQlFJekFjazA1ekViNXlRYndRUE12Vjl6TEswK0IwZVkx?=
 =?gb2312?B?WGc3SDB5RGR3emVXSFVIUWIrekRjYjNtRDBQcjYxa0U2VlFDYlQwcGJTaVd2?=
 =?gb2312?B?YXA4cTlFWjg4bG1TdXVTT1h2dS8rUld5SEdpSHBseUhPeHJQMktFNzFXTUlQ?=
 =?gb2312?B?Sit6aWcvZVJhZHR0b2I0VGFwbGp3ZG8zSWh3T1RjY0JPMVovSW9QQUoxWlhP?=
 =?gb2312?B?MDA1VCtPU0xOcHBjRDFJdm9xUVZzSFBzV1ZjTk9TUnNhU3hnRmhkUXpNRUtQ?=
 =?gb2312?B?NGRJNjRtNVpRb0ZBalUxd0pEbFR4cjRQWTVubUh0Skk3L2VqNStnc2tNU3ZM?=
 =?gb2312?B?b1R5MFZkNUlnWk96bWFvR1E2K0Q4ZmpzZG9PMnlnQmY4VytZOGFOZkRvaWFW?=
 =?gb2312?B?RldkN1BBbXFnSVNISTc0VFhZSWdVdmNLTlljZEtOM21FTXdwSUZUeWN1Umps?=
 =?gb2312?B?K3daakFobzhqMlN3SmlnV3V0Z0k4c3lKMFFtWkExK0QyNGlxajlKU1hKMnk0?=
 =?gb2312?B?azFLL0VCYlVZM3BCS3dYdHcreE9oZWJmaG5BQ2p1UnpWZ1FMbzd6dTQzL2tP?=
 =?gb2312?B?U2xxT1VkQVJmMUlINE0wWUJhZEowMVZ0M2NDNk12QWhOY3RYd1pSZHpBdTRr?=
 =?gb2312?B?TmU4REx6aUM4TmltcE56SGZDRlpraTVhdFlmelpacHJWVjNNd3JYRXBmNURl?=
 =?gb2312?B?YXB5U0VkLzdrMlVVMk05QUlCVUJkQ00vUHFyeE1icWVMdE9kcUl4V3BnQ01R?=
 =?gb2312?Q?kATtiyOqznVv7utlyrrj5Gx7HlvkFzi31d44qaC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4397d0eb-72bb-49bb-278c-08d94778fe9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 10:12:04.2081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cj7N6rdgwZpPy+qNpgkyHbK9Bh7oBitr3IWBQ8/KwMOChYVriWpIFUWwxNsWwJLeMjsThN3nuEzXYM7fJat8kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IG1lbmdsb25nOC5kb25nQGdt
YWlsLmNvbSA8bWVuZ2xvbmc4LmRvbmdAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOo31MIxNcjV
IDE1OjQ2DQo+IFRvOiBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENjOiBwZXBwZS5jYXZhbGxhcm9A
c3QuY29tOyBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lz
LmNvbTsga3ViYUBrZXJuZWwub3JnOyBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOw0KPiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1zdG0zMkBzdC1tZC1tYWlsbWFuLnN0b3JtcmVwbHku
Y29tOw0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IFpoYW5nDQo+IFl1bmthaSA8emhhbmcueXVua2FpQHp0ZS5jb20u
Y24+OyBaZWFsIFJvYm90IDx6ZWFsY2lAenRlLmNvbS5jbj4NCj4gU3ViamVjdDogW1BBVENIIGxp
bnV4LW5leHRdIG5ldDpzdG1tYWM6IEZpeCB0aGUgdW5zaWduZWQgZXhwcmVzc2lvbiBjb21wYXJl
ZA0KPiB3aXRoIHplcm8NCj4gDQo+IEZyb206IFpoYW5nIFl1bmthaSA8emhhbmcueXVua2FpQHp0
ZS5jb20uY24+DQo+IA0KPiBXQVJOSU5HOiAgVW5zaWduZWQgZXhwcmVzc2lvbiAicXVldWUiIGNv
bXBhcmVkIHdpdGggemVyby4NCj4gUmVwb3J0ZWQtYnk6IFplYWwgUm9ib3QgPHplYWxjaUB6dGUu
Y29tLmNuPg0KPiBTaWduZWQtb2ZmLWJ5OiBaaGFuZyBZdW5rYWkgPHpoYW5nLnl1bmthaUB6dGUu
Y29tLmNuPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0
bW1hY19tYWluLmMgfCA4ICsrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+IGluZGV4IDdiODQwNGEyMTU0NC4uYTRj
ZjJjNjQwNTMxIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0
bW1hYy9zdG1tYWNfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL3N0bW1hY19tYWluLmMNCj4gQEAgLTE2OTksNyArMTY5OSw3IEBAIHN0YXRpYyBpbnQg
aW5pdF9kbWFfcnhfZGVzY19yaW5ncyhzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2LCBnZnBfdCBm
bGFncykNCj4gIAlyZXR1cm4gMDsNCj4gDQo+ICBlcnJfaW5pdF9yeF9idWZmZXJzOg0KPiAtCXdo
aWxlIChxdWV1ZSA+PSAwKSB7DQo+ICsJZG8gew0KPiAgCQlzdHJ1Y3Qgc3RtbWFjX3J4X3F1ZXVl
ICpyeF9xID0gJnByaXYtPnJ4X3F1ZXVlW3F1ZXVlXTsNCj4gDQo+ICAJCWlmIChyeF9xLT54c2tf
cG9vbCkNCj4gQEAgLTE3MTAsMTEgKzE3MTAsNyBAQCBzdGF0aWMgaW50IGluaXRfZG1hX3J4X2Rl
c2NfcmluZ3Moc3RydWN0DQo+IG5ldF9kZXZpY2UgKmRldiwgZ2ZwX3QgZmxhZ3MpDQo+ICAJCXJ4
X3EtPmJ1Zl9hbGxvY19udW0gPSAwOw0KPiAgCQlyeF9xLT54c2tfcG9vbCA9IE5VTEw7DQo+IA0K
PiAtCQlpZiAocXVldWUgPT0gMCkNCj4gLQkJCWJyZWFrOw0KPiAtDQo+IC0JCXF1ZXVlLS07DQo+
IC0JfQ0KPiArCX0gd2hpbGUgKHF1ZXVlLS0pOw0KPiANCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0K
DQoNClRoaXMgaXMgYSByZWFsIENvdmVyaXR5IGlzc3VlIHNpbmNlIHF1ZXVlIHZhcmlhYmxlIGlz
IGRlZmluZWQgYXMgdTMyLCBidXQgdGhlcmUgaXMgbm8gYnJlYWthZ2UgZnJvbSBsb2dpYywgaXQg
d2lsbCBicmVhayB3aGlsZSBsb29wIHdoZW4gcXVldWUgZXF1YWwgMCwgYW5kIHF1ZXVlWzBdIGFj
dHVhbGx5IG5lZWQgYmUgaGFuZGxlZC4NCkFmdGVyIHlvdXIgY29kZSBjaGFuZ2UsIHF1ZXVlWzBd
IHdpbGwgbm90IGJlIGhhbmRsZWQsIHJpZ2h0PyBJdCB3aWxsIGJyZWFrIHRoZSBsb2dpYy4gSWYg
eW91IHdhbnQgdG8gZml4IHRoZSB0aGlzIGlzc3VlLCBJIHRoaW5rIHRoZSBlYXNpZXN0IHdheSBp
cyB0byBkZWZpbmUgcXVldWUgdmFyaWFibGUgdG8gaW50Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2Fr
aW0gWmhhbmcNCj4gLS0NCj4gMi4yNS4xDQoNCg==
