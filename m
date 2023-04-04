Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF7A6D5C0C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbjDDJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbjDDJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:36:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0791F2686
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680600969; x=1712136969;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5fQymlHJQfkoMXFSRH+dNaAC/0OrLwCS5DGp1bi5nio=;
  b=dZfAH4F3qkYlGbLewNG+CSd0pWKVVB1sHW413yvzl/Lh7mlbzF5vsNzj
   BDR6jMj0O2dL4wkRVaOPeYgYEPmR9bAqeBT0HrboFpxjvAsQao4GGxtte
   8QNYo1Uk98tYSkvv2Uh6ekjl9G7eobO5ewgB7rHutDPBQ92zDqwa+Hfqn
   GQuKtcIZkcUtEMnanBRENbvowO86wdSlvZ5CmXoJSynDp1YvFG8JEGWrW
   Du0py2caChvA2QvzfBB8PbLmOR69SanVZDLpoUYNDlQE4UwQHaeqRCVH2
   dBQltAeddDlzsaK0qpvAx7gAf8TtEs/aYegiPMGi4X+3m0u7WVBb6BzMg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="407194030"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="407194030"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 02:36:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="932385863"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="932385863"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 04 Apr 2023 02:36:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 02:36:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 02:36:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 02:36:06 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 02:36:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sy1LL11Nb6DFZkXTZFCDqelf/m/F+l2Fu2uWOneZjUPxL72AhKa+TBO4WJuoajHI3idyHP1PzxC6bNuAc6ZXEbGa7V8HFvcuDgdXaQau5trO/K6Yg39D71l+h+amVvIuSUELId5auP7SPx2YLMNoTYmZ6gCC+he/DTaR9E37NzgSha/BYvfhukqTT06jILb+GR7c4vvY6v5MB7XirW1E3zYyO6H8QNBiwMVnb8HvADhebou81jLecBBthuB3qYx1MfMey4C6Og8CdzbT8niFlYAKp1lr5iyy3UD46BN4d0IAd+prXhXgmczxAjUWrc85P/KOO2ifgcTmnFKoRSVYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQoX/mWMpIZc/BsVmhIwsk26MGedTthvGNnSnvgniXs=;
 b=TWxc/IoyomI7FCab6zYJxd5gYm/0BoisFREWu9jXkTCs/pI2BT87iN3L6oMpUb1/2SZ3X/0atNRbVmNAGnOdIcd5wrAsKyyxa/fXlZDnwqRFeT3mobXX68GY8Iz047lZZfmY5c9PohVhg9YGlNJ0DVUOAK757E1FZ/wSd9GOE28gUhk+IVKmehKUlShADqNmyq3Fye8UxoQRwm38PNf2mqrfASlGdV97uxZgws8CxtDpcrQtWfJ5456pWBupt1YqCTz89kBqNOqMCdOvfWuMASvNSIk9O7Ukp1YkQ/0n2ISCLrYpNV9P5uU1NH8jhZPWBtv1gyJgXsaEXusBMzIC5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5493.namprd11.prod.outlook.com (2603:10b6:208:31f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Tue, 4 Apr 2023 09:36:05 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 09:36:04 +0000
Date:   Tue, 4 Apr 2023 11:35:57 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Hao Ma <maxwillma0713@gmail.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <anthony.l.nguyen@intel.com>,
        <jesse.brandeburg@intel.com>, <netdev@vger.kernel.org>,
        <magnus.karlsson@intel.com>, Hao Ma <hao.ma@intel.com>
Subject: Re: [PATCH intel-net] ixgbe: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <ZCvvfQTYtH2S3P6k@boxer>
References: <20230321003524.700353-1-maxwillma0713@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230321003524.700353-1-maxwillma0713@gmail.com>
X-ClientProxiedBy: FR2P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5493:EE_
X-MS-Office365-Filtering-Correlation-Id: ea0051f1-7d7f-49e9-357c-08db34f0024c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bx8O6DY1x1vNDNY8OGdBgEGqXvOEqNzSgn4n+bGc24gI2SkSSQPnl6x/EpfznZ1/liNCBgKYaTQJsSeRCfH1Or8UtGwCSIPIgl1BEllG7T+c8uvQqQCK4MOLd7fGC9x07bu5jgKpL73tnFk7N2hENZKrGuDBoQrZpd560EXKW8HCNQvUmRBEuXARV4WuqN4fvXDbQtfkJPEoYPJ99YvvPE/S+NH/TXExkCqj/XW0C9kue/JresC/43+Pzbe1us/4KVj+xCFV3KwiBL/fYSqPvYAtKSNHmf1BFlkIWb5Yf14EhKhHPAe228MS1xnQoCRHyes6etZkeUKAywm8xgcQRN/rFnZaA1rKNURKFQ29pZZMNQpfPdCerJClbB5/yhdYYXrrlohis9blkgelmBh5Iysa3PJhNEl/TnpXyyxebsRxWiUf2kqpeeO60Kc1wfJX38aOSS2r06YkSo1TOZU5xz0oJ/4UQsMMvjIpKEDjooH9P0go7WcCKkbRmIat9OLiZDlqRITLH+47G8j/kZhImlnls3cKcY4hmhg6/sr4Hvq3POTYg4ItOtBAb5QLBfxS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199021)(8936002)(8676002)(316002)(478600001)(66476007)(83380400001)(6916009)(4326008)(6512007)(26005)(66946007)(6506007)(9686003)(86362001)(107886003)(33716001)(6486002)(6666004)(186003)(44832011)(66556008)(5660300002)(41300700001)(2906002)(82960400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZFSbYT0G35AnxZASOTVXkCuY4vKYaNJYyL0iqEs+K264CHEiqjvEodWtJotb?=
 =?us-ascii?Q?yUj483qy9FAkWzHgF2DEyBrNLJv2jztpFZcoHJEyzJwKDV6Dz6+TjTcffvDP?=
 =?us-ascii?Q?Bxs+qFoV0rhxkrvWQPzZ4lccW6PmoNLrij/WBDe8C9wRBacduTfHTkuql0Qr?=
 =?us-ascii?Q?mg7T29z4NcGqKNIeIOI7pPe9zP5/zlZfqT5AcWVkx8HcyU+h862yQe1pqdoT?=
 =?us-ascii?Q?lZ5Qm6VLrSla0uY7ZSleiYqD+W7uNF6A9J4tMEP5Ikc+oyr5JdV32yz5Z1OB?=
 =?us-ascii?Q?8GBvOHW9Rcfz37n2GmXLzEUpwNCt0i8jm0V6KhfwgqRhYUlLu3wrTxdWv6cs?=
 =?us-ascii?Q?fLOF+bDTtSOObGlYhcPerob6LgzKXrZagc5nmg6HF1chw8kmw62CB9hgJM+l?=
 =?us-ascii?Q?CVKYVmpz4mtOhjDeu3xzzHCJ8DR9C5aa9IPDnAnZXv7ecSuptFTfw+BTMb45?=
 =?us-ascii?Q?E3ZuGFLIdidinnR1mvY58kDi5NYDAeGwTnEB1QDf7p+h9u5B2q8LqZLUWoFM?=
 =?us-ascii?Q?V4x5izPLCKXaeH1tWmL3F14Gni+jk2Dyy3HEPKdLshidBK0VfL674n4Kvo38?=
 =?us-ascii?Q?DgNWN0GcQKEIT/A/6eQTd3XdNUwNd+OPMdr/sKskz3k/2bTPaV+alv0lJTGl?=
 =?us-ascii?Q?U1XJQpZdNSYVRdKEOtjnE/RgPGETJivj15MizJwTsj09v7xBlvQ9j+Ngzzhf?=
 =?us-ascii?Q?loVlpC/lBrHmiaPv9dlsxl9hthmUKMwKk/53mos2qDJ7k6y3pYx8z9MQLo5T?=
 =?us-ascii?Q?uW9ATIlPzLgQGlkYKKwLK/hYmvizR5CDNPeJydWTgY2s+1Oz15CVw1X73PNL?=
 =?us-ascii?Q?p4MKtD7SXFThEGUekOWmvIapErA2tZmZbt3fITPqmt2bzdIwRodeUX83ovbr?=
 =?us-ascii?Q?XfJ44iFBsolYQ8adNvw8ZDGAfKA7K/jWt6aQU3HU6asCx7M92md3Ved2YoD0?=
 =?us-ascii?Q?IMhHSK+jlW34w+FxZAZZVFj3fhRTsqRDQfKU3J6l+axZo3G9dlV082pGUnh/?=
 =?us-ascii?Q?D/g9hR7bYNf/sTooVyKJYBCnHYAtjhxFIA0K0ny8dJcNUYziTkYlcz7+53PF?=
 =?us-ascii?Q?vwV0ycil7fvpEndfyBGtnwBd/3a/db9sCDWxN/Lua7R4+3y7hSj2jZyP+DLZ?=
 =?us-ascii?Q?lrnU+vQ0/VDTa/a8J36dOdalviRCuMpXeSYHML1qnWKOrlTRP8AG9yFspwsx?=
 =?us-ascii?Q?aXhdwHFeXNKBm6RFWqcqHO6pUlFSnVPec0B0Nz5Rr+lbh7x8YeBSQfbEZepC?=
 =?us-ascii?Q?ZZwL5mNxMcK5sQPR2fLdnvoGEZ+CzyK0drLzbuu/5ZYmjQWhmKLe2fP0A4Bb?=
 =?us-ascii?Q?VOlxB8wBvbLQvlD/Oxf4DwsQBSJ0PEUs36AX0a+diNgdHFQU39J/kQFo0lHU?=
 =?us-ascii?Q?pVIp7/VT7/eHlF9qEfcH00/bwQOi9xe1ronl+769w45j6jyF47RI84+EK5TK?=
 =?us-ascii?Q?g3V3EdZR6WQT0KgSdQoWHDYYcqhRYnZSHAK7VVqRkPsPrhuiXAGT/uW+VRzF?=
 =?us-ascii?Q?xkBEglktBb5vhS+qlQe2JOSVAoMWJvklCM+DVLQDQb79nJxBez9EnSMyduog?=
 =?us-ascii?Q?1KYel68I4VPCpkYdK7ltoDFAXPItgULgCOIf0NUZjHjC/+GRXMQt8paENMx3?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0051f1-7d7f-49e9-357c-08db34f0024c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 09:36:04.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QvYLQ8CGf0woHncLtWWcY0vRN+XRnwMix+Ma435KKzN9c6gVcevek5yrcyk/P9dOrgumfpwZbjr+uxQT4VUGhFhkdok4oIA3ENPB3pM/cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5493
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 08:35:24AM +0800, Hao Ma wrote:
> From: Hao Ma <hao.ma@intel.com>
> 
> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> This sets the MAC Tx->Rx loopback used by selftests/bpf/xskxceiver

Can you resend this patch please? It seems it didn't arrive to iwl nor
netdev.

> 
> Signed-off-by: Hao Ma <hao.ma@intel.com>
> ---
>  .../net/ethernet/intel/ixgbe/ixgbe_common.c   |  4 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 73 +++++++++++++++++++
>  drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  1 +
>  3 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> index 38c4609bd429..a39dd2d11bc8 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> @@ -3336,7 +3336,7 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
>  
>  	if (link_up_wait_to_complete) {
>  		for (i = 0; i < IXGBE_LINK_UP_TIME; i++) {
> -			if (links_reg & IXGBE_LINKS_UP) {
> +			if (links_reg & IXGBE_LINKS_UP || hw->loopback_on) {
>  				*link_up = true;
>  				break;
>  			} else {
> @@ -3346,7 +3346,7 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
>  			links_reg = IXGBE_READ_REG(hw, IXGBE_LINKS);
>  		}
>  	} else {
> -		if (links_reg & IXGBE_LINKS_UP)
> +		if (links_reg & IXGBE_LINKS_UP || hw->loopback_on)
>  			*link_up = true;
>  		else
>  			*link_up = false;
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..e5624d1fc6c3 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -8874,6 +8874,57 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
>  	return NETDEV_TX_OK;
>  }
>  
> +static int ixgbe_force_loopback(struct ixgbe_adapter *adapter, bool on)
> +{	struct ixgbe_hw *hw = &adapter->hw;
> +	u32 reg_data;
> +
> +	hw->loopback_on = on;
> +	/* Setup MAC loopback */
> +	reg_data = IXGBE_READ_REG(hw, IXGBE_HLREG0);
> +	if (on)
> +		reg_data |= IXGBE_HLREG0_LPBK;
> +	else
> +		reg_data &= ~IXGBE_HLREG0_LPBK;
> +	IXGBE_WRITE_REG(hw, IXGBE_HLREG0, reg_data);
> +
> +	reg_data = IXGBE_READ_REG(hw, IXGBE_FCTRL);
> +	if (on)
> +		reg_data |= IXGBE_FCTRL_SBP | IXGBE_FCTRL_MPE;
> +	else
> +		reg_data &= ~(IXGBE_FCTRL_SBP | IXGBE_FCTRL_MPE);
> +	reg_data &= ~(IXGBE_FCTRL_BAM);
> +	IXGBE_WRITE_REG(hw, IXGBE_FCTRL, reg_data);
> +
> +	/* X540 and X550 needs to set the MACC.FLU bit to force link up */
> +	switch (adapter->hw.mac.type) {
> +	case ixgbe_mac_X540:
> +	case ixgbe_mac_X550:
> +	case ixgbe_mac_X550EM_x:
> +	case ixgbe_mac_x550em_a:
> +		reg_data = IXGBE_READ_REG(hw, IXGBE_MACC);
> +		if (on)
> +			reg_data |= IXGBE_MACC_FLU;
> +		else
> +			reg_data &= ~IXGBE_MACC_FLU;
> +		IXGBE_WRITE_REG(hw, IXGBE_MACC, reg_data);
> +		break;
> +	default:
> +		if (hw->mac.orig_autoc) {
> +			if (on)
> +				reg_data = hw->mac.orig_autoc | IXGBE_AUTOC_FLU;
> +			else
> +				reg_data = hw->mac.orig_autoc & ~IXGBE_AUTOC_FLU;
> +			IXGBE_WRITE_REG(hw, IXGBE_AUTOC, reg_data);
> +		} else {
> +			return 10;
> +		}
> +	}
> +
> +	IXGBE_WRITE_FLUSH(hw);
> +
> +	return 0;
> +}
> +
>  static netdev_tx_t __ixgbe_xmit_frame(struct sk_buff *skb,
>  				      struct net_device *netdev,
>  				      struct ixgbe_ring *ring)
> @@ -9923,6 +9974,15 @@ static int ixgbe_set_features(struct net_device *netdev,
>  	if (changed & NETIF_F_RXALL)
>  		need_reset = true;
>  
> +	if (changed & NETIF_F_LOOPBACK) {
> +		if (features & NETIF_F_LOOPBACK) {
> +			ixgbe_force_loopback(adapter, true);
> +		} else {
> +			ixgbe_force_loopback(adapter, false);
> +			need_reset = true;
> +			}
> +	}
> +
>  	netdev->features = features;
>  
>  	if ((changed & NETIF_F_HW_L2FW_DOFFLOAD) && adapter->num_rx_pools > 1)
> @@ -10296,6 +10356,17 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  			/* Wait until ndo_xsk_wakeup completes. */
>  			synchronize_rcu();
>  		err = ixgbe_setup_tc(dev, adapter->hw_tcs);
> +		if (adapter->hw.loopback_on) {
> +			u32 reg_data;
> +
> +			reg_data = IXGBE_READ_REG(&adapter->hw, IXGBE_HLREG0);
> +			reg_data |= IXGBE_HLREG0_LPBK;
> +			IXGBE_WRITE_REG(&adapter->hw, IXGBE_HLREG0, reg_data);
> +
> +			reg_data = IXGBE_READ_REG(&adapter->hw, IXGBE_MACC);
> +			reg_data |= IXGBE_MACC_FLU;
> +			IXGBE_WRITE_REG(&adapter->hw, IXGBE_MACC, reg_data);
> +		}
>  
>  		if (err) {
>  			rcu_assign_pointer(adapter->xdp_prog, old_prog);
> @@ -10979,6 +11050,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (hw->mac.type >= ixgbe_mac_82599EB)
>  		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
>  
> +	netdev->features |= NETIF_F_LOOPBACK;
> +
>  #ifdef CONFIG_IXGBE_IPSEC
>  #define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
>  				 NETIF_F_HW_ESP_TX_CSUM | \
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> index 2b00db92b08f..ca50ccd59b50 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
> @@ -3652,6 +3652,7 @@ struct ixgbe_hw {
>  	bool				allow_unsupported_sfp;
>  	bool				wol_enabled;
>  	bool				need_crosstalk_fix;
> +	bool				loopback_on;
>  };
>  
>  struct ixgbe_info {
> -- 
> 2.34.1
> 
