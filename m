Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140DE54A981
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351771AbiFNGce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiFNGcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:32:31 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D541C23B
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:32:27 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t25so12298261lfg.7
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-disposition;
        bh=bpDA/8HCyR0vlKavnt82QPftLcL/p7VlaeF5k8zFxxw=;
        b=oiiHx6OuWWPJTptM7WTl7D12y0ojPdv+Ylb/8ZRdPrKZV0w2Q3NXUKzJMQ+02qN18a
         C4w3qi7sdYGr7ynXOBQNhZVxAAmJTc5GaODcpQSZDzwHurEVihCtN9HgbHFjrrLFJAqY
         6lfN5TxfnV0OWgBJGuiOrTdYhaPQpilPGjJCNUj44vju1yz6P+GhnbULYscFNKVPIZj7
         F385jYEjg9pjHvDs/cMRI8Z9uxAlIHE5x2goiXSiG2u1Yl1XtpLxzvDEaw9xDx5ZbMw4
         ulYnyYyVrvfGE61+rPNvH+f6dPI12AGFVHJeBSzKdobqrVG9s4vPXcSfwsNVH+znf/O5
         CJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-disposition;
        bh=bpDA/8HCyR0vlKavnt82QPftLcL/p7VlaeF5k8zFxxw=;
        b=2Sgnqb+Ojui6Z7tCE7VCcyCkZaJ3pJo5fQ2R+NPtBR2mise7q9Ihpe7uSTjCeL+GWP
         O76GgrTLvtZdKiilr9zR9gix67gHTyCKZtaiopawt79Dz6mkhveKJ3guwdxOQ5QCtLLb
         F5GRgxikrTOwxx8ndANE8r7pcH9ANsmMGXirDAaVK2T957v3+G1knOKI6Z829aPw0JDe
         zyCb5OJGXvyWVQ072YToi5CIy1kw9F+yr9p92Ur9OSgVlit7fnad6xKVDKbZ0sE2zN9W
         i6QDmV4SB5HKDVWrjXcxWEmvCxpOKqAs06cWEClgWvOg6x69eWMnQjuKawsGB99hXF8g
         n+kA==
X-Gm-Message-State: AJIora/6X2Uvlay2wyZ4zLd+HRe4x1aDwOA4B6cU7Q4lyonbctT1C7fo
        N6BEmdhsr6NNvUZdAJToL0U=
X-Google-Smtp-Source: AGRyM1v5E/q0W7sVa+QkEjHLP79C5wpIt8ImMXG0llaNwtQOZ5tA/XD6xmMCK4DzqUILcg2+u94TpQ==
X-Received: by 2002:a19:dc57:0:b0:479:5300:4e0e with SMTP id f23-20020a19dc57000000b0047953004e0emr2166165lfj.236.1655188345644;
        Mon, 13 Jun 2022 23:32:25 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id z10-20020a0565120c0a00b00477cc59e376sm1267757lfu.161.2022.06.13.23.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 23:32:25 -0700 (PDT)
Date:   Tue, 14 Jun 2022 08:32:23 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Eric Dumazet <edumazet@google.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH net-next] net: bridge: allow add/remove permanent mdb entries
 on disabled ports
Message-ID: <20220614063223.zvtrdrh7pbkv3b4v@wse-c0155>
Organization: Westermo Network Technologies AB
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding mdb entries on disabled ports allows you to do setup before
accepting any traffic, avoiding any time where the port is not in the
multicast group.

Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
 net/bridge/br_mdb.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index fdcc641fc89a..589ff497d50c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1025,8 +1025,8 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
 			return -EINVAL;
 		}
-		if (p->state == BR_STATE_DISABLED) {
-			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state");
+		if (p->state == BR_STATE_DISABLED && entry->state != MDB_PERMANENT) {
+			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
 			return -EINVAL;
 		}
 		vg = nbp_vlan_group(p);
@@ -1086,9 +1086,6 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry,
 		if (!p->key.port || p->key.port->dev->ifindex != entry->ifindex)
 			continue;
 
-		if (p->key.port->state == BR_STATE_DISABLED)
-			goto unlock;
-
 		br_multicast_del_pg(mp, p, pp);
 		err = 0;
 		break;
@@ -1124,8 +1121,14 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -ENODEV;
 
 		p = br_port_get_rtnl(pdev);
-		if (!p || p->br != br || p->state == BR_STATE_DISABLED)
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Net device is not a bridge port");
+			return -EINVAL;
+		}
+		if (p->br != br) {
+			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
 			return -EINVAL;
+		}
 		vg = nbp_vlan_group(p);
 	} else {
 		vg = br_vlan_group(br);
-- 
2.30.2

