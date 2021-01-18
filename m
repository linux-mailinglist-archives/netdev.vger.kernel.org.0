Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793DB2FA5F5
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406569AbhARQUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406521AbhARQTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:19 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43200C061798
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:03 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id rv9so5671229ejb.13
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kDpvf2c68+1om/LVZmx9+7tfLn6lFzPq7jdW8tubCTw=;
        b=UhL4YrIeCPTVZkqN8axqKC2VvB//xcO5yryn5PKkQrK+f3hhYcqxeIXa6ESi4VbCHO
         GlWCvLVqwyFzcEyHkpFqsUI9YtcWvPeG7xef2D6TRoZ1v4e1dTh4S3YXHeJ4k/25osrn
         Fz7BpCvAsSEhcTLEz5IApRu0Do4gj+eZZptWObun967VYXeMf4REYR+I3bPnkb2p5W2h
         y7MOUpnkPkCwkfa/VAusy4zLJWMN5oNXnDFavyNSprLvqgNjiD+cpDp5Xoe1tAgajdSi
         maRxgXUX5uUIPGCw2QN+h647gqcsPoI6ZaxQoY5S/C0LhfrPNJqHiLHbuUaVkbcTh2yt
         HY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kDpvf2c68+1om/LVZmx9+7tfLn6lFzPq7jdW8tubCTw=;
        b=RA1gelxnYEo7kX7Q4ClFeW54VprD/gZhdB6zaPrf9V/fm9rqMYNfL+Bs8gz+vhfGQ6
         T4GDRP4HU2fkNWEWQ+R7RneSzTnohXbsxu+SUEQjMC9J33NGY8QZSn6y4fzZDd9uo57N
         JU++EUijx4MQJUsb873bvu2y49g0aDwwaeQ2A7F0NNpWUHkeVCB5N/O9pchJsN6VmpHT
         ZNzje88Wi0zSu5SGCyseX6ItoZqh65CthgUhv0oQPziM2/OMFyPLADiwjFxSC6k3y27m
         0vaNW/yRp3qhQI1/e4nwXpwlFODfFDoy8NDQbK+SBDqil687GWRRaJbUl9I67d5tWZ+n
         6CaQ==
X-Gm-Message-State: AOAM531K/Gi80o5L3wYd/M2dGlK4jmgvcK6kjdOupn3dOGi6iHqV+zn7
        7mhjy8dQzz2hRAptBMbUgl4=
X-Google-Smtp-Source: ABdhPJy4UHwFYBgoMgAII0DUJSSpW6EY7LIXmHpErZORp1uBjGdGvM78NPedRDURnlBVFZn2D7mQYw==
X-Received: by 2002:a17:906:3a0d:: with SMTP id z13mr313596eje.2.1610986681971;
        Mon, 18 Jan 2021 08:18:01 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:18:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 14/15] net: dsa: felix: use promisc on master for PTP with tag_8021q
Date:   Mon, 18 Jan 2021 18:17:30 +0200
Message-Id: <20210118161731.2837700-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is for the "no extraction IRQ" workaround, where the DSA master on
LS1028A (enetc) serves as a de-facto irqchip.

It needs to be promiscuous so that it will never drop a PTP frame (sent
to the 01-80-c2-00-00-0e multicast MAC address), otherwise the tagger
will get confused about which Ethernet PTP frame corresponds to which
PTP frame over the MMIO registers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 net/dsa/tag_ocelot_8021q.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 290880b94bb3..430d77d0b8eb 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -53,6 +53,7 @@ static struct dsa_device_ops ocelot_netdev_ops = {
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
 	.overhead		= VLAN_HLEN,
+	.promisc_on_master	= true,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

