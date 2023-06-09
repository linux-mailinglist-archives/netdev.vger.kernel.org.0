Return-Path: <netdev+bounces-9680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6501F72A2CF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B441D1C20A1F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC0C408FD;
	Fri,  9 Jun 2023 19:06:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E844408C0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:06:08 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2131.outbound.protection.outlook.com [40.107.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401FA35B3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:06:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G534EmuEKUtQ3olL7Ht0I8MnNKWSbPODVkqL39NXCftwUNlNzu8C+p+NbLHLUDq4Y6hlAfthyqqZsyeVuIyfVJKUUR3CWp52ixpmzyemiAxOXgeJ3M/zXeBXMfBige73PxtgdEF0AzSQj31MRDA0Oc+fe5SI4RtLzq17t4BrW/0fAqZ08F/8ujF5M8wyhRGO3b0BrsqEAS5LpA/Su37E2VqGORbYcLEFawSGr+QmfhY3RTCz9Bx1EYoCIsD2rDcmzODbeubLqRzHXh4wMchVhcaxvHAUrIVhCXZq9qmVzHdg08eMDlgZbQhu2lLjdNK5v9XhE8s1Su5SmkRoOyNYmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5goo91So90nVGMTSWewhKPGC4/h5OHFdi01qzIRqiQ=;
 b=ad6VylGmvOCsMpBglnVTPkTwSGYk3guvNPPPo0Ro+hwty7+omVps4zdBmXlPYArm84RTtg+HQh8QbolokhzZsq+6QpknhGKrVxEGznyzG/Iy7FCprj/7ANk1UmspuL7TgqJNEL9LRsw3KtGSj/EzrjY+/1jKN/jWz7T1aYWT4aEIuHMcy8eYeYEc5sWVeP/osXDV+JJSPHY+JPWFHNERljTSEyzNhZ3oFgnGa0MBYaLxLTKEvkkTtIgF/xmvGXoMrInvCM6J42241j2ZY51SeJ9sjNjZ+df/XJORJpbqq4RI3WjcVSW78VpC+db43nsL3pFv+JODyex6ooG/lxck3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5goo91So90nVGMTSWewhKPGC4/h5OHFdi01qzIRqiQ=;
 b=s3nGFLedTS31Ee6rtHtiKdQ7yt+Yw1IiIIOLQyya2ysgaQmuzalLCy5M+//oCrJHY/IFTZ+R5ZrBfpcfrhUE47AT1M9gkWf8h+I89O8KAZQBmfRS8mosCngTvosqSZOLjMGiAU3QQUegK29Id9oWAwvxjR0YCrlxfmZ2eDWaVwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6336.namprd13.prod.outlook.com (2603:10b6:408:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.17; Fri, 9 Jun
 2023 19:06:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:06:05 +0000
Date: Fri, 9 Jun 2023 21:05:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 3/8] mlxsw: spectrum_router: Pass router to
 mlxsw_sp_router_schedule_work() directly
