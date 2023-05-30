Return-Path: <netdev+bounces-6354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C49E4715E1F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE005281162
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2848182AC;
	Tue, 30 May 2023 11:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEA317725;
	Tue, 30 May 2023 11:56:46 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20715.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::715])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E615F1B7;
	Tue, 30 May 2023 04:56:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpoFV1A3WgsymARZGY0geiifhIuPDHR3k0MrzRYPk1nIZc1OwqSIeIvL+Gef/EuFbrCtr7T3T+15L8o+xtD2E/xju0LCBd1a9oEh0w6QxSmMXJ636TcLFNnmBxqJSAYcOncdppfL41E1koP0uDFjUijXep+/zNNYPGOxe+KKIalelBnt8NPOxQVXXwYX+Lolw1ZNwTLCYqYiDI+4LMelP9/3at3vLPtE3kDPN/EW+Rl3iCLiptouZnM4LScEMZ/GbYm5ffkX3L+HBe8Atxg1LOBlEzp9bqN9w6JTkGYBpPhTQuMx5+Njf+Qiz1ZmENeNhk60SAg9CRDxTZFjuzg0IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLzCelJjAR4bJh4V60WqvCmgIClqKFLE0Ch3vaGK/TY=;
 b=WrQ9uPCGgyUahEN4X/emZTUeOfbc8WDp4gQ77JGVvljFn5KJ/l7z2c1Jz1j6D9vkBGQKOWWSHsE6eFMEuwHtDLDWdRZJUUjVAkPQ5QUsZgsnERL6ByCW1rU995+80J5E47iWn0cUna06lNgbTn7VhFJYMvek803L7WI/qzlWacqdWefrn0jgcjTFgj10jyFTdl13MsDtchlifkxpfd4K/rZQgJ7R1suJOBWd+NwqGKS4d1N1WuNfdYpq/zk3wxAiexFPn3gSk5oOq02yGUIKf81+dTj0nXXPmW0QfnIIK19F+RM9tfWYhTuDkY5wduI48x4VBN4/Aym6IE95Z04hnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLzCelJjAR4bJh4V60WqvCmgIClqKFLE0Ch3vaGK/TY=;
 b=QCtRc9xbeL6qB2VecZbcwy2CEKdyfcJ70uKOYle8T1nfW6bci1YHmIvFMlBt7zQ9xOjx0M1LzxyR85sSv5zuWPtxWT8D06Oo8C/nCNAtlYAQVQOhB4F38Gis9i8V1WwhCo1D+ZeSwWXP5E+a6tI9cPyMHVi+yjwbucTCLRhgkvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5088.namprd13.prod.outlook.com (2603:10b6:408:14b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:56:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:56:03 +0000
Date: Tue, 30 May 2023 13:55:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, netdev@vger.kernel.org,
	magnus.karlsson@intel.com, bjorn@kernel.org,
	tirthendu.sarkar@intel.com
Subject: Re: [PATCH v2 bpf-next 13/22] xsk: report ZC multi-buffer capability
 via xdp_features
Message-ID: <ZHXkQX0uSh8tDFTO@corigine.com>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
 <20230529155024.222213-14-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529155024.222213-14-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5088:EE_
X-MS-Office365-Filtering-Correlation-Id: 300a117c-5e6a-4354-4e78-08db6104d820
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nt57iow63LZrc4PssaV7I/g3zf8YRiq/NrZIe7tbfL33odg0Pni+kfc5qUgrOgojJlq8r8N/J8tcCk7MdSDmL0uHoMzgxC+QE9POIMoWktuQRJj7zLPZ6Gum22XUpMJupFhV9J4VcZjxKBo+sk0/VPLMJIuhbbZeOg/R8df71nWhBbQf6T72tJUWAPU96wWMOzGBsJnZ+ImQBcCNSc6oc9gQAkeooXufLHnExUfk5Ijf35+Izs6rS5DF86X1bi3RBVBAnlRwm1n+JgYSbJ8p4aDaQrSTxeVP3tfKlC3k9hY4qA69ktVlY2zUu5Uz4fvm7Sd7LGY6cWjBpf6DGxTCUROYeJ+6hj6SAjp5yqRVaOJrqACUYX2lLDgTv0j1e2PNAJm58iB0RRPUGmszsnhsroCVy5Y5WADxYgKSnFzxvA7barzpG2ToC/u8RS0+PjHu7ngFRfyqQ/Ws1cs3LWct1yrx9GoTuhFEDZ6GD6DvOx3t71lg1vmZLkDGvEFMJcN9B/V0miIS/18/rl5qvnLNh5NJzz/bkYEVXg/1u9LLMxcX75va1/rvAuZBNvO5cwnKTeaRrVpntjINEl1B91p13EJ/Ouj5izPOyH+hzabc5no=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(478600001)(44832011)(8676002)(5660300002)(8936002)(36756003)(2906002)(86362001)(66476007)(66556008)(6916009)(4326008)(66946007)(316002)(41300700001)(38100700002)(186003)(6512007)(6506007)(83380400001)(6486002)(6666004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HzgrVeW7LZeV1RcXVxFhL8p7el7IokAQlm6NaeXgl1uxkxs3rh+NpVE5q7gw?=
 =?us-ascii?Q?ji/yk5PsY7UweCh4WFPK8szUK8GAaIbAvcWBpwW0+PveY5Z5zYL4o7WP61pR?=
 =?us-ascii?Q?c70hdHMCHc9ACAKaXcC7gLUzMmsUhVCkTCLn/qFmg5QjvSTqjhP3HKW2oZEy?=
 =?us-ascii?Q?ppKjrAr0SVNukgNHtDrfNYrfWbL1upygyOf9pAY4nTy2k9+Y46DqITPqweQr?=
 =?us-ascii?Q?zaHwcJtu5m6dnsuRQy8iSMoI+u2RYxuwiKvAZbCirVSXLVyBU1SztyQBFDWG?=
 =?us-ascii?Q?Vhgh/MA38rRJKm7xUlf84I2Aotl84sYGdGFpUS7gmNkdrZaM7GLY115TAK/Q?=
 =?us-ascii?Q?im2T9YbSwuD48ZSrEtG49yUHO0aqtu1Q/tn1xfp7pBoUx9Et380moNQD9/R1?=
 =?us-ascii?Q?mOpMsu6p95FWN8e8SJ2nZaUTRSOOD4+n2cbpHD16c40Yc7WQfm11ew1ih+QF?=
 =?us-ascii?Q?IAxIszFDcpPE9y71clmFuK0wqx0VZsjRMPoh+AIxPEIjmiSgk89Ol54pvO+b?=
 =?us-ascii?Q?5sGDG7Y5ytY/w+XqgJ0sL9ClqJ9lD4rab6ipM01qK8P+PVa5jwvhgUbTmqua?=
 =?us-ascii?Q?hzPWXzABLEHhIVNNFTrhYkadLdUbgj0aiGA+LQywaCKzM9MrCr95Zl4uZ26p?=
 =?us-ascii?Q?e61+1JQ5cbfWMVXMa/a1CveGEynu2SWVoGxisM/Mb61OlJkdCYFaXmZVPIDj?=
 =?us-ascii?Q?dAdiafO7e0KvtwL0VS7T2PZOoqu4dzPGccDuN2xWSBlqtY4HpjlBO9Qk6rZT?=
 =?us-ascii?Q?xhPe1X/0OMWqKOV1NDCVI75dCT1902D66wH1RAXIMo+AHJjK0GAriX9xmOyr?=
 =?us-ascii?Q?Vmcz8xqyEcFdz2D5awU6ReGBuYLzGO8BNS8IoM+qSLRYaMn8GmrQGTxvNk6j?=
 =?us-ascii?Q?92D6JmxUwXqoztLSaQkgllWT8hnIjyacpcrUg0rD4DDh5JC+ac580EiMDIG0?=
 =?us-ascii?Q?fxYRCIGp7H13dhggE0TJJrAF5XyIWeP245DIbnPP6yni7fKCTQh+6D7geHwO?=
 =?us-ascii?Q?a1ebam+WTizOYiEsgxYmlASdcQ7cvK7/7rPIX3QCwXkLbczPPf8WH7rueXc4?=
 =?us-ascii?Q?eH5lsriHEk0hU2WkvvBepwvyoV6E94XtCCGO2M4GwBBOKvchXISoKjOIjoQY?=
 =?us-ascii?Q?4hHhmyPu6YpgdVYhfb5wzKmZQ728h+Ogu2XZiVrCY3uTe1uWgZ4yNuCWMLMq?=
 =?us-ascii?Q?KI0t+8y2+9ZOVhiE9wwMSqLqzre8RCY/0gMuTfV6CAIN9UZGyo/LA+WH++4D?=
 =?us-ascii?Q?sFD2cBHr2bfpUn4DCt11ivIW7ExjzXShZ5wRPWWT9ty2Vmk/9xqPLmywe8xj?=
 =?us-ascii?Q?NecnmjyHYoQVqnGjhWUARajoJzy1e0ipumAeGqr2k4l9XCr8EAXKsiNjpvpX?=
 =?us-ascii?Q?0xnB0Gj+TTx+vihmtAm4P5N/jg5PHJyu4inGVk+zX+ZEYxEbDHvtr9cvVpdy?=
 =?us-ascii?Q?/1vpqdinstgg+h0f3yi41xdJWrgf8fI4A89wkbF0MY6zM9XkFRMp94PtjvwF?=
 =?us-ascii?Q?D5lMzB9X9+GSTDvzWFeB1/W9KAtUjxDihkpsJy3dWEt77CiSRvMA9TPYjZ67?=
 =?us-ascii?Q?1+8NpBV07D31cSX8QukXgMw+8kHcyjdaEF9VfKpvzCC58UMgSCcxMR7Weswo?=
 =?us-ascii?Q?t9igvj+JwjvdabPlFlsOPLKoD7d5jwz5Fjc8r7z+tfthmk0e7XBVVYkTT6E+?=
 =?us-ascii?Q?20DrPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300a117c-5e6a-4354-4e78-08db6104d820
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 11:56:03.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CbPOOD3r0YkVAcuo6VsKWQcRVcadUyl74WijETnuhnazW4kt52oFkZS1eHof9Ug+uh8OkuSNi9dcsTay/sXL7/LH79u9xc5huNUaRxZ6br8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 05:50:15PM +0200, Maciej Fijalkowski wrote:
> Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
> find out if user space that wants to do ZC multi-buffer will be able to
> do so against underlying ZC driver.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  include/uapi/linux/netdev.h | 4 ++--
>  net/xdp/xsk_buff_pool.c     | 6 ++++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 639524b59930..bfca07224f7b 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -33,8 +33,8 @@ enum netdev_xdp_act {
>  	NETDEV_XDP_ACT_HW_OFFLOAD = 16,
>  	NETDEV_XDP_ACT_RX_SG = 32,
>  	NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> -
> -	NETDEV_XDP_ACT_MASK = 127,
> +	NETDEV_XDP_ACT_NDO_ZC_SG = 128,

Hi Maciej,

Please consider adding NETDEV_XDP_ACT_NDO_ZC_SG to the Kernel doc
a just above netdev_xdp_act.

> +	NETDEV_XDP_ACT_MASK = 255,
>  };
>  
>  enum {

...

