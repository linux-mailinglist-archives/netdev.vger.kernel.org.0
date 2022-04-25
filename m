Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD4F50DE05
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiDYKjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiDYKjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:39:36 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65C7B7C8
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:36:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z99so17815955ede.5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmu7gKOFQLsh8iJYlK8QLiILyLHTPrhFDTVceJvtDfs=;
        b=7gBR8LJbrQKFsjDys2iVKkjLf1T+MuCqKk6XUBren9vSPT6uFJUVpcXJLRtbVkMkil
         zORsam074mF7rddGUIpeFehhv4kO+gwzfTxMGPQ/dlpOe+BUGt0v5tkiqfngkbBkVqP1
         GOFcHGXtXNYjZ77wSOEjSThbwNPPjJ5pb9CxjwKVnF6m95d2T2//c7jSlQPwN2hFQRjs
         /YNorsa2tQxkbH7JXq5uGYerXTf0fTD3e5zTyr/agrfqvIpZO8MoZIAm0m2BYnE2SpAh
         l+28oshhPk3RC7dE3SGis8Mfy13qoh8YH40PcglRQZ+zPcQqYn4uV/OxPAWF+jE/SCVf
         AWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fmu7gKOFQLsh8iJYlK8QLiILyLHTPrhFDTVceJvtDfs=;
        b=ZS5c7nU3l2tgXpPcqZhOdSp6wYA6r/CrWFC1TNrnFYFL4SGlkwq7gcdmvqMdroLI8j
         +UaZ8YYzvngdTJuOSMc1s2ofnuu/2MzI08oyDZQAcYMkeXUURLyo8DREHtxwqdnVsulu
         qose+Lvkk3m3z1I38NrTXBzpVB6vASNnLF2m0ttACKfzNhnDoACbXL9nQvsMml0rv7Ty
         gRsABgYe5ua8s3ul7wiKCJYLD1dCo0hSgRDzFPVQ98tk8kSlVk07nL9Tjg1VVTfxMMBO
         szI2qkFflkeSg6ShNkuiMGsKZZjr2ejdWhWzhqwmhNqUgptuSxA8E9qz7LaGLHOnuzDe
         1SjA==
X-Gm-Message-State: AOAM533r2GvWOKOq/vPZmQ6kbd4yNHB6T2r4WNXxmpfpfA9AbpTgRTuT
        KCRqwa7mzCV4fLkFgA0NWzYJDqupnMHsEfap
X-Google-Smtp-Source: ABdhPJx5x/jSAdo30SmPE65nEZVCXpg+rm4CMPwgSn2t3qeTwyELn3/HkCuHbAlOHrLZuVAA0IvJrg==
X-Received: by 2002:aa7:cac5:0:b0:41c:c1fb:f5cc with SMTP id l5-20020aa7cac5000000b0041cc1fbf5ccmr17516636edt.219.1650882989382;
        Mon, 25 Apr 2022 03:36:29 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o2-20020a170906768200b006e89514a449sm3456349ejm.96.2022.04.25.03.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 03:36:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, snelson@pensando.io
Subject: [patch iproute2-next v3] devlink: introduce -[he]x cmdline option to allow dumping numbers in hex format
Date:   Mon, 25 Apr 2022 12:36:27 +0200
Message-Id: <20220425103627.1521070-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

For health reporter dumps it is quite convenient to have the numbers in
hexadecimal format. Introduce a command line option to allow user to
achieve that output.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- fixed patch subject
v1->v2:
- changed the hex output option to "-x"
- added "0x" prefix to hex numbers
---
 devlink/devlink.c  | 19 +++++++++++++------
 man/man8/devlink.8 |  4 ++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index da9f97788bcf..7ace968ca081 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -367,6 +367,7 @@ struct dl {
 	bool pretty_output;
 	bool verbose;
 	bool stats;
+	bool hex;
 	struct {
 		bool present;
 		char *bus_name;
@@ -8044,6 +8045,8 @@ static int cmd_health_dump_clear(struct dl *dl)
 
 static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 {
+	const char *num_fmt = dl->hex ? "%#x" : "%u";
+	const char *num64_fmt = dl->hex ? "%#"PRIx64 : "%"PRIu64;
 	uint8_t *data;
 	uint32_t len;
 
@@ -8053,16 +8056,16 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 		print_bool(PRINT_ANY, NULL, "%s", mnl_attr_get_u8(nl_data));
 		break;
 	case MNL_TYPE_U8:
-		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u8(nl_data));
+		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u8(nl_data));
 		break;
 	case MNL_TYPE_U16:
-		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u16(nl_data));
+		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u16(nl_data));
 		break;
 	case MNL_TYPE_U32:
-		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u32(nl_data));
+		print_uint(PRINT_ANY, NULL, num_fmt, mnl_attr_get_u32(nl_data));
 		break;
 	case MNL_TYPE_U64:
-		print_u64(PRINT_ANY, NULL, "%"PRIu64, mnl_attr_get_u64(nl_data));
+		print_u64(PRINT_ANY, NULL, num64_fmt, mnl_attr_get_u64(nl_data));
 		break;
 	case MNL_TYPE_NUL_STRING:
 		print_string(PRINT_ANY, NULL, "%s", mnl_attr_get_str(nl_data));
@@ -8928,7 +8931,7 @@ static void help(void)
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
-	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
+	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] -[he]x }\n");
 }
 
 static int dl_cmd(struct dl *dl, int argc, char **argv)
@@ -9042,6 +9045,7 @@ int main(int argc, char **argv)
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
 		{ "iec",		no_argument,		NULL, 'i' },
+		{ "hex",		no_argument,		NULL, 'x' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -9057,7 +9061,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:ix",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -9095,6 +9099,9 @@ int main(int argc, char **argv)
 		case 'i':
 			use_iec = true;
 			break;
+		case 'x':
+			dl->hex = true;
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 840cf44cf97b..de53061bc880 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -63,6 +63,10 @@ Switches to the specified network namespace.
 .BR "\-i", " --iec"
 Print human readable rates in IEC units (e.g. 1Ki = 1024).
 
+.TP
+.BR "\-x", " --hex"
+Print dump numbers in hexadecimal format.
+
 .SS
 .I OBJECT
 
-- 
2.35.1

