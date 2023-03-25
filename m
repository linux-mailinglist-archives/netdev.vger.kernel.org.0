Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0376C8CE4
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 10:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjCYJKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 05:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjCYJKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 05:10:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2094.outbound.protection.outlook.com [40.107.94.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5E69034;
        Sat, 25 Mar 2023 02:10:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAlib8/mEcWNixnT49NNWYkodncDQh7G89rYVtzNL3QT/UWqnpnxxpXRgsIjs9rxA5phqMCi9j5hfmh99Nwvcy9OnT7yiBtixnAfKsf9oqa2JeW2Diz3JGaM7tp8PzFIiVKrVIPR7pefIGCUk3d5CQJUi3Vewlfb+G6HY+OBbx9lgmAg8GLbx4b2vDtlSAKIhpD8BDq27od84okOvdD+SBpIwP8pTq5hq+sN09eXSRBsSj4jeHN8HjtMkdsKZUFb3S2gJLXzxHtTwIW50fzmfkVAhQibNs0uyWhzEN3AHcUDgjXDPlku+5gLpTSyfpbf3TwtI0NYPUH/7wopLJ5fZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxtbl8yU/r3PWwRc3yrUytXQBVMquszxDa7F3cGgV0w=;
 b=TZbhe1TVCOf+gi6yrRDIaGCEXdd4Iqtfb5VLxVv9qMCgvCfgZWotTbbxX8mOZQoIsMoRZvyc4nv5RU4GWVWzYZpFbjFz0pzRPBAD90KmDqzVGFk7vzFdJZj3gL2MWZWSYAXeJJKADF5fmESWc9rf3Z9GeebH2jBvL69xK0RU9C/GpZfZ7ysPGWFmXpFGqt0ChtJH8hBhHZPupU0HRp2Ie7vCDR442K3StUgbWnBVK7MBguEqZab94gapr8yIin3kQjNYFKm5Wapp2qYxUJzhHGFvuL8Cv7OM/yH1znOAFbcbykdz9fUwtmhyNk3zzfJRlTDYlIxXhqTKsDaz43T/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxtbl8yU/r3PWwRc3yrUytXQBVMquszxDa7F3cGgV0w=;
 b=Eg6GOZe5xpCx1l7F5ERSCSxOeC5ka8uIhVF46BNaJEikYLeJLZMmSaeu76cXaA3beAr2jrzx7kcckFJpTmkjQtsC9zS3M8dxCAVmXL/1MZ0zTQlgv2dtd/X59YdARBKwWKdUu3RGvZETBdpPFAnwzhPk07RhBBxbV3DbtB03RD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4080.namprd13.prod.outlook.com (2603:10b6:806:9b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 09:10:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 09:10:37 +0000
Date:   Sat, 25 Mar 2023 10:10:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 10/10] net: sunhme: Consolidate common probe
 tasks
Message-ID: <ZB66hgG2+nn6CxS7@corigine.com>
References: <20230324175136.321588-1-seanga2@gmail.com>
 <20230324175136.321588-11-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324175136.321588-11-seanga2@gmail.com>
X-ClientProxiedBy: AM0PR04CA0052.eurprd04.prod.outlook.com
 (2603:10a6:208:1::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4080:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d6b8c63-8a8b-4825-4aaf-08db2d10cc1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ubVcWXdk1KlpP3PsYvPpgCxi3J1ezizqxIY6CsN6V9I63grLd+3Jt2tqppadc3Vm0STVFjCD1dBHTcxzHsSwcK2LthELELIltx2myX7f704VWX3j5RyPfdPNuxobZPiDTymPhiWz8oIspSppaJ+jHuikW+Wc6Kaez81ycVvU7u+0u72Laq00exdytiv2o7T/o6lQolt4sCyunddr2TkDJjNMQceJr6vy9uPCFn5zpoozwcjfSpTk+EuBsqFNnTziu9rBRHxrDeV2uj80dSYvd9kN0ZdiSkS64xPL4WeXSFS+vKim02smDuG88aRB1lyWmbmUmZF+8p01Ehajhjzn/RUYapAcFvsl4J1g9D6wWgAiir5izVzzTyFEbvuL61rHL5dY8lFvS6ig8SifWMqMXrXZSSijO7xc8wgwZZMWMKu4/pECLK9iAW35afq80w9VQZ+jvLkECNuyWj8oPe/HoITWKOfuHy8ggD3JEESJ/Au/gphGSnOFPL7oiYSQ7PZ9/dGi/1F9XyVuPYO78g9Pm5IlXVHKUTYKaGJDhsjk+pp1F5z2bd0VGTrFX22xcKZzQ3rastFFxwcCM6peFG8P6CE/NynEf/GbCnCu/HF/o8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(136003)(39830400003)(451199021)(6486002)(4326008)(36756003)(41300700001)(8676002)(66946007)(6916009)(66476007)(8936002)(2906002)(5660300002)(44832011)(478600001)(38100700002)(86362001)(66556008)(316002)(54906003)(6666004)(186003)(83380400001)(6512007)(6506007)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TwJDfwXi3QxeFsFUzcs9gDwIUfAdy7ygXdbv1lBxQAuZTbStFG/OaNAKXDHF?=
 =?us-ascii?Q?JO6uNRLwryx0ubd/GFiMz9jnMaIWXSTqxXzxRYePTBC9cGGBgTQ+98iGCoNJ?=
 =?us-ascii?Q?5MQojwymZhE28DWK8Pi6R9c6Ivyw0GHg+ZAB2cg5UllTgarLpfF3AblQop+Q?=
 =?us-ascii?Q?cb+I+r3aJmc68MeHU5BXQrFJtzcA9NNva0BaNQhKxFd3GN2gCkzyMsCG5ryr?=
 =?us-ascii?Q?it1jxhPBATfH4QSDuxRQiE7NDGAOz1c+MwRrDwCt4p8bw1IotaFLnYqn6kwZ?=
 =?us-ascii?Q?dlkxoQJcQiGkYcQvNSfQwhFJ+EptXafnZKytRLUKEIYQADskwCvCiX3GzXv1?=
 =?us-ascii?Q?jqWxB2YRULvsxa5HzDaYV1h6l1qYxKj16fNeFPulIVOadlNFsfeusrHBly5l?=
 =?us-ascii?Q?deuRcQXBdMu9f2tCTiO/LUtCDG4+hUj1Q2iq7S+E6UdWrKOeIoLqMNlQBBqx?=
 =?us-ascii?Q?zdLzRpvfIyu6bqq4NlWGqMdUE2uv2qEI5XkKgDEk4FY38lC3cbPdHd2DjzZW?=
 =?us-ascii?Q?UpACedJSesvBmx42bLRSesUCMqM/ncRz/gVa2jBHGFue8dOon1Emd7Qk+gDD?=
 =?us-ascii?Q?FxNCbvp8084JRV0wgVL10oBUGRAq2lrCqoSt+kzE86pAN1vz1hSB+LSZTC+c?=
 =?us-ascii?Q?4H6mNuDhfGdButXSvPyWICSp6+KNpHBJ3qML6eX8JjQR9DG2MoPIyuHmlRpI?=
 =?us-ascii?Q?M4PDztzFrrtcZOkQdTmIB2+7XowcZvb6/S03whWsrom2FeoGGDF3G8z1qwUf?=
 =?us-ascii?Q?i9HWW+cbbPyd0hm0xV9CIg84vc38Q7eY/jFAaebS1rfQp3gX/IyIoSf9Bls1?=
 =?us-ascii?Q?tTDkMlthKVzhJPy12R/WghQtxT6BLJ1vNqsAzc5EX6wcgcZuOkQ1BdBKfk3s?=
 =?us-ascii?Q?m3yrlsC8FiYsB9q4aTB5XbDDm8VHTOovpNXcX+uGm57z3ZfyKgR1e+e6cFW9?=
 =?us-ascii?Q?tnVpy/mW1fjiIW66gV4j4ogPloU44KIsxTGybtmhbuIurGkGXEGj7Z6db4MM?=
 =?us-ascii?Q?frYHz3UOHSTPdh0njkyiUwrPs5b34AY+scYO1St1XiLUtsNPxHOtr2rTktdK?=
 =?us-ascii?Q?Bz7DOOiRD9DRmbqplnLy6K5VXinA2ThCdbEFTCFYbxtH3H8BPdJwa/DgVhdN?=
 =?us-ascii?Q?4V0rYdcIr++I341KtptACDDL64XwMef3Vvxiwp0AgeW5qd+u3Y+14ri3yNGf?=
 =?us-ascii?Q?hAdtPsY7yi0WIxWMYDRMxZsKyA6fKajjHUkDvimcDbJEHJ/b/0IQcIwH80UV?=
 =?us-ascii?Q?mlD/9ggQIpuuEan7aNA+DuBW2KwG1byXTDCpZqk6QvZFx/XiydglZYTMGV+m?=
 =?us-ascii?Q?H1OaMhwE5AdWHWy1SVpGNQXa+LjrGIetfDWDxkQAiWjDrN5ihYAUvo9VPRai?=
 =?us-ascii?Q?Kl710N3Yy8AIhkTeR0tTC+7Ovao3tOAIxj34OxQfzG3oLbENw8r4gqIsyaZU?=
 =?us-ascii?Q?5Hm/sYumSb1UMgs3O0z03QlsDq9f61hh7MKcc+DkSQ565e4/C42v5qFiImUS?=
 =?us-ascii?Q?eLND3aEbK8rLkq5siFh74IbNhANzTOq6k8qaPsdxN2KtUXmTsx8HZQsAQRut?=
 =?us-ascii?Q?pNO6drxkpo6QHbEe5j5FCTwxPWyJvl/s0/J/TPsFUWHTTLXyMec6ZmeLVPBP?=
 =?us-ascii?Q?Xl7DtWx2qwRjFNJWA3M1LW/TDHPiRpKX675Kx8NSvHI5MBuzzsNNBaiAzp3T?=
 =?us-ascii?Q?FZ4Q9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6b8c63-8a8b-4825-4aaf-08db2d10cc1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 09:10:37.3313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mkwuuTSSQ1aCMLDMBB+2+CcSiwNDDBRelHOsLSnF4mLnThvkkJtDIokYDS6Nd6aQzjk2V5VkD/cjKry/YQLcmvKoCEuPpUx5VapVZjwM6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4080
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 01:51:36PM -0400, Sean Anderson wrote:
> Most of the second half of the PCI/SBUS probe functions are the same.
> Consolidate them into a common function.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Hi Sean,

overall this looks good.
But I (still?) have some concerns about handling hm_revision.

...

> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index bd1925f575c4..ec85aef35bf9 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2430,6 +2430,58 @@ static void happy_meal_addr_init(struct happy_meal *hp,
>  	}
>  }
>  
> +static int happy_meal_common_probe(struct happy_meal *hp,
> +				   struct device_node *dp)
> +{
> +	struct net_device *dev = hp->dev;
> +	int err;
> +
> +#ifdef CONFIG_SPARC
> +	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision);

Previously the logic, for SPARC for PCI went something like this:

	/* in happy_meal_pci_probe() */
	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
	if (hp->hm_revision == 0xff)
		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);

