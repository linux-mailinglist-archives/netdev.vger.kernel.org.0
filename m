Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235AB409E24
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 22:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbhIMUaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 16:30:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:25818 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhIMUay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 16:30:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="201963708"
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="201963708"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 13:29:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="471701645"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 13 Sep 2021 13:29:38 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 13:29:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 13 Sep 2021 13:29:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 13 Sep 2021 13:29:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbjWD6yTu21eBqTI8gnxxGozK+93eqrnKVGSAslQgUjfR1z/yLEHO9qrv1WvapPi/tY/ylxUtriD9NdbFbmzpwazJfAxDhdPIBGJ2AIB1mfvpmD265zh1r667UEfTcY3wgH0h4c1zyFB7Nt0iRgwKdjPsZTa5snkPFAi/7u4jyseyOv5jKrmzpiFaSt8OGNLvGJGY9dMJPX7r4/aVMCU+EHZumRWmDXjmEZ8T1eq3ibtymgg+XbJvWs7apsLZF9CY6lh86NeOY8uLpWuJSqmq17U28paEHQ2DhEWSvl/oW05c4gjslbJY1zHqoP8yIAtnBmztNFokAQndOZnpkZIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0xETtVo1h/SpDiYCDFbYykZnELbyI2vX/2ovzxIWsag=;
 b=BJIEF6v7fzYDcfDVqPGk6BW0mwjL0Mth4VXbqidxIcgzlfLDgr4c84/4kADw1tVmedjwps2LzSLmJBxGJIwnfKCvD7iJXj4QlhVNTD9lXxBfoKAUykGVEQi00oblj66HNQxJWCngxo98MEZEwWDJ5dHQSLMnZvxU/A/ledke8l/Am9WJkX25vI9zp9sHhUHFbLlQZag5FF/5dq5kJuuha7sNa4K/hUyOX2Q0DRulyQfy7t6aOsJIxCXlXhU/rVvy8WjvSroiJK5Xq3r0fGJY1bRHH3NGMSa1B52dMsbA+w6x6Q+1lj+pzQoWVI6wTjioTNBvhTb/Uz6XncCt3xMTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xETtVo1h/SpDiYCDFbYykZnELbyI2vX/2ovzxIWsag=;
 b=bM9eVzdocZ4iC5MdM9vJ6gxTfNtibIOv3yNb9j+hs6iAaGiGoNzcOFFKtzcnItrcIQPcHFvyjxm3wWlw4fBBg529PABSwpND5sZqya7P3cEHd/XcB6PYVlvF8dM/tpQrCoAtPypRQtTcsldqa2TehF2inTd3S8jUkUyHChR75qI=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2670.namprd11.prod.outlook.com (2603:10b6:805:61::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 20:29:35 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 20:29:35 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "pwaskiewicz@jumptrading.com" <pwaskiewicz@jumptrading.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsiBRJTk/bztnkiJewAWaKSBqquMjXAAgAGS54CAFFexAIAAD6UA
Date:   Mon, 13 Sep 2021 20:29:35 +0000
Message-ID: <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
In-Reply-To: <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: jumptrading.com; dkim=none (message not signed)
 header.d=none;jumptrading.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c92a933-1a9e-4323-f4b9-08d976f53376
x-ms-traffictypediagnostic: SN6PR11MB2670:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2670EC2927B0D67CAF9A4225C6D99@SN6PR11MB2670.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RJHw1TtqznI0K5DeNcQPbUuNW3GVkIfjuwP1SJGM0LeePcAd5uhK1SdZjn4MHkLNBrhXmlGmJQHqQ0Izw5XyK1b/yABn/B8V7noLpJQUFUNQW0gKoep8mW7jQ/XcwosZWS0GdjjOkZsRSPs/FfTH5gMHA+YE+OCbxJj4c73B+cQD9zWjcwhgSp9DJ2sO+QjXdK6mIx5Yu2qAx8uPShQ9lmwBM4LhoHdIn8xLtNJt5V/P76eqNrQF67IgYbn41hccuoSeJxP093G/pP8kXfB+opxq5SSNR0GvUVnCNUL5/ZHCKIIJyvoZnbzbS4bkZ4ksUpbI5tsiZIL/yBckmEv9LZw3ZMQGaHqCPhZd/EaULmM0/NXK1H+nZ67VAjNR1URQu86zWm8s3wHG25NTqRnGaYXvwqmLKw290JeW1O9ilIo+7ZzjQ3QcyHccXiYzsrggVORNxZ5gSTWBRZ27bh2FidCB2NL8GfCRvm3Tjwo3OX9NZkB839RZJGb1DA0BJaPH6NuoLwV7+MZEwyOBNsGzMIE9hzITp5Ew0hrHWorg8DFKg+kD8NyA/KDEKWkNkMaPQ1TWyJRRkDYl1RFZisQF1cubSSwk3oQ5XxCD0u4nyMVlwdd9Ttq2+y8EbrQmW/k+5uSYIrthmX74ipXZqNpakoNp1zHBCtfvJHnk/ZC7FerwxZBJgjR/FqDfZ5ndrgCFiy3C6uRBtLZxMH+oYTdFxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(5660300002)(6506007)(53546011)(26005)(8936002)(38100700002)(6486002)(91956017)(8676002)(76116006)(64756008)(478600001)(186003)(66446008)(38070700005)(66946007)(66476007)(66556008)(122000001)(6512007)(2906002)(4326008)(316002)(2616005)(6916009)(36756003)(54906003)(83380400001)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RkxFbjgrNzBXRTQzdEk5RkQzbENNc2pvYlJ4cmxXd1BCUTNHbkVNZXlwaG9m?=
 =?utf-8?B?NlJseU1VY1JsVHdJMkhzWFd4L3lQTmZRUHVmN0lCNkJSU2NOQUhlaXJUV0c2?=
 =?utf-8?B?YnFWU3Z3R04wRGdtcE93RFd3R1NWNUR0QUVkMnQ0T3dSTFZQa2MvS3RBMDEw?=
 =?utf-8?B?a2ttSG1MYUFKNkFkTHB3NDFzZldpN0ZhRHVrSXZ2cXR2ZkZNYUlzcS9rYmFy?=
 =?utf-8?B?WnIxclRsemVzU2ZvMmJMUlluMHdFT0JJeVQzSWFYWkI3Nk5HNWFhNktnWi9O?=
 =?utf-8?B?cElneUtYcXNTTkJRNGEvbXdLRG9HR3htMmFWblUxMGtVUmVxbjF3VUNmQUdO?=
 =?utf-8?B?ZkJwb0FBSXBSdkd3djB2WWRGY2FTdEFBL1hhMXRBbXNEaGhwcFJCMmx5MDFV?=
 =?utf-8?B?M0Jsd2h2N0RxUEVpaHR5RS80RTFGRm5pRm9ONmJUQmg3dXZpUkR3ME5xSGM4?=
 =?utf-8?B?NjZDT1ZkVDdpS3NoRFZPVy9yU0FROFJoUXhIc29qOXhkbmtxclVLVkN1Smgy?=
 =?utf-8?B?WGNkZ1NIbUQxZWRRL1hwajNzVVFDZzZUV2VFU2pDb1ZoRktKcmM2cGZlOTgr?=
 =?utf-8?B?NEJlYVpOK3NzSHhlWmQ5bm9LeXJFTUgwelYzQTdJMllpMlc2dEpsQTFlLzVT?=
 =?utf-8?B?Z2VGWHJibUZhdUo5MWxqeW9wUXN1YVYzKzZpVUQzTEdsd0U3OGhaV0hYWWEz?=
 =?utf-8?B?UmI0S0FNSmozOTdVakNBNVM1TUd3cUYvRFFoYXYwMFFJMmRRNTJQMGc4Yyt1?=
 =?utf-8?B?OFRwSG8wVVROU1E1bHB6OURpbXhUT09qK2xzRHR3N0dFNUY0Y2xPckc3anBa?=
 =?utf-8?B?d3lNTTFuMjF4WUdpTThBcFJaWVFubFNVZkVTa2k2OVZDUG4rMEdpTDZTVit0?=
 =?utf-8?B?T21rYTQ2ZG1yU29mckhYYnFIdUdkanlBQlppL2xYREZqdzloMUU3TzZlbWl6?=
 =?utf-8?B?cSsrOUl2MXQ0ZHpyVmZuUzFPdVkvOUxneUx5Z3pZNUlmVFVsWG5jNytQOFE3?=
 =?utf-8?B?cEw2NWNubVhwSkh4ZzkrS1UzcGhoWCs1YndvK3o4d2l3ejkxd1RUbzNjVFo4?=
 =?utf-8?B?eVFFSTVTbFYzT0t5R1QwdUlpSGhKRlNIbnFnYXp1TFlISGRsTXZscFZYc0dz?=
 =?utf-8?B?Nkl5QnVmZi8zY1N4bXIwYkkzTDg4WEVkRkZJMTcvaHFWZ2QxWkk4YjF4Qlp1?=
 =?utf-8?B?REszbkh2Vk5mN3Q0dFNuT1lwWkF2VWdMVU0zNVIyQ2J0TjlrcUt2QXNFanFY?=
 =?utf-8?B?aWhwRnlyOENtLzFzMEVJdm1ob3VoTEE0ZG8zZ1hLSXJrNk5IZ2JLL21BOStX?=
 =?utf-8?B?aERtODdFRkRtY3NtWURYT3hIODJmN0V5Um50T0Q5U3Z4eVhwNnVmS1JxTjZk?=
 =?utf-8?B?YzQ2QU5sOG5UUmFpVk8yUklXdXhhczErRkpoWWw2YUF4ZjFaQ0picU84azdS?=
 =?utf-8?B?MTM0Qm00V3h0NjRZcnhHTmhicWJBNUxWaWc5ajhLeDcrVkpiVGZzUkxqSXFJ?=
 =?utf-8?B?cU5Cb29ucHZCa2ZBSEtnTFZaUm1mMXhQS0NCT1lPb2VpRnJ2Ulp3NXp1YlEv?=
 =?utf-8?B?US9GbVVaYmJCZXpOQzBleWpDbmx4MFFIZmwyMHFkcVJuZVFadDcxQjdMNUg0?=
 =?utf-8?B?SHVvMGhOeXVJMUxtQXFhVG5BeVhFeHNKemJUOVVXV0VkZG1keTNmU25yYmY1?=
 =?utf-8?B?SUMzZXEraHlLTmpBMjUvMHFQTS9PTHVJazNINjBnN1F6eWpTWE11RFh2MmFi?=
 =?utf-8?B?VUpiZGR5THkrREhEMEpudzFZM3B4bUdZc08wdjNXSWl3Z09rL3k0eTd3VHZm?=
 =?utf-8?B?aFViVnhTSUlKUGZQWm5QZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B90161EBAF766742B22CB46622E66296@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c92a933-1a9e-4323-f4b9-08d976f53376
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 20:29:35.0815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UUM5ce99CDJ7JWpUPrd9qOhlCE4iTSv2MtrXDrGd9SDyyXNWLapi+0s3d1JtboC5DJKOC2zlRoKQBE6Fyxcwi4NgF4wVpLM6kxQETUstQxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2670
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA5LTEzIGF0IDE5OjM3ICswMDAwLCBQSiBXYXNraWV3aWN6IHdyb3RlOg0K
PiBIaSBUb255LA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206
IFBKIFdhc2tpZXdpY3ogPHB3YXNraWV3aWN6QGp1bXB0cmFkaW5nLmNvbT4NCj4gPiBTZW50OiBU
dWVzZGF5LCBBdWd1c3QgMzEsIDIwMjEgMTo1OSBQTQ0KPiA+IFRvOiBOZ3V5ZW4sIEFudGhvbnkg
TCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQo+ID4gQ2M6IGludGVsLXdpcmVkLWxhbkBs
aXN0cy5vc3Vvc2wub3JnOyBwandhc2tpZXdpY3pAZ21haWwuY29tOw0KPiA+IExva3Rpb25vdiwN
Cj4gPiBBbGVrc2FuZHIgPGFsZWtzYW5kci5sb2t0aW9ub3ZAaW50ZWwuY29tPjsgRmlqYWxrb3dz
a2ksIE1hY2llag0KPiA+IDxtYWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tPjsgRHppZWR6aXVj
aCwgU3lsd2VzdGVyWA0KPiA+IDxzeWx3ZXN0ZXJ4LmR6aWVkeml1Y2hAaW50ZWwuY29tPjsgZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldDsgQnJhbmRlYnVyZywNCj4gPiBKZXNzZSA8amVzc2UuYnJhbmRlYnVy
Z0BpbnRlbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBQSg0KPiA+IFdhc2tpZXdpY3og
PHB3YXNraWV3aWN6QGp1bXB0cmFkaW5nLmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIDEv
MV0gaTQwZTogQXZvaWQgZG91YmxlIElSUSBmcmVlIG9uIGVycm9yIHBhdGgNCj4gPiBpbiBwcm9i
ZSgpDQo+ID4gDQo+ID4gT24gTW9uLCBBdWcgMzAsIDIwMjEgYXQgMDg6NTI6NDFQTSArMDAwMCwg
Tmd1eWVuLCBBbnRob255IEwgd3JvdGU6DQo+ID4gPiBPbiBUaHUsIDIwMjEtMDgtMjYgYXQgMTc6
MTkgLTA1MDAsIFBKIFdhc2tpZXdpY3ogd3JvdGU6DQo+ID4gPiA+IFRoaXMgZml4ZXMgYW4gZXJy
b3IgcGF0aCBjb25kaXRpb24gd2hlbiBwcm9iZSgpIGZhaWxzIGR1ZSB0bw0KPiA+ID4gPiB0aGUN
Cj4gPiA+ID4gZGVmYXVsdCBWU0kgbm90IGJlaW5nIGF2YWlsYWJsZSBvciBvbmxpbmUgeWV0IGlu
IHRoZSBmaXJtd2FyZS4NCj4gPiA+ID4gSWYNCj4gPiA+ID4gdGhhdCBoYXBwZW5zLCB0aGUgcHJl
dmlvdXMgdGVhcmRvd24gcGF0aCB3b3VsZCBjbGVhciB0aGUNCj4gPiA+ID4gaW50ZXJydXB0DQo+
ID4gPiA+IHNjaGVtZSwgd2hpY2ggYWxzbyBmcmVlZCB0aGUgSVJRcyB3aXRoIHRoZSBPUy4gVGhl
biB0aGUgZXJyb3INCj4gPiA+ID4gcGF0aA0KPiA+ID4gPiBmb3IgdGhlIHN3aXRjaCBzZXR1cCAo
cHJlLVZTSSkgd291bGQgYXR0ZW1wdCB0byBmcmVlIHRoZSBPUw0KPiA+ID4gPiBJUlFzIGFzDQo+
ID4gPiA+IHdlbGwuDQo+ID4gPiANCj4gPiA+IEhpIFBKLA0KPiA+IA0KPiA+IEhpIFRvbnksDQo+
ID4gDQo+ID4gPiBUaGVzZSBjb21tZW50cyBhcmUgZnJvbSB0aGUgaTQwZSB0ZWFtLg0KPiA+ID4g
DQo+ID4gPiBZZXMgaW4gY2FzZSB3ZSBmYWlsIGFuZCBnbyB0byBlcnJfdnNpcyBsYWJlbCBpbiBp
NDBlX3Byb2JlKCkgd2UNCj4gPiA+IHdpbGwNCj4gPiA+IGNhbGwgaTQwZV9yZXNldF9pbnRlcnJ1
cHRfY2FwYWJpbGl0eSB0d2ljZSBidXQgdGhpcyBpcyBub3QgYQ0KPiA+ID4gcHJvYmxlbS4NCj4g
PiA+IFRoaXMgaXMgYmVjYXVzZSBwY2lfZGlzYWJsZV9tc2kvcGNpX2Rpc2FibGVfbXNpeCB3aWxs
IGJlIGNhbGxlZA0KPiA+ID4gb25seQ0KPiA+ID4gaWYgYXBwcm9wcmlhdGUgZmxhZ3MgYXJlIHNl
dCBvbiBQRiBhbmQgaWYgdGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQNCj4gPiA+IG9uZXMNCj4gPiA+
IGl0IHdpbGwgY2xlYXIgdGhvc2UgZmxhZ3MuIFNvIGV2ZW4gaWYgd2UgY2FsbA0KPiA+ID4gaTQw
ZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSB0d2ljZSB3ZSB3aWxsIG5vdCBkaXNhYmxlIG1z
aQ0KPiA+ID4gdmVjdG9ycw0KPiA+ID4gdHdpY2UuDQo+ID4gPiANCj4gPiA+IFRoZSBpc3N1ZSBo
ZXJlIGlzIGRpZmZlcmVudCBob3dldmVyLiBJdCBpcyBmYWlsaW5nIGluIGZyZWVfaXJxDQo+ID4g
PiBiZWNhdXNlDQo+ID4gPiB3ZSBhcmUgdHJ5aW5nIHRvIGZyZWUgYWxyZWFkeSBmcmVlIHZlY3Rv
ci4gVGhpcyBpcyBiZWNhdXNlIHNldHVwDQo+ID4gPiBvZg0KPiA+ID4gbWlzYyBpcnEgdmVjdG9y
cyBpbiBpNDBlX3Byb2JlIGlzIGRvbmUgYWZ0ZXINCj4gPiA+IGk0MGVfc2V0dXBfcGZfc3dpdGNo
LiBJZg0KPiA+ID4gaTQwZV9zZXR1cF9wZl9zd2l0Y2ggZmFpbHMgdGhlbiB3ZSB3aWxsIGp1bXAg
dG8gZXJyX3ZzaXMgYW5kIGNhbGwNCj4gPiA+IGk0MGVfY2xlYXJfaW50ZXJydXB0X3NjaGVtZSB3
aGljaCB3aWxsIHRyeSB0byBmcmVlIHRob3NlIG1pc2MgaXJxDQo+ID4gPiB2ZWN0b3JzIHdoaWNo
IHdlcmUgbm90IHlldCBhbGxvY2F0ZWQuIFdlIHNob3VsZCBoYXZlIHRoZSBwcm9wZXINCj4gPiA+
IGZpeA0KPiA+ID4gZm9yIHRoaXMgcmVhZHkgc29vbi4NCj4gPiANCj4gPiBZZXMsIEknbSBhd2Fy
ZSBvZiB3aGF0J3MgaGFwcGVuaW5nIGhlcmUgYW5kIHdoeSBpdCdzIGZhaWxpbmcuDQo+ID4gU2Fk
bHksIEkgYW0NCj4gPiBwcmV0dHkgc3VyZSBJIHdyb3RlIHRoaXMgY29kZSBiYWNrIGluIGxpa2Ug
MjAxMSBvciAyMDEyLCBhbmQgYmVpbmcNCj4gPiBhbiBlcnJvcg0KPiA+IHBhdGgsIGl0IGhhc24n
dCByZWFsbHkgYmVlbiB0ZXN0ZWQuDQo+ID4gDQo+ID4gSSBkb24ndCByZWFsbHkgY2FyZSBob3cg
dGhpcyBnZXRzIGZpeGVkIHRvIGJlIGhvbmVzdC4gV2UgaGl0IHRoaXMNCj4gPiBpbiBwcm9kdWN0
aW9uDQo+ID4gd2hlbiBvdXIgTE9NLCBmb3Igd2hhdGV2ZXIgcmVhc29uLCBmYWlsZWQgdG8gaW5p
dGlhbGl6ZSB0aGUNCj4gPiBpbnRlcm5hbCBzd2l0Y2ggb24NCj4gPiBob3N0IGJvb3QuIFdlIGVz
Y2FsYXRlZCB0byBvdXIgZGlzdHJvIHZlbmRvciwgdGhleSBkaWQgZXNjYWxhdGUgdG8NCj4gPiBJ
bnRlbCwgYW5kDQo+ID4gaXQgd2Fzbid0IHJlYWxseSBwcmlvcml0aXplZC4gU28gSSBzZW50IGEg
cGF0Y2ggdGhhdCBkb2VzIGZpeCB0aGUNCj4gPiBpc3N1ZS4NCj4gPiANCj4gPiBJZiB0aGUgdGVh
bSB3YW50cyB0byByZXNwaW4gdGhpcyBzb21laG93LCBnbyBhaGVhZC4gQnV0IHRoaXMgZG9lcw0K
PiA+IGZpeCB0aGUNCj4gPiBpbW1lZGlhdGUgaXNzdWUgdGhhdCB3aGVuIGJhaWxpbmcgb3V0IGlu
IHByb2JlKCkgZHVlIHRvIHRoZSBtYWluDQo+ID4gVlNJIG5vdA0KPiA+IGJlaW5nIG9ubGluZSBm
b3Igd2hhdGV2ZXIgcmVhc29uLCB0aGUgZHJpdmVyIGJsaW5kbHkgYXR0ZW1wdHMgdG8NCj4gPiBj
bGVhbiB1cCB0aGUNCj4gPiBtaXNjIE1TSS1YIHZlY3RvciB0d2ljZS4gVGhpcyBjaGFuZ2UgZml4
ZXMgdGhhdCBiZWhhdmlvci4gSSdkIGxpa2UNCj4gPiB0aGlzIHRvIG5vdA0KPiA+IGxhbmd1aXNo
IHdhaXRpbmcgZm9yIGEgZGlmZmVyZW50IGZpeCwgc2luY2UgSSdkIGxpa2UgdG8gcG9pbnQgb3Vy
DQo+ID4gZGlzdHJvIHZlbmRvciB0bw0KPiA+IHRoaXMgKG9yIGFub3RoZXIpIHBhdGNoIHRvIGNo
ZXJyeS1waWNrLCBzbyB3ZSBjYW4gZ2V0IHRoaXMgaW50bw0KPiA+IHByb2R1Y3Rpb24uDQo+ID4g
T3RoZXJ3aXNlIG91ciBwbGF0Zm9ybSByb2xsb3V0IGhpdHRpbmcgdGhpcyBwcm9ibGVtIGlzIGdv
aW5nIHRvIGJlDQo+ID4gcXVpdGUNCj4gPiBidW1weSwgd2hpY2ggaXMgdmVyeSBtdWNoIG5vdCBp
ZGVhbC4NCj4gDQo+IEl0J3MgYmVlbiAyIHdlZWtzIHNpbmNlIEkgcmVwbGllZC4gIEFueSB1cGRh
dGUgb24gdGhpcz8gIE1hY2llaiBoYWQNCj4gYWxyZWFkeSByZXZpZXdlZCB0aGUgcGF0Y2gsIHNv
IGhvcGluZyB3ZSBjYW4ganVzdCBtb3ZlIGFsb25nIHdpdGggaXQsDQo+IG9yIGdldCBzb21ldGhp
bmcgZWxzZSBvdXQgc29vbj8NCj4gDQo+IEknZCByZWFsbHkgbGlrZSB0aGlzIHRvIG5vdCBqdXN0
IGZhbGwgaW50byBhIHZvaWQgd2FpdGluZyBmb3IgYQ0KPiBkaWZmZXJlbnQgcGF0Y2ggd2hlbiB0
aGlzIGZpeGVzIHRoZSBpc3N1ZS4NCg0KSGkgUEosDQoNCkkgaGF2ZW4ndCBzZWVuIGEgcmVjZW50
IHVwZGF0ZSBvbiB0aGlzLiBJJ20gYXNraW5nIGZvciBhbiB1cGRhdGUuDQpPdGhlcndpc2UsIEFs
ZXggYW5kIFN5bHdlc3RlciBhcmUgb24gdGhpcyB0aHJlYWQ7IHBlcmhhcHMgdGhleSBoYXZlDQpz
b21lIGluZm8uDQoNClRoYW5rcywNClRvbnkNCg0KPiAtUEoNCj4gDQo+IF9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fDQo+IA0KPiBOb3RlOiBUaGlzIGVtYWlsIGlzIGZvciB0aGUgY29u
ZmlkZW50aWFsIHVzZSBvZiB0aGUgbmFtZWQNCj4gYWRkcmVzc2VlKHMpIG9ubHkgYW5kIG1heSBj
b250YWluIHByb3ByaWV0YXJ5LCBjb25maWRlbnRpYWwsIG9yDQo+IHByaXZpbGVnZWQgaW5mb3Jt
YXRpb24gYW5kL29yIHBlcnNvbmFsIGRhdGEuIElmIHlvdSBhcmUgbm90IHRoZQ0KPiBpbnRlbmRl
ZCByZWNpcGllbnQsIHlvdSBhcmUgaGVyZWJ5IG5vdGlmaWVkIHRoYXQgYW55IHJldmlldywNCj4g
ZGlzc2VtaW5hdGlvbiwgb3IgY29weWluZyBvZiB0aGlzIGVtYWlsIGlzIHN0cmljdGx5IHByb2hp
Yml0ZWQsIGFuZA0KPiByZXF1ZXN0ZWQgdG8gbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkg
YW5kIGRlc3Ryb3kgdGhpcyBlbWFpbCBhbmQNCj4gYW55IGF0dGFjaG1lbnRzLiBFbWFpbCB0cmFu
c21pc3Npb24gY2Fubm90IGJlIGd1YXJhbnRlZWQgdG8gYmUgc2VjdXJlDQo+IG9yIGVycm9yLWZy
ZWUuIFRoZSBDb21wYW55LCB0aGVyZWZvcmUsIGRvZXMgbm90IG1ha2UgYW55IGd1YXJhbnRlZXMN
Cj4gYXMgdG8gdGhlIGNvbXBsZXRlbmVzcyBvciBhY2N1cmFjeSBvZiB0aGlzIGVtYWlsIG9yIGFu
eSBhdHRhY2htZW50cy4NCj4gVGhpcyBlbWFpbCBpcyBmb3IgaW5mb3JtYXRpb25hbCBwdXJwb3Nl
cyBvbmx5IGFuZCBkb2VzIG5vdCBjb25zdGl0dXRlDQo+IGEgcmVjb21tZW5kYXRpb24sIG9mZmVy
LCByZXF1ZXN0LCBvciBzb2xpY2l0YXRpb24gb2YgYW55IGtpbmQgdG8gYnV5LA0KPiBzZWxsLCBz
dWJzY3JpYmUsIHJlZGVlbSwgb3IgcGVyZm9ybSBhbnkgdHlwZSBvZiB0cmFuc2FjdGlvbiBvZiBh
DQo+IGZpbmFuY2lhbCBwcm9kdWN0LiBQZXJzb25hbCBkYXRhLCBhcyBkZWZpbmVkIGJ5IGFwcGxp
Y2FibGUgZGF0YQ0KPiBwcm90ZWN0aW9uIGFuZCBwcml2YWN5IGxhd3MsIGNvbnRhaW5lZCBpbiB0
aGlzIGVtYWlsIG1heSBiZSBwcm9jZXNzZWQNCj4gYnkgdGhlIENvbXBhbnksIGFuZCBhbnkgb2Yg
aXRzIGFmZmlsaWF0ZWQgb3IgcmVsYXRlZCBjb21wYW5pZXMsIGZvcg0KPiBsZWdhbCwgY29tcGxp
YW5jZSwgYW5kL29yIGJ1c2luZXNzLXJlbGF0ZWQgcHVycG9zZXMuIFlvdSBtYXkgaGF2ZQ0KPiBy
aWdodHMgcmVnYXJkaW5nIHlvdXIgcGVyc29uYWwgZGF0YTsgZm9yIGluZm9ybWF0aW9uIG9uIGV4
ZXJjaXNpbmcNCj4gdGhlc2UgcmlnaHRzIG9yIHRoZSBDb21wYW554oCZcyB0cmVhdG1lbnQgb2Yg
cGVyc29uYWwgZGF0YSwgcGxlYXNlDQo+IGVtYWlsIGRhdGFyZXF1ZXN0c0BqdW1wdHJhZGluZy5j
b20uDQo=
