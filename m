Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD92F531F2D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiEWXWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiEWXWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:22:50 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969046C56A;
        Mon, 23 May 2022 16:22:49 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id j7so4541476vsp.12;
        Mon, 23 May 2022 16:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T74LvEQCUkDpmgdMl6Xd1TSwKVQRkgh3mHfZgMoviWQ=;
        b=oTtJaPCIyDyNjcXChkbnkL2NgutUs1GnqLnWuVTfx5wvuGcpCE5uulh8amtlL02Lru
         x0oPP3csGrdAiWMg1V6EZs+7RE0GQAhQ+AqwohszvXdk5qh9uydLhMNaAASarcvhngcv
         lgh/e83uHg51RQNHuJoBBNF2acUQ3JAVe7psZwZoG7Cex9GM9gW57H1Cy3NFCdPySOly
         mwwsOEVvOK7ZgTqsWnvHnmjucOODjHRMyKFdTZyNJIhhx0GgNxOXvnLKMDsrBh9mf5VB
         w1LE39ri9KFv+dGFamBe/sfJrlv97ISBW33nBRzvygdmHHHLgapEvVXyMN4Jx+XgsKxS
         tEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T74LvEQCUkDpmgdMl6Xd1TSwKVQRkgh3mHfZgMoviWQ=;
        b=trwe4pBr0op86eZ9vBWLzVeX9+3k7W7syVVN2IgL1lAHeJZA60rbtplwMAFtd+HDpU
         OS7J+8VwHgSL958ybouuc/BCZIYP9K4NDG3qnd3NdpyxGfs/4uvTJ74SjJxxiP7OkPEW
         +qkS789CELsvRjst1xhPOTiGfDB109PcYzZqdlzyTvY3TFEMVl71YxkZVq76nEKI1fu9
         MRZ0E9qEz6Dqv8pW8C3gXr0FugKG8n5BGgINKCnsxqSdn3TPZT40jxDDXBbzouPt6+72
         ql/HwTtcERruwu0tUM9kk4RsmX95f/U7RTAcScVZqpnqqa+SyyB1oyGQIbjaKQr5HGcj
         UGyw==
X-Gm-Message-State: AOAM532CoqJrMeuNUig8of6jJW4Q5XCQiC5zGGgGzWECpT9rrGv2+XQt
        hjP6FYPhceazL8oJN10X6Msedin3qgjryUdwahn4eYHP
X-Google-Smtp-Source: ABdhPJwRtmzoXx62/vMWqMo463GFm4hrLIl8+Xw4QnfkFNZeXiX+JCh/5BnrWBL9PmXNq4acrG5pR/zBYUMcTX/OKd8=
X-Received: by 2002:a67:e0d5:0:b0:337:b2f4:afe0 with SMTP id
 m21-20020a67e0d5000000b00337b2f4afe0mr3042998vsl.11.1653348168754; Mon, 23
 May 2022 16:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-8-sdf@google.com>
In-Reply-To: <20220518225531.558008-8-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 16:22:37 -0700
Message-ID: <CAEf4BzaYx9EdabuxjLsN4HKTcq+EfwRzpAYdY-D+74YOTpr4Yg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 07/11] libbpf: implement bpf_prog_query_opts
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

On Wed, May 18, 2022 at 3:55 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Implement bpf_prog_query_opts as a more expendable version of
> bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
> well:
>
> * prog_attach_flags is a per-program attach_type; relevant only for
>   lsm cgroup program which might have different attach_flags
>   per attach_btf_id
> * attach_btf_func_id is a new field expose for prog_query which
>   specifies real btf function id for lsm cgroup attachments
>

just thoughts aloud... Shouldn't bpf_prog_query() also return link_id
if the attachment was done with LINK_CREATE? And then attach flags
could actually be fetched through corresponding struct bpf_link_info.
That is, bpf_prog_query() returns a list of link_ids, and whatever
link-specific information can be fetched by querying individual links.
Seems more logical (and useful overall) to extend struct bpf_link_info
(you can get it more generically from bpftool, by querying fdinfo,
etc).

> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/include/uapi/linux/bpf.h |  5 ++++
>  tools/lib/bpf/bpf.c            | 42 +++++++++++++++++++++++++++-------
>  tools/lib/bpf/bpf.h            | 15 ++++++++++++
>  tools/lib/bpf/libbpf.map       |  1 +
>  4 files changed, 55 insertions(+), 8 deletions(-)
>

[...]

>         ret = sys_bpf(BPF_PROG_QUERY, &attr, sizeof(attr));
>
> -       if (attach_flags)
> -               *attach_flags = attr.query.attach_flags;
> -       *prog_cnt = attr.query.prog_cnt;
> +       if (OPTS_HAS(opts, prog_cnt))
> +               opts->prog_cnt = attr.query.prog_cnt;

just use OPTS_SET() instead of OPTS_HAS check

> +       if (OPTS_HAS(opts, attach_flags))
> +               opts->attach_flags = attr.query.attach_flags;
>
>         return libbpf_err_errno(ret);
>  }
>

[...]

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 6b36f46ab5d8..24f7a5147bf2 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -452,6 +452,7 @@ LIBBPF_0.8.0 {
>                 bpf_map_delete_elem_flags;
>                 bpf_object__destroy_subskeleton;
>                 bpf_object__open_subskeleton;
> +               bpf_prog_query_opts;

please put it into LIBBPF_1.0.0 section, 0.8 is closed now


>                 bpf_program__attach_kprobe_multi_opts;
>                 bpf_program__attach_trace_opts;
>                 bpf_program__attach_usdt;
> --
> 2.36.1.124.g0e6072fb45-goog
>
