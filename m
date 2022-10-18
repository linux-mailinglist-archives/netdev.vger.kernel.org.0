Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1989C602B2D
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJRMGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiJRMGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:06:07 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2069.outbound.protection.outlook.com [40.107.95.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74838C09B0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:05:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtQOv5BZv/CnR36oeiL/yEBjlzVt4wpd0scvNFSzt3Ons3Jyq7N/Rd4n8uuTkeRto94scO+xillQ9odQCp88WNqIRsSTWMEKVv/Lc4b7q2fImwwnGFurLwhobl/lAHJ0omfmZKaNVMKtpSV+WZOjK5saMRpsWvVwJhZfvK9cSbZukMCrwoB3nbQuHmBTKnjmL1ZMUB0PJqp1KGfssbUfFyVFCE9P31PSQ8DOYajHB7yw3W+XxlEDXRAJ67uNzffZYL97Fj2JOym4iTfvyneVwk3FMTMW7Jm/03pae43lYGCO2JcDhp7C4vYsaF5DnZu3dIrJyifYBLIzfpZZ0h4j7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWRooAyVO2JNMSYmI8vlHPvxUZSBlD8YMQ9nBQaXGqM=;
 b=mIVekLik8I8NJdM5lf4jBmdmAh9qdZlbXORr3udyy8whdZY48K42PZZq8o616ee1PN8AKnAeB/DaW3MwvVajkXvMW3o/u1zlQRrcj9299gH0rhZYJ/huIwAGP5YZbLWWebMTZLpCLQKLI2VbpeBO4uxSWIV/m6Ae/zePbCHHMiBGu58vlBml1xjqtce5eZjhdgoE9OWICtql5wgO76tzvAxA9wU5Ba3c/QxXokYUVJGpPhO8ZOi/Xd4JH316shepsvsYwvdSa0rpVTsDXxzpDIpvp/4AFAc94QGqczvTpV4rmfzIBK4Q68WEMCxZSHdwDWldJnzegOgmkbXDNdr7Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWRooAyVO2JNMSYmI8vlHPvxUZSBlD8YMQ9nBQaXGqM=;
 b=Fo5Ovfh80pjn8S0p3w437hl3gKMN0cj8F0M7g60fmhUVLl6GGizqH9MkjySqTlX2AUv9PXmSjF91FyF5rP87NPWW1unx+tsVbyf9DjIO9Tt9saLb6LnoOQ+WexqnhvO3E83pg33Rvb2tDfJ5CKyWPfGdibSn9MfTwNAk116C3bn2L2/OwY+fz09aOMI+29rBtFMSMH8UK7z15iMlzrmvsbNEPeFDRYhoaDR82+uJYod/bx2oclSW6JAVkM/2HuhImoUQghcQrN20MPPKaWjddYkCuCikXikBdjBZPs2lW4gNOvIVJjKaTCvqJu12Ap1cTDbJs7WALEJ2/x0IsaG+TA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 12:05:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 00/19] bridge: mcast: Extensions for EVPN
