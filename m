Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED6320DFF
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhBUVgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbhBUVff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:35 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A887FC0617A7
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:13 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id p2so19425684edm.12
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wLn5Ey/E1lc3VrlQcKa5CIQrW1vv9LmA3yA1oq69pjs=;
        b=XYMZ94DMXmdwGC3qhNIplHLxl8U/Q40SC03uVaJBiCpjHFk/8/1fYtfG2XuEUSv90M
         5LjdI3kbtaUmWYHMAIG4lu2rrYmRMuFkzYhMUjZgEcpHX4gUDtesAqtOYrBCHvrVZ99y
         0Eh/RpUMiKUfUIz5j5fuk6JCFVa8rEMahSCVEAGCy/yN11TPf05Pf90clhOLHuH4PYRT
         y4oBK6DRR79s1rWbELVcBF9AyaRWy4WyvNWkjdB5pIWHKuUpgvAyZ7XthliExztZaj9f
         kgFL6qx/Faip2iEC/FqZFA0fZ2QSW1YDPJuOsttmAEvJNZD8tqUyR8/pXgon/uS67jOV
         SyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wLn5Ey/E1lc3VrlQcKa5CIQrW1vv9LmA3yA1oq69pjs=;
        b=ovIDDIOlkLZ/0ION11HzIbSLf1TGLhMU+9mIgbHklgEbCXDMGiDuP7nDLnc4YRJRzp
         K/p+dw/GoF2oSr/4pYvLe3/DP59KMcqBYq25wsAfDb37ZZ7E5KPbke739OZiyWfHmaAf
         C2ySBHhkFGVTUXDnIB1MNVVwDcE68mN+Eb4YzHbNIm15YNDdHxfJwesNx5FKVMMkUECE
         rvhTxDGkGoAeuup8c3tr8dKpbuTTlmmvrifoPCASilYA82j2sNR442HRQojtVd0D/vi9
         Y00RfKsf8zHeLggsfcctq0HMW5J3z5usnVpYEtShv7zosI/oRDePFOs12hXEvUHRvp+c
         iUQA==
X-Gm-Message-State: AOAM532Pts2e0xiVHgLNy+jPiNHTWN+ZE/pE5JYLs7gKOe+WedQJsb/2
        CymtQlWIu1MENylyflzvAttyU41XAlI=
X-Google-Smtp-Source: ABdhPJx8R01Dj6AEB2nEH0m7YcaDc9wUhYoOzBLxsYv4jK7WrHBDKudfRZ1CJmos29LSwzcMXl+i/w==
X-Received: by 2002:aa7:cb0d:: with SMTP id s13mr19270256edt.221.1613943252207;
        Sun, 21 Feb 2021 13:34:12 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:11 -0800 (PST)
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
Subject: [RFC PATCH net-next 07/12] Documentation: networking: dsa: mention integration with devlink
Date:   Sun, 21 Feb 2021 23:33:50 +0200
Message-Id: <20210221213355.1241450-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add a short summary of the devlink features supported by the DSA core.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 3c6560a43ae0..463b48714fe9 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -394,6 +394,7 @@ DSA currently leverages the following subsystems:
 - MDIO/PHY library: ``drivers/net/phy/phy.c``, ``mdio_bus.c``
 - Switchdev:``net/switchdev/*``
 - Device Tree for various of_* functions
+- Devlink: ``net/core/devlink.c``
 
 MDIO/PHY library
 ----------------
@@ -433,6 +434,32 @@ more specifically with its VLAN filtering portion when configuring VLANs on top
 of per-port slave network devices. As of today, the only SWITCHDEV objects
 supported by DSA are the FDB and VLAN objects.
 
+Devlink
+-------
+
+DSA registers one devlink device per each physical switch in the fabric.
+For each devlink device, every physical port (i.e. user ports, CPU ports, DSA
+links and unused ports) is exposed as a devlink port.
+
+DSA drivers can make use of the following devlink features:
+- Regions: debugging feature which allows user space to dump driver-defined
+  areas of hardware information in a low-level, binary format. Both global
+  regions as well as per-port regions are supported. Since address tables and
+  VLAN tables are only inspectable by core iproute2 tools (ip-link, bridge) on
+  user ports, devlink regions can be created for dumping these tables on the
+  non-user ports too.
+- Params: a feature which enables user to configure certain low-level tunable
+  knobs pertaining to the device. Drivers may implement applicable generic
+  devlink params, or may add new device-specific devlink params.
+- Resources: a monitoring feature which enables users to see the degree of
+  utilization of certain hardware tables in the device, such as FDB, VLAN, etc.
+- Shared buffers: a QoS feature for adjusting and partitioning memory and frame
+  reservations per port and per traffic class, in the ingress and egress
+  directions, such that low-priority bulk traffic does not impede the
+  processing of high-priority critical traffic.
+
+For more details, consult ``Documentation/networking/devlink/``.
+
 Device Tree
 -----------
 
-- 
2.25.1

