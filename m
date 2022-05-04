Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4251C51971F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344776AbiEDGGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiEDGGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7281AD9F
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:02:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jxo2I3CPBA++hFF+omT1bR2RBhTYL5sFkL50KO5u/XZHOTHkZiwdSPOIFRJv2WTl5E73/CDl0IJSJfdIEFUucDcXcVEkuEK+VBPM099tcWrffk7EgsmTkHaonrwW4VtRdnpSUm2O8pSD3BorlbYp8kTYt224IGnLEl1vQD8BszcS55SJ0TGbMjo0j2hQ1/FEgEbsf5OpYM3lUsibDa66lnecT57XjJZTYkml/oCQCd3gdQNjNnmJ4Mh2RMGFQZmv6rIqodna+/DTpqFuklZ0uWOuZa0cr6Mn+AvhmdncpcSO31xc2m923nkUbHx8tSkjzxUKVQVxfUpZmFzrAU0Oog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeVy8AIJIDSrtXPzwu1Qix+JxXmEQMiCcVKqjsal5iI=;
 b=iHEAxkr++4DNZjGCVD9ngaaZy8Luj495qrffYIYUF2Lh+J4mcUFD7Kwjulbd0dDzAZ1W/i5dYhFhR8eZUpoTqclnSXDgrK/kioUk62u8i2/UpIoNOqoFKBcG5ZRZxw0rQLSrJZQ3g35JWTcKZvbRxfV9LCwPGOMiykBcr24yAfmXb59JuCwEHPFzJXNmL/DXipVzSUVOfPHIfpGhp18ZUwAq+Oq5+RxaJoNQfOJ6GU/j3aHHk6FYwZkyzjarmzVnelTPdeXNX1G3rEbkm9ULOlHcp/zoAJnBkZXH8XrBrY78NAEYVcU74uo6EXRx+YxA4AbmWIpBlFRbEKYBh6SE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeVy8AIJIDSrtXPzwu1Qix+JxXmEQMiCcVKqjsal5iI=;
 b=d0GUtFvMEKqHNTCLD950zA3BDjlFzDaQSwvYVYDav5p3VHMLoahTwNoj+SkTRbqR4Z/vpfDhvmCRULQb0GydbRts0+ZOT0/UFqimjE+e2JTwfbHfdIq/hySoVeiq5kK6h9bKaBvWMpfsL8Wufg6g32vZxye6C5e25RWGVykxyUgmNSOT4Bpg9qJrrQbvOPS191zW8Dy52HPPCZ/NNA/h6TXc9UiO+GDIBWj8Q3QiErxzFeX4zl5CvoN7l1vNwjfm48Z+oRv0cZaP6EBoh9U/XFl89CpqW1lmw8KgBtgjrQdeSL/szIekGSIUquGYz339yZBkXeat/HYh/lie+8DzeQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:02:54 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:02:54 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/17] mlx5 updates 2022-05-03
