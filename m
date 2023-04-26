Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD286EFAA7
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbjDZTKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjDZTKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:10:04 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20714.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::714])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307BD133;
        Wed, 26 Apr 2023 12:09:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7KaYzJikew8WQhnXjSUQGrcFmcziQFmwaKk+QjEtc+xXHiorkpRT90bJCJBVbr1cMD7nlAcBCFMLYPF8PI5Tx5uZx6f1L/u/azMELS+wf96RxLjzL+srp7Gbi+WNxfTZRseKmb732Xbnb06VgwCpp2XamxYLdNLSmt8hOVO3H9p2JZj84ks8+HuwwH+TnWUeI70gSu6FGJILJh61eAEFHlKNZy3CbImXImSTNwtfTyij/juJPpCdm4CpC1GGJsJgHXcwfS8fgQ59T8EnVdDaJFi3Jj38oOD2msG/mv5tDtyLwQ0b/UikdzcRl2CHtDQcqs1J08nJ5WwyKcOvIJAvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4uU+OaaQtPw1VNL7Y6mnvk+C+TmWkX1yKQl8SvzLvk=;
 b=ZT7W4dRVeux2njLMs3CMOgjeXQpnT+VDL6ezJA0ojzoQsZvd+Ce9He0OUvwDdYD9h5RFwrwwfOd6iB1STJmIBzGmR16U4ygV5sxljy7jaLNtjzzguaeQQmz2Cmw+HCfY8o4Tq63jm7o/9QGSr5YvCgw87gVMaoh7OzF5TiWalTqkGFfsSMMKpIgyj/nkr8eYspt3mU9rJKq7KXrm8cYZ6KiIs5xfKDvE19cAv2FFECsqbSzFcVd8NhyJXTcKfUfEuApVLSrJUSMFOYhoSXIZkEYWmWPbZOxiYJF8prfiAYpsJ6zkH1D0/XIWzjbMYTzIqTOVxSVZnCcODRLj9DtNFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4uU+OaaQtPw1VNL7Y6mnvk+C+TmWkX1yKQl8SvzLvk=;
 b=KEos/tYMTktqctFjFn4VbCAZeE/LrCljtGhxWvDC4682JYB5LFkp6qQ5S0TgwRaOufsFZGP+U5vBQZBCi3AdN0lAACtvUM4LACfJpqkf3py/Q6KtNlh7Blm3OBkE6C+60fP5PvVwZ0/iS0VSRzDlyIgHyC8N+86g9TSqvdnRNK8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3907.namprd13.prod.outlook.com (2603:10b6:5:2a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 19:09:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 19:09:51 +0000
Date:   Wed, 26 Apr 2023 21:09:34 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <kristo@kernel.org>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, andrew@lunn.ch,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v6 2/2] net: ti: icssg-prueth: Add ICSSG ethernet
 driver
Message-ID: <ZEl2zh879QAX+QsK@corigine.com>
References: <20230424053233.2338782-1-danishanwar@ti.com>
 <20230424053233.2338782-3-danishanwar@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424053233.2338782-3-danishanwar@ti.com>
