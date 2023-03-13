Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EAB6B7B39
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjCMO4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjCMOzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:55:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DB412866
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4r1ucPQLycnfR+9pSHUnUbu0GjCBgIykntWLM0L+SfxYu99Om2+BW3lf0K5DqJhSc08kivArN3mIr0F2IY9T3kbqxEQSNImyyx3hrDD/XlwKFjhEp4DHll1xyyV8naaa+bRg6NwOSxyNeipkpBOU6IQd7LTkMLCtFYL56yNXtQUS0kqC6kmWiztm84EgqwJTwgLr+QxzE3Osk4LCHxLaUhn85sZY+7HpGfwMEenwG7+RXw2qMSuaBAzgPgiTwQxn9e6rP0KmKDWPXiY+Q+vw4Kelu2WdWFyTtTMsn8QQR7uZOBxQK7GqGVveDvb7U7oGZGmrtH9MGSOJcT0NRx4tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kw/A6aRR7w4f7luwdrzzzDDo8ekmSK6/dM7h+W39FpA=;
 b=RFewiVrMhyGObOSYdsK2w1Ts88gJhKyDgCXI1VOS4SD0FMqAFk9OlBKPombrB6XoSE5Oj46yaVddQr58zbWPTJCbNX6R6wpSAcEeKGohwsmgjSkLABvGxShMC0MXAlBtifA6yzTB3aiMRFSGxKUkewRi2TW99uNLY5WNxO1NHuxqIdpHoF+NSO0Yr7K9Hua7/NrXQ/K1/9DkmZ4WtfvDb8AwmnMdJpWHLzpMO7VenT/hu81GDfyU+l7+TqjMS7EVRq42LqDem20QHjmJtzx71S0Y9xHFn7yFctGFO39P45stiU4TLG42Trsk/jXLYLjBsgQERegIEgrePuq+YAyA8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw/A6aRR7w4f7luwdrzzzDDo8ekmSK6/dM7h+W39FpA=;
 b=XTDOXwAWLSwZdMZ49W94PzC0xmhbsBgLA7P48oQCt1tjBzVswyXCBIHWcHyzIpB9Zm0xQd0+DBwAJzin1oeNZna0xebboTLqN0JZ+Sz36iNWKJ5VqiO6+kkN8MCbxwUYNZp2IuD5wL/9T618wlZny7yjfaJJmhp1zqRmiMA3yQJ1XojbHjru5OlCp1JJOcqXQAvDC0peyA3VEj6FNcM3wbaEaueKWr0pl68c7uMDDPV+M4iN/H0E1VFuTlYaLcdFHRK5nzCNQ6amCES1cEP8co7EvrWvghfwGEAETUa5GoUYgJVHqB9ugcl1CBYQCwJjCGgFjyFJJxl89L0SEdP5UQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/11] vxlan: Add MDB support
