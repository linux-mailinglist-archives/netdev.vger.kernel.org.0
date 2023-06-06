Return-Path: <netdev+bounces-8349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B986723C7B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BE811C20F2D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB3E290E0;
	Tue,  6 Jun 2023 09:04:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E286125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:04:47 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2040.outbound.protection.outlook.com [40.107.6.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA06E8;
	Tue,  6 Jun 2023 02:04:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+G/3k4yn+b1/ESjzCC0VBPQAR+GpVFDWH3wxOPDZ0s+nYJ3jP00xa57z4RCs1m4+VmDGKEgPHLexUtiqZzkA31W28OJVU54udxXy30qfp5ZzXB/RRuhUpvhsRKOvJOPeDw1qPEoirz0JxS/lWmV0gRc6wJOjKeIkLthwXPAlHvDRV4iEvKo5JNgRIhNiUmQMrn73HGqx4F04tCTojft1FwPe0bJkt5fGieyrWwEFXJEVIau3pSLEOKwK62S0qws0ZOQbneidy9JouGaktFhefF/QPxwPtbyuxBod2YGF/zOOpDHjWGokvyu7sCCuGP+nQQ5559/VdEHepPxX4OSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9Tz11qVlp7WadpXqtojwkoxPg7DrjcaRhSXWm44DQc=;
 b=VGH+5GkFwj4ZwWwV6UoVIVnnfpVf5NHhKo2R53VseW2daYGQ/2TZEHY64KKZ9BYepqPoyHJ0L4blsuwyD2MBW/9H2LI34oNWqg+ntqiWpSAqwXR73RzLOcIuGnfMNBRKZlUtIW9p+AnIYZBH6dfrsy/BK78smeg4B3IhDdFCvhIjXGLurXJb3oqSxdME7rxnCUhAMJUFuJolBxH+ZOEb0bCBch2zi4ieOzN/s5Cq7kHM6HxAm1o1IcZwQB2eFVosfujFPxRaqcxETuC4/4192zjL/Aeh9GcSq3Y1NwQyLBiKXenzEzyRZ60to9VXLMcTJBO+osN7Qb73JYWciKylBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9Tz11qVlp7WadpXqtojwkoxPg7DrjcaRhSXWm44DQc=;
 b=eiMETK2DFjOlPHm8wg+A3wBVmhg2y5zLRmerixGbGzmkF4sZbH0pp2ek0fElTeMxfsRIkCPrWdQLpmwYuKvKGC2CYMsOAHVZHMvvVZ/AWDiNsDrL8g3/3Oq/54XNCSNHrvxuk6Om+9yBP8KzdUn4sli9OleSfU885cwKRsMWhQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by AM0PR04MB6883.eurprd04.prod.outlook.com (2603:10a6:208:17f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:04:43 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:04:43 +0000
Date: Tue, 6 Jun 2023 12:04:39 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: ocelot: unlock on error in
 vsc9959_qos_port_tas_set()
Message-ID: <20230606090439.rcefdcfyrls6beoq@skbuf>
References: <ZH7tRX2weHlhV4hm@moroto>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH7tRX2weHlhV4hm@moroto>
X-ClientProxiedBy: FR3P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::21) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|AM0PR04MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f04ccb1-d874-45e9-3ffd-08db666d1156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Pi1h1JEhbHDaBoEvztfX1WSOa7q33YjlmMeu/seXo6yk+niP4rWLHgd3jO1o9cQaeANGbu/zGVNVN7IpYLdQDYYPN7E8pS31RnSq/odw0neNqcaG8N/eu8Oc7M9luLowtZAqwNl175n0gOzjk2wIV3cQ7Ys7PSwnbReb3+X2u0GlpNqUwJZ7Vv/wmvmIMH7RaRq68d0FyOzb20klEWLMZgq7qNXyhv4l4i5AqUXhz82bX2S2X8s3One8nKcAlj30xam7ctQiWyceYQKGxUAXxn3M7a5lOaGTMIWGrizQ324zDi4mgifR7sgFlwI9k04w8j8HeTT463nkLJ8tr2NBweK0BKOaU3/i6BSPTVLFocMAaouk2wgeFEcUUzvghKNrbxHnANUJRIQ2fMg83xbo2mWQ3G4siKtnrPxmWAtCa7zVPPtErwudFIVrHRUyjLVTe0VlXOc7ngU2/sBwwmLQFUj+PvbhDohxIxxjDV6q7cg36a4DjIDJrCKxVz8sR1WnTs0/53Szew7FE35DGY5fVMgnEGPpWUKoweawPsbFm0ItR9TaUWyzzzLekSnKOTJB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199021)(6486002)(6666004)(83380400001)(186003)(86362001)(38100700002)(33716001)(6512007)(1076003)(9686003)(6506007)(26005)(316002)(54906003)(8676002)(4326008)(66946007)(6916009)(66556008)(66476007)(8936002)(44832011)(5660300002)(41300700001)(2906002)(7416002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zRPq5H6KrX/u7gQbHW1gFLMfMqptdacVL131/CYjpIO4HniTZ/WjyHpteFDy?=
 =?us-ascii?Q?cGIHvO7BSGGds0q7bfMFivsD2ZOsRfECNRewRVbbhe+TESoDPh9yrXpEW+Z+?=
 =?us-ascii?Q?7pZkv0bWL6TEsdsyPQWYeRDtVt+/YZOoegwUXIIwVgpJiupgjrH5l8STlmRr?=
 =?us-ascii?Q?Uc3TPIrdMhXrY+DC99a276eYmjUK35Nwp2bw4dbwrYXIhlyvXRof3MCEqFC3?=
 =?us-ascii?Q?7JDOZZ1g8AffKua53IYHubX0D3KIMGNt5YirxXowJskzp9+ru6Ci5PN0XJN9?=
 =?us-ascii?Q?gIQ8OMrG2uPZFTn0JB2oS++PhuNzZHg5nvoc40fmhLxNdPA4svibTDt6Fxt2?=
 =?us-ascii?Q?sqrEYmuxz+TqhADXWPrFNywym3O27FkpAEr5vfUBKQNhEBtG70iKq3Z2PEBU?=
 =?us-ascii?Q?Gyk36IFhTBaGmx36OPeiUpAYlUcSdiLum/ofu09BEM8xDxlkYeWhbAXWVmET?=
 =?us-ascii?Q?HvHPAMaC26uu38LabzyqLVKi8IEvSsy5nuzpXdIzBu6kbyGSxEBms8LjzhHn?=
 =?us-ascii?Q?tHK76AujxBN3G53ulg+EYuG0QuRW1Os7rPiXd31Kv9xO5F7quXgmlBKLqlqi?=
 =?us-ascii?Q?elvEmQiMXnnVXK4+cWM3LKvdNXPiodykWMrQMfkdJWCMdttJ/KlXAwjkjfPP?=
 =?us-ascii?Q?x4g3N8f/IN10J6T76GhrBY/iwIz2twFyuOC+EnSC0mt5/mXKhAfocjJnF1VX?=
 =?us-ascii?Q?k4RlQ2hytR2MRRw0p9lLIxICHVGeaJqL/V08HSyiKEGA7Or1QFWImgJOgOfJ?=
 =?us-ascii?Q?4o9GdNjWhT0a3rvo7AdL7xC4REHUZ+z5G8Nnf+SNeqBu0UNgD2SFkzqQGqf0?=
 =?us-ascii?Q?sS1Gza/ZpGqrpGhGgfzVTre5S+wdI1SRuD33VW5XiKZhJknrH0NViz+QNIt6?=
 =?us-ascii?Q?Tf/MTM+92tW9AlVwYPcmTR0entKqS+G2p6HHA6kyhsV6FQRrptRWDvo0HFjZ?=
 =?us-ascii?Q?TbEVDSiwAPxzWbw6m0CLGV1ToD4+jXF2KyzeJiWhlZQPXukdf1OTKXdvdyyN?=
 =?us-ascii?Q?CkV2ZLb7d1ESDoteexbCwL3tqDpvRjXXjzz7AUwu8H5rBUXMALWUDbgzBhaf?=
 =?us-ascii?Q?6aIwcmGBnmfmSZXjyxn8MnwD/9w6M97rPoUXydHfsMYEVCIs9oy6SFD+xVJ4?=
 =?us-ascii?Q?+N7QDiQSMqAS9lJbSScV9nzkDFvD3FFTKqo6t47fW2TLRX38HQMj1F828UE5?=
 =?us-ascii?Q?sENp2Q3rAhOBxbcZBbFmD8wWace9bIjmiEyZ/J7SbswzePhcHYHVd0+QSiNC?=
 =?us-ascii?Q?eAdVCMYRCCpGEMXGZ1Ro1Dwov+K01o7YxS05hvUUqcWyI2OUvn2h2ct4IZK3?=
 =?us-ascii?Q?vSEBiU44KFa6V4+rg4yoCAP2h4z2v1YJ0FdL3Q+EcsgWPdhuaGqhnKYtWtU5?=
 =?us-ascii?Q?dtRy4zuacHwSE7YC1tzVFJaTGuEIHi/TXBhlpN31xtR+jtlv9C4h2iS+ojoV?=
 =?us-ascii?Q?v1SAAKdglu2vXs2iROJU3rb5aLq1Oy8+7jTx5Bap/tOYKa3VduPN7jIVURcy?=
 =?us-ascii?Q?bxfXkJ0xBDEa+7ZSuBzvza0t0IP/rVBw98nKU5PkXW4eBY9DbDbJUGFxBI6l?=
 =?us-ascii?Q?ZTbRC5QWVNahP5VQJL4lkC0qvOY67CKVKKj3a0fGR3XwhqWAFsuh1B5p7zA2?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f04ccb1-d874-45e9-3ffd-08db666d1156
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:04:43.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bT5bLPp/8dV5yR5H2w3kbOzMZKraqBlIUhRrlurJfAnyZ8RQZe/6fqfi0bEXsd5WlW/fYGJz/Sl3eW3lfi/oRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 11:24:37AM +0300, Dan Carpenter wrote:
> This error path needs call mutex_unlock(&ocelot->tas_lock) before
> returning.
> 
> Fixes: 2d800bc500fb ("net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a "cmd" enum")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---

Thanks. I had a slightly different patch which only locked the mutex in
the first place if the taprio->cmd was known at all (there's nothing to
serialize otherwise), but I didn't send it in time to resolve the issue,
so yours will have to do as well.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/ocelot/felix_vsc9959.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 5de6a27052fc..903532ea9fa4 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1424,7 +1424,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>  		mutex_unlock(&ocelot->tas_lock);
>  		return 0;
>  	} else if (taprio->cmd != TAPRIO_CMD_REPLACE) {
> -		return -EOPNOTSUPP;
> +		ret = -EOPNOTSUPP;
> +		goto err_unlock;
>  	}
>  
>  	ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);
> -- 
> 2.39.2
>

