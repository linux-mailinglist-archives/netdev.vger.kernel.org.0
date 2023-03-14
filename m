Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B096B953C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjCNNES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjCNNEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:04:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EA288ED7;
        Tue, 14 Mar 2023 06:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaJKX8MPd5yesGfbXt+zX9cqMjY5SpGcy35mCMj8LpzHPpstOruFC3qCsjgDgsSltCbRSZI+FUS2a674J6TkwG9DK5qraDuPzNwIrar5jLM66HM0AT13CONwfUvjE0dMvm7hu3Sdbc0wtTgv+1Bdb+mDP9+cZ9CqyFyzWV1AmuYxg1UsYRyB025rBPk3/Y6K57/LWbbHtY7Uk4tO/pgOMxna5HtMl1G0QsTxKFFNE3qagKzTiDSKzUWB35HtfxJhRZYddGhuHjCOgNLIwsPwi1fkj2iFeE1RTB+Wzw67LXmHSvd9+cOvnSDz6akQWvr4nVmsIgw/PeNJYrcztpvjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0ry09d8J2l5/aVy6AfNA7kKX6xfJes4g4bQ1pPkjyQ=;
 b=FXYAZrH5LplZILgc1FGPOOdhzu1hw0pBK8k9kweb/yhheE5X6a7CTowLzANpXJpuQ9vvT6Lr5dxRUDrqgRYaarm7rHDuAZ/ixpRWBOWzlX6j7vnGt7eUjOP0i+Uh2OOvfiTkzNzHBBwKBi5889tTWJJsFt9KrfGjvgtuILRw39lJo/z68eJrIwbsjr9sSFwPEft9hGMZK08L9QWQVnURafXJNCcQxw6/8kFGLKbws5zxz22Soi+T3LVarF9uPlnphY296umIGbrPWSVm1k7ONKMFf5RXBz2+yNDViHvGyFffjV3VE28jnxuE/piHa0xyOX43CB3G6txR0yfz5ieBEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0ry09d8J2l5/aVy6AfNA7kKX6xfJes4g4bQ1pPkjyQ=;
 b=C3ZabvBKYPX0XllZb/FaHRjRYBNQ7xrVwukavtMVgIBu/sOkwtsrnSHtiXVn07ci7sghC9j3GEQ/evN7TF+JsfNZRTXba6GlEJhpH1DtMsVkmPCu+cuxNfgy3qVVZuT93Bq51JCgJSBkxQhrGLru1dPypDdVdsz2CPs9xBuQL9HnfE4BoeByzV8tjqcoToYRvicaD79PMyu/k8pQQLniy/PsaT3xneUgDebodg9NkdXItv96ewHD9Q25Ik/AlzR2uXbGZQJx0MNMsfSnzFVVXTJFr2GFryehN/Ui7vxcFwCrwYN6KoLjpqXbTnJ6bF7lFSDwU23MVezbsTY71/k6Fg==
