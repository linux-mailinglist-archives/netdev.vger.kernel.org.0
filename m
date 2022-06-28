Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A2355DF2E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235995AbiF1Hni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiF1Hne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:43:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E5965C3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 00:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KG2fCLTAi2IP2HZ0GoQ1EPPWo55eBqW72n4nY+u4xJn/QrA3K7s0rKCjKIVTMjYVoSNGfS5sYRp4Auvn1cYvLQavl6cBac76cofUhJkdkCdnXg7oiS6IsWjkGd/g/8QcQw1Vi+w1VtvOqlV4LUu93/RZMGB09/3syhzBmxVO9LYlWu4/HVLeeiAPX/XniAlImf7wMXW4WL3lXGmjTgMpU86G1ufMIkLVGrnb4dLBH8qOj5sR6eVGMIWV+teQ8EmpP65mzOrNxK/6dAIL7wek7U2+AC2/pmylMemeX+2Jl3eMBh4u1fSTmpcKeMQXPMxTxKBqEgGMpfir4aa0EHguuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqsETFac9EzzeuqIcQHZfqxB/7e773hB5lC5q06PP0U=;
 b=boh5GEBUaimpeu/W/GgVttVel6xEENhOMtMWyv5x3kAa3q7J0tyd/Q8tnvdQDrWEulS1n9Ol/ywrGrIxuPRRNywnwpboNwW3Dns0uv4V+w6EfVFA4tBjiLVWCUS1Y/uGV7HxaExHx4LTsyLM5kni0rQ8tqGuUTznx3DPENU+SoPxmTJGzV6P1qWWOtzXWUM+J/IO0tQAySRONv4O+jOK+d8FpvkvBi75nccmYGIMEAYDyAGO5mLX27OI53CcF95shkQREZIQQj8yl5D3W9BLBhJ+wbur+EpXgqoU++F/4I0g8hszdEb4NNAf955lKLNO6BptFYNu6V+IHsLMmMmHkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqsETFac9EzzeuqIcQHZfqxB/7e773hB5lC5q06PP0U=;
 b=owIMxViVPx61LnsdAVFmMZJuQchBqdHnj7rib839QPdTsOQOuV9rS1OrEsL1fR56YNmG7Wk/iEAAWwGI2BqSeMrl+xf2B0iVqHigd/5AZ72MyHtZj5Ci74Osxy1nLWLzAlTgJSJz0HPBh3A/Hz+++IN+63zT5RYxoWtPwdtdI/Jvj4PPR2m+3ml9lBzTrS/wibvdDw9Tzu01WT36EY0MbtBpChLdUR44Cg6swzRo7tN64OJ9zmDeGul1su0qhC6yIkuTewmRHng8NyEEJMTPOJuqBH7+qN5B9S9TwUFDo2LQg2o5Hti/R9sT3SpqJlICX3VTZDfvSnkocwwavGz/UA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB5997.namprd12.prod.outlook.com (2603:10b6:510:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 07:43:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 07:43:31 +0000
Date:   Tue, 28 Jun 2022 10:43:26 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next RFC 0/2] net: devlink: remove devlink big lock
Message-ID: <YrqxHpvSuEkc45uM@shredder>
References: <20220627135501.713980-1-jiri@resnulli.us>
 <YrnPqzKexfgNVC10@shredder>
 <YrnS2tcgyI9Aqe+b@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrnS2tcgyI9Aqe+b@nanopsycho>
