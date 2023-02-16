Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C50699180
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBPKgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjBPKg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:36:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997D354557
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676543766; x=1708079766;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V7dVA0Jva96oDmbZPwCIRXOLLS32Fy9g/bgV01od2+c=;
  b=BJBpPNhKtYnaJldbklcnwOOYSm6vIaTkok5X6fQEPX2xy36K/7a1+m9H
   fyhKBAKSz3yT60xfY2tNIKp2nAIQxHhwVJxWOrkvv5ReD++bFOPrHDvsn
   OVzhXJTD6QcISt5tmLBOsC46Ff4VG4Q/IK9xo0QwO0Wjs2txyTSaip0lc
   u/WzguDziWfFI6/tc6FGNtmWnmauWKiXBS5bPctTMGN4ZSS5p2XYCRLE2
   6McoKITOdQtD2OefEXubna1ZoZf5ldHGko3oveogwcM4ZyRVUprBwCdq2
   6sJE7jGMhcvWPJEmBNQOWMWZPSnFIjRpbVYCPZX0CcfCiBg8M2EVlTXGs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="417907093"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="417907093"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 02:35:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793981937"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="793981937"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 16 Feb 2023 02:35:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 02:35:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 02:35:41 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 02:35:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6bZTctHjEnETjbj4RQLtG8OF6LOJwlJ+XNNE5UzqxFoVctLTMGHgTGoyvuhmKEVvKqmXhFmh05PshFjz/0lQSolZn7nMRXZ/yeNS616FniNxhQ9Km0bLH+TM22aNXaDA2AWiXxTcQ8PHZKSetZdSxinxJh57JgdqGZpLSCzMDnAXpDFVLcd8Nz/k13NV7/X0LgTFCWJqKIOfFh/9kLKIdnKY2AOd/rOIUGZiQ/N4kRftcCWLkjh4Y0qGCBtuoAhoRagjUVi1vkjxIYxTlBymCoHN5k9TOvJfzw3/PAH8rNP2cNuMuYgxyQoBgQ3HpNN60JSbKd7B9ibRJjSQm24Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0jxsvnyWDCkOdDKneQ7i4sE1951p9p22KldRPsphhI=;
 b=Meq8kqs8zssLe+phAbowxOwc7ONMh6dj8XUZiztYjY7oa2Jo7gQ+PyLs0hF63hQyQiCTd2HcsJlVdF+DKvXO+Wn4pe4lR5OeSotQGeKzoQL8v0hbf32211h4jmhlcsahqjeNNCyayUGLD5a5sf1fgAp3NAxQ/Hz+81pet1UswU6kkX6Sv8U9ynWv7xTh332FHHpaOKOu0TZ9tunqMGVSxTN5hIi12cd/vCmapSQW4XiTv595II1pEAT7dAD9A5WXjv8HOA6GhqoTbK7TkANOe2iHnUjGHpJTMbK7HVJ1hGoyOYjoajdLfYLEXfsDhJEqctIdwdHof0RIWe4CbtVPXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 16 Feb
 2023 10:35:38 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f%12]) with mapi id 15.20.6111.013; Thu, 16 Feb
 2023 10:35:38 +0000
Message-ID: <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
Date:   Thu, 16 Feb 2023 02:35:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Subject: Re: Kernel interface to configure queue-group parameters
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
 <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
