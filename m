Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADFE2EFBFB
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbhAIACz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAIACy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:02:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BD8C061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:13 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so16844330ejb.3
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m1JXqRY6INmFGeiRJU3x/opymDcRY1p58um4LB2rBFo=;
        b=oTYWHK/sKvsbUli1N6bJsuc742tgTHJCkou2pe4JG4Q3WdTJtBVwCS/mFwpE5tJUa2
         pWV3waJydGTl54KgivlCAJdfojcpDrvjBle5XzwXGVhM3IJ2rQS+nyzBRetmvIx8WJQ0
         zu1ANEkpI+nKHtBGSPc4a/a1/uDXQoeVTM8pNgbf20w0zZUCQ0D533Afv8M4K47t4181
         ZcYiGfdxBLFPutkIAdF+xxNUrUNoquEM487eNdB73Y2o9F5rEXwn0y2TmoQzrAMnXDq3
         9izuRmSTI+QJlakokXLeOtMXQ/qapThKBjUdvlktlLxvieVszaYJf0ew8/1hugnyAIzd
         HURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m1JXqRY6INmFGeiRJU3x/opymDcRY1p58um4LB2rBFo=;
        b=gl4pCY2oYav2+HPZCqU2JoQYj+U7aiyQ9LJPWtJBvGVS/zleUl9Ua3wjgXmepNd5rc
         GWATbyDMLNowNfXppjQHBwLbsWehwf3FZC7EkaG11TDRqQuoQ4TmLTSe+SUH7uu4WQRc
         QImZzwKtogn3PrRePk85JcZeDaxl1GC5g1XFjM+xIlX+TQWKpeaG7e52obglA8jGfo4z
         w5DWPhG1ZftDT6DvluyG1SRuvf3zzFzHry9cDihXlQbhoE8LzvJKfBZgLUiQiWQbUmTi
         XnXLEgVEaSredBUZ61edxLml5qADQ3jK/IOPZhu4ELYSbE8wL8YpZROEWd1ZNyqvxRe/
         oJDQ==
X-Gm-Message-State: AOAM533TMv9htji9wMrxSYLvLLDKXXT0Bh1KBqhDFl+ynnLklSEUV0W4
        OUy9EcJkt7Cj+SXJmfVFngY=
X-Google-Smtp-Source: ABdhPJyw73Y8zNIYpv2Z/0B4i5HAioidW+aV2dHpUQbg0hTKYlDDOJIMQGNb2VIRu/wrfhiaVlXyYA==
X-Received: by 2002:a17:907:3e02:: with SMTP id hp2mr4029046ejc.411.1610150531833;
        Fri, 08 Jan 2021 16:02:11 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 01/11] net: switchdev: remove vid_begin -> vid_end range from VLAN objects
Date:   Sat,  9 Jan 2021 02:01:46 +0200
Message-Id: <20210109000156.1246735-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The call path of a switchdev VLAN addition to the bridge looks something
like this today:

        nbp_vlan_init
        |  __br_vlan_set_default_pvid
        |  |                       |
        |  |    br_afspec          |
        |  |        |              |
        |  |        v              |
        |  | br_process_vlan_info  |
        |  |        |              |
        |  |        v              |
        |  |   br_vlan_info        |
        |  |       / \            /
        |  |      /   \          /
        |  |     /     \        /
        |  |    /       \      /
        v  v   v         v    v
      nbp_vlan_add   br_vlan_add ------+
       |              ^      ^ |       |
       |             /       | |       |
       |            /       /  /       |
       \ br_vlan_get_master/  /        v
        \        ^        /  /  br_vlan_add_existing
         \       |       /  /          |
          \      |      /  /          /
           \     |     /  /          /
            \    |    /  /          /
             \   |   /  /          /
              v  |   | v          /
              __vlan_add         /
                 / |            /
                /  |           /
               v   |          /
   __vlan_vid_add  |         /
               \   |        /
                v  v        v
      br_switchdev_port_vlan_add

