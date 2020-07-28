Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD0C22FEA2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgG1AxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG1AxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 20:53:13 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9092DC061794;
        Mon, 27 Jul 2020 17:53:13 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 2so13086656qkf.10;
        Mon, 27 Jul 2020 17:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ez0P4zZ64+vX0mQ7JcE+5zgCRUbO7zubu23iMJ7twFo=;
        b=Bt26wYnotxk6XIrKE2LY3qQOnLWm1MVV2FijOBNUaGUw3dnIQMsWu+6Qb1Td43byIw
         hJp6MvSlyhXx0vR58cc11+x+wRgUBh+i9xVhTJh0o4cc2wOo1ZBPYQ0/g1fjZTCFEVE1
         epSQtbDTOVMMxugq59x3E4vpKkRUdJcFqGVRGjA0iLMfgQsQcuTIvCfSEY3UbAIUyOUJ
         CviWBFQTKHX61mxwP/VCpBEHr5F6LuBV/WGa0HrcOPFx241URZ0NEzGjvTGh87C/BcQc
         /hsqNdLdDaBTyxI3KItvt1WkWFxpY6kkdug3mUKMy9x6+6iv2C1rCHuPIueaJ1/7CcYS
         +QYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ez0P4zZ64+vX0mQ7JcE+5zgCRUbO7zubu23iMJ7twFo=;
        b=NC1XurDKJyiITtnRgJzUhebCz8sXM6ZvJdNaYoCX4d9AhNQbkxCDjGBrGWa3fva72u
         V0vxJOLD5+vKjLVTDyDgscvEL4L5EDE+Ocq82e+5GaCyyUu9WbtdDq7IqYbaEbSop8ek
         uuKMxsh/XpSMqvCejetgIIx28jTlmlhmHBdEDXNE19Ea37SXzhUXxoTr3Y2NHyddXHnc
         6tVSySfVrSpY5UGrM4rF8+NzfiUTX69Zu1rzAAIUx3/8Gf8gtwL8zvEK2aD5qzG4DBBT
         bXcLp3Ux2KdIJXboGyo6gO50Rz+JQvnnFIbGUqi5NyAb5NmMcITc76LUEH6G5jRb4gUu
         t5ig==
X-Gm-Message-State: AOAM531dJdJCBla9ZjdOC/0/pLKPOpfEQDTZXJaYG7iAIrU02Wy2KtcK
        fZspyxJw8oLu144NM9iq+GGIREWGSu06HB+xvA4=
X-Google-Smtp-Source: ABdhPJxMo5Oa3gKBUEjxgrx4YcdQ+8FnjlMzfP/UWHnFs4DzdF0hw831QrxvqFVsSVyA1jxcD0DhF9UW6/2WfuoiDYo=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr26750671qkg.437.1595897592748;
 Mon, 27 Jul 2020 17:53:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-3-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 17:53:01 -0700
Message-ID: <CAEf4BzYgnEybzj2_O5FCwO1CgcfBrKoZVR9jFr43KPRqyD_=OQ@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 02/13] tools resolve_btfids: Add support for
 set symbols
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The set symbol does not have the unique number suffix,
> so we need to give it a special parsing function.
>
> This was omitted in the first batch, because there was
> no set support yet, so it slipped in the testing.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/resolve_btfids/main.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index 6956b6350cad..c28ab0401818 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -220,6 +220,19 @@ static char *get_id(const char *prefix_end)
>         return id;
>  }
>
> +static struct btf_id *add_set(struct object *obj, char *name)
> +{
> +       char *id;
> +
> +       id = strdup(name + sizeof(BTF_SET) + sizeof("__") - 2);

why strdup? you are not really managing memory carefully anyway,
letting OS clean everything up, so why bother strduping here?

Also if get invalid identifier, you can easily go past the string and
its ending zero byte. So check strlen first?

> +       if (!id) {
> +               pr_err("FAILED to parse cnt name: %s\n", name);
> +               return NULL;
> +       }
> +
> +       return btf_id__add(&obj->sets, id, true);
> +}
> +
>  static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
>  {
>         char *id;
> @@ -376,7 +389,7 @@ static int symbols_collect(struct object *obj)
>                         id = add_symbol(&obj->funcs, prefix, sizeof(BTF_FUNC) - 1);
>                 /* set */
>                 } else if (!strncmp(prefix, BTF_SET, sizeof(BTF_SET) - 1)) {
> -                       id = add_symbol(&obj->sets, prefix, sizeof(BTF_SET) - 1);
> +                       id = add_set(obj, prefix);
>                         /*
>                          * SET objects store list's count, which is encoded
>                          * in symbol's size, together with 'cnt' field hence
> --
> 2.25.4
>
