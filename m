Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD6664E13A
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiLOSqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiLOSp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:45:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6741F2D6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671129957; x=1702665957;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zm3SvdzAChmynSOAlIJRG/74UfogrUouCYbGfZd7S+M=;
  b=EVVWairvPmcfhQQUsW8uGEVxvlwDtgVcN3xPmH8+tFb3NwJFLGh6crvc
   8C6cvLQ/neC0A+WBTCqwC/y+5I8aWwngUb079KdamrWe5KhvuQNa07wer
   0UimZGLdnZ0HCYoQqRfgq6setKFn0v3/srsEP4xNXIjaAe44/wqnGlDHy
   aE4tcEBybdUXr86Xprn1N8POzqYc+uKgi30nKvLf+bNNa/jHqe1UBdOpv
   3WVdbD7/0xduB6l+cYQ2RKt9SliIv6Mmi2O2P3pdbsHqd0B65mLOYUlVP
   NT7M4HfQvPJv/slZIs81GvVeG1u+wdPp3hc8Sunt9AqXBv6pwegg1Ixu4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="302195826"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="302195826"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 10:45:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="643007390"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="643007390"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Dec 2022 10:45:52 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:45:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 10:45:52 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 10:45:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/S3AE0fCuzDotR9BPqWI6L6GYeK77ZUkCsFbKdxXVJyh5Mqz1Vr5ev2aRliYdPk1WQpKpCFk5irhU+g7Cde59xWWuB3v+JnpgbiDcvBcJ7ZVIxdKqWMHnxwjZmlKSGf+1Q1DMn1YlgkFWd8MwGCJRgD6rf/B+4KNSy9UzuD+SKU3bZcH5kpFxMyI1jJLzzelUpRNxOZqIY41xVhx/8NhDd4egZvBPluTTRuhqOaD0pTwqbV+Vd1V1DjHdKrmXyvkBB7Efs6w+p2u19KdNxLMjdQO37tB3e/yusJ8gDLsCq8rzJlCocNZrgexaV1xM0wU1hwnqjUk4pvQP/jPnr/sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHaXB6myK/h7K8XpTiqtGOHWCyM5rVsDGkWA0uG4fWQ=;
 b=Irf7cQaxtdpLjhUF0NKUeMmAKOxBVkWaQtPy6yaK6KCrkqPSW820x4RCN0YYWqiyLgu3CFv6tYS0rvuOUVbZdcTNFTkgQPqyb1MsxMYsBSf0i4e8O6/7G3Fr+STJpD2Xar+d8o78yRF87pbpGK5SwGVYuCBDGtOFUYxUerJSrJCdBDcQaX9SkAgoCTjlY+/F/DLmP6NQZC9wSWyXkPTGJ0rGMDo7MR7dax6tW2dMw5/5kK8mJzoQJOcAbfVQQQM1UCibZ4o4DUWOUUAxO1VZL7SYikbdvTJOmebD3H4NkhbdlvIHk7Ul4tEjTauSDTLG2po9vAs6vXVVlbeg+uB4rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 18:45:50 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 18:45:50 +0000
