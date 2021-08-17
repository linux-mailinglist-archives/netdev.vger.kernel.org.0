Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C1D3EEB0D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 12:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhHQKgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 06:36:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:19823 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235939AbhHQKgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 06:36:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="215764237"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="215764237"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 03:35:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="471116758"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga008.jf.intel.com with ESMTP; 17 Aug 2021 03:35:31 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 17 Aug 2021 03:35:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 17 Aug 2021 03:35:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 17 Aug 2021 03:35:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4XYZKKE9VJXRtxldCDQ4Dvo1HCeBToXh3bFCukB1KloShbS8I2eSKwAiJhnns9oDGt/2tdThQVW60epIBJN1WmmOLo7gFRbhg9ZBPH1aZZtAtiNM2INrmd6UFIJBXtzqJhUPexT4D1LslZvEQW4sRyQ49NXOvZahWaZGkw4zt6/hfOAiAxwg+I09L1oRqoiqs/IFq9lahWNqzrFZqCyz+KAR2LmiQMn4SbJYqLjhdB6E+OUu6x3z195fHj9uR9az1Gxj0dLuMEiJ/MEFDomnyHDLiDUXvsb8AAscRXa9uYeVwoy25fm9pQNYBFg7+IAdE1SUll4BOjhL+JQGWsHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTp/pZZIPNptuVBq057+2MdDNdR3s+IpCh3FQdrJwrQ=;
 b=HpR9uTlyumQjHWn6Ky5AlInXXeCR5GXGpo7VU6rcgzZJsOHvxiznGmeiDyBSto5LQfF8YzrI9R4/ZCWaTh7TboBQf66gWqdCbgXsvVYSIw5zz99qSeCd1pmPiDqtVxDu+yrzWuMgYQOIGLbsb+z1z/yu/IlxAmAXS4oZV5fQlUNk7oqtaNcoBPa282s5y7YlBGGxakYAeK3hcJQhCjtMdN/sItB6p16tmPAesvWcpOx5iSnzfiscSQeSz0ottOQy72OdjVMxeOxVE7thwPqLj1Xv+g+wKvMu3kRvg4p4c9N+6+O81sZgA7hFRRHEPxYqDTKQiLFFIvh5AfZ6e0rdag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTp/pZZIPNptuVBq057+2MdDNdR3s+IpCh3FQdrJwrQ=;
 b=WTM/QE1/9O/Zyun7mYnCODFcNp4tkUkAv6UBelXEQ5dmIzx+SApQ3l7OODBGoTao65O3tY1kg6xeZypj76nyp7ZFg2QPX2XEvxoGwtXC8PnF9jxjchYLzMou3PVI5gU0gGBB8eTssNgRL5kLMrj90JTRNVYbwNSWj7wIFeEN7Uw=
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM6PR11MB3963.namprd11.prod.outlook.com (2603:10b6:5:19b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.19; Tue, 17 Aug 2021 10:35:29 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::100:e37b:35bb:c213]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::100:e37b:35bb:c213%7]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 10:35:29 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: RE: [RFC net-next 4/7] net: add ioctl interface for recover reference
 clock on netdev
Thread-Topic: [RFC net-next 4/7] net: add ioctl interface for recover
 reference clock on netdev
Thread-Index: AQHXkrpDd8KR4sZrE0SVSHvcdxLd7at2iWmAgAD2LnA=
Date:   Tue, 17 Aug 2021 10:35:29 +0000
Message-ID: <DM6PR11MB4657C563333B755676B3069F9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-5-arkadiusz.kubalewski@intel.com>
 <CAK8P3a0N3N3mFvoPj_fkqOY30uudJceox=uwSW+nd0B0kf8-ng@mail.gmail.com>
In-Reply-To: <CAK8P3a0N3N3mFvoPj_fkqOY30uudJceox=uwSW+nd0B0kf8-ng@mail.gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.0.76
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: arndb.de; dkim=none (message not signed)
 header.d=none;arndb.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d6c9109-d981-4dcb-2ecd-08d9616abbd9
