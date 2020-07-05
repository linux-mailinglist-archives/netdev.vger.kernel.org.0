Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0297214D34
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 16:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgGEOpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 10:45:09 -0400
Received: from mail-eopbgr130055.outbound.protection.outlook.com ([40.107.13.55]:6116
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726747AbgGEOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 10:45:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0xTMnR3epr5FCs8gHyuYyqqx096EaJ3ulJTlYLlIrVkndUP/ifNB4WFnjBCsYB0bzXOP/7+k9OweY3Kleu+ykGGOzGzsYsxP0KONNH5M2ugwhF6yy3v4ET5eTsn9RwUWvFAYWHlkagjWRjQiFI7jEFG1VpBnsLWDMHswGOuxbpiDtNxRY7o4LIz0L6uqYvG6SO7yNoOpKzzcEiymOsUxWttrr0Vcww3UkmAlt2PocFL4AjZ7NsvJG1BesFUwxsSq2YOKWj0K2mWdCJwGGig0qhMfPhEcLDbLsapFHpIFx/BuRlXp6Urz6dHnHCuCd4PflRl2mp9W8cyNHXBEYbbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iz/phFwq43MMxpKtdiuafRnMPxlJQBjtqPOQhYIWbH8=;
 b=XVpRDwq9hj61EmZCyrZ5bjE40+qW14Lp1x3CS99dvXTSFjQ5ONQi5FFX7S0EdfskyQBSFkMfOv5wXLbu/twFTGEu+GfDxcXfmnM8mDRXRhBnFLwPQHJkb90vP5KPV1GATrgomdKMsycnQVsb/sJIGmApcgmuOBRsmFgs6rtXPK0DuL1O3OP3S5+Z8wj9sdnyxOGWXII6D/qzIsqbnXGr07KMAJi5h6jNevO+F27CqlrcGbAUmkJz/LVIJyUzEVvjtzdSmjXIaVFWCSbRd8rm5Z4Xg9bqQU82zwqY3iLzAC3xh5aVUqx5eFUJbHxe7naUsiJxVxwcSMrLJHrxvJz23g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iz/phFwq43MMxpKtdiuafRnMPxlJQBjtqPOQhYIWbH8=;
 b=c8sPHhxFSQNn9tZw0Xt0fTtx2gr7G8e0X6ed+5um3T3nQxyv5Qq4VoKWl2R+QQTc5v+XqmL27lo2C34pt5cLN+UJlO6ueRD/N4rcPTKmXdY97GDdb5VMw78uMqhCqjRpfco0UqDGXdd9htRuxpmdeO0+a/Yxok1bY/tRZ6texEM=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB5062.eurprd04.prod.outlook.com
 (2603:10a6:20b:11::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Sun, 5 Jul
 2020 14:45:03 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 14:45:03 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
CC:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Topic: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Index: AQHWUMBIY0/PmQIJzUKZXhlXPuzWDKj3d74AgAGaMEA=
Date:   Sun, 5 Jul 2020 14:45:02 +0000
Message-ID: <AM6PR0402MB360781DA3F738C2DF445E821FF680@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200702175352.19223-1-TheSven73@gmail.com>
 <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
In-Reply-To: <CAGngYiXGXDqCZeJme026uz5FjU56UojmQFFiJ5_CZ_AywdQiEw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.4.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e7efb26-a777-45bc-8af6-08d820f20034
x-ms-traffictypediagnostic: AM6PR04MB5062:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5062530C1E60E87253EF2DD5FF680@AM6PR04MB5062.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 045584D28C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XtnfNpoz9VfktgUHJ9GraROv+zMM1KcRLRDt0sFYBy5uXqQ7/TexpxALFi7NdMh91sXjilDkbjnD72ydmt+U3kXGQBJPYafCDfIJJ37Nl1qMccX2TVUO7J3rbvDyyGHcA6p9Cdyjex3fHPvbFLN8on8PqApSVXLCwJXiG/w5TzH2s67M3NLx4BbsE4AC03ZE3xtnltGbrXTiRzqmWVBGE91fgWXQo3zTn0fMjWY2SJxQvWjzvcpe9To7vQ87WKhD5spDsDPjTmJ+e8zVhqzZZeebUbMpttrUgHDrXmvqGiHqgT3k0Wa7kcbNhfu9xeZ5hJWJGUwG6zm+C9+lKtsY2FJCOXQoutO1HJAIsOK7Km9htgkejN/xWeRVOTY4zEbS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(136003)(366004)(376002)(346002)(4326008)(54906003)(110136005)(52536014)(2906002)(316002)(66476007)(86362001)(7416002)(66446008)(66556008)(66946007)(71200400001)(76116006)(64756008)(55016002)(33656002)(9686003)(8936002)(5660300002)(186003)(53546011)(6506007)(83380400001)(26005)(8676002)(7696005)(478600001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qfXiU1zxmhxM8+AxyzO+ZSQ6MmgYqkV4fP8Spat8MNAP9AayBtYuyEKtAJgeTsvm0soZd1b2oVgiovb/yUYdSKLcL4kfQgXs1EIyNp4rOvS29r4itwlWwbQR2d5ijfYE8qFxL66JemmtmriVauR+jQ+0joBx1+Y4OhSEhcuwoTxX9eFyjYLC2XQCaAKxge9SOd8Y8CUVm4D5soY0kvMWX/VUPa52cxGMupcW6dJ1L4PMpyEJOoRwvZaU5hiJAdndlqeTIXUoRerxWYFj7FxnX7yCtyjb05bRqGq6V++Vxu9dimLrcwaZ7VeBnHCTZHuiACB/L02Sv7QbF6BS2uwzqjAAjWAFi3SWJinAQWfP1oRpXKEW6QIXOkfoaMMsvSIC0AZZvNUV92UDHKc9a1d+ly4+vR1p8HcBHifPGSkf/UqSG/fedZ8avshSwnbOFAOSkzapdhovCjpqrg253YOIiy+abHc8jD5ZurItOHxExqM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e7efb26-a777-45bc-8af6-08d820f20034
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2020 14:45:02.9833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yN4j8Dde77IdX8cm/X7P3G+4gHrK3fqKubzSe2ZwptrPcNWdAXcd2Fp8atSKZDuxJMWv2jAAgQf35nPVvvX5Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+DQo+IEhpIEZhYmlv
LCBBbmR5LA0KPiANCj4gT24gVGh1LCBKdWwgMiwgMjAyMCBhdCA2OjI5IFBNIEZhYmlvIEVzdGV2
YW0gPGZlc3RldmFtQGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBXaXRoIHRoZSBkZXZpY2Ug
dHJlZSBhcHByb2FjaCwgSSB0aGluayB0aGF0IGEgYmV0dGVyIHBsYWNlIHRvIHRvdWNoDQo+ID4g
R1BSNSB3b3VsZCBiZSBpbnNpZGUgdGhlIGZlYyBkcml2ZXIuDQo+ID4NCj4gDQo+IEFyZSB3ZSAx
MDAlIHN1cmUgdGhpcyBpcyB0aGUgYmVzdCB3YXkgZm9yd2FyZCwgdGhvdWdoPw0KPiANCj4gQWxs
IHRoZSBGRUMgZHJpdmVyIHNob3VsZCBjYXJlIGFib3V0IGlzIHRoZSBGRUMgbG9naWMgYmxvY2sg
aW5zaWRlIHRoZSBTb0MuIEl0DQo+IHNob3VsZCBub3QgY29uY2VybiBpdHNlbGYgd2l0aCB0aGUg
d2F5IGEgU29DIGhhcHBlbnMgdG8gYnJpbmcgYSBjbG9jayAoUFRQDQo+IGNsb2NrKSB0byB0aGUg
aW5wdXQgb2YgdGhlIEZFQyBsb2dpYyBibG9jayAtIHRoYXQgaXMgcHVyZWx5IGEgU29DIGltcGxl
bWVudGF0aW9uDQo+IGRldGFpbC4NCg0KSSBhbHNvIGFncmVlIHdpdGggdGhhdCByZWxhdGVzIHRv
IFNPQyBpbnRlZ3JhdGlvbi4gDQo+IA0KPiBJdCBtYWtlcyBzZW5zZSB0byBhZGQgZnNsLHN0b3At
bW9kZSAoPSBhIEdQUiBiaXQpIHRvIHRoZSBGRUMgZHJpdmVyLCBhcyB0aGlzIGJpdA0KPiBpcyBh
IGxvZ2ljIGlucHV0IHRvIHRoZSBGRUMgYmxvY2ssIHdoaWNoIHRoZSBkcml2ZXIgbmVlZHMgdG8g
ZHluYW1pY2FsbHkgZmxpcC4NCj4gDQo+IEJ1dCB0aGUgUFRQIGNsb2NrIGlzIGRpZmZlcmVudCwg
YmVjYXVzZSBpdCdzIHN0YXRpY2FsbHkgcm91dGVkIGJ5IHRoZSBTb0MuDQo+IA0KPiBNYXliZSB0
aGlzIHByb2JsZW0gbmVlZHMgYSBjbG9jayByb3V0aW5nIHNvbHV0aW9uPw0KPiBJc24ndCB0aGVy
ZSBhbiBpbXg2cSBwbHVzIGNsb2NrIG11eCB3ZSdyZSBub3QgbW9kZWxsaW5nPw0KPiANCj4gICBl
bmV0X3JlZi1vLS0tLS0tPmV4dD4tLS1wYWRfY2xrLS18IFwNCj4gICAgICAgICAgICB8ICAgICAg
ICAgICAgICAgICAgICAgICB8TSB8LS0tLWZlY19wdHBfY2xrDQo+ICAgICAgICAgICAgby0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tfF8vDQo+IA0KPiBXaGVyZSBNID0gbXV4IGNvbnRyb2xsZWQgYnkg
R1BSNVs5XQ0KPiANCj4gVGhlIGlzc3VlIGhlcmUgaXMgdGhhdCBwYWRfY2xrIGlzIHJvdXRlZCBl
eHRlcm5hbGx5LCBzbyBpdHMgcGFyZW50IGNvdWxkIGJlIGFueQ0KPiBpbnRlcm5hbCBvciBleHRl
cm5hbCBjbG9jay4gSSBoYXZlIG5vIGlkZWEgaG93IHRvIG1vZGVsIHRoaXMgaW4gdGhlIGNsb2Nr
DQo+IGZyYW1ld29yay4NCkRvbid0IGNvbnNpZGVyIGl0IGNvbXBsZXgsIEdQUjVbOV0ganVzdCBz
ZWxlY3QgdGhlIHJnbWlpIGd0eCBzb3VyY2UgZnJvbSBQQUQgb3IgaW50ZXJuYWwNCkxpa2XvvJoN
CkdQUjVbOV0gaXMgY2xlYXJlZDogUEFEIC0+IE1BQyBndHgNCkdQUjVbOV0gaXMgc2V0OiBQbGxf
ZW5ldCAtPiBNQUMgZ3R4DQpBcyB5b3Ugc2FpZCwgcmVnaXN0ZXIgb25lIGNsb2NrIG11eCBmb3Ig
dGhlIHNlbGVjdGlvbiwgYXNzaWduIHRoZSBjbG9jayBwYXJlbnQgYnkgYm9hcmQgZHRzDQpmaWxl
LCBidXQgbm93IGN1cnJlbnQgY2xvY2sgZHJpdmVyIGRvZXNuJ3Qgc3VwcG9ydCBHUFIgY2xvY2su
IA0K
