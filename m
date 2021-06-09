Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5325C3A0F3D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 11:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhFIJFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:05:24 -0400
Received: from mail-eopbgr30075.outbound.protection.outlook.com ([40.107.3.75]:20454
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231485AbhFIJFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 05:05:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZLNvSFF8LbvU2dnAx+762WYRuqS7TY+ChH3F/4Ck7kkIQVr2jkIYUmYhGt8Yr2uVnOwqcXP3bXJ9xsmmhXOyL7OxTUkEGQZ4RcbABfUZsjpG2qqAAC5BGOgmF/8W8K8uGO+f77+EqN/LDzg2G3hmaChLZEuQnYS5/tNcO16AR1mCbhdv1JLdDN8aPFu29eULtFNB9dQ81x2OtFp4Avho4qdbnwKZ8acRbgAflKyzXVnNRZgpXhLPGWf4vw4fDP7hzjj/E7uXZyOxn7JoIYyyctQbzJXt7AiRRf7VWoQwvzO2ezcV/EHo/CaMj0u1ZUZYd1v5Q7E1m1zFSeTbPjwnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3j+wct0Xs34Xr4mGNF1tLhzotrHJU5XTWYL0wBvqws=;
 b=i8FvzxmVS+LhYcyJvHUqED3CpAlgDTWrEtyVY1wH6npOPLlR/+c2CJuKgbJgMhqJTNt3fquc2C0Lh8Av7JlDTIE4ejr+Q3S8MFf14JNzrFxfyygudd+hgUd+P9PWi6rjiInTjnTI4JEdrH4/zqrfClX20nfffc290Gj0TS7NoqHUKq9aItcaNy50Lh8IFu0SU2TELF5ioGeI5U1xgf7T5tbbwbVt07WwpkYrkd+Fdh4W9xzw8XiD3Yo29SgMbwQ4ncqCHeU/0o54y6NNaCLbHRFZJ/00prLC02FOcKCJF+UhAiVFBZ1UO0AQwgYvDLHYhiFfu246zh36D3v/2kuT1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3j+wct0Xs34Xr4mGNF1tLhzotrHJU5XTWYL0wBvqws=;
 b=msUmR+KlzTrF0buqsn4s+ymhYUaU9wbiYSdDdWweexS/4udaG3yP9HDXjzaM8ZczFpwvDlzg1apxHGA4qfDIzkoohbD246WkUXidY/ygpL/OnplasQ0rvLqFFZBPhxl59E5bBjGTqpC15kPGmKlTF0b7tlacOwjt1JnCCnkPj8k=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Wed, 9 Jun
 2021 09:03:24 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b463:c504:8081:dee5]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b463:c504:8081:dee5%6]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 09:03:24 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Rui Sousa <rui.sousa@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "vee.khee.wong@intel.com" <vee.khee.wong@intel.com>,
        "tee.min.tan@intel.com" <tee.min.tan@intel.com>,
        "mohammad.athari.ismail@intel.com" <mohammad.athari.ismail@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, "Y.b. Lu" <yangbo.lu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
Subject: RE: [PATCH v1 net-next 3/3] net: stmmac: ptp: update tas basetime
 after ptp adjust
Thread-Topic: [PATCH v1 net-next 3/3] net: stmmac: ptp: update tas basetime
 after ptp adjust
Thread-Index: AQHXVsAq74oZyGIaq0aybt2sUJNcZKsAg6SAgArhutA=
Date:   Wed, 9 Jun 2021 09:03:24 +0000
Message-ID: <DB8PR04MB5785F472AC4F8ED66B9E128CF0369@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210601083813.1078-1-xiaoliang.yang_1@nxp.com>
 <20210601083813.1078-4-xiaoliang.yang_1@nxp.com>
 <5d81bf51-6355-6b52-4653-412f9ce0c83a@nxp.com>
