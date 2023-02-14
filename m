Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6991C6969E2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjBNQjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjBNQit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:49 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2072.outbound.protection.outlook.com [40.107.212.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46E824C8A
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QA5g8IccqxUy3HxIkThbT0EN9m4Yo/7Wx3p0m1mg0N9MetmvL7fNRtEZG7fTb7EYH/icMHCmvTMzi8auAQmgQZ60Jq3ngB1GZCIiQrasZwyWJEWWj3u9nR2NyI2E0nZUCQI4dboUVZZgXP3xlD5IOcwkqMYe/Am47YJlhLJsut9mIZ9JV6bmfHZOzTrur+N8Y7/KphpqYfwhQBZQU3Pcp3aTDz5e4VzNsk4p/OLMdkvk/z2PNz4mPdN9tOaFDLGWm4U53wkYknbN2xWQ8ccJK3hMHSelGCUysk4p8tjd4vzAw/q4MgrWRMIs38+X6SbGIeFmpt5cAzyTPQcTrD1msw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjMlLiAxTfZ8KTzgpbvfuQVsZ0UkO23upF3z15Is/zc=;
 b=BJ8sOO7hjnYRQ9e1pWqiOZdZftreeZ74y31H1yANS4H2aRdXJ3L0Mj9YMMDT+Ndyskbp8TYHRgn3FXgriPqK1DZ03uiAt7CS4oSilq2On5NAV/NIw04fjtoX6gtFG1iw5re7vqAZTn3a2CcfEKnuPa0BL04UsXD5I8B0209NFKopq2wEU70kmNco7N+sGS6Q3wlKCo7LLD9x8yxEDoi24Bpx0XVRb4M9PAwn8gqSPf4QjObNi3K/8+k0Jb9ASgVu9OEUqhOXhguEJay1weMbu8/O/A4x1Wav/ZNED7IVWq9Xws1/wGvdV8AsOTpt2mXNvCZ3tMwY4GaABMkO/IL64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjMlLiAxTfZ8KTzgpbvfuQVsZ0UkO23upF3z15Is/zc=;
 b=ipJjUGtqU3ugMQ4g19hy0ULotcq2TBX9sF3AgGOiDS4sp/7kSgDYV2lkD9A6v69nb35Y993H037FALMHtxZSZhJxBb9o7TS6J7miW/jY1ccgvDMviHXJQxQqAkEWhFBZ5AvO+owk5cDWWr+nzCvIniXhurTtEO5OKPZFptz0bLFUOHSaZRtqMoeh/3LoIwNTMmFxKKFdsXvmQ1zX/nZjnwzV1KatekkBAFVgFvtQO5U0dea1uf2/mLsBjKvO/02SMPRY1260bf7VpvXKugidU6ipa9wucWYM5bisMuwLbxWRmrRP5/aIHYM5f+0PLGDrH87rgc3y+23jfuStsml6/w==
Received: from MW2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:907::23) by
 SJ1PR12MB6339.namprd12.prod.outlook.com (2603:10b6:a03:454::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:38:32 +0000
Received: from CO1NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::2a) by MW2PR16CA0010.outlook.office365.com
 (2603:10b6:907::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT097.mail.protection.outlook.com (10.13.175.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 16:38:32 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:20 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:20 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:19 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 05/10] devlink: Move devlink fmsg and health diagnose to health file
Date:   Tue, 14 Feb 2023 18:38:01 +0200
Message-ID: <1676392686-405892-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
References: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT097:EE_|SJ1PR12MB6339:EE_
X-MS-Office365-Filtering-Correlation-Id: f84b0011-c325-41d5-6dcf-08db0ea9e8e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNfaBiSoQnHpec2pZ0uy131+Xg9Kj6jjb3SLXH8Vle4BFKYEwUYAZg9tTUchGqHQVpyNv00bGTj3YHZ5WDCt9E6Z4TwfDh3oQQVSsGXjXxStyZdEp1bzS3QuBTxgL7h5084JvWYaIeEKpmOeHnp1MMhOHL70MQuXZRmMKngA2cw+C8USR678fXU7aeIy3+vNX7HlSR3hahnvImhosj0lop3EQia94O0VjdjEagVhqnklSB3kRIDd1rmSrtucMsvfZhcd0gRn43lPjpezC6NctAjiY/FGvW4d6U7Dcsej/Mgdy2t4JCuMROS1mo4Qr4dXK68GJB/LcVx9PMNjUNCfXrQZe8Vh5suC7u5MwGVLmlpBUGqdUcfjRFD7Ji4htj883v+G5em1S1GpFDWc0Z48YlsQEbKQ7D2chDHUxBoJwBgVC+O7QkyqYDaggP7UyfEauZ7qkKX7lGRlQyMA5EnrlYflX26xQFHBPgif32BBU1ux1mPrZO10DoL/GJdES0eHrby5hGBzmKe4bQALa957vfsMYWI/BgvkrRq2f4KjTJdwWHCspjWJNv26s0KkGSAOaiO6AXBe5eWlBcyIS9VRe4Zh4s0Xn3o0E8LEZocfPJRvreg5RW2ObubXcyA+LZs5zKEUy6iPLlr5KUn7589kAIaGPlHThHCnlQJvSRnPbMIsjoxZ/0lsGmbEPGrrcaLG5BzXJqfSUrcoMYx8IrLwTQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(83380400001)(4326008)(36860700001)(8676002)(7636003)(316002)(107886003)(36756003)(41300700001)(110136005)(2616005)(82310400005)(82740400003)(70206006)(70586007)(47076005)(426003)(336012)(2906002)(8936002)(30864003)(40460700003)(5660300002)(40480700001)(478600001)(356005)(6666004)(7696005)(186003)(86362001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:32.1706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f84b0011-c325-41d5-6dcf-08db0ea9e8e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6339
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink fmsg (formatted message) is used by devlink health diagnose,
dump and drivers which support these devlink health callbacks.
Therefore, move devlink fmsg helpers and related code to file health.c.
Move devlink health diagnose to file health.c. No functional change in
this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h |   6 +
 net/devlink/health.c        | 630 ++++++++++++++++++++++++++++++++++++
 net/devlink/leftover.c      | 630 ------------------------------------
 3 files changed, 636 insertions(+), 630 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index d1a901cb5900..a4b96f8a0ab4 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -240,7 +240,11 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 			   void *priv_ctx,
 			   struct netlink_ext_ack *extack);
+int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			struct netlink_callback *cb,
+			enum devlink_command cmd);
 
