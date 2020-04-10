Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6ED1A4C7E
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDJXNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:13:49 -0400
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44592 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDJXNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:13:49 -0400
Received: by mail-qv1-f65.google.com with SMTP id ef12so1669686qvb.11;
        Fri, 10 Apr 2020 16:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJHuZ/WcwcoaB0mu9da2/kaWS2bJruYQ3O4lQYvvXc4=;
        b=JXB+kbDt25CrVFs+DAS1Kmbk4dzpZf0tLTKOgwk0o7Lm36EpxGEvXruXCdZQYleZt3
         suLWQlopEZHUtjxjs1/7rV9owk0CSF0OVCCR51G7bejesfIfnHddqPt7KjkHhD3XQUih
         LsLEXptSf2mTLSC3j+JzC01VBKc6ZmfXyOJhfPPnbjJDdxxrUbgVIqRTh8EYioJtiCnn
         9BTYWE5juIoKa2yJb3PzleSoHIu6lt/1ua6/s5uwsUycm2IFr1AtCfHch7kmB/gBZlzU
         Mtuy5h+YHV0+Cupj3DugT3/FULtF35uscaPRxyV8yDlL8eOz19tiX0gljy6L1RuTDlvT
         Wk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJHuZ/WcwcoaB0mu9da2/kaWS2bJruYQ3O4lQYvvXc4=;
        b=tvhGbZWqYOYfKY1Tp2kA1VBaz1+Onw6ppuVcJmj8m3Z5QXnvOYVuzY/E11rSkE1TYd
         nqNMWxem/pB9Ky8peJC8LVmyyL8SLk28/I+K7NDuXrXYrymsn65y6bQVwvXw9PotygCI
         ZGL/WcgO0jiMd/3JHven2n4hXv7jFJCJfDKF+knR2Qr0RPm7ZxfOu2G3m30iXsXOrFmp
         8QXSww0ItZsyosC0HBuER3vT5WfhLI7nSfNcq6azoba3r8N697teCitzsAlWn11WpYK5
         JMBdwhhCgTKqi1uaTpvjAXnDNMmXjdYDRxXWJ3dYF1CabRwuG77MjO2O5h2H//xFRjoz
         R6aw==
X-Gm-Message-State: AGi0PuZvF7UITS20h/brDe1OtuDdyssEBACBVJO8crp6thePExI2k8jU
        CwfLMk98GkUXQZnwIB7Ae0R/Wl7GkX0dkg8TXzBHkoV0huM5yA==
X-Google-Smtp-Source: APiQypKdWQ3JnrkC8sdyWo99Q9Il2FZQnyo2/hO4NRsVQcabOwFcow3Z8hrbbjXHr7Igc9I2H7Dm9NgiAOQuB5cUFaE=
X-Received: by 2002:a0c:ec10:: with SMTP id y16mr7479630qvo.163.1586560427035;
 Fri, 10 Apr 2020 16:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232527.2675717-1-yhs@fb.com>
In-Reply-To: <20200408232527.2675717-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 16:13:36 -0700
Message-ID: <CAEf4BzaGrL0h1CC8XCngNnMBAAECSGPNbP6hVshByppVa2wbsg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 06/16] bpf: add netlink and ipv6_route targets
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:25 PM Yonghong Song <yhs@fb.com> wrote:
>
> This patch added netlink and ipv6_route targets, using
> the same seq_ops (except show()) for /proc/net/{netlink,ipv6_route}.
>
> Since module is not supported for now, ipv6_route is
> supported only if the IPV6 is built-in, i.e., not compiled
> as a module. The restriction can be lifted once module
> is properly supported for bpfdump.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h      |  1 +
>  kernel/bpf/dump.c        | 13 ++++++++++
>  net/ipv6/ip6_fib.c       | 41 +++++++++++++++++++++++++++++-
>  net/ipv6/route.c         | 22 ++++++++++++++++
>  net/netlink/af_netlink.c | 54 +++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 129 insertions(+), 2 deletions(-)
>

[...]

>
> +#if IS_BUILTIN(CONFIG_IPV6)
> +static int ipv6_route_prog_seq_show(struct bpf_prog *prog, struct seq_file *seq,
> +                                   u64 seq_num, void *v)
> +{
> +       struct ipv6_route_iter *iter = seq->private;
> +       struct {
> +               struct fib6_info *rt;
> +               struct seq_file *seq;
> +               u64 seq_num;
> +       } ctx = {

So this anonymous struct definition has to match bpfdump__ipv6_route
function prototype, if I understand correctly. So this means that BTF
will have a very useful struct, that can be used directly in BPF
program, but it won't have a canonical name. This is very sad... Would
it be possible to instead use a struct as a prototype for these
dumpers? Here's why it matters. Instead of currently requiring BPF
users to declare their dumpers as (just copy-pasted):

int BPF_PROG(some_name, struct fib6_info *rt, struct seq_file *seq,
u64 seq_num) {
   ...
}

if bpfdump__ipv6_route was actually a struct definition:


struct bpfdump__ipv6_route {
    struct fib6_info *rt;
    struct seq_file *seq;
    u64 seq_num;
};

Then with vmlinux.h, such program would be very nicely declared and used as:

int some_name(struct bpfdump__ipv6_route *ctx) {
  /* here use ctx->rt, ctx->seq, ctx->seqnum */
}

This is would would be nice to have for raw_tp and tp_btf as well.


Of course we can also code-generate such types from func_protos in
bpftool, and that's a plan B for this, IMO. But seem like in this case
you already have two keep two separate entities in sync: func proto
and struct for context, so I thought I'd bring it up.

> +               .rt = v,
> +               .seq = seq,
> +               .seq_num = seq_num,
> +       };
> +       int ret;
> +
> +       ret = bpf_dump_run_prog(prog, &ctx);
> +       iter->w.leaf = NULL;
> +       return ret == 0 ? 0 : -EINVAL;
> +}
> +
