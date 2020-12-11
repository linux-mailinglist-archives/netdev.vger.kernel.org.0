Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B512D71D8
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403850AbgLKIei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:34:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18992 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390913AbgLKIeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:34:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd32ef40000>; Fri, 11 Dec 2020 00:33:56 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Dec
 2020 08:33:55 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 11 Dec 2020 08:33:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8PoCG5hyCeg1DhH9OuYtyxAKTiC1ClPketeOu/PEVortj/1FcBgBWUncGKYa+ScKVGEcPcbY49Gm2SYAItFz5D6O7M7q+yvu1cW3EEZS+2uPbxafZEYdB3FDNieVUoy/ztgZVZaxwFcQe0xwZwK0mbu1Bc1Eh4z1pjforkxzCgSFzcDsoypCQ8CCiLeldcwgB1ZsbePzwJdrJazPL5fvDSf3YmJuJ2Nio2TH6POQVG+wB/GdiypwFFRl58FO1Fzd93rETKSSZXeXOOmkT7UJ7tRs6swtyZWWMlovXKD5+csLdIKohnjngxHSVrwhUbwqoAqKENHgaAT4DtQCrZp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FficEJeDcNZm/WrbY8pHRdiNQM5Uj4/v/OT5hkXf8ho=;
 b=IdItipN+wZSxaEmSnpxLTZEF5uYBdiin4YhEoNj0SyQVHqI1Xv1KmQVPHkfkYLEM+MLIIeJ0ZRb9hN2cMmaGyT0xgPTvfNpHIroSuw/f92hLX+eQ8SA4OvKU+NuP3CfNiKmNlmpu8YMjuMbyZJodF7Q66tpY70zNV+p8FC5rf+DafBZh8qwhNtrOqgtmlOmVI0fKH/MQ2W6J/dmGlExt6sB+AzwbyDYFsqF+hnFHknmqY9e4m/vnzhBYONYP2Lh+MMaadBYOqxDILqkPNgqPqbWmVAGNyOxVi6k8qj2n89uiPgiVElphsa+l2U1/hMPj5Fi25aEAcBFcWA6i8to3/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3109.namprd12.prod.outlook.com (2603:10b6:a03:db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Fri, 11 Dec
 2020 08:33:54 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Fri, 11 Dec 2020
 08:33:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH net-next v2 00/14] Add mlx5 subfunction support
Thread-Topic: [PATCH net-next v2 00/14] Add mlx5 subfunction support
Thread-Index: AQHWzf0tody2GAURz0CRxnF+rxS0sKnxS3sAgABCC0A=
Date:   Fri, 11 Dec 2020 08:33:54 +0000
Message-ID: <BY5PR12MB43227784BB34D929CA64E315DCCA0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201209072934.1272819-1-saeed@kernel.org>
 <f720c3fb-7401-4f3a-7de2-25309c2570f5@intel.com>
