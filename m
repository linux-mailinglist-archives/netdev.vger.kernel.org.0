Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2B20EACC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgF3BSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgF3BSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:18:49 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612B8C061755;
        Mon, 29 Jun 2020 18:18:49 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c30so13292050qka.10;
        Mon, 29 Jun 2020 18:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d8tAMwICXqgKPvOzjahMVAzDJDS8NleEPw2GGyNN/2U=;
        b=ndhXs9yeqlT5U78P3dbddL3NvAwigxMvkx+Cr4dXlaa0XLnw6aZtgVEcLm9xEuyjDw
         1Yd+a6c9qHnfnF52G+M77lp+WdVZX3mS8FWu33cpQEmBPoMjx0CCyrLGdM+ktClczjI3
         qmwvRKCvS0jP5FEwGmqatU5EYT1gSahpwCO8JH7tx2eFsfsCHlexWTNOAoiRwDx0VWuI
         h4PV/cdMrpQQMkU8u6cWIftVa4TTp/s7I2FkQxf6Q0mmBs/iNWYQzYbOjIbu0W2sFoLx
         pZmvRQZZP4cHytcPEAUvH6DCdR8zHcEd0ew+KlWAQqA0PA4qCPsJ8lDDYtZCtG8JMZ32
         8TlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d8tAMwICXqgKPvOzjahMVAzDJDS8NleEPw2GGyNN/2U=;
        b=Fz+ninBzr1kDlrTMrdMT1kaoNyEwB6SREZEuErkJDq4zkwAn7+BD3DAoP4ihSdOTmK
         UJgboBZdVOW+2nGiGctc8RHex6QW1o/xWmAe2aVy2Xk7pS3sO2NPHsCTOBghJtOdIhZn
         26wuAqkAoq6A52metpSMvBsr2rjf0480FfEiMrWbzxM9umr2s5NTVBHo97ODRjuPPhRL
         pwYO4gQC+wrYWnqlJd5PCCQIpi80F6b+2WyV6gYAe42vG0xXL89Nnvq1BEO4MkKSxEYX
         Ku+lArFdQl5HZZRjZcsK0Gpc0hkXXpvrNAGtGvZ9Uc9+gMRZc2WQznqjDGvsRJRQGJO9
         es9w==
X-Gm-Message-State: AOAM531V5g6No2VmueODUDUc7n2oM/jh4wuu5NYSCtAcCDVxM7chgHsW
        FrIZjy+Mpjq88hH2QyKIVO2Z06nCe8x15Zzuux8=
X-Google-Smtp-Source: ABdhPJxA/2GwwRG+MrzupQDYE8NUyQBkIhjOFFypsT4PBrge/kfCAJG2fCTXx5+N9/Jim+6xApq4RFES1UPnBrDlb00=
X-Received: by 2002:a37:270e:: with SMTP id n14mr16635482qkn.92.1593479928606;
 Mon, 29 Jun 2020 18:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com> <20200630003441.42616-4-alexei.starovoitov@gmail.com>
In-Reply-To: <20200630003441.42616-4-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 18:18:37 -0700
Message-ID: <CAEf4BzZ_ZGkMXRYV7VeudCVs=A3xY=1Mz97GLbbazXv-KUcnRw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/5] bpf: Add bpf_copy_from_user() helper.
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

On Mon, Jun 29, 2020 at 5:35 PM Alexei Starovoitov
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
> index e2b1581b2195..c9f27d5fdb7c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1657,6 +1657,7 @@ extern const struct bpf_func_proto bpf_skc_to_tcp_sock_proto;
>  extern const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto;
>  extern const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto;
>  extern const struct bpf_func_proto bpf_skc_to_udp6_sock_proto;
> +extern const struct bpf_func_proto bpf_copy_from_user_proto;
>
>  const struct bpf_func_proto *bpf_tracing_func_proto(
>         enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 73f9e3f84b77..6b347454dedc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3293,6 +3293,13 @@ union bpf_attr {
>   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
>   *     Return
>   *             *sk* if casting is valid, or NULL otherwise.
> + *
> + * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
> + *     Description
> + *             Read *size* bytes from user space address *user_ptr* and store
> + *             the data in *dst*. This is a wrapper of copy_from_user().
> + *     Return
> + *             0 on success, or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3435,7 +3442,9 @@ union bpf_attr {
>         FN(skc_to_tcp_sock),            \
>         FN(skc_to_tcp_timewait_sock),   \
>         FN(skc_to_tcp_request_sock),    \
> -       FN(skc_to_udp6_sock),
> +       FN(skc_to_udp6_sock),           \
> +       FN(copy_from_user),             \
> +       /* */

Thank you for this! Those trivial merge conflicts due to '\' were
really annoying.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
