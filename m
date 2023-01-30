Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADAD680C2C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbjA3Lnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235845AbjA3Lnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:43:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31A82CC6F;
        Mon, 30 Jan 2023 03:43:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2h9Z26qMuynlKsM6VHkyoY4hfs1dVuWCqsKWRs5nHLvst1Uf5C70fgjlKjzXOrmX8aGuSla3u2Xo1pB2Um3XGszmd27siNqOFGjruOoj1OkN7M6CzGY8xTV0RNgWxi/qKVnyA9nmnpPgI0IUjhuejXfbR0JgS6n4S7mqlQJYpIszpVbzJV/9atfGGyngsPrvzJz+PWZm4Zwzh4fBP3OtVJvlxQn2qQAvZE586ToNWJPdFR9u7OW0QnQJuUJa0cOrl1QHsstduAXDIWin0GbbVrzA3p/s2IliW5+OxXrtqByzIZRir2Fqp+gqtcWfTw+WaQlZaWWdtIUsPI0PlAocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAEhd6lFjlqhsDdSkhLZD2XuXICiUrmsfT/om6jGR28=;
 b=idqeP40/2oEXsUGO18Typ5iDbXZ0ioYsqJjeVyLHgNcnEUF3TPfZmXWfklNJqBN1Id67q/dTGBxR5M4xYLkWAgXQDHHMeq0hmjOGXa7uvi0enGHl7oYnJXDQcfJljWVpI6iyiHJhjlxudZjHPrsAfHuniA8jlJl4Ws9O0/GjnKLWVt9VFT7VjdlnAmZus+KfjwTI7o+8fZQEITAkj96hvCkWHaDqJixbb5cpLe/py27VuLYT2YqJ8dNTjz31V4ropQw6S6+PpqZLTj77ZEvmNaDUyvmDaqOCLNk9QqA1e9gJCw06gYFBzH2TUnJnj0NS384Zp9ZC+2JJT8KiEcQ3/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAEhd6lFjlqhsDdSkhLZD2XuXICiUrmsfT/om6jGR28=;
 b=NhcaMtDdSc7GvoNYC6GXRJW8dIm46N744ndgUWEZuurJdki0rxPvhs6nqT46KdJbDWUU4Y2QhBroK1B3HtGCSvnWFxLlUhCz/6AsJhbVAQYPzZ4u9wzD2m+wruAEb9o7SmBMKZftAelHaq7xi1nIQCD1jn8ZDsItLppDLNryI+c4WV61kuu87Eq/VicY52JQrgZXmzvrit/xgfO33PdK9yPoDZlFoCoWv2WWlezMj4a4k/LNTxjw9u5/YQwQDbsMDao84SqOY1qVsl/GoRlz94oTGGYyheDS8dKOKDtwtYb0amgJKikfB2+tv3PiIdIihdOKw7Q2lo/N2AaiAYtXkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 11:43:48 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6043.023; Mon, 30 Jan 2023
 11:43:48 +0000
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
 <Y8/r91PGGiY5JJvE@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, linuxppc-dev@lists.ozlabs.org,
        linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Date:   Mon, 30 Jan 2023 22:36:43 +1100
