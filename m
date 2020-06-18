Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C8F1FFE33
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgFRWdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgFRWdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:33:43 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F03C06174E;
        Thu, 18 Jun 2020 15:33:43 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id w1so7238894qkw.5;
        Thu, 18 Jun 2020 15:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KBHYsW5yW1CAVvBFDgy/TGfxwLfAurjw5+HPPsQ8l00=;
        b=GuvA39fiCMFlznSXXw9UFC8pVYn1ImBvDMaASeEWqJU5D8ZNCYt7WfT0BSMzmj5ICy
         9H7+YhjqBBjTLZvAQRR/pTQ8alt3+a3row7J3+GG34ekhtfgOWaeIDmILcUgUuZ1ndQH
         DlW2+vmM7BqMBDtanuh8DiknZPSr/R2a53YHBt7YRYybo6MGPjTk29Hl0o9it0oDRxf3
         ZDFT8UiUjFYkXNiutkfJu3Xf+vTP/gIlPV7Zy9FYmwSUD2tCCiA6rglKEIGpcVhO4a1j
         g2iSNvg+npagEqyVMq8AKXvW0giJPe5T5YQ9CTCR/sHMG5/u9sBk3bJhTj0lsieBQHd4
         GE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KBHYsW5yW1CAVvBFDgy/TGfxwLfAurjw5+HPPsQ8l00=;
        b=ShmII9HtH+7MnYG1rp9Lv8qHMS6BHUOFWjPYQyb/4MfGL5aQgYsnDwic6O1sOlMaSg
         P/1XxOHlFUIl6QPL9I9Q7TierdVrvYYCdPjmnxKKn0ySIs2nwD5ZkOKwQSlPsTts23Ot
         nlIdVXLz3rLvlzvBc+GcDW6viRpR+ORrBLGHLjT2cQIlmsFZbPdsiAqYn2R9xXAJZsea
         ZYfgLxOTz4ih4T2GscC/X6611FDOrh2o4BPF3WQuiNvQjj1n2ve5hGAuA91u/BG8nhCT
         ePNY6HGZlUc4xVeTnVwClj/eFUwLqgIEzrEm745OPk94ksTYMDByaKTEEbZPLyngq76t
         o5Jg==
X-Gm-Message-State: AOAM533Z5SQ+yxpXiaS49IISxnPdJdVubA/dvz/nG7SxX2B8wiVYym03
        Nnwt7rRcgtf4v6MpghyxbN2WJ6Q3rlRO69UE6Xs=
X-Google-Smtp-Source: ABdhPJziqnDloFofEuz0ZgAXix27jMBCHHkjhYh2laJZmfmWMUi9c/PYPVufxUad3bKMZ/Dod5JJOdXNbbnSDW6Xy4g=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr683424qkh.39.1592519622309;
 Thu, 18 Jun 2020 15:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com> <20200611222340.24081-3-alexei.starovoitov@gmail.com>
In-Reply-To: <20200611222340.24081-3-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 15:33:31 -0700
Message-ID: <CAEf4BzYbvuZoQb7Sz4Q7McyEA4khHm5RaQPR3bL67owLoyv1RQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 bpf-next 2/4] bpf: Add bpf_copy_from_user() helper.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 3:24 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Sleepable BPF programs can now use copy_from_user() to access user memory.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 11 ++++++++++-
>  kernel/bpf/helpers.c           | 22 ++++++++++++++++++++++
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h | 11 ++++++++++-
>  5 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 6819000682a5..c8c9217f3ac9 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1632,6 +1632,7 @@ extern const struct bpf_func_proto bpf_ringbuf_reserve_proto;
>  extern const struct bpf_func_proto bpf_ringbuf_submit_proto;
>  extern const struct bpf_func_proto bpf_ringbuf_discard_proto;
>  extern const struct bpf_func_proto bpf_ringbuf_query_proto;
> +extern const struct bpf_func_proto bpf_copy_from_user_proto;
>
>  const struct bpf_func_proto *bpf_tracing_func_proto(
>         enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0bef454c9598..a38c806d34ad 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3260,6 +3260,13 @@ union bpf_attr {
>   *             case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>   *             is returned or the error code -EACCES in case the skb is not
>   *             subject to CHECKSUM_UNNECESSARY.
> + *
> + * int bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)

Can we also add bpf_copy_str_from_user (or bpf_copy_from_user_str,
whichever makes more sense) as well?

> + *     Description
> + *             Read *size* bytes from user space address *user_ptr* and store
> + *             the data in *dst*. This is a wrapper of copy_from_user().
> + *     Return
> + *             0 on success, or a negative error in case of failure.
>   */

[...]
