Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEEF3E808A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbhHJRuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:50:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:20914 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236154AbhHJRsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 13:48:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="300544015"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="300544015"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 10:42:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="506219840"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 10 Aug 2021 10:42:06 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 10 Aug 2021 10:42:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 10:42:05 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 10:42:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 10:42:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DY3XESiGQKl6+SV8JZK91gpPwIITwTeywd2dVPn/LNrIK1ZEburYWBK/bJBTntute6CZwdAYLssSVvqzZbP/GSiQVsB4nfBMDmp27ENq3xpTDs5xPjwMc82aVyvYcYMKEmi0A1qG7/AxT6p3n5XtGaqjOlJVOI4kn5jiNT+U2kwZp4qH1/VWTFceWEo9Oqf6XsIZayi76w4g1Zq3hzVnRixJ7OnIWs209TbPSG5u314DZg1lFb8VOfphcWpod3k0ScZ8Xhgdjv/yZJlsb5A7d+gRu2Js70AeI/bX5kgS9NFWcoHCny+u7DO8NJceF/Nq071v/wx2oq0VNhXL2R686A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNIqzxHHqNYNs9Qv1bg/3yCh+o6rLReqsWUWhmmwnDU=;
 b=kkKi4WPtd9PN4JZil6OKUMb1eDKRfCpKT8PrDyIl2BtV4l0HaF1df4EC20VNtfYo/t9t5zokEX9ofOQuIahQWkEZ5+7HwWRymarJyoiPfSnStoiYA3IMVgpYZ+V2MfH0y3LgcpIdCCImiAPhFPP7TMfw7zeDvdfk3lQXbWmA53dGkV0g0FI+qUTzAEymESfHOdPW1Df3XqbdQQY3G38Cc1xZg545kkzA4Ma82QBrW5ObTUFc/QKeaYI/1g5OfKLOmN7/eEWRDW+oa1U9IhtKHrvoc/HMABbaQrwIERkB3xmr+RRd1n1LyUz5LqMpgHAMYGm5xlA6j5Ug+4G9Pr66Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNIqzxHHqNYNs9Qv1bg/3yCh+o6rLReqsWUWhmmwnDU=;
 b=UPktiNXKjNNXc8y78DZ7FOSTgjuvvhwT7Dr1HrdPEBxDLX1weKo3Jf87C10FiqTpT18y8GgyKaM2fNcCUwK7dgK/i9VogxQZELAUg2M8+UCaPDl5gh2D6K+/2UPKtGslae4yExcB6yDPYisVRA+xRS+BJUINEhyfrlZTkAe5iGk=
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by CO1PR11MB5122.namprd11.prod.outlook.com (2603:10b6:303:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Tue, 10 Aug
 2021 17:42:04 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::4ce1:c56f:55f:c991]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::4ce1:c56f:55f:c991%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 17:42:04 +0000
From:   "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 2/4] ice: Stop processing VF messages during teardown
Thread-Topic: [PATCH net 2/4] ice: Stop processing VF messages during teardown
Thread-Index: AQHXjUF/+Q++SpcJzEqUKAqpkA/5QKtryaoAgAE2P4A=
Date:   Tue, 10 Aug 2021 17:42:03 +0000
Message-ID: <8568eb9755224d5062337ab67f8a7a709ac2f2d8.camel@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
         <20210809171402.17838-3-anthony.l.nguyen@intel.com>
         <20210809155838.208796aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809155838.208796aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 (3.38.4-1.fc33) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f820bc0f-d3b1-44ea-d557-08d95c262a7c
