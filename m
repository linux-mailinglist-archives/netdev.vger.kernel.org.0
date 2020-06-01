Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6AE1EB1B9
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgFAWaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAWaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:30:18 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2527C061A0E;
        Mon,  1 Jun 2020 15:30:17 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id v79so10697192qkb.10;
        Mon, 01 Jun 2020 15:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ePaoocrKxmv83iBnIvi8b66+/VbPkB6r/kagRk6vBjA=;
        b=Nwk0v+BzSwpTxDL0F/q9gwI4aw5xql8CZt+1ss59J1hNy6Nv2bcqpBz/t9bPsHEb2S
         +lJaJGaQ72tL57EiYWRQHNhw2CrViM7ePdfd9fGjRoSWla04g0oyhKMbnifa1+mcWP5W
         VtiTKwb8qSr/lT2JaRzv1UsoMWR4m5v4TdKI7dp8nNt6yqQpCJSaW42dEry2bIgwrfpL
         pMbfPDinEHWbONvf+4XfjWGBccmf53ubTt4MIwjs31HuJnIlSN8taNXdoNmEuggXBD0K
         l6OQqoeWEZiNcp13wiA8MpqMZQIKeSl1gioaVLg81yWcBiYzssQXmIE5hMr9CSGYGhug
         Iczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ePaoocrKxmv83iBnIvi8b66+/VbPkB6r/kagRk6vBjA=;
        b=WRSTzdZ7G3Z1BwKB+CNTByG6uhuwBtJdEhquhxKNeO3pRyDWvKTQ0SrGh8q9rX4Y5m
         ZgjANZHsxkD8wtBQ2sMbyEfTHlEblIDkmXY4NYY8I1GwCCHjKdGtUecILGCOi7rnMm+0
         h2Xd0vuFRV4zRrkjnR7XdVKOi4x8cpLhFxHQB+acLcrpkqeySUsm2aE55pWSYOU2lwD1
         V6PiCJjkkl7ct3qVJjzdTQEBVdNnaMq18wRlEVcr3Jd47xGgLEmxl5kV0jnmWmcpsmCE
         ggDTJSGGmL430Sf2Xp3fmGUlDGahDztPmHRTY+IjJBDro+rt/4mQMj6mqOCEqhjrpnbi
         Od5A==
X-Gm-Message-State: AOAM5331iN6KPnv9LA89RGPSH93JiFyJFm2/0w+LeXzI+gaPIAukgdGB
        A4+uipV3pczs2XjVJNLJyhLp2KtiaK2Ksc+XzO1f+SW0
X-Google-Smtp-Source: ABdhPJykptdFMkGdTQfn/rYxVf1TX89xzs2zNAzHDZxLOyOD69TYMs1Yf4CaTTHghtdrzZ0TkR+AczhGZpkP1VzS7cc=
X-Received: by 2002:a05:620a:247:: with SMTP id q7mr22335998qkn.36.1591050616786;
 Mon, 01 Jun 2020 15:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-5-jakub@cloudflare.com>
