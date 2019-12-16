Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C0911FF1C
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 08:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfLPHoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 02:44:20 -0500
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:49263
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbfLPHoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 02:44:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URr7DYQRBBYIj6FycYe3ciNfWqLlX98e1KCIC6TnAuO3kfU+eCeDzg0Lt64Mgb3bdNDbJ4x2TI5rolpbiI4eSfexswjH9b8Ih9TsI7OzgeOxRb3Pd8sxP7oeGG0x08d2SE07ZiO0zTqt2oLESl6WGvEDfjyYTox7dwOf2edtj84Fx/jyArDHFTIsp1xc+WCmwq4ydsiQY0lm6tY0kMhiUp2k6lkOasjhYWHzMjBh4mFooOI07eZdviXw95TiLnOqq2SMahRkOS4i97jkZ+RPqm1/Sv30MVSEeMU8el6ZPoAf9iai2nM3dTDtbf8wzEoDLAuoohywF8dIG/LSWkShJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrrruYbnP9ocjL1YN2lB7hB1mc0Zkw69qZ2+DNFdmYU=;
 b=V17eT78PLgVVGtIG/TDcJR3XNJFbfngVcGMERJVFNQn+zmzOqdHGWHgC2fuMkA7JPFjrtLgurs4CfcyHXj8hzewnTDpHbSm1Q9FlHpp/yycdl56V474K/fOH/yZAMElYojfC9OdCszGASKWhfILQxTZ4vswG0+j84hLhglMGya4RZY5+HVfE/+nvva/0i5C0YoqoGh94wCIzWZn2XGT8V/Vi5NCLVJL5TNYrkh3bRklTWuLOCqjaC0kWUufDX4UVJlOrbsUNX4GwvjIJmYxQbBYE9w5isfEGz7H7735SXnUEZHGmurP2Y4m5ayKyAnxCNAj/3QN2Kgs3ldhDNaJQkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrrruYbnP9ocjL1YN2lB7hB1mc0Zkw69qZ2+DNFdmYU=;
 b=JXryyjqIksMLQquQBVoI7PB/FO+YogwohJfvoTjOvdaHz6xFyjx9Em/HqdaF2JArrKfqngzmE5m3gsWY71TNNRqDualHhGfn+7mjJ/Gy7EvGpgS2MrXz/pRfryqhrznVptr4dBWbuA/qYl0Q1sb/T5yXS2lQ8wL2V5+i7HRXdsA=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6624.eurprd04.prod.outlook.com (20.179.234.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 07:43:58 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7054:50dc:f2e6:2348]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::7054:50dc:f2e6:2348%5]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 07:43:58 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Andre Guedes <andre.guedes@linux.intel.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Topic: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiae0UhKAgAfLu0A=
