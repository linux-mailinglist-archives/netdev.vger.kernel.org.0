Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02676145A
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfGGICk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:40 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:50771 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGICk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 056571AF7;
        Sun,  7 Jul 2019 04:02:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=FAfE0Q+CPGDUeQ+RCBFx+nwuMeevC3zyng2avgOpU/U=; b=Qs8ZassX
        4XYm/RdecDgzlWcXPFqA2S2Oeex/j8+cRrUY22cjphnltfMXJV0h0dC7DMmOqOnN
        pc/if9fVM6g3etVUHRxAWJ5Eli38/pVYWyQ9T28xhMSnW3SkKiBGQdiHy+xoXh3x
        9PWJGvuJq2H7DCjG848VIYIEozLeVD59ISUR2Nv9oE+KB7tjv4gJKdf1Kd8nO/r+
        A2HGgvd7/utwSst9Ir8rV68bijiJQXJwxENI4WXetpMxd39wfhUADBphyW5HjBbW
        qcc+uqmVmmswFGvA55TdBs17fbQNzyOkPjONw9ZHANdQ1v74h0b/gDBpMwImTN4z
        31Yhp+cXnO2Ifw==
X-ME-Sender: <xms:HqchXSJ8eGLH9ef6ITmrapLpQW50lZl_VhbRA0qZiDyGWEg77VTOmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:HqchXeZbULn1BK8DeE_Na5jMvXq__4dPmXplr6V9aHJKM2O8fzE40w>
    <xmx:HqchXduxegeKGf6WfDbu7r8UGL4j4OmMc6rQyACTeGIH5IBsEPrtMQ>
    <xmx:HqchXbuF61mUZIFjRsm9ftdYj-VeSEI8i66EAc1A37qqwMS1cNvSfQ>
    <xmx:HqchXViKkDqKBloFqJ3GPrzt6-hzp6c8dua-YcgvGyK-7JFpz6zAEA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53C218005B;
        Sun,  7 Jul 2019 04:02:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 3/7] devlink: Add devlink trap group set and show commands
Date:   Sun,  7 Jul 2019 11:01:56 +0300
Message-Id: <20190707080200.3699-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080200.3699-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080200.3699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

These commands are similar to the trap set and show commands, but
operate on a trap group and not individual traps. Example:

# devlink trap group set netdevsim/netdevsim10 group l3_drops action trap report true
# devlink -jps trap group show netdevsim/netdevsim10 group l3_drops
{
    "trap_group": {
        "netdevsim/netdevsim10": [ {
                "name": "l3_drops",
                "generic": true,
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
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 136 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 90f41cbd2a9c..ad62b6162f0b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -214,6 +214,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_NAME		BIT(29)
 #define DL_OPT_TRAP_REPORT		BIT(30)
 #define DL_OPT_TRAP_ACTION		BIT(31)
+#define DL_OPT_TRAP_GROUP_NAME		BIT(32)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -251,6 +252,7 @@ struct dl_opts {
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
 	const char *trap_name;
+	const char *trap_group_name;
 	bool trap_report;
 	enum devlink_trap_action trap_action;
 };
@@ -1075,6 +1077,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_REGION_LENGTH,	      "Region length value expected."},
 	{DL_OPT_HEALTH_REPORTER_NAME, "Reporter's name is expected."},
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
+	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1371,6 +1374,13 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_TRAP_NAME;
+		} else if (dl_argv_match(dl, "group") &&
+			   (o_all & DL_OPT_TRAP_GROUP_NAME)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->trap_group_name);
+			if (err)
+				return err;
+			o_found |= DL_OPT_TRAP_GROUP_NAME;
 		} else if (dl_argv_match(dl, "report") &&
 			   (o_all & DL_OPT_TRAP_REPORT)) {
 			dl_arg_inc(dl);
@@ -1506,6 +1516,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_TRAP_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_NAME,
 				  opts->trap_name);
+	if (opts->present & DL_OPT_TRAP_GROUP_NAME)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_TRAP_GROUP_NAME,
+				  opts->trap_group_name);
 	if (opts->present & DL_OPT_TRAP_REPORT)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_TRAP_REPORT_ENABLED,
 				opts->trap_report);
