Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C86686320
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjBAJuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBAJuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:50:12 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DD0269F;
        Wed,  1 Feb 2023 01:50:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejqGItCp2maCqHDERgR6zynbq3roVTjquJ16V4jEne3bntaWcK0XcKjn/Z3we31PfR+jgPyfT5WG0gj1Opo/SDB8221R1Cy2VGpOO8ofs2wSEhjTHxR+W4aTwNoqqbsBYG85odYt4XYb3YmeTab/4T8Yl+TV/1bC2bD2XeUvIQv+2bKBQ4jAN0RIccq6B/KvTPJ00qlZFWP28g1Uu2gANancgwIBXNSlwNbwtquzUOvvdbA8f8MNRaZnXYb1oiBeuo4p5Rh/+5eZ4F7KKnrQZq673zkGzSYJYaaVl6DoI3Mn3oN9ttEzzVdf7bp+AjrOtBlATLesUcmqe59cw7CwmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GJ01NeOHXpi4AK75Qwub2e8cQqJE3Iuezf7oxpYGeA=;
 b=jTlgzEjt7esaBKWNu0tJEcCvX1V0Wn4hIAuVHwMLmL3a3aZkTuCxyuLqbjj+4oNa93FG+CAOuqm9yCIQQpz/d+/93xnmYuiO9NvfZIXYKOu4x2OcRh2CUagZo0cCgMzh+LeFq+QOLSk5fR9HsRgJmSLdfgbiieQAGVAPevv/UA8ATgf2mH+Z7p06K4kp65c3yG6eFqHQ3xrH+kqtJQ9ZWi35oK5FpIkR3rK8m94J0jNo+v4/74aWXtaNwQGofjwm/wOFffgIHzIWeCArhi9BxHE/2HeAALYNCtiNDUtoJJRvqwuywc9wBCbxIdZmM+zJDPEvSy8di43m706FKoi6IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GJ01NeOHXpi4AK75Qwub2e8cQqJE3Iuezf7oxpYGeA=;
 b=EB4VjCl43NYeSj+mz8DPWd5JcKVfUo4cEMWMSbdNCLguqWpAuCO+om/HZKMZXpF8ziKjZlk+Fwav0c6XKoD652fBCOdnnc6utuhzDqlH+o9kAuFtqYYuRU57qJpA97tLFXUAL2Rr2lZuW1pfZTas0pWm809c6YAwL+9zyAvSlZ4d4tNra0wcjBeuQfNQiyWt1nb/d1z1ag9EhAtFijxKVnyfINx4ShS6IzRbpeN17dPRAwa+yfL/iuSgeR60fhxIAzMYJVZVn5yJGILuEeePcWqw69qZzGoBXq5QQfkp39S8TucTK1o1AfHX8R4sUCR/ZE5NzX4yFAWi1RKfDgDM2A==