x-ms-traffictypediagnostic: DM6PR11MB3963:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3963065F95528E49C5F9A2059BFE9@DM6PR11MB3963.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DscbYtHjkDLFqM5pklHkz4KiBTuDmet4ZUW63dQi5in/9nn57SlXGaLgC4Y8U6oj6c5SeU3J/7bjo55zcJwcFZTbT0v03Jm05RSOHsZ+DUlrVgW0Jo3npV+m5asnplFMI/9Nh9R7l6p346Db6IKfDK+s+Ush2F6YOPI8nuZ2M8XDwcrWf2fjDPyLSRLrV7MfpqNDj5XvohchcvuNf17H5EzkJWPI1dl+fwrdl9NukFLVQjDE5yVQTemRiX5YzC3akv4z5p5rzG0tnI/Enq7a072D/w5bc8SD3BAsBcgwmUJB6vn+bTfKZj4yCL+IfuUKwfdbv8syhrQ4gKxnic0X5W9ZZRfnOSGo7rYdOniVtqipFUPENZXdh3gNwDL3oPIKVh3rTU39f0La5gvEyBI05426LzBOM0HEaku4pwC/Ji9wPQAsDXgQpMxk6qT1jZyY9DTrJIFWwx8C5kJZGKcdq+n2b9yamFc0UNv9P0/IcuqViMAbFjtUI9KvAK1tlg5K4N2SgGZQGGt0k/dUJ5aDYpOCpnQrmWMHBoWjt3RRIFAMcGnMVBEtJOSNchk4NW09pafYSIui/7kVe0GVliBbY+i7hzEa+Vu/cXbGhv7A18lcIFgK14FmPdpcQnKJph/yi5xNVb+MXkf0qIEArAJ+dTZ1q5LC3joyFXtG5XVOmgXD3j7fnrcaUJbGS5PyHPnW63dwBh9AD5e1UG77FjE8eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(76116006)(5660300002)(7416002)(6506007)(6916009)(186003)(38100700002)(122000001)(4326008)(26005)(66946007)(7696005)(64756008)(66446008)(66476007)(66556008)(478600001)(38070700005)(33656002)(316002)(8936002)(52536014)(86362001)(9686003)(71200400001)(2906002)(54906003)(8676002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVRUWk9ZQjFWU21uZFNvUTZvejVJNVpBQldNN2ZJN0FJTUl2T3VWL2JmWnBm?=
 =?utf-8?B?UmNVbmVJbzJJNUprYm1lNDc4QmYzTDhKL20vdDZlR2c4QWlxbytMemxZNWFQ?=
 =?utf-8?B?dHEzeEVCMU9JOTlxV2hETDIwYklWVzlsQkxDN1dqb3ZZVjVKeEsySzdFaUda?=
 =?utf-8?B?clFiV1NwQ1lYTXFzWjAvTThEL0txKzZTYmNFcGQzU1RlbDg0eG1qODdHVGo5?=
 =?utf-8?B?bE1ZcXZPV1piUHRoY3FmZ0lob2dtSWVwVzNvSk5KYzZ6cGQ4Z2RUNnFxU1BX?=
 =?utf-8?B?RFpBVlNkcjI3a1NiWkNRK0xsQ3Voa0w5R0VNcnRqN2xjdll3VEN3THdGN1NQ?=
 =?utf-8?B?VGVUSmFXd1plUWpERWR0Yms0V1gvNEIrYVIxMG9GLzRuazNLWnhoaFBTc1NQ?=
 =?utf-8?B?OTlIeWpUcWt6STNjNk9Ickw2a2xQVHNJaFBUNGwyM1ArQWpjd1JVbW5SQ0JC?=
 =?utf-8?B?VVpwRWs4bE12NlZWWVJ3VEpZcDM1c3NPWTV1SXhZZWpmaWhNVGI3Y05LMGZl?=
 =?utf-8?B?SWFKZVNBbkdBNkl2SXE2QkUyZXNRcWFyMnFkRnV5ejkvc0hFZzdEUUhwTEVF?=
 =?utf-8?B?bjVwZisxem9KWk1PNURzVFhRbW5QaE02c3RkUUpvaVluQm1jKzNOK2w4b0ll?=
 =?utf-8?B?T1hSUXQvQmpmVE9MQzJEZHh0ck9WU2dkQkppcjQwc0pEN3cvdW9UdjhncGFC?=
 =?utf-8?B?Q0FkTVdISXFhQ05YRldLVlF2OG8vL3NIdnlXbmNiV2g0M1NkWGNjb29UaWI3?=
 =?utf-8?B?QmUvMjA5dVBzSkdaQ2c4VFFWY0ZSUnp5U2pQTHJuMUpiZWlPY1VYRTlPZ1V3?=
 =?utf-8?B?N0VHeHpscGZrN3Bjd1FEeW9LTElDWnJmS1JjdW5wWVdsOUJGVUhZbTFhMTRr?=
 =?utf-8?B?N3JiOGYyRUtmNUxOZXg1Sm5aU3E5Rkg0SmFjM0kyRTZDcTFOWGdPMzNEbjJW?=
 =?utf-8?B?NGxvZmZpYy9FQzk2dmxRZGZySkJEQk9KRGpuRlcrSG9wZ2tVQnVzYjBRcVFE?=
 =?utf-8?B?UzdTUGVUWFRoemR2WW5zZVF0VFkrbFEreGphRUZlRWgxQjU3UU1acU4zczhu?=
 =?utf-8?B?MFg2T0ZKaHNGQW5KZ0RRbzJ2Sm1DSVh4dXp4K1pLeFlPZTdra3ZyUnhZRVJ0?=
 =?utf-8?B?eVk2TlBFUHVCN2p1SjlsT3U4NVBUSzBNRW8xOXhzREUwZFNEVWQ4d21mUUtz?=
 =?utf-8?B?Ry9iK3pmcVBaTUZWT0ovc0tyUktNeDkrdzJtY0hieTB2WXFGd3ovVUFNT3Az?=
 =?utf-8?B?L3U5VmI0MjJiRDhCOXBXT3hoR0x5QXAvMUw4VVRCZi9vcGtBRVgvTVNpRm9I?=
 =?utf-8?B?bFY2YWJndlQxZVBhYWYrbXNZeVQvQzFRdGFhdGF4bVlkdW9qTUV0Z3lVN3hn?=
 =?utf-8?B?Q2dtRHVGejBaMDUyODJDSFNwSmVqZmwzRmR0Ny9iaVhNZlBjdjk0Nks4SHBP?=
 =?utf-8?B?U3MrQ0VSK0NNMjFld0ErbGFWc3JpMzl5RTd5YzhpNDEzM2ZpblBSUkR6YjQ0?=
 =?utf-8?B?Z0dGa3FwODJYb1ZPbUNYdHZhdXFNREFPeGhZN3pMZDRLSGNnY2M1cm0zUlV6?=
 =?utf-8?B?ZHFBTEZDUzd1SWRuMFdaS2pkMDZOVzJ0dGw0eTZ6R0FsZzJJWVMzVjE2RElZ?=
 =?utf-8?B?QytRTTFNWjd0dEtBalJRbGNMSkN3V04xMDlRVWNhbm1Ka05DVUozS1FWMEsv?=
 =?utf-8?B?MGNWQVBTVGpzYzhUdGlBa0RFUFpOUEVTYW80Q0d4dkdyc1hsMVpGN1NkWTZo?=
 =?utf-8?Q?Q1U40OhMS0HXBxcpOmTt/rmnLZBbECarugdZjdN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d6c9109-d981-4dcb-2ecd-08d9616abbd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 10:35:29.4431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RnqNbYFkRcKnh+b0qtN/e/HZ+ZCoCaMXYVxjwPXPrYTD1q/7i9/fq0V1rSsJWvJNVWoiCCA0Iavz2rPfUQdAJwYMaS9f/QDDgyoR6zNaQkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3963
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pk9uIE1vbiwgQXVnIDE2LCAyMDIxIGF0IDY6MTggUE0gQXJrYWRpdXN6IEt1YmFsZXdza2kNCj48
YXJrYWRpdXN6Lmt1YmFsZXdza2lAaW50ZWwuY29tPiB3cm90ZToNCj4NCj4+ICsvKg0KPj4gKyAq
IFN0cnVjdHVyZSB1c2VkIGZvciBwYXNzaW5nIGRhdGEgd2l0aCBTSU9DU1NZTkNFIGFuZCBTSU9D
R1NZTkNFIGlvY3Rscw0KPj4gKyAqLw0KPj4gK3N0cnVjdCBzeW5jZV9yZWZfY2xrX2NmZyB7DQo+
PiArICAgICAgIF9fdTggcGluX2lkOw0KPj4gKyAgICAgICBfQm9vbCBlbmFibGU7DQo+PiArfTsN
Cj4NCj5JJ20gbm90IHN1cmUgaWYgdGhlcmUgYXJlIGFueSBndWFyYW50ZWVzIGFib3V0IHRoZSBz
aXplIGFuZCBhbGlnbm1lbnQgb2YgX0Jvb2wsDQo+bWF5YmUgYmV0dGVyIHVzZSBfX3U4IGhlcmUg
YXMgd2VsbCwgaWYgb25seSBmb3IgY2xhcml0eS4NCj4NCg0KU3VyZSwgd2lsbCBmaXggdGhhdCBp
biBuZXh0IHBhdGNoLCBzZWVtcyByZWFzb25hYmxlDQoNCj4+ICsjZW5kaWYgLyogX05FVF9TWU5D
RV9IICovDQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3NvY2tpb3MuaCBiL2lu
Y2x1ZGUvdWFwaS9saW51eC9zb2NraW9zLmgNCj4+IGluZGV4IDdkMWJjY2JiZWY3OC4uMzJjN2Q0
OTA5YzMxIDEwMDY0NA0KPj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3NvY2tpb3MuaA0KPj4g
KysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3NvY2tpb3MuaA0KPj4gQEAgLTE1Myw2ICsxNTMsMTAg
QEANCj4+ICAjZGVmaW5lIFNJT0NTSFdUU1RBTVAgIDB4ODliMCAgICAgICAgICAvKiBzZXQgYW5k
IGdldCBjb25maWcgICAgICAgICAgICovDQo+PiAgI2RlZmluZSBTSU9DR0hXVFNUQU1QICAweDg5
YjEgICAgICAgICAgLyogZ2V0IGNvbmZpZyAgICAgICAgICAgICAgICAgICAqLw0KPj4NCj4+ICsv
KiBzeW5jaHJvbm91cyBldGhlcm5ldCBjb25maWcgcGVyIHBoeXNpY2FsIGZ1bmN0aW9uICovDQo+
PiArI2RlZmluZSBTSU9DU1NZTkNFICAgICAweDg5YzAgICAgICAgICAgLyogc2V0IGFuZCBnZXQg
Y29uZmlnICAgICAgICAgICAqLw0KPj4gKyNkZWZpbmUgU0lPQ0dTWU5DRSAgICAgMHg4OWMxICAg
ICAgICAgIC8qIGdldCBjb25maWcgICAgICAgICAgICAgICAgICAgKi8NCj4NCj5JIHVuZGVyc3Rh
bmQgdGhhdCB0aGVzZSBhcmUgdHJhZGl0aW9uYWxseSB1c2luZyB0aGUgb2xkLXN0eWxlIDE2LWJp
dA0KPm51bWJlcnMsIGJ1dCBpcyB0aGVyZSBhbnkgcmVhc29uIHRvIGtlZXAgZG9pbmcgdGhhdCBy
YXRoZXIgdGhhbg0KPm1ha2luZyB0aGVtIG1vZGVybiBsaWtlIHRoaXM/DQoNClBlcnNvbmFsbHkg
SSB3b3VsZCB0cnkgdG8ga2VlcCBpdCBvbmUgd2F5LCBqdXN0IGZvciBjb25zaXN0ZW5jeSwgDQpi
dXQgeW91IG1pZ2h0IGJlIHJpZ2h0IC0gbWFraW5nIGl0IG1vZGVybiB3YXkgaXMgYmV0dGVyIG9w
dGlvbi4NCklmIG5vIG90aGVyIG9iamVjdGlvbnMgdG8gdGhpcyBjb21tZW50IEkgYW0gZ29pbmcg
dG8gY2hhbmdlIGl0IGFjY29yZGluZyB0bw0KQXJuZCdzIHN1Z2dlc3Rpb24gaW4gbmV4dCBwYXRj
aC4NCg0KPg0KPiNkZWZpbmUgU0lPQ1NTWU5DRSAgICAgX0lPV1IoMHg4OSwgMHhjMCwgc3RydWN0
ICBzeW5jZV9yZWZfY2xrX2NmZykNCj4vKiBzZXQgYW5kIGdldCBjb25maWcgICAqLw0KPiNkZWZp
bmUgU0lPQ0dTWU5DRSAgICAgX0lPUigweDg5LCAweGMxLCBzdHJ1Y3QgIHN5bmNlX3JlZl9jbGtf
Y2ZnKQ0KPi8qIGdldCBjb25maWcgICAqLw0KPg0KPiAgICAgICAgQXJuZA0KPg0KDQpUaGFuayB5
b3UsDQpBcmthZGl1c3oNCg==
