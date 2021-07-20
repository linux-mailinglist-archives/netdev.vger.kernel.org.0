Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279C33D0355
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbhGTUIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbhGTTqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:46:51 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F4FC061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 13:27:24 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id x192so259586ybe.6
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 13:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f12s54+eyWIf+eHB0ztyAYYgttS0GCpkKbq47ruBZx0=;
        b=YHvtXB3bHNEHeNMHj3+gvMabWRvBS9WoGFP9+Gf6AbEOK/x3S08MKxL5ahMcyRiwh4
         c2scMP9Y1F3l9CyhGrlc0q+bZq/FojRp6UAwQRhedcpHgitDyZeze+KpOUu5ScKlbJ2X
         k0osy9wMF0G8orgjt2kf/9mOSSwtmntHlSBPgHGIO/cIvqweHJCfkrULIySaCedbwyku
         FsqAFLnIoC+ORbSJlkJ9uEP+oBxADh4kZuLKUNZZzWC1J6lj5dEiqbiA+1nQuhiaSlhv
         f3TzQ0ZqHbDoJMXaVGm4MQXGfshn+nLq7tZNj0zEeaJJ28/riW5KYBMG/KXEDHnXzIei
         a5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f12s54+eyWIf+eHB0ztyAYYgttS0GCpkKbq47ruBZx0=;
        b=O11zxXluVMo2UVd9u9Se0fkjFV91ZQIDQklEvsSEUaMNNsavpjqRdnZh7tJ8DnIEo5
         8K2O5La6Ff599SUv5CTm8JCkzKZftrfxN4tCkZul2gB0gmqUEKcgSDSkM3WYR7oEKSEz
         jEOCC5PeLfoeMt2ZL0i+9PkjKt/86QKmf0VO7GFa/aZerS5Jk9N7dH1ubWYZyZ3PuVjV
         oy+CnY9lEXux3HZ6UVah9YvtSTKuJtf+H1ObOTTIArdjJuXkB4T2KAyvo6PENDY6mAR7
         bfBu6wC3RXbKep1BOh2g5mMjxGIBy41RgjR0jxs+6Lnj8slKaQkm4XZkgPIW2E7gg3nA
         O0ZQ==
X-Gm-Message-State: AOAM531aQrztTi5e4PYdayl/YNLlBRP6swKQ25DiGdIP7gxAadRdXO4x
        QQ8iLMbxt93Zr3znb7NdQ87Tqryfg1GUxAQJnEM=
X-Google-Smtp-Source: ABdhPJwm9X6OWGd7VvFEgW+Uxa3wRr/NRZpJSGd+avbtNclbgcwzQBiPHTxNg30KvpQTjyplutymNVZ5CguMc+eh8Rk=
X-Received: by 2002:a25:9942:: with SMTP id n2mr41593997ybo.230.1626812843322;
 Tue, 20 Jul 2021 13:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt>
In-Reply-To: <20210705124307.201303-1-m@lambda.lt>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Jul 2021 13:27:12 -0700
Message-ID: <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     Martynas Pumputis <m@lambda.lt>
Cc:     Networking <netdev@vger.kernel.org>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 5, 2021 at 5:44 AM Martynas Pumputis <m@lambda.lt> wrote:
>
> When BPF programs which consists of multiple executable sections via
> iproute2+libbpf (configured with LIBBPF_FORCE=on), we noticed that a
> wrong section can be attached to a device. E.g.:
>
>     # tc qdisc replace dev lxc_health clsact
>     # tc filter replace dev lxc_health ingress prio 1 \
>         handle 1 bpf da obj bpf_lxc.o sec from-container
>     # tc filter show dev lxc_health ingress filter protocol all
>         pref 1 bpf chain 0 filter protocol all pref 1 bpf chain 0
>         handle 0x1 bpf_lxc.o:[__send_drop_notify] <-- WRONG SECTION
>         direct-action not_in_hw id 38 tag 7d891814eda6809e jited
>
> After taking a closer look into load_bpf_object() in lib/bpf_libbpf.c,
> we noticed that the filter used in the program iterator does not check
> whether a program section name matches a requested section name
> (cfg->section). This can lead to a wrong prog FD being used to attach
> the program.
>
> Fixes: 6d61a2b55799 ("lib: add libbpf support")
> Signed-off-by: Martynas Pumputis <m@lambda.lt>
> ---
>  lib/bpf_libbpf.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> index d05737a4..f76b90d2 100644
> --- a/lib/bpf_libbpf.c
> +++ b/lib/bpf_libbpf.c
> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>         }
>
>         bpf_object__for_each_program(p, obj) {
> +               bool prog_to_attach = !prog && cfg->section &&
> +                       !strcmp(get_bpf_program__section_name(p), cfg->section);

This is still problematic, because one section can have multiple BPF
programs. I.e., it's possible two define two or more XDP BPF programs
all with SEC("xdp") and libbpf works just fine with that. I suggest
moving users to specify the program name (i.e., C function name
representing the BPF program). All the xdp_mycustom_suffix namings are
a hack and will be rejected by libbpf 1.0, so it would be great to get
a head start on fixing this early on.

> +
>                 /* Only load the programs that will either be subsequently
>                  * attached or inserted into a tail call map */
> -               if (find_legacy_tail_calls(p, obj) < 0 && cfg->section &&
> -                   strcmp(get_bpf_program__section_name(p), cfg->section)) {
> +               if (find_legacy_tail_calls(p, obj) < 0 && !prog_to_attach) {
>                         ret = bpf_program__set_autoload(p, false);
>                         if (ret)
>                                 return -EINVAL;
> @@ -279,7 +281,8 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>
>                 bpf_program__set_type(p, cfg->type);
>                 bpf_program__set_ifindex(p, cfg->ifindex);
> -               if (!prog)
> +
> +               if (prog_to_attach)
>                         prog = p;
>         }
>
> --
> 2.32.0
>
