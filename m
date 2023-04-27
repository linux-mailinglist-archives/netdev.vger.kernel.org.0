Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EBD6EFF71
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbjD0CzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjD0CzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:55:16 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E3A358E
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682564115; x=1714100115;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qHM9qV/uFdyCSQltYHjpqzib+9Fd5H/x4LkyA2xmFr8=;
  b=glAYFEQyjCdC7kbtJ1I1noExsFnKnWJMKF9fbyQlY4fdNvKT6mXmKCeb
   OBtmkBxbh6dNSddoJL3C2xrCKLGMKLc/9sEn2ZJaGUbltj8tUz1/njIZk
   dAOJ1/HDW+xJoc6gVUaFb93i8hJUYNM73E8eQDiTjdDQPI2RO+9fYqfJ7
   TPVdD8dvUaywQ1hCtNQMm9kB19tsoVrmrqqrF66+QJLT3nW2NU0Rv8x6+
   vNO7BWz8hk/ISdK5E0+JPm0YnqtoPu05wA/TvaChRmfkEoOF0rU0S5Fyx
   C3VDBul3t26QDl0LlH8da+JZbRVp6wVhvd9fwy8ElyL2Dk26mRPaFB3nV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="327620636"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="327620636"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 19:55:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="726840494"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="726840494"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 26 Apr 2023 19:55:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 19:55:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 19:55:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 19:55:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuKB9djA6HwW9WOzXNjJdQjPxnURuqStVILSsKaV98UXQhSk553pZh+pSOiQD9TAI4lgp6aK6QcZ8KU0/UsYL/q9qSxv0udV1byKg+bfeJxGAMR600L5e5BiwFY31ieCxqnSjfolEMPMdCOAnrIDq3NByhXSfnlFWWmI7huZMiSNH8FKcED9mtzYuXz6DysgZ7J4D1+fR7RlXEsR7bwYaHiPDDMhw2yDNap5scueReuMla8djZpd8QtH/55vnr4NkldMOFsn7zbtAfBNFrLepC1V6SHTjcF1f4PT5kACZTYuCPYeariTJwFhbRjAeDamaoWLLje3GqyQypCmfnv2HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUaadtOTxl3++qAHEfzpyKqPXrZNNveT8dw8wNGSKxQ=;
 b=XOWV4Vpay4oaAol8/UgiNdOXzvTiVKe3RszS+aOsXlXD2Ktt2NFj4LmR5++sJIwyPufCOK8ll53L5xfWRALq3OVRvGx65OPahKHJBbIF0rc5kixiDlSzXGcwqZHoIzH3Lefm8UcMioY/d06sAL3fWDhB82qmbrMQIiMScJG3pUD7YReqcvT0Nmni3T4Z/HdDF6n6tcAyoNpfbWeXPEQDoRB997p0PV8I77UBhrP5bV0iu+U3stdxGjV937MASzE5TRuutAMS1itKf51xUG4AdKSCcLDi6cSCXgww6z4wmWJp/3VyPN2dHWuOsVpKJ5vsRVMBd0Wyzq3IJSmAL1e8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SJ0PR11MB5199.namprd11.prod.outlook.com (2603:10b6:a03:2dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Thu, 27 Apr
 2023 02:55:10 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e%7]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 02:55:09 +0000
Message-ID: <97f635bf-a793-7d10-9a5e-2847816dda1d@intel.com>
Date:   Wed, 26 Apr 2023 19:55:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [net-next v3 00/15] Introduce Intel IDPF driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <willemb@google.com>, <decot@google.com>, <pabeni@redhat.com>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <alan.brady@intel.com>, <madhu.chittim@intel.com>,
        <phani.r.burra@intel.com>, <shailendra.bhatnagar@intel.com>,
        <pavan.kumar.linga@intel.com>, <shannon.nelson@amd.com>,
        <simon.horman@corigine.com>, <leon@kernel.org>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230426194623.5b922067@kernel.org>
