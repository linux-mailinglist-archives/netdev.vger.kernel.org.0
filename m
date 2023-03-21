Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDF26C31C2
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCUMe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjCUMe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:34:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A823A38649
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679402095; x=1710938095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sYf3QTp7T5GIrw2JXK0K9X9howUagbHqKhfawBxa6V0=;
  b=isZRDQA4VwbrIQMaX8G4b7UdpiM6FLftxCmJO4xmRllphwcDQUFpgqOv
   hF3XfdmhrEpZD4MUkK+6p01i4QjGEuaDbGbk8NG9ZGVXmg7mS9FKeEj3S
   xwMlje/ElTwhSNsF2C/1gFHmmCA3J1hKLlpgkijjTP9xt/nAbiaRMTyjU
   mvcThSZhh689sj0hWjHq+WyHhLO8d3JSnUruYkzYysq/JyfVeXdjiBLt3
   CIXjuMfmKjRBlCjM6nuHjksMSM/Wz3VCtnBopTnVzyKkk1fWC7m522ZS6
   /FPLqShDuY4F3jxr/pVnnxAouhUII8b5Fe6EMu22R2SJyX4xIUvM3PWjH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="366655906"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="366655906"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 05:34:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="770614348"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="770614348"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Mar 2023 05:34:54 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 05:34:54 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 05:34:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 05:34:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 05:34:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEqYjW0d04XVvsMTBqfC3BnaBQvSojDK8QMy+dHGYCZ6e+N7uvTTWkYQFHCWJIa4UzoVp3BFnLiqAuWwZIAYwCkhPr30xddvU5KYOg3JROskyKN/lBnckLvrEXX3MuDi0abVUGN6tOR4olmVJy1bskIEbmqX+57sRZriENt5ngOetKQLZ3/dRcxOH1dw0Y/z810bG63q+k8En/+w2ME4AEKt6raaHUesMxoLY5qMkgICHBjBviUQVTv1+8WcV+auMlqCFcxXiDUrJsSFcRUdoZ/6iWqqJQo097TcjEbunyU/k9pgu7JjcfcWRd3f3Kx6VOJVNuYlKLTmZbuLWRE6NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYf3QTp7T5GIrw2JXK0K9X9howUagbHqKhfawBxa6V0=;
 b=S6vCDgtQLhUFeHVJKuco6zgTMqGwv55M/b2gv5qS+643C/ks/Tf8C5GP5Td0zfzWt4ovnhMYotlppDpys5WB8Q0pE5nZhiJxR6FqlXUq7QakORJnMmbWxLhtE1nMAmMp3Y20rVBptZKqxa/I1AADQNbSd22xRamu9GggLxGNrpsqFGecvEGqtCV6QlZKZxSzHyWUFU5u6bCtmMQ5T4H6B6WlBq5bhcqZgWE3HdOUdx959TE/8reOLqftfK4CC3DN/r5X7zJFcBkwehjZJEop8JD3g/5P9G2v1S2P+GWoEp0AB5UzC9hSWww8hjN5EaQP3b5enQdGU3KPSfzbikYK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 12:34:51 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 12:34:51 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: RE: [PATCH net] tools: ynl: add the Python requirements.txt file
Thread-Topic: [PATCH net] tools: ynl: add the Python requirements.txt file
Thread-Index: AQHZVo86gIA/ksfkVkeNfFQzyDEwlK781aYAgAc5rKCAADa0gIAA787w
Date:   Tue, 21 Mar 2023 12:34:50 +0000
Message-ID: <BN6PR11MB41770D6527882D26403EF628E3819@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
 <20230315214008.2536a1b4@kernel.org>
 <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
 <560bd227-e0a9-5c01-29d8-1b71dc42f155@gmail.com>
