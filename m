Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A033D4DB45C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357050AbiCPPKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbiCPPKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:40 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCC866AC0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:12 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id g24so2318583lja.7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=fyNU2eCNeOLALHX86vTF1cqLP/pZoHeuskOPoJW5eBQ=;
        b=SaZEgm/+AfZUnWYiV4Xqx27XlyzemoS3E1bma8/EK9tpZdNtBNdj1w2yc9fsINkNai
         Oze6ugraeS/kRxuYggNuqTzAhx8C48u1y4gR9hSYlVMa44WfrJDbODQ3XS/ASutj+9Bk
         U3ZxHDTp8cSrqjYs6s5jimFobalz89DT3jzEnYPDzI4+eicm/ex6FwNodql8fw8J7zWx
         fUL82Pce1n9lWSF9v2SOWtQpzqF5oiVxV4nD2NpVA4RN7Q/KNwysJnG2L07XjdoiX/fH
         s3pRb/bshI+T17J1QeHRkWJDRoZz3CpuasicvSVecDsbM8/piC9XxQelqzaRngpK+JyO
         qfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=fyNU2eCNeOLALHX86vTF1cqLP/pZoHeuskOPoJW5eBQ=;
        b=QkbquBqG6IxxnQ1JFl+mgGyBxs7qAk75qInHYwAMGh9/sKuWSGT8E1XysuIr5qEZNw
         LyepQEP4q4BEtc0PDbVL7Kh2dylFtw+8q/Z38g/2RTJgrNsOijjfcEMR7u//EeuyPhkn
         UtWiijHRb0K8ITWFlcfqNdNeDY7NX/ZEGOViST3dZvozYjERCiTF8ZKdea22LAcC4QxT
         fZljrjIA3Cp0ZR5d8AyS1Z8HMh9rfTYp30P8ed0EQgw8iEyrqW+XR0xEkBA2bj0cykWs
         SIbUCOmIV7o3yy6X/QawrwUo69qsicYplicF1R5FKT0hs+ki+e8s9OK75t+/9YGwQLCQ
         yIXw==
X-Gm-Message-State: AOAM531oIiEtuyIdpNWOYRCbuYAy7QZQ9SKTlZ4eRzASctsXTukzNe6C
        v1Wwh310aNxJVuCgXGYXNXIl1kdHMYuba1vW
X-Google-Smtp-Source: ABdhPJz+MdQ5oJn/MW+pIJfYWII0qOAOT+lZ5Tpo72GYAe+lHDiXtqb8fA0qafWnurm0WqUWiDfIJQ==
X-Received: by 2002:a05:651c:1594:b0:247:dce8:b0ec with SMTP id h20-20020a05651c159400b00247dce8b0ecmr79235ljq.404.1647443350883;
        Wed, 16 Mar 2022 08:09:10 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:10 -0700 (PDT)
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
Subject: [PATCH v5 net-next 04/15] net: bridge: mst: Notify switchdev drivers of MST mode changes
Date:   Wed, 16 Mar 2022 16:08:46 +0100
Message-Id: <20220316150857.2442916-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
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
 net/bridge/br_mst.c     | 11 +++++++++++
 2 files changed, 13 insertions(+)

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
index 5c1831c73fc2..43ca6b97c5c3 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/kernel.h>
+#include <net/switchdev.h>
 
 #include "br_private.h"
 
@@ -102,8 +103,14 @@ void br_mst_vlan_init_state(struct net_bridge_vlan *v)
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
@@ -119,6 +126,10 @@ int br_mst_set_enabled(struct net_bridge *br, bool on,
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

