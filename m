Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5C46E2743
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDNPrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjDNPrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:47:23 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A819A6E85
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:47:21 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r15so1057354wmo.1
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 08:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681487240; x=1684079240;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQHeRjYfYyZKLC7iOU+t3/2myzlwDXi7gyuW2s6XLYg=;
        b=E7YL611X2p8DiYECVw3eqMssKwtoziCP0uU/lrSu7JXRYXm1AuMwJ5KUUrmx7OsRKf
         eR+ABZAIv/I2n/OOBXy0Hx9DyqOPxNPQeQkUDF7EBk8H33O7hA5dAmixe6s0X8oBoJPs
         os4XREsxuRa8732uIT6eUUSldmUMuxZjJopSF5mgr3wy6L8Ikd6swA+PAdvLw6apEIDN
         uNm/65XFLRY8LgjmVqt587oXqQ4GwrJjqv71B7IcHpRaVnBtfMdH71p/yx67k6uVbtzV
         dsfZ3TiL6P6YxaiWy/4d26ORWZXxSigZqQfb3DaOqeim0YJ47aSTU1JJRJrt4sNA3D0g
         OL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487240; x=1684079240;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQHeRjYfYyZKLC7iOU+t3/2myzlwDXi7gyuW2s6XLYg=;
        b=Qfqng54qh+6YqOULVfTH9l7JJjn6wLcBvQjQVCl0bgRXzDv4a2FrCam61Np21WWb/E
         ++lpx5e+kBPk45PKF4D4tex1x8cLV/qk61ozc1yuoah7WhFutetDzc0w6dd6Rni6izLo
         YIlJsvIEOolsuhDL7QHKp5Y+qb1PxICx3UWLpGM5nGK1ODWH7vRCK0PM5PDkYxp8X6dl
         OkM245+uCJG3YPWnO5sdEq94XrMmNEaqoW7wNpF6uhFDS/zdx8A0W+5D4krOV24mmeKG
         aKnmodXUseq0L52EIlsE0jrTHG/v0DdBT6YGsrmp9kjgCazNA0pxNmgi9fv0l+Vw+Dnq
         nsrg==
X-Gm-Message-State: AAQBX9d3/m1XZ10mE/eqgNaJyezOm02CIlhTCBed18ljd0UJctTRgQ+a
        /oTIEp3b9ySlTWzwXqy3YjH+3g==
X-Google-Smtp-Source: AKy350Y+j9BBgDLOwe0TGh3X1XiTBxUkqX9hbVre77YNH2cDwyG+t4sASNgSlkjqJZEg8k9V7UQLUQ==
X-Received: by 2002:a05:600c:d8:b0:3f0:49a3:586c with SMTP id u24-20020a05600c00d800b003f049a3586cmr4871539wmm.0.1681487240049;
        Fri, 14 Apr 2023 08:47:20 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id x2-20020a05600c21c200b003f149715cb6sm1034298wmj.10.2023.04.14.08.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:47:19 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/5] mptcp: various small cleanups
Date:   Fri, 14 Apr 2023 17:47:05 +0200
Message-Id: <20230414-upstream-net-next-20230414-mptcp-small-cleanups-v1-0-5aa4a2e05cf2@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHp1OWQC/z2OwQrCMBBEf6Xs2cWkFjH+ivSwiasNJDFkoxRK/
 91UqIc5DDO8mQWEi2eBa7dA4Y8X/0rN6EMHbqL0ZPT35qFX/UkNesB3llqYIiauTXPFfxRzdRk
 lUgjoAlNqXdTOkrmcjVFWQ6NaEkZbKLlp49bjDtzCXPjh59+dG+wDMK7rFwFSY9ioAAAA
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Geliang Tang <geliang.tang@suse.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Mat Martineau <martineau@kernel.org>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1414;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=hzQyCztsyV7eUv+6le+ymX20yjt7QV+7CGpvziAa0/w=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkOXWGk1xDrZ+YIHe67TANc0sdiNkrs4AoXMPEr
 oiXVCD1YGSJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDl1hgAKCRD2t4JPQmmg
 c2bkEACfkbVh8bIXWdGMzroWYB7SGf68GayVCP5g0GuwBKxmPLyeSEMgL7RY3arBYnjXs+stwOS
 BbSkdcsqt6TppLoB2g6VOHcSRPG00F9Z3b37Cz1ScbwoX53zAGV+803fhAcsW0tCfC8odY75FmM
 fPA3YUEyG+eEPzQaWXRhZerjhmB99cHAEBKaFaPe8M+7ZY2B0gGzgHqE18qEjfSDOcd7iGyMLIp
 osUW2Zoay/kTQjBwQKcxLBSgNi3HzK+gy4kgduNKy7nC3PiT/n6vTen8lGPtP7h2q7jF72Mn6yC
 IJMGTvAXDbdXil4Nj12hwvMuIGXbsnn0y3WoGhP2VZNSn0VTLgupY7aFR/lsTiIrCQ9XVO0uCwJ
 AwZW73ov/U4gP12sLtJWxuWazx0NdhHRCS5IZ3/eFlfY2YV/mEv7j3smaruFU+00wV3Hx2Nkg5k
 sHhmzEVjwzH9TNQD97nZjKMk5Q0QriQcPaVirukeyFIMvMWs1LM8Gs4tDNNd5mfCqH+GXH99XuV
 RRuFzQO1b2DV1Dub16zsvxcB1id89c8A8ng3Qec7kYGKI1kYojr/4aNXd5lT/TzoFf24AIrZ8cl
 5WnGgNPgbSlRDwi/MP1RUDUwKTN7OGEMEytOnMZSoV9FV8ttZ63SzzPoh1GfdARfmSj9P1lgD8y
 VJaywoTzqZYTTcw==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 makes a function static because it is only used in one file.

Patch 2 adds info about the git trees we use to help occasional devs.

Patch 3 removes an unused variable.

Patch 4 removes duplicated entries from the help menu of a tool used in
MPTCP selftests.

Patch 5 removes some ShellCheck warnings in mptcp_join.sh selftest.

Only very minor improvements then.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Geliang Tang (1):
      mptcp: make userspace_pm_append_new_local_addr static

Matthieu Baerts (4):
      MAINTAINERS: add git trees for MPTCP
      mptcp: remove unused 'remaining' variable
      selftests: mptcp: remove duplicated entries in usage
      selftests: mptcp: join: fix ShellCheck warnings

 MAINTAINERS                                       |  2 ++
 net/mptcp/options.c                               |  7 ++-----
 net/mptcp/pm_userspace.c                          |  4 ++--
 net/mptcp/protocol.h                              |  2 --
 tools/testing/selftests/net/mptcp/mptcp_connect.c |  8 ++++----
 tools/testing/selftests/net/mptcp/mptcp_join.sh   | 10 ++++++++--
 6 files changed, 18 insertions(+), 15 deletions(-)
---
base-commit: c11d2e718c792468e67389b506451eddf26c2dac
change-id: 20230414-upstream-net-next-20230414-mptcp-small-cleanups-1cba986990b1

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

