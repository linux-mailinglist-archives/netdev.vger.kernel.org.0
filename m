Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368F94D7F3C
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbiCNJzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiCNJzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:55:11 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF4238D96
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:53:18 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id y17so3862287ljd.12
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=EhqGuJqqtp9wtuhSiVXt/o5grLaHVr4b0QqzceZCUO8=;
        b=RJa3/5K5cCDl6EjFcQwfzqk/UcKzuV733YpHO1tIlGr8G8TfvlqiLBaFw5o8IGW6Gc
         cqjOSwteauUJ5Hkth30AhD7p3H0YTs1M/kkCVVVoT2t1S0FUwVxa80JVNjNENM6dmrlq
         QIe6ZiQ1MnjuDlJ9+sjvF3I/KIV0yarwG2f0OFT3St2q7QMAX+vJE2CZuh8remUW8zT9
         sjZCJuwa65WRGm4AL6RvOiBKuKPDsgWE38hao2IROUxuHkD1v2PA7aHF/uQDwMrimK6i
         kM+/knTp4IbzmlAwqwy53A9aW/b6Ph+Sd484UGqQJ/Abn08QumzCTKznDrNi2VzWv7x9
         pc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=EhqGuJqqtp9wtuhSiVXt/o5grLaHVr4b0QqzceZCUO8=;
        b=My6PvpVpXaUdbPNWY/5WgAcNdD+ITLWXB+ZSkBxcghRFjwOYo/zwo472CyuY0xhGyp
         lXTE7J8PcZj7owcVg4FBbnjxxhM7mEu9/4lttWQYasRirUigBxBZFjqm3WV4uVPmWPbl
         YnuXcYE+6pUY7ikpXAYzLr/lz2CdK2o2T3YgRMCwPW/eIEKUO5C5EUqtHv8fDkKsREJ4
         hGB4Y4u8xDUbi19UAPfqSNflUlTvxsdXVnuipPZ9c9e4xcMzqERPkWqRg9ioP18LCuSp
         DYcmRctHCn2mO7+4GoOnEcgkIER0ClT7vdXK/5Jex2mVvRgcBpYVw8Wk1W6GymOcu1dv
         9KrA==
X-Gm-Message-State: AOAM530UcLt7sab3f8urNhd2LFMc3wZ9+7zBS2YcZ1YKNjAq7WK4ZypP
        rIGuBi/kV2Gddpkgysdpv7jfcQ==
X-Google-Smtp-Source: ABdhPJx+Bm2nE+m0aEApfu+ftVJZhVBFOe9kvxEBDqF4k0QtCWa1a+gyVpQdN7tqFeWdRzVG9Wdosg==
X-Received: by 2002:a2e:aa0b:0:b0:249:1e19:67f8 with SMTP id bf11-20020a2eaa0b000000b002491e1967f8mr9448720ljb.390.1647251596605;
        Mon, 14 Mar 2022 02:53:16 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b3-20020a056512304300b004488e49f2fasm984870lfb.129.2022.03.14.02.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 02:53:16 -0700 (PDT)
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
Subject: [PATCH v3 net-next 14/14] net: dsa: mv88e6xxx: MST Offloading
Date:   Mon, 14 Mar 2022 10:52:31 +0100
Message-Id: <20220314095231.3486931-15-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220314095231.3486931-1-tobias@waldekranz.com>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 251 ++++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |  13 ++
 2 files changed, 257 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c14a62aa6a6c..c23dbf37aeec 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1667,24 +1667,32 @@ static int mv88e6xxx_pvt_setup(struct mv88e6xxx_chip *chip)
 	return 0;
 }
 
-static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
+static void mv88e6xxx_port_fast_age_fid(struct mv88e6xxx_chip *chip, int port,
+					u16 fid)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (dsa_to_port(ds, port)->lag)
+	if (dsa_to_port(chip->ds, port)->lag)
 		/* Hardware is incapable of fast-aging a LAG through a
 		 * regular ATU move operation. Until we have something
 		 * more fancy in place this is a no-op.
 		 */
 		return;
 
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_g1_atu_remove(chip, 0, port, false);
-	mv88e6xxx_reg_unlock(chip);
+	err = mv88e6xxx_g1_atu_remove(chip, fid, port, false);
 
 	if (err)
-		dev_err(ds->dev, "p%d: failed to flush ATU\n", port);
+		dev_err(chip->ds->dev, "p%d: failed to flush ATU (FID %u)\n",
+			port, fid);
+}
+
+static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	mv88e6xxx_reg_lock(chip);
+	mv88e6xxx_port_fast_age_fid(chip, port, 0);
+	mv88e6xxx_reg_unlock(chip);
 }
 
 static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
@@ -1818,6 +1826,159 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_stu_loadpurge(chip, &stu);
 }
 
+static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, u8 *sid)
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
+		if (err)
+			return err;
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
 
+	if (!vlan.valid && vlan.sid) {
+		err = mv88e6xxx_mst_put(chip, vlan.sid);
+		if (err)
+			return err;
+	}
+
 	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
 }
 
@@ -2482,6 +2649,72 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static void mv88e6xxx_port_vlan_fast_age(struct dsa_switch *ds, int port, u16 vid)
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
+	mv88e6xxx_port_fast_age_fid(chip, port, vlan.fid);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err)
+		dev_err(ds->dev, "p%d: failed to flush ATU in VID %u\n",
+			port, vid);
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
+	if (old_sid)
+		err = mv88e6xxx_mst_put(chip, old_sid);
+
+unlock:
+	mv88e6xxx_reg_unlock(chip);
+	return err;
+}
+
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
 				  struct dsa_db db)
@@ -6008,6 +6241,7 @@ static struct mv88e6xxx_chip *mv88e6xxx_alloc_chip(struct device *dev)
 	mutex_init(&chip->reg_lock);
 	INIT_LIST_HEAD(&chip->mdios);
 	idr_init(&chip->policies);
+	INIT_LIST_HEAD(&chip->msts);
 
 	return chip;
 }
@@ -6540,10 +6774,13 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
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

