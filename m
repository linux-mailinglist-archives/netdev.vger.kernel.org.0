Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A205730F29A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhBDLml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:42:41 -0500
Received: from mail-eopbgr60114.outbound.protection.outlook.com ([40.107.6.114]:12703
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235586AbhBDLmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:42:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnknTRm9TIZBh9fPMaMQI84azX6GOO363JMJK0jJMbOfxU/5/saySLkSrneNVYdCGmVogeIYcs05uMRoSfAySclLtthcaKDwWdkH9T900aJqQ/3PFUqf0eKuUTm3rH1ZMVwzz6bEm5H/jxLnn3dHR9IyQcx4FnhMfMwb8D+B6FlWSO5zzydYWmLfOEsyf7zQw4yogiJIxo3omFF0wy5ttZb7OEJkZOcRlfz75Rb9CpAj4wqEHBoyGEKn78fP793uGMdh0oFywBjLN9Z+S9w2xqcSaJJ3cI0HmL80F4KnEwfIikYdGpV+W9wpPd3O/CPdYdXJkZP39rwcQf9ihYbV2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yH1CLuTMGL7Sm77zfODlzH0uUujUj0/1ns8ZnOXHf8=;
 b=eWCJrguxjYNMLwIYlAEfbZvJ5zIpE78RZrqFf/TDK+lSa8W69Gk2OcwwGYYJyfQLZ/QXDVTq3jMuqJLBnrIRYLtBif4apYLfNppesfzV2eHJDlpUrD80y2juuiw17o2bEIp2Cf/cLL3JUE+bqNFP3l46aEvDFgV5l/QiMxJ/6SJ5KRP9CttgWS1en9pBmouf2pwqLweevzuZtCy57EWPZkyMzJG8Ow3cByIF7VjwF0tleT5+kcgneRhxDvOp5wGZGP/WyiEEhrVc+ZSxqbSVzUNFaPpZmQQyMwlCCR/HMuwpsqIunmGV771f8vw8ZdSU2wLwTKC4o+ZTkfHup3o/Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yH1CLuTMGL7Sm77zfODlzH0uUujUj0/1ns8ZnOXHf8=;
 b=Jevi9WYP9l81/G60Wd6onHfFnoT2Gt0jlAhXY9SkN9924AfYCt6X0XL5W0vXjw8//93j+kySPG/+OUHrpaamJ1Oww1y7emDRye8CtkDdEA72Ks+VlldJblG9MZ0aEDxP8X+GYz7xe/76HyqtpUTe6FvZ0euoLu3s8oa7BKKSRXA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM4P190MB0081.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Thu, 4 Feb
 2021 11:41:43 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3805.027; Thu, 4 Feb 2021
 11:41:43 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, idosch@idosch.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [RFC v5 net-next] net: core: devlink: add 'dropped' stats field for traps
Date:   Thu,  4 Feb 2021 13:41:22 +0200
Message-Id: <20210204114122.32644-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5P194CA0022.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::32) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM5P194CA0022.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 11:41:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9718b385-7db3-4b19-1963-08d8c901d845
X-MS-TrafficTypeDiagnostic: AM4P190MB0081:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4P190MB00817F62BB8FBF4D68D89C73E4B39@AM4P190MB0081.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Re+NbBP5WbF7rqBk8HC4/Kn5pjNEs9zWcfXWaaHLrj07wk9rbqI28g515LClzAxTlP1e5/BoaxKZBw1xJJ9hcfwWZ5FkPHG9sHQBl4ATZCoFTorvMedr4r3mUI2RRtHv01MO9byWf+XmM9OdPPUPGADXySIy3pUxcl1sow09mNtZa+S7ZUq8rxuni9qtGAmEwZZGIRXwSb4aSTCtfstnjF8M1Q4dqO799m4AIG5tN06cNAQlHVqPBNDDQ9Vsxdv3jilbNLPYq1U9ynmniLIaU6drNXu9C83CuZtkivJBR2K1X1QZea+cjwnA64ON+45X3/GSZ1A6dNhQnZ3RQuDJZvzDomNeqvDIoIkewPmub/fny15UIWX5zKELoo8sCJoN/NUK36HZHlzv+LuhJE+dkbCUNMAE11ZCQuni8D5Vj9blJ5V6aFMzea+Z3JjtVTUu7xdTOKZVUBhCFsZ8a2qCNe0HqpGMcwBo85jCC81ziFxLzSOpqsET+JHbd/SxZYCm6h+uABMyC4y0/of2SoWBvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(396003)(346002)(136003)(366004)(2906002)(956004)(8676002)(44832011)(2616005)(16526019)(6666004)(26005)(30864003)(52116002)(6506007)(1076003)(86362001)(36756003)(6512007)(478600001)(83380400001)(66946007)(8936002)(4326008)(316002)(6916009)(6486002)(66476007)(66556008)(186003)(107886003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Tog4aIC/Q6SIk5Ixof3/hFoCKsyLkt7ihi2GNsMcaI3cJJIQdxwjvuj/4Rey?=
 =?us-ascii?Q?vhvigpp1J3ywNU7dIHPrUhgU33pYJOxdWF5cbOO5mgmHcmk3ZDdagtAh9BHv?=
 =?us-ascii?Q?DFDsiskJDZ8kaQEf1Ew3uPTWavcTMmHfdgFkULXnoicZ2mC1KEQcRt3jDpsF?=
 =?us-ascii?Q?ITKoqQiriqSw8SA9zWNHa8pyodyaUpdkyfYP+gvU786LitlV/oVJCRG/ZAPn?=
 =?us-ascii?Q?1/SS8VZdMhdKlWJi2f/FGfuRc3ODsVxij6c9YRMUtZEe4lY89jiL/NEraxTX?=
 =?us-ascii?Q?nX0/ePSbxt2GCYDSGihIo1SkEUiTAcNnKjA3/cDnQoxX3FM4PZaS/oeftLnS?=
 =?us-ascii?Q?tkNYWCp1pcHEXsKyhHbdx6qXRkVP+y6gKFDltErUhjX/AszNwtU1g4l8JJHf?=
 =?us-ascii?Q?zfmRcy/h073hPI0zGuanqsuHaZOXK0G4bwq3hmxX/N1P3/j5HGhxhQLSA5oI?=
 =?us-ascii?Q?OW7zOdQFnQgxnS4PYXPqhjqUDsw/7ZKdnzxpXx+9RD82pzkU7/cB5dbmVJda?=
 =?us-ascii?Q?okP8Ac2TaNiCFHKtZBIqGN/JAmCELKRVybQidsdzeEOqHOXaFMgxaXITM8XV?=
 =?us-ascii?Q?Y2MPbFbVaA5khP8rm2Hqyzgkq38uUkVQ+Q9J4YjtWcwcItvplOv7GSrsVzcj?=
 =?us-ascii?Q?bSo8qhq2aI83+MIS2uMPUeYO+auLSUDqbWk6ec3lMW57W4Ci3fCSWCpxmMOQ?=
 =?us-ascii?Q?b5aUmpdjtvzN6LaftR5sCMH7iOjGoE02+5g5nBSmHFardh0m/T8kbSNtpALA?=
 =?us-ascii?Q?Se2M96zr75LbaP/pKkhCdL8po4QF711plWs9+Q+IaA8rlWYYoivE9GxQ9UBh?=
 =?us-ascii?Q?OkU3kaUlRO1N3U705WQ4FspaNYODZMHTC4ktGMhJ2Hr/hMhz+6JJCCAg50vk?=
 =?us-ascii?Q?NAk2vYPZGkd3zH1uE5YtaGdyFjNuLpYHY37Mti0sJO9RsPNGq8V7DmBzmiEM?=
 =?us-ascii?Q?MditfkdyTIkBfoED4eW3dBNUoVzHqaX54K/Q3PWEnMqZS9ELaKk1EPfC+MXv?=
 =?us-ascii?Q?w5tlC0Ssfa+ENgvPWBhXr/gX7AzYnCOG7AUEKvQo6Kz3pvdUngutVZoKkc/A?=
 =?us-ascii?Q?gP6l/F0qInKmW+YbSM2fjjDd0r50QeOHdRvr8LI2X1VDfcoNxUG+REx96QD+?=
 =?us-ascii?Q?d1zNLh4nuEnUCUMJNtb4DUpkeB0bmxFwOBBz6E+BRnb828swKYtALxf0iiUo?=
 =?us-ascii?Q?D17jmfJWGe8cLkEWTvHA53z/cF/9tW69cTjop+DDS/pYuk1ZF4BrpJ/JHibm?=
 =?us-ascii?Q?mDAD2GOl6cT4Ri3csvFWuQhLgZv/JorJAiuiGvlRLHoPE+0EKb09+eooiFpq?=
 =?us-ascii?Q?uZb0AQjiHR1gR/53WmcmVFcR?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9718b385-7db3-4b19-1963-08d8c901d845
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:41:43.5205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QE/shpawzWIQ77vzDQpHMM75UHxg0XS9qs+GUpaK4ZRuTpPaXz0TZuH9X6bwDsF6ms3E1itZ8eyyuxGKnMO4mO+dLfHB865BeavnbHEXYfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever query statistics is issued for trap, devlink subsystem
would also fill-in statistics 'dropped' field. This field indicates
the number of packets HW dropped and failed to report to the device driver,
and thus - to the devlink subsystem itself.
In case if device driver didn't register callback for hard drop
statistics querying, 'dropped' field will be omitted and not filled.
Add trap_drop_counter_get callback implementation to the netdevsim.
Add new test cases for netdevsim, to test both the callback
functionality, as well as drop statistics alteration check.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V5:
    1) Add missed static specifier for function in netdevsim/dev.c
