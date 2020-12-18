Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274192DDDD1
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 06:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732595AbgLRFVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 00:21:37 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15176 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732565AbgLRFVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 00:21:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdc3c380000>; Thu, 17 Dec 2020 21:20:56 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 05:20:55 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 05:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewm8wRJtSdSShSXmgRBT+B4skkbzyZobkv2j4BPRLUgjJJCH7HDbEu4TkdKaIhp1+p5KCXoI68ZumJE2WR+axeP95YSXbzMm+CahKOks32VlQ70I1nsdYN9Nt/uJZtMoMrjXbid+oHz0k1bnmHLz+a8/voG8cawddxqFzseJgZAWVnrMD22W9auMSsgI/R1fomTzHBorUbQpcWdEesDGC5GcAVF36wE6y6jxt9zU+Zvr2HTRm1gi57OGq2Eht4Pa1DsCxVxRtGRYNo6kkySFk/gQQv7RfQb3+sAOgnIY8kwrBtv64P3ewAtojl5i031Oebd7/XnafanXXw+TmFVjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbSz2O+KnwExif2h0BqwqKFiVv1Mw109tM897oe+4F0=;
 b=OvR5KYynKQmdPOPWkNMdH7AAqhe0aPrlrRzorYAb7An8XypiNcrjpHRBAJNfASuJO80oGdRitkmUIyJNP4xMb3L2oAFaAFzDTILL8VqmLVbGNksa0vwf+0FQGFffD/M/kgzuROMwR3XRhuFc60A6Nyfm2aCpXga022CI9CPfL2hhOE9YOr2oQ9s/cKmNcX7jIPIkjvqrIdJxGO7r1yapjTaozptDoFSelmNbQcBMNeJPZm5abapSkJZA5u5XRPeOl1kZrS/zMpc9AFcJFOm5/RvUj7kC+tVEK8CdHplYHLkIopbJrWHeA5ACiLDs8oJaTOHJP64GFH5jZ5qa9whHpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4228.namprd12.prod.outlook.com (2603:10b6:a03:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 05:20:53 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Fri, 18 Dec 2020
 05:20:53 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kiran Patil" <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Topic: [net-next v4 00/15] Add mlx5 subfunction support
Thread-Index: AQHW0mKFU48o8ZNlzEyGRue6Xkj1U6n3ZWwAgABJMwCAANkqgIAAFw4AgAASXQCAACxXAIAAIWYAgAAMc4CAABNrgIAAnGiAgAAx5QCAABY0AIAAGuoAgAATBoCAACZrgIABvk+AgAAcKYCAACOYEA==
Date:   Fri, 18 Dec 2020 05:20:53 +0000
Message-ID: <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
 <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
In-Reply-To: <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c6b4fd8-f1ed-4329-92ba-08d8a314b0c3
x-ms-traffictypediagnostic: BY5PR12MB4228:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4228BEA2E2A3BFEDB1347B76DCC30@BY5PR12MB4228.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9FhEAjLsoCGHHAKeEotXHEU1PS2lc/rLHp3eOthQf56vvktOgW/JqlJVDPWAtTC29VBMlrZRTLK2gbM04IdZfBjOe+PiWu3hWETROsCfqMQYH9bASJSb0zWe2mTiz+uC6PdSa+/8lL3w11S8BzvCiHZAzYpuud/q9jmzJGMC10XrUHmWNNZUw31TGBJZ1kZz7S9vqViwuidx9Xca91OIRChoBpKZDCLgcz6/VfNGZpdZ9Pi1d0oyX65io4nV1djOPh9+8xMqWkqIZKnwKdWbVw0/1wkhfqGTJQa5c9fmYdbNvLlz0CJAGUoDjJmEcin1br+7BIq2jFqfL4/7vUdFmDroYSkPkAelGSr4w/KCt8Qb67KI5oWklhaUkaNa5lu++6gZpoyDdxbEyWCTMu5dQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(53546011)(55236004)(6506007)(186003)(86362001)(8936002)(71200400001)(2906002)(54906003)(110136005)(52536014)(478600001)(9686003)(26005)(64756008)(66556008)(66476007)(76116006)(66946007)(5660300002)(66446008)(33656002)(4326008)(316002)(55016002)(7416002)(8676002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZlZqbUdlZW9hUUdYUDMyeXlIeVB4SnZsUjUxUW80RkwvSitZZU1NRUVnOUNM?=
 =?utf-8?B?YVQrbXJUbTcrQnFkSUlhUWliRmg3MGxlU3p6UFhlblNjams0Ui9aWFJReGxL?=
 =?utf-8?B?bVZVejdjOXkvOXdjd0puWXlLVDhLbEtsd1F4azlxU3VtbUFObW9qVkJpUU5j?=
 =?utf-8?B?NkxUUDJFSjNhcFdPYVFqaW15SkNGZHlMZ0FqMEVra2pmL0hUYkxob09BMjQy?=
 =?utf-8?B?aE92Q2gxcUlnNzBWYmkxNUdWSDJXejNHMFExVHBtTldheGFtVGM0WUJDK0NM?=
 =?utf-8?B?T211aGpGUmZvZkNJczhXZmlHRFZQNWtIYjNkRGVvN0ZvRk5lMlp5THkwWXgx?=
 =?utf-8?B?dU5IaDl4YitHRS9pSWxlbWVGMzdQVVJnTUtzaVRCemh3Qi9rZmVod1Z1WW1J?=
 =?utf-8?B?VFdUSmZObENuZHJRYitvOENSRFZldE83T1MrK0pveXd3bDRnVnFzazIrMnow?=
 =?utf-8?B?c2hMcmF0VTAyYy9DUDFhNXhZRzRFRVB5bFEzSUx1bnpWczJTdUR2WG1VYnE3?=
 =?utf-8?B?TzRuUFNTVk5ObG1GR3htdW5iSnM4ZEs0c3lib24waHRoTHJOMTQzT0lRVm1a?=
 =?utf-8?B?ZUYwRlI0ZVJsZHZpS2ZXWVo3MkJTR1Q4K3VCUys5UHhja1BYQTVPZXE0K2FV?=
 =?utf-8?B?VHAra0xSYWFWS1E0VHovYStNVGZITW81aE5hR1F6NS9Hd2luWURXaGsvK0U3?=
 =?utf-8?B?Y3NjR2k5eDFUYkNqT0p0ZEdIVGd1ZFp1NmxyVmVLd3N5dUg1N1JGSWFYY1R0?=
 =?utf-8?B?VU14dUUrT1JzSnM1bmFhUnhRVlc4eUxzSnp2bFp2bnFNSnpqb3RFTGVTTlJu?=
 =?utf-8?B?SUR1eitqSjlVSWZmTS9Cc1YwWmc4VXdiYUpPMzgvbERmbjBvK3JMNUlpUGxP?=
 =?utf-8?B?ZjNBNFZIcEJqbUdJSmN5dCs5SG91ODFBajJOZHJ6dEFSTERWdjc4YnhwRjQz?=
 =?utf-8?B?cmdhRGsvL3YzZEJiS1VPTmlqTEl2Q2JnWFE5NTlpekFSUnNyRXpmeGhLVzl5?=
 =?utf-8?B?cDErZFI5SEdFOWRUSTVWM2lEVEpINEJHVjVjVmJUeEx3eFR5VE9xZmtsUHF0?=
 =?utf-8?B?YTVvb3lsZUxsa1JPSTM0M1hKQzJlZEFZZTV4SWtOYjErZVB4UlF5ejllTita?=
 =?utf-8?B?WFo5ck5obUxLUmhYblgrVGJKVGhmTEFRbnk5SDkvQ0VCa3hzalE2b0hBSXhn?=
 =?utf-8?B?RE16Q1FvbkQ5b1l4QThLNk16MVBqN2x0MnhBb2JGOU5tdHhVZVd1Q0VHZzBu?=
 =?utf-8?B?MnVJdXBNZlBweGFwcVhvam9EVGZHTVoxem9HWm12dnRJSmo4aWQxeDFEL3ly?=
 =?utf-8?Q?dEnktB8oCiy3A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6b4fd8-f1ed-4329-92ba-08d8a314b0c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 05:20:53.1921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HO73YOqXAYv7tObnjcwearcmXrao8Nnz8HivYL/hmVQFKdse/eNLYwE6n4n0p4bUlPQgrYZ2nyeJDoaPJM3yCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4228
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608268856; bh=xbSz2O+KnwExif2h0BqwqKFiVv1Mw109tM897oe+4F0=;
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
        b=HJ10/qGQZxMFpVrLtuuVB38IS4JTr7Y+SD145L+VP3Iy8l7fmDgUsn1YxdHIZgPTb
         EaAt0jsrSzMd6XngxUVLVbS7DTfSJrVOoVc7kaCyvEn4o5gBJH/y45vstzrsY8uk4U
         k02nO5GRLf4M3iFalC1+i0b0XNIZ3yiaXKFv2B+kPl6GsnQr6WzFfWKSboL83iHee8
         i6HmYDo3q2aD9PtpBlbCs5lIKnvX2nJbdLRqmntAiJ8pTjI4aU61b+xnmu5ZGkH5JQ
         vLMRAw5VXFvv7b+Mi6Nb+a0XS5HZBf9WOObeomj0krrfn+umMsDQhToVGxHwrQfyn4
         VOo1qYU+JlXpg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4g
U2VudDogRnJpZGF5LCBEZWNlbWJlciAxOCwgMjAyMCA4OjQxIEFNDQo+IA0KPiBPbiBUaHUsIERl
YyAxNywgMjAyMCBhdCA1OjMwIFBNIERhdmlkIEFoZXJuIDxkc2FoZXJuQGdtYWlsLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPiBPbiAxMi8xNi8yMCAzOjUzIFBNLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IFRoZSBwcm9ibGVtIGlzIFBDSWUgRE1BIHdhc24ndCBkZXNpZ25lZCB0byBmdW5jdGlvbiBh
cyBhIG5ldHdvcmsgc3dpdGNoDQo+IGZhYnJpYyBhbmQgd2hlbiB3ZSBzdGFydCB0YWxraW5nIGFi
b3V0IGEgNDAwR2IgTklDIHRyeWluZyB0byBoYW5kbGUgb3ZlciAyNTYNCj4gc3ViZnVuY3Rpb25z
IGl0IHdpbGwgcXVpY2tseSByZWR1Y2UgdGhlIHJlY2VpdmUvdHJhbnNtaXQgdGhyb3VnaHB1dCB0
byBnaWdhYml0DQo+IG9yIGxlc3Mgc3BlZWRzIHdoZW4gZW5jb3VudGVyaW5nIGhhcmR3YXJlIG11
bHRpY2FzdC9icm9hZGNhc3QgcmVwbGljYXRpb24uDQo+IFdpdGggMjU2IHN1YmZ1bmN0aW9ucyBh
IHNpbXBsZSA2MEIgQVJQIGNvdWxkIGNvbnN1bWUgbW9yZSB0aGFuIDE5S0Igb2YNCj4gUENJZSBi
YW5kd2lkdGggZHVlIHRvIHRoZSBwYWNrZXQgaGF2aW5nIHRvIGJlIGR1cGxpY2F0ZWQgc28gbWFu
eSB0aW1lcy4gSW4NCj4gbXkgbWluZCBpdCBzaG91bGQgYmUgc2ltcGxlciB0byBzaW1wbHkgY2xv
bmUgYSBzaW5nbGUgc2tiIDI1NiB0aW1lcywgZm9yd2FyZA0KPiB0aGF0IHRvIHRoZSBzd2l0Y2hk
ZXYgcG9ydHMsIGFuZCBoYXZlIHRoZW0gcGVyZm9ybSBhIGJ5cGFzcyAoaWYgYXZhaWxhYmxlKSB0
bw0KPiBkZWxpdmVyIGl0IHRvIHRoZSBzdWJmdW5jdGlvbnMuIFRoYXQncyB3aHkgSSB3YXMgdGhp
bmtpbmcgaXQgbWlnaHQgYmUgYSBnb29kDQo+IHRpbWUgdG8gbG9vayBhdCBhZGRyZXNzaW5nIGl0
Lg0KTGludXggdGMgZnJhbWV3b3JrIGlzIHJpY2ggdG8gYWRkcmVzcyB0aGlzIGFuZCBhbHJlYWR5
IHVzZWQgYnkgb3BlbnZzd2ljaCBmb3IgeWVhcnMgbm93Lg0KVG9kYXkgYXJwIGJyb2FkY2FzdHMg
YXJlIG5vdCBvZmZsb2FkZWQuIFRoZXkgZ28gdGhyb3VnaCBzb2Z0d2FyZSBwYXRjaCBhbmQgcmVw
bGljYXRlZCBpbiB0aGUgTDIgZG9tYWluLg0KSXQgaXMgYSBzb2x2ZWQgcHJvYmxlbSBmb3IgbWFu
eSB5ZWFycyBub3cuDQo=
