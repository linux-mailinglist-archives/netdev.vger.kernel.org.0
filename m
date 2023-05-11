Return-Path: <netdev+bounces-1763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F2CC6FF155
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3121280F20
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC6619E45;
	Thu, 11 May 2023 12:15:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1506519E43
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:15:09 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2094.outbound.protection.outlook.com [40.107.237.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1E5D850;
	Thu, 11 May 2023 05:14:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/1HEP/SjyCYIMebMmpIjGwp6ebD/lZ4DELAGoGWa/FPSYUO+7JChPR5tTz98v7spiOr5jqxZxBzEN9Rx+3dHF0prexGj8DNEaW3QEOAwF4OnEE3PeAw8FduARFMNXP330kR1IIQSl1gqqxF0ypHn0ecg6B2/DnTX8efLvNd6gUK2ZlSGFvdgGwzUBdMhq/qpQd8PrRSyIbp4cm6Lc0kZYzoPoJHZeMfNoly5n/W4F3G9gGlkLhSH8hYjjTD4bERCm04jX+6Cxt5+Y8sgERcCLsTHyM6tRotdfaOf3b1stnw00gCrGOR+MSeOc0rmslbngepxrMJtvU1BIZ8bWHKhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E36p7b7JEbKoESAylJNtlQTxXQT6IvaJmRM+O6bxGn0=;
 b=nIBGBX8Zr0b4pMGrIJsqqkyA+onzpp49gq1PIH0wY5U04pqrdzjlH2Q8IRF2YoJnLkfcfpNnEgITmBDeZdkn3/Ie0yYPKOunyU+0Wc2LuccnogXSHQVfudZJ0r22u0sNej6lbpIVF88qW46+aVfZqAyyMErIsYKxn+hm+C/PNvxVBEnBYR+LPSSCMzo/RV80XT2zRmq+bF58mcRSCJ1fAeQ9il+4HPERnLfjIrdEBsLOQQYR72PC53ORTHPcfDSDM80rFFCV/kHdKS0IbENqWGU9t+togTyq9RTsmLcvmnuUTZkqV1zzLvkWevwTEIuSc3ymYLx4wsURBituzRYhmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E36p7b7JEbKoESAylJNtlQTxXQT6IvaJmRM+O6bxGn0=;
 b=vztAVVJgiWAjy6sio0qKFzZMam9/xmh1xvbVC2oBlQ2pY2ziHlspwApLe9u+UQ14QNhNfgw5yAzIf4PvSiKNxbEJs6dFcsRFq25VA56f9qDcqUGoAsTT/kXuOBa7YzIICpGxco9J3kqKP6KWxE+1RH5jmrbw6mLS85L6zqOxr+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH8PR13MB6245.namprd13.prod.outlook.com (2603:10b6:510:25d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 12:13:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:13:47 +0000
Date: Thu, 11 May 2023 14:13:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Qingfang Deng <dqfext@gmail.com>,
	SkyLake Huang <SkyLake.Huang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next v3] net: phy: add driver for MediaTek SoC
 built-in GE PHYs
Message-ID: <ZFzb9Fnc3mJAQal9@corigine.com>
References: <ZFwVwlN0eHjo_xB4@pidgin.makrotopia.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFwVwlN0eHjo_xB4@pidgin.makrotopia.org>
X-ClientProxiedBy: AS4P195CA0029.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH8PR13MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f467e58-d4a6-4c1a-7d1a-08db52192c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lo0vZAdioYke2zGdlKQB9HMH3dNuj3yD2TWJVLAq9LicV3e1KwCZL/AWXUtWYjkWKn6s7fQ8zDvRy6R3COpQaXqNElTGW4j4yxVoKH+2k6ywVq1YkJkOWIst5rMzPmV9Wq39os35Fe6ECPHTTn6WqE3WpOzTw3KwhYZ5YGsNjF6Cl2j6aP7jmi+e2zl4CIkuIngO/tDYdEOEIUsFBE/ESqbJ+zvIGFK4hBMFkUoYdyHdiP1wvNahn24p25VPpkcisVRKN5nfUXBaTnzAAJCUQ+rIOLGbb2oy54wmck6gJDedsxRA+yzirkwhg09cAyqoIJHZCCUjOt6ZjFLmQwUhnTB70/+dNVQXvcmbyK6zanOMGDirTkdx+sS7g4jvutnQrbYTLRy6MHBcKjj/f8oUgmNVUYBoCfdEkceVot6CN4+S6wPkhperRF3ABEcRX7CE7s6rBYQyrF9UY1yubIJbolbbUnzXN3TStazp16LuqeBc+b494W8+E5dhLUFUo5T7CRkuVjrZDX1BSlLeUE5MNecA9GsXj/x5dcTkT6mKyQ95ShEXmYSIif5I/y1d/ZwcnBj9DKQdsiPungS39zFIsQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(136003)(39840400004)(396003)(451199021)(38100700002)(2906002)(6512007)(6506007)(41300700001)(2616005)(5660300002)(83380400001)(7416002)(8936002)(8676002)(44832011)(4326008)(6916009)(66556008)(66476007)(36756003)(66946007)(316002)(186003)(86362001)(6666004)(966005)(478600001)(54906003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IKHxoiGSaDV36chD1wbSuHEtXfOciGQxCrGLFsdXi3zD3RNi0qUBTir7KI50?=
 =?us-ascii?Q?AdEnkqRM6Forfyc5I1lKkSFQvUqXB6FNaHdMzAnom3TDHTaUqOiqAnhAWZRC?=
 =?us-ascii?Q?Ss+IwnwMrDJEswlkGy5jimSOru9HAyr23cQP0PPGuYaNpcg/Xx7KzPaGIota?=
 =?us-ascii?Q?4FekkTAwEGZzhw4XhqnoI0Eum90XIQY/TYqZCEsppVlBQXjuyUeh/XkjI9pN?=
 =?us-ascii?Q?L0lqYvO65S8fe7ta2DK8Hv1WxiWLKiv1axVRtp5jbItDGfNQseeciOAzbIZf?=
 =?us-ascii?Q?ORi2TNHySUmOAYlOX8eyBDYOSQfdY+0pCtfE8mCjEYH6pf87O7mQ6Lw1lQRo?=
 =?us-ascii?Q?KDvuDU4/n6S4RukoEvUpsIo11bt1YcMiss2pB64V6TA33DchmX3oHk1Y/7Ee?=
 =?us-ascii?Q?3qaWd7xjLvS/7z/0bBXP9hs6dGhgffeyZO0R7jiMHqxKcrlRXMPLob7Dhl4o?=
 =?us-ascii?Q?pZqCxx7wpog1t6PsAMl3Jja4SNFGKrT8ktjgdRribSu2hn7HLxarkmjnVwIs?=
 =?us-ascii?Q?4j/1bcj7u2wjHXBvWoohIYpXt6wwaIyCZV222RY6oQTobj3BaY+b0eE92LpW?=
 =?us-ascii?Q?Veqac7I6DmwFlJSTOP56/DWaFGyTl8AaipG89BZwBs3JGJpbPR3YhQWT7RL7?=
 =?us-ascii?Q?eoZjDtaPuXpasHUE6HGswDhdIMnMIOnrbnNuZ1LuquPXsuQy3/qCgeb+ipI8?=
 =?us-ascii?Q?i4UEDe8ffYmktcNDJ17d37ert/xZ+hijDDJrXr8gqzfkEbEpcEXDMQWmoM8K?=
 =?us-ascii?Q?ByLkb94JdXG6dOD30+Vrz3NY1FUVf2TD+oSQau2vnaeGrblnYa5JNSfS68ZI?=
 =?us-ascii?Q?D6MPIvQWZkCoja9SYh10NtKVbXdQTdcLVWG2eCqF5Ppyqvys86NhMdxWYZxL?=
 =?us-ascii?Q?bMr7WaTt3Yy4a+jPHGuE6Y7zGUbT1a88Ufr8omJh73gQ9F5T7/70QD5VDKb5?=
 =?us-ascii?Q?IGql7ZsMEDfSA7OF04Wrokk1YTWr9ht12HB+jR0DfEhIlZpInQvXe/qILzf0?=
 =?us-ascii?Q?N6dD6ODafLEjyawmRhOkWi7+NfDJICb1TgwZmQHNGJX3X6Z9vomqriEHjyrg?=
 =?us-ascii?Q?8VrboY6WP8BhilJlGoMDzDB9qf1szY3VhX/BorWK250kVm9mGMVrtcvWNnhN?=
 =?us-ascii?Q?Jgf33qDr5c/QNNJeUJJalO+GFe8/p0ZvuhRZED4ls6+m1q++YW9gdK1akezA?=
 =?us-ascii?Q?Gszkp3vejDaWBQ9P65eyxxeAjlg0z+8fOMa0jDfAP7WdWveh3tO5NB1Xfodv?=
 =?us-ascii?Q?UPW6oQkM2IBml01/BGBLm9TIRVFcLfvc/GnjU7rcqHS+bK2PYSWN/u7KQ5Fd?=
 =?us-ascii?Q?5rN/yd+NE1vXrSyyHjaK3jqjLT6J4rp2nJMJX6G2rxKD6Q+H54kANJCm5nGT?=
 =?us-ascii?Q?fIKpI8FVz9+RzoDGQVu/tGxDN3wcftOymOJiTZR175kHBke+wsFCx1Kiq826?=
 =?us-ascii?Q?t6hc5jRtp5vZMBITAKHZvDk/KLsniLBukYYbDF646r3SAYIJ86cPUKoxyo+2?=
 =?us-ascii?Q?ih4gN/uXa5q/MAfV9oOEO9wSZe4GEJB4J8PNjA5fZMJcDbewMzcpXARstqgM?=
 =?us-ascii?Q?jbg3Eowqr4lwA8CEBPUJrFBfRjiYElvKUAWlSfGaBcyLQVDdUokzfu8uOxA3?=
 =?us-ascii?Q?cpWbnEGbUpPDUqz7Q5ZuHpYtPQFB82J7/uwNIfb9lLc+UaiKTakgi1Qc2GCb?=
 =?us-ascii?Q?cVMLBA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f467e58-d4a6-4c1a-7d1a-08db52192c37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:13:47.4910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ah1p6q+vHjaItZyavnU2GDvr2GpCFcON7FgWlqdqCe6Wo+svmyMyM4V/QsmvyaatiwELzjJ4nHNRyQdtyVXX6qUEfc91ej1zS0oNXDNcgQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR13MB6245
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 12:08:02AM +0200, Daniel Golle wrote:
> Some of MediaTek's Filogic SoCs come with built-in gigabit Ethernet
> PHYs which require calibration data from the SoC's efuse.
> Despite the similar design the driver doesn't share any code with the
> existing mediatek-ge.c, so add support for these PHYs by introducing a
> new driver for only MediaTek's ARM64 SoCs.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Hi Daniel,

some minor nits from my side.

...

> diff --git a/drivers/net/phy/mediatek-ge-soc.c b/drivers/net/phy/mediatek-ge-soc.c

...

> +#define MTK_PHY_RG_BG_RASEL			0x115
> +#define   MTK_PHY_RG_BG_RASEL_MASK		GENMASK(2, 0)
> +
> +/* These macro privides efuse parsing for internal phy. */

nit: s/privides/provides/

     Please consider using checkpatch --codespell

...

> +static int tx_amp_fill_result(struct phy_device *phydev, u16 *buf)
> +{
> +	int i;
> +	int bias[16] = {};
> +	const int vals_9461[16] = { 7, 1, 4, 7,
> +				    7, 1, 4, 7,
> +				    7, 1, 4, 7,
> +				    7, 1, 4, 7 };
> +	const int vals_9481[16] = { 10, 6, 6, 10,
> +				    10, 6, 6, 10,
> +				    10, 6, 6, 10,
> +				    10, 6, 6, 10 };

nits: Please put a blank line here.
      Please arrange local variables in networking code in reverse xmas
      tree order.

Link: https://github.com/ecree-solarflare/xmastree

> +	switch (phydev->drv->phy_id) {
> +	case MTK_GPHY_ID_MT7981:
> +		/* We add some calibration to efuse values
> +		 * due to board level influence.
> +		 * GBE: +7, TBT: +1, HBT: +4, TST: +7
> +		 */
> +		memcpy(bias, (const void *)vals_9461, sizeof(bias));
> +		break;
> +	case MTK_GPHY_ID_MT7988:
> +		memcpy(bias, (const void *)vals_9481, sizeof(bias));
> +		break;
> +	}

...

