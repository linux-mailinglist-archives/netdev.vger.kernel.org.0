Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592DB661696
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 17:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbjAHQ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 11:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbjAHQ27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 11:28:59 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698CB5F64
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 08:28:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9tUAgwAAW3DJV7qD4Sq3CjJEa3USLLgeTPCp0aBrune+AVZZajtJphPeR4/XhUJuOO6rh8vGJi1npRClMO6Ql8xtsyF8CgdYprBSL+mt9rqVTSo9A5sAYbpisqU1O7DbwMyK/wOYA01uheodw8iFV0bcMQeBLNQlooP7Xtqi8oTlrmVdOnmzt4LMFQc9llGhBs94xrjk7o+ADEOeqKYbSqWU0xkUwGFVD9DaJVOx22YS7ZWPyXHoRXBl4gx91dt3ETjbOGu+0a7TG5WQhkz7PMECDd1MFv81siOyyfIvTdNMTsxwApIQ7USGe/rbEytYLSM9V/8nTLpnTGwjlB+Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cWVycK4OFyvNCjud6dohIUJ4Co7ESS53zvV/5dp5/4=;
 b=e0wTQmQpbb5WqtEvTs0/BPSlnLjYLTuFlaPFE7lmntgB1ZajfPT+3j1qxAxSMh34VwBERVU29E5m+Cd9E91Ro2Arjsh9e8p7VKgfSWxpnHZcv9t5YK5BnqEbDe69onR2/PFb9JdtUqGtBHKR9GHRMmAsQxb2Q5Yv4xLR3hr2vjMPOfAfdvIy3SNoj+W63xhHBhp5i+v7Uz+GBzMLMCMH/Z+4X81lnD2CijP2SiSOECN92ltbmeM5wc+m1/slRFpe003AFFpthBYgR7umrFailSBz84J8fddXj49g+4lpmsz2msxZKP3aXay3xuN/VtFlQs6W5vRuxM71XJjQ54zhnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cWVycK4OFyvNCjud6dohIUJ4Co7ESS53zvV/5dp5/4=;
 b=OKKeMYw/z7KQOH+rRVTJvxUccTPrsTC4OirL10xfdFCSta+EmaAtO+IcBHHKteQ0M6Qjzchlhn5WtTDo5S6jM/HRKDnQxMlKglsV10ynRAQuPzSvLKlDR8evMoGQ+o4i1ZH8OGoe8sQnVJDHd3o9tZH9up2S5cF/73StPGamA2vHCSYNrCQUY/sN/XKE7hExnroNCsGyFdZcC/HmaylMk84gyurCeNzHH1SwTSGMlm5epqil2Oqifa7O6H7Gk+tKk7SSVtz9JR1ohRburu+7j1iDxy0h1AIVe95BTrR8FNU/hPW2fXx3ItnqaacXH21jD2BnWRkwHJM1erruIdnfNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6447.namprd12.prod.outlook.com (2603:10b6:8:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 16:28:56 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 16:28:56 +0000
Date:   Sun, 8 Jan 2023 18:28:50 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v2 4/9] devlink: remove reporters_lock
Message-ID: <Y7rvQkoatRhKMwGI@shredder>
References: <20230107101151.532611-1-jiri@resnulli.us>
 <20230107101151.532611-5-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230107101151.532611-5-jiri@resnulli.us>
