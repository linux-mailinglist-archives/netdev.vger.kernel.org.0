Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4E033D2F0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbhCPLZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhCPLYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:38 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F274C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:37 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r17so71470460ejy.13
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3F80TPs4WAjb4QnZL3S6m5+vCzslZHZnokWdtOsrud8=;
        b=cVV/E8G9BNZaftvCs0635vGUVU1A7LnwGSQkY3Mt5U2SHWaxzNpwEcYwduD/0XKGiW
         K4rBgjH4bj1S37gSH+L1T1Lb0CB/ZCTUPviSnPwLIFkxj1NIo55G3ShR4aCzGWLVjrQp
         LNg6dtIwyoKviiWCa6vIrdJyQBaa/mBj0JJuywreBoZ09aoiZjcdp7Kk7fDZYa0mR12q
         iaPNtaPaduEpusKDaHUDcgZk4i2AsKPxsm4aqn5mBS5EIClb0RREdc6GmvvbDRFhLD8S
         jpIahltEXg2lSltJ0zoVHagJV/j1gK1g8sf8Ubat5z+vwBPmlUdNGMI5GhMrmcr9AP6q
         6q8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3F80TPs4WAjb4QnZL3S6m5+vCzslZHZnokWdtOsrud8=;
        b=ZAXLyZLMkX4iL7P+Rd/S8+EH/uwZAUbkezLpLo2U6Wgu2fp1RqJ4zJ2bo52VP5DqvJ
         WKGObeL2lHUYvj1Pq7Kvxj8eQ+KfPeoNoECXYiW6GGAJpK573pVKY9vqz7a78FdxC/bR
         wWtLyyckVt8WWC7dB8zhtTKm+FjsNGVvHdiutMxGVVkxH551NEX821YWB5p2lVPeBj9u
         r45MRs8ib1X7hYWgiE+chBvajzKfc7OS7BtZFhaKLJkTv+ElWVRcb2apRrbkayCDSgYk
         9cDrWqo+IdRbQx6LfcSFSPjB4dXRxNilDCEvQgezob1ewlK7dXReTe1hynF+J81FQqPB
         eCRw==
X-Gm-Message-State: AOAM533eIEpvpcmcoJlXaRmmPaAXMnEuRvkRpL/JpVQgEA9stC0AplpN
        PtnpEy8kdXCw3RUy71Lgr3JaGF/BLBU=
X-Google-Smtp-Source: ABdhPJy/CnnEO4Gcg5oCYKSa90rkvzeuIhMvw1qyiMZVhLatMPffRnqtO4Prv7aG1d2RYi+3PK4z9A==
X-Received: by 2002:a17:906:260a:: with SMTP id h10mr29481535ejc.392.1615893875868;
        Tue, 16 Mar 2021 04:24:35 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 net-next 09/12] Documentation: networking: dsa: add paragraph for the MRP offload
Date:   Tue, 16 Mar 2021 13:24:16 +0200
Message-Id: <20210316112419.1304230-10-olteanv@gmail.com>
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
for getting an MRP instance to work on top of a DSA switch.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index e8576e81735c..0daafa2fb9eb 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -757,6 +757,36 @@ can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
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

