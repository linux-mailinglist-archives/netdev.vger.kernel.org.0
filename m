Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F42D289B3B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391963AbgJIVxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:53:32 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:31492 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732056AbgJIVxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 17:53:32 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80dbd50000>; Sat, 10 Oct 2020 05:53:26 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:53:25 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:53:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mg9l+vJEbQm0M5+gNPFjwvfICgzaYjULb5UMDZgxBmjYjTCQwgY4zj820hLZ1wHeI/p0iC0E4iNiLg6KzpGIQlhlSRX+L/kdi6pzSBBO+uxhM8bw2GkSrslDYNvJRzDCrLv3k3mQqCjxpmkGyGSLYP0snF4p+WMrx3MmKREeKtSkHRTzqe6WjRTPiiu9SAaXKnC5IaTb2ayNGEFI8Ey0N3vjQs92HEaEwAbMz5VMLVjy3XhfpVMaDCwFB6t8qMTZou/01A+IsHaje52OXj4hfg0LxPl+EO7o0SK0tJioqAlI9u6Go12HvWYMW0zjCsEIdN48iSWDiewe2b0xg2sh7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jtXPI1EluYc5Al6woS/GT6MG+BefbL+qt4Dm+VYiWU=;
 b=AbHAyn+H5QwB/mZA3SZj18D7s49RV7aJJb4A5YsxdSU0zienMuK+Ns0sBmeiL0ktheF02sFLRQgYv11Ouya93z2VgV5pHRTM9UKzMdmpu0hcXSqMxfR3WS6gb17/Xf4Vn+mdKDW81OnvrYiUTqcx1pY8R8theXgopICz5rEY+eD6qRRZ5Iq1KKFmnUorWUrpNj/r0SoTL/mDlx9Aiftw7Xnt0JRAtSq1vxLcClFXK4wEZTRf9G9t2gH9Y7eZ6XxkH3CQnUDPKe0SJytkm6ypUaKy6h8KUdJVicQXbNgZVTMt/tmiO0eOz7tdXiY8cQFeUo5bZetaBSI2u1A9/GpoZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM6PR12MB3563.namprd12.prod.outlook.com (2603:10b6:5:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 9 Oct
 2020 21:53:23 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:53:23 +0000
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
Subject: Re: [PATCH net-next v4 07/10] bridge: cfm: Netlink SET configuration
 Interface.
Thread-Topic: [PATCH net-next v4 07/10] bridge: cfm: Netlink SET configuration
 Interface.
Thread-Index: AQHWnknktoI3hWOfzkyGNMLM3ojDWKmP0KIA
Date:   Fri, 9 Oct 2020 21:53:23 +0000
Message-ID: <7b6678065b33aea63ab5e802852e738035b94719.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
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
x-ms-office365-filtering-correlation-id: 7c61a879-eef9-4923-b125-08d86c9dbe71
x-ms-traffictypediagnostic: DM6PR12MB3563:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3563412F74C9B3FCE2112718DF080@DM6PR12MB3563.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xuSNFyadFHA4fmba14CwASNmO+O8lQ3ydkQ65Xl2T1+eCXCNax3V5mZkcXChfn1Hsqg7R6G5P+ljUQynrKjyb2oVF2U23+SGXKT/il/34VRc9QeOumeOKHri2eIRueH2g53uFVy3eq9pkJTBimHdFLYZG7R77jA+hMVOJcrsAMB8w/eU7kvpz+/q7GIvAVfjAVS9MJ2bbxfu6QwAO9Bt17nnp/DMVNaokYUQR15jjTWtYCdSVR6MCGAgkzTE/qf+zBkhvL/3XobGW+p2i2rgYh+2pw2Is1AI5KzAq69okvkIIYYxDLvOWFLwpnmSsmtXJAm7WwvcxHG9kVlV/8IcAsPdLXx/HxWGt+zISChIUL0bh+8Bg48twtIadjhvJFQK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(186003)(26005)(6506007)(478600001)(316002)(5660300002)(71200400001)(2616005)(91956017)(64756008)(66946007)(66446008)(66476007)(76116006)(66556008)(86362001)(3450700001)(8676002)(4326008)(110136005)(2906002)(6486002)(8936002)(36756003)(6512007)(83380400001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QlktjyreQ2YFfJvE5IXSnberqhWA7UvIo9m74TW0I3dezFE4ggms5v2f1cBQpgOA0zS+NQPpafw97tMcphEEmLCGNN+s0qrJ07cYJERH9Bt3N6a0xt4DUqHLu9Cc/A3rXsQ2Toc7UbNyBhZz+KIqH/J5QuocCwxFV4sM+5dApk306Ks68c132ZZMZCrjalWWfS+sGA4LXYwxli1YrsFAwFzS9OvSJRqddPUB8LTSkHW+Ty8CjxKKvP2brUVhCt5Ep1RPoeuL0eWh9VXi5141BJTPDNK3JYJokoUoYJjQhJ4Qf7bo7D8bw/7QmgMySqNpsxe4Wbj68+DYq2nvU/EsD3c7gWcsZwKsI+6Phz3E/3TCHx7ryjmicUUSQeKIgCoYazyamVeiufgxiEty/H3R9e764F9ez8H7KyPem/yOpLIYUh85qa2SBGpwxI1hIuLtcRUf8ISmhXtSUwI30+xfZyFXcY9IkZ1Ih8+osDfJxBxIb8/ZU22BogdKjvxYtbDAAQef2WFPjkGeK4Dj6eKtdKocbtgzGoWotv4Tt8HM9pyl+TrHM0rLUbqFMR8UB/txShBG4Py0klycpMPHPTYKytr7yZJpXJwxA4ZqrNQk9NnQaIDI1f5lmLfw8BlpfViQAxbhMP48s5qUd3cIEIvuJQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7F6713A7E0F1547912452E947FA38D8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c61a879-eef9-4923-b125-08d86c9dbe71
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:53:23.1743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fmVbY91tJ3u3ar04OliViXzKmGyCH18M3dPE5xdVqzYUa9U6RHP5v2GaTNTikAzNBifOARFnoYwXMdjtmfVAcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3563
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280406; bh=5jtXPI1EluYc5Al6woS/GT6MG+BefbL+qt4Dm+VYiWU=;
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
        b=DIcRAxVHAabx6Oqq7tach6/fu0JMjS9v/QFJ+u1MIE9ygXcp6sAtuP1jl50GV4t4q
         8LbStW3TbVhJOLvcfY5KJP6XHMigvx5plRWGafDfYYCPxqWkQ4SvbunK46zAMK51VX
         upCfEnbXUcaZ/2BlM4B6eNq8YngaroJ2Vo56SK51L9nzU2ooGRoKho6TIZKBUQc601
         SW0XFnV+s94AtsB8FnP43+cPRPA3youmEynJrQxzvH9ngVd9X/vj6YiVpsJ6S6M0UY
         gG4nfTbOfVQEe/Ep69ZCycBk3o8ADPXmbxc+rfo4UflL2Tee/CZRstyMvXmYY79wpo
         pRDtnaO+QgG+A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjM1ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBpcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgQ0ZNIG5ldGxpbmsgY29uZmlndXJh
dGlvbg0KPiBzZXQgaW5mb3JtYXRpb24gaW50ZXJmYWNlLg0KPiANCj4gQWRkIG5ldyBuZXN0ZWQg
bmV0bGluayBhdHRyaWJ1dGVzLiBUaGVzZSBhdHRyaWJ1dGVzIGFyZSB1c2VkIGJ5IHRoZQ0KPiB1
c2VyIHNwYWNlIHRvIGNyZWF0ZS9kZWxldGUvY29uZmlndXJlIENGTSBpbnN0YW5jZXMuDQo+IA0K
PiBTRVRMSU5LOg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNOg0KPiAgICAgICAgIEluZGljYXRlIHRo
YXQgdGhlIGZvbGxvd2luZyBhdHRyaWJ1dGVzIGFyZSBDRk0uDQo+IA0KPiAgICAgSUZMQV9CUklE
R0VfQ0ZNX01FUF9DUkVBVEU6DQo+ICAgICAgICAgVGhpcyBpbmRpY2F0ZSB0aGF0IGEgTUVQIGlu
c3RhbmNlIG11c3QgYmUgY3JlYXRlZC4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfREVMRVRF
Og0KPiAgICAgICAgIFRoaXMgaW5kaWNhdGUgdGhhdCBhIE1FUCBpbnN0YW5jZSBtdXN0IGJlIGRl
bGV0ZWQuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NPTkZJRzoNCj4gICAgICAgICBUaGlz
IGluZGljYXRlIHRoYXQgYSBNRVAgaW5zdGFuY2UgbXVzdCBiZSBjb25maWd1cmVkLg0KPiAgICAg
SUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJRzoNCj4gICAgICAgICBUaGlzIGluZGljYXRlIHRoYXQg
YSBNRVAgaW5zdGFuY2UgQ29udGludWl0eSBDaGVjayAoQ0MpDQo+ICAgICAgICAgZnVuY3Rpb25h
bGl0eSBtdXN0IGJlIGNvbmZpZ3VyZWQuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9N
RVBfQUREOg0KPiAgICAgICAgIFRoaXMgaW5kaWNhdGUgdGhhdCBhIENDIFBlZXIgTUVQIG11c3Qg
YmUgYWRkZWQuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfUEVFUl9NRVBfUkVNT1ZFOg0KPiAg
ICAgICAgIFRoaXMgaW5kaWNhdGUgdGhhdCBhIENDIFBlZXIgTUVQIG11c3QgYmUgcmVtb3ZlZC4N
Cj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFg6DQo+ICAgICAgICAgVGhpcyBpbmRpY2F0
ZSB0aGF0IHRoZSBDQyB0cmFuc21pdHRlZCBDQ00gUERVIG11c3QgYmUgY29uZmlndXJlZC4NCj4g
ICAgIElGTEFfQlJJREdFX0NGTV9DQ19SREk6DQo+ICAgICAgICAgVGhpcyBpbmRpY2F0ZSB0aGF0
IHRoZSBDQyB0cmFuc21pdHRlZCBDQ00gUERVIFJESSBtdXN0IGJlDQo+ICAgICAgICAgY29uZmln
dXJlZC4NCj4gDQo+IENGTSBuZXN0ZWQgYXR0cmlidXRlIGhhcyB0aGUgZm9sbG93aW5nIGF0dHJp
YnV0ZXMgaW4gbmV4dCBsZXZlbC4NCj4gDQo+IFNFVExJTksgUlRFWFRfRklMVEVSX0NGTV9DT05G
SUc6DQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NSRUFURV9JTlNUQU5DRToNCj4gICAgICAg
ICBUaGUgY3JlYXRlZCBNRVAgaW5zdGFuY2UgbnVtYmVyLg0KPiAgICAgICAgIFRoZSB0eXBlIGlz
IHUzMi4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfQ1JFQVRFX0RPTUFJTjoNCj4gICAgICAg
ICBUaGUgY3JlYXRlZCBNRVAgZG9tYWluLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYnJf
Y2ZtX2RvbWFpbikuDQo+ICAgICAgICAgSXQgbXVzdCBiZSBCUl9DRk1fUE9SVC4NCj4gICAgICAg
ICBUaGlzIG1lYW5zIHRoYXQgQ0ZNIGZyYW1lcyBhcmUgdHJhbnNtaXR0ZWQgYW5kIHJlY2VpdmVk
DQo+ICAgICAgICAgZGlyZWN0bHkgb24gdGhlIHBvcnQgLSB1bnRhZ2dlZC4gTm90IGluIGEgVkxB
Ti4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfQ1JFQVRFX0RJUkVDVElPTjoNCj4gICAgICAg
ICBUaGUgY3JlYXRlZCBNRVAgZGlyZWN0aW9uLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAo
YnJfY2ZtX21lcF9kaXJlY3Rpb24pLg0KPiAgICAgICAgIEl0IG11c3QgYmUgQlJfQ0ZNX01FUF9E
SVJFQ1RJT05fRE9XTi4NCj4gICAgICAgICBUaGlzIG1lYW5zIHRoYXQgQ0ZNIGZyYW1lcyBhcmUg
dHJhbnNtaXR0ZWQgYW5kIHJlY2VpdmVkIG9uDQo+ICAgICAgICAgdGhlIHBvcnQuIE5vdCBpbiB0
aGUgYnJpZGdlLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX01FUF9DUkVBVEVfSUZJTkRFWDoNCj4g
ICAgICAgICBUaGUgY3JlYXRlZCBNRVAgcmVzaWRlbmNlIHBvcnQgaWZpbmRleC4NCj4gICAgICAg
ICBUaGUgdHlwZSBpcyB1MzIgKGlmaW5kZXgpLg0KPiANCj4gICAgIElGTEFfQlJJREdFX0NGTV9N
RVBfREVMRVRFX0lOU1RBTkNFOg0KPiAgICAgICAgIFRoZSBkZWxldGVkIE1FUCBpbnN0YW5jZSBu
dW1iZXIuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiANCj4gICAgIElGTEFfQlJJREdF
X0NGTV9NRVBfQ09ORklHX0lOU1RBTkNFOg0KPiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCBp
bnN0YW5jZSBudW1iZXIuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiAgICAgSUZMQV9C
UklER0VfQ0ZNX01FUF9DT05GSUdfVU5JQ0FTVF9NQUM6DQo+ICAgICAgICAgVGhlIGNvbmZpZ3Vy
ZWQgTUVQIHVuaWNhc3QgTUFDIGFkZHJlc3MuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgNip1OCAo
YXJyYXkpLg0KPiAgICAgICAgIFRoaXMgaXMgdXNlZCBhcyBTTUFDIGluIGFsbCB0cmFuc21pdHRl
ZCBDRk0gZnJhbWVzLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX01FUF9DT05GSUdfTURMRVZFTDoN
Cj4gICAgICAgICBUaGUgY29uZmlndXJlZCBNRVAgdW5pY2FzdCBNRCBsZXZlbC4NCj4gICAgICAg
ICBUaGUgdHlwZSBpcyB1MzIuDQo+ICAgICAgICAgSXQgbXVzdCBiZSBpbiB0aGUgcmFuZ2UgMS03
Lg0KPiAgICAgICAgIE5vIENGTSBmcmFtZXMgYXJlIHBhc3NpbmcgdGhyb3VnaCB0aGlzIE1FUCBv
biBsb3dlciBsZXZlbHMuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NPTkZJR19NRVBJRDoN
Cj4gICAgICAgICBUaGUgY29uZmlndXJlZCBNRVAgSUQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMg
dTMyLg0KPiAgICAgICAgIEl0IG11c3QgYmUgaW4gdGhlIHJhbmdlIDAtMHgxRkZGLg0KPiAgICAg
ICAgIFRoaXMgTUVQIElEIGlzIGluc2VydGVkIGluIGFueSB0cmFuc21pdHRlZCBDQ00gZnJhbWUu
DQo+IA0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJR19JTlNUQU5DRToNCj4gICAgICAg
ICBUaGUgY29uZmlndXJlZCBNRVAgaW5zdGFuY2UgbnVtYmVyLg0KPiAgICAgICAgIFRoZSB0eXBl
IGlzIHUzMi4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DT05GSUdfRU5BQkxFOg0KPiAgICAg
ICAgIFRoZSBDb250aW51aXR5IENoZWNrIChDQykgZnVuY3Rpb25hbGl0eSBpcyBlbmFibGVkIG9y
IGRpc2FibGVkLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICBJRkxB
X0JSSURHRV9DRk1fQ0NfQ09ORklHX0VYUF9JTlRFUlZBTDoNCj4gICAgICAgICBUaGUgQ0MgZXhw
ZWN0ZWQgcmVjZWl2ZSBpbnRlcnZhbCBvZiBDQ00gZnJhbWVzLg0KPiAgICAgICAgIFRoZSB0eXBl
IGlzIHUzMiAoYnJfY2ZtX2NjbV9pbnRlcnZhbCkuDQo+ICAgICAgICAgVGhpcyBpcyBhbHNvIHRo
ZSB0cmFuc21pc3Npb24gaW50ZXJ2YWwgb2YgQ0NNIGZyYW1lcyB3aGVuIGVuYWJsZWQuDQo+ICAg
ICBJRkxBX0JSSURHRV9DRk1fQ0NfQ09ORklHX0VYUF9NQUlEOg0KPiAgICAgICAgIFRoZSBDQyBl
eHBlY3RlZCByZWNlaXZlIE1BSUQgaW4gQ0NNIGZyYW1lcy4NCj4gICAgICAgICBUaGUgdHlwZSBp
cyBDRk1fTUFJRF9MRU5HVEgqdTguDQo+ICAgICAgICAgVGhpcyBpcyBNQUlEIGlzIGFsc28gaW5z
ZXJ0ZWQgaW4gdHJhbnNtaXR0ZWQgQ0NNIGZyYW1lcy4NCj4gDQo+ICAgICBJRkxBX0JSSURHRV9D
Rk1fQ0NfUEVFUl9NRVBfSU5TVEFOQ0U6DQo+ICAgICAgICAgVGhlIGNvbmZpZ3VyZWQgTUVQIGlu
c3RhbmNlIG51bWJlci4NCj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIuDQo+ICAgICBJRkxBX0JS
SURHRV9DRk1fQ0NfUEVFUl9NRVBJRDoNCj4gICAgICAgICBUaGUgQ0MgUGVlciBNRVAgSUQgYWRk
ZWQuDQo+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiAgICAgICAgIFdoZW4gYSBQZWVyIE1F
UCBJRCBpcyBhZGRlZCBhbmQgQ0MgaXMgZW5hYmxlZCBpdCBpcyBleHBlY3RlZCB0bw0KPiAgICAg
ICAgIHJlY2VpdmUgQ0NNIGZyYW1lcyBmcm9tIHRoYXQgUGVlciBNRVAuDQo+IA0KPiAgICAgSUZM
QV9CUklER0VfQ0ZNX0NDX1JESV9JTlNUQU5DRToNCj4gICAgICAgICBUaGUgY29uZmlndXJlZCBN
RVAgaW5zdGFuY2UgbnVtYmVyLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gICAgIElG
TEFfQlJJREdFX0NGTV9DQ19SRElfUkRJOg0KPiAgICAgICAgIFRoZSBSREkgdGhhdCBpcyBpbnNl
cnRlZCBpbiB0cmFuc21pdHRlZCBDQ00gUERVLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAo
Ym9vbCkuDQo+IA0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NDTV9UWF9JTlNUQU5DRToNCj4g
ICAgICAgICBUaGUgY29uZmlndXJlZCBNRVAgaW5zdGFuY2UgbnVtYmVyLg0KPiAgICAgICAgIFRo
ZSB0eXBlIGlzIHUzMi4NCj4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhfRE1BQzoNCj4g
ICAgICAgICBUaGUgdHJhbnNtaXR0ZWQgQ0NNIGZyYW1lIGRlc3RpbmF0aW9uIE1BQyBhZGRyZXNz
Lg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIDYqdTggKGFycmF5KS4NCj4gICAgICAgICBUaGlzIGlz
IHVzZWQgYXMgRE1BQyBpbiBhbGwgdHJhbnNtaXR0ZWQgQ0ZNIGZyYW1lcy4NCj4gICAgIElGTEFf
QlJJREdFX0NGTV9DQ19DQ01fVFhfU0VRX05PX1VQREFURToNCj4gICAgICAgICBUaGUgdHJhbnNt
aXR0ZWQgQ0NNIGZyYW1lIHVwZGF0ZSAoaW5jcmVtZW50KSBvZiBzZXF1ZW5jZQ0KPiAgICAgICAg
IG51bWJlciBpcyBlbmFibGVkIG9yIGRpc2FibGVkLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUz
MiAoYm9vbCkuDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYX1BFUklPRDoNCj4gICAg
ICAgICBUaGUgcGVyaW9kIG9mIHRpbWUgd2hlcmUgQ0NNIGZyYW1lIGFyZSB0cmFuc21pdHRlZC4N
Cj4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIuDQo+ICAgICAgICAgVGhlIHRpbWUgaXMgZ2l2ZW4g
aW4gc2Vjb25kcy4gU0VUTElOSyBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYDQo+ICAgICAgICAg
bXVzdCBiZSBkb25lIGJlZm9yZSB0aW1lb3V0IHRvIGtlZXAgdHJhbnNtaXNzaW9uIGFsaXZlLg0K
PiAgICAgICAgIFdoZW4gcGVyaW9kIGlzIHplcm8gYW55IG9uZ29pbmcgQ0NNIGZyYW1lIHRyYW5z
bWlzc2lvbg0KPiAgICAgICAgIHdpbGwgYmUgc3RvcHBlZC4NCj4gICAgIElGTEFfQlJJREdFX0NG
TV9DQ19DQ01fVFhfSUZfVExWOg0KPiAgICAgICAgIFRoZSB0cmFuc21pdHRlZCBDQ00gZnJhbWUg
dXBkYXRlIHdpdGggSW50ZXJmYWNlIFN0YXR1cyBUTFYNCj4gICAgICAgICBpcyBlbmFibGVkIG9y
IGRpc2FibGVkLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ICAgICBJRkxB
X0JSSURHRV9DRk1fQ0NfQ0NNX1RYX0lGX1RMVl9WQUxVRToNCj4gICAgICAgICBUaGUgdHJhbnNt
aXR0ZWQgSW50ZXJmYWNlIFN0YXR1cyBUTFYgdmFsdWUgZmllbGQuDQo+ICAgICAgICAgVGhlIHR5
cGUgaXMgdTguDQo+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYX1BPUlRfVExWOg0KPiAg
ICAgICAgIFRoZSB0cmFuc21pdHRlZCBDQ00gZnJhbWUgdXBkYXRlIHdpdGggUG9ydCBTdGF0dXMg
VExWIGlzIGVuYWJsZWQNCj4gICAgICAgICBvciBkaXNhYmxlZC4NCj4gICAgICAgICBUaGUgdHlw
ZSBpcyB1MzIgKGJvb2wpLg0KPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NDTV9UWF9QT1JUX1RM
Vl9WQUxVRToNCj4gICAgICAgICBUaGUgdHJhbnNtaXR0ZWQgUG9ydCBTdGF0dXMgVExWIHZhbHVl
IGZpZWxkLg0KPiAgICAgICAgIFRoZSB0eXBlIGlzIHU4Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
SGVucmlrIEJqb2Vybmx1bmQgIDxoZW5yaWsuYmpvZXJubHVuZEBtaWNyb2NoaXAuY29tPg0KPiBS
ZXZpZXdlZC1ieTogSG9yYXRpdSBWdWx0dXIgIDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29t
Pg0KPiAtLS0NCj4gIGluY2x1ZGUvdWFwaS9saW51eC9pZl9icmlkZ2UuaCB8ICA5MCArKysrKysr
DQo+ICBpbmNsdWRlL3VhcGkvbGludXgvcnRuZXRsaW5rLmggfCAgIDEgKw0KPiAgbmV0L2JyaWRn
ZS9NYWtlZmlsZSAgICAgICAgICAgIHwgICAyICstDQo+ICBuZXQvYnJpZGdlL2JyX2NmbS5jICAg
ICAgICAgICAgfCAgIDUgKw0KPiAgbmV0L2JyaWRnZS9icl9jZm1fbmV0bGluay5jICAgIHwgNDU4
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgbmV0L2JyaWRnZS9icl9uZXRs
aW5rLmMgICAgICAgIHwgICA1ICsNCj4gIG5ldC9icmlkZ2UvYnJfcHJpdmF0ZS5oICAgICAgICB8
ICAxNyArLQ0KPiAgNyBmaWxlcyBjaGFuZ2VkLCA1NzYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBuZXQvYnJpZGdlL2JyX2NmbV9uZXRsaW5rLmMN
Cj4gDQoNCkFja2VkLWJ5OiBOaWtvbGF5IEFsZWtzYW5kcm92IDxuaWtvbGF5QG52aWRpYS5jb20+
DQoNCg==