In-Reply-To: <560bd227-e0a9-5c01-29d8-1b71dc42f155@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_|DS0PR11MB7381:EE_
x-ms-office365-filtering-correlation-id: 0c4533d7-fc49-4f41-e17e-08db2a08aa6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UbRNlKvgp6GtV+mJ1n0JUnAiWwMBcMwy0M0Wk+6OQSaC5QUUd2vfEr5UgY+IVoTPrkpeaX8P8ssXiTQs4LVrApEBACf63bzuPTXVT7P1/lJgrc8ftfQkvaFpHTD3RSNpgHG/h6jyN8NbH0iqF7CCOgahgK1jvOocHJ2EJlDsbIGZnKG89TDF8nNZ+0aymP8z69AbRIQ0ODVuEBJDchQAOLOny7+QHuYVuloStgTMy/C37VwLN1KRz0ZovMMqm1QH8hqyFpQflSf0j/DQ8AEeOifkHqXB+ySWFsg0yqe/gv5dEAcn1QOMpNiv3G2k+NRflRm7w/OvIU0Et2HpDkS83XroNdJ7nCyOMwbnZ6gvB8zr0yzXObvKKZ5GGCQ/s4aC7bfvyMLxmVV9UsFfRTfQa/3DRsIA/jJcAybl0HPch7KV/V4+nemLNAxFvdHwsNUR+6VBnfsV41Hj/mGocYDkRYhfhs7INAHBGW1Vj7XZXPul5Ix7YkluNCIGfC3MTKoX451YXyKDOYTolFO84ODnfjIeMJUA1BKjnO0nNfSslRWEbzVr+14Vy2cJGd0duPpqJfRnWz4Vn6VRq1Bus6EyWHaTvVvoy8vX6+b4q11+i97JljCyobMe+cn6fs5CALEvF2tXJAgSUld55+IIczNzXkTK5941+QuqqJo52LRzP345wIc4IM1y/yzyOPuxahMf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199018)(8936002)(52536014)(41300700001)(5660300002)(55016003)(33656002)(38070700005)(86362001)(38100700002)(4326008)(82960400001)(122000001)(2906002)(54906003)(83380400001)(6506007)(53546011)(478600001)(9686003)(7696005)(107886003)(186003)(26005)(966005)(8676002)(71200400001)(66476007)(66446008)(66556008)(66946007)(64756008)(76116006)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnNCTzRKK0JtWkFQNGg5VXVub0tFbUNGYTBpMUNjdzBIR3ZYVXFoQ01rUzRo?=
 =?utf-8?B?NEt1ZG9QNWxaVTVZQkxnUFpqbkpXRHFOc1VsY3dtT0NSYlZMQlcwNU0zME1X?=
 =?utf-8?B?eDBza3lmVUE2NWRPd1RaSERSa254RXhTZVpHK2o0Z0JYZmVtMzB2emIyVkYy?=
 =?utf-8?B?QmViWVdnK1ZyV1NaR1ZDUnN6MDU1Z3RZdzBXdkpaZnkrYm9NQ1c2alpVQmpF?=
 =?utf-8?B?aWtjQTZLaWpPNUpOOUZtOHpWakdFcUJxMW5kdXExMnZ6cGRDaUUxN3VlVUha?=
 =?utf-8?B?K2czRVNBanFaTGt5N0lTbXUza0FwZDJQOUJPRXgvam01eUJ0TmFKMWVXSzcz?=
 =?utf-8?B?WEhuVFpPV3NSd09nWXNTRDV3QVVJaGd3dFdjb2RtSHJHamdQdkU1bTU0dGN0?=
 =?utf-8?B?NXRSMjNlL2hLWnArZlhtM2dKaUF4U3V4Z3pSY3lqUjIyd0w2SEJ2bHRVSFJJ?=
 =?utf-8?B?czVhNzRSYnV6Nis3dTNlVFJlWStYRFZvNGJhb2lkbHVRNTRoVGhCbnQwU1VO?=
 =?utf-8?B?T3lNZGdlbnhPYzVYcEVpQThGbVY1K3BqMENkMXE3djFwRDNMTHc0ZURiTGhr?=
 =?utf-8?B?cnhiNXVFR2NlRWtpL3MrVTVPZFRGRWkrVEY5S09vbG5EVDZWbEkwMWJ4U09z?=
 =?utf-8?B?Rk9tWENtZ2ZxSDNRVk9rSG84cm9aVGl0UGw3dEI5SzVTRmo2cytrd3c4UzVu?=
 =?utf-8?B?QzhTV3FYS2pFTXpqSUxyTkFVZW5SeUoxcFovSzNhU0tscndNSzdRMGFRamRx?=
 =?utf-8?B?T3BkcUhJNGkzaUR2RnU0RXM3VnVUMmZWQ1BmdUJLVHRWTkMxZ0UwTHMwNXVB?=
 =?utf-8?B?TTRvT3JIQm1FdmxOaDcrWjgvM2ozdStMbVpQR095b2NjTXNWeHVkcGpidlJp?=
 =?utf-8?B?ekwwV0wvakJCd1JvY0Rqb1c5VVNEenplc1FEaVdKSmxzNFlseDBnekE1SzhR?=
 =?utf-8?B?b25Pek1MOG03QXlwaUhKRG83bW51MUVhVHNuY2cxOUdlYTU5THdKOUNBN2Ew?=
 =?utf-8?B?aUp4cVY5TGJUdjJUeWpIL0N5anNGaG1udlhvOW1jeVVLWkdpU2tWaVROcnpk?=
 =?utf-8?B?ejhHd3J1U0I4ZHhwNG9GRHZBZW1OZXh6Z0M4QzFCOTlZL1B2SUpSTitKeUxH?=
 =?utf-8?B?NmJVOC9HMzRzM201b0hKN1lNTHlrYnVJSm9vNG5ycVdicVErMklOQmR1MVpZ?=
 =?utf-8?B?dlRET0d3Q0p5QTJOVTh4Yk4wYldmMEdWL3FZa0dyYjVYQU5TWmRTdmg0ekZh?=
 =?utf-8?B?UjNkNFRXeG85WVgwZklFWncvSUdVemNOVmluSjVWSjdPVGgxbHYwV2N5TU1C?=
 =?utf-8?B?aHA1d2FudGxEaGc2MFB1V0xseEdiak9Bamtxd0FMY1ZYVk15M2Nid0g0aW9B?=
 =?utf-8?B?ZHlwOFMrYTlJNUxYNkJnZ1phZkZWbFR4TlYvQWFGaFJicjd3VUlkWlVkSjg4?=
 =?utf-8?B?UXN2N0tDV3FYR1pVZU1KdzVVZDlqNWIvZ1pqSXV0NWtTdkszY1RLYkZKOGh1?=
 =?utf-8?B?UDJkTitWRmRpUHZZMVdJR2tDb1NHTHNkTzJOejF6b0RNL1JnZ1FSN0FPUFRq?=
 =?utf-8?B?MWx1UnU5K214TGVob0RYVmljMXRFcnp6QTVVNk0yTTlIOHk4NEl3c3ozZUJ2?=
 =?utf-8?B?QmQ3MVQ0T1UvVzRtNFJuV25Ib1hhbnEzdzJGL2FiZURoTmZOMkVGV2gyS1Q4?=
 =?utf-8?B?YzNOVDZlR0lQODcxYUdMSmpmTnVjRHltTEF0QUhwSGNxTlU4TnZBTHpJOEpl?=
 =?utf-8?B?TFdEcG5tZXl1enJCcmNwdGV1UStPSFNNV08rek51V0JEL2IrNUFqbzRBb2Zy?=
 =?utf-8?B?RjRpd1FlQWdvMldubU8xaXk0SmVlL1o5S04wekxCV1Fwb002Y0s4UzFSUjZz?=
 =?utf-8?B?NzNXZzhlQXM5c2NNL0ZzbTA3VFJpTkRoSjJqR1JrbVFINDJTQ2VHN3QwZ2pz?=
 =?utf-8?B?NC9tcEZBUExaOEZOTzhSZEsveW1IZGI3QkF1USt4RmFib25aNlJ6bGQ0THF1?=
 =?utf-8?B?M0ptV2ZJWGpBazRBdUJyM1NIaFB4cC96VGw4MjNnYk1UWVhrRUUzWXBhMkZH?=
 =?utf-8?B?aXBlNTlpeXZEaFlJeHpqQzlYdDhmQVVzemd5RFhwQ20vQUdKSHFuUWl4NWdN?=
 =?utf-8?B?TFp4dFE1dzZMNzRuRzFJTFlHUTAwejBoZ010NEtnb1RPdHJ6OHhaeW1oemQr?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4533d7-fc49-4f41-e17e-08db2a08aa6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 12:34:50.9733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SmCoeGFmT+TmT8o0NdO0Igz2pMiD65lkPMa8v/PnbIBkZi8u7dKCPXBmPU5/hwHVqZpIQHBuW5WuJ/JnRDkmXPHt+a153l6bdZ/nuBDKMqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAgTWFyY2ggMjAyMyAxMToxNiBQTSBDRVQsIEVkd2FyZCBDcmVlIHdyb3RlOg0KPiANCj4g
