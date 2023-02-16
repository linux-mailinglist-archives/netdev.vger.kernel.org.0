Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE836999E2
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBPQXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBPQXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:23:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE3A3B660
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676564595; x=1708100595;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+GS0lzhk4Bsq3JUtiewSsO2gEn1q5cS458Rtjp8fbqs=;
  b=hydz/qfUCTnST88X0Tv5t/95BC7cSlHk0oc37CQxT8o2DCTSdaYivb6W
   MJnruB38Wo1c/PUFR9uygrIVIKwsGkG1AhFYuYbIFJEhW29QBvQUNx4MC
   AMWT3JNERi9qHZqeOnChqN8c75xI7AdV8c+PnDNn5jcnr/B1JrhqrzU6U
   HMwPzXga4L7Z4S33kFsIHIMx5dqhXU9d/0FR11lVKnkPlankCT8nRz7tm
   jpfHk5Yhh8PqvvP251crm5Ok4NC4u7AY98GskMPfWSHB6qzhySja4hgRl
   vE2xul94ZTi8dRM6avrup8wJuhO6dfxUTQVQ8BBfeKODTx4DJDoQjJEFI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333101669"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333101669"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 08:05:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="733918782"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733918782"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 08:05:16 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 08:05:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 08:05:16 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 08:05:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYNdWOcEpnZHBq48BSNgYzxX3fVhkUKDlwB2+8jpQANHzXM9cs2GzNSu6dJ6dk7Ek4CKc0fzeoptgreTelO3wBTI9DO352D/s+xIsrT1y4xQN7z18l+g2vFJIK0vHi09yKlM00vZvE8tR+XqUUTU/58nuVrKezAWMxubPNcPI8BfwKLBt+gvacfG7yZYZF8fUpIiUcmygBf0HDp1rDm8c6psz8LkYr3/2GibcWZ8pJHLoH8RPzvpdqDADBYDL709LGRglJp5hXUcOkVgjuoGGmTXCWlVyEVcFrxYFmN+yHCZIPSgkYreYe54LaSKd/UvO3Dq0HUpddFo8rvTinvtlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRc/2KNDov09ytRVNmfr6k41jRmXhNSiCTPnHlf0o6A=;
 b=b4Y+HypH4H/ezLRRAa8ebocq/Pdhb+YNhvmI1Kujti0n/Pe3lFtxbiQ7FnW9LozioU7I0gMlCP6HdE3nYoYRln10Ipc7NwFriz3CW69aYgNaJ8mexNcp/CO9BQKca9bYjaB8htAkng1YXhVs2WT41pyjYOmiSn8R1Q/T45Wuefs8glq12N+BbLX6We9jlbBlK11xUix3xEne/XMSgmfYSPpeq6KM+7DmnyWv1NUzNx31lU68opc2m+DtNiZvKi43fN85e9f1MGjtZZItTk2EUNqrdM6a/4VpZSEvY3OD2kRO+MCpOx9557DOgChUYnUTgtV4VEvrcOlCVufmHv6pbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by SN7PR11MB8068.namprd11.prod.outlook.com (2603:10b6:806:2e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 16:05:13 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::16c0:1ae3:13ee:c40e]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::16c0:1ae3:13ee:c40e%8]) with mapi id 15.20.5986.018; Thu, 16 Feb 2023
 16:05:13 +0000
Date:   Thu, 16 Feb 2023 17:05:00 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 9/9] net/mlx5e: RX, Remove doubtful unlikely call
Message-ID: <Y+5ULBGJ9nlr3VS8@boxer>
References: <20230216000918.235103-1-saeed@kernel.org>
 <20230216000918.235103-10-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216000918.235103-10-saeed@kernel.org>
