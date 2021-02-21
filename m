Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6792320E04
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhBUVhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhBUVfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:40 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EAEC06121C
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:18 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g5so26132943ejt.2
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDtq21AQylYrGBFcER9Qx6Te7qXrewv3zQjWDKbFUHA=;
        b=X6E7hr4cXNDfPVSCtrat1GpPG79NPTIy777v8y56NKc/Cfl6D9u6KrNaKZgKtHzs/P
         xz49bHTSPJf6oXCXKPZo4QrkCCaY4sBvnrdrVOoX/89U/qafw6ksC1G4SC/B35YtDvhC
         QV/AyqsUDRIuIsQb+X9+cYVZ70Raj5NuluI4cfHBRbpfIJ33lzhutnVyrzpS3vWwkpgF
         tSZ3T4jlwNifkI6Wsywmu2BFCL8Rdae3Pakg8M8WiO2GS6Ap7hXF0JQdc76hL1Gs5yD4
         1q0dwwFcjmrqoPMq+TemGaZVrubnwY4WN5phuJsW1lm187gpJjUhb01TnmWLD7k4hxae
         CIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDtq21AQylYrGBFcER9Qx6Te7qXrewv3zQjWDKbFUHA=;
        b=g/qjkqJF0L3Q1e9i7lzdjvu1nwoR98yalVs8l0Yk/SNTg9A7uTfD007Vd/OX/A5TG7
         y4pf0u2RdgLWDvo3iP9j+lMyGF5uQcddyMNkT8KByZuS1kABKsK++2xHE9ggROSCbdZL
         uLmfA5YkEcbIkbwkeHIb4MKQEXWlqeANL8211OFgo1jnQqiPBszXjFXnSbVG2DyeGBls
         ZFP6+bywsvWOrEJGcp27NNwhFX29YPylrtNHROxSQ6ZqbP5bhP4NmM7UBJ2okzu/6fEZ
         xpbjx2s3+kmWkkerodOnVxfFL3xcztOuMmMSr564Gfp30+DKd9JCHu96FIT9mgkXBrXq
         MSJg==
X-Gm-Message-State: AOAM531yaW29x0ldAwsEW20n0D5JNl1l6v/Mi9Tuck/0uf/Ufcp1rFHS
        XyZV6RSOt6saVMVz7CRm8uu5ic8wYeQ=
X-Google-Smtp-Source: ABdhPJwC7B/58QW2vQQQMwGm/+CRPvb4F5v4Xxx+umLZGWkSyEXrjn28gNgjQpiLSpvLWzXaN+C3PA==
X-Received: by 2002:a17:906:2652:: with SMTP id i18mr18148817ejc.213.1613943257147;
        Sun, 21 Feb 2021 13:34:17 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:16 -0800 (PST)
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
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 12/12] Documentation: networking: switchdev: fix command for static FDB entries
Date:   Sun, 21 Feb 2021 23:33:55 +0200
Message-Id: <20210221213355.1241450-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
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
---
 Documentation/networking/switchdev.rst | 47 +++++++++++++++++++-------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index 9fb3e0fd39dc..d5afd2caaf91 100644
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

