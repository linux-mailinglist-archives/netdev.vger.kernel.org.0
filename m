Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E232A4DA9D2
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbiCPF1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353639AbiCPF1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:27:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AB85D5E2;
        Tue, 15 Mar 2022 22:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647408398; x=1678944398;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lslJ3Q9FvfJXCn5+f3KkGbeKasRdOfEXq0iio5WD8iE=;
  b=Ohadg+1nIfBucsn5f3L94No8990RmPjeZgJmLZXrQtkMCUrwm6MZs35l
   Rk4ENkpXyqRgtsRWpxat4ITmPHNPx8UR7z+i3h1rGj+l9xq+EfeqPN7M3
   SxXQJZvCd/oFfflzje4wH4O0ZFGtEWE/x3eoqDUyyiN1zGnMVbIqzqYwJ
   RXrmqSPM2DR5B/+wIuaPA/bWz4SxYYq7G+Bc2z1aET+Os6df3xbaAnuAq
   VE2j1HVrvISeUDOm7FCOyjAtiHYP/Qry950dmtufgXLK2AjKSp05ANNpN
   owH6DvKFXhhtmoERi1u2lVMQ+zx7w2hntacbr9yDXpkwTdBHRVXXzECUw
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="342926746"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="342926746"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 22:26:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="512888842"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 15 Mar 2022 22:26:38 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 22:26:37 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 22:26:37 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 15 Mar 2022 22:26:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 15 Mar 2022 22:26:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXFSM9x4OvtOVHZW0sx38MLft5HOF0/sl/9T3VlrPqYCHlcqHs+HhpwW1cs0D0BlgYzR92Dm9n0mH0ATUc1uoJbFna7nDHknl0gsFzYGhrgcG7ySOAc+7PisERIw4DRiqHJq9DgvAf9pEuq3PFtxLfDxMkjzM7HeQl5CqMBCUpMQpRZ+dOtEMjd/qSdR6DpzcAewf0EpfQkTd+eVwkqBIRsVdx0MVrDwjI/sUYMr605a/q0/lL2POg5qC2phOOcIPqtLB6ir9Ya6i1xFvcOjzxF8GbzRwXMZxa9eT2n5r7GW2lQDbt4miKw4hshImXGSDrb8wOMg+i89Z8K5f1TG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDcoM2YgiA0vvSlckQMiMWQ2nDACI8NxobJmkdrpPdU=;
 b=M6UenvcS9UTOIw+WY67XNOO4WIxAQtLMn0CgyV1HPFKmL7WPX5d7uwK9fs9BA2NIYsiGHC7kdG+tlgP7LIZDxXMbxMWyAktcpka++OIX8bHDn9rYJOWn/wEfP8IY1uZp4CrVfdpFAWUmsUu2P5iLwkWgmNTAXVj/ZMiTyG6qPi4NQo2J+xaj5K9ZtOeUCIXHX3KxnNtqA/aGPjT3JOGnPC0iEzchxTExQJcgXycrCsWvubKdSvQTBABAhHry4nwFczeBWQaqzw38HfTlp6Q0mx7cfIYe/5g8at49UktzkwUg7/7nw4RWUPjeW7o+N0rNeqNlgGBeVgZPB4voC9XPKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CO1PR11MB4868.namprd11.prod.outlook.com (2603:10b6:303:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Wed, 16 Mar
 2022 05:26:36 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d6d:f382:c5a3:282b]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d6d:f382:c5a3:282b%6]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 05:26:36 +0000
Message-ID: <6fda3983-a32f-c78c-0150-37593bf5db68@intel.com>
Date:   Tue, 15 Mar 2022 22:26:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH -next] ice: clean up one inconsistent indenting
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <anthony.l.nguyen@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220316000307.66863-1-yang.lee@linux.alibaba.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220316000307.66863-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0030.namprd14.prod.outlook.com
 (2603:10b6:300:12b::16) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 385d3014-ee17-475a-bec3-08da070d8a35
