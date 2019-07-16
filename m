Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D956AB28
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 16:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387758AbfGPO5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 10:57:17 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45703 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfGPO5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 10:57:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id s22so14795560qkj.12;
        Tue, 16 Jul 2019 07:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BgJZu+NFX+3jW29/vzjk0xHEUBkPIVmYlV4knfrZMYY=;
        b=hgEn46oZ3bHawcazIGOWXHJp3ac7X5lJf2TkApVies62XXejcmrCpK27KLi5gt7PQC
         KeaPYKm3uB7OaD7kuzebXBqKLb0NTdwpMQ1f+1bdm5UWsFnj94wrbGk9Mu6q6Qj7PE6E
         Fu00YJXqrWr9jvx8Lp0vbSLd3CPUhnr0gQtxXtbiTb8EhUGAacHwswIH+uH+8jHUMrzx
         fDCK/+os/ibtby/yswLq66gsv6YMhwFlsIhpXoDkLMlicQWldyai3YUrHls31w+sSKN8
         mUcvu4PcrwMPLbTISarBtzNFxJliyhffoeR59whhqcgP2tBi6pZO0788DwMwN5Vl1Et9
         y1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BgJZu+NFX+3jW29/vzjk0xHEUBkPIVmYlV4knfrZMYY=;
        b=pG1SuB2mdIUoU+M/it+UNkZU9paIz/syBGxr2ZOZYLr0041++RStfUH5mVQKcCdi+P
         aXyzw2MfyIJE7xL4sgaeD+pdkgIqhy3lpvhz9FY0B+eOX6j5FISQ+QIcYfERJFzIFFJ7
         fn/LYdmtaa/1+WDb89xaVQ5gSd3fI5TanoNY7PMCEUmkSuMvf5Lava7TYQap5VvksjvR
         kGqJzcjFtHZGBk3VFgBpc2tJOh/CT2KMZN/EuAxtK2mkClE1zHjOOEmouyCjaxbH2DDj
         b2gePrQOAlEyO9yLBEbn7Ino00jQE/YtXZAGpEHI6EyaKAyZT8txbYD4MdKYNGHepXlc
         5eKg==
X-Gm-Message-State: APjAAAXsFJwRZK7tuIBQHXbUYkKJ7OyRBvRf40nCGDiHKWB/ulcOS7sy
        4rT5X21z134/MbRlJ/i8gn4OdCAJZIifpuaYsI4=
X-Google-Smtp-Source: APXvYqzkDSEW1hkEpUcsLQ6eQGMS3XvP1qb9mygmQAuAhWWj9OAm/FFcdMlsjW3RnVUENlep93Cm85ypH1q1Uyh12os=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr22418264qkf.437.1563289035793;
 Tue, 16 Jul 2019 07:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190716105634.21827-1-iii@linux.ibm.com>
In-Reply-To: <20190716105634.21827-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jul 2019 07:57:04 -0700
Message-ID: <CAEf4Bzaf2Ys6H4h0rk6z+QhP-anonz=MBej5CaShXKL453MB4A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests/bpf: skip nmi test when perf hw events
 are disabled
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Y Song <ys114321@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 3:56 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Some setups (e.g. virtual machines) might run with hardware perf events
> disabled. If this is the case, skip the test_send_signal_nmi test.
>
> Add a separate test involving a software perf event. This allows testing
> the perf event path regardless of hardware perf event support.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

LGTM!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> v1->v2: Skip the test instead of using a software event.
> Add a separate test with a software event.
>
>  .../selftests/bpf/prog_tests/send_signal.c    | 33 ++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> index 67cea1686305..54218ee3c004 100644
> --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> @@ -173,6 +173,18 @@ static int test_send_signal_tracepoint(void)
>         return test_send_signal_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
>  }
>

[...]
