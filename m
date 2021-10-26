Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E4243B7D4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbhJZRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbhJZRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:06:03 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF0EC061745;
        Tue, 26 Oct 2021 10:03:39 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v200so36551488ybe.11;
        Tue, 26 Oct 2021 10:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uDTMGWAumcppRQTTt/9RJBXUz5ZAmLW8AZg8+OT4b4I=;
        b=dhiikuNcETWSy2ebc54Eaez6dOXRocZuO6D1g7OcrV+AUsGF+k+kF8f98WbiFq9CqS
         R4DGwK2+eHkJ8H9imzge1L0zlElKG96vEyrSlB9MXBdxdZEV5tMWxy7A5UStGEkuvs5n
         9TSGwHXG390Y1OULvpyvfDK3XkeAEbgTDUCl2ndI1jH/kOyWSl0c3/e7cvYLZPR5VNpz
         jHdIjXvmSopIbHxxl4DOr6/Fx1FsIBPU2hqsIQDY8mc73YUrCIpEp4UfvvNL4JuZyxE2
         lHgnqkYkxj7syhZpfZD96dN0mmP70EgatbWR4uy4NXuJaE5UQXE4RmBvgKrNS4CvfNAm
         I+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uDTMGWAumcppRQTTt/9RJBXUz5ZAmLW8AZg8+OT4b4I=;
        b=2udgfUbXUSMbeAArK42bsjnWOPwxs3oDKFP1Es6mjmmzaQTm+Xv0YP6PMVWWGS0doK
         d5ctkRtsGjh8FVIn29sC7lA14ZNRfAmalRyy8MCchixphAL5QA14b3CdejK95hEOU++p
         /xuY29y1KHcevKe6vPJW8fxyFLTw6/HYPettpPU68l44P0pZgBa70BUvuMI5+gGlOVgU
         IzFKdj+54kOJHfdhpdy4YBVhgDmdWnvMop5WE7ovbZ7TK/C9g1YkZF3evr3mDrLMxLBY
         yrp9sJNXv8HPt030FXa/6pXJX8+WBIKKnKewbT2UDydqXJTh3DwSoxvNKTsr9npD7AK9
         Lqgg==
X-Gm-Message-State: AOAM532KOq3EPvJ+B3G2uMyJI1fyv7bnycQGzYlt1HlynHb7QrVCZU40
        ltKevJ7C0jWoMrso5NcPxT3yEe2Mr6h0X58vLW4=
X-Google-Smtp-Source: ABdhPJzJzyWKWRmCAVOp/PEJJzUy7vunEPHyyfERgo5ZcjTEYQOEQFbEFK81UgNoLKHM1N2WlQv/6CsX2VzJhvunoCY=
X-Received: by 2002:a25:143:: with SMTP id 64mr25080123ybb.455.1635267819106;
 Tue, 26 Oct 2021 10:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com> <20211011155636.2666408-2-sdf@google.com>
 <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch> <CAKH8qBuR4bYn1POgu0TF428vApknvMNPAng5qMuiKXCpcg8CQQ@mail.gmail.com>
 <CAEf4BzaUFAVZz2PHePbF4ypBHusUJEZi5W9HL0gT_fy1T71itg@mail.gmail.com> <CAKH8qBt3_qpCLjviMr86EixBx+pVG5E4+ZZeHZpwO6G6wnrR+g@mail.gmail.com>
In-Reply-To: <CAKH8qBt3_qpCLjviMr86EixBx+pVG5E4+ZZeHZpwO6G6wnrR+g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Oct 2021 10:03:27 -0700
Message-ID: <CAEf4BzZnsiotMAjmeHN6y3sXgvJ_XbQHazMJbXrFuSr3RkVXzQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
To:     Stanislav Fomichev <sdf@google.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 8:46 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, Oct 25, 2021 at 9:27 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Oct 25, 2021 at 8:59 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Fri, Oct 22, 2021 at 10:05 AM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Stanislav Fomichev wrote:
> > > > > Otherwise, attaching with bpftool doesn't work with strict section names.
> > > > >
> > > > > Also, switch to libbpf strict mode to use the latest conventions
> > > > > (note, I don't think we have any cli api guarantees?).
> > > > >
> > > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > > ---
> > > > >  tools/bpf/bpftool/main.c |  4 ++++
> > > > >  tools/bpf/bpftool/prog.c | 15 +--------------
> > > > >  2 files changed, 5 insertions(+), 14 deletions(-)
> > > > >
> > > > > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > > > > index 02eaaf065f65..8223bac1e401 100644
> > > > > --- a/tools/bpf/bpftool/main.c
> > > > > +++ b/tools/bpf/bpftool/main.c
> > > > > @@ -409,6 +409,10 @@ int main(int argc, char **argv)
> > > > >       block_mount = false;
> > > > >       bin_name = argv[0];
> > > > >
> > > > > +     ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> > > > > +     if (ret)
> > > > > +             p_err("failed to enable libbpf strict mode: %d", ret);
> > > > > +
> > > >
> > > > Would it better to just warn? Seems like this shouldn't be fatal from
> > > > bpftool side?
> > > >
> > > > Also this is a potentially breaking change correct? Programs that _did_
> > > > work in the unstrict might suddently fail in the strict mode? If this
> > > > is the case whats the versioning plan? We don't want to leak these
> > > > type of changes across multiple versions, idealy we have a hard
> > > > break and bump the version.
> > > >
> > > > I didn't catch a cover letter on the series. A small
> > > > note about versioning and upgrading bpftool would be helpful.
> > >
> > > Yeah, it is a breaking change, every program that has non-strict
> > > section names will be rejected.
> > >
> > > I mentioned that in the bpftool's commit description:
> > > Also, switch to libbpf strict mode to use the latest conventions
> > > (note, I don't think we have any cli api guarantees?).
> > >
> > > So I'm actually not sure what's the best way to handle this migration
> > > and whether we really provide any cli guarantees to the users. I was
> > > always assuming that bpftool is mostly for debugging/introspection,
> > > but not sure.
> > >
> > > As Andrii suggested in another email, I can add a flag to disable this
> > > strict mode. Any better ideas?
> >
> > Maybe the other way around for the transition period. Add a --strict
> > flag to turn on libbpf strict mode? This follows libbpf's opt-in
> > approach to breaking change. We can also emit warnings when people are
> > trying to pin programs and mention that they should switch to --strict
> > as in some future version this will be the default. Would that be
> > better for users?
>
> Agreed, that sounds better for backwards compatibility. However, I'm
> not sure when we set that --strict to 'true' by default. The same
> moment libbpf loses non-strict behavior?

Yep, probably it will have to coincide with libbpf 1.0 release. And
it's not setting it to true, it's more like enforcing it to true (or
just dropping the --strict flag altogether).
