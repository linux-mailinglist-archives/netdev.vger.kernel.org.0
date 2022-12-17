Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79F64F693
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiLQAwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiLQAve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:51:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20102DDB;
        Fri, 16 Dec 2022 16:50:42 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a16so5837958edb.9;
        Fri, 16 Dec 2022 16:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S0skL65OaO9gjbkjvlPH5KjvN9AR9I2NEJv0ewBhF0s=;
        b=HACALePnQgwM9kIMhvd61ExKv806V+P6dqzb5XF9iqoh05XKL0pTQ99ayThM3VKY6F
         KKHuY+Z1ie4Rri/8NFmIcM9mclmqJ3qLwjhNm+/Mn3w5sxq+lpdYwL1HTR1VRMXihZgl
         Ov56YJESouLvDdHMu29BkWj+diKliJXEXwJ3z8wp+Ovtr4pELHMdyWruFk8mSwPZQGsS
         bK6/sj49bKavvvkvv9d7UkJLcX5M1XcyMPN2x0uc/v46kGxvjpKsjyTG6ccxTlA7humx
         HVFv3td4oY3ZRqe6wE/g6K7+2dWi/CuPpfujS2+9gno1Own/j3vhOikkyLTeaxdl9N3G
         jsig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S0skL65OaO9gjbkjvlPH5KjvN9AR9I2NEJv0ewBhF0s=;
        b=4uDhqAI+D664Cqnf9QOmCKfxhi2MuwMgfGafuNmRqqEp64M2FmEBPi1+O2noYjQq7y
         uCBzESn7e5ossGe3zaCa46RSh0dDR/4iFCUFD5HMz1h6CIQneJHmSeWIAuuPJLiwDPIR
         F04tyRtv6rVItWS3BnO7Nv8DnUb6mOp1Ojs426Qa3LqL016H9EGmXw/liUAIrIWakETN
         GNX2lQj2l2p0ntVr8bwE9tWRr/Owj+45Pay9V5c0/QKDo6qOvAr9GdGpBt+BxMJKfZ2b
         8u8Fm1OOS4B1lOjdgkFoHfXpdN405xCvBjSQqgPrb/OOeHBvbnMzjmAQiPIW+mDZB5Rx
         m1+w==
X-Gm-Message-State: ANoB5pleFKEf7JD5Ewvuay/VptUMzUDGEq98QIqGjssiLU4a6ubwZSOH
        t3zJ0Sqh1dS9FekTLPjUXUg=
X-Google-Smtp-Source: AA0mqf5cplFdyLfoxVBrt9WBfwmU3SGbWmbo41fqCEcgMMaaIYDa8xsYo5Omuthkl3mF8N2zeuKBvg==
X-Received: by 2002:aa7:cf0c:0:b0:470:410a:8ea7 with SMTP id a12-20020aa7cf0c000000b00470410a8ea7mr27866246edy.18.1671238241105;
        Fri, 16 Dec 2022 16:50:41 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id b4-20020aa7d484000000b0046267f8150csm1419543edr.19.2022.12.16.16.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 16:50:40 -0800 (PST)
Date:   Sat, 17 Dec 2022 01:50:39 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v4 ethtool-next 2/2] add support for IEEE 802.3cg-2019 Clause
 148 - PLCA RS
Message-ID: <1ddabd3850c3f3aea4b2ce840a053f0e917803ba.1671236216.git.piergiorgio.beruto@gmail.com>
References: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
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
Reconciliation Sublayer which was introduced in the IEEE 802.3
standard by the 802.3cg working group in 2019.

The ethtool interface has been extended as follows:
- show if the device supports PLCA when ethtool is invoked without FLAGS
   - additionally show what PLCA version is supported
   - show the current PLCA status
