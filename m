Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C08FD85D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKOJGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:06:06 -0500
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:10502
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbfKOJGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 04:06:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSiUVyh/LWqHb66SUoNO1tw8BrTHPXGyJnp2BZs/LMq1ObpgvQykczAlRLhoQmeV1fg9Laz8usB76PNeofy6fA9UFZcUA43VulMtjcGCLuOpA+RprZG3AvygATiA6ZcLD6UK4IjOz7DeHb8VMfi+vRe3aI/uhTFWkv1ACphwAENbVahONMgUS8P8BQYaKtLFg6Zzl1jugQ+el2z4eBHamElHgFv5rzEb9Vglwk3qFWk7gGoaQp/ZfEBIoOVGPASqs/ecMgzErNA2vW1L7nHDMKRzIP7wlVT0hfMZ2pRdZhqMJYoHG/XHf7a0qhjhHFLgzBC7jdodW+qS1VDpggJQhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+OWG0qjEOmnPvOQEq9FtvtAoGzciE1e3NQHQ4fFPL8=;
 b=cNzORAgSAnLxl8j1zadmh7HmUzsIB5QG5dFUA/y7MS4PryQh+DzFWS4eO9KDTLS+94dzUT5iW3N9xsQjrQW4m3qc1bxTzLV0kiJjbmW5QBeGj50wZ3P8ChX5vDQ25WiVhT82K7YkN8MNtYJOTwwMACYF7SP1FtoMIi17GXL2oA5ngMzmTme+GH/1Uaw0/7C069P8aHMp4gHqy8QbK6Gcf0D5+Z6DYSimFPi8GlCPNu5aFVMiUllGyev3f7k6GDYv1gSmJrQ7Ag3C5/xmbVRdrcHbwwCyUJ5vQYM1eej7Ftnxxy6V5voKMHIRaY9FA1UUYP+kD1LJ+uQhKnOb5Y4Ilw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+OWG0qjEOmnPvOQEq9FtvtAoGzciE1e3NQHQ4fFPL8=;
 b=nGS3iX34ySA3QAjJ2wg30UVVbhNVBD8ytpTmmj+7VqgW7HBL56Y4wfm85fG9srGPXumEPtnGd/Y7Rw/ERQcnAq2yNj2xxEVMw/1ka7BEGYiblgPiHe21RFLnX03OyNjwXGMwWuiTAHxPzratbowd1U23Rwqwj56G36yfn/0VBTs=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5339.eurprd04.prod.outlook.com (52.135.129.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Fri, 15 Nov 2019 09:06:01 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 09:06:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcKeLrVbggABANwCAAAILAA==
Date:   Fri, 15 Nov 2019 09:06:01 +0000
Message-ID: <DB7PR04MB4618824F3A331AF9EC207C55E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <DB7PR04MB4618335E8A90387EDAE17F21E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <986c06e6-644a-5ad4-b7e0-ce431605b626@geanix.com>
In-Reply-To: <986c06e6-644a-5ad4-b7e0-ce431605b626@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38e3e020-1eb9-4d51-0248-08d769ab0997
x-ms-traffictypediagnostic: DB7PR04MB5339:|DB7PR04MB5339:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB53394282967AC03D9F506084E6700@DB7PR04MB5339.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(13464003)(199004)(189003)(74316002)(99286004)(2201001)(186003)(14454004)(6436002)(7736002)(305945005)(486006)(11346002)(446003)(33656002)(66446008)(64756008)(66556008)(66476007)(66946007)(3846002)(6116002)(52536014)(478600001)(476003)(5660300002)(229853002)(25786009)(2906002)(76116006)(66066001)(86362001)(8676002)(9686003)(102836004)(81166006)(81156014)(4326008)(110136005)(26005)(54906003)(14444005)(2501003)(8936002)(256004)(55016002)(6246003)(6506007)(316002)(53546011)(7696005)(76176011)(71200400001)(71190400001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5339;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JBM8+n1AN+seDvIz3ACkw8U1hrUQEP8nPNCnrbpiQ4o9wGiyAHlkM/8J/xtyMt3g1CScvtkuON5N9zdmEgROT72bPxaihpAZwPiFZh8wjfjF81NjnV5sbZ0tEOQ8SAIrF3BDXC37qNuPUP0x+ig6+ofgFTlmrhnbXIRB/pL+XFU79qjD7dMrQCfu1s4U5gqW2up9HdEaPCTfeHxlmU+una049aeO8lWggC9kQhyXNPgwln9qhfLtTsfZ4//JVvU9Ui5L9RTo57kiV5bIfp0Pn8snOwMveNGpCh6G6Vz90vXPy788EjNQqFnRt4AUhrJW+EF9lr59uumNRudwFmjZ5LTGeOAPr03CraPPXrJk7ElyD7brhEYETqJ6ld4YV676hQoQXYUKWVULudQvL33f9dQbknS1/Ruyq2lVjZ4iIXIUd/plkQ9rl/Z+ZDtdeHLM
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e3e020-1eb9-4d51-0248-08d769ab0997
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 09:06:01.6310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q+AyTW05EvOFLEfGjCsbYQxZZsVUBkC+NIKllWyQWCd4r/GTK+6kFk5VU9UJYCksOnk4ayE7S2FqmuIbPxYI2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5339
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOcTqMTHUwjE1yNUgMTY6NTQNCj4gVG86IEpvYWtp
bSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBta2xAcGVuZ3V0cm9uaXguZGU7DQo+
IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
MS8zXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVwDQo+
IA0KPiANCj4gDQo+IE9uIDE1LzExLzIwMTkgMDYuMDksIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4g
Pg0KPiA+IEhpIFNlYW4sDQo+ID4NCj4gPiBJIHJlbWVtYmVyIHRoYXQgeW91IGFyZSB0aGUgZmly
c3Qgb25lIHNlbmRpbmcgb3V0IHRoZSBwYXRjaCB0byBmaXggdGhpcyBpc3N1ZSwNCj4gYW5kIEkg
TkFDSyB0aGUgcGF0Y2ggYmVmb3JlLg0KPiA+IEkgYW0gc28gc29ycnkgZm9yIHRoYXQsIGl0IGNh
biB3b3JrIGZpbmUgYWZ0ZXIgdGVzdGluZyBhdCBteSBzaWRlLg0KPiA+IENvdWxkIHlvdSBoZWxw
IGRvdWJsZSBjaGVjayBhdCB5b3VyIHNpZGUgZm9yIHRoaXMgcGF0Y2g/IEJvdGggd2FrZXVwIGZy
b20NCj4gdG90YWxseSBzdXNwZW5kIGFuZCB3YWtldXAgZnJvbSBzdXNwZW5kaW5nPw0KPiA+DQo+
ID4gV2l0aCB0aGlzIHBhdGNoLCB3ZSBjYW4gZml4IHR3byBwcm9ibGVtczoNCj4gPiAxKSBmaXgg
ZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxmIHdha2V1cA0KPiA+IDIpIGZyYW1lcyBvdXQtb2Ytb3Jk
ZXIgaW4gZmlyc3QgSVJRIGhhbmRsZXIgcnVuIGFmdGVyIHdha2V1cA0KPiA+DQo+ID4gVGhhbmtz
IGEgbG90IQ0KPiA+DQo+ID4gQmVzdCBSZWdhcmRzLA0KPiA+IEpvYWtpbSBaaGFuZw0KPiANCj4g
SGkgSm9ha2ltLA0KPiANCj4gDQo+IA0KPiBXZSBhcmUgbW9zdGx5IGxpc3RlbmluZyBmb3IgYnJv
YWRjYXN0IHBhY2thZ2VzLCBzbyB3ZSBoYXZlbid0IG5vdGljZWQgZnJhbWVzDQo+IG91dC1vZi1v
cmRlciA6LSkNCg0KT2theSwgSSBoYXZlIGRpc2N1c3NlZCB3aXRoIE1hcmMgYmVmb3JlLCB0aGlz
IGNvdWxkIGJlIHBvc3NpYmxlLiBZb3UgY2FuIHRlc3Qgd2l0aCB0d28gYm9hcmRzLCBvbmUgcmVj
ZWl2ZSBhbmQgYW5vdGhlciB0cmFuc21pdC4NCj4gDQo+IA0KPiBJIGhhdmUgY2hlY2tlZCB0aGlz
IHNlcmllcywgaXQgY29tZXMgb3V0IG9mIHN1c3BlbmQgZXZlcnkgdGltZSA6LSkNCg0KSSBhbSBu
b3QgcXVpdGUgdW5kZXJzdGFuZCwgY291bGQgeW91IGV4cGxhaW4gbW9yZSwgdGhpcyBwYXRjaCBj
YW5ub3QgZml4IGRlYWRsb2NrIGlzc3VlPw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcN
Cj4gL1NlYW4NCg0K
