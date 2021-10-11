Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F9A428702
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhJKGsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbhJKGsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 02:48:36 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8C7C061570;
        Sun, 10 Oct 2021 23:46:36 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id s64so36559615yba.11;
        Sun, 10 Oct 2021 23:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u2RXKo8mX6oo10DEsmNP5BEDBLL8MQItPDHRAJ9bFrc=;
        b=LUSbRSKpYRawF8I5pFm0PgvSWuxTjogU7W+TdUjJ+hYKbWT9/VH8c+w0+ix4w0IPwd
         IKFnCi8lyzBNgW09ksw+fWqIiMID0eru9kMEGx24yKggMJZ3utvotb54jULx6k9r5dz/
         xP1mztWtMAmdpwmiRbdOnB/2hAi7NzV4MZn92Iv9q/8xaTNeZGpPNzYYaiCFd/FjJZik
         7NAVuotnPFCTpyLt0b1nb1vFLV2+AK69CyNVOIesB4J4qdmVNHoUPW7iXESPX3acm3bS
         OvHuEx6K19iMge4zwtBLVSQy6UBfxI4e1UkW5j+4sdDJbe+xXz+vFoG86g28jBYrGVhF
         +vuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2RXKo8mX6oo10DEsmNP5BEDBLL8MQItPDHRAJ9bFrc=;
        b=2NKk5mmnfCvOUdtREidhNCcvh9XdvrzS5SmtrwtDCy8QGXXaG1iul74plYYJTyUarw
         2DQbOcosuV5CjKHb56lFoPtYDSjgJwLil2OKgxpl3bhwzVdpC0U+98JykdxdHQ5cFLK4
         HRpIw7DXBSMnKOvuHbnVqgpyapNT30KOFVEeyj/VIw7A7TZaHpFu5FpEnf6TZWY8N50o
         obAWycXSbjW6K1/E4mwOZwO4jnIlkP1rR+VqFDWqS46Xld2eIIUcHgU6ZbXuafMWdhhN
         vJ5xT/K8n2vBy87KKCtbfWScEW7wx45DfGkr0LiHsbdRPL9/w6iNkNOVUj6rTGjbU6xj
         ujlA==
X-Gm-Message-State: AOAM532S3TyEkxb3JK4BQ8In6C9T+praqe9K7dhoYL9sLs+Q1kEdtcJ1
        RyVztAIQgafqnYsEfJhEPwFygAwq9peyiNhcnN8=
X-Google-Smtp-Source: ABdhPJzs7YJ3fxKdUlO2Jl3N9PPvceWpglLFUCZe5Fzgrs8SVMJ8MUNhQFLoAG0QZx/zRDBjekRcO/cIccyhaNcGQbs=
X-Received: by 2002:a25:e7d7:: with SMTP id e206mr18920168ybh.267.1633934795901;
 Sun, 10 Oct 2021 23:46:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211007194438.34443-1-quentin@isovalent.com> <CAEf4BzZd0FA6yX4WzK6GZFW2VbBgEJ=oJ=f4GzkapCkbAGUNrA@mail.gmail.com>
 <CACdoK4KaaV_OZJdUz30VyQYyJNeseV=7LX+akeeXpFhQe6Zh6w@mail.gmail.com>
In-Reply-To: <CACdoK4KaaV_OZJdUz30VyQYyJNeseV=7LX+akeeXpFhQe6Zh6w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Oct 2021 08:46:24 +0200
Message-ID: <CAEf4Bzaq1CdyhCJFDBF6+6u59h+=zD7on5h_dEiOCLNwDwBK5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/12] install libbpf headers when using the library
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 11:03 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Fri, 8 Oct 2021 at 20:13, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > Tons of ungrateful work, thank you! Applied to bpf-next.
> >
> > I did a few clean ups (from my POV), see comments on relevant patches.
>
> Thanks for that. I don't mind the clean ups. There are several of them
> I considered before sending but wasn't sure about, so it's a good
> thing that you did it :).
>
> > Also in a bunch of Makefiles I've moved `| $(LIBBPF_OUTPUT)` to the
> > same line if the line wasn't overly long. 80 characters is not a law,
> > and I preferred single-line Makefile target definitions, if possible.
>
> No particular preference on my side, so OK.
>
> >
> > There is one problem in bpftool's Makefile, but it works with a
> > limited case of single file today. Please follow up with a proper fix.
>
> Right, good catch. I'm sending the fix.

thanks

>
> >
> > Btw, running make in bpftool's directory, I'm getting:
> >
> > make[1]: Entering directory '/data/users/andriin/linux/tools/lib/bpf'
> > make[1]: Entering directory '/data/users/andriin/linux/tools/lib/bpf'
> > make[1]: Nothing to be done for 'install_headers'.
> > make[1]: Leaving directory '/data/users/andriin/linux/tools/lib/bpf'
> > make[1]: Leaving directory '/data/users/andriin/linux/tools/lib/bpf'
> >
> > Not sure how useful those are, might be better to disable that.
>
> I had a look for bpftool, this is because we always descend into
> libbpf's directory (FORCE target). Removing this FORCE target as I did
> in samples/bpf/ avoids the descent and clears the output. I'll send a
> patch.

There is a way to prevent make from logging these enter/leave
messages, which will solve a similar problem discussed below.

>
> >
> > When running libbpf's make, we constantly getting this annoying warning:
> >
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/netlink.h'
> > differs from latest version at 'include/uapi/linux/netlink.h'
> > Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h'
> > differs from latest version at 'include/uapi/linux/if_link.h'
> >
> > If you will get a chance, maybe you can get rid of that as well? I
> > don't think we need to stay up to date with netlink.h and if_link.h,
> > so this seems like just a noise.
>
> I can look into that. Are you sure you want the warnings removed? Or
> would it be cleaner to simply update the headers?

Yeah, let's remove checks for those headers. We don't need to keep
them up to date, if there will be new features we need to use from
libbpf, we can update, if it's not already up-to-date.

>
> >
> > There was also
> >
> > make[4]: Nothing to be done for 'install_headers'.
> >
> > when building the kernel. It probably is coming from either
> > bpf_preload or iterators, but maybe also resolve_btfids, I didn't try
> > to narrow this down. Also seems like a noise, tbh. There are similar
> > useless notifications when building selftests/bpf. If it doesn't take
> > too much time to clean all that up, I'd greatly appreciate that!
>
> I haven't looked into it yet, but I can do as a follow-up. I'll post
> the patches for bpftool first because I prefer to submit the fix for
> bpftool's Makefile as soon as possible, and will look at this next.

sure. See also above about just silencing these somewhat useless
messages (it's some make variable or something like that, don't
remember)

>
> Thanks,
> Quentin
