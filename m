Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8947B408
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhLTT4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:56:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:54296 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230515AbhLTT4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 14:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640030193; x=1671566193;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MdUm9Ooy4kdl05QMKv7hWo7epDL+j+nPEYIsE2ASZ1s=;
  b=X/eBjEYR0O4EgByFDf48NiikgLyrb9vC8GEUZym70tag6WD3oJ5bthqq
   vBml5xToZKHDHHcoknjWwSr1o134SWzQhsoh0ZRchWpuVtMTpXx7PNpm2
   cXYyetiF0E1wlNqcd4UoKtkjjHycJyAU1WFMydkngmTQb8CGKmJqNZoZb
   Nw42cqRqSvh7kTC+Jg/zA9AWDljOQtBe2f5Sjuk9B6eVcoKqMysqvDEO+
   AQ7ALM5mVvIGFOuC12gIVULBkC/qQJMfFCQr78YubyDlFwdq1L0nDxtNb
   kJoRh8KaGTCe4kkB9ilphF+agdJ2Vno9M0m8LztaPfObCasB9iEG+A0+H
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="240212869"
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="240212869"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 11:56:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="755509191"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 20 Dec 2021 11:56:31 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 20 Dec 2021 11:56:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 20 Dec 2021 11:56:30 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 20 Dec 2021 11:56:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VX/aWbxVFeYuIKIoZ+d9A89RO4Xnc3uv+QfTUjrpaZot4ia8O/4t5J2T+otOnKsL0ARv91/dDza4jMRJCLtyrQ50rj001lEvWUMCsBM6pdwJuNKjs/7bntG8f4vxhjjIo6/Ypmx4jQ3Gejkvg1/gjZHtmnB/PKNxAnjPZVxdPwPMm78OBwVKiFdEXpRopgOQr94/RevXhSeM+z+oMlmi9SZoPUaKARGQqm1g96EgC1UGLSbAHE0ExUlaZdkPI+PvE4JRrieQEGjDjSGPXne92lkEdk4LguqdIDr2S5ahji/Zpxze9hcmhGAUtLhJ5wdQdyuM9shGif4e/SaEQjNEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MdUm9Ooy4kdl05QMKv7hWo7epDL+j+nPEYIsE2ASZ1s=;
 b=ZysenDD/+lE4YXHQHfeRwBiMVKK/bWpw0/GIbGek/gTRUS2/fk9rw77m1rnbtI6GfnQA2lF5qYUuZxwH62U7Lnqeypztg6U5iuxQsNaM3+n2lkkZ8YPUb8GP5b8TkCFwreHeKz8cw10rsDWPmy/OxHegtar5FtISLXvqlHYvZpvfLFfZ6Hyr6j97BLmBXsP4aE0NW5bE3nxD/Rh5v26w47K4NcYIbh74gGwp3KZPLqmkl0AcrVWG2SU+2DUQFCnECXZWoUuC6+A4sOzZIRCKKLzFrs6NXZ2a4iXM2dNykWnyjwDjnJtEGtvYWQN/zJtr4nxx3rB4MO9ZsdrbT2/Y0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3470.namprd11.prod.outlook.com (2603:10b6:805:b7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 19:56:28 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::10ca:cadc:48f6:b883]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::10ca:cadc:48f6:b883%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 19:56:28 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "regressions@leemhuis.info" <regressions@leemhuis.info>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "Torvalds, Linus" <torvalds@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM resume
 path
Thread-Topic: [PATCH net] igb: fix deadlock caused by taking RTNL in RPM
 resume path
Thread-Index: AQHX5WYXJPou2v+DZUGQLd03epxoeaw5mrWAgAJRnwA=
Date:   Mon, 20 Dec 2021 19:56:28 +0000
Message-ID: <b4be04bbd6a20855526b961ef80669bd2647564c.camel@intel.com>
References: <6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com>
         <edb8c052-9d20-d190-54e2-ed9bb03ba204@leemhuis.info>
