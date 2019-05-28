Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0346C2C6A4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfE1MgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:36:24 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:50101 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727082AbfE1MgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:36:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 307091DBD;
        Tue, 28 May 2019 08:27:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=kIh0m/ZI9FuMPMrW9wkcr3UivnkaLopJZCj/QfYz+t8=; b=dY8dlaBe
        7RcbdfGReRvnCHPIpQQgX5Ge30xPnPj83KPo2BighTaMcNeFH762plvA53k/GxcA
        F7M6DEKmq6sNl2FrtS8rqsb43x9jV1XN57O6KEMmV1dd1W6Ls0SFFIMb5uPcoJth
        CP6UNEMLUhauTKCsYN/doPAnC9Ge1XpE9Y78EO0wuvbc1tcGb6+d6owNrrhN4MlG
        /4sKYbhS6gp/1p1rEdL0eKn/145h+8OK54zL+HWxmVOIGRkdel/Xlfp3hmj8Fvo4
        VdbevoZMku+hUVcceClvSdbCZp2n6ttXEmNRcUgtC/gFfOppqLt5Pqpz0HtCHOv0
        d+0tzshANCIu5w==
X-ME-Sender: <xms:EyntXEk9ssej24K62EH_nXn2rk7Cw8MNDcndN2fl3u5_ABBwIpPXMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:FCntXC0tR81zC-rXJDAFaLogwu6NyrmLYC5R11NgW8DY8bXBpKS8vQ>
    <xmx:FCntXCyKvK5UOv007EbfNd2W_WXdLp3zSuCEwBs5-p2mL9mmOLET7w>
    <xmx:FCntXC9EicH-D5qZtETG5samb__WfVLB7VtaUxadl58C_Bj_8Dhlhw>
    <xmx:FCntXCV5pjOHBzmnXFrz3lGOkq8DRhq0YvhdwrRnyBQ7wp8N4nxvZw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FB6380065;
        Tue, 28 May 2019 08:26:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH iproute2-next 4/5] devlink: Add devlink trap group set and show commands
Date:   Tue, 28 May 2019 15:26:17 +0300
Message-Id: <20190528122618.30769-5-idosch@idosch.org>
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
---
 devlink/devlink.c | 136 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 994427611f65..57b87536ccad 100644
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

