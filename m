Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D2A6969DD
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbjBNQiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjBNQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:36 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DF92B2A4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N36FcCprjzCsxJwV8r9RbKLzrSE/SerujF3mZZpKkHGlIH5DIBOdeqAeHfHkOhVfhHl1w357GG5NtA2imPAhgl6sbr42lj7CC80mhifu+7y2qrSQ7znOFQq50IMl4lb6Fibizmp201qy2tLhRXeiONIFUJJs+1Unf7DPGRSq2o06CikKysJ/f75F7Y1sGkOxlY1m9IT0Gjo0TsZahbGGnDwlo1+b7s6yUJ6mHEDD8huaHzZZvwlr/BfR+vMR+L7B+pEwPUUQIGQG7T6cHNXIzOd+xAGx0qz0+TLw5zHI04tyDGOo0y85lUTq6P83/xs+8rhrPJqsl2FHVH6KvJj5Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28iqWVqnbz6OvfYrn7BuBqrQlDjvtruZL3m6Z+V3rlY=;
 b=eBpIu7JkfCzFdtR9Mg11Kug1NQeEsrhk/D56drkgLKJT9UEgqA7ywTXT/osei7L0/YE5CgrYX9LreA4C8Zp3CsGZfrwo0p4nOxds/vBlgIUJtClpqISb+ocxWXrkyJTupQb9GcrBNMJa1Qg+RXpog49uW+cugcqv+kJEWPZIu5k1DMPUc4x/LhZb65ZDjhDv26KnwcJgS1eO/aHMzAOUgwz7//iYEVRdQmm0BcB4SBhAjRHedBOsnpCbHKkvnyo7ozeOhbUj2QQlnuPUweI0I8tnLpXCJWrSjoz7CJXxs/PZTtkVdYgkSmh4Dk7X6LAyVMb3iDi2qbXb4hD4nP3B0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28iqWVqnbz6OvfYrn7BuBqrQlDjvtruZL3m6Z+V3rlY=;
 b=opt2pbIqszuCD2TKam68BFGX5ceyyLIdAiXmcYEpIkdtKAhsfOhaYhKlOGT7NUB9yTynp11epfl0QzHhhPi4UxYsj3j6qYzWyjS83dk78HmAzlOF4V2Hxwd5lvspE4B6RllxfXiKCFp5MU7upikqI4I8/OFIndKtJqSFMCXOlgl34g39LSTRN9wd0cEFgs+UkRkIBOspjkuPEIWhT0A4G3fX6iQjwynaM9XZ2YArBDMZLAcIxMoL93zZonsY7EDM+Y/UhYTJxTHLYpHs7+2JM48btk9hmxFKq7pOHFjRYpHw5aL8ud22WQ3szi8u64Cj/TkBf9I+QZEyBsy/jACogg==
Received: from BN8PR04CA0048.namprd04.prod.outlook.com (2603:10b6:408:d4::22)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:26 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::29) by BN8PR04CA0048.outlook.office365.com
 (2603:10b6:408:d4::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:25 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:16 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:15 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 03/10] devlink: Move devlink health get and set code to health file
