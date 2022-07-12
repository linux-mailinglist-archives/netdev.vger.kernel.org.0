Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0169257175F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiGLKcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGLKcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:32:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA854AD854
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:31:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ss3so7485251ejc.11
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dML7zQ2MwENGDNwzQPucZUEr+oUedNBKzQxUMOtWLwk=;
        b=I+KTDAaf/JEJyGK7dc4g7eJev6/OsdGIOIDFo+2Vi1am4Jq4gMYPxkRep4xSrsdFjf
         5cU2DXUbxRbkd95QkPRaGyD73cWT4zjCnEB4DWGfoQPDN7/LBLb1WLjsQeys8A/1AjIH
         xZZhvdlnUlImrKQ2VlK2G3EU6dTszoDRbtcAeJuhbH5BAQh4+NoFM4cWAqBYcEsjr0j+
         /Qbevw2EdsG33PnL/CqSuDeF2ZYBClnuK66nRrm7iStf7GQf8a7TsKeK+y04qoLLjhNa
         KdUJKeENmZiQVh2lYoLZOAv67vAOojrN+YQHwtOq2JsjnT0BNkMFubXuk9bW7p5qvhGh
         hgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dML7zQ2MwENGDNwzQPucZUEr+oUedNBKzQxUMOtWLwk=;
        b=wndlo/yVNM1oA/HqwoVCJ6KXj7KQFlaWlmU5/2odo7O1ts59EyjkysO/FdAA1dJ+IQ
         5F7xyw1KhbvPwEf6CQI7WK+84EuPO5n/p7TxKORBcvVFDQusoqp5liDcpRp1qw8Aq1BF
         9XljF0P0WJcpj48kIMt8rAslJKXbxQKbNr7nceJVCdvN950GuqWOXZSqz58ZMP/KBeN7
         M4uUEhWpsvVcMgUTysTlSvc6u/6KiuPQ1XOl3N09VXuSb3Gx7G5nALoFzzu01hbr8Qoa
         3Y8usSc4J78lUTbmWnajjg1IBRPMDZSvggV/OMwlISGy6cEYmrxjqS2gQAI8+p4dLCf+
         T3Nw==
X-Gm-Message-State: AJIora9+vL6yrW0iBrMI5DecoJTeDHajgTfKP7DYQt2HydsqCC8MxeFs
        WZ6crqTfBZ354IAKuDfFMff8qvFaESzGVZ7DUMY=
X-Google-Smtp-Source: AGRyM1tg/1yEl/V0AJM9wkBMPSYrtIUE8IL2F5jjXOGQIBWeE3fEf3m3foaBbx+jV1jUtcyJbch08w==
X-Received: by 2002:a17:907:2be9:b0:72b:50b8:82d6 with SMTP id gv41-20020a1709072be900b0072b50b882d6mr1428214ejc.677.1657621916335;
        Tue, 12 Jul 2022 03:31:56 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r18-20020a1709061bb200b007262a5e2204sm3672922ejg.153.2022.07.12.03.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:31:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: [patch iproute2/net-next] devlink: add support for linecard show and type set
Date:   Tue, 12 Jul 2022 12:31:54 +0200
Message-Id: <20220712103154.2805695-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce a new object "lc" to add devlink support for line cards with
two commands:
show - to get the info about the line card state, list of supported
       types as reported by kernel/driver.
set - to set/clear the line card type.

Example:
$ devlink lc
pci/0000:01:00.0:
  lc 1 state unprovisioned
    supported_types:
       16x100G
  lc 2 state unprovisioned
    supported_types:
       16x100G
  lc 3 state unprovisioned
    supported_types:
       16x100G
  lc 4 state unprovisioned
    supported_types:
       16x100G
  lc 5 state unprovisioned
    supported_types:
       16x100G
  lc 6 state unprovisioned
    supported_types:
       16x100G
  lc 7 state unprovisioned
    supported_types:
       16x100G
  lc 8 state unprovisioned
    supported_types:
       16x100G

To provision the slot #8:

