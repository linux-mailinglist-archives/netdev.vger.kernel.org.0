Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C8F4380E2
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 02:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhJWAQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJWAQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:16:18 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBDEC061764;
        Fri, 22 Oct 2021 17:13:59 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v7so10683845ybq.0;
        Fri, 22 Oct 2021 17:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RVC/3H4XWoFsWku2XRUprMXaLMrvDr0CYPvZlI8J200=;
        b=dxawzenDsCVVCg2MGVWBJ2zoY7v9NxiwyudtQDvlB921wnO//5SlDRLeZ7rxORsGTm
         3edbNkWBPeybLEcRkc0Jrv9VhtWAiwT0w4FuMS/yUddcTsjBaZfzRhCL8+MOSaoFcM9F
         Y+T0UcQPDweOrDhtVZGkjcDCtxiwoMGiB/pdjQSWAeBJre2vOMqzJ/KJNJlzc178JsX4
         syTguG3f2XfS4hcbmQcvIqF7pizCGNM8gM3ZI1Z2Q9Zc5ntK0y4Le1eJRx0Mw3g6tWUJ
         +k3IGVNxo+85yFTm/cbyb+kq+iJnuYX/7nhN/NYDmCwpseOBbiqqRh/CGsBZ+m9Q4rNa
         udAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVC/3H4XWoFsWku2XRUprMXaLMrvDr0CYPvZlI8J200=;
        b=6qnJ2y7PG1pzrw3phpLnoG9PbYBE05Xym3i0bNg1qcdA4LsEvxHEGcHighjZWGLXHc
         CpemXJ+lm+FHC07VzycUXN+ghXwqvjsvu5UpzKpd3OrnV4nxmX/tE58nOKFCKJYCnCu0
         N7GKoRCUaZiu97KI1oqYXll9nY9kUDeNDFcF2gV5aQ6Y9BNtHkZi9XCMSqGW3j9cGRyP
         oavIjgAVWqwaOHqjeMpOo05A/w/aR8tcExV/HZG2pMXMtYtNhO3zQ9nLWN0iRl7rYzy1
         yI3cZ1svuNQimMTGw4jrTHuQQMyqsgs4KmMSA+2pYlXzh+PZmXLx1aWAox7aXCf9vOG1
         ySQQ==
X-Gm-Message-State: AOAM531DVD5EFCFRpsTqHXQ287kWkO2mtBSCGwDeJJ4FCjUesn6WhIWE
        3PrDWnLIUwegyF5VCagwIJv8XxbOLVReu2jTEWY=
X-Google-Smtp-Source: ABdhPJzMo/B5icVddrSHgsfKhLLPPiFR7Jy/f4mOZmhdDRjX9eRkUtUs+1z2b1z++PVfJ5PuK5OgEsOr5rtwEryLhM8=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr2875817ybj.433.1634948038982;
 Fri, 22 Oct 2021 17:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20211022171647.27885-1-quentin@isovalent.com> <20211022171647.27885-3-quentin@isovalent.com>
In-Reply-To: <20211022171647.27885-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 Oct 2021 17:13:48 -0700
Message-ID: <CAEf4BzYouGby=iKWb18E7XH9RDg+vNt=8DuUv9AAEKgM74b4sA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpftool: Do not expose and init hash maps
 for pinned path in main.c
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:16 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> BPF programs, maps, and links, can all be listed with their pinned paths
> by bpftool, when the "-f" option is provided. To do so, bpftool builds
> hash maps containing all pinned paths for each kind of objects.
>
> These three hash maps are always initialised in main.c, and exposed
> through main.h. There appear to be no particular reason to do so: we can
> just as well make them static to the files that need them (prog.c,
> map.c, and link.c respectively), and initialise them only when we want
> to show objects and the "-f" switch is provided.
>
> This may prevent unnecessary memory allocations if the implementation of
> the hash maps was to change in the future.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/link.c |  9 ++++++++-
>  tools/bpf/bpftool/main.c | 12 ------------
>  tools/bpf/bpftool/main.h |  3 ---
>  tools/bpf/bpftool/map.c  |  9 ++++++++-
>  tools/bpf/bpftool/prog.c |  9 ++++++++-
>  5 files changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> index 8cc3e36f8cc6..ebf29be747b3 100644
> --- a/tools/bpf/bpftool/link.c
> +++ b/tools/bpf/bpftool/link.c
> @@ -20,6 +20,8 @@ static const char * const link_type_name[] = {
>         [BPF_LINK_TYPE_NETNS]                   = "netns",
>  };
>
> +static struct pinned_obj_table link_table;
> +
>  static int link_parse_fd(int *argc, char ***argv)
>  {
>         int fd;
> @@ -302,8 +304,10 @@ static int do_show(int argc, char **argv)
>         __u32 id = 0;
>         int err, fd;
>
> -       if (show_pinned)
> +       if (show_pinned) {
> +               hash_init(link_table.table);
>                 build_pinned_obj_table(&link_table, BPF_OBJ_LINK);
> +       }
>         build_obj_refs_table(&refs_table, BPF_OBJ_LINK);
>
>         if (argc == 2) {
> @@ -384,6 +388,9 @@ static int do_detach(int argc, char **argv)
>         if (json_output)
>                 jsonw_null(json_wtr);
>
> +       if (show_pinned)
> +               delete_pinned_obj_table(&link_table);

Shouldn't this be in do_show rather than do_detach?

> +
>         return 0;
>  }
>

[...]