In-Reply-To: <5d81bf51-6355-6b52-4653-412f9ce0c83a@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06e69f54-04dd-4923-50cf-08d92b257009
x-ms-traffictypediagnostic: DB8PR04MB5787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5787F18972F414AE8AC9F689F0369@DB8PR04MB5787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w+IgWjxsCIvDU/oA6OpZBvmvlPGfLU2Jhk6FuyGlvFGCIQA/yZPZH1jCP4hj4Xn4guHCVvxvLz6EqcVGsy4oRgKueAVyl0JumEoVPoPO433BAsb+a+IiDU98hpRzp1KGTHAXmgE9nbtoi5Mi16/XBR3tqn33ne6cPXHUvQbI3dqMDF1YR4L4ki/r05p8E27E+h9sy4DANwLLJvSDAGUR/xihVjtwkI+lTBZaiJRY4F7dPuvJQRaa6MTmTtFpj4o+G7ywg5nrghYaHcpFBn085ARW1iUFjbP5fFNk+DlhQrcNlGE8GbvndDUU/IKcSTuHEa08Md+KooiqvNPkpgHTYnm/JbtUovcZ3INLVwq3vkCXR5vGADhrF8skJ/IMj0P55gbxGk3EWABGf9DDpnUn61d/Qgy/mCvXdIeTdW12ej3a1sXkCjzozLvww4ahCrkIyy8SPx5k8KABpIDnhBUFZQMevn0d8adVW29Kox1b6dyzDeAaZVf87v73H1g8XSO0jRpHVh504EIk097j2/DCoy6PPl8KparOcvzOB4Acatia5YsmdBPZiI03hs1jpwgIs1f/8XznGPsbD3MChJ4yr4diFWwpodSyMFN1oWR3ZP8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(7696005)(2906002)(122000001)(66446008)(6862004)(186003)(33656002)(55016002)(478600001)(9686003)(64756008)(53546011)(71200400001)(38100700002)(6636002)(6506007)(8936002)(83380400001)(76116006)(66476007)(7416002)(66946007)(5660300002)(52536014)(15650500001)(4326008)(54906003)(316002)(26005)(8676002)(66556008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cEZOZU9nODFvUTFmSHRFZHRNTXZGMnpvaGFVbnRxTzNRMVY4Q2VLOUVMNWMv?=
 =?utf-8?B?bzMvQUpwL2xSK0tTRUl4dlVlVVRuRUYzK25jaFNCOW53cnlwVnNVOXMvaEkz?=
 =?utf-8?B?ZVgvM3kyV01vVWNqK3F1SWJHZ1J3NWpEQWdVWGQwdGpWNllnM1pJOTZlTGRP?=
 =?utf-8?B?UzM4aTRyMXVRbDd0Q2N6dW1PbThjYjJvNlZmQzZ5bHhGQTNqZVNWMUY5eVFO?=
 =?utf-8?B?aEgzbFp6SzlBWk1IVlRyeGltY0dabnlld2tWMWpuYVY4eFA4bU1lUGpMZzUw?=
 =?utf-8?B?bndjVHQ4R2owVjdZNFdpbkVsVEh4YXUxc3FBcytLRjNheEFjTTB2MXNuYUZZ?=
 =?utf-8?B?TkhpY3RYaC8zT0VhT25PUk5iZnBEZW9sVk9STlhBSEZYL2llYzdwbGZEclZ3?=
 =?utf-8?B?OWE4RVdyeW1MM2U2UnlyK1RORWQxSEpRbmNNcGJiNUJYblJ5N3Vzb0t6SUxx?=
 =?utf-8?B?S0E5Q1ArYSs2SnA1bktVbUZGQmtXTmQ4elp6c2pKOUNWL3JLQWJ6dGlISXEx?=
 =?utf-8?B?VG9hM3oyVVlTK3VJVGRKSm9oVk5saksvOXp4MWZBSHpmU0RuYXVWTG1zbUt5?=
 =?utf-8?B?UitkOUIyWnhYNEJ3TTJuWG1qSThNb29vV0Y1aU1iYmM5SFJOR2djWnZBaHB0?=
 =?utf-8?B?c291SkhwSEFEVUtHZ0N6cHdNODEvVHpmTU91L2lLcUlrbDNNcXF3Um1kMW4z?=
 =?utf-8?B?Y1JMTjhzcHp4SENPWnBEbmJsYkw5T3ZLNEUvbCtMR294TVZpQzVHZUJrVndk?=
 =?utf-8?B?VGIxc2JqalRkL0hGa0Z2VDJZR1NKaGNRYVNsSkJEcUdLU0laSGlkakZKVnd4?=
 =?utf-8?B?ZkJ3MmJIWnU1YVVyVTM4ZGszUFZDOUlzK2M4dXk0bytUUHVEZjhPcjdDRGtG?=
 =?utf-8?B?OXZ2eS9ZdDRzaUJVMGF1RUJ0d2JSMTR1QXRvY2lUVVdQQnZ6SkJNb1lwMWNx?=
 =?utf-8?B?djZzcDVYZnkzdlpaTGdvTHI2UitQZEdOQUcwcE1QR0tCWjVJUVVLbWpLcVZ6?=
 =?utf-8?B?TmN0WkwwRmx5ZUc2ODEyVE5MbmlZb3JxUFhTTEZLQitFT0FPbDhVREtteFRk?=
 =?utf-8?B?SUxtQThhcS8vcDhEdmRIM1crU3hzRDEzYnUrcitpT1ZyZU0zeGtNNm9sUEU2?=
 =?utf-8?B?bjgrQWxXMVhIUUFOelFycHZjYVdvUG9FZ2I3d01MemdhalBvM1NzL2dzdmpK?=
 =?utf-8?B?WlBLeXBXWmFlZWFBeERVQ3JOSnF5bVZobWJ0SjFSNkpjR3NvTU1yVW1RL0xm?=
 =?utf-8?B?SUtxZVZPdzNMVzAveHZJVTdneTRkTzd1N1dkQkUxSnkvWjhpaWhMVFU4S1Yr?=
 =?utf-8?B?eTAzUHUzMnRJamE2V0dtZGNSeC9IMVpmVlZXVlFibUVoa1NIdmVjNS9haGw0?=
 =?utf-8?B?MktMTjVKMGppbnp5L3pjVUxSZ1lLN0d0S0ViMlExZHVzRGJ0SkYvRTZVL2V6?=
 =?utf-8?B?L28xc3dNb1lPNnhkZzd5ZEVqQnlhZ0k4aGlnT2RtbWJLeXdJc0dhSVd1dC9T?=
 =?utf-8?B?MVppKys3RXZxTm5ZRFRXbU9wY2lNc256UGRxWlEyQXoxSnFyK3dSOGV3WThI?=
 =?utf-8?B?SFhkSm9wcFlTQkhnckVtRUJsRjcrNUhBTFVnYkZhSUswby9tRzgvcEpwSUxu?=
 =?utf-8?B?dW8wMm5iZUZ4T2xvUlBiTnNmMk9JVDdMZ0x4YWJMNmtwemRyWkcwSVNTclQw?=
 =?utf-8?B?L1h5U0N6eDBsUHBENisxMElyK3VCd290M2RBYWtxSkJUZ3lvR3ljSExDQ2dF?=
 =?utf-8?Q?wLePzJ9TWbF3Bph3ljgXJzzcKmi6/AQJLbp624j?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e69f54-04dd-4923-50cf-08d92b257009
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 09:03:24.1549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rqIQmv/6po+d0HD0hiBFXCgGocH8PDNzF+Cj28ssQ58w6X+jLL804PU7Zct7hkD15Pn8KjpsBLO16LzVuHGPevcuGTWkqnm1FXk0UwfTzZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVpLA0KDQpPbiAyMDIxLTA2LTAyIDE4OjE4LCBSdWkgU291c2Egd3JvdGU6DQo+ID4gQWZ0
ZXIgYWRqdXN0aW5nIHRoZSBwdHAgdGltZSwgdGhlIFFidiBiYXNlIHRpbWUgbWF5IGJlIHRoZSBw
YXN0IHRpbWUNCj4gPiBvZiB0aGUgbmV3IGN1cnJlbnQgdGltZS4gZHdtYWM1IGhhcmR3YXJlIGxp
bWl0ZWQgdGhlIGJhc2UgdGltZSBjYW5ub3QNCj4gPiBiZSBzZXQgYXMgcGFzdCB0aW1lLiBUaGlz
IHBhdGNoIGNhbGN1bGF0ZSB0aGUgYmFzZSB0aW1lIGFuZCByZXNldCB0aGUNCj4gPiBRYnYgY29u
ZmlndXJhdGlvbiBhZnRlciBwdHAgdGltZSBhZGp1c3QuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBYaWFvbGlhbmcgWWFuZyA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPg0KPiA+IC0tLQ0KPiA+
IC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX3B0cC5jwqAgfCA0MQ0KPiAr
KysrKysrKysrKysrKysrKystDQo+ID4gMSBmaWxlIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfcHRwLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3N0bWljcm8vc3RtbWFjL3N0bW1hY19wdHAuYw0KPiA+IGluZGV4IDRlODZjZGYyYmM5Zi4uYzU3
M2JjOGIyNTk1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8v
c3RtbWFjL3N0bW1hY19wdHAuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWlj
cm8vc3RtbWFjL3N0bW1hY19wdHAuYw0KPiA+IEBAIC02Miw3ICs2Miw4IEBAIHN0YXRpYyBpbnQg
c3RtbWFjX2FkanVzdF90aW1lKHN0cnVjdCBwdHBfY2xvY2tfaW5mbw0KPiA+ICpwdHAsIHM2NCBk
ZWx0YSkNCj4gPiAgwqDCoMKgwqB1MzIgc2VjLCBuc2VjOw0KPiA+ICDCoMKgwqDCoHUzMiBxdW90
aWVudCwgcmVtaW5kZXI7DQo+ID4gIMKgwqDCoMKgaW50IG5lZ19hZGogPSAwOw0KPiA+IC3CoMKg
wqAgYm9vbCB4bWFjOw0KPiA+ICvCoMKgwqAgYm9vbCB4bWFjLCBlc3RfcnN0ID0gZmFsc2U7DQo+
ID4gK8KgwqDCoCBpbnQgcmV0Ow0KPiA+DQo+ID4gIMKgwqDCoMKgeG1hYyA9IHByaXYtPnBsYXQt
Pmhhc19nbWFjNCB8fCBwcml2LT5wbGF0LT5oYXNfeGdtYWM7DQo+ID4NCj4gPiBAQCAtNzUsMTAg
Kzc2LDQ4IEBAIHN0YXRpYyBpbnQgc3RtbWFjX2FkanVzdF90aW1lKHN0cnVjdA0KPiA+IHB0cF9j
bG9ja19pbmZvICpwdHAsIHM2NCBkZWx0YSkNCj4gPiAgwqDCoMKgwqBzZWMgPSBxdW90aWVudDsN
Cj4gPiAgwqDCoMKgwqBuc2VjID0gcmVtaW5kZXI7DQo+ID4NCj4gPiArwqDCoMKgIC8qIElmIEVT
VCBpcyBlbmFibGVkLCBkaXNhYmxlZCBpdCBiZWZvcmUgYWRqdXN0IHB0cCB0aW1lLiAqLw0KPiA+
ICvCoMKgwqAgaWYgKHByaXYtPnBsYXQtPmVzdCAmJiBwcml2LT5wbGF0LT5lc3QtPmVuYWJsZSkg
ew0KPiA+ICvCoMKgwqDCoMKgwqDCoCBlc3RfcnN0ID0gdHJ1ZTsNCj4gPiArwqDCoMKgwqDCoMKg
wqAgbXV0ZXhfbG9jaygmcHJpdi0+cGxhdC0+ZXN0LT5sb2NrKTsNCj4gPiArwqDCoMKgwqDCoMKg
wqAgcHJpdi0+cGxhdC0+ZXN0LT5lbmFibGUgPSBmYWxzZTsNCj4gPiArwqDCoMKgwqDCoMKgwqAg
c3RtbWFjX2VzdF9jb25maWd1cmUocHJpdiwgcHJpdi0+aW9hZGRyLCBwcml2LT5wbGF0LT5lc3Qs
DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJpdi0+cGxh
dC0+Y2xrX3B0cF9yYXRlKTsNCj4gPiArwqDCoMKgwqDCoMKgwqAgbXV0ZXhfdW5sb2NrKCZwcml2
LT5wbGF0LT5lc3QtPmxvY2spOw0KPiA+ICvCoMKgwqAgfQ0KPiA+ICsNCj4gPiAgwqDCoMKgwqBz
cGluX2xvY2tfaXJxc2F2ZSgmcHJpdi0+cHRwX2xvY2ssIGZsYWdzKTsNCj4gPiAgwqDCoMKgwqBz
dG1tYWNfYWRqdXN0X3N5c3RpbWUocHJpdiwgcHJpdi0+cHRwYWRkciwgc2VjLCBuc2VjLCBuZWdf
YWRqLA0KPiA+IHhtYWMpOw0KPiA+ICDCoMKgwqDCoHNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBy
aXYtPnB0cF9sb2NrLCBmbGFncyk7DQo+ID4NCj4gPiArwqDCoMKgIC8qIENhY3VsYXRlIG5ldyBi
YXNldGltZSBhbmQgcmUtY29uZmlndXJlZCBFU1QgYWZ0ZXIgUFRQIHRpbWUNCj4gPiBhZGp1c3Qu
ICovDQo+ID4gK8KgwqDCoCBpZiAoZXN0X3JzdCkgew0KPiA+ICvCoMKgwqDCoMKgwqDCoCBzdHJ1
Y3QgdGltZXNwZWM2NCBjdXJyZW50X3RpbWUsIHRpbWU7DQo+ID4gK8KgwqDCoMKgwqDCoMKgIGt0
aW1lX3QgY3VycmVudF90aW1lX25zLCBiYXNldGltZTsNCj4gPiArwqDCoMKgwqDCoMKgwqAgdTY0
IGN5Y2xlX3RpbWU7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoCBwcml2LT5wdHBfY2xvY2tf
b3BzLmdldHRpbWU2NCgmcHJpdi0+cHRwX2Nsb2NrX29wcywNCj4gPiAmY3VycmVudF90aW1lKTsN
Cj4gPiArwqDCoMKgwqDCoMKgwqAgY3VycmVudF90aW1lX25zID0gdGltZXNwZWM2NF90b19rdGlt
ZShjdXJyZW50X3RpbWUpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoCB0aW1lLnR2X25zZWMgPSBwcml2
LT5wbGF0LT5lc3QtPmJ0clswXTsNCj4gPiArwqDCoMKgwqDCoMKgwqAgdGltZS50dl9zZWMgPSBw
cml2LT5wbGF0LT5lc3QtPmJ0clsxXTsNCj4gDQo+IFRoaXMgdGltZSBtYXkgbm8gbG9uZ2VyIGJl
IHdoYXQgdGhlIHVzZXIgc3BlY2lmaWVkIG9yaWdpbmFsbHksIGl0IHdhcyBhZGp1c3RlZA0KPiBi
YXNlZCBvbiB0aGUgZ3B0cCB0aW1lIHdoZW4gdGhlIGNvbmZpZ3VyYXRpb24gd2FzIGZpcnN0IG1h
ZGUuDQo+IElNSE8sIGlmIHdlIHdhbnQgdG8gcmVzcGVjdCB0aGUgdXNlciBjb25maWd1cmF0aW9u
IHRoZW4gd2UgbmVlZCB0byBkbyB0aGUNCj4gY2FsY3VsYXRpb24gaGVyZSBiYXNlZCBvbiB0aGUg
b3JpZ2luYWwgdGltZS4NCj4gVHlwaWNhbGx5ICh1c2luZyBhcmJpdHJhcnkgdW5pdHMpOg0KPiBh
KSBVc2VyIGNvbmZpZ3VyZXMgYmFzZXRpbWUgb2YgMCwgYXQgZ3B0cCB0aW1lIDEwMDANCj4gYikg
YnRyIGlzIHVwZGF0ZSB0byAxMDAwLCBzY2hlZHVsZSBzdGFydHMNCj4gYykgbGF0ZXIsIGdwdHAg
dGltZSBpcyB1cGRhdGVkIHRvIDUwMA0KPiBkLTEpIHdpdGggY3VycmVudCBwYXRjaCwgc2NoZWR1
bGUgd2lsbCByZXN0YXJ0IGF0IDEwMDAgKGkuZSByZW1haW5zIGRpc2FibGVkIGZvcg0KPiA1MDAp
DQo+IGQtMikgd2l0aCBteSBzdWdnZXN0aW9uLCBzY2hlZHVsZSB3aWxsIHJlc3RhcnQgYXQgNTAw
ICh3aGljaCBtYXRjaGVzIHRoZSB1c2VyDQo+IHJlcXVlc3QsICJzdGFydCBhcyBzb29uIGFzIHBv
c3NpYmxlIi4NCj4gDQpJdCBpcyBub3QgdGhlIGNvcnJlY3Qgb3BlcmF0aW9uIHNlcXVlbmNlIGZv
ciB0aGUgdXNlciB0byBjb25maWd1cmUgUWJ2IGJlZm9yZSBwdHAgY2xvY2sgc3luY2hyb25pemF0
aW9uLiBBZnRlciBhZGp1c3RpbmcgdGhlIHB0cCBjbG9jayB0aW1lLCBpdCBpcyBubyBsb25nZXIg
cG9zc2libGUgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgdGhlIHByZXZpb3VzbHkgc2V0IGJhc2V0aW1l
IGlzIHdoYXQgdGhlIHVzZXIgd2FudHMuIEkgdGhpbmsgb3VyIGRyaXZlciBvbmx5IG5lZWRzIHRv
IGVuc3VyZSB0aGF0IHRoZSBzZXQgYmFzZXRpbWUgbWVldHMgdGhlIGhhcmR3YXJlIHJlZ3VsYXRp
b25zLCBhbmQgdGhlIGhhcmR3YXJlIGNhbiB3b3JrIG5vcm1hbGx5LiBTbyBJIG9ubHkgdXBkYXRl
ZCB0aGUgcGFzdCBiYXNldGltZS4gSSBhbSBub3Qgc3VyZSBpZiBpdCBpcyBhcHByb3ByaWF0ZSB0
byByZXNldCBFU1QgY29uZmlndXJlIGluIHRoZSBQVFAgZHJpdmVyLCBidXQgdGhpcyBjYXNlIHdp
bGwgY2F1c2UgdGhlIGhhcmR3YXJlIHRvIG5vdCB3b3JrLg0KDQo+ID4gK8KgwqDCoMKgwqDCoMKg
IGJhc2V0aW1lID0gdGltZXNwZWM2NF90b19rdGltZSh0aW1lKTsNCj4gPiArwqDCoMKgwqDCoMKg
wqAgY3ljbGVfdGltZSA9IHByaXYtPnBsYXQtPmVzdC0+Y3RyWzFdICogTlNFQ19QRVJfU0VDICsN
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJpdi0+cGxhdC0+ZXN0LT5j
dHJbMF07DQo+ID4gK8KgwqDCoMKgwqDCoMKgIHRpbWUgPSBzdG1tYWNfY2FsY190YXNfYmFzZXRp
bWUoYmFzZXRpbWUsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY3VycmVudF90aW1lX25zLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN5Y2xlX3RpbWUpOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDC
oMKgwqAgbXV0ZXhfbG9jaygmcHJpdi0+cGxhdC0+ZXN0LT5sb2NrKTsNCj4gDQo+IEhtbS4uLiB0
aGUgbG9ja2luZyBuZWVkcyB0byBtb3ZlIHVwLiBSZWFkaW5nICsgd3JpdHRpbmcgYnRyL2N0ciBz
aG91bGQgYmUNCj4gYXRvbWljLg0KSSB3aWxsIG1vZGlmeSB0aGlzLg0KPiANCj4gPiArwqDCoMKg
wqDCoMKgwqAgcHJpdi0+cGxhdC0+ZXN0LT5idHJbMF0gPSAodTMyKXRpbWUudHZfbnNlYzsNCj4g
PiArwqDCoMKgwqDCoMKgwqAgcHJpdi0+cGxhdC0+ZXN0LT5idHJbMV0gPSAodTMyKXRpbWUudHZf
c2VjOw0KPiA+ICvCoMKgwqDCoMKgwqDCoCBwcml2LT5wbGF0LT5lc3QtPmVuYWJsZSA9IHRydWU7
DQo+ID4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IHN0bW1hY19lc3RfY29uZmlndXJlKHByaXYsIHBy
aXYtPmlvYWRkciwNCj4gPiArcHJpdi0+cGxhdC0+ZXN0LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwcml2LT5wbGF0LT5jbGtfcHRwX3JhdGUpOw0K
PiA+ICvCoMKgwqDCoMKgwqDCoCBtdXRleF91bmxvY2soJnByaXYtPnBsYXQtPmVzdC0+bG9jayk7
DQo+ID4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgbmV0ZGV2X2Vycihwcml2LT5kZXYsICJmYWlsZWQgdG8gY29uZmlndXJlIEVTVFxuIik7DQo+
ID4gK8KgwqDCoCB9DQo+ID4gKw0KPiA+ICDCoMKgwqDCoHJldHVybiAwOw0KPiA+IH0NCg0KVGhh
bmtzLA0KeGlhb2xpYW5nDQo=
