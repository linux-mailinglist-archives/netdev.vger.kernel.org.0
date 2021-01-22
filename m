Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9AF2FFFAA
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbhAVKA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbhAVKAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 05:00:11 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33F5C061793
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:50:42 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id b5so4437015wrr.10
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1UXxZv9FY2Uf77SWFItXsRehMbfzG3JhxOmRmJWsw/s=;
        b=dLtJ9l5d9sapVMKHtc34Fq7+U1KaeYUhhkcq3TlkkQ3D3yuWFmlzMY974FgYC1THZp
         Y2oNZdXwSyLMae4JCvShJIobW5/oU6oaO8OgHpwgio1GvOZzwcO3lT58NpVe4tHYNAOB
         cZsESAQPKW5y+G+HrXCUOm3z/X9J3XZjGaZ7vGN5hm/Bo4ZBorlhY8XVxpby1Xx8IIj2
         qM+kGhwPS3ignbVJsW5mJSrb92WmETwVPHh26EzJlEYSzTgT0VDAUIMGdoc0M3FpbXGL
         2OFYccopXVNx+9460tf30E+9bBVgGygmGQC8BFIxJENG9ma9/4bL0UrwCJOIyoKxpMEw
         Yg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1UXxZv9FY2Uf77SWFItXsRehMbfzG3JhxOmRmJWsw/s=;
        b=kuRzJJv5ivwQzE00GolwLRqrtKDHse5L6T8O5pBzi4rTkhIfcSNDTxR+HtHKE0RIXr
         IS/7IDi4aVnD7unR52Loq6k6U1G7Onx1TJMSRFNI3SoNxfE53oEQS5FHx2dRxXPsBvun
         U0YPyPJcry5LNSCEbMkfyZwcwiVXIVvD3JMfuASDATZQ6W8t4o/oJPDK/gMcXxrOT+m7
         HK1zsIXX7kK8b5cFrdDWWJDkrS4n9Ad/jCiwlBI2pcwG5at7WgyPmsEsa+QjD+ywdQSw
         iJMeNSXuASmotccuzjGSDo6S2+Wg5i46uPI1ihRJOBrJCZ3MIeBZS3kzeEkMvMgiau3O
         dbcQ==
X-Gm-Message-State: AOAM531rZgy+TOlcgeBzD9bxbFpxhakQYXECj1e8pSPmiTgeDjLe/e62
        STu2IZrAmtHWqjbPMqXwLWiSqym/1X5Yepmyc54=
X-Google-Smtp-Source: ABdhPJyQ1PQ01nBeAdJQ2EmIf79aEYJhwoSTBPBKnq6jdrFLXsDaNyJ6zgUG8d4usrTMedlUCTadyA==
X-Received: by 2002:a05:6000:1547:: with SMTP id 7mr3642616wry.301.1611309041358;
        Fri, 22 Jan 2021 01:50:41 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id l18sm10364746wme.37.2021.01.22.01.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:50:40 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch iproute2/net-next RFCv2] devlink: add support for linecard show and provision
Date:   Fri, 22 Jan 2021 10:50:40 +0100
Message-Id: <20210122095040.1631362-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 206 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 202 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a2e066441e8a..63502a419d80 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -306,6 +306,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_FLASH_OVERWRITE		BIT(39)
 #define DL_OPT_RELOAD_ACTION		BIT(40)
 #define DL_OPT_RELOAD_LIMIT	BIT(41)
+#define DL_OPT_LINECARD		BIT(42)
+#define DL_OPT_LINECARD_TYPE	BIT(43)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -356,6 +358,8 @@ struct dl_opts {
 	uint32_t overwrite_mask;
 	enum devlink_reload_action reload_action;
 	enum devlink_reload_limit reload_limit;
