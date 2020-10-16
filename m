Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0661728FFB7
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 10:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405021AbgJPIGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 04:06:47 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:26624
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404952AbgJPIGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 04:06:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtbEyIRQINy1ExYMxNDqZiZo7Sw5IqXefL4YWn5YY+Rcu9LF5RaXqKvhXMVaF2iX7QBfocrGVH7nyfhaHcvAOOVBPTIzZY8O9YyAz7oWGAkF74PRvXrBUH5mTjEb1aYjjgm0H93WR76NTg0+24XsR+lv4gFGjWnWCRy2Y/pG9DwjphoZ2hBQEirz9RJzArvbmhCMJN+wdtwavy2aYU0A/rXUQPtKOgfHYAWbX/X1Mps4b9Vx22CyYLgbpSuaHIQ5S8iKz2UQsBtDn2NAqdFz41aJqI7+Joj3rsefko8NxjcuWmNLOAcsvUfNMjWAzb8S3ezJmwCPRwZRDmsXgTC0Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZDoHKTvJ43HdTCGmuNGYCniawtsucx0uEhH8kCXxqA=;
 b=W74PH5vBkUGJ9mDV+ry+zTcv6TTttC9HbbUd8HSOQNZvt1hFnZaNylRI3STf2KR3JIxKg0HTFaCFJE/GuR5uOJ1tTWPz/C3zs0W/KTE2MAMh9sslBJSkRIse+Y7zYQHDIcp77pdBsYSSaTgc8Zx6VKcyDHSV73i/Sedkq25T30ZJ7mgJHVEXck8I5W7CkhrxGboToyIKlVmejvSuxVkih91jQNUwGOhL1umXchtTsc3Z3c43tDhg2VCLA7eEXEFRm/L0BTIieT3a5YiPTHxyVswdRu9Slegf14P+JzQPAw8MuOW8LHLzdEMNoFijRmR+8Rx4XTI8h78hcBH4f5o3sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZDoHKTvJ43HdTCGmuNGYCniawtsucx0uEhH8kCXxqA=;
 b=dPC7jvaNTONqsmf5LpzW3Wbah7wGcaLofCMzCnG67zAvmyKEzgSDc0AQuRYpfhAuXyl7cALdCFYJcwxVq29JqwVZaB51BwUaRVKIGTXlRjeASzlIlg2tNZJZJPB6ocSvBt8GDsX8y8p9+0+arraM8/U4QfuPlsLDtKonACwqvTc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 16 Oct
 2020 08:06:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 08:06:08 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: RE: [PATCH v1] ARM: dts: imx6/7: sync fsl,stop-mode with current
 flexcan driver
Thread-Topic: [PATCH v1] ARM: dts: imx6/7: sync fsl,stop-mode with current
 flexcan driver
