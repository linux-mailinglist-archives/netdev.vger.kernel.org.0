Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBCC67B2FD
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbjAYNKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjAYNK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:10:29 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2046.outbound.protection.outlook.com [40.107.20.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337794C0FB
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 05:10:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBJkF9+5o5hftZ+VFqPEtGIHgNiPjfSPg7us6aq/sakFRhn8Vq6mYdiGkt1rqbF0wEy9lN77+JwZMqtS2jFK+805euRH7g12Yd4w9KwtF0on2jPy4PGGliUs0f3QLBu/r8FzY7xtRHikYO1FYIcgEtzfDIIITdh6hlOcFfkJ45oZU8PAsD8UZPCCv7z24/mD2ksoqP07xsolxGKNXS7wuDaZOqLSM4xon1DQziwaTMlYuxVNK2uZqjikXC7VRUX5Hk9p63tIMU9CX6RjZRlCrC3+63OXIssWHb8AVMths6tUqKJIdIYdZ7YrpDCTQLhIIzQWbGSNTCRLGyYgIl5qQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sR3cQmklQwokta1KHGVSuJxhHnPA/zMmrHhI+JDq/hM=;
 b=dj3SnLwR3+4pp+o0HgKL2xzmObuafi5+q5xLdt/JEqwBmVxpu2yfdqUOztGu4WWCpou3GPre8zwC12x4spmkwubOIpxN+Y74+kdlqIo1eRlg/j5KTXMBVm7620OkLFukcYt6sKnS20L341DyC0ghPcoruEYr9qnykOfKMNh4ZT7vFmltWYsjQRqnRgNUfG34BvhJJj6LL+PsAvOktqv890Wtn8ya6PVpz2Z9KV0pVydM9XiL8sPjVfHtJMe+1aVEMtiOCsR3IZzwDrx2H5ZvSh5UfoBaWsZj+PepuVjSrqJ5r6+2cgD7OvYOC0NWdOAoRorpIky0aQUz5yIP+kFxwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sR3cQmklQwokta1KHGVSuJxhHnPA/zMmrHhI+JDq/hM=;
 b=OxW8pmjnrJa1tvq0sFOlRmPhc+UMmU9iHMg2kjveqeyXOeWr4k76f80mB7SfmBdgRbINyd2ddnGoag05f2Y4DsHASx2ZJER1lcun9lVicg+Eqkd8ufe8tV5Qt6iPy1Ovjsv+aFa+g7AgfnImtQR2odvthjWYIiafAyeHgXhbWWw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9244.eurprd04.prod.outlook.com (2603:10a6:20b:4e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 13:10:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 13:10:15 +0000
Date:   Wed, 25 Jan 2023 15:10:11 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Message-ID: <20230125131011.hs64czbvv6n3tojh@skbuf>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <87tu0fh0zi.fsf@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu0fh0zi.fsf@intel.com>
X-ClientProxiedBy: BE0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS4PR04MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: d8e848b0-874d-4a87-228e-08dafed57ffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8j7WfGLdBpqXy4t5087FvQDsDiWp+pYpl+stgX7N7SjBnWH8cbha9oqZpOSw5D3q+82Hzd9ul+P6ZKuPFMjsA6GaIVIdSp9lHLZLPE45ChYhgjROxxTfwRGnvutdiHHl9FgTpDZ5sHq45g1kZUv6B0ArsD+1MZ5ZDeive2jSKLSFDA/Dw1Orx2RjTgPrFSRlJ6aeXTIzM7xWfqJk2sjcOs3NF9apKbfQmZjVBaLSJFwnwja8mQCyPSlXhftJs6kjDPzMgFSp8SMTcdNsw+a5DKxi03oik78EQu31vXdFWhGsKw8QycMu5Iq7aEv2OnGCA3IM3l9sa6kepd8p5sRWZc9GfDmLo1UFvEuROFQnqLdrEyf00wLIojhOmTLMiWQFxj8v9ewGyMJavgHpaNOHPlQIpJmJqtp+67u3mhw3fqJqDIy3QVZi4wd/xKYKM8hId+TR08VLCMbsXF3fxPf9ZmzlrGOZ5/h3Tk0XxvtSzKorAoT9QFASepnnvLIZ7YKsj+2vc1dUXgyGIxBJO//ygYz+4x0PLtNV0a2hUJTHb3K4xMnnkGuhf/UJ8Rse0mqeDpiTMyMxqk006tVpzI+jTtHPoLctL2PSh9rR4VEEt+yAQwMWNyrHFR4b+Ak/8+p1XIV56Stb5T0O9LX6/6HTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199018)(5660300002)(186003)(316002)(2906002)(66946007)(6916009)(4326008)(66476007)(66556008)(8936002)(8676002)(41300700001)(6486002)(83380400001)(478600001)(6666004)(1076003)(6506007)(6512007)(9686003)(26005)(38100700002)(54906003)(7416002)(44832011)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZuN/4zvwNcUuMCA1ivtg1h0IcMjDLVPLG/fk0UBr6Y+dItay5AVswAyFimj?=
 =?us-ascii?Q?pjMImaWDfOkKcFyvNSN+Fyh3T6JERjxq/68RhTJDVwj/ERi126kTJKeJ9IWP?=
 =?us-ascii?Q?1hb2eiXJe9qlmpCR8n46bg+xiQFUhSl/LjXSileADyKEcqrIhqGV3wT97Jf0?=
 =?us-ascii?Q?A2/VGu/3haZia+nHpr7uYm/sOvYoltk7cDlhXuqqeWdOV3vlgMasTKDB5dwl?=
 =?us-ascii?Q?EYrj/7qhPzDuuw4Cbf7/0DDGxMdEccuTAa9gr4puN0RJgSE+K9lBmRTb2JAM?=
 =?us-ascii?Q?1D6ou86gYMsXCNXPi8pRrQFpkjZTLavD9yHi0DvypR3Sg9mPIfOzNwR0VvjN?=
 =?us-ascii?Q?M39agFusqqPXY4+MJyfHLUl3rFbI+zet/BtYM179/dTun7w/GpuzPKNIK98T?=
 =?us-ascii?Q?zcy1rxlp54PstFgZ9N1my/ii1EkTYla5XLYhpRwwc1/VFF6VcX+p63j8C852?=
 =?us-ascii?Q?O5htujx68oDuA6WXkBK60LWKrzMUUG9grLV4d8ikMdPikPAsUU+dMrg6gbE6?=
 =?us-ascii?Q?KkPsOdnzHTa/GiLHtigr9z0HOK3arK4rBIAml5Aapa0FPmsY32lgFuaTq2Pv?=
 =?us-ascii?Q?uneaZOLCJqzEN5h+KUp6UUa1G3Cu6iHz9m4BjAIrc1BbktKcx0Uzt8F+QOqi?=
 =?us-ascii?Q?i6Ld2SipuTvrmoDErDx+XDLP9jFKbJMv1W0WIlqjp955QRMocTulH5X68fuj?=
 =?us-ascii?Q?EiovmGAqx+HdQsfNx2qg2PCVma3GWSz2Wc5dKzI3ZKdAtvGQmX61EBzHXops?=
 =?us-ascii?Q?5iPZpemRduaCHuu5WcLE1XrCHSaE26T2ZOf0/O+UfiN1jxfBOaaACEvw5Mo9?=
 =?us-ascii?Q?uRsNDYiLDVF3KCKWNwH1QGyMQAebbRoRd8pRJI7A1k0UWhFNdmYZcOYSm7ga?=
 =?us-ascii?Q?J01/6UqIxmDK1GSYHPSJ62Zwxjid6jl9pPUJYJ2W3TsYHEgW2OlLlYbKM9Qt?=
 =?us-ascii?Q?YnkAk+bD3UUWFoRF0NAg8XfPg8SgY4PDoeS2TVuqxpN2jJbjCsfCSQ7XCXbj?=
 =?us-ascii?Q?ew90rXtr0K87TINS3ryAy8+VdAWA1k3Bqc+kL9C6+Kfc5/pdPyI3MVNAWUL2?=
 =?us-ascii?Q?mybidjoWMq4K8Npfx/I/HIdz427ku7H5nOc+DTRkUmTDAPR/rnYxFZh3yqEi?=
 =?us-ascii?Q?mxVxcGfmnzsu7utPauRs8jKYnYRWyQxUnKCB/kLG3wSAZAEQolt1ZuIeRvuG?=
 =?us-ascii?Q?TqvCKHpHRgeqRPh1NY2yvbhuhZRRMEEq7Y6QgPuTcZX7iRwWoNicCNkLh2YN?=
 =?us-ascii?Q?tRpK3tcknzPkqyaCMwTYd+LDhx2r6Cl+ErbHXIL2Hn4OejFT/bVdEP+RCxQg?=
 =?us-ascii?Q?XEGjZU2IX4ugUL9HnyN1VSys6JBdbgpFtwnGptzhUKn+rBUbBZdwTAw6kMcT?=
 =?us-ascii?Q?DtaDkD/4JyHkuTlbhFXNufS84Zk69JQujX1VhKk8RM0+LseKog/IyEmK7C+Z?=
 =?us-ascii?Q?j3zkrENPeV2ksXz8VsxzWmFghOTgi9g9bco1g2/ZEsX6lfJNZS2Z0eBD088M?=
 =?us-ascii?Q?yhpbJBpbcnEgASh3NalHsXAq9AusTB7Ti6Wr2KDZ2BE/6mHeCZ1sgKHGjMIF?=
 =?us-ascii?Q?d9qzKEkfHsjeJiaRojJqUhmqqqR11Th85TaIp2kE7ABNTH/k1+G04cHQU53J?=
 =?us-ascii?Q?sQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e848b0-874d-4a87-228e-08dafed57ffd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 13:10:15.7475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PO8N6Ze+g//XiEGrDeVkEA6WYfJxQpBCo0KzDQRkE0YW4PiX3cesZ9iemMJ/Y6D2kG2OhTcU3WwG56XZnMhuUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9244
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 05:11:29PM -0800, Vinicius Costa Gomes wrote:
> Hi Vladimir,
> 
> Sorry for the delay. I had to sleep on this for a bit.

No problem, thanks for responding.

> > Vinicius said that for some Intel NICs, prioritization at the egress
> > scheduler stage is fundamentally attached to TX queues rather than
> > traffic classes.
> >
> > In other words, in the "popular" mqprio configuration documented by him:
> >
> > $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
> >       num_tc 3 \
> >       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> >       queues 1@0 1@1 2@2 \
> >       hw 0
> >
> > there are 3 Linux traffic classes and 4 TX queues. The TX queues are
> > organized in strict priority fashion, like this: TXQ 0 has highest prio
> > (hardware dequeue precedence for TX scheduler), TXQ 3 has lowest prio.
> > Packets classified by Linux to TC 2 are hashed between TXQ 2 and TXQ 3,
> > but the hardware has higher precedence for TXQ2 over TXQ 3, and Linux
> > doesn't know that.
> >
> > I am surprised by this fact, and this isn't how ENETC works at all.
> > For ENETC, we try to prioritize on TCs rather than TXQs, and TC 7 has
> > higher priority than TC 7. For us, groups of TXQs that map to the same
> > TC have the same egress scheduling priority. It is possible (and maybe
> > useful) to have 2 TXQs per TC - one TXQ per CPU). Patch 07/11 tries to
> > make that more clear.
> 
> That makes me think, making "queues" visible on mqprio/taprio perhaps
> was a mistake. Perhaps if we only had the "prio to tc" map, and relied
> on drivers implementing .ndo_select_queue() that would be less
> problematic. And for devices with tens/hundreds of queues, this "no
> queues to the user exposed" sounds like a better model. Anyway... just
> wondering.
> 
> Perhaps something to think about for mqprio/taprio/etc "the next generation" ;-)