Date:   Mon, 13 Mar 2023 16:53:38 +0200
Message-Id: <20230313145349.3557231-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5269:EE_
X-MS-Office365-Filtering-Correlation-Id: 998dd2c5-80a0-48c6-d68a-08db23d2ee1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8MrpjXFhAA5Cj06Mhd8pEcbovNE9nj3JZic4RARHlB/Y5xspJGlWMmvvuUX9Gok5xitVZq0JHvJh/klMK7G1eSzxCPX1QND3ft4Fvo9P0Y6IFzXn9A+bX4ZI+iXY1t/Kfil5mbye7eXK6Te2t+YMTGN31O3nev7SG2PaluB8GrqYsWefQnZaVKSlpdcz9EI5zBg+B6ttX27vS7MWm3QVR5sdk+TEXHkuhdaZDokIT+Tj6JfyoY8bt8hzV+xP9IfeAiNWxexYQqOg4uYIlPfHQ4R5kTWJoC789WrASKxkNzmVLwo6GhhdPrF4s/NjlhIDUNV2eGUUWYBPQZgcHrHharSE9JUfQUfPXyH0i7NvlmZbULWJyMvBBBqL/uG+ek8aJFR8itUXOC5tYF4cdXJZZl2ApHN71P3fLUtZgpvSlkJf9pkZoo6QbmjdBFT6zlwRvdGr/AyyjiVo/nJ6uH001qat5UuI+UsjnVDIFfF05DNxUTjp3SaxWz0oAHdwvSpq0gE4Qzpw69vcc2dVOmo13zpHeAKhiN+CjHcXPx//7Qmorl7xZjeEEKf7D+TbymYZwQdPkispV6mWK4Ew9mdDwwOQMbYiokIuGVWe/C7VMhzYRpuq+RcgLYWIiqSsu0r78MLf5HLINbhqaoWEpPnLHwiZ8XQrK27/n3iWsfSD0fKsyYoqnZvr7IcLdA1s4I12UiKK6Y5LVLqoTOE5TwlPbLQIQAVnd2c7WrunIhkoyQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199018)(41300700001)(66946007)(66556008)(66476007)(8676002)(4326008)(2906002)(316002)(478600001)(36756003)(86362001)(38100700002)(966005)(6486002)(5660300002)(26005)(6512007)(1076003)(6506007)(2616005)(186003)(107886003)(6666004)(30864003)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clGsdtk0UZ3fF5+hquvJXhQMh2T5auh761hXJqz5+T+OmFUWrJRHZHM4tTPx?=
 =?us-ascii?Q?yvt4pnzMou6y+xzzs2BUqGAMOQ9qCzn1mfsvXrDj1/pobg2zsX6aS7vdKbjn?=
 =?us-ascii?Q?2vt7kr7kWkC6zMcb8NtjTaXL5PWerXk4FyG5LELuWt0CRnDmJjHrq9jAxscs?=
 =?us-ascii?Q?HLrD+q5mAiObIaBd1rGFTivtBmHkl3eVFIeIFf3a/9dGTH8uFgCnoCL/hy03?=
 =?us-ascii?Q?slUNHDMDY3pBJIpMoS+IE1TYUFmXOmuOiekHQzHb3sc50wdyhzaRhcQStX7T?=
 =?us-ascii?Q?or4AIl96G3VJ1SyTghgdYVQRMU5XQSoYmonOjqdE9hq44M45hhDk34O1mYYa?=
 =?us-ascii?Q?rC8Dr33vHLoSaOebtbO1qGcdVGwU81SYz+mZaMc7hgk56RZicKFcGVLHFjW+?=
 =?us-ascii?Q?e17oWB2T33QARiBPBmTIzJIgTyI5juW0haF9gvKZnBmENq0piWPCrJRSQkNp?=
 =?us-ascii?Q?q3jupflBdS94IRRdBFuh19cUCuzqMrexZk8/2AAF+J7bomFmnDIWjCkJucKg?=
 =?us-ascii?Q?3nIqJ7XDCfT7nveRcEoTuW/qUeJU8oEOrL8JwqkvVFQOCHhjY95Kiubvzz3x?=
 =?us-ascii?Q?xqenGUaSO4oVQ0jOb59OgqnMvRdPxCcFRQqjMhb4mljYZ2hssGjIdgSQfOqF?=
 =?us-ascii?Q?e1+ylWtlcijlCuEpX7O1R4iS15oPDK5Z+26GRoRDPqWBB4K+lsv85jQkOWhp?=
 =?us-ascii?Q?NTDoWvfaq84RhklQLRAqObSNQMBaxDX3f9kJzcoS7bJbZ0oWXE+v6Mj/EIpq?=
 =?us-ascii?Q?muv2J/KaeZBUWrS3br5rxlI1XY2Famh0XnZl42ZkQi2U9PJK/Xy6zU+k27AQ?=
 =?us-ascii?Q?kIVPBwGTdbTRn8suldyIAYS1eFslDA5rdHngmfROV56TWG6XsT+laXfbTUqw?=
 =?us-ascii?Q?2ytdx3buDaKj8xO574l5uGsj0T4d6EOyK6hmEcJqCqeqBwkIfpwz4EGswSWs?=
 =?us-ascii?Q?1dbTs1Zt5Tlot1DxGtk8CF+2bThKCyAt+PD8NHyI/v3sRWR1diQyoTBjB12i?=
 =?us-ascii?Q?53V5AjC6QN4UeVBDk10mo1WR29wVShd2X5FuRB7U8M3dAQ0njRd+95NTfb6+?=
 =?us-ascii?Q?8Y755W/hh12h57bhL6s1d2mNcDYV23bTDY0uTo+pb8QU457LN5BTG415oRMU?=
 =?us-ascii?Q?B/WYw3zVV+CwJ/XhKrgOeuLqJfu0V9emVzupdD4MCppqqJdAOemmTjK1n2Cf?=
 =?us-ascii?Q?6d94+2Bx/bBiDNfuC/nMZSshIG+XTpzcuWKZxU0Y+NUvdeippsG28vPDLhH9?=
 =?us-ascii?Q?c5MfGZfy/o5LpnDcv+qmFIDEJliohVwc0YJ89+uGpfyu9gpBFD/rIjqEe9D/?=
 =?us-ascii?Q?EpTsqFjqE7ZtqoYWYz3NTALZYHX08RmVIykzpwTDMd6wNFaX8e6lvKveWCCF?=
 =?us-ascii?Q?6bFes1df3rYQ3IOINmAjkeyBHWfxVXWcIuP1tWDHmvotDPS1EB3m2TaHjPsJ?=
 =?us-ascii?Q?G2sbsQJ30guB3aeqq0e/lUVAK0xpHqlMHigfTbkQFGMtD6wFcOploRxdC4rL?=
 =?us-ascii?Q?3j+zPyjFPh/1JCNJBBK6rOF9sm7ejmLAJA/y64DxU/PxlRtplFJhM7Lx/I16?=
 =?us-ascii?Q?jy2Rdum0Ch3TSW4XbZNoRwyi+3FtMJaX6HaK8NkN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998dd2c5-80a0-48c6-d68a-08db23d2ee1a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:05.0241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X12HXC4V5qWz9X6AFggXXuPfctQhwT8CSP6XOUlIXRORcJ2aLzmr61+6A6EWvzn9/H7RgJSanJVSRFoaBJ0IJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tl;dr