X-ClientProxiedBy: AS4P250CA0028.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3907:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec51b8a-030a-4a7c-a6f3-08db4689cf8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICbqalIOj3ZtMLeV5xFSFbQfga3+XZpdcsns0MM/qYPeT/VpsMrPZU+IqeoLqiaaoiy2L89p2O777qmlbMOoeD4wglgNM5wT2sPg0Bs+goyjLHLk2xU2Cb/nXYR3AEZlAHTBwWixsBaG0PYBOTniRysSytZZsUy9Hms3FM2wh1GmgRtMwYwZDb4evyQcwf6CZDla4PDBtoBPZCske26mCfnfrJ7l6/81baEZPYPhgKcG2Fn3MypidCsb4pked4sSmQiw9+WoxQFFxAhGckJm/qaVHZaSrfnV2b5l5ZSdaBAvhcYVIS61K28Uwb1RJJm8835t27OlqtjCBStonu5dNMMeZ8pTKsg/Fc4cuxTsjo8RNrtHt5/y4ik0Zy1NdAMeq8mDE+thD5XAtLoTA/K5S3/bZ9KTruijnnS3X61SC4HOnvNqN3IizdDu6PCNkgMgM3D5dyddDSbxfprKBMxcw+oW/2zq+JHyxL3BLYDLEQV5J32S2dacA3ZRhN8I4+ws9nKDypBIFmKX4FCQ/nmaHTk1YRFA6FUA6uSBDsiuhhgpZgteEwvHqWGOBgCtYyZ65HUkoc8OQWxsVbaMIVkc8w2RhR9M6hP3TJKDGurHbCOS4BwMGPXFGj/WtZe55HjsBN4Ch176Z/weoJqcFFN08Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(366004)(376002)(451199021)(186003)(86362001)(478600001)(54906003)(36756003)(6666004)(966005)(38100700002)(30864003)(2906002)(44832011)(8936002)(5660300002)(8676002)(7416002)(4326008)(66476007)(66556008)(6916009)(66946007)(41300700001)(6506007)(316002)(6512007)(6486002)(2616005)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wo3K1TZPSmetlbsabefbjRcxPOsizU6D04KrVe8IvDsAYnKZi2npBI5H3LW5?=
 =?us-ascii?Q?uefQ9tfi9UkIcPKp0qtay5UsESTPwIUhMvEEGtYWcwt4IJKH2s87NJ2eUwGE?=
 =?us-ascii?Q?EBb6c9CW982/7UNAWdMd6Vks02aLRRHW7FoQNPdpGx/X+OXyk1qPi5+iW3UT?=
 =?us-ascii?Q?VkWRl+ajFoz3dVW/ctsOhbhe1Z1TqWWs55jbYzVzGjvftqcD2cnl7ICNNRw8?=
 =?us-ascii?Q?sBN/AHwgpar2BNgYDcmD5d9nUMG+NqALDYUaVlUKlK84sZDqfva3X6dlDzI7?=
 =?us-ascii?Q?USeKeItyzuXK3r0qgm8ZpJa0hoXU1VRoYlWZIeMhHZAj3graDNN7KH9CjXfC?=
 =?us-ascii?Q?kZxwrhbwLnYM8t1w8A1K9QAH3wwC1cckrPzRVhKbvlwYjJFS2n3GXatiqgjg?=
 =?us-ascii?Q?AzhL+xaqCyUvFBdF8O/gU7DdkZ/V71AbvYopQqrSJhaBO2q0U7vVmOCpsT1O?=
 =?us-ascii?Q?VN/PAkFzhluAHJw+Azo3K5rg9UBhHavww+rAEPRMfNpSCvpaDd7Ee8g7viqH?=
 =?us-ascii?Q?hjPACqiNF39czJ85aSXxUIZMBteMEAz35n+fek5VNstViHKv3OlBLOEZ4RvC?=
 =?us-ascii?Q?L7YGdwSA50OZW0XVbgwkIV+hhCCI/GIJO7GnqgqRJ5RO4PO+9XY/4NShmqtJ?=
 =?us-ascii?Q?A0bq0y9Bk2JePnv4bLF8Yix5juEKP9XMDOC0ejnBTlFoV4uRhSit+q6RIcdX?=
 =?us-ascii?Q?KqBeqUP5WF1s7emCM4IwNjymOCHarouG5b4CP27T73eaRjplwxgWaEK8QXHE?=
 =?us-ascii?Q?oZaEbsgSsmrLmMmNzCIxpC18D7g7LwFc9vYtzBhfBopZ51bg+4dwYrq1on9y?=
 =?us-ascii?Q?9BN+7h54GFXoHo9BO0fWJ300skc3ljeIRGE86b1C65gQvWw82OIajouXrldq?=
 =?us-ascii?Q?8IgaPbIF15FXkB6YMn//eyOkPyDrs4xoaWtxEgwq49ZPkTd+yJsb7ybnSNRQ?=
 =?us-ascii?Q?ATbh1MX6yeqMAryhCl7fRIb7wxHyrAl61xQJGpe2FuNzvuvw0oU2pCuyOpVK?=
 =?us-ascii?Q?AaIDaMVCdetut8+tQm4+ymBykGH3PDrqlzL5+9nrjbkxB/KRriDq64H3lUT0?=
 =?us-ascii?Q?S5HCqS8tyWkLRUkRQYlWKiL3Qqv+yPFD/3M0nh4f9h1RKADM5K3zJfKw9oaC?=
 =?us-ascii?Q?NgfYG5QpioHUh3iAWDkNVXkn85tP2vofku63gQ4W08CUkNpvPUId+tXjQ031?=
 =?us-ascii?Q?fqW5mg3vU/Zl655Dbu1W6vWmsDDMrKTYxMBZ94VktSjjK1kkXyehm4+ou9yq?=
 =?us-ascii?Q?390sa1AE49ZqNanxL3lOzamRjzvLeyf9xDM20tZq9O6YR30e73fDs2maJOAC?=
 =?us-ascii?Q?V7pCoIutowIwI5F8fz6Wexk9t7ttsedH3j4mEamygNxLZzNc+C0xbr2S29OL?=
 =?us-ascii?Q?pj12NXg1TioPMC21dju4qVioTQmBXjJqYwT0S/H2+FZyrHYZREkuXzBzxldh?=
 =?us-ascii?Q?S2/de9krYWGFkG60PVGPwl+7Dovu5swdKmwGQouMScLq07dGMFREDYEqQYBk?=
 =?us-ascii?Q?j8JKGrXzLgKcxMQasNy+1QBfbZg6vTF/FOL85axrR8MWrT3MYv4/vcN7vQsh?=
 =?us-ascii?Q?I/He8d0f9K5soNW/6WVZdmCfnWvyApsSIxy6Ixl/jqHPmmrgEeCWoaRr4psc?=
 =?us-ascii?Q?7pci1HpkedWogv2C42JAlbTj6yu25xIW3yt2rm1NMMxogyAtpaEFEzr/1VEv?=
 =?us-ascii?Q?bn4vag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec51b8a-030a-4a7c-a6f3-08db4689cf8b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 19:09:51.6351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XboumY456Ix7f4A69rvEt6KCGF4cYaHKOGqIENLC0NqDSesjtgHged8O+jvRQvdD0sSaRmrNOav8E9XcRNxu4qS9sL8dVYtSKPYRJYCOvFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3907
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 11:02:33AM +0530, MD Danish Anwar wrote:
> From: Roger Quadros <rogerq@ti.com>
> 
> This is the Ethernet driver for TI AM654 Silicon rev. 2
> with the ICSSG PRU Sub-system running dual-EMAC firmware.
>
> The Programmable Real-time Unit and Industrial Communication Subsystem
> Gigabit (PRU_ICSSG) is a low-latency microcontroller subsystem in the TI
> SoCs. This subsystem is provided for the use cases like implementation of
> custom peripheral interfaces, offloading of tasks from the other
> processor cores of the SoC, etc.
> 
> Every ICSSG core has two Programmable Real-Time Unit(PRUs),
> two auxiliary Real-Time Transfer Unit (RT_PRUs), and
> two Transmit Real-Time Transfer Units (TX_PRUs). Each one of these runs
> its own firmware. Every ICSSG core has two MII ports connect to these
> PRUs and also a MDIO port.
> 
> The cores can run different firmwares to support different protocols and
> features like switch-dev, timestamping, etc.
> 
> It uses System DMA to transfer and receive packets and
> shared memory register emulation between the firmware and
> driver for control and configuration.
> 
> This patch adds support for basic EMAC functionality with 1Gbps
> and 100Mbps link speed. 10M and half duplex mode are not supported
> currently as they require IEP, the support for which will be added later.
> Support for switch-dev, timestamp, etc. will be added later
> by subsequent patch series.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> [Vignesh Raghavendra: add 10M full duplex support]
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> [Grygorii Strashko: add support for half duplex operation]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Hi MD,

