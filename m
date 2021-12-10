Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111AB470745
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244297AbhLJRhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbhLJRhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:07 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F05C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:32 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso10351593otj.1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WMqa61IMKQAN9nayBNaET9ogW/1IQBHwCkgxPK83A3s=;
        b=ZiinzdUTAUE4pW3+MikJK5J7ul2KgoWPeStbJcIb4f+ObGuAEAF6SL+SMRMxnX95h2
         iK95itksi/1uauaJqsD/x6K8C5VGuaLthvLoxR2o9n0klTF4wkcseELo0XrgDCp4GWPa
         /qWqBFehtViF2vhi7zRNmscMQ1Z5b/aeYT60o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMqa61IMKQAN9nayBNaET9ogW/1IQBHwCkgxPK83A3s=;
        b=0zJbRk7GNx4OeWc5uctkm7sxSuysPRH59LqLDUsUwweiQ5Raxiz6pal16jgUOfF8Hu
         kXmVz/5PFHmfdV8GWg5LmKrheIJklgKuaaMCJS53/aCHFLy7gfmzXbRBLebNyCBLgz7o
         DBR2Faki3UtFKXBpA2bjGqXuN2zm7a1tRXnavpKuO8WbUWuAAsyFDH9qhMOn2sq2CiAR
         ew1ceL+3nAlt4N5m1YrOQ8X5rLE6N+AUz91SMZrcxbZZV+l5O1VGd1y6EXMUUDYS18+x
         SrRdzKRiMScKqJfhpVW4RB7uWbj8BbN+MwhLbUCZKwFkEgpqorhXo/XLLD0/NC2L9he9
         Psig==
X-Gm-Message-State: AOAM5326f5nnHWN82zBO0n8qmA4UjOJ4AltThp34kySUUm0JNYUSSjii
        MpaX1IKlSa/LBg59Rw1CgMkANE2NBAcAlA==
X-Google-Smtp-Source: ABdhPJxs5UyjzAwtor6CH4V3zYGHQWLFyg/yw499Ss2tuG45t4WeD25Up32eMNTOXvKpzS2SfYHVjw==
X-Received: by 2002:a05:6830:1392:: with SMTP id d18mr11833207otq.374.1639157611625;
        Fri, 10 Dec 2021 09:33:31 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:31 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 06/12] selftests/landlock: remove ARRAY_SIZE define from common.h
Date:   Fri, 10 Dec 2021 10:33:16 -0700
Message-Id: <e86b9f3a050a919b90a41e42f369e8945210c2fb.1639156389.git.skhan@linuxfoundation.org>
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

Remove ARRAY_SIZE from common.h and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/landlock/common.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 20e2a9286d71..183b7e8e1b95 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -17,10 +17,6 @@
 
 #include "../kselftest_harness.h"
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
-
 /*
  * TEST_F_FORK() is useful when a test drop privileges but the corresponding
  * FIXTURE_TEARDOWN() requires them (e.g. to remove files from a directory
-- 
2.32.0

