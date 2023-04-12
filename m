Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93946E024C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDLXJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDLXJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:09:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D51AE68;
        Wed, 12 Apr 2023 16:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681340950; x=1712876950;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dHc0kXJ8FbjuT87YRLosIFRQkCkcJGrJV/pBlT2koFo=;
  b=eA3hK32BYSbzIUmbPRuDD7chD0r/N94GtpNgqUg4FDZlB8O3un4STr45
   1oRutvZLnqsNwl1accwtQDZX9dozQtzM31GZgF+DgwMZmq8+T7GbksgXB
   K9qQg/ZzO+IvZJ6zQIRuWGjsfxz+E74kob2C9Nazsew1/DNQK2FLX1jEK
   hQe02uVZ8w/asPMXC3rMKNBV++ZzcT+Qc1YvbP8jDvptWeyZ/wOSpUhbo
   UTIfzvT+hH0YT89LUtARIeXBai8QQKXilweD7Jr3ZeP9HZGp2rWKyEDqC
   xMre5Piq2SZy+CkP12eA2DEKdo2W8gN+DRjcZ2FIXSuCpfiZceiMX14ue
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409186778"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409186778"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:09:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="719582648"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="719582648"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 12 Apr 2023 16:09:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:09:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:09:08 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:09:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AATPrarGF/Z5EvnCxIO1pY6EE5OPOofrRybwxG6v3c/4F4dCK1PiyzHSGGESiMIhIN0FGosDKYR3n7FLHRggmxeeay/4lFS0ur4fhjNew1bvJpWxNr2uc6TfRZN75og8rBKy2K3BicG4nLmaYkzwEh8J2t+HY96vBz2RdD1q2mMy4eSIZqkVUkTl92bwxDq8ZjtqccB0kMkGgblY5cfL3TlvgTqj3cIIdsl8DcOvjmUih5chCD3vK0jwlrAPmtIhIgZYm7fLCulDqZqbjyXVNkNtGmbsfuf+2aU/ykKdliXgipy8zBcSXkCSM7FR7OGJ33X5ntbhOTVUp1rnVkylfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHEKWzEaTiqni6vvxvkxMBq9NiJtlvdLbL09qun0g5k=;
 b=R0RPanVDFW6MDkOwJV8YvfEm5JY8z/9zTB2NpTosU+Hw4dFdFMxgYBWh1VutMGpoGG3bZIu0PJzCcdrmW98DPMiZ5vyye39x2Pe2rwdAuPP7CUcaDVt4bo8jTVPMdJCsFi0tHcdBgMHf3BYymR156qYOohJ4/7NcFS0PQYdBl89tUY1tr01EaPBpENMOXqd8a/dAMe9Zo28nvWjL3IvMR2EVJVBa8YAV1rYhz/bzwqk5p3uCak9C+LiSV3HWb9buv1F81eX1wT1v49SH5pSDZhRCJwY0XPfSehcFtg/tUAobs8TojmtgfrcebzhpL/e/n4MDge7/ilVal+BXrdY9ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 23:09:00 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:09:00 +0000
