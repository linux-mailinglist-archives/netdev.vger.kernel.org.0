Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FCF6BACDA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjCOJ7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjCOJ7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:59:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962FC7DFA8;
        Wed, 15 Mar 2023 02:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678874269; x=1710410269;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ZxxDuRGhb4JpUdf9JvXWRV+OT/dhnqUTDHzrR15YeE=;
  b=NvKRssUVCchDncQaf2PA6Ja/jVHAAXwTsO+US6MRlmhWo5GWOAiuc9aJ
   oM1bTBbIa6gA66CzGe78aIqgDo7cC6PsVMQdtIwQrcR98VR4W2qMdpcMN
   uMnyNUzdwIoc+/gWu3VsnQyZg8LlUFxfOMrkCJ7BpKPs4hnfcV14H8wAr
   BQwC9agAbfI1mokC78P8QEpqJLYPtmDEP+UqL8ZOGQVrUmIKmBHyqLIKu
   +a/tuA7iSlnXdMABCWUnPD5S4TXI1JRRtXI/mxMRaIM0dhOV1hCMf+h/v
   KSzOKZoagOJDYdJ8KZrKms+i1X9/Nljp+LxeeHFghwy9lCL4mFc6VdnIt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="321501991"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="321501991"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 02:57:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="656699103"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="656699103"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 15 Mar 2023 02:57:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:57:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:57:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 02:57:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nxgu9pURWrpDaDkQ/KAqK7EXG2QbGiDDHwJbpNn4dguXFBUIchdAuYU+LX7k/Hr7x0Tk+JJJ/4Z4WlST9fhfUgzBNiN0oOPd8EKOnqkU4r2n+GrjF2nT0mia87eD6VmtCWrnD+4OFh4cqoXbeGPJje6ks5v1cd7cFXfEiUxo2QTUj2XKceeu9mqDo8xdfLLhCpZO0jXqM/P72WvU5x2WmoiybpDpLN1QKqZzt6TTNsPyLPhJOBbj67qIxo0esMwm62J1kc0meTbG2KhvoFgvNcRgiZGLL6/5waR/OQ7u20a1Mkgm8xiO9GJyq+2tgMUp04B9lOIMBqqc4V+3aiAkdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asIAAdfVySTjbMUFrHG15dIx/Rbso6O9FD4+sSAmIwk=;
 b=UoFGx6NjZvUpN4u6ypl8Yf+CSX9JJNVPvCbbPmTPoXyzEf5P8gCAAmthSWGyLP6nPxP1N8iOC8wvbQO7Nnki3OFweCF88HZ8fglebQXVevyHBi/Y9hjdZjeEh4AW327G4P1U+G3gsaZauLgmJAS3Ej83mI0vmZfTPIGdgnIM3+bbguIrVROIiL98OxY27tS3LERMeeIEWFUwuRIZ4ssXBCbxxXXjm/6Wch+LgXe84uBQ19cWzjuz75Qu9re/5VecJDpcGfpEuZQPAJV0Pfo78FcC1UKjzyvv0g62kwx0W0YACa9SXVL+WGtsPHtC5umieo7U0yYUT322M8SmR35ENg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ2PR11MB7618.namprd11.prod.outlook.com (2603:10b6:a03:4cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 09:57:40 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 09:57:40 +0000
Message-ID: <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
Date:   Wed, 15 Mar 2023 10:56:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        "Mykola Lysenko" <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ilya Leoshkevich" <iii@linux.ibm.com>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
 <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
 <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0207.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ2PR11MB7618:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2cf7e1-0164-42c5-2881-08db253bb6cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EYK2EBDa3E4ItsBrUDOrO43mNsPjqXqIWK9qTGpGTaO9fQqdbQMD8BE5mbOR2JYiJeyhUAGWIHzBxyHYax87v22Ahg+sq/RIGyj5zmJErlTAqY/bNn3G6P5MMzXKxPlEhQ7M0FLCuO36WZsDbSfkvXvkPVIpWVOzgObfQ8qht0rX/Mj3j8JWyxebBVuT8y4QpadJ38ryDACGjkNFEfE9BbHm8gXLfbgAwQ+D9ViqcdSadqUzvZCjZCy0BMSNua9pEXemaj+KZKMNoE7b13iI4SH6vrkRSjuUW1JYoBLhtjlr4awGgGvfxnAnQ0giKdbEuqwZbJaBzN7d0ZqHqm7ue4VdJd0IPVoBdBlw5hnhoKpOlpAI+NKe+UjbbgmJzTjWoyXBMJ0T0i7Wyc3JwzYuZtbVsqdMIG6lob5v31fm6V161iY5kXCxLcQGLKdKh6nqC17ChXeoY8GxJg98MI3YaRyTvNtShLvCknCSX4S/UmQOQzzCOro+I/RxgUwooHXNKMqEDZhAdUAU7c3WR6n13YCwfIBgFSG3kQ6NR9PNUx63FsRIq+Mq5ZBY7MBfpfoEUtej6FSn6HqNpKxF0iAbznlfbLcC1wFlCKkAhSidCd16dv36ihnPgggsu2AFnpriLqXtS4pWZrRCTCjGImtPo2JJIDVrkVpGMc3o1FKR4J1/Nv0Yi+GSO0ykdRM3OtF7IyyO/wrNHvWiaHg0EBn4a9WLKXN4q3nbWAJ+/XvzJ2g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199018)(31686004)(41300700001)(66946007)(54906003)(8936002)(8676002)(478600001)(4326008)(66476007)(66556008)(6916009)(31696002)(86362001)(38100700002)(36756003)(316002)(82960400001)(26005)(53546011)(6506007)(6512007)(6486002)(6666004)(186003)(7416002)(4744005)(2906002)(83380400001)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFZ3WTNGOWF0N1dHc25yNEMvM2JnODVVVEszNUtST1VtR3JKVWZvR1ZWeERL?=
 =?utf-8?B?QWRnNHN6MWtUZ0R4QVF6RjRmVGRINkRuOE1zb3pwMHNCMHl6cUdRd1k4Ukln?=
 =?utf-8?B?d3dnRTJTNFRIdzd6VjNjUkFuUGI4YUtoVnFJSFJhYzNYVHVnOEJ5NldEa05F?=
 =?utf-8?B?czBreXZMVDhmdDVhTHN6RFlqczhKTGNzK2NBKzlMN2M2bCtnQXVPVDkxQm1Q?=
 =?utf-8?B?bk9ka0phWUhiSWxQNEhodVo0OWNjaGplMWlBZDh6ZEFrWUlzMUpleVRqNEtO?=
 =?utf-8?B?NERCM0JHcWF3UGd1QzdWOW4vdXZFdDJuTDU5LzIzL2w5ZUJ0NVUvSGRGR05l?=
 =?utf-8?B?R0IyK3hYL05xZkQwOFE2V24xL3lEZVovR29qbXAwUElpTVRCMnJQSXRXTzZq?=
 =?utf-8?B?ZWJpQkdpUkM0M0I2QXgydDhabjdWd2FYQ0w2ZEgrNHRWTkJhK1RRb0o0eXh4?=
 =?utf-8?B?VStBaUhPK2JpMlFtRGFKWUlkbGVDM1JGZ2o5WGN1YkdtTFhpK0tEWVhzUzNY?=
 =?utf-8?B?dm9aMVRxcjkyNDJpb0FZbzJaWnluZ1EyY1M5d1h6SkU0N2FhV1hIK3pKRHVu?=
 =?utf-8?B?UGJ2Ly9sYmhhc2p6UG10WmxGUUFQWVJmVFV3dSt1UC9Jc01ickdYZ2lrQm03?=
 =?utf-8?B?c2lINm9YU2U4QUlsbzRPbWtsUWU5OXZwV1hLYzRWRDZlcEthUiswOUs4L09S?=
 =?utf-8?B?M1ZoZ21CSFpLNTR1enZxcWM5Q2hEM3ZwMmpyYkNobkgxRGNZYUtzd0JiUEpB?=
 =?utf-8?B?emVDWWZueXlGN3NZTkUyN29mZG5IRUtrT0NsT3ozbFF1Qk9XSjF4RUpXVjgw?=
 =?utf-8?B?d2xmL3lJZ2NiR0xjc2RkVi9zYnlNbjFLOUQvMFlGSkZEc1NKZkNlS2llcXVv?=
 =?utf-8?B?WlRub2pKdkZ6RjJkOG1RT0FOdlJPMlVDMHV4bGIwc2F2UGFocUg5YkxRU0NT?=
 =?utf-8?B?eGorTU5GUHB2MitIRVRoMzkyS1FiZlF3c2tLSCtvTlZTMzZnSWtPSHRhckQy?=
 =?utf-8?B?SGsvMXhrS1prSGMyY051UEZPbHA1VEFSZm9DcEVjVkxkbGhzZkV1QVhuWnlJ?=
 =?utf-8?B?enhxS3FjclpoZzBIeW85SkZGcGdDZGZlUEpYWDV1RWVjOEVncXR2cXo3Rkpp?=
 =?utf-8?B?S1Robzl0SlNzNzFUZGl0NS82TlBhTjY4TDgvNXp4RmtlRmQ4bXZKS0ZvVFFO?=
 =?utf-8?B?dTJzNjFLaFZLWXNCMWxJQzdzK2VUR2c0bC9uWWc4UzVVWjM5Y1pqOHBMb1hW?=
 =?utf-8?B?dVkvOVU1ODMrUHJ3SzlBcnhQU2FYOUh6eHlVQVpxd213NnRyakZzV1M0VTNJ?=
 =?utf-8?B?eGg1WkxEK3RPekY3dlh2aU9GU2c3eG1mNEQrWnNkMURINWJxWVo5cXNiQXhr?=
 =?utf-8?B?UUVVcDZQQitRK1JOT2dXcE5rMDBqNmZDUVpJZnZuQytXdDlwYW9mNHdqUjha?=
 =?utf-8?B?ZWhZdDE2d1ZMaXZrWUF4OFdxTE1TZWxuWmtjVlU1N1NQUW9MR0RGWVJQTUdH?=
 =?utf-8?B?T1JLRFQ4VkhvNVgzMnVJSjQyZGVwRzI1TEE5ZGtweEpORkUwOWRETFBXeUk4?=
 =?utf-8?B?WTF2Z0I1WGZudjJMK3REcXdZWkZOMEFPSVhXS3poVU5YamtrK09yVjlTR2py?=
 =?utf-8?B?bFV0T2R5eE9HMFhGdXF4YnJSMFVtTm4vQytSOWtndzFHUjA2MDFrMmFSaTQy?=
 =?utf-8?B?MFBxZGUyVmJLV1NMVjFmWjVTUk92aVZ3M1JQK2VkZS9EVkE0QnNLVmk5ZFo2?=
 =?utf-8?B?eXI0eUVTQ2N3WmxpWGR0NmNoZzgzT2cyd1lzcThWMVpZbnJpQ0VJdXRNNjAr?=
 =?utf-8?B?ZkZvV3dWVERoZWFlUVFNQlcvbThYeDBmYXp4VnlzaFFmcE5peEJWS3cxd2Jm?=
 =?utf-8?B?bzdLZmVXUytSQkE5ODlpTUVRZFpWTk85M2NnWml4dXJJRTZoWWJteDFvSUFQ?=
 =?utf-8?B?ZVphQnV5OUxDekdST0ZXNGNhb0ZxS0tkcGNOYjArUENXTnU0bTd1YVB5SGpW?=
 =?utf-8?B?clpaMHF1UGlWbGExOWg5U0dqOUhJQiszakliVUZSaDZTTWZkUHhmeHltT0Zj?=
 =?utf-8?B?U3VmQmg4MHgyb3ZyUGtqMDBvRUlac0M3WDY4WkQ3SDYyS0pvdWhGY3I1NTVZ?=
 =?utf-8?B?dzVQcW55S1Bkam00WmlqRkIyNVJFdm03TC9lVzlxQ0dTaXA5UjF3UHlLL1hH?=
 =?utf-8?Q?UvzuCPuKJam7BCCJroEhNKo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2cf7e1-0164-42c5-2881-08db253bb6cf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 09:57:40.6197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QArTjp0xVKvrg2jEngcDH4d9ppe398BHQr6arJPRNMXLv2hQjrJFf63Hg+X9yazlY6PGFltuiqdjh07btYJ6iIwYs32erPM4EXpfSUeNQlM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Mar 2023 16:54:25 -0700

> On Tue, Mar 14, 2023 at 11:52 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:

[...]

> test_xdp_do_redirect:PASS:prog_run 0 nsec
> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc: actual
> 220 != expected 9998
> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
> close_netns:PASS:setns 0 nsec
> #289 xdp_do_redirect:FAIL
> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
> 
> Alex,
> could you please take a look at why it's happening?
> 
> I suspect it's an endianness issue in:
>         if (*metadata != 0x42)
>                 return XDP_ABORTED;
> but your patch didn't change that,
> so I'm not sure why it worked before.

Sure, lemme fix it real quick.

Thanks,
Olek
