Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49853DE6DF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 08:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhHCGrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 02:47:53 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:22632 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231386AbhHCGrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 02:47:52 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EF6664C0027;
        Tue,  3 Aug 2021 06:47:39 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtfx67A0JIrbWEIQqXuWK71G79TiH3uJINARyoVZOiNO0bNHE+N3BogKAaJ/q8sCqsLkysCtyAPH40JbV2Js9ZzJCqv4mWArdq2XZTjJ7zhrP7vBfUGvOFpGUpIB8AF7315Gwqz5Z7JWYPs5s5O+xcQqG+5aeWXIbReQ+ZRK1hbSHACBc13/t8L9fWIIk2N0OrhtaB5IRA3j3uij6y0p6pW7zDhvwBY0Se0ZOaw+ehVQVpoGun4zVcTgsmphEcUv/DlPPK7A/JONKrlsWnnkpPohzavMAsSMGGjtBRaqOHk5HiAWT/x5LzT+mfTceNtZGicMwXG5/68My/2nyuSHuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QEB7cn8o+bJb6j6Wp2cykGx8kQhdK2Ei0CmpZ+IcOY=;
 b=A2mqi998E0v8mT4dY69e7WRL8t/uKV2PY8yVYbQdlwkhOfOsaOZ+HMYae1qQJ4ROgaXGCVbU/mT220Kuw7eYcme3zIDL4fm7BuPl/YRg3rByoew61yH6UmB4tJz6xtvJwkWDgd00go9stzk5D3BqQavv0aQtFNi7kcKZqu6zua9C4+ssveK7Yc/BYtwyCGAmZqcP4Sg0XPj2hyZAuu0sUzsb8cgdZQtvzelSvwnw+sZwtNggraKHYnRFDZjX7NqmFOGLipDMOPxko0ZqRuoymXjEw6bIXIcYrFp6+2eWVa1Ve7YQgrtF9pJOvt8fOkX0uzyDFUZc4ZCF87il52d/aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QEB7cn8o+bJb6j6Wp2cykGx8kQhdK2Ei0CmpZ+IcOY=;
 b=KyHTho4Ev3vtFCye6PEyH9VMzRVyeRgBptJC5YEzW6hE+qMmfHlEx4Q6kCv2wndW0ButEgZrgQDBNuNJCq1yd15jC0d6f0S5+xIFJfzSqk7i3WHsc0INFItEBDVh4+HtkC7hueWPeHg35NkAKj5wHWK7GCymworbcTXEGnnX3VI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB4157.eurprd08.prod.outlook.com (2603:10a6:803:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 06:47:37 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 06:47:37 +0000
Date:   Tue, 3 Aug 2021 09:47:31 +0300
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org
Subject: Re: [PATCH] neigh: Support filtering neighbours for L3 slave
Message-ID: <20210803064730.pmkm7xesffzjscze@kgollan-pc>
References: <20210801090105.27595-1-lschlesinger@drivenets.com>
 <351cae13-8662-2f8f-dd8b-4127ead0ca2a@gmail.com>
 <20210802082310.wszqbydeqpxcgq2p@kgollan-pc>
 <6b3516da-0ba5-0bbf-8de1-e1232457a5aa@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b3516da-0ba5-0bbf-8de1-e1232457a5aa@gmail.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::21) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kgollan-pc (199.203.244.232) by AM4P190CA0011.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 06:47:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dde3ca9-1937-4761-29b2-08d9564a948e
