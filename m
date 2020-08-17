Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5612466BD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgHQM4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:56:33 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:52245 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726727AbgHQM4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:56:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 96F3599C;
        Mon, 17 Aug 2020 08:56:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=BBVb9C+RqiAzbmLmynjyYyHYMbJhNiFS1M/a6ftN/0c=; b=S5s0La6q
        HP+FxX7ydUzPHVVE5vDQdiL7h4RcMjODcTolAEGmrNl2AXRSQGKtk7y/kNWr006a
        PyjvXICDcJFmHyDGpwf7q4JxEhqPvm7Gw5W9k+KdidEj1W39oSTDoIoo3yyttxjs
        f+bnMhj3sBQ/RdchKAwr3wM7/cBdBAaCDY/xMKp5i8xGP+ewCsyNwy6mhjxdN2Eu
        zBm6rMl+OpCJUEJeKVwYC24WWh81hAi3tCeECPQKXrC7gXyw1/97VZKlyHNNLaTQ
        y3Mwl9ZIBvzLdogC4YGz0oTvdHVyzv86dGyQ81OuiS4O837d84H0QajMOLFRTlDX
        a/xlbNVaU52/IA==
X-ME-Sender: <xms:fH46X886D6n_JOLU7p5AAcWjbC5tIhW51x6L987RD4YOhNhVSVu9Gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:fH46X0sgHKuiHlpfryz50r5fw-9WlIvRoC3uOGAW6tM65pFQhOEh9Q>
    <xmx:fH46XyB6geYbH1XJemWQjO9jHAHw7oIosI7tvFdfuFaQTfD6V8oiZQ>
    <xmx:fH46X8crPRPoEgt9Rr9DyMkB7SxqMM1cwYB2YTDrFzRdJlBMnMZ1kA>
    <xmx:fH46X3u8in-4d5AKanYOdrBw0qZZRcMVZB8rbHR3mLCw6BA18LmAET3L1tM>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5985328005D;
        Mon, 17 Aug 2020 08:56:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH iproute2-next 2/2] devlink: Add device metric set and show commands
Date:   Mon, 17 Aug 2020 15:55:41 +0300
Message-Id: <20200817125541.193590-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125541.193590-1-idosch@idosch.org>
References: <20200817125541.193590-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Add support for devlink device metric set / show commands with
accompanying bash completion.

Examples:

Show a specific metric:

# devlink -sjp dev metric show netdevsim/netdevsim10 metric dummy_counter
{
    "metric": {
        "netdevsim/netdevsim10": [ {
                "metric": "dummy_counter",
                "type": "counter",
                "group": 0,
                "value": 11
            } ]
    }
}

Set multiple metrics to the same metric group:

# devlink dev metric set netdevsim/netdevsim10 metric dummy_counter group 5
# devlink dev metric set netdevsim/netdevsim20 metric dummy_counter group 5

Dump metrics from a specific group:

# devlink -sjp dev metric show group 5
{
    "metric": {
        "netdevsim/netdevsim10": [ {
                "metric": "dummy_counter",
                "type": "counter",
                "group": 5,
                "value": 12
            } ],
        "netdevsim/netdevsim20": [ {
                "metric": "dummy_counter",
                "type": "counter",
                "group": 5,
                "value": 13
            } ]
    }
}

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bash-completion/devlink |  67 ++++++++++++++-
 devlink/devlink.c       | 185 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 248 insertions(+), 4 deletions(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index f710c888652e..fd17e7ccf9c0 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -38,6 +38,15 @@ _devlink_direct_complete()
             value=$(devlink -j dev param show 2>/dev/null \
                     | jq ".param[\"$dev\"][].name")
             ;;
+        dev_metric)
+            value=$(devlink -j dev metric show 2>/dev/null \
+                    | jq '.metric' | jq 'keys[]')
+            ;;
+        metric)
+            dev=${words[4]}
+            value=$(devlink -j dev metric show 2>/dev/null \
+                    | jq ".metric[\"$dev\"][].metric")
+            ;;
         port)
             value=$(devlink -j port show 2>/dev/null \
                     | jq '.port as $ports | $ports | keys[] as $key
@@ -262,6 +271,62 @@ _devlink_dev_flash()
      esac
 }
 
