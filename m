Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8E7648F41
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiLJO5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJO5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:57:14 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BAD1A053
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:57:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+x3/SxvWe3QT/KO7tNH7TliXNfwn85/3GjRWSrLtxdk3nXQsyhNAR7Of06uJHTlVpEf1QthWCwqYBcytdHRILGt9g9GENp6Hmyo0OeGX6NVgr8SZf7lBds3nFqRkw7z+wWbzQ3IDO5F859edez7BA46oMmP0TKmXzY0bl+xAMLBfy0/Pzh7tP5fk2vsrQxfmbAzkPHsOOfWAcbjp7SoVf2eXJpK5c1WRczIeW2WLra5S+WJTvDd4Sx69j07EvCpHQ9VWbuCD2ix8DoH6b7ZWJtJUdm2nuje0lt/8ynYxXoWBzmqJDZ0YExpPeSH+ACIInpseMcFQsVrMhtkaDYlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PRTMX2cyeDz0IjxF5vdAuoIeYnz1bsy0L4jrQBzjmmI=;
 b=W3eM/DhIJqP5QsioLZQ9Tazu5MSlTSQFeimxx5IVWTLb79BeretFu1cts7RV6GkC3O2ogN+NVDk9RFyWb+iu+U+pST90fs/giLK9/F2GO++SbS0rNHwtohwE+8i6y8vL5zA8lvx57t12vVpvaGJIssdLq9pJaal1AV/QVxyOO6hTIjPVafZDkDhyf9eAQ8uA+j41eux9bvt8ifmYvpFlO0zRprvei4FEqOYfvycHyV0gclbIqGKDSgoJ6DqfDpIWICNH5bSrbF7UNbA1BhisTESRYnch2Wew9bfsyFkjTTBEzOhAFUHmFPNZ5wzyijFrTqy/iDRrBjVjCllEmi+EvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PRTMX2cyeDz0IjxF5vdAuoIeYnz1bsy0L4jrQBzjmmI=;
 b=o00iRMQHN+M/AZo/wKzLhYDavuaTwi7eUITzFfKn1I8iKSvdF9rqYx9sxephxE3f5QjDPc3xCMX8wljq+GpodXqhO2oWjzw9hm2WxtdCggVzrnuA/f9JiFIv+uWoty5njC5w5lxKK9CA+pg0Ld5kZ9xXudTKFuJMlXDn46qkApytNJC42ja1MtuznfUTEgzbphW5+maj79uKr6P9rrM4q23OyymMXF3Jn0CGPLg81FmQhWRZX0Bp2AAnmA0spMuk1keX7mLS0gEBmy1E0jx/xiS7Lf3cRbePm4USrWnM2Fq0FSZZXjYLyCs6bzjfhjgndgWjlynyOL/q4ZYOu9vlsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:57:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:57:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 00/14] bridge: mcast: Extensions for EVPN
