Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061D120BBA7
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgFZVfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZVfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:35:07 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97DC03E979;
        Fri, 26 Jun 2020 14:35:07 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id h18so5157393qvl.3;
        Fri, 26 Jun 2020 14:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=023NKTkZGg4IC8ZwEuOqLRGqtbebfZV/WPOtqSM/PQM=;
        b=bUzYOEIH6HkrjtORASge6JEyzjjXPOkp/iTWAjc362wWNH3LF8FQNDQKxRvn2rD7zb
         yFYDhtyJRZ06KNq+6RtMizJjG9IEAyBgWr0Y/6yipo7L6WIe6xr5cXowwNLj0u+sJYyL
         ZqmtsIQJaTM3TqXOagZt0OBJxPihYNsLxoLpknjyIVtsEMwRFyWIk0EM9ViwdFmKPZyt
         l9eXrzjIC02M5Vp+QWKR/XwhXaNoJxScXx912O/ooHi5N9al4c4I9+p0/499y640NDIl
         aAor+jiA1Dl5BjIZgoPOH4esOvjLljAO1b2NnESCQ49dOySC6ojqjwWWT04WSmWxS+nZ
         Y1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=023NKTkZGg4IC8ZwEuOqLRGqtbebfZV/WPOtqSM/PQM=;
        b=kqjXmQqGCRZttD3aVrGsfMf/yEeW+m8zDY7VBOE1Fy3NM8muhe69Tg/6ak5/4WfaFB
         I9p+Ft3Zl9EY2aW48LYwvwz5iQWIrNrm9SfUoRgnp5RJGSjhzJqJmDP0GLBUeV+1+c+W
         1w1o3IoIQSAZbFBdyS5284oXf7qYj2l7sr3bMk+Dlb7tVSkg+3tr9Qw5Z705BJ7q8QuR
         h9A+VnFq2qm0MQrelEUw1w8jCVKv1Yq3W1P9ZtZ9mRFBjXCI9ZB/4RR64cWycqS7ghpe
         rMJaeuoWkqV6wDbWPyf8NjjdHEawCUjabkYJ4h/lx/o6WlOZOfGdFNUexmyAzvfnIvCk
         jEyg==
X-Gm-Message-State: AOAM5332hoxTrcNEg2sL44AT50bbF+OvNP8uzM0H1Tk/mqptizdFNviY
        wHrNS3mTVairDOa7EktnGU8h5XhQz+nXpXwdjl4=
X-Google-Smtp-Source: ABdhPJwMT0Gle7nbNkJCVgJmMogHItbVOAusJ+YOpaibh4GkoYwmeoKLtIXQ4csRzP+jbB4hvmIBYHZaPP3i48tzI8U=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr4888713qvb.228.1593207306814;
 Fri, 26 Jun 2020 14:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-5-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:34:55 -0700
Message-ID: <CAEf4BzaDYBq34PLpFd_+Zdk1PpKg-jsRw3Xs_QQ4XN4hMDphBQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 04/14] bpf: Resolve BTF IDs in vmlinux image
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
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

On Thu, Jun 25, 2020 at 4:48 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Using BTF_ID_LIST macro to define lists for several helpers
> using BTF arguments.
>
> And running resolve_btfids on vmlinux elf object during linking,
> so the .BTF_ids section gets the IDs resolved.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  Makefile                 | 3 ++-
>  kernel/trace/bpf_trace.c | 9 +++++++--
>  net/core/filter.c        | 9 +++++++--
>  scripts/link-vmlinux.sh  | 6 ++++++
>  4 files changed, 22 insertions(+), 5 deletions(-)

[...]
