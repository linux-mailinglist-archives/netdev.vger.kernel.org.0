Return-Path: <netdev+bounces-1783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA2E6FF22F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7D0C1C20F71
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D4D1F952;
	Thu, 11 May 2023 13:10:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEAA1F92D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:10:18 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7483C1B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:10:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlsAG9hxj0D1uOv0O3CD/jTt1F/W+b4xNpYLHMJ0Cy5fpE+5x6aJbWSdoe8q2YdHZX9N+vTbtJMMPlGy6uphT5x7sR5ofhT5jSb8/x7PL5qiyMMp2Wxw0pc984zidF8sqEKa3YP9xKKbkvStwxXfi8FG6skP8ccKypYNyAcx1PH/A4HPmvzcoQdwO26xvns/dWQVgw/6JgVY+FsM+ffyRszSHOsZL/oGIao/WoAY/yWBPeo3BuRWXowC9yJIKJCqqKMJ/zD9ShBMn06aU/Q+x2+oc1cKBNPQy4vRe9w1ZKFStFoPDsbMqIw0Ap+IuR310CbT7FAymMvioo4C3ePdrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BNOTnuelsBfrrU9uklPY89qD2utt/rstpeLwrCdtHI=;
 b=RPbJ6W48o3clOHKAop5nlUeqH6mw6E50mV9wIK+cMwM8VhJWVg01BYcge70OJiNRDP+8KhscHI8Ye5KuU8AOFrlTtJroYW0zYvv/X0x6wGhBw4dd+ubBECu1Pz8w7oVGef2ucv3F/NKzsrL+Fz/2XttdxDhWLyRKOXaBuIhw3EyclO27Ffk6kanfM4RiM0t2BpbFEVj8jNT1jy6VNusQFLPxhSkHdp8LLtPHLMxSgq/XzgPiYCQgiLTjhrNmjCEnWwjNx8IuilLOOlXwkld+oI2dC5LtdNnT3yNxrArD0CKRHfH9UCd8vTx0GIGFKm1aLTY6fSi5+lLmVGNaRCaHOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BNOTnuelsBfrrU9uklPY89qD2utt/rstpeLwrCdtHI=;
 b=qY3vPX7uX086/WHW2WabX6LawwMnRVxY9RAJO6PW5HB/4fWs3/Gup9zHL5oBajeaZ9e5bw5w595zQj8QXtCmBNYcHRkGMBJZ3P0tCESG8CFYPIy3V3mEhbj8o4dYzl+5iqcjcubMTOcWjcVLefRqxch5927pF+jmVsEoGpRJpZA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7631.eurprd04.prod.outlook.com (2603:10a6:102:e1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Thu, 11 May
 2023 13:10:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 13:10:11 +0000
Date: Thu, 11 May 2023 16:10:08 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add timestamp
 preferred choice property
Message-ID: <20230511131008.so5vfvnc3mrbfeh6@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-4-kory.maincent@bootlin.com>
 <20230412131421.3xeeahzp6dj46jit@skbuf>
 <20230412154446.23bf09cf@kmaincent-XPS-13-7390>
 <20230429174217.rawjgcxuyqs4agcf@skbuf>
 <20230502111043.2e8d48c9@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230502111043.2e8d48c9@kmaincent-XPS-13-7390>
X-ClientProxiedBy: FR2P281CA0140.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7631:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d268b25-0e4d-4be7-d186-08db52210d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F4ez/EMuThR4/B3xpy2NiTJwENPxFyFCoGhpi3vEakDK2X+tbamt/nr8+7qPTB300foCjqiXDNjpb8hd4N7ZiDGGbW1mtfzqT7dcepk/taP4fZnLzHT9/3DH/AcGYG3e/yKz8zqnzg02RTyh4Pk4MS5FDTNAytPFZUhhMR6PNK7eDOvQFodtDDiuWd0y61ZffIJxAoocyjYsCtspZ/ddaugg/rKHTs+emHnI257qPmRgJNrLEOiqzGwqgXOqQCxn76VVtFJ1FwlzMhkNMIPBJwXErnKJbMKpmfcLM8DVFZWQyx9LMTCwlSKUigU75Mt43v2kYF7ziFKjffGydPJ+fCmUhRs/nCGsrKYMI+TxRPRYWM1qZHN7uCiBuMzuSIiiD0Fuu5T1kkCoK3sfHFs+WofxgOnHtGq4qreBDR5lnLshhsUJO1y805jRDqoGxbxqNa1EGtHDbTktOxqa3u7u/4zMQader8YjFjqs8WbY/lbxcnObaSSOuWMGsL1getji+I4WxU4BjUtwqhG5nz957qeEuzVwTTt+93rHcEt2KRb/ezztnAHYN5X/c5SlXYaw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(2906002)(4744005)(6666004)(6486002)(478600001)(41300700001)(6512007)(9686003)(1076003)(26005)(186003)(6506007)(5660300002)(38100700002)(8676002)(6916009)(33716001)(8936002)(86362001)(7416002)(66556008)(66946007)(66476007)(316002)(4326008)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?ySK+c6pb+SLMfPSEgHjs3dADLBAsuVfb1K1zwzWGpwxuu1o9aSKJItFBag?=
 =?iso-8859-1?Q?UfQbZ+zXg01ulGsSNC/Ke83rLzCMwYPO4HhX1x83uaGxJ6lx1YtS1ma1Ux?=
 =?iso-8859-1?Q?CZha+HU2UArX8oNNfbPpshth41+tQnocTFTW4+A6jRxaeFfIxIop8ZMOQG?=
 =?iso-8859-1?Q?xDJJQC+67HjeR1x0HgaGw1VpL9lyPXCR6cCx5CSr6zdO+0UWSwMSk0cOC+?=
 =?iso-8859-1?Q?bot1qVbyKURsTt5vT35bb1oFm4xFzly/tn3PgYhGgZtie+QtJzNohj32y8?=
 =?iso-8859-1?Q?DV/pFyzcXa7nwEaD/Kt+T42P5h88rdqyq00//dluOsCIAxl6xf1PS/RF8t?=
 =?iso-8859-1?Q?XIx2JG+vHnLTjygMTBGl+J0+Z6fyL4RMbGoV+SLcXxS58RkvOaxADF4xPM?=
 =?iso-8859-1?Q?NllTwF0v2LKTUpGqrVhJafHTaUS1UiBUSbNvQ+rpfunvxPBlKmwWfRBBGx?=
 =?iso-8859-1?Q?FifC3PT/tM5VtMTpv6fGM5j7fBE+knoZQqPBNnKWrgf9PCwdjD2fnd8WJo?=
 =?iso-8859-1?Q?eLoP+L1DSwWPHjPoKn6BdnAjcIyFBqUVGXA7/ijAo/lOcBQJ4WoMLIeqNc?=
 =?iso-8859-1?Q?iElvQ5k0AJCSB773bF8miRyBI/53UvdZ3D3j2iKzxvgLAlNARwBQxQesjQ?=
 =?iso-8859-1?Q?8tBvQY7TMqzJBc4ku+U2rRMwfZQrUYHp7BA+KLitze/xle+ze4sxbeOLb5?=
 =?iso-8859-1?Q?qhjTN2lgrTX7upVuvvhOoSto//2SCVZhgtTTl4bjK6M+Wft7otR8U3qbfU?=
 =?iso-8859-1?Q?Gx3zCpp0agbAt4+8yc2fKmIUEWrZJ49cA5EiE8jTjsYV4SrSnDoiEI4vVR?=
 =?iso-8859-1?Q?ViPNRqDjZa2sk+nePI+MMA7znw8Nx2NzR2SC6XjTCN6UokbGr/5hVrZNjK?=
 =?iso-8859-1?Q?eAj0PFRlaqfqFVXrEO8z6GUMVq5DKxPpt6m76dtamDMeUzppYRJZX5alf8?=
 =?iso-8859-1?Q?zV9Zm+R9UuAKdzQnbor4s8qNgbnFzDBfIszLyl9GB3BCdlDv2NYNTThh/H?=
 =?iso-8859-1?Q?RfhdtSogmk8U91VD8p+5U/uOCy5TjgL3EgwHODtvigGxzhWF3w29sidup9?=
 =?iso-8859-1?Q?kMTFmFnkyfuVe0zghIXMDWD3LSYKullM8PlU9Zs1aQ3NPCBn7pjkql+SF/?=
 =?iso-8859-1?Q?ZloJrzNJEC3cuvM+UghZ+e/TEe/7Dm0iI3VuY4ueT6PGLnuMaIsVvSCdW0?=
 =?iso-8859-1?Q?o2g2UM/EM9A+k++CvAzhZHeTS/D2mPiQg+jX/kjmwdzhDRZPJh/8bj+eC9?=
 =?iso-8859-1?Q?gkJB3XLM+0OaqRoCz0YEwh5q1Dq5ME68FBZl2YA4e3D8w8g/mki0yhIg/4?=
 =?iso-8859-1?Q?3ABv0S2Q/jjyd3+uOY32I6BolAlBPaiOuZmBriPSGDPIecqsZVgckW8KAV?=
 =?iso-8859-1?Q?aKrC3w5RSqmh/WCfTx77KWZ8I9IQoCWCArf5LVfdXdKdm7cHhZqLFnY3Rq?=
 =?iso-8859-1?Q?7K5G40nk0tIDieTDlrTVc6rDcb8drdiwWve3FSYuxjf5WM/4IGOaPU7Xr8?=
 =?iso-8859-1?Q?0gsE9BbgfibAqM8f1KAjWH9/fm7EvHP7sdZLjzmosrr2XpbpkfYNeTeAI/?=
 =?iso-8859-1?Q?8CnKg+u0YiMB8nJReaghYLzI7mqbemWxE3zqqx1gKbgMBlqxk+6S+nvAvS?=
 =?iso-8859-1?Q?V+jMotnro2ls9BOwddRvnGwFWiJylB7NNwXdd8z7AJBe2FsPf4aODxRg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d268b25-0e4d-4be7-d186-08db52210d60
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:10:11.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXDe7ucP0o5DoGEkzLJvOC+eijNHH14HZ4KqKG5GeBpDEQ2I3hWEnbYoN9lmKrq98hR+ef5DS7YNLOTEDSL9CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7631
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 11:10:43AM +0200, Köry Maincent wrote:
> If a future PHY, featured like this TI PHYTER, is supported in the future the
> default timestamp will be the MAC and we won't be able to select the PHY by
> default.
> Another example is my case with the 88E151x PHY, on the Russell side with the
> Macchiatobin board, the MAC is more precise, and in my side with a custom board
> with macb MAC, the PHY is more precise. Be able to select the prefer one from
> devicetree is convenient.

If convenience is all that there is, I guess that's not a very strong
argument for putting something in the device tree which couldn't have
been handled by user space through an init script, and nothing would
have been broken as a result of that.

