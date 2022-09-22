Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE95E62FB
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 14:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiIVM6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 08:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiIVM5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 08:57:54 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F117627A;
        Thu, 22 Sep 2022 05:57:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUzx53KbqF65U+jlM5BTq7IMumwb1VzzKQZe5FoYfAkFiu0eKukLgj3qe4EgP+QSHrobZNac3zwakvrXFcqVAmRO/LTLAr3xrQ+6vJoq2TUqksO0xnSkBSCsFV5OKUChY0MFL3AqHf/lmVOPYoOYXADEghnZ4saVd5k4WZa1QrRvyCaJupVQw3PzTpm6g9o0gmFAn36wyWW6bahrlIobdgR5PVFBEJ+eZe9jXx53b/S+1SNMcO+HxeuXK310sJXbzCl8GacL4kJmpTddZnDDngsEUo1TPxuUVPCiW9a9v/9jsH9J92UDUMcvaQRhs4lKig9ZeqS/BLcqs0F8b7IbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHND5ag/lSyJJvU+rLwrjVoxJCFuMYXUGBcI4yRc8vk=;
 b=bGOJIVy0FVqGwdMYJ1C9zO1G3AEcf5laURlIPAlpY1Hc2qqdycvNh2/GGKLI+w4Qus5HRI78Z6vNVbW0OW9l/vC0bRsBwKF+fx+pXt2Hrk28emkKX6nQ50sJLZEDipXaSP6uKZ38OOmqVvgvHRaiolmPXMjCXpgOJXgkt3LVifKEsG7XBlQXSsuFskYwvUHxB4BrIERJw1nFinhhN26bg+ZcofNcRQV36IgMYkwo1Nu7HF/Lze/wr1d6y61e3eFHe7xegnQADazQ/7sJ47sMfpZcTQv16Q7kuZ1cyKFSJpHSmn8TtKdrY+Y+hsz9b0wiEzz44ZLw1w98B4Ef31Fumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHND5ag/lSyJJvU+rLwrjVoxJCFuMYXUGBcI4yRc8vk=;
 b=Ck7p7PfVttZA5g5iWX+lYalcOFzyKyr64kpcrRDLaBIhu5iX5koCcR/xPSRfdBzo1IlUrXT2Viu3eWw+w9GEiV2iiRfR5BMIcS0puvvfo/Ua2H65lCMLeEDslpuQvu/hCwQqyl/BuDv7ByvEehEk4N61LQ0cKLn1R/iZPKKFLe/xM8DR5Rufnk34HpI7EES7vniBvA8FsNFMcDzkOAGXiHOoAVfoCgIB/awOFCZ+Z1CjLz+JNEXOcl2bQUD2jn/aoPGBhNIFJgxs1VOwbD+l4S8xzAHBm3Mkd5CYa3/yc30WyMtLGTo1sCVYzJ0KsQ1Uz9D8S7EIsKp+gv/wMEU9yg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CY8PR12MB7683.namprd12.prod.outlook.com (2603:10b6:930:86::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 12:57:49 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f%4]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 12:57:49 +0000
