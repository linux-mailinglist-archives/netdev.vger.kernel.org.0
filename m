Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B916BB40D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCONNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCONM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:12:59 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908742068B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7iPQkL7KqoxZZRjwqVxGD35HQw3DiAflEDPjYp/gFScsK0/Ud/WWHBheSFBxEcf0GoiSFdtrFCOt37rjBowTTuDaIZ71zP7TdArCV+jPOy3UaKEBGYI851s83KSaWFvN26pGZcoPMwf0JUtc5lYhkjLgGRNwBARdffoJauiSrCMQgEQ8ZyHvUuFToao0CJze2SMmb5bXU9hLYcy438J8WPV0A6JpE6sTmsI4n8mvqsIX6mXMRhdZ02kewPKvVCNRuDtmlok/sjUoNqcfR8sC5pKoXs0SJpF2tMO5Kt+sLpw/kkX8fWbF0E7+R4hTBKDMYeCzs008xa7xfERXY/Hjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PffruUhRQXaT6f3vEUX3H/wv5JQm2o2qUf02tmQX0ek=;
 b=nlNgY98FZh9GZ1RvJcJEzz5jd+3/MWm/FF2NkU7taXIOP85Ofs1fxg3SLLuu1wJNf8i/WzyXrQh95IBl8DLpMob27nPkTmQTGavGB/XKz+Xkza7Kp8oSahqJ3TRNLcnBn5QRgy9FfGW7j+UMoTNoDU1EKPhPc4qF23KmxLn9SMszt2BT5taH+RHpsBWPbvYvF+6sGv4FoH0sW6pr/FW/CXQbOw+f7MNMgyer+m+jZokTAqIVZVZBiicRK88UVkm0ygoefzq4vOB7Cel/WoRsGLzPjmhwk6TlOJbKVR6Y5SFKOOuVflRCbPbwqjTXwUJmqBC0YoX26j2ebVB3gQ0fbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PffruUhRQXaT6f3vEUX3H/wv5JQm2o2qUf02tmQX0ek=;
 b=dl5l7lUkYTGecO8/UyPnlfxBUMJNNSsf9K9Eqtwdw7pIZ4dPHmxyFFOzkEbJdCycCPpgFcIjSkwauNz+hh4+uffwGimWd6aNfolkpew2vJ6qd/yslokQVyBEcgeO+SQynZhuwH+hYogXurmYGe72Pwr0eE9WlqKrpR8/+4gdmP4Udf+BiaiZxO/k/BaKKqoijhL4AgjV1Co/2/pwNwL4aF46lX+vqjlJVbawSJ22WLf6IgLlO4iA9nw9RhON+kHx+IAI91Vg+MZPlVUjk/OOzh5Xythhvw1Y+sHVsiFgqb0dPjSocZpAFxnQA81GqwvH5/L9bffecpDG0Vb4isuHfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB8802.namprd12.prod.outlook.com (2603:10b6:806:312::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:12:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:12:52 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 00/11] vxlan: Add MDB support
