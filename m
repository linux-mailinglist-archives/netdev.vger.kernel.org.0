Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243F4557EC
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfFYTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:42:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45230 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbfFYTmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so19187634wre.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z2q/9DY/eMlLakYA2goJPIRtdbZUH+0KxlPnLmYNTOY=;
        b=S6FLBGyhiUGRPfx8AIEOgrRMwJ0Zlq/FBeyMZ0NVbAecl9fre+tB9eolB83gg1d8Fh
         UlmK2b4GOhZ97HObqFlkwkfXZfsB0ImP+WPsm1elSj1LTHnsYfiGttSSjEkDiFVdmrmE
         fgoi5c6CiMiOHOLoQSAcHEE+eYN9VSUR6pLh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z2q/9DY/eMlLakYA2goJPIRtdbZUH+0KxlPnLmYNTOY=;
        b=ER1QB1IA3wROHM0KRs0/Y8ndb1rBv5/zBIGsKHb66La5O45Ju715JQ22L4rV6+Jp+7
         oPFXnt2gytZ/za1pN1nzrlNELEo5Qn+scjPYtXsY8yitynPSVfO0BO0+jUWRXE5FlsvD
         HskMODAhIQNPMUHv2ltj+peEyrqps5h6hM9HE8BZDyzOyI6vr6sNnN87wVD/5W6XM/wo
         kxxBaDOLri7ojCIg5hbGVneuK5EM5Hcn9oQW961wT7hq/8zr2JMsQ0IOfrmhmLqvcEHZ
         be3cMDe0vfeOCjQJbD29AcmvrTBXgHy+GcvP4PaGcV2h2cYzyi1OCVL5+TdWQSj5p4i6
         SyKQ==
X-Gm-Message-State: APjAAAVny+KUyKPV/vcwsHB50DqigayZQU6OsuhKBydKQz6eIUq58yAa
        DraLog1G8KcLQWGh3Jj4qLVjBnVmN1shsQ==
X-Google-Smtp-Source: APXvYqxARSUICUN82WqUy1X4NpQ/y8QyvqnKc7YfYnnYme1U189+Tncy8JdzCrbo/FkmDrNfs4SIog==
X-Received: by 2002:adf:81c8:: with SMTP id 66mr111481467wra.261.1561491770947;
        Tue, 25 Jun 2019 12:42:50 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:50 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     netdev@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v2 06/10] tools headers: Adopt compiletime_assert from kernel sources
Date:   Tue, 25 Jun 2019 21:42:11 +0200
Message-Id: <20190625194215.14927-7-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625194215.14927-1-krzesimir@kinvolk.io>
References: <20190625194215.14927-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will come in handy to verify that the hardcoded size of the
context data in bpf_test struct is high enough to hold some struct.

Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/include/linux/compiler.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/include/linux/compiler.h b/tools/include/linux/compiler.h
index 1827c2f973f9..b4e97751000a 100644
--- a/tools/include/linux/compiler.h
+++ b/tools/include/linux/compiler.h
@@ -172,4 +172,32 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __fallthrough
 #endif
 
+
+#ifdef __OPTIMIZE__
+# define __compiletime_assert(condition, msg, prefix, suffix)		\
+	do {								\
+		extern void prefix ## suffix(void) __compiletime_error(msg); \
+		if (!(condition))					\
+			prefix ## suffix();				\
+	} while (0)
+#else
+# define __compiletime_assert(condition, msg, prefix, suffix) do { } while (0)
+#endif
+
+#define _compiletime_assert(condition, msg, prefix, suffix) \
+	__compiletime_assert(condition, msg, prefix, suffix)
+
+/**
+ * compiletime_assert - break build and emit msg if condition is false
+ * @condition: a compile-time constant condition to check
+ * @msg:       a message to emit if condition is false
+ *
+ * In tradition of POSIX assert, this macro will break the build if the
+ * supplied condition is *false*, emitting the supplied error message if the
+ * compiler has support to do so.
+ */
+#define compiletime_assert(condition, msg) \
+	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+
+
 #endif /* _TOOLS_LINUX_COMPILER_H */
-- 
2.20.1

