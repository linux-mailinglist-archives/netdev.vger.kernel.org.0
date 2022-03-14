Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A894D7F3A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbiCNJzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbiCNJyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:54:23 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3C4369FF
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:53:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id w12so26014671lfr.9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=Xug1BH6fNokmYBfp1m7lmzVoHZRMKG6TmFS0A8AYQqI=;
        b=gvIFP34YAnZboyufyNgDvH4eWj9u+O+mpEkbj54ZArxII18gk06pWhM3nAr+JpQlOH
         c92qb9/6wGIGougMYSfZScMD7p/yyVvPutR3IlorBAGy4vZxZmrg7NnVWHRmqym/v3b+
         /9Nk4PRVz2twJrbxzq38jyUi3RmXqWkJuJKgMJvGuYGNQHSleNl7+bx2kqHJEjGkVeSH
         /y6BXoJK+LC3BR08K/77mH/rFZ08sdqBf+G936o3TWZBEp3kPOwm7/nIPOJpOWqqntWX
         q94NluUPApIEYrJsL1O6wRP0HTFlJey3CTdPz4Z7Jkkkzf4GhasZG22EUb6UnerSrKrM
         aykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=Xug1BH6fNokmYBfp1m7lmzVoHZRMKG6TmFS0A8AYQqI=;
        b=AtwhBvWoelzwRfWSEkGYwIUwa1ELpy2tDlCEKjZ2dLfim/N8WTF+Vpqxqx6vlLmzRs
         hzGULGMoM/CQSxokV/Z/99Zsgs2wtN6PgFSwZb3d7+wScIjMl6XycXfyW67typ4H+O8S
         IZ5IDnhuepviK8vZFotfOzUPqg3qroqgnmgv/FHsAm0YcUOpoZHUXJEsGe2+K6HWUhhd
         HGw+4ApQVo0s6q5kVTZOZiQ8Nzgm6jphH6NBZI4D1uiv1TqWWim2vJTwNdnBhveeXDxj
         SdyFT0OCH4Jc7H8pZGNTk2ho7qj0O7BA0HQF7njkZ22dKqraWzLHGhcLU4BZzVjVPXPS
         XDRQ==
X-Gm-Message-State: AOAM530cOizul3OauOLZJW7Wn8KBsakGcWWWiaUiqWxcqlHfvRoq0wPI
        WoI43Lq810bfIctcPPJ9dCaFnw==
X-Google-Smtp-Source: ABdhPJwU0M50Tvhi2qkouOipvP6AfZbTBMjqM+CPa4vA9VHX45AOikwvdLBQ0Afw88UlWhcEmJnHtw==
X-Received: by 2002:a05:6512:b03:b0:448:1e7c:8859 with SMTP id w3-20020a0565120b0300b004481e7c8859mr13565935lfu.110.1647251589737;
        Mon, 14 Mar 2022 02:53:09 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b3-20020a056512304300b004488e49f2fasm984870lfb.129.2022.03.14.02.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 02:53:09 -0700 (PDT)
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
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v3 net-next 10/14] net: dsa: Pass VLAN MSTI migration notifications to driver
Date:   Mon, 14 Mar 2022 10:52:27 +0100
Message-Id: <20220314095231.3486931-11-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220314095231.3486931-1-tobias@waldekranz.com>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
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

Add the usual trampoline functionality from the generic DSA layer down
to the drivers for VLAN MSTI migrations.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h  |  3 +++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 14 +++++++++++++-
 net/dsa/slave.c    |  6 ++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9d16505fc0e2..1ddaa2cc5842 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -964,6 +964,9 @@ struct dsa_switch_ops {
 				 struct netlink_ext_ack *extack);
 	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
+	int	(*vlan_msti_set)(struct dsa_switch *ds, struct dsa_bridge bridge,
+				 const struct switchdev_vlan_msti *msti);
+
 	/*
 	 * Forwarding database
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2aba420696ef..d90b4cf0c9d2 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -236,6 +236,8 @@ bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
 int dsa_port_mst_enable(struct dsa_port *dp, bool on,
 			struct netlink_ext_ack *extack);
+int dsa_port_vlan_msti(struct dsa_port *dp,
+		       const struct switchdev_vlan_msti *msti);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1a17a0efa2fa..f6a822d854cc 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -747,7 +747,8 @@ int dsa_port_mst_enable(struct dsa_port *dp, bool on,
 	if (!on)
 		return 0;
 
-	if (!dsa_port_can_configure_learning(dp)) {
+	if (!(ds->ops->vlan_msti_set &&
+	      dsa_port_can_configure_learning(dp))) {
 		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
 		return -EINVAL;
 	}
@@ -798,6 +799,17 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 	return 0;
 }
 
+int dsa_port_vlan_msti(struct dsa_port *dp,
+		       const struct switchdev_vlan_msti *msti)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->vlan_msti_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->vlan_msti_set(ds, *dp->bridge, msti);
+}
+
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 333f5702ea4f..cd2c57de9592 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -482,6 +482,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
+	case SWITCHDEV_ATTR_ID_VLAN_MSTI:
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_vlan_msti(dp, &attr->u.vlan_msti);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.25.1

