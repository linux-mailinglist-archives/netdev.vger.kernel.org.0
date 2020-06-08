Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8771D1F284F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbgFHXuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732633AbgFHXut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 19:50:49 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290C8C08C5C2;
        Mon,  8 Jun 2020 16:50:49 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g28so19189151qkl.0;
        Mon, 08 Jun 2020 16:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=suyqWS/ZUReE4gxYDGm5ZphsdqSoTMupn6xMnhtwXkI=;
        b=Wg9CygL0m9uKEgVPKFylzpVrbe6Krbbgc1oC+k21qtA85ViAFs99NXazhZQRWmb/ts
         n06z9ksIKMeLNnwZCQLPzCPqNjTjyRcm90Z0Oy2iXCL0+yD/F6ycqxrsfPLkxHKQML0i
         66C9N54QzY6EMOj6EoT06BOA0yeNfhz1UFHSwDJmMyoD1aTOKSurfg/p2ZbNFaF2Z92z
         XOODqEG2INVCQbbzRmfCWYsjA4glEi/P1e/vGYKUMYvKj4FT+uMkyDuEXhcg4o4uZZzY
         K4eblO4hYkFHAlO+NIGikYC72T84Kb07TAt6TQsjgSyRHwQt0w7OCpae9i/ofhJhGMjK
         6qzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=suyqWS/ZUReE4gxYDGm5ZphsdqSoTMupn6xMnhtwXkI=;
        b=FGEvjg+BWlRO4B1HphMWEXZpiN/LjolFYg9g4czOh4Y79ouI+ujHE/lKmtGxSNdhAj
         ByIfR55mJLlUW0VJH3QVUB/9YZOp+xxf4yAa3b/VSKPrO3O0pQvKw+YfnihRMnNGIKTA
         3DYQlhw1LFLXabhG4DUhNYxYYDevNh92+ZFnRiJIuSNNvA/1KWYuqiOQYivFBhKx+CDR
         701LNBl429LGTpEFnm+hMgNOv4yXmkIKrE6U/KJAl8j7mEerO4eJ9zpEtB1dT4EOp/AC
         tiPUCaNBP4/vlpkFNqTFb0NBWgn9JIf/a8lKfM/1D8N8XZOqHuTKys3smoMtiNbL7au4
         JEvQ==
X-Gm-Message-State: AOAM530U0iHTrVzjnslJwaLxYSjujtDQWtYvs3Qtjx/wTwqMVVVN2cKR
        jRbOGf11oVnJbz2yxQ+suc30DJgrt4Ul9D633QcsiO6WndY=
X-Google-Smtp-Source: ABdhPJzyA4pPmouxN9UqA3SLetGKvJTIicTZcdhMGJ6l2k+V2EZpqHrw+/opdh3iNjInD77Caax8jW1GXkdsKnO8uTI=
X-Received: by 2002:a37:4595:: with SMTP id s143mr26306198qka.449.1591660248298;
 Mon, 08 Jun 2020 16:50:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200608152052.898491-1-jean-philippe@linaro.org>
In-Reply-To: <20200608152052.898491-1-jean-philippe@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Jun 2020 16:50:37 -0700
Message-ID: <CAEf4BzaNaHGBxNLdA1RA7VPou7ypO3Z5XBRG5gpkePx4g27yWA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Fix BTF-to-C conversion of noreturn function pointers
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 8, 2020 at 8:23 AM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> When trying to convert the BTF for a function pointer marked "noreturn"
> to C code, bpftool currently generates a syntax error. This happens with
> the exit() pointer in drivers/firmware/efi/libstub/efistub.h, in an
> arm64 vmlinux. When dealing with this declaration:
>
>         efi_status_t __noreturn (__efiapi *exit)(...);
>
> bpftool produces the following output:
>
>         efi_status_tvolatile  (*exit)(...);


I'm curious where this volatile is coming from, I don't see it in
__efiapi. But even if it's there, shouldn't it be inside parens
instead:

efi_status_t (volatile *exit)(...);

?

>
> Fix the error by inserting the space before the function modifier.
>
> Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---

Can you please add tests for this case into selftests (probably
progs/btf_dump_test_case_syntax.c?) So it's clear what's the input and
what's the expected output.

>  tools/lib/bpf/btf_dump.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>

[...]