Date:   Sat, 10 Dec 2022 16:56:19 +0200
Message-Id: <20221210145633.1328511-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0041.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: e060da9c-0b4d-4ebd-074d-08dadabecefa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 360zhjRFeNDOrbU54+QFJ8rSVV+LSPLjq9tlo7/UmXEI4BR/+gw54oYiUWH1GAFR5nNEdMDeXCHZeQ6qGLfNfeigUqUX8m6r46B7iyHqYepiOlWP5CCoDHR/VdFO51YsSRr4dBeNGDIcpnAKGBoEKKcCmEROKhtqac3TeQ+Q8roAr4QBI923RKjeuCKxB9WZoxUizifiXW1mPSAT2nU5zf1FrjAWjoaBl2z0m84744XWhsGJQxXrSNVwS5wn/uL8MCAqhGr+qFJnHKYDl2DQoVZMYkzcoQUbJY7tqSv02ovcFokx9g/p8iI+mqv9kwfuRMsqkbm6dGpLSsQ3jbMbOGJZkLk09AaQJ8+MBU8ilxB0SzYsubxGxAyDsnJ7DirIRa/YLadNED1EVeHKTcHSvrjzxkFe93aYLvYOXhkJYhSyQhMJ8XkYgFTEZM6YaH58unlxvVRp+RESXI7K2A8a78Z2GmTLppmKYB5kRjepovt6J3LDrsZ68EMODnRt7LkCiFraI84N32HKTCJ4RkDQae/B7Yb0aRXRt0ccoQM+yYWyhGNhzWjPCOK3yAa97NAqgEcYJ6FRXFr4iz88iDJZ8UtDnqDxgDCWSS0umfJK7BDvwo4VPJENcsR7tj2nn4+fCXlkNKUiHYfO7vwt1y61dxUSZhGKLlHnu+RsUfwFEGn+c5bSFDlY66hxSf+7puK9v1kF5KVu7LHcgeyyz6ONtkSUYV5GAIjKPsi8MnIF/o4XuzrGLpJ3C5BpDNmHkc15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(966005)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(30864003)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oJO0dPZl1fpdj926FIMU3QAs+ciSrG7vpT7Q+Z90f+ImU1sGpxJ6lKwXqXV5?=
 =?us-ascii?Q?8m5DeSJBAzPBY/Vz4MJNd4Htgi9DAls+6basKn1I3JoX8E2YkBP6fotufAFG?=
 =?us-ascii?Q?Vb1sMb+Ffb5GEEq16hR4YJ4IjCSeyedkDDQsgi7CU6k5SWhjA/6Gze5G6S87?=
 =?us-ascii?Q?Y+H126X3qL3szRkzPchukoAf5eb66xZdS9LW7E7ZanppLU0OOil9BQdoyE8x?=
 =?us-ascii?Q?unptj1hqJ2SfMeZl/lswNPqTCZGyetka7ZViEErjAjcO5Qs1VNyJPGDmmVUL?=
 =?us-ascii?Q?OlT9FubE+4C1eQNRildlQ2FC5YsndKYpyzWQu9wvRkYHZ9jYMKJhWaO4vjs5?=
 =?us-ascii?Q?sAmhAvSmyF7yn0l0LtnJJ9e1obkXYX82i7orP3ITxI506St0XV1wwCcRWt2C?=
 =?us-ascii?Q?QEJPB0eDTUhjYjMPSn0HuUcLF7YtiyUDN+psxp1E3nQC8u0BOjOOaqM1SYcy?=
 =?us-ascii?Q?rWf9fw9226a3EWJRk6wcxcY+8Jdq3bJSAcRs0nOqeC+7rTxktyTWbR2vUpfc?=
 =?us-ascii?Q?W9hxR8zaICNpqCDbf7tCoiQgsY1d5Paq6oCXIYLyfNKaHKFxtDxtDjCQ7pkt?=
 =?us-ascii?Q?5TvrzTXy+MpU3nc+YCoAXpRVt6oMf/LPD2pPLRZz0pIH9+jbrhHz6og4fNcV?=
 =?us-ascii?Q?wf38QGHRuzSKaSTlVNBCIppcjhAJlloU7SoBSRkkMkdcx9R8MCMd596oidqX?=
 =?us-ascii?Q?rzO5NvpQpLZFBd3h3YJEhEXyFQDsF6MrY6zoIsRcBPYMZgpI1426ZfXkVd/d?=
 =?us-ascii?Q?Ii+AIYAJH3eRSwkHwP8A6MqD/u6cSZYmzPeLVAT4ZnvQkQ+Ipj6LKzh3o7Wp?=
 =?us-ascii?Q?zDqMr/SsS9U2gL6ziMKgO2uJ1cKvAhOPL/iGy5IAFltRYUwMlhmNwidECJbA?=
 =?us-ascii?Q?FKM/SfCyLxC0jW8Yhx6SIIZxn5c6zXocFl9xcKOiErNgbkq8raT4U9vdFqHW?=
 =?us-ascii?Q?dm5iWcIjEG+ntPQNdq5xvGlhXfqK53+3fWP0CuFSzULw6GrwyFFV+aTB1Qd7?=
 =?us-ascii?Q?iSvbo2wq7MQxCSOXX1UWnRb+WPGL2YREUBtYaaH6JvsRneegTv7+XwDa4/qh?=
 =?us-ascii?Q?3T+gGv7Bs7fTW8XDU/e3WjIyBCp47BbVwhnn7lewo+Xmw4NzwFVxfAB+0cNA?=
 =?us-ascii?Q?9VjO6CAk3rHKPH0TnEhEL2HwQO9HIDFKbxNG50bzN2VDtKXixUQr8FRk7c3f?=
 =?us-ascii?Q?k3BQRCm4zYjpHZOlu9KrJaV/QtFtVWz3BMpVaqjYs3UCWiOUn9qS7xcluTkh?=
 =?us-ascii?Q?U8wrvEeDKzFV45o6Vy4zxIXEib5cp/e065somVv2RQpg9Pdee87EwulkCdau?=
 =?us-ascii?Q?Bxgoz4sLsg2yP007HpQnnUaGB4qTy1uJ0NiIGyfx6o0suamHomG5jXYBe8Zs?=
 =?us-ascii?Q?S71miV44t2JgPiLcOogglV+MclFVuf7tzN+e5mCONdSRO4+guzPVDaBMY/Q4?=
 =?us-ascii?Q?bXj/zZfmzDnqupLyiVmz14pYwBJTR2xsccqBOSf1qoTZ6z2Txo0BwUGRug60?=
 =?us-ascii?Q?zTvbkH+7pBW0egINPpovXiS6r8yrTyXSReQ9PdQpYGkXiNj4XKwhn1SX+K07?=
 =?us-ascii?Q?Yl+6gsUfQQ149hFa2s3XL1H+4cGTjtShOKCwsopE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e060da9c-0b4d-4ebd-074d-08dadabecefa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:57:09.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cmc7HtZx4f8TvxifDg+OXPNuku2+ejdbYEUgQ/LmtRwxE2hZ43LX2sE/jiieRZFX0vK8xIdgJ5ZnYz+eK08E6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tl;dr
