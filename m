Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1074B77FD
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbiBOTTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 14:19:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiBOTTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 14:19:00 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70DD109A7C
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 11:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644952729; x=1676488729;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5SIahr5QQ/l079mjfzelAOwTZgYTlo5/7+9Shdm5NbA=;
  b=FcgpFHsHb01FvFI/+aGzdE2C7si/RtpuAF7X3rb9Okbvz/k2S4YsmVx+
   9fw7ZcFcT9P9fX69CXGSI/OlavY/2TgJG8ZnnC0AGTiSXHxTgqO7+EmxS
   QWEmvECoMs5ClyN3UZAHUMsd2ABbQP4XluICQfiQ++yFkhLb+CScJnqPZ
   gl3ZVvDajcXjRcb81sknAv9tfZqOib8L1g7ast7y8w8LqAwBDS57Uzrfm
   AZX2roaCZAW9XTnXjpsD99A92pBfuewn3lmTdW0f7iOrPuu6eBOFBa/zP
   kZuimczFruY7sUrGPg6X85SzqfQP9EZb4zd+bVdaOSELuew7wpUK1YHWS
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250175109"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="250175109"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 11:18:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="624974646"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Feb 2022 11:18:47 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 11:18:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 11:18:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 11:18:46 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 11:18:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftfbUwvTvQ0xK+vwZLhtpuqXNmYXXCM+HRGNOmI6uti0Wx9vYccrp3GoEi9/UAouYgq4AhCRkN1OQPRa+cLfDfhOO7XIZu2j7paFw/w3EOix6C8wzF6nl3weRnX5Q/1yWBPtjgTXifmAuoP9IChemPFUTERA9+kOj9MpUt2l8zMu4QedBHo6bbSuSKtI6Z5w/wxDREClMF/4tI2/fIZI/EaiwAePb8o3vWFjzjN7MV4DsdSMMyAPCdtMcWjYD+mDXrGhUUdWLFG4DXVAUIUvWDmIz9t8ZUPQDAw0AkKny8tV56dkoJftdO0GMaYivCThls5muc6jUlnGL/KwTeWAeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SIahr5QQ/l079mjfzelAOwTZgYTlo5/7+9Shdm5NbA=;
 b=Gh/m0WQCrW8POAaOlsJsuckC/zsTAchPUvn7XOz/RQAukC4nU+13eoWAwhAemGE9JhVU3pc7ldBmTrVL4DTKkoEIrVw4hXcdHX/m5VIoJMGlA406E9ulELeh7Qj4/lIDY3qbAL/HYDMbIk6v1Vsfv5gKAgMXAcYGly0jk2VksYkJsO1vMAxKL0Dz7ND+ot2K9wB1Y247Te2DFL3kXlqDOpNSHlQezEk+vqfUGSne4Ux0qU39OlpVoR2pFAJWW5ZLYvtcPa16wiR9seyaEzM6xGvEw8gmY1KqTFYn1ykoHyQ6JU7UfydY+SHwGXlI0rKQsfuZ3vy4WVft3LRCUPMdpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY4PR1101MB2357.namprd11.prod.outlook.com (2603:10b6:903:bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 19:18:45 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f57d:8a79:f838:ff1f]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f57d:8a79:f838:ff1f%6]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 19:18:44 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>,
        "Mishra, Sudhansu Sekhar" <sudhansu.mishra@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Thread-Topic: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Thread-Index: AQHYIfjMIAqwVc5cC0iQPJ4y7+ObuKyTvxGAgAE+s4A=
Date:   Tue, 15 Feb 2022 19:18:44 +0000
Message-ID: <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
         <20220215001807.GA16337@hoboy.vegasvil.org>