V4:
    1) Change commit description / subject.
    2) Change 'dropped' statistics fill condition from
       'trap_drop_counter_get is registered' && 'trap action == drop'
       to
       'trap_drop_counter_get is registered'.
    3) Fix statistics fill condition used for wrong stats attribute:
       DEVLINK_ATTR_STATS_RX_PACKETS -> DEVLINK_ATTR_STATS_RX_DROPPED
V3:
    1) Mark subject as RFC instead of PATCH.
V2:
    1) Change commit description / subject.
    2) Remove HARD_DROP action.
    3) Remove devlink UAPI changes.
    4) Rename hard statistics get callback to be 'trap_drop_counter_get'
    5) Make callback get called for existing trap action - DROP:
       whenever statistics for trap with DROP action is queried,
       devlink subsystem would call-in callback to get stats from HW;
    6) Add changes to the netdevsim support implemented changes
       (as well as changes to make it possible to test netdevsim with
        these changes).
    7) Add new test cases to the netdevsim's kselftests to test new
       changes provided with this patchset;

Test-results:
# selftests: drivers/net/netdevsim: devlink_trap.sh
# TEST: Initialization                                                [ OK ]
# TEST: Trap action                                                   [ OK ]
# TEST: Trap metadata                                                 [ OK ]
# TEST: Non-existing trap                                             [ OK ]
# TEST: Non-existing trap action                                      [ OK ]
# TEST: Trap statistics                                               [ OK ]
# TEST: Trap group action                                             [ OK ]
# TEST: Non-existing trap group                                       [ OK ]
# TEST: Trap group statistics                                         [ OK ]
# TEST: Trap policer                                                  [ OK ]
# TEST: Trap policer binding                                          [ OK ]
# TEST: Port delete                                                   [ OK ]
# TEST: Device delete                                                 [ OK ]
ok 1 selftests: drivers/net/netdevsim: devlink_trap.sh
---
 drivers/net/netdevsim/dev.c                   | 22 ++++++++
 drivers/net/netdevsim/netdevsim.h             |  1 +
 include/net/devlink.h                         | 10 ++++
 net/core/devlink.c                            | 53 +++++++++++++++++--
 .../drivers/net/netdevsim/devlink_trap.sh     | 10 ++++
 .../selftests/net/forwarding/devlink_lib.sh   | 26 +++++++++
 6 files changed, 118 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 816af1f55e2c..d83a53bd0930 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -231,6 +231,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	debugfs_create_bool("fail_trap_counter_get", 0600,
+			    nsim_dev->ddir,
+			    &nsim_dev->fail_trap_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
@@ -416,6 +419,7 @@ struct nsim_trap_data {
 	struct delayed_work trap_report_dw;
 	struct nsim_trap_item *trap_items_arr;
 	u64 *trap_policers_cnt_arr;
+	u64 trap_pkt_cnt;
 	struct nsim_dev *nsim_dev;
 	spinlock_t trap_lock;	/* Protects trap_items_arr */
 };
@@ -892,6 +896,23 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 	return 0;
 }
 