X-ClientProxiedBy: VI1PR0501CA0037.eurprd05.prod.outlook.com
 (2603:10a6:800:60::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe276b82-2fdd-44c4-1988-08da58d9e588
X-MS-TrafficTypeDiagnostic: PH7PR12MB5997:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gIO1nAZU3uBtuM4K86d7yFQpIa+hBkbcekp0pYrL80b2hYbAnA0vt9CVfE1yQfo6ICq8cRaiLlnlVtwTlQHKigdQizn2AJL2R2I+T60a8czMV8DhuQUP+cf+MytRsa3EHDzhQTQvQl/HwLolV9sudaO9N3lHdi54xNb+h++4775jo1vfbG5K/PwpQuFqCL97zbU56iI08/rSSeKfftkG7HkYQtqseMF5FV+ctkVGAHmnbDoCk4/TO00Qp+XLNXYk0L84x8G3H5CKC8EX97UCofggzlM10OLvny+08CHcxAkUje6u/3eLIgNqoxSONBanw9kLOsIOIVgO7ICD3RMy65yb+jbRwa8y2xnOd6yJeFf1KyWF6CZ6OahRMWKnXZCRURtLMkzRQPZOJR901nzWCtvMusJrEPCumorybfAAqTu+v5g9zNpSjE1C7dTM7IMZymLtO5Ije4jM/Yzru3kjlxc0dwQN82ipAEQA21+0Zz0Y8l6k8zgwz8evPtpx7k02DPpbKOayvesVCkvhe32FMQDNYlp2TuVdHV9f2qiNASKgPtGJWKlW14gL0P9OUed32moyEPP3UB2u47A5b//KZp/Q+I2sfgnXPWyr695mtdqtTsvGMuFbCcXT1qZVqdXJrGS/rWfLcGiW5KKHXPIM1Pnlolrt1MIa7w2BASfhpYcN1jbvCeZP3tXczyMARIP0GgYBRNsm4t/yJHS48nweHJn4vzachRlwLLjwBqq05UEi5JV7dEwXewsR79L8xqq1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(39860400002)(376002)(396003)(346002)(136003)(478600001)(38100700002)(186003)(316002)(6512007)(33716001)(86362001)(66946007)(4326008)(6916009)(8676002)(107886003)(41300700001)(6506007)(66556008)(6666004)(6486002)(5660300002)(83380400001)(9686003)(66476007)(2906002)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DzckihYrKo7At/ut1xC++NSBJT1R5FLwenlepfK9jQKL2a3eT5gExjwyMJWn?=
 =?us-ascii?Q?y+fRAM+jnjAHYY9UJAx0LezsFeJE+GRFr4o8catcTkAcL5xjt3qKU2vHrOPu?=
 =?us-ascii?Q?H1hPlmljWInCacTeot1Fg7YsaDq64nbO4vIBwZTyf81A3YyJqyO20qq6/v6I?=
 =?us-ascii?Q?aNUbJHodA0DsvIR796YeQHD0OHciX16TBK8FygeRebZvVLUxgNQvcGEeIpCK?=
 =?us-ascii?Q?XfI08dBatYZHxscaq/aBA6ufTCHv2CzQPjhCFTMInU27GPInqHLwjueiobMq?=
 =?us-ascii?Q?U2JvHzTUg7zacRqxPZHPgSmw9RuJbFItGesO35Dr2d476GpUPlRBAQ1pAlHS?=
 =?us-ascii?Q?yPu13CiON2Ohpe0WcoZ7+pE0aBoPaCs3xL463v51X262i/H4OFsGSwS7zWSS?=
 =?us-ascii?Q?8WcwMimj3tk2cEDPMBswNVQ8RYUFX3gmcJtPLmOLzksUif7mRX8cHYjFIHs/?=
 =?us-ascii?Q?esEaID+KItrwhe3mo3Ko5hbpNIQuJnonIhAjnHWiRTNzQ/BHNrQqKLvZFxLp?=
 =?us-ascii?Q?AMtZMajt3JefcjRa35n9pvbGco66lXOscOCFJ9a2z1YmuB1SKVNENPzKSVsN?=
 =?us-ascii?Q?mnI62NbrhPA9J9KeUG1uNJX4DM21r9sfYU3yTNbZ8JEfyKJQXlxrQi9kqt2K?=
 =?us-ascii?Q?5wMfWqtxoW0UCbrWUWqLpLt8t9ezU4VUaG8a1ER6qaBkdMQW/8Lx2EsEsBmF?=
 =?us-ascii?Q?XwPBmEU8AEkhaOP2+VhN+dwYpdCqLBYlQ2YX8ixzJXnBqKjtxfuxxBTahO6r?=
 =?us-ascii?Q?nvHe5AwI5W+l8QPAWgNNOVmRIgn+Zsx8189xhM5THG37ZZeOEOGugNd58jvA?=
 =?us-ascii?Q?yTSc68SSZLfvRHRK/LnVj+4Eq5Qpv1vjs3yfmARlrWve+cDR+3wnDDQ7dBm0?=
 =?us-ascii?Q?XIj2FTd9fk7/E3D/WhVvdwwP+/oVwg9Uw1P2bddQsWkrHVDi6GnI/SMKa1CQ?=
 =?us-ascii?Q?LlTvWFR2tgn3u9ecMosf+e2l79Z9sjtBrBCMY+SE03RIIuDBuqPHmVRVF/kG?=
 =?us-ascii?Q?dBEvLzs4TqSLT0no/7rz6fycxWrCpJ5qyh9Npt8Vr4vP3B9XIuf6XOR+mLQd?=
 =?us-ascii?Q?dzUHpwSY6Poz03yXWXVaM+5JVzrFtpmgb0SLS7ReqkCW8M8JUhk0wUyKKiyA?=
 =?us-ascii?Q?2FmuAVqsI3yuI8iKneLqCiJnKY0GlJtkW6iuGS86+S+GwQPegAniKsZaHCoA?=
 =?us-ascii?Q?ZyKka/RVvmmRpQ2cFue8k8p+9NF8oqszOXnDztNV7/jBDs4hL2RXlN8RRkZ+?=
 =?us-ascii?Q?X9rHCtbA+FUPHbtJXdk87isR6MEsmx2K1XWmmVWv0KEkcmV5WKTogICxwR+r?=
 =?us-ascii?Q?yGT4lC3fBm5HG6R3q2juuozzFHxOyt2oe9SkMjH+Hmmi+HDx91ES3KXAOP/H?=
 =?us-ascii?Q?C34l1fLgjhakycrvUVEu9lwDK0in33U46tCkXMu6wbTA4U+7pBCxd07H5Aok?=
 =?us-ascii?Q?vHPCk+No4mqQn8TomlnDM9i4RoxlgN62aBXnISRhu5I3NiKO6IRnz/vivm28?=
 =?us-ascii?Q?1Mx80206TgK0f3Qqw5B8xlP1CHxiUOMLOxJyGHu5m7ANkO3V2rBquNSHsCAw?=
 =?us-ascii?Q?Qe+nS5HWpZT/4Hl8Vs7JXyjebb9geYL2BZmzGtMk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe276b82-2fdd-44c4-1988-08da58d9e588
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 07:43:30.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbwZVr1FVwQfjgW+t/bo29KOFRnowJb19evQIHB3hDSMfQ4f8EKd83+5oa5uFJV6pL6ExH7odqQBejE6PQTsRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5997
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 05:55:06PM +0200, Jiri Pirko wrote:
> Mon, Jun 27, 2022 at 05:41:31PM CEST, idosch@nvidia.com wrote:
> >On Mon, Jun 27, 2022 at 03:54:59PM +0200, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> This is an attempt to remove use of devlink_mutex. This is a global lock
> >> taken for every user command. That causes that long operations performed
> >> on one devlink instance (like flash update) are blocking other
> >> operations on different instances.
> >
> >This patchset is supposed to prevent one devlink instance from blocking
> >another? Devlink does not enable "parallel_ops", which means that the
> >generic netlink mutex is serializing all user space operations. AFAICT,
> >this series does not enable "parallel_ops", so I'm not sure what
> >difference the removal of the devlink mutex makes.
> 
> You are correct, that is missing. For me, as a side effect this patchset
> resolved the deadlock for LC auxdev you pointed out. That was my
> motivation for this patchset :)