- add FLAGS for getting and setting the PLCA configuration

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 Makefile.am        |   1 +
 ethtool.c          |  21 ++++
 netlink/extapi.h   |   6 +
 netlink/plca.c     | 295 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/settings.c |  86 ++++++++++++-
 5 files changed, 407 insertions(+), 2 deletions(-)
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
index 000000000000..f7d7bdbc5c84
--- /dev/null
+++ b/netlink/plca.c
@@ -0,0 +1,295 @@
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
+	int idv, val;
+	int err_ret;
+	int ret;
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
+	} else {
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
+	} else {
+		idv = mnl_attr_get_u32(tb[ETHTOOL_A_PLCA_NODE_ID]);
+		printf("%u (%s)", idv,
+		       idv == 0 ? "coordinator" :
+		       idv == 255 ? "unconfigured" : "follower");
+	}
+	putchar('\n');
+
+	// get node count
+	printf("\tNode count: ");
+	if (!tb[ETHTOOL_A_PLCA_NODE_CNT]) {
+		printf("not supported");
+	} else {
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_PLCA_NODE_CNT]);
+		printf("%u", val);
+
+		// The node count is ignored by follower nodes. However, it can
+		// be pre-set to enable fast coordinator role switchover.
+		// Therefore, on a follower node we still wanto to show it,
+		// indicating it is not currently used.
+		if (tb[ETHTOOL_A_PLCA_NODE_ID] && idv != 0)
+			printf(" (ignored)");
+	}
+	putchar('\n');
+
+	// get TO timer (transmit opportunity timer)
+	printf("\tTO timer: ");
+	if (!tb[ETHTOOL_A_PLCA_TO_TMR]) {
+		printf("not supported");
+	} else {
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_PLCA_TO_TMR]);
+		printf("%u BT", val);
+	}
+	putchar('\n');
+
+	// get burst count
+	printf("\tBurst count: ");
+	if (!tb[ETHTOOL_A_PLCA_BURST_CNT]) {
+		printf("not supported");
+	} else {
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_PLCA_BURST_CNT]);
+		printf("%u (%s)", val,
+		       val > 0 ? "enabled" : "disabled");
+	}
+	putchar('\n');
+
+	// get burst timer
+	printf("\tBurst timer: ");
+	if (!tb[ETHTOOL_A_PLCA_BURST_TMR]) {
+		printf("not supported");
+	} else {
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_PLCA_BURST_TMR]);
+		printf("%u BT", val);
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
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PLCA_GET_CFG,
+				      ETHTOOL_A_PLCA_HEADER, 0);
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
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "node-cnt",
+		.type		= ETHTOOL_A_PLCA_NODE_CNT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "to-tmr",
+		.type		= ETHTOOL_A_PLCA_TO_TMR,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "burst-cnt",
+		.type		= ETHTOOL_A_PLCA_BURST_CNT,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "burst-tmr",
+		.type		= ETHTOOL_A_PLCA_BURST_TMR,
+		.handler	= nl_parse_direct_u32,
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
+	} else {
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
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_PLCA_GET_STATUS,
+				      ETHTOOL_A_PLCA_HEADER, 0);
+
+	if (ret < 0)
+		return ret;
+
+	return nlsock_send_get_request(nlsk, plca_get_status_reply_cb);
+}
diff --git a/netlink/settings.c b/netlink/settings.c
index 14ad0b46e102..2f4081b89713 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -166,6 +166,9 @@ static const struct link_mode_info link_modes[] = {
 	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
 	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
 	[ETHTOOL_LINK_MODE_10baseT1L_Full_BIT]		= __REAL(10),
+	[ETHTOOL_LINK_MODE_10baseT1S_Full_BIT]		= __REAL(10),
+	[ETHTOOL_LINK_MODE_10baseT1S_Half_BIT]		= __REAL(10),
+	[ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT]	= __REAL(10),
 };
 const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
 
@@ -890,6 +893,70 @@ int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data)
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
+
+		printf("OPEN Alliance v%u.%u",
+		       (unsigned int)((val >> 4) & 0xF),
+		       (unsigned int)(val & 0xF));
+	} else
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
+
+		printf(val ? "up" : "down");
+	} else
+		printf("unknown");
+
+	printf("\n");
+
+	return MNL_CB_OK;
+}
+
 static int gset_request(struct nl_context *nlctx, uint8_t msg_type,
 			uint16_t hdr_attr, mnl_cb_t cb)
 {
@@ -914,7 +981,10 @@ int nl_gset(struct cmd_context *ctx)
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKINFO_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_WOL_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_DEBUG_GET, true) ||
-	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true))
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_CFG, true) ||
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_STATUS, true))
 		return -EOPNOTSUPP;
 
 	nlctx->suppress_nlerr = 1;
@@ -934,6 +1004,12 @@ int nl_gset(struct cmd_context *ctx)
 	if (ret == -ENODEV)
 		return ret;
 
+	ret = gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_CFG,
+			   ETHTOOL_A_PLCA_HEADER, plca_cfg_reply_cb);
+
+	if (ret == -ENODEV)
+		return ret;
+
 	ret = gset_request(nlctx, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
 			   debug_reply_cb);
 	if (ret == -ENODEV)
@@ -941,6 +1017,13 @@ int nl_gset(struct cmd_context *ctx)
 
 	ret = gset_request(nlctx, ETHTOOL_MSG_LINKSTATE_GET,
 			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
+
+	if (ret == -ENODEV)
+		return ret;
+
+
+	ret = gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_STATUS,
+			   ETHTOOL_A_PLCA_HEADER, plca_status_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
@@ -949,7 +1032,6 @@ int nl_gset(struct cmd_context *ctx)
 		return 75;
 	}
 
-
 	return 0;
 }
 
-- 
2.37.4