+# Completion for devlink dev metric
+_devlink_dev_metric()
+{
+    if [[ $cword -eq 3 ]]; then
+            COMPREPLY=( $( compgen -W "show set" -- "$cur" ) )
+    fi
+
+    case "${words[3]}" in
+        show)
+            case $cword in
+                4)
+                    _devlink_direct_complete "dev_metric"
+                    COMPREPLY+=( $( compgen -W "group" -- "$cur" ) )
+                    return
+                    ;;
+                5)
+                    if [[ $prev != "group" ]]; then
+                        COMPREPLY=( $( compgen -W "metric" -- "$cur" ) )
+                    fi
+                    # else Integer argument
+                    return
+                    ;;
+                6)
+                    if [[ $prev == "metric" ]]; then
+                        _devlink_direct_complete "metric"
+                    fi
+                    return
+                    ;;
+            esac
+            ;;
+        set)
+            case $cword in
+                4)
+                    _devlink_direct_complete "dev_metric"
+                    return
+                    ;;
+                5)
+                    COMPREPLY=( $( compgen -W "metric" -- "$cur" ) )
+                    return
+                    ;;
+                6)
+                    _devlink_direct_complete "metric"
+                    return
+                    ;;
+                7)
+                    COMPREPLY=( $( compgen -W "group" -- "$cur" ) )
+                    return
+                    ;;
+                8)
+                    # Integer argument
+                    return
+                    ;;
+            esac
+    esac
+}
+
 # Completion for devlink dev
 _devlink_dev()
 {
@@ -274,7 +339,7 @@ _devlink_dev()
             fi
             return
             ;;
-        eswitch|param)
+        eswitch|param|metric)
             _devlink_dev_$command
             return
             ;;
diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8ec96c01fbcf..00d4e9a31f7e 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -302,6 +302,8 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_POLICER_BURST	BIT(36)
 #define DL_OPT_HEALTH_REPORTER_AUTO_DUMP     BIT(37)
 #define DL_OPT_PORT_FUNCTION_HW_ADDR BIT(38)
+#define DL_OPT_METRIC_NAME	BIT(39)
+#define DL_OPT_METRIC_GROUP	BIT(40)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -349,6 +351,8 @@ struct dl_opts {
 	uint64_t trap_policer_burst;
 	char port_function_hw_addr[MAX_ADDR_LEN];
 	uint32_t port_function_hw_addr_len;
+	const char *metric_name;
+	uint32_t metric_group;
 };
 
 struct dl {
@@ -678,6 +682,10 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_METRIC_NAME] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_METRIC_TYPE] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_METRIC_COUNTER_VALUE] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_METRIC_GROUP] = MNL_TYPE_U32,
 };
 
 static const enum mnl_attr_data_type
@@ -1359,6 +1367,8 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_TRAP_NAME,            "Trap's name is expected."},
 	{DL_OPT_TRAP_GROUP_NAME,      "Trap group's name is expected."},
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
+	{DL_OPT_METRIC_NAME,	       "Metric's name is expected."},
+	{DL_OPT_METRIC_GROUP,	       "Metric group's number is expected."}
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1738,7 +1748,20 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_PORT_FUNCTION_HW_ADDR;
-
+		} else if (dl_argv_match(dl, "metric") &&
+			   (o_all & DL_OPT_METRIC_NAME)) {
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &opts->metric_name);
+			if (err)
+				return err;
+			o_found |= DL_OPT_METRIC_NAME;
+		} else if (dl_argv_match(dl, "group") &&
+			   (o_all & DL_OPT_METRIC_GROUP)) {
+			dl_arg_inc(dl);
+			err = dl_argv_uint32_t(dl, &opts->metric_group);
+			if (err)
+				return err;
+			o_found |= DL_OPT_METRIC_GROUP;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1892,6 +1915,12 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				 opts->trap_policer_burst);
 	if (opts->present & DL_OPT_PORT_FUNCTION_HW_ADDR)
 		dl_function_attr_put(nlh, opts);
+	if (opts->present & DL_OPT_METRIC_NAME)
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_METRIC_NAME,
+				  opts->metric_name);
+	if (opts->present & DL_OPT_METRIC_GROUP)
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_METRIC_GROUP,
+				 opts->metric_group);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -1955,6 +1984,8 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ]\n");
+	pr_err("       devlink dev metric show [ DEV metric METRIC | group GROUP ]\n");
+	pr_err("       devlink dev metric set DEV metric METRIC [ group GROUP ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -3269,6 +3300,127 @@ out:
 	return err;
 }
 