Thanks for your patch, some review from my side.

...

> index 000000000000..27bd92ea8200
> --- /dev/null
> +++ b/drivers/net/ethernet/ti/icssg_config.c

...

> +static void icssg_config_mii_init(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	struct regmap *mii_rt = prueth->mii_rt;
> +	int slice = prueth_emac_slice(emac);

I think you need to check the return value of prueth_emac_slice for errors.
Or can that never happen?

> +	u32 rxcfg_reg, txcfg_reg, pcnt_reg;
> +	u32 rxcfg, txcfg;

For networking code, please arrange local variables in reverse xmas tree
order - longest line to shortest. In this case I think that would mean
something like:

	u32 rxcfg, txcfg, rxcfg_reg, txcfg_reg, pcnt_reg;
	struct prueth *prueth = emac->prueth;
	int slice = prueth_emac_slice(emac);
	struct regmap *mii_rt;

	mii_rt = prueth->mii_rt;

You can check this using https://github.com/ecree-solarflare/xmastree

> +
> +	rxcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RXCFG0 :
> +				       PRUSS_MII_RT_RXCFG1;
> +	txcfg_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_TXCFG0 :
> +				       PRUSS_MII_RT_TXCFG1;
> +	pcnt_reg = (slice == ICSS_MII0) ? PRUSS_MII_RT_RX_PCNT0 :
> +				       PRUSS_MII_RT_RX_PCNT1;
> +
> +	rxcfg = MII_RXCFG_DEFAULT;
> +	txcfg = MII_TXCFG_DEFAULT;
> +
> +	if (slice == ICSS_MII1)
> +		rxcfg |= PRUSS_MII_RT_RXCFG_RX_MUX_SEL;
> +
> +	/* In MII mode TX lines swapped inside ICSSG, so TX_MUX_SEL cfg need
> +	 * to be swapped also comparing to RGMII mode.
> +	 */
> +	if (emac->phy_if == PHY_INTERFACE_MODE_MII && slice == ICSS_MII0)
> +		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
> +	else if (emac->phy_if != PHY_INTERFACE_MODE_MII && slice == ICSS_MII1)
> +		txcfg |= PRUSS_MII_RT_TXCFG_TX_MUX_SEL;
> +
> +	regmap_write(mii_rt, rxcfg_reg, rxcfg);
> +	regmap_write(mii_rt, txcfg_reg, txcfg);
> +	regmap_write(mii_rt, pcnt_reg, 0x1);
> +}
> +
> +static void icssg_miig_queues_init(struct prueth *prueth, int slice)
> +{
> +	struct regmap *miig_rt = prueth->miig_rt;
> +	void __iomem *smem = prueth->shram.va;
> +	u8 pd[ICSSG_SPECIAL_PD_SIZE];
> +	int queue = 0, i, j;
> +	u32 *pdword;
> +
> +	/* reset hwqueues */
> +	if (slice)
> +		queue = ICSSG_NUM_TX_QUEUES;
> +
> +	for (i = 0; i < ICSSG_NUM_TX_QUEUES; i++) {
> +		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
> +		queue++;
> +	}
> +
> +	queue = slice ? RECYCLE_Q_SLICE1 : RECYCLE_Q_SLICE0;
> +	regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET, queue);
> +
> +	for (i = 0; i < ICSSG_NUM_OTHER_QUEUES; i++) {
> +		regmap_write(miig_rt, ICSSG_QUEUE_RESET_OFFSET,
> +			     hwq_map[slice][i].queue);
> +	}
> +
> +	/* initialize packet descriptors in SMEM */
> +	/* push pakcet descriptors to hwqueues */
> +
> +	pdword = (u32 *)pd;
> +	for (j = 0; j < ICSSG_NUM_OTHER_QUEUES; j++) {
> +		struct map *mp;
> +		int pd_size, num_pds;
> +		u32 pdaddr;
> +
> +		mp = &hwq_map[slice][j];

hwq_map is const, but mq is not.

clang-16 with W=1 tells me:

drivers/net/ethernet/ti/icssg_config.c:176:6: error: assigning to 'struct map *' from 'const struct map *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
                mp = &hwq_map[slice][j];

> +		if (mp->special) {
> +			pd_size = ICSSG_SPECIAL_PD_SIZE;
> +			num_pds = ICSSG_NUM_SPECIAL_PDS;
> +		} else	{
> +			pd_size = ICSSG_NORMAL_PD_SIZE;
> +			num_pds = ICSSG_NUM_NORMAL_PDS;
> +		}
> +
> +		for (i = 0; i < num_pds; i++) {
> +			memset(pd, 0, pd_size);
> +
> +			pdword[0] &= cpu_to_le32(ICSSG_FLAG_MASK);
> +			pdword[0] |= cpu_to_le32(mp->flags);
> +			pdaddr = mp->pd_addr_start + i * pd_size;
> +
> +			memcpy_toio(smem + pdaddr, pd, pd_size);
> +			queue = mp->queue;
> +			regmap_write(miig_rt, ICSSG_QUEUE_OFFSET + 4 * queue,
> +				     pdaddr);
> +		}
> +	}
> +}
> +
> +void icssg_config_ipg(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_1G);
> +		break;
> +	case SPEED_100:
> +		icssg_mii_update_ipg(prueth->mii_rt, slice, MII_RT_TX_IPG_100M);
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		netdev_err(emac->ndev, "Unsupported link speed\n");
> +		return;

