Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8C168C2A
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 04:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgBVD0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 22:26:45 -0500
Received: from mail-eopbgr30045.outbound.protection.outlook.com ([40.107.3.45]:50085
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726328AbgBVD0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 22:26:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLHyXLcfTIjTHhQVuWj66Yr6QzJcjOUPxQQ62J87OSMEWyIPfHP9CsXy0uz/pX7ofJWHAM9L5y4nyDojom2CxlgH58Ubz5aMoDAuBHSrBpXEcMBlbQCrwKFs18OvCLffkSl+YjqBDTxO/9Fi98foX8YcrQK33qZEyVyCl2HoKBw1vgFXnudv9mvd0ug13eCNm59U/nwVOiOj3pyz0s7EA7GDdECzCCZRPv9gj4MiGNu3tgDnS0zJ29rIHDLD6NY3iviS56ty53TvkHDx+YJh9rLXPao4gio1sh78XR5LJMAV1xKyK5TpV09g3iaI+0gZ/7bD81bQszPb8ISLGJ0Y2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WYI3q23dBI6TLiSVnVgutFeEI2+PumXXRGYyTHAk+4=;
 b=WvMT5wqcImYFph/gZfpmIStWgAaPZ7miCNlDcPQlu3STiRsHQ23uwkiFbF8fYk3rVIxbqbKMmmPNFRwsyjR+tdNWQE36uDU30MJvIw0IfgJ5mbRmiAuu4P+Rifqtnj2GCf4Z/MGSPdfnEtEE0XS2xzXs0ydiVLOaQd7j8PfVtXyIg8UVxYLNbAFOxtSxUbhYjdHfspqs0gFkHRIo5dWAuc5Cw1BfNu6g+dYTYoLwodqYXbt1jG/PYD3rkfb4VlSsBxKbZNTga/3HlcPuXvbF7A7ncGxlxR6qIihFsMVAN77eiK7yg0VoU4rIc4E+QrxlS4iHx7fCGWgiDsPBtTTCrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WYI3q23dBI6TLiSVnVgutFeEI2+PumXXRGYyTHAk+4=;
 b=i/5b8GHbrWkPM7A7S4cl3cb38yQaqTwLwTwFE403bdZxIvOd3H/qB53+yH7HOPjlClOoDCcGcTswYpxAYoNXmvmMo1oRQXk+aoMAekNqwbPjix00zMsQosxFKNL1qvJWq0wSd49kRnCpAt/N5E0xm8jttQz0eJdXn8SrpPAr3Ow=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6384.eurprd04.prod.outlook.com (20.179.235.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Sat, 22 Feb 2020 03:26:40 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2729.033; Sat, 22 Feb 2020
 03:26:40 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Topic: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiagmtdqAgABRRQA=
Date:   Sat, 22 Feb 2020 03:26:40 +0000
Message-ID: <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87a75br4ze.fsf@linux.intel.com>
In-Reply-To: <87a75br4ze.fsf@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 512f46e2-57d0-4e4a-c6f3-08d7b7470869
x-ms-traffictypediagnostic: VE1PR04MB6384:|VE1PR04MB6384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6384C859876217992E13064F92EE0@VE1PR04MB6384.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03218BFD9F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(189003)(199004)(64756008)(66476007)(66946007)(9686003)(66446008)(52536014)(5660300002)(66556008)(478600001)(76116006)(44832011)(7696005)(8676002)(6506007)(53546011)(81156014)(81166006)(8936002)(26005)(186003)(54906003)(110136005)(316002)(55016002)(2906002)(86362001)(71200400001)(4326008)(7416002)(33656002)(921003)(21314003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6384;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3iD/O0XAhXfFB4aNjrkNMgzBHhDP8G97/xTBCSc7tibUSA2KEUI96Uduhu2CBskDAUbi1IYqu/bdvFLnADvQ/G8Fqd8umZpeyWmtPzVWJFDKWIXcSefq+bDZ+xX6nsTMM2DPAi51U7svs117+Jb79MS72WnzVmSFND2wQs2QmmkithEwt9gghQ80VhmyU4jh1aH9AKSwSCKubXMPycvUFn5tU1OmJwro0i2vqy1BkgsuGptjVqvDIv1pqxH/dQOePAUBmMk7WvABs0Kejf2F0UBEEVwbCqPYKo7Qpc7O6mWk+Lbf/t+3XQ0u/rWKAvrywH1gthtCvxwzaUa1z+tW3n4gZQEKY0tT/kiRBgglAH9XrNcniHO9/p66gSYuxca/WT3DIlK5HVCbHIPHUfvybRtOeeXJQselPSa6LXwDsvzzpPfejgiSKpQJ+jWxrOVfzpKMNFprpsENKnpWcUggJNKtGEkw4ii2fHvgFMN/V4UF58hBSTdOZ2Z4jwSYGjXOtpaDBTXP8THFL6gdot4cGQ==
x-ms-exchange-antispam-messagedata: /InajqBcHjjVeEuULe4Dz8pAWsIXCJkYg4hY0Pr1BeUtis7kqa4OQzQjL7xM00arSm2oOHnx1AXYda9snStHylHsfRXKbBFKSssik9vSVG/5mFTGo+Njej7DzZU71goPIGV4T+N+OQow57uJaD2jmA==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 512f46e2-57d0-4e4a-c6f3-08d7b7470869
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2020 03:26:40.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s5IjheQq7QiuxIsP7SGYFXTRUX48iwp8Xllq3oSeDGfV8B7V0/WD0v4unJY6E8dV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMsDQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiBGcm9tOiBWaW5pY2l1cyBDb3N0YSBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwu
Y29tPg0KPiBTZW50OiAyMDIwxOoy1MIyMsjVIDU6NDQNCj4gVG86IFBvIExpdSA8cG8ubGl1QG54
cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBoYXVrZS5tZWhydGVuc0BpbnRlbC5jb207
IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOyBhbGxpc29uQGxvaHV0b2submV0Ow0KPiB0Z2x4
QGxpbnV0cm9uaXguZGU7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBzYWVlZG1AbWVsbGFub3guY29t
Ow0KPiBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207IGFsZXhhbmRydS5hcmRl
bGVhbkBhbmFsb2cuY29tOw0KPiBqaXJpQG1lbGxhbm94LmNvbTsgYXlhbEBtZWxsYW5veC5jb207
IHBhYmxvQG5ldGZpbHRlci5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBzaW1vbi5ob3JtYW5AbmV0cm9ub21lLmNvbTsg
Q2xhdWRpdSBNYW5vaWwNCj4gPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRl
YW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsNCj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxl
eGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgWGlhb2xpYW5nIFlhbmcNCj4gPHhpYW9saWFuZy55
YW5nXzFAbnhwLmNvbT47IFJveSBaYW5nIDxyb3kuemFuZ0BueHAuY29tPjsgTWluZ2thaSBIdQ0K
PiA8bWluZ2thaS5odUBueHAuY29tPjsgSmVycnkgSHVhbmcgPGplcnJ5Lmh1YW5nQG54cC5jb20+
OyBMZW8gTGkNCj4gPGxlb3lhbmcubGlAbnhwLmNvbT47IFBvIExpdSA8cG8ubGl1QG54cC5jb20+
DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbdjEsbmV0LW5leHQsIDEvMl0gZXRodG9vbDogYWRkIHNl
dHRpbmcgZnJhbWUgcHJlZW1wdGlvbiBvZg0KPiB0cmFmZmljIGNsYXNzZXMNCj4gDQo+IENhdXRp
b246IEVYVCBFbWFpbA0KPiANCj4gSGksDQo+IA0KPiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPiB3
cml0ZXM6DQo+IA0KPiA+IElFRUUgU3RkIDgwMi4xUWJ1IHN0YW5kYXJkIGRlZmluZWQgdGhlIGZy
YW1lIHByZWVtcHRpb24gb2YgcG9ydA0KPiA+IHRyYWZmaWMgY2xhc3Nlcy4gVGhpcyBwYXRjaCBp
bnRyb2R1Y2UgYSBtZXRob2QgdG8gc2V0IHRyYWZmaWMgY2xhc3Nlcw0KPiA+IHByZWVtcHRpb24u
IEFkZCBhIHBhcmFtZXRlciAncHJlZW1wdGlvbicgaW4gc3RydWN0DQo+ID4gZXRodG9vbF9saW5r
X3NldHRpbmdzLiBUaGUgdmFsdWUgd2lsbCBiZSB0cmFuc2xhdGVkIHRvIGEgYmluYXJ5LCBlYWNo
DQo+ID4gYml0IHJlcHJlc2VudCBhIHRyYWZmaWMgY2xhc3MuIEJpdCAiMSIgbWVhbnMgcHJlZW1w
dGFibGUgdHJhZmZpYw0KPiA+IGNsYXNzLiBCaXQgIjAiIG1lYW5zIGV4cHJlc3MgdHJhZmZpYyBj
bGFzcy4gIE1TQiByZXByZXNlbnQgaGlnaCBudW1iZXINCj4gPiB0cmFmZmljIGNsYXNzLg0KPiA+
DQo+ID4gSWYgaGFyZHdhcmUgc3VwcG9ydCB0aGUgZnJhbWUgcHJlZW1wdGlvbiwgZHJpdmVyIGNv
dWxkIHNldCB0aGUNCj4gPiBldGhlcm5ldCBkZXZpY2Ugd2l0aCBod19mZWF0dXJlcyBhbmQgZmVh
dHVyZXMgd2l0aCBORVRJRl9GX1BSRUVNUFRJT04NCj4gPiB3aGVuIGluaXRpYWxpemluZyB0aGUg
cG9ydCBkcml2ZXIuDQo+ID4NCj4gPiBVc2VyIGNhbiBjaGVjayB0aGUgZmVhdHVyZSAndHgtcHJl
ZW1wdGlvbicgYnkgY29tbWFuZCAnZXRodG9vbCAtaw0KPiA+IGRldm5hbWUnLiBJZiBoYXJld2Fy
ZSBzZXQgcHJlZW1wdGlvbiBmZWF0dXJlLiBUaGUgcHJvcGVydHkgd291bGQgYmUgYQ0KPiA+IGZp
eGVkIHZhbHVlICdvbicgaWYgaGFyZHdhcmUgc3VwcG9ydCB0aGUgZnJhbWUgcHJlZW1wdGlvbi4N
Cj4gPiBGZWF0dXJlIHdvdWxkIHNob3cgYSBmaXhlZCB2YWx1ZSAnb2ZmJyBpZiBoYXJkd2FyZSBk
b24ndCBzdXBwb3J0IHRoZQ0KPiA+IGZyYW1lIHByZWVtcHRpb24uDQo+ID4NCj4gPiBDb21tYW5k
ICdldGh0b29sIGRldm5hbWUnIGFuZCAnZXRodG9vbCAtcyBkZXZuYW1lIHByZWVtcHRpb24gTicN
Cj4gPiB3b3VsZCBzaG93L3NldCB3aGljaCB0cmFmZmljIGNsYXNzZXMgYXJlIGZyYW1lIHByZWVt
cHRhYmxlLg0KPiA+DQo+ID4gUG9ydCBkcml2ZXIgd291bGQgaW1wbGVtZW50IHRoZSBmcmFtZSBw
cmVlbXB0aW9uIGluIHRoZSBmdW5jdGlvbg0KPiA+IGdldF9saW5rX2tzZXR0aW5ncygpIGFuZCBz
ZXRfbGlua19rc2V0dGluZ3MoKSBpbiB0aGUgc3RydWN0IGV0aHRvb2xfb3BzLg0KPiA+DQo+IA0K
PiBBbnkgdXBkYXRlcyBvbiB0aGlzIHNlcmllcz8gSWYgeW91IHRoaW5rIHRoYXQgdGhlcmUncyBz
b21ldGhpbmcgdGhhdCBJIGNvdWxkIGhlbHAsDQo+IGp1c3QgdGVsbC4NCg0KU29ycnkgZm9yIHRo
ZSBsb25nIHRpbWUgbm90IGludm9sdmUgdGhlIGRpc2N1c3Npb24uIEkgYW0gZm9jdXMgb24gb3Ro
ZXIgdHNuIGNvZGUgZm9yIHRjIGZsb3dlci4NCklmIHlvdSBjYW4gdGFrZSBtb3JlIGFib3V0IHRo
aXMgcHJlZW1wdGlvbiBzZXJpYWwsIHRoYXQgd291bGQgYmUgZ29vZC4NCg0KSSBzdW1tYXJ5IHNv
bWUgc3VnZ2VzdGlvbnMgZnJvbSBNYXJhbGkgS2FyaWNoZXJpIGFuZCBJdmFuIEtob3Jub256aHVr
IGFuZCBieSB5b3UgYW5kIGFsc28gb3RoZXJzOg0KLSBBZGQgY29uZmlnIHRoZSBmcmFnbWVudCBz
aXplLCBob2xkIGFkdmFuY2UsIHJlbGVhc2UgYWR2YW5jZSBhbmQgZmxhZ3M7DQogICAgTXkgY29t
bWVudHMgYWJvdXQgdGhlIGZyYWdtZW50IHNpemUgaXMgaW4gdGhlIFFidSBzcGVjIGxpbWl0IHRo
ZSBmcmFnbWVudCBzaXplICIgdGhlIG1pbmltdW0gbm9uLWZpbmFsIGZyYWdtZW50IHNpemUgaXMg
NjQsDQoxMjgsIDE5Miwgb3IgMjU2IG9jdGV0cyAiIHRoaXMgc2V0dGluZyB3b3VsZCBhZmZlY3Qg
dGhlIGd1YXJkYmFuZCBzZXR0aW5nIGZvciBRYnYuIEJ1dCB0aGUgZXRodG9vbCBzZXR0aW5nIGNv
dWxkIG5vdCBpbnZvbHZlIHRoaXMgaXNzdWVzIGJ1dCBieSB0aGUgdGFwcmlvIHNpZGUuDQotICIg
RnVydGhlcm1vcmUsIHRoaXMgc2V0dGluZyBjb3VsZCBiZSBleHRlbmQgZm9yIGEgc2VyaWFsIHNl
dHRpbmcgZm9yIG1hYyBhbmQgdHJhZmZpYyBjbGFzcy4iICAiQmV0dGVyIG5vdCB0byB1c2luZyB0
aGUgdHJhZmZpYyBjbGFzcyBjb25jZXB0LiINCiAgIENvdWxkIGFkZGluZyBhIHNlcmlhbCBzZXR0
aW5nIGJ5ICJldGh0b29sIC0tcHJlZW1wdGlvbiB4eHgiIG9yIG90aGVyIG5hbWUuIEkgZG9uJyB0
IHRoaW5rIGl0IGlzIGdvb2QgdG8gaW52b2x2ZSBpbiB0aGUgcXVldWUgY29udHJvbCBzaW5jZSBx
dWV1ZXMgbnVtYmVyIG1heSBiaWdnZXIgdGhhbiB0aGUgVEMgbnVtYmVyLg0KLSBUaGUgZXRodG9v
bCBpcyB0aGUgYmV0dGVyIGNob2ljZSB0byBjb25maWd1cmUgdGhlIHByZWVtcHRpb24NCiAgSSBh
Z3JlZS4NCg0KVGhhbmtzo6ENCj4gDQo+IA0KPiBDaGVlcnMsDQo+IC0tDQo+IFZpbmljaXVzDQo=
