Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4043E1925
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhHEQKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhHEQKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:10:41 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3E1C061765;
        Thu,  5 Aug 2021 09:10:27 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id b11so7294016wrx.6;
        Thu, 05 Aug 2021 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/m61cwEMf4ke8oePiJ7XNYPUM0uLdLukigTj9FMf4mU=;
        b=NTySaqhQMS9iIq0L7mecMWAozFOYz81v55Eqd6GJLsW3WvGIshk/O3pMf/WHOOO7IF
         utO120Ann1qJPyO7fm9cASHjMPZ0gU1XwjkvrskM5kIigWvVAioWhGp1S8jmJpHuWiis
         qqxFOLmOmZeUs7vJccGfEAbtb4meW/xYoigo3IaMkAhtUPYMlLhhv72WNCsszkG3iuPy
         rZhUZGq0suIG9aJUAVP6TKkrs1RBHRCCuZjWaH8ZYzz+ey/WjWRwVxu5VrdzR3rEEZ7m
         Gk4jCfpozoXC+8a+8POw0/H70sDfzc+ag+xRMRHAH+GnC+PD3zgdXCWwBjhcXCgX7YAX
         I7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/m61cwEMf4ke8oePiJ7XNYPUM0uLdLukigTj9FMf4mU=;
        b=fqnnIq5CP4ZcGJWZIuKYxuGBMdkKTsJuQ9pjzhAnL+txAoMXNgobnd2LVDk+UWwUpS
         /qCbO5PABGWn4ym4i5Rb8BIUrgUyLJ6EBx5/dgAy94wrdrvf1R9tjM42kelvc7irJC3I
         1H9HcjsDsGLPgtR/H9dUitdar/0AfITiluRzTQvXj8ksx+zHwOVqisa3V3uchDjP7ejF
         owDlqtpE7qqr/eUrIQxjSLtels+FahsWNG3Hfdtcn3FNFsEcF4LfqQS+u147DtXKHjC8
         SPBfwjxZaccwf/rt9ihdkEUrdPUgDI9G9wmWgvHDIAZlWJoTYXd1boUNU2hOcQq8Ee4+
         Zjww==
X-Gm-Message-State: AOAM530RHb6FGAMEI/rfGIiyps/jyVupyoU/5YJuJUPoya9+kyllMhzH
        h6KaGO2AnjuOvOwsYyBbPaRrQUm7hXqlzz4=
X-Google-Smtp-Source: ABdhPJzbn8da4ZGzLwCkE6yEBK/zbupsxy/TyW/rkmfI4V9n3MB/cka8oq0uXyUsKLu9UwGR47sjNA==
X-Received: by 2002:adf:fb8f:: with SMTP id a15mr6202412wrr.92.1628179825472;
        Thu, 05 Aug 2021 09:10:25 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id n5sm5843968wme.47.2021.08.05.09.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 09:10:24 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v6 6/7] selftests/bpf: Fix xdp_tx.c prog section name
Date:   Sat, 31 Jul 2021 05:57:37 +0000
Message-Id: <20210731055738.16820-7-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210731055738.16820-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210731055738.16820-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The program type cannot be deduced from 'tx' which causes an invalid
argument error when trying to load xdp_tx.o using the skeleton.
Rename the section name to "xdp" so that libbpf can deduce the type.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 tools/testing/selftests/bpf/progs/xdp_tx.c   | 2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
index 94e6c2b281cb..5f725c720e00 100644
--- a/tools/testing/selftests/bpf/progs/xdp_tx.c
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -3,7 +3,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-SEC("tx")
+SEC("xdp")
 int xdp_tx(struct xdp_md *xdp)
 {
 	return XDP_TX;
diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
index ba8ffcdaac30..995278e684b6 100755
--- a/tools/testing/selftests/bpf/test_xdp_veth.sh
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
 ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
 
 ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
-ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
+ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp
 ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
 
 trap cleanup EXIT
-- 
2.17.1

