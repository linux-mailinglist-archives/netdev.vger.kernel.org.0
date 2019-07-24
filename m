Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46B174174
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbfGXWdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:33:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35705 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfGXWdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:33:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so35056140qke.2;
        Wed, 24 Jul 2019 15:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FeqBqcoUn/yFI9xWOlx5uPvHYLRND0UFM276km+KrdU=;
        b=RDuCzKRRijQIBgEgz2UJ3mi3CXgoDfGliWY9PJtqaIvRnO3zndthnYKqEo3Z5oi06F
         yoXrycD8hqle+RzyOw3UjGPEclogaUduIzNDLxWXf10PxtoGTyXgWgLeWmvqptRlQujG
         MJkjwki2Mtd48vtuCezZ2WOSzO6z+JGKUbAZKodyPoYLZsqQ0ma/U2kCBBqlKVcZo/DN
         5qKjRYwV6xefciskQQ9kKG69ASHefMdEk4M+8dnVX0GwokHX673Hjn0CIpADU8+tkiEM
         AYfjeXdptSzPjpwBmxlXX7Fh4opYzpzmBbOZnLsJwVHofq8nDi16s7AjOnVg592Ddd6s
         gBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FeqBqcoUn/yFI9xWOlx5uPvHYLRND0UFM276km+KrdU=;
        b=ateNhQHiJ2ZK6m4Tq57xYBM9xUmxkYxw66qVOZfH/v3I9L7imRPhoqFxvRxfyuQPfZ
         4q4P57gsMhWrWSgsJ7EA3VdvXMKTtwbPkIVzBI88lYjAkGOe1O2KGDjEAN1VKKszjAAk
         5QYDLKnbNwHwzWWzeN001A2RC2vnORG8pVe0FNYNTsZ18qes9juIBPnBuQQsrpvBLUuT
         E/HGke4moh49SG6ydepS9Fy9KLp1c3Yfzt2ncysEEw2o0saJh2Eh9ZtQlz1n3nafCNDf
         Txj4o3qu+B9jNZkMswVosireWeaZHa0uCK/LoVEgq36IGIVWrRVemFFzAqdF8fVVAck9
         brxg==
X-Gm-Message-State: APjAAAV+1DOFfdJsT5AP1iInTiolqtqlBvhdvW9wcb4ocWfck//CejT1
        /dbhppYYRmztqjGmWfPt8d2NR45P2GBPHHm8NXs=
X-Google-Smtp-Source: APXvYqxwVmd0vRVRr/dySy4C5PI+D5WtMygzNsfgmMF7vd6ORiOD3OUdY6DsZF/8EKqiiiIXv1+E2yTBZkqeFGxIn8o=
X-Received: by 2002:a37:a854:: with SMTP id r81mr56799075qke.378.1564007601197;
 Wed, 24 Jul 2019 15:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-4-sdf@google.com>
In-Reply-To: <20190724170018.96659-4-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 15:33:09 -0700
Message-ID: <CAPhsuW7n8tT83HmwU1YzAFiAmkt8h8uq+4fvxd9891y6=9o-ZA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> This will allow us to write tests for those flags.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/bpf/test_run.c | 39 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 35 insertions(+), 4 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 4e41d15a1098..444a7baed791 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -377,6 +377,22 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>         return ret;
>  }
>
> +static int verify_user_bpf_flow_keys(struct bpf_flow_keys *ctx)
> +{
> +       /* make sure the fields we don't use are zeroed */
> +       if (!range_is_zero(ctx, 0, offsetof(struct bpf_flow_keys, flags)))
> +               return -EINVAL;
> +
> +       /* flags is allowed */
> +
> +       if (!range_is_zero(ctx, offsetof(struct bpf_flow_keys, flags) +
> +                          FIELD_SIZEOF(struct bpf_flow_keys, flags),
> +                          sizeof(struct bpf_flow_keys)))
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>                                      const union bpf_attr *kattr,
>                                      union bpf_attr __user *uattr)
> @@ -384,9 +400,11 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>         u32 size = kattr->test.data_size_in;
>         struct bpf_flow_dissector ctx = {};
>         u32 repeat = kattr->test.repeat;
> +       struct bpf_flow_keys *user_ctx;
>         struct bpf_flow_keys flow_keys;
>         u64 time_start, time_spent = 0;
>         const struct ethhdr *eth;
> +       unsigned int flags = 0;
>         u32 retval, duration;
>         void *data;
>         int ret;
> @@ -395,9 +413,6 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>         if (prog->type != BPF_PROG_TYPE_FLOW_DISSECTOR)
>                 return -EINVAL;
>
> -       if (kattr->test.ctx_in || kattr->test.ctx_out)
> -               return -EINVAL;
> -
>         if (size < ETH_HLEN)
>                 return -EINVAL;
>
> @@ -410,6 +425,18 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>         if (!repeat)
>                 repeat = 1;
>
> +       user_ctx = bpf_ctx_init(kattr, sizeof(struct bpf_flow_keys));
> +       if (IS_ERR(user_ctx)) {
> +               kfree(data);
> +               return PTR_ERR(user_ctx);
> +       }
> +       if (user_ctx) {
> +               ret = verify_user_bpf_flow_keys(user_ctx);
> +               if (ret)
> +                       goto out;
> +               flags = user_ctx->flags;
> +       }
> +
>         ctx.flow_keys = &flow_keys;
>         ctx.data = data;
>         ctx.data_end = (__u8 *)data + size;
> @@ -419,7 +446,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>         time_start = ktime_get_ns();
>         for (i = 0; i < repeat; i++) {
>                 retval = bpf_flow_dissect(prog, &ctx, eth->h_proto, ETH_HLEN,
> -                                         size, 0);
> +                                         size, flags);
>
>                 if (signal_pending(current)) {
>                         preempt_enable();
> @@ -450,8 +477,12 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>
>         ret = bpf_test_finish(kattr, uattr, &flow_keys, sizeof(flow_keys),
>                               retval, duration);
> +       if (!ret)
> +               ret = bpf_ctx_finish(kattr, uattr, user_ctx,
> +                                    sizeof(struct bpf_flow_keys));
>
>  out:
>         kfree(data);
> +       kfree(user_ctx);

nit: it is not really necessary now, but maybe put kfree(user_ctx)
before kfree(data).

>         return ret;
>  }
> --
> 2.22.0.657.g960e92d24f-goog
>
