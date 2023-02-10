Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE161692679
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjBJTgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJTgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:36:21 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E552363109
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676057780; x=1707593780;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JuyQLDnLO0DkR6gk8g4eSEvtP4aK+NH4HwHK6QZEEEM=;
  b=dxXnw/FIJ3DEEwQrFhVLJF9lU7C12+9hwUIxG6KTAEPirZBnAW04bbtO
   Pf8OzsLulJQ826nScOwoH8rxe0gKpWVNonSWFGYbb05Lf2wT7+F2S1Zip
   HrZ05Iobc1tM7+zIjan6cWh0H2+N3Nxh27rWuUakMOv+n9SewwUibEw57
   1sHbqY1fAZK8SDdZYrXbYfrmeoeS41N3PTmtI4LFvnYhGgf61coOfdW6M
   obaXtSNnzwvK5/1AirIoTMA68tZdi7LWZfa8/sNdVW1DhXszqgo6SiL/T
   NIxC0sP3ZtCzyftsPYnjtN4RsY4QnVcz0xOxG3AUpQOBeR0448pTh1rZ2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="331813355"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="331813355"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:36:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="736838142"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="736838142"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 10 Feb 2023 11:36:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:36:18 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:36:18 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:36:18 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:36:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNX/DT1nzAXYkh4uYia5GuYm0cDlIl6OlKwTBD49eIWkhLmrLDhnPbs+un/DeRQxF2W7/w0q4alkakP6cKuE8ICW/JEHqLlQXEo/FQhKYEKJxbwSruY95DXZIv9imBjexbWKR94nLUg8V1p3AvDip0lv2GzNgplrLpnCK0m960SjP/oBKrUoZ3UsRIvgX4/1Y1ciaJMjk6aqM4YJtGWgyDsYX6t0XuYnUz34bO5yJZU9VJxZEDJUTVEdgl9XQVmcFokW81qkJu3+Su7WQpB/Me4nmL+s1GW1qkKlyPZLsIpnM9Gzdkovle3vjyWJPzRmmmlqNWsNC2eEFa25awuOeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvtA4mj7NUPCNNdUw/NHia3cxbTyUvs0+Gc2RaRwRds=;
 b=CTMOzRbIiPyJf8qX3BXLgKIhMSoYJegcSGbE8ksJSs8/ffHhyqqu33MVNaZxCvbzQlC04YQmtPoly26bjX7rgAs7J/MSR/gE6s202GaWlFeeEW434SHDmySuIJUNf2YBbR77DCHDbFUzgt1WDcrXy9OJMTSQkxF9aLeQfJAPS89CcDkgQxXd6MoEoai5SBY0kDGvwGIz1PG84MrAv+sMpbOUqAC+d394yLlXlPT+Ji9tqqU1KBmIxLUitKhIn3GdrpakjMr4/9pWNdvVxwZfkcnF/uzVH84xBro1BwqAZqBPO/pWSGoKEk8Jr60P+SlE8GPNzSlrugWKpLGzghm3tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM8PR11MB5606.namprd11.prod.outlook.com (2603:10b6:8:3c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 10 Feb
 2023 19:36:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:36:17 +0000
Message-ID: <21fef7cf-80a7-5f11-fa86-c4d4fa424d25@intel.com>
Date:   Fri, 10 Feb 2023 11:36:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v2 4/7] devlink: use xa_for_each_start() helper
 in devlink_nl_cmd_port_get_dump_one()
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <gal@nvidia.com>, <kim.phillips@amd.com>, <moshe@nvidia.com>,
        <simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-5-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230210100131.3088240-5-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0053.namprd17.prod.outlook.com
 (2603:10b6:a03:167::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM8PR11MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: 541e429c-638c-4a0f-edfb-08db0b9e13bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39f9ekBsrLTFebStcSXZQuoXYUfECdVjDEmPRHpmDRzO+BY95VxnlUHl/HDEoWaH7nnaFrzSX6R3KaSzK5QNSkOgI75CEj0l40TPpSGXd3Rzwd2xzce67HEqDKQhYYR6oZ4mIo6Ila59+6YjocPJlLMN0NmJWHiG0I5PssTVIYczmoHhbEXHiMePTLhRdsGeqD3siW3u/H6Q3T5V3IJtN7UpxeZqOACvnBD0R8huilKi9dSGp98prXLBCPQHhmoLYnPpM9eCnqMnRqIDM2NjyJKSoSo40klXidaQlZB4mrRf4mkXgeJUG4PjDke4cGGisLEi1P5Y1OEuZwCdgnbpJFSm2hSDG9QZYl0TZ2VEcS6Ar1024F8kUmDSYz0lQB8ou5KqdM/AaEnrIT1ONWqDcq49WXijq71LHhEReYBC+MCcb5AJ8phJw0idHaMOqNcFe6VVL0aNzdORAt3B1surwVZ7ueJkPunsjpgmZSAG+6t7Nx90QaDicHNx26Me+Pd0UVkhyUPVK8/3J9/zvavBqwXr5M1Edi8jsg5QIw/y7kKGRKmax6FuHacoXBecZrCU6FXMNLnEVgAk+s3nnaYvOs0krXfdGGtw/I61Kmz0gGLKWi4j62s0CSTG4G+buWmOWhxEzJfF3wFN0ZDjObyJ20rqmlm6heGtxulS0q8xTWQ2Ak6Ro9q7RnsSHMzD6lK51Gm0FSq+IbH81QTkaXzOhj0rkw8lHEyFmegNe12fp88=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199018)(31686004)(41300700001)(8936002)(316002)(8676002)(186003)(4326008)(4744005)(5660300002)(66946007)(7416002)(66476007)(66556008)(2906002)(6512007)(26005)(6486002)(478600001)(53546011)(6666004)(6506007)(2616005)(36756003)(31696002)(82960400001)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm9PV0pkUE4wOHhJcUFweWV1L0tEUUMyc0VhaVVOL3VjbHRyenU1WndSU0Vs?=
 =?utf-8?B?dThrZGZMRGx5TENUdVJDY1BiQVY5MkErU2I3dHVYZjZTODM5ZndLYUYzZDNl?=
 =?utf-8?B?dVlxUzBPK1kxSFRVcXJOMWQ1Rm1BV2tYVXd1RnhidWppc3NEVWpOYnRFMDhK?=
 =?utf-8?B?UXc4Q1ZISGlUL091TkwrMEJub3BFR2xHa1JJeW5JNEFzYTJWNTJkNG9VVmVR?=
 =?utf-8?B?aTRsZEJzSjg5ZmY3Y0Y3SnQwNUFyT1BYUlRueUFJWFRGaWNNV3FFMllRWlhs?=
 =?utf-8?B?U1RvR3F4Vnc1MmVjcWtxck51Y2p4VEV3Z1R0T3VzcE01SlIxR2xMdlM1a29m?=
 =?utf-8?B?dldxa3ZlQWlqL3I4dGRYK3hkeUFZdDhHOWFYQ2hnY2JmSDAvL2loTWtJMm5K?=
 =?utf-8?B?cGVNUTdqOVFiVmZvRTl4ZXdjMjVwRjR2eVpEeU9tZGRqaVJYMU5WMWRmWEFM?=
 =?utf-8?B?KzFwT1piWUJlUnJPeDlTQnl1eGZhZlBYNzRBSjQ5akluQ21Uc1Z4OG11OXda?=
 =?utf-8?B?bkUxNHhKdHdqTVpNcGZqVjlYcUt0M09HRGgzdm9WcWF5YnNFaEtVWXl1S2N1?=
 =?utf-8?B?QmhMN3FuaGpkTGNRVTZXQk5TUWt5RmFzUjBieVZPSzFHWUFXc05JSFBYcjQ0?=
 =?utf-8?B?NVFCaGUvMUFDcDJCVXh6MGV4OEVJcmNjczQ0ZERKZ0N1S295UGhQazM3Mm5m?=
 =?utf-8?B?VzBHOEZ4VlFRMXlZV2I5WHE5RW5uWFdETmUydDdvTGFITTAyUHdBMHNEaWgx?=
 =?utf-8?B?MUVCaXl4S3E4VHFPY1hKSTR6RnY1ZGhoZ29zRmExYklyNCtOa3lpSk0vTi91?=
 =?utf-8?B?Y0dCcTRjTTFBbkdOMklZbENBRTg4Vm9SQlNDZTFRRlhEWlUwc2ljUVNjUFBG?=
 =?utf-8?B?SVkrdzBjOVA1eDkwYTA5aDZvckt3U3k0bEVlVFV1RUdQWWRBUHkwTEh5MThM?=
 =?utf-8?B?VVhmaUZBZXF1Z21lVWVGd1FTTnZ5NlJXSVdwOEhaMWpoRXh6U3h0MC9RcWdx?=
 =?utf-8?B?Rk1mTDNyMGxyS2xwK3FpSXF5TTQwd1ZqOGE3eG8wald0aFNpaFdrUVJ5cXRj?=
 =?utf-8?B?L0lRVCtwS1RrL01tOVdxbWpkRmdXV3hhVnVOOEpJU0xsOFo4dWpOTjZTeU16?=
 =?utf-8?B?dTJsbnE1My92VEtGNENTWXl1RmNKN3A2QnY3a2pzc3ZkWWtBQXowTjFDNmJU?=
 =?utf-8?B?QTRyOTZPYXl6ZW03cEJwcnVlV3JZMTd6eTBYYzVrRVNJT3JjUnhkQmN4UStk?=
 =?utf-8?B?T05KNG1CRldLdUJ0dzVrUEJIeG9tbUV2WkwyWjR3TDQwMkFMb0JzVUcwN2Z0?=
 =?utf-8?B?eFJnUi9QMUpFNkd2QWtRMG5LcVZIT1lkYXdGZlNxL2lFOVVaQzNCcXJTR1VS?=
 =?utf-8?B?eTlBcmJzeHFoVTJQWkc2SXZYK2s5N1dsdmZTaXZ1RHBDQ3VYTnJMSjhJZm1j?=
 =?utf-8?B?bHdJWmJZeXNHSkFObkJaQldYWEhaR2JYVVFVdDkxZGVsMWhpWFFjV1RFZEo0?=
 =?utf-8?B?ODdIbDEvd0dRUlNTSEVHNjFZdjB0QTBCNjJWQjZpTVVvT1pmV0pqWUc3S2pO?=
 =?utf-8?B?bThvdHdlN2NWQXBTTTd1NG9Xa2orZkJaWnVYOWZBWXVhNllXSS80V2c4YUEy?=
 =?utf-8?B?Y2M1bWgrVm5WQlRBT1dRRXMrT24wRG1iNW12cXBCU3NodjNOK0RSMGM4bzQw?=
 =?utf-8?B?YkUzdThFS2hDbHJHdTFjM2FYUlUrczcwMmVCUDEveXNZNjF5NkFsM1pEL1E3?=
 =?utf-8?B?dnNRakNJcjNBQ0lkVER1dXcra2FkNGZSalhnWHdZRkZBbzdxOHptdGd1U3Zw?=
 =?utf-8?B?aXlQbzE3RlR2WGsyYXdCQmRtbUxrRVlqcDMrK0diMlNoUHNrVnZzRDlrTzEv?=
 =?utf-8?B?K01ndVBFQlB2TXdjb1I4WjBCSEdFR1lMSGlEZWwwYzI2aWF0WnRuZlphYjFO?=
 =?utf-8?B?YzJFUGM3emtBOGw3b3UyWVY2blVJYlFqZnlZWnZMQ05VL1MwR0NabFVyeXll?=
 =?utf-8?B?RkRIN0NaOFkvWTZKSGR6MEVnd2dVTG9YZnAwaysyYUZIM1lvZHE3QnVWcWYr?=
 =?utf-8?B?cm1nZHl3THhzckpMOU5haTZEWTA4VHBjR2VTK3EvZUtVVG5Mc3pERkRhdkMy?=
 =?utf-8?B?MDZnd3hqcm1zVDd2S29VenFLTlN1c3JIYXowaWpmYWVMYnlhTkNKelBNanJL?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 541e429c-638c-4a0f-edfb-08db0b9e13bb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:36:16.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g08i8BGj+lV1CZ/0sw3IKTr5GVe1xETqaxkQ0aRbSwigrcOgAqhT5CRRTHGmDuvItvF0uDc0l4yENy4L09FYMePRtyjmDaf2s+hmXqwsPVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5606
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2023 2:01 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As xarray has an iterator helper that allows to start from specified
> index, use this directly and avoid repeated iteration from 0.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
