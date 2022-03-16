Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905844DB47A
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357067AbiCPPLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357009AbiCPPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:49 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1123E673D2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:15 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 25so3519308ljv.10
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=i+b2UIYzIPR8HiB7lfNC7HnKeM/AsfglkAUtbevdP9c=;
        b=pKQumBJ+GJsRVp/9DOhiZG5nLwVHg3P0o8Mzd4OiMre2OVw7GwRWHQFDDOj6l1s/vA
         1w5nGNo0a8hV5fJ/UjSxv9IbAeQoH04ovDHkSWiJsu8KjaUjBh77oag+Hn7Eq4qixUVt
         6eQTY0sehEiq+KVOLjlm9AJ82yRyh6h5Zy+bEICcQBUHCmYnCsSs+FvWQsVpRKhnSJFp
         fzcz10VupTQQdkofQYGmIUbdEgaZ7hcDA/HtJcCsGUbtxVQtNTFsLfDx3KYyrrFESRJ7
         0BFwb9iICX8WGq/nTqHGi+B1rime6Vp8ivGp3nf6odxboZd80FFPzo4fl9NKqK1SwJmi
         gSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=i+b2UIYzIPR8HiB7lfNC7HnKeM/AsfglkAUtbevdP9c=;
        b=gD/04TVtp6g3/NAfatolTe1NrkgkxGxdkQldNB+R4/DXC1M15hXGLWgsc0zbNCQCGC
         1nQQmeK/qpuFRxuxmVC7PUicTaqp0SmKnqG/YTFRdRelRwFB3xSv+wY9UVIc8w+6grh/
         amtqxvi9P/YCjbNoSslLEOjyu+3NxAzP5GmUZj/iWYewP4i0r/pEodTTqNwY91xB0cXA
         zNDxst23Fv+wM8neY9YTYYSufDodt5cuIccB0MlIX4RdAP/j9PYEP5HfRk+5+wn96Zda
         VENtYoQkRfVF2BC6SPJPCOAtpo2UgTXGWsuTzDxZOV5Rtb2vsVhadraYT108XK5414Tb
         U6QA==
X-Gm-Message-State: AOAM530RxsIoDZ4L2+tvgH9dtgWs/i+R1+44+DArJfFbzEdg8WbGExef
        D9VdBlvporaX820ySy6mEKCAwg==
X-Google-Smtp-Source: ABdhPJwxmEKzCMsYoV9W9IgcGOWsUWc8nu+1gANANSrTAa+SS4zfn83WZgUS47iF9INcsPjoA0nY6g==
X-Received: by 2002:a2e:a236:0:b0:249:2a4b:16f5 with SMTP id i22-20020a2ea236000000b002492a4b16f5mr75402ljm.384.1647443352962;
        Wed, 16 Mar 2022 08:09:12 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:12 -0700 (PDT)
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
Subject: [PATCH v5 net-next 06/15] net: bridge: mst: Notify switchdev drivers of MST state changes
Date:   Wed, 16 Mar 2022 16:08:48 +0100
Message-Id: <20220316150857.2442916-7-tobias@waldekranz.com>
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

Generate a switchdev notification whenever an MST state changes. This
notification is keyed by the VLANs MSTI rather than the VID, since
multiple VLANs may share the same MST instance.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/switchdev.h |  7 +++++++
 net/bridge/br_mst.c     | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 53dfa0f7cf5b..aa0171d5786d 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -19,6 +19,7 @@
 enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_UNDEFINED,
 	SWITCHDEV_ATTR_ID_PORT_STP_STATE,
+	SWITCHDEV_ATTR_ID_PORT_MST_STATE,
 	SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS,
 	SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS,
 	SWITCHDEV_ATTR_ID_PORT_MROUTER,
@@ -32,6 +33,11 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_VLAN_MSTI,
 };
 
+struct switchdev_mst_state {
+	u16 msti;
+	u8 state;
+};
+
 struct switchdev_brport_flags {
 	unsigned long val;
 	unsigned long mask;
@@ -50,6 +56,7 @@ struct switchdev_attr {
 	void (*complete)(struct net_device *dev, int err, void *priv);
 	union {
 		u8 stp_state;				/* PORT_STP_STATE */
+		struct switchdev_mst_state mst_state;	/* PORT_MST_STATE */
 		struct switchdev_brport_flags brport_flags; /* PORT_BRIDGE_FLAGS */
 		bool mrouter;				/* PORT_MROUTER */
 		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 29266174e6b4..00935a19afcc 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -30,13 +30,31 @@ static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_v
 int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
 		     struct netlink_ext_ack *extack)
 {
+	struct switchdev_attr attr = {
+		.id = SWITCHDEV_ATTR_ID_PORT_MST_STATE,
+		.orig_dev = p->dev,
+		.u.mst_state = {
+			.msti = msti,
+			.state = state,
+		},
+	};
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
+	int err;
 
 	vg = nbp_vlan_group(p);
 	if (!vg)
 		return 0;
 
+	/* MSTI 0 (CST) state changes are notified via the regular
+	 * SWITCHDEV_ATTR_ID_PORT_STP_STATE.
+	 */
+	if (msti) {
+		err = switchdev_port_attr_set(p->dev, &attr, extack);
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
 	list_for_each_entry(v, &vg->vlan_list, vlist) {
 		if (v->brvlan->msti != msti)
 			continue;
-- 
2.25.1