X-MS-TrafficTypeDiagnostic: CO1PR11MB4868:EE_
X-Microsoft-Antispam-PRVS: <CO1PR11MB486844D3AA639369048C90FE97119@CO1PR11MB4868.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B+Ay+3DNcgT2B3q1K8ZS95Z5f1lZ2aAFNxPLsHCoSJIgt2QbAxO/Fq5gWTihmo3t9CPd0KzbQfZfC83v588V7WO+H+FFVfeCXCBYewkybVUG3JAj2ogLC0AgPwMX3mdyP+vGhx4Z9KcA/9NOUGtuFPQdHBW9ewgKXnZV9+qsL79BhD0nqOc7NUVCH+x3njrPErTOKTaVBd8uWI6L3GDZwGG16c7NDSjusitjcYfIAZ8c0hB1DCJ0GlDER7ns7ZuyMDaAIf+YjbnwTW6g8zA4pxkWmxcxmhJNiY8GUl1TY9AMY43IttG+46KJPbDbRlPAnL5BeKQSkZf+bVLO41chsO+YONpHFsTVP21oUqrZ4gAyGAg8KcFldkbaintCwuW/i5s5QTxdhmjM3DvXsmxMGj1J6l4Z0Zcwn/XWc1zuQqRIpz5IDGnGVBoR9Zy+mqJcy1Ga9R8D388g5k57a866EdSY86ZFmPumOyH5pTvwGqHb6XdVDwhRl2njGkyL3qZASIbuMwhiaN5s2JVeq5+BkwQnaSnoiQ3Oua9hKZ8ZpVjty7RhoNAxDcQhkz1oOxgzrS5rZUduzBTMrMWpOkU6gGARwYFdcp4roWaRSZhokD29Bk7uta9QfLzzX2O6nObg68lsyIKUSV2zx6M7jxNVF7qD7pi5VGAIE4ezOYR+vUGVv+N7JQSWSb/qtg3z/hXbgABygHmgLc7UkXHXbavB33JdqamsWIg1ZnFbxpLqtEl3GLvoTl9XQBA+MfTg1bghcHPqZsTK8nGI1X7Lb9clQhalYy7O28GbURlnQLwZqOgDImpvT8m2wZe4ndWD3szdCBJKFGK2lJY5tHGTaT3xxKrEOvC4Tu3kmjUENuDKRs0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(86362001)(38100700002)(83380400001)(6666004)(4744005)(2906002)(8676002)(4326008)(508600001)(44832011)(6486002)(966005)(8936002)(5660300002)(66946007)(82960400001)(66476007)(66556008)(31686004)(53546011)(316002)(36756003)(6512007)(186003)(26005)(2616005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDVmbnJqT3hoZVdQa01UYWNWRFptajlIaXcwUmc5eFMxRitmdjVWQkJzcG5v?=
 =?utf-8?B?VXF1VGp4Ukw3Z1RKNnE0SVQ5Y0FCbDV5OEt2MHByZ01ESDkydnBHd3B5cWJh?=
 =?utf-8?B?b3NGUGd4dkE1YitDSnpWdFhaKzUrVWRiMGtOdjZJSUpMNkVYRjlKZG00RWVw?=
 =?utf-8?B?cUwyZUpteWJ5SG5OZ1lZa0VHWDVScHVSaUJNSkhQVEpMVUhFSnR6TWRINGpo?=
 =?utf-8?B?MGtTZmxKRVRwTE5aM2ZaSlNUY3h0dkxBQnVhWHJXRTNFSXc5cjFpbE1BVHE1?=
 =?utf-8?B?RUFOWnlHRXJKYnh6Tk1tdHplV1duN0pxZWlVRDRGKzJTK0JDN3hTNnBJeDJT?=
 =?utf-8?B?N2d1M3hSRllqNFJLYWFmWlVOQXUvWlFvWHhWSGpQWW42TUFERVBxNlpIMG42?=
 =?utf-8?B?ckJLNFV3a1RTVW1vdXZ6UnFweTBmeVFpVFB2NlNMMFdyUDNBb3drVUhoMzM5?=
 =?utf-8?B?c1M5ZE1QbDN2Z202SkdGWkh5V05lTkV2VlBhYWNwa3ErNDdYSGErbVRlQ0Fy?=
 =?utf-8?B?UmlFYzJva0FjMFh2Rmc4UGhNd1IraGM4U0dHSHgxYUJZQWlXTzhkdXJjUGxa?=
 =?utf-8?B?WGEwQ2V1TnZtL0VoUWYwS1dJV2dlNjY3ajZ6eGY4R1ltdlNOWFhsVmVlYjlL?=
 =?utf-8?B?Z1lVQkR3aDYvYWZ5OGZpL0pjTXFpUnIza082RmUrNmVWV1NBUjc4SVdLb3Bx?=
 =?utf-8?B?elRKMWt4VTVpTUwyRVVTczBMdEg0RVhtSVY1Z3RYaUo4NVUwaFBKLzBVWkd5?=
 =?utf-8?B?dnp5OWNBcUVSSFhJRDJWTnJxMFJJRUFEa3Z4Z1NheGR2azBXQ2tCNVNLbzJH?=
 =?utf-8?B?cGNMeDFoZmdyR1FRRWg1NDBNUFIvRGRzM25xSjJsNXJ3ZVFPc1ZtZ1UrUS83?=
 =?utf-8?B?dWVyMitkYmNEaVVtM2FFaUk5UnNML1pUSVE1Wm9Ibkwwd1YrL1BTSlFiM2dF?=
 =?utf-8?B?TlUweDEwME9pc2Y5VFJwWm5BbjNvUUNONDZmYWVVWTgvbTdDUE5TU3Uxdll4?=
 =?utf-8?B?TDcrVWN6RVdqcjFyZUZSRHpSeDV2eFpiZzZoSzN1NlVkcjFlMTNSUGY0NVE3?=
 =?utf-8?B?aVIvbUk4Y3hQZ0tUL0ZrNXJ4TVZnSUtwS0R6alRycUpieFdpWWlpL3EvTU1j?=
 =?utf-8?B?QW1FajlmUndpMnpDWmljQjlwMGRFcnVadndWWlZKZUZCcTU5THoraEVJbm12?=
 =?utf-8?B?QWU2QlEwM09MTTJ5SHpzdUQvRk5JVDNGRkpCTEg0V3FzVGhDamMyaGZzVDEw?=
 =?utf-8?B?dTQ5UDRqK1NWUVJ2MWZGN0FSaWNWNHZNa00yc283UTM2SGxsZFlDSlJ5UjZw?=
 =?utf-8?B?Q1hrYXVOUHNiOWZtTnJZNDVGcm1WL010RmVGUHVJZkllTXlZNGlNNElUNlhX?=
 =?utf-8?B?TXd0bmh5V3pVdVdRRVJWRHRxeHNxUDNiU0hDNk12SkpPUU54eTROTEtBOTNV?=
 =?utf-8?B?Z1poSS9qbVVMbFppemFHc0x5WTZBd29OdTU1anQzWWJ0eDdIMCtjVmI0andX?=
 =?utf-8?B?aHk2eHlBZU1CWEFYM1R4ejFtRFRabDRrK0NzWHRzTkx4a296MUxKYlpxdldT?=
 =?utf-8?B?ZTFUMlQ0Z05aOERSVzZlQjdVSUhzeE9WWnJyRGUvWFZnWDl6MEFkR2JzUHpo?=
 =?utf-8?B?TVdOTkxGL0UyWEkwZmNGTFIrVCt4T3JlcGNhdytFKzBhWGdNSnR2OTR5eU1R?=
 =?utf-8?B?YVFqemRYb2tobVI1QVVnV0RuM2UzQXA3d3N3S08reUxZem5XNzNsWFk5UWFk?=
 =?utf-8?B?dXBwRUlyNWRzVE9hcmRjdVgyZUxVL0xOWmhPbThReDBMTDFSelNybFR0bkxK?=
 =?utf-8?B?T3ZyNXVVMXJWZnhNeEhZNWYrZWVqOFJuR3I3cm5kS2VFRmU1R1RrbjRGTk1G?=
 =?utf-8?B?UnhTMUYrL1dJRTYzYTNsRk1maFJoSTRoU2ZKQm8zOWhOZ0RCdk55ZDZvY25u?=
 =?utf-8?B?ZVpMYmNQZUVoVC9mTk9kY2VqbmtUNEZaTGJkd1JjcC92cnZ2d3FnWFpKVEF1?=
 =?utf-8?B?S1A2VVFGRmlnPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 385d3014-ee17-475a-bec3-08da070d8a35
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 05:26:36.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skb6JDGZf1fOU7yJo+oSi3B85YtBODuJ5RNsqKSSTcJ+i2kkzQD77vHNfyJOG8xd/iq99BcQ3f+nmnoFw+6R7UxHftZx3UHz3EVCKvsfW0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4868
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/2022 5:03 PM, Yang Li wrote:
> Eliminate the follow smatch warning:
> drivers/net/ethernet/intel/ice/ice_switch.c:5568 ice_find_dummy_packet()
> warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Thanks but this patch has already been submitted on intel-wired-lan, as 
it was already reported by the kernel test robot.

https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220314164314.15218-1-marcin.szycik@linux.intel.com/

As well, the other inconsistent indent patch is also fixed at
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220314164137.15101-1-marcin.szycik@linux.intel.com/

They will probably be sent to net-next tomorrow in the PDT timezone.

Thanks!
