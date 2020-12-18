Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD242DE8A5
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgLRSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 13:01:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4120 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgLRSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 13:01:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdcee620001>; Fri, 18 Dec 2020 10:01:06 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 18:01:05 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 18:01:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/tt0R8bhqvjI8v1goGI18rEPJBUn5Lzu7vQpL5A30ZaF4yX9YpSiwjY0+lVK4Ja4HmvHCH1Hb9KgZkQcfg2lbWOUSKQevnl5LoqeH01lMuDeGL6wuff/kSi+foaKAFKh2Pc/rTp5eG2GeKeeVBffWex2GvX+OzSI/q8FLzmSaquOvOogcg4RxJ8w/H29oNIa+kfskN0sZeWF7PUHoKdQBMh6bRedjQxSXxCuJSU+lDmz5nA39v3SdJAG83Eclk6bgUyuYevgolGpnNUFPPgI8xDTIvZ1doQsLC+OHqSYyqOZLP837h9dZXrWVssji10+ln26lgAZfSV/gOKir/eCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+AebZS3GeoTWCS5Je9XEr/CdiIdHR7E8V2avxhUaoA=;
 b=M1PBwPpn+qLwXY8qKGwaAz8TAlHsp496bzYzjAIanazztmSpuwvE2GofTbGwRRJ9ML26iLLH3XT2dBUMPkYhwp12peMh4X42uSgw/h2mbA/0B/TzclEWA1MgDP+JU2QYKLK79QGocY05Sy8FFV1+WzlOp8h6GIMqieaSQ6VA0qD8slqO/+x1ZWf+rX3oSw3LpYwLhu1C85g2MWEZAO2bcQcNs30KFrpAhIMKnL6bsycqI52guFuRr+v7FA+RVrQGDrjf4ZabRBFg7E2H9Flbz13AuMZQYgEHz6kLp1GLlmttN9aRnkMeGrobAwCK1xhGVEQTmaNQbP+bzEfPtzzegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 18:01:03 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Fri, 18 Dec 2020
 18:01:03 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "Saeed Mahameed" <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
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
Thread-Index: AQHW0mKFU48o8ZNlzEyGRue6Xkj1U6n3ZWwAgABJMwCAANkqgIAAFw4AgAASXQCAACxXAIAAIWYAgAAMc4CAABNrgIAAnGiAgAAx5QCAABY0AIAAGuoAgAATBoCAACZrgIABvk+AgAAcKYCAACOYEIAAs5YAgAAPVgA=
Date:   Fri, 18 Dec 2020 18:01:03 +0000
Message-ID: <BY5PR12MB43223E49FF50757D8FD80738DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
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
 <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0UdtEJ0Xe5icMOSj0dg-unEgTR8AwDrtdAWTKEH4D-0www@mail.gmail.com>
