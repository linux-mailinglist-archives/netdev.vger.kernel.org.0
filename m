Return-Path: <netdev+bounces-9471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60581729579
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA4492818BE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A69212B9A;
	Fri,  9 Jun 2023 09:37:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3112B6C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:37:52 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3184B558A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dwjtb7XPBnO4bAGpt3N1CU3z/KjdjkiddG6MXgoLqXxPObVbll4vFQHNKgK9lksOjDMgyxd9i+zgNeQxnN32IwZmKhqncG0t3bxk84X/fIEkngi3uRY9SS+FETmgzfR7MjfqY3nVAQUSluHvBZt45BuUby5vR5Gb5CSiivVM2yjcyhm22AmQy+w/MlYs5c/J6Ou7pGRuO6z1mGYKx0XDRKFJ6gepRHuk+kZOnSHCSbEes4dskZ9qQjD19UiKpwJkO6Xixj+Y/g0x5o4m+4ez0SSO1drRmymf6pORSawQqJBL3PdTvuP+Nv3iDg3WS7W83lGHEDSHKH/eGPUU5zxr0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwPfKK271yqYCR0KbAtAojVWQ/bxC5KEEL0HtLySqhQ=;
 b=R+wsI7K9kO0KhRJNLsbxF8BSfkpBBMaijYpldLjaOFnzuD1F6R1wxNwIB6vQvFBHNuWlYObitA4uPP/O6XWuD23oe6VOdhStzCHlQJYykbVw2G+QkspwbmDT53BV+MZW5rGq163xx2ij1WpNd4F73cZURsAfSIR8JEssKFawtm5hpWJx68khz/VrcKSg69DutFl+GFqbKqULL3qAtdZiqbJdnf1X1DiU7Bp2Jj8ifW07Trz3Xj/yph6Cia7Xs1MihNpgzlBLvVNA6Idnp2yu8N7FxrVkODzKgJGScs2DI5TWU2reqA/FKQPu7/wRVHkAtFyguCoTfF2K54HOoH+LKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwPfKK271yqYCR0KbAtAojVWQ/bxC5KEEL0HtLySqhQ=;
 b=pQq8uQcLyjj+r2/cHYwJn8vbVJwchsm4CKOipo09RLXmorUfTRo9sMJJE1XOdBlr4qNBQzAh2uRvBnQaUi4yLCXA2vuYnMxpiety70B+VErFuQ1H/aIsOwz0PQRZC8lrZeQcSuAttSqpni+WyHkJohUyNtlM+LdbIBcaKxVcBqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5078.namprd13.prod.outlook.com (2603:10b6:8:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 09:36:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:36:41 +0000
Date: Fri, 9 Jun 2023 11:36:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH v2 net-next 4/6] sfc: MAE functions to
 create/update/delete encap headers
