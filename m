Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA6A41C9DE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344475AbhI2QPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:15:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:30569 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344020AbhI2QPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 12:15:05 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="205125462"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="205125462"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 09:12:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="486978662"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 29 Sep 2021 09:12:22 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 29 Sep 2021 09:12:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 29 Sep 2021 09:12:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 29 Sep 2021 09:12:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeHmMrcWJ/36Qwyb+EAKC09eG6oed1dcNsdijLlkwhnQPTSZhPyzMyZjLnROVq+EzxhL0U5qa23qprVIKlu2i9ffTS4j7wz7H7KEnuVS+E2PtUCcsEPTko11E1bdwlSVW37A4uF9JfdoCyxgIKMJThQCXol6T2q8xfKppZoqLwgHFcfyYBHmxUkHBnYQYb7+Jr0+rV/3DqggbeYWcMkQIIPixfQFatwaV+sVbUIw6YEIcqjCrovLuAOdFFNqXl5dBNqLU1nq96WgNKo/o5XOtAhczrZgrst6YqUS/tmzwXvwuDFY2//13NtSVxEG9Y7bm9LrmAdSXJKbP5J/kZZIgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gRqwCYGveqjbbeuvP74AQyUcna1P2Oos1CwyAuA0+dA=;
 b=m/ihXIkwTXoJ9FWFXehW4Aiy77Bc4qUvAOIqdzFxJopvJTgYg6dW0jBJ6o5+uJyAL8YvI8e0YSjoOxOzBVG7PfZ1jiv4f1Z+nKKKQEUodnhWv+qXFM1XNNMQ8OGD4EqcdJPvEjuVDal3237aqtI9V/xT41/xTjHefZXHZraGt0ovDQnXJNtIMdhloNsFkfqKfHnXOVMSu/px7dr/ll+Ej19nlsb27BuUnJaK3B8ReRfzxbUuELrPuXcBlaog3IyS3EOj43c5W5SrOU8VhT80Z5JzwAvYNXmX84HjXy9OWoeQjRrLDj+g3Hyg+Erg1JsX9yfuIGn9r3pXvNGSV19OGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRqwCYGveqjbbeuvP74AQyUcna1P2Oos1CwyAuA0+dA=;
 b=dgEV0LkvIj1gpekNi1LUI4rz0IEgXYtFia40B2XIxeYQUxJzYChyfSGewlB7bWzRhVNBv3Xx813BUrq2M9wymWQNQpfjUhC/2c0vhyvAD4JqAcnVYEbPWkv1f4qCjFiGMt5ienjr3IkIhQYB+VGoqp46hWq4Rp3iG0xMRMJgO2E=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2544.namprd11.prod.outlook.com (2603:10b6:805:5d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Wed, 29 Sep
 2021 16:12:19 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 16:12:19 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH -next] intel: Simplify bool conversion
