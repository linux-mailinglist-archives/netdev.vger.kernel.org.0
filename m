Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB2376D0B
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhEGWyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:54:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:56091 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGWyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 18:54:22 -0400
IronPort-SDR: CZRs6OfQAoA4aoQSpr0r0HqhUJnIxvpTae4i9W2rp2e/OnShKgkRHrLOm1gIqgbtybclnjp7Nd
 JBjzSaaXegsA==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="260103011"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="260103011"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 15:53:22 -0700
IronPort-SDR: P/Xf4lFp2pP2+LRtavTgfyrh3UufwWxaJY9msUs33+m63Gnd8g0tKpmy1mJpwsUTTzDuhZTVcd
 GCJOGf4d3yPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="391247321"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 07 May 2021 15:53:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 7 May 2021 15:53:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 7 May 2021 15:53:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 7 May 2021 15:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVgmnpWSdYw97wQN541xqA14niO+xdWgNemo2dUknRlXQaFCS8+aHe/3LH4B255B/+FM67RydfAza4kECdYUY8dO3FW8FwLZmx6c7Xi5Pg+P6F3IUzgV94OvYGuPnJhqb5mmuS1HGTmu4CDZtL4VwyrkT7E2uIY/DZCMrz4wwUgeo3JAJX4dV3M7mFfW2r0jD4znNjEh2Yya0fU8xitmKQrp1b6ROKZO+9mXIyMAZmKOQsodYjvZicTChmMIXrSM7VP7T8s14uoc8g9xBto+raZ0ZuBdkqtooLfDdJhhmJXqD9/mOPDn1Pln3wu3iW82bPc5Q5eAzLRiZCJVcPt+5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqGOrJksCo5/qPZGVajebMZLWZqvmU0HPMcS1hpZAJ4=;
 b=FTA/npfubImOZO/s1+Un50OH1PBtmTkBwoMEn01KAJlWYEW5nONCfuqaxbylucRzA+ogGrMZ8zxW5CB80FzmcH6eC1keTRCGYq5yMwJ+jNdDXkC3YDhFGhKsxYmSrQmA4V8BTW05C8JGWIBM/cuWCHMij7nWHC/BhYVowVhLFZs5Qwn/lg1R7kPz4RZ7zkQljr3p6j0O+qN8Zfi0M5MGv5v8rX9jHMkNNdSq4FHZSKRLVyqKPFP8uo+2d1/RBid8ZKLJAYQVaP2PV0thJiZ/V+ZSa/b2YsrI+sLaxqtRIF7g2pRr2N9gf9czUUIbZQ8YnNXjXAL4Xs793lnUS8/19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqGOrJksCo5/qPZGVajebMZLWZqvmU0HPMcS1hpZAJ4=;
 b=agv+I4GwEqOEyKOQFverYcNaTy73CqAsd2wqQ0Evz2TX/X6CPJzsC+R/YwaQi96z9sS+XKQEyzmSFf+QxsskLxwi5Cj9KYEnA6ktRx45s8sEofAVcV4aMmOcJGus++DkIprsqexFr+9FX0qxyrsfhtj2PBt/CzSlIO6TOB+iWBo=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3470.namprd11.prod.outlook.com (2603:10b6:805:b7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 22:53:18 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4108.027; Fri, 7 May 2021
 22:53:18 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Verplanke, Edwin" <edwin.verplanke@intel.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Dumitrescu, Cristian" <cristian.dumitrescu@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next 0/4] i40e: small improvements on XDP path
Thread-Topic: [PATCH net-next 0/4] i40e: small improvements on XDP path
Thread-Index: AQHXQ4+1iwFrmgi1IkuLVydPGEu21KrYoGmA
Date:   Fri, 7 May 2021 22:53:18 +0000
Message-ID: <c31e5d21868c2773897f88dfe97a2471b2ba7f35.camel@intel.com>
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
         <CAJ8uoz3YSuPj6F+GHkk6yXHryUEOUhVSg2pDVEVrFA6b8Hgu6g@mail.gmail.com>
         <20210118103233.49bfd205@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20210507221135.GB18159@ranger.igk.intel.com>
