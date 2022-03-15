Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F294D9166
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343862AbiCOA1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343831AbiCOA1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE0C41603
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:32 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id l20so30124472lfg.12
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=fRo8wCl+tN06zy2NqVkO5/xxonQ/jWHccKeTEjzxNfI=;
        b=bllWpNbiRmEE+CK3V7xZ4paKx1F9Mk+OKAnEM86DuBObpcblQIwEsZJlfUUP4EajJ0
         kSHT5ox+4Tp9DtIgzZ0D6vxLVPBVP4Qr76vKXJ0ggJc/5X1gsX9YwUkZDC5II974vOwv
         wykxT0iBfzL6riXdJhhuHIZsqXe250S1CJEXX/yP2zvq10YWTa+HB5D7htI68+N/2BiM
         qyxol81HGUQnXwjAhrj0lXgmY/Nl3+4syfCCFY/mwf/JztSJ7NukjXpb7ztjzABp3YqI
         NoS1UVxZHFJKoSU9tJRgM46inBgfBCBLzg1eItodg7VZzv1U8ObfPLAZkvOMT7fKfZiG
         KImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=fRo8wCl+tN06zy2NqVkO5/xxonQ/jWHccKeTEjzxNfI=;
        b=X2TdZ0SoDq9pzpaw0U1qIYU5OxUCeSlue+FWhQ8uHjiMpdw8DwCKqCyuW6Aj5mGJeM
         SxIFRURVMNoFJssZTlH8lAVCRNlO6zNcvd0F9x0b0QwAkAWCLR1OngJIsnasqrlRFR55
         Ft9J9i+lID5UjBYgKkvv1Q/aVs/e10GJ7NIYkhfmIqTXn7XEZXH6dymtg9lbzTLaYRZ3
         PbRcvpdB/tUathCpi+VOtEuzi7NVDxnGlFNtMk3z0lelw3VCX3K/THjfUjKFdP/YkDno
         tmxQGOVi4GE+TCZYBjfSNdRstCeAblFmw59emmc6gH5bvf5upyXDR9qMv5IQcXnlfIla
         qRBg==
X-Gm-Message-State: AOAM5327zYayYIyVyHLCguErWqEndnEiOojkUsjJFqvFW9/5SnLQSrqs
        zoGiX3+8HTvf8Vhp3odvm2nWdby4oiOapE/kXGo=
X-Google-Smtp-Source: ABdhPJwDHApJ0DivKf9mcpMTpVj/5kbpPheKt/eudQMU+Uk8jtvPorPtgPMlNGmVwLK9gTXuXsJV3w==
X-Received: by 2002:a19:5510:0:b0:448:2e01:3e10 with SMTP id n16-20020a195510000000b004482e013e10mr14979398lfe.628.1647303991162;
        Mon, 14 Mar 2022 17:26:31 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:30 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: [PATCH v4 net-next 11/15] net: dsa: Pass VLAN MSTI migration notifications to driver
Date:   Tue, 15 Mar 2022 01:25:39 +0100
Message-Id: <20220315002543.190587-12-tobias@waldekranz.com>
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

Add the usual trampoline functionality from the generic DSA layer down
to the drivers for VLAN MSTI migrations.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 include/net/dsa.h  |  3 +++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 16 +++++++++++++++-
 net/dsa/slave.c    |  6 ++++++
 4 files changed, 26 insertions(+), 1 deletion(-)

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
index 02214033cec0..3ac114f6fc22 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -323,7 +323,10 @@ static void dsa_port_bridge_destroy(struct dsa_port *dp,
 
 static bool dsa_port_supports_mst(struct dsa_port *dp)
 {
-	return dsa_port_can_configure_learning(dp);
+	struct dsa_switch *ds = dp->ds;
+
+	return ds->ops->vlan_msti_set &&
+		dsa_port_can_configure_learning(dp);
 }
 
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
@@ -800,6 +803,17 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
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
index 879d18cc99cb..5e986cdeaae5 100644
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