Thread-Topic: [PATCH -next] intel: Simplify bool conversion
Thread-Index: AQHXtP8uZnwa1o12TUK8YCX0sGVS0qu7MLoA
Date:   Wed, 29 Sep 2021 16:12:19 +0000
Message-ID: <572f388c1678cbd8354f8788fbb0243396ec76d9.camel@intel.com>
References: <1632898586-96655-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1632898586-96655-1-git-send-email-yang.lee@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7120b479-0d9a-4b2e-e9ad-08d98363e9a6
x-ms-traffictypediagnostic: SN6PR11MB2544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB25442E4E5A9225DE7062C620C6A99@SN6PR11MB2544.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IAxDCyU2v7uAue4dK0rRBXXVrZOAb1h4LMug67DHhUTjBtG4Xkli6TFM0fHkf4ui+f8E/5kOkDWtWOLmlb3I36gvHPXPR5PFBqGq8wDIM+eD8Ycx43BURr5TqRPAV3zGJp4DoXFw4I64ONEpGtL9oW3mhB97xEorqtviAQuysQHr6j8x+0bU/uLCFtJnlris+X42ryVx97OmTFPc4AqQm/YCbx3M3WftiL5/A8x6hL7zYPkF9AMIdjvZrBAtwsKJANj9RUsjTMYhUy4qZLMooGiLoysricxj8MM3Ov22f+O3nQOJAe49vcxyqEwoObQ0lRAHBOoiwByswu1SgK0eZg57HgkqBothoR4afPFO9skqoFMVrhpjdYkPwvKllwvZh/PjLKai4u90hglkgvfC2BtwsxdKpmLXeTnNXra8rLeDIyD3z9Zt2j1GIQc3b721dezs1JyPi4SH7q1yvAx4OykJbVpsREPQ+FNzc05EGAGeBj8yr0DNeLRG+YjF39ee1Fk7vG/v1cTE6ctnT3itshGg133xP3CELpQhcdoeQWbUKQzNEPbpJrztKpBPTB0ICso1CvsJ1hy293t/wiRSNW3jq6yrfkZ/G8RxrZ6hu3goFOh8uEOAkva32mZ8PwSSzsQVWntG6MfAt8oer+mt2rtpTicCacjTNB7haemVDhc4uC+LUPR3ULx9JfK2I4fVo9NGC3sYgYFeJNx5xSP9Ozl2T8RIhsuVcdzuoPpf+i431P4wcjFC4myiHz+uPwj9Z8oskbi91So7ZZlbrYqr74ZuKz2CYqqcfifdARf2ULk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(6512007)(36756003)(8676002)(86362001)(2906002)(71200400001)(83380400001)(66476007)(66446008)(6486002)(66556008)(966005)(64756008)(122000001)(316002)(38100700002)(110136005)(54906003)(26005)(5660300002)(76116006)(508600001)(91956017)(66946007)(6506007)(38070700005)(2616005)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anFGaElQS0lFaklnK2pyY2dHOGg4UHBYS2oxRTV5ZjdmY3NQQndrRGJlRUh2?=
 =?utf-8?B?VmMzMFBkRGJyeDNOaXdIYXRUTEdMWVlRTS9NaHFmaVRzM1plcGZkanZ6QXBp?=
 =?utf-8?B?RTZPaVhVZzVnRmY5eXBNUEJueHBKSjlFVnBGcUx3U0dKOFd1MXphRUJkTk1n?=
 =?utf-8?B?Z3BZK3RwUHJHdWpSRnlPT1krN3liUXRGbzM3TTBtNVBodUZPRlBac0JHcmV3?=
 =?utf-8?B?aVo5eFIrc051aHhXZ3ptM2RTcU9walNvRFYrV0pxcVBBeklSR3U2RHYrWDhh?=
 =?utf-8?B?VjZ2MzA1NXJPQ1VJZ281d1N0ODBvTzNlM3gzWGRhNkQ3QmVCbVRBUjhheSth?=
 =?utf-8?B?OHRIL2tHZXpNbkdwdDd0QTFYanQvR0xvbXNnRWZlSU5hUFJoTU1nbC9uUVR6?=
 =?utf-8?B?akxhM3VqaXFpcWVTdEgraTk2SzRtSDIvVUlwK2tQVll1VEkyS3hlanB2VXg2?=
 =?utf-8?B?dGpOZTBzTHkvTWRvWXppbWZWWG1VaXE5YkpVNS9VVXdaZVo0QnlSZFE0RGNn?=
 =?utf-8?B?ZnBXS3p4SWp6YldnNkhLakx5ZndjZ09WTkVxMkR4NzJPRGk4eDVrakJIQkdD?=
 =?utf-8?B?OGdIT3pkaXJSMGlieFRrVTcvbU9EaTZFS0s0QWJ5Y2hpNU9weE43ME1YNFRR?=
 =?utf-8?B?UVpxMXgxTGRWcmZ4U2tNdnNadGxEYnljYVEvWjNtS2MxTEJTeHVhTUZKYTlV?=
 =?utf-8?B?YU5TYmk0Myt3VTVMbWdvcEtWdkxoVUIyUUhsUStpOXpMZnJCUVpUR1Z2R2hw?=
 =?utf-8?B?VitsSU4yNXlYVks1czFDZldRS25kV2h1cXRxdDZnVWM5SGp4OUtoZ0Z3dkJa?=
 =?utf-8?B?SkpHTGhWL1BOQzhzVk5ZOU5la2xKNVo0TU83UXM5QmN0bVRTS1p2MmRURko1?=
 =?utf-8?B?Rm9WMzM3RTF4ZS9aeDltU1ZybVRCdmNWSHc3T2lzTVEvUkZVSS9PcEl2cDl3?=
 =?utf-8?B?bFA2b2FraFVVR3dYb0h5eHVUdzVad2dxRmpjN0pEd1o2MUNCVDY5SVgwbEJw?=
 =?utf-8?B?VDhaOWZjMndYR1d0TVBmcytKUWovWVNoU2FNWUhjVmNMUmdkMER6NW1GTm80?=
 =?utf-8?B?aktzV3o3WWtDN3B0MkVVaUNYYmYxWTdCOVM0QzVyT09JK0RBVXNSb0EwM2Iy?=
 =?utf-8?B?eHRhOFNPanZXNVlvN1c2cVBXVldYcG9XSytOdW5La0EwREpVdHhpVng4VEQ4?=
 =?utf-8?B?c1UvdXFvN1lXT1p5UVhjOGIvMm5VTm1ydU4wK3hBcjMrcmt6T2hZNXRWYkpp?=
 =?utf-8?B?RCtxYW9kOHZ1Q3p0UnEwZWowZkNnNy9CblhIVllPM2FpQXhPY255TkxyL1ZU?=
 =?utf-8?B?QlZoZk4rTWk0WU1BSDBMUXNLTXJxRS9ISnhaL2RwY0lWZjFTbmVrVFdCRXZL?=
 =?utf-8?B?ZDJUYk9tcXNISk0weUVhcjh1RWdiZHc5Nmt5Tm9BRmhyc3BhNE1jb1c2cnYy?=
 =?utf-8?B?WGU3eVN0b1F4SU5Gdk1rMG0yd0RGZVpTTSs1cGVBSExGU0JKck10Q2tHNk5P?=
 =?utf-8?B?bGo5VDljalNtK1J3bUxpQWhaVmRrczJsRzdCWmo2dGJxdEkyclFFN00wQUo3?=
 =?utf-8?B?NEVFWXlLdDV5VGtKTnlTcmtOcjAycVdQcjlBV3lwcDJsSGUrUEp2WU5TclMz?=
 =?utf-8?B?ZEczWStpSXgxa2ttYmRKK3luT0UzZldwYmIwbTl4dGNNWjBwOEJvL00rM0to?=
 =?utf-8?B?YUc3Y2hBaWdwQXh1V0t2aW5nMXJnNFRtSnZwSS9ab1c4RDNkTWdYSTZaeDF1?=
 =?utf-8?B?TmFPV3BkSzVRVXArZ3RYRDNVSktzeW9IdUtQU3VZaFAwQ1FjTjM0MERjck9a?=
 =?utf-8?B?TzdBZ2x1UlBIc0gya0JzQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9FF39C523C9734489C47D8DB0BA7F4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7120b479-0d9a-4b2e-e9ad-08d98363e9a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 16:12:19.3997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHWOWzObOMCjwdyAJn3AL9SLIXrD1LFrjGhrnAcm2f2GG4UxKaYGhf4/qb2RwXmbYNdFViKYK0PDWqa47iwqaSZ4oGAeFFtJzsO4HfcGSV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2544
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA5LTI5IGF0IDE0OjU2ICswODAwLCBZYW5nIExpIHdyb3RlOg0KPiBGaXgg
dGhlIGZvbGxvd2luZyBjb2NjaWNoZWNrIHdhcm5pbmc6DQo+IC4vZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jOjIyOTozNS00MDogV0FSTklORzoNCj4gY29udmVyc2lv
biB0byBib29sIG5vdCBuZWVkZWQgaGVyZQ0KPiAuL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfeHNrLmM6Mzk5OjM1LTQwOiBXQVJOSU5HOg0KPiBjb252ZXJzaW9uIHRvIGJvb2wg
bm90IG5lZWRlZCBoZXJlDQo+IA0KPiBSZXBvcnRlZC1ieTogQWJhY2kgUm9ib3QgPGFiYWNpQGxp
bnV4LmFsaWJhYmEuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBZYW5nIExpIDx5YW5nLmxlZUBsaW51
eC5hbGliYWJhLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBl
L2k0MGVfeHNrLmMgfCAyICstDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNl
X3hzay5jICAgfCAyICstDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCg0KQWNrZWQtYnk6IFRvbnkgTmd1eWVuIDxhbnRob255Lmwubmd1eWVuQGlu
dGVsLmNvbT4NCg0KVGhpcyBhcHBsaWVzIHRvIHBhdGNoZXMgdGhhdCB3ZW50IHRocm91Z2ggQlBG
WzFdIGFuZCBhcmVuJ3Qgb24gdGhlDQpJbnRlbCB3aXJlZCBMQU4geWV0LiBCUEYgLSBkaWQgeW91
IHdhbnQgdG8gcGljayB0aGlzIHVwPw0KDQpbMV0NCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5v
cmcvcHJvamVjdC9uZXRkZXZicGYvbGlzdC8/c2VyaWVzPTU1MDc3NSZzdGF0DQplPSoNCg0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jDQo+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jDQo+IGluZGV4IDZm
ODU4NzkuLmVhMDZlOTUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2k0MGUvaTQwZV94c2suYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBl
L2k0MGVfeHNrLmMNCj4gQEAgLTIyNiw3ICsyMjYsNyBAQCBib29sIGk0MGVfYWxsb2NfcnhfYnVm
ZmVyc196YyhzdHJ1Y3QgaTQwZV9yaW5nDQo+ICpyeF9yaW5nLCB1MTYgY291bnQpDQo+ICAJcnhf
ZGVzYy0+d2IucXdvcmQxLnN0YXR1c19lcnJvcl9sZW4gPSAwOw0KPiAgCWk0MGVfcmVsZWFzZV9y
eF9kZXNjKHJ4X3JpbmcsIG50dSk7DQo+ICANCj4gLQlyZXR1cm4gY291bnQgPT0gbmJfYnVmZnMg
PyB0cnVlIDogZmFsc2U7DQo+ICsJcmV0dXJuIGNvdW50ID09IG5iX2J1ZmZzOw0KPiAgfQ0KPiAg
DQo+ICAvKioNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfeHNrLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5jDQo+
IGluZGV4IDc2ODJlYWEuLjM1YjZlODEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfeHNrLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWNlL2ljZV94c2suYw0KPiBAQCAtMzk2LDcgKzM5Niw3IEBAIGJvb2wgaWNlX2FsbG9jX3J4
X2J1ZnNfemMoc3RydWN0IGljZV9yaW5nDQo+ICpyeF9yaW5nLCB1MTYgY291bnQpDQo+ICAJcnhf
ZGVzYy0+d2Iuc3RhdHVzX2Vycm9yMCA9IDA7DQo+ICAJaWNlX3JlbGVhc2VfcnhfZGVzYyhyeF9y
aW5nLCBudHUpOw0KPiAgDQo+IC0JcmV0dXJuIGNvdW50ID09IG5iX2J1ZmZzID8gdHJ1ZSA6IGZh
bHNlOw0KPiArCXJldHVybiBjb3VudCA9PSBuYl9idWZmczsNCj4gIH0NCj4gIA0KPiAgLyoqDQo=
