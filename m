Return-Path: <netdev+bounces-1529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D384B6FE229
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 468E3281438
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9AE168CE;
	Wed, 10 May 2023 16:09:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373C86AA8
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 16:09:35 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F345BAA;
	Wed, 10 May 2023 09:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683734973; x=1715270973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mfkLHdYqU6SJa0XwKO/5CAdRhvG+Vf56stVm2kA66ac=;
  b=S5Ora3lZyrkGGtdKaVucpAYepuko2Ispzf4Lz2Wjxm0Qgl/kZC9Scyn+
   HZm9S9N3OaFNKj+DXCFeiVfTLXQjglcO3ZUMDVGm6jdG0ozu2+RfQvXD6
   XQwaOHMF5nL7h5CNLZkh13DwN4jJ6T5thV3Mxd/oz3iphngprW9QpBUoS
   EUKCUEAbZRinjDicg0yK4vajDKtuUgRtZSeN0g9nxkY/eEOMtBaf1sPh/
   qphryB3qdFoCzRs2cWpx9L7wRIIfBO9IFf2MPxx1Ee6xQMXSOVZZMolsg
   UdSnkDcuivzMdUN6pVcmQ513pF3PuYUb8jVywFUvYt6H1HFEseSvcD4Fj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334720948"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="334720948"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 09:09:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="768959124"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="768959124"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 10 May 2023 09:09:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 09:09:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 09:09:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 09:09:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 09:09:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j59g1kZ7snrZ+MrFEBtDc5MOWluYm+SIyrjg/5Xw+XEmaM1fGID86c44DNUPBZOymSUFDkDTlmb1IUyXKy5i4jsZOmErlbEVjrO5GDIERdK3ULKrpjPg9fuvYD/Tj2SC1R9RwDiaVgdb5VlFQWZQSSBQMuJ9KF8HBxFjfcYdmarH/f5VaMPU/s45uTuWSOFF5ZlhyvwsxNDHgLus1hBsj0h2S3OHzH51MDi/L/grQOwTwSnyDFwDm4+Dn1xxTiyupBBDeXzkAhuRuZMcY1LkCDJPUsElkhpXSh/PQAG3gCCpaSHYOHzwepwYeUHPGwutYQY69a8Kj7RFnwevu3ddBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfkLHdYqU6SJa0XwKO/5CAdRhvG+Vf56stVm2kA66ac=;
 b=hstCE1IW03QrtjI26ztECVsZhWhh9eLbqtxxC1vCAzD/gGQFckP+IWU2xX6NIfrSE8QjUoR3S2G8vKNK/+S0Id8+iHaiIQGjNfqUNUTlmDZs8jK3Iqmb6bDrQ0OxGkbkySZ5nprxnPgLus9ZuSqIWJCQ8652GOusqW04YwySMdr/aCsDM0j2+0C7njSA1FdwyVeCXueVpJDJCS96UfL4pOckLzToiNtx50Lj7N1wYM8o0di59bYXXoi4+0R/zzCuDEc/6FaSvK6ivk42hNc3zNVgZYXI3VtaCbCfRRJObJLfpDdCDN9yO3TH45iRy421wjvQBS+QuhSu6SoBKCWVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 16:09:23 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 16:09:23 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Eric Dumazet <edumazet@google.com>
CC: Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C"
	<tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAA==