Should this propagate an error to the caller?

> +	}
> +}

...

> +static int prueth_emac_buffer_setup(struct prueth_emac *emac)
> +{
> +	struct icssg_buffer_pool_cfg *bpool_cfg;
> +	struct prueth *prueth = emac->prueth;
> +	int slice = prueth_emac_slice(emac);
> +	struct icssg_rxq_ctx *rxq_ctx;
> +	u32 addr;
> +	int i;
> +
> +	/* Layout to have 64KB aligned buffer pool
> +	 * |BPOOL0|BPOOL1|RX_CTX0|RX_CTX1|
> +	 */
> +
> +	addr = lower_32_bits(prueth->msmcram.pa);
> +	if (slice)
> +		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
> +
> +	if (addr % SZ_64K) {
> +		dev_warn(prueth->dev, "buffer pool needs to be 64KB aligned\n");
> +		return -EINVAL;
> +	}
> +
> +	bpool_cfg = emac->dram.va + BUFFER_POOL_0_ADDR_OFFSET;
> +	/* workaround for f/w bug. bpool 0 needs to be initilalized */
> +	bpool_cfg[0].addr = cpu_to_le32(addr);
> +	bpool_cfg[0].len = 0;
> +
> +	for (i = PRUETH_EMAC_BUF_POOL_START;
> +	     i < (PRUETH_EMAC_BUF_POOL_START + PRUETH_NUM_BUF_POOLS);

nit: unnecessary parentheses

> +	     i++) {
> +		bpool_cfg[i].addr = cpu_to_le32(addr);
> +		bpool_cfg[i].len = cpu_to_le32(PRUETH_EMAC_BUF_POOL_SIZE);
> +		addr += PRUETH_EMAC_BUF_POOL_SIZE;
> +	}
> +
> +	if (!slice)
> +		addr += PRUETH_NUM_BUF_POOLS * PRUETH_EMAC_BUF_POOL_SIZE;
> +	else
> +		addr += PRUETH_EMAC_RX_CTX_BUF_SIZE * 2;
> +
> +	/* Pre-emptible RX buffer queue */
> +	rxq_ctx = emac->dram.va + HOST_RX_Q_PRE_CONTEXT_OFFSET;
> +	for (i = 0; i < 3; i++)
> +		rxq_ctx->start[i] = cpu_to_le32(addr);
> +
> +	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
> +	rxq_ctx->end = cpu_to_le32(addr);
> +
> +	/* Express RX buffer queue */
> +	rxq_ctx = emac->dram.va + HOST_RX_Q_EXP_CONTEXT_OFFSET;
> +	for (i = 0; i < 3; i++)
> +		rxq_ctx->start[i] = cpu_to_le32(addr);
> +
> +	addr += PRUETH_EMAC_RX_CTX_BUF_SIZE;
> +	rxq_ctx->end = cpu_to_le32(addr);
> +
> +	return 0;
> +}

