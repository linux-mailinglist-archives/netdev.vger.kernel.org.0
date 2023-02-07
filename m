Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8129468E009
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjBGSbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBGSbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:31:35 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2081.outbound.protection.outlook.com [40.107.8.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386973E600;
        Tue,  7 Feb 2023 10:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvGmqn1Ebs/d7kTYs11LqcmkLSzEQExlwyviwNqqVo0S6vijjVhks+GLFWvhgfjp6BXPwLvA6rioFVz6LeLCGJoo2YOzKOPacB8vADN4+NJP6hEZZJCMbeTWC7Tj78ADq1R7iVKGEpPl2iVZpoZiRXLQXC0TuJzUr6BaQQBa2nGDEjhkfkju+8SSCuFQu6Mq4Q8bpKeCpUIf2/hOoGpZpiuMUy9EffmWwokg0UjuN3dqzwPVnOGhkEa3Bi4d/e4Hn6L1MKmxyT02ROXGz50TGnWOcYnKXtPtUrDxb/t5ePGZYW7vMVfwvdbzdZYDpgn/uVVcbn0ceLMzrIP5D7B8YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXYzPSLiWlEPWSZM4SlTg/FK7UtxZOpnWOO/1D8Hf1c=;
 b=YfopKMsZpPr9V1Ygw394ZdBN00afdL+JWBwksPNwh7XvgKzurX57EFItIbPRdzkCSepPukVGjzkA/NWjLNrp0wHEiHiZIkLNMceFzvqFeSS6kU/vh1Vf5D5e34iSrxF8Yn1AiMkQD37cMRcxq9phPbNdf9s71cj2ySjUJxWN2l+hqJpV5YpDLWG7SHKn7Xly8CL6MUFkXpFRyeQoLik9/9+PQoKdb/2aGmq5aUDoB6lai00Wz39yWewNhMCeAciKTm211pnPsgODpLM6HBiA0ZzVFIacd7beKtlckR+yz9i77oib00gltTLJ68jB/x8RtQ8z7k5A5pVAg/a65OyNFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXYzPSLiWlEPWSZM4SlTg/FK7UtxZOpnWOO/1D8Hf1c=;
 b=ETiutKMhjCBmNymXRMVDDIC5PnSngTznVkmL/O0HZfIhLBY/uiEZtkEo5GlYofKTP8QuiuHmW/XIILy0WYqDEaWUHb6xwgYlzS/zkfTnOV93wDmt+mM+f4jjLIU0nTcNrTh3fNEHAk6ZhIzVE2oNqkj2rSKw2WybUKDnnhK1Nyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7134.eurprd04.prod.outlook.com (2603:10a6:800:12e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Tue, 7 Feb
 2023 18:31:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 18:31:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>
Subject: [PATCH net] net: mscc: ocelot: fix all IPv6 getting trapped to CPU when PTP timestamping is used
Date:   Tue,  7 Feb 2023 20:31:17 +0200
Message-Id: <20230207183117.1745754-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: db7346de-5cdc-41dc-1fb7-08db09398831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghB9Y+J95SLXa1rZuasXlFNrUKlpnUrARWoG8szc9DI4JlhNW598/bMmNbo834mVKL3ycLuIcx0cAwQXSVR33ANmobfw4AYVP6YcKfqjOgfvQDQFRgzR4mhfrvLsePJAFq/8r+PIvx/WptOPELB/lNpVAbryp5pURQ+uv3q1KtM2u7S3J/UjkOeXhwbX4tMFdf42cwOqo62/A45kgxOAM4fClFP0DzteROQBVVSmBAfDfg8vPBYTzFIO/irnWftz1aq+MFwedk6nOyQHdpJlZX4V13A3fs/CkIYiEas/QHzcj2ZXfs9H8g8OmnoEPFZCsMiSMZmuU/8Dt0b93i3F4E4NxSiZL2M4vQzs5EfeCkVC4qw4MSDY1d91TyX+oIntEVTctXs5L4R1KD/QBl+cWkiWjzYUtrINW4QHP+itjRFhNSwO0FCYMyFCp3B15eaKH9MCmL5Kl43OXVQeKfczRneO51rA7qmoIHFzsVwVm3LKsGzUu63hC9T7v03AVSKw1zIwkObVMUDwyvIbxJMR6pEVnAtiXNckSRynHW/PAOre9C9cSXGV/d7Z65SVA3Yg39KC9KTT6n9y2jmAarbfteDprxxThV55WaAFwREytIh6kto5rfLFaoVtL/7WmfSAqMQK1c95BsvpAljLXQoq0/IBLEKSlZmY5YrERY76oDN+9QYBbT9MEkAjpAR6f1Dfnr/lhjxgQWhXEN3+Y9qTvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199018)(8676002)(38350700002)(38100700002)(316002)(83380400001)(66476007)(8936002)(6916009)(66556008)(41300700001)(4326008)(44832011)(2906002)(66946007)(7416002)(5660300002)(6666004)(2616005)(6506007)(1076003)(6486002)(478600001)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jCbgHcezQHQQCmzvt1Y51p3ziWOb3XjF2JcCSPn/fJ4OmHyI22y7G2/anXZB?=
 =?us-ascii?Q?sRqPtnIKxgBczTSGB1sJT0VQyEk5xz623sQKLadfuUl9rGSFFqmH+mwviVCe?=
 =?us-ascii?Q?ohgB+q4gs2gURDGgfjhmun5U9QhKI7UvHejY6dW31iX0wEjBGg6lfenpzXCf?=
 =?us-ascii?Q?42UD6PGu0HpjRCpGVM7iA9qoIrMthBjDZj6raLfiG1kK9Ab42STGSdLTvjqi?=
 =?us-ascii?Q?84MOXIQjPJDGqogo/wtKG2YVjLzfkbW0bVSMF0doakwyMb59ix9lCodrSD6T?=
 =?us-ascii?Q?SMkeic8zjFQVaNvbBoZLQEqvqUPV5IvIiUzER6ghp3/e4pwE9qr5xlbyigFZ?=
 =?us-ascii?Q?gW0BkBGcI/kkUGiknoSisMb+IcXywpmK4WFk6D7qFKko0XihJGiUZcWA8uqr?=
 =?us-ascii?Q?pYFWpJHdwW9B04NGVVS0Rm3QxV8/Kfd+7x8hHtPqgcasIC2BnIG73hSjSNP8?=
 =?us-ascii?Q?4oEZ513lfUvQ8zOuBelVY9WsLk3Ap4MZqgx59X4GuDXp3y5XZ0KdCRjeu87P?=
 =?us-ascii?Q?HR7Y9LFP2HDs0ibFNFpDrGYO/W4E/g0wFOtcjCMo8cTcWPjK3Wn0Pwb9HpZN?=
 =?us-ascii?Q?a2jru15SNnx3uKROZGAkRbxrsQLwPWxoVv5UUTNxVLNycBlmoJYBlP+4LzEw?=
 =?us-ascii?Q?X6jQqDnYmv8oejpBM+fzkuCvzGDvtePaiXbE9BOxwk15LHTfilfRvgdMkF1g?=
 =?us-ascii?Q?l0/doN2zYQg/lKcaOTLtfNf1YhM7XzudaSi6oPBHU9oNbany01FUD18R7VY2?=
 =?us-ascii?Q?OLyPZZaodFaapTe7P33yaGsPx5DURcLEKZGa39SW3vLjpe5eBdlgAtMFfnRH?=
 =?us-ascii?Q?1cMPawJCp+f8Ieu9SpCA7m7Yy0fAhyq2YpEwF62jS/zsoKULr5wsCvtH+COD?=
 =?us-ascii?Q?eS+kNRo5PLAvJdL60Hzp7LIfTWIJ0GsmUBkLL1mzrAME9NNjzsRNMuPnDnab?=
 =?us-ascii?Q?BJ4uFbSpN5wlqCBqzR6v40kd2bceQdMt6m+wBWX8KsqPydmI1fMMIfj71Wnb?=
 =?us-ascii?Q?G/hrviMr04iUhzGgPqJGvlTwtCj37+Wi6g6tCjdYm9LH48/hFZKkG6cT4596?=
 =?us-ascii?Q?8z+4EtUHjkpwuF7QDQ9/IP98pps3Jdf0SkHGnlRsjnvkI0oQVK6hcIXVTvDT?=
 =?us-ascii?Q?uMH5VZFg/wbQspVaLWRZUfY+zhTweBSa1YNKj7jAb3VUKnriwzCeWSpy5GZU?=
 =?us-ascii?Q?6cAkQyfGNHOdMgJS1XcXsansIACfLtTe1m5SjuxyHLuqUKcoAQ1hv32y8/um?=
 =?us-ascii?Q?NXTGtwwwwXeaxal/t1xAudWWh5wh3kJ9a3I9X1dRHLbdtax4rdYOkJbOEKWd?=
 =?us-ascii?Q?Z2ns+e0Eh6BsvIa7N8rDH4UG/KIJBK+zmO07jjJo7acqKg9NCqOcWJNVdZY0?=
 =?us-ascii?Q?moZhc8ngN4QHdSud/ncPocVt5RcI4ZR5mqGSduyHNqFrbV93GC55B8mnOrVP?=
 =?us-ascii?Q?bUblzVstDA0ZeEkTHH8J4QJJeXp3U0HUdmLxAfUUxPwUtg3m+NBpcpsYG7RK?=
 =?us-ascii?Q?1FprPiabYUZiCn0tGILmZKSTELIcPjrdqY1/Q6A8+gJrpfj6BZHnuGsJZ9FF?=
 =?us-ascii?Q?g668em3Q3+8c/4ugI+qegM8t4t8gO73+/oDTwoKVAXfd6vaCnrVENk6pxLGW?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db7346de-5cdc-41dc-1fb7-08db09398831
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 18:31:30.7482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tJn2Td4BPB+PfbMsD8pfDjex2wTT4kNjoBPHm2au982eciPylwYTMnHWvrtJ5c9PgYSSMWGyEOIBAW2nQXjI1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7134
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running this selftest which usually passes:

~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]