The ranges UAPI was introduced to the bridge in commit bdced7ef7838
("bridge: support for multiple vlans and vlan ranges in setlink and
dellink requests") (Jan 10 2015). But the VLAN ranges (parsed in br_afspec)
have always been passed one by one, through struct bridge_vlan_info
tmp_vinfo, to br_vlan_info. So the range never went too far in depth.

Then Scott Feldman introduced the switchdev_port_bridge_setlink function
in commit 47f8328bb1a4 ("switchdev: add new switchdev bridge setlink").
That marked the introduction of the SWITCHDEV_OBJ_PORT_VLAN, which made
full use of the range. But switchdev_port_bridge_setlink was called like
this:

br_setlink
-> br_afspec
-> switchdev_port_bridge_setlink

Basically, the switchdev and the bridge code were not tightly integrated.
Then commit 41c498b9359e ("bridge: restore br_setlink back to original")
came, and switchdev drivers were required to implement
.ndo_bridge_setlink = switchdev_port_bridge_setlink for a while.

In the meantime, commits such as 0944d6b5a2fa ("bridge: try switchdev op
first in __vlan_vid_add/del") finally made switchdev penetrate the
br_vlan_info() barrier and start to develop the call path we have today.
But remember, br_vlan_info() still receives VLANs one by one.

Then Arkadi Sharshevsky refactored the switchdev API in 2017 in commit
29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
switchdev") so that drivers would not implement .ndo_bridge_setlink any
longer. The switchdev_port_bridge_setlink also got deleted.
This refactoring removed the parallel bridge_setlink implementation from
switchdev, and left the only switchdev VLAN objects to be the ones
offloaded from __vlan_vid_add (basically RX filtering) and  __vlan_add
(the latter coming from commit 9c86ce2c1ae3 ("net: bridge: Notify about
bridge VLANs")).

That is to say, today the switchdev VLAN object ranges are not used in
the kernel. Refactoring the above call path is a bit complicated, when
the bridge VLAN call path is already a bit complicated.

Let's go off and finish the job of commit 29ab586c3d83 by deleting the
bogus iteration through the VLAN ranges from the drivers. Some aspects
of this feature never made too much sense in the first place. For
example, what is a range of VLANs all having the BRIDGE_VLAN_INFO_PVID
flag supposed to mean, when a port can obviously have a single pvid?
This particular configuration _is_ denied as of commit 6623c60dc28e
("bridge: vlan: enforce no pvid flag in vlan ranges"), but from an API
perspective, the driver still has to play pretend, and only offload the
vlan->vid_end as pvid. And the addition of a switchdev VLAN object can
modify the flags of another, completely unrelated, switchdev VLAN
object! (a VLAN that is PVID will invalidate the PVID flag from whatever
other VLAN had previously been offloaded with switchdev and had that
flag. Yet switchdev never notifies about that change, drivers are
supposed to guess).

Nonetheless, having a VLAN range in the API makes error handling look
scarier than it really is - unwinding on errors and all of that.
When in reality, no one really calls this API with more than one VLAN.
It is all unnecessary complexity.

And despite appearing pretentious (two-phase transactional model and
all), the switchdev API is really sloppy because the VLAN addition and
removal operations are not paired with one another (you can add a VLAN
100 times and delete it just once). The bridge notifies through
switchdev of a VLAN addition not only when the flags of an existing VLAN
change, but also when nothing changes. There are switchdev drivers out
there who don't like adding a VLAN that has already been added, and
those checks don't really belong at driver level. But the fact that the
API contains ranges is yet another factor that prevents this from being
addressed in the future.

Of the existing switchdev pieces of hardware, it appears that only
Mellanox Spectrum supports offloading more than one VLAN at a time,
through mlxsw_sp_port_vlan_set. I have kept that code internal to the
driver, because there is some more bookkeeping that makes use of it, but
I deleted it from the switchdev API. But since the switchdev support for
ranges has already been de facto deleted by a Mellanox employee and
nobody noticed for 4 years, I'm going to assume it's not a biggie.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com> # switchdev and mlxsw
---
Changes in v3:
- Touch up the commit message a little bit.
- s/vid/vlan->vid/ in mv88e6xxx dev_err() printf message.

 drivers/net/dsa/b53/b53_common.c              |  54 ++++----
 drivers/net/dsa/bcm_sf2_cfp.c                 |   3 +-
 drivers/net/dsa/dsa_loop.c                    |  46 +++----
 drivers/net/dsa/hirschmann/hellcreek.c        |  22 ++--
 drivers/net/dsa/lantiq_gswip.c                |  61 ++++------
 drivers/net/dsa/microchip/ksz8795.c           |  62 +++++-----
 drivers/net/dsa/microchip/ksz9477.c           |  66 +++++-----
 drivers/net/dsa/mt7530.c                      |  32 ++---
 drivers/net/dsa/mv88e6xxx/chip.c              |  89 +++++++-------
 drivers/net/dsa/ocelot/felix.c                |  42 ++-----
 drivers/net/dsa/qca8k.c                       |  17 +--
 drivers/net/dsa/rtl8366.c                     | 115 ++++++++----------
 drivers/net/dsa/sja1105/sja1105_main.c        |  33 ++---
 .../marvell/prestera/prestera_switchdev.c     |  18 +--
 .../mellanox/mlxsw/spectrum_switchdev.c       |  63 +++-------
 drivers/net/ethernet/mscc/ocelot_net.c        |  41 ++-----
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  20 +--
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  33 +----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  47 +++----
 include/net/switchdev.h                       |   3 +-
 net/bridge/br_switchdev.c                     |   6 +-
 net/dsa/slave.c                               |  23 ++--
 22 files changed, 324 insertions(+), 572 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 288b5a5c3e0d..7470fcd4da35 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1393,7 +1393,7 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 {
 	struct b53_device *dev = ds->priv;
 
-	if ((is5325(dev) || is5365(dev)) && vlan->vid_begin == 0)
+	if ((is5325(dev) || is5365(dev)) && vlan->vid == 0)
 		return -EOPNOTSUPP;
 
 	/* Port 7 on 7278 connects to the ASP's UniMAC which is not capable of
@@ -1404,7 +1404,7 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	    !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return -EINVAL;
 
-	if (vlan->vid_end > dev->num_vlans)
+	if (vlan->vid > dev->num_vlans)
 		return -ERANGE;
 
 	b53_enable_vlan(dev, true, ds->vlan_filtering);
@@ -1420,30 +1420,27 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct b53_vlan *vl;
-	u16 vid;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		vl = &dev->vlans[vid];
+	vl = &dev->vlans[vlan->vid];
 
-		b53_get_vlan_entry(dev, vid, vl);
+	b53_get_vlan_entry(dev, vlan->vid, vl);
 
-		if (vid == 0 && vid == b53_default_pvid(dev))
-			untagged = true;
+	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
+		untagged = true;
 
-		vl->members |= BIT(port);
-		if (untagged && !dsa_is_cpu_port(ds, port))
-			vl->untag |= BIT(port);
-		else
-			vl->untag &= ~BIT(port);
+	vl->members |= BIT(port);
+	if (untagged && !dsa_is_cpu_port(ds, port))
+		vl->untag |= BIT(port);
+	else
+		vl->untag &= ~BIT(port);
 
-		b53_set_vlan_entry(dev, vid, vl);
-		b53_fast_age_vlan(dev, vid);
-	}
+	b53_set_vlan_entry(dev, vlan->vid, vl);
+	b53_fast_age_vlan(dev, vlan->vid);
 
 	if (pvid && !dsa_is_cpu_port(ds, port)) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
-			    vlan->vid_end);
-		b53_fast_age_vlan(dev, vid);
+			    vlan->vid);
+		b53_fast_age_vlan(dev, vlan->vid);
 	}
 }
 EXPORT_SYMBOL(b53_vlan_add);
@@ -1454,27 +1451,24 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	struct b53_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct b53_vlan *vl;
-	u16 vid;
 	u16 pvid;
 
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		vl = &dev->vlans[vid];
+	vl = &dev->vlans[vlan->vid];
 
-		b53_get_vlan_entry(dev, vid, vl);
+	b53_get_vlan_entry(dev, vlan->vid, vl);
 
-		vl->members &= ~BIT(port);
+	vl->members &= ~BIT(port);
 
-		if (pvid == vid)
-			pvid = b53_default_pvid(dev);
+	if (pvid == vlan->vid)
+		pvid = b53_default_pvid(dev);
 
-		if (untagged && !dsa_is_cpu_port(ds, port))
-			vl->untag &= ~(BIT(port));
+	if (untagged && !dsa_is_cpu_port(ds, port))
+		vl->untag &= ~(BIT(port));
 
-		b53_set_vlan_entry(dev, vid, vl);
-		b53_fast_age_vlan(dev, vid);
-	}
+	b53_set_vlan_entry(dev, vlan->vid, vl);
+	b53_fast_age_vlan(dev, vlan->vid);
 
 	b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), pvid);
 	b53_fast_age_vlan(dev, pvid);
diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index d82cee5d9202..59d799ac1b60 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -885,8 +885,7 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 			return -EINVAL;
 
 		vid = be16_to_cpu(fs->h_ext.vlan_tci) & VLAN_VID_MASK;
-		vlan.vid_begin = vid;
-		vlan.vid_end = vid;
+		vlan.vid = vid;
 		if (cpu_to_be32(fs->h_ext.data[1]) & 1)
 			vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED;
 		else
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index e38906ae8f23..3be9f665d174 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -206,13 +206,12 @@ dsa_loop_port_vlan_prepare(struct dsa_switch *ds, int port,
 	struct dsa_loop_priv *ps = ds->priv;
 	struct mii_bus *bus = ps->bus;
 
-	dev_dbg(ds->dev, "%s: port: %d, vlan: %d-%d",
-		__func__, port, vlan->vid_begin, vlan->vid_end);
+	dev_dbg(ds->dev, "%s: port: %d, vlan: %d", __func__, port, vlan->vid);
 
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
 
-	if (vlan->vid_end > ARRAY_SIZE(ps->vlans))
+	if (vlan->vid > ARRAY_SIZE(ps->vlans))
 		return -ERANGE;
 
 	return 0;
@@ -226,26 +225,23 @@ static void dsa_loop_port_vlan_add(struct dsa_switch *ds, int port,
 	struct dsa_loop_priv *ps = ds->priv;
 	struct mii_bus *bus = ps->bus;
 	struct dsa_loop_vlan *vl;
-	u16 vid;
 
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		vl = &ps->vlans[vid];
+	vl = &ps->vlans[vlan->vid];
 
-		vl->members |= BIT(port);
-		if (untagged)
-			vl->untagged |= BIT(port);
-		else
-			vl->untagged &= ~BIT(port);
+	vl->members |= BIT(port);
+	if (untagged)
+		vl->untagged |= BIT(port);
+	else
+		vl->untagged &= ~BIT(port);
 
-		dev_dbg(ds->dev, "%s: port: %d vlan: %d, %stagged, pvid: %d\n",
-			__func__, port, vid, untagged ? "un" : "", pvid);
-	}
+	dev_dbg(ds->dev, "%s: port: %d vlan: %d, %stagged, pvid: %d\n",
+		__func__, port, vlan->vid, untagged ? "un" : "", pvid);
 
 	if (pvid)
-		ps->ports[port].pvid = vid;
+		ps->ports[port].pvid = vlan->vid;
 }
 
 static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
@@ -253,26 +249,24 @@ static int dsa_loop_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct dsa_loop_priv *ps = ds->priv;
+	u16 pvid = ps->ports[port].pvid;
 	struct mii_bus *bus = ps->bus;
 	struct dsa_loop_vlan *vl;
-	u16 vid, pvid = ps->ports[port].pvid;
 
 	/* Just do a sleeping operation to make lockdep checks effective */
 	mdiobus_read(bus, ps->port_base + port, MII_BMSR);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		vl = &ps->vlans[vid];
+	vl = &ps->vlans[vlan->vid];
 
-		vl->members &= ~BIT(port);
-		if (untagged)
-			vl->untagged &= ~BIT(port);
+	vl->members &= ~BIT(port);
+	if (untagged)
+		vl->untagged &= ~BIT(port);
 
-		if (pvid == vid)
-			pvid = 1;
+	if (pvid == vlan->vid)
+		pvid = 1;
 
-		dev_dbg(ds->dev, "%s: port: %d vlan: %d, %stagged, pvid: %d\n",
-			__func__, port, vid, untagged ? "un" : "", pvid);
-	}
+	dev_dbg(ds->dev, "%s: port: %d vlan: %d, %stagged, pvid: %d\n",
+		__func__, port, vlan->vid, untagged ? "un" : "", pvid);
 	ps->ports[port].pvid = pvid;
 
 	return 0;
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 6420b76ea37c..a59cc40170fc 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -348,14 +348,12 @@ static int hellcreek_vlan_prepare(struct dsa_switch *ds, int port,
 	 */
 	for (i = 0; i < hellcreek->pdata->num_ports; ++i) {
 		const u16 restricted_vid = hellcreek_private_vid(i);
-		u16 vid;
 
 		if (!dsa_is_user_port(ds, i))
 			continue;
 
-		for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-			if (vid == restricted_vid)
-				return -EBUSY;
+		if (vlan->vid == restricted_vid)
+			return -EBUSY;
 	}
 
 	return 0;
@@ -446,28 +444,22 @@ static void hellcreek_vlan_add(struct dsa_switch *ds, int port,
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct hellcreek *hellcreek = ds->priv;
-	u16 vid;
 
-	dev_dbg(hellcreek->dev, "Add VLANs (%d -- %d) on port %d, %s, %s\n",
-		vlan->vid_begin, vlan->vid_end, port,
-		untagged ? "untagged" : "tagged",
+	dev_dbg(hellcreek->dev, "Add VLAN %d on port %d, %s, %s\n",
+		vlan->vid, port, untagged ? "untagged" : "tagged",
 		pvid ? "PVID" : "no PVID");
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		hellcreek_apply_vlan(hellcreek, port, vid, pvid, untagged);
+	hellcreek_apply_vlan(hellcreek, port, vlan->vid, pvid, untagged);
 }
 
 static int hellcreek_vlan_del(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
 	struct hellcreek *hellcreek = ds->priv;
-	u16 vid;
 
-	dev_dbg(hellcreek->dev, "Remove VLANs (%d -- %d) on port %d\n",
-		vlan->vid_begin, vlan->vid_end, port);
+	dev_dbg(hellcreek->dev, "Remove VLAN %d on port %d\n", vlan->vid, port);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		hellcreek_unapply_vlan(hellcreek, port, vid);
+	hellcreek_unapply_vlan(hellcreek, port, vlan->vid);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 4b36d89bec06..d35eb2cd2924 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1146,43 +1146,38 @@ static int gswip_port_vlan_prepare(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	unsigned int max_ports = priv->hw_info->max_ports;
-	u16 vid;
-	int i;
 	int pos = max_ports;
+	int i, idx = -1;
 
 	/* We only support VLAN filtering on bridges */
 	if (!dsa_is_cpu_port(ds, port) && !bridge)
 		return -EOPNOTSUPP;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		int idx = -1;
+	/* Check if there is already a page for this VLAN */
+	for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
+		if (priv->vlans[i].bridge == bridge &&
+		    priv->vlans[i].vid == vlan->vid) {
+			idx = i;
+			break;
+		}
+	}
 
-		/* Check if there is already a page for this VLAN */
-		for (i = max_ports; i < ARRAY_SIZE(priv->vlans); i++) {
-			if (priv->vlans[i].bridge == bridge &&
-			    priv->vlans[i].vid == vid) {
-				idx = i;
+	/* If this VLAN is not programmed yet, we have to reserve
+	 * one entry in the VLAN table. Make sure we start at the
+	 * next position round.
+	 */
+	if (idx == -1) {
+		/* Look for a free slot */
+		for (; pos < ARRAY_SIZE(priv->vlans); pos++) {
+			if (!priv->vlans[pos].bridge) {
+				idx = pos;
+				pos++;
 				break;
 			}
 		}
 
-		/* If this VLAN is not programmed yet, we have to reserve
-		 * one entry in the VLAN table. Make sure we start at the
-		 * next position round.
-		 */
-		if (idx == -1) {
-			/* Look for a free slot */
-			for (; pos < ARRAY_SIZE(priv->vlans); pos++) {
-				if (!priv->vlans[pos].bridge) {
-					idx = pos;
-					pos++;
-					break;
-				}
-			}
-
-			if (idx == -1)
-				return -ENOSPC;
-		}
+		if (idx == -1)
+			return -ENOSPC;
 	}
 
 	return 0;
@@ -1195,7 +1190,6 @@ static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	u16 vid;
 
 	/* We have to receive all packets on the CPU port and should not
 	 * do any VLAN filtering here. This is also called with bridge
@@ -1205,8 +1199,7 @@ static void gswip_port_vlan_add(struct dsa_switch *ds, int port,
 	if (dsa_is_cpu_port(ds, port))
 		return;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		gswip_vlan_add_aware(priv, bridge, port, vid, untagged, pvid);
+	gswip_vlan_add_aware(priv, bridge, port, vlan->vid, untagged, pvid);
 }
 
 static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
@@ -1215,8 +1208,6 @@ static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	u16 vid;
-	int err;
 
 	/* We have to receive all packets on the CPU port and should not
 	 * do any VLAN filtering here. This is also called with bridge
@@ -1226,13 +1217,7 @@ static int gswip_port_vlan_del(struct dsa_switch *ds, int port,
 	if (dsa_is_cpu_port(ds, port))
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		err = gswip_vlan_remove(priv, bridge, port, vid, pvid, true);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return gswip_vlan_remove(priv, bridge, port, vlan->vid, pvid, true);
 }
 
 static void gswip_port_fast_age(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c973db101b72..a4c814f6a4b5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -801,32 +801,32 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, new_pvid = 0;
+	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
 
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ksz8795_r_vlan_table(dev, vid, &data);
-		ksz8795_from_vlan(data, &fid, &member, &valid);
+	ksz8795_r_vlan_table(dev, vlan->vid, &data);
+	ksz8795_from_vlan(data, &fid, &member, &valid);
 
-		/* First time to setup the VLAN entry. */
-		if (!valid) {
-			/* Need to find a way to map VID to FID. */
-			fid = 1;
-			valid = 1;
-		}
-		member |= BIT(port);
+	/* First time to setup the VLAN entry. */
+	if (!valid) {
+		/* Need to find a way to map VID to FID. */
+		fid = 1;
+		valid = 1;
+	}
+	member |= BIT(port);
 
-		ksz8795_to_vlan(fid, member, valid, &data);
-		ksz8795_w_vlan_table(dev, vid, data);
+	ksz8795_to_vlan(fid, member, valid, &data);
+	ksz8795_w_vlan_table(dev, vlan->vid, data);
 
-		/* change PVID */
-		if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
-			new_pvid = vid;
-	}
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
+		new_pvid = vlan->vid;
 
 	if (new_pvid) {
+		u16 vid;
+
 		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
 		vid &= 0xfff;
 		vid |= new_pvid;
@@ -839,7 +839,7 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, pvid, new_pvid = 0;
+	u16 data, pvid, new_pvid = 0;
 	u8 fid, member, valid;
 
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
@@ -847,24 +847,22 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 
 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ksz8795_r_vlan_table(dev, vid, &data);
-		ksz8795_from_vlan(data, &fid, &member, &valid);
+	ksz8795_r_vlan_table(dev, vlan->vid, &data);
+	ksz8795_from_vlan(data, &fid, &member, &valid);
 
-		member &= ~BIT(port);
+	member &= ~BIT(port);
 
-		/* Invalidate the entry if no more member. */
-		if (!member) {
-			fid = 0;
-			valid = 0;
-		}
+	/* Invalidate the entry if no more member. */
+	if (!member) {
+		fid = 0;
+		valid = 0;
+	}
 
-		if (pvid == vid)
-			new_pvid = 1;
+	if (pvid == vlan->vid)
+		new_pvid = 1;
 
-		ksz8795_to_vlan(fid, member, valid, &data);
-		ksz8795_w_vlan_table(dev, vid, data);
-	}
+	ksz8795_to_vlan(fid, member, valid, &data);
+	ksz8795_w_vlan_table(dev, vlan->vid, data);
 
 	if (new_pvid != pvid)
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, pvid);
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 42e647b67abd..5a6ac0749ab0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -519,33 +519,30 @@ static void ksz9477_port_vlan_add(struct dsa_switch *ds, int port,
 {
 	struct ksz_device *dev = ds->priv;
 	u32 vlan_table[3];
-	u16 vid;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		if (ksz9477_get_vlan_table(dev, vid, vlan_table)) {
-			dev_dbg(dev->dev, "Failed to get vlan table\n");
-			return;
-		}
-
-		vlan_table[0] = VLAN_VALID | (vid & VLAN_FID_M);
-		if (untagged)
-			vlan_table[1] |= BIT(port);
-		else
-			vlan_table[1] &= ~BIT(port);
-		vlan_table[1] &= ~(BIT(dev->cpu_port));
+	if (ksz9477_get_vlan_table(dev, vlan->vid, vlan_table)) {
+		dev_dbg(dev->dev, "Failed to get vlan table\n");
+		return;
+	}
 
-		vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
+	vlan_table[0] = VLAN_VALID | (vlan->vid & VLAN_FID_M);
+	if (untagged)
+		vlan_table[1] |= BIT(port);
+	else
+		vlan_table[1] &= ~BIT(port);
+	vlan_table[1] &= ~(BIT(dev->cpu_port));
 
-		if (ksz9477_set_vlan_table(dev, vid, vlan_table)) {
-			dev_dbg(dev->dev, "Failed to set vlan table\n");
-			return;
-		}
+	vlan_table[2] |= BIT(port) | BIT(dev->cpu_port);
 
-		/* change PVID */
-		if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
-			ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vid);
+	if (ksz9477_set_vlan_table(dev, vlan->vid, vlan_table)) {
+		dev_dbg(dev->dev, "Failed to set vlan table\n");
+		return;
 	}
+
+	/* change PVID */
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
+		ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, vlan->vid);
 }
 
 static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
@@ -554,30 +551,27 @@ static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
 	struct ksz_device *dev = ds->priv;
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	u32 vlan_table[3];
-	u16 vid;
 	u16 pvid;
 
 	ksz_pread16(dev, port, REG_PORT_DEFAULT_VID, &pvid);
 	pvid = pvid & 0xFFF;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		if (ksz9477_get_vlan_table(dev, vid, vlan_table)) {
-			dev_dbg(dev->dev, "Failed to get vlan table\n");
-			return -ETIMEDOUT;
-		}
+	if (ksz9477_get_vlan_table(dev, vlan->vid, vlan_table)) {
+		dev_dbg(dev->dev, "Failed to get vlan table\n");
+		return -ETIMEDOUT;
+	}
 
-		vlan_table[2] &= ~BIT(port);
+	vlan_table[2] &= ~BIT(port);
 
-		if (pvid == vid)
-			pvid = 1;
+	if (pvid == vlan->vid)
+		pvid = 1;
 
-		if (untagged)
-			vlan_table[1] &= ~BIT(port);
+	if (untagged)
+		vlan_table[1] &= ~BIT(port);
 
-		if (ksz9477_set_vlan_table(dev, vid, vlan_table)) {
-			dev_dbg(dev->dev, "Failed to set vlan table\n");
-			return -ETIMEDOUT;
-		}
+	if (ksz9477_set_vlan_table(dev, vlan->vid, vlan_table)) {
+		dev_dbg(dev->dev, "Failed to set vlan table\n");
+		return -ETIMEDOUT;
 	}
 
 	ksz_pwrite16(dev, port, REG_PORT_DEFAULT_VID, pvid);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a67cac15a724..31d2d23bc815 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1501,20 +1501,16 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct mt7530_hw_vlan_entry new_entry;
 	struct mt7530_priv *priv = ds->priv;
-	u16 vid;
 
 	mutex_lock(&priv->reg_mutex);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		mt7530_hw_vlan_entry_init(&new_entry, port, untagged);
-		mt7530_hw_vlan_update(priv, vid, &new_entry,
-				      mt7530_hw_vlan_add);
-	}
+	mt7530_hw_vlan_entry_init(&new_entry, port, untagged);
+	mt7530_hw_vlan_update(priv, vlan->vid, &new_entry, mt7530_hw_vlan_add);
 
 	if (pvid) {
 		mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK,
-			   G0_PORT_VID(vlan->vid_end));
-		priv->ports[port].pvid = vlan->vid_end;
+			   G0_PORT_VID(vlan->vid));
+		priv->ports[port].pvid = vlan->vid;
 	}
 
 	mutex_unlock(&priv->reg_mutex);
@@ -1526,22 +1522,20 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	struct mt7530_hw_vlan_entry target_entry;
 	struct mt7530_priv *priv = ds->priv;
-	u16 vid, pvid;
+	u16 pvid;
 
 	mutex_lock(&priv->reg_mutex);
 
 	pvid = priv->ports[port].pvid;
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		mt7530_hw_vlan_entry_init(&target_entry, port, 0);
-		mt7530_hw_vlan_update(priv, vid, &target_entry,
-				      mt7530_hw_vlan_del);
+	mt7530_hw_vlan_entry_init(&target_entry, port, 0);
+	mt7530_hw_vlan_update(priv, vlan->vid, &target_entry,
+			      mt7530_hw_vlan_del);
 
-		/* PVID is being restored to the default whenever the PVID port
-		 * is being removed from the VLAN.
-		 */
-		if (pvid == vid)
-			pvid = G0_PORT_VID_DEF;
-	}
+	/* PVID is being restored to the default whenever the PVID port
+	 * is being removed from the VLAN.
+	 */
+	if (pvid == vlan->vid)
+		pvid = G0_PORT_VID_DEF;
 
 	mt7530_rmw(priv, MT7530_PPBV1_P(port), G0_PORT_VID_MASK, pvid);
 	priv->ports[port].pvid = pvid;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index eafe6bedc692..4834be9e4e86 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1529,7 +1529,7 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 }
 
 static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
-					u16 vid_begin, u16 vid_end)
+					u16 vid)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_vtu_entry vlan;
@@ -1539,47 +1539,45 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
 
