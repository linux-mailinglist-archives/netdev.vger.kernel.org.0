Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39EAD290396
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406670AbgJPK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:57:36 -0400
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:20449
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395565AbgJPK5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 06:57:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lk+tzh0VMDSlAknQBPCVW7mJIjW5YZzoQhHiMrqGpayW3Yo6cRBbOtorH2a2JOgGgNPkwQP/b5cz7iKfNWikyApE37M9mcPsMU7r5GDB2z5ZKAmJgji8h/S/jyrpU8CJnPfJx62CXyRRf8ar9wug6ngSB4vnS8K3wHDVxhkiguZ9CogH8JB5k4XTtiQCoKt0WX/t+GAkgdJPN2HMVyDyMV3IZ7yn+KarJzuuCrVXN8YAAL/rEvaqGnCCezrD2M3iXXEWjgAsBWAfn7tcFmFnUIevBodvMzSVKE3loY/n0TdgrFKM5vgDP92XR6YQyrP5Mgqhgg+VjiC5xZQs5CaCFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66iGkTjQSTclV4EjAM8SFdlbrdrLuZluqKmBCLoC1d0=;
 b=NrUt6ABSGCn7XQFUfas/NDOX9gYEkpR0CjJLk+bir+7nftt7PHY8t43PaR8zhMuSSiov/j12KyRdI7I2cnJQC0ucpuxhVpzTlOOoaeWoEgbr3BZOSyshvVgP4/VNDpKi0pme1IC4fH+e6SFlRh6XVoohpE/FeNDiTN8NzGQgkdX0QT3CkJkmsLYxKOZ7N8DfbISK6ekLMJ2OniM6sj85yqFrqMH29kfbBEAUeT9HG6DLeMGq/dbHvde09yUm11RUFzsr1DEsoISl/UUtZINXUj6thOXBMUcl0VOFMwZ/Cfm118ichnXNa+da0utb0iBEKVfY/b95mY6tCUs8M1NbHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66iGkTjQSTclV4EjAM8SFdlbrdrLuZluqKmBCLoC1d0=;
 b=JXaa+il1KViaIPXdRmFZZBF9aRyKgnKyXnMG5tBavw85orVuUzfloPCL3eUoy99l0lEb+kv6TXlbjqL0wh3MaCstdosJbPzFBMDKHNtBnfD7cDJjspaGHBFp0xO+kzaJJhSQlB6RlBVk3UiKUHOo0xbbjT9/ZlXydJeGAwwF/fg=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3851.eurprd04.prod.outlook.com (2603:10a6:8:12::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 16 Oct
 2020 10:57:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 10:57:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
Thread-Topic: [PATCH 5/6] can: flexcan: add CAN wakeup function for i.MX8QM
Thread-Index: AQHWo39An99v7VNKtkiYHjTJFb8gxqmZwW4AgAAFs9CAADP4sIAAD1AAgAAB1MA=
Date:   Fri, 16 Oct 2020 10:57:29 +0000
Message-ID: <DB8PR04MB67954A044B1B67BBE48B9D24E6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-6-qiangqing.zhang@nxp.com>
 <0e3f5abc-6baf-53e2-959b-793dfd41c17b@pengutronix.de>
 <DB8PR04MB6795DEDFA271889A162539EFE6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67952A058934D5013946EE97E6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <44f939d8-81a5-bd8d-d6a9-3ca990abeb55@pengutronix.de>
In-Reply-To: <44f939d8-81a5-bd8d-d6a9-3ca990abeb55@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c69e259d-febe-4bda-cbd3-08d871c246ab
x-ms-traffictypediagnostic: DB3PR0402MB3851:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB38517F93B90096A11A440C2CE6030@DB3PR0402MB3851.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8YuSVe8Nm0RLh6X4oy6jhskaf6JRskL5QWDtRNKQ7IVGvLtB3+cq+LqJrH3Y/J6VB+Qr2KVqda2VMLcPNxnqFCcjsH4h0Tby85wV29HJMtDutzTM67BfcyfuyTmB+V3G/KPyiD/JYljgLD9YTKjbEu2lBzOSTgDa1bNYRhVz3uKlnnm6NN9/dFldV5FD4EIqX3Ah901EZfba8ZiryWDYJiZ4hESkd2eOS1T95ajTFsjhbURS3c8F+igyM48NRjCaQ3y33UykbW6CZba0xexYVy4olE4qjZHKCYtbrjpq0eeGyrzR0ADw3YTWm3c2SViaI0DDwLC2KOMRcs9eIbX9eH9SkQBmU+mQKuycgOdhkmpMMGuaQNUUrc9umDuczoi/Cm849qXi7vslyjkgBhhMVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(2906002)(8936002)(76116006)(66476007)(71200400001)(64756008)(4326008)(83380400001)(66446008)(66556008)(316002)(66946007)(110136005)(54906003)(8676002)(86362001)(186003)(53546011)(478600001)(6506007)(26005)(55016002)(966005)(7696005)(5660300002)(33656002)(52536014)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FwBNpHtFKhq23R0YHyWm3UqmUPUWfYHM93kHyciQz9bLEj1gEytrnykraVQM9UjWXvEPcgsOOB++Pct9QfM8YGwQeK1xOip6mqftsUqHUoXI4WUi7OIwfM4lAb2d7w84zOOHk4pXxwjAvxNMzwKcEMuD49ipWxNDd1FuVTCeeVyeMXAew5VSHt2QevH9xbOW5l5vLheGB3P1/cbGVLEQuqXa73gxmZ+rhGiJMp1U2P1Xq6+8hnJyhjiUWFGofkF3t9Ve+J9k6HJPl8t02H4NaGlLzs5SajjRWkJxbrNSwXb/S0P2pR0FgDYKPw2kpPoFwQDplJcWj9dYcNi3Gzz6DAp8nkG05SXu7f+4zp2nz0dsQ2jzSo9RkZFcFj2hOAjN+BHjtPUqDlCvYbkZZRrZiSxIvLQeJcHKeEsH4g3rxRO1P4V+p2olfLBlnoiXI/4/CC6ILdA0gS0HEOd6/u1+CtgPxuXZzM6/L/Q9qFtTtA51cP2r89mppoAwk405ieVWsqd0D9uXE3cuTo5JXvE7IOj/w8kP8m9fpSwO4bqbtGYno8k0+8Hz+UBkRLZEdPLiwYlBg+MG+/mUrrGtR0v47YQkHC1w1GDjuNBYdaBMBOoD3Kk+NGkgjgVR3dWDOe7NYa4jSOaP7z2HWav9CYXnEw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c69e259d-febe-4bda-cbd3-08d871c246ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 10:57:29.4430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/2h6157FKTqWViIMMHKR2HClJHE5r+4xHyLp8uwGf2Wcege5ejTYhLtivkldiBhpAcRgNgZVaomwevIIorbgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3851
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQxMOaciDE2
5pelIDE4OjQwDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsg
cm9iaCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1
dHJvbml4LmRlDQo+IENjOiBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBZaW5nIExpdQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgUGVuZyBG
YW4gPHBlbmcuZmFuQG54cC5jb20+Ow0KPiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBQYW5r
YWogQmFuc2FsIDxwYW5rYWouYmFuc2FsQG54cC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDUvNl0gY2FuOiBmbGV4Y2FuOiBhZGQgQ0FO
IHdha2V1cCBmdW5jdGlvbiBmb3IgaS5NWDhRTQ0KPiANCj4gT24gMTAvMTYvMjAgMTI6MDAgUE0s
IEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPj4+PiArc3RhdGljIGludCBmbGV4Y2FuX3N0b3BfbW9k
ZV9lbmFibGVfc2NmdyhzdHJ1Y3QgZmxleGNhbl9wcml2DQo+ID4+Pj4gKypwcml2LCBib29sIGVu
YWJsZWQpIHsNCj4gPj4+PiArCXU4IGlkeCA9IHByaXYtPmNhbl9pZHg7DQo+ID4+Pj4gKwl1MzIg
cnNyY19pZCwgdmFsOw0KPiA+Pj4+ICsNCj4gPj4+PiArCWlmIChpZHggPT0gMCkNCj4gPj4+PiAr
CQlyc3JjX2lkID0gSU1YX1NDX1JfQ0FOXzA7DQo+ID4+Pj4gKwllbHNlIGlmIChpZHggPT0gMSkN
Cj4gPj4+PiArCQlyc3JjX2lkID0gSU1YX1NDX1JfQ0FOXzE7DQo+ID4+Pj4gKwllbHNlDQo+ID4+
Pj4gKwkJcnNyY19pZCA9IElNWF9TQ19SX0NBTl8yOw0KPiA+Pj4NCj4gPj4+IENhbiB5b3UgaW50
cm9kdWNlIHNvbWV0aGluZyBsaWtlIGFuZCBtYWtlIHVzZSBvZiBpdDoNCj4gPj4+DQo+ID4+PiAj
ZGVmaW5lIElNWF9TQ19SX0NBTih4KQkJCSgxMDUgKyAoeCkpDQo+ID4+IE9LLg0KPiA+DQo+ID4g
SSB0aG91Z2h0IGl0IG92ZXIgYWdhaW4sIGZyb20gbXkgcG9pbnQgb2YgdmlldywgdXNlIG1hY3Jv
IGhlcmUNCj4gPiBkaXJlY3RseSBjb3VsZCBiZSBtb3JlIGludHVpdGl2ZSwgYW5kIGNhbiBhY2hp
ZXZlIGEgZGlyZWN0IGp1bXAuDQo+ID4gSWYgY2hhbmdlIHRvIGFib3ZlIHdyYXBwZXIsIG9uIHRo
ZSBjb250cmFyeSBtYWtlIGNvbmZ1c2lvbiwgYW5kDQo+ID4gZ2VuZXJhdGUgdGhlIG1hZ2ljIG51
bWJlciAxMDUuIOKYuQ0KPiANCj4gVGhlIGRlZmluZSBzaG91bGQgZ28gaW50byB0aGUgcnNyYy5o
LCBhbmQgcHJvYmFibHkgYmU6DQo+IA0KPiAjZGVmaW5lIElNWF9TQ19SX0NBTih4KQkJKElNWF9T
Q19SX0NBTl8wICsgKHgpKQ0KPiANCj4gYW5kIGlmIHlvdSBjaGFuZ2UgdGhlIGZpcm13YXJlIGlu
dGVyZmFjZSwgeW91IHByb2JhYmx5IGhhdmUgbW9yZSBwcm9ibGVtcyA6KQ0KDQpyc3JjLmg6DQog
LyoNCiAgKiBUaGVzZSBkZWZpbmVzIGFyZSB1c2VkIHRvIGluZGljYXRlIGEgcmVzb3VyY2UuIFJl
c291cmNlcyBpbmNsdWRlIHBlcmlwaGVyYWxzDQogICogYW5kIGJ1cyBtYXN0ZXJzIChidXQgbm90
IG1lbW9yeSByZWdpb25zKS4gTm90ZSBpdGVtcyBmcm9tIGxpc3Qgc2hvdWxkDQogICogbmV2ZXIg
YmUgY2hhbmdlZCBvciByZW1vdmVkIChvbmx5IGFkZGVkIHRvIGF0IHRoZSBlbmQgb2YgdGhlIGxp
c3QpLg0KICAqLw0KSG1tLCBpdCBqdXN0IGxpc3QgYWxsIHJlc291cmNlIGlkLCBhbmQgbmV2ZXIg
YmUgY2hhbmdlZC4gQW55d2F5LCBpZiB5b3UgdGhpbmsgYWJvdmUgd2F5IGlzIGJldHRlciwgSSB3
aWxsIHR1cm4gdG8gaXQuDQoNCj4gPj4+PiArDQo+ID4+Pj4gKwlpZiAoZW5hYmxlZCkNCj4gPj4+
PiArCQl2YWwgPSAxOw0KPiA+Pj4+ICsJZWxzZQ0KPiA+Pj4+ICsJCXZhbCA9IDA7DQo+ID4+Pj4g
Kw0KPiA+Pj4+ICsJLyogc3RvcCBtb2RlIHJlcXVlc3QgdmlhIHNjdSBmaXJtd2FyZSAqLw0KPiA+
Pj4+ICsJcmV0dXJuIGlteF9zY19taXNjX3NldF9jb250cm9sKHByaXYtPnNjX2lwY19oYW5kbGUs
IHJzcmNfaWQsDQo+ID4+Pj4gK0lNWF9TQ19DX0lQR19TVE9QLCB2YWwpOyB9DQo+ID4NCj4gPiBX
ZSBzdGlsbCBuZWVkIHVzZSBJTVhfU0NfQ19JUEdfU1RPUCwgd2h5IG5vdCBiZSBjb25zaXN0ZW50
Pw0KPiANCj4gU29ycnkgSSBkb24ndCBnZXQgd2hhdCB5b3Ugd2FudCB0byB0ZWxsIG1lIGhlcmUu
DQoNCk5lZWQgbWUgYWRkIElNWF9TQ19DX0lQR19TVE9QIG1hY3JvIGluIHRoZSBkcml2ZXIgZGly
ZWN0bHk/DQoNClN1Y2ggYXMsICNkZWZpbmUgSU1YX1NDX0NfSVBHX1NUT1AgNTIsIHNvIHRoYXQg
bm8gbmVlZCB0byBpbmNsdWRlIHJzcmMuaCBmaWxlIGluIHRoZSBkcml2ZXIuDQoNCkJlc3QgUmVn
YXJkcywNCkpvYWtpbSBaaGFuZw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksu
ICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVk
ZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUg
IHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0y
ODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDog
ICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
