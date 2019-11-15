Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A820AFD8B1
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfKOJVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:21:42 -0500
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:23622
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbfKOJVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 04:21:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJDaHEbTynNdyxJQCOaq7ymuIr6YeFyjs2vFG8nRUB6+GFm4zDX8trVDCLXv6IJv1GajFudFZ7xo4Y4awxLDHsWcZAx9SAU4NLSfQ4VFd1pLs+j4bVs1e67lwdgTXlS/maW/6657hlH/SIzlbH/9QzCSBeW2/F2byYu8hSgC4wuI+L4ngLjqevezCcUVWcQFqBDvTYxN0lmBid3r3AyWRDaqjJRpGHpgM8rfkKacxlJVLLFhzHblVFZPJF6XPrhAnf41DzR4oDZD13EOkRAD8vhqEMY5fVSxzohExI2m/JfUhfHLeIlV6hn4bkFrfNII1uHxcIRT5okgFIXQzudgdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9+ATYWqd1MKF2+L42TZX4ABv22y6qq2ZvwfzbnMGOw=;
 b=loXC504A/JYBi2DapzDwnNLZZTai0gZdJ5YqW2WwApjKvmrHI5ztK5vJYkHSVP/RIkXufr/xkmYTwX4LOFuwye7VD/JBqsv6D+hPicFCNiWEqgMPB7cTaOOUcJPPYC6PdlzbiVhgZkn8Ap5MYdN8RzrgW4+Q/Fu2soQ5ZTnBoJIzUbW7PwrKP/bW9ZqAUg6PpVryYHx1cPIB+LUaWbPUlnks3fV40xpuFMB6xk+k4Ma52nHcmis5JD0IMyXB8LmL+VnCYrwvF3ikb8WQQ5B7v5Bimn/nr4riiZWus5lWyueqWGRHceLqqLHZk7U2HVC+T+duzfve4R/FL0q4YguaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9+ATYWqd1MKF2+L42TZX4ABv22y6qq2ZvwfzbnMGOw=;
 b=o0GCDEtSq02PEiZ/v0oF62IAIzjN2zq8zCLSfhaEK9ADfpLMs+JLD31wTaeb9duEzFcR9R2+yHROItf3fJEF2ElYJvte9MERwfY/J/4tMQy4moJXlUZiDQTViT6uykvJZahU+F0/d7tN755FhVQ318AcqsDW0uQ0QPZIQHb2XZM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5260.eurprd04.prod.outlook.com (20.176.237.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Fri, 15 Nov 2019 09:20:58 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 09:20:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH 1/3] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVm3IDm0rriooN3k2DjIsf/kbhcKeL8V8AgAADYIA=
Date:   Fri, 15 Nov 2019 09:20:58 +0000
Message-ID: <DB7PR04MB461887D626BFF7CAF387E708E6700@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
 <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
