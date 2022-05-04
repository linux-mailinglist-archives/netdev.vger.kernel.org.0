Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F8A51A18C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350964AbiEDOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350994AbiEDOAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:00:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2087.outbound.protection.outlook.com [40.107.101.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BF0419B9;
        Wed,  4 May 2022 06:56:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkWqchx+li+AtyTQ7+yXK6p+vFpE88j47doIzX8sWC98DvtrC73AVFmWD1lQqn3c8lwgfZtMPMY3qf8UB72lMBxm/YpZ44rPKTPFDzSVp42FONMbDvp4fKsKXbhgfQi+u5/XI4xc5ql8Uc86wjjBmys5eYIIxsX8ZkFfCYOhkr/MJy66/u9mys5CSoQFe62DXq6UMr/jj66B/DNomHLvXW8l91nOh8nt6B36GY4unDWmSIAVPPRNh+RKMvMM3xz8LAeasxKAjxah6zku7BWyMavRvgiYoOS0SE7I/7j+NaGOoHTViZ05y6hf+0lXK+Z54pDLoAEszKSMc8ouWv5L2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YvBsEwLXQWNzLsi628I6/KQeGqdIfHNpV7vish6Pdg=;
 b=ZlAS0m06W/WKFNDxxilvHukVPvx7pjY6hf7FBQ8+13WGX1KT/NmbTnjkn2GU+c5yYod25gvtdICOkv1j7f3/JlkKvldJRpgg7vYF3Yd5mjFCy7VtTZeefvPToMXEMc3sg8Dh5ndB6I8nERwl4pEfAsY5gGltrJNjzVJFOiH9RdTUT7YjfQ1ZohXOCdKJNlc6hzlOzOOsoNUAONZCekFx+y1IdbPzrkKvkFRtJdx5Z/1DlwLzUqXdA+N1bO5sL2GAD3iT+7+SYtlFM1zu7JFdMyTc39rL6k7mYTMevhBr7ZQKceEFw3CwbZKSmWjQP70FRlJtT+hhnKFLrDfAtNX0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YvBsEwLXQWNzLsi628I6/KQeGqdIfHNpV7vish6Pdg=;
 b=USDEhqG6TfueQot4TovUTTWryyx8XAL3GXea/+PrCwQYE8U9XrnQGVIfJvIEeI8B5Bmzbkx+CU8cZEQe0daAC9ydVeludLtLMb+K+zNi9xe5DYRmEQNOaQ7nT9XGz4RVR45ReZCfrc6I1VzV1tu6Kq2QaUpvFvwBxNvxrbLz87ySZY31C5RwQu0UtL26Gr2P9auOEFL1ezZimcv/OuccSKdxbIH7V48ppL7RONxxy91HZVV/H7d04pxilRs4Ak/NtxSA2KeiDg98oIbduX/smb8chBOsTbIRhurHGRkeCp02Y8lF6VY6UyFl6g8jfKZio6Y3Tjli+/u5xA4jubxhaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1219.namprd12.prod.outlook.com (2603:10b6:404:1c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 13:55:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 13:55:58 +0000
Date:   Wed, 4 May 2022 10:55:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH mlx5-next 2/5] net/mlx5: Expose
 mlx5_sriov_blocking_notifier_register /  unregister APIs
Message-ID: <20220504135557.GF49344@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
 <20220427093120.161402-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427093120.161402-3-yishaih@nvidia.com>
X-ClientProxiedBy: CH2PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:610:38::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2ebddc3-ca66-4dc7-a46d-08da2dd5d0fb
X-MS-TrafficTypeDiagnostic: BN6PR12MB1219:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1219F7EF315F59F03AE5E678C2C39@BN6PR12MB1219.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2dl832O9lnA3AmeQ/VvsGfnKbjQXeEk7YlX4Tbp/cvEyemfEkYNOzgBWVEPOBYFNPrmI35aekyZVuENUgizOWnwtIgCIq1k4ntQqxA9oV8pewj3BJ/SQoTLVZWG2ikL6y3oPdkfekRkg0uVfk7veww19MwePdrU1ZNV0yQs8V4SqzLxP6wlrw9XJlZu5fbmVRbDZeReXTvuJtcxSb0JhRCldhIAF6LdAMfqNwVyb4dZ73+dOLFjmm7tmFZOpBMEm89kqYwKPf6Kc8uw7yTaiQGq+jWnDbtO2RBl/lRYQha7TxowIruA+mg3cEN80Wt5LBEr36zQvZr3C9o4VpiIouNV60qNIWSAzwl0qXmGOjGNK/AN5Fs1Yf4qYpiekIW9Ayf339xUR6lsI4eSUuneZ9Iyw4Gdm4IV3Oq/LmF83jy9AgRzY2tdxLgA8P+iLHtlEqSiMJDz2lvHSr1/2zxG6U7RELeFr45TB78jM1zZQxx/qPI7heO5UAEzRHJj0ZKWX7q5FmrpPLEozKcWfUI9XROyPsJ2CcX/LERsyQaZX4KvB11eC86GAwv33qk3zBjASugw2mI/B5Ko29nS1ZWMr2B86HFZYR4htnH6WgFg5GZ8cW0pjYDCelxdDi5lY/Bn+uS4nu/NRzsYDvg2f97jKVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66556008)(66476007)(8676002)(36756003)(6862004)(66946007)(4326008)(38100700002)(6486002)(508600001)(6512007)(37006003)(316002)(6506007)(26005)(2616005)(6636002)(186003)(2906002)(1076003)(5660300002)(8936002)(83380400001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K6mcyZWnynjLzGid3qQ/bTF8w2JVp+KDo7RAuCuPhhNZKsOT+y+S1kF2QduC?=
 =?us-ascii?Q?gou2gqsd3LzRm9yObcfOjHwm0ernqR+JmM0qzsUBdKgoiVzyBiQISIJxsRNX?=
 =?us-ascii?Q?aASJ8dq0yIYb5Xw09gMqhY5ooAM2TEN0ONsleMV7QvIyjYWuWBwBjhTatXjW?=
 =?us-ascii?Q?/NmgAEhOXP5yQThsldje868YrDmh/X0nM50geKGbfO6j1nAaoM5dK++l0ozs?=
 =?us-ascii?Q?FOcj3eOb6RIbmFM8WBo1LDwvtLJ5nwNyxfbS527kzbx6KCo3bOGpm8QT8Xd+?=
 =?us-ascii?Q?Y7gX3gEIcL6ey86Q0rc8kisG9r8thdJ+eIHPD3MYusToMdxIJMFqBX6zlsfG?=
 =?us-ascii?Q?ls2LFopgav1SNIR5ePqRKYatwqXsITorRJDtKQXXED3T+QSZKNw0fzCLAra/?=
 =?us-ascii?Q?iuoVB85T9GUy6OQm3vK1WkSKkxmdITnJxs+H5wJEH/x7uCnpIhhhv4EGxx2z?=
 =?us-ascii?Q?lKh4IUTIMYYpOqlEWCuCbpMsgQBHRCN4Q7DiAstIA19WRm+m0H17/BfOHvB0?=
 =?us-ascii?Q?UwLrTc6AMACFGJevqnv7U90vKZRGoIVAtUz3xtHfkemFSzvO5/aCV+veP6Uf?=
 =?us-ascii?Q?uTf2H2q5pHSGQ/b6VrFlaPoFLZzTmm2y2YaCYvvcySr/gNwGbe1z353sp4eC?=
 =?us-ascii?Q?DBoZ5SrVKualPc6c8XAelzUIJjZp/H1oS6rIMiOU/gjKVIuPuN7tgtx116CB?=
 =?us-ascii?Q?4Y8Iajieo3qkEb6iVL6w/HsAKqUldi1NK90ojL9Zcpw7BSAH2ihnGZWOu3XT?=
 =?us-ascii?Q?6ubND3TWmjFdIzvD4mg1ozKtV9rzleHJ+3gTa5wzJNfpMawiZP9/Kc3QpNsU?=
 =?us-ascii?Q?4/cYarmKyYqsqirLkbtb7VDaBA0jMubHmb7YP7xR8taRKe1/FMOIIKuxuU4o?=
 =?us-ascii?Q?FigFdnaItK8swOkBOK9YlO9TX+w+K2HmwrT8uyK4nyiatKk0xZpaYgPAZHqG?=
 =?us-ascii?Q?BRkvYpOGC5HqvC0ZBaORo1m1M4SJOtC3wcAY7baZ0prBx/iSboaeP3cIwmro?=
 =?us-ascii?Q?bpdgEhKTcSn/hK6y4bCGzMZUSwFVdul2U1SWccuk2mq5rKX/OmbVteh0TerE?=
 =?us-ascii?Q?RkD+/Tzz9O7bw9INIyvwtjVnGCC0M1lI7L6olp2/ROtKuajQ7dISWSwOPZJl?=
 =?us-ascii?Q?A/K87hVlGqd+7PJr0TQiaSLKobvBWPC+HaHNp9ex5C2T2ZZWPXcQFcQwbQ29?=
 =?us-ascii?Q?XNwBwLbgeG7wc6ndwe4ylZXRv2sNeUsZXdgft0L8Ng+TIsjGxvzGEp2CYTDm?=
 =?us-ascii?Q?EvSsYuL+faG3YBda/Cu//tnryx5lYyKzVxBTv804FZqq3RNulScj9I/S1vn4?=
 =?us-ascii?Q?iwUomQGXbDW8MarW3C8QqG4x9fucEwPpX3qPsvTEsmcdL4PcAVCznZorknai?=
 =?us-ascii?Q?ZbiKmeLO5g45wO2cUR1iHj/9bab7nY06MJfDu67LU6GeglRyYvvmgJXz0Esf?=
 =?us-ascii?Q?Es5HbUKBRKmXkRUVrl2rT9O7CP3vdaMnAfUbHBCmQT79dnfdNypw9TS0ZUU2?=
 =?us-ascii?Q?7fPpJiljV+eJ8EeU7UBIq6HxeC33pZCimUHLVQ7ii+OqtiS1NcOJQ1ek8l51?=
 =?us-ascii?Q?QEbLzDGi0dLKp8PDAV1syEGgJGPq9ZpEc9TSePTEOUeW3JmopHupudxaXVaX?=
 =?us-ascii?Q?+gs80htHiMHSEdvqkgJi44Fr5eUb6gn24VHYKqpLKWln0kNFhA48mssCWhPh?=
 =?us-ascii?Q?2xUZKkw49OCMhKthZ570THtjxZ25dFu+vnHPvjSS1MraBvwDjUkyYEMdmgmQ?=
 =?us-ascii?Q?RrrTxVqjQg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ebddc3-ca66-4dc7-a46d-08da2dd5d0fb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 13:55:58.5501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9aCIwUxqi9gL9PbYPMBru0RvtoECRYDjEZvd7UbjT2uCLuW03/LQDqCdXKNY7Eu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1219
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 12:31:17PM +0300, Yishai Hadas wrote:
> Expose mlx5_sriov_blocking_notifier_register / unregister APIs to let a
> VF register to be notified for its enablement / disablement by the PF.
> 
> Upon VF probe it will call mlx5_sriov_blocking_notifier_register() with
> its notifier block and upon VF remove it will call
> mlx5_sriov_blocking_notifier_unregister() to drop its registration.
> 
> This can give a VF the ability to clean some resources upon disable
> before that the command interface goes down and on the other hand sets
> some stuff before that it's enabled.
> 
> This may be used by a VF which is migration capable in few cases.(e.g.
> PF load/unload upon an health recovery).
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/sriov.c   | 65 ++++++++++++++++++-
>  include/linux/mlx5/driver.h                   | 12 ++++
>  2 files changed, 76 insertions(+), 1 deletion(-)

This patch needs to be first and be on the mlx5 shared branch
 
Jason