In-Reply-To: <f720c3fb-7401-4f3a-7de2-25309c2570f5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 166e2985-260c-4f0a-9c9c-08d89daf7ee8
x-ms-traffictypediagnostic: BYAPR12MB3109:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB310931D44A2FD10330D670B0DCCA0@BYAPR12MB3109.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IGqYdiDK/uxw2HD3r+8LbejpfXvrXLMrLFlftgBz3gofUFOZex07naNcVtUcXPoSwIWv6G8wCR8Hjs78A+3sbawtxIuo8ZY9EJFdW7RcGpINFW8pzZaBz9yi//OEas3g/oy+7fNOYvMLPIJ+aeO8B+tj9nmx+TOem4d14VLx7Ua+VVjVI6DnjbUqn2vamrdhY2CA1cMW5KiWqW0KyBfLKpW55Tg8o+H+WgEzSKfgm2vmPVSJLaC7/u5tZzA1bLDJY99AnVNJlFiy1y5qsfGlNGlrP+H+/HR6TjlULvqVBwmfKs0WiPR9sYZ7esRCGbvmvzi43iZnAEszKwjZrPng62mqjyzSc/4xqinKm23LICRw6m5p40Aa4caZlp9ZQI/Hxc5D9l+ggmf07vWSywQlpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(52536014)(66446008)(7416002)(71200400001)(26005)(7696005)(2906002)(966005)(8676002)(186003)(8936002)(4326008)(86362001)(45080400002)(55016002)(5660300002)(9686003)(76116006)(6506007)(33656002)(508600001)(110136005)(55236004)(66946007)(66556008)(64756008)(6636002)(66476007)(54906003)(53546011)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y2xiL3hOV2lrZmtROCtBd0NrRGFsOWNzRnN2SWFITXdnQ3l4NXFBUnhFV0xx?=
 =?utf-8?B?SXBYZUlNTmowNjFsdno2cUc0ZEVSSzhxNHBZZlpDZnFvYXA4cUhQVnNsbml1?=
 =?utf-8?B?Q0N1NnV1d0hySjVMeDFmMCtTQUlTZVpTYTNLczBocHNmc0NodFJIdGhZL0Fo?=
 =?utf-8?B?aStkZDJHYVVSZ0Ira2pXNVpUNFBHQm5xUXRIS1NEK24vdlhkUWYxQjhzYWh5?=
 =?utf-8?B?RmtSS3dpS0d4aDUvRi82L0xOamJBSzdxbWtEd21vNmFDelExcmZKK05iV2Fv?=
 =?utf-8?B?b0JnTEFjQWVZWFlMWjlYQTNOazg0NlB1eWJMNkpiNnBZYjFXaWJIMmZIUXhs?=
 =?utf-8?B?YkZnZWdjMndwZTZpTFVMVlhJVVhsYjdHeTIzS3VCdmtiWGxmRGQ4RG55ZThD?=
 =?utf-8?B?bDdXWHU5QzlwUWx1a3ZVekc5Si9RbjhzcUVQbmZyR1ZSU3UzVFAyVWdvOG1F?=
 =?utf-8?B?STFUL2ZOVTUrRytqQWRuN3g5a2xaRWNsWE1kTVBDa2hTQ0piM2ZEOG5LRGgx?=
 =?utf-8?B?RXdHUWgweUVyem1aM3o5UGNQOHExNXhzMkp6dVFmSDdRYmRiVTVPYk4yaC9W?=
 =?utf-8?B?eDBXWW9Dd2RnR0ZMN0VPZUNJRG1Jb2p2aDUzdkRnd2VkU1R5dE1Wc1ZVUk1Y?=
 =?utf-8?B?TjFGSHV2b2R0QnFTK3lLQXZOTzQwOGhibzkwcFhOeTNzZmZhcytOM2R5V05h?=
 =?utf-8?B?TlQ2cUlTVVVIRlFiODViQUtTTkZFVmdMbHNBUWFFdmthclpDSEZlSVhUUjNE?=
 =?utf-8?B?VXNsRjA4c0tnWWVJS01XcTVBQURvRFBnMi9SbXNEd3hZcWNzVldKZjMzOUVo?=
 =?utf-8?B?S0FzQ2xlN2VrT1NxNDVvaVU5WXNUdHFsOEdUd2Q5UlI1bS92MEZ6dDhyeDZa?=
 =?utf-8?B?aHE3L2kyYXJVQ0ZROG1pa3B0QkR1QmJmdE1Hak9kSDVBSGdEcWlyZlpCRVpL?=
 =?utf-8?B?RzMzQkswc3FCMlh1Y3czUm5ESkg1L2VVRE1OZVlCb1krbG9YKzFhdjJ6Zjlo?=
 =?utf-8?B?UU5JVk1WeVloa2ZsRWxicTRyU0M2SU42cHNoU3pSbFZVRTRpZjBSZGJRaS9W?=
 =?utf-8?B?ZTVWdzdDV0c2TVQzOUkzcmFhWk1EY0tIYmpyNXZhZVhTa0RTZUVacTlVYjdH?=
 =?utf-8?B?c08zSU5WOTQwTzQyVEN4alZyWDlPRThXbzhyNHRUaDNSSTFOc2VsL2tQUFhz?=
 =?utf-8?B?QkNpdVhvSkNrYmc1eXhFd2M2VENWWWtYUktQZGZhUjdSTXJnME1RQWRxc1N6?=
 =?utf-8?B?eExFTERtYWdsUDNhQ1pIYXVsTGs2cXZaRHVMZThubEsrRXpHeFdOc1F5eWkx?=
 =?utf-8?Q?YPO+jRDXE7Zac=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 166e2985-260c-4f0a-9c9c-08d89daf7ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 08:33:54.5851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJMwEMWFNQEdFf3hEZjm3RcCvSIy9Tyd+2YIDGeU8iaxWrwFLEAXUPl4VkjfdB4TsJAh2EPmAAYutkCzbaE8KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3109
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607675636; bh=FficEJeDcNZm/WrbY8pHRdiNQM5Uj4/v/OT5hkXf8ho=;
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
        b=WR5UgnVC03H51qN2H2sKEvjHW5JBxUUS+l1M18YLoN+d8BK/NrY60f+B/1HUNe2Yw
         tAFRf+R3WuWpqOYGGpASA/Jde0D1GOiEFpl8f1gP6Z8cXmod5mlB419G2MfKiO/hqJ
         5IjHNPXeYixs7lXGq3e8mWMWbg9ldH0edidDfeCrBae6QePx1veYQbEAiAnDGWp8EL
         Fzdu1BYRYy6xdwMagB1b/IQPyBgRhywXqrQwib1wjJFvuQLjxiyWschc9NPKq6lqmF
         DbLo7nnK3IW7NfoQqaBuf56MAnGPg8xqh+voTfvhLMmQ9eivDvs1gstCOC6thv15ti
         TcPxWZX6kK9QA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogU2FtdWRyYWxhLCBTcmlkaGFyIDxzcmlkaGFyLnNhbXVkcmFsYUBpbnRlbC5j
