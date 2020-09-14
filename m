Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D156026868C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgINHwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:52:03 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:60466 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgINHvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 03:51:42 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5f21080000>; Mon, 14 Sep 2020 15:51:36 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Mon, 14 Sep 2020 00:51:36 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Mon, 14 Sep 2020 00:51:36 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 14 Sep
 2020 07:51:36 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 14 Sep 2020 07:51:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOxEi2gWDnndROzEZwp1yAPhoIs7zUxi70oBbjRCXzn8vIZBXJvW0+tfH9RRGnjZRQYDXXTdiAUHAhnlQhE9ZUKHgoKkkDqMXh4y1VL8/1+R1sQNMxFgCX9XNGPaN6wcOG/FWmpqA0pIvZ95dujnxPy0vHy1iWgmMDIbfLmGkStyhejKxVfcr1w3QuBLkb4VUjextaL2CIOtuLSIy8wNSJxgmwQT/yd0NfeQlLF3DfZa/0v2esfz05Bs92yowXUJDCEP0TxXrV6katS6GGUEExIonSXuLiCZSLkCXEfpkoJodeviPuSNwaj/XOXiGcJBnE+afayMY9gP/gs9RsDaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ0e4S+Ne5Mq0RpB8Sp6yp/soVHL5Fkvb0f8FmJPPOM=;
 b=JknF99B5i5QjXDDv7SbT+x4/iJqxNtCjf1elOcr5x4tnk7Y+z6AdmcM/wNVnN414h/Zu30USI7PWOFtFiNcrsHfmHYB7LLigGq3yGEaZEopf4JLGGpU3njohjlVvwYYNSSjLvZ6O42geGkCEOaXGItKEcZdw/XI8un0+WPFdPwDX6Mu2YYuiKjQRQmyP+40L0v/gb50AMfaL/T/SpiowQAW0PK6GgvCOYoelO+QGIIYrB1AF+7MkjI3yZ/hghab7+Qk4gxH+NGzNyfCsyXx4+9PJNX3qAecbFQAH0NXRjFWIrf0G3q8d2UNgDbUC7PiOjNF5iw6Povw7lxPACLKRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33)
 by BY5PR12MB4035.namprd12.prod.outlook.com (2603:10b6:a03:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 07:51:33 +0000
Received: from BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b]) by BYAPR12MB2823.namprd12.prod.outlook.com
 ([fe80::7dd0:ad41:3d71:679b%6]) with mapi id 15.20.3348.019; Mon, 14 Sep 2020
 07:51:33 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Thread-Topic: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Thread-Index: AQHWiJGYqt2ABPNtfE6Zj34+KHfdVqlkknWAgADU8ICAAl8wAA==
Date:   Mon, 14 Sep 2020 07:51:33 +0000
Message-ID: <315a6f2a1cec945eb35e69c6fdeaf3c2ab3cb25d.camel@nvidia.com>
References: <20200911231619.2876486-1-olteanv@gmail.com>
         <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
         <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
