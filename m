Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B5194DA8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgC0ABS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:01:18 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:61797
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgC0ABS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:01:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYdvp0IwkqcZurgSnkgwIRfxi+RJKvcek6sgHuvZ5oFQFA3N0mnu5JM6A/oN71l69r2FGq1VsmrIpRJbgu2Qu/mLPY8aS+GlrN5L7if4CrAzUuao0NgeIcQqm/KJAWKPIgyGOujXtERBPjAMxzjWV3LlObxndlFfslhAJ4j5od45hnfFnwEc3uyRoHywCcwCfxcHNFj2XjGhQe2is+MXfVCI61dy7fD9FVpZRBtxqCuqgFQuyTYzXwoVMz2UG2D3FusRVpjJZ9jNkXmBbm401yIi1eHmtPR8L9JvIgcddGAvP6AdrZHHN5YjicP0I7uslR8ArTvyxCUjJrqkgXrPxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoBORkoRDI9meJqazfFQuxeep/+LO0amX4/m74E9Z0k=;
 b=EtSCY1Ycwi/TbqJ7yh41FnClXsZh+HWhz8WvgqzM9odA+YvjBB4eS903mAYRp6GiMqb33eL6fqpbeJYv5EsOEEAWaeJ4keZS7HVCoEmCmnyHH/VBsB8uqoxnuC27lozGaGCnJTI0H4Dg6EjSQ83yldxBoKxYqUrDUQO0Kb9/UBCEq+7hLBXOEGg4brQYKmr+MSHMOuZYYWgULn+QK0zbB/apJBgXzXKAuvi5Osoa94xfq9fsqiCVEaTAYlXU+x3HlcYaY8PigpVRYaCfrhQNAGcWfF5rA87HEBH0FI4LrOzunCHuGltEf8Ox3jK6C4m5q/OVv3T4PQUpQDTAiyaAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoBORkoRDI9meJqazfFQuxeep/+LO0amX4/m74E9Z0k=;
 b=J+z0VJxnMhOyCEgUtv+O4K1OHUqNrDdu5qyg5LC/Uz0s2SJ2jkwwvp26bZXjqNOtBzAfQC/IHjPG1ynLEFmnFzLaMwtkHhfxYHsPsyqA9O/+IggfUibRTRqZDb8fJBpb4u7TAloBkqKl7MK7fl2QfI3m/oNjdnxrIve14skjAas=
Received: from HE1PR0501MB2201.eurprd05.prod.outlook.com (10.168.34.155) by
 HE1PR0501MB2427.eurprd05.prod.outlook.com (10.168.126.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Fri, 27 Mar 2020 00:01:13 +0000
Received: from HE1PR0501MB2201.eurprd05.prod.outlook.com
 ([fe80::e90a:ce54:6f55:b097]) by HE1PR0501MB2201.eurprd05.prod.outlook.com
 ([fe80::e90a:ce54:6f55:b097%7]) with mapi id 15.20.2835.025; Fri, 27 Mar 2020
 00:01:13 +0000
From:   Alexander Petrovskiy <alexpe@mellanox.com>
To:     Petr Machata <petrm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 0/3] Implement stats_update callback for pedit
 and skbedit
Thread-Topic: [PATCH net-next 0/3] Implement stats_update callback for pedit
 and skbedit
