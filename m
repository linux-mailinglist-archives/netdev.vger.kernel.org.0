Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB3E66172A
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 18:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjAHRCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 12:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjAHRCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 12:02:06 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CD9C2A
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 09:02:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNfhwxsRNfBSOdhf4KlZYedJD6fRPI5awRn+14JXhU1cnGu63t8HPgxA6sBsCUotk7EPuJWylcBuv+X1Xh2+eOXWJgrnKJyJZ492ufljZ9xduCE0JfzWHhTD9CKp6nmg3z+CH1pFttxh/b+kNRxSsT89nrG7CfpWGRVZomVBVpSBGYh7+6aKugZHkGFljl/zerlNf1lKye9uEh7CgpFQeACC8UX+XjoTB/s9ZJ1kToPt1KHx4e0Fc8gpGs/LN4cXp0h38pnBumcEKY3mr/j1+DYOcKiJtV13mxKR1a86MZOFXp9LfkgLPwh8rOXWCiFvYx/uGj1+DVZPwqiT+SKgQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnG2faCngCZ0CNVh4r74qNuUad/7HPuCWuFcj7O6T2E=;
 b=i/2/9bvUlPB3XQ6eadji3tgw8pM/skM6gEImqkBKk3b7r9Ts/U+N3iNl7wyKCuXfkSxcQt7jKZWDXV2CuOieUFNKDBDCv93WO89ZHM7F1I3Xm4Nc+lu4YMbbY2F4bBpPmAjffw51aAOgd2MCGs53fH1IheXJm/aP79TS2e5cGqXNnQ8jkCmPSIMXT8k3PfolpMM3N4GCv+kRuxQCyOopYj5r0UabXEXu+o2rvKBFzaKSrAGnkuzjdg/U9Bbd6KQl4If0asm4vZZY3kUJ+czfjOEr0PYK+wNOXsmxp1MKNT2DWw0z3oRoPy7GXrs09Dlj8EkZ2dmx65znhevvuJdvhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnG2faCngCZ0CNVh4r74qNuUad/7HPuCWuFcj7O6T2E=;
 b=IcbaXBa1JitdsjsAqNsNWjl/Dmsk0BPcls/ih4MNEkPCCNWe0NssdpJ2NDdFPeZyoulGASW+ol2pKoMBkB5BXwJWT1IjAtf3kRp25S1ZyW8gabIgxxEfVWP1WzFJS7qMCXgEk3s8nbvZkR7MrM9cr0XmgumEjH/QFAf3m0MRakOcnr8GIWeBfCRfjbjTWmoxCObwZEZtBvwxy5Do/g6vvFu0VhUzYtW4Vf3WgNQkrTittEiVIJW6Ob7IfwBvQqUuNgmf7OuRwm1Kh94SR3iPCaohnWN850FArEkLpOzp4IvnpYNK96XUOW6AanJsFZfMoJqClNcJlhqp6pT1WGM+YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW5PR12MB5623.namprd12.prod.outlook.com (2603:10b6:303:199::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 17:02:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 17:02:03 +0000
Date:   Sun, 8 Jan 2023 19:01:57 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 6/9] devlink: convert linecards dump to
 devlink_nl_instance_iter_dump()
