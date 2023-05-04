Return-Path: <netdev+bounces-251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F088D6F6642
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 09:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37D2E1C20FD4
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 07:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8020346B5;
	Thu,  4 May 2023 07:49:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AFB1C3D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 07:49:05 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C595358D;
	Thu,  4 May 2023 00:49:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3TzNdyJdIS+yzwSWtDrh/llPLrHzMzhDF3AZXRam3NU0iJ6mDERXOQg/UxLAth0PlMfI/3WJCwv3mMdw6r0Lxr/APtFIQFHRI5OXht2nrofHcB1T0U9/jTDU1hqEy0BvaVPdK4cigygcsuHEheFKppAkO2HOkNZtRNzIFTjSG750WhIpQDfVALNBZSwzCVzfIszUYLfJndHUrkL2av4zNPniJTt4ZcJ6/v7gE0YHMixMqPpr5KSZHA/jXkOgUQ74DmRK7OYhF6BNkaRykzb9CQ+jo5Y9SrJ2NZaaDkRSR0RZldDklRVSxYF2h+X9hE96N4l8GgDWKGmgUtZ2BpICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNU9Q50rsX7ymvUahQ1ZvVYUX06L6/im6D4IwNPNKaQ=;
 b=KO5WoFhQ2rLrOXsq4dBdleYL4jlGSzXEYn3HxqP9Kx4FkEGXatOifJTLkz8oQTcY/8i3b8Kgl2k5zL3Dwe4xKyl7RyLKuzoZo8UuyjdcmwaBtsxqq41y41wMNtpLtMqqcxIErTZ+EMNEy+dplXwsNthivWV3w4MocSi092vf/AJyMrx4OxOE8Bc9Bd5O13gO8rue9G75zG3Y11K9xOf8vL64N+sFwaMktnvbGVn25IEkvATKoIkISea2xHpyUKBQFqp96N9n03vRQf4FMsTahLwArrYU9fzr0z4aCPPsl1l6p4pPuaIswv909AlWQh5qRi6tUyNtsqEtG3ouZcIyvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNU9Q50rsX7ymvUahQ1ZvVYUX06L6/im6D4IwNPNKaQ=;
 b=ChB+ab2Pg8EDU/DNy0JaXSvXSduSR4Cod6rjSMt3zfNOm9nya1yC2F2ZjQpLzax0J7YkxLxmR9WUBcdWl+Op2nyWlb2eWtRkGTO1Uto7spNZk8DJsXR5CytNhZEBqFdsKjbxgOJ0HlG0SCMLlRQJP+rmSbKDjDraT9QAg/Ti66Z2Jds72baqMKA/txSHKigsHBK4/i6iyWIhmbIKsG43HUvOtoEx1NmKyjae/i9m2LR/n+/9L4/L2KSnauCQODfiz57DSbzSP0s336xLlzctNX987wjo7dNAo2S25+9JsQvULMH2FLGw8WMvoGFjNFtK3HF6NwblIcik0A2fcqW7Gw==
