Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285EF34B988
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 22:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhC0V2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 17:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhC0V2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 17:28:18 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FB9C0613B1;
        Sat, 27 Mar 2021 14:28:18 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 15so11531618ljj.0;
        Sat, 27 Mar 2021 14:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbwjNu2FkrJEP3d0O7KcMEasRB5V0VGOjN0+MS4lkVg=;
        b=ZlTRsxbP2YvzUM6TeTgSHLx/joOHuY6AaS9S0RfdOOTrasgAateAF38el0/LvQDpcB
         77d78UbKUZztlg3rQmjngpTh6WjzTvTW0p3e4hMKraxm3fo+9wYVP1x8MZ/ezSJYs8WK
         yHwlTh3N64eAJc1qGlVR9pJ1LXhOHnJahZ0XK3QlpjpPTKRMjcliVqYCzpXHaX1D/ECk
         KfhKNxi7EGfyAJkcp8KQhj3u4slrNskgr1dT370ExVq+ygK8jNYNfu8AutIKjYk2JW80
         eYXBRbmVcs5AAnQJkOJPAAd/kOPvlbR3CzO/MuM3l7ehSyLw12+ceRcHbehHytw+C5FO
         gCfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbwjNu2FkrJEP3d0O7KcMEasRB5V0VGOjN0+MS4lkVg=;
        b=f+qRBsTzb/knsy0KI5/dp/qz5hpc/snjI67gdS3+HlE11stgtdEIRhqXc/Ptg44aDK
         wK8EWiDXc/y4ZPhKCmCvnC8RM062hW1yTGaRxZ3bv8MgQctHAkNHsQbVFDAsyWX9J9Fv
         TcydYcsMv96Y1WrQo9+xGgLUM8Y1cJRPyzuKB2JJ1uXKc4i6u6WJDHaI8aSxQPH5V2JC
         I28SJIQ4q4n79dhemCMtJIdCETIx2p90AT4HIFe9Rro6BZ2d6ihOOK0WS0rCPoHi9oOa
         UGKOQUfeQEaKc2s5cfp6MWIJDk7fs9FJ1yucCz4caxn7xvu1dTPzL5GgXIR2tbTBs39P
         Ip9A==
X-Gm-Message-State: AOAM532Mth8YGGO+/jCpgnfz5Groueav7wgWkRGCfr4eouFP+RfZcKjb
        rhTZ7Nj/OXGjYKC9cLHnSRCiDhiHnbWvSPmFfVCliowQ
X-Google-Smtp-Source: ABdhPJwjRZ1Dn5/1HEfq3g7v7vEtCIxW31I40BtdlGYOKkDB/2oOXWMehXV1Xrd6ZbJiGOOXKz2lw0WrE7mmP7lT+TI=
X-Received: by 2002:a2e:9198:: with SMTP id f24mr12647337ljg.32.1616880497030;
 Sat, 27 Mar 2021 14:28:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210325015124.1543397-1-kafai@fb.com> <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
In-Reply-To: <CAM_iQpWGn000YOmF2x6Cm0FqCOSq0yUjc_+Up+Ek3r6NrBW3mw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 27 Mar 2021 14:28:05 -0700
Message-ID: <CAADnVQKAXsEzsEkxhUG=79V+gAJbv=-Wuh_oJngjs54g1xGW7Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 00/14] bpf: Support calling kernel function
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 2:25 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Hi,
>
> On Wed, Mar 24, 2021 at 8:40 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > Martin KaFai Lau (14):
> >   bpf: Simplify freeing logic in linfo and jited_linfo
> >   bpf: Refactor btf_check_func_arg_match
> >   bpf: Support bpf program calling kernel function
> >   bpf: Support kernel function call in x86-32
> >   tcp: Rename bictcp function prefix to cubictcp
> >   bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
>
> I got the following link error which is likely caused by one of your
> patches in this series.
>
> FAILED unresolved symbol cubictcp_state
> make: *** [Makefile:1199: vmlinux] Error 255

I don't see it and bpf CI doesn't see it either.
Without steps to reproduce your observation isn't helpful.