In-reply-to: <Y8/r91PGGiY5JJvE@nvidia.com>
Message-ID: <87h6w8z1qr.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0018.ausprd01.prod.outlook.com
 (2603:10c6:10:1f9::9) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: 63676471-5db8-44d1-d5dc-08db02b7400f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uITFThuSePSYf6UfX9hAnQ5ABtfQ9djgBVpBv1CwVbfHxYJNopZ/PA5wtDtuzYSyi51+j8EdFA3q/o5NNh0uvRqaoA6andeyiEMhwgCgRPmJMFjyNRCpQpSpA7Y5ajaKnkJgHW706Hkz9UfQYMIqzplYXbWIZBcPpW59hqJgvIbdbArSKziv6d3P1lbIaOsUIJGR6jl76yUb1NwZxjucINfDaH/lpfXJj7QDG18jcAuGxOaQ/bDsPGr5wuHY1hHJ+ruC6zq7h3WB369yhETBKh8QgvXPEU9SEJVKjkx4K07c3Up143QsRKr0G98grU5gIJP9brKawooyJILWLR6gZ+kanw+ugrz7pAo2+VRvbuWL74mjOWxB2yOTQCIZepOfo3l/6+q31SgQBDD8erVC0GKpxw8J0MM4ajlaBOaHED3f4W7kTJZmt5Ag+8PnyJq8aZgHhNH56ls2intNK6Nilvm8fi4aR4tuzoX3yowahj0rncl2M7h9kMeSdx72yyefq3kPwKLZGy3NLi8djcnUSMfSvDX1f00MmKizs1k7/QZx6VVYu8p79VULzbo/fLHPEM/kUiwMqbuiLHfa8/rjskLXDck3/KW7uBT/Nj5R/0JjTcXD5IKaCWtmr/3sziKas4DbWj/1a9lYfzHXu/FL3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199018)(38100700002)(86362001)(36756003)(2906002)(41300700001)(6666004)(7416002)(478600001)(37006003)(6486002)(186003)(8936002)(5660300002)(66946007)(4326008)(316002)(66476007)(66556008)(83380400001)(8676002)(26005)(6512007)(6636002)(6506007)(6862004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CrK9itskcDj4GP0CRorgythrPzWZHEJkTrp2yYI7P8Dwv7okOe4mmeIyC/1N?=
 =?us-ascii?Q?7JqHzYzMKQPdxwZV6r8xSyhhPb5Y+BGyuxAPapvQalUO2+MSfSN3StRrLRFl?=
 =?us-ascii?Q?AT2VSQA1bGUy57lbLsPWObCYAMyLVqYvCQUx7/7bVvOaUY36YqCNSE8C66Z4?=
 =?us-ascii?Q?iUpL/uaf6enikRyX7J04UsSBkazsrE6fIIzhIpH3kzl6W3+RqYhn621W/4ip?=
 =?us-ascii?Q?02uWOTJsYmBDUUB1C+2QmVDW4CwB5bcA0ZjH0NWzc8QxzsCuUuyANtySDiEk?=
 =?us-ascii?Q?Vi4oLGoRp9CcAnbu3HV1fYY7VIstNyh6Zui7fNo/1WcN9c31BF1EyOpOICdv?=
 =?us-ascii?Q?hkmPX43sr98uhMMzqWwLTbbjc7/i6gtAVmzextZlUUG/lrnJ2euE7vc/TKRp?=
 =?us-ascii?Q?ZGWrAw4yLj9VnLLI0WECU/PELqCSQij1E9raROFqaoo04UG6pyHwSKIiGA96?=
 =?us-ascii?Q?6WrREcYnJ1HIxqCc+gTYnlEsjBX+5Kmwyf1CbsvRwpjWjUBt8ElpqIVg9VaT?=
 =?us-ascii?Q?N6wBvlsd9ReqypptzdHRJf3raCYjh10WMO0O909AHnP4TgT8ixdbA+Aed1mv?=
 =?us-ascii?Q?3c71HkzRf/eLWmeZzFXkdLDpEAl56NXmS7hSLLUg/4Q3N3lg9WTHv/PO+WHi?=
 =?us-ascii?Q?xXs9gQWO9yuQd/lHTQLuiSODxc5VgCHwFgT3VBi8nQItBkHL1CEZgrn0TLqs?=
 =?us-ascii?Q?32N38Ca3r11gzJfJ/LLrkfLj1JHD3lMw1DIDM86Aymrdy9aqee+soMs5Tx6r?=
 =?us-ascii?Q?dm1wrpd4SqKt0MJXo2IzndpOn4XZLKzyILn+lzvtL2wb05A4JsiwjCG1FmJP?=
 =?us-ascii?Q?0nG7jMPU9AyApTKV8RbPvN8VduIlFzPS/C0e07e50zwjO8nonXWSOf9lbSY9?=
 =?us-ascii?Q?dVbQAkIQZikO1t7LOeOFfnncqrcdYZt3MmGdLw9xAFl7dNSjtnnyBhoBEtkB?=
 =?us-ascii?Q?Fh0TJbl8o1hS5jC1jg+IUaFZnP80dktvNH88oE0/AqhEn9pw2V5Y/YTxoZVc?=
 =?us-ascii?Q?EfFIhrPwX/cRg/zTI6p6WjoFjKF7sf9bx5fWyxVcJUPwSvgPeY6eOaToyoz8?=
 =?us-ascii?Q?Q9g0zBTxDf1xJ4G0JzNHMnqgyv9GYCeKkvSf3058iH+CibEHoHCKhCIJ455v?=
 =?us-ascii?Q?aSzrIp6nkzqZkVp/5MaFH4Vhac0cBPhqWeEIzZUm6BFD1u5iYOov1wYt1935?=
 =?us-ascii?Q?izLVourlGwdD7f80UkKDqQzhIptqRrzyep4mmcH/fBaPbD9wQ/xKYzFmcCvw?=
 =?us-ascii?Q?+n4kGiV+Xllhpnj4U3Ihzl18GBeopUbpRP5cAX6oaA71DPew96oxMgScpyqx?=
 =?us-ascii?Q?cM49SuFQENyVSXXiNaRCSkLN8E4aN1zBVknBYnDJvRKiHfhGAyjF0fWj8J6M?=
 =?us-ascii?Q?JqqkyLkgrgoZf52FKPoZS/y0StU3I9puaUuKIHUIecfkv8hEGc3Y/Cci7FO1?=
 =?us-ascii?Q?9S9IbhFWef2310CNECiqkVH3CdyiAgg1hXv08ExiG53iqGtnGhyDbUpLvnAW?=
 =?us-ascii?Q?XY7KIC9hx6oKVgleGX2hUYzFSH/kgeydpsxbvvTUuOQ+cgN/JXsCIY9GOWAx?=
 =?us-ascii?Q?txGFhvvxQ6YpkMdtgv9eP2glnZziyi58vY1Jgwlc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63676471-5db8-44d1-d5dc-08db02b7400f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 11:43:48.2451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMWVFjjUx/ulcyPi3NPfUnsdbArWq0SDPB2f54nJbyllgoeyJ4Sr4t8y10Xg901y58rv3rWQjtS1F8223SCh4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jason Gunthorpe <jgg@nvidia.com> writes:

> On Tue, Jan 24, 2023 at 04:42:30PM +1100, Alistair Popple wrote:
>> +/**
>> + * enum vm_account_flags - Determine how pinned/locked memory is accounted.
>> + * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
>> + * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
>> + * @VM_ACCOUNT_USER: Accounnt locked memory to user->locked_vm.
>> + *
>> + * Determines which statistic pinned/locked memory is accounted
>> + * against. All limits will be enforced against RLIMIT_MEMLOCK and the
>> + * pins cgroup if CONFIG_CGROUP_PINS is enabled.
>> + *
>> + * New drivers should use VM_ACCOUNT_TASK. VM_ACCOUNT_USER is used by
>> + * pre-existing drivers to maintain existing accounting against
>> + * user->locked_mm rather than mm->pinned_mm.
>
> I thought the guidance was the opposite of this, it is the newer
> places in the kernel that are using VM_ACCOUNT_USER?

I'd just assumed mm->pinned_vm was preferred because that's what most
drivers use. user->locked_mm does seem more sensible though as at least
it's possible to meaningfully enforce some overall limit. Will switch
the flags/comment around to suggest new users use VM_ACCOUNT_USER.

> I haven't got to the rest of the patches yet, but isn't there also a
> mm->pinned_vm vs mm->locked_vm variation in the current drivers as
> well?
>
>> +void vm_account_init_current(struct vm_account *vm_account)
>> +{
>> +	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
>> +}
>> +EXPORT_SYMBOL_GPL(vm_account_init_current);
>
> This can probably just be a static inline
>
> You might consider putting all this in some new vm_account.h - given
> how rarely it is used? Compile times and all

Works for me.

> Jason

