Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D524C1C17
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 20:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244354AbiBWTVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 14:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiBWTVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 14:21:14 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BDB45AEF
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 11:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645644046; x=1677180046;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9y1EBlJdh4azxtkZ8afCmGVRLNlQzMk40yrOUe5yMc4=;
  b=jd4p9inA8EzQe87GyNZnNGOFsEYQBgBED0s4LUiUCDSAoGzy1iOOVIlu
   gvHIYQd6E1exzdTDkmd2RoomzoE4KXf5QGBiprSa3+fB+Db9Rs+B0dRXb
   /oRKZzl/qUWLKPWsZKJjyTQQzwZjm0ddHoKZAFbcpCWXhhwEbDrCBvi1j
   4LcyfgYgseTv8OM883882IP2KBDtgamz3kzqbbl66tqQ41vaCjb+GHYjr
   PGmcvZt65qhF13WHYMueGqwJQfwsMC00qLaHtESpVYFSVoEwmaqEPYQHJ
   XbxCIhUT64/Ji2/gs2ZtIrVwH/bJjmJYafs+9ETewBpD1QqTuJ80VurYO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="250889734"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="250889734"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 11:20:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="532815874"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 23 Feb 2022 11:20:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Feb 2022 11:20:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 23 Feb 2022 11:20:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 23 Feb 2022 11:20:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGmBf01sU5HcIRp+0AwLXJBqYCn+yMfYSGh1Iimsumi8b9FBK5f/YUzhjR3hZmg0wRf2LNK7eBWQrjPwW6F0Xl6ZJSdE8NwVOr1bCUfFxUALElX5wO6Y9Tu0kHxk6pPvztZUU4nczOP5kgNv0jpcXTAyDsRYAKKYzKxnLSt1Z193MletfZtOezof1Uv7a/AKlZakJmJr+GYCaypMRmOLbWD9+TCxQvYEc/Q+ltYxRUXuVCwY1yoMFr+sd9PNdJ43hQ1YKM09Ql7kLpkPCXMS634HKHdFg4w5pBIasD78csmgJFfTJmoJkmaCwMouIiM8mT16FCnROyp/TQOOamR3PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9y1EBlJdh4azxtkZ8afCmGVRLNlQzMk40yrOUe5yMc4=;
 b=bKCv2TYEGQhjbFudq4h0CAmRRCASjt5ka+tw/WuoI4Y18lHjGW7adjzqLlx2ChtFo9i8v8PonjvRoAMm42+jz+IVmsRdrRjY+HfNq6Bx6yKA42vGUM0//tFL/w/UjsUjeGi2n/wLp4nwyZ3iurkPFhbuaTtRBrJO/oiQZfK9kqcDyV3zgtVhAzlVgNVaTaW1dT7FGyXxm7sog78uhnZ2rDqJJALUL/yEEgpJlLRV2fRdbosQAoQEXLZifRvi5VbH50RYZ4UtkmHyrNAZQcSKic3Hpxw1cCzG/Aye7aSEAbDB61WbILvqhlAYoMPIcGCdOGhuL8N1GKXcP+te4CD76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DM6PR11MB2588.namprd11.prod.outlook.com (2603:10b6:5:c6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 23 Feb
 2022 19:20:43 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f57d:8a79:f838:ff1f]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::f57d:8a79:f838:ff1f%6]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 19:20:43 +0000
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
Thread-Index: AQHYIfjMIAqwVc5cC0iQPJ4y7+ObuKyTvxGAgAE+s4CADJM9gA==
Date:   Wed, 23 Feb 2022 19:20:43 +0000
Message-ID: <19a3969bec1921a5fde175299ebc9dd41bef2e83.camel@intel.com>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
         <20220215001807.GA16337@hoboy.vegasvil.org>
         <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
