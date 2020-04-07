Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8D21A0DB8
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgDGMeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 08:34:08 -0400
Received: from mail-eopbgr70101.outbound.protection.outlook.com ([40.107.7.101]:53668
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728630AbgDGMeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 08:34:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFaDgPuLBpaG0+xGihVRvretwRWpe2ePlYA+4yOr4tNZbL1BEgxC1LDgMtzdv2iSMlrgbKybzyx8TPA3+uLkhVsJCTUpd/nZAHa1OjT9hVjP5hn+uc2ZtNII2pX2wBL2Zeif6+ec1gLgF1E2Dhlf6m7pEFGOCYCc/PUCQX+7n07DgTamPfvNBbDYxx6AOluwfgL40uiqg/8kqfiFdtHE32iOrKZoKxRc/baNTHvemURD+b0dCTm89F/w78QqeNHdxLQsKAWMfBxgKXyuohbKX3aZsiR5IRJ9Waj20S6a2x4Kb4xUVzdQ7w9dOwG0ZzeidQOmQt7EmXNn9trhVpzVXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txnbeOhJli1w0n+2JYo9H7VTgPC0tS7JPPFXObOEwOc=;
 b=dQvh6DWl0pKMw5ppFmLQAkfiM4aMBz1FAvrPJDqhF2rZiklc+69KmytZPl+dGOTnM5IALb1iGlSCKTNQ2Kexe9Z0KO39DHIrFLusEH3iTn2X+orbUVI3N/zQHogcEJK5VvxDPfWA6iCXmdnMbzZWFWsriIv7in2l5thpSLgO7Lsf1ePWQMADqx4098wTF0aCqfKbSh5+yzmrrKudULKtXXv0DTfe8QQAIOWhIKCZT6vUxjb4DpmVcSsKV6rypCzYxOhg8PIc91OaavfrzMFfCePrV+SEu2F881MqZ1ZSRkBUNcEXe77CrLmKMhP2Fw0cFulXvsjAx78D1G56fvKoTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txnbeOhJli1w0n+2JYo9H7VTgPC0tS7JPPFXObOEwOc=;
 b=hQuJYJBCpWn7MTqbWnIjgzf6Y11nUZVrJUKlEO1ktIb3Chn0eLHXgth9z06odXSZzYlZkD4lgRfHUYKuI75laE/34JKdSuGbMA2Kn8Jv+Nrl40sha54Cre+uEzbVv1XGFfR7/YRY+OctYwXQOekFH2KkqgJp4l+VDxiLs9JHv2I=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (2603:10a6:20b:a8::25)
 by AM6PR05MB4999.eurprd05.prod.outlook.com (2603:10a6:20b:3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 7 Apr
 2020 12:34:04 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::44ad:bee7:b765:b9c7]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::44ad:bee7:b765:b9c7%7]) with mapi id 15.20.2878.021; Tue, 7 Apr 2020
 12:34:04 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Topic: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Index: AQHWDMAdAKh4okIfHEScpK5LI+w0J6htfQ6AgAABfoCAABmXgA==
Date:   Tue, 7 Apr 2020 12:34:04 +0000
Message-ID: <2a04a3aa095c39ad165c7774dd0e92aa8fbd2cd4.camel@toradex.com>
References: <20200407093654.26095-1-o.rempel@pengutronix.de>
         <699bf716ce12178655b47ce77227e4e42b85de1b.camel@toradex.com>
         <49e9c223-78ed-f735-1787-f8c38cb18b1c@pengutronix.de>
