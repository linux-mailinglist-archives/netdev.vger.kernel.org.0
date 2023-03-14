Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5526B8D31
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjCNIW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjCNIWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:22:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C3199C3C;
        Tue, 14 Mar 2023 01:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678782069; x=1710318069;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kX31h7EHbiLIDJtzvHxpAirdAJ/Ju37hr9saytdnvBU=;
  b=ghM4ItoAeVav/9dxgraT17PHkAPZjQxpUHHQkLkUXKQsKIQSXHAKaZPq
   1QVqMFPNq/st1kfMomaLlMAQC7ug9w14Y+jgqIAwS/lBI7W0LwZTxNYNI
   y5WWhhtmGO/Vi83aQOPEI6DT0GQmnyWcoZHCirhIleFMeZ1HWf9/iHRyC
   mTfvpK42sDQOCAIaZi4TUcUry30nm0sAlcAZPn7tuW1pVFdt62pE2a7se
   InUvx8AOr70jBz54NAfMl1vLYUaRj52Rl53J42skKOSw6LjnxSeExcFyB
   tUa+319JcKCxrGD19ZKK9IyJdbD0ZkmjO3JcoypsTwcsoEaKpPSV5UPSt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="338904956"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="338904956"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:20:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="768005002"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="768005002"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2023 01:20:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:20:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:20:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 01:20:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 01:20:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INr900SwvhNDxMxVouSK7YQ4nlsPHiFSNePAhjDud2LgGMYWClUZSnCBY8rGuHpTZR/S9pRnLl9dtkP68S/Vuf5eckYfw1ro4YVtjiinQ8eSekUem0S1psxcpsg5LoqXyio98Mv+aZcU5DwwjS/soipwb3x69ZecCwuc/fZ4puE5XSinUywagdE5BM4CDROXppxrNWQGyCBNMsah1hGz/gVpC5yS4m6YjliVcxc9zAoMu/UW0IWiJXXaZjssY9Z0wDGxIlMLXLe06sxq2z2lDHTURxicBB+nlxJy2ON1cvEnMLhm08veIgIF82m5jdCoUrdFgfTIWwkAiN+ZJVUoYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=362/n6/aC1/ZpigwqkP5lGSQo6iVCOhAOJZyZfIeXyI=;
 b=ERKSxJ3Ghyw1+Rny8Krv+2L6Ev0bmKGD0mbPm+IhVLEsC3Ly9YaY9A+aYGQQFwHRe5yv0evaHmbOEdHqhixgALYCSGh9RjbiX/4FHQ8WvSX5PMXia8WIXM87597D2IBMojt/t5bB+pKVdoe/ohgU0yi6POunHtR+3BFEHb3+8aAa/RNU5mTYiCKNb4MOKvTzS9J8+TXXDoTTgw5+j3EOVHje0hyfga7tctDecFA6aiTna0TQGzrrROA5LdWDD2FR0lMDqzlI+N+eqo5JIKq/6SD1DywDgJ7LAnq+jtTjonhFALx/Hl44Vk7erU2+gL98fDp7WNusA9X1TDNI6y1IkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by CH0PR11MB5345.namprd11.prod.outlook.com (2603:10b6:610:b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 08:20:54 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 08:20:54 +0000
Date:   Tue, 14 Mar 2023 09:20:42 +0100
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
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Qing Zhang <zhangqing@loongson.cn>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 13/13] net: dwmac-loongson: Perceive zero IRQ as
 invalid
Message-ID: <ZBAuWk9lnGjeuvKC@nimitz>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
 <20230313224237.28757-14-Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230313224237.28757-14-Sergey.Semin@baikalelectronics.ru>
