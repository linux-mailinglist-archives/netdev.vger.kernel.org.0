Return-Path: <netdev+bounces-6870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF6D7187E5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6649B28155C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F2F17ACB;
	Wed, 31 May 2023 16:58:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE6E17736
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:58:27 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2057.outbound.protection.outlook.com [40.107.105.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6E9BE;
	Wed, 31 May 2023 09:58:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9D1iB1gUUQqvSD+fPf6Th8dSl2vNX4NhtD1J4zHPmeruy2me5laJJUHBGtZvUt5vAoVOwYjOUuRSnV6ZG6dGKrHE4svbuHjlRnzUXtM+o3P6Gpc+zUmR6sPUR7+34/IoABDWqwdpf0U5Cz6P47QMKXlhQ7Ir8I9YPMFViEb8ZAyVxG338d5dZ+JzVwdIKxhgK1b8ktEuTG4CJCrttGAiI9y2hUdEJ3mukyNTbefDn0lINQYPzM596tYrHyaQk/mAxOLWD7tu62IjW2SVySIsz8SYMsQ+ujc8hHb3TdNGq5Z0P8avN6IfR0AjC2kYM8v3HNFQ3MnCbGZX5VeY9+NFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WRx4mDUceWcVzUr+mJTHjIgFu1pHNakf0AvJ6a0StM8=;
 b=oOB399Jq9i+oegZYIbKBGxTIQpsGe5q7UbNMtPleUpp/0pO2pRoxomFyxC/Tf5mvPBtdDSEmTVbml21ow/QS3sv/UC/NQTjG+EdzA76TEthq0BBexy2VsTrru80ifgos5ZAHp+tt/8Sz5B7IHZPpJvo/HYe2Exd9xNLJQWKPHzNS6gKMtE7dO7fxWPn7d/OaJMfgrIVwN0molnyTupzbN22DuzDpGNSp1nRvvAZUTqQPVLe0yp6z/Bd+Iatam6fVSJoO+eKrGuFi8Z9K+2xV66gJortuja8VdjXsBqN9QaGfyQIZhazn9YFoLOHXchByDghKtsvz6LsxjSb5xMjamw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRx4mDUceWcVzUr+mJTHjIgFu1pHNakf0AvJ6a0StM8=;
 b=ngssc++5jRd4rOal1AjwLt6bD9b+JMtpUH7CqAz7plC+Q8rZW5M5ClfeQbyrLiIAksdZBxDf1RSAKIoE7uleeL3QvJQ2ZZrRywzdCb2qe6XP0jILvFL/5KKmAQa9tPo8Lza/795LrgaCWhwGhqPy2TftP2gw0fWCKZQfOdErIII=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB8395.eurprd04.prod.outlook.com (2603:10a6:10:247::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 16:58:23 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 16:58:23 +0000
Date: Wed, 31 May 2023 19:58:19 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230531165819.phx7uwlgtvnt3tvb@skbuf>
References: <20230530231509.4bybb5nw4xyxxq2m@skbuf>
 <ZHd8Ig7LzHqseAnq@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHd8Ig7LzHqseAnq@bhelgaas>
X-ClientProxiedBy: FR2P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB8395:EE_
X-MS-Office365-Filtering-Correlation-Id: 5421563a-34c0-4e4f-73a9-08db61f83e54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tEMXeKLuHb8gKrgr+w/jMAsxcVJ16WDrSHSFjJMC9El0o8poX0FE3jQS/EXaR45C9gfHe7K8h1kwASLCwF4iL7pO0NvqMKpOdCvkfU1/ObXrDVAdmEt0150T93Yb6EXgwmthXvak2doRWV7wdHj/WppgCsPQIB9bYDXaYxEPmWvr6y1xY3M54IzPCFkmnJR7X72M51tfYVUormlWgAG7LXtyuzY+eOs0/JfkSotvXfnXuRrDk1DxBUD/HZcfTI4bfHscyGCLZt4YV3pSkr/seXBf/XJrfedn92tux3b551NlWLshUE9Tb2TlIMrJQhZqcXLRV6LyqN6BZs2nVojhOHrRdGPQug8IHn+A0NqoCPTpfd4BUY8uZppIW/gNh9TlAk9dkNlDyg7nMvef4fYSWx3I2w1nCf4gzkbcMzrPU5rR2GEPF9hTyq6OFPfBYSUhBdiAzsIqm5JFkc+d+tJJMx45eQZJci4t7R8MKLKePy9NgQ+SNiJAENBH8WCPzuqLPNJdHHrgawARvimWLibRS9FL56erU04WYTNpj6kLHn2ACJh36YtX+1xqSN+qGBVu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199021)(186003)(38100700002)(41300700001)(83380400001)(9686003)(6506007)(26005)(6512007)(1076003)(6486002)(6666004)(478600001)(54906003)(66556008)(66476007)(66946007)(6916009)(4326008)(316002)(8936002)(44832011)(8676002)(33716001)(86362001)(5660300002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VBqTvcPoSu367UXKjTmMeCZzvgFKzRAMpE7jiQppHZGLsvsLLWlp+mUp9n5j?=
 =?us-ascii?Q?PWpvP0qNqBs5SWShcu7wLWQmIWXdFfpdBGMH+z0VeeoLa+s4wEyqCPfChvUJ?=
 =?us-ascii?Q?qGp0RvO9lcq9mEDRTpfDDe0tSpZcdGECgTpkIR436ezNhD0faJucYhsppLWm?=
 =?us-ascii?Q?tBkkjpgJ9i1GDxE/tepsIXxGdQfVK9KiZag/2NqJVF02nMl8KliFhgcosUUC?=
 =?us-ascii?Q?05rwrb4/Kobz/sXy/5Fubhoel3Q5d7qIb9yDUValH0jRciX3p9JLuoeCrKxx?=
 =?us-ascii?Q?/5bntieaGqVNVner6ikrKFBa+P6rePLikfzFf9Pdm0R8m5n2H2SecMjN4YXm?=
 =?us-ascii?Q?ccqqECdjpJ21znY03OPTvnHHNVVDzaba9Yf183NmuZLijdYh3bFVKl1UD3Au?=
 =?us-ascii?Q?78aF+UDJhe7SNMpFhekq+8vz6llFMZgZgNkO+H+/uCBLOapnd7tVWn4Vw/V4?=
 =?us-ascii?Q?NSB7wogA5D4OgdpwdPRjpYlK9+e2FsHsRRpiAXJK75SaGHaZZEpXdF/X/Gvy?=
 =?us-ascii?Q?1D1Ph6NKv/3KayHUfPHgkinG6WzZxHmlhLXEuHqVBxRA5EQwb36AS21erLsp?=
 =?us-ascii?Q?KmlaOnztDMb0yCln6HZhEqMY7Xt+jH3jyJa/iLmdEfNjRAc+M1YHet0IQwCE?=
 =?us-ascii?Q?/Az2gqa57YOeN08jtsxoVXS+sJTvFLcoKaVQ0cS5dl+4IgnMk/J3HhR+j3QS?=
 =?us-ascii?Q?D3LuxeiV0KZSQfOSE8fe0o1uHHteNclkzdWIs7uMikTvyt/1Ns3paXiU7Vgw?=
 =?us-ascii?Q?56nSfnMCol9r2lp4uePhQI7AFPfzu+0P/06vZ3699Hj1pJZZn3qFcoyFi9vs?=
 =?us-ascii?Q?ToYDVpV0Suhc3LYCRvAhRp/51GOJAmGWYS0wpn0Df68UOrl6ivQvGZe9PpuK?=
 =?us-ascii?Q?0y7suzb4fefvlTHEPsVyV7U1rbWbvaVW9wlYhqH4/xFAC50RXVHnwUB8tuCa?=
 =?us-ascii?Q?/j//9MD2iRrppLwAXZCiDxhS5C6SLyQr+s/yQrAO+8gFxt39CI0XdEh3w5hV?=
 =?us-ascii?Q?KFpjdWYKEP1nI5YPSpMvliyZiRS9vm9zJgdIYvYdihXW6KiROs9FSIycN3Wb?=
 =?us-ascii?Q?6vTYrEBPmm6/QuWtPjCiw9WgW9ADfQtqQv2urM/9VcVDzsTCZzuBbGNLfKj3?=
 =?us-ascii?Q?dMD4S9OmeTZxDDk+xKdO+Q1T5kic0twmlf0shzzJDltm/yRlqkofZFMX6A77?=
 =?us-ascii?Q?bwai+LmSgcdkWb06JuvLOCWkyl3Zuey8V72OUTGkw5UprWQ1IA8BeDifI9ZT?=
 =?us-ascii?Q?MC8VvEV3NIF0IsdotIBajfctmYZlTQZNTwy7HrR1eCdC1ZiK82GmQSetRVm1?=
 =?us-ascii?Q?/Q8/4UallkyK8sH67IvBFOAU9W0FnGr/BBR2cctbaBitOSA3FHwZc28B4Zyd?=
 =?us-ascii?Q?AmSpKJC+iXFMw63KvnZxoy7Q2NfEzYLsw+SoVL9tRYwCZdA7cS5PHzkXPb7u?=
 =?us-ascii?Q?Zwh/+UB/MMRyVZd272PEMTw0G0fqCnF2gu4eF76wRVTUCfkv+vVFDmQiisYu?=
 =?us-ascii?Q?7sT5eUcy7Oac121B/e3TFRl7roZddPZ2L2WtFxfZSCmFB4rrfOm+M4fzgaoZ?=
 =?us-ascii?Q?LaasE4gZ6wa4dsBoqziMXqJ1QVb/nJ7FIu9/3n+Jt3r1xV9yJLksmtzNRphG?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5421563a-34c0-4e4f-73a9-08db61f83e54
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:58:23.0111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6raFeGySd6Nm3PJfxS2Y7YHXfIyspH13BRAg+jn2F8dBx3NGpSENuE4zYyBOdFBueXA+SObsM9C26e5aE70OoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8395
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 11:56:02AM -0500, Bjorn Helgaas wrote:
> On Wed, May 31, 2023 at 02:15:09AM +0300, Vladimir Oltean wrote:
> > On Tue, May 30, 2023 at 05:27:24PM -0500, Bjorn Helgaas wrote:
> > > Ah, you're right, sorry I missed that.  Dispensing with the SERDES
> > > details would make this more obvious.
> > 
> > Lesson learned. When I had just gotten out of college, every time I asked
> > the coworkers in my company what they're up to, I was amazed by them just
> > proceeding to tell me all the nitty gritty details of what they're doing
> > and debugging, like I was supposed to understand or care for that matter.
> > "Dude, can't you just paint the high level idea without using dorky words?"
> > Now I'm one of them...
> 
> Haha :)  Communication is the hardest part!

I know...

> What bad things happen without this patch?

It's in the commit title: probing the entire device (PCI device!!!) is
skipped if function 0 has status = "disabled". Aka PCIe functions 1, 2, 3, 4, ...