In-Reply-To: <20220215001807.GA16337@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b046130e-abd4-4c96-efe4-08d9f0b7fc17
x-ms-traffictypediagnostic: CY4PR1101MB2357:EE_
x-microsoft-antispam-prvs: <CY4PR1101MB2357E75E0F4FF1000C867E99C6349@CY4PR1101MB2357.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KAppcZQctxsFQFBmBWo9+BaEwcBUbtYlLHad6VqsjsE+cqM2EtfqLGSQWef/8zK5PlZr6YOcT0Ani99/syflD3+aNuX64cX0//6UAl/2rfhtbJFGmhfvD0JHYlAydjd5MIaVC5FfSxxEsaDiQlrAAcu5veQafcjhM4sRVVpszk014hiQlhqQ5+QHnp+ZivyJiqW0+I7uQFid70a2EWb4bO+JHai869P05INIg7/yAledqIrNLSlZHWZqEdLW1c+41lfC08Z2+MWGXWoRjWiliI9kJT9Tp60CCfp1dM+R9D9sMbbCUFC2ZUpot2+RMN1/et/SeOPNPf1e4sr7G2DkNBzoFreypmmMetVGe/pDeSym0jd7P7lYJGuUYBwydSRsf3cf57QsN7Up2o/0pHPw811Q9TuPJxsD7n3WqgFDjBHY1reNQ+QuPcur81sB6g2KveWClo69S4fE4OAf30dtPHnUBuSJS0XH2IcOQYIcN4e5UiZv2lhZQmrDSLWuUbqPw5zTKNUIGWa97y+924smUVzWbyKPzFWAaftmC2Lci5IY+fk80G22UYOw/hEmwTB+h2tlbPS3CcZKzhfHhdp50QqyPZMw7bplp9fA4cK66ngHytAQybTiRhnlOP3Ek6Cqf+wpFwMxIEAg7g1mR00lfHN9g7XOVxU/SXVTQ3ryLJ1OZIZJPZDSkRLjXfNUhG1rMOZH+4t7XM+ysjoTL3vCEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(91956017)(54906003)(36756003)(38100700002)(76116006)(8676002)(4326008)(8936002)(316002)(66946007)(6486002)(66476007)(66556008)(508600001)(82960400001)(38070700005)(66446008)(122000001)(64756008)(71200400001)(2906002)(6506007)(5660300002)(86362001)(6512007)(2616005)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3FOS1FXbmJ2ZTYvcFBrUHJJdGtLSjFJOE53NmdXRmtuKzhrVDhaYjYzdHhj?=
 =?utf-8?B?UFM0d05tT3lQR0wrTC9yV003UzJuY1NiRjVUYWsvQkYrd3pwKzJCOVFxVjgy?=
 =?utf-8?B?WDMyb2dDSkpxc1hMM2U3S2pLeW9uenB2M1Fsd0U3MXJ3ZEJ4L3krYXUwZkty?=
 =?utf-8?B?NlNxSTJwN0RmN2MyeW5YZUxWS2FqR0tXeHJQVFcxSlJmNnpiSU1HUDdVYytQ?=
 =?utf-8?B?UHlPNERzWVVqNHM1cVUzWHRGRGt1NGEwUHNwRkh4MEpwbXlvSCtlV0VjNU1T?=
 =?utf-8?B?VnVlQlI3YVpYMTBOUUw2bGRyNjMyaXJNTEUxbkRWa3p6bktiZGtCRTRTcXZO?=
 =?utf-8?B?djRuQVdjSVl2cytpNGxtTDB3ZHhCQXNodllNcHI4R0JCQjU1MmRCSlYyMWhL?=
 =?utf-8?B?RXZaYUxqKzgzK0lIb3V2MmM1clorUEZCK2tiYTRXdkZDQ1pZY0djV1g0TzB2?=
 =?utf-8?B?S0pCM2VZMDBGWGw3NEVkZDRTTjZKeDVSMTN2QUw0M0lYcWJ3RHBvUzRMWm4z?=
 =?utf-8?B?ZllCQVIzZUlXdXZqVDZyM01lRTVGL3F3bDlIRFkzQU16VVlKVGV2RlRpbzRp?=
 =?utf-8?B?UVBLdEZ2c3M0bFBrN3ljTE1zSEZVaTl6aEVpRk02cnpHU1MwSXRMV2ErME52?=
 =?utf-8?B?NGVSbUlEM2M2SFRadk15WEZiTktTSFZzRDI4UUpORFd2VzJXdnpKZkZYSk1M?=
 =?utf-8?B?S1ZLcDhVZGZ1a042Ym1vL1QzOXNmcXQ5NW9Hak5sWnFvdkhjcUpORkJFMzdP?=
 =?utf-8?B?OWVGK01weS9peW4zYmpONW92OTk2MVlrdG5QY2NlZUtiQkNtaWdhSFhnN2Fp?=
 =?utf-8?B?RWdyUU5jbVpEdzBFb2VVVm12YWNSMmp5YlcxMmNsVDd4eDhYem92d3RDQjBZ?=
 =?utf-8?B?SWdmUGFHS0ZHdU5uMDJPMmdDUTk2K3pOdHNveDNQa1RqUUZSNlh1Slo2SzBV?=
 =?utf-8?B?Vld4NFlqTnJOK1luMHF2Z293L0lSRFF1bTJpdVZZQVBhNXlTZzRNcGRnMkI3?=
 =?utf-8?B?NVo3USt4ekpkS2htejVBVEZCY1MzenRqc081bUdjRlBSU0hDUnBvSmVPUFc0?=
 =?utf-8?B?Yjk5QUtmTEhHakFETThjSXM2NUV0dFhtWjRaQWpLYVVQeEViY3Z0bWtqY3VZ?=
 =?utf-8?B?cGpTM09zOVpsdk56Z00yQTFoWDQzNnpEMXNnSXhTL1VIOEQ4TFIzbmwyQ253?=
 =?utf-8?B?bFBydCtObXN5L0RRZU5OblhUTlZIcWpjOURxSk5sSGNzZUNxVStwc1ljMFVV?=
 =?utf-8?B?RDFqczR1Z0E5ZEE2Ym9NUTB1Umxob0hSQllXU3Y2bHU5eS9XZ1dDR0NuWnRI?=
 =?utf-8?B?NHJYYlZmcUdyZ2NmMXhFdHVzTnRhRHZYdklXdkg5UTZXVHB2V2drWTJ5Znhs?=
 =?utf-8?B?MHFQRWdKcXhlMGVuSkFudUg2VWtVTUI4TER2SzJYUTRZaDU2VjNZYzJ5K2Nx?=
 =?utf-8?B?Tk5idG5sNmI1YU9wRWhVOFFzb1pXR2lTTFU0Z0FvclZNKzVTV3hBZ25GVmVi?=
 =?utf-8?B?Q0FsZll0bjlPOVdXWCtLZWh6eDJkd01QYis0aEppRHJIL1NxRzhFbWYvdGlh?=
 =?utf-8?B?VHlVODFkc1ErT2lEZXdhUWJPSCt4dzBxQy9kWFRDRGRlNkFkaGNHTUxXOUhE?=
 =?utf-8?B?eHNJRXMvbWtpaUovUmV5WkVNVjk5blo3Wkd4cVN3M2RrRzk2NlFlSXdYT2Rr?=
 =?utf-8?B?Znp1TDdoUEVHcnc1QlVnUi95NW5rc0IyOFNwUStsMG5xcDdiakNYK3pxbDJr?=
 =?utf-8?B?Lzl5bElZZmpoazJVN3hpb3VFdE1WTjMwRGJKaFZCZk5NY1hIeHBMVVQ0MWU3?=
 =?utf-8?B?OWxmQWlRQTZwYytXd1Nwd0oyeGxNNEEzV0VTeGRQdmcxczNZeGJwdkFVa1RZ?=
 =?utf-8?B?czhXd1VKYWp4T3ZhU3NCMHM3NmxwejcvTGpLMTR6U2U1RXlKWHIrS0l2b0s5?=
 =?utf-8?B?WTJCbzdoQVBnNFJlUDdjcjhrRkJuNmJuZnFCaTRva01JcWFISm5LcHFrclkv?=
 =?utf-8?B?ZnlvcGZ1RnVGMG03NTVHVFFsZS83aCtNbkhXa2Z4cUFWY1o2aUR0ZzBPbWZN?=
 =?utf-8?B?NkpudjlHVUFOSWN0cVpjcXNxK0ZQdHNaQktEcWtpRlZ3ejB1eEZ4Um82eGtP?=
 =?utf-8?B?Q0lCbGRZRDF3bXlOeksraHNmcGFHRGtJOXM4OHp6S1RhcCtBMGtVMUVsdjJw?=
 =?utf-8?B?L1pYL0tMMzVZNTltUUJWTGcyNFpqTDhZckYxVFErdm1tdm4yV3BrZDRtK1o3?=
 =?utf-8?Q?6W6k7YLjWjCPfiTr9lQPkLPo6pXzyx7Z5yOUr2rNxg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEEBF4D512CC8B47B0425E3EF9B2AE87@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b046130e-abd4-4c96-efe4-08d9f0b7fc17
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 19:18:44.7338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWXHFHDAPxqa3n5B1VJiQugFreX1cpOchFDtxeX70ppaln6707rw58JRCi0rECl6THxr/JtM1uTbOxLvXXPxYTZ+6UmWZqcCWijBaVzO0fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2357
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KT24gTW9uLCAyMDIyLTAyLTE0IGF0IDE2OjE4IC0wODAwLCBSaWNoYXJk
IENvY2hyYW4gd3JvdGU6DQo+IE9uIE1vbiwgRmViIDE0LCAyMDIyIGF0IDAzOjE1OjM2UE0gLTA4
MDAsIFRvbnkgTmd1eWVuIHdyb3RlOg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9hZG1pbnFfY21kLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ludGVsL2ljZS9pY2VfYWRtaW5xX2NtZC5oDQo+ID4gaW5kZXggZmQ4ZWU1YjdmNTk2
Li5hMjNhOWVhMTA3NTEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWNlL2ljZV9hZG1pbnFfY21kLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pY2UvaWNlX2FkbWlucV9jbWQuaA0KPiA+IEBAIC0xNDAxLDYgKzE0MDEsMjQgQEAgc3Ry
dWN0IGljZV9hcWNfZ2V0X2xpbmtfdG9wbyB7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoHU4IHJzdmRb
OV07DQo+ID4gwqB9Ow0KPiA+IMKgDQo+ID4gKy8qIFJlYWQgSTJDIChkaXJlY3QsIDB4MDZFMikg
Ki8NCj4gPiArc3RydWN0IGljZV9hcWNfaTJjIHsNCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
aWNlX2FxY19saW5rX3RvcG9fYWRkciB0b3BvX2FkZHI7DQo+ID4gK8KgwqDCoMKgwqDCoMKgX19s
ZTE2IGkyY19hZGRyOw0KPiA+ICvCoMKgwqDCoMKgwqDCoHU4IGkyY19wYXJhbXM7DQo+ID4gKyNk
ZWZpbmUgSUNFX0FRQ19JMkNfREFUQV9TSVpFX1PCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoDANCj4gPiArI2RlZmluZSBJQ0VfQVFDX0kyQ19EQVRBX1NJWkVfTcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgKDB4RiA8PA0KPiA+IElDRV9BUUNfSTJDX0RBVEFfU0laRV9TKQ0K
PiA+ICsjZGVmaW5lIElDRV9BUUNfSTJDX1VTRV9SRVBFQVRFRF9TVEFSVMKgQklUKDcpDQo+IA0K
PiBOaXQ6wqAgI2RlZmluZSBiZWxvbmdzIGF0IHRvcCBvZiBmaWxlLCBvciBhdCBsZWFzdCBvdXRz
aWRlIG9mDQo+IHN0cnVjdHVyZSBkZWZpbml0aW9uLg0KDQpUaGVzZSBhcmUgdGhlIGJpdHMgdGhh
dCBkaXJlY3RseSByZWxhdGUgdG8gdGhlIGZpZWxkcyBmb3IgdGhlIEhXLVNXDQpzdHJ1Y3R1cmVz
LiBJdCdzIG1vcmUgcmVhZGFibGUgYW5kIGVhc2llciB0byBjb3JyZWxhdGUgYnkga2VlcGluZyB0
aGVzZQ0KZGVmaW5lcyBuZXh0IHRvIHRoZSBmaWVsZHMgdGhleSByZWxhdGUgdG8uDQoNClRoYW5r
cywNClRvbnkNCj4gDQoNCj4gPiArwqDCoMKgwqDCoMKgwqB1OCByc3ZkOw0KPiA+ICvCoMKgwqDC
oMKgwqDCoF9fbGUxNiBpMmNfYnVzX2FkZHI7DQo+ID4gK8KgwqDCoMKgwqDCoMKgdTggcnN2ZDJb
NF07DQo+ID4gK307DQo+IA0KPiBUaGFua3MsDQo+IFJpY2hhcmQNCg0K
