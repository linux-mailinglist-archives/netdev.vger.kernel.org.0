Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C61F198ED6
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgCaIug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:50:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37808 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgCaIug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:50:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so24914844wrm.4
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 01:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C2nhPxDmxWsjX9bCBYan5+jZgdzRTpV5NKuGedwR/nU=;
        b=xtr9Uy/Lw2OrQRgRjyPhbXgsED5Tjp/mBHDHsLQPyJoLMZsk0ykDOBUm+UlB4Z3mDX
         CxckeZUvXJIEF43QHCuGUC+Fmi1UZLF5jdmOUrOXaDxyc2NO9IjwKwht9qbzm0FVaOHS
         xt7Kz5ZEyjVfRzATnTD0nbAcudDn+8E1TcdJxsaz5/i8Ju8ytGXw3o7/DbGbcNczlzBj
         06r6e2EUybzBeJ+kICaNjKsdZKjymMN45S0DlkSzt8Kn9BKfqAxHkGMmpmcCueyR9wC8
         Og7savI/ch2LncskCPXditPJ6zDT69r0A8OXnJ5+WYtL7s3KaF4wd0Ueur/YcxvwTPXJ
         /soA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C2nhPxDmxWsjX9bCBYan5+jZgdzRTpV5NKuGedwR/nU=;
        b=J+q3FZvMRaw7lEknDJfYLVVHafKjMALnfpTaVCF3ioOKi2vMLHsd3gOkb6MQ75ky1n
         zxL8U8DCgwJJOvROJhjLSICK4PWKK6iTfxtIAWc6cprL35eIM+yFGwOMdbOHIwSKRGQ+
         grR+NZGtAhLirhckC6H34g20eXas4UAxu9iA3FlBCA/SZ/n0F/mFTIio1Ew9pcvgtYqI
         Xsh5K/3v1hZEQbmHM84g1XFDhMyVAZ4JrXrKYy1TvKTS6Yg9jDIg8xjTzwwd/YO3gAiq
         e7NkYRapyR7Ofwi0sJRVA+d24/5I6dOGd5kjCK/1c3P+9uCFygVRWqm6dFfbpRQSzOcc
         wE0A==
X-Gm-Message-State: ANhLgQ1O8gWqvY5+/KMeD1eS4b4B7PX6BdXC6FYm9N+mkTX3/R+5WuAn
        pkfwyYUr31tCX+PnM8e4Z7CzuSbmjbs=
X-Google-Smtp-Source: ADFU+vu7pfivpCM5JH9gHEG7wA52D587JvYqiGOJfrK6l9pVNkDxVFmT/rxFD9L3ET2GNz7k3/dcAw==
X-Received: by 2002:adf:efcd:: with SMTP id i13mr18963304wrp.355.1585644632468;
        Tue, 31 Mar 2020 01:50:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y200sm3014530wmc.20.2020.03.31.01.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 01:50:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, idosch@mellanox.com, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        pablo@netfilter.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        paulb@mellanox.com, alexandre.belloni@bootlin.com,
        ozsh@mellanox.com, roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: [patch iproute2/net-next v2] tc: show used HW stats types
Date:   Tue, 31 Mar 2020 10:50:31 +0200
Message-Id: <20200331085031.10454-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

If kernel provides the attribute, show the used HW stats types.

Example:

$ tc filter add dev enp3s0np1 ingress proto ip handle 1 pref 1 flower dst_ip 192.168.1.1 action drop
$ tc -s filter show dev enp3s0np1 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 192.168.1.1
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 10 sec used 10 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats immediate     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- fix output then hw_stats is not "any" - add \n
---
 include/uapi/linux/pkt_cls.h |  1 +
 tc/m_action.c                | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 6fcf7307e534..9f06d29cab70 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -18,6 +18,7 @@ enum {
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
 	TCA_ACT_HW_STATS,
+	TCA_ACT_USED_HW_STATS,
 	__TCA_ACT_MAX
 };
 
diff --git a/tc/m_action.c b/tc/m_action.c
index 2c4b5df6e05c..108329db29d0 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -159,7 +159,7 @@ static const struct hw_stats_item {
 	{ "disabled", 0 }, /* no bit set */
 };
 
-static void print_hw_stats(const struct rtattr *arg)
+static void print_hw_stats(const struct rtattr *arg, bool print_used)
 {
 	struct nla_bitfield32 *hw_stats_bf = RTA_DATA(arg);
 	__u8 hw_stats;
@@ -167,7 +167,7 @@ static void print_hw_stats(const struct rtattr *arg)
 
 	hw_stats = hw_stats_bf->value & hw_stats_bf->selector;
 	print_string(PRINT_FP, NULL, "\t", NULL);
-	open_json_array(PRINT_ANY, "hw_stats");
+	open_json_array(PRINT_ANY, print_used ? "used_hw_stats" : "hw_stats");
 
 	for (i = 0; i < ARRAY_SIZE(hw_stats_items); i++) {
 		const struct hw_stats_item *item;
@@ -177,6 +177,7 @@ static void print_hw_stats(const struct rtattr *arg)
 			print_string(PRINT_ANY, NULL, " %s", item->str);
 	}
 	close_json_array(PRINT_JSON, NULL);
+	print_string(PRINT_FP, NULL, "%s", _SL_);
 }
 
 static int parse_hw_stats(const char *str, struct nlmsghdr *n)
@@ -399,7 +400,10 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
 	if (tb[TCA_ACT_HW_STATS])
-		print_hw_stats(tb[TCA_ACT_HW_STATS]);
+		print_hw_stats(tb[TCA_ACT_HW_STATS], false);
+
+	if (tb[TCA_ACT_USED_HW_STATS])
+		print_hw_stats(tb[TCA_ACT_USED_HW_STATS], true);
 
 	return 0;
 }
-- 
2.21.1

