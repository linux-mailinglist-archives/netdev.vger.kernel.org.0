Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DA920DFBC
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389157AbgF2UjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731725AbgF2TOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:15 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-ve1eur02on060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe06::60e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E16C08E89D;
        Sun, 28 Jun 2020 22:37:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jfb7CM5J3OylY9Or5A63W3kTPMEWs1iKY2PjpgUQojRSpwGdmTP82VD0VWP79z2KjCgMK28P8RDtqxqowRJEZBz4sDH+M6fVfcR0x0rqP2An4OeqlEdbw+7+uqYVsUySGiJ8Ol94uobmq+e7yMwc6WH+GxEvvk/DkgGa9mkZccWdMV1oTo6qB3z71Qm8ZX1Smdjp+6bX6s/bKZIkv8o036wor86OQHRS8m+H+L7a78des0eQ0kAiAIOGr2FL7LNRb62fvR8snL3bKzs432NzfAfqk7TOiugVM3bcqtEbB6ROYOepfFgCcA6REFzf/q6Lt1p/77NYz2uPUbR1o7AzCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0iJIAu8XyEGqq7bpwJbi/vPG/wn37SJEk+A4jofqio=;
 b=RSqUFpn50BMzywts4uHghYe7GfQzM9UfOXrL8jKgnFr+SMHttwZv0/6iUzrdJIZOBoiENZ2znHL2rquHinIQKaxaCW0/1Dy6iONFAtj2L1mnhAcv4kxe49QJNKb/0aFvlZ9uRbxAteYhFjzmzOWNWeDAbJelm65RsCqkoLpnIsdYR91945AJ+eHhaLmJgwZAAS+QVzWX3h2rFhznrx9JYjx1qzfELJ9VCGr+gdf4c+P9hGduwqS1q2ccLrov9naN9wO/AHQUCmRqfl5m/OS27QZvxRgnc1Rk+UIeI5yJDHJBMP8PBemARNyh5sJM16+4ngfSHmPjnH6dWFR8GMbLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0iJIAu8XyEGqq7bpwJbi/vPG/wn37SJEk+A4jofqio=;
 b=izSBJsHhLaWbc7RcrniANwO+JI/bmDaCM32yGS4G6Di+T8exIS78GTO1g9+mrwHzNTcMpwu9HMAkuTbnWMGSzEa+g6ejtuqgdzhjH3C/bqZ5oS93kuEFesAH8gW1GMbhhWEfTAsD1005N4gMGu2O+nsmAkJ+CN8fHddgvDVtcqs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6972.eurprd04.prod.outlook.com (2603:10a6:10:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 05:37:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7564:54a2:a35e:1066]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7564:54a2:a35e:1066%9]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 05:37:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Michael Walle <michael@walle.cc>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Thread-Topic: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Thread-Index: AQHWE9It45mk5G6f2ES/KFIAprd1aah7fVCAgEnofYCAJE1mgIAABUIAgAXJWtA=
