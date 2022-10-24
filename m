Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA0060B4CE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiJXSDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiJXSDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:03:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202A81EAEA;
        Mon, 24 Oct 2022 09:43:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICDCvE1cGkaXDQ9dNdHygCGl4wXrKwHA0jssd1Q+yj9q9rko3Xdq3hK8c+NnDEw80iFQto06X96PtoqyEvChaUtzx4hY4VjvYJVoqMVnc4TqIU6c0Wl6+pMJFmX9eQUf9kslVG/Oqj06MJwZm/jW0FAyWmsiPSnuYW0G+x88AjzTrz5+V/owsC9OjsTUNjPw0OBS9RI8JPyG3THCMuIAyxLWiWLDoDwGY85Z2dBm+WgXevnwzARYHI1nbrnGjO7mBZjhmp635XJXnPkKAYLWo0+N6WqXs4ekOtYjMM5nR2movnDgpkewiV2lspqgtmAvCV0uTRZd7QL/K3W8qyIOGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k55sh9OjiE0ha8dqN/6u+9zcSFi0E1S4KdYJWOmTGq8=;
 b=k1paNC2UDXZMoacm7GoSMrLfWXRPnBrZO5Q4Jk3t165ZzZtKli8L+lv9l5QWkdcms59XwAC5VlnukykOwWUFbzke1CkP0XeC9yqDIbgV0qtlupU1tjqHOaaDugRvHTi9Z+KecqkSj7Hp8FbBYaRZGyW2HnXgRpgylPfVJvc0FvEioYtoWKCursbETUrCfkhwkJZGDJeryfCu9i4IN0xQypz2kWexGpZOV7c8sCtxw4WDs17nF4KdaCFUf2uMOJruQxrraK+tX/2ufj9TVwE2fPKn5bzlU4dbigndJOdnRA6hw/DT3Q6dIOcu9Z/YD88IzLftPixXU1z0xTOath/fGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k55sh9OjiE0ha8dqN/6u+9zcSFi0E1S4KdYJWOmTGq8=;
 b=kjj/r5Ny18+6u+JodYtWt44+A382Ma2Tku8hOID+C4vwVY7XqI7GVjiFyQ7qZKLPyR/fgT7fRQrsiN8M96MHIwfsINw1ue0f7OZ+8vBgHm4XpdYJBNoPt41bAxcYoVXrdtboiz5D9NLgnw2wnEMdQRn9UEGJY9PUy5Ejlm0Z7tvo2uzX0xObF+FGnGy9bsvhHy5VsCkzq6pU+1xOaXkf1FfMxfmMHCDYhzqDHbHAhshL1g7y9Ioo50uSD/rCK9IRHRyGm0s9P5p1vk9UGQoEdDtRiiqCfehbLFxvjaViN+W8jPgyAL+byR08oCcerfYBfOibHAO5NBYFrT0tfsJ9mQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 16:37:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5746.021; Mon, 24 Oct 2022
 16:37:13 +0000
Date:   Mon, 24 Oct 2022 13:37:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v1 0/5] convert tree to
 get_random_u32_{below,above,between}()
