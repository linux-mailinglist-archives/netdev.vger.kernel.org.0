Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD624224F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgHKWGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 18:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:06:06 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DB4C06174A;
        Tue, 11 Aug 2020 15:06:06 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f10so173639plj.8;
        Tue, 11 Aug 2020 15:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1h42nZtQ+tzgt4/mn8ojxC/D96UqAk3QrcGqtyvT3DQ=;
        b=oV0nsb3elNYaKzAw6+JUtkcJZGR5t8DoE9jW04ZGUpNUXLsI1ckj5XeZYOtI+hwnO2
         i0qqvPSVPTO99M50fQeUrRATQmk5UWIePgvy3sSgRL0nekZnmZJf/A5oIckvitmi0t89
         IvGJ6rGlMcvVQfMIIJ2ec2xQz2YOAksxan6AUG+U5NKY1MnSbMhu6v1zgACly3VfIIpi
         dmwrqAwDsHr+DEmU6V3VHvRToWsz2FbP1FS4pgHHSm84UakRCd0gWTP4ZJPKKrOUS1EP
         HOgYZmrOFPGRaEKvbkFIV45lpU42iA0K45SQhlaV0K4N+suVada+uRHFx47G6sB6b5Z6
         klVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1h42nZtQ+tzgt4/mn8ojxC/D96UqAk3QrcGqtyvT3DQ=;
        b=dJpHI2IqozSZTiDkjTyEF4iZJPK4uNYHS4Rw1RCRYIK/Y/JVkFRVhbHHR5rCbhu7CW
         FA8CNxfkmemfTJKvSK2pHwSDn5QgNWC7GfZm/l/Mp+lgMr61W+YZZPPNUS+nCp48uWtu
         qzvVcxPpanQeaZJ1vDBkR4EkDFVo1beIOEtGCfo35d+pj8PjNoypzLQi09UyFLajPDpW
         7udHs6cBwN3LFoynS646S04AqqdHXvkNb24pNRl4uSMZNAMBaTiztvMJap3DEca0mX4A
         jToMXloxFbazIPg7zHERMsjevfvv8qVozeOftNLZdYPng2SXt4NafrqYkFG2/LnWgjE/
         SyCg==
X-Gm-Message-State: AOAM53154RiHEfF9u6JLUWVjfXMlqZgxn4K87e2UO+RzNi3K7dizncY/
        rduq+fGyPHPdhuaFMGzTO24=
X-Google-Smtp-Source: ABdhPJzyI8Kn4YIfCws0fuvl9hcWvgxJm0o6hLTr4gEhB3FfJjGpRlgd0ipiCtf8qyHHUHDCXKKURg==
X-Received: by 2002:a17:90b:252:: with SMTP id fz18mr3132692pjb.48.1597183565809;
        Tue, 11 Aug 2020 15:06:05 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id gm9sm9143pjb.12.2020.08.11.15.05.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 15:06:05 -0700 (PDT)
Subject: [bpf PATCH v3 5/5] bpf,
 selftests: Add tests to sock_ops for loading sk
From:   John Fastabend <john.fastabend@gmail.com>
To:     songliubraving@fb.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 11 Aug 2020 15:05:53 -0700
Message-ID: <159718355325.4728.4163036953345999636.stgit@john-Precision-5820-Tower>
In-Reply-To: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
References: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to directly accesse sock_ops sk field. Then use it to
ensure a bad pointer access will fault if something goes wrong.
We do three tests:

The first test ensures when we read sock_ops sk pointer into the
same register that we don't fault as described earlier. Here r9
is chosen as the temp register.  The xlated code is,

  36: (7b) *(u64 *)(r1 +32) = r9
  37: (61) r9 = *(u32 *)(r1 +28)
  38: (15) if r9 == 0x0 goto pc+3
  39: (79) r9 = *(u64 *)(r1 +32)
  40: (79) r1 = *(u64 *)(r1 +0)
  41: (05) goto pc+1
  42: (79) r9 = *(u64 *)(r1 +32)

The second test ensures the temp register selection does not collide
with in-use register r9. Shown here r8 is chosen because r9 is the
sock_ops pointer. The xlated code is as follows,

  46: (7b) *(u64 *)(r9 +32) = r8
  47: (61) r8 = *(u32 *)(r9 +28)
  48: (15) if r8 == 0x0 goto pc+3
  49: (79) r8 = *(u64 *)(r9 +32)
  50: (79) r9 = *(u64 *)(r9 +0)
  51: (05) goto pc+1
  52: (79) r8 = *(u64 *)(r9 +32)

And finally, ensure we didn't break the base case where dst_reg does
not equal the source register,

  56: (61) r2 = *(u32 *)(r1 +28)
  57: (15) if r2 == 0x0 goto pc+1
  58: (79) r2 = *(u64 *)(r1 +0)

Notice it takes us an extra four instructions when src reg is the
same as dst reg. One to save the reg, two to restore depending on
the branch taken and a goto to jump over the second restore.

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index 6420b61..3e6912e 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -82,6 +82,27 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 		:: [skops] "r"(skops)
 		: "r9", "r8");
 
+	asm volatile (
+		"r1 = %[skops];\n"
+		"r1 = *(u64 *)(r1 +184);\n"
+		"if r1 == 0 goto +1;\n"
+		"r1 = *(u32 *)(r1 +4);\n"
+		:: [skops] "r"(skops):"r1");
+
+	asm volatile (
+		"r9 = %[skops];\n"
+		"r9 = *(u64 *)(r9 +184);\n"
+		"if r9 == 0 goto +1;\n"
+		"r9 = *(u32 *)(r9 +4);\n"
+		:: [skops] "r"(skops):"r9");
+
+	asm volatile (
+		"r1 = %[skops];\n"
+		"r2 = *(u64 *)(r1 +184);\n"
+		"if r2 == 0 goto +1;\n"
+		"r2 = *(u32 *)(r2 +4);\n"
+		:: [skops] "r"(skops):"r1", "r2");
+
 	op = (int) skops->op;
 
 	update_event_map(op);