Message-ID: <ZIN4F8iduRTz/MMB@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <02142b0db9554ff6df538a7659eef395db1313e6.1686330239.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02142b0db9554ff6df538a7659eef395db1313e6.1686330239.git.petrm@nvidia.com>
X-ClientProxiedBy: AM3PR07CA0078.eurprd07.prod.outlook.com
 (2603:10a6:207:6::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e41ca6b-c96d-4890-9e7a-08db691c9348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pgoQ6WcO/h0ne+P2SHuDP9SxAJMCHTX0vDhBNT125TOnH1fgKJBQObLNPSoMXEDcvLPqbfSAvQl0R6PUuaGx9iaDHNloEjCIQqOcuKt2tUe9UUxA7il/nyyWoOBEqsAI7mOweu3p9rCLnxv7/lvOxm8i0SFvrdiZKuQ7gvAHWESaKT7WbhZR3tEUPfy6a+igFVRDnvVljfR/AvF5zThZ3onmweMgLr8+/PtCzK64ODkiwY9AH1D/B3LUM68TFfH284qrjkFlQndF0hCaWRwSMftZxL6HGbjQL5W7mYxUm/KPVY1i7LbLNrMoGTR+oG+7SxU7iiTiPa9hdBhSP9M/sAX1dWuiDt9UB39OLlz+1hV3H4i/FzbQL3E9XiGzq439h1X5sH+3qR2op5KQRImgB7aZAzCoASr+HP/TmXGB9D0Pf+RUevHnsve2UHX2WKcQ+Tl+p1fhmBdit0nu2rR0vtICPmCNvk6aQmwctG+Q/xofcuWyFaCo8kXvQbN94cQAUT/djCJ0YIcJf6GZ29TUO46bpiFyEbZ4RoaPlyrVQIsWjm+3ROaiwx5c/W2aOUmW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(376002)(396003)(451199021)(66574015)(83380400001)(2906002)(4744005)(8676002)(8936002)(5660300002)(6486002)(316002)(41300700001)(44832011)(86362001)(6666004)(478600001)(66946007)(66556008)(66476007)(38100700002)(4326008)(6916009)(54906003)(2616005)(6506007)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7sBl5yf12J3MfebJ3RDfMVUGytvCfhXUD+/8/7ishcHmXUIrjtojpQ+jPqaV?=
 =?us-ascii?Q?2/N60jBflClEB6Ee6o3QyYjVrW7MkEWFQiFT+dcYbHNgNvAKJkr2P9sZr8rz?=
 =?us-ascii?Q?naMCiNHSdkC5z2q6lbmksCAOEswzcVeM2T1K46EINPnQPXpfL50pYnLZVCY1?=
 =?us-ascii?Q?oWSRCv4C/NARGsn+/Db4r2VM0vJQpsDvwsZEwdasARgnIyDbhxjBB24UX3L7?=
 =?us-ascii?Q?VvBTP+T0kQ/hQN3NFT1OCfbud71VbYqdhd/GdTj+/2iDJqiXijd1kUT1BctE?=
 =?us-ascii?Q?oujrOdCJfYtEveYG/qyw6qx4uGJgsR5O4tZCSVhfO9/yKbo5O6Ydv8l9EpCN?=
 =?us-ascii?Q?mS20CjBm1nTc5pPsRPwsJdR4cSgtflXmdHcc/y19Dk9ga8dzcvPDtE697Nu1?=
 =?us-ascii?Q?BEeJMLpo/lZnhfiKdcF/xvkF2gt7jbwlafovuWTM+wJ7cfgXj6lFm7F2nluN?=
 =?us-ascii?Q?jglGhL4h8L9ESjg4Fxf2ETR9shBQsyd86dPPH04IfbcPzpdhup3zsHw9ag7v?=
 =?us-ascii?Q?NrL0yg4WkAfzKvm0ZMfW9/HmAEIumcfygeZpMItn8XiG6eq0z2ayEk7Yo3zs?=
 =?us-ascii?Q?K2j9rzq4CUETshGFtsxgS5E3f0ZAsnlPEEYivr+ohIp5GyJ9NmQwif7Am3FW?=
 =?us-ascii?Q?nrbhi5D4QDbJe89/VwznHy17GCxbnGgmttRo+pEQGaDhDJHvFlmnVZEGdJ76?=
 =?us-ascii?Q?UcdrRKeJ6fWQvF9CCqjX36eUD3N/9/Nlaw7NHiudyt/5uEyFK/0K5aHP4RAo?=
 =?us-ascii?Q?KmsaQ/q13P9khCx46GrZTHt6gJ3W+/iIok01S3r0Rh/LYDt9mUveY7Ub49NM?=
 =?us-ascii?Q?dEupW4IpfzK/l2ytWZB1oWdZuEBGUkS7HMLP3vg/DfXDgBD7El1PzSKy7qGU?=
 =?us-ascii?Q?V6dMTWrwGbiT7bo3nt3JuEWNsIDICtIRlOtF9mJm7VuHwgVyw4dMf0novtNm?=
 =?us-ascii?Q?etS80GJu1thWbgKYuY8GpxrXx+2TFvhKJYvIH8ZrxN0I9NLCXJxW0vICFhfI?=
 =?us-ascii?Q?BvVG6WIeIk5MZiWW0+j2IZF9auVHC/uCXVrc1fopqrd4oJRVMiq5ILkwK32H?=
 =?us-ascii?Q?DDihf7XDSVKnTyKuPkiwcCrLFxi6eS2C1+S2W5bN/3J1ilHlJ7PflodD4hgH?=
 =?us-ascii?Q?ULUNPg9a1Uq//MhI0duIA1AQ0KyF4x6FU+CyHTSXHs6liaypEqUbfrGwYODw?=
 =?us-ascii?Q?HGbNVtyNtNQ2XumEcfyffgQ8aGY7gmTAbw16zsrKkqWmSYFLOurpGuJFKURi?=
 =?us-ascii?Q?LFXNeKLGO0AQXdAfvUKjw3QbSOG2redKW7xdDzWsveKfLF95HryZ+uySnX5S?=
 =?us-ascii?Q?aFSJZM9aj12w3DBHGmVSryZBCUJMwy8OcqByrUgVQsWXBUI2Utds2FaG74BX?=
 =?us-ascii?Q?P+5naVV4sgg+YtJRChGGw4QvjryJLa8X/aPSDhL1Yj0vqkM//qZ30TTKfoK9?=
 =?us-ascii?Q?qN1KoQl/2r1JmaNy9wHY3kSzBQauz1SQPrLTtgjgNnxXvUEXl8MEVBdUrLHd?=
 =?us-ascii?Q?SIbUlmL16kTbwicoIwBW4kqGXxOAAoQRXWSSVdL7FSG1iwHUT9nXBeCQmUzH?=
 =?us-ascii?Q?R9AzXDVXXYVNtlcljAMSZb3InDYW5rKPeyHb+Rnt/JzL2ujGmDBynfdKSBTc?=
 =?us-ascii?Q?33m47MW97eDObmOEoZTLHq9hBtRFGyjM2/tNJDfSI/eKO5jUzLoz6fi+iA6e?=
 =?us-ascii?Q?XKvVSQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e41ca6b-c96d-4890-9e7a-08db691c9348
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:06:05.5236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCW0rw1uW+6J7AkY+trAqYcdgSlv+73ejAs/KwwN+H637YUyFzmVcHoc/Yh5WPt6befGe8MmRwjqa6MD2My3ZJOvimCU8aj0POtfvbvVXPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:08PM +0200, Petr Machata wrote:
> Instead of passing a notifier block and deducing the router pointer from
> that in the helper, do that in the caller, and pass the result. In the
> following patches, the pointer will also be made useful in the caller.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