In-Reply-To: <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1e52a4f-a54d-4c94-83a6-08d9f701964a
x-ms-traffictypediagnostic: DM6PR11MB2588:EE_
x-microsoft-antispam-prvs: <DM6PR11MB2588C9C3FAC1FFFFAE993950C63C9@DM6PR11MB2588.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gopIw8fzDXh6M/898dhIW/Nj2ZzWy004BGzts2w47odWbOFiiKiFZfNrg4re8HjXoC1NasGUdRrmMQ4ZiZlVrqPqtOWfnQ6gj9nplrqxv5aMnarOuvOZvXP0lJjI/LSUjdjc6mjg4NBK6QDUH8wsqOwVevhhxxZoHTty4xI/kh0hOkrBUWuD4BEt9Q558mnzl/vUeTcP0Hy3bW8MmInCuGDMJ+PlWQ05BqoczQ84xtbWSVzdeLft24bv8J8U41+/WNT/JcayyHPU1b07Vz2Tuu4LJrly9zZoaTgM1oAIWfWDDOi9Un6EaNDpU/jDyiFYHg/prEZwjxLtDrz/fRZFPF4NQjcf/VRcsXi5GToPPokmi/5fn6h/L0FssjOpYjMmWYHbF8ViSfLHJcL/zE8ogBQ7ezFsRb6LK49zJwhIqnrFMri0MTTRClsIvOheLEJXID4G1CljR4m/ORkOPBrZdDSZyoLLi/Odv2uDMXXqaad9PbqQDDCDJWEruvVuvguzbUNh+oDLRWl+Y1GWFWqi8JOoCiPZ1R0eo0UWaCVjUkWtY+QZO6xrYiC9+cA+AeM/k5eS6/6z/RiK5YKCvPrQLHXse+cwdrYGnUqlY5FWjTuJ5Qn1hFqEFCvci7Hy/eTTUDC19rEaaW7gyP6GF4YSEU2jCOVVBni6X3P4vTWAiNBrgxWVrV2Z2oKxaLH0RafZz6bPExLpsFGPMqnVsQuGRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(316002)(36756003)(71200400001)(8676002)(76116006)(66946007)(5660300002)(4326008)(26005)(6486002)(91956017)(83380400001)(64756008)(66556008)(6506007)(6512007)(66476007)(2616005)(66446008)(8936002)(186003)(38100700002)(2906002)(82960400001)(122000001)(54906003)(6916009)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXZNOGxlUUh1VGZTV2pyWFN0QzI0aVBRbVdRNEF4OEdWYzhXcDJhNFhDQlI2?=
 =?utf-8?B?Rjl2OCtwQjNlT25VRGNhUXBtTURKN3JTYW5hSU1Mb3JieDJPRS9FNHVMR2k0?=
 =?utf-8?B?dCsza0owTkRuWW9yQkdhbDMvTU85NXN3MEU5bVQvWm1CNTkyaXVzSTVha0U4?=
 =?utf-8?B?a0F2OEhHUlE0UWJ2aTZ6MFVacWFab05JaXFuQVFHZVI4K1Q3RnY1bW85dkxH?=
 =?utf-8?B?bHgzMmlJRzl6SERUbW84cGRnVWVtcEd0UmswMnNETXFZcVJURWUzcGV5YTF3?=
 =?utf-8?B?UzQrbk1pZVJNSUx4eW96WDZmd1hPeWJKamRpeG5pZzBSN2xHQ3dwSUtnYzRQ?=
 =?utf-8?B?RjZORk1FV3JCaDV3bXNHN1Y3QkZqNXF4REFRZDJ1c2VWV2Y2WlZQUGR0UG91?=
 =?utf-8?B?ck9XdFpCZ2I3UWFyTzQyNGV2ZXBVck85aUhaNWVVSnk1K3p4MzhIa09SR0Nx?=
 =?utf-8?B?K3dIbUxBUUo3dDlOQzkxbWpRcUJsZGZlQi96K0l2d2tXME5SbVM2bzZMTW1y?=
 =?utf-8?B?WFRsN2NsV0VzblNZejQrTE1zUGxXdzRTbEU3YkkxWmcyOEtHYmZDWTlMYUlz?=
 =?utf-8?B?QjNJRFNvaE9mK3lncmg3bEhDVjJsSVk4OVlOZEY2MzViNi90U2xGMG9jODc1?=
 =?utf-8?B?RDVmdW1GKzdXOEJTRmJMRkpqOGJzRENxRzJtR3kxdFBGM3ZRWXg0Y0FieEtt?=
 =?utf-8?B?T1pqV3dyN2NKRVN5ZjUzWk5wZE5MdmFoR25ObUpId2pVcDdOYm9XbmYxNGFO?=
 =?utf-8?B?RHBKc1RPOThLVHliQnpiSG9XUlV0Tlc1WkFETUFKTzl2YVE5RTF3WGk4eHIw?=
 =?utf-8?B?OHlQTGE3ZGRySWRuZVpMUDNZblhramcyQUxCVVI2cjdaMFRTYk5IOWtCbnlK?=
 =?utf-8?B?SlJVQVd1WEh3SkUyZFI3TEdocnVUR1RMM253d1hLeElGZWdUb3ZpdFVjcHhO?=
 =?utf-8?B?K1RDKzhrdm94MUFkbUZvYkdWMmhXU0NqS3N0R29LTEVxN0dGd0JGa2JJTkVF?=
 =?utf-8?B?M09QdUhTbnlKZWNydEM1M2JURzJ0M2Y5dlFtVnh3NVQwcEdJY3AwZFpkbTQy?=
 =?utf-8?B?ZzNMQ1o3M011TmdPckUwMjE5b0psMDU5cnBrb1JxYmhWaFJBRTNJWUpwYnVP?=
 =?utf-8?B?TTBEVzgyLytxaGNTMElIQitUQkUvMmxld1VWby9RYUU1UGtRbUwzYW5MWjJz?=
 =?utf-8?B?RHM3Y1VTOG16MktuMUp5eFZvMVYzdFRJN0NRbTBjekZ6aUY3Q2w4VW9VMEZ5?=
 =?utf-8?B?YW9UUk9OOWp0RUs5eWF3N1dsQkR6RU5pSmlmbDVueEMrSXlZWUpaRHVJSHZS?=
 =?utf-8?B?M3dFMCtHM1ZpdUlzRnNCMlMvWVlYNFBhaWtHcFh3SHNsVE1tUnhPVkFTaEs2?=
 =?utf-8?B?UURCcktHUHdVSEpjRWthYlY4VEE3bStWdDR4WXQ4RisyR2NZRmVvRUhhcFRq?=
 =?utf-8?B?WE05S25iVURlRk5LMXRCSjFmSE5JQ0JhQ3JZQ0FIclhqS2twT0RNcitpWHpS?=
 =?utf-8?B?V1FsbDBTeXorSk9xNWh2czNDUnhzU0R2WHJrRlZKN2FOb0pmazFOaXJYZ0Z5?=
 =?utf-8?B?SXkxWXlRcEhERDhYM2lveTJscC82dFdzQjJiWjhPOWM0cklLNWlUYXJvQjE4?=
 =?utf-8?B?Q0xOVWZtaDNMa2ZBdEVqWVR2dnVNKzRiMmxEbjZGbG5BVGxrVVNUbFEyREtp?=
 =?utf-8?B?QkU1ZmdGY2dCNzQ5aVBXME9hL1Y0Sm1aRFRtRTRORXA4QlhaOE5YTWlJWkdw?=
 =?utf-8?B?VURKU0hpejBBMmNKWElPVXRvakF5eE5abTNXRnAxOWtrd3VMYTF3SWZZMEF2?=
 =?utf-8?B?TVl2N1FvdEFXWU9NZHphdEUyMk5PWCtzTlREV201NUw0VWgwVDJkMDFvdVVa?=
 =?utf-8?B?TmlIcTZCRDU2MVh1Y3NrR3NLakNvWlYrVmVkRkNIc3pyc2ZzMXlJR0pLVlpP?=
 =?utf-8?B?R2lTRE81bVVLK1c2UVNpYXY2cHNOUGtYMC9lNng4bUJlU0trWmxJUUFnRC9N?=
 =?utf-8?B?UW50TmVyaXN1UzUwMmtwY0MyRWl5THhvbWlqWVRUeWVCTU5RYVdsaUdEdXlu?=
 =?utf-8?B?UGJsUUFJbVliSVY0M056cUg3S3UwaFRpOEhWZW8zd2RrTEZGakFvaDRrOUFT?=
 =?utf-8?B?TjZBWXlEY0FqdGlwbjIreHpEUzlBR0lJSDBCZFYrU3hsdlVpckpLZC9HRzlT?=
 =?utf-8?B?YnZvdTR2NkdqckMwZU5YaTY1eDBvNE5JVFgrTnJjbHFwcGxNZEdlRWIrM1dl?=
 =?utf-8?Q?gpOdnfqOzy/DEPFEAN4gEx3u6tPlGooOMobgeXf0h4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CC0A96476F4A24C92A1648EE770D57A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e52a4f-a54d-4c94-83a6-08d9f701964a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 19:20:43.7504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VVf+PVoiKiKtRwPKIAml2PFFq+vs+4NUQiqPtcumTYt+d0YrPItFi0h3S11SCoKWhbdywqJfPAFPjXiValBY4a+1I2eLaxBcFJfn41BUE9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2588
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

