Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221EE5EEECC
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiI2HU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiI2HUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:20:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD9E21246
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQwq/GK0W0jqN5LClgDHyo1upY+NVNBEaW1FeZwqBZABB6fP9yurotAC0Bh6+E4/Cc7r1ksxAy95DFpxQfLhkNXgRkGokx5NummI2a+aZG0HxuHkgPy+4sepOAoKTWqBmP1dXDuKeOxOLm5FS+/A5XQBTqhbxe9nZ1/Z7argMaTUaYofI6eemoZCW1luXXdGeIxtZLmXzW5vGr5BTSuXbP8fdq1xZbMQPYGY4KIWvRE2+qlFMOZNT94ZZxRZL3Z0xnvPpq4FXQgwTHuq10xr2S3ml+mHvR6aPnctFABkfNeNOPURCsdGwTT5qUE6Oyf+/SgotaSO/R9qSEoRFQoFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ARlHIeObSqysUFjmd8MnzPjtaixFPmLVu8sHuM6oUg=;
 b=OXxQ904iAA1Z9J5FWUjHUYmIJGUxq/YSur9g4pRgV2ie6zjAj+GO8TSWCuMURy7C9hp8t8MfMPst5ukTF9lenscDH7Wq815iWxk2NH2bEzkco0qDnS35edvL7tvifH4ENMGb5A/J8v+N6PEqs/2PzkSZmzMs3cQEuv7SIAgPknlstSwRo0SF0nAueKMtcx22ZDreEeJAbLEOR0ibp8ELxglrJAXMA9EL4RkGgjTz8K07bONpgzKFnt+/w3l6zpUjNEbs2xXBjgBJvYAuXwCjEXxss0b81Q5goSQ55UVx1QizPPQhg0fl65HxjmYJ32OvFk5X7evAJDgm0FbADIlsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ARlHIeObSqysUFjmd8MnzPjtaixFPmLVu8sHuM6oUg=;
 b=TzvG5+MXnQogjCjc64q4wnSqObD0AWYNgJSwYRboe/jkfcdd/OVyAMGYCfaXB3LEFhN8+dW9UPv64eQfPky5nCfpG+EF3HRyn/g8oOW0fnV/vZU4IJ70MtVH6g8k5pt5ezzqm4cjHjd3naFc/unsMUSiUvy/iwihV7CXq/kxYjR8NLHyFoxpX8v7+1mU245jUMcBGnzh75tjFVSFOu3VlLQlL8h1Kvn13e6dEkC416WheCTAmtuP6ZyNKj8I88PKWKTOWRXif7MwRK053soCeUka5WHQoAmwXgs7ma08LENfhEN3BxZHv86mkXL0KEs1cxBPAHIHX3lYtedzMEMDHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CH2PR12MB4971.namprd12.prod.outlook.com (2603:10b6:610:6b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 07:20:44 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::70d0:8b83:7d82:b123]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::70d0:8b83:7d82:b123%3]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 07:20:44 +0000
Date:   Thu, 29 Sep 2022 00:20:43 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net-next 00/16] mlx5 updates 2022-09-27
Message-ID: <20220929072043.etp5f7bcne2q5pf6@dhcp-10-2-57-92.baseline-sap.scl-ca.nvidia.com>
References: <20220927203611.244301-1-saeed@kernel.org>
 <20220928193540.29445d20@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220928193540.29445d20@kernel.org>
