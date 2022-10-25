Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9760C969
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbiJYKHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJYKG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:06:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2B518D812
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:00:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2+a5oVf/7DgQM99xoM+8d3vx4KoUuRmT0PxnP+Xpv4A/6WEhyq5RjOWziN7yEJJrxZsBIX5tmg6/3QBXViTDdTA8JhBYfINS+07VhfGYRM0yruOJ/XZOjVibTs3xIm2tQI6429kvSWQWdstTMV0HPatPqiwJRtPOEBHKoL9qi2eHF74gqvqfVLp4lXzwfYZuxSEpUpg+uBApnofVGWHwWjVWz4CiW/J3LItYZVzh23Ms39fSWWztJo3unfurZhhuIYCWK5dVhz/+p1jml/mZYee2CZ2MIAJe+ApltOaYEa5jkXulr5vxqnuEoLt7AHpjKj77D1Cnue7Tg5Re1OrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMsqm4DkU7H9QVImeZAVmQ+Ff0bNqKwHMI9/LrUdPR4=;
 b=ZMA6WS4xSpQ4OF6Lkjsbs1oBY9jV8GgGi/uIO+liJJfWBuRUAyAcxOiwRl897XVJOtvyFZbPOQC9kcFj3oemHZEPootstKnAAII2gGGOfp4OqYjqxXe6WmczTa0a9Z9NcsZEI59+CilUPd97aCzg0LiY4dXBn0jMuZStcJ9zEMBtiOywR/L+zgs5E9QSeVF2e1/iAxp5JFDS4MmVuFM/Wxch81OQFdh7pzFwUv9xai2DxfhjSIumBzrrocnT9xev9qnRzIdv5CgdLlHotGOh7WncKnYUFyc/ELfTyi2ebxOIZV9lBsjHP588Z8cTXEYlKwvUoqqK3uZSOW3K8heYNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMsqm4DkU7H9QVImeZAVmQ+Ff0bNqKwHMI9/LrUdPR4=;
 b=Iwf5SSWDW22ECk568HFofGKt/U/tO7FTlnllqMXDo+57LHmPrbDI7usH5AmcemVZYgKMUsJ30DR3LtMsmLcwlGqiNXhfHtsKzc1XQ1uXJTJ5dhTc7s+noZwuVug2EoEQqGrN3Oyp+Lo+Q9gy5tivD57CWxFSoLPh2dnoFcCKQVKRqk6xZHTpNjWsreSRm2EyRlsCoZJeUp+jE7z7AEIeGAVOPvYJ4VWilFUYQtN6oMNNWIsRqD2BkFKqOoSoOQ9lVskbDUMxW/sInFc2LCuupYLOAlXxLuIlZWsowkfaQcIVuvaM0HVu6EcpuAfiz/MqYQ+IRH0y8I7em/Ygk8yBEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:00:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:00:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 00/16] bridge: Add MAC Authentication Bypass (MAB) support with offload
