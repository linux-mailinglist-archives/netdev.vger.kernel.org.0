Return-Path: <netdev+bounces-1572-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D1D6FE529
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 834FD1C20E64
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B439E21CCD;
	Wed, 10 May 2023 20:33:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A620F21CC0
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:33:49 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5109D4ED3;
	Wed, 10 May 2023 13:33:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGVE4uamoHCMiLRGuM0tSV70kWIZKxSszj8znX5Ze60tx3TCPrL1YE0Igp+Cu/wBT46eynkDEHt/sdn8uDblbfIuxGWFOYRJqwTCIBgo13fgHiwlRiFbnHyRXOBA47mwY+jggrbnvE/s2YSnY+iTt4MukDTxupK9pCOF659nEZvG8vI0gHePBou4b8InctMJxqlJ6wM0tQwhCUDgS686wyK6zbKb9W4tirmfdhTw+1qXq/T97wfWZNBRBI+gKpk5yemE0Xjp4tmpnndsk/CqaZhu2IVYaJRFk+1iZ4xFZhR+0gkXNZpZJ7FhVdZq976QCiZ3sz/T9YgIuDaF8HlLgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UArRzrLtYhAwJBxof5odgeplXhAfKOBD4VW90ibkiuE=;
 b=ksgE4cwKKakjS86UEAxEH/pUCCbkMWhH7hsPR2RRnxNuUCOTL6eWiefEyaKBhofZca7XKShB2yh9dH/rgpxFkvCPjgEL7a7ijYdmS8ioIOvhZgrO8EG6UytBpNEL4fj/HEIiQX5dmvj4owVwprLcYzLfuiv/PJyE8rHNvhJXBE7CKBP9fudzQ4JIn8t8P5w508dz3oJzVeI1gqQtGEKNIoZB49BPUqsURNtANLpeef1NSiYb8j7a0Rg26ORlYwxi9WYQQS2w+9E36J4DiCLkmS16f0IhuysUvVcYJpnR69WePy4U/FakqXQo+I1GVwy2hEiIkQ9KzTLyrPha+hsPIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UArRzrLtYhAwJBxof5odgeplXhAfKOBD4VW90ibkiuE=;
 b=rZ20jrgqMQCVuazqPnav9G2X9ZXrg7cSMIAf1mfcUzFwo3cvUh4m+x+N0kpLpgFSmGuU3uibp/aIm5Su0iZ7WdukP8Npvj/EXEnYqiKcR1cFZ9oD3MYcwlfSP+7pBkovQQVDWEr9AIeRdJVX6DkiKSYUo0qql2WPkvctnAjbF5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7348.eurprd04.prod.outlook.com (2603:10a6:20b:1db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:33:37 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:33:37 +0000
Date: Wed, 10 May 2023 23:33:33 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Colin Foster <colin.foster@in-advantage.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	UNGLinuxDriver@microchip.com,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net v1] net: mscc: ocelot: fix stat counter register
 values
