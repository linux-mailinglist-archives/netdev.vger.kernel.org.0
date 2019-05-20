Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A322ADF
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 06:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfETEhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 00:37:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35717 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbfETEhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 00:37:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id t87so6567444pfa.2
        for <netdev@vger.kernel.org>; Sun, 19 May 2019 21:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PmB4IkObjpeuboZRKYxZGWDOxg23kM0em7zXv3O1hUU=;
        b=UUoZE98JXcCWZqaQ/AQdnfUElkTlZSK4vvpMhuyRrjBEAf3DsI0s+TsxI+oD6+1P0D
         uwNPRawPcRZZjuSxi4W0PRTQEXh6/tyBbNlwpwphgJJzvK9llqxv8tQIGSBDIGwSOXPo
         vfrHOlqD76YevVxK6G67RmJOhKCGkDYHzzX+O5N9UQFENhEotvHsVtDYlcm22ccCUMTS
         5XezjLEjUYR05pr+IOLamZdSI/tysBKQNJaNzdNOu0+1ibU7xmaGU1ocvq2YVdfm2Pnp
         J/tF4roIsD2rG/A4rD80pRFD8yLk/pmjjLky+QSElMVcEVoHAH774pyA72jPgG/FxYgk
         IIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PmB4IkObjpeuboZRKYxZGWDOxg23kM0em7zXv3O1hUU=;
        b=HsPHOUW8gs6OxTQhgCoYHY/ZfA/zUE9uWjzffYf/ED4u+5U9M5b8rndkbXpFXdpVtE
         +rYlmL/73Pe2WMr3yCzyjnVuAU0EgReeswDcsrLJWp/bM6tU/ruovoaPe/3L9qUHoEpk
         i3JVaU6MTxpSMFxnanJ9LlWwJsdgX/5Yznh7y26LxW2/qYBxXFtnjr/BfbQrIP0sCzan
         8R0CNH8qxJZ2hHUEs5KCMm5yjh0fF/5MUZ7dUS1eEZhiUVzrg7zKapvUG3xuGYGXt7ma
         pVJdO7ghlk7FYdTPR7XGq9ML7MDpe9ghAZAG+M+ERYSRUZ5YWaf/kPSElmeNi/cWa439
         EOuQ==
X-Gm-Message-State: APjAAAVVRYsdXFFnZX3MNT1SH8AAuwlhK5WbxS+MZGfvRmHSLFPjBk1+
        azuoGMO2S0o8yRZiDnSwa5M/LWpQ9Ws=
X-Google-Smtp-Source: APXvYqw8il/z36o5SNsgyMy4rCppYz+pL9n4JXa7s3/yeZ7/YN2Jp3NnwEZHVNGjKztwp8rbCi6uhQ==
X-Received: by 2002:a65:450b:: with SMTP id n11mr31493821pgq.174.1558327052963;
        Sun, 19 May 2019 21:37:32 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 85sm20933953pgb.52.2019.05.19.21.37.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 21:37:32 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] selftests: fib_rule_tests: enable forwarding before ipv4 from/iif test
Date:   Mon, 20 May 2019 12:36:55 +0800
Message-Id: <20190520043655.13095-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190520043655.13095-1-liuhangbin@gmail.com>
References: <20190520043655.13095-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As all the testing addresses are in the same subnet and egress device ==
ingress device. We need enable forwarding to get the route entry.

Also disable rp_filer separately as some distributions enable it in
startup scripts.

Fixes: 65b2b4939a64 ("selftests: net: initial fib rule tests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/fib_rule_tests.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/fib_rule_tests.sh b/tools/testing/selftests/net/fib_rule_tests.sh
index 1ba069967fa2..617321d3b801 100755
--- a/tools/testing/selftests/net/fib_rule_tests.sh
+++ b/tools/testing/selftests/net/fib_rule_tests.sh
@@ -186,8 +186,13 @@ fib_rule4_test()
 	match="oif $DEV"
 	fib_rule4_test_match_n_redirect "$match" "$match" "oif redirect to table"
 
+	# need enable forwarding and disable rp_filter temporarily as all the
+	# addresses are in the same subnet and egress device == ingress device.
+	ip netns exec testns sysctl -w net.ipv4.ip_forward=1
+	ip netns exec testns sysctl -w net.ipv4.conf.$DEV.rp_filter=0
 	match="from $SRC_IP iif $DEV"
 	fib_rule4_test_match_n_redirect "$match" "$match" "iif redirect to table"
+	ip netns exec testns sysctl -w net.ipv4.ip_forward=0
 
 	match="tos 0x10"
 	fib_rule4_test_match_n_redirect "$match" "$match" "tos redirect to table"
-- 
2.19.2

