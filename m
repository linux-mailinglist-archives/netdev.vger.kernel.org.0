Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6C063E6FE
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLABRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLABRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:17:00 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5933C97903;
        Wed, 30 Nov 2022 17:16:59 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bj12so640081ejb.13;
        Wed, 30 Nov 2022 17:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBy2i6bfQlIMOFFdWaorQjVj0QKyhQhUzVQv90xIXCk=;
        b=mdv6fBFN34nz0NqGwS0/vWgNTm7izgV3J3nLpD9D9aDyZo2Sn1wVrB2pPeYtoUNPfi
         0RvT8seIuorkQYoOCZC+R+qKdYmSXg/3nRHDBqes7wwOnge5Q0B0HNcyHHMYs0JfPCZ9
         +yAjF3nZygFHZUDI8y6KYB7qJdkgIY/NmOtPdPnhm9EznufMuYuL98kxXQJrtirCcZje
         Qi4CJDze6Mt0CTDQ76oCBe/3Z6J8GL9FYxSFG2Ow499/8jtGLOQ4gKDWAGu0ZI91Bv88
         FSm7yFivooqkabPYbgPJ9EOY1emjSUeL/yqajFUuocJ8yQMYm1hJBjyHyKZRg3p+UTds
         ++Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBy2i6bfQlIMOFFdWaorQjVj0QKyhQhUzVQv90xIXCk=;
        b=5KqL1YaWqWfa7EuF29RuRIoHHuQSIaQI69RtsP6nPeJ3kLo560i2xGkvCZiB4WNimc
         kUUUTiqOZUTZU45kv4jBB+2lX9xiEyRJSHOqaqnhi6wvSic7l3jEiExbGbRVio5Tp3sQ
         emKfugcjx8ZU3oJcd+Zk0/YK9WXiPww/5dsLss7/OlxJtC8vApNlJBHVkdonbFaMft17
         Zs+wqDfS38DiEacLNmviHfVzR1kroAB+9o23g1SKCEUHsgnmxKVhz41yOEgRVOq1ngBx
         ykpOb0RmFrv+U+JIpRjPqZE/UaYon9h7oNt8/z8M7ioObz7fRePM8AGNtqcjz5gO13GZ
         C4Rg==
X-Gm-Message-State: ANoB5plwGGv37t03AHH2Rbn8M+k+fI4I4IndDHSOMi7phQHaUtmX6pyB
        pk49qv48zyhEh73UV1cW9zF3+oZR1hex/RiQyTA=
X-Google-Smtp-Source: AA0mqf4Gy64KlOcbdlZVMgmSqzurZK1EmYAaVR0QyVMI4Isru8nHh1a30NM/YnSVGAYCTlcAGo2fWRNvxx812+oKe5E=
X-Received: by 2002:a17:906:30c1:b0:7b7:eaa9:c1cb with SMTP id
 b1-20020a17090630c100b007b7eaa9c1cbmr39655439ejb.745.1669857417736; Wed, 30
 Nov 2022 17:16:57 -0800 (PST)
MIME-Version: 1.0
References: <20221130144240.603803-1-toke@redhat.com>
In-Reply-To: <20221130144240.603803-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Nov 2022 17:16:45 -0800
Message-ID: <CAEf4BzafebzBTVqtTHotRcySXPafF5JK11Svpirtnvz7c9O7uQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: Add dummy type reference to nf_conn___init
 to fix type deduplication
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
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
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

On Wed, Nov 30, 2022 at 6:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The bpf_ct_set_nat_info() kfunc is defined in the nf_nat.ko module, and
> takes as a parameter the nf_conn___init struct, which is allocated throug=
h
> the bpf_xdp_ct_alloc() helper defined in the nf_conntrack.ko module.
> However, because kernel modules can't deduplicate BTF types between each
> other, and the nf_conn___init struct is not referenced anywhere in vmlinu=
x
> BTF, this leads to two distinct BTF IDs for the same type (one in each
> module). This confuses the verifier, as described here:
>

Argh, shouldn't have wasted writing [1], but oh well.

  [1] https://lore.kernel.org/bpf/CAEf4Bza2xDZ45kxxa3dg1C_RWE=3DUB5UFYEuFp6=
rbXgX=3DLRHv-A@mail.gmail.com/

> https://lore.kernel.org/all/87leoh372s.fsf@toke.dk/
>
> As a workaround, add a dummy pointer to the type in net/filter.c, so the
> type definition gets included in vmlinux BTF. This way, both modules can
> refer to the same type ID (as they both build on top of vmlinux BTF), and
> the verifier is no longer confused.
>
> Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in n=
f_nat_bpf.c")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  net/core/filter.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a8e4..1bdf9efe8593 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -80,6 +80,7 @@
>  #include <net/tls.h>
>  #include <net/xdp.h>
>  #include <net/mptcp.h>
> +#include <net/netfilter/nf_conntrack_bpf.h>
>
>  static const struct bpf_func_proto *
>  bpf_sk_base_func_proto(enum bpf_func_id func_id);
> @@ -11531,3 +11532,17 @@ bpf_sk_base_func_proto(enum bpf_func_id func_id)
>
>         return func;
>  }
> +
> +#if IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_M=
ODULES)
> +/* The nf_conn___init type is used in the NF_CONNTRACK kfuncs. The kfunc=
s are
> + * defined in two different modules, and we want to be able to use them
> + * interchangably with the same BTF type ID. Because modules can't de-du=
plicate
> + * BTF IDs between each other, we need the type to be referenced in the =
vmlinux
> + * BTF or the verifier will get confused about the different types. So w=
e add
> + * this dummy pointer to serve as a type reference which will be include=
d in
> + * vmlinux BTF, allowing both modules to refer to the same type ID.
> + *
> + * We use a pointer as that is smaller than an instance of the struct.
> + */
> +const struct nf_conn___init *ctinit;
> +#endif

Use BTF_TYPE_EMIT() instead maybe?

> --
> 2.38.1
>
