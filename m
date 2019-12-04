Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5CF811219C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 03:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfLDCxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 21:53:30 -0500
Received: from mail-lf1-f52.google.com ([209.85.167.52]:40466 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfLDCxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 21:53:30 -0500
Received: by mail-lf1-f52.google.com with SMTP id y5so4811553lfy.7
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 18:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uR+pT65soPzjqJ67S48glzTfhGJEKMDDLWprJm5r4mY=;
        b=aI4SDOI62/pPrhGCaEj1/ngReuOGp6v0q67iB7ucEval3f3gGBEC8Dwizix4mEsV65
         N+tG1o/mmvoQZf+pi2hrlpgY0lPat20YwANxIleHDULtynaUMm1rZjbVYDgr0dy14c7T
         6AblvCluhJtUHCGaa/qoKfbUiNTmwF1dTPx/ovhs2d0knIpyEK7Rhwuuyqh4HKzno9e8
         tLWrxYiPt4rX06K9qnvHHcXkf2qk4LpK2fIIEycQOrDRPsyLzKkSwdti5RkkJns/bNjn
         5iBjr8wbkrUGIeaqsCg0Vr7D03tyB6rOOgjJEA2dH8vRR8pZrriFZRP2nA6gMe5XOP6j
         /nzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uR+pT65soPzjqJ67S48glzTfhGJEKMDDLWprJm5r4mY=;
        b=BnDTRhfeGuNfdaDuolJpATvW8vq3tQotrd5UtyZrkchxPSSh6WYlI6DH3W42Vz24rw
         O44bAXa1YaSvc9wqZ1g4uQB0R4I+KAGUlGJPeRlMa7KQmno8twJlOQMOQCqeUlezvGUY
         acQ5Np9u6KgxhJmkIMlooeC9ihMVsG9dk6hq7E0cEkl6X4R8epRo6LaaoKEi62dwf/IJ
         fEb216PVTTkceh9hvXpmQKpOgb5GxtfxZZiMK1Ft3X3GzllPJjxpneZ3ai9pWXGPKguN
         Pfyr1dypYKb5UXgSM4JU53pBOnW5iw8I5YT/by1ah/NKU4lgUGKUQk2n+SxQCJHbz91P
         7yuw==
X-Gm-Message-State: APjAAAXVAauwEcPBicVGf2KKvnPStnu6LywaVx3wngYS52z4SkJH1afw
        2s+15HN1D+4ffIyQumP7jiOFSKBgnQL6enJFt5IM
X-Google-Smtp-Source: APXvYqxC2jCV69k21E2WvCNty27MXD7mqixisctmZLTFJfdlz1LwQeP4SH3ptOANsNEsWPDaO4sPYI3Qqt1vdi3PFGA=
X-Received: by 2002:ac2:424d:: with SMTP id m13mr619905lfl.13.1575428007737;
 Tue, 03 Dec 2019 18:53:27 -0800 (PST)
MIME-Version: 1.0
References: <20191128091633.29275-1-jolsa@kernel.org> <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
 <20191203093837.GC17468@krava>
In-Reply-To: <20191203093837.GC17468@krava>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 3 Dec 2019 21:53:16 -0500
Message-ID: <CAHC9VhRhMhsRPj1D2TY3O=Nc6Rx9=o1-Z5ZMjrCepfFY6VtdbQ@mail.gmail.com>
Subject: Re: [RFC] bpf: Emit audit messages upon successful prog load and unload
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 4:38 AM Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Dec 02, 2019 at 06:00:14PM -0500, Paul Moore wrote:
> > On Thu, Nov 28, 2019 at 4:16 AM Jiri Olsa <jolsa@kernel.org> wrote:

...

> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -23,6 +23,7 @@
> > >  #include <linux/timekeeping.h>
> > >  #include <linux/ctype.h>
> > >  #include <linux/nospec.h>
> > > +#include <linux/audit.h>
> > >  #include <uapi/linux/btf.h>
> > >
> > >  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> > > @@ -1306,6 +1307,30 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
> > >         return 0;
> > >  }
> > >
> > > +enum bpf_audit {
> > > +       BPF_AUDIT_LOAD,
> > > +       BPF_AUDIT_UNLOAD,
> > > +};
> > > +
> > > +static const char * const bpf_audit_str[] = {
> > > +       [BPF_AUDIT_LOAD]   = "LOAD",
> > > +       [BPF_AUDIT_UNLOAD] = "UNLOAD",
> > > +};
> > > +
> > > +static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit op)
> > > +{
> > > +       struct audit_buffer *ab;
> > > +
> > > +       if (audit_enabled == AUDIT_OFF)
> > > +               return;
> >
> > I think you would probably also want to check the results of
> > audit_dummy_context() here as well, see all the various audit_XXX()
> > functions in include/linux/audit.h as an example.  You'll see a
> > pattern similar to the following:
> >
> > static inline void audit_foo(...)
> > {
> >   if (unlikely(!audit_dummy_context()))
> >     __audit_foo(...)
> > }
>
> bpf_audit_prog might be called outside of syscall context for UNLOAD event,
> so that would prevent it from being stored

Okay, right.  More on this below ...

> I can see audit_log_start checks on value of audit_context() that we pass in,

The check in audit_log_start() is for a different reason; it checks
the passed context to see if it should associate the record with
others in the same event, e.g. PATH records associated with the
matching SYSCALL record.  This way all the associated records show up
as part of the same event (as defined by the audit timestamp).

> should we check for audit_dummy_context just for load event? like:
>
>
> static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit op)
> {
>         struct audit_buffer *ab;
>
>         if (audit_enabled == AUDIT_OFF)
>                 return;
>         if (op == BPF_AUDIT_LOAD && audit_dummy_context())
>                 return;
>         ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
>         if (unlikely(!ab))
>                 return;
>         ...
> }

Ignoring the dummy context for a minute, there is likely a larger
issue here with using audit_context() when bpf_audit_prog() is called
outside of a syscall, e.g. BPF_AUDIT_UNLOAD.  In this case we likely
shouldn't be taking the audit context from the current task, we
shouldn't be taking it from anywhere, it should be NULL.

As far as the dummy context is concerned, you might want to skip the
dummy context check since you can only do that on the LOAD side, which
means that depending on the system's configuration you could end up
with a number of unbalanced LOAD/UNLOAD events.  The downside is that
you are always going to get the BPF audit records on systemd based
systems, since they ignore the admin's audit configuration and always
enable audit (yes, we've tried to get systemd to change, they don't
seem to care).

-- 
paul moore
www.paul-moore.com
