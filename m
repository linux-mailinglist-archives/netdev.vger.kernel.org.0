Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814CD4C88DE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiCAKEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbiCAKEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:04:37 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E3A8BF35
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:03:54 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e8so21170819ljj.2
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=9f7PbMRM1byMWVKRPVH2DH+qKFogCebwnAS9gVQDC5I=;
        b=LfKQcjKEK5wI+sNFr+DRYqUk+bAEDYWDniCP2ki23Pban4lZywbpkNO37WC9287GE4
         GUzTXcC7WfXhifu+HNVLh3hQagN1CsjazTGcN3YY2uq8fGGDGzCdya5i61D0NX15he2/
         dIiLOrDJZrDvV0yjBETAqcapWu/haPjOuIcTKoDX8Paqo2R7I+0MO1yWX5zT2rZgwihK
         xKwRYi/rzfgmKXKBSRmq020acgJjGZn41GrlcN2YqxDnHHu1Oip0P2qDOMmjgQYO8OBt
         L2mkd/8V0lV7bWm+pIbFhLZVdOI+r9Ck9VzcPQJYvLqw/AJ/f7OtO1THeQOLZSPJzWcF
         +Kkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=9f7PbMRM1byMWVKRPVH2DH+qKFogCebwnAS9gVQDC5I=;
        b=IDSEHO9qRAu7jz2Y2hUod48CboBDW4nUDAC/Ku8AJK6cAH/Ym0PuSMZu7+65pz8K3I
         fCrXux7FQ48ZtnoylItLrmCKL50XPASuDr2gw0OwOW6ztvLQrcvvpQOs14y6s3GZUcWu
         WQiUvJFFTBLoZNLbfwbLyuffLgDPL4IFTGLvgnFuJJPLdkrD9ZduieIy9My6A4gPEhqa
         tgAjexbLTtmkpeXWPVC4kJvKikcpIvP5TGcPQnGldxtoDAel/hDgEF/AG/akE6Ek3utd
         BKLSA83HC5Jtc6dDAmPS6BnWAaIqLrCb2d3tyrjME40Le9U3QKEEpVY66Jt8SzNav2Am
         lPDg==
X-Gm-Message-State: AOAM531eHAVlefDycbKDthoHnxUh9AHf0i5NNOh7m6WhzYJVD72uN2fS
        hSJsJYSXR3Teq+F+I5Vdd2PjWg==
X-Google-Smtp-Source: ABdhPJzMCZtiN5flmK0LILPNyZm7i1BbaUaNC+ytrvpDRyBrkkkb3keXqM+c+OqQ6Jt4nH5EEwLwDg==
X-Received: by 2002:a2e:bc09:0:b0:246:7327:879b with SMTP id b9-20020a2ebc09000000b002467327879bmr13832354ljf.381.1646129033092;
        Tue, 01 Mar 2022 02:03:53 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s27-20020a05651c049b00b002460fd4252asm1826822ljc.100.2022.03.01.02.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 02:03:52 -0800 (PST)
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
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v2 net-next 06/10] net: dsa: Pass VLAN MSTI migration notifications to driver
Date:   Tue,  1 Mar 2022 11:03:17 +0100
Message-Id: <20220301100321.951175-7-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301100321.951175-1-tobias@waldekranz.com>
References: <20220301100321.951175-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 net/dsa/dsa_priv.h |  1 +
 net/dsa/port.c     | 10 ++++++++++
 net/dsa/slave.c    |  6 ++++++
 4 files changed, 20 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index cfedcfb86350..cc8acb01bd9b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -962,6 +962,9 @@ struct dsa_switch_ops {
 				 struct netlink_ext_ack *extack);
 	int	(*port_vlan_del)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
+	int	(*vlan_msti_set)(struct dsa_switch *ds,
+				 const struct switchdev_attr *attr);
+
 	/*
 	 * Forwarding database
 	 */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 07c0ad52395a..87ec0697e92e 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -217,6 +217,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
+int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d9da425a17fb..5f45cb7d70ba 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -778,6 +778,16 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 	return 0;
 }
 
+int dsa_port_vlan_msti(struct dsa_port *dp, const struct switchdev_attr *attr)
+{
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->vlan_msti_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->vlan_msti_set(ds, attr);
+}
+
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool targeted_match)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 089616206b11..c6ffcd782b5a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -314,6 +314,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
 
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, extack);
 		break;
+	case SWITCHDEV_ATTR_ID_VLAN_MSTI:
+		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
+			return -EOPNOTSUPP;
+
+		ret = dsa_port_vlan_msti(dp, attr);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.25.1

