Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1668A68AB76
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjBDRLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDRLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:11:44 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2066.outbound.protection.outlook.com [40.107.95.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B6F2B090
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:11:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0XjWJ6bzVRr++1o/q1afomBDPjIwv11KPsKFq3KNW9kzsMzEk2uRJwV8I0KmvvO2ORBUp3DByTXTnlfIcxAaqZipsKR9hngNMtS5yZGeDHLrMMMuK8BCGfakuZpftgMfQhWYZ0qkYksVKE1A4JzCZwEfzdj5970KuhQNeoDnB2ZIrodK9wUeXfaHv1jULPeOHjeaexDcII9qA8yH2Lxdq03S3NpFa91YSO61w5GLM2RmmbnLYfDknJuUeNg0T5oxicr4aslaeeYpxCSPzqmPg1rW/Wbaue8WB3V0Zht5qHJLOIKIbsosaGd+9GleMXMbVFij/wfDB+EFsUSXXJtnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GZ7DrZWPwBmIaIY/XfKy9ZyaInod7eu5cbALe6gc3PE=;
 b=LVd5PjXDVetHC4HNNfDNSG+zAoo3ITxlXA10HwHE5nySYtOayc7aVbiHMqI4CfweqT6qicp27zj6JX90V5hZYk5BWKYW3LQ8QLpRvUTNFObKaEZjF2pzjVTgo5INXyM6MIrAwNiHTY4oWxK6Mrys2vFgxGtq85zPDp16CpylofFjajjP+OmfPa/bV70/AH3cgTcHbRXDWikVdDZHwZk1evR15DE/3yg7becxQNgyogbtsfeKeIM0KlgJMo4k3bTeGf8fztuP68w/brbZBIq7G/qumAJzQMEmZk9WrJM2nunq+h44T6dCrWU7T0aqgCmFFx7kPSUWda33aSV3E8OsvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZ7DrZWPwBmIaIY/XfKy9ZyaInod7eu5cbALe6gc3PE=;
 b=QeVWRmRNWMVIoiflLT2nnqr2VKf9YVljpmdQzd8FVyhyraoXjnVBGrO8esqcPZhm4aaV92UAh5cQk2G/clZ4WO19HB2Ly5I6cZ0RtdIXZKxfV+3la2tAtb1ejmxO8gXyWi0ZU0Q5Fmi7yl3KatV/0r4i6OBvn/TRKSLK98d24H6dpJOEfUJ8gWuXFTHSF22yYwaC9cNW3+ZjZY9xKxdBtWtAzM55MCPKCaE8qX3xv21dS/Oc+jFwVXSGCeBag3wnEdSobsP7PWlQC1kjvFhIiB26trPSza0QUjNyo9x3IkXjIRB4mgJYOhKP+3Uz6MOZ4Qrt6JrgE+9XFr/UChm7Dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:11:38 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:11:38 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 00/13] vxlan: Add MDB support
