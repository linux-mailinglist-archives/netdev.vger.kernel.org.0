Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA233AF141
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFURF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFURFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E612C051C76
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:37 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h17so9941893edw.11
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fSu4Q0hGuy8oluj1nx2hUlLrrsyIEnesNjOpjwQ6bsg=;
        b=rWToYzUgc/xVMHcT+XyYdEa2UB1YiouKUcE7ZTpXxT9jkFQ0QESw/ep/j/zP5bgniB
         MXiBmOXaifm+tFul6aQQSo53WRXg/goPtq4EADU6Rlf98fD2P/iQMum1GZhQD0hCv+Na
         Ad2KDb5w03L/u7AriFoZOcvBt6vLuq9Io+8ni7ZemDPsWt7eD+OPKPPCOXJrEiYsylLz
         xdSdcMtmZVKe22D97RdNzb3eXwK/x3fSHPl60MHHIpPA65t6IrKifz2L+ILVbwhWWiP5
         Nc0PoL4ST+nYz4XEb2jbOxHSpIIq0oYSHEk2Dn+FrBL3N20RuAw1J46NNe1RDDBQtFHt
         Ehig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fSu4Q0hGuy8oluj1nx2hUlLrrsyIEnesNjOpjwQ6bsg=;
        b=WAplwkvOr9HERV/wNN44hLOhdJmQ5PhQcJO2T/3YdToZtt0tW8S0eUd/S8Tq//uCG3
         9xPwoNLhZYVlECuBMaPi7WC1tCh92ULn/wHkW3egtZR8it4h0LGx/JIHy/ZGLAuTVBZP
         5ZHVKqmv8ze/o3c0HCYxwTDACDeL0V5o2AAkK3S2Y8gAZslfk6lZBmKifzoFcc7KH/9x
         ykk5YX849It467zYqG7YX0PMjCE2LSY94/lYSWLTF9NVRhav4Hd1tnSujv8DooK5CXGs
         B+BSTRMXkntqalxPdz/4H5JZV2uN8uO7nQsIIJmC9g+1MAzFmy8V55rd6UTrr9nX5Fo0
         8FSg==
X-Gm-Message-State: AOAM5301KxA5I3ZSoUNNBhChOpkT9tTvsWPi7DFxbq//jqomeKa83Kap
        +gep02tPmGsPd9W8ynLwVm8=
X-Google-Smtp-Source: ABdhPJxzC1qpxfSulSDBuFoRHBais+/MEIvvrJtDuGZ/Elm/gYH1tMYcx94q3yMWXYPpOuv5fqpzVg==
X-Received: by 2002:a50:aa87:: with SMTP id q7mr14238610edc.97.1624293755613;
        Mon, 21 Jun 2021 09:42:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c23sm10931093eds.57.2021.06.21.09.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:42:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/6] net: dsa: export the dsa_port_is_{user,cpu,dsa} helpers
Date:   Mon, 21 Jun 2021 19:42:15 +0300
Message-Id: <20210621164219.3780244-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621164219.3780244-1-olteanv@gmail.com>
References: <20210621164219.3780244-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The difference between dsa_is_user_port and dsa_port_is_user is that the
former needs to look up the list of ports of the DSA switch tree in
order to find the struct dsa_port, while the latter directly receives it
as an argument.

dsa_is_user_port is already in widespread use and has its place, so
there isn't any chance of converting all callers to a single form.
But being able to do:
	dsa_port_is_user(dp)
instead of
	dsa_is_user_port(dp->ds, dp->index)

is much more efficient too, especially when the "dp" comes from an
iterator over the DSA switch tree - this reduces the complexity from
quadratic to linear.

Move these helpers from dsa2.c to include/net/dsa.h so that others can
use them too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v1->v2: none

 include/net/dsa.h | 15 +++++++++++++++
 net/dsa/dsa2.c    | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 289d68e82da0..ea47783d5695 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -409,6 +409,21 @@ static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 	return NULL;
 }
 
+static inline bool dsa_port_is_dsa(struct dsa_port *port)
+{
+	return port->type == DSA_PORT_TYPE_DSA;
+}
+
+static inline bool dsa_port_is_cpu(struct dsa_port *port)
+{
+	return port->type == DSA_PORT_TYPE_CPU;
+}
+
+static inline bool dsa_port_is_user(struct dsa_port *dp)
+{
+	return dp->type == DSA_PORT_TYPE_USER;
+}
+
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
 {
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_UNUSED;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ba244fbd9646..9000a8c84baf 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -219,21 +219,6 @@ static void dsa_tree_put(struct dsa_switch_tree *dst)
 		kref_put(&dst->refcount, dsa_tree_release);
 }
 
-static bool dsa_port_is_dsa(struct dsa_port *port)
-{
-	return port->type == DSA_PORT_TYPE_DSA;
-}
-
-static bool dsa_port_is_cpu(struct dsa_port *port)
-{
-	return port->type == DSA_PORT_TYPE_CPU;
-}
-
-static bool dsa_port_is_user(struct dsa_port *dp)
-{
-	return dp->type == DSA_PORT_TYPE_USER;
-}
-
 static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
 						   struct device_node *dn)
 {
-- 
2.25.1

