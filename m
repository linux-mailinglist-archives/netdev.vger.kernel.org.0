Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927653E43E6
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhHIKYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:24:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54925 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234976AbhHIKX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E4975C0138;
        Mon,  9 Aug 2021 06:23:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Aug 2021 06:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/SVGRk5A5D/WNdcvmfXOa/VJ/qiTj0m3ow5WRexfQ/8=; b=G72lk1qO
        qDJAnFEhkic/aSS/wJt6ayuwGCh6B0rUojd73SuGIjPT/hmcTl0B2+vhHbbpmrO1
        III9dNrJ/a+qF1TgukyW/Y3KCwW0JVWf0zwqF3sGGN217SRtOKobO/9WdrGiLg0a
        pRybxgUtoSWV0ISqDWlwFAjCWYUUUOsAdxDey4OZmbBGPDYWV79JgwBEmCwUN4DE
        cYhg+/CNtyZ3HMZQ/nHs37ViOdhEIdRwH0Abo+asvLAKuoFfYdQmuQKa5XC3CSAy
        Y4fIXGHqoM8zW+FU9ilQHMRF1HE0jzHDY+U+r7tcl2FIysCTPuns3g6i2U586+iQ
        oZImFeBFkale1A==
X-ME-Sender: <xms:JwIRYTZFPZlZLNjKwiRwHJRaZ95_9FYPMhbnNS-s0gZ5D3TvAjHzLw>
    <xme:JwIRYSYYAzXb6NyvQea48xa6XB3Q6iJfNh3VRixU-RpdloenzdKefASKklhhos0Y9
    UoCy6jq4cfvSV8>
X-ME-Received: <xmr:JwIRYV_Ea4iYMqSE-dzvzDfn2J5iGw5BQEnFU37O6sy6MeuFfe7EPLuwURdalGsb3Iz9SKyMCHiyd422lQaoGfqSkkP0ioX8SK7LQ-QAdfDaeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JwIRYZpix5bwEY_ECTduWeaUfzhntqKyRbkoQUO8N_1lP91zav6Mew>
    <xmx:JwIRYeobtwNW_ofoT_XTD6hcBRPE2UeVpApCXOuBSCCvRt5sMVNzXw>
    <xmx:JwIRYfS6qUAZtZO7tT65WfXHtWJyN2Rj38jT2pZdmaqYv21vY5w7Aw>
    <xmx:KAIRYfdj_qqd2dIEt6u6VlndMVMtYAb7tryy4ozeEfsf7u5OTsAm_Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 6/6] ethtool: Add ability to reset transceiver modules
Date:   Mon,  9 Aug 2021 13:22:56 +0300
Message-Id: <20210809102256.720119-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102256.720119-1-idosch@idosch.org>
References: <20210809102256.720119-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add ability to reset transceiver modules over netlink.

Example usage:

 # ethtool --reset-module swp11

 $ ethtool --monitor
 listening...

 Module reset done for swp11

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ethtool.8.in                  |  9 ++++++
 ethtool.c                     |  5 ++++
 netlink/desc-ethtool.c        |  2 ++
 netlink/extapi.h              |  2 ++
 netlink/module.c              | 52 +++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |  4 +++
 netlink/netlink.h             |  1 +
 shell-completion/bash/ethtool |  1 +
 8 files changed, 76 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index f9d901cdefca..9953289758d4 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -482,6 +482,9 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool \-\-set\-module
 .I devname
 .B2 low-power on off
+.HP
+.B ethtool \-\-reset\-module
+.I devname
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1473,6 +1476,12 @@ Set the transceiver module's parameters.
 .A2 low-power on off
 Enable / disable forcing of low power mode by the host.
 .RE
+.TP
+.B \-\-reset\-module
+Reset the transceiver module to its initial state. Reset is performed by either
+asserting the relevant hardware signal or by writing to the module's reset bit
+in its EEPROM.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 89ff03b18fbf..0ce574b62692 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6031,6 +6031,11 @@ static const struct option args[] = {
 		.help	= "Set transceiver module settings",
 		.xhelp	= "		[ low-power on|off ]\n"
 	},
+	{
+		.opts	= "--reset-module",
+		.nlfunc	= nl_reset_module,
+		.help	= "Reset transceiver module",
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 3fb31b28f288..fce065fce3ae 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -416,6 +416,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_RESET_ACT, module),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -457,6 +458,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY, module_eeprom),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_RESET_NTF, module),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 2ab4c6bc2f8d..6c294d9058ce 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -45,6 +45,7 @@ bool nl_gstats_chk(struct cmd_context *ctx);
 int nl_gstats(struct cmd_context *ctx);
 int nl_gmodule(struct cmd_context *ctx);
 int nl_smodule(struct cmd_context *ctx);
+int nl_reset_module(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
 
@@ -103,6 +104,7 @@ static inline void nl_monitor_usage(void)
 #define nl_getmodule		NULL
 #define nl_gmodule		NULL
 #define nl_smodule		NULL
+#define nl_reset_module		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/module.c b/netlink/module.c
index 59a149075f0f..ae5423ff92f6 100644
--- a/netlink/module.c
+++ b/netlink/module.c
@@ -137,3 +137,55 @@ int nl_smodule(struct cmd_context *ctx)
 	else
 		return nlctx->exit_code ?: 83;
 }
+
+/* MODULE_RESET_ACT */
+
+int module_reset_ntf_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MODULE_MAX + 1] = {};
+	struct nl_context *nlctx = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	int ret;
+
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return MNL_CB_OK;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_MODULE_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	printf("\nModule reset done for %s\n", nlctx->devname);
+
+	return MNL_CB_OK;
+}
+
+int nl_reset_module(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_RESET_ACT, false))
+		return -EOPNOTSUPP;
+
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_MODULE_RESET_ACT,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_MODULE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 83;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 83;
+}
diff --git a/netlink/monitor.c b/netlink/monitor.c
index d631907817e2..e850c3d72108 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -75,6 +75,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_MODULE_NTF,
 		.cb	= module_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_RESET_NTF,
+		.cb	= module_reset_ntf_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index f43c1bff6a58..1e49d7f2bab3 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -92,6 +92,7 @@ int cable_test_tdr_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int module_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int module_reset_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
diff --git a/shell-completion/bash/ethtool b/shell-completion/bash/ethtool
index 5db3b4f50232..8818985f1cd9 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -1211,6 +1211,7 @@ _ethtool()
 		[--test]=test
 		[--set-module]=set_module
 		[--show-module]=devname
+		[--reset-module]=devname
 	)
 	local -A other_funcs=(
 		[--config-ntuple]=config_nfc
-- 
2.31.1

