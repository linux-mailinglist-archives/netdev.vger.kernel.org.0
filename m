Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D4716F570
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 03:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgBZCBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 21:01:20 -0500
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:6278
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbgBZCBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 21:01:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuXDTGzU/q8mBbNiUWw7YiD8XTwJFpdFESrArj5dR6WCrtZM2vrwE3YUws1T3AGbPZFE7gT8OdxhKP1Eu1O1GC3dz/rNe4RTtGthwKJ/jhBSwo6qSpqTT3D0aMkjBULMZyTC49sh7zmyUF5dNkqy+3s95627ibGEPsF7zthFEEldEbMuMMr6XQn2OvdEiKxfcyUNpVEdDUDX3nIfj73hC7Mql1F8F9tedLwWtitVHdcmLgzXAjiDlQhnesPMJgQ5upV4oOXyqv6HjR6cOnQC0V/aa42UpEqk5QetdkXc57lc+WiQTrAASYsiBPGFiUb6aHI0O4qpb9JKQehv8FVEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N04tt0XGea3Oir+rZHRG3xxVZz+JZTdxr593GSWFpww=;
 b=MVIPBHXayKZuAPsDds1XXhrTm0+QBrXI3hDnZLerwPgzR4V2hLs9FxbQmnIJcky9TrI1jXnCXYDTZBXoEOyQ3XbOTc7qjeaMAtPTR9RkecEobrjxqpCBooFnUjisZaZRHSDyoy5FVrbeiw5qQ/MHnSNAgxQX2oYzCTpavnwGiY+nkiK45UTHE1in7xi37h+j4s4TKVUfCNQTIObD3A1Ux3A+W/VbrfLwVopO3R8Y1Kp+ncMiIc5i4jYpj+lljUiLc9o0a47QcHSfaqPDVDD8n6STHlsc7aPmxJUvbdf1GNuOJB4VQANr9Y+JqEiMm9knl8el3l2YLlSIUZJf63DzJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N04tt0XGea3Oir+rZHRG3xxVZz+JZTdxr593GSWFpww=;
 b=DyN3tOaQZxqjCQE/rNp+7ubhnkqwedEw0NNH7mIRFFh51Scca1a+eLUj7m73Yke0xcBeAFdPZ8iEtBeD97Kaddn4MWQuVEemL3jKt4StxwcylJoJ9Rp24pPXMgzWw4JqSa5guQ2Z+tQn0VyR7IxeVWltiyYSwFVk/CFKSk2CW34=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6559.eurprd04.prod.outlook.com (20.179.235.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 02:01:15 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 02:01:15 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
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
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Topic: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiagmtdqAgABRRQCABblVgIAAhf0g
Date:   Wed, 26 Feb 2020 02:01:14 +0000
Message-ID: <VE1PR04MB649601CA53F6B2695EE83FFE92EA0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87a75br4ze.fsf@linux.intel.com>
 <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <7d68d83c-c81d-5221-b843-07adb40e4b93@ti.com>
In-Reply-To: <7d68d83c-c81d-5221-b843-07adb40e4b93@ti.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ce1badb-35d2-4880-bb21-08d7ba5fc2e7
x-ms-traffictypediagnostic: VE1PR04MB6559:|VE1PR04MB6559:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6559A497A2E1473ED49387A192EA0@VE1PR04MB6559.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(110136005)(9686003)(76116006)(316002)(2906002)(33656002)(44832011)(66476007)(66946007)(66556008)(7416002)(478600001)(55016002)(64756008)(54906003)(8936002)(53546011)(52536014)(6506007)(81166006)(81156014)(86362001)(26005)(186003)(4326008)(71200400001)(7696005)(66446008)(8676002)(5660300002)(921003)(21314003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6559;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k0rFBplrbG4RVXbHYUjYyZstog2Z5a+itgitKaHKTtopbE237oFs9FbXLMAkbjX+uk7978YaxUKX9Alj500M+brK4NceiUJchLnLhK9gxlsrGkoDDptfE5mblC/fSL2EjR8XQxq85sXpxZxxTO1jfCcBsNcjv3+7sCgufRFJX+7PwiDNo9OF31H2P2mGxOn6bTRpbZEiruFAFNyYIySOoMyJ1JTnP2Qg3M4r+2OGXOvFcAVJd/fqNpptKw5pmQ+IoOjgmeQhZE94NXXMN5xJ+1Hk/Z9e6Sm6053q/xvh2RW67OMzsRyqYUc6jKwvR0qnDn5zts+gVeuVxgIL7IMdF2ec52G0XtlUwkaBLjn+MCmdR68p1Ql89CdYNtle4/ZarvYngqWofu7LNQ8utERAb6Ct61n0WnEVLcU4GR4T/r1rQO9R7D+oyTdrtWCp5X/iVu7svMKgAhINgyZRHL5z+EQiqsbQlycqVfKSvrKTrGEd48jk2cK/b0yZ5T5UsyidotstaG9Gmbn4t70EK/UvVw==
x-ms-exchange-antispam-messagedata: WKYubA2GJXJGlKFOobBs7SZEWRxkvyloAP1hwJhauEgDOMzMacNqukE/VLhAqB3F8/jorUH1VSQ7lZ6nirGmzEMyIPR9PYE4qgIUR1Pz4ZVTkhtX0YM/47qnTDfSyqsr3SUxSlBzo/OPgZqtc5jfoA==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce1badb-35d2-4880-bb21-08d7ba5fc2e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 02:01:14.9111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBTgHNnHZBDwWfmiZXkEDEFadU/bIcE6sOX5H5dZLlITG7WcSn7MmzshgEYuu56w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6559
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBNdXJhbGkgS2FyaWNoZXJpIDxtLWthcmljaGVyaTJAdGkuY29tPg0KPiBTZW50OiAyMDIwxOoy
1MIyNsjVIDE6NTkNCj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+OyBWaW5pY2l1cyBDb3N0
YSBHb21lcw0KPiA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsNCj4gaGF1a2UubWVocnRlbnNAaW50ZWwuY29tOyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
ZzsNCj4gYWxsaXNvbkBsb2h1dG9rLm5ldDsgdGdseEBsaW51dHJvbml4LmRlOyBoa2FsbHdlaXQx
QGdtYWlsLmNvbTsNCj4gc2FlZWRtQG1lbGxhbm94LmNvbTsgYW5kcmV3QGx1bm4uY2g7IGYuZmFp
bmVsbGlAZ21haWwuY29tOw0KPiBhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNvbTsgamlyaUBt
ZWxsYW5veC5jb207IGF5YWxAbWVsbGFub3guY29tOw0KPiBwYWJsb0BuZXRmaWx0ZXIub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENj
OiBzaW1vbi5ob3JtYW5AbmV0cm9ub21lLmNvbTsgQ2xhdWRpdSBNYW5vaWwNCj4gPGNsYXVkaXUu
bWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29t
PjsNCj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsg
WGlhb2xpYW5nIFlhbmcNCj4gPHhpYW9saWFuZy55YW5nXzFAbnhwLmNvbT47IFJveSBaYW5nIDxy
b3kuemFuZ0BueHAuY29tPjsgTWluZ2thaSBIdQ0KPiA8bWluZ2thaS5odUBueHAuY29tPjsgSmVy
cnkgSHVhbmcgPGplcnJ5Lmh1YW5nQG54cC5jb20+OyBMZW8gTGkNCj4gPGxlb3lhbmcubGlAbnhw
LmNvbT47IEl2YW4gS2hvcm9uemh1ayA8aXZhbi5raG9yb256aHVrQGxpbmFyby5vcmc+DQo+IFN1
YmplY3Q6IFJlOiBbRVhUXSBSZTogW3YxLG5ldC1uZXh0LCAxLzJdIGV0aHRvb2w6IGFkZCBzZXR0
aW5nIGZyYW1lDQo+IHByZWVtcHRpb24gb2YgdHJhZmZpYyBjbGFzc2VzDQo+IA0KPiBDYXV0aW9u
OiBFWFQgRW1haWwNCj4gDQo+IEhpIFBvLA0KPiANCj4gT24gMDIvMjEvMjAyMCAxMDoyNiBQTSwg
UG8gTGl1IHdyb3RlOg0KPiA+IEhpIFZpbmljaXVzLA0KPiA+DQo+ID4NCj4gPiBCciwNCj4gPiBQ
byBMaXUNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBW
aW5pY2l1cyBDb3N0YSBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPg0KPiA+PiBTZW50
OiAyMDIwxOoy1MIyMsjVIDU6NDQNCj4gPj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+OyBk
YXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+PiBoYXVrZS5tZWhydGVuc0BpbnRlbC5jb207IGdyZWdr
aEBsaW51eGZvdW5kYXRpb24ub3JnOw0KPiA+PiBhbGxpc29uQGxvaHV0b2submV0OyB0Z2x4QGxp
bnV0cm9uaXguZGU7IGhrYWxsd2VpdDFAZ21haWwuY29tOw0KPiA+PiBzYWVlZG1AbWVsbGFub3gu
Y29tOyBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+ID4+IGFsZXhhbmRy
dS5hcmRlbGVhbkBhbmFsb2cuY29tOyBqaXJpQG1lbGxhbm94LmNvbTsNCj4gYXlhbEBtZWxsYW5v
eC5jb207DQo+ID4+IHBhYmxvQG5ldGZpbHRlci5vcmc7IGxpbnV4LSBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnOw0KPiA+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4+IENjOiBzaW1vbi5ob3Jt
YW5AbmV0cm9ub21lLmNvbTsgQ2xhdWRpdSBNYW5vaWwNCj4gPj4gPGNsYXVkaXUubWFub2lsQG54
cC5jb20+OyBWbGFkaW1pciBPbHRlYW4NCj4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsNCj4g
Pj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgWGlh
b2xpYW5nDQo+IFlhbmcNCj4gPj4gPHhpYW9saWFuZy55YW5nXzFAbnhwLmNvbT47IFJveSBaYW5n
IDxyb3kuemFuZ0BueHAuY29tPjsgTWluZ2thaQ0KPiBIdQ0KPiA+PiA8bWluZ2thaS5odUBueHAu
Y29tPjsgSmVycnkgSHVhbmcgPGplcnJ5Lmh1YW5nQG54cC5jb20+OyBMZW8gTGkNCj4gPj4gPGxl
b3lhbmcubGlAbnhwLmNvbT47IFBvIExpdSA8cG8ubGl1QG54cC5jb20+DQo+ID4+IFN1YmplY3Q6
IFtFWFRdIFJlOiBbdjEsbmV0LW5leHQsIDEvMl0gZXRodG9vbDogYWRkIHNldHRpbmcgZnJhbWUN
Cj4gPj4gcHJlZW1wdGlvbiBvZiB0cmFmZmljIGNsYXNzZXMNCj4gPj4NCj4gPj4gQ2F1dGlvbjog
RVhUIEVtYWlsDQo+ID4+DQo+ID4+IEhpLA0KPiA+Pg0KPiA+PiBQbyBMaXUgPHBvLmxpdUBueHAu
Y29tPiB3cml0ZXM6DQo+ID4+DQo+ID4+PiBJRUVFIFN0ZCA4MDIuMVFidSBzdGFuZGFyZCBkZWZp
bmVkIHRoZSBmcmFtZSBwcmVlbXB0aW9uIG9mIHBvcnQNCj4gPj4+IHRyYWZmaWMgY2xhc3Nlcy4g
VGhpcyBwYXRjaCBpbnRyb2R1Y2UgYSBtZXRob2QgdG8gc2V0IHRyYWZmaWMNCj4gPj4+IGNsYXNz
ZXMgcHJlZW1wdGlvbi4gQWRkIGEgcGFyYW1ldGVyICdwcmVlbXB0aW9uJyBpbiBzdHJ1Y3QNCj4g
Pj4+IGV0aHRvb2xfbGlua19zZXR0aW5ncy4gVGhlIHZhbHVlIHdpbGwgYmUgdHJhbnNsYXRlZCB0
byBhIGJpbmFyeSwNCj4gPj4+IGVhY2ggYml0IHJlcHJlc2VudCBhIHRyYWZmaWMgY2xhc3MuIEJp
dCAiMSIgbWVhbnMgcHJlZW1wdGFibGUNCj4gPj4+IHRyYWZmaWMgY2xhc3MuIEJpdCAiMCIgbWVh
bnMgZXhwcmVzcyB0cmFmZmljIGNsYXNzLiAgTVNCIHJlcHJlc2VudA0KPiA+Pj4gaGlnaCBudW1i
ZXIgdHJhZmZpYyBjbGFzcy4NCj4gPj4+DQo+ID4+PiBJZiBoYXJkd2FyZSBzdXBwb3J0IHRoZSBm
cmFtZSBwcmVlbXB0aW9uLCBkcml2ZXIgY291bGQgc2V0IHRoZQ0KPiA+Pj4gZXRoZXJuZXQgZGV2
aWNlIHdpdGggaHdfZmVhdHVyZXMgYW5kIGZlYXR1cmVzIHdpdGgNCj4gPj4+IE5FVElGX0ZfUFJF
RU1QVElPTiB3aGVuIGluaXRpYWxpemluZyB0aGUgcG9ydCBkcml2ZXIuDQo+ID4+Pg0KPiA+Pj4g
VXNlciBjYW4gY2hlY2sgdGhlIGZlYXR1cmUgJ3R4LXByZWVtcHRpb24nIGJ5IGNvbW1hbmQgJ2V0
aHRvb2wgLWsNCj4gPj4+IGRldm5hbWUnLiBJZiBoYXJld2FyZSBzZXQgcHJlZW1wdGlvbiBmZWF0
dXJlLiBUaGUgcHJvcGVydHkgd291bGQgYmUNCj4gPj4+IGEgZml4ZWQgdmFsdWUgJ29uJyBpZiBo
YXJkd2FyZSBzdXBwb3J0IHRoZSBmcmFtZSBwcmVlbXB0aW9uLg0KPiA+Pj4gRmVhdHVyZSB3b3Vs
ZCBzaG93IGEgZml4ZWQgdmFsdWUgJ29mZicgaWYgaGFyZHdhcmUgZG9uJ3Qgc3VwcG9ydCB0aGUN
Cj4gPj4+IGZyYW1lIHByZWVtcHRpb24uDQo+ID4+Pg0KPiA+Pj4gQ29tbWFuZCAnZXRodG9vbCBk
ZXZuYW1lJyBhbmQgJ2V0aHRvb2wgLXMgZGV2bmFtZSBwcmVlbXB0aW9uIE4nDQo+ID4+PiB3b3Vs
ZCBzaG93L3NldCB3aGljaCB0cmFmZmljIGNsYXNzZXMgYXJlIGZyYW1lIHByZWVtcHRhYmxlLg0K
PiA+Pj4NCj4gPj4+IFBvcnQgZHJpdmVyIHdvdWxkIGltcGxlbWVudCB0aGUgZnJhbWUgcHJlZW1w
dGlvbiBpbiB0aGUgZnVuY3Rpb24NCj4gPj4+IGdldF9saW5rX2tzZXR0aW5ncygpIGFuZCBzZXRf
bGlua19rc2V0dGluZ3MoKSBpbiB0aGUgc3RydWN0IGV0aHRvb2xfb3BzLg0KPiA+Pj4NCj4gPj4N
Cj4gPj4gQW55IHVwZGF0ZXMgb24gdGhpcyBzZXJpZXM/IElmIHlvdSB0aGluayB0aGF0IHRoZXJl
J3Mgc29tZXRoaW5nIHRoYXQNCj4gPj4gSSBjb3VsZCBoZWxwLCBqdXN0IHRlbGwuDQo+ID4NCj4g
PiBTb3JyeSBmb3IgdGhlIGxvbmcgdGltZSBub3QgaW52b2x2ZSB0aGUgZGlzY3Vzc2lvbi4gSSBh
bSBmb2N1cyBvbiBvdGhlcg0KPiB0c24gY29kZSBmb3IgdGMgZmxvd2VyLg0KPiA+IElmIHlvdSBj
YW4gdGFrZSBtb3JlIGFib3V0IHRoaXMgcHJlZW1wdGlvbiBzZXJpYWwsIHRoYXQgd291bGQgYmUg
Z29vZC4NCj4gPg0KPiA+IEkgc3VtbWFyeSBzb21lIHN1Z2dlc3Rpb25zIGZyb20gTWFyYWxpIEth
cmljaGVyaSBhbmQgSXZhbg0KPiBLaG9ybm9uemh1ayBhbmQgYnkgeW91IGFuZCBhbHNvIG90aGVy
czoNCj4gDQo+IEl0IGlzIE11cmFsaSA6KQ0KPiANCj4gPiAtIEFkZCBjb25maWcgdGhlIGZyYWdt
ZW50IHNpemUsIGhvbGQgYWR2YW5jZSwgcmVsZWFzZSBhZHZhbmNlIGFuZA0KPiA+IGZsYWdzOw0K
PiANCj4gICAtIEkgYmVsaWV2ZSBob2xkIGFkdmFuY2UsIHJlbGVhc2UgYWR2YW5jZSB2YWx1ZXMg
YXJlIHJlYWQgb25seQ0KPiANCj4gPiAgICAgIE15IGNvbW1lbnRzIGFib3V0IHRoZSBmcmFnbWVu
dCBzaXplIGlzIGluIHRoZSBRYnUgc3BlYyBsaW1pdCB0aGUNCj4gPiBmcmFnbWVudCBzaXplICIg
dGhlIG1pbmltdW0gbm9uLWZpbmFsIGZyYWdtZW50IHNpemUgaXMgNjQsIDEyOCwgMTkyLCBvcg0K
PiAyNTYgb2N0ZXRzICIgdGhpcyBzZXR0aW5nIHdvdWxkIGFmZmVjdCB0aGUgZ3VhcmRiYW5kIHNl
dHRpbmcgZm9yIFFidi4gQnV0DQo+IHRoZSBldGh0b29sIHNldHRpbmcgY291bGQgbm90IGludm9s
dmUgdGhpcyBpc3N1ZXMgYnV0IGJ5IHRoZSB0YXByaW8gc2lkZS4NCj4gPiAtICIgRnVydGhlcm1v
cmUsIHRoaXMgc2V0dGluZyBjb3VsZCBiZSBleHRlbmQgZm9yIGEgc2VyaWFsIHNldHRpbmcgZm9y
IG1hYw0KPiBhbmQgdHJhZmZpYyBjbGFzcy4iICAiQmV0dGVyIG5vdCB0byB1c2luZyB0aGUgdHJh
ZmZpYyBjbGFzcyBjb25jZXB0LiINCj4gICAtIENvdWxkbid0IHVuZGVyc3RhbmQgdGhlIGFib3Zl
PyBDb3VsZCB5b3UgcGxlYXNlIGV4cGxhaW4gYSBiaXQgbW9yZQ0KPiAgICAgb24gd2hhdCB5b3Ug
bWVhbnQgaGVyZT8NCg0KT2gsIEkgY29weSB0aGUgb3JpZ2luYWwgc3VnZ2VzdGlvbiBieSB5b3Ug
YW5kIG90aGVyIGhlcmUuIEp1c3QgZm9yIG1vcmUgZXZhbHVhdGlvbiBmb3IgbmV4dCB2ZXJzaW9u
Lg0KDQo+IA0KPiBNdXJhbGkNCj4gPiAgICAgQ291bGQgYWRkaW5nIGEgc2VyaWFsIHNldHRpbmcg
YnkgImV0aHRvb2wgLS1wcmVlbXB0aW9uIHh4eCIgb3Igb3RoZXINCj4gbmFtZS4gSSBkb24nIHQg
dGhpbmsgaXQgaXMgZ29vZCB0byBpbnZvbHZlIGluIHRoZSBxdWV1ZSBjb250cm9sIHNpbmNlIHF1
ZXVlcw0KPiBudW1iZXIgbWF5IGJpZ2dlciB0aGFuIHRoZSBUQyBudW1iZXIuDQo+ID4gLSBUaGUg
ZXRodG9vbCBpcyB0aGUgYmV0dGVyIGNob2ljZSB0byBjb25maWd1cmUgdGhlIHByZWVtcHRpb24N
Cj4gPiAgICBJIGFncmVlLg0KPiA+DQo+ID4gVGhhbmtzo6ENCj4gPj4NCj4gPj4NCj4gPj4gQ2hl
ZXJzLA0KPiA+PiAtLQ0KPiA+PiBWaW5pY2l1cw0KPiANCj4gLS0NCj4gTXVyYWxpIEthcmljaGVy
aQ0KPiBUZXhhcyBJbnN0cnVtZW50cw0K
