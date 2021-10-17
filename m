Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E79430C4D
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344648AbhJQVWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:22:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242717AbhJQVWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634505619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srAxXppIvHz+myMAl+rb3OMXLAjwG2sT2dL0Sifr8SY=;
        b=YSYlRFsFcLfsRb/MFm6bkaLCyJsVAvkqz6iH7plAyMd6oY4WWkTKYleihdqPrExblliUlN
        lAMuFoQhk+8TvVD1KGHMozwK+11DZmzxmvdjm5YCGM2KmHXiljIClCZ9T+OqBtqFxJJ4gK
        Hrjn6Mz3IVoNNpTQ0wlviRlyf6Pxv/k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-OYSrSrc9PHOFmLrkRe6rkw-1; Sun, 17 Oct 2021 17:20:18 -0400
X-MC-Unique: OYSrSrc9PHOFmLrkRe6rkw-1
Received: by mail-wm1-f70.google.com with SMTP id k6-20020a7bc306000000b0030d92a6bdc7so2376650wmj.3
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=srAxXppIvHz+myMAl+rb3OMXLAjwG2sT2dL0Sifr8SY=;
        b=gwjSrE+EdvPbU6dE3/96/gPgwMF69fr2qBxw4FTfk6mQU+6J8NTdJwrCpzi3B2DRFk
         dicPSvRvHxYhceHLLrKAGukeIQPdnYs+q7mQiCHdNI9udP1hZfinYsg+N3U83dqNhcbH
         ruqXxKURTJay0mPHhUMBbdMQ3XSwa8+UAXuOAWUx0g8GFBSMOQesVxFQ378ou/IQjPeh
         31C+KIyJuE6wLZ7k//jIhvv1K0pWtEWmpMrVtxCuPMO0MVDVGR9SYeM6O42Nb+Xmbpvr
         8d+yIHXSytCnWkKApbgy9Upfhkjf3qvGLqRTdf1ZXCe7R19iC4cawiFmowCinjHE4bAT
         p0TQ==
X-Gm-Message-State: AOAM533xS6Tm40bAWosqVT9fwSNkp1TBbfZbYXUPUVV0+YsULsFgOfFh
        uKfvh9j8QuLuSVEi3+wh3VvX/DI4NwUCSUCWTY9wzUJXVOrnvGzC7WWcDy7FhGcfWx4I912b540
        4Tqef6V29+keM24i9
X-Received: by 2002:a5d:4563:: with SMTP id a3mr30702551wrc.198.1634505310422;
        Sun, 17 Oct 2021 14:15:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8GDujnnlYrDZ6vz0cWuCOjpMhoco6bgO3eFsSttDzPYk0xUFvblndr4yRkPOE120t1DCMtQ==
X-Received: by 2002:a5d:4563:: with SMTP id a3mr30702543wrc.198.1634505310287;
        Sun, 17 Oct 2021 14:15:10 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id c132sm16905985wma.22.2021.10.17.14.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 14:15:10 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next 3/3] selftests/bpf: Use nanosleep tracepoint in perf buffer test
Date:   Sun, 17 Oct 2021 23:14:57 +0200
Message-Id: <20211017211457.343768-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211017211457.343768-1-jolsa@kernel.org>
References: <20211017211457.343768-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The perf buffer tests triggers trace with nanosleep syscall,
but monitors all syscalls, which results in lot of data in the
buffer and makes it harder to debug. Let's lower the trace
traffic and monitor just nanosleep syscall.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_perf_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_perf_buffer.c b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
index d37ce29fd393..a08874c5bdf2 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_buffer.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_buffer.c
@@ -12,7 +12,7 @@ struct {
 	__type(value, int);
 } perf_buf_map SEC(".maps");
 
-SEC("tp/raw_syscalls/sys_enter")
+SEC("tp/syscalls/sys_enter_nanosleep")
 int handle_sys_enter(void *ctx)
 {
 	int cpu = bpf_get_smp_processor_id();
-- 
2.31.1

