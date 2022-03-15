Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D84D916A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343802AbiCOA2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343804AbiCOA1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:37 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCB33D1C4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:25 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id y17so7215985ljd.12
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=tVCBhw08qNLsuFlkkOFuU98rHtIBmvXy+B80j+Mh3AE=;
        b=Ajad6Ng/K4St+Mej1wNaeU0DUSLAHoVfY9FQknmR5yYT0J2LcN3B5EM38Y2C3t3imY
         DbiPOzt1npZVsybU3zpIYM8hNYVIdjsYWnnbUqdYZ5vg9LWKRabomUcnwD6JbOG3TKe5
         mvT4PRWZ9xYkrofAinDjQUW0N+bGJmIPBmqwVIKminAXhqLaOwpdMJQL6f/b6I874Fgu
         v5ijsBCze+REVPVoAM3kDLD3VjRUm6vGDcXuSem9gkFP8igNTzYssJ9/JO2NrWrlju+1
         wLSY2JQ5qqwauprBlQWxdRuTLviVvn0kHAkywTUR2zefTfDQ0/FZyoHXO5jBG7dUVUxR
         RPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=tVCBhw08qNLsuFlkkOFuU98rHtIBmvXy+B80j+Mh3AE=;
        b=nSEuET8hIr4piQiHyCkyASErPsIfdDv8F6IdpxmQBdmcK14BLsA74yzwuaPQui/wZ9
         JyQPbRo4ratLZhUquHM+tQErLj/bM3tbouAqOTnH5+otFChaIWOMKVyu1qrgqtqToZCo
         X/h4vPctP6xFZycdNP8i4cu9c95j5JmPBD1Rwrl/l5rF6JVGqUeXAbh8tAPf3QevWmaM
         O/A/i/oF6kIXBe6UNzXfroLeR27YlvNI1Rd/3CZEdA1tpztptnH6mO6JwNjd5/VT9Tq+
         C2E5gVuKaJHNWSBQmJH7ZX9/WyP6hHPnr+UrX92zOGrTEhhkriaebodP5Mvkfwxo+sIO
         Trjg==
X-Gm-Message-State: AOAM530tOAAdkILHQH/TitXUdP4xuMpPsoxnHv66HexlgGPVWIHfWwG4
        q5rde5d9/kci6Ruwe1TtbmhpcA==
X-Google-Smtp-Source: ABdhPJzppm1HhRODkPhFyEPM5GPn/loX/IjWJz3NXCgwfrnKfb6+haIfNXipONdnWjQVMhCmDPjohw==
X-Received: by 2002:a05:651c:179c:b0:247:e1b4:92aa with SMTP id bn28-20020a05651c179c00b00247e1b492aamr15717879ljb.55.1647303984167;
        Mon, 14 Mar 2022 17:26:24 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:23 -0700 (PDT)
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
Subject: [PATCH v4 net-next 04/15] net: bridge: mst: Notify switchdev drivers of MST mode changes
Date:   Tue, 15 Mar 2022 01:25:32 +0100
Message-Id: <20220315002543.190587-5-tobias@waldekranz.com>
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

Trigger a switchdev event whenever the bridge's MST mode is
enabled/disabled. This allows constituent ports to either perform any
required hardware config, or refuse the change if it not supported.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/switchdev.h |  2 ++
 net/bridge/br_mst.c     | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 3e424d40fae3..85dd004dc9ad 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -27,6 +27,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
+	SWITCHDEV_ATTR_ID_BRIDGE_MST,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 };
 
@@ -48,6 +49,7 @@ struct switchdev_attr {
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
+		bool mst;				/* BRIDGE_MST */
 		bool mc_disabled;			/* MC_DISABLED */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
 	} u;
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 355ad102d6b1..051b9358946b 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -99,8 +99,14 @@ void br_mst_vlan_init_state(struct net_bridge_vlan *v)
 int br_mst_set_enabled(struct net_bridge *br, bool on,
 		       struct netlink_ext_ack *extack)
 {
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_BRIDGE_MST,
+		.orig_dev = br->dev,
+		.u.mst = on,
+	};
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_port *p;
+	int err;
 
 	list_for_each_entry(p, &br->port_list, list) {
 		vg = nbp_vlan_group(p);
@@ -116,6 +122,10 @@ int br_mst_set_enabled(struct net_bridge *br, bool on,
 	if (br_opt_get(br, BROPT_MST_ENABLED) == on)
 		return 0;
 
+	err = switchdev_port_attr_set(br->dev, &attr, extack);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	if (on)
 		static_branch_enable(&br_mst_used);
 	else
-- 
2.25.1

