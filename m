Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B70158FB3E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiHKL3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiHKL3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:29:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C928A66A70;
        Thu, 11 Aug 2022 04:28:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1/R2XuRIZ1cGBSrhtDdSR4nezZAV6sTimh98yO8hQoz+rGqMJnGELH2yalIjJcIOPyZCu+CIlE1Q4Vc/qZMcmm00BGSyfqJOMeB1Dz0TTQB78vo4q5WFq9weKzfCAqZeZ3wqTZrCSCKgKyayElqiskK/Gwji5DU4fsg306b/kTJUx/d5emLdBlV/LzroXcFbpV63UXrtTo4p1iDGO74yZe3VfHmBqGnRRO83pQsjwva8uQrsuUunc0R6T3mLXmP2egZ6/y5x7yzXQCyOQ3lmhX/QF8d+3wyGIAioT8u4mwgxFxqK+cgR1ZeOe8qCoduDMamI1l1yrsFMA8IgobJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGEs0gi6zE0+s8j80eORUFW0EiYDSHx6gLYg0JILxdE=;
 b=n18odaFCfgc79IV/m48Q3PkFXnM81nEYKPe7JScd93tk5i3eO+wMc4iCvgsU0obZL3z4mA4Th6WICCTFPtb3FMzxHEYgEvFdz5WbLo/lJvuOAviiWOFHhF5eXMe1EV+lvPrZLUyMM1e5Gtm5D3BnhwMbT6+6/bYunvaST+mwWa2PYojg4gEyQtI47zeW6H5kOKLpOh1WHPtXuy16nrn0lNweXGvPRyYkKEn3PezoG7ci1O3tfccvBqLcbJl+grCPCC91s5rOz/PoRyLf+SW+RJYZO2Z5gwkDGCshWBoRRvFAgO4MTsV0IIeQv5dH8jinqSxbauhCtExQ7upkzwVkrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGEs0gi6zE0+s8j80eORUFW0EiYDSHx6gLYg0JILxdE=;
 b=fbQkqdAE4DRXh4IWa9e/DrQb/DqVkWHXIx3qTjpbmMDuL6uLcbxePWwRhLbahGyfkay4Z6+pZ+bFzBjIGqhJpUdKN7Fq/JygeHUVp6DqIhE2biyz6Az6dZnlBl+RsZTavdbUaPAz9qNudcqVdIGKd/j8m8ymCV9Pj4t6m1OVCJdYchgYmBBQd8VD9L82HnrMrROloAtpe+E+/N27JPWprKDh++cDjqiD5c4PT3jVCt7+dTnv92J0FM67VUcB7EpDbO1VDo6lVIxNJhUNdgz7Y+7mO5gzn8xY4OP1UqAa0nQsjOpGRmC5TftC26mmBGUAktcQJGvfbUYcSPcM/pcLjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB1690.namprd12.prod.outlook.com (2603:10b6:4:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Thu, 11 Aug
 2022 11:28:56 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Thu, 11 Aug 2022
 11:28:56 +0000
Date:   Thu, 11 Aug 2022 14:28:51 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YvTn847P/Ga3Ulb0@shredder>
References: <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <79683d9cf122e22b66b5da3bbbb0ee1f@kapio-technology.com>
 <YvIm+OvXvxbH6POv@shredder>
 <6c6fe135ce7b5b118289dc370135b0d3@kapio-technology.com>
 <YvNcitNnyFxTw8bs@shredder>
 <2491232d5c017d94ca3213197a3fb283@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2491232d5c017d94ca3213197a3fb283@kapio-technology.com>
X-ClientProxiedBy: VI1PR06CA0187.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::44) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74c381f3-3bbe-4b71-002a-08da7b8cad5a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1690:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4UNp6AdZ28spDcNhQkkYvo+szCGylijEnKZ7A6GvkKZSFWlI1Lh4k/glgGtKy3zk3vo04Va01AlzQuUbgFGyBW1QQDalzxLOMX9DYNZasq5tMq4+cJG2UdpLOsO4ai1prun60iy2U67jpu4Sz09W9eToQnTjhonSSd2KWTtHH0s32xzYbFEJrCgjHIFiE0A456+LHxHp06pphupnogug55grNju7QRQiZTshH8Lj25o1J3V73y02SFAqsjAUwBbKjRqH+vNfyHisKyQustkZ0OC1pi88KWovepgrOAqRlFkIrmqiynkudBC688LPxO1SRUNi23JdXto0+D2dldoE2z/rQ1dUY1WPPHIueH/z0KEf7sq340v0G8TaBrVKzlKbmJ726EBCNg+Covk/H6iMYH2YZTI1FE+8wF/Y/MXbSJ2BdL+3MHCoBoqwDCrE6oBi5ZkZf4BpmjOlPDXbwdfCjdAGLvT5fDODzLgCdfF8w/xL9rEVU/3jdfB7ApPuQr02WzPHAXWGHJUttuo8jEjdXx3VtMgTSslxkawT9w6tpQthWBQ9AyiP9F6ybAU4IxG26XEiH7C14eNov+bGCwzvec4na0vZOoiSFc9IBSlFiTVuNSxqT1XkKLSqa2wyOIOSbXRGSSrL2jNGoBsrF/iEnJrzuEmKwjMBouYkHHEuUHtNFOMujoQIxJR/yXKJucFn87ThB/ginlvx5TiFCdAUJfAvKx61G5Gc0ps+jIvYVKpdyPP812DxA+RtD48L/oe3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(346002)(396003)(376002)(39860400002)(186003)(54906003)(8676002)(66946007)(4326008)(66556008)(66476007)(478600001)(6916009)(316002)(86362001)(41300700001)(33716001)(5660300002)(53546011)(8936002)(6512007)(6666004)(7416002)(9686003)(26005)(6506007)(38100700002)(2906002)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9dxWbp4LX9cTpQJx0YNKBQEupZbzHg2LhdleFzFVp3hZGFGNhy6LdLSg1SQS?=
 =?us-ascii?Q?Z9GrF3q6pY0Lr1NL43sM5uikf67qdMMBsPPGK1Shge/BFDJ4svgFhRU2FZEu?=
 =?us-ascii?Q?DDhqQWc9omRVd2ZeZgkP/rPRTkcOzSfC74bvZuzkWcewzj8IEP37Z0rEkrFN?=
 =?us-ascii?Q?dyMBsNOGnikJLNeQA2Mmirp1ZFvtbPNbO32YYjUn1OPynzw3NREZBovxe9fr?=
 =?us-ascii?Q?+V02mmlr4Ru3P+d04NjwNnG6wxj+n+X6U/qz4Fpbd5Tk9d6AzsOIbEpg8ZyB?=
 =?us-ascii?Q?SPh9Di00XdB2bsnekbDTcYsFf/NO6Iz0riFWgGRaZAL37VJj4gIrwo1487JT?=
 =?us-ascii?Q?pbWLG4ZR/slFSyxz0rLNdTcxmnnewNAT5AXcXs9CfuTAA14DmEAdCzohpNH1?=
 =?us-ascii?Q?JqKA/yYHAUaVCan2ZudIv01fCCyr23dNQkx+lohJxBZUUSL5M6SOx2Kk2sex?=
 =?us-ascii?Q?PdYbmKM8lMPQVkJoUzcmulkNWJVnoK+NjecL29/46FpGmUTKD9jxM2K61cLt?=
 =?us-ascii?Q?D5LlsCpfJZsYqPwoaDUzCtASp5TRbtzNOoY0yOVXdfmnI0jJb8Piqv6KJHmA?=
 =?us-ascii?Q?jKG/Sk52M0/Faw+0PzIzs8BQlykKCjJrqVh+zkJX13sb5otZAhQqB0ZBAK5E?=
 =?us-ascii?Q?ij6VXRoBSwJAaTxRlj04KcVvs4fXO+zC9sMwyt+QlY5iNJ6PGznm52kyT9GW?=
 =?us-ascii?Q?QoR/q9URam076VWs/bS6OlHmAvnyb6eQ6E3mYG7x5+n2o46jjjvLzpDRMOgt?=
 =?us-ascii?Q?/5gNb5ZCD7KQ3hrNdP1nGNn8bfr3WH06E27PRDJrfKU7oxcEioqKNNs031Ni?=
 =?us-ascii?Q?MmuefSy7Mn7yjrKwrn9DauJQjFaspCJS1lOJzkQZCyihIzUnWzT3GVDjWgTI?=
 =?us-ascii?Q?/L6g8TZPjX+8o/BDGa84m08XMCs8Q8d9RQkzA3PAzVa4jak/xjrqC4KgEwQi?=
 =?us-ascii?Q?UTbOCMeXJSeo/z3xGYYrqr6zyFImJdPIhqUdopHkp/O3yguIRctgtc8kTcIg?=
 =?us-ascii?Q?BdQbLlKQ+GBMiF96KxKWKCdauK14/v4tNhFfA5DEJuF1Wi+PTOxMPBZ9A/2c?=
 =?us-ascii?Q?D5q9Cr5v/HDskbhQ6Wl6+V0vh/M5It5qnfBEcVsjcOWWjzu9c5YGmnecYxGC?=
 =?us-ascii?Q?q7aANizCvPKWbe8Jg2lJAQru6nXlIaHmlZaOeRAKZp4RY68JJ84AwMqoqDGf?=
 =?us-ascii?Q?BJKSNDiyHeHJ9OXV1Q5X600Ec9xdz3F2FbumZ+EK+1L6aRAP7qglBwvgs12r?=
 =?us-ascii?Q?j2amSlwSv+84LUm9uAYX01W80ZyTEIHaKbBck3jdzl60UN2+fu+QSQShwTLL?=
 =?us-ascii?Q?66tnAewCy2ms8srZTP5e0oIAB+DPdzuWX44xdJjT4hGb5Ezyxv18kuN7qvm5?=
 =?us-ascii?Q?/rSMZFzGWWk2rCcpM795RQN5C2ynuflaavjS800Yl5ASujW7UwNKiSFKvauT?=
 =?us-ascii?Q?gdvjMV45bmE3OSmp54uDytZBIGQeUNC1GlloPbeZTR74TNEMgWfKDCP8IMKj?=
 =?us-ascii?Q?LRkaKgsLUuhJVkhdqn8izq25cRngs51t8ZUhLenybRy+45+k1qqxcQg+/k4d?=
 =?us-ascii?Q?hS9QL4CAwM5sfm4lfq5IyRXFdh/lthTT/cAB3B3q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c381f3-3bbe-4b71-002a-08da7b8cad5a
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 11:28:56.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: buwicC9/YhHaGLTD+82d+gpsYp13lF/p0zpvGb53hkRCGldJ3Nim/o5slK7xxNLuSK84v4JxlLnF6WqhpHZUrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1690
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 10:40:45AM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-10 09:21, Ido Schimmel wrote:
> > On Tue, Aug 09, 2022 at 10:00:49PM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-08-09 11:20, Ido Schimmel wrote:
> > > > On Mon, Aug 01, 2022 at 05:33:49PM +0200, netdev@kapio-technology.com
> > > > wrote:
> > > > > On 2022-07-13 14:39, Ido Schimmel wrote:
> > > > >
> > > > > >
> > > > > > What are "Storm Prevention" and "zero-DPV" FDB entries?
> > > > > >
> > > > >
> > > > > For the zero-DPV entries, I can summarize:
> > > > >
> > > > > Since a CPU can become saturated from constant SA Miss Violations
> > > > > from a
> > > > > denied source, source MAC address are masked by loading a zero-DPV
> > > > > (Destination Port Vector) entry in the ATU. As the address now
> > > > > appears in
> > > > > the database it will not cause more Miss Violations. ANY port trying
> > > > > to send
> > > > > a frame to this unauthorized address is discarded. Any locked port
> > > > > trying to
> > > > > use this unauthorized address has its frames discarded too (as the
> > > > > ports SA
> > > > > bit is not set in the ATU entry).
> > > >
> > > > What happens to unlocked ports that have learning enabled and are trying
> > > > to use this address as SMAC? AFAICT, at least in the bridge driver, the
> > > > locked entry will roam, but will keep the "locked" flag, which is
> > > > probably not what we want. Let's see if we can agree on these semantics
> > > > for a "locked" entry:
> > > 
> > > The next version of this will block forwarding to locked entries in
> > > the
> > > bridge, so they will behave like the zero-DPV entries.
> > 
> > I'm talking about roaming, not forwarding. Let's say you have a locked
> > entry with MAC X pointing to port Y. Now you get a packet with SMAC X
> > from port Z which is unlocked. Will the FDB entry roam to port Z? I
> > think it should, but at least in current implementation it seems that
> > the "locked" flag will not be reset and having locked entries pointing
> > to an unlocked port looks like a bug.
> > 
> 
> Remember that zero-DPV entries blackhole (mask) the MAC, so whenever a
> packet appears with the same MAC on another port it is just dropped in the

