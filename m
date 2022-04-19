Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CEB50765A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiDSRT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237020AbiDSRTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:19:23 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE94F326ED
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:16:39 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b24so22122688edu.10
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sRRRCI+pOhM/ZaZmdA9UGYOXQpM1lHGpFsorKxIRoRs=;
        b=Viv0ULTjPx0zMOpGsXXKkg33bW3UUSFAUs4XHv5EN50UEcE75mhVKakdzq9+/IMAvr
         1WeEu4PTNv9Yf9XxP1a7wSkhHFoZ9eK+aZlaJ11YhNTQLr6hNkbLwNlaDvQNSnkA5IpZ
         kTdujRZ+hLRgLEs8DCOBO8FsDUJCwyIbxSLaX3OFKrKEHFKup3FteBr9Y0Zjr5uhA08w
         /SnPZN7zXU3chJvGWrGRQw7kxddCzWrce4xPDQpo/WUNEmTUxAhrqfYU9GL6bgYFBrqJ
         Mqk4XRmDYnGQ8ScqWtpN/e9fLNJyJmqfXgTE22TtEmXzSEFY2HjzSqiDeNb3iBM8wawq
         NSbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sRRRCI+pOhM/ZaZmdA9UGYOXQpM1lHGpFsorKxIRoRs=;
        b=5+RVVmb/WU5wO5f2m6zpYiPBP5ZFeKtJ0x13PfMcJBy0WzlBZYWQGmNdwZLVLZJlGH
         4Drunq8bcgA0T5JpHqeknvvVX6ZDj756PYC0aU3yCSfNNsHmQKOdpStD9Tpo0+s3a2xx
         Zpcu3C7itKoJrZBZdaSJywL9RHgkqMg2dLoFqWzyFLWlZ+4u3e63HSPUP8QgtYiAGSSA
         zEg/ii5C0fgjGNh0UT1vfShpfh5bsNQiE+L4318Om4t7JcZO/7Jd6UTnun0YY/2Y3TYJ
         ToksyGMXjstKF/SsKw2Eu9ypgpUaYUuWk7e/5yXPiYWYxJfkSX1Sw/eReK9WooHRHz0D
         NGKA==
X-Gm-Message-State: AOAM533pbZId2humS/GkKPXrYFQx8o5QFfUPzwS1InzXLca6I8LmzNyF
        ExtsEcUDn/YhjZerfb9Ufkl26cuDxmArWmqH/nc=
X-Google-Smtp-Source: ABdhPJxyQVccWali8Dds40txoG/XUg9BvkxxeYtAqWm9sL587BOskhaK0xBDTEahG6aLoeeKnDXbTA==
X-Received: by 2002:a05:6402:2059:b0:41d:82c2:208a with SMTP id bc25-20020a056402205900b0041d82c2208amr18490876edb.379.1650388598555;
        Tue, 19 Apr 2022 10:16:38 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n14-20020a50934e000000b0042053e79386sm8762750eda.91.2022.04.19.10.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:16:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com
Subject: [patch iproute2-next] devlink: introduce -h[ex] cmdline option to allow dumping numbers in hex format
Date:   Tue, 19 Apr 2022 19:16:37 +0200
Message-Id: <20220419171637.1147925-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.1
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

For health reporter dumps it is quite convenient to have the numbers in
hexadecimal format. Introduce a command line option to allow user to
achieve that output.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c  | 19 +++++++++++++------
 man/man8/devlink.8 |  4 ++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index aab739f7f437..bc681737ec8a 100644
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
+	const char *num_fmt = dl->hex ? "%x" : "%u";
+	const char *num64_fmt = dl->hex ? "%"PRIx64 : "%"PRIu64;
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
@@ -8939,7 +8942,7 @@ static void help(void)
 	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns] netnsname\n"
 	       "where  OBJECT := { dev | port | sb | monitor | dpipe | resource | region | health | trap }\n"
-	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] }\n");
+	       "       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] -s[tatistics] -h[ex] }\n");
 }
 
 static int dl_cmd(struct dl *dl, int argc, char **argv)
@@ -9053,6 +9056,7 @@ int main(int argc, char **argv)
 		{ "statistics",		no_argument,		NULL, 's' },
 		{ "Netns",		required_argument,	NULL, 'N' },
 		{ "iec",		no_argument,		NULL, 'i' },
+		{ "hex",		no_argument,		NULL, 'h' },
 		{ NULL, 0, NULL, 0 }
 	};
 	const char *batch_file = NULL;
@@ -9068,7 +9072,7 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:i",
+	while ((opt = getopt_long(argc, argv, "Vfb:njpvsN:ih",
 				  long_options, NULL)) >= 0) {
 
 		switch (opt) {
@@ -9106,6 +9110,9 @@ int main(int argc, char **argv)
 		case 'i':
 			use_iec = true;
 			break;
+		case 'h':
+			dl->hex = true;
+			break;
 		default:
 			pr_err("Unknown option.\n");
 			help();
diff --git a/man/man8/devlink.8 b/man/man8/devlink.8
index 840cf44cf97b..3797a27cefc5 100644
--- a/man/man8/devlink.8
+++ b/man/man8/devlink.8
@@ -63,6 +63,10 @@ Switches to the specified network namespace.
 .BR "\-i", " --iec"
 Print human readable rates in IEC units (e.g. 1Ki = 1024).
 
+.TP
+.BR "\-h", " --hex"
+Print dump numbers in hexadecimal format.
+
 .SS
 .I OBJECT
 
-- 
2.35.1

