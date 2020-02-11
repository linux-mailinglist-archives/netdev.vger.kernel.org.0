Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2EB159927
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgBKSvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:51:39 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46913 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgBKSvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 13:51:39 -0500
Received: by mail-qk1-f193.google.com with SMTP id g195so11121728qke.13;
        Tue, 11 Feb 2020 10:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l/+E2eVsRW0Yo4vFctboUwHNG9669KLGFE00pneG3vM=;
        b=rLK6G0qJiN02pSXjNvkjM2OrYuVgwHM6VnYInbus+DfuYXtUgPPe2r14DaYgCcWNyH
         toFbmkc8EXMHctCTtcq7xVjnD1yjowCnLpnWbs32RhvKeHOQp6AR5ZdCNSz9EP7zS5yD
         0q2+EKbDL1IyKMDPzytneJVlUxA7BmRzb+zhFsp9Moi7Z0/Dyx3PItt+TW86wYvBljrm
         siKznHQlPiZLo5MjzT1XOdmYGQJ1VcjH3kqz1q9qWGpsd2T1NlS18BbVsPIUokPEzPNT
         9YKhtrDaj5q4xexZX551ahMRvcqEwTlRGX3Oj476nLWX0YOIMhaE8VXc2G9PYNRyo7ly
         2ueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l/+E2eVsRW0Yo4vFctboUwHNG9669KLGFE00pneG3vM=;
        b=PPCQWHHQ7dlTOrX7KltQrZhGjr8bY8uffCBtFQl1vrfInRsMbbY7gqUxltGs+shV6Z
         JijhNovSMvmqGi79xCWHlFSRCWl8uKr8gmqER1HIcJYrDCXF86YyfB3E+R71Pyvs13GJ
         5NPuxM0sBBOw3QkafDkJ1vyObhqJm0KBwGLybqdwV1tb8cbtuOy8NLo6VhEbSUBHLZNH
         6EF3fXsQVAjIouVtcaH0hN3mtUC0h0mOllyLUJTNPN4qe//f761txm+87zc7A9SK81p/
         LOc2GAOC2i39KSNNQMjuRQpLjjlH0T0+cTAJvnnVYkAzRIF8xjM0WcukQHA1Wh4TO/ii
         o6/w==
X-Gm-Message-State: APjAAAW7XOoTc130Hu8bjErtW2wwiCB3U+vR9XsucNSWBXonytX8RzTM
        JVkBf7yOT5h1b6ebKLaGn/mshzO7BxWjw9hmmgA=
X-Google-Smtp-Source: APXvYqzKmL1sYrrdHMxxtTh9JVJ+1phmHcTzJ9y1HZBKGYmp8+U9/aeOn35Pw5FKRg4YxyxEQyKbVhtRSz53Ivd8oes=
X-Received: by 2002:a37:a685:: with SMTP id p127mr7868061qke.449.1581447098036;
 Tue, 11 Feb 2020 10:51:38 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org> <20200208154209.1797988-13-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-13-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Feb 2020 10:51:27 -0800
Message-ID: <CAEf4BzZFBYVAs5-LowuMov86cbNFdXABkcA=XZAC2JJWg52HKg@mail.gmail.com>
Subject: Re: [PATCH 12/14] bpf: Add trampolines to kallsyms
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding trampolines to kallsyms. It's displayed as
>   bpf_trampoline_<ID> [bpf]
>
> where ID is the BTF id of the trampoline function.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h     |  2 ++
>  kernel/bpf/trampoline.c | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 7a4626c8e747..b91bac10d3ea 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -502,6 +502,7 @@ struct bpf_trampoline {
>         /* Executable image of trampoline */
>         void *image;
>         u64 selector;
> +       struct bpf_ksym ksym;
>  };
>
>  #define BPF_DISPATCHER_MAX 48 /* Fits in 2048B */
> @@ -573,6 +574,7 @@ struct bpf_image {
>  #define BPF_IMAGE_SIZE (PAGE_SIZE - sizeof(struct bpf_image))
>  bool is_bpf_image_address(unsigned long address);
>  void *bpf_image_alloc(void);
> +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
>  /* Called only from code, so there's no need for stubs. */
>  void bpf_ksym_add(struct bpf_ksym *ksym);
>  void bpf_ksym_del(struct bpf_ksym *ksym);
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 6b264a92064b..1ee29907cbe5 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -96,6 +96,15 @@ bool is_bpf_image_address(unsigned long addr)
>         return ret;
>  }
>
> +void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym)
> +{
> +       struct bpf_image *image = container_of(data, struct bpf_image, data);
> +
> +       ksym->start = (unsigned long) image;
> +       ksym->end = ksym->start + PAGE_SIZE;

this seems wrong, use BPF_IMAGE_SIZE instead of PAGE_SIZE?

> +       bpf_ksym_add(ksym);
> +}
> +
>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>  {
>         struct bpf_trampoline *tr;
> @@ -131,6 +140,7 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>         for (i = 0; i < BPF_TRAMP_MAX; i++)
>                 INIT_HLIST_HEAD(&tr->progs_hlist[i]);
>         tr->image = image;
> +       INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
>  out:
>         mutex_unlock(&trampoline_mutex);
>         return tr;
> @@ -267,6 +277,15 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
>         }
>  }
>
> +static void bpf_trampoline_kallsyms_add(struct bpf_trampoline *tr)
> +{
> +       struct bpf_ksym *ksym = &tr->ksym;
> +
> +       snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu",
> +                tr->key & ((u64) (1LU << 32) - 1));

why the 32-bit truncation? also, wouldn't it be more trivial as (u32)tr->key?

> +       bpf_image_ksym_add(tr->image, &tr->ksym);
> +}
> +
>  int bpf_trampoline_link_prog(struct bpf_prog *prog)
>  {
>         enum bpf_tramp_prog_type kind;
> @@ -311,6 +330,8 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog)
>         if (err) {
>                 hlist_del(&prog->aux->tramp_hlist);
>                 tr->progs_cnt[kind]--;
> +       } else if (cnt == 0) {
> +               bpf_trampoline_kallsyms_add(tr);

You didn't handle BPF_TRAMP_REPLACE case above.

Also this if (err) { ... } else if (cnt == 0) { } pattern is a bit
convoluted. How about:

if (err) {
   ... whatever ...
   goto out;
}
if (cnt == 0) { ... }

>         }
>  out:
>         mutex_unlock(&tr->mutex);
> @@ -336,6 +357,8 @@ int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
>         }
>         hlist_del(&prog->aux->tramp_hlist);
>         tr->progs_cnt[kind]--;
> +       if (!(tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT]))
> +               bpf_ksym_del(&tr->ksym);

same, BPF_TRAMP_REPLACE case. I'd also introduce cnt for consistency
with bpf_trampoline_link_prog?

>         err = bpf_trampoline_update(prog->aux->trampoline);
>  out:
>         mutex_unlock(&tr->mutex);
> --
> 2.24.1
>
