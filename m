Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9321E52C5
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgE1BRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:17:30 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:34369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgE1BR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:17:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDAL9IvidlKwhVpJ9dhBwdBA22jZGSGn8Wn1IVdL0AePl5bgmvvYS3aMFP4MVxSr/1ghQdhKptYGPZpdQ6osD45B5EvWipY3SasDtI7eGzpOoyang2N4cSqZtnjKlxpsHl78B8rC8Pse1UXgKQTTjeCMDpjnPG/+vqS7MzagidSB+Ue3UjcWgFCzauJkC/ccFQuyAz5E7OIKs7mIKeJ0970fR8nv6UE6lZNviztLIzAjN2jL48A7+NmKCtoCnxCfOalaosZm5/RS7KO+Qrd5GRj5nY5ETfLqMUJNed68EwKPJOu+HC5FbYx7lWxF7qk63EpIeZlHKRzzHkYrm/3LLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OekeyJ09M3g1nfoTt4YR+blpotuERhiivWPZTfS7Pts=;
 b=bEFKfXfsX+bLErn+MfrDQ8CnRhCJcRdo1hMVxI1rk1v9uZ1fH0q+LvxMaW/TTKPP1aWUrKw+Fw06u24naTLC9OVFqVWkFdlpx9tmzuKegQnlSkqKBs304t7oKLg/68WpKybzpoXK972swpD2bFoxLZGfCMHAwO5IVwodPFMIIdWiKcHmiixcsNdJdBUIOwojHclZg8F3jpDLUkZg3Lw/SNTYc1B/rMFOIUKlfhd/KeMceQmfWbKBQzWvNXxY8CLE9DzRvRIDc7SmdwAEMbuWnqU1xL7C6/nFg3c5jRdZ7Udkt3dN9E2ZE7LxqkGguLoQM4Prk2c+OKRlJllhrVKFSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OekeyJ09M3g1nfoTt4YR+blpotuERhiivWPZTfS7Pts=;
 b=Hv5rgxpn4qwjtGFIyjBFKYaiIY38LnPdNEClx7I4LCzRRBkAdQ1vVHPgmBMTl4Jck7BBRvVRsCBv7Am8uBtNgkiFltGD5IaHpmNnQAyc/I0S8/Imfx119OZk35S6LUShCM1CZtMUhx9ZBGIsdVlzl4aT2CCFvTOb447HVNx4KA0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V3 00/15] mlx5 updates 2020-05-26
Date:   Wed, 27 May 2020 18:16:41 -0700
Message-Id: <20200528011656.559914-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:23 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01833a2d-f97a-4a7a-83c5-08d802a4e12d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43688CD3D9B4A16F38D56F47BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7BtQTG7VsCIlH759TlKq+ctxDzLr5JFFQQ2iJSI4UryilyNW6WRyJK7g5tM0Skz5ULdVeWcsknKzJ1pu8XwxpxZVrvvcb/4jXKwVxkqkuVMJhf5aAFszOj5LVasciNwg0AOtq2WMbUdwtwiKdde/fzg3wAHqhm6F9lsqJ7iXJdyDmGSe/myXWHDaxSBHZ1280feI1YlKi3HwZZVH9hvOvEPZpC3aQrrC49KJakjmtVosQsNupq9Hh3pqfmUriJFR0mZ6kVr0SePXsobuGMe7FaL0vCzo6ei+P6lPVE0tk0zJZqKSoEAN3vvidVFyw7YCb+FHxaNJCtp19T60yXGzX3KlKvnsfInzqGHecvhQ9PEZNAKmbQqAzFU4Wnq2OY8v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(15650500001)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ab1a+kVQKNJ4XoFhdMXKlhnkTmvzJ0g1PRrRSX4K7ZLUIfsiXVWHg+J8yJq7+8tfts4IgAl+DqfgKDdlJpwsyVzWe6sgPMbk2dAmjBUnkdAYFmaioSrIDWFbGt3ynyozqawNMpRLhHuM2xh/9OgXzLrXnY1m7W/BZwnH95gvYgrJaPd7XFqQfNBvUV306iqTzb/ygEYFhK2yQCODPYAGYrHkFC57umgt6EuUpA9LQ4w+tfu2xeme2U06Uc99W6IORdiwbS33THdG0cQ5kvfFfmrWbtH4K2IdFH004wuK9gcVSZCXnLNNdjwuw4IOhcqierLnbvxlphMi42xMKgU7oi9oCNutYObptvwY31iPo47GDwsAVpHcVCMQ85RqkOuXBL5kQICxu7M8ooSQGavoqkJkMLp9SmIjGQvhv6fqdjnqQIqLj86+eBfGNmZXwoYUSlnzzwdOosC3l7Noq1pmjxUHI40LFNIY7D+S6mOnsUo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01833a2d-f97a-4a7a-83c5-08d802a4e12d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:25.1262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qVDe2Ebv924yIcqvz2mxMbnhOidTHOYEwAQ/WIqft6naEPGNv8Dbibltq6WBalS+1L4EtX4mo+sBNPFKbzot5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub.

