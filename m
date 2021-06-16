Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29E3A9968
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 13:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhFPLmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 07:42:40 -0400
Received: from mail-eopbgr30056.outbound.protection.outlook.com ([40.107.3.56]:63062
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbhFPLmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 07:42:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVMQuCh0EYJuy9IE+oSkC355R5qTDZd89xIxwSMqSKw2ERTswQrKSGztEEjr5U5mn6R89o4gpWhOat4XEHv2kKK6Yk7ZgsZupEdsf9XEhT1EIqWb+EMaG2TyIuWN5Owl2n00PR187+GLqRuO7SABj54BfYj8+cYpJhhE/J3UMcqMA04AsYVIEG8lnpyyz0Vy+hi7UimhqX+8jR5vfeUmD2hg65EO2AVcZVYBCjo58MWhFTaNtEFxWzr2xlySkPzj25u7NaWCcEn1DYiHjwWXi5lzveHDNK07zPDTKmUwBJvlqpBq6+e50xlJP5F9Oa20H8REzQVZVkJI+6g3HuIfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72Afy+qxNEQokGWLLXgL+mJlPCmeKKL+0/QyzaZOgBA=;
 b=NjS88Pn2G82G10hHZret1t0E9rKDI9iQH6Y+2XEfz7La88PIKkwClACMITXgfG+mFNPQ+dhUpQYQ8Uj7V0+JKxNFEeknmpeBQJn8rKMd0MZsQv+pTLSj+yC+15J8Sgd5XjF/bUIZ5rHgxFAY9HcbM8ziHNgSEErDFMWh7euzUUXyA1Mg2X0DM/08GPdsi0hzxP0I0Yc/tTLGOR0KyDJBomNr/gadNyJ1TgtZRYGp2klgb/PvjJkf3f1LkmlpJXE0C4voZmq1wBqK6zR25XaEpHZcuM8lxYB+AoqQu0cCxYXEqVSWoP+XQfqGxkuWV0oPVoawY4ACut+rZLFtO10Wxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72Afy+qxNEQokGWLLXgL+mJlPCmeKKL+0/QyzaZOgBA=;
 b=ZHNsQ8TJt7bSvjajjOFUoWVqiSPZNzYhYdDUcdRYGCf+6UtTOY5Pr4A4T/VdAl31Aj20wPYADxRnxQ4PifMxk0Gn3Gwq2Y2+XKmmnqR9Kz8q6HX2bEUvgCuweCrNAv3sLqm15L9ZP5iSBxvyf8/r23bqaUdj5WWG9midvgqPra4=
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB7405.eurprd04.prod.outlook.com (2603:10a6:800:1a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Wed, 16 Jun
 2021 11:40:29 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::d48b:48ed:c060:78de%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 11:40:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH net 1/2] net: fec_ptp: add clock rate zero check
Thread-Topic: [PATCH net 1/2] net: fec_ptp: add clock rate zero check
Thread-Index: AQHXYpAjjCpH7eZ3WUe24Kl2XrZ2sqsWbWAAgAAUiNA=
Date:   Wed, 16 Jun 2021 11:40:29 +0000
Message-ID: <VI1PR04MB68004D29895652864B4C1D20E60F9@VI1PR04MB6800.eurprd04.prod.outlook.com>
References: <20210616091426.13694-1-qiangqing.zhang@nxp.com>
 <20210616091426.13694-2-qiangqing.zhang@nxp.com>
 <20210616102038.GB22278@shell.armlinux.org.uk>
In-Reply-To: <20210616102038.GB22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c22bff3-4353-42ba-c118-08d930bb8a9f
x-ms-traffictypediagnostic: VE1PR04MB7405:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7405571351368401745E8E5AE60F9@VE1PR04MB7405.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LuETjRPY1dIUcIJhuE5KVtfJLm65w5MOc42VV/DYsepvVN6hzekm4kBqD8kC4TPxZB7OZXnlNfqgJS5VUJEK2lYJbs8ncQr8oMK1w6+jJCOWp0YK36qCz1enQ6CBUkMyJRi1vKZVtfj4it05PlBxn/TtsS3MwGga7eRip2RRFCFCoCuhFfEew768lNjV/C4EC1W1ZhNppGf790ihgcQ8rK8plEAfWvBMrAnoIpFJmVt0QNTKKAX85JEe6I5RUPLnv/6X1V4q7Eha5I9q9XXqckLYqQc10rnZdp7HcuQjAvCGU5MAMZ/nwArbwyA5TzdlLCkpa0DhulT9+0gf2F8UzLi3z6zrjfA3B4xShiEd/HuxbysOfE7VXEe5HNR29H9v9Gbj+9bVFcGQU9q+I3XTxjr42dJoDr6c0l41WdchccY2h468sh71OBkRjqFFxG2KBrKCiIWC2nFRZUrVYen9/TRTsDky3RT+Zp0Rgqc0u8DdGEK2QZPDEajdoaEIqKTMfy1mAUuz4581TNbxxIRicT8Ikyb94anqjSnpHPLPEFRZZT+KGj9ETjG8zo4Bo0kSoan7qnACH4oF9O7yj/pMujgMP04Pwx+nH7wghysgztJcOmrotRf148SnoT2TbyDyYvxXof6hYdhQWvAzzTGxDMoOFXpxw491CTByizNfAmpSTczUxeu1ELpLe0/JHpfA9ZdSLknhkgOEPylgD+16fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(366004)(376002)(396003)(136003)(966005)(2906002)(45080400002)(9686003)(4326008)(7696005)(71200400001)(186003)(6506007)(5660300002)(53546011)(55016002)(76116006)(122000001)(86362001)(8676002)(26005)(38100700002)(83380400001)(316002)(6916009)(7416002)(64756008)(66476007)(33656002)(52536014)(8936002)(66946007)(54906003)(66556008)(478600001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?akpzbWppRUFlWlVDZEFXRk1HRHMvYkd5dk5Edm1uVE03Mmk4Q01sNzZlNWJm?=
 =?gb2312?B?cE1nSmZheDFaTUttQ1R3MUVxcjl3ekg1eDZzaW5mQk5pcmZTWEI2Z0Vwd2tU?=
 =?gb2312?B?ajFNOWZuZU9aZDdaUWNHVi9OeXRXZjZjKy8xZHFqWnlWd1djaU1qckpVN3lK?=
 =?gb2312?B?RlF0NG5BZXpQTU9sbytiUlROMWZZOFA4SmxYN21vTDZ5SmgxSmRjOU5qNXds?=
 =?gb2312?B?eXJXb1cvR1MxT1VIcVVKWU5JRDcweE01Nmcya3MvaDlGWmQ2eXVxeEMvY01T?=
 =?gb2312?B?dVZ2V0xIM25oVjRteFU5QmcrV2RCMXVQUmR4dTZLU3pxdFdoK0k1VUdQLzd5?=
 =?gb2312?B?QUd1NjBqY0xLaWRaVnpOUTNTdDNIVzgxODQ2WDFLRHhNSzB0MGxhOEMrb1lx?=
 =?gb2312?B?cGt0QjIxeWhMYWxpWTZHZzc3c1B5THZjaEV0OHRMVzlxK2VhY2c2b01FTnd6?=
 =?gb2312?B?dHdMYkg3MUxHTnRLQ2M0UmdYOWVnRnFzQzVhaVFRS01vaXhLWDZsWjVXamxY?=
 =?gb2312?B?ZjFmVlJjbU9IVVU0cXJuTTErRjdkTkxRemtTNTR5VCt3WUUrMUNIOW1GWUY0?=
 =?gb2312?B?d3ZhcWx1RnpYbVMrZkxEK2oxTUFEejk5N1BScHo1U241eXNvdDBUL1lKS052?=
 =?gb2312?B?c1ZQUGE5MGUzdnI1WVVWRmM3WFlvemY0anlXa2syOFRLaXBiUFh3ZFZuZG1C?=
 =?gb2312?B?RlNlUjI2L2JmMEpTS2ZrdWk1cWs5TGV4ajVKTEdmcUR2TFZWbnpUWW52K1BT?=
 =?gb2312?B?eER3WjNnaWJNRHBaeHU5SzBqWXpSSUNnRnB4cFdBTTBmNmdjMVVjVU1VY2Rr?=
 =?gb2312?B?MENIeVpvOStFMmx3Tlovbk9XM21wQ0ZuUENQeUhmMkQ2cHBDaW16Y0luTEk4?=
 =?gb2312?B?THhneG95dnFuSmFsV2tSK21DL1RuQm9ZNkVuYzB2SDN1SC9Wb0g0OXpySC9X?=
 =?gb2312?B?WUY3SjI3Um9qV3B6Y3VRY1lWY0NFdWVwS0RodmpwMHpuRjZzMHloTkdUNkJC?=
 =?gb2312?B?NVYxdlozWFQ1S0p2d0RrOUEzRlVxS3dsVUV4RHZBV2IwNDVtQmdpd1ZKbUE4?=
 =?gb2312?B?S1FJSnN2YThMSWxMZ2NsMzlNWlhCY2NMVEQwMStCaUxETDQ4VmZKOWYvRmpT?=
 =?gb2312?B?M0xLUk9BYm9SMTFRREpiYytsN2w3MWc4RzBIRzNrdGZ4WmJRQWxCM0xPZTR2?=
 =?gb2312?B?SDljZllsUnZ3bDl4WjRrdWxCQmlwbXd6dERyelVlMnlUS01BdHhWZjh2STN4?=
 =?gb2312?B?VGhCMVZJLzJYT1ZZUkYyOFU5STlSQ2d2eUhzZUlSSzdTcUtEbWdWaFZPdkt4?=
 =?gb2312?B?Z1kvMFR5eXVOblBwQlJWWVNvaU9qeThPUTl1aitGYmNONTZyekhjNU10UE43?=
 =?gb2312?B?V1BzMFlvTWhJNmJqeE52RVVrVURJTWF6c0FDUzlyREw3SjBQeGRVSkdRZHJa?=
 =?gb2312?B?UnNTV1JSNXlIMlQwOFlPdWdkUmVUNW5oQitvcEZHYkNxZHdML2x1Z3Njb1Z3?=
 =?gb2312?B?dzlqbmFSb0c2VzBRMWtoTmpZQ1dGYzhsNW9xcWJhYnE4WDJ3UDk0czM4VkpV?=
 =?gb2312?B?T3lZWEZUc1prWGJmUmE2WHRZZWRtZXpCM1lHUW9tcUo0bm9QbkRyMkhKRXk3?=
 =?gb2312?B?SXZjZ2hxR1p6R0tzTEs1Q1RGN1FDOFhRNTk2alFMdDNtcnkvTm9SR3lDaE84?=
 =?gb2312?B?YXBFUUpMNWtidFh2L3AvV3dLbG9WNjBmNjhFdnFWQ2JyalpOK2FNZGllbHRs?=
 =?gb2312?Q?hR0MPS682FmtN8jdE4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c22bff3-4353-42ba-c118-08d930bb8a9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2021 11:40:29.1144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wz4eAefGh5q1n0kIORZZuWo1UGY9Q0zUJ26OsYeVNitMjnsXw74q7NsP4sGeQYdIlRoInGRszvuWzD3ufi9RMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7405
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSdXNzZWxsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIxxOo21MIxNsjV
IDE4OjIxDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBD
YzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBwZXBwZS5jYXZhbGxhcm9A
c3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOyBqb2FicmV1QHN5bm9wc3lz
LmNvbTsNCj4gbWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtc3RtMzJAc3QtbWQtbWFp
bG1hbi5zdG9ybXJlcGx5LmNvbTsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQu
b3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldCAxLzJdIG5ldDogZmVjX3B0cDogYWRkIGNsb2NrIHJhdGUgemVybyBjaGVjaw0KPiAN
Cj4gT24gV2VkLCBKdW4gMTYsIDIwMjEgYXQgMDU6MTQ6MjVQTSArMDgwMCwgSm9ha2ltIFpoYW5n
IHdyb3RlOg0KPiA+IEZyb206IEZ1Z2FuZyBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiA+
DQo+ID4gQWRkIGNsb2NrIHJhdGUgemVybyBjaGVjayB0byBmaXggY292ZXJpdHkgaXNzdWUgb2Yg
ImRpdmlkZSBieSAwIi4NCj4gPg0KPiA+IEZpeGVzOiBjb21taXQgODViZDE3OThiMjRhICgibmV0
OiBmZWM6IGZpeCBzcGluX2xvY2sgZGVhZCBsb2NrIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBGdWdh
bmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX3B0cC5jIHwgNCArKysrDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZmVjX3B0cC5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZmVjX3B0cC5jDQo+ID4gaW5kZXggMTc1MzgwN2NiZjk3Li43MzI2YTA2MTI4MjMg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19wdHAu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfcHRwLmMNCj4g
PiBAQCAtNjA0LDYgKzYwNCwxMCBAQCB2b2lkIGZlY19wdHBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpwZGV2LCBpbnQNCj4gaXJxX2lkeCkNCj4gPiAgCWZlcC0+cHRwX2NhcHMuZW5hYmxl
ID0gZmVjX3B0cF9lbmFibGU7DQo+ID4NCj4gPiAgCWZlcC0+Y3ljbGVfc3BlZWQgPSBjbGtfZ2V0
X3JhdGUoZmVwLT5jbGtfcHRwKTsNCj4gPiArCWlmICghZmVwLT5jeWNsZV9zcGVlZCkgew0KPiA+
ICsJCWZlcC0+Y3ljbGVfc3BlZWQgPSBOU0VDX1BFUl9TRUM7DQo+ID4gKwkJZGV2X2VycigmZmVw
LT5wZGV2LT5kZXYsICJjbGtfcHRwIGNsb2NrIHJhdGUgaXMgemVyb1xuIik7DQo+IA0KPiBJZiB0
aGlzIGlzIHN1cHBvc2VkIHRvIGJlIGFuIGVycm9yIG1lc3NhZ2UsIGl0IGRvZXNuJ3QgY29udmV5
IHRoYXQgc29tZXRoaW5nIGlzDQo+IHJlYWxseSB3cm9uZyB0byB0aGUgdXNlci4gTWF5YmUgc29t
ZXRoaW5nIGxpa2UgdGhpcyB3b3VsZCBiZSBtb3JlIG1lYW5pbmdmdWwNCj4gdG8gdGhlIHVzZXI6
DQo+IA0KPiAJIlBUUCBjbG9jayByYXRlIHNob3VsZCBub3QgYmUgemVybywgdXNpbmcgMUdIeiBp
bnN0ZWFkLiBQVFANCj4gCWNsb2NrIG1heSBiZSB1bnJlbGlhYmxlLlxuIg0KTWFrZSBTZW5zZS4N
Cg0KPiBJdCBtYXkgYmUgYXBwcm9wcmlhdGUgbm90IHRvIHB1Ymxpc2ggUFRQIHN1cHBvcnQgZm9y
IHRoZSBpbnRlcmZhY2UgaWYgd2UgZG9uJ3QNCj4gaGF2ZSBhIHZhbGlkIGNsb2NrIHJhdGUsIHdo
aWNoIGlzIHByb2JhYmx5IHRoZSBzYWZlciBhcHByb2FjaCBhbmQgd291bGQNCj4gcHJvYmFibHkg
bWFrZSB0aGUgcHJvYmxlbSBtb3JlIG5vdGljYWJsZSB0byB0aGUgZW5kIHVzZXIgc28gaXQgZ2V0
cyBmaXhlZC4NCg0KRG8geW91IG1lYW4gdGhhdCBwcmludCBhbiBlcnJvciBtZXNzYWdlIHRoZW4g
cmV0dXJuIGRpcmVjdGx5PyBJdCBzZWVtcyBiZXR0ZXIuDQoNCmlmICghZmVwLT5jeWNsZV9zcGVl
ZCkgew0KCWRldl9lcnIoJmZlcC0+cGRldi0+ZGV2LCAiUFRQIGNsb2NrIHJhdGUgc2hvdWxkIG5v
dCBiZSB6ZXJvIVxuIik7DQoJcmV0dXJuOw0KfQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhh
bmcNCj4gLS0NCj4gUk1LJ3MgUGF0Y2ggc3lzdGVtOg0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5r
cy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZ3d3cuYXINCj4gbWxp
bnV4Lm9yZy51ayUyRmRldmVsb3BlciUyRnBhdGNoZXMlMkYmYW1wO2RhdGE9MDQlN0MwMSU3Q3Fp
YW5ncWluDQo+IGcuemhhbmclNDBueHAuY29tJTdDYjNjODUzMjJlMzU5NDQ2ZTRlZWUwOGQ5MzBi
MDY3MDElN0M2ODZlYTFkMw0KPiBiYzJiNGM2ZmE5MmNkOTljNWMzMDE2MzUlN0MwJTdDMCU3QzYz
NzU5NDM1NjQ3NjkwMzY0NCU3Q1Vua25vdw0KPiBuJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3
TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYQ0KPiBXd2lMQ0pYVkNJNk1uMCUz
RCU3QzEwMDAmYW1wO3NkYXRhPVRINGZaSlJ1OElpNnc3eTA1TjhDSFdvUVINCj4gUjlPZWdzWUI3
VkF3Z1NwVGNVJTNEJmFtcDtyZXNlcnZlZD0wDQo+IEZUVFAgaXMgaGVyZSEgNDBNYnBzIGRvd24g
MTBNYnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxhc3QhDQo=
