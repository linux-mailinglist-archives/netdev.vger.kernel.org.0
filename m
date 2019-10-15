Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEA2D8129
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388192AbfJOUf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:35:59 -0400
Received: from mail-eopbgr130054.outbound.protection.outlook.com ([40.107.13.54]:45539
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388181AbfJOUf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8zt+/St0O61QbcFOpKr0kc2Hj47H4QmCATV4qTy0mkGpCkeS6VR8DHBMQEY5uxckSpFDwv0mEDUseH14zmgrsl6NyAiAGTsyhtu1p0S56AYP2KyZklFCQiWS5ElFXGEta9aJkIToOh8Sk/l8ngMf/mM0dKPfuUWLTKCN4jvLH3xLdiU1wQUaKcX0Pg6VOEhoKJKsESvw9iBvPQFhJOqzjIx8WwoB+bwtDegMTRSvsT/ITCWQd2RVQCkwWsGf/kqG3TGxSDO18wlI+mPbNiONyeRqPMu/2cZAHi5oNNoLDy1PKlhFH0nnbzO/tgObXQXLQTp/0yCVzZnOpkI/DZYcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcopBE6NeTqqMktisYVTDBusYpcrpWWjjMiFZ7GOUzY=;
 b=T1MXFKeScRck1uZh5VrmN3TsNSzP31m4Vc5E6YRHPb24Whi2f8caaZB+kY31qZq4yZhV1MBn66/8VwAxt+rbeOYeUzQpbp2Sto9yfBp3aQBaxW2itwG6NPS/w3MnQQEVitDBlcx8dYFUObUkp2v9HvJe162EDMhHLucYjyI73cpMinbmDp832P/NZtJVz2NiFKpYHt06TlopPyGk7Xb6UbHV6kCFmTQOPlATaZ3NZLTDF1HnSeZdJY9fR57pj8EAN91CZ666TYmzNelLBeTuqASpHCdd05UmnJSwnpmxTKsHZihif6LEdWg3uS60KJ+NQi6/PIMdQz1i7kNtwwtxNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcopBE6NeTqqMktisYVTDBusYpcrpWWjjMiFZ7GOUzY=;
 b=DewrhvQkSuhnT5A9UL1mHb5bSYlVhIsJ/ZQB1Jbi55YpeAI9jANOkWJQYKZnjUn/OezrBHGrapfWVzmiFXudj1EyVTHbw29SgL0KSreSONOqsdmwXvijZHZmQtEA5655Y5TBuI3zTCvM5q1JPlTPblK16TVRZGx3mFLlFEDvmrg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5597.eurprd05.prod.outlook.com (20.177.203.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Tue, 15 Oct 2019 20:35:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:35:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "navid.emamdoost@gmail.com" <navid.emamdoost@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "emamd001@umn.edu" <emamd001@umn.edu>,
        Tariq Toukan <tariqt@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "smccaman@umn.edu" <smccaman@umn.edu>,
        "leon@kernel.org" <leon@kernel.org>, "kjlu@umn.edu" <kjlu@umn.edu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: prevent memory leak in mlx5_fpga_conn_create_cq
Thread-Topic: [PATCH] net/mlx5: prevent memory leak in
 mlx5_fpga_conn_create_cq
Thread-Index: AQHVc1A9npAQKe9mq0SefCQK7t6REac/NdgAgB0TzQA=
Date:   Tue, 15 Oct 2019 20:35:54 +0000
Message-ID: <ded2700707fbf0919a123e17228a0a26913379e8.camel@mellanox.com>
References: <20190925032038.22943-1-navid.emamdoost@gmail.com>
         <20190927.103328.1345010550910672678.davem@davemloft.net>
In-Reply-To: <20190927.103328.1345010550910672678.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 339faeff-3c6e-4208-a4fb-08d751af46ee
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB5597:|VI1PR05MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB55971C273C6D2034A11AE393BE930@VI1PR05MB5597.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(2906002)(256004)(76176011)(8936002)(316002)(3846002)(6116002)(6506007)(6512007)(102836004)(4326008)(81156014)(6246003)(229853002)(8676002)(6436002)(81166006)(478600001)(2616005)(6486002)(11346002)(446003)(476003)(25786009)(486006)(186003)(58126008)(99286004)(86362001)(7736002)(26005)(305945005)(71200400001)(71190400001)(36756003)(110136005)(54906003)(4744005)(118296001)(91956017)(76116006)(64756008)(66556008)(66446008)(66476007)(66946007)(2501003)(66066001)(14454004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5597;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 25PsR9B082nK71LoaElt989qllu3Q5qCEQLEC8130Tret23nNyQVeS6Fi/yqEnB14WAW4drZfXahFkZvcrroVZKsgiRsVNUJ5kk/cg/txYQAcjKr+ng9t29Uaws7wmoSGcQQJp8KuZF/0EhX47fKffTv45eW/jec8YIySNlYTGbS5ti4tinkUkEY7s1yVWPNDbg3Q+DTg5pgQOSwRcknRKZ4klu7og8KYcUb83ZYkkuK0JuoZjOsMutK4q9fTLjCYF7Efvwu/IZCF0I3qw7ZAT6viLyydr3v5EQRGYFM6ruLQbniCePbHhO6cHZR9N/Y/m75zm5hBH4qzyOOGlH67Nuh+uiWo9IiHXgMXQJxasB4jhZhoKfrLh9MkFcDIGmCxbplu94lAC68eIA9/v0gCcIt+OCdJS85IzwvU2akueY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06B99AB5F2C33B40868ADBB60567EE36@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 339faeff-3c6e-4208-a4fb-08d751af46ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:35:54.5427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aeFmyVwr9xYfe4g3kA80D7g0stgQNgKpxuXtzYvEVmw4Q7SbfG+mjIWGhpr0KcG5BDtU8vlvIIbKTUiChZDKwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5597
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA5LTI3IGF0IDEwOjMzICswMjAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IE5hdmlkIEVtYW1kb29zdCA8bmF2aWQuZW1hbWRvb3N0QGdtYWlsLmNvbT4NCj4gRGF0
ZTogVHVlLCAyNCBTZXAgMjAxOSAyMjoyMDozNCAtMDUwMA0KPiANCj4gPiBJbiBtbHg1X2ZwZ2Ff
Y29ubl9jcmVhdGVfY3EgaWYgbWx4NV92ZWN0b3IyZXFuIGZhaWxzIHRoZSBhbGxvY2F0ZWQNCj4g
PiBtZW1vcnkgc2hvdWxkIGJlIHJlbGVhc2VkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IE5h
dmlkIEVtYW1kb29zdCA8bmF2aWQuZW1hbWRvb3N0QGdtYWlsLmNvbT4NCj4gDQo+IFNhZWVkLCBw
bGVhc2UgcXVldWUgdGhpcyB1cC4NCg0KQXBwbGllZCB0byBuZXQtbWx4NSBicmFuY2ggd2lsbCBz
ZW5kIGl0IHRvIG5ldCBicmFuY2ggc2hvcnRseS4NCg==