Date:   Mon, 29 Jun 2020 05:37:00 +0000
Message-ID: <DB8PR04MB67958DCE4BA9D0EC67731049E66E0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
In-Reply-To: <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fbbec9ab-18a7-4b42-fd49-08d81bee7229
x-ms-traffictypediagnostic: DB8PR04MB6972:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB69725C92BC530114FD33C730E66E0@DB8PR04MB6972.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PJOGZ7hsyRuHksWiK9YaW+yroEq0ey/n5lWRa51IeKspo7dVytYy46OoYfwZoqZSYc3PyUuFCZRa3wzENc6/FawPr2lT0yi6LJVAHwqlPW5JYsUagW/5q5MCr3gnyh1FF8mKcWsBMXZKwpAfMS9v33UCl/oB6cvEl4L5Czfhfa1aScDazhU9mSaa2z4cH/Un6dQgE5ZtNqG/srBb5pClK83/eOE+wKCSFqoPtGvU0PcuUIsQxnleKvMO4Bkr7kMTVhA2GO0jGqPtLBI0CHP0Y5TVI+8io/mAkGQnHmx0szYguXWFje/B1ur47qyIzN8hFPMxpA2KW/XiPVHzMm2zA3edvkL9bA97884gdZOl7+y5OkkM0NjAXuWen7zzVCCocomWRZjexfyx/nPu3oUo6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(83380400001)(966005)(86362001)(478600001)(4326008)(5660300002)(52536014)(316002)(8936002)(45080400002)(26005)(55016002)(66556008)(9686003)(71200400001)(2906002)(64756008)(66446008)(8676002)(7696005)(186003)(66476007)(66946007)(54906003)(110136005)(83080400001)(76116006)(53546011)(6506007)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: RPwhuq8irekCDH0JqwAtDsmocU6Wt2by8k3dt+pGeXKBY63wSmzcZOPQDv1Kk0RIROhvJ2gmmkAQcH0cWs56/Ak46J7bewcDG5JUonlpE7Faarjn1ZjNqHqVAJBi+f6D44C4Aj62RWAeFs47P+cy/9WZOPZN+317wbWBx7fCsurtSgM4nCpEv2SXj84RBlgwgUwyibgbRSGTs7Sun9IJw1wFQNr696FYUJIW6oyBKSUNuBR5ey4434DTd/eRai9T5yd52vfTUdXLdnfhNCadQT4cY5ebTJAqyroebOHGcYewgyM78x7FaBTmdJ6U7oPGEwEcw1tximR2OWVdihObE+FjZQ384zIdJWTuTaIqxojs8Gs6SV2vt4+twEnA+3iDIl4wZ9VlqTfep+bi5JoevSjm3oKzadN6GF0d7K9TxaSMn+Frmq2GVWXqcRl8dKQYCt3p6fNmS9+k9CrCobamOIreWTLKmGKydaag3QLjX9Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbbec9ab-18a7-4b42-fd49-08d81bee7229
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 05:37:00.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JBHg54NOaHGXPAANv8++M993tXST76YOnSI3FkhxVJ9IwDS3q1cf22gHfiYwKxIcYuG3PCbE8sHNUW1oKr7Yjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6972
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ25pyIMjXml6UgMjA6NTcNCj4g
VG86IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+OyBKb2FraW0gWmhhbmcNCj4gPHFp
YW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsg
ZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBsaW51eC1jYW4tbmV4dC9mbGV4Y2FuXSBjYW46IGZs
ZXhjYW46IGZpeCBUREMgZmVhdHVyZQ0KPiANCj4gT24gNi8yNS8yMCAyOjM3IFBNLCBNaWNoYWVs
IFdhbGxlIHdyb3RlOg0KPiA+IEFtIDIwMjAtMDYtMDIgMTI6MTUsIHNjaHJpZWIgTWljaGFlbCBX
YWxsZToNCj4gPj4gSGkgTWFyYywNCj4gPj4NCj4gPj4gQW0gMjAyMC0wNC0xNiAxMTo0MSwgc2No
cmllYiBKb2FraW0gWmhhbmc6DQo+ID4+PiBIaSBNYXJjLA0KPiA+Pj4NCj4gPj4+IEhvdyBhYm91
dCBGbGV4Q0FOIEZEIHBhdGNoIHNldCwgaXQgaXMgcGVuZGluZyBmb3IgYSBsb25nIHRpbWUuIE1h
bnkNCj4gPj4+IHdvcmsgd291bGQgYmFzZSBvbiBpdCwgd2UgYXJlIGhhcHB5IHRvIHNlZSBpdCBp
biB1cHN0cmVhbSBtYWlubGluZQ0KPiA+Pj4gQVNBUC4NCj4gPj4+DQo+ID4+PiBNaWNoYWVsIFdh
bGxlIGFsc28gZ2l2ZXMgb3V0IHRoZSB0ZXN0LWJ5IHRhZzoNCj4gPj4+IAlUZXN0ZWQtYnk6IE1p
Y2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+DQo+ID4+DQo+ID4+IFRoZXJlIHNlZW1zIHRv
IGJlIG5vIGFjdGl2aXR5IGZvciBtb250aHMgaGVyZS4gQW55IHJlYXNvbiBmb3IgdGhhdD8NCj4g
Pj4gSXMgdGhlcmUgYW55dGhpbmcgd2UgY2FuIGRvIHRvIHNwZWVkIHRoaW5ncyB1cD8NCj4gPg0K
PiA+IHBpbmcuLiBUaGVyZSBhcmUgbm8gcmVwbGllcyBvciBhbnl0aGluZy4gU29ycnkgYnV0IHRo
aXMgaXMgcmVhbGx5DQo+ID4gYW5ub3lpbmcgYW5kIGZydXN0cmF0aW5nLg0KPiA+DQo+ID4gTWFy
YywgaXMgdGhlcmUgYW55dGhpbmcgd3Jvbmcgd2l0aCB0aGUgZmxleGNhbiBwYXRjaGVzPw0KPiAN
Cj4gSSd2ZSBjbGVhbmVkIHVwIHRoZSBwYXRjaGVzIGEgYml0LCBjYW4geW91IHRlc3QgdGhpcyBi
cmFuY2g6DQo+IA0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2su
Y29tLz91cmw9aHR0cHMlM0ElMkYlMkZnaXQua2Vybg0KPiBlbC5vcmclMkZwdWIlMkZzY20lMkZs
aW51eCUyRmtlcm5lbCUyRmdpdCUyRm1rbCUyRmxpbnV4LWNhbi1uZXh0LmdpdCUyDQo+IEZsb2cl
MkYlM0ZoJTNEZmxleGNhbiZhbXA7ZGF0YT0wMiU3QzAxJTdDcWlhbmdxaW5nLnpoYW5nJTQwbnhw
LmNvDQo+IG0lN0NkZGJlOTAxOWZhZTg0NjQxMTY0NTA4ZDgxOTA3MzEyOSU3QzY4NmVhMWQzYmMy
YjRjNmZhOTJjZDk5Yw0KPiA1YzMwMTYzNSU3QzAlN0MwJTdDNjM3Mjg2ODY1OTYxNTY0MDYxJmFt
cDtzZGF0YT1CbTB1eW54dWVGJTJGDQo+IFdwRUNUOGF5ZnFReGglMkZNWW5GQ0xpeHZaTHZTZ1Vn
STQlM0QmYW1wO3Jlc2VydmVkPTANCg0KSGkgTWFyYywNCg0KVGhhbmsgeW91IHZlcnkgbXVjaCBm
b3IgeW91ciBlZmZvcnQgdG8gY2xlYW4gdXAgdGhlIGNvZGUuIEkgaGF2ZSB0ZXN0IHRoZSBwYXRj
aCBzZXQsIGl0IGNhbiB3b3JrIGZpbmUgYXQgbXkgc2lkZS4NCg0KQnV0LCBhIHBhdGNoIG1heSBi
ZSBpZ25vcmVkLCBjb3VsZCB5b3UgaGVscCBhZGQgYmFjayBpdD8gT3IgeW91IGFyZSB1bnNhdGlz
ZmllZCB3aXRoIGl0LCBJIGNhbiBpbXByb3ZlIGl0IGFjY29yZGluZyB0byB5b3VyIG9waW5pb24u
DQoNCmNvbW1pdCBkNmFkNWNjOTYyMjllMjhlNGYyZjA5NjAyNzcxMDJlZTE0MjU3N2VkDQpBdXRo
b3I6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQpEYXRlOiAgIEZyaSBK
dWwgMTIgMDg6MDI6NTEgMjAxOSArMDAwMA0KDQogICAgY2FuOiBmbGV4Y2FuOiBhZGQgSVNPIENB
TiBGRCBmZWF0dXJlIHN1cHBvcnQNCg0KICAgIElTTyBDQU4gRkQgaXMgaW50cm9kdWNlZCB0byBp
bmNyZWFzZSB0aGUgZmFpbHR1cmUgZGV0ZWN0aW9uIGNhcGFiaWxpdHkNCiAgICB0aGFuIG5vbi1J
U08gQ0FOIEZELiBUaGUgbm9uLUlTTyBDQU4gRkQgaXMgc3RpbGwgc3VwcG9ydGVkIGJ5IEZsZXhD
QU4gc28NCiAgICB0aGF0IGl0IGNhbiBiZSB1c2VkIG1haW5seSBkdXJpbmcgYW4gaW50ZXJtZWRp
YXRlIHBoYXNlLCBmb3IgZXZhbHVhdGlvbg0KICAgIGFuZCBkZXZlbG9wbWVudCBwdXJwb3Nlcy4N
Cg0KICAgIFRoZXJlZm9yZSwgaXQgaXMgc3Ryb25nbHkgcmVjb21tZW5kZWQgdG8gY29uZmlndXJl
IEZsZXhDQU4gdG8gdGhlIElTTw0KICAgIENBTiBGRCBwcm90b2NvbCBieSBzZXR0aW5nIHRoZSBJ
U09DQU5GREVOIGZpZWxkIGluIHRoZSBDVFJMMiByZWdpc3Rlci4NCg0KICAgIE5PVEU6IElmIHlv
dSBvbmx5IHNldCAiZmQgb24iLCBkcml2ZXIgd2lsbCB1c2UgSVNPIEZEIG1vZGUgYnkgZGVmYXVs
dC4NCiAgICBZb3Ugc2hvdWxkIHNldCAiZmQtbm9uLWlzbyBvbiIgYWZ0ZXIgc2V0dGluZyAiZmQg
b24iIGlmIHlvdSB3YW50IHRvIHVzZQ0KICAgIE5PTiBJU08gRkQgbW9kZS4NCg0KICAgIFNpZ25l
ZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQogICAgU2ln
bmVkLW9mZi1ieTogTWFyYyBLbGVpbmUtQnVkZGUgPG1rbEBwZW5ndXRyb25peC5kZT4NCg0KQW5k
LCBpZiBpdCBpcyBva2F5IGZvciB5b3UsIGJlbG93IHBhdGNoIGNvdWxkIHlvdSBhbHNvIHBpY2sg
dXA/DQpjYW46IGZsZXhjYW46IGRpc2FibGUgcnVudGltZSBQTSBpZiByZWdpc3RlciBmbGV4Y2Fu
ZGV2IGZhaWxlZCA6IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4LWNhbi9tc2cw
MzE0Ni5odG1sDQoNCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IE1hcmMNCj4gDQo+
IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVk
ZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAgICAgfA0KPiBo
dHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMl
M0ElMkYlMkZ3d3cucA0KPiBlbmd1dHJvbml4LmRlJTJGJmFtcDtkYXRhPTAyJTdDMDElN0NxaWFu
Z3FpbmcuemhhbmclNDBueHAuY29tJTdDZA0KPiBkYmU5MDE5ZmFlODQ2NDExNjQ1MDhkODE5MDcz
MTI5JTdDNjg2ZWExZDNiYzJiNGM2ZmE5MmNkOTljNWMzMDE2Mw0KPiA1JTdDMCU3QzAlN0M2Mzcy
ODY4NjU5NjE1NjQwNjEmYW1wO3NkYXRhPVUzT1F5a3FzU0UzNUF6OUNWem5xDQo+IENrMXJsM0hj
NlV2RVJhUHVoJTJCVmpIaXclM0QmYW1wO3Jlc2VydmVkPTAgIHwNCj4gVmVydHJldHVuZyBXZXN0
L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRz
Z2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1
NSB8DQo=
