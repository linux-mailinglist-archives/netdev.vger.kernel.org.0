Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A2423D2A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbhJFLtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhJFLto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F43CC061749;
        Wed,  6 Oct 2021 04:47:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id dj4so8832650edb.5;
        Wed, 06 Oct 2021 04:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EqSDl/mylFRuVIkcVfrD5wA64zlCr4ZZ5hRZ/Oux4fA=;
        b=IaqpZTdP79fj7hfFbwaekuNwmeyWRLdv+5VjfKPsre7hO+LLLYPsKw4xHkQPzjclp6
         04D8rDRw3JTak0DDydnBRbeiCiRt7qW5i1vON3wV9uL556K5eVsZGV107mv9rcLSw6qn
         YNKQAfborweo/JEedm3pQ2pqSasw/ibOThNSdc3XfbFLH4XuyJdIYb72e3W6AFlQP+w9
         mxCE6wbYay9aZ7MpkfAlPNcYw+nYsmE54sdpia5yd1bR7wTKUB490g/yxfwJobKNDS/m
         8JntMyTdsggXExfo65XwL1Cphc9gcn8IiJWCRbF2MLXAONVnLTBfwNiDhH1TNUGCe4Vx
         vCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EqSDl/mylFRuVIkcVfrD5wA64zlCr4ZZ5hRZ/Oux4fA=;
        b=tFsk6uLUng0Y0zypFFr1Nuzo1vwIOtW0YnVUIMWrkri5Kvn7I7kfgNjCtzAU9Qc539
         IV9crMm+RYC6sc8AEvkZwu6/It0EM/I6GTjyUJ5N89dEHn8JsgNSO/kmm8C2axNFR+pM
         HbQkDwHfyFMfLHmVuxvSBdQN6WtoTPUwatoDociV6hAtyNUehSP4sHF7v09nijJmE0PE
         wRyrez+xMr1UDacVbYSFeY9mn/Np8EBZigBFzCRrMzUkXT6PXh+23XmgBK0/KGNKgvBT
         lvdYXxbHKIgdJpU36+yKZektdTsihuEMbndrqpleqYsXfBDIYm5uydrSq1iThEjdYFIU
         BUQA==
X-Gm-Message-State: AOAM5326wx/B3YgfJ+OI+lUwcM6h49AnMElOym6ryUymHV+cdIYdBhi8
        dEDiJl8j+CnHQasgeXW9Ko0LRmOk45fVx0szrx8=
X-Google-Smtp-Source: ABdhPJwvRb3CrrV1nKJtM0pjbTIOvb5BgON9vKzQ8Fgu24g24KFsXiYiy8FmDAbLMoWdILHxcfPXiA==
X-Received: by 2002:a17:906:585a:: with SMTP id h26mr31179471ejs.31.1633520871024;
        Wed, 06 Oct 2021 04:47:51 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:50 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] selftests: Improve nettest and net/fcnal-test.sh
Date:   Wed,  6 Oct 2021 14:47:16 +0300
Message-Id: <cover.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a series of improvements to nettest and fcnal-test.sh from
tools/testing/selftests/net which make tests run faster. For me this
reduces the runtime from ~40minutes to ~5minutes and makes the tcp
tests very fast.

Some of the early commits are outright bugfixes.

The tests DO NOT pass perfectly for me on latest net-next/master but I
verified that the failures also happen without my changes. Here is the
list of failures:

TEST: ping local, VRF bind - VRF IP                                           [FAIL]
TEST: Raw socket bind to local address - VRF IP                               [FAIL]
TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [FAIL]
TEST: ping out, VRF bind - multicast IP                                       [FAIL]
TEST: TCP socket bind to out of scope local address - ns-A loopback IPv6      [FAIL]
TEST: TCP socket bind to VRF address with device bind - VRF IPv6              [FAIL]

Three of those were not tested by default before my changes, only with
explicit -t 'bind bind6'

This is related to my work on TCP-AO but there are no patch
dependencies
Link: https://lore.kernel.org/netdev/cover.1632240523.git.cdleonard@gmail.com/

Leonard Crestez (11):
  selftests: net/fcnal: Fix {ipv4,ipv6}_bind not run by default
  selftests: net/fcnal: Mark unknown -t or TESTS value as error
  selftests: net/fcnal: Non-zero exit on failures
  selftests: net/fcnal: Use accept_dad=0 to avoid setup sleep
  selftests: net/fcnal: kill_procs via spin instead of sleep
  selftests: net/fcnal: Do not capture do_run_cmd in verbose mode
  selftests: nettest: Implement -k to fork after bind or listen
  selftests: net/fcnal: Replace sleep after server start with -k
  selftests: nettest: Convert timeout to miliseconds
  selftests: nettest: Add NETTEST_CLIENT,SERVER}_TIMEOUT envvars
  selftests: net/fcnal: Reduce client timeout

 tools/testing/selftests/net/fcnal-test.sh | 710 ++++++++--------------
 tools/testing/selftests/net/nettest.c     | 134 +++-
 2 files changed, 378 insertions(+), 466 deletions(-)


base-commit: 0693b27644f04852e46f7f034e3143992b658869
-- 
2.25.1

