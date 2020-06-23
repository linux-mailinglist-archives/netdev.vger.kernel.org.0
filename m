Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2643B20576B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732658AbgFWQmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732174AbgFWQmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:42:39 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3DDC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:42:38 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h30so14394342qtb.7
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zl+PzJjccgQ/z2IEdEeYMiws9NGR4cJmTEy3MFLmC3o=;
        b=Du2IZQVww527r+DkfvLwjzL1rLzDjXpQwn91wkmvUrKnk31COi3wf75uaCGRrhnnGT
         cZtT9QEs5+WAsDy2Ws+B4BBRNf8YRXN+wx28A81PgSW5nfRRKHGEunysMDByIjthTpU1
         EaG+wzyDLq6vv8QEQnsq9NFMy+Ermx4r6wlkGoIVUpdvXVYM35WHVewJAvwnDJayvvIJ
         LNC+uYqFb6WOk68KVwUZMOQ47eUWbRT7EAHJLRpH8tFbqnw9UwX9DGe3NzzMS8hv6L01
         SxMsXa5G4ntXvJFJlJn6ilR1MO/d8wM/CtsQIbsORt7+rG13EysINazUWFLS/0Y592H1
         hRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zl+PzJjccgQ/z2IEdEeYMiws9NGR4cJmTEy3MFLmC3o=;
        b=ZpIFzKyRVN6ZIrteCjFR4zrRldItsp7KRQ9dM4ie0TzBdLY1EaNHAMrTE3ld8nzE1D
         6piN/nq6T7PyBbx+6BsFjmz4iqFMZ0DRYT1sWe0w5c7aHawrYF/exafs3ufVXyKCVNQM
         Gi5x+zEUk3YUkVJN55XGIt6ZQdM21rcSml9Z6/yJ9VFO9sFgHC9ukgOg5WjpMT6Mje9G
         OCxjOELaOP4LiG10XaG8b75og5C78fIoLy427UDgAeNFLbEOJV3jovUehKHXtewB7Muz
         ur2Ymz6LLthuhLKXZAt5SmUseRfc1ozn3sZckHODcCqzzFpoEzvpaRnepG8y5unI00/G
         VE+g==
X-Gm-Message-State: AOAM53350VpMH72WJBMwb5rGN8ZmyV0SU/ByaZbxKoyNpp3FkoFLNSXz
        RQfw7THyeQnD3ZgL7LwIVfL4Fop/fBRz
X-Google-Smtp-Source: ABdhPJwQGXprOfL8jqRrhCa93rf7sj1+uuw00sukDTOJcaV6twqdQ/5psZBymPf6HUwvw6+AZPA8V/mGl64c
X-Received: by 2002:a0c:bd12:: with SMTP id m18mr16597999qvg.178.1592930557012;
 Tue, 23 Jun 2020 09:42:37 -0700 (PDT)
Date:   Tue, 23 Jun 2020 09:42:31 -0700
Message-Id: <20200623164232.175846-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH v2 net-next 1/2] indirect_call_wrapper: extend indirect
 wrapper to support up to 4 calls
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many places where 2 annotations are not enough. This patch
adds INDIRECT_CALL_3 and INDIRECT_CALL_4 to cover such cases.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/linux/indirect_call_wrapper.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index 00d7e8e919c6..54c02c84906a 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -23,6 +23,16 @@
 		likely(f == f2) ? f2(__VA_ARGS__) :			\
 				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
 	})
+#define INDIRECT_CALL_3(f, f3, f2, f1, ...)					\
+	({									\
+		likely(f == f3) ? f3(__VA_ARGS__) :				\
+				  INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__);	\
+	})
+#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)					\
+	({									\
+		likely(f == f4) ? f4(__VA_ARGS__) :				\
+				  INDIRECT_CALL_3(f, f3, f2, f1, __VA_ARGS__);	\
+	})
 
 #define INDIRECT_CALLABLE_DECLARE(f)	f
 #define INDIRECT_CALLABLE_SCOPE
@@ -30,6 +40,8 @@
 #else
 #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALL_2(f, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_3(f, f3, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALLABLE_DECLARE(f)
 #define INDIRECT_CALLABLE_SCOPE		static
 #endif
-- 
2.27.0.111.gc72c7da667-goog