Date:   Sat,  4 Feb 2023 19:07:48 +0200
Message-Id: <20230204170801.3897900-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0029.eurprd08.prod.outlook.com
 (2603:10a6:800:a9::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: 4deafbb0-a3a4-4d58-c0e6-08db06d2e098
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bkT47Q/PdVVhcKrWSqE8IrqFIqoA8dm/5zit5RCck1GHtnsTBYS760jIwFzHlri7erBn19OkWPprjv17P1IyoiC4tgzO8v0Kzlo/Fe5TfFiz5m/18p5N2R2EKhbO9OkGnh5HpZuhlzuXpmCLbppNVzBVG63tuvinkzBasu50FJChFGYDcAuGbnVeO+Nt5DNiLZRhlVgzlopBgeV6fPJ3bsZPfltl2P5Nxn0xeiGX0nu/kPmouQ1BTaex/JUy1IatvGbwgdXBMICCsNwMmuwudZaa2cJb043115Xz/+d6fZdF/V3UrpGN6dmAvwi26jmM4wmnqy+TIQEfuivuiGIyTP2tqtELe6sQF4xh8aEv1ObQ8gWPvVSpTfDToECB26dUDsAgzxiweO/YsyBxhjYMkaFNAjpQxPvmAYDVOrY5VpigR8RYOiVuLSq//NYI5RlfiABh6rPZQKi6fUuT9pidFVXSTjia2MNMOkUweFYZbv7wfz35paXZWdjWHmUQQjVMV38f1q+IJbyDXpvHYonOyomLm7jTd0xPtUg3BGOEs5Jn3CNqPeFk8xU+Dpqk/Mou+19YyJauuT+51uVG6cpZS0MTHU2jNlIULRwmirctg45wn2O2cLyERcKSh9S3hhDsoWsrNB/GH8Sv0cLEIFRa+8SCoIHS3PZ0on/Us8JXJFD53y9UlgGk1a+F6mbaJ6f+rnfkMj/knBMG1+0t40WrL1QqwYOB+ezU26w8IXxVhIB0lBNcqSdg0+SCwkQPG2Eo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(8676002)(41300700001)(66556008)(316002)(66946007)(36756003)(966005)(66476007)(6486002)(1076003)(26005)(186003)(478600001)(6506007)(6512007)(4326008)(6666004)(107886003)(38100700002)(2906002)(86362001)(8936002)(5660300002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ovr652qCVYxpWO8NNkQaGdAFLSDVXioOuN2Io4S/Q2tCKiMtkOFVoBVi4mLH?=
 =?us-ascii?Q?Ymjd2qh2BikQLd+UkCGeL1935K9uD+YtqIUgOlFIE5QK0BFkpF89G/YqWlGS?=
 =?us-ascii?Q?PMYLld1Oe3PKQxAxOXTZDzK48m1STfTMBDiy9YpTIhMdjoc5N8W3U5voUlTD?=
 =?us-ascii?Q?WwkbaXwHQG7If4lGES7qrLpn5dmR391jt25trgAk6Xz6RWfyVksQmtouFHWn?=
 =?us-ascii?Q?zJcrhJKXysRXz1IynV8qQrKvhIciuZ3Fs+/65XgGrVK3rfNQA4Tag1OTo5+S?=
 =?us-ascii?Q?toJYtja4y0QVu6FbTNfPRqpVeNU1o8zmuiB/2SwtGgW84igPxKM4MTeX2NcE?=
 =?us-ascii?Q?git9AD5jZws44oTcK9r2AQa40ymvimWfgW7vzsAs8gSLcjWVhccJs6Utqm4S?=
 =?us-ascii?Q?OGDpitEdOGm3bJ/mVccQetXiseLYJxPkFUU8HoFYDvFQ0xgVpcO0DF2QKpNz?=
 =?us-ascii?Q?lR6SifEWBfdTF2GOpB6Uw2C4XSo3Rd0/l7encBY2Dny9AYNKJBu3od9KM3+X?=
 =?us-ascii?Q?FGFIz1jChDfqKC0r0XAJ5xY2zQOOebo5FPSFo+VtGpNb9F95pUlkKG6+WQ02?=
 =?us-ascii?Q?nTcrnfLPzth276SfCgobuYaBVlWQDnFBx11RCIxR7kxooeK9Dm110WCv31go?=
 =?us-ascii?Q?Fg9xlCXPmgcJQnsp3bO7M5y5IDZGHiwUmcw0VyctttC2hWjlnjXVxcn2TVqI?=
 =?us-ascii?Q?qL551me4d5w8jeWsjg6mSoPDWZChmOs4clDTZKPeGk3f9fhhIRXW2e7a6xTK?=
 =?us-ascii?Q?x059UltUvwij2bI8EVqvyLokPOvcuoHE18/QT5JJIuv8NiYt00EnkQWoB0Cn?=
 =?us-ascii?Q?KAUERPZ0dhgtmce5MLbG2k+6wS5tgoxjrWZtGPVsLFsknlSv9Ro6ahpk/uM6?=
 =?us-ascii?Q?0C30/So/n2nuTDIA9GSpodwKkR4Ey/KD6E/tDl5/wXan7FdmAhnM9ey9vGui?=
 =?us-ascii?Q?uErA6vIr+pcrxJbOV/XR4kS592rIvlx3EI5aeJ8TA8IWggmNlJXbDVEzmRVg?=
 =?us-ascii?Q?NxdxKXmbLVCI7FUaLRsKjg+8/soi+7Hxr2MeNhABpC4+EY6yWga33GtN80O7?=
 =?us-ascii?Q?EFRkeyFZO6PNRyO0KCDE4qPJlBrTAiiYs0G/MwKU7i4wpreqchxjGsLxSP9k?=
 =?us-ascii?Q?J7kQu7jl0uJA0l6FPBIxXRGEllVXIKIQRTFKkjf1uwx5tSMKXAWdj4k9uf0U?=
 =?us-ascii?Q?WIsY1PXIZfUmOjbF+osHykU6b+nTv68l+2YvWJFAFQte7eRjxXKB38voqpuD?=
 =?us-ascii?Q?QZ+uupn1vJpdIYutpUbR1e8STBgAGcpaxOo6VwjLNLtoitA6ZI6B5y3Ok+QE?=
 =?us-ascii?Q?UioA5YNgLE1oEfhbLxgqe89f+ye2VIhQzTEnURsbryLt/agqnhwk3IJX3XhN?=
 =?us-ascii?Q?F2xtfGC4+5pGhhLLFSEabB4QsNutvHRPb7ae/J8Iq2u6bDe26m6NdktFH8T7?=
 =?us-ascii?Q?JDkxU0DSDZEtVpjyEHb5mlEguG4spgakZg0FeoGOgX7It2wM0nGPKZNW/oCL?=
 =?us-ascii?Q?znmGAzRk1QbIjbyrSypwmXTbWy3x5r75+Y7O0QeQaPKBU0KCyRv+6mWFnv4I?=
 =?us-ascii?Q?O8rguQwiUmVzfpF2kG04KXH3gsw7KAuzGM+NczW+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4deafbb0-a3a4-4d58-c0e6-08db06d2e098
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:11:38.6093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4zZb/047R8YFFRrWF8zphYmgd9f/Ap0bP6GPGwUsiFbIqFKjvZYCgF1/YoQMHnpkAixINc+M+eTs5nEHJeczDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7997
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

"added_by_star_ex" entries?
---------------------------

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

Given the above, this RFC does not implement support for such entries.
One argument against this decision can be that in the future someone
might want to populate the VXLAN MDB in response to decapsulated IGMP /
MLD packets and not according to EVPN routes. Regardless of my doubts
regarding this possibility, it is unclear to me why the snooping
functionality cannot be implemented in user space by opening an
AF_PACKET socket on the VXLAN device and sniffing IGMP / MLD packets.

I believe that the decision to place snooping functionality in the
bridge driver was made without appreciation for the complexity that
IGMPv3 support would bring and that a more informed decision should be
made for the VXLAN driver.

Testing
=======

No regressions in existing VXLAN / MDB selftests. Will add dedicated
selftests in v1.

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

[1] https://datatracker.ietf.org/doc/html/rfc9251
[2] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast
[3] https://datatracker.ietf.org/doc/html/rfc7432
[4] https://datatracker.ietf.org/doc/html/rfc7432#section-7.2
[5] https://datatracker.ietf.org/doc/html/rfc9251#section-9.1
[6] https://github.com/idosch/iproute2/commits/submit/mdb_vxlan_rfc_v1

Ido Schimmel (13):
  bridge: mcast: Use correct define in MDB dump
  bridge: mcast: Remove pointless sequence generation counter assignment
  bridge: mcast: Move validation to a policy
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

 drivers/net/vxlan/Makefile        |    2 +-
 drivers/net/vxlan/vxlan_core.c    |   78 +-
 drivers/net/vxlan/vxlan_mdb.c     | 1484 +++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h |   84 ++
 include/linux/netdevice.h         |   21 +
 include/net/vxlan.h               |    6 +
 include/uapi/linux/if_bridge.h    |   10 +
 net/bridge/br_device.c            |    3 +
 net/bridge/br_mdb.c               |  214 +----
 net/bridge/br_netlink.c           |    3 -
 net/bridge/br_private.h           |   22 +-
 net/core/rtnetlink.c              |  215 +++++
 12 files changed, 1907 insertions(+), 235 deletions(-)
 create mode 100644 drivers/net/vxlan/vxlan_mdb.c

-- 
2.37.3

