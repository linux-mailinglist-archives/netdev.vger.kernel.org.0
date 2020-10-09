Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85467289B48
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388614AbgJIV4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:56:46 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14009 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732810AbgJIV4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:56:46 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80dc650000>; Fri, 09 Oct 2020 14:55:49 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:56:45 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:56:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qxdj5mAkqqUxsqfWlkxdbxWBvZY0a6FOTYI/LkntuCIenwvzZNXsG88nGPgLguyvR1B7pGImZZFD/CA0ed4zUsxbsLZXm8qP7JF3HudKrI+JN3eMis1Lm5InIGFFnrkjQ3RXgDZyyB/XlYPRx+Q560hFHkIomMneZuANy6b1LVxEq1z9pZ4lj1GzfP+6ULIfcUYKySBQ1OW2pPJWI6iCcCDh5Mtjq5YBjjxNIQtAwA5y0VLTjPg1Drt0m93gfU6p6T3il713IqDUOuS0bhLjUmxbtxpoBfyv7RBDkuMWzForFDy7uo2po63huqjnYH5QXbgvkRgiUjDzCbcwyEcyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lGOiTKXtUscYgKun9GxRxvbvu/c9fD49syGqUvirPaY=;
 b=Cvh9XJV91iACfVZayN26IL3q1z3HC9CXRA3ylOx1stNwXo9Ms3c/nUobF1owiVO8M6CwSBef/Yhk9a/7ljmWUBoheY5waewKfr7sOntAWGUCBkqTY44HmXh4vP/bGQxVfY2d3IOdtY3Lq1oif81NjX9OygvaQ5ylMn8ZeKRi+kS2yjm+PEASK5HzBOrrLwweqmCdUz7GhpWhfbMPN4T+9H8uCGYer3JYA9PfkP/UbQNI/g9WWGyooHT2+pr2UYRP131VFbrIlIpf2Mugcu2/mmMS6LNDQ+9/AF1MWoEhKSJTaHkpR/G6KLiQqtpwZzsi/rTBIvKMxFQwlGXbNEdxzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3563.namprd12.prod.outlook.com (2603:10b6:5:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 9 Oct
 2020 21:56:44 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:56:43 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 08/10] bridge: cfm: Netlink GET configuration
 Interface.
Thread-Topic: [PATCH net-next v4 08/10] bridge: cfm: Netlink GET configuration
 Interface.
