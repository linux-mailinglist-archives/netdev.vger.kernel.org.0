Return-Path: <netdev+bounces-10724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4692572FFC8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 057352813E1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F23FAD32;
	Wed, 14 Jun 2023 13:16:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2426FBB
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:16:09 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2105.outbound.protection.outlook.com [40.107.237.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10252108;
	Wed, 14 Jun 2023 06:15:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JG4hm06dihVYI8pPOlxNJzlKMolxrDX50woES2QS5yf3cKhm46yymixXXfu78TgFiL4O3FvGY8O4yoN6k6IF79Xs3TrrlYT2eisNvJeG4XHLAn6ECIs+XN0UAc9Quah1LK5ltbDeEPOPaAnGZAUiXX8eZyonTLDbMZGNdCZ+H+Usb4j8Hdy156tTLQ47/a4dcxhEyJO0voUnbgLMWhh3Pgv7BPJD9cIjJbhkZODi+vLcGEIcSAIqh/EzDPjk3PiL6XHw1DudD9WXkshpgTIiDwFzou5Pa5X/Ue/7uqRQo5jpCrz3IYgYfJAm0++S0rwrUOSDmC7kLGorxoR/OY+LLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvBU8h0ZPajUbg7q8YDQqmvNRCQLNdo9gjORyxnx0hk=;
 b=QC7yWgaRvzATpwa3QvYwAgctszwVdBzVUqaSpAOfoHu3NFMjMX96Ibk8A+kO3JvQWNc8CE5uvx7k36WDcCHHxX+ILyW/E3Gstfvh0okDllR2lzxSN97Tq03r4R/QQlI7ktUhv4486a5/g5iBP4gEnqyRF+EJ+wcoJxCDcJwKyw7o/42/h8ob5vicxUndwujFd6rxfxYp9bqsqzgJZL9oniKqDLB6zdOuHuQodYoK8Zrlp2envrOmJF+NYR8Z0+qjWSwYZv3XSi2cAcp/mOQsbijjVWlNqYSEHI8VbJ2wCJHsHWGtavnQP5pW/PjBulsELCCfnPbHWnMn3d1/MQr22w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvBU8h0ZPajUbg7q8YDQqmvNRCQLNdo9gjORyxnx0hk=;
 b=bvVVY6UfE2kbVSgGO+++BW1yVnapZqqNnzQVpU9oCyBBdnAJsY0tZU14Ijcep2o4yL0e22ILfBb8RrEitA9rTQskR4eW3jLeOjfE/B8I8xktpYDNEwJFTwfLX2Cf1zNL0cN9pzj6eXh1zvfyJg3QD2pfMZt+MJJh3rgPt+DhfSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4565.namprd13.prod.outlook.com (2603:10b6:408:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 13:15:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 13:15:50 +0000
Date: Wed, 14 Jun 2023 15:15:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: felix: fix taprio guard band overflow at
 10Mbps with jumbo frames
Message-ID: <ZIm9fw1l/EM0r3Um@corigine.com>
References: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
 <ZIms+0/KDpU9dd3y@corigine.com>
 <20230614121759.riazt6xiskk74h6r@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614121759.riazt6xiskk74h6r@skbuf>
X-ClientProxiedBy: AM0PR02CA0079.eurprd02.prod.outlook.com
 (2603:10a6:208:154::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4565:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb296a1-aeaa-446a-a7aa-08db6cd9796d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lT33pZEBqGFHRGZ3zNujM9DdRnwULJApwHz54ZOfQpjhxROb6bRfO2lXKU23SBzsXv1YjTzuuA4Cal92wMYMgjwVa5CjS2fvFXF6RPwY6DSPefMwAn5FtCuk5LGe56mPrCT904wFenV/A51l8KvzxgvXbBuZZGTl+E5b2DqCJpU6bkx9lRNIh4owGDzCO13VqLRuySgPwNRnnLhYXQyAlI392B77jMcoa5RpkVQ9l7dJD/hz5NtlQTdeU2j09MmqcDmuV7wZy8vfBCckB9NnlbgARrO7DOd0O7lt+ujUrJBQL07GEpEe64qXW/tE9khIicN9AqhPlDVMcePF24EnIuIaYCn2kT4uPZsy4yEFzpIg1pS5nk5BfRnE9hujQLNX8ync6Jl2XldmoiSbOnf5wxDUHdwu1x757sEv3+A9AUKK2KYQdh3W3XuTN4s7sEeUxF9CfXN1SviB3ImYOTdbglfWc0zbfs5mHuxtc9l3OgcYXDwDeP4MjBKxIUlUrt0ZeQHCfIO1uRtK56KoJik7vHcBfaXS8fcRHMyMdBaf/fobjUladTwS66kPuNWsQsUwNfLTRNPOdgjs45E3YNqPrTWUPphEqXzYpZeti28wwQw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39840400004)(396003)(136003)(451199021)(38100700002)(86362001)(83380400001)(8676002)(5660300002)(7416002)(316002)(8936002)(44832011)(41300700001)(66556008)(66476007)(6916009)(4326008)(66946007)(54906003)(2616005)(66899021)(186003)(36756003)(478600001)(6512007)(6506007)(4744005)(2906002)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GzNaPk96jgzZMeqP2Bm5AUKPzrzMQZTr2pC8/jxP/oUeBn1LVFOFSjv9rDU6?=
 =?us-ascii?Q?xr3K1qB6KvnLbmQeypRBfHbuFlslBgrLIAyDo0wYzQz4NxrVe9dcm3GUU+W0?=
 =?us-ascii?Q?l7Q1EATVkgmz2pxbf1RuK1IgQG67YSDvWLL0qznPTaiWknJc2arXdizcAEX0?=
 =?us-ascii?Q?b2YvkdJd3/CsU3KrZz3o/qKw9flzuBIX7jnGdySnymswM2OaURsve1sHYR0F?=
 =?us-ascii?Q?Jr+Gx4iV05d5NaOStl+TbpKe9RXjvhhdiHl6TqeQ+b3NhBDRRRgv11y2O733?=
 =?us-ascii?Q?4vPd+RW/oCYzDDFkqNOLJ3eUm8wt7Tkic1R8YqLOOGGXbeiKX1B+JHxFOw1y?=
 =?us-ascii?Q?WKM5tphq5zO9NL0bTtjiG/q6cHWDa89oMDCdFwEVnpY8/QzoWGujT6rr71xd?=
 =?us-ascii?Q?Aa59DPRKOSW2/yOZlOltPqxKikv/KQbMEXv9W6Mvwu0+Z8fXcXHvNGyE2u9/?=
 =?us-ascii?Q?VbPwkwRZ15Ogne9S1cv/GiG9k/TZ9EJobyOMrcBsE3ShgluOjLwxeuig1JNm?=
 =?us-ascii?Q?cpOJ5xxSUiDhwBoBVqqni/bAmz8p5P2WXsn5BGutDGtEz9WuPDIx++HWCVkI?=
 =?us-ascii?Q?RgOe13Wk6NI9SlMph/WJ7Ea+Kf4wJw5Yf+OgkPpMMzIjcEYL0ghYT3Odx/jh?=
 =?us-ascii?Q?1WrImgJU3mvqj2R8DRNICHX+iiU/4R9zD7Ulm4pjDGK7mFIhV78EXxK0FUrU?=
 =?us-ascii?Q?70Nky0xWbdXkdo7g8N/5gq1Jk7NFIAVyOeu5YEv6VzF14LR/8yworKw/WWAs?=
 =?us-ascii?Q?G5mI9uMRhSIGN/QchD+8tLvupIXGa3/oVihaTaxr7mnKqtcZxXmQp8q60THP?=
 =?us-ascii?Q?OI95EwSpj5NZyBuSJxo24679BfXCyw1Da88it+/f4yrFsWKrjkfXlzd7Si+I?=
 =?us-ascii?Q?g08dLHxDezOveIVolBOCogUwCw+7/0/3VBxlBewhOPWJoURXpdc/UU9+0pBb?=
 =?us-ascii?Q?THoHWyy0AYYd3CCKhKSSxSDGPoqX9H56jFXhA8fB5UVTASB3q9lUNTMQzb/k?=
 =?us-ascii?Q?P/zRnkU/Ehfb0IHKX99eG+4hKcvG3whlfK1Onw8Q/2DHx/qnRyFrea+vSRk7?=
 =?us-ascii?Q?Qwcx7hm/vvk4EgwpNUFhFHyjZJJeaVnyR0iLTLFQajT9mP6nnP31Jh86tVIO?=
 =?us-ascii?Q?bkgJHTpIWZBHBb5zzFnFsGgbJHvMpy+lrMR7DKPZU6ONYwcJnpXtqhfwbM98?=
 =?us-ascii?Q?ykW1KpKj5ntgKaHHEsqU9I6WmFwSqUhXx6vYo0FKL8TgqqeLMBcqA1unHYJ1?=
 =?us-ascii?Q?A0v4GVatPn9mLPWqxGaqup6Ec2d44XC0di8jXc4XIISqsIiLceT32OH6ojT0?=
 =?us-ascii?Q?wq1yY3vTm0eM0RUv7Xo3/I1zlWVR25UpdvWNukCWQMVtOOVrm496CJCg5GoU?=
 =?us-ascii?Q?wmzHNqReUuAC4Y1Lgf6Z5vcXSJrUwmkkBRFK1k1w/Om0OmrM79LWz6/Pzw4u?=
 =?us-ascii?Q?Ft8pYY/2NNGDw3UgClLKtB8/FmOTJpkIfwGB5kOx5CWcvm/+dotVRwTpduNe?=
 =?us-ascii?Q?AHUkXwt3eiu2qmtxnafMwAyb1s/f3Csepc+Pf1UTrmtmghL4DmMDHvi7n8v+?=
 =?us-ascii?Q?tLsbYoNBX1ynsBeymQ7atbZ1hw8Fbv4Ahf5+liKTUKfLFNwABDeTYCOVyXAi?=
 =?us-ascii?Q?E1224MYKUc8ak1h9CBN0o9fBMBhKThZ4Yi6DmzdV5GJuFyR/Jo3es+CvBQ+f?=
 =?us-ascii?Q?kcM85Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb296a1-aeaa-446a-a7aa-08db6cd9796d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:15:50.5075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bU/NEMeGBBTIcfFuQZ25nUTsZN3GYjYVszHY/bmN6Tm7mW1NvsE+ouH5SUkrgrnnV/s8oTWseUp/rBU/qk96IaIvUvqGxQ1T1kFSBTubhPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4565
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 03:17:59PM +0300, Vladimir Oltean wrote:
> On Wed, Jun 14, 2023 at 02:05:15PM +0200, Simon Horman wrote:
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> Thanks.
> 
> > In a similar vein, you may want to consider the following suggestion from
> > Coccinelle.
> > 
> >   .../felix_vsc9959.c:1382:2-8: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead.
> >
> 
> Yeah, but there, there's an earlier restriction for cycle_time to never
> exceed NSEC_PER_SEC (1000000000L) which fits on 32 bits.

Thanks, understood.

> Nonetheless, it is a good reminder that there are too many disjoint
> places in the kernel already that open-code the logic to advance a
> taprio base time. It would indeed be good to consolidate all of those
> into a static inline function offered by include/net/pkt_sched.h, which
> is also warning-free.

Yes, that would be nice, now that you mention it.