Date:   Tue, 14 Feb 2023 18:37:59 +0200
Message-ID: <1676392686-405892-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT020:EE_|SA0PR12MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: d451d52a-32e5-4860-3aaa-08db0ea9e536
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RO/faJaHTbcZwMWrmuEi1PsgeEh8agt8GxSJg5wmr5zfSDuZyaT13n3JblYq/wy4SYbgDL4ZxC7wEHkx9ow4i4WfH+xJOwR2Oc0WF4cYgf68K/VC2kRBxUTQONZbGGfHAA7OsSqSlUUwM40+38Nyr4xVhptwGFMR7aKVrmh5TquyPkeVOK4dH5BDM9239siSoIlrckXcUw8WL2atTVKZmRADAWdqzBOnoDGExF2cG74gJ37BB8l+CG+K3uaYcQt+qEVY6F9JnnSM1+YwJ6gu/dZmDE0bLYvTLYKZ5aIo0gkiwXmfxkKE1n+qK/+11xd8OfTQM7Lq8wbw8+E5qlDXkOyfY9ZqcAqfWsK3rWS3CC2aLQPp+SI+mldWIIIcoxRrkwy0N9K9/niiENAURNDTPTM09snAFeTuuRxD17g5CJD6JBv43yDbv2Ij5yQUq9l4QFvMH4uyqXcy7nBcASPjfgHqO21jAB9MbEXuj9krO9XpBOEnEaaMM5WcHxGHbJgUZi4Zzv9S6tlJAiT7Ac1sm4iEzNwkwmTitcS9QBYi2IgV1U/Cp6jRtw5irZruypI7dqI8tNrSCTOAgTLTgBCqGF/N3pBc6SlUz68vghSfGopQiAdDJEeFuAn38hhZK4uLpnh3bPAxz9kX9aMrOdpZJ6LVkT4DQV1MpcxB1USATgINo7hiVgOXhIOduYkNus82rbhDXwKD0tnZIHFFgHmB3Q==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(41300700001)(110136005)(8936002)(8676002)(316002)(4326008)(5660300002)(30864003)(70206006)(70586007)(2906002)(478600001)(7696005)(186003)(6666004)(107886003)(26005)(40460700003)(2616005)(36756003)(336012)(426003)(83380400001)(36860700001)(47076005)(40480700001)(82740400003)(7636003)(82310400005)(356005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:25.8980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d451d52a-32e5-4860-3aaa-08db0ea9e536
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink health get and set callbacks and related code from
leftover.c to health.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h |  18 +++
 net/devlink/health.c        | 214 +++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 219 +-----------------------------------
 3 files changed, 234 insertions(+), 217 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 49fe9e2dae34..085f80b5feb8 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -176,6 +176,8 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
 
 struct devlink_port *
 devlink_port_get_from_info(struct devlink *devlink, struct genl_info *info);
+struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
+						 struct nlattr **attrs);
 
 /* Reload */
 bool devlink_reload_actions_valid(const struct devlink_ops *ops);
@@ -224,6 +226,18 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 struct devlink_health_reporter *
 devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name);
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_attrs(struct devlink *devlink,
+				       struct nlattr **attrs);
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_info(struct devlink *devlink,
+				      struct genl_info *info);
+int
+devlink_nl_health_reporter_fill(struct sk_buff *msg,
+				struct devlink_health_reporter *reporter,
+				enum devlink_command cmd, u32 portid,
+				u32 seq, int flags);
+
 void devlink_fmsg_free(struct devlink_fmsg *fmsg);
 
 /* Line cards */
