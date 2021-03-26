Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B38834A00B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 04:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCZDD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 23:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhCZDDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 23:03:40 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E1BC061761;
        Thu, 25 Mar 2021 20:03:40 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id g38so4398770ybi.12;
        Thu, 25 Mar 2021 20:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sNlIQphRGrr6cRggbPFiNOSnzY2c84dt0y88urvI0JE=;
        b=X27GRIeUb3eSwS/MgD66l3z/ET/AgZH7wejdMPUAvZmWUbiYrv8rbgWDg3GGikSj/o
         c7yPx7BwQK0zyD7yuBVpO/SQl7UMmHRB46m3aSN7Z9gajo0md4RnPXn7LMpNuKu1OMmk
         JFeK2HUqSvEJl0INSCBGmBCLG/Gfu0PEBIjC1pSRaPVUCfKnPiArB+rTl5DmPHpBGMHy
         VmbZS1LZoHaz2mvyC6QTpTd+bA3tQw+TnXr4M6WaKwgGbMF/kq/ONOPvhTmfEG0T8fqM
         qfvQ3LLaGsuXZe3HR4iE7oHbTUp14te2EPxi2JWJ7RFiwOqjWj1YvV8uY6eE/KFesm/a
         CTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sNlIQphRGrr6cRggbPFiNOSnzY2c84dt0y88urvI0JE=;
        b=t7Eycc0LgY3owpWU+RUj3U/O2jXpQpESTUAZ/ZJ0zk7EX0lh1gQwNCjgHPTezBKUpJ
         fVWbLXVKSo332/2dz0NBwe12Z+fz9JK8a21vGkrwbgWsgTYzGehtlTNCTcWay60xiYRW
         f7k1dVkcJ/ugTPsbKPuEX9oLvJP5/+KtZ0Fwh6JA8FmUuZa7Z7d30xrh4r7kgGht7JKI
         mwXa3OwJtptTjwYBaU1zX1Y8oqbIx3G2D0TIwuILto5G1dZIuZHPAu4HBhs1db/5jfr+
         uevdWarbOEjwAcr7JUbgj0bdlk5QqKMHGWjo3HeWBblBo5s4/iwb2VavGQVjE5fhV2+q
         OhYQ==
X-Gm-Message-State: AOAM531L6y+c1voHO9yKC/RHPKpDZaloQEhRrWC61qx+YPsho4gcZBzB
        Bo/l0JTGC37Cvq9QMxapxD9uMw4MPuEGWBfad6s=
X-Google-Smtp-Source: ABdhPJx4pAUFdUbbs24Up2QCj3ScMj+P/MgNi9g87WGKSQv6AnT1WbeM/0LJhudgHL9YM7PuXzB36FXOwxnw5iAJJWY=
X-Received: by 2002:a25:ab03:: with SMTP id u3mr10324206ybi.347.1616727819875;
 Thu, 25 Mar 2021 20:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <161661993201.29133.10763175125024005438.stgit@john-Precision-5820-Tower>
 <161662006586.29133.187705917710998342.stgit@john-Precision-5820-Tower>
In-Reply-To: <161662006586.29133.187705917710998342.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Mar 2021 20:03:28 -0700
Message-ID: <CAEf4BzZr8fZjxyki4CauU3qZ-Xac_B7jJ4STaJPwTZhYSqN1AQ@mail.gmail.com>
Subject: Re: [bpf PATCH] bpf, selftests: test_maps generating unrecognized
 data section
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 2:07 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> With a relatively recent clang master branch test_map skips a section,
>
>  libbpf: elf: skipping unrecognized data section(5) .rodata.str1.1
>

So it was on my TODO list for a while to get rid of this by combining
all .rodata* sections into one at load time. I even outline that in
"libbpf v1.0" doc ([0]). I just haven't gotten to implementing this
yet. You can safely ignore this for now. But I also have nothing
against cleaning up tests, of course.

  [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY


> the cause is some pointless strings from bpf_printks in the BPF program
> loaded during testing. Remove them so we stop tripping our test bots.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> index fdb4bf4408fa..0f603253f4ed 100644
> --- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> +++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
> @@ -16,10 +16,7 @@ int bpf_prog1(struct sk_msg_md *msg)
>         if (data + 8 > data_end)
>                 return SK_DROP;
>
> -       bpf_printk("data length %i\n", (__u64)msg->data_end - (__u64)msg->data);
>         d = (char *)data;
> -       bpf_printk("hello sendmsg hook %i %i\n", d[0], d[1]);
> -
>         return SK_PASS;
>  }
>
>
