Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C592FFB1A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAVDcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:32:00 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8153 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbhAVDbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 22:31:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600a46fe0000>; Thu, 21 Jan 2021 19:31:10 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Jan
 2021 03:31:03 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 22 Jan 2021 03:31:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFqNF/SY2f9rrqWaJxSCh6YHodwFL5+khvh5f+XSaNclYeZseB25SsI642Gd9D2V2Pf7OrwXDPs3KvSTWgjOGXAcJyk0uuFpUCpaoNe4bCbrk9dJFV32Uuk0i56jW90GRAu3khCJK7qvMXv38LUiAKDLEgm/fckciGVdntfXubjfqebFDOzQnUH4CQftrc8ww25xEsgVGW2eVi1J5CoroCi5jiYGMvtCcHYEoy0kImKwhKaRHklL17mtuVfsr0yTeO6HsHa6VpffvoKSaO+CllMjBv9M4HkjL/Gdo4hsR0G5YGPLF6T9GTvoORVsinE0QriE3sDuk62cnHfxHDE8Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbcNu8J7uNyJzQ40Z007A7+8u1u3QjpjhejCmnahKHQ=;
 b=kZ4KsJm+9jmvuNYmaHfRlhIwl+9IN4yxePJxpjS26vzuPH9IjHGwcnmnqJUfxehHQ+nU+RsJ8KGipAyODlm7l2Axnz2nqBuSlVQq5ADHu1H8gW+29Qo2aXVL3v9wZVXDFK3vRXH/5ireqgEgQjqMT+5q8HSEJLxv+rb35CRSchAQu0FzfNVFrW7HEnv1sMSpzEXAiV56sgOvaaMc5/dC+R8uG7POSdv2SmNCX0ouFTXWMbEVDwTamp4vcz9F77ejPb8lAWYKpX1qfXkHzHRrHRxJq0Vz0x9Fle9TEcOnuNo9LtUVNUyaEBlJD9LCKRiE7SGJWujXzepV22KtlyIHxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3109.namprd12.prod.outlook.com (2603:10b6:a03:db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 03:31:02 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 03:31:01 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "edwin.peer@broadcom.com" <edwin.peer@broadcom.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next V9 03/14] devlink: Support add and delete devlink port
Thread-Topic: [net-next V9 03/14] devlink: Support add and delete devlink port
Thread-Index: AQHW79LmFPbaZ1yIqE6Dn8XBxqVDLKoyjoYAgABuIeA=
Date:   Fri, 22 Jan 2021 03:31:01 +0000
Message-ID: <BY5PR12MB4322C9132AFAF14E00E7B447DCA09@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-4-saeed@kernel.org>
 <0a51e4e2-97f2-a5bc-c9b4-7589882d69d6@intel.com>
