Return-Path: <netdev+bounces-1771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 613E06FF194
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDFD02817AA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7211F935;
	Thu, 11 May 2023 12:32:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDDE1D9D7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:32:55 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C19176B3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:32:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RV3aGnMMy/7mlu9mb3OZGXiV3hRIsJjuPH6b2wIHCTZz8W9RAGc5MJ0phodWdssH0Cey1ibHv6vuhPDhZMXA9rsJ83ra5NGdJC5Couok1bHHXxFLz163SNDM9vQyzZRCmja/de6+CA6UVWOb3duKvNuLe5z9R0gNSgiO8vjaY/2nhGTEVFQMU2kQlZETb9ZDpqf5L5WGF80ROHOj/aMJgrqgWifH/FiHiVRehkM8aDp560DB2N5zc+Lxilpn+zt/NtnYHcynMFvXwSDoJv9+cgkS9LHDmLTzd3heWPM1rAywDDjKAb1jVAuwvzClK9pfDyLtP4s9AZoXij+LhTtRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+1dqCUwpxR0drgbc1A87jjfaYwnTxeyyRtXtFgNxHU=;
 b=TMEHv2UJelH52SUO+dbWhaa3aYG/9Aq1BpWsXgCcAQrQlau/Yo+veWBkVmH2/cVzwfpRLoZukm5K43/JBjVMvhaG/jy96alkIng0lJ3/9qFMKuM9AoCj31QqWwKnn0GnZt8Shf7TwBB14MLwAXN0aBRDWGxyoftbXCbbeQUuahrT+Wqqj4uzf7aJ6a4TURE+ewW2jMMj/Y+meAPy7EZKltwPVZh7VOSkCXIx7OsEwVeS4YSgy/32ouAw8a6DHdF0BFtuj5QeGPL/YzCURp2PBbt9f+mkG6fV95iWf1Ifrr32CnAEFRh4s2pFy+Nyf76+MUIhn/fiNEzqf1uYEV2NLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+1dqCUwpxR0drgbc1A87jjfaYwnTxeyyRtXtFgNxHU=;
 b=XvOrnPE6L36u+JBu5gfnu1JInW/04Ytf7PRgp0uGgJ5Xi5vBZdocdDT/dW85y/ueFlDOndavReODCU2pki8gdGWtjmcvCZETfzH0duPJSeRCBBn2WCwjUBO3+VJFqKJXqsapkK/+iLIlsLPolttxSmCMf/Zu2QueLYqmTXKNBsY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB9189.eurprd04.prod.outlook.com (2603:10a6:20b:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:32:49 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 12:32:49 +0000
Date: Thu, 11 May 2023 15:32:45 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Maxim Georgiev <glipus@gmail.com>
Cc: kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	liuhangbin@gmail.com
Subject: Re: [RFC PATCH net-next v6 1/5] net: Add NDOs for hardware timestamp
 get/set
Message-ID: <20230511123245.rs5gskwukood3ger@skbuf>
References: <20230502043150.17097-1-glipus@gmail.com>
 <20230502043150.17097-2-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502043150.17097-2-glipus@gmail.com>
X-ClientProxiedBy: FR2P281CA0131.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB9189:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db5af7b-2645-47a0-71fe-08db521bd4ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ATLAdrIaeU+DcrCuY8mEduOkLKAMR7otrIvbkmiU3jg/Yze3ijgUaOB+v7FSKcxjHk1k6RbGugtdc7KstLKC6KQVFJPn6xZ+OIlVgyDFqPV6gTo4Pbe/dJNkjLQR9BYJujcP5Bo5YEjooEmx/wOlM0tei5zduJ5p4FrmcKcctF0SYzHvjLhl+M5CZDklnfiWyBk6sf9Zf2Xetmcnds/WovORdPYtBUNbSpM/LXBmsZ4d08YUsQIvPZ/RSzEVTYfv+Y67IpkjRQWqeJHxh80SH2B/uzqjOrRjOycWbyXyhCNHMkUKGgNI/KJRw+Dj3jxTfp/5SrSE51h6IIifd2bujgypbZll5KmzJxx3Er3u8MkzRt8Y1VSQLExPsiJEfYtqgeOFJ/wWjDvH3zZfVTvnvMBqB/ftIL5Gi9S0ottKC3ZPB08vWIGipBTv70MZeF4G+VHkJtZkthIGIJgDuFUqqJIqxos8ubo+kH4nM2qeCfmWT6DEobjDzxcU20F/7zHXgrAKrSuv8Eu7ROW/0q17/Wz8O/ra5NOAPd8CvVHdfgZ3FxZcfsBxzMf03QjAzqrP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(451199021)(41300700001)(2906002)(6506007)(4744005)(186003)(26005)(1076003)(6512007)(5660300002)(9686003)(38100700002)(44832011)(8936002)(478600001)(8676002)(33716001)(6486002)(6666004)(86362001)(4326008)(66556008)(66946007)(66476007)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xDsYy+pjX0VkImN8V0Imrm0o9MRcCtYcqkLrwBVsUkuOHWrbJnNXC5MgA+MU?=
 =?us-ascii?Q?CcH57VDqgWCsyjyC6mIBpJD2BazZUkcKLEsMGU5t0TCZptVVqi3vmQT8vDOp?=
 =?us-ascii?Q?+/1IodauJnygzRWwT2jJMyFXhJyJj/RnrWoEqNAWZjgj6sKcqGApBoFPM1RR?=
 =?us-ascii?Q?7qXkB8w3kqakZdahxW5iiv9TFvBfnLipbTuQO/3hs+6xCu6t3MFzvMLWWA/W?=
 =?us-ascii?Q?tJkXLn2kB92DWylh3X6xVefE1mYwn46EwpEOuloyDnetv5bDdMgZuEpmrd7S?=
 =?us-ascii?Q?0E8DISwjA9dQr5X4HkY7L5CDcGW4g3snvjTYjehmH/Lj+63YQfQMieHD0Ih8?=
 =?us-ascii?Q?plBHuntGNqcXpQsgTM5rIlCXAyneE0Hr0g7jY4Nc7FLOMeIM6ZjiL5L8nXOn?=
 =?us-ascii?Q?NbeW/wS+M6wwA06lnOWVASNBVAYtHWTHPRTsFcHl7g4fwwVek531oKpe7WJG?=
 =?us-ascii?Q?wwa3J7T0N8UyQ9v36i416NUrlsTCf/GLxH9e5HVv5/URNli49nRM9BF4uQM+?=
 =?us-ascii?Q?zzwdsrL3GYKlK22KA/BmYNXwOg+PMAWr+LQDaSwil72mFUsedTGYQc16xDRm?=
 =?us-ascii?Q?0Zv/uyHLbcKtjU70Jd0lsX8SADdGWkBqK6qe4toCwuHJQwzu2Tr3WsgTB+Mg?=
 =?us-ascii?Q?gAQjGdzp8Zk5N1TqLaW0o8/uO4ZQlCDrGjpmx/DVdiRg5Rbt0GJQx7AOQUFT?=
 =?us-ascii?Q?AX85Osy+/VZvm8VQSeNLJxGniIBgX4h56P2gRB2kW3zqcDxY3WEMUe0KMjgw?=
 =?us-ascii?Q?MXj8Z1hDk0ysapbuEbEU3Fu5Oi91kPLayRLujrQAn4ITYPfBycywM0JK/ofn?=
 =?us-ascii?Q?TDTCvsK7OSTuH5VasFvI6l1h34fBlXPT2aLr7yci/+hJdsIlGA2P9NiGYwXw?=
 =?us-ascii?Q?D9CTImEYf84yu+lJc7GLz5JaItygvyfbjJ09k0Ygax2Aq6zxAwHjlMBbRpXV?=
 =?us-ascii?Q?h4CkpRfC/e8RiWWoOnSiFtYpD4/uPhn84dVlqXxbjKxY+H+bErMRcODh7q2/?=
 =?us-ascii?Q?PNpSCkQuSOjHk4eTh8VqcBU7tdRMQCe+x5o+ayvrvyP8LqbKaKtp1UldGJ0m?=
 =?us-ascii?Q?JoI6wUAQIy+Zs78FRcKJpb7nsU1p06FdzyfMYfjZAFapRyF9SXlIOyrCvKGE?=
 =?us-ascii?Q?KJ49unlg3Xd5ZSP9WZ3sh6euZand4T6hd0+6M8uT/O+8ScAodmdZecnEAmp0?=
 =?us-ascii?Q?Yh5jFH6nf8QaV7OzSrDzZ5BDjYaPz80nCOP7vGZsjXKZr5UUBwqfLEfgjX+y?=
 =?us-ascii?Q?4HnHBdWTsDg9CTSeXg+m2Et7fKaAwDr/ZNlmksyBmekvzXjYrTX3WgerFOIg?=
 =?us-ascii?Q?k5bPPz1s2srQ9FyIZhAYlBTduK6SdlOHGwmttZeK3HJBdRuhV2F5gdN+Q3ua?=
 =?us-ascii?Q?JHU0N/RbCIPa16bARDzNKDPHod0TO0DhjhKkiMFM+QKu7hJU0f58ud4pqFCU?=
 =?us-ascii?Q?Dew8TBxDHu1bI1wKEY1t2bsSjwmOqroEaQEaF9CGM78k0LKFloFeQSTCke1T?=
 =?us-ascii?Q?xJuq8HgVraI2Vfj8d7jUERiTgzOkV9UpnWLWhF0uh27mk9jsuq6Tk/nZ9fzP?=
 =?us-ascii?Q?Un3RZRJ1SYXakQzgz3PnX4lggTypYgjZ6hOX9hcUIP2J3pfb5uHv45pPFWdh?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db5af7b-2645-47a0-71fe-08db521bd4ec
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:32:49.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmOPnE9Pkd0UsFwa+PtWDVZvyO+7Mw4gKKHB4vpmYdBvNNPPhbQZqKEghY2LqJw1lqG3Aad7zfAqtJDl2DjK5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 01, 2023 at 10:31:46PM -0600, Maxim Georgiev wrote:
>  struct net_device_ops {
>  	int			(*ndo_init)(struct net_device *dev);
> @@ -1649,6 +1659,12 @@ struct net_device_ops {
>  	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
>  						  const struct skb_shared_hwtstamps *hwtstamps,
>  						  bool cycles);
> +	int			(*ndo_hwtstamp_get)(struct net_device *dev,
> +						    struct kernel_hwtstamp_config *kernel_config,
> +						    struct netlink_ext_ack *extack);

I'm not sure it is necessary to pass an extack to "get". That should
only give a more detailed reason if the driver refuses something.

For that matter, now that ndo_hwtstamp_get() should no longer be
concerned with the copy_to_user(), I'm not even sure that it should
return int at all, and not void. The transition is going to be slightly
problematic though, with the generic_hwtstamp_get_lower() necessarily
still calling dev_eth_ioctl() -> copy_to_user(), so we probably can't
make it void just now.

