Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBD2672AC5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjARVpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjARVpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:45:09 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31B510CC
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078308; x=1705614308;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IBDKw5Ore/F7sUaylbN77YUxCZ1yElPHk3nNAxSud5I=;
  b=bkD6B6YHBZrG3jQUrdA6HrdhgYb43U7IQmJRNAaP34mmPCfyXpSRsY+u
   +8KtUOZgzILYEnyNKJI4ZJHA+Jmadv00SlUGXrRpg19P5XhPzGHyGEkn0
   NaYBxnbVVEJinZcrfqtXcRoum1e1VfbpYDTvwT12yTusrIWzRHIproNcl
   CS8TXL5B1Eb+nld6gL/EiiuPX4L5+HU901Op/YnFqfist/d3RWf/Nz0G7
   HHlQTV1lZTgZ6FSFhnP9upcWKdlVLPFNCoA91kwpTDb+WANJxhiSNghx6
   i6y3+OJ2fl6tuyJTMJf8g0Knb5d0LsD5tagL/XxJsf80BFOIRwKE41khu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387461018"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387461018"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:45:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="988759334"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="988759334"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2023 13:45:07 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:45:07 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:45:07 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:45:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxKadvD50+PtSJHnTDti0aXypy8rpTGSdSBS7FGMs7nSdXRsXuknqPEcEB358KWVxJhPMmOZEhgWX70Vbhm9JiCjLbOxR62+52O2csX/gAu3v9xnmvbzprj+iGSQ6xTAcN+owBwTQDpG9Rn7i1vvm7iHrPVj/14hewLiDg1PMkSIRjHPvtgENUrs1aAxfAJt4QAAXb/hWMRqx03D2iGEYzZkBusV41/3UbvwD/w9KDsP7NWxz74Nqw9oaRa9PvddLpPGY8VPJILClHWT2t7z2pDyH9TYRpGiRWAck17Cyouy5BvKCcRuxoktzeVNqFE8JqPxLjG1sp57gzTS1Sm4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJyPbi3PiBzPjRb0x+eTIQ7/ikMPle1BQfcCNHxw/qs=;
 b=f2j2URqNy6N/UtSaHR9B4k49Ssz15nHpqaXEOLcBT0ms7VbMT2K+0MU41Hex1obPmekWSl4F3nJEU6ykIFmrMX3GczI9YAPD/ZNcb7vnUI6m/it9WFtiejzq2PEBEDCYzTOLmsWzVwLbsEjgmycnzbgf0TJAXLPQyd/wkiuQNV3/NH6egmdGodjtntYP8XtVCxu1mwyTJvZS+3tSD28tg5gBwLHKA2toMmdQgDNvRkomqDhnbIHSNNJA8HA7FA5EzvGziyY+MwWBgRYLV3qJ82zo7zoDhoqY+w8oZg4G26NcQUwtKzWGCBqHmpurzv1c8XLRKKjgOksCbB/QeY9QeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6061.namprd11.prod.outlook.com (2603:10b6:8:74::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Wed, 18 Jan 2023 21:45:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:45:05 +0000
Message-ID: <3a8541cf-cbd9-72bb-cfef-70df6c643adb@intel.com>
Date:   Wed, 18 Jan 2023 13:45:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 10/15] net/mlx5e: TC, Use common function allocating
 flow mod hdr or encap mod hdr
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-11-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-11-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::27) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c3194c-7a23-485f-d2ae-08daf99d42f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o8DMAROvTsH9RXi56drQysoLB0IyOvzWF1zyaQ88xSGvqSnDC+o+8YvkSAx3SwrjqASoLQUn8xqvv/As9h0yS19ergckZAeEhMR3YsUFoqpVzAc33X7wZLYVzgqBRSDgCYfeF18jV8ty66OOZzqHX1mgcj/+53a3M52GCnR7XC3TvFq3ekvE4kCs2THMEaXnh0HzbXYYy5vvtcdYmGPDvGOe1nITOqWbKHltRzgfMCP8RIwtsXWGY9oZLxRgVPyvcqLVWKnD7sqnX4EleGNYIc9ksr68hZp4kcTJcJkHK4TNaIukzhcEFW82Am5zgjy1VkMPtX24yMH9h8o0WfqssB4LE1YDyd746gAfYxgLpsVCwWL986VWG7ptzR6w6Zo8su9uesyPlUmyLLLpotYm+PXqFhe1l4nqE+Fv9ppA+rzjktlO8BtD6JGYomFnoZH7ShSUk0tiTGpgVjAlyBS8MHTuArwEg33XpBf/JKFl5MPcj0fwYPtxAHf+b1svJmaWNKIviuC3/XJhAk9zwt2les0f9u1gHKCgD6VRnivNng4CswtKY+FNe8xyce+1n8ZLywlHC0262YRaS+HYzvOSXInHW0ymQzStvfAwgBwpUVbJM2tc+YofSYR/5JwzYusAykV/s3/P1Rg4sf4xCkWbwYXtbXA6WMH/ztC7+XUB2IS/gffCBGPDpKM7T7nYON7RfslDviWDvr88RgyCG6oDnzvyUmor00vCDxoqOFcFbeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199015)(31686004)(36756003)(4326008)(2906002)(66556008)(66476007)(8676002)(66946007)(8936002)(4744005)(7416002)(5660300002)(38100700002)(82960400001)(31696002)(54906003)(110136005)(478600001)(86362001)(316002)(41300700001)(6512007)(53546011)(2616005)(6486002)(186003)(26005)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkpxdHFCMmRJYnhMdVJQSFZmU0tJY2xIUFAwMGVGaWpuOUYyLzlBeHJwUm1R?=
 =?utf-8?B?c2FBQmF0NkpudGk5WnF4eUFTZWY1cENvSE1HWjZ0dWM5Zktwenh3WEljWDlZ?=
 =?utf-8?B?UFRqSnRDZjNFczc1RjRuT2FVVHR6TXdFdGZsMDFqRU9ucG1IdHUvS25ScS9P?=
 =?utf-8?B?Z04rQ2VJVWVqZE56aHZkbEJ4bjQzSzIzSEhUWnQvK2RqSGp2bUNwQUFYV1FW?=
 =?utf-8?B?RjJodU5jZU5scUY0bUlCa0oxUTBwQW5xSVBoYytsaklwby9HMFdwQ3J3OXZB?=
 =?utf-8?B?anhMellLWXcwRGVESzNFM2dZOEN4UlJ2WHRQbUZZSVJ1QXVKVzlkaHhVRW9n?=
 =?utf-8?B?YWNaWlpjcjdLdHlxWmVOUmVDUk5HREwrVkJoTElxWVFBV251aVRDdTlQTjBX?=
 =?utf-8?B?NEI5a290VitzeXdCeXNpZm1od0syWHl5SHRCTnZRSTJBTENQSnNRLzZWYWUx?=
 =?utf-8?B?cXg1RTVjMUxwTHJiUkFaeUF2V1oyQjdNWW5QQlFCencwc2p5cGN2RkJuQ1Yw?=
 =?utf-8?B?eU9QV3BPZUdkeFE0OVdLU3oya216UC9VNFJEY3B0cXVjM2FFU2dXZHRFeGE1?=
 =?utf-8?B?TFdjVFYvTU1SSHBTUUZJbDNWalJvaERQc1RjU05jTFRNVDk1K3krOFJQMGpV?=
 =?utf-8?B?YjlJWk1FRml6elZ0MzRCaE53cTR2TkdNb0thYXAwZW8wZVBGODd6YXpXZysx?=
 =?utf-8?B?bEF0YjBuaytHRVZRTFNGRCtjc0hTSTRWajJNM3dsV1N4Ukh1cXdqZG5xMUFB?=
 =?utf-8?B?WUpheTdnaTRnenFGbDg2WVpVNjNtYklTM3lXRVpiblpodGcrRGxFQUF4WENC?=
 =?utf-8?B?eVJQcVNWU0ZoaWNtTUNHeHlZT1VqNCs3bWw5eDhGYjB6Zjc1R0JKM3Zqc011?=
 =?utf-8?B?QTJOWkxMbEMxQm1jMlRHT0V0cWhsWXhLdXJQclQvdWRXYXZ6STNvMUpicUlF?=
 =?utf-8?B?dXRzZnNhTzl3OXNaUUh4bW1LMW1XOHcyRWJZWkFERDA2RFFLZ1QvNmJySFVr?=
 =?utf-8?B?TnRGR1dMRk1iNDB0TmRmbjZMU08zZ0JKME85R2FncjdyRWhENTRVUkRDOFJr?=
 =?utf-8?B?S05qdThZZlFqUDQ4ZlB3ampRU2Fma1hvK3JtUFowSzZVLzl4cElrQkJBTEtU?=
 =?utf-8?B?MGdQaDNVYkJ2WnE4UzhYK3plUzg4UmZuVmRKWnlUT0JDSFJKWWowa1BKY3J3?=
 =?utf-8?B?dlUzMXdGUEhIM0N0OHJnVyttelpuTGZwTnB4MTZCaXdiVHBPVUhpSjA3UmNi?=
 =?utf-8?B?ejdEMUZTV3pHMHRhdC92VHA3ZEx4d2xaOG54ckw0d3NUWVZiL2FvcnZTNlcr?=
 =?utf-8?B?QytEdnYrRVp0UzRjNGh3WW5mZ2w1V1k5ZFFZNGh0Wkk5ZEd0V1ZBQytLY3Vx?=
 =?utf-8?B?Nk1janNaMzNwUlVWdmZhSE5aVXVmUE10NUxTU3o3TTV2Z3Y1cEh5S0YxQVMr?=
 =?utf-8?B?VkpIYVpxeVBBUiszczJTSE1xd1dDc1l1M0RHYWF5N0JodlVtSTNLeTVGc0dK?=
 =?utf-8?B?MWlPWHpGRXFjUEwrTWZNNDJuYVY0b1NWZFBpOFY3b3lQd2hvT3FzRHRZenl3?=
 =?utf-8?B?K3FxcnR6b1NuZW9zUERmdDd5RUhKbFR5VHlYMzB0cTZVTVJNYVZwNmhOVkor?=
 =?utf-8?B?KysycTE2aitvb2xYejRSLzNjc1hqRkM3RjN5QlZwcmpoZnd0U0g4TzE5eFNV?=
 =?utf-8?B?d25xaUd1V2VkRFlEeldzVm5XektidDE0MHFOQ3NIUXVFZHBZbTcrSkxBTzE2?=
 =?utf-8?B?cVhmNThMencvOS9JRWNqUWx5YXhkUnhLeWN2QjFEYkphNS8zL0ovNGIyMEQ1?=
 =?utf-8?B?TnNvbDB3ejA1K0hUUGorQ3VJN01NTEV2RXA0cklkTWt3V041VHJqTHBHbXdC?=
 =?utf-8?B?Y1dkekhHVEtyb20xVytBLysxbWdEdytZTUxEYkdDNlN3c0lRRnJhMitMY2ti?=
 =?utf-8?B?Q1orUkRxK1VUdXZMOXd6YWU1bzdBN2lzakJqK2RuVFdUQWxSdm1DT3hoMWg3?=
 =?utf-8?B?NGdsNmdIUDZsbTJVU3VTRk16WjNIWERiODk5dDlZME9HTUlicWVvQ3Job2Z3?=
 =?utf-8?B?cXpqNzZpRnFIL3NrdHFsN2w1WUFBR0M1Y3BFc2NwOE9CZHFLRHBaM3FnZ0Q5?=
 =?utf-8?B?RExzbVZMdWlySDh1QnNRanVsanZrVStqcmJEeGdrTFVnL0REVE5HSXhRaENZ?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c3194c-7a23-485f-d2ae-08daf99d42f5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:45:05.6341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwbdYOhHUQTxZW9AXctNyvVjNDO1LfV8lepT4SYi55vdIlK1W/WGu3jsaT0YuS4N8yN61JvAsX/OyDMXQgEnLR6ewo6ybx7YmEg0RWlLSnM=
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
> From: Roi Dayan <roid@nvidia.com>
> 
> Use mlx5e_tc_attach_mod_hdr() when allocating encap mod hdr and
> remove mlx5e_tc_add_flow_mod_hdr() which is not being used now.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
