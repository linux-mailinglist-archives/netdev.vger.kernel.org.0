Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D44369B597
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBQWgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBQWgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:36:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F344412BE0
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:36:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+qL7WCroBKq3NJ4pMnaTlEinEL0EKCDSGxtcBlpCIEFDB9Y1kfgGzGj0TTx8oFQYbe0elqYYOpP4kmnGk+jmwte4XdSiJCXOwfNiHl/UMhQmSVzoe66iKYEROfVM9/QTB3ZHzmc5Qu3LI1Gzrgz6WNZa2ojKbQdsLzyQ9o/lzz5dKJaWHJztn6S/ity+gUrbd6hbES2xRN4Bz/gQLMyF1YPDyTHbL2g/A+B0ma9c2QMnzXCIxyw7W0lCgcidvB6YJcuosrJtfwq7+YCrMKzncIAkMigAlJ88cnSiaESxt+N/O7cKOo/Otwu2cx+6coRqklpX3h2j6rtOcFty8qiZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QB7mgGbVi1trOTQ/UQcW2gLUduEhXpqrzjF4NjKCMBo=;
 b=AmshZ1qxEjcvQpIVwBZ71fnd+S5ottL9BZypwi3UGLJWtUQFCg6em633EHUOb7y06S+qDSBfkGhJlF1msc7mxRPuNRuc4AXLiQcyZrQBc/jRn7R/2cWy6sqe/ahg8TCLoNGN6ZxJb4HBq0g4hCvN4hC5XADT1tCP1MS3ooGivn7JMwR+IjNCTwjKgDtWgXcLNdPQJSZjQERounxeui5jrCNvcVRAYvayOoWa+H0lKPNYUH93tSLX6bGbZCMuL3MtKjKfGirHBki0n2cS7nqXSyq7bt5IN+7i7F8owfEZx3ZJgmbaPUrTfKsdBrKVpIgiWSuY9z3Xd5Ymac7caf8kcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QB7mgGbVi1trOTQ/UQcW2gLUduEhXpqrzjF4NjKCMBo=;
 b=RTR5D/RVX6hPsHirDEiNxyvQaPWGHFBCeQ13tBAN5hTxicGCDwa0tqPzGLanMHtF5fpLV6GCX9C7wyHfeLuedFK0XhL5t0r3UYE0VE1DDjlRDj/cFExGK5nzSpzEDrzYmRkpQhxMx5IliN98/W1iQOGoj+q4REYEoaNjMTrUrIWtq3lV7FnFBl1FV+XY6+g/QMBXUisRKMXP3zpfALM+8WyFIaJIpZ+Lzx6kYxPTJVTG/li6pxwE8vd7lDGPeb5lkaJwjst6bztSYDoHlDZGiI0Gnh7vf/I/JsxSghLrtkgkeEE3OlMFtPQ3Q6I2v2N7idYbXRf6MQvsdAF1wMzX0Q==
Received: from MN2PR07CA0020.namprd07.prod.outlook.com (2603:10b6:208:1a0::30)
 by CH2PR12MB4921.namprd12.prod.outlook.com (2603:10b6:610:62::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 22:36:42 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::4e) by MN2PR07CA0020.outlook.office365.com
 (2603:10b6:208:1a0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 22:36:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:36:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:28 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:27 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Fri, 17 Feb 2023 14:36:24 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v13 0/8] net/sched: cls_api: Support hardware miss to tc action
Date:   Sat, 18 Feb 2023 00:36:12 +0200
Message-ID: <20230217223620.28508-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|CH2PR12MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: ab6b23b3-acb0-4c21-9c3c-08db11377165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMvQqGzY0euAmEpwTz924ZDm6TZoRrWQP8waVCGBWWaAU5p8+a8YxWqZMtXw3cdPS8+EBgPz1qHab2TE2+1KHqbFQooPDPt+Xx9INxX2u85fvRcsm4c2F2xSdPmFRqaaFZr8l6Wj9Vo1ftmBZiyEaT51wzaAPLihMDoruQgVF0qYeLyKPWpxLLUm9FvdP2/wxy4NPpq+cYXhfwmm18EEolaojj5r8Wq8IL4jKQREMuwbMeC/yhgjt7is8i8/HoKsDo7QzRT/ddfWPJM7LKpsXJnGXMgdJcXB1k7G4W/0p5aczwsg6L0Etr7BRLdDI92HGToYI4SOwbHHsDMQI5ChoeRHpxGlTdmabN1voYzvr0qj7wewtBDYuI3geUsTuDf+H187FgwbXwx093p2wXlXYw1lmRRa0kaYWygA4/OQ0pAKnpE3FaXF45PMvVsLy8ElmU0SB+ZdpHaPUMy1DwZTlU9OmusMxZy7om1+6/9+3Onjhhstwigc7B3gAltFVvxTe1Dnu5mpK/3cGxRDYESBMTJDQHjOq0iW4DAzbWkE86PcVoGff6N3Koy1aflKNjiX95gGqkNFeGHslE5pk9PYI8/T/fRTI2ARYN2VXVJ2ocaYF6h2WyF3DGDfyxODTlCgXAR4+ubN3XxaWQQ8TC1QUUO96Zcf1AWEOlW8/2nfdA5SkacWWCAsu4IwsT2hu/mBkusvNqxs1pV3zjBEPG+sd8Bdz8NB6F1lB2FY+rg35/0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(36840700001)(40470700004)(46966006)(86362001)(2906002)(36860700001)(82740400003)(7636003)(110136005)(336012)(426003)(54906003)(186003)(478600001)(26005)(40480700001)(82310400005)(36756003)(47076005)(921005)(356005)(70586007)(83380400001)(8676002)(316002)(4326008)(40460700003)(70206006)(6666004)(41300700001)(107886003)(2616005)(5660300002)(8936002)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:36:42.4071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6b23b3-acb0-4c21-9c3c-08db11377165
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4921
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for hardware miss to instruct tc to continue execution
in a specific tc action instance on a filter's action list. The mlx5 driver patch
(besides the refactors) shows its usage instead of using just chain restore.

