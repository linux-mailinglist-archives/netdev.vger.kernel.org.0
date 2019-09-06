Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F22AB086
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 04:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbfIFCLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 22:11:43 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:54306
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728507AbfIFCLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 22:11:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfPoen2BobU/psjfIpHPOSqT6EJGKvmbrjdbfEMLqZUmumxc9JURQxuOptaV5WzLXr/pIscYHXnFjdrzi3x4/Vces0QGJaf83YjhKrNEBc9LtWvQJr8vrTiVXIQCnV7QnQpeK1/8azjRbeB4z3ew0VzKFTzqsueZWlVrWVgQsqGidBJj42CIGjO4/4unakpO5K3rseHY8ClGp9VWUCZ3sk+DbFu4NwTtKX5mruTBWWCBk7azsKIsdePU0ecKKTHn/nT7wjVnFZGPcWvib0RzV/VTT3KjMnmV1JoirexxsIlJQZ45gU54j81r1+w3sbtAhdnm3HRf+znGDz46Iaayzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VaHZP8AWdnQ9/m4YzrvvMpBnqKnFqLOLD/uoUYSLpQ=;
 b=LY7c8oifDSKRfBIt2u6Bu9OUjliItc5rxSoLOy1N4P0J6J6ufOXhmMJc8oCfdelcvUjmsyKzl8d8xwtWt4MUn4FOHWCilygNd7f6yor0eP62XM3r87d0G7ue081345uNV9w0MQZwWBqELGd6SZUMBKQfvOPVs1/nTbN1TSiH7++QcS6BrPSwcmAg2cRBqfA8nlEMqZqX97VclWZ+r++RPD/b1OLcS4F8zVF/m1XECCwcDCkXqKsYdj1/Qlo0i3s8uNdnToi8EZkgn0sttWY1rct14Suegq1GyiXkoETKq22pEoQiUZeZaNS7hUu3wMCrMQHic/i1LVtyt6a9YpiiPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VaHZP8AWdnQ9/m4YzrvvMpBnqKnFqLOLD/uoUYSLpQ=;
 b=kHQ8173cfp0C9A9Zi81vquiAE5R4CuQc6ceuYzAdS82Hq2AyHG6OeFSoQNdFKyLDMwag+G/QcsUbteg+JnVTH6sbRU/E+Ws7A7vvLS7IUSE8WeEypaqJUXj1ZoFE4iN7LSMNYd/clYYcdy7daZWoGseqvPJnJq4JH/vLgaJ/KFQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5035.eurprd04.prod.outlook.com (20.176.234.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Fri, 6 Sep 2019 02:11:38 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::29e4:47d:7a2b:a6c6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::29e4:47d:7a2b:a6c6%7]) with mapi id 15.20.2220.022; Fri, 6 Sep 2019
 02:11:38 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        =?utf-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <martin@geanix.com>
Subject: RE: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Topic: [PATCH REPOST 1/2] can: flexcan: fix deadlock when using self
 wakeup
Thread-Index: AQHVVAt+uezYlHzMP0yJKoK3YxkiS6cD2xAAgAAKUjCAAA71AIAMq3CAgAEuS9CACueJAIAAERoggABp3ICAAM1yoA==
Date:   Fri, 6 Sep 2019 02:11:37 +0000
Message-ID: <DB7PR04MB461874ED80BCEA892249661AE6BA0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
 <20190816081749.19300-2-qiangqing.zhang@nxp.com>
 <dd8f5269-8403-702b-b054-e031423ffc73@geanix.com>
 <DB7PR04MB4618A1F984F2281C66959B06E6AB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <35190c5b-f8be-8784-5b4f-32a691a6cffe@geanix.com>
 <6a9bc081-334a-df91-3a23-b74a6cdd3633@geanix.com>
 <DB7PR04MB4618E527339B69AEAD46FB06E6A20@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <588ab34d-613d-ac01-7949-921140ca4543@geanix.com>
 <DB7PR04MB461868320DA0B25CC8255213E6BB0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <1655f342-7aaf-5e36-d141-d00eee84f3ec@geanix.com>
