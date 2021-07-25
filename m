Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC97B3D4E54
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhGYO7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 10:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhGYO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 10:59:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3D1C061757
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 08:39:38 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so287739pjb.3
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 08:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k4pyqvYl4yXwUVWm1WJZRtkkOJEdYxtORYlE3QvJu2k=;
        b=cFXoP8Q9we/D8JrpzOQ47XYavF6KBq2FcWFM9Y6jnyV+zrP+EW//xw0D+YgcizRoi8
         gfRryd4WJMSq3tCZkLV+grm0g/wSG5T7xOzTKe354xVpWsny1qYubD+kvp+pZO0jOQ7Z
         PraMmUL06Szcpi+HWc/C7omWZb86oWpzZnUnrh+jW9GNlxpe1kC/Joebt4gIKSXgAvXg
         T4vkoF/SUIUkc8Z89MOiMWbFYaTPm3hWYP0HqkrkmOqh1ZJQExYikNl4dV9dvbBEzt1J
         4oWx+XWHaRvVSuvN+glOGOvpGsULp0V79TYazzVaCXY3JWk/PG7KxjDUfnzFxvJy2wWe
         iaLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k4pyqvYl4yXwUVWm1WJZRtkkOJEdYxtORYlE3QvJu2k=;
        b=PHFcF6H9o541sPtoVLjGlqeG927VAClqpivtZ5ziVEuT4XQ9uGu214uEZ571zbOJHv
         TWarQnksvsVxQYnESP86qSjkPxAj2Bg3+xUXpkqNKHPB37kfOQxKWCmD+TvxA8SCzym2
         KEQ0J4bSQ7kfEc5M9ayEpmjz8MkMyVJpg7zMZTTvq0PZ9CBHwVvJZleUurlmsP6NBNE6
         nJlL67dySh++4oLMpnru+cz1yRYZZzZPVi0iDvYGew8N3DA+7p7L7TYT7CcMhwQwehaF
         pmwrKt8b008bzDBPUEe94V2x3jKBvXzyKi4r2wxpakGniPsQeXtYbADUVd4cqWL9QBp2
         3K2g==
X-Gm-Message-State: AOAM533QTkYzX5jw8m/JfQIFctxv/eyRLuK4N7ZzLc2YdkoAHKiMPp1I
        eNzigRlVb+ph9P7Z4LNE1fmx7XMj2LJ0a8uPSqw=
X-Google-Smtp-Source: ABdhPJxW0rGSUS29/AJDUdgqLbuJO7WabF9DDwd5lc39KBhnHm7J8pB3noUffuUJ02/V6/I+X02rfg==
X-Received: by 2002:a17:90a:9f91:: with SMTP id o17mr22065031pjp.29.1627227577868;
        Sun, 25 Jul 2021 08:39:37 -0700 (PDT)
Received: from lattitude.lan ([49.206.115.145])
        by smtp.googlemail.com with ESMTPSA id r7sm7500503pga.44.2021.07.25.08.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 08:39:37 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next] ipneigh: add support to print brief output of neigh cache in tabular format
Date:   Sun, 25 Jul 2021 21:09:13 +0530
Message-Id: <20210725153913.3316181-1-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the already available brief flag and print the basic details of
the IPv4 or IPv6 neighbour cache in a tabular format for better readability
when the brief output is expected.

$ ip -br neigh
bridge0          172.16.12.100                           b0:fc:36:2f:07:43
bridge0          172.16.12.174                           8c:16:45:2f:bc:1c
bridge0          172.16.12.250                           04:d9:f5:c1:0c:74
bridge0          fe80::267b:9f70:745e:d54d               b0:fc:36:2f:07:43
bridge0          fd16:a115:6a62:0:8744:efa1:9933:2c4c    8c:16:45:2f:bc:1c
bridge0          fe80::6d9:f5ff:fec1:c74                 04:d9:f5:c1:0c:74

And add "ip neigh show" to the list of ip sub commands mentioned in the man
page that support the brief output in tabular format.

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 ip/ipneigh.c  | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/ip.8 |  2 +-
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 2d6b7f58..91c157f9 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -251,6 +251,51 @@ static void print_neigh_state(unsigned int nud)
 	close_json_array(PRINT_JSON, NULL);
 }
 
+static int print_neigh_brief(FILE *fp, struct ndmsg *r, struct rtattr *tb[])
+{
+	if (!filter.index && r->ndm_ifindex) {
+		print_color_string(PRINT_ANY, COLOR_IFNAME,
+				   "dev", "%-16s ",
+				   ll_index_to_name(r->ndm_ifindex));
+	}
+
+	if (tb[NDA_DST]) {
+		const char *dst;
+		int family = r->ndm_family;
+
+		if (family == AF_BRIDGE) {
+			if (RTA_PAYLOAD(tb[NDA_DST]) == sizeof(struct in6_addr))
+				family = AF_INET6;
+			else
+				family = AF_INET;
+		}
+
+		dst = format_host_rta(family, tb[NDA_DST]);
+		print_color_string(PRINT_ANY, ifa_family_color(family),
+				   "dst", "%-40s", dst);
+	}
+
+	if (tb[NDA_LLADDR]) {
+		const char *lladdr;
+
+		SPRINT_BUF(b1);
+
+		lladdr = ll_addr_n2a(RTA_DATA(tb[NDA_LLADDR]),
+				     RTA_PAYLOAD(tb[NDA_LLADDR]),
+				     ll_index_to_type(r->ndm_ifindex),
+				     b1, sizeof(b1));
+
+		print_color_string(PRINT_ANY, COLOR_MAC,
+				   "lladdr", "%s", lladdr);
+	}
+
+	print_string(PRINT_FP, NULL, "%s", "\n");
+	close_json_object();
+	fflush(fp);
+
+	return 0;
+}
+
 int print_neigh(struct nlmsghdr *n, void *arg)
 {
 	FILE *fp = (FILE *)arg;
@@ -337,6 +382,9 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 	else if (n->nlmsg_type == RTM_GETNEIGH)
 		print_null(PRINT_ANY, "miss", "%s ", "miss");
 
+	if (brief)
+		return print_neigh_brief(fp, r, tb);
+
 	if (tb[NDA_DST]) {
 		const char *dst;
 		int family = r->ndm_family;
@@ -412,7 +460,7 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 
 	print_string(PRINT_FP, NULL, "\n", "");
 	close_json_object();
-	fflush(stdout);
+	fflush(fp);
 
 	return 0;
 }
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index c9f7671e..3f572889 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -227,7 +227,7 @@ print human readable rates in IEC units (e.g. 1Ki = 1024).
 .BR "\-br" , " \-brief"
 Print only basic information in a tabular format for better
 readability. This option is currently only supported by
-.BR "ip addr show " and " ip link show " commands.
+.BR "ip addr show ", " ip link show " & " ip neigh show " commands.
 
 .TP
 .BR "\-j", " \-json"
-- 
2.25.1

