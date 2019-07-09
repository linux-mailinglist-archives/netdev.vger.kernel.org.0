Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316E763A47
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfGIRtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:49:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45959 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGIRtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:49:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id j19so22454578qtr.12;
        Tue, 09 Jul 2019 10:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KGUPz5IV3YdoV/mexx5Ab396uDyprgwwp/OydGbs6sU=;
        b=cKpc9X/XEeq3BexplRCYQDI+DSxIcihTSEp7o9KXKGhhUJojOSrXWb5sIDmc2/o9j5
         fI+R4sz5lKUA0xwOeiAUfu+bwYgknIirl7Y0HyOX2O3poC589fGMm8C/+WHRTmYhFZWx
         cYgne5lFQifiNf408W42Z3U9hXWgeE7+t/s81AEHma3GCVeVNhtvfjHQcDQGchueeGYM
         sH7SDQc+YWtd9S7lx3g/7xe61PZaaefW97pcCvw0++JR4SShQjuJi11wvH5iwW2Btbyd
         f5bqoJLxuUW3qAAiJBoy4MpzsZpPsR4zhyUc91NY3sCt3goQhB0kSf9W7WbnMFOX6TZI
         zc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KGUPz5IV3YdoV/mexx5Ab396uDyprgwwp/OydGbs6sU=;
        b=npFYg406qBFnEzzUhm7dCLTOcEoP6gk96eqszvqyG1mj901awNZEu8Qg6Jw7FyBI5M
         SlGHtFPHQkClMStpPHq1RUSH1w+od0ZWqmLtXDbJXVdUt0Yo0XE0GLWANyYZNyh+QjvB
         pe5re+yxyAkVm+LeltlakPjop/iIAGkq88Exa/pYxhOfk34hKc9XYWBl8nwbUSJAeueL
         hgR7AIRpY94pOo6cBtWCP4GvssmW3nyHuzxjSQcDvWhVMYB1ueRTg70r7pFyEQWOrcv+
         qvhyOyAWpiKq7n3YKunEw9j7dO2m2B8hWfuCTIXasVIldSJjQAIBsarcNHpnajMEsBIj
         CDIA==
X-Gm-Message-State: APjAAAVmhee9Rr/XXtKkVthoM5IRsvDLtaDGKLq80KoxDBkHPVWoBWzo
        /eeGlarzxg/NiAHHwFwVeU9XQBZdyE/GwN53Dfw=
X-Google-Smtp-Source: APXvYqw9JxV9AAe4heuZ1w92WW0v5na02CiGNNG5IePbSLWQiKrQFIwh9TDmofW7PP3dHEaA/7i8i7aOm+Lahit1rzc=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr19233941qty.141.1562694542807;
 Tue, 09 Jul 2019 10:49:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190709151809.37539-1-iii@linux.ibm.com> <20190709151809.37539-4-iii@linux.ibm.com>
In-Reply-To: <20190709151809.37539-4-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Jul 2019 10:48:52 -0700
Message-ID: <CAEf4BzY0kO2si_ajouYNfsauaWdHkj042++bLaHe1W_G885i=g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/4] selftests/bpf: make PT_REGS_* work in userspace
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Y Song <ys114321@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 8:19 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Right now, on certain architectures, these macros are usable only with
> kernel headers. This patch makes it possible to use them with userspace
> headers and, as a consequence, not only in BPF samples, but also in BPF
> selftests.
>
> On s390, provide the forward declaration of struct pt_regs and cast it
> to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
> of the full struct pt_regs, s390 exposes only its first member
> user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
> (in selftests) and kernel (in samples) headers. It was added in commit
> 466698e654e8 ("s390/bpf: correct broken uapi for
> BPF_PROG_TYPE_PERF_EVENT program type").
>
> Ditto on arm64.
>
> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390 and
> arm64, x86 provides struct pt_regs to both userspace and kernel, however,
> with different member names.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Just curious, what did you use as a reference for which register
corresponds to which PARM, RET, etc for different archs? I've tried to
look it up the other day, and it wasn't as straightforward to find as
I hoped for, so maybe I'm missing something obvious.


>  tools/testing/selftests/bpf/bpf_helpers.h | 61 +++++++++++++++--------
>  1 file changed, 41 insertions(+), 20 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 73071a94769a..212ec564e5c3 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -358,6 +358,7 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>
>  #if defined(bpf_target_x86)
>
> +#ifdef __KERNEL__
>  #define PT_REGS_PARM1(x) ((x)->di)
>  #define PT_REGS_PARM2(x) ((x)->si)
>  #define PT_REGS_PARM3(x) ((x)->dx)
> @@ -368,19 +369,35 @@ static int (*bpf_skb_adjust_room)(void *ctx, __s32 len_diff, __u32 mode,
>  #define PT_REGS_RC(x) ((x)->ax)
>  #define PT_REGS_SP(x) ((x)->sp)
>  #define PT_REGS_IP(x) ((x)->ip)
> +#else
> +#define PT_REGS_PARM1(x) ((x)->rdi)
> +#define PT_REGS_PARM2(x) ((x)->rsi)
> +#define PT_REGS_PARM3(x) ((x)->rdx)
> +#define PT_REGS_PARM4(x) ((x)->rcx)
> +#define PT_REGS_PARM5(x) ((x)->r8)
> +#define PT_REGS_RET(x) ((x)->rsp)
> +#define PT_REGS_FP(x) ((x)->rbp)
> +#define PT_REGS_RC(x) ((x)->rax)
> +#define PT_REGS_SP(x) ((x)->rsp)
> +#define PT_REGS_IP(x) ((x)->rip)

Will this also work for 32-bit x86?

> +#endif

<snip>
