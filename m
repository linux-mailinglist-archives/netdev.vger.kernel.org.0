Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D6A2890B3
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390384AbgJISXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbgJISXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:23:35 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53813C0613D2;
        Fri,  9 Oct 2020 11:23:35 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id j76so7943201ybg.3;
        Fri, 09 Oct 2020 11:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGDeCJKVZUZU9FlKazWZGzhq32jE98lo3iMZ2Sd6y0U=;
        b=k3MRv52ArAFwLA5/6/0Fckm67Z6+9YC+T15B+OL3zEeO2OBCMknKZnJ8gbn2T3QmXb
         fiHjpK1VrG0/6ZX/5N8FF8WImgUYpzpi0y/8aJQ1CGY7O+A0TdR0qXqZCDbdMrvuAUXN
         auaHtQGJHpBo4N9AWjQWNBO+ApThPrOTWaH7mrdGiWK/LLCmorZ5EKXbh9DmobIJf0jx
         B2KtdblgtmO0CmW3XqnxYIDlT2M+l/qIRloyLRYPylPd70BbHkwEbu+VgAiXA116Yvfm
         xky8AmLUaH6z0hX4CLkm/s3zKcXmKZWBWVJ6lS2mxVYJyIM8Ve/GSLxru0+0GbEspqYb
         41eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGDeCJKVZUZU9FlKazWZGzhq32jE98lo3iMZ2Sd6y0U=;
        b=qzu/3N+Dwo4VuP/rpviwLVU0420lJ31mIrFj4ivgKPYwQhkXMIu3yBxZcoWelg9Z6g
         sWIjuwudKsK0AqSOknzVBhl7NhX21ZxMkTtn5NlElR9LAlG9/+pR1HVkoicWfbv3Kam+
         8L9WcsGusNr/TBu3joOz89NC0SIMnXKQ9Zkd0QBW+3IkB/k/6hhGuNIYFjizVb9UcnSc
         GRLupDKT0VjboAgoxnWjN2XCnqnrBxjgnbui6e0UU5FVF0jtz5mdx4TI9UkbrpSuWrF0
         RUha7PHl5BsqhB0CiYHiW21GF3cNUJl84m7+vZ86k8Uxs0KlDpUJzhhKFiRmi6sPrejk
         EngA==
X-Gm-Message-State: AOAM531lnbVJp1g6U2h5QJa9GG/5Trdq3PZice5INpFeA45kNDlbUw2N
        TcvXE7K74hTSugiBJ69fJPrmuu4ihZxqsSxaGX0=
X-Google-Smtp-Source: ABdhPJzIEtTxAXavDw406psjcDSZzKPQ26vbxjOMxfnT0frp9QZZeTfVhMhmqgrM9DrSimGeuVEYEyZbGBwguv7x9ro=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr9806345ybe.403.1602267814628;
 Fri, 09 Oct 2020 11:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <20201009160353.1529-3-danieltimlee@gmail.com>
In-Reply-To: <20201009160353.1529-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 11:23:23 -0700
Message-ID: <CAEf4Bzao-mCaQ4BnvoFZ_-wMSuoJ3JMJw1SAuy9bNRwy0E7qdg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] samples: bpf: Replace attach_tracepoint() to
 attach() in xdp_redirect_cpu
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> From commit d7a18ea7e8b6 ("libbpf: Add generic bpf_program__attach()"),
> for some BPF programs, it is now possible to attach BPF programs
> with __attach() instead of explicitly calling __attach_<type>().
>
> This commit refactors the __attach_tracepoint() with libbpf's generic
> __attach() method. In addition, this refactors the logic of setting
> the map FD to simplify the code. Also, the missing removal of
> bpf_load.o in Makefile has been fixed.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/Makefile                |   2 +-
>  samples/bpf/xdp_redirect_cpu_user.c | 138 +++++++++++++---------------
>  2 files changed, 67 insertions(+), 73 deletions(-)
>

[...]

>  #define NUM_TP 5
> +#define NUM_MAP 9
>  struct bpf_link *tp_links[NUM_TP] = { 0 };

= {}

> +static int map_fds[NUM_MAP];
>  static int tp_cnt = 0;
>
>  /* Exit return codes */

[...]

> -static struct bpf_link * attach_tp(struct bpf_object *obj,
> -                                  const char *tp_category,
> -                                  const char* tp_name)
> +static int init_tracepoints(struct bpf_object *obj)
>  {
> +       char *tp_section = "tracepoint/";
>         struct bpf_program *prog;
> -       struct bpf_link *link;
> -       char sec_name[PATH_MAX];
> -       int len;
> +       const char *section;
>
> -       len = snprintf(sec_name, PATH_MAX, "tracepoint/%s/%s",
> -                      tp_category, tp_name);
> -       if (len < 0)
> -               exit(EXIT_FAIL);
> +       bpf_object__for_each_program(prog, obj) {
> +               section = bpf_program__section_name(prog);
> +               if (strncmp(section, tp_section, strlen(tp_section)) != 0)
> +                       continue;

that's a convoluted and error-prone way (you can also use "tp/bla/bla"
for tracepoint programs, for example). Use
bpf_program__is_tracepoint() check.

>
> -       prog = bpf_object__find_program_by_title(obj, sec_name);
> -       if (!prog) {
> -               fprintf(stderr, "ERR: finding progsec: %s\n", sec_name);
> -               exit(EXIT_FAIL_BPF);
> +               tp_links[tp_cnt] = bpf_program__attach(prog);
> +               if (libbpf_get_error(tp_links[tp_cnt])) {
> +                       tp_links[tp_cnt] = NULL;
> +                       return -EINVAL;
> +               }
> +               tp_cnt++;
>         }
>

[...]
