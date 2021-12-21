Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CC747C172
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbhLUO0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:26:02 -0500
Received: from mga18.intel.com ([134.134.136.126]:41660 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233887AbhLUO0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640096762; x=1671632762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ullnnjAqJR4T+Wqx3q5UewPyvIswDtplR2I+qP2T66w=;
  b=SzJnYMDRtRKexRmHGG/FylM7f7N4ClVlREQLhh4mBvqSwPHg+rWjULBY
   WtL3jbMAEI3JjJxlYhG38DUKP5oqLQD2AGqXLAX4vV83m2BV4MBrQm0SJ
   uJEK8wfdF8g/ZrPVcYRoozFzqgqRjQxl6t+ubgGIjl2OMPV20AryYodlA
   QyiXmIiJWKbfpv0ygx4h9Fu4USMdh8BqRGwtOuB1ltHk8gDjkGCRihtMH
   zlzF0vWUERYahvL/8CCsUdAcL44NJre4znzk0doumrgGrXos5ADQp0zOY
   y9ksgTbUgczWZJEzq3iidowJS3u8rcwyfKm8U3WlWDoHS0iBkc7QOpEY/
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227251491"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="227251491"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:26:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="467806991"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 21 Dec 2021 06:26:01 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:26:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 06:26:01 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 06:26:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHcys2f8X2jmGdCtg5tIJ6eEsytvuF/8qYlogCw5+Cy57EBox/rgFN3b/Tu5eEHVQz3iDHRTvARPgczkBuhelqpL3vHNkw4JEqpzioIR/y6MGT1fXrD30wizEgxzrqGs9luC+uuirZbs7xXznZz6DfE7g1ZE0qyWI0J8YJSaGUcQNfGY3hXOtf5+LOtUsm2VFVBPuH08GLxifAMZkiWIWf9/mr9n6A1Kg0j790SkCInmz4VZvfxlToEaeVgVS+DA/ksqwesd4VOvBz2OFj0tsxz5JRW7+frXukz6DVAWyGFR83fS69jdEsfK7IRN6ZoCPV4viffVCPS9wmtqgzkH7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ullnnjAqJR4T+Wqx3q5UewPyvIswDtplR2I+qP2T66w=;
 b=PP9CVLR9//YfI6AWa45d/lwFV3Ajg+qrnKat4vGUanOXgQbgkziNiTcG6WDQxZlvXHBOaQBzWhmOqklTGtGthVelt5L69O7tVVaR3Piuw/M/dVmD6tS5B4uotky5DxEvciC83E8ZkhKBcAOM6xXJjvddy31VeAdI3V0kJ897PEDzxCOeQqm33jY8QW69U1jovicUOVqra6wyiTuIkR4kSQr2AWtpmbM+Av9hMZcs4bv6vFShxFvrPfeZE5NSgsTTNObBq3qXXjDXQPHz3ASwsQu05yR01CezZaV1GlGL9djqeRfoLSILxe28hdgb7iN8VbM+ojkyjUtqUz3NYiotjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1584.namprd11.prod.outlook.com (2603:10b6:301:e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:25:59 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 14:25:59 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Topic: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8h6kAgAAdWQCAAFcgAA==
Date:   Tue, 21 Dec 2021 14:25:59 +0000
Message-ID: <CO1PR11MB51707B01007B77CEF4F1640BD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcF+QIHKgNLJOxUh@kroah.com> <YcGW3lm4UBbDHURW@kroah.com>
In-Reply-To: <YcGW3lm4UBbDHURW@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b80e6d34-1bd4-49e9-da89-08d9c48dcf33
x-ms-traffictypediagnostic: MWHPR11MB1584:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB1584084E62F4CEE07A798E90D97C9@MWHPR11MB1584.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RKuBxhlrvvM9u5l6Xmy8CL9o823ad2P73bdj7UnB3gnxYTLWkiMNgmoonm3g369Nc8xFR9EhQ0yRrCt0phF+GBAmWv7PFbCnBjG8h8GuGdB5FmaOaaclqpViOYOVSR+iLY/IfkOm7UOqPw5PbmMhn/uPoLDFMQthKCl7AoErFgSuTlyTHv5+UsdwrBsxdpev7LwY8o5lAV2jAcnboMiQ/e2o0ogYKruL14wZKWrUx8gaatb8RuisY1h5hOojYiaMaFtuK9hymhcWhkvtvT+SLG3H9l0Ht6O2jiC7gzCiPYaOHumzizE4Et/3ON/5Fug0EIr0nX6iCc0oFMXFfIAJuuISwAcrYo0QgrKobiwY4mkHsdevEr9SspkUd4Vo8XUzLplepoqsDuhtQeS/2u5YyUgI5gRjWbxX+rg/lFALnqMAeCAG5Al5CovjTKLBBPvs21s2nBTcFJ/ZrksXTIYeTBNC6Q04rr84sV3x7IkWlsZd4yp3bopJY9b13i5uRqp53JfPh6Myi6Shu5SJoc6OcaixejTP5sc8dtDnyoevxTCS8wJaKEaK0EwcUzw0nOLmYyiJ4+0xy9EajGYPYneowt8RbWM/gLcILOq6DSAk3g62MM1uXB54q/JekDcFzIiDtFEs8/Knp7rPsCEDjibm1OangAI+eEc74wS3MkKCbId2HZ4cfJkupLGL2ZxJWZGT/R2QkOLJY2Dcemym1hz8lA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(122000001)(66556008)(52536014)(64756008)(71200400001)(55016003)(86362001)(54906003)(26005)(7696005)(8676002)(33656002)(9686003)(66446008)(38070700005)(83380400001)(5660300002)(76116006)(186003)(508600001)(2906002)(82960400001)(4326008)(66946007)(53546011)(6916009)(38100700002)(6506007)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVcxajF6NEZoUGtnbzlJaU5FUTdRalVsMmJieDBCSENkcWlGdk9KQ0tXMGpr?=
 =?utf-8?B?QktwNG1YOGxqY0NSZWhqT2NUb250Y2IwakpiTUY1ZUJtbm92NTdMR0J4L2NX?=
 =?utf-8?B?amcvOXJzRGRTS24yR3VCVzFvRFp1Tk00N0k5dk9yU0NwKzM2QllDNEdpMzFR?=
 =?utf-8?B?eGJDRGd3NnZDQUlmN1VrRmhYajhBOXBDSGdpZDlWRjA4UERuL0pObEVyQjRq?=
 =?utf-8?B?R0NjTjk4c2hQdGhRRncxdlM5b1VWVFdUUkJkUHlDR2t6dEJyNVllcjU1UW5t?=
 =?utf-8?B?ZU8ybHdReGt4VkVwSmk4MlJPL09heTEvTmg3UmhvTmRUR1VEREJlT2ZtTXdN?=
 =?utf-8?B?WE1yaWZWam5qOGU0My9nRkJDbHl2QVluNis5cGdtRUE3MnNvdlZXcGNjVW4x?=
 =?utf-8?B?M05QcEhZdWZLeGVuclpHTFBQdE1DbStaZStoYmRZRkRJY0Jwc0tkdjd3QXFN?=
 =?utf-8?B?ODFuTGVhSVpCMDd6K2FQRU56b1hFbDR0YktOYlFqdXdtRFRCVDJNOElxKytJ?=
 =?utf-8?B?d1Y1Y2ZiNi8wNDJpdlAyQ3hVdUVTYzV6alJReVhRM3E5Vm96NmxYbTRXSVIz?=
 =?utf-8?B?ckYxUDR2V2sraTRUYS9hT1d4Y2ZERGhpb0psa3RObTRMREtVQ3NsT0V2UENM?=
 =?utf-8?B?bjk1L3V6bDZGRzZwSFY2MmhqaGo3UGRWZkhYQlJwOXlxbGUwYmYxQ1hpNUhy?=
 =?utf-8?B?Zm5GUk9WQUw0NEhyOWc0bHA3SS9lN3ZWay9hUkpGcDRiS2dhRjFGelRiRnUw?=
 =?utf-8?B?RjBtc1l3d0tnNmpma3E0UEFURlZjQUEvN2poN1FLVDhNQ3krajFpaXBFTDM0?=
 =?utf-8?B?b1MvNWlsYStVZTdoTk1WVWQ1ZllDaVNiS3lBYjI1bEJrT2s3UENTb1dWQTRs?=
 =?utf-8?B?UXZxMHQwVGRwQ0hnVEhTb2haVDNzcVo2L3JvU0N1TGN2Sm5JY3hpdkx6a3pr?=
 =?utf-8?B?K1IzaXFudGhIeDQ0Ump6dkhNOW1BWk5tZXVrNG5IR0JCUVQyeTBRUkhrdjhp?=
 =?utf-8?B?eFp3VnlqTGJScDV6QXdFQ3pWU3FPYVh5di9qcmJXZWF0S1p2ZTlMOTA0VENI?=
 =?utf-8?B?eWdiNzJkRW54bDhqMnRuV0lYb0pyY05pNXhXQ0VxUW83NnVlQmdmbk1ibm9E?=
 =?utf-8?B?blJPQkJldG9HeUlWQ3RnMGhKbHNsTGRMQW5wUW1ZN1RkamVBblR2SnFwdUp4?=
 =?utf-8?B?bnFNcSszeC9sdDVBU3J5QjF3VWJ0VFk4NVoxV0hReU5pUzdXRjdOaWxURzVZ?=
 =?utf-8?B?d2NXajE5YjlIeUZHekJUQWpSbklLdmRyOUxWR2drT3RSM0NEczBBSEkvcWJU?=
 =?utf-8?B?Wis0UVhFYmorWWdjMzJSSXFFTTVUSDJhTXg3ZUd2YkVUU1lHdzNadHhNNm00?=
 =?utf-8?B?SDdTUjBpK2R2eEdZZnhpNFpnZ2tyd3NKZFllWmZCTkluYkRTVmd0RTNHbnFv?=
 =?utf-8?B?WHBkcWVpam9pOGFiUWdUK3YzbVFTc3JOS1VtMTY5OU1FRi8yVk1FdmV1cXR5?=
 =?utf-8?B?L3h3Uk96ZFpyR1RnMGJJRi9EK2k2a2RvdWZjVXhpSkRKS1JvbCs4M0ttNmc2?=
 =?utf-8?B?U2U5ZlVqLzZvdm9VSVBRNitkSUhNbjJlNTZKb1pJT0xXMmJGR1d3WjUrVWcr?=
 =?utf-8?B?bVo0N0ZNY1hsTm5nU0Y0c3hPVlAvRU1qRGdWOHJaM3Ntck8wbmhzYU1FcHVu?=
 =?utf-8?B?MnlWaS9DU0s3YlJyT3J5aXFsQzlFTGFiaVpQdkxQN2Z5SkZlVGYzdTBSN2c0?=
 =?utf-8?B?bmcxSDFLbGYrSTh3amp2K2E1QjRFd3VLV1RPc2JHS2VLNGUyc1BvMXNaQjR4?=
 =?utf-8?B?YUtLM3hacjNxc01vT3B2aG1YR0VtYWoxenoyTy9ESzBudkVuY1hIY3BMUGla?=
 =?utf-8?B?RU41MDhkdDM4N0hmcEZRQWtNZnA1YWZKdXBvNCtaOE0xMzlEOW9tWGUrejQz?=
 =?utf-8?B?UVlKV2JYWVRiSHphbCt1QXgyVjN4SjNxWjRoK2tCa3BuM0VwS2ZFWk9XWWN4?=
 =?utf-8?B?SGd2aXpsYnpUWGNkN0l3RVFmVlEyOFBkaEtsNFJlVzVuUHBqR1ZHSDBsV01C?=
 =?utf-8?B?Q0g5aGJuZ201NS90SHhoZDMvcVpxNjkwUTg4bjRsUkorT1YvS3hBYk53NUs2?=
 =?utf-8?B?bVBKMG9kcW93cXR0Y2huRU5ja1FVR1gyWmliL3VLUG10VXNtVndrTHFwdUZ3?=
 =?utf-8?B?dkp5c1JKOEoxMEV2UzAxM3FFaXRSTm5EUVhXUmVZc3ZTSlNtRWRROEFmSE52?=
 =?utf-8?B?MEZhN2RIbFBoUkVnNzZJSHJOR1dBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80e6d34-1bd4-49e9-da89-08d9c48dcf33
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 14:25:59.4046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r0g/cmwXaE0c6qYC4yW49HviVtncTCsWBzLI5SchAKVO9KrZFhABZ1Or/2DcTxFbexHD6Lt5515tbKtyMfI1Gh0HFzHo/0rpPS0WoTb0Cf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1584
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEdyZWcgS0ggPGdyZWdraEBs
aW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAyMSwgMjAyMSAz
OjU3IEFNDQo+IFRvOiBDaGVuLCBNaWtlIFhpbWluZyA8bWlrZS54aW1pbmcuY2hlbkBpbnRlbC5j
b20+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBhcm5kQGFybmRiLmRlOyBX
aWxsaWFtcywgRGFuIEogPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47IHBpZXJyZS0NCj4gbG91
aXMuYm9zc2FydEBsaW51eC5pbnRlbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRD
SCB2MTIgMDEvMTddIGRsYjogYWRkIHNrZWxldG9uIGZvciBETEIgZHJpdmVyDQo+IA0KPiBPbiBU
dWUsIERlYyAyMSwgMjAyMSBhdCAwODoxMjowMEFNICswMTAwLCBHcmVnIEtIIHdyb3RlOg0KPiA+
IE9uIFR1ZSwgRGVjIDIxLCAyMDIxIGF0IDEyOjUwOjMxQU0gLTA2MDAsIE1pa2UgWGltaW5nIENo
ZW4gd3JvdGU6DQo+ID4gPiArLyogQ29weXJpZ2h0KEMpIDIwMTYtMjAyMCBJbnRlbCBDb3Jwb3Jh
dGlvbi4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCj4gPiA+ICsqLw0KPiA+DQo+ID4gU28geW91IGRp
ZCBub3QgdG91Y2ggdGhpcyBhdCBhbGwgaW4gMjAyMT8gIEFuZCBpdCBoYWQgYSBjb3B5cmlnaHRh
YmxlDQo+ID4gY2hhbmdlZCBhZGRlZCB0byBpdCBmb3IgZXZlcnkgeWVhciwgaW5jbHVzaXZlLCBm
cm9tIDIwMTYtMjAyMD8NCj4gPg0KPiA+IFBsZWFzZSBydW4gdGhpcyBwYXN0IHlvdXIgbGF3eWVy
cyBvbiBob3cgdG8gZG8gdGhpcyBwcm9wZXJseS4NCj4gDQo+IEFoLCB0aGlzIHdhcyBhICJ0aHJv
dyBpdCBvdmVyIHRoZSBmZW5jZSBhdCB0aGUgY29tbXVuaXR5IHRvIGhhbmRsZSBmb3IgbWUgYmVm
b3JlIEkgZ28gb24gdmFjYXRpb24iIHR5cGUgb2YNCj4gcG9zdGluZywgYmFzZWQgb24geW91ciBh
dXRvcmVzcG9uc2UgZW1haWwgdGhhdCBoYXBwZW5lZCB3aGVuIEkgc2VudCB0aGlzLg0KPiANCj4g
VGhhdCB0b28gaXNuJ3QgdGhlIG1vc3Qga2luZCB0aGluZywgd291bGQgeW91IHdhbnQgdG8gYmUg
dGhlIHJldmlld2VyIG9mIHRoaXMgaWYgaXQgd2VyZSBzZW50IHRvIHlvdT8gIFBsZWFzZQ0KPiB0
YWtlIHNvbWUgdGltZSBhbmQgc3RhcnQgZG9pbmcgcGF0Y2ggcmV2aWV3cyBmb3IgdGhlIGNoYXIv
bWlzYyBkcml2ZXJzIG9uIHRoZSBtYWlsaW5nIGxpc3QgYmVmb3JlDQo+IHN1Ym1pdHRpbmcgYW55
IG1vcmUgbmV3IGNvZGUuDQo+IA0KPiBBbHNvLCB0aGlzIHBhdGNoIHNlcmllcyBnb2VzIGFnYWlu
cyB0aGUgaW50ZXJuYWwgcnVsZXMgdGhhdCBJIGtub3cgeW91ciBjb21wYW55IGhhcywgd2h5IGlz
IHRoYXQ/ICBUaG9zZQ0KPiBydWxlcyBhcmUgdGhlcmUgZm9yIGEgZ29vZCByZWFzb24sIGFuZCBi
eSBpZ25vcmluZyB0aGVtLCBpdCdzIGdvaW5nIHRvIG1ha2UgaXQgbXVjaCBoYXJkZXIgdG8gZ2V0
IHBhdGNoZXMNCj4gdG8gYmUgcmV2aWV3ZWQuDQo+IA0KDQpJIGFzc3VtZSB0aGF0IHlvdSByZWZl
cnJlZCB0byB0aGUgIlJldmlld2VkLWJ5IiBydWxlIGZyb20gSW50ZWwuIFNpbmNlIHRoaXMgaXMg
YSBSRkMgYW5kIHdlIGFyZSBzZWVraW5nIGZvcg0KY29tbWVudHMgYW5kIGd1aWRhbmNlIG9uIG91
ciBjb2RlIHN0cnVjdHVyZSwgd2UgdGhvdWdodCBpdCB3YXMgYXBwcm9wcmlhdGUgdG8gc2VudCBv
dXQgcGF0Y2ggc2V0IG91dA0Kd2l0aCBhIGZ1bGwgZW5kb3JzZW1lbnQgZnJvbSBvdXIgaW50ZXJu
YWwgcmV2aWV3ZXJzLiBUaGUgcXVlc3Rpb25zIEkgcG9zdGVkIGluIHRoZSBjb3ZlciBsZXR0ZXIN
CihwYXRjaCAwMC8xNykgYXJlIGZyb20gdGhlIGRpc2N1c3Npb25zIHdpdGggb3VyIGludGVybmFs
IHJldmlld2Vycy4NCg0KSSB3aWxsIHRha2Ugc29tZSBkYXlzIG9mZiBhcyBtYW55IHBlb3BsZSB3
b3VsZCBkbyBkdXJpbmcgdGhpcyB0aW1lIG9mIHRoZSB5ZWFyIPCfmIosIGJ1dCB3aWxsIGNoZWNr
IG1haWxzIGRhaWx5DQphbmQgcmVzcG9uc2UgdG8gcXVlc3Rpb25zL2NvbW1lbnRzIG9uIHRoZSBz
dWJtaXNzaW9uLg0KDQpUaGFua3MgZm9yIHlvdXIgaGVscC4NCk1pa2UgDQo=
