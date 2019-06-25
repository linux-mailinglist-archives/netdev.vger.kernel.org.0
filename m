Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E434E52774
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbfFYJFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:05:00 -0400
Received: from mail-eopbgr20073.outbound.protection.outlook.com ([40.107.2.73]:33606
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731095AbfFYJFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 05:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=My6rndEdNDkpizeY2vrIZlfkcd/pG2VSh1IxMnxQobo=;
 b=WcpUGpnrzncWOttlQDn+5FBpprMhSKG7bWXEXxLkYt2kJGP7RlBw5Q64JpMhFXDLr2Ct3FksbD8WGoET7uaQ6e6aL0J8kDgla7MvNDKPWpHi92HjwyF2kj9+0f592sH1Nuprmp0GRv2ZwwJ/DygrFiebtbbZ9mGzFXfckC1uvHM=
Received: from AM4PR0501MB2769.eurprd05.prod.outlook.com (10.172.222.15) by
 AM4PR0501MB2675.eurprd05.prod.outlook.com (10.172.221.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 09:04:55 +0000
Received: from AM4PR0501MB2769.eurprd05.prod.outlook.com
 ([fe80::d9da:d3c2:1bc0:6a8b]) by AM4PR0501MB2769.eurprd05.prod.outlook.com
 ([fe80::d9da:d3c2:1bc0:6a8b%3]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 09:04:55 +0000
From:   Ran Rozenstein <ranro@mellanox.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Maor Gottlieb <maorg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: RE: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Thread-Topic: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Thread-Index: AQHVJRbrLKNg9SQxm0O9HRFaFY7gmqagBcGAgAwZnFA=
Date:   Tue, 25 Jun 2019 09:04:55 +0000
Message-ID: <AM4PR0501MB276924D7AD83B349AA2A6A0BC5E30@AM4PR0501MB2769.eurprd05.prod.outlook.com>
References: <20190617140228.12523-1-fw@strlen.de>
 <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
In-Reply-To: <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ranro@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5bd6999-72e0-4965-40ea-08d6f94c311a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2675;
x-ms-traffictypediagnostic: AM4PR0501MB2675:
x-microsoft-antispam-prvs: <AM4PR0501MB26751F42EC9F26D58044FA42C5E30@AM4PR0501MB2675.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(376002)(39860400002)(346002)(13464003)(199004)(189003)(54906003)(53936002)(6116002)(53546011)(110136005)(186003)(76116006)(73956011)(256004)(76176011)(71190400001)(486006)(71200400001)(446003)(25786009)(33656002)(476003)(316002)(2501003)(7696005)(26005)(478600001)(102836004)(66066001)(4744005)(11346002)(8936002)(86362001)(52536014)(9686003)(229853002)(99286004)(66946007)(66446008)(8676002)(66476007)(6246003)(68736007)(66556008)(2906002)(3846002)(81156014)(6506007)(14454004)(7736002)(305945005)(4326008)(5660300002)(74316002)(81166006)(6436002)(64756008)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2675;H:AM4PR0501MB2769.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IMahAlTZN5BKo2Z3xck0NF50J+rRfVJqddMNQ4+YrCJJI/GdcgIg+dNmtDI8ejnFnoHhx0NC1IMTxjjJkx650+vhckrjWSc7+UbOBZxkacUXBWk+17O0LQQk/ClMeK8K1Y4TDPvEDGluPwq99RlagA5vvHLi23FTVRW5g2601UAoywVxw5u3DCf1hQQrqscsQnlSJ6d6GZEWwh3XxIPEQBrv3cwajID/CCfksJByi2tB+//ByH40sjAqNFXTnLuQZ9bXdUJS26MWs7e+trFIa7Wjb2crVOWnps3FOsh+Ej7iM8mNRtLPO9y+fo+qELJuMfG8noPEL8oMSDQbg/eFSAM7oECSZynyQzw49hV0GTpxBXTIs634iQAWTuhlRVv91w3l5BXkC8mTmb2NCsnnG6eOnweKoHHbk5YN1xWBemQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bd6999-72e0-4965-40ea-08d6f94c311a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 09:04:55.4997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ranro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2675
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGFyaXEgVG91a2FuDQo+
IFNlbnQ6IE1vbmRheSwgSnVuZSAxNywgMjAxOSAxOToxNg0KPiBUbzogRmxvcmlhbiBXZXN0cGhh
bCA8ZndAc3RybGVuLmRlPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogUmFuIFJvemVu
c3RlaW4gPHJhbnJvQG1lbGxhbm94LmNvbT47IE1hb3IgR290dGxpZWINCj4gPG1hb3JnQG1lbGxh
bm94LmNvbT47IGVkdW1hemV0QGdvb2dsZS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQt
bmV4dCAwLzJdIG5ldDogaXB2NDogcmVtb3ZlIGVycm9uZW91cw0KPiBhZHZhbmNlbWVudCBvZiBs
aXN0IHBvaW50ZXINCj4gDQo+IA0KPiANCj4gT24gNi8xNy8yMDE5IDU6MDIgUE0sIEZsb3JpYW4g
V2VzdHBoYWwgd3JvdGU6DQo+ID4gVGFyaXEgcmVwb3J0ZWQgYSBzb2Z0IGxvY2t1cCBvbiBuZXQt
bmV4dCB0aGF0IE1lbGxhbm94IHdhcyBhYmxlIHRvDQo+ID4gYmlzZWN0IHRvIDI2MzhlYjhiNTBj
ZiAoIm5ldDogaXB2NDogcHJvdmlkZSBfX3JjdSBhbm5vdGF0aW9uIGZvciBpZmFfbGlzdCIpLg0K
PiA+DQo+ID4gV2hpbGUgcmV2aWV3aW5nIGFib3ZlIHBhdGNoIEkgZm91bmQgYSByZWdyZXNzaW9u
IHdoZW4gYWRkcmVzc2VzIGhhdmUgYQ0KPiA+IGxpZmV0aW1lIHNwZWNpZmllZC4NCj4gPg0KPiA+
IFNlY29uZCBwYXRjaCBleHRlbmRzIHJ0bmV0bGluay5zaCB0byB0cmlnZ2VyIGNyYXNoICh3aXRo
b3V0IGZpcnN0DQo+ID4gcGF0Y2ggYXBwbGllZCkuDQo+ID4NCj4gDQo+IFRoYW5rcyBGbG9yaWFu
Lg0KPiANCj4gUmFuLCBjYW4geW91IHBsZWFzZSB0ZXN0Pw0KDQpUZXN0ZWQsIHN0aWxsIHJlcHJv
ZHVjZS4NCg==
