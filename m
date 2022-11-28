Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D405B63B61D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiK1XrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK1Xqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:46:54 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C822DA8F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669679210; x=1701215210;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/b357QJsEDSacm5lvlkdjkfg2dNHcFgWlALxWh3ijYg=;
  b=cyPrBAKTRSvtCKH6Wuhi8c6Db1EiBVXLbRTarMnEoA9WR1d8UnUfyuNQ
   SfZLz7ZnVoqkxJt/oKjJ8CKQjpoV2ufC+kUTlvRRCiJkNLNd689FKp3vu
   emWHW7FM4XRqzaBv8M+0Vm/59Hkp6W+Fvcl0dG8Ayr3gcfTZJmHcCtcdm
   CqVPQrMxSzIIyLXnHz2DQ97G8PjoDAH3hLue+m8ATYMH6aG3BvnxWlWFx
   zma+hOBipBlyjxxmRmdFbbbWWT9ztrBPpbyCdTZ6Pd3h00Fw/iugp9EqF
   qgoBsIQSPiNViCo1hIOOtPwMAOdDBdq2F1uwC0Sts0RjW1iKQICbYZOo4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379237278"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379237278"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:46:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="645686184"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="645686184"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 28 Nov 2022 15:46:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:46:49 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:46:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:46:48 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jASkz0JfJvenPdLiJUvJUGoYNI2N4H3fqjhfVvJ03msoRENMh25FL743dvFxbsecv80oN7z9eHCe3XlW0gZKHckAXIKpUZJSmvgt4x0QEJxTM60dmhoCWrsBi162Lx08ZAqAd4wwUHi4GhME2WHyF8ORABscdy3n+1Aiznoi0wseAPqmjWthqx8fObZeL5z3Hqg5zHeD2yCHg2qJsJf2ple+RjRNstsJwazbkEEXdBn9hPJwLApSRd1BOtX2o1qrGiiJe0H65z+fWvB7spfPIJqEbVwsXnAUJKp2shYPUu08O5+M7KsiqGCZjBnzC914V7PAz411wLn2eV+rwg1tdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOP29sKJrF5IQ0s8ERZEEe32cAv7izR/w8eOaKdr3NQ=;
 b=gVg0zrXz0231/aUNzWmTH8PH1//G9KxetxjcbuWS+S7p9/cLMaU0OBpvGTZltVpaIKEEqr04G/3q36P+aiH8/J2n+Cc+3wafitFJOp8Jn6ldTxG2pfUQlxujzn5k4biMGgfTZm89m/CtZbu9lvixDwJgg+mUvCiQDBhiK6qodnFk+aNkpuLhHb95uhyLcRx7TdCDlH1JG7WPJwgi7B518vl/lKL3MY+pLG2kBENHWChGcaHYQjb/H0yN0pZ80bWZaXpsy64mdixREOGJwhOJMqUrXI8+vY4RH3oEFX693Gh628K2bXH8NMTZrFLQaV9jIcfnh4AuprvBPf+JaF/u8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB4869.namprd11.prod.outlook.com (2603:10b6:510:41::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:46:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:46:47 +0000
