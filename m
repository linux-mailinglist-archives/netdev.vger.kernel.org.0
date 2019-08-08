Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACA686AB9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbfHHTrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:47:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41611 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbfHHTrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:47:23 -0400
Received: by mail-ot1-f65.google.com with SMTP id o101so123441915ota.8
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aoscBPHz3zXVrqZF7nIahC0lLZ2C7bmdx9G+BQ3FK6w=;
        b=jRbruSeKOOQMhDbLbeBTcdCRXowPAAnqrrzn7rKxkGmVBjNatfMszrk5FxBIM4tqHU
         UXoh6O1ffoFYff74+nzW9zNgGWZn0C46C+tIe505k3cR+8TWRML/sOnuG2AUOP8csahz
         Fsi0W1mWXBKXTpaU4lpLnXzbsCoD47o2C8e96DoTv8Xm0CiWa5wL39S8oKdtVeOMUNM/
         5aV+ndXAoDyxcCJTOx+q/AvAi8gPAz9UrnCKYVlRtX16ivtp+adQbXhHkNqXTZ8uv3Gx
         7JV8pkfcuJDeIlb3LRJgHZW66Gjw+soC9SG+FFzueHniasiV9bZAICClx+SoZlJihbyt
         b2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aoscBPHz3zXVrqZF7nIahC0lLZ2C7bmdx9G+BQ3FK6w=;
        b=XzjOIEG77pggLtI8j6coAXOWhpbS9jjwJ1qh/EHQV1AqUgd/g14NIrYe+7kKoOf8MS
         dUrnkXt9O41KViU8qXub/bJ1h55J7S9F0Q3T0tnUr6ZJJ6SxzqakabL7DNMZVJdTsnk/
         ZCAAJV7dxlufarpch7kg2Ztnv0SjLL+ByXAm7+V0asAYQoyY4rO6xfHy2GaXn7McpXV7
         RGvu0bRjZpNhRJvV6iUz72zgl5YlRWtzXd98V9F/GMc4zQv20qAtXXO78OO/AoOAdGUy
         7rOfgB0Fkm5sLkvcdjMj+PPqtC+TOuLabglMI9QnnjriH53BoiC23DjCj7l2s+IUSFb1
         CasQ==
X-Gm-Message-State: APjAAAXQ6NBgKY9ziJA0TnF94jNtw20NxrAnfTZKyeRqZ6CLPu4+nnrG
        eRVBNqFfctljHzp0bqPnkLkDYNhqyE5kYXkn4LG331l2hqA=
X-Google-Smtp-Source: APXvYqxTYbLp/LWq0YBd2S/vGzOLb4LP2vz+wbiuIbJKyjfCWpc7x90pJrNzE2PHxunnrV0FOpp19HNF9rP2HHLPZjQ=
X-Received: by 2002:a5d:9448:: with SMTP id x8mr18264878ior.102.1565293642428;
 Thu, 08 Aug 2019 12:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <156528102557.22124.261409336813472418.stgit@firesoul> <156528106270.22124.2563148023961869582.stgit@firesoul>
