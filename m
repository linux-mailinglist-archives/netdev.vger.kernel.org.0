Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A331D629FF9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiKORJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKORJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:09:18 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10F865CA;
        Tue, 15 Nov 2022 09:09:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l11so22841608edb.4;
        Tue, 15 Nov 2022 09:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13kwedfdgnKnT0nAJkpeTAEFco8AeqnjcbtoFZQynKE=;
        b=F+/WJzugxdRYB6xGIh4hz5t74AefbRu0GH1KdogoFrjrRHoj3SeIwh2LNYCUrML4ZD
         Rh3Z7AyjFRrT1fH4K3RG14tJfAear3uXUuD05MQrbSbiWl8nTD1uouBbj7sW0vn8w0eJ
         S1PcdO95o5YhllXVedfMa3zRtJFxFX0oyqgK6adsv7NJ5tdEVucq/B8UlxHLHlKHdvo4
         UKzhjbzTfK+mDOq+ccyZvGDqdxGqXb9vcmRLLtsOQHB/d5ByDNqUtVHTnLFl2IPbm3lt
         Bwi/fXPpLm8GyGaioEECw2IUv2OiHowAtRMz2nEmFjM1RocS141FHDLOKTNY5FfK35y+
         IfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13kwedfdgnKnT0nAJkpeTAEFco8AeqnjcbtoFZQynKE=;
        b=JEdSV6P+0e7OcOl0AQoaRLxU44nFap5FGH8PhBfJ8+fbWdGVyJd+jGKhNc0jEQCP3t
         s1jcQoHu5ArlhFb2V5va/mEqFoTC5hIReLTQjiEk5tIgF+/VKN9/4sVbu68BzxxHPbqk
         DzOLgyY7v+xMauAj1VJwfxNYH1vdDauF9o12WjlEs8RC0ZAv9hg88hKZzZ5MjSaLoffz
         qyLv4nI1D2KjasFskrdOXc5mLYph96e44BJJHNENuVgVUvsKLdz6Sye9MdUdBqH+B4yH
         ZuI4t6sKv5GPXzrhq8/x1wmb9SZYufe8XHsWithRvzKcTRjT4XswbJn+Sw91K011HXWk
         l90Q==
X-Gm-Message-State: ANoB5pkUPYJlBEOdJ68cPlkV30yfeKtq31qYgBLJwZ0wFgG21DNuWH4W
        hPuDAmKCpyX0Ex3qbrJWJm3I556okQCWL4n0KlY=
X-Google-Smtp-Source: AA0mqf5zokgESgJxV0AlRiXEMRIyYAtE4sgyWuQZDtA3AbedrogGwElUjg51a/G6HIptzBnoj4JrjYbYep1HTcglsdQ=
X-Received: by 2002:a50:fe19:0:b0:462:70ee:fdb8 with SMTP id
 f25-20020a50fe19000000b0046270eefdb8mr16344191edt.66.1668532156039; Tue, 15
 Nov 2022 09:09:16 -0800 (PST)
MIME-Version: 1.0
References: <20221108140601.149971-1-toke@redhat.com> <20221108140601.149971-4-toke@redhat.com>
In-Reply-To: <20221108140601.149971-4-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Nov 2022 09:09:04 -0800
Message-ID: <CAADnVQJjxdUAE6NHNtbbqVj3p3=8KsKrvRb3ShdYb9CcfVY8Ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] bpf: Use 64-bit return value for bpf_prog_run
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 6:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> BPF ABI always uses 64-bit return value, but so far __bpf_prog_run and
> higher level wrappers always truncated the return value to 32-bit. We
> want to be able to introduce a new BPF program type that returns a
> PTR_TO_BTF_ID or NULL from the BPF program to the caller context in the
> kernel. To be able to use this returned pointer value, the bpf_prog_run
> invocation needs to be able to return a 64-bit value, so update the
> definitions to allow this.

...

> -static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
> +static __always_inline u64 __bpf_prog_run(const struct bpf_prog *prog,
>                                           const void *ctx,
>                                           bpf_dispatcher_fn dfunc)
>  {
> -       u32 ret;
> +       u64 ret;
>
>         cant_migrate();
>         if (static_branch_unlikely(&bpf_stats_enabled_key)) {
> @@ -602,7 +602,7 @@ static __always_inline u32 __bpf_prog_run(const struc=
t bpf_prog *prog,
>         return ret;
>  }
>
> -static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, con=
st void *ctx)
> +static __always_inline u64 bpf_prog_run(const struct bpf_prog *prog, con=
st void *ctx)
>  {
>         return __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
>  }

I suspect 32-bit archs with JITs are partially broken with this change.
As long as progs want to return pointers it's ok, but actual
64-bit values will be return garbage in upper 32-bit, since 32-bit
JITs won't populate the upper bits.
I don't think changing u32->long retval is a good idea either,
since BPF ISA has to be stable regardless of underlying arch.
The u32->u64 transition is good long term, but let's add
full 64-bit tests to lib/test_bpf and fix JITs.

I've applied the first two patches of the series.
