Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1BE24E286
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgHUVRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgHUVR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:17:29 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79923C061573;
        Fri, 21 Aug 2020 14:17:29 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id y2so3380770ljc.1;
        Fri, 21 Aug 2020 14:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Y8Ez4pa2ApbWubBTUCh6B8TyCD929c4j3pQk30qda8=;
        b=uaO913Mnnbmoua0DYbXH8vx2qEfRaNdl/GKji80qKh/CdGAxOUVFYQaVbpnLNfuBi0
         LdGxcRzIVEznT5jclgv7ahvM6oyF0KC5+IWPYPgZfZnjtfjP+693APiqsijp6cFRUFOv
         yqAIsO5NrzHICPp8Jjo7UhDKJVZSzr8tIpEZ71dk8Sv0CdprkThM7OMDDqu7zb8ZHdyf
         bS5m9KNvFrc64ZOoZH8sHwKRjznw7XF56L12OEe8lAQTlFAWbkrjaPNPlKw396uWIapd
         sYEC+HJoh8jZ3GGJ7CnxgPRTUnJIOTMSTeYQTtTTR4kC7d4qhhft+97lfPQ1v592bZW9
         l7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Y8Ez4pa2ApbWubBTUCh6B8TyCD929c4j3pQk30qda8=;
        b=hlGqPKzQbfpM/O94O0sXCk4ut45Yqvp6ovQ+CJ4jcSDQdkL65Fi2C99vyw+u1cXs3D
         PbKIC0fAa7x0VPqQJRHQeP/GyJiuacLvLAw+2ucqXkf8A0+pDhKKug8d00lkM/S6Hfyr
         rKPOj74Oda7+YW67pEhPRYMvEFg58pVZ1K//NLXfoYzBf0eWeXYHKiUQ2XGd18Df6mzP
         25cQ/e0sU1bp+dIWZhsXxo8yxOxL9jKf1xyPsfSYCzftJGEDmlqBUaIjpapUBHNCktrq
         lTkqjG677axjLngL77APmF11hDn99VakgZ59gPBgWlHIwAn5AuEP6TPYMofCELRPwBpe
         97Jg==
X-Gm-Message-State: AOAM533WlrpO2pqizcEYqgAD8AQ/Lu821bQF/muzabj5lm4BB4tpG526
        icAP6piNe1/G/tOYSTEwcr8sUgQHuxsoFzv91lY=
X-Google-Smtp-Source: ABdhPJxw2aUWGFEQ711AaegJg/2aYowv4Jvq7gZyuJsz6BMSsgkvDyp8vQiZSD0fKSJvolwj6pol2u1woa1PwXnQd8E=
X-Received: by 2002:a2e:8e28:: with SMTP id r8mr2182846ljk.290.1598044647897;
 Fri, 21 Aug 2020 14:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200821184418.574065-1-yhs@fb.com> <CAEf4BzZQOz_uBkSOSXRXvc2nb0y5FUvT7x_SWwCbgwzwQKVdBg@mail.gmail.com>
In-Reply-To: <CAEf4BzZQOz_uBkSOSXRXvc2nb0y5FUvT7x_SWwCbgwzwQKVdBg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Aug 2020 14:17:16 -0700
Message-ID: <CAADnVQ+6avUVgC422WWe_1aN_qLNiWKdOzGi7XSVm0M5dqjEvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] bpf: implement link_query for bpf iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 12:04 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Aug 21, 2020 at 11:44 AM Yonghong Song <yhs@fb.com> wrote:
> >
> > "link" has been an important concept for bpf ecosystem to connect
> > bpf program with other properties. Currently, the information related
> > information can be queried from userspace through bpf command
> > BPF_LINK_GET_NEXT_ID, BPF_LINK_GET_FD_BY_ID and BPF_OBJ_GET_INFO_BY_FD.
> > The information is also available by "cating" /proc/<pid>/fdinfo/<link_fd>.
> > Raw_tracepoint, tracing, cgroup, netns and xdp links are already
> > supported in the kernel and bpftool.
> >
> > This patch added support for bpf iterator. Patch #1 added generic support
> > for link querying interface. Patch #2 implemented callback functions
> > for map element bpf iterators. Patch #3 added bpftool support.
> >
> > Changelogs:
> >   v3 -> v4:
> >     . return target specific link_info even if target_name buffer
> >       is empty. (Andrii)
> >   v2 -> v3:
> >     . remove extra '\t' when fdinfo prints map_id to make parsing
> >       consistent. (Andrii)
> >   v1 -> v2:
> >     . fix checkpatch.pl warnings. (Jakub)
> >
> > Yonghong Song (3):
> >   bpf: implement link_query for bpf iterators
> >   bpf: implement link_query callbacks in map element iterators
> >   bpftool: implement link_query for bpf iterators
> >
> >  include/linux/bpf.h            | 10 ++++++
> >  include/uapi/linux/bpf.h       |  7 ++++
> >  kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
> >  kernel/bpf/map_iter.c          | 15 +++++++++
> >  net/core/bpf_sk_storage.c      |  2 ++
> >  tools/bpf/bpftool/link.c       | 44 ++++++++++++++++++++++++--
> >  tools/include/uapi/linux/bpf.h |  7 ++++
> >  7 files changed, 140 insertions(+), 3 deletions(-)
> >
> > --
> > 2.24.1
> >
>
> LGTM, thanks.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
