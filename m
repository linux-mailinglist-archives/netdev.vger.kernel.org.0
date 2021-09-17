Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815D5410085
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244434AbhIQVHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbhIQVHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:07:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7131EC061574;
        Fri, 17 Sep 2021 14:06:21 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso4158024pjb.0;
        Fri, 17 Sep 2021 14:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=grvrN1OjbFpYmPR/aJANz9dhN1THUaM/iZ3DQxSLkNg=;
        b=WGJd6ACNmuU/uk+BBWIMxA2LSsGb5am1nUcE9qwiD4tLYcoCL+mfe9k1DGYuefWqPw
         V5hpQV480rTfLb+RKnlxVJ3/XCLlQFzJYuRepilpk1IXw2COa6DRo3+l5J7iIJDSxUJP
         /mMyjW6mTRd1FJFTJEhju9Sxtr4iTc94zKhR8kU4YaaYo8fAftGY714TH/WFeP1CGXoq
         BB7g7gRUGOFYFDqSuCwy2UGa3PaDLbLFk13Bgja1IRaJ51BN7uvWp3er/SjnWHFn98FI
         o8Np0fxKXHkuNydv3qwWOgCquUuVOgqncQs6ot4C/WLKPP9I3J9LNayhZsUjxlO/T7rH
         SS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=grvrN1OjbFpYmPR/aJANz9dhN1THUaM/iZ3DQxSLkNg=;
        b=G2LI5dc/7qgpmmf/qCqIbHmRhNbR/fRZoO5ZOAcEKT+gcuLW8bhI9LwgzOz8BEnuZP
         aZ34TXvtGK545ejPKS29BxM6r722Bl/nsGWQcaS1PL0v7fB+V/pR0hY41ZLki/vC1SjF
         9aiOAWUfnItrZPV2A2fNgqDer2kwRQ/mnMw7cS5Zq9XRwf6/hlfJvQXewYDYtcMg+3K8
         j82MNWHKVIA5OMvPdlP4lIFs4oOCenSmnNcSZJspYnsSZFahhN4PvsIRAhrz0yk+MnfV
         Sm4BsQlyzUQNtvX1wCxPatJadlAB6V5UrOvkkLR2FOF3MoC8+XdNWd+Pk1y19XcJaY5M
         izzQ==
X-Gm-Message-State: AOAM532lf29fuFTfUXX9Gl6IqRUtgGumNEWR/dPy4Zls/6fgTUoHcDGI
        rnEN0NmvKnh859LBLgWXgp+vnk0D6QnvEwiaRWOzDNIw
X-Google-Smtp-Source: ABdhPJz6/cFFKFxivvGRuycFeH3bPGjqfEX1QstuIqggG5S1Pe83ULSRlLkfnSLReMDJOfJv57MPKIZ3munSa62ZsqI=
X-Received: by 2002:a17:902:7246:b0:138:a6ed:66cc with SMTP id
 c6-20020a170902724600b00138a6ed66ccmr11559646pll.22.1631912780831; Fri, 17
 Sep 2021 14:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210917182911.2426606-1-davemarchevsky@fb.com>
In-Reply-To: <20210917182911.2426606-1-davemarchevsky@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 17 Sep 2021 14:06:09 -0700
Message-ID: <CAADnVQKZ0Wqz-DGwghk1UfrNXCZkoM0n5fLgx1MvC-=OdYUmBg@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 0/9] bpf: implement variadic printk helper
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 11:29 AM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This series introduces a new helper, bpf_trace_vprintk, which functions
> like bpf_trace_printk but supports > 3 arguments via a pseudo-vararg u64
> array. The bpf_printk libbpf convenience macro is modified to use
> bpf_trace_vprintk when > 3 varargs are passed, otherwise the previous
> behavior - using bpf_trace_printk - is retained.
>
> Helper functions and macros added during the implementation of
> bpf_seq_printf and bpf_snprintf do most of the heavy lifting for
> bpf_trace_vprintk. There's no novel format string wrangling here.
>
> Usecase here is straightforward: Giving BPF program writers a more
> powerful printk will ease development of BPF programs, particularly
> during debugging and testing, where printk tends to be used.
>
> This feature was proposed by Andrii in libbpf mirror's issue tracker
> [1].
>
> [1] https://github.com/libbpf/libbpf/issues/315
>
> v5 -> v6: Rebase to pick up newly-added helper

Applied. Thanks!
