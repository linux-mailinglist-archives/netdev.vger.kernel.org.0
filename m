Return-Path: <netdev+bounces-9472-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 655C872957F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FFB7281896
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E8713AD5;
	Fri,  9 Jun 2023 09:37:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BA413AD4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:37:59 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20701.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::701])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4701728F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:37:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/g8wf3J3MnWdOIRvzQwzB6D+QITUy6KLzaPZfFVuyHCbt3SoR6hFw08aYTzEEbTTKYFw4FqkV7UVKYM1K4HOnEMZir8rFYDUkLgW0Ne+LCq0sQJccutBLmfuYNypT4i+6grMYGvVyv3SjOsAOCKT3yy0LqpeCaXPuagh8R/z0uzn5wHPpzH1ZTN3SPnebgDwIspoZDjaJp+c4bwk3reWnT0mxmkGrXAIRd2QFOAEcfTMxZcGMOWawM0NkrCylFKGq1O1CbIE60vwtqxT68grNb+0Hgv3bNRZyIFVZKrnzC2/9cU/2T83rdzu5Md6wg1HtaDTLJ9TIqxGsERaJF9PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/cJ2xLT+p3FLXOpeOIuIG1LxNzClF0lujoyhWxY5JY=;
 b=g7iulPJdtmdouRoamd0+22Y4rxXh/MJcbqFvbwObZCuIFvM5qLwXSp0yi/HL7gHU7dJ2VYGNURoH3BBP4UTac1S95UV1+rHfoVbHJi9l4gBCkgMPvYLPiDoXvcbiSzjBKeXOiRfeg3HEN5dB9tmXz/fuNHFt9OKyHYTxDc8QvDwMNA4Lr29UV2QsgCrSyCYQ6FdA3w5yRk36lxvSWJKVnDcd1yANGW3ODv8GsaH0LqF2P/752JN62qBDFdDu+qVpSBs3nz1W38ziq8mrMl1RbaDoWR6LND6Kme3TBpHyYTFBKEsOEJCNU+8WwK6lZHx7dM0O3tv99b5u04rtalGytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/cJ2xLT+p3FLXOpeOIuIG1LxNzClF0lujoyhWxY5JY=;
 b=NIHAAnqsF+TK/3P4aka+GCjrIG1opReqDD0O24PTH0Dcy1K9M5vEns9wVs5U053/gOuT8uMnDP2gWVg6mdjGVk5eJkC14jMDqeTLcHLLRq4KzG4u3zoV9q71lwX8mbqaiAa59DfDEBk7mLC67DAY+iVI3tEhfnk8MLegBXqDfzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5078.namprd13.prod.outlook.com (2603:10b6:8:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 09:37:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:37:09 +0000
Date: Fri, 9 Jun 2023 11:37:02 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 5/6] sfc: neighbour lookup for TC encap
 action offload