X-ClientProxiedBy: LO4P123CA0654.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB6447:EE_
X-MS-Office365-Filtering-Correlation-Id: 6499546b-c217-45f1-a76a-08daf1957014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSHmU52gAXNvwRRQmQeB9f/1bWYG3igM5INo0JstD9c3mUN1pVHW9RXlXYNURhFo5kAk+9ipQUs2I56FkTE7GcqFbGY91tPqK894DWPes48Y10TfWrlyL7lXIgPgrm/kTdkuKnkuB+iVm1wcBxFZrU/8gz7+t5CLER5eg29pPApOl9NlSFLEt1FCXXIOikaCGqPTTnpb/dNVO2p+sfxNWyy1afEmY8+FDTTvEe+b2y2nwyb7wQZepD4E1jlNDv8sff3CmzeTr7Ea8UPJCHxVLfOuGArdUVTDgvx5rTLhntEC6sEr205+AA0q+hyEHSuLIiWlODsIKWKAeM7R1xU6pNPe7PYwTDXgL4R1LGyDnBpdoTwgsYCvc3DfRuBGjBwMLs14cI2yIKIytDL7Dvpv3iLJIdqx3xHBuSOaw9o1DQRMh6qPmcH8AwjQJbw8pOASiulp5vdPJg7lzDdefsknRUHebWTBUSrZ4i6pceMFoAAgCqpbvy6gEF6M6AXswlinh2bWkE0S/T/xdzCMnB5ZJ4U4ol4IlW78IWuqfsRP1MaSFqcikiRt6C5+WQ/WjxbQ87k40SiTPnuChrbneOH/5gYjH4NDR3XVPpus69UN3RTzmk9LKSPsJ6rP3PUbBaKEttTQs+XkvGsIKLg+Qk3XPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199015)(33716001)(8936002)(2906002)(5660300002)(41300700001)(7416002)(4326008)(66556008)(66476007)(6916009)(8676002)(66946007)(316002)(9686003)(186003)(26005)(6512007)(38100700002)(83380400001)(86362001)(6486002)(478600001)(107886003)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fxBY+dPWc+qZWi4erpDuNTH912MbA92kFpeskkuIu5GiUG0q+l9dbrq4RmTq?=
 =?us-ascii?Q?vKHiD93U+0KzzWJKb6DxKotjU46vv6oIHmVYzFlqgPGjz2BEHx5rI6IceDfO?=
 =?us-ascii?Q?K8z1oKkvuk8XnjEDVTdUmISvFCFX3sGYrvfNYi+5FL2JvokKa7cHKWFAbPs9?=
 =?us-ascii?Q?k5qyoTDXvDfnQ+jOzs6NQ2lDW5Thst0c1lA7eirbQXh2V8zPWjZKYGgtxNno?=
 =?us-ascii?Q?MNTUsr3dM4QXFIZ44rW7Gx0u24uq7MWcxt0tIEjtxUXWCJtJtoY6aPgIrO9w?=
 =?us-ascii?Q?9KTyzSi6B2RbVSjYBhWhYLlNu6nOzBEhvULYhVc/5QYXe52pDd7Vgyq3nwHJ?=
 =?us-ascii?Q?yHFjTwmRCkpJvXUoHf9xm8zOyFDBtxP9wZbr8zCnnywCW0/d+G7hIYf/RD8y?=
 =?us-ascii?Q?r/ZTP+jeAsGrwb8JgpOnGfSuZTeAaihCxlhiyQsvyMp++fHBqGM9roeQYDRc?=
 =?us-ascii?Q?zHcnsA1byHx2LrzptfOaStciRi1WlPpVrFHtJn27eCKKbd5QZLFTtc4iAops?=
 =?us-ascii?Q?8VrKoSetoXXF+efJE38tpjtbwusbo6b9ozPdjgaEOV5eQUBE4i7x1P29uQZb?=
 =?us-ascii?Q?0Io8yVMiW3VMNtNy8OKwaEqX4nS6d006IbxoOB3HevcP3sHEHHLOLfA20/ql?=
 =?us-ascii?Q?35hcBOdrCyb8N+Sudu4rQcF7kdl8HswrDL9dluiaFG+/NCEg27FQv8uzBpXv?=
 =?us-ascii?Q?U6+xrtSrtvYwAzaB58yJfwQfWmKGjRORM5Pa4WFTwNFVDbhnwdBM05JWoSk5?=
 =?us-ascii?Q?LqAgCyeaMFP+nlk9vRU5hkYKwMBDOn7Ttz0r8cwMKBHZaHYczVrCBen7AugI?=
 =?us-ascii?Q?MdWe8GCSExG01dLaF0LhOiDqz3dPzSFTjsu31l2dIE2c5fTMsT+Q2O6Igl63?=
 =?us-ascii?Q?22r7IfBym3zE8QQym8M4ssxWxJemTxuAe3Ts0Aed3q1jv4XX0ILaZM7PVvZ+?=
 =?us-ascii?Q?IaXCFZYb24CVKUiUYMDt5Fn5qFIsToP+9A6vrC1WVDIh7QKGVjGehW9O31iW?=
 =?us-ascii?Q?/mjcjPzlMKBD8DRFVd+PQW0WFgN6dYsytG8IozSclbITBejM2ENRnbMl1EMQ?=
 =?us-ascii?Q?GH7Ma5dzuSEI3+dfJCmNNJiGnsswhQs7O39ZRXcdndbJ6tMtcDDm7X/MmeSf?=
 =?us-ascii?Q?tJyZqcVMLe5kjEfKpY9GBRSKfWwkkOuRCr8qf/49iSLiPL3CqA3jOddAAik5?=
 =?us-ascii?Q?JHvv/5SSrTjoA3ROm0D7X3Q82yBhwzFDjm6YlOgIFy4YFlvijhcAfUAfPMwe?=
 =?us-ascii?Q?M+JQNxfFkOPGmRupWlnas4crVT7rkZutbF2f/ZsMzrOVE3csu+IbIBYxXIT2?=
 =?us-ascii?Q?fFEYWaKPDxjIuFOmfCa9LB8tmEC5x2g2oDCgYWvCQRnNiV0kCIB04EUV//7v?=
 =?us-ascii?Q?5G3xIsQjXmG1O7EMoFyQ5HLU2JlqVf78jiqLjMNLw49sRzh/Qp+0PvGB0iKA?=
 =?us-ascii?Q?GBGCAWzr5tdXk6hxcZvNGIvwcBSAY5x6O3u0EkOYyj0iSOTgUDyvIbpcwNnu?=
 =?us-ascii?Q?b/uvBftEGKgSlzRuwR8Ap3Vjb1jGJ8DcnwtUZt49EGvVXpwaFOu1othu9Wjk?=
 =?us-ascii?Q?K1qIZnwoVoUYj7GbWuKvWPOZgbFuW1JrfMNqiI8s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6499546b-c217-45f1-a76a-08daf1957014
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2023 16:28:56.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxLzP1MTR6vXn8eeMPXo3k7lNyQnCRRib6gUsif5vtDgvxANtsk5wL7EwFKI8neW1OcUe/CMmBPqDfGKkOUoeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6447
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 11:11:45AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to other devlink objects, convert the reporters list to be
> protected by devlink instance lock. Alongside add unlocked versions
> of health reporter create functions and remove port-specific destroy
> function which is no longer needed.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/en/health.c   |  12 ++
>  .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
>  .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
>  drivers/net/netdevsim/health.c                |  20 +--
>  include/net/devlink.h                         |  20 +--
>  net/devlink/core.c                            |   2 -
>  net/devlink/devl_internal.h                   |   1 -
>  net/devlink/leftover.c                        | 131 +++++++-----------
>  9 files changed, 96 insertions(+), 110 deletions(-)

This is quite difficult to review because there are multiple changes
squashed into one patch:

1. Addition of locked versions of both device and port health reporter
while refactoring the code to share code paths.

2. Removal of the reporters mutex.

3. Partial conversion of drivers to use the locked APIs. The conversion
of mlxsw and netdevsim is trivial because they hold the instance lock
during probe, but the conversion of mlx5 is less trivial. I would split
it into a separate patch.