Message-ID: <e350733f-d732-4ba6-a744-d77a37a237eb@intel.com>
Date:   Thu, 15 Dec 2022 10:45:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 03/15] devlink: split out netlink code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-4-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020155.1619839-4-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB4902:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bf76922-ce1c-4b47-9ac9-08dadecc965c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6vzkqoDS5shrm1bVmTi8SGP/8fblYJq+DRlaGuc8Qy9MuYQS5x+GoMpg5TzznN3Ii9Wr3/gTlSfftA96nE1rP/7v1UI5YuIBVa4e1H13cgMmNDBTBIaHzsxevR4SijyZFfOLe+M13FvoLW5rOj8rPeoW+NmWbGpg3ZvxWbI7zZcuqfrijzScJMNUECWPB+ceSYHUJI0K5ZIyd7S81h2cxYh2UcVueGbANE9PGad964wWr9SEa4pE+NCFFats3JV+8hzJrc7zEbcvJZ8HGV2srZWkENdHzOCWy8MtvRCbI18qevFmD5ccbh5VjZN8w4wrTFTQEogY+NWCB3mMyU+v6QYMXWWVPUjprTghx0NbVrark1X1A3Xddvb/8HS3Jxsu+r0UdgwddRvVESzSD6OuFI79PtfLwx8PJCy7H+vL6pp+T/ZxNwP/IGavhsroyMS5U8dTXj9xsoSXVtFfub5+WLGA559S68ppMBQn87a3wNJtrm0BFYgueVC91V8x1EhF0uB8v7QfgzxGhHJziB4tdTN2y5v6o6BN1tGmIIl8yez/1pfJUoksHxra5lwWwf2SMwlRsWnT42LQGjPJn4BdKkl/QJnmAHNODZWkxf0SunuI6ba8gtRJ+2/H83ZG88prpVUS5tx7g2TtpbfbrqQOJtaH2BSExstDrJigmKKu3l2hnm3rqRMvuNZmO8eexDoFriR9t66Q03AJYoMiayAQbE51D2apByKK8L4qo7BXXbk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199015)(8936002)(41300700001)(36756003)(4744005)(66476007)(66946007)(66556008)(316002)(8676002)(5660300002)(2616005)(82960400001)(4326008)(38100700002)(2906002)(53546011)(31696002)(86362001)(26005)(6486002)(186003)(31686004)(6506007)(478600001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVZzK0xnUFNwYmFET2tKVUk5VFJjYVpkR1J4NlhsdzNQSStwMXYxbEZHZXhz?=
 =?utf-8?B?QjdtTTlWRVc1NUk3UkhHbXZnOGVZOTkvRVpJVlJBZDIzMzVlUEhqS1p2eVR4?=
 =?utf-8?B?ZXRwZHhERnNtdURvRllXTUwxSjlycW1oUElzOEVnNjJxQmV0K2lGS3lVdzZP?=
 =?utf-8?B?VVRJQzFGSDA4VWcwN2s2TmRjV29oRlpWV2I1bkZEbnJjS3cwY01RVjkxazIx?=
 =?utf-8?B?YTBwR0w3eFEzME5CNXltNVRFSXMxTHc1ZXZ6SVJGUTEyZklJYnFhMjBlSGhN?=
 =?utf-8?B?eUhyVVlRdk51WnRGUmxlRksycmgxNi9jYlZpSTdTVTI2Q01zQ0FRbFNyWDc3?=
 =?utf-8?B?WmQ0dmJYZ3FSU05ZU04vRmEzM1Fvb1Q0WlREczVtdDdoU283Umt4RHNsQ3pW?=
 =?utf-8?B?M2t0NndoN0dpVDFKVytyT3ZFa0t6RmlEbGtZS1JQd20zNWdtUGl3Q052NVBt?=
 =?utf-8?B?akdtNzFyM0hoTnNScGc1Z210b2l6SlVHYnBKM2NzWTh0Z1UrL3ZjbVRCeHpx?=
 =?utf-8?B?WUpqbkV2c0RVVmFZMmE0bldRZm40UjA0d0JHREU1VnFUS28rd1Jyb0d1U01x?=
 =?utf-8?B?UElBVGlnb2dpRU1tcUlUQzZWTW1DVG5YNUwrZFJxT1ZEWld6Nmk4UzBRSVRN?=
 =?utf-8?B?ZFZ6TUd3UCtadkFzMFIzUUQrWU1DRFdKbm5neXJONXk3bzZxS2l3YUhXN3c1?=
 =?utf-8?B?bUVrZm8ydXhjdnk4VDV1N1RTYjU5WHB5WVBHQlR5cndIa21XQzdpTVYrZFl2?=
 =?utf-8?B?OXN6RWFPTlhYRjRldWNmcHZPblkyT3dXRTN0ZEZjdDh3amtGbXJaU0lTT0hR?=
 =?utf-8?B?Mkt4QVEwbHVEcmlTOEViVkgwNFdFUTJJQS84OXg3S2d4bS9lY2VRQ1M1K0xG?=
 =?utf-8?B?SlpzS2NjSWtWZGtGRlluaWVtK0FrRW43QVI5T1ZhLzJqZnMrZlRsVHo0K1VC?=
 =?utf-8?B?aEZpL202cVoyZFV0ZWRvRnh5d0hJWHhnVXBHWE50bHQvc2gveFZKMXNiSWhx?=
 =?utf-8?B?MG1Ea3k5MWRjM3FCd21Ra0VUN3JyclA1VWRsMExkdDluV0laaW9HMlRKV0xU?=
 =?utf-8?B?S25hV01PTnRuK0FCaWhjUG1SOW11VGUwSzk3aDRYRFRudEg4TUU4VlFsUmZx?=
 =?utf-8?B?bG9sK3lwNU9kQnJWZHR6eVUwSGpsODh3YWN2aVZzeGdJQ0dGSTdNdk1QY3Ir?=
 =?utf-8?B?N0JqUXZxVXl2QUZoL3RKVVhBWkttdGk5TXhUdDYyNnd5aXRXSU4yWTczSVRW?=
 =?utf-8?B?TlhKQlF4b0pzbXNxVXpzTy9TRUFBclpoSmRaMy9JaVd2cHdFL05VUG5hWTdT?=
 =?utf-8?B?MCtsMHdXVmwzc0UzRDR1MnIwTkZKY3BlYURKQk95ZmloRVJBOUZTdy9MYkVu?=
 =?utf-8?B?L3pTWHBUZlV1Z0IxRFV1N0FoeGJrS3ZXSXBVdC9tcm90OHVDVm5veDdsV2N2?=
 =?utf-8?B?NVdRaVpMNTRkWFFJZndwdHpUdGlJTmVSbkdNRVFHekdsT0dhZ3AwMTB6VFBY?=
 =?utf-8?B?aTEyMDk0aTRXMU9UV0V3cGQ4QzN3SWNFck03ZlZZNWRiWFdUMUphTk9iQzY1?=
 =?utf-8?B?UlhpV0taMmIzL1dWR0RBSEtiMTQ5clFiOHJxeUQxZ0xlVXV0b2pWR3lldkpu?=
 =?utf-8?B?dWtIRnpJenczZXZQem5qclhEbDJNVDEweTFEaFJmWFNodlRrY2VlSjlZV1JX?=
 =?utf-8?B?blBxZ1orUGNnSWpNcXFVaGFjaXYyaFlieDFhOVdEeG9SK21xLytSTUtERUZY?=
 =?utf-8?B?VWZhWnpTSkdZNEIwUWJoTUtVS3BnRmJJUmJCa2hCWjhwSnZVWTNxNkRHaDdF?=
 =?utf-8?B?K1hzcU91ZGc2UU1wWjZ5QWl2MHlEYVJkdFNUZUZ3VFRYY2lrL3hVOUduM3Nz?=
 =?utf-8?B?VnRZRTB4VkZ2bjc3cjNUQlI0Y1BhYWpzOGMrcnJqa1E2b0ZUanVzMlFSOU53?=
 =?utf-8?B?aHNvcEVzOGZIdGZ2RnduQXd1SjFzbm1RbjZUd2NUU1JjMkdnQTdUdWg2OVI0?=
 =?utf-8?B?UG5mY3NPdmN1b3F0QXBrNUp6Zm5DTmU4YVdibFp2ZlJ5eGpWSUxqU2RRNUU3?=
 =?utf-8?B?UGxMSnNxdVE4Q1JvMG1nMzVvOVpTMEh3R2prcnVWR2hBb2lnVHdQRVcxVlo3?=
 =?utf-8?B?Y21KcVpSa0dqWFNzVVhBY1JtUmlRTi9JUmxJRkVCNFhNaXpIRys1MHhnZFNh?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf76922-ce1c-4b47-9ac9-08dadecc965c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 18:45:50.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lG5GqzZlxHw0gT2ZSCLVZH0nPX1CMxx6HvqTNo0QIrvpbArloWJGT0OU2iOdU7HJmsV8taa5SQ/25B5hpyzc3OpZOYayHzNBp9EcWDgafWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> Move out the netlink glue into a separate file.
> Leave the ops in the old file because we'd have to export a ton
> of functions. Going forward we should switch to split ops which
> will let us to put the new ops in the netlink.c file.
> 
Moving to split ops will also be a requirement for per-op policy right?

Thanks,
Jake
