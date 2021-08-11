Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C676C3E8D8C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbhHKJvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbhHKJvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:51:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA6EC061765;
        Wed, 11 Aug 2021 02:50:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bo18so2583300pjb.0;
        Wed, 11 Aug 2021 02:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yfHklEjyVi0y+D9Q59Efd19/lK1Au76MfVqK/YYAw3w=;
        b=XlizxdegGChhgE9pvc1tXR0HauVwKnoNvrOgyr1hg5QGzCS1Xko59TMF+7HgYTCBkr
         f/KvF4ijJ6/19OPNn7gsdShJrdIjly0QW52BSb8+S5rY464qk17ejMF9cZ3sjRhKcDKR
         XwPB7W0C0rKqlk8lLClWs05Rihz/TZ6BggXleBKi60MKJqwv5XJLC5z4riwzDzvzdHnC
         JvMJpJyLgNyr56BP8sHcun2V+X2Wlyb8j0YFzupn8lA2QeYLUnyh7JUuEchVmyoxMe8f
         tVsYxF2LCIEAuZzaQnaBQqoLhdfJ0Jwy0mtbDy7PBTpNGLVnHAdXY4u2oel+84JMu+ce
         iDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yfHklEjyVi0y+D9Q59Efd19/lK1Au76MfVqK/YYAw3w=;
        b=dX+A42VA43SVNGB7rKMxzLxs6ir7WA2fDwApO/Lcut2qMvdXpMUsJWGvWyadYKmnNR
         QSsHjCuTBPsSKqm9GUZpgis6KWbNICTIqNS68DYaKI+U0OEe2YJ3clUSVARR8pgU+q+o
         996PkISi9/6aVqg3D5v2Bme8+RME/gqXzGDYmj49cVZfSjx9JFeHLySxkcSjaxfpSlR5
         ytCNRx39tyXkyPi7it2yh9NubxWHak2e4V3uHg/OBFLm5SypZnheQqJncq5g+6bs62Mg
         X7evA/atPLh4MJtN3lByDf/FDX4b+5CT+9SaR189BZsx7hpAurDlJ+GswzAJupd0BH9v
         ViFA==
X-Gm-Message-State: AOAM531BPMF+lRhmFn7FnNMslvIRvtnpQehK+aSVVxjunZcu2yArvKLq
        452YTn0xqKKLmu9pp5t9ngc=
X-Google-Smtp-Source: ABdhPJwaEw3SWt45M/YhnzJ5ndLJ5GVSKuftH9DwwoBOMkP0IR7KqL5Xph22uT1EEw6SE9e2ohkbOg==
X-Received: by 2002:a63:4f54:: with SMTP id p20mr64577pgl.437.1628675453594;
        Wed, 11 Aug 2021 02:50:53 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id w82sm2472502pff.112.2021.08.11.02.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:50:52 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:MEDIATEK SWITCH DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: mt7530: fix VLAN traffic leaks again
Date:   Wed, 11 Aug 2021 17:50:43 +0800
Message-Id: <20210811095043.1700061-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port leaves a VLAN-aware bridge, the current code does not clear
other ports' matrix field bit. If the bridge is later set to VLAN-unaware
mode, traffic in the bridge may leak to that port.

Remove the VLAN filtering check in mt7530_port_bridge_leave.

Fixes: 474a2ddaa192 ("net: dsa: mt7530: fix VLAN traffic leaks")
Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 53e6150e95b6..77e0205e4e59 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1315,11 +1315,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
-		 * And the other port's port matrix cannot be broken when the
-		 * other port is still a VLAN-aware port.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
+		if (dsa_is_user_port(ds, i) && i != port) {
 			if (dsa_to_port(ds, i)->bridge_dev != bridge)
 				continue;
 			if (priv->ports[i].enable)
-- 
2.25.1

