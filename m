Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02E2A232E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 03:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKBCvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 21:51:01 -0500
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:23045
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbgKBCvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 21:51:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltAZ4M9AEsZtqRQ4IPO2whc2Qi630ie4HbxYZ0g5Q6s8jOTFfgx7RlZFwy6DHQLFo9Ln0TxuqBoNPfxoExGSLdSuHpy7kcalV+vRHfIMiqg5THOyycSwKzakqP31mAxOUTtCUkPwUwcFKRS/E8v5Etu82TvAqtzNWlPk+ifjLgB98IVPtBEfaf0Q5hKXxXKYJ5RWn/fG3mkV8ojcJiyY59HKV26bCblRYH/rbbz0UThT/AjDlpdvr/YS+iuS8F/k7g5a+cuLmZ2m5KNc87ZG5jcPZZx1WpVmlwMQk+WyUhtlzdFZhkG5gWDty+ariDkuUzzoyj9N3xESo6CHTf9e6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7hk+/YCRKe6uz6K3w7er8FM1aK2eW1cfUiQpbfJkio=;
 b=TwxaOQ4K3/9xIIrzLx4415hqBuHnG13TMC4n6bfTq5OWX9k6sVBSgIT36js8wW6930GyHRvj3HhPoyClzVV1S++Po1hyOQTUZt+X/dQPjAcjSFa8rMNYF02Pf9XscPb6HpEysB6xrTxMjdFvOfxYbZYu6NRbjR0/XwuVhR4ysAfMZUVEvI6H+X1ovLr0hTBmTJKeV7/RGrMCbqVH7NJcYGGVDPEhMGbJ5Xet+LGVKjX2mRYuKpYPkOdUr3w0u2eEg6pKa0fphIszCRRX+Mv7Wuk3Y7dTk/BrYCqprlQJRuO2RTMKESKsT/yQAp6fmhTQj6tk+OVXaA3N5xACRC6WKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7hk+/YCRKe6uz6K3w7er8FM1aK2eW1cfUiQpbfJkio=;
 b=NjYIru8dpBwqcefPdWfh8V5oy0sWcUgyCm7rGYMbJi89UnMGgR6+ZZuOU00HSQ+lSyybw9GwnfVzgv7PHJI/aJv5SVuvXatZ2C8/gGcrTX1WVSqv3hXXKqJg5PzmPOOWuh3E2Dq9avSF0ffYIqWRIBsx6KIk7fTdSc8TbqM/S7A=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 2 Nov
 2020 02:50:55 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%8]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 02:50:55 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>
CC:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 1/6] firmware: imx: always export SCU symbols
Thread-Topic: [PATCH V4 1/6] firmware: imx: always export SCU symbols
Thread-Index: AQHWp2phbfWjD2H3H0e5mz6xLBAGVamy9mqAgAE+UUA=
Date:   Mon, 2 Nov 2020 02:50:55 +0000
Message-ID: <DB8PR04MB679590BED0CD0D8FC5C4C418E6100@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
 <20201021052437.3763-2-qiangqing.zhang@nxp.com>
 <20201101074300.GF31601@dragon>
