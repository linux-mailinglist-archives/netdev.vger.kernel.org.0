Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34E046B76B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbhLGJib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:38:31 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51405 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234237AbhLGJiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:38:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E84E55C0247;
        Tue,  7 Dec 2021 04:34:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Dec 2021 04:34:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=nCqioJeDzR5FPq0DKCyaq33yK27+Y6sGNQGGEDoirTY=; b=kPsAEZx1
        luzI6flBmTjwW5qlda4AbMyh07yYGwWPb2ffGTEzFnsrwrwAIYE9Zk6hslu6RyK+
        nhDaNA/22dzLPu80y3YtOLxLSVREGhO7xWwSZFc7g+p2iZHNUq44RFh7hl9Iw53y
        L39FU5fpzc37BB/NfgChxHyENsdBzD6BdKs8lz/zTlbzy7A0P7AVqAqzDhN3bL69
        pF9b23Abt4sJouiyx11yyowgpa34FU9bUYxq4HGYt41oM0pmOaisTFP4hHQS5An6
        3fs/W94nF3sAnMyG9FIm9hxu5Q+lsaAyQ6gOjC1xk/Nmlvk0KMMOI8GuSmZN/o6R
        PAi5vv5bweKe1g==
X-ME-Sender: <xms:syqvYSD-8DuilGPdV_IcP5IxS9kwSWfJIcstSTirZnU2XXoGxzkIEA>
    <xme:syqvYcgPY1d8SoIAFYdGeOguaYBpZHbJgXYxwq0dCM1sVKy2Xps1HjCTfl_P6Xs-_
    YVqUrDb0S0TmmA>
X-ME-Received: <xmr:syqvYVnAGymwn6bAra8Xynxqz9LilrkbuSZaSRQX0grTNeyaGbAR23EHRC2nl_akmcQfTUNdeVYYnYGWRlmWspJyyTKI9uhRGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjeehgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:syqvYQxIkDRQ0bDuDc_JGrXNMIct-b9j9rVnPbrQoqTV6Y-dkuDWBw>
    <xmx:syqvYXQ5fREkBkhwoAINYhHCrn-rW77PTmGDp2Bi8S0IMX2iXxWYjw>
    <xmx:syqvYbZKxgPDFvS9nyWU5v3IGUOCuEuZzcCAn8-VK1pKWfE19U5ikQ>
    <xmx:syqvYSeBYh6HCiEqWvcV78hmBRaghv9_LrBJhhE4tKv7oMzIKsQ2Hg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Dec 2021 04:34:42 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 2/3] ethtool: Add ability to control transceiver modules' power mode
Date:   Tue,  7 Dec 2021 11:33:58 +0200
Message-Id: <20211207093359.69974-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207093359.69974-1-idosch@idosch.org>
References: <20211207093359.69974-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add ability to control transceiver modules' power mode over netlink.

Example output and usage:

 # ip link set dev swp11 up

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy: high
 power-mode: high

 $ ethtool --json --show-module swp11
 [ {
        "ifname": "swp11",
        "power-mode-policy": "high",
        "power-mode": "high"
    } ]

 # ethtool --set-module swp11 power-mode-policy auto

 $ ethtool --show-module swp11
 Module parameters for swp11:
 power-mode-policy: auto
 power-mode: high

 # ethtool --set-module swp11 power-mode-policy auto

 # ethtool --set-module swp11 power-mode-policy high

Despite three set commands, only two notifications were emitted, as the
kernel only emits notifications when an attribute changes:

 $ ethtool --monitor
 listening...

 Module parameters for swp11:
 power-mode-policy: auto
 power-mode: high

 Module parameters for swp11:
 power-mode-policy: high
 power-mode: high

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Makefile.am                   |   2 +-
 ethtool.8.in                  |  25 +++++
 ethtool.c                     |  12 +++
 netlink/desc-ethtool.c        |  11 +++
 netlink/extapi.h              |   4 +
 netlink/module.c              | 179 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   4 +
 netlink/netlink.h             |   1 +
 shell-completion/bash/ethtool |  23 +++++
 9 files changed, 260 insertions(+), 1 deletion(-)
 create mode 100644 netlink/module.c

