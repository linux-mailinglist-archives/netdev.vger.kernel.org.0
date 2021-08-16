Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A177F3EDCA0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhHPRxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 13:53:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:47980 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhHPRxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 13:53:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="276935273"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="276935273"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 10:52:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="423619097"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2021 10:52:48 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 10:52:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 10:52:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 10:52:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3a0rkdIKd0349wGHChNWVbciZsqda2tem+UFuGl2VBQns12fo40xt8jEUw0ckNqG1zujvKTADjJCvwACHYkg4w5yrJkCcBoRBwMH+vAxmYf5krmAElLpPWjMyD08YYlREWBHDhzdHaupvBa257rV+bZcFYRHKjq9fbR2HnzXlAHodllENhonJayvSY+i7PdQE2SGuKikTV2d0ohdhYhqAGbVAsEoTYS6+IuaKRlgSgVStDSDUw9ABGe15fsWDr2r22IYKg9eqiROWdedrrekFBlU3HPG4zbaS77UiwOAyv+0i2r/fjDRXerUuvlrbfaqrIfSOH6gAFXtxn+pv5CTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v2I7z9imrA9WGOUpznT4/gtOUWPWh9Xil2i0qqLIig=;
 b=b8Zn9YIu8PUz2LzmrsMfhkp9ljRszTOyxWfKnB3X6t1bx8gvrzC2++DP7rciDVsz+mQTa0bunG+lOt9+cJ+T5N4t494X/M1q31u9e4qzbQ/rHg3AR1XKbRi8kFDzbFOqbL7dZIt1sQdreyOGrdDwcQdNjGRES0MSAmqJ8bAdFW8zu1xd0Hy9ei0Vhrs7s33UmcEISXkmFEWo7h3Yib0P3h8u8rhfON74uxDist50Hoocsc7phzWlvYwl9GS+bu0q3b8gxitE9B8uIYFW0ykfin3OhybiFUAn2vA0gLz0HhOJ/ruQlWDz4w28oNk2zlKSXQxiUm/6qbFjoCXEUwA2rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v2I7z9imrA9WGOUpznT4/gtOUWPWh9Xil2i0qqLIig=;
 b=SZwZLfUXP3YPJpB93c7Y3uD+PVp/3r7MP913Ad84vr81Mw3NMqFbu5wE7IGWWa4hJ7m0flg0GxzHhU2qEgN42jQFRK0tj2dDvluPboOKuGTzP8E/R/NoBtpdRiRCd9WvfgxIaHXc8yRQ6zg3eJqMhZqJTPc+cJ+uaYCsbP8a8nA=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4605.namprd11.prod.outlook.com (2603:10b6:806:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Mon, 16 Aug
 2021 17:52:43 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4415.022; Mon, 16 Aug 2021
 17:52:43 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "jkc@redhat.com" <jkc@redhat.com>,
        "Szlosek, Marek" <marek.szlosek@intel.com>,
        "Yang, Lihong" <lihong.yang@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when setting
 sriov_numvfs to zero
Thread-Topic: [PATCH net 1/1] ixgbe: Add locking to prevent panic when setting
 sriov_numvfs to zero
Thread-Index: AQHXj521/tP18gpZHE6jn3GYvfCv3atyJSiAgARLpIA=
Date:   Mon, 16 Aug 2021 17:52:43 +0000
Message-ID: <31f33e9ced63115b66ede5ff1e385105be076f15.camel@intel.com>
References: <20210812171856.1867667-1-anthony.l.nguyen@intel.com>
         <20210813172033.2c5c9101@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813172033.2c5c9101@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9059625b-b9bc-4bad-1329-08d960dea616
x-ms-traffictypediagnostic: SA0PR11MB4605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB46050E8E5ECDF4712483732DC6FD9@SA0PR11MB4605.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7L7vC3CI8bZ5qBCmQ3uDd2/xIRiIY2XQ+9yUlwXnxUW4IpYHdTT0Lpkrc7+nVbJGTFHzo0QvEaQTpctplPeYV6VoKYQZlz6aF8sllHYt8XTSBU0PR/wUJbWTosmc7DdQ9vd5+c2g9bd9SkJYhtgws7hinh9X2+fmOd6iYDycG9nA16AfNW0ize3xQxHKmxpdqCYNqsh1QoJZfSHI+lyUtkRBCLvZOb0IYLugEyTBLtinq/KoZbE+YVm1TQmbIYqt9zGMUVvdd4IxdrISMhHFrZRpN66Ahgd6UoI5wdjTMGU7rEdFXZfg7uRYCXH7tzTakmwRQBLGT5BFu4CcgCyO7f+4pyv2OrdMn4i3YAThagWMgUufm2IPgn/OR5jThiHDUxxmG8RbVb/l8d97NzjbgJildWnDzpefkatqrGZIrvCjWgULbmfOd/1/cjtRb0lgAlsHoxVIq3SGT+T5K0Q0mc490XUPmo/XmRjNPgzrK3EfeFY7d7Vyv/6ZGLw1hEAvQCbUTtYbSgnkG3SzB95iio/6uFuyICHv/RIVGHJs4JpZ75xuRLBIIjm3xWrltmGTK8SNwWqE9/eO/U6eCIkI0rPIE7OIPx536DFEVFkXoqHVGAQ4yQz1EpMVX99ksn19zLMtNkgjEk8kOxsD6EmF/hOw1XHJtvZQSb8dfwl41hso5iBk+hy5ctPt77XzuKJFgrqn71xuN08GhwAl5k0iaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(6512007)(5660300002)(83380400001)(2616005)(54906003)(316002)(478600001)(26005)(86362001)(36756003)(122000001)(6486002)(71200400001)(66446008)(66556008)(6916009)(66946007)(66476007)(76116006)(6506007)(38100700002)(8936002)(64756008)(38070700005)(107886003)(8676002)(2906002)(91956017)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTBBOFpQaGtTb1N2bzNUWTUyM0FxKysxejg1QnZvSDM4ZnliMm9iMnRjcGwz?=
 =?utf-8?B?UjZaenB2UnJZRkVnbzc4aVBQSDJJbU5BSEpXODVpYXlrQzgyQlh1eDAvekln?=
 =?utf-8?B?RjRtV1JVR0hBVnFRUjBUNWZFYnFwTzd1VGhCcE1WalVYZXhEK2pYZ0NjSTRs?=
 =?utf-8?B?OStQaTlIQkYyTERrdi9DTElRZ3BwMkIxZ1pZWWZBU2NBUFJ4MUNLY3RLOHRU?=
 =?utf-8?B?eXE1YUxtckd3UmRPL1R3T0I2YlJ0VXJQQ0FZN1c1RlR3S3F4Q05HTEl4Z0hu?=
 =?utf-8?B?RWE0WG9CS3JGMGxKbzFlR1E3Um02Y0lUeFZvNVNrRWpBbEhhOXRUaXp6Uyt1?=
 =?utf-8?B?aFNRVFhVaUJmWklZMFVXeWtNQ1VCUGJNay80dnEwMkx3ODhCM0Fja0lRWktF?=
 =?utf-8?B?Z3E3VHdPR1lsbFJRNXJrc3FKTjU4ZklhQ3d5N1B0ckpLYWpwczRiRUlrN0tF?=
 =?utf-8?B?cWFOVm9XMWJMc1NvZE1YUFBlV3UrUmF5WWF1d2FVSXVLRTFNNmR4djZ4c3R4?=
 =?utf-8?B?VWFpVmFvb2JRSXBJQ1U5ZjN1MFEyYnA3QmJJUGZZMzZPWVF2SlhNRzRWczJT?=
 =?utf-8?B?SVp5QjFrcUtLdVNTZ3V4LzUwSEtPd29aSjR5eGd1R3V3ZUZMbS8xQlF2TGl0?=
 =?utf-8?B?ZXp3SnNWQlJxWkhOZ3luOUVxcHJXaEtuWndZN2kzRjhEZktMS1B1RTdEUGl5?=
 =?utf-8?B?alp4R1RDTHY0VURiZ2R4T0xSQ1pmUzd5Ym92YzAyQjRJdGNHRzFzcGdOODNJ?=
 =?utf-8?B?SXNkcUpXWThLMlFQdTZIWFIzOUcweVBTWlZadmZIenJZVWpXV0Rlb1dreXd2?=
 =?utf-8?B?cElCUjVBRWplN2pYaTZJUEFxajFoTEc5ZWN0eEtkVDlkZi9ZbjA4ekRNUnJw?=
 =?utf-8?B?NWNMNHZhSkdxazk5UVdWYmRTY3B2dElhZm5jY2Faaml2a3ZRblN6bFhpS1FI?=
 =?utf-8?B?Qko2cGFYL3hveklRRTd6ekZWcS90WFBCbTdDSkcvaG5ZU2EzT3lsSkZ4L21U?=
 =?utf-8?B?SVlXTWo5TlpTUjJJMDgyZFRMK3UvQlZVNVBwSi9hSkdFVmNZVk41ZlU5NDdI?=
 =?utf-8?B?S3p0U0xFSGk1OXF2eTRDUXJxaEx1Uk5OZDMxd1NOR2NzS0tuV05paGFkSlRK?=
 =?utf-8?B?TjhGWjNoc2R2VUFXL0pFMWNma1ZFdVVTNEVlQW1DNjA5aVV4UFVRQUV3VkVR?=
 =?utf-8?B?dGF3dEJVV3VMN0k1KzkwOGZZWGg2U3MzWXRUSlowN0wwWmJpZ1dMblo0bDFi?=
 =?utf-8?B?ZXMvU3lFc2k4Rk9ibVNmL2R4NVFpaHp4Uks4V3l5cko3YnZqSTNua3hGRkU0?=
 =?utf-8?B?eFB3OExmRndiV0RXR0tnenJSd0dMV1I5TlJNS21reU9EV3NNd1JWMFZsN1Ji?=
 =?utf-8?B?blExaDdORHdXbnFGK2pxMS9rRUJsYmtwcDAyajZid0lhZ0xyL01ZUmgvRE9u?=
 =?utf-8?B?SUxGNnNsNnRhY0RNR005R3dROWVyaHcvS3FVV2UvdXh2ekxoMHJMeFdFVmZW?=
 =?utf-8?B?MXh2WUt2eC9URmJVK3Uvd0ZOMGhGYi80MWpJa2VENyt3ZXlXbDUwL0RUSU41?=
 =?utf-8?B?YXdRcSt6SVNjMkVxOU94b2htdkxqTitPQU5mSVhxNkR5UEFuVE5NajlzUVRi?=
 =?utf-8?B?MWNEWm1ySm9EN2xHdm16SHdrWFNUcnVIVjljK28wV0V2YjdqWGkxWXZVenNM?=
 =?utf-8?B?VjZMVVhqblpwNjdNcFpNUDQ0S3p3bFlmSXFrS3g2SmNxZ0QxT1JKVDFiWHJu?=
 =?utf-8?B?azloRDNkbEltT3dPWGVlQlJrRm9zZkc1RTg5R0NvbWFMUC85WnRuK0V4N1hU?=
 =?utf-8?B?S2k3WXRCQmVseE84VW9aUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C9BD1F543BBAD44ABA1D574AEA8E214@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9059625b-b9bc-4bad-1329-08d960dea616
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 17:52:43.4127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8yiFsKcJPlk+Yanf4DGiUzujEau1A2ewhSycGia1j0U1pEGvihzpNjz2RFF+4Z4fLXcneO5nMbnxdVTvN0Jf7m/QB1HIB1C9ZtdOaXopMLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4605
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA4LTEzIGF0IDE3OjIwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAxMiBBdWcgMjAyMSAxMDoxODo1NiAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVf
c3Jpb3YuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfc3Jp
b3YuYw0KPiA+IGluZGV4IDIxNGEzOGRlM2Y0MS4uMGExYTg3NTZmMWZkIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3NyaW92LmMNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9zcmlvdi5jDQo+ID4g
QEAgLTIwNiw4ICsyMDYsMTIgQEAgaW50IGl4Z2JlX2Rpc2FibGVfc3Jpb3Yoc3RydWN0IGl4Z2Jl
X2FkYXB0ZXINCj4gPiAqYWRhcHRlcikNCj4gPiAgCXVuc2lnbmVkIGludCBudW1fdmZzID0gYWRh
cHRlci0+bnVtX3ZmcywgdmY7DQo+ID4gIAlpbnQgcnNzOw0KPiA+ICANCj4gPiArCXdoaWxlICh0
ZXN0X2FuZF9zZXRfYml0KF9fSVhHQkVfRElTQUJMSU5HX1ZGUywgJmFkYXB0ZXItDQo+ID4gPnN0
YXRlKSkNCj4gPiArCQl1c2xlZXBfcmFuZ2UoMTAwMCwgMjAwMCk7DQo+ID4gKw0KPiA+ICAJLyog
c2V0IG51bSBWRnMgdG8gMCB0byBwcmV2ZW50IGFjY2VzcyB0byB2ZmluZm8gKi8NCj4gPiAgCWFk
YXB0ZXItPm51bV92ZnMgPSAwOw0KPiA+ICsJY2xlYXJfYml0KF9fSVhHQkVfRElTQUJMSU5HX1ZG
UywgJmFkYXB0ZXItPnN0YXRlKTsNCj4gPiAgDQo+ID4gIAkvKiBwdXQgdGhlIHJlZmVyZW5jZSB0
byBhbGwgb2YgdGhlIHZmIGRldmljZXMgKi8NCj4gPiAgCWZvciAodmYgPSAwOyB2ZiA8IG51bV92
ZnM7ICsrdmYpIHsNCj4gPiBAQCAtMTMwNyw2ICsxMzExLDkgQEAgdm9pZCBpeGdiZV9tc2dfdGFz
ayhzdHJ1Y3QgaXhnYmVfYWRhcHRlcg0KPiA+ICphZGFwdGVyKQ0KPiA+ICAJc3RydWN0IGl4Z2Jl
X2h3ICpodyA9ICZhZGFwdGVyLT5odzsNCj4gPiAgCXUzMiB2ZjsNCj4gPiAgDQo+ID4gKwlpZiAo
dGVzdF9hbmRfc2V0X2JpdChfX0lYR0JFX0RJU0FCTElOR19WRlMsICZhZGFwdGVyLT5zdGF0ZSkp
DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsNCj4gPiAgCWZvciAodmYgPSAwOyB2ZiA8IGFkYXB0ZXIt
Pm51bV92ZnM7IHZmKyspIHsNCj4gPiAgCQkvKiBwcm9jZXNzIGFueSByZXNldCByZXF1ZXN0cyAq
Lw0KPiA+ICAJCWlmICghaXhnYmVfY2hlY2tfZm9yX3JzdChodywgdmYpKQ0KPiA+IEBAIC0xMzIw
LDYgKzEzMjcsNyBAQCB2b2lkIGl4Z2JlX21zZ190YXNrKHN0cnVjdCBpeGdiZV9hZGFwdGVyDQo+
ID4gKmFkYXB0ZXIpDQo+ID4gIAkJaWYgKCFpeGdiZV9jaGVja19mb3JfYWNrKGh3LCB2ZikpDQo+
ID4gIAkJCWl4Z2JlX3Jjdl9hY2tfZnJvbV92ZihhZGFwdGVyLCB2Zik7DQo+ID4gIAl9DQo+ID4g
KwljbGVhcl9iaXQoX19JWEdCRV9ESVNBQkxJTkdfVkZTLCAmYWRhcHRlci0+c3RhdGUpOw0KPiAN
Cj4gTGlrZSBJJ3ZlIGFscmVhZHkgc2FpZCB0d28gb3IgdGhyZWUgdGltZXMuIE5vIGZsYWcgYmFz
ZWQgbG9ja2luZy4NCg0KS2VuLA0KDQpEaWQgeW91IHdhbnQgdG8gbWFrZSB0aGlzIGNoYW5nZSBv
ciBkaWQgeW91IHdhbnQgSW50ZWwgdG8gZG8gaXQ/DQoNClRoYW5rcywNClRvbnkNCg0KDQo=
