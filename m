Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E563CC3F6
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 17:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbhGQPF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 11:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbhGQPFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 11:05:24 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBEDC06175F
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 08:02:27 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so7618025wmc.2
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 08:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fg1LMtio76TZBE+V6rtOm0zM6x8DkN+VarQiinH1Wgc=;
        b=faMTee1KLLK/gxHwB6xs8Qh7MSM+lyJqIllmAQzXHU9Rj+GaxvQ7gRItAlALDTfjbA
         U0LnhQZa9JnvVjfYEy0PDJ+3g736Bg58SGI88j3BPbsy64ZE7OZGlOlBmtGxEGKvxt9m
         wt1fBxB6f6nA/Hw1OfSj8WRTm/xjb2gIxTo8bAizXtnvhS9w/LZvcVStZsbpGJzE35M8
         X4H3gr3kPfYMSyVfMmha2c4pyVmM5LFl/tvJHlvfy+ohnIaiPN7WKPwlXD6GTvObQi8w
         yIUue95attXaHLhM5C0eGA7JFSY6NhbHLvuds0JDHwEaqiJHiz/UT1zhsB929cTP648H
         xMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fg1LMtio76TZBE+V6rtOm0zM6x8DkN+VarQiinH1Wgc=;
        b=mgRJ6fRdvKfCv7aPE6DYUJikgSEDCN9c/3K4HXtvC5mvvM/LeBgrxYYorLbai44NBb
         vMgaqtrGzsk2onhxE0LTRhS/tUmAQ8yxlo7C5YoP2VK1jPS+HwCU1dhQDs50AMI2waVQ
         tjN1fP2aQ3ZsNjCsrypB7DHsg/+kOeaOcZd4MbY5II/r31Yz6LVl2Esrfna2eFKwM0Ui
         NmkxOBlv8Y/cxR78lniBB9vk3+Ds7YzyEy99v+uhDjPFCptllJPI8FUKsyHHWGvIMhdZ
         yWVYT6n+cPb39wZhT3YJetUxlo7bWz4fb+IjSW1ORGUC4ECMzTdXOQNdYjRaQ7Gpv4qo
         urDg==
X-Gm-Message-State: AOAM533mK4x2SEtkxvgzpEEhNJvhpPw1NRRUjrvG+SWSf0LcBihGVbKu
        3sH/PfKkXNvHUJ4EmTacTYtOhA==
X-Google-Smtp-Source: ABdhPJzLE5PXsOdOG8/1nr+hubuiJIXWEW65BpE2t6FhngSXXLcApOIg0N3U6iYgEW844BU8Q8MWpA==
X-Received: by 2002:a7b:c955:: with SMTP id i21mr22579994wml.147.1626534145832;
        Sat, 17 Jul 2021 08:02:25 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id v9sm11372463wml.36.2021.07.17.08.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 08:02:25 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        stable@kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH 0/2] xfrm/compat: Fix xfrm_spdattr_type_t copying
Date:   Sat, 17 Jul 2021 16:02:20 +0100
Message-Id: <20210717150222.416329-1-dima@arista.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the fix for both 32=>64 and 64=>32 bit translators and a
selftest that reproduced the issue.

Big thanks to YueHaibing for fuzzing and reporting the issue,
I really appreciate it!

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: netdev@vger.kernel.org

Dmitry Safonov (2):
  net/xfrm/compat: Copy xfrm_spdattr_type_t atributes
  selftests/net/ipsec: Add test for xfrm_spdattr_type_t

 net/xfrm/xfrm_compat.c              |  49 ++++++++-
 tools/testing/selftests/net/ipsec.c | 165 +++++++++++++++++++++++++++-
 2 files changed, 207 insertions(+), 7 deletions(-)


base-commit: e73f0f0ee7541171d89f2e2491130c7771ba58d3
-- 
2.32.0

