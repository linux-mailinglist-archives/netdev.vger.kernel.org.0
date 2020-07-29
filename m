Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BF1232299
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgG2QYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgG2QYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:24:21 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284AEC061794;
        Wed, 29 Jul 2020 09:24:21 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so19913895iln.1;
        Wed, 29 Jul 2020 09:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AH3iVlmefZurpYiADR1cpY1Cx4jU1ARkIkj0P/RSa6k=;
        b=ea27eZfnZx1t88la2qgJLwz9M8LwnZ8V8fyohWuGO5qxoLzr7oAdStnkuL/qVAl8vY
         wwlmK+MrtFIlaCyuAsToi75m2X4kjlw3vUainV0XL/1acLYoz60qrcwuXZWkkbWLnvJa
         jjo52SZDfrZi5jNTwgoLqOcPglI1MIjS6NgmZx+xoWphv2ZmyfhCZ6HvGe7cOFTre36l
         zX/1N7SnqI/Dv8eELrjDtiFiWbuPwkmiQflVJI9SpbCALExbnw1k67hsHOIDDV3mO79d
         q+z8ZbMLp9rUGyb+pgSIuCabTTkdq37UxB0cgrFxrY07IncA5xHlSM/bX8/AaqNbqSuM
         CyGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AH3iVlmefZurpYiADR1cpY1Cx4jU1ARkIkj0P/RSa6k=;
        b=HMJlj2lpaSEiMATzA028lOGIygAiqUjO9BVlFSWNrRPMLvof0oXY6M9MTOxMrYf12D
         mpt7DgoMb937x30Se7QWcmuzZHewMXqzKW2jd15V9UfkLjXIs0KWDG2lVYb7tP3X6/fv
         PSryvRoWRL9u7i9tmX+LOgArMzVyGXH/Nvfhawc4Qi6xooBMRJsqeFjgV0pupIjrvOCs
         yI5QhFdEC8RV99dGN7d8tl3BsfaFCatd7qSv0j8CO7kf9HOilf88pDNNj9iZhct4g51C
         sRGdCm6s4WyFB18lR4LwhD3ncbv6YZ4it1FpwQ7rdhkWj8FSTdLSQDUhiLLGrsFPoKJT
         ICxw==
X-Gm-Message-State: AOAM5313c5QcXCMHoC5RqS8lH3YhSjhcPyNEgmx+xWhpRYNPFhp/yvfS
        GKdPQwSYWWYDYmbt8MemCho=
X-Google-Smtp-Source: ABdhPJweoMTl+OEFKIl3Z5CbnjakEdO4G0E9KwZqY0B2r7BUOf4+EthnjEp+NWercFu3nJRU0rUopg==
X-Received: by 2002:a92:c530:: with SMTP id m16mr36096522ili.300.1596039860026;
        Wed, 29 Jul 2020 09:24:20 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a5sm1182255iol.39.2020.07.29.09.24.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 09:24:19 -0700 (PDT)
Subject: [bpf PATCH v2 5/5] bpf,
 selftests: Add tests to sock_ops for loading sk
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 29 Jul 2020 09:24:07 -0700
Message-ID: <159603984765.4454.3932218162163081929.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
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