=====

This patchset creates feature parity between user space and the kernel
and allows the former to install and replace MDB port group entries with
a source list and associated filter mode. This is required for EVPN use
cases where multicast state is not derived from snooped IGMP/MLD
packets, but instead derived from EVPN routes exchanged by the control
plane in user space.

Background
==========

IGMPv3 [1] and MLDv2 [2] differ from earlier versions of the protocols
in that they add support for source-specific multicast. That is, hosts
can advertise interest in listening to a particular multicast address
only from specific source addresses or from all sources except for
specific source addresses.

In kernel 5.10 [3][4], the bridge driver gained the ability to snoop
IGMPv3/MLDv2 packets and install corresponding MDB port group entries.
For example, a snooped IGMPv3 Membership Report that contains a single
MODE_IS_EXCLUDE record for group 239.10.10.10 with sources 192.0.2.1,
192.0.2.2, 192.0.2.20 and 192.0.2.21 would trigger the creation of these
entries:

 # bridge -d mdb show
 dev br0 port veth1 grp 239.10.10.10 src 192.0.2.21 temp filter_mode include proto kernel  blocked
 dev br0 port veth1 grp 239.10.10.10 src 192.0.2.20 temp filter_mode include proto kernel  blocked
 dev br0 port veth1 grp 239.10.10.10 src 192.0.2.2 temp filter_mode include proto kernel  blocked
 dev br0 port veth1 grp 239.10.10.10 src 192.0.2.1 temp filter_mode include proto kernel  blocked
 dev br0 port veth1 grp 239.10.10.10 temp filter_mode exclude source_list 192.0.2.21/0.00,192.0.2.20/0.00,192.0.2.2/0.00,192.0.2.1/0.00 proto kernel

While the kernel can install and replace entries with a filter mode and
source list, user space cannot. It can only add EXCLUDE entries with an
empty source list, which is sufficient for IGMPv2/MLDv1, but not for
IGMPv3/MLDv2.

Use cases where the multicast state is not derived from snooped packets,
but instead derived from routes exchanged by the user space control
plane require feature parity between user space and the kernel in terms
of MDB configuration. Such a use case is detailed in the next section.

Motivation
==========