X-ClientProxiedBy: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4209:EE_|CH2PR12MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: 847bd9cf-34a1-4fb5-f047-08daa1eb1f3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8/ZllTeTIPUfZffD1qDWCNAcrZF6dkIJcOK0zrvmugvqW+WDSTh60LDAHdUsr0xEAKqKoOGywnqgLBN6+RanXn1XM5Pd6ETHdygh0+G7y+p7kpllHVgDU+q0w6Ii+tXShesx0+z/w0pE0LAFdKvI5iHY2sEcMoqUU4U3PLQ5VlBphueI0TUbWrBCpSE1iplBqUb2Ea5eQBG333gvXPZSauSHjYr2+NpVcM69w1P9JGdFAs/0tiCeVjrhjlqjAe5nw9nB30EL1hUgWAy3Q5U7xlqqEwWkQwMfGflT07d2GC3IVm11JL3HWs/ZGdMiuGqdTWhIi1A79iYchq+TK8tOxrB268yy7eeSvtN8Jumixnae0Kkm8TUMvCb8MocQ1uiUqEloZo8ghpmU+IHKHDBCIMnKpICHab46AzOqS+CQXg5iGnTfQq/B4LgZWSzLNHlH/UlQYCOu3BiEhu7w1n8QpnLj0RdjS7/gvvBWJB5Fk8Oi9Snj+zLQdNgGpldqBC+1HgDb3ACEoEKB03wTit+Omrb7lj3Ezdcx6zcI/WPa/9D+5/j57h4RNlU6n2dIVSnmp/XcBxPGUzXIi73ZKsX2Zv/oBKLMsMTmb3kV8F0yXkzbgYku6RfZAWtTH+NWtMheR+GAOZ0t3jbhacLF4s7RSGas+8tMoec8HyiHCjlJlCogfmIkppNT2na1XuI81O7oHB9gkIa7TmrlQtfutth95w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199015)(6916009)(54906003)(316002)(107886003)(86362001)(41300700001)(8936002)(4744005)(186003)(1076003)(5660300002)(8676002)(66946007)(66476007)(66556008)(4326008)(6506007)(2906002)(6512007)(26005)(6486002)(478600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5xePNKPTUeTIL6HzZkSVFbcZpxozUm0TJZ0+UUhFLbrsJvi5P1t6bIkPCldE?=
 =?us-ascii?Q?QN4h4vIIz8dWibc4IjuSTd+NLVDQlHIQEXAd4TC/Jj15RmRUSv8AOjXgKJ5F?=
 =?us-ascii?Q?3QVEQWCDTySWvcU/GNMYj/E4HZcJikyCJHJUy9waFLxWrBI1bXUkPOJthNUF?=
 =?us-ascii?Q?MxSdk+AResUHFFHOYXl7zmUGdMUAqR+RcQE8Dj/QgX5u8yj9cdxbOcLteV9u?=
 =?us-ascii?Q?bA6tA3/Jm+nAMM31CiiOJwINIiSVghFKDDWHXZ7cILw7yugkgtlLvyJW3gHo?=
 =?us-ascii?Q?ANQHTZCKFvenZO4dcoMwK2S6U/eiJLsfMW3zHHvVFi7TldvDZYtF3LbsG5x8?=
 =?us-ascii?Q?yoBjy8N1oBIKUM5cwZ4lJRbe3vmz1lyAL9t7nO1wzoDPwjUaNs+br1DAAa+m?=
 =?us-ascii?Q?NlEHJll0LI9TBMeyHdF529uwt5UIUBGOKg/+/PdyzJK6dWxvATLFIRL7f8zE?=
 =?us-ascii?Q?ccCzXz/8AGuj20EBi/0GUe5Rhtt/6dIZVHbNvysqEpxOQb43Dt+qXqel2YzR?=
 =?us-ascii?Q?QoWCHqG3Ty8kEU7F0jlX+Bg+cgiUWSjrv8e13m5yOMRbJZAhCDbAGMCXrVJF?=
 =?us-ascii?Q?AVgNQc/KkuBeYHySzueyqqncpzFZDzm61Sv8QCH6NJQEr+gGwJbevRMaXgdg?=
 =?us-ascii?Q?qra6bWz+pi74IO64HGrgcSyU6hiEh/Igpcbs2hJVRNYfM7/U+m4usCxd9DhK?=
 =?us-ascii?Q?ZGgiDti4mwFBhEoeTKJD1MGaM5B4+SViObOHZ0pzVLjJIJCDhSJmRt4So0uy?=
 =?us-ascii?Q?J9wfgPv9gxjFO6WsNA23+JRuIDhrAl4+o3JYZ24aKwBaVG38XxGObeiocZYm?=
 =?us-ascii?Q?at/kop4hSctFnGT9oYpSLdWHwR6JaJ7MQd0zoIvU3nky+CE6uWpeEGLHtt2A?=
 =?us-ascii?Q?cISCqNDVRd7yafMF9osO1Cw4dAx/CK2hALX/Rye1OtlD9/mQfIs8HIsYj86A?=
 =?us-ascii?Q?H4tr4UQ+eBQywZfpNkIt6KZu0wQUedmzjc7JF/uuf/ewBALRhfzQbmhQQGQI?=
 =?us-ascii?Q?Tt6UdqthJjLk7T7kuHBVH8nn5iLJNXjeFYUsx6shZWjyV0/pIa5+qk4DnKdu?=
 =?us-ascii?Q?dfppC19rOXsm9rn0/sWQr6G3W5xv999Dnt4dbWkn+yTeN7QR48Ymvsa7IcHk?=
 =?us-ascii?Q?c3o5C0f3Co1W4uTgc3jNkb89BDSkI4HUanefTyNZFNyP4Wk4k/YpP8KnoVWT?=
 =?us-ascii?Q?fEC0T/ArUYK3Bu3amgKZQUDch0TMSHBNPi8ilTWhWqmEEtq2X8egk52VSiuF?=
 =?us-ascii?Q?0CzyhnhyhdxyECcW6kUMtQitqPDzZ+eqxr124ZkRFKMZncsG7pQaina8B44e?=
 =?us-ascii?Q?MiU3mLXtc/KKQm3sbF72QNSekRpbUrloLonPLR9FCI+tLY/LBsvIOU/x5KU7?=
 =?us-ascii?Q?Y6QMFinFH7hKmhe1pbI5pd+x9rZuBWMc5raT0Myab6JGVFDYxOBO2v6DFrGz?=
 =?us-ascii?Q?T4wk8iuM6enroTb8/EqBGwr02V0fxtUIeDiLoszMRBM7P5uy9Ry+Pndm67ul?=
 =?us-ascii?Q?99TRbbjFlYsYgpzFmYe3Sms78VJSFkc72yXWdnKeiYxWDIqTTOJT3A3SDZHa?=
 =?us-ascii?Q?+rBX3S4/qmeW8TPXLwiqnjscQdzvhKP+u9vUej1A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 847bd9cf-34a1-4fb5-f047-08daa1eb1f3d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 07:20:44.1448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 90o/qWzZvrB0cHCtHlDB1K+8PVj/K0MTpGyplFK6RxjgxAio/MAGFK/xqMFsP9RvBmSG9NimT4DP4M0IEHjASA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4971
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Sep 19:35, Jakub Kicinski wrote:
>On Tue, 27 Sep 2022 13:35:55 -0700 Saeed Mahameed wrote:
>> XSK buffer improvements, This is part #1 of 4 parts series.
>> For more information please see tag log below.
>>
>> Please pull and let me know if there is any problem.
>
>You're missing your s-o-bs in your tree.
>I'll apply from the list, you'd have to rebase anyway.

Thanks ! I changed laptop and some of my scripts broke !

I will submit the 2nd part as patchset to avoid such mistakes
for now, it includes 2 simple non-mlx5 changes anyhow.
I would appreciate it if you expedite acceptance so I can post part3
and 4 in this cycle, and get mlx5's XSK issues behind me once and for all.