@@ -249,3 +263,7 @@ int devlink_nl_cmd_info_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_flash_update(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_selftests_run(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
+					    struct genl_info *info);
+int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
+					    struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 18d1f38380b3..1c92f369c918 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -194,3 +194,217 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 	devl_unlock(devlink);
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
+
+int
+devlink_nl_health_reporter_fill(struct sk_buff *msg,
+				struct devlink_health_reporter *reporter,
+				enum devlink_command cmd, u32 portid,
+				u32 seq, int flags)
+{
+	struct devlink *devlink = reporter->devlink;
+	struct nlattr *reporter_attr;
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	if (reporter->devlink_port) {
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, reporter->devlink_port->index))
+			goto genlmsg_cancel;
+	}
+	reporter_attr = nla_nest_start_noflag(msg,
+					      DEVLINK_ATTR_HEALTH_REPORTER);
+	if (!reporter_attr)
+		goto genlmsg_cancel;
+	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
+			   reporter->ops->name))
+		goto reporter_nest_cancel;
+	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
+		       reporter->health_state))
+		goto reporter_nest_cancel;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT,
+			      reporter->error_count, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT,
+			      reporter->recovery_count, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->recover &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD,
+			      reporter->graceful_period,
+			      DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->recover &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
+		       reporter->auto_recover))
+		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS,
+			      jiffies_to_msecs(reporter->dump_ts),
+			      DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
+			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->dump &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
+		       reporter->auto_dump))
+		goto reporter_nest_cancel;
+
+	nla_nest_end(msg, reporter_attr);
+	genlmsg_end(msg, hdr);
+	return 0;
+
+reporter_nest_cancel:
+	nla_nest_cancel(msg, reporter_attr);
+genlmsg_cancel:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_attrs(struct devlink *devlink,
+				       struct nlattr **attrs)
+{
+	struct devlink_port *devlink_port;
+	char *reporter_name;
+
+	if (!attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME])
+		return NULL;
+
+	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
+	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
+	if (IS_ERR(devlink_port))
+		return devlink_health_reporter_find_by_name(devlink,
+							    reporter_name);
+	else
+		return devlink_port_health_reporter_find_by_name(devlink_port,
+								 reporter_name);
+}
+
+struct devlink_health_reporter *
+devlink_health_reporter_get_from_info(struct devlink *devlink,
+				      struct genl_info *info)
+{
+	return devlink_health_reporter_get_from_attrs(devlink, info->attrs);
+}
+
+int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+	struct sk_buff *msg;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_health_reporter_fill(msg, reporter,
+					      DEVLINK_CMD_HEALTH_REPORTER_GET,
+					      info->snd_portid, info->snd_seq,
+					      0);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int
+devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
+					    struct devlink *devlink,
+					    struct netlink_callback *cb)
+{
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
+	struct devlink_health_reporter *reporter;
+	struct devlink_port *port;
+	unsigned long port_index;
+	int idx = 0;
+	int err;
+
+	list_for_each_entry(reporter, &devlink->reporter_list, list) {
+		if (idx < state->idx) {
+			idx++;
+			continue;
+		}
+		err = devlink_nl_health_reporter_fill(msg, reporter,
+						      DEVLINK_CMD_HEALTH_REPORTER_GET,
+						      NETLINK_CB(cb->skb).portid,
+						      cb->nlh->nlmsg_seq,
+						      NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			return err;
+		}
+		idx++;
+	}
+	xa_for_each(&devlink->ports, port_index, port) {
+		list_for_each_entry(reporter, &port->reporter_list, list) {
+			if (idx < state->idx) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_health_reporter_fill(msg, reporter,
+							      DEVLINK_CMD_HEALTH_REPORTER_GET,
+							      NETLINK_CB(cb->skb).portid,
+							      cb->nlh->nlmsg_seq,
+							      NLM_F_MULTI);
+			if (err) {
+				state->idx = idx;
+				return err;
+			}
+			idx++;
+		}
+	}
+
+	return 0;
+}
+
+const struct devlink_cmd devl_cmd_health_reporter_get = {
+	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
+};
+
+int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->recover &&
+	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
+	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
+		return -EOPNOTSUPP;
+
+	if (!reporter->ops->dump &&
+	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		return -EOPNOTSUPP;
+
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
+		reporter->graceful_period =
+			nla_get_u64(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD]);
+
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])
+		reporter->auto_recover =
+			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
+
+	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
+		reporter->auto_dump =
+		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
+
+	return 0;
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 90f95f06de28..0b1c5e0122f3 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -156,8 +156,8 @@ static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 	return xa_load(&devlink->ports, port_index);
 }
 
-static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
-							struct nlattr **attrs)
+struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
+						 struct nlattr **attrs)
 {
 	if (attrs[DEVLINK_ATTR_PORT_INDEX]) {
 		u32 port_index = nla_get_u32(attrs[DEVLINK_ATTR_PORT_INDEX]);
@@ -5963,77 +5963,6 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	return err;
 }
 
-static int
-devlink_nl_health_reporter_fill(struct sk_buff *msg,
-				struct devlink_health_reporter *reporter,
-				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags)
-{
-	struct devlink *devlink = reporter->devlink;
-	struct nlattr *reporter_attr;
-	void *hdr;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto genlmsg_cancel;
-
-	if (reporter->devlink_port) {
-		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, reporter->devlink_port->index))
-			goto genlmsg_cancel;
-	}
-	reporter_attr = nla_nest_start_noflag(msg,
-					      DEVLINK_ATTR_HEALTH_REPORTER);
-	if (!reporter_attr)
-		goto genlmsg_cancel;
-	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
-			   reporter->ops->name))
-		goto reporter_nest_cancel;
-	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
-		       reporter->health_state))
-		goto reporter_nest_cancel;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT,
-			      reporter->error_count, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT,
-			      reporter->recovery_count, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->recover &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD,
-			      reporter->graceful_period,
-			      DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->recover &&
-	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
-		       reporter->auto_recover))
-		goto reporter_nest_cancel;
-	if (reporter->dump_fmsg &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS,
-			      jiffies_to_msecs(reporter->dump_ts),
-			      DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->dump_fmsg &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
-			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->dump &&
-	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
-		       reporter->auto_dump))
-		goto reporter_nest_cancel;
-
-	nla_nest_end(msg, reporter_attr);
-	genlmsg_end(msg, hdr);
-	return 0;
-
-reporter_nest_cancel:
-	nla_nest_cancel(msg, reporter_attr);
-genlmsg_cancel:
-	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
-}
-
 static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 				   enum devlink_command cmd)
 {
@@ -6188,33 +6117,6 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 }
 EXPORT_SYMBOL_GPL(devlink_health_report);
 
