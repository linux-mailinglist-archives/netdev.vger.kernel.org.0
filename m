Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B584932A2E2
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbhCBIfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:35:22 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:59364
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1443599AbhCBCWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 21:22:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laYRSnNQeYt3LXPHHUlkfYtY+NOrlsp3UKwujHCIcRRBuK0r5Jfv/nE9hSsjKrrJIG/BZRmkP76LRH2b/5QVchIdvwMkuxZ46DstwUNEyo5XB2oyIg2L2fSS3GrBVG9mIKfwpUjevmwlrBgRIOnykqtjnK+PeAjvUS2KUDEFpAUXg6o+JYp1JzSGiG0mZxxLRJR40oaiFhFIBlp+cLELmsZZxu3wVRONE0Ek+sDPKcJIq1DvqEXVaoJy5QigfkHo92R2l0k0vzXZZWysODn131d2uLYIB/LicJoqmAjnOKF2z7Q8HvhqbZCPF45bzmL89Nt+Zjyefro20KiPlWCNWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unfuyWI8J5mwT8eh7EDekXdPWfeyWAGZ4bQPoC9C8vE=;
 b=fXg0tmuZS0883Ugux7n4i+R23CJdlfFV+ZeOHmj7+XD6GgqbQ+IfaUWXMVt2PKtFPQcYO5TxPt1/5X5GhHpBZVcw4QL4TnUL020twaej2RNHbt9/X/hpdAa32rCMe+6aHXPDkg7MdHTgAkRk1Mki6VbHkdbm0jwiXEvOYuYycsUx4mMVweb1mQ/iYb0ikh1AUigIavTzJlqMQ1IZ/oQY0Mj6OX4IFM5ksj6Mb3zDLrsxKtTvCKhBP5KMcsgDlFuibY7Le+JWf8n5/IWpXkOMrTvwkjfuStbBjCKaK7KeFpmkJZ66kEAoCEGE2uFkdtHHE9SOAxjmry4GR2p5V+NexA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unfuyWI8J5mwT8eh7EDekXdPWfeyWAGZ4bQPoC9C8vE=;
 b=jGytmp9kH6A2vgJSxyj4qh4XGuQufg3sV4WDzpj1inZRMp0ibT7LDKFl611A1etOVwZudSRtiorWs4GW1cKCw3F+O40CjRFWVDTHPb0KnCcMwjLQZuMaNBk8ce4vZ7Pk3AiUO7CXCNJZK2G2yGicawaiOW23BJw9zIJqUQkGfpA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 2 Mar
 2021 02:21:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 02:21:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
CC:     Andre Naujoks <nautsch2@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v4 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
Thread-Topic: [PATCH net v4 1/1] can: can_skb_set_owner(): fix ref counting if
 socket was closed before setting skb ownership
Thread-Index: AQHXDCHTtD8a1IStAEOrE/v6wJPl7Kpu+jmAgAECOFA=
Date:   Tue, 2 Mar 2021 02:21:57 +0000
Message-ID: <DB8PR04MB6795BAF9C67A76515C5C6F27E6999@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210226092456.27126-1-o.rempel@pengutronix.de>
 <DB8PR04MB6795A03ADFAE983568087CB3E69A9@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795A03ADFAE983568087CB3E69A9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e2f6dca-d30b-4b8c-6db0-08d8dd21f42e