=====

This patchset implements MDB support in the VXLAN driver, allowing it to
selectively forward IP multicast traffic to VTEPs with interested
receivers instead of flooding it to all the VTEPs as BUM. The motivating
use case is intra and inter subnet multicast forwarding using EVPN
[1][2], which means that MDB entries are only installed by the user
space control plane and no snooping is implemented, thereby avoiding a
lot of unnecessary complexity in the kernel.

Background
==========

Both the bridge and VXLAN drivers have an FDB that allows them to
forward Ethernet frames based on their destination MAC addresses and
VLAN/VNI. These FDBs are managed using the same PF_BRIDGE/RTM_*NEIGH
netlink messages and bridge(8) utility.

However, only the bridge driver has an MDB that allows it to selectively
forward IP multicast packets to bridge ports with interested receivers
behind them, based on (S, G) and (*, G) MDB entries. When these packets
reach the VXLAN driver they are flooded using the "all-zeros" FDB entry
(00:00:00:00:00:00). The entry either includes the list of all the VTEPs
in the tenant domain (when ingress replication is used) or the multicast
address of the BUM tunnel (when P2MP tunnels are used), to which all the
VTEPs join.

Networks that make heavy use of multicast in the overlay can benefit
from a solution that allows them to selectively forward IP multicast
traffic only to VTEPs with interested receivers. Such a solution is
described in the next section.

Motivation
==========

RFC 7432 [3] defines a "MAC/IP Advertisement route" (type 2) [4] that
allows VTEPs in the EVPN network to advertise and learn reachability
information for unicast MAC addresses. Traffic destined to a unicast MAC
address can therefore be selectively forwarded to a single VTEP behind
which the MAC is located.

The same is not true for IP multicast traffic. Such traffic is simply
flooded as BUM to all VTEPs in the broadcast domain (BD) / subnet,
regardless if a VTEP has interested receivers for the multicast stream
or not. This is especially problematic for overlay networks that make
heavy use of multicast.

The issue is addressed by RFC 9251 [1] that defines a "Selective
Multicast Ethernet Tag Route" (type 6) [5] which allows VTEPs in the
EVPN network to advertise multicast streams that they are interested in.
This is done by having each VTEP suppress IGMP/MLD packets from being
transmitted to the NVE network and instead communicate the information
over BGP to other VTEPs.

