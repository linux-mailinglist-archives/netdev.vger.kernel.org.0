Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE3C20FC2B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgF3St3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgF3St1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:49:27 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D835C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:49:27 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id m67so14064251qkb.17
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LEHppYXCQPcRgd0zlbLe7CmHbNbqX0AwBnt1nKT8kmo=;
        b=gDKmgaxn/Cl6wcc1lPhuw4d+qqZAEQfqpIWDlxkB2OP7eOtiDx3WCaV9AFMCtBGcEW
         6y4r4V13gqh1xMTARtmFL7ye+2ccgbPwchESgvOexvYAy6hhtgrGLCKG6QC3Vkrev2y+
         IcxsPM4HEFx4vUl3Trmszcq2jN0HtzaH7vyAMM+/hVR7gCA6JLkndlLF4fRw/mi2fYa/
         rqJwYliZI3TiCxV3OBUl6aFdha/b4dwy17RorxyAwRczDrSXGLV+oykGuVWj1ZNTPbvv
         I1GjO7O7ckRnbMSSppCivAiy/2XvKnfWVijFknFlTXq65JbU2aUhnsfHnxvk6sQUTHLf
         fWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LEHppYXCQPcRgd0zlbLe7CmHbNbqX0AwBnt1nKT8kmo=;
        b=JGtysfnG2gF+J8ov0PRs42YWlg7PPK60mtRSuUUppwP1/8sGD7J/TEX8Pj0euBsT3H
         O86wZ+jbTVQ3XGUxY/n9GMwCr9Xq8IYTLfSGOaESC4BC3ZuVrp4wKH/2KuH2xGFo42h9
         g7sKbWl3h5kK1FeqtzR0pJStRY55Ot5Eu5TNIL9WjiGUFlu+8IlSYlDRmhY9/FtVrSkD
         dWx+6W4OW9Lvccewlbd+Gp4KYXjt0hkVY28lLNx/Pv8W1uhuCsFlQvBPUnEmwjjFnUu+
         4f//KfEPShCS9lW3+6vAOXzXDUnkvUHyMZMPODPa2aBvMkn8Q2o2FqLBcF9gZdmn3Mc6
         4BDw==
X-Gm-Message-State: AOAM532R8oMW3HdgmbgLeTaZnBxdMyJ6ETt3LejYgjzgrcyt++vLUS1m
        FdauqfUEhSQhpx8Hk5CA45w6N6dGoj1LiEsxdw3eMafhBS5U+IR+uW0AIQy0rHaXCPYZ8fjWEho
        Q9WwWADzMFsujI6g4W7D5Vel8afUX+38oUDeye2tPnXjYxsbU8yBeZUsDw9uldQ==
X-Google-Smtp-Source: ABdhPJwRys7ufIj6Wc7BHqYbfXPqG7SI1+88BKjiZMcxuVaaHmLS3yYhRz/blmSR7Scygm3uV5jRzePkDzQ=
X-Received: by 2002:ad4:4105:: with SMTP id i5mr11143826qvp.170.1593542965986;
 Tue, 30 Jun 2020 11:49:25 -0700 (PDT)
Date:   Tue, 30 Jun 2020 11:49:22 -0700
Message-Id: <20200630184922.455439-1-haoluo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kselftest@vger.kernel.org
Cc:     sdf@google.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
programs. But it seems Clang may have done an aggressive optimization,
causing fentry and kprobe to not hook on this function properly on a
Clang build kernel.

A possible fix is switching to use a more reliable function, e.g. the
ones exported to kernel modules such as hrtimer_range_start_ns. After
we switch to using hrtimer_range_start_ns, the test passes again even
on a clang build kernel.

Tested:
 In a clang build kernel, the test fail even when the flags
 {fentry, kprobe}_called are set unconditionally in handle__kprobe()
 and handle__fentry(), which implies the programs do not hook on
 hrtimer_nanosleep() properly. This could be because clang's code
 transformation is too aggressive.

 test_vmlinux:PASS:skel_open 0 nsec
 test_vmlinux:PASS:skel_attach 0 nsec
 test_vmlinux:PASS:tp 0 nsec
 test_vmlinux:PASS:raw_tp 0 nsec
 test_vmlinux:PASS:tp_btf 0 nsec
 test_vmlinux:FAIL:kprobe not called
 test_vmlinux:FAIL:fentry not called

 After we switch to hrtimer_range_start_ns, the test passes.

 test_vmlinux:PASS:skel_open 0 nsec
 test_vmlinux:PASS:skel_attach 0 nsec
 test_vmlinux:PASS:tp 0 nsec
 test_vmlinux:PASS:raw_tp 0 nsec
 test_vmlinux:PASS:tp_btf 0 nsec
 test_vmlinux:PASS:kprobe 0 nsec
 test_vmlinux:PASS:fentry 0 nsec

Signed-off-by: Hao Luo <haoluo@google.com>
---
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

