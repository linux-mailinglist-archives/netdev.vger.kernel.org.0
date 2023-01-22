Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33EA676CE9
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 13:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjAVMha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 07:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjAVMh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 07:37:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31105FC9
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 04:37:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iiYmaZMm9KkRAP4kcdjIM9fPuCKB0ioT7Fmq2v3mlkrz89LEJNfHCnTC/wfEM41fw/i7dMddTPCw3TlqgvuAghmzx+uUUBof9flce0E0jl/Hgh7N12cp1+8FfHWuNzAV4NZWCr+U/v08Ov8WZqTa3VTOcqviFB2nyh9wQA4ZQUAF5vsNJ1gY/UauRkSGbXRz2TfTN+x7uLAI8h9awO4CE49+78mtHXidmQ5hw+Fr+6ufuOeI0oWI5cjX2biLz2s4TTW11IzRzsUx/gxD4sXodpSQoRfpAMUMXIlPfERwd6+iUeG7FJzBwcjMFPFaTdi7Bxgfxu614/DrN0eQr/86IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02MBAjMfhGsZkmhHl2FaMAxBFHG8ifa1RaCHNix/lsI=;
 b=bE5ny9V80jKML13U56yJvIeP6n07nhmDuLX/GeRzYxRlClFJQwSgAA3okLVJBUBUItucvi5oG77mxPvpkw013zsS1PnGUYfRLwGp5oKCZ6pvpDHBk4QfLhgu5FQvuoop2MZEiVJEQwJW6ZReh9ronc3Cb1MFeFsmf7n8mDNZcETLyTRTeXh+aF//FZNHOWB62iVDO5ojKMN954wN5k7QTp4xsKg2kIdoLrTqdQgRtF9ocu3FIU2YaYQwO3fOyFHX7jdlzYci5n3G5QkIezY2LbiBkP2cIqu7i+s1MCiw3XwVZc5d7lUN7rPCPk75KYq3c/ffdwCaZiIg7q7HC0TDQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02MBAjMfhGsZkmhHl2FaMAxBFHG8ifa1RaCHNix/lsI=;
 b=pEh5UjLQqz2PFgDFrSHuxCYw0lKVuUFhn+arYYAsiAVlO+hkW7qqWu5NdqW7FG5vt5zCPSAUeZZkJ/E5SrE+dylc+Q6MZ/ao1PmN2RrMnIv+i34r/WlAn6A8kiXBB26bJCNNb0bfjIytZKZgXQ7AMQgy8E5VFOHoJMPHAk830iRpMYat16QaosJvn+LrrjaaJ71D7YVahGYpYZPdnMnIj1F5cPt5mGRUkvhRuAQ2EOcJRxYRMmOEk3utS1pxtyfiG2cxHzQ1XVvxwmLNzZGGyPzGKA8OO8ifofl+Hy4JJGugCygap0qBQDuDp9iV+c+AiRRvC9cdq6E1AP9zmh4T3Q==
Received: from BN0PR04CA0134.namprd04.prod.outlook.com (2603:10b6:408:ed::19)
 by CH2PR12MB5514.namprd12.prod.outlook.com (2603:10b6:610:62::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Sun, 22 Jan
 2023 12:37:27 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::bb) by BN0PR04CA0134.outlook.office365.com
 (2603:10b6:408:ed::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Sun, 22 Jan 2023 12:37:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 12:37:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 04:37:13 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 04:37:12 -0800
Date:   Sun, 22 Jan 2023 14:37:09 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, Dave Ertman <david.m.ertman@intel.com>,
        <netdev@vger.kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net v3 1/2] ice: Prevent set_channel from changing queues
 while RDMA active
Message-ID: <Y80t9Q8699GV8ejm@unreal>
References: <20230120211231.431147-1-anthony.l.nguyen@intel.com>
 <20230120211231.431147-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120211231.431147-2-anthony.l.nguyen@intel.com>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|CH2PR12MB5514:EE_
X-MS-Office365-Filtering-Correlation-Id: 304adc8c-c7e6-4d91-b281-08dafc756b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TcjiG0Xu72aSd9Z1T1ZDfaw+PR+z1U6MwsQwddYZ/B8giUFO/yJ0LR9JhIaX/cLpegX0aslieveiBeGLt+yhj4yaFNvDyXsPTsRREbquGqLvdxjfEdLJSKTNYzk1cJ1SeQJyACGYeuCNjQ5/YXJcYpAF5VznNr4vHH63rEy9lbUfH00rybXdo8+LPKxsd727R2RDjzjUZUGLm/8NuSIvzTmnIfITJnaWGwXYlMVmqcMhjMZxFJzr5bzOFn/Z+B1AtP2sCZDQ7cHGm31wwegQ2rEqseDp70rZEpmUmuUq84A5F2PfasRZH0YuX+UAQrSbhz7lCQdPdWoyGHvHGRgAHm2dk753sxqpc/7aiZiP8qi8lBqWprMCwd28g54He0FjGnDgK6yk1FmTN2/atxhbLaSLo99LEphnwZfXH5BqjZR56HM/g/7/2FMkE0ci0ZQNQJ7JSC3l6uIavXHxMcEEMIRehoSDS/nHHBx1rK/SfiTmY21XN3n6HAUPXDg3IEIfPtjsRrqZOCMQ6bkeo69eRvyQsz/BktwcarspUkurnw1I0aQwh0hw3nhFP2LLHFte7BdN7hy00J5A77IdYHiRLisv+w29yvvih3TT/1qRgE0EmtWvDJJpFM1fgUZEqz4oZwutn9CRREO2Ri8V5hMzZz0xqQUDAEUEEI+U2G0uFNNPICq2DX1zDoFROkrPs9TVMpLPjEVoj21ARnoWV/liQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(356005)(86362001)(8676002)(70206006)(6916009)(4326008)(40480700001)(70586007)(5660300002)(2906002)(8936002)(7636003)(82740400003)(36860700001)(316002)(478600001)(6666004)(426003)(47076005)(54906003)(40460700003)(82310400005)(41300700001)(33716001)(83380400001)(16526019)(9686003)(186003)(336012)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 12:37:26.4107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 304adc8c-c7e6-4d91-b281-08dafc756b31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5514
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 01:12:30PM -0800, Tony Nguyen wrote:
> From: Dave Ertman <david.m.ertman@intel.com>
> 
> The PF controls the set of queues that the RDMA auxiliary_driver requests
> resources from.  The set_channel command will alter that pool and trigger a
> reconfiguration of the VSI, which breaks RDMA functionality.
> 
> Prevent set_channel from executing when RDMA driver bound to auxiliary
> device.
> 
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Co-developed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index 4191994d8f3a..16006eedfceb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -3705,6 +3705,14 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
>  		return -EINVAL;
>  	}
>  
> +	mutex_lock(&pf->adev_mutex);
> +	if (pf->adev && pf->adev->dev.driver) {

adev_mutex protects pf->adev, but not .driver, isn't it?

> +		netdev_err(dev, "Cannot change channels when RDMA is active\n");
> +		mutex_unlock(&pf->adev_mutex);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&pf->adev_mutex);
> +
>  	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
>  
>  	if (!netif_is_rxfh_configured(dev))
> -- 
> 2.38.1
> 
