Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB05988CD
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbiHRQ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245538AbiHRQ3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:29:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1125A3CB;
        Thu, 18 Aug 2022 09:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660840147; x=1692376147;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j6Jj2Bo/ZxNVeSubUtbojaHeaAxMgB/9LOJv+FbNnzk=;
  b=lB9JG5+NbK5aF0tlDrZkRS8FC6ME+V0mmvAYy+z1Xk2UVPL1XHhAMm79
   BZ/BBKkznwF4kVM0PPscfM3ZZ9mZ0+t8PHSMMqVNmdiiyJ4cfS/vrgQ8k
   zFBg47IxPmbGrOh7V3f2C+0wX73dBeiqXFsHnAHNZHbRJKYgUanOC5cBM
   5IyHWbwkA1XWgboAH6GXETb895mq/p9A17FVK7pW2NgmZn0uGVgz+emS7
   4BO7w7tgLs0z/6blqosgpBkbSIrh6k092ZYZV38qkh9L5QR90kWv51y2X
   IUup0qX3ONYajR59j4jltt/qnNA0CVJ3Gb/uqjiqdS6tUxIq9w507HZtx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="275852028"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="275852028"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 09:29:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="935874290"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 18 Aug 2022 09:29:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 09:29:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 09:29:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 09:29:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 09:29:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwdA+NsHhgtcyZj0TKX1Z7SibOii0gX213YUEbSD/Mmtgul9LXYBoMmFY5+LtvI9AXG39mMvqdTgaHXoJe0cTCSljU7mOwnxwegANauYIl4m8r4YQmIKLfpCxrAoqWx8uFvGQSnKyXbaLYwNqEfx1RwgAkgRvbOxEe6XxQ45WoBFAVSjbwxZiSzxccvkWk04U7stMf5yRSsDJMCs6i0QNwkUuqIFConLrc1TmXJTw8TDwESEgSavO++zuzG45tl2ET4xdIAdmsJTAO/5AvmSgPDief0lHAiJiS8WdLOSXxFSWv1TmZoYGRVJz6F8i22rGEPkxPI+avVbzCzkyLNrgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTu3h8dW0K7MLir26SsvdRCtDhQnxjXXWDIVpb3QeiI=;
 b=SVnW7ho3m9ah+Mmc+LY3ugUySF+Tfgxib5hnOJzEp2C0WHYxT7SbMetwzuyWskjdbTi7hCi9nEZxb3GmjfEY1bahkCnfSYQ07plj1aoysYXF/W6KUwl5N4WGRtTk+B+fER4ywsFNvSzCpRORrAHbIx28Cqmo/MrP2EVpi1TPM44OnEp4zySzqF3Hsboi52uq3GeSMAE/stiqyLdQRangLJlV04uhnOQrefj1h5+np9bfuO6eXt1cVOrvpF6/HLlh6u6MXjjLRGj9xIR6ckopLem1qOxqM6mhEEoNp7m83wZjGhwnzX2TYTMFGod/vZsi778e7OC9OQjpRxraePNXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by PH8PR11MB6832.namprd11.prod.outlook.com (2603:10b6:510:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 16:29:03 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::28c9:82b2:cf83:97c8]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::28c9:82b2:cf83:97c8%8]) with mapi id 15.20.5525.019; Thu, 18 Aug 2022
 16:29:03 +0000
