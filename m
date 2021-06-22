Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B713B0131
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhFVKVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:21:20 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:19428
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229912AbhFVKVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:21:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8ETet/xZltSC4P+tw10CnkKItnVz+O4rmAGh3Xyc5TZATXSc8ZqNeya8vTlhT2xQatlgTv6LvD8g/tJMc4UCFIVA94zLzhxIdCaVvMiSMcOBDDAwF8VFLIxCHEDVMylJhJCOK9P5a/YjgVm0sErjlPyuJ4mfXfyhv2+IINQWELKhlySoELYnNdj1nfSBDtDJZiZZ2b5sFqTzG+YMnqW1Gqn5poCwpbHzZSvRoXTjv2975au80IMFpKv1kSEWyW2TLaCqXyfkzYyUvlWcB9HuF7DKHQv4gU9J71eJI/j4qT2z3uqeou7kLbqJP1XxBtN5q6sxnDPbwE82QlkskEsVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ9RR3kuGVfVnlDmalCxaZGYKbNksMUg6+mDVvsNNRs=;
 b=BkHZks4BA4TFcSUpOrvt4FzghcnBtuu1BM4m40Lk0nqfQr3M9wjd8O0/heT7Mg7PpQH4Ipmb1pcQYwdD2FUjKueTScoyJSvCjYnLwDEGz9q4Zi9EjL2xi1AxspqyJeb3jDXi3V6UOhiQI0B4MlR6156+rMPCKEh02dwKL1X9GZo8iDLIS+yILq5u+M1RHk0iJG5PJeR/utNAU4pCaIJnwOSIzkIHFMTiZuVoou1Obpg/XcettLiVOyE1IxpQ5ldfQgB9MPIJsk2VYDA2GxVU38hBKIU9xX+MyBfHBTMYcTB2FQh10O2UywvD9/daOJdeKysZXDUjUwiaCtq5AhyBIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ9RR3kuGVfVnlDmalCxaZGYKbNksMUg6+mDVvsNNRs=;
 b=YP61gSc/TFnac1ivORYXD10fMambs1H1DYH2FA4jtTb6bqoKopwddOiS0DiMEJx6S9Fcn8/cTbpWngmIeOPszeZQJqal7i98OYp3QpvFpoIaI9ZXK57ZeKmc8MgZsGby6P6dIyvIcddQOIGPmbG4s+R8iZBy118xEx+JGrFtZvs=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB7PR04MB5420.eurprd04.prod.outlook.com (2603:10a6:10:8e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 10:18:53 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:18:53 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Topic: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Index: AQHXYcnwaUvaYN3/1UWKJ0RWryDTcKsYfMqAgAdfZ7A=
Date:   Tue, 22 Jun 2021 10:18:53 +0000
Message-ID: <DB7PR04MB5017AF07C3264A10FD7447C1F8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-3-yangbo.lu@nxp.com> <20210617174247.GB4770@localhost>
In-Reply-To: <20210617174247.GB4770@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22792ceb-6d45-498b-15cc-08d9356722d3
x-ms-traffictypediagnostic: DB7PR04MB5420:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5420E4C1B6F0C91DC27101CFF8099@DB7PR04MB5420.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W9OaCMmfKD0nbDBcjqntF4MDeGDx8PjSsAYDtGy2W2+Cu5YB747oykw9XlXTBNsQbZXmsWahKaO3UCa5YytHfXQ4mEztTQwBV+nSt/aaNO6SubQRdCkFsdGEzMHtnphyvGiAIEovswemzjnuanQk2VdEBOf5DPuGz7WqLrRHdxf8VjzUae2qjoP3Ax3kMH5MvDUcgCX7WNfMnNmhgh4xzVBfMeq5Pp1KNQhoh007taZrjoI1AbMKxquYAu2qrmbMgILOoMREbuS2vcDMldJpTmek2d/zfDvjw2dA8M/8JQagewC6V+9Aw/elkhQzLzsPTh1JUvk2XdDjfBEKatEby0vTd2xIIH16Wf2WFlaO+nCS54bShHnaDSJPQlrlQiV4z1yaB3tLQ7IboFfdpTg9OqDSLnfI1XBjaILjo0BoCYMTtCNABV+eO0xrIklqmQU1lGiH0rvYZC8XZ/prhlCMoajXeeGgkXxUuIgzGkV/r5aA03isudsaljYw+rbq1eb+4nsMhNAC3JzdMtz/ZP3LWM8J5SKcO54jqTCxSFIE0NYBjOxt7LT4CGnL29iz0Ft6C1CeebVDFMRKDjc0b/iw/Qm8mmqrYFalSIJ4eVp62UM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(86362001)(71200400001)(64756008)(33656002)(7416002)(53546011)(66446008)(66946007)(66556008)(6506007)(186003)(122000001)(2906002)(66476007)(4326008)(6916009)(26005)(76116006)(83380400001)(38100700002)(52536014)(8676002)(7696005)(316002)(5660300002)(54906003)(55016002)(9686003)(478600001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?RmU5R2FxbHdtamJCZFFWZWVpR0FWL3BpVEpxTXRDQkYrUklpaHp2UURaWU9p?=
 =?gb2312?B?eFlPVVhmUFNzL0dWWkxuMzhDQnZXWWJqVTBBZkd4UWc4a21CYU9QYmpldHdo?=
 =?gb2312?B?cXR2V29ka1NsbGRjOGtmZGxjUm91bUM3djBkRlJqdDFGZ09oU0thTnVkRkZL?=
 =?gb2312?B?V1MvMEYrR0h5OXZsZ1pVVkx2MTMzelgzQ1N6bC9VMTdMOXl6K3ZaY1hXYUJB?=
 =?gb2312?B?dkFTRldCTVhLOURTUmhpbzRPOGQ1akF5N3REWkdUb0RVRk9kTWFiN1ZFRFE0?=
 =?gb2312?B?ajVFc3l2eTRBOGlNc3VtallJWmMyRG16ZkNSeFpYbzJRbUZLS3ZnZ0RTUWZO?=
 =?gb2312?B?Y0pubUdkMTdRTzBHdzRsYW1QTlQzWHpKbmNLbnlyNVRNQ0hyRWh4VDRldUxT?=
 =?gb2312?B?NkYveWFWUHkxTy91Y2hUWG9kUC9vZlhMMzdVSXJLNTE0WXZPTFVuN25kWlFT?=
 =?gb2312?B?ZkxHaXhSOFkwNCtqakQrN3VtUzVXQXdub2h1UWY1SXNWMmJVRUhTQ1ZmL1Bp?=
 =?gb2312?B?OW1XQ0h6RlpCcTR5cDY4SHloVDU5M3g4U0QxWGN2OVpPMkZCS1dRUUNGczlx?=
 =?gb2312?B?djhYK1JMOWZoTGh5bTBFVjNiUFNDVDUxRkdOL201V0VJQ1l2UjRPUWx1emk4?=
 =?gb2312?B?Y2tkQ2pVemdNLzdLMWpUM252Ni9aR0o4OFZLY0FIQ2s5VlNSOTFWL2o3TFNK?=
 =?gb2312?B?MUorS3p1bTkzRlQ4QjZzeUZoRlJ3Wk5LMmJ6OGZpVkxJZXZFSklFRGFSMWtq?=
 =?gb2312?B?R01XbVJvZGZFZGMzVWxGUE9kbUZiQWpGbjNDS2hHSytZZUVaU3hJZVE0bkNl?=
 =?gb2312?B?L2k4WVY4MUxiTWVGbzh0NGVSQ1ZqZjVSa0R2Qjd5Tm1Yd2hTYXAvRHY1d1hp?=
 =?gb2312?B?eG8wckVqS0lqWnU3M3k3VjgrdlNGR1pKNmErVFowMnNQNnhnV04xSTM1Q3cy?=
 =?gb2312?B?MG9xbFJUTnIzbEdud2JOQTd6VEtDSlc3OWVIcUgwK0FGeXp6TzNuREFYU3BM?=
 =?gb2312?B?MERrNDE5WGs4NWdxV25CajlmT2t2bTJ1YmxlSCtYSkVXRTlneVlJc3FJNVR2?=
 =?gb2312?B?WW9ydUpEVTAzc0V5eUFuZUhicE84ZFY1cHFua1I1UUc3aTd6T0pmZ0NoYnk1?=
 =?gb2312?B?YjZ5S0dlREtEZjFhSUVNWU1zRE8ydnViRFNjSXZtVTVxUVBoQUsxeVJZeGtQ?=
 =?gb2312?B?M2ZwdkYxMUZOUW0yNTlQbGZVRTIwK1FEMStYRDJZY01OT0FnOEtvZ3I5N1dt?=
 =?gb2312?B?bVAxb0FPZmhqLzJvZmxNTUdGeFEybHRadlByN01GT2FZZ1YvUzUwQ2lIZk5Z?=
 =?gb2312?B?eVRURzRJSUMrUU83UmhJd2ljWUYybW5EQjZMRjd6UjdKNTlneHptTXJkZXJl?=
 =?gb2312?B?UXBRK2Rlb1NjNjRyNWdOaitPeUd3NWVHOHVsdC8vMk9aVXlobEpsaW05TjAx?=
 =?gb2312?B?bkc3VjNJWERQSlRYRTRNQ1lueDdXV0RBc2NRaktneS9RUXd3dS8wdmd6RWh4?=
 =?gb2312?B?MzQyeVV2WVhvRmlRbnFOR0ZsU1FxV1JyNytmaFFaSEMwYlI1WFA5bjA2UVE3?=
 =?gb2312?B?K3RuMTZTaXhCc3NCMFJtNEYwY0E4RHVIYnQ2N0thVVhXeXZpcjcyMTFqbCtT?=
 =?gb2312?B?S0dNWGpPOWREeTJ2R0YvdTdMQVpLeFI3UlNHeGd3S1lXZkl1YTI5RVoxOGVv?=
 =?gb2312?B?S0FwUkhJckhrSnlBU3JFemlvMXluM3U1L3FSaUM4blRaRGZhOTlXcG1xSlEr?=
 =?gb2312?Q?sHkE8eeaFbwYyKKDkf4afQIeXDJNox2zsx/VtjO?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22792ceb-6d45-498b-15cc-08d9356722d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:18:53.0219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a3mvgzPgJgoAe47paLiwqN+vQQGKaUefFCBNRjBMHMVd5HgCmxRzTLv7CHvd24dabasNT6MwS0Lrs0wNKcysZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNtTC
MTjI1SAxOjQzDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4
LWtzZWxmdGVzdEB2Z2VyLmtlcm5lbC5vcmc7IG1wdGNwQGxpc3RzLmxpbnV4LmRldjsgRGF2aWQg
UyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+OyBNYXQgTWFydGluZWF1DQo+IDxtYXRoZXcuai5tYXJ0aW5lYXVAbGludXgu
aW50ZWwuY29tPjsgTWF0dGhpZXUgQmFlcnRzDQo+IDxtYXR0aGlldS5iYWVydHNAdGVzc2FyZXMu
bmV0PjsgU2h1YWggS2hhbiA8c2h1YWhAa2VybmVsLm9yZz47IE1pY2hhbA0KPiBLdWJlY2VrIDxt
a3ViZWNla0BzdXNlLmN6PjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+
Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBSdWkgU291c2EgPHJ1aS5zb3VzYUBu
eHAuY29tPjsgU2ViYXN0aWVuDQo+IExhdmV6ZSA8c2ViYXN0aWVuLmxhdmV6ZUBueHAuY29tPg0K
PiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MywgMDIvMTBdIHB0cDogc3VwcG9ydCBwdHAgcGh5
c2ljYWwvdmlydHVhbCBjbG9ja3MNCj4gY29udmVyc2lvbg0KPiANCj4gT24gVHVlLCBKdW4gMTUs
IDIwMjEgYXQgMDU6NDU6MDlQTSArMDgwMCwgWWFuZ2JvIEx1IHdyb3RlOg0KPiANCj4gPiBkaWZm
IC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1wdHANCj4gYi9Eb2N1bWVu
dGF0aW9uL0FCSS90ZXN0aW5nL3N5c2ZzLXB0cA0KPiA+IGluZGV4IDIzNjNhZDgxMGRkYi4uMmVm
MTFiNzc1ZjQ3IDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lz
ZnMtcHRwDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1wdHANCj4g
PiBAQCAtNjEsNiArNjEsMTkgQEAgRGVzY3JpcHRpb246DQo+ID4gIAkJVGhpcyBmaWxlIGNvbnRh
aW5zIHRoZSBudW1iZXIgb2YgcHJvZ3JhbW1hYmxlIHBpbnMNCj4gPiAgCQlvZmZlcmVkIGJ5IHRo
ZSBQVFAgaGFyZHdhcmUgY2xvY2suDQo+ID4NCj4gPiArV2hhdDoJCS9zeXMvY2xhc3MvcHRwL3B0
cE4vbl92Y2xvY2tzDQo+ID4gK0RhdGU6CQlNYXkgMjAyMQ0KPiA+ICtDb250YWN0OglZYW5nYm8g
THUgPHlhbmdiby5sdUBueHAuY29tPg0KPiA+ICtEZXNjcmlwdGlvbjoNCj4gPiArCQlUaGlzIGZp
bGUgY29udGFpbnMgdGhlIHB0cCB2aXJ0dWFsIGNsb2NrcyBudW1iZXIgaW4gdXNlLA0KPiA+ICsJ
CWJhc2VkIG9uIGN1cnJlbnQgcHRwIHBoeXNpY2FsIGNsb2NrLiBJbiBkZWZhdWx0LCB0aGUNCj4g
PiArCQl2YWx1ZSBpcyAwIG1lYW5pbmcgb25seSBwdHAgcGh5c2ljYWwgY2xvY2sgaXMgaW4gdXNl
Lg0KPiA+ICsJCVNldHRpbmcgdGhlIHZhbHVlIGNhbiBjcmVhdGUgY29ycmVzcG9uZGluZyBudW1i
ZXIgb2YgcHRwDQo+ID4gKwkJdmlydHVhbCBjbG9ja3MgdG8gdXNlLiBCdXQgY3VycmVudCBwdHAg
cGh5c2ljYWwgY2xvY2sgaXMNCj4gPiArCQlndWFyYW50ZWVkIHRvIHN0YXkgZnJlZSBydW5uaW5n
LiBTZXR0aW5nIHRoZSB2YWx1ZSBiYWNrDQo+ID4gKwkJdG8gMCBjYW4gZGVsZXRlIHB0cCB2aXJ0
dWFsIGNsb2NrcyBhbmQgYmFjayB1c2UgcHRwDQo+ID4gKwkJcGh5c2ljYWwgY2xvY2sgYWdhaW4u
DQo+IA0KPiBUaGUgbmF0aXZlIHNwZWFrZXIgaW4gbWUgc3VnZ2VzdHM6DQo+IA0KPiAJCVRoaXMg
ZmlsZSBjb250YWlucyB0aGUgbnVtYmVyIG9mIHZpcnR1YWwgUFRQIGNsb2NrcyBpbg0KPiAJCXVz
ZS4gIEJ5IGRlZmF1bHQsIHRoZSB2YWx1ZSBpcyAwIG1lYW5pbmcgdGhhdCBvbmx5IHRoZQ0KPiAJ
CXBoeXNpY2FsIGNsb2NrIGlzIGluIHVzZS4gIFNldHRpbmcgdGhlIHZhbHVlIGNyZWF0ZXMNCj4g
CQl0aGUgY29ycmVzcG9uZGluZyBudW1iZXIgb2YgdmlydHVhbCBjbG9ja3MgYW5kIGNhdXNlcw0K
PiAJCXRoZSBwaHlzaWNhbCBjbG9jayB0byBiZWNvbWUgZnJlZSBydW5uaW5nLiAgU2V0dGluZyB0
aGUNCj4gCQl2YWx1ZSBiYWNrIHRvIDAgZGVsZXRlcyB0aGUgdmlydHVhbCBjbG9ja3MgYW5kDQo+
IAkJc3dpdGNoZXMgdGhlIHBoeXNpY2FsIGNsb2NrIGJhY2sgdG8gbm9ybWFsLCBhZGp1c3RhYmxl
DQo+IAkJb3BlcmF0aW9uLg0KDQpUaGFuayB5b3UhIFdpbGwgdXBkYXRlLiBUaGF0J3MgYmV0dGVy
IHRoYW4gbWluZS4NCg0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJkDQoNCg==
