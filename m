Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972EE23EAA2
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 11:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHGJmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 05:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgHGJmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 05:42:50 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87A5C061574
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 02:42:49 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 3so1244283wmi.1
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 02:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5juPhLU+H4JaoeKCbinA/+bVYUkZ9Go2t3xfDKEiaSE=;
        b=PS+YsVZjAszmaNqZruaBMYez4s4zsHbm6Rg9hkcG5c/mGwKMaybsv+wZkvtR/yFR3w
         xdL+sLAbQH9XSrjxcsBD3P/gXtXNQcBTNTsTh/I9aGLhMY2k8rvY0GSgGblnbDC/a4gh
         ssRWpNWaBmkrLLdeH828d66FtH39WkilqI/fU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5juPhLU+H4JaoeKCbinA/+bVYUkZ9Go2t3xfDKEiaSE=;
        b=OJXcg+HuyQXx1PrgNzO7wlyAsyw8PMUxol0Oy6JT33uJugf4+Ve+BjBa0P5cBgCRuB
         hpuqpY+ZrddJXyRuDOXnTuntJCFUA1iP+Eh2iP0UhcB3M8h1gMiqAd7l98YQq7QF99sE
         h7fP3gqKEemxwODlQWcb/4BJOP4/PUNRO66Yy38mfpzYeZtSC6U4kgKqe3SQoV05iMb2
         BLIA7izBdYgDsKkeuheFZGSZt//QX87c7LfOU+oDOWM5SFt7RlGw0CcEpBgnnV8X3RtH
         yU2mkZzCmazTprh/+boafRqHaJVcGdLTf94rwzQrXFZRh1/5N50qBdCi2eJ7G7ukxWhV
         YAng==
X-Gm-Message-State: AOAM531rJmwl3ZsuA1YFt7V2fYURCJqD930EY1II0yWmg85qjddfP6Fl
        Zt5qOWcEBR4gVrJt0IHW0qQO+9ZPRfkSKPXqcF0udQ==
X-Google-Smtp-Source: ABdhPJzaoiavitVpRXHug7knKfFC7wo4ZeSgnUYzB1EnjOZPQP9yguuWaSFjI82GWGfvu/OfTq4IHSEy+dyeYiKR/OU=
X-Received: by 2002:a7b:c0c8:: with SMTP id s8mr12404856wmh.4.1596793368233;
 Fri, 07 Aug 2020 02:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-11-jolsa@kernel.org>
 <CACYkzJ57H391Xe20iGyHPkLWDumAcMuRu_oqV0ZzBPUOZBqNvA@mail.gmail.com> <20200807083528.GA561444@krava>
In-Reply-To: <20200807083528.GA561444@krava>
From:   KP Singh <kpsingh@chromium.org>
Date:   Fri, 7 Aug 2020 11:42:35 +0200
Message-ID: <CACYkzJ5vRuC8s_s=k7i0sYSrM333Xty7s0dAz0zMXyb2bow3AQ@mail.gmail.com>
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
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 10:35 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, Aug 07, 2020 at 02:31:52AM +0200, KP Singh wrote:
> > On Sat, Aug 1, 2020 at 7:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding d_path helper function that returns full path for
> >
> > [...]
> >
> > > +}
> > > +
> > > +BTF_SET_START(btf_allowlist_d_path)
> > > +BTF_ID(func, vfs_truncate)
> > > +BTF_ID(func, vfs_fallocate)
> > > +BTF_ID(func, dentry_open)
> > > +BTF_ID(func, vfs_getattr)
> > > +BTF_ID(func, filp_close)
> > > +BTF_SET_END(btf_allowlist_d_path)
> > > +
> >
> > > +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> > > +{
> > > +       return btf_id_set_contains(&btf_allowlist_d_path, prog->aux->attach_btf_id);
> > > +}
> >
> > Can we allow it for LSM programs too?
>
> yes, that's why I used struct bpf_prog as argument, so we could reach the

Thanks for adding the bpf_prog argument.

> program type.. but I was hoping we could do that in follow up patchset,

Sure. We can do it in a follow-up patch.

- KP

> because I assume there might be still some discussion about that?
>
> I plan to post new version today
>
> jirka
>
> >
> > - KP
> >
> > > +
> > > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > > +BTF_ID(struct, path)
> > > +
> >
> > [...]
> >
> > >
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > --
> > > 2.25.4
> > >
> >
>
