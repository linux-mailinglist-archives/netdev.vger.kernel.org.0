Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5C6672A90
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjARVeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjARVeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:34:04 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA4563E26
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674077643; x=1705613643;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HEL8W8iXRHExbvBpvCUlhU0KAFcxFo0RdX/vbZeIqcg=;
  b=lVCW4sI8uGkMBDLJNzU6qi0Fg0anS5weKiHCyx9RC6POmTltKVy6PsDp
   ZgarJt0dN9aKrsTmRWYDYGptHvm/EgL/NQP9pp4N4d97N0X0TA3L0QPWj
   eutHVizkSejlF5oMhFyrBTIZujXymvDoynzx4tp6vuQro26joMPlg1ZuW
   oaNitrgiZQV1Ez24LCS9wf+tlM6jMksZexGXVZIf8tz9b3kESmfvw1y9T
   HiiFN4yBKl7pW422/TR4MzbvIA/Js18qPkphMaS/EkIV7k46rKLmhdZJ7
   q8HvLIAyu5wBVFEWWY7RHGJ6nFVt7Y+qKYEbDo7BhtXoqcpGwMc1Fq7pD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387458131"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387458131"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:34:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="802368665"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="802368665"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jan 2023 13:34:02 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:34:01 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:34:01 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:34:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fhw2+g1cRfUyk+hhuu+o8GhzpIxXuGFjMJMQOGJS3SPJokzKG47OEmU5ScyaGkq4+kbvFuwHJo8Cxw5CZGKcaFLWKkWtu1n+autT+3+Glx4R+XLzVRqqS1iLbrkIWzFjIIuLoe0F10jPoaVS3+jtgMy+biv+PccCFmKE0oe0NyNcSoduivCXkO3U3otB8weffmAcfbCA7JwzolBjRwOv8Tk4wCsU4tPIqmyXukuGcDXSqVg8TrBD7GjnRPpY2vYiZUdt8+xqG4UhfmwqWQcl4Tv9kOGLGE2YJF6k0O73HSu1rAE7GkbQt6kYYu5Eule+4t8HqyubkZK3o5dOlUretQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhhw35hGNrfs9oHeFxiApl7QBDDm2Nn5+lzQOpYxIFE=;
 b=EQRr1midAX3jO90fcvDgWJs62Hk0zMOCVFmFL4/cgvPt6Qm1uyXFvUYNidZDI9FK3VGyEirObcfU0sFWmQ+QSTWyehGWJ9V9PGGXCRqVrQC51EUYL5LBPwR02Xf0HkY+3jkCdrXTs8dRwiJeoB/k3vMKjffiiDzDTyRILfasn8/WMKD7zjf+7ZWxrb9okUi3jjq8Ln24YKDsSxs4s8FpMApGZkjImAC2XGbAVX/NLk9YndRI3lQX6pjyN92/J86yfvMZpzPaLdd2jBXHSowBDJCnpTPNNWn6KmCsb41QLpxupq2D8MA5ixQ6fPpMi4+8uCMi9uFON40PqR6NTGZ2PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6061.namprd11.prod.outlook.com (2603:10b6:8:74::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Wed, 18 Jan 2023 21:33:58 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:33:58 +0000
Message-ID: <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
Date:   Wed, 18 Jan 2023 13:33:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-4-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-4-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::19) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db15afc-91c5-4b28-9c8d-08daf99bb553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0ZpuBf6NN6I0iocj6DQMXK3d/dv0aqwDaIkEy1kw4PYo8+tY4QI9K3aIznbDz0J13fE2WoV1egLGxW9tzGOS8xTnITtxg+els028O9m157LMAjZwxoE5tZtAci3jEokHBjwCpPECV/qA5KB40b5vGLGMApAgy0+KUneAZUbobi6jHjksWkoT1m+qOmSDXRRhFYX+MPgMJNpFCN35dJ7FtwphSmik67/LsjxQudxyTnWuGJLLXjA+5PCwuiJ/KStXsaXMOusw+L696KziC/uIT9oe3rla3nSBhItkPQuVaVhRjfHInuKUSl53Pg1BIiGVtumaZf+IE+UVPfy+l14KlHm+VzgCGdsKSoTxjCEfo/NMqxe3yKkLVAvjAKOgvoWbQ/WU9ikaeqNcG+8+AW+o9NL69uHU8i60OXC6GFKcLX+0ZeHmcAcGmT1yB7S3tEVkB+iOCNYgylkWAJqFI6oOG5heMWjKpvoPJO11QF5TdBI4URpxGYvS+6VPzyC5tkPncB+1l/P6WFNPoY/Du8Eva9j/VoHvkzhz79XHxF4PNwObmwzXmZP2JPHaEJRC7l1rc07HHpo2+44p+QJ225kSn788GLNjyEVmzmPjLw8SZYDTFWEz0fWW5/RMuz4JItKCbnvLa6NMy4ZL1DSHULsN6koZF2z/csBrDAR1dGDMrzJlbHtTeQNCG1nlsyXAHydBwiAG8ALh5YE0XPslpSeinJI/LFDX7CFaTBPeu1g60k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199015)(31686004)(36756003)(4326008)(2906002)(66556008)(66476007)(8676002)(66946007)(8936002)(7416002)(5660300002)(38100700002)(82960400001)(83380400001)(31696002)(54906003)(110136005)(478600001)(86362001)(316002)(41300700001)(6512007)(53546011)(2616005)(6486002)(186003)(26005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWhJOEd2WmU1UW9NU1hFMkI4VmQ4Uk5SOVVjZG9GVWMzL3NGaEorcUoxMm9F?=
 =?utf-8?B?a2NWZDdDNWwvblBjUnpJdVdHa2tBanI1OVlFWXM2MkV2N2NiR2ZhbFFCU25W?=
 =?utf-8?B?SG8rOXVmam5oVEs4L3R0eUIveGhTNHkyc1BKOXlpSk9HRGd6SUFqT1JTT1Vh?=
 =?utf-8?B?dGl0bVZFU2xUd3V6cTVJeVBvZllXYjNZNXF6TFpLdHBxQlBrTHNDZnFVSlJV?=
 =?utf-8?B?dnQ4ZmtYOGFuekpjTXE1MDBSdUtMTWhHWk5KdDJVVVBPTGg5cEh2bGw2TFNQ?=
 =?utf-8?B?VkRXV3ZaR21ab3B6TVQ0cEpnUmdVbnBIdWZVb1dBMnF3SENxOXhnYkpVSW5M?=
 =?utf-8?B?UXVZTDBXTi9rUkFpaE1SVW85TlE3ZEs4RlFnZ1BPOE9OTDhPZm51RGlCQ3ln?=
 =?utf-8?B?NG9CazNtZmRySlIwbzlXNFFkdndoVzVZNTcxb2FXb01uajVQaEFldktCQU5j?=
 =?utf-8?B?OWdBdFpRbC9MVDRoclp3Yk5yNTVYYVhUVFo1N2k2eGFjUFhpNUxXTkxaVGVm?=
 =?utf-8?B?Q3N2U3luYlBoL0ozWU94QlBOOVJBcE1hK1A3TlpyMTBHWEJBbWIxeStvS0ha?=
 =?utf-8?B?NEdVbkpRZzNKUkVRSUdJMWZnKzU2YkxyamRoYWptL3E2V3M3NzhIcE5GYkd4?=
 =?utf-8?B?M2ZCeFlaMjZNb2srdjkvMnVGSDNWOFh0bVA4VHlmVFo4eUpMUlVacUsrTUZo?=
 =?utf-8?B?RGU4eHFESC9pQU9ndFM1NnhCemJSTkhtWGEzUzc4K0xOVjR1c2pDQ1pETnZi?=
 =?utf-8?B?bkhxVUcvUmtoN25pTFZyeUJ4L2M2Y2ZyMk1qanJUanlWUDdiYTlkQmdydE9O?=
 =?utf-8?B?eXBVbTg2NVM0ZW9LRFcyNGUrYjcvQ05sNTdlQ0FRVC9udmx0bEZCRXdZV2ZZ?=
 =?utf-8?B?YU8wK2ZWeHdMcVZESzdEZnk1dG0yaEttVlpmSXlCL2Uxc0NxRlN5THFSRXZQ?=
 =?utf-8?B?bUZvbWsxWVhNNXRjOUxwVndSQ1lrWnliamZjMXlQaHkrUURzVXhKUnNwOXhv?=
 =?utf-8?B?QTBzbUVzcG1rTXREZjFSTDhsWHJFWUY5eTg1RGtSaHhONHpmTmRBM01zdzl1?=
 =?utf-8?B?ajlON0hmYW05dEpUM0swZ2ZhVDFIb2hhSGpCbHZERGJJUWhJU1AwbjBlRlgv?=
 =?utf-8?B?YXErQWJ2ZEEyNXlwNCtwTm9DOU5PMXB6bzRhYWJ1Z0srK09FTk02ZHJIb2c5?=
 =?utf-8?B?SHNjc0lvczVYSkJIWUtDbXIveVJrczdtZHFPSEdiUkNERVMvT0xsam1md0wv?=
 =?utf-8?B?WkhZN1EvU2lDNzZiYmFaOW5PZ2E4L1JxOFVFZTNPRnl1R3B3TWdYUXFlQXJV?=
 =?utf-8?B?VzJRc2J4R1VTc2dZczRiYkRyVkRsZTdlaTVNU3c4anlNRmlaODVxL2tJa21X?=
 =?utf-8?B?TERsWW0yaFJROTZqYkYweTBGbEFZc0RmWk14cVNmd25ndWhoSStrRXJSeEUv?=
 =?utf-8?B?NGtNcGl6WlE2NXh6Y25xd0RvMWFUbkZyOUY5RjBpaWVaNjYrb2t4ci9od2sv?=
 =?utf-8?B?MUlBV2hwRFBSSklpaWFRR0ZmMk0zeDJXZWNBTVVqaS9BeUZtZTQ0eTA1QjZG?=
 =?utf-8?B?SmFUU0wycG9KZ1AxN05ZeDgwRVRDWUZSZXIyL3NSQVRUTlBRYnpPWmZyZzJN?=
 =?utf-8?B?Z25nOE1ZejlMNlRCZG1BTi9rbEhQU2x1UlBGcTVyYmVOZEI5MFhsbHRtdVBm?=
 =?utf-8?B?Mk1jWVI1Z01zQU03cWJaNW1ydFBVSTlRQXBuUmJIZFRuQ1VJNnM3RjYwSWJE?=
 =?utf-8?B?OXhnbDdvdXdabW9NRWtNSXJ4Z1NwOFlCeHVzR3dsRUEyM2VDVjlONUVjRy9r?=
 =?utf-8?B?bWFhVGhXczNxbmZkTmNTeVZ5MDIzdE05SVJNdWczSmRTNkFHdU45RWdRY0U1?=
 =?utf-8?B?NDFMZlVnejN6SlIwTlpnL1NpMmY4a21ZV3g2VjM3NVFvaml6ZWdLYVJsWEZF?=
 =?utf-8?B?VmtaajRkQUtpMVhkSWFQTnIzVVpkWE1GNXVPdmI4OFlDaisyWlhvdE5qNWhW?=
 =?utf-8?B?V0xJbTQvSTZ2QXY3R1ZPWHRnNnQzUWlmU2VzYXQvN3FBc1pVSWJ0bjhwYS9N?=
 =?utf-8?B?TFdPK3l4dHA0RksvcXdvV2d5MlA3S2lpNXB2WExYN1JwZEFtcEJZS1hJM2Zq?=
 =?utf-8?B?T3g0RmpPbWFEUzUvSmdmMTMwME9ydy82QmZDNFJkeU1zeXhSRHRQMlNZblU5?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db15afc-91c5-4b28-9c8d-08daf99bb553
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:33:58.6092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFhl2kUHUS/84f2AqGXJtIWsMIEVsLfmR5sVDFWEDC7FdEUz89JrLGZgKz5PIWUaA0wQ3Ueq2AsEyaZhVlyjdANzgEI7s8d4//DHLPp4Axg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6061
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> 
> The adjtime function supports using hardware to set the clock offset when
> the delta was supported by the hardware. When the delta is not supported by
> the hardware, the driver handles adjusting the clock. The newly-introduced
> adjphase function is similar to the adjtime function, except it guarantees
> that a provided clock offset will be used directly by the hardware to
> adjust the PTP clock. When the range is not acceptable by the hardware, an
> error is returned.
> 

Makes sense. Once you've verified that the delta is within the accepted
range you can just re-use the existing adjtime function.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> index 69318b143268..ecdff26a22b0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> @@ -326,6 +326,14 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  	return 0;
>  }
>  
> +static int mlx5_ptp_adjphase(struct ptp_clock_info *ptp, s32 delta)
> +{
> +	if (delta < S16_MIN || delta > S16_MAX)
> +		return -ERANGE;
> +
> +	return mlx5_ptp_adjtime(ptp, delta);
> +}
> +
>  static int mlx5_ptp_adjfreq_real_time(struct mlx5_core_dev *mdev, s32 freq)
>  {
>  	u32 in[MLX5_ST_SZ_DW(mtutc_reg)] = {};
> @@ -688,6 +696,7 @@ static const struct ptp_clock_info mlx5_ptp_clock_info = {
>  	.n_pins		= 0,
>  	.pps		= 0,
>  	.adjfine	= mlx5_ptp_adjfine,
> +	.adjphase	= mlx5_ptp_adjphase,
>  	.adjtime	= mlx5_ptp_adjtime,
>  	.gettimex64	= mlx5_ptp_gettimex,
>  	.settime64	= mlx5_ptp_settime,
