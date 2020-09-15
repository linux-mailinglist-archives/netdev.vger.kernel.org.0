Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B41726A11B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIOIm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:42:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34513 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgIOIl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3056D5C00EC;
        Tue, 15 Sep 2020 04:41:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ll6vjQlzKnuXrvHsq4V8jvRjvN6aV/Ru86IAFfMNtHw=; b=Aq5kPe08
        XwBta5wQq7MIja06tTOyiYRt9sAMGlAqpBReYYIj7XJfOTyka28N8brwNxfh9K0M
        ypPEI4biRxXnTvyspAWOQGjRCrCrpimAjTVAmpNIrlPD8u4yYIl0vPTijYQZZqtz
        XuwJVScg+wBIX75naxfVZzeyOU5P5hZ9Vg8eCd0kh0yXaB4Qaca9jEXPt+BlJCVn
        M3BcmnXhGIJhJqfSjCFureo/hwizB0xAksvMwtdRuK5aRgDFif8AAME6L6GUNar4
        9B0hD3LGOVzNaevVyNisl6qL/X/sF2nXrLTdAyENZPQzqxeoIedJBoZWOVgLCjQN
        /XQ2RviWI2FMoA==
X-ME-Sender: <xms:VH5gX_zfD8eie-iouEwtxXnaDGQSf5m0qyVz1AaGRWrJamBsIyHQwA>
    <xme:VH5gX3TiRFHAhEwemFMKd7j_OIa5fwtHkUs5tPga7mPfffdXB8dWa-IyLUYBm6GGQ
    Nefg-IcEHixI5U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VH5gX5X7GNC6rUfqv2l1xgby2d9x38O_gGnJ8sRMPYqUoEFzEx7cWw>
    <xmx:VH5gX5ho6nTzZnqYSlakaoSgHPcjSR5_5JzuF1cRCd6CZEdQ2MZo9A>
    <xmx:VH5gXxDdKtpySKDBE6ySY-DSPRd9ZT1pMzbZG9HIQs0JNIVtZYbB_A>
    <xmx:VH5gX0N87l5GR7_k1hmIALCr8AS4GVER-uRqCpEDQ0iXatepoLe4Aw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C0013064674;
        Tue, 15 Sep 2020 04:41:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] devlink: introduce the health reporter test command
Date:   Tue, 15 Sep 2020 11:40:57 +0300
Message-Id: <20200915084058.18555-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce a test command for health reporters. User might use this
command to trigger test event on a reporter if the reporter supports it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/devlink.h        |  3 +++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 30 ++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index eaec0a8cc5ef..48b1c1ef1ebd 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -566,6 +566,7 @@ enum devlink_health_reporter_state {
  * @dump: callback to dump an object
  *        if priv_ctx is NULL, run a full dump
  * @diagnose: callback to diagnose the current status
+ * @test: callback to trigger a test event
  */
 
 struct devlink_health_reporter_ops {
@@ -578,6 +579,8 @@ struct devlink_health_reporter_ops {
 	int (*diagnose)(struct devlink_health_reporter *reporter,
 			struct devlink_fmsg *fmsg,
 			struct netlink_ext_ack *extack);
+	int (*test)(struct devlink_health_reporter *reporter,
+		    struct netlink_ext_ack *extack);
 };
 
 /**
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 40d35145c879..631f5bdf1707 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -122,6 +122,8 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_POLICER_NEW,
 	DEVLINK_CMD_TRAP_POLICER_DEL,
 
+	DEVLINK_CMD_HEALTH_REPORTER_TEST,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 19037f114307..e5b71f3c2d4d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6096,6 +6096,28 @@ devlink_nl_cmd_health_reporter_dump_clear_doit(struct sk_buff *skb,
 	return 0;
 }
 
+static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
+						    struct genl_info *info)
+{
+	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_health_reporter *reporter;
+	int err;
+
+	reporter = devlink_health_reporter_get_from_info(devlink, info);
+	if (!reporter)
+		return -EINVAL;
+
+	if (!reporter->ops->test) {
+		devlink_health_reporter_put(reporter);
+		return -EOPNOTSUPP;
+	}
+
+	err = reporter->ops->test(reporter, info->extack);
+
+	devlink_health_reporter_put(reporter);
+	return err;
+}
+
 struct devlink_stats {
 	u64 rx_bytes;
 	u64 rx_packets;
@@ -7316,6 +7338,14 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
 				  DEVLINK_NL_FLAG_NO_LOCK,
 	},
+	{
+		.cmd = DEVLINK_CMD_HEALTH_REPORTER_TEST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_health_reporter_test_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
+				  DEVLINK_NL_FLAG_NO_LOCK,
+	},
 	{
 		.cmd = DEVLINK_CMD_FLASH_UPDATE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.26.2

