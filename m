Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787C83F08C0
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 18:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhHRQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 12:13:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:48924 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhHRQNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 12:13:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="203512181"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="203512181"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 09:12:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="531750831"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2021 09:12:39 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 18 Aug 2021 09:12:37 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 18 Aug 2021 09:12:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 18 Aug 2021 09:12:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 18 Aug 2021 09:12:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLvPlK5HOVL95O62wuz7ymUJpd6h/sAkVXZjwlSj4W2ZYrcVggOeIsl0+HPSdER4POlYY5Mo06Xdk2EpJwX2g/jjeEaM31GiuINFvrW6LM+xcTX4waOyiZKa81LpPco+lJ4qur/V6iHBERkkX/0lYYj6h8IsRkEx2J23Lq2U2sUMQZf+Pz27yb70ws02l8Ud2xMigRgtTu7OLhNb30toPDy+D9oCl6L0dkDjgwtfoIXtUezMwVQxvkYQlec+3JQE3IaN2pkxcvXEZODZGs6GQtv6tDIXL0FxJrf/5hVJUKKuOWlLkMM0mAJDIBdYN3N9QWPZkjwwzxAI8FvxldwMng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3Kcj379vArFrjATSzAqEttCLK2WKmh4xsWwJ/IkO8c=;
 b=DVmP3Rbd5F1Fl00SZK0lCs547d0ANoG+gWp/FFzAhmjTLsBjd4xc2/HmGwzFtuNyfnjynhmEJsvoT/gnrnywSvDpRinXuFxTLdzoQALBk6uIEmcM6zrrPZsi6Dy2Q5jqXfQVERsquW7xK4h/Ad0wsCwLs7FHPe6gJfGFgxkm1w6CADF8xFuT5ST/EmMRSLKDKCFTyABcDqMxY9rcmoLNTMXvtBoA0kPUXOaebUI4E5J0sVPGjrgsliYqfxVNqMmk4hCKaqzvNzOvu6w+Xr/KGl/jSJa4vaY5hYVbf9PgsODcJYX/KmkAos/EFfabEN5SmHX6wFufk9IisA0scRvVrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3Kcj379vArFrjATSzAqEttCLK2WKmh4xsWwJ/IkO8c=;
 b=IbRAsjRnjbj4IMaF9VMjB/X50Uqt+3tQDIl4mjP+SPHnDP+qOkAViFEJ04SN6RQ1e+8z79RdFo+DwIAqyWZnipCku98YqPW1kJ7BKRIcbU+Jigfn0t6yBMsHP5IQWiaxOnnrEE34cmxw/L0Zfsr8jIaEItLM62s8D9pVIcNlbD4=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB5196.namprd11.prod.outlook.com (2603:10b6:806:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 16:12:32 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 16:12:32 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "toke@redhat.com" <toke@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "joamaki@gmail.com" <joamaki@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v5 intel-next 0/9] XDP_TX improvements for ice
Thread-Topic: [PATCH v5 intel-next 0/9] XDP_TX improvements for ice
Thread-Index: AQHXkRfjDVbd1gn2WEuU98SZhzox96t4NDsAgAC1sQCAAGeJAIAAJRCA
Date:   Wed, 18 Aug 2021 16:12:32 +0000
Message-ID: <b5812918827b58dd353fd32b7042f1dfc2634e62.camel@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
         <86e7bcc04d8211fe5796bd7ecbea9458a725ad03.camel@intel.com>
         <20210818075256.GA16780@ranger.igk.intel.com>
         <20210818140330.GA25189@ranger.igk.intel.com>
