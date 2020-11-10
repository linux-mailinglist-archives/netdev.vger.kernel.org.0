Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5F92AD0AC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 08:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgKJHyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 02:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgKJHyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 02:54:03 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C627C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 23:54:03 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id me8so6663452ejb.10
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 23:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/BN2tIUXpvNmL+C9oD+JE4fTY2d5efREbNFCs5KRvxI=;
        b=EVt7UwzkzWI92H7YUSEsTlvtOD3F8ACcz6RBwcxFOQj9tny//X8xCPxrLMXm4LDK1F
         9NpZdsnWi4Jd+6lkRgRHJzK0LBQ+B3bWmaan5WXbI3P9ASs7JyhdOSNXHO4Ekcd0j3nb
         JN5mJHvq1bICrFCDR0pkl+7pQh9f24zdy7EER1q7M+7dpfrIkCcWpyvBQP8sXJxC6ntN
         6cM3EUbVUQuIi4x5ZfGOfzvcCn+ENyJqXDS2lVuPOLoUQq/2EDqLPjNvPyL6jaOwfwlz
         3iCg5YtEf733w/1v5QVLOYwvx7cq2nxL8P+k0YghUVZ6XxVhsoT1dDcpqTdLuKyKP5Yh
         uUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=/BN2tIUXpvNmL+C9oD+JE4fTY2d5efREbNFCs5KRvxI=;
        b=gy4j5tugoG0nDEulnV4Z/PeVHH/0PXdAFFkVJ/MR1oSdKKNw+TwGzbKXrqFFj5BSqs
         ZG4pY/wIVstN85yaNZbH1UIfZKo5APJwezhiShyF0U5lUXBkFxhUX4qfH7D1sNFnN6DP
         y+HcXQCTuZ7dn5TMePrPGN6x7K0/7jgAi0ZmEYiPTscO1LRAlWUjuyyfBXIsK5xXoXt/
         TRKguUIVSsyt2FB7LXAFILBb48fsDxGdhj1ThD4qLN1coJ2oJSzKAj27YKJoRjEp7wHv
         nN+gQy3cbh8vjT3vFDPaahUZCEwUAaiEZ9+fD/5QhIBROqh2MebTOvFlgEfYiQTjE6AG
         93GA==
X-Gm-Message-State: AOAM530ctsv9oNeoQWW006vBt5e4Le0caQVOhlHsOG0EH8XQhf2/8CYp
        0Jnzx6P5PH1xcX8PFybC11ivoWD9ubw=
X-Google-Smtp-Source: ABdhPJykYqz+hLG5hSC3gLMLLXsTSAFs9qp4inUeyWjxTrEwzZ5sX30ddygvCztAApFjlVZ3Cr/FEQ==
X-Received: by 2002:a17:906:a891:: with SMTP id ha17mr19902223ejb.116.1604994841732;
        Mon, 09 Nov 2020 23:54:01 -0800 (PST)