-static struct devlink_health_reporter *
-devlink_health_reporter_get_from_attrs(struct devlink *devlink,
-				       struct nlattr **attrs)
-{
-	struct devlink_port *devlink_port;
-	char *reporter_name;
-
-	if (!attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME])
-		return NULL;
-
-	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
-	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
-	if (IS_ERR(devlink_port))
-		return devlink_health_reporter_find_by_name(devlink,
-							    reporter_name);
-	else
-		return devlink_port_health_reporter_find_by_name(devlink_port,
-								 reporter_name);
-}
-
-static struct devlink_health_reporter *
-devlink_health_reporter_get_from_info(struct devlink *devlink,
-				      struct genl_info *info)
-{
-	return devlink_health_reporter_get_from_attrs(devlink, info->attrs);
-}
-
 static struct devlink_health_reporter *
 devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 {
@@ -6251,123 +6153,6 @@ devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
 
-static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
-						   struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-	struct sk_buff *msg;
-	int err;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_health_reporter_fill(msg, reporter,
-					      DEVLINK_CMD_HEALTH_REPORTER_GET,
-					      info->snd_portid, info->snd_seq,
-					      0);
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int
-devlink_nl_cmd_health_reporter_get_dump_one(struct sk_buff *msg,
-					    struct devlink *devlink,
-					    struct netlink_callback *cb)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink_health_reporter *reporter;
-	struct devlink_port *port;
-	unsigned long port_index;
-	int idx = 0;
-	int err;
-
-	list_for_each_entry(reporter, &devlink->reporter_list, list) {
-		if (idx < state->idx) {
-			idx++;
-			continue;
-		}
-		err = devlink_nl_health_reporter_fill(msg, reporter,
-						      DEVLINK_CMD_HEALTH_REPORTER_GET,
-						      NETLINK_CB(cb->skb).portid,
-						      cb->nlh->nlmsg_seq,
-						      NLM_F_MULTI);
-		if (err) {
-			state->idx = idx;
-			return err;
-		}
-		idx++;
-	}
-	xa_for_each(&devlink->ports, port_index, port) {
-		list_for_each_entry(reporter, &port->reporter_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_health_reporter_fill(msg, reporter,
-							      DEVLINK_CMD_HEALTH_REPORTER_GET,
-							      NETLINK_CB(cb->skb).portid,
-							      cb->nlh->nlmsg_seq,
-							      NLM_F_MULTI);
-			if (err) {
-				state->idx = idx;
-				return err;
-			}
-			idx++;
-		}
-	}
-
-	return 0;
-}
-
-const struct devlink_cmd devl_cmd_health_reporter_get = {
-	.dump_one		= devlink_nl_cmd_health_reporter_get_dump_one,
-};
-
-static int
-devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
-					struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->recover &&
-	    (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] ||
-	     info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]))
-		return -EOPNOTSUPP;
-
-	if (!reporter->ops->dump &&
-	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
-		return -EOPNOTSUPP;
-
-	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
-		reporter->graceful_period =
-			nla_get_u64(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD]);
-
-	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])
-		reporter->auto_recover =
-			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
-
-	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
-		reporter->auto_dump =
-		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
-
-	return 0;
-}
-
 static int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 						       struct genl_info *info)
 {
-- 
2.27.0

