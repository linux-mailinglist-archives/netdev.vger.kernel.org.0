Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DC764E120
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiLOSmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 13:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiLOSm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 13:42:29 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3E01F2D6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 10:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671129748; x=1702665748;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/E5FRcIuofEvZB6UxXu2x92KOe+PfBXHaJgggPqWxu8=;
  b=UAYkPGHUpuQjUuHiJKns+Ft2eDXL1gxCtwsjBM6irCvqITpQv4f5gsqS
   aayPgo1UBadUBhITjKWSVvWEOu4V5r1RWJXvQmVwCfdy/w42F2Bll/XY7
   NygeQ1nwhmiIxK/EHMVeoo000XOK13g34RZv0T840hND7Itos2yqaa++y
   kKU702eeq0fn6NTSyA8fVRkrqXeM/a3Ob3B9lmQf1cpjCc+WI5666pqeM
   wBHJfzN0CsGFo4d/2RzBGeewGE19WkJ8COtebcUGx+B/673aUL9H+Il1y
   cLlcAzqconMx2+9c9eTK6G6hfu1iofkxOfNc0QtpKOcVwXD8XVRpjQXcF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="298437834"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="298437834"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 10:42:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="823824355"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="823824355"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 15 Dec 2022 10:42:27 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:42:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 10:42:26 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 10:42:26 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 10:42:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ns+XU5fITKbvruaTSt382he/6Z1mrMTHXbHUqV8+hnJFXQ1JaLg6UwQJzeToDulDkTf5vh5731NJQOwaLw/yJgWog3RHPhL2Jg4d3iHxZ+s5G1Mft4qhukdo8e6URQfCAf/dy1NcNLTu6/XtccMvZdh4wAkoWs58h7N2TZA/vxc/G3DI+J7ZenAFFzXXnYn8vZGPMi4RewtsXpOtgT6ap7hGVa9NYJf2XnFxMfmJ1YgOFNqD6pM2TtUicS5BjmVS8qnd1gN/1AnjWM/kwRsARnQYl8kMmsSKft/OlsyOcPm6Zt0gfjcuWrm2UAn7zmmJc0kdmRHTkDbrWzJHoPCbXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csntNFYeh11QX/jv0RJJ3I8R1gsNp1PdQ9055zB4bls=;
 b=awLRcwdArA1Dy4MEHM9c6RdarSEChAfN+yrNjNqSFszfhrXvVHLUmNM9cys18ykrnSVZXUywKRrT63Mpwb9l1tEsEB9i4noBOOcUELoqJkwS4htqLGmsOzbpxoTCP9coYLgqv667MNQF0EDSaAiubzGieNtX9bh1ViIsfbouc8QiiVBDzG5/ziXXdc0X2Q0HvryYT4PIABICn49ifJS7KC+OhZD0NNf7gMfGHrf1C7PyRj80eQ5usBK+6wU7Uc8nvMJqxo8jzhyk11xEtXOM7BEE9iPYB0aamZRZA9ypczRTmQ/AE43MEoSSD0TRwHiUbG3ZwxtAlHPNkeuxOUn1qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB7350.namprd11.prod.outlook.com (2603:10b6:8:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 18:42:24 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 18:42:24 +0000
Message-ID: <f10175b1-edd6-4c58-7b00-59a5b2f71af5@intel.com>
Date:   Thu, 15 Dec 2022 10:42:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net 0/3] devlink: region snapshot locking fix and selftest
 adjustments
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>
References: <20221215020102.1619685-1-kuba@kernel.org>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020102.1619685-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0172.namprd03.prod.outlook.com
 (2603:10b6:a03:338::27) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB7350:EE_
