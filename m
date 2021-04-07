Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A644357553
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 21:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355817AbhDGT7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 15:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355812AbhDGT7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 15:59:07 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69192C06175F;
        Wed,  7 Apr 2021 12:58:56 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id o198so64156yba.2;
        Wed, 07 Apr 2021 12:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+arhHcOopZCZVwwUY5LkE30MsV2yXA3O/x1Rb9Yvy3I=;
        b=Qi/nvyHe4p1pLSizPx3hdGve6ZHnvh83XFcT1ZlDKoLh9fwBGASz9JF23xKpn6Lq7C
         FXCHyLVyPFA2shUGBmVaTTPB8suUqf+Mxk1Ek7gYzxULZM2OzvKadc3xdc5aDB26+pDU
         vrV7rgcUVZWWfi/2xNMP6xHDdm/r6YV7hWn+wSb6+tM9eTgSsxPjqENl1f9/qvoJHwv/
         j6bbJK2M+0vD/yZ0V9plfT3dSjqspSAAHx0IqvQ1LgkXe0NlPSNE6eVV3U3/WZ31rsAC
         I9kKZPfdaG0tpNhoAKCPii7mcDBvIISy1BzDIEqgL0IzxFPu7i+NUPzy3dX6jvP6f1iG
         lU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+arhHcOopZCZVwwUY5LkE30MsV2yXA3O/x1Rb9Yvy3I=;
        b=DiZXNbQ2htnO8LU1L1L1KNVWKOheT7Z/o7tNi+bcbjXOs6abcQLfMsgnQ4gfC6IMty
         Mrz8lZzVF+ESf9VDN8KAbRKXV3QSeR4hwbzXYMCczMcZdysB/yBxWdNOjYpjqCciRKWH
         6zkplPJHuYJJtCQavlY0cum8HVV5zdTv5zV4MdDi4sHhz3TgEOZ3aLJrqS8dBix8xu6O
         WQrwGPpLP1x6H7uQCQwbwBbWriNm/iJpGyu5l7hI6WZs2XYU+i8jVgriMDAixIVM/qyu
         8BxY8Bmn+ZB/KLbhUeWwWzZsVjCZEAu7x/rk954dBA8kyHIFMFOSptUyHE5NVniwUfAI
         k55A==
X-Gm-Message-State: AOAM530ps5pBfjr5D3eTB9ZY2cq1EA8lf3PZC/3qSSTTRN5DlVVnDmDn
        sZqCzU9yTK8A82XU2t1HRqbUBwg1hjybLNxEZew=
X-Google-Smtp-Source: ABdhPJxQkN89156wQX1FRWeFcJzKGPxEYCyOFcmvrWlypN+PACMDIDQR0Wxy5GgajnLWkb6E+fOmN8eMMHNcfMXVX5E=
X-Received: by 2002:a25:9942:: with SMTP id n2mr6783373ybo.230.1617825535714;
 Wed, 07 Apr 2021 12:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210406185806.377576-1-pctammela@mojatatu.com> <CAOftzPgmZSB7oWDLLoO-NEDq3s8LdLxSXdhoaB2feScuTP-JSA@mail.gmail.com>
In-Reply-To: <CAOftzPgmZSB7oWDLLoO-NEDq3s8LdLxSXdhoaB2feScuTP-JSA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 12:58:44 -0700
Message-ID: <CAEf4BzaBJH-=iO-P6ZTj3zmycz0VESzBzpZkbVOVTvPaZ9OEaA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: clarify flags in ringbuf helpers
To:     Joe Stringer <joe@cilium.io>
Cc:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 11:43 AM Joe Stringer <joe@cilium.io> wrote:
>
> Hi Pedro,
>
> On Tue, Apr 6, 2021 at 11:58 AM Pedro Tammela <pctammela@gmail.com> wrote:
> >
> > In 'bpf_ringbuf_reserve()' we require the flag to '0' at the moment.
> >
> > For 'bpf_ringbuf_{discard,submit,output}' a flag of '0' might send a
> > notification to the process if needed.
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> >  include/uapi/linux/bpf.h       | 7 +++++++
> >  tools/include/uapi/linux/bpf.h | 7 +++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 49371eba98ba..8c5c7a893b87 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4061,12 +4061,15 @@ union bpf_attr {
> >   *             of new data availability is sent.
> >   *             If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
> >   *             of new data availability is sent unconditionally.
> > + *             If **0** is specified in *flags*, notification
> > + *             of new data availability is sent if needed.
>
> Maybe a trivial question, but what does "if needed" mean? Does that
> mean "when the buffer is full"?

I used to call it ns "adaptive notification", so maybe let's use that
term instead of "if needed"? It means that in kernel BPF ringbuf code
will check if the user-space consumer has caught up and consumed all
the available data. In that case user-space might be waiting
(sleeping) in epoll_wait() already and not processing samples
actively. That means that we have to send notification, otherwise
user-space might never wake up. But if the kernel sees that user-space
is still processing previous record (consumer position < producer
position), then we can bypass sending another notification, because
user-space consumer protocol dictates that it needs to consume all the
record until consumer position == producer position. So no
notification is necessary for the newly submitted sample, as
user-space will eventually see it without notification.

Of course there is careful writes and memory ordering involved to make
sure that we never miss notification.

Does someone want to try to condense it into a succinct description? ;)
