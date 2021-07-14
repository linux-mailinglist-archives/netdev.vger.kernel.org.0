Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533263C94BD
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 02:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbhGOAC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 20:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhGOAC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 20:02:57 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEABC06175F;
        Wed, 14 Jul 2021 17:00:05 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id k184so6020934ybf.12;
        Wed, 14 Jul 2021 17:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5B+woHff3gH1nbVQlGQQlOXxwWDup59Bz7W7LVwi/qw=;
        b=E/lzAAXTVDU2qn5bPj3WZJ5Nw+1fVLU3iFblqqX0mQHmJ3IqQpznTq8in5ypmA14Y/
         WbpPlH9EHvzfenK5u4bTItYJFeqroKMFqVL9YWpGlRquw0uIsC8NhT871z+lx4fFIukH
         0TZGdQQ+QnExkjMPUrOmBq7wMuLQU2L/n2/XAyeyj2ehPVTcT+v9/VfZvOmYNTYus3Yc
         JGfW/ogAB9it53pxWMPeqGZMp21A4C2F69TbXob1QWRBWrSG10DVaUEQ1dZlpi3vHItG
         WVFT8A0ZaMaj4ErXsRva4WuQuRvI/FDdhobhsymtNOML5BFKqqnQ34WPfNTWsSHQrm/z
         EsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5B+woHff3gH1nbVQlGQQlOXxwWDup59Bz7W7LVwi/qw=;
        b=pqizualXx5BToNflgFSMG5CF+SpBlVutggHE1QVkE/l2gJ1rG5tGatLjj24XhmgNCh
         kf7/3oC/9bpjC4mFM+2dc3EibuxBRt9rUZvxoLdtCvtPbuNAvJRBJDWi8EmdURNFmFGs
         gzpiKb2dxkX49bysBXurHyxZP7/zpbFYUpMaZBC34c60XXjW3yrX+L8WEs6f9stIvslN
         RsR3DMNmXzcSSR3BPmtjrO3kTluRx0p0X7pQOWlo4AS48ssijmh8ohrSr5zOxCwO3+D7
         HuaDO/8aFQgRLI4wqPxriMSw2LGZY1q3qZIzFC/hY7f0o5dF/KO1yqyv9Xmah6nGDxrP
         3vFg==
X-Gm-Message-State: AOAM532JvZRXuI+5cqS0j1AKDAa1/xMDajkoTL43PbDBMm+Cfhd8RLpf
        k2dgD2D/NVBZPtRhE9+aUWL/keSo1Mq1fMLpChk=
X-Google-Smtp-Source: ABdhPJzzpZTiV+NdEnxAaCxo8sRdhGmUNNOSSYD65zheyio/OkRAqrRY/2gqHWKxD05Fau4ynq2J0l2RG58xa+EPFXs=
X-Received: by 2002:a25:b203:: with SMTP id i3mr783727ybj.260.1626307204941;
 Wed, 14 Jul 2021 17:00:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210714010519.37922-1-alexei.starovoitov@gmail.com> <20210714010519.37922-4-alexei.starovoitov@gmail.com>
