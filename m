Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F526B86B0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCNAPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCNAPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:15:21 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB4090782;
        Mon, 13 Mar 2023 17:15:16 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id bo10so9318500qvb.12;
        Mon, 13 Mar 2023 17:15:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678752915;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8swntRo2w53/tesDGcj1/+7DDkhP52xTJeQgFbFBAhQ=;
        b=m8sSzhfDBmUjPMRXEPJs4+bLBQn3tjuE1KSO3zf2hdu9TErI8sTTdrBzn5ltoCHEbD
         paBMDeuS3WZbdxzCPNXrC643Unjfeq3Xj7zHymNv0rTi0RmHl+fMK1As562yq83Xzt8f
         5xrexzP0NZb6qSi4GuqLCOMvu5pAHHDVJ84xGzzXEFg6gyaJcqm/Y8EPJ4fIbtUYn+j6
         ITR3ccKg+evs/kKLFqWxi2zfgYuCZB+XgpwGYKlVzhZmlwRWX1ZnUANqo4Oa7OZzrnjs
         GDxRon35DnHuNQ/3YEcr9Ah35Ox528TTuxHGAv/upQ51zZVU3I/fgDTdZlTB7Gg+HCpq
         arOQ==
X-Gm-Message-State: AO0yUKWUapacLSDcBQmPan9WaGJHDgrZr8tVegSDt1gDe/U/M49gsb/O
        53KYKW6OHg5Rgg5hsgIf/jg=
X-Google-Smtp-Source: AK7set8m0x88o4OyUL/alYFJfNUbadktimIaS/ip7OP5Ax1EL4O0XzYfOn8HSe6iudwV0ThvG0Di+g==
X-Received: by 2002:a05:6214:3008:b0:56f:796c:b48 with SMTP id ke8-20020a056214300800b0056f796c0b48mr12772937qvb.1.1678752914906;
        Mon, 13 Mar 2023 17:15:14 -0700 (PDT)
Received: from maniforge ([2620:10d:c091:400::5:b967])
        by smtp.gmail.com with ESMTPSA id o7-20020a374107000000b00745c4d90aacsm371247qka.115.2023.03.13.17.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 17:15:14 -0700 (PDT)
Date:   Mon, 13 Mar 2023 19:15:12 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add various tests to check
 helper access into ptr_to_btf_id.
Message-ID: <20230314001512.GC202344@maniforge>
References: <20230313235845.61029-1-alexei.starovoitov@gmail.com>
 <20230313235845.61029-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313235845.61029-4-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:58:45PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add various tests to check helper access into ptr_to_btf_id.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Thanks a lot for the quick turnaround on this.

LGTM, just left one small nit below.

Acked-by: David Vernet <void@manifault.com>

> ---
>  .../selftests/bpf/progs/task_kfunc_failure.c  | 36 +++++++++++++++++++
>  .../selftests/bpf/progs/task_kfunc_success.c  |  4 +++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_failure.c b/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
> index 002c7f69e47f..27994d6b2914 100644
> --- a/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
> +++ b/tools/testing/selftests/bpf/progs/task_kfunc_failure.c
> @@ -301,3 +301,39 @@ int BPF_PROG(task_kfunc_from_lsm_task_free, struct task_struct *task)
>  	bpf_task_release(acquired);
>  	return 0;
>  }
> +
> +SEC("tp_btf/task_newtask")
> +__failure __msg("access beyond the end of member comm")
> +int BPF_PROG(task_access_comm1, struct task_struct *task, u64 clone_flags)
> +{
> +	bpf_strncmp(task->comm, 17, "foo");

Instead of 17, can you do either TASK_COMM_LEN + 1, or
sizeof(task->comm) + 1, to make the test a bit less brittle? Applies to
the other testcases as well.

> +	return 0;
> +}
> +
> +SEC("tp_btf/task_newtask")
> +__failure __msg("access beyond the end of member comm")
> +int BPF_PROG(task_access_comm2, struct task_struct *task, u64 clone_flags)
> +{
> +	bpf_strncmp(task->comm + 1, 16, "foo");
> +	return 0;
> +}
> +
> +SEC("tp_btf/task_newtask")
> +__failure __msg("write into memory")
> +int BPF_PROG(task_access_comm3, struct task_struct *task, u64 clone_flags)
> +{
> +	bpf_probe_read_kernel(task->comm, 16, task->comm);
> +	return 0;
> +}
> +
> +SEC("fentry/__set_task_comm")
> +__failure __msg("R1 type=ptr_ expected")
> +int BPF_PROG(task_access_comm4, struct task_struct *task, const char *buf, bool exec)
> +{
> +	/*
> +	 * task->comm is a legacy ptr_to_btf_id. The verifier cannot guarantee
> +	 * its safety. Hence it cannot be accessed with normal load insns.
> +	 */
> +	bpf_strncmp(task->comm, 16, "foo");
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_success.c b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
> index aebc4bb14e7d..4f61596b0242 100644
> --- a/tools/testing/selftests/bpf/progs/task_kfunc_success.c
> +++ b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
> @@ -207,6 +207,10 @@ int BPF_PROG(test_task_from_pid_invalid, struct task_struct *task, u64 clone_fla
>  	if (!is_test_kfunc_task())
>  		return 0;
>  
> +	bpf_strncmp(task->comm, 12, "foo");
> +	bpf_strncmp(task->comm, 16, "foo");
> +	bpf_strncmp(&task->comm[8], 4, "foo");
> +
>  	if (is_pid_lookup_valid(-1)) {
>  		err = 1;
>  		return 0;
> -- 
> 2.34.1
> 
