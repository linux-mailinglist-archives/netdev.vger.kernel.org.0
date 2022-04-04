Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5350B4F0D61
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376857AbiDDBRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376856AbiDDBRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:17:04 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF7033A02;
        Sun,  3 Apr 2022 18:15:08 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e13so2068516ils.8;
        Sun, 03 Apr 2022 18:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEKf8Pde9YY8auSd618KCyUh2uF47WnRFUOuZMe9eRU=;
        b=F0AIN2HuZPFKqqtGI5IEreYlRwnyNMJyYzfBhIzGIljOqw9XUhNcd234UoLoaX0GiA
         v4xuIReNWKpq++QYoD391qNrX324QZqrH7EcvMU+HvWhGNlvPgfj4S8DQ0MN8V2RODbQ
         oZedw/9aAVSFlVWXzRPoC3UQGuZdDc0Wqon0rewb6YhAUpCl6X914QNTNG/g4FSA3zv/
         VFlgpsC/01fofFZFyhQME5TNSIYAH6vfc85d/gqVsEYCg2cuOdyjPW1tHI/jTtmSnDeW
         eTwrrTzOmnxw24Pud+xObE6rWeln1OiTj6mXVK+rO+Fn6tRpKwIzYte0fwn04vkkir5P
         /LSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEKf8Pde9YY8auSd618KCyUh2uF47WnRFUOuZMe9eRU=;
        b=p1XzLqbSgVCwY841A6wlwlgZkZpIa6B0BpdABLSE5tbV/6IX5cBwryVDvFKfqch6Ik
         52ColuAe+LxGqqqfiQ7Ai36z0xDHxU20I/rgQ9P/bjTgd9ZrjlV5X1ibwpwhwDzXBsdk
         OY5iTVd8SgQAPEapOOWBSNNuUd9PcZIJonG4BXOYVm3VjpnEQXktjTQ1B9Mcpx3AHj6w
         arKJpRfKQhvzd7iffgqatPPqWEjfH6l4EjQ/k9JzfjsevjJoGGpck5+nldxG93Y9qlLP
         RTDBpetfs5cd1kVw0Q0P4bYe5HzVU/N2/ttiEAma6ySTB4tNjOY5qVL1bse9O31GwWHS
         iDqQ==
X-Gm-Message-State: AOAM533OHDo69ZPAczL6zDFvjKAND+sz04hA0da4PVNU3Ftq5pVFqqKy
        r/UPaAXYbsSXQXYU6k4Uq+dCA5o1Hcw95nwIsVc=
X-Google-Smtp-Source: ABdhPJzFaB4EAzesNWDFaG3hzHIVoCjY8w3JB9INbo4eHEa1Ri/52JSAE0erg6EWO3vlYL+ltK9Jx+muD3paH9IE6u8=
X-Received: by 2002:a92:cd89:0:b0:2c9:bdf3:c5dd with SMTP id
 r9-20020a92cd89000000b002c9bdf3c5ddmr4124444ilb.252.1649034908137; Sun, 03
 Apr 2022 18:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com> <1648654000-21758-4-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1648654000-21758-4-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:14:57 -0700
Message-ID: <CAEf4BzbB3yeKdxqGewFs=BA+bXBNfhDf2Xh4XzBjrsSp_0khPQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/5] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Now that u[ret]probes can use name-based specification, it makes
> sense to add support for auto-attach based on SEC() definition.
> The format proposed is
>
>         SEC("u[ret]probe/binary:[raw_offset|[function_name[+offset]]")
>
> For example, to trace malloc() in libc:
>
>         SEC("uprobe/libc.so.6:malloc")
>
> ...or to trace function foo2 in /usr/bin/foo:
>
>         SEC("uprobe//usr/bin/foo:foo2")
>
> Auto-attach is done for all tasks (pid -1).  prog can be an absolute
> path or simply a program/library name; in the latter case, we use
> PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
> standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
> the file is not found via environment-variable specified locations.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 72 insertions(+), 2 deletions(-)
>

[...]

> +static int attach_uprobe(const struct bpf_program *prog, long cookie, struct bpf_link **link)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> +       char *func, *probe_name, *func_end;
> +       char *func_name, binary_path[512];
> +       unsigned long long raw_offset;
> +       size_t offset = 0;
> +       int n;
> +
> +       *link = NULL;
> +
> +       opts.retprobe = str_has_pfx(prog->sec_name, "uretprobe/");
> +       if (opts.retprobe)
> +               probe_name = prog->sec_name + sizeof("uretprobe/") - 1;
> +       else
> +               probe_name = prog->sec_name + sizeof("uprobe/") - 1;

I think this will mishandle SEC("uretprobe"), let's fix this in a
follow up (and see a note about uretprobe selftests)

> +
> +       /* handle SEC("u[ret]probe") - format is valid, but auto-attach is impossible. */
> +       if (strlen(probe_name) == 0) {
> +               pr_debug("section '%s' is old-style u[ret]probe/function, cannot auto-attach\n",
> +                        prog->sec_name);

this seems excessive to log this, it's expected situation. The message
itself is also misleading, SEC("uretprobe") isn't old-style, it's
valid and supported case. SEC("uretprobe/something") is an error now,
so that's a different thing (let's improve handling in the follow up).

> +               return 0;
> +       }
> +       snprintf(binary_path, sizeof(binary_path), "%s", probe_name);
> +       /* ':' should be prior to function+offset */
> +       func_name = strrchr(binary_path, ':');
> +       if (!func_name) {
> +               pr_warn("section '%s' missing ':function[+offset]' specification\n",
> +                       prog->sec_name);
> +               return -EINVAL;
> +       }
> +       func_name[0] = '\0';
> +       func_name++;
> +       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> +       if (n < 1) {
> +               pr_warn("uprobe name '%s' is invalid\n", func_name);
> +               return -EINVAL;
> +       }

I have this feeling that you could have simplified this a bunch with
just one sscanf. Something along the lines of
"%m[^/]/%m[^:]:%m[a-zA-Z0-9_.]+%li". If one argument matched (supposed
to be uprobe or uretprobe), then it is a no-auto-attach case, just
exit. If two matched -- invalid definition (old-style definition you
were reporting erroneously above in pr_debug). If 3 matched -- binary
+ func (or abs offset), if 4 matched - binary + func + offset. That
should cover everything, right?

Please try to do this in a follow up.

> +       if (opts.retprobe && offset != 0) {
> +               free(func);
> +               pr_warn("uretprobes do not support offset specification\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Is func a raw address? */
> +       errno = 0;
> +       raw_offset = strtoull(func, &func_end, 0);
> +       if (!errno && !*func_end) {
> +               free(func);
> +               func = NULL;
> +               offset = (size_t)raw_offset;
> +       }
> +       opts.func_name = func;
> +
> +       *link = bpf_program__attach_uprobe_opts(prog, -1, binary_path, offset, &opts);
> +       free(func);
> +       return 0;

this should have been return libbpf_get_error(*link), fixed it


> +}
> +
>  struct bpf_link *bpf_program__attach_uprobe(const struct bpf_program *prog,
>                                             bool retprobe, pid_t pid,
>                                             const char *binary_path,
> --
> 1.8.3.1
>
