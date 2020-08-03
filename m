Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B673B23ABD5
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgHCRv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgHCRv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:51:58 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B69C06174A;
        Mon,  3 Aug 2020 10:51:58 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id q16so18345775ybk.6;
        Mon, 03 Aug 2020 10:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zov5dEZO0T2PVM9hra9gcoUzbtm6KiRFFoKFPBFxRqE=;
        b=FQykHsAuev6naMHAh6CV8ZiEGjr46SwfUCqaYatf67URcqfvEWNL1jG9SZhNQ4NnVs
         yRq2rXh3wEVcZPrr/0rU8w6kz0gbvnANfgKNU0bQBiPiXQ4/hvLbY3P4jQszuEljfOOT
         9kdkMiotnCrfglMWbLSrZ+M5X9Z8D+Q49SRDhJKz8UPqsoIocsxUUApG8uzJjRIS7AIf
         TIsmOR2LSe+KswDfIkvAi1EISNy/lqwJPt/phE2WSVV1t2xmsZHmh2N9hv5VA2/Le4iA
         ban6c7euza4/ZTlmEM0r8QtTo6k3QmvYSs3hPmC5IkPxlqVg+K19hHumydGN4/YSA9tR
         KD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zov5dEZO0T2PVM9hra9gcoUzbtm6KiRFFoKFPBFxRqE=;
        b=AwS7qrIpJZ8rxDNuu6GYgXF1n+3uMERT0yOGQISNxkMbN/a4CY35O/m7Y+JvkoD/Hy
         hNg/UnbxJBVK9YgM8Ahhpb+aCjSqEsoBGaH4oi447B1x29fQdFIRJ3NxEkqsYdZ9M1BA
         k5dzxAEzVxSNRb5HUwB7wnbmuwEZSCsF26QzyXFuBkqYEhR+1NNXJouUpHLwYy8sA7De
         YaUx3oRj7MZgbDMRmKbsOIhxGz5Cu1605OInkiDBvaC4+kYETetNUgnfgciKkUO1AipX
         c1Z8apQiWi7teMPaNX+C86yG88FnuodFkaydZ7ppStOLE5rgfyiFZ5J7UkY/ko3VWS2q
         G3Sg==
X-Gm-Message-State: AOAM530255kraY/5oJZdQjCXc5ZRonvENJcY67I+RaKzumAe+hCGN54H
        1dtjXsesXGH9bTBuWgmIuHUr7CF7yboaSbmQD4E=
X-Google-Smtp-Source: ABdhPJzbga1cip6psgKQPpnbgWWsVwHg+CANLBVKRrv4zd54cIJ5ajVk+DpfgrADTG6uwh13381C1kNRMmh53JM6O1E=
X-Received: by 2002:a25:9c06:: with SMTP id c6mr27849568ybo.403.1596477117300;
 Mon, 03 Aug 2020 10:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
 <20200802222950.34696-4-alexei.starovoitov@gmail.com> <33d2db5b-3f81-e384-bed8-96f1d7f1d4c7@iogearbox.net>
 <430839eb-2761-0c1a-4b99-dffb07b9f502@iogearbox.net> <736dc34e-254d-de46-ac91-512029f675e7@iogearbox.net>
In-Reply-To: <736dc34e-254d-de46-ac91-512029f675e7@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Aug 2020 10:51:46 -0700
Message-ID: <CAEf4BzY-RHiG+0u1Ug+k0VC01Fqp3BUQ60OenRv+na4fuYRW=Q@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 10:41 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 8/3/20 7:34 PM, Daniel Borkmann wrote:
> > On 8/3/20 7:15 PM, Daniel Borkmann wrote:
> >> On 8/3/20 12:29 AM, Alexei Starovoitov wrote:
> >>> From: Alexei Starovoitov <ast@kernel.org>
> >>>
> >>> Add kernel module with user mode driver that populates bpffs with
> >>> BPF iterators.
> >>>

[...]

>    CC      kernel/events/ring_buffer.o
>    CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/bpf.o
>    CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o
> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.=
c:47:0:
> ./tools/include/tools/libc_compat.h:11:21: error: static declaration of =
=E2=80=98reallocarray=E2=80=99 follows non-static declaration
>   static inline void *reallocarray(void *ptr, size_t nmemb, size_t size)
>                       ^~~~~~~~~~~~
> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.=
c:16:0:
> /usr/include/stdlib.h:558:14: note: previous declaration of =E2=80=98real=
locarray=E2=80=99 was here
>   extern void *reallocarray (void *__ptr, size_t __nmemb, size_t __size)
>                ^~~~~~~~~~~~

A bit offtopic. reallocarray and related feature detection causes so
much hassle, that I'm strongly tempted to just get rid of it in the
entire libbpf. Or just unconditionally implement libbpf-specific
reallocarray function. Any objections?

>    CC      kernel/user-return-notifier.o
> scripts/Makefile.userprogs:43: recipe for target 'kernel/bpf/preload/./..=
/../../tools/lib/bpf/libbpf.o' failed
> make[3]: *** [kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o] Error=
 1
> scripts/Makefile.build:497: recipe for target 'kernel/bpf/preload' failed
> make[2]: *** [kernel/bpf/preload] Error 2
> scripts/Makefile.build:497: recipe for target 'kernel/bpf' failed
> make[1]: *** [kernel/bpf] Error 2
> make[1]: *** Waiting for unfinished jobs....
> [...]
