Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111E72DB20F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgLORAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:00:35 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18072 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgLORAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:00:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd8eb740005>; Tue, 15 Dec 2020 08:59:32 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Dec
 2020 16:59:27 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Dec 2020 16:59:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZdKbgtwW86ZZ1hsmOIJyxjIxT2iMJglPcBXV9B7xRPy3NSIwDauY0Kv4C7bZnQHcy7rAgHojgMxrP9KpAPmrpAlIR5ciQTlAxdLhiI9PH0edBGMPCGqVh/fImWXQ/JIq7ndaqqEFGHqhRIcM6bGSV+vROHziLxm85sQ0H2NqEhb9t3a5pSthohLU7LhURJKi61oUM07EBhqnFgQWMvSiSwqZXnmBSLTGuXWQvPBVasfanb2Q3UkMe2mm6vC+VFUgxT26Dtn7BuqvLswHn4RaJkqOyC5fJTk4GqWXQrWCwITrIWdGmlthomhmvdviC5EyNPBUH1cuopRS/j2Uwp8pHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=logqA3BvglAWxuhu5chcqjvSq63IZIMaiYidIYFgkOQ=;
 b=KqPEa+3S9tJvPfkub6knnlvY35s/nE9NrP3xzWRGTwTVvfs68cZdHQqtwMCmzDqv6gn4hEp8Qcua5sx2d5h9sjWlgxald+bYfQUe4Hf+JjSAMeBCiMPmTea4gG7kRz1PtuEH9yCdoDMjAViL1xKM7U7lHDLV6E0QML/Yu9/t1V4Fap/yWWAZg2kJ3FCFXjgkExDj3/POPXErgMEVTXdgDbfiIeH2DfDhz5E9do5RL2CyIFvnFGEPNIV7a6oARalHhSgl7uSyGPEfsQe1y+rnNvm0YE1mCh+y+b83KG5ATp9v62ComflPfqdc62qEf9bqau5HFatAHVWnPhhVnD5Wdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 16:59:26 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.032; Tue, 15 Dec 2020
 16:59:26 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Topic: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Index: AQHW0mKFU48o8ZNlzEyGRue6Xkj1U6n3ZWwAgAAOPICAAOL3gIAACz2g
Date:   Tue, 15 Dec 2020 16:59:26 +0000
Message-ID: <BY5PR12MB43226C436EBE8201EB2D529EDCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <0af4731d-0ccb-d986-d1f7-64e269c4d3ec@gmail.com>
 <CAKgT0UfRWgkvezq2XVYGgxW2d1s+namb2r_e0=m9QN=e2O9WvA@mail.gmail.com>