+	uint32_t linecard_index;
+	const char *linecard_type;
 };
 
 struct dl {
@@ -1414,6 +1418,8 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
+	{DL_OPT_LINECARD,	      "Linecard index expected."},
+	{DL_OPT_LINECARD_TYPE,	      "Linecard type expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1832,7 +1838,25 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FUNCTION_HW_ADDR;
-
+		} else if (dl_argv_match(dl, "lc") &&
+			   (o_all & DL_OPT_LINECARD)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->linecard_index);
+			if (err)
+				return err;
+			o_found |= DL_OPT_LINECARD;
+		} else if (dl_argv_match(dl, "type") &&
+			   (o_all & DL_OPT_LINECARD_TYPE)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->linecard_type);
+			if (err)
+				return err;
+			o_found |= DL_OPT_LINECARD_TYPE;
+		} else if (dl_argv_match(dl, "notype") &&
+			   (o_all & DL_OPT_LINECARD_TYPE)) {
+			dl_arg_inc(dl);
+			opts->linecard_type = "";
+			o_found |= DL_OPT_LINECARD_TYPE;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -2015,6 +2039,12 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				 opts->trap_policer_burst);
 	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
 		dl_function_attr_put(nlh, opts);
+	if (opts->present & DL_OPT_LINECARD)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_LINECARD_INDEX,
+				 opts->linecard_index);
+	if (opts->present & DL_OPT_LINECARD_TYPE)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_LINECARD_TYPE,
+				  opts->linecard_type);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -2036,6 +2066,7 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 	struct nlattr *attr_dev_name = tb[DEVLINK_ATTR_DEV_NAME];
 	struct nlattr *attr_port_index = tb[DEVLINK_ATTR_PORT_INDEX];
 	struct nlattr *attr_sb_index = tb[DEVLINK_ATTR_SB_INDEX];
+	struct nlattr *attr_linecard_index = tb[DEVLINK_ATTR_LINECARD_INDEX];
 
 	if (opts->present & DL_OPT_HANDLE &&
 	    attr_bus_name && attr_dev_name) {
@@ -2063,6 +2094,12 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 		if (sb_index != opts->sb_index)
 			return false;
 	}
+	if (opts->present & DL_OPT_LINECARD && attr_linecard_index) {
+		uint32_t linecard_index = mnl_attr_get_u32(attr_linecard_index);
+
+		if (linecard_index != opts->linecard_index)
+			return false;
+	}
 	return true;
 }
 
@@ -3833,6 +3870,9 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 			break;
 		}
 	}
