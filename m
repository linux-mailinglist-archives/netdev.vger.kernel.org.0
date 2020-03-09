Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63A517E397
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgCIP1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:27:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36304 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgCIP1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:27:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id g62so5536655wme.1
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ct9M+GV8S4WFLtXSxxMwmHb4AaAB6kBARmym7Hmuac=;
        b=J38sSSjCLkTU9T8hrvqTugH+xBIiWAFLDWEPL4P0fG+/Ogp4G7SS8NdLwlNHfzZL29
         nCUKFfQoRBJCXYmaRQLgWHSGSj82QYseXoa3NBbWcE803agBS9u1MXBuJ0MPcCXBEgTH
         ynluGk0zOt63WscA7pc7o5xwNqVvunmjjtRT+jZp2tSXy+pOC+KEYeLlK2O4WMZE9MD1
         g2S/GMXyIlxxyL9XXtNA+tWWZMrN6vIoh+ht94+x20NrqLU7NA1U3acn9KZyRRjqLPel
         X5nygdUVmRbPazIb7VwUDQRGB3S45F4ELqUoIFirTz/2yBvvqiig4SBIUHsz9GPXs2Ha
         MbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ct9M+GV8S4WFLtXSxxMwmHb4AaAB6kBARmym7Hmuac=;
        b=OqOQcIkMC9H5q1Gt8L9HAqTNtTJViygOk5M2FKPs3tX8Q8/YslDEIfhxSs47dVrp3r
         E+nt4ltGOdCz4c0SJkQXZwgzQa1usD5RHcIC9WaMAmWfEn1Ga1cut5wv6R61uKjb37kA
         ckraEzZshTMC3QoBEr/BPUDt2QHxusunv1v7X4rjr79pu/O7xPEx8l38a3ZbY2sZQEy6
         tQP5wqNGXWdQZ6xVxlG3mj3Yr1zwPtdJA3h/zAv2lVS6zUEG/Zsw9499be7K7mINwl+r
         Onpmyx0x/IGRAV1iF/HI69qg504IHLxz8/m8yABkIT1mMy+ZwMa4EFSJ0NSYlS+4yOKw
         trSg==
X-Gm-Message-State: ANhLgQ3m4QsI+OCeTUZKBKeX2K46XaSGZSDyVy8cj+2r8WJsgdS80MPN
        pyL1WBVh1mfGjkldljcoM/LTUamiOx8=
X-Google-Smtp-Source: ADFU+vs01c3t08Zr69Ki9OKhi5GMromAdJsXOFKW1L+c4TVyaegxKlYwZhSOFcqpUkMjfRpo4f2ksg==
X-Received: by 2002:a1c:1f0c:: with SMTP id f12mr20535984wmf.179.1583767664504;
        Mon, 09 Mar 2020 08:27:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a26sm26743089wmm.18.2020.03.09.08.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:27:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next] tc: m_action: introduce support for hw stats type
Date:   Mon,  9 Mar 2020 16:27:43 +0100
Message-Id: <20200309152743.32599-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

introduce support for per-action hw stats type config.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/pkt_cls.h | 22 +++++++++++++
 man/man8/tc-actions.8        | 31 ++++++++++++++++++
 tc/m_action.c                | 61 ++++++++++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 449a63971451..81cc1a869588 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -17,6 +17,7 @@ enum {
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
+	TCA_ACT_HW_STATS_TYPE,
 	__TCA_ACT_MAX
 };
 
@@ -24,6 +25,27 @@ enum {
 					 * actions stats.
 					 */
 
+/* tca HW stats type
+ * When user does not pass the attribute, he does not care.
+ * It is the same as if he would pass the attribute with
+ * all supported bits set.
+ * In case no bits are set, user is not interested in getting any HW statistics.
+ */
+#define TCA_ACT_HW_STATS_TYPE_IMMEDIATE (1 << 0) /* Means that in dump, user
+						  * gets the current HW stats
+						  * state from the device
+						  * queried at the dump time.
+						  */
+#define TCA_ACT_HW_STATS_TYPE_DELAYED (1 << 1) /* Means that in dump, user gets
+						* HW stats that might be out
+						* of date for some time, maybe
+						* couple of seconds. This is
+						* the case when driver polls
+						* stats updates periodically
+						* or when it gets async stats update
+						* from the device.
+						*/
+
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
 #define TCA_ACT_MAX_PRIO 32
diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
index bee59f7247fa..7d7df00013c6 100644
--- a/man/man8/tc-actions.8
+++ b/man/man8/tc-actions.8
@@ -49,6 +49,8 @@ actions \- independently defined actions in tc
 ] [
 .I FLAGS
 ] [
+.I HWSTATSSPEC
+] [
 .I CONTROL
 ]
 