+static int
+nsim_dev_devlink_trap_hw_counter_get(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	u64 *cnt;
+
+	if (nsim_dev->fail_trap_counter_get)
+		return -EINVAL;
+
+	cnt = &nsim_dev->trap_data->trap_pkt_cnt;
+	*p_drops = (*cnt)++;
+
+	return 0;
+}
+
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
 					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
@@ -905,6 +926,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.trap_group_set = nsim_dev_devlink_trap_group_set,
 	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
 	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
+	.trap_drop_counter_get = nsim_dev_devlink_trap_hw_counter_get,
 };
 
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 48163c5f2ec9..f9aa8429549a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -219,6 +219,7 @@ struct nsim_dev {
 	bool fail_trap_group_set;
 	bool fail_trap_policer_set;
 	bool fail_trap_policer_counter_get;
+	bool fail_trap_counter_get;
 	struct {
 		struct udp_tunnel_nic_shared utn_shared;
 		u32 __ports[2][NSIM_UDP_TUNNEL_N_PORTS];
diff --git a/include/net/devlink.h b/include/net/devlink.h
index f466819cc477..0b9ed24533c5 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1294,6 +1294,16 @@ struct devlink_ops {
 				     const struct devlink_trap_group *group,
 				     enum devlink_trap_action action,
 				     struct netlink_ext_ack *extack);
+	/**
+	 * @trap_drop_counter_get: Trap drop counter get function.
+	 *
+	 * Should be used by device drivers to report number of packets
+	 * that have been dropped, and cannot be passed to the devlink
+	 * subsystem by the underlying device.
+	 */
+	int (*trap_drop_counter_get)(struct devlink *devlink,
+				     const struct devlink_trap *trap,
+				     u64 *p_drops);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..f59c49c070c8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6791,8 +6791,9 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 	}
 }
 
