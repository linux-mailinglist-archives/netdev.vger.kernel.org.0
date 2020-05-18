Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87701D7E60
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgERQZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:25:52 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:6083
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728209AbgERQZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:25:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdpO86mMYWbT/mX8zz0i7kE3g9bTjLRbwHXMJI2lxhu5CJAff4n/YkGDmNdvWkkp/KfWDQG6fuGDZxTLuNlCT+vN6EftEpH/cKyRrzS08SBqz3BmHlUWd4EKqv67FaNT7S68nUOjqF3A/olvOSd7AfAxPXZbYXSOGG9d6pJVaO8EHzYL4vM61F4W8oyNpZm70tma9GNrW3THJTkccXS1DDOGC04LKK/oyWMN81UIHrj8tJBVQMjSlAkNSvrJ2r+FdfU8YyLE0x9j28ZUFmEiq/A8xd/qEzn+xSAg/43F2KRxN5w1vgBoF0mtQ2tTIY0/jzTvHDYHVjo2LKX/pQVXAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb8drt9yrcm6vN++z8r7eKlWcxSzx8T4T+thIJJMH9E=;
 b=DeMP5EBVvNS8SVivxvjbqEbG6rM5/llaxqXyxfWcU/T2JIjMO7cEuYAcjpQ9zdlRlCgbnHcYUuDHyZj4jb+uHYRn9THtq2HjquODGT+L+mntNZGvwfntObkzF0jNb/2NgfvqWF8IxkhCz8tbNFFZupr8t376TJZt+/kbFRPMNCzMuJVOFIvSpU5w2nhX/MhF6gwgR/ujJ3l9/f3DE8NUF0fXQUXqBr1uk7ZLMUM9TxYn046oiVfD/JDEqzLxG94Zeazj5xwygLkEC2T8GHcNYZXIWmTgU9vdaqA7PCUWxeRiv8f6AM1Ql6mHhm0VyOUQfhvVv0/A3QI+SzM8rEFURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb8drt9yrcm6vN++z8r7eKlWcxSzx8T4T+thIJJMH9E=;
 b=U4v+NFubzZQNUCH8zeGd4JX8cwhtQu0jxRBI/evudhx1vw/w0413NmlLBmeqh3rdOpHBvqMvz/Fk4evNJFefdL2q7HUrcGTBRQE+Gz6oLScYApk3MIn0PxibORl/LqI7SSXNBhl5QUgZoldlwZFW5DNDCMHI92CRTo5YLVqai+I=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4608.eurprd05.prod.outlook.com (2603:10a6:802:5f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.31; Mon, 18 May
 2020 16:25:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 16:25:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tangbin@cmss.chinamobile.com" <tangbin@cmss.chinamobile.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "zhangshengju@cmss.chinamobile.com" 
        <zhangshengju@cmss.chinamobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use IS_ERR() to check and simplify code
Thread-Topic: [PATCH v2] net/mlx5e: Use IS_ERR() to check and simplify code
Thread-Index: AQHWKw1vt3qLm47COkubT/zbZ86R9aiuC9uA
Date:   Mon, 18 May 2020 16:25:47 +0000
Message-ID: <bffa9aeea3d70ba6ecc93bdddad952970d88e5af.camel@mellanox.com>
References: <20200515230633.2832-1-tangbin@cmss.chinamobile.com>
In-Reply-To: <20200515230633.2832-1-tangbin@cmss.chinamobile.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: cmss.chinamobile.com; dkim=none (message not signed)
 header.d=none;cmss.chinamobile.com; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 784753d1-7a90-4617-292e-08d7fb481f5a
x-ms-traffictypediagnostic: VI1PR05MB4608:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4608B60D9A4F77C0BEA29B14BEB80@VI1PR05MB4608.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:459;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 66BB0VQtuJUUdd8/ZqKjLeuclg0btyeOyBb8HIVUvPeeiYtGWAgK5VA8AP2zdwVK+p9pezvUEQvK3d2QuosYu00AzsK/MuyGG1sLb1fvAFAFURLyB7OSrnEtLvuyADF9V0bnnr/1JGellCAlcE3E6gWEnBbXZwnQnrQQ+d6N2EoVEyTjUsfW/19aVoPzdNqurw+44ijYasZIK5eQTI8BmpTFyB3wZQzKZg3zwYuVwLBTl4vUVrYXNHE442cK9+hJNp6Rp0qT2K7gEB8fQFeFt2xLFPKbcuz7tfVfIzsKy80xPYF8chyGYMBVBU8yrNROEn8rBHqS4HzQZJmvQk2Hknum8mny4hVqzXUdYs5Zj7J8JBgqrqvIVq0aBN8B3eYdqO2OyzSG0V/lcYrrQ6LtRNK/ZAEncm1czQjx7flHxcdwLlkbyizj/xuFc0dsAEN8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(4744005)(8936002)(2906002)(8676002)(36756003)(4326008)(76116006)(6512007)(91956017)(66946007)(66446008)(66556008)(66476007)(64756008)(478600001)(71200400001)(6486002)(2616005)(5660300002)(6506007)(26005)(86362001)(186003)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NFLY/SebuCwsjqTKbCkC46PYwe6DvlG0GIq5J4OrCtqX96aC4FZO52VzmlWKpG4V4bpM1k7IO8q2fl1faQdkwPydhpiRVwmy3Rw366z4hh0wcBS5aZqkd1Dci1Hhr6sMv4szJ+ESDXd2XamxwisemgojCYbknMS9eSYUiOIZI7LbupvEPZuL88FWzRz/dkvbu/cCNAzNqST6JIMGFsjqCMB9aUKVq9feKutOxSZFU8q6hWKXd72recf+06XW7h4qG/e5zVLlxtYJnd7+52VhV6aBY9+erwArf5nWIok23lnEoF+vZZN6qRW0+BqYvzYt4mv42hon2SYJxIJdu5YE/S7awfbsceZuxOELjnkINSfWCDlBXTRULEEnvGJGaGlUwm3rZMC6aKRiD3KMRMGPzLFOvyzW6Ov9Y1EKwQ2IX4eAFvaY/1fnNzX+i2ntc8cgX20bea7iPQ60k32TD47C1Ik3RX630coaP7Q80vT2D1s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EFF41507CA78E48AF51E9CEE67C324B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784753d1-7a90-4617-292e-08d7fb481f5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 16:25:47.7264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D8sKvYVSNhEtvKelaZ1s/W3Xbm6JBvCGx+kWJZt3jAmSEAr1HpgkIcAdoV9MUUqjMsG0K9wsSisv+LOahdVg5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTA1LTE2IGF0IDA3OjA2ICswODAwLCBUYW5nIEJpbiB3cm90ZToNCj4gVXNl
IElTX0VSUigpIGFuZCBQVFJfRVJSKCkgaW5zdGVhZCBvZiBQVFJfRVJSX09SX1pFUk8oKSB0bw0K
PiBzaW1wbGlmeSBjb2RlLCBhdm9pZCByZWR1bmRhbnQganVkZ2VtZW50cy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFpoYW5nIFNoZW5nanUgPHpoYW5nc2hlbmdqdUBjbXNzLmNoaW5hbW9iaWxlLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogVGFuZyBCaW4gPHRhbmdiaW5AY21zcy5jaGluYW1vYmlsZS5j
b20+DQo+IFJldmlld2VkLWJ5OiBMZW9uIFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+
DQo+IC0tLQ0KPiBDaGFuZ2VzIGZyb20gdjENCj4gIC0gZml4IHRoZSBjb21taXQgbWVzc2FnZSBm
b3IgdHlwby4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4vdGNfdHVuLmMgfCA1ICsrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCg0KQXBwbGllZCB0byBuZXQtbmV4dC1tbHg1IA0KDQpU
aGFua3MsDQpTYWVlZC4NCg0K
