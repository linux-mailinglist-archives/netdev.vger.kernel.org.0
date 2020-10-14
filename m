Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AAE28DF6C
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgJNKyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:54:25 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:38182 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgJNKyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 06:54:25 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f86d8df0000>; Wed, 14 Oct 2020 18:54:23 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 14 Oct
 2020 10:54:22 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 14 Oct 2020 10:54:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAv/W9Jyc+zTnE7YIBTusrClcrGHi/88VJNGGmsOHc2EMMg/dMhUFHKGSFXec9SZiOojE6bnM1h33M+bX5EG8ras8HAXuJX6Z+8vCLKYTt52KJpp+lxZKvgLP34Wi2y/qy28N7uf6xD+bwgaeUcXRT7sC+D3M9ANWM6RN6Soky+qCXonGw3B8mXhlx5WNrkRqqIfHU5TkHIst5A552c873J6E+2Q/MleWP56ejpJDhb5lpXqT1KGlbpCCvg4b+G+qIvn1+c4pFf4B93XCnSEAAJW9x5kc1Pt6fPE8KSKGmvrLOqWwwUT357b6WEV1wE3FOHhmK4pX/vhpZfAf02HiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d43onQCD3pBd+ZtACIO+jdmlk8niub8Tk7sVlJXxjdA=;
 b=lWI68O/RTXzds/Tf5A5oeTHg/7G7Zlc19qE6I1DeaEPDTZVr4HD3SZKC1+fIFdRLySdS7mtyhR7N6vpjbQ4vP1Z2pJ8up5RFstlY92VUSYWW9PXLaEUgidgxkkuXuXcFgr/iDU9A8yD4kQrMLTY3PGCBkKj/A1gNMVDwhGqHoyWMAKykHFpJl601OmzLWbLh0fw9EgClGmIsp9S9M7nSPyKXxOuh/Jztlr9F2M1guQr/87I4J6aYYMKqJ/iqUttLnMTJuAnXO5akUWN4C5egi0mgieyrlW+I6BtMOD9BfskwXiLiaeeULxwAuvKo4xapztInBQJqy/gX6srBwP5i8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) by
 DM5PR1201MB2490.namprd12.prod.outlook.com (2603:10b6:3:e3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.28; Wed, 14 Oct 2020 10:54:20 +0000
Received: from DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a]) by DM5PR12MB1244.namprd12.prod.outlook.com
 ([fe80::c4a9:7b71:b9:b77a%3]) with mapi id 15.20.3477.021; Wed, 14 Oct 2020
 10:54:20 +0000
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
Subject: Re: [PATCH net-next v5 08/10] bridge: cfm: Netlink GET configuration
 Interface.
Thread-Topic: [PATCH net-next v5 08/10] bridge: cfm: Netlink GET configuration
 Interface.
Thread-Index: AQHWoKEc5k5Nxcx09U+YEvsd4f3DoqmW73gA
Date:   Wed, 14 Oct 2020 10:54:19 +0000
Message-ID: <198c9f617ad6e1960041279de883fbc231941d8d.camel@nvidia.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
         <20201012140428.2549163-9-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201012140428.2549163-9-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 1d26d9b8-ef35-44b7-921b-08d8702f80e1
x-ms-traffictypediagnostic: DM5PR1201MB2490:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB24907409416F3FDEDD0CCCBCDF050@DM5PR1201MB2490.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RDEEMx7cR7hy7vPvBXiTCxb8ejsvKtl4rO/miEAbtvXCj/K0sjjdEudO6RaSrc3BF9UUW3cQFWcEp1YU9cVmLqchqgdBNe1cd+HG2cLsCorB9FjekvQUhYhHXhYPNI0vLBf5+CPq/iYDipirdEt6gxgBLporMhKjdU5vHRHPBq66N3zAjBhGi4PdgyqZ4IUj78iFhcDSZv5T1gHrf8sWj/fXRAPuspErkLZhfclkSSrBTI0LsfKWfwFzZz7rOF3j+rdty/bixnt+1mnoK+sZuS2/FtwRxl1ItoIFvbw91b06ZvI8obYiYTs8qi++O9ix6MVCEP+FUf8nDpnv5W7y5ZIJDqxTMv9Jx+o8CbuIROqT9/2fQM2yxLc9lWuSCyOp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(5660300002)(4001150100001)(6486002)(478600001)(66446008)(4326008)(8936002)(86362001)(8676002)(316002)(64756008)(66556008)(83380400001)(66476007)(91956017)(66946007)(71200400001)(76116006)(110136005)(6512007)(2906002)(3450700001)(26005)(36756003)(6506007)(186003)(2616005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qd8Rv6c9ZSki1kQf/B8RyOJL+l2K3BRjwpz4XoJrTscxNqukrkpvJmnTad4a1kKmrbzaVTH84E9HQ5HtDz4CQ66KrgUXe4U0JHpVa/eHHqKZOcd23cVkNA+Cy+0cJybcExuhaJm9VgAhOT72HubKcjoGUbIvR4ONjbaDXSxCIV1ICn3ci4V6+Uy6G9AP/+Zqb8FSAUxZajooMDqUkbRUoY+m1KWimxWNrK4wC8/TXG7lmOR5ZyMEj+Hcq7hhZfk4lMwHFiB2SV1SCBVSbbh+jdtIuYEcE2tL/GRHtra9YOxoP/F+KblZM2oV5xezTxLOC+UNJ4lRbCh1vPC0jHxxcwO8qx8j5bglUcB6mX/4JN5CFloyJCCB31VxAXVvVU8xxak5To0Pm5NQOvdu28RMdRKbvfiFPfRsjIrOUHVms8DXJL8SvfC/C7+CHmepccQZl6+vdiNpJ5uhaxdh9ZzFk/vslt6XH6EEhNCw758intaZ9wq0t0IARMRHUO7R2IT8tplXArnIImMsJOezUACaQq3KufQEN6QEgUtgXryyHoqRHwzDlf0ksBs49gBnxpFtwkGtHNVCfEDnecWY3nUH6s2Q47Y+xKXjj7d1Z71Qma2eOXnNk5ocQU5XX2Hpg7m/QksE57sl+Px6c5QzmFfGAA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <084CE78AF794AB4898D220D3FC84A689@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d26d9b8-ef35-44b7-921b-08d8702f80e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 10:54:19.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bx4k3X1tyaBaaZ58aslm8IftNNEhnmRItr8XKNRrJAWOp+Qq9iMpF3QD6aVKaTm74TEFfFSYKBc7H+Ce0jk4Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2490
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602672863; bh=d43onQCD3pBd+ZtACIO+jdmlk8niub8Tk7sVlJXxjdA=;
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
        b=PtVb6nldFMmccxXszDBDviu2mZBJQufiILdi5iqBciS1mOg65lRG/L0zRi4H183o2
         riqsRMg1EF10pZ3t4LQfbGNZO1qvJ6QPQrAzmMTPZXd7bf3j8TRzAyj4LdnO6nA2WN
         J4Ib9651VecHBWSxauFHqLTHuyHTP7EgWlyW6NVT/j0InehMOrxcLWl5VCVCwU/4GK
         LNK1z9lM0yr5vxX/LFyIuv43TLKL6hyIOJg7y23gPbMU03UiYlOrQ3/MAG/2Nrjze3
         czBdNyu+Sg0isseJT9MSqhuGOLQDgvTC8FbF1jAyT0SvtKpNgkfeNv+krbEN0n3mIz
         ekS674eCUXfQQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTEyIGF0IDE0OjA0ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
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
Y29tPg0KDQoNCg==
