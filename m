Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052E13B156C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFWILV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:11:21 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:39609 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhFWILU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:11:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 438355805A2;
        Wed, 23 Jun 2021 04:09:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 23 Jun 2021 04:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=T8IJA2au74T01lDFFIPBwPAEVMaTlwwEho8+bCeuEhY=; b=cYMxBexL
        FazBx6EFsnBIVotiNW9ebhJGkTOcQEcVsPQVpJu4YCtSPhpPIKg2KBucZEjZxiZl
        1nJCEnkoev4Rphz2zY3XucW0/lTmDz7fVPS1XkjkF29j6pMBo8ck6EVE6J8mbgiu
        IbgXBJvul9IUNffuIEbCnNkQzwPSedx0RaOfIoK3ME1vCXswssF8mcy51WtBSkew
        8HtJxB9rsCOOJY1i06ah1pW64zQpfZCFevYoI8fFE7Y6adESnZ3k81IDissPtzmJ
        aY+09efeM526DIe01+dokFW+AlZXZ93xgFyMEVxGRWnJh9JBWMsggahI97fOmwHT
        0bpKR/ck6/7ySQ==
X-ME-Sender: <xms:H-zSYGFHp9MFRSlXwS--dyvBuok6T5MK8FI1a1m9X0e6cAyFzXqkPQ>
    <xme:H-zSYHWmvJupeJZnDk7T04NEB4lb2kz8MdAvmW7gpxRZe0WE7TZ4uK7y7BzJ4raH0
    8rbfTCyNcABAzg>
X-ME-Received: <xmr:H-zSYAJWHK609oqq63HROmVgM_EUQ6NGdYPwweFGDkMGaYeoTGeoXqC6iXr3IViLk4NXsxILHZBF_-jvWTdsERJix2DxhMBI47GwFDT6WnCOHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegfedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:H-zSYAHXEeIcUDp6he6LKRapEJ3agE8IBpUi-GrG0XVl8wI9i4cVKg>
    <xmx:H-zSYMU185fxjSFPcj_lZoNT2YTBlUiq6UODxfae9biILYFjPFFR2w>
    <xmx:H-zSYDN_Xx2QE51UrX6dq0xOYuoVxi_6Fi7PEO3E8L2uAAb165Tzcg>
    <xmx:H-zSYArDdF6bePfn0tSkVj3KnCTGrKUSSPkXNImUP10ZSaCKBAHW9g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:09:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 2/2] ethtool: Add ability to write to transceiver module EEPROM
Date:   Wed, 23 Jun 2021 11:08:25 +0300
Message-Id: <20210623080825.2612270-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210623080825.2612270-1-idosch@idosch.org>
References: <20210623080825.2612270-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Implement support for writing to a transceiver module EEPROM using the
'ETHTOOL_MSG_MODULE_EEPROM_SET' message. While the netlink API allows
for multi-byte writes, the command line interface is limited to
single-byte writes. Example:

 # ethtool -M swp11 offset 0x80 page 3 bank 0 i2c 0x50 value 0x44

This is in accordance with the '-E' option which allows changing a byte
in the EEPROM of a network device.

Upon a successful write, a 'ETHTOOL_MSG_MODULE_EEPROM_NTF' notification
is sent to user space. Example:

 # ethtool --monitor
 listening...

 Module EEPROM write for swp11:
 offset: 128
 length: 1
 page: 3
 bank: 0
 i2c address: 0x50

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ethtool.8.in            |  29 ++++++++++
 ethtool.c               |  10 ++++
 netlink/desc-ethtool.c  |   2 +
 netlink/extapi.h        |   2 +
 netlink/module-eeprom.c | 125 +++++++++++++++++++++++++++++++++++++++-
 netlink/monitor.c       |   4 ++
 netlink/netlink.h       |   1 +
 7 files changed, 171 insertions(+), 2 deletions(-)

diff --git a/ethtool.8.in b/ethtool.8.in
index 115322a21932..4c77c4bcaefa 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -369,6 +369,14 @@ ethtool \- query or control network driver and hardware settings
 .BN bank
 .BN i2c
 .HP
+.B ethtool \-M|\-\-change\-module\-eeprom
+.I devname
+.BN offset \ N
+.BN page \ N
+.BN bank \ N
+.BN i2c \ N
+.BN value \ N
+.HP
 .B ethtool \-\-show\-priv\-flags
 .I devname
 .HP
@@ -1188,6 +1196,27 @@ and
 .I length
 parameters are treated relatively to EEPROM page boundaries.
 .TP
+.B \-M \-\-change\-module\-eeprom
+Changes a single byte in the module EEPROM at the specified address to a
+specific value.
+.RS 4
+.TP
+.BI offset \ N
+Specifies the offset within a page to write to.
+.TP
+.BI page \ N
+Specifies the page number to write to.
+.TP
+.BI bank \ N
+Specifies the bank number to write to. If not specified, kernel assumes bank 0.
+.TP
+.BI i2c \ N
+Specifies the I2C address of the page to write to.
+.TP
+.BI value \ N
+Specifies the value to write.
+.RE
+.TP
 .B \-\-show\-priv\-flags
 Queries the specified network device for its private flags.  The
 names and meanings of private flags (if any) are defined by each
diff --git a/ethtool.c b/ethtool.c
index 33a0a492cb15..601bb409d0ae 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5907,6 +5907,16 @@ static const struct option args[] = {
 			  "		[ bank N ]\n"
 			  "		[ i2c N ]\n"
 	},
