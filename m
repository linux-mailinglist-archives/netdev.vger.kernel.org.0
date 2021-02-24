Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87BD323B6A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhBXLps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbhBXLoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:44:46 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD0EC06178B
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:05 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id u20so2516849ejb.7
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=piGplLjZJEQ7DaXpT0Z5Bw5Z5JllZd0C+8Mir6u6p8Q=;
        b=iCEUKryz8XWwMY5+zj/5N72y/WBdk/+tkb0u4jHpBPlD9H+Vl38/1ACiSKXYJbxc8y
         WVeWPurAb/rSLz0uK1iX/SsWGGIqICcJEZJtOI6Bgd/MQOP9n6aEX6kqPDTOVCCmzCU7
         vOvOyrCYYGAluKF9Xs8kYewQiE/15qk+4IMMc2F15+daWBjg/Ss5qyEq/pybZbRh7kIL
         I8l+jzjeAGiesjnpYgBa9mJ1aniajOI45AiOso8yUuK3hcBx59C5Yi5jOfHZAMibxLh8
         UAQ2CeXOEgkg0TqJradwx/gata98PpfuFf0TYsbWFNhqDAqQFN1O+oC4AUoq47I3yzQ6
         OM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=piGplLjZJEQ7DaXpT0Z5Bw5Z5JllZd0C+8Mir6u6p8Q=;
        b=OGCowZw18RXrts7Pg+lfEJvbEdE8p+Hs49fWX6PYOLFs1bxDkgSyVJM2/po/TcS/KZ
         QZ+hcp61q/6aS64I45+A1l7v2uKcZ7Sd8+G40p17HkZMtPO1jGk8qg5u99KH0GQvfquI
         C7DRXi4herg5rC7iGtx2tIh7I1mjvwTk7gzX/XcGejn55yKWLjZbwmewBbLhRgPbMXBM
         aXdCcS/qv3VNJQFXdpSC5UOYjNFFnJM4QbzJt7CsNyoVHoug2Nd5xMPNtHalcBi7LhiB
         KhvlkJw/EkkwK1g3dJS82ATdXHZ2kIf2FQXwAfiYlpEwAhr5DtB9xq6ffm1Uyn4KxSwb
         myRQ==
X-Gm-Message-State: AOAM533SIcJ686eGEaxvJjy98SxlHAv72M6b0ewAORCfpE3UquOaUSuW
        AfRo3Kj3RMHjVr9Nb+MDQ59QUZkGM60=
X-Google-Smtp-Source: ABdhPJzjr9eGSMD0d5xtuIP8oDmAPJmQlWpWAfQGFlmhJlxjF3YCnDqiwqU46mOPpBHVXtb7J1u1ow==
X-Received: by 2002:a17:906:c24b:: with SMTP id bl11mr2339771ejb.80.1614167044311;
        Wed, 24 Feb 2021 03:44:04 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:04 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 03/17] net: dsa: install the host MDB and FDB entries in the master's RX filter
Date:   Wed, 24 Feb 2021 13:43:36 +0200
Message-Id: <20210224114350.2791260-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
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
case, and we should still instruct the master to receive them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 12d51bdb5eea..b6ea7e21b3b6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -48,6 +48,8 @@ static int dsa_host_mdb_add(struct dsa_port *dp,
 	struct dsa_host_addr *a;
 	int err;
 
+	dev_mc_add(cpu_dp->master, mdb->addr);
+
 	if (!dp->ds->ops->port_mdb_add || !dp->ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
@@ -82,6 +84,8 @@ static int dsa_host_mdb_del(struct dsa_port *dp,
 	struct dsa_host_addr *a;
 	int err;
 
+	dev_mc_del(cpu_dp->master, mdb->addr);
+
 	if (!dp->ds->ops->port_mdb_add || !dp->ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
@@ -109,6 +113,8 @@ static int dsa_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_host_addr *a;
 	int err;
 
+	dev_uc_add(cpu_dp->master, addr);
+
 	if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
@@ -143,6 +149,8 @@ static int dsa_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	struct dsa_host_addr *a;
 	int err;
 
+	dev_uc_del(cpu_dp->master, addr);
+
 	if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-- 
2.25.1