What do you mean by "same MAC"? As SMAC or DMAC? I'm talking about SMAC
and when the packet is received via an unlocked port. Why would such a
packet be dropped?

> HW, so there is no possibility of doing any CPU processing in this case.
> Only after the timeout (5 min) can the MAC get a normal ATU on an open port.
> For the bridge to do what you suggest, a FDB search would be needed afaics,
> and this might be in a process sensitive part of the code, thus leading to
> too heavy a cost.

When learning is enabled the bridge already performs a lookup on the
SMAC.

TBH, I don't think this is progressing well because there is too much
discrepancy between how this feature works in the bridge driver and in
the hardware you work with.

I suggest to first define the model in the bridge driver and then take
care of the offload. My suggestion is to send another RFC with only the
bridge changes with emphasize on the following aspects:

* Forwarding rules for "locked" entries. Do they drop matching packets?
Forward them? Or not considered at all for forwarding?

* Roaming rules for "locked" entries. Can they roam between locked
ports? Can they roam from a locked port to an unlocked port and
vice versa? Or are they completely sticky?

* Ageing rule for "locked" entries. Are these entries subject to the
ageing time or are they static? If they are not static, are they
refreshed by incoming traffic from a locked port or not?

* MAB enablement. New option? Overload an existing one? No option?

The commit messages should explain these design choices and new tests
cases should verify the desired behavior.

Once we have an agreement we can work out the switchdev/mv88e6xxx parts
and eventually the entire thing can be merged together. Fair?
