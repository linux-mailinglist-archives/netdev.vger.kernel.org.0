Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EBF4E9FB5
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 21:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiC1TXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 15:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbiC1TXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 15:23:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBA75DE59;
        Mon, 28 Mar 2022 12:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648495321; x=1680031321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+wo+B+VkDKW8Hlrtt1Qg15BHF4lhaR0atY1jmoMdr8c=;
  b=RsQNkzaAHgj2zUT25VVFOD9xO1mr7X3YQgR4kfMJdLV9EfpKJoheHa0w
   A9wPNtZXdAy3dJK8Hz8aentdbRH+tfSpm4CuVfqxHnDdcinHn/n2k3t+P
   kUB+7oeZUuW0RxKHU8yLZoWpPpSveJFrDpYtjyhIDkNTVLqtNpYoB/ST4
   301pcgatqAxE996MfP9EjjKW9+V/KlMmaEiMJTlfDDYH9AnSffLkzgEZL
   OtnE3EOzybiHwSAoZqhJopZiu4M9EzycA5sUPs9kP87jlNw2T6I/Z9kOj
   V6PtVwdVk1EYNeMafT5E/aPx3dHLgAf4IlO/Ro4Fez9GXhCDsKTEFKT8D
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="239019184"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="239019184"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 12:22:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="563932105"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 28 Mar 2022 12:22:00 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 12:21:59 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 12:21:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 12:21:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 12:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmjBDa8LiwNFrhX4D6fat9H0at+mlrbHJ9FMgHZQ6ydJHNvTd8XEQq89Yi9P+Rp3UNn4DEPzhhrDLENEUpB+OOBVoqAKRf9sZzzk0pfjqYaX97CQ6tnukjg33GBL+asPLqRioYaQPeM5oCN2rplWzLehIYrZH3CneInQKlF0+E3jO8uXnHsswq7OimxkrlqgyF6QesNOKOthxiqB+wiH2a8shAlygJGG1RVde6i+syNTgjiDaPFzTeEHo6hJKpkmCD5DH+3A83HHhpWPW0+clcvjDGu83fau9bNrg7gB5dXoq+/MOy4WshbhDQguGtP+9rzqrmBRq/cKWeMeqCt1+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wo+B+VkDKW8Hlrtt1Qg15BHF4lhaR0atY1jmoMdr8c=;
 b=B56adAoVtaw2VsD9rRwP2S43+H1UJ+MqGlJwJd4WSONcj5iFEo3dgw7mZIyiSz1OXxuvnCp30E0P3J17z7jd6yZGOw+ep+HewNimytf+4CPofPU+MgvJ1ytIRtSLfgJoagNWTEt02Gt5RYZLMfUe4eQUHKhtPObu6+sbgcThvFlB5/eOqHtEm2d3NupYHEGh5II43+ksaOG8ps7Gow1KX+QNeF2lNMJ6mveMb8SFbOnzbbO1AhK3j6TrGjDHXJ7DgqGDE2VWVKoxbD8qBlr2Bn0f/BraFTg3oVyb2FKaPkmYQU0iz1QgFkPgBVNFPQGcX5XFvgKl6W/d/xuBYW4w7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by DM5PR11MB1387.namprd11.prod.outlook.com (2603:10b6:3:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Mon, 28 Mar 2022 19:21:56 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b%3]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 19:21:56 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "songliubraving@fb.com" <songliubraving@fb.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel-team@fb.com" <Kernel-team@fb.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "song@kernel.org" <song@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Thread-Topic: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Thread-Index: AQHYQUHaMwdgdM+QqE+pJQTm0HeJQqzTCmuAgAFPrACAANWSAA==
Date:   Mon, 28 Mar 2022 19:21:56 +0000
Message-ID: <24f39339c3371cd63fa959f33c1bab33c19ac51f.camel@intel.com>
References: <20220204185742.271030-1-song@kernel.org>
         <20220204185742.271030-2-song@kernel.org>
         <14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de>
         <7edcd673-decf-7b4e-1f6e-f2e0e26f757a@molgen.mpg.de>
         <7F597B8E-72B3-402B-BD46-4C7F13A5D7BD@fb.com>