Date: Wed, 10 May 2023 16:09:23 +0000
Message-ID: <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
In-Reply-To: <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|SA0PR11MB4606:EE_
x-ms-office365-filtering-correlation-id: 22e89b04-5d53-43c0-8a58-08db5170eb71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fMob67YfBkn0hJz8NRCw6ZOOH+ny8c84LYNseTERJcz7fVPfihpp6mut+Kj4yrOshgY7uLsJic5XnqsFaStKu0M+JeyP1HocqRmrsHBbjdEbby/RTEab3d+rnEefoUZCOKP9eALM6mtJWmvTckVqaC+e9d3DN4l1S/0EfZOEegcJQUZoTLOJXcYYbEEbWA7XVcr0bpLUGYgfkszjMnbdrh9JsqzVnDQleHvnMFSRS3UiuP15vDVc9h7JY+bxnceZXCSM7JLJGsovfi1SGp1H7qi2LRpBzaN9yjxJheY8Ekyn74CPI34mtUMChMrFjaeo6bpS96OLdSMo5B0FO4qzOlimPrc37JuyLJASjqBkprYZUqam5ShEWrc13C/O+D/psfxi9P1Yr6UagUjq/bonLkYj0IFTN2CKnJmpBAFAxtdyyE0qpmO/Wf2rLkqyRfK0Tw7FTZxrbTAyzkCxDSbN24YWUPUIIFh0u97v5xy7Fz15ldfAq0Ajk4Jhxqw51cxg1wYHP1wx09zCy8yKXBan57+AfeEnSsyvwX0l5n7M5ZBMNrmQWcHjk4va0D8ZBd9lqxQSCtPm0O7N50he3/0n7qJvVBaDiNX5Cy3LOBwu1us=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199021)(71200400001)(7696005)(966005)(4326008)(64756008)(76116006)(66476007)(66446008)(66946007)(66556008)(54906003)(82960400001)(2906002)(6916009)(38070700005)(38100700002)(86362001)(41300700001)(316002)(52536014)(33656002)(5660300002)(8676002)(122000001)(55016003)(8936002)(478600001)(186003)(6506007)(9686003)(26005)(53546011)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWIzSE1wU1ZnK1FOdjhibzByeXRNbXp4VDNQM1NVbE1aTFJiaVhHSFF4bllN?=
 =?utf-8?B?ekJ1OTZYOEZxNGdyblRINFBDVTdLbUhtM1RCSWd4OERIUE1HNnZldFpQVUZK?=
 =?utf-8?B?c3haV3N0Ti8xTDdYMlFXUGVzMGszc3ZycWlOZ3hkV2dhcXFZVEZIcHYyQzVt?=
 =?utf-8?B?OCs0YTlRb3lUZ2tid0lRcTVIY0sranY0QkhNR24ycXVPNE1HTDdlMmtoVDU5?=
 =?utf-8?B?U3BCY0FyZWNXeDhGbDkzVjlxVDVqejdYNDhXZHdXeDhBdmR6MGJxM1UzSURz?=
 =?utf-8?B?RzA0RFExMlpRR29Mc2tYT21Va2Q4bEQ2S29rcTk5VGRyM2paMFlYNEUyUEFw?=
 =?utf-8?B?cmxvYWJpZlJCRExIL2JwcVBuWTk3czhGckR0d1BLdHJhdC9EMEZXbkxwMndr?=
 =?utf-8?B?Y2k3M0h6cStTcTU5U0JFKzVIekFZSGc4LzhuRkwxT0czWUQ3UW5HSy92ZVY0?=
 =?utf-8?B?NUk1ZjE0UjkraElTc3ZxVm8vT3FNZWV1YVpOaEo5a041aFVOR01Ga1BNSllm?=
 =?utf-8?B?VzJCS0o4WlVCVDhGUHJncGlRTFREZ2pIZXQvOXNSeTh1WFJVR3EvSmJZVDlo?=
 =?utf-8?B?em9mV0p1bWFkZEVDUVZ3clBDejlITGV0dzZKaWdKSkZJVXNySEM5b0JaRTlW?=
 =?utf-8?B?ZG9UbEpWdGZtZ0dCeTlOMXIrYjRGWE84QmsvczcxWm5vS1RzSkJDczhiekNq?=
 =?utf-8?B?a2xTV1NWVWhBeDBpbGFBU0FGWFhYNlI3akYyTVJLUEtQMXNMZUtOYVZVbHg5?=
 =?utf-8?B?cGd3NHh4ZHAvZElsa3RZZ1R1YlkxMEZraUk2Sm9wM0RheEowcDNjWmh4VUMv?=
 =?utf-8?B?MlhJR2FmS0VieFJSSENZUU85ZkNQcWhZcTNIN1JYbEVGeC84MEtVb3lpelFk?=
 =?utf-8?B?Z3lZeFlna1FhU05iR0xlREdRUi9kS2NIWmJyK0g1NjMrTXN4elgyOW50OWph?=
 =?utf-8?B?Ujcva1R5d0FsOHljdFowZDNxOFdwNEdidjkzTWVNNmlNY3hoa0FtMHVYR2dI?=
 =?utf-8?B?aUE2eGY2eTBDRDQrbkFkV21QeUh3T0hCU0Frdmg0Sm1zeWtaenNOQnJzb3Va?=
 =?utf-8?B?TjAweUd2Qm5oeUp0cktLdGtpUGRWamVvNk9PSzR1NG1uVXU1VzF6Nzhjd2xB?=
 =?utf-8?B?QnljWm1IL3dCaVVFY2lORmpETEQxOWFMaFhsbGJZb3JzUXJ0L1hEb0cwRkFD?=
 =?utf-8?B?aExXNHp6MTVzLzVLRUphYVpZSGpUc2lYblViR1hOeTUwazRkOVgvSUpLb1o1?=
 =?utf-8?B?RVBHWThvK0wwWlhhQ1V0bkhQbW5ZUkV1aEFqSjVrUFcwOVVjWVZEN0cyZGJ2?=
 =?utf-8?B?bTJ0bXVCUkxrdDhyMzdwY0VtZXN5aGdETERMMlRVWUR4SGJaY3pCQXVLT3hF?=
 =?utf-8?B?eXcyY3dCWnNNM0plQXpLdzR6dFo4L2dNdXUxd0NQdUI5VGF1a0xJREF0T1VC?=
 =?utf-8?B?a3haK1VwVUdWUXBuWExzNE5UQm9PWmpVb1RYN3FhbTNKVlVXZS9TMk56dXRo?=
 =?utf-8?B?UlNXRzZGQjJ0YzlONFAwcmhNdFJrTnVrQjNzRGltNTl2ZjRqREZSK2h2eTNa?=
 =?utf-8?B?MmwweXBCdGduQ2R2TDlPbGFLMlJTclhHcURmVVBQc3lNOVZMM1NyOGtrc0k3?=
 =?utf-8?B?Z0l4RlcrU2hzaTdqVk9BemZxdDVpSHFPS0lOUnh2UkVnMTVGOGU1ZE9OckpL?=
 =?utf-8?B?SVBnbEdFSnR5VlBsTzVRK3g2MFZzaEc3VWxzV2o0K2k5YlA1dTdBQnNxTlJB?=
 =?utf-8?B?ZFAzcjJ4K2pMd3E4dmtjbmpaQzI4RDhZUFc4VVZpYktLZVA4bVlkaVI2NVov?=
 =?utf-8?B?bDNWb3lGRUNRTDM4ZGNYeDE4bHhZcXFZakRyU3orbzBkc290UlVMaUx6cjFV?=
 =?utf-8?B?Ukwra0s4ei9WRURSa3lZakt6Q0pyWk5rNXBJMFh4L0pOR21NN2twMkNhRFFG?=
 =?utf-8?B?UFZpREJ0Q1pNVlRxNkNtQ0hVZVh5UjdPUTRGaXZNNUh5cE9JYXRHcXV6M0Vl?=
 =?utf-8?B?bUxVOTF1Qy9YMVdVVFhHcEFDT0pmSG1UQTQvOThsWU1DY0U5bmMxWTFpWkJE?=
 =?utf-8?B?UXhtdG1HTGw1bFVub0srR21XdTBQRXIvV2R0dkJxYzVzWHZVdFNsVmh0c01N?=
 =?utf-8?Q?i3y6vw0p1bxbsrt2DgWVgZ2jb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e89b04-5d53-43c0-8a58-08db5170eb71
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2023 16:09:23.0823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YCzj+Gfi7aAc8pccqOGv9NiLuyDG5XIfwT/49mv06fyATXcwgBdUgxJ0llvWdO8Y8XcwmW5Kgg7udgsokhokvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAyMyAxMTow
NyBQTQ0KPiBUbzogWmhhbmcsIENhdGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+IENjOiBT
aGFrZWVsIEJ1dHQgPHNoYWtlZWxiQGdvb2dsZS5jb20+OyBMaW51eCBNTSA8bGludXgtbW1Aa3Zh
Y2sub3JnPjsNCj4gQ2dyb3VwcyA8Y2dyb3Vwc0B2Z2VyLmtlcm5lbC5vcmc+OyBQYW9sbyBBYmVu
aSA8cGFiZW5pQHJlZGhhdC5jb20+Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5l
bC5vcmc7IEJyYW5kZWJ1cmcsIEplc3NlDQo+IDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47
IFNyaW5pdmFzLCBTdXJlc2gNCj4gPHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVuLCBU
aW0gQyA8dGltLmMuY2hlbkBpbnRlbC5jb20+OyBZb3UsDQo+IExpemhlbiA8bGl6aGVuLnlvdUBp
bnRlbC5jb20+OyBlcmljLmR1bWF6ZXRAZ21haWwuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNr
X2ZvcndhcmRfYWxsb2MgYXMgYSBwcm9wZXINCj4gc2l6ZQ0KPiANCj4gT24gV2VkLCBNYXkgMTAs
IDIwMjMgYXQgMzo1NOKAr1BNIFpoYW5nLCBDYXRoeSA8Y2F0aHkuemhhbmdAaW50ZWwuY29tPg0K
PiB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4gPiBGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQo+ID4gPiBT
ZW50OiBXZWRuZXNkYXksIE1heSAxMCwgMjAyMyA3OjI1IFBNDQo+ID4gPiBUbzogWmhhbmcsIENh
dGh5IDxjYXRoeS56aGFuZ0BpbnRlbC5jb20+DQo+ID4gPiBDYzogU2hha2VlbCBCdXR0IDxzaGFr
ZWVsYkBnb29nbGUuY29tPjsgTGludXggTU0NCj4gPiA+IDxsaW51eC1tbUBrdmFjay5vcmc+OyBD
Z3JvdXBzIDxjZ3JvdXBzQHZnZXIua2VybmVsLm9yZz47IFBhb2xvDQo+IEFiZW5pDQo+ID4gPiA8
cGFiZW5pQHJlZGhhdC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7
DQo+ID4gPiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBT
cmluaXZhcywgU3VyZXNoDQo+ID4gPiA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4s
IFRpbSBDIDx0aW0uYy5jaGVuQGludGVsLmNvbT47DQo+ID4gPiBZb3UsIExpemhlbiA8bGl6aGVu
LnlvdUBpbnRlbC5jb20+OyBlcmljLmR1bWF6ZXRAZ21haWwuY29tOw0KPiA+ID4gbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5l
dDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcw0KPiA+ID4gYSBwcm9wZXIgc2l6ZQ0KPiA+
ID4NCj4gPiA+IE9uIFdlZCwgTWF5IDEwLCAyMDIzIGF0IDE6MTHigK9QTSBaaGFuZywgQ2F0aHkg
PGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4gPiA+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBI
aSBTaGFrZWVsLCBFcmljIGFuZCBhbGwsDQo+ID4gPiA+DQo+ID4gPiA+IEhvdyBhYm91dCBhZGRp
bmcgbWVtb3J5IHByZXNzdXJlIGNoZWNraW5nIGluIHNrX21lbV91bmNoYXJnZSgpIHRvDQo+ID4g
PiA+IGRlY2lkZSBpZiBrZWVwIHBhcnQgb2YgbWVtb3J5IG9yIG5vdCwgd2hpY2ggY2FuIGhlbHAg
YXZvaWQgdGhlDQo+ID4gPiA+IGlzc3VlIHlvdSBmaXhlZCBhbmQgdGhlIHByb2JsZW0gd2UgZmlu
ZCBvbiB0aGUgc3lzdGVtIHdpdGggbW9yZSBDUFVzLg0KPiA+ID4gPg0KPiA+ID4gPiBUaGUgY29k
ZSBkcmFmdCBpcyBsaWtlIHRoaXM6DQo+ID4gPiA+DQo+ID4gPiA+IHN0YXRpYyBpbmxpbmUgdm9p
ZCBza19tZW1fdW5jaGFyZ2Uoc3RydWN0IHNvY2sgKnNrLCBpbnQgc2l6ZSkgew0KPiA+ID4gPiAg
ICAgICAgIGludCByZWNsYWltYWJsZTsNCj4gPiA+ID4gICAgICAgICBpbnQgcmVjbGFpbV90aHJl
c2hvbGQgPSBTS19SRUNMQUlNX1RIUkVTSE9MRDsNCj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICBp
ZiAoIXNrX2hhc19hY2NvdW50KHNrKSkNCj4gPiA+ID4gICAgICAgICAgICAgICAgIHJldHVybjsN
Cj4gPiA+ID4gICAgICAgICBzay0+c2tfZm9yd2FyZF9hbGxvYyArPSBzaXplOw0KPiA+ID4gPg0K
PiA+ID4gPiAgICAgICAgIGlmIChtZW1fY2dyb3VwX3NvY2tldHNfZW5hYmxlZCAmJiBzay0+c2tf
bWVtY2cgJiYNCj4gPiA+ID4gICAgICAgICAgICAgbWVtX2Nncm91cF91bmRlcl9zb2NrZXRfcHJl
c3N1cmUoc2stPnNrX21lbWNnKSkgew0KPiA+ID4gPiAgICAgICAgICAgICAgICAgc2tfbWVtX3Jl
Y2xhaW0oc2spOw0KPiA+ID4gPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ID4gPiAgICAg
ICAgIH0NCj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICByZWNsYWltYWJsZSA9IHNrLT5za19mb3J3
YXJkX2FsbG9jIC0NCj4gPiA+ID4gc2tfdW51c2VkX3Jlc2VydmVkX21lbShzayk7DQo+ID4gPiA+
DQo+ID4gPiA+ICAgICAgICAgaWYgKHJlY2xhaW1hYmxlID4gcmVjbGFpbV90aHJlc2hvbGQpIHsN
Cj4gPiA+ID4gICAgICAgICAgICAgICAgIHJlY2xhaW1hYmxlIC09IHJlY2xhaW1fdGhyZXNob2xk
Ow0KPiA+ID4gPiAgICAgICAgICAgICAgICAgX19za19tZW1fcmVjbGFpbShzaywgcmVjbGFpbWFi
bGUpOw0KPiA+ID4gPiAgICAgICAgIH0NCj4gPiA+ID4gfQ0KPiA+ID4gPg0KPiA+ID4gPiBJJ3Zl
IHJ1biBhIHRlc3Qgd2l0aCB0aGUgbmV3IGNvZGUsIHRoZSByZXN1bHQgbG9va3MgZ29vZCwgaXQg
ZG9lcw0KPiA+ID4gPiBub3QgaW50cm9kdWNlIGxhdGVuY3ksIFJQUyBpcyB0aGUgc2FtZS4NCj4g
PiA+ID4NCj4gPiA+DQo+ID4gPiBJdCB3aWxsIG5vdCB3b3JrIGZvciBzb2NrZXRzIHRoYXQgYXJl
IGlkbGUsIGFmdGVyIGEgYnVyc3QuDQo+ID4gPiBJZiB3ZSByZXN0b3JlIHBlciBzb2NrZXQgY2Fj
aGVzLCB3ZSB3aWxsIG5lZWQgYSBzaHJpbmtlci4NCj4gPiA+IFRydXN0IG1lLCB3ZSBkbyBub3Qg
d2FudCB0aGF0IGtpbmQgb2YgYmlnIGhhbW1lciwgY3J1c2hpbmcgbGF0ZW5jaWVzLg0KPiA+ID4N
Cj4gPiA+IEhhdmUgeW91IHRyaWVkIHRvIGluY3JlYXNlIGJhdGNoIHNpemVzID8NCj4gPg0KPiA+
IEkganVzIHBpY2tlZCB1cCAyNTYgYW5kIDEwMjQgZm9yIGEgdHJ5LCBidXQgbm8gaGVscCwgdGhl
IG92ZXJoZWFkIHN0aWxsIGV4aXN0cy4NCj4gDQo+IFRoaXMgbWFrZXMgbm8gc2Vuc2UgYXQgYWxs
Lg0KDQpFcmljLA0KDQpJIGFkZGVkIGEgcHJfaW5mbyBpbiB0cnlfY2hhcmdlX21lbWNnKCkgdG8g
cHJpbnQgbnJfcGFnZXMgaWYNCm5yX3BhZ2VzID49IE1FTUNHX0NIQVJHRV9CQVRDSCwgZXhjZXB0
IGl0IHByaW50cyA2NCBkdXJpbmcgdGhlIGluaXRpYWxpemF0aW9uDQpvZiBpbnN0YW5jZXMsIHRo
ZXJlIGlzIG5vIG90aGVyIG91dHB1dCBkdXJpbmcgdGhlIHJ1bm5pbmcuIFRoYXQgbWVhbnMgbnJf
cGFnZXMgaXMgbm90DQpvdmVyIDY0LCBJIGd1ZXNzIHRoYXQgbWlnaHQgYmUgdGhlIHJlYXNvbiB3
aHkgdG8gaW5jcmVhc2UgTUVNQ0dfQ0hBUkdFX0JBVENIDQpkb2Vzbid0IGFmZmVjdCB0aGlzIGNh
c2UuDQoNCj4gDQo+IEkgc3VzcGVjdCBhIHBsYWluIGJ1ZyBpbiBtbS9tZW1jb250cm9sLmMNCj4g
DQo+IEkgd2lsbCBsZXQgbW0gZXhwZXJ0cyB3b3JrIG9uIHRoaXMuDQo+IA0KPiA+DQo+ID4gPg0K
PiA+ID4gQW55IGtpbmQgb2YgY2FjaGUgKGV2ZW4gcGVyLWNwdSkgbWlnaHQgbmVlZCBzb21lIGFk
anVzdG1lbnQgd2hlbg0KPiA+ID4gY29yZSBjb3VudCBvciBleHBlY3RlZCB0cmFmZmljIGlzIGlu
Y3JlYXNpbmcuDQo+ID4gPiBUaGlzIHdhcyBzb21laG93IGhpbnRlZCBpbg0KPiA+ID4gY29tbWl0
IDE4MTNlNTFlZWNlMGFkNmY0YWFjYWViNzM4ZTdjY2VkNDZmZWI0NzANCj4gPiA+IEF1dGhvcjog
U2hha2VlbCBCdXR0IDxzaGFrZWVsYkBnb29nbGUuY29tPg0KPiA+ID4gRGF0ZTogICBUaHUgQXVn
IDI1IDAwOjA1OjA2IDIwMjIgKzAwMDANCj4gPiA+DQo+ID4gPiAgICAgbWVtY2c6IGluY3JlYXNl
IE1FTUNHX0NIQVJHRV9CQVRDSCB0byA2NA0KPiA+ID4NCj4gPiA+DQo+ID4gPg0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbWVtY29udHJvbC5oIGIvaW5jbHVkZS9saW51eC9tZW1j
b250cm9sLmgNCj4gPiA+IGluZGV4DQo+ID4gPg0KPiAyMjJkNzM3MDEzNGM3M2U1OWZkYmRmNTk4
ZWQ4ZDY2ODk3ZGJiZjFkLi4wNDE4MjI5ZDMwYzI1ZDExNDEzMmExZQ0KPiA+ID4gZDQ2YWMwMTM1
OGNmMjE0MjQNCj4gPiA+IDEwMDY0NA0KPiA+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9tZW1jb250
cm9sLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvbWVtY29udHJvbC5oDQo+ID4gPiBAQCAt
MzM0LDcgKzMzNCw3IEBAIHN0cnVjdCBtZW1fY2dyb3VwIHsNCj4gPiA+ICAgKiBUT0RPOiBtYXli
ZSBuZWNlc3NhcnkgdG8gdXNlIGJpZyBudW1iZXJzIGluIGJpZyBpcm9ucyBvciBkeW5hbWljDQo+
ID4gPiBiYXNlZCBvZiB0aGUNCj4gPiA+ICAgKiB3b3JrbG9hZC4NCj4gPiA+ICAgKi8NCj4gPiA+
IC0jZGVmaW5lIE1FTUNHX0NIQVJHRV9CQVRDSCA2NFUNCj4gPiA+ICsjZGVmaW5lIE1FTUNHX0NI
QVJHRV9CQVRDSCAxMjhVDQo+ID4gPg0KPiA+ID4gIGV4dGVybiBzdHJ1Y3QgbWVtX2Nncm91cCAq
cm9vdF9tZW1fY2dyb3VwOw0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9z
b2NrLmggYi9pbmNsdWRlL25ldC9zb2NrLmggaW5kZXgNCj4gPiA+DQo+IDY1NmVhODlmNjBmZjkw
ZDYwMGQxNmY0MDMwMjAwMGRiNjQwNTdjNjQuLjgyZjZhMjg4YmU2NTBmODg2YjIwN2U2YQ0KPiA+
ID4gNWU2MmExZDVkZGE4MDhiMA0KPiA+ID4gMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRlL25l
dC9zb2NrLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbmV0L3NvY2suaA0KPiA+ID4gQEAgLTE0MzMs
OCArMTQzMyw4IEBAIHNrX21lbW9yeV9hbGxvY2F0ZWQoY29uc3Qgc3RydWN0IHNvY2sgKnNrKQ0K
PiA+ID4gICAgICAgICByZXR1cm4gcHJvdG9fbWVtb3J5X2FsbG9jYXRlZChzay0+c2tfcHJvdCk7
DQo+ID4gPiAgfQ0KPiA+ID4NCj4gPiA+IC0vKiAxIE1CIHBlciBjcHUsIGluIHBhZ2UgdW5pdHMg
Ki8NCj4gPiA+IC0jZGVmaW5lIFNLX01FTU9SWV9QQ1BVX1JFU0VSVkUgKDEgPDwgKDIwIC0gUEFH
RV9TSElGVCkpDQo+ID4gPiArLyogMiBNQiBwZXIgY3B1LCBpbiBwYWdlIHVuaXRzICovDQo+ID4g
PiArI2RlZmluZSBTS19NRU1PUllfUENQVV9SRVNFUlZFICgxIDw8ICgyMSAtIFBBR0VfU0hJRlQp
KQ0KPiA+ID4NCj4gPiA+ICBzdGF0aWMgaW5saW5lIHZvaWQNCj4gPiA+ICBza19tZW1vcnlfYWxs
b2NhdGVkX2FkZChzdHJ1Y3Qgc29jayAqc2ssIGludCBhbXQpDQo+ID4gPg0KPiA+ID4NCj4gPiA+
DQo+ID4gPg0KPiA+ID4NCj4gPiA+DQo+ID4gPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gPiA+ID4gPiBGcm9tOiBTaGFrZWVsIEJ1dHQgPHNoYWtlZWxiQGdvb2dsZS5jb20+DQo+
ID4gPiA+ID4gU2VudDogV2VkbmVzZGF5LCBNYXkgMTAsIDIwMjMgMTI6MTAgQU0NCj4gPiA+ID4g
PiBUbzogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgTGludXggTU0gPGxpbnV4
LQ0KPiA+ID4gPiA+IG1tQGt2YWNrLm9yZz47IENncm91cHMgPGNncm91cHNAdmdlci5rZXJuZWwu
b3JnPg0KPiA+ID4gPiA+IENjOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT47
IFBhb2xvIEFiZW5pDQo+ID4gPiA+ID4gPHBhYmVuaUByZWRoYXQuY29tPjsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiA+ID4gPiA+IEJyYW5kZWJ1cmcsIEplc3NlIDxq
ZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IFNyaW5pdmFzLCBTdXJlc2gNCj4gPiA+ID4gPiA8
c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4sIFRpbSBDIDx0aW0uYy5jaGVuQGludGVs
LmNvbT47DQo+ID4gPiA+ID4gWW91LCBMaXpoZW4gPGxpemhlbi55b3VAaW50ZWwuY29tPjsgZXJp
Yy5kdW1hemV0QGdtYWlsLmNvbTsNCj4gPiA+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+
ID4gPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+
c2tfZm9yd2FyZF9hbGxvYw0KPiA+ID4gPiA+IGFzIGEgcHJvcGVyIHNpemUNCj4gPiA+ID4gPg0K
PiA+ID4gPiA+ICtsaW51eC1tbSAmIGNncm91cA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhyZWFk
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzA1MDgwMjA4MDEuMTA3MDItMS0NCj4g
PiA+ID4gPiBjYXRoeS56aGFuZ0BpbnRlbC5jb20vDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBPbiBU
dWUsIE1heSA5LCAyMDIzIGF0IDg6NDPigK9BTSBFcmljIER1bWF6ZXQNCj4gPiA+ID4gPiA8ZWR1
bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gPiA+ID4gPiB3cm90ZToNCj4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4gWy4uLl0NCj4gPiA+ID4gPiA+IFNvbWUgbW0gZXhwZXJ0cyBzaG91bGQgY2hpbWUgaW4sIHRo
aXMgaXMgbm90IGEgbmV0d29ya2luZyBpc3N1ZS4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE1vc3Qg
b2YgdGhlIE1NIGZvbGtzIGFyZSBidXN5IGluIExTRk1NIHRoaXMgd2Vlay4gSSB3aWxsIHRha2Ug
YQ0KPiA+ID4gPiA+IGxvb2sgYXQgdGhpcyBzb29uLg0K