Message-ID: <Y1a/OAJdW+dERHiR@nvidia.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221022014403.3881893-1-Jason@zx2c4.com>
X-ClientProxiedBy: MN2PR01CA0009.prod.exchangelabs.com (2603:10b6:208:10c::22)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4238:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fec61a3-506b-441f-0275-08dab5de00ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKf80sMrg5IUycWDwhzQGsqhRuRUNEo7co2x6wOatZpaB8t5SUjUHbjAzEr6sRorBvJGsd0/tcT09UpbrAJwcfNhYs/Jg5UoK3Jjoql0TRL1veT7dcI0rexcOtjQYU3c/PD586SfWLxsB8Qu4nrKs+amImQbAeOUnBw/xvaeBbsp819ObeGXW7RI8M5GCpbHipLB+bcZ2n7vo6ylspnISqWqRSjnnLcfbdirJAvcAWn1ijXq6fDiyGByuG31c/K3EBhQXKsv0PaaXjpw6WEimArqnEB4l5DezcFtAt1IHo9N2KF2UkNO7sE9JqcSt4KYZ0kKCslN4fmsF7a8PwpGRZ9gVxDLM7CeqF/JUdTgZcNjtNGogOtecNmLyHwXVD3Ds0lFHcSvpaSHe0XgkhK1MWz4ccGI4dC+r884Rl+W2TJVObYMgqkzkLoXCHJhQXY97m1ikA4hgZs0qvEgSPOUk8Flujc8ZakU95c0DL5zpCoSvqTvSHZEnJPlTYkGrelVPhoLhmLmMA2cr9tSlWcDfkAwBt2sxC09sjlXvRsx9sk502zBfEPjQe4hBEWImrRmfPTjdNKhMhbMXKZi+1sUpv4FTF/0F+TpkkUjJOXmAn2AIEGCDpfvxRSpcm6+V4wuVkaDazIw9R91Y8i0S3a3xNJ2wAD/SH4xrwI4lBKgw/000+OmPzXYst4AReTcXzGFIOGbziklkPp1hdsq1ntvJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199015)(6486002)(478600001)(54906003)(316002)(7406005)(7416002)(66946007)(66556008)(66476007)(6506007)(8676002)(4326008)(41300700001)(6916009)(5660300002)(8936002)(26005)(36756003)(6512007)(38100700002)(83380400001)(2906002)(2616005)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zV0ZvoIw8ElUdZSnE+53L7/s2Lw9Z0tCRY0pU4bjiONBEzMp//3qKb0bLgnT?=
 =?us-ascii?Q?luu646/cUA9wc8DJrSUGSGSkQB26guhodVON6cVMCUvYlPRSW4x+OrHc/AxZ?=
 =?us-ascii?Q?oNsxW+M+ZMFX9queecYkKl+Ho63dc2uIgb69s8faH+iDEyhnjNwZbp8QGI2z?=
 =?us-ascii?Q?WgAqd631DcIyDFUXxhewccmoWHUSxDdi1Z+NOprNHh56Hmccktkqu3K6LWBx?=
 =?us-ascii?Q?+35gJGUx0jrdX7omox7zE1Xtz5AarWKcQaVPV7qVLlBYX9c5P0y6QF/nao3N?=
 =?us-ascii?Q?BnP3pESNyEYS0FLK1l2XQ56MX2od6gRR7X3Fm4dZ10f2KLq1zTtuc61j4DV0?=
 =?us-ascii?Q?r7uf6ibUMK6KzxVlT4D3KLyOU925+dYqAsAOMOJoJ0yKqF4NHNJX+iN3fYD+?=
 =?us-ascii?Q?v/46CX0UTN9qbIs56xryLjUUtuJ4vNBdyxehJQ3msa70AyJTiE1sz+oEZYPV?=
 =?us-ascii?Q?b59iLoLm/BJkK4CBoKWP9/m1sWdPlHm4wA8zbLJ3ozQGAeDfoTZLEDnDre8b?=
 =?us-ascii?Q?CP3hwpxXpNd72XfNV0nMNyuSprnMyNCz8Ohi82MTNRoZMEUwsQiLqDeHGHuY?=
 =?us-ascii?Q?Jv4Ej/l3j2LVb8sFkoIQFvr45H7/SxqCd9PbkMiWx+p5/0yXk2seEYWRpA0M?=
 =?us-ascii?Q?ymi6OQ2p7MGVsyzLULIzz88eZT6UL8sQQIL3t5uGQZRwbhVWEUd7BG4LLDtw?=
 =?us-ascii?Q?SHn8bqfc163LfRlRmaveJCPELg0Au+5kM5Ux9zdU+80DYqSqbq6lTQPSY2BS?=
 =?us-ascii?Q?QV03v8PYp0RIbmagf5svpXc5w8UyWvXjPzC03jKKRnxCFHq7zDqSeMo85j62?=
 =?us-ascii?Q?vDMafIvempx1LImdNG+k6axHCPNkmdg3DB1FOprpdrFVgixQaPKd+L2LaKoY?=
 =?us-ascii?Q?pjqSHVnI1N/yST1NU4ZFh2BJ2yyqzzjSyGqj1blCMSzhlSlRJ3jf4uUCLGjK?=
 =?us-ascii?Q?x4wTgxuaG3fFRIRu/eSONbfIm84e8MXCt7sLfdvhQe10hk5Y5YT5gH81iPht?=
 =?us-ascii?Q?pmXR9NgmWM1Qglk2IqHrWyZvxpHqNWBvwA0CFYq9FIw/T9UvyLi447sXp0Fh?=
 =?us-ascii?Q?b/bIpp5pd+n4crt+I95W4IHQh6JsJz2EMyKKdrgUaJSlYWwIJbAOtpVCbwtt?=
 =?us-ascii?Q?NsMsCcHOLciSOTGO9tnG7k+JncjFoxOzCVPN8Vj7xa05uiEv9DML2obLP4Om?=
 =?us-ascii?Q?aNyrOjBMv3zOWG2Wb95mppM1PTQLvsf5DNN6+71IUwwPknrG+FdlrDKVimTh?=
 =?us-ascii?Q?JMb+HrGacxL3LV/0gjxOLL4xxKbn3GaYUYrIMoa4Ue+/Q6YAFPDJu1FdVcjo?=
 =?us-ascii?Q?ExfLabg1a/zAkF9Jexm/xdjR4ksawnbO6kvQKUqSQG0RpdktHcyd639dXpMf?=
 =?us-ascii?Q?LL3A0FFsCUXAhaCcQUYtIZ2oSzbyI6tt4yqq8SNDFbKx7AKKhk+6moaEx1E+?=
 =?us-ascii?Q?zWC7/maV8irSk1XSAVhM4XjpUu8WrZNwCo17MZlXrE6Kf4nSlQ00CQe2Rz5/?=
 =?us-ascii?Q?VyvZa1RqT/m42NrbvbnR17eddDyaXxk5KEbu37rw1QWQYgb/Gzfcj+wkGu4r?=
 =?us-ascii?Q?FAa7n4+VgqzXYzfguXg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fec61a3-506b-441f-0275-08dab5de00ff
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:37:13.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M08JolLSTvc/mpUbbK/5pFVHM/zVSM/eOfwLc7op140A/TyaKEMEkxMK7/WMGLcq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:43:58PM -0400, Jason A. Donenfeld wrote:
> Hey everyone,
> 
> Here's the second and final tranche of tree-wide conversions to get
> random integer handling a bit tamer. It's predominantly another
> Coccinelle-based patchset.
> 
> First we s/prandom_u32_max/get_random_u32_below/, since the former is
> just a deprecated alias for the latter. Then in the next commit we can
> remove prandom_u32_max all together. I'm quite happy about finally being
> able to do that. It means that prandom.h is now only for deterministic and 
> repeatable randomness, not non-deterministic/cryptographic randomness.
> That line is no longer blurred.
> 
> Then, in order to clean up a bunch of inefficient patterns, we introduce
> two trivial static inline helper functions built on top of
> get_random_u32_below: get_random_u32_above and get_random_u32_between.
> These are pretty straight forward to use and understand. Then the final
> two patches convert some gnarly open-coded number juggling to use these
> helpers.
> 
> I've used Coccinelle for all the treewide patches, so hopefully review
> is rather uneventful. I didn't accept all of the changes that Coccinelle
> proposed, though, as these tend to be somewhat context-specific. I erred
> on the side of just going with the most obvious cases, at least this
> time through. And then we can address more complicated cases through
> actual maintainer trees.
> 
> Since get_random_u32_below() sits in my random.git tree, these patches
> too will flow through that same tree.
> 
For drivers/infiniband

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
