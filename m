Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D03B73E5
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhF2OKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhF2OKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:10:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C78DC0613A4
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t3so31475842edc.7
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VJEpKYFzBJak2d7pHyDTke1vfLEgs3xoQ1r4o4dgZM=;
        b=mc/QbPoqafxS4G4eJ7J2D7LkgO1CV8lFyrq9a/Vb5fCrZ6NqNJGNCp1sVfNMVOmBGJ
         /H8w5DqF7Gyv9+Q4z0pbeeg6nG92z2TcOsn2EfHHfBu5auXz3mbIKl7maiwv+cPCR4HN
         wxt9dZME7jeRZvIRvjcsGNYco3wKx9vBdblLSuW0g0GvQ8m6sqafxJ0xBlDXUVHC04ba
         NRk5Q6xDXz06I+9TRAUEpOESApbLOW615sUtlIdjhC+uJa7EBK1Yhpv2oVFdzu1do8jz
         VPmLCsX0y+DOn5fBGJgF3PuErRCdr1ttpm/nRdqfxybCV6PlzKbvgazZ+QzWhQjiGaaC
         EaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VJEpKYFzBJak2d7pHyDTke1vfLEgs3xoQ1r4o4dgZM=;
        b=efoo9Hp4/PHVSmRNTr+PFOB8IZpvvP3iJYRONxnzUZGSiA8ULS2ZIVPbRiDSolr8Px
         7fD8hRJImpRFScnfrF/Wm6ap47gf3EaiRPHcffNYCmFVWmHTIOAWY6Q5fVRSk40SorMi
         qqnndmg9qAxesEaYLMbfsrxAt5eq1OAdr6+faacO7TfOcqLkE0w1Njnn9oI9GBfk8ZKH
         KqX2HYW/pP6y99jmbkvtdaQmOWkgvxyT43fYoCrV8WF1S1QzOGyeMaVpOtvfC57Ba59O
         cvC6U9VQoXSyOQ4TuX9o5eTzYpMzsTZcUy+qEoVXT53d2Xye+rUV5LVmU8VXiRwlded3
         x/3g==
X-Gm-Message-State: AOAM531ze4mXoD5uKeWVf1fr01J6SPwNbsxeqmPDKAjgBdf3Y7PhLtw0
        B7u9O8JmLmI/qSmiKDCI1h1HvRiTNfk=
X-Google-Smtp-Source: ABdhPJzzfAXfG8A91ZfAhd9VFlUbP5D7uM7QPMDjKJ2arsoCGJZmYZBSKDgUjJMA5YEkx40QdTDw5A==
X-Received: by 2002:a05:6402:1581:: with SMTP id c1mr40705298edv.213.1624975646613;
        Tue, 29 Jun 2021 07:07:26 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 10/15] net: dsa: install the host MDB and FDB entries in the master's RX filter
Date:   Tue, 29 Jun 2021 17:06:53 +0300
Message-Id: <20210629140658.2510288-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If the DSA master implements strict address filtering, then the unicast
and multicast addresses kept by the DSA CPU ports should be synchronized
with the address lists of the DSA master.

Note that we want the synchronization of the master's address lists even
if the DSA switch doesn't support unicast/multicast database operations,
on the premises that the packets will be flooded to the CPU in that
case, and we should still instruct the master to receive them. This is
why we do the dev_uc_add() etc first, even if dsa_port_notify() returns
-EOPNOTSUPP. In turn, dev_uc_add() and friends return error only if
memory allocation fails, so it is probably ok to check and propagate
that error code and not just ignore it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: do the dev_uc_add before the dsa_port_notify, as was correctly
        hinted by the commit message but not implemented this way
        previously

 net/dsa/port.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1b80e0fbdfaa..778b0dc2bb39 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -655,6 +655,12 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.addr = addr,
 		.vid = vid,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dev_uc_add(cpu_dp->master, addr);
+	if (err)
+		return err;
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
 }
@@ -668,6 +674,12 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.addr = addr,
 		.vid = vid,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dev_uc_del(cpu_dp->master, addr);
+	if (err)
+		return err;
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
@@ -715,6 +727,12 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
 		.port = dp->index,
 		.mdb = mdb,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dev_mc_add(cpu_dp->master, mdb->addr);
+	if (err)
+		return err;
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
 }
@@ -727,6 +745,12 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
 		.port = dp->index,
 		.mdb = mdb,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dev_mc_del(cpu_dp->master, mdb->addr);
+	if (err)
+		return err;
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
 }
-- 
2.25.1