This series adds support for mlx5 switchdev VM failover using FW bonded
representor vport and probed VF interface via eswitch vport ACLs.
Plus some extra misc updates.

v1->v2:
  - Dropped the suspend/resume support patch, will re-submit it to net and
    -stable as requested by Dexuan.
v2->v3:
  - Fix build warnings reported by Jakub.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit dc0f3ed1973f101508957b59e529e03da1349e09:

  net: phy: at803x: add cable diagnostics support for ATH9331 and ATH8032 (2020-05-26 23:26:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-26

for you to fetch changes up to ed03a418abe8e5a3ba541a805314bbf8a9eadda3:

  net/mlx5: DR, Split RX and TX lock for parallel insertion (2020-05-27 18:13:52 -0700)

----------------------------------------------------------------
mlx5-updates-2020-05-26

Updates highlights:

1) From Vu Pham (8): Support VM traffics failover with bonded VF
representors and e-switch egress/ingress ACLs

This series introduce the support for Virtual Machine running I/O
traffic over direct/fast VF path and failing over to slower
paravirtualized path using the following features:

     __________________________________
    |  VM      _________________        |
    |          |FAILOVER device |       |
    |          |________________|       |
    |                  |                |
    |              ____|_____           |
    |              |         |          |
    |       ______ |___  ____|_______   |
    |       |  VF PT  |  |VIRTIO-NET |  |
    |       | device  |  | device    |  |
    |       |_________|  |___________|  |
    |___________|______________|________|
                |              |
                | HYPERVISOR   |
                |          ____|______
                |         |  macvtap  |
                |         |virtio BE  |
                |         |___________|
                |               |
                |           ____|_____
                |           |host VF  |
                |           |_________|
                |               |
           _____|______    _____|_____
           |  PT VF    |  |  host VF  |
           |representor|  |representor|
           |___________|  |___________|
                \               /
                 \             /
                  \           /
                   \         /                     _________________
                    \_______/                     |                |
                 _______|________                 |    V-SWITCH    |
                |VF representors |________________|      (OVS)     |
                |      bond      |                |________________|
                |________________|                        |
                                                  ________|________
                                                 |    Uplink       |
                                                 |  representor    |
                                                 |_________________|

Summary:
--------
Problem statement:
------------------
Currently in above topology, when netfailover device is configured using
VFs and eswitch VF representors, and when traffic fails over to stand-by
VF which is exposed using macvtap device to guest VM, eswitch fails to
switch the traffic to the stand-by VF representor. This occurs because
there is no knowledge at eswitch level of the stand-by representor
device.

