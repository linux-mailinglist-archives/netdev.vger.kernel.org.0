Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAAE32386E
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhBXIQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbhBXIPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:15:12 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EED1C06174A;
        Wed, 24 Feb 2021 00:14:31 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id c1so866905qtc.1;
        Wed, 24 Feb 2021 00:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j2K/SUFIFZUghbC0EKiKQeI7b0lM+QlWgzKTZl7hblc=;
        b=OsdFAKf+XYQ8sFpOuJLvRX0xJGJ9dHJby3UPS7NMn5ZuRB5Kvr9Dn5Voky5utLw4SF
         y//IQw3Wwi52qRyDw575rk25ug3BP/2se59yHMpny3d4kkNhNbPmnBDzR6LjOiupUoWN
         wK+IyAON+AbErlpCac6OzXLLaSTHRnEM/RsODmlvahKSgj2awy/pTTeXA6+hIsqXJxdG
         uPpIFBGYrZmIowRfE6XBFwT7oAvdbOiMgSqYSDZlpX5vGB+7q1mBDkm2WGgGRQYOSOR3
         Vu/N27ErEyXaFkghHtA9IAgUh1gFjQLYC5S0KAjFdvwQrU2xPGNqTS/ufnaVF1yQ3jEq
         h+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j2K/SUFIFZUghbC0EKiKQeI7b0lM+QlWgzKTZl7hblc=;
        b=J3Ld5eNO0JN3RZst2bGCIMW+VP/wYK4NUNPgfA4J9NrnBeNIkagB0SsMtcKb+KLLAP
         44nEp+6y49xKFcJ6Q6Lc4Z3Tmm1YbawhPcWFyeqvHxCLB4TPI1rXL4DMB2/z9IVyyZWl
         4QXQ6WscWa9TZBXhNv0bdIXbs25DGDGqkUt1sXxxwol32YCCLBh/bIxP6J5aktfzJhoi
         FGoj4e8eWJT1kP9DxkGp7QcdcRc6Ne6aR09wJ+iQojgKaajas1Ka/vx43xcR/bjAgvFW
         MzN2Pm+e5LfK05GPUnNfJ1X5e8MYbR+YGYgxLV9hRMHKUFXURffsGg6j92iInblMkL5E
         DZyA==
X-Gm-Message-State: AOAM530W0mQWahBxcn9y6ZIfUuUPMVCIu/bwkzGPrf0IPhjCgq0+ozRT
        Vx1io8MQpFwmgDVs1U2yM8w=
X-Google-Smtp-Source: ABdhPJyHUtBLDQfPQ2kie2WMPDvAcsw7flG3KZV5ITVSZr10QtTug50VBEp4zam9H0r+9Ok9klxuBg==
X-Received: by 2002:ac8:6a09:: with SMTP id t9mr13276421qtr.334.1614154470387;
        Wed, 24 Feb 2021 00:14:30 -0800 (PST)
Received: from localhost.localdomain ([156.146.55.69])
        by smtp.gmail.com with ESMTPSA id y15sm836878qth.52.2021.02.24.00.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 00:14:29 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        masahiroy@kernel.org, akpm@linux-foundation.org,
        valentin.schneider@arm.com, terrelln@fb.com, qperret@google.com,
        hannes@cmpxchg.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] init: Kconfig: Fix a spelling compier to compiler in the file init/Kconfig
Date:   Wed, 24 Feb 2021 13:44:09 +0530
Message-Id: <20210224081409.824278-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/compier/compiler/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index b77c60f8b963..739c3425777b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -19,7 +19,7 @@ config CC_VERSION_TEXT
 	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
 	    When the compiler is updated, Kconfig will be invoked.

-	  - Ensure full rebuild when the compier is updated
+	  - Ensure full rebuild when the compiler is updated
 	    include/linux/kconfig.h contains this option in the comment line so
 	    fixdep adds include/config/cc/version/text.h into the auto-generated
 	    dependency. When the compiler is updated, syncconfig will touch it
--
2.30.1

