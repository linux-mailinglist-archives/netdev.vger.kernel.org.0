Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81967850A
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjAWSge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjAWSgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:36:31 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3184C1164F
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:36:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGVAgzzNEb0KxXzDl1JlYQ9XLjaBqzAbAY/Xvh8Zq8ncev9g8uyX6J0zbexAwhHQjY0RsiKv49EAf31X0OMnsD/I4Rmki+xZNYkui1ZPIAIRuV6qEU04Hv1EBKWPvAC6JtmhiK9oXfMuN0G1yrWU790Vw6yI3XCZPu/MrCSF2CGzcy4fFP+n0eQgkWMXUYwHGv80nG6v1GcmDnY+WYMK0qRhxwPmAITbAez8cq6BCNLRtRX7IK9plb71/SAT3TB5FWVDihK6zQ8CPzLDu8zejUkt6EGE7AJgslRBKoH5dnbcx+ZXIj494VzTDFOnwRZnpm5Jo3vPpBXl8h7sbIrbAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VP8qlJMGLk/RmVAluK7Gq2OY49rEpNW0qDB+yn/EU/0=;
 b=ItgLnWKWvJXmnya+RsoTpAUhs/7HGsxf7X7KgRqcBrt9T7PoyCJhzcVKROF0mZ8NzmrO5YRTqDlTWlRVXypH+wO8h4oA8Q+QmcHhWpM2IB1Xj4OjL0xYsS3ZX4/0gyLXNBDvSd6NS7yhg9nPrdtwV8QokSFoKytUzfY/jZ97DFtWX9zUh5bLILcAvV9N1OKqTIakvR+nHl8Vl0yNOdAt1DBqdI+L8dgEJMKxpuB9hOQoit0AGAejbqTHYPL1mOJqisZNN1rCMrYcE5kw2yIgaXRW21JqWB96ba8Lt4v398sbhjRnPgVwZmRq9Tg51o4RFgXlJSVH1EPSOJz1EN5tHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP8qlJMGLk/RmVAluK7Gq2OY49rEpNW0qDB+yn/EU/0=;
 b=cqNehYLUVp5Wls+8FlKn9dPAFpfhTULX0Z62LgwQ7n3fyvNEPS8vZTBFP5Xu4jAYC9ZK9EA8GbWZHKaAXzUiN2p1zBEMX0Ki68m/40/oJvDbbF6ucXNojWL1eOzUiLxPTkuZ7JAeuqYkskBnktcwvTYmIamnBNjwWjs4OiBSeEX/qeStGpFeA2Q56099i3YPsn2deE5TVr3hriBfpUsU9wVxLJRejDRVs/urglQuWhZC2YwHM7XjJk0rDubs8iXcyADYYjB+Pvth3qJj/2B9CbEdnT1TwJoYcVj0pXT4uRFAcn22Ww5zbwD3W/jkGnY1RvIoZCT0gTP3Sr1aLfr1OA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 18:36:26 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:36:26 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v9 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
In-Reply-To: <20230119184147.161a8ff4@kernel.org>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
 <20230117153535.1945554-4-aaptel@nvidia.com>
 <20230119184147.161a8ff4@kernel.org>
