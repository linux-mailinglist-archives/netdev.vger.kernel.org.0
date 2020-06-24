Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07E72073D4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390788AbgFXMz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:55:58 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:52964
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388942AbgFXMz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 08:55:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8m5r+rWdDzjKZPsGES35mzca/XeRD6aRWXNVRltFw80mLYr6UXkmPwi12/ji6Up18C0jzEUpdRNCZRxDd9kWIgIgdYc5rKS3bTeFjFp6YGD6IDjY8dQhNumlMVo6oLCiGHaTJzylUlUwwG4L0kxzeIQBwCB6QreJLAw0p3CjeHjPPMUBPyGRFOXdbAp8+vi0IETcC4uKpEXptOG6bioNAlry82vN2XOrxSfeWKdODund1WW0oRRxQ1UilFgTO3k1b0phGkgzTXWh7c+MmlwbpiC3eh7LOZlubmxOD4/lntHqAksxxSdwGI1EjfKnh+/BGMfhdLn5ny32eOcnwW6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIXoO9FtkFfC8MmioM9R0W6NldBhE6IkRajDMkRFNag=;
 b=IuVwW7ocRtzkprvWxE4vz7ksYd/rVfQbIBvArrNpp0XmD3eLIJ8raOZwql12gzv7YwDWBLGm5dYHh80Fhsb8nwN/2aTTohq/QogaHsp8r0haxYOWFFPRe5cPepzrod0uvxGE34TZTBYuyXNxVRO/7CJvUmeIzjwzGCfW+LbPTFPqdCu+kwE/SvxKQKrSH9lsp08HHFV0GYfaE/YuZsZk4GH8D5010MGwELfNNcVDHx/rnL+7UBsQiIF3x6y3vgnE4QnI+PR6289DER3JYM//8IaanCArItY72iSQAAv8pbPPHFtvg2EvrDA6gIEP8cMxHBaPuaPu333iDXsdpUhyeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIXoO9FtkFfC8MmioM9R0W6NldBhE6IkRajDMkRFNag=;
 b=fGI75GwhYO2yADyzQk9wSEIvGirn4+JOAE9bq10qLYVxawQ4xHcpmiSNwYRGjRn/rCIk/ogtjEEw3pvSwuMY4Fn/xYI6W4IJ7IK5dEImAYaJynt4Mv4ECD2h7ZuxIAlKiGi2kPei45Ly0A8nhnGAZRoYyFzdzZiqtgHOu87jc9A=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR0402MB3697.eurprd04.prod.outlook.com (2603:10a6:208:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 12:55:53 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 12:55:53 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next v3 2/7] dt-bindings: net: add backplane
 dt bindings
Thread-Topic: [EXT] Re: [PATCH net-next v3 2/7] dt-bindings: net: add
 backplane dt bindings
Thread-Index: AQHWSJoNB4Y+AeLtQEWS02n1NrfrpKjlNZaAgAJ9eQA=
Date:   Wed, 24 Jun 2020 12:55:53 +0000
Message-ID: <AM0PR04MB5443F5EDD551C7613AF21EF4FB950@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-3-git-send-email-florinel.iordache@nxp.com>
 <7035531d-3e74-6fd4-0df6-fa730998b065@gmail.com>