Content-Language: en-US
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <20230426194623.5b922067@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::23) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SJ0PR11MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: 56aa0a35-3510-49bc-0d34-08db46cad03d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+ieTy23IYckWJQt/Rmyjco+8GsDmkOTQs+gcvhrCjC4Q2+y6q9pfXQj5RZ7mNkPELNsBI8jlBMtmLU9LGgTDv1ucrkB3g3CZeG5mxs3K/veyZYw6Ld0a95Xqt1o2ERymJnjZaUMdxRAuShgS/d7OuI4sx4GC2X/ZN7bahDZRPg6SRIyJeU1iWO/efsxgY7m4QIcO472QmZpiU4X5OIz6Tpj5Svh8nSFj7GXb5xsZIqEfZuJGxil1D0WD0YYOCes/0jMYcyc0y7Dv14VFZRQaizGP30eXiVbKHT83BadLE/o4FuhruRMzZHnOpuOEBw8dHe9xpC/LqzMP9WwqPdtSAbC1/y2Ia7qPmiXpDE2zHCvd92IuppUSDi2JQcWGtzfKIn/wdBAUsoTk4SJ6xYGZZrFbIfaHU0Fk4bK0hS2Dmqq89PgZsiAcA6sj5fiD9xHrW1mhYRGp+vpAU/lC0YWVKZZea2icamsWfQLJQNBCll1NAUgkP/AK1qef+PSbpQTk1LDf+MZL7HslIPZbOB6K8KYAqYbuzmYVh2NUGDPPndAF7lmqVs80e9748lZGkurtXz94oyKhGA1citslTDEVwnQ6FkNK7ztXKinS4adqldZbfTy3EhMBvpYj6vy+yN5O5Nh0FP7AvGZHbB1KKW0MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(2616005)(41300700001)(26005)(53546011)(6512007)(6506007)(82960400001)(5660300002)(8936002)(8676002)(31686004)(83380400001)(7416002)(2906002)(38100700002)(4326008)(316002)(6916009)(66556008)(66946007)(66476007)(66899021)(31696002)(36756003)(478600001)(86362001)(186003)(966005)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFY3V1dUcGlCekZ0SVU3VjFxNXpzUVIxRHNLVnlnQURQOUtGYVRVNlZPVFo2?=
 =?utf-8?B?VFNTcHRHVW1lclNTOXZZcDdVL3NBU0xmazlHNG4xVFovZUUxa0hWT0VpRHho?=
 =?utf-8?B?SWgxWXBlYTlRZHpUUjlmbzc1UHdYNGJIdExBRDNjQXhCdHFUY05NQjdESnZR?=
 =?utf-8?B?TEZmTXJJV3cxbDFrTkF2VnFOSHZ5RTRKSHN1RVZFNVBoY1l4SG02NENOdUZv?=
 =?utf-8?B?UmFIWXdDQUluMFBFOVl6bTNyNCtkUnFVMnF1c2hYb3Erb2FvQzFlOW9CUkZQ?=
 =?utf-8?B?c0tYQlRsR01nM2Z5Y0JNc3Nibzk4RlR4NzdVOWZiUXpENiswMlZFbUlKa2lw?=
 =?utf-8?B?d0tkWTFSa1hibnZ4VTJpTTlDZkQxMHRMOTl5SnB3MVJOQ0RXZ1gweEorZTBD?=
 =?utf-8?B?YjBmWnZ6UzdwT0psVmJZd1VZT1NodTNRU043N1V0aFBBVkFSbzZPM0docit6?=
 =?utf-8?B?MjlpekNTZG5hUkM2aVltQVIvRzRsTkNnSDdlZmJ3b0NWTWlwY2ZlZGsvMVBi?=
 =?utf-8?B?NG1GbGJqRjBGYjdtc29ZdEM5WHRSLzIzbHUyV2YzSklyRG1BcGRiRGR1WXVz?=
 =?utf-8?B?N0hucWgwTkVyZElLM05KU21DMUIzandxdHQrQVpycHo2R0M3bG1KbWkxTmtW?=
 =?utf-8?B?R3NRQytpdEZMb1ZUWlZoUWhzSWdkNFNBZVFaYlJlaVRiZXRzTDl1U3o0SWtI?=
 =?utf-8?B?Uy9wemNmbm5LQk1BZ1VwNDVaR3QrekRCL3VnSDBTa05wL3h0N1R1Z0g4eWdS?=
 =?utf-8?B?ZmQvVTJBVzlNQkZRTkszdEZ3WmprQkFTR3dsSStXbnpWR0VMOFVGWTlua2ZH?=
 =?utf-8?B?MXNTNXVKWDZrSlI3VU8rTTkzMVJBTjIrbk56Q3A0WkoxZFJLejd6TmhsTFpt?=
 =?utf-8?B?WVBXT3cweGFtaEtodnRTaDNRSzh6eFVqVzJYb3FRd090cUNDMUNnU20xS2oz?=
 =?utf-8?B?UmNWWTVEUTJRQ1lHWXNlY0J5cUk4TkJxa0l0c01MT012Y2tBQTYzQy8vWEE4?=
 =?utf-8?B?TkJlSEJ0Z2FHUTFtTnVxUVg4N05XT2RITG9Yc0FBcVFuVFdUVDRYMUt2M2wv?=
 =?utf-8?B?UDNoOWgxYTZVTlR0NXBEckk1SUZ0TmtjRWFMd2VNTDBWQlhTNmNUZXlBdEg0?=
 =?utf-8?B?bWxZVkpVbjZZNTZQSnpORTgyUkhWanVTR1RsQmc4R3BiOU9LZjRuc2FkOTE1?=
 =?utf-8?B?emllWkwyNmVTZ2I3TExhTW5kTmJWTC9Nc1dtZmZpWDBSRlVsSXZTaVczOThS?=
 =?utf-8?B?MmI1UDZSUmx3STR5WjlGc3FhWG1VSngzNEhXdnNUSzZpY0p6bjJwSXdKQ2k2?=
 =?utf-8?B?WHVWd0Z1MVN3UC9Sd3Y5Ly9WYWRNTkFYZmZuMFQwWHA1TWg4OGE2OVVIQ00z?=
 =?utf-8?B?cEtpTDNoU2xxNGtna1dPRlF0Y1M1cGpkMWVqM3NMSmJ0c29lcVRIeGtyN1Fw?=
 =?utf-8?B?QzFqY3ZQQTVBanhKOS9rcDJ1UytNOFc1R2V0NmJkREtmQXJHMFROaWRJbkE4?=
 =?utf-8?B?MEtuY2hoc2lHbStCWlFoYUhTajZUMU82SkFDcW02TjIyQ0FScEwySk01WGJW?=
 =?utf-8?B?OEg4V2lvVmhick95THNTVXZEb1Q5bEN5bC92UW5GUjc2L09SY1dyTFlXVkU1?=
 =?utf-8?B?U2dHUFFVMFFROTh0dWpNNHJ2WnJhS284anIvamM5MmpsN1RSQyswOFNkL2lD?=
 =?utf-8?B?cVkvenI4ai9ZVVhuVU1jUy9zZTFjREVHOTJZb2dwcVdYUkhRTUdEaHFGN3hp?=
 =?utf-8?B?ZmFyY0FUZE55bHlWT1V6aHh4TmZKMXdTcFk2VFdGOTdnVHpUclNsSnRSMDZD?=
 =?utf-8?B?THY1cnpFRllnekJhd0ZXdmRPWFZqcDNrT2Rpdll3OTc2Vlpyb1JSclNFTTFk?=
 =?utf-8?B?R0R6aGpwK3M1VEtiR09zQXZoTFB5aTdWdENQcThyMU9Bc0JvKzFMMk5ia1k3?=
 =?utf-8?B?QUxyVCtNY1N6MGpHYjlVRnQ4K24yMTc4djVDVTRpcEJSVEpCZWRyR294VmU2?=
 =?utf-8?B?bDQ5NnpNZ3JnbDhZdDBGMS9mK1QxMVZkY0NFTDBqZHEzcDdGMksyMjdqNVpi?=
 =?utf-8?B?MUlqZFZway8zR2V5b0hTZVIrOUExMjhweU9WalpqeFdpcHVvanpUQ1pPc0hq?=
 =?utf-8?B?WUIyYkN6bDBnVnJjN1c4WUFreGFvR0hZeHJUWXUrTDRCMFMreFBud1JoSHI1?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56aa0a35-3510-49bc-0d34-08db46cad03d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 02:55:09.6529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yWGvvK+GeWtTazXKv7FsQhETfrZjJFQMdY2gRSv7oSFQL8xCjbSdT5w1X7nzjbLFFcV3q7XVf8BAGsa36D9S6/qDJxRKsAvOnxW+fGOKNUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/2023 7:46 PM, Jakub Kicinski wrote:
> On Wed, 26 Apr 2023 19:09:02 -0700 Emil Tantilov wrote:
>> This patch series introduces the Intel Infrastructure Data Path Function
>> (IDPF) driver. It is used for both physical and virtual functions. Except
>> for some of the device operations the rest of the functionality is the
>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
>> structures defined in the virtchnl2 header file which helps the driver
>> to learn the capabilities and register offsets from the device
>> Control Plane (CP) instead of assuming the default values.
> 
> This is not the right time to post patches, see below.
> 
> Please have Tony/Jesse take over posting of this code to the list
> going forward. Intel has a history of putting upstream training on
> the community, we're not going thru this again.
> 
> 
> ## Form letter - net-next-closed
> 
> The merge window for v6.3 has begun and therefore net-next is closed
> for new drivers, features, code refactoring and optimizations.
> We are currently accepting bug fixes only.
> 
> Please repost when net-next reopens after May 8th.
> 
> RFC patches sent for review only are obviously welcome at any time.
> 
> See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle

The v3 series are primarily for review on IWL (to intel-wired-lan, 
netdev cc-ed) as follow up for the feedback we received on v2.

Was I not supposed to cc netdev in the quiet period?

Thanks,
Emil
