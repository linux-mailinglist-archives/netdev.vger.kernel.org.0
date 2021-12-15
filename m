Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3984760AC
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhLOS0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:26:41 -0500
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:26496
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231138AbhLOS0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:26:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUBKA2eQQmehgqqjkOgyNxEz1o2UVKSeiPFA6czsx4LmqQFyMbSsM+Kl/3WTt9X89P1pPY/5+zp1iRl7BGXXfdYtLeqqtC+9dLRmeNU5Z4G4UL6r9fuDIdnm5kiEYv8vlfhnwx9PExeBwj7gGXURPL7eWc8uTdSWriywRSfZCxIWqDGFJVeHbaHnDHko8w8f8yDHOJrsWyZIwh3FmReyL2Oa8bNBVRHJMkw988Au4zhyeqyMtQdyt6bVeuoPlHnrPrKIOyT0YI7LjWgWDG/s0zUn4/fr3Q2jufPvhIvpH0pFowEiRl/Q9N+TKQWcHFZP8FNWBdng3o4enZgZlYVDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+6QqI3T3ioaS8t+cODJOvHYqJiamd/0DtIb5yFmrRM=;
 b=CwgG6DEOiTnSiH88gCro9i80vURtyv/AOq0DZKViKSj1857tEjrjUhAclN1AdxqMeqb8ehEWafD9JzgwBkx2QCpEC1yVfoRpW3buX2xqOePPUHVOPJD4Ms4zWjlVTXhELEFNxPxT1gfn3MsQHBdWCV9dyTuGDm/SdM7aRkIBOQWdmyzDPFRRsdD8ukJ3SocAdefZJR6IqQd1L5IGLu+fNzIGpx27gtX0gJO4XdF+L8Y/EjNCI+qlRPiH95116Ed9Sd9pf77vnTKSawcKEToTs+xYVKvUWI82udZtJ+raV4zu2TN/k1WDq1heAyenHw5CLJogz/ElkI2SoRj/R+MPAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+6QqI3T3ioaS8t+cODJOvHYqJiamd/0DtIb5yFmrRM=;
 b=MoU9zToaaKoghcmYTu9kMkcjtwi9qe5asYv7PFJLSV/yT0wESJU8gMHmCyimXKiCc6TmIAOu5lym+GhKJvlkhe1ZHhMRCk21/el2Ml8KM8GD/gfkXITbjgsJMLTZBjbsxf8GsNwErAwESU2dVWNvkbARj/4uJlo1vEqHcgnYFoJ53bxbo2Y+xs3xKYbZ2mGB6zsG1iXt/pXAYUXjSX54lrYOvTZsTfWwDzrq6XA8GD5xg2mQIxeNvTthMGd4L5cS4EyrMbdRZ8kWALN4KY0HIGOv8qzINMsa3MTpn0NywWWjoKO3yRymB0RSiRzSHt7BtgKs1wSp1lV24+rJ/f+iGQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4017.namprd12.prod.outlook.com (2603:10b6:a03:1ac::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Wed, 15 Dec
 2021 18:26:37 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 18:26:37 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Shay Drory <shayd@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/7] net/mlx5: Memory optimizations
Thread-Topic: [PATCH net-next v3 0/7] net/mlx5: Memory optimizations
Thread-Index: AQHX7D5dD+adttVerk2gBbMZG9h/QKwxE52AgAAgOwCAArZBAA==
Date:   Wed, 15 Dec 2021 18:26:37 +0000
Message-ID: <c55710e02f732b46fa5c48bb65b7eab23ee3c5ce.camel@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
         <160c22e7ee745e44b4f37d53003205d8f63b8016.camel@nvidia.com>
         <20211213170146.24676fa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211213170146.24676fa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a583347f-5766-4c8f-e901-08d9bff86e9b