Received: from MW3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:303:2b::7)
 by CH2PR12MB4183.namprd12.prod.outlook.com (2603:10b6:610:7a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 09:50:06 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::5e) by MW3PR05CA0002.outlook.office365.com
 (2603:10b6:303:2b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 09:50:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36 via Frontend Transport; Wed, 1 Feb 2023 09:50:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 01:49:57 -0800
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 01:49:56 -0800
Date:   Wed, 1 Feb 2023 11:49:53 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, Dave Ertman <david.m.ertman@intel.com>,
        <netdev@vger.kernel.org>, <poros@redhat.com>, <ivecera@redhat.com>,
        <shiraz.saleem@intel.com>, <mustafa.ismail@intel.com>,
        <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug
 under RTNL lock
Message-ID: <Y9o1wbLykLodmbDd@unreal>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230131213703.1347761-2-anthony.l.nguyen@intel.com>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|CH2PR12MB4183:EE_
X-MS-Office365-Filtering-Correlation-Id: 80834bf5-bac2-45d1-940e-08db0439b268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3yWhnZOLY72FIAHDdwznAvUo1WnZR21KYQHP5QQXi2AMZ47t6q8QQdJouSOn6QJGB65Bc+QMvYjSfEn48I0lT1DPO8mmmHOVsbPecyKA//Nv/n+0268IxpiEppRcYOBlZu1u86l1hdRWpfYuEjOZYF7LGeSu/5RBZc2vo8aGduwGM5ozPtPSQ048fMwPZuQsFrLsEqCmHgrDJVYnIHfYk97aIRJgWv3jYwrk2pSYd0tX0NXkwuT8qz+pJTgltHWUOj8hB5ySFWPE9+u+hd9h7fFooB3xYE+CWjgfNEmd2pRZDTeOejjoZojkZsj4X7Q+v2iqGVqf0zzye9/nl8XXRT3E1laYu8RSf01ysXAC4C6pftaAKkzgbrSo9RUngY2+8V8GP83ZpKzh65iooiswvi77z8EZWmo6laJ5CbuRs7tP6ltauD9q+/ZX3wsweYdsDgaNm/265Q5WxgaTp970QrNF7J8gled+0yu9dKE5hXgbQoBIgfX0Rjy5wfBCR490KcrQRgXvVcVX8tLXajGfsn2lQ2TQ52Tvht9TjgfyW6FBy6KTl3wFd9bAZt9d08OatHf36dE+qenu3GfWd6tDgzB/6OLqLEML6blwXI2Aws9btILRYEcctq1PJuwt4MlH/YBAEB7PVOdXQ8p42VdLsKfLmR/vkv8oNOOMxuMDABz+BVXIFmj559AnpPkMn1aJ4TM2BmcXvlQBxjWLdDJz+EVqWP9N9WoHonPb39g4iEyfdqW0O0Zk3yUjsuW2PJ3KdHBQBgMvp/NFewHe/Mg+KZFhTWy1gT57FUFcKbbgB4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(376002)(136003)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(426003)(33716001)(8936002)(2906002)(6916009)(8676002)(4326008)(336012)(478600001)(40460700003)(47076005)(5660300002)(186003)(966005)(6666004)(9686003)(26005)(16526019)(7416002)(86362001)(40480700001)(82310400005)(356005)(41300700001)(83380400001)(70586007)(70206006)(7636003)(82740400003)(316002)(36860700001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 09:50:05.4964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80834bf5-bac2-45d1-940e-08db0439b268
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4183
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:36:58PM -0800, Tony Nguyen wrote:
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
> Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> Link: https://lore.kernel.org/linux-rdma/68b14b11-d0c7-65c9-4eeb-0487c95e395d@leemhuis.info/
> Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave")
> Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
>  drivers/net/ethernet/intel/ice/ice_main.c | 17 +++++++----------
>  2 files changed, 12 insertions(+), 19 deletions(-)

<...>

> index 5f86e4111fa9..055494dbcce0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -2290,18 +2290,15 @@ static void ice_service_task(struct work_struct *work)
>  		}
>  	}
>  
> -	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
> -		/* Plug aux device per request */
> +	/* Plug aux device per request */
> +	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))

Very interesting pattern. You are not holding any locks while running
ice_service_task() and clear bits before you actually performed requested
operation.

How do you protect from races while testing bits in other places of ice
driver?

Thanks

>  		ice_plug_aux_dev(pf);
>  
> -		/* Mark plugging as done but check whether unplug was
> -		 * requested during ice_plug_aux_dev() call
> -		 * (e.g. from ice_clear_rdma_cap()) and if so then
> -		 * plug aux device.
> -		 */
> -		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
> -			ice_unplug_aux_dev(pf);
> -	}
> +	/* unplug aux dev per request, if an unplug request came in
> +	 * while processing a plug request, this will handle it
> +	 */
> +	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
> +		ice_unplug_aux_dev(pf);
>  
>  	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
>  		struct iidc_event *event;
> -- 
> 2.38.1
> 
