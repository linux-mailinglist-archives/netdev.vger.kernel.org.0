Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC9B2319D0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgG2GzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:55:05 -0400
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:28640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726290AbgG2GzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 02:55:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XK0EPpZPJghB3kwec6sVwGGzdgPlj7L6J9gXFj7gy0O1XS0XROQB6MovCISxDWaRk0W+EF8QvCJdo2xifmkAMsAQzoKygVIFMokPBYnYUEClbALTTMfSBR332GTcx2aB12+0wKBNjaqKegNmzlbkr2/i28/emNMU59HwP14Br2OUdxJT0y3AX3npnE+wOKYk+/8YWylADmupc957IpGqLWsUw54bhCBAD/mqFagzczHbVn3HLavHWeTvRPezdbQNjJc5xZdu19MO6WrT7QKct5q31AKHWp5L/fwy7x2XSEhaPDYcD/Wldwxihien4q9mclsWFQyAfjfjSzPQgxcZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZK2fwJ/wWE5romLuZW48AT8J8RLkyQ7WQVWEKHjlZ3k=;
 b=GQOACFEr4cWZjRYzIZzLVXzJZwNL/6Vq1EOBmxx26hdh5p9hPR0ZGpp+Gx3V0f6IpO3onsOGwp9i63s5hmi/YL645Mw8/AZLobjzMXWzVT1wmfhKPo5KfaHQXCNVLZpi41c/0KFhEZfLF7WCnAfG8xjE789unvNdPPSd22KkolHWvc50r0QfKutMWLrjqy5PNGeFRRzfXWfZc5iUq3NjUfU6Gio2HLcZjoiJihLpDpTBOShop9fkn2t4VnE3jiiJCesljzetSwcu7k5as5lus80ZsROztUP7aF1Aqfn2SxhczgrmPtAdd9g3BiCmhiqotG6TPTUe/uVzm8sSN+5noA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZK2fwJ/wWE5romLuZW48AT8J8RLkyQ7WQVWEKHjlZ3k=;
 b=h74sSNe+OzGPyJlCkdAh9NNzUBnnkA7OE25nCX5Eo+1+/TlZ8Ztki4kmgF5p+MFBuwuuiWz7GtI3lYRQcC6ecLXkiA6wXswYqLQSQHTGPoIJicVQvXRGSgOltrJ3VSRRDibBdY8I1OARXtDdtsBJz30TFdyApZuu1NM7tRZCAoU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5104.eurprd05.prod.outlook.com (2603:10a6:803:61::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.28; Wed, 29 Jul
 2020 06:55:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 06:55:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 2/2] mlx5: convert to new udp_tunnel
 infrastructure
Thread-Topic: [PATCH net-next v3 2/2] mlx5: convert to new udp_tunnel
 infrastructure
Thread-Index: AQHWZSjGy2ijaeeKgkKSBQOXKV/PSqkeIAkA
Date:   Wed, 29 Jul 2020 06:55:02 +0000
Message-ID: <ad8883e1ac34c71f64f64482ac5432ef276cf355.camel@mellanox.com>
References: <20200728214759.325418-1-kuba@kernel.org>
         <20200728214759.325418-3-kuba@kernel.org>
