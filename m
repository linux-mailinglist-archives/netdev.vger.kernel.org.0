Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217703D310C
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhGWAJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 20:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhGWAJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 20:09:29 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C2C061575;
        Thu, 22 Jul 2021 17:50:02 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id c204so7367021ybb.4;
        Thu, 22 Jul 2021 17:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D6Lk73a1fLHn8Oat3GUjMc5GwNcqezOdY56YwxP+Jqk=;
        b=CiYIUd6UeYxEXEgWOyy8GmNPJk7Z4/2FegZ6V/9UUZ/DYR8fseywlgm1YJl3lS7uQH
         Dngb9EMfBIgw5rElIDWO5/ImPFS4Rw1RnHTpMU1Vi4oAzuIpBI4hY4NmgfClXC71ZUtA
         GCD25YWyRhXMqikSk+hN7MQR7W6vcGIkHypFo+zswUjPcijwRCgjJtmYtzAeMT3nIZWH
         C7yX71ytCw+vrq3R7ZsB3wmFNREchDINlG1STKBnpaUWkXF4kKMndGcH1DIwtKhhUGSY
         ul6V3iqVnLyPkulcN/oQvZww57U9odOE1K50SI4JVYVoSPaZp3ALDyG4ssNrDqIMEvuW
         rrtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D6Lk73a1fLHn8Oat3GUjMc5GwNcqezOdY56YwxP+Jqk=;
        b=QZDVrvsI6bAU0S59MCenI4Ut7CagnFpU37a9W6ccXqtnIYf32lCZgf1eM2fjzyNBN0
         KcruAJqEDQos6vcNoB4e2St5ppYUuprAzVvympjVW94pRWz312V1XXVvWN04y/0+Nx7F
         5FlGWlO+U+imoKHCJ3Iv+Nyii3yq8EprNLkC0SqJ5diXzkmfITadkbj+tHabX5u+ySI6
         AmnQ5WdisicgTlMQ9UHrIw4UoIu+Ytf6Gkf3vmxMhbJQ9uLb7OTuqwStEoFNZ8GfnwJN
         0HHRLv4o7XfFW192ebbSoxCK8G7VTxcLd3HGMzDqAFqeDljqkTfaSrhoYRvtS/NHLIjp
         xZ5A==
X-Gm-Message-State: AOAM531gJ1MvlgIYKO+gCK0gab4NcPR7+G5JdIHU7LVlTmxzPPpdCfRF
        Ebij2R1gAgAaE0XEfExDFJTR1ecA4WvGkLrcAIc=
X-Google-Smtp-Source: ABdhPJzfWkNYSr4SoMZIeBH4AbFaUcp52bpnupOgIn5ezSLaggiE15VzB8biHnsnf9AGZeyj9VOjggZ/2tO9XhJGz+w=
X-Received: by 2002:a25:d349:: with SMTP id e70mr3108765ybf.510.1627001402047;
 Thu, 22 Jul 2021 17:50:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <20210721153808.6902-5-quentin@isovalent.com>
In-Reply-To: <20210721153808.6902-5-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 17:49:51 -0700
Message-ID: <CAEf4BzZ4ch-B22_VpS3HkS_wdOu4zTj8fYuX6ks_eicqgwg36g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/5] libbpf: add split BTF support for btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Add a new API function btf__load_from_kernel_by_id_split(), which takes
> a pointer to a base BTF object in order to support split BTF objects
> when retrieving BTF information from the kernel.
>
> Reference: https://github.com/libbpf/libbpf/issues/314
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  tools/lib/bpf/btf.c      | 9 +++++++--
>  tools/lib/bpf/btf.h      | 2 ++
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 10 insertions(+), 2 deletions(-)
>

[...]

> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 3db9446bc133..c9407d57d096 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -69,6 +69,8 @@ LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
>  LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
>  LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
>  LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
> +LIBBPF_API struct btf *btf__load_from_kernel_by_id_split(__u32 id,
> +                                                        struct btf *base_btf);

nit: please keep it on a single line, it's not that long

>  LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
>                                     __u32 expected_key_size,
>                                     __u32 expected_value_size,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index ca8cc7a7faad..eecf77227aeb 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -374,6 +374,7 @@ LIBBPF_0.5.0 {
>                 bpf_map_lookup_and_delete_elem_flags;
>                 bpf_object__gen_loader;
>                 btf__load_from_kernel_by_id;
> +               btf__load_from_kernel_by_id_split;
>                 btf__load_into_kernel;
>                 btf_dump__dump_type_data;
>                 libbpf_set_strict_mode;
> --
> 2.30.2
>
