Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4208159863
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfF1K2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:28:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34388 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfF1K2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:28:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so5737797wrl.1
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 03:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=00lQgp4KF8mWHCT3vLiiTY3cz1BNXZmrWPRpQYCYepQ=;
        b=WvtXk5cgkogFhun+ZiE8ghcPR+1UCyc/a3gnHHaDJ2OoARpA7j7GPvZHcTvAvmoldN
         7hZrC4XrFmRcPKeHZUeA/lmAI58KJnTJg5dxqgjmWnUH44QobZ38qiH1ciDZFGssNwR8
         d2JbM5WtRmJIFjsWjE1y0ztGJf2D6lMaWXL5rmTrVO4N5b5BlsWCnkdR/Yeeie7MFKKR
         oEQJTJarOPlUcveHA29/+uI+yKuU1azZPdnQt3pJPNE+tbWR51D8JMJzOmBfVWL0CltH
         UTrCoRZrxz7b9gaY3Su9TFQ1pNF7Weh0YQPLrbh6Y+fJRKb5TFYWajaQPELLKQt66mxe
         IisA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=00lQgp4KF8mWHCT3vLiiTY3cz1BNXZmrWPRpQYCYepQ=;
        b=gttL5l3wRFnZqnarVBBUtXbNkwPsXAFR5F9kj0jw1AK03fvJnbGderBaWZlozE6tNP
         +TN8YK3bjiOAO5WYcXcRePdBv6TBRx7fEonHYgDZCPl5R+HU2ezYUBmN24QLQeO/BAp0
         ZMn2TSoaYCufSM0MeU1NgHTMm5AHk/tgVX5Gn2IzyC7yNhbBhLPdptFCl+xKGMMetKBp
         1P3VjuUxlOyu30Xs/seE4bsB4Cpl8naBx/xtF0WS297QqMYArPY2qvrO8ui8KqBtRsGa
         3ypurqLlSb2DxmqWWEzTbt9j9ZgNHvc3ihEPH0VXFJLHgDQoF4DgvYFYN5b7q4oyggdM
         7q6g==
X-Gm-Message-State: APjAAAUtI0SgF/lp9T0V8/ZUZ7eP1zC5IKVYoUYTRB1y48Drm7AOrPSJ
        MhJBO335FlMH9wkK3frF+mUPLg==
X-Google-Smtp-Source: APXvYqwceU7uOJWFzAL991B1wKGjN7mDumVTVPUijIsToU5QF3dnh/WIfSHQjHGLcY+56bqP2MuwWg==
X-Received: by 2002:adf:fb84:: with SMTP id a4mr7863262wrr.41.1561717723814;
        Fri, 28 Jun 2019 03:28:43 -0700 (PDT)
Received: from brauner.io ([212.91.227.56])
        by smtp.gmail.com with ESMTPSA id x6sm2241373wru.0.2019.06.28.03.28.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 03:28:43 -0700 (PDT)
Date:   Fri, 28 Jun 2019 12:28:42 +0200
From:   Christian Brauner <christian@brauner.io>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>, lmb@cloudflare.com,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>, casey@schaufler-ca.com,
        sds@tycho.nsa.gov, linux-security@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190628102841.dye2ajyusukvwlwq@brauner.io>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <CALCETrUp3Tj062wG-noNdsY-sU9gsob_kVK=W_DxWciMpZFvyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUp3Tj062wG-noNdsY-sU9gsob_kVK=W_DxWciMpZFvyA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 04:42:18PM -0700, Andy Lutomirski wrote:
> [sigh, I finally set up lore nntp, and I goofed some addresses.  Hi
> Kees and linux-api.]

Love it or hate it but that should probably also Cc linux-security...

> 
> On Thu, Jun 27, 2019 at 4:40 PM Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On 6/27/19 1:19 PM, Song Liu wrote:
> > > This patch introduce unprivileged BPF access. The access control is
> > > achieved via device /dev/bpf. Users with write access to /dev/bpf are able
> > > to call sys_bpf().
> > >
> > > Two ioctl command are added to /dev/bpf:
> > >
> > > The two commands enable/disable permission to call sys_bpf() for current
> > > task. This permission is noted by bpf_permitted in task_struct. This
> > > permission is inherited during clone(CLONE_THREAD).
> > >
> > > Helper function bpf_capable() is added to check whether the task has got
> > > permission via /dev/bpf.
> > >
> >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 0e079b2298f8..79dc4d641cf3 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
> > >               env->insn_aux_data[i].orig_idx = i;
> > >       env->prog = *prog;
> > >       env->ops = bpf_verifier_ops[env->prog->type];
> > > -     is_priv = capable(CAP_SYS_ADMIN);
> > > +     is_priv = bpf_capable(CAP_SYS_ADMIN);
> >
> > Huh?  This isn't a hardening measure -- the "is_priv" verifier mode
> > allows straight-up leaks of private kernel state to user mode.
> >
> > (For that matter, the pending lockdown stuff should possibly consider
> > this a "confidentiality" issue.)
> >
> >
> > I have a bigger issue with this patch, though: it's a really awkward way
> > to pretend to have capabilities.  For bpf, it seems like you could make
> > this be a *real* capability without too much pain since there's only one
> > syscall there.  Just find a way to pass an fd to /dev/bpf into the
> > syscall.  If this means you need a new bpf_with_cap() syscall that takes
> > an extra argument, so be it.  The old bpf() syscall can just translate
> > to bpf_with_cap(..., -1).
> >
> > For a while, I've considered a scheme I call "implicit rights".  There
> > would be a directory in /dev called /dev/implicit_rights.  This would
> > either be part of devtmpfs or a whole new filesystem -- it would *not*
> > be any other filesystem.  The contents would be files that can't be read
> > or written and exist only in memory.  You create them with a privileged
> > syscall.  Certain actions that are sensitive but not at the level of
> > CAP_SYS_ADMIN (use of large-attack-surface bpf stuff, creation of user
> > namespaces, profiling the kernel, etc) could require an "implicit
> > right".  When you do them, if you don't have CAP_SYS_ADMIN, the kernel
> > would do a path walk for, say, /dev/implicit_rights/bpf and, if the
> > object exists, can be opened, and actually refers to the "bpf" rights
> > object, then the action is allowed.  Otherwise it's denied.
> >
> > This is extensible, and it doesn't require the rather ugly per-task
> > state of whether it's enabled.
> >
> > For things like creation of user namespaces, there's an existing API,
> > and the default is that it works without privilege.  Switching it to an
> > implicit right has the benefit of not requiring code changes to programs
> > that already work as non-root.
> >
> > But, for BPF in particular, this type of compatibility issue doesn't
> > exist now.  You already can't use most eBPF functionality without
> > privilege.  New bpf-using programs meant to run without privilege are
> > *new*, so they can use a new improved API.  So, rather than adding this
> > obnoxious ioctl, just make the API explicit, please.
> >
> > Also, please cc: linux-abi next time.