In-Reply-To: <0a51e4e2-97f2-a5bc-c9b4-7589882d69d6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 028241f9-34d5-46f4-2a0a-08d8be862473
x-ms-traffictypediagnostic: BYAPR12MB3109:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3109AB71325FA41BD1466A3ADCA09@BYAPR12MB3109.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8fmh8r/FJDloB+SGXBuw4YNEHfJUAKGzrs8mFhikSu1zeFKspSm9h5MMXnqndOADB5yKXGy9BovrU5+rbXW0QNror/HMvSu7HtCQItKQ3CzgySxlElq9Pe04ZGx8rqqk1hHtXAgld7U20xeJ94kDJKnNM+7VnMmf62BN5fvVfLc1ms5yVtCcG3xa5v0Xlp4lfNLpTLLyT3zmZ9NYKRRyRBu4i1NF2v8zlStaGYDrw1dJOv+B2nEIa9Xaj5Oiq8+EQ/noMcEtSdlSASkeb3ekyS+hxq5pvVPkjX80HetUfkYyI1RClIpk2m2w3Sjq3d3LFRXTp+45KQaN8XgzJFScX2rGFi3ZTUjYd2ZlKyhzIq5CIgoXh+eDf7/AxNPMPFIq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(64756008)(76116006)(186003)(4326008)(86362001)(66946007)(6636002)(33656002)(55016002)(8936002)(4744005)(7416002)(71200400001)(5660300002)(8676002)(7696005)(478600001)(2906002)(52536014)(66476007)(66556008)(54906003)(6506007)(66446008)(316002)(110136005)(26005)(107886003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZG1iSlZkUTcwR2hpWVM5dW14MEE1eWpIM1N6TVMyM2F1aXlZOXFGOXdoMGxH?=
 =?utf-8?B?ZW5lU1dyRGtlVVN4YTFIS3pLMG5YTjV4QlJ6YTNHQ0xad3dWcHd5Um1wSlJC?=
 =?utf-8?B?SG4rR2tMME1BRDhhQys1QW9hNGoyYTlqVThBdGZCVUtNazFycFM3V2dzUG0y?=
 =?utf-8?B?TEQ5N3lLd09VQ2Z2RncvSVl4SDB6UU8za2NXNUx3eXhpTEdRTGd1WitFejZG?=
 =?utf-8?B?azNuQjlqWWJ0a2ttWHRmMHBkbkVLTGRPd3ZyY1A1a3pTKzJoWjlOTTkrR29n?=
 =?utf-8?B?bllqMW1iNWNlSFphaXIzWlV1V0ZndGVJMmRHSjBtdnlsdi9Pem9JWEdXWVR4?=
 =?utf-8?B?YUpvQ2h4NjlIQ0FHM25JVE9FNUxvTEpnWXlOMFFVdFFib2h6eVQxTFZTVkxl?=
 =?utf-8?B?WHRRWGwzUk93d2VwZzllMGRVamxWL2szUnphdE40MHY1eEVRMDJHb0dzZ1Ez?=
 =?utf-8?B?WkQ1ZFdCNmJ4N1owZHdldGNMKzZKUzkxMFFGN2NxZzArNXdmMTJpTTRHR2E5?=
 =?utf-8?B?M3l6c3lrNVVHMTFkSWc5a2tZTjRxZGpOMit2ZWhEMlhhUlBaSm40aEFIT0dY?=
 =?utf-8?B?S2xXTW5BeXVkUVBYVjkySFJjZzgvT0dMaUpLQXpGS3I1eXEraXRlZ0NFMzh6?=
 =?utf-8?B?OG15YllIWC96RHRyU1E5N2prNUtzUUJ6ajZMdjFNS2kyWGljbi81QllvRDNj?=
 =?utf-8?B?RTFOSVpQcFY5ZHVmRTljRk9pWG5LTUd1QXJFMXlRYlY4aGt6bWFVUjdyVEcv?=
 =?utf-8?B?VUNqZlhkQjkvQmRjS0QxaDQ5VVd4ZEdmenNubUVsRnRoMVFUbk10eXh0cEVD?=
 =?utf-8?B?VGlhSHFhWVNzMnVtcUFYeWVIeVB0ajZNNVYxRGlrVkRUSXJBZ0tPRndwVmxI?=
 =?utf-8?B?QmNrbW9DRG5IamIzNVc3dThhNG8wT0FYSVgwOWppRXNjenc0VkhhV2laQ1RL?=
 =?utf-8?B?dmtFdnBEZmEvSy9XbHg0SUlrcS9kSVJieEZHeW5KNFRJZmR6V0NkblNmdUxo?=
 =?utf-8?B?ZVdTQlFsaUYyWWNMc01NMm14NFV4UVh1R0NSaVlCS01Jajl3UXhWR2x5SFV3?=
 =?utf-8?B?WTA3Q1NRTGFnNi9xUlErZXdSd2VZTGlvM0RjNTdxVEQ5d3BPaDFzZGdsZG50?=
 =?utf-8?B?K2gxQmRER2ZnbkpveFEyQitySE5CSnJONkJjUmVyemtsZW15SjV1RXNibFBl?=
 =?utf-8?B?Q09jUm1udXNqbzdURWQ5a1o3Wmh5L25JQWp0NUNhd2dGK0VTK2lOSkRvTGs1?=
 =?utf-8?B?VGttd2J6aExYRTBhaEwwZjUyek82NDludHdPZG1iZHJQM1ZNSzNLYmwrdnJi?=
 =?utf-8?Q?UqXTBy8yvS1Ts=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028241f9-34d5-46f4-2a0a-08d8be862473
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 03:31:01.7953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M3HuDjefwZllW8oxWytv9xwiVW92ouIrNHn1Qs2kI2HHBah6zpInwwGULF580L0OT48KXzhueKoPPZMxZnCodQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3109
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611286270; bh=fbcNu8J7uNyJzQ40Z007A7+8u1u3QjpjhejCmnahKHQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=phCZ9Nm/hwsvvJ/q7pqJTnGpCTo5OGAyCsifn0KhPvmxAW18YG8sYTPelgl1j3riv
         EJwCdUK9gXRNxGbsRBCitBR96ZojMC9RfOMJq+aPIdNCMAhU9YlgMPv/7VREDVxQJ7
         HVO6baBYSuH4EavuWTswSLS5TCg95Yt+lv8wE/4csFSCNhOh3olVLJSpXmKrdlB8er
         A3M58H+kKX7x7D0CS/ZyuPYvTUrQ7oQfoGOGIvNDxN8OLmi5kArhLHlwB1cVzqvy5H
         iYNfxdscarqKIJ8pyig57j7T1ffUtf+Pi/GaD8JkfTssFcPUhcazPj41Wzbsuj5JrC
         92CbTR9Qw7e+g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU2FtdWRyYWxhLCBTcmlkaGFyIDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5j
b20+DQo+IFNlbnQ6IEZyaWRheSwgSmFudWFyeSAyMiwgMjAyMSAyOjIxIEFNDQo+IA0KPiA+ICQg
ZGV2bGluayBwb3J0IHNob3cNCj4gPiBwY2kvMDAwMDowNjowMC4wLzY1NTM1OiB0eXBlIGV0aCBu
ZXRkZXYgZW5zMmYwbnAwIGZsYXZvdXIgcGh5c2ljYWwNCj4gPiBwb3J0IDAgc3BsaXR0YWJsZSBm
YWxzZQ0KPiA+DQo+ID4gJCBkZXZsaW5rIHBvcnQgYWRkIHBjaS8wMDAwOjA2OjAwLjAgZmxhdm91
ciBwY2lzZiBwZm51bSAwIHNmbnVtIDg4DQo+IA0KPiBEbyB3ZSBuZWVkIHRvIHNwZWNpZnkgcGZu
dW0gd2hlbiBhZGRpbmcgYSBTRiBwb3J0PyBJc24ndCB0aGlzIHJlZHVuZGFudD8NCj4gSXNuJ3Qg
dGhlcmUgYSAxOjEgbWFwcGluZyBiZXR3ZWVuIHRoZSBwY2kgZGV2aWNlIGFuZCBhIHBmbnVtPw0K
Pg0KTm8uIGl0J3Mgbm90IGVudGlyZWx5IHJlZHVuZGFudC4NCkN1cnJlbnRseSBpbiBtb3N0IGNh
c2VzIHRvZGF5IGl0IGlzIHNhbWUgZnVuY3Rpb24gbnVtYmVyIGFzIHRoYXQgb2YgUENJIGRldmlj
ZS4NCk5ldHJvbm9tZSBoYXMgb25lIGRldmxpbmsgaW5zdGFuY2UgdGhhdCByZXByZXNlbnRzIG11
bHRpcGxlIFBDSSBkZXZpY2VzLg0KU29tZWRheSBtbHg1IGRyaXZlciBtaWdodCBoYXZlIGl0IHRv
byBmb3IgdGhlIHNpbmdsZSBlc3dpdGNoIGluc3RhbmNlIGFtb25nIG11bHRpcGxlIFBDSSBkZXZp
Y2VzIG9mIG9uZSBwaHlzaWNhbCBjYXJkLg0KU28gaXQgaXMgbmVlZGVkIHRvIHNwZWNpZnkuDQo=
