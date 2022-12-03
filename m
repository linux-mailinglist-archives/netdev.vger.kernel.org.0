Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A259641402
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 04:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiLCD3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 22:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiLCD3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 22:29:43 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637F8E08C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 19:29:42 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id f3so5913265pgc.2
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 19:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vcWwWpLmNHt2FY1UogwwEk6ssueE+FtaD3irCe/nJpg=;
        b=WKib0rlI7jX9hMLtmD+2EDMra8vFHWfm7Bsr+mo+0NaCggSEvHxskqHUswkXmfCSHX
         Hdxg2SayztXzuUqOT6eQi/Zb5ajVSGZEPT7845IHY98tBa2Q1bzQ6UzWy1Bm/1kJVnPm
         EDW0DyZOwyUmVLwx0HZaTjmCvjFaUz/XVGBnvhpdtMxbvmG6CEvfPWhV+ckWPFyYAQmW
         lYUl2YZrvtKf5/N2Dx00PRHYdXZPSWEKdGaTJqZObqR1M3g5x04sXgzLbHPN5GWll2B5
         ObnVHkZxXL1K0ApMyaew7beAYyoaNeIu+EgWjlFXPYlcVVECKNKcTznP8zEUUulhNFau
         TG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vcWwWpLmNHt2FY1UogwwEk6ssueE+FtaD3irCe/nJpg=;
        b=RJfAA9YoXFnjbgO8yADCvBSzYsKq1SFuxuKG+sUbMsTs829ydrA6UwcHwS4XjPtYnc
         ywwQtB0WJsdrekaJ/jCZL6wMtd+KRPJY+jnUD1LJVYF68202M6sflIPm7ZZQqR3nfNYQ
         jSt1QLH2RDgfDW5BH4raNpwSfCi+sL3rW5A5NZUG9R6KKjDyMkALWtkrMBQoW1LX8sVv
         stjp8GJOcM2v3Kr58fpypG52nb3EmBOCqoJHpHPZER4wpGCDSSH3c8C3+pp0WIjOhMxP
         YVZCyLcVUKgU7vgn8QC2kzu1umOU14Bot6Kjxvp4cd+A14+z+P5ZaZ8zhYoi8lkpD2Hc
         XxKA==
X-Gm-Message-State: ANoB5pku3Ei+1nhgjVg2Vv4gVFFWJx4/tNBbsmIRfxLDjJvOMkgFEuab
        7L3Xke/v2fUf/7LocgMgkZ3bU1MJ7vhHEA==
X-Google-Smtp-Source: AA0mqf66gJ0O1tmPdaARcvkgB0P9MEQngRO0gb3SnDrEKDPCVfZdukBz9nrtM1egOHQ1dd6kB+9Yqg==
X-Received: by 2002:a05:6a00:1d98:b0:56d:4670:6e2a with SMTP id z24-20020a056a001d9800b0056d46706e2amr64553941pfw.77.1670038181384;
        Fri, 02 Dec 2022 19:29:41 -0800 (PST)
Received: from localhost.localdomain ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y5-20020a17090a784500b002187a4dd830sm7202797pjl.46.2022.12.02.19.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 19:29:40 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        William Tu <u9012063@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jianlin Shi <jishi@redhat.com>
Subject: [PATCHv2 net] ip_gre: do not report erspan version on GRE interface
Date:   Sat,  3 Dec 2022 11:28:58 +0800
Message-Id: <20221203032858.3130339-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the type I ERSPAN is based on the barebones IP + GRE
encapsulation and no extra ERSPAN header. Report erspan version on GRE
interface looks unreasonable. Fix this by separating the erspan and gre
fill info.

IPv6 GRE does not have this info as IPv6 only supports erspan version
1 and 2.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: fix o_flags not passed to gre fill info, reported by kernel test robot
---
 net/ipv4/ip_gre.c | 48 ++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f866d6282b2b..cae9f1a4e059 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1492,24 +1492,6 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if (t->erspan_ver <= 2) {
-		if (t->erspan_ver != 0 && !t->collect_md)
-			o_flags |= TUNNEL_KEY;
-
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-			goto nla_put_failure;
-
-		if (t->erspan_ver == 1) {
-			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-				goto nla_put_failure;
-		} else if (t->erspan_ver == 2) {
-			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-				goto nla_put_failure;
-			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-				goto nla_put_failure;
-		}
-	}
-
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
 			 gre_tnl_flags_to_gre_flags(p->i_flags)) ||
@@ -1550,6 +1532,34 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	return -EMSGSIZE;
 }
 
+static int erspan_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+
+	if (t->erspan_ver <= 2) {
+		if (t->erspan_ver != 0 && !t->collect_md)
+			t->parms.o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else if (t->erspan_ver == 2) {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
+
+	return ipgre_fill_info(skb, dev);
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static void erspan_setup(struct net_device *dev)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
@@ -1628,7 +1638,7 @@ static struct rtnl_link_ops erspan_link_ops __read_mostly = {
 	.changelink	= erspan_changelink,
 	.dellink	= ip_tunnel_dellink,
 	.get_size	= ipgre_get_size,
-	.fill_info	= ipgre_fill_info,
+	.fill_info	= erspan_fill_info,
 	.get_link_net	= ip_tunnel_get_link_net,
 };
 
-- 
2.38.1