Solution:
---------
Using standard bonding driver, a bond netdevice is created over VF
representor device which is used for offloading tc rules.
Two VF representors are bonded together, one for the passthrough VF
device and another one for the stand-by VF device.
With this solution, mlx5 driver listens to the failover events
occuring at the bond device level to failover traffic to either of
the active VF representor of the bond.

a. VM with netfailover device of VF pass-thru (PT) device and virtio-net
   paravirtualized device with same MAC-address to handle failover
   traffics at VM level.

b. Host bond is active-standby mode, with the lower devices being the VM
   VF PT representor, and the representor of the 2nd VF to handle
   failover traffics at Hypervisor/V-Switch OVS level.
   - During the steady state (fast datapath): set the bond active
     device to be the VM PT VF representor.
   - During failover: apply bond failover to the second VF representor
     device which connects to the VM non-accelerated path.

c. E-Switch ingress/egress ACL tables to support failover traffics at
   E-Switch level
   I. E-Switch egress ACL with forward-to-vport rule:
     - By default, eswitch vport egress acl forward packets to its
       counterpart NIC vport.
     - During port failover, the egress acl forward-to-vport rule will
       be added to e-switch vport of passive/in-active slave VF
representor
       to forward packets to other e-switch vport ie. the active slave
       representor's e-switch vport to handle egress "failover"
traffics.
     - Using lower change netdev event to detect a representor is a
       lower
       dev (slave) of bond and becomes active, adding egress acl
       forward-to-vport rule of all other slave netdevs to forward to
this
       representor's vport.
     - Using upper change netdev event to detect a representor unslaving
       from bond device to delete its vport's egress acl forward-to-vport
       rule.

   II. E-Switch ingress ACL metadata reg_c for match
     - Bonded representors' vorts sharing tc block have the same
       root ingress acl table and a unique metadata for match.
     - Traffics from both representors's vports will be tagged with same
       unique metadata reg_c.
     - Using upper change netdev event to detect a representor
       enslaving/unslaving from bond device to setup shared root ingress
       acl and unique metadata.

2) From Alex Vesker (2): Slpit RX and TX lock for parallel rule insertion in
software steering

3) Eli Britstein (2): Optimize performance for IPv4/IPv6 ethertype use the HW
ip_version register rather than parsing eth frames for ethertype.

----------------------------------------------------------------
Alex Vesker (2):
      net/mlx5: DR, Add a spinlock to protect the send ring
      net/mlx5: DR, Split RX and TX lock for parallel insertion

Eli Britstein (2):
      net/mlx5e: Helper function to set ethertype
      net/mlx5e: Optimize performance for IPv4/IPv6 ethertype

Or Gerlitz (2):
      net/mlx5e: Use netdev events to set/del egress acl forward-to-vport rule
      net/mlx5e: Offload flow rules to active lower representor

Parav Pandit (1):
      net/mlx5: Add missing mutex destroy

Vu Pham (8):
      net/mlx5: E-Switch, Refactor eswitch egress acl codes
      net/mlx5: E-Switch, Refactor eswitch ingress acl codes
      net/mlx5: E-Switch, Introduce APIs to enable egress acl forward-to-vport rule
      net/mlx5e: Support tc block sharing for representors
      net/mlx5e: Add bond_metadata and its slave entries
      net/mlx5: E-Switch, Alloc and free unique metadata for match
      net/mlx5e: Slave representors sharing unique metadata for match
      net/mlx5e: Use change upper event to setup representors' bond_metadata

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   7 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |  85 ++--
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  | 350 +++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  30 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  13 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  96 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   4 +
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       | 170 +++++++
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       | 235 +++++++++
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   | 160 ++++++
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.h   |  26 +
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      | 279 ++++++++++
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      | 322 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h |  17 +
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h |  29 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 559 +--------------------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  41 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 401 +++------------
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  16 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  14 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  10 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  31 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  13 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |  12 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  25 +-
 27 files changed, 1965 insertions(+), 1011 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
