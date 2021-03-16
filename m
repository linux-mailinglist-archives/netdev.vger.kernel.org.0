Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0BF33D2F6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhCPLZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbhCPLYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35868C061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:40 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jt13so71543252ejb.0
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sckutMAyutoKxTGnU+hRCjp7ZyGTCTbEbQkztPY9k4Y=;
        b=oogm8x/w4wP0qB8ncU6w6uOzKHD/GwrIHJ5sFsLGond4cxliKO/0roYK0Q7oKM2RHl
         mMfQrWBqKpjZRIEEYYZqNCM7LYPWir1kiC8vNwDfmpCc93h4kjY2SJSZjlrap/gCCAev
         m4hq/QhoYf9JJvw8pmO//H3/3cADajW2YcgKhJ75z5g2jgmQZtzhZJkqhm1x7g0Estug
         4cEpGG2BrAN2GBFNprYqmNFaFn2LgIKH+ff3w/fWYG5iPQmNyTAAfm90pwKmx0d/j/QJ
         EkRhDbu6LT+1RinY2V7czSuqpXYCXdKoerXdqB68msgxkVUK3tALB9UhkQtjwl0pu1lS
         VuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sckutMAyutoKxTGnU+hRCjp7ZyGTCTbEbQkztPY9k4Y=;
        b=hsde5rkWhPCCu25woT8ojXaTpjiIi7GHVuzebKKbXyX6kYnKrAN9airQMA7BqxaAM/
         wXNVXv9nnOWOP4gBh6zPZkxVBG0u5Dhh6HjDhqv8VJpeyoLUypW0uXKh2hBbG6g8M2PV
         MrOLZK+lf4ZAKOyUJbIkLXs2qyFn4uC0F0k15egGXOS4bTYnACqL54soXaA0IMqSljNO
         wP8Lxn7JdjEY+uVwiXuh3BEg0BvMd33uzxoYUZkvcPbumvrO13hEMVypbKclCDuviSvM
         h1YWhvEYW/MNrA/q2LClwzfWz0pSAXNGEp3jbFBZ2xiVa4ZZ4k2zHdsToIM/R0Sjl0NE
         QJvg==
X-Gm-Message-State: AOAM530eSsV4L7CtSB7+kLucIpKSOmxkwvRIb6w7QUpyxsBnm0Oborio
        LlkuILwKbRYJFQUAOZRMMmZeemfGmBA=
X-Google-Smtp-Source: ABdhPJzJDoJ0YW8h0Ifi3fLpemFwd0Ti1A+vOV1yo5iL2Yt1HqwuHon7efyzbDGDvhnCVlnxkNtY8A==
X-Received: by 2002:a17:906:5d12:: with SMTP id g18mr28552997ejt.246.1615893878680;
        Tue, 16 Mar 2021 04:24:38 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 12/12] Documentation: networking: switchdev: fix command for static FDB entries
Date:   Tue, 16 Mar 2021 13:24:19 +0200
Message-Id: <20210316112419.1304230-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The "bridge fdb add" command provided in the switchdev documentation is
junk now, not only because it is syntactically incorrect and rejected by
the iproute2 bridge program, but also because it was not updated in
light of Arkadi Sharshevsky's radical switchdev refactoring in commit
29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
switchdev"). Try to explain what the intended usage pattern is with the
new kernel implementation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/switchdev.rst | 47 +++++++++++++++++++-------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index 016531a3d471..1b56367d85ad 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -181,18 +181,41 @@ To offloading L2 bridging, the switchdev driver/device should support:
 Static FDB Entries
 ^^^^^^^^^^^^^^^^^^
 
-The switchdev driver should implement ndo_fdb_add, ndo_fdb_del and ndo_fdb_dump
-to support static FDB entries installed to the device.  Static bridge FDB
-entries are installed, for example, using iproute2 bridge cmd::
-
-	bridge fdb add ADDR dev DEV [vlan VID] [self]
-
-The driver should use the helper switchdev_port_fdb_xxx ops for ndo_fdb_xxx
-ops, and handle add/delete/dump of SWITCHDEV_OBJ_ID_PORT_FDB object using
-switchdev_port_obj_xxx ops.
-
-XXX: what should be done if offloading this rule to hardware fails (for
-example, due to full capacity in hardware tables) ?
+A driver which implements the ``ndo_fdb_add``, ``ndo_fdb_del`` and
+``ndo_fdb_dump`` operations is able to support the command below, which adds a
+static bridge FDB entry::
+
+        bridge fdb add dev DEV ADDRESS [vlan VID] [self] static
+
+(the "static" keyword is non-optional: if not specified, the entry defaults to
+being "local", which means that it should not be forwarded)
+
+The "self" keyword (optional because it is implicit) has the role of
+instructing the kernel to fulfill the operation through the ``ndo_fdb_add``
+implementation of the ``DEV`` device itself. If ``DEV`` is a bridge port, this
+will bypass the bridge and therefore leave the software database out of sync
+with the hardware one.
+
+To avoid this, the "master" keyword can be used::
+
+        bridge fdb add dev DEV ADDRESS [vlan VID] master static
+
+The above command instructs the kernel to search for a master interface of
+``DEV`` and fulfill the operation through the ``ndo_fdb_add`` method of that.
+This time, the bridge generates a ``SWITCHDEV_FDB_ADD_TO_DEVICE`` notification
+which the port driver can handle and use it to program its hardware table. This
+way, the software and the hardware database will both contain this static FDB
+entry.
+
+Note: for new switchdev drivers that offload the Linux bridge, implementing the
+``ndo_fdb_add`` and ``ndo_fdb_del`` bridge bypass methods is strongly
+discouraged: all static FDB entries should be added on a bridge port using the
+"master" flag. The ``ndo_fdb_dump`` is an exception and can be implemented to
+visualize the hardware tables, if the device does not have an interrupt for
+notifying the operating system of newly learned/forgotten dynamic FDB
+addresses. In that case, the hardware FDB might end up having entries that the
+software FDB does not, and implementing ``ndo_fdb_dump`` is the only way to see
+them.
 
 Note: by default, the bridge does not filter on VLAN and only bridges untagged
 traffic.  To enable VLAN support, turn on VLAN filtering::
-- 
2.25.1

