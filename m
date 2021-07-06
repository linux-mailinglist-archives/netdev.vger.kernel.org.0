Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF743BD6AB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbhGFMmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23524 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242470AbhGFM1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 08:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625574263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y13alJ2jM1bOVc9q850K4tBpaenyHU9dsbMO+Gya7uc=;
        b=h8uerQLFMJ9bS8CM4wWmuMfzpoJJbxMH1oZ6ZcUDmEx6Kl6AcvGnEMQ9XJzLNi5ZBTjsLK
        JlwDIhvwtvoe4yTRC126OQFTXsWatVRwPxbZbXiGQO47zVYQ/rniy8pV+tY+AX6t7lcv5I
        j4+FelXi++JkAxRoW0hmxt1C72E+gzI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-VjD2VBTSMB2iCDcGB09VwQ-1; Tue, 06 Jul 2021 08:24:22 -0400
X-MC-Unique: VjD2VBTSMB2iCDcGB09VwQ-1
Received: by mail-ed1-f72.google.com with SMTP id i8-20020a50fc080000b02903989feb4920so5239059edr.1
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 05:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y13alJ2jM1bOVc9q850K4tBpaenyHU9dsbMO+Gya7uc=;
        b=NX1wHQPejr8KZNMY2VnQ1xfUZ/ba0N5yCm4G6LrhOr3sPMuccD3+0MgKBH2lBAonRg
         ZyIG95bH+81uF7iOwrhJnO/16E2kJhNJIHBzODEXiSlbc3oXbH1gEFSNLjKttWFN2cg2
         rfUQKs/iYN3XRq7fBke5gcy++gEqIuklAlrMtfK/AgtgeRQS2IPNzQFeYEPH8Aqv2y43
         NVRegZKvF8sXzYK50jUHMBWRjVnKl/zPOWZKSe7e0cZu4ihn0hsfGKUVCe7nd4vrDAxr
         hi3QCTCyHHFOTkert27xE0h9Deqh0bXsX1xNjpjHbsQrIOreaQjIVuhnWqO87q4dHZZa
         yhyg==
X-Gm-Message-State: AOAM532G9C90uDNtztx+j37X9eDNC0XfxGFP4VBWqQC8eq9WLmNgCyof
        SJtYNNNcTlkDtkLb301qw+L/S/ar3k2tkbKkC+JwJcv4/Xz1tqGMMybqTxjLHEQtwYn+0ejYNWJ
        LhzyCEAvDOmi5NvVa
X-Received: by 2002:a05:6402:1d07:: with SMTP id dg7mr22695307edb.298.1625574261158;
        Tue, 06 Jul 2021 05:24:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJby1RGzCn1Gca06LP2s5K/jnrSikyYrVATGHfhm9trFu1pZ9JszYw/LRTDwt00A5iKIl0NQ==
X-Received: by 2002:a05:6402:1d07:: with SMTP id dg7mr22695295edb.298.1625574261032;
        Tue, 06 Jul 2021 05:24:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q17sm4422507eja.108.2021.07.06.05.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:24:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EA6F318072E; Tue,  6 Jul 2021 14:24:19 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf] libbpf: restore errno return for functions that were already returning it
Date:   Tue,  6 Jul 2021 14:23:55 +0200
Message-Id: <20210706122355.236082-1-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The update to streamline libbpf error reporting intended to change all
functions to return the errno as a negative return value if
LIBBPF_STRICT_DIRECT_ERRS is set. However, if the flag is *not* set, the
return value changes for the two functions that were already returning a
negative errno unconditionally: bpf_link__unpin() and perf_buffer__poll().

This is a user-visible API change that breaks applications; so let's revert
these two functions back to unconditionally returning a negative errno
value.

Fixes: e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level APIs")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e04ce724240..6f5e2757bb3c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10136,7 +10136,7 @@ int bpf_link__unpin(struct bpf_link *link)
 
 	err = unlink(link->pin_path);
 	if (err != 0)
-		return libbpf_err_errno(err);
+		return -errno;
 
 	pr_debug("link fd=%d: unpinned from %s\n", link->fd, link->pin_path);
 	zfree(&link->pin_path);
@@ -11197,7 +11197,7 @@ int perf_buffer__poll(struct perf_buffer *pb, int timeout_ms)
 
 	cnt = epoll_wait(pb->epoll_fd, pb->events, pb->cpu_cnt, timeout_ms);
 	if (cnt < 0)
-		return libbpf_err_errno(cnt);
+		return -errno;
 
 	for (i = 0; i < cnt; i++) {
 		struct perf_cpu_buf *cpu_buf = pb->events[i].data.ptr;
-- 
2.32.0