Hmm, not sure I wanted to go there with my proposal. I think the fact
that taprio allows specifying how many TXQs are used per TC (and
starting with which TXQ offset) is a direct consequence of the fact that
mqprio had that in its UAPI. Today, there certainly needs to exist
hardware-level knowledge in mapping TXQs to TCs in a way that makes
software prioritization (netdev_core_pick_tx()) coincide with the
hardware prioritization scheme. That requirement of prior knowledge
certainly makes a given taprio/mqprio configuration less portable across
systems/vendors, which is the problem IMO.

But I wouldn't jump to your conclusion, that it was a mistake to even
expose TXQs to user space. I would argue, maybe the problem is that not
*enough* information about TXQs is exposed to user space. I could
imagine it being useful for user space to be able to probe information
such as

- this netdev has strict prioritization (i.e. for this netdev, egress
  scheduling priority is attached directly to TXQs, and each TXQ is
  required to have a unique priority)

- this netdev has round robin egress scheduling between TXQs (or some
  other fairness scheme; which one?)
  - is the round robin scheduling weighted? what are the weights, and
    are they configurable? should skb_tx_hash() take the weights into
    consideration?

- this netdev has 2 layers of egress scheduling, first being strict
  priority and the other being round robin

Based on this kind of information, some kind of automation would become
possible to write an mqprio configuration that maps TCs to TXQs in a
portable way, and user space sockets are just concerned with the packet
priority API.