+struct devlink_fmsg *devlink_fmsg_alloc(void);
 void devlink_fmsg_free(struct devlink_fmsg *fmsg);
 
 /* Line cards */
@@ -272,3 +276,5 @@ int devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
 					    struct genl_info *info);
 int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 						struct genl_info *info);
+int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
+						 struct genl_info *info);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index bfeb71f17ff0..fbeedc8df043 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -8,6 +8,48 @@
 #include <trace/events/devlink.h>
 #include "devl_internal.h"
 
+struct devlink_fmsg_item {
+	struct list_head list;
+	int attrtype;
+	u8 nla_type;
+	u16 len;
+	int value[];
+};
+
+struct devlink_fmsg {
+	struct list_head item_list;
+	bool putting_binary; /* This flag forces enclosing of binary data
+			      * in an array brackets. It forces using
+			      * of designated API:
+			      * devlink_fmsg_binary_pair_nest_start()
+			      * devlink_fmsg_binary_pair_nest_end()
+			      */
+};
+
+struct devlink_fmsg *devlink_fmsg_alloc(void)
+{
+	struct devlink_fmsg *fmsg;
+
+	fmsg = kzalloc(sizeof(*fmsg), GFP_KERNEL);
+	if (!fmsg)
+		return NULL;
+
+	INIT_LIST_HEAD(&fmsg->item_list);
+
+	return fmsg;
+}
+
+void devlink_fmsg_free(struct devlink_fmsg *fmsg)
+{
+	struct devlink_fmsg_item *item, *tmp;
+
+	list_for_each_entry_safe(item, tmp, &fmsg->item_list, list) {
+		list_del(&item->list);
+		kfree(item);
+	}
+	kfree(fmsg);
+}
+
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter)
 {
@@ -544,3 +586,591 @@ int devlink_nl_cmd_health_reporter_recover_doit(struct sk_buff *skb,
 
 	return devlink_health_reporter_recover(reporter, NULL, info->extack);
 }
+
+static int devlink_fmsg_nest_common(struct devlink_fmsg *fmsg,
+				    int attrtype)
+{
+	struct devlink_fmsg_item *item;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+
+	item->attrtype = attrtype;
+	list_add_tail(&item->list, &fmsg->item_list);
+
+	return 0;
+}
+
+int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
+
+static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
+}
+
+int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
+
+#define DEVLINK_FMSG_MAX_SIZE (GENLMSG_DEFAULT_SIZE - GENL_HDRLEN - NLA_HDRLEN)
+
+static int devlink_fmsg_put_name(struct devlink_fmsg *fmsg, const char *name)
+{
+	struct devlink_fmsg_item *item;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
+		return -EMSGSIZE;
+
+	item = kzalloc(sizeof(*item) + strlen(name) + 1, GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+
+	item->nla_type = NLA_NUL_STRING;
+	item->len = strlen(name) + 1;
+	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_NAME;
+	memcpy(&item->value, name, item->len);
+	list_add_tail(&item->list, &fmsg->item_list);
+
+	return 0;
+}
+
+int devlink_fmsg_pair_nest_start(struct devlink_fmsg *fmsg, const char *name)
+{
+	int err;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_put_name(fmsg, name);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
+
+int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
+
+int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
+				     const char *name)
+{
+	int err;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_ARR_NEST_START);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_start);
+
+int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	err = devlink_fmsg_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
+
+int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
+					const char *name)
+{
+	int err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	fmsg->putting_binary = true;
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
+
+int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	fmsg->putting_binary = false;
+	return devlink_fmsg_arr_pair_nest_end(fmsg);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
+
+static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
+				  const void *value, u16 value_len,
+				  u8 value_nla_type)
+{
+	struct devlink_fmsg_item *item;
+
+	if (value_len > DEVLINK_FMSG_MAX_SIZE)
+		return -EMSGSIZE;
+
+	item = kzalloc(sizeof(*item) + value_len, GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+
+	item->nla_type = value_nla_type;
+	item->len = value_len;
+	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
+	memcpy(&item->value, value, item->len);
+	list_add_tail(&item->list, &fmsg->item_list);
+
+	return 0;
+}
+
+static int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
+}
+
+static int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
+}
+
+int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
+
+static int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
+}
+
+int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
+{
+	if (fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
+				      NLA_NUL_STRING);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
+
+int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+			    u16 value_len)
+{
+	if (!fmsg->putting_binary)
+		return -EINVAL;
+
+	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
+
+int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			       bool value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_bool_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_bool_pair_put);
+
+int devlink_fmsg_u8_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			     u8 value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u8_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u8_pair_put);
+
+int devlink_fmsg_u32_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			      u32 value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u32_pair_put);
+
+int devlink_fmsg_u64_pair_put(struct devlink_fmsg *fmsg, const char *name,
+			      u64 value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u64_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_u64_pair_put);
+
+int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
+				 const char *value)
+{
+	int err;
+
+	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_string_put(fmsg, value);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_string_pair_put);
+
+int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
+				 const void *value, u32 value_len)
+{
+	u32 data_size;
+	int end_err;
+	u32 offset;
+	int err;
+
+	err = devlink_fmsg_binary_pair_nest_start(fmsg, name);
+	if (err)
+		return err;
+
+	for (offset = 0; offset < value_len; offset += data_size) {
+		data_size = value_len - offset;
+		if (data_size > DEVLINK_FMSG_MAX_SIZE)
+			data_size = DEVLINK_FMSG_MAX_SIZE;
+		err = devlink_fmsg_binary_put(fmsg, value + offset, data_size);
+		if (err)
+			break;
+		/* Exit from loop with a break (instead of
+		 * return) to make sure putting_binary is turned off in
+		 * devlink_fmsg_binary_pair_nest_end
+		 */
+	}
+
+	end_err = devlink_fmsg_binary_pair_nest_end(fmsg);
+	if (end_err)
+		err = end_err;
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
+
+static int
+devlink_fmsg_item_fill_type(struct devlink_fmsg_item *msg, struct sk_buff *skb)
+{
+	switch (msg->nla_type) {
+	case NLA_FLAG:
+	case NLA_U8:
+	case NLA_U32:
+	case NLA_U64:
+	case NLA_NUL_STRING:
+	case NLA_BINARY:
+		return nla_put_u8(skb, DEVLINK_ATTR_FMSG_OBJ_VALUE_TYPE,
+				  msg->nla_type);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+devlink_fmsg_item_fill_data(struct devlink_fmsg_item *msg, struct sk_buff *skb)
+{
+	int attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
+	u8 tmp;
+
+	switch (msg->nla_type) {
+	case NLA_FLAG:
+		/* Always provide flag data, regardless of its value */
+		tmp = *(bool *)msg->value;
+
+		return nla_put_u8(skb, attrtype, tmp);
+	case NLA_U8:
+		return nla_put_u8(skb, attrtype, *(u8 *)msg->value);
+	case NLA_U32:
+		return nla_put_u32(skb, attrtype, *(u32 *)msg->value);
+	case NLA_U64:
+		return nla_put_u64_64bit(skb, attrtype, *(u64 *)msg->value,
+					 DEVLINK_ATTR_PAD);
+	case NLA_NUL_STRING:
+		return nla_put_string(skb, attrtype, (char *)&msg->value);
+	case NLA_BINARY:
+		return nla_put(skb, attrtype, msg->len, (void *)&msg->value);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			 int *start)
+{
+	struct devlink_fmsg_item *item;
+	struct nlattr *fmsg_nlattr;
+	int err = 0;
+	int i = 0;
+
+	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
+	if (!fmsg_nlattr)
+		return -EMSGSIZE;
+
+	list_for_each_entry(item, &fmsg->item_list, list) {
+		if (i < *start) {
+			i++;
+			continue;
+		}
+
+		switch (item->attrtype) {
+		case DEVLINK_ATTR_FMSG_OBJ_NEST_START:
+		case DEVLINK_ATTR_FMSG_PAIR_NEST_START:
+		case DEVLINK_ATTR_FMSG_ARR_NEST_START:
+		case DEVLINK_ATTR_FMSG_NEST_END:
+			err = nla_put_flag(skb, item->attrtype);
+			break;
+		case DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA:
+			err = devlink_fmsg_item_fill_type(item, skb);
+			if (err)
+				break;
+			err = devlink_fmsg_item_fill_data(item, skb);
+			break;
+		case DEVLINK_ATTR_FMSG_OBJ_NAME:
+			err = nla_put_string(skb, item->attrtype,
+					     (char *)&item->value);
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+		if (!err)
+			*start = ++i;
+		else
+			break;
+	}
+
+	nla_nest_end(skb, fmsg_nlattr);
+	return err;
+}
+
+static int devlink_fmsg_snd(struct devlink_fmsg *fmsg,
+			    struct genl_info *info,
+			    enum devlink_command cmd, int flags)
+{
+	struct nlmsghdr *nlh;
+	struct sk_buff *skb;
+	bool last = false;
+	int index = 0;
+	void *hdr;
+	int err;
+
+	while (!last) {
+		int tmp_index = index;
+
+		skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		if (!skb)
+			return -ENOMEM;
+
+		hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
+				  &devlink_nl_family, flags | NLM_F_MULTI, cmd);
+		if (!hdr) {
+			err = -EMSGSIZE;
+			goto nla_put_failure;
+		}
+
+		err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
+		if (!err)
+			last = true;
+		else if (err != -EMSGSIZE || tmp_index == index)
+			goto nla_put_failure;
+
+		genlmsg_end(skb, hdr);
+		err = genlmsg_reply(skb, info);
+		if (err)
+			return err;
+	}
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	nlh = nlmsg_put(skb, info->snd_portid, info->snd_seq,
+			NLMSG_DONE, 0, flags | NLM_F_MULTI);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	return genlmsg_reply(skb, info);
+
+nla_put_failure:
+	nlmsg_free(skb);
+	return err;
+}
+
+int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
+			struct netlink_callback *cb,
+			enum devlink_command cmd)
+{
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
+	int index = state->idx;
+	int tmp_index = index;
+	void *hdr;
+	int err;
+
+	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI, cmd);
+	if (!hdr) {
+		err = -EMSGSIZE;
+		goto nla_put_failure;
+	}
+
+	err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
+	if ((err && err != -EMSGSIZE) || tmp_index == index)
+		goto nla_put_failure;
+
+	state->idx = index;
+	genlmsg_end(skb, hdr);
+	return skb->len;
+
+nla_put_failure:
+	genlmsg_cancel(skb, hdr);
+	return err;
+}
+
+int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
+						 struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+	struct devlink_fmsg *fmsg;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->diagnose)
+		return -EOPNOTSUPP;
+
+	fmsg = devlink_fmsg_alloc();
+	if (!fmsg)
+		return -ENOMEM;
+
+	err = devlink_fmsg_obj_nest_start(fmsg);
+	if (err)
+		goto out;
+
+	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
+	if (err)
+		goto out;
+
+	err = devlink_fmsg_obj_nest_end(fmsg);
+	if (err)
+		goto out;
+
+	err = devlink_fmsg_snd(fmsg, info,
+			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
+
+out:
+	devlink_fmsg_free(fmsg);
+	return err;
+}
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 03184dd3d271..e460bcf1d247 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5372,597 +5372,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	return err;
 }
 
