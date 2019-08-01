Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BA87DBF6
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfHAMvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:51:47 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:16352 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731335AbfHAMvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 08:51:47 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 2+Lg3f808W8Ko/TvGY+D0dzXyTWjYgoH5Xuh4Ylc7SPwyJD4SFv/vajNl8U2pEd45vtGXMaS7X
 Xb+S+miSsGcsI59JfV6Amm57ollqFXT/Ij+Sf0/IfC/X4Wr6SJ4bKg1WvYT1GM86kq6n4LgwT6
 LDiDu1TqDE/LUur4OxzLZGks8YUZVHdGQxne0BzoqojNtmrJloCCKixAkvz/SqeJwgsZ77JY0+
 mbMe5eUXHVNcn5XCvvdazbXaRfIFXT2cRn/a7VdoSJC8NLhPn36odf0rRv24I0Y7GS2WpV7tOW
 pvw=
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="42025085"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Aug 2019 05:51:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 1 Aug 2019 05:51:44 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 1 Aug 2019 05:51:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <idosch@mellanox.com>,
        <andrew@lunn.ch>, <allan.nielsen@microchip.com>
CC:     <davem@davemloft.net>, <roopa@cumulusnetworks.com>,
        <petrm@mellanox.com>, <tglx@linutronix.de>, <fw@strlen.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>
Subject: [iproute2,rfc] bridge: mdb: Extend with with LLADDR
Date:   Thu, 1 Aug 2019 14:51:27 +0200
Message-ID: <1564663887-27854-1-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend bridge mdb command to accept as group also link layer multicast
addresss. The old behaviour is not change.

To add new mdb entry:
bridge mdb add dev br0 port eth0 grp 11:22:33:44:55:66 permanent vid 1

To display existing entries:
bridge mdb
dev br0 port eth4 grp 01:00:00:00:00:01 permanent offload vid 1

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 bridge/mdb.c                   | 29 ++++++++++++++++++++++++-----
 include/uapi/linux/if_bridge.h |  1 +
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 928ae56..057c0b6 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -138,9 +138,21 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	print_string(PRINT_ANY, "port", " port %s",
 		     ll_index_to_name(e->ifindex));
 
-	print_color_string(PRINT_ANY, ifa_family_color(af),
-			    "grp", " grp %s",
-			    inet_ntop(af, src, abuf, sizeof(abuf)));
+	if (e->addr.proto == htons(ETH_P_IP) ||
+	    e->addr.proto == htons(ETH_P_IPV6)) {
+		print_color_string(PRINT_ANY, ifa_family_color(af),
+				   "grp", " grp %s",
+				   inet_ntop(af, src, abuf, sizeof(abuf)));
+	} else {
+		const char *lladdr;
+		SPRINT_BUF(b1);
+
+		lladdr = ll_addr_n2a(e->addr.u.mac, ETH_ALEN, 0, b1,
+				     sizeof(b1));
+
+		print_color_string(PRINT_ANY, COLOR_MAC, "grp", " grp %s",
+				   lladdr);
+	}
 
 	print_string(PRINT_ANY, "state", " %s",
 			   (e->state & MDB_PERMANENT) ? "permanent" : "temp");
@@ -380,6 +392,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	};
 	struct br_mdb_entry entry = {};
 	char *d = NULL, *p = NULL, *grp = NULL;
+	char abuf[ETH_ALEN];
 	short vid = 0;
 
 	while (argc > 0) {
@@ -422,8 +435,14 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 
 	if (!inet_pton(AF_INET, grp, &entry.addr.u.ip4)) {
 		if (!inet_pton(AF_INET6, grp, &entry.addr.u.ip6)) {
-			fprintf(stderr, "Invalid address \"%s\"\n", grp);
-			return -1;
+			if (sscanf(grp, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
+				   abuf, abuf+1, abuf+2, abuf+3, abuf+4,
+				   abuf+5) != 6) {
+				fprintf(stderr, "Invalid address \"%s\"\n", grp);
+				return -1;
+			}
+			memcpy(entry.addr.u.mac, abuf, ETH_ALEN);
+			entry.addr.proto = 0;
 		} else
 			entry.addr.proto = htons(ETH_P_IPV6);
 	} else
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 04f763c..88aad9c 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -243,6 +243,7 @@ struct br_mdb_entry {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			__u8	mac[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
-- 
2.7.4

