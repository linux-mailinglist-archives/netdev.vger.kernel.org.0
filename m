Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA41E35B5CC
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbhDKPEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbhDKPEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:04:34 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEFC061574;
        Sun, 11 Apr 2021 08:04:18 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u17so16092165ejk.2;
        Sun, 11 Apr 2021 08:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oU9M0yEQA82+X1/ZR45YbPir+XlGNryVAzw61jdT/10=;
        b=HrvwYiEiwSwJ74cCd24Sb7zSz2skg4nAG8HJbySNYh7Tp9nm9PVsyKj5LWQ8UrXTRk
         L6CT+v4JCBynL/1kqpOeEsDkMLMLpZed1RDkkDup4l7gayYrh4Raphs9PV4wCzEhm0t/
         vZh8q7FT/QTZqbeAexiZYmh0bxk7jHW61a7aHK7b7mU+AaAZJiXrKBca0M8o6b8D49s+
         +qINJdIkfwcW6CFRZaL7tGwoog/USaG6QrIXQVkfyEOBYEp7UcM4fz6gSciAzCzWVUAO
         KdrPFk99tlS6mA43nIiOGu2P6a8XXepaiVn5aiVJ7DpLOrpx6fCnH2W0DsGF94b2on7O
         KhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oU9M0yEQA82+X1/ZR45YbPir+XlGNryVAzw61jdT/10=;
        b=J6X5LLMC12dPCY26WWB5yHHTfRa9WztuGiXVAg8NVuL73WQCbyBj5FztguD5VQNWIZ
         Esjvt9XL92rY/MUesL0VhomKT3R6b/G6yNzj1Z/NVuJ9qu8aS6KWv3NkZffUgLjP/wbA
         zkkj43yJjCwX23F0FH71H7NodGeaP+HRLRzIA+ZII6YrFBcFoD2jWTxiD1rRGfUqIK95
         h/RmlGKU2UHyJe5l4yXT7zMEA8GUMfGUTW4I/2TBxHll4fefLVIZfVlHh4p+PkcOUOGE
         N8lrbhe32uZrkEDWGLkFx+gMM6iqe5x7YQut65GrCKsTVQ5bqlJ8sWTmdCp8EOQ/Tyaz
         gUKg==
X-Gm-Message-State: AOAM533MXd7Ywx/28b4hUKAWexC6nzfIh4F/99noFUEwjPORK7eJVNV0
        HHAWecxsKDB1z2qHIjXjwo+Vlv0ncZJ5SQ==
X-Google-Smtp-Source: ABdhPJycWqTh/N5BnVH3cN12LfQtGqLdwSmVWqZabVn74d9LIie1KVyEOkbrYaYDk9xgYYp8+RVQ4A==
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr23674613ejx.324.1618153455791;
        Sun, 11 Apr 2021 08:04:15 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-95-239-254-7.retail.telecomitalia.it. [95.239.254.7])
        by smtp.googlemail.com with ESMTPSA id l15sm4736146edb.48.2021.04.11.08.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 08:04:15 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Di Zhu <zhudi21@huawei.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC iproute2-next] iplink: allow to change iplink value
Date:   Sat, 10 Apr 2021 15:34:50 +0200
Message-Id: <20210410133454.4768-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210410133454.4768-1-ansuelsmth@gmail.com>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to change the interface to which a given interface is linked to.
This is useful in the case of multi-CPU port DSA, for changing the CPU
port of a given user port.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink.c           | 16 +++++-----------
 man/man8/ip-link.8.in |  7 +++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 212a0885..d52c0aaf 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -579,7 +579,6 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 {
 	char *name = NULL;
 	char *dev = NULL;
-	char *link = NULL;
 	int ret, len;
 	char abuf[32];
 	int qlen = -1;
@@ -590,6 +589,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 	int numrxqueues = -1;
 	int link_netnsid = -1;
 	int index = 0;
+	int link = -1;
 	int group = -1;
 	int addr_len = 0;
 
@@ -620,7 +620,10 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				invarg("Invalid \"index\" value", *argv);
 		} else if (matches(*argv, "link") == 0) {
 			NEXT_ARG();
-			link = *argv;
+			link = ll_name_to_index(*argv);
+			if (!link)
+				return nodev(*argv);
+			addattr32(&req->n, sizeof(*req), IFLA_LINK, link);
 		} else if (matches(*argv, "address") == 0) {
 			NEXT_ARG();
 			addr_len = ll_addr_a2n(abuf, sizeof(abuf), *argv);
@@ -1004,15 +1007,6 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			exit(-1);
 		}
 
-		if (link) {
-			int ifindex;
-
-			ifindex = ll_name_to_index(link);
-			if (!ifindex)
-				return nodev(link);
-			addattr32(&req->n, sizeof(*req), IFLA_LINK, ifindex);
-		}
-
 		req->i.ifi_index = index;
 	}
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index a8ae72d2..800aed05 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -149,6 +149,9 @@ ip-link \- network device configuration
 .br
 .RB "[ " nomaster " ]"
 .br
+.RB "[ " link
+.IR DEVICE " ]"
+.br
 .RB "[ " vrf
 .IR NAME " ]"
 .br
@@ -2131,6 +2134,10 @@ set master device of the device (enslave device).
 .BI nomaster
 unset master device of the device (release device).
 
+.TP
+.BI link " DEVICE"
+set device to which this device is linked to.
+
 .TP
 .BI addrgenmode " eui64|none|stable_secret|random"
 set the IPv6 address generation mode
-- 
2.21.0


