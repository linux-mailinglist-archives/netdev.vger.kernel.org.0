Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7844164F6A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 02:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGKADi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 20:03:38 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:32801 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbfGKADi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 20:03:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so3433896qkc.0;
        Wed, 10 Jul 2019 17:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcagef65c04aERdHDZCmK5MH6YmpVVzcpkdhaNDNo5o=;
        b=C1XfdLqd5hKBMQEnUz4tGu4Ywf7IJdfVwTMvq/YrfYcAI75lVOzsVZIDgCEncN6mCU
         gkJprzkHoq5qTkSNZXVrziOzdxuQEZamT5Ff6EyjTpK2RP+fXwFu/F5mWbUwk1ejicoY
         GrYNWDyYGyPUVk3fsZkSelgOO8DFMDPgSGmjPdc8NC3uNDfFJGLe7kR4x8U184oU/Xut
         gBkBfGULn/gx7CHLkn6stkOEQERYv92gVBGnTCp+pW+7aYQcKScoCm1fyvDqxVhIcPxQ
         wpnTwGcKuFBZq8COA1WVRhh9nV1/Jl1Nc0N7FmZUZVsqS4bL9hf9SxXHmBdOm94znJpo
         Ed9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcagef65c04aERdHDZCmK5MH6YmpVVzcpkdhaNDNo5o=;
        b=G5hLo3ZxQvMPTWl3Tydux5h7HWK/Pi/WLAgMJ/QZpjxOknTI+J3t89aThkq84TyNn3
         p3tBU3w+TZLJoyVyFYnr2hfNXYYBq/XljQ9k5UEwPl+clurWUU1KowOQDwH37IUtms8L
         6xfgLSQ5EC/0htm9WdYNS0cYz7kpTJ0YQROuNShXiXcDQQfLUJnqIGM8tmHq1qMFs0O+
         /pyzIHTUFip2FXOA544WuoM2GMPRLVN39SxC3xW0ZY8ibDAkBfSL/QokrtlI9uzDnXEH
         9KPgXg//y9+Mq5Xa50EIkXo8dVeUucm/AykJ0ROEXDYfVaYBAH08q7Jr2JhPqlqRmLXz
         SjfA==
X-Gm-Message-State: APjAAAVyuqSxpxxL2O0MB+Leh4hwRAFDjIC6XuZmvIxPCP8czCs0nV3v
        VbqKZiTOA4IsVwJ1T5UewjOpqwrruiGTxgyYyY0d2hWWOZbTQw==
X-Google-Smtp-Source: APXvYqxaaPVmCJKGYrqtpwvraL1EswjCeJsS/XSCyFmDnYfbnnDLpm+8b9JquD0m7SIWIVbBy4B0yNf0+FZAo6p9xak=
X-Received: by 2002:a37:660d:: with SMTP id a13mr801660qkc.36.1562803416832;
 Wed, 10 Jul 2019 17:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-5-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-5-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 17:03:25 -0700
Message-ID: <CAEf4BzZoOw=1B8vV53iAxz8LDULOPVF-he4C_usoUQSdXU+oSg@mail.gmail.com>
Subject: Re: [bpf-next v3 04/12] selftests/bpf: Use bpf_prog_test_run_xattr
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:43 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> The bpf_prog_test_run_xattr function gives more options to set up a
> test run of a BPF program than the bpf_prog_test_run function.
>
> We will need this extra flexibility to pass ctx data later.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---

lgtm, with some nits below

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index c7541f572932..1640ba9f12c1 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -822,14 +822,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>  {
>         __u8 tmp[TEST_DATA_LEN << 2];
>         __u32 size_tmp = sizeof(tmp);

nit: this is now is not needed as a separate local variable, inline?

> -       uint32_t retval;
>         int saved_errno;
>         int err;
> +       struct bpf_prog_test_run_attr attr = {
> +               .prog_fd = fd_prog,
> +               .repeat = 1,
> +               .data_in = data,
> +               .data_size_in = size_data,
> +               .data_out = tmp,
> +               .data_size_out = size_tmp,
> +       };
>
>         if (unpriv)
>                 set_admin(true);
> -       err = bpf_prog_test_run(fd_prog, 1, data, size_data,
> -                               tmp, &size_tmp, &retval, NULL);
> +       err = bpf_prog_test_run_xattr(&attr);
>         saved_errno = errno;
>         if (unpriv)
>                 set_admin(false);
> @@ -846,9 +852,9 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>                         return err;
>                 }
>         }
> -       if (retval != expected_val &&
> +       if (attr.retval != expected_val &&
>             expected_val != POINTER_VALUE) {

this if condition now fits one line, can you please combine? thanks!

> -               printf("FAIL retval %d != %d ", retval, expected_val);
> +               printf("FAIL retval %d != %d ", attr.retval, expected_val);
>                 return 1;
>         }
>
> --
> 2.20.1
>
