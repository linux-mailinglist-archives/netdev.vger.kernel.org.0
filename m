Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564514D9165
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbiCOA1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343827AbiCOA1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96EE3D1CC
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:31 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id b28so18493741lfc.4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=G7oQe2cpTDpisPCmbwC7oQE+H3DLD/kOIxG11vmN0kE=;
        b=AWIOUkmA5DjJERUOTnY8KYJSVBNhBmn10maOhYm7Zi5sCALL2TIJzVv5C8ji7X+f7J
         n+QCz18Kt0u2U7lc+kdMld4egNuEPSzVMg0yIxBSQ4YBFYnQ2U6T/X5eFsZvhJXIHGIz
         psJBtt0oYRTGzbSOA8NGuTgpR/j3jawr2q37s+15L65O95Ce6PIiGUfPepqB+68/Pf5Q
         sg0p6aM9m9AswDVEtQwfT1FOJJ7wNYSZ2BwMdd/ptkq0DO6d2CilHPOTLhBj+5ztY9ol
         3uONDBxqpVTfLhvJdTGJOagpeBbowAPxz25cFjdmH+Es46gGIqPmGzpslzU+j8pgp3PS
         0+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=G7oQe2cpTDpisPCmbwC7oQE+H3DLD/kOIxG11vmN0kE=;
        b=Uz2zf2d/unDcaNaRig3uHCAnpyV/TdlyRY06If2z+S5llQC7I4LfFEXiMbf/aqwjEn
         xzPOKhEufZjtf2r3JYl6VQTMMkGymyVDdwlk2hT0z7yTrVztiZqD7fjGxh667D56JJPN
         jnaESU05Lp+c85TDRF7hkVBPsaoJZUUyruoC4sMakIVRQDKtHbmSDc3iKaGqLN74SuRe
         tcDSOX42BB92ZgkVW83gkeBPrcKrDNGvjw/UJvcDDZFllSTWur50XZSYZz+P4F8/yNAf
         BRNMuFVg04MV/fQwmRwa02ZAij4Z6c5RQxjIffBHdnjsPn6KY23FPntcntjUiyHKVFZM
         w/gg==
X-Gm-Message-State: AOAM533oHY3zCYB8VEmwHjtT7bgfdOdqwUsFn0U4apHhZHjFGDh+XzJM
        AoeE6Gmsih5K6RQ6hPPbpCBLUUpgXmeXprDNWyg=
X-Google-Smtp-Source: ABdhPJzFM4jL8KrSEsv+hsUuGMrWsuSvBnEnX6co+4dxfPjT4sHEide62i9GJVlYEhJOp9yCRqEK6Q==
X-Received: by 2002:a19:654c:0:b0:448:2649:1169 with SMTP id c12-20020a19654c000000b0044826491169mr14396738lfj.555.1647303990237;
        Mon, 14 Mar 2022 17:26:30 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:29 -0700 (PDT)
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
Subject: [PATCH v4 net-next 10/15] net: dsa: Validate hardware support for MST
Date:   Tue, 15 Mar 2022 01:25:38 +0100
Message-Id: <20220315002543.190587-11-tobias@waldekranz.com>
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
index 647adee97f7f..879d18cc99cb 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -463,6 +463,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
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

