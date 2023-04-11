Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC05C6DE81A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDKXky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKXkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:40:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E160040CA;
        Tue, 11 Apr 2023 16:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256452; x=1712792452;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ub+luRHB1aFAMKcXXPUUuDMrnGzVkslw+X3kwld1d0E=;
  b=XhKsijMHxynOFpNOIY5CrwgVdjMAvC+SKekRsLUbLuZqm/mYJ2QtgBPq
   N/NRPFIn7f4aVKrbggzg3dqyPVZifhJFLS3DplVVE0HOS4uOi1aHuTXS1
   MvqLEn3ZSe0bxXWY2C9KO7X7Omo5yEePOralaedpEeA+9ZBZLKXWnima6
   K+CqVKzSW03hO1wayRXGF/JIFdBrPfP/i/gh2hrPPJkw1J8Y1hb+mMerJ
   789OKNmiStnaVGmCECIvP4TeWMwAV30MUv+JhNuKH8B8OKFq/7oreXDUw
   iENkzjdJ1YsXytlsIPNU5bXuAOnmo0PcBSNwnOEDyI7nsXOgStm1yRbva
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346435397"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="346435397"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:40:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="666139095"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="666139095"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 11 Apr 2023 16:40:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:40:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:40:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:40:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:40:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vkcaj14MVKQzDDQksd1uZmwmX0HmkqucC96htUWomIsWeINxvIFa5oiehF8zu1K2J1Lonl07RjX4SqkHwI002RKiNE0nrjzRxAIQRkOk4DlBDuhj92IJnNdddq5oEIL07HYeSxOzeF/kw3usHhS3ygzmQUsqKaMGXSdRPzgn811GdTkkfu6dAyt6zeMBpy2DSaaSINW3yY8IFlGyhlXQ+EDFMF3Q8Eb9yHUWLYKdw2aDZbLIE/lCY7g8av70WsDhB/kRIkPVCKB/MD+YvnpYv6Dvm8feaNXaGx1yzo8J4NTfgLNoQ1z7bMsXZzLTwFoPVnkq82+SVyBtMkjbqISVSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fp0rdeOdqCqT1LptCsZXgCGtzrYIEl6lYEEVQ+PIu5E=;
 b=SYpYe5VThM1vDiaqcd5EJ0+TutdKXdR8G4b9SCV78bXgWSxUIqoHU8rOK1V8DDzk9Zi9jNh0H1L//3ZZx6yZ0rCxvaWt6kEin6ZL5BhzazivrexXJOIyg1iBefaqcHCXoPEF5YLTpqDbJCAo+79/O+1S2H6VhJD62kRPIaPWZ/R1EAdxkguwZwazsxujTgNTUDKS/kA8IxTJmoQ1E6Nl8cTlLpWT6rjby8azIXFFDdYeyzjqAmoylG0YX3lGfzm4ivUviX1XmD/EpUgiCEB3Yy8wzbSUQSQJtkmYzXhr9juLRnefkBnGJXykqUL78wb+B7g9QpRtAqvtfWi95o/IFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by PH0PR11MB5902.namprd11.prod.outlook.com (2603:10b6:510:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 23:40:35 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:40:35 +0000
