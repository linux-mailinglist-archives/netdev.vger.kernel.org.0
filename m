Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F36D302C83
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732287AbhAYU3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:29:03 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5852 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732265AbhAYU2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 15:28:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f299c0001>; Mon, 25 Jan 2021 12:27:08 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 20:27:02 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 20:27:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W82Wq2XdiVgW4ECqijuo04UvpMcwYuIf0/KDLpujIoPTD72ujefWfrCT7eGmh69Lw6w5Jh9Nz5nj5IGFi0/uB6XffEJ+akBB/RiORIrCSSggVILfWZMD0txkGLjirZL48tieSz6ng5uv12Fdw4fOmRqth6uT7BX7jm3R3pxoemy33ckOULGxLMOlNleylOt6FBn7OlHwxqRIm88aIDTZ8ANJFoMg3PHeHeOZje6BnWx9L/2yCxT+TOWwnp6tc1ImO0fN0ECBfEcZ8PytbT5U3/6+Z2beKYBZLDPbShfN304Bt1+CnxoFrTdylrX1cl3zxyex+fLSz9SdZP4kyCohZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojLHAAVVL756vA8ycXaeTaf7dEPb3Cesdss1r++uml4=;
 b=QO/GAn24lt6xi7CzqBNAoOWDTF8JIM6fdgpBZRTI8ZU7ZjdPnnBNXp2+tLJGWDIseNAcN4HZ6GWOU+1S0gDe7aIqZoIu5XWyYwP1pnvnHQ6ejSMa1jJi1zVW55xJuPtF7S4nvExydekBYn3ddLsVWk0I16erdFwtq1Z5RDJOwU7dZzHoXOuRlqjJdLKmAYls2lvjr9S2zfKu9TNExJr2yrSQPiDo+wMUVHgqSn0vSURiGZTmlWRS6CcmIY7F6E6duMvOhjJyH/tIJZ3zCBP/ykEIWsjTmTL55KA2zoUqrSR1GWTkGOVWcni/dISHJ5l3KNXmAE7YVO73GWDIllgRWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2888.namprd12.prod.outlook.com (2603:10b6:a03:137::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 20:26:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.019; Mon, 25 Jan 2021
 20:26:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Kiran Patil <kiran.patil@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Thread-Topic: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Thread-Index: AQHW8RRNInj19u6+tky+dxvR/K+r5Ko3Qf+AgADqQpCAACvCAIAAZRMAgAAHMoCAAASLgIAAALFg
Date:   Mon, 25 Jan 2021 20:26:57 +0000
Message-ID: <BY5PR12MB4322027CCDC2ECAF21174490DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210125132210.GJ4147@nvidia.com>
 <CAKOOJTx9V328r+TC_Pd0LXQr6aMaiK2eB4Qu77Dw-kc00vg3Bg@mail.gmail.com>
 <20210125194941.GZ4147@nvidia.com>
 <CAKOOJTwuziJWKUFVNMtqbOeMnRx6eJF54zEu7GDaUJr_Tx1Rtw@mail.gmail.com>
In-Reply-To: <CAKOOJTwuziJWKUFVNMtqbOeMnRx6eJF54zEu7GDaUJr_Tx1Rtw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08b79958-0637-43bc-e2b9-08d8c16f903f
x-ms-traffictypediagnostic: BYAPR12MB2888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2888177A8E7CDFC806894E04DCBD9@BYAPR12MB2888.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: geS5o07M4l2ICzXzmBKAEy2WnmkMY/S+5AF1QY3oHynV0fn8+s9/AcvD0nbwZhuXLRiOz6Cl7NIgAlLlnMw5T3fS1zTDc8RM80o4Q9ZctCzik0fLJJItJ1rY6/G12dvo+0AzeunF4nx94j0wr1Cjx8NirziAx1M602OpTTRe081RdjluV3fl/MWDSPj0k74EFrchq7lWX15JEFK5SJWmGOtioVZXkNtZPTeIHPGoXVNchPif0Vlz4YEdoujw3iW7A4mjS8uyp/N2UzEnTeyB7ql9ZXwlzbOHYD4e5qS96SQ5eRpg+SjV155yuNR46NK9aFzlR61FlwjmUxhmC0aVGeS9Ls1QtpjhKL701bqtvFZx7tYgQEtP+pe9UPXXv4qadxMCx4VGDvWciKv2zIS3eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(8936002)(316002)(5660300002)(55016002)(6506007)(83380400001)(66946007)(9686003)(52536014)(110136005)(53546011)(2906002)(64756008)(66446008)(4326008)(66556008)(7696005)(107886003)(26005)(76116006)(186003)(54906003)(8676002)(66476007)(86362001)(7416002)(71200400001)(478600001)(33656002)(6636002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dEFxeFMwVjhuSlB0b01Wb3VJN3oxeWFuYWlpVFJPbnRRSktqQVFBc1BpN2NJ?=
 =?utf-8?B?d0hEaUIrNjdyMFNYZldHQlNJcUlzd1ZpUUNncmp3Rk01ZXBIeThKdnFHQzhq?=
 =?utf-8?B?V2FUYzFuSXJkaCtBKzRmK3Z0S2VtajZ2VkFNVWdIUEZQSUpZSUcwanVlVTBx?=
 =?utf-8?B?S1VvYkgwT29zbEVhZEdVMEkxL04xZHB3bGJjZ3pIZ2MxTlZCTGFBTnM5cHN0?=
 =?utf-8?B?VXBrc0lSN2FVTDJBSUFEY3JWS05hQTZJWGJlcjRSYnpHd3NQSENwZld2R3VK?=
 =?utf-8?B?VVJCKzh1Z25WK1RUbnowVmdYZk0raXlqNUpidkNpZ25xNkRXN3BBU2tHSTZU?=
 =?utf-8?B?L29VVkNtOGIvalRjbGZKeDYrc1FxVWgvRjZseVZQdm93V1F0b05mUWR2MVV0?=
 =?utf-8?B?dUluS1NrMmNGaDVJMlN0WVU1bVFGdUhxTGdBRm5KZE1OVEErWG44czhBS3lo?=
 =?utf-8?B?c2FobWpGWFlSTjNZei93ZG1pREo2bTlqUDJTZEp3NDVGOE9GWCtIY0lBbTRk?=
 =?utf-8?B?RkI5S2tnQTRFWmxyZDBEeVRNZlQzQkE0QVJoa2FuWmdXRnp6TWNUTjJ6YkVu?=
 =?utf-8?B?Mzhsb3I0TE9tWE5nYnQ5eUViTUs1VHF6Y3VTcFp3aWFCbGdlNWxTc0xsbFAr?=
 =?utf-8?B?YnBFcjdhN1RCTUhWZWlyVkJPRWhJeWZEMkl5MXJaR1A5R1ZReE15Z3NwTjhP?=
 =?utf-8?B?R3g4RTNvU1hJQWNpa0pLOWVhRFArVEo1SWNZTW45M2g0WDVOYXcwQWZxSFFE?=
 =?utf-8?B?ZzNyQThwdUdtOUVsbVoyWDB3Nm1OdzViQnhFV1o3YmhCNW9Cd3N5RkU0Mndk?=
 =?utf-8?B?SFJobEVnUkE2djlyWGtSZE03YmJrV0c3b2VsOWFTVm56ZTBSc0dmV0Jaa3Zq?=
 =?utf-8?B?YnBJV3U3eFVyRnZOZ3lIcW91cTBTdnpmQkJkYjZCZDN6ZlNlVnJsOEdQcHhB?=
 =?utf-8?B?WXgwV2FpNkJGKzlOeUZaWW8rd0MzdlV2RDg3bHdNMTRpSXdNeVYvNFZBZHk2?=
 =?utf-8?B?TncybGlXNXZNYllJMVNTY1UxaXFJM3lNL1ZyUmxZNVVIV1VFVlVpa2xibzAw?=
 =?utf-8?B?UHoybld6N3dpbUFsSW1OMm5GL0RwVmRkYUZkdVRjTW1aMFJjRXMyenZRMHJK?=
 =?utf-8?B?R0YwZ2I4WEhPeHVkY1MyNHVtN09RZ0NNNHI0OGtwL2NFVkwvWkc0NVlQbzY0?=
 =?utf-8?B?TzBIWGdIZ0JmZzF2RlZHclVodExSOFBHQzdPbzZhMlRCSm9xS01BeUhvaENC?=
 =?utf-8?B?S0p0N3IrT1paS3FpZ0FLN3ZMdW0yWFA3WEVFNUVhVkxsQ1RNTFhVUUd5WDRx?=
 =?utf-8?B?dDZkbnR5dGF0ZmF4VWJ0ajZoWjBoNU1DT3RRQ3JwcS9GL0xGRW9TWkNROUpN?=
 =?utf-8?B?dEtiZERhaWRGZjg0T0FDWXF2ejlRK1YweHltMDU3aGJHSThuRjF2YnFRQUx6?=
 =?utf-8?Q?jSKh4ghv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b79958-0637-43bc-e2b9-08d8c16f903f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 20:26:57.7207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKMswzHWMHE8bwPTcHEV33bAnZoMHKHraUmfT3xbklUECRrRFPdw637hW4gk6fIWg4FPhNFvkkEhfAUlwGPSVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2888
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611606428; bh=ojLHAAVVL756vA8ycXaeTaf7dEPb3Cesdss1r++uml4=;
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
        b=Evui1K6kAuyHD9uouerGomAVks3X5RjzJc+w8biZn9aJ8UCPXSJltjIQuAZrdLHKV
         NTv/fmOlFhb3o7dyx4CeGyku+SIIfQEMRqlP4/by3dIFmS/ASudDRtfcGLAIUfR1qU
         l26bW8IdgSaLxPPk+YpEAp/jqGPGFv56VbCu1jygRtBwmH0P0abrdm8UgpMz24G1Qc
         6dk/PglVDF6D6dV0iUXb1b8M21gWo3u9xDmmuOfrU1YOEGi6GWhdjBP/XwfH5ewrbZ
         j3xoNSO8hHMMnmFFNDOY2Sv8LNbz/mn7yBl1EJGo0CCkbvBUj6a7+n1c4T/NW13oJw
         8xCsn819tjbmw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEVkd2luIFBlZXIgPGVkd2luLnBlZXJAYnJvYWRjb20uY29tPg0KPiBTZW50OiBU
dWVzZGF5LCBKYW51YXJ5IDI2LCAyMDIxIDE6MzYgQU0NCj4gDQo+IE9uIE1vbiwgSmFuIDI1LCAy
MDIxIGF0IDExOjQ5IEFNIEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IHdyb3Rl
Og0KPiANCj4gPiBJJ3ZlIG5ldmVyIHNlZW4gc29tZW9uZSBpbXBsZW1lbnQgYSBOdW1WRiA+IDI1
NiBieSBjby1vcHRpbmcgdGhlIGJ1cw0KPiA+IG51bWJlci4NCj4gDQo+IFVzdWFsbHkgdGhlIFZG
IG9mZnNldCBhbHJlYWR5IHBsYWNlcyB0aGUgVkYgcm91dGluZyBJRHMgaW50byBhDQo+IGRpZmZl
cmVudCBidXMgbnVtYmVyIHJhbmdlIGZyb20gdGhlIFBGLiBUaGF0IG11Y2ggYXQgbGVhc3Qgd29y
a3MNCj4gdG9kYXkuDQo+IA0KPiA+IENhbiBMaW51eCBldmVuIGFzc2lnbiBtb3JlIGJ1cyBudW1i
ZXJzIHRvIGEgcG9ydCB3aXRob3V0IGZpcm13YXJlDQo+ID4gaGVscD8gQnVzIG51bWJlcnMgYXJl
IHNvbWV0aGluZyB0aGF0IHJlcXVpcmVzIHRoZSByb290IGNvbXBsZXggdG8gYmUNCj4gPiBhd2Fy
ZSBvZiB0byBzZXR1cCByb3V0YWJpbGl0eS4NCj4gDQo+IEknbSBub3Qgc3VyZSwgcHJlc3VtYWJs
eSBzb21ldGhpbmcgYWxyZWFkeSBpbmZlcnMgdGhpcyBmb3IgdGhlIGZpcnN0DQo+IGFkZGl0aW9u
YWwgYnVzIG51bWJlciBiYXNlZCBvbiB0aGUgU1ItSU9WIGNvbmZpZyBjYXBhYmlsaXR5Pw0KPiAN
Ckl0IGlzIG5vdCBpbmZlcnJlZC4NCkxpbnV4IHBjaSBjb3JlIHByb2dyYW1zIHRoZSBhZGRpdGlv
bmFsIHJlZ2lzdGVycyBmb3Igc3Vib3JkaW5hdGUgYW5kIHNlY29uZGFyeSBidXMgbnVtYmVycy4N
ClRob3VnaCwgaXQgY29tZXMgd2l0aCBpdHMgb3duIGV4dHJhIGh3IGNvc3QuDQoNCktlZXAgaW4g
bWluZCBob3cgMTAwMCBWZnMgYXJlIGVuYWJsZWQgYW5kIGRpc2FibGVkIGluIG9uZSBnbyBhdCBw
Y2kgc3BlYyBsZXZlbCBhbmQgc28gYXQgT1MgbGV2ZWwsIGFzIG9wcG9zZWQgdG8gdW5pdCBvZiBv
bmUgaGVyZS4NClBDSSBjb21lcyB3aXRoIGhlYXZ5IGJ1cyBsZXZlbCByZXNldCByZXF1aXJlbWVu
dCBhcGFydCBmcm9tIEFFUiBhbmQgbW9yZS4NCg==