The draft in [2] further extends RFC 9251 with procedures to allow
efficient forwarding of IP multicast traffic not only in a given subnet,
but also between different subnets in a tenant domain.

The required changes in the bridge driver to support the above were
already merged in merge commit 8150f0cfb24f ("Merge branch
'bridge-mcast-extensions-for-evpn'"). However, full support entails MDB
support in the VXLAN driver so that it will be able to selectively
forward IP multicast traffic only to VTEPs with interested receivers.
The implementation of this MDB is described in the next section.

Implementation
==============

The user interface is extended to allow user space to specify the
destination VTEP(s) and related parameters. Example usage:

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 198.51.100.1
 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent dst 192.0.2.1

 $ bridge -d -s mdb show
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 192.0.2.1    0.00
 dev vxlan0 port vxlan0 grp 239.1.1.1 permanent filter_mode exclude proto static dst 198.51.100.1    0.00

Since the MDB is fully managed by user space and since snooping is not
implemented, only permanent entries can be installed and temporary
entries are rejected by the kernel.

The netlink interface is extended with a few new attributes in the
RTM_NEWMDB / RTM_DELMDB request messages:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_SET_ENTRY ]
	struct br_mdb_entry
[ MDBA_SET_ENTRY_ATTRS ]
	[ MDBE_ATTR_SOURCE ]
		struct in_addr / struct in6_addr
	[ MDBE_ATTR_SRC_LIST ]
		[ MDBE_SRC_LIST_ENTRY ]
			[ MDBE_SRCATTR_ADDRESS ]
				struct in_addr / struct in6_addr
		[ ...]
	[ MDBE_ATTR_GROUP_MODE ]
		u8
	[ MDBE_ATTR_RTPORT ]
		u8
	[ MDBE_ATTR_DST ]	// new
		struct in_addr / struct in6_addr
	[ MDBE_ATTR_DST_PORT ]	// new
		u16
	[ MDBE_ATTR_VNI ]	// new
		u32
	[ MDBE_ATTR_IFINDEX ]	// new
		s32
	[ MDBE_ATTR_SRC_VNI ]	// new
		u32

RTM_NEWMDB / RTM_DELMDB responses and notifications are extended with
corresponding attributes.

One MDB entry that can be installed in the VXLAN MDB, but not in the
bridge MDB is the catchall entry (0.0.0.0 / ::). It is used to transmit
unregistered multicast traffic that is not link-local and is especially
useful when inter-subnet multicast forwarding is required. See patch #12
for a detailed explanation and motivation. It is similar to the
"all-zeros" FDB entry that can be installed in the VXLAN FDB, but not
the bridge FDB.

"added_by_star_ex" entries
--------------------------

The bridge driver automatically installs (S, G) MDB port group entries
marked as "added_by_star_ex" whenever it detects that an (S, G) entry
can prevent traffic from being forwarded via a port associated with an
EXCLUDE (*, G) entry. The bridge will add the port to the port group of
the (S, G) entry, thereby creating a new port group entry. The
complexity associated with these entries is not trivial, but it needs to
reside in the bridge driver because it automatically installs MDB
entries in response to snooped IGMP / MLD packets.

The same in not true for the VXLAN MDB which is entirely managed by user
space who is fully capable of forming the correct replication lists on
its own. In addition, the complexity associated with the
"added_by_star_ex" entries in the VXLAN driver is higher compared to the
bridge: Whenever a remote VTEP is added to the catchall entry, it needs
to be added to all the existing MDB entries, as such a remote requested
all the multicast traffic to be forwarded to it. Similarly, whenever an
(*, G) or (S, G) entry is added, all the remotes associated with the
catchall entry need to be added to it.

Given the above, this patchset does not implement support for such
entries.  One argument against this decision can be that in the future
someone might want to populate the VXLAN MDB in response to decapsulated
IGMP / MLD packets and not according to EVPN routes. Regardless of my
doubts regarding this possibility, it can be implemented using a new
VXLAN device knob that will also enable the "added_by_star_ex"
functionality.

