Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA553B73E6
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhF2OKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbhF2OKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:10:01 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535D1C061280
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id df12so31502268edb.2
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AleSypaYvGLxF9YwqjeAB9A98Pwe4iYKy7o772RJXHk=;
        b=Nq711Vd97Y+eL8tsYmvxVzEf8W94oBpkAujgT5rHMwG62rl4DDaXBOxirBo1OtTzA6
         7VSGWV8/lTkwhdnWHAXVGvKO0SryKUJszSxu2eHTLyXJ65B3VYQQ95JNeXFDfl5agcLT
         gHQckE4laVQJ/Eond361aHfygg5jVg/GRStAwR6WUDCmRN5ruTQfXwm8OSkD8FvGlXrI
         UifXUDxNAOfgNxFPCjXWSPoeqEBwUCfOn7ewfYloaiHktWv1NZTziq3xVWlCLJMHEulZ
         gX9mfn2Ma4Ln6vxRjgbIcnI5u8+xTKW8yq1FfdvAoT/aEIWzVaZxwNoU8SwEl0XToUCM
         Y/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AleSypaYvGLxF9YwqjeAB9A98Pwe4iYKy7o772RJXHk=;
        b=BRIS/hGkbsOUCjbS4GWfQWIHL0DbubxNInhzjRgqSnIsYU27xsVm2ycDh2/mB1QAdA
         wdD299/O/Xi1lcONVDlcQzjSNZQb6d+R+eY/f55fuQPXibcZtxvgPixVkW7jZcUm+bfm
         JzT4zce1zACxvHoA3ymtCQXXHZb6QIHGo3PDHK90eF/OHdH95Ktt8GwFu5NE5ltFGVKc
         z5ug7Gjam2XlzCdugbKCGtZTH44RQ6VA2UK1cafZ5wPelxatu0/LBf51OliTYQ0OggDy
         SU/tB9W9DwlKJa3sKmI7y6UgeQCjOJZKYgO1UEd6MQgqOvtBm6wB5qzccqEM3zc/n+3g
         3mzw==
X-Gm-Message-State: AOAM533U938kQH8I0iqYnlu3PkbNIwGIRn3NPtxSSlY4BYGnz13ncHd9
        znpqk9vKDZVvFt9BwZ0bGEkEIGiMkfk=
X-Google-Smtp-Source: ABdhPJxYcDzgs3MwWepeKDbOA87Z09iOpNa4nBLl+RMpDCUAf8GDvD1DQOtzyDIBX72eSbbh1s9vtw==
X-Received: by 2002:aa7:da02:: with SMTP id r2mr21526929eds.350.1624975647768;
        Tue, 29 Jun 2021 07:07:27 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:27 -0700 (PDT)
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
Subject: [PATCH v5 net-next 11/15] net: dsa: sync static FDB entries on foreign interfaces to hardware
Date:   Tue, 29 Jun 2021 17:06:54 +0300
Message-Id: <20210629140658.2510288-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA is able to install FDB entries towards the CPU port for addresses
which were dynamically learnt by the software bridge on foreign
interfaces that are in the same bridge with a DSA switch interface.
Since this behavior is opportunistic, it is guarded by the
"assisted_learning_on_cpu_port" property which can be enabled by drivers
and is not done automatically (since certain switches may support
address learning of packets coming from the CPU port).

But if those FDB entries added on the foreign interfaces are static
(added by the user) instead of dynamically learnt, currently DSA does
not do anything (and arguably it should).

Because static FDB entries are not supposed to move on their own, there
is no downside in reusing the "assisted_learning_on_cpu_port" logic to
sync static FDB entries to the DSA CPU port unconditionally, even if
assisted_learning_on_cpu_port is not requested by the driver.

For example, this situation:

   br0
   / \
swp0 dummy0

$ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master static

Results in DSA adding an entry in the hardware FDB, pointing this
address towards the CPU port.

The same is true for entries added to the bridge itself, e.g:

$ bridge fdb add 02:00:de:ad:00:01 dev br0 vlan 1 self local

(except that right now, DSA still ignores 'local' FDB entries, this will
be changed in a later patch)

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: small fixups to commit message

 net/dsa/slave.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ac7f4f200ab1..ea9a7c1ce83e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2403,9 +2403,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 			dp = dsa_slave_to_port(dev);
 		} else {
-			/* Snoop addresses learnt on foreign interfaces
-			 * bridged with us, for switches that don't
-			 * automatically learn SA from CPU-injected traffic
+			/* Snoop addresses added to foreign interfaces
+			 * bridged with us, or the bridge
+			 * itself. Dynamically learned addresses can
+			 * also be added for switches that don't
+			 * automatically learn SA from CPU-injected
+			 * traffic.
 			 */
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
@@ -2424,7 +2427,8 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			dp = p->dp;
 			host_addr = true;
 
-			if (!dp->ds->assisted_learning_on_cpu_port)
+			if (!fdb_info->added_by_user &&
+			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
 			/* When the bridge learns an address on an offloaded
-- 
2.25.1