Message-ID: <286f6c3b-2398-56ef-d29f-49321229bdeb@intel.com>
Date:   Tue, 11 Apr 2023 16:40:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 08/12] net: stmmac: Pass stmmac_priv in some
 callbacks
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <vkoul@kernel.org>, <bhupesh.sharma@linaro.org>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <mturquette@baylibre.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <veekhee@apple.com>,
        <tee.min.tan@linux.intel.com>, <mohammad.athari.ismail@intel.com>,
        <jonathanh@nvidia.com>, <ruppala@nvidia.com>, <bmasney@redhat.com>,
        <andrey.konovalov@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <ncai@quicinc.com>,
        <jsuraj@qti.qualcomm.com>, <hisunil@quicinc.com>,
        <echanude@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
 <20230411200409.455355-9-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-9-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0008.prod.exchangelabs.com (2603:10b6:a02:80::21)
 To CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|PH0PR11MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: fb94bb60-82d3-4516-1af8-08db3ae62570
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZT5ojzCNzuVJU2HflXh33GBhz19x2FYdsjRHaieIkscxZI+D7qEmAWvP1WhHSAwgu7SElWfkxx/v5OmDHkrlfthx5zIyu4uSxysm8LbrXAfTsUZutbzHYe8mAaspAz8AXnBjlplfLhoOB8pxBHyl7kTiITrmVHX6EYSoVa9JzbDpLbtqRVT+Y7Li/b+3iePhkdxN5I0lf3oG2wrhAU+SsPDGhcZ1d18eVz8gUU7nOx26iHAFNIDjeOxQtFWCO7oXsNG2YcOVMyecPnLKezqKP575ZOEJWmZROfoEJ2TjcP1DangHmt3CQ5QgVKnHoA4KX8OCPbCAXSRbrV5yZ4Us5OhNfEF1yU41AtR6NwZ/uy2F4Ow1hVmMv7hPc5CYG/2cCqEkZ0Is+58Xaa4JoZl8b8nHZg1MPLvnEawf5YK9HZfO5t0fKbUbxQuW3CKMoKCijffpF1TbZyBB+uPr1MT//VMrp7RHbMZPigOFbnSSBqC3mY01YvhJ8A2qszzR2yCjKdWiCqevXXPHRjnbIZXujF2i3sRY8pkbm28G+G5mH6hrW//bE/F8xM0GQ6Q5fQS26X3agNQOcixUsguwx7EZRGpVzworPcBp9hD9zf1CBPYGdpOd11So82xF9syOlMHOoYrN9QAmMM1v5gH9ydZwsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199021)(6666004)(82960400001)(2616005)(478600001)(6486002)(26005)(186003)(6506007)(316002)(6512007)(53546011)(44832011)(2906002)(7416002)(36756003)(5660300002)(38100700002)(7406005)(4744005)(4326008)(41300700001)(66476007)(8936002)(66556008)(66946007)(86362001)(8676002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWU0TW9DVDRlL3pHeHhIbG85S1BDV3lHeExhM1loVE1nblVBdGNYN09wbnYx?=
 =?utf-8?B?Wi9RSTZDZXNXejUzOE1qN0Nkb1BJVkNvMloxZ1RWT2RFcTJFS3cwMVdXaTNM?=
 =?utf-8?B?bitSWkdKN2R5QzVxcmlKRjFwU255QmZNWDRtNDIvUUZxQ3JuYlNqQTlzZzJk?=
 =?utf-8?B?M1BuSEZrR2l3NjVrMHFIYmJNWERhOFBhQVA0ZEk5Nml4YkR4NHBPUTR3U09V?=
 =?utf-8?B?OUhDaU9EelBuM3V4WndsZUN6ckVFYVRjOWxIeTV1YS91REJMZ1dDb2FNU1Mx?=
 =?utf-8?B?dDYyVk9HMngyS2VjZnJmbFVjYWNacE1CdzJDTUZHV2tia2FGZjk2bktYR2Vp?=
 =?utf-8?B?TnN1OHgydGwwMmhXajFYZHNtOEw1TTQzcjNjdy9XM3Q3Ulg1S01DSnZucUVu?=
 =?utf-8?B?ajVvSzNVSkdCQjZpN25HbEJINTFVelByK3N6ZEszTDVDeHJyUE1nckhGQllF?=
 =?utf-8?B?c2hxSUduM2hrYjZ0OURvYVdxQUp4aWE5eHZmUWZvZURYVFgrRWFTd3ArOTRi?=
 =?utf-8?B?OVg2eHdFdjhwa1pzVXZTK09ldFZKZk1ZNisyRFJsaFgxRDBERm9ubVJRbGow?=
 =?utf-8?B?QlovczRWajZGOFNIV1dzYWEwamY2elRRN0RUeG42MnFrK3FJNEE3RGZYOUk1?=
 =?utf-8?B?NTdMN2tXR0pNY3NoOTBJQ1V4M1E3dVFGSGt6UDFLQ3A3OEgxY0RicUd0WUh5?=
 =?utf-8?B?SkVsTVFrVnpLSXdRaktkUlFkRUtHZzk3dks0bGY2RTJTOG9aZmZZOFBrL002?=
 =?utf-8?B?ZnRhVGpiZ3dMTDRoZ3pPSDZpYThJRWRSYmQ2ajNWRXU4clNHcFdYSlYyWkIr?=
 =?utf-8?B?WWRVZW5oWXYwSVpQVTBIbysyZW52L1ZCSXJUY0tpdDdpaUNIOWhubDhnRjV3?=
 =?utf-8?B?VjBVMjdScE1qWDE4dG5xNEFFa0dKTUNMRzVkZ25taTlYQjVTL3prV1Yya2Zq?=
 =?utf-8?B?MHgwTUtpTkZWaXRxVzRMQk5hZ2tTdlQ1aEt3eEVTTU9HVWcwbzNydCtNVWRy?=
 =?utf-8?B?NCsveDZhamFVS1hJd1hUbWtBbVozSXJEK1N3bjduQStwNVgxcG50d3paOXk4?=
 =?utf-8?B?Mis2MGs5T0Y2S3I5VnRiaFVCT0pCZ1kzYkxWa2FpZ1dweit2NmRRLzYvazEx?=
 =?utf-8?B?T0dnZGwrVFkvWVlQRGJ0MmtFZ1dlWjBSV2w3SHVId2pCT3RKRjJFb1VUY1VC?=
 =?utf-8?B?bHMzYm1mWWFVT2ppVHJ5SjJyMjRXNDZ5a2VVRERxVElzTHUvVk5UdTFYc0ll?=
 =?utf-8?B?ZjdvMHcrdGNPcWVZTDE3c1VROTRNaCtnN1cvK0h2L2h6VDZqSEpnU1NrM2lr?=
 =?utf-8?B?WjgvSkE0M1ZXRHRIdnJiOE9xNWcxYUVlMlFaRUpvMmdMdUVEVGdmM01GSnRQ?=
 =?utf-8?B?MFh4TWRGRG1xM0FSeVlIOG5DWEJEVlhLQk9CSzRTMEo2OVoyR1RyMTlaTkY1?=
 =?utf-8?B?OUxzS0ZzNTFmS29pcEt6blorL3lXWWxNVmJxUmo5NE45TjJGekNaYzVxcm9l?=
 =?utf-8?B?ZXdFQzlFS1lCRnNpV2xwVDI4dS9CQ1Fnb0ZwYk5OZTNldVp1Z1kzekl4Uzgx?=
 =?utf-8?B?TmgrNWcwekcvVllGWkwwZzE5Zm4yNjRNQkdVV2ZoVVlaRkNCenFjSkJNUHJ6?=
 =?utf-8?B?QjBic0YxeENGN29VRkVtRnFYZXU0NkpUVGRDYXhKUlFSZGRmYWIxRHliRmcy?=
 =?utf-8?B?ZGlGM2NRV2p0RGY4aENQUkcvaDV3N2pWb1R6aFF5UUdHWStJU1c2MWpPd0lL?=
 =?utf-8?B?QTQzOFNiQzMxbHBaUjBLYW1ZRHl3eURPUmxuc2ZhWGliSXpZVXAyQ2VOaE1I?=
 =?utf-8?B?bEJYR253UDBHRmJMdWFKQ2JYdFh3ZUtob3luSlM3bUUyTlk5bWxxbDd6eG9l?=
 =?utf-8?B?Z0VzSkFJQnBBbUZIMHoycDVSMmRGbS94dVhuQ2dJUElUdUR2bllHTUdPV0pS?=
 =?utf-8?B?bitvL1Z0a3dpaHpVY0t2ZG50VmZtSGVEbTI2Y29kZGN0U1Y4TDBDdEc2ZnJt?=
 =?utf-8?B?eGptWDNtWHVndys1SVllTEMrakZtNWVwSCs4MHQvZG1nTXFmNTd0YkpzUkxR?=
 =?utf-8?B?cWJmSlJxbnJqUkUydHJNSDgyN0Nld3RSbjladjBCM3BsdDdva1kyUThmTE9h?=
 =?utf-8?B?TUsydU55WWE5YWZ6ZU9icTE2U1RCanpUSFVLTzg1SFAvY0RkekQ1UFZpYml1?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb94bb60-82d3-4516-1af8-08db3ae62570
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:40:35.3945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gX6gtYM/K4smFkI0YAtesC70OydDN8UaCPUse3PxdmDOOyHXolxSY18qZuuCfAnKefB0IrVYCcGYz6zNPmDwWUgqgvPBXjOP8YIJUECC4MM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> Passing stmmac_priv to some of the callbacks allows hwif implementations
> to grab some data that platforms can customize. Adjust the callbacks
> accordingly in preparation of such a platform customization.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>