-static int devlink_trap_stats_put(struct sk_buff *msg,
-				  struct devlink_stats __percpu *trap_stats)
+static int
+devlink_trap_group_stats_put(struct sk_buff *msg,
+			     struct devlink_stats __percpu *trap_stats)
 {
 	struct devlink_stats stats;
 	struct nlattr *attr;
@@ -6820,6 +6821,50 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
+				  const struct devlink_trap_item *trap_item)
+{
+	struct devlink_stats stats;
+	struct nlattr *attr;
+	u64 drops = 0;
+	int err;
+
+	if (devlink->ops->trap_drop_counter_get) {
+		err = devlink->ops->trap_drop_counter_get(devlink,
+							  trap_item->trap,
+							  &drops);
+		if (err)
+			return err;
+	}
+
+	devlink_trap_stats_read(trap_item->stats, &stats);
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
+	if (!attr)
+		return -EMSGSIZE;
+
+	if (devlink->ops->trap_drop_counter_get &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
+			      DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
+			      stats.rx_packets, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
+			      stats.rx_bytes, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, attr);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 				const struct devlink_trap_item *trap_item,
 				enum devlink_command cmd, u32 portid, u32 seq,
@@ -6857,7 +6902,7 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, trap_item->stats);
+	err = devlink_trap_stats_put(msg, devlink, trap_item);
 	if (err)
 		goto nla_put_failure;
 
@@ -7074,7 +7119,7 @@ devlink_nl_trap_group_fill(struct sk_buff *msg, struct devlink *devlink,
 			group_item->policer_item->policer->id))
 		goto nla_put_failure;
 
-	err = devlink_trap_stats_put(msg, group_item->stats);
+	err = devlink_trap_group_stats_put(msg, group_item->stats);
 	if (err)
 		goto nla_put_failure;
 
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index da49ad2761b5..ff4f3617e0c5 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -163,6 +163,16 @@ trap_stats_test()
 			devlink_trap_action_set $trap_name "drop"
 			devlink_trap_stats_idle_test $trap_name
 			check_err $? "Stats of trap $trap_name not idle when action is drop"
+
+			echo "y"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_fail $? "Managed to read trap (hard dropped) statistics when should not"
+			echo "n"> $DEBUGFS_DIR/fail_trap_drop_counter_get
+			devlink -s trap show $DEVLINK_DEV trap $trap_name &> /dev/null
+			check_err $? "Did not manage to read trap (hard dropped) statistics when should"
+
+			devlink_trap_drop_stats_idle_test $trap_name
+			check_fail $? "Drop stats of trap $trap_name idle when should not"
 		else
 			devlink_trap_stats_idle_test $trap_name
 			check_fail $? "Stats of non-drop trap $trap_name idle when should not"
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 9c12c4fd3afc..2094ba025af5 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -318,6 +318,14 @@ devlink_trap_rx_bytes_get()
 		| jq '.[][][]["stats"]["rx"]["bytes"]'
 }
 
+devlink_trap_drop_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["dropped"]'
+}
+
 devlink_trap_stats_idle_test()
 {
 	local trap_name=$1; shift
@@ -339,6 +347,24 @@ devlink_trap_stats_idle_test()
 	fi
 }
 
+devlink_trap_drop_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+
+	t0_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_drop_packets_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
 devlink_traps_enable_all()
 {
 	local trap_name
-- 
2.17.1

