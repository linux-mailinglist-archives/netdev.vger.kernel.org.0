Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E0E3C1BF0
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhGHXXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:23:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:40838 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhGHXXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 19:23:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="273452102"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="273452102"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 16:20:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="646118798"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jul 2021 16:20:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 8 Jul 2021 16:20:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 8 Jul 2021 16:20:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 8 Jul 2021 16:20:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK45bZk022i9XIFoNZuVju1Fafrx6AJaK64mGhzCoGPzhRn4bfhH93wzdALZy1w4pVNRPTUjdGwmodza6viE2VctvsHFuVFcW4jheGKgrUmsil2Z3drSkoKHezRivLa2a2zTVrBZxOZO16DH1jJ6vB0zDjl2J491fGM+qkmBT+qDH/7Y5J/rxXcPZSJQl7EaEkz8QO3LRnoOrs1Hcw5GNxegYucIZvgE8qNJayobYrATSzfQIFIrwdDL+GDy7JNarDWHq05N5J6LVLCHhklWidutMq8CflK8dpL2PUOAOndzPayo547SBBkO0UjJs4Fpc0tvybXL/+bfQhND+SZXaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwe1Te685pG9C0e4IYRB7m3oo7NFyOppdZNDYQ8shak=;
 b=TRrRUoUe/zSAvTsC1b6StVfLGCzISelSHN9jZeDc3x07Pb9Lq3svaUn1deogRlCd/Oa+west0IRxMf+xqPdZSy6BcAB9rHyPj9iezBnNM9VxOp7X5zgamXI7U3D8Y4JMYdFQgB/EfET5eBGFme7/C+RXsQTw0aIaorbqBrwY/FNgBqul9iKLVbYu01JCyTHT/Q9mpVbrl5Pud6m27g5DRfSJV6r1GpT53B5Lj3QIpIWECdoQhsK8V2TgjZrOG4+QK2evZVbVexsuSZLpnVo/Dwn9Akg+3MNysuxv2J92GWIC9ddkFtzvF6jaHYqO2weRzw7ojeLaX+K53oAqFNZ+6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwe1Te685pG9C0e4IYRB7m3oo7NFyOppdZNDYQ8shak=;
 b=r9bZHhKqP2G/BSddVOZmt6cMbXScZvC6LL0kms/TsUHQIBC8UMLbQmACr4WWOP8UMOOh1fsIXClaVHP4/8e9pF3qxbRWioj06yrG0RSCB8RjhVFumNLcVuuvvTRRiC6XSOqrYByDlxMHiAdzAX8Ul00mYtAklrpNpg3L3+aoIXE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 23:20:52 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290%5]) with mapi id 15.20.4308.023; Thu, 8 Jul 2021
 23:20:52 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
Thread-Topic: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Thread-Index: AQHXc5JVSuHoO6yBxk2FsVeJf8muoas4SJuAgAAXwoCAAHlYsIAAb2yAgABs+XA=
Date:   Thu, 8 Jul 2021 23:20:52 +0000
Message-ID: <CO1PR11MB47719C284F178753C916519FD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch> <4e159b98-ec02-33b7-862a-0e35832c3a5f@gmail.com>
 <CO1PR11MB477144A2A055B390825A9FF4D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
 <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
