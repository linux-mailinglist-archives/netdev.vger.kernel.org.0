Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89001588920
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbiHCJKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiHCJKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:10:48 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92ABBE34
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 02:10:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q19so6558179pfg.8
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 02:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=bbgQFLJQPnXxQ7RAdflLJQs/BMZ+JI2wyH0NrUtT+Ok=;
        b=MuC5buCOejQhy9atTFvss3imAYwkrXDjDJbasDOrO/L9RLWdBzE/S8q2auwLasGIGc
         G78qScAvqoHZMM/jM03k++OeucinAg2JZVXqfifRqgUEgbIdMjc0c1lk12TcoYIkzOEx
         I5RC1iOVAvmv6qUsbsIOJBRroqAT+OK/X2JGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=bbgQFLJQPnXxQ7RAdflLJQs/BMZ+JI2wyH0NrUtT+Ok=;
        b=Q6DdeaYL+T+IDQObgswsVDAeekMNQNcRi4R9WX8ah2Z9LKJoHcmkmfjHqZnfjexXIF
         vwsBMyKohYdRjvywAm6AUN6C1DBDh2NtZ37+gifB+uz+nuhxytvZa3EPN+bAJxabisHG
         6NPQH62X4FGyd5GBl4DCTtiIBZOlXQ28Ug5tN2qr8anobTzUsUyiRp6bceZsEu3scgyE
         La17OoJNOAcPOFrlSV7sCA5UNGwHL7EeWrA12VsrCxqcpyPHJlhSDeKiNl2WqZEsG+Nb
         Jnr/ILLCn1k77ZEdRQE4ZCdSA6E6K/jKQ5o3I74ca4q7/UShwHS6ofP/S6jHysALmjmP
         eRJQ==
X-Gm-Message-State: ACgBeo1WqGjt7R2F5pzIzWhGK+SvyoGG/FVL5McOzveYx3tsSbeOOy6e
        SD90hca8drnWZ1WasBYqWvCl0w==
X-Google-Smtp-Source: AA6agR7srMHdvMACHxFYLPajSRroGZ46vrn6sOKpzBFPRaKO4C3JRVPBp9v2k5gu3ZBSdRKghCHGwQ==
X-Received: by 2002:a63:1a49:0:b0:41b:c0b2:c94d with SMTP id a9-20020a631a49000000b0041bc0b2c94dmr15459310pgm.524.1659517846012;
        Wed, 03 Aug 2022 02:10:46 -0700 (PDT)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id ik25-20020a170902ab1900b0016d6963cb12sm1315960plb.304.2022.08.03.02.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 02:10:44 -0700 (PDT)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH iproute2-next v5 2/2] devlink: add support for running selftests
Date:   Wed,  3 Aug 2022 14:40:25 +0530
Message-Id: <20220803091025.30800-3-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220803091025.30800-1-vikas.gupta@broadcom.com>
References: <20220803091025.30800-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bd56a105e5529bc9"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_TVD_MIME_NO_HEADERS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bd56a105e5529bc9

Add commands and helper APIs to run selftests.
Include a selftest id for a non volatile memory i.e. flash.
Also, update the man page and bash-completion for selftests
commands.

Examples:
$ devlink dev selftests run pci/0000:03:00.0 id flash
pci/0000:03:00.0:
    flash:
      status passed

$ devlink dev selftests show pci/0000:03:00.0
pci/0000:03:00.0
      flash

$ devlink dev selftests show pci/0000:03:00.0 -j
{"selftests":{"pci/0000:03:00.0":["flash"]}}

$ devlink dev selftests run pci/0000:03:00.0 id flash -j
{"selftests":{"pci/0000:03:00.0":{"flash":{"status":"passed"}}}}

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 bash-completion/devlink |  30 +++-
 devlink/devlink.c       | 328 ++++++++++++++++++++++++++++++++++++++++
 man/man8/devlink-dev.8  |  46 ++++++
 3 files changed, 403 insertions(+), 1 deletion(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 361be9fe..0117b278 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -33,6 +33,11 @@ _devlink_direct_complete()
         dev)
             value=$(devlink dev show 2>/dev/null)
             ;;
+        selftests_id)
+            dev=${words[4]}
+            value=$(devlink -j dev selftests show 2>/dev/null \
+                    | jq ".selftests[\"$dev\"][]")
+            ;;
         param_name)
             dev=${words[4]}
             value=$(devlink -j dev param show 2>/dev/null \
@@ -262,6 +267,29 @@ _devlink_dev_flash()
      esac
 }
 
