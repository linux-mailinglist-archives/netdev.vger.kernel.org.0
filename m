Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C2C641A7B
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLDCkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLDCkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:40:04 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA71180A;
        Sat,  3 Dec 2022 18:40:02 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qk9so2330187ejc.3;
        Sat, 03 Dec 2022 18:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KGd5LpCKZo9NoOS5phY6+jbNL3TjfFQ5CGWt9wHy6Tk=;
        b=o5/I6R1mkotGC/7492XSDrYAHLFkD8v17/1A1EwSMytIjR423IV7bDM+gOpcxDM/rn
         zUOtYXXAO01u621hc2/ew19d1nz6Hxh/Q/jMuVgG0PDU5QvHyp9wQiYnxzECvCmcC//y
         mLl9fIKCwEqpSGVnx43QmnW325wpRRv9YFEEwy9FfZOPS4bvhsYFwM35qnfCyCbPnlMY
         OqPpjMjnr9/wvpYgXnBMY5DmtrwvW242pT0JQuRxzE1d9BhVqc8PpNv8tQDuiFaPFy9H
         2x+AdsdJDzoz+kOnOOKdyWz7ayEv1PuUkKwSoOG9eGlO0Bs9dT5iJgLTmzm1I5y4LkhW
         4JYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGd5LpCKZo9NoOS5phY6+jbNL3TjfFQ5CGWt9wHy6Tk=;
        b=p8N5oES3NJfM2GpyCmxSWZ1BZSCC8vVoGiyJwS9UhlXMfcsY/bsfrLycBHdnW5ZQqK
         wXJxeXsVj6h82Pe+h2xP0FIjTTjLMlSJ7bCLZuhI+GHB7gviqHYAdxmQ/ZKHVmksfEZ1
         P8eXzpp7lzUy+bLWIt2dlQTOb4muY2TK2GzV7qFH+0M9lemZ33ufc85z1FMj/fYSyTd7
         7GQxGoKCKUsv8OqJG75LNYALAMDvwqf6jfvdGVBhRNbeyY+JT5ucWTosHz9AceoKbdNR
         mzL/2nnzUYToyV3cxKwzIVDYApsp2eQXoPthxmkZsSAbD3Iq+Trm6BFOsIpLzM2IL9Ah
         b1ew==
X-Gm-Message-State: ANoB5pmydQ6tlE3pUoOUv8L/dbUbPJp924TppJs47Z7LgNTay2HYHk8e
        S1kMFZUJ54t+K/SzWF9vb8c=
X-Google-Smtp-Source: AA0mqf7VeJ4H9JkHGYfDcgGcwiUC80PUweq09/AnMMrga2U1TZfMCXrH4qYioOw7CWV6szN85BXT8g==
X-Received: by 2002:a17:907:a489:b0:7c0:c14f:73d7 with SMTP id vp9-20020a170907a48900b007c0c14f73d7mr7634062ejc.52.1670121600855;
        Sat, 03 Dec 2022 18:40:00 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id v21-20020a170906859500b007aea1dc1840sm4762625ejx.111.2022.12.03.18.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 18:40:00 -0800 (PST)
Date:   Sun, 4 Dec 2022 03:40:08 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 2/2] ethtool: Add support for IEEE 802.3cg-2019
 Clause 148 - PLCA RS
Message-ID: <8929b2dbbca7d29573d604ffcd6e7c1cd5760894.1670121214.git.piergiorgio.beruto@gmail.com>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the Physical Layer Collision Avoidance
Reconciliation Sublayer which was introduced in the IEEE 802.3 standard
by the 802.3cg working group in 2019.

The ethtool interface has been extended as follows:
- show if the device supports PLCA when ethtool is invoked without FLAGS
   - additionally show what PLCA version is supported
   - show the current PLCA status
- add FLAGS for getting and setting the PLCA configuration

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 Makefile.am        |   1 +
 ethtool.c          |  21 +++
 netlink/extapi.h   |   6 +
 netlink/plca.c     | 311 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/settings.c |  86 ++++++++++++-
 5 files changed, 424 insertions(+), 1 deletion(-)
 create mode 100644 netlink/plca.c

diff --git a/Makefile.am b/Makefile.am
index fcc912edd7e4..b184b8ceb28a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -41,6 +41,7 @@ ethtool_SOURCES += \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/module-eeprom.c netlink/module.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
+		  netlink/plca.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/ethtool.c b/ethtool.c
index 3207e49137c4..d23406f54a37 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6075,6 +6075,27 @@ static const struct option args[] = {
 		.help	= "Set transceiver module settings",
 		.xhelp	= "		[ power-mode-policy high|auto ]\n"
 	},
