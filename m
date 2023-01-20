Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF7E6756C7
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjATORk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbjATORi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:17:38 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2068.outbound.protection.outlook.com [40.107.22.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749B5CC5D0
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:16:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9f3Abb9rvL+c4vb5IzbZMbMgs6UypS1gGVSUonehAw3+dn9Zy8iRWDtaErsU3FcHl7UKgHKJ+BSKAZWKCfAh5IGH1Fuvjdyf9TD/tyUE3f1O7U1l9El8ZuwigBEPc3h8DcDjiKwKvB5lPqt+TzeWh+tr518PIYLwQhAkYH4zyddPYBZ1B1ZtD9EQW0dMlKrWjfqO3rRihNj60xfVjhh7cpSx+vAelaqcDfeWkTbIYSkWUdbQqXI6+aYVA6vMbsMQh/dGQzepu/WJth71jvYTcRcEc5q8gdvgmE0RWUYLZzjc7A5hqUdv0lguJftgTGH+BuwrlG/7f5bSN2rVYC3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ml3L/0UXeTIbs16XuZq6MfY8U8OjXJH56iMEWC1UtKI=;
 b=k3fI+InvfkNoAP2L63GCaaINfM/qpd943DL+Zm5AdE27i+PnNI17+psIUEHFGIMgKmC8jIEGN8xOOAbOFs7pY89HRF6GpdiMJfpn3QZjp0tkawFT3R+9iMttr9rf2ms5OdchGo1h05g5/ohKo/CLoX35zsC2O5hjOcc23QUEAbYcn6GBwwKTBszVOXhav1cCW1u37IsVWC08g2OZBYtVc6YMDEQ/adv4ejaFEnrW1nkSPrC1krpWiasjnyV7fzaVIkr45XcXWeMhHmJYtm/XWPNO++wsQiquK0LujqcnH69yGoK/eT3DSPj+RmVSx/JpCXd+qG9u4xsZ9sfcXh4ELQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ml3L/0UXeTIbs16XuZq6MfY8U8OjXJH56iMEWC1UtKI=;
 b=nACs6m4T1ECWOMTxqGh5ojgk1r8qSOtsLXBxGtaLAb1ONmRvce1Y04v5i/ZLLgZ7bYh9tVAmVkNDtNpjFFJUYa0yYXZwhgOZxIOJTjimDmkDQKdXVND4pGF/V/OD5zP/qjHy6q+PUyop/C9yWrev5he9AOiKFvdhhHngZSRxQgI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Date:   Fri, 20 Jan 2023 16:15:26 +0200
Message-Id: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: 69172148-9473-448a-d71f-08dafaf0d54a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ziCdJ/7Bnxj6NaZFOiI3K9viPahfIvd4Ppku8os5EZHoxUhOOl4bY1UybZufiK4fpa9fZR7zlohHK/Ri/fEDnE0OTWtTMT1Wv2AY616U0tmVeAl70urojd/LtTkfIt5PMNW/Ns/tbvGipEddH+7DdSYvPTW0Owrt+tOq7SloYefWGk5tYVTDXYo3Dz46VHLnwMW5DhanO1kciMChSOffR0RzsECfW3eYRXBoGJTI+CIWTEjzdqvrXpezLZembdWEincceIsYQrQAfmdeogmwBqCkReqol4qPgGrnhrqiptppbIlCWJQD/+u94VbhWBPQLWCr1iMmzOx41akY10D8Q5P2OXf6qvbpwJxWMio213pY7DgoULQbihy7U8sAkOSKzAPjmrtgmWZe9vqTasufg0esrbD9aMNczDRu47GDiJvb7MxTXi4zVWY/daY3BK5NU7YFBwlyoQGiCAJfYDmeUHpUOzp4oTfAiarMqf7TNwp3+I9pnekU0bWSmADj4dUYVCe+NHaxwz2jgFBuByoavG0gHPzz/0bSVsXVvqNUC73F8FT1cNH/f2vGN3RSCpDH/2RvxjHUkRXD5SvNEDg1AVSuas+5B2+XYrhNdHkBgTDLPg+lEd1gvGcKelBjwOw5aibQemPzSAUqHLqj523R7GpLjH/6r+v+cCneP0wjmohjrYJVwF2GmiUlr9oPwTukeGPwYFAPCsB1y0VME4q75s/Hi8TkQvpxpEtXyDiXX0s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(966005)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qsuCRwHauUq8l9klxKtDwtKtDzaksuDaUTXJ9OcwW3vqMP7zvNLwI4K4IOhf?=
 =?us-ascii?Q?bZ5DpvL1K46NWQeV+RrYppDpd9ArbW+VlRK1wgg+uJVy82Mw5XX3KUY+aO0B?=
 =?us-ascii?Q?7AuqAbo0rYP2vNEngL4c4XZEw6ns2VF4663FJvwDN2KiZd2RK+O1zGbZkMNh?=
 =?us-ascii?Q?IQN03LL0x+AqY5SzJbes5u4jFUK3Md5JBkBRNr8vpcFfl6oYT/rVbOEcCc6g?=
 =?us-ascii?Q?PidPXHnIMi3WzsfwIBCqjDPmakR9xU2/9oeT08xwhplF0Iuq4veAX/3yu/zR?=
 =?us-ascii?Q?dItEkW2rhgahhGYGA0uWRnc4qXM/BHyJtLAJmVBcwtn47LD44nv3AnDCNjdj?=
 =?us-ascii?Q?VKGdP1eJXvir6npKj+ahrFYl/idBu9cgk6c5k0/iDgAfoh0PrEgaQewUp+Hc?=
 =?us-ascii?Q?amOh83YWoiLOsl0gD644EXaxSkKoLuw485xHdn7idqqBLZydBJd3KWLP4Xre?=
 =?us-ascii?Q?K7NPfBWhHhBLFz3za26xCnShFN2jkTBnCPquzV0hv3X9i1Kbhr8/jIYX3F+q?=
 =?us-ascii?Q?mHHe6cDvYtD9yzYswdrh7Ud7AcNRRaG4rExOmwjQ4K0HSOpYlwYvwEhvRPoE?=
 =?us-ascii?Q?mu4zO/sbaUVjZ1PXZODHnmMfLaCD158dwiixMyL1UXNNx68ET9RRr4fdmWTK?=
 =?us-ascii?Q?GJXn0n+6YqlCtWiqKGQcu5PLRaPr7k8hSISpCXAV/tPLwLBOoq7iEnvCxuSz?=
 =?us-ascii?Q?TrmSPwtp80Kagkk/rVF+9TicTg7Q4lJyx3BhRrf7auAsTMPewZH1RFXy5fpm?=
 =?us-ascii?Q?ySHbf+8XTtDQG4CzpX/4J6PR6BMnAMPg3mMjmiA038R8ctVRdl6ZnkEbJmeR?=
 =?us-ascii?Q?lhOwBTobjPFFlleg/UeWzUJ7U+K8B2xrYe6khSqECiZdRHXnEmQHbJ7cDUnZ?=
 =?us-ascii?Q?kyZevBbdzK4dZB4LpnyOqy6zQqcIESK2kJTUReBbpUwSFZ7kzKXqzX38perJ?=
 =?us-ascii?Q?uUjsmlSEnazFVzBObJ+Ud+tiSGkkBINweQ5Tv5eYa4vF/Ln1sa/M82dxmWOc?=
 =?us-ascii?Q?xAfgvY8xh6tqRtnzmyvb2FEuWmQeKGtbL+Sz7GPs6ZksiYh4hCLtLGEGEEUy?=
 =?us-ascii?Q?Xo8oa+hq21k0q6wBQO5Nkdk+TNPVhzUQXufNKEJocIdfIMH2N248xQjsGLAA?=
 =?us-ascii?Q?SYXw8++7pGOZwJgNTFRSyAjeqj3CUfZxAVT92hLz/5NH/9lwxFI6OJH7Sj6M?=
 =?us-ascii?Q?cvCKEdARx7cqqJRLsDSomWmM3SemBuS6A9Z+nJstztkwL8D/VPQ8VXuS8U89?=
 =?us-ascii?Q?uw0Iv3cuvxNuSl1VQlA4BKmhp1rLi8xWYRKD23JrzTmNFpn0WxcpjwhbzdNv?=
 =?us-ascii?Q?Jdaas+HTqTety+P8RiueWvpZcF2QqUKR+b21BjSCFnbiBKaWIOkqzeiOfd+P?=
 =?us-ascii?Q?fcJfiSsjG2zJRQ/41GT8xCzRiOiRKDBadUDDf/GEKN2Wr2v2sf8VoAVWyW8x?=
 =?us-ascii?Q?Aos6uIcjMYmkPcamW+7QhLC4dm4ifSv3yWONwj89cSxHjBYL8TrFI97evLP9?=
 =?us-ascii?Q?jaOEgyJ9cOi0O7xAo3L+BgIYdA1+lDc30HlCmZXG6fjWMGrcHyzrUkQSkKe3?=
 =?us-ascii?Q?9jnSVo8qoYhMsHb3TV4AhXSXiPP6TmMKos+7pF/jYKpAyqPLtF3L8N2qr/E2?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69172148-9473-448a-d71f-08dafaf0d54a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:50.5768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rd9xIRBOIYeYxzfYSbIi4LtNMYU6lUkNpt56gBx5QVaVoAZ0cubvPwdzn4iENfWK/xXSUYnmR+127ABWTCggww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I realize that this patch set will start a flame war, but there are
things about the mqprio qdisc that I simply don't understand, so in an
attempt to explain how I see things should be done, I've made some
patches to the code. I hope the reviewers will be patient enough with me :)

