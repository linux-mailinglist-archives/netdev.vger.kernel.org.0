Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F64573FB6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbiGMWsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiGMWsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:48:10 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01574F1AC
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657752489; x=1689288489;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WE0cjFyoMc6tnmdNqVHfj1jtBCXyz7aZudb3ZbwoLAA=;
  b=gy8lzs2U95M4bBpnEL6tl2a/wK3N3781ocDiV56XhCBQGTDJXAMnUGRH
   5qG/klV8JyyAD0wa38OUhLqEHlroUteKUCh7gfMQVpbKBdGGS8y6wsvYm
   qGgKT7Up3uol7zw9iuAJF7EjWGEWyIMZsS1ElLULn2zZ5UvhqP5Ap2XOw
   0eMBZazYyVeZMEq0gRcdyTOotsBZWC2T2wCNNDVC270C7fXrsQsKQ1B9c
   75x7ohVCyf2886WTVIbH4d0zx8Ihx7ZfRszMyDSj+xOM0pr+Yhe41iJh5
   siQG+5pEETyWbaiChbcuu1nJzT/aDa7GLDS3cLVkPaSw+8cdggY9bOaym
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="265775443"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="265775443"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 15:48:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="698598404"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2022 15:48:08 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 15:48:08 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 15:48:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 15:48:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 15:48:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKZPwE31t4FXPNOM04/M+JFis4ztIffrNeqO10ve09RrcRvUcSOIMsq6Uu9tXcix16csliSod6nkGkzRWs1Utz/vOPvv0Iqn3P2c5WZs2611dm538mhD2MdCKZIDay9v/sWwMWwNIXvffiSfzTq5APMZ8umk9SK2upDJu+NInQj6eCc/i8qRzdQOm1O9oy4zjx90LfUxB6CRcwgfHg4pAOtjXX9n3TCp6VeWwL52NS5Uk/6VaBKnLoUxcV3MDkaZkVMnoRyLgntEDvJF0BRGv2rWvQe/n0+CBAwiJ7GFl3ioxzCl0vl+RTe1fkac6Iia906AWfQsgAuGIIu8nKawWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFTTBS8HKsJxWYSPNIH5b/1YQc5uK9l8y6wGPketQMs=;
 b=ekBFF/NxdFLT7l/4jvScRszKSyb+D87WOlTEqBIyu7NftNk7i5FK5k/fnWdnR+DuJBz+uu3Qpm8b02utcVX+sL3cwZPCaAOy+NE+CIVOTIk6oxz+1AqWOrqsuqve2DFE/ixsNuzd2Pgt2UE8VZDIEKRX/aT4L2HqzrvE7O6r8f9mwm689GLTpNAVtthRHZox9zb99N6fGREPG9KhVXl36pUT02ClxgM3tLgSAT9nZPEmmcrfS27r4E78vMPgdE5c+MEyGC3pRQWbpM+6zAN5kD7ajWSMN4vQnI6++x12lGxjhagHYIh8FI3FuRV5C6tXac4YZ9o4fWsBTJPsmp9PEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5186.namprd11.prod.outlook.com (2603:10b6:303:9b::24)
 by CH2PR11MB4261.namprd11.prod.outlook.com (2603:10b6:610:39::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 22:48:05 +0000
Received: from CO1PR11MB5186.namprd11.prod.outlook.com
 ([fe80::c5c0:f51:3f1f:9877]) by CO1PR11MB5186.namprd11.prod.outlook.com
 ([fe80::c5c0:f51:3f1f:9877%8]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 22:48:05 +0000
Message-ID: <ececa999-1e66-ecb8-972a-1dc2ba8d64fc@intel.com>
Date:   Wed, 13 Jul 2022 15:48:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 1/1] ping: fix ipv6 ping socket flow labels
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, Gurucharan <gurucharanx.g@intel.com>
References: <20220712165608.32790-1-anthony.l.nguyen@intel.com>
 <20220713124930.6d58af50@kernel.org>
From:   Alan Brady <alan.brady@intel.com>
In-Reply-To: <20220713124930.6d58af50@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0187.namprd05.prod.outlook.com
 (2603:10b6:a03:330::12) To CO1PR11MB5186.namprd11.prod.outlook.com
 (2603:10b6:303:9b::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54441c2f-9722-4fbb-f250-08da6521bfcc
X-MS-TrafficTypeDiagnostic: CH2PR11MB4261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3R30fADYvvJilDmoVz9dISIJJnOWJn0QlQwq0veCUX4xG/CiqHS+/dueTeRApEBqj95rRU5ZwszSMxjvEG2DvBdqFvi6N0yU9Njh/WqW+SLK/WZZGQ7s7KK444Fgtp7bvsv7IIyT0sYoaZUvEvh4Tsi4o341tT+dCemuiFWWgJTml9hAcDXEK8A1A1MGWqSoRGudG9oUmpmM7WL6j1RbbdAZ4dzSOTPeCE2RQrLMS4KaxQBUMEdrpPVpqFQxcMDJ1F/t5QmQZsb4UXHLeZL5aAywZ4ojIEklQV+cA45wiL4YDeS8ausCaE1TEofk9nL3qnLb/Uuy59g1tbJTDuUtcvw0jf8KoXHbQCiDbempar0UBFvlxoltp3x0wAWBxndyi2VXFKQCHgIAzyt/hXpVq1toiTdI0GGMw7d461UNI/PwFkl2G5U42bMCn0tALH9BbVLa/+EK9dPB7+ckIUQLwqP8sBJtBfzbrhdCpOZQoye9d9uPb6mgHTBBnBNzF09BUVyMA90Y4hx4ESdBWyjWA8zBXJ2sfKtsvyX4tsL7n26gi9YqtD7yQg1TIBK6cBHRYHVrfAjr5u8ZGv2PmDmzxEsSJrQ0jqC1mtEOzMmCLeDMqqClQqYEQwvTNR58h6nUKy0W9eLO2D12Ufp3sOts1KUqGlxNBkR17h9VCoHCfLLym1WOHySd1/D7xOy69lmzOeeP8pxrGo4zE0MB7W6asZO41mM3AJh6f7mtht05bvAv5+0UV7J1RXbli9GLUfNtEIdOeBPZ3QXaUMrPlFqD8sbHbcQ2/kN+teaVIGOuQRN1a2Uv7uTnRnVvAaOC1SWBck8Q1Gta3foJdO4UpODK+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5186.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(346002)(136003)(376002)(38100700002)(2616005)(66946007)(82960400001)(31696002)(8936002)(31686004)(107886003)(5660300002)(4744005)(44832011)(478600001)(41300700001)(66556008)(6666004)(110136005)(66476007)(316002)(6512007)(53546011)(186003)(6506007)(86362001)(26005)(6486002)(8676002)(4326008)(2906002)(6636002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXhmK0hKQTczTTBrMTZxVTRKL0U1K29VdFdTOUx2SnNNV0ZEY1pyUVVQYU9x?=
 =?utf-8?B?cTNwK2ZUZTVJRGs3YnZZaWYyQUUrVUN6OEtBeFRZeGtHMHJYNkl5RjVWekxX?=
 =?utf-8?B?NWhTZXVaVWRLV1ArV2lRM3M1ZWkySWw4TG56d1hFamdFcUtOUGxzbG5qU1hn?=
 =?utf-8?B?dXBTWGJ5SXhXdWNLcGN0bWJHbjhObys2SUdJdGM2dExyUGV0RlNDYkxaWk96?=
 =?utf-8?B?Ryt0QjAwWlFNcHkyTThFaWJLb2pQNVI4bVNwbm0xWTkrajIxMUtHUkJ0dzVl?=
 =?utf-8?B?S2tVMWJqNjNzOWtpTWlDTzZMWjZ3MWx2MUxlQm9DVE5jUVhXWmJXZCs4NXFD?=
 =?utf-8?B?OW41MmFRcytQT21qWFZBNWZqb09obUkxN1RxTHNWZGNSRjNIOWwxclpFdmNP?=
 =?utf-8?B?c1JtR2p3b1JRZ2xtSUFqZVlYaUVCS1JwSUFCam9VK1lzbHhCUWJGUUdvbERJ?=
 =?utf-8?B?U0o3S2NpeHJ6VlIzdkpqaUJTdWxoNkw3Mm9pNXpGWUg3RGgyS1RuNllEWitx?=
 =?utf-8?B?R2FvUWxGNXp6NmFyMkRjUStHRHMzQ2xvS2xMMEQvbzJoMEZmRFV6R3htOVpl?=
 =?utf-8?B?VVh5MlJVeXdBRTZoL0JLTTQ0Z3ZUTkM3dERMaDZKQU9kVTFTcE9aang5Z1hh?=
 =?utf-8?B?ZkJieDc0Q0c2UkhKUUFiei9iSjY3OU80WVBEOGxHYXkzK0M4YkRMeXpkalRT?=
 =?utf-8?B?RDVEajZ3RlFOTW00RG5DVm85ckdoRkQ1QUJsZEVJRDRreU1yMXh4YUdZNVhW?=
 =?utf-8?B?OWhMc0cwdVJDSHptZWJSYkplNlFGeFJWbHhJTUlCNkJDNUF2QnpzaUx1QkJ2?=
 =?utf-8?B?aEtLTUpKZlA0TlRockZoWkJFVkk3TVRiV21wSFZ1V243M0p3cmJnOHZPWGdU?=
 =?utf-8?B?d1ZsamREU2crcDYrMHdyWUlnYkVVdkdjUVpId1Qzc2hTaUZvN2Jndm1IRW8v?=
 =?utf-8?B?NnJaWjlYOGZuNE5tb2RENTZqcEZqeHphcEdZcVZrOTlPQ2JsWWtsMVNIUXRx?=
 =?utf-8?B?Sjc5UkQrQWZvNGZJVzFJc0d3OEowUWM5Rlp6Mi9abGdXM21jM2Y3Zy9mVkow?=
 =?utf-8?B?VEFOdDNQZzFVVFptNVRvdnBzQXF6bzJCNjArNXZPSFFqdXdUTG5pL3AwUnF1?=
 =?utf-8?B?Q0hONFo2V3JuazMxcDcyYlB4eURPUU5JT1ZLRFZGcWRZcS90dmo2ak56WE1M?=
 =?utf-8?B?dnJBQXJ3U0d5MnA2eWxkNXJFcU81cUdPakdDWWFWUmdCTW9kcDlKWm5EMW5R?=
 =?utf-8?B?Z2didjh1Z3pZTmRhM25weVNJZTlpTTFMSlFhUy83djdQbVNlSmRqeGJEdXhT?=
 =?utf-8?B?bWRRN1UvU2FBeks0MXROMVZVVE5vdnR4YzkvcXNuZWpUa2ljT2FIZU9qYVJU?=
 =?utf-8?B?QnVyRWpDbEYxU09FeUYzWDQ5RGUvQi9NTDhqeW1Wb2JGUXl3R1EyWUxFd2RL?=
 =?utf-8?B?M1VjaGpIWmVEZitvU0pFU25Lc2JNSy9MdWVCcnNXZjltZi84NWFnWjRJcFUx?=
 =?utf-8?B?eTREM1JiQWN2T2FJMjZSTzVtalBod1RHSU5JZ3VSZE9tUWZXUFZCczl5VnJn?=
 =?utf-8?B?SEZjb2paMXh0OG1kVkVadGdpRTArSktnY0d2dTVNWVZYT0hjTS9OWmVvcjBp?=
 =?utf-8?B?VmRFTjExR2lKSWVGOEs5eWdBUXZqNmlsMlhwZGk3UDhDNDBZTEh2VnM1RCt1?=
 =?utf-8?B?eXhGRWhFUDJBVVdRdkNnb0wzSmd6TTdtaHlnZE5xL1BJbWxZcWdHbEVjemsy?=
 =?utf-8?B?M3Y4SWlkTjcrUEpyRUVLTlVVRjRXdEVCNG11M1FMeXM5TFplY3ZteExNY1NH?=
 =?utf-8?B?em9vL3B2SkUyd0RoKzVOVjRPaEFveVZHb0lvMno5L0NkYk9XWWhBWkNwcytY?=
 =?utf-8?B?Uk5yeksvMWFwVkpyWkViZGVBZVBiUlNNZ1ZtaFpPSE9RZnk2TnlZZVRpTkhy?=
 =?utf-8?B?SEhYWW00dUtOdDQ4eUVOcnpCOTdNdGx3MHI2d21XeGN2SnNzOXhqS0NGVXND?=
 =?utf-8?B?eVRLR29Rck1oK0hVYXhtK0FEZG9CV2R0bzZTQWRDMHdoczNtTHpNMHpwZ1dO?=
 =?utf-8?B?R1hUUFZKWU56UUd3QlhYSWFZQy83VFhFL0xzYU9KM2FFY2k5YnEvYytERXBH?=
 =?utf-8?Q?EmF2YObJXuwqmUnclPHHL89SH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54441c2f-9722-4fbb-f250-08da6521bfcc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5186.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 22:48:05.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8YnJ7IZC82im+ejOVJn8kbynE7ND0N8xNqZ8t+i8QdcCvNgaLtB2kD4cBwpYnNlniwNpZ3Ypzxw9odVQb5NRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4261
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/2022 12:49 PM, Jakub Kicinski wrote:
> On Tue, 12 Jul 2022 09:56:08 -0700 Tony Nguyen wrote:
>> From: Alan Brady <alan.brady@intel.com>
>>
>> Ping sockets don't appear to make any attempt to preserve flow labels
>> created and set by userspace. Instead they are always clobbered by
>> autolabels (if enabled) or zero.
>>
>> This grabs the flowlabel out of the msghdr similar to how rawv6_sendmsg
>> does it and moves the memset up so we don't zero it.
>>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> Thanks! Please add a selftest and s/fix/support/ in the subject
> otherwise  the stable ML bot will think this is a fix, and its more
> of a missing feature.

Gotcha, will do both, thanks!