In-Reply-To: <20210507221135.GB18159@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84d16066-2316-4019-a3dc-08d911aae7fe
x-ms-traffictypediagnostic: SN6PR11MB3470:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3470839DD4A690CD38325AF5C6579@SN6PR11MB3470.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hSfroNI89RvndGOXU8JvvZ3rM2lP2LMYO6mXLZRH1UY9FQFZnkgwGCWEAw+bhA5MOR6tqwgBsLeObEyQj0vEhXYiabvpE8Gr7aMEQ8ZsPGx/l9fdTLc5NEum8/IxGFSsHz1k3g4WRj4FzE9IwGkJujgIZmIHNftwOi9OZorZRGZDt6DSQtZcUOc4RBGwADXD8AqtKUCzmLMhg+WRIeNjnhZWEU49oVy0kstvGb4Ft8sF/4bBoNRy5Mr6UJxClaJcs0P6hUKxPckGRp1SN4DQFmsDWmwwXdyQ7oL6qyYR/l44FVShrYgPh5SExBGpo6cX9Qvsh9ouaJgfdBlzr5RRF/kiHjQeQDOwOTbYbOk8G3kqDEnmSORdlQGwPxQGaoEXx1Jjll9TZg14BUjNn22BjbZlnNkFIHUzyTI9VUZJZDzAAqs/aMPEQC3nE347q9UbysC+2397rF9cyKzLhvO6RJ2/l8zkq/KOBgboVvM2j2m4+ndOVZtUJlq7apuNndZKrqChIFaq+TR2ENHzIr1WrkQovzyOgO77NottNkujLYW3z09pByga3OwhH3K58wg7fbNVpSABLSj5v6TYY1oHEzBBFaAXglQaZq2XHBhHpC+uiy0V3nqVFQZ4nzogzjhKjaGGUBipBDkHJn6W5MFluYsZ52hL3jD9IsS4tbRwgcJ6UU4HS2w/BoLyJgUtqVtlvikMN7BWcLQs8+RxdF2SyPw3gzDIWAFh/9Z2Y4MtDio=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(122000001)(38100700002)(71200400001)(91956017)(2616005)(2906002)(53546011)(6506007)(86362001)(6486002)(966005)(6636002)(316002)(83380400001)(66446008)(64756008)(66556008)(66476007)(478600001)(54906003)(4326008)(6512007)(8936002)(26005)(186003)(8676002)(66946007)(110136005)(76116006)(5660300002)(36756003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WEgrSmVHejZGc3RqcjIyYmFkaWcwZWNwV2lheVZNWlErOU4wSXNWbXQ2Mkx1?=
 =?utf-8?B?YXptQlRTSUNxSXROdnBDNmY5SVYrR0R4anVDcW9QS1FmaTdlVjlnVFFFOFkz?=
 =?utf-8?B?TUM1QjIzT1NCLytldmh5WW1kV2VXMklidWdCaHplalp6VWpJalpDSFRiUkFy?=
 =?utf-8?B?TWpmMlRNNGM1cy9Qc1NkMHZDd3Q5YW40Qk05WnhsbDJTVGJKclFjQ2FoREZv?=
 =?utf-8?B?d0xUNlRhdmJOQ2VEUTdIUy9QREs1V09ubGt2QWxyR2FsSm5mZ2ZKVzdPRUps?=
 =?utf-8?B?TzV5VXR3bEplNVZjQWNIMFlxY0VtSVZDNjRoQjFTcThEUUhSMVk4bXk2eWxs?=
 =?utf-8?B?cTFHdmcyRnNKeDduVG5BenlVSzZVaXNoc2lGMFFVNDM4WlV0MERqQ051b2JP?=
 =?utf-8?B?eWZORE1IZkZNYS9pb3JjL2xoOGphMUt2T0JKcVdkNUJIY0JRTXlGMkRja296?=
 =?utf-8?B?amJUVGs5Q3pPUExMQW9pSTdNbkU3bmp4RFpZQjBxZ0V2aTFVUnB4RDk2STBI?=
 =?utf-8?B?SFQ3eW9VUUpLcjFQOW5xTFAyNXVXVjBtbGUvTFExRzk1K3h0aTZMdDJyUWV2?=
 =?utf-8?B?bE5BM2tyRFRNa0JOdUhsc2VCdkxGa0J2bHJYMVY3L2VKN3JESFhqZWdEamZ3?=
 =?utf-8?B?aEJJeFJ2SEhiT1NCWlFObHNFL2t0RXEzdFY5ZWU2ckgzR0xOeHk4cEdHUWZN?=
 =?utf-8?B?dy94NW5hbmhNSzE2T2dSM3NuWDZvU1lxNjd2YmI4VmExaVZEcG15QWF6Z1pF?=
 =?utf-8?B?Um5ZOEZQNnpqcGJwaGVtSFJDeGVBYnNiWU5tak1ud0tPTHNGWXNtYjZrVTRa?=
 =?utf-8?B?eEVQQ0pyWllTTmZ3MVhFYjBhbnlvY0drakJIdTNPajJKeHhKMDFZMlROT1Ba?=
 =?utf-8?B?cHpZdXhMOERHT3czS0ZqUWRkTjRibUFzdEFYOFNNM3RqK3hJOUJTTXdIWEVl?=
 =?utf-8?B?Y1ptSWZPUWloZ1dzUjVZM3lXVTI2RlZ4WHRrdW8rMytISmpvRVRTcFRXL0V2?=
 =?utf-8?B?Vm5oeU92dVBxcEhKRjQzNkRCOGpMNjlPaVdVWjJkeWNlSHBRdGJGSFd0KzNs?=
 =?utf-8?B?cFE3K0hJbEJFaEE1aHNUVDd5aG8rb0kzYVhxWmxtL0YrSlJhNEY1dXQ2MlRL?=
 =?utf-8?B?bkxvUmhzWGVaUnNYdjlxbUkwVnV6UURDODV0alA5amU3VGxaZzExRzNzd21k?=
 =?utf-8?B?eW1TdVYya0ZTMTg1cWRlbEZhZ0p2RUNmajZWZHNIWVBxZnBGbWF3eHAwRlRN?=
 =?utf-8?B?SHZ3SjJtSlp2YklPWkQrVTNNYzMvd2NQRHRjRGRHZTBFUzdkR1VwMkVLMm10?=
 =?utf-8?B?RzV1UmRXbWtLd3dGOXNKbEdvOUhXZzZleThTNFMycHNKWGNvRFR3Y2xUaTUy?=
 =?utf-8?B?a0J6UFp0NytNUGIyVUNLNFY1a3g0bzgvTGNpM2FBL2xtS1BucVFBZnRSK2tp?=
 =?utf-8?B?YmJsYzVZaDhFbHdsU3krU1hzUUVhcm04UUtIakdRR2NsVHo5dk1oaExzOVk3?=
 =?utf-8?B?eUhaK1ZNNmdrYUVDU25GRWorVHFsOCtaUVNVUGJScWVRRjIveUI3UGg2MUMv?=
 =?utf-8?B?QWxnejl6SUMxWVVwc09tZGs5MmhxOGJEejVRU0JzU3ZUU2FOMnpPTkFrcTYv?=
 =?utf-8?B?Szk4ZzFxOCtsNjBrckhYVFBVd2oxWm4vK3oyZ2Fwci83MEFReHdubUN6U1lz?=
 =?utf-8?B?UHVFZUx1NVYrdUNkMkRQcDRsaUYrVkU1ZmdONmxxekMyQ3BmNDBJaW85eDVM?=
 =?utf-8?B?aWliV0xLRy9HWEp0YTRPT1o2UlVFSjlLMDA1TFRDMWdCWTYrNnlCWHQxSkta?=
 =?utf-8?B?QU8yczlQYmlZK2ZnMENaUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F24877BD702DF7418B3BDE3B6E314E0C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d16066-2316-4019-a3dc-08d911aae7fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 22:53:18.2913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bIviLroPV1K/u1sADgprQXAgS+v9mXs4KBXyit696WOG2wLoX/vnkwCLaDWTZ3GWbBRHjCl6j5dUg1SlJ6fe9nDEhSEbF4sUHxpKVDrpKJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3470
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTA1LTA4IGF0IDAwOjExICswMjAwLCBNYWNpZWogRmlqYWxrb3dza2kgd3Jv
dGU6DQo+IE9uIE1vbiwgSmFuIDE4LCAyMDIxIGF0IDEwOjMyOjMzQU0gLTA4MDAsIEpha3ViIEtp
Y2luc2tpIHdyb3RlOg0KPiA+IE9uIE1vbiwgMTggSmFuIDIwMjEgMDg6MzE6MjMgKzAxMDAgTWFn
bnVzIEthcmxzc29uIHdyb3RlOg0KPiA+ID4gT24gVGh1LCBKYW4gMTQsIDIwMjEgYXQgMzozNCBQ
TSBDcmlzdGlhbiBEdW1pdHJlc2N1DQo+ID4gPiA8Y3Jpc3RpYW4uZHVtaXRyZXNjdUBpbnRlbC5j
b20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gVGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIHNv
bWUgc21hbGwgYW5kIHN0cmFpZ2h0Zm9yd2FyZA0KPiA+ID4gPiBpbXByb3ZlbWVudHMNCj4gPiA+
ID4gdG8gdGhlIEludGVsIGk0MGUgZHJpdmVyIFhEUCBwYXRoLiBFYWNoIGltcHJvdmVtZW50IGlz
IGZ1bGx5DQo+ID4gPiA+IGRlc2NyaWJlZA0KPiA+ID4gPiBpbiBpdHMgYXNzb2NpYXRlZCBwYXRj
aC4NCj4gPiA+IA0KPiA+ID4gVGhhbmsgeW91IGZvciB0aGVzZSBjbGVhbiB1cHMgQ3Jpc3RpYW4h
DQo+ID4gPiANCj4gPiA+IEZvciB0aGUgc2VyaWVzOg0KPiA+ID4gDQo+ID4gPiBBY2tlZC1ieTog
TWFnbnVzIEthcmxzc29uIDxtYWdudXMua2FybHNzb25AaW50ZWwuY29tPg0KPiA+IA0KPiA+IEZX
SVcgc2luY2UgdGhpcyBzZXJpZXMgaXMgMTAwJSBkcml2ZXIgY29kZSBJJ20gZXhwZWN0aW5nIGl0
IHdpbGwgDQo+ID4gY29tZSBkb3duc3RyZWFtIHZpYSBUb255J3MgdHJlZS4gUGxlYXNlIExNSyBp
ZiB0aGF0J3Mgbm90IHRoZSBjYXNlLg0KPiANCj4gSSBqdXN0IHJlYWxpemVkIHRoYXQgdGhpcyBz
ZXQgZ290IHNvbWV3aGF0IGFiYW5kb25kZWQuIFRvbnksIGNhbiB5b3UNCj4gcGljaw0KPiB0aGlz
PyBJIHdvdWxkbid0IGJlIHN1cnByaXNlZCBpZiBpdCB3b3VsZG4ndCBhcHBseSBjbGVhbmx5IGFu
eW1vcmUNCj4gc2luY2UNCj4gaXQgaGFzIGJlZW4gYWxtb3N0IDQgbW9udGhzIHNpbmNlIHRoZSBp
bml0aWFsIHN1Ym1pc3Npb24sIGJ1dCBsZXQncw0KPiBzZWUuLi4NCj4gT3RoZXJ3aXNlIHdlIHBy
b2JhYmx5IHdvdWxkIGhhdmUgdG8gYXNrIENyaXN0aWFuIHRvIHJlLXN1Ym1pdA0KPiBkaXJlY3Rs
eSB0bw0KPiBJV0wgSSBndWVzcy4NCg0KSWYgSSdtIG5vdCBtaXN0YWtlbiwgdGhlc2Ugd2VyZSBz
ZW50IGFuZCBhY2NlcHRlZCBpbiB0aGlzIHJlcXVlc3QuDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL25ldGRldi8yMDIxMDIwOTAyMjMyMy4yNDQwNzc1LTEtYW50aG9ueS5sLm5ndXllbkBpbnRl
bC5jb20vDQoNClRoYW5rcywNClRvbnkNCg==