X-MS-TrafficTypeDiagnostic: VI1PR08MB4157:
X-Microsoft-Antispam-PRVS: <VI1PR08MB415766160772C898FF347060CCF09@VI1PR08MB4157.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0V+7dsX/+KY38rc42nQD+AqOqELPhzZxjP52tf8mOYJU7lc7WnrzdNzBIy5oaobpiz2ep171JSmAlu4d5o+9GoXcY6HJXxeJ13AfqGic45lbFAILHmVmnawkG42jxs7ulGCUZ+Y7MrTOtXiz6yS0FTSxOq8b/hzGosl/agCrmieABSuyBtBzB9tqe7960Dkd96+U+deVcABePqBEjnB1RIsl5gESfSgdBfBzlxDw3s1Ud+j/f8VzAUkGyEsMxBSLU1OIiKhtD1T0FUItTuxP1TDmubuwLla99zkR//tgwPOFXOhYjNsi14sRXUFE1J51GQVbHeUVnzKf5UyE3w8wz/ZQqP7IXjxNG0cMW/4cL95v/uv1SEwBg7EHOiUZzlbmsi4NiblyxYavhYMNPKvw259TqfHm5rNHONbKKW59ef/doFIF6xploRxXFyD36qtMOPIz4zI3GGFquzOXyopHVS+L+0rDD3aNqxh/E5Ddp5fFEwSorazXmPxPRCw5fUaTsZiNuFE0iFXNgA4iFaqWsEIdZcmnr8glahI5XN7wrD3WTbil6S+bhb5Dl3Xnf/W3C2+Ig/Wnnls08mpGxoVbn5SgvueB+IYs7e6+1dvx5TJC98EPox3pNYiBj0NyCkp2WHRijfG6W6CVzeOkTZbLLb02/1rtleK0VRlDe52JyvvG+kEwuEe+HRsE/Le4TGhBR2KNs/xz0fFCnXiSmlhnDFCPJLxw51tsmlsnyujqCTY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(396003)(39840400004)(33716001)(26005)(186003)(1076003)(9686003)(86362001)(55016002)(478600001)(83380400001)(6666004)(4326008)(52116002)(2906002)(38100700002)(38350700002)(6496006)(66946007)(66476007)(8936002)(66556008)(8676002)(956004)(53546011)(316002)(6916009)(5660300002)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WSxROlXJQR5N4CXsoRyvJyT2wRo3uCqfnvrfGr8QDQ4eB9kLkhMb/iIf2biS?=
 =?us-ascii?Q?uQhnY749u7Gir0tABu1QHGfp6VXrjoC+QguKLnz/NMfEp+t4kyQls21BuMul?=
 =?us-ascii?Q?UBgi1j+sxYPzJ/YxF13dp7mMgWc1X/HULUf+uACmp+zCWi5SW/N4aIWNBKTp?=
 =?us-ascii?Q?WUq/SGneOG042Nda5OQVwShxgC38irQcj64s395VUjcDaPjbAhXArDbiMcrz?=
 =?us-ascii?Q?avivaz9Fn7r2yrHI07vw3dVO//n0WDOMeBFGXwuyY7NoxQCl5UoYDrzjPlGP?=
 =?us-ascii?Q?pNLNPKXMN8/hmLl498pCH6PT9q1cTSmU1gBPNOeIxPNMVVZCm/78CdBMm2wt?=
 =?us-ascii?Q?J+OTWYAcahaMBu4DrRphK0Pke1Y/w04e1RBpabIOalJZ2fmWspFcPXICNAXS?=
 =?us-ascii?Q?DcrS6hgN+hYDdCOO7b5tz09/qYwtiRqI0Vy/4BbFqipLFeZbNMxQINyruwFT?=
 =?us-ascii?Q?llS56Qm9PY6qaAVkHs+9OXtUTX+SuTopuoiFNQ+9GJGy1zHzeapcRkCHyFk1?=
 =?us-ascii?Q?qf0JdiiUJkumcKFLk/zEW5HvC0zFjZCr6Y2797hUi6yyQD8rVCw7PKlMBGli?=
 =?us-ascii?Q?rZgloD5ZFH5oRSFaYhj7oyHHWcKnvkT4+4JwMjjhc+5Eogb1/bjFEI7nwXua?=
 =?us-ascii?Q?xbxvYrIjQhi+QKOtQaXlJvn9mYb81+XTLC6DD9lLKd8tlNQDzPjMzbVzU0hL?=
 =?us-ascii?Q?g69joAeCOOZO1jfsVLxtG9T4Z4DNMwRwlWMPnF6je5veN82pki87Ib5+jEL3?=
 =?us-ascii?Q?tgzfTJ8d8EByIbgoSC0zZ7bVUikDtskZuc6a6fw9u9W92Fi2U5kYstszQ3F7?=
 =?us-ascii?Q?ypekhAcubu1Xj7fa2JqK8TTPy+XTkwXz1m7I+eC02i4zJ+nMEDSf5MqMowla?=
 =?us-ascii?Q?OVhHI5tuEPdatz7OHPfltq2QEPNgqbChf7suQM2pNlaiJIN/q7JZ+qMTnZMO?=
 =?us-ascii?Q?yfbkn4fGZguBfs+vOBBiGsKgzBKV1KE2qJCjqnwPwJZ1/h9AYn5q6wSV69i4?=
 =?us-ascii?Q?kpN+ip21pzXGYgWrHf06ul8kZJVzlNJ9lW5wGg5HuzsYPcI/hlKyr7fMbwYo?=
 =?us-ascii?Q?5P+MxkdOKERRqlsiYjX5oUD1pZxJ12T5PLXoQn27EhqGc8v959p9BixQKw62?=
 =?us-ascii?Q?VzO6Jp2TIYn7b8tiqHZ6toMIRpFLLnhBKLuL2uV8eaAl8UvpqeUBqUioO6eI?=
 =?us-ascii?Q?rt5n8ukrNRZSjGRt+dOvsOAG4/vudG9oHeSLxaHhlqOA784Q3L98p0f7xmQ8?=
 =?us-ascii?Q?cPHctaRZ4i0Zoql5PzIX4unuvNa0xzPfCEkjcNALBffb32rVUJc7OMid2krU?=
 =?us-ascii?Q?eqKdFHSiytJ6A9IxD7SLTXSb?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dde3ca9-1937-4761-29b2-08d9564a948e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 06:47:37.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /iJtEbYpDZpc6OfGaUZ9TYdtPmcKuCR15/qpsEcaZD/aaBG+QQ9mIZw5Fbniz1DRo3yCXwTudLNO6Xs+6C7gnaFYblFa803UR8LWKYKQIGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4157
