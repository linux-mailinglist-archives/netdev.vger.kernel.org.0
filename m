Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02142320E01
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 22:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhBUVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 16:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbhBUVff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 16:35:35 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F744C0617AA
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:15 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id do6so26120236ejc.3
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 13:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AtU1jI36zvlzU7aZb0x5ZQh27mcQmIY9drQEMcXyUJw=;
        b=kup3r1t7ARCAF93QSEV1aut0MJ8LQxyyDeLXHACPwgB/Nxf9ncF3yVrw7os4iAxCpe
         fGU9lB9i3MMFSuGkdXvgiLG2FqrsMgdrHjh9ssrZjBQl1XkYeM6QMyacsGMzUxHkUQAX
         c2LcpFBg3CuuZ+OYVBAYAzUfUhdFcZ/bcq2QOyuOvBPH3eUg6fSqqYOyAl6AlWbtEb+p
         gSMTVfOiLxtcj9v3yWSmbB9dH1n3H8zVKeQxMzsoiltRgqDXL5JFVDSTbJ+wMk8FJ4P6
         zktyHBGY+rOOpMp58hyTmkgKOha2NdoFTcHk+oFdkfpGqHD07g5aEK2Z1qTsFYEC7ScM
         xEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AtU1jI36zvlzU7aZb0x5ZQh27mcQmIY9drQEMcXyUJw=;
        b=Pc64HacFen5nLdWekuYS2MujQ8gr9GOukGyOIa1vGtmhZNiKFOezRQoUFV4mPZj4if
         xKplkOqaEczHhZTWcBUl+82GX+kHk+bp+rNI6+UY8mdGOZbCWm6MPWYLSvZjNerhnZwY
         5UbV1J0VQ9akP0cGARwkmL4PupuZkaG9zEJRMvVNcUaklHqdiAqBQp968biVEgjDYLDC
         j9Ex6SKFo9grGDG6xjvYYiLyy7R/HbsW0rnqFwA49d6TGe3F3V3Cykk5rywrDueswQOc
         SSbjDhrik9xw9cGBaaWtLQdRABLs4ZL62hOkfFnNQI6pdhMO31mXZ1tc6b7rB6jMfVqL
         0Vww==
X-Gm-Message-State: AOAM530mqnWQUyvAltLEVqJkWoPor+dP1lqojye9ggC3EHx5gunFGx85
        KYnx0clZlye/FMCefdniZexVlCDkoFw=
X-Google-Smtp-Source: ABdhPJy63mK2zLGZfQVdVsraQY6iqVvpLO/O/CSXIL4OBU5u92ggfgSOyCzAe4ZGeTjnl45eP5Q52w==
X-Received: by 2002:a17:906:70d4:: with SMTP id g20mr18435669ejk.361.1613943254191;
        Sun, 21 Feb 2021 13:34:14 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id rh22sm8948779ejb.105.2021.02.21.13.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 13:34:13 -0800 (PST)
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
Subject: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add paragraph for the MRP offload
Date:   Sun, 21 Feb 2021 23:33:52 +0200
Message-Id: <20210221213355.1241450-10-olteanv@gmail.com>
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
for getting an MRP instance to work on top of a DSA switch.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Horatiu:
- Why does ocelot support a single MRP ring if all it does is trap the
  MRP PDUs to the CPU? What is stopping it from supporting more than
  one ring?
- Why is listening for SWITCHDEV_OBJ_ID_MRP necessary at all, since it
  does nothing related to hardware configuration?
- Why is ocelot_mrp_del_vcap called from both ocelot_mrp_del and from
  ocelot_mrp_del_ring_role?
- Why does ocelot not look at the MRM/MRC ring role at all, and it traps
  all MRP PDUs to the CPU, even those which it could forward as an MRC?
  I understood from your commit d8ea7ff3995e ("net: mscc: ocelot: Add
  support for MRP") description that the hardware should be able of
  forwarding the Test PDUs as a client, however it is obviously not
  doing that.
---
 Documentation/networking/dsa/dsa.rst | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 0a5b06cf4d45..bf82f2aed29a 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -730,6 +730,36 @@ can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
 method. The LAG ID associated with a bonding/team interface can then be
 retrieved by a DSA switch driver using the ``dsa_lag_id`` function.
 
+IEC 62439-2 (MRP)
+-----------------
+
+The Media Redundancy Protocol is a topology management protocol optimized for
+fast fault recovery time for ring networks, which has some components
+implemented as a function of the bridge driver. MRP uses management PDUs
+(Test, Topology, LinkDown/Up, Option) sent at a multicast destination MAC
+address range of 01:15:4e:00:00:0x and with an EtherType of 0x88e3.
+Depending on the node's role in the ring (MRM: Media Redundancy Manager,
+MRC: Media Redundancy Client, MRA: Media Redundancy Automanager), certain MRP
+PDUs might need to be terminated locally and others might need to be forwarded.
+An MRM might also benefit from offloading to hardware the creation and
+transmission of certain MRP PDUs (Test).
+
+Normally an MRP instance can be created on top of any network interface,
+however in the case of a device with an offloaded data path such as DSA, it is
+necessary for the hardware, even if it is not MRP-aware, to be able to extract
+the MRP PDUs from the fabric before the driver can proceed with the software
+implementation. DSA today has no driver which is MRP-aware, therefore it only
+listens for the bare minimum switchdev objects required for the software assist
+to work properly. The operations are detailed below.
+
+- ``port_mrp_add`` and ``port_mrp_del``: notifies driver when an MRP instance
+  with a certain ring ID, priority, primary port and secondary port is
+  created/deleted.
+- ``port_mrp_add_ring_role`` and ``port_mrp_del_ring_role``: function invoked
+  when an MRP instance changes ring roles between MRM or MRC. This affects
+  which MRP PDUs should be trapped to software and which should be autonomously
+  forwarded.
+
 TODO
 ====
 
-- 
2.25.1

