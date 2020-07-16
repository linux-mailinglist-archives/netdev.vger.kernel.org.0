Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7EB222A85
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgGPR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGPR4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:56:17 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C90BC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 10:56:17 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so5227550pgf.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 10:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=St5IW/0RJx7awbUedzsjjleKKmGVsmjKbIso6cGl3+k=;
        b=kQCbJuk+QWBc0C2RQp/NyGF9ZRke9KZWwSTRHex+HLevzwUV7qn8qV5r85Xj/UItTb
         AaIgDfjsp2pkdtktisdnHT2ZGjJJ94EBuFm29ZeL6Hv1JVMEJOM23FTRkimkqxX56V2+
         9mtUwaTWHsnEgJLcoT4otx/ceSYVunLUcPn3HRcXvfK1B2eXTWLMumyj/Su7u70qKDKh
         gD1BLCeliG5hrGHMIG96elYBpkyRhrj4t1tMrFqBK3AyPs1Nv9KMg+PReT3LZz5u04fZ
         HSZN2Kk6/Lj9WWy4/9clkVQsXbhRX7qNdbb3WErDbEw/epnOCYwf9O53JqqBjryc8k1J
         ObIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=St5IW/0RJx7awbUedzsjjleKKmGVsmjKbIso6cGl3+k=;
        b=Dc5cHZ7VZ4au/viPvsFGncMm/GiDDl5gKx1dWUk4Z9Oo1uz/bPe1hACu7VEy2QsoeA
         Jx40LZ1ICSNuEdy6iWag+vM3p1ckI4o3N1b7dVP4PG7oj+lG+3ftdSv/DwPqF/0Cy43P
         wCRg2V3Bef4lXVWM+0gVaItTDHKCyZ3xRC4IKZMEXtQ0DTtmGmKfeIV4dU03MoHszGYh
         AyH87FXO++P6gQqM9jMde2Gs47YqSwed+qHSSpbFI6w3zoHIV8bP7BHBOqxa5OsaF77s
         2rnBadX24aKUE/jyeFdLgfgzFo5ehKm8HVdXlb+jt7kkHzfvo7P+APAU4m3vNZ/ExIIP
         wvGg==
X-Gm-Message-State: AOAM531UKwmcJ4AtMdEFoLC3r8+U9sWKGaydr1FtbrlxXnCA0KGrMD3i
        pAzia6DZKH/krWYmyF/I6TM=
X-Google-Smtp-Source: ABdhPJyXhGyfXfgkUFH22ABEF8smBWr57zS+8gPxoBoIw1e2p7y70Jbq5cf8aQJCapYjjnANRDb5Aw==
X-Received: by 2002:a63:e018:: with SMTP id e24mr5123235pgh.175.1594922176413;
        Thu, 16 Jul 2020 10:56:16 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:a2ce:c8ff:fe03:6cb0])
        by smtp.gmail.com with ESMTPSA id o42sm684571pje.10.2020.07.16.10.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 10:56:15 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
To:     mkubecek@suse.cz, netdev@vger.kernel.org, vivien.didelot@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Healy <cphealy@gmail.com>
Subject: [PATCH] ethtool: dsa: mv88e6xxx: add pretty dump for 88E6352 SERDES
Date:   Thu, 16 Jul 2020 10:55:26 -0700
Message-Id: <20200716175526.14005-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

In addition to the port registers, the device can provide the
SERDES/PCS registers. Dump these, and for a few of the important
SGMII/1000Base-X registers decode the bits.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Chris Healy <cphealy@gmail.com>
---
 dsa.c | 196 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 195 insertions(+), 1 deletion(-)

diff --git a/dsa.c b/dsa.c
index 50a171b..a5045fc 100644
--- a/dsa.c
+++ b/dsa.c
@@ -405,21 +405,204 @@ static void dsa_mv88e6352(int reg, u16 val)
 	case 19:
 		REG(reg, "Rx Frame Counter", val);
 		break;
