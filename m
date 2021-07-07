Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3293BED3E
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhGGRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 13:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhGGRnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 13:43:14 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AA7C061574;
        Wed,  7 Jul 2021 10:40:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so2119795pjo.3;
        Wed, 07 Jul 2021 10:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BgQbhoVbzjmNN3b9sj7N5Nl4gKvJ3MMVqvNXk5zHkNo=;
        b=bR47LD94Ihmmn+syU7HUJyHuGzItCzlwySdmlkOYI/yLYpYVon7pXNMaOD9WbOvGHh
         SqeGoAWtPadPUZwLG9LePULyOje+tqo/OgSzMDdJii1uZfPbqeFYEmEqpHBNywGAbqHy
         2iQt545mtIRNxxSdHd+w2YoLimLHvy+w6F2IHU8lAiQmJenx3+5YoqnFpXT13tHetrgy
         dlzio48/8UmsOvEgsEkA+FcqO5LKFg6wjaBPvsL9Tq+yM5THIWAKi3BkCdR5u6sX/GJd
         fT44xrPMKQbzunyhJl/zp8JqGkmruuVmLoS7qEzyjp8Frx+5bbCDFVaAl7M64v6s00ZW
         AvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BgQbhoVbzjmNN3b9sj7N5Nl4gKvJ3MMVqvNXk5zHkNo=;
        b=gCKAnK3WON5XurRZqYDx9wOnbeXoA/Ex/DUaMpDSSfwXsVBqePqxb+pB7hFXMYYgDF
         ndhjKAmkFv/qeXDKFQkkgIm33wPilhvYoaP6/sC55SLd9i0RLdgwxiXPww0nrqSOhXf9
         v4m5W1ztoZLI6AlJzloEIwfRl8HHMjuVkXvjbaLE/atuqpqZPb1NpYdG85TwYOmR6OZj
         Dvj75rxC15efXLXpBTrSkAAZLJboVCH4JA9eiIjqg9Tzm8hftqKBIvCHFRh26xpaFmwx
         x7NooOoGL/Y0ilZ+UhvlorigrfPNSAimfO135gXqIML45mJyO0HsDXwCL5+YzQdPYA0r
         yJeA==
X-Gm-Message-State: AOAM530cfpUmeVr6avTyOrfKpqVibjmGXxlRR2bmpzB2hMs1dfVebp5z
        6029MfSQnYQ4G4StTtlgduE=
X-Google-Smtp-Source: ABdhPJzCIAIXmtoc+TgNyipWd2WVTKXNqNE0xipLQsdFFIQOXHcVtnOxk+x8AeC7NNPt4aWeARXzww==
X-Received: by 2002:a17:90a:948b:: with SMTP id s11mr28015165pjo.139.1625679633694;
        Wed, 07 Jul 2021 10:40:33 -0700 (PDT)
Received: from BALT-UROY.maxlinear.com ([202.8.116.91])
        by smtp.gmail.com with ESMTPSA id r26sm15555376pfq.191.2021.07.07.10.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 10:40:33 -0700 (PDT)
From:   UjjaL Roy <royujjal@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: [PATCH] docs: bpf: Added more extension example
Date:   Wed,  7 Jul 2021 23:10:22 +0530
Message-Id: <20210707174022.517-1-royujjal@gmail.com>
X-Mailer: git-send-email 2.31.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Roy, UjjaL" <royujjal@gmail.com>

After reading this document observed that for new users it is
hard to find an example of "extension" easily.

So, added a new heading for extensions for better readability.
Now, the new readers can easily identify "extension" examples.
Also, added one more example of filtering interface index.

Signed-off-by: Roy, UjjaL <royujjal@gmail.com>
---
 Documentation/networking/filter.rst | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index 3e2221f4abe4..5f13905b12e0 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -320,13 +320,6 @@ Examples for low-level BPF:
   ret #-1
   drop: ret #0
 
-**(Accelerated) VLAN w/ id 10**::
-
-  ld vlan_tci
-  jneq #10, drop
-  ret #-1
-  drop: ret #0
-
 **icmp random packet sampling, 1 in 4**::
 
   ldh [12]
@@ -358,6 +351,22 @@ Examples for low-level BPF:
   bad: ret #0             /* SECCOMP_RET_KILL_THREAD */
   good: ret #0x7fff0000   /* SECCOMP_RET_ALLOW */
 
+Examples for low-level BPF extension:
+
+**Packet for interface index 13**::
+
+  ld ifidx
+  jneq #13, drop
+  ret #-1
+  drop: ret #0
+
+**(Accelerated) VLAN w/ id 10**::
+
+  ld vlan_tci
+  jneq #10, drop
+  ret #-1
+  drop: ret #0
+
 The above example code can be placed into a file (here called "foo"), and
 then be passed to the bpf_asm tool for generating opcodes, output that xt_bpf
 and cls_bpf understands and can directly be loaded with. Example with above
-- 
2.17.1

