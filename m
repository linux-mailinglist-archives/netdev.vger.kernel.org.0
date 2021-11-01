Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9E34412A9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhKAEJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhKAEI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:08:59 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA03C061714;
        Sun, 31 Oct 2021 21:06:26 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o10-20020a17090a3d4a00b001a6555878a8so3620721pjf.1;
        Sun, 31 Oct 2021 21:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lR2rA3syRfYqNnvx4W87XPNX8FptLg6EEYcLwPJf6yQ=;
        b=e+bQwPhy3S/XmMl7jOxbwtRUTN0Ug7CoquiD61CCa40odtXl0J9OVYpTJ4vrDzQgLe
         cjvHCEdMaFAYPfUXGXeDp+r//EUTAgYUR7/VVj6yO8knvL4pW+bQB0UfWq/bYpcvyPUi
         H6c/81DeALxGn47CGwL0YRTZbqWaBNEP5ztZL46KPzZ/5vfGNn9FazCUGn/IIdCauDhz
         Eb8t7/dcmxojJP1qegJcTjfQj5+ixxxLJpv0rqBCU+ZzbUs5gc72MMKFH46DfS09/GhE
         q0JuLDUA40oZ3qYCHoNHn5zfAQDA2qHY872kFvsR5DKdYBzEAx0HKK2o+GfTq6BLz2im
         1j3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lR2rA3syRfYqNnvx4W87XPNX8FptLg6EEYcLwPJf6yQ=;
        b=IRd9YFJU1J15mBmsuSpfT7IhdchzrEzpnT1KT5cg95xTKZzIk6YK5boBCL+U/4y/fG
         PM6cqrXX4GCceiYJWdIQwd/jO0YyxI9Oi0TdqONvLIy24Cr8PPp3ljyxZzbv4g5rH5uj
         vw272euGBS2nV7xccrLkzA2nVOY//J7Xjbz4SSWsXsqtU4Wb2DlA42PBBPoLTdfy6KkF
         twLMwUiBh26x1y8vmeSd/BjvdMi8WAGVWPPeq9HgL2cm36zWXkHOAjUftoGrVQ85y965
         JLqoCqm1VMfKf2I3+ANiUAIYbw4iWa5AnUMeX2PZ/c27TJJ5zU8u2RB7OVlOBSxKhtKs
         FcZw==
X-Gm-Message-State: AOAM532jEGi6ZnrYovfkpr6ekQsoDcMqXwZF3Ht9LTvjelMVae3ATdD7
        PNZcnK4F6HIf4FPAQWFc51CkrYLR+4I=
X-Google-Smtp-Source: ABdhPJz0ZikyE48k5wzjrKaWpIoqrxkwhaAn0ExDSEj4gcy9Azr1hUISrcCmZgc0RvZC15l2QtzPpQ==
X-Received: by 2002:a17:90a:9501:: with SMTP id t1mr4273009pjo.134.1635739585940;
        Sun, 31 Oct 2021 21:06:25 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm11132231pgt.7.2021.10.31.21.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 21:06:25 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Coco Li <lixiaoyan@google.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-kselftest@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/5] kselftests/net: add missed icmp.sh test to Makefile
Date:   Mon,  1 Nov 2021 12:06:05 +0800
Message-Id: <20211101040609.127729-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101040609.127729-1-liuhangbin@gmail.com>
References: <20211101040609.127729-1-liuhangbin@gmail.com>
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
index 492b273743b4..9b1c2dfe1253 100644
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