In-Reply-To: <20210818140330.GA25189@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f9ca1cf-f566-4878-4162-08d96262fc0a
x-ms-traffictypediagnostic: SA2PR11MB5196:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5196214684A6EA311FDF5023C6FF9@SA2PR11MB5196.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2r83Ry1JcknZtfnTCf/KWkFrYl6sfI6mheyuYd3O0SLB1KqrLe0qErKSfV3zcdt+EF56zv3MlmXY01IHZx6vMAoBOdegaEkhf25Ocb7AkF8XoFGbSROF5rAApzzH4ETe+HkRtom4A0HOectFPS2LJPsRiJ6YX6i+Ma7izmSgGhH/7EeVQt/ak/S3QcfUHKfa4r7y8shneOOHci7AsmNJQp7Fw9G7aCM99e41Yy3gHb5osKBUnIt+CAzSciZKDabeQw3fa9n5D3/A+ldh3c7eI4Tb0GfAWJz8TleHXKO334pWwdLQjTxfkc32+82Pvzp6BOBvyVNNpda+CZCQXOclZ/JrND5IaOxrS8jJrioEsfDi/HN/GawJ5/pUQuqLQNefiLFwtF91U3Bgq4mqYLpuyde9tMZ8hAzJ9SFF3r5LHANdxWkvsEbCqll6kaV63sMY/eGTPtGTY1fnq2rjYsUsyUSBBOxKv5kXb0JOfeBjs1cyimtDvodnovXvQBUfLHEQL6HHOEAsX2nZaG3wzVrmE4yIHcLJR7x2pliaTrL3BB7Xgyu84OLKO+piCK2qLcX6eIqjCEtYMoPkKhrgmiSDW5iJ7dgZrQkkKLQqitB9GpRO56bkg5Iz0+60wX1F1dLqAef6YR2HRkMlXNhCZ399NjPgfGXsSxI0qAkZuXX2n/BZ04nZ/1sxvdEgtNIAYvOj0yXBcKLKeZeBkSl0SYpqw0Q3yBcyVwhnZU167VyCFnyNsug4+7UrWNx+VxZHcPoBLtW90Pcps8R7U/cOKZ7Dym0N5OMLzCk1EC2vAOC8/HVG7kxvIwKqz2g2EKT08ktjql1XP3Ipl9PIf4HvtjpF8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(316002)(86362001)(966005)(54906003)(6636002)(38070700005)(38100700002)(26005)(122000001)(6512007)(36756003)(508600001)(71200400001)(37006003)(6486002)(186003)(66946007)(66476007)(66556008)(66446008)(76116006)(6506007)(91956017)(6862004)(4326008)(5660300002)(2616005)(8936002)(2906002)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkRoSjg4cU83SFNwTTZFTmtUeldybE9Jem1BZ3NjSXlxL0Z2VHFPM2hOOHZw?=
 =?utf-8?B?RHFFem1reUhJcGwrcjNvSVdielhQQXBGK2ZKYXJ5ZlJaeW9NNnE3K0xnSzhL?=
 =?utf-8?B?VVpDd3N2aWRhc2FGMjNzNzZiSTUzMGJ1OGsvSzR0WnRCdWZ1azR6bDdvK3Zs?=
 =?utf-8?B?OGZGbjhNQjViZlJTMXljWFl0UzJtdzAxcnRqSy95dDAxbFl6ZXI4Yk0vMS82?=
 =?utf-8?B?RUZmMzdOWWhmeXVSM3Ryb3l1OGx2SEhyNDQ2QWFpUmJyd1VhS3FRVC9pb1Ex?=
 =?utf-8?B?aVRwQ2VpSFhjSXJYUnEwbmFzUnVEazVnVmtKZmxBZHdXM1AvenRlRVhUcjhJ?=
 =?utf-8?B?czgvN0FscnY3L25Cak5CdXZtc0J2UFJTNVVxaWI3TkNoN1hMZ0htSEVCc05Z?=
 =?utf-8?B?QlZwVS9hditqdHNmeFV6Y2JXalovTEJNbEpvZk5yYjVHOHEvaW9wem5YZUF2?=
 =?utf-8?B?UFdmY2dhT0FINTlMN0NBdlhvNXNlM0pKMDhxSm1WcXNiWDQzWU9pODhSMFUv?=
 =?utf-8?B?bldtREN6YjBGa2tncFVSZitGWWhtSG1lUzlKSllMSmRRRnJhTVlnUW04bW0w?=
 =?utf-8?B?YmxpMTF5RjJlcU5XVWdkYU5pQ0tCaEF4Ym9XdlpnbmdqQWpsS3FNTHRxNDJB?=
 =?utf-8?B?NnNnRG1rN0Y3YzB6bkpZYmcwMXNPQXdPNGpyM2h1Um9XR0loVTcyVlpMR1oy?=
 =?utf-8?B?dWxvVy9lN0lZN3R3UCtSYXRzYmkwb3VFbDhON0FpM2t6WnRRQkF1eUc0dVVk?=
 =?utf-8?B?aWVibldYaEVNNzVlK1ZiVUJPOVhGQjYxbHJSZDltMTczdmdJZ2szTGlyMzBK?=
 =?utf-8?B?eDBWN3pCQm96ci9sQVJLMlJkMWo5VVp3eUExeEVMY2hlbXlRaDlTTTJuS3Rr?=
 =?utf-8?B?K1hOdXNzeUoxTGEzS2JJWTc4K2F3YlhJMG52NnBlR3A1cmxwU1VKZjEzZnUw?=
 =?utf-8?B?VDJ2aUY3eDNvblp0cE13M1htQ3htcGxVMkRoVHcrYW9LTjEzQVEwaTJDa0gx?=
 =?utf-8?B?aXA2TlRkZWhPQ0FqSmdBYVVRREJadndjUWhwOXQydDRZM05NNnpPQmlCY3g3?=
 =?utf-8?B?aXVPSzkyT0svOWFNQ1hRSFkwYWNWMzV6aTlqM0NaaWtMTjcwSzNnZHlQQnNK?=
 =?utf-8?B?M3JEMCtUM2s5d05WcHhvUDBzMm9WcHpiV1ZFS1A1RzZXZmxjOXdVeGhXTEJr?=
 =?utf-8?B?N2Y0ZnhLaTlPam13cTNuK2xvVnlSM3YvMFN6Rmd4eWJuWFQ0VUU2REZ5dElR?=
 =?utf-8?B?WXdKSlRKVndNM3ZjNDZ4UUFsdGlwWFdWZlVwQWFNVTd5UHZBTmx2eXNkMHI3?=
 =?utf-8?B?dHh6Mm9XRTJ2eUh1Tml2MHN0TkpicmtZbC9naHBzQWFQVStXVFViZGxYZXlP?=
 =?utf-8?B?Z1ZFL3IxRHVPMmFvcTdQRU1PQ2k3LytCU1RJK1Bxc0NFVHhOeG93d1NjRkV2?=
 =?utf-8?B?RzVyZERXVVdFWEJOSFJCVUcwcmlhblB2S0d6cXh5WnZWanRScHJ4MXMrenVj?=
 =?utf-8?B?djJHS2xKL1dERlV1VlhTeGFsUzdvVEZjMlFUUnZuWlN6U25yek5zWDRLaUE0?=
 =?utf-8?B?c3VtWU9GelVZZGNnVmovLzRiZXdiT2NxR0FmczlVZ2RTdG5NLythQ3dpOXFL?=
 =?utf-8?B?Vk5yZkxsU0JiTjMrdm9lV2RaVUhmWHhBME1iKzlUL1B2SmFSK2srOEFMaTlt?=
 =?utf-8?B?ODFPdWFrdXFaK3o1UGppbzlpQzFJL1EwVTA3NDJmN253NE05bVR1bTMvRUYv?=
 =?utf-8?B?emM3aDMxa1JrMG0ySnQzQnBFVDErcjkzdGhudkdZSjdVTVhKVG14UmlqY0VI?=
 =?utf-8?B?aWRqcHJPeWVnbTk3aUhldz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7217C07B81031340A5A4BAE23F142A76@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9ca1cf-f566-4878-4162-08d96262fc0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 16:12:32.3224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6YQOx+QePxGfm7SPjS7WYkjGrvLjKNnGyCwfj5FSK4Pa07b+MTiuvgrUR1DYRlGg7jlcYSq7NxneGokfs8Cy653OZpeJfoeVwJajYaH1tbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA4LTE4IGF0IDE2OjAzICswMjAwLCBNYWNpZWogRmlqYWxrb3dza2kgd3Jv
