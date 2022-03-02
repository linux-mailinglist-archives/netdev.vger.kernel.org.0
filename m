Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECAF4CAA39
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbiCBQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbiCBQci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:32:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F328C6255
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:31:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzEG8KQlisaxoyYLoMV26UObVbLog0+IEfx6wMrD67R9pIE7ZcoEzfZyMGcwrb2wY96Ts2roxEQsnzYkPcHZYHBgfng/SqWWSHqlGOBvEyOzOjhF81uiQK3/9TI/Atf1WOH84mL6G63kE2POPhEDCuZnMkmwcgCU738Q+5Ycb2QPIhH61nfeOhe87b/BiwRVqx0CzS8yn4qhiIWO5o1NuzN901tuPJ3xq9tlPPCFK2U+5PEdmdx46eEpXIAKh/Syp8ix7wP9c8ybC5kkWSeb872c+W98Gj+MyECDJUXcDa3MuV/JNl6CjO08v7XPDq5Nax1gL3glczkWPCsiPHpiCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ov/4oQR6KUdCYI83RACUQpho3hPWqADTfCz1FnmQd1c=;
 b=GCvpCPqb3HZ45qgLXzOYnfrp4DHSp64vjoKk4CEzyz0Z7/SGeR13E8PFd1re7d13+6VSRoji0pGDvCFzu0xHayI/sLrQvZoPh4BcUKSK+M/zQnH1xobQFu88Xx5Q9t2HKb6IC+cuX41zypH5rhvGh1XZmnWy3TgANevUS6xCjvJzcyvIBVn9WOt3P3pjcPJQCZcffex+pCb8MLX9ln/Lsi5uLCeDrTJL8M+/eq5lwwpxRlqfOy6TpOgsmR1GduCIkq79cjghOJsYupBpGu6++my2TXpfKTKHxiHclvcWvEqhgm+kxHLaO+fvc4ARpdH+JFayYm74DXLCe6gGca6alw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ov/4oQR6KUdCYI83RACUQpho3hPWqADTfCz1FnmQd1c=;
 b=aidZz/HeVsHHowqcT659uSBEDsiq1oPs0DKZvHDn8o9aMB2QiSqWocrAkUmsIrWKQX/wMt6fBEDNr8CeKAsdpGJGri4N5ZWwJWK/HaZeXmDmAwMCB0KHYBRx0gr+hEFUtSHDDOBnPNHEalWE3d1KLizyI7alRn7UPjRVUzdGePMnUU/abUg7KLe4b7HB6WAfCpge+gxWwArLkuMIx84Gh1p+XmfWXBiSO54nWYdtqvJMuxgtW2hI74xbEieKKHKcqCOtSzW/ACEDT/X319E2uOu5qYK1qTjlSo3c+ePUaqBH/jjFDF2g8H3c2CKKZ2qAhPUataI2UG44y1UyTv9n+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1942.namprd12.prod.outlook.com (2603:10b6:903:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 2 Mar
 2022 16:31:52 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:31:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 00/14] HW counters for soft devices
