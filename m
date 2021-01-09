Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969522EFBFE
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbhAIAC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAIACz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:02:55 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1094DC061757
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:15 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c7so12892759edv.6
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2J41e3i/+Yjzxn4Bjftp4/qKzypeOsG/JReX54CJ2S0=;
        b=dTIphpPG6B+J0EnWcVi0pcWWM0NuN6dPh0JMpKdkbH/gnIjcA/lQ+6Ldm3tJs+plUk
         vNkJer/I+A71eArr9PvkGLEAtQ5Ab5JOJFv5pKhoaVgm6hONn8386ewuf4qT0Xy4VQKr
         12rXmXlxqGGO6gz6XB5lJ+YeTNyB3GY+nlRmkWr98FPY4y8Tl07wj4afumwEbYNLh0lu
         KMvdl/PNO9GrIuPRm+QDEDnjpPAZMObtnAorIoBavHy/fCsGUQTGnV0eexDjqqZeAcWB
         7OKvSbDnqyJwjSUZlXf3yey76wcDMMyKYEmtZZzxrThFQ2mOmqJGHF8JXt6ryfVYQk3n
         o3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2J41e3i/+Yjzxn4Bjftp4/qKzypeOsG/JReX54CJ2S0=;
        b=lzZQnz33Gfw2vs3+RjxkED9fsART5+RHcrAbbLeS8dqhMRtTmVchNkDYoJSbalwDs+
         i/abnCtIMKGCXy6g98UAHosUEkXRGEDSlhfh8lryXpIldnByR4FlXXIM0JmXRsDMpmO6
         eOoJjNmdMpJP1Gd+21YDPpr668JHLR5mLfOiRJ6EcSiT6hIV3PPel8/3N0MDRTpq9RRa
         By8bSZozW6BAjafQH6eeTQH+WbNYBy3gxsDXZ5kgAUXPRWvZv9TctCwGuVvazfNNOCDP
         X0byjTCm22NQmDzQ9PbJptEaTG9mkyV6CfrGJ0JfSxklvNzQwBZG4kogULnCzauZ3V+h
         jSow==
X-Gm-Message-State: AOAM53067TUUGjuqag/DEvYRGB7VdNoJ3AM6J/CqDKtIr8sCTN+gk9sN
        I5GoI236JqJqIXhH36igi4g=
X-Google-Smtp-Source: ABdhPJykqH7HmxVVGoIkjCgE8LTlxOLlBGuh8o/IlYc8piJd29xp7f2DdGOW+YyTn//kpn3SOetFjw==
X-Received: by 2002:aa7:c0c2:: with SMTP id j2mr6905907edp.343.1610150533745;
        Fri, 08 Jan 2021 16:02:13 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:12 -0800 (PST)
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
Subject: [PATCH v4 net-next 02/11] net: dsa: mv88e6xxx: deny vid 0 on the CPU port and DSA links too
Date:   Sat,  9 Jan 2021 02:01:47 +0200
Message-Id: <20210109000156.1246735-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

mv88e6xxx apparently has a problem offloading VID 0, which the 8021q
module tries to install as part of commit ad1afb003939 ("vlan_dev: VLAN
0 should be treated as "no vlan tag" (802.1p packet)"). That mv88e6xxx
restriction seems to have been introduced by the "VTU GetNext VID-1
trick to retrieve a single entry" - see commit 2fb5ef09de7c ("net: dsa:
mv88e6xxx: extract single VLAN retrieval").

There is one more problem. The mv88e6xxx CPU port and DSA links do not
report properly in the prepare phase what are the VLANs that they can
offload. They'll say they can offload everything:

mv88e6xxx_port_vlan_prepare
-> mv88e6xxx_port_check_hw_vlan:

	/* DSA and CPU ports have to be members of multiple vlans */
	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
		return 0;

Except that if you actually try to commit to it, they'll error out and
print this message:

[   32.802438] mv88e6085 d0032004.mdio-mii:12: p9: failed to add VLAN 0t

which comes from:

mv88e6xxx_port_vlan_add
-> mv88e6xxx_port_vlan_join:

	if (!vid)
		return -EOPNOTSUPP;

What prevents this condition from triggering in real life? The fact that
when a DSA_NOTIFIER_VLAN_ADD is emitted, it never targets a DSA link
directly. Instead, the notifier will always target either a user port or
a CPU port. DSA links just happen to get dragged in by:

static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
				  struct dsa_notifier_vlan_info *info)
{
	...
	if (dsa_is_dsa_port(ds, port))
		return true;
	...
}

So for every DSA VLAN notifier, during the prepare phase, it will just
so happen that there will be somebody to say "no, don't do that".

This will become a problem when the switchdev prepare/commit transactional
model goes away. Every port needs to think on its own. DSA links can no
longer bluff and rely on the fact that the prepare phase will not go
through to the end, because there will be no prepare phase any longer.

Fix this issue before it becomes a problem, by having the "vid == 0"
check earlier than the check whether we are a CPU port / DSA link or not.
Also, the "vid == 0" check becomes unnecessary in the .port_vlan_add
callback, so we can remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
retouched the commit message a little bit.

Changes in v3:
Patch is new.

 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 4834be9e4e86..fb25cb87156a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1535,13 +1535,13 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
+	if (!vid)
+		return -EOPNOTSUPP;
+
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	vlan.vid = vid - 1;
 	vlan.valid = false;
 
@@ -1920,9 +1920,6 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	vlan.vid = vid - 1;
 	vlan.valid = false;
 
-- 
2.25.1

