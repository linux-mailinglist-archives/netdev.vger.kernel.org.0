Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E52289B58
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 00:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389646AbgJIV7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:59:25 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14188 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389451AbgJIV7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:59:24 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f80dd020001>; Fri, 09 Oct 2020 14:58:26 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 9 Oct
 2020 21:59:23 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 9 Oct 2020 21:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhS5iToCZz5QpIUZyWTEUc1uVxg/VJxJZoPLQWBsoGDsRfwZSs+LySZ+9sQ30VtMMYz+1CaMIxz3NhUpPGX+c2EFpREWeguiUAmXwOn64CI4g1l57h8F1yIN2z6H2W+aRzSYyQ3oP4m3Gdf9qoXBLffMA6Oi3pTKe+tkIrivRWA+Nxagm9U6fQmoDZR+zL/0mA5FawM34sxBD/9bP9EjA01GkHT+Gn+kLSNrH+pIfHghPZXcD26Toe5nFY8NXo4LGb/rqRJF+KyrTjsW7M8RzZqXV867aJ4MKveWOAANJuQJwk6qj5temIsQjZLklzCuYyiMSSSI3sOd7DEhhdCj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmEEOoUQC0RnljDkfwX1pTRdN9zx/KDUwfRuY/SY7RM=;
 b=ZsxM+HyC079fiqX+9LnD6j1Bs1TS8hjEy4mMYxCunAtzi6HFyKLC0g22dkoVoesdrmrTqG+Zx+KLBJDc4/8dL2T4lcwAeUKp4CfWkmmm4Dh/a1wUKZuMMpd6JevFcwioizsueYaWx7lRuHjgZBzNAmoKZnqyOML3XArE04+x2wQBlRXrdQzhbpqjyHK69JtNLmfn+GIIZaC86CAuddeH+hM6aWvYQrC2fUblDIpoid2aYOjFVccUvAgT/711eY80Vd1hs+qIWtACpGB+vFIVIa1nk5zcnVX2idhjXShN/R2toOdC/zwuzPZP/kyu+FyU+PBP5hGqGJIHoTZSBvzdMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM5PR1201MB0042.namprd12.prod.outlook.com (2603:10b6:4:50::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 9 Oct
 2020 21:59:21 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.027; Fri, 9 Oct 2020
 21:59:21 +0000
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
Thread-Index: AQHWnknaYdz63RTY906h+kGARB2DRamP0ZEAgAAAvAA=
Date:   Fri, 9 Oct 2020 21:59:21 +0000
Message-ID: <8e2e3709f4a0143c99e0f7c8c7a36ac6615b348e.camel@nvidia.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
         <20201009143530.2438738-9-henrik.bjoernlund@microchip.com>
         <1180153d9d7dc5d5c6af9c2eb32f4052c47e14f3.camel@nvidia.com>
In-Reply-To: <1180153d9d7dc5d5c6af9c2eb32f4052c47e14f3.camel@nvidia.com>
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
x-ms-office365-filtering-correlation-id: db60e88c-37a4-44fa-7038-08d86c9e9404
x-ms-traffictypediagnostic: DM5PR1201MB0042:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB0042C82106BEBD8E2342F399DF080@DM5PR1201MB0042.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VZibDkH9RA2tI+LScJGnTcG6pNlsPgABD3GdcburfEFf/NZRMMxjZKwXwE5oL5IPZPCMeWz1BIbxHUkGbvwXfqytgZUeY0fyB0yrOUsGdy4mdtGhFk+MH+Kai9ubWcK2qt8xU/e/3avJ2+amYAniw6rSKsQmBseIgHrbX+7Pee5lp+C/gyghiYHZrL0NH1nmlijSlgHIAXXayh3eKxrYxhunfHJsbgG2jVWKPqCbGETTW+S3BaEfto/6m50PQFgvTg0tQZ5d0oMp5Y4AUPxDmJIC7cUX0RGCmlNuVxNU0q2o0eu4Suc9d9ZeahVydHBCHwJxvKp9mjBCStWr9Sl4gFlUneEgndwFYjpjGLdBuOCzVhPxJcmmLjGuE1pOm5De
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(2906002)(66556008)(91956017)(66946007)(86362001)(6512007)(66476007)(64756008)(26005)(478600001)(83380400001)(316002)(8936002)(36756003)(5660300002)(186003)(110136005)(66446008)(6486002)(6506007)(4001150100001)(76116006)(2616005)(8676002)(71200400001)(3450700001)(4326008)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: eKE3KxnhfVjdqxmG6BwOWq1Q74EB3a7BTlYwkNaa2WL1h7FEsYTyqLBx+nHSTcpLUi1tMu3Wf/Zlk7CLNZ6uCouiaMHQoXNjne5ie6wRZ0PWSI1NItHXGUyQf0sD3Lf0CjZ/yEMjaySQNSkak+nfTdLMZNgTJWIgh+7DTrlsVUEEuJnXxtnvb5Fq6PFE7KVGibCHp2Hq1YU6aGfBzck4rIYzPuRTL41L1EtdZj3LkjDKUePv4w/ufXqdRLcMPJ/X4YsvMO+jkzGvCGa+J7gpMVKrZbxJvcXMwCXCks/XRkXn/f3m4+DhAsHEAcYbYE2alCUDDcHMkns5qBn/Ds3VgVgU7B8oYFOopAKGpzMcM3tMKBPMWpfE215bZc9WRh+Mctf4f4CPmTHW5+ROM+qQqnPDHfNnMNNvPtAVYWuqwK4EK7LVg9Am/Xu8P1QHJWqRbGcjzOo5XQtYWAYAWJEsLjE54EOTXjtcthwh6cWPFRodSU+D3Fm/xuYN1pTUvZ0VcZJrbNR17mD2rm++eB21Fa57NTER++3VEAz5GqHvoobPNv7RDo0+10D/HMpOo/YVM1UpxAHXiHV5vrn3MrytGE/oziozak0Ng6DIflIOJU/wWbVPKvqJNkLz2onGweEiv8t30OTGDYFH2d3yAUmxqg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B068859E73E6874F8DFA6308A6ED33AF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db60e88c-37a4-44fa-7038-08d86c9e9404
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 21:59:21.5567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38x7tdijzicI+wlI+KVfKH+Qh6/svFRIQA/LxchVqbEgJw41BgnbPkXO/tcDwXInE0hYBlvRU3TbgG0Dx9hh6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0042
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602280706; bh=cmEEOoUQC0RnljDkfwX1pTRdN9zx/KDUwfRuY/SY7RM=;
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
        b=ldvKqa4a1BVQQfquUbCjDNQD3o+b0s89ZmyfZjr8B9LeZ7Z/ZgpERe7RAO4aX79la
         nTNLotHdLe5FXmDqGiW2XRTDzFEfkaz2CzIx2HOsc9zDBREe6LYXeI6H3AAgPWQzpZ
         5FS8tTLF3xejPPqZ14uPIo8NMstgZ38zpo0UguNcGqUDlGDWs1CwN2ihnBrb6dVPEl
         T28yi3BoUOlk2hCRXch8EbNifhnkxJzH8/bekWID/3WxavO1ZxERldYn1aisdej+Zz
         4FfnJwbnTWq/wyFbgqB5atz4LM/18rwnQ/2qdd4id6fycL4cYnQd7/lzTDkJdwinEN
         WFR76FDv6uhPg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTEwLTEwIGF0IDAwOjU2ICswMzAwLCBOaWtvbGF5IEFsZWtzYW5kcm92IHdy
b3RlOg0KPiBPbiBGcmksIDIwMjAtMTAtMDkgYXQgMTQ6MzUgKzAwMDAsIEhlbnJpayBCam9lcm5s
dW5kIHdyb3RlOg0KPiA+IFRoaXMgaXMgdGhlIGltcGxlbWVudGF0aW9uIG9mIENGTSBuZXRsaW5r
IGNvbmZpZ3VyYXRpb24NCj4gPiBnZXQgaW5mb3JtYXRpb24gaW50ZXJmYWNlLg0KPiA+IA0KPiA+
IEFkZCBuZXcgbmVzdGVkIG5ldGxpbmsgYXR0cmlidXRlcy4gVGhlc2UgYXR0cmlidXRlcyBhcmUg
dXNlZCBieSB0aGUNCj4gPiB1c2VyIHNwYWNlIHRvIGdldCBjb25maWd1cmF0aW9uIGluZm9ybWF0
aW9uLg0KPiA+IA0KPiA+IEdFVExJTks6DQo+ID4gICAgIFJlcXVlc3QgZmlsdGVyIFJURVhUX0ZJ
TFRFUl9DRk1fQ09ORklHOg0KPiA+ICAgICBJbmRpY2F0aW5nIHRoYXQgQ0ZNIGNvbmZpZ3VyYXRp
b24gaW5mb3JtYXRpb24gbXVzdCBiZSBkZWxpdmVyZWQuDQo+ID4gDQo+ID4gICAgIElGTEFfQlJJ
REdFX0NGTToNCj4gPiAgICAgICAgIFBvaW50cyB0byB0aGUgQ0ZNIGluZm9ybWF0aW9uLg0KPiA+
IA0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NSRUFURV9JTkZPOg0KPiA+ICAgICAgICAg
VGhpcyBpbmRpY2F0ZSB0aGF0IE1FUCBpbnN0YW5jZSBjcmVhdGUgcGFyYW1ldGVycyBhcmUgZm9s
bG93aW5nLg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NPTkZJR19JTkZPOg0KPiA+ICAg
ICAgICAgVGhpcyBpbmRpY2F0ZSB0aGF0IE1FUCBpbnN0YW5jZSBjb25maWcgcGFyYW1ldGVycyBh
cmUgZm9sbG93aW5nLg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ09ORklHX0lORk86DQo+
ID4gICAgICAgICBUaGlzIGluZGljYXRlIHRoYXQgTUVQIGluc3RhbmNlIENDIGZ1bmN0aW9uYWxp
dHkNCj4gPiAgICAgICAgIHBhcmFtZXRlcnMgYXJlIGZvbGxvd2luZy4NCj4gPiAgICAgSUZMQV9C
UklER0VfQ0ZNX0NDX1JESV9JTkZPOg0KPiA+ICAgICAgICAgVGhpcyBpbmRpY2F0ZSB0aGF0IEND
IHRyYW5zbWl0dGVkIENDTSBQRFUgUkRJDQo+ID4gICAgICAgICBwYXJhbWV0ZXJzIGFyZSBmb2xs
b3dpbmcuDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhfSU5GTzoNCj4gPiAgICAg
ICAgIFRoaXMgaW5kaWNhdGUgdGhhdCBDQyB0cmFuc21pdHRlZCBDQ00gUERVIHBhcmFtZXRlcnMg
YXJlDQo+ID4gICAgICAgICBmb2xsb3dpbmcuDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19Q
RUVSX01FUF9JTkZPOg0KPiA+ICAgICAgICAgVGhpcyBpbmRpY2F0ZSB0aGF0IHRoZSBhZGRlZCBw
ZWVyIE1FUCBJRHMgYXJlIGZvbGxvd2luZy4NCj4gPiANCj4gPiBDRk0gbmVzdGVkIGF0dHJpYnV0
ZSBoYXMgdGhlIGZvbGxvd2luZyBhdHRyaWJ1dGVzIGluIG5leHQgbGV2ZWwuDQo+ID4gDQo+ID4g
R0VUTElOSyBSVEVYVF9GSUxURVJfQ0ZNX0NPTkZJRzoNCj4gPiAgICAgSUZMQV9CUklER0VfQ0ZN
X01FUF9DUkVBVEVfSU5TVEFOQ0U6DQo+ID4gICAgICAgICBUaGUgY3JlYXRlZCBNRVAgaW5zdGFu
Y2UgbnVtYmVyLg0KPiA+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiA+ICAgICBJRkxBX0JS
SURHRV9DRk1fTUVQX0NSRUFURV9ET01BSU46DQo+ID4gICAgICAgICBUaGUgY3JlYXRlZCBNRVAg
ZG9tYWluLg0KPiA+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyIChicl9jZm1fZG9tYWluKS4NCj4g
PiAgICAgICAgIEl0IG11c3QgYmUgQlJfQ0ZNX1BPUlQuDQo+ID4gICAgICAgICBUaGlzIG1lYW5z
IHRoYXQgQ0ZNIGZyYW1lcyBhcmUgdHJhbnNtaXR0ZWQgYW5kIHJlY2VpdmVkDQo+ID4gICAgICAg
ICBkaXJlY3RseSBvbiB0aGUgcG9ydCAtIHVudGFnZ2VkLiBOb3QgaW4gYSBWTEFOLg0KPiA+ICAg
ICBJRkxBX0JSSURHRV9DRk1fTUVQX0NSRUFURV9ESVJFQ1RJT046DQo+ID4gICAgICAgICBUaGUg
Y3JlYXRlZCBNRVAgZGlyZWN0aW9uLg0KPiA+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyIChicl9j
Zm1fbWVwX2RpcmVjdGlvbikuDQo+ID4gICAgICAgICBJdCBtdXN0IGJlIEJSX0NGTV9NRVBfRElS
RUNUSU9OX0RPV04uDQo+ID4gICAgICAgICBUaGlzIG1lYW5zIHRoYXQgQ0ZNIGZyYW1lcyBhcmUg
dHJhbnNtaXR0ZWQgYW5kIHJlY2VpdmVkIG9uDQo+ID4gICAgICAgICB0aGUgcG9ydC4gTm90IGlu
IHRoZSBicmlkZ2UuDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfQ1JFQVRFX0lGSU5ERVg6
DQo+ID4gICAgICAgICBUaGUgY3JlYXRlZCBNRVAgcmVzaWRlbmNlIHBvcnQgaWZpbmRleC4NCj4g
PiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoaWZpbmRleCkuDQo+ID4gDQo+ID4gICAgIElGTEFf
QlJJREdFX0NGTV9NRVBfREVMRVRFX0lOU1RBTkNFOg0KPiA+ICAgICAgICAgVGhlIGRlbGV0ZWQg
TUVQIGluc3RhbmNlIG51bWJlci4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gPiAN
Cj4gPiAgICAgSUZMQV9CUklER0VfQ0ZNX01FUF9DT05GSUdfSU5TVEFOQ0U6DQo+ID4gICAgICAg
ICBUaGUgY29uZmlndXJlZCBNRVAgaW5zdGFuY2UgbnVtYmVyLg0KPiA+ICAgICAgICAgVGhlIHR5
cGUgaXMgdTMyLg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fTUVQX0NPTkZJR19VTklDQVNUX01B
QzoNCj4gPiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCB1bmljYXN0IE1BQyBhZGRyZXNzLg0K
PiA+ICAgICAgICAgVGhlIHR5cGUgaXMgNip1OCAoYXJyYXkpLg0KPiA+ICAgICAgICAgVGhpcyBp
cyB1c2VkIGFzIFNNQUMgaW4gYWxsIHRyYW5zbWl0dGVkIENGTSBmcmFtZXMuDQo+ID4gICAgIElG
TEFfQlJJREdFX0NGTV9NRVBfQ09ORklHX01ETEVWRUw6DQo+ID4gICAgICAgICBUaGUgY29uZmln
dXJlZCBNRVAgdW5pY2FzdCBNRCBsZXZlbC4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4N
Cj4gPiAgICAgICAgIEl0IG11c3QgYmUgaW4gdGhlIHJhbmdlIDEtNy4NCj4gPiAgICAgICAgIE5v
IENGTSBmcmFtZXMgYXJlIHBhc3NpbmcgdGhyb3VnaCB0aGlzIE1FUCBvbiBsb3dlciBsZXZlbHMu
DQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9NRVBfQ09ORklHX01FUElEOg0KPiA+ICAgICAgICAg
VGhlIGNvbmZpZ3VyZWQgTUVQIElELg0KPiA+ICAgICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiA+
ICAgICAgICAgSXQgbXVzdCBiZSBpbiB0aGUgcmFuZ2UgMC0weDFGRkYuDQo+ID4gICAgICAgICBU
aGlzIE1FUCBJRCBpcyBpbnNlcnRlZCBpbiBhbnkgdHJhbnNtaXR0ZWQgQ0NNIGZyYW1lLg0KPiA+
IA0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ09ORklHX0lOU1RBTkNFOg0KPiA+ICAgICAg
ICAgVGhlIGNvbmZpZ3VyZWQgTUVQIGluc3RhbmNlIG51bWJlci4NCj4gPiAgICAgICAgIFRoZSB0
eXBlIGlzIHUzMi4NCj4gPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJR19FTkFCTEU6DQo+
ID4gICAgICAgICBUaGUgQ29udGludWl0eSBDaGVjayAoQ0MpIGZ1bmN0aW9uYWxpdHkgaXMgZW5h
YmxlZCBvciBkaXNhYmxlZC4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+
ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DT05GSUdfRVhQX0lOVEVSVkFMOg0KPiA+ICAgICAg
ICAgVGhlIENDIGV4cGVjdGVkIHJlY2VpdmUgaW50ZXJ2YWwgb2YgQ0NNIGZyYW1lcy4NCj4gPiAg
ICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYnJfY2ZtX2NjbV9pbnRlcnZhbCkuDQo+ID4gICAgICAg
ICBUaGlzIGlzIGFsc28gdGhlIHRyYW5zbWlzc2lvbiBpbnRlcnZhbCBvZiBDQ00gZnJhbWVzIHdo
ZW4gZW5hYmxlZC4NCj4gPiAgICAgSUZMQV9CUklER0VfQ0ZNX0NDX0NPTkZJR19FWFBfTUFJRDoN
Cj4gPiAgICAgICAgIFRoZSBDQyBleHBlY3RlZCByZWNlaXZlIE1BSUQgaW4gQ0NNIGZyYW1lcy4N
Cj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIENGTV9NQUlEX0xFTkdUSCp1OC4NCj4gPiAgICAgICAg
IFRoaXMgaXMgTUFJRCBpcyBhbHNvIGluc2VydGVkIGluIHRyYW5zbWl0dGVkIENDTSBmcmFtZXMu
DQo+ID4gDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX01FUF9JTlNUQU5DRToNCj4g
PiAgICAgICAgIFRoZSBjb25maWd1cmVkIE1FUCBpbnN0YW5jZSBudW1iZXIuDQo+ID4gICAgICAg
ICBUaGUgdHlwZSBpcyB1MzIuDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19QRUVSX01FUElE
Og0KPiA+ICAgICAgICAgVGhlIENDIFBlZXIgTUVQIElEIGFkZGVkLg0KPiA+ICAgICAgICAgVGhl
IHR5cGUgaXMgdTMyLg0KPiA+ICAgICAgICAgV2hlbiBhIFBlZXIgTUVQIElEIGlzIGFkZGVkIGFu
ZCBDQyBpcyBlbmFibGVkIGl0IGlzIGV4cGVjdGVkIHRvDQo+ID4gICAgICAgICByZWNlaXZlIEND
TSBmcmFtZXMgZnJvbSB0aGF0IFBlZXIgTUVQLg0KPiA+IA0KPiA+ICAgICBJRkxBX0JSSURHRV9D
Rk1fQ0NfUkRJX0lOU1RBTkNFOg0KPiA+ICAgICAgICAgVGhlIGNvbmZpZ3VyZWQgTUVQIGluc3Rh
bmNlIG51bWJlci4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMi4NCj4gPiAgICAgSUZMQV9C
UklER0VfQ0ZNX0NDX1JESV9SREk6DQo+ID4gICAgICAgICBUaGUgUkRJIHRoYXQgaXMgaW5zZXJ0
ZWQgaW4gdHJhbnNtaXR0ZWQgQ0NNIFBEVS4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAo
Ym9vbCkuDQo+ID4gDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhfSU5TVEFOQ0U6
DQo+ID4gICAgICAgICBUaGUgY29uZmlndXJlZCBNRVAgaW5zdGFuY2UgbnVtYmVyLg0KPiA+ICAg
ICAgICAgVGhlIHR5cGUgaXMgdTMyLg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RY
X0RNQUM6DQo+ID4gICAgICAgICBUaGUgdHJhbnNtaXR0ZWQgQ0NNIGZyYW1lIGRlc3RpbmF0aW9u
IE1BQyBhZGRyZXNzLg0KPiA+ICAgICAgICAgVGhlIHR5cGUgaXMgNip1OCAoYXJyYXkpLg0KPiA+
ICAgICAgICAgVGhpcyBpcyB1c2VkIGFzIERNQUMgaW4gYWxsIHRyYW5zbWl0dGVkIENGTSBmcmFt
ZXMuDQo+ID4gICAgIElGTEFfQlJJREdFX0NGTV9DQ19DQ01fVFhfU0VRX05PX1VQREFURToNCj4g
PiAgICAgICAgIFRoZSB0cmFuc21pdHRlZCBDQ00gZnJhbWUgdXBkYXRlIChpbmNyZW1lbnQpIG9m
IHNlcXVlbmNlDQo+ID4gICAgICAgICBudW1iZXIgaXMgZW5hYmxlZCBvciBkaXNhYmxlZC4NCj4g
PiAgICAgICAgIFRoZSB0eXBlIGlzIHUzMiAoYm9vbCkuDQo+ID4gICAgIElGTEFfQlJJREdFX0NG
TV9DQ19DQ01fVFhfUEVSSU9EOg0KPiA+ICAgICAgICAgVGhlIHBlcmlvZCBvZiB0aW1lIHdoZXJl
IENDTSBmcmFtZSBhcmUgdHJhbnNtaXR0ZWQuDQo+ID4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIu
DQo+ID4gICAgICAgICBUaGUgdGltZSBpcyBnaXZlbiBpbiBzZWNvbmRzLiBTRVRMSU5LIElGTEFf
QlJJREdFX0NGTV9DQ19DQ01fVFgNCj4gPiAgICAgICAgIG11c3QgYmUgZG9uZSBiZWZvcmUgdGlt
ZW91dCB0byBrZWVwIHRyYW5zbWlzc2lvbiBhbGl2ZS4NCj4gPiAgICAgICAgIFdoZW4gcGVyaW9k
IGlzIHplcm8gYW55IG9uZ29pbmcgQ0NNIGZyYW1lIHRyYW5zbWlzc2lvbg0KPiA+ICAgICAgICAg
d2lsbCBiZSBzdG9wcGVkLg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYX0lGX1RM
VjoNCj4gPiAgICAgICAgIFRoZSB0cmFuc21pdHRlZCBDQ00gZnJhbWUgdXBkYXRlIHdpdGggSW50
ZXJmYWNlIFN0YXR1cyBUTFYNCj4gPiAgICAgICAgIGlzIGVuYWJsZWQgb3IgZGlzYWJsZWQuDQo+
ID4gICAgICAgICBUaGUgdHlwZSBpcyB1MzIgKGJvb2wpLg0KPiA+ICAgICBJRkxBX0JSSURHRV9D
Rk1fQ0NfQ0NNX1RYX0lGX1RMVl9WQUxVRToNCj4gPiAgICAgICAgIFRoZSB0cmFuc21pdHRlZCBJ
bnRlcmZhY2UgU3RhdHVzIFRMViB2YWx1ZSBmaWVsZC4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlz
IHU4Lg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYX1BPUlRfVExWOg0KPiA+ICAg
ICAgICAgVGhlIHRyYW5zbWl0dGVkIENDTSBmcmFtZSB1cGRhdGUgd2l0aCBQb3J0IFN0YXR1cyBU
TFYgaXMgZW5hYmxlZA0KPiA+ICAgICAgICAgb3IgZGlzYWJsZWQuDQo+ID4gICAgICAgICBUaGUg
dHlwZSBpcyB1MzIgKGJvb2wpLg0KPiA+ICAgICBJRkxBX0JSSURHRV9DRk1fQ0NfQ0NNX1RYX1BP
UlRfVExWX1ZBTFVFOg0KPiA+ICAgICAgICAgVGhlIHRyYW5zbWl0dGVkIFBvcnQgU3RhdHVzIFRM
ViB2YWx1ZSBmaWVsZC4NCj4gPiAgICAgICAgIFRoZSB0eXBlIGlzIHU4Lg0KPiA+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IEhlbnJpayBCam9lcm5sdW5kICA8aGVucmlrLmJqb2Vybmx1bmRAbWljcm9j
aGlwLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogSG9yYXRpdSBWdWx0dXIgIDxob3JhdGl1LnZ1bHR1
ckBtaWNyb2NoaXAuY29tPg0KPiA+IC0tLQ0KPiA+ICBpbmNsdWRlL3VhcGkvbGludXgvaWZfYnJp
ZGdlLmggfCAgIDYgKysNCj4gPiAgbmV0L2JyaWRnZS9icl9jZm1fbmV0bGluay5jICAgIHwgMTYx
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBuZXQvYnJpZGdlL2JyX25l
dGxpbmsuYyAgICAgICAgfCAgMjkgKysrKystDQo+ID4gIG5ldC9icmlkZ2UvYnJfcHJpdmF0ZS5o
ICAgICAgICB8ICAgNiArKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDIwMCBpbnNlcnRpb25zKCsp
LCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiANCj4gQWNrZWQtYnk6IE5pa29sYXkgQWxla3NhbmRy
b3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCj4gDQoNCkkgbWlzc2VkIHRoaXMgdW50aWwgbm93LCBi
dXQgdGhlIGxvY2FsIHZhcmlhYmxlcyBuZWVkIHRvDQpiZSBhcnJhbmdlZCBpbiByZXZlcnNlIHht
YXMgdHJlZSAobG9uZ2VzdCB0byBzaG9ydGVzdCkgaW4gDQpicl9jZm1fY29uZmlnX2ZpbGxfaW5m
bygpLg0KDQoNCg==
