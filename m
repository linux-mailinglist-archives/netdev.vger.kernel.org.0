Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690D3273554
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgIUVzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgIUVzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:55:38 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799CCC0613CF;
        Mon, 21 Sep 2020 14:55:38 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a2so11395168ybj.2;
        Mon, 21 Sep 2020 14:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8grYpU7/gTNyX9FZs93OJvfovBLe0ola3M1YosR1fEo=;
        b=gNstWBmMpmvyedGTSr3CzDxhzA0CztF0y5rSTkdfErqBb0JZhfwRZgMjp9a0pe063O
         OzfCmfauvEDw5ex1ULZfkPB9pygoXoK0NToQbZnX98ThiCcSTUbMxQAWtzC1qGmF31pd
         gYvwYwFtLFmc5BCu2EMmHMrlJgbivEXv5aJQmJgIokLX0V9PVhQalSIW6+H2Hq4b9ZAm
         3HYqwa8Yqf5hOLk6D2xs3e1MyEufmjU+iM8J62X5t9eMAS6IH10NdfoA/ujBwsOF3BdT
         OzPOY3KM92RHqrkASm5QDJWib461BbnDIr9aHxdPha2tA+rlTM7Lnsuxcw/lBvU4vwSV
         h55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8grYpU7/gTNyX9FZs93OJvfovBLe0ola3M1YosR1fEo=;
        b=JN1lWuHjMPPl7ElsddziqMsAP4hw5UUWfWJiuz5SbpKIW952jep8O/X8fmDsW21oay
         VHtsqawUEw0dfRUDpSEjn0RJ+Fuah9hao6UGGZoiTW+0y0wbj6N9TltU8HKtYeeeglT0
         3qQ0GZlKaJgGPq/i5pSXz1UfzPMRGlcTIVh0R1lI6ahOUGJ0fhz5bGTcmaJmU/2kyrPM
         MqKHuccgiayrMuHIaPzdDYctDmtNYWHr13AmgWzFEaGVgsiI7YYg8nnZ4sK9xIXWlKu1
         1wB7nvF0Odr7mlTLi0ZP+ZKbr/wV2Y+bcYrERvKJMJ8WMNAug8tbIG3p8owumoB8ewUv
         HGFg==
X-Gm-Message-State: AOAM532kG4Xw336R5bHpb1yffBTzM8KbGHbvQ3Q9sj++tnci4tKAmO4z
        XaPdlCMbOIDbquKDOlZt0HjYf9FIOrANjGnWksZubPylbDk=
X-Google-Smtp-Source: ABdhPJy4sNrW87qbVpgcSxr/19syLbLrAYGgkUMuTJlM5OkrW2BnbyQg8GoRQ/ngzuQUXFy62J+n/gqwD1CLakFOa7k=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr2763641ybp.510.1600725337798;
 Mon, 21 Sep 2020 14:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200918122654.2625699-1-jolsa@kernel.org>
In-Reply-To: <20200918122654.2625699-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 14:55:27 -0700
Message-ID: <CAEf4BzZc6DE85wUTGwE=2FKPuwuuH4480Fh+v63q8J=PRxjgEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Use --no-fail option if CONFIG_BPF is
 not enabled
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 5:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently all the resolve_btfids 'users' are under CONFIG_BPF
> code, so if we have CONFIG_BPF disabled, resolve_btfids will
> fail, because there's no data to resolve.
>
> In case CONFIG_BPF is disabled, using resolve_btfids --no-fail
> option, that makes resolve_btfids leave quietly if there's no
> data to resolve.
>
> Fixes: c9a0f3b85e09 ("bpf: Resolve BTF IDs in vmlinux image")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

If no CONFIG_BTF is specified, there is no need to even run
resolve_btfids. So why not do just that -- run resolve_btfids only
if both CONFIG_BPF and CONFIG_DEBUG_INFO_BTF are specified?


>  scripts/link-vmlinux.sh | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index e6e2d9e5ff48..3173b8cf08cb 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -342,8 +342,13 @@ vmlinux_link vmlinux "${kallsymso}" ${btf_vmlinux_bin_o}
>
>  # fill in BTF IDs
>  if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> -info BTFIDS vmlinux
> -${RESOLVE_BTFIDS} vmlinux
> +       info BTFIDS vmlinux
> +       # Let's be more permissive if CONFIG_BPF is disabled
> +       # and do not fail if there's no data to resolve.
> +       if [ -z "${CONFIG_BPF}" ]; then
> +         no_fail=--no-fail
> +       fi
> +       ${RESOLVE_BTFIDS} $no_fail vmlinux
>  fi
>
>  if [ -n "${CONFIG_BUILDTIME_TABLE_SORT}" ]; then
> --
> 2.26.2
>