Received: from MW4PR03CA0169.namprd03.prod.outlook.com (2603:10b6:303:8d::24)
 by DM6PR12MB4975.namprd12.prod.outlook.com (2603:10b6:5:1bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Thu, 4 May
 2023 07:48:58 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::3b) by MW4PR03CA0169.outlook.office365.com
 (2603:10b6:303:8d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27 via Frontend
 Transport; Thu, 4 May 2023 07:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.25 via Frontend Transport; Thu, 4 May 2023 07:48:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 00:48:46 -0700
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 00:48:45 -0700
Date: Thu, 4 May 2023 10:48:42 +0300
From: Leon Romanovsky <leonro@nvidia.com>
To: Kamal Heib <kheib@redhat.com>
CC: Stephen Hemminger <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] rdma: Report device protocol
Message-ID: <20230504074842.GR525452@unreal>
References: <20230503210342.66155-1-kheib@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230503210342.66155-1-kheib@redhat.com>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT113:EE_|DM6PR12MB4975:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d99649a-0466-4df4-4697-08db4c7404ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/hA6f0+idBlvN2hiOoA9I847yJ4DsWx4gazKe+5abFNPbvr5fZY9pIlRNN9wZvbJSYF49sVw/QFIs2RJA3/u1NUoZ2FEAweJF/cirkFKiJs50H5ZDeP+JDtZEFVVTtFY/dJyomcthL2/kn5neQwGL6o9kKAJLlmtAImu/xlK8r26a44P70BTUFeyOsx0aWJJr6IRH3s25576eL9GxHYalH6iBbexSJBDRfaMInxCRndAbYsse1Hbsm2Iur5EXcsrlJhIBO2qVa0YNDMyCdnOLAc0ceUFJJ9y8EftRsl/f2iAWBq2wKufV/m+EgJfjYMshDvqUMiizMYKbVttEiCnZ4TKsD7OYZOPxeJ+ieO7QZzEtGS/jBeQ7km/H49tkQmAZAjMAk7bSz6iEzFfC6pGUNwFXRPz/F5sBlgitdOh/L7oN4nTy6YQDotib6BSSvZ1q1udHPTwP7OAhsZM/6yotdHCRrK7To4JYNhjHsJjVfEkquJ0hnzN25uaUR/hKx/TfOT9LRa2C1MJGc98WdKZPIf5h+QKjiEkEYbMC1/mhM5VBGn5qZ/Uysy5z8HlS+3HCgjdo7AJDoaOvl3dilBmTjZvVKu6bDawh1d0tGdKe2BvPcOU+wh1LaL6A2w7OPllRfX6vtvHWP3u6e7VKzQjE3IsCvGTPYvub4yDH+gAEEZmBA1dDrQ908shXlY6qoKojemVALPqfoXb1OW0XR/KDQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(70206006)(2906002)(70586007)(6916009)(316002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(478600001)(54906003)(47076005)(6666004)(40460700003)(336012)(40480700001)(1076003)(26005)(426003)(9686003)(86362001)(16526019)(36860700001)(33656002)(186003)(82310400005)(33716001)(7636003)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 07:48:58.4761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d99649a-0466-4df4-4697-08db4c7404ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4975
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 05:03:42PM -0400, Kamal Heib wrote:
> Add support for reporting the device protocol.
> 
> $ rdma dev
> 11: mlx5_0: node_type ca proto roce fw 12.28.2006
>     node_guid 248a:0703:004b:f094 sys_image_guid 248a:0703:004b:f094
> 12: mlx5_1: node_type ca proto ib fw 12.28.2006
>     node_guid 248a:0703:0049:d4f0 sys_image_guid 248a:0703:0049:d4f0
> 13: mlx5_2: node_type ca proto ib fw 12.28.2006
>     node_guid 248a:0703:0049:d4f1 sys_image_guid 248a:0703:0049:d4f0
> 17: siw0: node_type rnic proto iw node_guid
>     0200:00ff:fe00:0000 sys_image_guid 0200:00ff:fe00:0000
> 
> Signed-off-by: Kamal Heib <kheib@redhat.com>
> ---
>  rdma/dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/rdma/dev.c b/rdma/dev.c
> index c684dde4a56f..04c2a574405c 100644
> --- a/rdma/dev.c
> +++ b/rdma/dev.c
> @@ -189,6 +189,16 @@ static void dev_print_node_type(struct rd *rd, struct nlattr **tb)
>  			   node_str);
>  }
>  
> +static void dev_print_dev_proto(struct rd *rd, struct nlattr **tb)
> +{
> +       const char *str;
> +       if (!tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL])
> +               return;
> +
> +       str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_PROTOCOL]);
> +       print_color_string(PRINT_ANY, COLOR_NONE, "proto", "proto %s ", str);

Please, let's use full word "protocol" and not "proto".

Other than that,
Acked-by: Leon Romanovsky <leonro@nvidia.com>