Thread-Index: AQHWA6+e1Dr1Kri9/Eq6JMFmuPjTb6hbwJIA
Date:   Fri, 27 Mar 2020 00:01:12 +0000
Message-ID: <82146B35-23D2-437A-8052-E0DC6488D08A@mellanox.com>
References: <cover.1585255467.git.petrm@mellanox.com>
In-Reply-To: <cover.1585255467.git.petrm@mellanox.com>
Accept-Language: ru-RU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexpe@mellanox.com; 
x-originating-ip: [46.188.94.23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ef09ea43-7c0e-4fa6-a246-08d7d1e1f6c3
x-ms-traffictypediagnostic: HE1PR0501MB2427:|HE1PR0501MB2427:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0501MB24273F511B45ED301E5C1666A0CC0@HE1PR0501MB2427.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2201.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(107886003)(86362001)(478600001)(71200400001)(36756003)(53546011)(6512007)(2906002)(2616005)(6486002)(66476007)(66556008)(76116006)(66446008)(4326008)(81156014)(110136005)(54906003)(316002)(5660300002)(64756008)(81166006)(66946007)(33656002)(8676002)(91956017)(8936002)(6506007)(26005)(186003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R0AcDV2bGfS1V/SgzJV3WToQUkPHdZuqCwAc8aKctjFzmty9Nzp1G0yNG7wWAeeVYNeAJ2a69kfFj56ONfcTddTxLTidk/1PWiP3K5nU1Pj2WsoFe25me8jchQSl9gyGaF31qQ9NMzDldtfDNU7iXYO7suvquS4utLtl3z6P/nMqepw/uVrGV5FeV1ZGihut8xW3SLrIPUc7DsbpN5TTyKn1JPn+pZxvGukMtko/2XwOymKPgIRNQRhzZfMcDCPRnZRNUYqyrV8JqL4ylGCMIqs8JUY5hAshrThzFSfYNjgLWCEx3wUtibJAbEcnfRFtEBktGN6oXr3LRGPjQF0cKmWHkNdK0o3q1Vf2ijSscbQo+bUZ4SEHjjHljUrqljuWDA0p9J9vdPQhUD/UVl8T1s+fE8PiJUfjYbjzp4auaqBnIboSa5LBqtx9+fqbsAhn
x-ms-exchange-antispam-messagedata: vgQkaqCLCeAsGx8U8C3L71Y0UWtMligeCDLVhcZfnyptai9+4gUkcGRgeu/G/SdAqzIfa+GLdFJ4ncNxvxRWN2cFH/lSjJyWApFqwcqVGiM23e+6wVJQf87MpQD8cl3umm+GUZTh59mAkpGfNaNrCg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <68F1BBF1B73B8645BECD9EDD59989131@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef09ea43-7c0e-4fa6-a246-08d7d1e1f6c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 00:01:12.9449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ihlA/CcUWgQfeJwD0QixzaAh7J5WnH+Eso8GBOhg+QGqINAwLC2VhAzF04zWNsFTkmVDdwnH3eRkELDB2frbrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYuMDMuMjAyMCwgMjM6NDYsICJQZXRyIE1hY2hhdGEiIDxwZXRybUBtZWxsYW5veC5jb20+
IHdyb3RlOg0KDQo+VGhlIHN0YXRzX3VwZGF0ZSBjYWxsYmFjayBpcyB1c2VkIGZvciBhZGRpbmcg
SFcgY291bnRlcnMgdG8gdGhlIFNXIG9uZXMuDQo+Qm90aCBza2JlZGl0IGFuZCBwZWRpdCBhY3Rp
b25zIGFyZSBhY3R1YWxseSByZWNvZ25pemVkIGJ5IGZsb3dfb2ZmbG9hZC5oLA0KPmJ1dCBkbyBu
b3QgaW1wbGVtZW50IHRoZXNlIGNhbGxiYWNrcy4gQXMgYSBjb25zZXF1ZW5jZSwgdGhlIHJlcG9y
dGVkIHZhbHVlcw0KPmFyZSBvbmx5IHRoZSBTVyBvbmVzLCBldmVuIHdoZXJlIHRoZXJlIGlzIGEg
SFcgY291bnRlciBhdmFpbGFibGUuDQo+DQo+UGF0Y2ggIzEgYWRkcyB0aGUgY2FsbGJhY2sgdG8g
YWN0aW9uIHNrYmVkaXQsIHBhdGNoICMyIGFkZHMgaXQgdG8gYWN0aW9uDQo+cGVkaXQuIFBhdGNo
ICMzIHR3ZWFrcyBhbiBza2JlZGl0IHNlbGZ0ZXN0IHdpdGggYSBjaGVjayB0aGF0IHdvdWxkIGhh
dmUNCj5jYXVnaHQgdGhpcyBwcm9ibGVtLg0KPg0KPlRoZSBwZWRpdCB0ZXN0IGlzIG5vdCBsaWtl
d2lzZSB0d2Vha2VkLCBiZWNhdXNlIHRoZSBpcHJvdXRlMiBwZWRpdCBhY3Rpb24NCj5jdXJyZW50
bHkgZG9lcyBub3Qgc3VwcG9ydCBKU09OIGR1bXBpbmcuIFRoaXMgd2lsbCBiZSBhZGRyZXNzZWQg
bGF0ZXIuDQo+DQo+UGV0ciBNYWNoYXRhICgzKToNCj4gIHNjaGVkOiBhY3Rfc2tiZWRpdDogSW1w
bGVtZW50IHN0YXRzX3VwZGF0ZSBjYWxsYmFjaw0KPiAgc2NoZWQ6IGFjdF9wZWRpdDogSW1wbGVt
ZW50IHN0YXRzX3VwZGF0ZSBjYWxsYmFjaw0KPiAgc2VsZnRlc3RzOiBza2JlZGl0X3ByaW9yaXR5
OiBUZXN0IGNvdW50ZXJzIGF0IHRoZSBza2JlZGl0IHJ1bGUNCj4NCj4gbmV0L3NjaGVkL2FjdF9w
ZWRpdC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMSArKysrKysrKysrKw0K
PiBuZXQvc2NoZWQvYWN0X3NrYmVkaXQuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDExICsrKysrKysrKysrDQo+IC4uLi9zZWxmdGVzdHMvbmV0L2ZvcndhcmRpbmcvc2tiZWRpdF9w
cmlvcml0eS5zaCAgICAgIHwgIDkgKysrKysrKy0tDQo+IDMgZmlsZXMgY2hhbmdlZCwgMjkgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4NCj4tLSANCj4yLjIwLjENCg0KVGVzdGVkLWJ5
OiBBbGV4YW5kZXIgUGV0cm92c2tpeSA8YWxleHBlQG1lbGxhbm94LmNvbT4NCg0K