Date:   Tue, 18 Oct 2022 15:04:01 +0300
Message-Id: <20221018120420.561846-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0062.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|LV2PR12MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 39170c88-38c2-4640-b5a9-08dab100fd84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6BSBbOmcCxIi5KlK4t5LWd+OSQf89dFQayUfTnqF6ZRlTm7iZqGkHT6pr5v3STvp/RQRf2IFejONWbvKZjuy1z/1cuVOoCZcCRBR8OO8Wf3c3fAKb7KKGTmXDBFyY2NyjUKIPoilYLDA4SAPFS7+gzac8xtCAyT1+MLK0TDL7TAs8sBwrzhw9hCnB5UJFsC+MTEs1tgFBMGljsx27JqsV0KABBMBTal99NTaxAI1mS//v7gyuMhL4Mb4Wyab3WbRNhx5nc2cgvkTdLritjg/D0c20h19FQNqAFvheIj/e8YUEb59LN9ML+DV8CAiGs+ALuguL6GehvB85A9O9YuUXt5OPS4puXAyYupBz3cyzqUdIu5zMItCDyTzNL/rpOww9+4Okk9b1N3WCFPEAXcjbux9g9qdWiN/GNENFiGbCLzTdstOh1LD6QS1hT70jMzQCpbcSnBdQ+w3kMYRfExY/LPPMEwasYYZ0dktUwGvV5+oIVjC0eRzwAz21UjykGRwCQqFSjNQZt/yuq6XmwFHZqZPuVwg5P4vCn4uqUl7YRXnE+H370SOYnUE3ki2PI6VIHmt5XQzNCUbhctl9C/8NrpEwhHqAz/GNE0PbUrTt6eYutBQKG93Ow7mt/nDkCmyBnYcGGcW+VNNv+9RC/uU9IVaeDMaYHcezmr1fAoyamo6zCII7DdW9Zx+L+LEHWYbjDdYwXic3MH7QCRpwkXdaInEuMPB7d/dMJXjIcTEz8eD2PPOLe4Vi0O/hdX6vHiNbXZFzdGpXvi9AZOVO8v5A1m0AwKZmO08BU+Y/8qC5j0YE8zE0SGKkGMWj8sxe9+u/ecvSQyFlyzcSRNepHx4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(38100700002)(6486002)(478600001)(966005)(26005)(6506007)(186003)(1076003)(2906002)(36756003)(41300700001)(2616005)(316002)(66946007)(66556008)(66476007)(86362001)(4326008)(107886003)(6666004)(8676002)(5660300002)(30864003)(8936002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UXsePIx3+lvYwj2Kj85UYATXS6QRndEau4uCOojuYkj+M2Nvl4mvwGo/WQ+X?=
 =?us-ascii?Q?JaNSUiYWd0+DaCSPdm0gzA0J8hDlZRfc5/FzkfAPV+ikTk5b+Wy8/l0JISwK?=
 =?us-ascii?Q?As/fo5d+KyUkvILzSEIXaiZMwoH2wWNy1d+dq+rWGH9EQyJrODpN783mnQE0?=
 =?us-ascii?Q?Rbv+CACzTY3YVgc/7SuIKw1zsF6A0Q+BZ+1z12TgSjzTrlNtnSWgNj9vYbm4?=
 =?us-ascii?Q?fL+3Op96A0dJE7Z+m3qdeUx3UWslxW5w2G+QTlpiGp2DuLlMvOv194RF7I7J?=
 =?us-ascii?Q?5Rw2NmzKru9FqjoUCKr0A98k1k/2U6WfignEserrOu/g+zdl+F0s9OHt2Rpp?=
 =?us-ascii?Q?2PEcEzK4g4/74kJg1RyhiKqVMjdIKlthxjldzJ88vnCkgZoqG/baS5x/7oJd?=
 =?us-ascii?Q?5bUVQ8Aa5OEZZj0h4ztFTHCdhYmfyV3zO50fk4gJDtNmLuQev8QOUOkAPpEM?=
 =?us-ascii?Q?g3vxBFriQygZHr1Y2YtksiBUfDBv82XiGGUtSBaE4yxRMFgQe3GSkMdsSLyV?=
 =?us-ascii?Q?1USkZ4gL/IWYXIxEjaHVnf6XhR8szYpSGCKSGpOGIwsc1wW+8RdHujJ/P6Ws?=
 =?us-ascii?Q?+b2q3eD+jt0o6/AnOY1qYqOmjPi64ohKB14kkAtxwAYFan5CS2Q2o+0Pd81O?=
 =?us-ascii?Q?Km7BDZ8nK7lbHABBiVS5H7TJpqHdA4wkAY87fRwRWXl8/i7vFRIrOkthSD+D?=
 =?us-ascii?Q?xdx9IwzD0I6GKBzoRiGkC4Byguki5cw6l/e1RHy3kFa1eDeQjclY6KQq2cif?=
 =?us-ascii?Q?2I9g2Od1r992Jz8Njwgv5Avf4pgM+k+G9UbcWcn3Acowu+SRWhw/QYc+0aPB?=
 =?us-ascii?Q?HFilWW6hHvmZyK8ViWNLPbWCnjne+Rqw8PCNqV/8uW4gccQDHeKzApgEqS6Q?=
 =?us-ascii?Q?DzcnrKQmaOwI3wN/EtcaKi7WzA+nC28cee+SLSteOfyFuvU3oXj8lQFgUTG0?=
 =?us-ascii?Q?DOzxUfiXF6hIslKVq65oWwLiS1f3xcwSBVdjolt2cOAL2BKevld1nvDG6c9V?=
 =?us-ascii?Q?MDt5EvO/B+GBK7krj93rzaSV9yEIytCLIDxnHRGENvcaf/iXnvrfmCoJ0vfy?=
 =?us-ascii?Q?XjuNtuyYtUUshdVx/s1JsswB+vy5mbmco/YIEiEUIJtCQOVEaDe2WNjFI1R+?=
 =?us-ascii?Q?qB0wtODf9O5Exc7qe4ci5Dh1Dg0lgoKILi0CTynjZvucjaJgnjsFVTWw/dRL?=
 =?us-ascii?Q?RvO1mO9LGLLqvZViIujt4wd4kyQcZvwrXmJuct5YFP2OJAnx9Db5EYJGSWay?=
 =?us-ascii?Q?5Y9gNoCUG2MJtDMt6iV2cakB1uGnNpXoUnXfIeapKtoJpBKYphPU6XnsHq/K?=
 =?us-ascii?Q?aVqTc/5wxqvcauYZHqf7rbqqBRZf6ZINCT7+O/4Ronq1QUmOo1BjHoNx3hOc?=
 =?us-ascii?Q?fedN7Ahkl60tmi642LTD6R59dqnBHYhOy4kr3Ikq9OCiQbf7SclH5sVIUJ3m?=
 =?us-ascii?Q?EFcLsJBMv8Z0oOTecfaIUpQdNpMXMT7wwrHfDyxovKdy/zRnypuqdFSK19cZ?=
 =?us-ascii?Q?uE7kQe/NMo6K8RK4N2Be1bqN7iKAkzTpGQs26ucg/KYn7j8A7dCT18iOxXAD?=
 =?us-ascii?Q?XeE4lA08Uag6QGT3cbDDBJBn7rkgHlQPYoJKdn4B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39170c88-38c2-4640-b5a9-08dab100fd84
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:03.9981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FeDYHXbpexCXQiFuUezeMeeP33PNawqvRUmzUpwZSGzNYvG2h/P2UpZFCWXws/QjxVmS3f6WUg86Llig6SOSzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5869
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Posting as RFC to show the whole picture. Will split into smaller
submissions for v1 and add selftests.

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

