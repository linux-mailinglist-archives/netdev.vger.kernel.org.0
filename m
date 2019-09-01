Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B574A4826
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 09:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbfIAHiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 03:38:04 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:57318
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfIAHiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 03:38:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjqokHzsgQNASUL9HBtbAm7V9+sr81c1h4HWHAs7Jl7fPr8LLCef2htK2SnxIsJYgxDMDypE9u9tNyVHpHrU4mrsSv1SAIR4+7KThyAv1goyZmeVAyjmQDsBV/26Fo2sbqXjEwXjq8xMXcQW/9fyQtvcru6FzfubKQmkv+3sMefLTxGc7aCDOiH3J1I+uOTAnqxvGkD3AnCWunS5mz+a60j3rUn6yHT6mCFZE+ZFw+UZ0VJl9nA3FQ/uitDWZvO30LX87mKOBfEDSkCf6W9Hmy+orXO1HjpWjdLs5rRUDv6TM1AasO+x62FOJDpa0WmWNPcqT4Ph9C3FhNnd7MiSrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDuwY9E13rXFPLCF48ywS9hBRiZnUSF/iGEK2g67mxQ=;
 b=MKx/Z5QMi9Cam1AZWBaGPe3/E2KdETWO9gcGkRvIjP9zSZdl73dHGib81x6f+MyBpVNpAtn+ICATY3dCo4+OLc6T1tEg/v4E+T9j0OEjUFlqzwrDP2D7X7tv1D0mxeL9wBTmK3HClhWYsuxPCb2FVcGucbGEUKCS5l5YE6j42lJ14LzcGSwVpa/w6JXL2dAW2uF8qvuzswCtW4KllCENoZaIfXNlzLuZecjWet+lWM5gjuNMMqbGxhHYKmOmn6O9ZO6h61Gnsu05q2pZjNgrL/ih2xd1AoRbEkHfsCtlFH8WvaY/njjYGkJZAVir3Jmwq/W9ytx1z2PAgy3KVqZhAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDuwY9E13rXFPLCF48ywS9hBRiZnUSF/iGEK2g67mxQ=;
 b=m8ekW/vyaJhsRLrN8SLMce+IZl2JNU73qb8LkulzyAqPf47xB4Yic1t5aewxCX6+4RGyMqT6lTV7Tl5e6QJVM0D4+2jtqeBj7zpvD+qM9dgUoa8QQXL5UB0UI2SBiLPjBh+rBzoXuI4XpZ+KlamfNCYximl1yRHcmYD4ZaGgO10=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB6488.eurprd05.prod.outlook.com (20.179.7.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Sun, 1 Sep 2019 07:38:00 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::f9dc:5bc5:b4b:8e90]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::f9dc:5bc5:b4b:8e90%7]) with mapi id 15.20.2220.021; Sun, 1 Sep 2019
 07:38:00 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next v2] mlx5: Add missing init_net check in FIB
 notifier
Thread-Topic: [patch net-next v2] mlx5: Add missing init_net check in FIB
 notifier