...

> +void icssg_config_set_speed(struct prueth_emac *emac)
> +{
> +	u8 fw_speed;
> +
> +	switch (emac->speed) {
> +	case SPEED_1000:
> +		fw_speed = FW_LINK_SPEED_1G;
> +		break;
> +	case SPEED_100:
> +		fw_speed = FW_LINK_SPEED_100M;
> +		break;
> +	default:
> +		/* Other links speeds not supported */
> +		netdev_err(emac->ndev, "Unsupported link speed\n");
> +		return;

Should this propagate an error to the caller?

> +	}
> +
> +	writeb(fw_speed, emac->dram.va + PORT_LINK_SPEED_OFFSET);
> +}

...

> diff --git a/drivers/net/ethernet/ti/icssg_prueth.c b/drivers/net/ethernet/ti/icssg_prueth.c

...

> +static int prueth_init_rx_chns(struct prueth_emac *emac,
> +			       struct prueth_rx_chn *rx_chn,
> +			       char *name, u32 max_rflows,
> +			       u32 max_desc_num)
> +{
> +	struct net_device *ndev = emac->ndev;
> +	struct device *dev = emac->prueth->dev;
> +	struct k3_udma_glue_rx_channel_cfg rx_cfg;
> +	u32 fdqring_id;
> +	u32 hdesc_size;
> +	int i, ret = 0, slice;
> +
> +	slice = prueth_emac_slice(emac);
> +	if (slice < 0)
> +		return slice;
> +
> +	/* To differentiate channels for SLICE0 vs SLICE1 */
> +	snprintf(rx_chn->name, sizeof(rx_chn->name), "%s%d", name, slice);
> +
> +	hdesc_size = cppi5_hdesc_calc_size(true, PRUETH_NAV_PS_DATA_SIZE,
> +					   PRUETH_NAV_SW_DATA_SIZE);
> +	memset(&rx_cfg, 0, sizeof(rx_cfg));
> +	rx_cfg.swdata_size = PRUETH_NAV_SW_DATA_SIZE;
> +	rx_cfg.flow_id_num = max_rflows;
> +	rx_cfg.flow_id_base = -1; /* udmax will auto select flow id base */
> +
> +	/* init all flows */
> +	rx_chn->dev = dev;
> +	rx_chn->descs_num = max_desc_num;
> +
> +	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, rx_chn->name,
> +						     &rx_cfg);
> +	if (IS_ERR(rx_chn->rx_chn)) {
> +		ret = PTR_ERR(rx_chn->rx_chn);
> +		rx_chn->rx_chn = NULL;
> +		netdev_err(ndev, "Failed to request rx dma ch: %d\n", ret);
> +		goto fail;
> +	}
> +
> +	rx_chn->dma_dev = k3_udma_glue_rx_get_dma_device(rx_chn->rx_chn);
> +	rx_chn->desc_pool = k3_cppi_desc_pool_create_name(rx_chn->dma_dev,
> +							  rx_chn->descs_num,
> +							  hdesc_size,
> +							  rx_chn->name);
> +	if (IS_ERR(rx_chn->desc_pool)) {
> +		ret = PTR_ERR(rx_chn->desc_pool);
> +		rx_chn->desc_pool = NULL;
> +		netdev_err(ndev, "Failed to create rx pool: %d\n", ret);
> +		goto fail;
> +	}
> +
> +	emac->rx_flow_id_base = k3_udma_glue_rx_get_flow_id_base(rx_chn->rx_chn);
> +	netdev_dbg(ndev, "flow id base = %d\n", emac->rx_flow_id_base);
> +
> +	fdqring_id = K3_RINGACC_RING_ID_ANY;
> +	for (i = 0; i < rx_cfg.flow_id_num; i++) {
> +		struct k3_ring_cfg rxring_cfg = {
> +			.elm_size = K3_RINGACC_RING_ELSIZE_8,
> +			.mode = K3_RINGACC_RING_MODE_RING,
> +			.flags = 0,
> +		};
> +		struct k3_ring_cfg fdqring_cfg = {
> +			.elm_size = K3_RINGACC_RING_ELSIZE_8,
> +			.flags = K3_RINGACC_RING_SHARED,
> +		};
> +		struct k3_udma_glue_rx_flow_cfg rx_flow_cfg = {
> +			.rx_cfg = rxring_cfg,
> +			.rxfdq_cfg = fdqring_cfg,
> +			.ring_rxq_id = K3_RINGACC_RING_ID_ANY,
> +			.src_tag_lo_sel =
> +				K3_UDMA_GLUE_SRC_TAG_LO_USE_REMOTE_SRC_TAG,
> +		};
> +
> +		rx_flow_cfg.ring_rxfdq0_id = fdqring_id;
> +		rx_flow_cfg.rx_cfg.size = max_desc_num;
> +		rx_flow_cfg.rxfdq_cfg.size = max_desc_num;
> +		rx_flow_cfg.rxfdq_cfg.mode = emac->prueth->pdata.fdqring_mode;
> +
> +		ret = k3_udma_glue_rx_flow_init(rx_chn->rx_chn,
> +						i, &rx_flow_cfg);
> +		if (ret) {
> +			netdev_err(ndev, "Failed to init rx flow%d %d\n",
> +				   i, ret);
> +			goto fail;
> +		}
> +		if (!i)
> +			fdqring_id = k3_udma_glue_rx_flow_get_fdq_id(rx_chn->rx_chn,
> +								     i);
> +		rx_chn->irq[i] = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
> +		if (rx_chn->irq[i] <= 0) {

I think ret needs to be set to an error value here here.

> +			netdev_err(ndev, "Failed to get rx dma irq");
> +			goto fail;
> +		}
> +	}
> +
> +	return 0;
> +
> +fail:
> +	prueth_cleanup_rx_chns(emac, rx_chn, max_rflows);
> +	return ret;
> +}

