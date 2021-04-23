Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20738368B78
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 05:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhDWDTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 23:19:12 -0400
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:54359
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231261AbhDWDTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 23:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYw1jHKlKxwFboXwcJy6vHiU22e5w3WOY4gYXPWeurQ/2U/56w786j7OOteuXNGFnmQghalTvunz+AgitgU8NJTRdV5J4VOKoKIw9P10/zh7P0FH4NR1jgQZMqpvx7zYao+8s5/97TdTof0dN1NhaTC5iBneHXk0AV+Q42TSS8yqUdGwhMLDbIXfVytM73000POWm8jPaFD5CXDDotBsw4L6RJ446IjGRUJMoKB+g+gQZsFX/3CKAK+p8c2Ujp6tt/NBYmHzsYqsF7p/9G4XRrk3qh6z3JlfsextQ8aWSVtYd+Qd8Ut9vSqM8pOjCNnQ1NG1keVP3cKZj/VUvC+SlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRE9ecdOzt/285XUBAoTfXWWbdO8yYKeS5O/Tdh9Jrc=;
 b=nZLiST0pQHe3TXRoaFPtHTJjk5zWAidoTzyQKa8SUgs65PAjt6Q3I9nr434Lk3ygVdRxUiN0I40KDPKQT30mf2odABzLtc+opMnWn35r/A6mZ79ZN6UsfzrAbfdub0yh3TC56pSQChpH860/FbA2MCKT0JOcI5ARemTKzEV4vwbPUtOCS0Ns7MV4J+UrrLs2DMSeyqalEeJprsHnOjajNlYygyhyRcUea8RRZgNKFngLvPsqz/bi/7Xh9cjJD5LUtoMz2tbRMrdWOmZsF/gS93IwyaNTW0bMh2TlGPzkMqqzBsFHvGXVO26fkSqy3Nq+yrD5+habkqf91p3OTD6byA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRE9ecdOzt/285XUBAoTfXWWbdO8yYKeS5O/Tdh9Jrc=;
 b=PGm25Vucw017dcBxNDRPoibCFjdJDWjMqHUqi1C2Og95aajUX4Mjf2yJ+78BaS0rOPI2TlwoyTIDxPQi3Ak5O3a+tL7pZ2kt5Wbexk3bmIxPdI6P3NEW6g/0fGXux7ZI2S+F84dq7yLVcsngjIPjK5i0aWA2EeHVXz/U6xJKT6o=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7836.eurprd04.prod.outlook.com (2603:10a6:10:1f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 03:18:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 03:18:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: RE: [PATCH net-next v3 0/6] provide generic net selftest support
Thread-Topic: [PATCH net-next v3 0/6] provide generic net selftest support
Thread-Index: AQHXNRwagqYg3yRB0ku+UvQ/Kt5swqrBcaDg
Date:   Fri, 23 Apr 2021 03:18:32 +0000
Message-ID: <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
In-Reply-To: <20210419130106.6707-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 074f4378-2539-4d79-306d-08d906067984
x-ms-traffictypediagnostic: DBBPR04MB7836:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB78361B1D0CD19D4027C29265E6459@DBBPR04MB7836.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUjo64pPRthoMH4mN0FBO/CgWhqpQpMmznR95JHkEpdhBr9XJ+7svggE8wQLPi8C+t0wB+sNpUaf8zrAY/ytnsiWlWJGXs/eeospBFgwvmfhG5izFUJfO1CrJoO/gLPMmlFEB1E++ZaZqTa7RNzbWJuUfm9SDfCp25GWa3IXS1sdvRkQ7nPaItInqNBzjkugc5TkjImqntEpey4/1P2RxqANm0t4eFsiA3Mye69wo1c25J87CkT2DdBPeSRSyY6NNj/ujrAOTB7PcyvPZIAJfBngNoylloluLps9av6cGUHXQv+xb+uxptL1qrw+taBVlH69ntqIM7e/Ib74ocR5zj+ZcN3IIhGIIL/fKW3zuED/i5Tg/oTq54jU8TV1kwk3gQDtJdlqu++2omAMNa8PDLP305Owke04aDQ1ZO2npYqn1/IxI1xCCtgvLd3gyBR3spqiHIp4vXhvdGK+IFR47dlrOHCnDVS79yFaW2OtHds6CT7iCn5zoKfpR+3liZ9MEiv8IW4jb8PljThMVzR8Qk00I3fdwk4LItZRIM48YWfDvsQ4PcKJ14FKwUNx0tsM3u00aeObsxrNjJHL2oinNQrq6bNjOIqhOHbuEt2MKiRFYg2ZXaI6czDbxE7DqZY0rPQ8VFLYem4zb3bSbxe9rQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(7416002)(53546011)(76116006)(66946007)(66446008)(64756008)(66556008)(6506007)(71200400001)(54906003)(8936002)(7696005)(66476007)(8676002)(4326008)(52536014)(2906002)(38100700002)(55016002)(5660300002)(26005)(186003)(83380400001)(6636002)(33656002)(9686003)(122000001)(86362001)(478600001)(110136005)(316002)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?QnM4UWROYllJak9KUkl0TWRrMys0anNGVXM3MVNNeHgrb3QvdnlndFdJVWFB?=
 =?gb2312?B?STBtVUVGb2d2Zk8xQmt1TmtDV3h5Z3lCZnQyYkwyKzYzS2lYcEl1NUFXVUZM?=
 =?gb2312?B?WEV4UUcwRVZERlNaSlJER3dSU2J3VzRGbE8zNnluekNucmhnbzBUMVhKNXNr?=
 =?gb2312?B?ZGtLZTZISm5Cb2N4NE1NZTBFNXVyNlNOaWJJT0xwVXZmZUFwa0VLNTE0N3JV?=
 =?gb2312?B?VHd5Y1RoK1hTcEZSZGJCQTdGUU1BcjdrN2ZOR1hMbjR6VkFOYko0WUpZMWFw?=
 =?gb2312?B?QTJrZWVleWRnNlpJSHhaSDJobjF0SU9VNTdxMGdnejFURUJLSkptYjRIZWd3?=
 =?gb2312?B?eHkxNFEwdlhsVVlYUmhqaVdGRjBiMWlzM21ValQ3bmp2bzBEa3VJMUttU0Vl?=
 =?gb2312?B?RDBvMzVEajRza3dJa1FOZ0l5cjJobGhYbDVtNnZxOFJXMWJPREdTUFFReFpZ?=
 =?gb2312?B?SmQ2MUE1NTdVSmwxTDJTWitHOWlQakpyZjlKN3dxMExVemluSS9RZk9SNklX?=
 =?gb2312?B?VWMyc1NCWWhEdEsvYjBGZGxxTXJoWCt4MXhOV05CeWxiay9hSWFzNFI1ZG96?=
 =?gb2312?B?eE14MGg0VGYwMkZnYW41T1NCYVFLS09KTjQ1VWJyaXUreFQveUxUVTdGcHpj?=
 =?gb2312?B?ellWcnFKR2cxNnBpdmU0ckwrZFRoL3FYTkVlMmp4YU9QSzhVWUdkd0wzU0hU?=
 =?gb2312?B?dTkxSGlnNzFhd3o4SG1lcHg1SEsrY1RGL0lXcUVMRHJzMGI4RzBHRHBQV1dF?=
 =?gb2312?B?aUU3VGNSTExFUXkwVldLdFZvZGVrUGg1K3hKVWJCcC91UjQ0b3ZTd2RCNHVL?=
 =?gb2312?B?VS8yVkZqSFJpRndVY3owanNTVUppWkdnL082Q1FZdEhBMVloa3NJOFlzT0Za?=
 =?gb2312?B?aWVYdmZ2aXZXS3VvRE9xTGJoVkZFMndsSmRSd3ZUNEsrbzUxVnZKTTVpZDVo?=
 =?gb2312?B?YXpnYmt1S2tlWlZXY2NXck9WODh6b1lEcFJPWXE2Z0ZhakZXVndsNUsyZWtF?=
 =?gb2312?B?cjllVnVmdExiS2g2Rnkzdzc5ZzF5NU9hellUdXZZYWU3UVowRHk3djg4UEtM?=
 =?gb2312?B?MWRieXF3OEJkYUluUnNwZHcwdERocS9QcGhYUEpkdVVON2NCU3RBUjVVdCtO?=
 =?gb2312?B?UUtoUGNBNEhYMDVUZ0hlYkRseW1SQjFvVFRTTkdvQ2JBZGVGUUpFMS8yYkM4?=
 =?gb2312?B?Z2Nwa3kxZnlCMW5BVmFYSWozMjZiMXpSODhhWHZ6dGN1WFJVeGdadVZFZExR?=
 =?gb2312?B?UXNibFg4RFRibE43U0Z1MHdRbUNwcm9BME50M3ErdFhzbUxwU3pMMCtjN2E1?=
 =?gb2312?B?bW5GSXovYzZjVTl2RENXUzVzS2VvdkwrL0JzZDkvUG5lVFpGTGFCSis3YnRt?=
 =?gb2312?B?ZW9DUXdPdzJHSzNNSnJoeUtVcjRkbHFRbXdSV1JXRDZXbTh2VW12YmI0eDdR?=
 =?gb2312?B?eUNzRkJPUnhZS0w5WEY3cXJ5Q2NVWS9RZTZhUkhJSlZLaVpmOXhrVHhya2lV?=
 =?gb2312?B?MGFQNlFldkhaUS92WUFBNTJ1am15dHJ6UTBxaTkvV0wxbkZEK2t3eFdhMllj?=
 =?gb2312?B?T2VKVWhuU1dQVVd1a2djZWJ6aHI1WlpBMjNXbGw3NkJsbTFpWFBDN0JXMDVz?=
 =?gb2312?B?Ui90T3FKNTB2L0M0bjViU1I1MFo4R3l4cXYzblVFaCswdnNYWlRPMTlqQ2NX?=
 =?gb2312?B?NWlnUVNnQS9sa2xIUGJiNkhoTmRpandaOWN5OE5CRWlGZWVBM0ZtYjgrYXdJ?=
 =?gb2312?Q?ygH1kHhkK9wEizmG+7SGrEbcJHlluy/8Z9hsViN?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 074f4378-2539-4d79-306d-08d906067984
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 03:18:32.6538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LKjNoH7IJmSBwwSLXMEZuAiIX1Qxl4pUWY1PGccweuuK1DrIiFtqsyXz5BJDDVgRqeJ6TH5StOgwXjo3XEt1aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBPbGVrc2lqLA0KDQpJIGxvb2sgYm90aCBzdG1tYWMgc2VsZnRlc3QgY29kZSBhbmQgdGhp
cyBwYXRjaCBzZXQuIEZvciBzdG1tYWMsIGlmIFBIWSBkb2Vzbid0IHN1cHBvcnQgbG9vcGJhY2ss
IGl0IHdpbGwgZmFsbHRocm91Z2ggdG8gTUFDIGxvb3BiYWNrLg0KWW91IHByb3ZpZGUgdGhpcyBn
ZW5lcmljIG5ldCBzZWxmdGVzdCBzdXBwb3J0IGJhc2VkIG9uIFBIWSBsb29wYmFjaywgSSBoYXZl
IGEgcXVlc3Rpb24sIGlzIGl0IHBvc3NpYmxlIHRvIGV4dGVuZCBpdCBhbHNvIHN1cHBvcnQgTUFD
IGxvb3BiYWNrIGxhdGVyPw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gLS0tLS1P
cmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBl
bmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDIxxOo01MIxOcjVIDIxOjAxDQo+IFRvOiBTaGF3biBH
dW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+OyBTYXNjaGEgSGF1ZXINCj4gPHMuaGF1ZXJAcGVuZ3V0
cm9uaXguZGU+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBGbG9yaWFuIEZhaW5lbGxp
DQo+IDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBn
bWFpbC5jb20+OyBGdWdhbmcNCj4gRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gQ2M6IE9s
ZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT47IGtlcm5lbEBwZW5ndXRyb25p
eC5kZTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5p
bmZyYWRlYWQub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1p
bXggPGxpbnV4LWlteEBueHAuY29tPjsgRmFiaW8NCj4gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwu
Y29tPjsgRGF2aWQgSmFuZGVyIDxkYXZpZEBwcm90b25pYy5ubD47IFJ1c3NlbGwNCj4gS2luZyA8
bGludXhAYXJtbGludXgub3JnLnVrPjsgUGhpbGlwcGUgU2NoZW5rZXINCj4gPHBoaWxpcHBlLnNj
aGVua2VyQHRvcmFkZXguY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgdjMgMC82XSBw
cm92aWRlIGdlbmVyaWMgbmV0IHNlbGZ0ZXN0IHN1cHBvcnQNCj4gDQo+IGNoYW5nZXMgdjM6DQo+
IC0gbWFrZSBtb3JlIGdyYW51bGFyIHRlc3RzDQo+IC0gZW5hYmxlIGxvb3BiYWNrIGZvciBhbGwg
UEhZcyBieSBkZWZhdWx0DQo+IC0gZml4IGFsbG1vZGNvbmZpZyBidWlsZCBlcnJvcnMNCj4gLSBw
b2xsIGZvciBsaW5rIHN0YXR1cyB1cGRhdGUgYWZ0ZXIgc3dpdGNoaW5nIHRvIHRoZSBsb29wYmFj
ayBtb2RlDQo+IA0KPiBjaGFuZ2VzIHYyOg0KPiAtIG1ha2UgZ2VuZXJpYyBzZWxmdGVzdHMgYXZh
aWxhYmxlIGZvciBhbGwgbmV0d29ya2luZyBkZXZpY2VzLg0KPiAtIG1ha2UgdXNlIG9mIG5ldF9z
ZWxmdGVzdCogb24gRkVDLCBhZzcxeHggYW5kIGFsbCBEU0Egc3dpdGNoZXMuDQo+IC0gYWRkIGxv
b3BiYWNrIHN1cHBvcnQgb24gbW9yZSBQSFlzLg0KPiANCj4gVGhpcyBwYXRjaCBzZXQgcHJvdmlk
ZXMgZGlhZ25vc3RpYyBjYXBhYmlsaXRpZXMgZm9yIHNvbWUgaU1YLCBhZzcxeHggb3IgYW55IERT
QQ0KPiBiYXNlZCBkZXZpY2VzLiBGb3IgcHJvcGVyIGZ1bmN0aW9uYWxpdHksIFBIWSBsb29wYmFj
ayBzdXBwb3J0IGlzIG5lZWRlZC4NCj4gU28gZmFyIHRoZXJlIGlzIG9ubHkgaW5pdGlhbCBpbmZy
YXN0cnVjdHVyZSB3aXRoIGJhc2ljIHRlc3RzLg0KPiANCj4gT2xla3NpaiBSZW1wZWwgKDYpOg0K
PiAgIG5ldDogcGh5OiBleGVjdXRlIGdlbnBoeV9sb29wYmFjaygpIHBlciBkZWZhdWx0IG9uIGFs
bCBQSFlzDQo+ICAgbmV0OiBwaHk6IGdlbnBoeV9sb29wYmFjazogYWRkIGxpbmsgc3BlZWQgY29u
ZmlndXJhdGlvbg0KPiAgIG5ldDogYWRkIGdlbmVyaWMgc2VsZnRlc3Qgc3VwcG9ydA0KPiAgIG5l
dDogZmVjOiBtYWtlIHVzZSBvZiBnZW5lcmljIE5FVF9TRUxGVEVTVFMgbGlicmFyeQ0KPiAgIG5l
dDogYWc3MXh4OiBtYWtlIHVzZSBvZiBnZW5lcmljIE5FVF9TRUxGVEVTVFMgbGlicmFyeQ0KPiAg
IG5ldDogZHNhOiBlbmFibGUgc2VsZnRlc3Qgc3VwcG9ydCBmb3IgYWxsIHN3aXRjaGVzIGJ5IGRl
ZmF1bHQNCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL0tjb25maWcgICAgICB8
ICAgMSArDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL2FnNzF4eC5jICAgICB8ICAy
MCArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL0tjb25maWcgICAgfCAgIDEg
Kw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAgIDcgKw0K
PiAgZHJpdmVycy9uZXQvcGh5L3BoeS5jICAgICAgICAgICAgICAgICAgICAgfCAgIDMgKy0NCj4g
IGRyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMgICAgICAgICAgICAgIHwgIDM1ICstDQo+ICBp
bmNsdWRlL2xpbnV4L3BoeS5oICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ICBpbmNs
dWRlL25ldC9kc2EuaCAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArDQo+ICBpbmNsdWRl
L25ldC9zZWxmdGVzdHMuaCAgICAgICAgICAgICAgICAgICB8ICAxMiArDQo+ICBuZXQvS2NvbmZp
ZyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNCArDQo+ICBuZXQvY29yZS9NYWtl
ZmlsZSAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ICBuZXQvY29yZS9zZWxmdGVz
dHMuYyAgICAgICAgICAgICAgICAgICAgICB8IDQwMA0KPiArKysrKysrKysrKysrKysrKysrKysr
DQo+ICBuZXQvZHNhL0tjb25maWcgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+
ICBuZXQvZHNhL3NsYXZlLmMgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyMSArKw0KPiAg
MTQgZmlsZXMgY2hhbmdlZCwgNTAwIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pICBjcmVh
dGUgbW9kZSAxMDA2NDQNCj4gaW5jbHVkZS9uZXQvc2VsZnRlc3RzLmggIGNyZWF0ZSBtb2RlIDEw
MDY0NCBuZXQvY29yZS9zZWxmdGVzdHMuYw0KPiANCj4gLS0NCj4gMi4yOS4yDQoNCg==
