Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172CD5AF45
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 09:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfF3H4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 03:56:52 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:46702
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725959AbfF3H4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 03:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRfKd7OkaMZpU5IndeOP5fyQD4Qqc0uYjKJfx4JTapk=;
 b=rm+yEgDdjXNo03grj9u7qTYqJ65bHPmsNZqym5GqN549052kFv8/XYq9zqQabJO2ljn/Qg8XhtQcYRJEfBS3HDXuS9kUlQO4JuvXLLvf7NpN90+KhZr2xoojBmV3LCx82cgQkp9ilVrlKVcSc7kymY1OL/gHuFKM9A27PLu3Zto=
Received: from VI1PR05MB6285.eurprd05.prod.outlook.com (20.179.24.85) by
 VI1PR05MB5440.eurprd05.prod.outlook.com (20.177.200.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Sun, 30 Jun 2019 07:56:48 +0000
Received: from VI1PR05MB6285.eurprd05.prod.outlook.com
 ([fe80::98e1:ebf4:c63e:7388]) by VI1PR05MB6285.eurprd05.prod.outlook.com
 ([fe80::98e1:ebf4:c63e:7388%6]) with mapi id 15.20.2008.014; Sun, 30 Jun 2019
 07:56:48 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Miller <davem@davemloft.net>, "fw@strlen.de" <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ran Rozenstein <ranro@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Thread-Topic: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
Thread-Index: AQHVLOBaV/70ff2t5kGwV9qdZG2IyKavuFoAgAQgnQA=
Date:   Sun, 30 Jun 2019 07:56:48 +0000
Message-ID: <d419cd16-e693-2214-fa41-4c9c81f1649d@mellanox.com>
References: <20190627120333.12469-1-fw@strlen.de>
 <20190627.095458.1221651269287757130.davem@davemloft.net>
In-Reply-To: <20190627.095458.1221651269287757130.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0019.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::32) To VI1PR05MB6285.eurprd05.prod.outlook.com
 (2603:10a6:803:f1::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0bc6841-ca4e-405a-53c9-08d6fd308090
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5440;
x-ms-traffictypediagnostic: VI1PR05MB5440:
x-microsoft-antispam-prvs: <VI1PR05MB5440A98393DCB48F3057BC52AEFE0@VI1PR05MB5440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(189003)(199004)(6512007)(52116002)(76176011)(110136005)(107886003)(71190400001)(14454004)(71200400001)(316002)(6246003)(36756003)(486006)(11346002)(2501003)(4744005)(476003)(2616005)(7736002)(54906003)(26005)(53936002)(305945005)(4326008)(68736007)(14444005)(256004)(31686004)(186003)(5660300002)(25786009)(386003)(64756008)(73956011)(99286004)(446003)(53546011)(6486002)(81156014)(81166006)(8676002)(66446008)(229853002)(6436002)(66556008)(66476007)(66946007)(6506007)(2906002)(86362001)(8936002)(31696002)(66066001)(478600001)(3846002)(6116002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5440;H:VI1PR05MB6285.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bKRfPiPJ3OZ7v/Qz9rw55L5S4Raws7lIGIHXKUhIRI0+l1YtHPT3L8PSWX//kXBrmGXZPBfE51NFlzN1lbgI9ApQ8OriaeNMLrFsRP9ec4QDNzTnd9uuDbg1NtWBp19aBzXyDUFh8dLpiG7v1Ed9lOxut57uuf1Zu8V+l6GDvFbcHjYVAlPR/WnzFbrU5w59LVI/Tq5vJwx7u4YpBs11LiftDFQgaV1oskmSNXcSHe/6UaTRTF7EYO0eRUm39VWLFNjT74cfa0l0hjm91Y778d7VUAgLYFBLh/BdHn0ui7o3geWLl6R/616ZQRGmh0P1YtjJShU9712AmIpA7PYmosPE3XoxMc8qrTPwH5NPFC/CAXgBxjf6DYDuMRpxmBeZwZVANTa84+7OvVYPMXSRlrhRLm4cdc9VgEfbb/ZpaI8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EFA6FE8A3585E41A394345F7F4D0D46@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bc6841-ca4e-405a-53c9-08d6fd308090
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 07:56:48.0941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjcvMjAxOSA3OjU0IFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+IEZyb206IEZs
b3JpYW4gV2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT4NCj4gRGF0ZTogVGh1LCAyNyBKdW4gMjAxOSAx
NDowMzozMSArMDIwMA0KPiANCj4+IFRhcmlxIGFuZCBSYW4gcmVwb3J0ZWQgYSByZWdyZXNzaW9u
IGNhdXNlZCBieSBuZXQtbmV4dCBjb21taXQNCj4+IDI2MzhlYjhiNTBjZiAoIm5ldDogaXB2NDog
cHJvdmlkZSBfX3JjdSBhbm5vdGF0aW9uIGZvciBpZmFfbGlzdCIpLg0KPj4NCj4+IFRoaXMgaGFw
cGVucyB3aGVuIG5ldC5pcHY0LmNvbmYuJGRldi5wcm9tb3RlX3NlY29uZGFyaWVzIHN5c2N0bCBp
cw0KPj4gZW5hYmxlZCAtLSB3ZSBjYW4gYXJyYW5nZSBmb3IgaWZhLT5uZXh0IHRvIHBvaW50IGF0
IGlmYSwgc28gbmV4dA0KPj4gcHJvY2VzcyB0aGF0IHRyaWVzIHRvIHdhbGsgdGhlIGxpc3QgbG9v
cHMgZm9yZXZlci4NCj4+DQo+PiBGaXggdGhpcyBhbmQgZXh0ZW5kIHJ0bmV0bGluay5zaCB3aXRo
IGEgc21hbGwgdGVzdCBjYXNlIGZvciB0aGlzLg0KPiANCj4gU2VyaWVzIGFwcGxpZWQsIHRoYW5r
cyBGbG9yaWFuLg0KPiANCg0KVGhhbmtzIEZsb3JpYW4hDQoNClJhbiwgcGxlYXNlIHRlc3QgYW5k
IHVwZGF0ZS4NCg0KVGFyaXENCg==
