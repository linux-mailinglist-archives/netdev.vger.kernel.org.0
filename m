Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62EB227668
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGUDKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:10:50 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:48868
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgGUDKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 23:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqYn8V6/dWnatxRymHNSm4F5mvksuPFl8xtWU3P3zPhrOXiSSnegsZTagzi2VBJ0RLHfVGp6WtAJFYy6iXrkAhAhLyrtVGKW73f8X68P0SRIN4HGWPik21e0RZY8EsvdhNppH3tlyFwY9whlj38ebFZcAm/HkKI+matAM7NRHHrK95Gb9u0D+txMe/V6ALSF+HLnwEiy8Bs/G1/T29pZZUPfyJvlQdtGHYhvOHd9lgFJ0+k6zCxN5IZZ1DeOINACy7UvnShUqkhTtn/hrLqndY24fByV5+BwBORorde40yDoTBhmvGYo08MXfynkoF+pVLumJLqOPV6JsVz4q2N32Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsFzTJTrBummvyP//xty45RzBGfHm+CuhqDLfEDptmM=;
 b=d09fnnUUR+HMVUDQUNkLAdM6ER31e3ktoRLyWcrGWAj1QALWfGtxdmOpLBpTGZ0l4vhg2BRNDScZYDz5QSe4rHWjFbCqT22tuNWFZbEGWtN5I4B9/9QWbg4MF42ACCtE1dtzgUwoxeLTYGg7CK/uUWduh0V+g1KOWzRYlajlh4IiiYGj1+8f2DsChBj4BKeYfiA9kMKaWLdTJb8+08+2QUJSPS6EiYudhOVTdmfelluJW+gZYXnf2KW8D9KFk3Z0gY4VW1GibChjD6sDF1kffbR37c2J66O7hg4hpuzaBzx1l5euYBzJZ1EAizvsQ84zOCuF1KwBh3m7MH0C9dV2BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsFzTJTrBummvyP//xty45RzBGfHm+CuhqDLfEDptmM=;
 b=A1+/gCcbWgs1xi5s2KFJ+2LQq3CnyXw18Wt9DxivAxnEW0ql8g7Jd+9YmupnG4JZBSLtTIL02WKiIKf741tBprPMfZ+ncsz+y8eRoOFgUINF0XF/BRt+FgBUU23idjW5KyzdgT8pLhDR0LFjC6m4MKIFFlicvDCbE+fpdaUaXqQ=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB4127.eurprd04.prod.outlook.com (2603:10a6:803:4e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 03:10:41 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 03:10:41 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
CC:     Hongbo Wang <hongbo.wang@nxp.com>
Subject: RE: [EXT] Re: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding
 VLAN for dsa switch and port
Thread-Topic: [EXT] Re: [PATCH 1/2] net: dsa: Add flag for 802.1AD when adding
 VLAN for dsa switch and port
Thread-Index: AQHWXoLJBx1mtvIMdEm5Yv3hTArNlqkRUmjg
Date:   Tue, 21 Jul 2020 03:10:41 +0000
Message-ID: <VI1PR04MB510318E66EEF8F34A31AFDE6E1780@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200720104119.19146-1-hongbo.wang@nxp.com>
 <05b06d46-d705-7d06-b4dd-2bee90f75168@cumulusnetworks.com>
In-Reply-To: <05b06d46-d705-7d06-b4dd-2bee90f75168@cumulusnetworks.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: cumulusnetworks.com; dkim=none (message not signed)
 header.d=none;cumulusnetworks.com; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df8b2d8d-d866-4440-affb-08d82d23a6bd
x-ms-traffictypediagnostic: VI1PR04MB4127:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB41275E9A4B2E912C74344489E1780@VI1PR04MB4127.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b8wBM4CqzGZ9Tj8Fi5UZs7/n2eW7j8LSg+ObOzT70BrGB3x38RmxFGGThb0mNMxuyaq7k+2EmTv3LvCL2ACJuP4eGdkjxNr7VO5BjHDUKa0J3OK0bEGVFAzoZou/ZO5SzFrGQkVsmDXSOv7zEmm01FYVcg0+jge/mwdacGFN8WiWVQa6snKXUX5dlynxyNShQ0LPrCXEXwxBc74NG79CjivWMKSgc0sGyDBhHNKw49F4aeeAQB89q0Xe1r1I8AS/8fpK5P5ZSmwgqD689KQ3Jw6XRwxGvrjXfATu6BnLeX0ziGcTkHc83/r+aErXBAsfMX277XmX6GTbHu1urUQYYiLTedKwafFOuiv3xwt8yaeYGz49IKnWORncTkcqCQw5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(8936002)(71200400001)(110136005)(64756008)(7416002)(2906002)(478600001)(8676002)(52536014)(66556008)(66476007)(76116006)(66446008)(5660300002)(86362001)(66946007)(55016002)(7696005)(26005)(9686003)(44832011)(186003)(316002)(33656002)(4326008)(53546011)(6506007)(83380400001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: K24bZY0JS4bgyiW5maUJvChWjeb3XGiKmVnEtzwZeFJCPcKuoKGT88e0vnxOWVGhbbJtxyorDGkY7HcuFGxUDiImrzjH99DHZuq7s3z0eWgZAU4Eag705FTki+jt917QLgUaaVvKNIEXwXvt+oVasv+sZHnlJBqVDg55UIselpL1oTAiELO1L/Bk7/zo7V2b0KkWoMcDGMuYbNCtEmt5pJEU6nWABbccEx9gsl0/Rzm94O4VNC+9LT9wNma304c5v8gY16xZoZOnLm0c8mI2UOygbTvfoEv6RuYpGO2goQMBOpo628pbcxE5mb75Xofsg451lNS2Qh428whnUoUJMx02dp35zI6GkoPIKuddNNtwI5V2KMRnJMTiruBEB+bD5JWoJprtq3J1eryryKiJBpb926sOPiq/9oIDsFHsImx7gjfcXibE4hb6kh9B7041i1BLJ50/OtqEr5eYO4T0gptUNfpx6Ezi1TlSkbbiuG0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8b2d8d-d866-4440-affb-08d82d23a6bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 03:10:41.5320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+B1nteFCUR8ZDun//TLNXUyDSz0XvLwKYLiztCdC94z9jrSqAZlJH6vxtPyYwEZZzydtkN/ocmZAUHYBJI7SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTmlrb2xheSwNCg0KIFRoYW5rcyBmb3IgeW91ciBjb21tZW50cy4NCg0KVGhlIG9yaWdpbmFs
IGludGVudGlvbiBpcyB0aGF0IEkgd2FudCB0byBydW4gYSBjb21tYW5kIHRvIHNldCBzaW5nbGUg
cG9ydCBpbnRvIFFpblEgbW9kZSwNCnRoZSByZWxhdGVkIGNvbW1hbmRzIGFyZToNCmlwIGxpbmsg
c2V0IGJyMCB0eXBlIGJyaWRnZSB2bGFuX3Byb3RvY29sIDgwMi4xYWQgIC8vIHRoaXMgY29tbWFu
ZCB3aWxsIHNldCBhbGwgcG9ydHMgdW5kZXIgdGhlIGJyaWRnZSBicjANCmlwIGxpbmsgYWRkIGxp
bmsgc3dwMSBuYW1lIHN3cDEuMTAwIHR5cGUgdmxhbiBwcm90b2NvbCA4MDIuMWFkIGlkIDEwMCAg
Ly8gdGhpcyBjb21tYW5kIGNhbiBzZXQgc2luZ2xlIHBvcnQgZm9yIHZsYW4NCg0KSSB0cmFjZSB0
aGUgcmVsYXRlZCBjb2RlIG9mIHRoZXNlIHR3byBjb21tYW5kcywgZmluZCB0aGUgc2FtZSBpc3N1
ZSB0aGF0IGRzYV9zbGF2ZV92bGFuX3J4X2FkZF92aWQgZGlkbid0IHBhc3MgdGhlIHBhcmFtZXRl
ciAicHJvdG8iIHRvIG5leHQgcG9ydCBsZXZlbCwgc28gSSBjcmVhdGUgdGhpcyBwYXRjaC4NCg0K
SSB1bmRlcnN0YW5kIHlvdXIgY29uY2VybiwgSWYgZG9uJ3QgdXNlIHRoZSBmbGFncyBmb3IgYnJp
ZGdlLCBhbm90aGVyIHdheSBpcyB0aGF0IGFkZCBuZXcgaXRlbSAidTE2IHByb3RvIiBpbiBzdHJ1
Y3Qgc3dpdGNoZGV2X29ial9wb3J0X3ZsYW4sIHRoZSBzbGF2ZSBwb3J0IGNhbiBnZXQgcHJvdG8g
ZnJvbSB0aGF0LCBsaWtlIHRoYXQ6DQoNCnN0cnVjdCBzd2l0Y2hkZXZfb2JqX3BvcnRfdmxhbiB7
DQoJc3RydWN0IHN3aXRjaGRldl9vYmogb2JqOw0KCXUxNiBmbGFnczsNCgl1MTYgdmlkX2JlZ2lu
Ow0KCXUxNiB2aWRfZW5kOw0KICAgKyB1MTYgcHJvdG87DQp9Ow0KDQpUaGUgcmVsYXRlZCBtb2Rp
ZmljYXRpb24gaGFzOg0KaW50IGRzYV9wb3J0X3ZpZF9hZGQoc3RydWN0IGRzYV9wb3J0ICpkcCwg
dTE2IHZpZCwgdTE2IGZsYWdzLCB1MTYgcHJvdG8pOyAgLy8gYWRkIHBhcmFtZXRlciBwcm90bw0K
aW50IGRzYV9wb3J0X3ZpZF9kZWwoc3RydWN0IGRzYV9wb3J0ICpkcCwgdTE2IHZpZCwgdTE2IHBy
b3RvKTsgIC8vIGFkZCBwYXJhbWV0ZXIgcHJvdG8NCg0KQW55IGNvbW1lbnRzPw0KVGhhbmtzDQoN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IE5pa29sYXkgQWxla3NhbmRyb3Yg
PG5pa29sYXlAY3VtdWx1c25ldHdvcmtzLmNvbT4gDQpTZW50OiAyMDIw5bm0N+aciDIw5pelIDE4
OjQ1DQpUbzogSG9uZ2JvIFdhbmcgPGhvbmdiby53YW5nQG54cC5jb20+OyBYaWFvbGlhbmcgWWFu
ZyA8eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgYWxsYW4ubmllbHNlbkBtaWNyb2NoaXAuY29t
OyBQbyBMaXUgPHBvLmxpdUBueHAuY29tPjsgQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2ls
QG54cC5jb20+OyBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5j
b20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgTGVvIExpIDxs
ZW95YW5nLmxpQG54cC5jb20+OyBNaW5na2FpIEh1IDxtaW5na2FpLmh1QG54cC5jb20+OyBhbmRy
ZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207IHZpdmllbi5kaWRlbG90QGdtYWlsLmNv
bTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgamlyaUByZXNudWxsaS51czsgaWRvc2NoQGlkb3NjaC5v
cmc7IGt1YmFAa2VybmVsLm9yZzsgdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyByb29wYUBjdW11
bHVzbmV0d29ya3MuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyBob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29tOyBhbGV4YW5kcmUuYmVs
bG9uaUBib290bGluLmNvbTsgVU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsgbGludXgtZGV2
ZWxAbGludXgubnhkaS5ueHAuY29tDQpTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENIIDEvMl0gbmV0
OiBkc2E6IEFkZCBmbGFnIGZvciA4MDIuMUFEIHdoZW4gYWRkaW5nIFZMQU4gZm9yIGRzYSBzd2l0
Y2ggYW5kIHBvcnQNCg0KQ2F1dGlvbjogRVhUIEVtYWlsDQoNCk9uIDIwLzA3LzIwMjAgMTM6NDEs
IGhvbmdiby53YW5nQG54cC5jb20gd3JvdGU6DQo+IEZyb206ICJob25nYm8ud2FuZyIgPGhvbmdi
by53YW5nQG54cC5jb20+DQo+DQo+IHRoZSBmb2xsb3dpbmcgY29tbWFuZCBjYW4gYmUgc3VwcG9y
dGVkOg0KPiBpcCBsaW5rIGFkZCBsaW5rIHN3cDEgbmFtZSBzd3AxLjEwMCB0eXBlIHZsYW4gcHJv
dG9jb2wgODAyLjFhZCBpZCAxMDANCj4NCj4gU2lnbmVkLW9mZi1ieTogaG9uZ2JvLndhbmcgPGhv
bmdiby53YW5nQG54cC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L2lmX2JyaWRn
ZS5oIHwgMSArDQo+ICBuZXQvZHNhL3NsYXZlLmMgICAgICAgICAgICAgICAgfCA5ICsrKysrKyst
LQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
DQoNClRoaXMgaXMgbm90IGJyaWRnZSByZWxhdGVkIGF0IGFsbCwgcGxlYXNlIGxlYXZlIGl0cyBm
bGFncyBvdXQgb2YgaXQuDQoNCk5hY2tlZC1ieTogTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlrb2xh
eUBjdW11bHVzbmV0d29ya3MuY29tPg0KDQoNCg0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBp
L2xpbnV4L2lmX2JyaWRnZS5oIA0KPiBiL2luY2x1ZGUvdWFwaS9saW51eC9pZl9icmlkZ2UuaCBp
bmRleCBjYWE2OTE0YTNlNTMuLmVjZDk2MGFhNjVjNyANCj4gMTAwNjQ0DQo+IC0tLSBhL2luY2x1
ZGUvdWFwaS9saW51eC9pZl9icmlkZ2UuaA0KPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvaWZf
YnJpZGdlLmgNCj4gQEAgLTEzMiw2ICsxMzIsNyBAQCBlbnVtIHsNCj4gICNkZWZpbmUgQlJJREdF
X1ZMQU5fSU5GT19SQU5HRV9FTkQgICAoMTw8NCkgLyogVkxBTiBpcyBlbmQgb2YgdmxhbiByYW5n
ZSAqLw0KPiAgI2RlZmluZSBCUklER0VfVkxBTl9JTkZPX0JSRU5UUlkgICAgICgxPDw1KSAvKiBH
bG9iYWwgYnJpZGdlIFZMQU4gZW50cnkgKi8NCj4gICNkZWZpbmUgQlJJREdFX1ZMQU5fSU5GT19P
TkxZX09QVFMgICAoMTw8NikgLyogU2tpcCBjcmVhdGUvZGVsZXRlL2ZsYWdzICovDQo+ICsjZGVm
aW5lIEJSSURHRV9WTEFOX0lORk9fODAyMUFEICAgICAgKDE8PDcpIC8qIFZMQU4gaXMgODAyLjFB
RCBwcm90b2NvbCAqLw0KPg0KPiAgc3RydWN0IGJyaWRnZV92bGFuX2luZm8gew0KPiAgICAgICBf
X3UxNiBmbGFnczsNCj4gZGlmZiAtLWdpdCBhL25ldC9kc2Evc2xhdmUuYyBiL25ldC9kc2Evc2xh
dmUuYyBpbmRleCANCj4gNGM3ZjA4NmEwNDdiLi4zNzZkN2FjNWYxZTUgMTAwNjQ0DQo+IC0tLSBh
L25ldC9kc2Evc2xhdmUuYw0KPiArKysgYi9uZXQvZHNhL3NsYXZlLmMNCj4gQEAgLTEyMzIsNiAr
MTIzMiw3IEBAIHN0YXRpYyBpbnQgZHNhX3NsYXZlX2dldF90c19pbmZvKHN0cnVjdCANCj4gbmV0
X2RldmljZSAqZGV2LCAgc3RhdGljIGludCBkc2Ffc2xhdmVfdmxhbl9yeF9hZGRfdmlkKHN0cnVj
dCBuZXRfZGV2aWNlICpkZXYsIF9fYmUxNiBwcm90bywNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB1MTYgdmlkKSAgew0KPiArICAgICB1MTYgZmxhZ3MgPSAwOw0KPiAgICAg
ICBzdHJ1Y3QgZHNhX3BvcnQgKmRwID0gZHNhX3NsYXZlX3RvX3BvcnQoZGV2KTsNCj4gICAgICAg
c3RydWN0IGJyaWRnZV92bGFuX2luZm8gaW5mbzsNCj4gICAgICAgaW50IHJldDsNCj4gQEAgLTEy
NTIsNyArMTI1MywxMCBAQCBzdGF0aWMgaW50IGRzYV9zbGF2ZV92bGFuX3J4X2FkZF92aWQoc3Ry
dWN0IG5ldF9kZXZpY2UgKmRldiwgX19iZTE2IHByb3RvLA0KPiAgICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIC1FQlVTWTsNCj4gICAgICAgfQ0KPg0KPiAtICAgICByZXQgPSBkc2FfcG9ydF92
aWRfYWRkKGRwLCB2aWQsIDApOw0KPiArICAgICBpZiAobnRvaHMocHJvdG8pID09IEVUSF9QXzgw
MjFBRCkNCj4gKyAgICAgICAgICAgICBmbGFncyB8PSBCUklER0VfVkxBTl9JTkZPXzgwMjFBRDsN
Cj4gKw0KPiArICAgICByZXQgPSBkc2FfcG9ydF92aWRfYWRkKGRwLCB2aWQsIGZsYWdzKTsNCj4g
ICAgICAgaWYgKHJldCkNCj4gICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPg0KPiBAQCAtMTc0
NCw3ICsxNzQ4LDggQEAgaW50IGRzYV9zbGF2ZV9jcmVhdGUoc3RydWN0IGRzYV9wb3J0ICpwb3J0
KQ0KPg0KPiAgICAgICBzbGF2ZV9kZXYtPmZlYXR1cmVzID0gbWFzdGVyLT52bGFuX2ZlYXR1cmVz
IHwgTkVUSUZfRl9IV19UQzsNCj4gICAgICAgaWYgKGRzLT5vcHMtPnBvcnRfdmxhbl9hZGQgJiYg
ZHMtPm9wcy0+cG9ydF92bGFuX2RlbCkNCj4gLSAgICAgICAgICAgICBzbGF2ZV9kZXYtPmZlYXR1
cmVzIHw9IE5FVElGX0ZfSFdfVkxBTl9DVEFHX0ZJTFRFUjsNCj4gKyAgICAgICAgICAgICBzbGF2
ZV9kZXYtPmZlYXR1cmVzIHw9IE5FVElGX0ZfSFdfVkxBTl9DVEFHX0ZJTFRFUiB8DQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBORVRJRl9GX0hXX1ZMQU5fU1RBR19GSUxU
RVI7DQo+ICAgICAgIHNsYXZlX2Rldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9IV19UQzsNCj4g
ICAgICAgc2xhdmVfZGV2LT5mZWF0dXJlcyB8PSBORVRJRl9GX0xMVFg7DQo+ICAgICAgIHNsYXZl
X2Rldi0+ZXRodG9vbF9vcHMgPSAmZHNhX3NsYXZlX2V0aHRvb2xfb3BzOw0KPg0KDQo=
