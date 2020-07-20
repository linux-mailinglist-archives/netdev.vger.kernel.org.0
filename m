Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE49226E8D
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgGTSuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbgGTSuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:50:15 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257B3C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 11:50:15 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so10694507pgm.11
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 11:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYGyoof3pnw7SE2W8/LyNwkDVI4bLNe2nOaHdbji56w=;
        b=Nzzh+mfWccAeQxHP1bm3U3VXA+RlJypOX4RhfN0VKU1874hZ9ouASh6SRCyb5HvSAb
         OUELSw5B/3yfAYLbUtTzR09GT45wfsbZS8fbze9PsJsXWbayI1nDE8OGKPOSDL+nfhP5
         WeewoEpPjMlBmyk0CdtQ9TlhsrFMu/SrwxuOUCdEe5KupIJnNdjCU8nWg4tc9d7PC5Ij
         hVXSxXujdGZAd8pvAx8xsRLi0eOW+6fx1XQVrjEeGCqTF1elCeauiC1F26Gs851Fs70I
         51CLTrXp52RFQBfs7dazbDC2CMGpuNQ0oUAioNi7KhxWNVEPVQpbgdacOC3g0bGv+/27
         8L7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYGyoof3pnw7SE2W8/LyNwkDVI4bLNe2nOaHdbji56w=;
        b=PGRWArYVRA2b0Hj6PNlofk1LHf4nA2OdNWzVFG5ZOqv3/l3C7+SKYHEkRogDa+Pl/g
         s+vILtuztnEtGBIwMZt+74htorQDc7woUPVaEU0N36Wt4ujOukDL5hJu8DfLdGKv5I/F
         i9Hna2GLk7TSWbBJ9COeOVsJI/jwIyJPFPlAgvw7lvxqaxT4a4oGL7IxYQkTnngVX9N/
         uXnL0M6RuYqEvsKJSn5m5m6/hudS1w9tZy3ry80AW+jIMHAkbWsFADhPZSKMDhr9XSOY
         aOc+9Eg6GhuLezA+fmn2Vxf5nGv2UHcPSup9/2uo6BeRZ+m3JT3PO7UrNI77WtvUcZIl
         Ry/A==
X-Gm-Message-State: AOAM530XqvtbiL6g20p0sS14yPLJ2DQaTuB2eq5fP7EMibmDFnXmBy36
        hABethPbqq2fkNstsFnxBrwpTYnv5F8MlA==
X-Google-Smtp-Source: ABdhPJxGsBr/WUvbu5MK8YV09luD6G5Fu+8Cz7enab+X2V7qaidjrSCPosft+Yr+z0WoidIokaYnpA==
X-Received: by 2002:a62:dd91:: with SMTP id w139mr21035749pff.40.1595271014534;
        Mon, 20 Jul 2020 11:50:14 -0700 (PDT)
Received: from localhost-live.socal.rr.com ([2605:e000:160b:911f:5d2e:8d6b:6a7a:7a41])
        by smtp.gmail.com with ESMTPSA id q5sm17796934pfc.130.2020.07.20.11.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 11:50:14 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
X-Google-Original-From: Chris Healy <cphealy@gmail.com
To:     mkubecek@suse.cz, netdev@vger.kernel.org, vivien.didelot@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Healy <cphealy@gmail.com>
Subject: [PATCH v2] ethtool: dsa: mv88e6xxx: add pretty dump for 88E6352 SERDES
Date:   Mon, 20 Jul 2020 11:50:02 -0700
Message-Id: <20200720185002.158693-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.26.2
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
v2:
- Add SERDES_OFFSET define
- Improve readability of if statement
- Fix inconsistency in dump handler code

 dsa.c | 200 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 198 insertions(+), 2 deletions(-)

diff --git a/dsa.c b/dsa.c
index 50a171b..0071769 100644
--- a/dsa.c
+++ b/dsa.c
@@ -3,6 +3,8 @@
 
 #include "internal.h"
 
+#define SERDES_OFFSET 32
+
 /* Macros and dump functions for the 16-bit mv88e6xxx per-port registers */
 
 #define REG(_reg, _name, _val) \