...

> +static void prueth_emac_stop(struct prueth_emac *emac)
> +{
> +	struct prueth *prueth = emac->prueth;
> +	int slice;
> +
> +	switch (emac->port_id) {
> +	case PRUETH_PORT_MII0:
> +		slice = ICSS_SLICE0;
> +		break;
> +	case PRUETH_PORT_MII1:
> +		slice = ICSS_SLICE1;
> +		break;
> +	default:
> +		netdev_err(emac->ndev, "invalid port\n");
> +		return;
> +	}
> +
> +	emac->fw_running = 0;

fw_running won't be cleared if port_id is unknon. Is that ok?
Also, it's not obvious to me that fw_running used for anything.

> +	rproc_shutdown(prueth->txpru[slice]);
> +	rproc_shutdown(prueth->rtu[slice]);
> +	rproc_shutdown(prueth->pru[slice]);
> +}

...

> +static int prueth_netdev_init(struct prueth *prueth,
> +			      struct device_node *eth_node)
> +{
> +	int ret, num_tx_chn = PRUETH_MAX_TX_QUEUES;
> +	struct prueth_emac *emac;
> +	struct net_device *ndev;
> +	enum prueth_port port;
> +	enum prueth_mac mac;
> +
> +	port = prueth_node_port(eth_node);
> +	if (port < 0)
> +		return -EINVAL;
> +
> +	mac = prueth_node_mac(eth_node);
> +	if (mac < 0)
> +		return -EINVAL;
> +
> +	ndev = alloc_etherdev_mq(sizeof(*emac), num_tx_chn);
> +	if (!ndev)
> +		return -ENOMEM;
> +
> +	emac = netdev_priv(ndev);
> +	prueth->emac[mac] = emac;
> +	emac->prueth = prueth;
> +	emac->ndev = ndev;
> +	emac->port_id = port;
> +	emac->cmd_wq = create_singlethread_workqueue("icssg_cmd_wq");
> +	if (!emac->cmd_wq) {
> +		ret = -ENOMEM;
> +		goto free_ndev;
> +	}
> +	INIT_WORK(&emac->rx_mode_work, emac_ndo_set_rx_mode_work);
> +
> +	ret = pruss_request_mem_region(prueth->pruss,
> +				       port == PRUETH_PORT_MII0 ?
> +				       PRUSS_MEM_DRAM0 : PRUSS_MEM_DRAM1,
> +				       &emac->dram);
> +	if (ret) {
> +		dev_err(prueth->dev, "unable to get DRAM: %d\n", ret);
> +		ret = -ENOMEM;
> +		goto free_wq;
> +	}
> +
> +	emac->tx_ch_num = 1;
> +
> +	SET_NETDEV_DEV(ndev, prueth->dev);
> +	spin_lock_init(&emac->lock);
> +	mutex_init(&emac->cmd_lock);
> +
> +	emac->phy_node = of_parse_phandle(eth_node, "phy-handle", 0);
> +	if (!emac->phy_node && !of_phy_is_fixed_link(eth_node)) {
> +		dev_err(prueth->dev, "couldn't find phy-handle\n");
> +		ret = -ENODEV;
> +		goto free;
> +	} else if (of_phy_is_fixed_link(eth_node)) {
> +		ret = of_phy_register_fixed_link(eth_node);
> +		if (ret) {
> +			ret = dev_err_probe(prueth->dev, ret,
> +					    "failed to register fixed-link phy\n");
> +			goto free;
> +		}
> +
> +		emac->phy_node = eth_node;
> +	}
> +
> +	ret = of_get_phy_mode(eth_node, &emac->phy_if);
> +	if (ret) {
> +		dev_err(prueth->dev, "could not get phy-mode property\n");
> +		goto free;
> +	}
> +
> +	if (emac->phy_if != PHY_INTERFACE_MODE_MII &&
> +	    !phy_interface_mode_is_rgmii(emac->phy_if)) {

I think ret needs to be set to an error value here.

> +		dev_err(prueth->dev, "PHY mode unsupported %s\n", phy_modes(emac->phy_if));
> +		goto free;
> +	}
> +
> +	/* AM65 SR2.0 has TX Internal delay always enabled by hardware
> +	 * and it is not possible to disable TX Internal delay. The below
> +	 * switch case block describes how we handle different phy modes
> +	 * based on hardware restriction.
> +	 */
> +	switch (emac->phy_if) {
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +		emac->phy_if = PHY_INTERFACE_MODE_RGMII_RXID;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		emac->phy_if = PHY_INTERFACE_MODE_RGMII;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		dev_err(prueth->dev, "RGMII mode without TX delay is not supported");
> +		return -EINVAL;
> +	default:

Shoud this be an error condition?

> +		break;
> +	}
> +
> +	/* get mac address from DT and set private and netdev addr */
> +	ret = of_get_ethdev_address(eth_node, ndev);
> +	if (!is_valid_ether_addr(ndev->dev_addr)) {
> +		eth_hw_addr_random(ndev);
> +		dev_warn(prueth->dev, "port %d: using random MAC addr: %pM\n",
> +			 port, ndev->dev_addr);
> +	}
> +	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
> +
> +	ndev->netdev_ops = &emac_netdev_ops;
> +	ndev->ethtool_ops = &icssg_ethtool_ops;
> +	ndev->hw_features = NETIF_F_SG;
> +	ndev->features = ndev->hw_features;
> +
> +	netif_napi_add(ndev, &emac->napi_rx,
> +		       emac_napi_rx_poll);
> +
> +	return 0;
> +
> +free:
> +	pruss_release_mem_region(prueth->pruss, &emac->dram);
> +free_wq:
> +	destroy_workqueue(emac->cmd_wq);
> +free_ndev:
> +	free_netdev(ndev);
> +	prueth->emac[mac] = NULL;
> +
> +	return ret;
> +}

