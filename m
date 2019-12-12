Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC3511C1DE
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfLLBHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:07:30 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39231 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfLLBHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:07:30 -0500
Received: by mail-qk1-f195.google.com with SMTP id c16so244158qko.6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JcT5JaZ2ztlm9nVh3YJKAXgItNSZXXVSU78tCu2kIzQ=;
        b=tXiX5OtDHGhiywhmijDgyEx1NrbU4p93GnhnMF24bLBymtMFCimd4dBAq8qCMqsTlt
         xJmZioMRds/bSuhPZ7cO4ugVtbPQBAznxa6bT1Rq/11TFqWXS50gLBAuENcJULBOLZAQ
         4YM+bw+9S45jPdv/cNwcqYDZTnO7fPvtwVgwX3VL+Q01oFR7V3UiZinS7e01O8aJ59dR
         eRhTi2KuN8F1cNgp+4/fPiDZkC3+q77zp1YzK9TcRNYQwVq9T5qj9+OiCbQvrWTQZGeD
         8Fc2V8/CjbHFE9qLg6dl9pVs9L1pfo333+igJRuc6m7lR3LPXmyB2OPKunJINDf7WR1d
         D1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JcT5JaZ2ztlm9nVh3YJKAXgItNSZXXVSU78tCu2kIzQ=;
        b=aV7OqQElSPkCgjfM1mOMIo6v7crbLOrO3T5y/OI53UFkXUtvzq7SirPDr725e3qHQ5
         IMv7dwqGIiUfm7x+Je0Sl81O/2NDYYQR0sXWHw2CiGjmfSBuPy3KrnK01g0bDmrjC7ku
         bLuFF1jWu1KBVVkEJg0niNu/UlxjNo1nPT/5JoTP/KeVTdMbCOo/3vXYS/FtXTgOLfwI
         NsG4NHdEN9K38/y0n5wZXOKrImZOrLOHbtldUmO6oNypJAh55m3iobRf0/nIQlvhoeRM
         a4ceHGKXhWEMm24AnSx3W236zsDksXe34YF7mKFqGJ/8uAGiNAzTWZWykOtE/vw+I8n4
         pp1g==
X-Gm-Message-State: APjAAAVyAfW6G9MsIQQpZBdcdUOLf08aULm6JTdN3RRQU8xIywpzGi3G
        hAEe8omfj0220Nd1FJ+Bzno=
X-Google-Smtp-Source: APXvYqzoggbrOAvzAN/pHjC7Zpbl6lZdgepimYfDRAotf0UDnrXbCPWgpXyAMuWu6G06cbJfr9/bzg==
X-Received: by 2002:a05:620a:20c7:: with SMTP id f7mr5901951qka.440.1576112849328;
        Wed, 11 Dec 2019 17:07:29 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id f2sm1551198qtm.55.2019.12.11.17.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 17:07:28 -0800 (PST)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH iproute2 v4] iplink: add support for STP xstats
Date:   Wed, 11 Dec 2019 20:07:11 -0500
Message-Id: <20191212010711.1664000-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191212010711.1664000-1-vivien.didelot@gmail.com>
References: <20191212010711.1664000-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the BRIDGE_XSTATS_STP xstats, as follow:

    # ip link xstats type bridge_slave dev lan4 stp
    lan4
                        STP BPDU:  RX: 0 TX: 61
                        STP TCN:   RX: 0 TX: 0
                        STP Transitions: Blocked: 2 Forwarding: 1

Or below as JSON:

    # ip -j -p link xstats type bridge_slave dev lan0 stp
    [ {
            "ifname": "lan0",
            "stp": {
                "rx_bpdu": 0,
                "tx_bpdu": 500,
                "rx_tcn": 0,
                "tx_tcn": 0,
                "transition_blk": 0,
                "transition_fwd": 0
            }
        } ]

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/uapi/linux/if_bridge.h | 10 ++++++++++
 ip/iplink_bridge.c             | 26 ++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 31fc51bd..9fefc7f3 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -156,6 +156,15 @@ struct bridge_vlan_xstats {
 	__u32 pad2;
 };
 
+struct bridge_stp_xstats {
+	__u64 transition_blk;
+	__u64 transition_fwd;
+	__u64 rx_bpdu;
+	__u64 tx_bpdu;
+	__u64 rx_tcn;
+	__u64 tx_tcn;
+};
+
 /* Bridge multicast database attributes
  * [MDBA_MDB] = {
  *     [MDBA_MDB_ENTRY] = {
@@ -262,6 +271,7 @@ enum {
 	BRIDGE_XSTATS_VLAN,
 	BRIDGE_XSTATS_MCAST,
 	BRIDGE_XSTATS_PAD,
+	BRIDGE_XSTATS_STP,
 	__BRIDGE_XSTATS_MAX
 };
 #define BRIDGE_XSTATS_MAX (__BRIDGE_XSTATS_MAX - 1)
diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 06f736d4..bbd6f3a8 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -688,6 +688,7 @@ static void bridge_print_xstats_help(struct link_util *lu, FILE *f)
 static void bridge_print_stats_attr(struct rtattr *attr, int ifindex)
 {
 	struct rtattr *brtb[LINK_XSTATS_TYPE_MAX+1];
+	struct bridge_stp_xstats *sstats;
 	struct br_mcast_stats *mstats;
 	struct rtattr *i, *list;
 	const char *ifname = "";
@@ -807,6 +808,29 @@ static void bridge_print_stats_attr(struct rtattr *attr, int ifindex)
 				  mstats->mld_parse_errors);
 			close_json_object();
 			break;
+		case BRIDGE_XSTATS_STP:
+			sstats = RTA_DATA(i);
+			open_json_object("stp");
+			print_string(PRINT_FP, NULL,
+				     "%-16s    STP BPDU:  ", "");
+			print_u64(PRINT_ANY, "rx_bpdu", "RX: %llu ",
+				  sstats->rx_bpdu);
+			print_u64(PRINT_ANY, "tx_bpdu", "TX: %llu\n",
+				  sstats->tx_bpdu);
+			print_string(PRINT_FP, NULL,
+				     "%-16s    STP TCN:   ", "");
+			print_u64(PRINT_ANY, "rx_tcn", "RX: %llu ",
+				  sstats->rx_tcn);
+			print_u64(PRINT_ANY, "tx_tcn", "TX: %llu\n",
+				  sstats->tx_tcn);
+			print_string(PRINT_FP, NULL,
+				     "%-16s    STP Transitions: ", "");
+			print_u64(PRINT_ANY, "transition_blk", "Blocked: %llu ",
+				  sstats->transition_blk);
+			print_u64(PRINT_ANY, "transition_fwd", "Forwarding: %llu\n",
+				  sstats->transition_fwd);
+			close_json_object();
+			break;
 		}
 	}
 	close_json_object();
@@ -843,6 +867,8 @@ int bridge_parse_xstats(struct link_util *lu, int argc, char **argv)
 	while (argc > 0) {
 		if (strcmp(*argv, "igmp") == 0 || strcmp(*argv, "mcast") == 0) {
 			xstats_print_attr = BRIDGE_XSTATS_MCAST;
+		} else if (strcmp(*argv, "stp") == 0) {
+			xstats_print_attr = BRIDGE_XSTATS_STP;
 		} else if (strcmp(*argv, "dev") == 0) {
 			NEXT_ARG();
 			filter_index = ll_name_to_index(*argv);
-- 
2.24.0