X-MS-Office365-Filtering-Correlation-Id: 192fafb3-d103-40ff-6a7e-08dadecc1ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZrSwAJlue9c20B9Czmut9u90zdiOFRP6tgUIQLP7SXyV3CEBuHRIsksWAwQ0GYD6lnX3iwVPze+zOj1lGU24T0EwGKkzv08BAxtfwqSJoamOClN2GoNPzcrwCBsuFXwJefSDWksEDyZFo9GK9AiT9uc5mQjDYmQiiU2KmUApFO00RS/55N9+azMdsXIgw4To1pqs3JWPE60+lK6afLOtatib0wXeJY2iimttwgf/AggmezgCzyui/0yR/5CyMlNq85Fpu1rJt8IYjRs5kONet/2Q3cx8HssKZ+3uVkFmTexn75GCmLKB0JHdnyFx2lfl0bS2XhKSiv0ZJk9FCpeRIXVPL/XtANbNQetiBy8c56ud0P1ekQqcMGPCKw1EGPXAp8ZI6DoP9mBx/1sm3nw+cNAZnFyX/wh/eHV8njZB7Ql/XhH9vuCGmmJagcpweyj2sL3L8BB4gXoC1Uhw+RVbALtvGFERfaEgVxPyS3g6Y/pEn5IC0Z3Qao/SI3jRcwronEpylxPcBru5dq566d8GU1/RFkxPuziuI27Is827X/io4XmLvZiFTeklXeAQ1f+dSCwp/S5iZQR/GbKzllAMcTzyrBAxtMo1qTP497CEcDzMuCTKrxw2ywiRYXvivZnZG+DBCVbmwTGMsd2HBVGgqLt6eimQ/cpdA971VCBM0bds0pc32nYgqGAN+2o8Y9cYJL+hAlFXdz+H/mFzI1E7p+uq7NLPweGYPBR2hedQYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199015)(31686004)(2906002)(82960400001)(38100700002)(4744005)(4326008)(86362001)(26005)(8936002)(53546011)(41300700001)(6506007)(31696002)(66476007)(316002)(6512007)(8676002)(5660300002)(66556008)(36756003)(478600001)(6486002)(83380400001)(66946007)(2616005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXpyYndmNGlPKzB2NXN2Uml2WlhMTk5oQTFlUFpuTU4yZitwOFFNbUhTYXo3?=
 =?utf-8?B?VnUyKzhaMXNKKytFckJCSWZ0bkFMTDBtNHZRRVJrTWRRb1ArcGpXUHpscDRH?=
 =?utf-8?B?b1VHTXdab003UzNBTmliQWU3WTVsQzlTRkhSTGJDNkVhMUxOamdCWTU3TWdR?=
 =?utf-8?B?S21QU01heFhhZ3hXSmFwRi90U2RyeW9HZUVtMDFvYVBHOEhCWC9HTGJyQkNY?=
 =?utf-8?B?RmF3cGpGTGFzcDUrTmtlcEZKY1FuS0tteTN6aWI1NnNUTWgwTkNQOHJSR3dr?=
 =?utf-8?B?am1veGdscVB0UHNDeEtGWTBiWDJLd0U2WFBRU081VDhoZjBBZHVNM283VWJ1?=
 =?utf-8?B?N0ZLejVJYkprNGpwRXk4cURTUDFrK1lKV256dVhwOWl5bVB5SnVMSHo2TnVk?=
 =?utf-8?B?RnE3cTlVZk9pN3NNS09MRm9BOEpYMEc3VVE0T3FTVzJ1S1pGUmJ2MVhFcm1K?=
 =?utf-8?B?bDA4SzZqUXNGQmVSVjgvcUxmZGh4NEVvdUVYK1ZHQTNGWHEvQTU4TDMwYitr?=
 =?utf-8?B?UUU0ek5ycngvRjdvRGlYa1FYc1c5V1pxZ2xDMlVqM0dkOEhVQ2c0THBJY1c3?=
 =?utf-8?B?TGdaNXdvQTNYY0RVd0NnOEduMEkrUGdVaGkzR05NTzlPNk0wOHpDOHc5Vlda?=
 =?utf-8?B?dDg5cGY5dXVPOVVJaUtUTWxWY1NRMTZERFI3R3dwY2VRZ3ZCZW16dXpQMi85?=
 =?utf-8?B?UGdpVjJQV1JlRWdUa3I2ZFZlYTJXR3FmOGxuUGxRbHJLRnNyQ0FRMmxjTTVy?=
 =?utf-8?B?ZmZxRzFENzNWSlZLK1FYMG5OK3RSeE53THd5c01kQjdGSk9sOVhFRTFIQXE5?=
 =?utf-8?B?NENmMEx4K295NzlLdVUrOXdXSVA5VEcrZW5NajBqcGVVdjNacGhXT0FjTGxz?=
 =?utf-8?B?U1JsRllieUtqWHk4c3FubUt5YkIyak1sSm1aS0lhK1UrVTdkcEFpNXVaUWNG?=
 =?utf-8?B?OEd3RW1tYnpWZ20wV1lobXF4VzlvWXZpYXhwUzN4R2RXZ3lDRVNJakpjQXRM?=
 =?utf-8?B?bTNQZ3pSNjJGcEZQUDA5bGNMZ2VXTTd0UkRzQWRNV3RiQkU4S3hYa1U3aGYw?=
 =?utf-8?B?dnNDWXFDMWNnTVJCazVPLzJ1NXpCemRaUUIremN2Z3ZuUU5nMGFiaDRuYTQ1?=
 =?utf-8?B?WjJMNE56SUZtOFdJQzNvaXJQY0NldWx5cTZPTEp0YXNZUy9vL1Rhb01aaCtU?=
 =?utf-8?B?b3ZZeVF0RDBmK1lGaE03aUczYkVNUGQ5cWVXbEZZRWV0WXM4VUZmejQxeUhP?=
 =?utf-8?B?YWtXSm1EajRZWCtJZzFselZ3YkNabGh1S3N6b3VjOWc4cjZ4OXNPRzdlWTVU?=
 =?utf-8?B?b1FvYUQvMEZ3c3RUNCtuMW9GSWdPTTB0a093VXVKaitPUytBbEpkODdzVThL?=
 =?utf-8?B?OFZlaVBjRHNNL2FGeUdMWDQydVAxbVB5bzlKZW9YVTJ3cVhucXNlYUFHYjEx?=
 =?utf-8?B?ck1mMWszcVNLdVNaaGIxL1JNQStHVkFiTGVZVGl0bi9oYmdaYThXRW1DWWRF?=
 =?utf-8?B?RjhGYmw1cUk3cmJkZTlnejF4QnZGOTBFR1g5S29HZ3lnZDVBanBZa0N5QkFl?=
 =?utf-8?B?c3BtelZFbXVnTzNJT3RtZTRxUkZvUHNsQ1paTEhDeEdkdllET01jQmx2RTVw?=
 =?utf-8?B?YVdsME8rZEg4MGZQQWZ2ZG4vcXRuMkRvblF4SjBhbE9pUEN6czVCcWZ5QU9l?=
 =?utf-8?B?Q0VGRzFrbkw1am82TWV6dzFKQnRaaFJnR3pwQzI5aFJBTHhHNzFlam9nNEFw?=
 =?utf-8?B?NXhuRDhpb1Nhamd5TXp2bmg5aDlvbkJWNXlIVldMV0dUT2hiM04wMEJWdmJW?=
 =?utf-8?B?ZW9ZQmxrNTNyR1VGNW5LSHllQ0dyWERNalNhTXd4a0N1RGYrOFZUUWluYWpK?=
 =?utf-8?B?VW1XbWxqUUJHU2hycVhnbUw1ZHQ3QUpPZzB1bWtQUW13dmRRNXVkRjBWTUhk?=
 =?utf-8?B?WnNpVlNFNXZvOUVLMVdib0NMMWUvMVFRTENhYkltNHdUVTI3M2tnTjhGdGhY?=
 =?utf-8?B?bzA2MDFkdjJJOU5FZ1Mvb1BhWk9QeXV0YU1TUEFnYUhSa0ZjemllM2RVOVlK?=
 =?utf-8?B?TFJZZnQ2aVhkZlpFVXNRdUxJeGRBK3NuRy9IbGY0TkYrejB5c0J0OUdScVlr?=
 =?utf-8?B?S1g1MWtucFRieDBCMk9PUElPYjJuZGpSTGtDMzVMckRneVhLcWF0cnhwYlJF?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 192fafb3-d103-40ff-6a7e-08dadecc1ba8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 18:42:24.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1aiF+B8ohlVPAxB63Wum7YCImPcI9/f/Za9EGsjGNRWsLhyPyYBrB00o7zBghJsO7h3JkgNTxAkp6d13S/HD3tQeOXiLggXJkFg3Q1js6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7350
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 6:00 PM, Jakub Kicinski wrote:
> Minor fix for region snapshot locking and adjustments to selftests.
> 
> Jakub Kicinski (3):
>    devlink: hold region lock when flushing snapshots
>    selftests: devlink: fix the fd redirect in dummy_reporter_test
>    selftests: devlink: add a warning for interfaces coming up
> 
>   net/core/devlink.c                                  |  2 ++
>   .../selftests/drivers/net/netdevsim/devlink.sh      |  4 ++--
>   .../selftests/drivers/net/netdevsim/devlink_trap.sh | 13 +++++++++++++
>   3 files changed, 17 insertions(+), 2 deletions(-)
> 

Whole series makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