diff --git a/Makefile.am b/Makefile.am
index dd357d0a158a..dc5fbec1e09d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -39,7 +39,7 @@ ethtool_SOURCES += \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
 		  netlink/stats.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
-		  netlink/module-eeprom.c \
+		  netlink/module-eeprom.c netlink/module.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
diff --git a/ethtool.8.in b/ethtool.8.in
index d2c7e5c8570e..755c0f788522 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -477,6 +477,14 @@ ethtool \- query or control network driver and hardware settings
 .HP
 .B ethtool \-\-show\-tunnels
 .I devname
+.HP
+.B ethtool \-\-show\-module
+.I devname
+.HP
+.B ethtool \-\-set\-module
+.I devname
+.RB [ power\-mode\-policy
+.BR high | auto ]
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1460,6 +1468,23 @@ Show tunnel-related device capabilities and state.
 List UDP ports kernel has programmed the device to parse as VxLAN,
 or GENEVE tunnels.
 .RE
+.TP
+.B \-\-show\-module
+Show the transceiver module's parameters.
+.RE
+.TP
+.B \-\-set\-module
+Set the transceiver module's parameters.
+.RS 4
+.TP
+.A2 power-mode-policy high auto
+Set the power mode policy for the module. When set to \fBhigh\fR, the module
+always operates at high power mode. When set to \fBauto\fR, the module is
+transitioned by the host to high power mode when the first port using it is put
+administratively up and to low power mode when the last port using it is put
+administratively down. The power mode policy can be set before a module is
+plugged-in.
+.RE
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
diff --git a/ethtool.c b/ethtool.c
index 064bc697926e..55dac510f820 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6038,6 +6038,18 @@ static const struct option args[] = {
 		.nlfunc	= nl_gtunnels,
 		.help	= "Show NIC tunnel offload information",
 	},
+	{
+		.opts	= "--show-module",
+		.json	= true,
+		.nlfunc	= nl_gmodule,
+		.help	= "Show transceiver module settings",
+	},
+	{
+		.opts	= "--set-module",
+		.nlfunc	= nl_smodule,
+		.help	= "Set transceiver module settings",
+		.xhelp	= "		[ power-mode-policy high|auto ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 69f6561f4a64..2b27c3296e48 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -392,6 +392,13 @@ static const struct pretty_nla_desc __phc_vclocks_desc[] = {
 	NLATTR_DESC_BINARY(ETHTOOL_A_PHC_VCLOCKS_INDEX),
 };
 
+static const struct pretty_nla_desc __module_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MODULE_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MODULE_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_POWER_MODE_POLICY),
+	NLATTR_DESC_U8(ETHTOOL_A_MODULE_POWER_MODE),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -427,6 +434,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET, stats),
 	NLMSG_DESC(ETHTOOL_MSG_PHC_VCLOCKS_GET, phc_vclocks),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -467,6 +476,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY, module_eeprom),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET_REPLY, stats),
 	NLMSG_DESC(ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY, phc_vclocks),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 129e2931d01d..1bb580a889a8 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -43,6 +43,8 @@ int nl_gfec(struct cmd_context *ctx);
 int nl_sfec(struct cmd_context *ctx);
 bool nl_gstats_chk(struct cmd_context *ctx);
 int nl_gstats(struct cmd_context *ctx);
