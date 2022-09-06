Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D95AF663
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 22:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiIFU4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 16:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiIFU4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 16:56:37 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61BD895FA
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 13:56:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c11so13025911wrp.11
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 13:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=RZRC0OhzUwbsz5o6LL8NbWidAu3WkyLmyQWIoEdm+Jg=;
        b=4Ji5BUeDdT3w2OVS/yQVfWuHzPrLkTm8zpYRx2UWHWio/6W9jrrt8L3IWVHPr+ooY7
         i3Jej7gc5Exww9C/RufEN860zdBH0dpndyfofXbcYgHBOaT1AxHxGmKFFgGvKJ4N8mcW
         fyNE1WmC4f0iU/4k/9LT4GJO7zd8RBe3Svnuc+uij8L6SQraU2MCw6e+dwyWFjw63cch
         I7hUZuoXTmqgoxVl0YF2M1GVjaTeOrCLBPfJc0gaZB6+W9skIDOyyRFhzPrftQQnZ5a3
         oXhYxnlZ3kxfES7Fsm85706o/VroybaNW2sY8wK5ymL5cbxiEahstleQ9VXzQxj7j75b
         /grw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=RZRC0OhzUwbsz5o6LL8NbWidAu3WkyLmyQWIoEdm+Jg=;
        b=4KShJMR8AcPsxSGfFftKLYO6/H9Fv+ozaJvjNTO1aZpMPmfFGs0BTyhpsPo4+W4CyL
         FPUEXuEiazJpnxLj4lhbdkGoD7BlcsFSdnVbO3NzYjbMVl7k5k1r04r7+pHjmXTN9mQl
         QmBjABLwUeDHp5vXlEDdQmYHW4WUX05misRamrKUyty3AYocG33KVcb46ki7vC50lGaq
         qnD/bWJKrjyEMIo5QGWuo7n+YsI3jgn240f/BdFHjkwqG8AekGOuVB6hKd6NtYXX7NcJ
         wn2bCUnPx7j9rzwWpsbStYN3Rdc6q8FfkAaOOa/DekDskmkrdTYUxyjZYtzlnmZTFbiq
         KkJg==
X-Gm-Message-State: ACgBeo0dozYquH53UXjwKV+3wU1O2Y2GZV2nznnV1vLLKx3hBcxnkzEX
        0P3wS7soezEHkdk2fx6/uKTdtQ==
X-Google-Smtp-Source: AA6agR7XxadU1nBJKVC9I9af5814KUHtWktC30z4WVGLJu0wF/DHqaVW1+kfOIN4gVZqmnVjY8oMIQ==
X-Received: by 2002:a5d:66ce:0:b0:228:a430:673f with SMTP id k14-20020a5d66ce000000b00228a430673fmr154542wrw.355.1662497791425;
        Tue, 06 Sep 2022 13:56:31 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n24-20020a1c7218000000b003a317ee3036sm15735887wmc.2.2022.09.06.13.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 13:56:28 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] mptcp: allow privileged operations from user ns & cleanup
Date:   Tue,  6 Sep 2022 22:55:38 +0200
Message-Id: <20220906205545.1623193-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1171; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=S4CDyrNeDuwlK018W6S651nbf7bbfRCydZCxhDW7uh0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjF7O5qBlYlK33qKWIebumCBpUmWZJxbNvIYsaNWiw
 uwEx7WiJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCYxezuQAKCRD2t4JPQmmgc1oyEA
 Dc9Qn2D1dJo1OMABQwg6c2OfVJyiZprfb9sKPSfeSQxD6rj7treW/AUKsgVZ3CA2RVUruf090DtCKD
 Cb7qbGDOViZN+d1VsHTMDULxI3mETmFLVGQYYg+ytqIOdNE/iKJhbOWRbVhul6XC3bCBYoN4nKKI5E
 iw6X1N5MagJh6O2cjt9f//FfO4g9NoAbGtA9SU5KOuQ7mbF++NEDmIWs5Zkxs5Qw3hwCK7QtvpHFEw
 sn/+5gNL63vkzzemfZBwaK8VGyhrOs5w/ZBz0b2bKlMpkf+l6Yg/qBkFfQlqdFj8VpVPYgmb5vOihK
 IoRkWkzXGoy0erIOm93Z63E/ulhrkWYFYIEtiYFhQFbjSkusCQ/BOa9wGVuC9vF1Eh9aUbsPmx0lvm
 tnh82vA68Tmp9QZNPGu0zlFhg0LIlbiYYsJ+O3sBH02cMlyH8gcHAGMROBQsC9vBzeY1+4lhBJEReJ
 ENlKkhknoNGgErC9nxLnesxDqzC8rtLq87JlqO/r3NVdRbOqnKCFGE7eZJH2iNXpT4PW4dMFkU94v3
 K52Jj5jMyKxZQ5PknJu97DbWOqSkn6ZbXMErQUG2ed7fiJI4/8Jjk8RXc0y2On0agcNN+H1HiBdOXq
 ztEWwjdVkvpjce9c1OGiRZv/dQNQhMwq2ecC3rs2sJfDSW5f4cs0+SEanUkg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows privileged Netlink operations from user namespaces. When a
non-root user configures MPTCP endpoints, the memory allocation is now accounted
to this user. See patches 4 and 5.

Apart from that, there are some cleanup:

 - Patch 1 adds a macro to improve code readability

 - Patch 2 regroups similar checks all together

 - Patch 3 uses an explicit boolean instead of a counter to do one more check

Geliang Tang (2):
  selftests: mptcp: move prefix tests of addr_nr_ns2 together
  mptcp: add do_check_data_fin to replace copied

Matthieu Baerts (1):
  mptcp: add mptcp_for_each_subflow_safe helper

Thomas Haller (2):
  mptcp: allow privileged operations from user namespaces
  mptcp: account memory allocation in mptcp_nl_cmd_add_addr() to user

 net/mptcp/pm_netlink.c                        | 22 +++++++++----------
 net/mptcp/protocol.c                          | 13 ++++++-----
 net/mptcp/protocol.h                          |  2 ++
 .../testing/selftests/net/mptcp/mptcp_join.sh | 10 ++++-----
 4 files changed, 24 insertions(+), 23 deletions(-)


base-commit: 03fdb11da92fde0bdc0b6e9c1c642b7414d49e8d
-- 
2.37.2