-struct devlink_fmsg_item {
-	struct list_head list;
-	int attrtype;
-	u8 nla_type;
-	u16 len;
-	int value[];
-};
-
-struct devlink_fmsg {
-	struct list_head item_list;
-	bool putting_binary; /* This flag forces enclosing of binary data
-			      * in an array brackets. It forces using
-			      * of designated API:
-			      * devlink_fmsg_binary_pair_nest_start()
-			      * devlink_fmsg_binary_pair_nest_end()
-			      */
-};
-
-static struct devlink_fmsg *devlink_fmsg_alloc(void)
-{
-	struct devlink_fmsg *fmsg;
-
-	fmsg = kzalloc(sizeof(*fmsg), GFP_KERNEL);
-	if (!fmsg)
-		return NULL;
-
-	INIT_LIST_HEAD(&fmsg->item_list);
-
-	return fmsg;
-}
-
-void devlink_fmsg_free(struct devlink_fmsg *fmsg)
-{
-	struct devlink_fmsg_item *item, *tmp;
-
-	list_for_each_entry_safe(item, tmp, &fmsg->item_list, list) {
-		list_del(&item->list);
-		kfree(item);
-	}
-	kfree(fmsg);
-}
-
-static int devlink_fmsg_nest_common(struct devlink_fmsg *fmsg,
-				    int attrtype)
-{
-	struct devlink_fmsg_item *item;
-
-	item = kzalloc(sizeof(*item), GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
-	item->attrtype = attrtype;
-	list_add_tail(&item->list, &fmsg->item_list);
-
-	return 0;
-}
-
-int devlink_fmsg_obj_nest_start(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_OBJ_NEST_START);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_start);
-
-static int devlink_fmsg_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_NEST_END);
-}
-
-int devlink_fmsg_obj_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_end(fmsg);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_obj_nest_end);
-
-#define DEVLINK_FMSG_MAX_SIZE (GENLMSG_DEFAULT_SIZE - GENL_HDRLEN - NLA_HDRLEN)
-
-static int devlink_fmsg_put_name(struct devlink_fmsg *fmsg, const char *name)
-{
-	struct devlink_fmsg_item *item;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	if (strlen(name) + 1 > DEVLINK_FMSG_MAX_SIZE)
-		return -EMSGSIZE;
-
-	item = kzalloc(sizeof(*item) + strlen(name) + 1, GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
-	item->nla_type = NLA_NUL_STRING;
-	item->len = strlen(name) + 1;
-	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_NAME;
-	memcpy(&item->value, name, item->len);
-	list_add_tail(&item->list, &fmsg->item_list);
-
-	return 0;
-}
-
-int devlink_fmsg_pair_nest_start(struct devlink_fmsg *fmsg, const char *name)
-{
-	int err;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_PAIR_NEST_START);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_put_name(fmsg, name);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_start);
-
-int devlink_fmsg_pair_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_nest_end(fmsg);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_pair_nest_end);
-
-int devlink_fmsg_arr_pair_nest_start(struct devlink_fmsg *fmsg,
-				     const char *name)
-{
-	int err;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_nest_common(fmsg, DEVLINK_ATTR_FMSG_ARR_NEST_START);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_start);
-
-int devlink_fmsg_arr_pair_nest_end(struct devlink_fmsg *fmsg)
-{
-	int err;
-
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	err = devlink_fmsg_nest_end(fmsg);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_arr_pair_nest_end);
-
-int devlink_fmsg_binary_pair_nest_start(struct devlink_fmsg *fmsg,
-					const char *name)
-{
-	int err;
-
-	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	fmsg->putting_binary = true;
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_start);
-
-int devlink_fmsg_binary_pair_nest_end(struct devlink_fmsg *fmsg)
-{
-	if (!fmsg->putting_binary)
-		return -EINVAL;
-
-	fmsg->putting_binary = false;
-	return devlink_fmsg_arr_pair_nest_end(fmsg);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_nest_end);
-
-static int devlink_fmsg_put_value(struct devlink_fmsg *fmsg,
-				  const void *value, u16 value_len,
-				  u8 value_nla_type)
-{
-	struct devlink_fmsg_item *item;
-
-	if (value_len > DEVLINK_FMSG_MAX_SIZE)
-		return -EMSGSIZE;
-
-	item = kzalloc(sizeof(*item) + value_len, GFP_KERNEL);
-	if (!item)
-		return -ENOMEM;
-
-	item->nla_type = value_nla_type;
-	item->len = value_len;
-	item->attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
-	memcpy(&item->value, value, item->len);
-	list_add_tail(&item->list, &fmsg->item_list);
-
-	return 0;
-}
-
-static int devlink_fmsg_bool_put(struct devlink_fmsg *fmsg, bool value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_FLAG);
-}
-
-static int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U8);
-}
-
-int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U32);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u32_put);
-
-static int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, &value, sizeof(value), NLA_U64);
-}
-
-int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
-{
-	if (fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, value, strlen(value) + 1,
-				      NLA_NUL_STRING);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
-
-int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
-			    u16 value_len)
-{
-	if (!fmsg->putting_binary)
-		return -EINVAL;
-
-	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
-
-int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			       bool value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_bool_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_bool_pair_put);
-
-int devlink_fmsg_u8_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			     u8 value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u8_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u8_pair_put);
-
-int devlink_fmsg_u32_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			      u32 value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u32_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u32_pair_put);
-
-int devlink_fmsg_u64_pair_put(struct devlink_fmsg *fmsg, const char *name,
-			      u64 value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_u64_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_u64_pair_put);
-
-int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
-				 const char *value)
-{
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_string_put(fmsg, value);
-	if (err)
-		return err;
-
-	err = devlink_fmsg_pair_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_string_pair_put);
-
-int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
-				 const void *value, u32 value_len)
-{
-	u32 data_size;
-	int end_err;
-	u32 offset;
-	int err;
-
-	err = devlink_fmsg_binary_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	for (offset = 0; offset < value_len; offset += data_size) {
-		data_size = value_len - offset;
-		if (data_size > DEVLINK_FMSG_MAX_SIZE)
-			data_size = DEVLINK_FMSG_MAX_SIZE;
-		err = devlink_fmsg_binary_put(fmsg, value + offset, data_size);
-		if (err)
-			break;
-		/* Exit from loop with a break (instead of
-		 * return) to make sure putting_binary is turned off in
-		 * devlink_fmsg_binary_pair_nest_end
-		 */
-	}
-
-	end_err = devlink_fmsg_binary_pair_nest_end(fmsg);
-	if (end_err)
-		err = end_err;
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_pair_put);
-
-static int
-devlink_fmsg_item_fill_type(struct devlink_fmsg_item *msg, struct sk_buff *skb)
-{
-	switch (msg->nla_type) {
-	case NLA_FLAG:
-	case NLA_U8:
-	case NLA_U32:
-	case NLA_U64:
-	case NLA_NUL_STRING:
-	case NLA_BINARY:
-		return nla_put_u8(skb, DEVLINK_ATTR_FMSG_OBJ_VALUE_TYPE,
-				  msg->nla_type);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int
-devlink_fmsg_item_fill_data(struct devlink_fmsg_item *msg, struct sk_buff *skb)
-{
-	int attrtype = DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA;
-	u8 tmp;
-
-	switch (msg->nla_type) {
-	case NLA_FLAG:
-		/* Always provide flag data, regardless of its value */
-		tmp = *(bool *) msg->value;
-
-		return nla_put_u8(skb, attrtype, tmp);
-	case NLA_U8:
-		return nla_put_u8(skb, attrtype, *(u8 *) msg->value);
-	case NLA_U32:
-		return nla_put_u32(skb, attrtype, *(u32 *) msg->value);
-	case NLA_U64:
-		return nla_put_u64_64bit(skb, attrtype, *(u64 *) msg->value,
-					 DEVLINK_ATTR_PAD);
-	case NLA_NUL_STRING:
-		return nla_put_string(skb, attrtype, (char *) &msg->value);
-	case NLA_BINARY:
-		return nla_put(skb, attrtype, msg->len, (void *) &msg->value);
-	default:
-		return -EINVAL;
-	}
-}
-
-static int
-devlink_fmsg_prepare_skb(struct devlink_fmsg *fmsg, struct sk_buff *skb,
-			 int *start)
-{
-	struct devlink_fmsg_item *item;
-	struct nlattr *fmsg_nlattr;
-	int err = 0;
-	int i = 0;
-
-	fmsg_nlattr = nla_nest_start_noflag(skb, DEVLINK_ATTR_FMSG);
-	if (!fmsg_nlattr)
-		return -EMSGSIZE;
-
-	list_for_each_entry(item, &fmsg->item_list, list) {
-		if (i < *start) {
-			i++;
-			continue;
-		}
-
-		switch (item->attrtype) {
-		case DEVLINK_ATTR_FMSG_OBJ_NEST_START:
-		case DEVLINK_ATTR_FMSG_PAIR_NEST_START:
-		case DEVLINK_ATTR_FMSG_ARR_NEST_START:
-		case DEVLINK_ATTR_FMSG_NEST_END:
-			err = nla_put_flag(skb, item->attrtype);
-			break;
-		case DEVLINK_ATTR_FMSG_OBJ_VALUE_DATA:
-			err = devlink_fmsg_item_fill_type(item, skb);
-			if (err)
-				break;
-			err = devlink_fmsg_item_fill_data(item, skb);
-			break;
-		case DEVLINK_ATTR_FMSG_OBJ_NAME:
-			err = nla_put_string(skb, item->attrtype,
-					     (char *) &item->value);
-			break;
-		default:
-			err = -EINVAL;
-			break;
-		}
-		if (!err)
-			*start = ++i;
-		else
-			break;
-	}
-
-	nla_nest_end(skb, fmsg_nlattr);
-	return err;
-}
-
-static int devlink_fmsg_snd(struct devlink_fmsg *fmsg,
-			    struct genl_info *info,
-			    enum devlink_command cmd, int flags)
-{
-	struct nlmsghdr *nlh;
-	struct sk_buff *skb;
-	bool last = false;
-	int index = 0;
-	void *hdr;
-	int err;
-
-	while (!last) {
-		int tmp_index = index;
-
-		skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-		if (!skb)
-			return -ENOMEM;
-
-		hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
-				  &devlink_nl_family, flags | NLM_F_MULTI, cmd);
-		if (!hdr) {
-			err = -EMSGSIZE;
-			goto nla_put_failure;
-		}
-
-		err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
-		if (!err)
-			last = true;
-		else if (err != -EMSGSIZE || tmp_index == index)
-			goto nla_put_failure;
-
-		genlmsg_end(skb, hdr);
-		err = genlmsg_reply(skb, info);
-		if (err)
-			return err;
-	}
-
-	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	nlh = nlmsg_put(skb, info->snd_portid, info->snd_seq,
-			NLMSG_DONE, 0, flags | NLM_F_MULTI);
-	if (!nlh) {
-		err = -EMSGSIZE;
-		goto nla_put_failure;
-	}
-
-	return genlmsg_reply(skb, info);
-
-nla_put_failure:
-	nlmsg_free(skb);
-	return err;
-}
-
-static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
-			       struct netlink_callback *cb,
-			       enum devlink_command cmd)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	int index = state->idx;
-	int tmp_index = index;
-	void *hdr;
-	int err;
-
-	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI, cmd);
-	if (!hdr) {
-		err = -EMSGSIZE;
-		goto nla_put_failure;
-	}
-
-	err = devlink_fmsg_prepare_skb(fmsg, skb, &index);
-	if ((err && err != -EMSGSIZE) || tmp_index == index)
-		goto nla_put_failure;
-
-	state->idx = index;
-	genlmsg_end(skb, hdr);
-	return skb->len;
-
-nla_put_failure:
-	genlmsg_cancel(skb, hdr);
-	return err;
-}
-
 static void
 devlink_health_dump_clear(struct devlink_health_reporter *reporter)
 {
@@ -6031,45 +5440,6 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	return reporter;
 }
 
-static int devlink_nl_cmd_health_reporter_diagnose_doit(struct sk_buff *skb,
-							struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct devlink_health_reporter *reporter;
-	struct devlink_fmsg *fmsg;
-	int err;
-
-	reporter = devlink_health_reporter_get_from_info(devlink, info);
-	if (!reporter)
-		return -EINVAL;
-
-	if (!reporter->ops->diagnose)
-		return -EOPNOTSUPP;
-
-	fmsg = devlink_fmsg_alloc();
-	if (!fmsg)
-		return -ENOMEM;
-
-	err = devlink_fmsg_obj_nest_start(fmsg);
-	if (err)
-		goto out;
-
-	err = reporter->ops->diagnose(reporter, fmsg, info->extack);
-	if (err)
-		goto out;
-
-	err = devlink_fmsg_obj_nest_end(fmsg);
-	if (err)
-		goto out;
-
-	err = devlink_fmsg_snd(fmsg, info,
-			       DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE, 0);
-
-out:
-	devlink_fmsg_free(fmsg);
-	return err;
-}
-
 static int
 devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 					       struct netlink_callback *cb)
-- 
2.27.0

