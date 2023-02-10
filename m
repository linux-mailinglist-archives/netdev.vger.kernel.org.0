Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288B0692676
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbjBJTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjBJTfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:35:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D263109
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676057719; x=1707593719;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rfF0P75+9MbRhU+LeYMhzN45xqj6r/4xjVfqNn0EOgk=;
  b=H9a00Mi9YF3iRLle8LBxfh8CoC2RbVQXTHjDzqLMZEyqTwR1zU3/hPmM
   7GMDk2m/Mf99cqwPyPd+evURed8ld5O+1YgrKVy3C75ORvZThxV11cbGe
   p6xRPOVocXebChxKQkuXjpDFegzHu7fnkAZ8uS4hotfhKl11FBcBnLGuA
   G5/xRKXpEgX0Dq0VatLWs6xXPVwGbB+fiQ0C1qX2ngWq+JxuUCGjfiaS+
   m49uTJ0epnRMy0m7yFzCHs+qT8vRSBuhW6z0mNws7JrcsHAln9gr6H9nJ
   U/RqCY+wWbyJrLm640hqRx3TK+ykJdg12tJe+Gy20h2HHjkY1HopbCG1K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="331812759"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="331812759"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:35:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="736837965"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="736837965"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 10 Feb 2023 11:35:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 11:35:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 11:35:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 11:35:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLRTzkoEWEQbTnrJSHM4udNlBy6m/SbRHAN+aeDOUcbei/aVzit2MZVp4GI/a66bvfcCSpxndrxa6gIDSeZeLeUhJiGMcXImEzCdfbLYCwPx+f8//IU8dhwtHwBU4lSUZYlw/RaFXme7iPA6RvUKTXVxw7+5/xEzgSsE75ZLTtxQh6+lBH9WKFOzCVQbtXZCf7EfeCwdGOAyvvdmezKj15s+52CJq3Wk7EpwgJg78ue+At9m9XUg8BfAQIYerFC4P5vWFdLUuDwJ4+hJS8DsDK5Ff8xoNMQ0RH+7IE85UQEuiLNXJDmHigGcW4gVWIQPK3NOpesukB9x4c0mSE6drw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2vMKsmq0qocQvzigxcALYeS2AYDss12ANmVwt0ZCt8=;
 b=DFmfeKql8w9JcTKi2A0JeWSuonmaPfST2+VOx6HpOlNmGwOOtKl7uTQABJFiqK3M29u0kunswbJCIqgY/3bzVv3M/eVDABjQmzobgxDDKyoACLNH29pYhOjg87Ey632cuLElJRNArB4raUzVMBreFNNtIe0E7boWUmYMPs02LeJFlLKGz/Qh2y1atxc3DBWXBCDUIC3gaXC3ZERr/MArtEfKJViTOpLcvmAiyU3ElaJcNx/xQsgXt7Z//cguLd0ZMeXxAn9m581dCD3lcCFlrA9sXeGnC9mXIIKDWIAMPDt4WCUKdbXfETtpsVMq+lKv8ZLLZ8X3YSDuceIZ7ZLSiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM8PR11MB5606.namprd11.prod.outlook.com (2603:10b6:8:3c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 10 Feb
 2023 19:35:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 19:35:14 +0000
