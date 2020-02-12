Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B457159E29
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 01:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgBLAkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 19:40:41 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38606 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbgBLAkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 19:40:41 -0500
Received: by mail-qk1-f195.google.com with SMTP id z19so434098qkj.5;
        Tue, 11 Feb 2020 16:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ovwl2vuwE1yo3QeWgEUcWqPGOcOsa2AkedSozSYzlDU=;
        b=mDjCsE4A42zFUSm3fSfbc1iXHbSwDW+Icvl+l/Mb4gxF89oLPG9i8LGj6d7dE8TGZu
         bNh/GIc465IB/QvR3/tCAw37Sn0YL1Dge6yQj1nHrsp3q6diysvaopHCbCD7LviRrp0Z
         tXEXRw+PfLDyr6A/qSOCpYp6Pzs8BjyrQBqieHnf46MWZMBAAZDGz3Swds4xxM2u6OH8
         AXvWbMbMeiSqjAqNpUEMeGKFfFQ7ukFieTax4gWdLE3yCZnEGBLTrtS8j/+13qJjq7UN
         ex2SxVDMEMeI5iMFOyD/PBr+z/z81TV4uzxN461lBXdw2yjH9FQh+lPGc1wvb1ISUv6a
         gU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ovwl2vuwE1yo3QeWgEUcWqPGOcOsa2AkedSozSYzlDU=;
        b=naWkhzJjYkeaoHSPbLLS2AfB7hkZ0p8pJa0r797u2rXHbFf0JOKhYkhOVYke8J7wG0
         sQDxIVmuHDcUll6RYAxJUYQPgCQcIA1hhT177Ic+LzGCq0f7IW/38+xTQOQgNh3Gj0qc
         EtaxoSw7/ke3uBoE5nILQQ0OIUFbyyYHAl+x/GkMyUj8MAUENH80Y1s5PS4k7vIRhZWJ
         sVQq1Yn6DjxdYoKQZ0VVNsOo+sdOGNlxSKdaYzqnRDn6B+DK7OXIaReZYHtC84bU7naN
         fmkbWKFO2rOgb/1h+MIDS9FM0PyE0DBZ37y2UPg9IC2yniHZw211YfqGdszg9TAU1uLR
         CmaA==
X-Gm-Message-State: APjAAAW7rGqEgHmqkWIXlaKP7GwPlFUQhyLltIxT89fSE/f5xWfqZHi0
        QgHScHFwvZEp33v2DmbJQvlgq5pM/tk23HNaRGjWrg==
X-Google-Smtp-Source: APXvYqyVTmCDjqebixa1h/v7f83yriw7n4UMSJ1P4asNNRx0JnyflePKSLrfxaHviALQQB74mhpKyMsY/QdR8MQe5w8=
X-Received: by 2002:a37:785:: with SMTP id 127mr8868025qkh.437.1581468040201;
 Tue, 11 Feb 2020 16:40:40 -0800 (PST)
MIME-Version: 1.0
References: <20200211175910.3235321-1-kafai@fb.com>
In-Reply-To: <20200211175910.3235321-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Feb 2020 16:40:28 -0800
Message-ID: <CAEf4BzaVAH9+y2m7p-GZk2hx+P_WdyLcku4evOKCeudNYrRd5Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: selftests: Fix error checking on reading the
 tcp_fastopen sysctl
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 1:32 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> There is a typo in checking the "saved_tcp_fo" and instead
> "saved_tcp_syncookie" is checked again.  This patch fixes it
> and also breaks them into separate if statements such that
> the test will abort asap.
>
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/select_reuseport.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> index 098bcae5f827..b577666d028e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> +++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> @@ -822,8 +822,10 @@ void test_select_reuseport(void)
>                 goto out;
>
>         saved_tcp_fo = read_int_sysctl(TCP_FO_SYSCTL);
> +       if (saved_tcp_fo < 0)
> +               goto out;
>         saved_tcp_syncookie = read_int_sysctl(TCP_SYNCOOKIE_SYSCTL);
> -       if (saved_tcp_syncookie < 0 || saved_tcp_syncookie < 0)
> +       if (saved_tcp_syncookie < 0)
>                 goto out;
>
>         if (enable_fastopen())
> --
> 2.17.1
>
