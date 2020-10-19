Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210632926A7
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgJSLrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgJSLrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:47:17 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB78C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 04:47:17 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id h24so13459089ejg.9
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 04:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3dUzHu4x/jtCkUQNe94672McrwZ+e+Z3ey46lX8xZxA=;
        b=Ey8lzdGcTz4Ux/gJETsNjcye+z3pGCe033rUic7RTneggFsMWC5JnGHc0OTD/uKhkU
         rRQZgLWRyqAqdoWlh31sZdS54tH2ECnpJOglc72PiaQaGIKHC8PhHxE/TsZYiJYSvErt
         ccRTwUC9twav1VDhtXkl4Rb+KZlksw+I2eTGew6CcLT55n4Nh3FawcnotSVhwuPEynW3
         Bdv4IO0nkyTcUz9gBYBsw3F5WiWrqbt0DfRVbzlsmONLeo9Xo+czFDE9w8bjgiMZbG0n
         d9JP0g7K8E3xWeHbkXc7Sm+wEqjqIEoTRDmsSlt0lTGw+Iv0f2+yFrh6HeyzH3C1FH5d
         xr0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=3dUzHu4x/jtCkUQNe94672McrwZ+e+Z3ey46lX8xZxA=;
        b=ZLSS0TfNySBIGvZFZznHAsWkJ5HqATZWXTGa3peoqWwAgzhg75HS1SvXj64hmC8kUS
         rT9a8BEKFUETXGfAZYPAfoIDglWhhNXyZH2KG2GWod6x17r2Ub1anwOCeIDBX2fWeIfZ
         JGCXqi/TfwO+kFHOyskIp2hpEfscxkpMM00aYEsz0UO6c+Awck3al1zA4z10CI7Tk/eI
         gX88Y7J49dYoHr50Sf8C/JJP1n7pUeDfB9wuyIR9l9L5DN8TIkINDjkPbO+KCwbokgaX
         hNtsPD5NF5IIp8sjrq2Z2VI0QEKddl5nNPc2yOe9hHStH6VN3/ZdyTMDHmdhU0ge3qsy
         m6xw==
X-Gm-Message-State: AOAM532BLL9VbqE7DmpKxe9sVAmdGKkrUwneEdfLZr2GujunpKwvOPTT
        mFZNo1/s37HO6aNtxjqia25aPsFIcvQ=
X-Google-Smtp-Source: ABdhPJzEfuqAt1emlQHKQxsZhIcfwru0OUFwUO0Mmi270ppJaWx5RkiYxMkNjzRvUDWBQJ222B3Zog==
X-Received: by 2002:a17:906:9588:: with SMTP id r8mr17416588ejx.389.1603108035455;
        Mon, 19 Oct 2020 04:47:15 -0700 (PDT)
Received: from localhost.localdomain (ipbcc01043.dynamic.kabel-deutschland.de. [188.192.16.67])
        by smtp.gmail.com with ESMTPSA id t3sm10444157edv.59.2020.10.19.04.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 04:47:14 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, simon.horman@netronome.com, jhs@mojatatu.com,
        Zahari Doychev <zahari.doychev@linux.com>
Subject: [iproute2-next] tc flower: use right ethertype in icmp/arp parsing
Date:   Mon, 19 Oct 2020 13:47:08 +0200
Message-Id: <20201019114708.1050421-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the icmp and arp prsing functions are called with inccorect
ethtype in case of vlan or cvlan filter options. In this case either
cvlan_ethtype or vlan_ethtype has to be used.

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 tc/f_flower.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 00c919fd..dd9f3446 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1712,7 +1712,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "type") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_icmp(*argv, eth_type, ip_proto,
+			ret = flower_parse_icmp(*argv, cvlan_ethtype ?
+						cvlan_ethtype : vlan_ethtype ?
+						vlan_ethtype : eth_type,
+						ip_proto,
 						FLOWER_ICMP_FIELD_TYPE, n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"icmp type\"\n");
@@ -1720,7 +1723,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "code") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_icmp(*argv, eth_type, ip_proto,
+			ret = flower_parse_icmp(*argv, cvlan_ethtype ?
+						cvlan_ethtype : vlan_ethtype ?
+						vlan_ethtype : eth_type,
+						ip_proto,
 						FLOWER_ICMP_FIELD_CODE, n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"icmp code\"\n");
@@ -1728,33 +1734,36 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 			}
 		} else if (matches(*argv, "arp_tip") == 0) {
 			NEXT_ARG();
-			ret = flower_parse_arp_ip_addr(*argv, vlan_ethtype ?
-						       vlan_ethtype : eth_type,
-						       TCA_FLOWER_KEY_ARP_TIP,
-						       TCA_FLOWER_KEY_ARP_TIP_MASK,
-						       n);
+			ret = flower_parse_arp_ip_addr(*argv, cvlan_ethtype ?
+						cvlan_ethtype : vlan_ethtype ?
+						vlan_ethtype : eth_type,
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
+			ret = flower_parse_arp_ip_addr(*argv, cvlan_ethtype ?
+						cvlan_ethtype : vlan_ethtype ?
+						vlan_ethtype : eth_type,
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
+			ret = flower_parse_arp_op(*argv,  cvlan_ethtype ?
+						cvlan_ethtype : vlan_ethtype ?
+						vlan_ethtype : eth_type,
+						TCA_FLOWER_KEY_ARP_OP,
+						TCA_FLOWER_KEY_ARP_OP_MASK,
+						n);
 			if (ret < 0) {
 				fprintf(stderr, "Illegal \"arp_op\"\n");
 				return -1;
-- 
2.28.0

