Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19C364FFE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 03:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhDTBt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 21:49:56 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:50756
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229528AbhDTBtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 21:49:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLM8dIoN1sM6SKVV0G1WHNNiiYi1kyi1IFfYyF4MbfsLelmnh+ae7gz+BNVl7ZYwRtc30GiaRWAXFROm5mEyOFMG6B53wVWAIA1X/XXlChLPefRJ/wMMAjY0atLqPDEd87Ic+iYLia/3/h/EoR6aQtIcAvqw4wA0E//JBoYhbE9x4mnWbceaoVv/02fxvXXuYTFJYlZTBVD+lgwcqc+sS5Pp/W7dp47p6LaAql472TXk7AsASHhriUzEYgeAWejfw6xLIr6IItD85a7jxAHK2rVEUVjsS0WfzUxhk0apjfvoeY0gwhtPYl7D3BYVucwClRKrzznSvG2p9Qx19fnCeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BObgQ7AVjW4bPAgs4NtsXHhqic6hTzpsoIzA2UKkWM8=;
 b=GWt/tV4A3E8fyLcPjBNRuuwWDMJ49I7LOqG6bXTKb8VhmKai2Z2AThA6quxXAnD45TruT2sQMEj8Eqf8qmjmDmmRwttgbHZc2ECIJrXS/42q3PGW5PSn2J6lybRsANq415w6JwwSZtbHW7hQhEtqZ4Q6eQKX3TV24qlxo626EZ5BOkIOy1wwJ6CUP+QZhjaXt/i8l+Ia5PGmCxRBYZJSVM/jeO4CqFO3CWDzY+oJKqRYm0ZLNKnfVHmCDbFYQ8RwtCN1CekfvluIurM89sIEBIysurnAKRagFlNKCVFmuTfxWTLZ1dPt/633NpSenv4KFwaZ1Nku0Wc+u5Q7gAMw6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BObgQ7AVjW4bPAgs4NtsXHhqic6hTzpsoIzA2UKkWM8=;
 b=ifJS5hYX0Sb6sXnPM7ODCKM4IPTz4O6kAXF1Tnbq98Veu0uXzWNtAW8ejFUzDDlP/+I0881KLyJZ3vqUDyShQSnErA1pqTYPkiAV3PDISlWujofXWV7LncS066BeJelJAuYAuFN9L9G7RTOwhDYPmjVbShXhkudBRIi5xap2W20=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3963.eurprd04.prod.outlook.com (2603:10a6:5:1c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 01:49:20 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%7]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 01:49:20 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqq78qqAgACuHyA=