In-Reply-To: <edb8c052-9d20-d190-54e2-ed9bb03ba204@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cec030c-f25c-40b9-5088-08d9c3f2cfbd
x-ms-traffictypediagnostic: SN6PR11MB3470:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SN6PR11MB3470F1190FB3CE37EAC93022C67B9@SN6PR11MB3470.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 60tibsAm18VtRVnbReZbJrOG3jwaGIEpNNF6I3hlt2Iol1RSSFfEFteQ1c+5MxCMawnk+9Ker3zIh+Wr8d+/bT9CXDCFXeI/ZQ+fkpCu5r0kUEcRsEaoNOWZdSwEoQZRmO1XNcSeEwONS4fHLi2GblCNiXu8YwkiVrfKKiDHzfukDzfTJStKvW4MhOkB0lB2SQ5p9SwcH1wLPKQ+Zll4HJVB+VrCRHD8k40OSJnWCH6qmy9iZcBTZ9chr78blad4f/fGrMcXc91P4JnGcEFvlxT+N/C8PW/NbBX3pe/Ls2KFLMUeUkTf1dBGyAGEzMNtB5IUH00d1Jpuits9olBBg+SkIXGJEu9XX3rUn/g3UqedHfrprc0uPhUaugVpCS6kr1cP50qQE9rU3BcsliWas0tk3Rnt6CTj6H5UdyqrX2ux14w+osoY4ohsgPmRaOj40bSzLBu2Ey0c2lU388aQexTbIkAQefvZ9oztiJrZ3L6frcHnvZcYSfc2yRKtRk/GvOGoDrOMmEMb5eOOCpm1pY9h3RzTNxF2tO35cFEd+YZDJTB3K+QuKedDvbPNSgAPk/qghhBwcBPcsmUQQKTbzS/FOkxfkzDssGUmGxOaFEAiIEClJV/Bjp4b5R8HtWV/u9Wb9p8hrbF9RuwLUsBiP8UIiXeEb3D2egnbH5EeXg6CIIfYsyV3odP0fagS6V+L8LHQ2laHWvZJjLt2t2+thpFWszRwXA2ScXW64h4Oqmf7kyNf6axJNZFvtRDlv13A/Z3oXMz25tgxXS9IPpYth+xWFDApTYzwt7pifsOlaUWV3QcleQ/uI1MZA/MkxLYxM6hgBU+vC6w4I5/RHN3aZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(6512007)(966005)(4001150100001)(8936002)(508600001)(83380400001)(38070700005)(82960400001)(4326008)(5660300002)(122000001)(86362001)(66476007)(91956017)(66556008)(64756008)(6486002)(66946007)(36756003)(6636002)(76116006)(26005)(2616005)(71200400001)(186003)(8676002)(6506007)(53546011)(66446008)(316002)(110136005)(54906003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1dQczU3ZU1Ja3cyYnZSdVVCa1JhcDM1TTVZSHp4TGdJZHFzU00velRadk5K?=
 =?utf-8?B?aWNkWVhhRXNlRks2R1d4WWhFS2Y4NWtRaUl6dkRNY0ZaaE5GQk1WWnpLaWNy?=
 =?utf-8?B?OHZNN09rU2VmRUJkVXRid3RpQTBpUWEwS1hhM29lQTRHd1lPRExPcEphNmh1?=
 =?utf-8?B?MzFaSHVEc1B0bzBwZXBnZFVrbW5PZzJ1bFlXY2ZPRlBQVTExd1lUdUdKL0pp?=
 =?utf-8?B?SGZqckRsVE1LUDZPd1A1RUNsVmlXSk91M2x0SDlvYUc1SmluWWN0NndRSlQ0?=
 =?utf-8?B?eWpMRy9SN2lkY05NSDNOWTR1NDB4bGdaRkNGd1dLenpyMDRCZFhrbzBRWi9u?=
 =?utf-8?B?cVllTGxMcFZDSDlZemJIbTdrVlBLSFFhYTJEd0Y2YTd2K1dVSERYSnp6TzZ6?=
 =?utf-8?B?Rk1TRE9ibGlObmFzUmduRUg4OEUzenIwQ0hGMDQvNTY2TGFlb2pNRTVGRkh5?=
 =?utf-8?B?ZEhjNkpIWVFZbktoL2k4NXIzNTJOWStJZ2szMG5EUWMzRE1aZFdRQzdEeFhq?=
 =?utf-8?B?RUx6Y2E2L2wvK1U0OXRKczBjMkMrYTJFVkRxQ082bEpBbjNEcHlKTjhXZTNz?=
 =?utf-8?B?YjNNMWp4UTdUN1Y3K3Z0bTZwb0J3UnVlK1EyRmQ1bEVLUUU5SEJienUvWm9K?=
 =?utf-8?B?RHcyZ0xyYVdlcHRKNUxpak9uTEZDYW8vTDRMMWNSWEdDcVo3eVJKM2hSMFl4?=
 =?utf-8?B?NktNSEdQQVZjN2toRThJa2E0Y3ZEMUFubG16RzA2MHd1M0tUcG02VmFSMVB3?=
 =?utf-8?B?Qzd0QTN0TlJqK3FLMWVqTVFKU1VxTUpISm5SUVMxYVk2VXY4ZGttdm1PR243?=
 =?utf-8?B?SzkwN0hDTkZSbCtJNkx0VDJGR21tZ1pRL0FrVktFVGdJNUIwRVBQSlpLdml0?=
 =?utf-8?B?U01Wd2EzQ1hNYzhkckt5eUZZVEdwS05lN2RzUThqdHNNT0NMNldoenZFbytT?=
 =?utf-8?B?dWF0MkhoNWs3T0s4V1NBV2NBazZLbmRQTFFwVDJWWXlPcmNaNDBDenFIL1pr?=
 =?utf-8?B?NkxVOTlENXprZnNtV3BQN2hMM01TclNaRVYvMFlWejljZ00vRG14VHFNSW55?=
 =?utf-8?B?NkhkMUN1UzhGZ015ZGYzZkJaTUhzRFFvZ1NqVk4zUjZwUU1wSzNRbDN1OWtH?=
 =?utf-8?B?bHZhalBjZy9lOTJqOWdZOXRoZGxvSmQxZFlnTkpDb1NNWm9TOWNva2FpTmRC?=
 =?utf-8?B?T0h5dnBjWkpxOUpjVjZwdWRaemUrVGRiUGV1b01jMjR2ZUE0L0x1YllwclhI?=
 =?utf-8?B?UmtMNU5xSUh6SC8rbnBrd1JhZ2Nudi84eEFtR3VvNXR2bjZLckVnSGU5Ymxh?=
 =?utf-8?B?aDRtV2VERURvTzlsUVFwbFBYVEFWSnNEZ2VGWkRTRHFUbi8za01IaDRsRFhT?=
 =?utf-8?B?c1RuR0F2bzlud0NmaWRML3NzYjdVR3dKRGJYb3BpNllJc3g1azhuQ0FOMnlP?=
 =?utf-8?B?b3g0d2FrMzNxbkdxZ0lGaEx5ZWd1dUx4b3cyTXVIRC95d1N4NjJEdHdGVEJ0?=
 =?utf-8?B?UFlSNndBMHpkdkMrVDVDRGNZVVBqMlJEejFHTGZEemd1Q1hTdmtEcUxzdTFS?=
 =?utf-8?B?STVzTGJQTU5RR1lrZ3AwQnRYVnFnTENqeVRzZ3J6UDk4dDNWcHhvbVhSMTRE?=
 =?utf-8?B?cjN6R24yclBCMUpSSkxyaTZVYitCU0lHbENWemJiU2JOMUE3WWJyQit2OExF?=
 =?utf-8?B?NzlRYWd5eEY4ZUVnSVVwTmovWXJEM1Jqelk5TWJIQ3FIYzJNdDgvTkdCWnlE?=
 =?utf-8?B?eVF3eW11YkNLYU9ta29MSUVhL1ZEdnZJTGdSMm1EMDc3VjVNaGRMSE9LZFQr?=
 =?utf-8?B?SGNWaVVsWTlVN3d5UmJUSFF4a2hFQ3BEN3hMNVp3MXN2T3g2VEs5K0grRG1W?=
 =?utf-8?B?UnhvdUNJaDRZN1QvRUExNmxPL0pKVVhVaUhYQmVwaU1jMmRTN2hCNWd4SGZm?=
 =?utf-8?B?eTNTR2JsREYyYTZzdTlZc3I3NWRIYjBxdGRPVGhLT2JBb0luVmV0VUdwOUR1?=
 =?utf-8?B?Wm5SYTBMM05udGRCNUhqbGlyRTNxNzBwSEhMZmYyVDJRb0RNQjhqRVF1eDQ2?=
 =?utf-8?B?NWwrZGMvNFFMMldISG83TytWVnZNYWh0NTIwS1ptb1FjNUhiellWU1dHSHpR?=
 =?utf-8?B?TnlNMlNSYmd0TjhvSnlEWHV4d21TUzhsTTg3aHU2SXk3K3R1eUVmM0poVWNn?=
 =?utf-8?B?RCs0dnFhaGNsZEpCakg1Y2NKTXpMMGJuR3VtNVJjMFl5aTBkdHBzS2VaWFhs?=
 =?utf-8?Q?Pjs4jM9e0jAkBdFS0QqapCw+XOSHKreWM2GrkT7B3Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14D59CFC74DA5543BA49C1072E08FE12@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cec030c-f25c-40b9-5088-08d9c3f2cfbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 19:56:28.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hR0xTrrPlm8hq/hbKssLQrtJCIMPm6d1NbkWcj7nXv9GGgQilO3hD0eYbZag3CJ7q02eMey6xDcDOqSv+MMn05Fxco18GxFtCYzLz2gJCk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3470
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTEyLTE5IGF0IDA5OjMxICswMTAwLCBUaG9yc3RlbiBMZWVtaHVpcyB3cm90
ZToNCj4gSGksIHRoaXMgaXMgeW91ciBMaW51eCBrZXJuZWwgcmVncmVzc2lvbiB0cmFja2VyIHNw
ZWFraW5nLg0KPiANCj4gT24gMjkuMTEuMjEgMjI6MTQsIEhlaW5lciBLYWxsd2VpdCB3cm90ZToN
Cj4gPiBSZWNlbnQgbmV0IGNvcmUgY2hhbmdlcyBjYXVzZWQgYW4gaXNzdWUgd2l0aCBmZXcgSW50
ZWwgZHJpdmVycw0KPiA+IChyZXBvcnRlZGx5IGlnYiksIHdoZXJlIHRha2luZyBSVE5MIGluIFJQ
TSByZXN1bWUgcGF0aCByZXN1bHRzIGluIGENCj4gPiBkZWFkbG9jay4gU2VlIFswXSBmb3IgYSBi
dWcgcmVwb3J0LiBJIGRvbid0IHRoaW5rIHRoZSBjb3JlIGNoYW5nZXMNCj4gPiBhcmUgd3Jvbmcs
IGJ1dCB0YWtpbmcgUlROTCBpbiBSUE0gcmVzdW1lIHBhdGggaXNuJ3QgbmVlZGVkLg0KPiA+IFRo
ZSBJbnRlbCBkcml2ZXJzIGFyZSB0aGUgb25seSBvbmVzIGRvaW5nIHRoaXMuIFNlZSBbMV0gZm9y
IGENCj4gPiBkaXNjdXNzaW9uIG9uIHRoZSBpc3N1ZS4gRm9sbG93aW5nIHBhdGNoIGNoYW5nZXMg
dGhlIFJQTSByZXN1bWUNCj4gPiBwYXRoDQo+ID4gdG8gbm90IHRha2UgUlROTC4NCj4gPiANCj4g
PiBbMF0gaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTUxMjkN
Cj4gPiBbMV0NCj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTExMjUwNzQ5
NDkuNWY4OTc0MzFAa2ljaW5za2ktZmVkb3JhLXBjMWMwaGpuLmRoY3AudGhlZmFjZWJvb2suY29t
L3QvDQo+ID4gDQo+ID4gRml4ZXM6IGJkODY5MjQ1YTNkYyAoIm5ldDogY29yZTogdHJ5IHRvIHJ1
bnRpbWUtcmVzdW1lIGRldGFjaGVkDQo+ID4gZGV2aWNlIGluIF9fZGV2X29wZW4iKQ0KPiA+IEZp
eGVzOiBmMzJhMjEzNzY1NzMgKCJldGh0b29sOiBydW50aW1lLXJlc3VtZSBuZXRkZXYgcGFyZW50
IGJlZm9yZQ0KPiA+IGV0aHRvb2wgaW9jdGwgb3BzIikNCj4gPiBUZXN0ZWQtYnk6IE1hcnRpbiBT
dG9scGUgPG1hcnRpbi5zdG9scGVAZ21haWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEhlaW5l
ciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IA0KPiBMb25nIHN0b3J5IHNob3J0
OiB3aGF0IGlzIHRha2VuIHRoaXMgZml4IHNvIGxvbmcgdG8gZ2V0IG1haW5saW5lZD8gSXQNCj4g
dG8NCj4gbWUgc2VlbXMgcHJvZ3Jlc3NpbmcgdW5uZWNlc3Nhcnkgc2xvdywgZXNwZWNpYWxseSBh
cyBpdCdzIGENCj4gcmVncmVzc2lvbg0KPiB0aGF0IG1hZGUgaXQgaW50byB2NS4xNSBhbmQgdGh1
cyBmb3Igd2Vla3Mgbm93IHNlZW1zIHRvIGJ1ZyBtb3JlIGFuZA0KPiBtb3JlIHBlb3BsZS4NCj4g
DQo+IA0KPiBUaGUgbG9uZyBzdG9yeSwgc3RhcnRpbmcgd2l0aCB0aGUgYmFja2dyb3VuZCBkZXRh
aWxzOg0KPiANCj4gVGhlIHF1b3RlZCBwYXRjaCBmaXhlcyBhIHJlZ3Jlc3Npb24gYW1vbmcgb3Ro
ZXJzIGNhdXNlZCBieQ0KPiBmMzJhMjEzNzY1NzMNCj4gKCJldGh0b29sOiBydW50aW1lLXJlc3Vt
ZSBuZXRkZXYgcGFyZW50IGJlZm9yZSBldGh0b29sIGlvY3RsIG9wcyIpLA0KPiB3aGljaCBnb3Qg
bWVyZ2VkIGZvciB2NS4xNS1yYzEuDQo+IA0KPiBUaGUgcmVncmVzc2lvbiAoImtlcm5lbCBoYW5n
cyBkdXJpbmcgcG93ZXIgZG93biIpIHdhcyBhZmFpayBmaXJzdA0KPiByZXBvcnRlZCBvbiBXZWQs
IDI0IE5vdiAoSU9XOiBuZWFybHkgYSBtb250aCBhZ28pIGFuZCBmb3J3YXJkZWQgdG8NCj4gdGhl
DQo+IGxpc3Qgc2hvcnRseSBhZnRlcndhcmRzOg0KPiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5v
cmcvc2hvd19idWcuY2dpP2lkPTIxNTEyOQ0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRk
ZXYvMjAyMTExMjQxNDQ1MDUuMzFlMTU3MTZAaGVybWVzLmxvY2FsLw0KPiANCj4gVGhlIHF1b3Rl
ZCBwYXRjaCB0byBmaXggdGhlIHJlZ3Jlc3Npb24gd2FzIHBvc3RlZCBvbiBNb24sIDI5IE5vdiAo
dGh4DQo+IEhlaW5lciBmb3IgcHJvdmlkaW5nIGl0ISkuIE9idmlvdXNseSByZXZpZXdpbmcgcGF0
Y2hlcyBjYW4gdGFrZSBhIGZldw0KPiBkYXlzIHdoZW4gdGhleSBhcmUgY29tcGxpY2F0ZWQsIGFz
IHRoZSBvdGhlciBtZXNzYWdlcyBpbiB0aGlzIHRocmVhZA0KPiBzaG93LiBCdXQgYWNjb3JkaW5n
IHRvDQo+IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE1MTI5
I2M4wqB0aGUgcGF0Y2ggd2FzDQo+IEFDS2VkIGJ5IFRodSwgNyBEZWMuIFRvIHF1b3RlOiBgYGBU
aGUgcGF0Y2ggaXMgb24gaXRzIHdheSB2aWEgdGhlDQo+IEludGVsDQo+IG5ldHdvcmsgZHJpdmVy
IHRyZWU6DQo+IGh0dHBzOi8va2VybmVsLmdvb2dsZXNvdXJjZS5jb20vcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L3RuZ3V5L25ldC1xdWV1ZS8rL3JlZnMvaGVhZHMvZGV2LXF1ZXVlYGBgDQo+IA0K
PiBBbmQgdGhhdCdzIHdoZXJlIHRoZSBwYXRjaCBhZmFpY3Mgc3RpbGwgaXMuIEl0IGhhc24ndCBl
dmVuIHJlYWNoZWQNCj4gbGludXgtbmV4dCB5ZXQsIHVubGVzcyBJJ20gbWlzc2luZyBzb21ldGhp
bmcuIEEgbWVyZ2UgaW50byBtYWlubGluZQ0KPiB0aHVzDQo+IGlzIG5vdCBldmVuIGluIHNpZ2h0
OyB0aGlzIHNlZW1zIGVzcGVjaWFsbHkgYmFkIHdpdGggdGhlIGhvbGlkYXkNCj4gc2Vhc29uDQo+
IGNvbWluZyB1cCwgYXMgZ2V0dGluZyB0aGUgZml4IG1haW5saW5lZCBpcyBhIHByZXJlcXVpc2l0
ZSB0byBnZXQgaXQNCj4gYmFja3BvcnRlZCB0byA1LjE1LnksIGFzIG91ciBsYXRlc3Qgc3RhYmxl
IGtlcm5lbCBpcyBhZmZlY3RlZCBieQ0KPiB0aGlzLg0KDQpJJ3ZlIGJlZW4gd2FpdGluZyBmb3Ig
b3VyIHZhbGlkYXRpb24gdGVhbSB0byBnZXQgdG8gdGhpcyBwYXRjaCB0byBkbw0Kc29tZSBhZGRp
dGlvbmFsIHRlc3RpbmcuIEhvd2V2ZXIsIGFzIHlvdSBtZW50aW9uZWQsIHdpdGggdGhlIGhvbGlk
YXlzDQpjb21pbmcgdXAsIGl0IHNlZW1zIHRoZSB0ZXN0ZXIgaXMgbm93IG91dC4gQXMgaXQgbG9v
a3MgbGlrZSBzb21lIGluIHRoZQ0KY29tbXVuaXR5IGhhdmUgYmVlbiBhYmxlIHRvIGRvIHNvbWUg
dGVzdGluZyBvbiB0aGlzLCBJJ2xsIGdvIGFoZWFkIGFuZA0Kc2VuZCB0aGlzIG9uLg0KDQpUaGFu
a3MsDQpUb255DQoNCg0KDQo=
