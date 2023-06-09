Return-Path: <netdev+bounces-9515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE0E729971
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D2891C21129
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACD41642E;
	Fri,  9 Jun 2023 12:19:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FE315484
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:19:44 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2110.outbound.protection.outlook.com [40.107.102.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AD6172E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:19:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNlL9Oe/lXw4bnP0fkKoT+WxejJdRrAY7+h3nakb+sALuH60uyB1Ka3TvM5piTuwf0JOINnTpMQ9og6nMCk8hRukDSILUih+WzOiFvyzOxXsSSqDrlsR5Ls3d9KOlY3OfRP978lRj5zJlA6LryQvoDwdvCUwLRzU8IlcBaoIb4KAxub8ak3Wc30C4rsGg6Dc6c1ygAmvhDrTr+9hBxigxqNbWo1UceEvacEtZTfky0mDCRX2Tt/3mkK/D6f2KmYoo982aqM5DkYPaME3mhyQFMZ+e0m+IRPh2a9OOIFiSwiGcqtUm5E5VzC510CWovHtgwTxgmMoaz0vi3r47QpJ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omFCwtu69HXo+Do5//PB477hvB2w88GoPf67n5IirK4=;
 b=Tg3ksJiB4M5K/1NI3wpnbCpVu2EqThWX/nf/b8Ffx+c9tBVmnI4UYpDSulQIE+ZwGcl2Zg0qDOK2fckTW0BdDvFryC5MztaO0Egvh8s06h3ebnrMORs891iKkB6pKrBe3MDXaRpDLjw3pB3o2zcBrlbShbif1+wS0ewKhroKNCrTqyY9UxG6uRj99o9zWCFU4bNzvefgrhZsNu1VHR1B3bwS9kkpajUoDYTofrW3vCu8D1MV6fdSEVb75f6V4jTUVyb4Iee8EAHfmYZbb0ggLuG4cMbvdPu9HI8kPJB9ifua3eI/9tUKbh1kdohHJRtnarWWz9j1tDPZdMtIOtfjWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omFCwtu69HXo+Do5//PB477hvB2w88GoPf67n5IirK4=;
 b=fagq8MlO7HJmQlVixYq21Cdbmsr7HfYHWk3ZGl5KV0e49dj0Gr2guEiC5XHqCA/XE9Qvy0Y1W4kWX6afTvtJYKxjRDMHCtD8gtO8S9wIJBnqQa/e0UG+CA6+wtpNJhp1Kbgaeudeo1c/rRAszAvgueMY2WAoItmmHPD/3egidj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6067.namprd13.prod.outlook.com (2603:10b6:806:322::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 12:19:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:19:23 +0000
Date: Fri, 9 Jun 2023 14:19:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tristram.Ha@microchip.com
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v1 net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs
Message-ID: <ZIMYxaANiLvd0blQ@corigine.com>
References: <1686274280-2994-1-git-send-email-Tristram.Ha@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1686274280-2994-1-git-send-email-Tristram.Ha@microchip.com>
X-ClientProxiedBy: AM3PR07CA0059.eurprd07.prod.outlook.com
 (2603:10a6:207:4::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: 415f1d8b-62f0-4296-b86e-08db68e3c280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MaOamYqbsGmcGkK+DDjm0Vk93VKEUPF4iq38Q3I2xHskyqwiBraGbfZ+ypARgHLCkX6Xd4RbX8wnNKM6CHtOhXusOVHWQezcu/YpSk6HKVGipkOQ6IDZBjrVOC7Kr+GtCn/OyQcgYvWJ5KNSuheFJ2pXvDQ6TSDVjKZN2TiNVDpOBR94HHenfH7b+FbV/1Str+K53mndcKyQRXAVUOVjYGCUcJ7NhhWSAbfQVKR556OwlHiFlWLVCm+/LYu4pkMrFBMASbOCIrODN3W8ZpqoOaDsxrd+o3zlzdKSZ7wUg3r2LbaRB2RkAi0jfF+JMKbKYNL4rQjGodu7i10PZLoi3CaJBzLJnYUC4jadwEl16rTwsTQl+wz5CJMW4u9esQeXeZf+bVVE4BVFnLD43ZZCW5vLDzdtFThJ+CPGLWF5WbW8aRPMYHqH53uF7P8322NsgNz7uXgbqjl2gA2VhbMBoBUWsnqKfJVfrhCZM/3UWN5n++POpR1TT1/Twb7khQv/qyC1ZOw8+Zg8LrIGdUFrGEZ91Wtq1HyOY20ZYy46NKCkxZ1e1CrPhUi24v4Y4aeF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199021)(44832011)(54906003)(38100700002)(478600001)(8676002)(8936002)(41300700001)(66476007)(66946007)(66556008)(6916009)(316002)(5660300002)(4326008)(86362001)(36756003)(6666004)(2906002)(6486002)(186003)(6506007)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FsMd1IUrrYGlSboIqjqiw9+U/bEWF66A1W5qckLCwGaKvq/hk5Q1erF3f+s4?=
 =?us-ascii?Q?cMVwzUjimxnP883X0BZ2TYeXcU+HgBtJHi69mLcBCFvzZQdsDIDdw93X+Ogo?=
 =?us-ascii?Q?zovLSHS0ARJX5lgGZY4ll9z3qrPUtXejDYbflnLREkyCwbL39vnE5Njrr3eL?=
 =?us-ascii?Q?DiXDWIXopWI8EqQvY9RGu1eUHl3xGkLvD4ux0+45iJyFjAmgD0R2fHIuxzQ2?=
 =?us-ascii?Q?MZWzbcs3JnE3OU0DbiOOI5+X5XrrfYv9JcWrMLD34WyHDBj3tptpMXJ7JaBm?=
 =?us-ascii?Q?OSyPgt5ZD6JAJrN3LY1y5BoEJAu5DhJwN35lS7XQ30MaUAzDtushoqmGYbw0?=
 =?us-ascii?Q?ar3H2kJ6TrVIbRTmDuNDMGYVezx8j0rlyoG08WF90QM9rc5/h6JluW/7ZpXn?=
 =?us-ascii?Q?c7yqLi7qmQ/RiWHXIgnXMDaUPpPMnJuyXHcm3UH4pvAoCG4hNs/ev4VMP0wt?=
 =?us-ascii?Q?ZR3WphuriqQPUznzUtYfWtUBwFoqIR1oRwLIqz7NuiTivr8Nfnkaqk0cngRS?=
 =?us-ascii?Q?aDkTedAH/4fhif2idswdw7QJRD238uaMhVcTnY8cnpe4fISNjet4hyMoqlBU?=
 =?us-ascii?Q?/ljCwOIjgQpDEtV6T5BUz+a+eBaA2+ZQr7Xx2+ULLSCH6TJ9BeLo5j4UlcLp?=
 =?us-ascii?Q?QNexSllXM2PvK+pP/OSyl9KSXyY8dYcUKYN4JZypayFN7P24r0CvsgRyyg+p?=
 =?us-ascii?Q?7vaLX0ij2BFNFVE9MkvgwraulmJ7sZH2/BEZ5WdCCOScxMXm3Mhkwu7w4CQP?=
 =?us-ascii?Q?B5N8br2lXg+QXiciQ3v0hp+HaeDxjrYvDkJDMUcuFU0H7S7z1ryNPRhbQcT1?=
 =?us-ascii?Q?LaKKMlnIKmTyR9zw4VzEY60SRLwYr5xaWDAeVqXK2bfOMKA/xcKW7oizHuUR?=
 =?us-ascii?Q?KkopY0RpEVhoMgZRuEDS3N6ymtNPS7GcBcErR7dlg7qa+xqaILiEmoG6WHQL?=
 =?us-ascii?Q?KzdRu8ehHF3BkuCsjwJ+fro7HYCE6RuIdGSofMED+oq/+C0Mdpb3g46KEI0h?=
 =?us-ascii?Q?nH3wpv3xcgDEOUYpie3QwHK8L5LL6LDN1qZ1117CQ3mtJ3udwnLDSrDrmirE?=
 =?us-ascii?Q?jS/Ejd9hKAmHEke5wGi6qvdD2YptknU9HjpLdLx70Z+FsfdZbGZV2zEOA5ps?=
 =?us-ascii?Q?pHprOpEAykgkGwECNZdkZGEb1QKS2VTABzgzhXC7r3Z5FIcN6m42cDAm+Xu3?=
 =?us-ascii?Q?W5+J/5KSTreNihWU5lyAkvxjyuRexEgkhHh3xjRphyxD2JxIpNr4iYSr3NF3?=
 =?us-ascii?Q?LyW/MlpV+3/bQ8xdR4fu5CeLIC6BIt270+rzLca8V0vNSp7Z0Qlj2ipqguDX?=
 =?us-ascii?Q?AQxDrSexZg2e7Fj/0OlrofruiKodInFHs9pIl9nXNwd/rp2yebz0F8dlSdf5?=
 =?us-ascii?Q?8ruSjbAbMJSfsGiTEIcOw/PLcjVCBG95GRxAo65MO1CyWQfNLyfIajY1TFmB?=
 =?us-ascii?Q?/p+j7XFGQtsiwLrqXOzreduBA9DIOSgcchX0eYGVTvOCYUSgArMFfQjzRNlC?=
 =?us-ascii?Q?XAk+IJPRG8PFXgDufdGjXtxiCc8JxOFEnNCoPqTZkpcmrAHVs8FAW9+vQ3aR?=
 =?us-ascii?Q?kZ4+lgyt9N2IJKYBnnMbjw8+Tm+6cYPL7nu27Ff24L9x4jVVmAX1wT6yqVVg?=
 =?us-ascii?Q?bgP4i8GuOiSgHDh1FITZxLDZwLvFQFRGHY2DajYTkzX2Oue2SL2cbbkqNzEZ?=
 =?us-ascii?Q?JMqkuw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415f1d8b-62f0-4296-b86e-08db68e3c280
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 12:19:23.5203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1KrWfh0k/vA9ajd/FlAQNl8k46vO/0StZWiei2BQXXxu6Rlda25Okos4fdZt4OXyxHHYjsBHJEjqm2qMNZRHtmgSzIUeTehCO10pu0nKONw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6067
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 06:31:20PM -0700, Tristram.Ha@microchip.com wrote:

...

> diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
> index e1c88627755a..1a6a851d2cf8 100644
> --- a/include/linux/smscphy.h
> +++ b/include/linux/smscphy.h
> @@ -38,4 +38,38 @@ int smsc_phy_set_tunable(struct phy_device *phydev,
>  			 struct ethtool_tunable *tuna, const void *data);
>  int smsc_phy_probe(struct phy_device *phydev);
>  
> +#define MII_LAN874X_PHY_MMD_WOL_WUCSR		0x8010
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_CFGA	0x8011
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_CFGB	0x8012
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK0	0x8021
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK1	0x8022
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK2	0x8023
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK3	0x8024
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK4	0x8025
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK5	0x8026
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK6	0x8027
> +#define MII_LAN874X_PHY_MMD_WOL_WUF_MASK7	0x8028
> +#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRA	0x8061
> +#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRB	0x8062
> +#define MII_LAN874X_PHY_MMD_WOL_RX_ADDRC	0x8063
> +#define MII_LAN874X_PHY_MMD_MCFGR		0x8064
> +
> +#define MII_LAN874X_PHY_PME1_SET		(2 << 13)
> +#define MII_LAN874X_PHY_PME2_SET		(2 << 11)

Hi Tristram,

you could consider using GENMASK for the above.

> +#define MII_LAN874X_PHY_PME_SELF_CLEAR		BIT(9)
> +#define MII_LAN874X_PHY_WOL_PFDA_FR		BIT(7)
> +#define MII_LAN874X_PHY_WOL_WUFR		BIT(6)
> +#define MII_LAN874X_PHY_WOL_MPR			BIT(5)
> +#define MII_LAN874X_PHY_WOL_BCAST_FR		BIT(4)
> +#define MII_LAN874X_PHY_WOL_PFDAEN		BIT(3)
> +#define MII_LAN874X_PHY_WOL_WUEN		BIT(2)
> +#define MII_LAN874X_PHY_WOL_MPEN		BIT(1)
> +#define MII_LAN874X_PHY_WOL_BCSTEN		BIT(0)
> +
> +#define MII_LAN874X_PHY_WOL_FILTER_EN		BIT(15)
> +#define MII_LAN874X_PHY_WOL_FILTER_MCASTTEN	BIT(9)
> +#define MII_LAN874X_PHY_WOL_FILTER_BCSTEN	BIT(8)
> +
> +#define MII_LAN874X_PHY_PME_SELF_CLEAR_DELAY	0x1000 /* 81 milliseconds */
> +
>  #endif /* __LINUX_SMSCPHY_H__ */

