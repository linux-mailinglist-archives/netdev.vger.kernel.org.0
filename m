Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4320D4D4329
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbiCJJI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbiCJJIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:08:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4615E139128
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 01:07:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z53c3W+4HjqLOcUDn24TqkDmjVCeeiJRfITfveM65bOeU8UXsDj/Hbh8rabVGP66aYeKJG4oV28l7oCmZxnIJ2eU4j7ht9tA4uZ7wbJOViSz1/TAiN4PVRPPVm+WaMDtVd4Fxeg4nbCG+ZtOvpgm9ePk0QyBIJtD64+WowOwgasGFBW3Merp96dXh/3llQ0DV4pX6hsKts1kw1svDyNHVLyk4hk/MjmJCYwmWuw2b9XI+kIj78ajmsnYSK22eKr5mJfdaqs5kE0OyXgraQNzzBCHQuL//2hKIuyDBZ9MwkwZGbWCYZEUBHw+N+NoDB4q2VxMhuZTHbPg7bUrn6+tIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o8x7bbmHldn1ah1TxIbHf98KPvvghMmJx583+84AvDU=;
 b=AcYrazpC3ncToBB5cyvTg00OCLTAlGfR/K0dN2Dl7v6W2QcxbRSE5n4T0j2x41zu/NGIciHPHiUbpH8agfUFNbdRMoD7xcXJMKbT9azZUm5pi7sKa7HvqtsR3RaTI21hWv4GN5nbvqtoSVC6NwxxTd/FypwXTcCLXVecse+LiKUd60Y/bhhgZTz1YwqIx9q7H82a3+Pwpy9Xzjvkfqip10Qzq0I1HcFiSVrZLTIUPXuTg5xaF09UwSSghaLnRYiNe658b+gJ8VdTkqzsNzM/Hh9/N8KRDzyRfmgD9R+DxHGSYzFqayfgiPXG+1iz5Xl49k2LnTkKQvJNGkSZkyFPlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o8x7bbmHldn1ah1TxIbHf98KPvvghMmJx583+84AvDU=;
 b=AG0iXEjUIlSpZYuUwE6Oqne0a1GCieNYUa7f8WoUAoRRwE41n3xXnuwYBSflHo1oXZLFLE3q3Ds7jyYRkgU+U6lXfoA/O5TLBqujQAunNcct5NsLU8K/gUPUu+AbthG/HYVxM50GUidYo7OFGanWYXlFdPo0jMfto7Z/n7Otg1Ls1N/EDso8m87pyyk1xGJPycKihrakBDlAgvvR6TtmPqj438ZzSeuJkr6o+IiSg4M2CSIik91rgZ+X8Ib1j6RiVrKAUghOrDKVJ+IGhjAABY6tOERj1hcuzx6YvDwaZK0YlD1ITIzJMH8CM/bfC0+YL72kr9B4wcaGdK6JTn0ezw==
