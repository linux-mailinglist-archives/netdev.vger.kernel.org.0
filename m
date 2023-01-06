Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7784E65F805
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 01:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbjAFAQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 19:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjAFAQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 19:16:17 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B67334D4C
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 16:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672964177; x=1704500177;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rs9k+SpuMoLGM2CTfREkCRasneYfodExgyDyYjzUMV0=;
  b=k8OKrhfOC94rkmGxCZv2ZmKDbC1CZndzeHPYLEXZ7ICrOScWCwrABVyh
   HCdBTXTFLE+e0n/MWpBaY5mW901J6yh9HLkxhial7X7NsLkdFJCARwG8c
   jFM+eGC6h1K7WOJLjB7XP4d/ikvyfCKwshg0HPfeX66WFQdb+q/Jv15cf
   1H4Q0UXL8+jEgOlLmjuiu75+qbCuSb+xoCzrlTVmHd/skM4Aeee8pH4Aw
   7QDSEHwH8xzYuLebKxUHLJ+h19h1YNHe8Jb7p++VWPqhPNjX7zSb5QmWV
   afr6dVkg6nyiQ/FJbBMmMoXV9+JvPGCTxnxbz/aqjvFZAdVdioY5v5Nrm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="321068289"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="321068289"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 16:16:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="901112668"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="901112668"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jan 2023 16:16:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 16:16:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 16:16:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 16:16:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnluC5JXHAad2TOLb+5iZEYBqMarCVfJTckA0MXdsr35KJoUsUZU7AjaKVwAuIaBgIqoMqSq7ynOrd9hWG0qUZqyb1F7UPGLwdCFGEs2gnq2ZY1Jabd5RsXH+y4q7v9379NKtfgf4P2ZtBR+NFSKOdoOkIn0uJGfHJgUquZZ69MBfUQTi3v/zzobjTajBobsksY2YMSS3NIJxlZlf8VJzUQQ6/rqFWRAWgd83x5WRgK22SQy0hgC9A3NXjmk2h2Y08BYxZdrQ6duUndDkUP8feqGpbjbLGnbf/CAQNk99gsW1l5PidrCin1WnMnexsVKJOWh0GROX155NorFYm0ZOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkGDW+JnyfP3/3Ey8o/J8+yJRfmAyfdPcpgeAtiGJ4A=;
 b=W3VVqdbdCFONzZHOKBbSNNt2wWLZh76D+Vs/NH162eRLjnGX9or8y1m2jshn2FVYtYtl/h6u2qs8HFwuM0ZrVmA9yfsGynPCH6MFrf3Kf3Nv6JTJr2vg421QsDA4+aR335OxnQxaI//qL3tDWXuVr+xQK46q9gsR1+DZsKt2xIdmQyG9zqV2BDT93xly/hMBQBv9/zyPe0tnoiSDFFFhlTajjfWJgg4KZmFQQ/6S/oirGKlQPzN/ApX1xU9LK/8FU1LGJbBPwm1UwhbAk44yb7Y8Zev/mqBLZJfrnPIxlqA4y3MHJHWNVhTW6M8+0kI1vM4NL2r9pRg3cZU4XZTtVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6413.namprd11.prod.outlook.com (2603:10b6:930:37::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 00:16:09 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 00:16:09 +0000
