Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF4A1D288F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 09:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgENHNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 03:13:35 -0400
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:6083
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgENHNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 03:13:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPv5fDv/w83Gy3o15NANiY16NenRlC00twFzJhRZzE6ujGi2e5Pito5X41tIVaMzOnuNpJcdmVbFxzKxNW+ejCJ1VJLU4v6o80O9XKIyiLKlrQiXsBGWwk4HyGZd9m8CKEFQMIXblvrh1E/90WFGQYcoCJKF2hZ8+vdkse7kMZ6LXqD9DhwzozHBnhW7rcQP5QGtBZLexfAkA9V4hx1SL28uarIzBL1JgwbE0mlfBFIbLnWeXR9fBkoJLE3djCqSkCyPeisuneJBVdkY/Iq1x6wDyLDu2gfmx4zSMigaLAyTmtYaBxu4Njs6ysl5/RisBZyxYrLNcpF9OTgv9r0iZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maY+MjDq7rpXVjrdP94zzFJKMiY0khqwZM/KYj0KhIM=;
 b=hwtSaD2m5+qwVQ9a73MlVoLW7Yf7JyG7GWSAY8e2wITe5Wp8NiXGnMG8ArkQz0eqbwkSTwNaFXQcT2Tg17zvdTul5bDxAlNX/Bg5HDcR2gdl40UgP2Nv/IMtrWg6nZVKooukbFYCiGWj6zriV8vO6WOHFMSDJwYY7wQYNRFWYbOGE6lZ0AUrv34BR4QVxZcxJFO7kmTca33AX3JcTcIW8O3Z1HDkArWbby1HiOoqR6DpOPTIL+nA1HXoRh5kqS6Ev1m4xK742wu7kRgS5YM7FRuugR7B0iNyYmtF2QuLXJtEewefuasJkhAqtEUlncKSfRRClmYo8ioTdmN9OpcD2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maY+MjDq7rpXVjrdP94zzFJKMiY0khqwZM/KYj0KhIM=;
 b=DZ8dOkD2CAvrn+ZMXv2JMcc4FEZcpNi5I4gU3Csh1hle7yK08wqEmGlVWpD3AluA007pa21poRxS63mtaj/Fz+NzK6S9ZhmJtu8D3NG652UH5YJYZvu69gHmKuYR6pdMJSuJJHGHUBt404r7alOt832XUYKMiFc94Phd6K9+7WE=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB5876.eurprd04.prod.outlook.com (2603:10a6:208:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Thu, 14 May
 2020 07:13:30 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00%9]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 07:13:30 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: RE: [EXT] Re: signal quality and cable diagnostic