...

> +static int prueth_probe(struct platform_device *pdev)
> +{
> +	struct prueth *prueth;
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct device_node *eth_ports_node;
> +	struct device_node *eth_node;
> +	struct device_node *eth0_node, *eth1_node;
> +	const struct of_device_id *match;
> +	struct pruss *pruss;
> +	int i, ret;
> +	u32 msmc_ram_size;
> +	struct genpool_data_align gp_data = {
> +		.align = SZ_64K,
> +	};
> +
> +	match = of_match_device(prueth_dt_match, dev);
> +	if (!match)
> +		return -ENODEV;
> +
> +	prueth = devm_kzalloc(dev, sizeof(*prueth), GFP_KERNEL);
> +	if (!prueth)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, prueth);
> +	prueth->pdev = pdev;
> +	prueth->pdata = *(const struct prueth_pdata *)match->data;
> +
> +	prueth->dev = dev;
> +	eth_ports_node = of_get_child_by_name(np, "ethernet-ports");
> +	if (!eth_ports_node)
> +		return -ENOENT;
> +
> +	for_each_child_of_node(eth_ports_node, eth_node) {
> +		u32 reg;
> +
> +		if (strcmp(eth_node->name, "port"))
> +			continue;
> +		ret = of_property_read_u32(eth_node, "reg", &reg);
> +		if (ret < 0) {
> +			dev_err(dev, "%pOF error reading port_id %d\n",
> +				eth_node, ret);
> +		}
> +
> +		of_node_get(eth_node);
> +
> +		if (reg == 0)
> +			eth0_node = eth_node;
> +		else if (reg == 1)
> +			eth1_node = eth_node;
> +		else
> +			dev_err(dev, "port reg should be 0 or 1\n");
> +	}
> +
> +	of_node_put(eth_ports_node);
> +
> +	/* At least one node must be present and available else we fail */
> +	if (!eth0_node && !eth1_node) {

Are eth0_node and eth1_node always initialised in the loop above?

> +		dev_err(dev, "neither port0 nor port1 node available\n");
> +		return -ENODEV;
> +	}
> +
> +	if (eth0_node == eth1_node) {
> +		dev_err(dev, "port0 and port1 can't have same reg\n");
> +		of_node_put(eth0_node);
> +		return -ENODEV;
> +	}

