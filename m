Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431AD289B1F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391888AbgJIVmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:42:02 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12943 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgJIVmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:42:01 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80d8f00001>; Fri, 09 Oct 2020 14:41:04 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:42:01 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:42:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brWANG535mTf1FKVNSx2luEHjQigH1aftX/kh0nDvPKZQk3B6gDWM8c5PjFKvwYHEz57hJIjk+m4QSvQ0gg1rOdAGGgQOFciFGT3PdcQAnIqVXAmEex+ftiipmEzYP2flaEt0Ox2n9CykcsU9XaZpMorv//auy+hUS6y4hQR00/XGXRgLmZpoVicH+b3NjUfUs4WSVG49Iht7+ZGe150+KUMQmp9L3J2OXfOoYUrTXjYGPRqLwwCIAXYrEwWGYHG/HSm/kJxQ5QLeoG4lTDULFekCi4wJCCGgYzZqLeBYwIr56jPHbcYxDxTla1kWKgPP5/QlKudsxL505eTqeruDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNP8ren1Zf9kuDMwkYFmtO5gEhvOAG6vareHjbwrph8=;
 b=M/tWwT/63OQqwMxIeNbiu8BuiTqPoUFo6r8DUGPbJwSoLTXdVk/o04kl1q654ERx6hne3EciBsp1BiltqIyf72wjcCBgjTi93Kv5/EN4thYQQYVnq7wJkXXjJorDquNJRiQCuKZiF0FHFEvw84OUzhKfG0/K2weCik/A5kzH6ys1Sh9LveUJHkPWYu+QlE02qyU7I3u95LhRyZL2NgMMXQSRZ3yGTnyiYW3Z/ESrJW9+h5zJwCjKrxNkYn60fYDZuPgP/vH3YQDh8s1COL+vyu70XnjocDnDPlaQaqUn/2cdR47XhfRW8eEBDbXgoHb5mpkL7TIpmIXu3BMgE4vG5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3897.namprd12.prod.outlook.com (2603:10b6:5:1ca::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.26; Fri, 9 Oct
 2020 21:42:00 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:42:00 +0000
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
Subject: Re: [PATCH net-next v4 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Thread-Topic: [PATCH net-next v4 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Thread-Index: AQHWnknmRovAUutfP0eYih6ERqLFjKmPzXSA
Date:   Fri, 9 Oct 2020 21:42:00 +0000
Message-ID: <491685c20c840f3962433bed13f53aa5418696f5.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-5-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-5-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 56f9fd7e-f2b8-4401-324b-08d86c9c2749
x-ms-traffictypediagnostic: DM6PR12MB3897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3897599D4CDCACFB0011717DDF080@DM6PR12MB3897.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z/Z/Gwp3Y6rbhokGbpT4UnKfsBU2A5d+7jS4E8biWXPVea5f5h2X4diVWoJ4vRPqJYlMhzHzNnHPg1WI1pPhXH1pIDJQqsnWiYhDMU/s4jVHzGne1Se/51F7VywbRnmJj1NunxZ75a/OZzMubdF/2uXmy4XrUkSpFuMBhXAoMwfteDIKdS+J8dQxGtOs5g5BFFHOGo68NycsZ2XZ8ZP7zI+WjbAmo0FBctZvueL3hsSQ1jhx5MZljWPH+ohNvxr2apqChYHR7uC4XREx0qr1rzxFcAjivSqTy9Oere+WOw+5Dg7gqVICQX7swyaaxiEE0DfI1HxMyszPWVq1tcm7+9n6UM70g7NoE/g5VRA7qMNr3OB2AnW+XW6BUoQGTqXB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(478600001)(2906002)(66946007)(83380400001)(71200400001)(8676002)(8936002)(3450700001)(316002)(5660300002)(4326008)(2616005)(110136005)(6512007)(36756003)(6486002)(66476007)(66556008)(186003)(91956017)(76116006)(64756008)(6506007)(86362001)(66446008)(26005)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /8a0Mt7jiHkl9U4n6mmQ+0X69OOFBEnu2UQNmuNMl89rFPMsOxuWlRWytEnwJ0Gu57kQru5p/unGGp4XWwAc7uwUSwQPuW62r0nkarQpKZjJDPQmrfM1bzpdMINAl3zVpHTzTXfQLTlPHFt/zX9s9u3fxKxu50qwO/S9J0VQ2Qahcya5zz+SVrP/HrJnRcnNkFgm8K1jOscIjPEDkobFgNj4XFukpaGaVSXuKr4rU0HiWz9JlTanLNk90xiKfPd4SYfTKv1MJO1t0S18qfDIlKsYblyz/mOD/5Hes+Xmu77QAjewfu5pFDPl0EU9iOx7+j2XsguYJxrTcUmOzr7mSf1PzdjIYPMuYnfmb2oqmwEMd+1vbzGk0VmlysopDBXun8DUa7wjkEKAyjmFzQwQ/PtkS1PgXJs/5zOcmGrl/SJmFBHr0rIaHgjpPLs5rfINQkpD4YuRfrYTijrFdLNSs0vvTkjpjre+kMhJQfp4e9V6Kch1iKa4snFIB7dRWu/CBEb78Y1FwNXcB/lqpWr+1kZc5035HCcv0Nwtaa/kC8zepzFmZir0AHHwlphh5/nTb3ZCCx28qTovNtmhPgVuu2imTo0v17ZaAhM6wBDf+kWov8JkvdNNpg63ssycKm6E5xXjcg/RO8+vaGRcZvfzsA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AFB6F202626DF4892C3C67484EDE820@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f9fd7e-f2b8-4401-324b-08d86c9c2749
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:42:00.1232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fhyKXZmvZ8vowlbLJbjX+K+FI52j3R9jQgmPyM8TWcweZDURKIBa8ryKk/p8OtMHnn/Ud+oJ8vMhqR+cB6AW1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3897
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602279664; bh=TNP8ren1Zf9kuDMwkYFmtO5gEhvOAG6vareHjbwrph8=;
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
        b=TD1yWXKoadSZfioaHlqznW/FdIwgKCLOJYykWkesv8FdIqiNaBkJ9C+KDBg5xsT+v
         qWwj98Iw0gWACcrprw2LfuySzBXYb6ZVd6FSN3izdweydOT2wmi6ZKsVRBLqm2bHid
         eUThkkqKy9LTVmsxjdgSpjt+otQrtG7VITGC7NFlRCfOQZjkjLpUmOczAP6XJPaoj1
         LROgVJgA6NDUUfGdESWdeLY6cDXR8HwbqAKzBwLhr1f+fdkkiV4aZ/xLO55ZFKMGWT
         x+367s4wKFgPMru4cCvUfvrpBNrZrBUDO3Fab11F1rtzJdmM5krbYhKBl2WoqqrbKe
         JqhnjO3/KT7dQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgZmlyc3QgY29tbWl0IG9mIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0
aGUgQ0ZNIHByb3RvY29sDQo+IGFjY29yZGluZyB0byA4MDIuMVEgc2VjdGlvbiAxMi4xNC4NCj4g
DQo+IEl0IGNvbnRhaW5zIE1FUCBpbnN0YW5jZSBjcmVhdGUsIGRlbGV0ZSBhbmQgY29uZmlndXJh
dGlvbi4NCj4gDQo+IENvbm5lY3Rpdml0eSBGYXVsdCBNYW5hZ2VtZW50IChDRk0pIGNvbXByaXNl
cyBjYXBhYmlsaXRpZXMgZm9yDQo+IGRldGVjdGluZywgdmVyaWZ5aW5nLCBhbmQgaXNvbGF0aW5n
IGNvbm5lY3Rpdml0eSBmYWlsdXJlcyBpbg0KPiBWaXJ0dWFsIEJyaWRnZWQgTmV0d29ya3MuIFRo
ZXNlIGNhcGFiaWxpdGllcyBjYW4gYmUgdXNlZCBpbg0KPiBuZXR3b3JrcyBvcGVyYXRlZCBieSBt
dWx0aXBsZSBpbmRlcGVuZGVudCBvcmdhbml6YXRpb25zLCBlYWNoDQo+IHdpdGggcmVzdHJpY3Rl
ZCBtYW5hZ2VtZW50IGFjY2VzcyB0byBlYWNoIG90aGVyPEUyPjw4MD48OTk+cyBlcXVpcG1lbnQu
DQo+IA0KPiBDRk0gZnVuY3Rpb25zIGFyZSBwYXJ0aXRpb25lZCBhcyBmb2xsb3dzOg0KPiAgICAg
LSBQYXRoIGRpc2NvdmVyeQ0KPiAgICAgLSBGYXVsdCBkZXRlY3Rpb24NCj4gICAgIC0gRmF1bHQg
dmVyaWZpY2F0aW9uIGFuZCBpc29sYXRpb24NCj4gICAgIC0gRmF1bHQgbm90aWZpY2F0aW9uDQo+
ICAgICAtIEZhdWx0IHJlY292ZXJ5DQo+IA0KPiBJbnRlcmZhY2UgY29uc2lzdHMgb2YgdGhlc2Ug
ZnVuY3Rpb25zOg0KPiBicl9jZm1fbWVwX2NyZWF0ZSgpDQo+IGJyX2NmbV9tZXBfZGVsZXRlKCkN
Cj4gYnJfY2ZtX21lcF9jb25maWdfc2V0KCkNCj4gYnJfY2ZtX2NjX2NvbmZpZ19zZXQoKQ0KPiBi
cl9jZm1fY2NfcGVlcl9tZXBfYWRkKCkNCj4gYnJfY2ZtX2NjX3BlZXJfbWVwX3JlbW92ZSgpDQo+
IA0KPiBBIE1FUCBpbnN0YW5jZSBpcyBjcmVhdGVkIGJ5IGJyX2NmbV9tZXBfY3JlYXRlKCkNCj4g
ICAgIC1JdCBpcyB0aGUgTWFpbnRlbmFuY2UgYXNzb2NpYXRpb24gRW5kIFBvaW50DQo+ICAgICAg
ZGVzY3JpYmVkIGluIDgwMi4xUSBzZWN0aW9uIDE5LjIuDQo+ICAgICAtSXQgaXMgY3JlYXRlZCBv
biBhIHNwZWNpZmljIGxldmVsICgxLTcpIGFuZCBpcyBhc3N1cmluZw0KPiAgICAgIHRoYXQgbm8g
Q0ZNIGZyYW1lcyBhcmUgcGFzc2luZyB0aHJvdWdoIHRoaXMgTUVQIG9uIGxvd2VyIGxldmVscy4N
Cj4gICAgIC1JdCBpbml0aWF0ZXMgYW5kIHZhbGlkYXRlcyBDRk0gZnJhbWVzIG9uIGl0cyBsZXZl
bC4NCj4gICAgIC1JdCBjYW4gb25seSBleGlzdCBvbiBhIHBvcnQgdGhhdCBpcyByZWxhdGVkIHRv
IGEgYnJpZGdlLg0KPiAgICAgLUF0dHJpYnV0ZXMgZ2l2ZW4gY2Fubm90IGJlIGNoYW5nZWQgdW50
aWwgdGhlIGluc3RhbmNlIGlzDQo+ICAgICAgZGVsZXRlZC4NCj4gDQo+IEEgTUVQIGluc3RhbmNl
IGNhbiBiZSBkZWxldGVkIGJ5IGJyX2NmbV9tZXBfZGVsZXRlKCkuDQo+IA0KPiBBIGNyZWF0ZWQg
TUVQIGluc3RhbmNlIGhhcyBhdHRyaWJ1dGVzIHRoYXQgY2FuIGJlDQo+IGNvbmZpZ3VyZWQgYnkg
YnJfY2ZtX21lcF9jb25maWdfc2V0KCkuDQo+IA0KPiBBIE1FUCBDb250aW51aXR5IENoZWNrIGZl
YXR1cmUgY2FuIGJlIGNvbmZpZ3VyZWQgYnkNCj4gYnJfY2ZtX2NjX2NvbmZpZ19zZXQoKQ0KPiAg
ICAgVGhlIENvbnRpbnVpdHkgQ2hlY2sgUmVjZWl2ZXIgc3RhdGUgbWFjaGluZSBjYW4gYmUNCj4g
ICAgIGVuYWJsZWQgYW5kIGRpc2FibGVkLg0KPiAgICAgQWNjb3JkaW5nIHRvIDgwMi4xUSBzZWN0
aW9uIDE5LjIuOA0KPiANCj4gQSBNRVAgY2FuIGhhdmUgUGVlciBNRVBzIGFkZGVkIGFuZCByZW1v
dmVkIGJ5DQo+IGJyX2NmbV9jY19wZWVyX21lcF9hZGQoKSBhbmQgYnJfY2ZtX2NjX3BlZXJfbWVw
X3JlbW92ZSgpDQo+ICAgICBUaGUgQ29udGludWl0eSBDaGVjayBmZWF0dXJlIGNhbiBtYWludGFp
biBjb25uZWN0aXZpdHkNCj4gICAgIHN0YXR1cyBvbiBlYWNoIGFkZGVkIFBlZXIgTUVQLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogSGVucmlrIEJqb2Vybmx1bmQgIDxoZW5yaWsuYmpvZXJubHVuZEBt
aWNyb2NoaXAuY29tPg0KPiBSZXZpZXdlZC1ieTogSG9yYXRpdSBWdWx0dXIgIDxob3JhdGl1LnZ1
bHR1ckBtaWNyb2NoaXAuY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvdWFwaS9saW51eC9jZm1fYnJp
ZGdlLmggfCAgMjMgKysrDQo+ICBuZXQvYnJpZGdlL01ha2VmaWxlICAgICAgICAgICAgIHwgICAy
ICsNCj4gIG5ldC9icmlkZ2UvYnJfY2ZtLmMgICAgICAgICAgICAgfCAyNzggKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gIG5ldC9icmlkZ2UvYnJfaWYuYyAgICAgICAgICAgICAg
fCAgIDEgKw0KPiAgbmV0L2JyaWRnZS9icl9wcml2YXRlLmggICAgICAgICB8ICAxMCArKw0KPiAg
bmV0L2JyaWRnZS9icl9wcml2YXRlX2NmbS5oICAgICB8ICA2MSArKysrKysrDQo+ICA2IGZpbGVz
IGNoYW5nZWQsIDM3NSBpbnNlcnRpb25zKCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVk
ZS91YXBpL2xpbnV4L2NmbV9icmlkZ2UuaA0KPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IG5ldC9icmlk
Z2UvYnJfY2ZtLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBuZXQvYnJpZGdlL2JyX3ByaXZhdGVf
Y2ZtLmgNCj4gDQoNCkFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5QG52aWRp
YS5jb20+DQoNCg==
