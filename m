Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25064C33B1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiBXR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiBXR0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:26:49 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E4E278CA7
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645723579; x=1677259579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EJj5KiChttH/8qeqat2YysjNo/kqUAhHYDXL21IVgXE=;
  b=fIX0qgNbAWQRp48X2Y6lS6+YFAbu0kP8t+PvewG9mUnqPr0uBoEmDqVK
   EEMkxI4V0Hm5qSDOxAO9LeKjuTDOzn80Oh2KnYXbft/tyanbOcKMayrUn
   SEjp+ojPKiaTn908gajAZRaxOQbHCKdHRJiS8iQGFJ+t52RKcNZ1cFV/I
   v/6Cn5SyV8UhF1E04ceXktw3BQegiOLgn3kxAY3dcSDtB1DAPKvvXXcWz
   FV40YiYPRMM8Qc/jzfJpTB4dWzkwOvPp0cdIPSZxbTm8rCpzFhxWAaTWK
   xjbhjLKeZasitC8XHJ/VUXRzmlExkgbULne1192NPRyLaTMEOSjzkqqdx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="276923501"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="276923501"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 09:26:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="548846419"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 24 Feb 2022 09:26:18 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 09:26:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 24 Feb 2022 09:26:18 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 24 Feb 2022 09:26:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=add4PduO7eSOqFqj3xaiFoFqzUen+lUA/mqeQzftIF0GoOcilHdqmpmM4xEMPKiVbXbdo4M6mpjKtIl+q8+SjSGklTbAwDqfFSjlGIjogCp1MBwJVZiP1qWK1ZouyDXKH2mpmScwdbWwYlrjZ0XG/C0w2gDB94aSm1oHdoFzeqa9Xuke9OOPjMA09bNJmkZlT6axd020VVVXW8TfdKhh+XX0ioioRe3TGVi2ALTuz+kpY7e5zNC6NU0tNMBDdNh1cNl1D5Vf7PiRyZ178v5PaZV2LoLgxGek1BjFaEIadtjWhqeWLaaprEvPPmhsyriAwzdwKdkhyW33nuBqBUK9VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJj5KiChttH/8qeqat2YysjNo/kqUAhHYDXL21IVgXE=;
 b=fJ7knC5sRKyLwL5jnSuRZgTb8bpV1ZspytYqrTihjX5sT1MWbstvqdO5h3MbkaZHBMc4KIouR2ahpP61sgdUanvJB2GWwaSHCqpHchNNwxwEQoUkCsImbDYKKQ34uyt2HY5N+lYWNmu/FybYxojjKOvq1U7C/DmOTURYbjRq4iSh5zU1pgVTebdsx1ekShdYf7TW+d+1649ORIT0GCZjXXOkkyBy+xEBookdMVfYItnBQIxbablFfOAqeO44prbhM58Ndg5A1+l0+RHELt/DuN4JmKd5WGALzdaeXxC4ecboclYFodVl8KOtfCkprdzla5X9nqPERn3UHlpwn95CEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN9PR11MB5307.namprd11.prod.outlook.com (2603:10b6:408:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 17:26:16 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d484:c3ff:3689:fe81%6]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 17:26:16 +0000
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
Thread-Index: AQHYIfjMIAqwVc5cC0iQPJ4y7+ObuKyTvxGAgAE+s4CADJM9gIAAFWaAgAFc9YA=
Date:   Thu, 24 Feb 2022 17:26:15 +0000
Message-ID: <2da98bc3f97ef42dc6a054acc74894cd25031cd6.camel@intel.com>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
         <20220215001807.GA16337@hoboy.vegasvil.org>
         <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
         <19a3969bec1921a5fde175299ebc9dd41bef2e83.camel@intel.com>
         <20220223203729.GA22419@hoboy.vegasvil.org>
