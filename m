Return-Path: <netdev+bounces-1973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DF2A6FFCEE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF0571C210D9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77349174E7;
	Thu, 11 May 2023 23:07:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545333FDF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:07:26 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB79E2D4A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 16:07:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9vDx9MXqVm62W1L7G+FPYCJtoa5tmelSwHhrQdDlOYmR55+pwUv5oi/j6ov9EtR+2D5OUy4L5rpKmDFGawsg9EBXRHI8Igq2m7hxcVLqrRIma/CbV+rncc7XC1/+3wb+NcGwPkDkrb+CevSVCOLZau9P4DXvs2aoTIK/6+B887OaC++ZbH68UsGHtHlW5dqN/VBjPrIGWuGo74+orP5s844IlmJvcTPhblFg1bBSLjmkj0l3hU+KL6eFC7xQe5bonkliJB/wp0Be/RCX5OSJwvlJUY0bjQeVeGim1VcaM1iP+h45aRU2nI8t5ffLtO3fgzuILFl1GRCIaiNxBFlhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IlA1f7V1VdhZA/al7LZceH2+MC4CvyT8H7MvbcV8zg=;
 b=lIDp4dYpvfaqBGDHam7TBjU4JBwcl5HCIqYIF8ZyXtXoPjYXJBdsBgxE7TBr3d7SdVK4vqMxKbw6+/WBX/7jaGHUG6djcIdL1Fcw23cxxhhJNBIdNiw7iyB13pjvPbqc3R1XTdmn3n5SSvLdAQnyyBG2ajKjJiSx+vC1mItrRkp/S6MpYOwoQ9F66SSQ6xonI2ZcE7fTjPDWRiD7b64m5KSymr9s4rOfinxHf+eg1Ng6brVPDdVbrGL7M2dBNCAtbCSte6xYmH3kn6PfZ8AuKM1AfCT8FEcBw7ZbTzQszdNtE+68OHDyU+2xYU/EK2CRP15cxSgatOabg3k160ujKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IlA1f7V1VdhZA/al7LZceH2+MC4CvyT8H7MvbcV8zg=;
 b=ECcqu7PUhOvfTXY7pZs/2JQRfBWmfEfKN7Ou002pIL8uyOaB9hjnPKCXxIyUdY18W5q6MsX5a67RkgXPyu56WStynwrQ9/kcELCxBQwp6ESphCySGQSAtuwnREAVIl/mEX5Fnkh3Vaxnxk4a1ncK7Sir2D2LTUyt18RfeyaoiCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7363.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 23:07:21 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 23:07:20 +0000
Date: Fri, 12 May 2023 02:07:17 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	=?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
 <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
 <20230511210237.nmjmcex47xadx6eo@skbuf>
 <20230511150902.57d9a437@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511150902.57d9a437@kernel.org>
