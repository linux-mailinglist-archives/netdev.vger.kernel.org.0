Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B691BD492
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgD2GZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgD2GZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:25:24 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324B6C03C1AD;
        Tue, 28 Apr 2020 23:25:23 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g74so889660qke.13;
        Tue, 28 Apr 2020 23:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JYbUzf4qoz4ojFynP8ISd1T884WxDLWnM1xSRmOXCCw=;
        b=XBawqysPsV4+lEnTXNzc58vHvqcxlT+b2PKG+7k2TpPRdNkjxY8wag8u5H+7xuThGQ
         83GUEPkdqRtWcTc+I7LDofO1SoaXNQvK9z9I15BTqEwZT56N568dZ9pYBvcZrVfd+D5F
         CjRsZ/oP2gbwV0w2ZdXKe7pYd+Qbl1sKaJeefZsEgnzOu5aqlhPro7uePtoYkqNOZX+d
         zG5t3w8DCsm4EwDhK0cwrysgqR7y37+5lneqRU283AxoDuH0Rw3er46bA9Ryb4z1L2Mu
         EK3Tg12rN02hVrqnCZ2xk4hwi4TTCS9iNg4ZeLpOYKSlDCFOAAfAgpvcfSkO7Cwmo/3I
         A3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JYbUzf4qoz4ojFynP8ISd1T884WxDLWnM1xSRmOXCCw=;
        b=e+1mfepHYPkVG/tKFlvLQtghcgGvgEVIuA5crmls2rV3j2FP7Aa+ATOFdvM1ytyamD
         kBan4mz1+kyT9b+aBj5ETkQCfON+o8KxHZHl4NWGOOxZCw6rjPvvs0jr5NtP2vV49+Bg
         ul4PNUHDmV3+RItDBcW8WXifTyUwfsTuqhbdTRWLmdUZnM3o3/Ji/BFai4RwYNldfrj4
         eaLLUPL11WvS00VFk7hRattEOFWzeUFzWpTnxxoG6BJpAYOU+z4nF2SBo8FG8mWlvEH/
         b0Nqm5V1+P/9Bid8t3SPzCh88mm2DGxqNvG62jgcZVGudLoT4slXKnhpM45D643L/UPb
         aLDQ==
X-Gm-Message-State: AGi0Pua3sIs8a1k16XfH/nArYesC7qBhXQc72q9k7A4tV99DrVQhWNFE
        SJsPetZjJ706HObnkfgLJlY0NPgV4I+8G8G/16U=
X-Google-Smtp-Source: APiQypIVlDLPpqmF8iNK0WlkMotLzfduvkrBsxwpZDkN/hxPFIFwt36EMNgTdG2RrYR3H+YBMgpE9i9/wDztiOk5SQo=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr33415917qkm.449.1588141522042;
 Tue, 28 Apr 2020 23:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201240.2994985-1-yhs@fb.com>
In-Reply-To: <20200427201240.2994985-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 23:25:11 -0700
Message-ID: <CAEf4BzbFyz-LgDp439HoD172AnfLi5zybk5=UtqsPYTdH9yUCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 05/19] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 1:13 PM Yonghong Song <yhs@fb.com> wrote:
>
> Given a bpf program, the step to create an anonymous bpf iterator is:
>   - create a bpf_iter_link, which combines bpf program and the target.
>     In the future, there could be more information recorded in the link.
>     A link_fd will be returned to the user space.
>   - create an anonymous bpf iterator with the given link_fd.
>
> The anonymous bpf iterator (and its underlying bpf_link) will be
> used to create file based bpf iterator as well.
>
> The benefit to use of bpf_iter_link:
>   - for file based bpf iterator, bpf_iter_link provides a standard
>     way to replace underlying bpf programs.
>   - for both anonymous and free based iterators, bpf link query
>     capability can be leveraged.
>
> The patch added support of tracing/iter programs for  BPF_LINK_CREATE.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/bpf_iter.c | 54 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c  | 15 ++++++++++++
>  3 files changed, 71 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 4ac8d61f7c3e..60ecb73d8f6d 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1034,6 +1034,7 @@ extern const struct file_operations bpf_prog_fops;
>  extern const struct bpf_prog_ops bpf_offload_prog_ops;
>  extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
>  extern const struct bpf_verifier_ops xdp_analyzer_ops;
> +extern const struct bpf_link_ops bpf_iter_link_lops;

show_fdinfo implementation for bpf_link has changed, so thankfully
this won't be necessary after you rebase on latest master :)

>
>  struct bpf_prog *bpf_prog_get(u32 ufd);
>  struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
> @@ -1129,6 +1130,7 @@ int bpf_iter_reg_target(struct bpf_iter_reg *reg_info);
>  struct bpf_prog *bpf_iter_get_prog(struct seq_file *seq, u32 priv_data_size,
>                                    u64 *session_id, u64 *seq_num, bool is_last);
>  int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>
>  int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>  int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 284c95587803..9532e7bcb8e1 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -14,6 +14,11 @@ struct bpf_iter_target_info {
>         u32 target_feature;
>  };
>
> +struct bpf_iter_link {
> +       struct bpf_link link;
> +       struct bpf_iter_target_info *tinfo;
> +};
> +
>  static struct list_head targets;
>  static struct mutex targets_mutex;
>  static bool bpf_iter_inited = false;
> @@ -67,3 +72,52 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx)
>
>         return ret;
>  }
> +
> +static void bpf_iter_link_release(struct bpf_link *link)
> +{
> +}
> +
> +static void bpf_iter_link_dealloc(struct bpf_link *link)
> +{

Here you need to kfree() link struct. See bpf_raw_tp_link_dealloc() for example.


> +}
> +
> +const struct bpf_link_ops bpf_iter_link_lops = {
> +       .release = bpf_iter_link_release,
> +       .dealloc = bpf_iter_link_dealloc,
> +};
> +

[...]
