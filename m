Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2CB4D9162
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343839AbiCOA1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242791AbiCOA1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:43 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D292841304
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:28 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id bn33so24331224ljb.6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=S0uf403y5pA6c17GdYe3Paoa8iItkzcnykjXIbZRnYM=;
        b=tpDgUOqjwHD8vl9zPFuAoAgMa+MpKZLTPSjugdhT90HWIXW35dPqKYUkNYY6OrBEGX
         KF7zVFjA+jVW6IfkCJHx9X0NoNlufnrGtDb8W5utjV17pZv8wMelCEQOix3EAhHtUmZf
         gs9Qjp6dLDZullEAF6iuyDK69u1JPrw8+jCtLBGmRSqqwqDGUhf1bQVpxdt+GbN/UiNd
         k/AObQqpLJfDGl1sef9R+O9bLXkUoLpsfKmbZAiWBObzBmB0wUUlF1kOofpxX6/t1x0A
         K/NArjN6XXOasgkw/4whBXsjqkO/9cdP8z6Bap6Zj+OYHheAXyC8glRrNePC/yC4VEnc
         Hmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=S0uf403y5pA6c17GdYe3Paoa8iItkzcnykjXIbZRnYM=;
        b=NOsEm5G0vLXaIAqQok4TE3Pp9j3kO94XAn7rsqN2FJVIzV5pZpZUjydQmGDo6T2lTG
         oCz9KgNZIeiBFT0uaioCTEFAEKPY5oQHNKGejdZu7imWnBUnONW8GHx0PQAYgDt6hJqN
         7sX3v74G5/k/DAqFVBhk7kzeLzx+mR2+9zYS3uLXwTYMnafDDVQUgohqjNkmh68BHjV2
         UbY6stkHc3vX04nfr2SoP1mhiKKzrKlYLf/8EC0nQ+SppW2Bcv3+ScSqP496SvyTTq87
         3c3VWCDH9coDvXWAllpiLnuYZ3IwnKP2zwuE4tTLA577P/CGTSRzZVLlHzkAzP9RJy5V
         yEHg==
X-Gm-Message-State: AOAM530HAPOsmpvZShgcyYpZnYiOGsOr4NRKZ03f78S/+bENjfCGPXgv
        zvHfyXc+5mXkZsuZHay4MkTcXQ==
X-Google-Smtp-Source: ABdhPJxTQAQhOc6GBXdK4Hh/+qkG5keiIQfweZnAQU07y65XnQTHFLdfPe6CBRJUUEVLUmIPOhxZuA==
X-Received: by 2002:a2e:87d7:0:b0:246:1466:c43b with SMTP id v23-20020a2e87d7000000b002461466c43bmr15761096ljj.279.1647303987190;
        Mon, 14 Mar 2022 17:26:27 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:26 -0700 (PDT)
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
Subject: [PATCH v4 net-next 07/15] net: bridge: mst: Add helper to map an MSTI to a VID set
Date:   Tue, 15 Mar 2022 01:25:35 +0100
Message-Id: <20220315002543.190587-8-tobias@waldekranz.com>
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

br_mst_get_info answers the question: "On this bridge, which VIDs are
mapped to the given MSTI?"

This is useful in switchdev drivers, which might have to fan-out
operations, relating to an MSTI, per VLAN.

An example: When a port's MST state changes from forwarding to
blocking, a driver may choose to flush the dynamic FDB entries on that
port to get faster reconvergence of the network, but this should only
be done in the VLANs that are managed by the MSTI in question.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h |  7 +++++++
 net/bridge/br_mst.c       | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 3aae023a9353..1cf0cc46d90d 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 			 struct bridge_vlan_info *p_vinfo);
+int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -151,6 +152,12 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
+
+static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
+				  unsigned long *vids)
+{
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index b92daca86513..f50625a60b7e 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -13,6 +13,32 @@
 
 DEFINE_STATIC_KEY_FALSE(br_mst_used);
 
+int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
+{
+	const struct net_bridge_vlan_group *vg;
+	const struct net_bridge_vlan *v;
+	const struct net_bridge *br;
+
+	ASSERT_RTNL();
+
+	if (!netif_is_bridge_master(dev))
+		return -EINVAL;
+
+	br = netdev_priv(dev);
+	if (!br_opt_get(br, BROPT_MST_ENABLED))
+		return -EINVAL;
+
+	vg = br_vlan_group(br);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->msti == msti)
+			__set_bit(v->vid, vids);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(br_mst_get_info);
+
 static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
 				  u8 state)
 {
-- 
2.25.1

