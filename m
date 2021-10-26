Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086F443B5FD
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhJZPtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhJZPtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:49:06 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2DDC061767
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:46:42 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r17so13888585qtx.10
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R+5HmDDZUtlzRRRsqWwE3SEIGVuAoci/RAiSJi18EH8=;
        b=GrWjdoYRGT/MzA9Rnjq8J0OtuIUgeRIAz/DiHnjYPnlDwCSZXAqI918B1LOfVx9m73
         wBLxkT3WgFV0BGZVv5gz7JG4cb08PcXVS5z29tu1F+M1Gaft9xJtxa0HwnoJFXwXMXi8
         8+NTRBU++S92cGQ1uVQK8Tzwdf2gFsmGnNwlN8ywpYaTpQn20AkcLjn3BwZjec39XHTM
         SqicXBvRcxrlxJAKpaPuyHfNmp1miJAPfVV6YjmpB02x5rrWYgg7H2fJYJWAB60tyqjE
         TXHG4V3E3nk2ybvdF9AFuFEQdl+YWmJCOgLy79Q/U1T8B5Ixxahz0+cKOnGAu8G66gju
         RHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R+5HmDDZUtlzRRRsqWwE3SEIGVuAoci/RAiSJi18EH8=;
        b=XHlxLtCQNfOdIPFBqTNqxx6Hv6bZRmiCz+uhbbUb2QK0h6K6Zj++VzvjibuSDWJHye
         uB/R3+ruFebAk87ZQT0/ubhtKj1lN2Nv/KgOW7uUemzSRSyiwuTXPDm+cm7CCkXYxUi7
         44WMIZhJCe4sPXSKnQpWqtdoCgKuWZe4ET7Q6A6eTohZfTUSi342HdASiBfVZfUDJyy0
         /MD9C9wCb8wNPdxRXBTXLsTQHQJf5EgMGpNs+5CJxPqOCJjtfg+ASvwNn10ZiV+Uu2JP
         RrQSnzYZaUOqLAPxuxa+STqeInT1+ICcy24h/IgJ17QJq/3Icb3462g0pWZfVWe9ocEK
         Tlpw==
X-Gm-Message-State: AOAM532KWolilgtzHGny2Aslc0mCEM8YSZPZNh0YSDDNWJpfRJXQGjEj
        p3VQ88h1UzQW2y75eFSfN5s9adNrquPKbdBro5HfsQ==
X-Google-Smtp-Source: ABdhPJx+tOwjlffUewKU7LH+Lg7DoUElb6ZmnMQSHW5X4TwlUCJsauTKH8hgl+YwJkP9eWPnGz943s+1JJ1TtUa+kK4=
X-Received: by 2002:ac8:4159:: with SMTP id e25mr25664193qtm.69.1635263201845;
 Tue, 26 Oct 2021 08:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com> <20211011155636.2666408-2-sdf@google.com>
 <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch> <CAKH8qBuR4bYn1POgu0TF428vApknvMNPAng5qMuiKXCpcg8CQQ@mail.gmail.com>
 <CAEf4BzaUFAVZz2PHePbF4ypBHusUJEZi5W9HL0gT_fy1T71itg@mail.gmail.com>
In-Reply-To: <CAEf4BzaUFAVZz2PHePbF4ypBHusUJEZi5W9HL0gT_fy1T71itg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 26 Oct 2021 08:46:30 -0700
Message-ID: <CAKH8qBt3_qpCLjviMr86EixBx+pVG5E4+ZZeHZpwO6G6wnrR+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 9:27 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Oct 25, 2021 at 8:59 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Fri, Oct 22, 2021 at 10:05 AM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Stanislav Fomichev wrote:
> > > > Otherwise, attaching with bpftool doesn't work with strict section names.
> > > >
> > > > Also, switch to libbpf strict mode to use the latest conventions
> > > > (note, I don't think we have any cli api guarantees?).
> > > >
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  tools/bpf/bpftool/main.c |  4 ++++
> > > >  tools/bpf/bpftool/prog.c | 15 +--------------
> > > >  2 files changed, 5 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > > > index 02eaaf065f65..8223bac1e401 100644
> > > > --- a/tools/bpf/bpftool/main.c
> > > > +++ b/tools/bpf/bpftool/main.c
> > > > @@ -409,6 +409,10 @@ int main(int argc, char **argv)
> > > >       block_mount = false;
> > > >       bin_name = argv[0];
> > > >
> > > > +     ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> > > > +     if (ret)
> > > > +             p_err("failed to enable libbpf strict mode: %d", ret);
> > > > +
> > >
> > > Would it better to just warn? Seems like this shouldn't be fatal from
> > > bpftool side?
> > >
> > > Also this is a potentially breaking change correct? Programs that _did_
> > > work in the unstrict might suddently fail in the strict mode? If this
> > > is the case whats the versioning plan? We don't want to leak these
> > > type of changes across multiple versions, idealy we have a hard
> > > break and bump the version.
> > >
> > > I didn't catch a cover letter on the series. A small
> > > note about versioning and upgrading bpftool would be helpful.
> >
> > Yeah, it is a breaking change, every program that has non-strict
> > section names will be rejected.
> >
> > I mentioned that in the bpftool's commit description:
> > Also, switch to libbpf strict mode to use the latest conventions
> > (note, I don't think we have any cli api guarantees?).
> >
> > So I'm actually not sure what's the best way to handle this migration
> > and whether we really provide any cli guarantees to the users. I was
> > always assuming that bpftool is mostly for debugging/introspection,
> > but not sure.
> >
> > As Andrii suggested in another email, I can add a flag to disable this
> > strict mode. Any better ideas?
>
> Maybe the other way around for the transition period. Add a --strict
> flag to turn on libbpf strict mode? This follows libbpf's opt-in
> approach to breaking change. We can also emit warnings when people are
> trying to pin programs and mention that they should switch to --strict
> as in some future version this will be the default. Would that be
> better for users?

Agreed, that sounds better for backwards compatibility. However, I'm
not sure when we set that --strict to 'true' by default. The same
moment libbpf loses non-strict behavior?