...

> +MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
> +MODULE_AUTHOR("Puranjay Mohan <p-mohan@ti.com>");
> +MODULE_AUTHOR("Md Danish Anwar <danishanwar@ti.com>");
> +MODULE_DESCRIPTION("PRUSS ICSSG Ethernet Driver");
> +MODULE_LICENSE("GPL");

SPDK says GPL-2.0, so perhaps this should be "GPL v2" ?

> diff --git a/drivers/net/ethernet/ti/icssg_prueth.h b/drivers/net/ethernet/ti/icssg_prueth.h

...

> +/**
> + * struct prueth - PRUeth platform data

nit: s/prueth/prueth_pdata/

> + * @fdqring_mode: Free desc queue mode
> + * @quirk_10m_link_issue: 10M link detect errata
> + */
> +struct prueth_pdata {
> +	enum k3_ring_mode fdqring_mode;
> +	u32	quirk_10m_link_issue:1;
> +};
> +
> +/**
> + * struct prueth - PRUeth structure
> + * @dev: device
> + * @pruss: pruss handle
> + * @pru: rproc instances of PRUs
> + * @rtu: rproc instances of RTUs
> + * @rtu: rproc instances of TX_PRUs

nit: txpru is missing here.

> + * @shram: PRUSS shared RAM region
> + * @sram_pool: MSMC RAM pool for buffers
> + * @msmcram: MSMC RAM region
> + * @eth_node: DT node for the port
> + * @emac: private EMAC data structure
> + * @registered_netdevs: list of registered netdevs
> + * @fw_data: firmware names to be used with PRU remoteprocs
> + * @config: firmware load time configuration per slice
> + * @miig_rt: regmap to mii_g_rt block

nit: mii_rt is missing here.

> + * @pa_stats: regmap to pa_stats block
> + * @pru_id: ID for each of the PRUs
> + * @pdev: pointer to ICSSG platform device
> + * @pdata: pointer to platform data for ICSSG driver
> + * @icssg_hwcmdseq: seq counter or HWQ messages
> + * @emacs_initialized: num of EMACs/ext ports that are up/running
> + */
> +struct prueth {
> +	struct device *dev;
> +	struct pruss *pruss;
> +	struct rproc *pru[PRUSS_NUM_PRUS];
> +	struct rproc *rtu[PRUSS_NUM_PRUS];
> +	struct rproc *txpru[PRUSS_NUM_PRUS];
> +	struct pruss_mem_region shram;
> +	struct gen_pool *sram_pool;
> +	struct pruss_mem_region msmcram;
> +
> +	struct device_node *eth_node[PRUETH_NUM_MACS];
> +	struct prueth_emac *emac[PRUETH_NUM_MACS];
> +	struct net_device *registered_netdevs[PRUETH_NUM_MACS];
> +	const struct prueth_private_data *fw_data;
> +	struct regmap *miig_rt;
> +	struct regmap *mii_rt;
> +	struct regmap *pa_stats;
> +
> +	enum pruss_pru_id pru_id[PRUSS_NUM_PRUS];
> +	struct platform_device *pdev;
> +	struct prueth_pdata pdata;
> +	u8 icssg_hwcmdseq;
> +
> +	int emacs_initialized;
> +};

...
