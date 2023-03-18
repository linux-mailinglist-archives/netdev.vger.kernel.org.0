Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300BD6BFA94
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 14:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCRNxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 09:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCRNxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 09:53:43 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2107.outbound.protection.outlook.com [40.107.212.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE8D2F076;
        Sat, 18 Mar 2023 06:53:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2fm49qRHYnlKCUQeUlXGdt6iIR3cpC2QoC/4ioeFPeEUvK8YTq0ZDUObgPUw0gAeV3hqSWQT88hW+5aeRurwYJmAp4ScB+mdDff+tj//e0QqjeFwDdaFHzpYsne5dUoI2BJXjlYxt1JP2To2j1+picDI+ItU+fTyViHAoREolzjoyNJA8LxfY5rmU5fZBICz+A6a+nObk0tAdEFRyD3yHpONvOLONZTJbRdsikH6ej+MnlqWOBjWkfEQ8oJ9URFVo+WunzwQWl0PbLSxF1UgweUpf31cf62EaRozY3ZdEuOaQxWq0Kg8clccJAG1ysZYusy6EfhAuWWyCXl9W5YlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRxTsydyg850faUYXrKkjA7ABGXZXAUtj24URrzKN3k=;
 b=Z6abv7rZXg3lUCq/nU1enznOA9xmx/QYXcQ/t1Ty/iQqS4QNQh/4LRkOIVrqlB5RNyndw+iZPhUPNN+jdu5liY6gvps7JepJT2owvfvoXz7Kzwx7dHwvemHYfO5ZXP4nBd7rP8AabkUZtqrM1h7s5JBnv8i70yZEmlJIVUzwcAkSgdLNZdRxjRCPSmz09pYopUuw30gpEAaJoAMcc445UhM7QLmNtaUmtqGVGiJ2EsHosdr2zZ7a6bxFfyyTe1NDkev6MaCz400FK1LbHrSdjvDnwYvbsd1bBYgmsis6qeM7qTMdEKiQmaHxkKuuGmpZjipDFB688VxtLuNANPiNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRxTsydyg850faUYXrKkjA7ABGXZXAUtj24URrzKN3k=;
 b=uAIZ3yG5WxS3N0rAIgUAcs5ASBWrQl4HSkjYBcxtf3PoSsKIAtqhjqlvra5TNNiI+lJu5qWeTIVKNwkoFoNdjByBppI8c73CDgCF/qmPhCgBQiv/0dxugLURHPNNhaZlB9vSs57kxcx4Lhicj9/B/QErg+nsz6ksc1CMQ025Exo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4059.namprd13.prod.outlook.com (2603:10b6:303:53::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sat, 18 Mar
 2023 13:53:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.036; Sat, 18 Mar 2023
 13:53:34 +0000
Date:   Sat, 18 Mar 2023 14:53:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 9/9] net: sunhme: Consolidate common probe
 tasks
Message-ID: <ZBXCWUm/1ffaD1B+@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-10-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-10-seanga2@gmail.com>
Organisation: Horms Solutions BV
X-ClientProxiedBy: AM0PR01CA0116.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4059:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a73a61b-5a58-4c3a-4291-08db27b82a9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 15zYj+60XpJPlr7fJ2+FFGZK2/bahW7KfH8yBHH/1P7wX4QUtra8TbO1gEFG1YGtUWdyOVl0SDkAprGcXNgg70tyYIvCNPS5rl7dVd16MrLg0ErWpwaxkDHUKZl7Ws62Df0ki8xmJQJmRkV8jw8tQeHQ+x1hGnn4J/XzAH0eMVYlzk0gU/Ig2nbp0qNnfaqtzG+gKTcXYWIYRaD4iWbF5DM1Hgj62IRIZalod0QVFGvpU4RMz2rKRCO7Tw47jZqIaoyM6ZN26sish/H/PUXpbXGHyDOqsoDIpwNjsx9TUDQRUE4PN9pMYXCPR4IdAwFdJixErOSITH3iQk7wE4gsm3Bx8DOqKoolepW2N6UFrJnc9kra8vP1Iv4QQfk3A/4WRlblPdZdYh0uZCld3pt/jH7pQ6Qzr3Wksh8YDeImbhl1buVb6Uxb02Iw0Gwqf9/Do+4ByPauJt6eC3teezd0UmxRw3OmoBds8DCMPKWFvNbzfCY5zhn+kQGrwhj5fLf26tCPEf1inmmhz8+UB3/z87sT7qFCaW0Jy3KGZ96ELrCH93nMCniy9nDifQVLwM2TJav9iJdFRa5WaJ22DfkfPfk62PsR+4kzHhN9Un7g4EW1XQ9GsJzHPIBEKLsu55W1J01b2ECTgtMaUock5MsDhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(366004)(346002)(396003)(376002)(451199018)(36756003)(38100700002)(478600001)(4326008)(316002)(54906003)(66946007)(6916009)(66556008)(8676002)(41300700001)(66476007)(86362001)(8936002)(83380400001)(44832011)(6486002)(2616005)(6666004)(186003)(5660300002)(2906002)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u47KZV0wKcgP1tMALy5uM2HzWp3SmGrWBuF6bKNeJ9kpo6FJLB1nYl1vnF0h?=
 =?us-ascii?Q?XzNFa6gOEsqrlT7VzhmGet0E6f61MUHMj5GTZYPZclbqhZ9hy7FhJNmc96vc?=
 =?us-ascii?Q?wg2cfLaf+QrOruw1EwAXLYnJute+3rl+kzAD37nSmJqnDE6/oYvbog4p3Ihc?=
 =?us-ascii?Q?PTY2+K6mUIbFUCjtySrQv9DTzyE73xKCaYFUsASgxJdepmgIGAtvgQOLY+jk?=
 =?us-ascii?Q?OXn3gMZ0AWIZ8mR82gFoOzHRVXwyJpxUPde/XNgG92MFWktp5cvxsv2xP1Y5?=
 =?us-ascii?Q?4HfWe0ccN9SdOq5KdKDGYH0/IKQT0LS1Hupsei9W6hRvDPoBTh4dh9gbOLzi?=
 =?us-ascii?Q?wwN1lz+34EqFaV6hlzBTQDZQX4j5OVOlWle6D0Vvk9MWrTXl+xGWA48XB5eP?=
 =?us-ascii?Q?Tlyz+CNNukvNkKo+Q/fxJ8+Kyl6vNK46x3JiUIOLxIYzI4LfdWmekK6ArE10?=
 =?us-ascii?Q?lXAwpwA2TA4/4RXeweiHl37h0EvAR6wvNPfQ5GgZ/5f/i1FPErphNG2FcFL7?=
 =?us-ascii?Q?CTnzWaEW5A3Y1DhSwzD6QL8L3xmwS4bKiJI7APCPSkGGTgnRN5ib4ZUBkcOc?=
 =?us-ascii?Q?1Mv+qi1peGZNEtSMQAAbYjjy04HcVCRyAjHriXSBp8jEU/aeiDRPv4i1TvsW?=
 =?us-ascii?Q?JKDpn8gFsIV0Bv34nVbyl2adiIzbHKZ7+p3LNjekcbc21pY5YlQMjWxqcqQp?=
 =?us-ascii?Q?JwHMG0BF0s0LYCxIs7xQRzhgbln9m/0ZRFANLD+Ad3XoL+jCwO0yXQLCLKxY?=
 =?us-ascii?Q?hn1U7dqZQ7DeltDLpArrFvhhXbuoevUEYenrPGT4mTHSEXBFwtXErnKVDbRy?=
 =?us-ascii?Q?GS4Vbdt89GulaiRwf54K7ON/bRLUwf3+i0AYBrxMMbW5E98SQkgeFP5IwQ7S?=
 =?us-ascii?Q?Xi9cxjapg6ZxBQWS5mJ09Xdg6djovYslMPHWrWcLSfiODgRTMocEYEgNJ7ul?=
 =?us-ascii?Q?Jkk74SEDL56jiLGQUlpTSsmmd4iAz1i/glk402Rv0XSwLa1ozZ4xjllCc6NM?=
 =?us-ascii?Q?G6zNQf5+mQ8DZ0OX6UfLdGgW6YDkJc4qe2/ndCVx0Zv7zblSUO1yv67UboJy?=
 =?us-ascii?Q?0AW64rZbX/mpuHI7vV+Zb9zA+8PZnPC8SXcG1Z6uOl8m4R4Xq0EvJLDnx2Og?=
 =?us-ascii?Q?pHEwP1naFNuSisq4zSwYWOZWPh+craw9nNI2Li9Qm8XvoWydGnOVth4dpQXr?=
 =?us-ascii?Q?Lw3FiDSHvhi/I9LERa0g3OmZ71fQEqlS9TXLZ9o4ivrCOKaB/LPA04qL5fEg?=
 =?us-ascii?Q?tl7WT/a2RvhAms3tibAp+UnHfuGfH9YCyWHXX6V/wxBS46UubCX8UnOIAC8P?=
 =?us-ascii?Q?sscO4yeJBCWtDhzFZk9pEa803GzfiFyOCeXMJFlQssXoy90TUl0RH58MFl1i?=
 =?us-ascii?Q?cY3q62v20jkF2j1OsTVoUwxHJE8TtVfrdQqDJz3bLLcO+w1yJh61Zc3DlgFL?=
 =?us-ascii?Q?/WcSvr30bXoQytjkjLhzjuwqyJ7sDS2HbdwLB5UQxzMT9goVf8bdVCJJl9lp?=
 =?us-ascii?Q?f2tQjWdcetFg3asw+LxlPE13YM0ymcJElYtUs1bBTJMme+/Ii5rakZrYKrc/?=
 =?us-ascii?Q?nbucFgxLr5kyU7fbw4XCEelq/AJCPZ33OgLaRFJVD5x4P6EnbN9I/Sq/rM8/?=
 =?us-ascii?Q?k5jpHArZZwAajIExToTxoOo4lMyZ6z7kMn9berJUOYbcpIAkjAlXG3bezy2n?=
 =?us-ascii?Q?+/f1zg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a73a61b-5a58-4c3a-4291-08db27b82a9b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 13:53:34.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcu2g2C7UJvkebmm5gdMOXfe4KX4QSuBGdFiYpgJJ0EGh+9HBFrGNOFblLSR/ekdubznowDOSJKlIm+5IvJt8VjgpouMUB909zHTb1niYIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:13PM -0400, Sean Anderson wrote:
> Most of the second half of the PCI/SBUS probe functions are the same.
> Consolidate them into a common function.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
> (no changes since v1)
> 
>  drivers/net/ethernet/sun/sunhme.c | 183 ++++++++++++------------------
>  1 file changed, 71 insertions(+), 112 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index a59b998062d9..a384b162c46d 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2430,6 +2430,71 @@ static void happy_meal_addr_init(struct happy_meal *hp,
>  	}
>  }
>  
> +static int happy_meal_common_probe(struct happy_meal *hp,
> +				   struct device_node *dp, int minor_rev)
> +{
> +	struct net_device *dev = hp->dev;
> +	int err;
> +
> +#ifdef CONFIG_SPARC
> +	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> +	if (hp->hm_revision == 0xff)
> +		hp->hm_revision = 0xc0 | minor_rev;
> +#else
> +	/* works with this on non-sparc hosts */
> +	hp->hm_revision = 0x20;
> +#endif

...

> +#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
> +	/* Hook up SBUS register/descriptor accessors. */
> +	hp->read_desc32 = sbus_hme_read_desc32;
> +	hp->write_txd = sbus_hme_write_txd;
> +	hp->write_rxd = sbus_hme_write_rxd;
> +	hp->read32 = sbus_hme_read32;
> +	hp->write32 = sbus_hme_write32;
> +#endif

This looks correct for the SBUS case.
But I'm not sure about the PCIE case.

gcc 12 tells me when compiling with sparc allmodconfig that the following
functions are now unused.

  pci_hme_read_desc32
  pci_hme_write_txd
  pci_hme_write_rxd
  pci_hme_read32
  pci_hme_write32

> +
> +	/* Grrr, Happy Meal comes up by default not advertising
> +	 * full duplex 100baseT capabilities, fix this.
b
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
>  #ifdef CONFIG_SBUS
>  static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>  {

> @@ -2511,70 +2576,18 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
>  		goto err_out_clear_quattro;
>  	}
>  
> -	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> -	if (hp->hm_revision == 0xff)
> -		hp->hm_revision = 0xa0;

It's not clear to me that the same value will be set by the call to
happy_meal_common_probe(hp, dp, 0); where the logic is:

#ifdef CONFIG_SPARC
	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
	if (hp->hm_revision == 0xff)
		hp->hm_revision = 0xc0 | minor_rev;
#else
	/* works with this on non-sparc hosts */
	hp->hm_revision = 0x20;
#endif

I am assuming that the SPARC logic is run.
But another question: is it strictly true that SBUS means SPARC?

...

> -
> -#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
> -	/* Hook up SBUS register/descriptor accessors. */
> -	hp->read_desc32 = sbus_hme_read_desc32;
> -	hp->write_txd = sbus_hme_write_txd;
> -	hp->write_rxd = sbus_hme_write_rxd;
> -	hp->read32 = sbus_hme_read32;
> -	hp->write32 = sbus_hme_write32;
> -#endif

...

> @@ -2689,21 +2702,6 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>  	hp->bigmacregs = (hpreg_base + 0x6000UL);
>  	hp->tcvregs    = (hpreg_base + 0x7000UL);
>  
> -#ifdef CONFIG_SPARC
> -	hp->hm_revision = of_getintprop_default(dp, "hm-rev", 0xff);
> -	if (hp->hm_revision == 0xff)
> -		hp->hm_revision = 0xc0 | (pdev->revision & 0x0f);
> -#else
> -	/* works with this on non-sparc hosts */
> -	hp->hm_revision = 0x20;
> -#endif

...

> -#if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
> -	/* Hook up PCI register/descriptor accessors. */
> -	hp->read_desc32 = pci_hme_read_desc32;
> -	hp->write_txd = pci_hme_write_txd;
> -	hp->write_rxd = pci_hme_write_rxd;
> -	hp->read32 = pci_hme_read32;
> -	hp->write32 = pci_hme_write32;
> -#endif

...
