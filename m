Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001F03E5448
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhHJH0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:26:53 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.32]:8682 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232973AbhHJH0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:26:41 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99E866C0076;
        Tue, 10 Aug 2021 07:26:16 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3W0xzMQ7CSX5HEF7H2YDArHLijC8eB7MxmXUaaLPQ6zuQksb6k3XA34IthRO/6Pc6AUo5UHQFyrtSDaDmDvfDAYQ3gnnDtv5u8RchH2106+c5pjf7lI8mq50aS/DCoi/krkfTgZtnFiONLFvDF7jpRRS5fg5aKd2kIjeYSkTt6Y0T0V7ko0NhzpcBd+gocxjvMhviglgV9kY+Oz+M9U7ZLPZ2qWxGHViLTP5+j7n9KbQ+d3vMqEW2o1K5sdf+QmsCCUnBsZeGAt/Nar8w498hw+zl83FMOF7r6c7kXqV2RyZs2DBmYtHZuMpgFkcAqYu21r5QhvAPYuFwodCv7K+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0Bjt7mIuC5bLBMdViuOUdMGqptp28vU1M8VhFWloRQ=;
 b=WSzAJ1Y1A6IabjRZp+fR9OhHUzWYZlbKwbXSmWz88FYOL//PnphnkstA4kZi1nE/tcTJKREevg9yhF/WFz5SC3nWqtmbP/VNmZNZGUldw+5SHkuFxV9wlARxKvUXUwI6HB7VwuI6PpICZUU7kLNZRBKqn9kEQyyufEf08m5/HQXsMFeWpmTIAQ7d+TDKK/OBa1Vza1zbHAXcZgV/OaHwneJQV1f9+E8+/rk+IFttEG3NRcgykAwFa67xcHMO//PA3Pd2HpCORwNb5vZ/fxMnFL3JpF8FbOMQ5yt1huxy+PiuxSoqtlzZYFPZuYlA01Jd4kZEK/ZIQvacNK3YK0xqzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0Bjt7mIuC5bLBMdViuOUdMGqptp28vU1M8VhFWloRQ=;
 b=jjowi8F1c5hDcpdL65PaUWJ8bjR6P+/F0vJaLtcd4RbDJjr/EmBye5v/NgOcsw4VmkqDJCquGhqfxlqQ/dJ0t2lRXzFKzec8olvOlGopXCtT8nwGONBOrehNxwREtZcQihyezKBxaHgVvBpNoG1uyyBt6X6mweA1o+ZvqD52X7U=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB3246.eurprd08.prod.outlook.com (2603:10a6:803:4b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 07:26:15 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 07:26:15 +0000
Date:   Tue, 10 Aug 2021 10:26:08 +0300
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net-next v3] net: Support filtering interfaces on no
 master
Message-ID: <20210810072608.haanbwgpijyfxgjl@kgollan-pc>
References: <20210810064943.2778030-1-lschlesinger@drivenets.com>
 <YRIm1deoDLl37V8n@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRIm1deoDLl37V8n@unreal>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: LO4P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::12) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc (82.166.105.36) by LO4P123CA0007.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:150::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 07:26:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0525d00-164f-4843-a7e3-08d95bd02360