if I start PTP timestamping then run it again (debug prints added by me),
the unknown IPv6 MC traffic is seen by the CPU port even when it should
have been dropped:

~/selftests/drivers/net/dsa# ptp4l -i swp0 -2 -P -m
ptp4l[225.410]: selected /dev/ptp1 as PTP clock
[  225.445746] mscc_felix 0000:00:00.5: ocelot_l2_ptp_trap_add: port 0 adding L2 PTP trap
[  225.453815] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_add: port 0 adding IPv4 PTP event trap
[  225.462703] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_add: port 0 adding IPv4 PTP general trap
[  225.471768] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_add: port 0 adding IPv6 PTP event trap
[  225.480651] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_add: port 0 adding IPv6 PTP general trap
ptp4l[225.488]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l[225.488]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
^C
~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
TEST: swp0: Multicast IPv6 to unknown group                         [FAIL]
        reception succeeded, but should have failed
TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]

The PGID_MCIPV6 is configured correctly to not flood to the CPU,
I checked that.

Furthermore, when I disable back PTP RX timestamping (ptp4l doesn't do
that when it exists), packets are RX filtered again as they should be:

~/selftests/drivers/net/dsa# hwstamp_ctl -i swp0 -r 0
[  218.202854] mscc_felix 0000:00:00.5: ocelot_l2_ptp_trap_del: port 0 removing L2 PTP trap
[  218.212656] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_del: port 0 removing IPv4 PTP event trap
[  218.222975] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_del: port 0 removing IPv4 PTP general trap
[  218.233133] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_del: port 0 removing IPv6 PTP event trap
[  218.242251] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_del: port 0 removing IPv6 PTP general trap
current settings:
tx_type 1
rx_filter 12
new settings:
tx_type 1
rx_filter 0
~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]

