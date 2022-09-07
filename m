Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352975B0EAE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiIGU5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIGU5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:57:18 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140055.outbound.protection.outlook.com [40.107.14.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AF49DB78
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:57:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2ZWkk/2DeptDODWERJ2jfNgdBwv4o3Nc7X59bYJREk5Xd/8QgYpc9IhskGrcl4+5sEDtxK5eLAXorgaRQw41DOryQGtFD7NrjOsoAjYQ4E84oA2s111+R2tFIlWRTANnnVMI1vl72gk0vB8ADF2GaRls7ojk4JgKD8r8pPHG24Qzd9PQFRJif0v7WP3Q83DYDzf2VFphGWUWKkY6S7MWo4FNfGeHkIbXcCSOHIChGRaUJ+bixlCos1QF9Hv9FUceuZa2iwzqpy3h0aHFuFk7Qs54/ZpkhcweSqDAgDI1cLhpvaP45UA7zrQDqvMPqRqCJmUZXPN+La1GQ1cu+sKxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7R+TAbiJGErNM79GgBO/0iBNagzK60Blqcvg2nDKuc=;
 b=WmG8wzg0s8dAjNZ2uxMauVtFUQe52OgCiTmV6BoflhKXBi971GHjPGXDpfGMuSODeNmPC6DSe1HN0XU53qoajePKFvtZklpSokj9Femn9op7tB59Cosf7yu5uL36BZs1OBkwhiHMNmjVIVy4DZ4LeptB7rSepQxvOnpjrUwLU/J+vsbUHPqpH+r0mjIhUixQUks4pVxTWSRI398M9JegGGRdsZxN1RZB1JYLf34+krNm4HMLk/OBEEQtMHtuwsQWoYqKHH/yl7TlgMCEidUB6zI/0qrtNJlVpEAb1rJUEVlt0Kw1GWQSbQ5kuq4k+EbvG/qJExMt6HOVODm/x6h1pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7R+TAbiJGErNM79GgBO/0iBNagzK60Blqcvg2nDKuc=;
 b=hjVsr1NHOWu9zaJnIIFk47kyjYyH/bcQ+3zO5k7OgPr+uivdOnXq5H6igd9MKFS3pR7UnLsIxVqRyKPA9AvKn6pYse92645GKyrl/6oul0KwuhDmqsKQVc6GMjsJmSfFuFsi6JV/o1e4JyWoWNQhM75j0eUA8i7POzKC/aeAp5E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3119.eurprd04.prod.outlook.com (2603:10a6:802:10::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Wed, 7 Sep
 2022 20:57:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Wed, 7 Sep 2022
 20:57:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Richie Pearn <richard.pearn@nxp.com>
Subject: Re: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
Thread-Topic: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
Thread-Index: AQHYsb+nXYtt3WXwKU2Qzt72A2WzpK2zuuaAgAKuqwCABtWsgIAXVhCA
Date:   Wed, 7 Sep 2022 20:57:11 +0000
Message-ID: <20220907205711.hmvp7nbyyp7c73u5@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-3-vladimir.oltean@nxp.com> <87bksi31j4.fsf@intel.com>
 <20220819161252.62kx5e7lw3rrvf3m@skbuf> <87mtbutr5s.fsf@intel.com>
In-Reply-To: <87mtbutr5s.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 263d8e28-d46a-4c45-0550-08da91138948
x-ms-traffictypediagnostic: VI1PR04MB3119:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EuleeUl9LfMvUgAS+Uk0d4SW/KFD+o5ZKJKI5iTySASeP/hZQlJJzD7kcGu3VA/MfSMnNPvUKGAocNfpRFNpWoLRwW1O/ud1kl0qE7SKp4wQEwlq1pUiQBR+Eu0ep4Y8NNsgTwbffV8+zQFosHhUmIdbXKia7hJOLyMO+7jknkHsedWAhC35uQcb83RjxzBaazRc7TqbXYVqsEbXqUmhnH/wsJKyYwxs3lZUWTO/uo3iiKtMNT+6gPtKQU5RveMQyJfBoJqUkWH86hSkwCm5SzBPZwOe1vvzgcNPIt//tZAYoNV7HJou1KFG6F8fPg1kVar1+F9oztFpEhJcdB+990gz1zMrvACIDJXg92I9afNqdUfFp3FYZeDqDiFzxmfVod5+Od9BcimCTnqGVM3TNCrE9EcydwzbItol9fVSuga5gOaYIpdeeN00qegYx39Y14WzC+DKvGxyBhfsGJJ7BJMQqcFJ8PW6hUriRIuvg+ihi9lx196/DmalzfWyq8CMwhwZf3RrZIVixTksORgHmgb4RGI8MzIaPaOze9O0NSXm6moMDnhVnCSQMdOJvsl4lVHUifsyvibj/vVR/NfCCPDEe85s083VB8mOZuQn82hTsAPO52HUA1EryO8OL01Y5kouzxYkVoLgd4O8m9Vg7SPPU2BAc6WITFcPVmMtCH8iepSAFLCxYH3M1tolINUbi/kEDjVRbLTzpc+aU+SdsaQfx+N1gyRUGoTqvo7+d0X6I3YgtF/FuH7JcjbltchVTsDz5u39g/p36ddrgXCNrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(66946007)(86362001)(186003)(1076003)(6486002)(41300700001)(71200400001)(478600001)(26005)(9686003)(6512007)(6506007)(33716001)(122000001)(38100700002)(38070700005)(83380400001)(5660300002)(6916009)(316002)(54906003)(2906002)(66446008)(64756008)(8936002)(8676002)(66476007)(4326008)(66556008)(44832011)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MjW994w5S6tlDji3PXEZrgLRJfk/nSNyhUIK/87lD/kk970xZarme8iGAtTZ?=
 =?us-ascii?Q?krvq1aCZesfl+bt5QMbbRJSEST1eQtllWfqYTxVbsqQmaJbyg7RlANLksJfR?=
 =?us-ascii?Q?qi/9D2g8kpMChzx22lOCCJyj/GXj0vWYJ19RSHTuwf7WUR3tpGg+AFpiEVs1?=
 =?us-ascii?Q?hV5EJYPA0vjg3TSWbnOH5drhbOUDMoxrpX3CcJ+HGxnt9YLRqqnxdhYbCqW/?=
 =?us-ascii?Q?YuBNK44Gug+AOiZx+Cc6vaagNBgH5MooVXk0l4CDckwqWkBjyzfky82wQezP?=
 =?us-ascii?Q?+4qqncIsGBZcomGxdTFl5BKr+5s0zoKGWglAT3NBkBcTtIuukdF5G408/oOT?=
 =?us-ascii?Q?7po52p0878m+cW/Ki4c675dPs+QNKHYiJydEYc8NUCJ6lk8Uf02CKxaqOIrz?=
 =?us-ascii?Q?rtpOotp+Xa6QvWA95eook+alNe73inkoV5NgSgdtqolSCdzT5250QqkQsp+5?=
 =?us-ascii?Q?xrsjj6AdG43pIkfmwBQ/D67GjdsQWaGj/35WdufZvMN+dHAKCThqIYC4AWOv?=
 =?us-ascii?Q?/BQB5DEEu3jxtYexNkGhFwsd9hmT1O/b8VpT0v/dHW8k1kimo0qExJXG1+/o?=
 =?us-ascii?Q?6gCQWPqj1c8qX+pVQ+UKxJm5u1u1vOfot4INK/RmLs7UmVIOrwEjhk0UKUW3?=
 =?us-ascii?Q?5QMVxdQjhfuDagJKAIltT1ff9tEvGM8Ez3aOwfoPQ/A5xzdlsNAELSbqTwGs?=
 =?us-ascii?Q?tjjD63Sr3uWh+yQy39/e1mjwwaB/iIoXBaZ8ntZ1i+Ap4AXyCV0HDiys9hgI?=
 =?us-ascii?Q?54kK4BpwN5KXj0ZsoYgVq0/5PmgXnBCP9iSviinxqbFZm5R1hm37cGqV5dVD?=
 =?us-ascii?Q?OBajdUro78clgPtp0XSRkOLC+ynubGtCxZw6I6clU1uhi2GoxJlSwj0l0V2J?=
 =?us-ascii?Q?Chwgia5Yace9v10D4R0GulxOE039jP7osGsA8a5HnWfBm+82EydkFji7WkyJ?=
 =?us-ascii?Q?TFHNEAOlyLMxqNkIbnFApeJ0IYkIJWU3t7Uh3e8QiL4Du8/8+3+0KbETEb/4?=
 =?us-ascii?Q?WwcyXt7HC13iS0DvRL0Ge/5W8Ihjy4LzP1rrtngQnaTCRC+M8MQs9FGda0aG?=
 =?us-ascii?Q?gpk4KoTiU6y9cPOsrI4PWLqk1p+TG78QP9bwShyy1+DRdst6Z6+qdoWNwYrM?=
 =?us-ascii?Q?U0s6AejBHqOlJzQCFsG79t3fnChXaYBaqApy71+4flia2M+mkI8vh2H7KyCe?=
 =?us-ascii?Q?7GVG1gZBx/H7+un1F6nCeEshLgACnOIzjx/y6+kiP67kMadxqjQx0SeRNPO5?=
 =?us-ascii?Q?tu3qSelBRR3uYtpF5ynAw0CP1JfmQgspgQRujK5tmquuBGill/Do+FC+IFps?=
 =?us-ascii?Q?EokYfDi6RutRUfry16/ycf/Knlz2h2+Rwkj+/zLUyJ/SKnmQhGYE+R3XJZKK?=
 =?us-ascii?Q?6hQYBcSipl6GywYKZyLIBXw16mR5GlRMtF8ZNXYywVuheNUxVZkRItj9zIJl?=
 =?us-ascii?Q?nvxRhlSjIYMC9uvCzd0+juttOo5zeMud4SzDA9KP0eviGY4dQEpOGjoPsZyt?=
 =?us-ascii?Q?M7qA6q0eCb5Lx1Jlowja0L9EWyvboUA4FamCXcSxjn4iCDzo+Tocn+1XF/4T?=
 =?us-ascii?Q?SAMfCB/F0nQNVaT70sxAly9x86LZs1QNswkhGev58kYIGp5IBJdmMlU9T955?=
 =?us-ascii?Q?NQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91FE7748633C0C459F5C1775220F796F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263d8e28-d46a-4c45-0550-08da91138948
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 20:57:11.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e4zo8PlkWIJegXGSNJw/B0+knA5MIBIx7vmjG7RW1S1B9GjFPj9hXb+G5FBevx8kTE8kRK9Z7h/BC0UBOdWlaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 05:35:11PM -0700, Vinicius Costa Gomes wrote:
> Yes, as the limits are not in the UAPI this is a minor point, agreed.
>=20
> What I am concerned is about use cases not handled by IEEE 802.1Q, for
> example, thinking about that other thread about PCP/DSCP: how about a
> network that wants to have as many priorities as the DSCP field (6 bits)
> allows, together with frame preemption (in the future we may have
> hardware that supports that). I am only thinking that we should not
> close that door.
>=20
> Again, minor point.

Since Linux seems to have settled on TC_PRIO_MAX, TC_QOPT_MAX_QUEUE
constants of 16 rather than the 8 you'd expect, I guess I don't have
that big of a problem to also expose 16 admin-status values for FP.
I can limit the drivers I have to only look at the first 8 entries.
But what do 16 priorities mean to ethtool? 16 priorities are a tc thing.
Does ethtool even have a history of messing with packet priorities?
What am I even doing? lol.

> Sorry if I made you go that deep in the spec.
>=20
> I was only trying to say that for some implementations it's
> difficult/impossible to have totally orthogonal priorities vs. queue
> assignments, and that the commit message needs to take that into account
> (because the API introduced in this commit is implementation
> independent).

Yes, the comment is totally valid. However, between "difficult" and
"impossible" there is a big leap, and if it is really impossible, I'd
like to know precisely why.

> I, truly, admire your effort (and the time you took) and your
> explanation. I think I understand where you come from better. Thank you.
>=20
> Taking a few steps back (I don't like this expression, but anyway), I
> think that strict conformance is not an objective of the Linux network
> stack as a whole. What I mean by "not strict": that it doesn't try to
> follow the letter of the "baggy pants" model that IEEE 802.* and friends
> define. Being efficient/useful has a higher importance.
>=20
> But being certifiable is a target/ideal, i.e. the "on the wire" and user
> visible (statistics, etc) behavior can/"should be able" to be configured
> to pass conformance tests or even better, interoperability tests.
>=20
> Now back on track, in my mental model, this simplifies things to a
> couple of questions that I ask myself about this RFC, in particular
> about this priority idea:
>  - Is this idea useful? My answer is yes.
>  - Can this idea be used to configure a certifiable system? Also, yes.
>=20
> So, I have no problems with it.
>=20

I've taken quite a few steps back now, unfortunately I'm still back to
where I was :)

I've talked to more people within NXP, explained to them that the
standard technically does not disallow the existence of FP for single
queue devices, for this and that reason. The only responses I got varied
from the equivalent of a frightened "brrr", to a resounding "no, that
isn't what was intended". Of course I tried to dig deeper, and I was
told that the configuration is per (PCP) priority because this is the
externally visible label carried by packets, so an external management
system that has to coordinate FP across a LAN does not need to know how
many traffic classes each node has, or how the priorities map to the
traffic classes. Only the externally visible behavior is important,
which is that packets with priority (PCP) X are sent on the wire using a
preemptable SFD or a normal SFD, because the configuration also affects
what the other nodes in the network expect. You might contrast this with
tc-taprio, where the open/closed gates really are defined per traffic
class, and you might wonder why it wasn't important there for the
configuration to also be handled using the externally-visible priority
(PCP) as input. Yes, but with tc-taprio, you can schedule within your
traffic classes all you want, but this does not change the externally
visible appearance of a frame, so it doesn't matter. The scheduling is
orthogonal to whether a packet will be sent as preemptable or not.

Is this explanation satisfactory, and where does it leave us? For me it
isn't, and it leaves me nowhere new, but it's the best I got.

So ok, single TX queue devices with FP probably are possibly a fun
physics class experiment, but practically minded vendors won't implement
them. But does the alternate justification given change my design decision
in any way (i.e. expose "preemptable priorities" in ethtool as opposed
to "preemptable queues" in tc-mqprio and tc-taprio as you did)? No.
It just becomes a matter of enforcing the recommended restriction that
preemptable and express priorities shouldn't be mixed within the same
traffic class, something which my current patch set does not do.

[ yes, "should" is a technical term in IEEE standards which means "not
  mandatory", and that's precisely how the constraint from 12.30.1.1.1
  was formulated ]

I guess when push comes to shove, somebody will have to answer the
question of why was FP exposed in Linux by something other than what the
standard defined it for (prio), and I wouldn't know how to answer that.

> >>  - Question: would it be against the intention of the API to have a 1:=
1
> >>  map of priorities to queues?
> >
> > No; as mentioned, going through mqprio's "map" and "queues" to resolve
> > the priority to a queue is something that I intended to be possible.
> > Sure, it's not handy either. It would have been handier if the
> > "admin-status" array was part of the tc-mqprio config, like you did in
> > your RFC.
>=20
> Just to be sure, say that my plan is that I document that for the igc
> driver, the mapping of priorities for the "FP" command is prio (0) ->
> queue (0), prio (1) -> queue (1), and so on. Note that the mqprio
> mapping could be that "skb->priority" 10 goes to TC 1 which is mapped to
> queue 0. Would this be ok?

If skb->priority 10 goes to TC 1 via the prio_tc_map, and finally lands
in queue 0 where your actual FP knob is, then I'd expect the driver to
follow the reverse path between queue -> tc -> prios mapped to that tc.
And I would not state that prio 0 is queue 0 and skb->priority values
from the whole spectrum may land there, kthxbye. Also, didn't you say
earlier that "lowest queue index (0) has highest priority"? In Linux,
skb->priority 0 has lower priority that skb->priority 1. How does that
work out?

In fact, for both enetc and felix, I have to do this exact thing as you,
except that my hardware knobs are halfway in the path (per tc, not per
queue). The reason why I'm not doing it is because we only consider the
1:1 prio_tc_map, so we use "prio" and "tc" interchangeably.

It can't even be any other way given the current code, since the struct
tc_taprio_qopt_offload passed via ndo_setup_tc does not even contain the
tc_mqprio_qopt sub-structure with the prio_tc_map. Drivers are probably
expected to look, from the ndo_setup_tc hook, at their dev->prio_tc_map
as changed by netdev_set_prio_tc_map() in taprio_change(). Why this API
is different compared to struct tc_mqprio_qopt_offload, I don't know.

What prevents you from doing this? I'd like to understand as precisely
as you can explain, to see how what I'm proposing really sounds when
applied to Intel hardware.

> >>  - Deal breaker: fixed 8 prios;
> >
> > idk, I don't think that's our biggest problem right now honestly.
>=20
> Perhaps I am being too optimistic, but the way I see, your proposal is
> already expressible enough to be used in a "certifiable" system. I was
> too harsh with "deal breaker.
>=20
> So, what is the biggest problem that you see?
>=20
> Overall, no issues from my side.

Let me recap my action items out loud for v2 (some of them weren't
discussed publicly per se).

* Enforce the constraint recommended by 12.30.1.1.1, somewhere as a
  static inline helper function that can be called by drivers, from the
  tc-taprio/tc-mqprio and ethtool-fp code paths. Note that I could very
  quickly run into a very deep rabbit hole here, if I actually bother to
  offload to hardware (enetc) the prio_tc_map communicated from tc-mqprio.
  I'll try to avoid that. I noticed that the mqprio_parse_opt() function
  doesn't validate the provided queue offsets and count if hw offload is
  requested (therefore allowing overlapping queue ranges). I really
  dislike that, because it was probably done for a reason.

* Port the isochron script I have for enetc (endpoint) FP latency
  measurements to kselftest format.

* Do something such that eMAC/pMAC counters are also summed up somewhere
  centrally by ethtool, and reported to the user either individually or
  aggregated.

* Reorganize the netlink UAPI such as to remove ETHTOOL_A_FP_PARAM_TABLE
  and just have multiple ETHTOOL_A_FP_PARAM_ENTRY nests in the parent.

* The enetc verification state machine is off by default. The felix
  verification state machine is on by default. I guess we should figure
  out a reasonable default for all drivers out there?

* For some reason, I notice that the verification state machine remains
  FAILED on felix when it links to enetc and that has verification
  enabled. I need to disable it on enetc, enable it again, and only then
  will the MAC merge interrupt on felix say that verification completed
  successfully. I think I'll need to put a quirk in enetc_pl_mac_link_up()
  to toggle verification off and on, if it was requested, in order for
  this to be seamless to the user.

If it's only these, nothing seems exactly major. However, I assume this
is only the beginning. I fully expect there to be one more round of
"why not dcbnl? why not tc?" nitpicks, for which I'm not exactly
mentally ready (if credible arguments are to be put forward, I'd rather
have them now while I haven't yet put in the extra work in the direction
I'm about to).=
