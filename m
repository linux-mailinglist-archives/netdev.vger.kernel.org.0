Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093B54DB4EF
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiCPPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbiCPPcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:32:35 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAB86CA71
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t25so4352742lfg.7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hVMa5GtA6KBTlA6K52umM0UVKHxP7UKW8/9ytKYiC6g=;
        b=QjtzvXplDROxhaxiHvPu1BjJ5PjVslGbOrps8jUEbv1lkfDtDnk0Zq0JM0GbpB/Kxq
         Rk7WqMsXs0JNr5MgMZEd9duwRe4vDdAPzntjFJDu7OAiQ4aRmushMgDwIFHH97NHI8EF
         xf46zu2Yp/eibavTnqNOUsGe7RP9nL+X2pcQnyyiQtnNXCAQKeIPye8EATcNVJDa+0ja
         fPLWNooK+rgvOS0jrnbkSyfmc4eAiVGwi447dhW6LHtg5YxeNs9YJiYwsvNCIpCUdUEA
         HZ8u30tTIpqgVFYBlWVe4xDc41NDc2/AD4qRbRc6UM7W0p3CVcNbSQnPy0O771jhp9oU
         bPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hVMa5GtA6KBTlA6K52umM0UVKHxP7UKW8/9ytKYiC6g=;
        b=Crqm81SclPybZYo2ebKuyYRdA5SUszx2CO+xugkY4KBqVTEyYlCwcE5XYRGZU2UZwf
         bTttciT6hJMh72dfwalyRWQ/oYFtXCK1egX+w2i7o0EOkBGfbX4yRw64mReN6MW4DZvL
         JW0S6vDkO9EbBM5D6u61910DUtrIgvYFSjOiko2gLYg5ZJnYRI1oiZ6p8xqTqzESpwSF
         l1XJSOdAkiWvqoa5pTezDjOJzHJU12ajcJRR5k6JUjKekd716Wzdd7pWTCoycs1n31Mx
         OR66CUR5Iupb65lvHbnEsAiL7kmNvs4WlkSNfwUxyFsNsskPpWyVbUJZUCMKjpRNr9xP
         cn/g==
X-Gm-Message-State: AOAM531brjFiv6MawKxVAzfSE1a15nXePLTnp1avKj6pvylzlrBfN7F0
        oGIFHwpfRxworIHo1MCMyDhl4YGEV1uB8f1D
X-Google-Smtp-Source: ABdhPJzYYyZry5H4+IrzoCUY9ywdttjtmaih9FGKvzMOVwhkibJfhQZisdJmwtD+sBTlSs3kYF/y3w==
X-Received: by 2002:ac2:4f92:0:b0:448:7eab:c004 with SMTP id z18-20020ac24f92000000b004487eabc004mr118715lfs.27.1647444677694;
        Wed, 16 Mar 2022 08:31:17 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056512168900b004489c47d241sm205870lfb.32.2022.03.16.08.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:31:16 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH v2 net-next 3/5] dsa: Handle the flood flag in the DSA layer.
Date:   Wed, 16 Mar 2022 16:30:57 +0100
Message-Id: <20220316153059.2503153-4-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
References: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
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

Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
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
index f9cecda791d5..1349dda6b3e6 100644
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