In-Reply-To: <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::27) To MWHPR11MB1293.namprd11.prod.outlook.com
 (2603:10b6:300:1e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR11MB1293:EE_|CY8PR11MB6818:EE_
X-MS-Office365-Filtering-Correlation-Id: a68fea69-93b4-4c43-8fe6-08db10098b5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RdZMnD4qoWQiYxuGsip2d1EF3G4EOIWnwT2iuzcgjTKyriiGOVZquUaQ1o42bqFWnDVA/Yp//rUPHLJMrBV5t3L4eUN6Z0hPgmEvYHfdxKBW5pseaXp4uSa4uqGpVJWBCyAG854cV2rAkeVm1r/C53RxKdJ2+s0KckBAOKnA7nreLccyMI3VALPcB9xOBWv/+W7UddB3j1htT+TEGOz+LnO9822xCpluoSl6FjvZLTj/ketbKV40Qxe5bBJiYY6F2x7NTyMHLw5gneZJWdPoGUgfILKTbPFq2U7MCCYwR3T7UInsUDp/kX64wOkobWVTEz/d5zyjU/qiZpq+EpOwWsuOf1AkEdhIFa+/v6HYduusRMXdTSgTRHFuE8Lcw3X6rEzYpR05nTTZ458i8i3a7VCLUkblx/KDIN3goaIS9PqOTMaf2NsDzUrCX0EnyOA6YDt+f0gjQWdjRBPqeAlEiOn4DuCbyk62+9q4kZTn1WqU4JQwt6H6Z1tiDawlZ/CXMMv+WN48sRIm5pCIYEWS8M79UXa26QW04LyFmBLauj8/Beh9l3/ohaOsxVn5dGzZMZQpLJP2CereC+8c0EiKmp2bf04dBM2lSPcpvqWLHxZlM6ukeYjJtJPxpyySGH0yiKpSlFb1iH7FsyRwCSEKIz1RPlCYkJzVf8GWFGfGEzFjdEo9YegxeDPTP1vM1b1KN3tqzSppUMZ86hu1gxCfJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199018)(36756003)(966005)(107886003)(6666004)(478600001)(6486002)(86362001)(2616005)(53546011)(6506007)(186003)(6512007)(26005)(83380400001)(31696002)(66899018)(4326008)(66476007)(66556008)(66946007)(41300700001)(8676002)(8936002)(316002)(54906003)(2906002)(30864003)(5660300002)(38100700002)(31686004)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWxtZHFUY0hrU3h6WVduVjZMWEQ0dWV2aCsrVnNLclBaVlVHcWNrQkJUL0Qr?=
 =?utf-8?B?UUR2TDQzUTZmV3JnS0xicml4NThTVDZVT0k5YjVIZmhzY1ZTbzExYmZTUEhu?=
 =?utf-8?B?NlB6bWRjRXBPTy9mL0VBR2c4TVdIdWovTE5oTnM3R1pVb1VjdUdpSUFuUWsw?=
 =?utf-8?B?OGRKektBaDF6SmNQNTlydEFLQnd0bDQ1TnR0dE9ObTN0R0xWSmxNNkszWGM0?=
 =?utf-8?B?SURPSkdhTVcvbW9FSjVCVFhUOTUyL25lam5pTU1jNll2WitONTlveDdOejd6?=
 =?utf-8?B?emV4ekx2ckc3UzBmWXdGS2JGTTVqblREb0t3RGhaRXEzS1VWVlFXY3A3T051?=
 =?utf-8?B?bUZ2bzdVMGN2YVRFNWF1L0ppZml0NGZZcjRaVXFSeGpFYXFkMm10dTJUU1B5?=
 =?utf-8?B?NFR5ZktrMnRSU3lERHBZL25ISng3alA2cGl3RkVTOXlGd3VadCswVjEwZjVG?=
 =?utf-8?B?STRrVlNkQ2tEQW5NUWJpT3FFZVl4bTF3SmxLR20vMHpPUENndXd4L3Q0bmZS?=
 =?utf-8?B?QnUwTGJwd2plbkNYcnFTaHJiYjdzazdncWRGZW1JVFZmaWIrNnp6WUxCNFc0?=
 =?utf-8?B?M1VGaWkwR3dxVUJlZUFCNEE5ZnRXZ2ZQRUJmNVU1UzV4a0p3V2hPYTZQWHJG?=
 =?utf-8?B?Z3RSZXFZUWhEeUsxdHVxWDVPbElpb2kvdS9icW5oTGhzOEJvUUhrK21aTUti?=
 =?utf-8?B?d2xYRTlKTCtBR0s2WEhSekF0bkJPRFVBY0tDOXlyeTdUMWo1RWNuVjNLV3dQ?=
 =?utf-8?B?b09qWTdmRWt0eGUzaTBPMW5sZWNKVGR2cVhQdXlwZ0NkUlFjVnNnUlBkYlJZ?=
 =?utf-8?B?MUFQbkVrcm9ybFZNUU83MGNkM3hTanZCanBoRlhtaFJLc0QyU0RiRjRkUXY0?=
 =?utf-8?B?bzBocUl0MEZCTGJsem9OYllFZ3A2Q3ZQTTFiV3BtTjhlc2RkSi9mSDROUGI2?=
 =?utf-8?B?UnVPcncremJJN200dWR0SXBHcWgrNGkwVFRBamRZM2kzWHJEWnhNbS9kN2pa?=
 =?utf-8?B?UHh2ME90QzYrM1dyYWpRbktHYWc3a2M4ODFhemxjZElHU012blhkdXBHRUZW?=
 =?utf-8?B?c0lSaWN6OS9BRUtpV3M4a3FTRm5selJvUHkxOWhGaGtZUmZNRWZoMm1Mc3BH?=
 =?utf-8?B?cUdJbVEzMEQ2ZEVBUzZjZG5rVDJxNUZ6UWVJVFZxUm0wUUhDNEMrcGhRNnpv?=
 =?utf-8?B?RFRJUmpDOUtLYzduV2M0NHcxOHczZDBwQS8wNWNEQ1lUdmJ0YnBKYSsvU2I3?=
 =?utf-8?B?V2NhNHBiSExybW14SnduV3diTzBuQVNLVFpTVC8zTzVzU2kyUHdYVWNYSmNT?=
 =?utf-8?B?Vy90RGd4OHp5VlR0aUN1Z01zTmtFU3Y1Z0pXajRUY2VtVnFDTUg1K3IzMG5P?=
 =?utf-8?B?MVN4bVFSa2IwSEJvMWVJZ1ZCazV2K0JON0tuWS9ncWUvaktrVU10MGpXajRw?=
 =?utf-8?B?d0o1S1IwTTljUVMxeFhteXZMZ1UxS3d4OTVHbFV0T3BWeUtLS1huT0RGR1NE?=
 =?utf-8?B?TnZkU0lKbE5DL0FCb3I5bnpIZWRCcFB2MU9uMGMyKytqd2NTMzVHYVB2WlNJ?=
 =?utf-8?B?QzJUM0NKWWtQbVplc1AxamtXYUxGdnJra01GV0pLdUtzNnEyL1F3TGo1MjVq?=
 =?utf-8?B?S3QwNmowVGNIUlhLU3RvU0JXUnA3ZExUTkg4MWJiaDBGaWhxbUlaTTJGNFN1?=
 =?utf-8?B?SXF0NEVHelpIazgrNWx3Q1VwcHNiTlNmSnBlUUR6OWVkZHhhTjhBV3ZFTzRx?=
 =?utf-8?B?YXl3KzRISjNTdkhDajJCci8rNUJWWWlQcjJ4am1XTHE4Tkl3ZE1kVXBJLzVa?=
 =?utf-8?B?ZUpiekJDYmJDQml2T08ybEx6bEtKUU9tR2hSaVRmSXlVZzdTUjRUVzdiKzRF?=
 =?utf-8?B?WitGU3pPUTJTQlpTaE9CQlc1MEZvY2ZyZHQ0a0tVTnRUbTVPVks5S3djV2FQ?=
 =?utf-8?B?aEMwbFdqNjBoWStCQmpYYmcrcEMxQnJlSzduMkNvTVcxa01QbkdCMEZEQ2VG?=
 =?utf-8?B?R3U5ZUN2dWF3VkxQcFIvRHIzZ052dEUxSzZCMDBNbVoxK3BSYStWQThFdWV4?=
 =?utf-8?B?bEtjcFh2UTlOSWxYUzEwcEZqYUtibjQwaHJaTm1SWEV1aVZkTmVkS2JnUnlD?=
 =?utf-8?B?eHRpbWtEVUMvMit4WmxoNlVadkdCREM0ZWF5UHlpem8yaTgveENLSUpmTld5?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a68fea69-93b4-4c43-8fe6-08db10098b5d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 10:35:38.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uo4JZ38OKK6mwwG8A0Dq8wMCTuTRKxF63XC5faSriFiuqnwGyw3Kf/lf+vzoWODGDuUMGESqs/aTU1aCQTX4BxwlszpSeggbfax1jbU+Awc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6818
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/2023 8:28 AM, Alexander H Duyck wrote:
> On Mon, 2023-02-06 at 16:15 -0800, Nambiar, Amritha wrote:
>> Hello,
>>
>> We are looking for feedback on the kernel interface to configure
>> queue-group level parameters.
>>
>> Queues are primary residents in the kernel and there are multiple
>> interfaces to configure queue-level parameters. For example, tx_maxrate
>> for a transmit queue can be controlled via the sysfs interface. Ethtool
>> is another option to change the RX/TX ring parameters of the specified
>> network device (example, rx-buf-len, tx-push etc.).
>>
>> Queue_groups are a set of queues grouped together into a single object.
>> For example, tx_queue_group-0 is a transmit queue_group with index 0 and
>> can have transmit queues say 0-31, similarly rx_queue_group-0 is a
>> receive queue_group with index 0 and can have receive queues 0-31,
>> tx/rx_queue_group_1 may consist of TX and RX queues say 32-127
>> respectively. Currently, upstream drivers for both ice and mlx5 support
>> creating TX and RX queue groups via the tc-mqprio and ethtool interfaces.
>>
>> At this point, the kernel does not have an abstraction for queue_group.
>> A close equivalent in the kernel is a 'traffic class' which consists of
>> a set of transmit queues. Today, traffic classes are created using TC's
>> mqprio scheduler. Only a limited set of parameters can be configured on
>> each traffic class via mqprio, example priority per traffic class, min
>> and max bandwidth rates per traffic class etc. Mqprio also supports
>> offload of these parameters to the hardware. The parameters set for the
>> traffic class (tx queue_group) is applicable to all transmit queues
>> belonging to the queue_group. However, introducing additional parameters
>> for queue_groups and configuring them via mqprio makes the interface
>> less user-friendly (as the command line gets cumbersome due to the
>> number of qdisc parameters). Although, mqprio is the interface to create
>> transmit queue_groups, and is also the interface to configure and
>> offload certain transmit queue_group parameters, due to these
>> limitations we are wondering if it is worth considering other interface
>> options for configuring queue_group parameters.
>>
> 
> I think much of this depends on exactly what functionality we are
> talking about. The problem is the Intel use case conflates interrupts
> w/ queues w/ the applications themselves since what it is trying to do
> is a poor imitation of RDMA being implemented using something akin to
> VMDq last I knew.
> 
> So for example one of the things you are asking about below is
> establishing a minimum rate for outgoing Tx packets. In my mind we
> would probably want to use something like mqprio to set that up since
> it is Tx rate limiting and if we were to configure it to happen in
> software it would need to be handled in the Qdisc layer.
> 

Configuring min and max rates for outgoing TX packets are already 
supported in ice driver using mqprio. The issue is that dynamically 
changing the rates per traffic class/queue_group via mqprio is not 
straightforward, the "tc qdisc change" command will need all the rates 
for traffic classes again, even for the tcs where rates are not being 
changed.
For example, here's the sample command to configure min and max rates on 
4 TX queue groups:

# tc qdisc add dev $iface root mqprio \
                       num_tc 4        \
                       map 0 1 2 3     \
                       queues 2@0 4@2 8@6 16@14  \
                       hw 1 mode channel \
                       shaper bw_rlimit \
                       min_rate 1Gbit 2Gbit 2Gbit 1Gbit\
                       max_rate 4Gbit 5Gbit 5Gbit 10Gbit

Now, changing TX min_rate for TC1 to 20 Gbit:

# tc qdisc change dev $iface root mqprio \
   shaper bw_rlimit min_rate 1Gbit 20Gbit 2Gbit 1Gbit

Although this is not a major concern, I was looking for the simplicity 
that something like sysfs provides with tx_maxrate for a queue, so that 
when there are large number of tcs, just the ones that are being changed 
needs to be dealt with (if we were to have sysfs rates per queue_group).

> As far as the NAPI pollers attribute that seems like something that
> needs further clarification. Are you limiting the number of busy poll
> instances that can run on a single queue group? Is there a reason for
> doing it per queue group instead of this being something that could be
> enabled on a specific set of queues within the group?
> 

Yes, we are trying to limit the number of napi instances for the queues 
within a queue-group. Some options we could use:

1. A 'num_poller' attribute on a queue_group level - The initial idea 
was to configure the number of poller threads that would be handling the 
queues within the queue_group, as an example, a num_poller value of 4 on 
a queue_group consisting of 4 queues would imply that there is a poller 
per queue. This could also be changed to something like a single poller 
for all 4 queues within the group.

2. A poller bitmap for each queue (both TX and RX) - The main concern 
with the queue-level maps is that it would still be nice to have a 
higher level queue-group isolation, so that a poller is not shared among 
queues belonging to distinct queue-groups. Also, a queue-group level 
config would consolidate the mapping of queues and vectors in the driver 
in batches, instead of the driver having to update the queue<->vector 
mapping in response to each queue's poller configuration.

But we could do away with having these at queue-group level, and instead 
use a different method as the third option below:
3. A queues bitmap per napi instance - So the default arrangement today 
is 1:1 mapping between queues and interrupt vectors and hence 1:1 
queue<->poller association. If the user could configure one interrupt 
vector to serve different queues, these queues can be serviced by the 
poller/napi instance for the vector.
One way to do this is to have a bitmap of queues for each IRQ allocated 
for the device (similar to smp_affinity CPUs bitmap for the given IRQ). 
So, /sys/class/net/<iface>/device/msi_irqs/ lists all the IRQs 
associated with the network interface. If the IRQ can take additional 
attribute like queues_affinity for the IRQs on the network device (use 
/sys/class/net/<iface>/device/msi_irqs/N/ since queues_affinity would be 
specific to the network subsystem), this would enable multiple queues 
<-> single vector association configurable by the user. The driver would 
validate that a queue is not mapped multiple interrupts. This way an 
interrupt can be shared among different queues as configured by the user.
Another approach is to expose the napi-ids via sysfs and support 
per-napi attributes.
/sys/class/net/<iface>/napis/napi<0-N>
Each numbered sub-directory N contains attributes of that napi. A 
'napi_queues' attribute would be a bitmap of queues associated with the 
napi-N enabling many queues <-> single napi association. Example, 
/sys/class/net/<iface>/napis/napi-N/napi_queues

We also plan to introduce an additional napi attribute for each napi 
instance called 'poller_timeout' indicating the timeout in jiffies. 
Exposing the napi-ids would also enable moving some existing napi 
attributes such as 'threaded' and 'napi_defer_hard_irqs' etc. (which are 
currently per netdev) to be per napi instance.

>> Likewise, receive queue_groups can be created using the ethtool
>> interface as RSS contexts. Next step would be to configure
>> per-rx_queue_group parameters. Based on the discussion in
>> https://lore.kernel.org/netdev/20221114091559.7e24c7de@kernel.org/,
>> it looks like ethtool may not be the right interface to configure
>> rx_queue_group parameters (that are unrelated to flow<->queue
>> assignment), example NAPI configurations on the queue_group.
>>
>> The key gaps in the kernel to support queue-group parameters are:
>> 1. 'queue_group' abstraction in the kernel for both TX and RX distinctly
>> 2. Offload hooks for TX/RX queue_group parameters depending on the
>> chosen interface.
>>
>> Following are the options we have investigated:
>>
>> 1. tc-mqprio:
>>      Pros:
>>      - Already supports creating queue_groups, offload of certain parameters
>>
>>      Cons:
>>      - Introducing new parameters makes the interface less user-friendly.
>>    TC qdisc parameters are specified at the qdisc creation, larger the
>> number of traffic classes and their respective parameters, lesser the
>> usability.
> 
> Yes and no. The TC layer is mostly meant for handling the Tx side of
> things. For something like the rate limiting it might make sense since
> there is already logic there to do it in mqprio. But if you are trying
> to pull in NAPI or RSS attributes then I agree it would hurt usability.
> 

The TX queue-group parameters supported via mqprio are limited to 
priority, min and max rates. I think extending mqprio for a larger set 
of TX parameters beyond just rates (say max burst) would bloat up the 
command line. But yes, I agree, the TC layer is not the place for NAPI 
attributes on TX queues.

>> 2. Ethtool:
>>      Pros:
>>      - Already creates RX queue_groups as RSS contexts
>>
>>      Cons:
>>      - May not be the right interface for non-RSS related parameters
>>
>>      Example for configuring number of napi pollers for a queue group:
>>      ethtool -X <iface> context <context_num> num_pollers <n>
> 
> One thing that might make sense would be to look at adding a possible
> alias for context that could work with something like DCB or the queue
> groups use case. I believe that for DCB there is a similar issue where
> the various priorities could have seperate RSS contexts so it might
> make sense to look at applying a similar logic. Also there has been
> talk about trying to do the the round robin on SYN type logic. That
> might make sense to expose as a hfunc type since it would be overriding
> RSS for TCP flows.
> 

For the round robin flow steering of TCP flows (on SYN by overriding RSS 
hash), the plan was to add a new 'inline_fd' parameter to ethtool rss 
context. Will look into your suggestion for using hfunc type.

> The num_pollers can be problematic though as we don't really have
> anything like that in ethtool currently. Probably the closest thing I
> can think of is interrupt moderation. It depends on if it has to be a
> per queue group attribute or if it could be a per-queue attrtibute.
> Specifically I am referring to the -Q option that is currently applied
> to the coalescing functions in ethtool.
> 
>> 3. sysfs:
>>      Pros:
>>      - Ideal to configure parameters such as NAPI/IRQ for Rx queue_group.
>>      - Makes it possible to support some existing per-netdev napi
>> parameters like 'threaded' and 'napi_defer_hard_irqs' etc. to be
>> per-queue-group parameters.
>>
>>      Cons:
>>      - Requires introducing new queue_group structures for TX and RX
>> queue groups and references for it, kset references for queue_group in
>> struct net_device
>>      - Additional ndo ops in net_device_ops for each parameter for
>> hardware offload.
>>
>>      Examples :
>>      /sys/class/net/<iface>/queue_groups/rxqg-<0-n>/num_pollers
>>      /sys/class/net/<iface>/queue_groups/txqg-<0-n>/min_rate
> 
> So min_rate is something already handled in mqprio since it is so DCB
> like. You are essentially guaranteeing bandwidth aren't you? Couldn't
> you just define a bw_rlimit shaper for mqprio and then use the existing
> bw_rlimit values to define the min_rate?
> 

The ice driver already supports min_rate per queue_group using mqprio. I 
was suggesting this in case we happen to have a TX queue_group object, 
since dynamically changing rates via mqprio was not handy enough as I 
mentioned above.

> As far as adding the queue_groups interface one ugly bit would be that
> we would probably need to have links between the queues and these
> groups which would start to turn the sysfs into a tangled mess.
>
Agree, maintaining the links between queues and groups is not trivial.

> The biggest issue I see is that there isn't any sort of sysfs interface
> exposed for NAPI which is what you would essentially need to justify
> something like this since that is what you are modifying.
> 

Right. Something like /sys/class/net/<iface>/napis/napi<0-N>
Maybe, initially there would be as many napis as queues due to 1:1 
association, but as the queues bitmap is tuned for the napi, only those 
napis that have queue[s] associated with it would be exposed.

>> 4. Devlink:
>>      Pros:
>>      - New parameters can be added without any changes to the kernel or
>> userspace.
>>
>>      Cons:
>>      - Queue/Queue_group is a function-wide entity, Devlink is for
>> device-wide stuff. Devlink being device centric is not suitable for
>> queue parameters such as rates, NAPI etc.
> 
> Yeah, I wouldn't expect something like this to be a good fit.
