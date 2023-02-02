Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BDF6877F2
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjBBIxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjBBIxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:53:39 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26CB14EB8;
        Thu,  2 Feb 2023 00:53:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw12so3989029ejc.2;
        Thu, 02 Feb 2023 00:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S0CU+1ufO0MIDePneVAF7wc2e16ASE+d63jJbOhvyPM=;
        b=bTaZdF978hbQUa4KKQQ9vMegmv21dOgdnOh+VZ6Rw7+y6hqTL68hP/NhRHh7IGI9WN
         boK36pC+v3DiUDTNexJXK3bRFXK0UQuFePkA9LLLN0kcROYHEEfdwDit1E0/DW1iuQ2k
         YjiZFEY77ohxWiqII9FRKHdPsr183hHcleh/5wfysMi9lXOBLK4PVO914qVbl2Qf9Gu7
         x/6RQpSAF+abKsEzgFZVXOAJkAZ4VBdRz2pwloqv/KYFzmfVNnYMDJu3T6OD4ah+C2gN
         m3IxZnlrfnRUxT9BNAPOjMFbYvIouc77XpZ92KDtWV4Ey6P3fT+i7t7xCRKe5+Wk5iy/
         CFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S0CU+1ufO0MIDePneVAF7wc2e16ASE+d63jJbOhvyPM=;
        b=59cios1l+IqNymxH6hSht9jEH+hdJ2/K+Q1vhN+yHRbLj0G6tFlEWQf0rTW+ds7Ix2
         eeTX3dCoVAT0DC80YRLLwDEULw/LabIbQbMNGIVHNM1GOL4Nbb77q6UDiqx8Ll8/4nrA
         erjXU3PioAgFbIJDx7v6VJwm2t7xlK6gmwt8OJeRkU4p0m5zZc0x0k2JYBeslCQ24T70
         TUBz0quCykogED2DaFhKu1bgxL/Q1yqUYEZZ76iiftasXbCxpBkvP01WYXD6CEwXFLye
         c8kawVrNYFSs9UtkRYQd4jzYg9jViIHW1MMprYjGiriMrleMK4rAVncYmikvLiZSr7gn
         peKA==
X-Gm-Message-State: AO0yUKUC/Zm45YMCNtuj3qx9lqKgJ4xmMiuuiIhVFiGcciBul0Yc1+sN
        tuyNnHeKkYE1zPGas0tGaV0=
X-Google-Smtp-Source: AK7set/a3jcSHIPzMOI622pm9gLqs6kn6dkxhuSMXq4XhQAFMk48fVeniG4Lm2r84bP8yoohn0qbmQ==
X-Received: by 2002:a17:906:48cc:b0:84d:4e9d:864a with SMTP id d12-20020a17090648cc00b0084d4e9d864amr5913992ejt.74.1675327995999;
        Thu, 02 Feb 2023 00:53:15 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709061c1000b008898c93f086sm5525808ejg.71.2023.02.02.00.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 00:53:15 -0800 (PST)
Date:   Thu, 2 Feb 2023 09:53:15 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v5 ethtool-next 1/1] add support for IEEE 802.3cg-2019 Clause
 148
Message-ID: <d51013e0bc617651c0e6d298f47cc6b82c0ffa88.1675327734.git.piergiorgio.beruto@gmail.com>
References: <cover.1675327734.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675327734.git.piergiorgio.beruto@gmail.com>
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
 ethtool.8.in       |  83 ++++++++++++-
 ethtool.c          |  21 ++++
 netlink/extapi.h   |   6 +
 netlink/plca.c     | 296 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/settings.c |  82 ++++++++++++-
 6 files changed, 486 insertions(+), 3 deletions(-)
 create mode 100644 netlink/plca.c

diff --git a/Makefile.am b/Makefile.am
index 999e7691e81c..cbc1f4f5fdf2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -42,6 +42,7 @@ ethtool_SOURCES += \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/module-eeprom.c netlink/module.c netlink/rss.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
+		  netlink/plca.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h \
diff --git a/ethtool.8.in b/ethtool.8.in
index eaf6c55a84bf..c43c6d8b5263 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -468,7 +468,6 @@ ethtool \- query or control network driver and hardware settings
 .IR %x ]
 .I sub_command
 .RB ...
- .
 .HP
 .B ethtool \-\-cable\-test
 .I devname
@@ -490,6 +489,22 @@ ethtool \- query or control network driver and hardware settings
 .I devname
 .RB [ power\-mode\-policy
 .BR high | auto ]
+.HP
+.B ethtool \-\-get\-plca\-cfg
+.I devname
+.HP
+.B ethtool \-\-set\-plca\-cfg
+.I devname
+.RB [ enable
+.BR on | off ]
+.BN node\-id N
+.BN node\-cnt N
+.BN to\-tmr N
+.BN burst\-cnt N
+.BN burst\-tmr N
+.HP
+.B ethtool \-\-get\-plca\-status
+.I devname
 .
 .\" Adjust lines (i.e. full justification) and hyphenate.
 .ad
@@ -1514,6 +1529,69 @@ administratively up and to low power mode when the last port using it is put
 administratively down. The power mode policy can be set before a module is
 plugged-in.
 .RE
