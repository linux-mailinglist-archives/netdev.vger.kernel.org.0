Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AFA66AFA5
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjAOHRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbjAOHQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:50 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FE9B45B;
        Sat, 14 Jan 2023 23:16:34 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id d10so17594379pgm.13;
        Sat, 14 Jan 2023 23:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kDnC+/cfUMMOFjYmAxLkFmwnVT0UDNBRF4bIPq83UM=;
        b=WJBB9wETNIDP9BCZ8yiYzbgE4gUzl/NBgPPpHtMTfcpfqit0N3GbiI8YvI41bpJgsJ
         I9xWAhVYU+9n5PeiKcxN/bFD5UTUSDQiOa1VODh815qQbOoXIA3fRgtln0TySVhXRC3p
         zaNFRpUPqKXx8BMN6bjtGc9oqpcH/cEydxE8xJbl+LtfKUa/QxmFOWiKjvqdHzX/PJmE
         B8Vqyk9PH3kJD2T3Gva4HJaTy/TEwCk8gmb/QUXppfcEOxI9RZ8r4P6+YcqIE/WbUn0R
         0Rztbhz55NpkHgNfXqNf1Il9XavHUoCWYaAuJwJxqpOrRiMhF3Hybo0XxkKFkoNmalpw
         Dw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kDnC+/cfUMMOFjYmAxLkFmwnVT0UDNBRF4bIPq83UM=;
        b=MGf2NL/w+hWzzj5e0MNAFPdjDY0Ulo5eRs/sotCFGZtGH4AzeiKcmhJy9jtyoFg51j
         3AL945h7OJkvdSDAjkMWnVUM9PZGCZKB3f+3yhIlkWgLekEYsxBhWhZ6jQEngohi0CiF
         N7vF2w2a4IjMoF2obEgRAI91o2PHurT7BuHyUBSKfWrgeKzH5N2EtEEBfd5bJ+jwrVBP
         mbAKZ4bPPvDBpakyC1iY/MDzPQbPmi5A1bjQUvyLI9+RI4Y0Ws4DZttFf0nl4TeKXEvM
         dBmsrLIRo16UdSHdxIBcAJi7BTf4x364nAhzZi+NGeyQEfBb0qOZPaTHmehbGUZisaqf
         CWqQ==
X-Gm-Message-State: AFqh2krnKe4GS5nd1TEz2YErxnq//jPLpr8Xb8QMxf2lcHZyA9AFRfmR
        xH47fn94S9JggHFKkXUtQg==
X-Google-Smtp-Source: AMrXdXvVXQbZbTni1a0PSp7fjVXAWGUbUYO/UC+BynA6En81L8SzbO9iG26ZdF41L7P7k0u1fei3jQ==
X-Received: by 2002:a05:6a00:1a55:b0:58d:9791:44bc with SMTP id h21-20020a056a001a5500b0058d979144bcmr1773337pfv.9.1673766994350;
        Sat, 14 Jan 2023 23:16:34 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:33 -0800 (PST)
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
Subject: [bpf-next 04/10] samples/bpf: fix broken cgroup socket testing
Date:   Sun, 15 Jan 2023 16:16:07 +0900
Message-Id: <20230115071613.125791-5-danieltimlee@gmail.com>
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

Currently, executing test_cgrp2_sock2 fails due to wrong section
header. This 'cgroup/sock1' style section is previously used at
'samples/bpf_load' (deprecated) BPF loader. Because this style isn't
supported in libbpf, this commit fixes this problem by correcting the
section header.

    $ sudo ./test_cgrp2_sock2.sh
    libbpf: prog 'bpf_prog1': missing BPF prog type, check ELF section name 'cgroup/sock1'
    libbpf: prog 'bpf_prog1': failed to load: -22
    libbpf: failed to load object './sock_flags_kern.o'
    ERROR: loading BPF object file failed

In addition, this BPF program filters ping packets by comparing whether
the socket type uses SOCK_RAW. However, after the ICMP socket[1] was
developed, ping sends ICMP packets using SOCK_DGRAM. Therefore, in this
commit, the packet filtering is changed to use SOCK_DGRAM instead of
SOCK_RAW.

    $ strace --trace socket ping -6 -c1 -w1 ::1
    socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6) = 3

[1]: https://lwn.net/Articles/422330/

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/sock_flags_kern.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/samples/bpf/sock_flags_kern.c b/samples/bpf/sock_flags_kern.c
index 6d0ac7569d6f..1d58cb9b6fa4 100644
--- a/samples/bpf/sock_flags_kern.c
+++ b/samples/bpf/sock_flags_kern.c
@@ -5,7 +5,7 @@
 #include <uapi/linux/in6.h>
 #include <bpf/bpf_helpers.h>
 
-SEC("cgroup/sock1")
+SEC("cgroup/sock")
 int bpf_prog1(struct bpf_sock *sk)
 {
 	char fmt[] = "socket: family %d type %d protocol %d\n";
@@ -17,29 +17,29 @@ int bpf_prog1(struct bpf_sock *sk)
 	bpf_trace_printk(fmt, sizeof(fmt), sk->family, sk->type, sk->protocol);
 	bpf_trace_printk(fmt2, sizeof(fmt2), uid, gid);
 
-	/* block PF_INET6, SOCK_RAW, IPPROTO_ICMPV6 sockets
+	/* block PF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6 sockets
 	 * ie., make ping6 fail
 	 */
 	if (sk->family == PF_INET6 &&
-	    sk->type == SOCK_RAW   &&
+	    sk->type == SOCK_DGRAM   &&
 	    sk->protocol == IPPROTO_ICMPV6)
 		return 0;
 
 	return 1;
 }
 
-SEC("cgroup/sock2")
+SEC("cgroup/sock")
 int bpf_prog2(struct bpf_sock *sk)
 {
 	char fmt[] = "socket: family %d type %d protocol %d\n";
 
 	bpf_trace_printk(fmt, sizeof(fmt), sk->family, sk->type, sk->protocol);
 
-	/* block PF_INET, SOCK_RAW, IPPROTO_ICMP sockets
+	/* block PF_INET, SOCK_DGRAM, IPPROTO_ICMP sockets
 	 * ie., make ping fail
 	 */
 	if (sk->family == PF_INET &&
-	    sk->type == SOCK_RAW  &&
+	    sk->type == SOCK_DGRAM  &&
 	    sk->protocol == IPPROTO_ICMP)
 		return 0;
 
-- 
2.34.1

