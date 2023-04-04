Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3076D6CEC
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbjDDTEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbjDDTEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:04:11 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C945254;
        Tue,  4 Apr 2023 12:03:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIcJp9hJbk/qgBp4l/2RVLR/9b5S/A7xDMBafWYyQxVY8onEhk9g+Q5X1vOPGAPLtZOQtHL3eriZh26jLe4CEoyyV5Sz0tSQVAjM/YAvb8b7IhxyBU7BN214dKMC6MBuoXqBmowK+H5yV0vjbqcD71IChie4PVxRS36xXknSgqGbq2EpjXHRSm+qT39NB0CXp9krFbcbFJZCCnGkZvFWJXV8G3Ci/OsH7vJiAexAL8Pc9OeSlT1NI1MCLkvbatBH6+cHktwcK51Uo3K3pgWVMO+BlAiCC255bXrWtQ0xdfyc64WLXleaHtPDWfxD88hv44aXbeGfsiD3gvv8NePEDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gojRmdbKYJ4s9a9OULPvU4CpNcFoxOrUnrAy19nLREA=;
 b=G1afjxdAaHR6tYK6kkHlBsq4HY4VBHTbyjzuDO2Ntls5ZP+nFgBCJCToUH84a7zfrCIQVGdBjlKtLfl+nfITWtGFrBNyQKMmoXArDdoRirpBNEC8kExI3L0Jywf4vxl/zG+Vl5DyfAlU9sT11ZhP79V7/5V4olTy+CytBYW1N95LVIPdRGwQ0Re0GzDcquY3m9fnvmRH8eEK2BXzrt0BvRCWpHTKpXx5ROhMD8pqE/9p8uQXwi02Vy5U0yIavn31+AQsa780BMexNTtFN9k4qvT8ajhvTE1nJXNWP1vf94hRYQwvHTdoFz5CKr+CrsqYk7aMAHtflsrpvhShXgWFEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gojRmdbKYJ4s9a9OULPvU4CpNcFoxOrUnrAy19nLREA=;
 b=SseqiecoZUko0Y3uNjgsoi+912o+mbhLkCXNdetNxVsO+lEb0+yvsisxF5gtNodE1SxCqpdta0wfrMf8DFCLIjsJq1QSDnwZ2GXZEa1ItgM9R7z91iXAqoK5+O/lhh0qcoI2QkSjiudMMzI0MU1Ma3mjiTYxaFlSxLDH5EcM1p2L8OBx5p4SHi83ipKZucyBrlJM6INiwApv5Y39NKxzklr31u0BKkKdf8gNjZmre/tQUgq4l8dhigqc5lQNmclOUL30Ez0DnIqpnOGr9JQWkfdY5D02jZSB/qjx+VpqMvo5xv9t5DiNUwTRDdoE3f0cxwUBPdF127DbiH7c7j+vPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4328.namprd12.prod.outlook.com (2603:10b6:610:a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 19:03:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 19:03:31 +0000
Date:   Tue, 4 Apr 2023 16:03:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io,
        simon.horman@corigine.com
Subject: Re: [PATCH v8 vfio 0/7] pds_vfio driver
Message-ID: <ZCx0guFFi5Y2CW7y@nvidia.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404190141.57762-1-brett.creeley@amd.com>
X-ClientProxiedBy: BL0PR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:207:3c::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4328:EE_
X-MS-Office365-Filtering-Correlation-Id: 4365e391-8c54-4e98-ef72-08db353f4837
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RW9PGRA5spM7MMYdoErzHs5WqKB3S8NypZtKFxEcd2WAjOaj6GpLlRAbsUdCKXZB2F29Nis1oN4hB2hT4XhYAOVIQ4jyKRQ70BsvDUAzHQO5tJ7eB7ibLCNchSkC4e3mI7RU0obeI0axVcGN8dOuQArHNOfzstIFPKZYnlj/pUPcUxhpYb5zRZPAkoa/R5BBj2c4eSXdNFa5QtF0QAIvTeiOLyLWiZWBSpd4o3vbEZs3M39D6r+5FDizNZXvFFF6BlOhgfFa+XysR0v3xn8048D9afQ869vBkjUeEfGadQ4naGBA41SggOndCfX+pSlzpGHBQQkL3vI3kaYtuPH3/M2SdDG772CXiUKH5C93/HMJEsmytoX4eREfZ6iahVfCLeahgHkTeczu/uNOTzrpr2iV38+wB6O67lLem8Y0wJzoruXdy6sjzvAgcHaprU77XEHDlxM5nIzU9NwDcHgbdl3XuKXY+s3Ratc1IsP0NtTuX+ovogFPOLpCE001XgJvAhj78WdklXns/D06o7Rg2eIchDD6ymSkDooDyOcBHmsh8zx73YxG3Ah5l4123eNXzUFCMP2TN3y8sQzfAJBnbUlaAYTR9MbGojQDOGQH3mY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(478600001)(316002)(66556008)(66946007)(8676002)(6916009)(66476007)(6512007)(6506007)(26005)(186003)(36756003)(2616005)(2906002)(6486002)(4326008)(966005)(38100700002)(86362001)(8936002)(4744005)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t+dDSJ0dBpdO1c8dzYDcn5uyiaQbhFQ2bJn/gDf34aaxTLTKsCdUxqpGTSEK?=
 =?us-ascii?Q?/GNAJN+he8HXjUk4DX5pb8DdfeiRAs99Q7iymrdfZzOMGJn+BTuzomohn8sr?=
 =?us-ascii?Q?3wxWV5aoXiDmAKybY1o/MOMSOOncGB1PLykrJ/iei13qhSPnah51riW6CWmZ?=
 =?us-ascii?Q?/fuQV4Ez//HKTaa7ovb5OYsSEMZieIlk94sW1d24HMw2Fg7JZVS1mjxUhuoQ?=
 =?us-ascii?Q?2NI8sHCXM+gvaMKmPcbG4e+LHefAFbtI7YgXzgmI3FdippHbuEwdBexlYcXF?=
 =?us-ascii?Q?egmJE2UytzpdP/jwJsPIEX45YQbXzieBwo+K424werL/8oOj1S53hSiptchw?=
 =?us-ascii?Q?tFLlpTR4dXtdf6AGBjriCJNshG+oh6npSc/RNbCypS2ZkX30hhVt8NxRhg/e?=
 =?us-ascii?Q?7bPLZo06mxzJUwzKIjVqy0VtcmQqw/BYqr2vpIsdoMyZj3059NgopRC5GPMy?=
 =?us-ascii?Q?S2yYxJTrzelD34r0GqquIJszgD9TY9Ce7Een0/HbsSlVMzlEtpR3hElR9YSN?=
 =?us-ascii?Q?5KtVK5EoCaK6vFmi3GBl1/NKSm1qD+79KKVTiht2uqzrLcjPojfTdzTPcgYR?=
 =?us-ascii?Q?dLhlRaHLeWOk438bYcMJY7G0kR0Q7GbAcV3otXUYq5xFY5glfQbEOgBl863M?=
 =?us-ascii?Q?AQm4f56f2rLhKVaIJQ7Sq1uIRF2MsfI4CFz2ZRZOEGHf6ssegTZ0sdbBwl3W?=
 =?us-ascii?Q?eVHdl4mTeXgCogzB6v+YvNAoZQHsqHEvJh9kMqC1JkhbV1i6MUmUGVJHBkq0?=
 =?us-ascii?Q?KGbuiBfnNRIhJ4qlFruF++BWW6k3T2ZXkUE2hTZlJT/6WFV6vZP6AhvzXr6L?=
 =?us-ascii?Q?Ey1VCmYFYpx/jmA5BnPxRX3D+MD2y3NZ0Ql3y8ez56vU5cq7DY9gro5fcuUA?=
 =?us-ascii?Q?RL/JXJRrCHFwQbP4UaY3NJU1fnCTL3TzIn7uRi6falw6B3iJ/EViH7Y13w5H?=
 =?us-ascii?Q?lVOcBV8OdoaX15YF9nifyZjLQOMibdzjJB7pr5l6whCiqyuT+8IrDuGoHcBT?=
 =?us-ascii?Q?KdgXc4IhfzozhKGrKXj9VAvaQioSYb7+A8ejYMtpSMKT4X52Gq5jAR6hCrAU?=
 =?us-ascii?Q?7+AcQn8b3EWRA6ZKTu6aB36vvtV2RmrYwH88ZTEcbrJKt8LpNlBHJ6JS0G7H?=
 =?us-ascii?Q?OGKpyCEKQGBfJ3o0iTJyAIaEwT9Hz0xk/mKooNg75k1OJrTmmkqgq8Rd+b/h?=
 =?us-ascii?Q?xZ9i41j4s5AAbzEW1EWvhqcD0/6tK+6iuMo6P0DX0f56ONqLSBjYk1vgPzUX?=
 =?us-ascii?Q?Sn0+NJsz0dHdlFNxW1V6w4MopC9x/1i4q75196Z7ut/MOwHceWrKL4QM3ZG+?=
 =?us-ascii?Q?HcoILX3hLiRhEZezu+AUooFDp+o4qJqcP47MQMtPC9ZFyREYp23mI98qROIt?=
 =?us-ascii?Q?zOD1e62l8HsHxIzW4nEG9JuqsupSuqYQ/HYdBIvno5DeOhDfBfU8V9um+tUQ?=
 =?us-ascii?Q?BpLo18nI7QywsTVqK7qLv9/K0AeAsoPCWjSRKGIx6CX110WqLK24iju4OpHo?=
 =?us-ascii?Q?zFpgkC2KCqyfSq+MvTpDZgUHavWbvuLyKFOWV0E/AvZITkodGq+5OIov0gzs?=
 =?us-ascii?Q?fGU1giWuop52aT2SEQkL1GTrKEHf+0bPyxTKnrtM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4365e391-8c54-4e98-ef72-08db353f4837
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:03:31.5097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFPlPesagCr7eGHId8MKJayFPKcwOIVKkg0AsDMYQjDZdanyqY/Y87IQ7xsVSr3K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4328
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:01:34PM -0700, Brett Creeley wrote:
> This is a patchset for a new vendor specific VFIO driver
> (pds_vfio) for use with the AMD/Pensando Distributed Services Card
> (DSC). This driver makes use of the newly introduced pds_core
> driver, which the latest version can be referenced at:
> 
> https://lore.kernel.org/netdev/20230330234628.14627-1-shannon.nelson@amd.com/

You don't need to post one of these every little change - the base
netdev stuff and the use of aux dev still hasn't got a review from the
relevant people, let alone this part..

Jason