Will add dedicated selftests in v1.

Patchset overview
=================

Patches #1-#8 are non-functional preparations aimed at making it easier
to add additional netlink attributes later on. They create an MDB
configuration structure into which netlink messages are parsed into.
The structure is then passed in the entry creation / deletion call chain
instead of passing the netlink attributes themselves. The same pattern
is used by other rtnetlink objects such as routes and nexthops.

I initially tried to extend the current code, but it proved to be too
difficult, which is why I decided to refactor it to the extensible and
familiar pattern used by other rtnetlink objects.

The plan is to submit these patches separately for v1.

Patches #9-#15 are an additional set of non-functional preparations for
the core changes in the last patches.

Patches #16-#17 allow user space to install (*, G) entries with a source
list and associated filter mode. Specifically, patch #16 adds the
necessary kernel plumbing and patch #17 exposes the new functionality to
user space via a few new attributes.

Patch #18 allows user space to specify the routing protocol of new MDB
port group entries so that a routing daemon could differentiate between
entries installed by it and those installed by an administrator.

Patch #19 allows user space to replace MDB port group entries. This is
useful, for example, when user space wants to add a new source to a
source list. Instead of deleting a (*, G) entry and re-adding it with an
extended source list (which would result in packet loss), user space can
simply replace the current entry.

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

[1] https://datatracker.ietf.org/doc/html/rfc3376
[2] https://www.rfc-editor.org/rfc/rfc3810
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6af52ae2ed14a6bc756d5606b29097dfd76740b8
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=68d4fd30c83b1b208e08c954cd45e6474b148c87
[5] https://datatracker.ietf.org/doc/html/rfc7432
[6] https://datatracker.ietf.org/doc/html/rfc7432#section-7.2
[7] https://datatracker.ietf.org/doc/html/rfc9251
[8] https://datatracker.ietf.org/doc/html/rfc9251#section-9.1
[9] https://github.com/idosch/iproute2/commits/submit/mdb_rfc_v1

Ido Schimmel (19):
  bridge: mcast: Centralize netlink attribute parsing
  bridge: mcast: Remove redundant checks
  bridge: mcast: Use MDB configuration structure where possible
  bridge: mcast: Propagate MDB configuration structure further
  bridge: mcast: Use MDB group key from configuration structure
  bridge: mcast: Remove br_mdb_parse()
  bridge: mcast: Move checks out of critical section
  bridge: mcast: Remove redundant function arguments
  bridge: mcast: Do not derive entry type from its filter mode
  bridge: mcast: Split (*, G) and (S, G) addition into different
    functions
  bridge: mcast: Place netlink policy before validation functions
  bridge: mcast: Add a centralized error path
  bridge: mcast: Expose br_multicast_new_group_src()
  bridge: mcast: Add a flag for user installed source entries
  bridge: mcast: Avoid arming group timer when (S, G) corresponds to a
    source
  bridge: mcast: Add support for (*, G) with a source list and filter
    mode
  bridge: mcast: Allow user space to add (*, G) with a source list and
    filter mode
  bridge: mcast: Allow user space to specify MDB entry routing protocol
  bridge: mcast: Support replacement of MDB port group entries

 include/uapi/linux/if_bridge.h |  21 +
 net/bridge/br_mdb.c            | 821 ++++++++++++++++++++++++---------
 net/bridge/br_multicast.c      |   5 +-
 net/bridge/br_private.h        |  21 +
 4 files changed, 649 insertions(+), 219 deletions(-)

-- 
2.37.3

