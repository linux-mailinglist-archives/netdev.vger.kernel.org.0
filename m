Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F538F730
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 02:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbhEYA7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 20:59:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:27438 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhEYA7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 20:59:19 -0400
IronPort-SDR: EKRNEf47+99smr5Y9LF0HC2IypZH6qJ/2cQXBAYNPlB792vmH5mFR9lwUDUppKwwboY5AhkGet
 2pMdH4XpaU0g==
X-IronPort-AV: E=McAfee;i="6200,9189,9994"; a="189446018"
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="189446018"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 17:57:49 -0700
IronPort-SDR: 67wpAvWUEOOLtWcqLr4k7TZ+qmsK/s6wii+HbhUwo16Ldmt8oWH7zGFIofElzYTYASpt+VbmZN
 lcgL+iyItkjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,327,1613462400"; 
   d="scan'208";a="442296516"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2021 17:57:48 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 24 May 2021 17:57:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 24 May 2021 17:57:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Mon, 24 May 2021 17:57:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drnZ/ekd9FvVAezquyPPxq/uirRHihuRsEGJS7j7sn5SdcqbyYoNS1MV4zXO5l+tAmnoBwB4glheHIhFV9nDZRSfzUJzJYFHLDqbcGJrYGdgsZyOOgaIS6hXRrZSWqq45litZZ4HhDvTpIy+9raHAfiouOsFjpB/A9nmavqqZhGIse/Xg4+WGEakWtXMmEgxp28lDu+I5ZKtv56fK3kNxWcy+S/6yma0PyYOWUkr+SokmnpuhXUhxuP3gfW/kQMgwPmi/a6ZEtaTh4YxA21ySm1c3o4MAYblGtvuh+XvodeuDLQvH35TU1Nh8d8uw1+cGtm8edgfrUQFTGj4nWtKqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TVh5tymj1+bWPOGBKtoYz1HMk/m8hYiUMXa0XYkoB0=;
 b=lVLFfuUWrqltnduO2Y60vsw25HFwoT8xH9vX+lhNOaosE8dCZb5IlIjlq0sOxD10ET79o3hgmVCky43/UIpJn6ofoSVZjgy+EmaScpXXkkSg2+za7yf1DV3W/AiZz0JxbnbRhW/Nm3zCWoWebansKvvChVt2/5pNHbba10/YdO6Z8uol5AvqElfYkr0s3tA+NdWIJekOLMSHzESJgc5CvMCGS/b1zyIUOB79zRbzPkZnNlBDuqUR+iiB1ZyrVjnvyYkewLZW73PYcif7VLK0JQiTDWWP8EDWDXodP15+8z74k+iNCp9BKpUZjEuiXvRWWAYrQ67PBIAat0wOcefQfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TVh5tymj1+bWPOGBKtoYz1HMk/m8hYiUMXa0XYkoB0=;
 b=mHsYGEW2ao1qitgCYb773ozc1JvDsR987ifLvnkDRBRY+Ww3lpjWotLY+kHQ4bx/uI4bt493IipSrYBjIBnxQXzY4KO4iEswicoGTiUHoUI0G+n20q/lt10WPYUb0QbG+U3XiBNAKgsTztyIjOQZtk+Ck2TLCW+nifvL8c5IZEE=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2670.namprd11.prod.outlook.com (2603:10b6:805:61::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 00:57:45 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 00:57:45 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: Re: [PATCH net-next v1 0/6][pull request] iwl-next Intel Wired LAN
 Driver Updates 2021-05-21
Thread-Topic: [PATCH net-next v1 0/6][pull request] iwl-next Intel Wired LAN
 Driver Updates 2021-05-21
Thread-Index: AQHXTm3sM7KNHiqzfUCXhpP67hm89KrudGQAgAAU0QCABNyPgA==
Date:   Tue, 25 May 2021 00:57:45 +0000
Message-ID: <62555c6de641e10cb4169653731389a51d086345.camel@intel.com>
References: <20210521182205.3823642-1-anthony.l.nguyen@intel.com>
         <20210521.143114.1063478082804784831.davem@davemloft.net>
         <20210521224544.GD1002214@nvidia.com>
In-Reply-To: <20210521224544.GD1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8488246-8ac0-4cc8-769f-08d91f181bb1
x-ms-traffictypediagnostic: SN6PR11MB2670:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2670C1AC6B616B5BC98BAA2AC6259@SN6PR11MB2670.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cNxTRw/RY/bB2ZTsvehNOmBKNPvIX75nQlD8i9vkK8iQYjHAUMPanW6b30L3RTXX//ZqzW0uMM2Y8+PmJOppsmK+Ud6YRepd6fOwVqBiLZl6sbPg0pX8iKid3SeBygyqNtRKsySdpULUnFxSJu8jlsEW31M+j3q5/IkEv3Obw1Prgm5l7CbVm7zFA5NdOHjMqTc9Pfa9/JteChWrQlgkiq2spuxuzkJa5ZxvOZZ70oFJkPprT9XZbcdblqhE2HL79YjnuqRM54Qxl4A+RUmLTHibQ2EgEa+xoJYS4i+oscqJGHeeES280INRD7Pyfxl1YY8fz2N6xL4uzW2u9+Zi/g8bXDC2wolfwsMs4FQOJuA5qZVYex848wy2kz3s3SJ7HDnDDuTkfzp+L50BOKpk2OWn+4yUejf2H/6yEHldbcuhP6WRQ2OEAIuRybFy6r7g/EfwJ14BFm5ET5Ij1xobZOQWPOa1zqJ1ZIpuEwG1daKQ1eCepxm0UtmocnuLxzZtOpSWg+u8JWne0T3HTypApoHSjrQrdKaNWjXvZ119/ZYuM0sqr4XdX/huWtgDo1NibqfMIZGb6AAnHDAZz1bwaNomG/BYS6Vm+L8TOtCUxVeLsNzw0VHDOFLbKt0tVr8q/5GSLQeLozCCYEe/7ke2yy7TXnKCkX7Gxs1o6Vzh9gFen/CyfF7SiyEYVRVfxiFOb+1P/fXigxuU+W5bPiPrRb5TvDT7EoiW+QdFeFU0k1w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(8936002)(83380400001)(36756003)(478600001)(15650500001)(71200400001)(966005)(8676002)(38100700002)(2906002)(4326008)(66556008)(5660300002)(110136005)(66946007)(54906003)(66446008)(64756008)(6512007)(6486002)(2616005)(76116006)(107886003)(26005)(86362001)(6506007)(91956017)(316002)(186003)(122000001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NXNudWQ3VGs1cWtGZEp4Rk5XTEFqWU1SZFJIQzJDTGdIUytSY2FiTkNkY2xy?=
 =?utf-8?B?L0FHSXJvRE1hTVU0S29OZzFYZDA2Y0FQUVVUMlQxUU5zSkN0VnpweEFLcS9m?=
 =?utf-8?B?RkdPMkM0Q1pselpFZ0pRdHh2TWxiZ0kzNzNSOHQ5eVpGbDhsRkRaaktGZk1J?=
 =?utf-8?B?NGpqcUE1Z1NRc3c5cmRMbk44ckpyKzNHT0RTUld3czdUU24zUUVaVmQzT0V0?=
 =?utf-8?B?YkNqOUlyTnNHci9MREZOWGtMWnVqTlRFMHNacUpReEQ5SElRMDFCSXFBNjdw?=
 =?utf-8?B?cnhsa0hjcy9wTDdpM095U1RYSTJzb0ZJR2VQRGxIZkp5Z20yYXVnUCtFUUpk?=
 =?utf-8?B?Q1VQeE5DbEpCd2J0UzB6bUdxNXQyMHcranFyM0N1YUdzcTA1SmhFRHRoN0hF?=
 =?utf-8?B?TVdhdkxpa3BxRVgrclRVWUZUNUlCMFdsUFNxRkVsdXJOVHdscnEwemQ0a243?=
 =?utf-8?B?aHRjd0VaYW5mVUhacjk2clVjdG4xMU94eHN3MWpuUnlsYXBZY0xFSm1laXgw?=
 =?utf-8?B?UDhxMzBhSE9UMVFFQzVhNkRzWmZaM2Z5TG5uc3hrTjREVVRBY0ZQaDdPVTlv?=
 =?utf-8?B?TTM4cFJBNFBnYW12UVREYytLK3dEdEpCRmFBOXBhTU1LakdzK3pZc01ReXc0?=
 =?utf-8?B?NVVqWDdPUHYzcnUwdmJ2UjM2ZTFJQWNMVUVSU3ZXc0VEZVlPaUpJL1NTaisy?=
 =?utf-8?B?enBaaWFvcUNtZmwrL1VsTkxZOWRYbk1oUXE4RTF6Z3ZWSm0rSGo0M2kyTXFi?=
 =?utf-8?B?Sjl2bHVUWXpzaFB0ZENHV1N0Q2dLM2R3dDFacFFHY2NmaEowOWV3U1NreDc5?=
 =?utf-8?B?cGd3anVTdk9ZOHBVOThtNWNoSnBoZ1NnL2xxQjRoczZWVWZjdDZFT1VSM05B?=
 =?utf-8?B?SWhrTnQ5YU9nT05oRDlKRjhzNm5RNXNaMnJTbjg2T0dmTGd2VDY4RWV6OGcx?=
 =?utf-8?B?WkJjVXBKU0l2dnduL21OL044R0RBZDljQlprcnJoTTdqblBuUUNCUmNOL2Jk?=
 =?utf-8?B?R3FVQUo5OWFCbXBHNmFmanZ3VDhhcWdXeHJyT2JMcUF4b2lFUlFhd2E1eHY3?=
 =?utf-8?B?a3dQZFV2Y3FhKzViTnpCWEhGWGx1cUwyaFhmTVVaL28ydzFteFlJRlUzS28w?=
 =?utf-8?B?ejBzNk1EUlI3S2NvMUpmRGQxKy9rb2pVWng1MEg0YnZQNU9wM3VnNWFxR3Ft?=
 =?utf-8?B?Qk1IVCtNRVh3YjJ1RDVOYkx4ZzhKT3dqT2RqU29YeU9aa1JSMjRzM0hJaWJt?=
 =?utf-8?B?SFpxcGpidmdycjBzN1IyZTY5eGM2K1l3SEVjNTVRZkVHZG81S2VPOTd3clIr?=
 =?utf-8?B?U2p4ZlBGdkZkZlBZNEgyTVBZd0prZms1UFI2R3hCR2dJQWRMS3p4NTRwblFT?=
 =?utf-8?B?Szc0TWYreURKZjFlckVzVDFkc1IyOFc4RmlsV0phWjZ3SXJHWWpaQkdaakxW?=
 =?utf-8?B?UTBRS1Roc0ZZOGtFeEJvM1R4SnQxUHkvMUJJUWEvZVJQSnV1Y25ybUI5dDAx?=
 =?utf-8?B?TG41eGFUNVhHQ204UUdMRHo2SFVnWThpSVJNYjdYTjl2WVhRS0Y5N3FMZ2pj?=
 =?utf-8?B?bk5IWWtsVGdTa3JCdFJLbTIxYTZCY3gwVVZpNGs1aXhMZDhpT3Vqa01NZDVX?=
 =?utf-8?B?Z1ZsVEsrZUZFTTBWM3lkeEVrZ21tNmE1d3dLOVd6cHgwOGRMWk53Rjg0eXhk?=
 =?utf-8?B?SncxWVJ0Q0ZxRE9pZDhEMnJ2VlVDNEd2ODN3SHdZYnFmV0xrK3JHQmtvNUFM?=
 =?utf-8?B?MFVTT0V5RzJVV3pNNTNpR2tPM3ZYcWlXWE5KTVRRamFGa2RDSytRcHFDbXMr?=
 =?utf-8?B?cTJLMnRlSU43NExNeG0wUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <107C44C8ACB1E149988FDE0EF0CD3223@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8488246-8ac0-4cc8-769f-08d91f181bb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 00:57:45.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jfx/Puij3jo+T5QxVEDxLcZSvcyNTzsOQUfURnwZp2Q33qTbDVd8FDhkjqbFiYfddQMzwnEBZZXZdXtXg4ssQCnW7WFcVy14spkN+YvdNqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2670
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA1LTIxIGF0IDE5OjQ1IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIEZyaSwgTWF5IDIxLCAyMDIxIGF0IDAyOjMxOjE0UE0gLTA3MDAsIERhdmlkIE1pbGxl
ciB3cm90ZToNCj4gPiBGcm9tOiBUb255IE5ndXllbiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5j
b20+DQo+ID4gRGF0ZTogRnJpLCAyMSBNYXkgMjAyMSAxMToyMTo1OSAtMDcwMA0KPiA+IA0KPiA+
ID4gVGhpcyBwdWxsIHJlcXVlc3QgaXMgdGFyZ2V0aW5nIG5ldC1uZXh0IGFuZCByZG1hLW5leHQg
YnJhbmNoZXMuDQo+ID4gPiBUaGVzZSBwYXRjaGVzIGhhdmUgYmVlbiByZXZpZXdlZCBieSBuZXRk
ZXYgYW5kIHJkbWEgbWFpbGluZw0KPiA+ID4gbGlzdHNbMV0uDQo+ID4gPiANCj4gPiA+IFRoaXMg
c2VyaWVzIGFkZHMgUkRNQSBzdXBwb3J0IHRvIHRoZSBpY2UgZHJpdmVyIGZvciBFODEwIGRldmlj
ZXMNCj4gPiA+IGFuZA0KPiA+ID4gY29udmVydHMgdGhlIGk0MGUgZHJpdmVyIHRvIHVzZSB0aGUg
YXV4aWxpYXJ5IGJ1cyBpbmZyYXN0cnVjdHVyZQ0KPiA+ID4gZm9yIFg3MjIgZGV2aWNlcy4gVGhl
IFBDSSBuZXRkZXYgZHJpdmVycyByZWdpc3RlciBhdXhpbGlhcnkgUkRNQQ0KPiA+ID4gZGV2aWNl
cw0KPiA+ID4gdGhhdCB3aWxsIGJpbmQgdG8gYXV4aWxpYXJ5IGRyaXZlcnMgcmVnaXN0ZXJlZCBi
eSB0aGUgbmV3IGlyZG1hDQo+ID4gPiBtb2R1bGUuDQo+ID4gPiANCj4gPiA+IFsxXSANCj4gPiA+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIxMDUyMDE0MzgwOS44MTktMS1zaGly
YXouc2FsZWVtQGludGVsLmNvbS8NCj4gPiA+IENoYW5nZXMgZnJvbSBsYXN0IHJldmlldyAodjYp
Og0KPiA+ID4gLSBSZW1vdmVkIHVubmVjZXNzYXJ5IGNoZWNrcyBpbiBpNDBlX2NsaWVudF9kZXZp
Y2VfcmVnaXN0ZXIoKSBhbmQNCj4gPiA+IGk0MGVfY2xpZW50X2RldmljZV91bnJlZ2lzdGVyKCkN
Cj4gPiA+IC0gU2ltcGxpZmllZCB0aGUgaTQwZV9jbGllbnRfZGV2aWNlX3JlZ2lzdGVyKCkgQVBJ
DQo+ID4gPiANCj4gPiA+IFRoZSBmb2xsb3dpbmcgYXJlIGNoYW5nZXMgc2luY2UgY29tbWl0DQo+
ID4gPiA2ZWZiOTQzYjg2MTZlYzUzYTVlNDQ0MTkzZGNjZjFhZjlhZDYyN2I1Og0KPiA+ID4gICBM
aW51eCA1LjEzLXJjMQ0KPiA+ID4gYW5kIGFyZSBhdmFpbGFibGUgaW4gdGhlIGdpdCByZXBvc2l0
b3J5IGF0Og0KPiA+ID4gICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdG5ndXkvbGludXggaXdsLQ0KPiA+ID4gbmV4dA0KPiA+IA0KPiA+IFRoZXJlIGlzIGEg
bG90IG9mIGV4dHJhIHN0dWZmIGluIHRoaXMgcHVsbCwgcGxlYXNlIGNsZWFuIHRoYXQgdXAuDQo+
IA0KPiBJdCB3aWxsIGhhdmUgdG8gd2FpdCB1bnRpbCB5b3UgbWVyZ2UgYSA1LjEzIHJjIGludG8g
bmV0LW5leHQsIEkgY2FuJ3QNCj4gdGFrZSBhIGJyYW5jaCBpbnRvIHRoZSByZG1hIHRyZWUgdGhh
dCBpc24ndCBiYXNlZCBvbiBhIHJjLg0KPiANCg0KSSdsbCByZXNlbmQgdGhpcyByZXF1ZXN0IGFm
dGVyIG5ldC1uZXh0IGlzIHVwZGF0ZWQgdG8gYSA1LjEzIHJjLg0KDQpUaGFua3MsDQpUb255DQo=
