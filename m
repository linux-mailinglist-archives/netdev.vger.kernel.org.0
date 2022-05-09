Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2870520726
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiEIV6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiEIVzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:55:45 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B462CAA98;
        Mon,  9 May 2022 14:49:15 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r27so16783500iot.1;
        Mon, 09 May 2022 14:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fhp+F4xfYnb8fD7mYS48fVBfznRXTRAmEck5eOq6Vj4=;
        b=kwF3uZPpQP6cE69Wg+Cuk6xAb7uMcNTjugnQuuLlJP7H76lHYLKhAQcFW/CbIdWb/Q
         MAMgU2k2X+1l766zZLs0L990062Bzz5woKw+zrSe0kmUKLbH4Iu8nK+2dgS2eExWiU3m
         +LftxAVsPUPF98JYHsyM3od4E5YU0EzpBYZ0zJ999EzRl8bJsvgfK5FFDKBvV6NeNTKy
         KdiPbfr9lRftIqEzm4rkv8x79Wr9t/1owUEumszq7RvPBef1x62GzVwyztbfdQhGBvSh
         aAWJkr2kbUq9ElYb5/FHFl7wBNoEie1rhZ3W42ngPsNlGIYkEyJ9AkUVMTrBIjaqZ7I6
         skbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fhp+F4xfYnb8fD7mYS48fVBfznRXTRAmEck5eOq6Vj4=;
        b=zQs31oHoJkBY0wc4uL7GrXfJv5Mcn4R/bh7Ouh/e3SsCgKH93JaiwgIiadGMJl2pfa
         4Flgfo2eGi/tOKDJblkL3wq9LUPCOASww1AoVhEKkZBCfdeZpqOEh9W7gyIfU9LS96pC
         kKimdTnozywSt7+mdIl7v6l2JCUtTge5xz898efnUXCY3lX9T3QOh+A9Bk9S11eU3mfw
         pFh7L5ZVI/AzWMG6tsAAEF85quEjgzupKNbOFwYIp8WCrJ8uxfwNJHn/Sg+OYqX5DAf2
         Sl5K/0xMLgJ/cJ72KmeBJUP0FBrKTT4IFky5L64qwHsgL5ZpU5EUfCRzSs/jFizMhZ6H
         YVxw==
X-Gm-Message-State: AOAM531oDFeC5Uh4Udm6yx1idg4eTyQnE+nVYUEMtsSlWR5T2Zvy2DEA
        DlH/PD/QhSlImATjFJ16WmUhVeeTmyuE8Gn7M5A=
X-Google-Smtp-Source: ABdhPJyq5xGZnYmxwjyT3pi4tT+/AfimlEdcEmrm6paH0Q1FRW5zzXgWiI5LKWLRdy+NRG6ogZCYad8xIc06FBMsiWU=
X-Received: by 2002:a02:5d47:0:b0:32b:4387:51c8 with SMTP id
 w68-20020a025d47000000b0032b438751c8mr8369977jaa.103.1652132955122; Mon, 09
 May 2022 14:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-6-sdf@google.com>
In-Reply-To: <20220429211540.715151-6-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 14:49:04 -0700
Message-ID: <CAEf4BzbSW3Wgpt_RYaFSHiPEmiGVkqa0ZsA45hD6pOnBqCFfuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 05/10] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
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

On Fri, Apr 29, 2022 at 2:15 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> We have two options:
> 1. Treat all BPF_LSM_CGROUP as the same, regardless of attach_btf_id
> 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
>
> I'm doing (2) here and adding attach_btf_id as a new BPF_PROG_QUERY
> argument. The downside is that it requires iterating over all possible
> bpf_lsm_ hook points in the userspace which might take some time.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/cgroup.c            | 43 ++++++++++++++++++++++++----------
>  kernel/bpf/syscall.c           |  3 ++-
>  tools/include/uapi/linux/bpf.h |  1 +
>  tools/lib/bpf/bpf.c            | 42 ++++++++++++++++++++++++++-------
>  tools/lib/bpf/bpf.h            | 15 ++++++++++++
>  tools/lib/bpf/libbpf.map       |  1 +

please split kernel and libbpf changes into separate patches and mark
libbpf's with "libbpf: " prefix

>  7 files changed, 85 insertions(+), 21 deletions(-)
>

[...]

> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index a9d292c106c2..f62823451b99 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -946,28 +946,54 @@ int bpf_iter_create(int link_fd)
>         return libbpf_err_errno(fd);
>  }
>
> -int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
> -                  __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
> +int bpf_prog_query2(int target_fd,

this would have to be named bpf_prog_query_opts()

> +                   enum bpf_attach_type type,
> +                   struct bpf_prog_query_opts *opts)
>  {
>         union bpf_attr attr;
>         int ret;
>
>         memset(&attr, 0, sizeof(attr));
> +

[...]

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b5bc84039407..5e5bb3e437cc 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -450,4 +450,5 @@ LIBBPF_0.8.0 {
>                 bpf_program__attach_usdt;
>                 libbpf_register_prog_handler;
>                 libbpf_unregister_prog_handler;
> +               bpf_prog_query2;

this list is alphabetically ordered

>  } LIBBPF_0.7.0;
> --
> 2.36.0.464.gb9c8b46e94-goog
>
