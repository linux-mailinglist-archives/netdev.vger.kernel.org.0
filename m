Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8475E2F70F3
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 04:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbhAOD20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 22:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729971AbhAOD2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 22:28:25 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F9CC061575;
        Thu, 14 Jan 2021 19:27:45 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id v67so11207519lfa.0;
        Thu, 14 Jan 2021 19:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SbHv2LM3r1s8rUCMgl3Wtj7WAZ7OpMJFQ0X5VUOU05M=;
        b=c9FCVA4QsDIcml6UUMpL04H3CTkqDJsOCwjp4LvXEFgeWFuJdNPFYNv+smhvLpGe/2
         Z5nTLLoNGkxF/z5pK7gwoahgzkl0ks50LKD5vIzdLDIo53NUJShViv6Y8WeUMiqsQo2M
         jZdRxYFaQVsVXrD7jtN6AWngfa/wf49ck4HEaFnShPxPAGsabsEcX9pLIlGD7xz90p+z
         N/YIQJ3R3AxsNrJVm0/Zc1l3lzf2TzGLezAReBBLUnNqBF9L8Fvgm3fHC4C0pTy0+NXA
         FC06HNG534TKnVs8iXoPL/5sxqaZJGHMn6P7PSLlPAA//FtgbgmDDja6rBqm5hi/CfYt
         fM+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SbHv2LM3r1s8rUCMgl3Wtj7WAZ7OpMJFQ0X5VUOU05M=;
        b=MlVifLQ8zxnBR/8d7SjLeymXtEGyx5xdqmsOhge1MHkVEyHWENNOmQ+3Noe9gac/1A
         S+uMQCR2do2O0y+VQq8Vp0pJ4puu3I4POe8uF0X/cOMYlEsMqHlAcDGixhiTZVB7Mmof
         +zWViFQLi8N/rAFaxgLTHr16/OtWdAsAQslLkyYsMlRvlsuhaHwljghwQKODuYeyNBU3
         YNMf8cEow4Yp1ybVtieX39bSi0JTfM7En9a9ZFbEGvj2LP3Z35FnFoFgbjy5Mo6F7nJo
         gzD4WnhPhEWOsHL8KBkmajkbrUayH+Oh0v6zzG5Fy0yT6y+cl+zE631nI3vrzoVBF7he
         fEJQ==
X-Gm-Message-State: AOAM530tPPNB6oDZK3sSukZebkdKT4QfF4WFTBW9xh1Nnh3Vyn59EYh6
        E7mBd4LZC6d3v+LaV7dSVNBQLa7T8cESH8QvR8s=
X-Google-Smtp-Source: ABdhPJwgxBvWI/kpHi/nIr5mXxkzoZ7w435eUPofVmDa9OnC20BxclD5xDdCuG0tAbisjuB2tZAn73ypfTUdoNNkCbg=
X-Received: by 2002:a19:acd:: with SMTP id 196mr4770789lfk.539.1610681263751;
 Thu, 14 Jan 2021 19:27:43 -0800 (PST)
MIME-Version: 1.0
References: <20210113213321.2832906-1-sdf@google.com> <20210113213321.2832906-2-sdf@google.com>
In-Reply-To: <20210113213321.2832906-2-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 Jan 2021 19:27:32 -0800
Message-ID: <CAADnVQLssJ4oStg7C4W-nafFKaka1H3-N0DhsBrB3FdmgyUC_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 1:33 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> call in do_tcp_getsockopt using the on-stack data. This removes
> 3% overhead for locking/unlocking the socket.
>
> Without this patch:
>      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
>             |
>              --3.30%--__cgroup_bpf_run_filter_getsockopt
>                        |
>                         --0.81%--__kmalloc
>
> With the patch applied:
>      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Few issues in this patch and the patch 2 doesn't apply:
Switched to a new branch 'tmp'
Applying: bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
.git/rebase-apply/patch:295: trailing whitespace.
#endif
.git/rebase-apply/patch:306: trailing whitespace.
union tcp_word_hdr {
.git/rebase-apply/patch:309: trailing whitespace.
};
.git/rebase-apply/patch:311: trailing whitespace.
#define tcp_flag_word(tp) ( ((union tcp_word_hdr *)(tp))->words [3])
.git/rebase-apply/patch:313: trailing whitespace.
enum {
warning: squelched 1 whitespace error
warning: 6 lines add whitespace errors.
Applying: bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
error: patch failed: kernel/bpf/cgroup.c:1390
error: kernel/bpf/cgroup.c: patch does not apply
Patch failed at 0002 bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
