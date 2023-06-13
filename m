Return-Path: <netdev+bounces-10425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B0072E657
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:55:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66EFC281082
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF9637B93;
	Tue, 13 Jun 2023 14:55:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C3A15ADA;
	Tue, 13 Jun 2023 14:55:02 +0000 (UTC)
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC9D1734;
	Tue, 13 Jun 2023 07:55:00 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-7872d7b79e1so447468241.0;
        Tue, 13 Jun 2023 07:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686668100; x=1689260100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9n0iumPK6wdW/4Epbrf2rYsjBUwO3iDgGxkE9NXI6/M=;
        b=j2Ec4ltifisl3imdvY7J0POcnewURPf1JJrURzN0cW/3XDV+geDRhiTCMFFXtlsvEr
         STceutcjRBf7H9+pJAuW9UaIV1jR1ZE0EsLzBHbuFwifl1NRPuvXtx1zc3e7fpZdCpFj
         izG2EBGkRjNqV9QuoGJfFZtVy1FsraAWcQXpYhfsaPxFRIIfOqb9RcA0Z5vkUfB/J9wl
         0y5YpG8I2UXcnklbbTtKA+nnku3lFNtbr7CCI27Fjbpw445qJGBvKT9aATB84bqjDkpH
         mSi710Ys11Hqg2f1jHtHYz6YOG/cdzYJ82n6JPlbBuZvIUbwli0EAQQG09KmI9x+3PPp
         yktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686668100; x=1689260100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9n0iumPK6wdW/4Epbrf2rYsjBUwO3iDgGxkE9NXI6/M=;
        b=WeszC+f+SbXGpQE6ykqyrm9edMGZFZmnksj0Ce8uxyi8UDnsgXrfa7xgFRHjZOl6KU
         fhP5cH5IPFC9OokxfdnnkF36n8BI+VshBKI2TnvXo1vBGLT4ticVweQH0CLtT8esRXM1
         TfKHXE2x+hqZ/D8SPQzBmbX0diDd1x6PyF8Da0/XukghGivqa078e9A6rQE18YUj2Aiq
         GRnrCdjd+Kfpt8zcH3a4T05zB+kPv7rHYGNNQuaOY9qO8V8QN/s+yjBlsmLSajUm4BJX
         Zjnel0q3zw76g+7t2OmSlwlFqAQM1I5mXbVQmOqAWE43LgTpVGfQMW7UUQWMrptAYrQH
         NAxg==
X-Gm-Message-State: AC+VfDy4RD4Rx5hJAcRQyl+PlqidjPR74rdNt5xe2RGaM6w28VDpbLK3
	OiUUdsrQ2ULLxVDri8OjaEkEMsUlysbNqicC4n4=
X-Google-Smtp-Source: ACHHUZ7hjYUecq79kWaVUCHjHKGnnnW0Q135bcJaEi8G4Lu46naK/mAk0TdZU+jmqfEWuJWUhPlg94F1EoYMY6N6s7k=
X-Received: by 2002:a67:f803:0:b0:43b:16cf:1dda with SMTP id
 l3-20020a67f803000000b0043b16cf1ddamr5568260vso.27.1686668099721; Tue, 13 Jun
 2023 07:54:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-4-sdf@google.com>
In-Reply-To: <20230612172307.3923165-4-sdf@google.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 13 Jun 2023 16:54:23 +0200
Message-ID: <CAF=yD-LtxC8BeCyTWpqwziKto5DVjeg7maMjCkOZcWoihFHKzw@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 7:24=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> devtx is a lightweight set of hooks before and after packet transmission.
> The hook is supposed to work for both skb and xdp paths by exposing
> a light-weight packet wrapper via devtx_frame (header portion + frags).
>
> devtx is implemented as a tracing program which has access to the
> XDP-metadata-like kfuncs. The initial set of kfuncs is implemented
> in the next patch, but the idea is similar to XDP metadata:
> the kfuncs have netdev-specific implementation, but common
> interface. Upon loading, the kfuncs are resolved to direct
> calls against per-netdev implementation. This can be achieved
> by marking devtx-tracing programs as dev-bound (largely
> reusing xdp-dev-bound program infrastructure).
>
> Attachment and detachment is implemented via syscall BPF program
> by calling bpf_devtx_sb_attach (attach to tx-submission)
> or bpf_devtx_cp_attach (attach to tx completion). Right now,
> the attachment does not return a link and doesn't support
> multiple programs. I plan to switch to Daniel's bpf_mprog infra
> once it's available.
>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>


