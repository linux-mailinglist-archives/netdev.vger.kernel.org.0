Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF427CBEF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgI2Mbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:31:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730187AbgI2Mak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:30:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601382639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xvzLng++d0GQjJBUi/0nO1Ms1IYQwD4+9R7Ygprni3c=;
        b=GkmW/ZIEYGksVnNdbbsCe6sBpyK18HCRGp7fk0DXe3sqaMjrByyco2TZInRzT6ODkWMckr
        LHZLFWWIXdGuA7ubwzjRrhHAuzknxvbetKl6sYxuj+YG3whg/ljpLtTiyIuNA3IFOWQ2oO
        OtGNhyWw+oIqi77YimE6p1MTVbs8oVc=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-fUQNtP1NMqOWXgcD__ck5A-1; Tue, 29 Sep 2020 08:30:37 -0400
X-MC-Unique: fUQNtP1NMqOWXgcD__ck5A-1
Received: by mail-oo1-f69.google.com with SMTP id n6so1986714oos.12
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xvzLng++d0GQjJBUi/0nO1Ms1IYQwD4+9R7Ygprni3c=;
        b=MAGwwHscnmeOy4XjFNyqczWzp+9AKExPkEnm3Ub0bLzmjT8tailtwwVHhecjsovPDj
         7IwpoGLr7AhjvgRkP04OhCxV3h1l/vKEIl1CXEKj1VuUBBYMVZSaJZwSfLqY776Q6hoF
         9rSMbiwUvotftR2JLfEMNTLB5QF3yyoHxpbg+xboxwfgkcGspiiSGuTbLoBRP0BcHcim
         XGYlunGEI8pmaeS4TlvJ+VxItTl+321CRix7/m6lmqMKy9MDUNc98wEq8yg/hQ5nsNMy
         5y1fP+zJZIFtr69eekDeKL1Jfxpr8MdTYJnenOEX6Zj2zMSC1Hp9AXAG0BflvScE5PLH
         W7cw==
X-Gm-Message-State: AOAM530mYl0Cb5R+a37GnWnxjMb1aQjDNGjPEns7J06jA4TY/wN8rKkz
        9TLdVGKIYWgkGMhXnlHUygF704PG+OAeLY9h59HMZ71ZkKSjEC+TnqkqkYwIEcuDyLPfPdVWZ6b
        xHRwJb1wmfG2lfv2X
X-Received: by 2002:aca:bd8a:: with SMTP id n132mr2398097oif.100.1601382636963;
        Tue, 29 Sep 2020 05:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxtMOVSRmpEJspMGu1B9TMyJUHZE/vqWdRPfqoJwttt3tbdemxQ/MKrn2R6TluIvpwr/UyNw==
X-Received: by 2002:aca:bd8a:: with SMTP id n132mr2398080oif.100.1601382636497;
        Tue, 29 Sep 2020 05:30:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k3sm2852115oof.6.2020.09.29.05.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:30:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6847B183C5B; Tue, 29 Sep 2020 14:30:32 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next] selftests: Make sure all 'skel' variables are declared static
Date:   Tue, 29 Sep 2020 14:30:26 +0200
Message-Id: <20200929123026.46751-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If programs in prog_tests using skeletons declare the 'skel' variable as
global but not static, that will lead to linker errors on the final link of
the prog_tests binary due to duplicate symbols. Fix a few instances of this.

Fixes: b18c1f0aa477 ("bpf: selftest: Adapt sock_fields test to use skel and global variables")
Fixes: 9a856cae2217 ("bpf: selftest: Add test_btf_skc_cls_ingress")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c | 2 +-
 tools/testing/selftests/bpf/prog_tests/sock_fields.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
index 4ce0e8a25bc5..86ccf37e26b3 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingress.c
@@ -16,7 +16,7 @@
 #include "test_progs.h"
 #include "test_btf_skc_cls_ingress.skel.h"
 
-struct test_btf_skc_cls_ingress *skel;
+static struct test_btf_skc_cls_ingress *skel;
 struct sockaddr_in6 srv_sa6;
 static __u32 duration;
 
diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
index 66e83b8fc69d..af87118e748e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -36,7 +36,7 @@ struct bpf_spinlock_cnt {
 
 static struct sockaddr_in6 srv_sa6, cli_sa6;
 static int sk_pkt_out_cnt10_fd;
-struct test_sock_fields *skel;
+static struct test_sock_fields *skel;
 static int sk_pkt_out_cnt_fd;
 static __u64 parent_cg_id;
 static __u64 child_cg_id;
-- 
2.28.0