X-MDID: 1627973260-yYyQ-sDeeL6B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 09:51:29PM -0600, David Ahern wrote:
> On 8/2/21 2:23 AM, Lahav Schlesinger wrote:
> > On Sun, Aug 01, 2021 at 11:50:16AM -0600, David Ahern wrote:
> >> On 8/1/21 3:01 AM, Lahav Schlesinger wrote:
> >>> Currently there's support for filtering neighbours for interfaces which
> >>> are in a specific VRF (passing the VRF interface in 'NDA_MASTER'), but
> >>> there's not support for filtering interfaces which are not in an L3
> >>> domain (the "default VRF").
> >>>
> >>> This means userspace is unable to show/flush neighbours in the default VRF
> >>> (in contrast to a "real" VRF - Using "ip neigh show vrf <vrf_dev>").
> >>>
> >>> Therefore for userspace to be able to do so, it must manually iterate
> >>> over all the interfaces, check each one if it's in the default VRF, and
> >>> if so send the matching flush/show message.
> >>>
> >>> This patch adds the ability to do so easily, by passing a dummy value as
> >>> the 'NDA_MASTER' ('NDV_NOT_L3_SLAVE').
> >>> Note that 'NDV_NOT_L3_SLAVE' is a negative number, meaning it is not a valid
> >>> ifindex, so it doesn't break existing programs.
> >>>
> >>> I have a patch for iproute2 ready for adding this support in userspace.
> >>>
> >>> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> >>> Cc: David S. Miller <davem@davemloft.net>
> >>> Cc: Jakub Kicinski <kuba@kernel.org>
> >>> Cc: David Ahern <dsahern@kernel.org>
> >>> ---
> >>>  include/uapi/linux/neighbour.h | 2 ++
> >>>  net/core/neighbour.c           | 3 +++
> >>>  2 files changed, 5 insertions(+)
> >>>
> >>> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> >>> index dc8b72201f6c..d4f4c2189c63 100644
> >>> --- a/include/uapi/linux/neighbour.h
> >>> +++ b/include/uapi/linux/neighbour.h
> >>> @@ -196,4 +196,6 @@ enum {
> >>>  };
> >>>  #define NFEA_MAX (__NFEA_MAX - 1)
> >>>
> >>> +#define NDV_NOT_L3_SLAVE	(-10)
> >>> +
> >>>  #endif
> >>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> >>> index 53e85c70c6e5..b280103b6806 100644
> >>> --- a/net/core/neighbour.c
> >>> +++ b/net/core/neighbour.c
> >>> @@ -2529,6 +2529,9 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
> >>>  {
> >>>  	struct net_device *master;
> >>>
> >>> +	if (master_idx == NDV_NOT_L3_SLAVE)
> >>> +		return netif_is_l3_slave(dev);
> >>> +
> >>>  	if (!master_idx)
> >>>  		return false;
> >>>
> >>>
> >>
> >> you can not special case VRFs like this, and such a feature should apply
> >> to links and addresses as well.
> >
> > Understandable, I'll change it.
> > In this case though, how would you advice to efficiently filter
> > neighbours for interfaces in the default VRF in userspace (without
> > quering the master of every interface that is being dumped)?
> > I reckoned that because there's support in iproute2 for filtering based
> > on a specific VRF, filtering for the default VRF is a natural extension
>
> iproute2 has support for a link database (ll_cache). You would basically
> have to expand the cache to track any master device a link is associated
> with and then fill the cache with a link dump first. It's expensive at
> scale; the "no stats" filter helps a bit.
>
> This is the reason for kernel side filtering on primary attributes
> (coarse grain filtering at reasonable cost).
>

Nice, didn't know about the ll_cache.
Does filtering based on being in the default VRF is something you think
can be merged into iproute2 (say with "novrf" keyword, following the "nomaster"
convention below - e.g. "ip link show novrf")?
If so I'll add it as a patch to iproute2.

> >
> >>
> >> One idea is to pass "*_MASTER" as -1 (use "none" keyword for iproute2)
> >> and then update kernel side to only return entries if the corresponding
> >> device is not enslaved to another device. Unfortunately since I did not
> >> check that _MASTER was non-zero in the current code, we can not use 0 as
> >> a valid flag for "not enslaved". Be sure to document why -1 is used.
> >
> > Do you mean the command will look like "ip link show master none"?
> > If so, wouldn't this cause an ambiguity if an interface names "none" is present?
> >
>
> You could always detect "none" as a valid device name and error out or
> use "nomaster" as a way to say "show all devices not enslaved to a
> bridge or VRF.

I think "nomaster" sounds reasonable, especially since it's already has
a meaning with "ip link set".
