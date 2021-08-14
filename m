Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2CD3EC49C
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbhHNSud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhHNSuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:50:32 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B48C061764
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:50:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so14093360pje.0
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 11:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7d1Of6Q0IHb2d2A0JAJ2UbdazS+8z9xR48ep8nqw7o=;
        b=fvd5WNiRoXdopwENdskP0i7XtulJ4FUbfmOzVcclKhy3ta+jK6StUolKE/IQXqUFA5
         0NZlctmkR/FgwzIZkUAItAtvKU4bGSi0TwWe4YOAs08tmGe90EmQ+/Pa7GAIv8Kyv5RR
         jeou72lxKcWUzXQwkFXfy9W6Noqpd4Sy0zTVUDmyoTm6igOTkN5Lzqzl9+VkufsunDTG
         KdEk22cS6UFPG0wRiDxXx3cL3j7PbERnnbgC4e6JgXcAxhs6LrIglYj8Dxo2aemNocs5
         AQ8gWK5ntyq23VzCVDYvybp9MqIG3I/kKZWLCfjvdOtnwJGdA39/flHVKVBWauTbNqIT
         wCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7d1Of6Q0IHb2d2A0JAJ2UbdazS+8z9xR48ep8nqw7o=;
        b=Pmuvwf9ZCo72Kn3m4Qw2z02gKFzD2VXpnDp+ZKMgJQVP5/9u0+fnc4PoOiWhv6hL6Y
         rfb5T8p6lW9jSsYmUYVz7qTOruTe5+utvOawterCkUgRL23HP+9QSqPcg6toR0DLaieN
         LjyTlBKT894ZrsjEFlZgaU2PB4QPzxRwv8nCh+I9RhXDUjE9ougWwSp7iLgw5FekuZ8w
         hkZ9onSXG92HeJ9aDoK08koX5HBjwJM8lTChCDQTcpRkYS6cQ21eGNayWsIPwBamf164
         WfWT0h3tIjWfQvVqS5Kvzwdl8JIKEjmcC7/aJWQ3f2DlTMQJDUMcgYCYFczFyqe9/A7l
         Hj+w==
X-Gm-Message-State: AOAM530eXPfPF+IW032uadzpbqucv40pXypBY3L7i/CfWge7BvEfyeQo
        bEKLNM9p+mFVuB43nn0t8qvBQ9OCBbWTLTSm
X-Google-Smtp-Source: ABdhPJyK/kxgLpRUoNvlS+DKw1k4sHeOqcFMIERah6yl9qhObixEoyh1WsF5AI3moMo6u44PPHZ2nA==
X-Received: by 2002:a17:90b:a12:: with SMTP id gg18mr8289973pjb.78.1628967003079;
        Sat, 14 Aug 2021 11:50:03 -0700 (PDT)
Received: from lattitude.lan ([49.206.113.179])
        by smtp.googlemail.com with ESMTPSA id r16sm5294736pje.10.2021.08.14.11.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:50:02 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2-next v2 2/3] bridge: fdb: don't colorize the "dev" & "dst" keywords in "bridge -c fdb"
Date:   Sun, 15 Aug 2021 00:17:26 +0530
Message-Id: <20210814184727.2405108-3-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814184727.2405108-1-gokulkumar792@gmail.com>
References: <20210814184727.2405108-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be consistent with the colorized output of "ip" command and to increase
readability, stop highlighting the "dev" & "dst" keywords in the colorized
output of "bridge -c fdb" cmd.

Example: in the following "bridge -c fdb" entry, only "00:00:00:00:00:00",
"vxlan100" and "2001:db8:2::1" fields should be highlighted in color.

00:00:00:00:00:00 dev vxlan100 dst 2001:db8:2::1 self permanent

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 bridge/fdb.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 37465e46..ea61f65a 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -192,10 +192,14 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 				   "mac", "%s ", lladdr);
 	}
 
-	if (!filter_index && r->ndm_ifindex)
+	if (!filter_index && r->ndm_ifindex) {
+		if (!is_json_context())
+			print_string(PRINT_FP, NULL, "dev ", NULL);
+
 		print_color_string(PRINT_ANY, COLOR_IFNAME,
-				   "ifname", "dev %s ",
+				   "ifname", "%s ",
 				   ll_index_to_name(r->ndm_ifindex));
+	}
 
 	if (tb[NDA_DST]) {
 		int family = AF_INET;
@@ -208,9 +212,12 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 				  RTA_PAYLOAD(tb[NDA_DST]),
 				  RTA_DATA(tb[NDA_DST]));
 
+		if (!is_json_context())
+			print_string(PRINT_FP, NULL, "dst ", NULL);
+
 		print_color_string(PRINT_ANY,
 				   ifa_family_color(family),
-				    "dst", "dst %s ", dst);
+				   "dst", "%s ", dst);
 	}
 
 	if (vid)
-- 
2.25.1