-	if (!vid_begin)
+	if (!vid)
 		return -EOPNOTSUPP;
 
-	vlan.vid = vid_begin - 1;
+	vlan.vid = vid - 1;
 	vlan.valid = false;
 
-	do {
-		err = mv88e6xxx_vtu_getnext(chip, &vlan);
-		if (err)
-			return err;
+	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	if (err)
+		return err;
 
-		if (!vlan.valid)
-			break;
+	if (!vlan.valid)
+		return 0;
 
-		if (vlan.vid > vid_end)
-			break;
+	if (vlan.vid != vid)
+		return 0;
 
-		for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
-			if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
-				continue;
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
+			continue;
 
-			if (!dsa_to_port(ds, i)->slave)
-				continue;
+		if (!dsa_to_port(ds, i)->slave)
+			continue;
 
-			if (vlan.member[i] ==
-			    MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
-				continue;
+		if (vlan.member[i] ==
+		    MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
+			continue;
 
-			if (dsa_to_port(ds, i)->bridge_dev ==
-			    dsa_to_port(ds, port)->bridge_dev)
-				break; /* same bridge, check next VLAN */
+		if (dsa_to_port(ds, i)->bridge_dev ==
+		    dsa_to_port(ds, port)->bridge_dev)
+			break; /* same bridge, check next VLAN */
 
-			if (!dsa_to_port(ds, i)->bridge_dev)
-				continue;
+		if (!dsa_to_port(ds, i)->bridge_dev)
+			continue;
 
-			dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
-				port, vlan.vid, i,
-				netdev_name(dsa_to_port(ds, i)->bridge_dev));
-			return -EOPNOTSUPP;
-		}
-	} while (vlan.vid < vid_end);
+		dev_err(ds->dev, "p%d: hw VLAN %d already used by port %d in %s\n",
+			port, vlan.vid, i,
+			netdev_name(dsa_to_port(ds, i)->bridge_dev));
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
@@ -1617,8 +1615,7 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 	 * members, do not support it (yet) and fallback to software VLAN.
 	 */
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_check_hw_vlan(ds, port, vlan->vid_begin,
-					   vlan->vid_end);
+	err = mv88e6xxx_port_check_hw_vlan(ds, port, vlan->vid);
 	mv88e6xxx_reg_unlock(chip);
 
 	/* We don't need any dynamic resource from the kernel (yet),
@@ -1978,7 +1975,6 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	bool warn;
 	u8 member;
-	u16 vid;
 
 	if (!mv88e6xxx_max_vid(chip))
 		return;
@@ -1997,14 +1993,13 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid)
-		if (mv88e6xxx_port_vlan_join(chip, port, vid, member, warn))
-			dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
-				vid, untagged ? 'u' : 't');
+	if (mv88e6xxx_port_vlan_join(chip, port, vlan->vid, member, warn))
+		dev_err(ds->dev, "p%d: failed to add VLAN %d%c\n", port,
+			vlan->vid, untagged ? 'u' : 't');
 
-	if (pvid && mv88e6xxx_port_set_pvid(chip, port, vlan->vid_end))
+	if (pvid && mv88e6xxx_port_set_pvid(chip, port, vlan->vid))
 		dev_err(ds->dev, "p%d: failed to set PVID %d\n", port,
-			vlan->vid_end);
+			vlan->vid);
 
 	mv88e6xxx_reg_unlock(chip);
 }
@@ -2055,8 +2050,8 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	u16 pvid, vid;
 	int err = 0;
+	u16 pvid;
 
 	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
@@ -2067,16 +2062,14 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	if (err)
 		goto unlock;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		err = mv88e6xxx_port_vlan_leave(chip, port, vid);
+	err = mv88e6xxx_port_vlan_leave(chip, port, vlan->vid);
+	if (err)
+		goto unlock;
+
+	if (vlan->vid == pvid) {
+		err = mv88e6xxx_port_set_pvid(chip, port, 0);
 		if (err)
 			goto unlock;
-
-		if (vid == pvid) {
-			err = mv88e6xxx_port_set_pvid(chip, port, 0);
-			if (err)
-				goto unlock;
-		}
 	}
 
 unlock:
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 90c3c76f21b2..216fcfbc5daf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -116,8 +116,7 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
-	u16 vid, flags = vlan->flags;
-	int err;
+	u16 flags = vlan->flags;
 
 	/* Ocelot switches copy frames as-is to the CPU, so the flags:
 	 * egress-untagged or not, pvid or not, make no difference. This
@@ -130,15 +129,9 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 	if (port == ocelot->npi)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		err = ocelot_vlan_prepare(ocelot, port, vid,
-					  flags & BRIDGE_VLAN_INFO_PVID,
-					  flags & BRIDGE_VLAN_INFO_UNTAGGED);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return ocelot_vlan_prepare(ocelot, port, vlan->vid,
+				   flags & BRIDGE_VLAN_INFO_PVID,
+				   flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
 static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
@@ -154,37 +147,18 @@ static void felix_vlan_add(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 	u16 flags = vlan->flags;
-	u16 vid;
-	int err;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		err = ocelot_vlan_add(ocelot, port, vid,
-				      flags & BRIDGE_VLAN_INFO_PVID,
-				      flags & BRIDGE_VLAN_INFO_UNTAGGED);
-		if (err) {
-			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
-				vid, port, err);
-			return;
-		}
-	}
+	ocelot_vlan_add(ocelot, port, vlan->vid,
+			flags & BRIDGE_VLAN_INFO_PVID,
+			flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
 static int felix_vlan_del(struct dsa_switch *ds, int port,
 			  const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ocelot *ocelot = ds->priv;
-	u16 vid;
-	int err;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		err = ocelot_vlan_del(ocelot, port, vid);
-		if (err) {
-			dev_err(ds->dev, "Failed to remove VLAN %d from port %d: %d\n",
-				vid, port, err);
-			return err;
-		}
-	}
-	return 0;
+	return ocelot_vlan_del(ocelot, port, vlan->vid);
 }
 
 static int felix_port_enable(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 5bdac669a339..df99c696b688 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1330,11 +1330,8 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct qca8k_priv *priv = ds->priv;
 	int ret = 0;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
-		ret = qca8k_vlan_add(priv, port, vid, untagged);
 
+	ret = qca8k_vlan_add(priv, port, vlan->vid, untagged);
 	if (ret)
 		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
 
@@ -1342,11 +1339,10 @@ qca8k_port_vlan_add(struct dsa_switch *ds, int port,
 		int shift = 16 * (port % 2);
 
 		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
-			  0xfff << shift,
-			  vlan->vid_end << shift);
+			  0xfff << shift, vlan->vid << shift);
 		qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
-			    QCA8K_PORT_VLAN_CVID(vlan->vid_end) |
-			    QCA8K_PORT_VLAN_SVID(vlan->vid_end));
+			    QCA8K_PORT_VLAN_CVID(vlan->vid) |
+			    QCA8K_PORT_VLAN_SVID(vlan->vid));
 	}
 }
 
@@ -1356,11 +1352,8 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret = 0;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
-		ret = qca8k_vlan_del(priv, port, vid);
 
+	ret = qca8k_vlan_del(priv, port, vlan->vid);
 	if (ret)
 		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
 
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 83d481ef9273..1a8f93112bc6 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -383,14 +383,11 @@ int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
-	u16 vid;
 
-	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
-		if (!smi->ops->is_vlan_valid(smi, vid))
-			return -EINVAL;
+	if (!smi->ops->is_vlan_valid(smi, vlan->vid))
+		return -EINVAL;
 
-	dev_info(smi->dev, "prepare VLANs %04x..%04x\n",
-		 vlan->vid_begin, vlan->vid_end);
+	dev_info(smi->dev, "prepare VLAN %04x\n", vlan->vid);
 
 	/* Enable VLAN in the hardware
 	 * FIXME: what's with this 4k business?
@@ -408,47 +405,38 @@ void rtl8366_vlan_add(struct dsa_switch *ds, int port,
 	struct realtek_smi *smi = ds->priv;
 	u32 member = 0;
 	u32 untag = 0;
-	u16 vid;
 	int ret;
 
-	for (vid = vlan->vid_begin; vid < vlan->vid_end; vid++)
-		if (!smi->ops->is_vlan_valid(smi, vid))
-			return;
+	if (!smi->ops->is_vlan_valid(smi, vlan->vid))
+		return;
 
 	dev_info(smi->dev, "add VLAN %d on port %d, %s, %s\n",
-		 vlan->vid_begin,
-		 port,
-		 untagged ? "untagged" : "tagged",
+		 vlan->vid, port, untagged ? "untagged" : "tagged",
 		 pvid ? " PVID" : "no PVID");
 
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		dev_err(smi->dev, "port is DSA or CPU port\n");
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		member |= BIT(port);
+	member |= BIT(port);
 
-		if (untagged)
-			untag |= BIT(port);
+	if (untagged)
+		untag |= BIT(port);
 
-		ret = rtl8366_set_vlan(smi, vid, member, untag, 0);
-		if (ret)
-			dev_err(smi->dev,
-				"failed to set up VLAN %04x",
-				vid);
+	ret = rtl8366_set_vlan(smi, vlan->vid, member, untag, 0);
+	if (ret)
+		dev_err(smi->dev, "failed to set up VLAN %04x", vlan->vid);
 
-		if (!pvid)
-			continue;
+	if (!pvid)
+		return;
 
-		ret = rtl8366_set_pvid(smi, port, vid);
-		if (ret)
-			dev_err(smi->dev,
-				"failed to set PVID on port %d to VLAN %04x",
-				port, vid);
+	ret = rtl8366_set_pvid(smi, port, vlan->vid);
+	if (ret)
+		dev_err(smi->dev, "failed to set PVID on port %d to VLAN %04x",
+			port, vlan->vid);
 
-		if (!ret)
-			dev_dbg(smi->dev, "VLAN add: added VLAN %d with PVID on port %d\n",
-				vid, port);
-	}
+	if (!ret)
+		dev_dbg(smi->dev, "VLAN add: added VLAN %d with PVID on port %d\n",
+			vlan->vid, port);
 }
 EXPORT_SYMBOL_GPL(rtl8366_vlan_add);
 
@@ -456,46 +444,39 @@ int rtl8366_vlan_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan)
 {
 	struct realtek_smi *smi = ds->priv;
-	u16 vid;
-	int ret;
+	int ret, i;
 
-	dev_info(smi->dev, "del VLAN on port %d\n", port);
+	dev_info(smi->dev, "del VLAN %04x on port %d\n", vlan->vid, port);
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		int i;
-
-		dev_info(smi->dev, "del VLAN %04x\n", vid);
+	for (i = 0; i < smi->num_vlan_mc; i++) {
+		struct rtl8366_vlan_mc vlanmc;
 
-		for (i = 0; i < smi->num_vlan_mc; i++) {
-			struct rtl8366_vlan_mc vlanmc;
+		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
+		if (ret)
+			return ret;
 
-			ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-			if (ret)
+		if (vlan->vid == vlanmc.vid) {
+			/* Remove this port from the VLAN */
+			vlanmc.member &= ~BIT(port);
+			vlanmc.untag &= ~BIT(port);
+			/*
+			 * If no ports are members of this VLAN
+			 * anymore then clear the whole member
+			 * config so it can be reused.
+			 */
+			if (!vlanmc.member && vlanmc.untag) {
+				vlanmc.vid = 0;
+				vlanmc.priority = 0;
+				vlanmc.fid = 0;
+			}
+			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
+			if (ret) {
+				dev_err(smi->dev,
+					"failed to remove VLAN %04x\n",
+					vlan->vid);
 				return ret;
-
-			if (vid == vlanmc.vid) {
-				/* Remove this port from the VLAN */
-				vlanmc.member &= ~BIT(port);
-				vlanmc.untag &= ~BIT(port);
-				/*
-				 * If no ports are members of this VLAN
-				 * anymore then clear the whole member
-				 * config so it can be reused.
-				 */
-				if (!vlanmc.member && vlanmc.untag) {
-					vlanmc.vid = 0;
-					vlanmc.priority = 0;
-					vlanmc.fid = 0;
-				}
-				ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
-				if (ret) {
-					dev_err(smi->dev,
-						"failed to remove VLAN %04x\n",
-						vid);
-					return ret;
-				}
-				break;
 			}
+			break;
 		}
 	}
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 59e00d55780b..807e65ac2518 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2611,7 +2611,6 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
-	u16 vid;
 
 	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
 		return 0;