Message-ID: <792053eb-23ce-7e09-0bc1-951d470e03e7@intel.com>
Date:   Mon, 28 Nov 2022 15:46:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] ionic: update MAINTAINERS entry
Content-Language: en-US
To:     Shannon Nelson <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
References: <20221128193910.73152-1-shannon.nelson@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221128193910.73152-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:a03:331::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: fa54de7f-eb95-46fc-446a-08dad19acff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Ps3lVG5OL1961xKwwYMSrVIJbpo1fBiXHiLrTUADlWpyV1Zf5HnoNuR5kpZ5EZFAsTLnF9i9wuA7sN7zYfIi/EfbxLZ9xGSl8EbKKob+csqQ13J51dc40Ws1m3OqJGDymZjVVdCW16ZiM5bkCQnSnd8avur9IA4lD9BF7ZC0yJgHT7n+ZpTbJnt1N5yEfOesHoVE3sa8/q5yXWGHt4xaxWjjT/Lk3p7Y9dBrI8nEatfcx5vKtPgs9BL0A+8xFHH1WBfG4cMcYgdNFkOzXeSjcT1ntLo3Ib9nR+N7XwQQAHpUBeHcDWGFHpHy45jLH9qG76lqxtXqDXLan/Y0xa3IRjSdeb8okx5aLmLo+j6pinVCe+MySWdNb9gFHiXNV9QhaKqpugGivFWdDp3H2t7nBfgo0OCELuLOl/V1OnuiBemjZlwmr2nASVVoOm12NTOvbGwTSAAtoC1LMf9empl6SdGkEy7XUwsLMNzHctXCq55hkTVxI+s/+/DbIfxieDwO9G5dTDqoBMfOANB3eWQtauN34iACuKUNQgvnPRzcZOLD2jTRQ094U1Ok1dgRM/mHYRO+s6+SeguAX0Ke2jix7e98VsebcnDiUl+b7PwZgCkwfUUPbRcnlm+A3ywBTTOa5nGc63aBeprb8Bhdr7+C2m+ZqHUCuOD3IdtdRywyKm6g5PTsQ3QD4zk1mXCYAFwls6NRlUQbRKtpXGw/oJwXnFpp0KkgHJ4SWnWI2McS2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(186003)(2616005)(31686004)(86362001)(478600001)(316002)(31696002)(82960400001)(36756003)(38100700002)(83380400001)(53546011)(26005)(6512007)(6506007)(15650500001)(4744005)(2906002)(6486002)(5660300002)(4326008)(41300700001)(8936002)(66476007)(66946007)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qnh6YVhCd1Y2MklPSEdydVFSM3BkUzEyeHlwNTVrSE83eldqR2VPSWtNUzVI?=
 =?utf-8?B?TDAwc2NDUDcwNDU1V2hJUHhPS3UzM1pZaWNzQlY0V3lJYXpoYUhMS2lETXpP?=
 =?utf-8?B?dG03UVRDRTZ0aFBZOFNyNTI4RWU0K1gwNjhERktJbk5CenhyVXVKTmNhbmNE?=
 =?utf-8?B?MDNuL05tb3d3MGwvTkpWa1B0Nk9BSnlPN1BVVHI1bkw5NnUwWnoyc3g5eElS?=
 =?utf-8?B?RGYwbHhpdlVHaXVJK3dDbFJpQ084a04rYkJNVGVVRFpZaVc2WTZhRWVtenAy?=
 =?utf-8?B?WjN1UEl2YWdJb2pLazBocVIvY3FGb3FZQ3JHMmV0RCs3c1BraURXcTFBYysr?=
 =?utf-8?B?QWNSVmxZZnhjbUNYMEg0UVNGRXQwZ29NYk5xUTRTYlQ2UXVPRjZQQUJuVE9B?=
 =?utf-8?B?SDVNQ0QwYUtFS21KRFQ0SlM2YW8wNXZ6UDV3Zlp1QmRZeEt1Q0hwY2I5NVRG?=
 =?utf-8?B?aVd6Q2NCaG11VXova0Z3R0drYkJhMjRKWmJHbHZvTUxLNlUvU213d2FVbElr?=
 =?utf-8?B?NS9ZY1FmQnB1MEw4UTBsak52L1FJN2Y2SFRFbFZlZjlPcC95d2h5ZGFaMS81?=
 =?utf-8?B?M2lIVHB1bXNvbk1QaU5haExCT0pQVFlMNjEybHc1UmRiU3ZpOWVpenFrQVhk?=
 =?utf-8?B?WDF1czY1YzdkR0RZbEVrbXRHV2o0cTFYQWxKcTVQT3RPWDJDU2lZVjVZWHpt?=
 =?utf-8?B?RDVyV1RPbTZiZ05ERktnUnhNWUsyWWFyYWY5WnlHSXZDNDZWMVZtb2p0OHQv?=
 =?utf-8?B?dE9XZW8yR254aEtUdTJGWkhaVklaTGovR1RCbTdVS1ZWUDgzL2dqbDd2U0ZL?=
 =?utf-8?B?MU1Dd0ZMZml4aG42YnNtTW52eVRaZlpSLzZ3OW04VEZvVE14SG11NFJ0L1Vu?=
 =?utf-8?B?dFNpcUx0WlJhaFVoejI2WDZkYzBNeTltMlhUeStwRjdQUzArVnlWUzF1TkZE?=
 =?utf-8?B?VlZvMmljb0RjMjNqVUpmYzFDZ2RVVUJSMVZGQ2U4RlRQM2Z6V2dsYkpmcjlX?=
 =?utf-8?B?dDFyY2JBTnp5N1RxOEhjNHVENWJhMWRMVmVYcm44bHBhZ2IvWlVpVHdCcXQ4?=
 =?utf-8?B?NkNmM2k2a3ZJN0dTTURUY3pUK2VsNGVGakl5Rnp2ZXduL0hXUzJ5OWEvWCtH?=
 =?utf-8?B?QzJsTWUyUnFTMnlwYmJEUVkvdGk5UjMrcWtHdjFNaDZFSUFlNlg0cGpvdksw?=
 =?utf-8?B?VUtrdzhWUURVL3hTMDZRbStDUDBOcElvZXdJcW9rTDduS3BEMUxpT2FUdkpy?=
 =?utf-8?B?MWVUWHJxSzl1bGg1NnBHc1RtdHoxWEQ3SEE5OVNROFN6RG5PWjdTY2RVRldh?=
 =?utf-8?B?bGM0TjFGNXBPV3lPSm9OS1ZGeDc3eGNkVGtOWW1BaFlOR3lzSTFHL2M5WHFX?=
 =?utf-8?B?V0I3VHY5eEJ0eGZVbE5WTmVjcTZoUWV6dEI3bHlqYThFOEs2YzNLTnpWeGNI?=
 =?utf-8?B?RFBrK2U0YmU0cVpxc05vYXo4MzRjbFQ2MXZ4aFFTZEhmc0ZEazNBVm04VUUz?=
 =?utf-8?B?R3VwZnhFYjdMREFhVnBjNmxnOGxRWEdVMTgrNFR5bS9qTWU4b09sbFBQZEpE?=
 =?utf-8?B?eW5nVmhaUnRjNURUNUJPODMyU3lmOHNsN1NyRHR2NWIzYWEzNlJxdERibVc2?=
 =?utf-8?B?MThFQTJjZlM0WldqUXptcUtrb0tBUUQxNTVVb00raS8xNUF4a0FWOVBsMUlP?=
 =?utf-8?B?RGhVT1FyTE5KT0dVSmRCdnFyOWw2MGE3Z2tubndxdnpLRmxrSmxITmh2NW9V?=
 =?utf-8?B?ZG1Rc1R0RXpqS3RuWWxyelQrYTlQSXFteklmMmlldFcxL3RyQkVIT2t1eS90?=
 =?utf-8?B?SlE2ZmVKMVVGRDNUS2ViYnVuRXJwWUROK1ZxdlJwVS84QnUySmZSUnpYWHRS?=
 =?utf-8?B?RDVJK3hDNlRxbkF3T21HRi95dXE3WVlRdHgvRmdvSEhsQngxbGJISFRxYXFM?=
 =?utf-8?B?WHN4alp5aHpwWUdKaisyUUFEcURlenFDbVA5OW9mODRWMitodENqUUJ6ZEFI?=
 =?utf-8?B?VFpjcHl0NXNnVVNVYmx3VzZaaTJuNGZ4SjlYYmsxN0I2VlFjL3NqazF1b2pT?=
 =?utf-8?B?c3d4TXBYSDM5U3pvaUREVnU2ajlBR1J6ZnprK0JIb092UU5HOENTdENYdktU?=
 =?utf-8?B?dlYxQnUvekhSazBJUHowMlpzUGNndFB6MkI2NHN0Wm1qTDF2N3pVdzBCNHpa?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa54de7f-eb95-46fc-446a-08dad19acff2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:46:47.3244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWhAKjQYZkRTzPZ6St7GEyq02P2PZ3Mk/Kh8zQzLwCDgZ7QcNU3RXOGnvw1PJRhgWkftmCa8MC6v8PUZJyowT2GdPVW7BqjMrNPN14pYMgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 11:39 AM, Shannon Nelson wrote:
> Now that Pensando is a part of AMD we need to update
> a couple of addresses.  We're keeping the mailing list
> address for the moment, but that will likely change in
> the near future.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> ---
>   MAINTAINERS | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 256f03904987..44f33c6cddc8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16139,7 +16139,8 @@ F:	include/linux/peci-cpu.h
>   F:	include/linux/peci.h
>   
>   PENSANDO ETHERNET DRIVERS
> -M:	Shannon Nelson <snelson@pensando.io>
> +M:	Shannon Nelson <shannon.nelson@amd.com>
> +M:	Brett Creeley <brett.creeley@amd.com>
>   M:	drivers@pensando.io
>   L:	netdev@vger.kernel.org
>   S:	Supported

Makes sense. You may also want to update the .mailmap so that git will 
show your new email as the canonical email address.