x-ms-traffictypediagnostic: DB8PR04MB5787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5787FFEADDFDA8163125F3C6E6999@DB8PR04MB5787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6X9AV1eElrsUH2OoY9/XN2VjR/s9naGSh3xlLB8MlLQ9jIGLrYW1TRGIsArXIC2T3SirtrXnwl4dn+IyyaS7xFOCmAHythKWV03as7d2n59435CEkgHx5OXk5Z3vvcSfx9L5iDL4SRaMGA6PmiSuPzuPo6nQdf+toK7QmGFIsEjCfPLKtaEpza/PN4TwKCOFMDO4PW9yir1VOUIe2tliCiUAjIer4x4grWY7PtbweT+WAB6IVQdVlXnHVIUHpliVyGhBEx1cQ+MV+EkffXev2bO4tj4dQUjdpy8xC40rCxZ8GR/VbUqXltSJwHF0UXCAR1wOZ+d3O65n/7UDJ3g7ekWLVGtKLooiR2SDiOvYZpsYbxohOSLMfEE39r5C2yqzvYbUFth49zgkVqbVLFaRnT/lRQzRxkrHVn8DhKXvCTfU2S4btiuIyyXJys5MSjAObuA+cmYDo3Yx6DcZUkNfRjUnAXpiHtrzbcjYhZOfl7DEb01PrIqOUxhKSYRPFzZs41BlvxC7UweGTZ3WeFMhRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(52536014)(33656002)(2906002)(478600001)(83380400001)(7416002)(66446008)(5660300002)(66556008)(66946007)(64756008)(53546011)(6506007)(9686003)(66476007)(316002)(4326008)(54906003)(86362001)(55016002)(45080400002)(110136005)(26005)(76116006)(8676002)(71200400001)(7696005)(8936002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WS9zK2NUL0dzd3ovYU4vbk13VTJXa3ZXWXlxUFRxYlZwQ3RSN2tsQ2dCanJ6?=
 =?utf-8?B?N1l2Z1FhWUQ3VitaNzRhTUR4ZDZ0ZWxKS2xSSmVLdTRFMEVnS2NmS0tURjVC?=
 =?utf-8?B?ZnJsRnFYQ2NDZXlpbnZPbU5JL01DM1VxU2VFdFF3K042MWdhQmZ6NjY3blNy?=
 =?utf-8?B?bTRkdDhwSHJlaGVMYVVGQjl5WWFKYXFZVkZocS93RU9qVkNGc0tEZ2NIckFL?=
 =?utf-8?B?MHZWblk5eVZhU042c2dDUTFyb2dXWTd5REVscnRpK2M1cXdHamFzdndmTDEw?=
 =?utf-8?B?c3J6R0RoV0dyL0FMcFU1aFd1TFFHdWZnT1RVZnFUcERXclVOQmQ1NmZJUitF?=
 =?utf-8?B?NnNtSzJiNE1Rdllna2VSUHNmSm93T052TkFXOXQwVmEwODZ3dUQ3SXVNRVd0?=
 =?utf-8?B?Lzc2cDBqSGViajFpbW5waWt5UVZFdXpJdFVwYU1sRTNhQ2Y1a0dralFLdklZ?=
 =?utf-8?B?cHpCaTVWcXVMWmcwZldNZmE1aXlCKy9TZkx2MG1Rb0NsN29naXVIOGN3RlZM?=
 =?utf-8?B?bG9mY3ZkNkhXVXFINVlvakdESWFDVVlRbzFUNjJjemQrNzVwOHhCUG05Z0hl?=
 =?utf-8?B?ZUxnRkN6NkdlNzZsZjE0Y3NjNFNMRDBOMXpteVRhMlVndEJpUmZ4SGFNeUNk?=
 =?utf-8?B?RjlVa0JkMkdzdDcwUFpaRS93ajBXaFRMM1pIQkQwemo0L1phTVVMQno3QTJS?=
 =?utf-8?B?bjRDUlRyMWNmSGk3NThEbDJUNFNLYXp3ZG4wdVU3SHRMWW9IK3VjTlphaHNa?=
 =?utf-8?B?eURrTld6N2VLT2RJTFBFZHdiY3VaT25Ubk1oeGlCUnlXcWRmbzdKZlBoS1Mx?=
 =?utf-8?B?ejhDTUFSWVVWTjdqNnd4MitzZldhS0RqYUhHVmd2alo0VjZVQXNBZWNPd0sz?=
 =?utf-8?B?ZXM3ZCt5ZHp0V2JFS3ZRQWNLc255VXFXVVNUMnVPalo1alRtTHlrNGh1ZFhu?=
 =?utf-8?B?SzJpRDVNemhaNjBrdlBpaWNuNjQ4MlRGQ09nUFR4WDZPSGdHZndlSjk2Mnhu?=
 =?utf-8?B?YzlUTzdGdW1td0RuNEY4THg1dlFucWRaNG92ZEgzYTRqaG9UT2RNZ1RiWVFr?=
 =?utf-8?B?cm9ia3I0Z2I0Ymc4Q1laVEVITmFtajlLeHNPTkl0NzFnakRhVTdWdWhXMEc2?=
 =?utf-8?B?UFRXTGhLWEFiME0yWW5qSHZWclR2ejd2dmpiRVRiL2ozcTZaRHRzdDJJWGpo?=
 =?utf-8?B?NmxnZU1NaThnWjZ6QmUzTHNBTHlrc3RJOGlwMUJxSXFXZXhlS09YcmN3amta?=
 =?utf-8?B?NTlKYTYvRlNxYWt3T0RkVDNCUDVtNXQvY1RxTSttWEQ2OHlzTUErbDhNSlBE?=
 =?utf-8?B?eFZ1VlVHbHU5UFhybU03c0g1QXplSE02b1ZwZkVMWFVWbldUd0lvblJnbUNt?=
 =?utf-8?B?ZVJQUDB1NGp6eTNZdjN3N1c2ZUQ1WXBWNjZ1NnpKZmFtSHJBVkFsUFBDYXVJ?=
 =?utf-8?B?VFV6YUtBV0NObDd4WGpMYkhwMEpZUDJZZ1BLZmNKWDZ0K1IyMnY5UUl1WWlv?=
 =?utf-8?B?ZUxsbTFUUTFVSEs3a2xMRGwxMFhGRUU2bWkydHhNbFU1OXhuM1B6aS9MdnVK?=
 =?utf-8?B?cTZtdXcycm95bGk0Y3FBYnlVS2FESElXUmtrbWl1QnJwSW14eGRVeU1Fdno4?=
 =?utf-8?B?T0w1c2l1RzQ4VW5XTm5VY05CM0IrYkRuTXgzbVlxb1VQSWZLNk4zcGN3ZC9B?=
 =?utf-8?B?VWRVRXVVTGVlZkl1akFsdDJnY1FuZEw4YlBxTy9xaUJsakFDMjlObWV4MU5v?=
 =?utf-8?Q?btS8u5llDq0pBocARo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2f6dca-d30b-4b8c-6db0-08d8dd21f42e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 02:21:57.2541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bif8upqruMVhXSRcJ/2hwe6UH9ysdyoPBsFRwKyKM7VzrbCvV4U5yAgYW+S8WgVObeYAwZrAe0RiVe/QjQP+iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjHlubQz5pyIMeaXpSAxODo1Nw0KPiBU
bzogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPjsgbWtsQHBlbmd1dHJv
bml4LmRlOyBEYXZpZCBTLg0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBL
aWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgT2xpdmVyDQo+IEhhcnRrb3BwIDxzb2NrZXRjYW5A
aGFydGtvcHAubmV0PjsgUm9iaW4gdmFuIGRlciBHcmFjaHQNCj4gPHJvYmluQHByb3RvbmljLm5s
Pg0KPiBDYzogQW5kcmUgTmF1am9rcyA8bmF1dHNjaDJAZ21haWwuY29tPjsgRXJpYyBEdW1hemV0
DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsga2VybmVsQHBlbmd1dHJvbml4LmRlOyBsaW51eC1j
YW5Admdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0IHY0IDEvMV0gY2Fu
OiBjYW5fc2tiX3NldF9vd25lcigpOiBmaXggcmVmIGNvdW50aW5nIGlmDQo+IHNvY2tldCB3YXMg
Y2xvc2VkIGJlZm9yZSBzZXR0aW5nIHNrYiBvd25lcnNoaXANCj4gDQo+IA0KPiA+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBl
bmd1dHJvbml4LmRlPg0KPiA+IFNlbnQ6IDIwMjHlubQy5pyIMjbml6UgMTc6MjUNCj4gPiBUbzog
bWtsQHBlbmd1dHJvbml4LmRlOyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
OyBKYWt1Yg0KPiA+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBPbGl2ZXIgSGFydGtvcHAg
PHNvY2tldGNhbkBoYXJ0a29wcC5uZXQ+Ow0KPiA+IFJvYmluIHZhbiBkZXIgR3JhY2h0IDxyb2Jp
bkBwcm90b25pYy5ubD4NCj4gPiBDYzogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJv
bml4LmRlPjsgQW5kcmUgTmF1am9rcw0KPiA+IDxuYXV0c2NoMkBnbWFpbC5jb20+OyBFcmljIER1
bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+Ow0KPiA+IGtlcm5lbEBwZW5ndXRyb25peC5kZTsg
bGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsNCj4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogW1BBVENIIG5ldCB2NCAx
LzFdIGNhbjogY2FuX3NrYl9zZXRfb3duZXIoKTogZml4IHJlZiBjb3VudGluZw0KPiA+IGlmIHNv
Y2tldCB3YXMgY2xvc2VkIGJlZm9yZSBzZXR0aW5nIHNrYiBvd25lcnNoaXANCj4gPg0KPiA+IFRo
ZXJlIGFyZSB0d28gcmVmIGNvdW50IHZhcmlhYmxlcyBjb250cm9sbGluZyB0aGUgZnJlZSgpaW5n
IG9mIGEgc29ja2V0Og0KPiA+IC0gc3RydWN0IHNvY2s6OnNrX3JlZmNudCAtIHdoaWNoIGlzIGNo
YW5nZWQgYnkgc29ja19ob2xkKCkvc29ja19wdXQoKQ0KPiA+IC0gc3RydWN0IHNvY2s6OnNrX3dt
ZW1fYWxsb2MgLSB3aGljaCBhY2NvdW50cyB0aGUgbWVtb3J5IGFsbG9jYXRlZCBieQ0KPiA+ICAg
dGhlIHNrYnMgaW4gdGhlIHNlbmQgcGF0aC4NCj4gPg0KPiA+IEluIGNhc2UgdGhlcmUgYXJlIHN0
aWxsIFRYIHNrYnMgb24gdGhlIGZseSBhbmQgdGhlIHNvY2tldCgpIGlzIGNsb3NlZCwNCj4gPiB0
aGUgc3RydWN0IHNvY2s6OnNrX3JlZmNudCByZWFjaGVzIDAuIEluIHRoZSBUWC1wYXRoIHRoZSBD
QU4gc3RhY2sNCj4gPiBjbG9uZXMgYW4gImVjaG8iIHNrYiwgY2FsbHMgc29ja19ob2xkKCkgb24g
dGhlIG9yaWdpbmFsIHNvY2tldCBhbmQNCj4gPiByZWZlcmVuY2VzIGl0LiBUaGlzIHByb2R1Y2Vz
IHRoZSBmb2xsb3dpbmcgYmFjayB0cmFjZToNCj4gPg0KPiA+IHwgV0FSTklORzogQ1BVOiAwIFBJ
RDogMjgwIGF0IGxpYi9yZWZjb3VudC5jOjI1DQo+ID4gfCByZWZjb3VudF93YXJuX3NhdHVyYXRl
KzB4MTE0LzB4MTM0DQo+ID4gfCByZWZjb3VudF90OiBhZGRpdGlvbiBvbiAwOyB1c2UtYWZ0ZXIt
ZnJlZS4NCj4gPiB8IE1vZHVsZXMgbGlua2VkIGluOiBjb2RhX3ZwdShFKSB2NGwyX2pwZWcoRSkg
dmlkZW9idWYyX3ZtYWxsb2MoRSkNCj4gPiBpbXhfdmRvYShFKQ0KPiA+IHwgQ1BVOiAwIFBJRDog
MjgwIENvbW06IHRlc3RfY2FuLnNoIFRhaW50ZWQ6IEcgICAgICAgICAgICBFDQo+ID4gNS4xMS4w
LTA0NTc3LWdmOGZmNjYwM2M2MTcgIzIwMw0KPiA+IHwgSGFyZHdhcmUgbmFtZTogRnJlZXNjYWxl
IGkuTVg2IFF1YWQvRHVhbExpdGUgKERldmljZSBUcmVlKQ0KPiA+IHwgQmFja3RyYWNlOg0KPiA+
IHwgWzw4MGJhZmVhND5dIChkdW1wX2JhY2t0cmFjZSkgZnJvbSBbPDgwYmIwMjgwPl0NCj4gPiB8
IChzaG93X3N0YWNrKzB4MjAvMHgyNCkNCj4gPiB8IHI3OjAwMDAwMDAwIHI2OjYwMGYwMTEzIHI1
OjAwMDAwMDAwIHI0OjgxNDQxMjIwIFs8ODBiYjAyNjA+XQ0KPiA+IHwgKHNob3dfc3RhY2spIGZy
b20gWzw4MGJiNTkzYz5dIChkdW1wX3N0YWNrKzB4YTAvMHhjOCkgWzw4MGJiNTg5Yz5dDQo+ID4g
fCAoZHVtcF9zdGFjaykgZnJvbSBbPDgwMTJiMjY4Pl0gKF9fd2FybisweGQ0LzB4MTE0KSByOTow
MDAwMDAxOQ0KPiA+IHwgcjg6ODBmNGE4YzIgcjc6ODNlNDE1MGMgcjY6MDAwMDAwMDAgcjU6MDAw
MDAwMDkgcjQ6ODA1MjhmOTANCj4gPiB8IFs8ODAxMmIxOTQ+XSAoX193YXJuKSBmcm9tIFs8ODBi
YjA5YzQ+XQ0KPiA+IHwgKHdhcm5fc2xvd3BhdGhfZm10KzB4ODgvMHhjOCkNCj4gPiB8IHI5Ojgz
ZjI2NDAwIHI4OjgwZjRhOGQxIHI3OjAwMDAwMDA5IHI2OjgwNTI4ZjkwIHI1OjAwMDAwMDE5DQo+
ID4gfCByNDo4MGY0YThjMiBbPDgwYmIwOTQwPl0gKHdhcm5fc2xvd3BhdGhfZm10KSBmcm9tIFs8
ODA1MjhmOTA+XQ0KPiA+IHwgKHJlZmNvdW50X3dhcm5fc2F0dXJhdGUrMHgxMTQvMHgxMzQpIHI4
OjAwMDAwMDAwIHI3OjAwMDAwMDAwDQo+ID4gfCByNjo4MmI0NDAwMCByNTo4MzRlNTYwMCByNDo4
M2Y0ZDU0MCBbPDgwNTI4ZTdjPl0NCj4gPiB8IChyZWZjb3VudF93YXJuX3NhdHVyYXRlKSBmcm9t
IFs8ODA3OWE0Yzg+XQ0KPiA+IHwgKF9fcmVmY291bnRfYWRkLmNvbnN0cHJvcC4wKzB4NGMvMHg1
MCkNCj4gPiB8IFs8ODA3OWE0N2M+XSAoX19yZWZjb3VudF9hZGQuY29uc3Rwcm9wLjApIGZyb20g
Wzw4MDc5YTU3Yz5dDQo+ID4gfCAoY2FuX3B1dF9lY2hvX3NrYisweGIwLzB4MTNjKSBbPDgwNzlh
NGNjPl0gKGNhbl9wdXRfZWNob19za2IpIGZyb20NCj4gPiB8IFs8ODA3OWJhOTg+XSAoZmxleGNh
bl9zdGFydF94bWl0KzB4MWM0LzB4MjMwKSByOTowMDAwMDAxMA0KPiA+IHwgcjg6ODNmNDg2MTAN
Cj4gPiB8IHI3OjBmZGMwMDAwIHI2OjBjMDgwMDAwIHI1OjgyYjQ0MDAwIHI0OjgzNGU1NjAwIFs8
ODA3OWI4ZDQ+XQ0KPiA+IHwgKGZsZXhjYW5fc3RhcnRfeG1pdCkgZnJvbSBbPDgwOTY5MDc4Pl0g
KG5ldGRldl9zdGFydF94bWl0KzB4NDQvMHg3MCkNCj4gPiB8IHI5OjgxNGMwYmEwIHI4OjgwYzg3
OTBjIHI3OjAwMDAwMDAwIHI2OjgzNGU1NjAwIHI1OjgyYjQ0MDAwDQo+ID4gfCByNDo4MmFiMWYw
MCBbPDgwOTY5MDM0Pl0gKG5ldGRldl9zdGFydF94bWl0KSBmcm9tIFs8ODA5NzI1YTQ+XQ0KPiA+
IHwgKGRldl9oYXJkX3N0YXJ0X3htaXQrMHgxOWMvMHgzMTgpIHI5OjgxNGMwYmEwIHI4OjAwMDAw
MDAwDQo+ID4gfCByNzo4MmFiMWYwMA0KPiA+IHwgcjY6ODJiNDQwMDAgcjU6MDAwMDAwMDAgcjQ6
ODM0ZTU2MDAgWzw4MDk3MjQwOD5dDQo+ID4gfCAoZGV2X2hhcmRfc3RhcnRfeG1pdCkgZnJvbSBb
PDgwOWM2NTg0Pl0gKHNjaF9kaXJlY3RfeG1pdCsweGNjLzB4MjY0KQ0KPiA+IHwgcjEwOjgzNGU1
NjAwDQo+ID4gfCByOTowMDAwMDAwMCByODowMDAwMDAwMCByNzo4MmI0NDAwMCByNjo4MmFiMWYw
MCByNTo4MzRlNTYwMA0KPiA+IHwgcjQ6ODNmMjc0MDAgWzw4MDljNjRiOD5dIChzY2hfZGlyZWN0
X3htaXQpIGZyb20gWzw4MDljNmMwYz5dDQo+ID4gfCAoX19xZGlzY19ydW4rMHg0ZjAvMHg1MzQp
DQo+ID4NCj4gPiBUbyBmaXggdGhpcyBwcm9ibGVtLCBvbmx5IHNldCBza2Igb3duZXJzaGlwIHRv
IHNvY2tldHMgd2hpY2ggaGF2ZQ0KPiA+IHN0aWxsIGEgcmVmIGNvdW50ID4gMC4NCj4gPg0KPiA+
IENjOiBPbGl2ZXIgSGFydGtvcHAgPHNvY2tldGNhbkBoYXJ0a29wcC5uZXQ+DQo+ID4gQ2M6IEFu
ZHJlIE5hdWpva3MgPG5hdXRzY2gyQGdtYWlsLmNvbT4NCj4gPiBTdWdnZXN0ZWQtYnk6IEVyaWMg
RHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiBGaXhlczogMGFlODliZWIyODNhICgi
Y2FuOiBhZGQgZGVzdHJ1Y3RvciBmb3Igc2VsZiBnZW5lcmF0ZWQgc2ticyIpDQo+ID4gU2lnbmVk
LW9mZi1ieTogT2xla3NpaiBSZW1wZWwgPG8ucmVtcGVsQHBlbmd1dHJvbml4LmRlPg0KPiANCj4g
SSB3aWxsIGdpdmUgb3V0IGEgdGVzdCByZXN1bHQgdG9tb3Jyb3cgd2hlbiB0aGUgYm9hcmQgaXMg
YXZhaWxhYmxlLiDwn5iKDQoNCkkgYWxzbyBtZXQgdGhpcyBpc3N1ZSBpbiB0aGUgcGFzdCBhbmQg
dGhpcyBwYXRjaCBpbmRlZWQgZml4IGl0LiBUaGFua3MgT2xla3NpaiBSZW1wZS4NCg0KVGVzdGVk
LWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KDQpCZXN0IFJlZ2Fy
ZHMsDQpKb2FraW0gWmhhbmcNCj4gQmVzdCBSZWdhcmRzLA0KPiBKb2FraW0gWmhhbmcNCj4gPiAt
LS0NCj4gPiAgaW5jbHVkZS9saW51eC9jYW4vc2tiLmggfCA4ICsrKysrKy0tDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9saW51eC9jYW4vc2tiLmggYi9pbmNsdWRlL2xpbnV4L2Nhbi9za2Iu
aCBpbmRleA0KPiA+IDY4NWYzNGNmYmEyMC4uZDgyMDE4Y2MwZDBiIDEwMDY0NA0KPiA+IC0tLSBh
L2luY2x1ZGUvbGludXgvY2FuL3NrYi5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9jYW4vc2ti
LmgNCj4gPiBAQCAtNjUsOCArNjUsMTIgQEAgc3RhdGljIGlubGluZSB2b2lkIGNhbl9za2JfcmVz
ZXJ2ZShzdHJ1Y3Qgc2tfYnVmZg0KPiA+ICpza2IpDQo+ID4NCj4gPiAgc3RhdGljIGlubGluZSB2
b2lkIGNhbl9za2Jfc2V0X293bmVyKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBzb2NrICpz
aykNCj4gew0KPiA+IC0JaWYgKHNrKSB7DQo+ID4gLQkJc29ja19ob2xkKHNrKTsNCj4gPiArCS8q
DQo+ID4gKwkgKiBJZiB0aGUgc29ja2V0IGhhcyBhbHJlYWR5IGJlZW4gY2xvc2VkIGJ5IHVzZXIg
c3BhY2UsIHRoZSByZWZjb3VudCBtYXkNCj4gPiArCSAqIGFscmVhZHkgYmUgMCAoYW5kIHRoZSBz
b2NrZXQgd2lsbCBiZSBmcmVlZCBhZnRlciB0aGUgbGFzdCBUWCBza2IgaGFzDQo+ID4gKwkgKiBi
ZWVuIGZyZWVkKS4gU28gb25seSBpbmNyZWFzZSBzb2NrZXQgcmVmY291bnQgaWYgdGhlIHJlZmNv
dW50IGlzID4gMC4NCj4gPiArCSAqLw0KPiA+ICsJaWYgKHNrICYmIHJlZmNvdW50X2luY19ub3Rf
emVybygmc2stPnNrX3JlZmNudCkpIHsNCj4gPiAgCQlza2ItPmRlc3RydWN0b3IgPSBzb2NrX2Vm
cmVlOw0KPiA+ICAJCXNrYi0+c2sgPSBzazsNCj4gPiAgCX0NCj4gPiAtLQ0KPiA+IDIuMjkuMg0K
DQo=
