Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD822431FB
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 03:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMBUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 21:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHMBUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 21:20:36 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8354FC061383;
        Wed, 12 Aug 2020 18:20:35 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 140so2163484lfi.5;
        Wed, 12 Aug 2020 18:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ND7V86I1T+9Op2pIjnWTmRoM0I9JCJHGVNtwjc1briA=;
        b=YzHrwpgUZZ9wVoEsl7Bwx/ikJPGHd0l2TNLh/+837gQfKtgfAkVe2lBCftsqPybhFE
         uFWbIPBkkPaRMcjoVwNLAGi6rvIWzrJt7ue6etbB3Jc/kke+iODTl2/S9xnwp5R1ycM4
         Ideceih3FGi5F6XIJlFYSSeBp6Se8Om9TsSX8ual33Kf1/qTBy16VvU49IMTkn03cAqN
         OmsO58cWauXFlC/akzEr5EPg/Bkuu7C0jwHGSnwupLVmFfX0AOxfCbNIYRrTQwEsPFjs
         uzVVb8wS/SibWjkKVZX3b2mPyFjDT+cOcE3T6kqzVI2/WHH9mcT3xASh9itZOy3ZwEwf
         kjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ND7V86I1T+9Op2pIjnWTmRoM0I9JCJHGVNtwjc1briA=;
        b=ZObZG+auJiwC934hRVNp2NkLNWxv3F5KjTOD4cDO4XHsfmdFsmwJOkZsCDxeSRFJE/
         55U0lE33lYcVbGlk1xJ3Rr4vQWhOHjtOP8FZRPdGTNDxAXfZ6T42WCTLBRMEeiY7f1Xu
         rwbLFFOoRqHJ1cgCpUGAIFrDNRRe4n1CA3qgz3DFUleDiunhH6LnC7RQxyw1dIOBCkha
         GdKWscEw6rnXvF6O8DOUgjE8xykppD8lELQwPR4yLSPu3lVasi48wHtMIXX4YJ7QKj8u
         DZvn5wlasnL5w9g+/T63zSyTgdB4GfZCgOpyQukZ76v0snCI+s0bCU4JEUEvdIOVqCve
         Frkw==
X-Gm-Message-State: AOAM533brB+B2Im35SuS716UePG0LdgK4Yf+tsuCU4AMVWGlma5jyFYF
        eiEBN4ao+YScfiHfJOE5zKdwoSUNqvvHrspLtQg=
X-Google-Smtp-Source: ABdhPJy8NP5T4oX4PJTvbnhHkvhZjwCM0XI9dAT+xTWKofiQCkOTVV7+M3TLEm82siZ65koNa1RfSLFt++kRlxWNwKc=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr978605lfs.8.1597281633677;
 Wed, 12 Aug 2020 18:20:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200812123102.20032-1-jolsa@kernel.org> <5238E896-6A88-4857-B8D4-3C2E8C4E9F2C@fb.com>
In-Reply-To: <5238E896-6A88-4857-B8D4-3C2E8C4E9F2C@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Aug 2020 18:20:22 -0700
Message-ID: <CAADnVQL08gA=N1qM4Zv-fbfzjn7Y=qRGCe+g0RjkhDfJmCEPRg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Iterate through all PT_NOTE sections
 when looking for build id
To:     Song Liu <songliubraving@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 8:27 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Aug 12, 2020, at 5:31 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Currently when we look for build id within bpf_get_stackid helper
> > call, we check the first NOTE section and we fail if build id is
> > not there.
> >
> > However on some system (Fedora) there can be multiple NOTE sections
> > in binaries and build id data is not always the first one, like:
> >
> >  $ readelf -a /usr/bin/ls
> >  ...
> >  [ 2] .note.gnu.propert NOTE             0000000000000338  00000338
> >       0000000000000020  0000000000000000   A       0     0     8358
> >  [ 3] .note.gnu.build-i NOTE             0000000000000358  00000358
> >       0000000000000024  0000000000000000   A       0     0     437c
> >  [ 4] .note.ABI-tag     NOTE             000000000000037c  0000037c
> >  ...
> >
> > So the stack_map_get_build_id function will fail on build id retrieval
> > and fallback to BPF_STACK_BUILD_ID_IP.
> >
> > This patch is changing the stack_map_get_build_id code to iterate
> > through all the NOTE sections and try to get build id data from
> > each of them.
> >
> > When tracing on sched_switch tracepoint that does bpf_get_stackid
> > helper call kernel build, I can see about 60% increase of successful
> > build id retrieval. The rest seems fails on -EFAULT.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> LGTM. Thanks for the fix!
>
> Acked-by: Song Liu <songliubraving@fb.com>

It's a good fix.
Applied to bpf tree. Thanks