Date:   Mon, 23 Jan 2023 20:36:21 +0200
Message-ID: <253o7qprtcq.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0043.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::31) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c1b5f4-e7b1-4150-f20f-08dafd70bc59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ohIJujbMZVgPpco5s+ceqCx88E5T4ykinqZ6KvYVk62SNtNjixpFjDkXtJd4yddGad7mhilVUbJ3yxvGTcg6Sbh+RJeWZT2NfFdByjXn4qXDFGCamRGymWXeTViMwv2tu0+NnGozvLZ3Fr4N5Wq76KS4xCz9tXYdn64dzrRECch6LSy9p+3ij4b4sdDTDhX3pl6HtfBQgDrTermGq8FA40rq5v6pgtnUOKyb/pib3IJWvaxvOEAvJwo0pX5Jquuf0P86NTxuJFbK5udLUmXM9fwAjeLUFBYAEHl3DnNCJUhZ5M/O4UYaYgEz4Xz9SFxko/82oDF7EbNh7fXAsg5J3+G+9iHk/sVKcIwNkApgWSXtNWJS3BWzyu9Xa7jLq8bWjoi4M0MfEOt3YahAcSP6L8UdzpNxRiutp0Pd9iuNBTyi5EaDTymTCeHzfCzviT1j4HDH1qXy2t2FpPJxPSZ+Dy1O/D7FOgvtmLhn1Mzg3+4ycgzvubsNrtlcGRvG/YADibc3URv5TNsdXByZKEwb9d6C4c4wNIWg1z9Glvj7iug17XS1Jqcwp10rJhnhErBRmULtD21nTGDaOtyb3M/vnGwpWPEYuZbeff5nQHs7Y50n9CMeMtY6Q+2SJd6HVUeP3Sx0XgHb72YQUFpmPMzZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199015)(83380400001)(66556008)(86362001)(66946007)(66476007)(6916009)(8676002)(4326008)(316002)(6506007)(107886003)(6666004)(9686003)(26005)(186003)(6512007)(6486002)(478600001)(8936002)(7416002)(5660300002)(2906002)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4pfXwYkVWh/l0Z49mI55QDo1BGBbREsm5cQbWmFrRknx0kZQceoTn/LV+Hq4?=
 =?us-ascii?Q?eIV7MpOTNtFcGIbWyjYUaIp4rq1ZzGW3GhNf0Y7OMMECmdE9a33pt2bETEx5?=
 =?us-ascii?Q?oWxv2TtA++L5bi4/uzyaYKI64a+utAalOADnQwa94Ma2e9s8/XDlzO5RbRzO?=
 =?us-ascii?Q?6L2XoZQiXweE6KJBOVLLbd2Uwv6plGjSP2XaOjtcpNlu5bFrhPqXEOTzgabQ?=
 =?us-ascii?Q?w/Xyxn9fzaRVf3SNCHS+ZE+l9H1Mj6+0AaFuTt3t2TrEmZuDptqNrHE17TJK?=
 =?us-ascii?Q?6hCzNcQUHTkd+aLbhRaRKK+x1FS8oSt2bxDPEIh8W9Ku393kB5Dfbeq4ObC9?=
 =?us-ascii?Q?oKTdVa1r6nCXFlvbzxNhHF0QmyR1SuaN893nSegJSSMvjxXdqx8zQZ0anCU0?=
 =?us-ascii?Q?CAeratDV23cUsJzxijyDNsnhOJ1LBC5kGUdhDcG+pQzVl56TNA02ceLTJGFx?=
 =?us-ascii?Q?RM9KJg8X+FgVyrItb4kqMd45Z6arpSKrl8vnfJKySoKalLk7wws6VwCuKmNj?=
 =?us-ascii?Q?YhLd9QbnisFmRst8g4KAtPUQ6FD/+ni+6CRpunKS+tBqXh/yM5UukqR5+7r/?=
 =?us-ascii?Q?FR9IY5r9XTGjuy6CCzoBsNkJrvtvrHkjbr5hTdWtfnXEDg9A73aUIhD9goLq?=
 =?us-ascii?Q?7BNKhIiyMwbcKTGnL0opdTCDwnIesivROTlkOQzLSPd+5mbVBVpB/IMPWIyx?=
 =?us-ascii?Q?muezfoX2Vjk+sCsLt04uUDr+HUaQlnRrNY7pEB6nrPxJd+2YoqUMzHMatPAK?=
 =?us-ascii?Q?WueBem28KjBCn8c2ei2vYmdHHvJA1fa5lkdu5MGzKFFs8kG2ii64fl6YSPTf?=
 =?us-ascii?Q?eQrOCMnaz3xsKwgaeBbsZzd2+6U7Hok/miYzpHIKxn7/lYxGwzpSHcuQKy9p?=
 =?us-ascii?Q?eOdtFvk52TrzmFsv6EhsCt+tPHItsbM+bQryTcfS+124uLJWq8iY4oDsCiCz?=
 =?us-ascii?Q?67k4fHERC+udcm+VBNqxvsTaBbCOW0dnMrg7ymW7FTh4V18ktPp5a62ULS7C?=
 =?us-ascii?Q?JIFYNmZcqXlDGjx4P2w7xHGnLk25H17VIHz5wvxony7r9Q5qeh/sqwazvdmW?=
 =?us-ascii?Q?zelMLjLLe6i+I8QwWsYkICv19lhpaef5p9lVc4GoFwd56LnHe22fZN7uAVTW?=
 =?us-ascii?Q?x1izSWBk07J58/oayd/7gY03Mu0TrSWXfGhcErx3e15MwUF0oGgPFopAFfTT?=
 =?us-ascii?Q?T0uLfTgxCKwZZFLi8Kauhudc9afp7avm9ZqDqJWz7WUf7JtoUCVuNMeWnLNq?=
 =?us-ascii?Q?iLf5msgseBV2icMSsWQGXU/0oAOqZ3weqmq69OlgO0EWAYFMITKSLxFflQj7?=
 =?us-ascii?Q?i/771Da0iE5y28zM71YQ+3+bQETxlzOcK3u7+H4WzyUsIBTzlzUpSzZNMczx?=
 =?us-ascii?Q?RBoD5r+JQNdNRpeWGmXk4VGjuKRpMBX7hPtz68UFVnEp0qJ8+SYRpELBZjXy?=
 =?us-ascii?Q?eFIRXQA6X8++ZKKo14PRrZAsYtJakHwkiBvGQVZcwC1muO1+NK9L4vmSiQoy?=
 =?us-ascii?Q?3nCLgFCNebw7OEMfK6Tzy2E5dL4QSKwh+UkEp6w2ujrPdRc0SDXMdDMrOsDI?=
 =?us-ascii?Q?jbdfyCW8g4n78X13wi1yWrZ2N9ug18SnpEpG+f0g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c1b5f4-e7b1-4150-f20f-08dafd70bc59
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:36:26.6240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5DWg2ntwDTghpdliOtXpoIqmnPi00a5KZTayGGcquqkIoJip3Fc4RO5cmriAE2iugXmXmsekDUH2dNU6sQtH4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6075
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
>> If a ULP_DDP_GET message has requested statistics via the
>> ETHTOOL_FLAG_STATS header flag, then per-device statistics are
>
> s/per-device// ?

Will be fixed.

>> Compact statistics are nested as follows:
>>
>>     STATS (nest)
>>         COUNT (u32)
>>         COMPACT_VALUES (array of u64)
>
> That's not how other per-cmd stats work, why are you inventing
> new ways..

As we commented in patch 2, dynamic strings are used for ethtool
forward-compability (being able to list future stats, which we are
planning) without updating or recompiling.

>> +     int     (*get_ulp_ddp_stats)(struct net_device *dev, struct ethtool_ulp_ddp_stats *stats);
>> +     int     (*set_ulp_ddp_capabilities)(struct net_device *dev, unsigned long *bits);
>
> Why are these two callbacks not in struct ulp_ddp_dev_ops?

We were trying to implement these callbacks in alignment with the
existing ethtool commands, for this reason we implemented it in the
ethtool API.

> Why does the ethtool API not expose limits?

Originally, and before we started adding the netlink interface, we were
not planning to include the ability to modify the limits as part of this
series.  We do agree that it now makes sense, but we will add, some
limits reflect hardware limitations while other could be tweaked by
users.  Those limits will be per-device and per-protocol. We will
suggest how to design it.

Thanks
