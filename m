Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8966AE5720
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 01:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfJYXgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 19:36:35 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34220 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfJYXgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 19:36:35 -0400
Received: by mail-qt1-f194.google.com with SMTP id e14so5846066qto.1;
        Fri, 25 Oct 2019 16:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KzbHASUfFjFi6cCngAYQn1nY75Dph3P1r3I7Eawc/sg=;
        b=bueBv8+gHPWAJlKRPBog44DIAkCsnUu6wyH5c7bt6XNqJPvvRYHIUDbmMKkClZrath
         CkZ5W4pvqiRnen8T3XBOe12oE3nXTHU597wuOFCxM1efGEjbXEFbNGlsX93iMB7n8yh2
         9a9Sv1JaFOmLpF0Q2XokcWgqXAvEvhQrkAijIc7RRCDpD8yTQpdJePuOnkSQ8Ag2506N
         qtd3dk1xc3fyY/PqR9vTiG3n0vJrt5XxOTHjnEyMv78f6OgQsxIV6u/4gTL8XU6QIVUV
         YeCa+IpKBrNeAgEYhPkm0I3kwc2AOaJc5EIthwjzBtlf38eWgukJL2czpkZHWxTD7Pdy
         HqWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KzbHASUfFjFi6cCngAYQn1nY75Dph3P1r3I7Eawc/sg=;
        b=IeHsidvBt2Q9IzmmMjDXg7i8DH8oz295KEA2jLPgzGYTfqBJj/H5lpKQ+CSZ5+yfcA
         UPWzzIXEwNZt3SaomcuBiud2EQnbsSzOwKH88aYZl0kCNGGkDQdDt77geQrHD4fYWoCA
         ToV6ACTCNzNW2w8NWp7YAtpcip4afphBCUqvnYWEmgKDkoFF9x8oYjdxio7SH/xt1/pM
         L3WEfykbrJHcNOuJ3TMV2yqoVJs80cDW9xeRfnmm//2OKqV+9ai4GynGVcHCm267dCIz
         RNdjinVf1dHkbqSS/nJjZZZpTCipmhOGBp5M0fm9tn5UG+1INweOn/0moKKJGBYWp8QP
         SWpg==
X-Gm-Message-State: APjAAAXKHczMT1OdmGUqyQNauswjXP3W8CNUIs3DSWvSe6W7Vz4dmZSs
        KQKWoM6aaYcfk6Gsozczs0Rzxdo0CCgz7jKkZrY=
X-Google-Smtp-Source: APXvYqwhSKKETawW5BvKo5rIoZcD1fRKpPrczKdeSAVsdMQ4DEXJeoFREZmTLFGgdgN8PtYr9KHNcPq6A4aL4bDYbwc=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr5781746qtj.171.1572046594405;
 Fri, 25 Oct 2019 16:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <19ce2c58465c5fab4c94f23450a8b8d5016a35bb.1572010897.git.daniel@iogearbox.net>
In-Reply-To: <19ce2c58465c5fab4c94f23450a8b8d5016a35bb.1572010897.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 16:36:23 -0700
Message-ID: <CAEf4BzZxFpk-HbS-dZyYDfDviBu8j=fqiCxb-Y_D0EDOSDmoig@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] bpf, testing: Add selftest to read/write
 sockaddr from user space
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Tested on x86-64 and Ilya was also kind enough to give it a spin on
> s390x, both passing with probe_user:OK there. The test is using the
> newly added bpf_probe_read_user() to dump sockaddr from connect call
> into BPF map and overrides the user buffer via bpf_probe_write_user():
>
>   # ./test_progs
>   [...]
>   #17 pkt_md_access:OK
>   #18 probe_user:OK
>   #19 prog_run_xattr:OK
>   [...]
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/probe_user.c     | 80 +++++++++++++++++++
>  .../selftests/bpf/progs/test_probe_user.c     | 33 ++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c

[...]
