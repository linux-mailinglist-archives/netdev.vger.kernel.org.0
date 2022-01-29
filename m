Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45674A2C1E
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 07:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiA2G2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 01:28:06 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17451 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbiA2G2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 01:28:05 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643437672; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=A0Mmd43QOBXHFWG4/7dV4A6kcFE3JvORbARgpsgdz5tzRHe8NbRRXxwMd9HXR4QyuwWAYl0oR+AWGYrqzSH49JYoOLGwXlTa1IzcvVqRZNamq/b09VgymyVqo54cngkFHbI0L4k77eLZDY5tWVUnC3KzpuRUGZeIUgZOBIjLnMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643437672; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=0i3HnSGPt75/LEM1b3UUYU+azcUjcoL1IC/M6OqaU0k=; 
        b=B+YP3j6GezGd6JTYEW+v7Bj5Ea/VqayxPriMklyl1cK332j8SHEkza761ciTNcSWPwp9fuADwY0KaGqnmIW5S/06yoN9Awp+r8nT74gc2a9TZbZBsLB45GN0TLJzZiSYkgT+pVZeMNVKvwXEhTY/gPPCFU3VtAlV8JRST1lfq18=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643437672;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=0i3HnSGPt75/LEM1b3UUYU+azcUjcoL1IC/M6OqaU0k=;
        b=NPahyhJ1ld2tJPvdO971WvklCDMA3BPKnnXSM82r+BIfjsj3hwMBqRWpXFaKgkiy
        Ux6/9NSnJ5OP19JAfHtBSwAQaIjoyMrHWb0ksF0HYfe0VpL6Kq0vAavwSHt/r1+gNYZ
        QvQ0+eW2Lugjl1yEcFUl59IsMLvaC/pHDO5J87cs=
Received: from arinc9-PC.localdomain (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1643437670346679.2662527643953; Fri, 28 Jan 2022 22:27:50 -0800 (PST)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, NeilBrown <neil@brown.name>,
        erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v2] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY
Date:   Sat, 29 Jan 2022 09:27:04 +0300
Message-Id: <20220129062703.595-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
properly control MT7530 and MT7531 switch PHYs.

A noticeable change is that the behaviour of switchport interfaces going
up-down-up-down is no longer there.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 7b1457a6e327..c0c91440340a 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -36,6 +36,7 @@ config NET_DSA_LANTIQ_GSWIP
 config NET_DSA_MT7530
 	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
 	select NET_DSA_TAG_MTK
+	select MEDIATEK_GE_PHY
 	help
 	  This enables support for the MediaTek MT7530, MT7531, and MT7621
 	  Ethernet switch chips.
-- 
2.25.1