Received: from DM6PR13CA0004.namprd13.prod.outlook.com (2603:10b6:5:bc::17) by
 PH8PR12MB7028.namprd12.prod.outlook.com (2603:10b6:510:1bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 12:54:22 +0000
Received: from DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::1e) by DM6PR13CA0004.outlook.office365.com
 (2603:10b6:5:bc::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26 via Frontend
 Transport; Tue, 14 Mar 2023 12:54:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT073.mail.protection.outlook.com (10.13.173.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.11 via Frontend Transport; Tue, 14 Mar 2023 12:54:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 14 Mar 2023
 05:54:12 -0700
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 14 Mar
 2023 05:54:11 -0700
Date:   Tue, 14 Mar 2023 14:54:07 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        <shiraz.saleem@intel.com>, <mustafa.ismail@intel.com>,
        <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>, <poros@redhat.com>,
        <ivecera@redhat.com>, <jaroslav.pulchart@gooddata.com>,
        <git@sphalerite.org>, <stable@vger.kernel.org>,
        Arpana Arland <arpanax.arland@intel.com>
Subject: Re: [PATCH net v3 1/1] ice: avoid bonding causing auxiliary
 plug/unplug under RTNL lock
Message-ID: <20230314125407.GD36557@unreal>
References: <20230310194833.3074601-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230310194833.3074601-1-anthony.l.nguyen@intel.com>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT073:EE_|PH8PR12MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a216acb-c7e3-45bc-93aa-08db248b3b9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LhrIC9KN4W71uy/CGOVpnKYXOYTTRwK5EbgfxoUdtjxLAE23l1ipvyuRRd7OOaKJZwGf9xWPT8iHalHi0GxoT6pDm7i2cOF0TrfwSvjWa6ONG9IwTFMzlZLMzBCg2DCpJEnGhsK9REuIpNIoxsDlBIrPjAuNgiC1hFcm11RoyaflESUBlanoPFiKny4RDZRZ7cGYf4Kit6pjDSCZdNIZ3dMR8gPO7zwUnUs4FLpHC8AgxRgajfpZXq02kWvxVvpIpb3G6hGhxKd9v6uGkOAdF6OU+VB6sstBimpf0FjRbBv14QVaSj0klwbQyz1IFPX0Sze/MY1MJKzdEg/Yy07oABdtrvfX4bwykV7HpQ+vJ6j3IxvMGI0qMpgZBeU1L2mCnA1j21nccv5xkpvljqM89HQRkQQMAWW2ZemwKPjHIZGqe9zTTdAtMKyHrnlPW0g8JCl2tE6QFus5CysL0miOLfm4uHDJS9Gb6S1h3MytSbUp4nN+bXl3lXzS6gsCp1AV+M5SBiEz2r9pkh5lg84hfhGcgcmiCW4dtvXbyrk5Yk1zH96TEVPPNJOnrOYDljx9Y8QQlebHI7mQoTS2OpFofqnnfhSqxjliNEwB+oPpNWulySSFxlaTRT9sFvBP7UBsV4qgWt/RJdLq7yqwNgxiGMs3KnWrtuqwyqeTw4T5dhTZJYaE4rrzSlz75H/0UFUeYgNhkDKVKG8uiGNJjkNZ21SSAro9nZ5xHMmHcSTogUsmuyV8WUEevkETppOqavylG5b+H+xzL4ljifI3dX8femngDcZcXjw+xYWePV+yG9iGP13J6GP2MNtkcaZxfHFgeJSPtkvxhUutOqw/s5B5eg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199018)(40470700004)(36840700001)(46966006)(36860700001)(82740400003)(7636003)(2906002)(33716001)(86362001)(40460700003)(316002)(478600001)(6666004)(336012)(54906003)(40480700001)(33656002)(82310400005)(356005)(1076003)(47076005)(426003)(41300700001)(70206006)(4326008)(8676002)(6916009)(70586007)(16526019)(186003)(26005)(9686003)(8936002)(966005)(5660300002)(7416002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 12:54:22.0862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a216acb-c7e3-45bc-93aa-08db248b3b9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7028
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:48:33AM -0800, Tony Nguyen wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> RDMA is not supported in ice on a PF that has been added to a bonded
> interface. To enforce this, when an interface enters a bond, we unplug
> the auxiliary device that supports RDMA functionality.  This unplug
> currently happens in the context of handling the netdev bonding event.
> This event is sent to the ice driver under RTNL context.  This is causing
> a deadlock where the RDMA driver is waiting for the RTNL lock to complete
> the removal.
> 
> Defer the unplugging/re-plugging of the auxiliary device to the service
> task so that it is not performed under the RTNL lock context.
> 
> Cc: stable@vger.kernel.org # 6.1.x
> Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> Link: https://lore.kernel.org/netdev/CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com/
> Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
> Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
> Note:
> This was reported as still causing issues [1], however, with details from
> the reporter we have not been able to reproduce the issue; a newer
> firmware was reported to fix their problem [2]. As this fixes the bug for
> other users [3][4], I'm submitting this patch.
> 
> v3:
> - Add Tested-by
> 
> v2: https://lore.kernel.org/netdev/20230217004201.2895321-1-anthony.l.nguyen@intel.com/
>  (Removed from original pull request)
> - Reversed order of bit processing in ice_service_task for PLUG/UNPLUG
> 
> v1: https://lore.kernel.org/netdev/20230131213703.1347761-2-anthony.l.nguyen@intel.com/
> 
> [1] https://lore.kernel.org/intel-wired-lan/ygay1oxikvo.fsf@localhost/
> [2] https://lore.kernel.org/intel-wired-lan/ygattz3tjk9.fsf@localhost/
> [3] https://lore.kernel.org/netdev/CAK8fFZ5Jjh-ZXfLdupQGqvb9pg7nW-6fWMN3cPMdmQQfQRLGFA@mail.gmail.com/
> [4] https://lore.kernel.org/intel-wired-lan/16c393e17c552cbf0c3456194456d32ea8bc826a.camel@redhat.com/
> 
>  drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
>  drivers/net/ethernet/intel/ice/ice_main.c | 19 ++++++++-----------
>  2 files changed, 13 insertions(+), 20 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
