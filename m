Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998D131AE08
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBMUrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBMUrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:47:22 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E163C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:46:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id f14so5154696ejc.8
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5EvltRHIh3CNVcmc7Uvgs492TSq/jXs5E9V1EVbQECw=;
        b=mJmngiM98ySsNq04YoY4kNHNS9TDqJeLJT7ggeMf1DYlue+Y3SbIL1tMG7r/5DWaul
         tIUMskxgoiBRaaUuRu8exb3lS4Jlj1DgQHRSTkyySH3mjOQXZD6axavl43oGQTah0leS
         cp1FsxzdOExitFHextZA3aLAs3n1/8cfCnXdsWScMEkFd1fYR2x08znjM5GUGJUn/GCn
         zHAu6lp206mIkbnjCzBspYwm2VPelqTvh0r28uLymaB21qVc3O90C1FLh1nKTM0d06ZX
         kVkaGx7Gxi07605R6h0vrUXZYxZ266lGGXCQ5AlVDbKz2j20cooyXYhxBQsET2KLDRx5
         yUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5EvltRHIh3CNVcmc7Uvgs492TSq/jXs5E9V1EVbQECw=;
        b=PshQQqRwTTdTF4vnvVXL39xbj3WxCB2yZx5fEcThE5pbSIMloeRweyd2TwNAuBpHH7
         L2jecpsEUJHw7V2lNAhk+EC+aXJw8UERwZY2QOxfVVysASMsjfVj7/WyUBToFcGmHv9Y
         88Pxi7ePkSz1v0rrb2PVtTSDmvmfNeevcTGXItlo1a1nynSMBemoke1hdsiHmnTqJhgv
         cTzF22YNOscECg8Tb0YbRQp2nrmAHxCjiOqmOb5nE+vr5/05NTpHwOCwksFi2MI6eIw0
         cT1njDqJ+4aLRrw1s2d0zscfKkQ8c7uOT5leFqwtXToMuWMziY24cJbs4qrpsQIYCjg9
         Mzlw==
X-Gm-Message-State: AOAM533Nr3OekdD8F4xy/Hk2TfRCq963GTp6I8CK57i0RE8uPPYpt639
        w4vG0PYo4eis6JtmkvfwHTI=
X-Google-Smtp-Source: ABdhPJzpKFCM+Rkx+/4QmtF67JogB9uJAOaXHEB3++Qsgmp/HvBe9PxYbuWlO264QE1w9QC/Oofa2Q==
X-Received: by 2002:a17:906:d214:: with SMTP id w20mr8962965ejz.284.1613249200392;
        Sat, 13 Feb 2021 12:46:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i13sm170330edk.38.2021.02.13.12.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:46:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: make devlink property best_effort_vlan_filtering true by default
Date:   Sat, 13 Feb 2021 22:46:32 +0200
Message-Id: <20210213204632.1227098-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105 driver has a limitation, extensively described under
Documentation/networking/dsa/sja1105.rst and
Documentation/networking/devlink/sja1105.rst, which says that when the
ports are under a bridge with vlan_filtering=1, traffic to and from
the network stack is not possible, unless the driver-specific
best_effort_vlan_filtering devlink parameter is enabled.

For users, this creates a 'wtf' moment. They need to go to the
documentation and find about the existence of this property, then maybe
install devlink and set it to true.

Having best_effort_vlan_filtering enabled by the kernel by default
delays that 'wtf' moment (maybe up to the point that it never even
happens). The user doesn't need to care that the driver supports
addressing the ports individually by retagging VLAN IDs until he/she
needs to use more than 32 VLAN IDs (since there can be at most 32
retagging rules). Only then do they need to think whether they need the
full VLAN table, at the expense of no individual port addressing, or
not.

But the odds that an sja1105 user will need more than 32 VLANs
terminated by the CPU is probably low. And, if we were to follow the
principle that more advanced use cases should require more advanced
preparation steps, then it makes more sense for ping to 'just work'
while CPU termination of > 32 VLAN IDs to require a bit more forethought
and possibly a driver-specific devlink param.

So we should be able to safely change the default here, and make this
driver act just a little bit more sanely out of the box.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1dad94540cc9..260073e830c7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2936,6 +2936,8 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
+	priv->best_effort_vlan_filtering = true;
+
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
 		return rc;
-- 
2.25.1

