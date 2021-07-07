Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5EA3BF247
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhGGXCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 19:02:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:26399 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhGGXCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 19:02:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="206388029"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="206388029"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 15:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="410705248"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 07 Jul 2021 15:59:50 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 7 Jul 2021 15:59:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 7 Jul 2021 15:59:50 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 7 Jul 2021 15:59:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E56reUzPDbm9/kAv7k/sMXfIXvIWnQrK7gHApuOwzbY4Gm+ZzxW/zAYKm/d3556J+JId6w35fDuhps6Veg69wnXv3CaXfZWtygqNAitpvBtzwg3rYp48Yh0+NoEcyb8EXHJdrUGJItGDfcUTqt3WCnXv3OBk0LdKvimSK6axgvySejeX/gY/i1FanO/hOFZ+QKEzZeKXu5pqTisDi41LjHUjntDXQ1rZhfXOJwrwNb3r7hKWKDtCB51TcRY/bNoGPdy2t+wzjK2D4l+VofypOngImPwpYqiIAj2mzFXiZI339SB2hL/LoXqISfaa0YEtFmRTN6QErcSJrgvDi4GOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUv4lArxUVVnC357MsiF3vaP/BYd5IVD6CWSeY2htgI=;
 b=O3CWP8WdRCnAsWqm0FY6FTEw1GtQFegm6//WTFojEa9cYToXydh188ad7NgqfNzCUIkJuk0NROBKjkVqw/ccRL3lwuNYBTbwfZ4+0UHneK4c0j/RWjw7TAKD9qlT2+7R3L4p++OcK4BidkOugzxe5ChxG68RdS7IkDPlJ1l5MsFbJ+l2iK8IIQ/5Y3VUNpS1eHRSu7bVLXCLw57JuEnqMA+aZVHwSt1WlPjwP/etDyie0KRlBtbXjWmomkjBxmOOPQhsebaKOh0OwXJidtkr37U6gnTjKpTtbNst4skSZjZHbh0Aw0uvhoqg6DEGuxEFhilduzb2bjXAnne5SwCU5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUv4lArxUVVnC357MsiF3vaP/BYd5IVD6CWSeY2htgI=;
 b=yZSRo01NmxhFNYk8XifAX63JInp+4N0SGBvMiZNz/eUdhUZpJ9RgfdjOotPed6pm8qUko/LPZW6bknwCmHf9gOuR+Zz/Mn3zyyZK822cz/T5xIkgwpFSL86FPhr1DAWa2eZe6YzQ10mZHrjhbNBu1yH/of3BJkISwKQcXAsUyaM=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Wed, 7 Jul
 2021 22:59:48 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4308.021; Wed, 7 Jul 2021
 22:59:48 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        lkp <lkp@intel.com>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH] iavf: remove redundant null check on key
Thread-Topic: [PATCH] iavf: remove redundant null check on key
Thread-Index: AQHXbzVCYzjOBc1t90Wnf+HT8shaI6swBfYAgAD9AQCABycKgA==
Date:   Wed, 7 Jul 2021 22:59:48 +0000
Message-ID: <e5f0d67fb0f278886fc4c4ac862b3c68533bd2c7.camel@intel.com>
References: <20210702112720.16006-1-colin.king@canonical.com>
         <202107030209.xwGHO2JN-lkp@intel.com> <20210703092040.GX2040@kadam>