In-Reply-To: <CAKgT0UfRWgkvezq2XVYGgxW2d1s+namb2r_e0=m9QN=e2O9WvA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b602ff45-3924-400a-4efd-08d8a11ac79d
x-ms-traffictypediagnostic: BY5PR12MB4180:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB41804489BB1A5118FDF736AEDCC60@BY5PR12MB4180.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IB4yyFCWZ3KM7pNJ8Kv+PzDd4TOowbbsPXjNEBAMiWGM98+6umNCktthtM9DgWp2cljT56if92SHk+Lf8PE/dUc3ysXjLxOBls3FyYIROCGZcSxDqgBuHn6CeNfQKlRI2lIiJ35c2Mp2dgHF3uhMEiKTkO1BkQ4EZzw97025N4YaePz13IRNC16FoeHgFDORtHdXAbMhGfDiNa78/Trm16GS1wkvOccn7TJCrmtGk06sGria2x3XN6YP7QvuYVfFSu0ulfLur/5ZpotOTL4dlDZHAZouzLFEdnCRc7wY1di+c6e8bESndbQqiqkjXWsAigRB9Ujhp8rRayJXYQXf3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(66946007)(55236004)(110136005)(53546011)(2906002)(9686003)(26005)(76116006)(71200400001)(186003)(33656002)(83380400001)(7696005)(508600001)(54906003)(7416002)(86362001)(66476007)(4326008)(66446008)(6506007)(5660300002)(66556008)(64756008)(55016002)(52536014)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QXZOSitQeHphdGd1blJIQTFIUENJSUxSaGpHQkpLRWZxWlM4YjJZNDZUNXIy?=
 =?utf-8?B?QmtoTk9ieXJMS0Qwc0t4UUZHQ0pCM0RJZHo2MFhwKzJNSlhVbW9iczR4WWl0?=
 =?utf-8?B?VWp6VnZmM05sMi8wUG9xZGlodER1Vm1MTFI2a1BGc3NybTRUbSszd3NmMS83?=
 =?utf-8?B?V1ZvS01BSVl2Si9KNXpieDhOVU9VYkxwSW1zaFUzZG5PWjlsTDhKQTRLQUsr?=
 =?utf-8?B?eDNwL3hKemtsbjBwdTV5THh3YTBaRWViUVlVSXhmNm14Tm04MFVSakRqNnhq?=
 =?utf-8?B?S3BqM2JuOVNzL21yUFFsUldnUjV6N3FxSWxlWjV2Slp2c2dZTXpwSmZNNVJW?=
 =?utf-8?B?cisrS1FsUnBtNHBCV3ZCd0xSNUZjZnYyZDZ1ajFNam5Fd3R5c0ZFU0xRUXRD?=
 =?utf-8?B?UUpYN0pPOTJzS2Z3UmFxcE1LK21HM1dvNXFIbXFIMFFGVEtROXBMZVVPblJY?=
 =?utf-8?B?dVBEbUgxamxpTzZnalY4SlV3ajBwMWJ2WVdhanpObDRPZmdhdjBxRk54b0p4?=
 =?utf-8?B?S1hRMWlFUHl4QzE1Y3hzS2tLWDQydzNjOWNGYi8va0huU0JBSm55MkorR2hB?=
 =?utf-8?B?S0NSYVhzT2NrT2ZiQWU2UFFOSmFWVDlrQ2RPRDNCbTdxaW5WSE9wWlJOQVFW?=
 =?utf-8?B?d0w5ZlVpTjJWYWoxZDMySlVkaGRvYTAvalcwQkdUWWJTdDNDNlllMEdKb0p4?=
 =?utf-8?B?alJYeFg5cXg3Uk5uTWIwV0s0RVZqNldLRFY2YlBhdUpEYjErTjcwelhoV1U2?=
 =?utf-8?B?MmFML2hweEd0YzRta0ZmYzlscjEwczE2NHN6ZFlucGpmSzBPRm5WNGhscnpM?=
 =?utf-8?B?QTdraHhiU1NoVmgxbWlFMUxybmkvaFZZeGxnTi9YK09IVnh4OUE2dG9pam4r?=
 =?utf-8?B?MGt2REpSblFkTVg0TlgvVEdvWVFDQkR2TnRsOVlPc1hWUnk4emdSdUY0Mm9U?=
 =?utf-8?B?QlJsMlk2dGMvQUpyRERzOHNycmM2L2J2WDNObkZNNGRqN0o0cCtubzkwcE9C?=
 =?utf-8?B?SkU0WC95ZklsaXAwTnBrRXk5K29sakMzK0E1VVhQdGhtdTR4djQ2ZytJV1dI?=
 =?utf-8?B?K2k1aER6amYzc2VaTDlWZTFZeDdvUldURDBLd3BzZVYvYTJuL1ltT0xmZDh1?=
 =?utf-8?B?b1BYQm9Kb3Q5amk0US9BbTgxdkRieGNIY0I3VkZwYnJWaXJNWnVhQU5BQjk3?=
 =?utf-8?B?c3VTalROQUhVb2R4MEpwRCsyOTQvNXBwRlNxaFBYdVgxMXlnNUZvZndQdG1q?=
 =?utf-8?B?cDNHUFBxUUNhR3c2dVZvNWNzODFLVzdjazlIWjlLZWhBQTE4SGk0UUhyR2Ju?=
 =?utf-8?Q?Y9ruMAOvhdFlc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b602ff45-3924-400a-4efd-08d8a11ac79d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 16:59:26.1847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iw0vl1h71pcR98O2Nv1l4LJoswQlY6yOrjsubJal8SRuwpI1d/r4gmqhTlmpvJhtOmXumcB0HXn4RHGGTXqmpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608051572; bh=logqA3BvglAWxuhu5chcqjvSq63IZIMaiYidIYFgkOQ=;
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
        b=pvV9qwCdEeFFfs632X8CffEEZeLgfP/Yr3YUVHlwNwVBE8nLOz4yHF+ioKXzDkvdd
         PNNfkdcWTfFidCvskWA1yai/Q7uh2zmwAxRCiohqDGpaLcMULzgyIirnT5YA9VBLgR
         W33CUkS6BowUp7qpdtiQEmvZ+l8iHk6rYt/W6tYfBKVOWNWmxgRrpc8OX/V3BawCtB
         +Dlb5S+qP9aRMxvI4IHjutPo8R35uwl7Eb7e1utYxa9jBtHTdCNDauBz6Fgksaf17d
         IUgU+abAAucKlm/dfR3LhAoTkL7iVw2h/LC/CquN2oA5IIvFGwaYb3bmtyWdWlpswX
         P29vF9WFGQ5ww==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tPg0K
PiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxNSwgMjAyMCA5OjQ3IFBNDQo+IA0KPiBPbiBNb24s
IERlYyAxNCwgMjAyMCBhdCA2OjQ0IFBNIERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4g
d3JvdGU6DQo+ID4NCj4gPiBPbiAxMi8xNC8yMCA2OjUzIFBNLCBBbGV4YW5kZXIgRHV5Y2sgd3Jv
dGU6DQo+ID4gPj4gZXhhbXBsZSBzdWJmdW5jdGlvbiB1c2FnZSBzZXF1ZW5jZToNCj4gPiA+PiAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ID4+IENoYW5nZSBkZXZpY2Ug
dG8gc3dpdGNoZGV2IG1vZGU6DQo+ID4gPj4gJCBkZXZsaW5rIGRldiBlc3dpdGNoIHNldCBwY2kv
MDAwMDowNjowMC4wIG1vZGUgc3dpdGNoZGV2DQo+ID4gPj4NCj4gPiA+PiBBZGQgYSBkZXZsaW5r
IHBvcnQgb2Ygc3ViZnVuY3Rpb24gZmxhb3Z1cjoNCj4gPiA+PiAkIGRldmxpbmsgcG9ydCBhZGQg
cGNpLzAwMDA6MDY6MDAuMCBmbGF2b3VyIHBjaXNmIHBmbnVtIDAgc2ZudW0gODgNCj4gPiA+DQo+
ID4gPiBUeXBvIGluIHlvdXIgZGVzY3JpcHRpb24uIEFsc28gSSBkb24ndCBrbm93IGlmIHlvdSB3
YW50IHRvIHN0aWNrDQo+ID4gPiB3aXRoICJmbGF2b3VyIiBvciBqdXN0IHNob3J0ZW4gaXQgdG8g
dGhlIFUuUy4gc3BlbGxpbmcgd2hpY2ggaXMgImZsYXZvciIuDQo+ID4NCj4gPiBUaGUgdGVybSBl
eGlzdHMgaW4gZGV2bGluayB0b2RheSAoc2luY2UgMjAxOCkuIFdoZW4gc3VwcG9ydCB3YXMgYWRk
ZWQNCj4gPiB0bw0KPiA+IGlwcm91dGUyIEkgZGVjaWRlZCB0aGVyZSB3YXMgbm8gcmVhc29uIHRv
IHJlcXVpcmUgdGhlIFVTIHNwZWxsaW5nIG92ZXINCj4gPiB0aGUgQnJpdGlzaCBzcGVsbGluZywg
c28gSSBhY2NlcHRlZCB0aGUgcGF0Y2guDQo+IA0KPiBPa2F5LiBUaGUgb25seSByZWFzb24gd2h5
IEkgbm90aWNlZCBpcyBiZWNhdXNlICJmbGFvdnVyIiBpcyBkZWZpbml0ZWx5IGEgd3JvbmcNCj4g
c3BlbGxpbmcuIElmIGl0IGlzIGFscmVhZHkgaW4gdGhlIGludGVyZmFjZSB0aGVuIG5vIG5lZWQg
dG8gY2hhbmdlIGl0Lg0KSSBhbSB1c2luZyB0byB3cml0ZSAiZmxhdm9yIiBhbmQgSSByZWFsaXpl
ZCB0aGF0IEkgc2hvdWxkIHByb2JhYmx5IHNheSAiZmxhdm91ciIgYmVjYXVzZSBpbiBkZXZsaW5r
IGl0IGlzIHRoYXQgd2F5Lg0KU28gSSBhZGRlZCAndScgYW5kIHR5cG8gYWRkZWQgaXQgYXQgd3Jv
bmcgbG9jYXRpb24uIDotKQ0KVGhhbmtzIGZvciBjYXRjaGluZyBpdC4gDQpTYWVlZCBzZW50IHRo
ZSB2NSBmaXhpbmcgdGhpcyBhbG9uZyB3aXRoIGZldyBtb3JlIEVuZ2xpc2ggY29ycmVjdGlvbnMu
DQo=
