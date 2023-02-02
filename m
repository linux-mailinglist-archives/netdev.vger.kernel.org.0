Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A9D688067
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbjBBOsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBBOs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:48:26 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2074.outbound.protection.outlook.com [40.107.212.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8236022782;
        Thu,  2 Feb 2023 06:48:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWMTGOxJXxKNXwrALjlCNcqTm4MAi4OPmfQ4vkTBAEPfOrMI1zjZAygT/v2a1FbYYf/UvPZpfhtJ3yJPpCmB3SrLJ/EC27TbBSG/zm/UDaFd0uUhJwPR24kp8zPBCFYnp1BssSyxFfkrbuqD6ujYBI12ovA75BVZcbO+3xL3R9XWzDVpWcxkC3Xqg7WBTHYScmGz16TeU/33PKHz9cJqeHqL4fbeRJXjkm4ixti5Z8s+c5CyAa9GS1UHSbxDA1D6i0njTQIjl5Hbc25diI3o1k4O9+QRVOtswRIgUvtyq3qPusCczFp/iiQVA6VdGRbZ3I+ybkzIu07uMofuQIh0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsFFNjTfegL/o5TjKPMLAROreWOqw6NJENSTgl2mhVA=;
 b=DwvZw3yWpxStJu2sJ3SzZZo3RH15qJO1Q4vLBwU6mmY/CQbFAU8ODazAzPtyaKVezEEYbVWV+2yM8pV2HTZrN+Uodmvko4AWP8GJNYoanhxo7E85dFnOI1DBqEiVYMyPLmqGGt9BzLWVvJJVzSt+Y2XderJ81HYeSHzZDMHdXZ8KvlYBE1QMZDsH00Qnnzref4wVf7D19UePTCl/NZ9Lhd5PjbulPDNlk7jIIcwlcaEHrkUstV9x3PsmrTigWckG4UcMxkkOgRSUv9Rvcn1VKr3QF9DFDFCchlHkt588azB45g1pbWfbs3m+L4gcs2IPoQfGRsFGHa22RwfL3thiNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsFFNjTfegL/o5TjKPMLAROreWOqw6NJENSTgl2mhVA=;
 b=JwKtdh4solYgXMX0mVWhu7sl/nagx7Wc6AEUwesPj73ehUhTkMHQd/2WNiUKlLvInL3QVAiEyPHtew+FC9mOE8c7qc1jv+6gUV+rx3ZpzWT2zfh1AwcEDkyJa4J+L2ciDe9Ftv22TyKXrUbX7Qd1p81arJB4S+ePMpxDuAqhJy5NU7eqkQ7ZxHIvO83GEFUh34p24pBnWUTYkxOowddqpEghgd9jLSQckSsL9X6eXM5T1/RPWSjM+N1nusKQASdehaql+U5Jbmnk0FhStyhAN4FJEYB2/b6b7vzTnD8FbUn1halfujgYj4cF6+rDOyIn3hxsNU0pQ2MsLYOYT57YxQ==
Received: from DM6PR13CA0024.namprd13.prod.outlook.com (2603:10b6:5:bc::37) by
 DM6PR12MB4217.namprd12.prod.outlook.com (2603:10b6:5:219::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25; Thu, 2 Feb 2023 14:47:58 +0000
Received: from DS1PEPF0000E65A.namprd02.prod.outlook.com
 (2603:10b6:5:bc:cafe::7c) by DM6PR13CA0024.outlook.office365.com
 (2603:10b6:5:bc::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7 via Frontend
 Transport; Thu, 2 Feb 2023 14:47:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E65A.mail.protection.outlook.com (10.167.18.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Thu, 2 Feb 2023 14:47:58 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:46 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 06:47:46 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 2 Feb
 2023 06:47:44 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 3/7] devlink: Move devlink dev eswitch code to dev
Date:   Thu, 2 Feb 2023 16:47:02 +0200
Message-ID: <1675349226-284034-4-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E65A:EE_|DM6PR12MB4217:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e31550-ab63-452c-1f55-08db052c79c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUfy7bUfcgDED1U0pI2/DNafYK5e79tUdM9ygoeSpQYhmrZKieeuxnu8yraqLpe4UL4XTZd8hwJbYlFxYklYPQQBGAp5+CPnyrPOJK0i7RFKIlJ+f9eGFqOhuLk8ReRM+3s/2uNaFI6JR8cE3lWDQvQAkYVJ5h+UGiyhXAsVUn9VD1fM38hUlWS8SmPb+uboENKjRMvwo31pbVRwCYx7z8kFQtYM+UpLel6DAsN+M16LCgkJNaiVYrXBrly9vPT9hpQnPBHpOuRzfkWXZMqvFw1pYqHe9Vmf4BEvqM69bCu71/fuZdr9q6Wes319xmDqwssiPcwZaULil2tVc+/6z62xwAkUt6p1Ew43vsdXJ1PbT82jLMRJyly3jfFuDpCurKPMpt0vPLiISbl2b5A2bXtLwrjO9EQYphyTHGTnywG6kbMO1qr9PxmE800vblnSLEENLcNWRLVQpkkOoBUyvBofy1WlhH6P5HUiVU7IIl6z0njsrvb3guJdtmD4hKxAMuBsHZXKgAQdhYNwAte/4GQkV7DlscUhm355s3KJZmxNCiwEcK98vrFZQDXYRK/VTcVDmU7DoJd8eZp7Zcq5Ld3Kw49CCzzaMDcHhQ/CcxAiHINxqGBje8KOyO1GSq9vsafsSz9JwmH6IMvCXveu6Jqra7FDD8UBO9V+RphpJITQBbrpuxCxIr8x8iAc/HfAxDqOEwaJun++qmsr2Iw3nA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199018)(36840700001)(40470700004)(46966006)(47076005)(70586007)(4326008)(83380400001)(426003)(336012)(70206006)(7636003)(41300700001)(2616005)(8676002)(8936002)(82310400005)(82740400003)(186003)(26005)(356005)(36756003)(478600001)(107886003)(40460700003)(110136005)(316002)(86362001)(36860700001)(7696005)(40480700001)(2906002)(6666004)(54906003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 14:47:58.1221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e31550-ab63-452c-1f55-08db052c79c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E65A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4217
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move devlink dev eswitch callbacks and related code from leftover.c to
file dev.c. No functional change in this patch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 net/devlink/dev.c           | 120 ++++++++++++++++++++++++++++++++++
 net/devlink/devl_internal.h |   4 ++
 net/devlink/leftover.c      | 127 +-----------------------------------
 3 files changed, 126 insertions(+), 125 deletions(-)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 0d6c14b89d03..4de3dcc42022 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -514,3 +514,123 @@ bool devlink_reload_actions_valid(const struct devlink_ops *ops)
 	}
 	return true;
 }
+
+static int devlink_nl_eswitch_fill(struct sk_buff *msg, struct devlink *devlink,
+				   enum devlink_command cmd, u32 portid,
+				   u32 seq, int flags)
+{
+	const struct devlink_ops *ops = devlink->ops;
+	enum devlink_eswitch_encap_mode encap_mode;
+	u8 inline_mode;
+	void *hdr;
+	int err = 0;
+	u16 mode;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	err = devlink_nl_put_handle(msg, devlink);
+	if (err)
+		goto nla_put_failure;
+
+	if (ops->eswitch_mode_get) {
+		err = ops->eswitch_mode_get(devlink, &mode);
+		if (err)
+			goto nla_put_failure;
+		err = nla_put_u16(msg, DEVLINK_ATTR_ESWITCH_MODE, mode);
+		if (err)
+			goto nla_put_failure;
+	}
+
+	if (ops->eswitch_inline_mode_get) {
+		err = ops->eswitch_inline_mode_get(devlink, &inline_mode);
+		if (err)
+			goto nla_put_failure;
+		err = nla_put_u8(msg, DEVLINK_ATTR_ESWITCH_INLINE_MODE,
+				 inline_mode);
+		if (err)
+			goto nla_put_failure;
+	}
+
+	if (ops->eswitch_encap_mode_get) {
+		err = ops->eswitch_encap_mode_get(devlink, &encap_mode);
+		if (err)
+			goto nla_put_failure;
+		err = nla_put_u8(msg, DEVLINK_ATTR_ESWITCH_ENCAP_MODE, encap_mode);
+		if (err)
+			goto nla_put_failure;
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return err;
+}
+
+int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_eswitch_fill(msg, devlink, DEVLINK_CMD_ESWITCH_GET,
+				      info->snd_portid, info->snd_seq, 0);
+
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	const struct devlink_ops *ops = devlink->ops;
+	enum devlink_eswitch_encap_mode encap_mode;
+	u8 inline_mode;
+	int err = 0;
+	u16 mode;
+
+	if (info->attrs[DEVLINK_ATTR_ESWITCH_MODE]) {
+		if (!ops->eswitch_mode_set)
+			return -EOPNOTSUPP;
+		mode = nla_get_u16(info->attrs[DEVLINK_ATTR_ESWITCH_MODE]);
+		err = devlink_rate_nodes_check(devlink, mode, info->extack);
+		if (err)
+			return err;
+		err = ops->eswitch_mode_set(devlink, mode, info->extack);
+		if (err)
+			return err;
+	}
+
+	if (info->attrs[DEVLINK_ATTR_ESWITCH_INLINE_MODE]) {
+		if (!ops->eswitch_inline_mode_set)
+			return -EOPNOTSUPP;
+		inline_mode = nla_get_u8(info->attrs[DEVLINK_ATTR_ESWITCH_INLINE_MODE]);
+		err = ops->eswitch_inline_mode_set(devlink, inline_mode,
+						   info->extack);
+		if (err)
+			return err;
+	}
+
+	if (info->attrs[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]) {
+		if (!ops->eswitch_encap_mode_set)
+			return -EOPNOTSUPP;
+		encap_mode = nla_get_u8(info->attrs[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]);
+		err = ops->eswitch_encap_mode_set(devlink, encap_mode,
+						  info->extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index cb4a89ac42ec..79165050feea 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -202,6 +202,8 @@ struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
 
 /* Rates */
+int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
+			     struct netlink_ext_ack *extack);
 struct devlink_rate *
 devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
 struct devlink_rate *
@@ -210,3 +212,5 @@ devlink_rate_node_get_from_info(struct devlink *devlink,
 /* Devlink nl cmds */
 int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info);
 int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb, struct genl_info *info);
+int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 703a03d65df7..1fa58e69a7a2 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -2843,85 +2843,8 @@ static int devlink_nl_cmd_sb_occ_max_clear_doit(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
-static int devlink_nl_eswitch_fill(struct sk_buff *msg, struct devlink *devlink,
-				   enum devlink_command cmd, u32 portid,
-				   u32 seq, int flags)
-{
-	const struct devlink_ops *ops = devlink->ops;
-	enum devlink_eswitch_encap_mode encap_mode;
-	u8 inline_mode;
-	void *hdr;
-	int err = 0;
-	u16 mode;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	err = devlink_nl_put_handle(msg, devlink);
-	if (err)
-		goto nla_put_failure;
-
-	if (ops->eswitch_mode_get) {
-		err = ops->eswitch_mode_get(devlink, &mode);
-		if (err)
-			goto nla_put_failure;
-		err = nla_put_u16(msg, DEVLINK_ATTR_ESWITCH_MODE, mode);
-		if (err)
-			goto nla_put_failure;
-	}
-
-	if (ops->eswitch_inline_mode_get) {
-		err = ops->eswitch_inline_mode_get(devlink, &inline_mode);
-		if (err)
-			goto nla_put_failure;
-		err = nla_put_u8(msg, DEVLINK_ATTR_ESWITCH_INLINE_MODE,
-				 inline_mode);
-		if (err)
-			goto nla_put_failure;
-	}
-
-	if (ops->eswitch_encap_mode_get) {
-		err = ops->eswitch_encap_mode_get(devlink, &encap_mode);
-		if (err)
-			goto nla_put_failure;
-		err = nla_put_u8(msg, DEVLINK_ATTR_ESWITCH_ENCAP_MODE, encap_mode);
-		if (err)
-			goto nla_put_failure;
-	}
-
-	genlmsg_end(msg, hdr);
-	return 0;
-
-nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-	return err;
-}
-
-static int devlink_nl_cmd_eswitch_get_doit(struct sk_buff *skb,
-					   struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	struct sk_buff *msg;
-	int err;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	err = devlink_nl_eswitch_fill(msg, devlink, DEVLINK_CMD_ESWITCH_GET,
-				      info->snd_portid, info->snd_seq, 0);
-
-	if (err) {
-		nlmsg_free(msg);
-		return err;
-	}
-
-	return genlmsg_reply(msg, info);
-}
-
-static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
-				    struct netlink_ext_ack *extack)
+int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
+			     struct netlink_ext_ack *extack)
 {
 	struct devlink_rate *devlink_rate;
 
@@ -2933,52 +2856,6 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 	return 0;
 }
 
-static int devlink_nl_cmd_eswitch_set_doit(struct sk_buff *skb,
-					   struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-	const struct devlink_ops *ops = devlink->ops;
-	enum devlink_eswitch_encap_mode encap_mode;
-	u8 inline_mode;
-	int err = 0;
-	u16 mode;
-
-	if (info->attrs[DEVLINK_ATTR_ESWITCH_MODE]) {
-		if (!ops->eswitch_mode_set)
-			return -EOPNOTSUPP;
-		mode = nla_get_u16(info->attrs[DEVLINK_ATTR_ESWITCH_MODE]);
-		err = devlink_rate_nodes_check(devlink, mode, info->extack);
-		if (err)
-			return err;
-		err = ops->eswitch_mode_set(devlink, mode, info->extack);
-		if (err)
-			return err;
-	}
-
-	if (info->attrs[DEVLINK_ATTR_ESWITCH_INLINE_MODE]) {
-		if (!ops->eswitch_inline_mode_set)
-			return -EOPNOTSUPP;
-		inline_mode = nla_get_u8(
-				info->attrs[DEVLINK_ATTR_ESWITCH_INLINE_MODE]);
-		err = ops->eswitch_inline_mode_set(devlink, inline_mode,
-						   info->extack);
-		if (err)
-			return err;
-	}
-
-	if (info->attrs[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]) {
-		if (!ops->eswitch_encap_mode_set)
-			return -EOPNOTSUPP;
-		encap_mode = nla_get_u8(info->attrs[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]);
-		err = ops->eswitch_encap_mode_set(devlink, encap_mode,
-						  info->extack);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 int devlink_dpipe_match_put(struct sk_buff *skb,
 			    struct devlink_dpipe_match *match)
 {
-- 
2.27.0

