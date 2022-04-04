Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEDD4F0D5E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376848AbiDDBQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376846AbiDDBQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:16:57 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E493388D;
        Sun,  3 Apr 2022 18:15:02 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e1so1095227ile.2;
        Sun, 03 Apr 2022 18:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBv8WYNZsg1CD0jU6C0Atd9ivPNvJO//q85Jx95DqFo=;
        b=cWq/346g2AwZJ6OOqq7B4JsUcIl7rGRxd63eGt/9N25ihEoUOIdqplDNYwsxDC29B6
         qtU/F68j7Jn2ycq+1NZg9x6HFZmWm1PABhtW0O+KqAW/Coalnd+fnJQd723soHcDLgl3
         hTjiqDoDkJTM2Ny+vWkzYNXeAXVRAGlM4JlLY3tsL0BLpq1T4JF6OhMkdiCmFYi4FO+v
         gcxGFPOpOMftSMe0cT9Vz0cnJH4TN/aeBikeYJ4C7f3gjOddOE351XS8Pyo8G7aNIa1P
         O3To54ug9wN07ajcUkDLEEmOPiLYotJ+slm6u+OVc6hXzyn/mS8GmwdYsWRK8+HXaVj+
         q+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBv8WYNZsg1CD0jU6C0Atd9ivPNvJO//q85Jx95DqFo=;
        b=JCJYbec2xhLOokOtr2sbCTCWoczaMoIBVMUIwK1Nf68f25bByqawpQOMhrni57yTEC
         Iek/JMZjBHewbh1cwT2GmiA8jCKPylv9erJoXkjmY4lj6p8Dx+eOG2RGDPu0/nUOsBuC
         VAhhKbeuFUwUxPrf+9WoNf2fMpTum9Q61qG/alGtYSwto4huNDiN3wzXYJbUS9wSIXOl
         yc/Gciq/DX3TByav1r3ZE6Kp1BUDor4pk0VPLeIzHEZ5cYR+moXH3pZxZGxg43MYVYiw
         Xj51VOa22iQI/LunXdc8o4m+3IYSBThMJ8DwfQpHBDPAUFMjGnJ2QzU/zxhYOJcRIJkS
         XTAw==
X-Gm-Message-State: AOAM531RaXx4gl/aZjYh+DCNGljadhcgud5TF+2XRpSH/6JDcIvoaNwb
        wRiY/wDdoMOoFlgv+cMWiKGKf1y/VeiTMZ9G5/4=
X-Google-Smtp-Source: ABdhPJz4fRTLWSI6FaRU323l0cadf+KyZuD8SXoCO9kmXziD+eUR2OG3hRjyBHqe+sw/WFfwtGgEEudFN4ScjLnEiVo=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr4311183ilb.305.1649034901774; Sun, 03
 Apr 2022 18:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com> <1648654000-21758-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1648654000-21758-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:14:50 -0700
Message-ID: <CAEf4Bzat_udfdM2y3B7xBO-SVa9hLcFQRW2fZPFAjCh94C=fxg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 1/5] libbpf: bpf_program__attach_uprobe_opts()
 should determine paths for programs/libraries where possible
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
> bpf_program__attach_uprobe_opts() requires a binary_path argument
> specifying binary to instrument.  Supporting simply specifying
> "libc.so.6" or "foo" should be possible too.
>
> Library search checks LD_LIBRARY_PATH, then /usr/lib64, /usr/lib.
> This allows users to run BPF programs prefixed with
> LD_LIBRARY_PATH=/path2/lib while still searching standard locations.
> Similarly for non .so files, we check PATH and /usr/bin, /usr/sbin.
>
> Path determination will be useful for auto-attach of BPF uprobe programs
> using SEC() definition.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

This patch's subject was very long, I took the liberty to shorten it as:

libbpf: auto-resolve programs/libraries when necessary for uprobes

Please yell if you strongly object.

>  tools/lib/bpf/libbpf.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 809fe20..a7d5954 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10517,6 +10517,46 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         return pfd;
>  }
>
> +/* Get full path to program/shared library. */
> +static int resolve_full_path(const char *file, char *result, size_t result_sz)
> +{
> +       const char *search_paths[2];
> +       int i;
> +
> +       if (strstr(file, ".so")) {

this check can be too brittle. It will think that binary called
"i.am.sorry" will be re assumed a shared library. While you can always
subvert this logic, maybe checking for ".so" suffix (not a substring)
and, if no such suffix found, looking for ".so." substring as a second
check? "i.am.so.sorry" still would fool it, but that looks like a very
artificial stretch.

let's improve this in a follow up

> +               search_paths[0] = getenv("LD_LIBRARY_PATH");
> +               search_paths[1] = "/usr/lib64:/usr/lib";

[...]

>  {
>         DECLARE_LIBBPF_OPTS(bpf_perf_event_opts, pe_opts);
>         char errmsg[STRERR_BUFSIZE], *legacy_probe = NULL;
> +       char full_binary_path[PATH_MAX];
>         struct bpf_link *link;
>         size_t ref_ctr_off;
>         int pfd, err;
> @@ -10536,12 +10577,22 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
>         pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
>
> +       if (binary_path && !strchr(binary_path, '/')) {
> +               err = resolve_full_path(binary_path, full_binary_path,
> +                                       sizeof(full_binary_path));
> +               if (err) {
> +                       pr_warn("failed to resolve full path for '%s'\n", binary_path);

we use "prog '%s': " prefix for error messages within
bpf_program__attach_xxx() wherever possible. Fixed up while applying.





> +                       return libbpf_err_ptr(err);
> +               }
> +               binary_path = full_binary_path;
> +       }
> +
>         legacy = determine_uprobe_perf_type() < 0;
>         if (!legacy) {
>                 pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
>                                             func_offset, pid, ref_ctr_off);
>         } else {
> -               char probe_name[512];
> +               char probe_name[PATH_MAX + 64];
>
>                 if (ref_ctr_off)
>                         return libbpf_err_ptr(-EINVAL);
> --
> 1.8.3.1
>