Thread-Topic: [EXT] Re: signal quality and cable diagnostic
Thread-Index: AQHWJ6ExNilqBbwzZ0ehkAYa7smAYaikHY+AgAMNSsA=
Date:   Thu, 14 May 2020 07:13:30 +0000
Message-ID: <AM0PR04MB7041DE18F2966573DB6E078586BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511143337.GC413878@lunn.ch> <20200512082201.GB16536@pengutronix.de>
In-Reply-To: <20200512082201.GB16536@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [88.130.52.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c8a47c7f-f02f-44b9-7eba-08d7f7d64e6d
x-ms-traffictypediagnostic: AM0PR04MB5876:
x-microsoft-antispam-prvs: <AM0PR04MB5876160120A46E3C784DB94C86BC0@AM0PR04MB5876.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wnIPQOEhJoI7IcWInAc4/jLbMXpiMZWdkzsv5bm60u6wfx0iRQeklTaohA1uGmkUU24xqI5ftfpSDKrErXPGwIq4JwA9ROYl63+BCqQMG5GeV99JhN5rt99M2l1UXNLkLNOiF7ZeV9TOqgMhlCsyIMBweN//AK2NMsfaUb8WEhnkRjVldtPkriqW1jeyGpK4MvP7vRBwFw9jq2Y8D4sMVU3v1AmQnn+OwMfu59VMYEDphx1CL3hHQ9Ujr5pCKcAXAgE1CDyXV+MRP8Yoc3znbm0UIKzftTFIGRv8KTN5J4wlt8yjD5/N4o14ANyPVxgGZXFDqWE5S3kS9RcWOj47yrqb51OVSmVA+Vx1lI7sGB7ZNEV0ABbXnLbv4PPZ8YQ2dxvJ+2ejZgiYfOeeMMOx7FEYYNkflCFC5lIXBmAFRgFFrzrDJ0flnkoguQ3LqHXx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(316002)(86362001)(8936002)(71200400001)(2906002)(9686003)(4326008)(26005)(110136005)(52536014)(54906003)(7696005)(55016002)(5660300002)(66476007)(44832011)(66556008)(66946007)(8676002)(33656002)(66446008)(76116006)(7416002)(64756008)(478600001)(186003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kqSDKHQoCTRcsrSrgEI0Q3wBA9TH5/pa5fxuoMsVBLOCyYQLnxSo46mlSSu0EdSC7/f1yMJGWgW4Q1PO5K8C8Eq83qQzam56tUKPfDp0Gto5JuDUgo1fgDJD41ueEz68+Lu2w1uIfJ9NhqWPfXWytujNJS2GCoRKoPLaoWUqc3Hhp7mC4jHgqIYaMMHiD9laS2fOesdoBedfJKAnh8DSZo+yrNbAFqNBjGFkPs5Oh2im4tHM5Nx7DgPhyMtXbDybrozCvJP4jyQA3cht4iXf3n4hRghFIrvMKtGocq4dmTcV34A8ckQSMI1er+ZGHvLrLHqQeZRojGWNE9wHbyeLBxpfYDkUF4S31r/1rytw8y3l6TWPfScOWF18vFjNNePlVLluO4jJgEFAbjQda2uYJnXrK9lFjjHOMaYgYJ3zrxshpFhH28wWIoTNWm0Bclar/3pp437jWFWhTz2G3saaNR1et6wnWG0HMeFIbx1ld3c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8a47c7f-f02f-44b9-7eba-08d7f7d64e6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 07:13:30.5571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSnbpQnw1Nojp8OxCHdzlvEUNgbn2v4LJiZc2qjnk/HJmunejyM6XnJEaQwCE2n3hbRAe5Wvgy01UXebK4hIMXxdjc2eNcAwm2X4rB02mTw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5876
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBNYXkgMTIsIDIwMjAgYXQgMTA6MjI6MDFBTSArMDIwMCwgT2xla3NpaiBSZW1wZWwg
d3JvdGU6DQoNCj4gU28gSSB0aGluayB3ZSBzaG91bGQgcGFzcyByYXcgU1FJIHZhbHVlIHRvIHVz
ZXIgc3BhY2UsIGF0IGxlYXN0IGluIHRoZQ0KPiBmaXJzdCBpbXBsZW1lbnRhdGlvbi4NCg0KPiBX
aGF0IGRvIHlvdSB0aGluayBhYm91dCB0aGlzPw0KDQpIaSBPbGVrc2lqLA0KDQpJIGhhZCBhIGNo
ZWNrIGFib3V0IHRoZSBiYWNrZ3JvdW5kIG9mIHRoaXMgU1FJIHRoaW5nLiBUaGUgdGFibGUgeW91
IHJlZmVyZW5jZSB3aXRoIGNvbmNyZXRlIFNOUiB2YWx1ZXMgaXMgaW5mb3JtYXRpdmUgb25seSBh
bmQgbm90IGEgcmVxdWlyZW1lbnQuIFRoZSByZXF1aXJlbWVudHMgYXJlIHJhdGhlciBsb29zZS4N
Cg0KVGhpcyBpcyBmcm9tIE9BOg0KLSBPbmx5IGZvciBTUUk9MCBhIGxpbmsgbG9zcyBzaGFsbCBv
Y2N1ci4NCi0gVGhlIGluZGljYXRlZCBzaWduYWwgcXVhbGl0eSBzaGFsbCBtb25vdG9uaWMgaW5j
cmVhc2luZyAvZGVjcmVhc2luZyB3aXRoIG5vaXNlIGxldmVsLg0KLSBJdCBzaGFsbCBiZSBpbmRp
Y2F0ZWQgaW4gdGhlIGRhdGFzaGVldCBhdCB3aGljaCBsZXZlbCBhIEJFUjwxMF4tMTAgKGJldHRl
ciB0aGFuIDEwXi0xMCkgaXMgYWNoaWV2ZWQgKGUuZy4gImZyb20gU1FJPTMgdG8gU1FJPTcgdGhl
IGxpbmsgaGFzIGEgQkVSPDEwXi0xMCAoYmV0dGVyIHRoYW4gMTBeLTEwKSIpDQoNCkkuZS4gU1FJ
IGRvZXMgbm90IG5lZWQgdG8gaGF2ZSBhIGRpcmVjdCBjb3JyZWxhdGlvbiB3aXRoIFNOUi4gVGhl
IGZ1bmRhbWVudGFsIHVuZGVybHlpbmcgbWV0cmljIGlzIHRoZSBCRVIuDQpZb3UgY2FuIHJlcG9y
dCB0aGUgcmF3IFNRSSBsZXZlbCBhbmQgdXNlcnMgd291bGQgaGF2ZSB0byBsb29rIHVwIHdoYXQg
aXQgbWVhbnMgaW4gdGhlIHJlc3BlY3RpdmUgZGF0YSBzaGVldC4gVGhlcmUgaXMgbm8gZ3VhcmFu
dGVlZCByZWxhdGlvbiBiZXR3ZWVuIFNRSSBsZXZlbHMgb2YgZGlmZmVyZW50IGRldmljZXMsIGku
ZS4gU1FJIDUgY2FuIGhhdmUgbG93ZXIgQkVSIHRoYW4gU1FJIDYgb24gYW5vdGhlciBkZXZpY2Uu
DQpBbHRlcm5hdGl2ZWx5LCB5b3UgY291bGQgcmVwb3J0IEJFUiA8IHggZm9yIHRoZSBkaWZmZXJl
bnQgU1FJIGxldmVscy4gSG93ZXZlciwgdGhpcyByZXF1aXJlcyB0aGUgaW5mb3JtYXRpb24gdG8g
YmUgYXZhaWxhYmxlLiBXaGlsZSBJIGNvdWxkIHByb3ZpZGUgdGhlc2UgZm9yIE5YUCwgaXQgbWln
aHQgbm90IGJlIGVhc2lseSBhdmFpbGFibGUgZm9yIG90aGVyIHZlbmRvcnMuDQpJZiByZXBvcnRp
bmcgcmF3IFNRSSwgYXQgbGVhc3QgdGhlIFNRSSBsZXZlbCBmb3IgQkVSPDEwXi0xMCBzaG91bGQg
YmUgcHJlc2VudGVkIHRvIGdpdmUgYW55IG1lYW5pbmcgdG8gdGhlIHZhbHVlLg0KDQpSZWdhcmRz
LA0KDQpDaHJpc3RpYW4NCg==