Date:   Tue, 20 Apr 2021 01:49:19 +0000
Message-ID: <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
In-Reply-To: <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e013ea24-94bd-4d28-7401-08d9039e83dc
x-ms-traffictypediagnostic: DB7PR04MB3963:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB3963DF9BD72B13A4E95A8454E6489@DB7PR04MB3963.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R7/w6Wtrq+3k6hTUyHVzThOW739KdmFANRfjaizLfYedfuFR2cuVAb6+5RxZ8SXRkVqh+VvDYZPMsgPifxNNTFh9P4YpvkJexz0QG1HGnWvaWMORXxikRIebkd1M7haOI7KXC/34L7BVUYQs69JTOYHBFU+KLFuRyb/p+JVYMujIYf6yddSrulWnFz7ddPQq1Xu10TK+TZAOcx+obx1HSyx/SxacJyXIwbX2CqC2IYcAy35LPkd4IBva8XamIVv4SW6hmTQ8U/vhAOaTiAFNWYQEmvVdKA/RCwPEysW1b3NTvjcfRDaBskDuW7IFMPFnwu6BqQ4dtK5mfXUMcLhP9q2TVwPKF7fAvwUelbQr65jMBzWaviFZQ5vlcZQgmaeWeqKE0GQBSJ7/jMIrOVM6KJuB9A6T4fzO5u8hdqfb280HroS3+ioth82lz9nIrIeI5kX2HpvcRwV9/HLDTwVVszT5hXNfNTRmthEiTm+EosC4snmwNRfHZ5+OJeMPU31Ijc/HW49ivee23SxK/Sgq1PyZXYUUNaeOwk09fqKIhdqbrQrVefXs1haZmEWUbsiOVesrBrdoOAjzo4wUwpJ6KE3dZ8X718T1UTf3Cxo3g2Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(346002)(396003)(136003)(366004)(55016002)(52536014)(6506007)(66556008)(5660300002)(83380400001)(66946007)(8676002)(186003)(53546011)(64756008)(26005)(66476007)(4326008)(76116006)(478600001)(66446008)(9686003)(122000001)(316002)(38100700002)(8936002)(7416002)(71200400001)(110136005)(86362001)(2906002)(7696005)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?REdyVHord01VWlVKbDcreHlOQ2JsME5wMSt1aHUxczRldHdNWTNxN09aTTFU?=
 =?utf-8?B?aWVNS1ltdnlpd2hwS1J4RU45L21rQkMwSC82VzViQjEydWw5a3M1Nzh0YTB2?=
 =?utf-8?B?WktUbHoxU2laUVFuYktBeTdxQzZ0cCtwQ3I1STQ4Mlo2YjMzaHBKcHBXbyti?=
 =?utf-8?B?T29IVEliMmdQNkhYSkVTYmJSU25kcGJQNSsyYTFYbDE0cFhHaExpanZKVjl5?=
 =?utf-8?B?NWgxaDNBUVdDZFJGVGwrZG5HOUxQYWlxZFcyaTZKVks0TVBxLytaeTVZQ1NW?=
 =?utf-8?B?MVlvVFFkOHRtazdOdDdpU1ZRVjZDeWtKd2wvSlJySXRKcTFQT1k3eVY3T1Ja?=
 =?utf-8?B?V2hUWVFUZUxNMyt5aE9TdW9YTDBlVG5NenpOZ1R6Rmp1UzUrK3liQW1MNUFL?=
 =?utf-8?B?aHZwSXdMT215dXpUSWhzLzJTNHlUaUpSSVI1T1R2amxrV0hsNENQOWZOOUZN?=
 =?utf-8?B?bDhVR1dXZi91YnZ6TFh2MER0ZWhrYnZMc3pGQVNyZWFjM3QxNGxwczAxZDEy?=
 =?utf-8?B?UGs0Q1JTWnBLQzU1OE9qaWVlMDN3WXpCQmVZbDZaUkVtVko2QTZqSUo0WUdm?=
 =?utf-8?B?cG9DSDJnNGtYUWhudDI1Y3g5UW9MQUhoaVExaE9KNGlxdU91Rm1icEcyZzFk?=
 =?utf-8?B?OFNjaGUrUlpkN3FWd2JRT0h3NEZtRkEzMTNIMk1FbHVNYUhieE9DaUJUNmlN?=
 =?utf-8?B?VWt3bmZnWlVJUXFIUEsrS0s4aXpWS0tIWVROQ1B1T1JpV3l6MTZGSldoakpR?=
 =?utf-8?B?dUFBZnk1TXdITGVjdEJDemk1WGtZTU9DQ2VTc0NoV3daMzl5UWlWMG9qQUFm?=
 =?utf-8?B?ZXppNHE1ZFVNSDRGNER6UWJhWEsrNThXNU1FKzJ2N0RwM0RISktCVkZkNTNF?=
 =?utf-8?B?SmU2bWxLODJ1Y2M0V28yblAyZy9zbFY3eGVrN2p4WW1QUjVnais2d2hZd2Rm?=
 =?utf-8?B?ODN2Nzc2YWtNRGNFb0d4UE1PSHBUVW1UK1pjR0VheE0rVDg2b0dFTEhxWDBG?=
 =?utf-8?B?Y0pjTWtoWnRsVjdiejBEMTBXSnZmeStKeXZPUHVxMzlaRDF3ekJybzJmNlZB?=
 =?utf-8?B?MnJ4UVJmODl3UWUzNlhocnBlZURsNU5yMUxvUUJxYlZIRFVXUnVmczR2TmZO?=
 =?utf-8?B?ZWhXbnVudkxjNElQVFlYR1VtZUpDVCtVZTlwUnZ2UmtsMldzRDlBNjFMVk9z?=
 =?utf-8?B?TVpHRTl5ZU1iNEVrR0xMbnJ3UVRFWjBtUkkxSllyTldKN0tnd2VrYlRxT2Zm?=
 =?utf-8?B?M0xiQ1hxbG14ZytyVmtadG1yWkVSZUZlOUUrQndMM0dOSUY4VURoSEpjdysw?=
 =?utf-8?B?Y3FVeENNWmpNZEtxdC90N2xuWWY2VS8vT29OcWxmRnNNaDVZZjNaZVBCMGFu?=
 =?utf-8?B?K3RSWTdOdGNhcHp3bE90Z2xsZG11YnJyK2puWjV0MTcvWUFER21sREFLc25a?=
 =?utf-8?B?ZWNOMVpROEE4UWU0TXJibko0SWRiWW9aOURRdDhPcnc4VkRMYVRPQWdUR2lq?=
 =?utf-8?B?aTJnVmlqTERRWUxKNFR4clh5VlpWVnBNdmFpakVlaXBneHE4U0hFUWxJbGVk?=
 =?utf-8?B?c1JQNytSdndoV2N2Snc0a0pWczFYS3RLYU9ROXl0L1JwTDBhTWhrNWJya1pK?=
 =?utf-8?B?WmNUS3MzeCtoWHJmS2RRdy9qYUpUKzE3anA5NEtRVXZQcy9ETEQyNDFuN3d5?=
 =?utf-8?B?NmFMUnNCVFFPbytnOUdXOElUZ1UzaitUcjhScFJpOGljd2hxSnVERUo1dFRw?=
 =?utf-8?Q?4Waud4egcCUhoTgo/VVr60cl0lSe1B11pATqbS4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e013ea24-94bd-4d28-7401-08d9039e83dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 01:49:19.9932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kaLHQuUO6bEp3MLLon0F0XK1WIJH+5VWejncZMp7Oz+R3HVj2uVgqwJtjiUSUmlkgezkETSsSE6AjqaHQJ5faQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKb24sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9uIEh1
bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+DQo+IFNlbnQ6IDIwMjHlubQ05pyIMTnml6UgMjM6
MTINCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBwZXBwZS5j
YXZhbGxhcm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOyBqb2FicmV1
QHN5bm9wc3lzLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBt
Y29xdWVsaW4uc3RtMzJAZ21haWwuY29tOw0KPiBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBn
bWFpbC5jb20NCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyB0cmVkaW5n
QG52aWRpYS5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtS
RkMgbmV0LW5leHRdIG5ldDogc3RtbWFjOiBzaG91bGQgbm90IG1vZGlmeSBSWCBkZXNjcmlwdG9y
IHdoZW4NCj4gU1RNTUFDIHJlc3VtZQ0KPiANCj4gSGkgSm9ha2ltLA0KPiANCj4gT24gMTkvMDQv
MjAyMSAxMjo1OSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IFdoZW4gc3lzdGVtIHJlc3VtZSBi
YWNrLCBTVE1NQUMgd2lsbCBjbGVhciBSWCBkZXNjcmlwdG9yczoNCj4gPiBzdG1tYWNfcmVzdW1l
KCkNCj4gPiAJLT5zdG1tYWNfY2xlYXJfZGVzY3JpcHRvcnMoKQ0KPiA+IAkJLT5zdG1tYWNfY2xl
YXJfcnhfZGVzY3JpcHRvcnMoKQ0KPiA+IAkJCS0+c3RtbWFjX2luaXRfcnhfZGVzYygpDQo+ID4g
CQkJCS0+ZHdtYWM0X3NldF9yeF9vd25lcigpDQo+ID4gCQkJCS8vcC0+ZGVzMyB8PSBjcHVfdG9f
bGUzMihSREVTM19PV04gfA0KPiBSREVTM19CVUZGRVIxX1ZBTElEX0FERFIpOyBJdA0KPiA+IG9u
bHkgYXNzZXRzIE9XTiBhbmQgQlVGMVYgYml0cyBpbiBkZXNjMyBmaWVsZCwgZG9lc24ndCBjbGVh
ciBkZXNjMC8xLzIgZmllbGRzLg0KPiA+DQo+ID4gTGV0J3MgdGFrZSBhIGNhc2UgaW50byBhY2Nv
dW50LCB3aGVuIHN5c3RlbSBzdXNwZW5kLCBpdCBpcyBwb3NzaWJsZQ0KPiA+IHRoYXQgdGhlcmUg
YXJlIHBhY2tldHMgaGF2ZSBub3QgcmVjZWl2ZWQgeWV0LCBzbyB0aGUgUlggZGVzY3JpcHRvcnMN
Cj4gPiBhcmUgd3JvdGUgYmFjayBieSBETUEsIGUuZy4NCj4gPiAwMDggWzB4MDAwMDAwMDBjNDMx
MDA4MF06IDB4MCAweDQwIDB4MCAweDM0MDEwMDQwDQo+ID4NCj4gPiBXaGVuIHN5c3RlbSByZXN1
bWUgYmFjaywgYWZ0ZXIgYWJvdmUgcHJvY2VzcywgaXQgYmVjYW1lIGEgYnJva2VuDQo+ID4gZGVz
Y3JpcHRvcjoNCj4gPiAwMDggWzB4MDAwMDAwMDBjNDMxMDA4MF06IDB4MCAweDQwIDB4MCAweGI1
MDEwMDQwDQo+ID4NCj4gPiBUaGUgaXNzdWUgaXMgdGhhdCBpdCBvbmx5IGNoYW5nZXMgdGhlIG93
bmVyIG9mIHRoaXMgZGVzY3JpcHRvciwgYnV0IGRvDQo+ID4gbm90aGluZyBhYm91dCBkZXNjMC8x
LzIgZmllbGRzLiBUaGUgZGVzY3JpcHRvciBvZiBTVE1NQUMgYSBiaXQNCj4gPiBzcGVjaWFsLCBh
cHBsaWNhdG9uIHByZXBhcmVzIFJYIGRlc2NyaXB0b3JzIGZvciBETUEsIGFmdGVyIERNQSByZWNl
dmllDQo+ID4gdGhlIHBhY2tldHMsIGl0IHdpbGwgd3JpdGUgYmFjayB0aGUgZGVzY3JpcHRvcnMs
IHNvIHRoZSBzYW1lIGZpZWxkIG9mDQo+ID4gYSBkZXNjcmlwdG9yIGhhdmUgZGlmZmVyZW50IG1l
YW5pbmdzIHRvIGFwcGxpY2F0aW9uIGFuZCBETUEuIEl0IHNob3VsZA0KPiA+IGJlIGEgc29mdHdh
cmUgYnVnIHRoZXJlLCBhbmQgbWF5IG5vdCBlYXN5IHRvIHJlcHJvZHVjZSwgYnV0IHRoZXJlIGlz
IGENCj4gPiBjZXJ0YWluIHByb2JhYmlsaXR5IHRoYXQgaXQgd2lsbCBvY2N1ci4NCj4gPg0KPiA+
IENvbW1pdCA5YzYzZmFhYTkzMWUgKCJuZXQ6IHN0bW1hYzogcmUtaW5pdCByeCBidWZmZXJzIHdo
ZW4gbWFjIHJlc3VtZQ0KPiA+IGJhY2siKSB0cmllZCB0byByZS1pbml0IGRlc2MwL2Rlc2MxIChi
dWZmZXIgYWRkcmVzcyBmaWVsZHMpIHRvIGZpeA0KPiA+IHRoaXMgaXNzdWUsIGJ1dCBpdCBpcyBu
b3QgYSBwcm9wZXIgc29sdXRpb24sIGFuZCBtYWRlIHJlZ3Jlc3Npb24gb24gSmV0c29uIFRYMg0K
PiBib2FyZHMuDQo+ID4NCj4gPiBJdCBpcyB1bnJlYXNvbmFibGUgdG8gbW9kaWZ5IFJYIGRlc2Ny
aXB0b3JzIG91dHNpZGUgb2YNCj4gPiBzdG1tYWNfcnhfcmVmaWxsKCkgZnVuY3Rpb24sIHdoZXJl
IGl0IHdpbGwgY2xlYXIgYWxsIGRlc2MwL2Rlc2MxL2Rlc2MyL2Rlc2MzDQo+IGZpZWxkcyB0b2dl
dGhlci4NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggcmVtb3ZlcyBSWCBkZXNjcmlwdG9ycyBtb2RpZmlj
YXRpb24gd2hlbiBTVE1NQUMgcmVzdW1lLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDMgKystDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFp
bi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFp
bi5jDQo+ID4gaW5kZXggOWYzOTY2NDhkNzZmLi5iNzg0MzA0YTIyZTggMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMN
Cj4gPiBAQCAtNzE4Niw2ICs3MTg2LDggQEAgc3RhdGljIHZvaWQgc3RtbWFjX3Jlc2V0X3F1ZXVl
c19wYXJhbShzdHJ1Y3QNCj4gc3RtbWFjX3ByaXYgKnByaXYpDQo+ID4gIAkJdHhfcS0+bXNzID0g
MDsNCj4gPg0KPiA+ICAJCW5ldGRldl90eF9yZXNldF9xdWV1ZShuZXRkZXZfZ2V0X3R4X3F1ZXVl
KHByaXYtPmRldiwgcXVldWUpKTsNCj4gPiArDQo+ID4gKwkJc3RtbWFjX2NsZWFyX3R4X2Rlc2Ny
aXB0b3JzKHByaXYsIHF1ZXVlKTsNCj4gPiAgCX0NCj4gPiAgfQ0KPiA+DQo+ID4gQEAgLTcyNTAs
NyArNzI1Miw2IEBAIGludCBzdG1tYWNfcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikNCj4gPiAg
CXN0bW1hY19yZXNldF9xdWV1ZXNfcGFyYW0ocHJpdik7DQo+ID4NCj4gPiAgCXN0bW1hY19mcmVl
X3R4X3NrYnVmcyhwcml2KTsNCj4gPiAtCXN0bW1hY19jbGVhcl9kZXNjcmlwdG9ycyhwcml2KTsN
Cj4gPg0KPiA+ICAJc3RtbWFjX2h3X3NldHVwKG5kZXYsIGZhbHNlKTsNCj4gPiAgCXN0bW1hY19p
bml0X2NvYWxlc2NlKHByaXYpOw0KPiA+DQo+IA0KPiANCj4gSSBoYXZlIHRlc3RlZCB0aGlzIHBh
dGNoLCBidXQgdW5mb3J0dW5hdGVseSB0aGUgYm9hcmQgc3RpbGwgZmFpbHMgdG8gcmVzdW1lDQo+
IGNvcnJlY3RseS4gU28gaXQgYXBwZWFycyB0byBzdWZmZXIgd2l0aCB0aGUgc2FtZSBpc3N1ZSB3
ZSBzYXcgb24gdGhlIHByZXZpb3VzDQo+IGltcGxlbWVudGF0aW9uLg0KDQpDb3VsZCBJIGRvdWJs
ZSBjaGVjayB3aXRoIHlvdT8gSGF2ZSB5b3UgcmV2ZXJ0ZWQgQ29tbWl0IDljNjNmYWFhOTMxZSAo
Im5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBtYWMgcmVzdW1lIGJhY2siKSBh
bmQgdGhlbiBhcHBseSBhYm92ZSBwYXRjaCB0byBkbyB0aGUgdGVzdD8NCg0KSWYgeWVzLCB5b3Ug
c3RpbGwgc2F3IHRoZSBzYW1lIGlzc3VlIHdpdGggQ29tbWl0IDljNjNmYWFhOTMxZT8gTGV0J3Mg
cmVjYWxsIHRoZSBwcm9ibGVtLCBzeXN0ZW0gc3VzcGVuZGVkLCBidXQgc3lzdGVtIGhhbmcgd2hl
biBTVE1NQUMgcmVzdW1lIGJhY2ssIHJpZ2h0Pw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhh
bmcNCj4gSm9uDQo+IA0KPiAtLQ0KPiBudnB1YmxpYw0K
