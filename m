Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CDF1962B9
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgC1Av7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:51:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34234 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgC1Av6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:51:58 -0400
Received: by mail-qk1-f196.google.com with SMTP id i6so12911906qke.1;
        Fri, 27 Mar 2020 17:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gW8Us07p34tKNr5q6DX8s4W0HyAUjAC+n0HPSZjJ2sg=;
        b=Ac+lQPMNGYardQr60q70ftCnkyAW63aygWK4m0tour2xpDekE68hcHroV83+YOvQfd
         EIKOU1+MVvWKqoaYeIREj9bvgnOYOk+sOQLHfh2uP5hYn3ZXwoOm8aihm7Dsf+Ip6t5Y
         xh8E1ASHN+0JQweaDRXe0/G5U5BhIiuO00xWcR+L8ZPq/dPTuczC9R5bUbnMT7+8t96W
         QVdIRN9llWJ1U4fMeCriudsD3k8iHBu8ehZzuhRpSlKFJaJETcO89gS8oIAxgQ/ih7ks
         IfV04oCRr32DSi+F1qAVIrBUp5LifVte9WBmG8TPSENGi266Xbt2YPlLypolV8pf4UF3
         bKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gW8Us07p34tKNr5q6DX8s4W0HyAUjAC+n0HPSZjJ2sg=;
        b=oBNshp+QzkSANen30bnldH+v6/V2WjhEKncMYEp5sihYe8StX2cKkT+BeFY4FS27bZ
         2NKZWc2lq1BEJMJGTTdl26gV/yz/2OuzExqFXB74NMgD3oF2IVMRPuqlux2sRcvQKUXy
         O478ecIbo4sv1P4N11U3yaih5Pl//8NlZSMDmmSGUKy9n3Vf657yye2PyLlYX5A8mu2n
         fHOrHaZQXhJcWkMy1uvgAGl1MCcJOlmzB6eHlmIq0a+QHrZz/VQA2TLH0h5R1ZTvCmf/
         8pR4heIAdVZ1O6PeUs5tXex9Qobs/pX9VesD5Q5kU8AqMiXRNUef1c5dd7wC4ygWWDh5
         /24w==
X-Gm-Message-State: ANhLgQ0KXjeYT7zA9z1YK1OG87jRFHaijyGzAsbfNmNtyi7Dy/GMEOx+
        fY9umnDKX5NeM8UjKixTBnjj9qqRiIUDdMEXMh8=
X-Google-Smtp-Source: ADFU+vuWY1uRpKQYpPfB/Q5Nq7ZPVY25HmRzy7fj5SC7KN4sJD8G9pUEwk1oM/n5kygBTkeMNPH/IT/76ymOjhQJ//4=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr2142216qka.449.1585356717654;
 Fri, 27 Mar 2020 17:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585323121.git.daniel@iogearbox.net> <c74758d07b1b678036465ef7f068a49e9efd3548.1585323121.git.daniel@iogearbox.net>
In-Reply-To: <c74758d07b1b678036465ef7f068a49e9efd3548.1585323121.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 17:51:46 -0700
Message-ID: <CAEf4BzbEMVBMhN7cOCxzQ84wRXK3Um1Pc=gi_C7-GQ8WLpz+Uw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/7] bpf: add selftest cases for ctx_or_null
 argument type
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 8:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add various tests to make sure the verifier keeps catching them:
>
>   # ./test_verifier
>   [...]
>   #230/p pass ctx or null check, 1: ctx OK
>   #231/p pass ctx or null check, 2: null OK
>   #232/p pass ctx or null check, 3: 1 OK
>   #233/p pass ctx or null check, 4: ctx - const OK
>   #234/p pass ctx or null check, 5: null (connect) OK
>   #235/p pass ctx or null check, 6: null (bind) OK
>   #236/p pass ctx or null check, 7: ctx (bind) OK
>   #237/p pass ctx or null check, 8: null (bind) OK
>   [...]
>   Summary: 1595 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/testing/selftests/bpf/verifier/ctx.c | 105 +++++++++++++++++++++
>  1 file changed, 105 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/verifier/ctx.c b/tools/testing/selftests/bpf/verifier/ctx.c
> index 92762c08f5e3..93d6b1641481 100644
> --- a/tools/testing/selftests/bpf/verifier/ctx.c
> +++ b/tools/testing/selftests/bpf/verifier/ctx.c
> @@ -91,3 +91,108 @@
>         .result = REJECT,
>         .errstr = "variable ctx access var_off=(0x0; 0x4)",
>  },
> +{
> +       "pass ctx or null check, 1: ctx",
> +       .insns = {
> +               BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
> +                            BPF_FUNC_get_netns_cookie),

nit: seems like it deserves its own helper, e.g.,
BPF_CALL_HELPER(BPF_FUNC_get_netns_cookie)?

> +               BPF_MOV64_IMM(BPF_REG_0, 0),
> +               BPF_EXIT_INSN(),
> +       },
> +       .prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
> +       .expected_attach_type = BPF_CGROUP_UDP6_SENDMSG,
> +       .result = ACCEPT,
> +},

[...]
