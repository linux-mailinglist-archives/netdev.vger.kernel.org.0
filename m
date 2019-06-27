Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02875895A
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfF0R5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:57:16 -0400
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:8054
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726405AbfF0R5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 13:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+4apgaw8Z3FSXymsBM9SiuZfPV4DS0RyfriiDyJPSI=;
 b=Quv21VI0CnGn1Rla2rh2mWN8opkVr6JG20v2ya5eVbFjWiW9oQfpIwXD0XKM9K6Q4+f4nCBh8he8E6RpWhhJg7x3YdSfPUJXD1Ye/mU5byJHVyoqBP0V8SambgOGHebQTqvdEVHsQNAPWuNhzCuJAKfIfiqgoHubSqxji3tFH2g=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB5205.eurprd05.prod.outlook.com (20.177.196.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Thu, 27 Jun 2019 17:57:12 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::2c23:fdba:9ce4:7397]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::2c23:fdba:9ce4:7397%7]) with mapi id 15.20.2032.016; Thu, 27 Jun 2019
 17:57:12 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "idosch@idosch.org" <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 12/16] mlxsw: spectrum: PTP: Support timestamping
 on Spectrum-1
Thread-Topic: [PATCH net-next 12/16] mlxsw: spectrum: PTP: Support
 timestamping on Spectrum-1
Thread-Index: AQHVLO/HEWOost2Rm0Cf5hR3DDr4RqavuuGAgAAOuwA=
Date:   Thu, 27 Jun 2019 17:57:11 +0000
Message-ID: <87tvcaud1l.fsf@mellanox.com>
References: <20190627135259.7292-1-idosch@idosch.org>
 <20190627135259.7292-13-idosch@idosch.org>
 <20190627.100427.16208207750306183.davem@davemloft.net>
In-Reply-To: <20190627.100427.16208207750306183.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P18901CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::20) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [89.176.15.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 399f968b-96cd-48a6-7782-08d6fb28e153
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5205;
x-ms-traffictypediagnostic: AM6PR05MB5205:
x-microsoft-antispam-prvs: <AM6PR05MB5205A21BAEBC28BADB3C7DB3DBFD0@AM6PR05MB5205.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(366004)(39860400002)(189003)(199004)(86362001)(7736002)(305945005)(66066001)(6916009)(316002)(2906002)(81156014)(54906003)(5660300002)(478600001)(25786009)(66556008)(66476007)(64756008)(66446008)(73956011)(66946007)(81166006)(446003)(11346002)(4326008)(68736007)(8936002)(8676002)(256004)(6116002)(486006)(3846002)(2616005)(476003)(52116002)(99286004)(558084003)(36756003)(71200400001)(71190400001)(14454004)(76176011)(102836004)(386003)(6506007)(6436002)(6486002)(26005)(229853002)(186003)(107886003)(53936002)(6246003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5205;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0Cs7Uj9716TtEL6DKyG4TfXPHhn4rK8GB3k9tHH1U6kDv9ve+kbKeTI/bCPrgrfXrRX+h6KiBaBP+nQQRD71I+z0OrZ9teZJ7Ixdo1VuKNvL5waU1gBxG1NNOSCkPgdWUEsAcwnKFoWR+e8z453iQ9/U4cis2ea7QPPpx9kuLYgjlCJcsLThLWtyl1qBSlAQfBa957lWsNSzXsyGr9o3sb2KgTqH5K2VR0hmWBIbG7wrRUP3HBab/YxDJJQxsaRLJi6Gv8SWVSjcZAIWVtOCktlYjKWdKqedWumDAx+sDFZ7V3FCvKGOl/evCOgPQjDizpj6TuTdIa1vQNNVhj285qYMvstOEH0dIrZqXU+y+OWzK3wv++p3CSpfQJwKtFF7wlQ9ljfg/ZfvD+q1xvB606FQ6/b62vFq0ARcTVFaxok=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399f968b-96cd-48a6-7782-08d6fb28e153
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 17:57:11.9919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5205
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+IHdyaXRlczoNCg0KPiBGcm9tOiBJ
ZG8gU2NoaW1tZWwgPGlkb3NjaEBpZG9zY2gub3JnPg0KPiBEYXRlOiBUaHUsIDI3IEp1biAyMDE5
IDE2OjUyOjU1ICswMzAwDQo+DQo+PiArCWZvciAoaSA9IDA7IGkgPCBudW1fcmVjOyArK2kpIHsN
Cj4NCj4gUGxlYXNlIHVzZSB0aGUgbW9yZSBjYW5vbmljYWwgImkrKyIgaGVyZSwgdGhhbmsgeW91
Lg0KDQpPSy4NCg==