Date:   Tue, 25 Oct 2022 13:00:08 +0300
Message-Id: <20221025100024.1287157-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0174.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ec277b-959a-457e-9fb3-08dab66fc982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PIlRcelhZivoh46V9N2oSNc/ikB1HyX9QKDi24Gb3zvoPk1zAZlIZ/Pq1NkNEc8AA75AkXyI9vKiXAB1IjyrvniNceEfNPbtj9duYKC48T0nJquU8W5yuTyhokVuyRGNRofh/+Vrw4Q/jr9ROlBrQZyX00wZmLgnW13HugnjWvXyHfGj2f+z3rrRoeyUeyVArdygoMYbphApsr9yR7mSWaq7HiG7fNig+KmI6BzDD/E6jueTfX+nyoLsO4KMUNgd138tpsHiYygOAMYKL0yUwuGBhB+eumKZetJzT167Fx1QYWaY39jdkMu2TUsPRSW1+q+Zi3IfCGVTA/FFxEopc0QXih2AhDd+8QZPkcTEsT24ksHAmqqil5HrpZ1r8jHEEA8rUmguvsNJtNX2HvnOsTMZDTkoUWOTUbIgV0ZHih97ervsMt665xr8ZUtlnzZE+4BgrURX6c5hZwxdDvqDRqqitcEuBWl8N08SQioUjatc3ZVSP/eFeYf8osuFec+i7KX+64QTYJ+yWyHcvezU3o9iAAWJe0aKRVuND3bXb/tig8MKVV0y2qtrHt/b44XVPc+mRJxNBzM1ZT3TMaHkOW/vrssY4gxXrFyXVtS83uAGj1Y5rMOsWGSwROWolGTlxd2XwfSnZrQZNPkgfi9KR66+rpGkHZ4CRGcc8mqcRWTQVl1gvNedHgKWcWzZlTMOTGPhgBtCIuWz1Z0WblDHJVP2toSY6nKCDdI3DUyzTj4m7SeQBaKg28Sr5F0zWW4uhtuG4wMgWmDNn8IaXrxAhg/HUQJCCwPFSczZlCRgAoy2eqyXuXoGDucsIdlC14Cr0pPjq3Gi5y9k8vkpsqwwNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(36756003)(38100700002)(2906002)(5660300002)(8936002)(7416002)(83380400001)(1076003)(107886003)(6666004)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(8676002)(66476007)(41300700001)(66946007)(66556008)(316002)(6486002)(966005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q9xJqME0zlRfJUK8YOb25M911vHFsEeUg4wBbaSOtKn5Qv3E3JdHSNNrl1u3?=
 =?us-ascii?Q?rmiE01z59PkjYpnW24SFrQmmvrenQ9q+9Vl5hH0RsgjXLy5y1UKGpVHq/XOb?=
 =?us-ascii?Q?jdBVVGy6qZ8CX7qhYmk37BRkST/YRPB28n33Ayq1Tj5dDEJtMJtwolFcvo/Z?=
 =?us-ascii?Q?zYHUz99zGU54FftMs9mmBrFDne8iYUY8P+XJa6SnKvi95kEyBlHYrNjgLWGn?=
 =?us-ascii?Q?ebZ91xldyHt9ICBeAWQ/bGouwtPMHl+TMb0Q0wqzqvzSi1iisckIoqcXKDde?=
 =?us-ascii?Q?60GCboQnWcUBNbv3WfmE5B8lciLrh5cbcriQXSeyQZsTTYwJq9zevrQiGBn3?=
 =?us-ascii?Q?OlIqhLubj+ngQHSgO5q29XC54m3ioWw5ey72oR51J7U7ugj08jew0K+nCDHH?=
 =?us-ascii?Q?gySsQMzxI91W7dG8O+tvcr1z7Ni5ifoOeg3WnaX1KVE6EStHAxsHIL2VwxGV?=
 =?us-ascii?Q?2Y0eRULJvWQJvDGQRmEzsMSHHTISm7zHaqMn205aNj+WmUQYxdOffzHcisYq?=
 =?us-ascii?Q?xS7qnsuAaN8vlUqXnAi0DHyqV9idi8b9zJIfcu6mKWPaqTsuuqX0/d+lhKYB?=
 =?us-ascii?Q?hlkz93Eb3GIohX9Jai3AbajL1AWFm3NRB8DG8SxkHg7YXKWC7YjT9kvHed1L?=
 =?us-ascii?Q?HJj/z0PSFk2zst7HGRHMLvmf9ieRGlF3L1Yf4IwiUfYiGpdwdEvbVqKCzVeI?=
 =?us-ascii?Q?wND0qE0+HT8bdbeqYcmrkgOOMLBF/oyxQ5YhSZWZoHI/FVMN+g0RjfRkEUt+?=
 =?us-ascii?Q?+/tGuloV/KS/2raBteYyiCRzKz9b48Uuc70zc9TNOpaG66jNQSLO76p5m/Lx?=
 =?us-ascii?Q?f6gmga0CzVrkCCBjXRcZBSaZVLmVpQ61JO65zUjKLoYZqs76nGy34RzWKrN1?=
 =?us-ascii?Q?9637fTkwKxQmW6H3NGfOaR1klfE/3deVJCN0za8ZANAqQfikhsGJsjXzXR8r?=
 =?us-ascii?Q?pNYcbUoTdPGnsfwqu6GE0OUMLwU0NtVeKQvAiRvA6KaqA3ElVNmSshsarw9a?=
 =?us-ascii?Q?bDen6p76WAheAV6+JWf6A0yR3aA+5x2pEHxV7swZmdmupaDXwMQrqSVVbffQ?=
 =?us-ascii?Q?gcuVI7qwmfokpuU0GM3vznTYx05S09ZjE1Q4udLT2S5JUtTVMy45z6lV1cya?=
 =?us-ascii?Q?BPZAaMk65D4/Tu8WB5Q9FZYO4nDN4IO3dVgCNcK044pTVjcrervcGqqkWzIu?=
 =?us-ascii?Q?xizIgnlkYFd3QWT9dTO93G/N792dUpwh8uAlqigGpYwFlYYJjQzowUJIyKLf?=
 =?us-ascii?Q?QbKBraDOWelrX54ojXPreUGnb60m7pdOceZmjaery4JyH39L7ByWbLXxtjP8?=
 =?us-ascii?Q?HYp88tGJDSMBpWIffv7qraMZO5lWY1AnDAcpPIVn6qqloOTGxJBrUceTZh/W?=
 =?us-ascii?Q?Jt7p11ClVjngp5C8fnmkNfEc8+rSc29GSNOUNMvFZfwtLRfHR3WV5Gf1Yp/n?=
 =?us-ascii?Q?JdEjEcOwaRNeS9GnjCN3fh+l0CxwatQ/y6LcMbNbH9BI9Eu/rRmLmbRGZuwK?=
 =?us-ascii?Q?xcnT22VfmUDnRz3B7pYKiFHp3LKAmCSwMKiX+klLViPwRAUZgFsqQlhuzU1H?=
 =?us-ascii?Q?Enhqr1pGLNv8AlKUhD3+VZrFhqAl+yD+f+3RlplS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ec277b-959a-457e-9fb3-08dab66fc982
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:00:46.6158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bPjkWMVVLUVUMo0YiJt3zJ+Extl3AH9UrSn9fM1DK5JyN5+rDwJzwIYyjTYLYpdItWjyha1v2ngLLsTg7EuTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is based on Hans' work from [1][2]. It adds MAB support in
the bridge driver and 802.1X (with MAB) offload support in mlxsw.

Patchset overview
=================

Patch #1 adds MAB support in the bridge driver. See the commit message
for motivation and design choices.

Patch #2 adds a selftest.

Patches #3-#4 extend the switchdev interfaces to allow device drivers to
install locked FDB entries in the bridge driver. Required for MAB
offload support.

The rest of the patches add 802.1X and MAB offload support in mlxsw.
Specifically:

Patches #5-#6 add the required packet traps for 802.1X.

Patches #7-#11 are small preparations.

Patch #12 adds locked bridge port support in mlxsw.

Patches #13-#16 add mlxsw selftests.

Future work
===========

The hostapd fork by Westermo is using dynamic FDB entries to authorize
hosts [3]. Changes are required in switchdev to allow such entries to be
offloaded. Hans already indicated he is working on that [4]. It should
not necessitate any uAPI changes so I do not view it as a blocker (Hans,
please confirm).

Merge plan
==========

We need to agree on a merge plan that allows us to start submitting
patches for inclusion and finally conclude this work. In my experience,
it is best to work in small batches. I therefore propose the following
plan:

* Add MAB support in the bridge driver. This corresponds to patches
  #1-#2.

* Switchdev extensions for MAB offload together with mlxsw
  support. This corresponds to patches #3-#16. I can reduce the number
  of patches by splitting out the selftests to a separate submission.

* mv88e6xxx support. I believe the blackhole stuff is an optimization,
  so I suggest getting initial MAB offload support without that. Support
  for blackhole entries together with offload can be added in a separate
  submission.

* Switchdev extensions for dynamic FDB entries together with mv88e6xxx
  support. I can follow up with mlxsw support afterwards.

[1] https://lore.kernel.org/netdev/20221018165619.134535-1-netdev@kapio-technology.com/
[2] https://lore.kernel.org/netdev/20221004152036.7848-1-netdev@kapio-technology.com/
[3] https://github.com/westermo/hostapd/blob/bridge_driver/hostapd/hostapd_auth_deauth.sh#L11
[4] https://lore.kernel.org/netdev/a11af0d07a79adbd2ac3d242b36dec7e@kapio-technology.com/

Hans J. Schultz (3):
  bridge: Add MAC Authentication Bypass (MAB) support
  selftests: forwarding: Add MAC Authentication Bypass (MAB) test cases
  bridge: switchdev: Allow device drivers to install locked FDB entries

Ido Schimmel (13):
  bridge: switchdev: Let device drivers determine FDB offload indication
  devlink: Add packet traps for 802.1X operation
  mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
  mlxsw: reg: Add Switch Port FDB Security Register
  mlxsw: spectrum: Add an API to configure security checks
  mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
  mlxsw: spectrum_switchdev: Add support for locked FDB notifications
  mlxsw: spectrum_switchdev: Use extack in bridge port flag validation
  mlxsw: spectrum_switchdev: Add locked bridge port support
  selftests: devlink_lib: Split out helper
  selftests: mlxsw: Add a test for EAPOL trap
  selftests: mlxsw: Add a test for locked port trap
  selftests: mlxsw: Add a test for invalid locked bridge port
    configurations

 .../networking/devlink/devlink-trap.rst       |  13 +++
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  35 ++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  22 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  64 +++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  25 +++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 include/linux/if_bridge.h                     |   1 +
 include/net/devlink.h                         |   9 ++
 include/net/switchdev.h                       |   1 +
 include/uapi/linux/if_link.h                  |   1 +
 include/uapi/linux/neighbour.h                |   8 +-
 net/bridge/br.c                               |   5 +-
 net/bridge/br_fdb.c                           |  46 +++++++-
 net/bridge/br_input.c                         |  15 ++-
 net/bridge/br_netlink.c                       |  13 ++-
 net/bridge/br_private.h                       |   5 +-
 net/bridge/br_switchdev.c                     |   1 +
 net/core/devlink.c                            |   3 +
 net/core/rtnetlink.c                          |   5 +
 .../drivers/net/mlxsw/devlink_trap_control.sh |  22 ++++
 .../net/mlxsw/devlink_trap_l2_drops.sh        | 105 ++++++++++++++++++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  |  31 ++++++
 .../net/forwarding/bridge_locked_port.sh      | 101 ++++++++++++++++-
 .../selftests/net/forwarding/devlink_lib.sh   |  19 ++--
 tools/testing/selftests/net/forwarding/lib.sh |   8 ++
 26 files changed, 535 insertions(+), 30 deletions(-)

-- 
2.37.3

