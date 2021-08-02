Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37043DD1DB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhHBIXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:23:30 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:23120 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232562AbhHBIX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:23:29 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 094C66C0067;
        Mon,  2 Aug 2021 08:23:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBaGd4UQc29jxm+hPRTt4DBPvzqCGamK+nlsrjKln6arkxE3ksX9wrdDmYrePO5hlE7Migxq4moPTK5+vxsBDLw3EO4dq+ksoqKhv1kGTc0TbkOwbi0xgvzyr1aLBjkTGhVbzkkGq1rwddnLgseVHs5NcwwtsRp7WziCNZ68yBWzP+Q5z7ejPsNme4fqHkbsAGiPKQT8RgBoe5evHUlaptLSSOoQ/CLv+T6dvxNK/vxqEbtNzsDMs33BhU62hbXT6dy/2mY4wtC4Wz+mVrv+RoTOQLna7jkTTcAjQTIIqFTzBO+Rd1Z8f6nXP5UpxzdgQG71/PKTx8pJQUSLkzbeNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ANa/Ush2zBubXR/f27mszvclPdRZMNSucHSOU7fDME=;
 b=A34BVytX5OIvuOpl1wlyYiVvHf5rqN2KpvytcRn6btPIpNhPlB6TlPaNNlmySSlGhM3DSbLGfAncCkTcgmF+ju0R7TGtSb+/ejJ4555fC9Ti01yxjFjWncsR907g3H6pjlbB0PvhkckOizNPbEPDEcmR4Sou55LTRJ4sNL3vgWDKptchqnjVDvSjax8RSBOJzXf2Oe064A6hRhHy5bVLAnsHrdxE/2SXQGrrKCt99H/nHujadQ0z5ZAPlATMyK+MIgAJIADX6YRCt1iDk4i4uXwrqeARdGCke/vZubaEmeBZMMalgQtHZlkpeJ7eOZ/BrqYc3WSe9l6CgNkC9FzQSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ANa/Ush2zBubXR/f27mszvclPdRZMNSucHSOU7fDME=;
 b=m6dS7mXlNrjRoQlDG2LqLpYurH4BdFxUBVeopQIfG7KgWB9ErzazgdOhvLD0QKgJ7zQZPs3pQUFLuTrrnRdUnOCT12QRuklV+NbkFZGK/MtDoaWupM5rjMa2r7em0BEwc7EGYMr92xuGBFlNi21WnD58ZiXNc3Fovz7Dm7T51f0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB5502.eurprd08.prod.outlook.com (2603:10a6:803:12f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Mon, 2 Aug
 2021 08:23:16 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:23:16 +0000
Date:   Mon, 2 Aug 2021 11:23:11 +0300
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org
Subject: Re: [PATCH] neigh: Support filtering neighbours for L3 slave
Message-ID: <20210802082310.wszqbydeqpxcgq2p@kgollan-pc>
References: <20210801090105.27595-1-lschlesinger@drivenets.com>
 <351cae13-8662-2f8f-dd8b-4127ead0ca2a@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <351cae13-8662-2f8f-dd8b-4127ead0ca2a@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM0PR06CA0113.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::18) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc (82.166.105.36) by AM0PR06CA0113.eurprd06.prod.outlook.com (2603:10a6:208:ab::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Mon, 2 Aug 2021 08:23:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da2466bd-429f-48f3-358b-08d9558ec72d
X-MS-TrafficTypeDiagnostic: VI1PR08MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR08MB550248E836B70ABC803AF73DCCEF9@VI1PR08MB5502.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2W3OOUzSEExhM5YTA8GRqU9WDgOh3srqRhQwSYty3OVlXxvdQ5UsWAsgPAvZOqxDZglZqZTh8i+ITGfCYbx+BYGsImiLeZFYKTUrPEFW4wz7cNyJh9hEwwT6qZ7HqfC1/KvPY9jbzDh+oByARHjb+HxLnBzQMt9khl4xe6Kl6tHp2QerMigDj66deZTEntde0dg8wc9h61OelgP/l4DUdDFbixO1HB+zSPS//lgQ80vhtyxbAych37D1TYLyPc3OPalmAbJmX80BW8DP5oCWSo1oAjbe5jMNj9f91SLH8j/+pptG1ncLJQAqS67Bx3KEc4J0KcJ0PDTt/ricIezIOsRtGkhaCnN5ZpOru+/OOf2BNsF4TYbtdEMosXgNAMqa5s1H6JdLZG3uKXHjscgi+fbQ7wlutuN/fpf8ONCKEVmHgcO63RCveWFLd7JDA0MfHbEQA2yq4PO/go3ePGoWrtP/u85Y0cHI7R78GpSlMQVK5p/gxWVRYze5NP4W/Z4zagZZuFbEw7Py+WQwzYDTUvwppPH7xV1l7RGCZ4/jwu47L7BRlIU/OBEgfmKRS3VrGTkW+B7xYcoaXD7ddqOLBGfFK5DsGS8I8kZ7Mo3xQdUTsRaslUsY8dtz0t8TLuJApTa83PGvc6s+o9G9P3ECAEc256wpzV6YQ+ZkMx0yB7lYq7Vcp0RCHu0AF5jGeZ4SWUamD9Y6AzF7+xkSrjKUd3R2dZTOBpmQKJw9gLvlRO0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(26005)(8676002)(8936002)(33716001)(4326008)(186003)(52116002)(55016002)(6916009)(6496006)(508600001)(86362001)(53546011)(2906002)(66946007)(66476007)(38100700002)(38350700002)(956004)(5660300002)(83380400001)(6666004)(66556008)(1076003)(9686003)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?suoaw6oEtTsjtzMqVQMwovaJwLTVhQXwGZ0Tuzp4YRFFGpOAHx4Ip6Nfo2KP?=
 =?us-ascii?Q?iKLNLyCB9+WtB7CGMTwksUCp0coObLG9flU97WWteKHp0WnToD/V/vLct4zg?=
 =?us-ascii?Q?q0GX/AJzmKF4HB/0Bh0HlouGJ0RM8Qrx0Hkxz1sMPjQNkgTc/y3hfue6UNpE?=
 =?us-ascii?Q?31b6f17CiAU0hG1BUY0pYhQVhWgkf/IXAW2tHfwANU0zNGwHJTE1XFuE+H0p?=
 =?us-ascii?Q?VEO8zXDNv0WlN3Nk2+R+sKdWFdyLnfvLqn1g4QfbQAp8kH1C35Hn3vjb5iRF?=
 =?us-ascii?Q?X0zzFebwFVwQSK0c9yV/XLxlqzvyNNuKiyD+buujuj7MNJMHDe8Bol01zUL6?=
 =?us-ascii?Q?7jBtK0TqBFseyz3YuU0yuLmlwSOtjDkBM9oGpqSa95z11MBbm55LMjJm+0DJ?=
 =?us-ascii?Q?qlrEOH9KblMnfERvwtPnYMIJrlvKjBGzBu9gusqaepmj+nzl+SayMh1aeDjk?=
 =?us-ascii?Q?65UvEQg4BfGUwhYZmz+Gux8QODtWsKI23DIKCb39cMxXLCJGDWvvYsIsBaEo?=
 =?us-ascii?Q?/mJ1GSr+Doj1IvBNRkPiJVFft+oYLkQuuz9G41DImBF4qyPeOzL2Q+Ro1R7F?=
 =?us-ascii?Q?J/0Bsi1CuHF3B5ZXpScZzHRCDdFI11gDy3Kjk00nfv5wZYMW4qOJP3j5sH6u?=
 =?us-ascii?Q?0TVJTH/UDBRDUcqwSipOlx6yyLwmBDFavaOG2aF38//aWT/6gXlZDcbXj5Ly?=
 =?us-ascii?Q?21Bu6f0DtHMyxAx34aD+VWZ5jTsEeTtn73kIr6Mc5VexlK8+aDuMdzFsSvTe?=
 =?us-ascii?Q?Cjkdubyh20IIXJJNdQKaaBBkYvpf7e6rMSJ6qQPhKATb+DGApQYbpbg5d0/v?=
 =?us-ascii?Q?Nf7OLWzPL1pE+MulELMHbDyIhZhVIVE86rqzSvlnI2Yy/2diVXiaXwDqp7XK?=
 =?us-ascii?Q?zP0eV52411j/CPHufVoys0mSCN7Hqx6/6FcQvCctgq4UYOrTM32GvXJ7gON1?=
 =?us-ascii?Q?doIP65Vdgk3InDNNnhBEDXWaoWweC0Ou31RPcflCKM6QUL7OAmERPKnWC/Gb?=
 =?us-ascii?Q?IO0Z8TOzj4PMrvd5pWhd8rn1fhHTASRQEu3n6W8DOAMw50OBnFPHsWr+PZ6v?=
 =?us-ascii?Q?oKfQmu6itMXqbo1QGwRiJ3nIzwtF3p83OSh5I+rsJBAwBIEAYBoEWN+bnuZi?=
 =?us-ascii?Q?jU9jq90h0RyPbBPjYOmfLZvmQj0aYajJ13X1PrkLmwb8Yk96QGVLOtDbY+6O?=
 =?us-ascii?Q?USj52J0NMvvrY/1cNFaJA8+nVxUTrBBg7dJ8rD2KNYSkCanQhijpPCFeGuhy?=
 =?us-ascii?Q?3t1kLTz8v4mtMxrCZoXyFIPd5FQ1Vx4AtJ4wt1e/JYgef8VQKAHdlSa/rhWy?=
 =?us-ascii?Q?lAH3WzjeepUIBVCHAAaVwJ+6?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2466bd-429f-48f3-358b-08d9558ec72d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:23:16.6560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ccgqXU5OILfiRSWUCjEVOG8TqzEnbf5Z5+t3CT1YE8m2XKeiwdrisOF7KuJhaY9MCBUmU9Twuvtk+JwUBEFCQBGcdXVPblGA4DN7Tb0TTAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5502
X-MDID: 1627892598-kzCjFCV1M4-Z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 11:50:16AM -0600, David Ahern wrote:
> On 8/1/21 3:01 AM, Lahav Schlesinger wrote:
> > Currently there's support for filtering neighbours for interfaces which
> > are in a specific VRF (passing the VRF interface in 'NDA_MASTER'), but
> > there's not support for filtering interfaces which are not in an L3
> > domain (the "default VRF").
> >
> > This means userspace is unable to show/flush neighbours in the default VRF
> > (in contrast to a "real" VRF - Using "ip neigh show vrf <vrf_dev>").
> >
> > Therefore for userspace to be able to do so, it must manually iterate
> > over all the interfaces, check each one if it's in the default VRF, and
> > if so send the matching flush/show message.
> >
> > This patch adds the ability to do so easily, by passing a dummy value as
> > the 'NDA_MASTER' ('NDV_NOT_L3_SLAVE').
> > Note that 'NDV_NOT_L3_SLAVE' is a negative number, meaning it is not a valid
> > ifindex, so it doesn't break existing programs.
> >
> > I have a patch for iproute2 ready for adding this support in userspace.
> >
> > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > ---
> >  include/uapi/linux/neighbour.h | 2 ++
> >  net/core/neighbour.c           | 3 +++
> >  2 files changed, 5 insertions(+)
> >
> > diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> > index dc8b72201f6c..d4f4c2189c63 100644
> > --- a/include/uapi/linux/neighbour.h
> > +++ b/include/uapi/linux/neighbour.h
> > @@ -196,4 +196,6 @@ enum {
> >  };
> >  #define NFEA_MAX (__NFEA_MAX - 1)
> >
> > +#define NDV_NOT_L3_SLAVE	(-10)
> > +
> >  #endif
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 53e85c70c6e5..b280103b6806 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -2529,6 +2529,9 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
> >  {
> >  	struct net_device *master;
> >
> > +	if (master_idx == NDV_NOT_L3_SLAVE)
> > +		return netif_is_l3_slave(dev);
> > +
> >  	if (!master_idx)
> >  		return false;
> >
> >
>
> you can not special case VRFs like this, and such a feature should apply
> to links and addresses as well.

Understandable, I'll change it.
In this case though, how would you advice to efficiently filter
neighbours for interfaces in the default VRF in userspace (without
quering the master of every interface that is being dumped)?
I reckoned that because there's support in iproute2 for filtering based
on a specific VRF, filtering for the default VRF is a natural extension

>
> One idea is to pass "*_MASTER" as -1 (use "none" keyword for iproute2)
> and then update kernel side to only return entries if the corresponding
> device is not enslaved to another device. Unfortunately since I did not
> check that _MASTER was non-zero in the current code, we can not use 0 as
> a valid flag for "not enslaved". Be sure to document why -1 is used.

Do you mean the command will look like "ip link show master none"?
If so, wouldn't this cause an ambiguity if an interface names "none" is present?