+static const char *metric_type_name(uint8_t type)
+{
+	switch (type) {
+	case DEVLINK_METRIC_TYPE_COUNTER:
+		return "counter";
+	default:
+		return "<unknown type>";
+	}
+}
+
+static void pr_out_metric(struct dl *dl, struct nlattr **tb, bool array)
+{
+	uint8_t type = mnl_attr_get_u8(tb[DEVLINK_ATTR_METRIC_TYPE]);
+
+	if (array)
+		pr_out_handle_start_arr(dl, tb);
+	else
+		__pr_out_handle_start(dl, tb, true, false);
+
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "metric", " metric %s",
+		     mnl_attr_get_str(tb[DEVLINK_ATTR_METRIC_NAME]));
+	print_string(PRINT_ANY, "type", " type %s", metric_type_name(type));
+	print_uint(PRINT_ANY, "group", " group %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_METRIC_GROUP]));
+	if (dl->stats) {
+		if (tb[DEVLINK_ATTR_METRIC_COUNTER_VALUE]) {
+			enum devlink_attr attr;
+
+			attr = DEVLINK_ATTR_METRIC_COUNTER_VALUE;
+			pr_out_u64(dl, "value", mnl_attr_get_u64(tb[attr]));
+		}
+	}
+	pr_out_handle_end(dl);
+}
+
+static int cmd_dev_metric_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_METRIC_NAME] || !tb[DEVLINK_ATTR_METRIC_TYPE] ||
+	    !tb[DEVLINK_ATTR_METRIC_GROUP])
+		return MNL_CB_ERROR;
+	pr_out_metric(dl, tb, true);
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_metric_set(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_METRIC_SET, flags);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_METRIC_NAME,
+				DL_OPT_METRIC_GROUP);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
+static int cmd_dev_metric_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0) {
+		flags |= NLM_F_DUMP;
+	} else if (dl_argv_match(dl, "group")) {
+		dl_arg_inc(dl);
+		err = dl_argv_uint32_t(dl, &dl->opts.metric_group);
+		if (err)
+			return err;
+		dl->opts.present |= DL_OPT_METRIC_GROUP;
+		flags |= NLM_F_DUMP;
+	}
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_METRIC_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		if (flags & NLM_F_DUMP) {
+			pr_err("Too many arguments\n");
+			return -EINVAL;
+		}
+
+		err = dl_argv_parse(dl, DL_OPT_HANDLE | DL_OPT_METRIC_NAME, 0);
+		if (err)
+			return err;
+	}
+
+	dl_opts_put(nlh, dl);
+
+	pr_out_section_start(dl, "metric");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_dev_metric_show_cb, dl);
+	pr_out_section_end(dl);
+	return err;
+}
+
+static int cmd_dev_metric(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_dev_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_dev_metric_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_dev_metric_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_dev(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -3293,6 +3445,9 @@ static int cmd_dev(struct dl *dl)
 	} else if (dl_argv_match(dl, "flash")) {
 		dl_arg_inc(dl);
 		return cmd_dev_flash(dl);
+	} else if (dl_argv_match(dl, "metric")) {
+		dl_arg_inc(dl);
+		return cmd_dev_metric(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
@@ -4413,6 +4568,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_POLICER_SET: return "set";
 	case DEVLINK_CMD_TRAP_POLICER_NEW: return "new";
 	case DEVLINK_CMD_TRAP_POLICER_DEL: return "del";
+	case DEVLINK_CMD_METRIC_GET: return "get";
+	case DEVLINK_CMD_METRIC_SET: return "set";
+	case DEVLINK_CMD_METRIC_NEW: return "new";
+	case DEVLINK_CMD_METRIC_DEL: return "del";
 	default: return "<unknown cmd>";
 	}
 }
@@ -4462,6 +4621,11 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_TRAP_POLICER_NEW:
 	case DEVLINK_CMD_TRAP_POLICER_DEL:
 		return "trap-policer";
+	case DEVLINK_CMD_METRIC_GET:
+	case DEVLINK_CMD_METRIC_SET:
+	case DEVLINK_CMD_METRIC_NEW:
+	case DEVLINK_CMD_METRIC_DEL:
+		return "metric";
 	default: return "<unknown obj>";
 	}
 }
@@ -4532,6 +4696,7 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health,
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_policer(struct dl *dl, struct nlattr **tb, bool array);
+static void pr_out_metric(struct dl *dl, struct nlattr **tb, bool array);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 {
@@ -4653,6 +4818,19 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_trap_policer(dl, tb, false);
 		break;
+	case DEVLINK_CMD_METRIC_GET: /* fall through */
+	case DEVLINK_CMD_METRIC_SET: /* fall through */
+	case DEVLINK_CMD_METRIC_NEW: /* fall through */
+	case DEVLINK_CMD_METRIC_DEL:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_METRIC_NAME] ||
+		    !tb[DEVLINK_ATTR_METRIC_TYPE] ||
+		    !tb[DEVLINK_ATTR_METRIC_GROUP])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_metric(dl, tb, false);
+		break;
 	}
 	return MNL_CB_OK;
 }
@@ -4670,7 +4848,8 @@ static int cmd_mon_show(struct dl *dl)
 		    strcmp(cur_obj, "health") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
 		    strcmp(cur_obj, "trap-group") != 0 &&
-		    strcmp(cur_obj, "trap-policer") != 0) {
+		    strcmp(cur_obj, "trap-policer") != 0 &&
+		    strcmp(cur_obj, "metric") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
 			return -EINVAL;
 		}
@@ -4691,7 +4870,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group | trap-policer }\n");
+	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group | trap-policer | metric }\n");
 }
 
 static int cmd_mon(struct dl *dl)
-- 
2.26.2