+	if (tb[DEVLINK_ATTR_LINECARD_INDEX])
+		print_uint(PRINT_ANY, "lc", " lc %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_LINECARD_INDEX]));
 	if (tb[DEVLINK_ATTR_PORT_NUMBER]) {
 		uint32_t port_number;
 
@@ -4005,6 +4045,139 @@ static int cmd_port(struct dl *dl)
 	return -ENOENT;
 }
 
+static void cmd_linecard_help(void)
+{
+	pr_err("Usage: devlink lc show [ DEV [ lc LC_INDEX ] ]\n");
+	pr_err("       devlink lc set DEV lc LC_INDEX [ { type LC_TYPE | notype } ]\n");
+}
+
+static const char *linecard_state_name(uint16_t flavour)
+{
+	switch (flavour) {
+	case DEVLINK_LINECARD_STATE_UNPROVISIONED:
+		return "unprovisioned";
+	case DEVLINK_LINECARD_STATE_UNPROVISIONING:
+		return "unprovisioning";
+	case DEVLINK_LINECARD_STATE_PROVISIONING:
+		return "provisioning";
+	case DEVLINK_LINECARD_STATE_PROVISIONING_FAILED:
+		return "provisioning_failed";
+	case DEVLINK_LINECARD_STATE_PROVISIONED:
+		return "provisioned";
+	case DEVLINK_LINECARD_STATE_ACTIVE:
+		return "active";
+	default:
+		return "<unknown state>";
+	}
+}
+
+static void pr_out_linecard_supported_types(struct dl *dl, struct nlattr **tb)
+{
+	struct nlattr *nla_types = tb[DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES];
+	struct nlattr *nla_type;
+
+	if (!nla_types)
+		return;
+
+	pr_out_array_start(dl, "supported_types");
+	check_indent_newline(dl);
+	mnl_attr_for_each_nested(nla_type, nla_types) {
+		print_string(PRINT_ANY, NULL, " %s",
+			     mnl_attr_get_str(nla_type));
+	}
+	pr_out_array_end(dl);
+}
+
+static void pr_out_linecard(struct dl *dl, struct nlattr **tb)
+{
+	uint8_t state;
+
+	pr_out_handle_start_arr(dl, tb);
+	check_indent_newline(dl);
+	print_uint(PRINT_ANY, "lc", "lc %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_LINECARD_INDEX]));
+	state = mnl_attr_get_u8(tb[DEVLINK_ATTR_LINECARD_STATE]);
+	print_string(PRINT_ANY, "state", " state %s",
+		     linecard_state_name(state));
+	if (tb[DEVLINK_ATTR_LINECARD_TYPE])
+		print_string(PRINT_ANY, "type", " type %s",
+			     mnl_attr_get_str(tb[DEVLINK_ATTR_LINECARD_TYPE]));
+	pr_out_linecard_supported_types(dl, tb);
+	pr_out_handle_end(dl);
+}
+
+static int cmd_linecard_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct dl *dl = data;
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_LINECARD_INDEX] ||
+	    !tb[DEVLINK_ATTR_LINECARD_STATE])
+		return MNL_CB_ERROR;
+	pr_out_linecard(dl, tb);
+	return MNL_CB_OK;
+}
+
+static int cmd_linecard_show(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_LINECARD_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
+					DL_OPT_LINECARD);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "lc");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_linecard_show_cb, dl);
+	pr_out_section_end(dl);
+	return err;
+}
+
+static int cmd_linecard_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_LINECARD_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_LINECARD |
+					 DL_OPT_LINECARD_TYPE, 0);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_linecard(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_linecard_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_linecard_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_linecard_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static void cmd_sb_help(void)
 {
 	pr_err("Usage: devlink sb show [ DEV [ sb SB_INDEX ] ]\n");
@@ -4818,6 +4991,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_POLICER_SET: return "set";
 	case DEVLINK_CMD_TRAP_POLICER_NEW: return "new";
 	case DEVLINK_CMD_TRAP_POLICER_DEL: return "del";
+	case DEVLINK_CMD_LINECARD_GET: return "get";
+	case DEVLINK_CMD_LINECARD_SET: return "set";
+	case DEVLINK_CMD_LINECARD_NEW: return "new";
+	case DEVLINK_CMD_LINECARD_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -4867,6 +5044,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_POLICER_NEW:
 	case DEVLINK_CMD_TRAP_POLICER_DEL:
 		return "trap-policer";
+	case DEVLINK_CMD_LINECARD_GET:
+	case DEVLINK_CMD_LINECARD_SET:
+	case DEVLINK_CMD_LINECARD_NEW:
+	case DEVLINK_CMD_LINECARD_DEL:
+		return "lc";
 	default: return "<unknown obj>";
 	}
 }
@@ -5059,6 +5241,18 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_policer(dl, tb, false);
 		break;
+	case DEVLINK_CMD_LINECARD_GET: /* fall through */
+	case DEVLINK_CMD_LINECARD_SET: /* fall through */
+	case DEVLINK_CMD_LINECARD_NEW: /* fall through */
+	case DEVLINK_CMD_LINECARD_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_LINECARD_INDEX])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_linecard(dl, tb);
+		pr_out_mon_footer();
+		break;
 	}
 	fflush(stdout);
 	return MNL_CB_OK;
@@ -5077,7 +5271,8 @@ static int cmd_mon_show(struct dl *dl)
 		    strcmp(cur_obj, "health") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
 		    strcmp(cur_obj, "trap-group") != 0 &&
-		    strcmp(cur_obj, "trap-policer") != 0) {
+		    strcmp(cur_obj, "trap-policer") != 0 &&
+		    strcmp(cur_obj, "lc") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -5098,7 +5293,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group | trap-policer }\n");
+	       "where  OBJECT-LIST := { dev | port | lc | health | trap | trap-group | trap-policer }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -8073,7 +8268,7 @@ static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
-	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
+	       "where  OBJECT := { dev | port | lc | sb | monitor | dpipe | resource | region | health | trap }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
 }
 
@@ -8112,6 +8307,9 @@ static int dl_cmd(struct dl *dl, int argc, char **argv)
 	} else if (dl_argv_match(dl, "trap")) {
 		dl_arg_inc(dl);
 		return cmd_trap(dl);
+	} else if (dl_argv_match(dl, "lc")) {
+		dl_arg_inc(dl);
+		return cmd_linecard(dl);
 	}
 	pr_err("Object \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
-- 
2.26.2

