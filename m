Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15716C433
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 03:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbfGRBYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 21:24:07 -0400
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:47104
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727487AbfGRBYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 21:24:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iuu0P3Gadypefc/bSXSBNwOApSKthhd27xMi5Ums1wuCZZ2+PwTwErGhf+lf4Vlz5gRK/gVdoaiHUTiFKfV+AzC9G5iNbYSQ5SJqLWUFkGWJ0YwbNU51aefAMtDVPeizs2Laeb4cT1zKPjKluU/GZg997/tiv/NrfXdcQkKRdImFx189+/nZTZDwDTBhKvQAfDrPd3HaOM/McFmqwU6dXQ/P2reyWxxnOFue1w+eKi51r/rosH1dMWoa8/3Ojrds13kpoICNdiYDV0wSpBt+YLwSql71Llez1W3FmCKbgwOy2BBbXYOgsJ4+Zb5HdViddWAzCBFuFTHl5dpKlicDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKC9nK/Vgxs9ifL74pIat5i3F8SBZYDSy/Og/BwaoNo=;
 b=j9pvT9LdxinyzLuZd+X+fjgkkiW6anJ+GEPcUn94ptZwHwMjux+K1rIMbY/0nG9QuNW7u449+VLpJMq2bYrjENlsx1OBjgZoL5O0DMtrL9FTedq5l6eR+MhTHW2XsTJNrOhr+zTYh/s8qTIQI+V46ODOPRK3SOJPMoUVus7n5rk2vKGdScg0b2IEtZjJTd1fK5VB5FenebaoK9hB7fBlrTqS3WJbu4ZnTUaf1/Kesx9MDkbGXXpnPV88k3p1qEotdSyxjALNV62hCFw3vwDyHTbFtI64BehYuDdeeLTc+hQEA8rWTtoO8H86IsQVMW2CncZA+UTnU6813qMTTjih+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKC9nK/Vgxs9ifL74pIat5i3F8SBZYDSy/Og/BwaoNo=;
 b=R3PXIcYFlZvH1tbG5E8Uvtiy74SUXFRrBUPgYE7Bh1wV/iaVH0b0skR9IN/f/3E+rKcCkxHMGp9PaJNgf5iAYSUKeqIxwwD7wLpCAR+SIUm9sLvQxOBtILS6fyTz4vOk7nHZV3pAkdRaVBB3Ha8EQvgrPTRLkWeAJzCqhEarRK8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2704.eurprd04.prod.outlook.com (10.175.23.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Thu, 18 Jul 2019 01:24:03 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c539:7bdc:7eea:2a52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c539:7bdc:7eea:2a52%7]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 01:24:03 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1] net: fec: optionally reset PHY via a
 reset-controller
Thread-Topic: [EXT] [PATCH v1] net: fec: optionally reset PHY via a
 reset-controller
Thread-Index: AQHVO1EEL3ng1jsYe0KS/0rCZTBO1KbMdjtAgADFVICAAMwi4IAAvYOAgADSo7A=
Date:   Thu, 18 Jul 2019 01:24:02 +0000
Message-ID: <VI1PR0402MB360031575769A5AAC07FEDDDFFC80@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20190715210512.15823-1-TheSven73@gmail.com>
 <VI1PR0402MB36009E99D7361583702B84DDFFCE0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAGngYiUb5==QSM1-oa4bSeqhGyoaTw_dWjygLo=0X60eX=wQhQ@mail.gmail.com>
 <VI1PR0402MB36009A9893832F89BB932E09FFC90@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAGngYiU7B4uuqSAawNE6RFsjGPzbj5gzK9S299H+Qy+CWFjaAg@mail.gmail.com>
In-Reply-To: <CAGngYiU7B4uuqSAawNE6RFsjGPzbj5gzK9S299H+Qy+CWFjaAg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05d2d788-6c54-435d-81fb-08d70b1e9e71
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2704;
x-ms-traffictypediagnostic: VI1PR0402MB2704:
x-microsoft-antispam-prvs: <VI1PR0402MB27041C332FEC81E24801EADFFFC80@VI1PR0402MB2704.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(199004)(189003)(6246003)(74316002)(53936002)(7736002)(486006)(9686003)(11346002)(476003)(6916009)(229853002)(446003)(256004)(14444005)(81156014)(26005)(52536014)(5660300002)(66946007)(64756008)(66476007)(66446008)(76116006)(8936002)(305945005)(8676002)(66556008)(99286004)(86362001)(55016002)(4326008)(102836004)(33656002)(76176011)(316002)(7696005)(25786009)(81166006)(53546011)(71190400001)(71200400001)(1411001)(3846002)(6116002)(2906002)(186003)(6436002)(4744005)(478600001)(14454004)(68736007)(66066001)(6506007)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2704;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MkNy1ORbj1O2t8f9vLnE1LZDHq+8YJEkDRFcR4k2s7iBVIoOonajGAAbvBUnraUFMRLrWfsmEWTYobDpAwuuMZ3+RiWHrNHqH7rum/lmPnxfcuzwCTiS2O5p5a49+rLgGIUyVDNsedzeEW28uv6xEcTeeAFGwSaIsA5AGIzj7JkTOfunBSHjspJq7lpT5MN6wK1QYQmUsvPb47AnvG1BrfF31LZ1VpYDtaZRpVHCcOh0wJCiQveWiZPfyo0cLNGoqpumBnv3vK8jDgk5hFuXb2/329WBaLvKoWg13TQ3hrmI9OAlN33547id3ilLUT4jfwd+FpwMkUmo7REvHCKq16Rg+LUiY0ZAftUSugP7uFWaQlkWH+OjSUZo8RAbOYJ4OzjqIDr1VfeFAHfzjGy/3fyHQsU8lmcOGw9dQiywmQ0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d2d788-6c54-435d-81fb-08d70b1e9e71
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 01:24:03.0448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fugang.duan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2704
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+IFNlbnQ6IFdlZG5l
c2RheSwgSnVseSAxNywgMjAxOSA4OjQ4IFBNDQo+IE9uIFR1ZSwgSnVsIDE2LCAyMDE5IGF0IDk6
MzIgUE0gQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPiB3cm90ZToNCj4gPg0KPiA+IFll
cywgc28gdGhlIG9sZCBsZWdhY3kgY29kZSBpcyBrZXB0IHRoZXJlLiBCdXQgaXQgaXMgYmV0dGVy
IHRvIGNsZWFuDQo+ID4gdXAgYWxsIGlmIHRoZXJlIGhhdmUgZW5vdWdoIGJvYXJkcyB0byB2ZXJp
ZnkgdGhlbS4NCj4gDQo+IFdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gcHJpbnQgYSB3YXJuaW5nIG1l
c3NhZ2UgdG8gdGhlIGxvZyB3aGVuZXZlcg0KPiBzb21lb25lIHRyaWVzIHRvIHVzZSB0aGUgbGVn
YWN5IHBoeSByZXNldCBvbiB0aGUgZmVjPw0KDQpJdCBpcyBmZWFzaWJsZSwganVzdCBhcyByZW1p
bmRlciB0byBkcm9wIHN1Y2ggdXNhZ2UuDQo=
