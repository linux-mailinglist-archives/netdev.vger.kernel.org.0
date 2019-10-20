Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4CDDD36
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 09:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJTHqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 03:46:05 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:41957
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfJTHqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 03:46:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6QccQpmMUUHBEE0hYQFR1xW2twR1GR6/1LEM404C7ZxbOYvwaL1duTWorw/oHgtS+STUVR6bfJgT1S2zAv4s+tWg1woH93/9+Eua0LyG3KAkj478vK+z40dmCALDJe/9Wj/zRJlUSlzx+1yHMFsGAXok2iWoSEftv/dBKCesWFCYxYhRRkwJNWnKGlL5CN8jcSU/bfwUOwVsXc4eNqcyJN6tV+IAEHMPdga94maGT90WSrdUeffGo3QFjG7yKp/TFE/hIpumq3bGvBdc1ruhESUZQxaP2XKri9Ok9Da79cOZbFtw62VexwVF0/yM3+kVkVIpUAD+5CLkguSt2Diyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NOOLSs0IELxdM2xF2JeJOdy/5N6Ff3WvIf3CHzvw3E=;
 b=UEHnLtj70id19B75ft+vxGYuCynJeZ5L3yzXsVsqYQPx2SKKT3lDCZ+0DXaA0ES692mcp27tZbpFQKewcjmjq0aC8V5LFcDIJJfz5e2XFwnZadejYcko45w7HmQv2tfQZV3yweUndAKIQgLs+l2tUdeXZsinYR5Fru3L/XrNd2WFTaP8LhqIwYoWTPAbpKE956K4d6D6gwP8fG6+acnTkkOE0iCkajC0uahNNmD9D0o8Uluyi2hwJvr790B2eUqaT3PgBhlB7Jpk+mPC72RDqe+XN6Xls6NOyHFbc7sHVJ8KBWqFaoTE7SWgrb1fdxSDRVcM7Ba9iFf3d/UztPuPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NOOLSs0IELxdM2xF2JeJOdy/5N6Ff3WvIf3CHzvw3E=;
 b=TY3UFK55bgD2HpGYIVxb8xpKETUf2LMItpzafjoyI+bZJrKrJnQZEaT9FKtuzVDJypVpfcguayP3ojwXe/ROsbBiMmykDIT5c0J5j0wV+NlbNbxpfmvvMjUKAn1GO+sQWjVZmxB+Dv9ukeSpTtuzSTgaWCdsGJeb09VLp9HteTs=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.43.208) by
 DBBPR05MB6585.eurprd05.prod.outlook.com (20.179.41.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Sun, 20 Oct 2019 07:46:00 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::80c3:88d8:12c7:b861]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::80c3:88d8:12c7:b861%7]) with mapi id 15.20.2347.028; Sun, 20 Oct 2019
 07:46:00 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net 11/15] net/mlx5e: kTLS, Save a copy of the crypto info
Thread-Topic: [net 11/15] net/mlx5e: kTLS, Save a copy of the crypto info
Thread-Index: AQHVheuawLjJi7C3EEu3RHx16T16badhCDsAgAIgvQA=
Date:   Sun, 20 Oct 2019 07:46:00 +0000
Message-ID: <9f2465b6-9bec-326b-8939-ff9d2a6d5bb4@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
 <20191018193737.13959-12-saeedm@mellanox.com>
 <20191018161614.3b22ed45@cakuba.netronome.com>
In-Reply-To: <20191018161614.3b22ed45@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0701CA0040.eurprd07.prod.outlook.com
 (2603:10a6:200:42::50) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:cf::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.124.18.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0d262f2-f568-4984-b601-08d755318cc0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DBBPR05MB6585:|DBBPR05MB6585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB6585B5CD9DF5481137F9915DAE6E0@DBBPR05MB6585.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0196A226D1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39850400004)(366004)(189003)(199004)(6436002)(5660300002)(8676002)(256004)(478600001)(102836004)(36756003)(6486002)(31686004)(316002)(31696002)(229853002)(66066001)(81166006)(6512007)(81156014)(3846002)(4326008)(52116002)(2906002)(99286004)(6116002)(25786009)(110136005)(66446008)(107886003)(6246003)(54906003)(76176011)(86362001)(8936002)(71190400001)(71200400001)(14454004)(11346002)(476003)(446003)(2616005)(4744005)(386003)(6506007)(53546011)(66476007)(486006)(186003)(26005)(7736002)(6636002)(305945005)(66946007)(66556008)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6585;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6VwveVvIsv9Cxa0dRr31eDceby1OKTT0OleUmD95KGi/lD5E7LzGRPiKbqSqJzeX8ctULHiSmldbwIfJA/BooQsyPITovp2L0INLBBnOGt7zYeYoahDclcU2LcAMq1TuBecotKmnxt6IkAFJ9FwJcIKlTyh96mi//yK4zr6zFgx5y3yRG2/19F1G+AZsIp7dQqItkvj1f4RDnKoxmDKLTvsofH/naNzmC40kzsEFXTav7pPoCSpG7D4ILxQf0fgcEwodv9x9r37WefI3nGJN9jKlJlCMF/h1dIcFH3gRkgBA0J8vIISW331pn1tgkU36hAAkeM9SSbVz+aGfUyUbixwvJwOzWCAIfR114u4Qo8KycZx3P0qT5bcZhxT8BwsyQMxP4y0z09YbivSjgHVjhrQoi3hiuaFtInbPRkZA2jE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14C391A050A2724B8DF2E9AE19978320@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d262f2-f568-4984-b601-08d755318cc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2019 07:46:00.1421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3IAQoDLNsoMTNamJD3tUqv6vG//817KBefi1lmvDgLAkrTsedOhcNBdjzelTZ9kc/8Q1v7KL1s6R0ZPK3OJmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6585
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE5LzIwMTkgMjoxNiBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZy
aSwgMTggT2N0IDIwMTkgMTk6Mzg6MjIgKzAwMDAsIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPj4g
RnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPj4NCj4+IERvIG5vdCBh
c3N1bWUgdGhlIGNyeXB0byBpbmZvIGlzIGFjY2Vzc2libGUgZHVyaW5nIHRoZQ0KPj4gY29ubmVj
dGlvbiBsaWZldGltZS4gU2F2ZSBhIGNvcHkgb2YgaXQgaW4gdGhlIHByaXZhdGUNCj4+IFRYIGNv
bnRleHQuDQo+IA0KPiBJdCBzaG91bGQgYmUgYXJvdW5kIGFzIGxvbmcgYXMgdGhlIGRyaXZlciBr
bm93cyBhYm91dCB0aGUgc29ja2V0LCBubz8NCj4gDQoNClRoZSBjcnlwdG8gaW5mbyBpbnN0YW5j
ZSBwYXNzZWQgdG8gdGhlIGRyaXZlciAoYXMgcGFyYW1ldGVyIGluIA0KY29ubmVjdGlvbiBjcmVh
dGlvbiBjYWxsYmFjaykgbWlnaHQgYmUgbW9kaWZpZWQvemVyb2VkL3JldXNlZCwgc28gdGhlIA0K
ZHJpdmVyIGlzIGV4cGVjdGVkIHRvIHNhdmUgaXRzIG93biBjb3B5LCBub3QganVzdCB0aGUgcG9p
bnRlci4NCg==