Thread-Index: AQHWo5FBjjscsJc8rEqeUYwd43gfMqmZ3uRQ
Date:   Fri, 16 Oct 2020 08:06:08 +0000
Message-ID: <DB8PR04MB67956B85B96E9C840BBD2798E6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201016075158.31574-1-o.rempel@pengutronix.de>
In-Reply-To: <20201016075158.31574-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15c0b5fb-98fe-49fe-eb89-08d871aa56ee
x-ms-traffictypediagnostic: DBAPR04MB7432:
x-microsoft-antispam-prvs: <DBAPR04MB74320E39D27E6E55A87F1C7AE6030@DBAPR04MB7432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:466;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XvBuNeMHLbMAPTUYdPYztfgR7zvXXviBbhjb4+nrZsmzOAZ+IHg9RqzqxzKyWaEVOmIP9fQ2XJ3UREcYhQrEXlYRkomVKCY9IQK4aA+N682oCWXnlcVdEcwZMedONxd5j2YAME/R/rFBIJbq9bH5FCX0inct/07uA5jSGBI0kpXhDX0YmLeQLiBa3oaFbufJOvbmqWg+jZOuMIogduX/rsTEU22tJSdKeAVeBc7bu7Zt/pXfcUmRFS30qTB7hWa95oGlQ/YHXzk2SSbM1sVhn/vXO8fcWbcAC7vf8VbQCMFdR7bMzr6GN0aH8MDTCLn+aJKJYAfeQH/7fsLvLgaIOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(83380400001)(53546011)(478600001)(66946007)(7416002)(5660300002)(66556008)(66446008)(52536014)(6506007)(66476007)(86362001)(64756008)(7696005)(186003)(76116006)(33656002)(26005)(110136005)(8676002)(4326008)(2906002)(55016002)(8936002)(9686003)(54906003)(316002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: khgMeLrmqVRQQDOq+2HVltPLmAqRJd5jMdwLVWUZ6+VEwiI+qrHzrR/FoikswgDirMuEbK5MacWUwH35N9MlCT5Ker6DZ70IWKl9V0UbQNZQeNYaI+lq5h0S+NzwXvQCbMN2+116HOtUYgdeQhCNi+YxLmFtL5SzTZu/DEWOFGITwjR1K2VGl2b7wSifCw5MSobrI6DnJ+xoUCG984l9yetnL7O+BovUtr4Xh9RplQ9VGHBjL5jO/sIb0KeYVxR7xOPitinvvxCc/TP4MKZhB7RutfYT7mpVOSEU/ox4nUs/YOj+X/jJNRBtCmaOnre5Gf8TQgNh6Zy0SrkDe/1zeazxoCG3yu6/MUcFSRgdC6PFhLY6y0ALl6Q3xAv5jh+8Fzn4KD/zwZLyOeh95aorgCh4jz21Kt8oYPhGTDtEfWbS+TB+11tlsAWklgredEm8tdI4G4a8irBv7vZcKWMRsTSXFLf50N0eY/ATdU0hAprVlqOqymZZKVOJf6Zxe5RkJoCMC1TmNvrjxYWBuZnOgs5Z0KXZeLZIfKZVWxq7G+a9rqNIVipg/ivDR/abDtC6DZceUnAMU31MMabORqS0tluIb70IbPa/jAXV2B9B0h5MBkFwqUib6bGu38lT/dhB980PMSFWUzgb4T1JMXDtkQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c0b5fb-98fe-49fe-eb89-08d871aa56ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 08:06:08.8647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XHoHqMHwrokIr1wEiMImXx9oi5L7afDKv4vrvvsIJ0Tb4JtWqdqnrJj4qHsPBS0VHV6Bz483U1yOgwp5LzQzvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE9sZWtzaWogUmVtcGVsIDxv
LnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gU2VudDogMjAyMMTqMTDUwjE2yNUgMTU6NTINCj4g
VG86IG1rbEBwZW5ndXRyb25peC5kZTsgV29sZmdhbmcgR3JhbmRlZ2dlciA8d2dAZ3JhbmRlZ2dl
ci5jb20+Ow0KPiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBL
aWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsNCj4gUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVs
Lm9yZz47IFNoYXduIEd1byA8c2hhd25ndW9Aa2VybmVsLm9yZz47DQo+IFNhc2NoYSBIYXVlciA8
cy5oYXVlckBwZW5ndXRyb25peC5kZT4NCj4gQ2M6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBw
ZW5ndXRyb25peC5kZT47IGtlcm5lbEBwZW5ndXRyb25peC5kZTsNCj4gbGludXgtY2FuQHZnZXIu
a2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29t
PjsgSm9ha2ltDQo+IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDog
W1BBVENIIHYxXSBBUk06IGR0czogaW14Ni83OiBzeW5jIGZzbCxzdG9wLW1vZGUgd2l0aCBjdXJy
ZW50IGZsZXhjYW4NCj4gZHJpdmVyDQo+IA0KPiBBZnRlciB0aGlzIHBhdGNoIHdlIG5lZWQgMiBh
cmd1bWVudHMgbGVzcyBmb3IgdGhlIGZzbCxzdG9wLW1vZGUNCj4gcHJvcGVydHk6DQo+IA0KPiB8
IGNvbW1pdCBkOWIwODFlM2ZjNGJkYzMzZTY3MmRjYjdiYjI1NjM5NDkwOTQzMmZjDQo+IHwgQXV0
aG9yOiBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiB8IERhdGU6ICAg
U3VuIEp1biAxNCAyMTowOToyMCAyMDIwICswMjAwDQo+IHwNCj4gfCBjYW46IGZsZXhjYW46IHJl
bW92ZSBhY2tfZ3JwIGFuZCBhY2tfYml0IGhhbmRsaW5nIGZyb20gZHJpdmVyDQo+IHwNCj4gfCBT
aW5jZSBjb21taXQ6DQo+IHwNCj4gfCAgMDQ4ZTNhMzRhMmU3IGNhbjogZmxleGNhbjogcG9sbCBN
Q1JfTFBNX0FDSyBpbnN0ZWFkIG9mIEdQUiBBQ0sgZm9yDQo+IHwgc3RvcCBtb2RlIGFja25vd2xl
ZGdtZW50DQo+IHwNCj4gfCB0aGUgZHJpdmVyIHBvbGxzIHRoZSBJUCBjb3JlJ3MgaW50ZXJuYWwg
Yml0IE1DUltMUE1fQUNLXSBhcyBzdG9wIG1vZGUNCj4gfCBhY2tub3dsZWRnZSBhbmQgbm90IHRo
ZSBhY2tub3dsZWRnbWVudCBvbiBjaGlwIGxldmVsLg0KPiB8DQo+IHwgVGhpcyBtZWFucyB0aGUg
NHRoIGFuZCA1dGggdmFsdWUgb2YgdGhlIHByb3BlcnR5ICJmc2wsc3RvcC1tb2RlIiBpc24ndA0K
PiB8IHVzZWQgYW55bW9yZS4gVGhpcyBwYXRjaCByZW1vdmVzIHRoZSB1c2VkICJhY2tfZ3ByIiBh
bmQgImFja19iaXQiIGZyb20NCj4gdGhlIGRyaXZlci4NCj4gDQo+IFRoaXMgcGF0Y2ggcmVtb3Zl
cyB0aGUgdHdvIGxhc3QgYXJndW1lbnRzLCBhcyB0aGV5IGFyZSBub3QgbmVlZGVkIGFueW1vcmUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9u
aXguZGU+DQpSZXZpZXdlZC1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNv
bT4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ICAjIFBsZWFzZSBlbnRlciB0aGUg
Y29tbWl0IG1lc3NhZ2UgZm9yIHlvdXIgY2hhbmdlcy4gTGluZXMgc3RhcnRpbmcNCj4gLS0tDQo+
ICBhcmNoL2FybS9ib290L2R0cy9pbXg2cWRsLmR0c2kgfCA0ICsrLS0gIGFyY2gvYXJtL2Jvb3Qv
ZHRzL2lteDZzeC5kdHNpICB8DQo+IDQgKystLSAgYXJjaC9hcm0vYm9vdC9kdHMvaW14NnVsLmR0
c2kgIHwgNCArKy0tDQo+ICBhcmNoL2FybS9ib290L2R0cy9pbXg3cy5kdHNpICAgfCA0ICsrLS0N
Cj4gIDQgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDZxZGwuZHRzaSBiL2FyY2gvYXJt
L2Jvb3QvZHRzL2lteDZxZGwuZHRzaQ0KPiBpbmRleCA0M2VkYmYxMTU2YzcuLjVlZmI5YjkyM2Jm
OSAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14NnFkbC5kdHNpDQo+ICsrKyBi
L2FyY2gvYXJtL2Jvb3QvZHRzL2lteDZxZGwuZHRzaQ0KPiBAQCAtNTQ5LDcgKzU0OSw3IEBAIGNh
bjE6IGZsZXhjYW5AMjA5MDAwMCB7DQo+ICAJCQkJY2xvY2tzID0gPCZjbGtzIElNWDZRRExfQ0xL
X0NBTjFfSVBHPiwNCj4gIAkJCQkJIDwmY2xrcyBJTVg2UURMX0NMS19DQU4xX1NFUklBTD47DQo+
ICAJCQkJY2xvY2stbmFtZXMgPSAiaXBnIiwgInBlciI7DQo+IC0JCQkJZnNsLHN0b3AtbW9kZSA9
IDwmZ3ByIDB4MzQgMjggMHgxMCAxNz47DQo+ICsJCQkJZnNsLHN0b3AtbW9kZSA9IDwmZ3ByIDB4
MzQgMjg+Ow0KPiAgCQkJCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQo+ICAJCQl9Ow0KPiANCj4gQEAg
LTU2MCw3ICs1NjAsNyBAQCBjYW4yOiBmbGV4Y2FuQDIwOTQwMDAgew0KPiAgCQkJCWNsb2NrcyA9
IDwmY2xrcyBJTVg2UURMX0NMS19DQU4yX0lQRz4sDQo+ICAJCQkJCSA8JmNsa3MgSU1YNlFETF9D
TEtfQ0FOMl9TRVJJQUw+Ow0KPiAgCQkJCWNsb2NrLW5hbWVzID0gImlwZyIsICJwZXIiOw0KPiAt
CQkJCWZzbCxzdG9wLW1vZGUgPSA8JmdwciAweDM0IDI5IDB4MTAgMTg+Ow0KPiArCQkJCWZzbCxz
dG9wLW1vZGUgPSA8JmdwciAweDM0IDI5PjsNCj4gIAkJCQlzdGF0dXMgPSAiZGlzYWJsZWQiOw0K
PiAgCQkJfTsNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2R0cy9pbXg2c3guZHRz
aSBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDZzeC5kdHNpDQo+IGluZGV4IGI0ODBkZmE5ZTI1MS4u
ODc3MGU1MjJkMjFjIDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybS9ib290L2R0cy9pbXg2c3guZHRz
aQ0KPiArKysgYi9hcmNoL2FybS9ib290L2R0cy9pbXg2c3guZHRzaQ0KPiBAQCAtNDYzLDcgKzQ2
Myw3IEBAIGZsZXhjYW4xOiBjYW5AMjA5MDAwMCB7DQo+ICAJCQkJY2xvY2tzID0gPCZjbGtzIElN
WDZTWF9DTEtfQ0FOMV9JUEc+LA0KPiAgCQkJCQkgPCZjbGtzIElNWDZTWF9DTEtfQ0FOMV9TRVJJ
QUw+Ow0KPiAgCQkJCWNsb2NrLW5hbWVzID0gImlwZyIsICJwZXIiOw0KPiAtCQkJCWZzbCxzdG9w
LW1vZGUgPSA8JmdwciAweDEwIDEgMHgxMCAxNz47DQo+ICsJCQkJZnNsLHN0b3AtbW9kZSA9IDwm
Z3ByIDB4MTAgMT47DQo+ICAJCQkJc3RhdHVzID0gImRpc2FibGVkIjsNCj4gIAkJCX07DQo+IA0K
PiBAQCAtNDc0LDcgKzQ3NCw3IEBAIGZsZXhjYW4yOiBjYW5AMjA5NDAwMCB7DQo+ICAJCQkJY2xv
Y2tzID0gPCZjbGtzIElNWDZTWF9DTEtfQ0FOMl9JUEc+LA0KPiAgCQkJCQkgPCZjbGtzIElNWDZT
WF9DTEtfQ0FOMl9TRVJJQUw+Ow0KPiAgCQkJCWNsb2NrLW5hbWVzID0gImlwZyIsICJwZXIiOw0K
PiAtCQkJCWZzbCxzdG9wLW1vZGUgPSA8JmdwciAweDEwIDIgMHgxMCAxOD47DQo+ICsJCQkJZnNs
LHN0b3AtbW9kZSA9IDwmZ3ByIDB4MTAgMj47DQo+ICAJCQkJc3RhdHVzID0gImRpc2FibGVkIjsN
Cj4gIAkJCX07DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14NnVsLmR0
c2kgYi9hcmNoL2FybS9ib290L2R0cy9pbXg2dWwuZHRzaQ0KPiBpbmRleCAyYjA4OGYyMTAzMzEu
LjRhMDU5NzA4ZmYyMCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvaW14NnVsLmR0
c2kNCj4gKysrIGIvYXJjaC9hcm0vYm9vdC9kdHMvaW14NnVsLmR0c2kNCj4gQEAgLTQzMCw3ICs0
MzAsNyBAQCBjYW4xOiBmbGV4Y2FuQDIwOTAwMDAgew0KPiAgCQkJCWNsb2NrcyA9IDwmY2xrcyBJ
TVg2VUxfQ0xLX0NBTjFfSVBHPiwNCj4gIAkJCQkJIDwmY2xrcyBJTVg2VUxfQ0xLX0NBTjFfU0VS
SUFMPjsNCj4gIAkJCQljbG9jay1uYW1lcyA9ICJpcGciLCAicGVyIjsNCj4gLQkJCQlmc2wsc3Rv
cC1tb2RlID0gPCZncHIgMHgxMCAxIDB4MTAgMTc+Ow0KPiArCQkJCWZzbCxzdG9wLW1vZGUgPSA8
JmdwciAweDEwIDE+Ow0KPiAgCQkJCXN0YXR1cyA9ICJkaXNhYmxlZCI7DQo+ICAJCQl9Ow0KPiAN
Cj4gQEAgLTQ0MSw3ICs0NDEsNyBAQCBjYW4yOiBmbGV4Y2FuQDIwOTQwMDAgew0KPiAgCQkJCWNs
b2NrcyA9IDwmY2xrcyBJTVg2VUxfQ0xLX0NBTjJfSVBHPiwNCj4gIAkJCQkJIDwmY2xrcyBJTVg2
VUxfQ0xLX0NBTjJfU0VSSUFMPjsNCj4gIAkJCQljbG9jay1uYW1lcyA9ICJpcGciLCAicGVyIjsN
Cj4gLQkJCQlmc2wsc3RvcC1tb2RlID0gPCZncHIgMHgxMCAyIDB4MTAgMTg+Ow0KPiArCQkJCWZz
bCxzdG9wLW1vZGUgPSA8JmdwciAweDEwIDI+Ow0KPiAgCQkJCXN0YXR1cyA9ICJkaXNhYmxlZCI7
DQo+ICAJCQl9Ow0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDdzLmR0
c2kgYi9hcmNoL2FybS9ib290L2R0cy9pbXg3cy5kdHNpIGluZGV4DQo+IDFjZmFmNDEwYWE0My4u
ODM3ZjBkYTA4Njg2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL2FybS9ib290L2R0cy9pbXg3cy5kdHNp
DQo+ICsrKyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2lteDdzLmR0c2kNCj4gQEAgLTk3MSw3ICs5NzEs
NyBAQCBmbGV4Y2FuMTogY2FuQDMwYTAwMDAwIHsNCj4gIAkJCQljbG9ja3MgPSA8JmNsa3MgSU1Y
N0RfQ0xLX0RVTU1ZPiwNCj4gIAkJCQkJPCZjbGtzIElNWDdEX0NBTjFfUk9PVF9DTEs+Ow0KPiAg
CQkJCWNsb2NrLW5hbWVzID0gImlwZyIsICJwZXIiOw0KPiAtCQkJCWZzbCxzdG9wLW1vZGUgPSA8
JmdwciAweDEwIDEgMHgxMCAxNz47DQo+ICsJCQkJZnNsLHN0b3AtbW9kZSA9IDwmZ3ByIDB4MTAg
MT47DQo+ICAJCQkJc3RhdHVzID0gImRpc2FibGVkIjsNCj4gIAkJCX07DQo+IA0KPiBAQCAtOTgy
LDcgKzk4Miw3IEBAIGZsZXhjYW4yOiBjYW5AMzBhMTAwMDAgew0KPiAgCQkJCWNsb2NrcyA9IDwm
Y2xrcyBJTVg3RF9DTEtfRFVNTVk+LA0KPiAgCQkJCQk8JmNsa3MgSU1YN0RfQ0FOMl9ST09UX0NM
Sz47DQo+ICAJCQkJY2xvY2stbmFtZXMgPSAiaXBnIiwgInBlciI7DQo+IC0JCQkJZnNsLHN0b3At
bW9kZSA9IDwmZ3ByIDB4MTAgMiAweDEwIDE4PjsNCj4gKwkJCQlmc2wsc3RvcC1tb2RlID0gPCZn
cHIgMHgxMCAyPjsNCj4gIAkJCQlzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiAgCQkJfTsNCj4gDQo+
IC0tDQo+IDIuMjguMA0KDQo=