@@ -2620,11 +2619,9 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 	 * bridge plus tagging), be sure to at least deny alterations to the
 	 * configuration done by dsa_8021q.
 	 */
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		if (vid_is_dsa_8021q(vid)) {
-			dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
-			return -EBUSY;
-		}
+	if (vid_is_dsa_8021q(vlan->vid)) {
+		dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
+		return -EBUSY;
 	}
 
 	return 0;
@@ -2799,17 +2796,14 @@ static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	bool vlan_table_changed = false;
-	u16 vid;
 	int rc;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		rc = sja1105_vlan_add_one(ds, port, vid, vlan->flags,
-					  &priv->bridge_vlans);
-		if (rc < 0)
-			return;
-		if (rc > 0)
-			vlan_table_changed = true;
-	}
+	rc = sja1105_vlan_add_one(ds, port, vlan->vid, vlan->flags,
+				  &priv->bridge_vlans);
+	if (rc < 0)
+		return;
+	if (rc > 0)
+		vlan_table_changed = true;
 
 	if (!vlan_table_changed)
 		return;
@@ -2824,14 +2818,11 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	bool vlan_table_changed = false;
-	u16 vid;
 	int rc;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		rc = sja1105_vlan_del_one(ds, port, vid, &priv->bridge_vlans);