Date:   Wed,  2 Mar 2022 18:31:14 +0200
Message-Id: <20220302163128.218798-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0191.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7feb2f9-8f85-43b8-04ac-08d9fc6a2817
X-MS-TrafficTypeDiagnostic: CY4PR12MB1942:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB19429BACE22A425C0DD9277EB2039@CY4PR12MB1942.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GW/lkF8OrjEbQvUo/8NKFf1t2uKYunREYpHxt+kLNmBTNDpjJbHeGBHDpu9eZ3HYc81SnL57fTpIH6CjzDoTGBAhxGs5nZGBnNwAPy/PiNPOQKJIxENPPbZJvbZS2ne4v1rnrBlMX+9Ft7Fna1v+DgCHPZ3OxGv0OfS4kJQFS+lT/n1fg0EorB5ywt3YNporeXez8zrGVW8fmF+7Tg8wmqEePLRd8VpQWCc1nilN/G4ArCudkygXI+Ft9alkGD0xuHC7Vq+ZCXv1UtO4nzeNJEMiw5BhiCY1eo3gSq8f7eCda+ryEbToL6tYp5ppvTjqwXon7db41YkJFmOyrSTHn2kYXggo53u+GmKRTrHO4LrFx8c9gZLuYq2dfP0kBSS55zo4VtjwFObAfF4aoZjT35V+2ozaeWCL0qeW7Uy0+HseiU4+N8ka4OY93i4mWrMTGd8eXPCWJzB2LYXBUssehxnmb5yubf4A4meXQCJrqK6j8tRzIzRn0i9/HNZLujATOHqC7RdJSt1Qm8whWNTF4bPMi5i79BQgFKlFRjDq3w+9F16tBuExHK17N4KOaqkcPDvm0oXlzWv+aqd3h457m/Gu03uca2ZyOKrN3r5n9gB3hLSEWDM5Sona4vPKWlX+huPG00KhtaESMx8ll9E9yNZkERQUmpSulSRaY2usNkfQyD+ASac8Im8u0TMIPdiCtBISFvrLmhU2tm9tY0LEZ2T6FS6FtRdocWIipA/UBoL/MiYqyaU/qHNlz19EAcy6FWLyLYox7jSjpmb7p1wIig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(36756003)(2616005)(86362001)(26005)(186003)(1076003)(6916009)(316002)(107886003)(4326008)(66574015)(6666004)(66476007)(6506007)(66946007)(6512007)(66556008)(8676002)(966005)(6486002)(508600001)(2906002)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YgAIJewysDA9Dzl2Zs8VRVIV8Vouz0SNVXZD6JvsrOoJHogwTtd+A1bGwRbB?=
 =?us-ascii?Q?saL3uB06LAlOE9QEN4Wu6DnXSyiU5qI5BL/Yu8EeHaMN3UtC5+nUMVtT7iKT?=
 =?us-ascii?Q?qMEdQufISFHi2ZRdngsUnh8uBAv5DIE0Qj9IgPPCCabC++hj6KY01TvCgZ0d?=
 =?us-ascii?Q?HuQWKojDJn8ta0qQgQI/+Uspaq13JKlsuuB31zPcA+RB9NpZDqPZmDNL8a4a?=
 =?us-ascii?Q?OIEJU09bj0Mkn4B1+Q2oqhcwP7QuHlzRhLXSnArMkKVoOI9qggAD4E67hfCT?=
 =?us-ascii?Q?lcmi2trlxOlLOYpXuQj1K4DRCYK+WblCZci9UCbxnDsppNu1OEYe7vBeFUq3?=
 =?us-ascii?Q?vqBCeBdUlSyG0ZZLOy0mtt6VNafTJWqRo6oYtux9yn/BKNxCCe6GMbWsQtEl?=
 =?us-ascii?Q?AW8VJaZtO6ankfC9sw8gS0R/iepvL+gfTMljfPcBlCJcCB2lZXDNKc30ND68?=
 =?us-ascii?Q?E9cSMhxwhtakS0CCTCxXAHo3Jv1pgJVNfNmhY7lY1iDQ3NV6BlHPnxpimqUU?=
 =?us-ascii?Q?xe8VPI26iRDO0t7r6liZbWoRNVIIcixwS7sAaILciYbRYiSkZwnWVAWJYWWJ?=
 =?us-ascii?Q?LFgNduM1swCJj1noQ3Jw8dNHJrQHhS3NlMUO1aJKvA1SJobA0rYkZiU8Veu0?=
 =?us-ascii?Q?iSGX1z0pnTghkiE2bgyKtjsfotBNPi8Lf0OyJBClBJ7cYlifnFsbJzaIIEPL?=
 =?us-ascii?Q?TA7s88BvdAQP+OtQuPT31dw/j7aOswKw/rQ9Wp1/Vdt5MXhki/RQpEE4dllm?=
 =?us-ascii?Q?sg7RzzxZZQHbdc+kh+Hr9Zxj48AXnBzu6fO4F8snclBqx4LqIvocnQi8E+4g?=
 =?us-ascii?Q?mJDEsUGImkhShoepPgtk70A4J68gyXLXe25lkrp8zH1z1J7TqkOw9Qmge0nX?=
 =?us-ascii?Q?XnMwm2qQZCZZosGuiOP50BbW8OISr0C0ViJHshsrFcsyz8Xiw6iO0j4JWDU9?=
 =?us-ascii?Q?KW/lFJTcAKpyAXTwKYWS0BdEaLXB3qlePF8V5bcFaqxAs65hu4sWBOy9be3d?=
 =?us-ascii?Q?0M+aP4OashaMM0x8s3ASzYigPLmrR9RB82PVXgNyF/LdU36TIdYeF0ESFYLm?=
 =?us-ascii?Q?dksv9eA1DBQisIj9CmUngbvcSM2ooBWQqXdUmSO9lQGVqrOjdySDdb5X0FIY?=
 =?us-ascii?Q?BR9C9wA5+BXv8wzZuZpORrX5m691PWNLasgVgslymx4r6a18gm3o/qjFMtXy?=
 =?us-ascii?Q?MvrL65hBBiFfmhW31qsSzi8BwAyi8Cw4uS6fCtKKHvqd39h+nCj/+/NkRl8X?=
 =?us-ascii?Q?MCJxes1zRD0N88gGa61ueUx3kXhs7v3hcn0Y+stnufUXKA5y9HgKIVfAW/FF?=
 =?us-ascii?Q?cz5MpEamCseYptPFKFKfRKXunZ/O0E1lrtP9j3INIwyURKckpEQuM246CRBk?=
 =?us-ascii?Q?vFzCRrr4acC+qyhBSF+LnH3RiCYqeGjuyI+ZJDi5veC4yJuvcRRLwIUp7A1V?=
 =?us-ascii?Q?it1hj+jbymWBNn/Wpa6GTVzIXOYUFfpr2/i2Q+cxZbL1KXsmi04Twu14EM9b?=
 =?us-ascii?Q?Yxov3pwcpoELbe1UWCCn7mpxfPXjTfPh1v6rdxVbcaONBKhiy2xJ1x2UnsQx?=
 =?us-ascii?Q?VfnlLxp2Qk44PQpEl7w88KBhG3zRYhWQ/etCuEip1KfcSI/0mNbXzFb6+X74?=
 =?us-ascii?Q?M06CGbACsmK3cv3Nn/MyhLQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7feb2f9-8f85-43b8-04ac-08d9fc6a2817
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:31:52.1309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwC7TPabYEU/NjASwkuMOAPqgOcnt0SIF8p5gUTjHoFiIUh2QQ7DY2RoDDbYt3+nxM0K8uI+d8WTxt8YwLfD8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1942
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr says:

