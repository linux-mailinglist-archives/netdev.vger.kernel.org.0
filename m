Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC3E1E5724
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 08:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgE1GAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 02:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgE1GAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 02:00:08 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B23CC05BD1E;
        Wed, 27 May 2020 23:00:08 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id dh1so12373905qvb.13;
        Wed, 27 May 2020 23:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSIkqll8sUKJVfyJgzmApri/Tnr6UPthp9Pzww75BE4=;
        b=ShLu1XZcu2ukWKbMEKyv0j193Ikr/j5pjAK3b351juvhkycAN8dou6IAQSpyYZ6Vap
         uhHtWhZK+TlXpmNCDMfOm91UmNWFsKIDg1abJP1KKp3E9dAbelUyFlh0SrAAjvl4lzLQ
         BZ3BTBLgMoilQWxyvreZJGPYXqUCGRxB6VC+VTRfY6xdib7A12CEqesfTN07OWsdne5V
         p5nt2sBGdi+qaDjx2YNQhejanwiu208C5t+LaiUx86rJvKwRqQGXCN40FotbPgss4tqV
         hBwvt1NuSBXGwuYoNUPpylnnNNvtaRMPjwQ/zkr6qn+1IVrL9AetlhCYB7r4Gp6w4PjU
         IeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSIkqll8sUKJVfyJgzmApri/Tnr6UPthp9Pzww75BE4=;
        b=fXQLmqkUoebgZKuknEb/zs+/LzmNbt7ddhtoE8+QcWOsmlkClD6UAvMwB393NFppQ0
         MJMNWJOLbeNG+n2H0xTl7Yf32hLTDknwH0PT8o7q1R2qeFQdPYtK8NjQ/tBXazIw08kZ
         BTKfIkVHhto6TVtfjvqOJ1OWskyVZhdhJ9Cqe/uDz+p9Z8GkBQEhg9kbxBrIuvNYoRo3
         3BR1qj4gztLIXXTWCOEIzK3lBB3nFCI84Bf3c+RTVNovieWilWQ3CIqssga62xf25AXD
         cnhGXqK1huHA39EPmPkAOB+bTiGjLMGmsHx3MRBNqhtKnRX9/QtjA7NMi9sw9pJx5+3e
         lNjQ==
X-Gm-Message-State: AOAM532dj6t0BofiwM9cxLyEV6qaj50oOaiuX1a9b1wbUly0EXPXcyoJ
        FA/7aNXTlIfIKKSA9k2LteDXZj0f1Tn+kwJ4Qzc=
X-Google-Smtp-Source: ABdhPJwtF9ZTYo3xzbvHmGh3cm1p5T0Y3MwedpCvRYHC5yeXW0KDc1GBwDDCJr0jwbEXBE8DHa3dnocYGgMzFP08DAY=
X-Received: by 2002:ad4:55ea:: with SMTP id bu10mr1572148qvb.163.1590645607292;
 Wed, 27 May 2020 23:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-7-jakub@cloudflare.com>
In-Reply-To: <20200527170840.1768178-7-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 May 2020 22:59:56 -0700
Message-ID: <CAEf4BzZJU-zRXzQU3X3zyBWX4=nxfDTjyqjzJ6NV3HvGUxNd_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/8] libbpf: Add support for bpf_link-based netns attachment
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:16 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Add bpf_program__attach_nets(), which uses LINK_CREATE subcommand to create
> an FD-based kernel bpf_link, for attach types tied to network namespace,
> that is BPF_FLOW_DISSECTOR for the moment.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/lib/bpf/libbpf.c   | 20 ++++++++++++++++----
>  tools/lib/bpf/libbpf.h   |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5d60de6fd818..a49c1eb5db64 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7894,8 +7894,8 @@ static struct bpf_link *attach_iter(const struct bpf_sec_def *sec,
>         return bpf_program__attach_iter(prog, NULL);
>  }
>
> -struct bpf_link *
> -bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
> +static struct bpf_link *
> +bpf_program__attach_fd(struct bpf_program *prog, int target_fd)
>  {
>         enum bpf_attach_type attach_type;
>         char errmsg[STRERR_BUFSIZE];
> @@ -7915,11 +7915,11 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>         link->detach = &bpf_link__detach_fd;
>
>         attach_type = bpf_program__get_expected_attach_type(prog);
> -       link_fd = bpf_link_create(prog_fd, cgroup_fd, attach_type, NULL);
> +       link_fd = bpf_link_create(prog_fd, target_fd, attach_type, NULL);
>         if (link_fd < 0) {
>                 link_fd = -errno;
>                 free(link);
> -               pr_warn("program '%s': failed to attach to cgroup: %s\n",
> +               pr_warn("program '%s': failed to attach to cgroup/netns: %s\n",

I understand the desire to save few lines of code, but it hurts error
reporting. Now it's cgroup/netns, tomorrow cgroup/netns/lirc/whatever.
If you want to generalize, let's preserve clarity of error message,
please.

>                         bpf_program__title(prog, false),
>                         libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
>                 return ERR_PTR(link_fd);
> @@ -7928,6 +7928,18 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>         return link;
>  }
>
> +struct bpf_link *
> +bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
> +{
> +       return bpf_program__attach_fd(prog, cgroup_fd);
> +}
> +
> +struct bpf_link *
> +bpf_program__attach_netns(struct bpf_program *prog, int netns_fd)
> +{
> +       return bpf_program__attach_fd(prog, netns_fd);
> +}
> +
>  struct bpf_link *
>  bpf_program__attach_iter(struct bpf_program *prog,
>                          const struct bpf_iter_attach_opts *opts)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 1e2e399a5f2c..adf6fd9b6fe8 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -253,6 +253,8 @@ LIBBPF_API struct bpf_link *
>  bpf_program__attach_lsm(struct bpf_program *prog);
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_netns(struct bpf_program *prog, int netns_fd);
>
>  struct bpf_map;
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 381a7342ecfc..7ad21ba1feb6 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -263,4 +263,5 @@ LIBBPF_0.0.9 {
>                 bpf_link_get_next_id;
>                 bpf_program__attach_iter;
>                 perf_buffer__consume;
> +               bpf_program__attach_netns;

Please keep it alphabetical.

>  } LIBBPF_0.0.8;
> --
> 2.25.4
>