X-ClientProxiedBy: FR3P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::12) To IA1PR11MB6097.namprd11.prod.outlook.com
 (2603:10b6:208:3d7::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|SN7PR11MB8068:EE_
X-MS-Office365-Filtering-Correlation-Id: 956d2cb6-7351-4537-eb65-08db1037960b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6st05vBgd87B+XsvvhkBrYn9KvgRHHnKrmJGYDFt3BN9BnT8rjpoMcKoJj1OOYR7yFayr0lgMZo2gE0P6RRWphojdf3QOgr29tD+Ey9DrBHUWEl5/95MZjfBFf8ygZtvN2VlEUzBeGWUwHxwVO/tlDSDBH8iQbDMwI0IfSAspUlfa0d7z4S26WuUROiGSkNamzVbvD4NpWAD5uApMX/wxmZCDd+9OflzgfIyxpXQvIygp+m+ooPSFMsCjPbeNb2GdcgRCT6kRw3CcL6e1haUF7pxJPLfg0SA8WbbQRFsTRiRVsOxfNy6q2pBdGRrG/TS1hdVMdhRcM8ZrYeHGH1TsKdDkmXsLdyPDhO+ckpXk5n9S9e6XXwmUbmGfuqfcidJJqRAU97WgA6vHsSvXMyutWCTuCY0ncLsgdYcAbvdxBdpkd/4lBcBAga2PMYWoNi5fCT/3ctjnnKabEVy0C/I6MtJmZkYV3lFL5H+UC/AfRnoh1AWo0sq9eUwUyQzhxo4VoR0XYDgjzRRi8QuDRL2hC2bGdiw+J9g1qju00x7dIaHGmkuHQ87D1YWPRX6qy0ptdK5YFO1Na4oFMGKiVqDglYiZj77k3DxlUkpbdwRhDv+ciQCn2EFVv8/GGjbK1yGCjcSOV+qNy5ZRA1eSKYrTodfpRcuO807eRYgbCG2dnrh8oblERInitrExfhEk6UE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(346002)(376002)(396003)(366004)(451199018)(6506007)(6666004)(9686003)(186003)(83380400001)(6512007)(26005)(38100700002)(86362001)(82960400001)(33716001)(8676002)(316002)(66556008)(54906003)(6916009)(478600001)(6486002)(41300700001)(44832011)(66946007)(2906002)(66476007)(5660300002)(4326008)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WMwp7e/vU+g3WCvMauJFokjUSFrdjyS9fRCj7MFgCjWA3+/Dh8lsXlf4TvUg?=
 =?us-ascii?Q?7PcL+eHve9Bl2UvwvFMbOvfJjFUS7amSLF1iIoLAxd9dqWGbseQqJNh346Lm?=
 =?us-ascii?Q?IPseHQBSxbQJvO62nvNgvaBcZEq7nn9HTU/PH6/vhZRDSF2J/zwUJH14wW6I?=
 =?us-ascii?Q?DHIUiiAG3nrzP59vdADMYBC2hkhZepA15mJ1B1nJ5WSF+rthLtG2dm1yr998?=
 =?us-ascii?Q?G0kLbC/RFkPxPUf3+8d0qOtbBOBFFhBqbuDKbn7ZBdO7cpL5J8hbvPJvvAJ5?=
 =?us-ascii?Q?y1zMkoyu5Qkh5I+BP0rSb2ESFpwYCFy8ZtfDahplO1ZWivVXK0SbhVm+USFc?=
 =?us-ascii?Q?2esLTBYJYr2ZGqSFG5zODWpaBLs+h2mDQTq+X4826rdytma9eZSgcyJ23amL?=
 =?us-ascii?Q?ygaWmUiSkHHqjBpQgvZkwbPusOKP8t5TXiXdTZO6u0b2hxifGUyU784GIDb9?=
 =?us-ascii?Q?fX/qxHVCMEEg48oEHHkTj6gA80TDY4YdIySenm/tDGc8X41Qt5MDrk2i1wKr?=
 =?us-ascii?Q?heN7K3MMoCxDo12e0VjwiJcFPiqcQSpVs3vsXeoRzCC0v2QLODuxjfZ4YHp6?=
 =?us-ascii?Q?fkHJurlWmwGyUcEzNkoIh9OjURUfV+Nf9lhjtqDsUxEQAJiizaHWlgYZf4Zm?=
 =?us-ascii?Q?W6SmvTKZI4OdFfw3vSsJWzcdx1BqP/3WG3yZQymj0KCAJvYcnwYB0BHBoNzg?=
 =?us-ascii?Q?fY6A0AjV1c+c13a4AcrPH4izNtBqYvt10sTU79YKFpDGxJQox6owrIM5b1pw?=
 =?us-ascii?Q?SOeYn8GS4qfQ2boZAkU2/yep13hqmrKi9OwvKU14zEpWsMfD8u3VKTM3IWtN?=
 =?us-ascii?Q?BANNH3NgIhdKFShy6me4eSds0XuL1rR05n9NP0koLtCbDl0VmAXMC2Nc5bYr?=
 =?us-ascii?Q?0WuqifbZsgPtjO44JOraQ3/sY9cDJcfQfyUFvSQ+l1Ae2cg1DBVpgABhlTb+?=
 =?us-ascii?Q?ktHqbX2bijIRb75DlTgo/AsuPJt9z80V3q9JOQNvtFNF/Ocu+qd0yT+w/vC7?=
 =?us-ascii?Q?P4IcKKdb+6XEsK0b+GmgqxkLdFLpN0u/38NDJai/va5MqY1GViNdIYUt/F3c?=
 =?us-ascii?Q?OnITnqK6XJnVDX7Q3aQiiqIOaU5ipoQ7GYg+HyYzlMwQ61Wvx78ET5Dm49lN?=
 =?us-ascii?Q?xWg8x0EYXyCzFWGBQPyxKGo80piWoGvGNkq/XCtXwVmb+hZYq0UPpYoTJqLr?=
 =?us-ascii?Q?+Gq+p1lxZXBBEuHCEV6t+B+PyMrDw2CxcdtsVruSxT+QiCViGCTcmbGC84Yq?=
 =?us-ascii?Q?Uj1PDzCVL+og51sBcpxJGeB25izG5GloIsyp2ODm/mb8hPGsKXJYANh09BnF?=
 =?us-ascii?Q?436bojRbs4uMxjYdLSlrPHgrphBu20aBxR/MK83JfqIwkyhtj3Z+vZ6VqRBJ?=
 =?us-ascii?Q?usfGdM8aI6+zTy+1FruhkQZe9W0l2GqsJKez0CIzQrRtIf6vx6bU1gImz1VP?=
 =?us-ascii?Q?sbZ0Kex1uYO78zp+aRZS0Vu0uYpVjs6LiaFVQQjO/H44dfiitLKlq8DrxUk3?=
 =?us-ascii?Q?ZOIGUQLcltYt1GfzN0fVfOlTJ4WYOI/31FeQyMakstr54IhiNUpjFyq0wse+?=
 =?us-ascii?Q?Ptb3UJURSY7ZF2p9OKWJtqn3kvyckH1vL6xAYTsNggkK+ux+PgmWGDhgj1kg?=
 =?us-ascii?Q?e+o/qXsfwwtSbXbjp/2qJMo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 956d2cb6-7351-4537-eb65-08db1037960b
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 16:05:13.7958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zy82dzCoxciaoLRZlLjeG5qdNMZbtK/NT28KhzMRSF+yh0p8rvTVn/pls3N5YoRnttdegBAO8x6TqJErSX4jU21EU0zxVaYyMgfaxlIsVFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8068
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 04:09:18PM -0800, Saeed Mahameed wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> When building an skb in non-linear mode, it is not likely nor unlikely
> that the xdp buff has fragments, it depends on the size of the packet
> received.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index ac570945d5d2..e79dcc2a6007 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1718,7 +1718,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
>  
>  	page_ref_inc(head_wi->au->page);
>  
> -	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
> +	if (xdp_buff_has_frags(&mxbuf.xdp)) {
>  		int i;
>  
>  		/* sinfo->nr_frags is reset by build_skb, calculate again. */
> -- 
> 2.39.1
> 
