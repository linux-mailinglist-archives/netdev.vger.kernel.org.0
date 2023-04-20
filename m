Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AC56E8EAA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbjDTJyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbjDTJyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:54:23 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185882D5D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 02:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681984461; x=1713520461;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZgZRz9a4P8Q8y2DSDeXPd15gayIvbtDXgCKNPkCfE7E=;
  b=jXzxxjPwLb92JqXsJScxVPpymgzFaPCVRUHtKJcwO8D4TfxQxkbFDUhD
   9KH7ot6kkomvsJETw7XmzRZuKitjyxGyajpJvP5cY3juHWDZ7sqIG2SRs
   613WUnJ3NXXJ8PGqoFFWYlW+gWaKq2cbBUBbXieBMRSOH4+bCqJ9rZAB3
   gOB7APf6mqpriqxc8SHZJuerMEEunS3rCjjqDss5gJtepwNSEq1Ed+E4j
   KH/n560l6JkRxFYiHb7ninZEbjJdZc8rYbcthHEm/snvqhOKOVV3mL5+W
   6fTg64Skv5zaeIqbEX9H7CkKIGZ2SBNY10xThJlterpvpwhg0/Z/VoI9t
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="345695649"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="345695649"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 02:54:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="803281688"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="803281688"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2023 02:54:19 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 02:54:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 02:54:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 02:54:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQ9FjY4MJGtoQw2BUwMFHoGK3z47oxQPDjWpDT0wDPwTsKulHZqJ5urpM2orY9GhvkLd0KV5uvitUjSSXS5jVjk5BiJK8MrrkAPE4ZkUKfv79k1P88p+hOkCo0qqyLq48NuIPScKot7YXGrTiVHNppqyinRH6bHiyJz6/DQ8EXXb7iT+KSa0d/vCyEffXsQ8Fn1NMcrsE5wWwIeGtDlJgk3t36PKkqDqcKrHEDK2BLIWfS1qZmT17LYtNHSsl+mu5aQpEjAhWWvY4LjABncFagFui9bvYNxDb0MVcWjcwQFy5Tgfth1ZstEIf94oJ9skyK8p3loDHEkG6pv3Ko8sTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgZRz9a4P8Q8y2DSDeXPd15gayIvbtDXgCKNPkCfE7E=;
 b=R0IVBaB+JWESwIz9MWLSwLvwStnqkfahZFKwbd9QoIiAYgXfO1w+lTrreVioO223iKMyEg4EPzGUXi0NFrksZ1y8c0FfO/lYcDIe1rTKK/4F4o2Cndes7i14mb6AT6TTCg3oADXzqm74cEPfRysO7kYL1CjskFqu9iIRDD0Os6Y0YbE8LjWPFzuU+4yIVnhMZDVe++WVAYd+vfvmCdVYHMHv+v4HYgXHFe2Qz9h/h91RkIdavSm0MQVHyarWGxbkX7Y4iUmdUngQONqLnbYA+W68aief3NYuKPLdLIsn00QH+Y8uv3r4Nap0sGKjFuhHbTzizoq4TrXsenA+s/NxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by PH7PR11MB6747.namprd11.prod.outlook.com (2603:10b6:510:1b5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 09:54:16 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%6]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 09:54:16 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
Thread-Topic: [PATCH net-next 04/12] ice: Implement basic eswitch bridge setup
Thread-Index: AQHZctMVsnGBKGKcRE2LRxEZIa88QK8z7Onw
Date:   Thu, 20 Apr 2023 09:54:15 +0000
Message-ID: <MW4PR11MB5776C7DDDB91DD98A960AD20FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-5-wojciech.drewek@intel.com>
 <4a293c46-f112-e985-f9ad-19a41dd64f01@intel.com>