b20+DQo+IFNlbnQ6IEZyaWRheSwgRGVjZW1iZXIgMTEsIDIwMjAgOTo0MiBBTQ0KPiANCj4gT24g
MTIvOC8yMDIwIDExOjI5IFBNLCBzYWVlZEBrZXJuZWwub3JnIHdyb3RlOg0KPiA+IEZyb206IFBh
cmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4NCg0KDQo+ID4gU3ViZnVuY3Rpb24gcHJvdmlk
ZSB0aGUgc2FtZSBmdW5jdGlvbmFsaXR5IGFzIFNSSU9WIGJ1dCBpbiBhIHZlcnkNCj4gPiBsaWdo
dHdlaWdodCBtYW5uZXIsIHBsZWFzZSBzZWUgdGhlIHRob3JvdWdoIGFuZCBkZXRhaWxlZCBkb2N1
bWVudGF0aW9uDQo+ID4gZnJvbSBQYXJhdiBiZWxvdywgaW4gdGhlIGNvbW1pdCBtZXNzYWdlcyBh
bmQgdGhlIE5ldHdvcmtpbmcNCj4gPiBkb2N1bWVudGF0aW9uIHBhdGNoZXMgYXQgdGhlIGVuZCBv
ZiB0aGlzIHNlcmllcy4NCj4gDQo+IFdoYXQgaXMgdGhlIG1lY2hhbmlzbSBmb3IgYXNzaWduaW5n
IHRoZXNlIHN1YmZ1bmN0aW9ucyB0byBWTXM/DQo+IE9SIGlzIHRoaXMgb25seSB0YXJnZXRlZCBm
b3IgY29udGFpbmVyIHVzZWNhc2VzIGF0IHRoaXMgdGltZT8NCj4gDQpDdXJyZW50bHkgc3ViZnVu
Y3Rpb24gY2Fubm90IGJlIGFzc2lnbmVkIHRvIFZNIGFzX2lzLg0KU29tZSBtb3JlIHZmaW9fcGNp
IHN0eWxlIHNvZnR3YXJlIG1heSBiZSBkZXZlbG9wZWQgaW4gZnV0dXJlIHRvIG1hcCBzdWJmdW5j
dGlvbiBhdXhpbGlhcnkgZGV2aWNlIHRvIHRoZSBWTS4NCg0KPiA+DQo+ID4gQWRkIGEgZGV2bGlu
ayBwb3J0IG9mIHN1YmZ1bmN0aW9uIGZsYW92dXI6DQo+ID4gJCBkZXZsaW5rIHBvcnQgYWRkIHBj
aS8wMDAwOjA2OjAwLjAgZmxhdm91ciBwY2lzZiBwZm51bSAwIHNmbnVtIDg4DQo+IElzIHRoZXJl
IGFueSByZXF1aXJlbWVudCB0aGF0IHN1YmZ1bmN0aW9ucyBjYW4gYmUgY3JlYXRlZCBvbmx5IHdo
ZW4NCj4gZXN3aXRjaCBtb2RlIGlzIHNldCB0byBzd2l0Y2hkZXY/DQo+IEkgdGhpbmsgd2Ugc2hv
dWxkIG5vdCByZXN0cmljdCB0aGlzIGZ1bmN0aW9uYWxpdHkgd2l0aG91dCBzd2l0Y2hkZXYgbW9k
ZSAuDQo+IA0KSXQgaXMgbm90IHJlc3RyaWN0ZWQuIFdlIGRpc2N1c3NlZCB0aGlzIGJlZm9yZSBh
dCBbM10uDQoNCj4gQWZ0ZXIgdGhpcyBzdGVwLCBpIGd1ZXNzIGFuIGF1eGlsaWFyeSBkZXZpY2Ug
aXMgY3JlYXRlZCBvbiB0aGUgYXV4aWxpYXJ5IGJ1cyBhbmQgYQ0KPiBkZXZsaW5rIHBvcnQuDQo+
IERvZXMgImRldmxpbmsgcG9ydCBzaG93IiBzaG93IHRoaXMgcG9ydCBhbmQgY2FuIHdlIGxpc3Qg
dGhlIGF1eGlsaWFyeSBkZXZpY2UuDQpZZXMgYW5kIHllcy4NCkJlbG93IGNvbW1hbmQgd2lsbCBz
aG93IHRoZSB0aGUgYXV4aWxpYXJ5IGRldmljZS4NCkF1eGlsaWFyeSBkZXZpY2UgaXMgbGlzdGVk
IGluIGRldGFpbCBpbiB0aGUgcGF0Y2hfNyBhdCBbNF0gd2hlbiBpdHMgY3JlYXRlZC4NCiQgZGV2
bGluayBkZXYgc2hvdyBhdXhpbGlhcnkvbWx4NV9jb3JlLnNmLjQvDQpNb3JlIGJlbG93Lg0KDQo+
ID4gQ29uZmlndXJlIG1hYyBhZGRyZXNzIG9mIHRoZSBwb3J0IGZ1bmN0aW9uOg0KPiA+ICQgZGV2
bGluayBwb3J0IGZ1bmN0aW9uIHNldCBlbnMyZjBucGYwc2Y4OCBod19hZGRyIDAwOjAwOjAwOjAw
Ojg4Ojg4DQo+IFdoYXQgaXMgZW5zMmYwbnBmMHNmODg/IElzIHRoaXMgdGhlIHBvcnQgcmVwcmVz
ZW50ZXIgbmV0ZGV2PyANClllcywgaXQgaXMgcmVwcmVzZW50b3IgbmV0ZGV2IGFzc29jaWF0ZWQg
d2l0aCB0aGUgZGV2bGluayBwb3J0Lg0KDQo+IEkgdGhpbmsgd2Ugc2hvdWxkIGFsbG93IHNldHRp
bmcgdGhpcyBieSBwYXNzaW5nIHRoZSBkZXZsaW5rIHBvcnQuDQpBYnNvbHV0ZWx5LiBJdCBpcy4g
RXZlcnkgZGV2bGluayBwb3J0IGlzIGlkZW50aWZpZWQgYnkgYSB1bmlxdWUgcG9ydCBpbmRleC4N
ClNvDQokIGRldmxpbmsgcG9ydCBzaG93IHBjaS8wMDAwOjA2OjAwLjAvPGRldmxpbmtfcG9ydF9p
bmRleD4gIHdpbGwgc2hvdyBpdC4NCg0KSXQgaXMgY2FwdHVyZWQgaW4gZGV0YWlsZWQgZXhhbXBs
ZSBpbiB0aGUgY29tbWl0IGxvZyBvZiB0aGUgcGF0Y2hfNyB0aGF0IGFkZHMgaXQgYXQgWzRdLg0K
QWxzbyBwcmVzZW50IGluIHRoZSBEb2N1bWVudGF0aW9uIG9mIG1seDUucnN0IHBhdGNoXzE0IGF0
IFs1XS4NCg0KSSBqdXN0IHVzZWQgdGhlIHJlcHJlc2VudG9yIG5ldGRldiBleGFtcGxlIGFzIGl0
IHdhcyBpbnR1aXRpdmUgdG8gdmlldyB0aGUgd29ybGQgZnJvbSBlc3dpdGNoIHNpZGUuDQpCdSB5
ZXMsIGluc3RlYWQgb2YgbmV0ZGV2IHBvcnQgaW5kZXggaXMgYWxyZWFkeSBzdXBwb3J0ZWQgbmF0
aXZlbHkuDQoNCj4gDQo+IFdoYXQgYWJvdXQgb3RoZXIgYXR0cmlidXRlcyBsaWtlIG51bWJlciBv
ZiBxdWV1ZXMsIGludGVycnVwdCB2ZWN0b3JzIGFuZA0KPiBwb3J0IGNhcGFiaWxpdGllcyBldGM/
IENhbiB3ZSBhZGQgb3RoZXIgYXR0cmlidXRlcyB2aWEgdGhpcyBpbnRlcmZhY2U/DQo+ID4NCldl
IGJlbGlldmUgdGhhdCBjYXBhYmlsaXRpZXMgb2YgdGhlIGZ1bmN0aW9uIHNob3VsZCBiZSBjb250
cm9sbGVkIHVzaW5nIHRoZSBwb3J0IGZ1bmN0aW9uIHNldCBjb21tYW5kLg0KQXQgdGhlIG1vbWVu
dCBvbmx5IG1hYyBhZGRyZXNzIGNhbiBiZSBjb25maWd1cmVkLg0KTnVtYmVyIG9mIHF1ZXVlcyBp
cyBhIHJlc291cmNlIHNvIGRldmxpbmsgcmVzb3VyY2UgaXMgbW9yZSBzdWl0YWJsZSBpbnRlcmZh
Y2UuDQoNCj4gPiBOb3cgYWN0aXZhdGUgdGhlIGZ1bmN0aW9uOg0KPiA+ICQgZGV2bGluayBwb3J0
IGZ1bmN0aW9uIHNldCBlbnMyZjBucGYwc2Y4OCBzdGF0ZSBhY3RpdmUNCj4gSXMgdGhlIHN1YmZ1
bmN0aW9uIG5ldGRldiBjcmVhdGVkIGFmdGVyIHRoaXMgc3RlcD8NClllcy4NCj4gSSB0aG91Z2h0
IHRoZXJlIHdhcyBhIHN0ZXAgdG8gYmluZCB0aGUgYXV4aWxpYXJ5IGRldmljZSB0byB0aGUgZHJp
dmVyLg0KWWVzLiBVc2VyIGNhbiBhbHdheXMgYmluZC91bmJpbmQgYXV4aWxpYXJ5IGRyaXZlciBm
cm9tIHRoZSBhdXhpbGlhcnkgZGV2aWNlLg0KQ3VycmVudGx5IGF1eGlsaWFyeSBidXMgZG8gbm90
IGhhdmUgb3B0aW9uIHRvIGRpc2FibGUgYXV0b3Byb2JlIChwZXIgZGV2aWNlKS4NClRoaXMgaXMg
c29tZXRoaW5nIHRvIGJlIGV4dGVuZGVkIGluIGZ1dHVyZSBzbyB0aGF0IHVzZXIgY2FuIHNlbGVj
dCBob3cgYSBzdWJmdW5jdGlvbiBkZXZpY2UgdG8gYmUgdXNlZCBpbiB0aGUgaG9zdCBzeXN0ZW0u
DQoNCj4gSG93IGRvZXMgdGhlIHByb2JlIHJvdXRpbmUgZm9yIHRoZSBhdXhpbGlhcnkgZGV2aWNl
IGdldCBpbnZva2VkPw0KPiA+DQpXaGVuIHRoZSBzdWJmdW5jdGlvbiBhdXhpbGlhcnkgZGV2aWNl
IGlzIHBsYWNlZCBvbiB0aGUgYXV4aWxpYXJ5IGJ1cywgZHJpdmVyIGNvcmUgaW52b2tlcyB0aGUg
cmVnaXN0ZXJlZCBkcml2ZXIgcHJvYmUgcm91dGluZS4NClBsZWFzZSByZWZlciB0byBwYXRjaCBf
NyBhdCBbNF0uIEl0IGlzIHNpbWlsYXIgdG8gaG93IGEgcGNpIGRldmljZSBpcyBwcm9iZWQuDQoN
ClszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvQlk1UFIxMk1CNDMyMjVBQTVBNUU0
MkU3NkMwM0Y2NDVCREMzRjBAQlk1UFIxMk1CNDMyMi5uYW1wcmQxMi5wcm9kLm91dGxvb2suY29t
Lw0KWzRdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIwMTIwOTA3MjkzNC4xMjcy
ODE5LTQtc2FlZWRAa2VybmVsLm9yZy8NCls1XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRk
ZXYvMjAyMDEyMDkwNzI5MzQuMTI3MjgxOS0xNS1zYWVlZEBrZXJuZWwub3JnLw0KDQo=
