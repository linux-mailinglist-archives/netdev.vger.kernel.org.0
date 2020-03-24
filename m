Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C9B190630
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgCXHW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:22:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46608 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbgCXHW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 03:22:58 -0400
Received: by mail-ed1-f68.google.com with SMTP id cf14so10381409edb.13;
        Tue, 24 Mar 2020 00:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xbAGFRUEc8WSi1m7tXd4QfoMkZSNw03YADtsowLEzJc=;
        b=QyOmm5ahPvMwOgaXbRvjRYuAGztnFHABZ1ay5NdVP4sQfwveT2bJtwcHD/pdhafXym
         U3nmrRDDkm5CH57XGUjkFfhcFTqtJ75wBKA3D/xK7YIDkeLMc+peRX1DdELLta4aIJYW
         PFvq29PXNTvktpqhI6OftKvvikVNkcVqeCnHmKBAmUndElIMXBm0eo+GM/ZOdieYzlY6
         25Bz8T61jhZNAQv0c3H5ISif/2X9CWiVJKD38SFMLDkdG+a0Zw7ZjFJf9y7h1xWkdq6C
         oJbZGXWj7p7T3mP82mNa9QxOQMm4/t33FJyobBTT2RRm+liOgYAGhAMxZ3DlNvxHm0Rm
         MntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xbAGFRUEc8WSi1m7tXd4QfoMkZSNw03YADtsowLEzJc=;
        b=giSg/4H0Rp8ieq2yvdC558N9SSIXkeI8LZVDf77iP5YbeYQhFiK45//aAH6kbLdcIA
         SNhpKf63DONfi99DwPaktb6ctIgJ9M3OwVvirm0GrEY2HG2tGPzftIZxrh9sysyzKKOx
         /uEYe6vNjLypDnDAqUImBju05c5zpbxQTw3qZR8ig81cXrm/fJfHwyQrQV0jXXa/RA60
         vlDAqFkNhJNaJKD1Lfp29kAZN3jAg9vI8yy1Tuhj1VBOye2QEYTiobiX5WIaVwvJYcjF
         7i5NoTFJbVeR5L7xbkVtvHV8BH7BwA8OVVSrufTaaxuJMDaGY4jkCq6kcndsmNzUz9jr
         yW8g==
X-Gm-Message-State: ANhLgQ26HIFIEtH1tRKcgivVNOeaNFSDPJsLo24FUnlUIVjdvY9vbgZo
        u2tD+TadmdYrHvaBax0NKMg=
X-Google-Smtp-Source: ADFU+vvv3nq9kXL78yrg4zvv6t3eZQV3/PwSXUQ6OlTRVy235ugMyeReRt5WE1ttXU1U9XZsmbHKeA==
X-Received: by 2002:a17:906:5c43:: with SMTP id c3mr21253612ejr.3.1585034576216;
        Tue, 24 Mar 2020 00:22:56 -0700 (PDT)
Received: from localhost.localdomain (45.239.197.178.dynamic.wless.lssmb00p-cgnat.res.cust.swisscom.ch. [178.197.239.45])
        by smtp.googlemail.com with ESMTPSA id bc11sm12420edb.34.2020.03.24.00.22.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 00:22:55 -0700 (PDT)
From:   Jean-Philippe Menil <jpmenil@gmail.com>
To:     yhs@fb.com
Cc:     kernel-janitors@vger.kernel.org, jpmenil@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] bpf: fix build warning - missing prototype
Date:   Tue, 24 Mar 2020 08:22:31 +0100
Message-Id: <20200324072231.5780-1-jpmenil@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <7c27e51f-6a64-7374-b705-450cad42146c@fb.com>
References: <7c27e51f-6a64-7374-b705-450cad42146c@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build warnings when building net/bpf/test_run.o with W=1 due
to missing prototype for bpf_fentry_test{1..6}.

Declare prototypes in order to silence warnings.

Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
---
 net/bpf/test_run.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index d555c0d8657d..cdf87fb0b6eb 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -113,31 +113,37 @@ static int bpf_test_finish(const union bpf_attr *kattr,
  * architecture dependent calling conventions. 7+ can be supported in the
  * future.
  */
+int noinline bpf_fentry_test1(int a);
 int noinline bpf_fentry_test1(int a)
 {
 	return a + 1;
 }
 
+int noinline bpf_fentry_test2(int a, u64 b);
 int noinline bpf_fentry_test2(int a, u64 b)
 {
 	return a + b;
 }
 
+int noinline bpf_fentry_test3(char a, int b, u64 c);
 int noinline bpf_fentry_test3(char a, int b, u64 c)
 {
 	return a + b + c;
 }
 
+int noinline bpf_fentry_test4(void *a, char b, int c, u64 d);
 int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
 {
 	return (long)a + b + c + d;
 }
 
+int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e);
 int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
 {
 	return a + (long)b + c + d + e;
 }
 
+int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f);
 int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
 {
 	return a + (long)b + c + d + (long)e + f;
-- 
2.25.2