Message-ID: <a4eea208-987d-c443-9b4e-243e785e85df@intel.com>
Date:   Fri, 10 Feb 2023 11:35:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [patch net-next v2 3/7] devlink: fix the name of value arg of
 devl_param_driverinit_value_get()
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <gal@nvidia.com>, <kim.phillips@amd.com>, <moshe@nvidia.com>,
        <simon.horman@corigine.com>, <idosch@nvidia.com>
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-4-jiri@resnulli.us>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230210100131.3088240-4-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0057.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::32) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM8PR11MB5606:EE_
X-MS-Office365-Filtering-Correlation-Id: f6638325-bac1-46ef-acd5-08db0b9dee4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0RdJLJ/5uvRMHGK8fflu4FdlU+1JBECeaaSsPKMy5oKzBZXJm/kJcjA1+5dM6Y1B82kVRb6H2kxo9Q8FC0EyUBiqY/Kn79HA/HmieVHKQSvSwqdMyuWP83YkLPTIRpoCMO/+FClL/iOe+J8DAEWg+K4Hp7EhFTMaI0fGWEgbVu1XPcIlrQ5NpMAx85KvmpAjNBaoxPi/9hRDlPbmjn3hXqRQn5oYgMLAyBCuz+kjfl2CgORPtgIHvdUQUJ0GO/o6GqxzMZV9u2oLVLLJB+u2ORX5O86jR3wtPmlDsVBiQ8+1z+DNgGm1m7EePvtb+wIQUz1kDJz4+7DvJ24CsbGws9EvCa24qd+PnKa/S8vhb3POlj3yf2xnSjHCHFbmLHdcqP5YpqIyF78TW5rTGUjDeAcCV97ZEQotSN4LFMxgvnqo/UBVvctKkl+qnqwR7l1RF9PfaE2WfBjjPb/IPZuRSFKpheKavTACzUXyqvEieiKq4FQIKYXps2kxL5i9BTvG7RyqLjxrXGVUqecSmUt5CaWAHhzbC+Ea/I6hT8KBKN3xOTY0uiOAHt97OiehQuX4Zh/cW95CKPz+aW7HQH240caDzD0UIbRA2uZJplc+VNfv0TGhuB+4s8HOUX/REfZfHWsYtwM+ZZTLMWBBuNrUB6AAe23oIUWhVcQXcCJES4emjbvVZEEif2gUM93H/EFdZM9WWw8NXQC7rX6TAu4iwu5VXaGtDYyhGASumvNJh8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199018)(31686004)(41300700001)(8936002)(316002)(8676002)(186003)(4326008)(5660300002)(66946007)(7416002)(66476007)(66556008)(2906002)(6512007)(26005)(6486002)(478600001)(53546011)(6666004)(6506007)(2616005)(36756003)(31696002)(83380400001)(82960400001)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnAvRDhTclRFNUFDcXlQaVBPd1djclZzWWRORTlTb0Q3ODdhZE9GU0R5cURF?=
 =?utf-8?B?ckVCNXdXdTZoNlJiUS83WFUyaE1RRHR4d0RpUjBuamdQODJkczhzeEhIUHB5?=
 =?utf-8?B?SmZGVjhTRXhiaW9BSHBxVm1HaGxJeUZwdExSNGU0eWhvblZsVVVBcTl1WlR3?=
 =?utf-8?B?cFdmVTgxSXhkclB6c0x4NEhDa280clROVUFacmNncmFNanhuTUdtVTljN3oy?=
 =?utf-8?B?UFplQlRnSFhlSFZzMlh2T0xIRTUxcXdlcTJSUW5OSDQ2Q3VXQkxsejdJdnli?=
 =?utf-8?B?VHN0SU5haUh4YW5pUkZBMmtna2ZCNGpYT29SbEZ2cmo0YW5tc2hkb2hiWUZC?=
 =?utf-8?B?cDR4R0RuTisrUTFmRVdVT2wzQ01qWnZ4UDI2NmlOdXRoMy9JUEg4ZVltdCtP?=
 =?utf-8?B?RG90OXNVeG1KV1pYME5vNXpmckN5MVFPRmpjVXNTcVB0ZGI3VlUraHhyVTBs?=
 =?utf-8?B?bTFIY1RKVlNKUk8wMFFXZ1BnbWpKT1RDMW5OQ3ovcXA3Q0Z0OHF4dXMzZWtK?=
 =?utf-8?B?OENQcVJIRHc5bVplL3duTWxkcURYWUk2SE9WQVloTTZLWndFd01INTg3dnRm?=
 =?utf-8?B?dklGY2tMeHZvV21wVVFrcDlxV0xNelRTUnlHaCtXdCtDL0RhZDhhRWp2Q0g5?=
 =?utf-8?B?d3lCWEdBMS9tU0Q0bmpJeGtWS2wrbFp5aHZKYlhDYWM0b3VYcE5kN291OXA3?=
 =?utf-8?B?NTczSXpVQ25MR1hQeUIxUkZMbHowRjZ1ZS9EckQvUmtSZGF6YW96dzV0T2lp?=
 =?utf-8?B?VisyYjl1dS9KQ2lRbXdvQ2IwMUg4dlR6NzFadFR1SFIweU1Bb0RlRFZwdnhw?=
 =?utf-8?B?dnlveHFpNnBSa1RSSThVMkpHbG0rL3NxYlpaVzc2VjYxSWIrc29odHV5MHR0?=
 =?utf-8?B?VXd3ODZRTzJpTjdjY3VMc0NNUUFSWi9OT1RsQVpTVWc5ajVHTElDbXF2Y1Mr?=
 =?utf-8?B?d2J0dTYvUE0xSzlqOC9tUWpQM1hPVWZoeWo4OTZQRFVkdTA1N3QrNnZVaU93?=
 =?utf-8?B?QjRyTTdMcTNtWlRBL3lvaUdPTFEyY3p0U0RHejJOV09JV2J1NFRUdUxnNEdG?=
 =?utf-8?B?Q1R4aTFUMldndUh6d3dzSzQwQ2M4Mm1KUkNKbW9QYkpXNzlVYlRwRUxjTm5a?=
 =?utf-8?B?dk1xQzJCdm9yR3UzSkhDZW43SDBteVIyQ0dlNDBuWnIydElPL0d2dzBMNDV3?=
 =?utf-8?B?SGlYVk9zU25UK0thc3RHajVRNEp4NG5MSUFxeWNRcURaOVBhY1hrdnhkM1Nn?=
 =?utf-8?B?ZFF0MWVBZklWSXM0MVZSbXlZQnRFcHcwWEVVcnNyM3lKQnN5OWJZN0l5S1gw?=
 =?utf-8?B?amxNUUpKOUFlYUNOYzdFaTYyRE1yQ2lWbEcxeXhnOFNsM1l0K2JkY1FHZ1lt?=
 =?utf-8?B?b1Nkd0NtS3RQc0ZmdGdRSzR3dzRxeWRXTmlJbUt1M28zQk5kSG12WDE5WVBr?=
 =?utf-8?B?ZEtXbHJWdFBjYkRFd3lnaG0zSWdwZDV3YjR2bjQrcERaL001VzBPQ1czb1VQ?=
 =?utf-8?B?NDVZS0IyV3VrOHF6b3FzQXV6bWlHWHFlQkhjRnhFajc4SVY5bC9lVWRZVkRQ?=
 =?utf-8?B?Nmo1RnpuNWt4dlpkbkd0V0prWitWZTVib0lGWFVDRTNxd1hoc1FyUXJzbVNu?=
 =?utf-8?B?UGtmZ0p1WDB1U21zZHVWRU1ROFBBMFE3ZTlEcUVsN3pMSFZZTUg2RUhpT0pk?=
 =?utf-8?B?dlpjbU1uZy9Gdmk4NjRZMTRpb2RQcFR4V1JqRERhMEpnYS90d3ZPSDlvUWpx?=
 =?utf-8?B?MXBHTWtXckNnQzk0YThGQUdBT3dWYS9QMEtHT1BkVUQrRXRWbDMzYU9rSFN3?=
 =?utf-8?B?V3c3WHkrZVc3aFhGNW5RV3lKbGltWnlXUmxDNjNIZlBna2FJalZ6VzQrUkNW?=
 =?utf-8?B?QnROMlcrbTNlaGVReUZRQS9HNy9OYXlMODlSSXBORld1RkN4T0RoTmE3a2Yw?=
 =?utf-8?B?MlNvcGtGdjJlN05nUCs2enFLYWhvb2hpTVVMUVFLOWNnMEtEOE1Kcnp5SzN2?=
 =?utf-8?B?cDlVWDRzNUhidXpFd2VpaVVGSGpMVWc5UmxwOUtIR0RSTzhoMVJUL2xZUDFU?=
 =?utf-8?B?c0NrODA3T1dSajZuQ2c5dDZKVm1HbDFjZzgvRzY5SnN1RmY3b1ZGYUNwY0w0?=
 =?utf-8?B?UEZDUE9sM05UNGhwU3E0TnJ5dWx6TVZDRnYwbDRRdGFDZWJSckYxaWVsK0xN?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6638325-bac1-46ef-acd5-08db0b9dee4f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:35:14.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4PDFQpXyfPEd/sLNdcdCCRE3Ll2w1LahftZyGqe7Qlj+DdA6qsCxQlGU+Vt7C9xg6oR5BO3aFPrVddxcYXPI7FLid0gQDrzBET3Yl551XM=
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
> Probably due to copy-paste error, the name of the arg is "init_val"
> which is misleading, as the pointer is used to point to struct where to
> store the current value. Rename it to "val" and change the arg comment
> a bit on the way.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  include/net/devlink.h  | 2 +-
>  net/devlink/leftover.c | 7 ++++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 8ed960345f37..6a942e70e451 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1784,7 +1784,7 @@ void devlink_params_unregister(struct devlink *devlink,
>  			       const struct devlink_param *params,
>  			       size_t params_count);
>  int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
> -				    union devlink_param_value *init_val);
> +				    union devlink_param_value *val);
>  void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
>  				     union devlink_param_value init_val);
>  void devl_param_value_changed(struct devlink *devlink, u32 param_id);
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index 61e59556ea03..dab7326dc3ea 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -9630,13 +9630,14 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
>   *
>   *	@devlink: devlink
>   *	@param_id: parameter ID
> - *	@init_val: value of parameter in driverinit configuration mode
> + *	@val: pointer to store the value of parameter in driverinit
> + *	      configuration mode
>   *
>   *	This function should be used by the driver to get driverinit
>   *	configuration for initialization after reload command.
>   */
>  int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
> -				    union devlink_param_value *init_val)
> +				    union devlink_param_value *val)
>  {
>  	struct devlink_param_item *param_item;
>  
> @@ -9656,7 +9657,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
>  						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
>  		return -EOPNOTSUPP;
>  
> -	*init_val = param_item->driverinit_value;
> +	*val = param_item->driverinit_value;
>  
>  	return 0;
>  }