So it's clear that something in the PTP RX trapping logic went wrong.

Looking a bit at the code, I can see that there are 4 typos, which
populate "ipv4" VCAP IS2 key filter fields for IPv6 keys.

VCAP IS2 keys of type OCELOT_VCAP_KEY_IPV4 and OCELOT_VCAP_KEY_IPV6 are
handled by is2_entry_set(). OCELOT_VCAP_KEY_IPV4 looks at
&filter->key.ipv4, and OCELOT_VCAP_KEY_IPV6 at &filter->key.ipv6.
Simply put, when we populate the wrong key field, &filter->key.ipv6
fields "proto.mask" and "proto.value" remain all zeroes (or "don't care").
So is2_entry_set() will enter the "else" of this "if" condition:

	if (msk == 0xff && (val == IPPROTO_TCP || val == IPPROTO_UDP))

and proceed to ignore the "proto" field. The resulting rule will match
on all IPv6 traffic, trapping it to the CPU.

This is the reason why the local_termination.sh selftest sees it,
because control traps are stronger than the PGID_MCIPV6 used for
flooding (from the forwarding data path).

But the problem is in fact much deeper. We trap all IPv6 traffic to the
CPU, but if we're bridged, we set skb->offload_fwd_mark = 1, so software
forwarding will not take place and IPv6 traffic will never reach its
destination.

The fix is simple - correct the typos.

I was intentionally inaccurate in the commit message about the breakage
occurring when any PTP timestamping is enabled. In fact it only happens
when L4 timestamping is requested (HWTSTAMP_FILTER_PTP_V2_EVENT or
HWTSTAMP_FILTER_PTP_V2_L4_EVENT). But ptp4l requests a larger RX
timestamping filter than it needs for "-2": HWTSTAMP_FILTER_PTP_V2_EVENT.
I wanted people skimming through git logs to not think that the bug
doesn't affect them because they only use ptp4l in L2 mode.

Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 1a82f10c8853..2180ae94c744 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -335,8 +335,8 @@ static void
 ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv6.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_EV_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
@@ -355,8 +355,8 @@ static void
 ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
-	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
-	trap->key.ipv4.proto.mask[0] = 0xff;
+	trap->key.ipv6.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv6.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_GEN_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
-- 
2.34.1