I guess different people would want to expose even more, or slightly
different, information about what it is that the kernel exposes for
TXQs. I would be interested to know what that is.

> > Furthermore (and this is really the biggest point of contention), myself
> > and Vinicius have the fundamental disagreement whether the 802.1Qbv
> > (taprio) gate mask should be passed to the device driver per TXQ or per
> > TC. This is what patch 11/11 is about.
> 
> I think that I was being annoying because I believed that some
> implementation detail of the netdev prio_tc_map and the way that netdev
> select TX queues (the "core of how mqprio works") would leak, and it
> would be easier/more correct to make other vendors adapt themselves to
> the "Intel"/"queues have priorities" model. But I stand corrected, as
> you (and others) have proven.

The problem with gates per TXQ is that it doesn't answer the obvious
question of how does that work out when there is >1 TXQ per TC.
With the clarification that "gates per TXQ" requires that there is a
single TXQ per TC, this effectively becomes just a matter of changing
the indices of set bits in the gate mask (TC 3 may correspond to TXQ
offset 5), which is essentially what Gerhard seems to want to see with
tsnep. That is something I don't have a problem with.

But I may want, as a sanity measure, to enforce that the mqprio queue
count for each TC is no more than 1 ;) Otherwise, we fall into that
problem I keep repeating: skb_tx_hash() arbitrarily hashes between 2
TXQs, both have an open gate in software (allowing traffic to pass),
but in hardware, one TXQ has an open gate and the other has a closed gate.
So half the traffic goes into the bitbucket, because software doesn't
know what hardware does/expects.

So please ACK this issue and my proposal to break your "popular" mqprio
configuration.

> In short, I am not opposed to this idea. This capability operation
> really opens some possibilities. The patches look clean.

Yeah, gotta thank Jakub for that.

> I'll play with the patches later in the week, quite swamped at this
> point.

Regarding the patches - I plan to send a v2 anyway, because patch 08/11
"net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()"
doesn't quite work how I'd hoped. Specifically, taprio must hold a
persistent struct tc_mqprio_qopt, rather than just juggling with what it
received last time via TCA_TAPRIO_ATTR_PRIOMAP. This is because taprio
supports some level of dynamic reconfiguration via taprio_change(), and
the TCA_TAPRIO_ATTR_PRIOMAP would be NULL when reconfigured (because the
priomap isn't what has changed). Currently this will result in passing a
NULL (actually disabled) mqprio configuration to ndo_setup_tc(), but
what I really want is to pass the *old* mqprio configuration.