RFC 7432 [5] defines a "MAC/IP Advertisement route" (type 2) [6] that
allows NVE switches in the EVPN network to advertise and learn
reachability information for unicast MAC addresses. Traffic destined to
a unicast MAC address can therefore be selectively forwarded to a single
NVE switch behind which the MAC is located.

The same is not true for IP multicast traffic. Such traffic is simply
flooded as BUM to all NVE switches in the broadcast domain (BD),
regardless if a switch has interested receivers for the multicast stream
or not. This is especially problematic for overlay networks that make
heavy use of multicast.

The issue is addressed by RFC 9251 [7] that defines a "Selective
Multicast Ethernet Tag Route" (type 6) [8] which allows NVE switches in
the EVPN network to advertise multicast streams that they are interested
in. This is done by having each switch suppress IGMP/MLD packets from
being transmitted to the NVE network and instead communicate the
information over BGP to other switches.

As far as the bridge driver is concerned, the above means that the
multicast state (i.e., {multicast address, group timer, filter-mode,
(source records)}) for the VXLAN bridge port is not populated by the
kernel from snooped IGMP/MLD packets (they are suppressed), but instead
by user space. Specifically, by the routing daemon that is exchanging
EVPN routes with other NVE switches.

Changes are obviously also required in the VXLAN driver, but they are
the subject of future patchsets. See the "Future work" section.

Implementation
==============

The user interface is extended to allow user space to specify the filter
mode of the MDB port group entry and its source list. Replace support is
also added so that user space would not need to remove an entry and
re-add it only to edit its source list or filter mode, as that would
result in packet loss. Example usage:

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent \
	source_list 192.0.2.1,192.0.2.3 filter_mode exclude proto zebra
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 permanent filter_mode include proto zebra  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude source_list 192.0.2.3/0.00,192.0.2.1/0.00 proto zebra     0.00

The netlink interface is extended with a few new attributes in the
RTM_NEWMDB request message:

[ struct nlmsghdr ]
[ struct br_port_msg ]
[ MDBA_SET_ENTRY ]
	struct br_mdb_entry
[ MDBA_SET_ENTRY_ATTRS ]
	[ MDBE_ATTR_SOURCE ]
		struct in_addr / struct in6_addr
	[ MDBE_ATTR_SRC_LIST ]		// new
		[ MDBE_SRC_LIST_ENTRY ]
			[ MDBE_SRCATTR_ADDRESS ]
				struct in_addr / struct in6_addr
		[ ...]
	[ MDBE_ATTR_GROUP_MODE ]	// new
		u8
	[ MDBE_ATTR_RTPORT ]		// new
		u8

No changes are required in RTM_NEWMDB responses and notifications, as
all the information can already be dumped by the kernel today.

Testing
=======

Tested with existing bridge multicast selftests: bridge_igmp.sh,
bridge_mdb_port_down.sh, bridge_mdb.sh, bridge_mld.sh,
bridge_vlan_mcast.sh.

In addition, added many new test cases for existing as well as for new
MDB functionality.

Patchset overview
=================

Patches #1-#8 are non-functional preparations for the core changes in
later patches.

Patches #9-#10 allow user space to install (*, G) entries with a source
list and associated filter mode. Specifically, patch #9 adds the
necessary kernel plumbing and patch #10 exposes the new functionality to
user space via a few new attributes.

Patch #11 allows user space to specify the routing protocol of new MDB
port group entries so that a routing daemon could differentiate between
entries installed by it and those installed by an administrator.

Patch #12 allows user space to replace MDB port group entries. This is
useful, for example, when user space wants to add a new source to a
source list. Instead of deleting a (*, G) entry and re-adding it with an
extended source list (which would result in packet loss), user space can
simply replace the current entry.

Patches #13-#14 add tests for existing MDB functionality as well as for
all new functionality added in this patchset.

Future work
===========

The VXLAN driver will need to be extended with an MDB so that it could
selectively forward IP multicast traffic to NVE switches with interested
receivers instead of simply flooding it to all switches as BUM.

The idea is to reuse the existing MDB interface for the VXLAN driver in
a similar way to how the FDB interface is shared between the bridge and
VXLAN drivers.