Message-ID: <20230510203333.473u4sxwbnkwv6kj@skbuf>
References: <20230510044851.2015263-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510044851.2015263-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: AM8P191CA0017.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: be7897cc-1c83-4ddb-37b9-08db5195d4e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qZrm/a/znRJEhJrh686h9qwv5Fa8D1JQNkrg4cJ3uuL7yG6D79ARiMEEZ9dVfXdHNloFB4ZBFtpkm0ox1YHVogHv+ksBxFjqNAWEmY3ffZpv4IjpDiXuQHIrhvuSGu87jnaBKHWf+4GdEO5pKzj27+yWOGB3UpTALszPucew7V7y5tIFhbQqILCUQ3ZJKQpngbLNzMVPKkfvAYAj8/VA5USl3bLZ1m5QDtUXlaQrlbgEiznHq40R/Gxbc9sF9DvYrMfHbBpkq9RN8/7+1z4JiouUaFKf89ZKeHDMiiARb3ZTxwnlD7GetTUD5Rx36DlnPXGrbNPePfp/KhHOjzEn6xjMpOfuEY1OuwqjIFn/vqs1q3LKWa0Rbtgm91yE56129mw+vNfHmxZwXjz5v+IdhqStDgl2KKqL8u6b9AcnilWRJ2tP2NCfQJR0wDMess6k4sE46zYPN9qGtPGfKtg/P2i1HX+YAVRUVsW8KrrOxudCs9hQJyf699CJ5DF3GqCQyXVWOF9sfOSnoGavUPJrmDsbY4lHuD7vLf461uBc4OuWXzSgaEFGuUBTDjS0U+tv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199021)(86362001)(54906003)(316002)(66476007)(66946007)(66556008)(4326008)(6916009)(478600001)(6486002)(33716001)(41300700001)(4744005)(44832011)(8676002)(5660300002)(8936002)(2906002)(38100700002)(6506007)(186003)(1076003)(6512007)(9686003)(26005)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YH78ePjivoqawQSDr4Utljish/3HaW09xtzShWaVJeGiKJV9e2lSY/B1KiuO?=
 =?us-ascii?Q?TjGzx8iWPtLDYk7pQpmeftL86W7f4eCvqteSvkTuo5lp2EJ4/H9n7yPUZbQy?=
 =?us-ascii?Q?unZq/WAswupk3I7huKsKrrCq9dGKQbPdrwnCPSq8atJ0nmPFkCSEApPx+7EF?=
 =?us-ascii?Q?zihCge0hblRhcHLmBrVgj0fj/k0C7ufs8wbltBVrSaVcntXpv33wlKDV5YV6?=
 =?us-ascii?Q?qS38tsaXhTxLicm7UhbgVQGvog9rXaXTkpzahsVlHiTGthHA31a0XlXY++wt?=
 =?us-ascii?Q?oxG8ACXe7fuWAve77vSCi0XLI4wcB+SytlZ4IojtLmm4TGjCW/Mue65k3hRt?=
 =?us-ascii?Q?2r/x2lBPyoSS8EmfTQxQd77PDmSqK2r/mXzg18p84baaXsHHj4yBwuNzAkDS?=
 =?us-ascii?Q?aOu8nCI8Pi/EXq/7A3rD/N54LanTGaK3YREK6uq6HvJbLNRvIH3FxRw8cR2e?=
 =?us-ascii?Q?3m0qg1Eld92DqNB882qesU069OV4rWtb+7rIDOv/IGobMUJ+xmzd3pHf57rT?=
 =?us-ascii?Q?b2M9oAs3MrjYJe3yH3X+CP3X5vuoBJovl5ujOs2xieMDVqTbjdhiIEZQNbHv?=
 =?us-ascii?Q?z0t+VgV6QpTc/vDgT3aSJRpENpe9AFOyPN4ki4AoVR1ok//JZkjHPmE5PRSn?=
 =?us-ascii?Q?PEgyrpdUNYkwbrtzYHvQaM/bsgaM+UiBPRLZIyyIfqVluY2xOsiC3v2WH25B?=
 =?us-ascii?Q?5mMqrC7oKILGumhE2Glm7cin4tU5adXHbvU0iCcyO0pYEb8NYcOVr6ZbhToh?=
 =?us-ascii?Q?TTtHibHMCM2F3itCwHROG5Qur/ylLrF+tDykfiMer2hbiM0APKCQykUnGdAz?=
 =?us-ascii?Q?QGhlacDs/8mIHEKH88t0woCuQ27kU33g6fg8qBWeslRNJJAEiI4NExadJ4DS?=
 =?us-ascii?Q?LLYXE3AiIkFg4G68WSNL1kETKsJwJHeFdMUM6jCL8zmniH9IM1g0EurPEDe6?=
 =?us-ascii?Q?WKcq/G6iIOPHuwpTOkhZ9nv+iyeN/UqA7zA6rCS2ShsBRq9M1YYfBQNUV96e?=
 =?us-ascii?Q?IJxJ1L5KJp9gYQvRAOwPIQ87yw+Oj9KRh+yCJ8qEau807HfRtKv8CRAh04Sj?=
 =?us-ascii?Q?b1HE4ByRBHfNzxocVMAFBPzBRLQg5qXaenAhqpVEPq4VxzMA+9VLLnLufqS9?=
 =?us-ascii?Q?LfjWnLlnt/x1eMHjaNNV4U1KlMva9tCEldgdZqw8wbpw2sdPcL058C00Up1k?=
 =?us-ascii?Q?X0BPphBirKgjX7EqjYxQ7gnqXRpjBqbre2vH05v88Fvz7yKthFafmy0RUDAF?=
 =?us-ascii?Q?m+9hoJdkU/1uq/aqDVG2tqC+f+sppkymBS+wM6zSkCLbYRX8PckWMV55plkg?=
 =?us-ascii?Q?SIF8rcA2wVjputHa4DsJRSVjOyxZO+e4s6CSToyoJ+RHrJHpi30YXsDLdHq4?=
 =?us-ascii?Q?ln7+hVw5N3BPtg73u40MYZOIukz6amTESzDnrlHd2KL+N/4Ix5A6Wezfbxd1?=
 =?us-ascii?Q?4buJgkGpqUTFcwzc19FbeyRbSYCs482sS4oZ0+2ArJPwvfQp3IjlYueVU2ps?=
 =?us-ascii?Q?KYD434QWu5HT0++fGonDBf7zvm2NDRzzp7iZ7Y9zRmM1RkFzQhoQIhkoe9zM?=
 =?us-ascii?Q?mqO7ZGKWoz7zuER2ct7BzPvXDFvCL8gMN12iD/DjklxNCe/JP2hRXCpj6tWv?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7897cc-1c83-4ddb-37b9-08db5195d4e1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:33:36.8948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6zyArzfX9ED8cg9cVzFhAYBexjoLbDii6EPycJW+c84BsZozICR/MffLrOe7EOPkHxXtARBFHa9aqKLjTiAEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 09:48:51PM -0700, Colin Foster wrote:
> Commit d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg
> address, not offset") organized the stats counters for Ocelot chips, namely
> the VSC7512 and VSC7514. A few of the counter offsets were incorrect, and
> were caught by this warning:
> 
> WARNING: CPU: 0 PID: 24 at drivers/net/ethernet/mscc/ocelot_stats.c:909
> ocelot_stats_init+0x1fc/0x2d8
> reg 0x5000078 had address 0x220 but reg 0x5000079 has address 0x214,
> bulking broken!
> 
> Fix these register offsets.
> 
> Fixes: d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!