+	{
+		.opts	= "--get-plca-cfg",
+		.nlfunc	= nl_plca_get_cfg,
+		.help	= "Get PLCA configuration",
+	},
+	{
+		.opts	= "--set-plca-cfg",
+		.nlfunc	= nl_plca_set_cfg,
+		.help	= "Set PLCA configuration",
+		.xhelp  = "             [ enable on|off ]\n"
+			  "             [ node-id N ]\n"
+			  "             [ node-cnt N ]\n"
+			  "             [ to-tmr N ]\n"
+			  "             [ burst-cnt N ]\n"
+			  "             [ burst-tmr N ]\n"
+	},
+	{
+		.opts	= "--get-plca-status",
+		.nlfunc	= nl_plca_get_status,
+		.help	= "Get PLCA status information",
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 1bb580a889a8..0add156e644a 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -47,6 +47,9 @@ int nl_gmodule(struct cmd_context *ctx);
 int nl_smodule(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
+int nl_plca_get_cfg(struct cmd_context *ctx);
+int nl_plca_set_cfg(struct cmd_context *ctx);
+int nl_plca_get_status(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -114,6 +117,9 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_getmodule		NULL
 #define nl_gmodule		NULL
 #define nl_smodule		NULL
+#define nl_get_plca_cfg		NULL
+#define nl_set_plca_cfg		NULL
+#define nl_get_plca_status	NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/plca.c b/netlink/plca.c
new file mode 100644
index 000000000000..19818598ec55
--- /dev/null
+++ b/netlink/plca.c
@@ -0,0 +1,311 @@
+/*
+ * plca.c - netlink implementation of plca command
+ *
+ * Implementation of "ethtool --show-plca <dev>" and
+ * "ethtool --set-plca <dev> ..."
+ */
+
+#include <errno.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "bitset.h"
+#include "parser.h"
+
+/* PLCA_GET_CFG */
+
+int plca_get_cfg_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PLCA_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	bool silent;
+	int err_ret;
+	u8 id = 255;
+	int ret;
+	u8 val;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PLCA_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+
+	printf("PLCA settings for %s:\n", nlctx->devname);
+
+	// check if PLCA is enabled
+	printf("\tEnabled: ");
+
+	if (!tb[ETHTOOL_A_PLCA_ENABLED]) {
+		printf("not supported");
+	}
+	else {
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_ENABLED]);
+		printf(val ? "Yes" : "No");
+	}
+	putchar('\n');
+
+	// get node ID
+	printf("\tlocal node ID: ");
+
+	if (!tb[ETHTOOL_A_PLCA_NODE_ID]) {
+		printf("not supported");
+	}
+	else {
+		id = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_NODE_ID]);
+		printf("%u (%s)", (unsigned int)id,
+		       id == 0 ? "coordinator" :
+		       id == 255 ? "unconfigured" : "follower");
+	}
+	putchar('\n');
+
+	// get node count
+	printf("\tNode count: ");
+	if (!tb[ETHTOOL_A_PLCA_NODE_CNT]) {
+		printf("not supported");
+	}
+	else {
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_NODE_CNT]);
+		printf("%u", (unsigned int)val);
+
+		// The node count is ignored by follower nodes. However, it can
+		// be pre-set to enable fast coordinator role switchover.
+		// Therefore, on a follower node we still wanto to show it,
+		// indicating it is not currently used.
+		if (tb[ETHTOOL_A_PLCA_NODE_ID] && id != 0)
+			printf(" (ignored)");
+	}
+	putchar('\n');
+
+	// get TO timer (transmit opportunity timer)
+	printf("\tTO timer: ");
+	if (!tb[ETHTOOL_A_PLCA_TO_TMR]) {
+		printf("not supported");
+	}
+	else {
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_TO_TMR]);
+		printf("%u BT", (unsigned int) val);
+	}
+	putchar('\n');
+
+	// get burst count
+	printf("\tBurst count: ");
+	if (!tb[ETHTOOL_A_PLCA_BURST_CNT]) {
+		printf("not supported");
+	}
+	else {
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_BURST_CNT]);
+		printf("%u (%s)", (unsigned int) val,
+		       val > 0 ? "enabled" : "disabled");
+	}
+	putchar('\n');
+
+	// get burst timer
+	printf("\tBurst timer: ");
+	if (!tb[ETHTOOL_A_PLCA_BURST_TMR]) {
+		printf("not supported");
+	}
+	else {
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_BURST_TMR]);
+		printf("%u BT", (unsigned int) val);
+	}
+	putchar('\n');
+
+	return MNL_CB_OK;
+}
+
+
+int nl_plca_get_cfg(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_CFG, true))
+		return -EOPNOTSUPP;
+
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(
+				      nlsk,
+				      ETHTOOL_MSG_PLCA_GET_CFG,
+				      ETHTOOL_A_PLCA_HEADER,
+				      0
+				     );
+
+	if (ret < 0)
+		return ret;
+
+	return nlsock_send_get_request(nlsk, plca_get_cfg_reply_cb);
+}
+
+/* PLCA_SET_CFG */
+
+static const struct param_parser set_plca_params[] = {
+	{
+		.arg		= "enable",
+		.type		= ETHTOOL_A_PLCA_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "node-id",
+		.type		= ETHTOOL_A_PLCA_NODE_ID,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "node-cnt",
+		.type		= ETHTOOL_A_PLCA_NODE_CNT,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "to-tmr",
+		.type		= ETHTOOL_A_PLCA_TO_TMR,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "burst-cnt",
+		.type		= ETHTOOL_A_PLCA_BURST_CNT,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "burst-tmr",
+		.type		= ETHTOOL_A_PLCA_BURST_TMR,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_plca_set_cfg(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_SET_CFG, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr,
+			"ethtool (--set-plca-cfg): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "--set-plca-cfg";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_PLCA_SET_CFG,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_PLCA_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, set_plca_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return 76;
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret == 0)
+		return 0;
+	else
+		return nlctx->exit_code ?: 76;
+}
+
+/* PLCA_GET_STATUS */
+
+int plca_get_status_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PLCA_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	bool silent;
+	int err_ret;
+	int ret;
+	u8 val;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PLCA_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+
+	printf("PLCA status of %s:\n", nlctx->devname);
+
+	// check whether the Open Alliance TC14 standard memory map is supported
+	printf("\tStatus: ");
+
+	if (!tb[ETHTOOL_A_PLCA_STATUS]) {
+		printf("not supported");
+	}
+	else {
+		val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_STATUS]);
+		printf(val ? "on" : "off");
+	}
+	putchar('\n');
+
+	return MNL_CB_OK;
+}
+
+
+int nl_plca_get_status(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_STATUS, true))
+		return -EOPNOTSUPP;
+
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	ret = nlsock_prep_get_request(
+				      nlsk,
+				      ETHTOOL_MSG_PLCA_GET_STATUS,
+				      ETHTOOL_A_PLCA_HEADER,
+				      0
+				     );
+
+	if (ret < 0)
+		return ret;
+
+	return nlsock_send_get_request(nlsk, plca_get_status_reply_cb);
+}
diff --git a/netlink/settings.c b/netlink/settings.c
index ea86e365383b..25c5e7848fb7 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -165,6 +165,9 @@ static const struct link_mode_info link_modes[] = {
 	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
 	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
 	[ETHTOOL_LINK_MODE_10baseT1L_Full_BIT]		= __REAL(10),
+	[ETHTOOL_LINK_MODE_10baseT1S_Full_BIT]		= __REAL(10),
+	[ETHTOOL_LINK_MODE_10baseT1S_Half_BIT]		= __REAL(10),
+	[ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT]	= __REAL(10),
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
@@ -882,6 +885,75 @@ int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
+int plca_cfg_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PLCA_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PLCA_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	print_banner(nlctx);
+	printf("\tPLCA support: ");
+
+	if (tb[ETHTOOL_A_PLCA_VERSION]) {
+		uint16_t val = mnl_attr_get_u16(tb[ETHTOOL_A_PLCA_VERSION]);
+		if ((val >> 8) == 0x0A) {
+			printf("OPEN Alliance v%u.%u",
+			       (unsigned int)((val >> 4) & 0xF),
+			       (unsigned int)(val & 0xF)
+			);
+		}
+		else
+			printf("unknown standard");
+	}
+	else
+		printf("non-standard");
+
+	printf("\n");
+
+	return MNL_CB_OK;
+}
+
+int plca_status_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_PLCA_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	int ret;
+
+	if (nlctx->is_dump || nlctx->is_monitor)
+		nlctx->no_banner = false;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_PLCA_HEADER]);
+	if (!dev_ok(nlctx))
+		return MNL_CB_OK;
+
+	print_banner(nlctx);
+	printf("\tPLCA status: ");
+
+	if (tb[ETHTOOL_A_PLCA_STATUS]) {
+		uint8_t val = mnl_attr_get_u8(tb[ETHTOOL_A_PLCA_STATUS]);
+		printf(val ? "up" : "down");
+	}
+	else
+		printf("unknown");
+
+	printf("\n");
+
+	return MNL_CB_OK;
+}
+
 static int gset_request(struct nl_socket *nlsk, uint8_t msg_type,
 			uint16_t hdr_attr, mnl_cb_t cb)
 {
@@ -903,7 +975,9 @@ int nl_gset(struct cmd_context *ctx)
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKINFO_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_WOL_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_DEBUG_GET, true) ||
-	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true))
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_CFG, true) ||
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_STATUS, true))
 		return -EOPNOTSUPP;
 
 	nlctx->suppress_nlerr = 1;
@@ -923,6 +997,11 @@ int nl_gset(struct cmd_context *ctx)
 	if (ret == -ENODEV)
 		return ret;
 
+	ret = gset_request(nlsk, ETHTOOL_MSG_PLCA_GET_CFG,
+			   ETHTOOL_A_PLCA_HEADER, plca_cfg_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
 	ret = gset_request(nlsk, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
 			   debug_reply_cb);
 	if (ret == -ENODEV)
@@ -933,6 +1012,11 @@ int nl_gset(struct cmd_context *ctx)
 	if (ret == -ENODEV)
 		return ret;
 
+	ret = gset_request(nlsk, ETHTOOL_MSG_PLCA_GET_STATUS,
+			   ETHTOOL_A_PLCA_HEADER, plca_status_reply_cb);
+	if (ret == -ENODEV)
+		return ret;
+
 	if (!nlctx->no_banner) {
 		printf("No data available\n");
 		return 75;
-- 
2.35.1