In-Reply-To: <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d0b0f9f-f37d-4261-27a1-08d85882ffe2
x-ms-traffictypediagnostic: BY5PR12MB4035:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB40359B5DC24F70D7C5C41EF6DF230@BY5PR12MB4035.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lJhqxI4s4CEq8cCqoHS1JBS7pBiXL89OaRNmlQqA8mazS78ZkmbiDCZL2W2KFzKqoJjOmRUY97x8zvOrduS95pr+NzlYE8JWurQh3035YbVV10nw299H0mZiaaSHuuJv43yeCcOpAP06seRQXbTxwyX0vL9vFCCL/+xzoPAcWX+qKn0se/9rtE9zoxHN2v0mAl+7LYXCjwq7husuQMCQdh0U9qlgV7kWcrCIKEbax8/O0rcg7Fm9wyjYnNKxZNN4xlzRVljd5M1SXfYDgsCnlS+SxWCdLcZ5i5LWd7DeWXwaao6aBFqb8+D3pb/Qao/Jn2NWcA5x8azpZarGRebYNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2823.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(66446008)(186003)(54906003)(64756008)(66476007)(4326008)(66946007)(2616005)(91956017)(76116006)(71200400001)(316002)(478600001)(110136005)(86362001)(6486002)(8936002)(66556008)(6512007)(8676002)(53546011)(83380400001)(3450700001)(36756003)(6506007)(2906002)(26005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: a1QAW6PptoncAY4Bg8J3A6hz70nHCPvn1cgIaS+GvmYypqMneLYjd16FVS6HHRJp7iKv8wjS+pDsJ/HhJTfWj+E4DUrLHDfyIg2TLXdy1H05zE/wiPNRkHQyoxe5SSfZlMSzWaU9YxWmSZYzqbcmCzfiB3pVmbYPfzs1r62gVV1F7AnnpXbFqRg3I5n3hZQ8dnyhfaq1CAFWA5klnPfEpxvyWaSSc/nfcPj5zU2RPa/gr+99/3USXoVTAAQxHJcF7VMHUq0FexQXiLFRFCmYKZ2bwSH9+XVAFt5mkqBGBFm0yod32aynQhM0PuSbENB9FdJstXaEvcmqkaVUfANjxaYs5dRQWeEgqiqv/2nAS1MseQq2bwnti84MfFh4FXlennP/62hBbmKMTkAIpEdaWtqibP2SbDT/QCjzFR3Bh/Ffjj7iWxJoChsMhHLQeMSnn5BcAWiNkbPzIkoa59JRZt/OTEt+6qISRwcbbKUc6Q13jActqmTUsrDEkWYL5G0bMdoAMPWIWGv29Dle54JzFlvCmrnthIq2kxCTClDXlk95ucwM+Mc0ro76RbLqtTFECKzxnBWobIPjVcKBbLm1ixhsSQSiitZVekIBbH/BKhskCijemOVYngc96DwDCpuDk2tdTw4SyalLQYIFcxen0g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F7AF25F2B09294CB887A7633DC604D3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2823.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0b0f9f-f37d-4261-27a1-08d85882ffe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 07:51:33.3200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IMtDRi4+OLrBCnZ42tILfk9EgPJSSRn+D+1qT7TjY+uQKn406ioiHu5YMZxocbfPp04k+Z53vOZji9rncYqMJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4035
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600069896; bh=mQ0e4S+Ne5Mq0RpB8Sp6yp/soVHL5Fkvb0f8FmJPPOM=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
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
        b=O9HO4m/ofiqB698qgk/1g7lGjoU3SLu4yH1ybr++8ehtN/1vJsCuX8mhCzp8+hs32
         nZicRahR+9nztcZHV5kzzGrcFZmaauYRg5y5vohfuTy9pwEvTK6gUzp0ZJcJG2oZll
         lIymyfgHu/dn66/pP/c4uQWFacvhrVI63TllMA7Hptnhnh66jTqoVjey35P/CUelxn
         dgt0Jjn4gLGHHyVvzE/IHklgE1Pwhj/S0yPNYVs7lQ1OeIx4JXX1JND82o9oT3xwZk
         BhNTTlxCjmw3hBgtgXCHxIcNfXHyzL9FP42KJgJAfeTB1QuOIyN9lrCpOwS1MLDuho
         Gk3dd2OMqptEg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTA5LTEyIGF0IDEyOjM4IC0wNzAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiANCj4gT24gOS8xMS8yMDIwIDExOjU2IFBNLCBOaWtvbGF5IEFsZWtzYW5kcm92IHdyb3Rl
Og0KPiA+IE9uIFNhdCwgMjAyMC0wOS0xMiBhdCAwMjoxNiArMDMwMCwgVmxhZGltaXIgT2x0ZWFu
IHdyb3RlOg0KPiA+ID4gQ3VycmVudGx5IHRoZSBicmlkZ2UgdW50YWdzIFZMQU5zIGZyb20gaXRz
IFZMQU4gZ3JvdXAgaW4NCj4gPiA+IF9fYWxsb3dlZF9pbmdyZXNzKCkgb25seSB3aGVuIFZMQU4g
ZmlsdGVyaW5nIGlzIGVuYWJsZWQuDQo+ID4gPiANCj4gPiA+IFdoZW4gaW5zdGFsbGluZyBhIHB2
aWQgaW4gZWdyZXNzLXRhZ2dlZCBtb2RlLCBEU0Egc3dpdGNoZXMgaGF2ZSBhDQo+ID4gPiBwcm9i
bGVtOg0KPiA+ID4gDQo+ID4gPiBpcCBsaW5rIGFkZCBkZXYgYnIwIHR5cGUgYnJpZGdlIHZsYW5f
ZmlsdGVyaW5nIDANCj4gPiA+IGlwIGxpbmsgc2V0IHN3cDAgbWFzdGVyIGJyMA0KPiA+ID4gYnJp
ZGdlIHZsYW4gZGVsIGRldiBzd3AwIHZpZCAxDQo+ID4gPiBicmlkZ2UgdmxhbiBhZGQgZGV2IHN3
cDAgdmlkIDEgcHZpZA0KPiA+ID4gDQo+ID4gPiBXaGVuIGFkZGluZyBhIFZMQU4gb24gYSBEU0Eg
c3dpdGNoIGludGVyZmFjZSwgRFNBIGNvbmZpZ3VyZXMgdGhlIFZMQU4NCj4gPiA+IG1lbWJlcnNo
aXAgb2YgdGhlIENQVSBwb3J0IHVzaW5nIHRoZSBzYW1lIGZsYWdzIGFzIHN3cDAgKGluIHRoaXMg
Y2FzZQ0KPiA+ID4gInB2aWQgYW5kIG5vdCB1bnRhZ2dlZCIpLCBpbiBhbiBhdHRlbXB0IHRvIGNv
cHkgdGhlIGZyYW1lIGFzLWlzIGZyb20NCj4gPiA+IGluZ3Jlc3MgdG8gdGhlIENQVS4NCj4gPiA+
IA0KPiA+ID4gSG93ZXZlciwgaW4gdGhpcyBjYXNlLCB0aGUgcGFja2V0IG1heSBhcnJpdmUgdW50
YWdnZWQgb24gaW5ncmVzcywgaXQNCj4gPiA+IHdpbGwgYmUgcHZpZC10YWdnZWQgYnkgdGhlIGlu
Z3Jlc3MgcG9ydCwgYW5kIHdpbGwgYmUgc2VudCBhcw0KPiA+ID4gZWdyZXNzLXRhZ2dlZCB0b3dh
cmRzIHRoZSBDUFUuIE90aGVyd2lzZSBzdGF0ZWQsIHRoZSBDUFUgd2lsbCBzZWUgYSBWTEFODQo+
ID4gPiB0YWcgd2hlcmUgdGhlcmUgd2FzIG5vbmUgdG8gc3BlYWsgb2Ygb24gaW5ncmVzcy4NCj4g
PiA+IA0KPiA+ID4gV2hlbiB2bGFuX2ZpbHRlcmluZyBpcyAxLCB0aGlzIGlzIG5vdCBhIHByb2Js
ZW0sIGFzIHN0YXRlZCBpbiB0aGUgZmlyc3QNCj4gPiA+IHBhcmFncmFwaCwgYmVjYXVzZSBfX2Fs
bG93ZWRfaW5ncmVzcygpIHdpbGwgcG9wIGl0LiBCdXQgY3VycmVudGx5LCB3aGVuDQo+ID4gPiB2
bGFuX2ZpbHRlcmluZyBpcyAwIGFuZCB3ZSBoYXZlIHN1Y2ggYSBWTEFOIGNvbmZpZ3VyYXRpb24s
IHdlIG5lZWQgYW4NCj4gPiA+IDgwMjFxIHVwcGVyIChicjAuMSkgdG8gYmUgYWJsZSB0byBwaW5n
IG92ZXIgdGhhdCBWTEFOLg0KPiA+ID4gDQo+ID4gPiBNYWtlIHRoZSAyIGNhc2VzICh2bGFuX2Zp
bHRlcmluZyAwIGFuZCAxKSBiZWhhdmUgdGhlIHNhbWUgd2F5IGJ5IHBvcHBpbmcNCj4gPiA+IHRo
ZSBwdmlkLCBpZiB0aGUgc2tiIGhhcHBlbnMgdG8gYmUgdGFnZ2VkIHdpdGggaXQsIHdoZW4gdmxh
bl9maWx0ZXJpbmcNCj4gPiA+IGlzIDAuDQo+ID4gPiANCj4gPiA+IFRoZXJlIHdhcyBhbiBhdHRl
bXB0IHRvIHJlc29sdmUgdGhpcyBpc3N1ZSBsb2NhbGx5IHdpdGhpbiB0aGUgRFNBDQo+ID4gPiBy
ZWNlaXZlIGRhdGEgcGF0aCwgYnV0IGV2ZW4gdGhvdWdoIHdlIGNhbiBkZXRlcm1pbmUgdGhhdCB3
ZSBhcmUgdW5kZXIgYQ0KPiA+ID4gYnJpZGdlIHdpdGggdmxhbl9maWx0ZXJpbmc9MCwgdGhlcmUg
YXJlIHN0aWxsIHNvbWUgY2hhbGxlbmdlczoNCj4gPiA+IC0gd2UgY2Fubm90IGJlIGNlcnRhaW4g
dGhhdCB0aGUgc2tiIHdpbGwgZW5kIHVwIGluIHRoZSBzb2Z0d2FyZSBicmlkZ2Uncw0KPiA+ID4g
ICAgZGF0YSBwYXRoLCBhbmQgZm9yIHRoYXQgcmVhc29uLCB3ZSBtYXkgYmUgcG9wcGluZyB0aGUg
VkxBTiBmb3INCj4gPiA+ICAgIG5vdGhpbmcuIEV4YW1wbGU6IHRoZXJlIG1pZ2h0IGV4aXN0IGFu
IDgwMjFxIHVwcGVyIHdpdGggdGhlIHNhbWUgVkxBTiwNCj4gPiA+ICAgIG9yIHRoaXMgaW50ZXJm
YWNlIG1pZ2h0IGJlIGEgRFNBIG1hc3RlciBmb3IgYW5vdGhlciBzd2l0Y2guIEluIHRoYXQNCj4g
PiA+ICAgIGNhc2UsIHRoZSBWTEFOIHNob3VsZCBkZWZpbml0ZWx5IG5vdCBiZSBwb3BwZWQgZXZl
biBpZiBpdCBpcyBlcXVhbCB0bw0KPiA+ID4gICAgdGhlIGRlZmF1bHRfcHZpZCBvZiB0aGUgYnJp
ZGdlLCBiZWNhdXNlIGl0IHdpbGwgYmUgY29uc3VtZWQgYWJvdXQgdGhlDQo+ID4gPiAgICBEU0Eg
bGF5ZXIgYmVsb3cuDQo+ID4gDQo+ID4gQ291bGQgeW91IHBvaW50IG1lIHRvIGEgdGhyZWFkIHdo
ZXJlIHRoZXNlIHByb2JsZW1zIHdlcmUgZGlzY3Vzc2VkIGFuZCB3aHkNCj4gPiB0aGV5IGNvdWxk
bid0IGJlIHJlc29sdmVkIHdpdGhpbiBEU0EgaW4gZGV0YWlsID8NCj4gPiANCj4gPiA+IC0gdGhl
IGJyaWRnZSBBUEkgb25seSBvZmZlcnMgYSByYWNlLWZyZWUgQVBJIGZvciBkZXRlcm1pbmluZyB0
aGUgcHZpZCBvZg0KPiA+ID4gICAgYSBwb3J0LCBicl92bGFuX2dldF9wdmlkKCksIHVuZGVyIFJU
TkwuDQo+ID4gPiANCj4gPiANCj4gPiBUaGUgQVBJIGNhbiBiZSBlYXNpbHkgZXh0ZW5kZWQuDQo+
ID4gDQo+ID4gPiBBbmQgaW4gZmFjdCB0aGlzIG1pZ2h0IG5vdCBldmVuIGJlIGEgc2l0dWF0aW9u
IHVuaXF1ZSB0byBEU0EuIEFueSBkcml2ZXINCj4gPiA+IHRoYXQgcmVjZWl2ZXMgdW50YWdnZWQg
ZnJhbWVzIGFzIHB2aWQtdGFnZ2VkIGlzIG5vdyBhYmxlIHRvIGNvbW11bmljYXRlDQo+ID4gPiB3
aXRob3V0IG5lZWRpbmcgYW4gODAyMXEgdXBwZXIgZm9yIHRoZSBwdmlkLg0KPiA+ID4gDQo+ID4g
DQo+ID4gSSB3b3VsZCBwcmVmZXIgd2UgZG9uJ3QgYWRkIGhhcmR3YXJlL2RyaXZlci1zcGVjaWZp
YyBmaXhlcyBpbiB0aGUgYnJpZGdlLCB3aGVuDQo+ID4gdmxhbiBmaWx0ZXJpbmcgaXMgZGlzYWJs
ZWQgdGhlcmUgc2hvdWxkIGJlIG5vIHZsYW4gbWFuaXB1bGF0aW9uL2ZpbHRlcmluZyBkb25lDQo+
ID4gYnkgdGhlIGJyaWRnZS4gVGhpcyBjb3VsZCBwb3RlbnRpYWxseSBicmVhayB1c2VycyB3aG8g
aGF2ZSBhZGRlZCA4MDIxcSBkZXZpY2VzDQo+ID4gYXMgYnJpZGdlIHBvcnRzLiBBdCB0aGUgdmVy
eSBsZWFzdCB0aGlzIG5lZWRzIHRvIGJlIGhpZGRlbiBiZWhpbmQgYSBuZXcgb3B0aW9uLA0KPiA+
IGJ1dCBJIHdvdWxkIGxpa2UgdG8gZmluZCBhIHdheSB0byBhY3R1YWxseSBwdXNoIGl0IGJhY2sg
dG8gRFNBLiBCdXQgYWdhaW4gYWRkaW5nDQo+ID4gaGFyZHdhcmUvZHJpdmVyLXNwZWNpZmljIG9w
dGlvbnMgc2hvdWxkIGJlIGF2b2lkZWQuDQo+ID4gDQo+ID4gQ2FuIHlvdSB1c2UgdGMgdG8gcG9w
IHRoZSB2bGFuIG9uIGluZ3Jlc3MgPyBJIG1lYW4gdGhlIGNhc2VzIGFib3ZlIGFyZSB2aXNpYmxl
DQo+ID4gdG8gdGhlIHVzZXIsIHNvIHRoZXkgbWlnaHQgZGVjaWRlIHRvIGFkZCB0aGUgaW5ncmVz
cyB2bGFuIHJ1bGUuDQo+IA0KPiBXZSBoYWQgZGlzY3Vzc2VkIHZhcmlvdXMgb3B0aW9ucyB3aXRo
IFZsYWRpbWlyIGluIHRoZSB0aHJlYWRzIGhlIHBvaW50cyANCj4gb3V0IGJ1dCB0aGlzIG9uZSBp
cyBieSBmYXIgdGhlIGNsZWFuZXN0IGFuZCBiYXNpY2FsbHkgYWxpZ25zIHRoZSBkYXRhIA0KPiBw
YXRoIHdoZW4gdGhlIGJyaWRnZSBpcyBjb25maWd1cmVkIHdpdGggdmxhbl9maWx0ZXJpbmc9MCBv
ciAxLg0KPiANCj4gU29tZSBFdGhlcm5ldCBzd2l0Y2hlcyBzdXBwb3J0ZWQgdmlhIERTQSBlaXRo
ZXIgaW5zaXN0IG9uIG9yIHRoZSBkcml2ZXIgDQo+IGhhcyBiZWVuIHdyaXR0ZW4gaW4gc3VjaCBh
IHdheSB0aGF0IHRoZSBkZWZhdWx0X3B2aWQgb2YgdGhlIGJyaWRnZSB3aGljaCANCj4gaXMgZWdy
ZXNzIHVudGFnZ2VkIGZvciB0aGUgdXNlci1mYWNpbmcgcG9ydHMgaXMgY29uZmlndXJlZCBhcyBl
Z3Jlc3MgDQo+IHRhZ2dlZCBmb3IgdGhlIENQVSBwb3J0LiBUaGF0IENQVSBwb3J0IGlzIHVsdGlt
YXRlbHkgcmVzcG9uc2libGUgZm9yIA0KPiBicmluZ2luZyB0aGUgRXRoZXJuZXQgZnJhbWVzIGlu
dG8gdGhlIExpbnV4IGhvc3QgYW5kIHRoZSBicmlkZ2UgZGF0YSANCj4gcGF0aCB3aGljaCBpcyBo
b3cgd2UgZ290IFZMQU4gdGFnZ2VkIGZyYW1lcyBpbnRvIHRoZSBicmlkZ2UsIGV2ZW4gaWYgYSAN
Cj4gdmxhbl9maWx0ZXJpbmc9MCBicmlkZ2UgaXMgbm90IHN1cHBvc2VkIHRvLg0KPiANCg0KSSBy
ZWFkIHRoZSB0aHJlYWQgYW5kIHNlZSB5b3VyIHByb2JsZW0sIGJ1dCBJIHN0aWxsIHRoaW5rIHRo
YXQgaXQgbXVzdCBub3QgYmUNCmZpeGVkIGluIHRoZSBicmlkZ2UgZGV2aWNlLCBtb3JlIGJlbG93
Lg0KDQo+IFdlIGNhbiBzb2x2ZSB0aGlzIHRvZGF5IGJ5IGhhdmluZyBhIDgwMi4xUSB1cHBlciBv
biB0b3Agb2YgdGhlIGJyaWRnZSANCj4gZGVmYXVsdCB0byBwb3AvcHVzaCB0aGUgZGVmYXVsdF9w
dmlkIFZMQU4gdGFnLCBidXQgdGhpcyBpcyBub3Qgb2J2aW91cywgDQo+IHJlcHJlc2VudHMgYSBk
aXZlcmdlbmNlIGZyb20gYSBwdXJlIHNvZnR3YXJlIGJyaWRnZSwgYW5kIGxlYWRzIHRvIA0KPiBz
dXBwb3J0IHF1ZXN0aW9ucy4gV2hhdCBpcyBhbHNvIHV0dGVybHkgY29uZnVzaW5nIGZvciBpbnN0
YW5jZSBpcyB0aGF0IGEgDQo+IHJhdyBzb2NrZXQgbGlrZSBvbmUgb3BlbmVkIGJ5IGEgREhDUCBj
bGllbnQgd2lsbCBzdWNjZXNzZnVsbHkgYWxsb3cgYnIwIA0KPiB0byBvYnRhaW4gYW4gSVAgYWRk
cmVzcywgYnV0IHRoZSBkYXRhIHBhdGggc3RpbGwgaXMgbm90IGZ1bmN0aW9uYWwsIGFzIA0KPiB5
b3Ugd291bGQgbmVlZCB0byB1c2UgYnIwLjEgdG8gaGF2ZSBhIHdvcmtpbmcgZGF0YSBwYXRoIHRh
a2luZyBjYXJlIG9mIA0KPiB0aGUgVkxBTiB0YWcuDQo+IA0KDQpXaXRoIHRoaXMgcGF0Y2ggYnIw
LjEgd29uJ3Qgd29yayBhbnltb3JlIGZvciBhbnlvbmUgaGF2aW5nIHZsYW5fZmlsdGVyaW5nPTAu
DQoNCj4gVmxhZGltaXIgaGFkIG9mZmVyZWQgYSBEU0EgY2VudHJpYyBzb2x1dGlvbiB0byB0aGlz
IHByb2JsZW0sIHdoaWNoIHdhcyANCj4gbm90IHRoYXQgYmFkIGFmdGVyIGFsbCwgYnV0IHRoaXMg
b25lIGlzIGFsc28gbXkgZmF2b3JpdGUuDQo+IA0KDQpJIHNhdyBpdCwgYW5kIGl0IGxvb2tzIGdv
b2QuIEkgc2F3IHRoZSBvbmUgb2YgdGhlIG1haW4gaXNzdWVzIGlzIG5vdCBoYXZpbmcgYW4NClJD
VSBnZXQgcHZpZCBoZWxwZXIuIEkgY2FuIHByb3ZpZGUgeW91IHdpdGggdGhhdCB0byBzaW1wbGlm
eSB0aGUgcGF0Y2guDQoNCj4gTGV0IHVzIGtub3cgd2hlbiB5b3UgYXJlIGNhdWdodCB1cCBvbiB0
aGUgdGhyZWFkIGFuZCB3ZSBjYW4gc2VlIGhvdyB0byANCj4gc29sdmUgdGhhdCB0aGUgYmVzdCB3
YXkuDQoNCkknbGwgc3RhcnQgd2l0aCB3aHkgdGhpcyBwYXRjaCBpcyBhIG5vbi1zdGFydGVyLCBJ
J20gZ3Vlc3NpbmcgbW9zdCBvZiB1cyBhbHJlYWR5DQpoYXZlIGd1ZXNzZWQsIGJ1dCBqdXN0IHRv
IGhhdmUgdGhlbToNCiAtIHRoZSBmaXggaXMgRFNBLXNwZWNpZmljLCBpdCBtdXN0IG5vdCByZXNp
ZGUgaW4gdGhlIGJyaWRnZQ0KIC0gdmxhbl9maWx0ZXJpbmc9MCBtZWFucyBhYnNvbHV0ZWx5IG5v
IHZsYW4gcHJvY2Vzc2luZywgdGhhdCBpcyB3aGF0IGV2ZXJ5b25lDQogICBleHBlY3RzIGFuZCBi
cmVha2luZyB0aGF0IGV4cGVjdGF0aW9uIHdvdWxkIGJyZWFrIHZhcmlvdXMgdXNlIGNhc2VzDQoN
Ckxlc3MgaW1wb3J0YW50LCBidXQgc3RpbGw6DQogLSBpdCBpcyBpbiB0aGUgZmFzdCBwYXRoIGZv
ciBldmVyeW9uZQ0KIC0gaXQgY2FuIGFscmVhZHkgYmUgZml4ZWQgYnkgYSB0YyBhY3Rpb24vODAy
MXEgZGV2aWNlDQoNCldlIGNhbiBnbyBpbnRvIGRldGFpbHMgYnV0IHRoYXQgd291bGQgYmUgYSB3
YXN0ZSBvZiB0aW1lLCBpbnN0ZWFkIEkgdGhpbmsgd2UNCnNob3VsZCBmb2N1cyBvbiBWbGFkaW1p
cidzIHByb3Bvc2VkIERTQSBjaGFuZ2UuDQoNClZsYWRpbWlyLCBJIHRoaW5rIHdpdGggdGhlIHJp
Z2h0IHB2aWQgaGVscGVyIHRoZSBwYXRjaCB3b3VsZCByZWR1Y2UgdG8NCmRzYV91bnRhZ19icmlk
Z2VfcHZpZCgpIG9uIHRoZSBSeCBwYXRoIG9ubHkuIE9uZSB0aGluZyB0aGF0IEknbSBjdXJpb3Vz
IGFib3V0DQppcyBzaG91bGRuJ3QgZHNhX3VudGFnX2JyaWRnZV9wdmlkKCkgY2hlY2sgaWYgdGhl
IGJyaWRnZSBwdmlkIGlzID09IHRvIHRoZSBza2INCnRhZyBhbmQgdGhlIHBvcnQncyBwdmlkPw0K
U2luY2Ugd2UgY2FuIGhhdmUgdGhlIHBvcnQncyBwdmlkIGRpZmZlcmVudCBmcm9tIHRoZSBicmlk
Z2Uncy4gVGhhdCdzIGZvciB0aGUNCmNhc2Ugb2Ygdmxhbl9maWx0ZXJpbmc9MSBhbmQgdGhlIHBv
cnQgaGF2aW5nIHRoYXQgdmxhbiwgYnV0IG5vdCBhcyBwdmlkLg0KDQpUaGFua3MsDQogTmlrDQoN
Cg==
