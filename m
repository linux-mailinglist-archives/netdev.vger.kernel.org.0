Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBE7399508
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhFBU6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBU6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:58:46 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E03C06174A;
        Wed,  2 Jun 2021 13:56:48 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i4so5758375ybe.2;
        Wed, 02 Jun 2021 13:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98R4y9Ho6Ds3Ftg0xtA3UpEMeFR69/Ooe51tALQPpbM=;
        b=LCbji9yw3EhRCmaoHzv4Bm+6BTNkKugE9sQ8XCj5r03OwKnupL4di6BLbtwTLLM22S
         xrwu4meCAb0RpZz/hJR3Jk3dqYZ4RlIEMcVGLonD9V/rcUuaqrarJVQzp0/XtsP0vIKV
         VRiyuWPxJ3vTHycOC/77lHCCbS2+RV/luSDT+KV1YAemzHIeXLG2stS5a3qOFPcabxOR
         YDfieU8V5CA3pCirFCmQfwfxAa3x2gbQlzMQPZX6i9hESOZgDFAoB2tpWg62ZRVQ/M7F
         DCfmEmXJLcbHa9BXZ8f4FRGVSzR93dl1wd70GDqAFs5amy/nQvvrPOTsijwNMwKIEMhz
         qobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98R4y9Ho6Ds3Ftg0xtA3UpEMeFR69/Ooe51tALQPpbM=;
        b=kPVeVwtu2k6a+7D0QR68NW2GR5GAOhYaA23glc2HkpRsXpriEYHoEgAC+QAiMtEM7J
         A0vGrz6bwItO/PHdHuoFZahVHMQ63Gd6Won+TPy2QDI2RSwfZxEUuOoodxJoTZIFyF4o
         bA+XL6VfDMPGfaNVK1jH4nJF90XtpmzdketSm4pGyLtZFSdlYW5NOhM5/uvo2x1VY2ut
         TnEQh1ipQYuJXNm7/TfZth7benlpJ5CvjKDBqA5VNJVzVft8FxHKeP5BbffoXWBkCo9D
         SXzdwxu5hwiGEByf6s5GXdXVjWYmPJZ/QcrgkLx2Nzki3jw9VbuaCQKJF+hHYZLfNPGS
         WakQ==
X-Gm-Message-State: AOAM531lWq6lFyOlZLsmIJR8PVBZuIJ6WDzBx9UaedOYfUYX/TZ7lzbg
        No3a7OWlHjR9TkLB4mRHvDzpHxDb/sntstR0fIo=
X-Google-Smtp-Source: ABdhPJzLeeinr8SRIhdmTc+TH1lTmioEAPlVkZAJomXsyYx5bE1Az/pNDImQprCLFW/Jf6f5FTazpVASKGLmwceYQes=
X-Received: by 2002:a25:3357:: with SMTP id z84mr48894565ybz.260.1622667405589;
 Wed, 02 Jun 2021 13:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <20210528195946.2375109-4-memxor@gmail.com>
In-Reply-To: <20210528195946.2375109-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Jun 2021 13:56:34 -0700
Message-ID: <CAEf4BzYk1vRUPgP4rVc4WYcLUtqOcGKjHfgsVuDhOm5hJU-Qhg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 3/7] net: sched: add bpf_link API for bpf classifier
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 1:00 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This commit introduces a bpf_link based kernel API for creating tc
> filters and using the cls_bpf classifier. Only a subset of what netlink
> API offers is supported, things like TCA_BPF_POLICE, TCA_RATE and
> embedded actions are unsupported.
>
> The kernel API and the libbpf wrapper added in a subsequent patch are
> more opinionated and mirror the semantics of low level netlink based
> TC-BPF API, i.e. always setting direct action mode, always setting
> protocol to ETH_P_ALL, and only exposing handle and priority as the
> variables the user can control. We add an additional gen_flags parameter
> though to allow for offloading use cases. It would be trivial to extend
> the current API to support specifying other attributes in the future,
> but for now I'm sticking how we want to push usage.
>
> The semantics around bpf_link support are as follows:
>
> A user can create a classifier attached to a filter using the bpf_link
> API, after which changing it and deleting it only happens through the
> bpf_link API. It is not possible to bind the bpf_link to existing
> filter, and any such attempt will fail with EEXIST. Hence EEXIST can be
> returned in two cases, when existing bpf_link owned filter exists, or
> existing netlink owned filter exists.
>
> Removing bpf_link owned filter from netlink returns EPERM, denoting that
> netlink is locked out from filter manipulation when bpf_link is
> involved.
>
> Whenever a filter is detached due to chain removal, or qdisc tear down,
> or net_device shutdown, the bpf_link becomes automatically detached.
>
> In this way, the netlink API and bpf_link creation path are exclusive
> and don't stomp over one another. Filters created using bpf_link API
> cannot be replaced by netlink API, and filters created by netlink API are
> never replaced by bpf_link. Netfilter also cannot detach bpf_link filters.
>
> We serialize all changes dover rtnl_lock as cls_bpf API doesn't support the
> unlocked classifier API.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf_types.h |   3 +
>  include/net/pkt_cls.h     |  13 ++
>  include/net/sch_generic.h |   6 +-
>  include/uapi/linux/bpf.h  |  15 +++
>  kernel/bpf/syscall.c      |  10 +-
>  net/sched/cls_api.c       | 138 ++++++++++++++++++++-
>  net/sched/cls_bpf.c       | 247 +++++++++++++++++++++++++++++++++++++-
>  7 files changed, 426 insertions(+), 6 deletions(-)
>