$ devlink lc set pci/0000:01:00.0 lc 8 type 16x100G
$ devlink lc show pci/0000:01:00.0 lc 8
pci/0000:01:00.0:
  lc 8 state active type 16x100G
    supported_types:
       16x100G

To uprovision the slot #8:

$ devlink lc set pci/0000:01:00.0 lc 8 notype

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c     | 210 +++++++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-lc.8 | 103 +++++++++++++++++++++
 2 files changed, 310 insertions(+), 3 deletions(-)
 create mode 100644 man/man8/devlink-lc.8

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ddf430bbb02a..1e2cfc3d4285 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
+#define DL_OPT_LINECARD		BIT(52)
+#define DL_OPT_LINECARD_TYPE	BIT(53)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -354,6 +356,8 @@ struct dl_opts {
 	uint64_t rate_tx_max;
 	char *rate_node_name;
 	const char *rate_parent_node;
+	uint32_t linecard_index;
+	const char *linecard_type;
 };
 
 struct dl {
@@ -693,6 +697,10 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_LINECARD_INDEX] = MNL_TYPE_U32,
+	[DEVLINK_ATTR_LINECARD_STATE] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_LINECARD_TYPE] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES] = MNL_TYPE_NESTED,
 };
 
 static const enum mnl_attr_data_type
@@ -1490,6 +1498,8 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
 	{DL_OPT_PORT_FLAVOUR,          "Port flavour is expected."},
 	{DL_OPT_PORT_PFNUMBER,         "Port PCI PF number is expected."},
+	{DL_OPT_LINECARD,	      "Linecard index expected."},
+	{DL_OPT_LINECARD_TYPE,	      "Linecard type expected."},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -2008,6 +2018,25 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			dl_arg_inc(dl);
 			opts->rate_parent_node = "";
 			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
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
@@ -2221,6 +2250,12 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_PORT_FN_RATE_PARENT)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
 				  opts->rate_parent_node);
+	if (opts->present & DL_OPT_LINECARD)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_LINECARD_INDEX,
+				 opts->linecard_index);
+	if (opts->present & DL_OPT_LINECARD_TYPE)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_LINECARD_TYPE,
+				  opts->linecard_type);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -2242,6 +2277,7 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 	struct nlattr *attr_dev_name = tb[DEVLINK_ATTR_DEV_NAME];
 	struct nlattr *attr_port_index = tb[DEVLINK_ATTR_PORT_INDEX];
 	struct nlattr *attr_sb_index = tb[DEVLINK_ATTR_SB_INDEX];
+	struct nlattr *attr_linecard_index = tb[DEVLINK_ATTR_LINECARD_INDEX];
 
 	if (opts->present & DL_OPT_HANDLE &&
 	    attr_bus_name && attr_dev_name) {
@@ -2269,6 +2305,12 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
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
 
@@ -4104,6 +4146,9 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 			break;
 		}
 	}
+	if (tb[DEVLINK_ATTR_LINECARD_INDEX])
+		print_uint(PRINT_ANY, "lc", " lc %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_LINECARD_INDEX]));
 	if (tb[DEVLINK_ATTR_PORT_NUMBER]) {
 		uint32_t port_number;
 
@@ -4848,6 +4893,140 @@ static int cmd_port(struct dl *dl)
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
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_LINECARD_GET,
+					  flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE,
+					DL_OPT_LINECARD);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "lc");
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_linecard_show_cb, dl);
+	pr_out_section_end(dl);
+	return err;
+}
+
+static int cmd_linecard_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_LINECARD_SET,
+					  NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_LINECARD |
+					 DL_OPT_LINECARD_TYPE, 0);
+	if (err)
+		return err;
+
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, NULL, NULL);
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
@@ -5665,6 +5844,10 @@ static const char *cmd_name(uint8_t cmd)
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
@@ -5718,6 +5901,11 @@ static const char *cmd_obj(uint8_t cmd)
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
@@ -5910,6 +6098,18 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
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
@@ -5928,7 +6128,8 @@ static int cmd_mon_show(struct dl *dl)
 		    strcmp(cur_obj, "health") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
 		    strcmp(cur_obj, "trap-group") != 0 &&