In-Reply-To: <20220223203729.GA22419@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68fc27d5-1fe8-4c59-0b36-08d9f7bac32f
x-ms-traffictypediagnostic: BN9PR11MB5307:EE_
x-microsoft-antispam-prvs: <BN9PR11MB530724AEC81B4363574F5AACC63D9@BN9PR11MB5307.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tYLNg6dyvLZHOE2tCK5ShuMnGy/GrYrQtPlLD8zNCdi0WC0hxHo1Fx4BP+HsihjuACsNm3IOgzssqEyJ4G7TAVPhTpkRcl5Gvwx/NW0qbkeaOSbs/w1ikz1qHrROVcoVAoq6t/4m0x7x2kw3cY+a5CiLcaQ2bMT66RlTIIBw3XxZvsyt200KShYgiYzVMbNKLxT+PFudoqveg1toULn7S+iVKkROPrk5xurOosu3H3QBdfzqsty05yLT/1ns+xLmZjeC2N0ztvlzrEKxOIufubW3/4P54qHIZ1uL5rTW1AdT69oFeLhrEQCE0KT6T7yJsoOB1Fh8wfQIEPNh5ZoR2zaK7eP1jI/HCUnk1IcmXWopVi+VPcriRMWeJbv9J4181/Wz9xGt/Y7WuRbKWgcF4+rrIOEWrl7dqZkQQ4ewARdczMtGQctx9g4J0G66ZSGY8aDvayt11czkzha1PGtwswdaro45Q9XDn5/D/EPHGCCQGuIFeGf8uXNL4VDtA06OMpEfwx4WymF1R9EYBD/JHDkQgJRMd+KzdlknyUcd0tsSsnq3+0g3YQl91Cj2TSmcRE671++kLAWMTnovRmyNlciXVzt+PIWmZhRQRS8WCHsu+bPKlSrlKQMKFevd+04cegELyEsJpr9bh8B/0M9FaB3zjVGwCkmoXw7PmGngeRDzjKrLXo5GF5AnhQCIQbfkd4rOaR/OMB9T+z45jCE8+b6iQJ5z5MhMSBsBGrIcNcLED0mAkFDf4ZdoXLRyhP3L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(83380400001)(122000001)(86362001)(82960400001)(38100700002)(8936002)(36756003)(38070700005)(4744005)(91956017)(66446008)(76116006)(66556008)(26005)(66476007)(4326008)(64756008)(6506007)(6916009)(66946007)(316002)(186003)(6512007)(54906003)(2616005)(71200400001)(5660300002)(8676002)(508600001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wm9QbDh4NkE2OWk4c2JvUnBXQ295WHlFUVlhY3NyNXhsMHJ0ZHpwamhMdGVj?=
 =?utf-8?B?NTQ3S2h2UVA2KzErd29Uck8wSkN0ZHBMVGliWGdOTkYwLzVaQmtTQnRwNVVy?=
 =?utf-8?B?d0xuZUFnVmdkVmxpRVNiOXNmQUd1RTEzMVZld1d2RFpHZERnR3VDdkszTEI1?=
 =?utf-8?B?ZFhacUtZeXJFSmphelVUUVd5L2RWRWJ3LzFNQ3FoVkcyZVNWWWdyUjg2TitI?=
 =?utf-8?B?SktYVm1aZFd1Ym5IWm1zQ1NZYWFieGVNMm12Y1IrM0VpVm8vOEk3UGdILyt5?=
 =?utf-8?B?dGZVZ2ppVmZJeWRlSEdLcWJuMjFIVmJmK2Foc2lINUlvWDZMNVBqUFBMcUti?=
 =?utf-8?B?K3Q2c2xyTVd6dnkrcFVWNFQwcElPSlN1TGxiRk5xWDRmU2NLbzNtWW02R21T?=
 =?utf-8?B?bnFRd0NUK3JyeUlISlVtbGdmbnFvZHFzSlBiTkRrajY4VGV1QnFVMWZ1RFdn?=
 =?utf-8?B?OXFXVlFqNGNaNlE4NjRNZzR2Y2Rpa1RRN1FlWS9aVnBKeXRRMVRaS1NlTHc3?=
 =?utf-8?B?by9Va3RGczFlNFB6ZnlVUzh2N2JCSVZ3QXZtYkdWYUR2RHl4VU9FeXIzY1Uw?=
 =?utf-8?B?MzdMempJdjlsMlUzNXRIdk9nVXhaNE5HUXNNMFFQSUJvcDYyeWNKYmVpMXBC?=
 =?utf-8?B?RmNRODFNSnlodVJ1OGFkemw3SThnejgxN0V2UUt6UkppcG00SXkxb1V1cTNq?=
 =?utf-8?B?MThKSmhNNGtLcXJSOGhuNWJubWVMd0RrNDAwd3RTMjZ1bnVjekIzS01xMUcw?=
 =?utf-8?B?dHJFdllXekZ5UFBLZjBrTXNqd0JmanZmdENNaEtLUTJNaGovU2IvK3RqeEM4?=
 =?utf-8?B?RGdGQXZUK0pHdDV5RFV4Y0NPdVNJM1ArWXRWOThSU3I1eHdqTHpQM0pWbGtv?=
 =?utf-8?B?dG1RejBSOW5kbE5sWEs5NzhhTjBEcHk5WTFCWXc4OVpscVNSL0pkVTVhREJM?=
 =?utf-8?B?WGdHTlNPazNGTXlyS1A1ZTF4SUZBUzBKaUhoVkNkNndVZXZ6bVdLczZidnFx?=
 =?utf-8?B?bHNCeU5hRTNiaUNMQWxCeUFoVkRaMFRPektydGpyNVhNUGtkd3lLNmRBd25T?=
 =?utf-8?B?YzQ5c3hsZWVTNW1aeTE1cGViUjk1L3ltK3RJNFkrSVN2UWVoL21McHFXVzRy?=
 =?utf-8?B?MlJ1clczMmtaM0xiSThtbFYrbHhtU0c3UlJWYzkwR2V6MXdZVUNVZ0tVZW5Y?=
 =?utf-8?B?YUNSUW1iN2pKc0doZklnV1R1dVdENTJ4RDgxbmNzSXI2K0VsTkhtY1puYmp4?=
 =?utf-8?B?d0dnQUN1L0tLeGxuc0FYMVBLalRJbGhleEh2VjJyV0lpN2J1d2c0RkN2clpR?=
 =?utf-8?B?REtHSHFaeThGdWNxVU10V0RUTTlkWm04a3h6YVI1SE0rME1CT09KaVRob0k4?=
 =?utf-8?B?c3NvRkJRNVdWU2RSb0RnbGM2WDBrN3ZVSHVOdjFXY3dQTTVoTitVOFFjNnYr?=
 =?utf-8?B?NTFPcG5iaWQ2SXozc21WLzlCeGdoZEpTb0dRZGlYMmRyQnp4b09Ed2J6NnBz?=
 =?utf-8?B?dDVqMWpiSzNTOUF5SzFCMWQ4U2ozZmxOZy9HaE1SY0dhSUszSFNXa2JqbGRt?=
 =?utf-8?B?NGNTNE9uWlV6MWVYdkxzeUVtRlJKQTN0L1N3SnhuS2hCOXJ0NjZXbFdOS1Z0?=
 =?utf-8?B?TDh3OGljZ1Bndm5rL21najZYL3pkSzYvOGtvV2thMGUxcFk0RmhWdzQ4dmNs?=
 =?utf-8?B?RWRYUjh4SERsUGZrNktJbDFFQlR2MTE5S2xaM3FLaVhzT3lSZjAwUitTQmIx?=
 =?utf-8?B?QWlPT00rNXh4L0QzUWVTZFdWQW0wYlpzRkdUaVQ5MmxuN3Z0aG94ZTdReTk3?=
 =?utf-8?B?MS9sNU1XalhkdjR0dnFQSnE2MkFwYzQ5QTEyWFRkOFhoK3Z4TmVFVHViM2Z6?=
 =?utf-8?B?ZURIa0pWWUpLWmtXaFZYQVhqbFB3Y1pmTTdmc0FEWjlTVFZwRkJId1lFbFRi?=
 =?utf-8?B?RUsxb1Q0b3lGVHg4OStKamlGV1JjdllVU1JDLy9uMVVIaUtVQ0F4MG45OVcw?=
 =?utf-8?B?TGhTT1BRb3NFYVlsUkRycWxRQmp5L1JCZ1hFOHlRbGErb1NPVTJyMTVGYktV?=
 =?utf-8?B?SGJ2ZGRuaFphUHY0Q0xiV3kwSHZFbkV0ZW4vL3grRU5BamdXdnhiVzhoRVEy?=
 =?utf-8?B?dUJmdlhJbEszWDdqaXc2c2IrOEJJS3R6UTRpRXFnWnQrZWdQaUZ0YlZNemtp?=
 =?utf-8?B?WUhWcUV2cDRDYlhzT09VUUJ5UGpNRmJPbmNTQ3pWTUZtU1J2V3lWM0JuMmtZ?=
 =?utf-8?Q?Gfq0LgBKtrEc6c+Eu9qUvxHKS7WDVzbG2enc/jN0k4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B548E0BCA5397D46AFB018598408AE96@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68fc27d5-1fe8-4c59-0b36-08d9f7bac32f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2022 17:26:15.9472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s8YMemRn+O4k3laCLH87bw/TVuz3HT+oiDF6JHXEQIXUZTbuEJER0m+woANyV/z6KZB6bQkOX2r1BJJRETPqV9dn6QdvgkhKjEcv395+lH4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5307
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAyLTIzIGF0IDEyOjM3IC0wODAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6
DQo+IE9uIFdlZCwgRmViIDIzLCAyMDIyIGF0IDA3OjIwOjQzUE0gKzAwMDAsIE5ndXllbiwgQW50
aG9ueSBMIHdyb3RlOg0KPiANCj4gPiBJIGhhdmVuJ3QgaGVhcmQgYW55dGhpbmcgYmFjay4gQXJl
IHdlIG9rIHdpdGggdGhpcyBjb252ZW50aW9uPyBKdXN0DQo+ID4gdG8NCj4gPiBhZGQgdGhpcyB1
c2FnZSBpcyBmYWlybHkgc3RhbmRhcmQgZm9yIG91ciBkcml2ZXIgc3RydWN0dXJlcw0KPiA+IGVz
cGVjaWFsbHkNCj4gPiBpbiB0aGlzIGljZV9hZG1pbnEuaCBmaWxlLg0KPiANCj4gSSB3b3VsZCBw
dXQgdGhlICNkZWZpbmVzIGp1c3QgYWJvdmUgdGhlIHN0cnVjdCwgYnV0IG1heWJlIHRoYXQgaXMN
Cj4gbW9yZQ0KPiBvZiBhIHBlcnNvbmFsIHByZWZlcmVuY2Ugb2YgbWluZS7CoCBJIGRvbid0IHRo
aW5rIHRoZXJlIGlzIGEgdHJlZSB3aWRlDQo+IENvZGluZ1N0eWxlIHJ1bGUgYWJvdXQgdGhpcy4N
Cg0KVGhhbmtzIFJpY2hhcmQuIFNpbmNlIHRoZXJlJ3MgYWxyZWFkeSB0aGlzIGN1cnJlbnQgc3R5
bGUsIEknZCBsaWtlIHRvDQprZWVwIGV2ZXJ5dGhpbmcgY29uc2lzdGVudC4NCg0KRGF2ZSwgSmFr
dWIsDQoNCklmIHlvdSdyZSBva2F5IHdpdGggdGhpcywgaXQgbG9va3MgbGlrZSB0aGlzIHBhdGNo
IHN0aWxsIGFwcGxpZXMNCmNsZWFubHkuIFdvdWxkIHlvdSBsaWtlIG1lIHRvIHJlc2VuZCBpdCBv
ciBkaWQgeW91IHdhbnQgdG8gdXNlIHRoaXMNCm9uZT8NCg0KVGhhbmtzLA0KVG9ueQ0K