[...]

> +static int cls_bpf_link_change(struct net *net, struct tcf_proto *tp,
> +                              struct bpf_prog *filter, void **arg,
> +                              u32 handle, u32 gen_flags)
> +{
> +       struct cls_bpf_head *head = rtnl_dereference(tp->root);
> +       struct cls_bpf_prog *oldprog = *arg, *prog;
> +       struct bpf_link_primer primer;
> +       struct cls_bpf_link *link;
> +       int ret;
> +
> +       if (gen_flags & ~CLS_BPF_SUPPORTED_GEN_FLAGS)
> +               return -EINVAL;
> +
> +       if (oldprog)
> +               return -EEXIST;
> +
> +       prog = kzalloc(sizeof(*prog), GFP_KERNEL);
> +       if (!prog)
> +               return -ENOMEM;
> +
> +       link = kzalloc(sizeof(*link), GFP_KERNEL);
> +       if (!link) {
> +               ret = -ENOMEM;
> +               goto err_prog;
> +       }
> +
> +       bpf_link_init(&link->link, BPF_LINK_TYPE_TC, &cls_bpf_link_ops,
> +                     filter);
> +
> +       ret = bpf_link_prime(&link->link, &primer);
> +       if (ret < 0)
> +               goto err_link;
> +
> +       /* We don't init exts to save on memory, but we still need to store the
> +        * net_ns pointer, as during delete whether the deletion work will be
> +        * queued or executed inline depends on the refcount of net_ns. In
> +        * __cls_bpf_delete the reference is taken to keep the action IDR alive
> +        * (which we don't require), but its maybe_get_net also allows us to
> +        * detect whether we are being invoked in netns destruction path or not.
> +        * In the former case deletion will have to be done synchronously.
> +        *
> +        * Leaving it NULL would prevent us from doing deletion work
> +        * asynchronously, so set it here.
> +        *
> +        * On the tcf_classify side, exts->actions are not touched for
> +        * exts_integrated progs, so we should be good.
> +        */
> +       prog->exts.net = net;
> +
> +       ret = __cls_bpf_alloc_idr(head, handle, prog, oldprog);
> +       if (ret < 0)
> +               goto err_primer;
> +
> +       prog->exts_integrated = true;
> +       prog->bpf_link = link;
> +       prog->filter = filter;
> +       prog->tp = tp;
> +       link->prog = prog;
> +
> +       prog->bpf_name = cls_bpf_link_name(filter->aux->id, filter->aux->name);
> +       if (!prog->bpf_name) {
> +               ret = -ENOMEM;
> +               goto err_idr;
> +       }
> +
> +       ret = __cls_bpf_change(head, tp, prog, oldprog, NULL);
> +       if (ret < 0)
> +               goto err_name;
> +
> +       bpf_prog_inc(filter);
> +
> +       if (filter->dst_needed)
> +               tcf_block_netif_keep_dst(tp->chain->block);
> +
> +       return bpf_link_settle(&primer);
> +
> +err_name:
> +       kfree(prog->bpf_name);
> +err_idr:
> +       idr_remove(&head->handle_idr, prog->handle);
> +err_primer:
> +       bpf_link_cleanup(&primer);

once you prime the link, you can't kfree() it, you do only
bpf_link_cleanup() and it will handle eventually freeing it. So if you
look at other places doing bpf_link, they set link = NULL after
bpf_link_cleanup() to avoid directly freeing.

> +err_link:
> +       kfree(link);
> +err_prog:
> +       kfree(prog);
> +       return ret;
> +}
> +
>  static struct tcf_proto_ops cls_bpf_ops __read_mostly = {
>         .kind           =       "bpf",
>         .owner          =       THIS_MODULE,
> @@ -729,6 +973,7 @@ static struct tcf_proto_ops cls_bpf_ops __read_mostly = {
>         .reoffload      =       cls_bpf_reoffload,
>         .dump           =       cls_bpf_dump,
>         .bind_class     =       cls_bpf_bind_class,
> +       .bpf_link_change =      cls_bpf_link_change,
>  };
>
>  static int __init cls_bpf_init_mod(void)
> --
> 2.31.1
>
