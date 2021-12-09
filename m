Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F161046E58A
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhLIJcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:06 -0500
Received: from mail-mw2nam12on2093.outbound.protection.outlook.com ([40.107.244.93]:1376
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236225AbhLIJcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+YdS6ry2BsHFUOrKEFBq2tnTRjYaSu5VBrABgIGTQXQk9gknfNo4VF6N7fWxKFSD7NZGX2W+xAu4sG52JkXrFACz/PoagSotmo60JyWCMNPRrfm1Js0/VAWZxzQqujbmPi38MoYWhhJ3ixbstvj5iJjugldE1VSa21Vut6UfHLbYhYNgQhOtkflgAbPRssh+GVEduNTmd/0HSgvxjBtl3kzUiwR0i7YwcY4gXfKHGk2RRr22bL4RF1OJr2ImCt7ARACvapIgeYY90vXMznGKnCad9ffGMHNEXG/DEe/v3j6lHNG/64mR/MsPUmciVtS5qwI5JpB0cbrNIkmvr3Fag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAp+mgbOPK8CgdVso16MTWQ9zDFodhYvRH0QJ5SbPRY=;
 b=cwq3UAv7WwBDCKioL3U+wnYnI+fOqXzOIo7PtgLfz96vf2McyadiY0e12+PbpGdv1PghbxgBQFCXXzKPTZvTYgkirqbeFxg3MUAoQdXKiRIkcpxYCE9RpUr7VEF1TCpRGw9Mgw4SDG9tv3RBD4/hi4fYttv6N3GYlXAR/Gbjq3oYwOdlhPB2OK05FeiD2qQ9e+7UoW3B87XW1iLIq9Gc9bOInc0EcxYF/iJqq7lDeoIO7LqrAGGUSGzdE2Ww5xmwwbhTG8147caUg9KF0FWH/oYcRMjf6xgcmaRSXXj7frBJD84GHPbkqktuCXj7MfZKJHfi3DEaXZrLMev9aCPwZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAp+mgbOPK8CgdVso16MTWQ9zDFodhYvRH0QJ5SbPRY=;
 b=c6Ex8wHfXx0EHSqxjYS6JaXscpea1JR0KKhnKSJdEnmLvV/Z+65mUVqOfIfOhzH7ROGC3TWImIZC68lAb0j2em9MtRrXLGkQzYXzowhsJ1OmM0ZAEw1Ji/4PWdszO0fasSDb2gXmFd1fByC17cF69CmOvrOBlq2z1xohxJb/k8g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4796.namprd13.prod.outlook.com (2603:10b6:510:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 00/12] allow user to offload tc action to net device
Date:   Thu,  9 Dec 2021 10:27:54 +0100
Message-Id: <20211209092806.12336-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf11329b-e344-473b-33c3-08d9baf6401a
X-MS-TrafficTypeDiagnostic: PH0PR13MB4796:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB47964E7C33C97D063B121077E8709@PH0PR13MB4796.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: poI7qUiMdwhtHReqBEjKf3Gra3WbRTfHi6TrUkCHYJ/Z7Hsd+LySzaANuqAcDhE33/rfnTYl1qMIDk9p71tZTcQPxtICgRvbX078T5SznMnz8ip98TGyrYJfNPLU+aPvNY/L8ZJQRHcojGAXDleZjpxXEaKfRIHdZXhZxsui8fCtzHOkeqMjW2bzqoigSRoa49QYIuau41jC5tlDejGg6+Ckm4I4u/3Bi1hvFofccq992MRVmVDnLHoJzlvem6rGUA7uZd1pzt1OQLJVth2Q/9hUrT3RdS+PYtEPodu+t7N9Y9yLjG35Q/iuzouuf/HMZEPzcFuSPbUV62fmHpJGN1xfM3hbhyfYxdR8JTQ213zmZRHHYfsR5NVlHC9iWYbWxupNFwnREYqlqy+H4BAOgX+QkItkDKbKoZ7EbeliimsxrATpc6Pk268TIIXpRjJBj1lfOR30AV0dH3bY/isjFuv5iCbg6yVBz8BdkOrc4tbarx9TqI66ks0afkUsIuI+N3gfm6llNEqvguuCUo+1TM/sg+zOvAIxmJrOFo7M89NdWPxXxSGbHT/J7zIiJ1la0+xvuSZwCEv1zmehP5gCSs6g+E9ZGShv8Ek5lLSnIO8iwB28z4RPLSx3Y4KZcw9Vkrl7+1Zv958eTcoVMmTzNtkla55+zhjffDYiJRba7eTaNJIfekUbMJ1GKL8LkC9l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39830400003)(346002)(376002)(366004)(6486002)(2616005)(6512007)(6506007)(8936002)(508600001)(44832011)(66556008)(38100700002)(1076003)(36756003)(107886003)(66476007)(6666004)(66946007)(6916009)(8676002)(2906002)(316002)(83380400001)(52116002)(4326008)(86362001)(5660300002)(186003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G3dXWz7EpL6eKE9d93NmX4eEANngoj7V0J43OGBoH40NSpx7CMxGqoarQKzw?=
 =?us-ascii?Q?siA7VsagacOAuypbIWlgvVSy36yi0LyUYPEf0y57NwLasOa0KMK7FNStNo8K?=
 =?us-ascii?Q?njX9OOsC/s0xRS8FmKp9TAa/kbTOcnlTTUkiz/OYmcV1oxESHTdkrl77bnyn?=
 =?us-ascii?Q?oqpTh94qoPY6il0UDAyYELiaHLMevCP+hb5M+3G0uhNRYFkPQYnsdIU/AdFq?=
 =?us-ascii?Q?u1JDlGfmNxPfRBibIxqkpVSdHK8MfmQu+QW/LrTMUISsTBZTFQjCGdDWE6Wn?=
 =?us-ascii?Q?kPW8OmGNCTATIb4Dkduy4VOYnRnfLhvbHf6IQFHIZx8fgEZJquUbpPfyHKt7?=
 =?us-ascii?Q?MW74cfp923PxfjrHpAnxQiwd+MTsbdDT3at5bLL8AW7NqMTPBDZ75Agj9lu+?=
 =?us-ascii?Q?O66+r4aOEAwLbtLuY5/jHchBgpcRsvtqdpdf4aMmrepjbRYwG3Y/ZJ3umxDp?=
 =?us-ascii?Q?s45kz+1BD8ZSX58W5Fsube+e/SoZj9mcXAn99XZjRYblZ24+ywDlRMnahmve?=
 =?us-ascii?Q?6/cZrIgSuUm7v+jfAoC5lfaEropXJFrTF+CK6MiTyU5NNunJ9rdP9JG8y/qW?=
 =?us-ascii?Q?7xBVPRz8e9BWL+9CRPpjtHngOAJDqa5K//w+ZRjqKIGIbsOpdHe4evDINrAh?=
 =?us-ascii?Q?fE8WpcvH+iqzeI58mMp2X/LBRCaCLF8q788wHtBM+Zmjx2RWBlyflRQXjtfr?=
 =?us-ascii?Q?vvQOfZokXwGsgTRS9SXxiNLve6G6XdVoLniKferv2pOvIpoh4JtCFkYttzXB?=
 =?us-ascii?Q?Ro4E6fLGF7N9s0oPwwbSNNsVGWDshKr9ypotNFiI8fsLPLFul3UXi+BAhUSt?=
 =?us-ascii?Q?e36jSgc61AH50FKJzvjtEDH4cEYv68ZfS1o/Q9GkUZQqpMyUSlQDnCqLPJYS?=
 =?us-ascii?Q?JyBdBqHB06aR7LdDb0KKhsfjzKS4wlCo42lF1zyQHNQnVdeS7/PtVaoWPUGw?=
 =?us-ascii?Q?WBJIhxW4PrAIakKZhZg/BQr0TA2otphu2Pb4xhsaMtvJQOqLo2KzsrhpSah1?=
 =?us-ascii?Q?GmBShjbsMUNQMgyEADSET1YRS7geRKLCvcu8jdkkKVgWn/UdS+VvP9uYxTvw?=
 =?us-ascii?Q?kcTsKVzT8ewYTIr54PHQfTGVv1QCINzUtn+EOtqpDHlVDi93IqN7Tc/j72p2?=
 =?us-ascii?Q?bT22KphF3iqqwtSx0XmjIWQktjImYDEUls+2QiTvKU24STk1metShK/x+zks?=
 =?us-ascii?Q?gZb5QOKTk6MooJKEQ8Bnsjs/Fyapb549BJdWDBTnGDdCuct5zpfHl4jYXVt8?=
 =?us-ascii?Q?3Fn43rLzWM0XU/AalgUOMpwy7keQvZ2m40Ca3hnbv2mbkE8QC/SEvbXmbyIW?=
 =?us-ascii?Q?LXrt34qztNo/zAqt7eWmXFb6I4iWSHEFUqDmdouNfyfn/PLhD0D3g0L8SSVr?=
 =?us-ascii?Q?Cac2d3rNxbnvbOjw2W30vif4+StXgYbFV1MgMa/Pwk3HwqEgU6PIzoRzV7kL?=
 =?us-ascii?Q?wdtwXYOSwD7g4TwfGXQeVQ+wnETEyAvgE56yDXC8wa3smxyA2L8aHN7KCt9y?=
 =?us-ascii?Q?OdeVYEs1jHK1uFGynqH4Ub9qHbY7A1cN2ecv3NczrS1yzwEmjgclB0QJxqVM?=
 =?us-ascii?Q?DWOb/sm7d7X8ZC0zQXD7d2F62HJBsDlpgSRmNrZxehas9KeqJ3RdBn1W7Heb?=
 =?us-ascii?Q?i8Y/p/zqEOSusccnTJvitK3wUjz6ldKZ7W3YyxwTIxpeqX/tof/Bv4KN8xIC?=
 =?us-ascii?Q?44gHjBcgSOGJWdUabTwOiH/NRhqwAECheSul+5Lw+v3s0I/ly+rzAuR+2j9R?=
 =?us-ascii?Q?lL6LHXtJeU2/zM81jRGhxjsSHac4+Q0=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf11329b-e344-473b-33c3-08d9baf6401a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:25.2982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBVGBNa2hLrT9duqKkJ3XVUxAmuGgqNtd+jYOFY/9X1Xu4qgmHaSiYhyVExL15MW0AQfcaE0/e1j0pWuiev+AjAqGW5FQGO7ZIFw/zxMdnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baowen Zheng says:

Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
tc actions independent of flows.

The motivation for this work is to prepare for using TC police action
instances to provide hardware offload of OVS metering feature - which calls
for policers that may be used by multiple flows and whose lifecycle is
independent of any flows that use them.

This patch includes basic changes to offload drivers to return EOPNOTSUPP
if this feature is used - it is not yet supported by any driver.

Tc cli command to offload and quote an action:

 # tc qdisc del dev $DEV ingress && sleep 1 || true
 # tc actions delete action police index 200 || true

 # tc qdisc add dev $DEV ingress
 # tc qdisc show dev $DEV ingress

 # tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
 # tc -s -d actions list action police
 total acts 1

         action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify 
         overhead 0b linklayer ethernet
         ref 1 bind 0  installed 142 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc filter add dev $DEV protocol ip parent ffff: \
         flower skip_sw ip_proto tcp action police index 200
 # tc -s -d filter show dev $DEV protocol ip parent ffff:
 filter pref 49152 flower chain 0
 filter pref 49152 flower chain 0 handle 0x1
   eth_type ipv4
   ip_proto tcp
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
         reclassify overhead 0b linklayer ethernet
         ref 2 bind 1  installed 300 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc filter add dev $DEV protocol ipv6 parent ffff: \
         flower skip_sw ip_proto tcp action police index 200
 # tc -s -d filter show dev $DEV protocol ipv6 parent ffff:
   filter pref 49151 flower chain 0
   filter pref 49151 flower chain 0 handle 0x1
   eth_type ipv6
   ip_proto tcp
   skip_sw
   in_hw in_hw_count 1
         action order 1:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action 
         reclassify overhead 0b linklayer ethernet
         ref 3 bind 2  installed 761 sec used 0 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0
         skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

 # tc -s -d actions list action police
 total acts 1

          action order 0:  police 0xc8 rate 100Mbit burst 10000Kb mtu 2Kb action reclassify overhead 0b linklayer ethernet
          ref 3 bind 2  installed 917 sec used 0 sec
          Action statistics:
          Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
          backlog 0b 0p requeues 0
          skip_sw in_hw in_hw_count 1
         used_hw_stats delayed

Changes compared to v5 patches:
* Fix issue reported by Dan Carpenter found using Smatch.

Baowen Zheng (12):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: add index to flow_action_entry structure
  flow_offload: return EOPNOTSUPP for the unsupported mpls action type
  flow_offload: add ops to tc_action_ops for flow action setup
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
  flow_offload: add process to update action stats from hardware
  net: sched: save full flags for tc action
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions
  selftests: tc-testing: add action offload selftest for action and
    filter

 drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
 drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  27 +-
 include/net/flow_offload.h                    |  20 +-
 include/net/pkt_cls.h                         |  27 +-
 include/net/tc_act/tc_gate.h                  |   5 -
 include/uapi/linux/pkt_cls.h                  |   9 +-
 net/core/flow_offload.c                       |  46 +-
 net/sched/act_api.c                           | 450 +++++++++++++++++-
 net/sched/act_bpf.c                           |   2 +-
 net/sched/act_connmark.c                      |   2 +-
 net/sched/act_csum.c                          |  19 +
 net/sched/act_ct.c                            |  21 +
 net/sched/act_ctinfo.c                        |   2 +-
 net/sched/act_gact.c                          |  38 ++
 net/sched/act_gate.c                          |  51 +-
 net/sched/act_ife.c                           |   2 +-
 net/sched/act_ipt.c                           |   2 +-
 net/sched/act_mirred.c                        |  50 ++
 net/sched/act_mpls.c                          |  54 ++-
 net/sched/act_nat.c                           |   2 +-
 net/sched/act_pedit.c                         |  36 +-
 net/sched/act_police.c                        |  27 +-
 net/sched/act_sample.c                        |  32 +-
 net/sched/act_simple.c                        |   2 +-
 net/sched/act_skbedit.c                       |  38 +-
 net/sched/act_skbmod.c                        |   2 +-
 net/sched/act_tunnel_key.c                    |  54 +++
 net/sched/act_vlan.c                          |  48 ++
 net/sched/cls_api.c                           | 263 ++--------
 net/sched/cls_flower.c                        |   9 +-
 net/sched/cls_matchall.c                      |   9 +-
 net/sched/cls_u32.c                           |  12 +-
 .../tc-testing/tc-tests/actions/police.json   |  24 +
 .../tc-testing/tc-tests/filters/matchall.json |  24 +
 42 files changed, 1144 insertions(+), 290 deletions(-)

-- 
2.20.1


Baowen Zheng (12):
  flow_offload: fill flags to action structure
  flow_offload: reject to offload tc actions in offload drivers
  flow_offload: add index to flow_action_entry structure
  flow_offload: return EOPNOTSUPP for the unsupported mpls action type
  flow_offload: add ops to tc_action_ops for flow action setup
  flow_offload: allow user to offload tc action to net device
  flow_offload: add skip_hw and skip_sw to control if offload the action
  flow_offload: add process to update action stats from hardware
  net: sched: save full flags for tc action
  flow_offload: add reoffload process to update hw_count
  flow_offload: validate flags of filter and actions
  selftests: tc-testing: add action offload selftest for action and
    filter

 drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
 drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |  27 +-
 include/net/flow_offload.h                    |  20 +-
 include/net/pkt_cls.h                         |  27 +-
 include/net/tc_act/tc_gate.h                  |   5 -
 include/uapi/linux/pkt_cls.h                  |   9 +-
 net/core/flow_offload.c                       |  46 +-
 net/sched/act_api.c                           | 451 +++++++++++++++++-
 net/sched/act_bpf.c                           |   2 +-
 net/sched/act_connmark.c                      |   2 +-
 net/sched/act_csum.c                          |  19 +
 net/sched/act_ct.c                            |  21 +
 net/sched/act_ctinfo.c                        |   2 +-
 net/sched/act_gact.c                          |  38 ++
 net/sched/act_gate.c                          |  51 +-
 net/sched/act_ife.c                           |   2 +-
 net/sched/act_ipt.c                           |   2 +-
 net/sched/act_mirred.c                        |  50 ++
 net/sched/act_mpls.c                          |  54 ++-
 net/sched/act_nat.c                           |   2 +-
 net/sched/act_pedit.c                         |  36 +-
 net/sched/act_police.c                        |  27 +-
 net/sched/act_sample.c                        |  32 +-
 net/sched/act_simple.c                        |   2 +-
 net/sched/act_skbedit.c                       |  38 +-
 net/sched/act_skbmod.c                        |   2 +-
 net/sched/act_tunnel_key.c                    |  54 +++
 net/sched/act_vlan.c                          |  48 ++
 net/sched/cls_api.c                           | 263 ++--------
 net/sched/cls_flower.c                        |   9 +-
 net/sched/cls_matchall.c                      |   9 +-
 net/sched/cls_u32.c                           |  12 +-
 .../tc-testing/tc-tests/actions/police.json   |  24 +
 .../tc-testing/tc-tests/filters/matchall.json |  24 +
 42 files changed, 1145 insertions(+), 290 deletions(-)

-- 
2.20.1