In-Reply-To: <9870ec21-b664-522e-e0df-290ab56fbb32@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec2b718c-9fc6-4d9f-1451-08d769ad200d
x-ms-traffictypediagnostic: DB7PR04MB5260:|DB7PR04MB5260:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5260162D4404CA911FB660E9E6700@DB7PR04MB5260.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(13464003)(189003)(199004)(64756008)(8936002)(11346002)(486006)(66446008)(102836004)(26005)(66946007)(66476007)(66556008)(446003)(33656002)(476003)(186003)(110136005)(14444005)(2906002)(53546011)(6506007)(7696005)(99286004)(52536014)(76176011)(5660300002)(2501003)(66066001)(256004)(305945005)(55016002)(9686003)(71200400001)(71190400001)(478600001)(3846002)(76116006)(54906003)(81166006)(81156014)(25786009)(6116002)(4326008)(229853002)(74316002)(86362001)(316002)(6246003)(7736002)(14454004)(8676002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5260;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A4Icf/ZQ/hXfAXGfPHcJ52HQNVoKIwZlAPrfiz5AV7UxoaEMXPlFdA9YYg1YoUg+xvg09cpXBrBeNAJt0xRzyNqp0WMVNZrIjHaSGQt9BgStNecKUkGURTb4VMrR8eg/f99d/lV66gjQSwE5nzF90zX3Zs5FW3yxpdr5vqtDrF+vzmD4pOFR5IdTUuC7onTLf1n2hulz6mE73KcBVgU2by9z1GubiwZtxFHhii1i58ostqD9HdBCOOWWqKqz2Wgdkmg5NGGJvRG7GZOXm9RhrOt8UlzMOuKPshZYUKE076+opV3tVdHXkCG4/hpKlTBJfSz7ecj0BhXnJZUb569pYYiURmi91Q/7Ac0J+sR7Kb0OzZvcx4bbL02mVGeAWXjuvX30ekItSpCUPjLvUaVQcnBlJsUw1d5udqx/bA/UhRmQfQBKH7CCG8k0BqzdWY0h
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2b718c-9fc6-4d9f-1451-08d769ad200d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 09:20:58.3611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iGUuk4IVbiJI5sHKJ6QUV8FgD5dqaEVZT2QuZ7fQMg9GbFC/+OvAqHHGpeLaSdYgRUtQRhLULkrY2BgDdOqyBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5260
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LWNhbi1vd25lckB2
Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LWNhbi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+DQo+IE9uIEJl
aGFsZiBPZiBTZWFuIE55ZWtqYWVyDQo+IFNlbnQ6IDIwMTnlubQxMeaciDE15pelIDE3OjA4DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgbWtsQHBlbmd1dHJv
bml4LmRlDQo+IENjOiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXggPGxp
bnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIDEvM10gY2FuOiBmbGV4Y2FuOiBmaXggZGVhZGxvY2sgd2hlbiB1c2luZyBzZWxm
IHdha2V1cA0KPiANCj4gDQo+IA0KPiBPbiAxNS8xMS8yMDE5IDA2LjAzLCBKb2FraW0gWmhhbmcg
d3JvdGU6DQo+ID4gRnJvbTogU2VhbiBOeWVramFlciA8c2VhbkBnZWFuaXguY29tPg0KPiA+DQo+
ID4gV2hlbiBzdXNwZW5kaW5nLCB3aGVuIHRoZXJlIGlzIHN0aWxsIGNhbiB0cmFmZmljIG9uIHRo
ZSBpbnRlcmZhY2VzIHRoZQ0KPiA+IGZsZXhjYW4gaW1tZWRpYXRlbHkgd2FrZXMgdGhlIHBsYXRm
b3JtIGFnYWluLiBBcyBpdCBzaG91bGQgOi0pLiBCdXQgaXQNCj4gPiB0aHJvd3MgdGhpcyBlcnJv
ciBtc2c6DQo+ID4gWyAzMTY5LjM3ODY2MV0gUE06IG5vaXJxIHN1c3BlbmQgb2YgZGV2aWNlcyBm
YWlsZWQNCj4gPg0KPiA+IE9uIHRoZSB3YXkgZG93biB0byBzdXNwZW5kIHRoZSBpbnRlcmZhY2Ug
dGhhdCB0aHJvd3MgdGhlIGVycm9yIG1lc3NhZ2UNCj4gPiBkb2VzIGNhbGwgZmxleGNhbl9zdXNw
ZW5kIGJ1dCBmYWlscyB0byBjYWxsIGZsZXhjYW5fbm9pcnFfc3VzcGVuZC4NCj4gPiBUaGF0IG1l
YW5zIHRoZSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZSBpcyBjYWxsZWQsIGJ1dCBvbiB0aGUgd2F5
IG91dA0KPiA+IG9mIHN1c3BlbmQgdGhlIGRyaXZlciBvbmx5IGNhbGxzIGZsZXhjYW5fcmVzdW1l
IGFuZCBza2lwcw0KPiA+IGZsZXhjYW5fbm9pcnFfcmVzdW1lLCB0aHVzIGl0IGRvZXNuJ3QgY2Fs
bCBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlLg0KPiA+IFRoaXMgbGVhdmVzIHRoZSBmbGV4Y2FuIGlu
IHN0b3AgbW9kZSwgYW5kIHdpdGggdGhlIGN1cnJlbnQgZHJpdmVyIGl0DQo+ID4gY2FuJ3QgcmVj
b3ZlciBmcm9tIHRoaXMgZXZlbiB3aXRoIGEgc29mdCByZWJvb3QsIGl0IHJlcXVpcmVzIGEgaGFy
ZCByZWJvb3QuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGNhbiBmaXggZGVhZGxvY2sgd2hlbiB1c2lu
ZyBzZWxmIHdha2V1cCwgaXQgaGFwcGVuZXMgdG8gYmUNCj4gPiBhYmxlIHRvIGZpeCBhbm90aGVy
IGlzc3VlIHRoYXQgZnJhbWVzIG91dC1vZi1vcmRlciBpbiBmaXJzdCBJUlENCj4gPiBoYW5kbGVy
IHJ1biBhZnRlciB3YWtldXAuDQo+ID4NCj4gPiBJbiB3YWtldXAgY2FzZSwgYWZ0ZXIgc3lzdGVt
IHJlc3VtZSwgZnJhbWVzIHJlY2VpdmVkIG91dC1vZi1vcmRlcix0aGUNCj4gPiBwcm9ibGVtIGlz
IHdha2V1cCBsYXRlbmN5IGZyb20gZnJhbWUgcmVjZXB0aW9uIHRvIElSUSBoYW5kbGVyIGlzIG11
Y2gNCj4gPiBiaWdnZXIgdGhhbiB0aGUgY291bnRlciBvdmVyZmxvdy4gVGhpcyBtZWFucyBpdCdz
IGltcG9zc2libGUgdG8gc29ydA0KPiA+IHRoZSBDQU4gZnJhbWVzIGJ5IHRpbWVzdGFtcC4gVGhl
IHJlYXNvbiBpcyB0aGF0IGNvbnRyb2xsZXIgZXhpdHMgc3RvcA0KPiA+IG1vZGUgZHVyaW5nIG5v
aXJxIHJlc3VtZSwgdGhlbiBpdCBjYW4gcmVjZWl2ZSB0aGUgZnJhbWUgaW1tZWRpYXRlbHkuDQo+
ID4gSWYgbm9pcnEgcmV1c21lIHN0YWdlIGNvbnN1bWVzIG11Y2ggdGltZSwgaXQgd2lsbCBleHRl
bmQgaW50ZXJydXB0DQo+ID4gcmVzcG9uc2UgdGltZS4NCj4gPg0KPiA+IEZpeGVzOiBkZTM1Nzhj
MTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIE55ZWtqYWVyIDxzZWFuQGdlYW5peC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gDQo+IEhpIEpv
YWtpbSBhbmQgTWFyYw0KPiANCj4gV2UgaGF2ZSBxdWl0ZSBhIGZldyBkZXZpY2VzIGluIHRoZSBm
aWVsZCB3aGVyZSBmbGV4Y2FuIGlzIHN0dWNrIGluIFN0b3AtTW9kZS4NCj4gV2UgZG8gbm90IGhh
dmUgdGhlIHBvc3NpYmlsaXR5IHRvIGNvbGQgcmVib290IHRoZW0sIGFuZCBob3QgcmVib290IHdp
bGwgbm90IGdldA0KPiBmbGV4Y2FuIG91dCBvZiBzdG9wLW1vZGUuDQo+IFNvIGZsZXhjYW4gY29t
ZXMgdXAgd2l0aDoNCj4gWyAgMjc5LjQ0NDA3N10gZmxleGNhbjogcHJvYmUgb2YgMjA5MDAwMC5m
bGV4Y2FuIGZhaWxlZCB3aXRoIGVycm9yIC0xMTANCj4gWyAgMjc5LjUwMTQwNV0gZmxleGNhbjog
cHJvYmUgb2YgMjA5NDAwMC5mbGV4Y2FuIGZhaWxlZCB3aXRoIGVycm9yIC0xMTANCj4gDQo+IFRo
ZXkgYXJlIG9uLCBkZTM1NzhjMTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxmIHdha2V1cCBz
dXBwb3J0IikNCj4gDQo+IFdvdWxkIGl0IGJlIGEgc29sdXRpb24gdG8gYWRkIGEgY2hlY2sgaW4g
dGhlIHByb2JlIGZ1bmN0aW9uIHRvIHB1bGwgaXQgb3V0IG9mDQo+IHN0b3AtbW9kZT8NCg0KSGkg
U2VhbiwNCg0KSSBhbSBub3Qgc3VyZSwgSSB3aWxsIHRyeSB0byBpbXBsZW1lbnQgaXQuDQoNCkJl
c3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAvU2Vhbg0K