In-Reply-To: <7F597B8E-72B3-402B-BD46-4C7F13A5D7BD@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4245d688-49ae-4fea-5e5d-08da10f0397a
x-ms-traffictypediagnostic: DM5PR11MB1387:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1387D3CFF6D1E08FAFF66BA3C91D9@DM5PR11MB1387.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H5GDojuaPMBjCm8Q+Erv1zGaTbK+HbsCQBgkJzO8AJDPLiF3K6AvH4VgRSRr/Sk3JJz0JOFKSzwOZ5htaVHyJlwW1dZm12oJQDjCVp4FBYMUKlttMH4GHCsoiUWmOTk0WGNe7CaefKcoqrqo3yz69k1IMfWMALP2yI3kJIgD2pS/2KNezaE/y8H7WdXTJln9ZPz+Whv+4N6hnnW3965r/+TAtUfFBGl+CSAt+89qad6Iy7Z3HDE4t5c5w9aMDaBjyCDyRsapLcki/lQFv51oJqH0VPwQGHIRQQgIwvK+ufLSU8MsHGnNMVE04n4Qhe0UmOZYXtAS3xBn/Pe1+qG9suAHpfSUz+oa5c2KYYAR3QkgM6bGyhP0MfCmWYCoUHTn4nVLb/E7ZclFVpA53QhN0AWLlXeftZpUt2zr0oCSUIGBx9cAtzxPdGaFzGiF566vkgHquHyZJRcGBEaGRzGU5nkdSlS5w/6dHwlHvjW6UuHNIbU5ToB0jFQMb6GecihFTu1XWUW/j9FvkHlbOVRWnm+ibNazxQpbP2fCrKR2HqtAKMVDEt9c3+UrGaZ8noBQjycy28dnJJdrENdphQVMRJAe+LGL1BExRQgvspviD270YjsdTChAIQVusWrhODi98ehquHYSZ734Kirac2Ba1Q5km97cb4451N2Arfdw36CSKYWT62z72cePDLkM90v/r2colpoYVEXsrg7gzh0sDEeC8/c5/vtVV3b1PU9kO6mLF2xW7w4Ag+Ap9f2a2j3B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(110136005)(38100700002)(7416002)(6512007)(54906003)(5660300002)(316002)(26005)(4744005)(38070700005)(8936002)(186003)(82960400001)(4326008)(71200400001)(6506007)(122000001)(2906002)(8676002)(76116006)(64756008)(66476007)(508600001)(66946007)(66556008)(66446008)(2616005)(6486002)(36756003)(99106002)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjRhRHBmbmZZOTFBVWdlZG5DMGZVN09VekdPOTRGWisrem5XWm8rT2tFWUhR?=
 =?utf-8?B?M200d1pxWnBGZWpBMTNmTW5KREwvWG5kQ1Z0MmtpVjVoSzlKeitGTkorUUZt?=
 =?utf-8?B?UGdXdE82OVZ4M0xNTW9OejBWcFdKZ3BBaFMwUEhDQlc2ZVMvWU9tUFkyeDVW?=
 =?utf-8?B?Z2RienZ2TmxNWTVXb0VUc2NFc1JZWnFyMjFUNXg2TW5iZFFERkQ2U0NtcnlT?=
 =?utf-8?B?ZENrZGQ5VVVKRXVVODJGVlJTNlRLenpmVUVidll2d1VHTlR4R0NzelU4cFEr?=
 =?utf-8?B?YzBiMzhtU0kzZGNva3pDcXpocGtJb0dTcGlFSDYxakZDU3Vzam9udHRROG9u?=
 =?utf-8?B?WnJDTzUzN0w1Y29HVXVjaU96UVBldFVZY1BRZ3VpVlJTdFh5bk5ZbzFtMkRw?=
 =?utf-8?B?bmhCQ0c1SmZLMTRFdU5YamVkdG9JeEFvSzhmSVJnY1VBQ0dIRXlIT3BhQXFI?=
 =?utf-8?B?a2xyOXBmOGRmbUNkTURkQzVpQzk4NEk0TEFrcHpVTkxQcXJZU095N3BxUjN0?=
 =?utf-8?B?Zld5K1IvU2pRN3pQb2diNW1Xcm9Bb204eXJkTXpFZGFRY3hBTmlaTHBBeEpH?=
 =?utf-8?B?UUZCM0ZFSkZELytsTFB4TDRtSm1kUUxUUDNWWnF0dWtmSlplZDhTRkh1clFP?=
 =?utf-8?B?MHkreGxiTzdYZzJ6U0NQWHJkNm5aQlJnMElzRWdDUm9nZENDNFNkNk9ScjJL?=
 =?utf-8?B?T1pYWWpZWGp2UXlpbGJieEltVzdYMjgxc3ovdWJ5a1UveGU0bGNJRk5jb09F?=
 =?utf-8?B?NXZlbEx3SHdMQ1ZqTmlHSjF1aFFYUWFHNTFNSy9TMElaVjJ2S1Rxc2VTRkdt?=
 =?utf-8?B?NkEwRG1VcXlDT1ZWZCtzc0dyak13bkpoOG04NStHMktoK2l6YThoMXNSUnQw?=
 =?utf-8?B?TWhWTkx2OHdEU2dCSTFLNHl3MFF3TFpwc1B4TXNDbjlvbTZZVUpBSkxURkRB?=
 =?utf-8?B?V0VBWmVkMUIxd3RqdWQ1SEg1bjk1S1EvZTRLTmJFYUZGZk9hQ0RFYmZUSkZw?=
 =?utf-8?B?enUvTlVwLy9ub0d5T0RNcnhSNU1kNGk3a1ZnZmozUExWL3FHQndZZUlES1Yx?=
 =?utf-8?B?QmExbWpYMVV6RmxoQnE4cHErOUptMXB5TTlNWnhjRFB5dVhVemlvWndXVDlS?=
 =?utf-8?B?YUw0eWh4WUlBTkQ3aytSUGFZRWExbUgvb0g0bDl2ZjZMcmJhYkhNZnFWL2Fz?=
 =?utf-8?B?QTJsUUovUmFDbWVYTmYxRzlQTk9kMVpLa01JRjRsSUo2dkl1ZWlNcERrbTdO?=
 =?utf-8?B?b2MvdFhlQ21rUHBhbXVVNlJoeHRvemFZN0RQZ293RDFRKzBjY1NDcmM0UVJj?=
 =?utf-8?B?elhzWGVCZFFFYlE3TTZRdmltZkttS3RNSW9yNXpNenVwWUF6K1FIVmswWFRk?=
 =?utf-8?B?UnNwQ012NGh2aFdvbFlya3BucC94T3d1dDRjUlI2eXdKbmFVLzF3N3hkTXF2?=
 =?utf-8?B?UTVPamhlRGVaNHBXWXFvNEliTHdQN25QUkhYdkhLM1JtejNZNW84Q2pFNG5J?=
 =?utf-8?B?bXV1MnoyTlVCYllBUjk0cFRUYXpRcVhJOVRselkxOCtUaUM5WnBtU1hSTXpK?=
 =?utf-8?B?ZGtmaURnVDNJMHRoaGd6KzNoYkdwWDdMTU1vMWkyRmtac0lTN3gwZDNVNkdi?=
 =?utf-8?B?bnE3c3hkM1dHd0FZU3VSSEdSUXU5eUFzSXlXclhBU3pweWVOSXl1TlpCMk1m?=
 =?utf-8?B?RG15anp1bmNtT09BSzdqYlhnUzR4bzFZRVhVOUJIeDZEWEJDNS9FbGF2VkZW?=
 =?utf-8?B?ODRuaWZqRTUyRlorNlcvWTNDdENtUnJoR1BTbFpaSHYxd080YmI5Um9JNWth?=
 =?utf-8?B?dWl5Tm9hbktBNGlTOS92blZqZUtycnRVRjZubnZoeUJBamhPT3hUTzB0NmJn?=
 =?utf-8?B?WU43OC9UWmdKMVhHYUJhTDhXaEhhYTJiT3JHN0hZVVhpRTlGbVRoQktjemJv?=
 =?utf-8?B?ZzBpcE1tODBiSnVJV0dENkY2Tk82MVFVdUVKdmNTbkRmdnRpd1A0V1NvQlZW?=
 =?utf-8?B?ayt4L0R4RVUxZXZZL3N3L3dlcFZLbVk3NEQ3OWJOZjJJWng1Z2RuREtaWWVa?=
 =?utf-8?B?VEtMYVFkSnZ5U2RBNkhCSUUwMnlFRzBkQnZxVElRRTRLVExhWWdpOUZ1UURG?=
 =?utf-8?B?TmJNYlVMcFNzRHM0YkhBZU5HWGRGOEM0UHNnSS9HUGZUK1VQSlhjQjY0Zmt5?=
 =?utf-8?B?cy9MdXRBTlYwU3hSQUR3WjJBemhCRCtsR1ZUREhLQVh0NmszWm0zOVg1T1VQ?=
 =?utf-8?B?SnhYYWtaRUlNa2JYaFhSYkpoVFBWQ3lwaStkUkFyR0hwOStiN3ZXZ2FlVU5G?=
 =?utf-8?B?R2NSUHhlT0FjazVsSzZSMUVjZHZ5V090eHBvM3ZwbWJkOWF1ZDFEbGxDTHg5?=
 =?utf-8?Q?9mPLfjdKDngm31SvStKLWpVg2YVOfnfg7a8yM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78C8E5B0594A3C4F87B2EC1D268F175A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4245d688-49ae-4fea-5e5d-08da10f0397a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 19:21:56.6206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PuV78PtZ+Hm5wMsjjMrGpoqc4r+cKtSJNp2mgKTOgINSNuCm8lTntg0Ki5k1HSvNPacvUl6o4NGem5HVWQeTmoHlFBzBjB/cK7ypNseTQSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1387
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTI4IGF0IDA2OjM3ICswMDAwLCBTb25nIExpdSB3cm90ZToNCj4gKyBS
aWNrLCB3aG8gaGlnaGxpZ2h0ZWQgc29tZSBwb3RlbnRpYWwgaXNzdWVzIHdpdGggdGhpcy4gKGFs
c28NCj4gYXR0YWNoZWQNCj4gdGhlIHN0YWNrIHRyYWNlKS4NCg0KWWVhLCB0aGlzIGxvb2tzIGxp
a2Ugc29tZXRoaW5nIGVsc2UuIEp1c3QgYSB3aWxkIGd1ZXNzLCBidXQgY291bGQgc29tZQ0Kdm1h
bGxvYygpIGNhbGxlciBiZSBtdWNraW5nIHdpdGggdGhlIHN0cnVjdCBwYWdlIG9mIHRoZSBiYWNr
aW5nDQphbGxvY2F0aW9uIGluIHdheSB0aGF0IHRyaXBzIHVwIGNvbXBvdW5kIHBhZ2VzPw0K
