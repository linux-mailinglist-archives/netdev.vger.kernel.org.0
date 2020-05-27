Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF81E49BF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgE0QWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:02 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:4705
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727804AbgE0QWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ngoJ/Z7DDk0+gAfK8zdOZoXskQFgWuw78gHtEHFd30fW87ulOkhwjpRDr8OKL5z4i5XlvAt8Di8w8xTxzsssL2twzp+Xg3pxnJrdOWsbYqd6JDbu5on9FgTtx7nR6K+ha29+Ny6Ipd6tE4ttp30eQHh2WHRwjlux5LVEkwNxZJUMoMMOvPY484f1EKRgzugKJSqBctmzRK3cCXE5diubETaSq1CKA1BG41P4oAxmsdLgUlZ9ALMf42lHYUsJC3bgFG5IcZnRp0BaOvmsH1PR7vJWzNAP46VPy+B6r1UbBNlMFw6zG77Ym9oOWVKlEfbTyiQ0yiVoCUm7V5bGNwi6ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEzkElI38WSd3jjWWFUX3QQtF2UiBzVXI0Tkp0nh6uA=;
 b=J7CSsZ/MFHANcjMAhxdspbkpOStMI+geTBd3bi6VMZZrVeDknPtkrqx5w1Ye5PWiaFYcbj31a6qLRioVYaMbaQNG/R0EV0S2zGlHUSFwmPM4LUGDfZgf9ILQC7w0D2cZvK8qiQ8zXinTQ2Z+6G/w6tBBlJlXf5n+fe+ay5+Xumx62Q8YCd36sgQ7MPYQBrd7SoHBUOvshHdrBDHCkOrir8etu+lx9CzOhy5OJDLgYXDAGqCt61pENQeOnsgrrqqN8DEt9uajw9gMMZkFhvPaxNJcdCkLq56DlzK7LTWjW7BZVQRWkyKh6AVen9fKdWKweapkTsI7mBV56DuGRYW1HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEzkElI38WSd3jjWWFUX3QQtF2UiBzVXI0Tkp0nh6uA=;
 b=b5KfYj3TGrPMgvzMcWq25NViAITErZvEEeKF0hL40T07yUj3UsawLKTWV21zyKTkvbB1TgIkbAi6YSxjtMpIgNCRJO2D0S46nr1JqT+OHa17R1uV6vrDFV5hQXwHPnolyIKIWDsvZt79wg3P1dvYV+2VpqJTjxAyX+kTJFNsAL8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:21:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:21:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 00/15] mlx5 updates 2020-05-26
Date:   Wed, 27 May 2020 09:21:24 -0700
Message-Id: <20200527162139.333643-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:21:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c294b88f-3d1c-4fb9-3d00-08d8025a1353
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70398014D61EC531FD0922F6BEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5FRMEEnIWiPgHzQcbdxKfNVhDzlvnQJiebI/WN8L8flibSqhHeGJn4z0CsKOtYuXG+aRCEDh/42ZpJj91viwHNPNsC196e3jDA3jqYH30+kJtmsHllJpFecsJiUKZkM22gmlTbupXsrC3eZz3NEwE2M5eXHgFFp2Hr8ThtLJ40As5zwT39iM6EhVPTh/vcVRYyI+mEC1s2nckBs9z6X4pfMXlfNBjxZ4CSB+mm8bSWaP3nBgK+OkdhyRDHYXyUJcUAI2JQDteW/damzHus0/H+wDyBU4vIfRY4rGde265oJLQBDJw8CtOysqB46pgAlMNPfKiHrI/RmpvG9SflZikw5uqx/1cTsc2LvF5q+y3X2omCleBkdZ7uSNCC7Ric+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(478600001)(107886003)(6512007)(86362001)(83380400001)(15650500001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wgl4f2c/fFh6YIAcarvX1728xv/9Ib1EkDn6WLrzJJyw1Wikm/Z7WJt4/1reV/lDTFPZCiU20vETvO3ON60R8SquNW33xNDj723gaosh3hv4OdhOyi3NMisU/iWCyQoMtk+K1oZnNeMizv22Eeae6FpXoRNWJxkCu6/kmZglTStcyX0IiNiY3HHCa44Gp8bRC6347tP2MvIWI1SdlLYvhJaMTLEAV3hloPfaD85L4awuXJikg24fCgWZYNQTgu9DfAg7Zeert1JYstsLAOB29I0WL4qQbpesm/WM8CUI4z63MCFXy41b68quFxaHIQSjG9mn3o1FtmgFtgPLUd754BNZpQ+vuO/cJLI+0xFpnWlsw1ZPs65YpUcDvIX9iEOUVPZOpp8ngtbjBp1q+YMXJ3QNfR3qls123z9nS2ZPrm45SG8Q+xiyLWVURkwkWd4BzdB1JrfN2++oDQTzPfqsWVzJJGX1jBwGo8O9syUzeKs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c294b88f-3d1c-4fb9-3d00-08d8025a1353
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:21:56.9638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UPjA8kmNrIQ7D8eEeY9lDHaXt5ODAegagBzEOfU0eLoKkZY63DkkOYkDv/lKsuPnRQFsEosVWuvTP/VpgJgsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
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

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
---
The following changes since commit dc0f3ed1973f101508957b59e529e03da1349e09:

  net: phy: at803x: add cable diagnostics support for ATH9331 and ATH8032 (2020-05-26 23:26:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-26

for you to fetch changes up to 6c3be8409faf3c952aa6fd2ef7234a9a025500d0:

  net/mlx5: DR, Split RX and TX lock for parallel insertion (2020-05-27 09:16:57 -0700)

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
