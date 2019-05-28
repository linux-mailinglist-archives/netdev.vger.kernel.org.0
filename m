Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE302C6A6
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfE1MgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:36:22 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42129 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726852AbfE1MgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:36:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B5ADE158E;
        Tue, 28 May 2019 08:26:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:26:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=XPtG6sPKwHeaZkmHuPTT+Xw+E4RNRkkfesrGg7KDjMA=; b=E/qedn+B
        xcodlrWOufeaHsusaih4j9oO5Ce7l17vt+w6wIL577dGtyBl6229DTcDElw36kNS
        ir/DI/SPDQr0OcSux+pfB7GFwgDi6RxzCo5hmSP1WqYj3XjR+Sm9Uu1PVglaXw6v
        dPrPjEGfL1Dz+v7F3gqO7t1A01naRfPk3F6BgxJ/6tO5IvLmdQz/DxMMI4vvbosz
        2jgKm5sNtE0T7RczKqNdsIMIqHvPKybi6lJ16d0K+LePJUW/d0IBcX8RPU4jQ9La
        Py/Rfk4zsJnUF1XSCvyIB/tVDCbxMY7yTu1muDIci/yo4Wa3IOLa06uD24JJbApQ
        gsp/NHC4pa20/Q==
X-ME-Sender: <xms:ESntXI9kw3rB_-lle8mmDTqo4IuMjnOM0WC76QX_TRm-7KzEsN_gHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:ESntXG0u6YRN9T5vEGGi1yP16NWR2ItOWje1jwr0810tWE7IabK6VQ>
    <xmx:ESntXEhkrDOL0zEHWkk80JEldTuZtn9GDucilB5_aTp_tdzNwRty_Q>
    <xmx:ESntXCf4d5WuuieOUDKAx-D_9XeyY0AN9L9gixCs3hhJpj3KLeIUfw>
    <xmx:ESntXOGrBFcUM2QqG5KCikK672NB2TN87yOBCckUfk6HrEsEGxkXdg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 074BB8005A;
        Tue, 28 May 2019 08:26:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH iproute2-next 3/5] devlink: Add devlink trap set and show commands
Date:   Tue, 28 May 2019 15:26:16 +0300
Message-Id: <20190528122618.30769-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122618.30769-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
 <20190528122618.30769-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The trap set command allows the user to set the action and reporting
state of an individual trap. Example:

# devlink trap set netdevsim/netdevsim10 trap blackhole_route_drop action trap report true

The trap show command allows the user to get the current status of an
individual trap or a dump of all traps in case one is not specified.
When '-s' is specified the trap's statistics are shown. When '-v' is
specified the metadata types the trap can provide are shown. Example:

# devlink -jvps trap show netdevsim/netdevsim10 trap blackhole_route_drop
{
    "trap": {
        "netdevsim/netdevsim10": [ {
                "name": "blackhole_route_drop",
                "type": "drop",
                "generic": true,
                "report": true,
                "action": "trap",
                "group": "l3_drops",
                "metadata": [ "input_port" ],
                "stats": {
                    "rx": {
                        "bytes": 0,
                        "packets": 0
                    }
                }
            } ]
    }
}

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 devlink/devlink.c | 313 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 308 insertions(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 40ad61fd0245..994427611f65 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -211,6 +211,9 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_NAME	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
+#define DL_OPT_TRAP_NAME		BIT(29)
+#define DL_OPT_TRAP_REPORT		BIT(30)
+#define DL_OPT_TRAP_ACTION		BIT(31)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -247,6 +250,9 @@ struct dl_opts {
 	const char *reporter_name;
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
+	const char *trap_name;
+	bool trap_report;
+	enum devlink_trap_action trap_action;
 };
 
 struct dl {
@@ -260,6 +266,7 @@ struct dl {
 	bool json_output;
 	bool pretty_output;
 	bool verbose;
+	bool stats;
 	struct {
 		bool present;
 		char *bus_name;
@@ -414,6 +421,22 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_STATS] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_TRAP_NAME] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_TRAP_REPORT_ENABLED] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_TRAP_ACTION] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_TRAP_TYPE] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
+	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_TRAP_TIMESTAMP] = MNL_TYPE_BINARY,
+	[DEVLINK_ATTR_TRAP_IN_PORT] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
+};
+
+static const enum mnl_attr_data_type
+devlink_stats_policy[DEVLINK_ATTR_STATS_MAX + 1] = {
+	[DEVLINK_ATTR_STATS_RX_PACKETS] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_STATS_RX_BYTES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -432,6 +455,25 @@ static int attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int attr_stats_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	/* Allow the tool to work on top of newer kernels that might contain
+	 * more attributes.
+	 */
+	if (mnl_attr_type_valid(attr, DEVLINK_ATTR_STATS_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_stats_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
 static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
@@ -992,6 +1034,20 @@ static int param_cmode_get(const char *cmodestr,
 	return 0;
 }
 
+static int trap_action_get(const char *actionstr,
+			   enum devlink_trap_action *p_action)
+{
+	if (strcmp(actionstr, "drop") == 0) {
+		*p_action = DEVLINK_TRAP_ACTION_DROP;
+	} else if (strcmp(actionstr, "trap") == 0) {
+		*p_action = DEVLINK_TRAP_ACTION_TRAP;
+	} else {
+		pr_err("Unknown trap action \"%s\"\n", actionstr);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 struct dl_args_metadata {
 	uint64_t o_flag;
 	char err_msg[DL_ARGS_REQUIRED_MAX_ERR_LEN];
@@ -1018,6 +1074,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_REGION_ADDRESS,	      "Region address value expected."},
 	{DL_OPT_REGION_LENGTH,	      "Region length value expected."},
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
+	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1307,6 +1364,32 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_HEALTH_REPORTER_AUTO_RECOVER;
+		} else if (dl_argv_match(dl, "trap") &&
+			   (o_all & DL_OPT_TRAP_NAME)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->trap_name);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_NAME;
+		} else if (dl_argv_match(dl, "report") &&
+			   (o_all & DL_OPT_TRAP_REPORT)) {
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &opts->trap_report);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_REPORT;
+		} else if (dl_argv_match(dl, "action") &&
+			   (o_all & DL_OPT_TRAP_ACTION)) {
+			const char *actionstr;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &actionstr);
+			if (err)
+				return err;
+			err = trap_action_get(actionstr, &opts->trap_action);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_ACTION;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1420,6 +1503,15 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_RECOVER)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
 				opts->reporter_auto_recover);