In-Reply-To: <9871a015-bcfb-0bdb-c481-5e8f2356e5ba@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c008d0e-9a69-4c38-871a-08d9426707af
x-ms-traffictypediagnostic: CO1PR11MB5170:
x-microsoft-antispam-prvs: <CO1PR11MB5170CE0F16B249A011AE76DBD5199@CO1PR11MB5170.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oXmScuHE9+LFmS2kp5K7deG5WoFbMKxONTINdRPu8CaecCeFOEmv1mZWzWFC2YSmHFlNrZoqQvutTBPtSzbHeyf2WOGYq7bN1pnOFWhlc9x7dy77ZB9dOIKzCGjRPG9KWudHQeNaQeqFIvDIFFvoqjg4NQAiCz4JmJVE8mplboo7j4zHgDYXrP3FVApGD2fHyAQ/0+5yyba+eqNmRKqABIpChRihybucYSSvVa90A9taykEjhBmMHxkBQ3MLiicjQ1P3JVj5kzE1D3wjNHuhhFSbDfECnprvP3XJ+TPAQhE2K3UAPlQgsBNEDYsNCVOFN2024AtBhFsHsLe33+R2Iz4Ko4SjH+8D4xBSebhbSpUCatV2CP/pYJSB7WIXSGVrQHLzFR43aBCzF6KHE/yievKzUwmhxpt2VSx2ga2iPsmCABLtR17ZjQ9X0Kgnh8xQ1YQXtv6RtOLC98YCg1M+4r/JQKG1lh+EEEbpEKoYmXm+yGMIP+yHrCU3XH4ttut09nwmd2cFvMjdT0QMjjPjVTNHwxKbWnWWBQhkPQJEA1INISj6DD8Pt2+Utw6yFHqbIrZPHvUIFXS7KkNjuDHKKZ9vWG17oyCGzx7CLdNal8xOGdb+uOCjm+ZWoc4MFudW0DAaWguYlevx/1izpCN88g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(346002)(396003)(26005)(66476007)(7696005)(6506007)(122000001)(71200400001)(9686003)(83380400001)(478600001)(53546011)(52536014)(316002)(38100700002)(110136005)(4326008)(33656002)(55236004)(66446008)(66946007)(55016002)(186003)(64756008)(66556008)(76116006)(86362001)(54906003)(5660300002)(2906002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M3VpV2ZRRzJLRFpXbWhqaTFzSlJFSXh1SnpPR0xVY0NUWER4ZE1DbjlUdWp1?=
 =?utf-8?B?N0RuRFkxVlN0VnNyWGZvQjdwVGRoZ2VkS012VVNyV3pJR2gwbFM5OVBzOUdQ?=
 =?utf-8?B?b1dIWk5RV08yd0lyWkkxRXp2TmU1QS9sTGJ2YTZYcWQxY3ZGOWthRTZxbWMr?=
 =?utf-8?B?WnJ5aVpFeThoVXhQWEFISGpGY1JzdWcxR0NzWmpGNjBvYVZvRmxuQmY4ZENi?=
 =?utf-8?B?UXEydDNzODBvcEVwdEsrRlFCMlgweHU4ejNobGlxa3ZsS3JLNzMycWI2MkZi?=
 =?utf-8?B?dmhBa1JHVmVXeUt4VTNLWkJsaHdPa2pHcEpXQWp6S0ZCNnJpRGtpVGc5V2d2?=
 =?utf-8?B?OUxKdWFIemRNalIyNXVldnhFdUdaRzRhejVmN2tJNXNJb2tLZWxVanNacGJu?=
 =?utf-8?B?Z3ArN3lzeDNHN2JRTlFDbHhLMGxDOUVHTjl6TzFHRVpjZ3F6dE9leVNwNmJ6?=
 =?utf-8?B?cjVVYXFPRGN2V2t0cUEzSnUvV01VMlZ3NklHVVhSdnZuR2RmOXN3RHJpNzFF?=
 =?utf-8?B?NU8rRmZ4VCtXZU1iMkt5S3FzcE5FdHViNTZtMzZNYjYyYmpicUpnTDU0ejFY?=
 =?utf-8?B?Ukx3S3p1eVRZSjRRU2lDckhNSGRiTmlKTU1XSWkzOERoWDlkVlA5R0xPcy9G?=
 =?utf-8?B?eGJTQ2k4UGoxRmhsYWtRemltbzZwUk0xekozY25hVUxwWlBPZmhpWWVhdUo4?=
 =?utf-8?B?amtSemVTTW0yblNQNG9UdCtxU2pnbThtQU1pdTZtUkUvWmdXRUFiNnNnbWph?=
 =?utf-8?B?YXJGWWQrSlVXMVhjeFB5b2hkQm5oMWU2ekQ1NHpGNC94U25XVEJ6TTNxalp2?=
 =?utf-8?B?UEZ6cDhSOHZ3WFc5cmZGekNrZXkzOHBaSWFRa0p6ZHNuZmpQQXJpK1hnTjNL?=
 =?utf-8?B?dU1KaEdVaHR6MzVsakl4dmR2SC80dDd2UXVWWStxM252V201NmZmcGxocUQ5?=
 =?utf-8?B?K1YwK3dxMU5Ia2FCY2ZpU0xoQzZBUFkyV1lqYjh0UkFWQXczeTRYU2ZPRTdr?=
 =?utf-8?B?aEIvQ1Zmc0hRZ2F5ZlZBZ1dtdGNkWHdad3ZFUUhPeUt0UjhOSUhleGQrd2hl?=
 =?utf-8?B?dVpibkFRZjdOTGtlSWlaVXBpbDZZNlRCNVVhcXhaaGNOODBma0ZKTDlVYlNR?=
 =?utf-8?B?NFVYQ3FWYURMYnVlWjhMV1VIcmFsdkRhaFc3ODdKNDFwblV4dDA0S3ZWY3Rx?=
 =?utf-8?B?VlJZdDluM3hjVDkraHJaTGE5aUtGVlpmbCtDTDJzeGU5VHZvTFVrRnZEbzVU?=
 =?utf-8?B?UUp1ZW1oNW9xWFlPUFk1UmFSZUtmS1VKMDNadHgwZWx5Nk55N0RVaEZSNHJ0?=
 =?utf-8?B?QUJ6Nzd1d2N6bmZrRHhYNzNET1pRMCszc213ZU1laGVEOFFwNjhrblpiRHFP?=
 =?utf-8?B?Q1pzWVhyUHVOZXNEaHR5UGpUNzBDTWFpMWFvZHVWOEovWGQxeVVCcEVsYk1D?=
 =?utf-8?B?YXpvalp2WFRxYnAxOTJESkNzWnRQaDNtcEdZcWVESjVlRTVrUklvTkhSQ2dB?=
 =?utf-8?B?RjMyMFJWVXFjV3IwMk5aMDlya1Myb1pDSlhFeUtXSEZINGxweUJhNEJjWFk2?=
 =?utf-8?B?K1MvQWdkRFJmNENTZE41OG1aQWdZQ0VHc2IxQ2tTMGI1ODFnMVFPYVpBRldM?=
 =?utf-8?B?NmlHVi92d0o2Y01IRSsxaGg1RW9kWUZKcm0ycklQRzVMaUJsc21MbTNtRjh1?=
 =?utf-8?B?VUZGdU55ZFZkalBNbU8xSzMzbVA1L3RHZzVDamlwem9JRDVkL0pCdk9ZNjdh?=
 =?utf-8?Q?owt+gHvd4u0wW27tJTrqb74cHYpu/Vmmou1sj8+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c008d0e-9a69-4c38-871a-08d9426707af
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 23:20:52.6190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z9JSALjcZk7ibOqqyklAtXVj97EV81gpuqTUYW30jBnCF8PEz+WQp9Gy/kiB048RdfpnU1Cn0CP9hOKXJoBjUPSlp0WDZZvzBKlbeVsqYYvgnl71WTSYevY8pLaK3YpK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5170
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBGYWluZWxs
aSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVseSA5LCAyMDIxIDEy
OjQyIEFNDQo+IFRvOiBJc21haWwsIE1vaGFtbWFkIEF0aGFyaSA8bW9oYW1tYWQuYXRoYXJpLmlz
bWFpbEBpbnRlbC5jb20+Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IENjOiBI
ZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsgRGF2aWQgUyAuIE1pbGxlcg0K
PiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFJ1c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3Jn
LnVrPjsgSmFrdWINCj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0XSBuZXQ6IHBoeTogcmVjb25maWd1cmUgUEhZIFdPTCBpbiByZXN1bWUgaWYg
V09MDQo+IG9wdGlvbiBzdGlsbCBlbmFibGVkDQo+IA0KPiBPbiA3LzgvMjEgMzoxMCBBTSwgSXNt
YWlsLCBNb2hhbW1hZCBBdGhhcmkgd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdt
YWlsLmNvbT4NCj4gPj4gU2VudDogVGh1cnNkYXksIEp1bHkgOCwgMjAyMSAxMDo0OSBBTQ0KPiA+
PiBUbzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgSXNtYWlsLCBNb2hhbW1hZCBBdGhh
cmkNCj4gPj4gPG1vaGFtbWFkLmF0aGFyaS5pc21haWxAaW50ZWwuY29tPg0KPiA+PiBDYzogSGVp
bmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT47IERhdmlkIFMgLiBNaWxsZXINCj4g
Pj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9y
Zy51az47IEpha3ViDQo+ID4+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOw0KPiA+PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggbmV0XSBuZXQ6IHBoeTogcmVjb25maWd1cmUgUEhZIFdPTCBpbiBy
ZXN1bWUgaWYNCj4gPj4gV09MIG9wdGlvbiBzdGlsbCBlbmFibGVkDQo+ID4+DQo+ID4+DQo+ID4+
DQo+ID4+IE9uIDcvNy8yMDIxIDY6MjMgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+Pj4gT24g
VGh1LCBKdWwgMDgsIDIwMjEgYXQgMDg6NDI6NTNBTSArMDgwMCwNCj4gPj4gbW9oYW1tYWQuYXRo
YXJpLmlzbWFpbEBpbnRlbC5jb20gd3JvdGU6DQo+ID4+Pj4gRnJvbTogTW9oYW1tYWQgQXRoYXJp
IEJpbiBJc21haWwNCj4gPG1vaGFtbWFkLmF0aGFyaS5pc21haWxAaW50ZWwuY29tPg0KPiA+Pj4+
DQo+ID4+Pj4gV2hlbiB0aGUgUEhZIHdha2VzIHVwIGZyb20gc3VzcGVuZCB0aHJvdWdoIFdPTCBl
dmVudCwgdGhlcmUgaXMgYQ0KPiA+Pj4+IG5lZWQgdG8gcmVjb25maWd1cmUgdGhlIFdPTCBpZiB0
aGUgV09MIG9wdGlvbiBzdGlsbCBlbmFibGVkLiBUaGUNCj4gPj4+PiBtYWluIG9wZXJhdGlvbiBp
cyB0byBjbGVhciB0aGUgV09MIGV2ZW50IHN0YXR1cy4gU28gdGhhdCwNCj4gPj4+PiBzdWJzZXF1
ZW50IFdPTCBldmVudCBjYW4gYmUgdHJpZ2dlcmVkIHByb3Blcmx5Lg0KPiA+Pj4+DQo+ID4+Pj4g
VGhpcyBmaXggaXMgbmVlZGVkIGVzcGVjaWFsbHkgZm9yIHRoZSBQSFkgdGhhdCBvcGVyYXRlcyBp
biBQSFlfUE9MTA0KPiA+Pj4+IG1vZGUgd2hlcmUgdGhlcmUgaXMgbm8gaGFuZGxlciAoc3VjaCBh
cyBpbnRlcnJ1cHQgaGFuZGxlcikNCj4gPj4+PiBhdmFpbGFibGUgdG8gY2xlYXIgdGhlIFdPTCBl
dmVudCBzdGF0dXMuDQo+ID4+Pg0KPiA+Pj4gSSBzdGlsbCB0aGluayB0aGlzIGFyY2hpdGVjdHVy
ZSBpcyB3cm9uZy4NCj4gPj4+DQo+ID4+PiBUaGUgaW50ZXJydXB0IHBpbiBpcyB3aXJlZCB0byB0
aGUgUE1JQy4gQ2FuIHRoZSBQTUlDIGJlIG1vZGVsbGVkIGFzDQo+ID4+PiBhbiBpbnRlcnJ1cHQg
Y29udHJvbGxlcj8gVGhhdCB3b3VsZCBhbGxvdyB0aGUgaW50ZXJydXB0IHRvIGJlDQo+ID4+PiBo
YW5kbGVkIGFzIG5vcm1hbCwgYW5kIHdvdWxkIG1lYW4geW91IGRvbid0IG5lZWQgcG9sbGluZywg
YW5kIHlvdQ0KPiA+Pj4gZG9uJ3QgbmVlZCB0aGlzIGhhY2suDQo+ID4+DQo+ID4+IEkgaGF2ZSB0
byBhZ3JlZSB3aXRoIEFuZHJldyBoZXJlLCBhbmQgaWYgdGhlIGFuc3dlciBpcyB0aGF0IHlvdQ0K
PiA+PiBjYW5ub3QgbW9kZWwgdGhpcyBQTUlDIGFzIGFuIGludGVycnVwdCBjb250cm9sbGVyLCBj
YW5ub3QgdGhlDQo+ID4+IGNvbmZpZ19pbml0KCkgY2FsbGJhY2sgb2YgdGhlIGRyaXZlciBhY2tu
b3dsZWRnZSB0aGVuIGRpc2FibGUgdGhlDQo+ID4+IGludGVycnVwdHMgYXMgaXQgbm9ybWFsbHkg
d291bGQgaWYgeW91IHdlcmUgY29sZCBib290aW5nIHRoZSBzeXN0ZW0/DQo+ID4+IFRoaXMgd291
bGQgYWxzbyBhbGxvdyB5b3UgdG8gcHJvcGVybHkgYWNjb3VudCBmb3IgdGhlIFBIWSBoYXZpbmcg
d29rZW4tDQo+IHVwIHRoZSBzeXN0ZW0uDQo+ID4NCj4gPiBIaSBGbG9yaWFuLA0KPiA+DQo+ID4g
VGhhbmsgeW91IGZvciB0aGUgc3VnZ2VzdGlvbi4NCj4gPiBJZiBJIHVuZGVyc3RhbmQgY29ycmVj
dGx5LCB5b3UgYXJlIHN1Z2dlc3RpbmcgdG8gYWNrbm93bGVkZ2UgYW5kIGNsZWFyIHRoZQ0KPiBX
T0wgc3RhdHVzIGluIGNvbmZpZ19pbml0KCkgY2FsbGJhY2sgZnVuY3Rpb24uIEFtIEkgY29ycmVj
dD8NCj4gPiBJZiB5ZXMsIEkgZGlkIHRyeSB0byBhZGQgYSBjb2RlIHRvIGNsZWFyIFdPTCBzdGF0
dXMgaW4gbWFydmVsbF9jb25maWdfaW5pdCgpDQo+IGZ1bmN0aW9uICh3ZSBhcmUgdXNpbmcgTWFy
dmVsbCBBbGFza2EgODhFMTUxMikuIEJ1dCwgSSBmb3VuZCB0aGF0LCBpZiB0aGUNCj4gcGxhdGZv
cm0gd2FrZSB1cCBmcm9tIFMzKG1lbSkgb3IgUzQoZGlzayksIHRoZSBjb25maWdfaW5pdCgpIGNh
bGxiYWNrDQo+IGZ1bmN0aW9uIGlzIG5vdCBjYWxsZWQuIEFzIHRoZSByZXN1bHQsIFdPTCBzdGF0
dXMgbm90IGFibGUgdG8gYmUgY2xlYXJlZCBpbg0KPiBjb25maWdfaW5pdCgpLg0KPiA+DQo+ID4g
UGxlYXNlIGFkdmljZSBpZiB5b3UgYW55IHN1Z2dlc3Rpb24uDQo+IA0KPiBUaGlzIGlzIHByZXN1
bWFibHkgdGhhdCB5b3UgYXJlIHNlZWluZyB3aXRoIHN0bW1hYyBhbG9uZyB3aXRoIHBoeWxpbms/
DQo+IA0KPiBEdXJpbmcgUzMgcmVzdW1lIHlvdSBzaG91bGQgYmUgZ29pbmcgYmFjayB0byB0aGUg
a2VybmVsIHByb3ZpZGVkIHJlLWVudHJ5DQo+IHBvaW50IGFuZCByZXN1bWUgd2hlcmUgd2UgbGVm
dCAod2FybSBib290KSBzbw0KPiBtZGlvX2J1c19waHlfcmVzdW1lKCkgc2hvdWxkIGNhbGwgcGh5
X2luaXRfaHcoKSB3aGljaCBjYWxscyBjb25maWdfaW5pdCgpLA0KPiBoYXZlIHlvdSB0cmFjZWQg
aWYgdGhhdCBpcyBzb21laG93IG5vdCBoYXBwZW5pbmc/DQo+IA0KPiBEdXJpbmcgUzQgcmVzdW1l
IChkaXNrKSwgSSBzdXBwb3NlIHRoYXQgeW91IGhhdmUgdG8gaW52b2x2ZSB0aGUgYm9vdCBsb2Fk
ZXINCj4gdG8gcmVzdG9yZSB0aGUgRFJBTSBpbWFnZSBmcm9tIHRoZSBzdG9yYWdlIGRpc2ssIGFu
ZCBzbyB0aGF0IGRvZXMNCj4gZWZmZWN0aXZlbHkgbG9vayBsaWtlIGEgcXVhc2kgY29sZCBib290
IGZyb20gdGhlIGtlcm5lbD8gSWYgc28sIHRoYXQgc2hvdWxkIHN0aWxsDQo+IGxlYWQgdG8gY29u
ZmlnX2luaXQoKSBiZWluZyBjYWxsZWQgd2hlbiB0aGUgUEhZIGlzIGF0dGFjaGVkLCBubz8NCg0K
SGkgRmxvcmlhbiwNCg0KVGhpcyB3aGF0IEkgdW5kZXJzdGFuZCBmcm9tIHRoZSBjb2RlIGZsb3cu
DQoNCldpdGggV09MIGVuYWJsZWQgdGhyb3VnaCBldGh0b29sLCB3aGVuIHRoZSBzeXN0ZW0gaXMg
cHV0IGludG8gUzMgb3IgUzQsDQp0aGlzIGZsYWcgbmV0ZGV2LT53b2xfZW5hYmxlZCBpcyBzZXQg
dHJ1ZSBhbmQgY2F1c2UgIG1kaW9fYnVzX3BoeV9tYXlfc3VzcGVuZCgpDQp0byByZXR1cm4gZmFs
c2UuIFNvLCB0aGUgIHBoeWRldi0+c3VzcGVuZGVkX2J5X21kaW9fYnVzIHJlbWFpbiBhcyAwIHdo
ZW4NCmV4aXRpbmcgZnJvbSBtZGlvX2J1c19waHlfc3VzcGVuZCgpLg0KDQpEdXJpbmcgd2FrZSB1
cCBmcm9tIFMzIG9yIFM0LCBhcyBwaHlkZXYtPnN1c3BlbmRlZF9ieV9tZGlvX2J1cyByZW1haW4g
YXMgMC9mYWxzZQ0Kd2hlbiBtZGlvX2J1c19waHlfcmVzdW1lKCkgaXMgY2FsbGVkLCBpdCB3aWxs
IGp1bXAgdG8gbm9fcmVzdW1lIHNraXBwaW5nDQpwaHlfaW5pdF9odygpIGFzIHdlbGwgYXMgcGh5
X3Jlc3VtZSgpLg0KDQotQXRoYXJpLQ0KDQoNCj4gLS0NCj4gRmxvcmlhbg0K
