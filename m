Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826094B75EA
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242092AbiBORCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:02:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242090AbiBORCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:02:41 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10075.outbound.protection.outlook.com [40.107.1.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5247A119F7D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:02:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHFL4GQqaHeuPiQMSPWwfgvDTDjZ5AfOhOUYhjbvsX1Ql9sslgXgR1VXlq1ZMImglBXh4m+O8MUrRFvIqYq6ta9MMZRBg6/jsVKWezPyw+0IFNext6tyldperULwUk4RP8SVJphspP54vJQvpBGQPLkovPLbCV8MCLrV0IYpKrE+o2ieZ0ZQz35eAxB7OPAFg6X70u1D0MxQGs4XbfmxY+0mViRY6E1f2JG9HwsU/MK9gpF6aCnIUKAvzkYOJTlGHSNcpktm94Lp67xUrs6zQK3eretLXK557WV/AQyeKmqHLe8rIkkJ8KCf6qm6MAKHvxUWNHFIeI7u8qvesTedCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uaa1MvdosRr1MPQIp2Kd1COb/13oWQmxrBVS6Dd0vcU=;
 b=PRT7ReRmlLm9WGlEuQfnXW4Onns81DSOlNaANZsqVsyNTIXF1hMzzG7VHvPyOEgV02a3Xk9sJxtsNAVCgkRIErux+/lnvXZTvhDCc00U/rgmIlTvm7wSkpIHg35BU8IHb/dy8LdI+JsGbDeuaNF626h412mOPxCOAWhoz33/bz7Z+njSM1cDcOXlxVq/3Zk4otc9Dwc/6haXXU1N3JMHUGWG2QqKxBH7nueioopnxUYHqd2Ae08pXZOSWjKEY7o7sOOM0MjC4BxehC/OYEx8hfmeYFMfJwcwBkr+XcqAaffEuWI3jzTvbkctEdb8+iw1rZL7PaySNE/NVYRhiZfUhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uaa1MvdosRr1MPQIp2Kd1COb/13oWQmxrBVS6Dd0vcU=;
 b=cScpSzjQmtsKPpXrBpLipbeDlxlECf037ky/Jd53pbZV9EgRcffZBxHPSPgMGIUzxtZJTV9yjIMmmDwsGhKPSjzUhkPu9lGc/q9j/MzJQum+mcfasikTULHu6HP6vR2Hg4s1icTkNeBN0CVv74A1Db1dLNgJSKik3o52B18G+cg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 17:02:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 17:02:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v3 net-next 00/11] Replay and offload host VLAN entries in DSA
