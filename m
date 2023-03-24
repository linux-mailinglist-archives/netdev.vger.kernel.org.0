Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FAD6C82FE
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjCXRMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjCXRMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:12:06 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E153220A36
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p34so1556432wms.3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679677922;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rp4jzDgiOrieNODoUE7feSGHVsgmzzTUUSpbLxz1Poo=;
        b=eg3VX4b/9QMY/w9Um0SvW5sAhGNaAzNudm8etC/W+KkwNirZkXfFHTdJwh7LVrxs5q
         hlGkFrEi2Xc9WO+9EzypwG/LU2m/hQAJfEEDtD5yUU4yypvBPIEnJY8HMIqURrMFoMMS
         RiY66SctKO9N43N9v0rKlrwCyTMLjBlz6Hn0UqtN/W9yVAAq64Ols6iglhKHGYhOP92y
         1Q2TU3RWuE5P5AeJrVbYGkZzbR1hkmyvoBNIqEKG1qKnWjfBjH/cB9N6vb4vkBWYLaKh
         PLG+vfdRo8jCnRCM5wkYp6SlthkW+wOoYNIz62a5yPIMo3UP+EUnWQzYxvOZwWYdFoma
         6bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677922;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rp4jzDgiOrieNODoUE7feSGHVsgmzzTUUSpbLxz1Poo=;
        b=mvYDkbD1DaDNSjCIFvma+c5IXKDeh9CEzz8PIdDCalEhoL9SycT07uSOwd/x5jof0+
         G2pPr8+wIe86E5z1N+7wpUc50CHByllU8BGZZsGCnEahH/66yfTt5zJd2N0ZpEi1HriR
         EzSu9BYPPDT++ULXBxHTfrRt7AH1QcLV/LnwE4mYaYqhJfFr/NUbVkAe9u1TFxp/1SwN
         CuJvWrUQBXHBqyPB7necL24IWenB5M8sWoK2wdm9XM6jD8/to9qyDSQ4SMrmG3HhdGcI
         HLpx+MiQ2HX54MntiWQ8aQ7uTdlKv3IFNLrW26/7ND80sxBxFGCz+Xu/KcTIeJjvA26a
         h/Hw==
X-Gm-Message-State: AO0yUKXM8X+bVSDUOF/LUc7fnrhKtXj5HlcRLlKyl1SgnGgmM1VAKMmJ
        ScAZ0NVxU2UWY/fK/5NXc2/ePQ==
X-Google-Smtp-Source: AK7set9ZOoz0f0isbrMvYYJ6nHirwCbWDPt6P6SBNjHPIksNu1/Fxo15zJ/cTuX6v+Uto7JKdduWeA==
X-Received: by 2002:a05:600c:2909:b0:3eb:383c:1870 with SMTP id i9-20020a05600c290900b003eb383c1870mr3013607wmd.11.1679677922317;
        Fri, 24 Mar 2023 10:12:02 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n17-20020a1c7211000000b003edf2dc7ca3sm5336285wmc.34.2023.03.24.10.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:12:02 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/4] mptcp: a couple of cleanups and improvements
Date:   Fri, 24 Mar 2023 18:11:29 +0100
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMLZHWQC/2WOwQqDMBBEf0X23AUTQ5X+SukhSde6B6PsRhHEf
 2/swUsPc3jM8JgdlIRJ4VHtILSy8pQKmFsFcfDpQ8jvwmBr29SNdbjMmoX8iIlyyZbxqkbWiD3
 5vAgpmrYLNtxN54yDogteCYP4FIdT+Oc5N7NQz9vvzhOu4nUcXzu7zDeoAAAA
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1284;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=BbPKd6tExiRa5BLYOz2a++7Meq/Ul3smPHqa4Li5/A4=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHdnh686gD+l9bRK9koOr/oHp/1mkc2lAmaFLW
 gnkYJucdF2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZB3Z4QAKCRD2t4JPQmmg
 c7wsD/47ZlVEZNdxxFu1HQrRrIwW0tYnosH/p9bpE62YreDa2HQTI60M7x+gOPOtF6uBLXwox/C
 lCJFcIsLbzpzUo/VIkd6SKEdDdjU0KqLB6270YQ74MZKwwbS6BzMKNZe9BH1yhcUAZGettPA901
 wSX3HF7XOMmWvGHz8bkVeMCGOLJ3V608TfPATeEWvseKst85lwtZuaXngAfLtjBwKJiwRljym/6
 oEwIhnbHsAL/JtiLRODn87sAtq602MVus+ajJQA3O+7G8mz+t1Ur5mKIAgAPuqTwG90UMk3QWIJ
 7dXaZLkwVCNJdVzDBvpfmjWmH3vpapJCv4Y/Yjm+j3QDCe1pS5ECx+EUStMyBo/n1dXa8y//Oij
 +m6CT+v1tWHPzoHHD8xOcx9GtlYd2LzFfP4wmzBkfPnVeQpSu5JbxMgsmFssZLzadu3BRgZRnoU
 iW5uz3nGTNLivAcxh6EJUMioICRVKhXZgbbLJmvN9HKXVe7FUzW4ZGwxNMI7mpQn32rBl0I9H7k
 fZUVzy2JbDMxPrAgbR/WqWQdPlE80bdt0boBQtz7+eB2zBzs2YQk9ez7cqGgogD9+dzKwS/DSLJ
 VeFqoRmRnLXY576j18qc4FvMoZnJhlgGsaauZt2WBFCYX4rT1Rq0kdH0yLrt3TgQ7HZvMnU+mGk
 GKgfavySdvrbo9w==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 removes an unneeded address copy in subflow_syn_recv_sock().

Patch 2 simplifies subflow_syn_recv_sock() to postpone some actions and
to avoid a bunch of conditionals.

Patch 3 stops reporting limits that are not taken into account when the
userspace PM is used.

Patch 4 adds a new test to validate that the 'subflows' field reported
by the kernel is correct. Such info can be retrieved via Netlink (e.g.
with ss) or getsockopt(SOL_MPTCP, MPTCP_INFO).

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Geliang Tang (1):
      selftests: mptcp: add mptcp_info tests

Matthieu Baerts (1):
      mptcp: do not fill info not used by the PM in used

Paolo Abeni (2):
      mptcp: avoid unneeded address copy
      mptcp: simplify subflow_syn_recv_sock()

 net/mptcp/sockopt.c                             | 20 +++++++----
 net/mptcp/subflow.c                             | 43 +++++++---------------
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 47 ++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 38 deletions(-)
---
base-commit: 323fe43cf9aef79159ba8937218a3f076bf505af
change-id: 20230324-upstream-net-next-20230324-misc-features-178b2b618414

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