Message-ID: <ZILyvkGIXdV/9Izz@corigine.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <c8f47cbeeb9eaf9172721ef2146c3373d229c2b4.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f47cbeeb9eaf9172721ef2146c3373d229c2b4.1686240142.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM0PR02CA0027.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: a71e1fd3-b300-412a-8f30-08db68cd1856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WekR8woXJjfFPgNeo8mPcw1whzA2+oEndH3wvGhvVopvT6f54awrjXksq55e27kMwVGjIfCb5PlfjpReglrIdP8jkFg/jJsmyHZQ1BimKNXGggpvaCagefeq3tAU/a/pGBaqiiijZG/IOuktkuwIYVbCAW3U8G0PlJBQ7G8+Bx0h8unOQLeAzpcjbWUgs7lvBZhnCkuAP+mxUfYokTkqDRIJ25P9oN8hplGE1/0gR0qn+LPVvTPKyqVkrNtrEHitfqwulR0SEt0QIQqh8X5Z36zkkmKBy4GyzVnIcUbikvKnpHnCiiHMTGzsw6VqekcmiAplbw/81UfZ5sfNwC4s3PHTpCrTwOjrP/+NmLbK0dTVzzGZUoXHztiMrE0ZiUwF39fnnvcraaQPTNN15Zm9clGTtxKjIYvioI6Os/Hx6tSaZyT7s1r2Z6PGIGN1KpfCgOblUb86nASoa+gtp1z2Roy+YN9X0BKt+TsSmBqovup36zqYsfSPzCi1Ln2zxilrzDqHQQVkQjYPv0fyOfTwXcPSbraJkN5M+rkclk7shekWZiM9jjTswVS16ffrqQUl6b2Te2M2ehuYuMEJVxNzQm8YgNrl2fwF7NVXB1lwpfo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39840400004)(366004)(346002)(451199021)(8936002)(8676002)(44832011)(5660300002)(6666004)(4326008)(66476007)(66556008)(66946007)(38100700002)(6916009)(316002)(6486002)(36756003)(41300700001)(83380400001)(86362001)(478600001)(2616005)(186003)(4744005)(6506007)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QqQc4xp2lrKqYhdTNuJ5DbQptV/g/+O6wfugnTuCUs1YK6RQUnj1r/gl1DGk?=
 =?us-ascii?Q?mJuNDR0XqzzIGW0YBDOKwOi+25uJb1fj8uViSPORDzzpM1HshvzXgxiakoXV?=
 =?us-ascii?Q?jmNWyZn95QC+Xy6gQydB36yJobbuIQSsXx9zoIXvN3ZyIAXvHDf4dhIO8wpM?=
 =?us-ascii?Q?W0U9Wa7qNeBsCzfPbSCADDC0hFD6SHEZ8OCm1qsr4alW9F/ewqiM3eIgP24l?=
 =?us-ascii?Q?Je7fD+XkQlM1+h+VDz9g6A5/heOT3R02E91ZrtleaHlq0kNKZldCT+zcmBvM?=
 =?us-ascii?Q?mmFzEs3VymT5gHQIGfjUYjLcP/2I0RX+6eKD8ZcqyMjZfckTD7YBq8LUDVsX?=
 =?us-ascii?Q?uCFSN7LPj4tmO5oOj5CV5e5Ixqt7Ucs/lKkXT5qtwzJvKuRd993sTRANDsQL?=
 =?us-ascii?Q?L7pmQFcEs/6Ne3IK/YdUhZIUM2FDa0E4repplzbwVlPP1igem5H4E/Xo5o9X?=
 =?us-ascii?Q?YSg1NrW9OjKGutpVKZ7UiCWZ9vrvpRlT7NDy5zzUvahiPRepmwHpliVULzZQ?=
 =?us-ascii?Q?ALEy9L5Y6tvFD6ZC1WvG1l8cUiqoMuSFeaeN5hnmHRyYV8MzilIPjIQqYmfX?=
 =?us-ascii?Q?jhag8e54td16WONji7dIAXu6r0sduKHipBGYwSwC4+rb5z8ef+eHDjx5x1fF?=
 =?us-ascii?Q?8dXap2g56aMrJQHf25jZWUWDaABFKUJpy0epfoiqKq0KWMF8YEnMd6T7X65X?=
 =?us-ascii?Q?zWJIu5g3sqkOtmThBuSLRXWpriuTnsDDEFSNDtpb1z0+hUcBFOXBFy8afM0S?=
 =?us-ascii?Q?uksgKDJit4iAVSAHMlhIYUx0ecnUpyFB/0zx+0ISHN62CHisJkWAzDLfZPrC?=
 =?us-ascii?Q?r9SddgYUOXvxetvTSaIhn919+Mz193WwuLqMmuPTqghYV6rJoq3tl4t3E/CT?=
 =?us-ascii?Q?ZlD5FGLADVmcfqyyEk6YKXsUKlcYrjj0xZpzrDEvJ6ZW1Xo4cdEdpeWnFmFD?=
 =?us-ascii?Q?TT9SiB+o/zdGAUE4Kd9JupcZ55HPSKxV0P0mEO21wpnQuLA+2xTvegiB9KH8?=
 =?us-ascii?Q?rHu8+3ovqLp0niikyORkybt6baSYKVRH39ePQy3g72Gf8BPvY8nCs+Bruhkv?=
 =?us-ascii?Q?JT+5VJF9p6OoqgK7J3ggrosXalVOVGys5VfSfSvI/A/C8nU7QRXriGwgJYO/?=
 =?us-ascii?Q?UOVzo1lKBHWnalqMQCMK+pO+A+Q1HZhWQ9N3b32/JXphhW7ulTalFB2rTiAB?=
 =?us-ascii?Q?W+DhmjynlpV/D6upjgQHHmmI94a43uXLfz0ST5QS4sENKpb51SabvcBwHLDI?=
 =?us-ascii?Q?mYkxkvDPguz+mW5iNEBIUHc1bbz9uLQ1ebIgqKX5BwPddrEhkEnYeKTe5Y+8?=
 =?us-ascii?Q?etzIAKd1twNXfOh1yDyl1Lq9j7z69e2dwBxLdDfNVuK/8E9S0wgRISpmBgnC?=
 =?us-ascii?Q?x74FvSAb2g/bAMjP0VcsdLB3jJSrgKMn8oGo5QSeTk5aCmfgncCsjrXUkHxC?=
 =?us-ascii?Q?dMLhSLzAYGyDzJDBQ2/RnsWdPVDtYOsVNvMp3pepQ/fPJUeJfP3uvfRXccrI?=
 =?us-ascii?Q?TxXJrCgOcFiCq1xSbwQeJpWp8KgjtisMbel5Duyd9cbfZLfp5w24ybDK2WvU?=
 =?us-ascii?Q?n82P7AdYLEfFQfujKh/zpKCLFJiFSeAn5wsSsmkGlEXKNDeDlPngyOmX3UO8?=
 =?us-ascii?Q?2Y83KMNd03SX3QiBL0GjX57e3gxO+nuFHH3en5AqFgwNl9b6f3Jme69yHGmi?=
 =?us-ascii?Q?dNf2eA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a71e1fd3-b300-412a-8f30-08db68cd1856
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:37:09.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WhhoVu8AK2/keElikw0+98X2tpAW0FndmNqSxrSF3dMoTeSnpHamxPiMFD+hBLsbzVX+BZDxcMF5puycjBXOTsnnCJVdN0aXznmDLRVVxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5078
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:42:34PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> For each neighbour we're interested in, create a struct efx_neigh_binder
>  object which has a list of all the encap_actions using it.  When we
>  receive a neighbouring update (through the netevent notifier), find the
>  corresponding efx_neigh_binder and update all its users.
> Since the actual generation of encap headers is still only a stub, the
>  resulting rules still get left on fallback actions.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


