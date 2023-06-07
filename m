Return-Path: <netdev+bounces-8920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9878E7264BC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1DEE1C20D66
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2318370D0;
	Wed,  7 Jun 2023 15:35:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C514AA5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:35:04 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EE110D7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtxtwMEpHJ5D94L1KfzGqhjI0pj70cW5P2V68FCEq8fRcQmhj7Vkji4DEY+XduTmmLI7nwLVYx2WIgrVeilGZEcaubptrLTHsS8HfBqEGgm3n5L3GoZRO0PGEYgejUoLCjEBcGtH3dapm1byEv996bnnihq6wzYG0tmls8ZJOFVRAfsDUzqX0oF9d8rMMgcrT9T9byarj8rLLuR/kO79iZNWAMCSKv1VAs/Ni33dvhjYQR6iRqx9+++eqLjHEN+D8rxI/Jm8S0CtN7UCq/ZdxxeXO17vz1iNX8yIx8tbGr073JuKzVr67lCRCUXV5Hbz6+/6Hs0vMWSIKn01eU6X7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wAcjKFj8+xnAW6nYPnDF2TEVMFldF3mGYf3W94ToZQ=;
 b=mTNk4U0g2wlTQUJT+8yOeWv7LOfzubyZRh6y5QvsQCO5ccxZbRDqd3t0SE9qGp3QtmNDG5mvPvTkkJT1gMGzt/MSzcbKTbuVoxFBwRGB4Nd3BISMHBur7TXNAY9EwS7abQB1bbT6dugsR8Gz2hdVNGeVh1uufgYH0glH+79G8VOlBA+CSTkM4BSoeC3aeNfCCD/3xuEBrNf33XEXt5hkb7Gn25bDzW80F4rvw3iuKxosZkos91DdYlCDLYEQneMRwSNS2Mh9n1b93D1DcLqvbKtHWVfsu3DRADOm2209M2vK0pAxNRE0ibGak1fBBE+4fGGDn0p1JC0dFF8DPGkzGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wAcjKFj8+xnAW6nYPnDF2TEVMFldF3mGYf3W94ToZQ=;
 b=fWFX/3I4Dw8ck7P/apjNNjhmeFqZJAALBxRNT9aFFI0SriN0BBYQ/vbJgs77kemL3sthO2eSm4/ibolbQ7AbYu829lHs+LeYbVpR+u8i+DEz7jQ2cYIXEYOKNJZFeHWRBnVGl+nPCT0td7GX91BduLpE2PAhChySBwHVwrSVoKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by DM6PR13MB3851.namprd13.prod.outlook.com (2603:10b6:5:249::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 15:34:58 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 15:34:58 +0000
Date: Wed, 7 Jun 2023 17:34:51 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Feiyang Chen <chenfeiyang@loongson.cn>, peppe.cavallaro@st.com,
	alexandre.torgue@foss.st.com, joabreu@synopsys.com,
	netdev@vger.kernel.org, loongson-kernel@lists.loongnix.cn,
	chris.chenfeiyang@gmail.com, Yanteng Si <siyanteng@loongson.cn>
Subject: Re: [PATCH] net: stmmac: Fix stmmac_mdio_unregister() build errors
Message-ID: <ZICjm8WsSPAa6YJo@corigine.com>
References: <20230607093440.4131484-1-chenfeiyang@loongson.cn>
 <ZIBwPc95jooavl86@boxer>
 <20230607160219.7dd5e867@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607160219.7dd5e867@pc-7.home>
X-ClientProxiedBy: AM0PR02CA0092.eurprd02.prod.outlook.com
 (2603:10a6:208:154::33) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|DM6PR13MB3851:EE_
X-MS-Office365-Filtering-Correlation-Id: 22557260-fe41-4777-1045-08db676cc033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	D76oP+Phj7nV75mpRzqfw02heqesdS3XCmTs1AP9CwaS56v6cmgSxGy9UuCtw4j8pkjQuC16itYdAePQ/cM30pvzR0v+QQ/Xl6ItjQ6dZVTOaNrbY/qBCmyfOIxr0KnGMelgylaHzkKB72YN90kNVBLXLEt8MmDDeY+Q8wSlsmuzKHQvMZ+thchqTzukLdZjY6YLa3BsyyXmSph9G31KCKTSgNu3u6i5Jgo+iRAy6AWBnSKev6itPomWs7s5WaWezeC0ZH4JZYnQzPgZ8+PYxVMUhXVphmKmvZ36ME1AsJqD+mLxaRtl65ZUYeAhqy9V0aw1dAN0yPERbiCal9XBltU3Kel8U06BVA5XfifcSWKPE6goECEOUG/1W0RvPEh5ibYoJPArdgYtrqGVkEux2y4yuO9J7EvHVviaoosKz4XWEXaRwjX0SkwD7tWShIhrtjX024Hf4/HMitiJB7tewcBqVZqPwSlxPpKz6KRDTYaRR+foTOE35LvIFFMWzLl19CqiB747X/N6ZWirQhnmflTWG+uviQoNg9pCZlHnqQ+5patFUVpOouYgXeWjYhB+P1yVgom2ET1CnmJeFZ49mg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(136003)(366004)(346002)(396003)(451199021)(7416002)(66476007)(66946007)(44832011)(4326008)(6916009)(316002)(41300700001)(38100700002)(8936002)(8676002)(5660300002)(86362001)(36756003)(2906002)(66556008)(186003)(478600001)(2616005)(6666004)(966005)(6486002)(6506007)(6512007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vyj1rQYysCy2Irz97fz1tJiPKaMnFu/AxwczzZj+EdSAuqXdBEGHegwKCouQ?=
 =?us-ascii?Q?1bxT1ZvOYNd2dRrCqBeNziLDmCGHTbXsez/qdBBAebrEE1Y8mIvMiNWckcZm?=
 =?us-ascii?Q?O/Kzw8igVmAAI2u5zx5XCTUncjWmdfE6j/Vk4Tod+otFbZXLPu683H77OGKl?=
 =?us-ascii?Q?pWHl2/0N/QdVx+WQJnsgdstZvBuzWjIgDZPG/TvSeYFSj8nsio4AGV5aunRG?=
 =?us-ascii?Q?p3kUusJOhS8WBT1sXaMzOmhLgLRZM4cq7JMk8SnZ8mqdTa8zQu2mVC8Q2KHd?=
 =?us-ascii?Q?oaY+1utT5BeyyuMl5D2G02SigoieIydHwUywMoO8QmgruDvqXY+MvOf6JfEx?=
 =?us-ascii?Q?7HvzZINubv+W0MT5FMFhtJFBsSP7iHr6yXAVgNC45v4ALZG85sbL9PRRcJU7?=
 =?us-ascii?Q?0VEaqu3KMTWDAPmStyOu2wCGblVvxhwlduf8765CdK+UTp+XocU3N/yWYSQx?=
 =?us-ascii?Q?CsoZG7hDlNR8QhpgeTEp6tqMDbUlnZRGmF4qDdeAeqSccB7mnqy8qQ0Awt+T?=
 =?us-ascii?Q?dNg59OrRlP0xKkDfwaqV3NX8AsU8Wr2PaSC+ur5fggiBE0E7cequ0Tjto4TY?=
 =?us-ascii?Q?HUBRwY9I64aZ9zWGekzgb7+Amd48t44mqm0Jb2laV/OU2hJiYRSsoaco85TB?=
 =?us-ascii?Q?27Q4AppWkkveD3CjZm0iAyL9cqGwj8eyWPhKmMB1MzLnQF/ZsNQ2M+32kQ1K?=
 =?us-ascii?Q?g2EpdlLPI0kJno2/4wUA67on/SwFCkARNGWLma1Te3tMcVoT7RFKP4Hrl4EK?=
 =?us-ascii?Q?KTVbxW8j7PFv6KYYvoZ+jNV7cIakDLn9KvX86+4ksV7lRyrYonqJJ0wrt9Rq?=
 =?us-ascii?Q?ldH9NDbkhZaQ5Sbs7JjpZ/CJUdpBoE8yyS3CBtwGoO20V+bOiX/Wv7lFJqzf?=
 =?us-ascii?Q?LG4cEz5ha5YxCK375lZLs294R4Nqv2xXXksROE8xBFrpDqH8h7fIjdKm3uwO?=
 =?us-ascii?Q?2O9AUNLldBV/aOLG/PlY8Mw1CKIWvgstakSlB5c8145v+VsCXHiZsVNhzKLA?=
 =?us-ascii?Q?xefCN5IWmn+JSZPR/hYqfGCpGymhrH8wlHNHI0v/Lu7wshio651peaifJ6yA?=
 =?us-ascii?Q?dwkLoX7RRaE5992UXj17pq/Ip70kSg1pDsWhUCKGOgSWEaGF2Jtr4Stm3uGt?=
 =?us-ascii?Q?d1aRDxjW52XgjS7XovGwnarxLB2b9USEdVofgXhi/t3/FzKOQQKwmJFe4q1R?=
 =?us-ascii?Q?SJsV2RoFSqNLAAKYf50N01DKP0RjNKt3fWBIbb7P/71/mHrk4vbO8kyP8mBH?=
 =?us-ascii?Q?nR7NW933jAkLqZrnuMG9+5EGaSkZKiPca42tsSfMpWsZWtKQs7gp14zaKKOL?=
 =?us-ascii?Q?PpKCIu0VNmn/Tlw+UxdSoNKZ7Sc1I//APKY9pvNx0kiWiOhHXGXbHLjzN9jW?=
 =?us-ascii?Q?ERaHrF5UECwU4WX7yJyfHxxIIevyqIGjR0VzoKKLofLlV0GBsMRG6+akQO5o?=
 =?us-ascii?Q?AaolJ+Nz9C4MYXOa0a8x3rchMn/jJZ4VcqBvWTCt57V0YKgYniWFjARmQUxk?=
 =?us-ascii?Q?t7DXp+3aJkmOHEHEi8kx72c+3B0k5wsBJpCjRVJPBV/3S1TnXsAdrl5JK5mV?=
 =?us-ascii?Q?xZpsa5X+fwXM1Yynrf4ttzdR5U5LsIm6Rd7pod6ZhjWoZiMVpnewgpdYaTzh?=
 =?us-ascii?Q?hHvjMQrpVd/7NgmMG6i3PBZiAOij4myN2j8wBNO2ouUql+GY61socddXwCpT?=
 =?us-ascii?Q?/UM+tg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22557260-fe41-4777-1045-08db676cc033
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:34:58.3844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1i56/rTTeaXEQL24GGoUAYs3n1PgaF6MYSXt/RhgHskdjpPJKkD1Zjqxmp3Q4AKOnz3uzeGAocrz5YLsImJFXoL54+C9x73c+KJOjIn1XY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3851
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:02:19PM +0200, Maxime Chevallier wrote:
> Hello,
> 
> On Wed, 7 Jun 2023 13:55:41 +0200
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> 
> > On Wed, Jun 07, 2023 at 05:34:40PM +0800, Feiyang Chen wrote:
> > > When CONFIG_PCS_LYNX is not set, lynx_pcs_destroy() will not be
> > > exported. Add #ifdef CONFIG_PCS_LYNX around that code to avoid
> > > build errors like these:
> > > 
> > > ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
> > > stmmac_mdio.c:(.text+0x1440): undefined reference to `lynx_pcs_destroy'
> > > 
> > > Reported-by: Yanteng Si <siyanteng@loongson.cn>
> > > Fixes: 5d1f3fe7d2d5 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
> > > Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > > index c784a6731f08..c1a23846a01c 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> > > @@ -665,8 +665,10 @@ int stmmac_mdio_unregister(struct net_device *ndev)
> > >  	if (priv->hw->xpcs)
> > >  		xpcs_destroy(priv->hw->xpcs);
> > >  
> > > +#ifdef CONFIG_PCS_LYNX  
> > 
> > wouldn't it be better to provide a stub of lynx_pcs_destroy() for
> > !CONFIG_PCS_LYNX ? otherwise all of the users will have to surrounded with
> > this ifdef.
> 
> I just sent another fix that has been in the works since yesterday :
> 
> https://lore.kernel.org/netdev/20230607135941.407054-1-maxime.chevallier@bootlin.com/T/#t
> 
> It uses a better solution of only using pcs_lynx-related helpers on dwmac_socfpga,
> as this is the only stmmac variant that needs this PCS.
> 
> Sorry for the mess,
> 
> Maxime

Thanks everyone, and sorry for my part in this mess.
Let's keep working on the solution at the thread above.

-- 
pw-bot: reject


