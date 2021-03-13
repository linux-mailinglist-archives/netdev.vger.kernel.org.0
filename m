Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB6339A3E
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 01:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhCMADT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 19:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbhCMACq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 19:02:46 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B12C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 16:02:46 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id n23so4375172otq.1
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 16:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a6wQjC/3YqPwKxD8KlLN6RSVfnEsTgcTJVAVTUM4DfM=;
        b=ZeTVs9JLG6Qhj1A+XELDFaNnnpMSjFuPB5iX5SFt3KgqF0cFapHO9Bb4/FSDE6DK4Z
         NrapfWfs/4U1IEIyJwt3N9czcQ+hcFNvO1lvYa8tUkgkg8eUwM09ZDumWtM+MtydZNnj
         PGrg37Fq2xeVCXhpA0VKeVPHcwKglOui5GL0ReV4CbCKR7Z0dW6Am7J25sKlR/Dhz5XH
         rl/iN6UGJ6KIP3XlKg+JcxK0DOcxwUhanblwWQgTuJx28D2Q5gWxS8jhdmOO6iCusLcn
         kJVRUQF4kPhAz0qqONW+Bk0uScKjcjid6UB8G1iTzTV0BbIuTOxY9BVDH2+w6UBpudsF
         RXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a6wQjC/3YqPwKxD8KlLN6RSVfnEsTgcTJVAVTUM4DfM=;
        b=F288xlTcVPBDttvYO9CVg6OPF1cAn5z5SkfK9oP3stAGxrlH36TL37OdQEtGQco/IE
         D/+WhYptfYb3eJVf/NhylF5wjf7b+V68KpuVkaPLtLHrjeR1SbD6s3nC5btWdHL+Gt9T
         m0SSpK/z+cOBjqDtZcLqn6ZH8KLYT5P5+vJbHML2mCYNJ/G9pN4Y//R4qgu8eVi/oLds
         sqh7gLzJb58XF3VV6Omsj1UxJB1ImT7IhiUtDXLNe6ufkJghh4EB0u+8zEWa9IBsbr+K
         Wx4eQFsTA3xgIUDHJ/aJYYtm0kVw2l0YNw6rNtSv3l24ZA4iOvaLCkh1G7fgqQ0WIOAI
         A6AQ==
X-Gm-Message-State: AOAM531hqVOWIIDWmWR0LRMTLF2NCViJxBDAlpMxFUMFsRiZUIdtG2RH
        WZwIkgyVFcNChiOmJ9eImtBsYi3T06hDag==
X-Google-Smtp-Source: ABdhPJzy3lH9u2U3SZQalFAUg4Mz3why6H6H2XtFjP7CoLqg83WnmCWnUZndKPCalgMRlyXUehOUQw==
X-Received: by 2002:a05:6830:118f:: with SMTP id u15mr5128411otq.43.1615593765312;
        Fri, 12 Mar 2021 16:02:45 -0800 (PST)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id s21sm2187196oos.5.2021.03.12.16.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 16:02:44 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>, Alex Elder <elder@linaro.org>
Subject: [PATCH] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
Date:   Fri, 12 Mar 2021 18:02:41 -0600
Message-Id: <20210313000241.602790-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse and pass IFLA_RMNET_FLAGS to the kernel, to allow changing the
flags from the default of ingress-aggregate only.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 ip/iplink_rmnet.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
index 1d16440c6900..8a488f3d0316 100644
--- a/ip/iplink_rmnet.c
+++ b/ip/iplink_rmnet.c
@@ -16,6 +16,10 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... rmnet mux_id MUXID\n"
+		"                 [ingress-deaggregation]\n"
+		"                 [ingress-commands]\n"
+		"                 [ingress-chksumv4]\n"
+		"                 [egress-chksumv4]\n"
 		"\n"
 		"MUXID := 1-254\n"
 	);
@@ -29,6 +33,7 @@ static void explain(void)
 static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 			   struct nlmsghdr *n)
 {
+	struct ifla_rmnet_flags flags = { };
 	__u16 mux_id;
 
 	while (argc > 0) {
@@ -37,6 +42,18 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 			if (get_u16(&mux_id, *argv, 0))
 				invarg("mux_id is invalid", *argv);
 			addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
+		} else if (matches(*argv, "ingress-deaggregation") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
+		} else if (matches(*argv, "ingress-commands") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
+		} else if (matches(*argv, "ingress-chksumv4") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
+		} else if (matches(*argv, "egress-chksumv4") == 0) {
+			flags.mask = ~0;
+			flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
 		} else if (matches(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -48,11 +65,28 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--, argv++;
 	}
 
+	if (flags.mask)
+		addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
+
 	return 0;
 }
 
+static void rmnet_print_flags(FILE *fp, __u32 flags)
+{
+	if (flags & RMNET_FLAGS_INGRESS_DEAGGREGATION)
+		print_string(PRINT_ANY, NULL, "%s ", "ingress-deaggregation");
+	if (flags & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
+		print_string(PRINT_ANY, NULL, "%s ", "ingress-commands");
+	if (flags & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
+		print_string(PRINT_ANY, NULL, "%s ", "ingress-chksumv4");
+	if (flags & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
+		print_string(PRINT_ANY, NULL, "%s ", "egress-cksumv4");
+}
+
 static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
+	struct ifla_vlan_flags *flags;
+
 	if (!tb)
 		return;
 
@@ -64,6 +98,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		   "mux_id",
 		   "mux_id %u ",
 		   rta_getattr_u16(tb[IFLA_RMNET_MUX_ID]));
+
+	if (tb[IFLA_RMNET_FLAGS]) {
+		if (RTA_PAYLOAD(tb[IFLA_RMNET_FLAGS]) < sizeof(*flags))
+			return;
+		flags = RTA_DATA(tb[IFLA_RMNET_FLAGS]);
+
+		rmnet_print_flags(f, flags->flags);
+	}
 }
 
 static void rmnet_print_help(struct link_util *lu, int argc, char **argv,
-- 
2.28.0

