Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291084DBFA2
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiCQGwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiCQGwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:52:01 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45049ABF4C
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:44 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id bu29so7511971lfb.0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lCUc36wMLGuTup0uWW9rIeQHoFjF/vJZIzoTIUj4pLY=;
        b=TCeYZQm9mvMs8RlgpBcWoDGcUQghqpW71PRAx8GNfUpEIFj+ZM6oHCgu/kKzL5RvCj
         IJ6EI2l7GWPGRsEN1+M46xcP5NMWvwAW2CujEHdmLdCoquT+AKfWHm7J7BeOFALdfew+
         qOTG8cy//RFoW/Kd8H8fSDT9by8/qdbrp5m2BHc7MyBH7y5ewkzAveK3pKM221PE+RIR
         IkbYS5FhI0v5b89Qq3tP2HpwcGgcipgF3Rj+V7lTiPt/PzfkdmCeWfogrY2XbQNeitmt
         8vDSzB2baxUdMad82z9lgvQKxopYJscCNPSk8Yf3SaGhSnon0/sq5riwcWX91Sjetql5
         T1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lCUc36wMLGuTup0uWW9rIeQHoFjF/vJZIzoTIUj4pLY=;
        b=6mFAT6D6I7pvX961g+YGRB2dGGiUPTRe2cNQLDHFFyd8YlVXSJ5AxwmeTQKnpT/0U+
         nV/PT68NQFTgSedSOtljocUPDlY1VSj+MkxKonhQVk20fPjxL3TpNPn1dnmuqB95/50T
         FSiQFSZK5Xkabbkn9dJY3/U8Fi/XYjNB67NLfM3jXrMGYZ1qO7oyIHBoZIAEpy68kZsu
         DFvaXnIzLpltcdr5q5E/vanT8H4mMvGcscjTu165ryF4Pbe7sAtzfequ2/iqmmUT5vSd
         jf8FReVQYWw6M+qHEZm9+kyKerx8Cxy39J+f/FJKW9UcitXQV7YIUtNATMQIoaL/A/ma
         4CRw==
X-Gm-Message-State: AOAM531MQhQ6oumed4NJApirrfl/nokTXnQTTUBRkpvLo10RKmy3R8zX
        8qJmSTOWtv+W3eOxJ3WWQbiFEX6gUQyvAxR1
X-Google-Smtp-Source: ABdhPJzPgkQqyOiJ+IXcdQ6EWVX9KIunc3EMw20GUUmk7NrKISkKhLzn5HJ9kN1X7yEK4qYE/ExRjA==
X-Received: by 2002:a05:6512:3e0c:b0:448:3480:1fe5 with SMTP id i12-20020a0565123e0c00b0044834801fe5mr2049249lfv.358.1647499842471;
        Wed, 16 Mar 2022 23:50:42 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l25-20020ac25559000000b0044825a2539csm362215lfk.59.2022.03.16.23.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:50:41 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH 3/5] dsa: Handle the flood flag in the DSA layer.
Date:   Thu, 17 Mar 2022 07:50:29 +0100
Message-Id: <20220317065031.3830481-4-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
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

Add infrastructure to be able to handle the flood
flag in the DSA layer.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h  |  7 +++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/slave.c    | 18 ++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9bfe984fcdbf..fcb47dc832e1 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -939,6 +939,13 @@ struct dsa_switch_ops {
 	void	(*get_regs)(struct dsa_switch *ds, int port,
 			    struct ethtool_regs *regs, void *p);
 
+	/*
+	 * Local receive
+	 */
+	int	(*set_flood)(struct dsa_switch *ds, int port,
+				     struct net_device *bridge, unsigned long mask,
+				     unsigned long val);
+
 	/*
 	 * Upper device tracking.
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f20bdd8ea0a8..ca3ea320c8eb 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -234,6 +234,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
+int dsa_port_set_flood(struct dsa_port *dp, struct net_device *br, unsigned long mask,
+		       unsigned long val);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d24b6bf845c1..f3d780e2b42b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -458,6 +458,13 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
 					      extack);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_FLOOD:
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_set_flood(dp, attr->orig_dev, attr->u.brport_flags.mask,
+					 attr->u.brport_flags.val);
+		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
 			return -EOPNOTSUPP;
@@ -834,6 +841,17 @@ dsa_slave_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *_p)
 		ds->ops->get_regs(ds, dp->index, regs, _p);
 }
 
+int dsa_port_set_flood(struct dsa_port *dp, struct net_device *br, unsigned long mask,
+		       unsigned long val)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->set_flood)
+		return ds->ops->set_flood(ds, dp->index, br, mask, val);
+
+	return 0;
+}
+
 static int dsa_slave_nway_reset(struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-- 
2.25.1

