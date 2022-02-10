Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CC34B09FC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbiBJJvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:51:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239098AbiBJJvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:51:04 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1CC1DD;
        Thu, 10 Feb 2022 01:51:05 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x15so6858776pfr.5;
        Thu, 10 Feb 2022 01:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IPIAr9B88raXJ/R9UN+5dNl5AB4bp+Kz/ykYnflmqHA=;
        b=dhXOZo2rgw542LFautHg/acRTCvI7pYc0k6jPgg//YHRpMEZbS/OOzKO+NiHAVbYrL
         UlhhyLd006X34XKYbLo6F7KrA9bTmE4BWOQ8/Z7tZhKaIgAS8qhLLINjOpi5G13OKb8O
         ZysLk7NigCmKsKdT5ut00MRD3yQvDEeW1Td3zpsl7ZZFsvfQZ9fnzJnBVTWmo9BRS+2c
         gjx0nnF16sW0ZmId+xwpXiMpAFIj0D7HwuzskWrgOeQU9paH3oblUBz5SkQBWByAI6If
         tHC8oAFTLbFkDdNjOL+F/Rm8uHslOfAGlu3PwSA2IEgEoXqPoV6xfI2N8iZP3SzHkZto
         CGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IPIAr9B88raXJ/R9UN+5dNl5AB4bp+Kz/ykYnflmqHA=;
        b=SXjn/nxrNj8IC0OzmnOoaAWrPX0vd7FVKnrnzUF25Z5d91qmhoXAaYN9l6MXbeiuli
         EiRN+AHYzR1IdJLFeg7TruXsh30l/KRiL5uU5lm7nkcLopc02iMwFyPzkspxZvDFggz3
         Gx7zlItC/q7xRqsFaQ8lyT9C5DniGhcQK4YStgCk+SXR0ZoLgHsGqgCDxaKqGkPho+Ir
         sI/AMG00J3bngiSPnTmPcYtJ6erGG7OT87C7tL0UmPKD9hsqs7cWsf8yyt1Qi4PWjMIM
         EizT3JsJNxoStsqC3QkF81WOypnYb86aUOXU+AfoGkv/4TsM5ehXN9CIDj9gqwka94MY
         PqYQ==
X-Gm-Message-State: AOAM533akew1FSto4bYy42epHVE/T8FQsH3lT584yDzZkoIHyKuMqHia
        Wv8d70HyAVknkbLsX9J9S8IKgmVhyDE=
X-Google-Smtp-Source: ABdhPJxshsMoUNHED4iI0+dVLTxCdLlhnwR3l93Vq2qNJXwUGN0ZEQctX616cEAwwU4/xqQQ7N/7ag==
X-Received: by 2002:a05:6a00:b85:: with SMTP id g5mr6806473pfj.27.1644486664676;
        Thu, 10 Feb 2022 01:51:04 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c11sm15767939pgl.92.2022.02.10.01.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 01:51:04 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Hangbin Liu <liuhangbin@gmail.com>, Yi Chen <yiche@redhat.com>
Subject: [PATCHv2 nf] selftests: netfilter: disable rp_filter on router
Date:   Thu, 10 Feb 2022 17:50:56 +0800
Message-Id: <20220210095056.961984-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some distros may enalbe rp_filter by default. After ns1 change addr to
10.0.2.99 and set default router to 10.0.2.1, while the connected router
address is still 10.0.1.1. The router will not reply the arp request
from ns1. Fix it by setting the router's veth0 rp_filter to 0.

Before the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  Netns nsrouter-HQkDORO2 fib counter doesn't match expected packet count of 1 for 1.1.1.1
  table inet filter {
          chain prerouting {
                  type filter hook prerouting priority filter; policy accept;
                  ip daddr 1.1.1.1 fib saddr . iif oif missing counter packets 0 bytes 0 drop
                  ip6 daddr 1c3::c01d fib saddr . iif oif missing counter packets 0 bytes 0 drop
          }
  }

After the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  PASS: fib expression did drop packets for 1.1.1.1
  PASS: fib expression did drop packets for 1c3::c01d

Fixes: 82944421243e ("selftests: netfilter: add fib test case")
Signed-off-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: no need to disable rp_filter on router veth1
---
 tools/testing/selftests/netfilter/nft_fib.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index 6caf6ac8c285..695a1958723f 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -174,6 +174,7 @@ test_ping() {
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
 sleep 3
 
-- 
2.31.1