-		if (rc > 0)
-			vlan_table_changed = true;
-	}
+	rc = sja1105_vlan_del_one(ds, port, vlan->vid, &priv->bridge_vlans);
+	if (rc > 0)
+		vlan_table_changed = true;
 
 	if (!vlan_table_changed)
 		return 0;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 7d83e1f91ef1..c87667c1cca0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1045,17 +1045,9 @@ static int prestera_port_vlans_add(struct prestera_port *port,
 	if (!bridge->vlan_enabled)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int err;
-
-		err = prestera_bridge_port_vlan_add(port, br_port,
-						    vid, flag_untagged,
-						    flag_pvid, extack);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return prestera_bridge_port_vlan_add(port, br_port,
+					     vid, flag_untagged,
+					     flag_pvid, extack);
 }
 
 static int prestera_port_obj_add(struct net_device *dev,
@@ -1081,7 +1073,6 @@ static int prestera_port_vlans_del(struct prestera_port *port,
 	struct net_device *dev = vlan->obj.orig_dev;
 	struct prestera_bridge_port *br_port;
 	struct prestera_switch *sw = port->sw;
-	u16 vid;
 
 	if (netif_is_bridge_master(dev))
 		return -EOPNOTSUPP;
@@ -1093,8 +1084,7 @@ static int prestera_port_vlans_del(struct prestera_port *port,
 	if (!br_port->bridge->vlan_enabled)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
-		prestera_bridge_port_vlan_del(port, br_port, vid);
+	prestera_bridge_port_vlan_del(port, br_port, vlan->vid);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index cea42f6ed89b..7039cff69680 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1211,23 +1211,20 @@ mlxsw_sp_br_ban_rif_pvid_change(struct mlxsw_sp *mlxsw_sp,
 				const struct switchdev_obj_port_vlan *vlan)
 {
 	u16 pvid;
-	u16 vid;
 
 	pvid = mlxsw_sp_rif_vid(mlxsw_sp, br_dev);
 	if (!pvid)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
-		if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
-			if (vid != pvid) {
-				netdev_err(br_dev, "Can't change PVID, it's used by router interface\n");
-				return -EBUSY;
-			}
-		} else {
-			if (vid == pvid) {
-				netdev_err(br_dev, "Can't remove PVID, it's used by router interface\n");
-				return -EBUSY;
-			}
+	if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
+		if (vlan->vid != pvid) {
+			netdev_err(br_dev, "Can't change PVID, it's used by router interface\n");
+			return -EBUSY;
+		}
+	} else {
+		if (vlan->vid == pvid) {
+			netdev_err(br_dev, "Can't remove PVID, it's used by router interface\n");
+			return -EBUSY;
 		}
 	}
 
@@ -1244,7 +1241,6 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct net_device *orig_dev = vlan->obj.orig_dev;
 	struct mlxsw_sp_bridge_port *bridge_port;
-	u16 vid;
 
 	if (netif_is_bridge_master(orig_dev)) {
 		int err = 0;
@@ -1269,17 +1265,9 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_port->bridge_device->vlan_enabled)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int err;
-
-		err = mlxsw_sp_bridge_port_vlan_add(mlxsw_sp_port, bridge_port,
-						    vid, flag_untagged,
-						    flag_pvid, extack);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return mlxsw_sp_bridge_port_vlan_add(mlxsw_sp_port, bridge_port,
+					     vlan->vid, flag_untagged,
+					     flag_pvid, extack);
 }
 
 static enum mlxsw_reg_sfdf_flush_type mlxsw_sp_fdb_flush_type(bool lagged)
@@ -1873,7 +1861,6 @@ static int mlxsw_sp_port_vlans_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct net_device *orig_dev = vlan->obj.orig_dev;
 	struct mlxsw_sp_bridge_port *bridge_port;
-	u16 vid;
 
 	if (netif_is_bridge_master(orig_dev))
 		return -EOPNOTSUPP;
@@ -1885,8 +1872,7 @@ static int mlxsw_sp_port_vlans_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_port->bridge_device->vlan_enabled)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
-		mlxsw_sp_bridge_port_vlan_del(mlxsw_sp_port, bridge_port, vid);
+	mlxsw_sp_bridge_port_vlan_del(mlxsw_sp_port, bridge_port, vlan->vid);
 
 	return 0;
 }