> @@ -2238,6 +2238,8 @@ struct net_device {
>         unsigned int            real_num_rx_queues;
>
>         struct bpf_prog __rcu   *xdp_prog;
> +       struct bpf_prog __rcu   *devtx_sb;
> +       struct bpf_prog __rcu   *devtx_cp;

nit/subjective: non-obvious two letter acronyms are nr. How about tx
and txc (or txcomp)

> +static int __bpf_devtx_attach(struct net_device *netdev, int prog_fd,
> +                             const char *attach_func_name, struct bpf_pr=
og **pprog)
> +{
> +       struct bpf_prog *prog;
> +       int ret =3D 0;
> +
> +       if (prog_fd < 0)
> +               return __bpf_devtx_detach(netdev, pprog);
> +
> +       if (*pprog)
> +               return -EBUSY;
> +
> +       prog =3D bpf_prog_get(prog_fd);
> +       if (IS_ERR(prog))
> +               return PTR_ERR(prog);
> +
> +       if (prog->type !=3D BPF_PROG_TYPE_TRACING ||
> +           prog->expected_attach_type !=3D BPF_TRACE_FENTRY ||
> +           !bpf_prog_is_dev_bound(prog->aux) ||
> +           !bpf_offload_dev_match(prog, netdev) ||
> +           strcmp(prog->aux->attach_func_name, attach_func_name)) {
> +               bpf_prog_put(prog);
> +               return -EINVAL;
> +       }
> +
> +       *pprog =3D prog;
> +       static_branch_inc(&devtx_enabled);
> +
> +       return ret;

nit: just return 0, no variable needed

> +}
> +
> +__diag_push();
> +__diag_ignore_all("-Wmissing-prototypes",
> +                 "Global functions as their definitions will be in vmlin=
ux BTF");
> +
> +/**
> + * bpf_devtx_sb_attach - Attach devtx 'packet submit' program
> + * @ifindex: netdev interface index.
> + * @prog_fd: BPF program file descriptor.
> + *
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_devtx_sb_attach(int ifindex, int prog_fd)
> +{
> +       struct net_device *netdev;
> +       int ret;
> +
> +       netdev =3D dev_get_by_index(current->nsproxy->net_ns, ifindex);
> +       if (!netdev)
> +               return -EINVAL;
> +
> +       mutex_lock(&devtx_attach_lock);
> +       ret =3D __bpf_devtx_attach(netdev, prog_fd, "devtx_sb", &netdev->=
devtx_sb);
> +       mutex_unlock(&devtx_attach_lock);
> +
> +       dev_put(netdev);
> +
> +       return ret;
> +}
> +
> +/**
> + * bpf_devtx_cp_attach - Attach devtx 'packet complete' program
> + * @ifindex: netdev interface index.
> + * @prog_fd: BPF program file descriptor.
> + *
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_devtx_cp_attach(int ifindex, int prog_fd)
> +{
> +       struct net_device *netdev;
> +       int ret;
> +
> +       netdev =3D dev_get_by_index(current->nsproxy->net_ns, ifindex);
> +       if (!netdev)
> +               return -EINVAL;
> +
> +       mutex_lock(&devtx_attach_lock);
> +       ret =3D __bpf_devtx_attach(netdev, prog_fd, "devtx_cp", &netdev->=
devtx_cp);
> +       mutex_unlock(&devtx_attach_lock);
> +
> +       dev_put(netdev);
> +
> +       return ret;
> +}

These two functions are near duplicates, aside from the arguments to
their inner call to __bpf_devtx_attach. Can be dedup-ed further?

