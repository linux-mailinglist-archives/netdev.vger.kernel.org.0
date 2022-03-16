Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0002E4DB485
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357196AbiCPPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357101AbiCPPLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:11:13 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366AA673F8
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:23 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id h11so3560968ljb.2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ubTDrM/HLQcbgKJhKkseLppPojCwlLcGyvEvWGWRMWk=;
        b=G1FBGZ8JjDKdAQ9eQL4No6F6/Nu3/61Scg6kUp/jCU0/rIHhtMKuIPdMEaKUv1xnHo
         ZOqVIVVLZ4+iju6oTM9/62vBPVQx1H7Qf05HKXY/q3Wfft0aZHZoKxfsjrRjsXVpryFF
         UiscohFT4YdYdWyFn0YiZJ/GxtsP8Uzh9X86ELMTeuYHNaSZXC/eSMYKW5rtzPB5qKrA
         G7X/PItbcxRxTx98iPDfBKtk9jh4kvEUcESpVvPU/M9VBKd9SmNfMrlI90Ub+WK8grf5
         rx/XvMqiEfhQz1mDqRkMxRlbqSTg+vZl2dZ7TCXbMrH1qfsh4k6fE4hocS1CuV/ndYkA
         TedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ubTDrM/HLQcbgKJhKkseLppPojCwlLcGyvEvWGWRMWk=;
        b=In2zA5AdQ0s9iI1VzIin4LIUYyQQ0UVe97tmi8z1mL1WiBPzfoSfkSUS8TTzfHdyZo
         V/nC2PvwU+WIXHrzTXadb1osKNZ6lqEKhWBDGLTAwZkqN9kU91nD+RBbSNOEa1OXoMuM
         l2yT6gClmUplqE2OiX857zW74H2T+f+PHp/0Kjwfr/+x6Ia7OktcfUxi7jlp/lxP25ew
         Yg/H+CwhpL9vXfk+ONtRgFkJiw9Yb/AKIoMaiVLFCfmFFkNwxMdEGGwAdrXtX9GCOS8f
         MoF+TIm3Ch/0sYhH3R1J3Ev4qZjYVAuqy/KY9N7la+G6JuoulvY9t5SL3GRHbiuhD001
         wPiQ==
X-Gm-Message-State: AOAM533f+X2oL+Pff0oQLLi8qXOEMcdVQHfxfusWwsCkImgbYprDmjur
        zWq8NY98rqq0byaBtU+n0sxM+Q==
X-Google-Smtp-Source: ABdhPJyS2uBP/JGA9PbWjuCf6NGb6KnfvuolkCli17hS9IXHb7QXyB65jGsFO4rhI4M5gQ7dcdbGhw==
X-Received: by 2002:a2e:9e19:0:b0:247:deb7:cd9f with SMTP id e25-20020a2e9e19000000b00247deb7cd9fmr46692ljk.261.1647443361429;
        Wed, 16 Mar 2022 08:09:21 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:21 -0700 (PDT)
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
Subject: [PATCH v5 net-next 15/15] net: dsa: mv88e6xxx: MST Offloading
Date:   Wed, 16 Mar 2022 16:08:57 +0100
Message-Id: <20220316150857.2442916-16-tobias@waldekranz.com>
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

Allocate a SID in the STU for each MSTID in use by a bridge and handle
the mapping of MSTIDs to VLANs using the SID field of each VTU entry.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 250 ++++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |  13 ++
 2 files changed, 255 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c14a62aa6a6c..bed1a5658eac 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1667,24 +1667,31 @@ static int mv88e6xxx_pvt_setup(struct mv88e6xxx_chip *chip)
 	return 0;
 }
 
-static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
+static int mv88e6xxx_port_fast_age_fid(struct mv88e6xxx_chip *chip, int port,
+				       u16 fid)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	if (dsa_to_port(ds, port)->lag)
+	if (dsa_to_port(chip->ds, port)->lag)
 		/* Hardware is incapable of fast-aging a LAG through a
 		 * regular ATU move operation. Until we have something
 		 * more fancy in place this is a no-op.
 		 */
-		return;
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_g1_atu_remove(chip, fid, port, false);
+}
+
+static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
 
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_g1_atu_remove(chip, 0, port, false);
+	err = mv88e6xxx_port_fast_age_fid(chip, port, 0);
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-		dev_err(ds->dev, "p%d: failed to flush ATU\n", port);
+		dev_err(chip->ds->dev, "p%d: failed to flush ATU: %d\n",
+			port, err);
 }
 
 static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