In-Reply-To: <4a293c46-f112-e985-f9ad-19a41dd64f01@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|PH7PR11MB6747:EE_
x-ms-office365-filtering-correlation-id: 5a063193-4c3b-4e0c-e185-08db418533c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iffkki8irglOljiF/gtSEmmpU8CIAOoLeqKrkEmitXS1qGHoyiMJGM/+0YP7/3xotPoEGc+bBknBKT9QgGUEt8IXaCYP1ZpLF08dAbvk4v+o+DNYmz3jy/FLJU9r8RPIWTNWM74Uk08BCZGXnluT0kJ7v1IIHlJ/2yaNU9LLGIWm0Wc/SsddMFsz454PDhFrJIFtEx9e1O+RWdUBEp3DBL870ls1jS2I7EM76ou46gtoBhLVbTFEiD6buvEfTefrHiYo5rEKjTHefwAWx2o1cuIxieJ0Zps96Hf/iGrj/DOfQs92Mpo4jnQ2aeaCQ3dRvr7rKzlIzO2G2nOQBVyN8NhKAaezBlHiJCmzdjDftL33CC8A3Bo+6xwhgp4lUTLv7U7fKBuRq4JwB814o+KtTBXEMam2KiThZltKrIxxSPBtGh7PKxtr3vVkhqly2VMyd96XlTgBq8MWhrHQMKfhWqBV2RrRRAJfHofSXiXdbFFTnI7iVT/lAZzOgDhNJGonz/XNiW91izo0fXw3ZvLtSqOcKXafMSqS/kFThlAZ5M5kB4Sx2w5Sn68pxrzwWRg3EpzdhfZapwGUbubfw04NwklWIMtRD13vXuaBDn7/NtLdkyaeMGqnr3bP9OzhkYTu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199021)(38100700002)(41300700001)(38070700005)(122000001)(5660300002)(52536014)(6862004)(8676002)(2906002)(8936002)(33656002)(86362001)(55016003)(7696005)(71200400001)(9686003)(6506007)(26005)(53546011)(54906003)(6636002)(478600001)(83380400001)(186003)(76116006)(66556008)(66476007)(66446008)(66946007)(316002)(64756008)(4326008)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDhRdjJrS2NMQ0c0ZXZOYm1mNjFwNnAwcXl5aXpqcGNrd25ZNmwzbkw0TUtt?=
 =?utf-8?B?N2FWTHZZMW9EODRKWGY3MDIrMmxiOWV1SGU1SDAyRldSNU9ETS9CbUNoNTEy?=
 =?utf-8?B?cWRTL0syUTJkNXVCMUIvVkJZSlFCZ1NKTjlWSlhPdDMycWhKdjB4aVM5eDBI?=
 =?utf-8?B?Z0VJYlB6VjJ5L1RMMFpWZUFYRjBCVCtzMERiTU1aZVphaEpxbU4xYktJUThP?=
 =?utf-8?B?aVRIR2JLRVdBUCt1VUZsZHIyUGRhc3cxUGgrakJJR29GTERyVU9kNXRITzUv?=
 =?utf-8?B?aXR0d1k2allRNHlDQnRUTXpxS3BwZ0tvdktBcGlnbDdJdTJYdGJYemtjenc2?=
 =?utf-8?B?WnBGS2w4ZENETldFUnAxc1JQRlNKdlFzd3ZaSzRlQ3FrYklPTHZGRFIrTFVu?=
 =?utf-8?B?YzhFcHBVb3JIQUMyS3crVUljYVNsYnJmL3RjeU1Kd01PbjlDYWpySmd1TGF1?=
 =?utf-8?B?QVZaZVcrL0xRNEhkeWRQMWJEYXp4OStHUEtqeEtqVGJkTWN5RVRzd1FtZHZr?=
 =?utf-8?B?Vm55R09Ga3U4aWphbzFrTHZnTndHYi9ObTU1U2I3WlVWR24vU1U4WEhTdGlW?=
 =?utf-8?B?aGIwMmkwZ21GQ1NBaEttOFJrRC8rZ25JTFNEOXFwOGRVYXhsZ2ZIYzV0UmxY?=
 =?utf-8?B?S09aanU1UkRnNkdJYndEUU1zdHNtd0R1VldWMW9zMHZyQjU3THVYTTFtSVNQ?=
 =?utf-8?B?NUxHK2FsaExKL1lYWnRqSUhpSzFoMm8xMGszNzVCYzExTnUzK3VjWWg5Nkhx?=
 =?utf-8?B?NkExekdOenRSaWdhZFNzM1BkcGNnYkVRdG5icHJRZjM4LzI3c1lqL3E1VUx2?=
 =?utf-8?B?c2ZGQ21YTHUzR3hxSy8vbEdsRXJqNG5Rb0RrYVo2aVVvcThOck5IVjZpSnBa?=
 =?utf-8?B?SnJWMnNTa2hIb0x1NXhaQXdvUDZ4dW1pdFNlVUFoR2hSSWhlUTFwUDZiNlU2?=
 =?utf-8?B?S25jVTdZTnQ5TzZ1dU1iNk0rS096bDBkUll2bFRQbFhkUisvMHRuRHF0Q0Jy?=
 =?utf-8?B?WjJEa1kxbHlFdWQ2MFd1bFhJOWlBQkpZMVN0Z0pKK2lTY0RuUXFzTXQ5T0Rs?=
 =?utf-8?B?ZVZBOXAwbEM0ZTV2TGV3SWlDNUNiMFhkTzAzVzVKQW1KbEswdzFzVFI0a3dY?=
 =?utf-8?B?cWtPdjYvOVJwZjFTVHcrSm9Xc3VnZHJ4MCtlT0U0UVdyZmRVcmd6dFJZaHo1?=
 =?utf-8?B?Qmd2RmRnUXJqVC8vSVlzRzk0Z0NLNmJRQThnNjkvVk9WK2FqMFpHamdFTHAv?=
 =?utf-8?B?QkpoWFl6WU5nS2c4TUoyMHppZTdQWXhDZTcwbWFCcjNjNGRFRnF2Z2R4TlA3?=
 =?utf-8?B?S3VtYzA3UzVmeC9PZkc0SEhxdDBUakFLRVA0dnpEaVhtM0tJbWZmMDhTNTRx?=
 =?utf-8?B?QVBxOWNYdVZHSDhRajY1WUJBRTh5MmQ3Z3BGRU5YVG9Hb0JuSWpFdVFzMVQ0?=
 =?utf-8?B?LzFHTEY4OExlS0dXU2FBREpxam4wZ3ZGRkUzakN5eXc1MVVrNUZma2V5d2Mw?=
 =?utf-8?B?KzVWalkvMk9CZCthTE9MRnZ2Vks0N1NnNDZFQWtFY1ZLVnZ3ZDBrTjBrYXk4?=
 =?utf-8?B?Zzdlem5MdTE0WUl3UkFORXZZb1Fobm9oMzhHcnNDaDFURkZ1c3VxM2lWRkpr?=
 =?utf-8?B?Wk11ZWVscitHWlZ4ZzJDN3lzeksyTC9WZHV4cURCbG45aG01ZFc4YXBPdXJp?=
 =?utf-8?B?Vyt5ODVWVm1SSkN2TXVkTVRER3FiYnZzdldMczFKem5iUUtiZnNCcjdMT1dr?=
 =?utf-8?B?cDJKOVh6Wlc5R0kyOVhud2syUGF0blhYVVV5SkdRMWFhOWRBbU1SR3daMlJW?=
 =?utf-8?B?Q25Hb00xRXgxQVVzUDlQYWh0VzhPNXpzZE42QyttYVRuRzAyRXcvUS9zS3Bp?=
 =?utf-8?B?MlMxc3NLWWdRSVlMTHNFTnM4L0ZYWUdEU0ZFaE8zRldzdmd0ZG94Y3R2Vmpi?=
 =?utf-8?B?bTNubFFmM3BURDNuT01HTUYzTVQ1NG56WEc0RHE2TTh3Rm9CWUcwaS8rV01u?=
 =?utf-8?B?bzBsWFRSK3JqTTdNSDFjMTFnSFZXNTZKck9DeE1KSTRoWlc5YlBEN2hSMExV?=
 =?utf-8?B?dG1kOFY5R0JsNkIzTzliY1hwTjZtUy94TklBL2VtYlFWYldaRWJTZnZrT3NW?=
 =?utf-8?Q?xz2jDJIwIZ+IGYA/iJXwwOIbj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a063193-4c3b-4e0c-e185-08db418533c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 09:54:15.8208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ESxmHX88fRmnc5BbQ3k2e31j/xdM63TJuONzuBVL9STQN4SG2CvqgVzq0wWjIxP2fWE7qS984uKhsYkx6yceSL5i4z3TdwSIYBOrAZvubA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6747
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciByZXZpZXcgT2xlayENCg0KTW9zdCBvZiB0aGUgY29tbWVudHMgc291bmQgcmVh
c29uYWJsZSB0byBtZSAoYW5kIEkgd2lsbCBpbmNsdWRlIHRoZW0pIHdpdGggc29tZSBleGNlcHRp
b25zLg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwg
QWxla3NhbmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogxZtyb2Rh
LCAxOSBrd2lldG5pYSAyMDIzIDE3OjI0DQo+IFRvOiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVj
aC5kcmV3ZWtAaW50ZWwuY29tPg0KPiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5v
cmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IEVydG1hbiwgRGF2aWQgTSA8ZGF2aWQubS5lcnRt
YW5AaW50ZWwuY29tPjsNCj4gbWljaGFsLnN3aWF0a293c2tpQGxpbnV4LmludGVsLmNvbTsgbWFy
Y2luLnN6eWNpa0BsaW51eC5pbnRlbC5jb207IENobWllbGV3c2tpLCBQYXdlbCA8cGF3ZWwuY2ht
aWVsZXdza2lAaW50ZWwuY29tPjsNCj4gU2FtdWRyYWxhLCBTcmlkaGFyIDxzcmlkaGFyLnNhbXVk
cmFsYUBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDQvMTJdIGlj
ZTogSW1wbGVtZW50IGJhc2ljIGVzd2l0Y2ggYnJpZGdlIHNldHVwDQo+IA0KPiBGcm9tOiBXb2pj
aWVjaCBEcmV3ZWsgPHdvamNpZWNoLmRyZXdla0BpbnRlbC5jb20+DQo+IERhdGU6IE1vbiwgMTcg
QXByIDIwMjMgMTE6MzQ6MDQgKzAyMDANCj4gDQo+ID4gV2l0aCB0aGlzIHBhdGNoLCBpY2UgZHJp
dmVyIGlzIGFibGUgdG8gdHJhY2sgaWYgdGhlIHBvcnQNCj4gPiByZXByZXNlbnRvcnMgb3IgdXBs
aW5rIHBvcnQgd2VyZSBhZGRlZCB0byB0aGUgbGludXggYnJpZGdlIGluDQo+ID4gc3dpdGNoZGV2
IG1vZGUuIExpc3RlbiBmb3IgTkVUREVWX0NIQU5HRVVQUEVSIGV2ZW50cyBpbiBvcmRlciB0bw0K
PiA+IGRldGVjdCB0aGlzLiBpY2VfZXN3X2JyIGRhdGEgc3RydWN0dXJlIHJlZmxlY3RzIHRoZSBs
aW51eCBicmlkZ2UNCj4gPiBhbmQgc3RvcmVzIGFsbCB0aGUgcG9ydHMgb2YgdGhlIGJyaWRnZSAo
aWNlX2Vzd19icl9wb3J0KSBpbg0KPiA+IHhhcnJheSwgaXQncyBjcmVhdGVkIHdoZW4gdGhlIGZp
cnN0IHBvcnQgaXMgYWRkZWQgdG8gdGhlIGJyaWRnZSBhbmQNCj4gPiBmcmVlZCBvbmNlIHRoZSBs
YXN0IHBvcnQgaXMgcmVtb3ZlZC4gTm90ZSB0aGF0IG9ubHkgb25lIGJyaWRnZSBpcw0KPiA+IHN1
cHBvcnRlZCBwZXIgZXN3aXRjaC4NCj4gDQo+IFsuLi5dDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlLmggYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlLmgNCj4gPiBpbmRleCBhYzI5NzEwNzNmZGQuLjViMmFkZTU5MDhlOCAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlLmgNCj4g
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlLmgNCj4gPiBAQCAtNTEx
LDYgKzUxMSw3IEBAIHN0cnVjdCBpY2Vfc3dpdGNoZGV2X2luZm8gew0KPiA+ICAJc3RydWN0IGlj
ZV92c2kgKmNvbnRyb2xfdnNpOw0KPiA+ICAJc3RydWN0IGljZV92c2kgKnVwbGlua192c2k7DQo+
ID4gIAlib29sIGlzX3J1bm5pbmc7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19icl9vZmZsb2FkcyAq
YnJfb2ZmbG9hZHM7DQo+IA0KPiA3LWJ5dGUgaG9sZSBoZXJlIHVuZm9ydHVuYXRlbHkgPVwgQWZ0
ZXIgOjppc19ydW5uaW5nLiBZb3UgY2FuIHBsYWNlDQo+IDo6YnJfb2ZmbG9hZHMgKmJlZm9yZSog
Ojppc19ydW5uaW5nIHRvIGF2b2lkIHRoaXMgKHdlbGwsIHlvdSdsbCBzdGlsbA0KPiBoYXZlIGl0
LCBidXQgYXMgcGFkZGluZyBhdCB0aGUgZW5kIG9mIHRoZSBzdHJ1Y3R1cmUpLg0KPiAuLi5vciBj
aGFuZ2UgOjppc19ydW5uaW5nIHRvICJ1bnNpZ25lZCBsb25nIGZsYWdzIiB0byBub3Qgd2FzdGUg
MSBieXRlDQo+IGZvciAxIGJpdCBhbmQgaGF2ZSA2MyBmcmVlIGZsYWdzIG1vcmUgOkQNCj4gDQo+
ID4gIH07DQo+ID4NCj4gPiAgc3RydWN0IGljZV9hZ2dfbm9kZSB7DQo+IA0KPiBbLi4uXQ0KPiAN
Cj4gPiArc3RhdGljIHN0cnVjdCBpY2VfZXN3X2JyX3BvcnQgKg0KPiA+ICtpY2VfZXN3aXRjaF9i
cl9uZXRkZXZfdG9fcG9ydChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiANCj4gQWxzbyBjb25z
dD8NCj4gDQo+ID4gK3sNCj4gPiArCWlmIChpY2VfaXNfcG9ydF9yZXByX25ldGRldihkZXYpKSB7
DQo+ID4gKwkJc3RydWN0IGljZV9yZXByICpyZXByID0gaWNlX25ldGRldl90b19yZXByKGRldik7
DQo+ID4gKw0KPiA+ICsJCXJldHVybiByZXByLT5icl9wb3J0Ow0KPiA+ICsJfSBlbHNlIGlmIChu
ZXRpZl9pc19pY2UoZGV2KSkgew0KPiA+ICsJCXN0cnVjdCBpY2VfcGYgKnBmID0gaWNlX25ldGRl
dl90b19wZihkZXYpOw0KPiANCj4gQm90aCBAcmVwciBhbmQgQHBmIGNhbiBhbHNvIGJlIGNvbnN0
IDpwDQo+IA0KPiA+ICsNCj4gPiArCQlyZXR1cm4gcGYtPmJyX3BvcnQ7DQo+ID4gKwl9DQo+ID4g
Kw0KPiA+ICsJcmV0dXJuIE5VTEw7DQo+ID4gK30NCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICtzdGF0
aWMgc3RydWN0IGljZV9lc3dfYnJfcG9ydCAqDQo+ID4gK2ljZV9lc3dpdGNoX2JyX3BvcnRfaW5p
dChzdHJ1Y3QgaWNlX2Vzd19iciAqYnJpZGdlKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vz
d19icl9wb3J0ICpicl9wb3J0Ow0KPiA+ICsNCj4gPiArCWJyX3BvcnQgPSBremFsbG9jKHNpemVv
ZigqYnJfcG9ydCksIEdGUF9LRVJORUwpOw0KPiA+ICsJaWYgKCFicl9wb3J0KQ0KPiA+ICsJCXJl
dHVybiBFUlJfUFRSKC1FTk9NRU0pOw0KPiA+ICsNCj4gPiArCWJyX3BvcnQtPmJyaWRnZSA9IGJy
aWRnZTsNCj4gDQo+IFNpbmNlIHlvdSBhbHdheXMgcGFzcyBAYnJpZGdlIGZyb20gdGhlIGNhbGwg
c2l0ZSBlaXRoZXIgd2F5LCBkb2VzIGl0DQo+IG1ha2Ugc2Vuc2UgdG8gZG8gdGhhdCBvciB5b3Ug
Y291bGQganVzdCBhc3NpZ24gLT4gYnJpZGdlIG9uIHRoZSBjYWxsDQo+IHNpdGVzIGFmdGVyIGEg
c3VjY2Vzc2Z1bCBhbGxvY2F0aW9uPw0KDQpJIGNvdWxkIGRvIHRoYXQgYnV0IEkgcHJlZmVyIHRv
IGtlZXAgaXQgdGhpcyB3YXkuDQpXZSBoYXZlIHR3byB0eXBlcyBvZiBwb3J0cyBhbmQgdGhpcyBm
dW5jdGlvbiBpcyBnZW5lcmljLCBJdCBzZXR1cHMNCnRoaW5ncyBjb21tb24gZm9yIGJvdGggdHlw
ZXMsIGluY2x1ZGluZyBicmlkZ2UgcmVmLg0KQXJlIHlvdSBvayB3aXRoIGl0PyANCg0KPiANCj4g
PiArDQo+ID4gKwlyZXR1cm4gYnJfcG9ydDsNCj4gPiArfQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4g
K3N0YXRpYyBpbnQNCj4gPiAraWNlX2Vzd2l0Y2hfYnJfcG9ydF9jaGFuZ2V1cHBlcihzdHJ1Y3Qg
bm90aWZpZXJfYmxvY2sgKm5iLCB2b2lkICpwdHIpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYgPSBuZXRkZXZfbm90aWZpZXJfaW5mb190b19kZXYocHRyKTsNCj4gPiArCXN0
cnVjdCBuZXRkZXZfbm90aWZpZXJfY2hhbmdldXBwZXJfaW5mbyAqaW5mbyA9IHB0cjsNCj4gPiAr
CXN0cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZsb2FkcyA9DQo+ID4gKwkJaWNlX25i
X3RvX2JyX29mZmxvYWRzKG5iLCBuZXRkZXZfbmIpOw0KPiANCj4gTWF5YmUgYXNzaWduIGl0IG91
dHNpZGUgdGhlIGRlY2xhcmF0aW9uIGJsb2NrIHRvIGF2b2lkIGxpbmUgd3JhcD8NCj4gDQo+ID4g
KwlzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2s7DQo+ID4gKwlzdHJ1Y3QgbmV0X2Rldmlj
ZSAqdXBwZXI7DQo+ID4gKw0KPiA+ICsJaWYgKCFpY2VfZXN3aXRjaF9icl9pc19kZXZfdmFsaWQo
ZGV2KSkNCj4gPiArCQlyZXR1cm4gMDsNCj4gPiArDQo+ID4gKwl1cHBlciA9IGluZm8tPnVwcGVy
X2RldjsNCj4gPiArCWlmICghbmV0aWZfaXNfYnJpZGdlX21hc3Rlcih1cHBlcikpDQo+ID4gKwkJ
cmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJZXh0YWNrID0gbmV0ZGV2X25vdGlmaWVyX2luZm9fdG9f
ZXh0YWNrKCZpbmZvLT5pbmZvKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gaW5mby0+bGlua2luZyA/
DQo+ID4gKwkJaWNlX2Vzd2l0Y2hfYnJfcG9ydF9saW5rKGJyX29mZmxvYWRzLCBkZXYsIHVwcGVy
LT5pZmluZGV4LA0KPiA+ICsJCQkJCSBleHRhY2spIDoNCj4gPiArCQlpY2VfZXN3aXRjaF9icl9w
b3J0X3VubGluayhicl9vZmZsb2FkcywgZGV2LCB1cHBlci0+aWZpbmRleCwNCj4gPiArCQkJCQkg
ICBleHRhY2spOw0KPiANCj4gQW5kIGhlcmUgZG8gdGhhdCB2aWEgYGlmIHJldHVybiBlbHNlIHJl
dHVybmAgdG8gYXZvaWQgbXVsdGktbGluZSB0ZXJuYXJ5Pw0KPiANCj4gPiArfQ0KPiA+ICsNCj4g
PiArc3RhdGljIGludA0KPiA+ICtpY2VfZXN3aXRjaF9icl9wb3J0X2V2ZW50KHN0cnVjdCBub3Rp
Zmllcl9ibG9jayAqbmIsDQo+ID4gKwkJCSAgdW5zaWduZWQgbG9uZyBldmVudCwgdm9pZCAqcHRy
KQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2ljZS9pY2VfZXN3aXRjaF9ici5oIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9lc3dpdGNoX2JyLmgNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4
IDAwMDAwMDAwMDAwMC4uNTNlYTI5NTY5YzM2DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZXN3aXRjaF9ici5oDQo+ID4gQEAg
LTAsMCArMSw0MiBAQA0KPiA+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAq
Lw0KPiA+ICsvKiBDb3B5cmlnaHQgKEMpIDIwMjMsIEludGVsIENvcnBvcmF0aW9uLiAqLw0KPiA+
ICsNCj4gPiArI2lmbmRlZiBfSUNFX0VTV0lUQ0hfQlJfSF8NCj4gPiArI2RlZmluZSBfSUNFX0VT
V0lUQ0hfQlJfSF8NCj4gPiArDQo+ID4gK2VudW0gaWNlX2Vzd19icl9wb3J0X3R5cGUgew0KPiA+
ICsJSUNFX0VTV0lUQ0hfQlJfVVBMSU5LX1BPUlQgPSAwLA0KPiA+ICsJSUNFX0VTV0lUQ0hfQlJf
VkZfUkVQUl9QT1JUID0gMSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0cnVjdCBpY2VfZXN3X2Jy
X3BvcnQgew0KPiA+ICsJc3RydWN0IGljZV9lc3dfYnIgKmJyaWRnZTsNCj4gPiArCWVudW0gaWNl
X2Vzd19icl9wb3J0X3R5cGUgdHlwZTsNCj4gDQo+IEFsc28gaG9sZSA6cyBJJ2QgbW92ZSBpdCBv
bmUgbGluZSBiZWxvdy4NCj4gDQo+ID4gKwlzdHJ1Y3QgaWNlX3ZzaSAqdnNpOw0KPiA+ICsJdTE2
IHZzaV9pZHg7DQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdHJ1Y3QgaWNlX2Vzd19iciB7DQo+ID4g
KwlzdHJ1Y3QgaWNlX2Vzd19icl9vZmZsb2FkcyAqYnJfb2ZmbG9hZHM7DQo+ID4gKwlpbnQgaWZp
bmRleDsNCj4gPiArDQo+ID4gKwlzdHJ1Y3QgeGFycmF5IHBvcnRzOw0KPiANCj4gKG5vdCBzdXJl
IGFib3V0IHRoaXMgb25lLCBidXQgcG90ZW50aWFsbHkgdGhlcmUgY2FuIGJlIGEgaG9sZSBiZXR3
ZWVuDQo+ICB0aG9zZSB0d28pDQoNCk1vdmUgaWZpbmRleCBhdCB0aGUgZW5kPw0KDQo+IA0KPiA+
ICt9Ow0KPiA+ICsNCj4gPiArc3RydWN0IGljZV9lc3dfYnJfb2ZmbG9hZHMgew0KPiA+ICsJc3Ry
dWN0IGljZV9wZiAqcGY7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19iciAqYnJpZGdlOw0KPiA+ICsJ
c3RydWN0IG5vdGlmaWVyX2Jsb2NrIG5ldGRldl9uYjsNCj4gPiArfTsNCj4gPiArDQo+ID4gKyNk
ZWZpbmUgaWNlX25iX3RvX2JyX29mZmxvYWRzKG5iLCBuYl9uYW1lKSBcDQo+ID4gKwljb250YWlu
ZXJfb2YobmIsIFwNCj4gPiArCQkgICAgIHN0cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzLCBcDQo+
ID4gKwkJICAgICBuYl9uYW1lKQ0KPiANCj4gSG1tLCB5b3UgdXNlIGl0IG9ubHkgb25jZSBhbmQg
b25seSB3aXRoIGBuZXRkZXZfbmJgIGZpZWxkLiBEbyB5b3UgcGxhbg0KPiB0byBhZGQgbW9yZSBj
YWxsIHNpdGVzIG9mIHRoaXMgbWFjcm8/IE90aGVyd2lzZSB5b3UgY291bGQgZW1iZWQgdGhlDQo+
IHNlY29uZCBhcmd1bWVudCBpbnRvIHRoZSBtYWNybyBpdHNlbGYgKG1lbnRpb25lZCBgbmV0ZGV2
X25iYCkgb3IgZXZlbg0KPiBqdXN0IG9wZW4tY29kZSB0aGUgd2hvbGUgbWFjcm8gaW4gdGhlIHNv
bGUgY2FsbCBzaXRlLg0KDQpJIHRoZSBuZXh0IHBhdGNoIGl0IGlzIHVzZWQgd2l0aCBkaWZmZXJl
bnQgbmJfbmFtZSAoc3dpdGNoZGV2X25iKQ0KDQo+IA0KPiA+ICsNCj4gPiArdm9pZA0KPiA+ICtp
Y2VfZXN3aXRjaF9icl9vZmZsb2Fkc19kZWluaXQoc3RydWN0IGljZV9wZiAqcGYpOw0KPiA+ICtp
bnQNCj4gPiAraWNlX2Vzd2l0Y2hfYnJfb2ZmbG9hZHNfaW5pdChzdHJ1Y3QgaWNlX3BmICpwZik7
DQo+ID4gKw0KPiA+ICsjZW5kaWYgLyogX0lDRV9FU1dJVENIX0JSX0hfICovDQo+IFsuLi5dDQo+
IA0KPiBUaGFua3MsDQo+IE9sZWsNCg==