Date:   Mon, 16 Dec 2019 07:43:58 +0000
Message-ID: <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <157603276975.18462.4638422874481955289@pipeline>
In-Reply-To: <157603276975.18462.4638422874481955289@pipeline>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 42a1c298-b373-4a29-6b03-08d781fbb61c
x-ms-traffictypediagnostic: VE1PR04MB6624:|VE1PR04MB6624:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6624FEA84B0A32C1D606FEAE92510@VE1PR04MB6624.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(13464003)(199004)(189003)(4326008)(86362001)(8936002)(71200400001)(8676002)(81156014)(81166006)(55016002)(33656002)(2906002)(54906003)(5660300002)(478600001)(52536014)(7696005)(4001150100001)(7416002)(110136005)(53546011)(6506007)(26005)(76116006)(66946007)(186003)(66446008)(64756008)(66556008)(66476007)(44832011)(316002)(9686003)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6624;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: msBjk1zBlh/L5vfNcXpxdz6Qq19KonEcdgzP03QS6C5ClVfOVIWNz6kUJvIttROisjQjVD7zWoXTcvtGEKHWLLJiC5xPJ/8jPoH7xVOZPq1h9fDH4a8B6Be3ETJTlPM3ozg1BpMLsvrHeACkbLWC1dUbWZTSp1uPORQ8k3ttQpEUAyHqVkR5TdmgwX3l1DQiPezWncnvApzR4sDqDjsnSho9MF9/s7QlaI2ami/w+Q66EyLndb31LSYU/MKwFG2hM/zWW/0fSvmKTin6JnFqweUl94/hv7djFNgss6VIZyzJkwjyv35kPPpFBh3epsWLzGIEPDocILuUZ8RFfeRawagv4EOYdOK/J2P8CI6+mRWmBtL8g7S0akSYgxzCRk2EoJBJkXafrSgbCCwV5Cu3rJXoUFEl4lQC1UTH8uyUA8g89R8F56Xc/0cLIiscEC57s1fItT3HpSlpjDQ/kdsTr5sCb82yDqvxufwJR11amiMb1PY93xdrsB79YwO8jA0hRFEl1x6bH45F4+DGv8CtWQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42a1c298-b373-4a29-6b03-08d781fbb61c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 07:43:58.7005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l22MxK2jA4esD87qLM3rdWaqiuPbfinNDz8jTmd3x2ebHpFk9u8yg/493r4N92Ua
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6624
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmUsDQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiBGcm9tOiBBbmRyZSBHdWVkZXMgPGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb20+DQo+
IFNlbnQ6IDIwMTnlubQxMuaciDEx5pelIDEwOjUzDQo+IFRvOiBhbGV4YW5kcnUuYXJkZWxlYW5A
YW5hbG9nLmNvbTsgYWxsaXNvbkBsb2h1dG9rLm5ldDsgYW5kcmV3QGx1bm4uY2g7DQo+IGF5YWxA
bWVsbGFub3guY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBmLmZhaW5lbGxpQGdtYWlsLmNvbTsN
Cj4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IGhhdWtlLm1laHJ0ZW5zQGludGVsLmNvbTsN
Cj4gaGthbGx3ZWl0MUBnbWFpbC5jb207IGppcmlAbWVsbGFub3guY29tOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBwYWJsb0BuZXRmaWx0
ZXIub3JnOyBzYWVlZG1AbWVsbGFub3guY29tOw0KPiB0Z2x4QGxpbnV0cm9uaXguZGU7IFBvIExp
dSA8cG8ubGl1QG54cC5jb20+DQo+IENjOiB2aW5pY2l1cy5nb21lc0BpbnRlbC5jb207IHNpbW9u
Lmhvcm1hbkBuZXRyb25vbWUuY29tOyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxA
bnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+Ow0KPiBB
bGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBYaWFvbGlh
bmcgWWFuZw0KPiA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgUm95IFphbmcgPHJveS56YW5n
QG54cC5jb20+OyBNaW5na2FpIEh1DQo+IDxtaW5na2FpLmh1QG54cC5jb20+OyBKZXJyeSBIdWFu
ZyA8amVycnkuaHVhbmdAbnhwLmNvbT47IExlbyBMaQ0KPiA8bGVveWFuZy5saUBueHAuY29tPjsg
UG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFt2MSxuZXQtbmV4
dCwgMS8yXSBldGh0b29sOiBhZGQgc2V0dGluZyBmcmFtZSBwcmVlbXB0aW9uIG9mDQo+IHRyYWZm
aWMgY2xhc3Nlcw0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBIaSBQbywNCj4gDQo+
IFF1b3RpbmcgUG8gTGl1ICgyMDE5LTExLTI3IDAxOjU5OjE4KQ0KPiA+IElFRUUgU3RkIDgwMi4x
UWJ1IHN0YW5kYXJkIGRlZmluZWQgdGhlIGZyYW1lIHByZWVtcHRpb24gb2YgcG9ydA0KPiA+IHRy
YWZmaWMgY2xhc3Nlcy4gVGhpcyBwYXRjaCBpbnRyb2R1Y2UgYSBtZXRob2QgdG8gc2V0IHRyYWZm
aWMgY2xhc3Nlcw0KPiA+IHByZWVtcHRpb24uIEFkZCBhIHBhcmFtZXRlciAncHJlZW1wdGlvbicg
aW4gc3RydWN0DQo+ID4gZXRodG9vbF9saW5rX3NldHRpbmdzLiBUaGUgdmFsdWUgd2lsbCBiZSB0
cmFuc2xhdGVkIHRvIGEgYmluYXJ5LCBlYWNoDQo+ID4gYml0IHJlcHJlc2VudCBhIHRyYWZmaWMg
Y2xhc3MuIEJpdCAiMSIgbWVhbnMgcHJlZW1wdGFibGUgdHJhZmZpYw0KPiA+IGNsYXNzLiBCaXQg
IjAiIG1lYW5zIGV4cHJlc3MgdHJhZmZpYyBjbGFzcy4gIE1TQiByZXByZXNlbnQgaGlnaCBudW1i
ZXINCj4gPiB0cmFmZmljIGNsYXNzLg0KPiA+DQo+ID4gSWYgaGFyZHdhcmUgc3VwcG9ydCB0aGUg
ZnJhbWUgcHJlZW1wdGlvbiwgZHJpdmVyIGNvdWxkIHNldCB0aGUNCj4gPiBldGhlcm5ldCBkZXZp
Y2Ugd2l0aCBod19mZWF0dXJlcyBhbmQgZmVhdHVyZXMgd2l0aCBORVRJRl9GX1BSRUVNUFRJT04N
Cj4gPiB3aGVuIGluaXRpYWxpemluZyB0aGUgcG9ydCBkcml2ZXIuDQo+ID4NCj4gPiBVc2VyIGNh
biBjaGVjayB0aGUgZmVhdHVyZSAndHgtcHJlZW1wdGlvbicgYnkgY29tbWFuZCAnZXRodG9vbCAt
aw0KPiA+IGRldm5hbWUnLiBJZiBoYXJld2FyZSBzZXQgcHJlZW1wdGlvbiBmZWF0dXJlLiBUaGUg
cHJvcGVydHkgd291bGQgYmUgYQ0KPiA+IGZpeGVkIHZhbHVlICdvbicgaWYgaGFyZHdhcmUgc3Vw
cG9ydCB0aGUgZnJhbWUgcHJlZW1wdGlvbi4NCj4gPiBGZWF0dXJlIHdvdWxkIHNob3cgYSBmaXhl
ZCB2YWx1ZSAnb2ZmJyBpZiBoYXJkd2FyZSBkb24ndCBzdXBwb3J0IHRoZQ0KPiA+IGZyYW1lIHBy
ZWVtcHRpb24uDQo+ID4NCj4gPiBDb21tYW5kICdldGh0b29sIGRldm5hbWUnIGFuZCAnZXRodG9v
bCAtcyBkZXZuYW1lIHByZWVtcHRpb24gTicNCj4gPiB3b3VsZCBzaG93L3NldCB3aGljaCB0cmFm
ZmljIGNsYXNzZXMgYXJlIGZyYW1lIHByZWVtcHRhYmxlLg0KPiA+DQo+ID4gUG9ydCBkcml2ZXIg
d291bGQgaW1wbGVtZW50IHRoZSBmcmFtZSBwcmVlbXB0aW9uIGluIHRoZSBmdW5jdGlvbg0KPiA+
IGdldF9saW5rX2tzZXR0aW5ncygpIGFuZCBzZXRfbGlua19rc2V0dGluZ3MoKSBpbiB0aGUgc3Ry
dWN0IGV0aHRvb2xfb3BzLg0KPiANCj4gSW4gYW4gZWFybHkgUkZDIHNlcmllcyBbMV0sIHdlIHBy
b3Bvc2VkIGEgd2F5IHRvIHN1cHBvcnQgZnJhbWUgcHJlZW1wdGlvbi4gSSdtDQo+IG5vdCBzdXJl
IGlmIHlvdSBoYXZlIGNvbnNpZGVyZWQgaXQgYmVmb3JlIGltcGxlbWVudGluZyB0aGlzIG90aGVy
IHByb3Bvc2FsDQo+IGJhc2VkIG9uIGV0aHRvb2wgaW50ZXJmYWNlIHNvIEkgdGhvdWdodCBpdCB3
b3VsZCBiZSBhIGdvb2QgaWRlYSB0byBicmluZyB0aGF0IHVwDQo+IHRvIHlvdXIgYXR0ZW50aW9u
LCBqdXN0IGluIGNhc2UuDQogDQpTb3JyeSwgSSBkaWRuJ3Qgbm90aWNlIHRoZSBSRkMgcHJvcG9z
YWwuIFVzaW5nIGV0aHRvb2wgc2V0IHRoZSBwcmVlbXB0aW9uIGp1c3QgdGhpbmtpbmcgYWJvdXQg
ODAyMVFidSBhcyBzdGFuZGFsb25lLiBBbmQgbm90IGxpbWl0IHRvIHRoZSB0YXByaW8gaWYgdXNl
ciB3b24ndCBzZXQgODAyLjFRYnYuICANCg0KQXMgc29tZSBmZWVkYmFjayAgYWxzbyB3YW50IHRv
IHNldCB0aGUgTUFDIG1lcmdlIG1pbmltYWwgZnJhZ21lbnQgc2l6ZSBhbmQgZ2V0IHNvbWUgbW9y
ZSBpbmZvcm1hdGlvbiBvZiA4MDIuM2JyLg0KDQo+IA0KPiBJbiB0aGF0IGluaXRpYWwgcHJvcG9z
YWwsIEZyYW1lIFByZWVtcHRpb24gZmVhdHVyZSBpcyBjb25maWd1cmVkIHZpYSB0YXByaW8gcWRp
c2MuDQo+IEZvciBleGFtcGxlOg0KPiANCj4gJCB0YyBxZGlzYyBhZGQgZGV2IElGQUNFIHBhcmVu
dCByb290IGhhbmRsZSAxMDAgdGFwcmlvIFwNCj4gICAgICAgbnVtX3RjIDMgXA0KPiAgICAgICBt
YXAgMiAyIDEgMCAyIDIgMiAyIDIgMiAyIDIgMiAyIDIgMiBcDQo+ICAgICAgIHF1ZXVlcyAxQDAg
MUAxIDJAMiBcDQo+ICAgICAgIHByZWVtcHRpb24gMCAxIDEgMSBcDQo+ICAgICAgIGJhc2UtdGlt
ZSAxMDAwMDAwMCBcDQo+ICAgICAgIHNjaGVkLWVudHJ5IFMgMDEgMzAwMDAwIFwNCj4gICAgICAg
c2NoZWQtZW50cnkgUyAwMiAzMDAwMDAgXA0KPiAgICAgICBzY2hlZC1lbnRyeSBTIDA0IDQwMDAw
MCBcDQo+ICAgICAgIGNsb2NraWQgQ0xPQ0tfVEFJDQo+IA0KPiBJdCBhbHNvIGFsaWducyB3aXRo
IHRoZSBnYXRlIGNvbnRyb2wgb3BlcmF0aW9ucyBTZXQtQW5kLUhvbGQtTUFDIGFuZCBTZXQtQW5k
LQ0KPiBSZWxlYXNlLU1BQyB0aGF0IGNhbiBiZSBzZXQgdmlhICdzY2hlZC1lbnRyeScgKHNlZSBU
YWJsZSA4LjcgZnJvbQ0KPiA4MDIuMVEtMjAxOCBmb3IgZnVydGhlciBkZXRhaWxzLg0KIA0KSSBh
bSBjdXJpb3VzIGFib3V0IFNldC1BbmQtSG9sZC1NYWMgdmlhICdzY2hlZC1lbnRyeScuIEFjdHVh
bGx5LCBpdCBjb3VsZCBiZSB1bmRlcnN0YW5kIGFzIGd1YXJkYmFuZCBieSBoYXJkd2FyZSBwcmVl
bXB0aW9uLiBNQUMgc2hvdWxkIGF1dG8gY2FsY3VsYXRlIHRoZSBuYW5vIHNlY29uZHMgYmVmb3Jl
ICBleHByZXNzIGVudHJ5IHNsb3Qgc3RhcnQgdG8gYnJlYWsgdG8gdHdvIGZyYWdtZW50cy4gU2V0
LUFuZC1Ib2xkLU1BQyBzaG91bGQgbWluaW1hbCBsYXJnZXIgdGhhbiB0aGUgZnJhZ21lbnQtc2l6
ZSBvY3QgdGltZXMuDQoNCj4gDQo+IFBsZWFzZSBzaGFyZSB5b3VyIHRob3VnaHRzIG9uIHRoaXMu
DQoNCkkgYW0gZ29vZCB0byBzZWUgdGhlcmUgaXMgZnJhbWUgcHJlZW1wdGlvbiBwcm9wb3NhbC4g
RWFjaCB3YXkgaXMgb2sgZm9yIG1lIGJ1dCBldGh0b29sIGlzIG1vcmUgZmxleGlibGUuIEkndmUg
c2VlbiB0aGUgUkZDIHRoZSBjb2RlLiBUaGUgaGFyZHdhcmUgb2ZmbG9hZCBpcyBpbiB0aGUgbWFp
bmxpbmUsIGJ1dCBwcmVlbXB0aW9uIGlzIG5vdCB5ZXQsIEkgZG9uJ3Qga25vdyB3aHkuIENvdWxk
IHlvdSBwb3N0IGl0IGFnYWluPw0KDQo+IFJlZ2FyZHMsDQo+IA0KPiBBbmRyZQ0K