Now it goes something like this:

	/* in happy_meal_pci_probe() */
	hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
	/* in happy_meal_common_probe() */
	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision); 

Is this intentional?

Likewise, for sbus (which implies SPARC) the logic was something like:

	/* in happy_meal_sbus_probe_one() */
	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
	if (hp->hm_revision == 0xff)
		 hp->hm_revision = 0xa0;

And now goes something like this:

	/* in happy_meal_pci_probe() */
	hp->hm_revision = 0xa0;
	/* in happy_meal_common_probe() */
	hp->hm_revision = of_getintprop_default(dp, "hm-rev", hp->hm_revision); 

> +#endif
> +
> +	/* Now enable the feature flags we can. */
> +	if (hp->hm_revision == 0x20 || hp->hm_revision == 0x21)
> +		hp->happy_flags |= HFLAG_20_21;
> +	else if (hp->hm_revision != 0xa0)
> +		hp->happy_flags |= HFLAG_NOT_A0;
> +
> +	hp->happy_block = dmam_alloc_coherent(hp->dma_dev, PAGE_SIZE,
> +					      &hp->hblock_dvma, GFP_KERNEL);
> +	if (!hp->happy_block)
> +		return -ENOMEM;
> +
> +	/* Force check of the link first time we are brought up. */
> +	hp->linkcheck = 0;
> +
> +	/* Force timer state to 'asleep' with count of zero. */
> +	hp->timer_state = asleep;
> +	hp->timer_ticks = 0;
> +
> +	timer_setup(&hp->happy_timer, happy_meal_timer, 0);
> +
> +	dev->netdev_ops = &hme_netdev_ops;
> +	dev->watchdog_timeo = 5 * HZ;
> +	dev->ethtool_ops = &hme_ethtool_ops;
> +
> +	/* Happy Meal can do it all... */
> +	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
> +	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
> +
> +

nit: one blank line is enough.

> +	/* Grrr, Happy Meal comes up by default not advertising
> +	 * full duplex 100baseT capabilities, fix this.
> +	 */
> +	spin_lock_irq(&hp->happy_lock);
> +	happy_meal_set_initial_advertisement(hp);
> +	spin_unlock_irq(&hp->happy_lock);
> +
> +	err = devm_register_netdev(hp->dma_dev, dev);
> +	if (err)
> +		dev_err(hp->dma_dev, "Cannot register net device, aborting.\n");
> +	return err;
> +}
> +

...