+	if (opts->present & DL_OPT_TRAP_NAME)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_NAME,
+				  opts->trap_name);
+	if (opts->present & DL_OPT_TRAP_REPORT)
+		mnl_attr_put_u8(nlh, DEVLINK_ATTR_TRAP_REPORT_ENABLED,
+				opts->trap_report);
+	if (opts->present & DL_OPT_TRAP_ACTION)
+		mnl_attr_put_u8(nlh, DEVLINK_ATTR_TRAP_ACTION,
+				opts->trap_action);
 
 }
 
@@ -1926,6 +2018,30 @@ static void pr_out_entry_end(struct dl *dl)
 		__pr_out_newline();
 }
 
+static void pr_out_stats(struct dl *dl, struct nlattr *nla_stats)
+{
+	struct nlattr *tb[DEVLINK_ATTR_STATS_MAX + 1] = {};
+	int err;
+
+	if (!dl->stats)
+		return;
+
+	err = mnl_attr_parse_nested(nla_stats, attr_stats_cb, tb);
+	if (err != MNL_CB_OK)
+		return;
+
+	pr_out_object_start(dl, "stats");
+	pr_out_object_start(dl, "rx");
+	if (tb[DEVLINK_ATTR_STATS_RX_BYTES])
+		pr_out_u64(dl, "bytes",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_STATS_RX_BYTES]));
+	if (tb[DEVLINK_ATTR_STATS_RX_PACKETS])
+		pr_out_u64(dl, "packets",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_STATS_RX_PACKETS]));
+	pr_out_object_end(dl);
+	pr_out_object_end(dl);
+}
+
 static const char *param_cmode_name(uint8_t cmode)
 {
 	switch (cmode) {
@@ -3712,6 +3828,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_REGION_SET: return "set";
 	case DEVLINK_CMD_REGION_NEW: return "new";
 	case DEVLINK_CMD_REGION_DEL: return "del";
+	case DEVLINK_CMD_TRAP_GET: return "get";
+	case DEVLINK_CMD_TRAP_SET: return "set";
+	case DEVLINK_CMD_TRAP_NEW: return "new";
+	case DEVLINK_CMD_TRAP_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -3740,6 +3860,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_REGION_NEW:
 	case DEVLINK_CMD_REGION_DEL:
 		return "region";
+	case DEVLINK_CMD_TRAP_GET:
+	case DEVLINK_CMD_TRAP_SET:
+	case DEVLINK_CMD_TRAP_NEW:
+	case DEVLINK_CMD_TRAP_DEL:
+		return "trap";
 	default: return "<unknown obj>";
 	}
 }
@@ -3765,6 +3890,7 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
 }
 
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
+static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -3820,6 +3946,23 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_region(dl, tb);
 		break;
+	case DEVLINK_CMD_TRAP_GET: /* fall through */
+	case DEVLINK_CMD_TRAP_SET: /* fall through */
+	case DEVLINK_CMD_TRAP_NEW: /* fall through */
+	case DEVLINK_CMD_TRAP_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_TYPE] ||
+		    !tb[DEVLINK_ATTR_TRAP_REPORT_ENABLED] ||
+		    !tb[DEVLINK_ATTR_TRAP_ACTION] ||
+		    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_METADATA] ||
+		    !tb[DEVLINK_ATTR_STATS])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_trap(dl, tb, false);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -3833,7 +3976,8 @@ static int cmd_mon_show(struct dl *dl)
 	while ((cur_obj = dl_argv_index(dl, index++))) {
 		if (strcmp(cur_obj, "all") != 0 &&
 		    strcmp(cur_obj, "dev") != 0 &&
-		    strcmp(cur_obj, "port") != 0) {
+		    strcmp(cur_obj, "port") != 0 &&
+		    strcmp(cur_obj, "trap") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -3850,7 +3994,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port }\n");
+	       "where  OBJECT-LIST := { dev | port | trap }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -6273,12 +6417,164 @@ static int cmd_health(struct dl *dl)
 	return -ENOENT;
 }
 