Date:   Thu, 22 Sep 2022 21:57:44 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: rectify file entry in TEAM DRIVER
Message-ID: <YyxbyOOoAU44Kfgy@d3>
References: <20220922114053.10883-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922114053.10883-1-lukas.bulwahn@gmail.com>
X-ClientProxiedBy: TYWPR01CA0011.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::16) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|CY8PR12MB7683:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a573e3d-26f9-49de-4a6f-08da9c9a0d79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fd8c1XQLz6F3wm0aXCVn51WN1SOzZl93GXSe04BLv8PpgHwtsutJ4MAT1TrqcA2BgGkv3oqcoyedoPcmQVoes5v/2TmyIsH5eiAjS9ssle97PYadmY6aVnoBliIBPU3yLjJP/TDS5ui4KjsZSn8vPFw96CMHAmP4F1mcaS38tPrdiWzmAsIJOpurR4nQJmgxnUuV51P66cf8O5cL/phQQLCwEN6nvyK9M6b+/71jFc194UOiD7N6ZSYcDzyz/NV/17S0K1pVsPMbMbkQdcIyYxzLoiihturjFsVXiB7gDeRzk+QUJnNt1R5xmTTtJXNqrJv4u+XdNo1JYdaST3K/6mwVKMjbKyJQ3md99IpzaNUs8cJMRCs19V5TxKyiZhTLqRpuHHv/veiatBfHwfAv3gScG+0m134UC+CWZQkACW5zVQ3j31GD5g3/93CuOOFudnhlgsMi4sPT9alOHUtRMEli7jZGZT3vJae/WS/BIdRy3BM+/eJIbLzbwVilySXrEG0ELga2P7L+ybUMgwCUAV5lO8hj3fVB2kJTjn1ondhgj5qTBQBWNUbJaL2MFJg5bJGfde5HWdcvKOH5hIuvwg8YjZ1ZvHbIt9LS3ZMhxg1lfpcEz99+kV5i8ZrLG/FWfSQpMesLSDIPjPAhAgbShRajfwcF+GYxagYFQxHoBvKmY5d2aR0kxwQio3eOCSt5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199015)(2906002)(4326008)(9686003)(186003)(8676002)(53546011)(6666004)(41300700001)(5660300002)(6512007)(38100700002)(8936002)(4744005)(6506007)(33716001)(26005)(66476007)(86362001)(6916009)(316002)(54906003)(6486002)(478600001)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4scBQa3W2TY9z9QqlG8XzNWN+Bvt0KlgzynkozBxXdAHmIEZmHldJL7v58I?=
 =?us-ascii?Q?SzPLAAFSrdwFOQWA1YuBIN8xF3cwVW9g4tKOstuqGlry+h/RZpdn0+VKB1eT?=
 =?us-ascii?Q?vTTumQQ166wxaNFRZVQoLKbdGD/n0tcqfxMGWBMrxrbOdj4pRAvrcbUwsXcm?=
 =?us-ascii?Q?5ezQUYJQA0Z16s+WmKIvxvppRjGFQqBxw/+sdoWiRlNuRnWzgevQD/GVrqfH?=
 =?us-ascii?Q?c9l0UvDYv/DiEGhxkpbhQfK748E5YoIpGXKaUx1YJlZdlYn5bAc0ex3okNBF?=
 =?us-ascii?Q?gaq58NQMW5OtX1x32r2XFyG9pKvyIHgmrOoNiAiQfPqN3pUAqvNdCVhh3eu1?=
 =?us-ascii?Q?D3L+PSTZB8aTOTLiB58M92qTWihyxLDttvVK2TNYgSRbef9YlId5RalZkEyy?=
 =?us-ascii?Q?0WBURyTpzUB+VdPLqEEgSMR9U4pwdRwwLo4BjZBG3wfqRxnRMo6ZT87FPUwX?=
 =?us-ascii?Q?18TgHAQI7mxfZVAQ5VNd3/cVuV1FoSw+Cj90mRuSX86N5Mpk6ZDhdwxwJGWL?=
 =?us-ascii?Q?nLIR6Bu4K9/N47g8FyzuDfSjyrxJAY3IT0yQb/2yzZ+4BSibwFFcaT3smpUi?=
 =?us-ascii?Q?dm/7Jpk3d0EQTtEbWH+NFS38vWySw5ePetSu7c2YCnOsIuDjD5G/OWMRn0Jy?=
 =?us-ascii?Q?LWrlfUIntxCNgdjMGQ8GsBKM3yaw/mwq4wNgU3oNHFR5Eoy4Y8SkFm+RvELA?=
 =?us-ascii?Q?kfxykivYaR7B6dzgy4Wgh1DEL5wLK2HE0M3smel/TRJ/7EuCk6oToDiSLn2n?=
 =?us-ascii?Q?POu0Tva9+MjhRoC9XU5U08IVbow0GXaJ/j1ldoDkLMyJQk656/GRkGuVo6Oq?=
 =?us-ascii?Q?E2DbMzwoQfHkZFxkHA7jKq8cnZTKsIjH6w9OrR5AFFJNSR+EJo5lbd05dJ+I?=
 =?us-ascii?Q?ozfpTeqGtufS1VpxGdfBQ+qTKmFakfets532TTXYproziXnemT4ZpBsWs/jl?=
 =?us-ascii?Q?2VfAroQJ5pxcgiFwFqV/HYpbfsUdRtntVhCBe84oRGXm/lLcqGR5H90k1yAw?=
 =?us-ascii?Q?JaBSI4x6YQ8s3c6GtoSZIFFVqazhVwfWR6TB4hMDFtLmw2lvL4PK7upOmB4w?=
 =?us-ascii?Q?DDP2kfeG7wED3OJY0Pi1jGzVWVoDrQEGJFJ38r4wE+p4V1VolZovqsBPkdNB?=
 =?us-ascii?Q?ksrFvEa1h8yxdLMrZDuUVfvGVyuMhtJUv7js33RqhhY8glRWcEszav7wk+Hq?=
 =?us-ascii?Q?4hVhU23rrjpl9MaBS77WxLB3eHwTmA1vrCrUjLmJzIZYsG0et8zmQmJUkJZt?=
 =?us-ascii?Q?Cm6tGOtmJVLnYoMxjHaBKCjH9dzLNIIWFyWz9s5MwlHKOtUQM8ysmSbGGb4W?=
 =?us-ascii?Q?lGFVdVuo+4QIBjZYUE5nOykvbduJSV5URakorHbvjZgBs4O3xaG1F5pSANbG?=
 =?us-ascii?Q?mQictfWOcK96zAuBIt+upHZ6e5XzpqyjH1fiRQPurIYi1cs3kBCttmiOFpWC?=
 =?us-ascii?Q?fUF93hK6QSz7aXvn5IlnpIK4V0zALpnRmuB396Jvht2LRwOuldI0iV17qzjy?=
 =?us-ascii?Q?VyX6G4DsbFE8GSt8i2+aKKFWUbWsaGaPWdPZt7x0zOuzlb/zC/Ymc+qb1fRZ?=
 =?us-ascii?Q?bmSulcAOLmszotfOUQf81mXMiqgu8gusKUXXHy0n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a573e3d-26f9-49de-4a6f-08da9c9a0d79
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 12:57:49.3951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 81mA9gFeDQqfJxVYHMVJmsHZcIx30H0k03tFJl2DfjGe13esDpaqsEHGbREQOLJVJS6UsAqkJub0xV4vLhJvWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7683
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-22 13:40 +0200, Lukas Bulwahn wrote:
> Commit bbb774d921e2 ("net: Add tests for bonding and team address list
> management") adds the net team driver tests in the directory:
> 
>   tools/testing/selftests/drivers/net/team/
> 
> The file entry in MAINTAINERS for the TEAM DRIVER however refers to:
> 
>   tools/testing/selftests/net/team/
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken file pattern.
> 
> Repair this file entry in TEAM DRIVER.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Benjamin, please ack.
> 

Thank you for correcting this.

Fixes: bbb774d921e2 ("net: Add tests for bonding and team address list management")
Acked-by: Benjamin Poirier <bpoirier@nvidia.com>
