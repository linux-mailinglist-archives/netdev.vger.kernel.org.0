Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D149662EC6C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbiKRDoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiKRDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:44:04 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0C658BDD
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:44:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so7228073pji.1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=v3QJSicqKkeLeJURWZ3koiyOwF2vhxjTOTMrBj/jUvI=;
        b=lIhhK+HfLUVu7fEBxYPMtXmViSSvquGnGR1odev4HH1hTjXkcrYgj9Z+bryzC6zAGX
         QcHvs58uJcaUQgSfm4yz9E/PzCBsmBYooPVdrPtoMR6cDY4wRiYnPkCHtm0rN+knKHPU
         s3drFz4tjpyO77Re9cpsqI+Xx+hVWgSNg15jmYnuegczpd+UHVQ5Gvoc8WiiFWSOt8AR
         peMz7BA+NdnlZ6yOueMlsyNX0ISeRkR0etpMC0L+C46P7hnbCgrBh41VRCbBZOTRj99S
         NL3BU3Li2zqn343lGbzkM32Xr3+Et+CyWwlsGeZ5QGuA9Gdnvr/1br9yxiP7GZovobtO
         GEQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v3QJSicqKkeLeJURWZ3koiyOwF2vhxjTOTMrBj/jUvI=;
        b=X4pkXJAe/YZJ93XQcTobV99BNgzQRS4cbPOF+Dgh51Tnf4Z5jo3secIB9LbEWWYkLA
         Vdik0EnWKMC6ZwBtpWPOD+30ThQcHga77oPlf3lvBSW+3BdB8a18J/6ICEmWnu9JwHZO
         nKV+bpAAdSOCGTNX7beFIKiBjRADG1o7f05y7SvcbAyVdnDISoxPip/ddTVGdX5TkiMn
         UQnUGehghG0NKskAlsuEDODCve2FfOC/GoAdtrfEaZh8CVnAwjD+QxnVz9AlloTyw/DW
         FivTkrtg8jf8p2heNkYMy/kgwLOUNOB3Lhl5TH2hU4kQiQ3ZXeA80NxWuknSKxwyH7as
         MlLw==
X-Gm-Message-State: ANoB5pnvpCSwhF4XbZ5LYi6ZY6zGuTSG8tXH+fE3TF+OuECrTt6Ve4x2
        54h0Lna+/JGtMT84OrvN8O7ISKaMmoldYw==
X-Google-Smtp-Source: AA0mqf4sU7MWqr/wjWiNGLs82U+S7Tcd9r6VRxR574hjy3EwKB0fUXhnw8v9xU3h71B83Xv3/ZK+lA==
X-Received: by 2002:a17:903:1c1:b0:185:378d:7c18 with SMTP id e1-20020a17090301c100b00185378d7c18mr5554756plh.21.1668743042450;
        Thu, 17 Nov 2022 19:44:02 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090300cc00b0016d773aae60sm2229945plc.19.2022.11.17.19.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 19:44:01 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        Eric Dumazet <edumazet@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Liang Li <liali@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCHv4 net] bonding: fix ICMPv6 header handling when receiving IPv6 messages
Date:   Fri, 18 Nov 2022 11:43:53 +0800
Message-Id: <20221118034353.1736727-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
transport header to be set first. But there is no rule to ask driver set
transport header before netif_receive_skb() and bond_handle_frame(). So
we will not able to get correct icmp6hdr on some drivers.

Fix this by using skb_header_pointer to get the IPv6 and ICMPV6 headers.

Reported-by: Liang Li <liali@redhat.com>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v4: get the full ipv6+icmp6 hdr in case the skb is not lineared
v3: fix _hdr parameter warning reported by kernel test robot
v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
---
 drivers/net/bonding/bond_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e84c49bf4d0c..f298b9b3eb77 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3231,16 +3231,23 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		       struct slave *slave)
 {
 	struct slave *curr_active_slave, *curr_arp_slave;
-	struct icmp6hdr *hdr = icmp6_hdr(skb);
 	struct in6_addr *saddr, *daddr;
+	struct {
+		struct ipv6hdr ip6;
+		struct icmp6hdr icmp6;
+	} *combined, _combined;
 
 	if (skb->pkt_type == PACKET_OTHERHOST ||
-	    skb->pkt_type == PACKET_LOOPBACK ||
-	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+	    skb->pkt_type == PACKET_LOOPBACK)
+		goto out;
+
+	combined = skb_header_pointer(skb, 0, sizeof(_combined), &_combined);
+	if (!combined || combined->ip6.nexthdr != NEXTHDR_ICMP ||
+	    combined->icmp6.icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
 		goto out;
 
-	saddr = &ipv6_hdr(skb)->saddr;
-	daddr = &ipv6_hdr(skb)->daddr;
+	saddr = &combined->ip6.saddr;
+	daddr = &combined->ip6.saddr;
 
 	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
 		  __func__, slave->dev->name, bond_slave_state(slave),
-- 
2.38.1