@@ -3411,7 +3397,6 @@ mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 	struct netlink_ext_ack *extack;
 	struct mlxsw_sp *mlxsw_sp;
 	struct net_device *br_dev;
-	u16 vid;
 
 	extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
 	br_dev = netdev_master_upper_dev_get(vxlan_dev);
@@ -3434,18 +3419,10 @@ mlxsw_sp_switchdev_vxlan_vlans_add(struct net_device *vxlan_dev,
 	if (!bridge_device->vlan_enabled)
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int err;
-
-		err = mlxsw_sp_switchdev_vxlan_vlan_add(mlxsw_sp, bridge_device,
-							vxlan_dev, vid,
-							flag_untagged,
-							flag_pvid, extack);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return mlxsw_sp_switchdev_vxlan_vlan_add(mlxsw_sp, bridge_device,
+						 vxlan_dev, vlan->vid,
+						 flag_untagged,
+						 flag_pvid, extack);
 }
 
 static void
@@ -3458,7 +3435,6 @@ mlxsw_sp_switchdev_vxlan_vlans_del(struct net_device *vxlan_dev,
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp *mlxsw_sp;
 	struct net_device *br_dev;
-	u16 vid;
 
 	br_dev = netdev_master_upper_dev_get(vxlan_dev);
 	if (!br_dev)
@@ -3477,9 +3453,8 @@ mlxsw_sp_switchdev_vxlan_vlans_del(struct net_device *vxlan_dev,
 	if (!bridge_device->vlan_enabled)
 		return;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
-		mlxsw_sp_switchdev_vxlan_vlan_del(mlxsw_sp, bridge_device,
-						  vxlan_dev, vid);
+	mlxsw_sp_switchdev_vxlan_vlan_del(mlxsw_sp, bridge_device, vxlan_dev,
+					  vlan->vid);
 }
 
 static int
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2bd2840d88bd..3b8718b143bb 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -893,39 +893,16 @@ static int ocelot_port_obj_add_vlan(struct net_device *dev,
 				    const struct switchdev_obj_port_vlan *vlan,
 				    struct switchdev_trans *trans)
 {
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	int ret;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-		bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-
-		if (switchdev_trans_ph_prepare(trans))
-			ret = ocelot_vlan_vid_prepare(dev, vid, pvid,
-						      untagged);
-		else
-			ret = ocelot_vlan_vid_add(dev, vid, pvid, untagged);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-static int ocelot_port_vlan_del_vlan(struct net_device *dev,
-				     const struct switchdev_obj_port_vlan *vlan)
-{
-	int ret;
-	u16 vid;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ret = ocelot_vlan_vid_del(dev, vid);
-
-		if (ret)
-			return ret;
-	}
+	if (switchdev_trans_ph_prepare(trans))
+		ret = ocelot_vlan_vid_prepare(dev, vlan->vid, pvid, untagged);
+	else
+		ret = ocelot_vlan_vid_add(dev, vlan->vid, pvid, untagged);
 
-	return 0;
+	return ret;
 }
 
 static int ocelot_port_obj_add_mdb(struct net_device *dev,
@@ -985,8 +962,8 @@ static int ocelot_port_obj_del(struct net_device *dev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		ret = ocelot_port_vlan_del_vlan(dev,
-						SWITCHDEV_OBJ_PORT_VLAN(obj));
+		ret = ocelot_vlan_vid_del(dev,
+					  SWITCHDEV_OBJ_PORT_VLAN(obj)->vid);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 		ret = ocelot_port_obj_del_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 7072b249c8bd..d9d5188b7627 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2540,32 +2540,16 @@ static int ofdpa_port_obj_vlan_add(struct rocker_port *rocker_port,
 				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ofdpa_port *ofdpa_port = rocker_port->wpriv;
-	u16 vid;
-	int err;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		err = ofdpa_port_vlan_add(ofdpa_port, vid, vlan->flags);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return ofdpa_port_vlan_add(ofdpa_port, vlan->vid, vlan->flags);
 }
 
 static int ofdpa_port_obj_vlan_del(struct rocker_port *rocker_port,
 				   const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ofdpa_port *ofdpa_port = rocker_port->wpriv;
-	u16 vid;
-	int err;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		err = ofdpa_port_vlan_del(ofdpa_port, vid, vlan->flags);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return ofdpa_port_vlan_del(ofdpa_port, vlan->vid, vlan->flags);
 }
 
 static int ofdpa_port_obj_fdb_add(struct rocker_port *rocker_port,
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 29747da5c514..8a36228acc5d 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -260,10 +260,9 @@ static int cpsw_port_vlans_add(struct cpsw_priv *priv,
 	struct net_device *orig_dev = vlan->obj.orig_dev;
 	bool cpu_port = netif_is_bridge_master(orig_dev);
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-	u16 vid;
 
 	dev_dbg(priv->dev, "VID add: %s: vid:%u flags:%X\n",
-		priv->ndev->name, vlan->vid_begin, vlan->flags);
+		priv->ndev->name, vlan->vid, vlan->flags);
 
 	if (cpu_port && !(vlan->flags & BRIDGE_VLAN_INFO_BRENTRY))
 		return 0;
@@ -271,33 +270,7 @@ static int cpsw_port_vlans_add(struct cpsw_priv *priv,
 	if (switchdev_trans_ph_prepare(trans))
 		return 0;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int err;
-
-		err = cpsw_port_vlan_add(priv, untag, pvid, vid, orig_dev);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int cpsw_port_vlans_del(struct cpsw_priv *priv,
-			       const struct switchdev_obj_port_vlan *vlan)
-
-{
-	struct net_device *orig_dev = vlan->obj.orig_dev;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		int err;
-
-		err = cpsw_port_vlan_del(priv, vid, orig_dev);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return cpsw_port_vlan_add(priv, untag, pvid, vlan->vid, orig_dev);
 }
 
 static int cpsw_port_mdb_add(struct cpsw_priv *priv,
@@ -392,7 +365,7 @@ static int cpsw_port_obj_del(struct net_device *ndev,
 
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		err = cpsw_port_vlans_del(priv, vlan);
+		err = cpsw_port_vlan_del(priv, vlan->vid, vlan->obj.orig_dev);
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index d524e92051a3..62edb8d01f4e 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -981,19 +981,14 @@ static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct dpsw_attr *attr = &ethsw->sw_attr;
-	int vid, err = 0, new_vlans = 0;
+	int err = 0;
 
 	if (switchdev_trans_ph_prepare(trans)) {
-		for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-			if (!port_priv->ethsw_data->vlans[vid])
-				new_vlans++;
-
-			/* Make sure that the VLAN is not already configured
-			 * on the switch port
-			 */
-			if (port_priv->vlans[vid] & ETHSW_VLAN_MEMBER)
-				return -EEXIST;
-		}
+		/* Make sure that the VLAN is not already configured
+		 * on the switch port
+		 */
+		if (port_priv->vlans[vlan->vid] & ETHSW_VLAN_MEMBER)
+			return -EEXIST;
 
 		/* Check if there is space for a new VLAN */
 		err = dpsw_get_attributes(ethsw->mc_io, 0, ethsw->dpsw_handle,
@@ -1002,27 +997,22 @@ static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
 			netdev_err(netdev, "dpsw_get_attributes err %d\n", err);
 			return err;
 		}
-		if (attr->max_vlans - attr->num_vlans < new_vlans)
+		if (attr->max_vlans - attr->num_vlans < 1)
 			return -ENOSPC;
 
 		return 0;
 	}
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		if (!port_priv->ethsw_data->vlans[vid]) {
-			/* this is a new VLAN */
-			err = dpaa2_switch_add_vlan(port_priv->ethsw_data, vid);
-			if (err)
-				return err;
-
-			port_priv->ethsw_data->vlans[vid] |= ETHSW_VLAN_GLOBAL;
-		}
-		err = dpaa2_switch_port_add_vlan(port_priv, vid, vlan->flags);
+	if (!port_priv->ethsw_data->vlans[vlan->vid]) {
+		/* this is a new VLAN */
+		err = dpaa2_switch_add_vlan(port_priv->ethsw_data, vlan->vid);
 		if (err)
-			break;
+			return err;
+
+		port_priv->ethsw_data->vlans[vlan->vid] |= ETHSW_VLAN_GLOBAL;
 	}
 
-	return err;
+	return dpaa2_switch_port_add_vlan(port_priv, vlan->vid, vlan->flags);
 }
 
 static int dpaa2_switch_port_lookup_address(struct net_device *netdev, int is_uc,
@@ -1155,18 +1145,11 @@ static int dpaa2_switch_port_vlans_del(struct net_device *netdev,
 				       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-	int vid, err = 0;
 
 	if (netif_is_bridge_master(vlan->obj.orig_dev))
 		return -EOPNOTSUPP;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		err = dpaa2_switch_port_del_vlan(port_priv, vid);
-		if (err)
-			break;
-	}
-
-	return err;
+	return dpaa2_switch_port_del_vlan(port_priv, vlan->vid);
 }
 
 static int dpaa2_switch_port_mdb_del(struct net_device *netdev,
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 99cd538d6519..bac7d3ba574f 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -97,8 +97,7 @@ struct switchdev_obj {
 struct switchdev_obj_port_vlan {
 	struct switchdev_obj obj;
 	u16 flags;
-	u16 vid_begin;
-	u16 vid_end;
+	u16 vid;
 };
 
 #define SWITCHDEV_OBJ_PORT_VLAN(OBJ) \
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 015209bf44aa..a9c23ef83443 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -153,8 +153,7 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 		.obj.orig_dev = dev,
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.flags = flags,
-		.vid_begin = vid,
-		.vid_end = vid,
+		.vid = vid,
 	};
 
 	return switchdev_port_obj_add(dev, &v.obj, extack);
@@ -165,8 +164,7 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 	struct switchdev_obj_port_vlan v = {
 		.obj.orig_dev = dev,
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
-		.vid_begin = vid,
-		.vid_end = vid,
+		.vid = vid,
 	};
 
 	return switchdev_port_obj_del(dev, &v.obj);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c8b842ac2600..4d0adea6e7cd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -318,7 +318,7 @@ dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
 			continue;
 
 		vid = vlan_dev_vlan_id(upper_dev);
-		if (vid >= vlan->vid_begin && vid <= vlan->vid_end)
+		if (vid == vlan->vid)
 			return -EBUSY;
 	}
 
@@ -332,7 +332,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan;
-	int vid, err;
+	int err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -367,13 +367,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
-	for (vid = vlan.vid_begin; vid <= vlan.vid_end; vid++) {
-		err = vlan_vid_add(master, htons(ETH_P_8021Q), vid);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return vlan_vid_add(master, htons(ETH_P_8021Q), vlan.vid);
 }
 
 static int dsa_slave_port_obj_add(struct net_device *dev,
@@ -419,7 +413,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
-	int vid, err;
+	int err;
 
 	if (obj->orig_dev != dev)
 		return -EOPNOTSUPP;
@@ -436,8 +430,7 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	if (err)
 		return err;
 
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++)
-		vlan_vid_del(master, htons(ETH_P_8021Q), vid);
+	vlan_vid_del(master, htons(ETH_P_8021Q), vlan->vid);
 
 	return 0;
 }
@@ -1289,8 +1282,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
-		.vid_begin = vid,
-		.vid_end = vid,
+		.vid = vid,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
@@ -1328,8 +1320,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan vlan = {
-		.vid_begin = vid,
-		.vid_end = vid,
+		.vid = vid,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
-- 
2.25.1

