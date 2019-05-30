Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C220A30048
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 18:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfE3QnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 12:43:20 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:38446
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbfE3QnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 12:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ExmO83JvLWng6K/x7qv2Jib272lsgPmH76UBg2XahM0=;
 b=sA3uQy0nm9iQaAYm+UQ0I7S0vE1aQRrl5R1d3Z2yF+wlvA0FRcOM9H1ZECRMnm0B1EX5N4sOeFBYXCHvRAhCLz6DIbdHM4gK0Hsk2BqzWG6tH9CrRK6er8aIhlDCaU5cvxNcyuuDSG5yWaFu+wACKr5pkRfd2zlV1SIuuyd3NVE=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2589.eurprd03.prod.outlook.com (10.171.104.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Thu, 30 May 2019 16:43:15 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 16:43:15 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [RFC PATCH iproute2-next 0/1] tc: add support for act ctinfo
Thread-Topic: [RFC PATCH iproute2-next 0/1] tc: add support for act ctinfo
Thread-Index: AQHVFwbHscI50gWIsUG6iXIioZb2Zg==
Date:   Thu, 30 May 2019 16:43:15 +0000
Message-ID: <20190530164246.17955-1-ldir@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0003.eurprd03.prod.outlook.com (2603:10a6:20b::16)
 To VI1PR0302MB2750.eurprd03.prod.outlook.com (2603:10a6:800:e3::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1 (Apple Git-117)
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6ed4e36-a6fc-48a4-c49a-08d6e51de950
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0302MB2589;
x-ms-traffictypediagnostic: VI1PR0302MB2589:
x-microsoft-antispam-prvs: <VI1PR0302MB25891E9E787A5B2AC5804C3FC9180@VI1PR0302MB2589.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39830400003)(346002)(366004)(136003)(376002)(199004)(189003)(486006)(36756003)(8936002)(66946007)(53936002)(66446008)(64756008)(66556008)(66476007)(68736007)(46003)(50226002)(73956011)(476003)(14454004)(2616005)(2501003)(5660300002)(110136005)(186003)(71190400001)(2906002)(71200400001)(74482002)(508600001)(4326008)(25786009)(256004)(14444005)(107886003)(305945005)(99286004)(6436002)(6506007)(52116002)(1076003)(6116002)(386003)(316002)(86362001)(81156014)(6486002)(81166006)(7736002)(8676002)(6512007)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2589;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jb8S9g+nlaXiHYIu4RirnRhu7LW1/UVNr2YKBF7XUm3UaDqvM3dwjzoTtRWXnTDMn5LU99r2wetroGlgohDizn1A/uqAt9kJJ21aMS99YVgovhPTyEKxsvQ6L5rBxIKyo4vE/5kCyzER0iP9n1DN5SW8TEycHrXADIQyyDPRuZNVQx7JJC6EmglTPvPaPtKNHNzrYXRvBqFCoQHhx/7hdvPtAeKttpXxb670HnEHs65uiHdFMu+3/TgKOJ4AU0FiG8Ekl03b/6+FcttPgielBGoAgVxdb2cVY8SdLmC8UCWlJXCB/gU5mFcjeBTtklrRfBL+6mCaaWrgckA76bR0UOZEu17/WW6bOYK4WklaGOWFBP7xyy4cUSCdNIkCFy6pgyQBgvpeqa4SeTH6qNOJkAEwhu45f72tGeNv9WZWdYE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ed4e36-a6fc-48a4-c49a-08d6e51de950
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 16:43:15.5594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3RpbGwgaGlnaCBvbiB0aGUgZ29vZHMgb2YgYWN0X2N0aW5mbyBiZWluZyBhY2NlcHRlZCBpbnRv
IGtlcm5lbA0KbmV0LW5leHQgSSB0aG91Z2h0IGl0IHdvdWxkIGJlIGEgZ29vZCBpZGVhIHRvIG9m
ZmVyIHRoZSB1c2VyIHNwYWNlIHRjDQpzaWRlIG9mIHRoaW5ncyB0byBjb250cm9sIHRoZSB3ZWUg
YmVhc3RpZS4NCg0KSXQncyBhIHByZXR0eSBzaGFtZWxlc3MgY29weS9zaHVudC9wYXN0ZS9oYWNr
IG9mIG1fY29ubm1hcmsgYW5kIHNvbWUgb2YNCnRoZSBvdGhlciB0YyBhY3Rpb24gY29udHJvbCBw
cm9ncmFtcyBhbmQgZG9lcyBmdW5kYW1lbnRhbGx5IHdvcmsgKHVzZWQNCmZvciB0ZXN0aW5nIG9m
IHRoZSBrZXJuZWwgbW9kdWxlKQ0KDQpUaGVyZSBhcmUgbm8gZG91YnQgc29tZSBzaGFycCBlZGdl
cyB0aGF0IEknZCBsaWtlIHRvIGtub2NrIHRoZSBjb3JuZXJzDQpvZmYgYmVmb3JlIGEgcmVhbGlz
dGljIGF0dGVtcHQgYXQgc3VibWl0dGluZywgc28gdGhpcyBpcyBhIGdlbmVyYWwgUkZDDQpjYWxs
IHRvIHNlZSB3aGF0IEkndmUgZnVuZGFtZW50YWxseSBkb25lIHdyb25nIGFuZCBjYW4gY2xlYW4g
dXAuDQoNCmVnLiBJIGRvIHVwZGF0ZSB1YXBpL2xpbnV4L3BrdF9jbHMuaCB0byBtYXRjaCB0aGUg
cmVsZXZhbnQgYml0cyBvZiB3aGF0DQpoYXMgZ29uZSB1cHN0cmVhbSBmb3IgYWN0X2N0aW5mby4g
IFNob3VsZCB0aGlzIGJlIGEgc2VwYXJhdGUgY29tbWl0Pw0KDQpLZXZpbiBEYXJieXNoaXJlLUJy
eWFudCAoMSk6DQogIHRjOiBhZGQgc3VwcG9ydCBmb3IgYWN0IGN0aW5mbw0KDQogaW5jbHVkZS91
YXBpL2xpbnV4L3BrdF9jbHMuaCAgICAgICAgICB8ICAgMyArLQ0KIGluY2x1ZGUvdWFwaS9saW51
eC90Y19hY3QvdGNfY3RpbmZvLmggfCAgMzQgKysrKw0KIHRjL01ha2VmaWxlICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIDEgKw0KIHRjL21fY3RpbmZvLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAyNDQgKysrKysrKysrKysrKysrKysrKysrKysrKysNCiA0IGZpbGVzIGNoYW5nZWQs
IDI4MSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGlu
Y2x1ZGUvdWFwaS9saW51eC90Y19hY3QvdGNfY3RpbmZvLmgNCiBjcmVhdGUgbW9kZSAxMDA2NDQg
dGMvbV9jdGluZm8uYw0KDQotLSANCjIuMjAuMSAoQXBwbGUgR2l0LTExNykNCg0K