Message-ID: <e460c958-625e-a7e7-6552-d3ce5334654f@intel.com>
Date:   Thu, 5 Jan 2023 16:16:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2 14/15] devlink: add by-instance dump infra
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-15-kuba@kernel.org> <Y7aXXQUraJl6So2V@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y7aXXQUraJl6So2V@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0001.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY5PR11MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 6331a098-3086-4252-3f78-08daef7b35e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWIjDuVY6L40DHLUzi8NmhA1tyJxNhrOZXz1UZP2QNNc8UchR/rkG6WsiWsylG5XQZJCyI4UjilF4SFNTiQT0ttZ86ubBTMVJOmB85hbxFSUF1EreFs25/XYWJkdT3hPynhieu04kLEjNcqzOzOkqiNE+9ol31N9pw6z/JOVO47j16vVbpvMcDcaBiOCArxSn6+Kc06xMorAMr0zeAmStsfKMx+t2sXmvmKK5QX8l/kLkZENvEwf24z81Hgj5UOc3UnI/VdWIfQ+xk6wJojfFNmJ1NNEJEMVHpVjVt5SSHzyiWQHZUlpdsOYZPciTmvoyHLpU7c7NwlGPxk1pnG4H0G6ly6cwHsnuZpXVTki68W10D9F7GDfxWNZqrOX2E10G9H7N34uJYqnvv5k1BIkpfViYMlysccBFZ/lGPPxVjMtd+b2MT1cvMxZ/KnFmw5h99EKOPHVJesabNi/yPdHP9wCxv9hvRcPP7J7cidY1oHUaXk6z5v0BqkI6im+9sOPsA/Zxh9UnCKXWM01RZ8OPgrBT5cjbGFX/AhIQbHlY5Wm0Iviko2DWdiPCWdZPROwSbs4nB+Ey/H6LTGIUpBz7v4LkLx6dN3LHHS1V7NJlRMVkRl/ac42X06Pcm6wHQv/rb595ERPnOGEpn4woquiv/VmmR+WwihvGjnTas+cobxNabxEB28SXRysVxOXUp76HbPLgOpTukyBjE9CYpVoPhAFeLcl5wV8cdcIU5E3exI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(53546011)(6512007)(6666004)(186003)(26005)(2906002)(6506007)(478600001)(6486002)(31686004)(4326008)(66556008)(110136005)(2616005)(66476007)(66946007)(41300700001)(8676002)(316002)(83380400001)(5660300002)(82960400001)(38100700002)(36756003)(8936002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0JGeWZ6V210blpaNGVjWDR1c1pyT1hMZENrR2dLbmg3aCthOWQwbXl5OEFm?=
 =?utf-8?B?b1VWb083aXhvZnYzK1R3WG9reEhNS0tHTEJzc3czV1lvQzNTYit2Yy9SN2dl?=
 =?utf-8?B?eU1ETlhueVRNTWJvejBndnJ3aFI0NjRuL0w4eTI4WXVGRU91MC9UaTB0N2pS?=
 =?utf-8?B?aFhScGZQVDJ0QTBSUm1ReG9wRWo5Yk9mZTNTYnlvN3pMUnlBQk9JUzA0Q1pm?=
 =?utf-8?B?NEpqS2JqRlFpQk1CL1JGSzFOSXNjT0xKWncyRVJia0pXa2xYU0tFRzAxY2lF?=
 =?utf-8?B?bCtpcDlqaGE4M0xwSndPM2o1Ujh5M0FhTENoYldjaHljZkxnUVNCMUVZNGNi?=
 =?utf-8?B?dDdLYlJVVTFKeDRzZjBKa1cxb2V0cWN1MHFRRXV4TFFaSURIMENKcmc5cEx5?=
 =?utf-8?B?VUp0N3VxRTNQMnhQRmhidlNqd3JFcko2ekkraXVWVVo5NlNmYXhROFp2ang2?=
 =?utf-8?B?NkZLWlNtaFlyZEdVZEVFR0RacXV3QzBFZmR5VUNld0VENkZQTnlPd3IybVlK?=
 =?utf-8?B?cmU5cGRqamU4MURDdXcyUmE3WkRoMWZpbWl6SzhLQjA2aVF0SE5KbkV5L0Fz?=
 =?utf-8?B?R3dNSzhZVlp2YnFDQ2RoTnVFenF1b1ZESU5keEFHUVF5QXZuVDdUL0RyL014?=
 =?utf-8?B?ZCsrbkZsMHRwKzRZaEgvS3pCU2RDZHdsNGVnMEo1cU5DSXQ0ZHRxV1IvM1FC?=
 =?utf-8?B?b2hmUjhRZERsNnlJbzRCYUZ5S1RkVWg3djZOSklHZG9IUnZYY2x2aXBsU1Vn?=
 =?utf-8?B?NkQ0TU5xa2VGU0Vwa1RMcjVBS3JmQjdZa0J2Y3dvbmZjNVFxZFZOUzBuenJO?=
 =?utf-8?B?VTEzU3NHZFNqZUNWU0g5ZkI1cDNIS1V0SmcxbmhSTzhDYmNVbGV0ejdOUi9z?=
 =?utf-8?B?U1djY1VXcUZuRXdoclZzR1FHQjExUXMzdWdDcFg0cTdwb0F5cFRoUUN0bTdr?=
 =?utf-8?B?NEgvY0tueUNYL2NOeGRRSXc3eTFPMjYvRHE1d2d6RkNnYTNOb1E1SENvc0R5?=
 =?utf-8?B?OGw5azRvZWFkdUdSTUlkaFF5MElCQjFTc2VOOCt1enEwTFF1QjhSYnY5SjlT?=
 =?utf-8?B?N2VkeVBTTDNaRERrbnFLY1NBaHB3RmFYZkh3UnIzMktDbXF6R1ovL3Vuem9a?=
 =?utf-8?B?b1NDRkFSeHZyK1hySnNvZWFqdWp4eXJVV0JJdXZkaU5JeEpNdmpPVWxYaWJG?=
 =?utf-8?B?bnhreTJCVEpibWo3S1RoWnNRV3dVV01tT3F2Zlhpdk10Ri9USzZSbVJkSU15?=
 =?utf-8?B?WTRnZFJuQ0tQdk9GYndSdnlHOE1sNUU2OUo4T29lQTVHMEErSHNyN0tjbGFR?=
 =?utf-8?B?NmE0eVU3NE9EOHhtaVc5dWpsRldFY3A4RDhBZ1J0azFwMFp4TkxzWkNrOXZ2?=
 =?utf-8?B?WWVCV3AyejhLSjFNaTQ5cjk2QnZpRjY3QjhTQmo2eVMwRmxBalB1djlTY282?=
 =?utf-8?B?cWZFR201ZlMwZGxmdEFTMVc1NmNHeEtKcGl3enVqWjAyamxXRXQyR2RtVUFG?=
 =?utf-8?B?SEQ3b2txS1NENmtzWlpnTWZxZTRKSElLeHFXVkF6VEFYaFUva21IdkFsc3FP?=
 =?utf-8?B?MTRHaEsveHJRTHJnZDU3VzFzWVQvVThyM1FESW9RTGswcXI0TFR5NGw1Zjhl?=
 =?utf-8?B?RnlUV2dOalYzdlBqLy9KKzhBWll3OHh1ajlHeWJzU3hnamp6eW5QOXpTWmxF?=
 =?utf-8?B?NDNZTmxaaDdISnh2YkVhQ0Q3MFZxaHVxbitIWEhxVmYrUG9EWlUwZWhRcGN2?=
 =?utf-8?B?VGVGU1I5b0JvR0xlQUxYVjlsaTBwMWpIaFpYTE85NXFhdnlzMTlaajFxd0dK?=
 =?utf-8?B?MmxpajVCWmNyMWpQbm1PcExHb0gvdGJDTjhnVW4zNDVMWWRJVVVpNlk0dGpW?=
 =?utf-8?B?ZjlRa2J6Z1Zwallvenp3aCt1WExsTkhzZ2FsbmZDTlFIdmJEWmJPNkF6dHVi?=
 =?utf-8?B?NWkvOVQrY1Q1dFNMTXJqTXFUTUp6bHJMc3hDYVM3OVhwVTNoUFlnNHUyeGtD?=
 =?utf-8?B?aHE5L1dZTzROVEZFWGFMY0NPQTUrRGFaMGlXdmZENFQwbUVnMDZjbnJjd3JY?=
 =?utf-8?B?UEFJcUR1Q3Z1dW9qN3hhVWY5eHQwSmxDOG8xSE9SNlljQXF3M1pmSWpLaTVM?=
 =?utf-8?B?VmhYcHhDT1hDdk4xTkZzMWNzY2k0d0NaNWVXSW1MOXhBbThmSWhBb0JvRmpj?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6331a098-3086-4252-3f78-08daef7b35e2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 00:16:09.2413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptlLOr8AIcY82IEBXZ9rYytbOEt3DEUtsoAmw7OG16uH4U1kVLN3MWyJTRrkGzjEdEy6WoC4UaEE604IZkDIwti7/h9q/Vnbv1a/3XQCELs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6413
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2023 1:24 AM, Jiri Pirko wrote:
> Thu, Jan 05, 2023 at 05:05:30AM CET, kuba@kernel.org wrote:
>> Most dumpit implementations walk the devlink instances.
>> This requires careful lock taking and reference dropping.
>> Factor the loop out and provide just a callback to handle
>> a single instance dump.
>>
>> Convert one user as an example, other users converted
>> in the next change.
>>
>> Slightly inspired by ethtool netlink code.
>>
>> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> net/devlink/devl_internal.h | 10 +++++++
>> net/devlink/leftover.c      | 55 ++++++++++++++++---------------------
>> net/devlink/netlink.c       | 34 +++++++++++++++++++++++
>> 3 files changed, 68 insertions(+), 31 deletions(-)
>>
>> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>> index 15149b0a68af..734553beccde 100644
>> --- a/net/devlink/devl_internal.h
>> +++ b/net/devlink/devl_internal.h
>> @@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
>> 	};
>> };
>>
>> +struct devlink_gen_cmd {
> 
> As I wrote in reply to v1, could this be "genl"?
> 

Except Kuba already said this wasn't about "generic netlink" but
"generic devlink command" vs "complicated command that can't use the new
iterator for whatever reason", so genl feels misleading.

I guess gen is also kind of misleading but I can't think of anything better.

> 
>> +	int (*dump_one)(struct sk_buff *msg, struct devlink *devlink,
>> +			struct netlink_callback *cb);
>> +};
>> +
>> /* Iterate over registered devlink instances for devlink dump.
>>  * devlink_put() needs to be called for each iterated devlink pointer
>>  * in loop body in order to release the reference.
> 
> [...]
> 
> 
>> @@ -9130,7 +9123,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
>> 	{
>> 		.cmd = DEVLINK_CMD_RATE_GET,
>> 		.doit = devlink_nl_cmd_rate_get_doit,
>> -		.dumpit = devlink_nl_cmd_rate_get_dumpit,
>> +		.dumpit = devlink_nl_instance_iter_dump,
> 
> devlink_nl_instance_iter_dumpit to match ".dumpit".
> 
> 
>> 		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>> 		/* can be retrieved by unprivileged users */
>> 	},
> 
> [...]