Date:   Tue, 15 Feb 2022 19:02:07 +0200
Message-Id: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80a5cf53-c252-4bf1-fa1b-08d9f0a4f189
X-MS-TrafficTypeDiagnostic: VI1PR04MB5342:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5342CB5CD42D9019514E910EE0349@VI1PR04MB5342.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntDxmALdoqt24BIHk3K7DWUGB8wAfTvAmnyxH8XKuKh0b5+F/qRjxW2jEivU7WiZbX55QG70OQu4ff6w4uRA3nvZ1PJbWMB5nYGAYqJcVDbnY0YO85qFHxaRqw/CpD0B5wtiFLW2S4hJY7KT52aUxRlIJBF5UYtQZI67h3NBlCa5aSYlLXfwky8X60Z+wrZ5FD4OnFTnyAk6OPdWJDrFFI8hgN39BTIqbTK3yAC9ZVYZ0kNZHLRRQ+kwBQ8hU3oEwtmFb14vJMRPjDLhjEJmcPACuFtwJfgRFxei4xghx/XsfLtbAnusGhGhxR+OpaB3YZ1SdycWwdQS97yLdxN4l+//YneXFvweUTcULlMXTJ2p/Vll56ohTep5pOWyfku39ZcQwWESBXyfuxQJj3NZdv03tRpYn4D136ewAA9+Yr0m2fHRb0+sj+1pVZeKBD6j3QUH7XJ97a3J8UlY6QlVn5oelAcxMk1T4WgQZmdSAGQbX7iGncW5cDlQyom4PPzGEw+TEYfN3ntZdGYHcLi01BDZTcttjkQc6B6TG4dqjl5HztOhLp2RgLfpLFaibR42iGhXLpp6jCCmwF8xRQ9ACf7hqP4tHjGiGSbelzL6qiPYYL6yAjjoFHZ6DcANXFzxWbwqMfdYROVEGAJG9EXuqzBhl30c6TNuue6nqiLT+iXc8O3+FwZe+BYsbRLO3VRDpxbVVTnMxiRnZe7Mrhq80epjY50HbaaBMdtFV/L4FNQpQzeN+3yl9twRXZS/FduEgDUBbq2xSD7Kq88e2FjKGEl70wgYP18UZzrIlGFJfwo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(508600001)(2616005)(316002)(26005)(6506007)(6512007)(54906003)(966005)(1076003)(38100700002)(6486002)(6916009)(52116002)(38350700002)(2906002)(66946007)(4326008)(44832011)(5660300002)(66556008)(8936002)(66476007)(7416002)(8676002)(6666004)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L1t8LmbgqGtimrY8RYLD0auiYF2S12t/1DhjiZxTZoZhC9jxLS/OYbc+hi1A?=
 =?us-ascii?Q?jDnRFv33dliv68Tn814PG8PV0QzJSDN2F6840IQaR3hV7sT+EhAiEESmSrV+?=
 =?us-ascii?Q?Zn8llBIgcbESNc3dYxCeLzl2qal8ueB5r0Gpjc03p/jPaoI5KWR0jn6qGdm0?=
 =?us-ascii?Q?BQKdVDaZOw0Ri3WKo+SI1MXIDhjcLOtYf8iTy18YOMEvC+SXV+G7c9QLiT40?=
 =?us-ascii?Q?2gsgHo23cP25E25kYv1kRgh/uipPum2ATe9uJZ/9OCiP3deqWa9NIk+to08i?=
 =?us-ascii?Q?tsg6cvitJMXMY9qpnPhQciXsf33HOiGvPaA3F0zAMiM60yFr3RlOmxdIxPnq?=
 =?us-ascii?Q?8LfIvQuSmiP7w0KrN5dAnz/194hwJ9IRBgveXaoe2pymNA4LPE41LkfuY5ps?=
 =?us-ascii?Q?o5v0mYsYxp02D70djW1iEZS6/1cRIbhHbYL4HmV5eeEZuWFgJ6tkYUObGbyq?=
 =?us-ascii?Q?VC4mwJEJqC9KzK2EVHgL5Zl7w9VeMYbiQMi28JOonC6OssMY+qmZR/xGrT9N?=
 =?us-ascii?Q?8Y2V1XRED3Y+9L1C/k/Bfzdsf6fGrj7SSuJkIBXdLWgCPExKaXthXYyJwMiB?=
 =?us-ascii?Q?MiM6j/GzdfzifZFqv/aGtWUyPUgabe1VI6tkjOHCjgE7a2Yjh8tV50xakQCV?=
 =?us-ascii?Q?pfMgUxpHjUDa5lCyMlDBxH2a5NXCqk9ijfoEeEarXY5ThG+8VzR1j7qGnowU?=
 =?us-ascii?Q?IVujkoZXePucOvgxevTrvfJ6bMaskh5kmHIG1Bt4FGMmMvu0ffJNfshnGBIJ?=
 =?us-ascii?Q?t0+EemkNpjQ8UNd3BvPORQFVgYkZ4u2S3LdyOxk0+hv9fypD6y5Bm2ncIhZ2?=
 =?us-ascii?Q?wLxW/j3c4BfOyAPEst3vfzaoUpumOZRUBUMUpGrlAyAJxL3JBRzn+DJ/flSk?=
 =?us-ascii?Q?8AvzL5iS/JVcWvqbyWFJH7y5uHhfb8JWPZfraek0PEyC1VzpGV0rCgTJ2jv8?=
 =?us-ascii?Q?hWGbK8cV2aGG8+kgQapi3SlR4451Y2ORoDrgCUVhba3ECUH4hBNaDFgxEiD3?=
 =?us-ascii?Q?IgC/+tF9jC2NU2InSYW4ivZGLZrQA5vuF32XdAmqC7damjp7oA200tPxnemV?=
 =?us-ascii?Q?/DEy9MBSN79fJecTTRWfTx1wKNfuj1FVM28E6X1VYoUeqiNkOWcoeA6f4aUh?=
 =?us-ascii?Q?DHHAY1/m4b1gGDgVyYYUXRCZw+mM3RM8g+aPNK6/V9alMjEl1zHtId+8n2kJ?=
 =?us-ascii?Q?JQA03IKL7JgtKL8PMSpXFHl50cddg9NorkYxjP0H+0pi+cjtwFZXIkeIOHKA?=
 =?us-ascii?Q?ce69t70xn9PJkRJFwHekzRquaLKBd2SQXQ16yuenD3+8pl9aOoO2H4RUYtIC?=
 =?us-ascii?Q?OgGnqWOGcxX+1NjpehActFgrdezBqlGAEbzOtwdeWh5t5abi0FzkBLWRU6w2?=
 =?us-ascii?Q?MKU0TO5MCKDbT5Z0aDvGK3G74hO5YhBHTyWml4HnbvFKEw4CeIU45ZURDtmh?=
 =?us-ascii?Q?d7qoUo/yott8zm3M2Q50RwCNsAUkRLnzPEZfXICVlt9AWAP0pdYYheS+G3Wj?=
 =?us-ascii?Q?INba5I5y3E/XLuG21X7zYwV6rjk03TQF6P/0RQ4bsI+KyAfi1AwOZHausL8L?=
 =?us-ascii?Q?BHPufvRz4zQ72d2+2V1SFzGduqqmyj8u9jAVw7NMMWFIgo3tIjd1trV1wgOp?=
 =?us-ascii?Q?uGWK0uxaagCOEoZMbbnxFb4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a5cf53-c252-4bf1-fa1b-08d9f0a4f189
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 17:02:27.0102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBJtyXjecnV2yAMLn2qSAXwUYL0MTfyMCOGKqL+SrHo/K6VwHDsp2cyNM3hFEeVwWbaD+2W90PIyqENSej/TiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2->v3:
- make the bridge stop notifying switchdev for !BRENTRY VLANs
- create precommit and commit wrappers around __vlan_add_flags().
- special-case the BRENTRY transition from false to true, instead of
  treating it as a change of flags and letting drivers figure out that
  it really isn't.
