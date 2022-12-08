Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1886E6472E5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLHP3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLHP3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:29:01 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F7775BE1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:29:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WljkLDSqXPSUlLeE/Loio3cOSOGNLygurpDdHiQkaeVlyuzCZbmA28JnCsncz1Uj5Zr2i7a17+DxyK8oZaUJoUrteJDcvw3ElCDbfP2cIGAmoWux+lY0fqHuMGOscdj230/NZyKcVbf/Fsvk/Y7QDOX0PQgnJPhUDWjk45jUirpScuv+R2l56XHmZqxvPGwfJAuupJKSbt1YM07GPwf07rzO/obtdxO1CbON8JjVIHkikIdw2Hmd+v3dte1eUYkDgyarEer65c+uLNAt+abFJUyU/PxXrkv96zNw9RHI6wOKFPq7Q7DqvnZuYctmVuR9SkqaYdwi+CYyOTxogEC5WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbLsM+grVdZwZhfZGJkPeQCsf8BLb5CaseQKTFJFXiE=;
 b=YX5qA7susYebuRC2FUtx7aAFs/2N3XUgBgg3jFFwb/ATCaH3v8p/rU2U9c3W50NrgvxLuQmlQ22QCx1G4ok6LFmwhWzaIdA7sRd0z4QLLBOMWUy0l7E6RB2EvXdVLPPdMZZZMSVpztDhbIHhiNmZPBVPCUtSpX9D15gnJKR8VwUiLBZctIt9Jr9/yiX1PIsLjRb40Esxwhlt4dr/u3KBuROeoV2Sv194htRu4vWT2hgvSTs7Hg2TcVtw76bycpZXbKjU9H3d955WyDDqPIt2cGJbtspPjMw8VTMOrqm4CZzfgy4o15gYblzHlU0qZJece+i3rU7sqSzVNxASeMSoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbLsM+grVdZwZhfZGJkPeQCsf8BLb5CaseQKTFJFXiE=;
 b=JAT+xT1gt9DQKzixWeVZu8VN3ubeDbi8MiVtM3HHuvS6ZOKFS8XpTEy3pt/Zhk7/HT1LXPSn9U9oOAy+uO4U7HN8vbRGHb+GBHBgA3/vchU244Y1W4Vm/QDaRrboA0DCEqxjJJQ/vEoy3LxMOwfL8DnDpGjoPvnILPEaly3+ukeXmleLteKWELnpzjs86SnrvIOOWvYNSSbDQpZvnNdGBkyJbm5cRh873WqzxDSh3SPpMvTdpcTBCf7L22JKMgy1ImHBTawZ9GwL6Yd9pBBkoyNSsndjHmY2L/CIkP9utY3+IoX+rioEaO5uCFioiPM9oH0VVSGMvmE46L4Hn3CteQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6787.namprd12.prod.outlook.com (2603:10b6:510:1ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 15:28:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:28:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/14] bridge: mcast: Extensions for EVPN
