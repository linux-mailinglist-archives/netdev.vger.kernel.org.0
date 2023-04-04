Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD2C6D70B4
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 01:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbjDDXba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 19:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbjDDXb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 19:31:29 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2AB171C;
        Tue,  4 Apr 2023 16:31:28 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y4so136841589edo.2;
        Tue, 04 Apr 2023 16:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680651086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yNhIi8mY0TFnAPxh5RCm+XcoQvTMOi9OM34elDPUxo=;
        b=TitKMC54JSn+ZiL+Cnl8EompZaGDs6Xd49peTs8Me5tVO6jmi7hYc5Md6294YlKlAG
         H80cF32L92QUVBGAK7ePfzcUeu/o8CPyBCYlqvX2v4SVLQ7B2ZB333v4OhHeyTaNtR1M
         O+tFVVnUTZjiB9ecceIF1PG2J7cGSGuDPr2e4AGnvfn9HePk6ej8vkHm7OS3n5VxwZSE
         ZkFoW16XogJjuIGU7j12Z9zlU9sfdEg4fAWnCkrPX8yv4ghKaYgJBWS/CuF5VvLadFQ5
         y5SEmyx9ucbVeBL0ixmc0HaavKMwKcdAyEsxI2bLfw9MxdK2Kb2CtFmTAr/bXm34hPji
         7rjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680651086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9yNhIi8mY0TFnAPxh5RCm+XcoQvTMOi9OM34elDPUxo=;
        b=uKcKJIL81HSWZBJEdF1Rl69ZcOrtmTcSP7H4YDHWzs5GSvcWkhQOD//wFRh5jl5EpO
         7TP2HRN9LWiMGgp6B1YbcwCbDc1Ni9gqp76gxXXFLa7wlCGNA8r6Tdgogqn1paRK8ELB
         J/KS/3q3hqc/Y3EJANqZUSrDCyh6DpvXYIFQ+Qn5olnA3y//2pvAgikgfggftxREQAoD
         hHEeGyhLxNZDNaQrzU/hTKMlSKkxqIe00+tijYrISBRVe8nfdQkkaEp06W752zkdwgUW
         8gX75gS1DHvVwfOEZ2C3qyn+KieMxpv2eJCzYmUEaCivcM9RY9pCpSSXk4Lbin06lcT4
         gUiA==
X-Gm-Message-State: AAQBX9dp/O0A+rmN/cl6PjZZWCEn+G0xrNJKr3rynWEwwOw8cj5iBhy3
        lo55dprinIekAY58WgiohYtoWVmGFlt3d4UUYx4=
X-Google-Smtp-Source: AKy350bdN/3bHb5oY0KHIZX8+Gxpp6Ts8Vl+rAwng+9sfJOrllko+jw/+/G2Eb3reaxLCuabaKn7ZuVdLfjYAJ1mylc=
X-Received: by 2002:a17:906:25d9:b0:931:fb3c:f88d with SMTP id
 n25-20020a17090625d900b00931fb3cf88dmr628644ejb.5.1680651086339; Tue, 04 Apr
 2023 16:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com> <20230404045029.82870-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20230404045029.82870-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Apr 2023 16:31:14 -0700
Message-ID: <CAEf4Bzb30F_zJOd0s35YMLVs+LQ4k5o33YsQb_qY=KFmJiKZ0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] bpf: Remove unused arguments from btf_struct_access().
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, memxor@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 9:50=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Remove unused arguments from btf_struct_access() callback.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

expected this change in patch #1, tbh, even wrote a comment about
dropping enum bpf_access_type, but then guessed to check next patch.
Anyways, I'm fine either way, but patch 1 and 2 together make for much
less confusing change, IMO. See also my note about renaming *callback*
to make its write access nature clear.

>  include/linux/bpf.h              |  3 +--
>  include/linux/filter.h           |  3 +--
>  kernel/bpf/verifier.c            |  4 ++--
>  net/bpf/bpf_dummy_struct_ops.c   | 12 +++++-------
>  net/core/filter.c                | 13 +++++--------
>  net/ipv4/bpf_tcp_ca.c            |  3 +--
>  net/netfilter/nf_conntrack_bpf.c |  3 +--
>  7 files changed, 16 insertions(+), 25 deletions(-)
>

[...]
