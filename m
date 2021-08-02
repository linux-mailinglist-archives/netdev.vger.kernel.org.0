Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA13DE141
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhHBVLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:11:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:44677 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhHBVLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 17:11:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="277302231"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="277302231"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 14:10:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="510403136"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Aug 2021 14:10:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 14:10:52 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 14:10:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 2 Aug 2021 14:10:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 14:10:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAjt6hqYe8Nqm105xMsnRmvv6JMiGQY1O1y1IIgfFLKRvDH1DQRnJKMQ1H8CQlooAVi5qbPMZXkZ+VSXguCdLi1ptclhULwUFoY5Dm0BQ91kQ3a78qmeFIPRb6MYi8onk2lbW2w68XLO4qvSZuiplVmzrz/Q59jHssneUlC4nFWzRgGOtF1S4IGesoQH1yWWgi1qtylgwwuBziBnHozGNZGMy2sLwJW0dG3QY+c+26CEsEKXx2Tj9gfBvRXkfvHnl/QlUj1VttPdJTJlOhCGXHsBlXur2Mhhzg1X6wdg6i+98v0/OxFMDMfZtydLT5m5vqajQwHnkdIOVpr1zuEcBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0MY7kDTKYe8e81ShdVnkFt6oCwRn0G9/EJDCkzrIZ0=;
 b=hTh4ghrBpgCFLaXHhzsY0ipUJYq+VSMTH8o7BvvAMclFYkBJyTMQrjx7JphjaflAurTw6bJ7xaYMC6b6iaK1FtKBoyJBcVQ3Zac3syeqMFtwE2jMMLGFjVvAzcBcW5QuYPVUw69ke1S2ieotKCcm0GmCLcW3Y2eE5fohKrCCeCsCnXzHrJeEs3RUNJBerFHiYfPMsIpduT4CjEuJV70SkCWLgPIeM4Sdl3f/lSi5ou9Riwlb+Q8OWhMtK1y08kQE+Dg7NFsTAw19Q9MCiAwS6GPsQk2qYoZWi8byZcO9X147NykW30xSqGB5JQ8UAJnR86xDhXk8leynoiigdOQ0nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0MY7kDTKYe8e81ShdVnkFt6oCwRn0G9/EJDCkzrIZ0=;
 b=ZWI6GdMFk0q3cvGzD3wRt4NrG3uFnKGvdS3ghuc7crasxGmm6cT3NwvoWDvaH0AVYSTqbcn+dqpOtF1GlntsyKm5seN1JzJz6921jZpA1Q4uQge/n86fDQ0GRV06p005Dh0Uyy3eEE34rC75SHHkZx52VtIXog/uDYusNJrLaeM=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1518.namprd11.prod.outlook.com (2603:10b6:301:c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 21:10:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 21:10:49 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAAAqYAIAAAknggAAFUACAAALNwA==
Date:   Mon, 2 Aug 2021 21:10:49 +0000
Message-ID: <CO1PR11MB508981DD21005448829C014AD6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
 <CO1PR11MB50892367410160A8364DBF69D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAK8P3a379=Qi7g7Hmf299GgM-6g32Them81uYXPqRDZDro_azg@mail.gmail.com>
In-Reply-To: <CAK8P3a379=Qi7g7Hmf299GgM-6g32Them81uYXPqRDZDro_azg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e3f6a9d-e5a8-4d92-9631-08d955fa00fb
x-ms-traffictypediagnostic: MWHPR11MB1518:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1518A76D2AB5E77B3641785AD6EF9@MWHPR11MB1518.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: STHdXnH8NXErJIHwTVKb4GUJhs1ddEvMryexIbzUNO+hu9nbR4xn9ddmu6cErldy26UjUQJbXXJ2MZ+BTCi4sRFw+Xy9KplyMX1ovy0dPQSq4ReyiNMMaOKJ8wJn2tX+FmKHTU9+2Zq4BuIneBEPoPKRxb7L10kuPpvqK5HKe+5F5IikK4/9uU7i5bClFIkzHnm+OhhNNC83FaB45F+Hvro+OEU0PrxT+sYkldtv6sKHRH/DdgLZc0lxf/tw10KQ6ncbAkWW64S9/TVcmN6cMrViD4xNDu5qzybNeV55eyUrHCO/glQMC04mOba6vvBGAvuamRdoC59Jne6grsEfhj1TU/WkC7VvOnyOPJ9ECWC6EhPsKdn3Tm4hjY9fCK0aAM7ORTSwvNOavOsBXG1re3gCNth2eKNoI1LgdaB/SjmuFbVrwSCcVHxqv9Qpzd8jD5x+oOd6OTlJCw6zidThfnVIlqpVPeng62uA7Laqi0d6eMD5pxaLYJkFsj8kjrJ1C2GfMo+evM9hwpzXp0VHI+N8fyEre5+r6o7n5w5ZwOFN/RvS8vvE2tvpMHxMZbu9Ssh84mVzI16KTYPYw9R+IXjmZgp8iHx5ThmGgtlaQKsOuroLss3nqrYLp30s+6OOQkm20j1FkZ57ME/5kPpblGwl1rHEcSd6PvX0+hXjgcHhu95/esNJxi3acC9rquNgf21hvZ8V2nl/E2cMPcvx0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(9686003)(2906002)(55016002)(4326008)(122000001)(71200400001)(38100700002)(6916009)(7696005)(53546011)(26005)(5660300002)(6506007)(316002)(83380400001)(54906003)(478600001)(86362001)(38070700005)(66476007)(7416002)(33656002)(76116006)(66446008)(8676002)(186003)(64756008)(66556008)(52536014)(66946007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTZuWVl0c1BBK0EydnF2Q3owVVpiWTBySVZ0ZVo0cTF4UlBUb1JSOWhpenFv?=
 =?utf-8?B?U0FRL2RIcWdlY1N6UFVIVng3Ylg3WmJzS21UNmFPeWZnb20xbDdBZzZCQUNB?=
 =?utf-8?B?cmVVUloxSEJxNzZvbEQzelJuZEcxV0hzOFZJY0VxcGJ2RUQzRHNZV3VZZWNE?=
 =?utf-8?B?QjA0Und5eFluWUU0bjgxVjlFQndMVXdNVEIrRlFkcXZnQVg0Sit4M3hwbm1r?=
 =?utf-8?B?bHNYYlY4U2FNL0JRWGpRTi9jQnJtcU0zUTh4V3U1VGFjMHVvU1VoRlBBNVkv?=
 =?utf-8?B?WWlHTXg1aEZnN0tUWitSQ3owMjRTYW4wTjN2WTRTc0U4dWpOaTJ5R01uektW?=
 =?utf-8?B?bHZPb3k1ZzVpRHhkclh6ZnordFIyUE1nb0xQTzIxazBzeXh1MG84NEdkdlNH?=
 =?utf-8?B?L1MveG5OZU1tL1ViQ29GUVZDWGNWVVlFS0JDOTZsSWllYmJBYkZHc2hnUGEz?=
 =?utf-8?B?SG53a1JhWE16VW4vMDZweDh5c3JkSks5T3hmNFc0UldnMU53dis5OFFmRndu?=
 =?utf-8?B?c2Q1SWZjd0gra2NtSkhxQW5KcFFmUnQxZkREQ2UrakYxL0VSL3JPTnFjbUZY?=
 =?utf-8?B?U3NmbTJhQk1GUW5laG0xbjdMSnlTeDdXWVkxQkkvYk53dXJIbW9oaExyWnlt?=
 =?utf-8?B?UWJBcHBTSmVONjNZWlk4c1ZucDBlUGtMK2lBQnd6bzdlVTRTMVVCNVB3SmEz?=
 =?utf-8?B?UE1GWTNCTE1sTFJ0QkcvaEVLZzQ1NFBtQWx0a01qS2ZUVXU3eFdqRzNNV21Z?=
 =?utf-8?B?dUtvK0dXMm93TjA3RXFMTUVyMmtWK0FjVFdUVEYwZXllaml2VmIvejJDZnd3?=
 =?utf-8?B?cjdueGNuNnAxZ0FpNElUbGN4aDZucGdEYWN5Zm5uRmNCaTgzY2VwTHVCK2Nw?=
 =?utf-8?B?MllISUJJSDMrWklVd3lwK2c5VWdoT1JsNnJOZXExd0NINHIxRWZXa0kyT3VX?=
 =?utf-8?B?QU80b2pwc2oyWTlqdkY2WEtiRVhmTThtUVJVWkFZZHY3aVVVcGF0REhTWUMr?=
 =?utf-8?B?WDYwcVVrRzNNYi9lMVk0R0xRM1ZvN0xlOVJHL3BHdkludDIxV2RTbzNJd256?=
 =?utf-8?B?SWtwQ3RscmNhQWEyY2tQTFRZMGNrMnRJRGo4M2k4VjBZUEZuSHNPOXNjODQv?=
 =?utf-8?B?WWJENW9wSkJZWnNpeVBKdnVTRVpXQ3JhcVREOVJaYURnMXQ1UEpEdWxFMUt2?=
 =?utf-8?B?bHE1RVVkUms3Zk80SS9VUzd1RzJZdFZBUEljOEl3K0I3SzdiaGFIZ0hWYURN?=
 =?utf-8?B?RXZ2bEdLZVJYcHBuMzNQekxtOGdkNXQxVUc1N1JBRVR2MmpQbHYyTjE4bFBh?=
 =?utf-8?B?ZEZwWThieW1OdnNoR1JPbG1ibUNCMXppcnJXQ1dWcWcwVVNmMGc2OHl4RzQx?=
 =?utf-8?B?a2x3RDhtS1Y0WktFR09kSlFMOHQvWGt2R3dTLzgxQkh0NzhuYTU3ckVobU55?=
 =?utf-8?B?d3ZvcVhVZ3VtSkRSaGdsVlkyNTJ3TEMrckprNTJsZGVUZFBuOW13QzhDZlhz?=
 =?utf-8?B?ZW43bEZwTWk0K3E2SXp4OVZPZ1VQZUkySmYxYmJFNC93Q2hSQ1ExZFFIYmZX?=
 =?utf-8?B?T0puaHBLa2dSV3dyV2w5Uy9EejhLWGdsRXRmelZNWk5UcXk3eEtTTnVaMkF6?=
 =?utf-8?B?aGVjMXFEUmtGRXVWemI3NWtLeFFyUE5ncC9Ha3pSa0NnamZ0R1VIblNtUE1M?=
 =?utf-8?B?R2JjbVlIYzhwQlhGeWlDU01IVVFyLzdDeUJSZUZhcStiSCtzL2xucW5VTFVT?=
 =?utf-8?Q?JskupHzp2kEX8uT7nU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3f6a9d-e5a8-4d92-9631-08d955fa00fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 21:10:49.4138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZijTTFfjPraiC4slNB1aalNniKGPuP0SMfLE4XJCjrt6z21d39i+gdnX009sm5EYUcVX7tiZoNzsqpEW886qDLARV7MkbMaXRDCCxJKwOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1518
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAwMiwgMjAyMSAxOjU5IFBN
DQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gQ2M6
IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgTmljb2xhcyBQaXRy
ZQ0KPiA8bmljb2xhcy5waXRyZUBsaW5hcm8ub3JnPjsgQnJhbmRlYnVyZywgSmVzc2UgPGplc3Nl
LmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsNCj4gTmd1eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5u
Z3V5ZW5AaW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0
PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4NCj4gPGFy
bmRAYXJuZGIuZGU+OyBLdXJ0IEthbnplbmJhY2ggPGt1cnRAbGludXRyb25peC5kZT47IFNhbGVl
bSwgU2hpcmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IEVydG1hbiwgRGF2aWQgTSA8
ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsNCj4gaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9z
bC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJdIGV0aGVybmV0L2ludGVs
OiBmaXggUFRQXzE1ODhfQ0xPQ0sNCj4gZGVwZW5kZW5jaWVzDQo+IA0KPiBPbiBNb24sIEF1ZyAy
LCAyMDIxIGF0IDEwOjQ2IFBNIEtlbGxlciwgSmFjb2IgRQ0KPiA8amFjb2IuZS5rZWxsZXJAaW50
ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gPiBZb3UgY2FuIGRvIHNvbWV0aGluZyBsaWtlIGl0IGZv
ciBhIHBhcnRpY3VsYXIgc3ltYm9sIHRob3VnaCwgc3VjaCBhcw0KPiA+ID4NCj4gPiA+IGNvbmZp
ZyBNQVlfVVNFX1BUUF8xNTg4X0NMT0NLDQo+ID4gPiAgICAgICAgZGVmX3RyaXN0YXRlIFBUUF8x
NTg4X0NMT0NLIHx8ICFQVFBfMTU4OF9DTE9DSw0KPiA+ID4NCj4gPiA+ICBjb25maWcgRTEwMDBF
DQo+ID4gPiAgICAgICAgIHRyaXN0YXRlICJJbnRlbChSKSBQUk8vMTAwMCBQQ0ktRXhwcmVzcyBH
aWdhYml0IEV0aGVybmV0IHN1cHBvcnQiDQo+ID4gPiAgICAgICAgIGRlcGVuZHMgb24gUENJICYm
ICghU1BBUkMzMiB8fCBCUk9LRU4pDQo+ID4gPiArICAgICAgIGRlcGVuZHMgb24gTUFZX1VTRV9Q
VFBfMTU4OF9DTE9DSw0KPiA+ID4gICAgICAgICBzZWxlY3QgQ1JDMzINCj4gPiA+IC0gICAgICAg
aW1wbHkgUFRQXzE1ODhfQ0xPQ0sNCj4gPg0KPiA+IFdoYXQgYWJvdXQgImludGVncmF0ZXMiPw0K
PiANCj4gTWF5YmUsIHdlJ2QgbmVlZCB0byBsb29rIGF0IHdoZXRoZXIgdGhhdCBmaXRzIGZvciB0
aGUgb3RoZXIgdXNlcnMgb2YgdGhlDQo+ICJBIHx8ICFBIiB0cmljay4NCj4gDQoNClN1cmUuICBJ
IGp1c3Qga25vdyBmcm9tIHJlYWRpbmcgaXQgb3RoZXIgcGxhY2VzIGl0IHJlYWxseSBjYXVzZXMg
YSAiaHVoPyIgcmVhY3Rpb24uDQo=
