Return-Path: <netdev+bounces-8193-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C41027230F9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78DB528140D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BD7261C5;
	Mon,  5 Jun 2023 20:17:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF2124E9D;
	Mon,  5 Jun 2023 20:17:32 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2108.outbound.protection.outlook.com [40.107.237.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34900E5D;
	Mon,  5 Jun 2023 13:17:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9v8FKDhyZn4wh1isn5ho0B8UxG1ULntF7lxFyV2rKZ9/s/sbcOIKW5L9o3ZH0vj/f5lryjlhxc8YHP0ZQU+WO+74OXVkyOg6eNf19zMEpn/0Ib8A2i+uzpNL1qG2UeIMnbKB8NaYZyIDskEyLmOKXQzk669tCMLJPuEMmdBjRBTl6TLa/7klxjUSKrnKKM5ETanpaaMqn4cHd/aP7xq1F/Hm7IFUQacdit0UxWwl2EK32sNulLfR31W8Iwpj2e8PCCh6VFQLoGca7UIMmVolVuCuYANJte3srbnpw/GCDSnssN0j8W9j4tb2kUQhSU/cBJhDf4Ge+1civaCCMDPOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8KGDSzYEFGLEqGlp44InKxkhyLJlTPqpuaFJr7v9pF8=;
 b=RU9PjUOdMUgf1u6IG+VFkVbQ+wu2TWbSXrAlxUTqGe+2TCZAUPdSdZpn72j4oV+yeiErRKEZ3ymxC0bYqGokyVMx/BUmb5ncEIv13oCTZVsfIex26vRqcnjFOnIPh05D4ZP/Q2qOjQ/gcqZdc38jNFOrsPBffN98kRpj5l0PO8d+aFy9DoGeMSWAvbX6urr/7MGnYuxNycLCqWmusgtjfH9wgZh+xbZx2t67D7sbPdEJzbnF52zNHyeboKQh4TJWwpISdmKEP/Yce5YSjOFwcxnihz/L2Y8u/t8tGNz8RHXxjp1oH+2o6V+yAeXEAn64oeGQG+wXHX8SzNDZDGr5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KGDSzYEFGLEqGlp44InKxkhyLJlTPqpuaFJr7v9pF8=;
 b=Bilep9sqYFzX3/RmeWeNAaGfycbi8oq9Q36LYe38ELVYEpYsNipRgzCu8DqiJ8ZHTGysscZvYxpM4axbkIVzi1umrPOOvhA+4ee9SVfR6BtlDfjGFblvea8r42+4M9i/QDqqOTz14j9IgvvMgEVuoLSSQBuIgRfTW9BGTg6/p+w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4723.namprd13.prod.outlook.com (2603:10b6:208:30e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 20:17:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 20:17:15 +0000
Date: Mon, 5 Jun 2023 22:17:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, netdev@vger.kernel.org,
	magnus.karlsson@intel.com, bjorn@kernel.org,
	tirthendu.sarkar@intel.com
Subject: Re: [PATCH v3 bpf-next 17/22] selftests/xsk: add basic multi-buffer
 test
Message-ID: <ZH5CxH7x1y5y8g1H@corigine.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
 <20230605144433.290114-18-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605144433.290114-18-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AS4P195CA0051.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: ab946bf7-4471-407a-8d37-08db6601da91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OURtoKxGRRDyyLneOEnldUFKqEg2+tf6458qbVElvt4hfWHLpSIe1GjM0W/c2g4DeMJlU/amj8OImCsTPt8FSPpo7anLgiD+TadgMI9g+AyVl+LzOaq+RxhPv4pdjnAj8gboDEx89TIDpFYkPzg4fYM/HmI0O6JfJZ4yCwbp6w20C5C4LUsJKd1Pe82SvbAzYe8rGvMMJU/3pDXqxrTiIzHnVECSUrVZ1BsWnEo8y4WSf43NIZdCvuVSlNoytNtjhD+EpvXjRY/nGQevfK1DV0NsjJI/jS2UeJVOpM4CR8W3+k9EsvDUCLKFkltxD8vDFm3Oh6WpkrBxe1jM36IhZrP6DcOHGMj9Il91S4BsRmsjQWaxYbQOGTIss+p36beWv2JSf9zLxBqURpq+vhfOICOykw/Cz8G3ZfJu/F3QpjFKbOSwKNKn8F+i3qGyB6zYF3+ttbqqWGpof481llKyI1j9hTBBXBdx1Xv9eyg1wlmyc6nl8P57T+xYCi3WgU4d9OfgKBoZ7BDtu1IGniYC53Nh/5oryIAb0qbiIlhIvYG1tElujLNLi89NikX9n6BUdB0noL3/1xmX/r3itJ47ZJfX+TdroDV1KhKR1V7Kidw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(376002)(366004)(451199021)(66556008)(66946007)(66476007)(4326008)(6916009)(38100700002)(83380400001)(478600001)(2616005)(6486002)(2906002)(36756003)(6506007)(6512007)(41300700001)(316002)(44832011)(8676002)(8936002)(5660300002)(186003)(86362001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aed5Nu11tFlN+nX6LvoqUsDrKrkarx+RiHvyQ6CGiHGt9wz+05Cc7EkJ+Q6j?=
 =?us-ascii?Q?ssK25ew5MqAhyB+Md6PoQJ+9JG+9mZosThr4a+XV93YyU0Nw60Laj2OAeS/u?=
 =?us-ascii?Q?rBAl1uDIVxELzmDp3VfTeEDVTObNXQ+cU0gy5AzAIY9ynqk/11vtTs+SZ0v4?=
 =?us-ascii?Q?TAcJfqhBcjR+tNzQHrEYTVQcciKKNQHnskymct+QeDxHvhSlYuPQnRArLe7w?=
 =?us-ascii?Q?r9cKmlxcijFzLKEPDQflIlhWehNtCeZcEv1JknqCkcRJTHJcYnHj6HEYNW5j?=
 =?us-ascii?Q?EuFdH2M2olNv1Tw5WZvaKaY1NB9JGCC1jmlgcO99xisN6rh6RQ3h2dibXvgA?=
 =?us-ascii?Q?44bqaRYQBpyZmMx0HivmQVTDnIsy1totiivWKbhaAuZwBxL1eOb2wIlXDHVq?=
 =?us-ascii?Q?jvuZ+7TdIbwAsHz3T0MTKcsqSnuQoO5MnvDwC5SLXtutz2/yLr9/TTRye4qE?=
 =?us-ascii?Q?l1Tu4Y/5lRC0Lm9B3KI+UmQArXArYNiQvPg89GCWpVNw5maWwL4Fa37HMmjx?=
 =?us-ascii?Q?iEwizUa9eJKt+9Q0KZqSfOzi8mlnhORNql4q0l5+SB1Z1EKXxf98admT0LhL?=
 =?us-ascii?Q?czr0ynhoO5HRkN+7rDkSd2/x1u2bFMG/uSTVMcciGlihA2EY2qex8coQrelv?=
 =?us-ascii?Q?zRqJ2AdizxAPbXXH6dSqEoz6oRHstcO1B2G3U457W4seq62Ij3vpG/HeqY5l?=
 =?us-ascii?Q?0/pB8Kkifp+LFQ76id3tebeJJQ9CJi/2rQutIlx8yERXwd7S/fv1jZ3g37l+?=
 =?us-ascii?Q?ITCsxyLPARG0aNQTHc3YmFfwZ9FGU7xlgY/zlqznxmSNi9vM7ikIYr39bdVr?=
 =?us-ascii?Q?gNOAeOIk/TFiFl5sm6qLMDPnZ0svoCWz9O9XinQ5juVPgwh0wXYiOkU6z77L?=
 =?us-ascii?Q?XOrGLQk3xq5GQ7LIWPvUx6l6YUds3lxjsVWA2fe8ZsbYyoqSjfNO6X/QG9ak?=
 =?us-ascii?Q?nRRbQH20j+ivRCsFI4CEGcTvnaQ7YEOCFjfdsjnm17PCRJRc0dJ+/IlHrt9r?=
 =?us-ascii?Q?bdiQ5CBg2YJZNyQf2QgBtnXtqwUcKpYvF2DMeuQuvUwFhUpgMRnLKgps/RhN?=
 =?us-ascii?Q?rEVy70OtKNZJ8JeYGpTwmDW9kKMIol4UDYCCpFVtGshi8e2NsqD3BIR04GjL?=
 =?us-ascii?Q?kxtRisz4fGYVqO8Id1TNNjmcNRFaw7nFeL80/Bp1ObxpRtITWblrReg2hIiF?=
 =?us-ascii?Q?2cxXzhZjLuErXExnAklWA6Az0RqvI302VyiX/YUjOxLYn2onD8Ox9vqioO2i?=
 =?us-ascii?Q?ZZTRc0+jisR77ZvZ59tN4THdsPH2cppTF6qJrCV0bW0sEvbs2TyK5nx2D7bq?=
 =?us-ascii?Q?V3IQX8fdj6wABiPG3U4QtlWKrHHdCmzyqFGUMLQ3nmUm+Pe8y1pX9Q/14oTF?=
 =?us-ascii?Q?vmsiHdtrcz4AESmElX6inMj0nNB4rw2GD8u3DLFfzMgOIKnc6IaFRUZ4cIUM?=
 =?us-ascii?Q?/JyE4E3be0pu3OXGwffkZI1D2n6ybiQd5/szuSIsgJ8L2nCYJg+wpXZ2T68k?=
 =?us-ascii?Q?ZMjDfwMx8lybSKgTJLiPqO5mLIwmwqhpnUUMWLY9mW5WC+WhProh7/IHEjdV?=
 =?us-ascii?Q?aWSUCovs8RxT2oyEO0yyeY9pxZ2x/mxr9epBmlSZRO0R4tu0U0n9J7kIdMLX?=
 =?us-ascii?Q?U5jv7dIhWfFRQuz8+q4tWnNzGgNOfKbprT+epUSV9l2Un4OSF/4oVZrNEwN/?=
 =?us-ascii?Q?XXN93A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab946bf7-4471-407a-8d37-08db6601da91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 20:17:15.3011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94qOiacgByoXSYS7zfO7zegxAm9L82i3IiwxyUtuTy1C6u/gp4b8gJ1Yi2vY+XQZv5kQcm9ANNBZCh75qMIhSoj/LBxWgwCxK7Kh4XKXvrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4723
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:44:28PM +0200, Maciej Fijalkowski wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Add the first basic multi-buffer test that sends a stream of 9K
> packets and validates that they are received at the other end. In
> order to enable sending and receiving multi-buffer packets, code that
> sets the MTU is introduced as well as modifications to the XDP
> programs so that they signal that they are multi-buffer enabled.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/include/uapi/linux/if_xdp.h             |   6 +
>  tools/include/uapi/linux/netdev.h             |   3 +-
>  .../selftests/bpf/progs/xsk_xdp_progs.c       |   4 +-
>  tools/testing/selftests/bpf/xsk.c             | 136 +++++++++++++++++-
>  tools/testing/selftests/bpf/xsk.h             |   2 +
>  tools/testing/selftests/bpf/xskxceiver.c      |  67 +++++++++
>  tools/testing/selftests/bpf/xskxceiver.h      |   6 +
>  7 files changed, 220 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
> index 80245f5b4dd7..73a47da885dc 100644
> --- a/tools/include/uapi/linux/if_xdp.h
> +++ b/tools/include/uapi/linux/if_xdp.h
> @@ -25,6 +25,12 @@
>   * application.
>   */
>  #define XDP_USE_NEED_WAKEUP (1 << 3)
> +/* By setting this option, userspace application indicates that it can
> + * handle multiple descriptors per packet thus enabling xsk core to split
> + * multi-buffer XDP frames into multiple Rx descriptors. Without this set
> + * such frames will be dropped by xsk.
> + */
> +#define XDP_USE_SG     (1 << 4)
>  
>  /* Flags for xsk_umem_config flags */
>  #define XDP_UMEM_UNALIGNED_CHUNK_FLAG (1 << 0)
> diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
> index 639524b59930..c1e59bfbae41 100644
> --- a/tools/include/uapi/linux/netdev.h
> +++ b/tools/include/uapi/linux/netdev.h
> @@ -33,8 +33,9 @@ enum netdev_xdp_act {
>  	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
>  	NETDEV_XDP_ACT_RX_SG = 32,
>  	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> +	NETDEV_XDP_ACT_ZC_SG = 128,

Hi Maciej,

a minor nit from my side: NETDEV_XDP_ACT_ZC_SG was not added to the kernel
doc a few lines further above

> -	NETDEV_XDP_ACT_MASK = 127,
> +	NETDEV_XDP_ACT_MASK = 255,
>  };

