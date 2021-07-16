Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31683CB1AC
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhGPEr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbhGPErZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:47:25 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B61FC06175F;
        Thu, 15 Jul 2021 21:44:30 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id r132so12829000yba.5;
        Thu, 15 Jul 2021 21:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yYOD/u1xihPok91arDjP4278IqZI5oLzya2IA/6JFKU=;
        b=nAda8iMn0xANAOsMItn8hNdbhhFgBUtwexymCvv+el8C8kVQsC2SaZa0VFY8g89Tzh
         7HUu8E1ZfbBtD18w0/HpD0joD00lnt3CSER8vjPeuEpimvLFUp1DUwIUkO1j5DLX/o7N
         0RvTuwwJYP/M+AKzbsyIsvSd+aeQbv+K6vdKiV8+8UoUbQgqjoWdRD+tdSZJxSq31yAY
         BZh9S0tT0Na8Kz467rQ5i99mg5k5bz/XwpbF7BCuKjMsXsPLHRwpvV0X97g/N0lRjEuO
         MQkLPl9zP/rof2+wnZGj0Bzd7nf4Web9ulA/SeolZcKnhGgOH9dIXC0Nz1jNVLMubtD1
         d0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYOD/u1xihPok91arDjP4278IqZI5oLzya2IA/6JFKU=;
        b=thtJ2M6FUFBNchY4y4i4xRUtQXG5OouNNDzdhLY5iO6KDNL1eVV8AkBuRpA8dMbw4+
         XXMvl4Fj6KmhVjlzQKxnYFq+8JT59JNSJmUXUZnJvL+Bqm/+/BhbypknzLbeDnzvtelQ
         PjsdZspiTzeu3UA+I5NI7w4bvtWPWVZfHSVB9Zy3AHklfgj6kr0WbA5Oqa44v1QSqVEL
         ksc1WjK0o01vhD36INONhvVU4FwpUSKuqKvch16Q5D7TbV9Qb65yG95ahpa3PVMaupRt
         6/nzPC4wSm+K+3ZVyj0t9SGtiC3HAWvhA5tfvbn5mOZ3CWj+FdwLXP8m/yJbTG+R7KWx
         g2pQ==
X-Gm-Message-State: AOAM533LB+EV1mZ8QcuUH0sbx5pafPSgAxH+vgsmQ/JyRD1Pjhu3N8dy
        nYDvaIi5P4bs6ybtOXA01Yc9OaQ+k4Uo/kxMHvc=
X-Google-Smtp-Source: ABdhPJz6jpaMLnAjkQMCQFHnFjMJyjo9RkbTuUPq6AcGlbAEs7tc/gNf9IO5a08SM+OpCa9rribA9hP8iE+3jVt6Y4U=
X-Received: by 2002:a25:9942:: with SMTP id n2mr10525860ybo.230.1626410669723;
 Thu, 15 Jul 2021 21:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210714141532.28526-1-quentin@isovalent.com> <20210714141532.28526-6-quentin@isovalent.com>
In-Reply-To: <20210714141532.28526-6-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:44:18 -0700
Message-ID: <CAEf4BzbdVVkCffQjZGO81rQQZ0EUop36qv_Byit68xkA8m5iqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: add split BTF support for btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 7:15 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Add a new API function btf__load_from_kernel_by_id_split(), which takes
> a pointer to a base BTF object in order to support split BTF objects
> when retrieving BTF information from the kernel.
>
> Reference: https://github.com/libbpf/libbpf/issues/314
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/btf.c      | 10 ++++++++--
>  tools/lib/bpf/btf.h      |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 05b63b63083a..15967dd80ffb 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1383,7 +1383,8 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
>         return btf;
>  }
>
> -int btf__load_from_kernel_by_id(__u32 id, struct btf **btf)
> +int btf__load_from_kernel_by_id_split(__u32 id, struct btf **btf,
> +                                     struct btf *base_btf)

here all those struct btf pointers are even more confusing, let's
return the resulting struct btf * as a direct result value

>  {
>         struct btf *res;
>         int err, btf_fd;

[...]