In-Reply-To: <20200728214759.325418-3-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ede5587b-e722-4983-d060-08d8338c510e
x-ms-traffictypediagnostic: VI1PR05MB5104:
x-microsoft-antispam-prvs: <VI1PR05MB5104CB70D7C50C5957781741BE700@VI1PR05MB5104.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CFBAfgPmLMYOX9iAwL9n/gNhW/G8Ph14wljgz1gQeHv5Exh+axZ3GobL64p2qgmr/59+MUWyZgQtImgD1gCI6LUtLII7sy6WdjV0QiT/jIO0nO5srlI2f20vqcDnYlfBmlYQIT6SLhlH+hutCd6Y/uP52EGzBIjpz37eZLShEP8p9u6gKxxs/uRNn0N0N7am4K2oZmNxTD8hr3cxYx21sQ+czh70GApDtmDsdGlL/h1wcpJfew7OWI2VUFxiYwJck7GibeIl5o1jiOZxjJQBrhOio+Cm3P8e3xp2jR3BfhLm03x1wZkBnXa8UbmlB89YctJKacibkbKXBmUBBxDaGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(346002)(396003)(376002)(136003)(366004)(36756003)(26005)(6486002)(83380400001)(186003)(6506007)(71200400001)(66946007)(86362001)(478600001)(8936002)(8676002)(4326008)(76116006)(66446008)(91956017)(6916009)(2616005)(6512007)(54906003)(66556008)(316002)(64756008)(66476007)(5660300002)(2906002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ZoGx1C0AkkrStLrN5jGQpu8MO2s53PAkQf42PRzm3YAbnv76Bhs2WLj07mVliby8sZUfHRKlX8kMbz/EjT1crjUtQgbAJ55X4ZTPAEcUySeDnta/eXlw+nC6ymD9Xuj0LGsuwLNG/rkBfdY24M6AbTi3CPxmHWqnQraywHdj7ToJjzL40rWHjQh3iB2CX5Zrc9K2qRiy8DpVaaiBFcAm50tT4HL6U+TFs4hAKAWtdByO+cChNJyfkfZMd+/KLdWJXGUpzgu5RwJ76Zk2rcASKt6ru/O2CIJDALtrbNlsnRB9v3Hd5DV8VWZIDv8OURPGFdGpS7cg/7qer9D/COlcb/9at7VmOdCMTbZ/6kdVXobIncZJo64bhbCG3qwmKwoq043duv2jhwEDmABd72WMUfb2+WYG7h3ENaT+lS5bSjOAB26y0ERnVDjBOP4G6oGUPMBB9dR85tSlYwjluUvLUtaMayZlnzis8L1m6k32KgU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <509482EEF8F7DC469803BA238F51CD1F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede5587b-e722-4983-d060-08d8338c510e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 06:55:02.0400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tie+Xm6Og3aAlu2ZGTh+dmHSovJk4MlDSxEaOyqZCnz15swPpqXnp6/JTGREILmRtwXw/FLMVWKSkTb5Q+/rJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDE0OjQ3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gQWxsb2NhdGUgbmljX2luZm8gZHluYW1pY2FsbHkgLSBuX2VudHJpZXMgaXMgbm90IGNvbnN0
YW50Lg0KPiANCj4gQXR0YWNoIHRoZSB0dW5uZWwgb2ZmbG9hZCBpbmZvIG9ubHkgdG8gdGhlIHVw
bGluayByZXByZXNlbnRvci4NCj4gV2UgZXhwZWN0IHRoZSAibWFpbiIgbmV0ZGV2IHRvIGJlIHVu
cmVnaXN0ZXJlZCBpbiBzd2l0Y2hkZXYNCj4gbW9kZSwgYW5kIHRoZXJlIHRvIGJlIG9ubHkgb25l
IHVwbGluayByZXByZXNlbnRvci4NCj4gDQo+IERyb3AgdGhlIHVkcF90dW5uZWxfZHJvcF9yeF9p
bmZvKCkgY2FsbCwgaXQgd2FzIG5vdCB0aGVyZSB1bnRpbA0KPiBjb21taXQgYjNjMmVkMjFjMGJk
ICgibmV0L21seDVlOiBGaXggVlhMQU4gY29uZmlndXJhdGlvbiByZXN0b3JlDQo+IGFmdGVyIGZ1
bmN0aW9uIHJlbG9hZCIpDQo+IHNvIHRoZSBkZXZpY2UgZG9lc24ndCBuZWVkIGl0LCBhbmQgY29y
ZSBzaG91bGQgaGFuZGxlIHJlbG9hZHMgYW5kDQo+IHJlc2V0IGp1c3QgZmluZS4NCj4gDQoNCk9v
dWYgOiksIEkgcG9zdGVkIGNvbW1lbnRzIG9uIHYyLCBwbGVhc2UgaGF2ZSBhIGxvb2suDQoNCg0K
