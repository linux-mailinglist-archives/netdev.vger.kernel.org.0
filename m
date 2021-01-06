Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1852EBBEF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 10:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbhAFJxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 04:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbhAFJxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 04:53:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78DBC06135E;
        Wed,  6 Jan 2021 01:52:17 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b2so3889252edm.3;
        Wed, 06 Jan 2021 01:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EJz2f0BPU/V/WA7rRceP314TuPjibKG/K1RbisBajTo=;
        b=rQffNnMRM7oY9+l+SpdWettB2i1OKHz8Lz3g09zgPf3ec3ndhAnOqlOVCtp5BKqPAM
         GM31b+hc3zuVHBbAcpLec7UZYKcM3na7OcLpXOWW7Ra6EihpvYf2h2CwjUyaPkQRr4AW
         yNSOkgVn0HHWvWLHPGek3GC2pYiNMpP7dOPvo1nXCjHlKomgd1Znxc7FDR/AJOLuzZvp
         cvzV9WijdJ9epII9ZtODKpZytTr1MFouAn4P5mbxZ/MPaeZ1e3KkBgphqyTQpIgyDnR4
         1TGGWGRYZ+pj2w9/lL/ezmKT3iKMFaldyoxCcjtzkOJxVHrKmmlmCriikJbypo4rEfD4
         OKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EJz2f0BPU/V/WA7rRceP314TuPjibKG/K1RbisBajTo=;
        b=C2tyYiPoBpcdQK4sRkH6/oslU/bkj9+63zXvrs+UZ58u3Ypl8UbtcMF2TIUbRHexQj
         gGnMMZb5D/ytN9Ku9Y0ikbe/F//+usupwQzjquP8YuEVSLY0n7jykd7xatkftYD1FOEU
         IngzLsl34XC3OxeFCDBbYUaiUcE2vUv3pWsZ8MXNa6+DkLm56hat4WadbSE7isSWTB3x
         FW5lpfTANxBLqe0W0ZQAu7F/FqZCNQziUbu2/JqeGxO0B/6ykHd31DCrARK1SIQ2FyZP
         lztXXUZmuu0RR+upVYw/632/7SW61lfvabFQbW+crcwDegrG+vt7HKECR1Ht44QQAagC
         mefQ==
X-Gm-Message-State: AOAM530vNvVFCjzFp1Q6FC/LVeuYrKCpim6F1kcMJrIbvW9BavEc4pC5
        OoLAPfKblJzmDK2RULQSnus=
X-Google-Smtp-Source: ABdhPJwxu5waLfll8PJNcf8kYlI8DCoNBnS83NsaQszhFl33Rn+Pdbaw+WiWrPjr6CzxniORyULxNQ==
X-Received: by 2002:a50:d604:: with SMTP id x4mr3468939edi.64.1609926736645;
        Wed, 06 Jan 2021 01:52:16 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id n8sm1019587eju.33.2021.01.06.01.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 01:52:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 7/7] net: dsa: ocelot: request DSA to fix up lack of address learning on CPU port
Date:   Wed,  6 Jan 2021 11:51:36 +0200
Message-Id: <20210106095136.224739-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106095136.224739-1-olteanv@gmail.com>
References: <20210106095136.224739-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Given the following setup:

ip link add br0 type bridge
ip link set eno0 master br0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp2 master br0
ip link set swp3 master br0

Currently, packets received on a DSA slave interface (such as swp0)
which should be routed by the software bridge towards a non-switch port
(such as eno0) are also flooded towards the other switch ports (swp1,
swp2, swp3) because the destination is unknown to the hardware switch.

This patch addresses the issue by monitoring the addresses learnt by the
software bridge on eno0, and adding/deleting them as static FDB entries
on the CPU port accordingly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
None.

Changes in v3:
s/learning_broken/assisted_learning/

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7dc230677b78..90c3c76f21b2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -629,6 +629,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
+	ds->assisted_learning_on_cpu_port = true;
 
 	return 0;
 }
-- 
2.25.1