T24gMjAvMDMvMjAyMyAxOTowMywgTWljaGFsaWssIE1pY2hhbCB3cm90ZToNCj4+IEZyb206IEph
a3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+IA0KPj4+IFdoeSB0aGUgPT0gc2lnbnM/IERv
IHdlIGNhcmUgYWJvdXQgdGhlIHZlcnNpb24gb2YgYW55IG9mIHRoZXNlPw0KPj4gDQo+PiBJIGNh
bm5vdCAoeW91IHByb2JhYmx5IGFsc28gbm90KSBndWFyYW50ZWUgdGhlIGNvbnNpc3RlbmN5IG9m
IHRoZSBBUEkgb2YNCj4+IHBhcnRpY3VsYXIgbGlicmFyaWVzLg0KPiANCj4gQXNzdW1pbmcgdGhl
IGxpYnJhcmllcyBhcmUgZm9sbG93aW5nIGJlc3QgcHJhY3RpY2UgZm9yIHRoZWlyIHZlcnNpb24N
Cj4gIG51bWJlcmluZyAoZS5nLiBzZW12ZXIpLCB5b3Ugc2hvdWxkIGJlIGFibGUgdG8gdXNlIH49
ICgnY29tcGF0aWJsZQ0KPiAgdmVyc2lvbicgWzFdKS4NCj4gRm9yIGV4YW1wbGUsIGBqc29uc2No
ZW1hIH49IDQuMGAgd2lsbCBhbGxvdyBhbnkgNC54LnkgcmVsZWFzZSwgYnV0DQo+ICBub3QgNS4w
LjAgc2luY2UgdGhhdCBjb3VsZCBoYXZlIGJyZWFraW5nIEFQSSBjaGFuZ2VzLg0KPiBJIHdvdWxk
IHJlY29tbWVuZCBhZ2FpbnN0IHBpbm5pbmcgdG8gYSBzcGVjaWZpYyB2ZXJzaW9uIG9mIGENCj4g
IGRlcGVuZGVuY3k7IHRoaXMgaXMgYSBkZXZlbG9wbWVudCB0cmVlLCBub3QgYSBkZXBsb3ltZW50
IHNjcmlwdC4NCj4NCg0KVGhpcyBpcyBhY3R1YWxseSBhIGdvb2QgaWRlYS4gTGV0J3Mgd2FpdCBm
b3IgSmFrdWIgdG8gY29uZmlybSBpZiBoZSBmZWVscw0KdGhlIFB5dGhvbiByZXF1aXJlbWVudHMg
ZmlsZSBpcyBhIGdvb2QgaWRlYSBpbiB0aGlzIGNhc2UuIElmIGhlIGNvbmZpcm1zLA0KSSB3b3Vs
ZCB1cGRhdGUgdGhlIGxpYnJhcmllcyBhY2NvcmRpbmcgdG8geW91ciBzdWdnZXN0aW9uLiBUaGFu
a3MuDQoNCj4+IE5vLCB5b3UgZGlkIG5vdCBmb3JnZXQgYWJvdXQgYW55dGhpbmcgKGJlc2lkZXMg
dGhlIFB5WUFNTCB0aGF0IHlvdSBkaWRuJ3QNCj4+IG1lbnRpb24gYWJvdmUpLiBUaGVyZSBpcyBt
b3JlIHRoYW4geW91IGV4cGVjdCBiZWNhdXNlIGBQeVlBTUxgIGFuZA0KPj4gYGpzb25zY2hlbWFg
IGhhdmUgdGhlaXIgb3duIGRlcGVuZGVuY2llcy4NCj4gDQo+IEFnYWluIEknZCd2ZSB0aG91Z2h0
IGl0J3MgYmV0dGVyIHRvIGxldCB0aG9zZSBwYWNrYWdlcyBkZWNsYXJlIHRoZWlyDQo+ICBvd24g
ZGVwZW5kZW5jaWVzIGFuZCByZWx5IG9uIHBpcCB0byByZWN1cnNpdmVseSByZXNvbHZlIGFuZCBp
bnN0YWxsDQo+ICB0aGVtLiAgQm90aCBvbiBzZXBhcmF0aW9uLW9mLWNvbmNlcm5zIGdyb3VuZHMg
YW5kIGFsc28gaW4gY2FzZSBhDQo+ICBuZXdlciB2ZXJzaW9uIG9mIGEgcGFja2FnZSBjaGFuZ2Vz
IGl0cyBkZXBlbmRlbmNpZXMuDQo+IChQcm9iYWJseSBpbiB0aGUgcGFzdCBwaW5uaW5nIGFsbCBk
ZXBlbmRlbmNpZXMgYXQgdGhlIHRvcCBsZXZlbCB3YXMNCj4gIG5lZWRlZCB0byB3b3JrIGFyb3Vu
ZCBwaXAncyBsYWNrIG9mIGNvbmZsaWN0IHJlc29sdXRpb24sIGJ1dCB0aGlzDQo+ICB3YXMgZml4
ZWQgaW4gcGlwIDIwLjMgWzJdLikNCg0KSSBhZ3JlZSB3aXRoIHRoZSBjb21tZW50IHRoYXQgaXQg
aXMgbm90IGEgZGVwbG95bWVudCBzY3JpcHQgYW5kIHRoYXQgd2UNCmNvdWxkIGxlYXZlIG9ubHkg
bmVjZXNzYXJ5IHBhY2thZ2VzIGFuZCBsZXQgcGlwIGRvIHRoZSByZXN0IG9mIHRoZSBqb2IuDQpJ
IHdpbGwgdXBkYXRlIGlmIEpha3ViIHdvdWxkIGRlY2lkZSBoZSB3YW50IHRvIHNlZSB0aGUgcmVx
dWlyZW1lbnRzIGhlcmUuDQoNClRoYW5rcyBFZHdhcmQgZm9yIHZhbHVhYmxlIGlucHV0IQ0KDQpC
UiwNCk1eMg0KDQo+IA0KPiAtZWQNCj4gDQo+IFsxXTogaHR0cHM6Ly9wZXBzLnB5dGhvbi5vcmcv
cGVwLTA0NDAvI2NvbXBhdGlibGUtcmVsZWFzZQ0KPiBbMl06IGh0dHBzOi8vcGlwLnB5cGEuaW8v
ZW4vbGF0ZXN0L3VzZXJfZ3VpZGUvI2NoYW5nZXMtdG8tdGhlLXBpcC1kZXBlbmRlbmN5LXJlc29s
dmVyLWluLTIwLTMtMjAyMA0K
