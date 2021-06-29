Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1487A3B73E7
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhF2OKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhF2OKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:10:05 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E22CC061283
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:30 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b2so5272323ejg.8
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F8Bq9LOrbkQe2teXAwhBAJEVwZD45ZGkMkz1XIbZDow=;
        b=bOyLRLO05LKRkEOc74lMre1hcIgPlqFfHeSIbnHbPi4AW+sKiRM4lbixxkhMx7H0od
         1azpY0RF/jRISRaWzcsGdNGp7xnV3LvfYg88OepcmbC4JFAXjXXzqxFfwI7mP7QF8FK1
         8TseTb6TCbMVv/F6egydkf+4UBFwgYcOqsDAjnScKoq/rqEnhyEYK/+JLLj3TJZ+inI9
         qX33sDyKc1XhNva9UXUfZ1hMt1xT/ujw/979jSj6bcs9UVIe1mrSOFJTqP6czAWRYlD0
         XMBjY0snHCATCHI30IKkum3MRWwwR9wmTTtmRUe+TArp7dcFi5+x+J6lb2nRo20/S1qo
         ElKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F8Bq9LOrbkQe2teXAwhBAJEVwZD45ZGkMkz1XIbZDow=;
        b=cSqFfC/BNGbp9cNQ6vQrR0Ztjo+34diurGzQIt7//6V9jTIrvZCekQHFnGWziLawXr
         kQJwbEyVAcOHfGGtjovxT6PYksmdi0XlPqNmPC0PNwF12xRh0sKaVlnN6lR/z6MfpBcQ
         qoiOCNmqGOybFMjmVqV7/rV7xVEzrYIvlniGqpGyDRZNruylyiQO2MuiFagDGURjaKHd
         fzpR60kwLzCzFeBE6QDUzM0Ja865I0d3LZadFzjfrmnincmPtoVmUe4gy6vsdcvUFzsk
         Mh58hfcwoHmJB0dxVpFDFOdxkv9XjwmeBLsUha6uiDvodzVdMe5B8C+lk87l8G1KPNuN
         KMEA==
X-Gm-Message-State: AOAM531mZAdoHe1CSzCpc059o6Ncr5c708E3m0Ddb+ZkP7Ol3tb2OEQ8
        lQDnhYIQODz+ybBZUPJYuMIh2HkDK68=
X-Google-Smtp-Source: ABdhPJwGiLzWQkXhkH2cvJPS6bY913LHD5WNtCSLZHr3+61wEJZBRYxbc2d4WvhTVUaI0XndLjE/YA==
X-Received: by 2002:a17:906:2cca:: with SMTP id r10mr3806844ejr.298.1624975648786;
        Tue, 29 Jun 2021 07:07:28 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:28 -0700 (PDT)
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
Subject: [PATCH v5 net-next 12/15] net: dsa: include bridge addresses which are local in the host fdb list
Date:   Tue, 29 Jun 2021 17:06:55 +0300
Message-Id: <20210629140658.2510288-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629140658.2510288-1-olteanv@gmail.com>
References: <20210629140658.2510288-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

The bridge automatically creates local (not forwarded) fdb entries
pointing towards physical ports with their interface MAC addresses.
For switchdev, the significance of these fdb entries is the exact
opposite of that of non-local entries: instead of sending these frame
outwards, we must send them inwards (towards the host).

NOTE: The bridge's own MAC address is also "local". If that address is
not shared with any port, the bridge's MAC is not be added by this
functionality - but the following commit takes care of that case.

NOTE 2: We mark these addresses as host-filtered regardless of the value
of ds->assisted_learning_on_cpu_port. This is because, as opposed to the
speculative logic done for dynamic address learning on foreign
interfaces, the local FDB entries are rather fixed, so there isn't any
risk of them migrating from one bridge port to another.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: none

 net/dsa/slave.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ea9a7c1ce83e..d006bd04f84a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2398,10 +2398,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		fdb_info = ptr;
 
 		if (dsa_slave_dev_check(dev)) {
-			if (!fdb_info->added_by_user || fdb_info->is_local)
-				return NOTIFY_OK;
-
 			dp = dsa_slave_to_port(dev);
+
+			if (fdb_info->is_local)
+				host_addr = true;
+			else if (!fdb_info->added_by_user)
+				return NOTIFY_OK;
 		} else {
 			/* Snoop addresses added to foreign interfaces
 			 * bridged with us, or the bridge
@@ -2425,9 +2427,15 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				return NOTIFY_DONE;
 
 			dp = p->dp;
-			host_addr = true;
+			host_addr = fdb_info->is_local;
 
-			if (!fdb_info->added_by_user &&
+			/* FDB entries learned by the software bridge should
+			 * be installed as host addresses only if the driver
+			 * requests assisted learning.
+			 * On the other hand, FDB entries for local termination
+			 * should always be installed.
+			 */
+			if (!fdb_info->added_by_user && !fdb_info->is_local &&
 			    !dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
 
-- 
2.25.1