In-Reply-To: <CAKgT0UdtEJ0Xe5icMOSj0dg-unEgTR8AwDrtdAWTKEH4D-0www@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bef4d90e-0250-49b8-1956-08d8a37ee2ba
x-ms-traffictypediagnostic: BY5PR12MB4243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4243A9579F0A251505A85A9ADCC30@BY5PR12MB4243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jo15/3TzcSdQ+iFxnRbQChdXpvRz221tDCqOz9mZBMQoug97c0A0AeZb4xFo3c1ypnCeh4rlhvoVS4BS+GYcMvdl+DGnP7Dq5fpPF/FL9imP1Xxu2Yww/Ll1gj3f2bSTLGPRKOKW86zfUTyEvaC3vw5pmvKyopsijkrjaQ6k4VbrFq8uGnn0ae1Bttibi6n2J3+wYCOp9SHZJUhJqzKoLLHGWOWAQkLdsKKtqrH2Sp6wrOeaBYsicKq8inFGltQS0fCZXHATZqdx7BndrMv5DoNYs94WYHtIa2DqqoMxbEzmtAcSWou3gQ9mv7syCXEGXFj75kZOzVquM5cefmZIHuhtm6IdxEL2CDd/yjpvukaQo6wmYZ3evdp2rytKKt95WhDGTfdp0UBv2YzjKkRRxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(316002)(64756008)(33656002)(7416002)(4326008)(7696005)(76116006)(8676002)(55016002)(5660300002)(83380400001)(2906002)(86362001)(71200400001)(8936002)(53546011)(55236004)(52536014)(6916009)(54906003)(186003)(6506007)(66556008)(66946007)(66446008)(66476007)(478600001)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z1prSU0wSU1pazdKTXhTaXdLMCswYXJ1V2Q0dzR0NWYxdXFwZlNFZWNBVUor?=
 =?utf-8?B?YXo4aTNNMG9UeDVNaDh4ZWxLNitJdE1yZ09ZcTI0TUd2SkUyWVQvbGowOWpF?=
 =?utf-8?B?R3FQZXlTakZpS0ZkcW9sR3FqUG1JYWNHNlV1Y0RPd3RpNHZhU3BrbFpqWlpP?=
 =?utf-8?B?ZG1BcU52NWJBRE1RSURoUmpFM1RmOFptRUs5RG50Y21FSjk4ckJxS29ybmwx?=
 =?utf-8?B?dU10UzJidEhENnR5ZGl3elFydUNkSWNQcm53V1pzSnphUlQrMUpvRDQzZFZw?=
 =?utf-8?B?emhoMkEvUldOOTFYWG9RbWoyTkR5NmQ3SGJIOTVOYzRRYWxERFN2Sno5OXN6?=
 =?utf-8?B?VkFmL2w5c3liU2V3UEhoZjhFMk03T0hpaVBHaE5OL2VUUVQyTS9NNDBZTGZq?=
 =?utf-8?B?UG9rWlBxRHdQSURETDlFS2lSR0dzZTV0bVNUaHdvek5UVzdwTk5yRDkxa09E?=
 =?utf-8?B?bUdIV1h1OXJOa2gva1d3T3Nmc3kyYkRUNmEvQVhOTjVidVppbGs2OTZ3RlFt?=
 =?utf-8?B?MU13RXNuc0V5bW1rSi9rMUFaUkorZHRWNlBwWi9kcTZVYTBEbUR0SEozMUNI?=
 =?utf-8?B?RkZpdHJpZXltcUdDZlpkdHJzZjRRcGNSTjJUMVkxU1c0R1JOazB2b0xGb2V2?=
 =?utf-8?B?Nkt6S2NTVmFkeE5lZFJ1K3h5eEN4WHB6SGxrakdJSXJsT09sY2RLOTlrY2VH?=
 =?utf-8?B?V3lFQkhGaDZiZjNZWTh3cmVUcm01TkVqbWdRNE9LbEJhdFJaa3d1NGd4WVk2?=
 =?utf-8?B?dlptRmU1S00xVGpDM2FleUwxdHFGYkkyaUZOZkd4ZnNVT2xhREhDUFllbUEy?=
 =?utf-8?B?ME12YUVDV3VHR1Rsb0I2YjRzejRYd09ncWhEeHIvbStteStzeEpDRS9rUjdp?=
 =?utf-8?B?SDR3V2gvNFFXOHBqZVJKbWZYL2labisyYnZLQnkyemtSSUowUWU4bFpPWXJj?=
 =?utf-8?B?b0FER3poRTVyR2pqSm5OdHNDWEJaUERtNzkrU0h3ekVKTFZjWGZKYmFvTTAz?=
 =?utf-8?B?UWpxVmk2K2ttVWZjR2NjNzcvVWFHakd3U043VHFaQ1JQL1AzelZXSVVVT0tB?=
 =?utf-8?B?ZjNMaDdFVzZmbHZ0QXRHcWZWbU5jQ1AyUHJhTzF0YVlsODNQeXJTS3RQWFNp?=
 =?utf-8?B?b25pb081WnkyMlZFdWpvTDNOeUZoeDE2TjdNL1JlTVlhNlV1ZFFXUkZ2UjVZ?=
 =?utf-8?B?SjRRRUlDWHBBUnJSbkQ1dWFjYXpyN1J0RmxiOUphbUVBYThKZ3c4NVlRczBO?=
 =?utf-8?B?YkVWeGtwcCtndGxVQ3BMVmV2cUhoVVBMWG5tNVNNcE95M3hrTGp4YzNRdDdH?=
 =?utf-8?Q?vmWk3g9XDbh7Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef4d90e-0250-49b8-1956-08d8a37ee2ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 18:01:03.6953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7vBrxbnl+xBCKaHKCIhmg9iox3AP/0av5YUbkbbSFbtI6/pH/BGgP/FMt0I+DZj/rzQsFAoI7aEnnbFUuG+dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608314466; bh=q+AebZS3GeoTWCS5Je9XEr/CdiIdHR7E8V2avxhUaoA=;
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
        b=IYUvybK2zjN4CPHknQIapKIX4qi0aPLxBigipKwOLxpfP3BXuopTO1bsOFfMGjHPN
         9eR4Se9ircYvsOwpbEkg3SP3GIIZKT4bAahWVEPSwG4CREDPQVYQ5uj7ZhRWBN3sI2
         MrsUQT0ag45tCQnt+HHg/iYHV4mxOvdihQA6AP/iDBnLwGdtwpDUlvlfkLZ7ZpWToI
         vglShgYzamVDKHtSUbfi0k0xxZA2uos3alTLtTFsjQxaOz2cYW+xc9nHKakm1ywdzZ
         HjwkSRtrKgK4fw7wHvsJe5yKW/z4FosIMXfYX/qdv+eyhTAvloJfVOS1WseW+KHppy
         LxFadqzwMuiQQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyLmR1eWNrQGdtYWlsLmNvbT4NCj4g
