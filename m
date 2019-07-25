Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5574975BB6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGYXz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:55:27 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:21252
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbfGYXzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 19:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag/idBxBmouT5nFXzcghiM25EOTupTkTUDFsAl6/JPHgUm8oXXhToKEa8Q3xTCSxRQU8dLghsBW0sSHeE/4j914WCfYmQIObIREjckUdYXQgJlU/PpGIkZbwnkkJFgidHhZGGvN0ngUvkUV49HR+K4HA42+UW23I820GH6LCOEVhg/tTe5zJ0Xq1S2cd1NsQ1N2sRiR8KPBkLJLNVw0RCx+Hk5iOFVw27MbG3i/+2NCmKwXKsPe38qobS3bWV7UMsfZESAbbDEKcwd98QFVXRlfPgFgnsgu0jrkcRzcAHP9Tky69SqvzOS0dAGtCfvYV1WapEvrn+91Ih1mtZSkczw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJ2WMLL7x6n6VVAs6rDUkf3pB0hBO2rQ0VmLyGL2uT0=;
 b=atMINBlWoeArd8eHDN94Lt+rUMdUv9d7r0BnaRNK6S3QeMn9xHdabe9LROi6MTF0lNMHgd3Q38RO4yFhfUAfS/E2r5vcnM0uQ/7trdtXIMkh0GovcKd3ABDEOPKV0YHBkoRs2xZV2Bov32v0xdDHoLBYb3NgWHLCjEkP/IK2ZC/X1rpFviZoY3vrXAk4gn4CiZaXP0BPdeOC1JPIfnt4BLxkMLrTGGLBPpDS1SGoRAlHDIA8p6U1RpkoAqi0kd01FDwUG2DEVNpR4Iaq+7HgwRJ9AHLtqKnDjE1UN08jyoex/Cm4dN+yn8ZHK4wdAV94sBjLBk6aYM8CT8g/8kUW6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJ2WMLL7x6n6VVAs6rDUkf3pB0hBO2rQ0VmLyGL2uT0=;
 b=EPvmGlLDC5ho/squ2oBEIIZBYaeAp+KLOXLa6TXkUG6dZ9E3xSC/3QUvoiOMdw5wTd6S/2iysUDyjSQWcSIWWKTSSdjKgsV/9f9r72exeV+nisY6o49IUkcx11JpWHQwApignOFubU4apVBjh4X9HmsqetnarRNg5vEF1p7Dpeg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2727.eurprd05.prod.outlook.com (10.172.225.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 23:55:22 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 23:55:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "snelson@pensando.io" <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 15/19] ionic: Add netdev-event handling
Thread-Topic: [PATCH v4 net-next 15/19] ionic: Add netdev-event handling
Thread-Index: AQHVQNYlISFkVNCg+UKJQielGzmgt6bcBygA
Date:   Thu, 25 Jul 2019 23:55:21 +0000
Message-ID: <a27ba11984c8872a35206bd9fbeee0800ba7b050.camel@mellanox.com>
References: <20190722214023.9513-1-snelson@pensando.io>
         <20190722214023.9513-16-snelson@pensando.io>
In-Reply-To: <20190722214023.9513-16-snelson@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec33f9fd-8181-49df-01fb-08d7115b8e35
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2727;
x-ms-traffictypediagnostic: DB6PR0501MB2727:
x-microsoft-antispam-prvs: <DB6PR0501MB27270D95DD3FE65342C49225BEC10@DB6PR0501MB2727.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(6486002)(66946007)(8676002)(6512007)(256004)(110136005)(316002)(3846002)(53936002)(36756003)(5660300002)(2201001)(86362001)(64756008)(58126008)(66556008)(66476007)(68736007)(66446008)(76116006)(25786009)(6116002)(7736002)(305945005)(446003)(91956017)(2616005)(81156014)(81166006)(11346002)(2501003)(486006)(8936002)(99286004)(476003)(76176011)(2906002)(71200400001)(478600001)(26005)(558084003)(186003)(118296001)(66066001)(229853002)(71190400001)(14454004)(6506007)(6436002)(102836004)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2727;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8lVx5dHGMjmbGzZgS0nRnk3BM4du0Ie91tjH1teJtmd5eNC9KVF9gCPC3GPXltr/nWRnyIS+8OOcL99Ed/mrU9hHBGVNuqSlEH3frgtsLY85ETFTre3XdVyXa1GXJZu1HLQhNHy7sgM5KMmtfwyU/9/ZklNOhXdJyAfOr6Q307pZY9EX2uB3xKMitf5cp01ETMPX5ndUUD+zks2hKJUd2FPib6QYA3FJsh8EIAgQvLtYlA6b/wcUvsjTom0Zl2arFYCZpnfxtxuzhU1cPwsMXi9CFFz35wPvHDLvWUrIDlQlpdQO4o2OyeL9AEK71Kku+MYZWe+4ZJgYTyFqPK3NvryagF5UsmWAZUjPFxpJTHPgO8bukaoAkwTA7rvOn7knXqY9u+1keh0E2dexbuzEI+DnvxrPvBch9N6JmLE2TOU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E6B0401DF3A2F4CA032393AF4D5565E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec33f9fd-8181-49df-01fb-08d7115b8e35
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 23:55:21.9750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTIyIGF0IDE0OjQwIC0wNzAwLCBTaGFubm9uIE5lbHNvbiB3cm90ZToN
Cj4gV2hlbiB0aGUgbmV0ZGV2IGdldHMgYSBuZXcgbmFtZSBmcm9tIHVzZXJsYW5kLCBwYXNzIHRo
YXQgbmFtZQ0KPiBkb3duIHRvIHRoZSBOSUMgZm9yIGludGVybmFsIHRyYWNraW5nLg0KPiANCg0K
SnVzdCBvdXQgb2YgY3VyaW9zaXR5LCB3aHkgeW91ciBOSUMgaW50ZXJuYWwgZGV2aWNlL2Zpcm13
YXJlIG5lZWQgdG8NCmtlZXAgdHJhY2tpbmcgb2YgdGhlIG5ldGRldiBuYW1lID8NCg0KDQo=
