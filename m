Return-Path: <netdev+bounces-1402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C406FDAF9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBBF22812BD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79366AB1;
	Wed, 10 May 2023 09:42:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B3820B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:42:27 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2104.outbound.protection.outlook.com [40.107.92.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9295D469B;
	Wed, 10 May 2023 02:42:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boyi01OTOBb1UuVfSd7rjba3EKhJtFBk60NocdsWENOA96JEGYjDqf/F/WY1ZJwYukfTWQlmIa+v+kiB7DOLIdjtWch4UvHlmvy59H9ppRl0G53vviAt2ftUYfeiJKvsf8t2e1J95DvlFDIDOvZGn3ZR1Cq9ILv9STuh34DFXEgEzDWIb4XV6Qm/MF13DjNFMnoXY2PEmgYuc++ohx6F35ZsT1GnrIh5GnMJp0HIUqy/HV4aGyBFj4A+nQPccSa5NXuPjpk/AC9wEgP/jbzfKPvmHJ2qrrdPZ86FkBgg9xEIHQyjv1vMyox+NS32pjuwwlqME+N2KmcXB6Ljp/RzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9SnRtIk25akYcBD4ABFC5gCWdL+GrMUFhogG4KpVu7g=;
 b=SdC25PzEdvdMRfa8LKlnw8ZMzG0EsnoGYjVv4cQn46R1XHuVxpzNR3QPlAv1k0m5V1WmV+XEDxGS7Xr6eMEXSHFFR+TV9bGYvLHFinnUaOY8LeuaQeWQE8mL0ii/rTvpaPSgbUrVUakW9m04U4NblneCvyX66nibcZJ6+mN364AeUFMHMx7BleDvYRHXbwcBHI9cDqrgbzAeONe1Hvzt93kzPT8FoDsezZmB6umawMQ9G9M0aBAKYrWYjQJ+9pj32BBcz4UV8d7vGowtwGKVlkiUYGtGqQEOxnIYLzynbQ79kHcZ+YwStonwUTBhWKz8jjTEQMR1ndQX2w2dfRlBnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SnRtIk25akYcBD4ABFC5gCWdL+GrMUFhogG4KpVu7g=;
 b=p9oPpyTJOEzpdk84UHzx2RIuvq41urruxMRpA8WHcU88KV542M6Ygvx2Wju/aqHrvEl7STZmwGWXWcrNYGBAna3zWT9kr0/c1PVLSnUC8WoiKOUQV+G4YQlYcDMQTGckyoqfpoIueziTnDZR2phKhFqUpjvM1oLin7sMv3hZfUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5417.namprd13.prod.outlook.com (2603:10b6:806:230::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 09:42:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:42:23 +0000
Date: Wed, 10 May 2023 11:42:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Colin Foster <colin.foster@in-advantage.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	UNGLinuxDriver@microchip.com,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net v1] net: mscc: ocelot: fix stat counter register
 values
Message-ID: <ZFtm91360rfOtBR1@corigine.com>
References: <20230510044851.2015263-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510044851.2015263-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: AM0PR08CA0010.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5417:EE_
X-MS-Office365-Filtering-Correlation-Id: b11e4abf-c1e5-49f9-453b-08db513adb8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iOinf2O58ihQHdUeSkfCeGlYuf9rqcd4/DSxBEsUxtUmiTMtEowWnuU7f1nwJhdYLVdsssOdzmemP4d0KqNXbCtePkOvGCZJvZdU8fprJXxcmu99DZ/z4vVrTz4XZdQ/E+xU45jrD04W8V07fhMm8Trysgib7a/vtIfk5kyU873mVMsS3EztI25A032kMYHW9nmEuKQjoIBpyFQj3SH4UBdqRyhSKLf7uspPFh8SKtR86gHQtEYIxYJc3sKsvQPnaaTmAyKP6mcDyHZmTS/g+txyfprvW0x5p2Bgr4oy1Qx+n5uuATvS8l6x9L9lQsb6/PhC570DdiGvCwO8obgfcGOWsiUlVizxOs6FsKcFUOqrTsFP24CqrNEVG+7gj8uM9c5PjPRLD2/zICss6vetOZazsVkSMRlljN5gHUwbXN7uSRYCwU6y9+W2sH3sEA78Dji8m2ydojjEFUYqViHdD00eGdUzq/ruZk6MBaekRg4+fP42uoqI+rHYVVPGCZB3eB95+3IAc9Ku6laH0bLhcLM85kUAMWQr20qJmA4nrf66vz59Xh4925UsPLyno+Nx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(366004)(376002)(451199021)(6916009)(83380400001)(66476007)(54906003)(41300700001)(4326008)(8676002)(36756003)(38100700002)(8936002)(6512007)(6506007)(6486002)(478600001)(66946007)(2616005)(66556008)(5660300002)(7416002)(86362001)(44832011)(2906002)(186003)(316002)(4744005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HL+YpOn7gmY4IGtd7onk+MyiGwnrh0Oe9SnSVp0DQyts/vwXoU2M5f3Mv/Lu?=
 =?us-ascii?Q?p6WXJpMKTUVl01+il13dUfeNJAMFHoNNUdOSlYqu6CPJvzZzH7YyGbNTyWwz?=
 =?us-ascii?Q?6JHKYRwfa2T8KdC+s1PiiYzdVTiJ5KHf7yGp+9HIQY2J7h3363sTQ1zBDOF2?=
 =?us-ascii?Q?XJGPqloHNa6aWZJwB667lf8UxFJYJls6THgq/j24Z4lNm5TrUbQH7onl7IVj?=
 =?us-ascii?Q?9t6z8nXvjIl55FTQV7P2YtIeJz+/d7oszQKkPJfkIk17TJ0ofFjI8FpUUiPP?=
 =?us-ascii?Q?ndv1QdcaKwsMMkpvPar2ZmtH7DGYqN3DWt0HnGLXpw4oLfWY89y/xs8gR0sv?=
 =?us-ascii?Q?8mVP9mpv55VMPEk6YM+ir9Qn9abWdUAWoBmLe6bWJ9tRsgFV1anAzUV1jQHt?=
 =?us-ascii?Q?2ZeOv/HiRfzl3W8DlK5fhQj6tU+feB9V1rZLiNSSDmFY5gAloqnvOmNPfXAD?=
 =?us-ascii?Q?gBssmFqg02vuUh7Wh7EEoMuefbvWqNF0cf8fTSaeS6Fob5BWBBo9/z54muH4?=
 =?us-ascii?Q?z/epALpLW+1zYFXOtcJ3TSiOzbSdMjrDmESOxltZjVzU7O1Mn29tZLkqRYEL?=
 =?us-ascii?Q?Os+pDdZTlXN+eTRuWBULP8aZBNrpbXvSxH9DI4zdK7pCGZO40o3gM0BWcnEg?=
 =?us-ascii?Q?gZLLkr5I3p55QFO9WOjoyeCeCBy9KmmIiUsLPjdq5USqIomzoSltHNl16KcR?=
 =?us-ascii?Q?OQ2dAnkbf6sHt8I7bMXcxojCxPx+6u0AF5d1tEZFV1aIeCX1HzmtJG07o3tE?=
 =?us-ascii?Q?JxO6lf32yxGAh1r1MnDOLspwhz0p6QSlYw3kZIjzaj2IAetVv4qHob+ZzUY5?=
 =?us-ascii?Q?NSO3bpqcnURtT0+e+XO3OoNF88cOydFkr1o9ejI8CrZHuVb3QU4CXXrt3Z99?=
 =?us-ascii?Q?pLX8Z2Sn3EXj9YcU7HJqL5lgF0qZQzcYupYK4dg99UCdu05jriQBvZH4k+Vs?=
 =?us-ascii?Q?CNzEZPS1he2ErD8EUy/VyopADkJVD9Qmu5ba9wtj7ePABca0t/LuM+wexmZ8?=
 =?us-ascii?Q?XPosTkCqZTlPy4k/t0H+egxJlSFhzlcZ3x/gqI4uEf0oBjlVzHeb7p5pyTv3?=
 =?us-ascii?Q?fvlBgb+nUuSqQR93LroqMoSk0FGXitxtMTTavDHMpKSPmNH2O2V13PRqzqzT?=
 =?us-ascii?Q?pCGSoKwougfsTXS5mDcLIqOx7+lY3gXWI1dMnNPSWyliAqWjtI1ZnMzaG5Xc?=
 =?us-ascii?Q?VETEEtuX6jPQ460+J07LY29eb2xbjEcBlS+k2JKr+iS0IwqxXGFBZCstxuB2?=
 =?us-ascii?Q?P7B9tLrDt1XD78r0nDT6/LVcHGnXz5DEePm5ki9QjLbQ3tzMvr69PbzOLf0s?=
 =?us-ascii?Q?rJH5k1diI+4w4Db/Bmjo3g7WipdJMSBTtug6ZJtSqgQsJD5U5fkkQL5E+zAi?=
 =?us-ascii?Q?CNFXPVn842x9BzUwnG1zQbsAHB02sZ86YUAwRbpN/G5Qmx9ne+o6W5ivaheB?=
 =?us-ascii?Q?8OS2ua+ZVnI0xLcAbEWSg6xfGafbhxJlFpQRHnvUcBg+tiGOqZ3rTR9snjON?=
 =?us-ascii?Q?9LHd+oFDRDUanSK2W6fKO1ecFPXiKC2RQSgZ0Kyi3lq1AP47k5e8NceoRMyi?=
 =?us-ascii?Q?lq1IGVa7HivQsxGOlMWPbXuRLalvnJ2fn2RREakuJ/4lwF81TPFt3BoQBb2y?=
 =?us-ascii?Q?5zmsw9v+qDyv8H1Se5tqVhtiJ71OyMc2noouEd2mV4NcklEzj20DhyKNPu7W?=
 =?us-ascii?Q?fng5nA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11e4abf-c1e5-49f9-453b-08db513adb8e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:42:23.8544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oqCmsbP+g19yLcNOlJ8k7jiMEOf/Bh10wHhYFHU0u0hDuTaSoR/zfZdNLPAujMrWqOoiUBI+TGhF1k5WUZIZyIiNuZpn9liY0SL1c7Elos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5417
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>