Date:   Thu,  8 Dec 2022 17:28:25 +0200
Message-Id: <20221208152839.1016350-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0008.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de7dd2e-0bde-460c-6309-08dad930ec91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyUhLjGzTpi0OI2hV9Wm4uXh+d0VlLT9416xFwZ4q47z+XwPmmROjuyOpwVFbEHNowsWfjVbo2xEpFTa/DygivZyx40ZJcUizNPLfOrVsIrzgJjOvkpRYhX0puUe9e8Lk6XTlMnfPsi4gWPRpFiDOaNy3aei3fcQ5RiFSwt0Yo131EQfwNyY3v+bU6y2eOOCbJUx3fiBj+DVLIV7XgO4nCpt9tEVTwMaT08TrMbESG/VAK4QsQbfr5CXP8znPIv+3tMEYQEoAm1qy+2c3Sh8mO/EfQxJMDKhiqcjOodmm4mvYCgGT5fAXYJTi4OqlZJLOAHLtvIAfyu72hMNzCrJES8n5QqskL3sP2xQoHhHIvGjamYjGpI0B9uiqBJcYic5Ra4PSSUqh3D1qwE0CtCrwJUyFRH9DOw5tK+foFCGktoH2rt65MZCgc0c6XLGEfu9nst4tBHUPqxKmJmoe4tIpZ8je5mdpMsytZHz2tcwNSmLZFXC4Ht8QvaybwPCY7MNVgGSlRZaG1dFHBWOQ6Y6f/7Wc0eBHphsQCIl+u/u1InasGGq5b9tqbw+9+xBlIR6Q2QrIk0rn14wfVgjv5VP95UoETUg98Lxc84gAmGau+WidnW/ilHz669mQxHZX7bdBpgspDDHDVsYE2G3XB/C73B9yENWdgIshTvBISJDHn7W0TPl0niYm7MYtDznhb7zcSi9ePubcfKeLI0SGR6SNyFIHquzOt2ddTB/esmzDK2cMdd9hQ1LIdjrLMJqjQmh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(38100700002)(36756003)(86362001)(186003)(2616005)(1076003)(6506007)(107886003)(26005)(6512007)(966005)(6486002)(478600001)(30864003)(6666004)(2906002)(66476007)(5660300002)(8936002)(66556008)(66946007)(4326008)(8676002)(316002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ePLf1Bgs6MZ5+bZ0PfDHSSjJesC9xGcMTE3MIBoeNC883zswKYbVXXopJsKG?=
 =?us-ascii?Q?Lj8pJuHKDjdlSDVQ0spAgvRH092C+suyXXs43umJQRKS26pE9gtSwTnJwHMv?=
 =?us-ascii?Q?q4i0SnjXc9FvkJ7ZPInP+0mlM+zItx3NOlSTe8xl5XYM8fGxV0Zb8lo8xBRj?=
 =?us-ascii?Q?x9hrrTK0qLBd1ErKp/HTq8lL7vX4lDCvYpuLw0RuHTLILNncsWJCRyW9Xw2U?=
 =?us-ascii?Q?4VXIFOJwCNvnWHLUj6rHcvHgoyaI2fgxJghHEAk8gPA7mh+E0rYuRRAP1rlk?=
 =?us-ascii?Q?pE4xo+Zz9N6gMGqT4ZccNDrTXQTHU+zd336/b34aI8XY3dQP5nLp0SPOoVoN?=
 =?us-ascii?Q?MyaM5lTp4iqmq3jApzleeZF/Dwci6U6mTs5KRniFouIG2amD2438te7D/qNK?=
 =?us-ascii?Q?QltrCtIXQ+/Qxjj7DdBXk5qQp0YWZlv4Z9Xg/W1dW/pnfHAit0uMPny6LPjX?=
 =?us-ascii?Q?jRd6wbKNyiniRXglkzGqK/2RvSvGH2YjiUW9dpwSy6q+UJvW4cNwVjVrQu3H?=
 =?us-ascii?Q?kBq/TSwJrLNBm4xIyTkPf9eeQxks5SIZPHTAG9C9cucvhdAFMsVPB/hI/egE?=
 =?us-ascii?Q?jSHovJYjk8KVCIVIOtRbq7fXD6NLWilmWgiTioQ4kKjt3GwA1pJQxivV4Cxn?=
 =?us-ascii?Q?t1KSNBsvt9EiaMTl4BTOpG+iwO4do6uu93wmhDKx/9GWjfcrdNyrqaSnghkh?=
 =?us-ascii?Q?vSe2dhxlvyvkBhmuTtCXq9DeKUYmg5E8xpSfkgr4zO+yxHVOMcAaYC2mkE4X?=
 =?us-ascii?Q?B6XOGMFEJGQjLOKGQ/BoIAAMG10PVZlF1PQH55CVXMuIFv00BmQOCKL3k8Bh?=
 =?us-ascii?Q?JMAgemc58w1W/v0/ZZ15tLCdTS/Jf3cAJhzdZ9Rt/72YxwTrWJRnF2mrowbG?=
 =?us-ascii?Q?nUxZvMevGtaCLWpbwNDzP9nzXH004coCS4NZbvFuy2aUOUsymmysZ7fsA6LO?=
 =?us-ascii?Q?VlRwXoEW/s+GdsPgK32uvRvP3FmYp+rteWi8JAYlPd+wNonVuOalHOoaOwJN?=
 =?us-ascii?Q?7jeJqVt7Gn3eEJHlt4zSpiyZOWo5ErCpkeVGmesUrWwAAzj0IW4FRyCVN9ZE?=
 =?us-ascii?Q?7b2vUHzsNPj23G5qNwe5bzDU9npQA2V/ktmEzo4hg2wb076YrEnfuhyVX8rz?=
 =?us-ascii?Q?q+bod4fSz7IOHMeaS660EucI8jFST7oEb0j8AOU6GBG6sLW29nw1Kgfne4js?=
 =?us-ascii?Q?wf6EVVlg4KsWMZY4ituFpgbLjA0BQIgShLZe4dxq0JJCDrlkFWrf5tP2mnLg?=
 =?us-ascii?Q?XrpWjp0+q5ujZ7jy+uDKAT33Tr4Z9Q6HCFzpP1/3XeiogUEB2SA2BNJ4jCmT?=
 =?us-ascii?Q?rhaWZP6HT7l8eLsGFe24c5GyEZRogCWnwow2WYxIcv7tK1+1qNbXAE9XGBGv?=
 =?us-ascii?Q?OAJHfzgVVHUDBR1Ukszmh0KZMXXcueRZ5z4ILY+impEAiW0FHYXKyw5+I5Ei?=
 =?us-ascii?Q?6rTiuyhuKBwe4aaBqwKvuwx2NReSdmwK3ohwuD5OA63SuaDZkOgocsMb86e2?=
 =?us-ascii?Q?4czWtQPzBZBjai0/11kFQbxY6s7v5q00T3oaWpLgnmDAef1AtqBByx/L8XcQ?=
 =?us-ascii?Q?J38UkGAsHSIMFAiBmdnKZVNT/pb6eFLWZuST1HC5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de7dd2e-0bde-460c-6309-08dad930ec91
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:28:58.0248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jonKxF0M4XI3rRq53Ix/TYsTAFxTKWH1u0jcRS4dIePT/gqMhcHyH+u/tKC72JlZvuWpaFEY0qWfLCRjCXvJig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6787
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

Since RFC [10]:

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
[10] https://lore.kernel.org/netdev/20221018120420.561846-1-idosch@nvidia.com/

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
 net/bridge/br_mdb.c                           |  526 +++++++-
 net/bridge/br_multicast.c                     |   16 +-
 net/bridge/br_private.h                       |   15 +
 .../testing/selftests/net/forwarding/Makefile |    1 +
 .../selftests/net/forwarding/bridge_mdb.sh    | 1127 ++++++++++++++++-
 .../net/forwarding/bridge_mdb_host.sh         |  103 ++
 7 files changed, 1709 insertions(+), 100 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_host.sh

-- 
2.37.3