@@ -1818,6 +1825,160 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_stu_loadpurge(chip, &stu);
 }
 
+static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, u8 *sid)
+{
+	DECLARE_BITMAP(busy, MV88E6XXX_N_SID) = { 0 };
+	struct mv88e6xxx_mst *mst;
+
+	__set_bit(0, busy);
+
+	list_for_each_entry(mst, &chip->msts, node)
+		__set_bit(mst->stu.sid, busy);
+
+	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
+
+	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;
+}
+
+static int mv88e6xxx_mst_put(struct mv88e6xxx_chip *chip, u8 sid)
+{
+	struct mv88e6xxx_mst *mst, *tmp;
+	int err;
+
+	if (!sid)
+		return 0;
+
+	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
+		if (mst->stu.sid != sid)
+			continue;
+
+		if (!refcount_dec_and_test(&mst->refcnt))
+			return 0;
+
+		mst->stu.valid = false;
+		err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
+		if (err) {
+			refcount_set(&mst->refcnt, 1);
+			return err;
+		}
+
+		list_del(&mst->node);
+		kfree(mst);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int mv88e6xxx_mst_get(struct mv88e6xxx_chip *chip, struct net_device *br,
+			     u16 msti, u8 *sid)
+{
+	struct mv88e6xxx_mst *mst;
+	int err, i;
+
+	if (!mv88e6xxx_has_stu(chip)) {
+		err = -EOPNOTSUPP;
+		goto err;
+	}
+
+	if (!msti) {
+		*sid = 0;
+		return 0;
+	}
+
+	list_for_each_entry(mst, &chip->msts, node) {
+		if (mst->br == br && mst->msti == msti) {
+			refcount_inc(&mst->refcnt);
+			*sid = mst->stu.sid;
+			return 0;
+		}
+	}
+
+	err = mv88e6xxx_sid_get(chip, sid);
+	if (err)
+		goto err;
+
+	mst = kzalloc(sizeof(*mst), GFP_KERNEL);
+	if (!mst) {
+		err = -ENOMEM;
+		goto err;
+	}
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
+	err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
+	if (err)
+		goto err_free;
+
+	list_add_tail(&mst->node, &chip->msts);
+	return 0;
+
+err_free:
+	kfree(mst);
+err:
+	return err;
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
@@ -2437,6 +2598,12 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
 	if (err)
 		return err;
 
+	if (!vlan.valid) {
+		err = mv88e6xxx_mst_put(chip, vlan.sid);
+		if (err)
+			return err;
+	}
+
 	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
 }
 
@@ -2482,6 +2649,69 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_port_vlan_fast_age(struct dsa_switch *ds, int port, u16 vid)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_vtu_entry vlan;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
+	if (err)
+		goto unlock;
+
+	err = mv88e6xxx_port_fast_age_fid(chip, port, vlan.fid);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	return err;
+}
+
+static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
+				   struct dsa_bridge bridge,
+				   const struct switchdev_vlan_msti *msti)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_vtu_entry vlan;
+	u8 old_sid, new_sid;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+
+	err = mv88e6xxx_vtu_get(chip, msti->vid, &vlan);
+	if (err)
+		goto unlock;
+
+	if (!vlan.valid) {
+		err = -EINVAL;
+		goto unlock;
+	}
+
+	old_sid = vlan.sid;
+
+	err = mv88e6xxx_mst_get(chip, bridge.dev, msti->msti, &new_sid);
+	if (err)
+		goto unlock;
+
+	if (new_sid != old_sid) {
+		vlan.sid = new_sid;
+
+		err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
+		if (err) {
+			mv88e6xxx_mst_put(chip, new_sid);
+			goto unlock;
+		}
+	}
+
+	err = mv88e6xxx_mst_put(chip, old_sid);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
 				  struct dsa_db db)
@@ -6008,6 +6238,7 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
 	mutex_init(&chip->reg_lock);
 	INIT_LIST_HEAD(&chip->mdios);
 	idr_init(&chip->policies);
+	INIT_LIST_HEAD(&chip->msts);
 
 	return chip;
 }
@@ -6540,10 +6771,13 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_pre_bridge_flags	= mv88e6xxx_port_pre_bridge_flags,
 	.port_bridge_flags	= mv88e6xxx_port_bridge_flags,
 	.port_stp_state_set	= mv88e6xxx_port_stp_state_set,
+	.port_mst_state_set	= mv88e6xxx_port_mst_state_set,
 	.port_fast_age		= mv88e6xxx_port_fast_age,
+	.port_vlan_fast_age	= mv88e6xxx_port_vlan_fast_age,
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

