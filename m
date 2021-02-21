Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B902320E00
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhBUVgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhBUVff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:35 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCA3C0617A9
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:14 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h25so5862654eds.4
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2zYyNpPOqLqu4fXlOOuGHHQD2qu3Ha8IhbOXBQeShV4=;
        b=VzaSuO2QsW1UiNl+ZpK9L6Z9bZ7jcUh98PdbEG4QIYk25P3hFTei55T/jk3W77a+pP
         /NMufkFgvxJEfP2bqhgezF5iOzgGr2zcKrCZFVTia/JatFvOQfqAU5Noi8j0BOkaAU8n
         2HCV/qSUroabwAEqzVTNPAJAJ1+G8ox5nT6jdisiRoowqArxGtvyOxakPnsG/G+WzwYe
         MWHgSKiz82fzBzWg9h7Hp4qFP/f4qBqVvVDwJYZnIUek2bQiCHwsj8oLoGHy0PpVRKUx
         kzGn8doIBLTyXZ8gQppK3sym4s2Y5dXdZRb91wSkazfCPGzrsWmCOKir4BQ8G7CV+eCV
         zWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2zYyNpPOqLqu4fXlOOuGHHQD2qu3Ha8IhbOXBQeShV4=;
        b=mWX+wULVWmwHdkDUq9vA8jmzeYCanKUeA9jUhXmifp+45SQf6BQQoOIGQsbhrY1Bnc
         6dqu3GfntKEDfVoGoBKg9M7n1xmZFmtVpiLAJPThyQm2fUifXHAqfNwcXlFvdJ78MN+V
         FNFfkAemHSVNHu0SqD0uzDYVftH+pfSrsw9Xxc5Lb+bbdg9dlz6JJhP4Fy0NWCDC2C1G
         edGJLElWJ3dn+99Ig++X7VXw/xMxKSfr07kpMPQzTYPR2RXPTHeUIn8pr6Nyq+kQGsuy
         RddR7v4DK/ARmsiBmgQHcptGt/Ne5O51FCDAXQElpjir/VCL+qWcidUVM80Qz6a1nk08
         lTtg==
X-Gm-Message-State: AOAM532jz0RP18upeNOqiiiFXaRIxLJzX2HaPC1HHJXaSH+X4Qg5jv0t
        mtxLZxlGl8iq6wnj22Qzf1OjzkufYlw=
X-Google-Smtp-Source: ABdhPJzifpBckF8vS+8jERH6Te6TkN+0X8pRB6bmuRSkyuFvDQTq4Eno6m2VxR849ZTKWiI/jd5yxQ==
X-Received: by 2002:a50:da8b:: with SMTP id q11mr20010466edj.352.1613943253205;
        Sun, 21 Feb 2021 13:34:13 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:12 -0800 (PST)
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
Subject: [RFC PATCH net-next 08/12] Documentation: networking: dsa: add paragraph for the LAG offload
Date:   Sun, 21 Feb 2021 23:33:51 +0200
Message-Id: <20210221213355.1241450-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210221213355.1241450-1-olteanv@gmail.com>
References: <20210221213355.1241450-1-olteanv@gmail.com>
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
---
 Documentation/networking/dsa/dsa.rst | 32 ++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 463b48714fe9..0a5b06cf4d45 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -698,6 +698,38 @@ Bridge VLAN filtering
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
+physical port at the moment. Due to this, events where a LAG joins/leaves a
+bridge are treated as if all individual physical ports that are members of that
+LAG join/leave the bridge. Switchdev port attributes (VLAN filtering, STP
+state, etc) on a LAG are treated similarly: DSA offloads the same switchdev
+port attribute on all members of the LAG. Switchdev objects on a LAG (FDB, MDB)
+are not yet supported, since the DSA driver API does not have the concept of a
+logical port ID.
+
+- ``port_lag_join``: function invoked when a given switch port is added to a
+  LAG. The driver may return ``-EOPNOTSUPP``, and in this case, DSA will fall
+  back to a software implementation where all traffic from this port is sent to
+  the CPU.
+- ``port_lag_leave``: function invoked when a given switch port leaves a LAG
+  and returns to operation as a standalone port.
+- ``port_lag_change``: function invoked when the link state of any member of
+  the LAG changes, and the hashing function needs rebalancing only towards the
+  subset of physical LAG member ports that are up.
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