+# Completion for devlink dev selftests
+_devlink_dev_selftests()
+{
+    if [[ $cword -gt 5 ]]; then
+            _devlink_direct_complete "selftests_id"
+            return
+    fi
+    case "$cword" in
+        3)
+            COMPREPLY=( $( compgen -W "show run" -- "$cur" ) )
+            return
+            ;;
+        4)
+            _devlink_direct_complete "dev"
+            return
+            ;;
+        5)
+            COMPREPLY=( $( compgen -W "id" -- "$cur" ) )
+            return
+            ;;
+    esac
+}
+
 # Completion for devlink dev
 _devlink_dev()
 {
@@ -274,7 +302,7 @@ _devlink_dev()
             fi
             return
             ;;
-        eswitch|param)
+        eswitch|param|selftests)
             _devlink_dev_$command
             return
             ;;
diff --git a/devlink/devlink.c b/devlink/devlink.c
index ddf430bb..822e9f60 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
 #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
 #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
+#define DL_OPT_SELFTESTS		BIT(52)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -354,6 +355,7 @@ struct dl_opts {
 	uint64_t rate_tx_max;
 	char *rate_node_name;
 	const char *rate_parent_node;
+	bool selftests_opt[DEVLINK_ATTR_SELFTEST_ID_MAX + 1];
 };
 
 struct dl {
@@ -693,6 +695,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_SELFTESTS] = MNL_TYPE_NESTED,
 };
 
 static const enum mnl_attr_data_type
@@ -1401,6 +1404,17 @@ static struct str_num_map port_fn_opstate_map[] = {
 	{ .str = NULL, }
 };
 