+	{
+		.opts	= "-M|--change-module-eeprom",
+		.nlfunc = nl_setmodule,
+		.help	= "Change byte in device module EEPROM",
+		.xhelp	= "		[ offset N ]\n"
+			  "		[ page N ]\n"
+			  "		[ bank N ]\n"
+			  "		[ i2c N ]\n"
+			  "		[ value N ]\n"
+	},
 	{
 		.opts	= "--show-eee",
 		.func	= do_geee,
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index d6fc4e2d03df..4b86cd849f7d 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -408,6 +408,7 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_SET, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET, stats),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET, module_eeprom),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_SET, module_eeprom),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -447,6 +448,7 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_FEC_NTF, fec),
 	NLMSG_DESC(ETHTOOL_MSG_STATS_GET_REPLY, stats),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY, module_eeprom),
+	NLMSG_DESC(ETHTOOL_MSG_MODULE_EEPROM_NTF, module_eeprom),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 91bf02b5e3be..0579c2abdb5d 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -45,6 +45,7 @@ bool nl_gstats_chk(struct cmd_context *ctx);
 int nl_gstats(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
+int nl_setmodule(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -99,6 +100,7 @@ static inline void nl_monitor_usage(void)
 #define nl_gstats_chk		NULL
 #define nl_gstats		NULL
 #define nl_getmodule		NULL
+#define nl_setmodule		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 355d1de047a8..5ce74e6b7731 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -1,7 +1,7 @@
 /*
- * module-eeprom.c - netlink implementation of module eeprom get command
+ * module-eeprom.c - netlink implementation of module eeprom commands
  *
- * ethtool -m <dev>
+ * Implementation of "ethtool -m <dev>" and "ethtool -M <dev> ..."
  */
 
 #include <errno.h>
@@ -18,6 +18,8 @@
 #include "netlink.h"
 #include "parser.h"
 
+/* MODULE_EEPROM_GET */
+
 #define ETH_I2C_ADDRESS_LOW	0x50
 #define ETH_I2C_ADDRESS_HIGH	0x51
 #define ETH_I2C_MAX_ADDRESS	0x7F
@@ -340,6 +342,43 @@ static void decoder_print(void)
 	}
 }
 
+int module_eeprom_ntf_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MODULE_EEPROM_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	struct nl_context *nlctx = data;
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	if (!tb[ETHTOOL_A_MODULE_EEPROM_OFFSET] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_LENGTH] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_PAGE] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_BANK] ||
+	    !tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS])
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_FEC_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		putchar('\n');
+	printf("Module EEPROM write for %s:\n", nlctx->devname);
+	show_u32(tb[ETHTOOL_A_MODULE_EEPROM_OFFSET], "offset: ");
+	show_u32(tb[ETHTOOL_A_MODULE_EEPROM_LENGTH], "length: ");
+	printf("page: %u\n", mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_PAGE]));
+	printf("bank: %u\n", mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_BANK]));
+	printf("i2c address: 0x%x\n",
+	       mnl_attr_get_u8(tb[ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS]));
+
+	return MNL_CB_OK;
+}
+
 int nl_getmodule(struct cmd_context *ctx)
 {
 	struct ethtool_module_eeprom request = {0};
@@ -414,3 +453,85 @@ cleanup:
 	cache_free();
 	return ret;
 }
+
+/* MODULE_EEPROM_SET */
+
+static const struct param_parser setmodule_params[] = {
+	{
+		.arg		= "offset",
+		.type		= ETHTOOL_A_MODULE_EEPROM_OFFSET,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "page",
+		.type		= ETHTOOL_A_MODULE_EEPROM_PAGE,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "bank",
+		.type		= ETHTOOL_A_MODULE_EEPROM_BANK,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "i2c",
+		.type		= ETHTOOL_A_MODULE_EEPROM_I2C_ADDRESS,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "value",
+		.type		= ETHTOOL_A_MODULE_EEPROM_DATA,
+		.handler	= nl_parse_direct_u8,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_setmodule(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MODULE_EEPROM_SET, false))
+		return -EOPNOTSUPP;
+	if (!ctx->argc) {
+		fprintf(stderr, "ethtool (-M): parameters missing\n");
+		return 1;
+	}
+
+	nlctx->cmd = "-M";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_MODULE_EEPROM_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret < 0)
+		return 2;
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_MODULE_EEPROM_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, setmodule_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret < 0)
+		return 1;
+
+	if (ethnla_put_u32(msgbuff, ETHTOOL_A_MODULE_EEPROM_LENGTH, 1))
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
index 0c4df9e78ee3..ca4ebc7b0b9b 100644
--- a/netlink/monitor.c
+++ b/netlink/monitor.c
@@ -71,6 +71,10 @@ static struct {
 		.cmd	= ETHTOOL_MSG_FEC_NTF,
 		.cb	= fec_reply_cb,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MODULE_EEPROM_NTF,
+		.cb	= module_eeprom_ntf_cb,
+	},
 };
 
 static void clear_filter(struct nl_context *nlctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 70fa666b20e5..096a907c65c7 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -91,6 +91,7 @@ int cable_test_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int cable_test_tdr_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 int fec_reply_cb(const struct nlmsghdr *nlhdr, void *data);
+int module_eeprom_ntf_cb(const struct nlmsghdr *nlhdr, void *data);
 
 /* dump helpers */
 
-- 
2.31.1