I need to touch mqprio because I'm preparing a patch set for Frame
Preemption (an IEEE 802.1Q feature). A disagreement started with
Vinicius here:
https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/#24976672

regarding how TX packet prioritization should be handled. Vinicius said
that for some Intel NICs, prioritization at the egress scheduler stage
is fundamentally attached to TX queues rather than traffic classes.

In other words, in the "popular" mqprio configuration documented by him:

$ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      hw 0

there are 3 Linux traffic classes and 4 TX queues. The TX queues are
organized in strict priority fashion, like this: TXQ 0 has highest prio
(hardware dequeue precedence for TX scheduler), TXQ 3 has lowest prio.
Packets classified by Linux to TC 2 are hashed between TXQ 2 and TXQ 3,
but the hardware has higher precedence for TXQ2 over TXQ 3, and Linux
doesn't know that.

I am surprised by this fact, and this isn't how ENETC works at all.
For ENETC, we try to prioritize on TCs rather than TXQs, and TC 7 has
higher priority than TC 7. For us, groups of TXQs that map to the same
TC have the same egress scheduling priority. It is possible (and maybe
useful) to have 2 TXQs per TC - one TXQ per CPU). Patch 07/11 tries to
make that more clear.

Furthermore (and this is really the biggest point of contention), myself
and Vinicius have the fundamental disagreement whether the 802.1Qbv
(taprio) gate mask should be passed to the device driver per TXQ or per
TC. This is what patch 11/11 is about.