- avoid setting *changed unless we know that functions will not error
  out later.
- drop "old_flags" from struct switchdev_obj_port_vlan, nobody needs it
  now, in v2 only DSA needed it to filter out BRENTRY transitions, that
  is now solved cleaner.
- no BRIDGE_VLAN_INFO_BRENTRY flag checks and manipulations in DSA
  whatsoever, use the "bool changed" bit as-is after changing what it
  means.
- merge dsa_slave_host_vlan_{add,del}() with
  dsa_slave_foreign_vlan_{add,del}(), since now they do the same thing,
  because the host_vlan functions no longer need to mangle the vlan
  BRENTRY flags and bool changed.

v1->v2:
- prune switchdev VLAN additions with no actual change differently
- no longer need to revert struct net_bridge_vlan changes on error from
  switchdev
- no longer need to first delete a changed VLAN before readding it
- pass 'bool changed' and 'u16 old_flags' through switchdev_obj_port_vlan
  so that DSA can do some additional post-processing with the
  BRIDGE_VLAN_INFO_BRENTRY flag
- support VLANs on foreign interfaces
- fix the same -EOPNOTSUPP error in mv88e6xxx, this time on removal, due
  to VLAN deletion getting replayed earlier than FDB deletion

The motivation behind these patches is that Rafael reported the
following error with mv88e6xxx when the first switch port joins a
bridge:

mv88e6085 0x0000000008b96000:00: port 0 failed to add a6:ef:77:c8:5f:3d vid 1 to fdb: -95 (-EOPNOTSUPP)

The FDB entry that's added is the MAC address of the bridge, in VID 1
(the default_pvid), being replayed as part of br_add_if() -> ... ->
nbp_switchdev_sync_objs().

-EOPNOTSUPP is the mv88e6xxx driver's way of saying that VID 1 doesn't
exist in the VTU, so it can't program the ATU with a FID, something
which it needs.

It appears to be a race, but it isn't, since we only end up installing
VID 1 in the VTU by coincidence. DSA's approximation of programming
VLANs on the CPU port together with the user ports breaks down with
host FDB entries on mv88e6xxx, since that strictly requires the VTU to
contain the VID. But the user may freely add VLANs pointing just towards
the bridge, and FDB entries in those VLANs, and DSA will not be aware of
them, because it only listens for VLANs on user ports.

To create a solution that scales properly to cross-chip setups and
doesn't leak entries behind, some changes in the bridge driver are
required. I believe that these are for the better overall, but I may be
wrong. Namely, the same refcounting procedure that DSA has in place for
host FDB and MDB entries can be replicated for VLANs, except that it's
garbage in, garbage out: the VLAN addition and removal notifications
from switchdev aren't balanced. So the first 2 patches attempt to deal
with that.

This patch set has been superficially tested on a board with 3 mv88e6xxx
switches in a daisy chain and appears to produce the primary desired
effect - the driver no longer returns -EOPNOTSUPP when the first port
joins a bridge, and is successful in performing local termination under
a VLAN-aware bridge.
As an additional side effect, it silences the annoying "p%d: already a
member of VLAN %d\n" warning messages that the mv88e6xxx driver produces
when coupled with systemd-networkd, and a few VLANs are configured.
Furthermore, it advances Florian's idea from a few years back, which
never got merged:
https://lore.kernel.org/lkml/20180624153339.13572-1-f.fainelli@gmail.com/
v2 has also been tested on the NXP LS1028A felix switch.

Some testing:

root@debian:~# bridge vlan add dev br0 vid 101 pvid self
[  100.709220] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_add: port 9 vlan 101
[  100.873426] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_add: port 10 vlan 101
[  100.892314] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_add: port 9 vlan 101
[  101.053392] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_add: port 10 vlan 101
[  101.076994] mv88e6085 d0032004.mdio-mii:12: mv88e6xxx_port_vlan_add: port 9 vlan 101
root@debian:~# bridge vlan add dev br0 vid 101 pvid self
root@debian:~# bridge vlan add dev br0 vid 101 pvid self
root@debian:~# bridge vlan
port              vlan-id
eth0              1 PVID Egress Untagged
lan9              1 PVID Egress Untagged
lan10             1 PVID Egress Untagged
lan11             1 PVID Egress Untagged
lan12             1 PVID Egress Untagged
lan13             1 PVID Egress Untagged
lan14             1 PVID Egress Untagged
lan15             1 PVID Egress Untagged
lan16             1 PVID Egress Untagged
lan17             1 PVID Egress Untagged
lan18             1 PVID Egress Untagged
lan19             1 PVID Egress Untagged
lan20             1 PVID Egress Untagged
lan21             1 PVID Egress Untagged
lan22             1 PVID Egress Untagged
lan23             1 PVID Egress Untagged
lan24             1 PVID Egress Untagged
sfp               1 PVID Egress Untagged
lan1              1 PVID Egress Untagged
lan2              1 PVID Egress Untagged
lan3              1 PVID Egress Untagged
lan4              1 PVID Egress Untagged
lan5              1 PVID Egress Untagged
lan6              1 PVID Egress Untagged
lan7              1 PVID Egress Untagged
lan8              1 PVID Egress Untagged
br0               1 Egress Untagged
                  101 PVID