In-Reply-To: <1655f342-7aaf-5e36-d141-d00eee84f3ec@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81246f94-a7d6-4ff3-daf3-08d7326f8cde
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5035;
x-ms-traffictypediagnostic: DB7PR04MB5035:|DB7PR04MB5035:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5035BA4B6A5B52EBC3F26A6AE6BA0@DB7PR04MB5035.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(13464003)(199004)(189003)(229853002)(8936002)(52536014)(6246003)(66446008)(64756008)(66556008)(66476007)(81166006)(7736002)(2201001)(305945005)(76116006)(81156014)(8676002)(66946007)(66066001)(99286004)(9686003)(53546011)(76176011)(14444005)(102836004)(186003)(53936002)(26005)(316002)(71190400001)(71200400001)(54906003)(6506007)(110136005)(7696005)(256004)(446003)(476003)(6436002)(2501003)(55016002)(486006)(11346002)(6116002)(3846002)(66574012)(14454004)(478600001)(74316002)(86362001)(5660300002)(33656002)(2906002)(25786009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5035;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7y1HEJgnon2rMcjobt5tr7OaXTVKk1nEnAWnMN0r6SEPjPcOvRKjx+L2Ltp2pI2XI0DALVIUllpcF9xnVfhtwKywu2DEMxw6fV3QaYBJr7PjfEj009zuNbN4NN9PTo50tJglFkf2Zm0t98COifp+Q4IxQEv4A454A6LyhOwyGPW4ggC72Qh3lvaYqqeQyBr0wmaV1DVSSIXmsAWMKenrmp/WUlgDkd1r0Pj2oX89kbiOhMDLXlj/eD6oeShfXM59PC+u1aTTOYb0NkPTxuA5rL8fAvwcGVuXW1BWDzDgvvat0WFMM9wsPJxTncvbQD4/3JLPl8czZIOgHW0sm9HtfH0bkvCkz/X1NGm+8h5vffkrVHA6UGp7X8zy6bBbd2MJSM0gSPuaDLbKqRJJiGrCorGWGh/jEei8D2ea6+aTInI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81246f94-a7d6-4ff3-daf3-08d7326f8cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 02:11:38.0379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: muP3PIiW2E2T7XzHIVsAiZQdR5QlDcYSOobPwDnRJt8h/p0O9hYPIMRQBFDtN8GZm1FHZsNy9J7ZjmsrLD3spA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5035
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDnmnIg15pelIDIxOjE4DQo+IFRvOiBKb2Fr
aW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgbWtsQHBlbmd1dHJvbml4LmRlOw0K
PiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiB3Z0BncmFuZGVnZ2VyLmNvbTsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47
IE1hcnRpbiBIdW5kZWLDuGxsIDxtYXJ0aW5AZ2Vhbml4LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBSRVBPU1QgMS8yXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNl
bGYNCj4gd2FrZXVwDQo+IA0KPiANCj4gDQo+IE9uIDA1LzA5LzIwMTkgMDkuMTAsIEpvYWtpbSBa
aGFuZyB3cm90ZToNCj4gPiBIaSBTZWFuLA0KPiA+DQo+ID4gQ291bGQgeW91IHVwZGF0ZSBsYXN0
ZXN0IGZsZXhjYW4gZHJpdmVyIHVzaW5nIGxpbnV4LWNhbi1uZXh0L2ZsZXhjYW4gYW5kIHRoZW4N
Cj4gbWVyZ2UgYmVsb3cgdHdvIHBhdGNoZXMgZnJvbSBsaW51eC1jYW4vdGVzdGluZz8NCj4gPiBk
MGI1MzYxNjcxNmUgKEhFQUQgLT4gdGVzdGluZywgb3JpZ2luL3Rlc3RpbmcpIGNhbjogZmxleGNh
bjogYWRkIExQU1INCj4gPiBtb2RlIHN1cHBvcnQgZm9yIGkuTVg3RCA4MDNlYjZiYWQ2NWIgY2Fu
OiBmbGV4Y2FuOiBmaXggZGVhZGxvY2sgd2hlbg0KPiA+IHVzaW5nIHNlbGYgd2FrZXVwDQo+ID4N
Cj4gPiBCZXN0IFJlZ2FyZHMsDQo+ID4gSm9ha2ltIFpoYW5nDQo+IA0KPiBUaGUgdGVzdGluZyBi
cmFuY2ggaGF2ZSBzb21lIFVCSSBidWdzLCB3aGVuIHN1c3BlbmRpbmcgaXQgY3Jhc2hlcy4uLg0K
PiBTbyB3aWxsIGhhdmUgdG8gbGVhdmUgdGhpcywgdW50aWwgdGhleSBhcmUgcmVzb2x2ZWQgOi0p
DQoNCkkgdGhpbmsgeW91IGNhbiBmaW5kIHRoZSBiYXNlIGFuZCBjaGVycnktcGljayBhbGwgYWJv
dmUgZmxleGNhbiByZWxhdGVkIGxhdGVzdCBwYXRjaGVzIHRvIHlvdXIgbG9jYWwgc3RhYmxlIHRy
ZWUuDQpJIGRpZCB0aGlzIGFuZCB0ZXN0IHdha2V1cCBmdW5jdGlvbiBvbiBpLk1YOFFNL1FYUCBi
ZWZvcmUuDQoNCkJUVywgSSB0aGluayB3aXRob3V0IENBTiBGRCByZWxhdGVkIHBhdGNoZXMsIHlv
dSBzdGlsbCBjYW4gdGVzdCB3YWtldXAgZnVuY3Rpb24gb24gaS5NWDYvNyB3aXRoIHRoaXMgcGF0
Y2gobWF5IG5lZWQgZml4IG1lcmdlIGNvbmZsaWN0cykNClRoaXMgcGF0Y2ggaGFzIGJlZW4gbWVy
Z2VkIGludG8gb3VyIDQuMTkga2VybmVsIGFuZCBwYXNzZWQgdGhlIHdha2V1cCB0ZXN0IGZvciBp
Lk1YNi83LzguIEkgd2VudCB0aHJvdWdoIHRoZSBmbGV4Y2FuIHN1c3BlbmQvcmVzdW1lIHByb2Nl
c3MgYWdhaW4sDQphbmQgbm90IGZpbmQgbG9naWNhbCBpc3N1ZS4gSWYgeW91IG1ldCB3YWtldXAg
ZmFpbHVyZSwgY291bGQgeW91IGhlbHAgdG8gbG9jYXRlIHRoZSBwcm9ibGVtIG1vcmUgYWNjdXJh
dGUuIEZhaWx1cmUgbG9nIHlvdSBwcm92aWRlZCBsYXN0IHRpbWUsIHN0cmFuZ2UNCmFuZCBpbGxv
Z2ljYWwuDQoNClRoYW5rcyBhIGxvdCEg8J+Yig0KIAkNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBa
aGFuZw0KPiAvU2Vhbg0K