Thread-Index: AQHVXwx+CfIjhF/x7EmrSGL5yqgBOqcWcj+A
Date:   Sun, 1 Sep 2019 07:38:00 +0000
Message-ID: <5c5379ea-1d3c-6e02-e100-b67bd0effb1f@mellanox.com>
References: <20190830082530.8958-1-jiri@resnulli.us>
In-Reply-To: <20190830082530.8958-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-clientproxiedby: AM4PR0101CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::33) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6946a9c-afc7-472e-7310-08d72eaf506e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6488;
x-ms-traffictypediagnostic: AM6PR05MB6488:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6488A722AAF43AC9E96281B6B5BF0@AM6PR05MB6488.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:30;
x-forefront-prvs: 0147E151B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(346002)(366004)(39850400004)(199004)(189003)(25786009)(86362001)(4326008)(31686004)(14444005)(71190400001)(71200400001)(66446008)(64756008)(99286004)(6506007)(256004)(11346002)(478600001)(66476007)(486006)(2616005)(476003)(102836004)(76176011)(52116002)(4744005)(65806001)(65956001)(66066001)(5660300002)(53546011)(386003)(26005)(36756003)(8936002)(66556008)(186003)(66946007)(229853002)(14454004)(446003)(107886003)(58126008)(110136005)(6512007)(54906003)(53936002)(316002)(6436002)(305945005)(6486002)(6246003)(3846002)(2906002)(6116002)(81166006)(81156014)(8676002)(2501003)(31696002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6488;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0xoCJqQExs9fY1gScxZL9qiuwEQKFAD9JpBcEbe+CwCCXs3DPWOQafoZdOHdAh1rsbhZuJaDgPwXtIoaQnDKDOTepPyp5jN+1dmjGzjpCCtD3F4aCnNTQiv2zH2TECOxbal4fa/f18U63nB9ky+ah0ZujBA4Pb/4ha1p09Qpr+05+EMLAC7+rAQhMEZx9XX6vKK7fORHvc+t+nFrusXyfiHqhXOeGkCfV93U7e0TC5YWoXYEVlPfDOaTgmlF/rUBJufqoLRfrgvnFFbMiIGLcpEdpS8jke7IccsNiGmF5csFIcFIn/9iiJopKh2pfu+996oj+wOayROFFX/owha2V8FXR0Ylec8npVzgs41Foh2qBobMgKCG6lMfgIccDUjC9rBD99Ud+45sQn6dvkgEz9NofA0sVFMiZ0paBN0l3xQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D6BC9434BF80845A761FF4015D9AC48@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6946a9c-afc7-472e-7310-08d72eaf506e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2019 07:38:00.2213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7cRR8+aalZ0cCE3si/fWQUUo1hc7tRRVcgzXDsPjal6UNWqOCW+/mPcgAMDO4QarHDowVxW6D5t5yDMN1JLmhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6488
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMDgtMzAgMTE6MjUgQU0sIEppcmkgUGlya28gd3JvdGU6DQo+IEZyb206IEpp
cmkgUGlya28gPGppcmlAbWVsbGFub3guY29tPg0KPiANCj4gVGFrZSBvbmx5IEZJQiBldmVudHMg
dGhhdCBhcmUgaGFwcGVuaW5nIGluIGluaXRfbmV0IGludG8gYWNjb3VudC4gTm8gb3RoZXINCj4g
bmFtZXNwYWNlcyBhcmUgc3VwcG9ydGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmlyaSBQaXJr
byA8amlyaUBtZWxsYW5veC5jb20+DQo+IC0tLQ0KPiB2MS0+djI6DQo+IC0gbm8gY2hhbmdlLCBq
dXN0IGNjZWQgbWFpbnRhaW5lcnMgKGZhdCBmaW5nZXIgbWFkZSBtZSBhdm9pZCB0aGVtIGluIHYx
KQ0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9sYWdf
bXAuYyB8IDMgKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xhZ19t
cC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xhZ19tcC5jDQo+
IGluZGV4IGU2OTc2NjM5Mzk5MC4uNWQyMGQ2MTU2NjNlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGFnX21wLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xhZ19tcC5jDQo+IEBAIC0yNDgsNiAr
MjQ4LDkgQEAgc3RhdGljIGludCBtbHg1X2xhZ19maWJfZXZlbnQoc3RydWN0IG5vdGlmaWVyX2Js
b2NrICpuYiwNCj4gIAlzdHJ1Y3QgbmV0X2RldmljZSAqZmliX2RldjsNCj4gIAlzdHJ1Y3QgZmli
X2luZm8gKmZpOw0KPiAgDQo+ICsJaWYgKCFuZXRfZXEoaW5mby0+bmV0LCAmaW5pdF9uZXQpKQ0K
PiArCQlyZXR1cm4gTk9USUZZX0RPTkU7DQo+ICsNCj4gIAlpZiAoaW5mby0+ZmFtaWx5ICE9IEFG
X0lORVQpDQo+ICAJCXJldHVybiBOT1RJRllfRE9ORTsNCj4gIA0KPiANCg0KdGhhbmtzDQoNCkFj
a2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0K
