Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E067661630
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjAHPc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjAHPcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:32:25 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBC9F03E
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:32:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzI6Ub9OTPfdCQ1vtu138zksGAW4THnoLK6eptjCjtzB1DA+oIi/nKlTY4R1s47xztf+i1BnzL5kXt9Hu6BLVOEPk0G/b6nyI5dtNL/vpuTJYj7D23F5mFUhMphflkMx1LhAKTuKHQzs+fgqNdqIdxIyK7hMAS8khnYBgV8UxCDzNI40UFX3SnxseegcygvTp2umBc0QND4n1G2gZ5eTUovdn44lIvljwu2aff0iahBjtm3zwGL7cRv5DLHm5f020Kg8RepAO6DayTOdEtv23Y7hIAlivorjw9AL9QIiioP+bN4r/DeH42MoZ6DoMHm9qsmVwuFEnUS/lLWM6/Azlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18OZMyNAJrkRfqGda/906mUinHu+q7a8XQErRctUE/0=;
 b=jDXGxpmj/Q81iYolofUtB1Qt6VEGV/PT0HQT5+gK0ul3UeoYPeUDoZn/Pq0uBGP5Udbz6Du4hUKUFhZd7GycasOmnZ8BA7mBTt0WrqQsuaLOFIO/jjjPTxugGfRa9d5u07hbH2ld4mIq45L8NIPOfZIj8WWgTFrx8O1wOzUlKZjiJhcqtkW7l3CTHWESFmO3xyA2UznytgsjLh2/fJjjUN2ftADixW3WlKG5FMitlhVFTrCigWjGRZ7fVsM6Jh5Kxx6HtkIznVqlFkTh4tiLtHvIEOcR0O56S901KoRTevj0180zo/gF+n6Ya6UZ1ZnoySdtgiFVLQds7Ehg6ukk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18OZMyNAJrkRfqGda/906mUinHu+q7a8XQErRctUE/0=;
 b=UIoR2xhvw/gkiLL9jlVDmbpR31gMUNfHLbnL1/eehW2PyUOt0g45t781PyVNS8FUab8CUCGd/k4TYtoTWhsYbqwA15GN7AxvQEA0PKOFo/GOv/FSz8huFhf+Hu08Nirc9OpG6/Xik6FQQisxlCE7EPngsRNXouqekFQXgLaEosxS/+MSE8cUkmXLKuk17tFOSXyUWSft8lwbRkgQQ/eSSu0UWcBZJr+wMQyivDrv6pXBxouTrHzlnvFNL8gANknRJ09IK89xSz3cG8U6B92PwLtYYN3cOxXAET5kEFsA1hTs9kFGSdWpm4TRfu/Xr3y+dy74WLCbaR2dR9YD9rQdcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB5680.namprd12.prod.outlook.com (2603:10b6:510:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 15:32:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 15:32:19 +0000
Date:   Sun, 8 Jan 2023 17:32:12 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 1/9] devlink: remove devlink features
Message-ID: <Y7rh/PvtBOY6hRuy@shredder>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-2-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107101151.532611-2-jiri@resnulli.us>
X-ClientProxiedBy: LO4P123CA0072.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB5680:EE_
X-MS-Office365-Filtering-Correlation-Id: 4eb8246c-9ac2-4e07-b883-08daf18d8740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N/1iAB/cGlA/2iiHf/sWj3kgtl8zq7ZqZ1vNVa0WL7GrS1UECJc8gqMREJEgrQC7gPrXla0xspLhUcsOrzweQ4GLgrZGCOUR6g9HYzrlOULB3ek58CfaJtBttXETq0yopIkngNEwlHz7iu1dJF/9A/Yd12FlCgmVE5xQuMYkki3KYdY4k5dKkSNstVa9KxtQDz6netwWQD7u+7Wdmvmm/VNLkzkY181egNWU+saqXUPMMWickzdpdKr7+1zDslkZtOpk20deuJ+jOdWWF+I6yOWk++su6yO6AX3nU7khYYA6rKj55sI4YG/J4a7G6pNzFM4bt0Yd/QkSybsgBYs+bF4QyWR1I7ILowRF1ZWM+FjzUdsi7XZg2/0oLXi3LbOjnbVylSAmDICEAT9WSOu964i5rwhWzA8l+waVHtbcTRADYD99TV6W9Qp+cetLDXB6WO1fOSQz3VbjWIJSPH6mutJHaKOSChFKPnZbfI6UcQ2wF6cIwtDTS6EHzothRRIgMU95M1n6b3Xs1hanP5mMK3m23FXxb/ovMK5GcQG8gsiqe7YI61peK4xDUxm+PS6hYC82ZrqVhZJkvZU0r9Y33z5a+eZ2ABqCvsvjGVDiLStrl0/rY1xFlULcnURV6R1jKI/AeAZ8TAuSKUWoy9dBuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199015)(2906002)(8936002)(7416002)(5660300002)(41300700001)(6666004)(8676002)(66946007)(66476007)(66556008)(316002)(4326008)(6486002)(26005)(6506007)(478600001)(9686003)(186003)(6512007)(6916009)(107886003)(86362001)(33716001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HTCqwBY7e1ATAxGaPebbPHIKG9bFvHAYjz0XRd73O2PXUKpp+dHsa6LPB03n?=
 =?us-ascii?Q?HdoZKpata3lMDg2QiDUhyyfHp2TVYNND9+7mnuK9jUb2KGY3aj0I8DMItwX1?=
 =?us-ascii?Q?5kAEk0nyTazuBNFbsGxlYqPDXbNrddkx/QJIfPuR98M4swz9Bja+otzZNT3C?=
 =?us-ascii?Q?qso+SERGv9W8DI6SkgVyicdar6OW6v2cSZh71TQnn4aQR15PfN5HjcsdnkIE?=
 =?us-ascii?Q?ZxKGSi6eK/z0qUj2f2unxdm5d9CuA1zEg6vfNvW+7dTnNZ0EudMtB0vYlV3o?=
 =?us-ascii?Q?oI+lyhojHiXY3Q0lll10qLRVpFJj0SF6oL8ChImCpsPDMFAnXz0bSUyLQuNe?=
 =?us-ascii?Q?5FLbca9AMLZt/dGJuG2yFVBxfDp1PnL/V30sxLhxNGTWOyJEMeLNBTKDn7Li?=
 =?us-ascii?Q?oA3mpqq19WyQWRwY2eSNQ6soeBap0VUhNiTZVFDFhSMVCA60WbYxgiGgYwPt?=
 =?us-ascii?Q?SI+xrX42jba+YYa+78s9ReE2amJfwPTutX7qt5OiLfHqSY/Sdmt0Q0fxPcVu?=
 =?us-ascii?Q?5QevMwK6C2ULlkDkzT1e2wU3z6TQVIRTrdW+OGu7BXydNnUE5U08xXMjqge1?=
 =?us-ascii?Q?9gxMhomyivBHf/7jTfQPrJKC4H/XESM8QoiHmuvpawgEJ1++RC6z3Ar+Jay0?=
 =?us-ascii?Q?20PLR+5Hyh318gOsHeFNPR52a5QYjqr6nL7EBmJ+IpC8DSD6PMvCJLIx8nap?=
 =?us-ascii?Q?qzXbeK6CsBxylAn837xHgIZjNAtQPFpF1wQhdHhlfQMGxFFWQ6IN8cIO1Ab+?=
 =?us-ascii?Q?2JsxzsDC27yR4t1awYbFsklDX8RTlYw+vrFWk5lHTlQslM30KzOEdQVqPbhm?=
 =?us-ascii?Q?i/qQDE6XSRpMs5FSYoY9tt0yDq8bFTqcf/dH/yaqHB11b5Z2hIAQiJDhrpgW?=
 =?us-ascii?Q?vSfv7rFijQ3Zqrqd46iLLsEQeN2u7MJLAq03KN9iRXS4bSGtMFKYa6ttDnVi?=
 =?us-ascii?Q?TTgWjN508Yl2jWp4CGbm+ZUR6RnwnVDBiJsezD59uf00FwaIFAG4iuN2mE1r?=
 =?us-ascii?Q?/tWZx9wmpu0HYwvYomjfQt7mY2Tdbwx5nmzXUrs8LXkAB4nFVV+pP8JUf7u/?=
 =?us-ascii?Q?jGnaDyUFAhajnTg1ZJUwchPfWFbXuT/W3EPDxhfhNMEQB/6qsNGKWXNl4j6n?=
 =?us-ascii?Q?TohWG9WCzZAwvmtqWLsZ2W4OjJaIxZRBz6nT57zhNnV/zJZw45/otDQixXiE?=
 =?us-ascii?Q?I5YCmDP4lqBotBh7FUfW+kyztp63pPNj6a/O9ALSkJqqBOL46P01Yi1KErJK?=
 =?us-ascii?Q?cNS4GpqIxyw89RQbppzCB1RjyBBgH2ad4+mvdeGEYtlAQDNvbyox76TDJzP1?=
 =?us-ascii?Q?IdsAVPdHc2EcBXrshxo8L5T7ANfXwSlwGWfNcwsckrF/IJ4hUeJleVDfJmR8?=
 =?us-ascii?Q?GtLYhRhcYV7fH/mQ0MWs9KAheMFG5DNP6HItJxvwXR8t19rcA2WmmZy3KpKE?=
 =?us-ascii?Q?mY23OEU5V3fJ+h/Wvq4jc2b8AyBzGauTgKRnWZ9sQL8bH18Yo+mgeMTNBNgs?=
 =?us-ascii?Q?LwYIvUKfqsNvqn3zz0WO4Ri67NqFDEsdf2jc8spztblMoDYHwqSFFFj1dMut?=
 =?us-ascii?Q?XionT1aozUuTUM6btRb2RiFdwNi+Yf1AKSH+Ym57?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb8246c-9ac2-4e07-b883-08daf18d8740
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 15:32:18.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzvzsp/kS/PylOBQ87pmjh/VycRUU6QhOmXXbAA3MUj46eW3uXLOaj2QzCGzxexq+/eVVXfsdyPFy2/LM6j3NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5680
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:11:42AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Devlink features were introduced to disallow devlink reload calls of
> userspace before the devlink was fully initialized. The reason for this
> workaround was the fact that devlink reload was originally called
> without devlink instance lock held.
> 
> However, with recent changes that converted devlink reload to be
> performed under devlink instance lock, this is redundant so remove
> devlink features entirely.
> 
> Note that mlx5 used this to enable devlink reload conditionally only
> when device didn't act as multi port slave. Move the multi port check
> into mlx5_devlink_reload_down() callback alongside with the other
> checks preventing the device from reload in certain states.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
>  .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  1 -
>  .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  1 -
>  drivers/net/ethernet/intel/ice/ice_devlink.c  |  1 -
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  1 -
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++----
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  1 -
>  drivers/net/netdevsim/dev.c                   |  1 -
>  net/devlink/core.c                            | 19 -------------------
>  net/devlink/devl_internal.h                   |  1 -
>  net/devlink/leftover.c                        |  3 ---
>  11 files changed, 5 insertions(+), 34 deletions(-)

devlink_set_features() needs to be removed from include/net/devlink.h as
well