Thread-Index: AQHWnknaYdz63RTY906h+kGARB2DRamP0ZEA
Date:   Fri, 9 Oct 2020 21:56:43 +0000
Message-ID: <1180153d9d7dc5d5c6af9c2eb32f4052c47e14f3.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-9-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-9-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 126af617-418c-4a35-528b-08d86c9e3603
x-ms-traffictypediagnostic: DM6PR12MB3563:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB35634847B286604D76F8D3C6DF080@DM6PR12MB3563.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9JvYYdGSaloCBTYgaJzBXqVJBVcQktDcP/7dVkoiJKzf+bmq/zjW8/8f5iO8T7CDm/fRR7JJvUEcLZyrgHth97PXt3t8pjE7MlOIlSgReCbVb8CS2XMiZdLBSbHqxO0TZbr7kmEMtsG7TmQezzEeLKIjTd8Je0+dLLkjJFn8TCVUGhyM5X5stYotwpjVOi5g3OHxI9tQ0jHKFh5RhwPjUg1PQEjfTROhF9gqvodfiPVjBSnARt+qx50war4jZM6HQO95IfKmOeuPs9sgEQn5/e4ntAhom0mWzO6KJQN7hW5FxhEcz/JtB1JogrncIf+Y8uYxp2jPvBAoxAMwEAMgI4pmvjPLKnuY4W5bjho9Xi8yWGkCcueuQdIaBuwSdSF8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(186003)(26005)(6506007)(478600001)(316002)(5660300002)(71200400001)(2616005)(91956017)(64756008)(66946007)(66446008)(66476007)(76116006)(66556008)(86362001)(3450700001)(8676002)(4326008)(110136005)(2906002)(6486002)(8936002)(36756003)(6512007)(83380400001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vMg+Pp/VTNWH/DKb6MOP1RpmdeWe+mBQcB3PhFftfwFxJZoqwUSrywB646EPLunFSN5HcasbGz5nNqjWcoF+Stu6DjoX5G17TYDbutAF0A0dOromPReYW5afX+ovx+I6C9tmaJUgE5Ntk9QWjlP0xLmi7fgb0Sm6w1bSNjB1VoduxZaR2PkydKDS0YmcoRh+CeCYXpxOEmnhSJmL6gCdoqYoW+H2FavIdeWRwZdttMN9F69ra+7h6g2sVqYhylXHmyxI/oTcqo9ykbY6poeuOzz92HT76TlXXz78Q2mt8t5iPncN8iydtKinHgxXaoU9/U1FiyN5S0EVg4CWtY8L7VeWzsuQSCD2GoiDEk7SeTbf3eHvZkYrgXmj+Ww5XcQM0Cz//MWWxfvcrc2xVt/YboasjQSI4X6c+/k5vbCk70VYyPbZZCxgo/J5UBJ48bRj8rNWvnu3uUzdDvpHET3iVklS/HrYZG9xTi6Eqh2m4oqTdUBtS2S1igNoE0eOcPK0JZyfW9Kv7VTks07bNmKrZDOKpNjqYuOFOXHQUU7RYnR4GzCaWvS0Pi3/AyeieFjj8stRD+OlWXV0xaPyaVGL8tTpjcBGSva7hhc8S3+cgNXsXE1/R8lV7UshUtqXmgezvYyvtnpcr6D1DwfB4gsYog==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F9DFD0D7152AE4D8AA7E70FBE5FA3A8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126af617-418c-4a35-528b-08d86c9e3603
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:56:43.7896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VYj4yCEA+WrJFsZj9yrihjh24AxY2iqyOro+kO9NAKD8jLDUC+n7n2MYuiRfOs5IUHmQCSvAT2C9sjlmN1a44w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3563
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280549; bh=lGOiTKXtUscYgKun9GxRxvbvu/c9fD49syGqUvirPaY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
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
        b=H36wLbPJ7i2LQnw6cPqYZyv3EBtL9zSEJ43hW8GzLbBTwsXo0iYnLnHilmMwLN1TW
         s6WPXmx8QdUBbe+HaUXIKMTxvsS7G1pmjcB8o+bo9tbJZY4q5SOsHTEf5tZhVos+cr
         CC1zV2b9TsEYyHJh3orG6WVBVtuSKMdr4ThULcYFN3syYkDBcDYeMxqKjme8XE4ANt
         bUM81PxhjhmS/L4p3GPWzZscmQHi9u+Pztb0jLIV1XprhwrP+L53cjmBwI67/wA2xU
         kPiA7UZZ3RbJtpRWurxiWKXYIvDbQqfQUhJqWtmR88j5mLnGpZFup+A8cjY5Dh5MkU
         g4yTsV2U9EJCQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgQ0ZNIG5ldGxpbmsgY29uZmlndXJh
dGlvbg0KPiBnZXQgaW5mb3JtYXRpb24gaW50ZXJmYWNlLg0KPiANCj4gQWRkIG5ldyBuZXN0ZWQg
bmV0bGluayBhdHRyaWJ1dGVzLiBUaGVzZSBhdHRyaWJ1dGVzIGFyZSB1c2VkIGJ5IHRoZQ0KPiB1
c2VyIHNwYWNlIHRvIGdldCBjb25maWd1cmF0aW9uIGluZm9ybWF0aW9uLg0KPiANCj4gR0VUTElO
SzoNCj4gICAgIFJlcXVlc3QgZmlsdGVyIFJURVhUX0ZJTFRFUl9DRk1fQ09ORklHOg0KPiAgICAg
SW5kaWNhdGluZyB0aGF0IENGTSBjb25maWd1cmF0aW9uIGluZm9ybWF0aW9uIG11c3QgYmUgZGVs
aXZlcmVkLg0KPiANCj4gICAgIElGTEFfQlJJREdFX0NGTToNCj4gICAgICAgICBQb2ludHMgdG8g
dGhlIENGTSBpbmZvcm1hdGlvbi4NCj4gDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NSRUFU
RV9JTkZPOg0KPiAgICAgICAgIFRoaXMgaW5kaWNhdGUgdGhhdCBNRVAgaW5zdGFuY2UgY3JlYXRl
IHBhcmFtZXRlcnMgYXJlIGZvbGxvd2luZy4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfQ09O
RklHX0lORk86DQo+ICAgICAgICAgVGhpcyBpbmRpY2F0ZSB0aGF0IE1FUCBpbnN0YW5jZSBjb25m
aWcgcGFyYW1ldGVycyBhcmUgZm9sbG93aW5nLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NP
TkZJR19JTkZPOg0KPiAgICAgICAgIFRoaXMgaW5kaWNhdGUgdGhhdCBNRVAgaW5zdGFuY2UgQ0Mg
ZnVuY3Rpb25hbGl0eQ0KPiAgICAgICAgIHBhcmFtZXRlcnMgYXJlIGZvbGxvd2luZy4NCj4gICAg
IElGTEFfQlJJREdFX0NGTV9DQ19SRElfSU5GTzoNCj4gICAgICAgICBUaGlzIGluZGljYXRlIHRo
YXQgQ0MgdHJhbnNtaXR0ZWQgQ0NNIFBEVSBSREkNCj4gICAgICAgICBwYXJhbWV0ZXJzIGFyZSBm
b2xsb3dpbmcuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYX0lORk86DQo+ICAgICAg
ICAgVGhpcyBpbmRpY2F0ZSB0aGF0IENDIHRyYW5zbWl0dGVkIENDTSBQRFUgcGFyYW1ldGVycyBh
cmUNCj4gICAgICAgICBmb2xsb3dpbmcuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9N
RVBfSU5GTzoNCj4gICAgICAgICBUaGlzIGluZGljYXRlIHRoYXQgdGhlIGFkZGVkIHBlZXIgTUVQ
IElEcyBhcmUgZm9sbG93aW5nLg0KPiANCj4gQ0ZNIG5lc3RlZCBhdHRyaWJ1dGUgaGFzIHRoZSBm
b2xsb3dpbmcgYXR0cmlidXRlcyBpbiBuZXh0IGxldmVsLg0KPiANCj4gR0VUTElOSyBSVEVYVF9G
SUxURVJfQ0ZNX0NPTkZJRzoNCj4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfQ1JFQVRFX0lOU1RB
TkNFOg0KPiAgICAgICAgIFRoZSBjcmVhdGVkIE1FUCBpbnN0YW5jZSBudW1iZXIuDQo+ICAgICAg
ICAgVGhlIHR5cGUgaXMgdTMyLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX01FUF9DUkVBVEVfRE9N
QUlOOg0KPiAgICAgICAgIFRoZSBjcmVhdGVkIE1FUCBkb21haW4uDQo+ICAgICAgICAgVGhlIHR5
cGUgaXMgdTMyIChicl9jZm1fZG9tYWluKS4NCj4gICAgICAgICBJdCBtdXN0IGJlIEJSX0NGTV9Q
T1JULg0KPiAgICAgICAgIFRoaXMgbWVhbnMgdGhhdCBDRk0gZnJhbWVzIGFyZSB0cmFuc21pdHRl
ZCBhbmQgcmVjZWl2ZWQNCj4gICAgICAgICBkaXJlY3RseSBvbiB0aGUgcG9ydCAtIHVudGFnZ2Vk
LiBOb3QgaW4gYSBWTEFOLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX01FUF9DUkVBVEVfRElSRUNU
SU9OOg0KPiAgICAgICAgIFRoZSBjcmVhdGVkIE1FUCBkaXJlY3Rpb24uDQo+ICAgICAgICAgVGhl
IHR5cGUgaXMgdTMyIChicl9jZm1fbWVwX2RpcmVjdGlvbikuDQo+ICAgICAgICAgSXQgbXVzdCBi
ZSBCUl9DRk1fTUVQX0RJUkVDVElPTl9ET1dOLg0KPiAgICAgICAgIFRoaXMgbWVhbnMgdGhhdCBD
Rk0gZnJhbWVzIGFyZSB0cmFuc21pdHRlZCBhbmQgcmVjZWl2ZWQgb24NCj4gICAgICAgICB0aGUg
cG9ydC4gTm90IGluIHRoZSBicmlkZ2UuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NSRUFU
RV9JRklOREVYOg0KPiAgICAgICAgIFRoZSBjcmVhdGVkIE1FUCByZXNpZGVuY2UgcG9ydCBpZmlu
ZGV4Lg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoaWZpbmRleCkuDQo+IA0KPiAgICAgSUZM
QV9CUklER0VfQ0ZNX01FUF9ERUxFVEVfSU5TVEFOQ0U6DQo+ICAgICAgICAgVGhlIGRlbGV0ZWQg
TUVQIGluc3RhbmNlIG51bWJlci4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIuDQo+IA0KPiAg
ICAgSUZMQV9CUklER0VfQ0ZNX01FUF9DT05GSUdfSU5TVEFOQ0U6DQo+ICAgICAgICAgVGhlIGNv
bmZpZ3VyZWQgTUVQIGluc3RhbmNlIG51bWJlci4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIu
DQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NPTkZJR19VTklDQVNUX01BQzoNCj4gICAgICAg
ICBUaGUgY29uZmlndXJlZCBNRVAgdW5pY2FzdCBNQUMgYWRkcmVzcy4NCj4gICAgICAgICBUaGUg
dHlwZSBpcyA2KnU4IChhcnJheSkuDQo+ICAgICAgICAgVGhpcyBpcyB1c2VkIGFzIFNNQUMgaW4g
YWxsIHRyYW5zbWl0dGVkIENGTSBmcmFtZXMuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NP
TkZJR19NRExFVkVMOg0KPiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCB1bmljYXN0IE1EIGxl
dmVsLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gICAgICAgICBJdCBtdXN0IGJlIGlu
IHRoZSByYW5nZSAxLTcuDQo+ICAgICAgICAgTm8gQ0ZNIGZyYW1lcyBhcmUgcGFzc2luZyB0aHJv
dWdoIHRoaXMgTUVQIG9uIGxvd2VyIGxldmVscy4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBf
Q09ORklHX01FUElEOg0KPiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCBJRC4NCj4gICAgICAg
ICBUaGUgdHlwZSBpcyB1MzIuDQo+ICAgICAgICAgSXQgbXVzdCBiZSBpbiB0aGUgcmFuZ2UgMC0w
eDFGRkYuDQo+ICAgICAgICAgVGhpcyBNRVAgSUQgaXMgaW5zZXJ0ZWQgaW4gYW55IHRyYW5zbWl0
dGVkIENDTSBmcmFtZS4NCj4gDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ09ORklHX0lOU1RB
TkNFOg0KPiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCBpbnN0YW5jZSBudW1iZXIuDQo+ICAg
ICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJR19F
TkFCTEU6DQo+ICAgICAgICAgVGhlIENvbnRpbnVpdHkgQ2hlY2sgKENDKSBmdW5jdGlvbmFsaXR5
IGlzIGVuYWJsZWQgb3IgZGlzYWJsZWQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyIChib29s
KS4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DT05GSUdfRVhQX0lOVEVSVkFMOg0KPiAgICAg
ICAgIFRoZSBDQyBleHBlY3RlZCByZWNlaXZlIGludGVydmFsIG9mIENDTSBmcmFtZXMuDQo+ICAg
ICAgICAgVGhlIHR5cGUgaXMgdTMyIChicl9jZm1fY2NtX2ludGVydmFsKS4NCj4gICAgICAgICBU
aGlzIGlzIGFsc28gdGhlIHRyYW5zbWlzc2lvbiBpbnRlcnZhbCBvZiBDQ00gZnJhbWVzIHdoZW4g
ZW5hYmxlZC4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DT05GSUdfRVhQX01BSUQ6DQo+ICAg
ICAgICAgVGhlIENDIGV4cGVjdGVkIHJlY2VpdmUgTUFJRCBpbiBDQ00gZnJhbWVzLg0KPiAgICAg
ICAgIFRoZSB0eXBlIGlzIENGTV9NQUlEX0xFTkdUSCp1OC4NCj4gICAgICAgICBUaGlzIGlzIE1B
SUQgaXMgYWxzbyBpbnNlcnRlZCBpbiB0cmFuc21pdHRlZCBDQ00gZnJhbWVzLg0KPiANCj4gICAg
IElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX01FUF9JTlNUQU5DRToNCj4gICAgICAgICBUaGUgY29u
ZmlndXJlZCBNRVAgaW5zdGFuY2UgbnVtYmVyLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4N
Cj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX01FUElEOg0KPiAgICAgICAgIFRoZSBDQyBQ
ZWVyIE1FUCBJRCBhZGRlZC4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIuDQo+ICAgICAgICAg
V2hlbiBhIFBlZXIgTUVQIElEIGlzIGFkZGVkIGFuZCBDQyBpcyBlbmFibGVkIGl0IGlzIGV4cGVj
dGVkIHRvDQo+ICAgICAgICAgcmVjZWl2ZSBDQ00gZnJhbWVzIGZyb20gdGhhdCBQZWVyIE1FUC4N
Cj4gDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUkRJX0lOU1RBTkNFOg0KPiAgICAgICAgIFRo
ZSBjb25maWd1cmVkIE1FUCBpbnN0YW5jZSBudW1iZXIuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMg
dTMyLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX1JESV9SREk6DQo+ICAgICAgICAgVGhlIFJE
SSB0aGF0IGlzIGluc2VydGVkIGluIHRyYW5zbWl0dGVkIENDTSBQRFUuDQo+ICAgICAgICAgVGhl
IHR5cGUgaXMgdTMyIChib29sKS4NCj4gDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RY
X0lOU1RBTkNFOg0KPiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCBpbnN0YW5jZSBudW1iZXIu
DQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0ND
TV9UWF9ETUFDOg0KPiAgICAgICAgIFRoZSB0cmFuc21pdHRlZCBDQ00gZnJhbWUgZGVzdGluYXRp
b24gTUFDIGFkZHJlc3MuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgNip1OCAoYXJyYXkpLg0KPiAg
ICAgICAgIFRoaXMgaXMgdXNlZCBhcyBETUFDIGluIGFsbCB0cmFuc21pdHRlZCBDRk0gZnJhbWVz
Lg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NDTV9UWF9TRVFfTk9fVVBEQVRFOg0KPiAgICAg
ICAgIFRoZSB0cmFuc21pdHRlZCBDQ00gZnJhbWUgdXBkYXRlIChpbmNyZW1lbnQpIG9mIHNlcXVl
bmNlDQo+ICAgICAgICAgbnVtYmVyIGlzIGVuYWJsZWQgb3IgZGlzYWJsZWQuDQo+ICAgICAgICAg
VGhlIHR5cGUgaXMgdTMyIChib29sKS4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhf
UEVSSU9EOg0KPiAgICAgICAgIFRoZSBwZXJpb2Qgb2YgdGltZSB3aGVyZSBDQ00gZnJhbWUgYXJl
IHRyYW5zbWl0dGVkLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gICAgICAgICBUaGUg
dGltZSBpcyBnaXZlbiBpbiBzZWNvbmRzLiBTRVRMSU5LIElGTEFfQlJJREdFX0NGTV9DQ19DQ01f
VFgNCj4gICAgICAgICBtdXN0IGJlIGRvbmUgYmVmb3JlIHRpbWVvdXQgdG8ga2VlcCB0cmFuc21p
c3Npb24gYWxpdmUuDQo+ICAgICAgICAgV2hlbiBwZXJpb2QgaXMgemVybyBhbnkgb25nb2luZyBD
Q00gZnJhbWUgdHJhbnNtaXNzaW9uDQo+ICAgICAgICAgd2lsbCBiZSBzdG9wcGVkLg0KPiAgICAg
SUZMQV9CUklER0VfQ0ZNX0NDX0NDTV9UWF9JRl9UTFY6DQo+ICAgICAgICAgVGhlIHRyYW5zbWl0
dGVkIENDTSBmcmFtZSB1cGRhdGUgd2l0aCBJbnRlcmZhY2UgU3RhdHVzIFRMVg0KPiAgICAgICAg
IGlzIGVuYWJsZWQgb3IgZGlzYWJsZWQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyIChib29s
KS4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhfSUZfVExWX1ZBTFVFOg0KPiAgICAg
ICAgIFRoZSB0cmFuc21pdHRlZCBJbnRlcmZhY2UgU3RhdHVzIFRMViB2YWx1ZSBmaWVsZC4NCj4g
ICAgICAgICBUaGUgdHlwZSBpcyB1OC4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhf
UE9SVF9UTFY6DQo+ICAgICAgICAgVGhlIHRyYW5zbWl0dGVkIENDTSBmcmFtZSB1cGRhdGUgd2l0
aCBQb3J0IFN0YXR1cyBUTFYgaXMgZW5hYmxlZA0KPiAgICAgICAgIG9yIGRpc2FibGVkLg0KPiAg
ICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0Nf
Q0NNX1RYX1BPUlRfVExWX1ZBTFVFOg0KPiAgICAgICAgIFRoZSB0cmFuc21pdHRlZCBQb3J0IFN0
YXR1cyBUTFYgdmFsdWUgZmllbGQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTguDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIZW5yaWsgQmpvZXJubHVuZCAgPGhlbnJpay5iam9lcm5sdW5kQG1pY3Jv
Y2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBIb3JhdGl1IFZ1bHR1ciAgPGhvcmF0aXUudnVsdHVy
QG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS91YXBpL2xpbnV4L2lmX2JyaWRnZS5o
IHwgICA2ICsrDQo+ICBuZXQvYnJpZGdlL2JyX2NmbV9uZXRsaW5rLmMgICAgfCAxNjEgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBuZXQvYnJpZGdlL2JyX25ldGxpbmsuYyAg
ICAgICAgfCAgMjkgKysrKystDQo+ICBuZXQvYnJpZGdlL2JyX3ByaXZhdGUuaCAgICAgICAgfCAg
IDYgKysNCj4gIDQgZmlsZXMgY2hhbmdlZCwgMjAwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+IA0KDQpBY2tlZC1ieTogTmlrb2xheSBBbGVrc2FuZHJvdiA8bmlrb2xheUBudmlkaWEu
Y29tPg0KDQo=
