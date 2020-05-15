Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231651D5498
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEOP0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726188AbgEOP0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:26:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DE0C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:26:04 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so1078969pfb.10
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vAR8O53cRTAqk7j0ALFOMufRLgekolkaCiBhxftm2No=;
        b=JkqnyoBOyht+GTFgTHMwOITCVXUi8fp8ONeE01PTX/LcJPnTVyTel9dp3SIjvT5qPL
         8yb815yhsCLfnOr0myOeORAxQg6mjA34vXc3IZa8orpR+63r5fPaADULe8PlRAuIBslU
         p6Jf26+/ZJAHwQ/tdgsatFay2Ovu2Qu0EcFl8GssWs5q1/JIglQ7rnGq+SXosCkvGm1I
         g7jNalg7ffWP5PGkZsRw7v9I7bQjy+3eRDPNBLA44nF97gHOlkdmcnUUdWahtb8PPtTE
         7WdtF/0AoQqCsOa2u6JT9aNVyhsPewZNd0/2VK5qPmi9TEJ42RYiH475P3ZWGVyhWsmm
         WpNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vAR8O53cRTAqk7j0ALFOMufRLgekolkaCiBhxftm2No=;
        b=l4H8nZ/DbqusWsqawOqDSSSxBPL6QBrkLbqY1/hOhIwyChzwVzAcYw/YRf8J5ztLQB
         FoVXrofajRRi7CRRqqU4bbt2fQSk847wVe7HSevS+z2jY8sSuA+ZK0l2bviX7rSnla+N
         vcSZt6aQnS6jqoacTnaLeL7xxD1+LTCAb9CGAXzh5gfVBPD3Xh3AP1nl8aKTux9b3juO
         S36Tb5KuOjG79eozX3BCy63PealHVAVeu8Wvhn1EjtRms9NR5qrbRGIC8ANu7eJ+tfd5
         HYxVsBWNNPZut3+9TC2j1m+iyTz3zMBgFDTBQJ8jQpHmkTN0ULni0DPmJHKaFHF5wtJ/
         Dr+g==
X-Gm-Message-State: AOAM530yRYOU+x+bpbLpTp58xEaJB1VHh8pV9xjJaXHsEWwK/L+3LjkT
        DwQLhzfqFPIIKGtuPHRRWGvK7+6EfpUPPJ4a
X-Google-Smtp-Source: ABdhPJzTC/IOZyolbmlA50kiBsP2ldkyxN1ST18wwVqUchc91tDsc9o4eZMGeC9C/GWVTMTVgovMBw==
X-Received: by 2002:a63:1e22:: with SMTP id e34mr3755288pge.427.1589556363407;
        Fri, 15 May 2020 08:26:03 -0700 (PDT)
Received: from example.com ([2402:f000:1:1501::7416:1fdd])
        by smtp.gmail.com with ESMTPSA id j7sm2270815pfh.154.2020.05.15.08.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 08:26:02 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH net-next] net: dsa: mt7530: fix VLAN setup
Date:   Fri, 15 May 2020 23:25:55 +0800
Message-Id: <20200515152555.6572-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow DSA to add VLAN entries even if VLAN filtering is disabled, so
enabling it will not block the traffic of existent ports in the bridge

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a063d914c23f..d30542fc556a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1085,12 +1085,6 @@ mt7530_port_vlan_add(struct dsa_switch *ds, int port,
 	struct mt7530_priv *priv = ds->priv;
 	u16 vid;
 
-	/* The port is kept as VLAN-unaware if bridge with vlan_filtering not
-	 * being set.
-	 */
-	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
-		return;
-
 	mutex_lock(&priv->reg_mutex);
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; ++vid) {
@@ -1116,12 +1110,6 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 	struct mt7530_priv *priv = ds->priv;
 	u16 vid, pvid;
 
-	/* The port is kept as VLAN-unaware if bridge with vlan_filtering not
-	 * being set.
-	 */
-	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
-		return 0;
-
 	mutex_lock(&priv->reg_mutex);
 
 	pvid = priv->ports[port].pvid;
@@ -1235,6 +1223,7 @@ mt7530_setup(struct dsa_switch *ds)
 	 * as two netdev instances.
 	 */
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
+	ds->configure_vlan_while_not_filtering = true;
 
 	if (priv->id == ID_MT7530) {
 		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
-- 
2.26.2

