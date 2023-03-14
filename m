Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FCA6B8E06
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjCNJBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCNJBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:01:52 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CDA15577;
        Tue, 14 Mar 2023 02:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678784509; x=1710320509;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PRwBc2mWXDwUFUu9827A7ZtM8AF2b6dqMKyzpXtPkHY=;
  b=X20eiKxIluH8o8lYWNCi1j28LKeX5M2VYK/qlf+shDVorF5l1irJ5Uy4
   N/ebsUOkh6Ut6ORT81JmjjZCSt1pqHyOjKiOI7h3XneARCoc8CcbsF7Jh
   xh4+suv4/CbHLIdpumUHXYCkPzPBXdoZRsaGzGYhLL1F+Ux5NUYRGH+xb
   dMLITb52vMquZTUWMNESjsHE3nrMZvhl+OEYkRn9QPcc76BMD8wefCzYW
   HFV3IdX/7UwsRvdh+gwaZqPar4FQQCoXQWGLyNoRlfvjOwakKSfUPWTQm
   o12KnqHYd+WyIuHUOU1SDJxvWMDAdjNStzK1utYXLktTcwII6CrMOevG5
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="317016149"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="317016149"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 02:01:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="681340987"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="681340987"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 14 Mar 2023 02:01:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 02:01:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 02:01:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 02:01:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7stEySC0gaQKjvv3sBaeAX8/8gC1u9LG+GV8Xiq+aO5IJMZtvvGoEXTYeTmwgEL/CteA24iegK/8idtVvBfQkMWGbBeO8TI9KkF/vxMdPJit6kkUyoKcY4jkh6FrdewVJO2zyP10lyZ0PAypVrb41O50aqyISO3Ukh2EnpOm3LNbt6r5fBicGHlrWzNv/dQqzWX9r2uSFE7OBgjGCEQV/bf8fr+Dc8tdYw9ISDf8c3feJa252Vu2I0QGzjUy3/q5g6jGvp7HpEomy7SKVtIgroW9d8m5UiHYP2BYAD3mTMo1e0wp8sd/KYdXPZ3nW7oG4Z3X98uI6Zhts6wx415/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=smo5gY9yR8ZCTXYg7jKFPiLRMuM7Z388nOA9fUtt8j4=;
 b=Z84ctMV9iD9aWf3WIx5l/NMMpGfI26PQ10lkiDEPw4cYn56Oj3gSLzrN4G5ggf+VurHKFej1j3ZoUDvg5AucrRuZDMoLA/yre4qLmMEHYUN72hLNT3LCGvlKmA8ysyDzQgqSBP+csfO8X2+uJoqNfSHJ3ZLKzkcPbzBIQli7ZV0w8Z+hHIJm/gPjDAYDazOmdDucYJCentxai/S7pm4WC2XnSP4PkST6fPz2yKSZISoS84ziFOKmfILwfozkoWoq1k0uP+Ee6UjmHOcyVMw4OErVC0rTkTLxklyjzs0vsZjkxwBz6ToGh5pc53d2sGPy7kmqzDccjC/fyrFWYVZ+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SJ0PR11MB5102.namprd11.prod.outlook.com (2603:10b6:a03:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 09:01:46 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 09:01:46 +0000
Date:   Tue, 14 Mar 2023 10:01:44 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Looi Hong Aun" <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net 2/2] net: stmmac: move fixed-link support fixup code
Message-ID: <ZBA3+LqAaWXDZCKZ@nimitz>
References: <20230313080135.2952774-1-michael.wei.hong.sit@intel.com>
 <20230313080135.2952774-3-michael.wei.hong.sit@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313080135.2952774-3-michael.wei.hong.sit@intel.com>
X-ClientProxiedBy: LO2P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::27) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SJ0PR11MB5102:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca127f2-2c47-47fc-121e-08db246abcf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XehmPxh+g4xpC4EuiRE29i0vunf1oFz7KL0zvPmUGQ5Mans1wmxnyRS0vNc6nAPyPy/ly2SFjtNYnJnhWp60EBJ7hbxaEDiPfUxAwX/PWo7YHdamZNiOUsLu+aEdHZz8Scwx4sk2qEmK/7lJvl0QHEyULPZJYkCxrb3soByBLSGeKD6433rrFaGjqj4hWGnhxAniEuEZSYZMKlf7PoULH8mNPAp90FklTAszSPwrHFISVhSaV/MGuMlucqFkW5EIzvuQMsHKJZzh0SRmVdWPBVKtpPXX9Q7i0fXT6DTaTQXhQp1b9bNcTApWyCR+PSscf9UG9KzYyA+xKb204jMM/3/6smitYJq/QOqQKxtkz5XZbOGrzt2aIeXacypLsPR1OQWnWOVfC2xM24/5kL3EbZ0+IqQcfpMuaAlrBN8V/tKMtdWXj7FIJw/Ih2atRRHkNJN0FNgWf4bK22aPy/BU4AMg2X9ZLfyPObR6hYgFTRufVFGiDzwfmcM27AlAsrLjiiDMWLnaThjuTtZTD2MhOaVPsTgSyO9ZcG63tAkebdzk9JZldhOiYSEH1oCqdSG/+aRvxN34KeJPB2zXq0e6acD08ng/K804/PZMmeKCkdbykaETq3NowSmmCaToHHVzxBXWBp/i/JR+fiCIxJJlHAEwagFzhTG1M9WGC6qQkB5fY9+ACkRNapjOpvAm/N2G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199018)(6486002)(2906002)(33716001)(82960400001)(83380400001)(107886003)(5660300002)(26005)(9686003)(6506007)(8936002)(186003)(8676002)(86362001)(6512007)(66946007)(41300700001)(6862004)(44832011)(66556008)(7416002)(66476007)(4326008)(478600001)(38100700002)(316002)(6636002)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xQLvtsEadMp9bX8w3W/7pO7c5FXi7qAk47XsMaUKKVyS7kilavaD01IBz9B0?=
 =?us-ascii?Q?IfuqCHAqcLEr/fjfUwMsNDhl5i28eXM39FVnOnkHTmyLHEKMLMVyKPtP/G5v?=
 =?us-ascii?Q?tkLkVWfRShUZfLu1xiHPouhvbi0txRSzfEUHxjHgsCkz7MhC+rqhZ6qZy92M?=
 =?us-ascii?Q?W40z7v5ZKhxP+G4JSSt0FT5qmYQPp/UiGo8R2QnD9uy6Xp6LgYfWoo4I1e0o?=
 =?us-ascii?Q?09F7T9IrBjvFBqA9Q5Qcdao+SjBtfSH4V8ahJoO2JbobjmUkG00Vq9AfFIwb?=
 =?us-ascii?Q?7A4eEFNBmG1Xtf/Xec9Zv6rfXnv2EizsCDyVq5aO4JKlDBg9z/fIDFo0+8WI?=
 =?us-ascii?Q?IY0Quk+0lgKP9sku1Nlpoaf9T7A+MFERDnDzI0tmNm+ecUKiCRA564rhw0P0?=
 =?us-ascii?Q?ovHXmNxCY5KZKcezO2ONZNys1vinE0FEhwF8DNKbv2B0Fs/oK/6RBetOaA2Z?=
 =?us-ascii?Q?nINDh8P0Op4cy2QcOBuH163eix0AX5WfPkgdDNx1OocEfHJEHLx3mEg/HeT5?=
 =?us-ascii?Q?JqsHDHy/ENTgsaKH8QfA56nwJ9pa8UqOGnIeWll9NRknxBpKorjBZ81d7KYn?=
 =?us-ascii?Q?mpchrvnzsdQ5bSlakbiKS65r6OSyHsnfkBd8hL6fTw2VRiKmzNPxLQNLriHE?=
 =?us-ascii?Q?NmyOv9hQ/g2qcPkid/uufihQHjjX23Atw/rUHmbpUIO+ISsGsh7rdwRIuESw?=
 =?us-ascii?Q?P418XGxRW+xa0biefHEf6RHnwMzOgiQIkU6O/ObTQN5QhZ41OJuBM2RLh9mH?=
 =?us-ascii?Q?RTOFE0JUQDzx0V+eBlJUkMdAv+RKeTgomqPBVOl3Ywi51JsAoyCJsvsPngtb?=
 =?us-ascii?Q?DBb10D88fMkGp5jxK3vBtD08cv6u5pTRdhuaYjJ02yuRN1DpVyKU+bxFww27?=
 =?us-ascii?Q?i451zz5gD8dQ12bjq5awraqFb5Z/ToFAdmKaBRlGFAxRanSR+IwDzeV5q5ju?=
 =?us-ascii?Q?hfn0HjErWTIVXFnlLoOvO8GOx7BDA4QvUfn9X5jxKf+Y0CPNNNWa/GWjVpb7?=
 =?us-ascii?Q?7yxDs4WxGwH04UDTc2RVPGouHcCuH03gUfJ0+RAStjhmpRZbWWJEYBBqwdKB?=
 =?us-ascii?Q?lAT6X35XFpcb7qPQvgNkdWqKsiIgAgCycUkuh+y2dAI1xSa3kdxGZOvWGHCz?=
 =?us-ascii?Q?GvXqwBHHmvUN/a8GmoCXO5r3T9l/qtJU52dt5IantrVApEh7GU8z2jmnAfH4?=
 =?us-ascii?Q?eb5uw8xcEVGnsxYMroUuiIVqeNislZZK/HQ3p0SXPCu4F1QaJhE6x9OGRHUD?=
 =?us-ascii?Q?v/B6/2Ag2eytNpp8oriFFZMXNirOPTDsquB+dTJpw9ABGcJ6N5Th4sIfUOwM?=
 =?us-ascii?Q?l9YEZD+4Y2JxL4215SrBH7Vp/p+Bbz5MRBSx7aUetSPCdCjxorKzcVt70pC/?=
 =?us-ascii?Q?ho560foWZ9I+yWEB+uWqt8hGNbiMFXYA8wc9hfV5ZOekODKB7XQbYq8Ly3WR?=
 =?us-ascii?Q?5pRFniHqX/ZzVHvI8jMaWtpZHfpTFDrdWlnT2bNMmk3oms8iCfQ5EUeFynBV?=
 =?us-ascii?Q?/jxS5BV0lwGnnLluP9SEv69D7SLEaL/Jt5nMjKT/5u5COB1vUgBoM43XLSqJ?=
 =?us-ascii?Q?dZH8Z+5MxDcOqRuaJo2kt4W2uRXUjaGJ1BUWqveIwIloVrILnyAZKwKxr7Nl?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca127f2-2c47-47fc-121e-08db246abcf0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 09:01:46.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvpGGnxF75Ro+kQcFhM7EhPZrntPLKtwkVCBlpL5non0S2xILIehJa8skzxfVG3InA1R5G+yLzIUnkbpl80GemTxGN7BLm6wf/1MeI6ER9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5102
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:01:35PM +0800, Michael Sit Wei Hong wrote:
> xpcs_an_inband value is updated in the speed_mode_2500 function
> which turns on the xpcs_an_inband mode.
> 
> Moving the fixed-link fixup code to right before phylink setup to
> ensure no more fixup will affect the fixed-link mode configurations.
> 
> Fixes: 72edaf39fc65 ("stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 -----------
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 15 +++++++++++++++
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 7deb1f817dac..d02db2b529b9 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -592,17 +592,6 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
>  		plat->mdio_bus_data->xpcs_an_inband = true;
>  	}
>  
> -	/* For fixed-link setup, we clear xpcs_an_inband */
> -	if (fwnode) {
> -		struct fwnode_handle *fixed_node;
> -
> -		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
> -		if (fixed_node)
> -			plat->mdio_bus_data->xpcs_an_inband = false;
> -
> -		fwnode_handle_put(fixed_node);
> -	}
> -
>  	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
>  	plat->mdio_bus_data->phy_mask = 1 << INTEL_MGBE_ADHOC_ADDR;
>  	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 398adcd68ee8..5a9abafba490 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7064,6 +7064,7 @@ int stmmac_dvr_probe(struct device *device,
>  		     struct stmmac_resources *res)
>  {
>  	struct net_device *ndev = NULL;
> +	struct fwnode_handle *fwnode;
>  	struct stmmac_priv *priv;
>  	u32 rxq;
>  	int i, ret = 0;
> @@ -7306,6 +7307,20 @@ int stmmac_dvr_probe(struct device *device,
>  			goto error_xpcs_setup;
>  	}
>  
> +	/* For fixed-link setup, we clear xpcs_an_inband */
> +	if (!fwnode)
> +		fwnode = dev_fwnode(priv->device);
> +
> +	if (fwnode) {
> +		struct fwnode_handle *fixed_node;
> +
> +		fixed_node = fwnode_get_named_child_node(fwnode, "fixed-link");
> +		if (fixed_node)
> +			priv->plat->mdio_bus_data->xpcs_an_inband = false;
> +
> +		fwnode_handle_put(fixed_node);
> +	}
> +

Now you're doing similar checks here and inside stmmac_init_phy. Maybe
you could combined this to some function?

Piotr

>  	ret = stmmac_phy_setup(priv);
>  	if (ret) {
>  		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
> -- 
> 2.34.1
> 
