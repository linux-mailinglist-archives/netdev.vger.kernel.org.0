Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E747D36D3A2
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhD1IGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:06:54 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:19456
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229643AbhD1IGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 04:06:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFGsV7yhk051Wn1S4octSZ4U/5pLto2q106kWWG8pxcJH/LkxyUa2rC2E3KU10PV3R67jhlKCEBk10dvjtqh0oQX+S0GisazdD6qBEI+AAGIBJ/9c8ZPwal0e9ceRWPNovkHR8GhroZJA1pepRdQH2KKOUG88Kl3rIQWuDVupxCULhtWODtrfPo6+Dj8JM9+T8rTbEgfLdoJmJ0qBBP2pjfPzeXKyiuyzvhMldvxjsLvlXvfFJBbR6mseOeVqDt0Lb3fxfdmAeZBgJVar/1WjsRSJms4Q3aP0exTgR/qz72s/laTfKAg2JEfEhwExmArT+CbZo3gkqWoSy12IoY1Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqRKk6JVnu5QMV05SoaM6F8GwwmubxFhppRWDAjYaMQ=;
 b=FAYcSVHBunv70dvshpEK/CF889NsGVZTo15blaeDx2QEnejFcXdfF/9FKhcVwHjN73++hQm1Guo3Hrg/l3lTe+PGOlPX+SM0wntn8wS+SdZvjydjmdHUJG6Q8NtqASAPPMBrXwIA1Okw27DpUuPMUeGuHpmn3FH6+6PLCZAsbMXaXQMyuve34OQY6F43jzz8HzQuDdnbsZCfEoYGj4JXBrj+Lj5XjBmyJpPOObQKEqehpMCvqC9kPXJ4wC88nGw7ljZxDscvjwCyKhASdrxPpH3Zt88fJpxyhfuYg9EwxoRJJCAAhwSqSbdZbzR+CW3C+WBCQtCDZejLfXIB5+/QXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqRKk6JVnu5QMV05SoaM6F8GwwmubxFhppRWDAjYaMQ=;
 b=Fg0FonS+FHMyt/ObvO9qsnvC/JBnWS83GrOXrOOHsYEc2e6Uo/K/TrsBS3qFpINmQJYnPuc06mQChBZpnji6C7AymRAfDtsfX8ZXvdMgMGLr/mOqmJADcaRr5WcT7QXz1PaNqtltEzKWiCiYADknn1uAxHb4+IGMM5ZH52xtrdc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7205.eurprd04.prod.outlook.com (2603:10a6:10:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Wed, 28 Apr
 2021 08:06:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 08:06:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
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
Thread-Index: AQHXNRwagqYg3yRB0ku+UvQ/Kt5swqrBcaDggAAY44CABi40MIAA5ToAgAD/QaA=
Date:   Wed, 28 Apr 2021 08:06:05 +0000
Message-ID: <DB8PR04MB6795AD745C2B27B6AC68497EE6409@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419130106.6707-1-o.rempel@pengutronix.de>
 <DB8PR04MB67951B9C6AB1620E807205F2E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210423043729.tup7nntmmyv6vurm@pengutronix.de>
 <DB8PR04MB6795479FBF086751D16080E2E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <6416c580-0df9-7d36-c42d-65293c40aa25@gmail.com>
In-Reply-To: <6416c580-0df9-7d36-c42d-65293c40aa25@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12ec924d-4a8a-41b1-5622-08d90a1c78fc
x-ms-traffictypediagnostic: DBAPR04MB7205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB72055B68F67EEEFDAF7247CEE6409@DBAPR04MB7205.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5bO+1S744KN72qXvrSbo/BpnkBwY+22SP8gmNVxE/FnBt2+tus4l7xssHgLZX/PF8g0EkuGmT6e+Kt4kr7uMzVZJI9dqxdmhf6zq8Ced9RuY2/787l12D0synTxekoI7jcaP8MAptUl220C+OAjMZUzqOR0tu73Jh1CRcUmILymcfk/1l5CjjaA/HQ0F50UbhTNeDcU8V90GcPKPk6aI45JlTZRh+f2XS0M25S3UFeM5QJZ1X5NNqj/jP2L0zTZomDSIrDZRhuf1eNgLiITbvQpQ0o5QmFOFLhJulrgelUwMTLZP8gCAvHG8ZwiL7iF4OMscyAdieghZ3JlN2oYVaYQoJuY3AvShrVwg3dZjkxQjKNgIENmzmTd5enb35DPmBcNVa9IMktT5JC7DINwEwEU353lDAX2mCy4KRIeOOQPadWlVahaRAvlDTc7aOLOEW58PNg/iPV8cHsBV5tFtRn2UxhnSMO9jzrQQ3mW91IKHVmjwyGpERphiv9XqriOIsNGOab/AMIr6zPh/IZO5DP4dMxQt6mdlbrkVppAUgqS9a1LxdkRl9Q4tKr4lBUl6Y8wuOAWXQhsikxqCrkkMSg/EY+ECi47uAELJ2uTXv1zEVKJ7kYxeSSbXr1r4we/XRbUT25TM6QX3xuX8KQ4kbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(38100700002)(122000001)(7416002)(66476007)(6506007)(64756008)(478600001)(76116006)(8676002)(71200400001)(86362001)(83380400001)(110136005)(2906002)(53546011)(54906003)(8936002)(33656002)(5660300002)(66946007)(316002)(66446008)(55016002)(186003)(9686003)(52536014)(4326008)(26005)(7696005)(66556008)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?VW05bDBjZlBpUy9MTEdvMHIrbGQrc1JSR0pGUHBYK0ZlQUk3QkpEaDR4NjBU?=
 =?gb2312?B?K3FzajRsVGtRck4rbWR5eXUxN1Nua2Vuc3dxY2dnVDJ0Y0VEcFdVSUw1bFBJ?=
 =?gb2312?B?TndqaWVyd3RUcTNLckJhOWJYeFk0MVdLc0JRWUxaTDhhVUt0eG1Oc1JyN1Fm?=
 =?gb2312?B?YVgzTktuaGtvY0FSZTZiWStwZERNb3dndVpzcXRySmNPNzBRZXQwc0hvUnQ2?=
 =?gb2312?B?Z2tvcUxrVGk4WVRsc1FzNGFFR0N1QWxYam1GamtkT3hyT0hMeGg5SE5JdUox?=
 =?gb2312?B?OTIzQUlMdHVOWFpmaXBYWWpkQ1VXRnhOS295eHR0Z2pVQTVkK1hod2NFRDI3?=
 =?gb2312?B?ckF3SXVBbEJmNEMyUUsyZ2R3V0hyc0ZiOG9FUnBwZlFZcXhXaS9iZlEyQ2x2?=
 =?gb2312?B?R09GRXBxblFzLzhBVzdoT1praXFoSTFqbVFQSkY5MmFVWnpiMTl2SnR6bWUz?=
 =?gb2312?B?M3pNQmpKZjdOM3JFWU5QMEZrenV5WTVLalA1QnhSdWNxZlhhVThHNHFsNVdF?=
 =?gb2312?B?Y2dENDhLRTJFRDZRN0pJaDVyRDZMNkFwc2J4aDdnUEdiMFloWEpCb3FyV1Ew?=
 =?gb2312?B?L3FiRHVTWjB6YlA3OTN3WUQ5RW55bHFDZUY5bXRWQVJiV0diVUk2bzRlZ3Np?=
 =?gb2312?B?UGo5MzlLQkp3b3hOSnY5d05VOE91dzBQWFlIOHRVT1p3eXdZUytyNDFPREsr?=
 =?gb2312?B?Q1hJbEdjMnhzNE9FUG1ST0YrL2VIZzQ3M3VlMGVGdldRYUJwWlg0VHNER3RX?=
 =?gb2312?B?eEtsZHp5QzZWY3Axb0J4RzhUS0wwRjBqNjBYcWdtSDJ6aUhxRnRjVHZFTHZS?=
 =?gb2312?B?UmQrOTBONHREUWdEQ1hPN3U5bFlMSElKR3RxT0NsMUJmc1JUT0V0VTNHa3VQ?=
 =?gb2312?B?TWxaOTdBaDltQ1JIcHdtcmljSEFyMTlKaVNaWXdrYVdtcitCNk5YblpVQkRz?=
 =?gb2312?B?T3EzRGxXU1lMMDhhRTV3MHBzYnBUZ2FKdzI0WE9Hc01GQVgzb1FRYjdyNllF?=
 =?gb2312?B?b2E0UHJwQmp2dUZlVFRZZEtZOGVDREc2Zk9RM3Jqb3UvZ0RKcUZldmplbWYx?=
 =?gb2312?B?LzVDL05tSDBBSDRoQTJraFdTdm1KcmFub1ZhcXBUQnI3WkpNQnBDN2toQjFG?=
 =?gb2312?B?bU1LSWVyWjZ2NURpM3JJYmE4UnB2SG9wS3l4OGdYSlZnaXR4M2xsSVBQckd3?=
 =?gb2312?B?ZWNIcFRRNEdvN1hoay9kdzMzY3hBd0FxNyt5LzhIeWNWaVM3UVFkV0VhQjZL?=
 =?gb2312?B?QUh5N2lFb0V6UkRsdm1ha2NITmdzdGczY1ZndDY4aEJwTnl3YkhuaU9xYnl1?=
 =?gb2312?B?QlpyV3JpRzF5R3BQKzNRZ25TZEdicmF3Vlk1UUVVMHVkZmxLRnpCc3hTYmhm?=
 =?gb2312?B?YUgxY2FCZ3VmOGlMTWNqbFBXRXU5dEJHOEhXQnh5QTJmWnR1NWNJUyt1dXNa?=
 =?gb2312?B?LytrcmhQeVdpVVV4KzMyaENyY29mMjRHUkk2OUYxUzR1TTcvSmpZdGZEQVk4?=
 =?gb2312?B?MnpJRTFEblBwK0VMQ0tZZXBkcE8wVFJqNkFxZVkyMWp6Tk43d2psdzJrOXNH?=
 =?gb2312?B?U3h2czZrYmVFYXVta1dHVjFoRmdwMlRTS21BYlJmWFY0cUF5dys2R3R1MnVx?=
 =?gb2312?B?bkk1bS9aditGYlh3T2R5cWxEaGsyR1NkbjJLWGFhN0JqbGM5VkorOWJLOG1J?=
 =?gb2312?B?RThhUVlMMXJVSVl0SEwvMXpYQTNWUFN4bDVEeEJTMjBkcVltcWpEMDlxLzhu?=
 =?gb2312?Q?EwQYb4VlKElmuE19TdF/u0RBxLSwSAdSofkVZuC?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ec924d-4a8a-41b1-5622-08d90a1c78fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 08:06:05.3825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qli72FirohfMdizQec0J1+scAriuLDPrIKHTXmXrzLQ69q8NTNX5oFTrRKkY21Q5mblxqI4CvAKdnWZCFjFXQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGbG9yaWFuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZs
b3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOo01MIy
OMjVIDA6NDENCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBP
bGVrc2lqIFJlbXBlbA0KPiA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IENjOiBTaGF3biBH
dW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+OyBTYXNjaGEgSGF1ZXINCj4gPHMuaGF1ZXJAcGVuZ3V0
cm9uaXguZGU+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBIZWluZXIgS2FsbHdlaXQN
Cj4gPGhrYWxsd2VpdDFAZ21haWwuY29tPjsgRnVnYW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5j
b20+Ow0KPiBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+
IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IEZhYmlvIEVz
dGV2YW0gPGZlc3RldmFtQGdtYWlsLmNvbT47DQo+IERhdmlkIEphbmRlciA8ZGF2aWRAcHJvdG9u
aWMubmw+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az47DQo+IFBoaWxpcHBl
IFNjaGVua2VyIDxwaGlsaXBwZS5zY2hlbmtlckB0b3JhZGV4LmNvbT4NCj4gU3ViamVjdDogUmU6
IFtQQVRDSCBuZXQtbmV4dCB2MyAwLzZdIHByb3ZpZGUgZ2VuZXJpYyBuZXQgc2VsZnRlc3Qgc3Vw
cG9ydA0KPiANCj4gDQo+IA0KPiBPbiA0LzI2LzIwMjEgOTo0OCBQTSwgSm9ha2ltIFpoYW5nIHdy
b3RlOg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IE9s
ZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gPj4gU2VudDogMjAyMcTq
NNTCMjPI1SAxMjozNw0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT4NCj4gPj4gQ2M6IFNoYXduIEd1byA8c2hhd25ndW9Aa2VybmVsLm9yZz47IFNhc2NoYSBI
YXVlcg0KPiA+PiA8cy5oYXVlckBwZW5ndXRyb25peC5kZT47IEFuZHJldyBMdW5uIDxhbmRyZXdA
bHVubi5jaD47IEZsb3JpYW4NCj4gPj4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPjsg
SGVpbmVyIEthbGx3ZWl0DQo+ID4+IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT47IEZ1Z2FuZyBEdWFu
IDxmdWdhbmcuZHVhbkBueHAuY29tPjsNCj4gPj4ga2VybmVsQHBlbmd1dHJvbml4LmRlOyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVh
ZC5vcmc7DQo+ID4+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRsLWxpbnV4LWlteCA8
bGludXgtaW14QG54cC5jb20+OyBGYWJpbw0KPiA+PiBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5j
b20+OyBEYXZpZCBKYW5kZXIgPGRhdmlkQHByb3RvbmljLm5sPjsNCj4gPj4gUnVzc2VsbCBLaW5n
IDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBQaGlsaXBwZSBTY2hlbmtlcg0KPiA+PiA8cGhpbGlw
cGUuc2NoZW5rZXJAdG9yYWRleC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5l
eHQgdjMgMC82XSBwcm92aWRlIGdlbmVyaWMgbmV0IHNlbGZ0ZXN0DQo+ID4+IHN1cHBvcnQNCj4g
Pj4NCj4gPj4gSGkgSm9ha2ltLA0KPiA+Pg0KPiA+PiBPbiBGcmksIEFwciAyMywgMjAyMSBhdCAw
MzoxODozMkFNICswMDAwLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4+Pg0KPiA+Pj4gSGkgT2xl
a3NpaiwNCj4gPj4+DQo+ID4+PiBJIGxvb2sgYm90aCBzdG1tYWMgc2VsZnRlc3QgY29kZSBhbmQg
dGhpcyBwYXRjaCBzZXQuIEZvciBzdG1tYWMsIGlmDQo+ID4+PiBQSFkNCj4gPj4gZG9lc24ndCBz
dXBwb3J0IGxvb3BiYWNrLCBpdCB3aWxsIGZhbGx0aHJvdWdoIHRvIE1BQyBsb29wYmFjay4NCj4g
Pj4+IFlvdSBwcm92aWRlIHRoaXMgZ2VuZXJpYyBuZXQgc2VsZnRlc3Qgc3VwcG9ydCBiYXNlZCBv
biBQSFkgbG9vcGJhY2ssDQo+ID4+PiBJIGhhdmUgYQ0KPiA+PiBxdWVzdGlvbiwgaXMgaXQgcG9z
c2libGUgdG8gZXh0ZW5kIGl0IGFsc28gc3VwcG9ydCBNQUMgbG9vcGJhY2sgbGF0ZXI/DQo+ID4+
DQo+ID4+IFllcy4gSWYgeW91IGhhdmUgaW50ZXJlc3QgYW5kIHRpbWUgdG8gaW1wbGVtZW50IGl0
LCBwbGVhc2UgZG8uDQo+ID4+IEl0IHNob3VsZCBiZSBzb21lIGtpbmQgb2YgZ2VuZXJpYyBjYWxs
YmFjayBhcyBwaHlfbG9vcGJhY2soKSBhbmQgaWYNCj4gPj4gUEhZIGFuZCBNQUMgbG9vcGJhY2tz
IGFyZSBzdXBwb3J0ZWQgd2UgbmVlZCB0byB0ZXN0cyBib3RoIHZhcmlhbnRzLg0KPiA+IEhpIE9s
ZWtzaWosDQo+ID4NCj4gPiBZZXMsIEkgY2FuIHRyeSB0byBpbXBsZW1lbnQgaXQgd2hlbiBJIGFt
IGZyZWUsIGJ1dCBJIHN0aWxsIGhhdmUgc29tZSBxdWVzdGlvbnM6DQo+ID4gMS4gV2hlcmUgd2Ug
cGxhY2UgdGhlIGdlbmVyaWMgZnVuY3Rpb24/IFN1Y2ggYXMgbWFjX2xvb3BiYWNrKCkuDQo+ID4g
Mi4gTUFDIGlzIGRpZmZlcmVudCBmcm9tIFBIWSwgbmVlZCBwcm9ncmFtIGRpZmZlcmVudCByZWdp
c3RlcnMgdG8gZW5hYmxlDQo+IGxvb3BiYWNrIG9uIGRpZmZlcmVudCBTb0NzLCB0aGF0IG1lYW5z
IHdlIG5lZWQgZ2V0IE1BQyBwcml2YXRlIGRhdGEgZnJvbQ0KPiAic3RydWN0IG5ldF9kZXZpY2Ui
Lg0KPiA+IFNvIHdlIG5lZWQgYSBjYWxsYmFjayBmb3IgTUFDIGRyaXZlcnMsIHdoZXJlIHdlIGV4
dGVuZCB0aGlzIGNhbGxiYWNrPyBDb3VsZA0KPiBiZSAic3RydWN0IG5ldF9kZXZpY2Vfb3BzIj8g
U3VjaCBhcyBuZG9fc2V0X2xvb3BiYWNrPw0KPiANCj4gRXZlbiBmb3IgUEhZIGRldmljZXMsIGlm
IHdlIGltcGxlbWVudGVkIGV4dGVybmFsIFBIWSBsb29wYmFjayBpbiB0aGUgZnV0dXJlLA0KPiB0
aGUgcHJvZ3JhbW1pbmcgd291bGQgYmUgZGlmZmVyZW50IGZyb20gb25lIHZlbmRvciB0byBhbm90
aGVyLiBJIGFtIHN0YXJ0aW5nDQo+IHRvIHdvbmRlciBpZiB0aGUgZXhpc3RpbmcgZXRodG9vbCBz
ZWxmLXRlc3RzIGFyZSB0aGUgYmVzdCBBUEkgdG8gZXhwb3NlIHRoZSBhYmlsaXR5DQo+IGZvciBh
biB1c2VyIHRvIHBlcmZvcm0gUEhZIGFuZCBNQUMgbG9vcGJhY2sgdGVzdGluZy4NCj4gDQo+IEZy
b20gYW4gRXRoZXJuZXQgTUFDIGFuZCBQSFkgZHJpdmVyIHBlcnNwZWN0aXZlLCB3aGF0IEkgd291
bGQgaW1hZ2luZSB3ZQ0KPiBjb3VsZCBoYXZlIGZvciBhIGRyaXZlciBBUEkgaXM6DQo+IA0KPiBl
bnVtIGV0aHRvb2xfbG9vcGJhY2tfbW9kZSB7DQo+IAlFVEhUT09MX0xPT1BCQUNLX09GRiwNCj4g
CUVUSFRPT0xfTE9PUEJBQ0tfUEhZX0lOVEVSTkFMLA0KPiAJRVRIVE9PTF9MT09QQkFDS19QSFlf
RVhURVJOQUwsDQo+IAlFVEhUT09MX0xPT1BCQUNLX01BQ19JTlRFUk5BTCwNCj4gCUVUSFRPT0xf
TE9PUEJBQ0tfTUFDX0VYVEVSTkFMLA0KPiAJRVRIVE9PTF9MT09QQkFDS19GSVhUVVJFLA0KPiAJ
X19FVEhUT09MX0xPT1BCQUNLX01BWA0KPiB9Ow0KDQpXaGF0J3MgdGhlIGRpZmZlcmVuY2UgYmV0
d2VlbiBpbnRlcm5hbCBhbmQgZXh0ZXJuYWwgbG9vcGJhY2sgZm9yIGJvdGggUEhZIGFuZCBNQUM/
IEkgYW0gbm90IGZhbWlsaWFyIHdpdGggdGhlc2UgY29uY2VwdHMuIFRoYW5rcy4NCg0KQmVzdCBS
ZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IAlpbnQgKCpuZG9fc2V0X2xvb3BiYWNrX21vZGUpKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYsIGVudW0NCj4gZXRodG9vbF9sb29wYmFja19tb2RlIG1vZGUp
Ow0KPiANCj4gYW5kIHdpdGhpbiB0aGUgRXRoZXJuZXQgTUFDIGRyaXZlciB5b3Ugd291bGQgZG8g
c29tZXRoaW5nIGxpa2UgdGhpczoNCj4gDQo+IAlzd2l0Y2ggKG1vZGUpIHsNCj4gCWNhc2UgRVRI
VE9PTF9MT09QQkFDS19QSFlfSU5URVJOQUw6DQo+IAljYXNlIEVUSFRPT0xfTE9PUEJBQ0tfUEhZ
X0VYVEVSTkFMOg0KPiAJY2FzZSBFVEhUT09MX0xPT1BCQUNLX09GRjoNCj4gCQlyZXQgPSBwaHlf
bG9vcGJhY2sobmRldi0+cGh5ZGV2LCBtb2RlKTsNCj4gCQlicmVhazsNCj4gCS8qIE90aGVyIGNh
c2Ugc3RhdGVtZW50cyBpbXBsZW1lbnRlZCBpbiBkcml2ZXIgKi8NCj4gDQo+IHdlIHdvdWxkIG5l
ZWQgdG8gY2hhbmdlIHRoZSBzaWduYXR1cmUgb2YgcGh5X2xvb3BiYWNrKCkgdG8gYWNjZXB0IGJl
aW5nDQo+IHBhc3NlZCBldGh0b29sX2xvb3BiYWNrX21vZGUgc28gd2UgY2FuIHN1cHBvcnQgZGlm
ZmVyZW50IG1vZGVzLg0KPiANCj4gV2hldGhlciB3ZSB3YW50IHRvIGNvbnRpbnVlIHVzaW5nIHRo
ZSBzZWxmLXRlc3RzIEFQSSwgb3IgaWYgd2UgaW1wbGVtZW50IGENCj4gbmV3IGV0aHRvb2wgY29t
bWFuZCBpbiBvcmRlciB0byByZXF1ZXN0IGEgbG9vcGJhY2sgb3BlcmF0aW9uIGlzIHVwIGZvcg0K
PiBkaXNjdXNzaW9uLg0KPiAtLQ0KPiBGbG9yaWFuDQo=