@@ -405,21 +407,204 @@ static void dsa_mv88e6352(int reg, u16 val)
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
+	case SERDES_OFFSET + 0:
+		REG(reg - SERDES_OFFSET, "Fiber Control", val);
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
+	case SERDES_OFFSET + 1:
+		REG(reg - SERDES_OFFSET, "Fiber Status", val);
+		FIELD("100Base-X FD",  "%u", !!(val & 0x4000));
+		FIELD("100Base-X HD",  "%u", !!(val & 0x2000));
+		FIELD("Autoneg Complete", "%u", !!(val & 0x0020));
+		FIELD("Remote Fault", "%u", !!(val & 0x0010));
+		FIELD("Autoneg Ability", "%u", !!(val & 0x0008));
+		FIELD("Link Status", "%s", val & 0x0004 ? "Up" : "Down");
+		break;
+	case SERDES_OFFSET + 2:
+		REG(reg - SERDES_OFFSET, "PHY ID 1", val);
+		break;
+	case SERDES_OFFSET + 3:
+		REG(reg - SERDES_OFFSET, "PHY ID 2", val);
+		break;
+	case SERDES_OFFSET + 4:
+		REG(reg - SERDES_OFFSET, "Fiber Autoneg Advertisement", val);
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
+	case SERDES_OFFSET + 5:
+		REG(reg - SERDES_OFFSET, "Fiber Link Autoneg Ability", val);
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
+	case SERDES_OFFSET + 6:
+		REG(reg - SERDES_OFFSET, "Fiber Autoneg Expansion", val);
+		FIELD("Link Partner Next Page Ability", "%u", !!(val & 0x0008));
+		FIELD("Page Received", "%u", !!(val & 0x0002));
+		FIELD("Link Partner Autoneg Ability", "%u", !!(val & 0x0001));
+		break;
+	case SERDES_OFFSET + 7:
+		REG(reg - SERDES_OFFSET, "Fiber Next Page Transmit", val);
+		break;
+	case SERDES_OFFSET + 8:
+		REG(reg - SERDES_OFFSET, "Fiber Link Partner Next Page", val);
+		break;
+	case SERDES_OFFSET + 9 ... SERDES_OFFSET + 14:
+		REG(reg - SERDES_OFFSET, "Reserved", val);
+		break;
+	case SERDES_OFFSET + 15:
+		REG(reg - SERDES_OFFSET, "Extended Status", val);
+		break;
+	case SERDES_OFFSET + 16:
+		REG(reg - SERDES_OFFSET, "Fiber Specific Control", val);
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
+	case SERDES_OFFSET + 17:
+		REG(reg - SERDES_OFFSET, "Fiber Specific Status", val);
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
+	case SERDES_OFFSET + 18:
+		REG(reg - SERDES_OFFSET, "Fiber Interrupt Enable", val);
+		FIELD("Speed Changed", "%u", !!(val & 0x4000));
+		FIELD("Duplex Changed", "%u", !!(val & 0x2000));
+		FIELD("Page Received", "%u", !!(val & 0x1000));
+		FIELD("Autoneg Complete", "%u", !!(val & 0x0800));
+		FIELD("Link Status Change", "%u", !!(val & 0x0400));
+		FIELD("Symbol Error", "%u", !!(val & 0x0200));
+		FIELD("False Carrier", "%u", !!(val & 0x0100));
+		FIELD("Energy Detect", "%u", !!(val & 0x0010));
+		break;
+	case SERDES_OFFSET + 19:
+		REG(reg - SERDES_OFFSET, "Fiber Interrupt Status", val);
+		FIELD("Speed Changed", "%u", !!(val & 0x4000));
+		FIELD("Duplex Changed", "%u", !!(val & 0x2000));
+		FIELD("Page Received", "%u", !!(val & 0x1000));
+		FIELD("Autoneg Complete", "%u", !!(val & 0x0800));
+		FIELD("Link Status Change", "%u", !!(val & 0x0400));
+		FIELD("Symbol Error", "%u", !!(val & 0x0200));
+		FIELD("False Carrier", "%u", !!(val & 0x0100));
+		FIELD("Energy Detect", "%u", !!(val & 0x0010));
+		break;
+	case SERDES_OFFSET + 20:
+		REG(reg - SERDES_OFFSET, "Reserved", val);
+		break;
+	case SERDES_OFFSET + 21:
+		REG(reg - SERDES_OFFSET, "Fiber Receive Error Counter", val);
+		break;
+	case SERDES_OFFSET + 22:
+		REG(reg - SERDES_OFFSET, "Reserved", val);
+		break;
+	case SERDES_OFFSET + 23:
+		REG(reg - SERDES_OFFSET, "PRBS Control", val);
+		break;
+	case SERDES_OFFSET + 24:
+		REG(reg - SERDES_OFFSET, "PRBS Error Counter LSB", val);
+		break;
+	case SERDES_OFFSET + 25:
+		REG(reg - SERDES_OFFSET, "PRBS Error Counter MSB", val);
+		break;
+	case SERDES_OFFSET + 26:
+		REG(reg - SERDES_OFFSET, "Fiber Specific Control 2", val);
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
+		REG(reg - SERDES_OFFSET, "Reserved", val);
+		break;
 	}
 };
 
@@ -643,7 +828,7 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
 	int i;
 
 	/* Marvell chips have 32 per-port 16-bit registers */
-	if (regs->len < 32 * 2)
+	if (regs->len < 32 * sizeof(u16))
 		return 1;
 
 	id = regs->version & 0xfff0;
@@ -667,6 +852,17 @@ static int dsa_mv88e6xxx_dump_regs(struct ethtool_regs *regs)
 		else
 			REG(i, "", data[i]);
 
+	/* Dump the SERDES registers, if provided */
+	if (regs->len > SERDES_OFFSET * sizeof(u16)) {
+		printf("\n%s Switch Port SERDES Registers\n", sw->name);
+		printf("-------------------------------------\n");
+		for (i = SERDES_OFFSET; i < regs->len / 2; i++)
+			if (sw->dump)
+				sw->dump(i, data[i]);
+			else
+				REG(i - SERDES_OFFSET, "", data[i]);
+	}
+
 	return 0;
 }
 
-- 
2.26.2

