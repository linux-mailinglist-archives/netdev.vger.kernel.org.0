Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FABC66AFAD
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjAOHSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjAOHRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:17:01 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA928CDD5;
        Sat, 14 Jan 2023 23:16:45 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i65so15442605pfc.0;
        Sat, 14 Jan 2023 23:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p84tYMZEQXh/QdeHoG0Y2waJnOExFznBjHemL6AX+5c=;
        b=PossRIwEacxLxawEt/KAP6YCxW+x8yiqDIOTxF6SWEqoouLh0NWxjY49m7RgDH/VGs
         Gg4OYJP1sgmuHaMun22Fu67+P1J8Jpgm9H9bQovC2WMHDB3EVJZMrAXFeyRk7OAnhR4H
         LZ9LMvX4h4IcdtUjaptBl0bOKB3dJt0K+U2D0HtXjtHFVU1i1s466prk1aUri1TvBzUd
         P/chZ23z5zu4EYuCMh/AcRHTnkyJoqJNL6ejG39o4ZsBdoxS3GTEqrTvHouw5IJWg0iN
         13oaEkv5D2rqvwGhCD0rKVMPsT4koDXbSK4nxX55moCJrjPTOLt0/+RQsUoveSh9YmD0
         Z8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p84tYMZEQXh/QdeHoG0Y2waJnOExFznBjHemL6AX+5c=;
        b=c9gZFRudi51FfSPsI2qJDcRQnl4MgOH3oovgqqaIK6+HtvgDrl0uAvK2HAxpOadXoT
         HkJmUkUOQyTseIaGmvkcESDItfWhEJ6Cb3TleWzX/rOT7d/gOL6atJFQGqR47CePMWr8
         Y8O5ZrxuyTlRsRJ8m1GItUcPkmNAykIOrXgo7br7rtIPeJTMSMFiDZbDCtHvAinPQ/hr
         oL9gQr6lc7I3QqbzR8iYh73/w++nS+J/D4L6sQUZ/vFTVfPHqliQ9h8mCQfRWo1GZ286
         itHEkeVnSoDzBvHivC3uzNjrZA1W/FuG7SZQEinEpUYkZXFGnzTN9gXu4fVHBmc765bO
         KeYQ==
X-Gm-Message-State: AFqh2kpnGwLj/LG6QY7vHOUg6Krw7+567jAZDoOYgCWPfXeDpknxb+w2
        rLMqWAIrI279hZeVBARWtw==
X-Google-Smtp-Source: AMrXdXvV0bQRSJ0I3nfBS+a6jD++ICoVTAFw+lXAeyk/dkNICkzWVy+5MxdoDTNf+7mFztM6xBooew==
X-Received: by 2002:a62:1887:0:b0:582:5886:e1b7 with SMTP id 129-20020a621887000000b005825886e1b7mr45554548pfy.14.1673767005403;
        Sat, 14 Jan 2023 23:16:45 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:44 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 07/10] samples/bpf: split common macros to net_shared.h
Date:   Sun, 15 Jan 2023 16:16:10 +0900
Message-Id: <20230115071613.125791-8-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, many programs under sample/bpf often include individual
macros by directly including the header under "linux/" rather than
using the "vmlinux.h" header.

However, there are some problems with migrating to "vmlinux.h" because
there is no definition for utility functions such as endianness
conversion (ntohs/htons). Fortunately, the xdp_sample program already
has a function that can be replaced to solve this problem.

Therefore, this commit attempts to separate these functions into a file
called net_shared.h to make them universally available. Additionally,
this file includes network-related macros that are not defined in
"vmlinux.h". (inspired by 'selftests' bpf_tracing_net.h)

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/net_shared.h     | 26 ++++++++++++++++++++++++++
 samples/bpf/xdp_sample.bpf.h | 22 +---------------------
 2 files changed, 27 insertions(+), 21 deletions(-)
 create mode 100644 samples/bpf/net_shared.h

diff --git a/samples/bpf/net_shared.h b/samples/bpf/net_shared.h
new file mode 100644
index 000000000000..04b29b217d25
--- /dev/null
+++ b/samples/bpf/net_shared.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef _NET_SHARED_H
+#define _NET_SHARED_H
+
+#define ETH_ALEN 6
+#define ETH_P_802_3_MIN 0x0600
+#define ETH_P_8021Q 0x8100
+#define ETH_P_8021AD 0x88A8
+#define ETH_P_IP 0x0800
+#define ETH_P_IPV6 0x86DD
+#define ETH_P_ARP 0x0806
+#define IPPROTO_ICMPV6 58
+
+#if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define bpf_ntohs(x)		__builtin_bswap16(x)
+#define bpf_htons(x)		__builtin_bswap16(x)
+#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define bpf_ntohs(x)		(x)
+#define bpf_htons(x)		(x)
+#else
+# error "Endianness detection needs to be set up for your compiler?!"
+#endif
+
+#endif
diff --git a/samples/bpf/xdp_sample.bpf.h b/samples/bpf/xdp_sample.bpf.h
index 25b1dbe9b37b..fecc41c5df04 100644
--- a/samples/bpf/xdp_sample.bpf.h
+++ b/samples/bpf/xdp_sample.bpf.h
@@ -7,17 +7,9 @@
 #include <bpf/bpf_core_read.h>
 #include <bpf/bpf_helpers.h>
 
+#include "net_shared.h"
 #include "xdp_sample_shared.h"
 
-#define ETH_ALEN 6
-#define ETH_P_802_3_MIN 0x0600
-#define ETH_P_8021Q 0x8100
-#define ETH_P_8021AD 0x88A8
-#define ETH_P_IP 0x0800
-#define ETH_P_IPV6 0x86DD
-#define ETH_P_ARP 0x0806
-#define IPPROTO_ICMPV6 58
-
 #define EINVAL 22
 #define ENETDOWN 100
 #define EMSGSIZE 90
@@ -55,18 +47,6 @@ static __always_inline void swap_src_dst_mac(void *data)
 	p[5] = dst[2];
 }
 
-#if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
-	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-#define bpf_ntohs(x)		__builtin_bswap16(x)
-#define bpf_htons(x)		__builtin_bswap16(x)
-#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && \
-	__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-#define bpf_ntohs(x)		(x)
-#define bpf_htons(x)		(x)
-#else
-# error "Endianness detection needs to be set up for your compiler?!"
-#endif
-
 /*
  * Note: including linux/compiler.h or linux/kernel.h for the macros below
  * conflicts with vmlinux.h include in BPF files, so we define them here.
-- 
2.34.1

