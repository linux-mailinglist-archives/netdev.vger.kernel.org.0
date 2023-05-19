Return-Path: <netdev+bounces-3892-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90817096D5
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:54:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63DE11C21129
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6C78C1A;
	Fri, 19 May 2023 11:54:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ED28C17
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:54:49 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C3418C;
	Fri, 19 May 2023 04:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qq9FfEPnuaCQPVgdNH1dWrkcDFTw42EDOwvMoIa2zHIW2hl/YOhGIHQHWeKvxhy1YB5oS35SrqNe+EW1HWmL/qD3VlADXWGAR3duELxtgpf9cjepZYSuVHPXnQRMIy9720EmS6Sr18FuBX1EScSreiAenqayg10cCX76lldG+naE3EVIXdmMfbyDeOGE60fogLtISgCPTTPapFrZWZouTF8VCCJY0A5k4O65RRDhe1RPFSVMn2/C2pC/TJ2WPcB5g/nzcVQf1hxv0BZcMcM9KVxsShFmtlazRywS5ccQJDoE5qBEykq+LkFCIG4qMAXPwPJRBvOjLWL3UK1SqQCHlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AnwNhjhT3L4hDTyQFxthuy8CtAWIL9izByyW9PTY/o=;
 b=E3sKWra4o4Okkvr9D10iaUt9As8AGg1H1uinmoPnR8C4PRCcpi9E/qgbOk2W/IDqDljGYcrVCSPClwkSj7vkwIbx4hJ77GEx4JbRbw1S4YU2egjN9tGkgyG1d3IqdAwZ80LDMDC0e1M4mhbDCXuWoVbGAwgUBm6welwRyIl9lo8fuCJxYpnJbY5OPlW/WB9q52fqCGF2FDAO2MOjXGpRtHzAtc/ii1ckvhoDEBqA7gjz+AgRGJiZlgksLbeOYlxtY6pGuXYi7q2pLQhUfy+L+TqouW5tx3JekYaczLfPQ2B2jEcxQvdy5kWV1CKSJlqMUqyd0GJNGLLi+hROZbZ6NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AnwNhjhT3L4hDTyQFxthuy8CtAWIL9izByyW9PTY/o=;
 b=XbUZocQ5mMLzvbeVAx7XgzbWXr09SPjMIO8sBWmoOy7G7MG/usgtUry1yahQ2DbkSIn5Wu4nsAFFewtldK5bO8Wm391HWwQuguTNssV/iA+pqM5X9bqsVD71S5Lav2bM/ZRAY29js1NZkwClZeZcePAAWkgVkpBPvfzisawFpdk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5285.namprd13.prod.outlook.com (2603:10b6:a03:3d5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 11:54:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:54:43 +0000
Date: Fri, 19 May 2023 13:54:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] iavf: Remove useless else if
Message-ID: <ZGdjfn1anf/DJt1G@corigine.com>
References: <20230519083848.58828-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519083848.58828-1-jiapeng.chong@linux.alibaba.com>
X-ClientProxiedBy: AS4P195CA0007.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5285:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bfbee25-2b2a-4b08-09e6-08db585fd5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qt4Q+wvOQIGinDUN3tBnKAz14TMm7NNlVi9h2AS3cJNrXZXlmLj1wed79M4z7dbTlkj0P522j9tB4r7RqptKH2WTHIWNqQAQ3JKefmT31AuY1FAGLi+KYyT8UfQi2WKH4vlV1FKRdG8FvUOuO6dA4w96ydLRc4FTtmMEuS0ek+teCzz3E2KLKdc+Odr9otSieYZBOd+FOdTKKkkpz2PTBozLgj9xNKdZ3iocx+nj2igO9ZxMc517rdpM9p2oy3PS5DLujpmtcOj5hlzP8kY6LSHVr+tEnyWbM8vgdaVxorogY3VllVGK400drc0boN6apm6BU9j9FlrB6o9ZTU7IDkHNmE96atj8jl356ZqPck0jBQMTPyxSvAHuU0yqgSUoOevIIRXhL71V5CtBiDGPJFEJqrB+HOQfzLh53U492N9+GRmxCMlE1PJMeQWIQV7fCEGKtDl8zQZIYKzXHqGwdWmhzejf6THwu5vH7ExzwKrkpJ35f00vNM5iJpZAPgEvVMSVOCsY2TV5Is2JBW6lrjgASWIXJnKg2HYIyy4/zYaHPsDQ+gr/E0ayCyQz/Qa7WyUihh80wYsw+87Udo5IVErUEqUCIdGXuReONNCprLQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(451199021)(966005)(6486002)(6666004)(478600001)(83380400001)(2616005)(6512007)(6506007)(186003)(2906002)(5660300002)(44832011)(8936002)(8676002)(7416002)(36756003)(6916009)(4326008)(38100700002)(66476007)(316002)(66556008)(66946007)(86362001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/S5fWu/iwnlwVsTFmx4GEPXOebGsB012diTMOOMj/clZXx4aIHFc8Ind1cbg?=
 =?us-ascii?Q?BA6eNWVTBV//PnPnmUBloOfRH+nymkjtuaLrwmE9iFk2Bx/2BWcImhqgc17W?=
 =?us-ascii?Q?fVVjWacSujlf4p2G+xk++anN1tfFdqv+ydUGla5C61NvLyd6NnMRwgZORggd?=
 =?us-ascii?Q?NmqWUOwADpUeA7rUi5j08RvCCWNBytDK9uqeQoRET0N3r99fhGM9y1BN/C70?=
 =?us-ascii?Q?4DEsuRFebcxDfd6x0PQVy7pBXGr4vdzhsm3lTlHx3buOl4C6dysyT67Piahd?=
 =?us-ascii?Q?yPDdzOq7X9FBx+zPyqo1lIeBNcJQSdZ0+sIF3KpE79DCuRv5b/8gBsU3Ce1P?=
 =?us-ascii?Q?4xLWFocsKtXOrRJAN+FX+A1Z2tSHGE9dga08I+9idGqdvZR++7obJ8a6rdHM?=
 =?us-ascii?Q?MEZoReeilVTtlJHWi9m4YmroLvFP3Zr9x92NGtnSfAvFxr6EXGu4NEDs7Kai?=
 =?us-ascii?Q?C4dS/LCv5gC6ak1L/M+URzPiRYQjCKtBSENslo710t1qF5BoCthXPruF2sIb?=
 =?us-ascii?Q?PKhEgyBnVNxF2uszYgsrZxJQFN+oFPJNKGBHppOjp1SL5CqE0/e7PFAYFc1B?=
 =?us-ascii?Q?3lkSkEJKQMCzBR5qUor97zbPMXR8mq6mxbDO5Tmr26mpocs4vmjfsiAYWWGo?=
 =?us-ascii?Q?cnFAypAEYP3H8GTyXru4MouwU9/eRp/0id2XtMhJ2jzC6Sduvi5JsLvPm3I3?=
 =?us-ascii?Q?MhnLtiN0biwb3voGcIuQr6eukwCG/ByN7YowpLpg/+3upNLfKL5pWz5ew4bD?=
 =?us-ascii?Q?B2c493V4aclx4RrefXaS+8WbeeZA5yflNMi6sUj1wp8fdGb9CwpHJU8XJoFI?=
 =?us-ascii?Q?oUJYTS+xenZm4ILhNO6T4JcY3stPCiN9FkK8YHYUHBOL2Q/gDtfQhJH4+9f9?=
 =?us-ascii?Q?ySVUaQURu+4hwUMp+qj8HLMW1VnAYpjbdWdLTCxyNj1Atb8PD8pxU/2fkXpv?=
 =?us-ascii?Q?w7eIEdTqO1D8Fj207Q1vSkwMK2/a39FifDJtGmVOGt7LZ9dPELAsKnWRWME9?=
 =?us-ascii?Q?fIkVh07vXVvOdzrvGRAfCQa80+ZMbyIG0/bjN/01tgoKBTYBPmb5qRg3e1AK?=
 =?us-ascii?Q?cQ/lwXzssMl8n2GBjthOI4R8RjoJjWRBQQqF/pKFy7HlCqFyFB6KvpzIkN2o?=
 =?us-ascii?Q?yFnrsFsmtw9/8JCq5cuxqoTb4Sjt2ago474KwLX6j+Bbjo54/YVhgbwwbh01?=
 =?us-ascii?Q?ah8DXj+4XRsyKfy8iniz8nJG0lQ6tTm57sxj7xQ+buhdqxw+zFWG4XETs38E?=
 =?us-ascii?Q?1CEq2Ls7FUkJYezHpMt1M1JxkUAVBZ5Pwgrbxbu7vkl1APESIZUiQF4C6Bec?=
 =?us-ascii?Q?w93TkYBJccja154aXmt8wQY3J94sgQ06GdwoGCY3GulpCGzGVY258lqwPyjj?=
 =?us-ascii?Q?sw2U9krA23VYIsoBX4D9vLZg5Xm/lDQyxQNcFzwvDRQifZxmTLgWXCnCGe2O?=
 =?us-ascii?Q?nnxJHruCE5xNTPu4dp6HppjH2l4eg5Sn5M4rwwojqEPMpW+Ije5j0jMKyIQ/?=
 =?us-ascii?Q?yGYMgF7tpwsemp3qspLVc/MzPo4E2J+BfpWx1qj3x8Hz9VCu18DhkGu8EzCH?=
 =?us-ascii?Q?h5Un8kRgGtahgnv+LYs7d0W8hFFCKxdjR7UC7JJhxXm22Lgnj9rFS5Rl6Lbu?=
 =?us-ascii?Q?hxUSzPPh8T74rXR3IvZ07nVHwRbRUWA1SaT5/L+Hsaab0yGO+ZT9v59urRGZ?=
 =?us-ascii?Q?8YQeGA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfbee25-2b2a-4b08-09e6-08db585fd5c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:54:43.5559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOkr+t4A6Dg+tdZ1YN8XjzKCLGXrnH5YR1YtqxD2FYlDzkGsFUsiMbH5IoICzGbfLxy0P7IRnhqGbqv+t8ZYtr8REl4rq//TT/rCGSQBUBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5285
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 04:38:48PM +0800, Jiapeng Chong wrote:
> The assignment of the else and if branches is the same, so the if else
> here is redundant, so we remove it.
> 
> ./drivers/net/ethernet/intel/iavf/iavf_main.c:2203:6-8: WARNING: possible condition with no effect (if == else).
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=5255
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

nit: This should be targeted at net-next.

     Subject: [PATCH net-next] ...

> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 2de4baff4c20..cf8538cebfe0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -2200,8 +2200,6 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
>  		vlan_ethertype = ETH_P_8021Q;
>  	else if (prev_features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))
>  		vlan_ethertype = ETH_P_8021AD;
> -	else if (prev_features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX))
> -		vlan_ethertype = ETH_P_8021Q;

I agree that the assignment is the same.
But the current arrangement does very obviously handle
NETIF_F_HW_VLAN_CTAG_TX, whereas in the new arrangement
it's unclear if it is handled or forgotten.

Perhaps a comment is warranted here?
Something like this?

>  	else

		/* This covers both the default and the
		 * (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX case.
		 */

>  		vlan_ethertype = ETH_P_8021Q;
>  
> -- 
> 2.20.1.7.g153144c
> 
> 

