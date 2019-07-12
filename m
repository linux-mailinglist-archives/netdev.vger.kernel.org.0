Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D7D6631D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfGLAxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:53:17 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46669 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLAxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:53:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so6401784qtn.13;
        Thu, 11 Jul 2019 17:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yWKQwARdMcpvbwc42EaVVia65zSn+TZBr92VrKzSCNM=;
        b=HRbb5/dM31GQ9JGV+X9MZV+VPTaRNN8+QGzZtR/iMEtzNvFCi/DzlNKtk8QbBwon26
         gPYAIXESQPbnoIL8YoK+odlVfe5FCl7EUtN5FFbBmVhSA6ig3jV1agLUs/dN4p0PKelh
         jORP76uCuwRgWaVZBJ43pcnpHsoyLC8DShDqa28yFcCQreDfGUdXVC9AJTW4FP23C4ml
         d5YGrlYJEwbYIC1GRs7TVT66PLDBTSQBk/tH9JaRPDnHX2QBoIplNLshUghkxei082A8
         jht510MhuJbGjqjItNZGPvv14HYpcTTHtaQ2dt3uKIExbnAt/8zQLxBO9yJ27NHjVwxs
         HVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yWKQwARdMcpvbwc42EaVVia65zSn+TZBr92VrKzSCNM=;
        b=IxSSFHv2mgSmvWt4T9KPyO1VRnGHCXpAZyFK/t2lcBwWgHsfVY6g8TwUint/ptUS1C
         wdIMWqk2FQ3J0Q3FidaEaPj64a4cisOQW1+8ql05THBa8xvq5goQ6VsC5bs/BPv95dEM
         6CHkFFiH+iNs9tz3VDaXEgYS6+jt1KFb+xvEZ5fx6+56Up+XJgOA6NR4JljYwlUTrsO8
         LIO9RrXLk+QyIwDwXzsa/VMVFsr2/O03INKdHmKp1+56gWARgT0rvg7ts4QyF7YMOZk+
         oQbW2mLeqG0RSl8UzOoTkCE42rAYMtNaQ2rrvWNk4YbbBeoYXYjnCQm5WhQ7BHP4frsH
         fDCg==
X-Gm-Message-State: APjAAAVTj48paBC2QolHfK2N3158KJXtE8zJ+up1wdUDQ1FK5OUioAoI
        PUjv0bUj5VD98bgA0EnXRktTe2WDZENiqSO4tbs+lWM515/zcA==
X-Google-Smtp-Source: APXvYqx7PzqWa7KL+S/suXDKZqfaWVBb7it7k+kRuVVRfUdsCXgZAdAULDBwrdJsOs6cfaw/Hc+aJZk/399vp4jWFW0=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr4222945qta.117.1562892796502;
 Thu, 11 Jul 2019 17:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190711142930.68809-1-iii@linux.ibm.com> <20190711142930.68809-2-iii@linux.ibm.com>
In-Reply-To: <20190711142930.68809-2-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:53:05 -0700
Message-ID: <CAEf4BzYwwqn9ATwPyVcJ8nBQM+rvaFp7KBFjqbYY4GKda3G8jA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/4] selftests/bpf: compile progs with -D__TARGET_ARCH_$(SRCARCH)
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 7:32 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> This opens up the possibility of accessing registers in an
> arch-independent way.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 2620406a53ec..ad84450e4ab8 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> +include ../../../scripts/Makefile.arch
>
>  LIBDIR := ../../../lib
>  BPFDIR := $(LIBDIR)/bpf
> @@ -138,7 +139,8 @@ CLANG_SYS_INCLUDES := $(shell $(CLANG) -v -E - </dev/null 2>&1 \
>
>  CLANG_FLAGS = -I. -I./include/uapi -I../../../include/uapi \
>               $(CLANG_SYS_INCLUDES) \
> -             -Wno-compare-distinct-pointer-types
> +             -Wno-compare-distinct-pointer-types \
> +             -D__TARGET_ARCH_$(SRCARCH)

samples/bpf/Makefile uses $(ARCH), why does it work for samples?
Should we update samples/bpf/Makefile as well?

>
>  $(OUTPUT)/test_l4lb_noinline.o: CLANG_FLAGS += -fno-inline
>  $(OUTPUT)/test_xdp_noinline.o: CLANG_FLAGS += -fno-inline
> --
> 2.21.0
>
