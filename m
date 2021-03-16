Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF3D33D2E9
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhCPLYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhCPLYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:35 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C67AC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x21so21018247eds.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7RxxPLuNb53DtH90pDP+Np5bAnHDIr3BhHi4g+PrkFs=;
        b=K0aWYiuFHLRBuIB3i7FEzK5YXPkm9PHM22/901Bf1FKXoLH66zOW843K/r9SLX76Uq
         N9oXrigKSF0i7gEwMJio329unZfT1U0vGPve3xetlkxIJw8eAMvKYGr/RtHe9cnxRTvi
         EOQ3wNAUl6jJ/K4B/zkxym9vHwapAOqDtv388EO2UfiaVWVSZd6VvljlEK5zOmjRxgVU
         EPwhxMF2Lzwth7bal5z7280ZJJKEgfBYfZhcVeNqJg0E2O34oTgsuWrGssrJTNtsoTRt
         uRsCfZ8cjkT6xuLu9C/qgUong5vXUyCHgnDf9Y4NVKSg9e9VMlQVJ8LL7pnnSBDOANpj
         g17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7RxxPLuNb53DtH90pDP+Np5bAnHDIr3BhHi4g+PrkFs=;
        b=iH+eGk7FwtPihElYB2yfwv92fuBMOknPBUfmuBuLT/ItfPTAU5lJMQ6TP1CR4+QcLk
         lvnWYhtuUsS4bgl78Bzscq8GViRLuiff5F/J+IgUcoSkFiZutzCQGvyot8TN5yetVOuP
         NGJVYC/COAyCRv0aoqrmkJqAp7Hnk74yhQbWcZZXKTKpFuhZG/hbtC9c1w7HJ66Mww9R
         eZxHI1E3JrWq/VEQyBu7Qa2a0rhmh6Ac0pp4oF1n7VK7h2v98rculC7sLIeC4pKA6IfN
         xGmINmVp1dBo9C2zpUj3nsiAWC7J/ndgtrBpxoSFOyEdJB0TeMQOpLya2E+qUawTGNmQ
         9uDA==
X-Gm-Message-State: AOAM530qpAGylf6puXOm44U9As3Gw4+NeENc2xdcosOYQqixyom6gsHs
        thGDCo2iOccI+qpAYbrNtrvHYCtCJro=
X-Google-Smtp-Source: ABdhPJxPO8d2BXg8DJNpFRUwREkq/Z4d7wUZ9zqV7sEaK5gxFxxWKJ9i/uk1mXynTDUN2FwXooFGjw==
X-Received: by 2002:a05:6402:3493:: with SMTP id v19mr30393129edc.355.1615893873720;
        Tue, 16 Mar 2021 04:24:33 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 07/12] Documentation: networking: dsa: mention integration with devlink
Date:   Tue, 16 Mar 2021 13:24:14 +0200
Message-Id: <20210316112419.1304230-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
References: <20210316112419.1304230-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add a short summary of the devlink features supported by the DSA core.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/dsa/dsa.rst | 31 ++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 9c287dfd3c45..af604fe976b3 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -416,6 +416,7 @@ DSA currently leverages the following subsystems:
 - MDIO/PHY library: ``drivers/net/phy/phy.c``, ``mdio_bus.c``
 - Switchdev:``net/switchdev/*``
 - Device Tree for various of_* functions
+- Devlink: ``net/core/devlink.c``
 
 MDIO/PHY library
 ----------------
@@ -455,6 +456,36 @@ more specifically with its VLAN filtering portion when configuring VLANs on top
 of per-port slave network devices. As of today, the only SWITCHDEV objects
 supported by DSA are the FDB and VLAN objects.
 
+Devlink
+-------
+
+DSA registers one devlink device per physical switch in the fabric.
+For each devlink device, every physical port (i.e. user ports, CPU ports, DSA
+links or unused ports) is exposed as a devlink port.
+
+DSA drivers can make use of the following devlink features:
+- Regions: debugging feature which allows user space to dump driver-defined
+  areas of hardware information in a low-level, binary format. Both global
+  regions as well as per-port regions are supported. It is possible to export
+  devlink regions even for pieces of data that are already exposed in some way
+  to the standard iproute2 user space programs (ip-link, bridge), like address
+  tables and VLAN tables. For example, this might be useful if the tables
+  contain additional hardware-specific details which are not visible through
+  the iproute2 abstraction, or it might be useful to inspect these tables on
+  the non-user ports too, which are invisible to iproute2 because no network
+  interface is registered for them.
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