+static const char *trap_type_name(uint8_t type)
+{
+	switch (type) {
+	case DEVLINK_TRAP_TYPE_DROP:
+		return "drop";
+	case DEVLINK_TRAP_TYPE_EXCEPTION:
+		return "exception";
+	default:
+		return "<unknown type>";
+	}
+}
+
+static const char *trap_action_name(uint8_t action)
+{
+	switch (action) {
+	case DEVLINK_TRAP_ACTION_DROP:
+		return "drop";
+	case DEVLINK_TRAP_ACTION_TRAP:
+		return "trap";
+	default:
+		return "<unknown action>";
+	}
+}
+
+static const char *trap_metadata_name(const struct nlattr *attr)
+{
+	switch (attr->nla_type) {
+	case DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT:
+		return "input_port";
+	default:
+		return "<unknown metadata type>";
+	}
+}
+static void pr_out_trap_metadata(struct dl *dl, struct nlattr *attr)
+{
+	struct nlattr *attr_metadata;
+
+	pr_out_array_start(dl, "metadata");
+	mnl_attr_for_each_nested(attr_metadata, attr)
+		pr_out_str_value(dl, trap_metadata_name(attr_metadata));
+	pr_out_array_end(dl);
+}
+
+static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array)
+{
+	uint8_t action = mnl_attr_get_u8(tb[DEVLINK_ATTR_TRAP_ACTION]);
+	uint8_t type = mnl_attr_get_u8(tb[DEVLINK_ATTR_TRAP_TYPE]);
+
+	if (array)
+		pr_out_handle_start_arr(dl, tb);
+	else
+		__pr_out_handle_start(dl, tb, true, false);
+
+	pr_out_str(dl, "name", mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_NAME]));
+	pr_out_str(dl, "type", trap_type_name(type));
+	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	pr_out_bool(dl, "report",
+		    !!mnl_attr_get_u8(tb[DEVLINK_ATTR_TRAP_REPORT_ENABLED]));
+	pr_out_str(dl, "action", trap_action_name(action));
+	pr_out_str(dl, "group",
+		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	if (dl->verbose)
+		pr_out_trap_metadata(dl, tb[DEVLINK_ATTR_TRAP_METADATA]);
+	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_trap_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_NAME] || !tb[DEVLINK_ATTR_TRAP_TYPE] ||
+	    !tb[DEVLINK_ATTR_TRAP_REPORT_ENABLED] ||
+	    !tb[DEVLINK_ATTR_TRAP_ACTION] ||
+	    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_METADATA] || !tb[DEVLINK_ATTR_STATS])
+		return MNL_CB_ERROR;
+
+	pr_out_trap(dl, tb, true);
+
+	return MNL_CB_OK;
+}
+
+static void cmd_trap_help(void)
+{
+	pr_err("Usage: devlink trap set DEV trap TRAP [ report { true | false } ]\n");
+	pr_err("                                      [ action { trap | drop } ]\n");
+	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
+}
+
+static int cmd_trap_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl,
+					DL_OPT_HANDLE | DL_OPT_TRAP_NAME, 0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "trap");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_show_cb, dl);
+	pr_out_section_end(dl);
+
+	return err;
+}
+
+static int cmd_trap_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_TRAP_NAME,
+				DL_OPT_TRAP_REPORT | DL_OPT_TRAP_ACTION);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_trap(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_trap_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_trap_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_trap_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename\n"
-	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health }\n"
-	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
+	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
 }
 
 static int dl_cmd(struct dl *dl, int argc, char **argv)
@@ -6313,6 +6609,9 @@ static int dl_cmd(struct dl *dl, int argc, char **argv)
 	} else if (dl_argv_match(dl, "health")) {
 		dl_arg_inc(dl);
 		return cmd_health(dl);
+	} else if (dl_argv_match(dl, "trap")) {
+		dl_arg_inc(dl);
+		return cmd_trap(dl);
 	}
 	pr_err("Object \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
@@ -6422,6 +6721,7 @@ int main(int argc, char **argv)
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "verbose",		no_argument,		NULL, 'v' },
+		{ "statistics",		no_argument,		NULL, 's' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -6437,7 +6737,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpv",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvs",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -6463,6 +6763,9 @@ int main(int argc, char **argv)
 		case 'v':
 			dl->verbose = true;
 			break;
+		case 's':
+			dl->stats = true;
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
-- 
2.20.1