In-Reply-To: <20200531082846.2117903-5-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 15:30:05 -0700
Message-ID: <CAEf4BzbxPrEJgWyeh_XzQcQ6VwfhC9NzyDNX4JCu86Jj4cCMtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/12] bpf: Add link-based BPF program
 attachment to network namespace
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 1:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Extend bpf() syscall subcommands that operate on bpf_link, that is
> LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO, to accept attach types tied to
> network namespaces (only flow dissector at the moment).
>
> Link-based and prog-based attachment can be used interchangeably, but only
> one can exist at a time. Attempts to attach a link when a prog is already
> attached directly, and the other way around, will be met with -EEXIST.
> Attempts to detach a program when link exists result in -EINVAL.
>
> Attachment of multiple links of same attach type to one netns is not
> supported with the intention to lift the restriction when a use-case
> presents itself. Because of that link create returns -E2BIG when trying to
> create another netns link, when one already exists.
>
> Link-based attachments to netns don't keep a netns alive by holding a ref
> to it. Instead links get auto-detached from netns when the latter is being
> destroyed, using a pernet pre_exit callback.
>
> When auto-detached, link lives in defunct state as long there are open FDs
> for it. -ENOLINK is returned if a user tries to update a defunct link.
>
> Because bpf_link to netns doesn't hold a ref to struct net, special care is
> taken when releasing, updating, or filling link info. The netns might be
> getting torn down when any of these link operations are in progress. That
> is why auto-detach and update/release/fill_info are synchronized by the
> same mutex. Also, link ops have to always check if auto-detach has not
> happened yet and if netns is still alive (refcnt > 0).
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/bpf-netns.h      |   8 ++
>  include/linux/bpf_types.h      |   3 +
>  include/net/netns/bpf.h        |   1 +
>  include/uapi/linux/bpf.h       |   5 +
>  kernel/bpf/net_namespace.c     | 244 ++++++++++++++++++++++++++++++++-
>  kernel/bpf/syscall.c           |   3 +
>  tools/include/uapi/linux/bpf.h |   5 +
>  7 files changed, 267 insertions(+), 2 deletions(-)
>

[...]

> +
> +static int bpf_netns_link_update_prog(struct bpf_link *link,
> +                                     struct bpf_prog *new_prog,
> +                                     struct bpf_prog *old_prog)
> +{
> +       struct bpf_netns_link *net_link =
> +               container_of(link, struct bpf_netns_link, link);
> +       enum netns_bpf_attach_type type = net_link->netns_type;
> +       struct net *net;
> +       int ret = 0;
> +
> +       if (old_prog && old_prog != link->prog)
> +               return -EPERM;
> +       if (new_prog->type != link->prog->type)
> +               return -EINVAL;
> +
> +       mutex_lock(&netns_bpf_mutex);
> +
> +       net = net_link->net;
> +       if (!net || !check_net(net)) {

As is, this check_net() check looks very racy. Because if we do worry
about net refcnt dropping to zero, then between check_net() and
accessing net fields that can happen. So if that's a possiblity, you
should probably instead do maybe_get_net() instead.

But on the other hand, if we established that auto-detach taking a
mutex protects us from net going away, then maybe we shouldn't worry
at all about that, and thus check_net() is unnecessary and just
unnecessarily confusing everything.

I don't know enough overall net lifecycle, so I'm not sure which one
it is. But the way it is right now still looks suspicious to me.

> +               /* Link auto-detached or netns dying */
> +               ret = -ENOLINK;
> +               goto out_unlock;
> +       }
> +
> +       old_prog = xchg(&link->prog, new_prog);
> +       rcu_assign_pointer(net->bpf.progs[type], new_prog);
> +       bpf_prog_put(old_prog);
> +
> +out_unlock:
> +       mutex_unlock(&netns_bpf_mutex);
> +       return ret;
> +}
> +
> +static int bpf_netns_link_fill_info(const struct bpf_link *link,
> +                                   struct bpf_link_info *info)
> +{
> +       const struct bpf_netns_link *net_link =
> +               container_of(link, struct bpf_netns_link, link);
> +       unsigned int inum = 0;
> +       struct net *net;
> +
> +       mutex_lock(&netns_bpf_mutex);
> +       net = net_link->net;
> +       if (net && check_net(net))
> +               inum = net->ns.inum;
> +       mutex_unlock(&netns_bpf_mutex);
> +
> +       info->netns.netns_ino = inum;
> +       info->netns.attach_type = net_link->type;
> +       return 0;
> +}
> +
> +static void bpf_netns_link_show_fdinfo(const struct bpf_link *link,
> +                                      struct seq_file *seq)
> +{
> +       struct bpf_link_info info = {};

initialization here is probably not necessary, as long as you access
only fields that fill_info initializes.

> +
> +       bpf_netns_link_fill_info(link, &info);
> +       seq_printf(seq,
> +                  "netns_ino:\t%u\n"
> +                  "attach_type:\t%u\n",
> +                  info.netns.netns_ino,
> +                  info.netns.attach_type);
> +}
> +

[...]