@@ -77,6 +79,12 @@ ACTNAME
 :=
 .I no_percpu
 
+.I HWSTATSSPEC
+:=
+.BR hw_stats " {"
+.IR immediate " | " delayed " | " disabled
+.R }
+
 .I ACTDETAIL
 :=
 .I ACTNAME ACTPARAMS
@@ -200,6 +208,29 @@ which indicates that action is expected to have minimal software data-path
 traffic and doesn't need to allocate stat counters with percpu allocator.
 This option is intended to be used by hardware-offloaded actions.
 
+.TP
+.BI hw_stats " HW_STATS"
+Speficies the type of HW stats of new action. If omitted, any stats counter type
+is going to be used, according to driver and its resources.
+The
+.I HW_STATS
+indicates the type. Any of the following are valid:
+.RS
+.TP
+.B immediate
+Means that in dump, user gets the current HW stats state from the device
+queried at the dump time.
+.TP
+.B delayed
+Means that in dump, user gets HW stats that might be out of date for
+some time, maybe couple of seconds. This is the case when driver polls
+stats updates periodically or when it gets async stats update
+from the device.
+.TP
+.B disabled
+No HW stats are going to be available in dump.
+.RE
+
 .TP
 .BI since " MSTIME"
 When dumping large number of actions, a millisecond time-filter can be
diff --git a/tc/m_action.c b/tc/m_action.c
index 4da810c8c0aa..08568462c9ad 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -149,6 +149,57 @@ new_cmd(char **argv)
 		(matches(*argv, "add") == 0);
 }
 
+static const struct hw_stats_type_item {
+	const char *str;
+	__u8 type;
+} hw_stats_type_items[] = {
+	{ "immediate", TCA_ACT_HW_STATS_TYPE_IMMEDIATE },
+	{ "delayed", TCA_ACT_HW_STATS_TYPE_DELAYED },
+	{ "disabled", 0 },
+};
+
+static void print_hw_stats(const struct rtattr *arg)
+{
+	struct nla_bitfield32 *hw_stats_type_bf = RTA_DATA(arg);
+	__u8 hw_stats_type;
+	int i;
+
+	hw_stats_type = hw_stats_type_bf->value & hw_stats_type_bf->selector;
+	print_string(PRINT_FP, NULL, "\t", NULL);
+	open_json_array(PRINT_ANY, "hw_stats");
+
+	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
+		const struct hw_stats_type_item *item;
+
+		item = &hw_stats_type_items[i];
+		if ((!hw_stats_type && !item->type) ||
+		    hw_stats_type & item->type)
+			print_string(PRINT_ANY, NULL, " %s", item->str);
+	}
+	close_json_array(PRINT_JSON, NULL);
+}
+
+static int parse_hw_stats(const char *str, struct nlmsghdr *n)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hw_stats_type_items); i++) {
+		const struct hw_stats_type_item *item;
+
+		item = &hw_stats_type_items[i];
+		if (matches(str, item->str) == 0) {
+			struct nla_bitfield32 hw_stats_type_bf =
+					{ item->type,
+					  item->type };
+			addattr_l(n, MAX_MSG, TCA_ACT_HW_STATS_TYPE,
+				  &hw_stats_type_bf, sizeof(hw_stats_type_bf));
+			return 0;
+		}
+
+	}
+	return -1;
+}
+
 int parse_action(int *argc_p, char ***argv_p, int tca_id, struct nlmsghdr *n)
 {
 	int argc = *argc_p;
@@ -250,6 +301,14 @@ done0:
 				addattr_l(n, MAX_MSG, TCA_ACT_COOKIE,
 					  &act_ck, act_ck_len);
 
+			if (*argv && matches(*argv, "hw_stats") == 0) {
+				NEXT_ARG();
+				ret = parse_hw_stats(*argv, n);
+				if (ret < 0)
+					invarg("value is invalid\n", *argv);
+				NEXT_ARG_FWD();
+			}
+
 			if (*argv && strcmp(*argv, "no_percpu") == 0) {
 				struct nla_bitfield32 flags =
 					{ TCA_ACT_FLAGS_NO_PERCPU_STATS,
@@ -337,6 +396,8 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 				   TCA_ACT_FLAGS_NO_PERCPU_STATS);
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
+	if (tb[TCA_ACT_HW_STATS_TYPE])
+		print_hw_stats(tb[TCA_ACT_HW_STATS_TYPE]);
 
 	return 0;
 }
-- 
2.21.1