In-Reply-To: <156528106270.22124.2563148023961869582.stgit@firesoul>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 8 Aug 2019 12:46:46 -0700
Message-ID: <CAH3MdRXZ-Wy4zADhQvba8rWEZrZNZi4SjorkJfrJo42oufinAw@mail.gmail.com>
Subject: Re: [bpf-next v3 PATCH 2/3] samples/bpf: make xdp_fwd more
 practically usable via devmap lookup
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        a.s.protopopov@gmail.com, David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 8, 2019 at 9:17 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> This address the TODO in samples/bpf/xdp_fwd_kern.c, which points out
> that the chosen egress index should be checked for existence in the
> devmap. This can now be done via taking advantage of Toke's work in
> commit 0cdbb4b09a06 ("devmap: Allow map lookups from eBPF").
>
> This change makes xdp_fwd more practically usable, as this allows for
> a mixed environment, where IP-forwarding fallback to network stack, if
> the egress device isn't configured to use XDP.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  samples/bpf/xdp_fwd_kern.c |   17 +++++++++++------
>  samples/bpf/xdp_fwd_user.c |   33 ++++++++++++++++++++++-----------
>  2 files changed, 33 insertions(+), 17 deletions(-)
>
> diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
> index e6ffc4ea06f4..a43d6953c054 100644
> --- a/samples/bpf/xdp_fwd_kern.c
> +++ b/samples/bpf/xdp_fwd_kern.c
> @@ -104,13 +104,18 @@ static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
>
>         rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params), flags);
>
> -       /* verify egress index has xdp support
> -        * TO-DO bpf_map_lookup_elem(&tx_port, &key) fails with
> -        *       cannot pass map_type 14 into func bpf_map_lookup_elem#1:
> -        * NOTE: without verification that egress index supports XDP
> -        *       forwarding packets are dropped.
> -        */
>         if (rc == 0) {
> +               /* Verify egress index has been configured as TX-port.
> +                * (Note: User can still have inserted an egress ifindex that
> +                * doesn't support XDP xmit, which will result in packet drops).
> +                *
> +                * Note: lookup in devmap supported since 0cdbb4b09a0.
> +                * If not supported will fail with:
> +                *  cannot pass map_type 14 into func bpf_map_lookup_elem#1:
> +                */
> +               if (!bpf_map_lookup_elem(&xdp_tx_ports, &fib_params.ifindex))
> +                       return XDP_PASS;
> +
>                 if (h_proto == htons(ETH_P_IP))
>                         ip_decrease_ttl(iph);
>                 else if (h_proto == htons(ETH_P_IPV6))
> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
> index ba012d9f93dd..97ff1dad7669 100644
> --- a/samples/bpf/xdp_fwd_user.c
> +++ b/samples/bpf/xdp_fwd_user.c
> @@ -27,14 +27,20 @@
>  #include "libbpf.h"
>  #include <bpf/bpf.h>
>
> -
> -static int do_attach(int idx, int fd, const char *name)
> +static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
>  {
>         int err;
>
> -       err = bpf_set_link_xdp_fd(idx, fd, 0);
> -       if (err < 0)
> +       err = bpf_set_link_xdp_fd(idx, prog_fd, 0);
> +       if (err < 0) {
>                 printf("ERROR: failed to attach program to %s\n", name);
> +               return err;
> +       }
> +
> +       /* Adding ifindex as a possible egress TX port */
> +       err = bpf_map_update_elem(map_fd, &idx, &idx, 0);
> +       if (err)
> +               printf("ERROR: failed using device %s as TX-port\n", name);
>
>         return err;
>  }
> @@ -47,6 +53,9 @@ static int do_detach(int idx, const char *name)
>         if (err < 0)
>                 printf("ERROR: failed to detach program from %s\n", name);
>
> +       /* TODO: Remember to cleanup map, when adding use of shared map
> +        *  bpf_map_delete_elem((map_fd, &idx);
> +        */
>         return err;
>  }
>
> @@ -67,10 +76,10 @@ int main(int argc, char **argv)
>         };
>         const char *prog_name = "xdp_fwd";
>         struct bpf_program *prog;
> +       int prog_fd, map_fd = -1;
>         char filename[PATH_MAX];
>         struct bpf_object *obj;
>         int opt, i, idx, err;
> -       int prog_fd, map_fd;
>         int attach = 1;
>         int ret = 0;
>
> @@ -103,8 +112,14 @@ int main(int argc, char **argv)
>                         return 1;
>                 }
>
> -               if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
> +               err = bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd);
> +               if (err) {
> +                       printf("Does kernel support devmap lookup?\n");
> +                       /* If not, the error message will be:
> +                        *  "cannot pass map_type 14 into func bpf_map_lookup_elem#1"
> +                        */
>                         return 1;
> +               }
>
>                 prog = bpf_object__find_program_by_title(obj, prog_name);
>                 prog_fd = bpf_program__fd(prog);
> @@ -119,10 +134,6 @@ int main(int argc, char **argv)
>                         return 1;
>                 }
>         }
> -       if (attach) {
> -               for (i = 1; i < 64; ++i)
> -                       bpf_map_update_elem(map_fd, &i, &i, 0);
> -       }
>
>         for (i = optind; i < argc; ++i) {
>                 idx = if_nametoindex(argv[i]);
> @@ -138,7 +149,7 @@ int main(int argc, char **argv)
>                         if (err)
>                                 ret = err;
>                 } else {
> -                       err = do_attach(idx, prog_fd, argv[i]);
> +                       err = do_attach(idx, prog_fd, map_fd, argv[i]);
>                         if (err)
>                                 ret = err;
>                 }
>