Date:   Tue,  3 May 2022 23:02:14 -0700
Message-Id: <20220504060231.668674-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0062.prod.exchangelabs.com (2603:10b6:a03:94::39)
 To BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9add3c9a-e3a5-4ea0-fc52-08da2d93baa0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB000628DEC85A2E440155B173B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0SI3rp57pWYhm2dlP+OexQAET4/Cc4DLpJ3oBo/Az/w02u5bE7GaUnAC/RAS23MWCdKQ/154E6yqW+qcYHRxhTJSJgwKtYD9YoDakIjValbjQQc8JjwbsTWTTdV78WAF0c8G/mAlllNaEu6VIBcYAlAJNdBKrT4UFC8wjG8movMocDPI0xm9Rf0+xG01pmaDGvqSOfYK+rKVY2JZPnB86ZFZ3AMn7frZatNAPX4RVXEnB0+CTkNwXB5XMbpRQC2yzLTwrIdrraDoyYNrIwqwN3jZ+clcdRwMQt5t37tmbJPznBeRA0JJ4MKMHC9XgV2CMdSS/5R16vBo1nwGP7t8pQ860nabfV2Qp0d5eDMGwCRN0HK8u12kLkwgJt0M3yUXN8h/BRd8MdIY+DGKlX5mYjglycxo9WJDmMX+rtD7DWc0Jh1S3Z0M8iWD0z8xwQ8esWuIGIE0HBe16zhZ8z8leBOfPC0lMi8jpydZKxSnxTITqVfCp9dMO3TYDRH88mxrwROhkN6OAqrXckr+M2gnDoxfTPHJiZWRk2/6dJFWnDoW9g948PAKgt974TI0l9kZGcjk1isAGa7SL/qcvKEqTPvMUc6xRL3NPkc3+c1xdQGATWR4yuBDOrL0zHOtInlnd7NIRjLijpwTFzjLol46X/iKKV/iil1tZVVEJNEPCfbosKvLvvK7XeQ2S6WF4dnD43HrzNdmDFQ2EStH6ei2X/KcaUEVqweRQRxmjsyAeBZsS3oiVyER2MV3KlXproLDQ7Bl5C0ERgsEGWrILBtIfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(15650500001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(966005)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AOYlHohaGogEafKjE6yfBdVCHW71L708/m44UFouLsiI2vtaSMVAzudIPPlZ?=
 =?us-ascii?Q?U5AX+qhUcdp1YtrcqKz2N+0ge7iN6lf8w6BTkjJ7dfV83ngMUxXCqdcA7+Ov?=
 =?us-ascii?Q?tbxlStSnkCQA+4dPRJQ/h19cAeuOrqqMJZhBWtOOJRvTAGCITxh7u6EuYo3P?=
 =?us-ascii?Q?KQDYQI9y8ulFtTienydVGhquKYApigwTRb8eLkJ/R+k7a27ahrhcXT/prshH?=
 =?us-ascii?Q?Jb8EpUNYABJj9BPa1hU6k+Rh+ANbgcuA0d5u9aC2u7P3mT6ycN2W/rm1Rfjy?=
 =?us-ascii?Q?1TNaFourIc8IPGOojY1yNuQPsCpL86gK1Zd5opGelce1pTdLEG7H5nqlbPFI?=
 =?us-ascii?Q?OAgeepQ1iPIhkmeFsrzfZ/YzbfXWCyw3vaETzMZlHDDoxAXzXar7y4gJoCkF?=
 =?us-ascii?Q?cio41WSO4U0q9srkHZfekf9mJAq0//0eeu4fpJW1tQWi96ZmEqQ7oFWBf/4P?=
 =?us-ascii?Q?gcPWBjUUpEPCKT4DID1IM2ApSPi9AxQq7mvOrkVB07Bytys9YFs7LXzXNWAO?=
 =?us-ascii?Q?XylwV5c7MaIQEOYTjzC/MZrzVlVz8Ig+SaHgTqeIvObc051F8Zgi3fQLdzLT?=
 =?us-ascii?Q?mzQXoBu0ZW/siMWpYaCS5KpDh5bX4Wo/4Tq3YWHi1rVlHwQA+w1zW34AV0qp?=
 =?us-ascii?Q?/zLSX1Xrr95zPulOi6bOKgcS0+yrVfiTyXSW5ruOGsMlEgszLRilYgRtutJE?=
 =?us-ascii?Q?OAGMm3Xt/P3qJJSyzYlbuIjYVg9w7Q3P6n8blQ/LyoQtigK5fBBtO2vFjizc?=
 =?us-ascii?Q?4gtDkIEY8CF6nC3Sghw7mu/x2tUFkjfs4AFeDGD+oRmJRE73mUBvPvochPMu?=
 =?us-ascii?Q?B/wDmEgbxaOBDZuihLCsJBu/6WW1USt+TRGqFxqgyWNulGsBdrFyJQLoH6FJ?=
 =?us-ascii?Q?TGPaPJl3amC5QvulazcPjsE0QCWevlfW4EPPoVcaCQgEwmXgLi5N8hW2DzYr?=
 =?us-ascii?Q?oeHfFGpBPEO6l02DUx66VgB0Lev1q7dSLp5+3zPcLmBCg86/9c1LeDWg336A?=
 =?us-ascii?Q?rK4fbZeC2OXtD/iMXUo8HGbtXgYSlpMv/WNRCZKSaVlZkzdmOx6c9UgjqTKe?=
 =?us-ascii?Q?+XO8dWeAk1I52MNN4LHf60JtGAlN6SN8Vw/lB7/HG8fKz3vsN70efl0I+LaW?=
 =?us-ascii?Q?w7j/N/Xub5b8JFvacdns/yGBQpjmvDwKZmnNg2i4eSDOsDNsasBKoYa900BQ?=
 =?us-ascii?Q?i+llRTOEfWCOGH/TmOKy1YlR54FOueDhUkEovnNVzxVPdztW/SlceWb+3WMb?=
 =?us-ascii?Q?jVi/GEGZezcTVXsN+oIDN50Ano+c5bMKLM0OUmrLBkjSuBKDaokHmTvL7bZZ?=
 =?us-ascii?Q?xx5U72s7u4iSjG1uVELlX4BGW+Fvhu0j2+emK9KBwgsQEdu+Z+lw6BSLv6hk?=
 =?us-ascii?Q?T4kEccajEN01Q8F1q5NB03yHRnSkMgGwOw7vMu7ZIZpqZHGBZSxCJI8szQba?=
 =?us-ascii?Q?Xh/cspnScM83A+I0CMhVBXVTjwHjqFN+XG54sLt74ylYw/Jd4mYK0eBFfZHr?=
 =?us-ascii?Q?UV0h2lMUemIB5JJuYByBPJgWbmLc6LMTzBqqIhlVpZ7UYam9ce0gR7hvrtpM?=
 =?us-ascii?Q?u/Bs8FpUQZzNpjftA+J2UPD/lKciCyJ27VVbkQaGefmlVMl7gMzUBTeN3m+d?=
 =?us-ascii?Q?dnePy3rvgcUt0tlLNhW6+BO4wyKYaQEboVzhaOi060+6vvGt0geOXGAmvvK9?=
 =?us-ascii?Q?lIjzGBdztTdVaJyj2NEbOHB2FmeOwc34TwPkcd+71kPnENy3tF0MqYcpSM9E?=
 =?us-ascii?Q?Efjf74H9hbetqAYl4NEPcKtkBT+C/SY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9add3c9a-e3a5-4ea0-fc52-08da2d93baa0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:02:54.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBUCweCE2j31QSc7gGnZhnLfgQteOn7gUf5FfFs0e3K8tM4vdgb4waGVBYZV2rIIlw6vNa4JoayGtj++op+7Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More IPsec cleanups from Leon

Changelog:
v2:
 * Improved commit messages
v1: https://lore.kernel.org/all/cover.1650363043.git.leonro@nvidia.com
 * changed target from mlx5-next to net-next.
 * Improved commit message in patch #1
 * Left function names intact, with _accel_ word in it.
v0: https://lore.kernel.org/all/cover.1649578827.git.leonro@nvidia.com

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit f43f0cd2d9b07caf38d744701b0b54d4244da8cc:

  Merge tag 'wireless-next-2022-05-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2022-05-03 17:27:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-05-03

for you to fetch changes up to 656d33890732978919f79bdbc96921dfca6f28bb:

  net/mlx5: Allow future addition of IPsec object modifiers (2022-05-03 22:59:18 -0700)

----------------------------------------------------------------
mlx5-updates-2022-05-03

Leon Romanovsky Says:
=====================

Extra IPsec cleanup

After FPGA IPsec removal, we can go further and make sure that flow
steering logic is aligned to mlx5_core standard together with deep
cleaning of whole IPsec path.

=====================

----------------------------------------------------------------
Leon Romanovsky (17):
      net/mlx5: Simplify IPsec flow steering init/cleanup functions
      net/mlx5: Check IPsec TX flow steering namespace in advance
      net/mlx5: Don't hide fallback to software IPsec in FS code
      net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
      net/mlx5: Store IPsec ESN update work in XFRM state
      net/mlx5: Remove useless validity check
      net/mlx5: Merge various control path IPsec headers into one file
      net/mlx5: Remove indirections from esp functions
      net/mlx5: Simplify HW context interfaces by using SA entry
      net/mlx5: Clean IPsec FS add/delete rules
      net/mlx5: Make sure that no dangling IPsec FS pointers exist
      net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
      net/mlx5: Simplify IPsec capabilities logic
      net/mlx5: Remove not-supported ICV length
      net/mlx5: Cleanup XFRM attributes struct
      net/mlx5: Don't perform lookup after already known sec_path
      net/mlx5: Allow future addition of IPsec object modifiers

 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   1 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 174 +++-------
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |  85 ++++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         | 362 +++++++--------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |   4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    | 331 ++++---------------
 .../mellanox/mlx5/core/en_accel/ipsec_offload.h    |  14 -
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 include/linux/mlx5/accel.h                         | 153 ---------
 include/linux/mlx5/mlx5_ifc.h                      |   2 -
 15 files changed, 320 insertions(+), 823 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
 delete mode 100644 include/linux/mlx5/accel.h
