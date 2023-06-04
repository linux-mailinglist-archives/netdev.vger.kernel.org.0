Return-Path: <netdev+bounces-7808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A10D5721903
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 20:00:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 572FF2811D2
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C8110946;
	Sun,  4 Jun 2023 18:00:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781E6107BB
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 18:00:42 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2095.outbound.protection.outlook.com [40.107.94.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAFCDB;
	Sun,  4 Jun 2023 11:00:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjjdrtORI3L2uR7B+fLTCPCgQZ7SfoCnljwwmDo1/Ec62m/IwHgqB9xCmx4bC6VKT2Pkq3QWHCmsIe0MDodr/VodpdFK57ucfdbDb9mJgACxiXmoH7i+s5DYL5x8QANZZyHvqm/v4q7URoMTSF6B6MXv3hQT59ghdnR4ypLba5ZHdOamnZqwPL8vn/+pMK4UvWgTaI7WlrGVqYaT9RZ3J2mzF0aZFsTnDY0q9jAyNMiXezvheZs0CkRO+L4Z/O3Wq8rHII377NMElW5291oxvN0TPSx1Uiy8UWxxMNwYfkXSAHveDC1VzG/O9XN1Y9xdAV6q0DNFwcJdAAvDbdyfUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBew9oNPTcrZAiyoxeUCm6d6ADVj0eCIheWM9cze1HU=;
 b=cQoRnoQVcjul0pIZwXswAIJGnzs81j+2nLe13k9qIOn/pixqHolgFCJ5XGBRgLdsR24JStHjPDrNnfvlSRnRDIZBWGkG8jC5TWxZA+Qr9KFaSj9h2XDlGywFQ51E6HLpNE0l6lA3JskC1BQmfHJObJsDDDXZdOgMGiU+M1ssYWvuOhgoRpI/dkzAJ5ZS6m5NmBvtgX6mk6BPVVa9GTutFElxuDdR4eWKlv9YQ0vHYIr/m5HxDWVHteBju2IM4LahCvfDbBeYCpW9CJ1aap/qFX5UvPYf0ECnD4eWAojhXTZPfEqlimZpn7z00Sc2jx0KRNVcFDgdKDA7daLynC51sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NBew9oNPTcrZAiyoxeUCm6d6ADVj0eCIheWM9cze1HU=;
 b=RJgWvzey/eWnOL42MgNl4aSGnpMIOEKjqYZwk0gO7ALlv/09FN1Nf/7Wy23ycdBht0O9zkeZAmw7jTIQRQX1KX2/EZ1OqzYHZ9PBRfhOXZIuVUvk9BvI5LvaRkrjxCA28L/gN9hmCkC6bYzfJkJwbf76bB8dGBDjwnKK7vvAp3U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5221.namprd13.prod.outlook.com (2603:10b6:8:f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Sun, 4 Jun 2023 18:00:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 18:00:37 +0000
Date: Sun, 4 Jun 2023 20:00:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Varshini Rajendran <varshini.rajendran@microchip.com>
Cc: tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@microchip.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	gregkh@linuxfoundation.org, linux@armlinux.org.uk,
	mturquette@baylibre.com, sboyd@kernel.org, sre@kernel.org,
	broonie@kernel.org, arnd@arndb.de, gregory.clement@bootlin.com,
	sudeep.holla@arm.com, balamanikandan.gunasundar@microchip.com,
	mihai.sain@microchip.com, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
	durai.manickamkr@microchip.com, manikandan.m@microchip.com,
	dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
	balakrishnan.s@microchip.com
Subject: Re: [PATCH 14/21] clk: at91: sam9x7: add sam9x7 pmc driver
Message-ID: <ZHzROaaCmrnjcejV@corigine.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-15-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603200243.243878-15-varshini.rajendran@microchip.com>
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5221:EE_
X-MS-Office365-Filtering-Correlation-Id: f12a0439-e386-4370-2900-08db652599bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CzEex9wewc5o65aHOuEKhQWjQZbXdbJo3L2lTTrRZUnmjpCEx1BMc82cYaeWPGdRD94SqX4xrt/7fm9PJ8c2dSKLHwLhL8dkzFWZhX4dsBYALNV/VBUO0iGa0PKKr7sS346+8SbU41wDaf0D3j8ax/Gujtz/x7zUs9duVUOe93wOjPjfxtx2/80oNLoaHcLEj8AWu4bdykEkbpza7c5U0p4s1aL+G82y+8owY+4OzQbnKgWqXUF0y9cXFQFEjHdz6UbvMIN9Pa9Zt3iccd6DrhvJTz1vDLR4glsD8ekmoxHMvg1Vm8Lh+JqOCNDsKp8sIJZQK2N/JY0XOaKt+EZqXzLSwXzO2V+d0ljn/4kJ2u2kCiAP/lrYS2rsgcc55zX2h6wCSFOJPnW+Tvo8bblFP1j3Uka43WeEHBgOcz4xbSKYzowICmDDmoyO4LpuQGRWluvQh50wajjcbSLJzXDDK8wziTPmQo0ODRv9p7RDiTIvaeofudEq0KA/esfVhWwLM5dXaTJDW/UrqXuj6YyP8VSQMv5DU0UsgQqYhpUPN34wGoo9VnuWGchIuEw86/ci
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(39830400003)(376002)(451199021)(2616005)(6512007)(6506007)(44832011)(316002)(83380400001)(4326008)(6916009)(66556008)(66946007)(66476007)(6486002)(6666004)(186003)(478600001)(36756003)(2906002)(5660300002)(8936002)(8676002)(86362001)(7416002)(7406005)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DQnmowMOaeQVOb+kAygv0zjCjRnKIK2kUoCq+WY4xUdz4cujcK4mWbCspn15?=
 =?us-ascii?Q?F0D3QV3rP1Z4QrULGKu5o41UeW55laf+t81l6ibYxbNZDy9JkKlx6PcpU4mU?=
 =?us-ascii?Q?X6+Hv1a7IUhBZXWfiNXF2xhwW1JAtXkAoqvC6SHmTLzNW3NlJeWgBA3AWq6r?=
 =?us-ascii?Q?oa1C1ADRLPK2NJ56K1UyxUixZbnHSsjR745vrgW143MfitfSq5T6r3kf+kHm?=
 =?us-ascii?Q?2GswmlOW9erPIktON+KZGlPuOjLj7LmMGOfQ26+HHDILxz4gvmpBgKek8g+2?=
 =?us-ascii?Q?dan/uBGQ9XvnKYZskiI/2w08iDot+w6Ezxq0ESfQMUSvJkxTLgHtN8wfMfzw?=
 =?us-ascii?Q?7Og0YTIgM+30IZa4tQPVVT/3PRW8SuVSziPey2BAYhqAKSbLOLQ3FsC231Ce?=
 =?us-ascii?Q?/APGCfDNLUhZTm1zKly+QVwVj9qzTtPe3wmStHlEc1ZYPex2/jF9yA+oEATK?=
 =?us-ascii?Q?/XnI/t0o4CnxD9nlatRmmm9ZB5P+nHZfV96J4iaN1zlyqJJDeV/KO1JhmkfW?=
 =?us-ascii?Q?aeo1rHwN+cVVwIxHVR+vcldKh+NMaSBGKwMShFNKCBS7VCNvLIIR3F9ihw37?=
 =?us-ascii?Q?hAX6rmOx4PBeZrIJEj7xlNiixu0Yk/MjPuw6pnhz73E781claSdQnIPJMtwy?=
 =?us-ascii?Q?CqvZY6ZV4lm/dxmwQ/JNWChRjIkWhxktf8u9Lxzdwg8BP65vbLcZhvvx0rF3?=
 =?us-ascii?Q?m/cHhBwi+ygr1bvxSB1zrrZbKo74rPJ6d6cW9e+ZLE8Fpc3V0D+CXtfZM/nJ?=
 =?us-ascii?Q?mgX7RRv/JS3gRbpLgeTc+zzr1H/UOEhErsqc++BEgJXGRCbequIJ8aed5ji2?=
 =?us-ascii?Q?l22BDDJmQQ8TJpBwVAA/JacvEkv+5jYYorvqiV1Kqze6I3yBx2Oyz67Qqn2G?=
 =?us-ascii?Q?jPrOQVAcrle4TXmKJQYeA2nGX2RbGLWww8d34jN0GOoy8ia8cwgb1yl9ZMxA?=
 =?us-ascii?Q?BIGL/gVce1zpm/352oiDMXLroiSM83mVfJq58H1QvswMxuXLDNWxNi4cEfUP?=
 =?us-ascii?Q?k/3L7yGLwEFnZXK6lYD8WMrRb+wgsm07QA/iinfy9nb5+OnjBlVLaIv53c88?=
 =?us-ascii?Q?d2B43MFKTM0iDwQBTFwP1YPZ7PwEU5TuVPZk78bGmgAn738s0+IonZKgQLy1?=
 =?us-ascii?Q?uJraL8hHR9Zk4eRoQ0Z5Ww0mP52bdGAeug6v1u+PPq6zgnNi3KvwksXoAe57?=
 =?us-ascii?Q?mZOHWTMMe3V0h4IPQKzga0mCX5VaQjzThpc1uRvTil56et8tHaZEGeMNafxw?=
 =?us-ascii?Q?aid40LRXr+/QyGgvsMhM+aJhhEQtEm8gI+WlhP4s1Owok+xcvb6zC2kvSEMC?=
 =?us-ascii?Q?iYraZF+wnUSwJ/SbqnTUjfauc73tMzF8fr3F/3+O3F6sTVHbKVQqvm8zir+s?=
 =?us-ascii?Q?AJAOWfWpIKJ48A7V6D1dl9DJrLkT8vq4zgYHImD08bxNdTkCPpm3rXaLkZO7?=
 =?us-ascii?Q?hqSPOvLE0to5a8jP57e/XYDu/L0hpLgm5aM0MmQKXIHMOW+qgcV58CTRORLG?=
 =?us-ascii?Q?jMU4sHG1yR9GXhq5D0hQrWWHXLyMCtYo+mVGt1XBifoL/g4DFU0q0jjGXy7g?=
 =?us-ascii?Q?kzoOW4T5GWmAQXF/dk7DEv4FaLLoqYfaBHDyaQCzS8lkp/3+puWlNKi6Ts9h?=
 =?us-ascii?Q?FkZJ9eeY9DYZu6eMA6M6Z+NKKjB/EqotdXndo+COEtAliP/lu8gwjtRAoyf8?=
 =?us-ascii?Q?1Fedhw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12a0439-e386-4370-2900-08db652599bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 18:00:37.2419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MEmWMP40sngXW8La8z5KJCEDCIV9Thbx83MjHdR6Ztw7NBvqSJUvLVS2cSQboXKY7bVk7nD268oiW6gWM2BHB32yaF5Uque9QPUZownp6GI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5221
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:32:36AM +0530, Varshini Rajendran wrote:
> Add a driver for the PMC clocks of sam9x7 Soc family
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>

...

> +static void __init sam9x7_pmc_setup(struct device_node *np)
> +{
> +	struct clk_range range = CLK_RANGE(0, 0);
> +	const char *td_slck_name, *md_slck_name, *mainxtal_name;
> +	struct pmc_data *sam9x7_pmc;
> +	const char *parent_names[9];
> +	void **alloc_mem = NULL;
> +	int alloc_mem_size = 0;
> +	struct clk_hw *main_osc_hw;
> +	struct regmap *regmap;
> +	struct clk_hw *hw;
> +	int i, j;
> +
> +	i = of_property_match_string(np, "clock-names", "td_slck");
> +	if (i < 0)
> +		return;
> +
> +	td_slck_name = of_clk_get_parent_name(np, i);
> +
> +	i = of_property_match_string(np, "clock-names", "md_slck");
> +	if (i < 0)
> +		return;
> +
> +	md_slck_name = of_clk_get_parent_name(np, i);
> +
> +	i = of_property_match_string(np, "clock-names", "main_xtal");
> +	if (i < 0)
> +		return;
> +	mainxtal_name = of_clk_get_parent_name(np, i);
> +
> +	regmap = device_node_to_regmap(np);
> +	if (IS_ERR(regmap))
> +		return;
> +
> +	sam9x7_pmc = pmc_data_allocate(PMC_PLLACK + 1,
> +				       nck(sam9x7_systemck),
> +				       nck(sam9x7_periphck),
> +				       nck(sam9x7_gck), 8);
> +	if (!sam9x7_pmc)
> +		return;
> +
> +	alloc_mem = kmalloc(sizeof(void *) *
> +				(ARRAY_SIZE(sam9x7_gck)),
> +				GFP_KERNEL);
> +	if (!alloc_mem)
> +		goto err_free;
> +
> +	hw = at91_clk_register_main_rc_osc(regmap, "main_rc_osc", 12000000,
> +					   50000000);
> +	if (IS_ERR(hw))
> +		goto err_free;
> +
> +	hw = at91_clk_register_main_osc(regmap, "main_osc", mainxtal_name, 0);
> +	if (IS_ERR(hw))
> +		goto err_free;
> +	main_osc_hw = hw;
> +
> +	parent_names[0] = "main_rc_osc";
> +	parent_names[1] = "main_osc";
> +	hw = at91_clk_register_sam9x5_main(regmap, "mainck", parent_names, 2);
> +	if (IS_ERR(hw))
> +		goto err_free;
> +
> +	sam9x7_pmc->chws[PMC_MAIN] = hw;
> +
> +	for (i = 0; i < PLL_ID_MAX; i++) {
> +		for (j = 0; j < 3; j++) {
> +			struct clk_hw *parent_hw;
> +
> +			if (!sam9x7_plls[i][j].n)
> +				continue;
> +
> +			switch (sam9x7_plls[i][j].t) {
> +			case PLL_TYPE_FRAC:
> +				if (!strcmp(sam9x7_plls[i][j].p, "mainck"))
> +					parent_hw = sam9x7_pmc->chws[PMC_MAIN];
> +				else if (!strcmp(sam9x7_plls[i][j].p, "main_osc"))
> +					parent_hw = main_osc_hw;
> +				else
> +					parent_hw = __clk_get_hw(of_clk_get_by_name
> +								 (np, sam9x7_plls[i][j].p));
> +
> +				hw = sam9x60_clk_register_frac_pll(regmap,
> +								   &pmc_pll_lock,
> +								   sam9x7_plls[i][j].n,
> +								   sam9x7_plls[i][j].p,
> +								   parent_hw, i,
> +								   sam9x7_plls[i][j].c,
> +								   sam9x7_plls[i][j].l,
> +								   sam9x7_plls[i][j].f);
> +				break;
> +
> +			case PLL_TYPE_DIV:
> +				hw = sam9x60_clk_register_div_pll(regmap,
> +								  &pmc_pll_lock,
> +								  sam9x7_plls[i][j].n,
> +								  sam9x7_plls[i][j].p, i,
> +								  sam9x7_plls[i][j].c,
> +								  sam9x7_plls[i][j].l,
> +								  sam9x7_plls[i][j].f, 0);
> +				break;
> +
> +			default:
> +				continue;
> +			}
> +
> +			if (IS_ERR(hw))
> +				goto err_free;
> +
> +			if (sam9x7_plls[i][j].eid)
> +				sam9x7_pmc->chws[sam9x7_plls[i][j].eid] = hw;
> +		}
> +	}
> +
> +	parent_names[0] = md_slck_name;
> +	parent_names[1] = "mainck";
> +	parent_names[2] = "plla_divpmcck";
> +	parent_names[3] = "upll_divpmcck";
> +	hw = at91_clk_register_master_pres(regmap, "masterck_pres", 4,
> +					   parent_names, &sam9x7_master_layout,
> +					   &mck_characteristics, &mck_lock);
> +	if (IS_ERR(hw))
> +		goto err_free;
> +
> +	hw = at91_clk_register_master_div(regmap, "masterck_div",
> +					  "masterck_pres", &sam9x7_master_layout,
> +					  &mck_characteristics, &mck_lock,
> +					  CLK_SET_RATE_GATE, 0);
> +	if (IS_ERR(hw))
> +		goto err_free;
> +
> +	sam9x7_pmc->chws[PMC_MCK] = hw;
> +
> +	parent_names[0] = "plla_divpmcck";
> +	parent_names[1] = "upll_divpmcck";
> +	parent_names[2] = "main_osc";
> +	hw = sam9x60_clk_register_usb(regmap, "usbck", parent_names, 3);
> +	if (IS_ERR(hw))
> +		goto err_free;
> +
> +	parent_names[0] = md_slck_name;
> +	parent_names[1] = td_slck_name;
> +	parent_names[2] = "mainck";
> +	parent_names[3] = "masterck_div";
> +	parent_names[4] = "plla_divpmcck";
> +	parent_names[5] = "upll_divpmcck";
> +	parent_names[6] = "audiopll_divpmcck";
> +	for (i = 0; i < 2; i++) {
> +		char name[6];
> +
> +		snprintf(name, sizeof(name), "prog%d", i);
> +
> +		hw = at91_clk_register_programmable(regmap, name,
> +						    parent_names, 7, i,
> +						    &sam9x7_programmable_layout,
> +						    NULL);
> +		if (IS_ERR(hw))
> +			goto err_free;
> +
> +		sam9x7_pmc->pchws[i] = hw;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(sam9x7_systemck); i++) {
> +		hw = at91_clk_register_system(regmap, sam9x7_systemck[i].n,
> +					      sam9x7_systemck[i].p,
> +					      sam9x7_systemck[i].id,
> +					      sam9x7_systemck[i].flags);
> +		if (IS_ERR(hw))
> +			goto err_free;
> +
> +		sam9x7_pmc->shws[sam9x7_systemck[i].id] = hw;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(sam9x7_periphck); i++) {
> +		hw = at91_clk_register_sam9x5_peripheral(regmap, &pmc_pcr_lock,
> +							 &sam9x7_pcr_layout,
> +							 sam9x7_periphck[i].n,
> +							 "masterck_div",
> +							 sam9x7_periphck[i].id,
> +							 &range, INT_MIN,
> +							 sam9x7_periphck[i].f);
> +		if (IS_ERR(hw))
> +			goto err_free;
> +
> +		sam9x7_pmc->phws[sam9x7_periphck[i].id] = hw;
> +	}
> +
> +	parent_names[0] = md_slck_name;
> +	parent_names[1] = td_slck_name;
> +	parent_names[2] = "mainck";
> +	parent_names[3] = "masterck_div";
> +	for (i = 0; i < ARRAY_SIZE(sam9x7_gck); i++) {
> +		u8 num_parents = 4 + sam9x7_gck[i].pp_count;
> +		u32 *mux_table;
> +
> +		mux_table = kmalloc_array(num_parents, sizeof(*mux_table),
> +					  GFP_KERNEL);
> +		if (!mux_table)
> +			goto err_free;
> +
> +		SAM9X7_INIT_TABLE(mux_table, 4);
> +		SAM9X7_FILL_TABLE(&mux_table[4], sam9x7_gck[i].pp_mux_table,
> +				  sam9x7_gck[i].pp_count);
> +		SAM9X7_FILL_TABLE(&parent_names[4], sam9x7_gck[i].pp,
> +				  sam9x7_gck[i].pp_count);
> +
> +		hw = at91_clk_register_generated(regmap, &pmc_pcr_lock,
> +						 &sam9x7_pcr_layout,
> +						 sam9x7_gck[i].n,
> +						 parent_names, mux_table,
> +						 num_parents,
> +						 sam9x7_gck[i].id,
> +						 &sam9x7_gck[i].r,
> +						 sam9x7_gck[i].pp_chg_id);
> +		if (IS_ERR(hw))
> +			goto err_free;
> +
> +		sam9x7_pmc->ghws[sam9x7_gck[i].id] = hw;
> +		alloc_mem[alloc_mem_size++] = mux_table;
> +	}
> +
> +	of_clk_add_hw_provider(np, of_clk_hw_pmc_get, sam9x7_pmc);
> +

Hi Varshini,

alloc_mem appears to be leaked here.

> +	return;
> +
> +err_free:
> +	if (alloc_mem) {
> +		for (i = 0; i < alloc_mem_size; i++)
> +			kfree(alloc_mem[i]);
> +		kfree(alloc_mem);
> +	}
> +	kfree(sam9x7_pmc);
> +}
> +
> +/* Some clks are used for a clocksource */
> +CLK_OF_DECLARE(sam9x7_pmc, "microchip,sam9x7-pmc", sam9x7_pmc_setup);

I'm sure I'm missing some thing obvious, but I was unable to
find the binding for "microchip,sam9x7-pmc".

