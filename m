Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC654D9168
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343869AbiCOA1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343822AbiCOA1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:44 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBEE41323
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:30 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id b28so18493631lfc.4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=aeFHqUQf014JdNM8SnwjKE1NY0OOpsJ45a5c0nxth/A=;
        b=zllb7l3VfNci4jRgZoBvkq+a/alefJj1HmF1O+MuOP5bKBdakeaFt2hvTv9GVm5E36
         cGHNOnXp7puxzQjNDEMw0eo7HwHgZDxZN9KYZKtV9xrUjvqpbARyHlPMprgPEYK0UcWF
         IZWtEtapMPZJkb+UqKwNlMfLvQJ//blW1Ao9f/yz7qFmI8P16SjIBAuJ01XbwRhs07hU
         kFIQCERqtjA6qilc+zFllPtQUKr5wHpXMgds8AJWpfi2URYYbDt58hoM7z/SmjVSn1V9
         7KhrnK/U5SW1Cl3mNYuGKkoc5ln/0+WHThIMueKH0ZRGleLc8iNaLrLMdEQ1RhwyAKnT
         p+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=aeFHqUQf014JdNM8SnwjKE1NY0OOpsJ45a5c0nxth/A=;
        b=1EvII95lF5k8NyHYLUQdkc81VMSHnz5gIU5zM0M6xioi6xmIlT9Am8POpxWY/6WQWK
         1HueIu178ZyjbLwVaSoVSg9MRAXSk8/c/76BQThH+iEBRyaszl6HHX/+jXlEn2suuy7J
         PEuKSXAuSBc48voS7YyKwnAAvcQPIS05oMGeqNpXpWIxBRA6GZf48ib6aL9DILAOYWxT
         9FWh0FLIKf3eJWfiwk3KzP3txBvQiaB6c0jbs70VI+s8NPz9I7R8o0yH2y5ojY57nOmE
         xnS/Z/Y3jnC3dKWqItee+l2rZAJtyVuIwdGOuHisyVGVGTVE1UtDHgFwPAX+L/TjvUIG
         u6Ww==
X-Gm-Message-State: AOAM532ce0zdI8rZSfRQO0dQkdzBNkqhwT7ZDHxUxd0gETjKJlBxNQ3i
        17Z72omi8SEqX+7PFuMDnENPQA==
X-Google-Smtp-Source: ABdhPJwRUPdbjyr9jI+vbGfd0hMI1Zk0tfb4D2YJsvTHmK1dHpYqtCC8gGUazwhBd8bZXM0rYo60qA==
X-Received: by 2002:a05:6512:3f0d:b0:443:5f35:6360 with SMTP id y13-20020a0565123f0d00b004435f356360mr14602572lfa.661.1647303988309;
        Mon, 14 Mar 2022 17:26:28 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:27 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v4 net-next 08/15] net: bridge: mst: Add helper to check if MST is enabled
Date:   Tue, 15 Mar 2022 01:25:36 +0100
Message-Id: <20220315002543.190587-9-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315002543.190587-1-tobias@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is useful for switchdev drivers that might want to refuse to join
a bridge where MST is enabled, if the hardware can't support it.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h | 6 ++++++
 net/bridge/br_mst.c       | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 1cf0cc46d90d..4efd5540279a 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 			 struct bridge_vlan_info *p_vinfo);
+bool br_mst_enabled(const struct net_device *dev);
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
@@ -153,6 +154,11 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 	return -EINVAL;
 }
 
+static inline bool br_mst_enabled(const struct net_device *dev)
+{
+	return false;
+}
+
 static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
 				  unsigned long *vids)
 {
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index f50625a60b7e..fe0b807d46f2 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -13,6 +13,15 @@
 
 DEFINE_STATIC_KEY_FALSE(br_mst_used);
 
+bool br_mst_enabled(const struct net_device *dev)
+{
+	if (!netif_is_bridge_master(dev))
+		return false;
+
+	return br_opt_get(netdev_priv(dev), BROPT_MST_ENABLED);
+}
+EXPORT_SYMBOL_GPL(br_mst_enabled);
+
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
 {
 	const struct net_bridge_vlan_group *vg;
-- 
2.25.1