Message-ID: <9b062b28-e6dd-3af1-da02-1bc511ed6939@intel.com>
Date:   Thu, 18 Aug 2022 09:28:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 0/5] sched, net: NUMA-aware CPU spreading interface
Content-Language: en-US
To:     Valentin Schneider <vschneid@redhat.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Gal Pressman" <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
References: <20220817175812.671843-1-vschneid@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220817175812.671843-1-vschneid@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::48) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62f2fa9d-fc94-4ddf-9927-08da8136c2fd
X-MS-TrafficTypeDiagnostic: PH8PR11MB6832:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QEjt7TMoRGxNz+z4EM+tQIE1+C5mSmt6RWpJNUkrnb5LuRENgmbl/Z2j0DQ09TOGOBQpzG2U2QYo0oFjfm/D2JPjyi1KqrcDklL1eVL//Mrg3MOMWJimoDK+BJL5jgNvleoOeN23SfOcC4utVUI7bTAyvSz+ZDa5nbYEqTpK2IaC6gCmSQpPpvkouj6vPVUoVkBF9MJuj59qX5qOryVdXJjUH4NwtnTS4U1oLm4NFxZ82wM/WUX2WhLQ4R+VJ13fnzy3oRUnGdB1Z0ubftV9V9eNhkqMj8avtKp3ai+8aRY5bktExYmNfeDMwZGhKCYdXi8VqUJO0cGhw6UXCWEHqYJPT5aTwjA79eNBp2cU19KHIVK8zErj6pm8OR6tJc0yd9XzLLKRNdzaces9rkdILyA9ANQNzDIdY4z5PNz7VlrH5w6rfSVk2CwVoBD0NF3Mwc+797k7n9xH+pX2/xh+FfyRwci2U75CIJz3c9gQvi/5T+5u0xxSHyHKqaXhyuY9KiPc6CVFQKuj6PHxKLSwNShhD/dDdZ3rTPcNwnm8YLjWl2u+4Wlkt4kAZ0kcwoQE3eJ/JuoQL87fwOfznVVWGA+Tvkwf1Aw5C4bN1fwHpUx6BjYXNGjRJf2LGs3qCZkES/Fq/mUF3S6pkazNUnOcy9arJ+TUrkQwU/B4uxg2crApFqsSZqlDSHb86MSFXSSHiJnJHrcMi+O0UlIrI9gODqQfVdvaPJQA9ahcnwT3rzsjLoprM2bnQJMSpPYVgEDKJT4C5P9mWqMq33M3CCA2tWRIHyiBYprVMyDhTHDSffo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(366004)(396003)(376002)(6512007)(186003)(26005)(6506007)(86362001)(2616005)(53546011)(38100700002)(31696002)(83380400001)(82960400001)(7416002)(36756003)(5660300002)(478600001)(4744005)(44832011)(2906002)(4326008)(66946007)(6486002)(66556008)(8676002)(8936002)(31686004)(66476007)(6666004)(41300700001)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2ZqL2VtUEtTWEdkaVVaRWxxT0Jlb3oxTVFrbWlzY0hVblVSektCQ3FYUXY5?=
 =?utf-8?B?MjBvQXU5aDBMR0tuZlpsWnpOaWVwSDBIbTN0WVhBM1ljbUYrL0lLZ1puR1FO?=
 =?utf-8?B?cHNFWmdIUjZqZ3B1c1FDYnhleHVOMDMybk9hNHU3VG9xTFpZV3ZqeXNSNW9S?=
 =?utf-8?B?U2t3RUJPaDFMNTBpUi9pNjE2b0traDdTZzFKT0hvSldPYVRwZFJIajdTRmtH?=
 =?utf-8?B?b1NvSk1jKzQrOW01R1ppVm9RUlVKOEZEcnRnMXJRbHFvbnpXS29PMDE5M3NG?=
 =?utf-8?B?cGM4Tm0xbncrS3MvNGlLTGNBdDlUMWo4NlJSQnhxdVBjd2NUenkyekJBMlJh?=
 =?utf-8?B?VDFEQzR3UHZIVWNOZ0pyUFIvUDMxZCtVYXBmbzd0UHluSTIvWGpVcUpYa0p4?=
 =?utf-8?B?d3U5VWVDSU5QTkx1bWpnT3VDdkFRb3Y5RGJyemt6dVcxY3VLM1h2Y2JMM3Qy?=
 =?utf-8?B?WWZZYXlnRUExS1NrN3RmMERtTkVkOGFIWERHdmszZTBYMUdTQlpMYkl1Tmd4?=
 =?utf-8?B?eDg5MHl5S2xCaTZzT3ZQUEZqMEdXd24vbUVhVWlITzBOYlFvRVlXMEphRWVi?=
 =?utf-8?B?RDY4aFUrZlA0Mkp4K2JFaWt5VDNBZncrWVhZY2h2Q0RDT3ZNYXpWRTNyZzB3?=
 =?utf-8?B?UXlZU3U3bXNpTE5SYStVSUY3NDh2citncjg2d2FyeDlhSFcyZGJQbFlFZUtw?=
 =?utf-8?B?elU2T2lqOXQvekFVcDRLY05OcDJEZnJJMXZNWnMvckMwTDNiTWxOYmM1R1pj?=
 =?utf-8?B?VnM0djJ0RGdZM1NzWEV2NXZjR0xON1NVT1dEaEJPWUVSWXk3dVFmTFludzJH?=
 =?utf-8?B?TTJxRjV0OFFFT1p6dC8vcnkrL09OQVJiSStSdEtLN1dkVTZ3MHpzTmV1ZGRU?=
 =?utf-8?B?R1VoRDZuUXJjaXVrdStJc2lQZ1d0WlF2UEtUUXRJWFlWN1J1RnIwTXdLVGJP?=
 =?utf-8?B?bWFuUElGemoxNjl6ZDRuREphQmx6eXc5UnczN0doNjR4VG04T001RVBSNGJw?=
 =?utf-8?B?TEREalN0cnhCYVlKaVVTYkpSVXVUU2ZaWWlBcXFmVzY2LzF6VzBoTmlCY1Fz?=
 =?utf-8?B?Nmk3bkFheTdPZFpnYXBCOUdGY0JyUWJ5cVNWaTROZHhlYm91aVZQbDFpdjdx?=
 =?utf-8?B?VUhybWIzd0oyNm5YZmJMM00ycjZWNXZqT3lwMEtURW5vQ0ZtZHo0Z2syNHFS?=
 =?utf-8?B?aE8zaEhxWGZOR2orcVRUck5jb29lcThaT002YXJqQzNrdzA0V3hyaktJbnhK?=
 =?utf-8?B?a3NyL0N1bTZWV3JNK0JUTFlIS2FZR3p2c0tCR0RRQmRPaEVobDhEQlp3b2tK?=
 =?utf-8?B?UE1mTDJhRVNKclQ1clQxeURDMk8rWXFEZzZiZDlzSEpjQllSalgrS1E2czhT?=
 =?utf-8?B?YlJKTlhzdUdGN0hXYisvckQwNHBWLzdueHJGSDNOMHJRYlplZlI1TWdrZDZE?=
 =?utf-8?B?OWlSK2RiLzdBSFZNOTdSOWFidDJzRXB5NXhVZkpNMlk0S3NkSERZT1FKKytP?=
 =?utf-8?B?YzZ1MUc4S2piNG1TREI1QnVGMUpZYnZBNWk4blJ5VFpUSWxZaEU3NXZVRlJV?=
 =?utf-8?B?WEE3Um0vVnFEaVFiTDZSZFZ1RXg3ZzljQ3ljWWlWbDJRVWVFUzJGc1BHR01Z?=
 =?utf-8?B?Nk1kZVRNN3VpcWQwaXBqTjdRMG9tQUN0enRSUkR4cjlzVU12b0ZiMUNKaGkv?=
 =?utf-8?B?eEJ3Y1RaVG0wM1pXSkxFK2t1UkxEMUVTZStSdVBKYzVsMG0xZ3Z6NDYzVkIx?=
 =?utf-8?B?WDUvdC9DS0dUbWZuNHlpL0tEdjRWRTUzMHh3cGduWkd3c2d1QXZSb1VnQnZn?=
 =?utf-8?B?RkRGWUk0RERNc1hIMFowdEFFVEV0Y2tsM0JmbzRjTUQzU2RQOXkvQzU5VXYw?=
 =?utf-8?B?WjlFbDNWVkg3ekp2aWUwNm9uL1M5b3NXSUcrSWFnS3RGZzcxc1JjQW5jK1BR?=
 =?utf-8?B?UG8wU2svNmJFV3AxcHBJWFF0SWVvVHk0dzI1cyt1RkMvR1UyR200NCtnaHZL?=
 =?utf-8?B?RkFwZmFXaTYweVZRZmNtUHQzRVBDK3VBQ0lmT2lXMURIVU42QjFJa1FmRlc5?=
 =?utf-8?B?aUpjVXpaYy83aEhZaWtteVV4Zm5OdUtzbU1CWWhpZDBqdTJYZktmRzZpeEVw?=
 =?utf-8?B?MEkvcjJ4ekdrQisyTlBjb21JaHZFanJ4SEdzMVk2K2NVOUxKN3dPdUlBNXV4?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f2fa9d-fc94-4ddf-9927-08da8136c2fd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:29:03.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSLrAPkmA/7IEUOgEtfdFMuuF/zRjdzO288mBuQ+nIl874LTyNO200MmvoAvTyUu1qqTrvvn7za2qwRKASeSiy9NMIydVSOxYBHKayR32Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6832
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/2022 10:58 AM, Valentin Schneider wrote:
> Hi folks,
> 
> Tariq pointed out in [1] that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness (cpumask_local_spread() doesn't quite cut
> it).
> 
> The proposed interface involved an array of CPUs and a temporary cpumask, and
> being my difficult self what I'm proposing here is an interface that doesn't
> require any temporary storage other than some stack variables (at the cost of
> one wild macro).
> 
> Patch 5/5 is just there to showcase how the thing would be used. If this doesn't
> get hated on, I'll let Tariq pick this up and push it with his networking driver
> changes (with actual changelogs).

I am interested in this work, but it seems that at least on lore and in 
my inbox, patch 3,4,5 didn't show up.


