Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788DB21F1A
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfEQUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:34:16 -0400
Received: from mail-eopbgr50049.outbound.protection.outlook.com ([40.107.5.49]:20901
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbfEQUeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4MCPgfrm2A5TkzCD2lu6r6mD1zverZVhRMloD0Zy88=;
 b=e78jBHRiaYdWhdlaHQ7R7SzKj30wcrfSMawJE87WnIUZO57kGzihINcQQgmGRxjcBkRyTcze17UBnF2kBG+g+rk8zc/l7IP6vsyxG4seXFx1cLki/FCLyHoR2xTF8dFZU7SzGoK8w+mArWD3KMOXshZgNl9bN5uqhnE9ecXI82E=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5932.eurprd05.prod.outlook.com (20.179.9.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 20:34:13 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:34:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
Thread-Topic: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
Thread-Index: AQHVDJF5FWVnYyzo6UCV+YsYkW6mZKZvxqGA
Date:   Fri, 17 May 2019 20:34:13 +0000
Message-ID: <4702c2da4a5a8a065f36c5414fa4057ba9f12883.camel@mellanox.com>
References: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a0fb112-50b3-4ebf-cf4d-08d6db070626
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5932;
x-ms-traffictypediagnostic: DB8PR05MB5932:
x-microsoft-antispam-prvs: <DB8PR05MB59320EF7AB15A98F187406D1BE0B0@DB8PR05MB5932.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(39860400002)(346002)(136003)(51914003)(189003)(199004)(8676002)(4326008)(110136005)(36756003)(6436002)(71190400001)(3846002)(6116002)(2906002)(6486002)(53936002)(76116006)(71200400001)(229853002)(316002)(14454004)(99286004)(66066001)(5660300002)(6506007)(6636002)(6246003)(81156014)(6512007)(91956017)(81166006)(76176011)(102836004)(66556008)(64756008)(476003)(2616005)(66446008)(25786009)(486006)(66946007)(2501003)(73956011)(256004)(11346002)(118296001)(305945005)(446003)(26005)(8936002)(58126008)(7736002)(86362001)(478600001)(68736007)(186003)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5932;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wy19GMyHAs0iJ7VJdVygbyxjuRegGjkqRd3UlYkBwfJoJjCGTKHBflVIRpdJsm2sZWksvnN1KP9LFCJnwNzNVsLwr/xfuW0FhPlDO+ErkMPJpNeexcNpnupjnHnd/9qKbLah4CUgLQkS6j+V61HMcnYRAQyabQKQEKSvU17ssdQwnuTPMwE+wli6hfcE5gsaxSHGAPaJkZCrp20rSrdRBWt5a5GYCbF16urEvNV410u/OiAKgQ8iC7asrzTaGhXrW6bVqTywmRSdkCZDSMAOhwYcV1Q+WwLOIf8gqmnsbCA/eR0JF2t65nLLxxWWkxwWC7Wn6tG+VIZqFfReSBdkWYYwwdaMfCeVLqy6/V7NQNW0/3qWRtvO35qIZ5R9vGGc3VMLTymYXuTtKaabpfgq5Zczl5obTLaxhFl0PNnnv18=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85C4F3153E71404CA118374F8FDA853A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0fb112-50b3-4ebf-cf4d-08d6db070626
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:34:13.3364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5932
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTE3IGF0IDE3OjE3ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBUaGUgbWx4NWUgc3VwcG9y
dCB0aGUgbGFnIG1vZGUuIFdoZW4gYWRkIG1seF9wMCBhbmQgbWx4X3AxIHRvIGJvbmQwLg0KPiBw
YWNrZXQgcmVjZWl2ZWQgZnJvbSBtbHhfcDAgb3IgbWx4X3AxIGFuZCBpbiB0aGUgaW5ncmVzcyB0
YyBmbG93ZXINCj4gZm9yd2FyZCB0byB2ZjAuIFRoZSB0YyBydWxlIGNhbid0IGJlIG9mZmxvYWRl
ZCBiZWNhdXNlIHRoZXJlIGlzDQo+IG5vIGluZHJfcmVnaXN0ZXJfYmxvY2sgZm9yIHRoZSBib25k
aW5nIGRldmljZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+
DQoNCkhpIFdlbnh1LCB0aGFua3MgZm9yIHRoZSBwYXRjaA0KDQpJIHdvdWxkIGxpa2UgdG8gd2Fp
dCBmb3Igc29tZSBmZWVkYmFjayBmcm9tIFJvaSBhbmQgaGlzIHRlYW0sIA0KR3V5cyBjYW4geW91
IHBsZWFzZSBwcm92aWRlIGZlZWRiYWNrID8NCg0KVGhhbmtzLA0KU2FlZWQNCg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyB8IDEgKw0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+IGluZGV4IDkxZTI0
ZjEuLjEzNGZhMGIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4gQEAgLTc5Niw2ICs3OTYsNyBAQCBzdGF0aWMgaW50IG1s
eDVlX25pY19yZXBfbmV0ZGV2aWNlX2V2ZW50KHN0cnVjdA0KPiBub3RpZmllcl9ibG9jayAqbmIs
DQo+ICAJc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IG5ldGRldl9ub3RpZmllcl9pbmZvX3Rv
X2RldihwdHIpOw0KPiAgDQo+ICAJaWYgKCFtbHg1ZV90Y190dW5fZGV2aWNlX3RvX29mZmxvYWQo
cHJpdiwgbmV0ZGV2KSAmJg0KPiArCSAgICAhbmV0aWZfaXNfYm9uZF9tYXN0ZXIobmV0ZGV2KSAm
Jg0KPiAgCSAgICAhaXNfdmxhbl9kZXYobmV0ZGV2KSkNCj4gIAkJcmV0dXJuIE5PVElGWV9PSzsN
Cj4gIA0K