Testing
=======

Tested using existing VXLAN and MDB selftests under "net/" and
"net/forwarding/". Added a dedicated selftest in the last patch.

Patchset overview
=================

Patches #1-#3 are small preparations in the bridge driver. I plan to
submit them separately together with an MDB dump test case.

Patches #4-#6 are additional preparations centered around the extraction
of the MDB netlink handlers from the bridge driver to the common
rtnetlink code. This allows reusing the existing MDB netlink messages
for the configuration of the VXLAN MDB.

Patches #7-#9 include more small preparations in the common rtnetlink
code and the VXLAN driver.

Patch #10 implements the MDB control path in the VXLAN driver, which
will allow user space to create, delete, replace and dump MDB entries.

Patches #11-#12 implement the MDB data path in the VXLAN driver,
allowing it to selectively forward IP multicast traffic according to the
matched MDB entry.

Patch #13 finally enables MDB support in the VXLAN driver.

iproute2 patches can be found here [6].

Note that in order to fully support the specifications in [1] and [2],
additional functionality is required from the data path. However, it can
be achieved using existing kernel interfaces which is why it is not
described here.

Changelog
=========

Since RFC [7]:

Patch #3: Use NL_ASSERT_DUMP_CTX_FITS().
Patch #3: memset the entire context when moving to the next device.
Patch #3: Reset sequence counters when moving to the next device.
Patch #3: Use NL_SET_ERR_MSG_ATTR() in rtnl_validate_mdb_entry().
Patch #7: Remove restrictions regarding mixing of multicast and unicast
remote destination IPs in an MDB entry. While such configuration does
not make sense to me, it is no forbidden by the VXLAN FDB code and does
not crash the kernel.
Patch #7: Fix check regarding all-zeros MDB entry and source.
Patch #11: New patch.

[1] https://datatracker.ietf.org/doc/html/rfc9251
[2] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast
[3] https://datatracker.ietf.org/doc/html/rfc7432
[4] https://datatracker.ietf.org/doc/html/rfc7432#section-7.2
[5] https://datatracker.ietf.org/doc/html/rfc9251#section-9.1
[6] https://github.com/idosch/iproute2/commits/submit/mdb_vxlan_rfc_v1
[7] https://lore.kernel.org/netdev/20230204170801.3897900-1-idosch@nvidia.com/

Ido Schimmel (11):
  net: Add MDB net device operations
  bridge: mcast: Implement MDB net device operations
  rtnetlink: bridge: mcast: Move MDB handlers out of bridge driver
  rtnetlink: bridge: mcast: Relax group address validation in common
    code
  vxlan: Move address helpers to private headers
  vxlan: Expose vxlan_xmit_one()
  vxlan: mdb: Add MDB control path support
  vxlan: mdb: Add an internal flag to indicate MDB usage
  vxlan: Add MDB data path support
  vxlan: Enable MDB support
  selftests: net: Add VXLAN MDB test

 drivers/net/vxlan/Makefile                    |    2 +-
 drivers/net/vxlan/vxlan_core.c                |   78 +-
 drivers/net/vxlan/vxlan_mdb.c                 | 1462 +++++++++++
 drivers/net/vxlan/vxlan_private.h             |   84 +
 include/linux/netdevice.h                     |   21 +
 include/net/vxlan.h                           |    6 +
 include/uapi/linux/if_bridge.h                |   10 +
 net/bridge/br_device.c                        |    3 +
 net/bridge/br_mdb.c                           |  219 +-
 net/bridge/br_netlink.c                       |    3 -
 net/bridge/br_private.h                       |   22 +-
 net/core/rtnetlink.c                          |  218 ++
 tools/testing/selftests/net/Makefile          |    1 +
 tools/testing/selftests/net/config            |    1 +
 tools/testing/selftests/net/test_vxlan_mdb.sh | 2318 +++++++++++++++++
 15 files changed, 4207 insertions(+), 241 deletions(-)
 create mode 100644 drivers/net/vxlan/vxlan_mdb.c
 create mode 100755 tools/testing/selftests/net/test_vxlan_mdb.sh

-- 
2.37.3

