Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C768D7F3
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjBGNEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjBGNEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:04:51 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850E839CD5
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:43 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d14so13468881wrr.9
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2LNCnTYQnKI2Qi+rIbkgnUL8Nmbo6Qz5VaHG00c9zYg=;
        b=R6b16Anl58GF4Ndnmggam0JqBAZSqo0/T+bhnT/iYTRtuObc/dXZ6xloUhtLwWp9y+
         UTJr92rFlrbCq+tzaHrs69ArfVTgoUR6PBj84O9mvc1/I1Exc0hMdlZGgTDvtwykl0Mt
         IAX8Zic1dqgE42gMDp9jS6SSO/IL9ixdJoXYfBr4v5PBbsLwSy9yhHqt/9vY4ATmV22F
         TPodadJqvEWI3SpF+/IqycXhFvTGxkOmBE5FiauyXH/rK6M+Lvo8f3W8t6OYeoKG60fV
         dqB3sn4haHf/1mH9+XiRfXRDFqrw4o4xjICP9IXP2Yv0ka01Q52bcPpDKi+XDlW3l6rI
         n2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2LNCnTYQnKI2Qi+rIbkgnUL8Nmbo6Qz5VaHG00c9zYg=;
        b=PKmPx26czynQvPeBScTL2ywuxog38hvSQo6LMuPc1AtS/yU6LZXVDM9enRngbt7fXb
         jiiioGwhy3e6RgNAtnfpCvG2jTrJAXZ0YuUP8xJFr7NvTeCTfWIKfkrIwzD5Bn6sDvBH
         BZCkQ17L7rHjDm+YFDyF7ytOETMaWIs0aQJkyIOPVd61gy02wiIHxF1wjl7WiI5lBiqm
         hKb89h6YKNsWBTGkgpSYJly8XAQZ3J2u4Xj6snVin6Qdv58ZXutQ9R7nk+xl9wzm7qL1
         vNNJQIdORzYn2/PYCQVocOhLeMGA40IaxLw2HlwG7JH55TNQpJhYpt6BuBYOHWF0cp4L
         0Qog==
X-Gm-Message-State: AO0yUKUwMd4UZCy5AEzKC6vvmCRJTAUYHhMssNuEqVwRVEcVfMMah6/b
        b5OgbX6ziIzznv0LYWxfpKPQxSPV/UT0CBHS2kA=
X-Google-Smtp-Source: AK7set9YTo6jBw+wu7vaeuAeClfkKfkEd/2ijcXBN2UJsc6YhpTX+cpVF2pNclhOp4qg7ZOFKK1Euw==
X-Received: by 2002:a5d:4806:0:b0:2c3:ea6b:ef83 with SMTP id l6-20020a5d4806000000b002c3ea6bef83mr2957523wrq.12.1675775081619;
        Tue, 07 Feb 2023 05:04:41 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:41 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net 0/6] mptcp: fixes for v6.2
Date:   Tue, 07 Feb 2023 14:04:12 +0100
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAExM4mMC/z2OTQ6CQAyFr0K6tnEYFYhXMS46UKULBtLCxIRwd
 2dcuHx/X94OxipscK92UE5iMscs6lMF/UjxzShD1uCdvzjvWtwWW5Vpwsgr/t1EKvNm+JIPNui
 x7q4dtbcQAjeQWYGMMSjFfiy0vB04FcR5IomlsSjn8e/Jo+TwPI4vG2YZcZ4AAAA=
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1639;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=2gwf1t1oLdLLnLS96VoPdbQ5z+6BonFJUbLHcasVbGo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxofU3dUJPYLTFtKKn31mjpfvMSn+lCifKCJ
 xo/SKVohx6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 c/UCD/9DpgQJ8kzrJ2KEQv1Xi/VGx2/EyabkZme7Vtis7wJFenjHLJAHALXsvAtTY/6mqc6YZ2+
 9KnFFKfL46SvYBIcrieYB1ryxDWGQlmOn+OculZ6VWyUgJZRLOzaFrLTi/LJ3iVgsfDXDMoyPWz
 rtvyqO/nfdoeOQvPCjOuVAqHVkL7xK9lcZa27IyF1rPyLs3e80WmQ69DvcQuRkVXDTO9ZuxshV3
 zm0LCL43YCYh8/Gjmup5/nOG0FjbuJNzzNNZyeer1y6JbrvkXv1fleuSMrYC2fJdpPpWXN8eEk3
 9PYliiKo2h7WT2p7jVe1L5dSZ5a46rNmuwXYiA3UKkkNJEGd5EGy09fhUBU3TuB9vHfZCiFaghk
 kC4o+sS80nxzoJqab2g3YbcaL1Pudgzye5XvjiScEcP0CNO2dIjTWeL9zlA3968vYhE11imsGK4
 yS8e8hDOb3meiFGAxQ4YcInNen9jFPsTIPU/1WjxZ6ciBBZL2rYZ7lwkIJlYVMYdeKjw7stSZar
 TS07d6zvKETpCIc31rtuesf4OcCATbRBWueZx3aE6VDeavG04zAVWu7IeYEq3g3YTWZi8oDi5Yt
 EilmNWGLySNbLcFgJhlcuTrsgZm1Y4Q1/wHOsdr4b0Qj8BT0g03A5QZDgODmLoZl1n6+knuogow
 pe75W2YZdKn34vg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 clears resources earlier if there is no more reasons to keep
MPTCP sockets alive.

Patches 2 and 3 fix some locking issues visible in some rare corner
cases: the linked issues should be quite hard to reproduce.

Patch 4 makes sure subflows are correctly cleaned after the end of a
connection.

Patch 5 and 6 improve the selftests stability when running in a slow
environment by transfering data for a longer period on one hand and by
stopping the tests when all expected events have been observed on the
other hand.

All these patches fix issues introduced before v6.2.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Matthieu Baerts (1):
      selftests: mptcp: stop tests earlier

Paolo Abeni (5):
      mptcp: do not wait for bare sockets' timeout
      mptcp: fix locking for setsockopt corner-case
      mptcp: fix locking for in-kernel listener creation
      mptcp: be careful on subflow status propagation on errors
      selftests: mptcp: allow more slack for slow test-case

 net/mptcp/pm_netlink.c                          | 10 ++++++----
 net/mptcp/protocol.c                            |  9 +++++++++
 net/mptcp/sockopt.c                             | 11 +++++++++--
 net/mptcp/subflow.c                             | 12 ++++++++++--
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 22 +++++++++++++++++-----
 5 files changed, 51 insertions(+), 13 deletions(-)
---
base-commit: 811d581194f7412eda97acc03d17fc77824b561f
change-id: 20230207-upstream-net-20230207-various-fix-6-2-1848a75bbbe6

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

