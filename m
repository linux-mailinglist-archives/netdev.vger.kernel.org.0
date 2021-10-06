Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4EC4247DF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhJFUX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:23:57 -0400
Received: from mail-eopbgr1400114.outbound.protection.outlook.com ([40.107.140.114]:13931
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229992AbhJFUX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 16:23:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kC5R5FglBoAURcdq843JLXRZMVj1VpCFhJByXjQt14vsuVTsO96S3pGN8wPZAaIsRBnKeZ1Rep275Hy6ZQm0BPzq9VvgX1rWBiXej10v3WqCwvWczdd9OY56I8KpIjYVgrT3h75onhTkyffzsIGsWrfuqkpaxkJWtXlQCQk75K/1FxhAHbjJRnKkNERGIQSBJ43WNg5EhwEzRGXFInGFdoOxgHl3cvX33+Kopu0sGwUyObiZZYlNWXWEe2Et7xpTPx2fv6Y2ksvyVozy6xrnVoj/7xkchvY3pD041po+g5VrzYv8UNWaTKWOG/7DEU7sGL4s90twJ3kfkBIVst6FWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Leu8VVIAz691roilGiAvVEAmVdwlRoM9dKY1a0ZBMv4=;
 b=L1PXzXQMK4MkjXYrgDrszTm0yC5k9ADTDUeKd/L6ORZiU6rNaqloA4ToQSJ5SemIgQNkOnBZfxretAmwzuhd/xRExJa7nM2x85OVpKci+40aOcPvYlx86CDY/4u+T9qixqMKZ4JZIGTktrQ+Fj04jKJqLhtldqirRzasg7mQV6sWlLyxpahmCAIxifIHmNarxy9tIDUt1aKtTnZKnTQGH1AUc4rc9OS/QAqbTNlWcFbexlKV7475fDPbZxeViaLCeqD2Yy6xrKz4Brm6ebOXy4cKu8J5q+Ixjqm/x/SmJdyRffWkc5Sxl7D2atY3tVrDWEboFj7gMkKBV6+mW4RkjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Leu8VVIAz691roilGiAvVEAmVdwlRoM9dKY1a0ZBMv4=;
 b=k4GI8YypbRqYdk4o2JWrI/pyt3ncVZY4RRgpFcMapW+J+uBFsscRqZrOGiqexD3uBhlLxpOJMFhUO2JTgHtUODNrm5DkLEcyge/y97QIPUQQ6OFqPGS1/II8xRa+Ikj2JhiZhyS+lSI6LhX8qyHN50Qqw6oR97xKLQ/pDzmdfMw=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5877.jpnprd01.prod.outlook.com (2603:1096:604:c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 20:22:01 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 20:22:01 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Topic: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Index: AQHXudknyVYpSr19EUOWd3E+ko3swavGX+aAgAAJbzA=
Date:   Wed, 6 Oct 2021 20:22:01 +0000
Message-ID: <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
In-Reply-To: <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f6293f7-5c98-45d6-004c-08d98906f466
x-ms-traffictypediagnostic: OS3PR01MB5877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB58776B55200CAF95DC094CBB86B09@OS3PR01MB5877.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cUZ6rh4sCtZey0a09sP7ec+6ZMdGw224r3JSAf8ytA/ynfl8h7esin1ITh2DTRiGv4TyRZcK2tPkfxgPsYSP6i5Vs55UmXD01AQU2LOKGXVn2uKdNJJNcO8mhdhLuAhym5KWp5+f+Hil/W3272mc+KN7ijjf1yO2eautV/myyVGrsaB8gv31M6Gk785Vd+ECuDlGe4j92dvizFh1jxve2aKJz1X8WhRP5KGsd9iSa8A5QQI7UUhVOGjeINo/zCf6wYivQb68qbxHNNf0y6o0zUnpAHEb5R6gsJoMWhPEJnqMDAWMIC2ARvD+WbS1S1kVfQJod/l1lxHlXoTpY+ptJfRH3vkxHXGTCszXptz55rC057E4840fW/pDhHzIOkuQto5PQZhKBLpvMQ9EzEXih5INVIco6dKEA2Mq5TFRzZBmDB583uhZZHDePnR9Z703byCGlK/Y+QpYoJxMoSiWZLeTW0EjB+CAP7zYDSpcP5sLKUBOUnrIxA/GxPOJrnxP/y92Xo4W4DWiN9LynQRFt7FsIerGjvvob12DLMcHkLRLcvUPmgntbhqWnNqw7TxrWWe83uRrxnGBMw1x/HXFQ80t/60mYvHiwuKYPgQycY7iO19OI6KnhlJ8N0ABSJ7Cd2vBzxUuOT5vAph032rpIwDZtOPGfeNwLXhd/7AB0OulUs9stUXF5g81AAQn3xc746WxW/JV93vIs8HdXbVzCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(86362001)(64756008)(66946007)(66556008)(6506007)(66476007)(53546011)(33656002)(66446008)(508600001)(5660300002)(38100700002)(9686003)(8936002)(54906003)(186003)(7416002)(2906002)(122000001)(83380400001)(76116006)(7696005)(4326008)(26005)(107886003)(38070700005)(71200400001)(52536014)(110136005)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGZtai9RYWhxNTRBaExoQ2IxZU5MMzZQdWhEbnEwYnhxZ2lIazRjTVYxdFIx?=
 =?utf-8?B?TWt2S2RKZWs0RVhSZlpONEYzR1BKQUxXakpmSk9nc2w5QU53RUhRQVNlZFA2?=
 =?utf-8?B?V09lVWtkejBFZU4wOGwxbXJqdnFUcTNmc3hsdFQ4alBiTFhybHRuUm8rakhv?=
 =?utf-8?B?UCtHTjVxRHBxY1FPQ0VoaFhQNkRYU3MzYjNaSElBdlRqd0VMSXhVdER1dXhy?=
 =?utf-8?B?TjJvdi9lLy9zU3pFYU0yQjQrWkNYdi9VL1FIL3pIbXh4cWpsdGMySkR1NG9S?=
 =?utf-8?B?YmtLR3ZtUHQxRm16bnJSbDA0RzlnVW51c0Vkb2xobDBBYkNHNEljUXVqOVAr?=
 =?utf-8?B?bXV0N0pyVk5JeGs4ZmlUTS9HeWN4WnJacDlPZzBBWHJpMWJyWlF1Y2xFaDJm?=
 =?utf-8?B?ZEgzSmdrRlgyQXJYSGI5MWE4OHZja2xWQXkvY2pQdWlRdVkydW1GVkdQOVlF?=
 =?utf-8?B?NlJaS2dKRTZoWExidk9nbjJnbVhqcFBwV3JHTmRINGx4eTdLTmF2R3VuMzUy?=
 =?utf-8?B?NW5EM0tod1lnTVpuRzlOaHhhYzNHeHlxYjZPS0tyZENFNnlhWjFyTklOc3E2?=
 =?utf-8?B?OGEzMENWOW9NRVkraXk0ZS9PY2l0eWpHc1RMaFdBajJGYnJxanFFblRxOFc5?=
 =?utf-8?B?THpRQ2UrUnR2TktvZit0eTVwQmYvcjZGaGdVVkVrYXo2TUtWdHYzdWdoNEo3?=
 =?utf-8?B?aERWRUxUZ2taTXpzOVdvOFhYQndFQlNIb0s2VThqU1BkRDNqMFZVQXVuamtZ?=
 =?utf-8?B?RXRNTDQreHJhcmNZNnlZa1BoejNOZytYVkJjTUE0SjBVMGcxSE5QMncxMVlu?=
 =?utf-8?B?aDFTSklzSWllQko1ZEwwZGUrZjRXMC9uNHkvTDlLYmtGajhLTnQ1S08wWTNG?=
 =?utf-8?B?VktoZ2dYTUt0K1IvY2VwNWxaa0pDa2xVc1ovS0FRWkZyZ1VKZ0xZdER1cndK?=
 =?utf-8?B?eFNBOHFwNXVIVUt4ZG1SK2t5SjZEaGY5RHE4amVweTg0dk1CaDdjK0xOQmlt?=
 =?utf-8?B?TXJGT0NWMWplQ0RqekpzSDIvRGJaaDB0YWtKK0owVEVGbDVQV1ZUZ1Z2UTg5?=
 =?utf-8?B?NWdDaVd6WDRYakh1VDJKdm9rN0lPanc0c1lhSlNsc1RsUVBNRXRrQ1ZTNy9N?=
 =?utf-8?B?Y3U5Z1lDcktpc0VJY3hzL1FLMDBVc2wyRnd4RnhOZ3pIdGU1VGpONlU2NlU3?=
 =?utf-8?B?Qk13aDVUVkxoWlArSUhNdzUvUHZOTVdVeDZVY3NEV1JFTkdSWllQRUN6MlBr?=
 =?utf-8?B?WVRoejBQaWRVNDByMTh5L0lpUVZTcy9XdXRzWFVRSEllc21CRE1ja3Y4TENq?=
 =?utf-8?B?d3lEQ09NczJxMjJiMmt3MXQxM1hueE94NGlHT3lKREx4MVdOWkJvQy94aXFv?=
 =?utf-8?B?VERaT1gwOS96MDAzaHdJbHgvdDZSNnVuZ1NHT3FPSUh6WmtDQVZrd0U1Q1lV?=
 =?utf-8?B?L1ppaElaT1JTK1VNcWdkV3p3VGhZY0xUeGVSbDVwZiszYmVpMjNZZVVFTCtj?=
 =?utf-8?B?K1hpbkc5SzV6dG1jeXFETGJvdFlxeHhIWWdVTnNqRzJiNU5QRGZ1Uk5aRlpD?=
 =?utf-8?B?d2krdjMrRmJxM3N0enJNSlhtdFFianZnY2hhQk04OUUzb3puVExQQVhqaUdv?=
 =?utf-8?B?K1YyM3lHNVFIVE1HR1B5OFlFdFJFRklDU0x1azk0WTcxNUlHVUdZUXRRdVV1?=
 =?utf-8?B?U2lpU1o2VlBWWEpnUmgzODNrNExSeCtlZVU0TWpBSGI4V2I3RVBZSnh5eHZN?=
 =?utf-8?Q?M/DJYWJhshyH0Ww7vY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6293f7-5c98-45d6-004c-08d98906f466
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 20:22:01.1037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9SkUByFTV+kEd1Bl7upuS8wqE3VoQ65PBKDnxQW38M8NjfU7WHatpuLdAd0J0oMQgBh3Vqy47RQvsa1AlZExwT3/EOohmSWAXmfGBdv6g8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5877
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpUaGFua3MgZm9yIHRoZWZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UkZDIDA3LzEyXSByYXZiOiBGaWxsdXAgcmF2Yl9yeF9nYmV0aCgpIHN0dWINCj4gDQo+IE9uIDEw
LzUvMjEgMjowNiBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IEZpbGx1cCByYXZiX3J4X2di
ZXRoKCkgZnVuY3Rpb24gdG8gc3VwcG9ydCBSWi9HMkwuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGFs
c28gcmVuYW1lcyByYXZiX3JjYXJfcnggdG8gcmF2Yl9yeF9yY2FyIHRvIGJlIGNvbnNpc3RlbnQN
Cj4gPiB3aXRoIHRoZSBuYW1pbmcgY29udmVudGlvbiB1c2VkIGluIHNoX2V0aCBkcml2ZXIuDQo+
ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5j
b20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXINCj4gPiA8cHJhYmhha2FyLm1haGFk
ZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPlsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCAzNzE2NGE5ODMxNTYuLjQyNTczZWFj
ODJiOSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4u
Yw0KPiA+IEBAIC03MjAsNiArNzIwLDIzIEBAIHN0YXRpYyB2b2lkIHJhdmJfZ2V0X3R4X3RzdGFt
cChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmRldikNCj4gPiAgCX0NCj4gPiAgfQ0KPiA+DQo+ID4g
K3N0YXRpYyB2b2lkIHJhdmJfcnhfY3N1bV9nYmV0aChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKSB7DQo+
ID4gKwl1OCAqaHdfY3N1bTsNCj4gPiArDQo+ID4gKwkvKiBUaGUgaGFyZHdhcmUgY2hlY2tzdW0g
aXMgY29udGFpbmVkIGluIHNpemVvZihfX3N1bTE2KSAoMikgYnl0ZXMNCj4gPiArCSAqIGFwcGVu
ZGVkIHRvIHBhY2tldCBkYXRhDQo+ID4gKwkgKi8NCj4gPiArCWlmICh1bmxpa2VseShza2ItPmxl
biA8IHNpemVvZihfX3N1bTE2KSkpDQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJaHdfY3N1bSA9IHNr
Yl90YWlsX3BvaW50ZXIoc2tiKSAtIHNpemVvZihfX3N1bTE2KTsNCj4gDQo+ICAgIE5vdCAzMi1i
aXQ/IFRoZSBtYW51YWwgc2F5cyB0aGUgSVAgY2hlY2tzdW0gaXMgc3RvcmVkIGluIHRoZSBmaXJz
dCAyDQo+IGJ5dGVzLg0KDQpJdCBpcyAxNiBiaXQuIEl0IGlzIG9uIGxhc3QgMiBieXRlcy4NCg0K
PiANCj4gPiArDQo+ID4gKwlpZiAoKmh3X2NzdW0gPT0gMCkNCj4gDQo+ICAgIFlvdSBvbmx5IGNo
ZWNrIHRoZSAxc3QgYnl0ZSwgbm90IHRoZSBmdWxsIGNoZWNrc3VtIQ0KDQpBcyBJIHNhaWQgZWFy
bGllciwgIjAiIHZhbHVlIG9uIGxhc3QgMTYgYml0LCBtZWFucyBubyBjaGVja3N1bSBlcnJvci4N
Cg0KPiANCj4gPiArCQlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX1VOTkVDRVNTQVJZOw0KPiA+
ICsJZWxzZQ0KPiA+ICsJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fTk9ORTsNCj4gDQo+ICAg
U28gdGhlIFRDUC9VRFAvSUNNUCBjaGVja3N1bXMgYXJlIG5vdCBkZWFsdCB3aXRoPyBXaHkgZW5h
YmxlIHRoZW0gdGhlbj8NCg0KSWYgbGFzdCAyYnl0ZXMgaXMgemVybywgbWVhbnMgdGhlcmUgaXMg
bm8gY2hlY2tzdW0gZXJyb3Igdy5yLnRvIFRDUC9VRFAvSUNNUCBjaGVja3N1bXMuDQoNClJaL0cy
TCBjaGVja3N1bSBwYXJ0IGlzIGRpZmZlcmVudCBmcm9tIFItQ2FyIEdlbjMuIFRoZXJlIGlzIG5v
IFRPRSBibG9jayBhdCBhbGwgZm9yIFItQ2FyIEdlbjMuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4g
DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0YXRpYyB2b2lkIHJhdmJfcnhfY3N1bShzdHJ1Y3Qgc2tf
YnVmZiAqc2tiKQ0KPiANCj4gc3RhdGljIHZvaWQgcmF2Yl9yeF9jc3VtX3JjYXIoc3RydWN0IHNr
X2J1ZmYgKnNrYik/DQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZXkNCg==
