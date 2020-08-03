Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11602239E92
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgHCFFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgHCFFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:05:51 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4BCC06174A;
        Sun,  2 Aug 2020 22:05:51 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id u43so6255195ybi.11;
        Sun, 02 Aug 2020 22:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3T7Ik/YwD7BnBHHfjXl9hw5B/iy4fduVP06/2/CYjLc=;
        b=q8Ji3fqwZihwOhbM4jcUT4rxNTBTnwr/W9PcRXHXPO+9CaxeCEg9YZi5XEnvUuN+Cp
         I26EJJKIRplhDlf4x5XjhIwu7KABvE5ajFPqUzoPy1AppJg4ktaXQstOVslJ0RjXoyqL
         YVUZAK05wciHuCxRhzYYBsepgeBejyd+ArRrUYXuVDpeQyMuUR7Bf7L40MTdu7emhYD0
         3K8C8uORi7bOGBTRAb30Fgi2r4g3XJpgDc933o1R4qDOq9bQ96REBj8mwPURaDBW2Wq5
         8VeTtdxt7UqZutp4n3C6/zy/eKSBuGjEdzbaG1BA3QLhubtVpOL9MeDXNP8P5HUh2jUX
         iNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3T7Ik/YwD7BnBHHfjXl9hw5B/iy4fduVP06/2/CYjLc=;
        b=KZB14MeXAP2TS4w22jguNA9lqZZUJuKsK0HPJj8uAJQG0RX8vVk1aYlMeLiO19jtV7
         UDfx73bSw2KeWheky2A4Bn5JtPgEy0UFj5+/324yvXZCdU9KIkkKFa5m1sQqGxaunfV5
         y2uAjmBFZ8F3Q+iHodnEMhuFy/RSdHCrIV5AQr6QlGtiMLcsWT5DvaMNQLzdXL1Lniyl
         1xD8laUKWOOsOm+ZpazRrAA7wH/hEO0W0LRDNskh9sBOMauSFd62/oAzQI5Jhj+X6LvA
         MwcF3Wdh6MArD2ZSMTDN/3rWYD5lH1+KFRNQtHoVxhHdNoshfeQcwhDmRLIJts27QBYS
         bABg==
X-Gm-Message-State: AOAM532SV0V/IRIIZZLEkRlXqk2wAoxIhEYCwWi2Njwnba0dvdZV9xd8
        IRr2WfgXwp4mXkg+Rzzy+JhPzeSiFRHKzCmjhnM=
X-Google-Smtp-Source: ABdhPJzkBRsYnW6x02jbpbEXy2VPlFBmqqbEhwmiQMPPfUJld06HtnN103eCpW7WB5RUPyVgsYoG2gzbDMhzYU1Mzyk=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr22480530ybq.27.1596431150542;
 Sun, 02 Aug 2020 22:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com> <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
 <3B31DE6E-B128-48D7-91A9-84D51BDF205B@fb.com>
In-Reply-To: <3B31DE6E-B128-48D7-91A9-84D51BDF205B@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 22:05:39 -0700
Message-ID: <CAEf4BzZcn_44DE4Zr9YKGaPoGvZzgv0tvZbZP-0nuwA5RVPbog@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 2, 2020 at 9:21 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >> Add cpu_plus to bpf_prog_test_run_attr. Add BPF_PROG_SEC "user" for
> >> BPF_PROG_TYPE_USER programs.
> >>
> >> Signed-off-by: Song Liu <songliubraving@fb.com>
> >> ---
> >> tools/lib/bpf/bpf.c           | 1 +
> >> tools/lib/bpf/bpf.h           | 3 +++
> >> tools/lib/bpf/libbpf.c        | 1 +
> >> tools/lib/bpf/libbpf_probes.c | 1 +
> >> 4 files changed, 6 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> >> index e1bdf214f75fe..b28c3daa9c270 100644
> >> --- a/tools/lib/bpf/bpf.c
> >> +++ b/tools/lib/bpf/bpf.c
> >> @@ -693,6 +693,7 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
> >>        attr.test.ctx_size_in = test_attr->ctx_size_in;
> >>        attr.test.ctx_size_out = test_attr->ctx_size_out;
> >>        attr.test.repeat = test_attr->repeat;
> >> +       attr.test.cpu_plus = test_attr->cpu_plus;
> >>
> >>        ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
> >>        test_attr->data_size_out = attr.test.data_size_out;
> >> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> >> index 6d367e01d05e9..0c799740df566 100644
> >> --- a/tools/lib/bpf/bpf.h
> >> +++ b/tools/lib/bpf/bpf.h
> >> @@ -205,6 +205,9 @@ struct bpf_prog_test_run_attr {
> >>        void *ctx_out;      /* optional */
> >>        __u32 ctx_size_out; /* in: max length of ctx_out
> >>                             * out: length of cxt_out */
> >> +       __u32 cpu_plus;     /* specify which cpu to run the test with
> >> +                            * cpu_plus = cpu_id + 1.
> >> +                            * If cpu_plus = 0, run on current cpu */
> >
> > We can't do this due to ABI guarantees. We'll have to add a new API
> > using OPTS arguments.
>
> To make sure I understand this correctly, the concern is when we compile
> the binary with one version of libbpf and run it with libbpf.so of a
> different version, right?
>

yep, exactly

> Thanks,
> Song
>
> >
> >> };
> >>
> >> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index b9f11f854985b..9ce175a486214 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] = {
> >>        BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
> >>        BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
> >>        BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOCAL),
> >> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
> >
> > let's do "user/" for consistency with most other prog types (and nice
> > separation between prog type and custom user name)
>
> Will update.
>

thanks!