X-MS-TrafficTypeDiagnostic: VI1PR08MB3246:
X-Microsoft-Antispam-PRVS: <VI1PR08MB3246B8252D57E8740C392BA4CCF79@VI1PR08MB3246.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C3ulo2z7z8WGJ5GAqeBcLdiZiDc79oDmttxKZuR1ownh9JJfbngcUodNmqnV5ABMjcsMVQoYBtHJmAfDaZRUk7q3GAJeLTgzmKGSvL9E9wYQxY4Pln8EmgkqOF5FCx80OMbGjUK3z/wvX9khWopAZ2w0xlGtsJTvkLq+JZ3eDKxip+IG93CvzIESlAH/K1P3e4AeBwUqqWb151zcdF3rBofn0TpSenVPU1T+GEIzrggTNZ2yUw6N++txtC2Mb3U5aZRCDYVvAQ6ZfxZ8SkbqrPtajT9KOPf35CvaAlvwJKs29+e6jmD52OQRcL3pX+Dsi0xgsXhJdTS0Q6wvkOMiVG/OC+hrEdPMBAUBRcd/yMGSuO678KUUdLOi2Oi76EHOb2r7sYTdoztXakLu9jnvdTML7FPHU3FfxPFEBNME0pvsUSE57906xeM8SQXkjTI5uVR/+uIibvGoceUa8kMif9KrUOwwZC64ZpT6cWnQY8t3JT3mesUjyxvTpZM+TTwlcD/lPUXV6Dx3l9Aneh9U01UpYJ+MPv6k6FIY6TTrzetambMwrSjU/7ii2ahEvvuF0O5Us799OjY0jOBkoE03uF3CGtfcCv/JLO1YL4Cy7fkZRTyWilpkWmA+dIBzWqXPrVALiqvpE0lCBzWWJSKVd/Qfq0Ikt1H7uH5DhYhR8li/PNJXe9IWE3pP90KDON3JLh0xved1Hls0v8N+vt+VD+dAwUgsR7I2ALY0PVjBzGCoQiU6od9cmh+IHszxJM33Z37UeRvIrwfOnl6VA0CBHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(39830400003)(346002)(38350700002)(55016002)(52116002)(1076003)(6496006)(9686003)(478600001)(33716001)(956004)(83380400001)(26005)(38100700002)(86362001)(316002)(6666004)(8936002)(66946007)(66476007)(66556008)(3716004)(2906002)(4326008)(8676002)(186003)(6916009)(5660300002)(16060500005)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gy3Dt2I36t+ql0ifn5nFfFQv8ZZByZkHBARhflOXpm0Pjg3+RKpLVTFHgafw?=
 =?us-ascii?Q?thAQzBWThLAaQbjbOyPR1RTzZbSbQ6PnEjKS9q35lzCNUIldCzWlGKGUt9Bh?=
 =?us-ascii?Q?MjcrFeMYOvMCla4+yV9jvpUQo18nR6JbC5AH3ZJkR5JLZsKnUNetqxHbCNXg?=
 =?us-ascii?Q?spd820jspGvrwokmeiBioLdj5ooScYTN7RtWb4KDrXttlYO+Yu9S0kaeMcvg?=
 =?us-ascii?Q?TwUCnZrnBU2+F+x6UlOM/1uHDm4pHDrOBntYItHV3GtIsvOTD50cxf9t6UEt?=
 =?us-ascii?Q?8IpZrXm8R4QJx1mWWbkeLnjZA8TsGwsdOA8pIx/1wAOUBHYnFhk9i9nu4l2T?=
 =?us-ascii?Q?N0hGTc94ij9Z4537fZKesr03xparJLF9QwsgFveq1yaGHhkg48I4s/0DKBRu?=
 =?us-ascii?Q?KeuOW8/oUH7j7yanNv9mWPjS3vlVghP/wAua8wy+uv37btQcx5jQ2AXSflr+?=
 =?us-ascii?Q?7qKCkw2QvEmpVj51nMjzgVuJ6AL3ER2v3W/kf3+Q9Cp2v9z+MSxP8u45oJqj?=
 =?us-ascii?Q?w6ChYbc8foTwZJAQwNRz+J/T5r5WpIiZEdI2Mb+yDsFM139JAwiaywv567/o?=
 =?us-ascii?Q?3yWrvtQrCTi9QTyLqn6GLmTOC5qr9SP4NgS39Ji7r5TzgpzECpRiCCYGHmxr?=
 =?us-ascii?Q?lq9bfXIbOxTeRDSMmRIMh8ZYrUQCtHNVEJrHG9JpA80eAzMZxfQXIqWJEpKz?=
 =?us-ascii?Q?6pXg9Y++XIuovN5MY6xAlezDWAIjMyDtiQPMqlpgjZGxPJKSpIcHd91VzCP6?=
 =?us-ascii?Q?V8Ku5peOUOJpXYLVAFqF7xNUaDdIw9b64IwGIKbl6awmqHyObeAawohuosLw?=
 =?us-ascii?Q?bRsHoqy476+MKXwLv55VKtXOU4x+MNABUHvBZq/dOTSuN3iGlie52+Lj6rsT?=
 =?us-ascii?Q?JxHNkrM8322NHABHg4DihmaWilkMHjEduSfcKcMdKqLZb1pvg1NXDDwL+b83?=
 =?us-ascii?Q?6+bVDOPL1qq/WFz4sFefSjnW2G8VYZYsngYWt4nE581vvRsIZfW6BSf9vhEw?=
 =?us-ascii?Q?k06MPiEoCXeaJylF+0krheZ2LCjKw6xixBmdLHj5hfh4pTwy2XlCehPmuiGs?=
 =?us-ascii?Q?I9n08RMAJLYoow5Arjy0am9AiFwhZ7rxMngxF5CTbRodbnM+QDqfDWrxd/vg?=
 =?us-ascii?Q?wfA1P1m8IvXMG+qaGRcydlRONRHekvSI78WuxdPjl3E8lUayDOb7HgPcxVrW?=
 =?us-ascii?Q?GmIXDKgezveopu6ZZNXKZ0pydJj4wZ0z9bEXxywGCdD0C+talMUWZI1pq+ny?=
 =?us-ascii?Q?SBhW9xh+3lhBMp3189my4pPfbnJXyhL1QhlzzMhGQx+C87cQxAFsU65Vdr9t?=
 =?us-ascii?Q?Gl3Gcq1ZiLgv1BPrB/YD3zoS?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0525d00-164f-4843-a7e3-08d95bd02360
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 07:26:15.5497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4h6m2ndYRNgpikaDQicMtT9qSGVyU0ZrTr7ySNrZeJfNtr/cw2kYc3jIxeO3Q7/ce2RwZ2iqFXKABvWV9wkbCDNttixXus4da6aMymQmxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3246
X-MDID: 1628580377-4XkBUZGjySIC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 10:12:21AM +0300, Leon Romanovsky wrote:
> On Tue, Aug 10, 2021 at 06:49:43AM +0000, Lahav Schlesinger wrote:
> > Currently there's support for filtering neighbours/links for interfaces
> > which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> > attributes).
> >
> > This patch adds support for filtering interfaces/neighbours dump for
> > interfaces that *don't* have a master.
> >
>
> .....
>
> > I have a patch for iproute2 ready for adding this support in userspace.
> >
> > v2 -> v3
> >  - Change the way 'master' is checked for being non NULL
> > v1 -> v2
> >  - Change from filtering just for non VRF slaves to non slaves at all
> >
>
> The above lines don't belong to commit message. Please put them under "---"
>
> Thanks
>

Oops, sorry about that!

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
> > index b963d6b02c4f..2d5bc3a75fae 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -2528,6 +2528,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
> >  		return false;
> >
> >  	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
> > +
> > +	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
> > +	 * invalid value for ifindex to denote "no master".
> > +	 */
> > +	if (master_idx == -1)
> > +		return !!master;
> > +
> >  	if (!master || master->ifindex != master_idx)
> >  		return true;
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index 7c9d32cfe607..2dcf1c084b20 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1959,6 +1959,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
> >  		return false;
> >
> >  	master = netdev_master_upper_dev_get(dev);
> > +
> > +	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
> > +	 * another invalid value for ifindex to denote "no master".
> > +	 */
> > +	if (master_idx == -1)
> > +		return !!master;
> > +
> >  	if (!master || master->ifindex != master_idx)
> >  		return true;
> >
> > --
> > 2.25.1
> >