X-ClientProxiedBy: BE1P281CA0257.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 36accc8e-fb57-4703-5bc9-08db52747912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0hYUU+8jEFRo1Ptr9C2qazW4kjJrbBitOspZFpjEaG1fE9M/bl8ftPsRyVinNaV4+Qo4qjvdEcyS4bUe3dzmKQvEToLptA1s0GxwsxEAMIxN3mzL3AYoYRUm21bA7RMo3A3jquaaxwhplQNYTGRiFOj8jWCu/A4OqEOkAlHZcAUZyTLnBoSfyMDGZxAxzM6IjTaBzFg5lUVZ4lES7BhUoHxACMml7Dzld1mYfhW4V3oJHLvlLixrWmAS40HCwyhxB3Hb5aQM1ixpVZkupb0ALwuUU5HSFEs0CSIOAyZdJnlcN+Fw6ROai+JAaDZJDWPZV2I1BT3vkGEkCjweGveWZxJ1bG4GRecC/PqV5oT7T2gv4iZ0UALeI/Fag4686tqoHeHkhpCOaUS/J5d3RHeiaXVo93ANnZQCBr/amN06SfqE5mbMUTaK3I/sTJagsc8QREDcwyEIGjPsPhrqcQ66dUa6kRSEQKESeSJe3y/legyNhX94etjUIKWVYX/0hn2FKihQ+kNosi2m2BjanK9cuVCDmxu0+vlcMXSSLgXuZhU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199021)(38100700002)(966005)(6666004)(6486002)(9686003)(1076003)(33716001)(6506007)(83380400001)(186003)(6512007)(26005)(2906002)(66946007)(4326008)(66476007)(6916009)(54906003)(5660300002)(66556008)(8676002)(86362001)(8936002)(316002)(44832011)(41300700001)(7416002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wW8gHVCeBU1DYyUnXn1sx2am3JY4wxc1TVD+TOeQkcwKKuxOWIlTAhBR0+NR?=
 =?us-ascii?Q?fNy3XmrLLWe2DsznELpfSKnwmKJGyOkfbCr7rv7zmxBoVjd5R8e/K9IwUWbP?=
 =?us-ascii?Q?xeqdWHA8EgsEF9pMGJbfC+QhTAyLvYEUfZh8gyDZkDviu8xXpmKLNBr7Y/cl?=
 =?us-ascii?Q?dP+wQzoZPOSV2jNp/U8keEfufjpyK2oVk5j66WOyc7xFQGIsgjkNu44fvxVm?=
 =?us-ascii?Q?stIf4qdN/Ak81P5pltmEa7rZo9cOfCz4prFjVdNZ/cPbfMNoIOjKgvpq1HvA?=
 =?us-ascii?Q?mBKHYgEczoODIg+pguUse+6xIqWaP6ua38/7Yg9K8qSiK47by8A0ho7umanp?=
 =?us-ascii?Q?eztuXnTwGsIjNISNwUqnmSEWAWgI3OMfOxmwnu5RC7bpDtv7S6sM6RrM3Q0q?=
 =?us-ascii?Q?pOiTuj9Btt3FWAYXA1odkXoGwOWDvuRiljLsb0ETvIFEw8HH2p/rme2Ycrfo?=
 =?us-ascii?Q?YG4mVsjQPmf1P8G4maUpRxnSsWqNxAUX4N7rfFEH8cxbnuYqSbO3z7VGBrZS?=
 =?us-ascii?Q?2DrR5RY9VtVvD4hd+D75qyHK5iUIprWR9e3bqUNintKA1orXuwjuOfkn0OyC?=
 =?us-ascii?Q?NPta6j7TusEweM3plValRYKJv3xYUBWWpX+brnFas9pc0lrs7Phgb9TDvd3U?=
 =?us-ascii?Q?nyhKWGE1B0rLQCJs0QF4n2UqRrcROaF4SbccNz17NOYUA6o3QEWXM8YEpblD?=
 =?us-ascii?Q?PB2K01MkbJTl/qn+vdHMhnLGuF3P9z1FY+C8N6l00vL+ffKFIShVeejxxy6y?=
 =?us-ascii?Q?gNa+AHopjDWxuD6dRmZkNBQh1GUvmOVgZWg6f1RvQZfX2BUyn5HQ6Y+C/kUc?=
 =?us-ascii?Q?OGw1hAZml1syKL4PYw16vyqKw6QvJ1u3nu1HyVLybhP4qrdMz25fXTWOdIoH?=
 =?us-ascii?Q?zFadWqOWX4GPT3t3xgehQFK/vTiZzQBCy+FGhRIGfgXpO6Pz1VuleX0wRq7w?=
 =?us-ascii?Q?0R8X0MEo/4WJEvJXs0Hod6MlgpkFLs979Hd6nsixXX1N4kNamtXlyn56eIop?=
 =?us-ascii?Q?tLt9rgbCwzX6e4PbbqCUv3xtHwBxkmLGPW8voBcCPZj2Dgtv/bsHqOk4OXkH?=
 =?us-ascii?Q?3j02oM+J8umhcIvEL/ES12qoiMezdCQMV2NITIryzTB0TA3Lphn952OQB3lu?=
 =?us-ascii?Q?qZVGSaWbloNM2dZIyJHiO50axBM7yBxGsitircp3RNu+1XAo2jnWFdi5Mojw?=
 =?us-ascii?Q?qW1UNYUj7Lnl72fiDLMb1AKB6wJK1nHApmBd2kcaigbFuz53GQoDHioUv1Zz?=
 =?us-ascii?Q?ipZ51gZ34MfHNwNFvgC45nwXhtaunTLZXtJmKfLFT76JDNhLW7aO7wFabLxc?=
 =?us-ascii?Q?VWVgotZ0QUIQbW2o1bdV7rnQiXsm0xnXAigqI2VbNBHjnknoGF+ugv8T2u9i?=
 =?us-ascii?Q?oZaUucMMQv737lFRHu6yl5jBQ8aYAVgfJlr9d2/knJVwfea0pRFDUzWA9iZN?=
 =?us-ascii?Q?BDjwuHyxyip/u0C7p7v1m6cWocTxn8OP5iquPlnJbVLb27ADyehHntT8Incl?=
 =?us-ascii?Q?Nhcyb8LctRNvVdwavkwSL9aQn+iM12UVWf4fhlzOf7rT8exx1HBvIimkmhDO?=
 =?us-ascii?Q?fZt7maiwud8DNLS8QCADLjVs0EWeSbRxKhNoxl7no9adSA+PcqSGNJrXnELI?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36accc8e-fb57-4703-5bc9-08db52747912
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 23:07:20.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1v8ji+Bz7E452H319owl5lXKrDsc60GC1UjRXm0DfmRAcmbqaO8vWXBxnxwcbfqIy4qfGCOTK47VWVyuB5E48g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7363
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:09:02PM -0700, Jakub Kicinski wrote:
> Exactly, think Tx. For Rx hauling the TS in metadata from PHY/MAC to
> descriptor is easy. For Tx device will buffer the packet so the DMA
> completion happens before the packet actually left onto the wire.
> 
> Which is not to say that some devices may not generate the Rx timestamp
> when the packet is DMA'ed out of laziness, too.
> 
> > timestamps is an alternate solution to the same problem as DMA
> > timestamps, or whatever:
> > https://lore.kernel.org/netdev/20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com/
> 
> What I was thinking was:
> 
>  - PHY - per spec, at the RS layer
>  - MAC - "close to the wire" in the MAC, specifically the pipeline
>    delay (PHY stamp vs MAC stamp) should be constant for all packets;
>    there must be no variable-time buffering and (for Tx) the time
>    stamping must be past the stage of the pipeline affected by pause
>    frames
>  - DMA - worst quality, variable delay timestamp, usually taken when
>    packets DMA descriptors (Rx or completion) are being written
> 
> With these definitions MAC and PHY timestamps are pretty similar
> from the perspective of accuracy.

So if I add a call to ptp_clock_info :: gettimex64() where the
skb_tx_timestamp() call is located in a driver, could that pass as
a DMA timestamp?

The question is how much do we want to encourage these DMA timestamps:
enough to make them a first-class citizen in the UAPI? Are users even
happy with their existence?

I mean, I can't ignore the fact that there are NICs that can provide
2-step TX timestamps at line rate for all packets (not just PTP) for
line rates exceeding 10G, in band with the descriptor in its TX
completion queue. I don't want to give any names, just to point out
that there isn't any inherent limitation in the technology. AFAIU from
igc_ptp_tx_hwtstamp(), it's just that the igc DMA controller did not
bother to transport the timestamps from the MAC back into the
descriptor, leaving it up to software to do it out of band, which of
course may cause correlation bugs and limits throughput. Surely they
can do better.