x-ms-traffictypediagnostic: BY5PR12MB4017:EE_
x-microsoft-antispam-prvs: <BY5PR12MB40174E3BF9BF8DED18526389B3769@BY5PR12MB4017.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kb5rOhdN7tU8fPAp5+p0rAyRjGhQrnH39GXZbOUmR1X+4W93isD/up1v7Pm9SSd7gmq7ilp3wFCM4Gjgr7ppc9h164brAfNnv5RTUyZotVIG9De+XXdJFfay6UvXI/EOX05zSWYsNTxBu6oYh6I0c4zCH65bmiuKL+memYUbK0W12AgilO82Gzz5/ullDkhNoBI6B5e2YS09aU6mi9rgk10+wTwazFJtqS8ybgyjNJrTvK2Ik2a0fbTpLYvxwAPw6bZGmAge0ZJMfzCGq3SnfOl/m89ImBDiW7wQLr4zhq1Zxh6MdJiPRbzEzV+0UHOGkZUi0KlYJGiyKOKZnGsI3h9/TG22a+3yp1RLqcIC5KXSnZY2g1jnF2/S5kalI3e9Hg6Nj9NpzrDWR7v9hlz5l8jyJlwOFzoftyOkvumwHfzYszrHlgiQc0sqkymuV7s2u7pBI93mZULb4vPJfk+bDtiJAmjvCy1QU0crhtIkN/9ED6BrTGRPX8wv5cD4LBKWiga6dNBRyKsKd95AyQJ5ocsx0F6aUaXbLbV/m68CaeQhoQCDCGE3WzRxhzDLoGEUDD+oK2CsKq+M2RrM2gThW7kXtTy3+P3YlVLr3PBMz4oAWBygnpSJfQsiUeASo3X54yJpLDLxS/mhL7Kcm02eLQXoWkgZbCJPnB8dAb2yeKITokk+tqDsYRxoGioZqX1GIoBpvEHYKyfo0ZhvL3lDHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66446008)(508600001)(38100700002)(76116006)(38070700005)(2616005)(86362001)(66946007)(36756003)(6506007)(54906003)(2906002)(5660300002)(8936002)(6486002)(122000001)(6916009)(66556008)(316002)(186003)(64756008)(26005)(66476007)(4001150100001)(4326008)(71200400001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDRNUEhHbTBVdHZ2QUdVSFVEVzdsSGk0K01oZXVtcEQ4SkNmYzRZM2RWOWJ0?=
 =?utf-8?B?THYvWG8xNm1VeEIrbGoyNHc1bnZnaVZ5WExqNm1VTFFZeUV5M0Nhb1lxWDNN?=
 =?utf-8?B?d0FnWGVRYkd2WnNLZk5PVlkwK2JuS1VYVE15akxVUXR1OGtGQXZOSlFLT2E3?=
 =?utf-8?B?bld4TStEci9BRGtKTUJaRUdQc2lXVUlpa0FDajBNUzBXZ3E4MnRTS2RkMXVK?=
 =?utf-8?B?c2NmWG1INEJwWTlDcTRKUllpQVVlc3dvZ1Myc2hTUmswVlZzdzI3WmxxSVBN?=
 =?utf-8?B?TloyNEFiUnUxVWJWYkkvMjhyNlBxZ203Z1YzNkdxc3p3ak4wR3VnbnlQQUIw?=
 =?utf-8?B?UmhwSnR1T2tVWU1QaVZuLzAxRDd4NEVmVGx2R29pM1lZQS9Na1B2Sm1IS0dS?=
 =?utf-8?B?OWdHQ1JBaEt4di9raXNTbk1uQXhpUkExaEVuV0lQaWk5N3ZLVW5UYXpTeWg3?=
 =?utf-8?B?eXlQMGtGSE5mRnI1ODZGblR1bnErNFZjZmg4VWNnWlBFbW9WWTJtRlJOMVdM?=
 =?utf-8?B?YnYvRjl2d1pYbTVUTngyV0RxK3NXT0xtV3hreUdITElweUs4NVRucXBSajd5?=
 =?utf-8?B?Q2xPWXovOEEvblRSM1ptbnFndmFSR0ZyTHBVcWRYQm5sV2o4UlFNbXdrN21P?=
 =?utf-8?B?eEN2TTlVZ2ZQL2pKdnZ6cnc3bHJyTFFpZnNDbFhqbkZsVnNPNnlvT3JuU25v?=
 =?utf-8?B?QTJBb21pa0VXUXc2c2o4amR2MVV5SEU1OGNuT3libXJIOTZ3QzdibmorcVhq?=
 =?utf-8?B?b3QxcG4vbm45UDBwTFBzbGRsanNVMjBocjhBdzdlMDJ0ZVBZM0lMVEpOZEVF?=
 =?utf-8?B?SXI4cDdHQjMrQVJwZTNDRUQ0SE1sVC92YngvRjZGdzFLU3V1bkhLd2VVYUQ2?=
 =?utf-8?B?c3luYU40U0lvaC9rYzJJa1loRUluVzN6c3h4VjRaSXEyb0l5UGY3NVFKMGRE?=
 =?utf-8?B?bDRBUW9Hd0ZRSGZ5NmRCL0gxVnZZNTJZS1ZQMm1nVk5TS0VsbTU3SE92MXJ5?=
 =?utf-8?B?eTB5eVd4cEgybUI2VXliYkdhV3d2RHYxVzJFWkxQN3VNWVJGZnR1VDdFRi96?=
 =?utf-8?B?TnpJR0E5dU9iYUVRWm5YZW5jNWZoMjROVXVxZFJaaTFGMnBHTkNWMnM3aity?=
 =?utf-8?B?bjJld1pMZEw0TU1oemdRVzVqQmEyd2p5bzJnd3orM3NvZUZIMFZRbHlXUUky?=
 =?utf-8?B?cFQxVFkreWJiM1Y5K0pjY0xvclpEQkp1VFFmak9ndDNqblcyUDlCWkh0ajV6?=
 =?utf-8?B?ME8vVk5EUExpa09vQzlqc3RoK29CdFAxWVR2dEZrejBUR0JxbUNpVHh2b2NU?=
 =?utf-8?B?ZEhoWkxVZm55djd4Szl0c0hvbDVyeEJIVDdJV0t1eEpuRXhWV2YzRlRoeGdP?=
 =?utf-8?B?ZVU2VUZTMXArbkZrQ0s4MnpGZlNDSStHLzMwRTUzVDJpRmNxVGFsa0trcGpQ?=
 =?utf-8?B?eThvb0NtbDRPbjRIZ1pkL2toMHltZnhRVDdYMjJwcmJrcS80a05jVlNvZ2VD?=
 =?utf-8?B?UDU4OEwveUc1aDM4TTJtSXhXQ3ErWmpQVGhsSERCV1M5bHhYbTl2dmoyMVIy?=
 =?utf-8?B?OTMvS2o0REtDU2hlNTRtK2V3RXZBb1JocnVyUElzNWhwQjZnTjM5SnBqRks5?=
 =?utf-8?B?WEh3YXBacERyRHdtRGcwU21SclIzSXA4dmx1cE9iWk1WZlpPMHNrV2c5NTdM?=
 =?utf-8?B?dEw4a3hNRWZpMDMxTTg5RnRzWGR0bWZ6VVVqaHIwdWVoem1ZWHNxQloxSmVO?=
 =?utf-8?B?MFBvK29QNkZGUEFha3RlVTlRRlFPR3g0SjlLZE0yMmVSUDdaWVBWWGExNWI0?=
 =?utf-8?B?NTBlU1NIL0swZGdLeldQMngwK255eXJNOTl1emNnR0FRbWE1aXBLa3lOWGw4?=
 =?utf-8?B?dzNXVUxQNGxwd09jL1hOVG1CeTlBZG1nd3BKb21HY09wMVRSVVRIS2RPUVZP?=
 =?utf-8?B?NWhKaVp0TkZYMlVLZUlza1F3T05FWXBDcXAra0MvbTNhRzhnNWpXdHpLeThj?=
 =?utf-8?B?ay9BNlNUbEJVaUR2VTB4bUFQVG05ajk0Q1RyNC8yMmpVSXNuV095ZFhrcU94?=
 =?utf-8?B?clFUUGhSR2JVNlhyTzBCdzQ3eUhBSGdiMTZIMzdDQ1lEUTF3cUZ6QlJLancv?=
 =?utf-8?B?YlNtQTcvMWJoK1NBTHQ4TEtjNzRyM2hybXJ1VGFqMUVRZjdlNkR3d3g0T1NN?=
 =?utf-8?Q?N5VIJHLEn+QVw/EGHrAIPM1aRmv9WpViuDpKXdzEHIx4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1650561D0B9C51488703C9CA68E8DCAA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a583347f-5766-4c8f-e901-08d9bff86e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 18:26:37.6807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g931mSvWSP6FNIglC7WPG4dj1qUicroExOm11vvP8rPaunswOeedIqPa3EvbFH7I2U4rUlty0oXtmVfswYb9kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4017
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTEyLTEzIGF0IDE3OjAxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxMyBEZWMgMjAyMSAyMzowNjoyNiArMDAwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBPbiBXZWQsIDIwMjEtMTItMDggYXQgMTY6MTcgKzAyMDAsIFNoYXkgRHJvcnkgd3Jv
dGU6DQo+ID4gPiBUaGlzIHNlcmllcyBwcm92aWRlcyBrbm9icyB3aGljaCB3aWxsIGVuYWJsZSB1
c2VycyB0bw0KPiA+ID4gbWluaW1pemUgbWVtb3J5IGNvbnN1bXB0aW9uIG9mIG1seDUgRnVuY3Rp
b25zIChQRi9WRi9TRikuDQo+ID4gPiBtbHg1IGV4cG9zZXMgdHdvIG5ldyBnZW5lcmljIGRldmxp
bmsgcGFyYW1zIGZvciBFUSBzaXplDQo+ID4gPiBjb25maWd1cmF0aW9uIGFuZCB1c2VzIGRldmxp
bmsgZ2VuZXJpYyBwYXJhbSBtYXhfbWFjcy4NCj4gPiA+IA0KPiA+ID4gUGF0Y2hlcyBzdW1tYXJ5
Og0KPiA+ID4gwqAtIFBhdGNoLTEgSW50cm9kdWNlIGxvZ19tYXhfY3VycmVudF91Y19saXN0X3dy
X3N1cHBvcnRlZCBiaXQgDQo+ID4gPiDCoC0gUGF0Y2hlcy0yLTMgUHJvdmlkZXMgSS9PIEVRIHNp
emUgcGFyYW0gd2hpY2ggZW5hYmxlcyB0byBzYXZlDQo+ID4gPiDCoMKgIHVwIHRvIDEyOEtCLg0K
PiA+ID4gwqAtIFBhdGNoZXMtNC01IFByb3ZpZGVzIGV2ZW50IEVRIHNpemUgcGFyYW0gd2hpY2gg
ZW5hYmxlcyB0byBzYXZlDQo+ID4gPiDCoMKgIHVwIHRvIDUxMktCLg0KPiA+ID4gwqAtIFBhdGNo
LTYgQ2xhcmlmeSBtYXhfbWFjcyBwYXJhbS4NCj4gPiA+IMKgLSBQYXRjaC03IFByb3ZpZGVzIG1h
eF9tYWNzIHBhcmFtIHdoaWNoIGVuYWJsZXMgdG8gc2F2ZSB1cCB0bw0KPiA+ID4gNzBLQg0KPiA+
ID4gDQo+ID4gPiBJbiB0b3RhbCwgdGhpcyBzZXJpZXMgY2FuIHNhdmUgdXAgdG8gNzAwS0IgcGVy
IEZ1bmN0aW9uLg0KPiA+IA0KPiA+IEpha3ViIGFyZSBvayB3aXRoIHRoaXMgdmVyc2lvbiA/DQo+
ID4gSSB3b3VsZCBsaWtlIHRvIHRha2UgaXQgdG8gbXkgdHJlZXMuDQo+IA0KPiBZdXAsIGdvIGZv
ciBpdC4gU29ycnkgSSBkaWRuJ3QgYWNrIC0gSSB3YXMgZ29pbmcgdG8gYXBwbHkgaXQgdG9kYXkN
Cj4gYnV0DQo+IERhdmUgcmVtaW5kZWQgbWUgdGhhdCB5b3UgcHJvYmFibHkgd2FudCB0byB0YWtl
IGl0IHRocnUgeW91ciB0cmVlLg0KDQpUaGFua3MgISBhcHBsaWVkLiBXaWxsIGJlIHNlbnQgaW4g
ZnV0dXJlIFBScy4NCkZpcnN0IHBhdGNoIG5lZWRzIHRvIGdvIHRvIG1seDUtbmV4dCBzaGFyZWQg
YnJhbmNoIHdpdGggcmRtYS4NClNvIHRoaXMgd2lsbCBiZSBzZW50IGluIHR3byBzZXBhcmF0ZSBQ
UnMuDQoNCg0KDQoNCg0KDQo=
