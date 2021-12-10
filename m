Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B799147073F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhLJRhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244706AbhLJRhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:03 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF1EC0617A2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:28 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id be32so14113370oib.11
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Om7A8iJx3nmhRt21+GcSVSh1CLYidC/pJOApyfAW7NA=;
        b=SjV4lPhUdKrmpRTjTbfve+d5B769d3IL84XjeCyYyIxveR1xklcF8EADqlliDHUpYJ
         Frpg+DqzjkTlT32YzOqef4iMfY3Joj/P40H2wHvWyCUffJ0BIvLT3lAq9spBCpTV9VqW
         fhqvSvrGrkeHAyMG2Gr2cDT7Go5Db+PPVzNi8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Om7A8iJx3nmhRt21+GcSVSh1CLYidC/pJOApyfAW7NA=;
        b=QqoH2xAxIh/juyoZhaA8jaAhpZnCJFJP72vPQV4MPjCMz8ggtCrrt+6sOnOiDhM22S
         t/A6PxyFbOSSsNEXR6eg0VmZXrMfVS9EQmDG9tJE9Ewffvj8VgP/8ADBSfYLl/rFS9rh
         FD5a6IauC2SGiJGYIYF+dNg/B689XMkwpnl8pPEMr9mTM1QIAMrB53bpkMlm7RUf10Pi
         r+7aXGZCDW7b9Os6EEdKkMVt17qFwooPQb0+3sWnip/iEgc+sWmNao/E8GvzsaCgOJJh
         a1gWOKZs9Am2y8qIBJghVG8TdfZ3KYpE0p6FdMTUJHT5y/H8AsN2/vz8XQ7jYvx0lJCp
         SE/Q==
X-Gm-Message-State: AOAM532gK2bJjbN2X5vUextMOUs0rn6UU8hXd1DML2Gqfbm3Gm1xvv+p
        YB3yHv8hJQT44GRNSvnCQ22RPA==
X-Google-Smtp-Source: ABdhPJw1xkTM0IGWbm2xBQvRbX572S/iV1SuoJVNLe1QtOfW6SfMXVYKCvQz8AqfVuAHR9tlpezb4g==
X-Received: by 2002:a05:6808:1a02:: with SMTP id bk2mr13567633oib.52.1639157607755;
        Fri, 10 Dec 2021 09:33:27 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:27 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 02/12] selftests/arm64: remove ARRAY_SIZE define from vec-syscfg.c
Date:   Fri, 10 Dec 2021 10:33:12 -0700
Message-Id: <7f6d7252af5c8efda140b6b5f626b9e5a267016a.1639156389.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1639156389.git.skhan@linuxfoundation.org>
References: <cover.1639156389.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARRAY_SIZE is defined in several selftests. Remove definitions from
individual test files and include header file for the define instead.
ARRAY_SIZE define is added in a separate patch to prepare for this
change.

Remove ARRAY_SIZE from vec-syscfg.c and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/arm64/fp/vec-syscfg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/fp/vec-syscfg.c b/tools/testing/selftests/arm64/fp/vec-syscfg.c
index 272b888e018e..c90658811a83 100644
--- a/tools/testing/selftests/arm64/fp/vec-syscfg.c
+++ b/tools/testing/selftests/arm64/fp/vec-syscfg.c
@@ -21,8 +21,6 @@
 #include "../../kselftest.h"
 #include "rdvl.h"
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
-
 #define ARCH_MIN_VL SVE_VL_MIN
 
 struct vec_data {
-- 
2.32.0