Message-ID: <Y7r3BQphwVLuaBZ/@shredder>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-7-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107101151.532611-7-jiri@resnulli.us>
X-ClientProxiedBy: LO4P123CA0495.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW5PR12MB5623:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b5f126-8c46-45b8-d591-08daf19a1072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kma6gn9IiM1Ob+oMczAf8kx/0XeEupeURWlaI/n6lniNRscTJMOof+vcwYfsUIFqjeEQUHlIUPcGnNoQfjKiommol/Gs0CsEDqm4Izw9ThxTFA49WPgwiyt7TNaxjwuh+T0K7Km1a+gASvLS2cH0uAfUZPNPgnJ1DFmuHGbJZXcwHA/tV7ppkUbITKXxd/9tJVotyNZyXOWKb+eFLCIZecM6TYMfhBeRR4EIYvGvWiUoKaues9rggHSoZzJFd1zWin6BPdILDxVNZCYs33hjdGTtWpyv6Hd/p3oimfm+8+g6mwvvNqtQlYTTEDk+lHPeWrYi8yUpwdIDNyI3wOxuLjKc7hRW+O8ZlbPKM9p8W9wUEbtHH+D5EjxsbO+QiFP+zZE3l2Ymg6LONyO1SWlJSabVb8mfkEOk8guBAQq25zfThGMs9PgE9DEdSvSwWuya+rcNRddRO3LzpyqgY5iC8Wg1Xr5+njPGhjCZREwE74iTwVawR5uyTnkoeNcvh5KAPHXVLjRtWYs4YEiC6OCsGUeqJ05vBaBL0CG/g/tH38OnVquamldn1wPU084p+roVwINMdpZcQMWCvSBOBb6cvQueTbpi1BUxaZNkSjMqnw/TKoqqUaDGOcb4eCTrM8yuYMX33nD+ZEtBE4ZUCyx9NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199015)(2906002)(83380400001)(9686003)(66476007)(66556008)(7416002)(5660300002)(66946007)(33716001)(6666004)(107886003)(26005)(186003)(8936002)(4744005)(6506007)(6512007)(8676002)(478600001)(38100700002)(41300700001)(316002)(86362001)(6916009)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hRUngzx3cA2UCh0fr8ubRvuJv3Iy29seIoy68XaGJxRNt9YI0sKRnlvYstUu?=
 =?us-ascii?Q?XdX8EMaNvToeK0etZYAgiBQ3D74Ht74Wehx8aI0/GX+YeDjoFB1BioqAAjSb?=
 =?us-ascii?Q?55c0ZAF9aFwxJQ3ulVA0gzho4YjRky1ZSuy3SuBquP/1YSTgNZVcrcuGiPvI?=
 =?us-ascii?Q?DzlJDlYOXdkmNf9iXUj8RoTfeV66fa6zqE1f0lNSc+wOvWHE1ASB8AkwAEih?=
 =?us-ascii?Q?TwkgKRySKsTFdO8BJ7iC/oLVgB+6lpswefj6N8ZBwLddFf0SiPIUEMphCA0b?=
 =?us-ascii?Q?6GpOUya84QPOAz+MjXOOPbqsFzcHoQMmFUA3FIJMnUuPlEzDHz4fJEJeYJPt?=
 =?us-ascii?Q?6f9zPSqe7phll8/t0r73DLFWySQQtFJPSC8K5rDgtPxC5X0D2L4QS29b93ac?=
 =?us-ascii?Q?kBAM5Zoca/QO6nMxWPm3Rn9qtt/1QyBWd3XgnPo/sZG4gIOvT7/v7d8Kd5+e?=
 =?us-ascii?Q?8Hllz9Qe6ZqIbfq9F46U45KaluxNvS9DoeHxAzfb0KT10SVo37pXDaTN+rLx?=
 =?us-ascii?Q?SBetkk/0z3OMknNY6epBZsCNN5y+yJC35ONDgxTGOTE/jLd2An7qjY/UA15C?=
 =?us-ascii?Q?CYSTG24z1XUHXA1S69NO0JBDCEtaQVFdmW7lCami3N/QGHr5LNgwVCPMfUnn?=
 =?us-ascii?Q?zt2hRK1s0GFsJM6G5SRtjYSaOaLgSJ1xCOEMYJvJ9gIwZfasOTWsGuiOfGHo?=
 =?us-ascii?Q?Qhzmo6Y8q3ekhsDxapL8mVLrYWLYl4whRdJ7B5I2AqV4flfjA9xqvoiGtRKi?=
 =?us-ascii?Q?I4lLJaR7L+e7BN2Oy56Zx6XK9gX8mwWD1J2ExEHC6sq6q4kNy6/tjSfYsFcD?=
 =?us-ascii?Q?7BKc/hiq29+q8cqZvst2nTDfbQpETCKQxzkT5RjSGNYqNPVfS71VrQXV6mWy?=
 =?us-ascii?Q?Vusj7kmO52BZUULUULt/EDGIoXzhc+lQLkVp961un6DXt1A2KE4tVGJQxNRV?=
 =?us-ascii?Q?f/NeNbU9/a4CUYTnG6mccOGqBexEW8PvbMdoDTv3lwwehgJxgwGXtJk4lmQw?=
 =?us-ascii?Q?RmiGRiTD8S8ANclurFk+xX1luU0iGX7smdAORVZ7ZnpLhjqUOrte/F/bo8+b?=
 =?us-ascii?Q?ZWt10kYDKoHSHb9AKq1Sbp9tbCFxezpUiA7GwupI5KchLrb1knLhyGQUt6aD?=
 =?us-ascii?Q?wgUSXdkUsnDEGUSKPoQG9TA8jdF3KYjkbDmyIpK2gbmr6VElawy8/nYdjisr?=
 =?us-ascii?Q?Mboy7BNiTZXBAvVO/QDVzZVcU4s1pP1rYUkG5yaUdxWlnAMI5Etf6r9gfb2c?=
 =?us-ascii?Q?IBUx1IB5s3dRUl18bho36IBh4yoOKY/ii1da5AUSXCR6YOzCnmxPE6zUaCs8?=
 =?us-ascii?Q?Vl6ApPWZnHWgbphlgFiMymvCA6QNXazvowHwRyOaObX+N7UKi6C4ssaZqOsu?=
 =?us-ascii?Q?vCEbMhutcdd12SkmccPHrc9uW2gg6SamNObdeIEzmquj7xWHI7MXFZ7v3uqC?=
 =?us-ascii?Q?UKvYZwvwisXX13SoCnVTDV47YGBxaGRg+9uHQtFP4krnWpJFyRi1SGv3m0jF?=
 =?us-ascii?Q?NN3LRqE4YMYLgnAqcc0M1JA1giNZpbZVOS9h3MBvzHakDrDhjWmWP+8qEZf9?=
 =?us-ascii?Q?iFK1lFzVqI2LEikbtqwKS8YwGw+KA7y5qi+B2sMk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b5f126-8c46-45b8-d591-08daf19a1072
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 17:02:03.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MC3qCaDTlylcUVcM1dY4R3/G4LvwJj+OEbLipSGS94h4lPKBlsUakLrU9PpPJmjqnZWOwCTfOR7vh1ZdHRTx9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5623
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:11:47AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Benefit from recently introduced instance iteration and convert
> linecards .dumpit generic netlink callback to use it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Code looks good to me and consistent with other objects:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
