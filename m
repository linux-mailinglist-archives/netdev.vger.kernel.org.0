Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A937F443B84
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhKCCru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhKCCrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:47:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA1CC061203;
        Tue,  2 Nov 2021 19:45:13 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e65so1082861pgc.5;
        Tue, 02 Nov 2021 19:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4ID5mhgXXH+a5xryhUpR8xJXIDPoajtSQuHKCUgT2Y=;
        b=bPo9Oof842oZ8pEJRKlIwxt/segTRUzzmxyNr2yllhwtzft0SBx9YQuW1wwcx+s72t
         LrtnRy9juZYplNm/HoX2+R2neok5TxWiS75wzHnow3tqchbSFgWZZMs9AphKFGPa7Uey
         vx2XMoZoIRsW7xWqLidgjzU0wGTTXXFjvc5WoO0YacAfkX+ZJBPkb8OwBfaHqkhPvNT5
         fl42RwN75XMhzk14EPOZfQctSH7YzO2It+Tm9VAa6e2tJ4GmcrPtQwKQruXmgh3e9LRm
         TED/8tupjDhRds1ACccEH/v/WFQ0ujaiLBhI1BTAQO2hlQ/9jUqDoKJmVq2QisEPVFgO
         K4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z4ID5mhgXXH+a5xryhUpR8xJXIDPoajtSQuHKCUgT2Y=;
        b=HR5c2sfA/IGHJlThnD6DIcfPBeYk9VZ+X7wkC5B/L3Tu9gGFscmFcgDftGylT9EcYs
         RCJf5Dv6fD+WVuSFsYRVR9u3gZreAdqdQnOotK/9+9gO3Se2b/IpKxrFUA3OV/UXspfN
         qfCcX4+TIpmERlwMVQ/U5DCsKDzlArfxXj2CF8pxSfX1Hy/UEko0Vc4zCF/jRUyN64ke
         BcCZ+BREDp1ZA1NlUiMxQbNlllYc0wMLNCVmG0u8P3RNIwHtJ8M51VrLzaSIap7KEFOH
         isaUcFrbiObwPXAht53Bev+jVLKa3ncVBqu356sWJ6Nj1csfIlapo4logKuTRzaacJWw
         qx4w==
X-Gm-Message-State: AOAM532NqMY9hNVQaYU7GX5mcW6dLkEU3wsYYkb9D39Ix5O/fMlq9C8l
        oW/19AGKy3ESP+RfbdABVLyXx8z8u10=
X-Google-Smtp-Source: ABdhPJxCT+P7NLZSk4dtk68OdRXtYZr0BcInAh0bFAlxO34pH1EsxJcpG1LqFTAOFWRzNeImRq1nVA==
X-Received: by 2002:a05:6a00:887:b0:44b:dee9:b7b1 with SMTP id q7-20020a056a00088700b0044bdee9b7b1mr41958581pfj.84.1635907513284;
        Tue, 02 Nov 2021 19:45:13 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm348088pgn.94.2021.11.02.19.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 19:45:13 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 1/5] kselftests/net: add missed icmp.sh test to Makefile
Date:   Wed,  3 Nov 2021 10:44:55 +0800
Message-Id: <20211103024459.224690-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103024459.224690-1-liuhangbin@gmail.com>
References: <20211103024459.224690-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When generating the selftests to another folder, the icmp.sh test will
miss as it is not in Makefile, e.g.

  make -C tools/testing/selftests/ install \
      TARGETS="net" INSTALL_PATH=/tmp/kselftests

Fixes: 7e9838b7915e ("selftests/net: Add icmp.sh for testing ICMP dummy address responses")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index aee76d1bb9da..7b079b01aa1b 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -12,7 +12,7 @@ TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_a
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
 TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
-TEST_PROGS += altnames.sh icmp_redirect.sh ip6_gre_headroom.sh
+TEST_PROGS += altnames.sh icmp.sh icmp_redirect.sh ip6_gre_headroom.sh
 TEST_PROGS += route_localnet.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS += txtimestamp.sh
-- 
2.31.1