-		    strcmp(cur_obj, "trap-policer") != 0) {
+		    strcmp(cur_obj, "trap-policer") != 0 &&
+		    strcmp(cur_obj, "lc") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -5949,7 +6150,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group | trap-policer }\n");
+	       "where  OBJECT-LIST := { dev | port | lc | health | trap | trap-group | trap-policer }\n");
 }
 
 static int cmd_mon(struct dl *dl)
@@ -8941,7 +9142,7 @@ static void help(void)
 {
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
-	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
+	       "where  OBJECT := { dev | port | lc | sb | monitor | dpipe | resource | region | health | trap }\n"
 	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] -[he]x }\n");
 }
 
@@ -8980,6 +9181,9 @@ static int dl_cmd(struct dl *dl, int argc, char **argv)
 	} else if (dl_argv_match(dl, "trap")) {
 		dl_arg_inc(dl);
 		return cmd_trap(dl);
+	} else if (dl_argv_match(dl, "lc")) {
+		dl_arg_inc(dl);
+		return cmd_linecard(dl);
 	}
 	pr_err("Object \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
diff --git a/man/man8/devlink-lc.8 b/man/man8/devlink-lc.8
new file mode 100644
index 000000000000..ae5bb6d8cad6
--- /dev/null
+++ b/man/man8/devlink-lc.8
@@ -0,0 +1,103 @@
+.TH DEVLINK\-LC 8 "20 Apr 2022" "iproute2" "Linux"
+.SH NAME
+devlink-lc \- devlink line card configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B devlink
+.RI "[ " OPTIONS " ]"
+.B lc
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " := { "
+\fB\-V\fR[\fIersion\fR] }
+
+.ti -8
+.B "devlink lc set"
+.IB DEV " lc " LC_INDEX
+.RB [ " type " {
+.IR LC_TYPE " | "
+.BR notype " } ] "
+
+.ti -8
+.B "devlink lc show"
+.RI "[ " DEV " [ "
+.BI lc " LC_INDEX
+.R  " ] ]"
+
+.ti -8
+.B devlink lc help
+
+.SH "DESCRIPTION"
+.SS devlink lc set - change line card attributes
+
+.PP
+.TP
+.I "DEV"
+Specifies the devlink device to operate on.
+
+.in +4
+Format is:
+.in +2
+BUS_NAME/BUS_ADDRESS
+
+.TP
+.BI lc " LC_INDEX "
+Specifies index of a line card slot to set.
+
+.TP
+.BR type " { "
+.IR LC_TYPE " | "
+.BR notype " } "
+Type of line card to provision. Each driver provides a list of supported line card types which is shown in the output of
+.BR "devlink lc show " command.
+
+.SS devlink lc show - display line card attributes
+
+.PP
+.TP
+.I "DEV"
+.RB "Specifies the devlink device to operate on. If this and " lc " arguments are omitted all line cards of all devices are listed.
+
+.TP
+.BI lc " LC_INDEX "
+Specifies index of a line card slot to show.
+
+.SH "EXAMPLES"
+.PP
+devlink ls show
+.RS 4
+Shows the state of all line cards on the system.
+.RE
+.PP
+devlink lc show pci/0000:01:00.0 lc 1
+.RS 4
+Shows the state of line card with index 1.
+.RE
+.PP
+devlink lc set pci/0000:01:00.0 lc 1 type 16x100G
+.RS 4
+.RI "Set type of specified line card to type " 16x100G "."
+.RE
+.PP
+devlink lc set pci/0000:01:00.0 lc 1 notype
+.RS 4
+Clear provisioning on a line card.
+.RE
+
+.SH SEE ALSO
+.BR devlink (8),
+.BR devlink-dev (8),
+.BR devlink-port (8),
+.BR devlink-sb (8),
+.BR devlink-monitor (8),
+.BR devlink-health (8),
+.br
+
+.SH AUTHOR
+Jiri Pirko <jiri@nvidia.com>
-- 
2.35.3