@@ -3832,6 +3845,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_SET: return "set";
 	case DEVLINK_CMD_TRAP_NEW: return "new";
 	case DEVLINK_CMD_TRAP_DEL: return "del";
+	case DEVLINK_CMD_TRAP_GROUP_GET: return "get";
+	case DEVLINK_CMD_TRAP_GROUP_SET: return "set";
+	case DEVLINK_CMD_TRAP_GROUP_NEW: return "new";
+	case DEVLINK_CMD_TRAP_GROUP_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -3865,6 +3882,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_NEW:
 	case DEVLINK_CMD_TRAP_DEL:
 		return "trap";
+	case DEVLINK_CMD_TRAP_GROUP_GET:
+	case DEVLINK_CMD_TRAP_GROUP_SET:
+	case DEVLINK_CMD_TRAP_GROUP_NEW:
+	case DEVLINK_CMD_TRAP_GROUP_DEL:
+		return "trap-group";
 	default: return "<unknown obj>";
 	}
 }
@@ -3891,6 +3913,7 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
 
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
+static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -3963,6 +3986,18 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap(dl, tb, false);
 		break;
+	case DEVLINK_CMD_TRAP_GROUP_GET: /* fall through */
+	case DEVLINK_CMD_TRAP_GROUP_SET: /* fall through */
+	case DEVLINK_CMD_TRAP_GROUP_NEW: /* fall through */
+	case DEVLINK_CMD_TRAP_GROUP_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] ||
+		    !tb[DEVLINK_ATTR_STATS])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_trap_group(dl, tb, false);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -3977,7 +4012,8 @@ static int cmd_mon_show(struct dl *dl)
 		if (strcmp(cur_obj, "all") != 0 &&
 		    strcmp(cur_obj, "dev") != 0 &&
 		    strcmp(cur_obj, "port") != 0 &&
-		    strcmp(cur_obj, "trap") != 0) {
+		    strcmp(cur_obj, "trap") != 0 &&
+		    strcmp(cur_obj, "trap-group") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -3994,7 +4030,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | trap }\n");
+	       "where  OBJECT-LIST := { dev | port | trap | trap-group }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -6509,6 +6545,9 @@ static void cmd_trap_help(void)
 	pr_err("Usage: devlink trap set DEV trap TRAP [ report { true | false } ]\n");
 	pr_err("                                      [ action { trap | drop } ]\n");
 	pr_err("       devlink trap show [ DEV trap TRAP ]\n");
+	pr_err("       devlink trap group set DEV group GROUP [ report { true | false } ]\n");
+	pr_err("                                              [ action { trap | drop } ]\n");
+	pr_err("       devlink trap group show [ DEV group GROUP ]\n");
 }
 
 static int cmd_trap_show(struct dl *dl)
@@ -6552,6 +6591,96 @@ static int cmd_trap_set(struct dl *dl)
 	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
 }
 
+static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array)
+{
+	if (array)
+		pr_out_handle_start_arr(dl, tb);
+	else
+		__pr_out_handle_start(dl, tb, true, false);
+
+	pr_out_str(dl, "name",
+		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_trap_group_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_TRAP_GROUP_NAME] || !tb[DEVLINK_ATTR_STATS])
+		return MNL_CB_ERROR;
+
+	pr_out_trap_group(dl, tb, true);
+
+	return MNL_CB_OK;
+}
+
+static int cmd_trap_group_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GROUP_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl,
+					DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+					0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "trap_group");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_trap_group_show_cb, dl);
+	pr_out_section_end(dl);
+
+	return err;
+}
+
+static int cmd_trap_group_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_TRAP_GROUP_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl,
+				DL_OPT_HANDLE | DL_OPT_TRAP_GROUP_NAME,
+				DL_OPT_TRAP_REPORT | DL_OPT_TRAP_ACTION);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_trap_group(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_trap_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_trap_group_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_trap_group_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_trap(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -6564,6 +6693,9 @@ static int cmd_trap(struct dl *dl)
 	} else if (dl_argv_match(dl, "set")) {
 		dl_arg_inc(dl);
 		return cmd_trap_set(dl);
+	} else if (dl_argv_match(dl, "group")) {
+		dl_arg_inc(dl);
+		return cmd_trap_group(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.20.1

