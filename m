Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA9B196718
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgC1Pkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:40:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50650 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgC1Pkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:40:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id d198so14821934wmd.0
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5F4G6g7xDG0QrCBl0/TWqCIhAJQH6dkd9KuQgIOZKMw=;
        b=KuviICTox9/zI2fyN09CSt4/zJ59HAYYo0mka5wypKEEA9C7A0K+kb3GUBjJfNx9Zx
         Vrl3rvOSINSkQ6XgdALOH5VUF+GX2ANt/ISNR1OsSjQPciTp2b9isWu0GUl16vlAB7qm
         27gP4N4Eb6Lb9hg3v3l0VCVnnB2iukM1DqqNNzAmOvI2m4IjP4Zfgkk84Sk5zsdktOz5
         pg4Zgr2YFCiQE67PDw5ifTLMflqJuWjI7+7qNKCCOiOci3x6cqssHWCT2xYugGnDHa9W
         XzIemk+lHYFV1NOoeGi5vLK2+6xpthlXZCGlOGhdcxKrrYxK1nDCBWJUcujOjlOnsDNE
         6V5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5F4G6g7xDG0QrCBl0/TWqCIhAJQH6dkd9KuQgIOZKMw=;
        b=AqiVf911zSbt46gfKNhzOmocb00FiSoE+TYeiIYu37NXEft0vdUtVYQhraTLpAwAp0
         yOOnoIBHwg1lmMv6jUS5UBWXo0SCwNr85tdoTmXacul4SW4kY15a6VziuJqYxCkqcjuo
         wSwLhD6ipXXY/gFHhXtm7pElHbFItB28FmP+Z/zMAZJjiCuMzfZThZu6aau3HW+zBSxE
         bpAO506+JnhTRJm2mvZ5Z6cxnFeeENsXXlYToqaylXv8XGJlOH4eyjWlmrXYZsHbhgKO
         vh1IornpgNuBxtwDtl0Bvxi8N+AyQU3fkuEP2AWcnMDCn+6qEMbrG3DgDPHFpM/TOu2q
         PKTQ==
X-Gm-Message-State: ANhLgQ2tei4L36R1inuhArngYEAmwd7iwGb8EjVB6bEpJoNhYT5j9JZe
        ldKUaVGDCslU0fGYtkatuZIspgdy7C4=
X-Google-Smtp-Source: ADFU+vvOabGO4qc8E6fvMDvx2h/bdVcoxuE3JGdVvT1rWKqSW/WwPPBl3aXRl0hhAl6ASotkfOyxPA==
X-Received: by 2002:a1c:c3c3:: with SMTP id t186mr4516014wmf.118.1585410050607;
        Sat, 28 Mar 2020 08:40:50 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o14sm12469395wmh.22.2020.03.28.08.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 08:40:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, pablo@netfilter.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, paulb@mellanox.com,
        alexandre.belloni@bootlin.com, ozsh@mellanox.com,
        roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: [patch iproute2/net-next] tc: show used HW stats types
Date:   Sat, 28 Mar 2020 16:40:49 +0100
Message-Id: <20200328154049.6580-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200328153743.6363-1-jiri@resnulli.us>
References: <20200328153743.6363-1-jiri@resnulli.us>
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
 include/uapi/linux/pkt_cls.h | 1 +
 tc/m_action.c                | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

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
index 2c4b5df6e05c..d499a38c9f57 100644
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
@@ -399,7 +399,10 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
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