x-ms-traffictypediagnostic: CO1PR11MB5122:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5122CAEF3FC5DC5DC9C39B5890F79@CO1PR11MB5122.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MiHNSonT1Y+7zrmlVH42uN2K0wUcDCwpObPv7EvwhbeI43T11rXt+6JVO0dIqLA/7ZQxoTFRi1W2cKUZx22oE8KOyntnyGwZJwDfbzeMQVPMdmQ0nKFntG9EH4G21SuSKic5hSEWF/auVLw8+0qmqE3x5xayDw9BRYwLY5CGxzqQh1sefHOqyLU8bcoyT1DjdfIdQDoPaVPoJw2AK6d3HKgD3p8wrZxLCmzDmlA72+naJ8PaFCYyFEMB2uStZ6a/v/6CvybqELMzt8QAZKph0V4qP9bT9EJLIj3dCdm4CjQitjtl20YWDu0AjeGVTqX5q6yljdmOxaqDD4Mz7ls5fYZ5A0VPLy0ZGlSKPrwa+sz8sxZgqeU8ttZQeiBtzwq9htqIbqhQyqPI1uA44JZ/zOuFbXFO9KdSjvtnM3Oe6orHiVFa9wxKsx/K3vLMzAabKRycMf/aGmz2R2rafmt+/78lsKzqVCSDe0m53zGQUF2tXFgrv+T2+ogHF9Kewir9dv24l7oRDnx/3NNHjqt/I2sImgNf2p8skTBzl3K140AIhXu0SCBdaFJcriTg7Z20TW+6BEegQBh7E23quh+c6ZaoE/22xYUy8JEa8+LJwSfNJrWAUHLTYXVCVAvdEPV8SIrg0bfbqmuWBFpsagT7E40hqG7ceJqGsFEMnOam3pmLT92tLfRUrh07jYEvOHLQF6szut2oLkHKYRWi8x5BZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(83380400001)(76116006)(15650500001)(64756008)(66446008)(107886003)(66946007)(5660300002)(66556008)(66476007)(478600001)(8676002)(6512007)(71200400001)(6486002)(8936002)(86362001)(186003)(4326008)(36756003)(6506007)(26005)(6636002)(38100700002)(2616005)(2906002)(122000001)(110136005)(38070700005)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2xJVjB6R1N1K2xpOHdoSXlERFNqWGJsWncrSEc1ZHVRVHhhTzdQejd1T1Y4?=
 =?utf-8?B?cWZPSWJSbTl6MFdxa0xwanFLSktocDFZU0VGZGpUdHVMeXdDNVNvNXA2YWNZ?=
 =?utf-8?B?NXVLVXVqWXU0UGlLczBFSGpkNDR2VDV1K0cxaXJHYTY4Mm55Nk5kcXY1aDdx?=
 =?utf-8?B?WE52bU5lQ1lSa0w4YUFKbnhlNUExV1lWUWZuZGtvMmdOVHZDMGdzMXlUWjls?=
 =?utf-8?B?RDlQMW1hOUJPSG9PTVRzTlpJNFZhYWlkL2hjQnFsRUJQbVpGWnNUU3lDYjRu?=
 =?utf-8?B?b0JDTVBzOXlQT0k3N3hnaDNYQklwM3lnZUl3Rks2TzJuSHBpRmdYVkVZTTFP?=
 =?utf-8?B?Mjc0d1FIRG1rVjR3cTRncFp5c2V5bDVFSUhZdWt4d0c5SUM5Vkk3Y2VMaWd0?=
 =?utf-8?B?aGo1SjJGcE02L0pnS09BTEpLeUNmVUk2U0ZpZHNQbW1KNlh2MlAxT1FLUStE?=
 =?utf-8?B?SFI4bzJFbGVOcys5dFhjYWQ1SjEwYlI3MXJBYUJkVFcybk5VRzdGdDJYVjlM?=
 =?utf-8?B?SDgxVDhMakJWNCtxZFIvcFJWTitBRHhIUjY4NHBFU0FQSmVTZzU3MXYyS0VW?=
 =?utf-8?B?TjlqR0k2OWlTWTM1NXZNQk5CRnUzcFJpWHVSUi9lWnUzZHo2em8wbEg1bExa?=
 =?utf-8?B?czdiaWJ0ZEhnK2NESnFPTGNJYnpxdzZZQ3VhR1JjTVZ6dks0WGYxR1kvUEpX?=
 =?utf-8?B?UFJIekx2eFIvU2pkdlpLRVBZS1I3MjgzL1preG8xVVVzWEh0UEJsZWZOVWI3?=
 =?utf-8?B?aElWaEhTT09BNXlxUnBFdHNTckw0YXZPR2VNUG1SQU5uODhCVGljSk1MV2NS?=
 =?utf-8?B?VUZ5bWpnZ1dORHJ0L0JDS24vNGJ4bFI2OWhEcTFmK212UVlKSFNUNTdjL3Bn?=
 =?utf-8?B?WElqZEdjRDlWbGdVd2hhZWYxK3VLTGxWRjRqYkxJTWxRanQ0LzFNUXc1ZDlT?=
 =?utf-8?B?VHNheUVocUlIdGpUSGkzMVBud2ZKVWgrZDdzVGYzUmRKNW51T2U2OTB2ZFAz?=
 =?utf-8?B?dnRXeXdyMU95elUzUjNuWFJRbWFCaHIwZ1QzbXpoNXhNVEUyWWJvZFlzU01v?=
 =?utf-8?B?VmZINGFWSlo1WE1mN0VvSUcwSDRpMzZkYWJQYy9kRENYak5NanNjN0lOUkFk?=
 =?utf-8?B?MzFyWnFPemRIYWgwcXBwZ3U2aXZRbzZtdENlTW9jdmdtdWk0aTRaZndSRnV2?=
 =?utf-8?B?Q0M4RGNhYkcyWTRmZ2FNRnplZzZkdllZM2pNTnN4VGh3M05pRmR0b2pqRVdE?=
 =?utf-8?B?aDR1blg2Y0c5dW13ZDBaMnhGSG5TdUVvNnJtemtGOHJwekNMbWxjejJmbG1Q?=
 =?utf-8?B?QzZ6Vkp3WURIaHp1WXpiM2Y2WnZDekxpL3pBRnR4V0VBUXNmQTBjUnBoR1Q5?=
 =?utf-8?B?aVhMdm9VSnh0NW1TcFp5R3M0bWxuVDVwR09rSXMwbFAzTzlVWFYra1Bpd2VS?=
 =?utf-8?B?d3BEOVNnRERzcFNpUkxtd1BSckNsWHBSTkY2UDBONEh6bkhCQjBjUGVEM3FY?=
 =?utf-8?B?ZmEvWVljMWtoay92Y0x0M3NyZTB3RGJudHRGMFFoc3JsTmUxUEVrV2dIckxB?=
 =?utf-8?B?b2EzdE9tRjVFTDFScEIrL04vTG9BMGVYbTdCUzdkdXhNZ01oTWVEcHgyVEVz?=
 =?utf-8?B?aTNwcm9MNjBEdVYzRTAzK1JhV091UDh5YUwwMjhHZ3p0cUFSVTJRUXNtbjd6?=
 =?utf-8?B?dm0wQlViQjRhM2hYdzU4S0dza1VrRGlGQ2cwWXFpSGlxVGlyc3k0T3l3U2hq?=
 =?utf-8?Q?PERaUVacPrXn7e8xxDm79tOIcyNru9a41Ls+3EI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4D95FEAEA4E7945883111DFAE72707B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f820bc0f-d3b1-44ea-d557-08d95c262a7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 17:42:03.9170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1FSY7KqR5z3BT/LYbZ2oP88XULUTMD4zojZSVwvHXHWKYA3sJM7SLJtB38x7/fqTKxxZpbBJh0u/x2G+mu9l3FCNy/u0MSYRkbm3FRB6aisufpMjdsJmv9yaOWsGFZdv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5122
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA4LTA5IGF0IDE1OjU4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLMKgIDkgQXVnIDIwMjEgMTA6MTQ6MDAgLTA3MDAgVG9ueSBOZ3V5ZW4gd3JvdGU6
DQo+ID4gV2hlbiBWRnMgYXJlIHNldHVwIGFuZCB0b3JuIGRvd24gaW4gcXVpY2sgc3VjY2Vzc2lv
biwgaXQgaXMNCj4gPiBwb3NzaWJsZQ0KPiA+IHRoYXQgYSBWRiBpcyB0b3JuIGRvd24gYnkgdGhl
IFBGIHdoaWxlIHRoZSBWRidzIHZpcnRjaG5sIHJlcXVlc3RzDQo+ID4gYXJlDQo+ID4gc3RpbGwg
aW4gdGhlIFBGJ3MgbWFpbGJveCByaW5nLiBQcm9jZXNzaW5nIHRoZSBWRidzIHZpcnRjaG5sDQo+
ID4gcmVxdWVzdA0KPiA+IHdoZW4gdGhlIFZGIGl0c2VsZiBkb2Vzbid0IGV4aXN0IHJlc3VsdHMg
aW4gdW5kZWZpbmVkIGJlaGF2aW9yLiBGaXgNCj4gPiB0aGlzIGJ5IGFkZGluZyBhIGNoZWNrIHRv
IHN0b3AgcHJvY2Vzc2luZyB2aXJ0Y2hubCByZXF1ZXN0cyB3aGVuIFZGDQo+ID4gdGVhcmRvd24g
aXMgaW4gcHJvZ3Jlc3MuDQo+IA0KPiBXaGF0IGlzICJ1bmRlZmluZWQgYmVoYXZpb3IiIGluIHRo
aXMgY29udGV4dD8gUGxlYXNlIGltcHJvdmUgdGhlDQo+IGNvbW1pdA0KPiBtZXNzYWdlLiBJdCBz
aG91bGQgZGVzY3JpYmUgbWlzYmVoYXZpb3IgdmlzaWJsZSB0byB0aGUgdXNlciwgZmFpbGluZw0K
PiB0aGF0IHdoYXQgd2lsbCBoYXBwZW4gZnJvbSBrZXJuZWwvZGV2aWNlIHBlcnNwZWN0aXZlLiBP
ciBzdGF0ZSB0aGF0DQo+IGl0J3MNCj4ganVzdCBhICJmaXgiIHRvIGFsaWduIHdpdGggc29tZSBp
bnRlcm5hbCBkcml2ZXIgPD4gZmlybXdhcmUgc3BlYy4uLg0KDQpUaHJlZSBkaWZmZXJlbnQgY2Fs
bCB0cmFjZXMgd2VyZSByZXBvcnRlZCwgYW5kIHRoYXQncyB0aGUgcmVhc29uIEkNCmNob3NlIHRv
IHNheSAidW5kZWZpbmVkIGJlaGF2aW9yIiB3aGljaCBJIHN1cHBvc2UgaXNuJ3QgdmVyeSBoZWxw
ZnVsLg0KV2lsbCB1cGRhdGUgdGhlIGNvbW1pdCBtZXNzYWdlIHRvIGluY2x1ZGUgbW9yZSBkZXRh
aWxzLg0KDQpBbmkNCg0K
