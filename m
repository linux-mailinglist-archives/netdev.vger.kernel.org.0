Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2F052CB1A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbiESE3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiESE3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:29:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABA452B0D;
        Wed, 18 May 2022 21:29:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0107wx7K5k8/RZsEmuJyorGWwngJ+kXQprNGJRFfVxz4r/HCpi7VVzyp6wrNDPmoYj1Tr2GT1Yc/EBXPu+DLIkc5NcOtPrSBoU33NrTK5wxg5Bcp0NMCBKNyHGOlz+bPdRgtrJIBdf14qmKfevPPkWjxXi1UBrDf72rDZ5Bpp4lEzUORZRnc/jLf5WYqymbINFtZ0Q6kdmYZom3PZ3wcfjsLDhgJiPM8G8OnZPKe39yPym0IC9k0dYpN/m5ya8t3JDd1Hs2hcAsaNB6j5dpffW460h9/rX2+bm4mICEVM9GwLvs5yExjX/v2856Z2q1JVzepzJcqOMMnFYik2QjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0giA1wYrFkP/Q92fzZ1CgpTMJM9/3H21SoIHL/O8uyU=;
 b=R/KpKv7uvaVkJaaCjyedM38eN1XNv+owxDbF6sww8E0H9Ot3yLdjcUm7t+sjrvxPRE14wesZ0LOjXVBkrljrHY0lUznpuwtSXygNsnwZFlBkDkv9jtK8ziQcmOQM3UQkGSj5hlfH8g9swoYmlkaFcZTOef2f6F1b6FTPfY2torTEXjVXb/89hiW/ro+jRRGmnyX7ck47qJanXz5un4VZ+GVAaxR8ng7Hbowv+piyO7QRr7C8WNUuDM39G14u0/R4OuovnNm2o6h9hfYSxROeZ2a/ukyjH7cZC65uCvjcec0ZdkjMeion0JnZ+MybGmx9vc0ziMWaYxj252hbiFiB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0giA1wYrFkP/Q92fzZ1CgpTMJM9/3H21SoIHL/O8uyU=;
 b=cIpR39eNalq9GksJDaqEWvbUQVT2wF9AlTuRUerlsGlxUKBN0KE36TfzMbhKt2fzBm87fHnrukbBD0ZfpKa7cF2Yd1DHa+Fcjoc/IYsIvKXKaqGjfh6T6ZfUKpr7RbkvKSeN3pllc+pCXE+g2TTy8KF341KmdVk0Ih1L5LrLZnipDALMRESWSG9zEntNlgypipkGMJBp647JoSrnQKupVJHBnx7mgEswzVp9EmEIcNTo5v15u1tHhfp+8QvTG+17UxHUpKnKOSdgM5XJE+xqMgn16pmsCvx+fOXpVAA/aRCoUEeDxrp0gLdrhVge9QfNEyOd1ki7EGJDTzhRtlF/5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3494.namprd12.prod.outlook.com (2603:10b6:a03:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Thu, 19 May
 2022 04:29:30 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 04:29:30 +0000
Date:   Wed, 18 May 2022 21:29:29 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, leon@kernel.org, elic@nvidia.com,
        mbloch@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: fix multiple definitions of
 mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup
Message-ID: <20220519042929.f6yme27j3pbn22q7@sx1>
References: <20220518183022.2034373-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220518183022.2034373-1-kuba@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::32) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c903a5d2-8eb3-4306-eeca-08da39502aa8
X-MS-TrafficTypeDiagnostic: BYAPR12MB3494:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3494AF8627399DFEB5A759D8B3D09@BYAPR12MB3494.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZVxktjU/gOkv+dKHK6IKCyDzsIj/jDSpRCFsAmiGrZPGxQ6ir/Kmcnr+M2+u8h2a3gNgvnIqpkzkIjnAMlyv9YFMoVakWaaehan8pyhfIBj5nsFrNfb4ZAmRPwpn89m8RkmzCmkIQoF2y1P3PP3ipb7SDZVE/1ed0RFudMDANitqPFWQ8DdeRBNPnH51K4NGa9Cg2Ca68QADJn0Y62NGVJH0paBgLHwqSysycByCWfkiSE6ORxtFU7ObrlnBX4cDwk/cOhlOkCGreKP/mN9ObIHgH7uzcjvqov++D2QJJbLnkT5tF2QRTuh/yfL3zPjH6zBZcDR1SlZAoGHsoWucHI0Csz2Vv/IhOfrdHT7gxNn7gQnmK7aDV0nt+71ZBUKVLy2a6blriFNEeYfYTizMsIPavZqO2wFDpuU7Xm6CGjTKdnlGPbPfg15dkS/F/V3bUYAfD80CZ9AIZDibgaz5fmU1TwH+RomIDOptApDIsNCEejCZzeX8CB0poFHdFFlvlqkwo8Z5LSa5ZsXf8cM7fSc3/F55oFH6d5wJEtjUZISIuOyRCZEmm2t6pPKzLqtkMqVQu4+dDjreYW23WfTZRHl1ZK7OJn0HKec1KGR5XcEpqgZAgOSNXhb4zO383B7q6VpqX6VuZlxkcXwZDy3TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(86362001)(2906002)(186003)(1076003)(4326008)(558084003)(38100700002)(6506007)(6512007)(9686003)(5660300002)(508600001)(6486002)(8936002)(33716001)(316002)(6916009)(8676002)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qA8PYonCjZOuew6jslU9W+ar9OP8kXKWDIL1pWBUpPp5f0EnNOI2NrXhbUio?=
 =?us-ascii?Q?X0MQiRQwhihlzGzR+4VQV0f4NVhwCauKWA2qdo4glnAaYTAncBqxl4ad57ge?=
 =?us-ascii?Q?Ia6Lz0PN5QSbFZC8+MiLjnMJsism4/arNEwWc3hRICqoqaknCD6jMuT7nsKw?=
 =?us-ascii?Q?geihGODdyWaPfsNCXKcL3B4N9iby2OP4LoOtgB2O/SZ19A8/1W9ffYpoG1qb?=
 =?us-ascii?Q?irtcYm5sEc4Lrpc7AROxfRIlqKr72qCTi33/ai5M/5OYO2T+0RMVu0md7AYL?=
 =?us-ascii?Q?Kb3MICemF2S/JqCpTQDMT2imQRXMRruUbK4i99wJ8w9zGDZOtiEp0xpnu0aX?=
 =?us-ascii?Q?qM0lT0PFmMbrsNr3mmYPmI4O5lGhrCUMEnU/d9PP1UBY/C4NHmRLTKEvFEzh?=
 =?us-ascii?Q?lx+ISnpymZQ6bG+yMjxYojwLYgp5R+1jgygJg6QEyek+Cx7rQUX9Qw2BiP4/?=
 =?us-ascii?Q?LuOSopfSvx/YxQQw5mQRbF6rsLXxrfG1bLRMfmeGmgDDrVaMoTIkQGV8S5l0?=
 =?us-ascii?Q?4+9RJm3GDUP3L+wePlk2HDEpX9gETbM85M37c2yXtkXcLzY6MbpafIKnBoYD?=
 =?us-ascii?Q?NEndVkrh40kt1IOqUlfOdp1VqwzsmKO5nz/8uK5Jrbc7Y9AIBJqGIYoLo1Pm?=
 =?us-ascii?Q?Jyc7T4zl2kYAVdFjTnTnYG3Tqc74FKJB/IANKbkGb8AClDVwgKn70sVNum9t?=
 =?us-ascii?Q?8zFc3CkONs3+aqLKq5C9WsnjqL4ORHufPWVqQTaTeCglkpLtLb0Rxe6IIrc4?=
 =?us-ascii?Q?Zg4glqiBrqdbqkwU7Z+EZ/rNh3P2Zw9lA/KxMkBSbY6rJzl6KencAIdIwS4+?=
 =?us-ascii?Q?YVyqUjNp3xgR3nlGQ2+73NEDpvmyl2eosDscPQbWpa8rMuclKCngg5+7bl9E?=
 =?us-ascii?Q?zDQ2TIMrpuIcrwG9ey8sQvYFJMaEgb4A3i4CYbidHJ9k/Y6WYvxGQGwP9Qch?=
 =?us-ascii?Q?MjTJi2/uos6sXaWTRbK7zE7DcoA1PkVzN73eL0Wy/CiwCZWsibCOBCsNe97h?=
 =?us-ascii?Q?UtppYnDtBDDHZ5Z17qVrjDZj5qoutAivnn/viJ2hxctabLKMw+msS5PgwoZu?=
 =?us-ascii?Q?/L1nNSh3bj9Zr7zVx8B4HXkxxrERI5RRnqhCGUs1XFjYVLnhnE6eNX1S7kdR?=
 =?us-ascii?Q?s/HNNwCoaL2ihYdhzdJSUAynz8+B3MvSA/hbHzcV8OdG6VJixRZoFSPI2ugk?=
 =?us-ascii?Q?Kt+YuLjcHvt4KFohsUGaSNLuRE+jwFDrSqvJPc0yuMTXuPk3jaHNiVUm4zVN?=
 =?us-ascii?Q?9DEXfuoWbrvoWXJWeHEooLkZUxJ7MfxdmQqVCc5/c/qj2qWqjtAts7ZGaCfg?=
 =?us-ascii?Q?nFuSdT16vdk57ytXeyO4LF0dWVTZG2xWTXSzNSC3oXBTKJYuFKSdFyLFu7I3?=
 =?us-ascii?Q?ffUsnFrqCC2Z6HyaPEo3uHhGvuA0jQ9SkalRcBV/ZZm7cu19pypF/U94xUdH?=
 =?us-ascii?Q?gJLA8zkeZKhQd/d+Sblw0mJ6wiziQXCIW0eO5ANAtwI3Lg0pEvByNRs+HoV5?=
 =?us-ascii?Q?2c9rr8fh5KicrDEfsOLbukDYGjCVs0AYfePhVYixzkewtQLlsAsKgVU70eT+?=
 =?us-ascii?Q?XQopvxmeF3+bFyIl53CfB0uAzeRKfH0UaaGb9vMxHeW1lJmnWCugYeynkssS?=
 =?us-ascii?Q?S2cFu0BXtPxkoIeh8JuZxj6GOKWDK0QXwf1+PTqmf4Z+kw9gk9c5fYVpay+8?=
 =?us-ascii?Q?ZPRfZqABioSmte7NhWNygAYAoC2yeQhxaffhpxW4D7BuElljb5/fB/0hwxZO?=
 =?us-ascii?Q?XWHX5u7aZukG0rzsZVwW+auEd1HE9jpY7EMa1xqf12xA36sHyWWJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c903a5d2-8eb3-4306-eeca-08da39502aa8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 04:29:30.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7wQWTanVg0wuQPBCrFNFVdBBrSDOTn5Ca20hoKtXo5pz8mDCsp5ZVBU31+pJakMeWqHdEXtwdmRiKQTPdrq9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3494
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18 May 11:30, Jakub Kicinski wrote:
>static inline is needed in the header.
>
>Fixes: 94db33177819 ("net/mlx5: Support multiport eswitch mode")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Saeed Mahameed <saeedm@nvidia.com>

Sorry! Go ahead and apply this.

