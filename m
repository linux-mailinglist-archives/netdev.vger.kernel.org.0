Return-Path: <netdev+bounces-6612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 637AB71716B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0169F1C20D45
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DC434CF5;
	Tue, 30 May 2023 23:15:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED76A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:15:18 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2048.outbound.protection.outlook.com [40.107.105.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26B0E5;
	Tue, 30 May 2023 16:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEwaYVrseaMY0SGDtm/OFnl2MKTqrHyrP4MzHAn10d8EISbQezgVHk0n1xYGCOiMMeTx98UaVtaZSJ9gQQRgor0BUa4W+9utsbIQ7zH1oCAT91N9BezY+w6SBNsQfZLwpaPv9nkZ41JtQvtERlFsDYMe7m6IgrtTuTun6Ewa3ITcWLJyjd0OXz/XopkshxlraPyOxPg5q64BIIAvKa35xU5SJC7C6IICQXfYUQq9oz/+v7QRNOuFv07Vvp4Pesb3HHEXcGh2na1hoKuCMS2I08TLWVsNjxN/uAPL/mspuoCF/LCEpIFIt7+wOGxb7NpUPNv1Ha3iZq1i89wiZMmFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zG7xYUMG0n3gsvTCSmGYZQaKLjWXkwITzhR+YMyPcRM=;
 b=ABw906BG4jy0V7EO7BpkFrS8KnBCnRjWXoLlXBuC8eFCDLsqflalLaH3N1/1VuH5jnj080sKTfWugLavITaXbLxXPrxXB3uL04luL+rcdX/9UGZ/440EA1uiu6eEm5PSa4QSDrc1gsV+g8rV7sAR4IHsegIoWX7HGC+gBpC1lvDCZZu1KgMxEVSXqgz3BbF41uZOyb0sRAGqS6KVjoYo44HCW5Y0Mbrsyc0mo4l8fGomjG0OLEy1Qd8T8gs2L1g1fLpcPuJc51WvJo3/r9YTJisPTYxKuC90dVMNnbbgjfu5Jm+xCQQhnpO0IDXBJYE5vpds0CgStk9FVK7KB+jTCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zG7xYUMG0n3gsvTCSmGYZQaKLjWXkwITzhR+YMyPcRM=;
 b=EeXBUH5eTKysGNkRJ9MYWGJ/9X3UPOYEFn+5CL8RaYwqStXUYJfn1lu35OqzaxvGqP7YByI6GymWxMjhKi5FgnQPCJWiggnw9eIjqKRwOHqye47+J02v7o0FeN7CeFtO3uCN3tXnhie/5p1GXQBmMKqIAoZJojyNiC1xfynus90=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by VE1PR04MB7232.eurprd04.prod.outlook.com (2603:10a6:800:1af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 23:15:14 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 23:15:13 +0000
Date: Wed, 31 May 2023 02:15:09 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230530231509.4bybb5nw4xyxxq2m@skbuf>
References: <20230530220436.fooxifm47irxqlrj@skbuf>
 <ZHZ4TFjFLrKeHPGi@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHZ4TFjFLrKeHPGi@bhelgaas>
X-ClientProxiedBy: FR2P281CA0041.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::12) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|VE1PR04MB7232:EE_
X-MS-Office365-Filtering-Correlation-Id: 42524e5a-df3b-468a-338f-08db6163b8d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S9xPHSrVD/o00sHRuNplqIO2jKqNweKDtGwdlwsAuN7aN6gJ4+fw73HxwuFK0vYlmFE40xwFBV/4shQFdJWyB11rYCiJgp3beLX0z6VH9vpOpI5q+d6nJDNMbjy2iIyaCi53ozxXwRUlrWAtSPIbnrtV6jG7cfIdLyToyvOCT73pLVD7YfM+lSdWVRGO6R2Fw5pzPJlpoZAO0Poez73TtN8nKEDePhahO86KbRCzqMx0eVm6DOfa0Z7WKxG0yaCV+18tc1I5IaIVq5mTL7q6Wm//lG0XycjtRdjwJsKrZ1SBIQSkwwKfEcgcRFLY565udusLa6xA16LNenD7EwlQSrFl+yUu5EpQXkiyOeUdsT+i4xXPRVOVbVpfU/PxaFvbiMDIlKA0bt7cwLWiJiKo3694p9gCIaAc49fjpm9Hm0DXRLbdq6+V78vJ0d9eXsYauvQDodZn0nAS8GuvatO/W85klA2VpriUIQrXQDgOJkKBWAFv04Amny4HpOLQln+Z+d5RCb8kr1gsNsmlG/dY18ggE47e3s1iDP3umyAUFreNU8NmQHub5husVKWf/gOV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(26005)(1076003)(38100700002)(41300700001)(6486002)(6666004)(186003)(6512007)(6506007)(9686003)(478600001)(54906003)(6916009)(66556008)(66946007)(4326008)(66476007)(316002)(5660300002)(8676002)(8936002)(44832011)(33716001)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XcBtnet2379H9K6CIL9VMSk2jeeozx5JWTtCKFUTbTzaJJZNCj5x4RhkLFi4?=
 =?us-ascii?Q?Y0lc6tJHohKLUEJEARyJRBBnzjXzWFZropa9RppzHgERaMHitQPZXtlN7hl9?=
 =?us-ascii?Q?d44IbmS60P5sD/q/u2S2DInsg9/gwCBk/zy1qd6V/RHc6mm/rJkCvTZ61Vgl?=
 =?us-ascii?Q?YCSkcJSpiPiMswm9v47LMSN31IMKAs9t7Nr7qUED0Pd+BH+UGUlwpsGgJ6+Q?=
 =?us-ascii?Q?3M6M6n1UTU6zIDjyTXxZBeekV0mLWkTdlp/bJzUEpofBuSA9YyZl1dN88+zD?=
 =?us-ascii?Q?TyfFB5uYq8rcd181dist7j2mlleYhfHh+s7FfyQNpF3tS8mQKDCUxr8vNDMh?=
 =?us-ascii?Q?13cLBu5wlH+zScG6lMX7r+e4SWKp3A8foWu+k10nvTa14I7KTM8AMYwgslXD?=
 =?us-ascii?Q?cD7pBSwbaEVZULbqqVzhk+PWMhPFsjzh0DWPCTc+snsUUWVoL5e8mBx4ElT+?=
 =?us-ascii?Q?2OLpUSenYZ49FDjyDZFtiuB9mtEp71LSNEQaghmoA+tv33SZslpSX3Gr7TDb?=
 =?us-ascii?Q?GSoDKwiQyAzHcYrtgaRce42in4m0Mvtplr8q58hr8A4mImzWt9vWdRvDehwg?=
 =?us-ascii?Q?18Uyqi3b0tgpMzfsy+WnbZCIwvfm/aU2k20+ciXzVDiGyi41qPYP4d5qh3j7?=
 =?us-ascii?Q?N8zcUUlKg+Gmo3Q1tZ+uwe0zrOZuNkwSah7uQdqaJwK4GuB5wnSAkofzFEWG?=
 =?us-ascii?Q?rWTYEGwUqyWvxXh4NflRFRoct+Ieds6ze+4zxjt6IHbEENtmwvmRqtfZR/Ou?=
 =?us-ascii?Q?gQTUlMInHHJ8aFGzUnE8NzKoqqiWu8BHFDW67JZef8gO1k1ztsmMXucv/0Hl?=
 =?us-ascii?Q?2VVdG9dVZkCNULBOnK7XQNz6ZtFpISXuQ4zJQnJIsLtlQfWGCJmaTKWM6gj+?=
 =?us-ascii?Q?STryORj54bkIy3vU06cJFQBULHNc3EsPT/SIlSVVJG7CDhJuDViCDA9FMP6f?=
 =?us-ascii?Q?FgwuqkPaZXRM4W+ez6oHqvhPK+1m5OsMeBTB0HNj2pFafQWbjJyHEXVXtXjM?=
 =?us-ascii?Q?yDhPb67GwF8CUvXVE//B3Mov7vyS4dC+LyofIF1EVfwa9nlbUn+SVUWffEfq?=
 =?us-ascii?Q?3KFzEKHYN3rBcwUH7ch4f800Bk0Aq6iBrikrJnfekMqA0sysr891pUA0+3j/?=
 =?us-ascii?Q?MXL4ESuCs3npWisAiwGf9Wtdr/7GA9PqQmuMEavB8Mx7dF83QIqXBZgDXLlz?=
 =?us-ascii?Q?p+w5JMJPjcX0uKuEU4RWmeSJAOeUUhCZ+Zn89yhhwDYqNu9Ibr1EPgftCtHY?=
 =?us-ascii?Q?SGH0FWGy8nWLKpwMVxK2IIY9z5/hbVzIvH9UiNIUJftal0Mg8WlPWo4YyD6w?=
 =?us-ascii?Q?u+m6HqXJhIgNpMxCxuDO8vZQFxy/XJ3JYhlTypAMWb3DoJpMmD/1rEF0als/?=
 =?us-ascii?Q?xXjwPAEfHMtcz8YFsASgqIkCWfZJvGZz1xJbuWzCRShgONBGJ5XQoGURk/9H?=
 =?us-ascii?Q?mY1OkiTiFHh/HMKNoTb3F1Uw5S6fIHkYMEwri9canDZTuSSY9cwP31PllLdr?=
 =?us-ascii?Q?Oh7eN+0tIqZfFPHk5MZ8NISGu8OVICYVZtvfzs4OEkTn59vrLrflWZQf21rB?=
 =?us-ascii?Q?HhWXjPHBFXyCoN7KhTnB8aM1NyFWWdUXpT/VYz37fzWRHFFTjokdxQE3alPf?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42524e5a-df3b-468a-338f-08db6163b8d3
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 23:15:13.4932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TaDyFNBIXuHbP8o5puuQYgAldqGA3FbHbDxfxbxa0f5EUiR4N9S4UMnDmcblM5vXAqtfaN9GBu04zKuBm5H96g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7232
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 05:27:24PM -0500, Bjorn Helgaas wrote:
> Ah, you're right, sorry I missed that.  Dispensing with the SERDES
> details would make this more obvious.

Lesson learned. When I had just gotten out of college, every time I asked
the coworkers in my company what they're up to, I was amazed by them just
proceeding to tell me all the nitty gritty details of what they're doing
and debugging, like I was supposed to understand or care for that matter.
"Dude, can't you just paint the high level idea without using dorky words?"
Now I'm one of them...

> Not sure why this needs to change the pci_scan_slot() path, since
> Function 0 is present and enumerable even though it's not useful in
> some cases.

Well, the rationale for me was pretty simple: it's the pci_scan_slot() logic
that I want to change - continue enumeration in some cases when the pci_dev
for fn 0 is NULL - and I'm otherwise perfectly okay with pci_scan_slot()
getting a NULL pci_dev from pci_setup_device() for fn 0. That wasn't something
I had in mind to change.

This patch is what it takes to propagate a qualifier, without leaving a mark
in any structure, for that NULL return code: is it NULL because enumeration
came up with nothing, or is it NULL because pci_set_of_node() said so?

> Seems like something in pci_set_of_node() or a quirk could do whatever
> you need to do.

Could you help me out with a more detailed hint here? I'm not really
familiar with the PCI core code. You probably mean to suggest leaving a
stateful flag somewhere, though I'm not exactly sure where that is, that
would reach pci_scan_slot() enough to be able to alter its decision.

