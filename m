Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57754107682
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 18:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfKVRhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 12:37:14 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43925 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVRhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 12:37:14 -0500
Received: by mail-pf1-f194.google.com with SMTP id 3so3783619pfb.10;
        Fri, 22 Nov 2019 09:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AT1Uy45KEcceTclVAxyQPO7oz8RlbQQ1KDgFdZwOxDo=;
        b=HLpB5iWZ7csSRU6lvWE0Ii59B5YgIoebz0qWCZLFHEqE0OIXEDlHw6y1yRzSQ/Xl6J
         Lk8Ilp66RrenJYuFeEs21HnX3Ima6XKBwxlnc7JnaLKCMc2OtFCQZopPLl8CPC4innoQ
         W2GBhAiFumyVAo6IDoElBeTuOiulkpuMy9BVTtLj5jro/mmBUeSGwrm6J6cH/WScSjfC
         qPpmSKZFtoCP5qLe8WlzfwWRuWIRG1UzRUjuYRpEUhKVv9tJm8ICfWuQBn0N802TgCPp
         Hh2a3XCqWoZtDIU6jNBTPyAKr59aWOB056PmZyrY5DuWQmeU3++lhKYS5zwz5gIIsWgh
         j/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AT1Uy45KEcceTclVAxyQPO7oz8RlbQQ1KDgFdZwOxDo=;
        b=A+Wdqz++9v3a8Zf6TkjjIXRdBMSHYEmiDLbKC7/VD8/y9qkLXxMuusSuvQyah4E8DS
         Zqvv6bDshEsneUmjEYa8pKN3943/pggQjOwrn6iUxxvzbmGT5lPwkHJj6D4ZaMxsCsJK
         KheT/yAhJUUa9IRsFgAbbHxTBdbJ6ohp9c3HVQWHnGAdfsZO2Fih8LOn3M+4jvnmn7Ji
         ix6ZRSaqUsY4zSn9Y65VvYssWzkmE74q/pi7gemoWQ06d7mffMbUAKEPkpTznpGTUROG
         yuyNW+m/FAezGVtI2fzM1mr1PtpQwwOTfTeLZ9i9iK2nLbXBtFQvXN8BdgHQrp80xjga
         1LGg==
X-Gm-Message-State: APjAAAWYC1n+hdE4hbKd/9wUElusxcgRn49Y67FmfkQvRfDn5aMOBEfE
        YWt7VFy5TE/HrjazNOo4WcA=
X-Google-Smtp-Source: APXvYqxKD+6O9VbOx03obqZXYJ4pwU04HQmFatVz4ularr4jqoyT//CaMgtPMGkPa1m0XO9Qp3w9pw==
X-Received: by 2002:a65:62cc:: with SMTP id m12mr16352589pgv.397.1574444233552;
        Fri, 22 Nov 2019 09:37:13 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id r15sm8426605pfh.81.2019.11.22.09.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 09:37:12 -0800 (PST)
Date:   Fri, 22 Nov 2019 09:37:12 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5dd81cc8275d3_15482ad476a405b890@john-XPS-13-9370.notmuch>
In-Reply-To: <20191122011515.255371-1-ast@kernel.org>
References: <20191122011515.255371-1-ast@kernel.org>
Subject: RE: [PATCH bpf-next] selftests/bpf: Add BPF trampoline performance
 test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> Add a test that benchmarks different ways of attaching BPF program to a kernel function.
> Here are the results for 2.4Ghz x86 cpu on a kernel without mitigations:
> $ ./test_progs -n 49 -v|grep events
> task_rename base	2743K events per sec
> task_rename kprobe	2419K events per sec
> task_rename kretprobe	1876K events per sec
> task_rename raw_tp	2578K events per sec
> task_rename fentry	2710K events per sec
> task_rename fexit	2685K events per sec
> 
> On a kernel with retpoline:
> $ ./test_progs -n 49 -v|grep events
> task_rename base	2401K events per sec
> task_rename kprobe	1930K events per sec
> task_rename kretprobe	1485K events per sec
> task_rename raw_tp	2053K events per sec
> task_rename fentry	2351K events per sec
> task_rename fexit	2185K events per sec
> 
> All 5 approaches:
> - kprobe/kretprobe in __set_task_comm()
> - raw tracepoint in trace_task_rename()
> - fentry/fexit in __set_task_comm()
> are roughly equivalent.
> 
> __set_task_comm() by itself is quite fast, so any extra instructions add up.
> Until BPF trampoline was introduced the fastest mechanism was raw tracepoint.
> kprobe via ftrace was second best. kretprobe is slow due to trap. New
> fentry/fexit methods via BPF trampoline are clearly the fastest and the
> difference is more pronounced with retpoline on, since BPF trampoline doesn't
> use indirect jumps.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/test_overhead.c  | 142 ++++++++++++++++++
>  .../selftests/bpf/progs/test_overhead.c       |  43 ++++++
>  2 files changed, 185 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_overhead.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_overhead.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/test_overhead.c b/tools/testing/selftests/bpf/prog_tests/test_overhead.c
> new file mode 100644
> index 000000000000..c32aa28bd93f

Acked-by: John Fastabend <john.fastabend@gmail.com>