Currently a filter's action list must be executed all together or
not at all as driver are only able to tell tc to continue executing from a
specific tc chain, and not a specific filter/action.

This is troublesome with regards to action CT, where new connections should
be sent to software (via tc chain restore), and established connections can
be handled in hardware.

Checking for new connections is done when executing the ct action in hardware
(by checking the packet's tuple against known established tuples).
But if there is a packet modification (pedit) action before action CT and the
checked tuple is a new connection, hardware will need to revert the previous
packet modifications before sending it back to software so it can
re-match the same tc filter in software and re-execute its CT action.

The following is an example configuration of stateless nat
on mlx5 driver that isn't supported before this patchet:

 #Setup corrosponding mlx5 VFs in namespaces
 $ ip netns add ns0
 $ ip netns add ns1
 $ ip link set dev enp8s0f0v0 netns ns0
 $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
 $ ip link set dev enp8s0f0v1 netns ns1
 $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up

 #Setup tc arp and ct rules on mxl5 VF representors
 $ tc qdisc add dev enp8s0f0_0 ingress
 $ tc qdisc add dev enp8s0f0_1 ingress
 $ ifconfig enp8s0f0_0 up
 $ ifconfig enp8s0f0_1 up

 #Original side
 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
    ct_state -trk ip_proto tcp dst_port 8888 \
      action pedit ex munge tcp dport set 5001 pipe \
      action csum ip tcp pipe \
      action ct pipe \
      action goto chain 1
 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
    ct_state +trk+est \
      action mirred egress redirect dev enp8s0f0_1
 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
    ct_state +trk+new \
      action ct commit pipe \
      action mirred egress redirect dev enp8s0f0_1
 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
      action mirred egress redirect dev enp8s0f0_1

 #Reply side
 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
      action mirred egress redirect dev enp8s0f0_0
 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
    ct_state -trk ip_proto tcp \ 
      action ct pipe \
      action pedit ex munge tcp sport set 8888 pipe \
      action csum ip tcp pipe \
      action mirred egress redirect dev enp8s0f0_0

 #Run traffic
 $ ip netns exec ns1 iperf -s -p 5001&
 $ sleep 2 #wait for iperf to fully open
 $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888

 #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
 $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
        Sent hardware 9310116832 bytes 6149672 pkt
        Sent hardware 9310116832 bytes 6149672 pkt
        Sent hardware 9310116832 bytes 6149672 pkt

A new connection executing the first filter in hardware will first rewrite
the dst port to the new port, and then the ct action is executed,
because this is a new connection, hardware will need to be send this back
to software, on chain 0, to execute the first filter again in software.
The dst port needs to be reverted otherwise it won't re-match the old
dst port in the first filter. Because of that, currently mlx5 driver will
reject offloading the above action ct rule.

This series adds support for hardware partially executing a filter's action list,
and letting tc software continue processing in the specific action instance
where hardware left off (in the above case after the "action pedit ex munge tcp
dport... of the first rule") allowing support for scenarios such as the above.

Changelog:
	v1->v2:
	Fixed compilation without CONFIG_NET_CLS
	Cover letter re-write

	v2->v3:
	Unlock spin_lock on error in cls flower filter handle refactor
	Cover letter

	v3->v4:
	Silence warning by clang

	v4->v5:
	Cover letter example
	Removed ifdef as much as possible by using inline stubs

	v5->v6:
	Removed new inlines in cls_api.c (bot complained in patchwork)
	Added reviewed-by/ack - Thanks!

	v6->v7:
	Removed WARN_ON from pkt path (leon)
	Removed unnecessary return in void func

	v7->v8:
	Removed #if IS_ENABLED on skb ext adding Kconfig changes
	Complex variable init in seperate lines
	if,else if, else if ---> switch case

	v8->v9:
	Removed even more IS_ENABLED because of Kconfig

	v9->v10:
	cls_api: reading ext->chain moved to else instead (marcelo)

	v10->v11:
	Cover letter (marcelo)

	v11->v12:
	Added patch to rename current cookies, making room and less
	confusion with new miss_cookie.

	v12->v13:
	Kernel bot complaint fix
	Added Reviewed-By Marcelo Thanks!

Paul Blakey (8):
  net/sched: Rename user cookie and act cookie
  net/sched: cls_api: Support hardware miss to tc action
  net/sched: flower: Move filter handle initialization earlier
  net/sched: flower: Support hardware miss to tc action
  net/mlx5: Kconfig: Make tc offload depend on tc skb extension
  net/mlx5: Refactor tc miss handling to a single function
  net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
  net/mlx5e: TC, Set CT miss to the specific ct action instance

 .../net/ethernet/mellanox/mlx5/core/Kconfig   |   4 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++------------
 .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  39 +--
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 282 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  23 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
 include/linux/skbuff.h                        |   6 +-
 include/net/act_api.h                         |   2 +-
 include/net/flow_offload.h                    |   5 +-
 include/net/pkt_cls.h                         |  34 ++-
 include/net/sch_generic.h                     |   2 +
 net/openvswitch/flow.c                        |   3 +-
 net/sched/act_api.c                           |  28 +-
 net/sched/cls_api.c                           | 243 +++++++++++++--
 net/sched/cls_flower.c                        |  73 +++--
 20 files changed, 636 insertions(+), 359 deletions(-)

-- 
2.30.1

