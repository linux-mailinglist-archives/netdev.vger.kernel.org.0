Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE956441E80
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhKAQir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhKAQi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 12:38:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF3C061203;
        Mon,  1 Nov 2021 09:35:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id f4so8055137edx.12;
        Mon, 01 Nov 2021 09:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JI8YrRsfLzLwAqOBlEu7dUg/mczyENBF75WDCisqFVU=;
        b=pbv7QoTag2cmAvXVblwBn18Cgf+xfKjy7Xl/FoTaHX4YyJgJs1J0YcafkeG/rPc2y6
         zTT9KqzW0JFWSy5YJrSYC7At5G1fvuGAdwrXVokZSNJs1w2w0Y0orh2V8yI5QtQsD6Wh
         3S2SghGPcXMwhkqBg6wp9J3IEMDJb5yVe0ZqkpcEcxbdqZ2ESWHVpublgcM7tULnOaDU
         rgec3ORjb2pjaTlkU5P//e+y91IH8F8LW+GmNei8JAy5YEWm2DWy9QuR8ZuoPdYakAwP
         geKGQUECeqdYBb1nzXXj7n/+akG9QUzRey+jGseDzzDUCiu6nSpvt3i/XT/xjqLj44Xe
         og/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JI8YrRsfLzLwAqOBlEu7dUg/mczyENBF75WDCisqFVU=;
        b=2YIjm9b0W9qiowdsn1RsLcslGOivwqQJSBttysBYIL7Z8PN4fiIE6r1FTLGeQtyi8B
         PQt+dSYv9Rpcn04Qyt8+HjxnfCbu1lH+koj7Ni8KfFcT2KzN3SWYZ8AXAbgc3ly+JgM9
         os0eyzNl3qF4Dft/7t3Cuy7+I+e5uKtBmxI9LWCDuG8IaqdFOVPC7qOo4WA2Zi2a95aA
         t/hfhjPb67TDJ2amIhXDtUmwZMD4DJNqm2VIpneh4F9f8HtmfNJ9f+RTFn1+loRe0D0Q
         N9+ZBmUcOsL3yQtP2p8nVXZfESArCmYP8Z1cnivbrudkhqJJgf5e5eGXHE5Iy45U9Vpe
         JD6A==
X-Gm-Message-State: AOAM532HE+0Q0oiyPwWorWaRmH41HUXiyTSzEdF58w58ZRqFHjtBJvNu
        mkXo21EB1izRvn/WTtmQVPotWFtiC2Le7q0w
X-Google-Smtp-Source: ABdhPJzAii23DhSguYlO7T2uZC4CVcK37lU5rR4cy4U4tlxSrtjx02py3lzoPfo+gI972MGDNwGCXw==
X-Received: by 2002:a17:907:9690:: with SMTP id hd16mr5862862ejc.297.1635784553937;
        Mon, 01 Nov 2021 09:35:53 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:f5f:2085:7f25:17c])
        by smtp.gmail.com with ESMTPSA id f25sm4124583edv.90.2021.11.01.09.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:35:53 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/25] selftests: tcp_authopt: Implement SNE in python
Date:   Mon,  1 Nov 2021 18:34:50 +0200
Message-Id: <ce875c2c65a2bdc181bd2a4b38d5dee45d49ab66.1635784253.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
References: <cover.1635784253.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation and tests for Sequence Number Extension.

One implementation is based on an IETF draft:
https://datatracker.ietf.org/doc/draft-touch-sne/