Date:   Wed, 15 Mar 2023 15:11:44 +0200
Message-Id: <20230315131155.4071175-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB8802:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eb2123a-85fd-47b2-4196-08db2556fbc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IH6LVjiAF4cif68MMWi/T5rY90t28T3rAg2uiZBp1rfuXYGvMMnjFM2f0tifl9ygrUt5K4/ND56ixRnu/YAEJ8QSSRnKDS5uoyL8J1wbhc2TEUSEsYKGezVOceElbQ9wmIBWL7bI8kI54aBTBogvSNUizBLhKQW+l59IbWJsdSsvyuQzR1/EkJTfGC3eEIT0v2aETLgkLdHMdtU/Ctk5JmrVvd2HroP1E7wWHHA/CyH2cB+6I0pvc4ajTqN2bE7VRG+tB+3RJrNoN4yzkMOoi7XT9OtO/0jw5Ex5ozMGm+jmK/WYVGr7RIq35XIzJepjuSdyM1RUEkg9lvBXjQANibmqH1Sah+O86YvatpJJ3Tb9PzNeHREZEDIOcdWOcU5lmfi08tPBmr4E75exZb5iLMJ2mjMY9gEQHaWWaFgESLlSYRMB9+ZxgkuqwbGYecfBpTy5Oc6FNgpmr8snOsgNvhBNTxsVRPUTxviSz/3K7ZQzWz5/lRj2K8+pvccMe3nXefZybOgmYbxmN7mFVqcd8i+1q08dildP6aVhuhtBO3FMYjVBYtCrZWTplrxCxmQynDGqVlVenWiz3c9vR5i65xV8iQ0gWCdRgDQCEDgNIXlHjrNNmemmcRHgjZhgBCRTL+sgfpN6VoDgQ99s6isPOLAlhRU5hvXLana+dQVC0ElHER/Pnuaoh+6wOj+FBECuL0e4Jk+t8Zk44pfGcs2nz4f+/k03x8iCJ4urRzr1PzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199018)(86362001)(36756003)(41300700001)(30864003)(5660300002)(8936002)(38100700002)(2906002)(478600001)(66476007)(8676002)(66946007)(966005)(6486002)(6666004)(66556008)(4326008)(83380400001)(107886003)(316002)(186003)(1076003)(26005)(6512007)(6506007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s3OPYBzkgN337D895dK1lU7qyPc9TPP00kQDpytK4VMb8wi0pWIJZ4zmz5A0?=
 =?us-ascii?Q?uXP3/ya4/JutAjhHRDRR8lX3sm+F9f/i5D0j/Iq6AwSvSId4MdaJZsvVBRip?=
 =?us-ascii?Q?tlU7b00Yp5Vo+7ZAScfJEJSiBsQr5iEMYrYnMnIAVFjlAK8++mhDyA1Vj8PO?=
 =?us-ascii?Q?mNxxYRHiK340/myKBeYUNISXmssHLn9APh+5+D3Dh1lUJewAkVBhTypKO1Gs?=
 =?us-ascii?Q?dMeoCkTuABeaZ9QRGNHGB9/CLa20zjia4/v2qCwbKVOUHfdnrrweKkZdbE+d?=
 =?us-ascii?Q?i6WrVPlpiFVkyc+32pSO+4NNd21CRSPjSwP22SWZ2ExgFUKQyzi453EVuism?=
 =?us-ascii?Q?Ctv5TjSso3XLnpon69IJM3JlpWjel+Hk6PXtg/k3nWOYxX6D7wTRXQmuQAkc?=
 =?us-ascii?Q?v78NohGPU4JdcdjbLXQl/5CsvJ4ueRpxdEpY5gXHTPrA2niHCq/nt/xkB/d2?=
 =?us-ascii?Q?3OrDU7AK4kTK/wcucIspirIQWpuy2kRAIg61PgJ/qpNnnO9Ln+fDUFCvz0Zo?=
 =?us-ascii?Q?WB0kQMSMHIGcChNtGm+Vo1ST9EAbSax9rdZAdhk9BVJDZvhrHhbHdYWYXDMl?=
 =?us-ascii?Q?aTsJtUAKvXFQIv39WCo2h9V9qyKX22T5gLpRcXGULSY+9rpoRyfL+5C6N5jy?=
 =?us-ascii?Q?DoMDXqm3KHSCSHCRyYXKN9FF+VRqpo1YQ9Afbawa3i4D2e+GZSmhR9s0KCnW?=
 =?us-ascii?Q?1EAXnM6NQLOlOWjkc96yEzzc0HKq6OhQ0ZOblCA+djLA9M9ryjDz1XZLGiWF?=
 =?us-ascii?Q?eGd3nfNgEwkcPkfMIm8HL+06okyG35Tri2mFNgVfRGhtn9g7pIpVWZa4pnmt?=
 =?us-ascii?Q?d1Amjr2dC2crELLjNuBBunB99c0cRq1Sy+2cXyzq0dVgb6wKwTd7L6upzYjP?=
 =?us-ascii?Q?DnYEAh3R07IXxfDzyE/Fy+qwOtY8vS9ZvDJM22YXLpO4bmJPiBRaNh5/z0QJ?=
 =?us-ascii?Q?EkV3AwOVvrUcep/pctGvus0N2SMhT+K6jH3IxZ7luSQstvDqNm9k7dt7OLgV?=
 =?us-ascii?Q?4BjGTK91JX7ZSqqxLun2pLgyVd9W/lYgFtnbFR6wyaiVzqY2QGFcBVgWqjP9?=
 =?us-ascii?Q?ZeLrVOp3G4yx7nTHPskOPnk3IGuoUniegVeQtwHhBjEGh4PTWZuvEjFZ8z4Q?=
 =?us-ascii?Q?RE6pH0adJbUyEMPufA7TLg8TOpBBR8bTUO8y6V5L/zCiRC1pnYi3OQMo22nu?=
 =?us-ascii?Q?z6nm10tNqEo8U0asGAHHEeFUGTMhmO28ZquzLOI8Nhqu2n3SIXKzhYMzCpp0?=
 =?us-ascii?Q?WZY7TAOxc63zqGrtdun3a4/2ZWD0f8SxeoUA4gCTP0Y8d+4Bx8drnSboQCfy?=
 =?us-ascii?Q?/Vd/DhhO51OWp9HIDRX2aRUJZ2RwvpKAMNopo+byCyEfxFNsDDdspGth1FPn?=
 =?us-ascii?Q?dwURCAyl2iEaWiN3tcGUVCqu2VFkb2k9vsYNMqE1/AwoCwqQqVl5mtiRAIhd?=
 =?us-ascii?Q?/HzNB0C1HdfN9aIh1NKeToa+JjVUBnjKL5xvqmICWVRtc+ACLqomNTtKQZFF?=
 =?us-ascii?Q?1Swutfj1lXtZYqquXM5aJGSX+IsuSRJxleODYFo8AWrgHAQC+8sx0AUIBpKu?=
 =?us-ascii?Q?/m1Oogh/lbJirR95GbkFjhrJwDR7IhpeZQLF928X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb2123a-85fd-47b2-4196-08db2556fbc5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:12:52.6993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Q3+0UMQaQ0xsVH6PrTADOQDydht10JRCirz21l+1g6XLaTI1dfn0Fyf8B68Hz5D+dcTvbs9WNRCS4k/Ssi8Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Since v1 [7]:

Patch #9: Use htons() in 'case' instead of ntohs() in 'switch'.

Since RFC [8]:

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
[7] https://lore.kernel.org/netdev/20230313145349.3557231-1-idosch@nvidia.com/
[8] https://lore.kernel.org/netdev/20230204170801.3897900-1-idosch@nvidia.com/

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

