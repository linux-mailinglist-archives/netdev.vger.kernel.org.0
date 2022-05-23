Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B24B530F38
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiEWKno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiEWKnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB0749F11
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id f9so27956400ejc.0
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=50niX/FM4H+njvGscV8qhuvnFKUkuRbOE6cNDO+7lms=;
        b=Y+dk4ydtwlOWmKVU9EFl01/ndztmUGbKsYKIWX5bHhvWYgUvPjDcAdN5S+1/Z4nobv
         3YSz5OVyS/IDuIWc6bvKC7ay/3xwJB1futK5ID7XICecNhKi16011evZ7eAtNfDjrdrg
         lwbaUwVzqgXtJZgEf3ia1iqBSGyxx80DKRd+iZnzRLyb7W/ye7/rEdcok3a6LtppvxVR
         6gaDL/jIiOMvK0V2EI4v69ZeL5BtsORAU3OE6tFDLrZeJbouDjVotuKE3H+0832NnnqV
         2whxzoU/t/G0IY8ueWV/I2gncrg4SIgxrdlmzyEOPvBiJtHrKnSltEQjBd/YrxAWqVHv
         JBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=50niX/FM4H+njvGscV8qhuvnFKUkuRbOE6cNDO+7lms=;
        b=ZbI4s8VkNE+LMT5hosA3ituBGmwWMrje5b688mWfKDzAheklZWNn+elhAiO3pNfvEW
         4Si5yoOR6mT+hMNMcxn0FbSih97GLpLUibqJhJUAXj53IwvzZxWvk+U+dgjxr3i15co1
         opfbgOkxDxH45g6RW9KbWKC6SZSNI92b0wEmD9e7EC14cKS4RBOUN92ZWnokY3MpMXGs
         ZRqdn5FlGKHlRwrevL7qjPVvkCvW/50vBDXPPYgL003XJo3XDCfYsTtb0k+fEAh7wxCV
         vSacGfQMoNyxCnqVgQmpyBAFUZnuEYxQDs8paKJqNRbmLs9EBrO2nJZsk53NVZ+2j8HO
         xUGg==
X-Gm-Message-State: AOAM532ifjocRypSi4Q7+Xz+ZS38Uo26ICzRtn8OKxV5/rSgtyDSeXEK
        08k9YIFq12G8P4BcUmS8Ircg68aKIUk=
X-Google-Smtp-Source: ABdhPJzDGCsHfdOeTPzHSzrdo1GJt2lJYWBK6tpAWa8XhIdQHgAWgHEq8dvTswB3CZENEqEAKF4d8w==
X-Received: by 2002:a17:906:f24f:b0:6fe:9b70:6d63 with SMTP id gy15-20020a170906f24f00b006fe9b706d63mr17634645ejb.255.1653302594684;
        Mon, 23 May 2022 03:43:14 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 07/12] net: dsa: all DSA masters must be down when changing the tagging protocol
Date:   Mon, 23 May 2022 13:42:51 +0300
Message-Id: <20220523104256.3556016-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The fact that the tagging protocol is set and queried from the
/sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
the single CPU port days which isn't aging very well now that DSA can
have more than a single CPU port. This is because the tagging protocol
is a switch property, yet in the presence of multiple CPU ports it can
be queried and set from multiple sysfs files, all of which are handled
by the same implementation.

The current logic ensures that the net device whose sysfs file we're
changing the tagging protocol through must be down. That net device is
the DSA master, and this is fine for single DSA master / CPU port setups.

But exactly because the tagging protocol is per switch [ tree, in fact ]
and not per DSA master, this isn't fine any longer with multiple CPU
ports, and we must iterate through the tree and find all DSA masters,
and make sure that all of them are down.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c     | 10 +++-------
 net/dsa/dsa_priv.h |  1 -
 net/dsa/master.c   |  2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ec0df4e498d6..4f0042339d4f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1235,7 +1235,6 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
  * they would have formed disjoint trees (different "dsa,member" values).
  */
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops)
 {
@@ -1251,14 +1250,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
 	 * restriction, there needs to be another mutex which serializes this.
 	 */
-	if (master->flags & IFF_UP)
-		goto out_unlock;
-
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_port_is_user(dp))
-			continue;
+		if (dsa_port_is_cpu(dp) && (dp->master->flags & IFF_UP))
+			goto out_unlock;
 
-		if (dp->slave->flags & IFF_UP)
+		if (dsa_port_is_user(dp) && (dp->slave->flags & IFF_UP))
 			goto out_unlock;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..cc1cc866dc42 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -545,7 +545,6 @@ struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
 void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2851e44c4cf0..32c0a00a8b92 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -307,7 +307,7 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 		 */
 		goto out;
 
-	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, new_tag_ops,
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, new_tag_ops,
 					old_tag_ops);
 	if (err) {
 		/* On failure the old tagger is restored, so we don't need the
-- 
2.25.1