The linux implementation is simpler and doesn't require additional
flags, it just relies on standard before/after macros.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt/tcp_authopt_test/sne_alg.py   | 111 ++++++++++++++++++
 .../tcp_authopt_test/test_sne_alg.py          |  96 +++++++++++++++
 2 files changed, 207 insertions(+)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/sne_alg.py
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne_alg.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sne_alg.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sne_alg.py
new file mode 100644
index 000000000000..252356dc87a4
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/sne_alg.py
@@ -0,0 +1,111 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Python implementation of SNE algorithms"""
+
+
+def distance(x, y):
+    if x < y:
+        return y - x
+    else:
+        return x - y
+
+
+class SequenceNumberExtender:
+    """Based on https://datatracker.ietf.org/doc/draft-touch-sne/"""
+
+    sne: int = 0
+    sne_flag: int = 1
+    prev_seq: int = 0
+
+    def calc(self, seq):
+        """Update internal state and return SNE for certain SEQ"""
+        # use current SNE to start
+        result = self.sne
+
+        # both in same SNE range?
+        if distance(seq, self.prev_seq) < 0x80000000:
+            # jumps fwd over N/2?
+            if seq >= 0x80000000 and self.prev_seq < 0x80000000:
+                self.sne_flag = 0
+            # move prev forward if needed
+            self.prev_seq = max(seq, self.prev_seq)
+        # both in diff SNE ranges?
+        else:
+            # jumps forward over zero?
+            if seq < 0x80000000:
+                # update prev
+                self.prev_seq = seq
+                # first jump over zero? (wrap)
+                if self.sne_flag == 0:
+                    # set flag so we increment once
+                    self.sne_flag = 1
+                    # increment window
+                    self.sne = self.sne + 1
+                    # use updated SNE value
+                    result = self.sne
+            # jump backward over zero?
+            else:
+                # use pre-rollover SNE value
+                result = self.sne - 1
+
+        return result
+
+
+class SequenceNumberExtenderRFC:
+    """Based on sample code in original RFC5925 document"""
+
+    sne: int = 0
+    sne_flag: int = 1
+    prev_seq: int = 0
+
+    def calc(self, seq):
+        """Update internal state and return SNE for certain SEQ"""
+        # set the flag when the SEG.SEQ first rolls over
+        if self.sne_flag == 0 and self.prev_seq > 0x7FFFFFFF and seq < 0x7FFFFFFF:
+            self.sne = self.sne + 1
+            self.sne_flag = 1
+        # decide which SNE to use after incremented
+        if self.sne_flag and seq > 0x7FFFFFFF:
+            # use the pre-increment value
+            sne = self.sne - 1
+        else:
+            # use the current value
+            sne = self.sne
+        # reset the flag in the *middle* of the window
+        if self.prev_seq < 0x7FFFFFFF and seq > 0x7FFFFFFF:
+            self.sne_flag = 0
+        # save the current SEQ for the next time through the code
+        self.prev_seq = seq
+
+        return sne
+
+
+def tcp_seq_before(a, b) -> bool:
+    return ((a - b) & 0xFFFFFFFF) > 0x80000000
+
+
+def tcp_seq_after(a, b) -> bool:
+    return tcp_seq_before(a, b)
+
+
+class SequenceNumberExtenderLinux:
+    """Based on linux implementation and with no extra flags"""
+
+    sne: int = 0
+    prev_seq: int = 0
+
+    def reset(self, seq, sne=0):
+        self.prev_seq = seq
+        self.sne = sne
+
+    def calc(self, seq, update=True):
+        sne = self.sne
+        if tcp_seq_before(seq, self.prev_seq):
+            if seq > self.prev_seq:
+                sne -= 1
+        else:
+            if seq < self.prev_seq:
+                sne += 1
+        if update and tcp_seq_before(self.prev_seq, seq):
+            self.prev_seq = seq
+            self.sne = sne
+        return sne
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne_alg.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne_alg.py
new file mode 100644
index 000000000000..9b74873cff4a
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_sne_alg.py
@@ -0,0 +1,96 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test SNE algorithm implementations"""
+
+import logging
+
+import pytest
+
+from .sne_alg import (
+    SequenceNumberExtender,
+    SequenceNumberExtenderLinux,
+    SequenceNumberExtenderRFC,
+)
+
+logger = logging.getLogger(__name__)
+
+
+# Data from https://datatracker.ietf.org/doc/draft-touch-sne/
+_SNE_TEST_DATA = [
+    (0x00000000, 0x00000000),
+    (0x00000000, 0x30000000),
+    (0x00000000, 0x90000000),
+    (0x00000000, 0x70000000),
+    (0x00000000, 0xA0000000),
+    (0x00000001, 0x00000001),
+    (0x00000000, 0xE0000000),
+    (0x00000001, 0x00000000),
+    (0x00000001, 0x7FFFFFFF),
+    (0x00000001, 0x00000000),
+    (0x00000001, 0x50000000),
+    (0x00000001, 0x80000000),
+    (0x00000001, 0x00000001),
+    (0x00000001, 0x40000000),
+    (0x00000001, 0x90000000),
+    (0x00000001, 0xB0000000),
+    (0x00000002, 0x0FFFFFFF),
+    (0x00000002, 0x20000000),
+    (0x00000002, 0x90000000),
+    (0x00000002, 0x70000000),
+    (0x00000002, 0xA0000000),
+    (0x00000003, 0x00004000),
+    (0x00000002, 0xD0000000),
+    (0x00000003, 0x20000000),
+    (0x00000003, 0x90000000),
+    (0x00000003, 0x70000000),
+    (0x00000003, 0xA0000000),
+    (0x00000004, 0x00004000),
+    (0x00000003, 0xD0000000),
+]
+
+
+# Easier test data with small jumps <= 0x30000000
+SNE_DATA_EASY = [
+    (0x00000000, 0x00000000),
+    (0x00000000, 0x30000000),
+    (0x00000000, 0x60000000),
+    (0x00000000, 0x80000000),
+    (0x00000000, 0x90000000),
+    (0x00000000, 0xC0000000),
+    (0x00000000, 0xF0000000),
+    (0x00000001, 0x10000000),
+    (0x00000000, 0xF0030000),
+    (0x00000001, 0x00030000),
+    (0x00000001, 0x10030000),
+]
+
+
+def check_sne_alg(alg, data):
+    for sne, seq in data:
+        observed_sne = alg.calc(seq)
+        logger.info(
+            "seq %08x expected sne %08x observed sne %08x", seq, sne, observed_sne
+        )
+        assert observed_sne == sne
+
+
+def test_sne_alg():
+    check_sne_alg(SequenceNumberExtender(), _SNE_TEST_DATA)
+
+
+def test_sne_alg_easy():
+    check_sne_alg(SequenceNumberExtender(), SNE_DATA_EASY)
+
+
+@pytest.mark.xfail
+def test_sne_alg_rfc():
+    check_sne_alg(SequenceNumberExtenderRFC(), _SNE_TEST_DATA)
+
+
+@pytest.mark.xfail
+def test_sne_alg_rfc_easy():
+    check_sne_alg(SequenceNumberExtenderRFC(), SNE_DATA_EASY)
+
+
+def test_sne_alg_linux():
+    check_sne_alg(SequenceNumberExtenderLinux(), _SNE_TEST_DATA)
+    check_sne_alg(SequenceNumberExtenderLinux(), SNE_DATA_EASY)
-- 
2.25.1

