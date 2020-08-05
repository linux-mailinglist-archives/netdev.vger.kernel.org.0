Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ED523D371
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 23:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgHEVKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 17:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725139AbgHEVKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 17:10:04 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55673C061575;
        Wed,  5 Aug 2020 14:10:04 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x2so4367914ybf.12;
        Wed, 05 Aug 2020 14:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y5HNeTe4uJkYH5b8+Fesy3su7HNHxfOePc2M1RI34GE=;
        b=QqF+WuyQKMq9P1lYXegqhjAHKXfAqIzh9iicdYDwvdmQgjfVsMQu/SKv+qJTD1wHSY
         JRp9PLZJDCpGCCxMv6Dg5y6MqYgMBqEEhFxJzSG7Kkr52Z+k210Zcxe/dvq0HA7+aASa
         K+HXz2Da7eNm7BvM+r3774aDi4wQNqQEILr/83ti7a8pZOCJblGnUotpKwjhn0Pypym2
         s9zMDKELkCQBSU51r+kE+EjGMwEr9bejmKqohDv8zUH17KVA4+pXDdMugt4eppgjKD7d
         rhD6jacFdTEQ/U7tZDPixGh/5ZztfXYoFerKTbuEyJkylDX4BMahFBNl4RX+plQpdCZn
         5eBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y5HNeTe4uJkYH5b8+Fesy3su7HNHxfOePc2M1RI34GE=;
        b=a5g24a/ga+Fxi/+OrYdc4523zuy/jEeGI0YYj0jrlT30IHI00OYiUNzLn5L9LX3Au8
         Df7PBgiqAW4x/9WDooIx1mD7T/QSXsM2lWbhxRnt9LMObHuu8JzteauLo9YEzvpyfXsu
         pqvP1XbiQOer30bNXzuOesj/Fx/S8P2bU/D0+cgM/pRRHhiG1ErmpRl9e7Mzz4Q3isCt
         arq51TIpoU5FuJOA+Ux6SK4fsZbxVS/rgeYdvntnKoDFUDnwwtVnLXsPX5tkwmsKBrnw
         P3mQU06CUhO0M4OD3+ACtqMlr+SEqCwrXw2HlcsjpMHsmPwcJoQHE9cZsL1zJx6Y8Fu9
         r9Bg==
X-Gm-Message-State: AOAM530in3NXBtZpyoEI/1NV6l/nT6tGS+JVZiqbs/fAJU/YdcjMSwbq
        dDk/bEYMK/Vvl4wu84BOjn9IIJ1FhnayNJSf3Ao=
X-Google-Smtp-Source: ABdhPJy0VX6lVSX12SLL3gD1uks8MBv7DmMY4MpRm3N+6pV3/yuU2A2DUdoIkRMDAlypL3YJ2I/W9QvTCp0scObMKHc=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr7316125ybe.510.1596661803552;
 Wed, 05 Aug 2020 14:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-11-jolsa@kernel.org>
 <CAEf4BzY5b8GhoovkKZgT4YSUUW=GPZBU0Qjg4eqeHNjoPHCMTw@mail.gmail.com>
 <20200805175850.GD319954@krava> <20200805210101.GF319954@krava>
In-Reply-To: <20200805210101.GF319954@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Aug 2020 14:09:49 -0700
Message-ID: <CAEf4BzYudhoouZO2nXcTQh3otK6FO04sQJj6RWjAfa_4o4V=zQ@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 2:01 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Aug 05, 2020 at 07:58:54PM +0200, Jiri Olsa wrote:
> > On Tue, Aug 04, 2020 at 11:35:53PM -0700, Andrii Nakryiko wrote:
> > > On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > Adding d_path helper function that returns full path for
> > > > given 'struct path' object, which needs to be the kernel
> > > > BTF 'path' object. The path is returned in buffer provided
> > > > 'buf' of size 'sz' and is zero terminated.
> > > >
> > > >   bpf_d_path(&file->f_path, buf, size);
> > > >
> > > > The helper calls directly d_path function, so there's only
> > > > limited set of function it can be called from. Adding just
> > > > very modest set for the start.
> > > >
> > > > Updating also bpf.h tools uapi header and adding 'path' to
> > > > bpf_helpers_doc.py script.
> > > >
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  include/uapi/linux/bpf.h       | 13 +++++++++
> > > >  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
> > > >  scripts/bpf_helpers_doc.py     |  2 ++
> > > >  tools/include/uapi/linux/bpf.h | 13 +++++++++
> > > >  4 files changed, 76 insertions(+)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index eb5e0c38eb2c..a356ea1357bf 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -3389,6 +3389,18 @@ union bpf_attr {
> > > >   *             A non-negative value equal to or less than *size* on success,
> > > >   *             or a negative error in case of failure.
> > > >   *
> > > > + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> > >
> > > nit: probably would be good to do `const struct path *` here, even if
> > > we don't do const-ification properly in all helpers.
>
> hum, for this I need to update scripts/bpf_helpers_doc.py and it looks
> like it's not ready for const struct yet:
>
>   CLNG-LLC [test_maps] get_cgroup_id_kern.o
> In file included from progs/test_lwt_ip_encap.c:7:
> In file included from /home/jolsa/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:11:
> /home/jolsa/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:32:1: warning: 'const' ignored on this declaration [-Wmissing-declarations]
> const struct path;
> ^
>
> would it be ok as a follow up change? I'll need to check
> on bpf_helpers_doc.py script first

yeah, no big deal

>
> jirka
>