From command line perspective, configuration will look as follows:

 # bridge mdb add dev br0 port vxlan0 grp 239.1.1.1 permanent \
	filter_mode exclude source_list 198.50.100.1,198.50.100.2

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent \
	filter_mode include source_list 198.50.100.3,198.50.100.4 \
	dst 192.0.2.1 dst_port 4789 src_vni 2

 # bridge mdb add dev vxlan0 port vxlan0 grp 239.1.1.1 permanent \
	filter_mode exclude source_list 198.50.100.1,198.50.100.2 \
	dst 192.0.2.2 dst_port 4789 src_vni 2

Where the first command is enabled by this set, but the next two will be
the subject of future work.

From netlink perspective, the existing PF_BRIDGE/RTM_*MDB messages will
be extended to the VXLAN driver. This means that a few new attributes
will be added (e.g., 'MDBE_ATTR_SRC_VNI') and that the handlers for
these messages will need to move to net/core/rtnetlink.c. The rtnetlink
code will call into the appropriate driver based on the ifindex
specified in the ancillary header.

iproute2 patches can be found here [9].

Changelog
=========

Since v1 [10]:

* Patch #12: Remove extack from br_mdb_replace_group_sg().
* Patch #12: Change 'nlflags' to u16 and move it after 'filter_mode' to
  pack the structure.

Since RFC [11]:

* Patch #6: New patch.
* Patch #9: Use an array instead of a list to store source entries.
* Patch #10: Use an array instead of list to store source entries.
* Patch #10: Drop br_mdb_config_attrs_fini().
* Patch #11: Reject protocol for host entries.
* Patch #13: New patch.
* Patch #14: New patch.

[1] https://datatracker.ietf.org/doc/html/rfc3376
[2] https://www.rfc-editor.org/rfc/rfc3810
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6af52ae2ed14a6bc756d5606b29097dfd76740b8
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=68d4fd30c83b1b208e08c954cd45e6474b148c87
[5] https://datatracker.ietf.org/doc/html/rfc7432
[6] https://datatracker.ietf.org/doc/html/rfc7432#section-7.2
[7] https://datatracker.ietf.org/doc/html/rfc9251
[8] https://datatracker.ietf.org/doc/html/rfc9251#section-9.1
[9] https://github.com/idosch/iproute2/commits/submit/mdb_v1
[10] https://lore.kernel.org/netdev/20221208152839.1016350-1-idosch@nvidia.com/
[11] https://lore.kernel.org/netdev/20221018120420.561846-1-idosch@nvidia.com/

Ido Schimmel (14):
  bridge: mcast: Do not derive entry type from its filter mode
  bridge: mcast: Split (*, G) and (S, G) addition into different
    functions
  bridge: mcast: Place netlink policy before validation functions
  bridge: mcast: Add a centralized error path
  bridge: mcast: Expose br_multicast_new_group_src()
  bridge: mcast: Expose __br_multicast_del_group_src()
  bridge: mcast: Add a flag for user installed source entries
  bridge: mcast: Avoid arming group timer when (S, G) corresponds to a
    source
  bridge: mcast: Add support for (*, G) with a source list and filter
    mode
  bridge: mcast: Allow user space to add (*, G) with a source list and
    filter mode
  bridge: mcast: Allow user space to specify MDB entry routing protocol
  bridge: mcast: Support replacement of MDB port group entries
  selftests: forwarding: Rename bridge_mdb test
  selftests: forwarding: Add bridge MDB test

 include/uapi/linux/if_bridge.h                |   21 +
 net/bridge/br_mdb.c                           |  525 +++++++-
 net/bridge/br_multicast.c                     |   16 +-
 net/bridge/br_private.h                       |   15 +
 .../testing/selftests/net/forwarding/Makefile |    1 +
 .../selftests/net/forwarding/bridge_mdb.sh    | 1127 ++++++++++++++++-
 .../net/forwarding/bridge_mdb_host.sh         |  103 ++
 7 files changed, 1708 insertions(+), 100 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_host.sh

-- 
2.37.3

