Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE04AFF37
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiBIVbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:31:11 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiBIVbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:31:08 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140081.outbound.protection.outlook.com [40.107.14.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60146C002172
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:31:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLbBmSDKMgOFvYLNlNTe4WFqoHqVWSEPhIYDtYgCqwESPQj/3TpOKl/D5PuPE2tNu2DGP/Vb+QnSJdX9MAJDR8+r+4zcquMzOAlYtiFwONXiBaPoW2awTLBwnuinAF3/x4z9k+eyDigfNAQoqlzbtZ5c1x5br1d6uuDqJjq1tTcZxSj65cNJbnOVczMsCUa0PjpLtdvVqeNVKQa0MHQRU5ZRM5oYhHda3neCVKZD7dF8cniOm+Rcr1mszvqH6QkmNyHpYAqLA8hoMxBHG/HpU8+DIH9JiD28Ydvg7i2VoFBYLZeXjtG0zfiHKtnR+7kte3REBuoCghKbGDfa/Ls0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msR7w9ipr5Dqjw+LS8gK7YaX7fn8db7rP0ErMmV48F8=;
 b=ffLEzhSiHID9+e9wg1MFZz2jstXJb0e0B7jsSzh+nAZogzzMtA5+osvZYwYqkS8tfMOhhWLe2CjxaBqiRsD/LGKRilGS5XiXBS3i3DUjanLbSM3lyRfbxdUS+uNmQY4oUeDGvujsw4Gj+/ft6asGH5UFD0iQPB5wkT8QCJwg6S2oMbTMvMCmWa1CrRMTzy3ibkj6DBz8MQH9ZmObuwFuHaJKf2EJw17PZxzpwqBP+SMS/zw972mNqnGRVp78zydPADkVmSQkihYDsvwDsKqJ+LExODYdTC6WGGv3HKfpK0m4HCZ5m315iFxF84h1YeqU4WBZuGQS/PdxAlVyUJQCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msR7w9ipr5Dqjw+LS8gK7YaX7fn8db7rP0ErMmV48F8=;
 b=JFVY7sTXNCmP6MFKbynjE5yjmTsgJrzJzS5DyslPuLYYaQYP7GEK2x+pKJPZbrG3dprT+rXhLjQujo0DE/IytxvlykHRFpMgW59IsgNFbbWVTc7Hg/ccWl1lUkFsimPQv8CTBWCW0/tiCFIRJKq46kJAIcmjWfZRRxmEd87TJ7s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR0402MB3481.eurprd04.prod.outlook.com (2603:10a6:7:83::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 21:31:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 21:31:04 +0000
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
Subject: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in DSA
Date:   Wed,  9 Feb 2022 23:30:38 +0200
Message-Id: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0077.eurprd09.prod.outlook.com
 (2603:10a6:802:29::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78502a94-8943-473a-3108-08d9ec1379f6
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3481:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB34815F4C6922830F5B91F918E02E9@HE1PR0402MB3481.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zi7ofEUb1tXw7xSM/VegvLLNPfeoAN0KHYlcr7k+MH6VB68707eovghN2udipnCdfHhg/MK3Ft6Ur/h+5GBdw/5XpQUeHOfaFeKRfQzkAh7SA6+kki/2ubaIcFfADo6/tWB0pjxlk4g+LjOTZxg6OmZmeqwua+a+gMd6xcNcSWu4joNofPDlwm5MAPqu8PISM44F/7/660Z2n5Vf0FkV1KGUFWN15lZrEuNlnd6XKJbBpcqwiQMXB8MBlkSeCb0mfYLj/DYFCCx2cN3KFVA/PRYkuoIeU6OlJb66ePsdJkp+c6lG4c8SnZtVNkF4ilB1P1th2OPnH3qKJzQkCYVVO9k95PrJGKk3ooWs01t34rScCOtnYpkhqyC/tCuE/gaQUnWzA0cfVvAwq2xWfrLKYyLxdt97ct7X1fhL1nGVJANYyWdhAVvviZiC0jEq1a18jGHb2LTwW5D2NFdN72+AzU3mIEWw6JyDyLVQKUPn7ogZp34zEk+GSlaWlYk8fb3ptWXVYU31yBcsIHhyiHLQpDT2hJbl2ZuEFciRfs+0nAvgfQlKuteBvViqV5NpAu8GYDwABTCVE5HAQ/XqD9fpZAD+UDMwhGpHV8GyXLiGsNC5Mf8BVOqh2R2ZpWC0AZLVdQPQOs2aYEYOcW8y8nKnbjXjsDqwxbrtSoawf85sMR0/UarFSClc6s3qxXYUD2rWyrFb2hO3s9qxy/MeRmdeFMFMy6bwR2HLq+z50W86p0u7cOmI6E1bM+pQTj/gRaGRk8k/eS/oImFyUKuUJ4PsOk6vAIvkpsmL3C2jqkBAayg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(316002)(6486002)(86362001)(508600001)(66476007)(6916009)(966005)(83380400001)(5660300002)(6512007)(44832011)(52116002)(8676002)(186003)(26005)(7416002)(1076003)(4326008)(6666004)(6506007)(54906003)(2906002)(38100700002)(38350700002)(36756003)(2616005)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ML2/PUFtfp35+ZiFPaoEUpqgdug7sUk2W9dwl5A0ffo1yjZ4oE0X/Ewlv+3J?=
 =?us-ascii?Q?Gy0xKvDJtQExyVWCjKp1mvh3l27iZfAKOCVg2M/7h7DhLFJ8cS1+WpNQwMH6?=
 =?us-ascii?Q?NvncszWz5lccqcWDtjv4hWK7AKZ1po5vflQEP3Bl+WSp7fNe3dxiQ1/ShxtY?=
 =?us-ascii?Q?E03RmbPcIaydnJROL3adefHMGRs2lVQhvQqw9HdOMSyD0M/HRpyMnRlKDxB/?=
 =?us-ascii?Q?otCMIZTXqTWt7F1IodhM/vBO+b5gAS9aRwnAjNBPKwj8LI6052ZjReXGKHYP?=
 =?us-ascii?Q?eHLEVBic48yn2Otxbxa7ZlFYENdGGUX0bLl9VTx4/5fSxQtOpCSlxkJdxAiF?=
 =?us-ascii?Q?4kpUdkb8aBI06aX97vjrqh8oVRTOY+ukg6va8iYzo67k1nQYUhA5L+KtNB02?=
 =?us-ascii?Q?M1CmKQZdzjQSORqtRm++lOm7rOUPtnOEFCKwmW99Mpg2PP4RqdQZblcgaQF/?=
 =?us-ascii?Q?8yglvN+O0Myy88HRpseUiaZuNxvwHJeWMzXLmYKrxM7eD2Zw5XA26h7TTG+v?=
 =?us-ascii?Q?M+tK1O5Vu8PAdXLMhI2ZIxkBnKxg+oer6it1y6SzBc0QTAR+vBvMI7PC7ugi?=
 =?us-ascii?Q?eJQEmc04IT+ZAUuaY+P8xAplL43fpDJkLfGgDzhN46d6x3e73nWdzj2aFUtp?=
 =?us-ascii?Q?da8Hms26k3PhKbskQCyULEdAsnNPkwYGw89ay/Vaz2rraGxUe1v7uy4SCWD4?=
 =?us-ascii?Q?VEU7kf3b030xPwgNpKm/tC4abtrLh59Wlcl433yL30C+GphpeuZw3M8C5ooe?=
 =?us-ascii?Q?PfEjTAOR5Yvr8jUP35HoLJsbf5mf/pbUfY45Px18u7vAeUqBNZ6xnD6i/w2j?=
 =?us-ascii?Q?djMrSj0tUQ3Eq8atu+IP20xQVtZ5B1ocpTIa9d5NBwZp21HfLZYXktTSiXqS?=
 =?us-ascii?Q?wg6vrxoT1kMtoG3+Ge/iWyDwCs3Kh0ZUhCrQJxYjsCYPw+CGFQAhJCupzrug?=
 =?us-ascii?Q?MkZrDufy1SkylT1VSK3e0ugFwLbAFc465NotgyfJ1NTOVAV47uXeAO111pSM?=
 =?us-ascii?Q?+BC4k9HZqYJpTeYA0sZLSSiu8WujtvKp58c5NsMiahROgPI+tEv4DNe8NqJR?=
 =?us-ascii?Q?X9i0DnlCPwzavcCWKclFDlFQzQ5WPigEjsQukuSO25UpqLvCZTZW8+wmpO4D?=
 =?us-ascii?Q?pWC4rnuAKjS4oMn76uipataVsUkABQ8hjJuQpyW3oq747qiXtaCcuMT9i6rV?=
 =?us-ascii?Q?LENoWUggVDkTxmlfTAM6vUhMA0yWsFSaaeiPzLJrmqod72ujVZUcJodrVfH/?=
 =?us-ascii?Q?gnKMRPk/OIM3Wpkv0epB4vXlrBDK49teQpyfGmm1w41dBnWFeQTFvRR9RhOQ?=
 =?us-ascii?Q?XZQrKLu9XpvbGZGYtbMB5DwI1gNXadXx+HY6SZapce5cOtm65dRZl+y+ydH6?=
 =?us-ascii?Q?38zFUNFVeTXdZaboFX2o67xntCaEJv/DW9+jWquZuoVPGW6MH+j7Td0mJHnf?=
 =?us-ascii?Q?/ExLORGdVIOZgyrQEzRrk1YbxTwDniNc4uhAPl5TIF5HlBSxN3GkcQ0sqaIW?=
 =?us-ascii?Q?e381glCNzrN+Waznys9b+TplzEEYwymT4s1BI2JLGO8v5fTwS1lvtaaqgKKw?=
 =?us-ascii?Q?U6ZHK+ZTl7eWztD97AgLViH9OtSL3lFaAR0nFNoaawj+05hqy6CPPxfgNpeM?=
 =?us-ascii?Q?GpnVX/0uF/1ROOfsW184RzA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78502a94-8943-473a-3108-08d9ec1379f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 21:31:04.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+RQ3hpkj0sFaofDoUutqwt1yUJpKyifo8gbVlWf+4GNFajFsFoSBgliORoe6ecMi61AI/5U+a5qPeArZYVRRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3481
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
from switchdev aren't balanced. So the first 3 patches attempt to deal
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

Vladimir Oltean (5):
  net: bridge: vlan: br_vlan_add: notify switchdev only when changed
  net: bridge: vlan: nbp_vlan_add: notify switchdev only when changed
  net: bridge: vlan: notify a switchdev deletion when modifying flags of
    existing VLAN
  net: bridge: switchdev: replay VLANs present on the bridge device
    itself
  net: dsa: add explicit support for host bridge VLANs

 include/net/dsa.h         |  12 +++
 net/bridge/br_switchdev.c |   9 ++
 net/bridge/br_vlan.c      | 110 ++++++++++++++++++-----
 net/dsa/dsa2.c            |   2 +
 net/dsa/dsa_priv.h        |   7 ++
 net/dsa/port.c            |  42 +++++++++
 net/dsa/slave.c           |  97 +++++++++++++--------
 net/dsa/switch.c          | 179 ++++++++++++++++++++++++++++++++++++--
 8 files changed, 392 insertions(+), 66 deletions(-)

-- 
2.25.1

