Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F403E4095
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 08:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhHIGzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 02:55:06 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:34266 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232800AbhHIGzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 02:55:05 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01lp2053.outbound.protection.outlook.com [104.47.2.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 88B6340080;
        Mon,  9 Aug 2021 06:54:43 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdkRuj8l11/ndci3W7xDr7bj83XMOSXAH9Yy1aQWL+BIYJSobqSzbI6iaaW96NqQjnZwHF3ooXFn6GR2a4dTNCuaMpjRPryZ6sYvNAeyV9AVdXLPq9smF8+/1lctykBfFmedN4vRC2N+4Qlw49xt+vwcp+eeCSHOW98LdJf27xkMeyhK0Bl2ugJ6eLmyESSclfJYSsr4/yu9oTLq8fuo9jsnMkatfV+WqVE/07H4PDsQ1YGXUKHTmcR6LEqAElVBOJGd3CFKnTlWrGjwfzTFcKYoH2OZwrJIIiJTzlaKzPPI0chTnLql1CYxlr4uvq42Ffa7Q3hpDqgTOE/q5fpQ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxDOYpES8G67FHNkjLlg+MwAtwpoiYlXMiMCR5umqOg=;
 b=FbKfkOMzmlrOQIvxSZxlz2Sy0AoScMyFVC7KbmteKu0b0M7uDeyyomwjE2TK3V1BT0N8r391hdM/pIboiE3lzR0NHdvQTiKUIsqHKAB+nKIUHIZx0RuBecS1i6XixM7kO4jh8Zd20XscnxmK4OCGZaX1vASSWS/aPtXLEcy2p6b8u4+ln3C4n2Jh5ibqT8SAURsOD+OJX1w37iHGybFzFyu0HlApCs4J7FQInOOYMRZ4DZAkmkdpwjq2XNwo2r0BOf59oNo2veVBzwIPrYSCKRyhBdBS7jiEKa4xrHHBOHZkoYcFx3Ep2NTmYXSwxCeIbT5L1gwA/WshJ/47IiFyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxDOYpES8G67FHNkjLlg+MwAtwpoiYlXMiMCR5umqOg=;
 b=F64ibmXUjDU35+O1ueTwFDycjc3+a2XFRPsKoAkrcTK+dQCcrFxR5YUJGBu33HWCFXinfy1xm+XY77d7Fb/QLpsobm6kjxTBjMfjw/6YowiunW5cu48XOfJJUvfHqoEoSykb0kTa3dpyU/jM+ebgcyJMcI3ve0XFmtoriNU542M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from AM6PR08MB3510.eurprd08.prod.outlook.com (2603:10a6:20b:48::30)
 by AS8PR08MB7026.eurprd08.prod.outlook.com (2603:10a6:20b:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 06:54:41 +0000
Received: from AM6PR08MB3510.eurprd08.prod.outlook.com
 ([fe80::d90b:71c3:9c4c:34a3]) by AM6PR08MB3510.eurprd08.prod.outlook.com
 ([fe80::d90b:71c3:9c4c:34a3%4]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 06:54:41 +0000
Date:   Mon, 9 Aug 2021 09:54:32 +0300
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH] net: Support filtering interfaces on no master
Message-ID: <20210809065432.lk2dx3abff4p6wmq@kgollan-pc>
References: <20210808132836.1552870-1-lschlesinger@drivenets.com>
 <439cf1f8-78ad-2fec-8a43-a863ac34297b@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <439cf1f8-78ad-2fec-8a43-a863ac34297b@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: LO4P123CA0284.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::19) To AM6PR08MB3510.eurprd08.prod.outlook.com
 (2603:10a6:20b:48::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc (82.166.105.36) by LO4P123CA0284.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:195::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 06:54:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b920b93-07dc-44c5-914b-08d95b028fb9
X-MS-TrafficTypeDiagnostic: AS8PR08MB7026:
X-Microsoft-Antispam-PRVS: <AS8PR08MB702616895C5AABC04FD54DC5CCF69@AS8PR08MB7026.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J7/rW5PREhi1gsK0WaCZBYmUmGOzjNQh8QcTTXCcHRXNuX5rPurpDgIpDcAj8yUq9Fyrm2m/b5LZBD9c4rcBm3gFVM7oxRjkDKRZBhtLBS5Ul8Jm/2p5ymaeWAz0eDlc09W9SD9ZSU47WRM6EciWVu/wWTtKD+hI1vmYDcJYd48nbSZzy7BdxHV30YbzBjVJTUeuay+KEnGg9NEW8Lqjcqgv7JVWohN6O44Ei7Bka3w7x38ZqKvHp57vHs7hMzkOKQbgEPR4tuMv/RWUUxsWIavTaC/RG48DGF+/rJuXDiBB3KDcxMZtJtUXXvR1scQ6MMqItcBa9rzqWgrXA2sRiqCq0NHTLvHxHyamSgO0qBEczghFkjg12UTErSajl/Jp5oUnHzJGCGii3Xruq2PLRVa2J82o78HrmyL8PTau9XVoguzisyp42d+3U+DtDAPxuegexeeI2wIz1No0G3gWxTkzBBqK4+7hWfKM+vzEIjoCKqK7jSIXAPwjtA3j+0It5lS42ANOS/UeXxyu+cbWvW36KGGFPi01WyyURtZVLKPxdJy5gZ7gxJdqkYwNa1GSGccfZEvT0GL/yal1UOshqV78t3cdrEwi930KzDrvvCRqF+wodm1xzO+I9NAyPLHS10Xqqw+SoNyBLkxZFJdvCQTLIWnoYdQ1ZNsyskzAv9eJzNDvf8MGAYiCT9bt6SQp3/PF7ebw2rAD0xDLY69rJRryrf9gM3kwmSPgZXau2oFMVaAo9YZ8nJMOL07u/9Lc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3510.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39830400003)(346002)(396003)(376002)(316002)(6496006)(1076003)(33716001)(9686003)(8676002)(6666004)(4326008)(52116002)(478600001)(5660300002)(8936002)(53546011)(86362001)(26005)(956004)(186003)(66946007)(55016002)(66556008)(66476007)(6916009)(38100700002)(38350700002)(2906002)(16060500005)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZkUAyO0sL2SrZYiqi0DgFgPIHuxKN8MHVn+Wu5UNvrRXQ+ndMC6JKW51kt7R?=
 =?us-ascii?Q?7mvfLGxE4XDzl4JZOv+Rv8EOiAQwzCkxC4LIrj72sUZkrLpY5sB32ID9iVDc?=
 =?us-ascii?Q?5yF1izK3KcK5VWFXuGWQrO/R0oq4LT/RoWI7x4yguQBVKv4e1TexXniT54a4?=
 =?us-ascii?Q?NNL5gDAlZXnTdkq7/nAOuVexecJOQ2dHAxR/boPjx5iIx0BduVhkY6rc2zkN?=
 =?us-ascii?Q?9G+DX3aPwzMntJvxlNDqO4kTJBoMYkfHSapTaQpGYxgL6B6avZBZszoJJ4L5?=
 =?us-ascii?Q?ZzKFLRgVBNEyT5IsH/1DXOQiPJVkqGVaCxf+fjRUEkb5f9Ump9h/fWb9DrPD?=
 =?us-ascii?Q?8lFTZJBzavDoyobIKSeLzIefp4V6ZJicE9X7rFYTfhQMHfBTCWM7QSzwwaBa?=
 =?us-ascii?Q?eQLbkpkxSWi+KilY2zVPS94Dsl5jjOc6YljlrxFGiCb8DjEVbkVfE5YtzASG?=
 =?us-ascii?Q?jvxASbW/GbQY6SD6+8HG0gZZYq4XrMOAGZ/aE+tfEsMQwLLKUnnZ3onXfDGg?=
 =?us-ascii?Q?LywajPJrRAJCpki14MKOG/ExXnG5wuwfY3ldAXeoOx4wbvImE0gu9oC5F/g7?=
 =?us-ascii?Q?Ph3asA0bws7pcxvZBT6sSKz1LMaoTmcJqv0+twAN7+SCkJQEZjOoFdJB7l9n?=
 =?us-ascii?Q?cHPaoU2e8/RR5dea85aztp2pDJ0OSCQW1nrXm4tIBNXeVC2y56O7bJgMK7A6?=
 =?us-ascii?Q?JLsBZ5HXAKxgt4sKV7bWTsU5bujHS3k9em5k3KtU4kAzNfek6a3KJHuhWVuQ?=
 =?us-ascii?Q?WpCoHoJFlRzeJle3agBt3NXbeIUQmWzzkW7FM+6afsZFSQp1wxB6lxNJ6TTw?=
 =?us-ascii?Q?RsPEg0/2PUjITNgeScMTi0ICeGoYgbi0K2MIJlk6D0NFTLWNWQNFpve8PppN?=
 =?us-ascii?Q?a0sRI1vBw02b3gJq4W8ghrfk8AU1N5lxustPxKlGbQY4nhid6zRk77V8ii27?=
 =?us-ascii?Q?0LO59C9FyyU4/fUxkIaf22R2/WHjl+cYKhCqK8A+UyE1Ht8nQDtP6g7L3X59?=
 =?us-ascii?Q?pLnayiprkBJdk9z4pdCAU6nMPHF8BMLaogB/6O4fYFRSmPrtZPIrxCjzLu8D?=
 =?us-ascii?Q?+pfWyTK1FGywjl9hJievNcX8N9NhKA/RPRwzY8OVHg6t4P5RO66OVygrHOry?=
 =?us-ascii?Q?PhO3HwAaEqGwWtFZCxuIIFwVuSLuLCIj2LXI+Q74KX/rROB1bqNdkeDTdq59?=
 =?us-ascii?Q?wh4wO4+4nQfYUyEw9jfkG+latsDj1FUdivwsFhUDmQ/P9up/f23Bz9XbHmVM?=
 =?us-ascii?Q?Na19FbrAXb3DnU3bYryP/MLEvLFhbDtqz+StMw+A339TKOqDE2Qd45Jqj9xA?=
 =?us-ascii?Q?gfFJkjuIy0SUcETYUdubOOIF?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b920b93-07dc-44c5-914b-08d95b028fb9
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB3510.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 06:54:41.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KARCVwZ399g64Bahk9PNZyqusVc3YSKcFsjaLn+xr5W/NwiRw9gc72+P7oGn0xrQ6bnA6ASZ+y1605nAFMOBZjq278gf0WVIKgTXDlkxKjI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7026
X-MDID: 1628492084-1kM2sOZnzEVm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 08, 2021 at 02:02:36PM -0600, David Ahern wrote:
> On 8/8/21 7:28 AM, Lahav Schlesinger wrote:
> > Currently there's support for filtering neighbours/links for interfaces
> > which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> > attributes).
> >
> > This patch adds support for filtering interfaces/neighbours dump for
> > interfaces that *don't* have a master.
> >
> > I have a patch for iproute2 ready for adding this support in userspace.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/core/neighbour.c | 7 +++++++
> >  net/core/rtnetlink.c | 7 +++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 53e85c70c6e5..1b1e0ca70650 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -2533,6 +2533,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
> >  		return false;
> >
> >  	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
> > +
> > +	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
> > +	 * invalid value for ifindex to denote "no master".
> > +	 */
> > +	if (master_idx == -1)
> > +                return (bool)master;
>
> return !!master;
>
> same below
>
> > +
> >  	if (!master || master->ifindex != master_idx)
> >  		return true;
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index f6af3e74fc44..8ccc314744d4 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1970,6 +1970,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
> >  		return false;
> >
> >  	master = netdev_master_upper_dev_get(dev);
> > +
> > +	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
> > +	 * another invalid value for ifindex to denote "no master".
> > +	 */
> > +	if (master_idx == -1)
> > +                return (bool)master;
> > +
> >  	if (!master || master->ifindex != master_idx)
> >  		return true;
> >
> >
>


From 7908142b2d4799672a7f9dd27e848214e3c4a0a7 Mon Sep 17 00:00:00 2001
From: Lahav Schlesinger <lschlesinger@drivenets.com>
Date: Sun, 8 Aug 2021 13:16:44 +0000
Subject: [PATCH] net: Support filtering interfaces on no master

Currently there's support for filtering neighbours/links for interfaces
which have a specific master device (using the IFLA_MASTER/NDA_MASTER
attributes).

This patch adds support for filtering interfaces/neighbours dump for
interfaces that *don't* have a master.

I have a patch for iproute2 ready for adding this support in userspace.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/core/neighbour.c | 7 +++++++
 net/core/rtnetlink.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 53e85c70c6e5..3aeefc48b96a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2533,6 +2533,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
 		return false;

 	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
+
+	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
+	 * invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+		return !!master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..bc4d62174ab0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1970,6 +1970,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
 		return false;

 	master = netdev_master_upper_dev_get(dev);
+
+	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
+	 * another invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+		return !!master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;

--
2.25.1