Received: from localhost.localdomain ([2a02:810d:e80:4c80:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id z2sm9983801edr.47.2020.11.09.23.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 23:54:01 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, simon.horman@netronome.com, jhs@mojatatu.com,
        jianbol@mellanox.com, Zahari Doychev <zahari.doychev@linux.com>
Subject: [PATCH iproute2-next v2] tc flower: use right ethertype in icmp/arp parsing
Date:   Tue, 10 Nov 2020 08:53:55 +0100
Message-Id: <20201110075355.52075-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the icmp and arp parsing functions are called with incorrect
ethtype in case of vlan or cvlan filter options. In this case either
cvlan_ethtype or vlan_ethtype has to be used. The ethtype is now updated
each time a vlan ethtype is matched during parsing.

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 tc/f_flower.c | 52 +++++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 00c919fd..58e1140d 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1324,9 +1324,9 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 	bool mpls_format_old = false;
 	bool mpls_format_new = false;
 	struct rtattr *tail;
-	__be16 eth_type = TC_H_MIN(t->tcm_info);
+	__be16 tc_proto = TC_H_MIN(t->tcm_info);
+	__be16 eth_type = tc_proto;
 	__be16 vlan_ethtype = 0;
-	__be16 cvlan_ethtype = 0;
 	__u8 ip_proto = 0xff;
 	__u32 flags = 0;
 	__u32 mtf = 0;
@@ -1464,6 +1464,8 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 						 &vlan_ethtype, n);
 			if (ret < 0)
 				return -1;
+			/* get new ethtype for later parsing  */
+			eth_type = vlan_ethtype;
 		} else if (matches(*argv, "cvlan_id") == 0) {
 			__u16 vid;
 
@@ -1495,9 +1497,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				 TCA_FLOWER_KEY_CVLAN_PRIO, cvlan_prio);
 		} else if (matches(*argv, "cvlan_ethtype") == 0) {
 			NEXT_ARG();
+			/* get new ethtype for later parsing */
 			ret = flower_parse_vlan_eth_type(*argv, vlan_ethtype,
 						 TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
-						 &cvlan_ethtype, n);
+						 &eth_type, n);
 			if (ret < 0)
 				return -1;
 		} else if (matches(*argv, "mpls") == 0) {
@@ -1627,9 +1630,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "ip_proto") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_ip_proto(*argv, cvlan_ethtype ?
-						    cvlan_ethtype : vlan_ethtype ?
-						    vlan_ethtype : eth_type,
+			ret = flower_parse_ip_proto(*argv, eth_type,
 						    TCA_FLOWER_KEY_IP_PROTO,
 						    &ip_proto, n);
 			if (ret < 0) {
@@ -1658,9 +1659,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "dst_ip") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_ip_addr(*argv, cvlan_ethtype ?
-						   cvlan_ethtype : vlan_ethtype ?
-						   vlan_ethtype : eth_type,
+			ret = flower_parse_ip_addr(*argv, eth_type,
 						   TCA_FLOWER_KEY_IPV4_DST,
 						   TCA_FLOWER_KEY_IPV4_DST_MASK,
 						   TCA_FLOWER_KEY_IPV6_DST,
@@ -1672,9 +1671,7 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "src_ip") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_ip_addr(*argv, cvlan_ethtype ?
-						   cvlan_ethtype : vlan_ethtype ?
-						   vlan_ethtype : eth_type,
+			ret = flower_parse_ip_addr(*argv, eth_type,
 						   TCA_FLOWER_KEY_IPV4_SRC,
 						   TCA_FLOWER_KEY_IPV4_SRC_MASK,
 						   TCA_FLOWER_KEY_IPV6_SRC,
@@ -1728,33 +1725,30 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "arp_tip") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_arp_ip_addr(*argv, vlan_ethtype ?
-						       vlan_ethtype : eth_type,
-						       TCA_FLOWER_KEY_ARP_TIP,
-						       TCA_FLOWER_KEY_ARP_TIP_MASK,
-						       n);
+			ret = flower_parse_arp_ip_addr(*argv, eth_type,
+						TCA_FLOWER_KEY_ARP_TIP,
+						TCA_FLOWER_KEY_ARP_TIP_MASK,
+						n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"arp_tip\"\n");
 				return -1;
 			}
 		} else if (matches(*argv, "arp_sip") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_arp_ip_addr(*argv, vlan_ethtype ?
-						       vlan_ethtype : eth_type,
-						       TCA_FLOWER_KEY_ARP_SIP,
-						       TCA_FLOWER_KEY_ARP_SIP_MASK,
-						       n);
+			ret = flower_parse_arp_ip_addr(*argv, eth_type,
+						TCA_FLOWER_KEY_ARP_SIP,
+						TCA_FLOWER_KEY_ARP_SIP_MASK,
+						n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"arp_sip\"\n");
 				return -1;
 			}
 		} else if (matches(*argv, "arp_op") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_arp_op(*argv, vlan_ethtype ?
-						  vlan_ethtype : eth_type,
-						  TCA_FLOWER_KEY_ARP_OP,
-						  TCA_FLOWER_KEY_ARP_OP_MASK,
-						  n);
+			ret = flower_parse_arp_op(*argv, eth_type,
+						TCA_FLOWER_KEY_ARP_OP,
+						TCA_FLOWER_KEY_ARP_OP_MASK,
+						n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"arp_op\"\n");
 				return -1;
@@ -1894,8 +1888,8 @@ parse_done:
 			return ret;
 	}
 
-	if (eth_type != htons(ETH_P_ALL)) {
-		ret = addattr16(n, MAX_MSG, TCA_FLOWER_KEY_ETH_TYPE, eth_type);
+	if (tc_proto != htons(ETH_P_ALL)) {
+		ret = addattr16(n, MAX_MSG, TCA_FLOWER_KEY_ETH_TYPE, tc_proto);
 		if (ret)
 			return ret;
 	}
-- 
2.28.0