SGkgRGF2ZSwgSmFrdWIsIFJpY2hhcmQsDQoNCk9uIFR1ZSwgMjAyMi0wMi0xNSBhdCAxMToxOCAt
MDgwMCwgVG9ueSBOZ3V5ZW4gd3JvdGU6DQo+IEhpIFJpY2hhcmQsDQo+IA0KPiBPbiBNb24sIDIw
MjItMDItMTQgYXQgMTY6MTggLTA4MDAsIFJpY2hhcmQgQ29jaHJhbiB3cm90ZToNCj4gPiBPbiBN
b24sIEZlYiAxNCwgMjAyMiBhdCAwMzoxNTozNlBNIC0wODAwLCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2Uv
aWNlX2FkbWlucV9jbWQuaA0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2Uv
aWNlX2FkbWlucV9jbWQuaA0KPiA+ID4gaW5kZXggZmQ4ZWU1YjdmNTk2Li5hMjNhOWVhMTA3NTEg
MTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Fk
bWlucV9jbWQuaA0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9hZG1pbnFfY21kLmgNCj4gPiA+IEBAIC0xNDAxLDYgKzE0MDEsMjQgQEAgc3RydWN0IGljZV9h
cWNfZ2V0X2xpbmtfdG9wbyB7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgdTggcnN2ZFs5XTsNCj4g
PiA+IMKgfTsNCj4gPiA+IMKgDQo+ID4gPiArLyogUmVhZCBJMkMgKGRpcmVjdCwgMHgwNkUyKSAq
Lw0KPiA+ID4gK3N0cnVjdCBpY2VfYXFjX2kyYyB7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgaWNlX2FxY19saW5rX3RvcG9fYWRkciB0b3BvX2FkZHI7DQo+ID4gPiArwqDCoMKgwqDCoMKg
wqBfX2xlMTYgaTJjX2FkZHI7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqB1OCBpMmNfcGFyYW1zOw0K
PiA+ID4gKyNkZWZpbmUgSUNFX0FRQ19JMkNfREFUQV9TSVpFX1PCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoDANCj4gPiA+ICsjZGVmaW5lIElDRV9BUUNfSTJDX0RBVEFfU0laRV9NwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAoMHhGIDw8DQo+ID4gPiBJQ0VfQVFDX0kyQ19E
QVRBX1NJWkVfUykNCj4gPiA+ICsjZGVmaW5lIElDRV9BUUNfSTJDX1VTRV9SRVBFQVRFRF9TVEFS
VMKgQklUKDcpDQo+ID4gDQo+ID4gTml0OsKgICNkZWZpbmUgYmVsb25ncyBhdCB0b3Agb2YgZmls
ZSwgb3IgYXQgbGVhc3Qgb3V0c2lkZSBvZg0KPiA+IHN0cnVjdHVyZSBkZWZpbml0aW9uLg0KPiAN
Cj4gVGhlc2UgYXJlIHRoZSBiaXRzIHRoYXQgZGlyZWN0bHkgcmVsYXRlIHRvIHRoZSBmaWVsZHMg
Zm9yIHRoZSBIVy1TVw0KPiBzdHJ1Y3R1cmVzLiBJdCdzIG1vcmUgcmVhZGFibGUgYW5kIGVhc2ll
ciB0byBjb3JyZWxhdGUgYnkga2VlcGluZw0KPiB0aGVzZQ0KPiBkZWZpbmVzIG5leHQgdG8gdGhl
IGZpZWxkcyB0aGV5IHJlbGF0ZSB0by4NCg0KSSBoYXZlbid0IGhlYXJkIGFueXRoaW5nIGJhY2su
IEFyZSB3ZSBvayB3aXRoIHRoaXMgY29udmVudGlvbj8gSnVzdCB0bw0KYWRkIHRoaXMgdXNhZ2Ug
aXMgZmFpcmx5IHN0YW5kYXJkIGZvciBvdXIgZHJpdmVyIHN0cnVjdHVyZXMgZXNwZWNpYWxseQ0K
aW4gdGhpcyBpY2VfYWRtaW5xLmggZmlsZS4NCg0KVGhhbmtzLA0KVG9ueQ0KDQo+IFRoYW5rcywN
Cj4gVG9ueQ0KPiA+IA0KPiANCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHU4IHJzdmQ7DQo+ID4gPiAr
wqDCoMKgwqDCoMKgwqBfX2xlMTYgaTJjX2J1c19hZGRyOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKg
dTggcnN2ZDJbNF07DQo+ID4gPiArfTsNCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gUmljaGFyZA0K
PiANCg0K