Given that devlink does not enable "parallel_ops" and that the generic
netlink mutex is held throughout all callbacks, what prevents you from
simply dropping the devlink mutex now? IOW, why can't this series be
patch #1 and another patch that removes the devlink mutex?

> 
> 
> >
> >The devlink mutex (in accordance with the comment above it) serializes
> >all user space operations and accesses to the devlink devices list. This
> >resulted in a AA deadlock in the previous submission because we had a
> >flow where a user space operation (which acquires this mutex) also tries
> >to register / unregister a nested devlink instance which also tries to
> >acquire the mutex.
> >
> >As long as devlink does not implement "parallel_ops", it seems that the
> >devlink mutex can be reduced to only serializing accesses to the devlink
> >devices list, thereby eliminating the deadlock.
> >
> >> 
> >> The first patch makes sure that the xarray that holds devlink pointers
> >> is possible to be safely iterated.
> >> 
> >> The second patch moves the user command mutex to be per-devlink.
> >> 
> >> Jiri Pirko (2):
> >>   net: devlink: make sure that devlink_try_get() works with valid
> >>     pointer during xarray iteration
> >>   net: devlink: replace devlink_mutex by per-devlink lock
> >> 
> >>  net/core/devlink.c | 256 ++++++++++++++++++++++++++++-----------------
> >>  1 file changed, 161 insertions(+), 95 deletions(-)
> >> 
> >> -- 
> >> 2.35.3
> >> 