+.TP
+.B \-\-get\-plca\-cfg
+Show the current PLCA parameters for the given interface.
+.RE
+.TP
+.B \-\-set\-plca\-cfg
+Change the PLCA settings for the given interface.
+.RS 4
+.TP
+.A2 enable on off
+Enables or disables the PLCA function. When the PLCA RS is disabled (default),
+the PHY operates in plain CSMA/CD mode. To enable PLCA, the PHY must be assigned
+a unique \fBplca\-id\fR other than 255. This one can be configured concurrently
+with the enable parameter. The \fBenable\fR parameter maps to IEEE 802.3cg-2019
+clause 30.16.1.1.1 (aPLCAAdminState) and clause 30.16.1.2.1 (acPLCAAdminControl).
+.TP
+.BI node\-id \ N
+The unique node identifier in the range [0 .. 255]. Node ID 0 is reserved for
+the coordinator node, the one generating the BEACON signal. There must be
+exactly one coordinator on a PLCA network. Setting the node ID to 255 (default)
+disables the node. This parameter maps to IEEE 802.3cg-2019 clause 30.16.1.1.4
+(aPLCALocalNodeID).
+.TP
+.BI node\-cnt \ N
+The node-cnt [1 .. 255] should be set after the maximum number of nodes that
+can be plugged to the multi-drop network. This parameter regulates the minimum
+length of the PLCA cycle. Therefore, it is only meaningful for the coordinator
+node (\fBnod-id\fR = 0). Setting this parameter on a follower node has no
+effect. The \fBnode\-cnt\fR parameter maps to IEEE 802.3cg-2019 clause 
+30.16.1.1.3 (aPLCANodeCount).
+.TP
+.BI to\-tmr \ N
+The TO timer parameter sets the value of the transmit opportunity timer in 
+bit-times, and shall be set equal across all the nodes sharing the same
+medium for PLCA to work. The default value of 32 is enough to cover a link of
+roughly 50 mt. This parameter maps to  IEEE 802.3cg-2019 clause 30.16.1.1.5
+(aPLCATransmitOpportunityTimer).
+.TP
+.BI burst\-cnt \ N
+The \fBburst\-cnt\fR parameter [0 .. 255] indicates the extra number of packets
+that the node is allowed to send during a single transmit opportunity.
+By default, this attribute is 0, meaning that the node can send a sigle frame 
+per TO. When greater than 0, the PLCA RS keeps the TO after any transmission,
+waiting for the MAC to send a new frame for up to \fBburst\-tmr\fR BTs. This can
+only happen a number of times per PLCA cycle up to the value of this parameter.
+After that, the burst is over and the normal counting of TOs resumes.
+This parameter maps to IEEE 802.3cg-2019 clause 30.16.1.1.6 (aPLCAMaxBurstCount).
+.TP
+.BI burst\-tmr \ N
+The \fBburst\-tmr\fR parameter [0 .. 255] sets how many bit-times the PLCA RS
+waits for the MAC to initiate a new transmission when \fBburst\-cnt\fR is 
+greater than 0. If the MAC fails to send a new frame within this time, the burst
+ends and the counting of TOs resumes. Otherwise, the new frame is sent as part
+of the current burst. This parameter maps to IEEE 802.3cg-2019 clause
+30.16.1.1.7 (aPLCABurstTimer). The value of \fBburst\-tmr\fR should be set
+greater than the Inter-Frame-Gap (IFG) time of the MAC (plus some margin)
+for PLCA burst mode to work as intended.
+.RE
+.TP
+.B \-\-get\-plca\-status
+Show the current PLCA status for the given interface. If \fBon\fR, the PHY is
+successfully receiving or generating the BEACON signal. If \fBoff\fR, the PLCA
+function is temporarily disabled and the PHY is operating in plain CSMA/CD mode.
 .SH BUGS
 Not supported (in part or whole) on all network drivers.
 .SH AUTHOR
@@ -1532,7 +1610,8 @@ Alexander Duyck,
 Sucheta Chakraborty,
 Jesse Brandeburg,
 Ben Hutchings,
-Scott Branden.
+Scott Branden,
+Piergiorgio Beruto.
 .SH AVAILABILITY
 .B ethtool
 is available from
diff --git a/ethtool.c b/ethtool.c
index 9d3b0c850c3d..16c88bf7f527 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6080,6 +6080,27 @@ static const struct option args[] = {
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
index 9b6dd1a6e489..ce5748ec0532 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -48,6 +48,9 @@ int nl_smodule(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
 int nl_grss(struct cmd_context *ctx);
+int nl_plca_get_cfg(struct cmd_context *ctx);
+int nl_plca_set_cfg(struct cmd_context *ctx);
+int nl_plca_get_status(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -116,6 +119,9 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_gmodule		NULL
 #define nl_smodule		NULL
 #define nl_grss			NULL
+#define nl_plca_get_cfg		NULL
+#define nl_plca_set_cfg		NULL
+#define nl_plca_get_status	NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/plca.c b/netlink/plca.c
new file mode 100644
index 000000000000..7d61e3b9d5d9
--- /dev/null
+++ b/netlink/plca.c
@@ -0,0 +1,296 @@
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
+	int idv = 255;
+	int err_ret;
+	int val;
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
index 1107082167d4..a349e270dff9 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -899,6 +899,70 @@ int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data)
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
@@ -923,7 +987,10 @@ int nl_gset(struct cmd_context *ctx)
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
@@ -943,6 +1010,12 @@ int nl_gset(struct cmd_context *ctx)
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
@@ -950,6 +1023,13 @@ int nl_gset(struct cmd_context *ctx)
 
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
 
-- 
2.37.4