In-Reply-To: <20210714010519.37922-4-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Jul 2021 16:59:53 -0700
Message-ID: <CAEf4BzbJb3q0=LwHs_JXXB2a7wsY=rCF7E+nxsM2SgcC6KK8jA@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 03/11] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 6:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> in hash/array/lru maps as a regular field and helpers to operate on it:
>
> // Initialize the timer.
> // First 4 bits of 'flags' specify clockid.
> // Only CLOCK_MONOTONIC, CLOCK_REALTIME, CLOCK_BOOTTIME are allowed.
> long bpf_timer_init(struct bpf_timer *timer, struct bpf_map *map, int flags);
>
> // Configure the timer to call 'callback_fn' static function.
> long bpf_timer_set_callback(struct bpf_timer *timer, void *callback_fn);
>
> // Arm the timer to expire 'nsec' nanoseconds from the current time.
> long bpf_timer_start(struct bpf_timer *timer, u64 nsec, u64 flags);
>
> // Cancel the timer and wait for callback_fn to finish if it was running.
> long bpf_timer_cancel(struct bpf_timer *timer);
>
> Here is how BPF program might look like:
> struct map_elem {
>     int counter;
>     struct bpf_timer timer;
> };
>
> struct {
>     __uint(type, BPF_MAP_TYPE_HASH);
>     __uint(max_entries, 1000);
>     __type(key, int);
>     __type(value, struct map_elem);
> } hmap SEC(".maps");
>
> static int timer_cb(void *map, int *key, struct map_elem *val);
> /* val points to particular map element that contains bpf_timer. */
>
> SEC("fentry/bpf_fentry_test1")
> int BPF_PROG(test1, int a)
> {
>     struct map_elem *val;
>     int key = 0;
>
>     val = bpf_map_lookup_elem(&hmap, &key);
>     if (val) {
>         bpf_timer_init(&val->timer, &hmap, CLOCK_REALTIME);
>         bpf_timer_set_callback(&val->timer, timer_cb);
>         bpf_timer_start(&val->timer, 1000 /* call timer_cb2 in 1 usec */, 0);
>     }
> }
>
> This patch adds helper implementations that rely on hrtimers
> to call bpf functions as timers expire.
> The following patches add necessary safety checks.
>
> Only programs with CAP_BPF are allowed to use bpf_timer.
>
> The amount of timers used by the program is constrained by
> the memcg recorded at map creation time.
>
> The bpf_timer_init() helper needs explicit 'map' argument because inner maps
> are dynamic and not known at load time. While the bpf_timer_set_callback() is
> receiving hidden 'aux->prog' argument supplied by the verifier.
>
> The prog pointer is needed to do refcnting of bpf program to make sure that
> program doesn't get freed while the timer is armed. This approach relies on
> "user refcnt" scheme used in prog_array that stores bpf programs for
> bpf_tail_call. The bpf_timer_set_callback() will increment the prog refcnt which is
> paired with bpf_timer_cancel() that will drop the prog refcnt. The
> ops->map_release_uref is responsible for cancelling the timers and dropping
> prog refcnt when user space reference to a map reaches zero.
> This uref approach is done to make sure that Ctrl-C of user space process will
> not leave timers running forever unless the user space explicitly pinned a map
> that contained timers in bpffs.
>
> bpf_timer_init() and bpf_timer_set_callback() will return -EPERM if map doesn't
> have user references (is not held by open file descriptor from user space and
> not pinned in bpffs).
>
> The bpf_map_delete_elem() and bpf_map_update_elem() operations cancel
> and free the timer if given map element had it allocated.
> "bpftool map update" command can be used to cancel timers.
>
> The 'struct bpf_timer' is explicitly __attribute__((aligned(8))) because
> '__u64 :64' has 1 byte alignment of 8 byte padding.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h            |   3 +
>  include/uapi/linux/bpf.h       |  73 ++++++++
>  kernel/bpf/helpers.c           | 325 +++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c          | 109 +++++++++++
>  kernel/trace/bpf_trace.c       |   2 +-
>  scripts/bpf_doc.py             |   2 +
>  tools/include/uapi/linux/bpf.h |  73 ++++++++
>  7 files changed, 586 insertions(+), 1 deletion(-)
>

[...]

> +       if (!atomic64_read(&(map->usercnt))) {
> +               /* maps with timers must be either held by user space
> +                * or pinned in bpffs.
> +                */
> +               ret = -EPERM;
> +               goto out;
> +       }
> +       /* allocate hrtimer via map_kmalloc to use memcg accounting */
> +       t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);

I wonder if it would make sense to use map->numa_node here to keep map
value and timer data in the same NUMA node?

> +       if (!t) {
> +               ret = -ENOMEM;
> +               goto out;
> +       }

[...]

> +
> +/* This function is called by map_delete/update_elem for individual element.
> + * By ops->map_release_uref when the user space reference to a map reaches zero
> + * and by ops->map_free when the kernel reference reaches zero.

is ops->map_free part still valid?

> + */
> +void bpf_timer_cancel_and_free(void *val)
> +{
> +       struct bpf_timer_kern *timer = val;
> +       struct bpf_hrtimer *t;
> +

[...]