+	case 20 ... 21:
+		REG(reg, "Reserved", val);
+		break;
 	case 22:
 		REG(reg, "LED Control", val);
 		break;
+	case 23:
+		REG(reg, "Reserved", val);
+		break;
 	case 24:
 		REG(reg, "Tag Remap 0-3", val);
 		break;
 	case 25:
 		REG(reg, "Tag Remap 4-7", val);
 		break;
+	case 26:
+		REG(reg, "Reserved", val);
+		break;
 	case 27:
 		REG(reg, "Queue Counters", val);
 		break;
-	default:
+	case 28 ... 31:
 		REG(reg, "Reserved", val);
 		break;
+	case 32 + 0:
+		REG(reg - 32, "Fiber Control", val);
+		FIELD("Fiber Reset", "%u", !!(val & 0x8000));
+		FIELD("Loopback", "%u", !!(val & 0x4000));
+		FIELD("Speed", "%s",
+		      (val & (0x2000 | 0x0040)) == 0x0000 ? "10 Mbps" :
+		      (val & (0x2000 | 0x0040)) == 0x2000 ? "100 Mbps" :
+		      (val & (0x2000 | 0x0040)) == 0x0040 ? "1000 Mbps" :
+		      (val & (0x2000 | 0x0040)) == (0x2000 | 0x0040) ?
+		      "Reserved" : "?");
+		FIELD("Autoneg Enable", "%u", !!(val & 0x1000));
+		FIELD("Power down", "%u", !!(val & 0x0800));
+		FIELD("Isolate", "%u", !!(val & 0x0400));
+		FIELD("Restart Autoneg", "%u", !!(val & 0x0200));
+		FIELD("Duplex", "%s", val & 0x0100 ? "Full" : "Half");
+		break;
+	case 32 + 1:
+		REG(reg - 32, "Fiber Status", val);
+		FIELD("100Base-X FD",  "%u", !!(val & 0x4000));
+		FIELD("100Base-X HD",  "%u", !!(val & 0x2000));
+		FIELD("Autoneg Complete", "%u", !!(val & 0x0020));
+		FIELD("Remote Fault", "%u", !!(val & 0x0010));
+		FIELD("Autoneg Ability", "%u", !!(val & 0x0008));
+		FIELD("Link Status", "%s", val & 0x0004 ? "Up" : "Down");
+		break;
+	case 32 + 2:
+		REG(reg - 32, "PHY ID 1", val);
+		break;
+	case 32 + 3:
+		REG(reg - 32, "PHY ID 2", val);
+		break;
+	case 32 + 4:
+		REG(reg - 32, "Fiber Autoneg Advertisement", val);
+		FIELD("Remote Fault", "%s",
+		      (val & 0x3000) == 0x0000 ? "No error, link OK" :
+		      (val & 0x3000) == 0x1000 ? "Link failure" :
+		      (val & 0x3000) == 0x2000 ? "Offline" :
+		      (val & 0x3000) == 0x3000 ? "Autoneg Error" : "?");
+		FIELD("Pause", "%s",
+		      (val & 0x0180) == 0x0000 ? "No Pause" :
+		      (val & 0x0180) == 0x0080 ? "Symmetric Pause" :
+		      (val & 0x0180) == 0x0100 ? "Asymmetric Pause" :
+		      (val & 0x0180) == 0x0180 ? "Symmetric & Asymmetric Pause" :
+		      "?");
+		FIELD("1000BaseX HD", "%u", !!(val & 0x0040));
+		FIELD("1000BaseX FD", "%u", !!(val & 0x0020));
+		break;
+	case 32 + 5:
+		REG(reg - 32, "Fiber Link Autoneg Ability", val);
+		FIELD("Acknowledge", "%u", !!(val & 0x4000));
+		FIELD("Remote Fault", "%s",
+		      (val & 0x3000) == 0x0000 ? "No error, link OK" :
+		      (val & 0x3000) == 0x1000 ? "Link failure" :
+		      (val & 0x3000) == 0x2000 ? "Offline" :
+		      (val & 0x3000) == 0x3000 ? "Autoneg Error" : "?");
+		FIELD("Pause", "%s",
+		      (val & 0x0180) == 0x0000 ? "No Pause" :
+		      (val & 0x0180) == 0x0080 ? "Symmetric Pause" :
+		      (val & 0x0180) == 0x0100 ? "Asymmetric Pause" :
+		      (val & 0x0180) == 0x0180 ? "Symmetric & Asymmetric Pause" :
+		      "?");
+		FIELD("1000BaseX HD", "%u", !!(val & 0x0040));
+		FIELD("1000BaseX FD", "%u", !!(val & 0x0020));
+		break;
+	case 32 + 6:
+		REG(reg - 32, "Fiber Autoneg Expansion", val);
+		FIELD("Link Partner Next Page Ability", "%u", !!(val & 0x0008));
+		FIELD("Page Received", "%u", !!(val & 0x0002));
+		FIELD("Link Partner Autoneg Ability", "%u", !!(val & 0x0001));
+		break;
+	case 32 + 7:
+		REG(reg - 32, "Fiber Next Page Transmit", val);
+		break;
+	case 32 + 8:
+		REG(reg - 32, "Fiber Link Partner Next Page", val);
+		break;
+	case 32 + 9 ... 32 + 14:
+		REG(reg - 32, "Reserved", val);
+		break;
+	case 32 + 15:
+		REG(reg - 32, "Extended Status", val);
+		break;
+	case 32 + 16:
+		REG(reg - 32, "Fiber Specific Control", val);
+		FIELD("Fiber Transmit FIFO Depth", "%s",
+		      (val & 0xc000) == 0x0000 ? "16 Bits" :
+		      (val & 0xc000) == 0x4000 ? "24 Bits" :
+		      (val & 0xc000) == 0x8000 ? "32 Bits" :
+		      (val & 0xc000) == 0xc000 ? "40 Bits" : "?");
+		FIELD("SERDES Loopback", "%u", !!(val & 0x1000));
+		FIELD("Force Link Good", "%u", !!(val & 0x0400));
+		FIELD("MAC Interface Power Down", "%u", !!(val & 0x0008));
+		FIELD("Mode", "%s",
+		      (val & 0x0003) == 0x0000 ? "100BaseFX" :
+		      (val & 0x0003) == 0x0001 ? "1000BaseX" :
+		      (val & 0x0003) == 0x0002 ? "SGMII System" :
+		      (val & 0x0003) == 0x0003 ? "SGMII Media" : "?");
+		break;
+	case 32 + 17:
+		REG(reg - 32, "Fiber Specific Status", val);
+		FIELD("Speed", "%s",
+		      (val & 0xc000) == 0x0000 ? "10 Mbps" :
+		      (val & 0xc000) == 0x4000 ? "100 Mbps" :
+		      (val & 0xc000) == 0x8000 ? "1000 Mbps" :
+		      (val & 0xc000) == 0xc000 ? "Reserved" : "?");
+		FIELD("Duplex", "%s", val & 0x2000 ? "Full" : "Half");
+		FIELD("Page Received", "%u", !!(val & 0x1000));
+		FIELD("Speed/Duplex Resolved", "%u", !!(val & 0x0800));
+		FIELD("Link", "%s", val & 0x0400 ? "Up" : "Down");
+		FIELD("Sync", "%u", !!(val & 0x0020));
+		FIELD("Energy Detect", "%s", val & 0x010 ? "False" : "True");
+		FIELD("Transmit Pause", "%u", !!(val & 0x0008));
+		FIELD("Receive Pause", "%u", !!(val & 0x00004));
+		break;
+	case 32 + 18:
+		REG(reg - 32, "Fiber Interrupt Enable", val);
+		FIELD("Speed Changed", "%u", !!(val & 0x4000));
+		FIELD("Duplex Changed", "%u", !!(val & 0x2000));
+		FIELD("Page Received", "%u", !!(val & 0x1000));
+		FIELD("Autoneg Complete", "%u", !!(val & 0x0800));
+		FIELD("Link Status Change", "%u", !!(val & 0x0400));
+		FIELD("Symbol Error", "%u", !!(val & 0x0200));
+		FIELD("False Carrier", "%u", !!(val & 0x0100));
+		FIELD("Energy Detect", "%u", !!(val & 0x0010));
+		break;
+	case 32 + 19:
+		REG(reg - 32, "Fiber Interrupt Status", val);
+		FIELD("Speed Changed", "%u", !!(val & 0x4000));
+		FIELD("Duplex Changed", "%u", !!(val & 0x2000));
+		FIELD("Page Received", "%u", !!(val & 0x1000));
+		FIELD("Autoneg Complete", "%u", !!(val & 0x0800));
+		FIELD("Link Status Change", "%u", !!(val & 0x0400));
+		FIELD("Symbol Error", "%u", !!(val & 0x0200));
+		FIELD("False Carrier", "%u", !!(val & 0x0100));
+		FIELD("Energy Detect", "%u", !!(val & 0x0010));
+		break;
+	case 32 + 20:
+		REG(reg - 32, "Reserved", val);
+		break;
+	case 32 + 21:
+		REG(reg - 32, "Fiber Receive Error Counter", val);
+		break;
+	case 32 + 22:
+		REG(reg - 32, "Reserved", val);
+		break;
+	case 32 + 23:
+		REG(reg - 32, "PRBS Control", val);
+		break;
+	case 32 + 24:
+		REG(reg - 32, "PRBS Error Counter LSB", val);
+		break;
+	case 32 + 25:
+		REG(reg - 32, "PRBS Error Counter MSB", val);
+		break;
+	case 32 + 26:
+		REG(reg - 32, "Fiber Specific Control 2", val);
+		FIELD("1000BaseX Noise Filtering", "%u", !!(val & 0x4000));
+		FIELD("1000BaseFX Noise Filtering", "%u", !!(val & 0x2000));
+		FIELD("SERDES Autoneg Bypass Enable", "%u", !!(val & 0x0040));
+		FIELD("SERDES Autoneg Bypass Status", "%u", !!(val & 0x0020));
+		FIELD("Fiber Transmitter Disable", "%u", !!(val & 0x0008));
+		FIELD("SGMII/Fiber Output Amplitude", "%s",
+		      (val & 0x0007) == 0x0000 ? "14mV" :
+		      (val & 0x0007) == 0x0001 ? "112mV" :
+		      (val & 0x0007) == 0x0002 ? "210mV" :
+		      (val & 0x0007) == 0x0003 ? "308mV" :
+		      (val & 0x0007) == 0x0004 ? "406mV" :
+		      (val & 0x0007) == 0x0005 ? "504mV" :
+		      (val & 0x0007) == 0x0006 ? "602mV" :
+		      (val & 0x0007) == 0x0007 ? "700mV" : "?");
+		break;
+	default:
+		REG(reg - 32, "Reserved", val);
+		break;
 	}
 };
 
@@ -667,6 +850,17 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
 		else
 			REG(i, "", data[i]);
 
+	/* Dump the SERDES registers, if provided */
+	if (regs->len > 32 * 2) {
+		printf("\n%s Switch Port SERDES Registers\n", sw->name);
+		printf("-------------------------------------\n");
+		for (i = 32; i < regs->len / 2; i++)
+			if (sw->dump)
+				sw->dump(i, data[i]);
+			else
+				REG(i, "", data[i]);
+	}
+
 	return 0;
 }
 
-- 
2.21.3

