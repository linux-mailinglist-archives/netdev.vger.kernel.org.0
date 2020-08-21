Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B724E06A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHUTEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgHUTE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:04:28 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D9AC061573;
        Fri, 21 Aug 2020 12:04:28 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id i10so1560280ybt.11;
        Fri, 21 Aug 2020 12:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fw6iApV3eG35pr8zgOPE8u4W9sm/PRtthJwhKMrWo2A=;
        b=k/0PCYhxn3flk/K2JDQwzdtXIH/eTndiSiH4mK9ZzprDqFB+r5oCD1RmFoec1cLS9v
         l6DyOHTzMCWBv68dCLmG4TDfBMYhSfpsV+AwwPsg3GB9N69YrLIrSKAoLSSLJ2GNG9Ld
         JRR2O6TYKy1T0e1R8ZY6v5F3je46/fIWsSi7cGSyqFZHyhPjzpgrYvnKCKQNOat7soNj
         J+eCZEISPbx6CWjWybE1YjN5vvgFFziYN5TNMBGfE5QJ0CY4KxQbTgHIBImnhM3lvAm1
         yzvTzhSy+yHbY6qjW4BW4lH1X63aO4QFB8VF9iNYk/54YqdWzxlwn/e21YA6CnlEEuwF
         XMUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fw6iApV3eG35pr8zgOPE8u4W9sm/PRtthJwhKMrWo2A=;
        b=qm0H33cf4yRpWvC49KB6HLntHhd7mRfgDdxmWOb6K6dDqKKRcjPI1R7zwFEZI84vJw
         yVb7Po0hXJ456WDP5S560KHLCYgRYYCT+eGHBhxYjU1X+PtEEX0Rj8YElZ+aEuE+XDpU
         5zkm2zbv/EwC4+COjRpf5yN8T+veqJKNzwMHFCqNiWFfB16IUgt1Qx3r47E5k20B1dzS
         nYrrdDecF44/9argOqU+LkRj9255g+5gKZLCWc4YeNu5j+gKE5Z7oJzc3NGCH8UAb1Pa
         TNePpN53CzNs7a4FiVwT/GAATzWBmctoZw118Mo8XOLwA7taljW8HxiCbr/Ogu5ae7Df
         tvkQ==
X-Gm-Message-State: AOAM532bTbu+x0mZIZg/oLatNXQJDjqF66xGG+ib2qYD7S5kBWuhnqLq
        2OMX1r9iXpP14+c21OKwSo1pNfMeGkDFT34nBkc=
X-Google-Smtp-Source: ABdhPJyE1cEVyra2r1FXxr8mcJmTKQIVazKhJsVfScNJSpooJD8AyHXI/1KNgcrLi4uSSW6UShJ55Umh9ya9lepBBzI=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr5399335ybq.27.1598036667532;
 Fri, 21 Aug 2020 12:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200821184418.574065-1-yhs@fb.com>
In-Reply-To: <20200821184418.574065-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 12:04:16 -0700
Message-ID: <CAEf4BzZQOz_uBkSOSXRXvc2nb0y5FUvT7x_SWwCbgwzwQKVdBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] bpf: implement link_query for bpf iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 11:44 AM Yonghong Song <yhs@fb.com> wrote:
>
> "link" has been an important concept for bpf ecosystem to connect
> bpf program with other properties. Currently, the information related
> information can be queried from userspace through bpf command
> BPF_LINK_GET_NEXT_ID, BPF_LINK_GET_FD_BY_ID and BPF_OBJ_GET_INFO_BY_FD.
> The information is also available by "cating" /proc/<pid>/fdinfo/<link_fd>.
> Raw_tracepoint, tracing, cgroup, netns and xdp links are already
> supported in the kernel and bpftool.
>
> This patch added support for bpf iterator. Patch #1 added generic support
> for link querying interface. Patch #2 implemented callback functions
> for map element bpf iterators. Patch #3 added bpftool support.
>
> Changelogs:
>   v3 -> v4:
>     . return target specific link_info even if target_name buffer
>       is empty. (Andrii)
>   v2 -> v3:
>     . remove extra '\t' when fdinfo prints map_id to make parsing
>       consistent. (Andrii)
>   v1 -> v2:
>     . fix checkpatch.pl warnings. (Jakub)
>
> Yonghong Song (3):
>   bpf: implement link_query for bpf iterators
>   bpf: implement link_query callbacks in map element iterators
>   bpftool: implement link_query for bpf iterators
>
>  include/linux/bpf.h            | 10 ++++++
>  include/uapi/linux/bpf.h       |  7 ++++
>  kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/map_iter.c          | 15 +++++++++
>  net/core/bpf_sk_storage.c      |  2 ++
>  tools/bpf/bpftool/link.c       | 44 ++++++++++++++++++++++++--
>  tools/include/uapi/linux/bpf.h |  7 ++++
>  7 files changed, 140 insertions(+), 3 deletions(-)
>
> --
> 2.24.1
>

LGTM, thanks.

Acked-by: Andrii Nakryiko <andriin@fb.com>