U2VudDogRnJpZGF5LCBEZWNlbWJlciAxOCwgMjAyMCA5OjMxIFBNDQo+IA0KPiBPbiBUaHUsIERl
YyAxNywgMjAyMCBhdCA5OjIwIFBNIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPg0KPiA+ID4gRnJvbTogQWxleGFuZGVyIER1eWNrIDxhbGV4YW5kZXIuZHV5
Y2tAZ21haWwuY29tPg0KPiA+ID4gU2VudDogRnJpZGF5LCBEZWNlbWJlciAxOCwgMjAyMCA4OjQx
IEFNDQo+ID4gPg0KPiA+ID4gT24gVGh1LCBEZWMgMTcsIDIwMjAgYXQgNTozMCBQTSBEYXZpZCBB
aGVybiA8ZHNhaGVybkBnbWFpbC5jb20+DQo+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBPbiAx
Mi8xNi8yMCAzOjUzIFBNLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6DQo+ID4gPiBUaGUgcHJvYmxl
bSBpcyBQQ0llIERNQSB3YXNuJ3QgZGVzaWduZWQgdG8gZnVuY3Rpb24gYXMgYSBuZXR3b3JrDQo+
ID4gPiBzd2l0Y2ggZmFicmljIGFuZCB3aGVuIHdlIHN0YXJ0IHRhbGtpbmcgYWJvdXQgYSA0MDBH
YiBOSUMgdHJ5aW5nIHRvDQo+ID4gPiBoYW5kbGUgb3ZlciAyNTYgc3ViZnVuY3Rpb25zIGl0IHdp
bGwgcXVpY2tseSByZWR1Y2UgdGhlDQo+ID4gPiByZWNlaXZlL3RyYW5zbWl0IHRocm91Z2hwdXQg
dG8gZ2lnYWJpdCBvciBsZXNzIHNwZWVkcyB3aGVuIGVuY291bnRlcmluZw0KPiBoYXJkd2FyZSBt
dWx0aWNhc3QvYnJvYWRjYXN0IHJlcGxpY2F0aW9uLg0KPiA+ID4gV2l0aCAyNTYgc3ViZnVuY3Rp
b25zIGEgc2ltcGxlIDYwQiBBUlAgY291bGQgY29uc3VtZSBtb3JlIHRoYW4gMTlLQg0KPiA+ID4g
b2YgUENJZSBiYW5kd2lkdGggZHVlIHRvIHRoZSBwYWNrZXQgaGF2aW5nIHRvIGJlIGR1cGxpY2F0
ZWQgc28gbWFueQ0KPiA+ID4gdGltZXMuIEluIG15IG1pbmQgaXQgc2hvdWxkIGJlIHNpbXBsZXIg
dG8gc2ltcGx5IGNsb25lIGEgc2luZ2xlIHNrYg0KPiA+ID4gMjU2IHRpbWVzLCBmb3J3YXJkIHRo
YXQgdG8gdGhlIHN3aXRjaGRldiBwb3J0cywgYW5kIGhhdmUgdGhlbQ0KPiA+ID4gcGVyZm9ybSBh
IGJ5cGFzcyAoaWYgYXZhaWxhYmxlKSB0byBkZWxpdmVyIGl0IHRvIHRoZSBzdWJmdW5jdGlvbnMu
DQo+ID4gPiBUaGF0J3Mgd2h5IEkgd2FzIHRoaW5raW5nIGl0IG1pZ2h0IGJlIGEgZ29vZCB0aW1l
IHRvIGxvb2sgYXQgYWRkcmVzc2luZyBpdC4NCj4gPiBMaW51eCB0YyBmcmFtZXdvcmsgaXMgcmlj
aCB0byBhZGRyZXNzIHRoaXMgYW5kIGFscmVhZHkgdXNlZCBieSBvcGVudnN3aWNoDQo+IGZvciB5
ZWFycyBub3cuDQo+ID4gVG9kYXkgYXJwIGJyb2FkY2FzdHMgYXJlIG5vdCBvZmZsb2FkZWQuIFRo
ZXkgZ28gdGhyb3VnaCBzb2Z0d2FyZSBwYXRoDQo+IGFuZCByZXBsaWNhdGVkIGluIHRoZSBMMiBk
b21haW4uDQo+ID4gSXQgaXMgYSBzb2x2ZWQgcHJvYmxlbSBmb3IgbWFueSB5ZWFycyBub3cuDQo+
IA0KPiBXaGVuIHlvdSBzYXkgdGhleSBhcmUgcmVwbGljYXRlZCBpbiB0aGUgTDIgZG9tYWluIEkg
YXNzdW1lIHlvdSBhcmUgdGFsa2luZw0KPiBhYm91dCB0aGUgc29mdHdhcmUgc3dpdGNoIGNvbm5l
Y3RlZCB0byB0aGUgc3dpdGNoZGV2IHBvcnRzLiANClllcy4NCg0KPiBNeSBxdWVzdGlvbiBpcw0K
PiB3aGF0IGFyZSB5b3UgZG9pbmcgd2l0aCB0aGVtIGFmdGVyIHlvdSBoYXZlIHJlcGxpY2F0ZWQg
dGhlbT8gSSdtIGFzc3VtaW5nDQo+IHRoZXkgYXJlIGJlaW5nIHNlbnQgdG8gdGhlIG90aGVyIHN3
aXRjaGRldiBwb3J0cyB3aGljaCB3aWxsIHJlcXVpcmUgYSBETUEgdG8NCj4gdHJhbnNtaXQgdGhl
bSwgYW5kIGFub3RoZXIgdG8gcmVjZWl2ZSB0aGVtIG9uIHRoZSBWRi9TRiwgb3IgYXJlIHlvdSBz
YXlpbmcNCj4gc29tZXRoaW5nIGVsc2UgaXMgZ29pbmcgb24gaGVyZT8NCj4gDQpZZXMsIHRoYXQg
aXMgY29ycmVjdC4NCg0KPiBNeSBhcmd1bWVudCBpcyB0aGF0IHRoaXMgY3V0cyBpbnRvIGJvdGgg
dGhlIHRyYW5zbWl0IGFuZCByZWNlaXZlIERNQQ0KPiBiYW5kd2lkdGggb2YgdGhlIE5JQywgYW5k
IGNvdWxkIGVhc2lseSBiZSBhdm9pZGVkIGluIHRoZSBjYXNlIHdoZXJlIFNGDQo+IGV4aXN0cyBp
biB0aGUgc2FtZSBrZXJuZWwgYXMgdGhlIHN3aXRjaGRldiBwb3J0IGJ5IGlkZW50aWZ5aW5nIHRo
ZSBtdWx0aWNhc3QNCj4gYml0IGJlaW5nIHNldCBhbmQgc2ltcGx5IGJ5cGFzc2luZyB0aGUgZGV2
aWNlLg0KSXQgcHJvYmFibHkgY2FuIGJlIGF2b2lkZWQgYnV0IGl0cyBwcm9iYWJseSBub3Qgd29y
dGggZm9yIG9jY2FzaW9uYWwgQVJQIHBhY2tldHMgb24gbmVpZ2hib3IgY2FjaGUgbWlzcy4NCklm
IEkgYW0gbm90IG1pc3Rha2VuLCBldmVuIHNvbWUgcmVjZW50IEhXIGNhbiBmb3J3YXJkIHN1Y2gg
QVJQIHBhY2tldHMgdG8gbXVsdGlwbGUgc3dpdGNoY2V2IHBvcnRzIHdpdGggY29tbWl0IDdlZTNm
NmQyNDg2ZSB3aXRob3V0IGZvbGxvd2luZyB0aGUgYWJvdmUgZGVzY3JpYmVkIERNQSBwYXRoLg0K
