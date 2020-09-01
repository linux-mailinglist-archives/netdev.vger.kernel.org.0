Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BCD259C9F
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgIARRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:17:37 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:41382 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732599AbgIARRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 13:17:12 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e82140000>; Wed, 02 Sep 2020 01:17:08 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 10:17:08 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Tue, 01 Sep 2020 10:17:08 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 17:17:04 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 1 Sep 2020 17:17:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHnjjOKxqaoTVDcyLPcF9zEyYSXD1IU17KlVky3nIDbloYx3zjIIabg4zXalnQHZo3TF0qMAEdzqCOXDomywNn9fgGPpZ1Bdu86Z+J4eZcwKjFkpcMvWJ5ayZpOgW0HGOvtqfUYJcvNnbRIcS07Iwm3JPH+IU3XTXsz8OZ7Ip2QgFHU69MhBTRkIeEgd00gRhX0f81FICYwcW45aNIarSKYJfoA9LgrltsvSwAimN4VYUVanwIPS/oB2XrcHCTOxRg8RehgXs9lYvP3PUpawelo+bJuOktdOoQES7NYVmX+V2GnNYW5JMefQk4pW3LFLmTk2fxah70tGGXBkHUU4LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbe7Q8Fkc31BiL/ON15r8fiuvWpfjSVWK2lsN0F8QtY=;
 b=DzzrWRo+H3Py4hJz+6Mgax/bGch/Mq4sYznFbOQUspTJuFztexxJUUFTqAPNOubTIHzJwAwLCuQnAD0Ug0Q0winAxcwBWro4YMBl+fZZGuJr4Sz43uD4vHmHLttLCaycjzD0/TnGOEwt7TXkKw1JLTRaIRmay9XxyyaTuQ5c///wiiEDz3ldP0melBdfY4yEMd2cK0EbBLfO/eyMP0+EITMH9FMIk9WtuRt7ILygZoxF2jH63KRniXspmMa7msL3qoU6nvog+NFlp9Zg2JB3/2CMML5ZIb8slUkSOxM3oq89oYKo17TOWIAO7IzTQW/ihHsirFxiwLQ5wd0PI26U0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3093.namprd12.prod.outlook.com (2603:10b6:a03:dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Tue, 1 Sep
 2020 17:17:00 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e528:bb9a:b147:94a9]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e528:bb9a:b147:94a9%6]) with mapi id 15.20.3348.015; Tue, 1 Sep 2020
 17:16:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: kTLS, Avoid kzalloc(GFP_KERNEL) under
 spinlock
Thread-Topic: [PATCH net-next] net/mlx5e: kTLS, Avoid kzalloc(GFP_KERNEL)
 under spinlock
Thread-Index: AQHWgG08sOx441VITkihaRnRX50/aalUBouA
Date:   Tue, 1 Sep 2020 17:16:59 +0000
Message-ID: <d92b28edfa72687114fe85c07cb1e190697485a0.camel@nvidia.com>
References: <20200901143512.25424-1-yuehaibing@huawei.com>
In-Reply-To: <20200901143512.25424-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c86b36c0-26fb-4fdc-1bd0-08d84e9ad641
x-ms-traffictypediagnostic: BYAPR12MB3093:
x-ld-processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3093EEC4B93104070A55B402B32E0@BYAPR12MB3093.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WDDYGIJ2bPlBgaIRbTjndFU77eBbp6rDbx4xJkQG48adyr9jgs0ZY5npXCavNM5aZb6UF1lGkMNNgHvXvSODJsNQVa23JTXUJISvZCQ1wGqR+wtOndwg8bruJWtDRYTjuCn8zDUnhrX1RZxbhJHRVDaX/jXN8MuIXqz0o1xcrJ/6CCtgizGiiwYgg48yNT0SqVN1f+eYBmmGtmkPQ7PyF3ysBUf0qPg/smFNyk3RR5T5HTif+lkiJ9y8kiXYyto9JP7gR+T8vsZyQNXd7IaUSpK6yFW9uYELn6nigzs8U/n2nc6UBpnOB68ed+COeSLUATB1WVvRNwosPfKxWzP9zA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(83380400001)(4326008)(66446008)(36756003)(2616005)(66556008)(2906002)(66476007)(76116006)(316002)(6506007)(64756008)(8936002)(8676002)(66946007)(6512007)(478600001)(6486002)(86362001)(186003)(54906003)(71200400001)(5660300002)(26005)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HTTnZnefpXhjPk8Ym2c1SEpcxebVFpkQyR3pkoh7d7RSiU/b16rbqr4ykUWjAnbMIJyf2OdXNKcqrQs/btKgziuYJ/tMPuU9lK6LtWBA71u5vdk0Zae4sTPbky5CxFRQLc2Vk/L0nCmGGUbGCzR2JcclrIgTmwFtDC4fqTezRPillFQmaYm8zo3Pdl7w00CXFH3dMhDb5WHGC9xFc0Ge5B/2joLIcHDan8iBa3py3hXXKo62EUWe85GJK7znJ4eh+3bbazPiRLBd7O/3XXrg5Yb3tY4s5LuKMqUASA6SoWu3qi1jjYIfaQfnlupTt4dsSXVfQS/Fp9yskAWvIWApuH5Yf8kKp6h2vy6g1N1142MDgz8ilvPCNTXGyPP30U0THuS0WgD+ZeHWhIHfWlIGHfDUnuMPuM8VAvO8lcTyaZd4zwRaxdc4zpHB4XM6fgzfdtZH8C9ht4/6DL8HUnNQKqcYZrCE0DKR/9r7PGh0QEdfNMZBfBpqJafPOSkKfcsXqBKPTy+PdjYubzQ0TY1JYaCffChiGC2+dsXBKtmkuTslyA3Sp7m4KdFr35CC0JJ0LZ9sdcGnrHPcbdQsgFGYJt4Xv1g6hePmShvz10pJoqeAd+YRvdQDEfYr9TZeQ+OjnoQKmtHx0WLYUtCsGXVJyQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B61A95E110C7A4D8FCF450062D0D6E3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86b36c0-26fb-4fdc-1bd0-08d84e9ad641
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2020 17:16:59.8331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RiInVsOB7czlN9HTpdWCeEZH7NQsP2ps5EfOU1mLRR4jUjXLu82GzDRnhLGgAa5uDCTLO3J6o25GvVuRjFn8Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3093
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598980628; bh=gbe7Q8Fkc31BiL/ON15r8fiuvWpfjSVWK2lsN0F8QtY=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ld-processed:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=NPo9W2uZIsmwrqYKg54JsouczgdzoWZkEEOpmhwOEv3P9EcK+2PWo8QCDU2XhMVar
         i7/ium41ujoxoPqwFUo0+uDQofk4s85ki94JcIraPU205j/HjefLnpn/izs112KY6H
         /aqFAGpva0uyQ0Ocu0sB2TcK0skq+tvu+liUl0noC6F9VnREGJKPmyJ+roow0d58pE
         f8eux3TQUQCOqYCg1lHs2lQNq8utfZSAJ1K5giv7+FGeqe+SKTwLQBSEO05arjl1+j
         koLO4uaAQlIzZ9xO9XHp9T06NWmyjljoTUWwd8o4CN+NIR3ZqhzTBNFsPbJ8FsVhR3
         Z/OG9BdY/WjHw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA5LTAxIGF0IDIyOjM1ICswODAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBB
IHNwaW4gbG9jayBpcyBoZWxkIGJlZm9yZSBremFsbG9jLCBpdCBtYXkgc2xlZXAgd2l0aCBob2xk
aW5nDQo+IHRoZSBzcGlubG9jaywgc28gd2Ugc2hvdWxkIHVzZSBHRlBfQVRPTUlDIGluc3RlYWQu
DQo+IA0KPiBUaGlzIGlzIGRldGVjdGVkIGJ5IGNvY2NpbmVsbGUuDQo+IA0KPiBGaXhlczogMDQx
OWQ4YzlkOGY4ICgibmV0L21seDVlOiBrVExTLCBBZGQga1RMUyBSWCByZXN5bmMgc3VwcG9ydCIp
DQo+IFNpZ25lZC1vZmYtYnk6IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwv
a3Rsc19yeC5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0DQo+IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2t0bHNfcnguYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3J4LmMNCj4gaW5kZXggYWNmNmQ4
MGE2YmI3Li4xYTMyNDM1YWNhYzMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3J4LmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2t0bHNfcnguYw0KPiBAQCAt
MjQ3LDcgKzI0Nyw3IEBAIHJlc3luY19wb3N0X2dldF9wcm9ncmVzc19wYXJhbXMoc3RydWN0DQo+
IG1seDVlX2ljb3NxICpzcSwNCj4gIAlpbnQgZXJyOw0KPiAgCXUxNiBwaTsNCj4gIA0KPiAtCWJ1
ZiA9IGt6YWxsb2Moc2l6ZW9mKCpidWYpLCBHRlBfS0VSTkVMKTsNCj4gKwlidWYgPSBremFsbG9j
KHNpemVvZigqYnVmKSwgR0ZQX0FUT01JQyk7DQo+ICAJaWYgKHVubGlrZWx5KCFidWYpKSB7DQo+
ICAJCWVyciA9IC1FTk9NRU07DQo+ICAJCWdvdG8gZXJyX291dDsNCg0KVGhhbmtzIGZvciB0aGUg
cGF0Y2gsIHRoZSBremFsbG9jIGNhbiBtb3ZlIG91dHNpZGUgdGhlIHNwaW5sb2NrLg0KVGhpcyBw
YXRjaCBzaG91bGQgYWxzbyBnbyB0byBuZXQuDQoNCkkgd2lsbCBwcm92aWRlIGEgbmV3ZXIgdmVy
c2lvbiBvZiB0aGUgcGF0Y2ggdG8gZGVhbCB3aXRoIHRoaXMgYW5kIHdpdGgNCmEgbWlzc2luZyBr
ZnJlZSBvbiBlcnJvciBoYW5kbGluZyBpIGZvdW5kIHdoaWxlIGxvb2tpbmcgYXQgdGhlIGNvZGUu
DQoNClRoYW5rcywgDQpTYWVlZC4NCg==
