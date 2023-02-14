Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794C3696A2D
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjBNQrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBNQrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:47:15 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841E4C1D
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676393222; x=1707929222;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4uVK+Cx7K9Uomx885bCXRrheMGGNaVOJyNKPPHWQ6AE=;
  b=POJO9X+W9gVeVCldvCK6IR46xnAYg2mGj45sagdj5IF8H8XSeeUEW2Mb
   OAnpPY5xiJlCFziTYfI9tBwLeKeL/DlGukoq99W/r8Or8H+stG1dvou0O
   tWDA7yvU2JItsPnTzSAHkj49SyQqB5co697/9CG7g7g6SQdRsjyp8a3mg
   Idgj3JUz8SvKBYqPTf96v/dh/vWxg/Z0kHzhHF9xLNuCf57EzXYkfGZZW
   Fyu2eD11CluyAdEl//t23KKPKhNaMUAjiBd64nAYeHn+FvNX00eX8R33A
   4lkaHoo3lXAqRnR+qRV3pnW6q/ZmUq9WV9QNXFwHfnmo70XHWv3Y9tCRR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="311564141"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="311564141"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:45:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619125236"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="619125236"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 08:45:17 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:45:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 08:45:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 08:45:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiGwo7w6F8QueQzl8lKAl2ydZ0bNlxe9lUS2VjPI6aUUZXzKaG7gcr9cO9C5E0kDXGFw97xI+Kq1rCa7wAp/sMiAIfhLi7FWQCgjHizsmFpi8p/XXO0gdWkMkRyXoYtbT9nNHc079tEft0uEnTl5tv0ZIpowl5SQN0vd/iwhHZZRJgdLBufwvwQPD3BFwD7dAAjqORtrywIam2bnAkeS6QeUvwzdNPxmoP3bnBcXqrhRWkOz+gAuHzGbuHoxgDDHzDVIo3xylcSLS9ecPbHMVgm42ojOFk2h5Xuzu2uw6UVCjw2mEENVAefArVdj8CUslpTBt9e2Ut6zk/hl96QYjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAWi7TOX93RNjh76HXOVdJ6zl/47t0Id2TTQ1ueJ/ls=;
 b=kXKPzOnnwLY2Cg+CNhQOUq6cDeAqSjy9fYmqf8tBqrb4vupASDj2VLZgeor7kw7qAGRPoBL0dYxUXAIegScOVLOv/S5MAVPlPeXcwpEt4TytrFFdxFM/EouzeQuIkhnkWDXham8eKPi8zqPWsRl+bR5syYEp4Rn19q1Kmw3E+1pjfXacsbG/VY4x+z6+O/RkbFO8oqLxY790/ZxiweyBSAVEGFE93yah+Uny03H5qOlcR5cm5wxycjFbiumu99F80khGEmDwID+NHu8PAw4ByY9CRJoaNCIUJIuLkWRZmauk6xoeSlnhDBPBOaP0+dgssJDbwZUg6ZyXA5m2RjJRPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS0PR11MB7682.namprd11.prod.outlook.com (2603:10b6:8:dc::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 16:45:15 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 16:45:15 +0000
Date:   Tue, 14 Feb 2023 17:45:02 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <edumazet@google.com>,
        <anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH v2 net-next] ice: update xdp_features
 with xdp multi-buff
