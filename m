Return-Path: <netdev+bounces-1957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B1C6FFB80
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01772280AAD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0823B12B74;
	Thu, 11 May 2023 20:54:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB386FD3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:54:43 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2069.outbound.protection.outlook.com [40.107.6.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E884C12
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqOAANIUdctgIBJiOBJQP43Sx0EG4vzEDvhyNv5tqYiYoBgQwOgOirmz8DYuoQJWZFm+ganujZeIegNQmz8UrYw7e6FC7QDGIPKEAvXS3R8rnEKu3ySA3IBKt6DGyd4+eLEwOP/OXUMke2qUWM7yHtM2zcEmR2jAKb3Pzy2wq2t6yhX2N5m3ABSvwY6S9kcleqgK6N/2hdUuKNqWxxsV1kV6JFSTtw7IKsv07sHtp26YuIaqzQ94pSndIL8Mvl5w39Ng293Mlxp6D4QCsaMjWo5asTrd3ZuR97Q+KQ3GSI8wINaXYQAgGucJLWtB1D+0g/CqvfmzGjyGk8Ye3f4/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhPvLRLfDwkRoQtOfAodfEGEWmp9lT+SPBRW0jhHt/c=;
 b=IdexnYfo4GbVk71uAeCWn4viqhQlxa2HajlTyLh8HI+rrjMb0pM9IhyGbE70rfWMdxwzsZtr7dPhZdR4zKkj3orxsRW5/yqYbnCxXQC2bU4ibVCu1tL5WRNNkHRYiTUazMS9K+zzoSwKXPeORzQsWKEOnb0tRdfPCB8wAx35+lreLb/erLxZ8pVZkdHWeHK7XMmgQBI8HGTmaUJbUYA2pPiss1EG1SX0vnzYY3LLdiM+1e7FaaY3nDgVirAFfHpM5oIqsQ9Q4jlXK8lDswKOzpIeGxPIrNUX4Ic4lSfhvvkMs5GWJM1JM5KKN/2ADhVLZdz7eB5sub0JHXW4Q7a4tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhPvLRLfDwkRoQtOfAodfEGEWmp9lT+SPBRW0jhHt/c=;
 b=O9JGqNAa46yjMnVs4JOeGGpWtK/yWJCaUBpMZlodU/CC7fKeGhxxm/YgTPmnjiDnGJTjDFZ5RAzP+nklXwoPpm7ZR5TTTMSYV+yqvPrvtgDQfzbWyxdNgaHMKpZXEvYW8pyhCjNzN6viGly2YN0Oans9ILvFREPV+4OIFHkvJIw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB9461.eurprd04.prod.outlook.com (2603:10a6:102:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 20:54:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:54:38 +0000
Date: Thu, 11 May 2023 23:54:35 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511205435.pu6dwhkdnpcdu3v2@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230406173308.401924-5-kory.maincent@bootlin.com>
 <20230429175807.wf3zhjbpa4swupzc@skbuf>
 <20230502130525.02ade4a8@kmaincent-XPS-13-7390>
 <20230511134807.v4u3ofn6jvgphqco@skbuf>
 <20230511083620.15203ebe@kernel.org>
 <20230511155640.3nqanqpczz5xwxae@skbuf>
 <20230511092539.5bbc7c6a@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511092539.5bbc7c6a@kernel.org>
X-ClientProxiedBy: BE1P281CA0263.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:86::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: 28f2a1f8-4bdf-4cb9-790d-08db5261ef33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xZD5RSPPU//goNo4HCVwQJBrh0rJ4Uax3MqalNh+7xSRgjRn2SsHpu7YcYmwLDOJw7lcE4vB93a414nTBDhY3ZQO6DdZKVyi097IovknAQ5WpPNxvdmISp1oT9+GHJ/9pr94z4wmZ74RmApaCOs1xall7ZgSyzdXUGPvMIKkSeddilVs6ZuCSOgNOtrxkGI2sOC+icNGzdIHkb3vRixhn3fU39KTGOVJdveuHlP+o37VeIMlyyFvXK/NwezMjycCRJoVr3NNG1WRt7PJYp9ollAVNoaRSf7NHzD4xYu3L0+489w6wEAmB1dgJoGhOVW18Nj6cnPLRCE/dPztwktZzlYlYMtJ+xaRKFMzh9zTeuu3FyaCsUfBj4nq/6pIU6eyCb2deFpmRDE0JeNa4ZTzLYW6kNEehTDAXkjiQP6X+h/k1deq5+P7tiifkOHwZCBkeOtU2q+BRmrTGSNTeab+0RHEJLEZDqb9QaPlvDNgjF5RvF95leYRqQoNZoPrCORLJVK9mXVGaHoA3dCGvt7+E5lEpZHe04Ro3IFW0WnV+vA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(6666004)(6486002)(8676002)(966005)(66556008)(66476007)(6916009)(33716001)(2906002)(4326008)(7416002)(44832011)(66946007)(8936002)(41300700001)(86362001)(38100700002)(316002)(5660300002)(478600001)(186003)(6506007)(1076003)(6512007)(9686003)(66574015)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Uavl3WCJACwze0uTiL01xUkoe471skJhhe2uFOoZUrxlkVHjxW+iAsBoXp?=
 =?iso-8859-1?Q?pfOjE6tFmk95jcUcnXikm7Oj/KyD8mGG+Ll+f9DibCGOIPJGMot471UO38?=
 =?iso-8859-1?Q?V5oVTDFmabKzC8N40KXp6w98i4xUSRmgHxp83qHGCfwnx6aePmyUDuCoFu?=
 =?iso-8859-1?Q?ABZkSLPJXWXx4QYe/jpL/Otbk6aBbRw7FNtVKWiNqOTGZYJQAaWtllqytF?=
 =?iso-8859-1?Q?MHe3HE1l/pN+IHgL1OT8NPwzu1PHPnx3kqRw0uHXVYxwWtrNRvLiA4rfzm?=
 =?iso-8859-1?Q?/ithfmYE1cZjTOTQJ1EhOjJyQjSL3KCjj7uchkOWzVd8mED6VL4tngq2ws?=
 =?iso-8859-1?Q?qol13IWeNOQQ4J3lQEQrnr+n01U0OwITYEIr6uGzx+2iktSbzEBrG97LAg?=
 =?iso-8859-1?Q?MMQLI3vV8ULaQVxEdUye3Mnb26SqiHOJJYwB4Llah3ve57T+yKo4qoNAj+?=
 =?iso-8859-1?Q?m/ROnash/BLc4DZsvxjIvJ+hVaVFA11ONh7MwY6QyGmM9j2cAzXlpyZVqm?=
 =?iso-8859-1?Q?R3sMi11ShSVXKCBtlBnc80d9qdSvEnsUW4V/QEw55rz7M/TspBvSn/QY/s?=
 =?iso-8859-1?Q?3rA4gQloDO/rUJaMAriRX5cw+45H2fXz1amHrIpAhgCrdmq3ojPmpLe4yQ?=
 =?iso-8859-1?Q?yfTwZnOpZ4g4geey2inY5xaEGwGUOo9H8xwWRR5yyyk3UQycnsvBoxyvOt?=
 =?iso-8859-1?Q?mFrKAxt4A516022tfHfGcl4Y1sKxiy4Mo7m7iA4Ib+ovwQ61BRTAUSrCSN?=
 =?iso-8859-1?Q?fESQ4uNTuVVPFk3uVr2TXyZSnAHNy8LhsHQB4AA46UsLXKYP2PeSwczVYu?=
 =?iso-8859-1?Q?OXZRdzv8aZHuaEMVSa6QOdoGedaIjdFwGV0txSaU2aEZV5NvR6G0SENSpS?=
 =?iso-8859-1?Q?B82Yx3IRDo0CQ9eaEhdyoee97VABbE3QWJMPd0C6gYBSotKEICPrxLiGy/?=
 =?iso-8859-1?Q?hah1TywpWra8gWrrGmTDqYc8OSpm46wTSLexj7Jgry4vqGE0rrBagmjv3Q?=
 =?iso-8859-1?Q?k712II0TAIJxC4qGqHlyjcuwvULoqCAEj7NC5SorMmEyh2WegEL2KkGe0M?=
 =?iso-8859-1?Q?ZTELUkN2cpBik9i6VYrOg6fHqfDWJbjsU6XBiQoV4RhoYUb+C3wvkw720B?=
 =?iso-8859-1?Q?ADXBIW/PMyDp9TVNf8MB2xDrW0TTUueUUWiOp2LisDG1kDMFKmv+NItJQJ?=
 =?iso-8859-1?Q?JVn+S4/uiaAY3KEbdJGruTJjmKey0tzDexSoL5/oufIu8Kygsk3SB8L3UC?=
 =?iso-8859-1?Q?m3H1jm+/xdBYGiqZ4rqmYIGBkv+XS86+IGCSQ3e8k1b355eJundEpSorCZ?=
 =?iso-8859-1?Q?7TwQeyFFr91lHMM6rhJUu6xOYa1j4Ulo3kJIZ1qWwqPKKrVC7jArRKQkEt?=
 =?iso-8859-1?Q?/U5snTherY1X9tFMmTX9dGQxYq3WfiKnrvgzBfejVTBnLKhDx5js3+yopK?=
 =?iso-8859-1?Q?8HQmdKQfE1KyffjDew1MutijAGk9zKwBsQsXNqUOFMm7Og8jIZ80m3xRl5?=
 =?iso-8859-1?Q?5cKccjx72BPoBm1EAzif2XcmnAE8bZEbl7vc1oH+CiqSNWXKPnLQXQ+onU?=
 =?iso-8859-1?Q?1KDF1s39Sx7oboTtUAKU+4R56v2lW9qvQedflymidiWqJwnFzFGwe60u5G?=
 =?iso-8859-1?Q?QzAF+t+L2WVjnybdsypo66ITgx2xBlJBiLdvX1N3AkM9nTN+zN7CZB/Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f2a1f8-4bdf-4cb9-790d-08db5261ef33
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:54:38.2884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kx/4u8VBIyUoOAhW18Ppmx2kbzBl4KNScq+Sp2AttaczJaMLYAg9xMqXPuM14Cgc++I/5Q1e1cryEu7eeK0yDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9461
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 09:25:39AM -0700, Jakub Kicinski wrote:
> On Thu, 11 May 2023 18:56:40 +0300 Vladimir Oltean wrote:
> > > More importantly "monolithic" drivers have DMA/MAC/PHY all under 
> > > the NDO so assuming that SOF_PHY_TIMESTAMPING implies a phylib PHY
> > > is not going to work.
> > > 
> > > We need a more complex calling convention for the NDO.  
> > 
> > It's the first time I become aware of the issue of PHY timestamping in
> > monolithic drivers that don't use phylib, and it's actually a very good
> > point. I guess that input gives a clearer set of constraints for Köry to
> > design an API where the selected timestamping layer is maybe passed to
> > ndo_hwtstamp_set() and MAC drivers are obliged to look at it.
> > 
> > OTOH, a complaint about the current ndo_eth_ioctl() -> phy_mii_ioctl()
> > code path was that phylib PHY drivers need to have the explicit blessing
> > from the MAC driver in order to enable timestamping. This patch set
> > attempts to circumvent that, and you're basically saying that it shouldn't.
> 
> Yes, we don't want to lose the simplification benefit for the common
> cases.

While I'm all for simplification in general, let's not take that for
granted and see what it implies, first.

If the new default behavior for the common case is going to be to bypass
the MAC's ndo_hwtstamp_set(), then MAC drivers which didn't explicitly
allow phylib PHY timestamping will now do.

Let's group them into:

(A) MAC drivers where that is perfectly fine

(B) MAC drivers with forwarding offload, which would forward/flood PTP
    frames carrying PHY timestamps

(C) "solipsistic" MAC drivers which assume that any skb with
    SKBTX_HW_TSTAMP is a skb for *me* to timestamp

Going for the simplification would mean making sure that cases (B)
and (C) are well handled, and have a reasonable chance of not getting
reintroduced in the future.

For case (B) it would mean patching all existing switch drivers which
don't allow PHY timestamping to still not allow PHY timestamping, and
fixing those switch drivers which allow PHY timestamping but don't set
up traps (probably those weren't tested in a bridging configuration).

For case (C) it would mean scanning all MAC drivers for bugs akin to the
one fixed in commit c26a2c2ddc01 ("gianfar: Fix TX timestamping with a
stacked DSA driver"). I did that once, but it was years ago and I can't
guarantee what is the current state or that I didn't miss anything.
For example, I missed the minor fact that igc would count skbs
timestamped by a non-igc entity in its TX path as 'tx_hwtstamp_skipped'
packets, visible in ethtool -S:
https://lore.kernel.org/intel-wired-lan/20230504235233.1850428-2-vinicius.gomes@intel.com/

It has to be said that nowadays, Documentation/networking/timestamping.rst
does warn about stacked PHCs, and those who read will find it. Also,
ptp4l nowadays warns if there are multiple TX timestamps received for
the same skb, and that's a major user of this functionality. So I don't
mean to point this case out as a form of discouragement, but it is going
to be a bit of a roll of dice.


The alternative (ditching the simplification) is that someone still
has to code up the glue logic from ndo_hwtstamp_set() -> phy_mii_ioctl(),
and that presumes some minimal level of testing, which we are now
"simplifying" away.

The counter-argument against ditching the simplification is that DSA
is also vulnerable to the bugs from case (C), but as opposed to PHY
timestamping where currently MACs need to voluntarily pass the
phy_mii_ioctl() call themselves, MACs don't get to choose if they want
to act as DSA masters or not. That gives some more confidence that bugs
in this area might not be so common, and leaves just (B) a concern.

To analyze how common is the common case is a simple matter of counting
how many drivers among those with SIOCSHWTSTAMP implementations also
have some form of forwarding offload, OR, as you point out, how many
don't use phylib.

> I think we should make the "please call me for PHY requests" an opt in.
> 
> Annoyingly the "please call me for PHY/all requests" needs to be
> separate from "this MAC driver supports PHY timestamps". Because in
> your example the switch driver may not in fact implement PHY stamping,
> it just wants to know about the configuration.
> 
> So we need a bit somewhere (in ops? in some other struct? in output 
> of get_ts?) to let the driver declare that it wants to see all TS
> requests. (I've been using bits in ops, IDK if people find that
> repulsive or neat :))

It's either repulsive or neat, depending on the context.

Last time you suggested something like this in an ops structure was IIRC
something like whether "MAC Merge is supported". My objection was that
DSA has a common set of ops structures (dsa_slave_ethtool_ops,
dsa_slave_netdev_ops) behind which lie different switch families from
at least 13 vendors. A shared const ops structure is not an appropriate
means to communicate whether 13 switch vendors support a TSN MAC Merge
layer or not.

With declaring interest in all hardware timestamping requests in the
data path of a MAC, be they MAC-level requests or otherwise, it's a bit
different, because all DSA switches have one thing in common, which is
that they're switches, and that is relevant here. So I'm not opposed to
setting a bit in the ethtool ops structure, at least for DSA that could
work just fine.

> Then if bit is not set or NDO returns -EOPNOTSUPP for PHY requests we
> still try to call the PHY in the core?

Well, if there is no interest for special behavior from the MAC driver,
then I guess the memo is "yolo"...

But OTOH, if a macro-driver like DSA declares its interest in receiving
all timestamping requests, but then that particular DSA switch returns
-EOPNOTSUPP in the ndo_hwtstamp_set() handler, it would be silly for the
core to still "force the entry" and call phy_mii_ioctl() anyway - because
we know that's going to be broken.

So with "NDO returns -EOPNOTSUPP", I hope you don't mean *that* NDO
(ndo_hwtstamp_set()) but a previously unnamed one that serves the same
purpose as the capability bit - ndo_hey_are_you_interested_in_this_hwtstamp_request().
In that case, yes - with -EOPNOTSUPP we're back to "yolo".

> Separately the MAC driver needs to be able to report what stamping 
> it supports (DMA, MAC, PHY, as mentioned in reply to patch 2).

I'm a bit unclear on that - responded there.