X-ClientProxiedBy: LO4P123CA0645.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::16) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|CH0PR11MB5345:EE_
X-MS-Office365-Filtering-Correlation-Id: 3926236a-d598-4351-73d1-08db246507c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZrWt7NMDYJa8Q2Qd2jRz8fB4eW+sznnEl7DvU95BnIc7hjhr9F126hBkO3cTEHJeLN+rbzX1hOlf9jVbqIP54oamYUehD/Wy7kEjcRuNQ5Ol1PxuNn8jk7TEXour+ier2RqNGzTORra07+BbyXsmgtev2/CkZCZll/vc/UvFlMKy7iuiW1gVqKqPROfSQOIpK/d8gXiHBhz29OXc28LSADtE2RbM7bTLf1BvROF/0ZjDXmDzEGIk9G8LuFEHQTEwV5teu7euATFYRRPMa3QrUQDCpm2SeuQOCKZpoZwEL+/dWErTN4tnHwElSPNkjFK2zq8xUq87RwF3NrTTWnRQ1NpGEmGPwTeFT6bg5fjCVm1hCSfKUhyEltes9dEhAiRmiGA806l9s5rSKR+b6/gg0gLRQr6gWuUpstaim/x4hlfRs5JLk/zDbnhSTxxnNev6foXyIfoUA2ySqBsjoKyG3UrLJdcRgkZX1RvGup1tDrw66cznSoP2zXqJfB9s6f+aqgvL1ejt9Y3chJaZiE8++JlEddKcD9SzwpH9kTkaiEEhbR0bx894iYoery5MK214e2aK2iQNvR4NwbDelKfQHox8wfRsGtYTSUn7KAR/A2o5ceCCZ/ERJhdiBoK0Wv+RW2FA6TVqNFx5qdr3iwbRJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199018)(316002)(54906003)(478600001)(6486002)(7416002)(5660300002)(2906002)(8936002)(44832011)(66556008)(66476007)(66946007)(6916009)(4326008)(8676002)(41300700001)(6666004)(82960400001)(86362001)(38100700002)(186003)(33716001)(9686003)(26005)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fcEPFjxYvPiUrW7UnE7Q0suGhI5X1FbV7iALsjlxUk5reAoKBgZCCCnDQtwK?=
 =?us-ascii?Q?wSiei0BDnpVQ/X+KNd6cbXzDhjKdrTgC6nWmJ0/iAD5DWaViVdOPY+jJPaYw?=
 =?us-ascii?Q?BtZCJIBWgx6hMUMSPPp2wofsrLzlyZIuUzmBqsSNdigIGWwA32lrxNNEiIC8?=
 =?us-ascii?Q?xaetEiTWjzWMIC0z0hE8aeQ6W5E3oKn5vdmGjT/gE7k4GtzGGSxzxIJ/SCz+?=
 =?us-ascii?Q?nKfzuAVEeDQVphQWnD6KWvcqoTAFQ5X8IybvdwLQruJxPjEWTPABigizWnBi?=
 =?us-ascii?Q?OpsC9bpuo1bjWJkmVc5LDC66V95c7ehIyy+LVrVsnmpuDlHX+hHjSVZzv9HC?=
 =?us-ascii?Q?kLEzJCr8P9ImB7Izl10q7nTkDZLiaTKqBsoY2ulq5yrJdY1oe8jqwtU69zA6?=
 =?us-ascii?Q?XgM4PZPkpz+4vTcvU2/6uoV1HU8ion+k+FvfAE/RUnNuJPYgx+gmfB88NVbm?=
 =?us-ascii?Q?4K0nuoSgZ8Prz6paJmoL+k2c569UUEwqMBpib8K5YI1f9ZZK2uDSkQUJZUMD?=
 =?us-ascii?Q?ibXnwPsC6HcZG4Rz3FQBtNnzOj13Nqn+sy7QhDeV9ez2jQJoh97SGXWfQre/?=
 =?us-ascii?Q?G7RbrUo+LLcD/rfmLe1fyxqIbGNvzYZ1StrHQ/D0a1wAHlKXwyAqSYVkB9pX?=
 =?us-ascii?Q?5RLC7loQPd9275OEibYZ5mORyWLl6YoXQ8I9m1VNgm1by6Yt+jkP2vSfgkUZ?=
 =?us-ascii?Q?MRpXLW2A2JPctHSDS1ojvhTvInI7j9ps6++fWEtS+t6BQ4DeEYEfQefbvRei?=
 =?us-ascii?Q?hD+wcKoSSxja97184a/TEMQTghfSkueknGNhjAaRSu/ZNDpAvG8ZbKXFcXbI?=
 =?us-ascii?Q?nfcyAe/y3xevu5dD6lc3YP/kv7yBuOc8Sn1QPOvQuIzNI3FbKgQY4fIA0ynA?=
 =?us-ascii?Q?4Jh+v8XkfnPqd7BihAo3uItuzrlHgvxu7KQ6gmFVDihJHWeLYHL4oF8zYjKZ?=
 =?us-ascii?Q?egquvNBnLohiAQGpXMnWgTkPc7YHtTB129448t+wkRRubpwzFxJAYcOUdfjG?=
 =?us-ascii?Q?m7L9fY25bUYx1wxkER9Ilt/8w4CKudordU2eCJFqnNRoS1Cq2KEmSG2s8YFH?=
 =?us-ascii?Q?cTiemQJUfCrE+Vrkn6AiuURFX8t3ffyXTXTMbMCk45N9bHkS04p75YsG4U7T?=
 =?us-ascii?Q?3+6dTcDwKra22aNpYIlJITX3rHNIwoOjKPhVAy6vSnhxaAHQZE+hTNmB/Hpn?=
 =?us-ascii?Q?/NMkvTixnUhTLKNjHyeqbwe73N5xk9U7Ryn5QZFb35dKcvRYTOy+Zpq98v7Q?=
 =?us-ascii?Q?r2x4Hl/xwxWOWVzmx8eVQi30ygVeFDiIrtVFsy+CPvB++dikfwAoTzztky+K?=
 =?us-ascii?Q?OnwCZwvafB5iOr1pzxhXoueqjwySUOlocYLI6AKJGvmrZ2Z1+EBxu2y8SFcK?=
 =?us-ascii?Q?w74CDISTzdQMDT3V9Tfmcc2Gl+k/F/EhXEWs99IS/kOUSC+hhPqPK/AaEbxy?=
 =?us-ascii?Q?u8qoyUlcMkUeLCG6jQ4AtVcJDGa9jWNmJlfJn/b6oYD0UgcL3ejU1MTuBks5?=
 =?us-ascii?Q?LSMv3+ppT6qO4t9yjAVgMR3Zt+cbrKoeAWMDXXfDI0DnE9GY6uaW+JTcyg+H?=
 =?us-ascii?Q?1U7m+LsnaeWke3oUZKcrbnQC7hKf4Sc5tWuyt1DSFw/JKNefqKZWHqyDlQ45?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3926236a-d598-4351-73d1-08db246507c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 08:20:54.5478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0efHE1Co6iblDjDPAYs1dIJJ+GdDt1bxbkIz+LzjpeJSTpyblRv1oqDJv2rU9dgB+r2O/9fYmrCAfy+qutRvKT+u8hn3EXhx5PmSFEG+05Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5345
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:42:37AM +0300, Serge Semin wrote:
> Linux kernel defines zero IRQ number as invalid in case if IRQ couldn't be
> mapped. Fix that for Loongson PCI MAC specific IRQs request procedure.
> 

Looks a little odd but as I also checked and kernel does seem to treat
zero as mapping failure instead of -WHATEVER.

Fix looks fine.

Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

> Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> index a25c187d3185..907bdfcc07e9 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> @@ -127,20 +127,20 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  	res.addr = pcim_iomap_table(pdev)[0];
>  
>  	res.irq = of_irq_get_byname(np, "macirq");
> -	if (res.irq < 0) {
> +	if (res.irq <= 0) {
>  		dev_err(&pdev->dev, "IRQ macirq not found\n");
>  		ret = -ENODEV;
>  		goto err_disable_msi;
>  	}
>  
>  	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
> -	if (res.wol_irq < 0) {
> +	if (res.wol_irq <= 0) {
>  		dev_info(&pdev->dev, "IRQ eth_wake_irq not found, using macirq\n");
>  		res.wol_irq = res.irq;
>  	}
>  
>  	res.lpi_irq = of_irq_get_byname(np, "eth_lpi");
> -	if (res.lpi_irq < 0) {
> +	if (res.lpi_irq <= 0) {
>  		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
>  		ret = -ENODEV;
>  		goto err_disable_msi;
> -- 
> 2.39.2
> 
> 