In-Reply-To: <20201101074300.GF31601@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 361f25d0-0c76-414c-0b34-08d87eda1ebf
x-ms-traffictypediagnostic: DBAPR04MB7430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7430594B4B77368D1637A9E5E6100@DBAPR04MB7430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OxIYu/zZrEfU7l/Lgv+v0AFelcz34R9hf1yhlTjXgXRiq8eECewiRXDW3TGZHfxLEp9d3d03C1NGLoiftfJZB1bWkQaRwTSxNBV0EUbuEQXI42VmyLm/ePA5vRX+U04G84oaPNGBECKK/6AZQ5V0YFsDwtHPTZ8Td9y8UsxWjczC3hm3T4+371o4PNUGE3ILJYRHy1PZenbQ/u5kJrFj3+73T01l4+VXWelp0jt7TDitv7YTXpTEXwmzA9QtT3S8hk0jP3QslxbVe/M1LPICMYss34jb8h/g7/l5RU+vej7W1RfKbtKJtsJtilfKyZ2ZXVNNoG6f5oC+p196kditlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(54906003)(316002)(6916009)(71200400001)(8936002)(8676002)(66556008)(9686003)(66446008)(76116006)(64756008)(66476007)(66946007)(83380400001)(2906002)(4326008)(5660300002)(186003)(6506007)(26005)(478600001)(53546011)(86362001)(33656002)(55016002)(7696005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +lV/BdxZfH2MYl7A1GpJdAgbjbogt17icRAzZv99MXspXP+fbUmm5nTaJWmVu/mzL7NF5IzJ6Oo3dAacBOl6Y9yXYqZD6evgOxZhx0ut97u4UI+xE74IGDMd0W1q4h+/YVKP6ZAGp69nKOZpXs6R/Wgaq9YfH2gq8pM48SyFYrqF6FCd5Vk+kBhfL3LDMPoP7OCzgsgb6dcliAoFYBWFeye7bW6gtZvsmSLBwo3OC6Axx+ScFrxJudgEZQ5Jsq63yjzDzTLKQkY08ai+hKKis1Qyig5KMKQOCQld3CYPUEAUzGPmJByUYn1mTA4L03R9xj4eU8JEhdHpuepQxlaIb3lBHcf6+keu6ktOLPfvGvNBHbtzb518eVOYhOqhF0Zx4OM9L5FJ6fnF7o+TzJCEM3evrwHbZiz/54bZ/MVLTaY9BE+zW9SZGSDXHPMdGFeY4cJ+54riEynvC/0T3FFxZzBeX+Q1leLrMt8aid8xXyU2ycGpp/iVKBtUE1bU/4ghwwcrRtirJPJUx++KrjHEF8epA7pw+eegMxRBMN9AIbB0v75xIKgXMiGlgBOa55QSEg2zhzJ75TfaeX5u99Rfli/vR2u7VJZ/SGEON2HI0IlAu7UimF50JgJaUClpa0UQsMaZHkX2XPnvevnpgH2Oxw==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361f25d0-0c76-414c-0b34-08d87eda1ebf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 02:50:55.5676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vwop8m1gZXp5dCHMj7gIOaZ3cLEf1zhP5VVSsZqIDkQnOmjS3XOE61J6babarN+625lxlgC2R5fSDZ4vmsKdyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNoYXduIEd1byA8c2hhd25n
dW9Aa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMMTqMTHUwjHI1SAxNTo0Mw0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IG1rbEBwZW5ndXRyb25peC5k
ZTsgcm9iaCtkdEBrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOw0KPiBrZXJuZWxA
cGVuZ3V0cm9uaXguZGU7IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBZaW5nIExp
dQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIFY0IDEvNl0gZmlybXdhcmU6IGlteDogYWx3YXlzIGV4cG9ydCBT
Q1Ugc3ltYm9scw0KPiANCj4gT24gV2VkLCBPY3QgMjEsIDIwMjAgYXQgMDE6MjQ6MzJQTSArMDgw
MCwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IEZyb206IExpdSBZaW5nIDx2aWN0b3IubGl1QG54
cC5jb20+DQo+ID4NCj4gPiBBbHdheXMgZXhwb3J0IFNDVSBzeW1ib2xzIGZvciBib3RoIFNDVSBT
b0NzIGFuZCBub24tU0NVIFNvQ3MgdG8gYXZvaWQNCj4gPiBidWlsZCBlcnJvci4NCj4gPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IExpdSBZaW5nIDx2aWN0b3IubGl1QG54cC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTog
Sm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgaW5j
bHVkZS9saW51eC9maXJtd2FyZS9pbXgvaXBjLmggICAgICB8IDE1ICsrKysrKysrKysrKysrKw0K
PiANCj4gQ291bGQgeW91IHJlYmFzZSBpdCB0byBteSBpbXgvZHJpdmVycyBicmFuY2g/ICBUaGVy
ZSBpcyBvbmUgcGF0Y2ggZnJvbSBQZW5nDQo+IEZhbiB0aGF0IGFscmVhZHkgY2hhbmdlZCBpcGMu
aC4NCg0KDQpIaSBTaGF3biwNCg0KUGxlYXNlIGlnbm9yZSAxLzYgcGF0Y2ggc2luY2UgaXQgaGFz
IGJlZW4gZG9uZSB3aXRoIFBlbmcncyBwYXRjaC4gSSB3aWxsIHJlc2VuZCBmbGV4Y2FuIHBhdGNo
IHNldCBhZnRlciBQZW5nJ3MgcGF0Y2ggZ29lcyBpbnRvIG1haW5saW5lLg0KDQpDb3VsZCB5b3Ug
cGxlYXNlIHJldmlldyA1LzYgcGF0Y2ggd2hpY2ggaXMgc3VnZ2VzdGVkIGJ5IEZsZXhjYW4gZHJp
dmVyIG1haW50YWluZXI/IFRoYW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQoN
Cg0KPiBTaGF3bg0KPiANCj4gPiAgaW5jbHVkZS9saW51eC9maXJtd2FyZS9pbXgvc3ZjL21pc2Mu
aCB8IDIzICsrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMzgg
aW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZmlybXdh
cmUvaW14L2lwYy5oDQo+ID4gYi9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL2lteC9pcGMuaA0KPiA+
IGluZGV4IDg5MTA1NzQzNDg1OC4uMzAwZmEyNTNmYzMwIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1
ZGUvbGludXgvZmlybXdhcmUvaW14L2lwYy5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9maXJt
d2FyZS9pbXgvaXBjLmgNCj4gPiBAQCAtMzQsNiArMzQsNyBAQCBzdHJ1Y3QgaW14X3NjX3JwY19t
c2cgew0KPiA+ICAJdWludDhfdCBmdW5jOw0KPiA+ICB9Ow0KPiA+DQo+ID4gKyNpZiBJU19FTkFC
TEVEKENPTkZJR19JTVhfU0NVKQ0KPiA+ICAvKg0KPiA+ICAgKiBUaGlzIGlzIGFuIGZ1bmN0aW9u
IHRvIHNlbmQgYW4gUlBDIG1lc3NhZ2Ugb3ZlciBhbiBJUEMgY2hhbm5lbC4NCj4gPiAgICogSXQg
aXMgY2FsbGVkIGJ5IGNsaWVudC1zaWRlIFNDRlcgQVBJIGZ1bmN0aW9uIHNoaW1zLg0KPiA+IEBA
IC01NSw0ICs1NiwxOCBAQCBpbnQgaW14X3NjdV9jYWxsX3JwYyhzdHJ1Y3QgaW14X3NjX2lwYyAq
aXBjLCB2b2lkDQo+ICptc2csIGJvb2wgaGF2ZV9yZXNwKTsNCj4gPiAgICogQHJldHVybiBSZXR1
cm5zIGFuIGVycm9yIGNvZGUgKDAgPSBzdWNjZXNzLCBmYWlsZWQgaWYgPCAwKQ0KPiA+ICAgKi8N
Cj4gPiAgaW50IGlteF9zY3VfZ2V0X2hhbmRsZShzdHJ1Y3QgaW14X3NjX2lwYyAqKmlwYyk7DQo+
ID4gKw0KPiA+ICsjZWxzZQ0KPiA+ICtzdGF0aWMgaW5saW5lIGludA0KPiA+ICtpbXhfc2N1X2Nh
bGxfcnBjKHN0cnVjdCBpbXhfc2NfaXBjICppcGMsIHZvaWQgKm1zZywgYm9vbCBoYXZlX3Jlc3Ap
IHsNCj4gPiArCXJldHVybiAtRUlPOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5l
IGludCBpbXhfc2N1X2dldF9oYW5kbGUoc3RydWN0IGlteF9zY19pcGMgKippcGMpIHsNCj4gPiAr
CXJldHVybiAtRUlPOw0KPiA+ICt9DQo+ID4gKyNlbmRpZg0KPiA+ICsNCj4gPiAgI2VuZGlmIC8q
IF9TQ19JUENfSCAqLw0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL2lt
eC9zdmMvbWlzYy5oDQo+ID4gYi9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL2lteC9zdmMvbWlzYy5o
DQo+ID4gaW5kZXggMDMxZGQ0ZDNjNzY2Li5kMjU1MDQ4ZjE3ZGUgMTAwNjQ0DQo+ID4gLS0tIGEv
aW5jbHVkZS9saW51eC9maXJtd2FyZS9pbXgvc3ZjL21pc2MuaA0KPiA+ICsrKyBiL2luY2x1ZGUv
bGludXgvZmlybXdhcmUvaW14L3N2Yy9taXNjLmgNCj4gPiBAQCAtNDYsNiArNDYsNyBAQCBlbnVt
IGlteF9taXNjX2Z1bmMgew0KPiA+ICAgKiBDb250cm9sIEZ1bmN0aW9ucw0KPiA+ICAgKi8NCj4g
Pg0KPiA+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfSU1YX1NDVSkNCj4gPiAgaW50IGlteF9zY19t
aXNjX3NldF9jb250cm9sKHN0cnVjdCBpbXhfc2NfaXBjICppcGMsIHUzMiByZXNvdXJjZSwNCj4g
PiAgCQkJICAgIHU4IGN0cmwsIHUzMiB2YWwpOw0KPiA+DQo+ID4gQEAgLTU1LDQgKzU2LDI2IEBA
IGludCBpbXhfc2NfbWlzY19nZXRfY29udHJvbChzdHJ1Y3QgaW14X3NjX2lwYyAqaXBjLA0KPiA+
IHUzMiByZXNvdXJjZSwgIGludCBpbXhfc2NfcG1fY3B1X3N0YXJ0KHN0cnVjdCBpbXhfc2NfaXBj
ICppcGMsIHUzMg0KPiByZXNvdXJjZSwNCj4gPiAgCQkJYm9vbCBlbmFibGUsIHU2NCBwaHlzX2Fk
ZHIpOw0KPiA+DQo+ID4gKyNlbHNlDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50DQo+ID4gK2lteF9z
Y19taXNjX3NldF9jb250cm9sKHN0cnVjdCBpbXhfc2NfaXBjICppcGMsIHUzMiByZXNvdXJjZSwN
Cj4gPiArCQkJdTggY3RybCwgdTMyIHZhbCkNCj4gPiArew0KPiA+ICsJcmV0dXJuIC1FSU87DQo+
ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50DQo+ID4gK2lteF9zY19taXNjX2dl
dF9jb250cm9sKHN0cnVjdCBpbXhfc2NfaXBjICppcGMsIHUzMiByZXNvdXJjZSwNCj4gPiArCQkJ
dTggY3RybCwgdTMyICp2YWwpDQo+ID4gK3sNCj4gPiArCXJldHVybiAtRUlPOw0KPiA+ICt9DQo+
ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5lIGludCBpbXhfc2NfcG1fY3B1X3N0YXJ0KHN0cnVjdCBp
bXhfc2NfaXBjICppcGMsIHUzMiByZXNvdXJjZSwNCj4gPiArCQkJCSAgICAgIGJvb2wgZW5hYmxl
LCB1NjQgcGh5c19hZGRyKSB7DQo+ID4gKwlyZXR1cm4gLUVJTzsNCj4gPiArfQ0KPiA+ICsjZW5k
aWYNCj4gPiArDQo+ID4gICNlbmRpZiAvKiBfU0NfTUlTQ19BUElfSCAqLw0KPiA+IC0tDQo+ID4g
Mi4xNy4xDQo+ID4NCg==
