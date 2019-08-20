Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127DD95F47
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfHTM41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:56:27 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:59995
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729260AbfHTM41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 08:56:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wo/0xFtydN3vzhwzxEGwURw2g5UyyOj6aCXNglHVW/I5Z+ZdoerCXBa71UHBBmjuU0lhfcdbU4IVYRAsVqYW768yGVyrkWbwbLh5ee17cbK6s4runPfVVB1eH0cuFD1jhNzoEP+QsOXaeVVQXqzY1bqqdqjIQleMbpn12S7VsAUDbyvtfwWVBdkQ306qkHYG+R6x7DOxpvY2ObrbfxYoPkXo8jVZpKzKa9RFzMCFNYQIRoZeGW47ge6k+yptj2VUUl/raEKNG06KknWGC7xFX80RCG5I+tS6DdPTswrZEltMm4Os4JSKs1/bLPhJd30jt4TtFjos3tdDCoii84unWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8x8R4eyFAndOyW7DOAuxs+z71qcCe0wf3hGGtJByrqI=;
 b=ggp7PlttXRylYdL0jhyazbbURu5/em7ylhh110/FVlEknB5QG7YAXA9Qk22rrpCd2ir9meBj82ujNxgn363xdXJrawSuJcTNB/at9yUUTP9sf5z84ad6zJ4eZnSdYOKEk9UbVUazSTLXDSBC/feGc03p/TwxAXta24iyQWh6Zymu11hmSKkoI21Er8emUGIzAa3tj0nP19yIlL8/bxDpGEmgDuZjQwseKJXF6mjA0NBIy/PpklqDTjjBXrA3MGQBMds46ERADbXXmZQNQmwQWPPIZyHRyCLegvJeHlP5XCols7V6msdlMPT+vZqfmvrpJfZz0CTqOSA74BmvXP1jFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8x8R4eyFAndOyW7DOAuxs+z71qcCe0wf3hGGtJByrqI=;
 b=UsisJ4JK90YrtbcQ7UbBuGkIAbzNaNmINTdgA3BTIa3fwI1INrJAqFx1/a/RtFvsRulF5w5HN6/s6G5PWiKo+6Xlo40VzHWI84JBplNkBAmDACV83IQA/04ZnQet3BWCINYkpW6NLfB//gCO/xeszLcNBFc5ynY+y/zS1FcHnF0=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3473.eurprd05.prod.outlook.com (10.170.126.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 12:56:23 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 12:56:23 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Topic: [PATCH net-next v2] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Index: AQHVV1SLSJS9nzUEck6pAZSmyfPbF6cD/qkA
Date:   Tue, 20 Aug 2019 12:56:23 +0000
Message-ID: <677eef11-7f6a-ffcd-6e1d-b1b6e885ac20@mellanox.com>
References: <1566304834-22836-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1566304834-22836-1-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0025.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::13) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fef224cb-bf78-4344-2c07-08d7256dce0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3473;
x-ms-traffictypediagnostic: AM4PR05MB3473:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB347345CAA718B43030BAF56ACFAB0@AM4PR05MB3473.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(189003)(199004)(6506007)(5660300002)(71200400001)(52116002)(86362001)(76176011)(31696002)(4744005)(3846002)(31686004)(53936002)(6246003)(36756003)(110136005)(316002)(2616005)(476003)(99286004)(81156014)(6116002)(7736002)(8936002)(81166006)(305945005)(8676002)(54906003)(107886003)(25786009)(256004)(102836004)(6512007)(6436002)(6486002)(446003)(486006)(478600001)(66556008)(66476007)(66946007)(66446008)(53546011)(64756008)(71190400001)(14454004)(2906002)(2501003)(6636002)(66066001)(11346002)(4326008)(229853002)(26005)(186003)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3473;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dA35yAhrldlAh6gncdtrTdJXJbQPwSmiU+UTSEHkHNN1jUhLiu3S/k6aQLH1jsU5n9yvR7ozNk+LaK7toxHImXiDtsaIQmG7XYQh8G3baD7BgT4xCRPdFcqAnJ4tIv4Xu94e0lbr0VzXDlO+rn5UF/pq4vjRShpvbkwT9mwSuaNRmNElhAZwJ9aDyP/hu8jWxYKDwLOO/pq3X6EgZmeJ5RX4LHz0kY7qGqzPboBxvrWcs8GlAEXca3UZYlQhv0CKzPDOr+tAkddHj8/0+juU5P+HTKcXOQugvcxzQ76aZDEc6oOxmUvhQnwS9Ymck95N8nbyjMzhlElB+iaOVV8AJsHEwHJsCyqYB1ts4X119vXnDmFNNKh2D4QlX0YyLiiawH1oF5qJoGg5NZlXpAK8FEOq33seO6eZvYtDNRRAG/M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <953AFA86E6669C4E951C3C109E369A64@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef224cb-bf78-4344-2c07-08d7256dce0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 12:56:23.6669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZpBV/mXbR4fx6o7cmZuJG+xDti6nNblXOwwthHzO6I3xQKPn6dmExoPh8PzyzY35F8hHX5IS2Um7zPK8yCS3hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3473
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGV5IGd1eXMsIHNvcnJ5IGZvciBzcGFtLCBJIHVzZWQgdGhlIC0taW4tcmVwbHktdG/CoCB0aGlz
IHRpbWUgc28gaXQgZ2V0cyANCnRvIHRoZSBvcmlnaW5hbCB0aHJlYWQgKCJbUEFUQ0ggbmV0LW5l
eHQgdjJdIG5ldDogb3BlbnZzd2l0Y2g6IFNldCBPdlMgDQpyZWNpcmNfaWQgZnJvbSB0YyBjaGFp
biBpbmRleCIpICwNCg0KSWdub3JlIHRoaXMgdGhyZWFkIGFuZCByZXNwb25kIHRoZXJlIGlmIG5l
ZWRlZC4NCg0KVGhhbmtzLg0KDQoNCk9uIDgvMjAvMjAxOSAzOjQwIFBNLCBQYXVsIEJsYWtleSB3
cm90ZToNCj4gUmVnYXJkaW5nIHRoZSB1c2VyX2ZlYXR1cmVzIGNoYW5nZSwgSSB0ZXN0ZWQgdGhl
IGFib3ZlIHBhdGNoIHdpdGggdGhpcyBvbmUgaW4NCj4gdXNlcnNwYWNlIHRoYXQgSSdsbCBzZW5k
IG9uY2UgdGhpcyBpcyBhY2NlcHRlZCwgdG9nb3RoZXIgd2l0aCB0aGUgcmVzdA0KPiBvZiBjb25u
ZWN0aW9uIHRyYWNraW5nIG9mZmxvYWQgcGF0Y2hlcy4NCj4NCj4gSSBhbHNvIGhhdmUgYSB0ZXN0
IGZvciBpdCwgaWYgYW55b25lIHdhbnRzIGl0Lg0KPg0KPiBQYXRjaCBpczoNCj4gbGliL25ldGRl
di1vZmZsb2Fkcy10YzogUHJvYmUgcmVjaXJjIHRjIHNoYXJpbmcgZmVhdHVyZSBvbiBmaXJzdCBy
ZWNpcmNfaWQgcnVsZQ0KPiBbLi4uXQ0K
