Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8ED2EC6BB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbhAFXSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbhAFXSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:18:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42990C06179B
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:17:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y24so5921823edt.10
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EbxwUS2rYGUws0bQmKYTB/L286zn0IPa4z98oen4UNM=;
        b=VGOfB18TjVUbip1Zz+RV3vs+fQ11ErnrjfkRi/HdwLX6q/Lffo6jAR+LhIMSEoAUfx
         wdnKaZHXOG/vo+Y89f4vLWmY8qE2VG3eAMSz5sx8SBVu630/2rrWw5fcKfWbjRZI0Tzx
         /26XiPZXn6qzaROCgv6mnxOejndpnoeLBHQuBfKQ3eEYRDM6Mg6FnajCxfWR3h1rjtAj
         5BSD27StQi27tiWLkguAGcFnLIFfGcxvR1CjR1bna93I46S1S1HJ2ieZEZZFX+vIOBWT
         vZgF5qn23KWCyxvcNqljrS0jeAdDX0D3CAY93a496fCQrqNIZ87HPWjiIuQPd7eVTtqx
         J2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EbxwUS2rYGUws0bQmKYTB/L286zn0IPa4z98oen4UNM=;
        b=G7Ne2F+rKaDMgSuujxe9eQUCOht24Sf4MLvjnI68DeqKJ/2aXDbVSrNWxFR44kJW1a
         KLJVEQ7Jlls+Si86+V8xG/G8bqbGx8qcwmakeiYFyLdTZqgQOTAndhay3Wk49cfBFp9Q
         ApmPHTyODggrfOVpLyyul+FCxJvZqzZg6x3Yn+ElO8MY11ExsstKaJgvPgUBr9DuBtKF
         qF76FZx3Vw0/rIjFuAz0A8Ig3zacd/Jn6fL5JdJUabKjDYRdlnhfiEw3dYGpfpVlwuVm
         EzpYVS9wQAMD6Nx4ya0KXe2JRFqevmgmk75umDyVusNszba+i38myVMKmhTXF7PN8dKF
         Tqfg==
X-Gm-Message-State: AOAM533rRs2GH9yMl40zyeRusJ/tlJmjGkj/C/DH2Gm5ezQ9AQFvaM4o
        e+mg79kM64bMlzsBgfoZsw0=
X-Google-Smtp-Source: ABdhPJySMAy0/br/nbl976WYYsOrNsRdql+GFy99SsqqiESZayZOujItbxt0NVnASpFS25RRk58X3w==
X-Received: by 2002:aa7:d407:: with SMTP id z7mr5828551edq.234.1609975069012;
        Wed, 06 Jan 2021 15:17:49 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:17:48 -0800 (PST)
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
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 02/11] net: dsa: mv88e6xxx: deny vid 0 on the CPU port and DSA links too
Date:   Thu,  7 Jan 2021 01:17:19 +0200
Message-Id: <20210106231728.1363126-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx apparently has a problem offloading VID 0, which the 8021q
module tries to install as part of commit ad1afb003939 ("vlan_dev: VLAN
0 should be treated as "no vlan tag" (802.1p packet)"). That mv88e6xxx
restriction seems to have been introduced by the "VTU GetNext VID-1
trick to retrieve a single entry" - see commit 2fb5ef09de7c ("net: dsa:
mv88e6xxx: extract single VLAN retrieval").

There is one more problem. The mv88e6xxx CPU port and DSA links are very
gullible. They'll say yes to whatever VLAN you ask them to offload:

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

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
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

