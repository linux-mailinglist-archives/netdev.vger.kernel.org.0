Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6008B33D2EA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhCPLYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhCPLYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:36 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747D6C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jt13so71542995ejb.0
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8mmUAD7BKWW5pIh8nz/334IfE8cFMNkF30yLdi/DEo=;
        b=Wk5QQ5KlWs1BKjUE6oaB+M2/Sb7y+dcIzBxR9++Oa0n1cgIykYabDuEHF0S7n2xGTO
         W2ETJjMZMu0d3TfgF4Femtk/vlbMvN6QzPP3r6buoz5j1dbNPZFNYrwPRXvSPRCyz9Jm
         hAsWwlwwCxDXehlZdFH4UbtrzsZn2NY9YvSZGfknOwWrBVTznqUXrm7PG5kzxjopP+oY
         pQ7sRfXdwHAGV6hFPZO6X0uixGbFyjpjN5YKBYcg7E8dz1HsBStHXO4UX9bRBQ4pE+9K
         x0pBlUVbFwsfSgtzVgmLIvkM4j5ZmRuaox8g5mN11ucqhhkIu9zA38GMMed642Sa3pvl
         /1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8mmUAD7BKWW5pIh8nz/334IfE8cFMNkF30yLdi/DEo=;
        b=N5NoXSdUdFoQsTwgXFGZYQwBOttNrwlOd3qd2xL7nmQadTH1YfzhOyQyQm7IosvLVc
         EU8rZ3WdmDXbYMogtIAaVDCojHVBtY5rb5TaglvXdGJ5keVYfq9NtKCDG7qJSF8ooUQa
         Gj5/8sgl52gnA8MN8ieZhPNbtiOjW43+ogGbQFvWKl4jCsjxrZIlvgXzdN9YrjaddCi4
         4vJIKg041FOZ0/PYzuzuc08xArbiin8i+2Jt5Fu8UE8yPfq5tESZILTTv4VDRDd4J8Zq
         Egb1ssbJk4rzRsITLeNE5SrjJNRdgCl45yKp2xo9UwacbWOSwT7S0NQyLVihwCrbD0EE
         Lsog==
X-Gm-Message-State: AOAM5308BO/XCoYQDra0GUJJq+HYGVob2TYHUBKL+/NxhIi2tpBQix1T
        GrM38nvc2dYn0eMPUHtXr+xw6ar9NCc=
X-Google-Smtp-Source: ABdhPJyAQngDtIbPhD6TieGy5txJwQHudVaO9gavjk9Ht48Td9rlQl5hm7D7fwG6NPRR+5DSVXq/Lw==
X-Received: by 2002:a17:907:2642:: with SMTP id ar2mr29072982ejc.145.1615893874880;
        Tue, 16 Mar 2021 04:24:34 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 08/12] Documentation: networking: dsa: add paragraph for the LAG offload
Date:   Tue, 16 Mar 2021 13:24:15 +0200
Message-Id: <20210316112419.1304230-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add a short summary of the methods that a driver writer must implement
for offloading a link aggregation group, and what is still missing.

Cc: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/dsa/dsa.rst | 33 ++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index af604fe976b3..e8576e81735c 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -724,6 +724,39 @@ Bridge VLAN filtering
   function that the driver has to call for each MAC address known to be behind
   the given port. A switchdev object is used to carry the VID and MDB info.
 
+Link aggregation
+----------------
+
+Link aggregation is implemented in the Linux networking stack by the bonding
+and team drivers, which are modeled as virtual, stackable network interfaces.
+DSA is capable of offloading a link aggregation group (LAG) to hardware that
+supports the feature, and supports bridging between physical ports and LAGs,
+as well as between LAGs. A bonding/team interface which holds multiple physical
+ports constitutes a logical port, although DSA has no explicit concept of a
+logical port at the moment. Due to this, events where a LAG joins/leaves a
+bridge are treated as if all individual physical ports that are members of that
+LAG join/leave the bridge. Switchdev port attributes (VLAN filtering, STP
+state, etc) and objects (VLANs, MDB entries) offloaded to a LAG as bridge port
+are treated similarly: DSA offloads the same switchdev object / port attribute
+on all members of the LAG. Static bridge FDB entries on a LAG are not yet
+supported, since the DSA driver API does not have the concept of a logical port
+ID.
+
+- ``port_lag_join``: function invoked when a given switch port is added to a
+  LAG. The driver may return ``-EOPNOTSUPP``, and in this case, DSA will fall
+  back to a software implementation where all traffic from this port is sent to
+  the CPU.
+- ``port_lag_leave``: function invoked when a given switch port leaves a LAG
+  and returns to operation as a standalone port.
+- ``port_lag_change``: function invoked when the link state of any member of
+  the LAG changes, and the hashing function needs rebalancing to only make use
+  of the subset of physical LAG member ports that are up.
+
+Drivers that benefit from having an ID associated with each offloaded LAG
+can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
+method. The LAG ID associated with a bonding/team interface can then be
+retrieved by a DSA switch driver using the ``dsa_lag_id`` function.
+
 TODO
 ====
 
-- 
2.25.1