In-Reply-To: <49e9c223-78ed-f735-1787-f8c38cb18b1c@pengutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49f4fbcd-fcda-45a9-4de9-08d7daeff539
x-ms-traffictypediagnostic: AM6PR05MB4999:
x-microsoft-antispam-prvs: <AM6PR05MB4999947C8AFCA0F3108157DCF4C30@AM6PR05MB4999.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(136003)(376002)(346002)(366004)(39850400004)(7416002)(8676002)(2906002)(110136005)(71200400001)(81156014)(81166006)(2616005)(44832011)(5660300002)(54906003)(478600001)(6486002)(36756003)(6512007)(8936002)(4326008)(186003)(76116006)(316002)(6506007)(86362001)(66556008)(64756008)(66446008)(53546011)(66946007)(66476007)(91956017)(26005);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cl2go9aQR83jIIl/6+D4NaQFREjvE+xeUtZnJC7JTfKSB7pw9iu0Lyw4dG49Z4UpYrIaTtps3j+47E6bg+6C38le1J6H84v+/GM7+KBU6z1qzxX9JBr5+HyA9ZMoyJzmW9QTTvHA055gZ/9IQjgkfijvN6fIKOcd0pTumeAGWriieVzi3CbgKSmz6uzNk+2Qde9coM5iNcV+VzaeA7ibDt9DM4Tz2BD+tMN34GdRBEN5yHUuRGkpJYINMgZbz1SAszAde7lxDRznihT+vUr7uLoD+l+Un6TINxWMbyrwslhXD9bWoboQCU2anK/W0dV9NwL50I/1S8rhvSK+jxLBDCRIbAf2qG8lDCIig9NtVF1/Z+2vvSzRbVW/SBdOc1vYtErrVJSsf0BOYgciluuHl3lZw1nxV45s+T91Jn6HXPrlztMJr+JBnyG+xWJ8TuvJ
x-ms-exchange-antispam-messagedata: trzYdo0EcYm9kaPZOH9aVz399Y3nAsdrDy3VJUWy2NSHkUjFRvXiuQUtHxGWMfnvvLTIdLvr0KEwbYAGYZ4BEdeUHlmAAFiXWZb1ako6sfD8ZHibBbSmZtM+k5gVGUlt7+zbfkxUqsp0cM2T9vAy9w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <22C40361AEE4E54EA100FE1A4C13ED09@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f4fbcd-fcda-45a9-4de9-08d7daeff539
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 12:34:04.1027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rmolsub5TP4hl3HppJMkVEnTjF/uzrOQrbvWAA57/jTKbzequ66xAUWSZpQzarDyUKKpqlN95v4P+F971eIuH8f/ndQ4mONl6SLR6GEiKBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4999
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTA3IGF0IDEzOjAyICswMjAwLCBNYXJjIEtsZWluZS1CdWRkZSB3cm90
ZToNCj4gT24gNC83LzIwIDEyOjU3IFBNLCBQaGlsaXBwZSBTY2hlbmtlciB3cm90ZToNCj4gPiBP
biBUdWUsIDIwMjAtMDQtMDcgYXQgMTE6MzYgKzAyMDAsIE9sZWtzaWogUmVtcGVsIHdyb3RlOg0K
PiA+ID4gQWRkIHN1cHBvcnQgZm9yIGZvbGxvd2luZyBwaHktbW9kZXM6IHJnbWlpLCByZ21paS1p
ZCwgcmdtaWktdHhpZCwNCj4gPiA+IHJnbWlpLXJ4aWQuDQo+ID4gPiANCj4gPiA+IFRoaXMgUEhZ
IGhhcyBhbiBpbnRlcm5hbCBSWCBkZWxheSBvZiAxLjJucyBhbmQgbm8gZGVsYXkgZm9yIFRYLg0K
PiA+ID4gDQo+ID4gPiBUaGUgcGFkIHNrZXcgcmVnaXN0ZXJzIGFsbG93IHRvIHNldCB0aGUgdG90
YWwgVFggZGVsYXkgdG8gbWF4DQo+ID4gPiAxLjM4bnMNCj4gPiA+IGFuZA0KPiA+ID4gdGhlIHRv
dGFsIFJYIGRlbGF5IHRvIG1heCBvZiAyLjU4bnMgKGNvbmZpZ3VyYWJsZSAxLjM4bnMgKyBidWls
ZA0KPiA+ID4gaW4NCj4gPiA+IDEuMm5zKSBhbmQgYSBtaW5pbWFsIGRlbGF5IG9mIDBucy4NCj4g
PiA+IA0KPiA+ID4gQWNjb3JkaW5nIHRvIHRoZSBSR01JSSB2MS4zIHNwZWNpZmljYXRpb24gdGhl
IGRlbGF5IHByb3ZpZGVkIGJ5DQo+ID4gPiBQQ0INCj4gPiA+IHRyYWNlcw0KPiA+ID4gc2hvdWxk
IGJlIGJldHdlZW4gMS41bnMgYW5kIDIuMG5zLiBUaGUgUkdNSUkgdjIuMCBhbGxvd3MgdG8NCj4g
PiA+IHByb3ZpZGUNCj4gPiA+IHRoaXMNCj4gPiA+IGRlbGF5IGJ5IE1BQyBvciBQSFkuIFNvLCB3
ZSBjb25maWd1cmUgdGhpcyBQSFkgdG8gdGhlIGJlc3QgdmFsdWVzDQo+ID4gPiB3ZQ0KPiA+ID4g
Y2FuDQo+ID4gPiBnZXQgYnkgdGhpcyBIVzogVFggZGVsYXkgdG8gMS4zOG5zIChtYXggc3VwcG9y
dGVkIHZhbHVlKSBhbmQgUlgNCj4gPiA+IGRlbGF5DQo+ID4gPiB0bw0KPiA+ID4gMS44MG5zIChi
ZXN0IGNhbGN1bGF0ZWQgZGVsYXkpDQo+ID4gPiANCj4gPiA+IFRoZSBwaHktbW9kZXMgY2FuIHN0
aWxsIGJlIGZpbmUgdHVuZWQvb3ZlcndyaXR0ZW4gYnkgKi1za2V3LXBzDQo+ID4gPiBkZXZpY2Ug
dHJlZSBwcm9wZXJ0aWVzIGRlc2NyaWJlZCBpbjoNCj4gPiA+IERvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvbWljcmVsLWtzejkweDEudHh0DQo+ID4gPiANCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gPiAN
Cj4gPiBNYWtlIHN1cmUgeW91IGRvIG5vdCBleGNlZXQgODAgY2hhcnMgd2l0aCB5b3VyIHBoeWRl
dl93YXJuLiBCZXNpZGVzDQo+ID4gdGhhdDoNCj4gDQo+IFdhcm5pbmcgYW5kIEVycm9yIHN0cmlu
Z3Mgc2hvdWxkIG5vdCBiZSB3cmFwcGVkLCBzbyB0aGF0IHlvdSBjYW4NCj4gYmV0dGVyDQo+ICJn
cmVwIiBmb3IgdGhlbS4NCg0KRGlkbid0IGtuZXcgdGhhdCwgdGhhbmtzIQ0KPiANCj4gcmVnYXJk
cywNCj4gTWFyYw0KPiANCg==
