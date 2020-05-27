Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889D61E4CA8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387610AbgE0SD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgE0SD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:03:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F80CC03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:03:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p192so4539087ybc.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gqvWIIzgGnYB+w+92pYL8JqGQIYXDlZ/IarkIv/YQ1U=;
        b=KoFfRRIalVkFMENo3SfSvXpXND2N0t7YqEaj8ZkqC1y0n50e/T0mH/NBJnrZ+6rEOG
         HGilZwOVG2tRQIXnlhxmtHNZ1AxNh7HweGfGK+mCY6g9FZK0qVreJ/yCRBT1VNYIgUId
         1dc+Pj+tPvVBRpfoLCHA0uvMRpK+8aH9Vc/184C1ccWO48JBV8D0Q4ykEct2zPUtzPKq
         4yrNQ8wi5FnLzi9GZUeQsNLjB7dOU07rR65jk04CSsPECif8zt3Axh6V6cynhn/rLMaz
         wNztZBxlNtGq4fgOvikU0pSq7mgtOMs3RGPm49gEieEk1sRuBsu4CZYvc7WUTOrqw28s
         OkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gqvWIIzgGnYB+w+92pYL8JqGQIYXDlZ/IarkIv/YQ1U=;
        b=QfqB2qw4M/T4EBtfY1Ut36CEvjl5PK0UCLmaj4ss6Qbc6GQ2HAI7YkyuQOzgYtlgXG
         y5NAzxX7/md4om52UpQEiWxxf0tPbqF12YYWfpFHLg7h8frNspJWTPuIFPYDAQfyQO2z
         8XojwuV8KSsyAY9cSt+t96FVssFnxCHByZFSYRi+BZvqET2aCZf0zCKVSobbfyWGivZ9
         DEbQ6zICaNSAU9bH31pygi9ERD4LZMuqqL0o/4Aca6EoJC/VVebiDMvcxkajOTtfzkMD
         lIpCUjkDaN63A6YvYFm2Na59IJxNaeBQwb4ZvY3Wf2Ap6aQSTsWArin2faihzSHGbUth
         +2TA==
X-Gm-Message-State: AOAM531Dnyiks35vAe2R83WXH+dGCtsjSL9ee35PqobZGM0Wj0F5o1dL
        tl1Zs07TpojURlWfEHvJgw/b/mrCTxDcLrik96VOcPDbrhs13zHvwDQMLi2FO7hQ5qbHXDfWx5h
        fAwH3++Lsrm2Dpic1qNDvqKb6DAFlq8IHplzuTNh3ZM2ZAwBIB9J2Ljqj6EMlohrXvw1xCA==
X-Google-Smtp-Source: ABdhPJzUvh5vglvXuDoIiecjoXoLtJZEn9xKfAn7aZ1X2qNI79eYo4kYUOqnBN2D0GMR/5hRQp2oMZzz+98IubM=
X-Received: by 2002:a25:9242:: with SMTP id e2mr11222317ybo.188.1590602635618;
 Wed, 27 May 2020 11:03:55 -0700 (PDT)
Date:   Wed, 27 May 2020 11:03:45 -0700
In-Reply-To: <20200524015144.44017-1-icoolidge@google.com>
Message-Id: <20200527180346.58573-1-icoolidge@google.com>
Mime-Version: 1.0
References: <20200524015144.44017-1-icoolidge@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 1/2] iproute2: ip addr: Organize flag properties structurally
From:   "Ian K. Coolidge" <icoolidge@google.com>
To:     netdev@vger.kernel.org
Cc:     ek@google.com, "Ian K. Coolidge" <icoolidge@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This creates a nice systematic way to check that the various flags are
mutable from userspace and that the address family is valid.

Mutability properties are preserved to avoid introducing any behavioral
change in this CL. However, previously, immutable flags were ignored and
fell through to this confusing error:

Error: either "local" is duplicate, or "dadfailed" is a garbage.

But now, they just warn more explicitly:

Warning: dadfailed option is not mutable from userspace
---
 ip/ipaddress.c | 112 ++++++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 57 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 80d27ce2..403f7010 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1233,52 +1233,63 @@ static unsigned int get_ifa_flags(struct ifaddrmsg *ifa,
 		ifa->ifa_flags;
 }
 
