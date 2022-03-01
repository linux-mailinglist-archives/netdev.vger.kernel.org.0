Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE64C88E2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiCAKEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiCAKEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:04:41 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4018CDBB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:03:58 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id f37so25915891lfv.8
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=jqsbZZHdMda2x9oc6NoF+wlcHcbYportSlPaVmfdhdw=;
        b=HKk0hQezxCK92/j7bOgiYTr1ECclfO1RYVPOgm46iOd8IVv5YZuP1DX0qbTwEjSY5T
         I17GcmYYNnBdIVrkuyZQH7hT6jUZ6giAsrpQ5NwG3UhUdCXT1Vcsh70SiqjjMuCTZFZJ
         +avKxmLzhlgl19XI+uwyDb04MO7YB53WviZKZrrpXc0teudQ7xYobGV+Ur2m9T8yL/DT
         vBcnDdltpcRrxFcAdI7ehZTchPIYwmmAWvCl3rxMVGhhxst2FYtMv9tf18Ag0i9Z9qkg
         CO+q9T8HuUYPDmlDPjVnKPbaIJEsSNyK/sUWd5GCVhVonZ/1fjwyqopw8e1xKDBuOrnx
         y3TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=jqsbZZHdMda2x9oc6NoF+wlcHcbYportSlPaVmfdhdw=;
        b=lasz787xRlhcnJardy8aEZ6xX4yzyn8f6rQtNtB+1jotblW1S/x61pBhWnBxr+3jnb
         OFzD3w3FJMYOfpMQCqa+RGhfyIFqwyMofhKCh3fSW79XtHi2zZoneG79LFEVDPZJmhA3
         ISf5eNKfeC80nKL/KE1+F7ubDqoviI+ukHj4T6cz2U7sovBO1PC3iuQ0qx6qSLw2SKGe
         mnVDBD/dl/8+6V0DYmtNCBleTar6Odbm1g+ku3R5tMsXKPsn8eUKDch55QZ/uLzkqWyU
         abxwWlr6RIeWipHnaRDFS40N+xIp9JHwRgLWNs3OlT2Vn3LZuFf+ExJ4AiuS49J8OfX1
         8+dQ==
X-Gm-Message-State: AOAM530r2NuHqYQuOEuWnOo3E6kMfm8rPIDsWx+UQ0hoGWTS+03Ur3Pb
        OXuBnTJf2+KUsqnXDXsPA2VJgQ==
X-Google-Smtp-Source: ABdhPJzyTHyE7Ya2J9YjwlEf5uGw6oVRODcnx+gLqTw8XPZn4iWGc0QoLBGe3pNm1B66bq8IOMwHHw==
X-Received: by 2002:a05:6512:114c:b0:434:b7a7:1fdc with SMTP id m12-20020a056512114c00b00434b7a71fdcmr15109807lfg.608.1646129037075;
        Tue, 01 Mar 2022 02:03:57 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s27-20020a05651c049b00b002460fd4252asm1826822ljc.100.2022.03.01.02.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 02:03:56 -0800 (PST)
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
Subject: [PATCH v2 net-next 10/10] net: dsa: mv88e6xxx: MST Offloading
Date:   Tue,  1 Mar 2022 11:03:21 +0100
Message-Id: <20220301100321.951175-11-tobias@waldekranz.com>
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

Allocate a SID in the STU for each MSTID in use by a bridge and handle
the mapping of MSTIDs to VLANs using the SID field of each VTU entry.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 178 +++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  13 +++
 2 files changed, 191 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c14a62aa6a6c..4fb4ec1dff79 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1818,6 +1818,137 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_stu_loadpurge(chip, &stu);
 }
 