In-Reply-To: <20210703092040.GX2040@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f80e0b2b-6eed-4867-b8b3-08d9419aebce
x-ms-traffictypediagnostic: SA2PR11MB4873:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB487302F14169A8CBAE3427ABC61A9@SA2PR11MB4873.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ul330abpeQ8BoCKwQdgovlQBEj4HIlwMCjCNekM0OaAhAbhpv4J4Ebe8iHtJJGprVSl6qsE1zOk8C2qkkyc330G6nMPMLygtZuzaCqD+Vwoxk2jwAvCQt3Co97C/GvPL+YMO6/hFcjQ3Yc9t2lkMb5V4apVd8M1s8EDfSIPMNSpNTfJLRTgZBBRtjvYLtBnk4HQ9hqBPyuexO7lXM/iF4JRbtXpiGhDtnUhrHETNPzjFVCmmxB2+7KI64k+gq2SXpC/ffVruHwaxwdIWnqq9X4homr0+s05zZ+nxUcBxQk4OFIQt3XBj21rZ9Upy/vvrhXnDG/yp2e5a0ZmrzVQsWTn1WCrAel+FbNm2EG3E5r91CnF21p5yz/NrGDC8Y0miPVNGq0/3nBBJBx/NxvN7EEoF+Z3mdazSF7SmvFzZtE/wXKwxj1nsrR5/RVHtv8v8Z1mcNukjICf//HVMJLvPMzVAN3dH+zA0slcWFLnq8+gzfIvxe/i5j10Ke2SAIKVFkfZTPEPa2g+Rz3FttfWGlwWFpOwitki0TOubzeU1c7zdFbw67EvIh5qjFGwaDNRtSGjQmOSbdZsLX2lw7/l4hlpkm0fJtlI1qYTgHIT+C9kLy3t/B2fVSJnlouBZi+/h1vjuDHtXn//lqoiWosh1GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39860400002)(66476007)(4326008)(64756008)(478600001)(91956017)(66556008)(6506007)(66946007)(86362001)(6636002)(38100700002)(2616005)(4001150100001)(66446008)(316002)(110136005)(71200400001)(76116006)(122000001)(2906002)(26005)(186003)(83380400001)(54906003)(6486002)(36756003)(6512007)(8676002)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmFrR1FZY3RucldCUk9xbWQvRVV4bUlPZm51dGRLaERoODM0ZUZrdzA1QVZW?=
 =?utf-8?B?UzhBZ29CV3lNZXdTemxOVDhybWI5ZUVYQkFYRVFwYUZ5L09PWDJKWTlGajYr?=
 =?utf-8?B?cklMeTM4cDVBRU4xbGZJTDBYTzJsT1VObEhCMVN4UFdpeC9YN1pUVTBuamVX?=
 =?utf-8?B?SXJDRExxblFMMlhtOWViNVh4bmIzUGFBdk1SanhFTEFXa3h0THdMOFJGWXcv?=
 =?utf-8?B?VUhiTjZsTlZFdWFQTXR5dk0vNUh0c1YzRWNwUFIvMFZMck8xMnRoYXF1REI3?=
 =?utf-8?B?TlgyeXZrNjFXbmkrQWduMXFoTUl6Z2J3RjJvTlZOaG1QRkoyRDBiNEdjVGtW?=
 =?utf-8?B?TUtzTklnVit1VDBtR0EwS2hyZ0tHN24ydmVXSzF5aXBKYm4rUEloNzZZM0tu?=
 =?utf-8?B?eDUxVWcyVTlHeWZLcGlmdEVZVUlVcG1hV05qZlErbm1PdlU2dGpjbUNENWNt?=
 =?utf-8?B?elM3eGUzdnJSYWlyeHNRN3h0TEpFd3dESG12WWVxQzMrVzV3S1ljejVxbnJZ?=
 =?utf-8?B?ZmdrK2JybWk4akhxOS92T0xXa2plNTJZWmp1RmNNcVl4eFdoLzFPMUtzeEVo?=
 =?utf-8?B?bU1BcDM4UzdaaWYwenVyQWswRjNFekZtWW1MTFlmbGVpSldyTUc1MkNJS3BI?=
 =?utf-8?B?SjZxS0hlYWhBd3RzbjIxeGh2azR6UzRYK3ltbTQvTUcrWUtaNk53eGRuRkND?=
 =?utf-8?B?NHhhNUVLVTZXMUp4S2tQVjk4TDFMNzRVcjZqbG5vRTMvQzZ1SlBXNXpjcWFi?=
 =?utf-8?B?ZnFmU2ExSTRnajdMZHhHayt3elhHSU9oOXp4OCs5aUIxTTdYb0pWcGRhd3A3?=
 =?utf-8?B?djBOdXo2dFNwS3FyN2w1YkdGZ3g4aE9vaHdDWC84N2dhcVVuWGpjdG1OdzZs?=
 =?utf-8?B?WU5HTFFoUGxleHRGL21UalkxendrdnVLOE1OdVFPK2JSTzErbHRKTThzM3lC?=
 =?utf-8?B?RnQ3eXhmTEtIekJiSVBmWU9MUmh0YmVmdm05WTdOSkMvL2cwRVhhd0dqUUxv?=
 =?utf-8?B?ZzVxb1ZFK2ovWVBhQUZZbVU0c1ozWExHTUM1Y1dGcmNta1NEM0gwVmE4NEpI?=
 =?utf-8?B?WWdkSHV5b09LWHltOHRUTkpGVllkb08za1FYSTlsN0hSd3FNTmNZQjd2M3pl?=
 =?utf-8?B?YThDRDBKNDlpUVRWS1pPQUlENk93UEV6ZFUwVjFOUmVxSElTL1JYdVBEM3NX?=
 =?utf-8?B?M3ZpS2IzT281YkZQMXc1RDc1VVUwblRIaUtGcng0MTNpemtXZnRQOEZNL2Z4?=
 =?utf-8?B?TkpZMnRSTy95eEEya3RPOGRNck5oR1U3RERrWHFYMkt1ZzRXSWh1MzdTRFVi?=
 =?utf-8?B?TENUUmxuWEdFaVM3MDRwY2FPZkdVV2hxejd4TFoybkF6clVBZmp3dlIvT2lP?=
 =?utf-8?B?L3lnOXRkUUNqRm9JWUJ5OFFNTFdPL3JiV3NJQWhEbkVEM0xBSUtkcnB5SkNZ?=
 =?utf-8?B?SDhjQzRZeW5lQytqNzRrSGhjVlZuenVsTEhCZUVIZUNmb0dlbnptY1FhODhR?=
 =?utf-8?B?UVdxRjJhZUE4S0c1MGd1NEFhRlB3ZTd4T2FYZVB6L0hMV2VEd1JnSFVhN3ds?=
 =?utf-8?B?b2xsQ3QrZDh0YzhYT01EcC9DOE41L3RrQ0JWWHFEVGxuZnJGWEN1STVPZURF?=
 =?utf-8?B?ZmVtbGJsVG1DWUhJUGFrcktUV3pjc0xjaWZTZk5wb1oxWk96RlNSaGVFalZx?=
 =?utf-8?B?REpqVHJVaGxIcjRaOThhS2lBVkVuSUkvWVFaa0kvdFRQbGw2Z2hZNHowWHZm?=
 =?utf-8?Q?rZH4gjoyxVYRR4CWxbUKJhXpQCwuVw3WlVwHWm3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84FBE1CA0E0F184295063B0865F6BF1F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80e0b2b-6eed-4867-b8b3-08d9419aebce
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2021 22:59:48.5169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: You+Z8wAUBVP698lcweOT1SVAZPVrGftCK7AvXSnXK4hMA96Y/A7OV72N7IzfkRGaXDWFsoPklNIqaZ6dGCiqm2sx9QwSzVXOfnpcbeJek4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA3LTAzIGF0IDEyOjQ5ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBPbiBTYXQsIEp1bCAwMywgMjAyMSBhdCAwMjo0Mzo0NkFNICswODAwLCBrZXJuZWwgdGVzdCBy
b2JvdCB3cm90ZToNCj4gPiAxMjljZjg5ZTU4NTY3Ng0KPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2lhdmYvaTQwZXZmX2V0aHRvb2wuYyAgIEplc3NlIEJyYW5kZWJ1cmcNCj4gPiAyMDE4
LTA5LTE0ICAxODk5ICBzdGF0aWMgaW50IGlhdmZfc2V0X3J4Zmgoc3RydWN0IG5ldF9kZXZpY2UN
Cj4gPiAqbmV0ZGV2LCBjb25zdCB1MzIgKmluZGlyLA0KPiA+IDg5MjMxMWY2NmYyNDExIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGV2Zi9pNDBldmZfZXRodG9vbC5jDQo+ID4gRXlhbCBQ
ZXJyeSAgICAgICAyMDE0LTEyLTAyICAxOTAwICAJCQkgY29uc3QgdTggKmtleSwNCj4gPiBjb25z
dCB1OCBoZnVuYykNCj4gPiA0ZTlkYzMxZjY5NmFlOCBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pNDBldmYvaTQwZXZmX2V0aHRvb2wuYw0KPiA+IE1pdGNoIEEgV2lsbGlhbXMgMjAxNC0wNC0w
MSAgMTkwMSAgew0KPiA+IDEyOWNmODllNTg1Njc2DQo+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWF2Zi9pNDBldmZfZXRodG9vbC5jICAgSmVzc2UgQnJhbmRlYnVyZw0KPiA+IDIwMTgt
MDktMTQgIDE5MDIgIAlzdHJ1Y3QgaWF2Zl9hZGFwdGVyICphZGFwdGVyID0NCj4gPiBuZXRkZXZf
cHJpdihuZXRkZXYpOw0KPiA+IDJjODZhYzNjNzA3OTRmIGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2k0MGV2Zi9pNDBldmZfZXRodG9vbC5jDQo+ID4gSGVsaW4gWmhhbmcgICAgICAyMDE1LTEw
LTI3ICAxOTAzICAJdTE2IGk7DQo+ID4gNGU5ZGMzMWY2OTZhZTggZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaTQwZXZmL2k0MGV2Zl9ldGh0b29sLmMNCj4gPiBNaXRjaCBBIFdpbGxpYW1zIDIw
MTQtMDQtMDEgIDE5MDQgIA0KPiA+IDg5MjMxMWY2NmYyNDExIGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2k0MGV2Zi9pNDBldmZfZXRodG9vbC5jDQo+ID4gRXlhbCBQZXJyeSAgICAgICAyMDE0
LTEyLTAyICAxOTA1ICAJLyogV2UgZG8gbm90IGFsbG93IGNoYW5nZSBpbg0KPiA+IHVuc3VwcG9y
dGVkIHBhcmFtZXRlcnMgKi8NCj4gPiA4OTIzMTFmNjZmMjQxMSBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pNDBldmYvaTQwZXZmX2V0aHRvb2wuYw0KPiA+IEV5YWwgUGVycnkgICAgICAgMjAx
NC0xMi0wMiAgMTkwNiAgCWlmIChrZXkgfHwNCj4gPiA4OTIzMTFmNjZmMjQxMSBkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pNDBldmYvaTQwZXZmX2V0aHRvb2wuYw0KPiA+IEV5YWwgUGVycnkg
ICAgICAgMjAxNC0xMi0wMiAgMTkwNyAgCSAgICAoaGZ1bmMgIT0NCj4gPiBFVEhfUlNTX0hBU0hf
Tk9fQ0hBTkdFICYmIGhmdW5jICE9IEVUSF9SU1NfSEFTSF9UT1ApKQ0KPiA+IDg5MjMxMWY2NmYy
NDExIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGV2Zi9pNDBldmZfZXRodG9vbC5jDQo+
ID4gRXlhbCBQZXJyeSAgICAgICAyMDE0LTEyLTAyICAxOTA4ICAJCXJldHVybiAtRU9QTk9UU1VQ
UDsNCj4gPiA4OTIzMTFmNjZmMjQxMSBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBldmYv
aTQwZXZmX2V0aHRvb2wuYw0KPiA+IEV5YWwgUGVycnkgICAgICAgMjAxNC0xMi0wMiAgMTkwOSAg
CWlmICghaW5kaXIpDQo+ID4gODkyMzExZjY2ZjI0MTEgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaTQwZXZmL2k0MGV2Zl9ldGh0b29sLmMNCj4gPiBFeWFsIFBlcnJ5ICAgICAgIDIwMTQtMTIt
MDIgIDE5MTAgIAkJcmV0dXJuIDA7DQo+ID4gODkyMzExZjY2ZjI0MTEgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaTQwZXZmL2k0MGV2Zl9ldGh0b29sLmMNCj4gPiBFeWFsIFBlcnJ5ICAgICAg
IDIwMTQtMTItMDIgIDE5MTEgIA0KPiA+IDQzYTNkOWJhMzRjOWNhIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2k0MGV2Zi9pNDBldmZfZXRodG9vbC5jDQo+ID4gTWl0Y2ggV2lsbGlhbXMgICAy
MDE2LTA0LTEyIEAxOTEyICAJbWVtY3B5KGFkYXB0ZXItPnJzc19rZXksIGtleSwNCj4gPiBhZGFw
dGVyLT5yc3Nfa2V5X3NpemUpOw0KPiANCj4gSGVoLi4uICBUaGVyZSBoYXZlIGJlZW4gYSBidW5j
aCBvZiBwYXRjaGVzIG1vZGlmeWluZyB0aGUgYmVoYXZpb3IgaWYNCj4gImtleSIgaXMgbm9uLU5V
TEwgYW5kIG5vIG9uZSBub3RpY2VkIHRoYXQgaXQncyBhY3R1YWxseSBpbXBvc3NpYmxlLg0KDQpX
ZSBhcmUgY2FwYWJsZSBvZiBzdXBwb3J0aW5nIGEga2V5IGNoYW5nZS4gV2UncmUgd29ya2luZyBv
biBhIHBhdGNoIHRvDQpyZXNvbHZlIHRoZSBjaGVjayBhbmQgYWxsb3cgdGhlIGtleSB0byBiZSBj
aGFuZ2VkLg0KDQotIFRvbnkNCg0KPiA6UA0KPiANCj4gcmVnYXJkcywNCj4gZGFuIGNhcnBlbnRl
cg0KPiANCg==
