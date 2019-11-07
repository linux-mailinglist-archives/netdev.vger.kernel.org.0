Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86D6F2E83
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 13:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbfKGMwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 07:52:37 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41880 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbfKGMwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 07:52:37 -0500
Received: by mail-lf1-f66.google.com with SMTP id j14so1501234lfb.8
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 04:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p+MIjxw4i3V/EkbtjtpDD2n0kK+NAJPN/6KwZf8q01c=;
        b=F4Gi+sAjPQQ2+8UNWymnpTCOTFpwmm1zRyk/S8HolMPz56GiHuHMk8RFNCyRpWDK1C
         aGutIV2F7vdfZLm0aDQehgWXCJmfU8CW6UpQHW5Li3V3sjS9B5cjo/pg80OXkp95ySdI
         t//LwHG4Pqx6qIOQ7X/cf5m5NIUwTMAm0MH7klgJ4h0XnvqU4d4ennnvZmFMX6TZUS1h
         CCDpWO8q07QYSh3VRHtq9fSQSJpROX5V4qH7VmV/MmEnCsFyXyRZV4BOnpOrReBZCYlh
         VM9nd7/OiNOAYI/QIREovNPbtPjuktHpXNppNFgZVk50rpxMZB/uXR0G1Y0BnoU2jJ0n
         EKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p+MIjxw4i3V/EkbtjtpDD2n0kK+NAJPN/6KwZf8q01c=;
        b=QOFMQzxGeyXRPi6IgT39eS4uxn1ugsbAZwJ8UBSOYWqS/dBRJlIUvF8X7c3X3csxP9
         +Hf+fZKvcwFpNec3sPhgkTrYpVu9dyTKDr6JnYtzfg4ieBLxwTcpxzDneyegglinAp3c
         hzx1P4hPzIwvUGLKhdGkH69U/GTIbufCQF9a8HOg99D+7vGW8TtWNIxpV6TyJXn5QkYn
         J0FGfZBQv5csZAtFn9MHiVe0OSSSPRO6GdbSAdPtKvJqHavT+ib2E2ljadMxftIOEa70
         RKS2Z21CfooNzp8KOLuqpnkXPagR6NjN9kRFoyLT5raMjtUqRI90yhfTCer8Q4TLHdlB
         FIdQ==
X-Gm-Message-State: APjAAAWPdtWJOscQ4WQs1qkz9s7bDOqU7rP8Pvz2SicPQ/lG7vs7dOoF
        Lco6xkNIqGYAmmAdul6POai4Tg==
X-Google-Smtp-Source: APXvYqyqZ7DmditMphihw8mIXDe5TLQUgJ0wqBa8wqcZsWt2IQB6JBlXAEv5XDwg7Wm+W4WRNiRQqw==
X-Received: by 2002:a19:ca13:: with SMTP id a19mr2297916lfg.133.1573131154733;
        Thu, 07 Nov 2019 04:52:34 -0800 (PST)
Received: from localhost (c-413e70d5.07-21-73746f28.bbcust.telenor.se. [213.112.62.65])
        by smtp.gmail.com with ESMTPSA id z22sm853118ljm.92.2019.11.07.04.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 04:52:34 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah@kernel.org, Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 1/2] selftests: bpf: test_lwt_ip_encap: add missing object file to TEST_FILES
Date:   Thu,  7 Nov 2019 13:52:23 +0100
Message-Id: <20191107125224.29616-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When installing kselftests to its own directory and running the
test_lwt_ip_encap.sh it will complain that test_lwt_ip_encap.o can't be
find.

$ ./test_lwt_ip_encap.sh
starting egress IPv4 encap test
Error opening object test_lwt_ip_encap.o: No such file or directory
Object hashing failed!
Cannot initialize ELF context!
Failed to parse eBPF program: Invalid argument

Rework to add test_lwt_ip_encap.o to TEST_FILES so the object file gets
installed when installing kselftest.

Fixes: 74b5a5968fe8 ("selftests/bpf: Replace test_progs and test_maps w/ general rule")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index b334a6db15c1..cc09b5df9403 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -38,7 +38,7 @@ TEST_GEN_PROGS += test_progs-bpf_gcc
 endif
 
 TEST_GEN_FILES =
-TEST_FILES =
+TEST_FILES = test_lwt_ip_encap.o
 
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
-- 
2.20.1