+int nl_gmodule(struct cmd_context *ctx);
+int nl_smodule(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
 
@@ -110,6 +112,8 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_gstats_chk		NULL
 #define nl_gstats		NULL
 #define nl_getmodule		NULL
+#define nl_gmodule		NULL
+#define nl_smodule		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/module.c b/netlink/module.c
new file mode 100644
index 000000000000..54aa6d09722a
--- /dev/null
+++ b/netlink/module.c
@@ -0,0 +1,179 @@
+/*
+ * module.c - netlink implementation of module commands
+ *
+ * Implementation of "ethtool --show-module <dev>" and
+ * "ethtool --set-module <dev> ..."
+ */
+
+#include <errno.h>
+#include <ctype.h>
+#include <inttypes.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "parser.h"
+
+/* MODULE_GET */
+
+static const char *module_power_mode_policy_name(u8 val)
+{
+	switch (val) {
+	case ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH:
+		return "high";
+	case ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO:
+		return "auto";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *module_power_mode_name(u8 val)
+{
+	switch (val) {
+	case ETHTOOL_MODULE_POWER_MODE_LOW:
+		return "low";
+	case ETHTOOL_MODULE_POWER_MODE_HIGH:
+		return "high";
+	default:
+		return "unknown";
+	}
+}
+
+int module_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MODULE_MAX + 1] = {};
+	struct nl_context *nlctx = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_MODULE_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "Module parameters for %s:\n",
+		     nlctx->devname);
+
+	if (tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]) {
+		u8 val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE_POLICY]);
+		print_string(PRINT_ANY, "power-mode-policy",
+			     "power-mode-policy: %s\n",
+			     module_power_mode_policy_name(val));
+	}
+
+	if (tb[ETHTOOL_A_MODULE_POWER_MODE]) {
+		u8 val;
+
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_POWER_MODE]);
+		print_string(PRINT_ANY, "power-mode",
+			     "power-mode: %s\n", module_power_mode_name(val));
+	}
+
+	close_json_object();
+
+	return MNL_CB_OK;
+}
+
+int nl_gmodule(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	nlsk = nlctx->ethnl_socket;
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_MODULE_GET,
+				      ETHTOOL_A_MODULE_HEADER, 0);
+	if (ret < 0)
+		return ret;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, module_reply_cb);
+	delete_json_obj();
+	return ret;
+}
+
+/* MODULE_SET */
+
+static const struct lookup_entry_u8 power_mode_policy_values[] = {
+	{ .arg = "high",	.val = ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH },
+	{ .arg = "auto",	.val = ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO },
+	{}
+};
+
+static const struct param_parser smodule_params[] = {
+	{
+		.arg		= "power-mode-policy",
+		.type		= ETHTOOL_A_MODULE_POWER_MODE_POLICY,
+		.handler	= nl_parse_lookup_u8,
+		.handler_data	= power_mode_policy_values,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_smodule(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_SET, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr, "ethtool (--set-module): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "--set-module";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_MODULE_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_MODULE_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, smodule_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
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
index 0c4df9e78ee3..d631907817e2 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -71,6 +71,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_FEC_NTF,
 		.cb	= fec_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_NTF,
+		.cb	= module_reply_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 70fa666b20e5..f43c1bff6a58 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -91,6 +91,7 @@ int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int module_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
diff --git a/shell-completion/bash/ethtool b/shell-completion/bash/ethtool
index 45573413985d..46334b525e2b 100644
--- a/shell-completion/bash/ethtool
+++ b/shell-completion/bash/ethtool
@@ -1137,6 +1137,27 @@ _ethtool_test()
 	fi
 }
 
+# Completion for ethtool --set-module
+_ethtool_set_module()
+{
+	local -A settings=(
+		[power-mode-policy]=1
+	)
+
+	case "$prev" in
+		power-mode-policy)
+			COMPREPLY=( $( compgen -W 'high auto' -- "$cur" ) )
+			return ;;
+	esac
+
+	# Remove settings which have been seen
+	local word
+	for word in "${words[@]:3:${#words[@]}-4}"; do
+		unset "settings[$word]"
+	done
+
+	COMPREPLY=( $( compgen -W "${!settings[*]}" -- "$cur" ) )
+}
 
 # Complete any ethtool command
 _ethtool()
@@ -1189,6 +1210,8 @@ _ethtool()
 		[--show-time-stamping]=devname
 		[--statistics]=devname
 		[--test]=test
+		[--set-module]=set_module
+		[--show-module]=devname
 	)
 	local -A other_funcs=(
 		[--config-ntuple]=config_nfc
-- 
2.31.1