In-Reply-To: <7035531d-3e74-6fd4-0df6-fa730998b065@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.123.197.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c87e4fba-78f3-4510-e3b4-08d8183dedb0
x-ms-traffictypediagnostic: AM0PR0402MB3697:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0402MB36972CD660EA9707F6801ED0FB950@AM0PR0402MB3697.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9CLUmbYT/V3E3dYQue2qCUBDPLZwhz6fVx8x7l3eCfWD+6Mr1mcFqsX4dGN7hgV+DGt6ePxGJAJO09whw008WMYZabgvOeN6a4i99mJ04pBgdi9Up0rpZ1wtnMvdNGg/bVWz1lKyveb6a8/NzyFBNIaPKj38WYTWEvES/F6wV14bLGF/OZe+kDReFz387YzJKX2nsa8lwfa9atSkt3ejFyuNoUyIfmTVSlSDuuiwCcf9zgbCG8JQTGp8s4ANs1deY2qszGsuywltPYXPxHA3SioYBaOTk+ET95lDEGUNIo0xpxSsvQZps4VvTOAJ0+qQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(53546011)(2906002)(52536014)(7696005)(6506007)(33656002)(5660300002)(316002)(110136005)(54906003)(186003)(86362001)(478600001)(71200400001)(76116006)(26005)(7416002)(4326008)(83380400001)(9686003)(66556008)(8676002)(44832011)(66476007)(66946007)(8936002)(64756008)(55016002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Pt28AQVtlHOv3fcGAgSSkysT/qHR29NtQjirl71mkND2vckpJGSwep7ar7L+78BHo/UT7yVfsg8UIkjpbb0I0RyU0mCpBAxU5vlh00u2wRyTmVeM8jL3bnomzCef2aK/S8z+n8lVz1mhVgYuYj9gUQGNxXfoT7xWHhcdKVYLlXhcON36f/67Oj70alLquSwnfdA47fAYd/e5lZeQa9WtS0RgyWqTjQPOd4VGMQawv0/VD0lH2QN5298tXMxpN+oIwXJASQNukADQWq3jeLQeSpaa5mspnE4QPG09a57UQr/KQY+FcvSUIOIGru1a9LN8sNirTV89qoDjInkvNxsXYUJAYlRv+AgibgiZknL2keumLyo4dlsPqgQpl92PBTKhwWMTbtBbHcjQxFCO835z4rT/MSmALyADrt5WLqDcevn6GGI46EZeDUjjKPV08vEvl0wUuARFFFLJcuFcNcGngzlsUN9tD/VSVoP5DN4oWoIj2rPKSrJw3XDkXq02HDoR
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c87e4fba-78f3-4510-e3b4-08d8183dedb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 12:55:53.1760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iYiJrK64X6RLnJqUrpk58h5Oj8qSQm6G8fQO7HAsKK/4T2mvGUI/C0340TsRU9LNhyh9QafPxXE6ojmIZ0zSYo79Ai87sSIHDzZPUvFx5/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3697
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgSnVuZSAyMywgMjAyMCAxOjIx
IEFNDQo+IFRvOiBGbG9yaW5lbCBJb3JkYWNoZSA8ZmxvcmluZWwuaW9yZGFjaGVAbnhwLmNvbT47
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFuZHJld0Bs
dW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbGludXhAYXJtbGludXgub3JnLnVrDQo+
IENjOiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtZG9jQHZnZXIua2VybmVsLm9y
ZzsNCj4gcm9iaCtkdEBrZXJuZWwub3JnOyBtYXJrLnJ1dGxhbmRAYXJtLmNvbTsga3ViYUBrZXJu
ZWwub3JnOw0KPiBjb3JiZXRAbHduLm5ldDsgc2hhd25ndW9Aa2VybmVsLm9yZzsgTGVvIExpIDxs
ZW95YW5nLmxpQG54cC5jb20+OyBNYWRhbGluDQo+IEJ1Y3VyIChPU1MpIDxtYWRhbGluLmJ1Y3Vy
QG9zcy5ueHAuY29tPjsgSW9hbmEgQ2lvcm5laQ0KPiA8aW9hbmEuY2lvcm5laUBueHAuY29tPjsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENI
IG5ldC1uZXh0IHYzIDIvN10gZHQtYmluZGluZ3M6IG5ldDogYWRkIGJhY2twbGFuZSBkdA0KPiBi
aW5kaW5ncw0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBPbiA2LzIyLzIwIDY6MzUg
QU0sIEZsb3JpbmVsIElvcmRhY2hlIHdyb3RlOg0KPiA+IEFkZCBldGhlcm5ldCBiYWNrcGxhbmUg
ZGV2aWNlIHRyZWUgYmluZGluZ3MNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEZsb3JpbmVsIElv
cmRhY2hlIDxmbG9yaW5lbC5pb3JkYWNoZUBueHAuY29tPg0KPiA+IC0tLQ0KPiANCj4gW3NuaXBd
DQo+IA0KPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ICsgICRub2RlbmFtZToNCj4gPiArICAgIHBhdHRl
cm46ICJec2VyZGVzKEBbYS1mMC05XSspPyQiDQo+ID4gKw0KPiA+ICsgIGNvbXBhdGlibGU6DQo+
ID4gKyAgICBvbmVPZjoNCj4gPiArICAgICAgLSBjb25zdDogc2VyZGVzLTEwZw0KPiA+ICsgICAg
ICAgIGRlc2NyaXB0aW9uOiBTZXJEZXMgbW9kdWxlIHR5cGUgb2YgMTBHDQo+IA0KPiBTaW5jZSB0
aGlzIGFwcGVhcnMgdG8gYmUgbWVtb3J5IG1hcHBlZCBpbiB5b3VyIGNhc2UsIGl0IGRvZXMgbm90
IHNvdW5kIGxpa2UNCj4gInNlcmRlcy0xMGciIGFsb25lIGlzIGdvaW5nIHRvIGJlIHN1ZmZpY2ll
bnQsIHNob3VsZCBub3Qgd2UgaGF2ZSBhIFNvQyBzcGVjaWZpYw0KPiBjb21wYXRpYmxlIHN0cmlu
ZyBpZiBub3RoaW5nIGVsc2U/DQoNCk15IGludGVudGlvbiB3YXMgdG8gbWFrZSBpdCBnZW5lcmlj
IGVub3VnaCB0byBiZSB1c2VkIGJ5IGFueSBTZXJEZXMgKFNlcmlhbGl6ZXIvRGVzZXJpYWxpemVy
KSBibG9jay4NClNvIEkgd2FzIHRoaW5raW5nIHRoYXQgc3BlY2lmeWluZyBzZXJkZXMgYXMgSFcg
YmxvY2sgYW5kIHRoZSB0eXBlOiAxMGcgKG9yIDI4ZyBmb3IgZXhhbXBsZSkgc2hvdWxkIGJlIGVu
b3VnaC4NCkkgY291bGQgYWRkIFNvQyBzcGVjaWZpYyAob3IgZmFtaWx5IG9mIFNvQykgdG8gdGhl
IGNvbXBhdGlibGUgc3RyaW5nDQpsaWtlIGZvciBleGFtcGxlIEZyZWVzY2FsZS9OWFAgUW9ySVEg
U29jOiAiZnNsLGxzMTA0NmEtc2VyZGVzLTEwZyIgb3IgImZzbCxxb3JpcS1zZXJkZXMtMTBnIg0K
DQo+IA0KPiA+ICsNCj4gPiArICByZWc6DQo+ID4gKyAgICBkZXNjcmlwdGlvbjoNCj4gPiArICAg
ICAgUmVnaXN0ZXJzIG1lbW9yeSBtYXAgb2Zmc2V0IGFuZCBzaXplIGZvciB0aGlzIHNlcmRlcyBt
b2R1bGUNCj4gPiArDQo+ID4gKyAgcmVnLW5hbWVzOg0KPiA+ICsgICAgZGVzY3JpcHRpb246DQo+
ID4gKyAgICAgIE5hbWVzIG9mIHRoZSByZWdpc3RlciBtYXAgZ2l2ZW4gaW4gInJlZyIgbm9kZS4N
Cj4gDQo+IFlvdSB3b3VsZCBhbHNvIG5lZWQgdG8gZGVzY3JpYmUgaG93IG1hbnkgb2YgdGhlc2Ug
dHdvIHByb3BlcnRpZXMgYXJlDQo+IGV4cGVjdGVkLg0KDQpPbmx5IG9uZSBtZW1vcnkgbWFwIGlz
IHJlcXVpcmVkIHNpbmNlIHRoZSBtZW1vcnkgbWFwcyBmb3IgbGFuZXMgYXJlIGluZGl2aWR1YWxs
eSBkZXNjcmliZWQNCihhcyBpdCBpcyBkb2N1bWVudGVkIGluIHNlcmRlcy1sYW5lLnlhbWwpLg0K
SSB3aWxsIHNwZWNpZnkgdGhpcy4NCg0KPiANCj4gPiArDQo+ID4gKyAgbGl0dGxlLWVuZGlhbjoN
Cj4gPiArICAgIGRlc2NyaXB0aW9uOg0KPiA+ICsgICAgICBTcGVjaWZpZXMgdGhlIGVuZGlhbm5l
c3Mgb2Ygc2VyZGVzIG1vZHVsZQ0KPiA+ICsgICAgICBGb3IgY29tcGxldGUgZGVmaW5pdGlvbiBz
ZWUNCj4gPiArICAgICAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2NvbW1vbi1w
cm9wZXJ0aWVzLnR4dA0KPiANCj4gVGhpcyBpcyByZWR1bmRhbnQgd2l0aCB0aGUgZGVmYXVsdCBi
aW5kaW5nIHRoZW4sIGFuZCBpZiBpdCBpcyBub3QgYWxyZWFkeSBpbiB0aGUNCj4gY29tbW9uIFlB
TUwgYmluZGluZywgY2FuIHlvdSBwbGVhc2UgYWRkIGxpdHRsZS1lbmRpYW4gYW5kIG5hdGl2ZS1l
bmRpYW4NCj4gYWRkZWQgdGhlcmU/DQoNClRoZSBlbmRpYW5uZXNzIG9mIHRoZSBzZXJkZXMgYmxv
Y2sgbXVzdCBiZSBzcGVjaWZpZWQgYXMgbGl0dGxlLWVuZGlhbiBvciBiaWctZW5kaWFuLg0KVGhl
IHNlcmRlcyBlbmRpYW5uZXNzIG1heSBiZSBkaWZmZXJlbnQgdGhhbiB0aGUgY29yZXMgZW5kaWFu
bmVzcy4NClRoaXMgaXMgYWxzbyB0aGUgY2FzZSBmb3IgUW9ySVEgTFMxMDQzL0xTMTA0NiBwbGF0
Zm9ybXMgd2l0aCBBUk0gY29yZXMgd2hpY2gNCmFyZSBsaXR0bGUgZW5kaWFuIGJ1dCBzZXJkZXMg
YmxvY2sgaXMgYmlnIGVuZGlhbi4NClNvIGVuZGlhbm5lc3MgbXVzdCBiZSBzcGVjaWZpZWQgaW4g
ZGV2aWNlIHRyZWUgaW4gb3JkZXIgZm9yIHRoZSBkcml2ZXIgdG8ga25vdyBob3cgdG8gYWNjZXNz
IGl0Lg0KVGhpcyBpcyB0aGUgZ2VuZXJpYyBiaW5kaW5nIGRlc2NyaXB0aW9uICh3aXRoIGFuIGV4
YW1wbGUgYmVsb3cpDQpidXQgZm9yIExTMTA0NiBwbGF0Zm9ybSBmb3IgZXhhbXBsZSB3ZSBzaG91
bGQgcHV0OiBiaWctZW5kaWFuDQooYXMgaXQgaXMgaW4gdGhlIGxhc3QgcGF0Y2g6IDAwMDctYXJt
NjQtZHRzLWFkZC1zZXJkZXMtYW5kLW1kaW8tZGVzY3JpcHRpb24ucGF0Y2gNCmluIGZpbGU6IC9h
cmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9mc2wtbHMxMDQ2YS5kdHNpICkNCg0KPiANCj4g
PiArDQo+ID4gK2V4YW1wbGVzOg0KPiA+ICsgIC0gfA0KPiA+ICsgICAgc2VyZGVzMTogc2VyZGVz
QDFlYTAwMDAgew0KPiA+ICsgICAgICAgIGNvbXBhdGlibGUgPSAic2VyZGVzLTEwZyI7DQo+ID4g
KyAgICAgICAgcmVnID0gPDB4MCAweDFlYTAwMDAgMCAweDAwMDAyMDAwPjsNCj4gPiArICAgICAg
ICByZWctbmFtZXMgPSAic2VyZGVzIiwgInNlcmRlcy0xMGciOw0KPiA+ICsgICAgICAgIGxpdHRs
ZS1lbmRpYW47DQo+ID4gKyAgICB9Ow0KPiA+DQo+IA0KPiANCj4gLS0NCj4gRmxvcmlhbg0KDQpU
aGFuayB5b3UgZm9yIGZlZWRiYWNrDQpGbG9yaW5lbC4NCg==