Offloading switch device drivers may be able to collect statistics of the
traffic taking place in the HW datapath that pertains to a certain soft
netdevice, such as a VLAN. In this patch set, add the necessary
infrastructure to allow exposing these statistics to the offloaded
netdevice in question, and add mlxsw offload.

Across HW platforms, the counter itself very likely constitutes a limited
resource, and the act of counting may have a performance impact. Therefore
this patch set makes the HW statistics collection opt-in and togglable from
userspace on a per-netdevice basis.

Additionally, HW devices may have various limiting conditions under which
they can realize the counter. Therefore it is also possible to query
whether the requested counter is realized by any driver. In TC parlance,
which is to a degree reused in this patch set, two values are recognized:
"request" tracks whether the user enabled collecting HW statistics, and
"used" tracks whether any HW statistics are actually collected.

In the past, this author has expressed the opinion that `a typical user
doing "ip -s l sh", including various scripts, wants to see the full
picture and not worry what's going on where'. While that would be nice,
unfortunately it cannot work:

- Packets that trap from the HW datapath to the SW datapath would be
  double counted.

  For a given netdevice, some traffic can be purely a SW artifact, and some
  may flow through the HW object corresponding to the netdevice. But some
  traffic can also get trapped to the SW datapath after bumping the HW
  counter. It is not clear how to make sure double-counting does not occur
  in the SW datapath in that case, while still making sure that possibly
  divergent SW forwarding path gets bumped as appropriate.

  So simply adding HW and SW stats may work roughly, most of the time, but
  there are scenarios where the result is nonsensical.

- HW devices will have limitations as to what type of traffic they can
  count.

  In case of mlxsw, which is part of this patch set, there is no reasonable
  way to count all traffic going through a certain netdevice, such as a
  VLAN netdevice enslaved to a bridge. It is however very simple to count
  traffic flowing through an L3 object, such as a VLAN netdevice with an IP
  address.

  Similarly for physical netdevices, the L3 object at which the counter is
  installed is the subport carrying untagged traffic.

  These are not "just counters". It is important that the user understands
  what is being counted. It would be incorrect to conflate these statistics
  with another existing statistics suite.

To that end, this patch set introduces a statistics suite called "L3
stats". This label should make it easy to understand what is being counted,
and to decide whether a given device can or cannot implement this suite for
some type of netdevice. At the same time, the code is written to make
future extensions easy, should a device pop up that can implement a
different flavor of statistics suite (say L2, or an address-family-specific
suite).

For example, using a work-in-progress iproute2[1], to turn on and then list
the counters on a VLAN netdevice:

    # ip stats set dev swp1.200 l3_stats on
    # ip stats show dev swp1.200 group offload subgroup l3_stats
    56: swp1.200: group offload subgroup l3_stats on used on
	RX:  bytes packets errors dropped  missed   mcast
		0       0      0       0       0       0
	TX:  bytes packets errors dropped carrier collsns
		0       0      0       0       0       0

The patchset progresses as follows:

- Patch #1 is a cleanup.

- In patch #2, remove the assumption that all LINK_OFFLOAD_XSTATS are
  dev-backed.

  The only attribute defined under the nest is currently
  IFLA_OFFLOAD_XSTATS_CPU_HIT. L3_STATS differs from CPU_HIT in that the
  driver that supplies the statistics is not the same as the driver that
  implements the netdevice. Make the code compatible with this in patch #2.

- In patch #3, add the possibility to filter inside nests.

  The filter_mask field of RTM_GETSTATS header determines which
  top-level attributes should be included in the netlink response. This
  saves processing time by only including the bits that the user cares
  about instead of always dumping everything. This is doubly important
  for HW-backed statistics that would typically require a trip to the
  device to fetch the stats. In this patch, the UAPI is extended to
  allow filtering inside IFLA_STATS_LINK_OFFLOAD_XSTATS in particular,
  but the scheme is easily extensible to other nests as well.

- In patch #4, propagate extack where we need it.
  In patch #5, make it possible to propagate errors from drivers to the
  user.

- In patch #6, add the in-kernel APIs for keeping track of the new stats
  suite, and the notifiers that the core uses to communicate with the
  drivers.

- In patch #7, add UAPI for obtaining the new stats suite.

- In patch #8, add a new UAPI message, RTM_SETSTATS, which will carry
  the message to toggle the newly-added stats suite.
  In patch #9, add the toggle itself.

At this point the core is ready for drivers to add support for the new
stats suite.

- In patches #10, #11 and #12, apply small tweaks to mlxsw code.

- In patch #13, add support for L3 stats, which are realized as RIF
  counters.

- Finally in patch #14, a selftest is added to the net/forwarding
  directory. Technically this is a HW-specific test, in that without a HW
  implementing the counters, it just will not pass. But devices that
  support L3 statistics at all are likely to be able to reuse this
  selftest, so it seems appropriate to put it in the general forwarding
  directory.

We also have a netdevsim implementation, and a corresponding selftest that
verifies specifically some of the core code. We intend to contribute these
later. Interested parties can take a look at the raw code at [2].

[1] https://github.com/pmachata/iproute2/commits/soft_counters
[2] https://github.com/pmachata/linux_mlxsw/commits/petrm_soft_counters_2

v2:
- Patch #3:
    - Do not declare strict_start_type at the new policies, since they are
      used with nla_parse_nested() (sans _deprecated).
    - Use NLA_POLICY_NESTED to declare what the nest contents should be
    - Use NLA_POLICY_MASK instead of BITFIELD32 for the filtering
      attribute.
- Patch #6:
    - s/monotonous/monotonic/ in commit message
    - Use a newly-added struct rtnl_hw_stats64 for stats transfer
- Patch #7:
    - Use a newly-added struct rtnl_hw_stats64 for stats transfer
- Patch #8:
    - Do not declare strict_start_type at the new policies, since they are
      used with nla_parse_nested() (sans _deprecated).
- Patch #13:
    - Use a newly-added struct rtnl_hw_stats64 for stats transfer

Petr Machata (14):
  net: rtnetlink: Namespace functions related to IFLA_OFFLOAD_XSTATS_*
  net: rtnetlink: Stop assuming that IFLA_OFFLOAD_XSTATS_* are
    dev-backed
  net: rtnetlink: RTM_GETSTATS: Allow filtering inside nests
  net: rtnetlink: Propagate extack to rtnl_offload_xstats_fill()
  net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error
    returns
  net: dev: Add hardware stats support
  net: rtnetlink: Add UAPI for obtaining L3 offload xstats
  net: rtnetlink: Add RTM_SETSTATS
  net: rtnetlink: Add UAPI toggle for IFLA_OFFLOAD_XSTATS_L3_STATS
  mlxsw: reg: Fix packing of router interface counters
  mlxsw: spectrum_router: Drop mlxsw_sp arg from counter alloc/free
    functions
  mlxsw: Extract classification of router-related events to a helper
  mlxsw: Add support for IFLA_OFFLOAD_XSTATS_L3_STATS
  selftests: forwarding: hw_stats_l3: Add a new test

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   8 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  20 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 305 +++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   6 +-
 include/linux/netdevice.h                     |  42 ++
 include/linux/rtnetlink.h                     |   3 +
 include/uapi/linux/if_link.h                  |  37 ++
 include/uapi/linux/rtnetlink.h                |   4 +
 net/core/dev.c                                | 267 ++++++++-
 net/core/rtnetlink.c                          | 522 +++++++++++++++---
 security/selinux/nlmsgtab.c                   |   1 +
 .../selftests/net/forwarding/hw_stats_l3.sh   | 332 +++++++++++
 13 files changed, 1458 insertions(+), 93 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3.sh

-- 
2.33.1

