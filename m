Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF3262330D
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiKISzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiKISzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:55:04 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CA12BB
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668020103; x=1699556103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BwtPJL7CtWQuGzl7Zh3LhPhBkXvN5Rs8KFqWxiUyHIM=;
  b=RYkLoFv6teFFwN9iSJvo9fvcNpv+rHGdwwVHtsibOQkdY5hR7t9kVtf4
   V39Z62z8YDfomezSkWT/To2vrU5JyDyS6WB+6wQIpKc0sUpI/L64KmoIA
   bekL8M0v0QgJ62dRUrqofro71sP9NEP46WWXfm2OB6h1zkgezI8IMdZ99
   BTSdqN762JhFxSx8GvWhZjM0aFWigRZYXB4eubY1EHJDwZohFsiWNKkHT
   fipTG4qMs0F6z9JFquV5Mx9Nvt5TF48j/623bDMa6lkCN8sicYH2hd3r8
   Iqsgt2tRFxiKJhm4oUGgLskeRDXP9r+GY0W7sShnAmMiZvf3KdQL+1Qry
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="294444054"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="294444054"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 10:55:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="668099094"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="668099094"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 09 Nov 2022 10:55:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 10:55:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 10:55:02 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 10:55:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8UZzM2asCObim1xQaWe3AUWKgLCQlquEwLJaryZePQbRGAvPoB4xa2JL4irL31mKPm0deUxBy0Ugn58r1KenOpkFF5PSM5fw/xxYmT7lUvwA+3gUYFOmirF3vnqXxueX2gcgO90MTtwBfoC6QX1XyDgklYR5j4RnBnz6W0ZedJR8vg15XTLex5G/6o9YNjK5K80ddy9tow8pRirbIdlSVGk+F8sZLdJI1j1rwKrXRgGrhrwJPk20sSm2bzWPv1v1E7ZnByj/0TWaaWPTrFgtsq07v4hsKpkOmznylSb1ouUMWHYLBcexwrHqJ8PBPrq8Ngxu9evBXys2po+ZSc20w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIvHJOeFWtuVLxDv3mEtL79F0FPPt/vqR/md9QXZuBU=;
 b=AAvk0MSKhRgaHoJ/kdkwE48E0g5W8UhwZbpp7gLAoyPqBxAhJHKzK5DIGQ8uHAFy9US3yfD5FeV7m6KLFu7m/k96N2M9mpg9Zis2gFTurIshGvEHVDF2ab6pplHnUVZY9Zx+XE1EYJkOIGBju0RKWnLqZes4iXvtL3LeZ7Plo9fu3cTsBiAnr/tPrxiFb+askJ+cPCLRyQlClzRSJpCMoPgFwe2IVPYB5f3VhMZdH/jccHxSUzAnnn4oh4TUdKe8h/V5kNQX/EzkA11TF5l/I70b8SX4roU6TDcQ7lS/JcBVm1Mhj1eqcStYYr61UDjgVNlz4YDT3nvNsMRluhOgPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SN7PR11MB6798.namprd11.prod.outlook.com (2603:10b6:806:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 18:54:59 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 18:54:59 +0000
Message-ID: <de1cb0ab-163c-02e8-86b0-fc865796a40a@intel.com>
Date:   Wed, 9 Nov 2022 19:54:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v10 10/10] ice: add documentation for
 devlink-rate implementation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
 <20221107181327.379007-11-michal.wilczynski@intel.com>
 <20221108143936.4e59f6e8@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221108143936.4e59f6e8@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0201CA0010.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::20) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SN7PR11MB6798:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd7260a-b976-426a-5dd9-08dac283e696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKmB77PU0/bqg5CoonDG+q8irw+iMeP6rNsTMxTjGQZPyXtLmnuiCS2aIEmNenpkrMk/Gps9MZNCPZONYHJsRYe5PEjgPpvcwWZNso4i69/RihZcf8VX1Ltlvm0qFOBHVHFqjMBhLxv52zxR640NZmJ/oStzNgsQhNRnsvMLLW2lt5XYtsWhOu6BqeVQ8kRskFXOQg0WtHISPNSMirUYrqA13800BfwdcSk+kTZbalgi57LU5YR6qfiLkziNJJ9e3NcKU6mRMMF7mFYRa2dwnK9ZR0NAwbPe1CaeTvt0AbMADzh+SUdRAmB4z/u/z9r4TaHMfUlJanZ95RLePli9oMldMKPFt4A7vFVZTs4lqsII34ZA5/mxXSJdobqPpMHNGErGkmxmSyBD6SBpKwVZvcp833drfD2w5EjAtPzQRP175j54Fc96euoQwaE7qtsZSh0JIdqoE2Wq9fum/se8bYKkH522ku1N1wlV4bPxbAf+RvFhiHdplnAsh/naTN3uJT8GxGV2mhk+4HinEjeg33Hj8LIWln+FoF5rEVFM8/jTljGY8OvYy5ty55fOCmzOQZs4a1H7/cq6ql8vauHbNNhUxd9Mf+Ta9bAWOPq4v7SKiBRh4ZeNX8RjwsTiIEZ3HQDB9ryAYT8EVY0TlVEhtg0VvVkxbC++brF5BhcJrHBph78sASsnqCWFNQcUfKFP3fDBmT2ruEnipDg72FuXOojSjY1+rLc7sMDFhPDlsTZ4aiZtuYm2R+6IbhOWeFqPorExIeHtD1zuo9WRUZ9ROYNRCt+xJ1jYGGaL2FXv5cg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(86362001)(83380400001)(31696002)(82960400001)(6486002)(478600001)(5660300002)(41300700001)(186003)(316002)(8676002)(66476007)(26005)(2616005)(6916009)(66556008)(66946007)(4326008)(8936002)(6512007)(53546011)(6666004)(6506007)(38100700002)(2906002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzEvZ3Q2UXdIelZIWTFKRmlzZ0pUZnFMRWw4WjZCRTFYSWlYbU1LOEp2TVZs?=
 =?utf-8?B?T2NwOHRUYTR2Qkx2RnpzNW1mWWtJdGhkYytLYW5tSUttOERCeHZxOUZJTTJs?=
 =?utf-8?B?NFpEL2IzUUlVUmRmLzV5UjdvTHVnWjExdjBMTC80c1BhUHFhYmU3a21IQ1dp?=
 =?utf-8?B?c0wxenVKQzBxSHRSS1UzeWhQSzY5emNlM0xKbDRhaWtTL0JNMW5MMGF0VHpD?=
 =?utf-8?B?Qm5KcmpZNXR6cHBkc2NSeVk4dlhKRHRSalYrdFFpZ0MrL2x3cVNLc01lc01p?=
 =?utf-8?B?SVNVdHRNVnJLbmNvbUJBTnpaYVFzdHd1REF6K3pkM0xhNjdyMHhxaTJZWEYx?=
 =?utf-8?B?RTRkNENGeWhBbnZURW5xRFV3NHk5V1RCbS9DdXNKaStRQ0kvWldjUEhZNEVB?=
 =?utf-8?B?QisxbkR5VVJrZG1NMm5BUncxKzNadzlSWTExTEFFWlhzM3FTSWFHNWsrQ2Mz?=
 =?utf-8?B?TTFNNExEL2ZpUUphNlRJeHg0WHh6MHowd3pDOUg3dVFoN3NETHlGTUxpYmtr?=
 =?utf-8?B?UEUwdzM1T2pnN2IrSjk1WThMYngxSXk4eW5qSGE1RkhCRk9wYm8zcXNWbmdW?=
 =?utf-8?B?UUhUbkZQZ1NqVUpDd3NmeUd0aWxYV04zSWlQbDFtYVExWVQzaVlPWGJpV3M5?=
 =?utf-8?B?bENGNXBxbmZSME9oYWtXMkMxdjcyeGdpNENjUFlBci9xWGNJczExcEU2eGdq?=
 =?utf-8?B?UjgxUFpreEFISC9Kd0N5ckdEZS8vSEpVYkdJY2dpZVJDQy9yd05pYUJwMFB5?=
 =?utf-8?B?RENUTGFBdW1lbzF3VzRyNWtubjFCUDhvQTV4a09IU3BydzNGUGpHWDVnL212?=
 =?utf-8?B?eGNCd2dFajhPb2hDZjcvMVByNU92L0FGM29YajR4NXJ2REpJVGFyMmNtelVE?=
 =?utf-8?B?U2YrdlhJWnJ4WnZwQzFpSWJzenYvMHI3V01sTWh4aWt1dnlQbHQvRENybFdM?=
 =?utf-8?B?amRGYW5ORjNjNzBZZ2lvdERQQVBjWjdJcThxM3N0d0NqemxtM3dHR0VKMytF?=
 =?utf-8?B?d3hEbEdnY3VjTTZkQ1k1c2oxUiszY2NUcjMzc3VxV0sxNTlHYUpUK3B3c25T?=
 =?utf-8?B?Mk9PdnZSSWFJSHBCd2t3SklJWCtMTXk3c2dad0N5S05pOE1GN1dPRVlPYjhS?=
 =?utf-8?B?ZWp0UnRONk0rRjV3NVpwdzdiL2FMeGV2Vlk0NnkyRkZrN01WRFNmUmdwRmla?=
 =?utf-8?B?Ym9KbmZIYUk0WVpvc3NLcXVwOXJEN0lDOFg3cjFKUGhxK3BIbVR5OFd0SnBi?=
 =?utf-8?B?SGx1aGt3ZWFWMlp3VGFFRmxSOGtoVmtqYVF0U2xFWjhpb1VOck9ndmZRZUhM?=
 =?utf-8?B?NmFWQnhxNEVlRFhQd1lGMWcrK0hKYVo3NWduVVhhM1lyM2dBTG43cEprd2xn?=
 =?utf-8?B?bjJlZFBkd2xSQ0FJR2hKMFhpOGlLcFByMGN0bGFGK09lcHBhREJpOHU4T2NR?=
 =?utf-8?B?NEFlbWtRa09tUmh5eWs4Rnl3K0d2V2I3eVJpb0ZnRThzVVUxaUl6U1lyNDBh?=
 =?utf-8?B?K3REWllsRjl3cWw1MVFudWI3N2RFeklVK2x2a0JNYkNpWnRFMWtON3FZZ0Vv?=
 =?utf-8?B?NTBTYzg2b0JuTWxJU2piQmZ2aDB0U0RLRUpEbXdZa3NFc05waEU2czhzVy9U?=
 =?utf-8?B?cjlGZG05cFZQQWhGaXMycWlWVDhsSHVPZkc2elduMlBwcCszdFM3cFlvMTVZ?=
 =?utf-8?B?MGVmVkZZSHVyV25OWm01ejhqM0VJTlM4UGVyQ0dXSDJVUnZmRkpDeGlDWXBk?=
 =?utf-8?B?QmNJNzFZKzArQWRMRzZmRUFab2FDSDlJbk5NNDdVeXRTMjFnR2pRaW85L294?=
 =?utf-8?B?bWNSejVrcnd5b2kzTXBFZElGT0dwcnZoQ3A0SWMrUEM5TDMzdndwVkd3a2RQ?=
 =?utf-8?B?L3BjeHMvNXk1UFdINlZIV1p3QmxweXkzeVdUVkVEWVE4ZmswQlQzNFFqd3NK?=
 =?utf-8?B?RUZ6TW44SnF3SWNTeC84bFQyNGZCQTJFMVFrdCtNNElUS2FleFBXY1QwZUt6?=
 =?utf-8?B?M2cxQmtFa1RqWGU2Yk5HTU93QzY3cE9TNml1MlFqZU5yZGlKUjYxblFXcjk3?=
 =?utf-8?B?YlBhc3ExSFIySmFnNEpHbmJ2aU5RQWNvbEM1NnBjU3dVU2hmVXkvczQ0UGFr?=
 =?utf-8?B?V1NhTEVSZG11ZnFkMUN0MExERlV0SkRpdUt3YjJjcHFYaGppdzRCMFdLUjVY?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd7260a-b976-426a-5dd9-08dac283e696
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 18:54:59.4276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBbcaAyKAr9JSqfBTStvsrf8rk8dghPCViP6Oj2PmF2Dvzg7meB1OLVX8TCGxoYLWa/2S+yehKqM8XwgFk3rlAXFeUfMBEC9hNqJ6K9Ob5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6798
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/2022 11:39 PM, Jakub Kicinski wrote:
> On Mon,  7 Nov 2022 19:13:26 +0100 Michal Wilczynski wrote:
>> Add documentation to a newly added devlink-rate feature. Provide some
>> examples on how to use the features, which netlink attributes are
>> supported and descriptions of the attributes.
>> +Devlink Rate
>> +==========
>> +
>> +The ``ice`` driver implements devlink-rate API. It allows for offload of
>> +the Hierarchical QoS to the hardware. It enables user to group Virtual
>> +Functions in a tree structure and assign supported parameters: tx_share,
>> +tx_max, tx_priority and tx_weight to each node in a tree. So effectively
>> +user gains an ability to control how much bandwidth is allocated for each
>> +VF group. This is later enforced by the HW.
>> +
>> +It is assumed that this feature is mutually exclusive with DCB and ADQ, or
>> +any driver feature that would trigger changes in QoS, for example creation
>> +of the new traffic class.
> Meaning? Will the devlink API no longer reflect reality once one of
> the VFs enables DCB for example?

By DCB I mean the DCB that's implemented in the FW, and I'm not aware
of any flow that would enable the VF to tweak FW DCB on/off. Additionally
there is a commit in this patch series that should prevent any devlink-rate
changes if the FW DCB is enabled, and should prevent enabling FW DCB
enablement if any changes were made with the devlink-rate.

I don't think there is a way to detect that the SW DCB is enabled though.
In that case the software would try to enforce it's own settings in the SW
stack and the HW would try to enforce devlink-rate settings.

>
>> This feature is also dependent on switchdev
>> +being enabled in the system. It's required bacause devlink-rate requires
>> +devlink-port objects to be present, and those objects are only created
>> +in switchdev mode.
>> +
>> +If the driver is set to the switchdev mode, it will export
>> +internal hierarchy the moment the VF's are created. Root of the tree
>> +is always represented by the node_0. This node can't be deleted by the user.
>> +Leaf nodes and nodes with children also can't be deleted.
>> +
>> +.. list-table:: Attributes supported
>> +    :widths: 15 85
>> +
>> +    * - Name
>> +      - Description
>> +    * - ``tx_max``
>> +      - This attribute allows for specifying a maximum bandwidth to be
> Drop the "This attribute allows for specifying a" from all attrs.

Sure.

>
>> +        consumed by the tree Node. Rate Limit is an absolute number
>> +        specifying a maximum amount of bytes a Node may consume during
>> +        the course of one second. Rate limit guarantees that a link will
>> +        not oversaturate the receiver on the remote end and also enforces
>> +        an SLA between the subscriber and network provider.
>> +    * - ``tx_share``
> Wouldn't it be more common to call this tx_min, like in the old VF API
> and the cgroup APIs?

I agree on this one, I'm not really sure why this attribute is called
tx_share. In it's iproute documentation tx_share is described as:
"specifies minimal tx rate value shared among all rate objects. If rate
object is a part of some rate group, then this value shared with rate
objects of this rate group.".
So tx_min is more intuitive, but I suspect that the original author
wanted to emphasize that this BW is shared among all the children
nodes.

>
>> +      - This attribute allows for specifying a minimum bandwidth allocated
>> +        to a tree node when it is not blocked. It specifies an absolute
>> +        BW. While tx_max defines the maximum bandwidth the node may consume,
>> +        the tx_share marks committed BW for the Node.
>> +    * - ``tx_priority``
>> +      - This attribute allows for usage of strict priority arbiter among
>> +        siblings. This arbitration scheme attempts to schedule nodes based
>> +        on their priority as long as the nodes remain within their
>> +        bandwidth limit. Range 0-7.
> Nodes meaning it will (W)RR across all nodes of highest prio?

Yes nodes with the same priority will be treated equally.

>
> Is prio 0 or 7 highest?
7 is the highest, nodes with 7 are selected first.

>
>> +    * - ``tx_weight``
>> +      - This attribute allows for usage of Weighted Fair Queuing
>> +        arbitration scheme among siblings. This arbitration scheme can be
>> +        used simultaneously with the strict priority. Range 1-200.
> Would be good to specify how the interaction with SP looks.

In each arbitration flow, the winning node will be selected from
the group’s non-blocked siblings with the highest priority.
The basic rule is that each sibling group consists of a sub group
with high priority nodes, a WFQ sub group with intermediate
priority nodes, and a sub group with low priority nodes.

So basically if several sibling nodes have same priority configured
they are treated as a sub-group and arbitration among them is
performed using weights.

Will add this info in the documentation.

> Does the absolute value of the weight matter or only the relative
> values? (IOW is 1 vs 10 the same as 10 vs 100)

Only relative values matter. Will also add this to documentation
I guess.