Again, I'm not *certain* that my opinion on this topic is correct
(and it sure is confusing to see such a different approach for Intel).
But I would appreciate any feedback.

Vladimir Oltean (11):
  net/sched: mqprio: refactor nlattr parsing to a separate function
  net/sched: mqprio: refactor offloading and unoffloading to dedicated
    functions
  net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to
    pkt_sched.h
  net/sched: mqprio: allow offloading drivers to request queue count
    validation
  net/sched: mqprio: add extack messages for queue count validation
  net: enetc: request mqprio to validate the queue counts
  net: enetc: act upon the requested mqprio queue configuration
  net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
  net: enetc: act upon mqprio queue config in taprio offload
  net/sched: taprio: validate that gate mask does not exceed number of
    TCs
  net/sched: taprio: only calculate gate mask per TXQ for igc

 drivers/net/ethernet/freescale/enetc/enetc.c  |  67 ++--
 .../net/ethernet/freescale/enetc/enetc_qos.c  |  27 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  17 +
 include/net/pkt_cls.h                         |  10 -
 include/net/pkt_sched.h                       |  16 +
 net/sched/sch_mqprio.c                        | 298 +++++++++++-------
 net/sched/sch_taprio.c                        |  57 ++--
 7 files changed, 310 insertions(+), 182 deletions(-)

-- 
2.34.1

