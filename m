Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740054DB45E
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357063AbiCPPLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357061AbiCPPLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:11:03 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A782F674C6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:18 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id e6so4289145lfc.1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=akWzYrIA0f7A74GU4gqxjh8xdXZeuUVFKu3EYBQU0u8=;
        b=5WCup1a1iZIhs6zKsDXNRtYiF+OmuSJenUiuhmrGMbgRY2VLwJEBUpkIv4WJZavNsG
         Li67VLDKgBwFlZAuviq670EL7VcNtfKUKkX44EYzda+3gd1yVkxcExaN+6F/yhPpmJHN
         vaEkjBUdAal3Uu/zxHVjZpqKA4gLOdYaz3bFDXPEr6uU5+405HHkzE4GB4omBcdKUPMR
         uA10X0CygKXZFgOFCIy5Jrm40jdf//jSpuMWLMXsEpb6Dvv41iM3bnfiL3R3LFsYcDtA
         gPrPy7pC6uKk+y1pj4Vs4N+SXANsU89aeiPDVnA5WXyPPfeBAu/42HZ5WTnhLXdvC2ai
         sZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=akWzYrIA0f7A74GU4gqxjh8xdXZeuUVFKu3EYBQU0u8=;
        b=nyE2VWirqusphGupEkNnx7WEjy/AXXqHR4XjBxB7QaTx8uyGD7TF5ha+VKqR8xJeMh
         V38w044bhqYcYwJ/EUyueDYwVKn+lp7xeKIy/LmcD4TvywK7fyxlusNO+KTL7kVHgd54
         Eyxu6RPeOk/j3YQ+zNBaI9ADpRHB8ceIFfSowyagiDk/t7DgUSVBUzasXT0rSOa4pYSl
         5SADvAcPP6QDBx0sxz2GIqKI+eOk0y97DvtWICSlpPA9c0Q/iqy/2AGSQWHP0Ru39/JQ
         +49aP2ieVyBLf52TljEXdNnBsS/yzqe8xNEtPm6LA8E6zNOlYjrbHQgORJKibuE9IuNS
         vZ3A==
X-Gm-Message-State: AOAM532kN0Z5/q7zxD/UEiQxWOKO65VBa1+lJ6gBqOEpwqBC4ER/tKit
        7fENcwrwGdCK2JICE/sv7j7PxQ==
X-Google-Smtp-Source: ABdhPJxqAc8yTfQ9oDPedAeCVnAEX41Q9ElvytjZastGmNlW4og36AabxVaLx4eCo2wHcB9ZzvmoFg==
X-Received: by 2002:a05:6512:455:b0:448:24a7:a241 with SMTP id y21-20020a056512045500b0044824a7a241mr95256lfk.208.1647443356545;
        Wed, 16 Mar 2022 08:09:16 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:16 -0700 (PDT)
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
Subject: [PATCH v5 net-next 10/15] net: dsa: Validate hardware support for MST
Date:   Wed, 16 Mar 2022 16:08:52 +0100
Message-Id: <20220316150857.2442916-11-tobias@waldekranz.com>
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

When joining a bridge where MST is enabled, we validate that the
proper offloading support is in place, otherwise we fallback to
software bridging.

When then mode is changed on a bridge in which we are members, we
refuse the change if offloading is not supported.

At the moment we only check for configurable learning, but this will
be further restricted as we support more MST related switchdev events.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 22 ++++++++++++++++++++++
 net/dsa/slave.c    |  6 ++++++
 3 files changed, 30 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f20bdd8ea0a8..2aba420696ef 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -234,6 +234,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
+int dsa_port_mst_enable(struct dsa_port *dp, bool on,
+			struct netlink_ext_ack *extack);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 58291df14cdb..02214033cec0 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -321,6 +321,11 @@ static void dsa_port_bridge_destroy(struct dsa_port *dp,
 	kfree(bridge);
 }
 
+static bool dsa_port_supports_mst(struct dsa_port *dp)
+{
+	return dsa_port_can_configure_learning(dp);
+}
+
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 			 struct netlink_ext_ack *extack)
 {
@@ -334,6 +339,9 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	struct net_device *brport_dev;
 	int err;
 
+	if (br_mst_enabled(br) && !dsa_port_supports_mst(dp))
+		return -EOPNOTSUPP;
+
 	/* Here the interface is already bridged. Reflect the current
 	 * configuration so that drivers can program their chips accordingly.
 	 */
@@ -735,6 +743,20 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	return 0;
 }
 
+int dsa_port_mst_enable(struct dsa_port *dp, bool on,
+			struct netlink_ext_ack *extack)
+{
+	if (!on)
+		return 0;
+
+	if (!dsa_port_supports_mst(dp)) {
+		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 			      struct switchdev_brport_flags flags,
 			      struct netlink_ext_ack *extack)
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f9cecda791d5..2e8f62476ce9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -464,6 +464,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MST:
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_mst_enable(dp, attr->u.mst, extack);
+		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
-- 
2.25.1

