Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB515A9A9
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfF2IsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 04:48:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34149 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfF2IsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 04:48:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so9195416qtu.1;
        Sat, 29 Jun 2019 01:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mqydSDRSV0jWxwz7ugy91DJaCBTfJoUbnzwjCnmfAlE=;
        b=d528cTJ2ry5mwUZWLLP+0bTACfDwdQRT1a+UXlmXQKpD0FqCHKynA4PRK+s1m7Wb0e
         QDy/4Z73Fr7/NcZwhaVWiM/ItD38f2R7/AdAf9xX2M/D3zWfYUA+YCFCtjsSiW4+r/rR
         E4Z/NyxGSM0kw8JHTxu8L7QTB2HbhrVRRixFhhbTxcCVk4fgZiLhbOiNdqkhn0Fc5kNk
         aE8r3elp1S8Bi0CXBKdnlauqKmZYrF0o6Sf3DuNKXo1wHE1uA9tlJ/y7qOPtZFQV3B2I
         Ir3Sqk9z+Q4yFSHjv1iuW497lQhonf5DukgJi9fS0dpmWrnnVpK95oHG+LA7SnYDsRUf
         uHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mqydSDRSV0jWxwz7ugy91DJaCBTfJoUbnzwjCnmfAlE=;
        b=LBfDOzE/ZOBmKi8OZmy3sjgoGMYL7tbDC084hLDYoM8PKPDiYvCxpVErNm4deuNiFA
         +7Bk2WXlpeDcrd3e5UEqtOMW6GrsZn/fNHZ3428QgtTZs6x3ZtDcANUh+rO0LmUyDm2F
         /BDJsDI+bcTdGfc49Oz/xftD1FZTdhN9AFguTdIqFa4X8uUVHbl8EKuAW+80ahkQDudQ
         WIZfGPe46jBb9zs6ra4ob3zpKg8+UQgqtoL8Ioufa1cRPEVqruA08utC7JDYjYFg8KKh
         KIK4CLjjon0vHmqFI7f0slE7pOzQDmZqtfkI1RySRqm40tTCrWIk+6pJGbHgjjHfAF9m
         au5Q==
X-Gm-Message-State: APjAAAXRDk3O52BRSBULfMe5t4cYp6ER02Mm0PcD9wkVuPRGyaYw83MH
        rKDc73ymI5BPSl2dhS5FXu64ySSGlCT4DFP0OhY=
X-Google-Smtp-Source: APXvYqyotxknvu+ydYKQ85yBhyMNk1RTktPD13hpCO3XEanmQ9qYyBdGdtulq1SOkN1Eickep4yfCE2ydmuSubGorRQ=
X-Received: by 2002:ac8:1af4:: with SMTP id h49mr11447153qtk.183.1561798103737;
 Sat, 29 Jun 2019 01:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-4-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-4-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 29 Jun 2019 01:48:12 -0700
Message-ID: <CAPhsuW460zkY6JzNUOsFQqVsezG1++nb1pKo-azwusrTJZumDg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/9] libbpf: add ability to attach/detach BPF
 program to perf event
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 8:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> bpf_program__attach_perf_event allows to attach BPF program to existing
> perf event hook, providing most generic and most low-level way to attach BPF
> programs. It returns struct bpf_link, which should be passed to
> bpf_link__destroy to detach and free resources, associated with a link.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With one nit below.

> ---
>  tools/lib/bpf/libbpf.c   | 61 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  3 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 65 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 455795e6f8af..98c155ec3bfa 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -32,6 +32,7 @@
>  #include <linux/limits.h>
>  #include <linux/perf_event.h>
>  #include <linux/ring_buffer.h>
> +#include <sys/ioctl.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/vfs.h>
> @@ -3958,6 +3959,66 @@ int bpf_link__destroy(struct bpf_link *link)
>         return err;
>  }
>
> +struct bpf_link_fd {
> +       struct bpf_link link; /* has to be at the top of struct */
> +       int fd; /* hook FD */
> +};
> +
> +static int bpf_link__destroy_perf_event(struct bpf_link *link)
> +{
> +       struct bpf_link_fd *l = (void *)link;
> +       int err;
> +
> +       if (l->fd < 0)
> +               return 0;
> +
> +       err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
> +       if (err)
> +               err = -errno;
> +
> +       close(l->fd);
> +       return err;
> +}
> +
> +struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> +                                               int pfd)
> +{
> +       char errmsg[STRERR_BUFSIZE];
> +       struct bpf_link_fd *link;
> +       int prog_fd, err;
> +
> +       prog_fd = bpf_program__fd(prog);
> +       if (prog_fd < 0) {
> +               pr_warning("program '%s': can't attach before loaded\n",
> +                          bpf_program__title(prog, false));

This warning message is not very easy to follow.

> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       link = malloc(sizeof(*link));
> +       if (!link)
> +               return ERR_PTR(-ENOMEM);
> +       link->link.destroy = &bpf_link__destroy_perf_event;
> +       link->fd = pfd;
> +
> +       if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
> +               err = -errno;
> +               free(link);
> +               pr_warning("program '%s': failed to attach to pfd %d: %s\n",
> +                          bpf_program__title(prog, false), pfd,
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(err);
> +       }
> +       if (ioctl(pfd, PERF_EVENT_IOC_ENABLE, 0) < 0) {
> +               err = -errno;
> +               free(link);
> +               pr_warning("program '%s': failed to enable pfd %d: %s\n",
> +                          bpf_program__title(prog, false), pfd,
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(err);
> +       }
> +       return (struct bpf_link *)link;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>                            void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 5082a5ebb0c2..1bf66c4a9330 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -169,6 +169,9 @@ struct bpf_link;
>
>  LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
>
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> +
>  struct bpf_insn;
>
>  /*
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 3cde850fc8da..756f5aa802e9 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -169,6 +169,7 @@ LIBBPF_0.0.4 {
>         global:
>                 bpf_link__destroy;
>                 bpf_object__load_xattr;
> +               bpf_program__attach_perf_event;
>                 btf_dump__dump_type;
>                 btf_dump__free;
>                 btf_dump__new;
> --
> 2.17.1
>