dGU6DQo+IE9uIFdlZCwgQXVnIDE4LCAyMDIxIGF0IDA5OjUyOjU2QU0gKzAyMDAsIE1hY2llaiBG
aWphbGtvd3NraSB3cm90ZToNCj4gPiBPbiBUdWUsIEF1ZyAxNywgMjAyMSBhdCAwOTo1OTowMVBN
ICswMTAwLCBOZ3V5ZW4sIEFudGhvbnkgTCB3cm90ZToNCj4gPiA+IE9uIFNhdCwgMjAyMS0wOC0x
NCBhdCAxNjowOCArMDIwMCwgTWFjaWVqIEZpamFsa293c2tpIHdyb3RlOg0KPiA+ID4gPiBXaXRo
IHRoZSB2NSwgSSB0aGluayBpdCdzIHRpbWUgZm9yIGEgcHJvcGVyIGNoYW5nZSBsb2cuDQo+ID4g
PiANCj4gPiA+IFRoaXMgaXNuJ3QgYXBwbHlpbmcgdG8gdGhlIEludGVsLXdpcmVkLUxBTiB0cmVl
LiBJZiB5b3Ugd2FudCBpdA0KPiA+ID4gdG8gZ28NCj4gPiA+IHRocm91Z2ggdGhlcmUsIGNvdWxk
IHlvdSBiYXNlIHRoZSBwYXRjaGVzIG9uIHRoYXQgdHJlZT8NCj4gPiANCj4gPiBJbnRlcmVzdGlu
Z2x5IHRoaXMgaXMgdGhlIGZpcnN0IHRpbWUgdGhhdCBoYXBwZW5zIHRvIG1lIGFuZCBJDQo+ID4g
YWx3YXlzIGJhc2VkDQo+ID4gbXkgWERQIHJlbGF0ZWQgZHJpdmVyIHdvcmsgb24gYnBmLW5leHQu
DQo+ID4gDQo+ID4gaXdsIHRyZWUgaXMgc29tZSBzdGFuZGFsb25lIHRyZWUgb3IgaXMgaXQganVz
dCB0aGUgbmV0LW5leHQgPw0KPiANCj4gVHVybnMgb3V0IHRoYXQgeW91IGhhdmUgdGhlIHN3aXRj
aGRldiBzZXQgaW4geW91ciBicmFuY2ggYW5kIGl0J3Mgbm90DQo+IG9uDQo+IG5ldC1uZXh0IHll
dC4gSSBoYXZlIGFkanVzdGVkIG15IHNldCBvbiB0b3Agb2YgdGhhdCBjb2RlIGFuZCBzZW50IGEN
Cj4gdjYuDQoNCkl0J3MgbmV0LW5leHQgYnV0IGl0IGFsc28gY29udGFpbnMgdGhlIEludGVsIGRy
aXZlciBwYXRjaGVzIHRoYXQgYXJlDQptYWtpbmcgdGhlaXIgd2F5IHRvIG5ldC1uZXh0LiBNb3N0
IG9mIHRoZSB0aW1lIHRoZXknbGwgYXBwbHkgdG8gZWl0aGVyDQp3aXRob3V0IGlzc3VlLCBob3dl
dmVyLCBpdCBkZXBlbmRzIG9uIHRob3NlIGV4dHJhIHBhdGNoZXMuIEluIHRoaXMgY2FzZQ0Kc291
bmRzIGxpa2UgdGhlIHN3aXRjaGRldiBzZXQgZGlkbid0IGFsbG93IGZvciBhIGNsZWFuIGFwcGx5
LiBUaGFua3MNCmZvciB0aGUgdjYuDQoNCj4gPiA+IEFsc28sIGxvb2tpbmcgYXQgTklQQSwgaXQg
bG9va3MgbGlrZSBwYXRjaGVzIDIgYW5kIDMgaGF2ZSBrZG9jDQo+ID4gPiBpc3N1ZXMuDQo+ID4g
DQo+ID4gWWVhaCBJIHNhdyBrZG9jIGlzc3VlIG9uIHBhdGNoIDMgYW5kIHdhbnRlZCB0byBhc2sg
eW91IHRvIGZpeCB0aGlzDQo+ID4gaWYgeW91DQo+ID4gd291bGQgYmUgYXBwbHlpbmcgdGhhdCBz
ZXQgYnV0IGdpdmVuIHRoYXQgeW91J3JlIGFza2luZyBmb3IgYSByZS0NCj4gPiBzdWJtaXQNCj4g
PiBpJ2xsIGZpeCB0aG9zZSBieSBteXNlbGYuDQo+ID4gDQo+ID4gPiBUaGFua3MsDQo+ID4gPiBU
b255DQo+ID4gPiANCj4gPiA+ID4gdjQtPnY1Og0KPiA+ID4gPiAqIGZpeCBpc3N1ZXMgcG9pbnRl
ZCBieSBsa3A7IHZhcmlhYmxlcyB1c2VkIGZvciB1cGRhdGluZyByaW5nDQo+ID4gPiA+IHN0YXRz
DQo+ID4gPiA+ICAgY291bGQgYmUgdW4taW5pdGVkDQo+ID4gPiA+ICogcy9pY2VfcmluZy9pY2Vf
cnhfcmluZzsgaXQgbG9va3Mgbm93IHN5bW1ldHJpYyBnaXZlbiB0aGF0IHdlDQo+ID4gPiA+IGhh
dmUNCj4gPiA+ID4gICBpY2VfdHhfcmluZyBzdHJ1Y3QgZGVkaWNhdGVkIGZvciBUeCByaW5nDQo+
ID4gPiA+ICogZ28gdGhyb3VnaCB0aGUgY29kZSBhbmQgdXNlIGljZV9mb3JfZWFjaF8qIG1hY3Jv
czsgaXQgd2FzDQo+ID4gPiA+IHNwb3R0ZWQNCj4gPiA+ID4gYnkNCj4gPiA+ID4gICBCcmV0dCB0
aGF0IHRoZXJlIHdhcyBhIHBsYWNlIGFyb3VuZCB0aGF0IGNvZGUgdGhhdCB0aGlzIHNldA0KPiA+
ID4gPiBpcw0KPiA+ID4gPiAgIHRvdWNoaW5nIHRoYXQgd2FzIG5vdCB1c2luZyB0aGUgaWNlX2Zv
cl9lYWNoX3R4cS4gVHVybmVkIG91dA0KPiA+ID4gPiB0aGF0DQo+ID4gPiA+IHRoZXJlDQo+ID4g
PiA+ICAgd2VyZSBtb3JlIHN1Y2ggcGxhY2VzDQo+ID4gPiA+ICogdGFrZSBjYXJlIG9mIGNvYWxl
c2NlIHJlbGF0ZWQgY29kZTsgY2FycnkgdGhlIGluZm8gYWJvdXQgdHlwZQ0KPiA+ID4gPiBvZg0K
PiA+ID4gPiByaW5nDQo+ID4gPiA+ICAgY29udGFpbmVyIGluIGljZV9yaW5nX2NvbnRhaW5lcg0K
PiA+ID4gPiAqIHB1bGwgb3V0IGdldHRpbmcgcmlkIG9mIEByaW5nX2FjdGl2ZSBvbnRvIHNlcGFy
YXRlIHBhdGNoLCBhcw0KPiA+ID4gPiBzdWdnZXN0ZWQNCj4gPiA+ID4gICBieSBCcmV0dA0KPiA+
ID4gPiANCj4gPiA+ID4gdjMtPnY0Og0KPiA+ID4gPiAqIGZpeCBsa3AgaXNzdWVzOw0KPiA+ID4g
PiANCj4gPiA+ID4gdjItPnYzOg0KPiA+ID4gPiAqIGltcHJvdmUgWERQX1RYIGluIGEgcHJvcGVy
IHdheQ0KPiA+ID4gPiAqIHNwbGl0IGljZV9yaW5nDQo+ID4gPiA+ICogcHJvcGFnYXRlIFhEUCBy
aW5nIHBvaW50ZXIgdG8gUnggcmluZw0KPiA+ID4gPiANCj4gPiA+ID4gdjEtPnYyOg0KPiA+ID4g
PiAqIHRyeSB0byBpbXByb3ZlIFhEUF9UWCBwcm9jZXNzaW5nDQo+ID4gPiA+IA0KPiA+ID4gPiB2
NCA6DQo+ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2JwZi8yMDIxMDgwNjA5NTUzOS4z
NDQyMy0xLW1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20vDQo+ID4gPiA+IHYzIDoNCj4gPiA+
ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzIwMjEwODA1MjMwMDQ2LjI4NzE1LTEtbWFj
aWVqLmZpamFsa293c2tpQGludGVsLmNvbS8NCj4gPiA+ID4gdjIgOg0KPiA+ID4gPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9icGYvMjAyMTA3MDUxNjQzMzguNTgzMTMtMS1tYWNpZWouZmlqYWxr
b3dza2lAaW50ZWwuY29tLw0KPiA+ID4gPiB2MSA6DQo+ID4gPiA+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2JwZi8yMDIxMDYwMTExMzIzNi40MjY1MS0xLW1hY2llai5maWphbGtvd3NraUBpbnRl
bC5jb20vDQo+ID4gPiA+IA0KPiA+ID4gPiBUaGFua3MhDQo+ID4gPiA+IE1hY2llag0KPiA+ID4g
PiANCj4gPiA+ID4gTWFjaWVqIEZpamFsa293c2tpICg5KToNCj4gPiA+ID4gICBpY2U6IHJlbW92
ZSByaW5nX2FjdGl2ZSBmcm9tIGljZV9yaW5nDQo+ID4gPiA+ICAgaWNlOiBtb3ZlIGljZV9jb250
YWluZXJfdHlwZSBvbnRvIGljZV9yaW5nX2NvbnRhaW5lcg0KPiA+ID4gPiAgIGljZTogc3BsaXQg
aWNlX3Jpbmcgb250byBUeC9SeCBzZXBhcmF0ZSBzdHJ1Y3RzDQo+ID4gPiA+ICAgaWNlOiB1bmlm
eSB4ZHBfcmluZ3MgYWNjZXNzZXMNCj4gPiA+ID4gICBpY2U6IGRvIG5vdCBjcmVhdGUgeGRwX2Zy
YW1lIG9uIFhEUF9UWA0KPiA+ID4gPiAgIGljZTogcHJvcGFnYXRlIHhkcF9yaW5nIG9udG8gcnhf
cmluZw0KPiA+ID4gPiAgIGljZTogb3B0aW1pemUgWERQX1RYIHdvcmtsb2Fkcw0KPiA+ID4gPiAg
IGljZTogaW50cm9kdWNlIFhEUF9UWCBmYWxsYmFjayBwYXRoDQo+ID4gPiA+ICAgaWNlOiBtYWtl
IHVzZSBvZiBpY2VfZm9yX2VhY2hfKiBtYWNyb3MNCj4gPiA+ID4gDQo+ID4gPiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlLmggICAgICAgICAgfCAgNDEgKysrLQ0KPiA+ID4g
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9hcmZzLmMgICAgIHwgICAyICst
DQo+ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Jhc2UuYyAgICAg
fCAgNTEgKystLS0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
YmFzZS5oICAgICB8ICAgOCArLQ0KPiA+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9kY2JfbGliLmMgIHwgICA5ICstDQo+ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlX2RjYl9saWIuaCAgfCAgMTAgKy0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXRodG9vbC5jICB8ICA5MyArKysrKy0tLS0NCj4gPiA+
ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGliLmMgICAgICB8ICA4OCAr
KysrKy0tLS0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGli
LmggICAgICB8ICAgNiArLQ0KPiA+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNl
L2ljZV9tYWluLmMgICAgIHwgMTQyICsrKysrKysrKy0NCj4gPiA+ID4gLS0tLQ0KPiA+ID4gPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9wdHAuYyAgICAgIHwgICAyICstDQo+
ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3B0cC5oICAgICAgfCAg
IDQgKy0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHJhY2Uu
aCAgICB8ICAyOCArLS0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfdHhyeC5jICAgICB8IDE4Mw0KPiA+ID4gPiArKysrKysrKysrKy0tLS0tDQo+ID4gPiA+IC0t
DQo+ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguaCAgICAg
fCAxMjYgKysrKysrKy0tLQ0KPiA+ID4gPiAtLQ0KPiA+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaWNlL2ljZV90eHJ4X2xpYi5jIHwgIDk4ICsrKysrKysrLS0NCj4gPiA+ID4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHhyeF9saWIuaCB8ICAxNCArLQ0KPiA+
ID4gPiAgLi4uL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3ZpcnRjaG5sX3BmLmMgIHwgICAy
ICstDQo+ID4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5jICAg
ICAgfCAgNzAgKysrKy0tLQ0KPiA+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNl
L2ljZV94c2suaCAgICAgIHwgIDIwICstDQo+ID4gPiA+ICAyMCBmaWxlcyBjaGFuZ2VkLCA2MDcg
aW5zZXJ0aW9ucygrKSwgMzkwIGRlbGV0aW9ucygtKQ0KPiA+ID4gPiANCg==
