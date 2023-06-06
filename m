Return-Path: <netdev+bounces-8547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15020724831
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:48:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B1171C20A48
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EF030B71;
	Tue,  6 Jun 2023 15:48:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E64637B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:48:54 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C337139;
	Tue,  6 Jun 2023 08:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJyY0jZCx061+3UAC/9jU2Z6wId75A5d2vDyYBKrctgThI35J44PnEiG6SH/5Yb1ovFXd9QbjPZsvi3SoBzmLlHhE5o89xMXvD0njmo4ewzt27hpONt0e/JyaRbwrs1vc8MGrNFhucqt1cIJ/tPHNsOg9bp571pn55J4XO//mo57w2iuriS3Ej2e2rUPWs/QwnpjU4OFJdGw2mZ69Q8EXePP2SIOJ4pMSARWxzmkqlc5KCBF+wWgSoiKTNnJ8L29Qv+dCWChRngqUDgVcTOCwoHrPRnI70SYqMlV4WFJ0cmWjj8vePKj1pg3qWZc/Ah8NiTHXbGM+GMU63S3W246Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjnQEu87vp8IEY99WI1RsT8zLcUM9fxWxbGWFkwANi0=;
 b=KoQCZCbrztxfQ4JxolxS3EZ59KYTmlrXe34zc9t0kvlJGmBqjSixIl06dAKbz5Mabvu9x/bAIHUppteuz8ZBpUpz21fo0O+c1SI/lNRBAiHeqR0z6zY6UxZAXlWEjYuY9bZ/WCyAJb0kqHss8R+QUY7efpesVXjHOX/Y01bTRDKsL/8ScXJCVTWILFGC+RrXOF9GZVL/Rq0NAPwtpcatEWSA0R0Nbn3GyYgcLF0gLVRMO+yP3NkPcywyGe88PRiHbenCV+Fzj8x8IJAO9xnsjbsAnUKU3gTrY9ccZkSJYfLDY1H4+U8q04ijvIhJPYc4QODF0xHZgp5nPEYRkpSKIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjnQEu87vp8IEY99WI1RsT8zLcUM9fxWxbGWFkwANi0=;
 b=F5NLSQUb5KeGgQHpLhmnWNf7/DQVt55mW21kJN6gwRnyFMIhbcWEwXbUQ011PJnSy+bULm9XKy3rx7r7deo3JPQLs21fzFJehpi3Ac6FKAHV0Dz/DmKPCT1Nez/MZNVW6PIb9m7obeR+kHIN/22C+Ip4akSjcOCQFy+Uy5LEqKGVGFmYMQQUwGj0pNSlH6w+Op33fsjDv8DDgaRH5sICOyRJmPWsbkMmw2syvqBUp3fSV8pKDHejfPSzMw2ZGOlCpDl2pCfUIjSKi26isP7XG+9j8x2B6Yxn952BHnszNKGizih4QbaHhQwAJBjuAf8B60KkcoQKJ20mylhifmPMOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5926.namprd12.prod.outlook.com (2603:10b6:510:1d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 15:48:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 15:48:48 +0000
Date: Tue, 6 Jun 2023 12:48:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Chuck Lever <cel@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, linux-rdma@vger.kernel.org,
	BMT@zurich.ibm.com, tom@talpey.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Message-ID: <ZH9VXSUeOHFnvalg@nvidia.com>
References: <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: SJ0P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: 04591649-ff81-4833-ca23-08db66a5847e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eCjrKiasKS+UjeOg9YNpOvhjO62uW0qhiUsJQqfT7/PnURTv+rvJBtcbhSUOguP9/DsQFUR725+n7kpgxZSN+Wy1svrASYRpJIJhd8a5N4UGB9CUOHjfYYPGJKtBgAdrA5xUvhGkJjk2tPS69439P3uMMQ/MFvoXtbzIXFsJunupF7Agol6zBur+9W5kpONL7FtNfM2iM8i0s0qzReZLU3ousY3/Y7emKBNV7wigPjpZSn9oC4+BZMrU9NtDRi8iIumfyQVHv7dZrP2X8YhzWei96Q68VHNLiWncbSQRR2ZOqZD9AcEOilUMIB+yGc1Qe9cBopOtutXbg77+ro3s4QjGiF0BaT+g4+JIYnMGOX/L/YrmYdcgrY3Pq/oB2dvUlpPTtwhoHOUWpZfac71UGwpVQbgoxoSJ2gc+uUvZza/deur2tZTMa1kQ4It0Xc7VpCxjFinPVlJOLiTzbbsdF8JNT44/Dl4K0aDzzoKLfUMIFu29wVY4L92S87BegZvZYADAskKK7wHi6GyvELma/knDfoGEB1JvGuo/KJAB8cNHzdPl/hptIrDRmYBhwhiP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199021)(478600001)(2906002)(26005)(36756003)(6486002)(6666004)(2616005)(83380400001)(38100700002)(86362001)(6506007)(186003)(6512007)(316002)(41300700001)(8676002)(8936002)(66946007)(66476007)(66556008)(4326008)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Q9yeCony71/+s80SsGWiqUlcw6uZEIuOz015WvPwnWhH8opgjqMGcWsccyM?=
 =?us-ascii?Q?BBpo1QUZFzTK2VCdc1kShAhAlFyJzP47rsOCSc1NJoAoWP5yNJpbD55XcVU6?=
 =?us-ascii?Q?STIZuEWywqigpxnpsvQYQ5L+D57wfzc4KYQ4jxHuwUBxxHO3ZJ4IlvWJ0mGB?=
 =?us-ascii?Q?iVu0wama5GXA4kX9NxKMgcoC9waK0o7+PGrdnadVRzoVaQfpZ4FuxZ4aLkEw?=
 =?us-ascii?Q?05g/Ov1HXeOgWBqlVm0ZgeYMVuIbSAr2XC5pYstu173MYSSAHXEsv5+KhuvG?=
 =?us-ascii?Q?dt0zhs2g56B9TxbKtqZeGM70Q0WOhf/bGz5QmcMPgNudbqwt9D6z/jDIMW2b?=
 =?us-ascii?Q?xlT75MEVDZz2jAtmFhTR6i48oRlWL7qfZr6CJ3unfnBTbQLsTE4ffqkSHMLa?=
 =?us-ascii?Q?hqhcLJSGQ5u2G/U8Pj3katnfYMh2bGmvNTv05b6zrofX87GQBbZU/o/lU5s7?=
 =?us-ascii?Q?LoF4jXAJXTNHYCr5peLcrUi4oRTo+dHa+vkPhtihk/3i7sCM4NY2pe5EYjBF?=
 =?us-ascii?Q?xDR3uptrzIc5CidCc8M2R8/nVi7ATvqKDX6l5O8N39njqM59fjOwXx/6xGcl?=
 =?us-ascii?Q?JyQWE454jY4FmYFg/2rhqKePOLSgVplwhQFf7ml4kyORQo+gJsmcpXsykXDe?=
 =?us-ascii?Q?Jj1snnN79jFLDvLghNCdvJanusVy5pWHqT4tUbQ2WSU0R/WxTTxLXlZufip2?=
 =?us-ascii?Q?QvOv9z/BqUSoeLTlJXcN/kxs8L25KFUSV/qWZw6CI7a69qV/PVa0o0ngLrY+?=
 =?us-ascii?Q?9gRgFz/ONea7osWWBvgGhOst7A1llRE74ji13wrk4RuBYkLmskTyTehYlJH6?=
 =?us-ascii?Q?8atevs3ynVPDnXKorGhbui+l0NUKEOZqZFbamVtW35QRpjWGYsh7DSOM3rlX?=
 =?us-ascii?Q?NNRsBhINZbH6hxgqftIuDzPEYBsntTTp0mvKrwi4wP6mKvJgTw/9PAwuulWT?=
 =?us-ascii?Q?qrZm8gcJGAm1e9A2N4g9/dU5MaH4HC8+P1SI5lXWapEdD8iSvHhFfqmGmmdb?=
 =?us-ascii?Q?BGhidz5m4fVTnR4Jg9sEs2fq/NjxoK9oTUyH3z7+YtMtIH0GNH15PD/MZaNz?=
 =?us-ascii?Q?5y8bnU+G7TQHHSakxNWp3vTTfQSl5sJrmSueuFOJ14WipuaL1yTx4kUN/9LE?=
 =?us-ascii?Q?18GrupubK396jJxZj4AcNDD5B+y/uUcszqfwJF38eRIUswzRAaToYvimbVBq?=
 =?us-ascii?Q?cXCh+A5tM2mZLbRq1z1a5RL1/0IYkFhJvNpEg4jaVUvZhR6p7yEJvYtlyrZu?=
 =?us-ascii?Q?6NLcRzcwfJqgkzfqDxlPJVNe987NubPzORTlwwgi2ISf5/ZL5Lwc+YoX+Sk+?=
 =?us-ascii?Q?LKACFPZy9QdMPnrB9C4Tm+ajZvdhxN7uv4ej9PJpR49A849RAMlfmslBXSCW?=
 =?us-ascii?Q?u8qV37fAMzPXJR5919w0+CvP79MqXujNeVAZNQBSLqkmlMidqXWVFwEGuhdj?=
 =?us-ascii?Q?fH+9cTsxc4UwtVi44kYTnGOH4kizbzFwXb7pBkD2kP0Pt/9iGSuf+3YsuY40?=
 =?us-ascii?Q?iqobBOL6usknG6GdGpUliG2HjMScQJaHmR3oLpOfGNIg/b6ilEfhTCiFE6uP?=
 =?us-ascii?Q?0S9y/9EOJ/oN57yLjEK41/IMRJknHfpobme6Q9yF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04591649-ff81-4833-ca23-08db66a5847e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:48:48.3093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XhxiXL3Sska0Ojz9Cu6WbP+NvyV8XGk75oPLe5EAPvXo/jWYtzSGmtoaGx52Ikg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5926
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 03:24:30PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> We would like to enable the use of siw on top of a VPN that is
> constructed and managed via a tun device. That hasn't worked up
> until now because ARPHRD_NONE devices (such as tun devices) have
> no GID for the RDMA/core to look up.
> 
> But it turns out that the egress device has already been picked for
> us. addr_handler() just has to do the right thing with it.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  drivers/infiniband/core/cma.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 56e568fcd32b..3351dc5afa17 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 port,
>  		ndev = dev_get_by_index(dev_addr->net, bound_if_index);
>  		if (!ndev)
>  			return ERR_PTR(-ENODEV);
> +	} else if (dev_type == ARPHRD_NONE) {
> +		sgid_attr = rdma_get_gid_attr(device, port, 0);

It seems believable, should it be locked to iwarp devices?

More broadly, should iwarp devices just always do this and skip all
the rest of it?

I think it also has to check that the returned netdev in the sgid_attr
matches the egress netdev selected?

Jason

