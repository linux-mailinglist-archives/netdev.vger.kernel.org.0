Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0058E6B9184
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCNLVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjCNLVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:21:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9823F9FBD6;
        Tue, 14 Mar 2023 04:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678792879; x=1710328879;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j5RfpFoGWQFUgOSyuslq4GilOKjBwT0pindTDzJ8Kag=;
  b=Ip7B6YvF1rtOB1D4StTyQm5mEvi1s/GRkyYA5wrLrk0RIMgXdYOQUd5B
   RiwknJ8x3zGEAP3kCtfpkSLmo74Pv1rRIfpLliu8/MTf2pFJg4G5btB0O
   WqpZf5SF6WWfz0bI8Arr8LNMZ9YJtiwirAnUbI3dsXPOc+t+g2wGAjwLw
   uRP9/x6LfdVppIWFpB6itHDXE272TjjGsHFpgNBb+fvhlHWlRBTIZsUvG
   Ak429Lkpop4aVRejdenlmi3tk3FRb4DsZ/PAVIr5hbYucWHcxJxscrqQm
   INnFYKtBWIOT3VwjkcNUJloP1fsJouwt3zznG2myzX+r0vLVeOtxy3GcU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="337421380"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="337421380"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 04:20:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="743281845"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="743281845"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 14 Mar 2023 04:20:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 04:20:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 04:20:27 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 04:20:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cevgGpbHDRO5R/Fc2iI0TjQRz51Y71xuaPxxVE/8M4zwo3EJAEIme3+W+u0dymwQSBWii/o7IVPj2+bFoRJjNyQIFjG9qx8wmGD3Vdl4rEbowSettL48Lgrtq9TnU14wx7fPyNqUJQ6vOVV5/3BDGr5jfR/hjlOJrPLALknyWvrkwPeBQOnPmyHUzTB7ID3m/GlclfQKC0Sz1+YRlTS6qflcjN8E4Z52vrTbxAbNHMltXpfaLNPfLRV5RBOyZ6B+4TE378O5B2bSAaU9ox+BgiW3dYbgGsHqbHoHz4WPPy3UtmfbaWNkV7QDlG4YPv+8P5Sc1L5P2TphwuWt7nprEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDvoR3P2lSqWaV31HssjPOgE1bYRXr7uQVrHtoyzAb0=;
 b=Qx0t4vxDkckX/dYu+CTylam0e10JadYr+6eSLUKZR9KbPKg1IakFmrjtVKrAdldMT323XpASa1PYZZQC76qHhW39Ka6gInbNLxqFM6/jkA6yxIkEvuyPIg2JOHS5QxLEPzW9Xc0/ZdlIpyFhsiNnoVcWgP2oPxtCBLdES574LKYD8dbh1HHVIHzi0rB4vlTzONwhEiBQPk2eNCkbD+Usay0v6yPXJK96fOhaAS+X2O/kMllrNHDmtIANcdNlz7lHwU6iC+ggpy6siaOzGbdHMOiHoLISJPdmaI6oYAxxp7jlvLhy/xSd2HyC4NsrlWai84ryhAjh+ej/idfjOaYpIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SJ1PR11MB6156.namprd11.prod.outlook.com (2603:10b6:a03:45d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 11:20:25 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 11:20:25 +0000
Date:   Tue, 14 Mar 2023 12:20:18 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Jose Abreu" <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net 09/13] net: stmmac: Remove default maxmtu DT-platform
 setting
Message-ID: <ZBBYcnh51WMutdG8@nimitz>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-10-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313224237.28757-10-Sergey.Semin@baikalelectronics.ru>
X-ClientProxiedBy: DB6PR0201CA0031.eurprd02.prod.outlook.com
 (2603:10a6:4:3f::41) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SJ1PR11MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 669bc0ff-6e91-440b-3f86-08db247e1be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5IN1hdHCS8SeNIDEEWUuhIuc06wjBnkWQJf1QH9hHz9ucTlbfeSxjc90fjLKCw5OT0bv1xxEQ24w3Y1+F5KasSuXDCxFrWasFqM/P6PVeMSsZHGJpBNidt0pxtGPQlIpsgY82uF4/YhM1ltdqX/JBL8k46CUJIzNx+VWqokCvTS8n1hez2fvEisidFxuZZ6XmFCyX5bb3eK8v0BCpua9Tds3dNHFg3aiI70G6YA4plfai8SgQ2vqu/5JnUGcbL+WkxfLDO5QfEzEJRG5dqPLXsjbVC7jgIPRW3OoF9NZMYiNYvQxZ9BWZ7rhbjuIbBhF5kP6MOHJu21jIQy+qjvCa86TdRnogLjq/6gsmW6jQ7vTVIv5G0k7BfBziV5SGJKqOmFBMW/KnqXIoIHoWJg0rO+xidGpz04oTUX0qEkm/JzrI7Xxly2fB+kX3U+77Mu0g7GYd6YLTXZknE+B7sMPszHxfvhUG32G3f9aoLf7fMpt9/fQV7zK9Y1wx1v1N0QmekJYgOzVhiN7qKgQTSkkgBQWJUG1HRxKmM5bA6Jw627PnFWyMIwuVBywsOvFuXdOPJDUQ+h1EeBqOgcDGv45Rltf6gXF5DnClz6QmnRnyTuM6yCywMFjBM0c72RZ3kV/LXI+y2eebTGAl/1qDFx9Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199018)(316002)(54906003)(83380400001)(478600001)(33716001)(86362001)(38100700002)(82960400001)(6506007)(6512007)(9686003)(186003)(26005)(6666004)(6486002)(66556008)(44832011)(4326008)(6916009)(8676002)(5660300002)(66476007)(66946007)(41300700001)(2906002)(8936002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hlbuZco8CBt9YbeKRZ4NuS4ALzWsxwQpn09lzDMN44iIpKxP4V84eFxb+Q4G?=
 =?us-ascii?Q?ElKmC46LEI6VS7IT29Cy8V7oKtiD5mbpCMT6QlI6TOvJ/pJTMwClj+GPfmbC?=
 =?us-ascii?Q?9Su8LzQN/i58MrpLzr50cuOx+c2R5xYKqyZHrhjXLRR0TyNdCGL6XkrpYWA3?=
 =?us-ascii?Q?pzhstnLqtSwwJ9fiywkNRvHwl5ixqqW7eCZGXEVNMpk/jlRpR8OkR5d7wuhK?=
 =?us-ascii?Q?sNmuzBZ8Wjghopp96w2mv0VGKyX0FRiS5+ezm38sFlOPHZGqIjEG6hDU+ol0?=
 =?us-ascii?Q?H1NXP8+z8Un2cHjLXx2MV1rxyuGQPNkeSQEdChiNTW3BqGpmCJsIhAr784fd?=
 =?us-ascii?Q?/AVw01DTuAn/3Uz/e0+wWwJ5vBHUseZzeJL7f35CkYrXBjOwBx+6YnEDngYL?=
 =?us-ascii?Q?6JIaDmEpHZcnm6XsH1IyipcUcbYRQTHGMywXdZ8hxVcC+NlOVYHFrcvin/mj?=
 =?us-ascii?Q?FhkxPiwTzDx39rVpd5dI5t7E8iF9Ks4XQ4akVoZZ/MdtkDhRPqBM4Azl9sjx?=
 =?us-ascii?Q?8Lbt7Oa67MhZlHVznpTUrwzMAZgkEXjECig6voarRHYl+U4Kb/vE7MXGIsve?=
 =?us-ascii?Q?Kx2pBrT7ER4kPqcKZJCmS8Y+0PDQy3DmnWhoGWjAeD+2/K1tF8f2SqxXOYAP?=
 =?us-ascii?Q?FROEKrVDgDFDcMXVj1Bt+IBCKJsO4bUe+o6tMnHN58JppFtzQ+fubTNdq9ep?=
 =?us-ascii?Q?61NkvUedtH0OSH6yOyBj/mXiKeWMMFncNxTVrsANDVDO/2mkzlYc+4q/Yq+3?=
 =?us-ascii?Q?ZgdrO01hWof9W5Ff9DUOSsxFX0gmUr7hPUgysnqMHuvjcyG77Z4bpHPwHaO9?=
 =?us-ascii?Q?iVMv0R+kgAZPb3ix5XYXkKljxZV8AFIjz3OZ9whlDj5CwwHVK6rh1UcD1DZU?=
 =?us-ascii?Q?W0TbrTu5e57FP0RQ7unDvi0yPWI8IrPpR7IbkukTQHNWw5AsD2YXkIY6ex6E?=
 =?us-ascii?Q?a3lWpAcdcWLBlFuqvFL1mX0PmxyWt9HIj8D2LuBY5TReJgLXNNxA4liKc2km?=
 =?us-ascii?Q?vK2CNIhb5hxnw3pok+Dxs46Qh4E8S5V6iadHB664KAgVvB+xIn1vyEvZwRSC?=
 =?us-ascii?Q?JqidcOeA82EpcD0sulfufkjwnlauZIAaFsEVKwa3VGpUQaUigaTH+7v+FlvX?=
 =?us-ascii?Q?m8f7wrG/l2Ps8vzYKVHAvNstucqjZ3WPosAY4jpop4b03+n5vFU0o4MZRs7d?=
 =?us-ascii?Q?tFNFuk4A7PBl3sVL66dgqRZY23ysCj0rWenSQm3YIZUmE1P3du2QWCo2wQg9?=
 =?us-ascii?Q?yRiSKmhht63GeNUiUhgttZ2zip2FDZRBoLJMlNmDsBNttWQx6n1FqIwNaP7O?=
 =?us-ascii?Q?5c63e34XPXJszuVw0JPuB+zYsXqQ+iFvn4rAQBzP5fZDM7bUFWPaWTErCx8I?=
 =?us-ascii?Q?lMcoIh7W+xP/UCTXZDHHhcMFVeKm9SakR/ySa+8oPSCX2mDj67QxoxbtgVEI?=
 =?us-ascii?Q?vbMx2+RX802Nnve/sW4ABLVWnGed1SWE6I84LqKjqlRspwwuk3c6yv4Xqx0T?=
 =?us-ascii?Q?mwSQvnMbMH/3i7KIqKbBAyTFG7af9HAsLxsLsbfoYoZGDl2nu/Dwue7ajGW3?=
 =?us-ascii?Q?IvsH/JQybGEOuYxcDWl47c3xMHAOepKVBhtg4ugh5p8T/SEqKpzln+zpGB2e?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 669bc0ff-6e91-440b-3f86-08db247e1be2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 11:20:25.6910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLvu+1FXxQsR5U52MkT9JgDPBzlGrAQdiOrFDiyVjU/SJQXcBA0swu7bFAKVUbAEM96d54kvOWfS1G9ijDykokmUDKqGg8v0H7cTexdFfbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6156
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:42:33AM +0300, Serge Semin wrote:
> Initializing maxmtu platform parameter in the stmmac_probe_config_dt()
> method by default makes being pointless the DW MAC-specific maximum MTU
> selection algorithm implemented in the stmmac_dvr_probe() method. At least
> for xGMAC we'll always have a frame MTU limited with 9000 while it
> supports units up to 16KB. Let's remove the default initialization of
> the maxmtu platform setting then. We don't replace it with setting the
> maxmtu with some greater value because a default maximum MTU is
> calculated later in the stmmac_dvr_probe() anyway. That would have been a
> pointless limitation too. Instead from now the main STMMAC driver code
> will consider the out of bounds maxmtu value as invalid and will silently
> replace it with a maximum MTU value specific to the corresponding DW MAC.
> 
> Note this alteration will only affect the xGMAC IP-cores due to the way
> the MTU autodetecion algorithm is implemented. So from now the driver will
> permit DW xGMACs to handle frames up to 16KB length (XGMAC_JUMBO_LEN). As
> before DW GMAC IP-cores of v4.0 and higher and IP-cores with enhanced
> descriptor support will be able to work with frames up to 8KB (JUMBO_LEN).
> The rest of the NICs will support frames of SKB_MAX_HEAD(NET_SKB_PAD +
> NET_IP_ALIGN) size.
> 
> Fixes: 7d9e6c5afab6 ("net: stmmac: Integrate XGMAC into main driver flow")
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ----
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 5 -----
>  2 files changed, 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 32aa7953d296..e5cb4edc4e23 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -7252,10 +7252,6 @@ int stmmac_dvr_probe(struct device *device,
>  	if ((priv->plat->maxmtu < ndev->max_mtu) &&
>  	    (priv->plat->maxmtu >= ndev->min_mtu))
>  		ndev->max_mtu = priv->plat->maxmtu;
> -	else if (priv->plat->maxmtu < ndev->min_mtu)
> -		dev_warn(priv->device,
> -			 "%s: warning: maxmtu having invalid value (%d)\n",
> -			 __func__, priv->plat->maxmtu);

Looks fine but by removing plat->maxmtu = JUMBO_LEN; you eliminate the
case of dev_warn here or you remove dev_warn since the driver will be
able to fix the mtu value?
>  
>  	if (flow_ctrl)
>  		priv->flow_ctrl = FLOW_AUTO;	/* RX/TX pause on */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 067a40fe0a23..857411105a0a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -468,11 +468,6 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>  	plat->en_tx_lpi_clockgating =
>  		of_property_read_bool(np, "snps,en-tx-lpi-clockgating");
>  
> -	/* Set the maxmtu to a default of JUMBO_LEN in case the
> -	 * parameter is not present in the device tree.
> -	 */
> -	plat->maxmtu = JUMBO_LEN;
> -
>  	/* Set default value for multicast hash bins */
>  	plat->multicast_filter_bins = HASH_TABLE_SIZE;
>  
> -- 
> 2.39.2
> 
> 