Received: from MWHPR19CA0092.namprd19.prod.outlook.com (2603:10b6:320:1f::30)
 by BYAPR12MB2952.namprd12.prod.outlook.com (2603:10b6:a03:13b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Thu, 10 Mar
 2022 09:07:20 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:1f:cafe::77) by MWHPR19CA0092.outlook.office365.com
 (2603:10b6:320:1f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 09:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Thu, 10 Mar 2022 09:07:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Mar
 2022 09:07:19 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 01:07:18 -0800
Date:   Thu, 10 Mar 2022 11:07:14 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <Yim/wpHAN/d0S9MC@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-1-kuba@kernel.org>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1f43f23-2c97-496f-1db7-08da02756203
X-MS-TrafficTypeDiagnostic: BYAPR12MB2952:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2952F803090B2ECC9C4BAB50BD0B9@BYAPR12MB2952.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jezR4/YO4SA/8+EepCHZWcRC8sDZ6oTRi8+JR5XFHPHFc5eY7TtwXsELv/53qUUzQ2Wj5crARLxtY4S8/iSStPW4NQwNnAsinUt7SOypJU2mJdiPsNMG/r23HfzHqTx5BjZ34h9jgmg8eNFj6hQz2i6z3QaKdAy+I05WvRHY/blabFUO3axzC+7b2KYfmwNiJKdd8OQwezCFctGFEtxl5fW+wueJ+XFTFZGYpaZ/nph88cCZ3PaWYwoWH0qZqM/jvEsSO9TCnGVGm9bIzaF3lLjbnf8ljANDULc6wVEthFfcisFS3qcoQViUqNgvDC7yp23nmI1CctojdpbTPDglQpkiSu2Vh1wuDn4AI3WkTI/il5hd0NrvtKsNT4Jabdn1YBUHagwYXxuc4Uqe7pMrejnLO1+hwDG2l9NHksH3iJTaCIYEcfFq6/KS0v1Yrndolr9OSX6Mu1PFbVVdTVXOj/wLkrlAMu8PmF1hI++ASq3SurZY+E3Qr7xOIEk4FhnhdvMy/q8kMyf81OEN+WMnnhnSmecBah6FtIH6BTti+Tes2o4lIdAJzx7ymPJeINEbw8Nb1pkhBos9L0aD9c/cKSo1Lr34lunrGhx2Lqf9nkLjyH4fUxucn3wb39OOm0kDyKTwxdE5FxHNfa6rxp0kzJePEfh5coJ7Yasa0Yhi6bx/UCYW+ENqEoU04ynilqH5y5HDQxL3mdYKV0TVsrtc3Q==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(46966006)(40470700004)(36840700001)(40460700003)(426003)(9686003)(336012)(356005)(33716001)(70586007)(5660300002)(16526019)(47076005)(86362001)(6666004)(81166007)(26005)(186003)(8676002)(2906002)(36860700001)(8936002)(316002)(508600001)(54906003)(6916009)(83380400001)(82310400004)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 09:07:20.4053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f43f23-2c97-496f-1db7-08da02756203
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2952
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> This series puts the devlink ports fully under the devlink instance
> lock's protection. As discussed in the past it implements my preferred
> solution of exposing the instance lock to the drivers. This way drivers
> which want to support port splitting can lock the devlink instance
> themselves on the probe path, and we can take that lock in the core
> on the split/unsplit paths.
> 
> nfp and mlxsw are converted, with slightly deeper changes done in
> nfp since I'm more familiar with that driver.
> 
> Now that the devlink port is protected we can pass a pointer to
> the drivers, instead of passing a port index and forcing the drivers
> to do their own lookups. Both nfp and mlxsw can container_of() to
> their own structures.
> 
> I'd appreciate some testing, I don't have access to this HW.
> 
> Jakub Kicinski (6):
>   devlink: expose instance locking and add locked port registering
>   eth: nfp: wrap locking assertions in helpers
>   eth: nfp: replace driver's "pf" lock with devlink instance lock
>   eth: mlxsw: switch to explicit locking for port registration
>   devlink: hold the instance lock in port_split / port_unsplit callbacks
>   devlink: pass devlink_port to port_split / port_unsplit callbacks

Jakub,

Thanks for pursuing in cleanup this devlink mess.

Do you plan to send a series that removes devlink_mutex?

Thanks

> 
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  36 ++---
>  drivers/net/ethernet/mellanox/mlxsw/minimal.c |   6 +
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |   7 +
>  .../net/ethernet/netronome/nfp/flower/main.c  |   4 +-
>  drivers/net/ethernet/netronome/nfp/nfp_app.c  |   2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_app.h  |  12 +-
>  .../net/ethernet/netronome/nfp/nfp_devlink.c  |  55 +++----
>  drivers/net/ethernet/netronome/nfp/nfp_main.c |  19 +--
>  drivers/net/ethernet/netronome/nfp/nfp_main.h |   6 +-
>  .../net/ethernet/netronome/nfp/nfp_net_main.c |  34 ++--
>  .../net/ethernet/netronome/nfp/nfp_net_repr.c |   4 +-
>  drivers/net/ethernet/netronome/nfp/nfp_port.c |  17 --
>  drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 -
>  include/net/devlink.h                         |  15 +-
>  net/core/devlink.c                            | 148 ++++++++++--------
>  15 files changed, 196 insertions(+), 171 deletions(-)
> 
> -- 
> 2.34.1
> 
