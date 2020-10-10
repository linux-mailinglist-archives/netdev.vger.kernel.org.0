Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B3028A49E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgJJXzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 19:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgJJXzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 19:55:20 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C90C0613D0;
        Sat, 10 Oct 2020 16:55:20 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x20so10338706ybs.8;
        Sat, 10 Oct 2020 16:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nm+Da4YVhQgQInAhJML77NLPrMfQc4QCCExgxRH4iWc=;
        b=HVsQlCZsKisdyP7iZ+g8lZb5yQ8etVuW1sTtGvdrkQ1a/zTfyZcarONBzp5GBTeHuf
         X3dHdLKhRIeYHk7SA92SOD2CK7roK9wc1eO9c7DUfKOArep4ENlu3WYj2pF1Tb5JCTBA
         SPqe0EAa79KpCveBeaHD0PBXG5f24xqPX6L/prYzRIfab1E/NbmShWYvQ0gC1vbH7uO+
         GFnFLreCvCT+ZJ9ndX5JqicUm0FAUaAv+y4Z4nQf36N8P6NXka/G7RdtWCQbCn3PIEWU
         JE8kXUftu9Uyw93b/OzlHVjN0EQFrfL+f5uoHG5kQITGpw+zE/t5synbak2pPOmUQafH
         rokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nm+Da4YVhQgQInAhJML77NLPrMfQc4QCCExgxRH4iWc=;
        b=pWBuaaM1/NBjdbOTBFoGtbMn++oW6/+SzH9n/LhGjBdo1lBFyE3wzWdiT3jJ6FD//F
         RWlDlylFfW4tncVb2HX1n2sedJcjXPGDIEhQml6oMnPa706P6WHpr8+mmNw9T/Lp0BK+
         26dC0RilKAo9vtYHPCLn8EpPWQnMV58B0uA4VF3A0hGGD8kJUaae22qt9C71cE73TNoE
         w1qtuguOtB2T4IB2D8y3UQLP6jl0Sgt38gEZPqSuCRgI6bDLIw20MZIH2cVwyboBuspH
         OtW2r4JksF2kZd0EojtuG+Tiq43fFO6XMClp+BktFEKJYJfKyIMN11j6kwJw/jG1m01M
         EkpQ==
X-Gm-Message-State: AOAM530Q8tHHFcmBvDG8wKzLiaU72ZhepOXuWgRgvrBV7on56uRC/6pm
        VUY05rp7b+Fq/orNvNe5fLKOeqc8B0tSDlyZfEU=
X-Google-Smtp-Source: ABdhPJycPDPkRutENa5v9cJd1bnsdewvFB6SUwRdbL77/nqtdut8hMT7RKPP3rjdfAHh8UsMJ49lgNhoC3NAaW2Y//w=
X-Received: by 2002:a25:8541:: with SMTP id f1mr22832474ybn.230.1602374119377;
 Sat, 10 Oct 2020 16:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201010181734.1109-1-danieltimlee@gmail.com> <20201010181734.1109-3-danieltimlee@gmail.com>
In-Reply-To: <20201010181734.1109-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 10 Oct 2020 16:55:08 -0700
Message-ID: <CAEf4Bzbw5TOkbQMOv99ONc374yp9xVXAKnGZAnwCw=TUro0wsA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] samples: bpf: Replace attach_tracepoint()
 to attach() in xdp_redirect_cpu
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 11:17 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> From commit d7a18ea7e8b6 ("libbpf: Add generic bpf_program__attach()"),
> for some BPF programs, it is now possible to attach BPF programs
> with __attach() instead of explicitly calling __attach_<type>().
>
> This commit refactors the __attach_tracepoint() with libbpf's generic
> __attach() method. In addition, this refactors the logic of setting
> the map FD to simplify the code. Also, the missing removal of
> bpf_load.o in Makefile has been fixed.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---
> Changes in v2:
>  - program section match with bpf_program__is_<type> instead of strncmp
>  - refactor pointer array initialization
>  - error code cleanup
>
>  samples/bpf/Makefile                |   2 +-
>  samples/bpf/xdp_redirect_cpu_user.c | 153 +++++++++++++---------------
>  2 files changed, 73 insertions(+), 82 deletions(-)
>

[...]

> @@ -986,6 +975,8 @@ int main(int argc, char **argv)
>
>         stats_poll(interval, use_separators, prog_name, mprog_name,
>                    &value, stress_mode);
> +
> +       err = EXIT_OK;
>  out:

This one doesn't call bpf_object__close() as well, but let's land your
refactoring and we can do further improvements in the follow ups.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>         free(cpu);
>         return err;
> --
> 2.25.1
>