root@debian:~# bridge vlan del dev br0 vid 101 pvid self
[  108.340487] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_del: port 9 vlan 101
[  108.379167] mv88e6085 d0032004.mdio-mii:11: mv88e6xxx_port_vlan_del: port 10 vlan 101
[  108.402319] mv88e6085 d0032004.mdio-mii:12: mv88e6xxx_port_vlan_del: port 9 vlan 101
[  108.425866] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_del: port 9 vlan 101
[  108.452280] mv88e6085 d0032004.mdio-mii:10: mv88e6xxx_port_vlan_del: port 10 vlan 101
root@debian:~# bridge vlan del dev br0 vid 101 pvid self
root@debian:~# bridge vlan del dev br0 vid 101 pvid self
root@debian:~# bridge vlan
port              vlan-id
eth0              1 PVID Egress Untagged
lan9              1 PVID Egress Untagged
lan10             1 PVID Egress Untagged
lan11             1 PVID Egress Untagged
lan12             1 PVID Egress Untagged
lan13             1 PVID Egress Untagged
lan14             1 PVID Egress Untagged
lan15             1 PVID Egress Untagged
lan16             1 PVID Egress Untagged
lan17             1 PVID Egress Untagged
lan18             1 PVID Egress Untagged
lan19             1 PVID Egress Untagged
lan20             1 PVID Egress Untagged
lan21             1 PVID Egress Untagged
lan22             1 PVID Egress Untagged
lan23             1 PVID Egress Untagged
lan24             1 PVID Egress Untagged
sfp               1 PVID Egress Untagged
lan1              1 PVID Egress Untagged
lan2              1 PVID Egress Untagged
lan3              1 PVID Egress Untagged
lan4              1 PVID Egress Untagged
lan5              1 PVID Egress Untagged
lan6              1 PVID Egress Untagged
lan7              1 PVID Egress Untagged
lan8              1 PVID Egress Untagged
br0               1 Egress Untagged
root@debian:~# bridge vlan del dev br0 vid 101 pvid self

Vladimir Oltean (11):
  net: bridge: vlan: check early for lack of BRENTRY flag in
    br_vlan_add_existing
  net: bridge: vlan: don't notify to switchdev master VLANs without
    BRENTRY flag
  net: bridge: vlan: make __vlan_add_flags react only to PVID and
    UNTAGGED
  net: bridge: vlan: notify switchdev only when something changed
  net: bridge: switchdev: differentiate new VLANs from changed ones
  net: bridge: make nbp_switchdev_unsync_objs() follow reverse order of
    sync()
  net: bridge: switchdev: replay all VLAN groups
  net: switchdev: rename switchdev_lower_dev_find to
    switchdev_lower_dev_find_rcu
  net: switchdev: introduce switchdev_handle_port_obj_{add,del} for
    foreign interfaces
  net: dsa: add explicit support for host bridge VLANs
  net: dsa: offload bridge port VLANs on foreign interfaces

 include/net/dsa.h         |  10 ++
 include/net/switchdev.h   |  46 ++++++++++
 net/bridge/br_private.h   |   6 +-
 net/bridge/br_switchdev.c |  95 ++++++++++---------
 net/bridge/br_vlan.c      | 108 +++++++++++++++-------
 net/dsa/dsa2.c            |   8 ++
 net/dsa/dsa_priv.h        |   7 ++
 net/dsa/port.c            |  42 +++++++++
 net/dsa/slave.c           | 112 +++++++++++++----------
 net/dsa/switch.c          | 187 ++++++++++++++++++++++++++++++++++++--
 net/switchdev/switchdev.c | 152 ++++++++++++++++++++++++++++---
 11 files changed, 623 insertions(+), 150 deletions(-)

-- 
2.25.1