+static int selftests_get(const char *selftest_name, bool *selftests_opt)
+{
+	if (strcmp(selftest_name, "flash") == 0) {
+		selftests_opt[0] = true;
+	} else {
+		pr_err("Unknown selftest \"%s\"\n", selftest_name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int port_flavour_parse(const char *flavour, uint16_t *value)
 {
 	int num;
@@ -1490,6 +1504,7 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
 	{DL_OPT_PORT_FLAVOUR,          "Port flavour is expected."},
 	{DL_OPT_PORT_PFNUMBER,         "Port PCI PF number is expected."},
+	{DL_OPT_SELFTESTS,             "Test name is expected"},
 };
 
 static int dl_args_finding_required_validate(uint64_t o_required,
@@ -1793,6 +1808,21 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 				return err;
 			o_found |= DL_OPT_FLASH_OVERWRITE;
 
+		} else if (dl_argv_match(dl, "id") &&
+				(o_all & DL_OPT_SELFTESTS)) {
+			dl_arg_inc(dl);
+			while (dl_argc(dl)) {
+				const char *selftest_name;
+				err = dl_argv_str(dl, &selftest_name);
+				if (err)
+					return err;
+				err = selftests_get(selftest_name,
+						    opts->selftests_opt);
+				if (err)
+					return err;
+			}
+			o_found |= DL_OPT_SELFTESTS;
+
 		} else if (dl_argv_match(dl, "reporter") &&
 			   (o_all & DL_OPT_HEALTH_REPORTER_NAME)) {
 			dl_arg_inc(dl);
@@ -2063,6 +2093,34 @@ dl_reload_limits_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
 	mnl_attr_put(nlh, DEVLINK_ATTR_RELOAD_LIMITS, sizeof(limits), &limits);
 }
 
+static void
+dl_selftests_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
+{
+	bool test_sel = false;
+	struct nlattr *nest;
+	int id;
+
+	nest = mnl_attr_nest_start(nlh, DEVLINK_ATTR_SELFTESTS);
+
+	for (id = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
+	     id <= DEVLINK_ATTR_SELFTEST_ID_MAX &&
+		opts->selftests_opt[id]; id++) {
+		if (opts->selftests_opt[id]) {
+			test_sel = true;
+			mnl_attr_put(nlh, id, 0, NULL);
+		}
+	}
+
+	/* No test selected from user, select all */
+	if (!test_sel) {
+		for (id = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
+		     id <= DEVLINK_ATTR_SELFTEST_ID_MAX; id++)
+			mnl_attr_put(nlh, id, 0, NULL);
+	}
+
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 {
 	struct dl_opts *opts = &dl->opts;
@@ -2157,6 +2215,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				  opts->flash_component);
 	if (opts->present & DL_OPT_FLASH_OVERWRITE)
 		dl_flash_update_overwrite_put(nlh, opts);
+	if (opts->present & DL_OPT_SELFTESTS)
+		dl_selftests_put(nlh, opts);
 	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
 				  opts->reporter_name);
@@ -2285,6 +2345,8 @@ static void cmd_dev_help(void)
 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
+	pr_err("       devlink dev selftests show [DEV]\n");
+	pr_err("       devlink dev selftests run DEV [id TESTNAME ]\n");
 }
 
 static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
@@ -2379,6 +2441,41 @@ static void pr_out_handle(struct dl *dl, struct nlattr **tb)
 	pr_out_handle_end(dl);
 }
 
+static void pr_out_selftests_handle_start(struct dl *dl, struct nlattr **tb)
+{
+	const char *bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
+	const char *dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
+	char buf[64];
+
+	sprintf(buf, "%s/%s", bus_name, dev_name);
+
+	if (dl->json_output) {
+		if (should_arr_last_handle_end(dl, bus_name, dev_name))
+			close_json_array(PRINT_JSON, NULL);
+		if (should_arr_last_handle_start(dl, bus_name,
+						 dev_name)) {
+			open_json_array(PRINT_JSON, buf);
+			arr_last_handle_set(dl, bus_name, dev_name);
+		}
+	} else {
+		if (should_arr_last_handle_end(dl, bus_name, dev_name))
+			__pr_out_indent_dec();
+		if (should_arr_last_handle_start(dl, bus_name,
+						 dev_name)) {
+			pr_out("%s%s", buf, ":");
+			__pr_out_newline();
+			__pr_out_indent_inc();
+			arr_last_handle_set(dl, bus_name, dev_name);
+		}
+	}
+}
+
+static void pr_out_selftests_handle_end(struct dl *dl)
+{
+	if (!dl->json_output)
+		__pr_out_newline();
+}
+
 static bool cmp_arr_last_port_handle(struct dl *dl, const char *bus_name,
 				     const char *dev_name, uint32_t port_index)
 {
@@ -3904,6 +4001,234 @@ err_socket:
 	return err;
 }
 
+static const char *devlink_get_selftest_name(int id)
+{
+	switch (id) {
+	case DEVLINK_ATTR_SELFTEST_ID_FLASH:
+		return "flash";
+	default:
+		return "unknown";
+	}
+}
+
+static const enum mnl_attr_data_type
+devlink_selftest_id_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
+	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = MNL_TYPE_FLAG,
+};
+
+static int selftests_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	if (mnl_attr_type_valid(attr, DEVLINK_ATTR_SELFTEST_ID_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_selftest_id_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_selftests_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *selftests[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+	int avail = 0;
+	int err;
+	int i;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_SELFTESTS])
+		return MNL_CB_ERROR;
+
+	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_SELFTESTS],
+				    selftests_attr_cb, selftests);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
+	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
+		if (!(selftests[i]))
+			continue;
+
+		if (!avail) {
+			pr_out_selftests_handle_start(dl, tb);
+			avail = 1;
+		}
+
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, NULL, "%s", devlink_get_selftest_name(i));
+	}
+
+	if (avail) {
+		pr_out_selftests_handle_end(dl);
+	}
+
+	return MNL_CB_OK;
+}
+
+static const char *devlink_selftest_status_to_str(uint8_t status)
+{
+	switch (status) {
+	case DEVLINK_SELFTEST_STATUS_SKIP:
+		return "skipped";
+	case DEVLINK_SELFTEST_STATUS_PASS:
+		return "passed";
+	case DEVLINK_SELFTEST_STATUS_FAIL:
+		return "failed";
+	default:
+		return "unknown";
+	}
+}
+
+static const enum mnl_attr_data_type
+devlink_selftests_result_policy[DEVLINK_ATTR_SELFTEST_RESULT_MAX + 1] = {
+	[DEVLINK_ATTR_SELFTEST_RESULT] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_SELFTEST_RESULT_ID] = MNL_TYPE_U32,
+	[DEVLINK_ATTR_SELFTEST_RESULT_STATUS] = MNL_TYPE_U8,
+};
+
+static int selftests_result_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type;
+
+	if (mnl_attr_type_valid(attr, DEVLINK_ATTR_SELFTEST_RESULT_MAX) < 0)
+		return MNL_CB_OK;
+
+	type = mnl_attr_get_type(attr);
+	if (mnl_attr_validate(attr, devlink_selftests_result_policy[type]) < 0)
+		return MNL_CB_ERROR;
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_selftests_run_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *selftest;
+	struct dl *dl = data;
+	int avail = 0;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_SELFTESTS])
+		return MNL_CB_ERROR;
+
+	mnl_attr_for_each_nested(selftest, tb[DEVLINK_ATTR_SELFTESTS]) {
+		struct nlattr *result[DEVLINK_ATTR_SELFTEST_RESULT_MAX + 1] = {};
+		uint8_t status;
+		int err;
+		int id;
+
+		err = mnl_attr_parse_nested(selftest,
+					    selftests_result_attr_cb, result);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!result[DEVLINK_ATTR_SELFTEST_RESULT_ID] ||
+		    !result[DEVLINK_ATTR_SELFTEST_RESULT_STATUS])
+			return MNL_CB_ERROR;
+
+		if (!avail) {
+			pr_out_section_start(dl, "selftests");
+			__pr_out_handle_start(dl, tb, true, false);
+			__pr_out_indent_inc();
+			avail = 1;
+			if (!dl->json_output)
+				__pr_out_newline();
+		}
+
+		id = mnl_attr_get_u32(result[DEVLINK_ATTR_SELFTEST_RESULT_ID]);
+		status = mnl_attr_get_u8(result[DEVLINK_ATTR_SELFTEST_RESULT_STATUS]);
+
+		pr_out_object_start(dl, devlink_get_selftest_name(id));
+		check_indent_newline(dl);
+		print_string_name_value("status",
+					devlink_selftest_status_to_str(status));
+		pr_out_object_end(dl);
+		if (!dl->json_output)
+			__pr_out_newline();
+	}
+
+	if (avail) {
+		__pr_out_indent_dec();
+		pr_out_handle_end(dl);
+		pr_out_section_end(dl);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int cmd_dev_selftests_run(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	int err;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_RUN, flags);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SELFTESTS);
+	if (err)
+		return err;
+
+	if (!(dl->opts.present & DL_OPT_SELFTESTS))
+		dl_selftests_put(nlh, &dl->opts);
+
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_run_cb, dl);
+	return err;
+}
+
+static int cmd_dev_selftests_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "selftests");
+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_show_cb, dl);
+	pr_out_section_end(dl);
+	return err;
+}
+
+static int cmd_dev_selftests(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_dev_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_dev_selftests_show(dl);
+	} else if (dl_argv_match(dl, "run")) {
+		dl_arg_inc(dl);
+		return cmd_dev_selftests_run(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_dev(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help")) {
@@ -3928,6 +4253,9 @@ static int cmd_dev(struct dl *dl)
 	} else if (dl_argv_match(dl, "flash")) {
 		dl_arg_inc(dl);
 		return cmd_dev_flash(dl);
+	} else if (dl_argv_match(dl, "selftests")) {
+		dl_arg_inc(dl);
+		return cmd_dev_selftests(dl);
 	}
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 6906e509..2a776416 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -85,6 +85,20 @@ devlink-dev \- devlink device configuration
 .I ID
 ]
 
+.ti -8
+.B devlink dev selftests show
+[
+.I DEV
+]
+
+.ti -8
+.B devlink dev selftests run
+.I DEV
+[
+.B id
+.I ID...
+]
+
 .SH "DESCRIPTION"
 .SS devlink dev show - display devlink device attributes
 
@@ -249,6 +263,28 @@ should match the component names from
 .B "devlink dev info"
 and may be driver-dependent.
 
+.SS devlink dev selftests show - shows supported selftests on devlink device.
+
+.PP
+.I "DEV"
+- specifies the devlink device.
+If this argument is omitted all selftests for devlink devices are listed.
+
+.SS devlink dev selftests run - runs selftests on devlink device.
+
+.PP
+.I "DEV"
+- specifies the devlink device to execute selftests.
+
+.B id
+.I  ID...
+- The value of
+.I ID(s)
+should match the selftests shown in
+.B "devlink dev selftests show"
+to execute selftests on the devlink device.
+If this argument is omitted all selftests supported by devlink devices are executed.
+
 .SH "EXAMPLES"
 .PP
 devlink dev show
@@ -296,6 +332,16 @@ Flashing 100%
 .br
 Flashing done
 .RE
+.PP
+devlink dev selftests show pci/0000:01:00.0
+.RS 4
+Shows the supported selftests by the devlink device.
+.RE
+.PP
+devlink dev selftests run pci/0000:01:00.0 id flash
+.RS 4
+Perform a flash test on the devlink device.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.31.1


--000000000000bd56a105e5529bc9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICbHhbG4uH2eqxbKhxROlAwu8ci40Frhe1tM
6/Lrrf2SMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDgwMzA5
MTA0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCNhjIzj1+a2b/yMpeC1f2hUtJnPBup4PRTNtNkkZLaDyXYT5ArjGcO
UMK6xPOd2bN+2H1N90ANcTkjBwueqEGr5XxfGwJytmyJE+qtDwLOcWQbx9JlOQGcmHZ85wYiAfIG
MSV2gRvGnqNG+dNtSCvC2j2bhtL3D5i9ipiXCu8+OSKDtc3cq+W1YS9RevYEaDI7KpPpltZUiNiJ
MYlgDtsMx1213Cz0OvY9BMejBlPwf5etx9+Tm858dL/ydVp4dpPFPd9ONcHvIXB4D09gIWSs4YEL
QbI0ADQpgN7ARC5sPMNav95b7OZgoUGZ8hHS5pQwv6epzBFQ4mGJx8E2fn37
--000000000000bd56a105e5529bc9--