Message-ID: <Y+u6jkfVo4oZWn42@boxer>
References: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8a4781511ab6e3cd280e944eef69158954f1a15f.1676385351.git.lorenzo@kernel.org>
X-ClientProxiedBy: FR2P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS0PR11MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: a7468cee-b280-4c06-909b-08db0eaad90c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYurAydxKLsWF2ChkE+JJFWaa4QN4iiIZUrREv95n0wk49PikbAMg4KdJgQZb4+w/TvcrjJr9/0jIV32NnqVvwZ6ar3JzWs3WwNy85Ax+dqIhOAcI4RC8eKZQqVOBWnCgj48aP4NfgzUMcfGl9++11xsRd9oVNmqBVfk8jNcZP7oY05cmrTDVyrpa984TtVWMBI9u3f+iR6hV6/QHvIZhe8LgN4epal5hMzG9YrCl5FxS5koLNllga3Yvk63v7QVZwJfZjaCJ2Mg0iFDa7IEut+NWoQM8oieKBgsnx2XJ0hIUod3zVcThzei3yOrmPBJCJJOQwkvI4Vq4Vd1ygvnOmUS0rRZw6KRIhSOoplePlYXcQDo3lhakJSGAtDsMrk4OXZijwn2uoqDcf69cYIZVQTaUurKNSD8lWBp1a2HiL4Fa18OceRqzPSjp/ngLCHmqFaK073FGxe0QFKN89hVvQveduHrmAts0dS57sCc+1hlB0ss/nd3eJtbxuF3er+5lq/8Yugv1qv7h+BBZ2EBfx3tC9ysRpFmESbWGsHeV8EGX+Tsk3r8xaS9oXREYkBs1Sgl74SK4zpFCotAyRve1luDYlgnqB9HlrKI7h2B5vehkOT/cw66FcYGY3M/iYq17uOtAuk/G/RT/HBtTilmaRmJFoRQLRxPhhiK59/c6Do=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(376002)(39860400002)(396003)(136003)(346002)(451199018)(6666004)(44832011)(9686003)(6512007)(26005)(2906002)(41300700001)(5660300002)(83380400001)(316002)(33716001)(38100700002)(82960400001)(8936002)(8676002)(86362001)(66476007)(6916009)(4326008)(66556008)(66946007)(478600001)(186003)(6486002)(966005)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bTblDgytIJYgOZ4Ei0LWeSIIwJzbD/VwavCbEKh8ynBNH+Kl6wV3bCrqOyTv?=
 =?us-ascii?Q?PJGIcOgN3GRrYCGPiE5DaHofUnKuHVQhb+P9tFGulFqp+C05TsIAuZ92+4Ko?=
 =?us-ascii?Q?1HqTc1CKJQf1AZj4UokGETG4FWhbeMMK+3bFWCEHZct8fxb02gFd9Z1nx/NF?=
 =?us-ascii?Q?L41m6rU6OKpSDPBlAM8cV2Cdn7QZ2HVM/m1C3NeTl/Ihqa22e5LiUGmS5rx3?=
 =?us-ascii?Q?D5+Hi+DaLrRhMrJc7a/Mczve4oN5CBFsXG2QaabcKxQ2gLXW9XauDSiabgOP?=
 =?us-ascii?Q?YV6IIBDAoGGt8xrxwbD1wCRcKX4ug2P8kApQsp3S9YaWjH/tAGZecE+y+O17?=
 =?us-ascii?Q?mQdhpg7vb/YrRdjg29htGvWDtN2p5sPda24b/nbi8tMqOAMRRrrEBRwHiosv?=
 =?us-ascii?Q?VaTwitJFUXRDjg9wbjKs4o1ian1Fbj/jgx9vGvo2AlD/yL0ijLkqeWYXHyFJ?=
 =?us-ascii?Q?XIbjyydwktZT5HA91JcIBkrn2bzPVKnvqkr1OxfuhCFB5ocGPZFbx5R1VlDJ?=
 =?us-ascii?Q?r8GAG7ClS6pbfwji6/qh99gi5ofJw6jR52FXWS7NhsLDXpUpQ7UJTpCkdep4?=
 =?us-ascii?Q?gTQ0cABVfeeTuIGdVWTDaaUlc1c+txW4SnDkJSZt/aC+19OD8nX7db2WvTOK?=
 =?us-ascii?Q?xf2boP/gSojwvlD47bAQxSNBFBeujkpfFtouvJ6tT1aYgtRBoHbkq0cqKvnv?=
 =?us-ascii?Q?NuR4HI8RRIvyYc6jmhKv1KlRNnxyx9h6PXLriHzvnUeT+ShBTUy/p5p4Sq/V?=
 =?us-ascii?Q?9hdNfHsWm15ti34cSfCOOwUeWVxlAVpHVSwJek/bDJ3PpaJWlErPPXC2gIrs?=
 =?us-ascii?Q?rZk51zwbIW18CGIc3FqcWQZgdamf4ugfsYFqZxVVyh8pfZq26sM+YjGW5EyW?=
 =?us-ascii?Q?oS0c629NDy9+zGsF1zqjvXD85NhFZImQRe6v4DBHijOvg6Xs7EPT++WoapMd?=
 =?us-ascii?Q?/HlxolnL93tMssNHuf/Ozxze5CPUeVBEQU8urjcVNiIyBwqzZ1CdjB7nfkKy?=
 =?us-ascii?Q?MI7h1QlokQeTlDvTihXyg1h2dVBkGGm5AyE0BfmSdg8CRBxm2c8HfsKGK2xr?=
 =?us-ascii?Q?waKNOMv/jKgsJbZL954epnZ68ZdCS2QKJYlTt3yv4reLVE+jpJqVx777O27y?=
 =?us-ascii?Q?lYEX+Yec9Chvh0LNKEJLEZeT+vNM9m/9gxDdSxN6SswI0sSgKu+srx4PonGl?=
 =?us-ascii?Q?NF/tcObAbcMEJx5De5cKZSdUqPOOJkNScRjyn5r5WeQcszeJsLMNVyiyie16?=
 =?us-ascii?Q?QucJqVyGwDT1GfVh6ECnwkFHZ2Zf8liDfztwxoPRUFDH4b/rXt5CDhfhWXna?=
 =?us-ascii?Q?wxNQp6+JBXmmOuI16UX0BeM7JMx3eaxwMEaRt+w3tbsldLiQurjmU81IYlQx?=
 =?us-ascii?Q?Q13y25Icz7TDmo1T8IoojxSi6xm+kPYY4O4x/SMGLI8pdFkso1TzeMxHCb9O?=
 =?us-ascii?Q?BHyad8ZdvTFgFFI6Y2khnCnN750ax+kkUWTY+POxgL5mDQu5hKaa/+TrjHwi?=
 =?us-ascii?Q?wKQY2Xla9JuOGWrlvctrLXtNtv3V39lYz3PxnfG51FXbR2upSBS5DeYYkUm1?=
 =?us-ascii?Q?UmjB4CMPFBi96A7+qUmldL4cofRlLZveRHkzz50TEarkVzrf1wi6pY8T9cIq?=
 =?us-ascii?Q?Iizs99BymZbH9yK/3J5UDjw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7468cee-b280-4c06-909b-08db0eaad90c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:45:15.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqr/57gKbjgZ+ftBpA0CYtRGArlbW9xIu4h6/VpDE1saBX+gHMEH7FIDYYsGHZmi2Khez/cE+5qvgQzjRPHjkFWjQ7vZ9UvzcSt8upuAaXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7682
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 03:39:27PM +0100, Lorenzo Bianconi wrote:
> Now ice driver supports xdp multi-buffer so add it to xdp_features.
> Check vsi type before setting xdp_features flag.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rebase on top of net-next
> - check vsi type before setting xdp_features flag
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 0712c1055aea..4994a0e5a668 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -2912,7 +2912,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
>  			if (xdp_ring_err)
>  				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
>  		}
> -		xdp_features_set_redirect_target(vsi->netdev, false);
> +		xdp_features_set_redirect_target(vsi->netdev, true);
>  		/* reallocate Rx queues that are used for zero-copy */
>  		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
>  		if (xdp_ring_err)
> @@ -3333,10 +3333,11 @@ static void ice_napi_add(struct ice_vsi *vsi)
>  
>  /**
>   * ice_set_ops - set netdev and ethtools ops for the given netdev
> - * @netdev: netdev instance
> + * @vsi: the VSI associated with the new netdev
>   */
> -static void ice_set_ops(struct net_device *netdev)
> +static void ice_set_ops(struct ice_vsi *vsi)
>  {
> +	struct net_device *netdev = vsi->netdev;
>  	struct ice_pf *pf = ice_netdev_to_pf(netdev);
>  
>  	if (ice_is_safe_mode(pf)) {
> @@ -3348,6 +3349,13 @@ static void ice_set_ops(struct net_device *netdev)
>  	netdev->netdev_ops = &ice_netdev_ops;
>  	netdev->udp_tunnel_nic_info = &pf->hw.udp_tunnel_nic;
>  	ice_set_ethtool_ops(netdev);
> +
> +	if (vsi->type != ICE_VSI_PF)
> +		return;
> +
> +	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> +			       NETDEV_XDP_ACT_XSK_ZEROCOPY |
> +			       NETDEV_XDP_ACT_RX_SG;

FWIW we do support frags in ndo_xdp_xmit() now so
NETDEV_XDP_ACT_NDO_XMIT_SG should be set.

>  }
>  
>  /**
> @@ -4568,9 +4576,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
>  	np->vsi = vsi;
>  
>  	ice_set_netdev_features(netdev);
> -	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> -			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
> -	ice_set_ops(netdev);
> +	ice_set_ops(vsi);
>  
>  	if (vsi->type == ICE_VSI_PF) {
>  		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
> -- 
> 2.39.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
