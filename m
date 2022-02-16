Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5BB4B8A10
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbiBPNan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:30:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiBPNak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:30:40 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BDD166E1C
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:28 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id a42so3260784ljq.13
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=DYnfKqTSgC5uj+SzX4mt7uAq7sGgk7Wi7t60amasNV0=;
        b=oxgfrsXStgeuX6tCRI8Jrp2u3JdDVV8hMQYPzHmSvI8GOYa/IRYkpGoSbIKCUVYZZq
         pyHvHY1anxMNK9X3eJvqEjDG8+48vm6wLm0q79+bJQrnw6kKhbSZDh9v7OhufwQ+Q3xI
         oLCefAUu7MkS0wFIseqacZjsATPxgvlxhqk2bPdQy3tOYs/4/PNsx74hC8j6vPA2EwYt
         3A3BL4DVRusjAv56hhWzQ6BHib7nvN6z/HRpBkZ2Kf/OBYwIDQzKlAV3Oco5C881kPaY
         UlURxMwmPCiivCJYZPoiZh9ffuVp7p7wamxtLGKluisKrMujGYQOYudOCEHVFBU9YR7I
         SyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=DYnfKqTSgC5uj+SzX4mt7uAq7sGgk7Wi7t60amasNV0=;
        b=d/uW/uXKdg4z62I9Rkx1ZU6tm+eqV6xVk1E4lZupe2NQP9iodMDFdvBw8ZF2+oP/Zz
         dt1/3cxLptohvXB9mnL0yzJ0Ay39JiIDb8tnV/qmChvcETynioRgx7kmzkzzKAEd4kyJ
         3bMxk1BfJV7HZ3hdAAKxa9hH56Fp6+CVakfSWiIeMTil29UnGQpIxAgEcVwoX/bjQslY
         mTczc57Jth2ahCQ/JydA4gOyGOfU4d9JDU6oMBuolKxBdOR+HBPAKE5sbWqsif/j/M8H
         4BtxjQUuNowv2xq0l0oFLiCT0TXwjgL6WaMkPSLx91rqoxbTO3vLZ9C9r941JHPNfLfq
         pRVg==
X-Gm-Message-State: AOAM532yG+ehrWSHDQRGlYrNmXM+JEU0X7RBpC6pY6gd8Jzb2dkL0+XK
        zIYAtS3oNDVty/s7YUIzFq0Cng==
X-Google-Smtp-Source: ABdhPJwJFoP2AoBOi0/Lpv5FIoWr4q1oM0BAHDJboChbC8FCLPQd4CMCNVbVyuPHiaJPBASD8aIioQ==
X-Received: by 2002:a2e:8346:0:b0:246:c11:b4c3 with SMTP id l6-20020a2e8346000000b002460c11b4c3mr1485442ljh.351.1645018226660;
        Wed, 16 Feb 2022 05:30:26 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v6sm234780ljd.86.2022.02.16.05.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 05:30:26 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 3/9] net: bridge: vlan: Notify switchdev drivers of VLAN MST migrations
Date:   Wed, 16 Feb 2022 14:29:28 +0100
Message-Id: <20220216132934.1775649-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216132934.1775649-1-tobias@waldekranz.com>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
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

Whenever a VLAN moves to a new MSTID, send a switchdev notification so
that switchdevs can track a bridge's VID to MSTID mapping.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/switchdev.h | 10 ++++++++++
 net/bridge/br_vlan.c    | 20 ++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index d353793dfeb5..ee4a7bd1e540 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -28,6 +28,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
+	SWITCHDEV_ATTR_ID_VLAN_MSTID,
 };
 
 struct switchdev_brport_flags {
@@ -35,6 +36,14 @@ struct switchdev_brport_flags {
 	unsigned long mask;
 };
 
+struct switchdev_vlan_attr {
+	u16 vid;
+
+	union {
+		u16 mstid;
+	};
+};
+
 struct switchdev_attr {
 	struct net_device *orig_dev;
 	enum switchdev_attr_id id;
@@ -50,6 +59,7 @@ struct switchdev_attr {
 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
 		bool mc_disabled;			/* MC_DISABLED */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
+		struct switchdev_vlan_attr vlan_attr;	/* VLAN_* */
 	} u;
 };
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 459e84a7354d..c45a34c14e10 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -173,6 +173,26 @@ static int br_vlan_mst_migrate(struct net_bridge_vlan *v, u16 mstid)
 	old_mst = rtnl_dereference(v->mst);
 	rcu_assign_pointer(v->mst, mst);
 
+	if (br_vlan_is_master(v)) {
+		struct switchdev_attr attr = {
+			.id = SWITCHDEV_ATTR_ID_VLAN_MSTID,
+			.flags = SWITCHDEV_F_DEFER,
+			.orig_dev = br->dev,
+			.u.vlan_attr = {
+				.vid = v->vid,
+				.mstid = mstid,
+			},
+		};
+		int err;
+
+		err = switchdev_port_attr_set(br->dev, &attr, NULL);
+		if (err && err != -EOPNOTSUPP) {
+			rcu_assign_pointer(v->mst, old_mst);
+			br_vlan_mst_put(mst);
+			return err;
+		}
+	}
+
 	if (old_mst)
 		br_vlan_mst_put(old_mst);
 
-- 
2.25.1

