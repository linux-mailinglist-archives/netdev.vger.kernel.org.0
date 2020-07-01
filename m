Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417BE211237
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732770AbgGARxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGARxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 13:53:19 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E806C08C5DD
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 10:53:19 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u93so17347028qtd.8
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 10:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VB/KSdoSleNPyuddI4RHZwpZo8dMr4vfXtKSdI4JDW8=;
        b=UfhtwlfrE3cJUVoe4WVJG0157tIrGS4kww4M+vCDEfR+MCtIiF4OHtsu8K6QHxFgSL
         H0UHxeRL8rCoT0xjdG6BeSd9Vzya6G5s6MvHiwqdFlGdqTCJaXXJeUrqNTHrlVNwFpaR
         A/ANM+yVtI8e/dEMoZKYYul4ntUXW8V2/F3LhRlIYDNn0RqTajLdXN0eMWaTagt9HVCl
         hPG3cFJQIU2bTRi3IzGl4NTUH9f4NgKrXrfdnIIG/RuFR9rCo/VuMGRcXIqsQ6GT+ndI
         hQVRM0DybGmWejTnFp3mJO8RGffIZPtnhuFSu3QvgYT4djdjGnsgFSyEwHF1fOuWUomu
         wvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VB/KSdoSleNPyuddI4RHZwpZo8dMr4vfXtKSdI4JDW8=;
        b=uHEXf6RtUMkaMjn4H7y0sbrvD9VHMf8kpIixPocM5EhGqJFlcEAf0Kd3roCcL6bEAE
         IUwyB4aqeYi15OkxiBdRFTwrgbg3La3ntqgMNpsFnWSvIOJWhkXO6JDsaPQlZ+DKIgXA
         qYAM0DOuRp1Dt27U8dsOTYHLOYxZoAih0tO6kHeaCPVAlb7iOXUmFtkaweeHM5IRpA3N
         HH8KFpgrSp/cPmISLZTZIJXrCvkOKFnUkQ+hBmKrOLH8aPdLKJMv+TFye2WO5lZVaj+k
         vnXt7ZiJF8HblBB227MxItBj+w9TjmVQplWX1V3bT7UiTj6vLw0EC4bk+svYMQYOnfWg
         BHOA==
X-Gm-Message-State: AOAM532p7QNWRiZYTsolAmhDIhq+W3Dk48ZHAbgSvG9JyORqHxtsoGTa
        vPUxLvVujsFSomEr/101UVQq5F34WW1mpOkqlVxW5Wx0nzbqTyWm3oCWVuL80JmMkHQ8zwN9Ygv
        WHOTFL0gkb2vPNSRoTD8/roPtu9xDOhQCZ+tsFRTDGa39hcD3Ex/Hjuu5LvbNzA==
X-Google-Smtp-Source: ABdhPJxm18w/p7T2L9JtqSka8bQFpLWO3xGu8H/hkbHEGAGRPd+DV26F5Q8a2oWlPOlxvzXa0T/+KtOVVFo=
X-Received: by 2002:a0c:8b4a:: with SMTP id d10mr26091444qvc.31.1593625998237;
 Wed, 01 Jul 2020 10:53:18 -0700 (PDT)
Date:   Wed,  1 Jul 2020 10:53:15 -0700
Message-Id: <20200701175315.1161242-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v2] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     sdf@google.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Hao Luo <haoluo@google.com>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
programs. But in a kernel built by clang, which performs more aggresive
inlining, that function gets inlined into its caller SyS_nanosleep.
Therefore, even though fentry and kprobe do hook on the function,
they aren't triggered by the call to nanosleep in the test.

A possible fix is switching to use a function that is less likely to
be inlined, such as hrtimer_range_start_ns. The EXPORT_SYMBOL functions
shouldn't be inlined based on the description of [1], therefore safe
to use for this test. Also the arguments of this function include the
duration of sleep, therefore suitable for test verification.

[1] af3b56289be1 time: don't inline EXPORT_SYMBOL functions

Tested:
 In a clang build kernel, before this change, the test fails:

 test_vmlinux:PASS:skel_open 0 nsec
 test_vmlinux:PASS:skel_attach 0 nsec
 test_vmlinux:PASS:tp 0 nsec
 test_vmlinux:PASS:raw_tp 0 nsec
 test_vmlinux:PASS:tp_btf 0 nsec
 test_vmlinux:FAIL:kprobe not called
 test_vmlinux:FAIL:fentry not called

 After switching to hrtimer_range_start_ns, the test passes:

 test_vmlinux:PASS:skel_open 0 nsec
 test_vmlinux:PASS:skel_attach 0 nsec
 test_vmlinux:PASS:tp 0 nsec
 test_vmlinux:PASS:raw_tp 0 nsec
 test_vmlinux:PASS:tp_btf 0 nsec
 test_vmlinux:PASS:kprobe 0 nsec
 test_vmlinux:PASS:fentry 0 nsec

Signed-off-by: Hao Luo <haoluo@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 Changelog since v1:
 - More accurate commit messages

 tools/testing/selftests/bpf/progs/test_vmlinux.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c b/tools/testing/selftests/bpf/progs/test_vmlinux.c
index 5611b564d3b1..29fa09d6a6c6 100644
--- a/tools/testing/selftests/bpf/progs/test_vmlinux.c
+++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
@@ -63,20 +63,20 @@ int BPF_PROG(handle__tp_btf, struct pt_regs *regs, long id)
 	return 0;
 }
 
-SEC("kprobe/hrtimer_nanosleep")
-int BPF_KPROBE(handle__kprobe,
-	       ktime_t rqtp, enum hrtimer_mode mode, clockid_t clockid)
+SEC("kprobe/hrtimer_start_range_ns")
+int BPF_KPROBE(handle__kprobe, struct hrtimer *timer, ktime_t tim, u64 delta_ns,
+	       const enum hrtimer_mode mode)
 {
-	if (rqtp == MY_TV_NSEC)
+	if (tim == MY_TV_NSEC)
 		kprobe_called = true;
 	return 0;
 }
 
-SEC("fentry/hrtimer_nanosleep")
-int BPF_PROG(handle__fentry,
-	     ktime_t rqtp, enum hrtimer_mode mode, clockid_t clockid)
+SEC("fentry/hrtimer_start_range_ns")
+int BPF_PROG(handle__fentry, struct hrtimer *timer, ktime_t tim, u64 delta_ns,
+	     const enum hrtimer_mode mode)
 {
-	if (rqtp == MY_TV_NSEC)
+	if (tim == MY_TV_NSEC)
 		fentry_called = true;
 	return 0;
 }
-- 
2.27.0.212.ge8ba1cc988-goog

