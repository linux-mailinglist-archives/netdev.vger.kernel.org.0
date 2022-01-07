Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F58486E99
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343949AbiAGAUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343531AbiAGAUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:20:17 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965EBC061245;
        Thu,  6 Jan 2022 16:20:17 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p14so3636625plf.3;
        Thu, 06 Jan 2022 16:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fj9kX4cP4lXIzAUcHvTSQq+2gUiSFponYUkO/x8lnjw=;
        b=UnE0aozBfaeQomCHtjaN7v7Yx2D4xqEwHcCYiqp4MT44aEusmUxKsmm9iPLyEKJJmW
         6/jp4Kzvmu7ZiijqFGhrPSeNU4KlsgPp0MOpEDe3r7U9QJ7XfMZGJ4AbR3Au0VNqTWs/
         IchQHJY5m8vFvavDJ/9PNNyiSxxUmb/aJJWeHUO/SpKjCTadpF+Lt1hMUqLcbgGSOj1R
         jhx6U5mFE+8gis4mWuTTRFZltykwD0bB5ZuTELqW2w3vNNlOzaOYMCUzX8lyjAQpFC02
         OCQOhF56cplnkWp+9G+ZvWdBNPknYCdDOGQRjSi9jAxwAG+IIpu5VHR19GHNJImJXm6k
         5Xsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fj9kX4cP4lXIzAUcHvTSQq+2gUiSFponYUkO/x8lnjw=;
        b=dUeOW8yxPZb1MuyI0uQ7V5YEIdbujs7/dQoj8oeFKX0bt7PTZnSDc34Z8YJoYXPH02
         Pww/bBhGziJl4IqWGseX66JDh38EVDzenDrzLze0yMF+kIpVSavT5wEm5Xt+HtIorDbo
         QIRsGlUWMnsb0whvThkR3Vtkd074B6b2WE//F9pP96cHGJvLPpmezMdvqbumLXVsvKMz
         VUh99wzBA0jWZkM2O1Cfbc4uEYdUO2Ut+Jrt27R8f8l+NphHAtJQPd3C56P+Kg43Y4eU
         TRyLgcVo5t6lifG14gBMBtehk4c+TfrhEiHZq7Y8UU5EIt6rEgZqmCNysoI97pn3Sray
         4DtQ==
X-Gm-Message-State: AOAM531lzG6AzQ5j9Ohp7PcRtCY9Hc4ELU5puEHUrqHYlujz/baTX/ZK
        4WAx/Y13dRspITxsTqectpr/sR50ZB4OgN7w5qU=
X-Google-Smtp-Source: ABdhPJxbzLuwc2Ntd3uq6VipTXN3kSaA9q1s0yI8P2Jbc2VnoX2P1Ts//npiixSjvow9S7wGphrDiFUAdRbn7qz4Z0w=
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr12797709pjz.122.1641514817074;
 Thu, 06 Jan 2022 16:20:17 -0800 (PST)
MIME-Version: 1.0
References: <20220104080943.113249-1-jolsa@kernel.org> <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
 <YdaoTuWjEeT33Zzm@krava> <20220106225943.87701fcc674202dc3e172289@kernel.org>
 <CAADnVQLjjcsckQVqaSB8ODB4FKdVUt-PB9xyJ3FAa2GWGLbHgA@mail.gmail.com> <20220107085203.14f9c06e0537ea6b00779842@kernel.org>
In-Reply-To: <20220107085203.14f9c06e0537ea6b00779842@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 16:20:05 -0800
Message-ID: <CAADnVQ+mZxxm=96pQ4ekV3rbjV=svPOKg3TG+K0396g+iMjTbA@mail.gmail.com>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 3:52 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> On Thu, 6 Jan 2022 09:40:17 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > On Thu, Jan 6, 2022 at 5:59 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > >
> > > That seems to bind your mind. The program type is just a programing
> > > 'model' of the bpf. You can choose the best implementation to provide
> > > equal functionality. 'kprobe' in bpf is just a name that you call some
> > > instrumentations which can probe kernel code.
> >
> > No. We're not going to call it "fprobe" or any other name.
> > From bpf user's pov it's going to be "multi attach kprobe",
> > because this is how everyone got to know kprobes.
> > The 99% usage is at the beginning of the funcs.
> > When users say "kprobe" they don't care how kernel attaches it.
> > The func entry limitation for "multi attach kprobe" is a no-brainer.
>
> Agreed. I think I might mislead you. From the bpf user pov, it always be
> shown as 'multi attached kprobes (but only for the function entry)'
> the 'fprobe' is kernel internal API name.
>
> > And we need both "multi attach kprobe" and "multi attach kretprobe"
> > at the same time. It's no go to implement one first and the other
> > some time later.
>
> You can provide the interface to user space, but the kernel implementation
> is optimized step by step. We can start it with using real multiple
> kretprobes, and then, switch to 'fprobe' after integrating fgraph
> callback. :)

Sounds good to me.
My point was that users often want to say:
"profile speed of all foo* functions".
To perform such a command a tracer would need to
attach kprobes and kretprobes to all such functions.
The speed of attach/detach has to be fast.
Currently tracers artificially limit the regex just because
attach/detach is so slow that the user will likely Ctrl-C
instead of waiting for many seconds.