+static int mv88e6xxx_sid_new(struct mv88e6xxx_chip *chip, u8 *sid)
+{
+	DECLARE_BITMAP(busy, MV88E6XXX_N_SID) = { 0 };
+	struct mv88e6xxx_mst *mst;
+
+	set_bit(0, busy);
+
+	list_for_each_entry(mst, &chip->msts, node) {
+		set_bit(mst->stu.sid, busy);
+	}
+
+	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
+
+	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;
+}
+
+static int mv88e6xxx_sid_put(struct mv88e6xxx_chip *chip, u8 sid)
+{
+	struct mv88e6xxx_mst *mst, *tmp;
+	int err = 0;
+
+	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
+		if (mst->stu.sid == sid) {
+			if (refcount_dec_and_test(&mst->refcnt)) {
+				mst->stu.valid = false;
+				err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
+				list_del(&mst->node);
+				kfree(mst);
+			}
+
+			return err;
+		}
+	}
+
+	return -ENOENT;
+}
+
+static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, struct net_device *br,
+			     u16 msti, u8 *sid)
+{
+	struct mv88e6xxx_mst *mst;
+	int err, i;
+
+	if (!br)
+		return 0;
+
+	if (!mv88e6xxx_has_stu(chip))
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(mst, &chip->msts, node) {
+		if (mst->br == br && mst->msti == msti) {
+			refcount_inc(&mst->refcnt);
+			*sid = mst->stu.sid;
+			return 0;
+		}
+	}
+
+	err = mv88e6xxx_sid_new(chip, sid);
+	if (err)
+		return err;
+
+	mst = kzalloc(sizeof(*mst), GFP_KERNEL);
+	if (!mst)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mst->node);
+	refcount_set(&mst->refcnt, 1);
+	mst->br = br;
+	mst->msti = msti;
+	mst->stu.valid = true;
+	mst->stu.sid = *sid;
+
+	/* The bridge starts out all ports in the disabled state. But
+	 * a STU state of disabled means to go by the port-global
+	 * state. So we set all user port's initial state to blocking,
+	 * to match the bridge's behavior.
+	 */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
+		mst->stu.state[i] = dsa_is_user_port(chip->ds, i) ?
+			MV88E6XXX_PORT_CTL0_STATE_BLOCKING :
+			MV88E6XXX_PORT_CTL0_STATE_DISABLED;
+
+	list_add_tail(&mst->node, &chip->msts);
+	return mv88e6xxx_stu_loadpurge(chip, &mst->stu);
+}
+
+static int mv88e6xxx_port_mst_state_set(struct dsa_switch *ds, int port,
+					const struct switchdev_mst_state *st)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_mst *mst;
+	u8 state;
+	int err;
+
+	if (!mv88e6xxx_has_stu(chip))
+		return -EOPNOTSUPP;
+
+	switch (st->state) {
+	case BR_STATE_DISABLED:
+	case BR_STATE_BLOCKING:
+	case BR_STATE_LISTENING:
+		state = MV88E6XXX_PORT_CTL0_STATE_BLOCKING;
+		break;
+	case BR_STATE_LEARNING:
+		state = MV88E6XXX_PORT_CTL0_STATE_LEARNING;
+		break;
+	case BR_STATE_FORWARDING:
+		state = MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	list_for_each_entry(mst, &chip->msts, node) {
+		if (mst->br == dsa_port_bridge_dev_get(dp) &&
+		    mst->msti == st->msti) {
+			if (mst->stu.state[port] == state)
+				return 0;
+
+			mst->stu.state[port] = state;
+			mv88e6xxx_reg_lock(chip);
+			err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
+			mv88e6xxx_reg_unlock(chip);
+			return err;
+		}
+	}
+
+	return -ENOENT;
+}
+
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid)
 {
@@ -2437,6 +2568,12 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
 	if (err)
 		return err;
 
+	if (!vlan.valid && vlan.sid) {
+		err = mv88e6xxx_sid_put(chip, vlan.sid);
+		if (err)
+			return err;
+	}
+
 	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
 }
 
@@ -2482,6 +2619,44 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
+				   const struct switchdev_attr *attr)
+{
+	const struct switchdev_vlan_attr *vattr = &attr->u.vlan_attr;
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_vtu_entry vlan;
+	u8 new_sid;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_vtu_get(chip, vattr->vid, &vlan);
+	if (err)
+		goto unlock;
+
+	if (!vlan.valid) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	err = mv88e6xxx_sid_get(chip, attr->orig_dev, vattr->msti, &new_sid);
+	if (err)
+		goto unlock;
+
+	if (vlan.sid) {
+		err = mv88e6xxx_sid_put(chip, vlan.sid);
+		if (err)
+			goto unlock;
+	}
+
+	vlan.sid = new_sid;
+	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
 				  struct dsa_db db)
@@ -6008,6 +6183,7 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
 	mutex_init(&chip->reg_lock);
 	INIT_LIST_HEAD(&chip->mdios);
 	idr_init(&chip->policies);
+	INIT_LIST_HEAD(&chip->msts);
 
 	return chip;
 }
@@ -6540,10 +6716,12 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
 	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
+	.port_mst_state_set	= mv88e6xxx_port_mst_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
 	.port_vlan_filtering	= mv88e6xxx_port_vlan_filtering,
 	.port_vlan_add		= mv88e6xxx_port_vlan_add,
 	.port_vlan_del		= mv88e6xxx_port_vlan_del,
+	.vlan_msti_set		= mv88e6xxx_vlan_msti_set,
 	.port_fdb_add           = mv88e6xxx_port_fdb_add,
 	.port_fdb_del           = mv88e6xxx_port_fdb_del,
 	.port_fdb_dump          = mv88e6xxx_port_fdb_dump,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 6d4daa24d3e5..6a0b66354e1d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -297,6 +297,16 @@ struct mv88e6xxx_region_priv {
 	enum mv88e6xxx_region_id id;
 };
 
+struct mv88e6xxx_mst {
+	struct list_head node;
+
+	refcount_t refcnt;
+	struct net_device *br;
+	u16 msti;
+
+	struct mv88e6xxx_stu_entry stu;
+};
+
 struct mv88e6xxx_chip {
 	const struct mv88e6xxx_info *info;
 
@@ -397,6 +407,9 @@ struct mv88e6xxx_chip {
 
 	/* devlink regions */
 	struct devlink_region *regions[_MV88E6XXX_REGION_MAX];
+
+	/* Bridge MST to SID mappings */
+	struct list_head msts;
 };
 
 struct mv88e6xxx_bus_ops {
-- 
2.25.1

