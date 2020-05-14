Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCF31D40BE
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgENWUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgENWUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:20:32 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C31C061A0C;
        Thu, 14 May 2020 15:20:31 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f83so534618qke.13;
        Thu, 14 May 2020 15:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Btb+pUXqufPEo0v33O7AZL4ElyjUDGTi6VfzFSIsJsM=;
        b=U5xpniTN9ydrdfaExtS+SYHelYWAb95MIeKEuok4Bk3Jo09nz0eGgYrnzYBsdN2wnl
         RofaB7mXp1xbvkOZG6f5PuP92FfXY28SEUM2Vav9qP2TC8rvPsn43CpN9JzU3ZjUqFrq
         +8qNG8ZJWerUiouCh3MTTGcTwUzchxITkk1kZMFykGZHLUBqoepRrIyJvcZ9QHHZZ6kH
         7zDpMVOoMUfwVjqa1+kD8BpaFyTQzLb/s5Ramy0bTL1nx+8GIeumjA8f4cHkPy7OY98b
         lsicxfEDa/+KELPxUeDSvlhx2WyEPGhm8GKlVq4MfA/rDZ3iGYS6uo5hQmyBiKYSmo+o
         TDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Btb+pUXqufPEo0v33O7AZL4ElyjUDGTi6VfzFSIsJsM=;
        b=J/ykWTgWULyd1Hn9AcLgHKXF/nkkX1trNRyTrt7IFTAU3yag5TlKjNweAb1npTk78Y
         BQzTHF88vApUMlqwAgdbvYigRvyISz5bWZAQAd+k1Jr7uq2ykV+RXvGJdlmKqkPiSfYh
         QkdfuOau7rNeRIRXbmSdSWdRVnC+OPMUdllExTpk2reYuXh3qT4szOZ2ztD+4FrNxriU
         OX1RT6/XXqGPpSelEKwZsbKyR/fnDRt1gfUl07rqWgFf31tgfzz0Eq7hT5wysyqpo2ZB
         qzoM08cNnn9+zqlJJS5HW/jyrlt856Szl1DKJiWMgbaFYR/G5YgDlm9HXnyKzxyqiz7b
         68Ow==
X-Gm-Message-State: AOAM531jvZ+woJ/nESqABOB9WkbC5hT4REU2zdpsvihl9Gw3pWlWrpf+
        YPzHCpkELdDU4s7tfU9RG1Gvq8tnVC4ZoP1J0cHrHg/Z
X-Google-Smtp-Source: ABdhPJw2mJXYvtNgeUvbCrKnCVvfQVFa8lWVsSosTCHtIMyvlDfI7TlubzTR8LA93sy5NI7if9vnz/JfYf/ejExGvFE=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr599491qkg.437.1589494830915;
 Thu, 14 May 2020 15:20:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-4-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 15:20:19 -0700
Message-ID: <CAEf4BzY=GgQ0jaTg2BLfguZ+sPjT==qgoMFeB85utGWFj5qtPA@mail.gmail.com>
Subject: Re: [PATCH 3/9] bpf: Add bpfwl tool to construct bpf whitelists
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:30 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> This tool takes vmlinux object and whitelist directory on input
> and produces C source object with BPF whitelist data.
>
> The vmlinux object needs to have a BTF information compiled in.
>
> The whitelist directory is expected to contain files with helper
> names, where each file contains list of functions/probes that
> helper is allowed to be called from - whitelist.
>
> The bpfwl tool has following output:
>
>   $ bpfwl vmlinux dir
>   unsigned long d_path[] __attribute__((section(".BTF_whitelist_d_path"))) = \
>   { 24507, 24511, 24537, 24539, 24545, 24588, 24602, 24920 };

why long instead of int? btf_id is 4-byte one.

>
> Each array are sorted BTF ids of the functions provided in the
> helper file.
>
> Each array will be compiled into kernel and used during the helper
> check in verifier.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/bpfwl/Build    |  11 ++
>  tools/bpf/bpfwl/Makefile |  60 +++++++++
>  tools/bpf/bpfwl/bpfwl.c  | 285 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 356 insertions(+)
>  create mode 100644 tools/bpf/bpfwl/Build
>  create mode 100644 tools/bpf/bpfwl/Makefile
>  create mode 100644 tools/bpf/bpfwl/bpfwl.c

Sorry, I didn't want to nitpick on naming, honestly, but I think this
is actually harmful in the long run. bpfwl is incomprehensible name,
anyone reading link script would be like "what the hell is bpfwl?" Why
not bpf_build_whitelist or something with "whitelist" spelled out in
full?

>
> diff --git a/tools/bpf/bpfwl/Build b/tools/bpf/bpfwl/Build
> new file mode 100644
> index 000000000000..667e30d6ce79
> --- /dev/null
> +++ b/tools/bpf/bpfwl/Build
> @@ -0,0 +1,11 @@
> +bpfwl-y += bpfwl.o
> +bpfwl-y += rbtree.o
> +bpfwl-y += zalloc.o
> +

[...]

> +
> +struct func {
> +       char                    *name;
> +       unsigned long            id;

as mentioned above, btf_id is 4 byte

> +       struct rb_node           rb_node;
> +       struct list_head         list[];
> +};
> +

[...]

> +       btf = btf__parse_elf(vmlinux, NULL);
> +       err = libbpf_get_error(btf);
> +       if (err) {
> +               fprintf(stderr, "FAILED: load BTF from %s: %s",
> +                       vmlinux, strerror(err));
> +               return -1;
> +       }
> +
> +       nr = btf__get_nr_types(btf);
> +
> +       /* Iterate all the BTF types and resolve all the function IDs. */
> +       for (id = 0; id < nr; id++) {

It has to be `for (id = 1; id <= nr; id++)`. 0 is VOID type and not
included into nr_types. I know it's confusing, but.. life :)

> +               const struct btf_type *type;
> +               struct func *func;
> +               const char *str;
> +
> +               type = btf__type_by_id(btf, id);
> +               if (!type)
> +                       continue;
> +

[...]