-/* Mapping from argument to address flag mask */
-static const struct {
+/* Mapping from argument to address flag mask and attributes */
+static const struct ifa_flag_data_t {
 	const char *name;
-	unsigned long value;
-} ifa_flag_names[] = {
-	{ "secondary",		IFA_F_SECONDARY },
-	{ "temporary",		IFA_F_SECONDARY },
-	{ "nodad",		IFA_F_NODAD },
-	{ "optimistic",		IFA_F_OPTIMISTIC },
-	{ "dadfailed",		IFA_F_DADFAILED },
-	{ "home",		IFA_F_HOMEADDRESS },
-	{ "deprecated",		IFA_F_DEPRECATED },
-	{ "tentative",		IFA_F_TENTATIVE },
-	{ "permanent",		IFA_F_PERMANENT },
-	{ "mngtmpaddr",		IFA_F_MANAGETEMPADDR },
-	{ "noprefixroute",	IFA_F_NOPREFIXROUTE },
-	{ "autojoin",		IFA_F_MCAUTOJOIN },
-	{ "stable-privacy",	IFA_F_STABLE_PRIVACY },
+	unsigned long mask;
+	bool readonly;
+	bool v6only;
+} ifa_flag_data[] = {
+	{ .name = "secondary",		.mask = IFA_F_SECONDARY,	.readonly = true,	.v6only = false},
+	{ .name = "temporary",		.mask = IFA_F_SECONDARY,	.readonly = true,	.v6only = false},
+	{ .name = "nodad",		.mask = IFA_F_NODAD,	 	.readonly = false,	.v6only = true},
+	{ .name = "optimistic",		.mask = IFA_F_OPTIMISTIC,	.readonly = true,	.v6only = true},
+	{ .name = "dadfailed",		.mask = IFA_F_DADFAILED,	.readonly = true,	.v6only = true},
+	{ .name = "home",		.mask = IFA_F_HOMEADDRESS,	.readonly = false,	.v6only = true},
+	{ .name = "deprecated",		.mask = IFA_F_DEPRECATED,	.readonly = true,	.v6only = true},
+	{ .name = "tentative",		.mask = IFA_F_TENTATIVE,	.readonly = true,	.v6only = true},
+	{ .name = "permanent",		.mask = IFA_F_PERMANENT,	.readonly = true,	.v6only = true},
+	{ .name = "mngtmpaddr",		.mask = IFA_F_MANAGETEMPADDR,	.readonly = false,	.v6only = true},
+	{ .name = "noprefixroute",	.mask = IFA_F_NOPREFIXROUTE,	.readonly = false,	.v6only = true},
+	{ .name = "autojoin",		.mask = IFA_F_MCAUTOJOIN,	.readonly = false,	.v6only = true},
+	{ .name = "stable-privacy",	.mask = IFA_F_STABLE_PRIVACY, 	.readonly = true,	.v6only = true},
 };
 
+/* Returns a pointer to the data structure for a particular interface flag, or null if no flag could be found */
+static const struct ifa_flag_data_t* lookup_flag_data_by_name(const char* flag_name) {
+	for (int i = 0; i < ARRAY_SIZE(ifa_flag_data); ++i) {
+		if (strcmp(flag_name, ifa_flag_data[i].name) == 0)
+			return &ifa_flag_data[i];
+	}
+        return NULL;
+}
+
 static void print_ifa_flags(FILE *fp, const struct ifaddrmsg *ifa,
 			    unsigned int flags)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(ifa_flag_names); i++) {
-		unsigned long mask = ifa_flag_names[i].value;
+	for (i = 0; i < ARRAY_SIZE(ifa_flag_data); i++) {
+		const struct ifa_flag_data_t* flag_data = &ifa_flag_data[i];
 
-		if (mask == IFA_F_PERMANENT) {
-			if (!(flags & mask))
+		if (flag_data->mask == IFA_F_PERMANENT) {
+			if (!(flags & flag_data->mask))
 				print_bool(PRINT_ANY,
 					   "dynamic", "dynamic ", true);
-		} else if (flags & mask) {
-			if (mask == IFA_F_SECONDARY &&
+		} else if (flags & flag_data->mask) {
+			if (flag_data->mask == IFA_F_SECONDARY &&
 			    ifa->ifa_family == AF_INET6) {
 				print_bool(PRINT_ANY,
 					   "temporary", "temporary ", true);
 			} else {
 				print_string(PRINT_FP, NULL,
-					     "%s ", ifa_flag_names[i].name);
+					     "%s ", flag_data->name);
 				print_bool(PRINT_JSON,
-					   ifa_flag_names[i].name, NULL, true);
+					   flag_data->name, NULL, true);
 			}
 		}
 
-		flags &= ~mask;
+		flags &= ~flag_data->mask;
 	}
 
 	if (flags) {
@@ -1297,7 +1308,6 @@ static void print_ifa_flags(FILE *fp, const struct ifaddrmsg *ifa,
 static int get_filter(const char *arg)
 {
 	bool inv = false;
-	unsigned int i;
 
 	if (arg[0] == '-') {
 		inv = true;
@@ -1313,18 +1323,16 @@ static int get_filter(const char *arg)
 		arg = "secondary";
 	}
 
-	for (i = 0; i < ARRAY_SIZE(ifa_flag_names); i++) {
-		if (strcmp(arg, ifa_flag_names[i].name))
-			continue;
+	const struct ifa_flag_data_t* flag_data = lookup_flag_data_by_name(arg);
+	if (flag_data == NULL)
+		return -1;
 
-		if (inv)
-			filter.flags &= ~ifa_flag_names[i].value;
-		else
-			filter.flags |= ifa_flag_names[i].value;
-		filter.flagmask |= ifa_flag_names[i].value;
-		return 0;
-	}
-	return -1;
+	if (inv)
+		filter.flags &= ~flag_data->mask;
+	else
+		filter.flags |= flag_data->mask;
+	filter.flagmask |= flag_data->mask;
+	return 0;
 }
 
 static int ifa_label_match_rta(int ifindex, const struct rtattr *rta)
@@ -2330,25 +2338,15 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			preferred_lftp = *argv;
 			if (set_lifetime(&preferred_lft, *argv))
 				invarg("preferred_lft value", *argv);
-		} else if (strcmp(*argv, "home") == 0) {
-			if (req.ifa.ifa_family == AF_INET6)
-				ifa_flags |= IFA_F_HOMEADDRESS;
-			else
-				fprintf(stderr, "Warning: home option can be set only for IPv6 addresses\n");
-		} else if (strcmp(*argv, "nodad") == 0) {
-			if (req.ifa.ifa_family == AF_INET6)
-				ifa_flags |= IFA_F_NODAD;
-			else
-				fprintf(stderr, "Warning: nodad option can be set only for IPv6 addresses\n");
-		} else if (strcmp(*argv, "mngtmpaddr") == 0) {
-			if (req.ifa.ifa_family == AF_INET6)
-				ifa_flags |= IFA_F_MANAGETEMPADDR;
-			else
-				fprintf(stderr, "Warning: mngtmpaddr option can be set only for IPv6 addresses\n");
-		} else if (strcmp(*argv, "noprefixroute") == 0) {
-			ifa_flags |= IFA_F_NOPREFIXROUTE;
-		} else if (strcmp(*argv, "autojoin") == 0) {
-			ifa_flags |= IFA_F_MCAUTOJOIN;
+		} else if (lookup_flag_data_by_name(*argv)) {
+			const struct ifa_flag_data_t* flag_data = lookup_flag_data_by_name(*argv);
+			if (flag_data->readonly) {
+				fprintf(stderr, "Warning: %s option is not mutable from userspace\n", flag_data->name);
+			} else if (flag_data->v6only && req.ifa.ifa_family != AF_INET6) {
+				fprintf(stderr, "Warning: %s option can be set only for IPv6 addresses\n", flag_data->name);
+			} else {
+				ifa_flags |= flag_data->mask;
+			}
 		} else {
 			if (strcmp(*argv, "local") == 0)
 				NEXT_ARG();
-- 
2.27.0.rc0.183.gde8f92d652-goog