Message-ID: <83c589b9-4fd4-bfd1-8bf0-1af217e7121d@intel.com>
Date:   Wed, 12 Apr 2023 16:09:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next Patch v7 3/6] octeontx2-pf: qos send queues management
Content-Language: en-US
To:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
References: <20230410072910.5632-1-hkelam@marvell.com>
 <20230410072910.5632-4-hkelam@marvell.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-4-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:a03:334::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL1PR11MB5239:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6791cc-0f4d-44be-1ad6-08db3baae6ba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5Wacj17r6jMdB+Ph7qe76AzTtYZtdmzu8leSVsoTCm23pNCNFx5zjkMsTG23rXIhgTkV+k5PSk2ZWwM+/bQXEvtm4IzTwl2ls9+nnOFzcHapIjUGYvR420AVs+44oCPfFGf6kH1ATjnqhIZcwYxHRqHgCxTQsYXOkwDe97WA49q5+aUMvZ1W7kBxI1zy0I1z6mwKA711E+gf+9u6zA1/VBQAW0kk7+8DW0EoYQKIE70klNNDBROLv6dqJFwLjxLxsCol51P1oyoB1+BRSquXgCNU+qWGtPUcnvtap4MoVKE3SCDQ6TtMxCBy72GY3tsLv8GraT8KlC51gzJO/HYAws6Md/huvsXJPMOD2jIgo9Imn0oeBULrukVfnJnEt2Bf3GYNYoTpDCzgFp57I1RvyleiVBHagbX63rkIrmsrN80rzLL2biejYfIXfF6uceiZarA1UK9AIRRRWUz52IJEZSz4DGJfDANRKnzAs8FJ+7rW73Wo5tzaOkVLUQD47dMwG/gFlkXFENJ8ozIZN7cGWDNEoziixYmSiSMOVaaqFu/syCfTdG9FsU6BQ5G0bNgk1V/EKUaR7+qpRNkmkUqUQ2VGJ0UCh4DxHZeCjlFliw9ao7cQruoHucaBjbzvd6qqp4grpePzm1x9hgJocZuow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199021)(2906002)(7416002)(4744005)(31686004)(8676002)(8936002)(5660300002)(66899021)(478600001)(41300700001)(316002)(66946007)(66556008)(83380400001)(66476007)(82960400001)(36756003)(4326008)(31696002)(26005)(86362001)(38100700002)(186003)(6486002)(53546011)(6506007)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3JpRUx5VldiRis5TEpLT1pzTE9jSUpLckEwMURMUlVKWFhwRDNpeUdXMnBT?=
 =?utf-8?B?emlaWVk1OFNYVFJuWlRFUkh3ZUxwQXdoWXhPY1I4YzJ4OXpuWVRxMW4yUjZk?=
 =?utf-8?B?c1AxbGxRUGVjN3g4a05KZ2VDQWVVV3o0Vmttdm1LeXBKbFMzMHJkK3MzL3dR?=
 =?utf-8?B?RWpReGhOODA3OXR5UjNkNmpnd0tLWFEzQ0I2OTk2RHpZME8rRytJeS91eE1t?=
 =?utf-8?B?cXFHWW9UM1dzQWVwMGlsWU9JM2MrbHlxRmJ2MkNnUnM4K1ROOExoUFA0S1NN?=
 =?utf-8?B?RmEzMkFSdGdpN3dQOFhod0RtZnFubTI0U0pVY0JQWE53NW9BRkxmN0QwK25I?=
 =?utf-8?B?Q21zb1JkTVY0bGlYdWZYbU4xajBhV3RadnJNT2lRMmpYNGNEZ2dKV1NXZmFC?=
 =?utf-8?B?cXZhSmduTm1zZGdPWmRVa1VBaDU5TWRTUFp0dUZVSlN3N2ZyaW41YVdxNVI4?=
 =?utf-8?B?Q2RNT1VqVEJ2c1Y2RWVEY2RHZzdCQUdpaENMc0JDZHFZeTNhbmlCMTVrZEli?=
 =?utf-8?B?aWJZcy84eFd2QklYMnJBMVV0QWZsL0tpa0hrSjlVNUhLZ0FpV0NtV0VpU2Ni?=
 =?utf-8?B?N1JFYzhnaVFGOVBRQTV2VkxiR3F0SzFReDVtODFsVDl6a3VQaXVEWkp0TXU2?=
 =?utf-8?B?TGF5alF5YzFmVzZRY1cyYWUwWXMxUmRCU3oyS25PNmczcHZIbUt3MmtUUlBI?=
 =?utf-8?B?TTFwYVNrQnVqY0U5ektKbkV4UmtTSnBDc0NZbllxR1BKUHMrc3RLaUNnNzNv?=
 =?utf-8?B?WlFGTzVDWmNlSCtkd3lXN1pnb2huMzB5Q0ZUeGhEclpwSkxDL3VHc1pMQ0hk?=
 =?utf-8?B?NmdjOWlESWVsRlowaC93b2dYZStXWGxpSW1LZWczM05vaGV4Y3AyQWR4b1Jm?=
 =?utf-8?B?VHBNME5MRnJqMzU2cm0yUDlaOEoySUk5aitBLy8xNmZkbzBMQVI1N0hLRW9K?=
 =?utf-8?B?TGx5Wk1TRVl6MTZkRjZCU2c0dWdIUk4xU0k3K1I1K1JUY3pNQ2MxVDFvYWFn?=
 =?utf-8?B?bEFsN0pscW53REJ5YUFETkhxQThlQVllSmV4STBPNWhHTHpraFlXVDFjeEZH?=
 =?utf-8?B?aVIzYnY2MWNJNlF0SVNVSUUwaGpEYUtMS0doV2FkSC80WkRaNSs4aENPODQz?=
 =?utf-8?B?VGppdVpJQjVJUVh4L1ZiL0ltYkhINXRFLzhGSElBdkRyMDNkZWNYRitaUDUv?=
 =?utf-8?B?S0syTjZuRFdFYmpqMDJET1hOVE4yZUxQYlh4dDVQSFhyU0hQSnU5TjZCbnl2?=
 =?utf-8?B?YVgwUTBJczc3UXhyVTl3bWFKVm40eEVtZmdOZk9LYTdmcmZxR0V5VEtLV2Jq?=
 =?utf-8?B?N0lOL09NZ3VXclZQTzcxcW4vOUJpa0twN2VESndLSmUrUkUxR3JOQ0hSREE5?=
 =?utf-8?B?NHdXT3ZvWTlrcHpOQk5yQU56c0d6M2VVWW1TbERueGhGUVBCYkszRlkxMko2?=
 =?utf-8?B?R0o4bnRDTk9rZUZaYS9ObFZJMnV3d0hDam1JbHZMRk40bXdKMWNwY0FmaWtN?=
 =?utf-8?B?N1VYaUN1T1k4M1FROVpvbWZtVWR5ZTRHcFJUekI5aDkxQXJvaVNuYnhORmRD?=
 =?utf-8?B?TUdQbUlkR0NWUmlpeXZWWXQxbWZFTCswZmwxZm5pZXN0Q29NNTdiSyt5UTYw?=
 =?utf-8?B?cUNwdjdWZGV2MkpGNEdEVHBrR3h5bTRYNHdRditiWkNWYThlTFFaNTFENzdD?=
 =?utf-8?B?V2I0Z3h6WWpiaHl1ZHpjQWhZRWtHd1Q4Ry9sTjVOOGFQL2htZHlzSXhnZVN1?=
 =?utf-8?B?R1NneGhCOE9MbW5rc0g1WDFzeWh1a1JQS0E1bFFONDZmYWlocGdSVDg5dFJj?=
 =?utf-8?B?MGxhT2VUVEJqc1VWYy9ray9IZUhXbFhTTWx6aWd2KytEcngxbnR2MnJHQlZO?=
 =?utf-8?B?d29JQlZ4K0VVcHBKcERCZ3p1MUVYVHo3MkoyVDhLNnQvUFI3aFh1d29XNVBK?=
 =?utf-8?B?aXkyeDlUNUphMDNveWRZWFVxc1hHS0NLZ25mQzJCdlVEK2h6em9sdEdxaXFY?=
 =?utf-8?B?blMvM3JjK3hsM0k2RVkvM2hOYnFDbDJkc1pvdnZ3bDd3c1k0Vk9NWnF2VEE5?=
 =?utf-8?B?bzhKMC9FU2VBUktLdVZpMk9wNEhGS0R5OGNiZFdpdVg5RzhpUmhoYXhNc1pU?=
 =?utf-8?B?WW1QTklOZWxxSVN4bFVJQnJKY1JhRTBsUHczTkZHbEF1RE9wR1RiSWR5Q2ZV?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6791cc-0f4d-44be-1ad6-08db3baae6ba
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:09:00.6672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCBObr0Msx4lopPaNPXF2Ahp75kir1P4RSZZPhkJONbhTavf2ZmKBFvf6my5U89NiAyBc9QB69+cSLv8x1QyrspNIQ82hH16ml9267ildd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 12:29 AM, Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Current implementation is such that the number of Send queues (SQs)
> are decided on the device probe which is equal to the number of online
> cpus. These SQs are allocated and deallocated in interface open and c
> lose calls respectively.
> 
> This patch defines new APIs for initializing and deinitializing Send
> queues dynamically and allocates more number of transmit queues for
> QOS feature.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
