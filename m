Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E15D49FEA8
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 18:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350454AbiA1RIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 12:08:00 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17442 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350436AbiA1RH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 12:07:59 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643389665; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=JL7Y90evHESef3VA0PiFILPhGwxPuLcJBA9flmq3CkVLz26Wa8F3vTu8Hif2/zKtwGzvCueLJO0AJfV8yykBun0sa8AOTQTvs0ulv589V1Mw++HwLcRVdyqyanVzxoBJMbJrrh3L80jPtvlaIj+WeukJXqODt4dEDv1Zu3RrvMk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643389665; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=sHA+C43vpPAamMsaMDIKSmUN7JrM2grs2Osv03CtYMc=; 
        b=ddJA0LZyZr1c4dotekhluHYqfaTN+qJXLQ6p+xhNWxBdmtHLKrqEx0sd2GsV35hPpuqs8dbcYdLI3/9K4TC48kJlZdQwx7OkiYegpcIAtHMyvRRq1Zvxd12HJbTn7v7IHWZAq+yeN/8Nb0fN5naAKEEzbfYqHzTEJ1jc6mZ2sug=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643389665;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=sHA+C43vpPAamMsaMDIKSmUN7JrM2grs2Osv03CtYMc=;
        b=Whp4tgAK8FkMSje/M//SZ3DBtNN9dW3og0QsmLHc6nLTEZU6Ps+ZjPLe+aXCnsTm
        g3/U5tEIrKbXzZrRuFx83jCWP4ffztJtcOHkt/YrZfSMz64MuwI9s5xGQXzbgVQ1DxI
        U3Muk/ozLrjX8BtGpFzzA9y2TstvQd9TALsCoX/o=
Received: from arinc9-PC.localdomain (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1643389663615595.4055395103865; Fri, 28 Jan 2022 09:07:43 -0800 (PST)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY
Date:   Fri, 28 Jan 2022 20:05:45 +0300
Message-Id: <20220128170544.4131-1-arinc.unal@arinc9.com>
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

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
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