Message-ID: <ZILyopa3kC9a07Oh@corigine.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <ec28374eb94989fba657207c6373126bc25cc5b7.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec28374eb94989fba657207c6373126bc25cc5b7.1686240142.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM8P191CA0010.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: d6a1fb14-28a8-4b1e-6647-08db68cd07b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/DDjSEFy7Oa4wf7VNhG4xfbiZp+Qlt2ldLAHt+llvAgsSD1thmwUzICPrX8purXZOva0nqkppYMBOOQs+7s0vkyYD2pSHQG8C7njt1a8uljV+oYwfG3EFGXkscKWm4hSZalqAIfPzua/DgauuJ4zaqljemN1/HmZ/zTImlpNgf8pP91wOFdYhZxvASjZyUXzWGBQSOrmNWuqEpVcWlr6pefHn1aGZRq3DU5RqusFFuehoT1d9/ymqkF43eG7umm1NQIM7XqSHlK74qlQzoXZHJApIjI4FZz/e8vkaG+0HrZ8PITV1RsiKG9a6UE2f1jLRW8pEfY0S8p5CMNCXUS8sPeSII2lyNajDCIgsH0LskXyqm2va8b8Abd4a8Hp5dlKfvSgTR/pLqMDwRlgGUSX1rSgCrcCXCI3XsAt3N9TTizyTWL2zCu9qgwoCP4P0RLVE9cd70WUZOLzit8M+znL19KiJekFzLVJiCpnWURi8MT2jYAnipJM4W+na+WJCnHOJN4DirxA2b1H4JlY+E765s8sZPGA9EBt4NXs4w/afn9tVcbM+m8J5bjctodP4WneA+lCq4aXXoPVc3pQdXEVU2HnXHa7z8aA/EWVOH6T3y8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(366004)(346002)(451199021)(8936002)(8676002)(7416002)(44832011)(5660300002)(6666004)(4326008)(66476007)(66556008)(66946007)(38100700002)(6916009)(316002)(6486002)(36756003)(41300700001)(83380400001)(86362001)(478600001)(54906003)(2616005)(186003)(4744005)(6506007)(6512007)(15650500001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+gxM/KN2ISCfQwtPeCtj2dQvlEotwDAcJzq5bUDRmLkp6MN5VQtC3hQNq5ft?=
 =?us-ascii?Q?xSAZvCMGM6gmM91Z+X6wzLPS8mwKJdhqwIEYoWhfs5OY/QTw6zwR6JZgXF8c?=
 =?us-ascii?Q?uJhKy7I86ZjtWXL/jEJKKNg1vhnMf+DowAWLahV8c2U1VZNXUvWDelZ5nA5D?=
 =?us-ascii?Q?Bj8m8ysKfEN10r/Xht+9nIY7HC9a0D+snY1YjOMJKDYiklxfWpUBpWu5Ws5S?=
 =?us-ascii?Q?O8+DO49P0XH9UabaSm2PoiIF0TKp9q+TdD5V3LzTptO/qQffRRb80f3REBt/?=
 =?us-ascii?Q?1r9Mi7TZEzYHZfHkGeiHw3iuCIvfB7K8M9dEVqbZ0JlWPIFddB+CeEc1yNkb?=
 =?us-ascii?Q?O5IF08VdOsohgswVScIlkhCFO7wtVPo1C7JsdW/pUu5DbX6vMfALA8hIr0CI?=
 =?us-ascii?Q?cN6UoRx/gp3+75NxV1bNYoKzhKvvjnTOkRqAqzyKW0oG+SNSwhS5AYMgGNK4?=
 =?us-ascii?Q?+pmAgq3EF972kwxEJNkCVm3kr4GYLxv5F81fG9u14M/dQCo8n36O5WbLfgTT?=
 =?us-ascii?Q?ctmcRBW+Rz7oupiK+FoYRz7ID/VhDOPokz4X4Js67/e8y437fbdGj9ka4tRL?=
 =?us-ascii?Q?uJIAk3Jzh6gQfb8l3Lboio/0cCgCWrU8630Hb8YaqYE9UgL0u2ndn5O1ve4u?=
 =?us-ascii?Q?7qLcqDkOx3zn8/iihuX4otTE8wcW23Qnxznyt2RpIdiWZo/EvLZPe6amoXIu?=
 =?us-ascii?Q?NPLVy6SD2WUF97N3E5QGjRs8p1P2PMIx495KeogJccyWxGhf/Rj+3W7cDyOo?=
 =?us-ascii?Q?Bmwl32SwVkx+q/RIY/HLJgUkDIf7r9wSfNMwwbzNUC9m8K4rmf1hd8fUZQdx?=
 =?us-ascii?Q?scc3ucWJPrqEEzAdN6LjGSJPQvYYsf0epa7CjLPVGJ7WZfJurBgrDho/Eq9B?=
 =?us-ascii?Q?xtaFfI2YNiWy3ksTP3uaKBGIcF5uuLNkpkPtGKBwCorEVMWKMRrP733s21Yn?=
 =?us-ascii?Q?8HSWwis6qedQEjuH5d6gdiZXSMlV9LSxwkeE4TvtaxvAE03C9ZZKU3X32L4y?=
 =?us-ascii?Q?V2UuTOYLC4GBvO3FgeAHC5mNsvmprUfH5wm/VUsS85LQNG9WKr11Jdn44kfk?=
 =?us-ascii?Q?YR+LtV+UHth4dvJnv+lAIJEbGCONAl9UrhhhpMoU1qNWpKjMoyJwIekyZZpk?=
 =?us-ascii?Q?rmmiUlAd3k64wnHaIO/b+LZbLSbuF+GEMuOa25pybHoaUu7Rir6O5gQKSIXr?=
 =?us-ascii?Q?y9E/316HvBY0F5QJE+0hFHL/+eHQbMTR0dlQx/Tn4VVbqr2YmhaUMCYAQsN8?=
 =?us-ascii?Q?GJUIdCgmQWWI4nSjggQ7JLAXMxq1YYtMJtQHoOCoRIOYth+DYtRYfJ/4u4tG?=
 =?us-ascii?Q?4TuwBP2cST3gspiI/JPf2sXU5H2V3Ci7NWejy675UtILilD8AMfIRAlH90j4?=
 =?us-ascii?Q?GaTx+QhczO0TQhJgEy9x7qAAByhLbJmDmoHBpSbHvaQLVu5cjDvJoOcv/idE?=
 =?us-ascii?Q?thr1r8tnOBBs9pJpIuHbtVsxD5Hv8vjSyN68VOgoOZgQVFa4ZRQuzJ+9LQs8?=
 =?us-ascii?Q?AtmfGa5geq2HdG/A2GQhDHtz1vZHX0X+uMz1o6eAbKyFcZ7G+2GXC6vYnaI9?=
 =?us-ascii?Q?jelz84RVQaBOiH8H9f7X7823kXFbRKXjmBnsNK+vFXcqotBcY3rXFYT1+jjx?=
 =?us-ascii?Q?OJEUqfjoKuq2jzaVqqgxTISG0HoajXFzQbtvZhXjt4pkoR8+DIu5Tuvjrm65?=
 =?us-ascii?Q?BDQmlA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a1fb14-28a8-4b1e-6647-08db68cd07b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:36:41.0829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nv/dXKPU0xKZV7lAf/sgLwqEmriUEJ/4mjE4X/Ang71NWxTJzCWMjMUfrLAiqPZyk3DQdEkHolOJt33yr8eq4glVlTJNLTaYC4/w1hP0eY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5078
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:42:33PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Besides the raw header data, also pass the tunnel type, so that the
>  hardware knows it needs to update the IP Total Length and UDP Length
>  fields (and corresponding checksums) for each packet.
> Also, populate the ENCAP_HEADER_ID field in efx_mae_alloc_action_set()
>  with the fw_id returned from efx_mae_allocate_encap_md().
> 
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


