Return-Path: <netdev+bounces-10773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E359730406
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 490D5281358
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6263C10782;
	Wed, 14 Jun 2023 15:41:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51951101DD
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:41:45 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2130.outbound.protection.outlook.com [40.107.220.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F261FE4;
	Wed, 14 Jun 2023 08:41:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=enYmpBtrg2qWSmiAnwUuw8N1yd07FQs5cA4h+o7tr6wpO3xRpi8+kfsi9Soun+Jqriv9xPdOMzCisxqWPBzEGSf9jXjrh5GFbcgdzL+XKrEfjOFFt6QMKaeQDbAzc4FHX/GpYDBiOY7Y4qnuOYkdoYQt5oulkk19APYtoULvUqf8Id1tUccrg72ztdivMasTNNkTV2XmjMh12OtZRBxCxuBsVGi8mVZZaFaNv5HduJBewklOTpKscIevBF8c6HTGFx4tnV/MXfBMJAcQEQjMhRMILfNTvWcug5NjHBRnoltL5dJciogQz/0pgDNIpdL2qgDu2qqfj0CBoaJwxUsJqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5IOeGXfJXYs372OHtKM/3KSk2Vbx7iwLOduXAoZPag=;
 b=Zt2VVBul/Od3nJi8Vl4o9Iq1Fb24hL/bN3fRokdFy0D5TIvpcjweGRGw3ZxO/melQZYW6dlJODBLTLz1L1PEgrUWAJRivBtS6aNwLGWldwQjeg7MWcLZzPoeNrWwgYIqOQq5GnQKKEWIPR522RZhb17c3o35gMzFcpKJjYW3+YOIZ1Q/+3r35iFxggho78VmX5V77yETq4wy0SDP4aSevoTECyTT3VBarbW1ESW3WgIj4nMO4P1JxkdepxzscF9XMkZe1t7wagTLbx+0KzoSLvG9HEnoLHkotbN8z2vUhgCIwcTNKA3M+v6BKXMC1UzhLpuot+O3qmt7euYv1QyNyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5IOeGXfJXYs372OHtKM/3KSk2Vbx7iwLOduXAoZPag=;
 b=bpyTiiEQLFTAfncirOMnQz9+vgj9sBHH3DtLUDcElkSwcOPA/QhBmd/bcWv+8JrEwGXj783n5PZJ51hvvTjPyET3lLDBO73UhEZaOi7rqFVPJ+5IYSrYr+YPvK5Lbhr+Wtdsw3QaFNx3E6CO1V1YrhFpsgjfEFE1mpKf/w2Suzs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5894.namprd13.prod.outlook.com (2603:10b6:a03:438::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 15:41:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 15:41:40 +0000
Date: Wed, 14 Jun 2023 17:41:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jose Abreu <Jose.Abreu@synopsys.com>, stable@vger.kernel.org
Subject: Re: [net PATCH] net: ethernet: stmicro: stmmac: fix possible memory
 leak in __stmmac_open
Message-ID: <ZInfrBTQDkay+UXP@corigine.com>
References: <20230614073241.6382-1-ansuelsmth@gmail.com>
 <ZInUzhOZ/3TGSQl9@corigine.com>
 <6489d5a2.1c0a0220.c53b2.acb0@mx.google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6489d5a2.1c0a0220.c53b2.acb0@mx.google.com>
X-ClientProxiedBy: AS4P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: f8bc56e0-9ef9-40fc-d074-08db6cedd8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lWgtnq3KV1/uvcXYL90QV5Tp8kstQTC74tURKJWoEYbMa6Xm/v23yc/KiE2P0/l1Iin0hDAozfLpQ68PBKZuOdvcSSYA2pDU8OaMR6/iSjSWKBPGS+W9O1aJ/6e8LiJM3soXSO4Lm/vR/7P5LuXocQc84Wc46Wk6KbTe0LmbZHpc7wHw/eqXUfHR3G4iurNJ0z8tg7xpPk3psndmlsxYlZ/rAZwjo3Grl0der1WBE+kCtzOZDe+94bQHeaeKklEvdSBlK3TkOonJEaZleP96v6OJTDCsE+aEQnCJrOtyTSDFAftzZaBh41J/ESjTw6rbmidZkfK1oqWqfTnRncEDlOkuybbdcGEOfZF17dVAZJGLijaHXiaQnICMKQGEaMZrPyGacLClcrzRiuMOz7VSxc1pDkVh2scVyl0mXWNw16XQA5/zcFSY5Y7j8d2p+TMuEvzNg3y4qXuhh4JBwCDuHS3gwWJAObxlWsYtUh+1Xmy/PxTJ/hU6HAvmTIL7gxRamG5kNmT+l5pKlOdhZUzqow9ARYwoylzmFikI7n1zawrLo3qpfsLv4pFIjwtlloTpyaTa3Ia1VYSveI5DbjVRq6pjCbRq0ll2k6sKH283aVM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39840400004)(396003)(366004)(451199021)(86362001)(7416002)(6486002)(316002)(8676002)(41300700001)(5660300002)(83380400001)(6512007)(38100700002)(6506007)(6666004)(44832011)(8936002)(66556008)(36756003)(66476007)(6916009)(66946007)(4326008)(478600001)(186003)(54906003)(2906002)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T5mvNBMcBZXY4+Cp9U5MGK6km+LrnM2K0FNP3FvTvJf+HEMUugiEcvzmGtpG?=
 =?us-ascii?Q?XWQ2ZPCgh06gQMbAHVhRuEX2X5smPC01g/dX9Pd1lyIpcZ1ENn0uyzjwMX0O?=
 =?us-ascii?Q?wGsQjnS4gIYBQNI1V1K6P/a4/C23TSpNlFeCvj7gI4ubZD+kHe3eVjREmmo0?=
 =?us-ascii?Q?T21Kchao0q+DaSX6HSgCYxKDzmTapJl4FMAmc7yI1EbnOynOyQifZnw9tz6t?=
 =?us-ascii?Q?7NKAaAytj9O925yL3qiAIczz5FTRaJd1hDdVeQErhWFdftUQkcFT5RUAnEv9?=
 =?us-ascii?Q?9AbnwwsdhWwae++QAdBleXoJQvKRqtgyuNglTq39ebVMJ0K0Y5ypHOBQb67h?=
 =?us-ascii?Q?xoFV4oVkQ2s2k+pdtzBFM2soYeB/oOX9ARrpeJ5N8QiS4deEzqw4aRY/NQTN?=
 =?us-ascii?Q?j3B+J3tbjwGx+1kXptiE8ioqcFZIyQiUB38Kl/t5iTDjORSoGmg2quy04MJk?=
 =?us-ascii?Q?6SiFX8Z+oeDfFLo6GyjiO9CmyCZFohEbxkdMPHbS3SZbCQxBQCG0q/tjH/1b?=
 =?us-ascii?Q?a3OFUtc6ZeYMRnnPQDwWgVOWzIHCKgU62L6mycfD+w07d2NwYOYghQo1RpNY?=
 =?us-ascii?Q?RHzYW6qjfQn7DQcf3PBdKc5nnf+Fy7GmHJqHL1HiQC2U9KAHCNA86mxhVZP2?=
 =?us-ascii?Q?4AT1qk7G267lLtde/iJIucPlNQ+23PtUfeJPf3naf2PLp3NZr9ebFLVG7fmy?=
 =?us-ascii?Q?3MsxTH0LqFDOanTPZVlN6KvYxe/e6o2aiEjB+myGgq1A7B+ljt3UNAIz/8TI?=
 =?us-ascii?Q?uj/ehgZtNWns/TGdBPJA2ykXnnBGtlsIxoES6C/h5KTcPcIkIWAkBhMYa9fg?=
 =?us-ascii?Q?SQ3iKSjUzHiAvFm77sRj06jSeJB2sFu3l0/VPPwA9AzVjOBzbJUiFiJmcv+/?=
 =?us-ascii?Q?lEghvmfD0v+aqGcV+yBB7axOFN6AMwQh1sBa97oD24YEDWb3e3vE1k8YcDIg?=
 =?us-ascii?Q?hbb7RvTC5Zzigvl8X8DVwruxZZkddaDAsQuCh2IlpUuiW0lST9o/RGAiFYv/?=
 =?us-ascii?Q?cVSzXm8BCcJP0TSonj34pj+6vTOYHkQh0D8jWJ3W1nBwjoSSJfiodST0i9TJ?=
 =?us-ascii?Q?lUz4TW/ymqlA+ezyO+2PRKoh0GOPRo2dIl+wF006yAIu3CX6v0q+jpLrfurq?=
 =?us-ascii?Q?SABgOVPeeLecVQlp2Cp9e2ZNfpJfvXewgAW+ArSmnZ0AgzVeV6vB5S3BnSLb?=
 =?us-ascii?Q?3BD0PpBHOGshfaJ7ja7HKDn3XJz4A6P8KGzkznYL4DrqjdgaqDnTsvq5/qaF?=
 =?us-ascii?Q?aZHQ8NyfXyLD5uNg7CyKci/lG5B3A57JnyCPA2QF7yeJPfMN6m8Qxzn1gHRY?=
 =?us-ascii?Q?CiNQzGfuMoz8E3m5a6189gZLFQO6XRv7d6YbGk59mnE1pfqIYhiNrMYafmkM?=
 =?us-ascii?Q?R2d4YoIGeb1N/b1+SetP6GYGWVZSy+ZT2Gu+eG1pDg/SrECnR3cEAKA6Z/+r?=
 =?us-ascii?Q?AnQcZdTS/nJkedtek/jAxU17CvQIq109zlYF/oHHQs6mWdwoiHsMVu4Hsb8o?=
 =?us-ascii?Q?tB/P+kk2uBsK2VWP4tg4StuPQi32XmmPmSc3Vcj2wjtZn+VaTkH+Dwb/5MRu?=
 =?us-ascii?Q?F88QEIiQ9ZyDZ9ECBLi3N5tHk44rNJAmZcIMWgsnZeslNUIx1zIJLtC/EY3k?=
 =?us-ascii?Q?TYdY6U705/4nKZMjEG8OLwwUZXANGtdA6E7iKz+C40hOzq1IjUB9tQktlZd0?=
 =?us-ascii?Q?q7WXnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8bc56e0-9ef9-40fc-d074-08db6cedd8ce
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 15:41:40.4981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VXR3LOwHnvo4z1+Exc9wTUN13AvX2tNXdkYc+YeGU86zngszLQKx9/O3V27lwvCgoLns15YObLSyJveLyzU/b7q0JLvqbipW2GPsPC+7lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5894
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:18:20AM +0200, Christian Marangi wrote:
> On Wed, Jun 14, 2023 at 04:55:10PM +0200, Simon Horman wrote:
> > On Wed, Jun 14, 2023 at 09:32:41AM +0200, Christian Marangi wrote:
> > > Fix a possible memory leak in __stmmac_open when stmmac_init_phy fails.
> > > It's also needed to free everything allocated by stmmac_setup_dma_desc
> > > and not just the dma_conf struct.
> > > 
> > > Correctly call free_dma_desc_resources on the new dma_conf passed to
> > > __stmmac_open on error.
> > > 
> > > Reported-by: Jose Abreu <Jose.Abreu@synopsys.com>
> > > Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma conf before open")
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > index fa07b0d50b46..0966ab86fde2 100644
> > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > @@ -3877,10 +3877,10 @@ static int __stmmac_open(struct net_device *dev,
> > >  
> > >  	stmmac_hw_teardown(dev);
> > >  init_error:
> > > -	free_dma_desc_resources(priv, &priv->dma_conf);
> > >  	phylink_disconnect_phy(priv->phylink);
> > >  init_phy_error:
> > >  	pm_runtime_put(priv->device);
> > > +	free_dma_desc_resources(priv, dma_conf);
> > 
> > Hi Christian,
> > 
> > Are these resources allocated by the caller?
> > If so, perhaps it would be clearer if a symmetric approach
> > was taken and the caller handled freeing them on error.
> >
> 
> Yes, they are. Handling in the caller would require some additional
> delta to this and some duplicated code but if preferred I can implement
> it. I can provide a v2 shortly if it's ok and you prefer this
> implementation.

Thanks, I think that would be best,
unless the new delta is enormous for some reason.

-- 
pw-bot: cr


